# AHK_X11

AutoHotkey for Linux. (WORK IN PROGRESS)

<div align="center">

![MsgBox](popup.png)

`MsgBox, AHK_X11` (*)
</div>

[**Direct download**](https://github.com/phil294/ahk_x11/releases/latest/download/ahk_x11.zip) (all Linux distributions, x86_64, single executable)

[**FULL DOCUMENTATION**](https://phil294.github.io/AHK_X11) (single HTML page)

[**Go to installation instructions**](#installation)

More specifically: A very basic but functional reimplementation AutoHotkey v1.0.24 (2004) for Unix-like systems with an X window system (X11), written from ground up with [Crystal](https://crystal-lang.org/)/[libxdo](https://github.com/jordansissel/xdotool)/[crystal-gobject](https://github.com/jhass/crystal-gobject)/[x11-cr](https://github.com/TamasSzekeres/x11-cr/)/[x_do.cr](https://github.com/woodruffw/x_do.cr), with the eventual goal of 80% feature parity, but most likely never full compatibility. Currently about 30% of work is done. Note that because of the old version of the spec, many modern AHK features are missing, especially expressions (`:=`, `% v`), classes, objects and functions, so you probably can't just port your scripts from Windows. Maybe this will also be added some day, but it does not have high priority for me personally. This AHK is shipped as a single executable native binary with very low resource overhead and fast execution time.

> Please also check out [Keysharp](https://bitbucket.org/mfeemster/keysharp/), a fork of [IronAHK](https://github.com/Paris/IronAHK/tree/master/IronAHK), another complete rewrite of AutoHotkey in C# that tries to be compatible with multiple OSes and support modern, v2-like AHK syntax with much more features than this one. In comparison, AHK_X11 is a lot less ambitious and more compact, and Linux only.

Features:
- [x] Hotkeys (complete)
- [x] Hotstrings (complete, but does not work *in some windows*: help needed)
- [x] Window management (setup complete, but many commands are still missing)
- [x] Send keys (complete)
- [ ] Control mouse (TBD)
- [x] File management (setup complete, but all commands are still missing)
- [x] GUIs (windows, g-labels, variables; Text, Edit, Button, Checkbox, DropDownList; Submit)
- [ ] Compile script to executable (TBD)
- [x] Scripting: labels, flow control: If/Else, Loop
- [ ] Window Spy

Besides:
- Graphical installer (optional)
- Interactive console (REPL)

AHK_X11 can be used completely without a terminal. You can however if you want use it console-only too. Graphical commands are optional, it also runs headless.

Implementation details follow below; note however that this is not very representative. For example, all `Gui` sub commands are missing. For a better overview on what is already done, skim through the [docs](https://phil294.github.io/AHK_X11).

```diff
DONE      16% (34/213):
+ Else, { ... }, Break, Continue, Return, Exit, GoSub, GoTo, IfEqual, Loop, SetEnv, Sleep, FileCopy,
+ SetTimer, WinActivate, MsgBox (incomplete), Gui, SendRaw, #Persistent, ExitApp,
+ EnvAdd, EnvSub, EnvMult, EnvDiv, ControlSendRaw, IfWinExist/IfWinNotExist, SetWorkingDir,
+ FileAppend, Hotkey, Send, ControlSend, #Hotstring, Menu

NEW       1% (2/213): (new Linux-specific commands)
@@ Echo, ahk_x11_print_vars @@

REMOVED   10% (21/213):
# ### Those that simply make no sense in Linux:
# EnvSet, EnvUpdate, PostMessage, RegDelete, RegRead, RegWrite, SendMessage, #InstallKeybdHook, 
# #InstallMouseHook, #UseHook
#
# ### "Control" commands are impossible with X11, I *think*?
# Control, ControlClick, ControlFocus, ControlGet, ControlGetFocus, 
# ControlGetPos, ControlGetText, ControlMove, ControlSetText, SetControlDelay
#
# ### Skipped for other reasons:
# AutoTrim: It's always Off. It would not differentiate between %a_space% and %some_var%.
#           It's possible but needs significant work.

TO DO     73% (155/213): alphabetically
- BlockInput, ClipWait, CoordMode, 
- DetectHiddenText, DetectHiddenWindows, Drive, DriveGet, DriveSpaceFree, Edit, 
- FileCopyDir, FileCreateDir, FileCreateShortcut, FileDelete, 
- FileInstall, FileReadLine, FileGetAttrib, FileGetShortcut, FileGetSize, FileGetTime, FileGetVersion, 
- FileMove, FileMoveDir, FileRecycle, FileRecycleEmpty, FileRemoveDir, FileSelectFile, 
- FileSelectFolder, FileSetAttrib, FileSetTime, FormatTime, GetKeyState, GroupActivate, GroupAdd, 
- GroupClose, GroupDeactivate, GuiControl, GuiControlGet, If var [not] between,
- If var [not] in/contains MatchList, If var is [not] type, IfNotEqual, IfExist/IfNotExist, 
- IfGreater/IfGreaterOrEqual, IfInString/IfNotInString, IfLess/IfLessOrEqual, IfMsgBox, 
- IfWinActive/IfWinNotActive, IniDelete, IniRead, IniWrite, Input, 
- InputBox, KeyHistory, KeyWait, ListHotkeys, ListLines, ListVars, Loop (files & folders),
- Loop (parse a string), Loop (read file contents), Loop (registry), MouseClick, 
- MouseClickDrag, MouseGetPos, MouseMove, OnExit, Pause, PixelGetColor, PixelSearch, 
- Process, Progress, Random, Reload, RunAs, SetBatchLines, 
- SetCapslockState, SetDefaultMouseSpeed, SetFormat, SetKeyDelay, SetMouseDelay, 
- SetNumlockState, SetScrollLockState, SetStoreCapslockMode, SetTitleMatchMode, 
- SetWinDelay, Shutdown, Sort, SoundGet, SoundGetWaveVolume, SoundPlay, SoundSet, 
- SoundSetWaveVolume, SplashImage, SplashTextOn, SplashTextOff, SplitPath, StatusBarGetText, 
- StatusBarWait, StringCaseSense, StringGetPos, StringLeft, StringLen, StringLower, StringMid, 
- StringReplace, StringRight, StringSplit, StringTrimLeft, StringTrimRight, StringUpper, Suspend, 
- SysGet, Thread, ToolTip, Transform, TrayTip, URLDownloadToFile, WinActivateBottom, 
- WinClose, WinGetActiveStats, WinGetActiveTitle, WinGetClass, WinGet, WinGetPos, WinGetText, 
- WinGetTitle, WinHide, WinKill, WinMaximize, WinMenuSelectItem, WinMinimize, WinMinimizeAll, 
- WinMinimizeAllUndo, WinMove, WinRestore, WinSet, WinSetTitle, WinShow, WinWait, WinWaitActive, 
- WinWaitClose, WinWaitNotActive, #CommentFlag, #ErrorStdOut, #EscapeChar, 
- #HotkeyInterval, #HotkeyModifierTimeout, #Include, #MaxHotkeysPerInterval, #MaxMem, 
- #MaxThreads, #MaxThreadsBuffer, #MaxThreadsPerHotkey, #NoTrayIcon, #SingleInstance, 
- #WinActivateForce
```

## Installation

Prerequisites:
- X11 and GTK are the only dependencies. You most likely have them already.
- Old distros like Debian *before* 10 (Buster) or Ubuntu *before* 18.04 are not supported ([reason](https://github.com/jhass/crystal-gobject/issues/73#issuecomment-661235729)). Otherwise, it should not matter what system you use.

Then, you can download the latest binary from the [release section](https://github.com/phil294/AHK_X11/releases). Make the downloaded file executable and you should be good to go.

**Please note that the current version is not very usable yet** because many commands are missing.

## Usage

There are different ways to use it.

1. The Windows way: Running the program directly opens up the interactive installer.
    - Once installed, all `.ahk` files are associated with AHK_X11, so you can simply double click them.
2. Command line: Pass the script to execute as first parameter, e.g. `./ahk_x11 "path to your script.ahk"`
    - Once your script's auto-execute section has finished, you can also execute arbitrary single line commands in the console. Code blocks aren't supported yet in that situation. Those single lines each run in their separate threads, which is why variables like `%ErrorLevel%` will always be `0`.
    - When you don't want to pass a script, you can specify `--repl` instead (implicit `#Persistent`).
    - If you want to pass your command from stdin instead of file, do it like this: `./ahk_x11 /dev/stdin <<< 'MsgBox'`.

<details>
<summary>Here's a working demo script showing several of the commands so far implemented.</summary>

```AutoHotkey
#Persistent
IfWinExist, ahk_class firefox
    WinActivate
tomorrow += 1, days
FileAppend, %tomorrow%, tomorrow.txt
GoSub greet
return ; some comment

greet:
my_var = 1234
sleep 0.001
IfEqual, my_var, 1234, MsgBox, %my_var%!. Try writing "btw" or pressing ctrl+shift+A.
else, msgbox ??
return

:*:btw::
SendRaw by the way
return

^+a::
msgbox You pressed ctrl shift A. If you press ctrl+shift+B, ahk_x11 should type something for you.
return

^+b::
SetTimer, my_timer, %myvar%
loop, 3
{
	sendraw, loop no %A_Index% `; ...
}
return

my_timer:
settimer, my_timer, off
msgbox, A timer was triggered!
return
```
</details>

### Caveats

#### Focus stealing prevention

`MsgBox` (which currently only accepts 0 or 1 arguments) should always work fine, but some Linux distros apply some form of focus stealing prevention. If you have enabled that, it is very likely that those msgbox popups will be created hidden behind all other open windows. This is even more problematic because popups do not appear in the task bar, so they are essentially invisible. (Only?) solution: Disable focus stealing prevention.

#### Appearance

(*) The `MsgBox` picture at the top was taken on a XFCE system with [Chicago95](https://github.com/grassmunk/Chicago95) installed, a theme that resembles Win95 look&feel. On your system, it will look like whatever GTK popups always look like.

## Development

These are the steps required to build this project locally. Please open an issue if anything doesn't work.

1. Install development versions of prerequisites.
    1. Ubuntu 20.04 and up:
        1. Dependencies
            ```
            sudo apt-get install libxinerama-dev libxkbcommon-dev libxtst-dev libgtk-3-dev libxi-dev libx11-dev
            ```
        1. [Install](https://crystal-lang.org/install/) Crystal and Shards (Shards is typically included in Crystal installation)
    1. Arch Linux:
        ```
        sudo pacman -S crystal shards gcc libxkbcommon libxinerama libxtst gtk3 gc
        ```
1. `git clone https://github.com/phil294/AHK_X11`
1. `cd AHK_X11`
1. Run these commands one by one (I haven't double checked them, so it's best to go through them manually). Most of it is all WIP and temporary and only necessary so the different dependencies get along fine (x11 and gobject bindings). As a bonus, the `build_namespace` invocations cache the GIR (`require_gobject` calls) and thus reduce the overall compile time from ~6 to ~3 seconds.
    ```bash
    shards install
    # populate cache
    crystal run lib/gobject/src/generator/build_namespace.cr -- Gtk 3.0 > lib/gobject/src/gtk/gobject-cache-gtk.cr
    crystal run lib/gobject/src/generator/build_namespace.cr -- xlib 2.0 > lib/gobject/src/gtk/gobject-cache-xlib--modified.cr
    for lib in "GObject 2.0" "GLib 2.0" "Gio 2.0" "GModule 2.0" "Atk 1.0" "HarfBuzz 0.0" "GdkPixbuf 2.0" "cairo 1.0" "Pango 1.0" "Gdk 3.0"; do
        echo "### $lib" >> lib/gobject/src/gtk/gobject-cache-gtk-other-deps.cr
        crystal run lib/gobject/src/generator/build_namespace.cr -- $lib >> lib/gobject/src/gtk/gobject-cache-gtk-other-deps.cr
    done
    # update lib to use cache
    sed -i -E 's/^(require_gobject)/# \1/g' lib/gobject/src/gtk/gobject-cache-gtk.cr lib/gobject/src/gtk/gobject-cache-gtk-other-deps.cr
    sed -i -E 's/^require_gobject "Gtk", "3.0"$/require ".\/gobject-cache-gtk"/' lib/gobject/src/gtk/gtk.cr
    echo 'require "./gobject-cache-xlib--modified"' > tmp.txt; echo 'require "./gobject-cache-gtk-other-deps"' >> tmp.txt; cat lib/gobject/src/gtk/gobject-cache-gtk.cr >> tmp.txt; mv tmp.txt lib/gobject/src/gtk/gobject-cache-gtk.cr
    echo 'macro require_gobject(namespace, version = nil) end' >> lib/gobject/src/gobject.cr
    # delete conflicting c function binding by modifying the cache
    sed -i -E 's/  fun open_display = XOpenDisplay : Void$//'  lib/gobject/src/gtk/gobject-cache-xlib--modified.cr
    ```
1. Now everything is ready for local use with `shards build -Dpreview_mt`, if you have `libxdo` (xdotool) version 2016x installed. Read on for a cross-distro compatible build.
1. In `lib/x_do/src/x_do/libxdo.cr`, add line `role : LibC::Char*` *after* `winname : LibC::Char*`
1. To make AHK_X11 maximally portable, various dependencies should be statically linked. Here is an overview of all dependencies. All of this was tested on Ubuntu 18.04.
    - Should be statically linked:
        - `libxdo`. Additionally to the above reasons, it isn't backwards compatible (e.g. Ubuntu 18.04 and 20.04 versions are incompatible) and may introduce even more breaking changes in the future. So, clone [xdotool](https://github.com/jordansissel/xdotool) somewhere, in there, run `make libxdo.a` and then copy the file `libxdo.a` into our `static` folder (create if it doesn't exist yet).
        - Dependencies of `libxdo`: `libxkbcommon`, `libXtst` and `libXi`. The static libraries should be available from your package manager dependencies installed above so normally there's nothing you need to do.
        - More dependencies of `libxdo` which are also available from the packages, but their linking fails with obscure PIE errors: `libXinerama` and `libXext`. I solved this by getting the source for these two and building the `.a` files locally (but apparently no makefile changes were required). Not very sure if these aren't actually part of every standard `libx11` install anyway, so maybe they should be dynamic...
        - Other (crystal dependencies?), also via package manager: `libevent_pthreads`, `libevent`, and `libpcre`
        - `libgc` is currently shipped and linked automatically by Crystal itself so there is no need for it
    - Stays dynamically linked:
        - `libgtk-3` and its dependencies, because afaik Gtk is installed everywhere, even on Qt-based distros. If you know of any common distribution that does not include Gtk libs by default please let me know. Gtk does also not officially support static linking. `libgtk-3`, `libgd_pixbuf-2.0`, `libgio-2.0`, `libgobject-2.0`, `libglib-2.0`, `libgobject-2.0`
        - glibc / unproblematic libraries according to [this list](https://github.com/AppImage/pkg2appimage/blob/master/excludelist): `libX11`, `libm`, `libpthread`, `librt`, `libdl`.
1. All in all, once you have `libxdo.a`, `libXext.a` and `libXinerama.a` inside the folder `static`, the following builds the final binary which should be very portable: `shards build -Dpreview_mt --link-flags="-L$PWD/static -Wl,-Bstatic -lxdo -lxkbcommon -lXinerama -lXext -lXtst -lXi -levent_pthreads -levent -lpcre -Wl,-Bdynamic"`. When not in development, increase optimizations and runtime speed by adding `--release`. The resulting binary is about 3.6 MiB in size.

## Performance

Not yet explicitly tuned for performance, but by design and choice of technology, it should run reasonably fast. Most recent tests yielded 0.03 ms for parsing one instruction line (this happens once at startup). Execution speed even is at least x100 faster than that.

TODO: speed measurements for `Send` and window operations

## Contributing

If you feel like it, you are welcome to contribute. This program has a very modular structure due to its nature which should make it easier to add features. Most work pending is just implementing commands, as almost everything more complicated is now bootstrapped. Simply adhere to the 2004 spec chm linked above. There's documentation blocks all across the source.

Commands behave mostly autonomous. See for example [`src/cmd/file/file-copy.cr`](https://github.com/phil294/AHK_X11/blob/master/src/cmd/file/file-copy.cr): All that is needed for most commands is `min_args`, `max_args`, the `run` implementation and the correct class name: The last part of the class name (here `FileCopy`) is automatically inferred to be the actual command name in scripts.
Regarding `run`: Anything can happen here, but several commands will access the `thread` or `thread.runner`, mostly for `thread.runner.get_user_var`, `thread.get_var` and `thread.runner.set_user_var`.

GUI: Most controls and their options still need to be translated into GTK. For that, both the [GTK Docs for C](https://docs.gtk.org/gtk3) and `lib/gobject/src/gtk/gobject-cache-gtk.cr` are helpful.

A more general overview:
- `src/build` does the parsing etc. and is mostly complete
- `src/run/runner` and `src/run/thread` are worth looking into, this is the heart of the application and where global and thread state is stored
- `src/cmd` contains all commands exposed to the user.

There's also several `TODO:`s scattered around all source files mostly around technical problems that need some revisiting.

While Crystal brings its own hidden `::Thread` class, any reference to `Thread` in the source refers to `Run::Thread` which actually are no real threads (see [`Run::Thread`](https://github.com/phil294/AHK_X11/blob/master/src/run/thread.cr) docs).

## Issues

For bugs and feature requests, please open up an issue. I am also available on the AHK Discord server or the [forum](https://www.autohotkey.com/boards/viewtopic.php?f=81&t=106640).

## License

[GPL-2.0](https://tldrlegal.com/license/gnu-general-public-license-v2)
