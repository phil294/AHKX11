# require "malloc_pthread_shim"
require "gobject/gtk"
require "base64"

module Run
	# Please note that all GUI logic needs to happen on the same worker thread where `run` was called
	# because anything else can result in undefined behavior (in fact, it just doesn't work).
	# That's why all GUI commands need to somehow pass through `Gui.act`.
	class Gui
		def run
			_argc = 0
			# taken from "gobject/gtk/autorun". There's probably a better way.
			LibGtk.init pointerof(_argc), Pointer(UInt8**).new(0)
			LibGtk.main # blocking!
		end

		# For running Gtk code on the Gtk worker thread (`idle_add` tells GTK to run
		# the `block` in its free time),
		# so perfect for Gui modifications, new window requests etc.
		def act(&block)
			channel = Channel(Exception?).new
			GLib.idle_add do
				begin
					block.call
				rescue e
					channel.send(e)
					next false
				end
				channel.send(nil)
				false
			end
			error = channel.receive
			raise RuntimeException.new error.message, error.cause if error
			nil
		end

		@@default_title = ARGV[0]? || PROGRAM_NAME

		# Only run this after `run` has started, as it depends on a running gtk main.
		# If you don't see the popup, it may be because of focus stealing prevention from the
		# window manager, please see the README.
		def msgbox(txt, *, title = @@default_title)
			channel = Channel(Nil).new
			act do
				dialog = Gtk::MessageDialog.new text: txt || "Press OK to continue.", title: title, message_type: :info, buttons: :ok, urgency_hint: true, icon: @icon_pixbuf
				dialog.on_response do |_, response_id|
					response = Gtk::ResponseType.new(response_id)
					channel.send(nil)
					dialog.destroy
				end
				dialog.show
			end
			channel.receive
		end

		@tray_menu : Gtk::Menu? = nil
		@tray : Gtk::StatusIcon? = nil
		property icon_pixbuf : GdkPixbuf::Pixbuf? = nil
		getter default_icon_pixbuf : GdkPixbuf::Pixbuf? = nil
		def bytes_to_pixbuf(bytes)
			stream = Gio::MemoryInputStream.new_from_bytes(GLib::Bytes.new(bytes))
			GdkPixbuf::Pixbuf.new_from_stream(stream, nil)
		end
		def initialize_menu(runner)
			act do
				@tray = tray = Gtk::StatusIcon.new
				@icon_pixbuf = @default_icon_pixbuf = bytes_to_pixbuf Base64.decode "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"
				tray.from_pixbuf = @icon_pixbuf

				@tray_menu = tray_menu = Gtk::Menu.new

				item_help = Gtk::MenuItem.new_with_label "Help"
				item_help.on_activate do
					begin
						Process.run "xdg-open", ["https://phil294.github.io/AHK_X11/"]
					rescue e
						STDERR.puts e # TODO:
					end
				end
				tray_menu.append item_help
				tray_menu.append Gtk::SeparatorMenuItem.new
				item_edit = Gtk::MenuItem.new_with_label "Edit this script"
				item_edit.on_activate do
					if runner.script_file
						begin
							Process.run "xdg-open", [runner.script_file.not_nil!.to_s]
						rescue e
							STDERR.puts e # TODO:
						end
					end
				end
				tray_menu.append item_edit
				tray_menu.append Gtk::SeparatorMenuItem.new
				item_exit = Gtk::MenuItem.new_with_label "Exit"
				item_exit.on_activate { runner.exit_app 0 }
				tray_menu.append item_exit
				tray_menu.append Gtk::SeparatorMenuItem.new

				tray.on_popup_menu do |icon, button, time|
					tray_menu.show_all
					tray_menu.popup(nil, nil, nil, nil, button, time)
				end
			end
		end
		def tray
			with self yield @tray.not_nil!, @tray_menu.not_nil!
		end

		class ControlInfo
			getter control : Gtk::Widget
			getter alt_submit = false
			def initialize(@control, @alt_submit)
			end
		end
		private class GuiInfo
			getter window : Gtk::Window
			getter fixed : Gtk::Fixed
			property last_widget : Gtk::Widget? = nil
			property last_x = 0
			property last_y = 0
			property padding = 0
			property last_section_x = 0
			property last_section_y = 0
			getter var_control_info = {} of String => ControlInfo
			def initialize(@window, @fixed)
			end
		end
		@guis = {} of String => GuiInfo
		# Yields (and if not yet exists, creates) the gui info referring to *gui_id*,
		# including the `window`, and passes the block on to the GTK idle thread so
		# you can run GTK code with it.
		def gui(gui_id, &block : GuiInfo -> _)
			gui_info = @guis[gui_id]?
			if ! gui_info
				act do
					window = Gtk::Window.new title: @@default_title, window_position: Gtk::WindowPosition::CENTER, icon: @icon_pixbuf
					# , border_width: 20
					fixed = Gtk::Fixed.new
					window.add fixed
					gui_info = GuiInfo.new(window, fixed)
				end
				@guis[gui_id] = gui_info.not_nil!
			end
			act do
				block.call(gui_info.not_nil!)
			end
		end
	end
end