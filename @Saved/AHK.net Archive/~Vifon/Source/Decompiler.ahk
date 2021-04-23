#NoEnv
SendMode Input
SetWorkingDir %A_Desktop%
#NoTrayIcon


Gui, Add, Edit, x16 y29 w320 h r1 vfile, 
Gui, Add, Edit, x16 y79 w320 h21 r1 vpass password, 
Gui, Add, Button, x26 y109 w100 h30 , OK
Gui, Add, Button, x146 y109 w100 h30 , Cancel
Gui, Add, Checkbox, x286 y109 w100 h30 vPass1 gPassCheck, Password?
Gui, Add, Text, x16 y9 w250 h20 , File:
Gui, Add, Text, x16 y59 w250 h20, Password:
Gui, Add, Button, x346 y29 w60 h20 gBrowse, Browse...
GuiControl Disable, pass

Gui, Show, x410 y319 h160 w426, AHK Decompiler
Return

ButtonCancel:
ExitApp

ButtonOK:
Gui Submit
if PassCheck = 0
{
	Run C:\Program Files\AutoHotkey\Compiler\Exe2Ahk.exe "%file%"
}
else
{
	Run C:\Program Files\AutoHotkey\Compiler\Exe2Ahk.exe "%file%" "%pass%"
}
ExitApp

Browse:
FileSelectFile path, 1, %A_AhkPath%,, *.exe
if ErrorLevel
{
	Return
}
GuiControl Text, Edit1, %path%
Return

PassCheck:
Gui Submit, NoHide
if Pass1 = 1
{
	GuiControl Enable, pass
}
else
{
	GuiControl Disable, pass
}
Return

GuiDropFiles:
IfInString A_GuiEvent, .exe
	GuiControl Text, file, %A_GuiEvent%
Return

GuiClose:
ExitApp
