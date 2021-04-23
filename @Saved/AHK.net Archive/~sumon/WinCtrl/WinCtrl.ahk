; ******* General ******* 
; < WinCtrl >
ScriptVersion := 0.7
; Script created using Autohotkey (http://www.autohotkey.com)
; AHK version: AHK_L
; Dependencies: 
;
; AUTHOR: sumon @ the Autohotkey forums, < simon.stralberg (@) gmail.com>
; SPECIAL THANKS: Nimda for Windows Warrior < http://www.autohotkey.com/forum/viewtopic.php?t=70001 >
; CHANGELOG:
; || To-do ||
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance, Force
IfNotExist, data\ico\on_top.ico
	Gosub, Install
#NoTrayIcon
; Define menu
Menu, ControlMenu, Add, Always on top, Alwaysontop
	Menu, ControlMenu, Icon, Always on top, %A_ScriptDir%\data\ico\on_top.ico,, 32
Menu, ControlMenu, Add, Info, Info
	Menu, ControlMenu, Icon, Info, %A_ScriptDir%\data\ico\info.ico,, 32
; Positions
ini_load(WinCtrlPositions, "data\WinCtrlPositions.ini")
SectionNames := ini_getAllSectionNames(WinCtrlPositions)
Loop, Parse, SectionNames, `,
{
Menu, Positions, Add, %A_LoopField%, Position
}
Menu, Positions, Add
Menu, Positions, Add, Add Position, AddPosition
	Menu, Positions, Icon, Add Position, data\ico\add.ico,, 16
Menu, Positions, Add, Manage Position(s), ManagePositions
	Menu, Positions, Icon, Manage Position(s), data\ico\config.ico,, 16
; <--
Menu, ControlMenu, Add, Position, :Positions
	Menu, ControlMenu, Icon, Position, %A_ScriptDir%\data\ico\position.ico,, 32
Menu, ControlMenu, Add, Transparent, Transparent
	Menu, ControlMenu, Icon, Transparent, %A_ScriptDir%\data\ico\transparent.ico,, 32
Menu, ControlMenu, Show
Gosub, Exit
return
AlwaysOnTop:
WinGetActiveTitle, Win
WinSet, AlwaysOnTop, Toggle, %Win%
Gosub, Exit
return

Info:
WinGetActiveTitle, Win
WinGet, ID, ID, %Win%
WinGet, PID, PID, %Win%
WinGet, ProcessName, ProcessName, %Win%
WinGetClass, Class, %Win%
Title := Win
Notify("Window info:", "Title: " . Title . "`nClass: " . Class . "`nID: " . ID . "`nProcess: " . ProcessName . "`nPID: " . PID, 8)
Sleep 8000
Gosub, Exit
return
Position:
WinGetActiveTitle, Win
IniRead, X, data\WinCtrlPositions.ini, %A_ThisMenuItem%, X, 0
IniRead, Y, data\WinCtrlPositions.ini, %A_ThisMenuItem%, Y, 0
IniRead, W, data\WinCtrlPositions.ini, %A_ThisMenuItem%, W, 400
IniRead, H, data\WinCtrlPositions.ini, %A_ThisMenuItem%, H, 300
WinMove, %Win%,, %x%, %y%, %w%, %h%
Gosub, Exit
return

AddPosition:
TrayTip,, Please drag a box for your new position, 4
KeyWait, LButton, Down
CoordMode, Mouse ,Screen
MouseGetPos, MX, MY
Gui, +AlwaysOnTop -caption +Border +ToolWindow +LastFound
WinSet, Transparent, 80
Gui, Color, c0edeb

While, (GetKeyState("lbutton", "p"))
{
   MouseGetPos, MXend, MYend
   Send {control up}
   w := abs(MX - MXend)
   h := abs(MY - MYend)
   If ( MX < MXend )
   X := MX
   Else
   X := MXend
   If ( MY < MYend )
   Y := MY
   Else
   Y := MYend
   Gui, Show, x%X% y%Y% w%w% h%h%
   Sleep, 10
}
MouseGetPos, MXend, MYend
;~ Traytip,, %Mx%:%My% to %MxEnd%:%MYEnd%, 4
;~ Traytip,, x:%x% y:%y% w:%w% h:%h%, 4
Traytip,, Please enter position name`,`nthen press < Enter >, 6
gui, font, s24, Verdana 
Gui, Add, Edit, vName w200, Position X
Gui, Show, x%X% y%Y% w%w% h%h%
KeyWait, Enter, Down
Gui, Submit
IniWrite, %x%, data\WinCtrlPositions.ini, %Name%, X
IniWrite, %y%, data\WinCtrlPositions.ini, %Name%, Y
IniWrite, %w%, data\WinCtrlPositions.ini, %Name%, W
IniWrite, %h%, data\WinCtrlPositions.ini, %Name%, H
Gosub, Exit
return

ManagePositions:
MsgBox Not yet implemented. For now`, you can edit the file data\WinCtrlPositions.ini to change or delete positions.
return


Transparent:
WinGetActiveTitle, Win
WinGet, TransX, Transparent, %Win%
If (TransX > 1) ; ie "Has transparency"
	WinSet, Trans, Off, %Win%
else
	WinSet, Trans, 150, %Win%
Gosub, Exit
return
Install:
Gui, 33:Default
gui, font, s10, Verdana  ; Set 10-point Verdana.
Gui, Add, Text,, This is the first time you run WinCtrl! `n`nExtract data to "/data" directory?
Gui, Add, Button, x10 w125 h40 gInstallFiles default, Sure!
Gui, Add, Button, x135 w125 yp h40 gExit, No thanks!
Gui, -Caption +Border
Gui, Color, ffFFff
Gui, Show
Sleep 30000
Return
;~ return

InstallFiles:
Gui, 33: Destroy
FileCreateDir, data
FileCreateDir, data\ico
FileInstall, data\WinCtrlPositions.ini, data\WinCtrlPositions.ini
FileInstall, data\ico\add.ico, data\ico\add.ico
FileInstall, data\ico\config.ico, data\ico\config.ico
FileInstall, data\ico\info.ico, data\ico\info.ico
FileInstall, data\ico\on_top.ico, data\ico\on_top.ico
FileInstall, data\ico\position.ico, data\ico\position.ico
FileInstall, data\ico\transparent.ico, data\ico\transparent.ico
return

Exit:
ExitApp
return