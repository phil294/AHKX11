require "./win-util"
# WinGetClass, OutputVar [, WinTitle, WinText, ExcludeTitle, ExcludeText]
class Cmd::X11::Window::WinGetClass < Cmd::Base
	def self.min_args; 1 end
	def self.max_args; 5 end
	def run(thread, args)
		match_conditions = args[1..]? || [] of ::String
		out_var = args[0]
		Util.match_win(thread, match_conditions) do |win|
			thread.runner.set_user_var(out_var, win.class_name || "")
			return
		end
		thread.runner.set_user_var(out_var, "")
	end
end