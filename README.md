# AHK_X11

AutoHotkey for Linux.

<div align="center">

![MsgBox](assets/popup.png)

`MsgBox, AHK_X11` (*)
</div>

This project is usable, but WORK IN PROGRESS.

**Scripts from Windows will usually NOT WORK without modifications.** If you want this to become a reality, you're welcome to contribute, and/or join the [AHK Discord](https://autohotkey.com/discord/)'s #ahk_x11 channel.

Supports both X11 **AND** Wayland, but the latter is very experimental. Please read the **Wayland** section below if you're intending on using that.

!!!!!!!!!!YOU ARE CURRENTLY ON THE EXPERIMENTAL WAYLAND / EVDEV BRANCH. EXPECT BUGS EVERYWHERE!!!!!!!!!!

[**Direct download**](https://github.com/phil294/AHK_X11/releases/download/0.5.1/ahk_x11-0.5.1-x86_64.AppImage) (all Linux distributions, x86_64, single executable)

[**FULL DOCUMENTATION**](https://phil294.github.io/AHK_X11) (single HTML page)

[**Go to installation instructions**](#installation)

[**DEMO VIDEO**](https://raw.githubusercontent.com/phil294/AHK_X11/master/assets/demo.mp4): Installation, script creation, compilation

[AutoHotkey](https://www.autohotkey.com/) is "Powerful. Easy to learn. The ultimate automation scripting language for Windows.". This project tries to bring large parts of that to Linux.

More specifically: A very basic but functional reimplementation AutoHotkey v1.0.24 (2004) for Unix-like systems with an X window system (X11), written from ground up with [Crystal](https://crystal-lang.org/)/[libxdo](https://github.com/jordansissel/xdotool)/[gi-crystal](https://github.com/hugopl/gi-crystal)/[x11-cr](https://github.com/TamasSzekeres/x11-cr/)/[x_do.cr](https://github.com/woodruffw/x_do.cr), with the eventual goal of 80% feature parity, but most likely never full compatibility. Currently about 60% of work is done. This AHK is shipped as a single executable native binary with very low resource overhead and fast execution time.

Note that because of the old version of the spec (at least for now), many modern AHK features are missing, especially expressions (`:=`, `% v`), classes, objects and functions, so you probably can't just port your scripts from Windows. More to read: [Project goals](https://github.com/phil294/AHK_X11/issues/8)

You can use AHK_X11 to create stand-alone binaries with no dependencies, including full functionality like Hotkeys and GUIs. (just like on Windows)

Please also check out [Keysharp](https://bitbucket.org/mfeemster/keysharp/), a WIP fork of [IronAHK](https://github.com/Paris/IronAHK/tree/master/IronAHK), another complete rewrite of AutoHotkey in C# that tries to be compatible with multiple OSes and support modern, v2-like AHK syntax with much more features than this one. In comparison, AHK_X11 is a lot less ambitious and more compact, and Linux only.

Features:
- [x] Hotkeys
- [x] Hotstrings
- [x] Window management (but some commands are still missing)
- [x] Send keys
- [x] Control mouse
- [x] File management (but some commands are still missing)
- [x] GUIs (partially done)
- [x] One-click compile script to portable stand-alone executable
- [x] Scripting: labels, flow control: If/Else, Loop
- [x] Window Spy
- [x] Graphical installer (optional)
- [x] Context menu and compilation just like on Windows

Besides:
- Interactive console (REPL)

AHK_X11 can be used completely without a terminal. You can however if you want use it console-only too. Graphical commands are optional, it also runs headless.

<details><summary><strong>CLICK TO SEE WHICH COMMANDS ARE IMPLEMENTED AND WHICH ARE MISSING</strong>. Note however that this is not very representative. For example, no `Gui` sub command is included in the listing. For a better overview on what is already done, skim through the <a href="https://phil294.github.io/AHK_X11"><b>FULL DOCUMENTATION HERE</b></a>.</summary>

```diff
DONE      42% (93/219):
+ Else, { ... }, Break, Continue, Return, Exit, GoSub, GoTo, IfEqual, Loop, SetEnv, Sleep, FileCopy,
+ SetTimer, WinActivate, MsgBox, Gui, SendRaw, #Persistent, ExitApp,
+ EnvAdd, EnvSub, EnvMult, EnvDiv, ControlSendRaw, IfWinExist/IfWinNotExist, SetWorkingDir,
+ FileAppend, Hotkey, Send, ControlSend, #Hotstring, Menu, FileCreateDir, FileDelete, IfMsgBox,
+ #SingleInstance, Edit, FileReadLine, FileSelectFile, FileSelectFolder, FileSetAttrib, FileSetTime,
+ IfNotEqual, If var [not] between, IfExist/IfNotExist, IfGreater/IfGreaterOrEqual,
+ IfInString/IfNotInString, IfLess/IfLessOrEqual, IfWinActive/IfWinNotActive, IniDelete, IniRead,
+ IniWrite, Loop (files & folders), Loop (read file contents), MouseClick, Pause, Reload,
+ StringGetPos, StringLeft, StringLen, StringLower, StringMid, StringReplace, StringRight,
+ StringUpper, Suspend, URLDownloadToFile, WinClose, WinGetPos, WinKill, WinMaximize, WinMinimize,
+ WinMove, WinRestore, MouseGetPos, MouseMove, GetKeyState, KeyWait, ControlClick, WinGetText,
+ WinGetTitle, WinGetClass, PixelGetColor, CoordMode, GuiControl, ControlGetPos, ControlGetText,
+ WinGet, Input, Loop (parse a string), ToolTip, If var [not] in/contains MatchList, ControlSetText,
+ PixelSearch, #Include

NEW       4% (8/219): (not part of spec or from a more recent version)
@@ Echo, ahk_x11_print_vars, FileRead, RegExGetPos, RegExReplace, EnvGet, @@
@@ ahk_x11_track_performance_start, ahk_x11_track_performance_stop @@

REMOVED   5% (12/219):
# ### Those that simply make no sense in Linux:
# EnvSet, EnvUpdate, PostMessage, RegDelete, RegRead, RegWrite, SendMessage, #InstallKeybdHook,
# #InstallMouseHook, #UseHook, Loop (registry)
#
# ### Skipped for other reasons:
# AutoTrim: It's always Off. It would not differentiate between %a_space% and %some_var%.
#           It's possible but needs significant work.

TO DO     47% (102/219): alphabetically
- BlockInput, ClipWait, Control, ControlFocus, ControlGet, ControlGetFocus,
- ControlMove,
- DetectHiddenText, DetectHiddenWindows, Drive, DriveGet, DriveSpaceFree,
- FileCopyDir, FileCreateShortcut,
- FileInstall, FileGetAttrib, FileGetShortcut, FileGetSize, FileGetTime, FileGetVersion,
- FileMove, FileMoveDir, FileRecycle, FileRecycleEmpty, FileRemoveDir,
- FormatTime, GroupActivate, GroupAdd,
- GroupClose, GroupDeactivate, GuiControlGet,
- If var is [not] type,
- InputBox, KeyHistory, ListHotkeys, ListLines, ListVars,
- MouseClickDrag, OnExit,
- Process, Progress, Random, RunAs, SetBatchLines,
- SetCapslockState, SetControlDelay, SetDefaultMouseSpeed, SetFormat, SetKeyDelay, SetMouseDelay,
- SetNumlockState, SetScrollLockState, SetStoreCapslockMode, SetTitleMatchMode,
- SetWinDelay, Shutdown, Sort, SoundGet, SoundGetWaveVolume, SoundPlay, SoundSet,
- SoundSetWaveVolume, SplashImage, SplashTextOn, SplashTextOff, SplitPath, StatusBarGetText,
- StatusBarWait, StringCaseSense, StringSplit, StringTrimLeft, StringTrimRight,
- SysGet, Thread, Transform, TrayTip, WinActivateBottom,
- WinGetActiveStats, WinGetActiveTitle,
- WinHide, WinMenuSelectItem, WinMinimizeAll,
- WinMinimizeAllUndo, WinSet, WinSetTitle, WinShow, WinWait, WinWaitActive,
- WinWaitClose, WinWaitNotActive, #CommentFlag, #ErrorStdOut, #EscapeChar,
- #HotkeyInterval, #HotkeyModifierTimeout, #MaxHotkeysPerInterval, #MaxMem,
- #MaxThreads, #MaxThreadsBuffer, #MaxThreadsPerHotkey, #NoTrayIcon, #WinActivateForce

Also planned, even though it's not part of 1.0.24 spec:
- ImageSearch
- Maybe some kind of OCR command
- #IfWinActive (the directive)
```
</details>

## Showcase of scripts

- [Vimium Everywhere](https://github.com/phil294/vimium-everywhere): Keyboard navigation for the whole desktop
- [Activity monitor](https://github.com/phil294/activity-monitor): Demonstrates keyboard tracking, window, control listing and more
- ...did you create something with AHK_X11 that could potentially be useful to others too? Suggestions for this list? Please open an issue or [write me a mail](mailto:github@waritschlager.de)!

## Installation

**[Download the latest binary from the release section](https://github.com/phil294/AHK_X11/releases)**. Make the downloaded file executable ([how?](https://askubuntu.com/a/484719/378854)) and you should be good to go: Just double click it *or* run it in the console without arguments (**without** sudo).

Prerequisites:
- *Nothing*, except that old distros like Debian *before* 10 (Buster) or Ubuntu *before* 18.04 are not supported ([reason](https://github.com/jhass/crystal-gobject/issues/73#issuecomment-661235729)). Otherwise, it should not matter what system you use.

There is no auto updater yet! (but planned) You will probably want to get the latest version then and again.

## Usage

There are different ways to use it.

1. The graphical way, like on Windows: Running the program directly opens up the interactive installer.
    - Once installed, all `.ahk` files are associated with AHK_X11, so you can simply double click them.
    - Also adds the Compiler into `Open as...` Menus.
    - Also adds Window Spy to your applications. It looks [something like this](./assets/WindowSpy.png).
2. Command line
    - Either: Pass the script to execute as first parameter, e.g. `./ahk_x11 "path to your script.ahk"`
    - Or: Pass code from stdin, e.g. `echo $'var = 123\nMsgBox %var%' | ./ahk_x11`
    - If you once installed with the graphical installer, the binary is also to be found at `~/.local/bin/ahk_x11.AppImage`
    - Once your script's auto-execute section has finished, you can also interactively execute arbitrary single line commands in the console. Code blocks aren't supported yet in that situation. Those single lines each run in their separate threads, which is why variables like `%ErrorLevel%` will always be `0`.
    - When you don't want to pass a script and jump to this mode directly, you can specify `--repl` instead (implicit `#Persistent`).
    - Compile scripts with `./ahk_x11 --compile "path/script.ahk"`
    - Run Window Spy with `./ahk_x11 --windowspy`
    - Hashbang supported if first line starts with `#!`
    - You can disable graphical commands by manually unsetting the DISPLAY variable. Example: `DISPLAY= ./ahk_x11 <<< 'Echo abc'` just prints `abc` to the console (`Echo` command is a special ahk_x11-only command). The only advantage is faster startup time.

## Wayland (evdev)

You can skip this section if you're using X11. If you're on Ubuntu 22.04 and up, you can switch back from Wayland to X11 using this ([link](https://askubuntu.com/q/1410256)).

Generally, on X11 everything will be less painful and just work™, mostly because our Wayland support isn't mature yet. You are welcome to try it out though.

As a prerequisite, you will need to give yourself elevated input permission: You need to be part of the `input` group, e.g. by typing `sudo usermod -aG input $USER` in a terminal and then *relogging*. (Note that if you want to `setcap` instead, it [won't work](https://github.com/AppImage/AppImageKit/issues/881#issuecomment-1493039417) because the binary is an AppImage).

STATE OF THE WAYLAND / EVDEV BRANCH:

- Most commands work perfectly fine, e.g. `Send`. `Send` should actually work even *better* than on X11 right now for special keys (temporarily)
- Certain commands don't work at all: E.g. `WinMaximize`
- Certain commands work only partially: E.g. `ControlSendRaw` only works when you give it a specific control handle. `MouseMove` and `MouseGetPos` only works reliably in relative mode. `WinGetText` works but you can't specify window class anymore, only matching by name or `ahk_pid` is available.
- Certain commands only work once you've set up accessibility settings completely, see **Accessbility** below. That's because Wayland has no concept of "Windows" on its own.
- Certain functionality is not **yet** implemented for Wayland, such as Hotkey grabbing (without `~`)
- WindowSpy is currently broken and it is unclear how/when this can be fixed

The html docs currently don't reflect the differences and difficulties when dealing with Wayland. Many command descriptions are still due to be updated accordingly.

There is a small automated tests file (`tests.ahk`) but nothing works properly right now.

More than 100 `todo`s and `fixme`s all over the source code right now, they all need to be fixed before this branch can be merged into master.

Even if you're on X11, it's possible to try out Wayland features by specifying the AHK_X11-specific directive `#InputDevice`: Add `#InputDevice evdev` anywhere in your script to switch. Alternative values are `xtest` (default on X11), `xgrab` (legacy X11) or `off`.

In case you're wondering - the `X11` in `AHK_X11` is indeed a bit unfortunate as the name predates the addition of Wayland support, but as you can see, compatibility has been added and renaming the whole project because of that is probably not a good idea.

### Caveats

#### Accessibility

All commands or command options related to Controls (e.g. `ControlClick` or `WinGetText`) relies on assistive technologies. While almost all windows support this, this typically needs adjustments on the running system. Read [the documentation section on accessibility](https://phil294.github.io/AHK_X11/#Accessibility.htm) for instructions.

#### Focus stealing prevention

Some Linux distros offer a configurable setting for focus stealing prevention. Usually, it's default off. But if you have activated it, window focus changing actions like `MsgBox` or `WinActivate` will not work as expected: A `MsgBox` will appear hidden *behind* the active window. This can be useful to prevent accidental popup dismissal but when you don't like that, you have three options:
- disable said setting
- use the `always on top` setting of MsgBox
- <details><summary>hack around it with code</summary>

    ```AutoHotkey
    SetTimer, MsgBoxToFront, 1
    MsgBox, Hello
    Return

    MsgBoxToFront:
    SetTimer, MsgBoxToFront, off
    ; You might want to adjust the matching criteria, especially for compiled scripts
    WinActivate ahk_class ahk_x11
    return
    ```

#### Appearance

(*) The `MsgBox` picture at the top was taken on a XFCE system with [Chicago95](https://github.com/grassmunk/Chicago95) installed, a theme that resembles Win95 look&feel. On your system, it will look like whatever GTK popups always look like.

#### Incompatibilities with Windows versions

Like covered above, AHK_X11 is vastly different to modern Windows-AutoHotkey because 1. its spec is *missing its more recent features* and 2. there are *still several features missing*. Apart from that, there are a few minor *incompatibilities* between AHK_X11 and the then-Windows-AutoHotkey 1.0.24:
- `#NoEnv` is the default, this means, to access environment variables, you'll have to use `EnvGet`.
- All arguments are always evaluated only at runtime, even if they are static. This can lead to slightly different behavior or error messages at runtime vs. build time.
- Several more small subtle differences highlighted in green throughout the docs page

Besides, it should be noted that un[documented](https://phil294.github.io/AHK_X11) == undefined.

## Performance

AHK_X11 is an interpreted language, not a compiled one. This means that no compile time optimizations take place on your script code, apart from some validation and reference placements. Also, all variables are of type String. So you probably wouldn't want to use it for performance-critical applications. However, the tool itself is written in Crystal and thus compiled and optimized for speed, so everything should still be reasonably fast. The speed of some of the slower commands depends on either libxdo or X11 and it's not yet clear whether there is much room for improvement. Some tests run on a 3.5 GHz machine:

Parsing a single line takes about 30 µs (this happens once at startup), and execution time depends on what a command does:
- `x = 1`: 70 ns (0.00000007 s)
- `FileRead, x, y.txt`: 10 µs (0.00001 s)
- `WinGetTitle, A`: 87 µs (0.000087 s)
- `Send, a`: 530 µs (0.00053 s)
- `Clipboard = a`: 6 ms (0.006 s)
- `SendRaw, a`: 9 ms (0.009 s) (??)
- `WinActivate, title`: 60 ms (0.06 s)
- `WinGetText`: 0-3 s (!)

You can run fine-grained benchmarks with the following special hidden instruction:

```AutoHotkey
AHK_X11_track_performance_start
Loop, 1000
    Send, a
AHK_X11_track_performance_stop
```
prints something like:
```
[{"send", count: 1000, total: 00:00:00.530032328>},
 {"loop", count: 1001, total: 00:00:00.000206347>}]
```
Note that the internal code around executing commands takes about 10 µs between two every commands and you can't do anything about it and this *not* measured / included in the benchmark command's output. This can actually be the bottleneck in some scripts and should probably be improved

More tips:
- Some values are cached internally while the thread is running, so repeated commands may run faster
- The first time an AtSpi-related command (`Control`-*, `WinGetText`, ... see "Accessibility" section above) runs, the interface needs to be initialized which can take some time (0-5s)
- Searching for windows is slow. Querying the active window or specifying an ID is not. For example, `WinActivate, ahk_id %win_id%` will be much much faster than `WinActivate, window name`. So for many window operations you might want to do a single `WinGet, win_id, ID` beforehand and then reuse that `%win_id%`.

## Contributing

If you want to help with AHK_X11 development or prefer to build from source instead of using the prebuilt binaries, detailed build instructions are to be found in [./build/README.md](./build).

## Issues

For bugs and feature requests, please open up an issue, or check the Discord or [Forum](https://www.autohotkey.com/boards/viewtopic.php?f=81&t=106640).

## License

[GPL-2.0](https://tldrlegal.com/license/gnu-general-public-license-v2)
