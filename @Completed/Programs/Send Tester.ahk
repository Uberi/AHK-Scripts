#NoEnv

;ensure script is run as administrator
If !A_IsAdmin
{
    Run, *RunAs "%A_ScriptFullPath%"
    ExitApp
}

DetectHiddenWindows, On
SetTitleMatchMode, 2

ToolTip, Right click on the window to be tested.
KeyWait, RButton, D
KeyWait, RButton
ToolTip
MouseGetPos,,, hWindow

Gui, Font, s12 Bold, Arial
Gui, Add, GroupBox, x10 y10 w270 h140, Settings
Gui, Add, GroupBox, x290 y10 w220 h180, About

Gui, Font, s10 Norm
Gui, Add, Text, x20 y30 w110 h20, Sleep time (ms):
Gui, Add, Text, x20 y60 w110 h20, Keys to send:
Gui, Add, Text, x20 y90 w110 h20, Click position X:
Gui, Add, Text, x20 y120 w110 h20, Click position Y:

Gui, Add, Edit, x130 y30 w140 h20 Center Number vWaitTime, 2000
Gui, Add, Edit, x130 y60 w140 h20 Center vSendKeys, wasd
Gui, Add, Edit, x130 y90 w140 h20 vMouseX Center Number, 100
Gui, Add, Edit, x130 y120 w140 h20 vMouseY Center Number, 100

Gui, Add, Text, x300 y30 w200 h150, This script tests different commands to help determine which work best in certain applications.`n`nOriginally written by Snow Flake, fixed by Uberi.

Gui, Font, Bold
Gui, Add, Button, x10 y160 w130 h30 Default gClickTest, Start click test
Gui, Add, Button, x150 y160 w130 h30 gSendTest, Start send test

Gui, Show, w520 h200, Send Tester
Return

Esc::
GuiEscape:
GuiClose:
ExitApp

ClickTest:
Gui, Submit
WinActivate, ahk_id %hWindow%

ToolTip, Testing Click, 0, 0
Click, %MouseX%, %MouseY%, 100
Sleep, WaitTime

ToolTip, Testing MouseClick,0,0
MouseClick, Left, %MouseX%, %MouseY%
Sleep, WaitTime

ToolTip, Testing MouseClickDrag,0,0
MouseClickDrag, Left, MouseX, MouseY, MouseX, MouseY, 0
Sleep, WaitTime

ToolTip, Testing ControlClick,0,0
ControlClick, x%MouseX% y%MouseY%, ahk_id %hWindow%, Left
Sleep, WaitTime

ToolTip, Testing Send Click,0,0
Send, {Click %MouseX%, %MouseY%}
Sleep, WaitTime

ToolTip, Testing SendPlay Click,0,0
SendPlay, {LButton}
Sleep, WaitTime

ToolTip, Testing SendEvent Click,0,0
SendEvent, {LButton}
Sleep, WaitTime

ToolTip, Testing SendInput Click,0,0
SendInput, {LButton}
Sleep, WaitTime

ToolTip, Testing ControlSend Click,0,0
ControlSend,, {Click %MouseX%, %MouseY%}, ahk_id %hWindow%
Sleep, WaitTime

ToolTip, Testing PostMessage Click,0,0
PostMessage, 0x201, 0x1, MouseX | (MouseY << 16),, ahk_id %hWindow% ;WM_LBUTTONDOWN, MK_LBUTTON
Sleep, 500
PostMessage, 0x202, 0x0, MouseX | (MouseY << 16),, ahk_id %hWindow% ;WM_LBUTTONUP
Sleep, WaitTime

ToolTip, Testing SendMessage Click,0,0
SendMessage, 0x201, 0x1, MouseX | (MouseY << 16),, ahk_id %hWindow% ;WM_LBUTTONDOWN, MK_LBUTTON
Sleep, 500
SendMessage, 0x202, 0x0, MouseX | (MouseY << 16),, ahk_id %hWindow% ;WM_LBUTTONUP
Sleep, WaitTime

ToolTip, Testing ControlFocus Click,0,0
ControlFocus, x%MouseX% y%MouseY%, ahk_id %hWindow%
Sleep, WaitTime

ToolTip, Testing DllCall mouse_event,0,0
DllCall("mouse_event","UInt",0x8002,"Int",MouseX,"Int",MouseY,"UInt",0,"UPtr",0) ;MOUSEEVENTF_ABSOLUTE | MOUSEEVENTF_LEFTDOWN
Sleep, 500
DllCall("mouse_event","UInt",0x8004,"Int",MouseX,"Int",MouseY,"UInt",0,"UPtr",0) ;MOUSEEVENTF_ABSOLUTE | MOUSEEVENTF_LEFTUP
Sleep, WaitTime

ToolTip
Gui, Show
Return

SendTest:
Gui, Submit
WinActivate, ahk_id %hWindow%

ToolTip, Testing SendInput,0,0
SendInput, %SendKeys%
Sleep, WaitTime

ToolTip, Testing SendPlay,0,0
SendPlay, %SendKeys%
Sleep, WaitTime

ToolTip, Testing SendEvent,0,0
SendEvent, %SendKeys%
Sleep, WaitTime

ToolTip, Testing ControlSend,0,0
ControlSend,,%SendKeys%, ahk_id %hWindow%
Sleep, WaitTime

ToolTip, Testing DllCall keybd_event (will send 9),0,0
DllCall("keybd_event","Int",GetKeyVK(SubStr(SendKeys,1,1)),"Int",GetKeySC(SubStr(SendKeys,1,1)),"Int",0,"UPtr",0)
Sleep, 500
DllCall("keybd_event","Int",GetKeyVK(SubStr(SendKeys,1,1)),"Int",GetKeySC(SubStr(SendKeys,1,1)),"Int",2,"UPtr",0) ;KEYEVENTF_KEYUP
Sleep, WaitTime

ToolTip, Testing WScript, 0, 0
ComObjCreate("wscript.shell").SendKeys(SendKeys)
Sleep, WaitTime

ToolTip
Gui, Show
Return