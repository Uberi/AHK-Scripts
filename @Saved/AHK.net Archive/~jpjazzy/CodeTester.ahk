SetTitleMatchMode, 2 
OnExit, GuiClose ; On exit, clean up
GuiShowFlag := 1 ; Flag to hide or show the GUI

Gui, Add, Edit, x22 y60 w440 h270 vTempCode WantCtrlA, Input code here
Gui, Font, S10 CDefault Bold, Times New Roman
Gui, Add, Text, x92 y10 w290 h40 +Center, Input Test Code
Gui, Add, Button, x362 y330 w100 h30 gTestTempCode, Test code			;GUI GENERATION
Gui, Add, Button, x262 y330 w100 h30 gEndTest, End testcode
Gui, Add, Button, x22 y330 w100 h30 gClearTempCode, Clear code
Gui, Show, x127 y87 h379 w479, RealTime Code tester
Return

$F1::
KeyWait, F1, T.5
If !ErrorLevel
{
	Send, {F1}
	return
}
If (GuiShowFlag = 1)
{
	Gui, Hide
	GuiShowFlag--
}
Else If (GuiShowFlag = 0)
{
	Gui, Show
	GuiShowFlag++
}
KeyWait, F1
return

$F11::			; HOTKEY TO END TEST
KeyWait, F11, T1
If !ErrorLevel
{
	Send, {F11}
	return
}
EndTest:
PostMessage("Slave script", 1)   ; exits/deletes slave script
TrayTip, Status:, Test code ended and deleted.
KeyWait, F11
return

ClearTempCode:
GuiControl,, TempCode,
return

GuiClose:
PostMessage("Slave script", 1)   ; exits/deletes slave script
ExitApp

$F12::			; HOTKEY TO TEST HIGHLIGHTED CODE
KeyWait, F12, T1
If !ErrorLevel
{
	Send, {F12}
	return
}
GuiControl,, TempCode,
Sleep 200
Clipsave := ClipboardAll
Send, ^c
GuiControl,, TempCode, %Clipboard%
Clipboard := Clipsave
TestTempCode:
DetectHiddenWindows, On
If Winexist("TempTestCode.ahk") ; If the test code is running close it before running a new one.
{
	PostMessage("Slave script", 1)   ; exits/deletes slave script
}
DetectHiddenWindows, Off

Gui, Submit, NoHide
FileAppend, 
(
#Persistent
#SingleInstance, Force
Progress, m2 b fs13 Y0 zh0 WMn700, Test script is running
Gui 99: show, hide, Slave script ; hidden message receiver window
OnMessage(0x1001,"ReceiveMessage")
%TempCode%
return

ReceiveMessage(Message) {
   if Message = 1
   ExitApp
}
), %A_ScriptDir%\TempTestCode.ahk
Run, %A_ProgramFiles%\AutoHotkey\AutoHotkey.exe "%A_ScriptDir%\TempTestCode.ahk" ; run script
Sleep, 100
IfWinExist, ahk_class #32770		; IF THERE IS AN ERROR LOADING THE SCRIPT SHOW THE USER
{
	Sleep 20
	WinActivate, ahk_class #32770
	Clipsave := ClipboardAll
	Send, ^c
	CheckWin := Clipboard
	Clipboard := Clipsave
	IfInString, CheckWin, The program will exit.
	{
	IfExist, %A_ScriptDir%\TempTestCode.ahk
	FileDelete, %A_ScriptDir%\TempTestCode.ahk
	TrayTip, ERROR, Error executing the code properly
	return
	}
}
TrayTip, Status:, Test code is now running on your machine.
return

; ===================================================== FUNCTIONS ==================================================
PostMessage(Receiver, Message) {                                    
   oldTMM := A_TitleMatchMode, oldDHW := A_DetectHiddenWindows
   SetTitleMatchMode, 3
   DetectHiddenWindows, on
   PostMessage, 0x1001,%Message%,,, %Receiver% ahk_class AutoHotkeyGUI
   SetTitleMatchMode, %oldTMM%                                              ; POST MESSAGE TO END THE TEST SCRIPT AND DELETE IT
   DetectHiddenWindows, %oldDHW%                                                ; Thank you to learning one for this example function
   IfExist, %A_ScriptDir%\TempTestCode.ahk
   FileDelete, %A_ScriptDir%\TempTestCode.ahk
}