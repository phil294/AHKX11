class Cmd::Gtk::Gui::GuiOption < Cmd::Base
	def self.min_args; 2 end
	def self.max_args; 2 end
	def run(thread, args)
		gui_id = args[0]
		thread.runner.display.gtk.gui(thread, gui_id) do |gui|
			thread.parse_word_options(args[1]).each do |w, i|
				case w
				when "caption" then gui.window.decorated = ! i[:minus]
				when "resize" then gui.window.resizable = ! i[:minus]
				when "maximizebox", "minimizebox"
					gui.window.type_hint = i[:minus] ?
						::Gdk::WindowTypeHint::Menu :
						::Gdk::WindowTypeHint::Normal
				when "toolwindow" then gui.window.skip_taskbar_hint = ! i[:minus]
				# FIXME: https://github.com/phil294/vimium-everywhere/issues/3
				# type_hint: ::Gdk::WindowTypeHint::Tooltip, accept_focus: false, can_focus: false
				end
			end
		end
	end
end