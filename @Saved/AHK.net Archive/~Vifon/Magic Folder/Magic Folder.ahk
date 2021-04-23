/*
	Author:	Vifon
	Email:	http://scr.im/Vifon
	Name:		Magic Folder
*/

#NoEnv
#NoTrayIcon
#SingleInstance off
#Persistent
#Include ToolTip.ahk
SetWorkingDir %A_ScriptDir%
CoordMode Menu, Screen

if !FileExist("cfgLocation.mf")
{
	MsgBox 35, Magic Folder, Press "yes" if you want a normal install - config files will be stored in Windows' AppData folder. Each user can have separate settings.`n`nPress "no" if you want a traditional install - config files will be stored in program's folder (like in pre-5.0 versions).`n`nTo change it later, delete hidden file "cfgLocation.mf".
	ifMsgBox yes
		FileAppend 1, cfgLocation.mf
	else ifMsgBox no
		FileAppend 0, cfgLocation.mf
	else
		ExitApp
	FileSetAttrib +H, cfgLocation.mf
	Reload
	sleep 20000 ; without this, script goes further regardless of Reload
}

if FileRead("cfgLocation.mf")
{
	if !FileExist(A_AppData "\Magic Folder")
		FileCreateDir %A_AppData%\Magic Folder
	SetWorkingDir %A_AppData%\Magic Folder
}

SetBatchLines -1


IniRead MagicFolder, Magic Folder.ini, Path, Magic Folder, %A_Space%
IniRead posX, Magic Folder.ini, Misc, X, %A_Space%
IniRead posY, Magic Folder.ini, Misc, Y, %A_Space%
IniRead folderSort, Magic Folder.ini, Misc, FolderSort, 0
IniRead ShortSubMenu, Magic Folder.ini, Misc, ShortcutsAsMenu, 1
IniRead Alt, Magic Folder.ini, Alternative, Alternative, 0
IniRead Dropbox, Magic Folder.ini, Alternative, Dropbox, 0
IniRead AltPath, Magic Folder.ini, Path, Alternative, %A_Space%
IniRead PubNr, Magic Folder.ini, Alternative, Public Number, %A_Space%
IniRead Invert, Magic Folder.ini, Alternative, Invert, 0
IniRead Restore, Magic Folder.ini, Restore, Restore, 0
IniRead rCount, Magic Folder.ini, Restore, Count, 10
if !MagicFolder
{
	Goto Settings
}

Loop Read, Custom.txt
{
	StringSplit custArray, A_LoopReadLine, |
	cust%custArray1% := custArray2
}
;====================End of Configuration Section====================


if 0 = 0		; If no files drag'n'dropped
{
	Loop %MagicFolder%\*, 1
	{
		FileRemoveDir %A_LoopFileLongPath%, 0 ; Remove empty dirs
	}
	Loop %MagicFolder%\*, 1
	{
		name%A_Index% := A_LoopFileName
		folder%A_Index% := A_LoopFileLongPath
		Menu Magic, Add, % name%A_Index%, Open
	}
	if (FileExist("Shortcuts.txt") || Alt)
		Menu Magic, Add

	Loop Read, Shortcuts.txt
	{
		StringSplit sMenuArray%A_Index%_, A_LoopReadLine, |
		if ShortSubMenu
			Menu Shortcuts, Add, % sMenuArray%A_Index%_1, ShortcutOpen
		else
			Menu Magic, Add, % sMenuArray%A_Index%_1, ShortcutOpen
	}
	if (FileExist("Shortcuts.txt") && ShortSubMenu)
		Menu Magic, Add, Shortcuts, :Shortcuts
	if Alt
	{
		if Dropbox
		{
			Menu Magic, Add, Dropbox, Alternative
			if A_IsCompiled
				Menu Magic, Icon, Dropbox, %A_ScriptFullPath%, -206	;If you are not using AutoHotkey_L, delete this line
		}
		else
		{
			Menu Magic, Add, Alternative Folder, Alternative
		}
	}
	Menu Magic, Add
	Menu Magic, Add, Settings
	Menu Magic, Add, Just open this crap already!, Crap
	if (posX && posY)
		Menu Magic, Show, %posX%, %posY%
	else
		Menu Magic, Show
	if !Settings
		ExitApp
	else
		Exit
}


