/*
__Permanent.ahk

Permanent AutoHotkey commands, always running on my system.

// by Philippe Lhoste <PhiLho(a)GMX.net> http://Phi.Lho.free.fr
// File/Project history:
 1.00.000 -- Today (PL) -- Lastest version (updated daily!).
 0.01.000 -- 2006/01/01 (PL) -- Creation.
*/
/* Copyright notice: For details, see the following file:
http://Phi.Lho.free.fr/softwares/PhiLhoSoft/PhiLhoSoftLicence.txt
This program is distributed under the zlib/libpng license.
Copyright (c) 2006-2007 Philippe Lhoste / PhiLhoSoft
*/
#SingleInstance Force

; The most flexible match mode
SetTitleMatchMode RegEx
; Recommended for performance and compatibility with future AutoHotkey releases.
#NoEnv
; Recommended for new scripts due to its superior speed and reliability.
SendMode Input

;~ #Include DllCallStruct.ahk

;===== Autoexecute section

;~ Menu Tray, Icon, %A_AhkPath%, 6
Menu Tray, Icon, %A_ScriptDir%\HOT!Key.ico

;~ SetCapslockState AlwaysOff
hiddenHwnd := 0

menuControlPanel =
(
&Control Panel
@control.exe
&Desktop
@control.exe desk.cpl
Desktop / &Screensaver
@control.exe desk.cpl,,1
--

&Installed Programs
@appwiz.cpl
)

menuReferenceTools =
(
&Google Search
@http://www.google.com/search?hl=en&q=:::
Google &Images
@http://images.google.com/images?hl=en&q=:::
&Wikipedia
@http://en.wikipedia.org/w/wiki.phtml?search=:::
Word&Reference (French->English)
@http://www.wordreference.com/fren/:::
Word&Reference (English->French)
@http://www.wordreference.com/enfr/:::
Word&Reference (English definition)
@http://www.wordreference.com/definition/:::
&AutoHotkey manual
@http://www.autohotkey.com/docs/commands/:::.htm
--

&Merriam-Webster
@http://www.m-w.com/cgi-bin/dictionary?book=Dictionary&va=:::
&Dictionary.com
@http://www.dictionary.com/search?q=:::&db=*
The &Free Dictionary
@http://www.thefreedictionary.com/:::
&Columbia Encyclopedia
@http://columbia.thefreedictionary.com/:::
&Encarta Encyclopedia
@http://encarta.msn.com/encnet/refpages/search.aspx?q=:::
&IMDB.com
@http://www.imdb.com/find?q=:::;s=tt
)

Gosub CapsLockAltGr

; Not provided, stuff very specific to my needs
#Include ~.ahk

;===== Hotstrings

