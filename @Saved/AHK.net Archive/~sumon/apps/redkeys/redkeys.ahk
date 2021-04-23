/*
	< Redkeys >
	Version: 0.1
	Author: sumon
	Autohotkey version: AHK_L (Unicode, x32)
	Dependencies:
		- cIni by zzzooo10 [http://www.autohotkey.com/forum/viewtopic.php?p=462061#462061]
		
	CHANGELOG:
	v.
		- 0.1 initial "conceptual" release
	
	To-DO:
		- Fix the Browse: command (f.ex. it needs to wait til hotkey is released before Sending)
	
	INPUT COMMANDS: 
		MsgBox: Msg (Displays MsgBox with Msg)
		Run: Arg (Runs the argument)
		Browse: URL (Tries to visit the URL)
		Send: Keys (Send)
		SendRaw: Text (SendRaw)
		Exit: PID (Closes the process by PID, A or [This] to close active process)
		DisplayHotkeys:

	LICENSE: If no license documentation exists, [http://www.autohotkey.net/~sumon/license.html]
	Script created using Autohotkey [http://www.autohotkey.com]
	
*/
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance, Force

/*****************
** Autoexecute  **
******************
*/
Red := cIni("redkeys.ini")
If FileExist("redkeys.ico")
	Menu, Tray, Icon, redkeys.ico

#If Win := (CheckWindows(Red) ? CheckWindows(Red) : "Global")
Hotkey, If, Win := (CheckWindows(Red) ? CheckWindows(Red) : "Global") ; Dynamic hotkeys also depend on #if now

for Window in Red
	for hotkey, action in Red[Window]
		If (action)
			Hotkey, %hotkey%, Hotkey
return

/*****************
** Hotkeys  **
******************
*/

Hotkey: 
If !Red[Win][A_ThisHotkey] ; If active window has no hotkey associated
	Win := "Global" ; Must have been triggered by global hotkey

; MsgBox:Msg
If RegExMatch(Red[win][A_ThisHotkey], "MsgBox:(.*)", Out)
	MsgBox %Out1%

; Run:Arg
If RegExMatch(Red[Win][A_ThisHotkey], "Run:(.*)", Out)
	Run %Out1%

; Send:Keys
else if RegExMatch(Red[Win][A_ThisHotkey], "Send:(.*)", Out)
	Send %Out1%

; SendRaw:Text
else if RegExMatch(Red[Win][A_ThisHotkey], "SendRaw:(.*)", Out)
	SendRaw %Out1%
	
; Browse:URL
else if RegExMatch(Red[Win][A_ThisHotkey], "Browse:(.*)", Out)
{
	Run, %Out1% ; Must be edited/improved for "Active browser" etc.
}

; Exit:PID
else RegExMatch(Red[Win][A_ThisHotkey], "Exit:(.*)", Out)
	If (Out1 = "A" || Out1 = "[This]")
	{
		WinGet, ID, PID, A
		Process, Close, %ID%
	}
	else
	{
		Process, Close, %Out1%
	}


; DisplayHotkeys:
if RegExMatch(Red[Win][A_ThisHotkey], "DisplayHotkeys:")
{	
	WinGetClass, ActiveClass, A
	Gui, DisplayHotkeys:Default
	Gui, Destroy
	Gui, +AlwaysOnTop +LastFound
	Gui, Color, EA5246j
	gui, font, s12 c232323 w700, Arial
	Gui, Add, Text, x10, Displaying hotkeys for %ActiveClass%
	gui, font, s12 c232323 w400, Arial
	
	for key, val in Red[ActiveClass]
		if (hasVal := val)
		Gui, Add, Text, x10 yp+30, { %Key% } %Val%
	
	Gui, Show, % "w400 h240 x" A_ScreenWidth - 440 " y" A_ScreenHeight - 320 " NoActivate", Redkeys for %ActiveClass%
	hwndDisplayHotkeys := WinExist()
}
return
#If

/****************
** Exit **
*****************
*/

~Esc:: 
Gui, DisplayHotkeys: Destroy
return

#Esc:: 
ExitApp

/***************
** Functions  **
****************
*/

CheckWindows(RedWindows)
{
	for key, val in RedWindows
		If WinActive("ahk_class " key)
			return key
}