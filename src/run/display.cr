require "x_do"
require "./display/x11"
require "./display/hotstrings"
require "./display/hotkeys"
require "./display/pressed-keys"
require "./display/gtk"
require "./display/at-spi"

module Run
	# Groups all modules that require a running display server.
	class Display
		getter adapter : DisplayAdapter
		getter x_do : XDo
		getter gtk : Gtk
		getter hotstrings : Hotstrings
		getter hotkeys : Hotkeys
		getter pressed_keys : PressedKeys
		@runner : Runner

		def initialize(@runner)
			@adapter = X11.new
			@gtk = Gtk.new default_title: (@runner.get_global_var("a_scriptname") || "")
			@at_spi = AtSpi.new
			@x_do = XDo.new
			@hotstrings = Hotstrings.new(@runner, @runner.settings.hotstring_end_chars)
			@hotkeys = Hotkeys.new(@runner)
			@pressed_keys = PressedKeys.new(@runner)
		end

		def run(*, hotstrings, hotkeys)
			spawn do
				@adapter.run key_handler: ->handle_event(KeyCombination)
			end
			@hotstrings.run
			hotstrings.each { |h| @hotstrings.add h }
			@hotkeys.run
			hotkeys.each { |h| @hotkeys.add h }
			@pressed_keys.run
			# Cannot use normal mt `spawn` because https://github.com/crystal-lang/crystal/issues/12392
			::Thread.new do
				gtk.run # separate worker thread because gtk loop is blocking
			end
			gtk.init(@runner)
		end

		@pause_counter = 0
		@is_paused = false
		@pause_mutex = Mutex.new
		@pause_listeners = [] of Proc(Nil)
		def on_pause(&block)
			@pause_listeners << block
		end
		# multiple threads may request a pause. Display will only resume after all have called
		# `resume` again.
		# pausing event handling can be very important in `Send` scenarios to prevent hotkeys
		# from triggering themselves (or others).
		# Please note that this `display.pause` has nothing to do with `thread.pause`.
		private def pause
			@pause_counter += 1
			if ! @is_paused
				@is_paused = true
				@pause_listeners.each &.call
			end
		end
		# :ditto:
		private def resume
			@pause_counter -= 1
			if @pause_counter < 1
				@pause_counter = 0
				@is_paused = false
				@resume_listeners.each &.call
			end
		end
		# :ditto:
		def pause(&block)
			@pause_mutex.lock
			pause
			yield
			resume
			@pause_mutex.unlock
		end
		@resume_listeners = [] of Proc(Nil)
		def on_resume(&block)
			@resume_listeners << block
		end
		@suspend_listeners = [] of Proc(Nil)
		def on_suspend(&block)
			@suspend_listeners << block
		end
		getter suspended = false
		def suspend
			@suspended = true
			@suspend_listeners.each &.call
		end
		@unsuspend_listeners = [] of Proc(Nil)
		def on_unsuspend(&block)
			@unsuspend_listeners << block
		end
		def unsuspend
			@suspended = false
			@unsuspend_listeners.each &.call
		end

		private def handle_event(key_event)
			@key_listeners.each do |sub|
				spawn same_thread: true do
					sub.call(key_event, @is_paused)
				end
			end
		end
		@key_listeners = [] of Proc(KeyCombination, Bool, Nil)
		def register_key_listener(&block : KeyCombination, Bool -> _)
			@key_listeners << block
			block
		end
		def unregister_key_listener(proc)
			@key_listeners.reject! &.== proc
		end

		def at_spi(&block : AtSpi -> T) forall T
			# AtSpi stuff can fail in various ways with null pointers, (rare) crashes, timeouts etc.
			# so this is some kind of catch-all method which seems to work great
			error = nil
			5.times do |i|
				begin
					resp : T? = nil
					@gtk.act do # to make use of the GC mgm
						resp = block.call @at_spi
					end
					return resp
				rescue e
					error = e
					STDERR.puts "An internal AtSpi request failed. Retrying... (#{i+1}/5)"
					sleep 600.milliseconds
				end
			end
			STDERR.puts "AtSpi failed five times in a row. Last seen error:"
			error.not_nil!.inspect_with_backtrace(STDERR)					
			return nil
		end
	end
end