;--- Frequenly used BBCodes
; Reminder: *: no ending char; c: case sensitive
; URL
:*c:²u::[url=][/url]{Left 6}
:*c:²U::[url=^v][/url]{Left 6}
; URL to AutoHotkey manual for a command copied to clipboard
:*c:²M::[url=http://www.autohotkey.com/docs/commands/^v.htm]^v[/url]
; URL to a file in my AutoHotkey.net space, file whose name is copied to clipboard
:*c:²F::[url=http://autohotkey.net/~PhiLho/^v][color={#}5500AA][size=15][b]^v[/b][/size][/color][/url]
; Code section
:*c:²c::[code][/code]{Left 7}
; Quote section
:*c:²q::[quote=""][/quote]{Left 8}
; Frequent quote, editable of course
:*c:²Q::[quote="AHK's Manual"][/quote]{Left 8}
; Inverted quote section
:*c:²K::[/quote]{Enter 2}[quote]{Left 8}
; Kolor... I chose green because I use it frequently for short, unindented code fragments
:*c:²k::[color=green][/color]{Left 8}
; Size
:*c:²s::[size=9][/size]{Left 7}
; Title (big, bold, colored...)
:*c:²t::[color={#}770099][size=15][b][/b][/size][/color]{Left 19}
; Generic (to be filled)
:*c:²g::[][/]{Left 3}
:*c:²b::[b][/b]{Left 4}
:*c:²<::«&nbsp;&nbsp;»{Left 7}

; Other hotstrings
:*c:²ah::AutoHotkey
:*c:²ak::AutoHotkey
:*c:²am::http://www.autohotkey.com/docs/commands/.htm
:*c:²an::http://autohotkey.net/~PhiLho/
:*c:²af::http://www.autohotkey.com/forum/
:*c:²av::
	Send %A_AhkVersion%
Return

:*c:²lp::lp:~philho/{+}junk/

; deviantART shortcuts
:*c:²da::deviantART
:*c:²dpl::http://PhiLho.deviantART.com
:*c:²fpl::http://Phi.Lho.free.fr	; While I am at it...
:*c:²dd::http://www.deviantart.com/deviation/^v/	; URL of a deviation (with ID)
:*c:²dt:::thumb^v:	; Thumb (ID of deviation)
:*c:²di::<b>^v</b> :icon^v:	; Icon of a deviant (this name without the prefix)
+#d::	; Deviation thumb with title: dev#`tTitle in clipboard
	ref := Clipboard
	If (RegExMatch(ref, "^\d{8}$"))
	{
		SendRaw :thumb%ref%:
	}
	Else If (RegExMatch(ref, "^(?'ID'\d{8})\t(?'Name'.*?)(?:\t|$)", deviation))
	{
		SendRaw <i>%deviationName%</i> :thumb%deviationID%:
	}
	Else If (RegExMatch(ref, "^[\w-]{3,20}$"))	; Deviant name
	{
		SendRaw :dev%ref%: :icon%ref%:
	}
	Else If (RegExMatch(ref, "^http://(?'Name'.*?)\.deviantart\.com/$"), deviant)	; Deviant URL
	{
		SendRaw :dev%deviantName%: :icon%deviantName%:
	}
Return
!#d::	; Address of a deviation
	ref := Clipboard
	If (RegExMatch(ref, "^\d{8}$"))
	{
		SendRaw <a href="http://www.deviantart.com/deviation/%ref%/"></a>
	}
	Else If (RegExMatch(ref, "^(?'ID'\d{8})\t(?'Name'.*?)(\t|$)", deviation))
	{
		SendRaw <i><a href="http://www.deviantart.com/deviation/%deviationID%/">%deviationName%</a></i>
	}
Return

#+<::
	InputBox tag, HTML Tag Input, Give the HTML tag to output
	l := StrLen(tag) + 3
	Send <%tag%></%tag%>{Left %l%}
Return

;~ #^x:: ControlSend ahk_parent, {F5}, Microsoft Internet Explorer
; Works better
;~ #^x:: ControlSend Edit1, {Enter}, ahk_class IEFrame
;~ #^x:: ControlSend ahk_parent, {F5}, ahk_class Internet Explorer_Server1

; Deactivate Capslock & Numlock, as I never use them
;~ ^CapsLock::	; Control-Capslock = Toggle CapsLock
;~ 	GetKeyState t, CapsLock, T
;~ 	IfEqual t, D, SetCapslockState AlwaysOff
;~ 	Else SetCapslockState AlwaysOn
;~ Return
;~ Capslock::	Return
;~ +Capslock::	Return
Numlock::	Return

;===== Hotkeys

; A substitute for AltGr key: no need for finger gym.
; Plus provide alternative way to get some other special chars
; that I usually get with Alt+Numpad0 Numpad... and others with the char applet.
; Type CapsLock followed by a key below to get the corresponding character.
CapsLock::
	Input key, I L1 T2, {Escape}
	el := ErrorLevel
	If (el = "Timeout" or el = "EndKey:Escape")
	{
		; Timeout (or escaped), do nothing
		Goto NoCapsLock
	}
	pos := InStr(keysCapsLock, key, true)
	If (pos > 0)
	{
		StringMid c, charsCapsLock, pos, 1
		; Manage dead-keys by adding a space after
		If c in ~,``,^
			c := c . " "
	}
	Else If key in !,?,:,;, ,`%,q
	{
		If (key = "q")
			c := "&rsquo;"
		Else If (key = " ")
			c := "&nbsp;"
		Else
			c := "&nbsp;" . key
	}
	Else
	{
		c := key
	}
	SendRaw %c%
Return

; To call from Auto-execute section
CapsLockAltGr:
	keysCapsLock = "'(-_à)=eaAoO0279<>éèç
	charsCapsLock = #{[|\@]}€æÆœŒÀÉÈÇ«»~``^
Return

; If timeout or Escape to cancel the CapsLock, warn the user
NoCapsLock:
	ToolTip CapsLock: %el% %key%
	SetTimer RemoveToolTip, 1000
Return

+²::Send \
^²::Send ``%A_Space%

; This allows to paste list of files copied from Win Explorer
#Insert::
	; I also clean up URLs from the forum...
	cb := RegExReplace(Clipboard, "^(http://.*)?&highlight=.*$", "$1")
	cb := RegExReplace(cb, "=(http://.*)?&highlight=.*?\]", "=$1]")
	; And from Microsoft's MSDN!
	StringReplace cb, cb, http://msdn.microsoft.com/library/default.asp?url=/, http://msdn.microsoft.com/
	Clipboard := cb
	Send ^v	; Faster in SciTE (no autocompletion trigger...)
Return

; Convert plain line comment to JavaDoc comment
; Caret must be right after the line comment symbol //
^!c::Send {Backspace}**{End}. */

; In BareGrep <http://www.baremetalsoft.com/baregrep/>, suppose the user selected a line of search result
; Copy this line (as I don't know how to extract info from a TBEGUIGridView), get the path, combine the whole
; to open the file in SciTE at the selected line.
#IfWinActive BareGrep ahk_class TMainWindow
^o::
	cbOld := Clipboard
	Clipboard =
	Send ^c
	ClipWait 1
	cb := Clipboard

	If (RegExMatch(cb, "^(?'RelativePath'.+?)\t(?:-\t|\d{4}-\d\d-\d\d|(?'Line'\d+)\t)", file) > 0)
	{
		; In a search result line
		; Get start of path
		ControlGetText searchPath, Edit1
		param = "%searchPath%\%fileRelativePath%"
		If (fileLine != "")
		{
			; We have a line number
			param .= " -goto:" . fileLine
		}

		; Run SciTE with the parameter
		; I have this environment variable set to the path of SciTE's install dir
		; Replace this by a simple assignment of the path otherwise
		EnvGet sciteHome, SciTE_HOME
		Run %sciteHome%\SciTE.exe %param%
	}
	Clipboard := cbOld
Return
#IfWinActive

; Ask for an HTML tag, surround the current selection with this tag and paste it.
#h::
	cbOld := Clipboard
	Clipboard =
	Send ^c
	ClipWait 1
	cb := Clipboard
	message = Enter an HTML tag
	If (cb != "")
	{
		message = %message% for text "%cb%"
	}
	InputBox tag, Fast tag entry, %message%
	If (ErrorLevel = 1)
		Return
	If (cb != "")
	{
		Clipboard = <%tag%>%cb%</%tag%>
		ClipWait 2
		Send ^v
	}
	Else
	{
		tl := StrLen(tag) + 3
		Send <%tag%></%tag%>{Left %tl%}
	}
	Sleep 1
	Clipboard := cbOld
Return
+#h::
	Send <>{Left 1}
Return

; Deactivated: previously simplistic hide current window code
	If (hiddenHwnd = 0)
	{
		hiddenHwnd := WinExist("A")
		WinHide ahk_id %hiddenHwnd%
	}
	Else
	{
		WinShow ahk_id %hiddenHwnd%
		hiddenHwnd := 0
	}
Return

;----------------------------------------------------------------
;--- Win+?: show defined hotkeys!
; Badly outdated/incomplete... Will generate this someday.
#?::
;ListHotkeys
	MsgBox,
(
List of hotkeys defined in Permanent.ahk:

Ctrl+Win+R:	reload this script!
Win+T:		run my standard AHK test script...
Ctrl+Win+T:	test a small AHK script...
Shift+Win+S:	run a mini-WinSpy
Ctrl+Alt+S:	screensaver launcher
Win+PrintScreen:	put systray behind its tooltips! (fixes a XP bug)
Shift+Win+C:	Control Panel menu
F12:		in Explorer, create a new folder (if nothing selected) or duplicate current file
Ctrl+Alt+I:		show IP address
Shift+Win+R:	reference tool look-up
)
Return

;----------------------------------------------------------------
;--- Ctrl+Win+R: reload this script!
#^R::Reload

;----------------------------------------------------------------
;--- Ctrl+Win+T: test a small AHK script...
#^t::
;~ 	WinSet Top,, Auto
;~ 	WinActivate Auto
;~ 	Send {Del}{End}{Del}{End}{Del}{Down}
	Run 3rdPartyCodeTest.ahk
;~ 	Run JapaneseFlashCards.ahk
Return

;----------------------------------------------------------------
;--- Win+T: run my standard AHK test script...
#t::Run %A_AhkPath% __Test.ahk

;----------------------------------------------------------------
;--- Double right-click (by Laszlo)
/*
~RButton::
	If (A_PriorHotKey = A_ThisHotKey and A_TimeSincePriorHotkey < 500)
	{
		Sleep 200   ; wait for right-click menu, fine tune for your PC
		Send {Esc}  ; close it
		MsgBox OK   ; your double-right-click action here
	}
Return
*/

;----------------------------------------------------------------
;--- Ctrl+Alt+S: screensaver launcher
; 0x0112 is WM_SYSCOMMAND -- 0xF140 is SC_SCREENSAVE
^!s::	PostMessage 0x0112, 0xF140, 0,, Program Manager

;----------------------------------------------------------------
;--- CMD console shortcuts
#IfWinActive ahk_class ConsoleWindowClass
; by JSLover, http://www.autohotkey.com/forum/viewtopic.php?t=13812
;//scroll=smooth
;~ +pgup::Send {WheelUp}
;~ +pgdn::Send {WheelDown}

;//scroll=page
+pgup::Click WheelUp
+pgdn::Click WheelDown

^f::Send !{Space}mr!h!r
#IfWinActive

;----------------------------------------------------------------
;--- Win+PrintScreen: put systray behind its tooltips! (fixes a XP bug)
#PrintScreen::
	WinSet AlwaysOnTop, , ahk_class Shell_TrayWnd
Return

;----------------------------------------------------------------
;--- Shift+Win+PrintScreen: move window under mouse cursor on top-left corner
; (for unmovable top-most windows, eg. progress dialogs, that go in front of MsgBox, for example).
+#PrintScreen::
	MouseGetPos, , , winID
	WinMove ahk_id %winID%, , 0, 0
Return

;----------------------------------------------------------------
;--- Shift+Win+R: reference tool look-up
#+r::
	Send ^c
	Sleep 100
	CreateMenu("mRef", menuReferenceTools, "ReferenceTools")
	Menu mRef, Show
Return

ReferenceTools:
	RunMenuItem(menuReferenceTools, A_ThisMenuItemPos)
Return

;----------------------------------------------------------------
;--- Shift+Win+C: Control Panel menu
#+c::
	CreateMenu("mCP", menuControlPanel, "ControlPanel")
	Menu mCP, Show
Return

ControlPanel:
	RunMenuItem(menuControlPanel, A_ThisMenuItemPos)
Return

;----------------------------------------------------------------
;--- Shift+Win+S: run a mini-WinSpy
#+s::
	If bMiniWinSpy
	{
		SetTimer WatchCursor, Off
		ToolTip
		Hotkey ^c, Off
	}
	Else
	{
		SetTimer WatchCursor, 200
		Hotkey ^c, MWS_Snapshot
	}
	bMiniWinSpy := not bMiniWinSpy
Return

WatchCursor:
	; Get relative coordinates, and additional data
	MouseGetPos xr, yr, winID, control
	; Get absolute coordinates
	CoordMode Mouse, Screen
	MouseGetPos xs, ys
	; Restore default
	CoordMode Mouse, Relative
	; Get other information: window level
	WinGetTitle title, ahk_id %winID%
	WinGetClass class, ahk_id %winID%
	WinGetText windowText, ahk_id %winID%
	ShortenAndCleanUp(windowText)
	WinGetPos xw, yw, ww, hw, ahk_id %winID%
	; Get other information: current control level
	ControlGetText controlText, %control%, ahk_id %winID%
	ShortenAndCleanUp(controlText)
	ControlGetPos xc, yc, wc, hc, %control%, ahk_id %winID%
	ControlGet controlID, Hwnd, , %control%, ahk_id %winID%
	MWS_Info =
(
Window: %title%
(%windowText%)
ahk_id: %winID% - ahk_class: %class%
%ww%x%hw% at %xw%, %yw%
Control: %control% - ahk_id: %controlID%
(%controlText%)
%wc%x%hc% at %xc%, %yc%
Cursor: (relative) %xr%, %yr% (screen) %xs%, %ys%
)
	; Prevent excessive flickering when not moving
	If (prevInfo != MWS_Info)
	{
		ToolTip %MWS_Info%
	}
	prevInfo := MWS_Info
Return

MWS_Snapshot:
	Clipboard = %MWS_Info%
	ToolTip Copying to clipboard, , , 2
	Sleep 2000
	ToolTip, , , , 2
Return

;----------------------------------------------------------------
; FileZilla helpers

#IfWinActive FileZilla
;--- Synchronize in FileZilla the distant location with the local one
; Adjust root paths as needed
#s::
	ControlGetText wp, Edit1, FileZilla
	StringReplace wp, wp, D:\www\ZC-1.3.7\, /www/Boutique/
	StringReplace wp, wp, \, /, All
	ControlSetText Edit2, %wp%, FileZilla
	ControlSend Edit2, {Enter}
Return
#IfWinActive

;----------------------------------------------------------------
; Explorer Extensions
; The Explorer class below may change depending on system
; and the way the window is created.

#IfWinActive ahk_class ExploreWClass|CabinetWClass

;--- F12: in Explorer, duplicate current file or duplicate or create new folder
;--- Shift+F12: in Explorer, rename current file
F12::
+F12::
	; Get current path in Explorer
	explorerHwnd := WinExist("A")
	ControlGetText currentPath, Edit1, ahk_id %explorerHwnd%

	; GUI constants
	width = 300
	Gui 14:+LabelEEGui	; hexa E = 14...
	appName = Explorer Extensions

	; Get current (selected/with focus) filename in Windows Explorer
	; If several files/folders are selected, the returned one is semi-random...
	selectedItem := GetWindowsExplorerSelectedFile(explorerHwnd)
	If (selectedItem == "")
	{
		; No file nor folder selected, create a new folder in the current dir
		bCreateFolder := true
		Goto DuplicateOrCreateFolder
	}
	If InStr(FileExist(currentPath . "\" . selectedItem), "D")
	{
		; That's a dir
		bCreateFolder := false
		Goto DuplicateOrCreateFolder
	}
	bDuplicateFile := (A_ThisHotkey = "F12")
Goto DuplicateOrRenameFile

^#E::
	explorerHwnd := WinExist("A")
	ControlGetText currentPath, Edit1, ahk_id %explorerHwnd%
	selectedItem := GetWindowsExplorerSelectedFile(explorerHwnd)
	If (selectedItem != "")
	{
		EnvGet sciteHome, SciTE_HOME
		Run %sciteHome%\SciTE.exe "%currentPath%\%selectedItem%"
	}
Return

#IfWinActive

EEGuiCancel:
EEGuiClose:
EEGuiEscape:
	Gui 14:Destroy
Return

DuplicateOrCreateFolder:
	Gui 14:Add, Text, , %currentPath%
	Gui 14:Font, c400080 s12 bold
	If bCreateFolder
		Gui 14:Add, Text, , Create Folder
	Else
		Gui 14:Add, Text, , Duplicate Folder
	Gui 14:Font
	Gui 14:Add, Edit, w%width% vfolderName, %selectedItem%
	Gui 14:Add, Button, w50 xm+100 gEEProcessFolder Default, OK
	Gui 14:Add, Button, w50 x+20 gEEGuiCancel, Cancel
	Gui 14:Show, , %appName%
	Return

EEProcessFolder:
	Gui 14:Submit
	Gui 14:Destroy
	IfExist %currentPath%\%folderName%
	{
		Send {F5}
		MsgBox 16, %appName%, A folder or file with this name already exists!
		Return
	}
	If bCreateFolder
	{
		FileCreateDir %currentPath%\%folderName%
	}
	Else
	{
		FileCopyDir %currentPath%\%selectedItem%, %currentPath%\%folderName%
	}
Return

DuplicateOrRenameFile:
	SplitPath selectedItem, , , siExt, siNameNE
	Gui 14:Add, Text, , %currentPath%
	Gui 14:Font, c400080 s12 bold
	If bDuplicateFile
		Gui 14:Add, Text, , Duplicate File
	Else
		Gui 14:Add, Text, , Rename File
	Gui 14:Font
	Gui 14:Add, Edit, w%width% vnameNoExt, %siNameNE%
	Gui 14:Add, Edit, w100 x+10 vext, %siExt%
	If bDuplicateFile
		Gui 14:Add, Text, xm, Type * to increment file name
	Gui 14:Add, Button, w50 xm+130 y+20 gEEProcessFile Default, OK
	Gui 14:Add, Button, w50 x+20 gEEGuiCancel, Cancel
	Gui 14:Show, , %appName%
	Return

EEProcessFile:
	Gui 14:Submit
	Gui 14:Destroy
	If (nameNoExt = "*" or ext = "*")
	{
		nameNoExt := siNameNE
		Loop
		{
			IfExist %currentPath%\%nameNoExt%.%ext%	; First time is always true...
			{
				nameNoExt := IncrementName(nameNoExt)
			}
			Else
			{
				Break
			}
		}
	}
	newName = %nameNoExt%.%ext%
	IfExist %currentPath%\%newName%
	{
		Send {F5}
		MsgBox 16, %appName%, A folder or file with this name (%newName%) already exists!
		Return
	}
	If bDuplicateFile
		FileCopy %currentPath%\%selectedItem%, %currentPath%\%newName%
	Else
		FileMove %currentPath%\%selectedItem%, %currentPath%\%newName%
Return

;----------------------------------------------------------------
;--- Ctrl+Alt+I: show IP address
ShowIPAddress:	; Deactivated...
	ipFile = %TEMP%\IP
	; Use Netikus service, simple and straight to the point...
	URLDownloadToFile http://www.netikus.net/show_ip.html, %ipFile%
	If ErrorLevel = 1
	{
		MsgBox 16, IP Address, Your public IP address could not be detected.
	}
	Else
	{
		FileReadLine ip, %ipFile%, 1
		MsgBox 64, IP Address, Your public IP address is: %ip%`n`nYour private IP address is: %A_IPAddress1%
	}
	FileDelete %ipFile%
Return

;===== Generic labels

RemoveToolTip:
	ToolTip
	SetTimer RemoveToolTip, Off
Return

GuiEscape:
GuiClose:
	Gui Destroy
Return

;===== Functions & routines

ShortenAndCleanUp(ByRef @text, _length=64)
{
	StringReplace @text, @text, `r, ``r, All
	StringReplace @text, @text, `n, ``n, All
	StringReplace @text, @text, `r, ``t, All
	StringLeft @text, @text, _length
}

GetWindowsExplorerSelectedFile(_hWnd)
{
	local selectedFiles, file

	; I can send ^C and parse Clipboard, but this way don't mess with clipboard at all, seems nicer.
	; Warning: with this, you get only what is displayed in Explorer!
	; If you kept the default Windows setting of not displaying file extensions (bad idea...),
	; you will get partial file names...
	ControlGet, selectedFiles, List, Selected Col1, SysListView321, ahk_id %_hWnd%
	Loop, Parse, selectedFiles, `n  ; Rows are delimited by linefeeds (`n).
	{
		If (A_Index = 1)
		{
			file := A_LoopField
		}
		Else
		{
			; Indicate that several files are selected, we return only the first one
			; but count the total number of selected files, to indicate we return a partial result
			ErrorLevel := A_Index
		}
	}
	Return file
}

IncrementName(_nameNoExt)
{
	local d, dd

	Loop
	{
		; Take out rightmost char (digit?)
		StringRight d, _nameNoExt, 1
		StringTrimRight _nameNoExt, _nameNoExt, 1
		If d = 9
		{
			dd = 0%dd%
		}
		Else If d between 0 and 8
		{
			dd := (d + 1) . dd
			Break
		}
		Else
		{
			; Not a digit: put back non digit char, add a 1
			_nameNoExt = %_nameNoExt%%d%1
			Break
		}
	}
	Return _nameNoExt . dd
}

CreateMenu(_menuName, _menuDef, _menuLabel)
{
	Menu %_menuName%, Add	; Must create before deleting, otherwise AHK complains!
	Menu %_menuName%, Delete
	Loop Parse, _menuDef, `n
	{
		If (Mod(A_Index, 2) = 1) ; Odd
		{
			If (A_LoopField = "--")	; Separator
			{
				Menu %_menuName%, Add
			}
			Else
			{
				Menu %_menuName%, Add, %A_LoopField%, %_menuLabel%
			}
		}
	}
}

RunMenuItem(_menuDef, _index)
{
	local cmd, toRun, tmp

	Loop Parse, _menuDef, `n
	{
		If (_index * 2 = A_Index)
		{
			; Get command
			StringLeft cmd, A_LoopField, 1
			; Remove command
			StringTrimLeft toRun, A_LoopField, 1
			; Substitute special tag with clipboard content
			StringReplace toRun, toRun, :::, %Clipboard%, All
			If (cmd = "@")
			{
				Run %toRun%
			}
			Else If (cmd = ">")
			{
				tmp := A_KeyDelay
				SetKeyDelay -1
				Send %toRun%
				SetKeyDelay tmp
			}
			Else If (cmd = "!")
			{
				; Faster...
				tmp := Clipboard
				Clipboard := toRun
				Send ^v
				Clipboard := tmp
			}
			Else
			{
				MsgBox 16, RunMenuItem, Invalid command: '%cmd%'! (%A_LoopField%)
			}
			Break
		}
	}
}

Crypt(_string)
{
	local f, r

	f := A_FormatInteger
	SetFormat Integer, H
	Loop Parse, _string
	{
		r .= Asc(A_LoopField) ^ Asc(SubStr(A_ScriptName, A_Index, 1)) + 256
	}
	StringReplace r, r, 0x1, , All
	StringUpper r, r
	SetFormat Integer, %f%
	Return r
}
^!k:: Clipboard := Crypt(Clipboard)

Decrypt(_string)
{
	local d, r

	d := RegExReplace(_string, "..", "0x$0!")
	StringTrimRight d, d, 1
	Loop Parse, d, !
	{
		r .= Chr((A_LoopField + 0) ^ Asc(SubStr(A_ScriptName, A_Index, 1)))
	}
	Return r
}
