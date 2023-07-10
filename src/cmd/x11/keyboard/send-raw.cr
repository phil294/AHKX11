# SendRaw, Keys
class Cmd::X11::Keyboard::SendRaw < Cmd::Base
	def self.min_args; 1 end
	def self.max_args; 1 end
	def run(thread, args)
		txt = args[0]
		thread.runner.display.pause do # to prevent hotkey from triggering other hotkey or itself
			thread.runner.display.x_do.clear_active_modifiers thread.runner.display.x_do.active_modifiers
			if (hotkey = thread.hotkey) && hotkey.key_name.size == 1 && txt.includes?(hotkey.key_name)
				# TODO: duplicate code as in send.cr
				key_map_hotkey_up = XDo::LibXDo::Charcodemap.new
				key_map_hotkey_up.code = hotkey.keycode
				thread.runner.display.x_do.keys_raw [key_map_hotkey_up], pressed: false, delay: 0
			end
			thread.runner.display.x_do.type txt
		end
	end
end