curDate = %A_YYYY%-%A_MM%-%A_DD%@%A_Hour%%A_Min%

if (Alt && GetKeyState("ScrollLock", "T") != Invert)
{
	if Dropbox
	{
		tX := A_ScreenWidth / 2 - (162 / 2)
		tY := A_ScreenHeight / 2 - (52 / 2)
		ToolTip("1", "Files moved to Dropbox!", "Magic Folder", "I2 X" tX " Y" tY " BFF8686")
	}
	else
	{
		tX := A_ScreenWidth / 2 - (200 / 2)
		tY := A_ScreenHeight / 2 - (52 / 2)
		ToolTip("1", "Files moved to your alternative folder!", "Magic Folder", "I2 X" tX " Y" tY " BFF8686")
	}
	SetTimer ToolTipOff, 2000
	if (Dropbox && PubNr)
		Clipboard := ""
	Loop %0%
	{
		SplitPath %A_Index%, OutFileName
		MagicMove(%A_Index%, OutFileName, "", 1, Dropbox)
	}
	RestoreClean(rCount)
	if (folderCheck && fileCheck)
		DllCall("Shell32.dll\SHChangeNotify", "UInt", "0x8000000", "UInt", 0, "IntP", 0, "IntP", 0) ; refresh all windows
	if (Dropbox && PubNr)
		Clipboard := SubStr(Clipboard, 1, -1)
	sleep 1000
	ToolTip("1")
	ExitApp
}
else


