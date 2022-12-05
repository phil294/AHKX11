class Cmd::Gtk::Gui::GuiCancel < Cmd::Base
	def self.min_args; 1 end
	def self.max_args; 1 end
	def run(thread, args)
		thread.runner.display.gui.gui(thread, args[0]) do |gui|
			gui.window.hide
		end
	end
end