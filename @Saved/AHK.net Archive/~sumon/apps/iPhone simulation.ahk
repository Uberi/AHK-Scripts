/*
	< iPhone Simulation >
	Author: Simon Strålberg [sumon @ Autohotkey forums, simon . stralberg @ gmail . com]
	Autohotkey version: AHK_L (Unicode, x32)

	LICENSE: If no license documentation exists, [http://www.autohotkey.net/~sumon/license.html]
	Script created using Autohotkey [http://www.autohotkey.com]
	
*/
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.

SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
SetTitleMatchmode, 2
#SingleInstance, Force

/*****************
** Autoexecute  **
******************
*/

FileCreateDir, Apps
If (!FileExist("iphone.png"))
	UrlDownloadToFile, http://autohotkey.net/~sumon/img/iphone.png, iphone.png

Loop, Apps\*.*
{
	If (A_index = 1 AND !A_LoopFileFullPath)
		MsgBox, 48, Add apps, In order to launch applications`, put shortcut (.lnk) or executable files (.exe) in the \Apps directory
	If (A_LoopFileExt = "lnk")
		FileGetShortcut, %A_LoopFileFullPath%, App%A_Index%
	else
		App%A_Index% := A_LoopFileFullPath
}

NumpadAdd & NumPadEnter::
Gosub, iGui
return

#IfWinActive, iPhone simulation
Numpad1:: Gosub, Run
Numpad2:: Gosub, Run
Numpad3:: Gosub, Run
Numpad4:: Gosub, Run
Numpad5:: Gosub, Run
Numpad6:: Gosub, Run
Numpad7:: Gosub, Run
Numpad8:: Gosub, Run
Numpad9:: Gosub, Run
Esc:: Gui, Destroy
/****************
** Subroutines **
*****************
*/

/***************
**    GUI     **
****************
*/

iGui:
Gui, Destroy
AppN := 0
Gui, Add, Pic,, iphone.png
Loop, 3 ; 1 row at the time
{
	y := 190 + (A_Index-1)* 138
	Loop, 3 ; Three items
	{
		++appN
		x := 90 + (A_Index-1)*138
		if (App%appN%)
			Gui, Add, Pic, x%x% y%y% w128 h128 BackgroundTrans vRunApp%AppN% gRun, % App%AppN%
	}
}
Gui, Color, 385ec0
Gui, -Caption +LastFound +toolWindow
Gui, Show

hwnd1 := WinExist()
WinSet, TransColor, 385ec0
return

Run:
If (A_GuiControl)
{
	AppR := SubStr(A_GuiControl, 7)
}
else if (StrLen(A_ThisHotkey) < 8)
	AppR := SubStr(A_ThisHotkey, 7)
; Below line transforms from 1-9 (numerics) to 7-3 (numpad), if was triggered by hotkey
If (!A_GuiControl)
	AppR := (AppR = 1) ? 7 : (AppR = 2) ? 8 : (AppR = 3) ? 9 : (AppR = 7) ? 1 : (AppR = 8) ? 2 : (AppR = 9) ? 3 : AppR
Gui, Destroy
If (FileExist(App%AppR%))
	Run, % App%AppR%
else
	MsgBox, 16, App does not exist, There is no such file 
return

/***************
**Installation**
****************
*/

/***************
** Functions  **
****************
*/