{	
	Loop %0%
	{
		SplitPath %A_Index%, OutFileName,, OutExt
		if (!OutExt && !isFolder(%A_Index%))
		{
			MsgBox 4112, ERROR!, Sorry`, files without extensions are not supported.
			Continue
		}
		else
			MagicMove(%A_Index%, OutFileName, OutExt)
	}
	RestoreClean(rCount)
	if (folderCheck && fileCheck)
		DllCall("Shell32.dll\SHChangeNotify", "UInt", "0x8000000", "UInt", 0, "IntP", 0, "IntP", 0) ; refresh all windows
	ExitApp
}

/*
file = original path
name = name + ext
ext = ext
*/
MagicMove(file, name, ext, alt = 0, drop = 0)
{
	global
	local Destination, RegExArray0, RegExArray1, RegExArray2
	if isFolder(file)
	{
		folderCheck := true
		if folderSort
		{
			Loop % file "\*.*", 1
				MagicMove(A_LoopFileFullPath, A_LoopFileName, A_LoopFileExt, alt, drop)
			FileRemoveDir %file%
			Return
		}
		else
		{
			if !alt
				Destination := MagicFolder . "\.folders"
			else
				Destination := AltPath
			if !FileExist(Destination)
				FileCreateDir % Destination
			FileMoveDir % file, % Destination "\" name
			if ErrorLevel
			{
				if FileExist(Destination "\" name)
				{
					MsgBox 4132, Magic Folder, Folder "%name%" already exists. Merge?
					ifMsgBox Yes
					{
						FileMoveDir % file, % Destination "\" name, 2
					}
				}
			}
			if ErrorLevel
			{
				MsgBox 4112, Magic Folder, ERROR! Folder "%name%" was not moved!
				Return
			}
		}
	}
	else
	{
		fileCheck := true
		if !alt
		{
			Loop Read, RegEx.txt
			{
				StringSplit RegExArray, A_LoopReadLine, "
				if RegExMatch(name, RegExArray1)
				{
					Destination := RegExArray2
					Goto RegExSkip
				}
			}
			if !(cust%ext%)
			{
				if !(cust#)
				{
					Destination := MagicFolder . "\" . StringLower(ext)
				}
				else
				{
					Destination := cust#
				}
			}
			else
				Destination := cust%ext%
		}
		else
			Destination := AltPath
		RegExSkip:
		if !FileExist(Destination)
			FileCreateDir %Destination%
		FileMove %file%, %Destination%
		if ErrorLevel
		{
			if FileExist(Destination "\" name)
			{
				MsgBox 4132, Magic Folder, Overwrite file "%name%"?
				ifMsgBox Yes
				{
					FileMove %file%, %Destination%\%name%, 1
					if Errorlevel
					{
						MsgBox 4112, Magic Folder, ERROR! File "%name%" was not moved!
						Return
					}
				}
				else
					Return
			}
			else
			{
				MsgBox 4112, Magic Folder, ERROR! File "%name%" was not moved!
				Return
			}
		}
	}
	if (drop && PubNr && !isFolder(Destination "\" name))
		Clipboard .= "http://dl.dropbox.com/u/" PubNr "/" RegExReplace(name, A_Space, "%20") "`n"
	if Restore
	{
		if !FileExist("Restore")
			FileCreateDir Restore
		FileAppend %file%->%Destination%\%name%`n, Restore\%curDate%.mfr
	}
	Return
}


Open:
	Run % """" folder%A_ThisMenuItemPos% """"
ExitApp

Crap:
	Run "%MagicFolder%"
ExitApp

Alternative:
	if Dropbox
		Run % RegExReplace(AltPath, "(.*)\\.*", "$1")	; Open Dropbox main folder instead of Public subfolder
	else
		Run "%AltPath%"
ExitApp

ShortcutOpen:
	Run % """" sMenuArray%A_ThisMenuItemPos%_2 """"
ExitApp



;====================Settings====================

Settings:

	Settings := true
	IniRead TabNr, Magic Folder.ini, Misc, Tab, 1
	

	; gui: 248x140
	;==========Tab 1==========
	Gui 1: Add, Tab2, x5 y6 w424 h184 AltSubmit Choose%TabNr%, Basic|Alternative Folder|Filters etc.|Tools
	Gui 1: Add, GroupBox, x13 y44 w407 h43 , Magic Folder path (THIS IS THE ONLY REQUIRED FIELD)
	Gui 1: Add, Edit, x19 y60 w306 r1 vMagicFolder , %MagicFolder%
	Gui 1: Add, Button, x335 yp-1 w80 r1 gBPath, Browse...

	;==========Tab 3==========
	Gui 1: Tab, 3
	quantity := 3
	width := (400 - (10 * (quantity - 1))) // quantity
	x2 := 16
	Gui 1: Add, Button, x%x2% y40 w%width% h100 gShortcuts, Run Shortcut configurator...
	Gui 1: Add, Button, xp yp+105 w%width% h35 gHelpShortcuts, Help
	x2 += width + 10
	Gui 1: Add, Button, x%x2% y40 w%width% h100 gCustom, Run Custom Folder configurator...
	Gui 1: Add, Button, xp yp+105 w%width% h35 gHelpCustom, Help
	x2 += width + 10
	Gui 1: Add, Button, x%x2% y40 w%width% h100 gRegExConfig, Run RegEx Filters configurator...
	Gui 1: Add, Button, xp yp+105 w%width% h35 gHelpRegEx, Help
	

	;==========Tab 2==========
	Gui 1: Tab, 2
	Gui 1: Add, GroupBox, x9 y30 w415 h150, Alternative Folder
	Gui 1: Add, CheckBox, x19 y45 w140 r2 vAlt gAltToggle, Enable Alternative folder	;AltFolder
	if Alt
		GuiControl 1:, Alt, 1
	Gui 1: Add, CheckBox, x176 yp w190 r2 vDropbox gDropboxToggle, Alternative folder is Dropbox public folder	;Dropbox
	if Dropbox
		GuiControl 1:, Dropbox, 1

	Gui 1: Add, GroupBox, x13 y74 w407 h43 , Alternative Folder path
	Gui 1: Add, Edit, x19 y90 w306 r1 vAltPath , %AltPath%	;AltPath
	Gui 1: Add, Button, x335 yp-1 w80 r1 gBAlt vBrowsePlaceholder, Browse...	; AltBrowse

	Gui 1: Add, GroupBox, x19 y129 w132 h44, Public Number
	Gui 1: Add, Edit, x25 y145 w90 r1 vPubNr, %PubNr%	;Public Number
	Gui 1: Add, Button, xp+95 yp-2 w25 h25 gHelpPublic, ?
	Gui 1: Add, Checkbox, xp+50 yp-10 w90 r3 vInvert, Invert ScrollLock behavior
	GuiControl 1:, Invert, %Invert%
	Gui 1: Add, Button, x300 y140 w120 h36 gHelpAlt, HELP
	if !Alt
	{
		GuiControl 1: Disable, Edit2
		GuiControl 1: Disable, Dropbox
		GuiControl 1: Disable, BrowsePlaceholder
		GuiControl 1: Disable, Edit3
	}
	else
	{
		if !Dropbox
			GuiControl 1: Disable, Edit3
	}
	;==========Tab 4==========
	Gui 1: Tab, 4
	Gui 1: Add, Button, x16 y40 w100 h50 gRestoreMenu, Restore...
	Gui 1: Add, Button, xp+105 yp+12 w25 h25 gRestoreHelp, ?
	Gui 1: Add, Checkbox, x16 y100 w130 r1 vRestore, Create restore points
	GuiControl 1:, Restore, %Restore%
	Gui 1: Add, Text, x16 y125 w130 r2, How many restore points do you want to keep?
	Gui 1: Add, Edit, x16 y155 w50 r1 vrCount, %rCount%
	Gui 1: Add, Button, x150 y40 w264 h140 Disabled, More comming soon (or not so soon)
	

	Gui 1: Tab

	Gui 1: Add, Button, x96 y200 w100 h30 gOK1 , OK
	Gui 1: Add, Button, xp+140 yp wp hp gCancel1 , Cancel
	Gui 1: Add, Button, xp+120 yp+5 w70 h20 gAbout , About...

	Gui 1: Tab, 1
	Gui 1: Add, GroupBox, x13 y100 w150 h70 , Menu position
	Gui 1: Add, Text, x19 y120 w10 r1, X
	Gui 1: Add, Edit, xp+15 yp-4 w40 r1 vposX, %posX%
	Gui 1: Add, Text, xp+60 yp+4 w10 r1, Y
	Gui 1: Add, Edit, xp+15 yp-4 w40 r1 vposY, %posY%
	Gui 1: Add, Button, xp-60 yp+25 w80 gSelMenuPos, Select
	Gui 1: Add, GroupBox, x203 y100 w170 h43 , Folders
	Gui 1: Add, CheckBox, xp+13 yp+19 vfolderSort, Sort folder contents
	GuiControl 1:, folderSort, %folderSort%
	Gui 1: Add, Button, xp+117 yp-7 w25 h25 gHelpFolderSort , ?

	Gui 1: Show, h240 w436, % "Magic Folder v" FileGetVersion(A_ScriptFullPath)
	RestoreClean(rCount)
Exit

About:
	Gui 1: +Disabled
	Gui 98: +Owner1
	Gui 98: Default
	Gui, Add, Text, x10 y5 w200 r2 , % "Magic Folder " FileGetVersion(A_ScriptFullPath) "`ncreated by " VSE2("DJC2ei2Q ""KeSJ3"" feireiw1Ae")
	Gui, Font, CBlue Underline, 
	Gui, Add, Text, xp yp+40 w130 r1 gMail , % VSE2("9FwAYeSJ3@0RFeH.2JR")
	Gui, Add, Text, xp yp+20 w150 r1 gWWW, http://autohotkey.net/~Vifon
	Gui, Show, , Credits
Return

Mail:
	Run % "mailto:" VSE2("9FwAYeSJ3@0RFeH.2JR")
Return

WWW:
	Run http://autohotkey.net/~Vifon
Return

98GuiEscape:
98GuiClose:
	Gui 1: -Disabled
	Gui 98: Destroy
Return

SelMenuPos:
	CoordMode Mouse
	Gui 1: Hide
	Gui 98: -Caption +ToolWindow +LastFound +AlwaysOnTop
	WinSet Trans, 1
	Gui 98: Show, % "w" A_ScreenWidth + 100 " h" A_ScreenHeight + 100 " NoActivate", Barrier
	WinSet ExStyle, +0x08000000
	if (posX && posY)
	{
		Gui 99: Color, FF0000
		Gui 99: +LastFound -Caption +ToolWindow +AlwaysOnTop
		WinSet ExStyle, +0x08000000
		Gui 99: Show, x%posX% y%posY% w5 h5 NoActivate
	}
	SplashImage,,B1 W200, Click where you want the menu to appear next time
	KeyWait LButton, D
	SplashImage Off
	MouseGetPos posX, posY
	Gui 98: Destroy
	Gui 99: Destroy
	Gui 1: Show
	GuiControl 1:, posX, %posX%
	GuiControl 1:, posY, %posY%
Return

BPath:
	Browse(1, "Select location of your Magic Folder")
Return

BAlt:
	Browse(2, "Select location of your alternative folder")
Return

AltToggle:
	Gui 1: Submit, NoHide
	if Alt
	{
		GuiControl 1: Enable, Edit2
		GuiControl 1: Enable, Dropbox
		GuiControl 1: Enable, BrowsePlaceholder
		if Dropbox
			GuiControl 1: Enable, Edit3
	}
	else
	{
		GuiControl 1: Disable, Edit2
		GuiControl 1: Disable, Dropbox
		GuiControl 1: Disable, BrowsePlaceholder
		GuiControl 1: Disable, Edit3
	}
Return

DropboxToggle:
	Gui 1: Submit, NoHide
	if Dropbox
		GuiControl 1: Enable, Edit3
	else
		GuiControl 1: Disable, Edit3
Return

;==========Submit==========

OK1:
	Gui 1: Submit, NoHide
	IniWrite %MagicFolder%, Magic Folder.ini, Path, Magic Folder
	IniWrite %Alt%, Magic Folder.ini, Alternative, Alternative
	if (Alt && Dropbox)
		IniWrite 1, Magic Folder.ini, Alternative, Dropbox
	else
		IniWrite 0, Magic Folder.ini, Alternative, Dropbox
	IniWrite %folderSort%, Magic Folder.ini, Misc, FolderSort
	IniWrite %ShortSubMenu%, Magic Folder.ini, Misc, ShortcutsAsMenu
	IniWrite %posX%, Magic Folder.ini, Misc, X
	IniWrite %posY%, Magic Folder.ini, Misc, Y
	IniWrite %Invert%, Magic Folder.ini, Alternative, Invert
	if Alt
	{
		IniWrite %AltPath%, Magic Folder.ini, Path, Alternative
	}
	if (Alt && Dropbox)
		IniWrite %PubNr%, Magic Folder.ini, Alternative, Public Number
	IniWrite %Restore%, Magic Folder.ini, Restore, Restore
	if rCount is digit
		IniWrite %rCount%, Magic Folder.ini, Restore, Count
Cancel1:
GuiClose:
	GuiControlGet TabNr, 1:, SysTabControl321
	IniWrite %TabNr%, Magic Folder.ini, Misc, Tab
	Settings := false
ExitApp


Browse(field, prompt = "")
{
	FileSelectFolder path, , 1, %prompt%
	if ErrorLevel
		Return ErrorLevel
	GuiControl Text, Edit%field%, %path%
}


HelpAlt:
	Help("Alternative folder is a folder where files can be moved to instead of the Magic Folder.`nMagic Folder is used if ScrollLock is turned off and alternative folder is used if it is turned on.`nFiles moved to alternative folder are NOT sorted by extension!")
Return

HelpPublic:
	Help("Public number is the number present in every Dropbox public link.`nIn ""http://dl.dropbox.com/u/XXXXXX/file.ext"" XXXXXX is this number.`nIf you enter this number here, public links for your files will be automatically copied to the clipboard.")
Return

HelpFolderSort:
	Help("Check this checkbox if you want Magic Folder to sort contents of drag'n'dropped folders.`nUncheck it if you want these folders just moved into the Magic Folder.")
Return

HelpShortcuts:
	Help("These folders can be opened with Magic Folder's submenu ""Shortcuts"".")
Return

HelpCustom:
	Help("You can force Magic Folder to move certain file types to certain folders.`nIt's faster than RegEx but less flexible.`nThe order is not important.`n`nUse # as an extension for ""all other files"" rule.")
Return

HelpRegEx:
	Help("You can set up some filters based on Regular Expressions.`nIf you don't know what it is, Google it or just ignore it.`nThe filter on the top has the highest priority and the filter on the bottom -  the lowest.`nUse with caution - may be slow.")
Return

RestoreHelp:
	Help("You can revert up to 10 (by default, can be changed) operations.")
Return


;==========Shortcuts==========
Shortcuts:
	Gui 2: Default
	Gui 2: +Owner1
	Gui 1: +Disabled
	Gui 2: Margin, 5, 5
	Gui 2: Add, ListView, w500 h200 Grid -ReadOnly, Name|Path

	Loop Read, Shortcuts.txt
	{
		StringSplit sArray, A_LoopReadLine, |
		LV_Add("", sArray1, sArray2)
	}

	LV_ModifyCol(1, "AutoHdr")
	LV_ModifyCol(2, "AutoHdr")
	Gui 2: Add, Button, x80 w150 h30 gshAdd Section, Add
	Gui 2: Add, Button, x270 yp w150 h30 gRemove, Remove
	Gui 2: Add, Button, x190 w50 h20 gshOK, OK
	Gui 2: Add, Button, x260 yp w50 h20 gCancel2, Cancel
	Gui 2: Add, Checkbox, xp+80 yp+2 w150 r1 vShortSubMenu, Show as a submenu
	GuiControl 2:, ShortSubMenu, %ShortSubMenu%
	Gui 2: Add, Button, x10 ys r1 w50 gUp, Up
	Gui 2: Add, Button, x10 yp+30 r1 w50 gDown, Down
	Gui 2: Add, Button, x80 ys+30 w100 h30 gshAddSep, Add separator
	Gui 2: Show, , Shortcuts
Return

shOK:
	FileDelete Shortcuts.txt
	Loop % LV_GetCount()
	{
		LV_GetText(shName, A_Index, 1)
		LV_GetText(shPath, A_Index, 2)
		FileAppend %shName%|%shPath%`n, Shortcuts.txt
	}
	Gui 2: Submit
Cancel2:
2GuiClose:
	Gui 1: -Disabled +LastFound
	Gui 2: Destroy
	Gui 1: Default
	WinActivate
Return


shAdd:
	Gui 2: +OwnDialogs
	FileSelectFolder shFold,, 0, Specify path for the new shortcut
	if ErrorLevel
		Return
	InputBox shFoldName, Shortcut Name, Specify the name for your shortcut,,,150
	if ErrorLevel
		Return
	LV_Add("", shFoldName, shFold)
	LV_ModifyCol(1, "AutoHdr")
	LV_ModifyCol(2, "AutoHdr")
Return

Remove:
	Loop % LV_GetCount("S")
	{
		LV_Delete(LV_GetNext("S"))
	}
Return

shAddSep:
	LV_Add("", "", "Separator")
Return

Up:
	thisRow := LV_GetNext(0, "Focused")
	if (thisRow = "1")
	{
		GuiControl Focus, SysListView321
		Return
	}
	LV_Insert(thisRow - 1, "Focus Select", LV_GetText2(thisRow, 1), LV_GetText2(thisRow, 2))
	LV_Delete(thisRow + 1)
	GuiControl Focus, SysListView321
Return

Down:
	thisRow := LV_GetNext(0, "Focused")
	LV_Insert(thisRow + 2, "Focus Select", LV_GetText2(thisRow, 1), LV_GetText2(thisRow, 2))
	LV_Delete(thisRow)
	GuiControl Focus, SysListView321
Return


;==========Custom Folders==========
Custom:
	Gui 2: Default
	Gui 2: +Owner1
	Gui 1: +Disabled
	Gui 2: Margin, 5, 5
	Gui 2: Add, ListView, w500 h200 Grid, Ext|Destination

	Loop Read, Custom.txt
	{
		StringSplit cArray, A_LoopReadLine, |
		LV_Add("", cArray1, cArray2)
	}

	LV_ModifyCol(1, "AutoHdr")
	LV_ModifyCol(2, "AutoHdr")
	Gui 2: Add, Button, x80 w150 h30 gcustAdd Section, Add
	Gui 2: Add, Button, x270 yp w150 h30 gRemove, Remove
	Gui 2: Add, Button, x190 w50 h20 gcustOK, OK
	Gui 2: Add, Button, x260 yp w50 h20 gCancel2, Cancel
	Gui 2: Add, Button, x10 ys r1 w50 gUp, Up
	Gui 2: Add, Button, x10 yp+30 r1 w50 gDown, Down
	Gui 2: Show, , Custom Folders
Return

custOK:
	FileDelete Custom.txt
	Loop % LV_GetCount()
	{
		LV_GetText(custName, A_Index, 1)
		LV_GetText(custPath, A_Index, 2)
		FileAppend %custName%|%custPath%`n, Custom.txt
	}
	Gui 1: -Disabled +LastFound
	Gui 2: Destroy
	Gui 1: Default
	WinActivate
Return

custAdd:
	Gui 2: +OwnDialogs
	InputBox custFoldExt, Custom Ext, Specify the file type (extension) you want to be moved to the new Custom Folder,, 430,150
	if ErrorLevel
		Return
	FileSelectFolder custFold,, 1, Specify path for the new Custom Folder
	if ErrorLevel
		Return
	LV_Add("", custFoldExt, custFold)
	LV_ModifyCol(1, "AutoHdr")
	LV_ModifyCol(2, "AutoHdr")
Return


;==========RegExConfig==========
RegExConfig:
	Gui 2: Default
	Gui 2: +Owner1
	Gui 1: +Disabled
	Gui 2: Margin, 5, 5
	Gui 2: Add, ListView, w500 h200 Grid -ReadOnly, RegEx|Destination

	Loop Read, RegEx.txt
	{
		StringSplit RegExArray, A_LoopReadLine, "
		LV_Add("", RegExArray1, RegExArray2)
	}

	LV_ModifyCol(1, "AutoHdr")
	LV_ModifyCol(2, "AutoHdr")
	Gui 2: Add, Button, x80 w150 h30 greAdd Section, Add
	Gui 2: Add, Button, x270 yp w150 h30 gRemove, Remove
	Gui 2: Add, Button, x190 w50 h20 greOK, OK
	Gui 2: Add, Button, x260 yp w50 h20 gCancel2, Cancel
	Gui 2: Add, Button, x10 ys r1 w50 gUp, Up
	Gui 2: Add, Button, x10 yp+30 r1 w50 gDown, Down
	Gui 2: Show, , RegEx Filters
Return

reOK:
	FileDelete RegEx.txt
	Loop % LV_GetCount()
	{
		LV_GetText(reName, A_Index, 1)
		LV_GetText(rePath, A_Index, 2)
		FileAppend %reName%"%rePath%`n, RegEx.txt
	}
	Gui 1: -Disabled +LastFound
	Gui 2: Destroy
	Gui 1: Default
	WinActivate
Return

reAdd:
	Gui 2: +OwnDialogs
	InputBox reRule, RegEx, Specify the new Regular Expression,, 430,150
	if ErrorLevel
		Return
	FileSelectFolder reFold,, 1, Specify path for the new RegEx Filter
	if ErrorLevel
		Return
	LV_Add("", reRule, reFold)
	LV_ModifyCol(1, "AutoHdr")
	LV_ModifyCol(2, "AutoHdr")
Return


;==========Restore==========
RestoreMenu:
	Gui 2: Default
	Gui 2: +Owner1
	Gui 1: +Disabled
	Gui 2: Margin, 5, 5
	Gui 2: Add, ListView, w500 h200 Grid gListClick SortDesc, Restore Point

	Loop Restore\*.mfr
	{
		LV_Add("", A_LoopFileName)
	}

	LV_ModifyCol(1, "AutoHdr")
	LV_ModifyCol(2, "AutoHdr")
	Gui 2: Add, Button, x80 w150 h30 grestDetails, Restore...
	Gui 2: Add, Button, x270 yp w150 h30 grestRemove, Remove
	Gui 2: Add, Button, x200 w100 h20 gCancel2, Close
	Gui 2: Show, , Restore Point Manager
Return

restRemove:
	Gui 2: +OwnDialogs
	MsgBox 8228, Magic Folder, Are you sure?
	ifMsgBox No
		Return
	Loop % LV_GetCount("S")
	{
		FileDelete % "Restore\" LV_GetText2(LV_GetNext("S") ,1)
		LV_Delete(LV_GetNext("S"))
	}
Return

ListClick:
	if A_GuiEvent != DoubleClick
		Return
restDetails:
	if !LV_GetCount("Selected")
		Return
	LV_GetText(restFile, LV_GetNext(0, "Focused"), 1)
	row := ""
	Gui 3: Default
	Gui 3: +Owner1
	Gui 2: +Disabled
	Gui 3: Margin, 5, 5
	Gui 3: Add, ListView, w500 h200 Grid, Original Location|Current Location
	Loop Read, Restore\%restFile%
	{
		StringReplace restoreLine, A_LoopReadLine, ->, "
		StringSplit RestoreArray, restoreLine, "
		LV_Add("", RestoreArray1, RestoreArray2)
	}
	LV_ModifyCol(1, "AutoHdr")
	LV_ModifyCol(2, "AutoHdr")
	Gui 3: Add, Button, x80 w150 h30 gRestore, Restore these files!
	Gui 3: Add, Button, x270 yp w150 h30 gCancel3, Cancel
	Gui 3: Show, , Restore Point Details
Return

Restore:
	Loop Read, Restore\%restFile%
	{
		StringReplace restoreLine, A_LoopReadLine, ->, "
		StringSplit RestoreArray, restoreLine, "
		SplitPath RestoreArray1,, DirCheck
		if (!(InStr(FileExist(folder), "D")))
			FileCreateDir %DirCheck%
		if isFolder(RestoreArray2)
		{
			FileMoveDir %RestoreArray2%, %RestoreArray1%, 0
			folderCheck := true
		}
		else
		{
			FileMove %RestoreArray2%, %RestoreArray1%
			fileCheck := true
		}
	}
	FileDelete Restore\%restFile%
	if (folderCheck && fileCheck)
		DllCall("Shell32.dll\SHChangeNotify", "UInt", "0x8000000", "UInt", 0, "IntP", 0, "IntP", 0) ; refresh all windows
	folderCheck := false
	fileCheck := false
	GoSub Cancel3
	GoSub Cancel2
Return
Cancel3:
3GuiEscape:
3GuiClose:
	Gui 2: -Disabled +LastFound
	Gui 3: Destroy
	Gui 2: Default
	WinActivate
Return
	



LV_GetText2(Row, Col = "")
{
	LV_GetText(temp, Row, Col)
	Return temp
}

FileGetVersion(file)
{
	FileGetVersion ver, %file%
	Return ver
}


VSE2(inTxt)	; Vifon's Shitty Encryption v2
{
	StringCaseSense On
	chars := "JCGOde4QDcILRwguZXyFkSv3Vxt1MHzojp59iNhW2T6mr0BE7UaAfYnK8qsblP"
	Loop Parse, inTxt
	{
		IfInString chars, %A_LoopField%
			rot .= SubStr(chars, Mod(InStr(chars, A_LoopField, 1) + (StrLen(chars) // 2), StrLen(chars)), 1)
		else
			rot .= A_LoopField
	}	
	Return rot
}

StringLower(inStr)
{
	StringLower outStr, inStr
	Return outStr
}

FileRead(file)
{
	FileRead var, %file%
	Return var
}


RestoreClean(count)
{
	i := 0
	Loop Restore\*.mfr
	{
		i++
		file%A_Index% := A_LoopFileFullPath
	}
	Loop % i - count
		FileDelete % file%A_Index%
}

isFolder(path)
{
	if InStr(FileExist(path), "D")
		Return 1
	else
		Return 0
}

Help(text)
{
	Gui 1: +OwnDialogs
	Gui 1: +Disabled
	SplashImage,,B1 W400,
	(LTrim
		%text%

		Press Esc to close
	), Help
	KeyWait Escape, D
	SplashImage Off
	Gui 1: -Disabled
	Return
}




ToolTipOff:
	ToolTip("1")
Return
