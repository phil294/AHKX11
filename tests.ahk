TODO:
the changes to this file from the evdev branch were ignored because they somehow were the same as from x11 but still conflicts? review
; AUTOMATED TEST SUITE
; Mostly to prevent regression bugs
; Right now, only commands that can be easily tested in 1-2 lines are tested.
;;;;;;;;;;;;;;;;;;;;;;

N_TESTS = 70

SetKeyDelay, 0
SetMouseDelay, 0

GoSub, run_tests
if tests_run != %N_TESTS%
{
	fail_reason = %tests_run% tests completed does not match the expected N_TESTS=%N_TESTS%
	GoSub, fail
}
echo All tests completed successfully!
ExitApp

assert:
	tests_run += 1
	If expect =
	{
		fail_reason = "expect" not set
		GoSub, fail
	}

	; StringSplit, split, expect, `,
	; ^ does not exist yet in ahk_x11 so we'll imitate it for now:
	StringGetPos, first_comma_pos, expect, `,
	If first_comma_pos < 0
	{
		fail_reason = expect: var missing: %expect%
		GoSub, fail
	}
	StringMid, test_title, expect, , %first_comma_pos%
	first_comma_pos += 2
	StringMid, expect, expect, %first_comma_pos%, 9999
	StringGetPos, second_comma_pos, expect, `,
	If second_comma_pos < 0
	{
		fail_reason = expect: condition missing (value): %expect%
		GoSub, fail
	}
	StringMid, test_var, expect, , %second_comma_pos%
	second_comma_pos += 2
	StringMid, test_value, expect, %second_comma_pos%, 9999

	StringLeft, test_var_value, %test_var%, 9999
	test_success = 0
	if assert_as_opposite <>
	{
		if test_var_value != %test_value%
			test_success = 1
	} else {
		if test_var_value = %test_value%
			test_success = 1
	}
	If test_success != 1
	{
		if assert_as_opposite <>
			fail_reason_not = not%a_space%
		fail_reason = ❌ (%tests_run%/%N_TESTS%) %test_title%: '%test_var%' is '%test_var_value%' but should %fail_reason_not%be '%test_value%'
		fail_reason_not =
		GoSub, fail
	}
	echo ✔ (%tests_run%/%N_TESTS%) %test_title%
	expect =
	first_comma_pos =
	test_title =
	second_comma_pos =
	test_var =
	test_value =
	test_var_value =
	assert_as_opposite =
	test_success =
Return
assert_false:
	assert_as_opposite = 1
	gosub assert
return

fail:
	echo %fail_reason%
	msgbox %fail_reason%
	exitapp 1
Return

timeout:
	settimer, timeout_over, 250
	loop
	{
		stringleft, timeout_var_value, %timeout_var%, 9999
		if timeout_var_value <>
		{
			settimer, timeout_over, OFF
			tests_run += 1
			echo ✔ (%tests_run%/%N_TESTS%) %timeout_var%
			%timeout_var% =
			timeout_var_value =
			return
		}
		sleep 10
	}
return
timeout_over:
	fail_reason = ❌ (%tests_run%/%N_TESTS%) %timeout_var%: Timeout!
	gosub fail
return

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

run_tests:

setup = 2
expect = test setup works,setup,2
gosub assert

timeout_var = test_setup_timeout_works
settimer, l_test_setup_timeout_timer, 1
goto l_test_setup_timeout
			l_test_setup_timeout_timer:
				settimer, l_test_setup_timeout_timer, off
				test_setup_timeout_works = 1
			return
l_test_setup_timeout:
gosub timeout
expect = test setup: timeout: reset timeout_var,test_setup_timeout_works,
gosub assert

var1 = v1
expect = equality check,var1,%var1%
gosub assert
var1 =   v1  ; ; ;
/*
*/
expect = equality check spaced,var1,v1
gosub assert
var1 = v1%a_space%
expect = disparity check,var1,v1
gosub assert_false
expect = equality check spaced var,v1,%v1%
gosub assert

; helper gui for various interaction tests:
gui -caption
gui add, picture, x0 y0 h47 w-1, assets/logo.png
gui add, button, x10 y50 ggui_button_clicked, btn txt 1
gui add, edit, x20 y70 vgui_edit, edit txt 1
gui +resize
gui show, x10 y20, ahk_x11_test_gui
goto l_after_gui
			gui_button_clicked:
				gui_button_clicked_success = 1
			return
l_after_gui:
sleep 10

;;;;;;;;;;;;;;;;;;; TESTS ;;;;;;;;;;;;;;;;;;;

ifwinnotexist, ahk_x11_test_gui
{
	fail_reason = gui win not exist
	gosub fail
}
ifwinnotexist, ahk_x11_test_gui, btn txt 1
{
	fail_reason = gui win not exist 1
	gosub fail
}
ifwinexist, ahk_x11_test_gui, btn txt 2
{
	fail_reason = gui win exist 2
	gosub fail
}
ifwinexist, ahk_x11_test_gui,,, btn txt 1
{
	fail_reason = gui win exist 3
	gosub fail
}
ifwinnotexist, ahk_x11_test_gui,,, btn txt 2
{
	fail_reason = gui win not exist 4
	gosub fail
}
ifwinnotexist, ahk_x11_test_gui, btn txt 1,banana,btn txt 2
{
	fail_reason = gui win not exist 5
	gosub fail
}
ifwinexist, ahk_x11_test_gui,,ahk_x11_test_gui
{
	fail_reason = gui win not exist 6
	gosub fail
}
winactivate
ifwinnotactive, ahk_x11_test_gui
{
	fail_reason = gui win not active
	gosub fail
}

WinGetPos, x, y, w, h
expect = gui show pos,x,10
gosub assert
expect = gui show pos,y,20
gosub assert

WinMove, ,, 0, 0, 233, 234
sleep 10
WinGetPos, x, y, w, h
expect = winmove,x,0
gosub assert
expect = winmove,y,0
gosub assert
expect = winmove,w,233
gosub assert
expect = winmove,h,234
gosub assert
WinMove, ,, 10, 20
sleep 10


;;CommentFlag NewString
;;ErrorStdOut
;;EscapeChar NewChar
;;HotkeyInterval Value
;;HotkeyModifierTimeout Value
;;MaxHotkeysPerInterval Value
;;MaxMem Megabytes
;;MaxThreads Value
;;MaxThreadsBuffer On|Off
;;MaxThreadsPerHotkey Value
;;NoTrayIcon
;Persistent
;SingleInstance [force|ignore|off|prompt]
;;WinActivateForce
;;BlockInput, Mode
;Break
;;ClipWait [, SecondsToWait]
;Continue
;;Control, Cmd [, Value, Control, WinTitle, WinText, ExcludeTitle, ExcludeText]

ControlClick, push_button_0_1
expect = controlclick gui button,gui_button_clicked_success,1
gosub assert
gui_button_clicked_success =

;;ControlFocus [, Control, WinTitle, WinText, ExcludeTitle, ExcludeText]
;;ControlGet, OutputVar, Cmd [, Value, Control, WinTitle, WinText, ExcludeTitle, ExcludeText]
;;ControlGetFocus, OutputVar [WinTitle, WinText, ExcludeTitle, ExcludeText]

ControlGetPos, x, y, w, h, icon_0_0_0
expect = controlgetpos,x,0
gosub assert
expect = controlgetpos,y,0
gosub assert
expect = controlgetpos,w,47
gosub assert

ControlGetText, edit_txt, edit txt 1
expect = controlgettext,edit_txt,edit txt 1
gosub assert

ControlSetText, text_0_2, edit txt 2
controlgettext, edit_txt, text_0_2
expect = controlgettext settext,edit_txt,edit txt 2
gosub assert

;;ControlMove, Control, X, Y, Width, Height [, WinTitle, WinText, ExcludeTitle, ExcludeText]

CoordMode, Mouse, Relative
MouseMove, 0, 0
CoordMode, Mouse, Screen
mousegetpos, x, y
expect = coordmode mousepos,x,10
gosub assert
expect = coordmode mousepos,y,20
gosub assert
CoordMode, Mouse, Relative

;;DetectHiddenText, On|Off
;;DetectHiddenWindows, On|Off
;;Drive, Sub-command [, Drive , Value]
;;DriveGet, OutputVar, Cmd [, Value]
;;DriveSpaceFree, OutputVar, Path
;Else
;EnvAdd, Var, Value [, TimeUnits]
;Var += Value [, TimeUnits]
;EnvDiv, Var, Value
;EnvGet, OutputVar, EnvVarName
;EnvMult, Var, Value
;EnvSet, EnvVar, Value
;EnvSub, Var, Value [, TimeUnits]
;Var -= Value [, TimeUnits]
;Exit [, ExitCode]
;ExitApp [, ExitCode]

txt =
tmp_file = ahk_x11_test_%a_now%.txt
FileAppend, txt, %tmp_file%
FileCopy, %tmp_file%, %tmp_file%2
FileDelete, %tmp_file%
FileRead, txt, %tmp_file%
FileRead, txt2, %tmp_file%2
expect = file append copy read,txt2,txt
gosub assert
expect = file delete,txt,
gosub assert
FileDelete, %tmp_file%2


;;FileCopyDir, Source, Dest [, Flag]
;FileCreateDir, DirName
;;FileCreateShortcut, Target, LinkFile [, WorkingDir, Args, Description, IconFile, ShortcutKey, IconNumber, RunState]
;FileGetAttrib, OutputVar [, Filename]
;;FileGetShortcut, LinkFile [, OutTarget, OutDir, OutArgs, OutDescription, OutIcon, OutIconNum, OutRunState]
;;FileGetSize, OutputVar [, Filename, Units]
;;FileGetTime, OutputVar [, Filename, WhichTime]
;;FileGetVersion, OutputVar [, Filename]
;;FileInstall, Source, Dest, Flag
;;FileMove, SourcePattern, DestPattern [, Flag]
;;FileMoveDir, Source, Dest [, Flag]
;FileReadLine, OutputVar, Filename, LineNum
;;FileRecycle, FilePattern
;;FileRecycleEmpty [, DriveLetter]
;;FileRemoveDir, DirName [, Recurse?]
;FileSelectFile, OutputVar [, Options, RootDir, Prompt, Filter]
;FileSelectFolder, OutputVar [, RootPath, Options, Prompt]
;FileSetAttrib, Attributes [, FilePattern, OperateOnFolders?, Recurse?]
;;FileSetTime [, YYYYMMDDHH24MISS, FilePattern, WhichTime, OperateOnFolders?, Recurse?]
;;FormatTime, OutputVar [, YYYYMMDDHH24MISS, Format]

Send {a down}
sleep 20
GetKeyState, a_state, a
expect = getkeystate,a_state,D
gosub assert
send {a up}
sleep 20
GetKeyState, a_state, a
expect = getkeystate,a_state,U
gosub assert

;GoSub, Label
;Goto, Label
;;GroupActivate, GroupName [, R]
;;GroupAdd, GroupName, WinTitle [, WinText, Label, ExcludeTitle, ExcludeText]
;;GroupClose, GroupName [, A|R]
;;GroupDeactivate, GroupName [, R]
;GUI, sub-command [, Param2, Param3, Param4]

GuiControl, , gui_edit, edit txt 3
gui submit, nohide
expect = guicontrol settext,gui_edit,edit txt 3
gosub assert

;;GuiControlGet, OutputVar [, Sub-command, ControlID, Param4]

goto l_after_hotkey_a
			hotkey_a:
				hotkey_a_success = 1
			return
l_after_hotkey_a:
Hotkey, a, hotkey_a
runwait, xdotool type --delay=0 a
expect = hotkey a trigger,hotkey_a_success,1
gosub assert
Hotkey, a, OFF

;if Var between LowerBound and UpperBound
;if var is not type
;if var is type
;if Var not between LowerBound and UpperBound
;IfEqual, var, value (same: if var = value)
;IfExist, FilePattern
;IfGreater, var, value (same: if var > value)
;IfGreaterOrEqual, var, value (same: if var >= value)
;IfInString, var, SearchString
;IfLess, var, value (same: if var < value)
;IfLessOrEqual, var, value (same: if var <= value)
;IfMsgBox, ButtonName
;IfNotEqual, var, value (same: if var <> value) (same: if var != value)
;IfNotExist, FilePattern
;IfNotInString, var, SearchString
;IniDelete, Filename, Section [, Key]
;IniRead, OutputVar, Filename, Section, Key [, Default]
;IniWrite, Value, Filename, Section, Key

goto l_input
			input_send_key:
				settimer, input_send_key, OFF
				runwait xdotool type --delay=0 b
			return
l_input:
settimer, input_send_key, 1
Input, keys, v l1 t1
expect = input,keys,b
gosub assert
keys =

goto l_input_extended
			input_send_key_extended:
				settimer, input_send_key_extended, OFF
				runwait xdotool type --delay=0 abc.
				runwait xdotool key space
				runwait xdotool type --delay=0 xy
				runwait xdotool key BackSpace
				runwait xdotool type --delay=0 yz
			return
l_input_extended:
settimer, input_send_key_extended, 1
Input, keys, *t1, {esc}, abc , xyz
_errorlevel = %errorlevel%
expect = input extended errorlevel,_errorlevel,Match
gosub assert
expect = input extended keys,keys,abc. xyz
gosub assert
keys =
_errorlevel =

Input, keys, t0.00001, {esc}
_errorlevel = %errorlevel%
expect = input timeout,_errorlevel,Timeout
gosub assert
keys =
_errorlevel =

;;InputBox, OutputVar [, Title, Prompt, HIDE, Width, Height, X, Y, Font, Timeout, Default]
;;KeyHistory
;KeyWait, KeyName [, Options]
;;ListHotkeys
;;ListLines
;;ListVars
;Loop [, Count]
;Loop, FilePattern [, IncludeFolders?, Recurse?]
;Loop, Parse, InputVar [, Delimiters, OmitChars, FutureUse]
;Loop, Read, InputFile [, OutputFile, FutureUse]
;Menu, MenuName, Cmd [, P3, P4, P5, FutureUse]

MouseClick, L, 35, 60
sleep 50
expect = click gui button,gui_button_clicked_success,1
gosub assert
gui_button_clicked_success =

;;MouseClickDrag, WhichButton, X1, Y1, X2, Y2 [, Speed, R]

MouseGetPos,,,, ctrl
expect = mousegetpos,ctrl,push_button_0_1
gosub assert

;MsgBox [, Options, Title, Text, Timeout]
;MsgBox, Text
;;OnExit [, Label, FutureUse]
;Pause [, On|Off|Toggle]

coordmode, pixel, relative
PixelGetColor, color, 26, 8, rgb
expect = pixelgetcolor,color,79BE79
gosub assert

PixelSearch, x, y, 0, 0, 100, 100, 0x79BE79, 0, rgb
expect = pixelsearch,x,26
gosub assert
expect = pixelsearch,y,8
gosub assert

;;PostMessage, Msg [, wParam, lParam, Control, WinTitle, WinText, ExcludeTitle, ExcludeText]
;;Process, Cmd, PID-or-Name [, Param3]
;;Random, OutputVar [, Min, Max]
;RegExGetPos, OutputVar, InputVar, SearchText [, L#|R#]
;RegExReplace, OutputVar, InputVar, RegExSearchText [, ReplaceText, ReplaceAll?]
;Reload
;Return
;RunAs [, User, Password, Domain]
;SendRaw, Keys
;;SetBatchLines, 20ms
;;SetBatchLines, LineCount
;;SetControlDelay, Delay
;;SetDefaultMouseSpeed, Speed
;;SetFormat, NumberType, Format
;;SetKeyDelay [, Delay, PressDuration]
;;SetMouseDelay, Delay
;;SetStoreCapslockMode, On|Off
;;SetTitleMatchMode, Fast|Slow
;;SetTitleMatchMode, MatchMode
;;SetWinDelay, Delay
;SetWorkingDir, DirName
;;Shutdown, Code
;Sleep, Delay
;;Sort, VarName [, Options]
;;SoundGet, OutputVar [, ComponentType, ControlType, DeviceNumber]
;;SoundGetWaveVolume, OutputVar [, DeviceNumber]
;;SoundPlay, Filename [, wait]
;;SoundSet, NewSetting [, ComponentType, ControlType, DeviceNumber]
;;SoundSetWaveVolume, Percent [, DeviceNumber]
;;SplitPath, InputVar [, OutFileName, OutDir, OutExtension, OutNameNoExt, OutDrive]
;;StatusBarGetText, OutputVar [, Part#, WinTitle, WinText, ExcludeTitle, ExcludeText]
;;StatusBarWait [, BarText, Seconds, Part#, WinTitle, WinText, Interval, ExcludeTitle, ExcludeText]
;;StringCaseSense, On|Off
;StringGetPos, OutputVar, InputVar, SearchText [, L#|R#]
;StringLeft, OutputVar, InputVar, Count
;StringLen, OutputVar, InputVar
;StringLower, OutputVar, InputVar [, T]
;StringMid, OutputVar, InputVar, StartChar, Count [, L]
;StringReplace, OutputVar, InputVar, SearchText [, ReplaceText, ReplaceAll?]
;StringRight, OutputVar, InputVar, Count
;;StringSplit, OutputArray, InputVar [, Delimiters, OmitChars, FutureUse]
;;StringTrimLeft, OutputVar, InputVar, Count
;;StringTrimRight, OutputVar, InputVar, Count
;StringUpper, OutputVar, InputVar [, T]
;Suspend [, Mode]
;;SysGet, OutputVar, Sub-command [, Param3]
;;Thread, Setting, P2 [, P3]
;;Transform, OutputVar, Cmd, Value1 [, Value2]
;URLDownloadToFile, URL, Filename
;;WinActivateBottom [, WinTitle, WinText, ExcludeTitle, ExcludeText]
;WinClose [, WinTitle, WinText, SecondsToWait, ExcludeTitle, ExcludeText]
;WinGet, OutputVar [, Cmd, WinTitle, WinText, ExcludeTitle, ExcludeText]
;;WinGetActiveStats, Title, Width, Height, X, Y
;;WinGetActiveTitle, OutputVar

WinGetClass, class
EnvGet, is_appimage, APPIMAGE
if is_appimage =
	expect = wingetclass,class,Ahk_x11
else
	expect = wingetclass,class,AppRun.wrapped
gosub assert

WinGetText, txt
expect = wingettext,txt,ahk_x11_test_gui`nbtn txt 1`nedit txt 3
gosub assert

WinGetTitle, title
expect = wingettitle,title,ahk_x11_test_gui
gosub assert

;;WinHide [, WinTitle, WinText, ExcludeTitle, ExcludeText]
;WinKill [, WinTitle, WinText, SecondsToWait, ExcludeTitle, ExcludeText]
;WinMaximize [, WinTitle, WinText, ExcludeTitle, ExcludeText]
;;WinMenuSelectItem, WinTitle, WinText, Menu [, SubMenu1, SubMenu2, SubMenu3, SubMenu4, SubMenu5, SubMenu6, ExcludeTitle, ExcludeText]
;WinMinimize [, WinTitle, WinText, ExcludeTitle, ExcludeText]
;;WinMinimizeAll
;;WinMinimizeAllUndo
;;WinMove, X, Y
;WinRestore [, WinTitle, WinText, ExcludeTitle, ExcludeText]
;WinSet, Attribute, Value [, WinTitle, WinText, ExcludeTitle, ExcludeText]
;;WinSetTitle, NewTitle
;;WinSetTitle, WinTitle, WinText, NewTitle [, ExcludeTitle, ExcludeText]
;;WinShow [, WinTitle, WinText, ExcludeTitle, ExcludeText]
;;WinWait, WinTitle, WinText, Seconds [, ExcludeTitle, ExcludeText]
;;WinWaitActive [, WinTitle, WinText, Seconds, ExcludeTitle, ExcludeText]
;;WinWaitClose, WinTitle, WinText, Seconds [, ExcludeTitle, ExcludeText]
;;WinWaitNotActive [, WinTitle, WinText, Seconds, ExcludeTitle, ExcludeText]

send {tab}^a{del} ; focus and reset
sleep 20

; ;;;;;;;;;;;;;;;;;

goto l_send_tests
			test_send:
				send %to_send%
				sleep 50
				gui submit, nohide
				if to_send_output =
					to_send_output = %to_send%
				expect = send %to_send%,gui_edit,%to_send_output%
				gosub assert
				to_send_output =
				send ^a{del}
				sleep 20
			return
l_send_tests:

to_send = 123
gosub test_send

to_send = aBc
gosub test_send

to_send = +d
to_send_output = D
gosub test_send

; issue #32
; TODO:
; to_send = @_
; gosub test_send

send {lshift down}
sleep 20
to_send = revert-modifiers
gosub test_send
GetKeyState, shift_state, lshift
expect = revert modifiers after send,shift_state,D
gosub assert
send {lshift up}

; ;;;;;;;;;;;;;;;

goto l_hotstring_tests
			test_hotstring:
				runwait xdotool type --delay=0 %hotstring_input%
				loop
				{
					x = %a_index%
					sleep 10
					gui submit, nohide
					if gui_edit = %hotstring_output%
						break
					if a_index > 50
						break
				}
				expect = hotstring %hotstring_input%,gui_edit,%hotstring_output%
				gosub assert
				send ^a{del}
				sleep 10
			return
l_hotstring_tests:

; ::testhotstringbtw::by the way
hotstring_input = .testhotstringbtw.
hotstring_output = .by the way.
gosub test_hotstring

; TODO: case detection doesn't work when input comes from xdotool but with normal typing it does
; hotstring_input = .testhotstringcAsE.
; hotstring_output = .sensitive.
; gosub test_hotstring

hotstring_input = .testhotstringcase.
hotstring_output = .testhotstringcase.
gosub test_hotstring

; :r:testhotstringraw::^a
hotstring_input = .testhotstringraw.
hotstring_output = .^a.
gosub test_hotstring

; :o:testhotstringbs::{bs}
hotstring_input = .testhotstringbs.
hotstring_output =
gosub test_hotstring

; :*:testhotstringnoendchar::immediate
hotstring_input = .testhotstringnoendchar
hotstring_output = .immediate
gosub test_hotstring

; ;;;;;;;;;;;;;;

runwait xdotool key --delay=0 ctrl+shift+alt+s
sleep 100
expect = hotkey with inline command,gui_button_clicked_success,1
gosub assert
gui_button_clicked_success =
send {tab}

goto l_hotkey_tests
			hotkey_test_success:
				hotkey_test_success = 1
			return
			test_hotkey_success:
				hotkey, %key%, hotkey_test_success
				runwait, bash -c 'xdotool %xdotool_run% --delay=0',,,,xdotool_o,xdotool_e
				sleep 50
				expect = hotkey %key%,hotkey_test_success,1
				gosub assert
				hotkey_test_success =
				hotkey, %key%, off
			return

			hotkey_test_send:
				if hokey_send_raw <>
					sendraw, %hotkey_send%
				else
					send, %hotkey_send%
			return
			test_hotkey_send:
				hotkey %key%, hotkey_test_send
				runwait, bash -c 'xdotool %xdotool_run% --delay=0',,,,xdotool_o,xdotool_e
				sleep 50
				gui submit, nohide
				if hotkey_sent =
					hotkey_sent = %hotkey_send%
				expect = hotkey with send %key%:%hokey_send_raw%:%hotkey_sent%:%xdotool_run%,gui_edit,%hotkey_sent%
				gosub assert
				hotkey, %key%, off
				hotkey_sent =
				send ^a{del}
				sleep 10
			return
l_hotkey_tests:

key = f2
xdotool_run = key F2
gosub test_hotkey_success

key = F2
xdotool_run = key F2
gosub test_hotkey_success

key = +s
xdotool_run = key shift+s
gosub test_hotkey_success

key = +S
xdotool_run = key shift+s
gosub test_hotkey_success

key = *s
xdotool_run = key shift+s
gosub test_hotkey_success

; esc and xbutton2 share the same keycode:
key = esc
xdotool_run = key Escape
gosub test_hotkey_success

key = xbutton2
xdotool_run = click 9
gosub test_hotkey_success

key = lbUTton
xdotool_run = click 1
gosub test_hotkey_success

key = a
xdotool_run = key a
hotkey_send = bcd
gosub test_hotkey_send

; This functionality works but the test doesn't because xdotool cannot reliably send
; Ctrl down and up again it seems. Same with shift. Try doing `xdotool keydown shift_l`
; in a terminal - it works but only the first time and doesn't cooperate with the keyboard.
; key = ^a
; xdotool_run = key ctrl+a
; hotkey_send = kja
; gosub test_hotkey_send

; sending itself
key = a
xdotool_run = key a
hotkey_send = abc
gosub test_hotkey_send
hotkey_send = ade
hokey_send_raw = raw
gosub test_hotkey_send
hokey_send_raw =

key = *s
hotkey_send = {blind}v
	xdotool_run = key shift+s
	hotkey_sent = V
	gosub test_hotkey_send

	xdotool_run = key s
	hotkey_sent = v
	gosub test_hotkey_send

	; TODO: somehow test {blind}: ^!s -> ^!v and ^+s => ^+v

	xdotool_run = key ctrl+s
	clipboard = clp
	hotkey_sent = clp
	gosub test_hotkey_send

; remap tests
runwait, xdotool keydown bracketleft
sleep 20
GetKeyState, bracket_state, ]
expect = remap getkeystate down,bracket_state,D
gosub assert
runwait, xdotool keyup bracketleft
sleep 20
GetKeyState, bracket_state, ]
expect = remap getkeystate up,bracket_state,U
gosub assert
send ^a{del}
sleep 10

; ;;;;;;;;;;

Send, {LButTon}
sleep 50
expect = send {lbutton},gui_button_clicked_success,1
gosub assert
gui_button_clicked_success =

clipboard = clp
MouseClick, R, 62, 81 ; Context menu of text field
sleep 20
send p ; paste
sleep 100
gui submit, nohide
expect = clipboard paste,gui_edit,clp
gosub assert
send ^a{del}
sleep 10

Clipboard =
expect = clipboard unsetting,clipboard,
gosub assert

send clp-del-test
sleep 10
Clipboard =
Send, ^a^c
ClipWait, 1
expect = clipboard unsetting race condition,clipboard,clp-del-test
gosub assert
send ^a{del}
sleep 10

; Tests missing / need manual testing for now:
; - Vimium Everywhere with FF Context Menus

Return

; ### ### ###

; TODO: hotstring with _ in it doesn't work
::testhotstringbtw::by the way
:C:testhotstringcAsE::sensitive
:r:testhotstringraw::^a
:o:testhotstringbs::{bs}
:*:testhotstringnoendchar::immediate

^+!s::MouseClick, L

[::]

noop:
return
