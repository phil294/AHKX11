require "./ahk-string"
require "./thread"
require "./timer"

module Run
	# can start a completely fresh and isolated ahk execution instance with its own
	# variables etc. All properties can and will be heavily accessed from outside (commands).
	class Runner
		@user_vars = {
			"a_space" => " "
		}
		@escape_char = '`'
		protected getter labels : Hash(String, Cmd)
		@threads = [] of Thread
		@auto_execute_thread : Thread?
		@interrupt = Channel(Nil).new
		@exit_code = 0
		@timers = {} of String => Timer

		def initialize(@labels, auto_execute_section : Cmd, @escape_char) # todo force positional params with ** ?
			@auto_execute_thread = spawn_thread auto_execute_section, 0
		end

		# add to the thread queue and start if it isn't running already
		protected def spawn_thread(cmd, priority) : Thread
			thread = Thread.new(self, cmd, priority)
			@threads << thread
			if @threads.size > 1
				@interrupt.send(nil)
			else
				spawn clock
			end
			thread
		end

		# there must only be one
		private def clock
			while thread = @threads.last?
				select
				when @interrupt.receive
					# current command may finish in the background, but its result handling and thread continuation
					# will have to wait: probably because another, more important thread came along which will now
					# get attention in the next iteration
				when exit_code = thread.next.receive?
					if ! exit_code.nil?
						@exit_code = exit_code
						@threads.pop
						if thread == @auto_execute_thread
							::exit @exit_code
						end
					end
				end
			end
		end

		def get_var(var)
			@user_vars[var.downcase]? || ""
		end
		def set_var(var, value)
			@user_vars[var.downcase] = value
		end
		def print_vars
			puts @user_vars
		end
		
		def str(str)
			AhkString.process(str, @escape_char) do |varname_lookup|
				get_var(varname_lookup)
			end
		end

		def get_timer(label)
			@timers[label]?
		end
		def add_timer(label, period, priority)
			cmd = labels[label]?
            raise RuntimeException.new "timer: label '#{label}' not found" if ! cmd
			timer = Timer.new(self, cmd, period, priority)
			@timers[label] = timer
			timer
		end
	end
end