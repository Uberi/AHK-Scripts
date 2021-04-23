#SingleInstance Force
#NoEnv
;SetBatchlines -1

FileIsSaved=1

shellnew_dir=%A_WinDir%\ShellNew\
if !InStr(FileExist(shellnew_dir), "D")
    FileCreateDir, %shellnew_dir%
if errorlevel
{
    msgbox,16,Error, Couldn't create directory (%shellnew_dir%). Exiting!
    Exitapp
}
shellnew_filename:=shellnew_dir . "Template.ahk"
if FileExist(shellnew_filename)
    FileRead, shellnew_filedata, %shellnew_filename%
else
    FileAppend ,, %shellnew_filename%


Gui, +resize
Gui, Add, Edit, r20 w300 vshellnew_filedata +HScroll gl_DataChange, %shellnew_filedata%
Gui, Add, Button, r1 w300 vSaveButton gl_saveroutine, Save
Gui, Show, ,AHK Template Script Creator
Gui, +Lastfound
GuiHwnd:=WinExist()
return



l_DataChange:
    if FileIsSaved
        FileSavedStatus(1)
return

#IfWinActive , AHK Template Script Creator
^s::
l_saveroutine:
    if FileExist(shellnew_filename)
    {
        FileDelete, %shellnew_filename%
        if errorlevel
        {
            msgbox,16,Error, Couldn't overwrite (%shellnew_filename%). Please close all other processes that are using this file first.
            Return
        }
    }
    Gui, Submit, Nohide
    FileAppend , %shellnew_filedata%, %shellnew_filename%
    if !FileIsSaved && !Errorlevel
        FileSavedStatus(0)
        
    RegRead, shellnew_shellname, HKCR, .ahk
    if !shellnew_shellname
        RegWrite, REG_SZ, HKCR, .ahk , , AutoHotkey Script
    RegWrite, REG_SZ, HKCR, .ahk\ShellNew , FileName, Template.ahk
return



FileSavedStatus(x="")
{
    global GuiHwnd, FileIsSaved
    WinGetTitle, WinTitle , ahk_id %GuiHwnd%
    if x=
        return (SubStr(WinTitle, -1) = " *")
    if x=1
        if (SubStr(WinTitle, -1) = " *")
            return
        else
        {
            WinSetTitle, ahk_id %GuiHwnd%,, % WinTitle . " *"
            FileIsSaved=0
        }
    else if x=0
        if !(SubStr(WinTitle, -1) = " *")
            return
        else
        {
            WinSetTitle, ahk_id %GuiHwnd%,, % SubStr(WinTitle, 1,(StrLen(WinTitle)-2))
            FileIsSaved=1
        }
}

GuiSize:
Anchor("shellnew_filedata", "wh")
Anchor("SaveButton", "wy")
return

Anchor(ctrl, a, draw = false) { ; v3.4.2 - Titan
	static d
	GuiControlGet, p, Pos, %ctrl%
	If !A_Gui or ErrorLevel
		Return
	s = `n%A_Gui%:%ctrl%=
	c = x.w.y.h./.7.%A_GuiWidth%.%A_GuiHeight%
	StringSplit, c, c, .
	Loop, 4
		b%A_Index% += !RegExMatch(a, c%A_Index% . "(?P<" . A_Index . ">[\d.]+)", b)
	If !InStr(d, s)
		d := d . s . px - c7 * b1 . c5 . pw - c7 * b2
			. c5 . py - c8 * b3 . c5 . ph - c8 * b4 . c5
	Loop, 4
		If InStr(a, c%A_Index%) {
			i = %A_Index%
			c6 += !cx and (cx := i > 2)
			RegExMatch(d, s . "(?:(-?[\d.]+)/){" . i . "}", p)
			m := m . c%i% . p1 + c%c6% * b%i%
		}
	If draw
		t = Draw
	GuiControl, Move%t%, %ctrl%, %m%
}

GuiClose:
exitapp