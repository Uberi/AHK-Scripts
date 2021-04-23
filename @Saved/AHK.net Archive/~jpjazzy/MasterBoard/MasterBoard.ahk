/*
_________________________________________________________________________________

Script Name: MasterBoard

Author: jpjazzy (Jeremy)

Forum Link:

Source helping credits:
		- Mango (many small pieces of code) by tidbit [http://www.autohotkey.com/forum/viewtopic.php?t=44727]
		- Including icons by SKAN [http://www.autohotkey.com/forum/viewtopic.php?t=33955&highlight=include+icon]
		- IconEx to extract icons by SKAN [http://www.autohotkey.com/forum/viewtopic.php?t=31670]
		- Help extracting hex data from an icon by [VxE] [http://www.autohotkey.com/forum/viewtopic.php?p=496025#496025]
		- Tray clicking interaction via guest [http://www.autohotkey.com/forum/viewtopic.php?t=79097&highlight=menu+tray+click]
		- Appending text data to clipoard help by tomoe_uehara AND RaptorX [http://www.autohotkey.com/forum/viewtopic.php?p=496904#496904]
		- Tic's GDI+ library [http://www.autohotkey.com/forum/viewtopic.php?t=32238&highlight=tic]


Description:
	Description: MasterBoard is your free, simple, and easy to use alternative to add a plethora more functionality to your clipboard (copy and paste content) on your computer. This utility makes it extremely easy to do things that manipulate the clipboard the way YOU want to handle it. For a command list, see the command list tab under the Help Menu.
	
Requirements:
GDI+ Library by tic [http://www.autohotkey.com/forum/viewtopic.php?t=32238&highlight=tic]
_________________________________________________________________________________
*/


/*
_________________________________________________________________________________
Gui list:
1. Main GUI
2. White overlay for screenshot GUI
3. GDI+ for SS
4. Command list help file GUI
5. Custom sort GUI
6. Hotkey management GUI
_________________________________________________________________________________
*/

; ##### Uncomment this line to automatically update on launch
;~ Check_ForUpdate(1) ; Checks for update on script startup and overwrites the file script if you download it

SetBatchLines, -1
#SingleInstance, Force
#NoTrayIcon
SetTimer, SetClipNum, 100
OnExit, ExitSequence

ForumLink := "http://www.autohotkey.com/forum/viewtopic.php?p=497702#497702"
SupClips := 10 ; Number of supported clipboards

About_Description = ; the description in the about section
(
Version: 1.3

Last Edit Date: 12/12/2011

Author: jpjazzy (Jeremy)

Forum Link: %ForumLink%

Description: MasterBoard is your free, simple, and easy to use alternative to add a plethora more functionality to your clipboard (copy and paste content) on your computer. This utility makes it extremely easy to do things that manipulate the clipboard the way YOU want to handle it. For a command list, see the command list tab under the Help Menu.
)


; Gui Menu
Menu, FileMenu, Add, Manage my &hotkeys...	(Win + N), MenuHandler
Menu, FileMenu, Add, Send to &tray, MenuHandler
Menu, FileMenu, Add
Menu, FileMenu, Add, E&xit, MenuHandler
Menu, HelpMenu, Add, &About, MenuHandler
Menu, MyMenuBar, Add, &File, :FileMenu  ; Attach the two sub-menus that were created above.
Menu, MyMenuBar, Add, &Help, :HelpMenu
Menu, HelpMenu, Add, &Command list, MenuHandler
Menu, HelpMenu, Add, Check for &update, MenuHandler
Menu, Tray, NoStandard
Menu, Tray, Tip, MasterBoard Control Panel ; DO NOT USE SetIcon() BEFORE THIS COMMAND
Menu, Tray, Add, Show MasterBoard Control Panel, MenuHandler
Menu, Tray, Default, Show MasterBoard Control Panel
Menu, Tray, Click, 1
Menu, Tray, Add, Suspend MasterBoard	(Win + S), MenuHandler
Menu, Tray, Add, Visit MasterBoard Forum Link	(Win + F), MenuHandler
Menu, Tray, Add, Manage Hotkeys	(Win + N), MenuHandler
Menu, Tray, Add, Reload MasterBoard, MenuHandler
Menu, Tray, Add
Menu, Tray, Add, Exit MasterBoard	(Hold ESC), MenuHandler


; Main GUI
Gui, Menu, MyMenuBar
Gui, Color, CFFFFFF
Gui, Font, S8 CDefault, Times New Roman
Gui, Add, Text, x22 y20 w130 h20 , Current clipboard number:
Gui, Add, Edit, vCurClipNum x172 y20 w60 h20 ReadOnly, 1
Gui, Add, Text, x22 y40 w150 h20 , Number of supported clipboards:
Gui, Add, Edit, vSupClips x172 y40 w60 h20 gChangeSupClips, 10
Gui, Add, Button, x242 y20 w220 h20 gClearAllClipboards, Clear all clipboards
Gui, Add, Button, x242 y60 w220 h20 gClipToText, Convert clipboard to text
Gui, Add, Text, x312 y40 w80 h20 , Switch clipboard
Gui, Add, Button, x242 y40 w30 h20 gPrevClip, -
Gui, Add, Button, x432 y40 w30 h20 gNextClip, +
Gui, Add, Text, xs ,Last clipboard to text content preview:
Gui, Add, Edit, vMCCTC readonly Wrap WantCtrlA Multi,
Gui, Font, S8 CDefault bold, Times New Roman
Gui, Add, StatusBar, vMBSB , MasterBoard Status: Running
SetTimer, HideStatusBar, -3000
Gui, +AlwaysOnTop +Resize
GuiControl, Focus, SupClips ; Keyboard control focus to Clipboard number because it is editable

Loop, 26 ; Add letters
{
	If (!HotkeyList)
		HotkeyList := "Windows key + " Chr(97+(A_index-1))
	else
		HotkeyList .= "|Windows key + " Chr(97+(A_index-1))
	
	Hotkey, % "#" Chr(97+(A_index-1)), % "Win" Chr(97+(A_index-1)) "Hotkey"
	
}

Loop, 10 ; Add numbers
{
	If (!HotkeyList)
		HotkeyList := "Windows key + " Chr(48+(A_index-1))
	else
		HotkeyList .= "|Windows key + " Chr(48+(A_index-1))
	
	Hotkey, % "#" Chr(48+(A_Index-1)), NumHandler ; All numbers are handled by this label
}

; Other hotkeys
HotkeyList .= "|Windows key + printscreen"
Hotkey, #printscreen, WinprintscreenHotkey
HotkeyList .= "|Windows key + delete"
Hotkey, #delete, WindeleteHotkey
HotkeyList .= "|Windows key + plus"
Hotkey, #=, WinplusHotkey
HotkeyList .= "|Windows key + minus" 
Hotkey, #-, WinminusHotkey

If (FileExist(A_ProgramFiles "\MasterBoard\HotkeyData.txt"))
{
	Loop, Read, %A_ProgramFiles%\MasterBoard\HotkeyData.txt
	{
		StringTrimRight, DeactivatedKey, A_LoopReadLine, 4 ; trim off the 'flag'
		Hotkey, % DeactivatedKey, Off ; Turn off hotkey
		%A_LoopReadLine% := 1 ; Set the flag
		DeactivatedKey := "" ; Clear var
	}
}



;Turn on/off hotkey GUI
Gui, 6: Default
Gui, Color, CFFFFFF
Gui, Font, bold, Times New Roman
Gui, Add, Text,, Select a hotkey to enable or disable:
Gui, Font, Norm, Times New Roman
Gui, Add, DropDownList, r25 w190 vMyHotkeySelection, %HotkeyList%
Gui, Add, Button, Default gDisableSelectedHotkey, Disable hotkey
Gui, Add, Button,gEnableSelectedHotkey, Enable hotkey
Gui, +AlwaysOnTop
Gui, Show, hide Autosize, Hotkey Preferences
Gui, 1: Default

TranlatedKey := "Windows key +"
CurClipNum := 1 ; Set to 1 initially
SetIcon("Main")
Return

EnableSelectedHotkey:
Gui, Submit, NoHide
Loop, 26 ; Alphabetical keys
{
	If (MyHotkeySelection = "Windows key + " Chr(97+(A_index-1)))
	{
		StringReplace, HTD, MyHotkeySelection, %TranlatedKey%, #
		StringReplace, HTD, HTD, %A_Space%,, 1
		Hotkey, % HTD, on
		ToolTip, % MyHotkeySelection " hotkey turned on"
		%HTD%Flag := 0 ; Flag for saving hotkeys
		SetTimer, ToolTipOff, -3000
	}
}

Loop, 10 ; Number keys
{
	If (MyHotkeySelection = "Windows key + " Chr(48+(A_index-1)))
	{
		StringReplace, HTD, MyHotkeySelection, %TranlatedKey%, #
		StringReplace, HTD, HTD, %A_Space%,, 1
		Hotkey, % HTD, on
		ToolTip, % MyHotkeySelection " hotkey turned on"
		%HTD%Flag := 0 ; Flag for saving hotkeys
		SetTimer, ToolTipOff, -3000
	}
}

;Misc hotkeys
If (MyHotkeySelection = "Windows key + printscreen")
{
		StringReplace, HTD, MyHotkeySelection, %TranlatedKey%, #
		StringReplace, HTD, HTD, %A_Space%,, 1
		Hotkey, % HTD, on
		ToolTip, % MyHotkeySelection " hotkey turned on"
		%HTD%Flag := 0 ; Flag for saving hotkeys
		SetTimer, ToolTipOff, -3000
}
Else If (MyHotkeySelection = "Windows key + delete")
{
		StringReplace, HTD, MyHotkeySelection, %TranlatedKey%, #
		StringReplace, HTD, HTD, %A_Space%,, 1
		Hotkey, % HTD, on
		ToolTip, % MyHotkeySelection " hotkey turned on"
		%HTD%Flag := 0 ; Flag for saving hotkeys
		SetTimer, ToolTipOff, -3000
}
Else If (MyHotkeySelection = "Windows key + minus")
{
		StringReplace, HTD, MyHotkeySelection, %TranlatedKey%, #
		StringReplace, HTD, HTD, %A_Space%,, 1
		Hotkey, % HTD, on
		ToolTip, % MyHotkeySelection " hotkey turned on"
		%HTD%Flag := 0 ; Flag for saving hotkeys
		SetTimer, ToolTipOff, -3000
}
Else If (MyHotkeySelection = "Windows key + plus")
{
		StringReplace, HTD, MyHotkeySelection, %TranlatedKey%, #
		StringReplace, HTD, HTD, %A_Space%,, 1
		Hotkey, % HTD, on
		ToolTip, % MyHotkeySelection " hotkey turned on"
		%HTD%Flag := 0 ; Flag for saving hotkeys
		SetTimer, ToolTipOff, -3000
}
return


DisableSelectedHotkey:
Gui, Submit, NoHide
Loop, 26 ; Alphabetical keys
{
	If (MyHotkeySelection = "Windows key + " Chr(97+(A_index-1)))
	{
		StringReplace, HTD, MyHotkeySelection, %TranlatedKey%, #
		StringReplace, HTD, HTD, %A_Space%,, 1
		Hotkey, % HTD, Off
		ToolTip, % MyHotkeySelection " hotkey turned off"
		%HTD%Flag := 1 ; Flag for saving hotkeys
		SetTimer, ToolTipOff, -3000
	}
}

Loop, 10 ; Number keys
{
	If (MyHotkeySelection = "Windows key + " Chr(48+(A_index-1)))
	{
		StringReplace, HTD, MyHotkeySelection, %TranlatedKey%, #
		StringReplace, HTD, HTD, %A_Space%,, 1
		Hotkey, % HTD, Off
		ToolTip, % MyHotkeySelection " hotkey turned off"
		%HTD%Flag := 1 ; Flag for saving hotkeys
		SetTimer, ToolTipOff, -3000
	}
}

;Misc hotkeys
If (MyHotkeySelection = "Windows key + printscreen")
{
		StringReplace, HTD, MyHotkeySelection, %TranlatedKey%, #
		StringReplace, HTD, HTD, %A_Space%,, 1
		Hotkey, % HTD, Off
		ToolTip, % MyHotkeySelection " hotkey turned off"
		%HTD%Flag := 1 ; Flag for saving hotkeys
		SetTimer, ToolTipOff, -3000
}
Else If (MyHotkeySelection = "Windows key + delete")
{
		StringReplace, HTD, MyHotkeySelection, %TranlatedKey%, #
		StringReplace, HTD, HTD, %A_Space%,, 1
		Hotkey, % HTD, Off
		ToolTip, % MyHotkeySelection "hotkey turned off"
		%HTD%Flag := 1 ; Flag for saving hotkeys
		SetTimer, ToolTipOff, -3000
}
Else If (MyHotkeySelection = "Windows key + minus")
{
		StringReplace, HTD, MyHotkeySelection, %TranlatedKey%, #
		StringReplace, HTD, HTD, %A_Space%,, 1
		Hotkey, % HTD, Off
		ToolTip, % MyHotkeySelection " hotkey turned off"
		%HTD%Flag := 1 ; Flag for saving hotkeys
		SetTimer, ToolTipOff, -3000
}
Else If (MyHotkeySelection = "Windows key + plus")
{
		StringReplace, HTD, MyHotkeySelection, %TranlatedKey%, #
		StringReplace, HTD, HTD, %A_Space%,, 1
		Hotkey, % HTD, Off
		ToolTip, % MyHotkeySelection " hotkey turned off"
		%HTD%Flag := 1 ; Flag for saving hotkeys
		SetTimer, ToolTipOff, -3000
}
return

6GuiClose:
Gui, 6: Hide
return

WinaHotkey: ; Adds new text data to clipboard and displays it in tooltip
ClipSave := Clipboard
Clipboard =
SendInput, ^c
ClipWait, 0.2
Clipboard := ClipSave " " Clipboard
ToolTip, Original clipboard = %clipsave%`nCurrent clipboard = %clipboard%
SetTimer, ToolTipOff, -3000
return

WinbHotkey: ; Clear formatted data
Clipboard := ""
Loop
{
	If (FClip%A_Index%)
		FClip%A_Index% := ""
	else
		break
}
ToolTip, Formatted clipboard data cleared.
SetTimer, ToolTipOff, -3000
Return

WincHotkey: ; Clear the current clipboard
ClipboardControl( "CSC", CurClipNum)
ToolTip, Current clipboard cleared.
SetTimer, ToolTipOff, -3000
return

WindHotkey: ; Display clipboard text content in tooltip
ClipSave := ClipboardAll
Clipboard := Clipboard
ToolTip, Displaying clipboard %CurClipNum% text content:`n%Clipboard%
SetTimer, ToolTipOff, -3000
Sleep 3000
Clipboard := ClipSave
return

WineHotkey: ; Unassigned hotkey
Return

WinfHotkey: ; Visit Forum Link
Suspend, Permit
Run, %ForumLink%
Return

WingHotkey: ; Google clipboard content
Run, http://www.google.com/search?source=ig&hl=en&rlz=&q=%Clipboard%&btnG=Google+Search&aq=f
ToolTip, Googling clipboard...
SetTimer, ToolTipOff, -3000
return

WinhHotkey: ; Unassigned hotkey
Return

WiniHotkey: ; Google image search clipboard
Run, http://images.google.com/images?um=1&hl=en&newwindow=1&safe=off&client=opera&rls=en&q=%Clipboard%&btnG=Search+Images
ToolTip, Google image searching clipboard...
SetTimer, ToolTipOff, -3000
return

WinjHotkey: ; Run dictionary lookup on clipboard
Run, http://dictionary.reference.com/browse/%Clipboard%
Return

WinkHotkey: ; Unassigned hotkey
Return

WinlHotkey: ; convert to lowercase
StringLower, Clipboard, Clipboard
return

WinmHotkey: ; IMDb movie search
Run, http://www.imdb.com/find?s=all&q=%Clipboard%
Return

WinnHotkey: ; Hotkey Disabling control
Gui, 6: Show
Return

WinoHotkey: ; Organize/Sort clipboard data by line
ToolTip, Choose a sorting method:`n1: Normal Sort`n2: Reverse Sort`n3: Random Sort`n4: Cancel Sort`n`n5: Advanced sort...
Input, SMethod, L1
If (SMethod = 1)
{
  ToolTip, Clipboard sorted by Numeric Value/Alphabetic Characters.
  Sort, Clipboard
}
Else If (SMethod = 2)
{
  ToolTip, Clipboard sorted by Reverse Alphabetic Characters/Numeric Value.
  Sort, Clipboard, R
}
Else If (SMethod = 3)
{
  ToolTip, Clipboard sorted Randomly.
  Sort, Clipboard, Random
}
Else If (SMethod = 4)
{
  ToolTip, Sort Cancelled.
}
Else If (SMethod = 5)
{
 Run, http://www.autohotkey.com/docs/commands/Sort.htm
  Gui, 5: Default
  Gui, +Owner
  Gui, Font, Bold, Times New Roman
  Gui, Add, Text,, Please input an advanced sort options set [as shown in the documentation brought up]:
  Gui, Font, Norm
  Gui, Add, Edit, w430 vSortOptions,
  Gui, Add, Button, default gCusSort, Start sort
  Gui, Show, Autosize, Advanced Sort
}
else
{
  Tooltip, Unrecognized choice option... Sort Cancelled.
}
SetTimer, ToolTipOff, -3000
return

WinpHotkey: ; Unassigned hotkey
return

WinqHotkey: ; Unassigned hotkey
return

WinrHotkey: ; restore saved clipboards from last exit [Clipboards save on exit]
CurClipNum := ClipboardControl("LSC")
return

WinsHotkey: ; Suspend keys
Suspend, Permit
SuspendToggle()
return

WintHotkey: ; Convert to plain text
ClipToText:
Clipboard := Clipboard
GuiControl,, MCCTC, %Clipboard%
ToolTip, Converted clipboard to unformatted text.
SetTimer, ToolTipOff, -3000
return

WinuHotkey: ; convert to uppercase
StringUpper, Clipboard, Clipboard
return

WinvHotkey: ; paste formatted data
SendInput, ^v
Sleep 50
Loop
{
	If (FClip%A_Index%)
	{
	Clipboard := ""
	Clipboard := " " FClip%A_Index%
	ClipWait
	SendInput ^v
	Sleep 50
	}
	else
		break
}
ToolTip, Formatted clipboard data pasted.
SetTimer, ToolTipOff, -3000
return

WinwHotkey: ; Wikipedia search
Run, http://en.wikipedia.org/wiki/Special:Search?search=%Clipboard%
return

WinxHotkey: ; ; Add formatted data 
ClipSave := ClipboardAll
Clipboard := ""
SendInput, ^c
ClipWait
Loop
{
	If (!FClip%A_Index%)
	{
		FClip%A_Index% := ClipboardAll
		break
	}
}
Clipboard := ""
Clipboard := ClipSave
ClipWait
ClipSave := ""
ToolTip, Formatted clipboard data added.
SetTimer, ToolTipOff, -3000
return

WinyHotkey: ; YouTube clipboard content
Run, www.youtube.com/results?search_query=%Clipboard%
ToolTip, YouTubing clipboard...
SetTimer, ToolTipOff, -3000
return

WinzHotkey: ; Reverts to last clipboard
Clipboard := OldClipboard
ToolTip, Reverted to last clipboard.
SetTimer, ToolTipOff, -3000
SetIcon("Check")
SetTimer, ReturnMainIcon, -700
return

WinprintscreenHotkey: ; user selected area to clipboard
ToolTip, Drag the left mouse button to define`nan area to store on the clipboard.
SetTimer, ToolTipOff, -4000
SStoClip()
return

WindeleteHotkey: ; Clear all clipboards
ClearAllClipboards:
ClipboardControl( "CAC" )
ToolTip, All clipboards cleared.
SetTimer, ToolTipOff, -3000
return

WinminusHotkey: ; Back one clipboard number
PrevClip:
If (CurClipNum > 1)
{
ClipboardControl( "STC", CurClipNum-1, CurClipNum )
CurClipNum--
}
else
	gosub, ErrorSwitch
return

WinplusHotkey: ; Forward one clipboard number
NextClip:
If (CurClipNum < SupClips)
{
ClipboardControl( "STC", CurClipNum+1, CurClipNum )
CurClipNum++
}
else
	gosub, ErrorSwitch
return

;This hotkey must remain on.
~*Esc:: ; Gives the user the option to quit the application
If (OverlayFlag)
{
	Gui, 2: Destroy
	Gui, 3: Destroy
	OverlayFlag := "Error"
}
KeyWait, Esc, T1.5
If (ErrorLevel)
{
	MsgBox, 4116, Exit, Do you wish to exit MasterBoard?
	IfMsgBox, Yes
	{
	ExitApp	
	}
}
return

SetClipNum: ; Clip number polling for the GUI
GuiControl,, CurClipNum, %CurClipNum%
return

MenuHandler: ; Handles menu items
If (A_ThisMenuItem = "Show MasterBoard Control Panel" && A_ThisMenu = "Tray")
{
	ClipSave := ClipboardAll
	Gui, Show, Autosize, MasterBoard Control Panel
}

Else If (A_ThisMenuItem = "&About" && A_ThisMenu = "HelpMenu")
{
	SetIcon("Info")
	MsgBox, 4160, About MasterBoard, %About_Description%
	SetIcon("Main")
}
Else If (A_ThisMenuItem = "Check for &update" && A_ThisMenu = "HelpMenu")
	{
	Check_ForUpdate(1, 0, "",  ErrorInfo)
	MsgBox, 64, Update Information, %ErrorInfo%, 10 ; Times out after 10 seconds to resume the script
	}
Else If (A_ThisMenuItem = "Send to &tray" && A_ThisMenu = "FileMenu")
	Gui, Hide
Else If (A_ThisMenuItem = "E&xit" && A_ThisMenu = "FileMenu" || A_ThisMenuItem = "Exit MasterBoard	(Hold ESC)" && A_ThisMenu = "Tray")
	ExitApp
Else If (A_ThisMenuItem = "Reload MasterBoard" && A_ThisMenu = "Tray")
	Reload
Else If (A_ThisMenuItem = "Suspend MasterBoard	(Win + S)" && A_ThisMenu = "Tray")	
	SuspendToggle()
Else If (A_ThisMenuItem = "Visit MasterBoard Forum Link	(Win + F)" && A_ThisMenu = "Tray")
	Run, %ForumLink%
Else If (A_ThisMenuItem = "&Command list" && A_ThisMenu = "HelpMenu")
	Gosub, LoadHelpFile
Else If (A_ThisMenuItem = "Manage my &hotkeys...	(Win + N)" && A_ThisMenu = "FileMenu" || A_ThisMenuItem = "Manage Hotkeys	(Win + N)" && A_ThisMenu = "Tray")
	Gui, 6: Show
return

NumHandler: ; Handle windows keys + number to trigger clipboard changes
StringTrimLeft, NClipNum, A_ThisHotkey, 1
If (NClipNum = 0)
	NClipNum := 10
ClipboardControl( "STC", NClipNum, CurClipNum)
CurClipNum := NClipNum
NClipNum := ""
return


ErrorSwitch: ; Error message
SetIcon("Error")
SetTimer, ReturnMainIcon, -1000
ToolTip, You have exceeded the number of supported clipboards.
SetTimer, ToolTipOff, -3000
return

GuiSize: ; If minimized, then hide the GUI, or else resize the edit box to fit
if (A_EventInfo = 1)
	Gui, Hide
Else
{
	My_GuiWidth := A_GuiWidth
	My_GuiHeight := A_GuiHeight
	
	If (SB_HideFlag)
		GuiControl, Move, MCCTC, % "w" A_GuiWidth-50 " h" A_GuiHeight-115 
	else
		GuiControl, Move, MCCTC, % "w" A_GuiWidth-50 " h" A_GuiHeight-135 
}
return

ToolTipOff: ; Turn off the tooltip
ToolTip
return

HideStatusBar:
SB_HideFlag := 1
GuiControl, Hide, MBSB
If ( My_GuiHeight && My_GuiWidth)
	GuiControl, Move, MCCTC, % "w" My_GuiWidth-50 " h" My_GuiHeight-115
return

ReturnMainIcon: ; Set the icon back to main icon
SetIcon("Main")
return

ChangeSupClips: ; Change number of supported clips
Gui, Submit, NoHide
return

ExitSequence: ; Save data needed on exit
ClipboardControl( "SCD", "", CurClipNum)
IniWrite, %SupClips%, %A_ProgramFiles%\MasterBoard\MasterBoardData.ini, ClipData, SupClips

If (FileExist(A_ProgramFiles "\MasterBoard\HotkeyData.txt"))
	FileDelete, %A_ProgramFiles%\MasterBoard\HotkeyData.txt

Gui, Submit, NoHide
Loop, 26 ; Alphabetical keys
{
	LCheck := Chr(97+(A_index-1))
	If (#%LCheck%Flag = 1)
	{
		If (!SavedKeyConfig)
			SavedKeyConfig := "#" Chr(97+(A_index-1)) "Flag"
		else
			SavedKeyConfig .= "`n#" Chr(97+(A_index-1)) "Flag"
	}
}

Loop, 10 ; Number keys
{
	NCheck := Chr(48+(A_index-1))
		If (#%NCheck%Flag = 1)
	{
		If (!SavedKeyConfig)
			SavedKeyConfig := "#" Chr(48+(A_index-1)) "Flag"
		else
			SavedKeyConfig .= "`n#" Chr(48+(A_index-1)) "Flag"
	}
}

;Misc hotkeys
	If (#printscreenFlag = 1)
	{
		If (!SavedKeyConfig)
			SavedKeyConfig := "#printscreenFlag"
		else
			SavedKeyConfig .= "`n#printscreenFlag"
	}
	If (#deleteFlag = 1)
	{
		If (!SavedKeyConfig)
			SavedKeyConfig := "#deleteFlag"
		else
			SavedKeyConfig .= "`n#deleteFlag"
	}
	If (#minusFlag = 1)
	{
		If (!SavedKeyConfig)
			SavedKeyConfig := "#minusFlag"
		else
			SavedKeyConfig .= "`n#minusFlag"
	}
	If (#plusFlag = 1)
	{
		If (!SavedKeyConfig)
			SavedKeyConfig := "#plusFlag"
		else
			SavedKeyConfig .= "`n#plusFlag"
	}
If (SavedKeyConfig)
	FileAppend, %SavedKeyConfig%, %A_ProgramFiles%\MasterBoard\HotkeyData.txt

ExitApp

GuiClose: ; Exit application prompt
MsgBox, 4116, Exit, Do you wish to exit MasterBoard?
	IfMsgBox, Yes
	{
	ExitApp	
	}
	else
		Gui, Hide
	return

5GuiClose:
Gui, 5: Destroy
return

CusSort: ; Custom Sort options
Gui, 5: Submit
Gui, 5: Destroy
Sort, Clipboard, %SortOptions%
ToolTip, Clipboard sorted using custom options.
SetTimer, ToolTipOff, -3000
return

OnClipboardChange: ; For reverting to previous clipboard
OldClipboard := NewBoard
NewBoard := ClipboardAll
return

; ######################################################
; Switch clipboard ( Clipboard control command, Clipboard number to switch to, Current Clipboard Number, Display tooltip? [1/0])
; ######################################################

; ######################################################
; Clipboard control
;
;	Commands:
;			Switch to clipboard (STC) - Switches to specified clipboard
;			Clear all clipboards (CAC) - Clears all clipboards
;			Clear Selected Clipboard (CSC) - Clears the selected clipboard
;			Save clipboard(s) data (SCD) - Saves the clipboards to Program Files\MasterBoard
;			Load saved clipboards (LSC) - Load saved clipboards
; ######################################################
ClipboardControl( _ClipControlCmd, _ClipNum="", _CurClipNum="", _DisplayTTO=1  ){
	Static
	

	If (_ClipControlCmd = "STC")
	{
		If (!_ClipNum || !_CurClipNum)
		{
			MsgBox, 16, Error in ClipControl(), You cannot switch clipboards without the clipboard number to switch to and current clipboard number.
			return
		}
		SetIcon("Cycle")
		SetTimer, ReturnMainIcon, -1000
	MyClipboard%_CurClipNum% := ClipboardAll
	Clipboard := MyClipboard%_ClipNum%
	ClipWait, 0.2
		If (_DisplayTTO)
		{
			ToolTip, Switched to clipboard %_ClipNum%
			SetTimer, ToolTipOff, -3000
		}
	}
	Else If (_ClipControlCmd = "CAC")
	{
		global SupClips
		Loop, %SupClips%
		{
			MyClipboard%A_Index% := ""
			Clipboard := ""
		}
	}
	Else If (_ClipControlCmd = "CSC")
	{
		MyClipboard%_ClipNum% := ""
		Clipboard := ""
	}
	Else If (_ClipControlCmd = "SCD" && _CurClipNum)
	{
		IfExist, %A_ProgramFiles%\MasterBoard
			{
				FileRemoveDir, %A_ProgramFiles%\MasterBoard, 1
			}
			FileCreateDir, %A_ProgramFiles%\MasterBoard
			FileAppend, %ClipboardAll%, %A_ProgramFiles%\MasterBoard\Clipboard0Data.txt
			Loop
			{
				If (MyClipboard%A_Index%)
					FileAppend, % MyClipboard%A_Index%, %A_ProgramFiles%\MasterBoard\Clipboard%A_Index%Data.txt
				else
				{
					IniWrite, %A_Index%, %A_ProgramFiles%\MasterBoard\MasterBoardData.ini, ClipData, NumOfClips
					IniWrite, %_CurClipNum%, %A_ProgramFiles%\MasterBoard\MasterBoardData.ini, ClipData, CurrentClip
					break
				}
			}
	}
	Else If (_ClipControlCmd = "LSC")
	{
		IfExist, %A_ProgramFiles%\MasterBoard\Clipboard0Data.txt
			{
				IniRead, _NOC, %A_ProgramFiles%\MasterBoard\MasterBoardData.ini, ClipData, NumOfClips
				IniRead, _CCN, %A_ProgramFiles%\MasterBoard\MasterBoardData.ini, ClipData, CurrentClip
				IniRead, SupClips, %A_ProgramFiles%\MasterBoard\MasterBoardData.ini, ClipData, SupClips
				GuiControl,, SupClips, %SupClips%
				Loop
				{
					If(FileExist(A_ProgramFiles "\MasterBoard\Clipboard" A_Index "Data.txt"))
						FileRead, MyClipboard%A_Index%, *c %A_ProgramFiles%\MasterBoard\Clipboard%A_Index%Data.txt
					else
						break
				}
				FileRead, Clipboard, *c %A_ProgramFiles%\MasterBoard\Clipboard0Data.txt
				ToolTip, Clipboard load complete. Current clipboard set to %_CCN%.
				SetTimer, ToolTipOff, -3000
				return _CCN ; Returns active clipboard number
			}
			MsgBox, 16, ERROR, No old clipboard data was found.
	}
return
}

; ##################### HEX ICON DATA FUNCTION (Special thanks to SKAN) ########################################
; Icon list for this script: Main, Check, Cycle, Error, Info
SetIcon( _WhichIcon ){
MainIconData =
(
00000100010010100000010020006804000016000000280000001000000020000000010020000000000000040000120B0000120B00000000000000000000FFFFFF00FFFFFF0000074999000647CC000647CC000647CC000647CC000647CC000647CC000647CC000647CC000647CC000647CC0007499900084A0031311000FFFFFF00FFFFFF00001055CC396CB0FF3669ADFF3568ACFF3467ABFF3467ABFF3467ABFF3366AAFF3366AAFF3265A9FF3265A9FF001055CC21241D0031311000FFFFFF00FFFFFF00001D67CC376AAEFF3164A8FF3164A8FF3164A8FF32516DFF314958FF314958FF314958FF314958FF314A59FF1C2935E73131108534341264FFFFFF00FFFFFF0000236ECC376AAEFF2E61A5FF2E61A5FF2E61A5FF3B5668FFFFFFFFFFFFFFFEFFFEFEFDFFFDFDFBFFFDFDF9FFFCFCF7FFFDFDF8FF4A4A277BFFFFFF00FFFFFF00002672CC386BAEFF2C5FA2FF2C5FA2FF2C5FA2FF405B6EFFFFFFFEFFBDBDACFFBDBDACFFCECEBDFFC6C6B5FFDFDFCEFFFAFAF4FF57573276FFFFFF00FFFFFF00002977CC386BAFFF295CA0FF295CA0FF295CA0FF415D71FFFEFEFDFFE2E2D1FFE2E2D1FFE2E2D1FFE2E2D1FFE2E2D1FFFAFAF2FF5E5E3873FFFFFF00FFFFFF00002C7BCC3F72B6FF285B9FFF26599DFF26599DFF425E73FFFDFDFBFFC5C5B4FFC5C5B4FFD6D6C5FFD6D6C5FFCDCDBCFFF8F8ECFF65653E71FFFFFF00FFFFFF0000307FCC487BBFFF3669ADFF2C5FA3FF25589CFF425F75FFFDFDF9FFEBEBDAFFEBEBDAFFF5F5EEFFF3F3EBFFEEEEE3FFF5F5E5FF6B6B446EFFFFFF00FFFFFF00003383CC4D80C4FF3E71B5FF3E71B5FF3A6DB1FF4D6A81FFFCFCF7FFCCCCBBFFD4D4C3FFF3F3EBFFA4A493FFA4A493FFA4A493FF4949257CFFFFFF00FFFFFF00003587CC5184C8FF4376BAFF4376BAFF4376BAFF58768DFFFBFBF5FFF5F5EEFFF3F3EBFFEEEEE3FFB6B6A5FFFFFFFFFF76764D6A76764D26FFFFFF00FFFFFF0000388ACC5689CDFF487BBFFF487BBFFF487BBFFF5D7B93FFFDFDF6FFFAFAF2FFF8F8ECFFF4F4E5FFC2C2B1FF395770E17B7B512576764D00FFFFFF00FFFFFF00003A8DCC598CD0FF4D80C4FF4073B7FF4073B7FF517598FF59778FFF59778FFF59778FFF617F97FF67859DFF154684D43E5B70003B596E00FFFFFF00FFFFFF00003D90CC5C8FD3FF2C5FA3FF24579BFF2A5DA1FF3063A7FF3265A9FF2D60A4FF275A9EFF2E61A5FF5A8DD1FF003D90CC003D9000003D9000FFFFFF00FFFFFF00003F93CC6295D9FF3A6DB1FFD2C7C7FFD8CFCFFFE4DEDEFFE4DEDEFFD8CFCFFFD2C7C7FF3A6DB1FF6093D7FF003F93CC003F9300003F9300FFFFFF00FFFFFF0000409599004095CC004095CC003186D06E78A2E6DCDADAFFDCDADAFF6E78A2E6003186D0004095CC004095CC00409599003F9400003F9400FFFFFF00FFFFFF00004095000040950000409500294974065454545254545467545454675454545229497406004095000040950000409500003F9400003F9400C0030000C0030000C0000000C0000000C0000000C0000000C0000000C0000000C0000000C0000000C0010000C0030000C0030000C0030000C0030000F81F0000
)
CheckIconData = 
(
0000010001001010000001000800680500001600000028000000100000002000000001000800000000000001000000000000000000000001000000010000000000007A797A00AC8B1B00AE911D00B5971600B7981200BA9B1100BB9F1700A8882200B1932400B69A2300B69A2800AC8E3900AF933A00B79B3B00BCA22B00C4A71300C2A61600C5AB1500C9AB1000CDB01200CCB01B00CBB21E00D0B72000D2B82500D1BB2F00CEB63100CFBA3800D7C62B00D7C52C00D7C33400D9C23200DBCA3000DCCC3100DED03600E0D43700E2D23B00E6D93D00B2985000C6B24A00CCB54800CBB74E00C9BA5F00DECF4500D7C35000D5C35E00DDCE5C00E3D54500E2D64900E5D94A00E6DB5300E6DB5500E5D95C00E8DD5B00D6C56200D4C57F00E7DB6400E8DE6200E9DE6600E1D46A00E8DD6900E8DE6F00E3D67100E7DC7700E5DB7E00EAE07100EBE277008B898900909090009B979700A5A1A000A4A4A400B1B0B100BEB9B700C6BEB100C6BFB600D8CC8E00DCD18F00CFC29100D2C39100D3C79400DBD09B00E1D58500E7DB8300E0D59300EDE78600E8E08C00EDE59E00C7C0B700CEC6B200C7C0B800C8C2BA00D2CBB700D7D0BB00ECE3A000EEE7A200EFE8A800EFE8AE00F4ECAF00F0EAB100D0C9C800D8D2CE00F5EFC500EFECDA00F4EFE400F5F1E800FDFBF300FCFBF600FDFCF700FEFDFB00FEFEFE00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000FFFFFF000000000000484401014448000000000000000048434649646449464348000000000046455A50260803284E4A454600000048455C2A026B620C10172C5945480000435A36096D6D6D5705141F364A43004846510F6B6D616D6D0C13181E4C464844492E686D6B0A616D5F0615192D494401642F5569271C526D6D0D10151B6401016438252422211C616D5704121A640144494035313023213B6D6D0E07284944484654413933302321566D660B50464800435B53413C3330222B636D374A43000048455D534139333321616765454800000046455B544039343E4D5B454600000000004843464964644946434800000000000000004844010144480000000000F81F0000E0070000C003000080010000800100000000000000000000000000000000000000000000000000008001000080010000C0030000E0070000F81F0000
)
CycleIconData = 
(
000001000100101000000100200068040000160000002800000010000000200000000100200000000000400400000000000000000000000000000000000000000000000000000000000000000000C2753B148F562C9F7D4B262B00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000CF7D3F818A532AFC643C1E5D6D4221157245231C7D4B2608000000000000000000000000000000000000000000000000000000000000000000000000D580413CD27F40F0AC6834FF845028E3704422DD653D1FDB59361BB856341A6C6F432212000000000000000000000000000000000000000000000000CC7B3E16CD7C3EC3D58041FFDA8442FFD78241FFD88342FFD78241FFBF743AFF89532AFF5D381CC1643C1E2C0000000000000000000000000000000000000000E69659A8E59051FFE48B49FFE38946FFE48B49FFE69559EAECAD7ED3EFBC96E1EEB68CEFE69559FF8E552BDB6D42212D00000000000000000000000000000000EFBA9276F0BE98E0EDB387FAE89E67FFDF8744FFCA7A3D8D000000000000000000000000F0C19D70E9A36FEAB26B36D00000000000000000000000000000000000000000EFBD9707F1C3A078F0C09BD9EAA774FBAD6834D700000000000000000000000000000000EFBC962EE79C62C000000000000000000000000000000000000000000000000000000000EFBD9702F0BE997CE6975BB0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000E79A600500000000A9663387623B1E4400000000000000000000000000000000000000000000000000000000C7783DA2824E28830000000000000000000000000000000000000000DD8543F9724523E558351B885F391D490000000000000000000000000000000000000000EBA97861E38946EC7C4B26B65231194D000000000000000000000000E38945E0C4763CFF985C2EFF6D4221E6643C1E960000000000000000000000000000000000000000EEB88F7FE89E66FF9F6030FE653D1FE15E391DD19B5D2FD2CB7A3EF6E28845FFDD8543FFCA7A3DFF94592DF00000000000000000000000000000000000000000EDB58A02F0C19D75EFBA92EDEAA571FFE59151FFE48D4BFFE48E4CFFE48E4DFFE48C4AFFE48B49F9C5773C7F00000000000000000000000000000000000000000000000000000000F0BF9A38F0C19D99EFBD97CDEEB990E2EEB68CDAEBAB7AF7E59354FFD27F40B2DF87440A0000000000000000000000000000000000000000000000000000000000000000ECB08301EEB78E13EEB78E1FEFBD9721EEB991C7E69558EECF7D3F3500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000EEB9908BE89E677C00000000000000000000000000000000F1FF0000F03F0000E00F0000C0070000C0030000C0E30000E0F30000F8FF0000FE9F0000CF870000C3830000E0030000E0030000F8030000FC070000FFCF0000
)
ErrorIconData = 
(
0000010001001010000001000800680500001600000028000000100000002000000001000800000000000001000000000000000000000001000000010000000000000000790001017C007A797A0006068800010195000202990000009D00161697001C1C9C00343489000404A1000000AA000101AE000101B2000303B4000505B6000101B9002625A1002B29A7002C2AAD002121BD002D2DBC004444BE005957B2000000C1000809C3000909C6001615C900191ACC001E1FD7002C2CC1003F3FC2003030CA003434D1003636D7003939DD005250C2005250C5005A57C0005150CA005857CE00605ED9006462C7006060CD007371CD006260D1006866D5006E6FDB006C6CDC007272D6007D7AD3006D6DE5007B7AE600847FC4008B898900909090009B979700A29EBE00A5A1A000A4A4A400B4AFBC00B1B0B100BEB9B700B6B0BD008581C7008884C5008C88C5008481C8008585CB008C8CCF009490CA008080D0008F8FD0008885D8009191D4009D9DD3009090DA00A29ECD00AAA5C800BCB6C100BDBDCF00A6A1D200ACA7D500AFABD000ABABD500A8A8DC00BDBDD1008282E7009D9DE7008D8DF100A0A0E900B6B6E300B6B6EE00BBBBE800D0C9C800C7C7D700D2D2DC00E5E4DC00F7F7DA00D9D9E400D7D7EC00DDDDF700F5F4E200F5F5E500F9F9E500FFFFE600F6F6E800FFFFE900FFFFEC00F8F8F000FFFFF100FFFFF90000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000FFFFFF0000000000003E380303383E00000000000000003E373B3F5F5F3F3B373E00000000003B393D36251F1F25443D393B0000003E393A140C070C111907134E393E0000374018485E010711076544124037003E3B4220556D600105616F5D04413B3E383F2B0C15556D5151635C0911253F38035F28110C174C696856080C0C165F03035F292111114B68684B010711165F03383F331C215B706D6269460105273F383E3B52345B70703429696F460A433B3E003750356670581B1B3269642F403700003E3954345A1E24231D322A4F393E0000003B3950534A2F2E2D4740393B00000000003E373B3F5F5F3F3B373E00000000000000003E380303383E0000000000F81F0000E0070000C003000080010000800100000000000000000000000000000000000000000000000000008001000080010000C0030000E0070000F81F0000
)
InfoIconData = 
(
0000010001001010000001000800680500001600000028000000100000002000000001000800000000000001000000000000000000000001000000010000000000007A797A00943112009431140099321400A83F1A00AC3F1A00B33F1C00BA3F1F00AA401B00AE441E00B0401B00B6401C00B0441E00BA401F0096462C00AE4C2A00B0472100BF402000B2492100B04B2A00BF583100DE5D2D00C25C3400C6603900CA623A00CF653A00CA633C00CD653C00BC684E00A4665100B0685400BA6D5100BD6F5300BF6F5400B4755F00B8766400CE694100CA6C4700D56D4200D46F4700D4704700D1714D00DD754A00DA764E00C3695000C76D5700C86D5700CA7D5F00E5724700ED734500E17C5300E57D5100E87F5700BA837000BD837200EF835900CD866900D48B6E00D78D6F00C18E7D00C98C7800E68A6400EE8B6500F0916B00F4936D00F4946E00EA9A7600F79C78008B898900909090009B979700A5A1A000A4A4A400B1B0B100BEB9B700CC8F8000C9918100CC9A8700CC9B8900DD9C8200D6A69300D7AA9B00D7AC9B00E1A08700CEACA300CBB0A600C4B2AE00CFB4AA00DBB0A000C5B6B100C8B8B400D3B9B000DDBBB100DDBCB400D0C9C800D1D2D400D7D8DA00F5E4DD00FFF9F200FAFBFB0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000FFFFFF0000000000004A460101464A00000000000000004A45484B5F5F4B48454A00000000004847574D2D0F0F1E4C5747480000004A4756220C3D5D5D1F042F55474A00004557210C0B5264642404122D5745004A484F130B0B526064240312124D484A464B3015130B52616437030C071D4B46015F261B170B5261643C030C09145F01015F2A26251B52616437030B0B145F01464B3B252B2553626423050B0A1F4B464A48532B2B2C353231161B18174F484A00455B5035354062633F1A26395A4500004A475C543544646442253B58474A00000048475B594340403F515B474800000000004A45484B5F5F4B48454A00000000000000004A460101464A0000000000F81F0000E0070000C003000080010000800100000000000000000000000000000000000000000000000000008001000080010000C0030000E0070000F81F0000
)

IconDataHex := %_WhichIcon%IconData

VarSetCapacity( IconData,( nSize:=StrLen(IconDataHex)//2) )
Loop %nSize% ; MCode by Laszlo Hars: http://www.autohotkey.com/forum/viewtopic.php?t=21172
  NumPut( "0x" . SubStr(IconDataHex,2*A_Index-1,2), IconData, A_Index-1, "Char" )
IconDataHex := ""                                          ; Hex contents needed no more

hICon := DllCall( "CreateIconFromResourceEx", UInt,&IconData+22, UInt,NumGet(IconData,14)
       , Int,1, UInt,0x30000, Int,16, Int,16, UInt,0 )

; Thanks Chris : http://www.autohotkey.com/forum/viewtopic.php?p=69461#69461
Gui +LastFound               ; Set our GUI as LastFound window ( affects next two lines )
SendMessage, ( WM_SETICON:=0x80 ), 0, hIcon                ; Set the Titlebar Icon
SendMessage, ( WM_SETICON:=0x80 ), 1, hIcon                ; Set the Alt-Tab icon

; Creating NOTIFYICONDATA : www.msdn.microsoft.com/en-us/library/aa930660.aspx
; Thanks Lexikos : www.autohotkey.com/forum/viewtopic.php?p=162175#162175
PID := DllCall("GetCurrentProcessId"), VarSetCapacity( NID,444,0 ), NumPut( 444,NID )
DetectHiddenWindows, On
NumPut( WinExist( A_ScriptFullPath " ahk_class AutoHotkey ahk_pid " PID),NID,4 )
DetectHiddenWindows, Off
NumPut( 1028,NID,8 ), NumPut( 2,NID,12 ), NumPut( hIcon,NID,20 )

Menu, Tray, Icon                                           ; Show the default Tray icon ..
DllCall( "shell32\Shell_NotifyIcon", UInt,0x1, UInt,&NID ) ; .. and immediately modify it
return
}

;Suspension workaround for my icon + check toggling
SuspendToggle(){
	static
	SusTog := !SusTog
	Menu, Tray, ToggleCheck, Suspend MasterBoard	(Win + S)
	
	If (SusTog)
	{
		Menu, Tray, Icon,,, 1
		Global My_GuiWidth, My_GuiHeight, SB_HideFlag
		SB_HideFlag := 0
		GuiControl, Move, MCCTC, % "w" My_GuiWidth-50 " h" My_GuiHeight-135
		GuiControl, Show, MBSB
		SB_SetText("MasterBoard Status: Suspended")
	}
	
	Suspend	
	
	If (!SusTog)
	{
		Menu, Tray, Icon,,, 0
		Global My_GuiWidth, My_GuiHeight, SB_HideFlag
		SB_HideFlag := 0
		GuiControl, Move, MCCTC, % "w" My_GuiWidth-50 " h" My_GuiHeight-135
		GuiControl, Show, MBSB
		SB_SetText("MasterBoard Status: Running")
		SetTimer, HideStatusBar, -3000
		SetIcon("Main")
	}
	Return SusTog
}

; Stores selected area in clipboard
SStoClip(){
Global OverlayFlag
DefineBox(TLX, TLY, BLX, BLY, BW, BH)
If (OverlayFlag = "Error")
{
	ToolTip, Error: Screencap exited
	SetTimer, ToolTipOff, -3000 
	return
}
ScreenPass := TLX "|" TLY "|" BW "|" BH
if (!pToken:=Gdip_Startup()) {
      msgbox, 48, gdiplus error!, Gdiplus failed to start. Please ensure you have gdiplus on your system
      ExitApp
   }
MypBitmap := Gdip_BitmapFromScreen(ScreenPass)
Gdip_SetBitmapToClipboard(MypBitmap)
DeleteObject(MypBitmap)
ToolTip, Screenshot stored on clipboard.
SetTimer, ToolTipOff, -3000
return
}


; User defined box and the dimensions
DefineBox(ByRef TopLeftX, ByRef TopLeftY, ByRef BottomRightX, ByRef BottomRightY, ByRef BoxWidth, ByRef BoxHeight) ;This function needs to return the coords of the top left corner x/y  of the square and bottom right corner x/y of the square
{
CoordMode, ToolTip, Screen
CoordMode, Pixel, Screen
CoordMode, Mouse, Screen
WS_EX_LAYERED:=0x00080000 ;positioned here for ease of GDI+ use
WS_EX_NOACTIVATE:=0x08000000
{
    ;generate GUI to cover the active window so you don't play with things in it while you select your box.
   Gui, 2: +LastFound -Caption +AlwaysOnTop
   Gui, 2: Color, White
   Gui, 2: Show, Hide
   WinSet, Transparent, 100
   Gui, 2: Show, NA x0 y0 w%A_ScreenWidth% h%A_ScreenHeight%
   Global OverlayFlag
   OverlayFlag := 1
   
   
   ;Wait for the left mouse button to start the GDI+
   KeyWait, LButton, D
   if (!pToken:=Gdip_Startup()) {
      msgbox, 48, gdiplus error!, Gdiplus failed to start. Please ensure you have gdiplus on your system
      ExitApp
   }
;Generate the GDI+
Gui, 3: +LastFound -Caption +AlwaysOnTop +E%WS_EX_LAYERED% +E%WS_EX_NOACTIVATE%
Gui, 3: Show, NA
Width:=A_ScreenWidth
Height:=A_ScreenHeight
   MouseGetPos, MX, MY
   MX := MX-1
   MY := MY-1

Loop {
   MouseGetPos, NewMX, NewMY
   NewMX := NewMX-1
   NewMY := NewMY-1
   XWidth := (NewMX-MX)
   YHeight := (NewMY-MY)

hwnd1 := WinExist()
hbm := CreateDIBSection(Width, Height)
hdc := CreateCompatibleDC()
obm := SelectObject(hdc, hbm)
G := Gdip_GraphicsFromHDC(hdc)
Gdip_SetSmoothingMode(G, 4)
pPen := Gdip_CreatePen(0x990000ff, 2)
Gdip_DrawRectangle(G, pPen, MX, MY, XWidth, YHeight)
Gdip_DeletePen(pPen)
UpdateLayeredWindow(hwnd1, hdc, 0, 0, Width, Height)
SelectObject(hdc, obm)
DeleteObject(hbm)
DeleteDC(hdc)
Gdip_DeleteGraphics(G)
if (GetKeyState("LButton", "P") = 0)
   {
      Break
   }
}
   Gui, 2:Destroy
   Gui, 3:Destroy
   
   If (OverlayFlag != "Error")
	OverlayFlag := 0
   
   TopLeftX:=MX
   TopLeftY:=MY
   BottomRightX:=NewMX
   BottomRightY:=NewMY
   BoxWidth := NewMX-MX
   BoxHeight := NewMY-MY
}
CoordMode, ToolTip, Relative
CoordMode, Pixel, Relative
CoordMode, Mouse, Relative
return
}

; ##################### Command list help file GUI #########################
LoadHelpFile:
If (LoadCmdListFlag)
	return

Loop, 26 ; Add letters
{
	If (!HelpList)
		HelpList := "Windows key + " Chr(97+(A_index-1))
	else
		HelpList .= "|Windows key + " Chr(97+(A_index-1))
}

Loop, 10 ; Add numbers
{
	If (!HelpList)
		HelpList := "Windows key + " Chr(48+(A_index-1))
	else
		HelpList .= "|Windows key + " Chr(48+(A_index-1))
}

		HelpList .= "|Windows key + [" Chr(45) " key]"
		HelpList .= "|Windows key + [" Chr(43) " key]"
		HelpList .= "|Windows key + [PrtSc key]"
		HelpList .= "|Windows key + [Delete key]"
		HelpList .= "|Esc key"
		HelpList .= "|Number of supported clipboards"
		
Sort, HelpList, D|
	
Gui, 4: Default
Gui, +Owner
Gui, Add, Text,, Search:
Gui, Add, Edit, w160 vsearchedString gIncrementalSearch, 
Gui, Add, Listbox, w160 h290 vSelCom gListBoxClick, %HelpList%
Gui, Font, s10 bold, Times New Roman
Gui, Add, Text, ys, Command:
Gui, Font, norm, Times New Roman
Gui, Add, Edit, w500 vDisplayCmdInfo,
Gui, Font, s10 bold, Times New Roman
Gui, Add, Text,, Description:
Gui, Font, norm, Times New Roman
Gui, Add, Edit, w500 r10 vDisplayDescriptionInfo,
Gui, Font, s10 bold, Times New Roman
Gui, Add, Text,, Notes and Remarks:
Gui, Font, norm, Times New Roman
Gui, Add, Edit, w500 r4 vDisplayNoteInfo,
Gui, Add, Button, Default Hidden gListBoxClick, Display
Gui, +AlwaysOnTop
Gui, Show, Autosize, Help - Command list
LoadCmdListFlag := 1
Return

IncrementalSearch:
   Gui Submit, NoHide
   len := StrLen(searchedString)
   itemNb := 1
   Loop Parse, HelpList, |
   {
      StringLeft part, A_LoopField, len
      If (part = searchedString)
      {
         itemNb := A_Index
         Break
      }
   }
   GuiControl Choose, SelCom, %itemNb%
Return

ListBoxClick:
   Gui Submit, NoHide
   gosub, SelectedCommand
Return


SelectedCommand:
If (SelCom = "Windows key + a")
		{
			GuiControl,, DisplayCmdInfo, Add unformatted text data to clipboard.
			GuiControl,, DisplayDescriptionInfo, This hotkey adds unformatted (which means text only, no bold/italic/underline/etc. formatting) text data to the clipboard. It combines the previous clipboards data (along with unformatting it if it isn't already) and separates the unformatted data with a space. The result is displayed with a tooltip.
			GuiControl,, DisplayNoteInfo, This data is UNFORMATTED. If you have something which is on your clipboard that is formatted or you are copying something which is formatted, it will be unformatted (simply text only) when combined.
		}
Else If (SelCom = "Windows key + b")
		{
			GuiControl,, DisplayCmdInfo, Clear formatted data from clipboard(s).
			GuiControl,, DisplayDescriptionInfo, When data is added as a formatted piece, multiple clipboards are pasted to ensure binary data is not combined, which causes errors. To clear all the previously added data use this command.
			GuiControl,, DisplayNoteInfo, Previously formatted data is pasted along with other data when using the formatted paste unless this command is used to clear it.
		}
Else If (SelCom = "Windows key + c")
		{
			GuiControl,, DisplayCmdInfo, Clears the current clipboard.
			GuiControl,, DisplayDescriptionInfo, This hotkey clears the data from the current clipboard.
			GuiControl,, DisplayNoteInfo, < None >
		}
Else If (SelCom = "Windows key + d")
		{
			GuiControl,, DisplayCmdInfo, Displays the current clipboard text in a tooltip.
			GuiControl,, DisplayDescriptionInfo, Without unformatting any data, all text on the current clipboard is shown in a tooltip.
			GuiControl,, DisplayNoteInfo, < None >
		}
Else If (SelCom = "Windows key + e")
		{
			GuiControl,, DisplayCmdInfo, Unassigned hotkey.
			GuiControl,, DisplayDescriptionInfo, Functionality may be added later. For now there is no function assigned to this hotkey.
			GuiControl,, DisplayNoteInfo, < None >
		}
Else If (SelCom = "Windows key + f")
		{
			GuiControl,, DisplayCmdInfo, Visit forum link.
			GuiControl,, DisplayDescriptionInfo, This hotkey visits the MasterBoard main forum link page.
			GuiControl,, DisplayNoteInfo, < None >
		}
Else If (SelCom = "Windows key + g")
		{
			GuiControl,, DisplayCmdInfo, Google clipboard content.
			GuiControl,, DisplayDescriptionInfo, This hotkey can quick search the content on your clipboard using Google.
			GuiControl,, DisplayNoteInfo, < None >
		}
Else If (SelCom = "Windows key + h")
		{
			GuiControl,, DisplayCmdInfo, Unassigned hotkey.
			GuiControl,, DisplayDescriptionInfo, Functionality may be added later. For now there is no function assigned to this hotkey.
			GuiControl,, DisplayNoteInfo, < None >
		}
Else If (SelCom = "Windows key + i")
		{
			GuiControl,, DisplayCmdInfo, Google image search clipboard content.
			GuiControl,, DisplayDescriptionInfo, This hotkey can quick search Google images for the content on your clipboard.
			GuiControl,, DisplayNoteInfo, < None >
		}
Else If (SelCom = "Windows key + j")
		{
			GuiControl,, DisplayCmdInfo, Dictionary search clipboard content.
			GuiControl,, DisplayDescriptionInfo,  This hotkey quick searches dictionary lookup for your clipboard content.
			GuiControl,, DisplayNoteInfo, < None >
		}
Else If (SelCom = "Windows key + k")
		{
			GuiControl,, DisplayCmdInfo, Unassigned hotkey.
			GuiControl,, DisplayDescriptionInfo, Functionality may be added later. For now there is no function assigned to this hotkey.
			GuiControl,, DisplayNoteInfo, < None >
		}
Else If (SelCom = "Windows key + l")
		{
			GuiControl,, DisplayCmdInfo, Convert clipboard to lowercase.
			GuiControl,, DisplayDescriptionInfo, Converts your current clipboard content to all lowercase.
			GuiControl,, DisplayNoteInfo, < None >
		}
Else If (SelCom = "Windows key + m")
		{
			GuiControl,, DisplayCmdInfo, IMDb search clipboard content.
			GuiControl,, DisplayDescriptionInfo, This hotkey can quickly search IMDb for your clipboard content.
			GuiControl,, DisplayNoteInfo, < None >
		}
Else If (SelCom = "Windows key + n")
		{
			GuiControl,, DisplayCmdInfo, Hotkey control preferences.
			GuiControl,, DisplayDescriptionInfo, This will bring up a prompt to allow the user to disable or enable keys.
			GuiControl,, DisplayNoteInfo, < None >
		}
Else If (SelCom = "Windows key + o")
		{
			GuiControl,, DisplayCmdInfo, Organize clipboard data.
			GuiControl,, DisplayDescriptionInfo, Sorts clipboard data. By default the sort is done by using new lines as separate pieces of data (separations are referred to as delimiters). When you choose to sort data, a tooltip comes up to prompt you how you wish to organize the data. If the options are not satisfactory to your needs, you can enter custom options by selecting advanced options and reading the about the options parameter from AutoHotkey. Any data input into the advanced options should be compliant with AutoHotkey sort options.
			GuiControl,, DisplayNoteInfo, If you input a bad option, the command may look like it executed correctly when it really didn't. Also if the clipboard contains a file, the file name will be used rather than the file itself and replaced on your clipboard.
		}
Else If (SelCom = "Windows key + p")
		{
			GuiControl,, DisplayCmdInfo, Unassigned hotkey.
			GuiControl,, DisplayDescriptionInfo, Functionality may be added later. For now there is no function assigned to this hotkey.
			GuiControl,, DisplayNoteInfo, < None >
		}
Else If (SelCom = "Windows key + q")
		{
			GuiControl,, DisplayCmdInfo, Unassigned hotkey.
			GuiControl,, DisplayDescriptionInfo, Functionality may be added later. For now there is no function assigned to this hotkey.
			GuiControl,, DisplayNoteInfo, < None >
		}
Else If (SelCom = "Windows key + r")
		{
			GuiControl,, DisplayCmdInfo, Restore previously saved clipboards.
			GuiControl,, DisplayDescriptionInfo, Clipboards are saved on program exit. To restore previous clipboard data, use this hotkey.
			GuiControl,, DisplayNoteInfo, If a clipboard is empty when the clipboards are saved`, all clipboards after that point are no longer saved.
		}
Else If (SelCom = "Windows key + s")
		{
			GuiControl,, DisplayCmdInfo, Suspend all keys.
			GuiControl,, DisplayDescriptionInfo, All hotkeys are suspended, allowing you to use them again until unsuspended.
			GuiControl,, DisplayNoteInfo,  Windows key + S (suspend) and Windows key + F (forum visiting) are NOT suspended with the other keys and will remain active upon suspension.
		}
Else If (SelCom = "Windows key + t")
		{
			GuiControl,, DisplayCmdInfo, Convert clipboard to text data.
			GuiControl,, DisplayDescriptionInfo, This hotkey converts all clipboard data to unformatted text data.
			GuiControl,, DisplayNoteInfo, < None >
		}
Else If (SelCom = "Windows key + u")
		{
			GuiControl,, DisplayCmdInfo, Convert clipboard to uppercase.
			GuiControl,, DisplayDescriptionInfo, Converts the clipboard text to all uppercase.
			GuiControl,, DisplayNoteInfo, < None >
		}
Else If (SelCom = "Windows key + v")
		{
			GuiControl,, DisplayCmdInfo, Paste formatted clipboard data.
			GuiControl,, DisplayDescriptionInfo, When you need clipboard data to remain formatted and you wish to add it to the clipboard, each piece is added separately and pasted separately. This command is necessary because the formatted data is pasted one at a time, one after another. The clipboard can only contain one piece at a time to eliminate the issue of binary data error.
			GuiControl,, DisplayNoteInfo, < None >
		}
Else If (SelCom = "Windows key + w")
		{
			GuiControl,, DisplayCmdInfo, Wikipedia search clipboard content.
			GuiControl,, DisplayDescriptionInfo, Searches Wikipedia for the data contained within your clipboard.
			GuiControl,, DisplayNoteInfo, < None >
		}
Else If (SelCom = "Windows key + x")
		{
			GuiControl,, DisplayCmdInfo, Add formatted data to clipboard.
			GuiControl,, DisplayDescriptionInfo, Adds each piece to a new variable which is to be pasted one at a time. This is necessary because clipboard binary data causes errors when pieced together. To avoid this, each addition is placed in its own section and then pasted one after another. This key generates another section to paste.
			GuiControl,, DisplayNoteInfo, Use like Ctrl + C when you wish to add formatted data.
		}
Else If (SelCom = "Windows key + y")
		{
			GuiControl,, DisplayCmdInfo, YouTube search clipboard data.
			GuiControl,, DisplayDescriptionInfo, This hotkey quickly searches YouTube for the data contained on your clipboard.
			GuiControl,, DisplayNoteInfo, < None >
		}
Else If (SelCom = "Windows key + z")
		{
			GuiControl,, DisplayCmdInfo, Revert to last clipboard.
			GuiControl,, DisplayDescriptionInfo, When you accidentally copy data which you did not mean to or want to revert back to the previously contained clipboard data, this hotkey allows you to do so.
			GuiControl,, DisplayNoteInfo, Similar to a Ctrl + Z (undo) hotkey.
		}
Else If (SelCom = "Windows key + 0")
		{
			GuiControl,, DisplayCmdInfo, Quick switch to clipboard number 10.
			GuiControl,, DisplayDescriptionInfo, This hotkey will switch to the designated clipboard (specifically, clipboard number 10).
			GuiControl,, DisplayNoteInfo, < None >
		}
Else If (SelCom = "Windows key + 1")
		{
			GuiControl,, DisplayCmdInfo, Quick switch to clipboard number 1.
			GuiControl,, DisplayDescriptionInfo, This hotkey will switch to the designated clipboard (specifically, clipboard number 1).
			GuiControl,, DisplayNoteInfo, < None >
		}
Else If (SelCom = "Windows key + 2")
		{
			GuiControl,, DisplayCmdInfo, Quick switch to clipboard number 2.
			GuiControl,, DisplayDescriptionInfo, This hotkey will switch to the designated clipboard (specifically, clipboard number 2).
			GuiControl,, DisplayNoteInfo, < None >
		}
Else If (SelCom = "Windows key + 3")
		{
			GuiControl,, DisplayCmdInfo, Quick switch to clipboard number 3.
			GuiControl,, DisplayDescriptionInfo, This hotkey will switch to the designated clipboard (specifically, clipboard number 3).
			GuiControl,, DisplayNoteInfo, < None >
		}
Else If (SelCom = "Windows key + 4")
		{
			GuiControl,, DisplayCmdInfo, Quick switch to clipboard number 4.
			GuiControl,, DisplayDescriptionInfo, This hotkey will switch to the designated clipboard (specifically, clipboard number 4).
			GuiControl,, DisplayNoteInfo, < None >
		}
Else If (SelCom = "Windows key + 5")
		{
			GuiControl,, DisplayCmdInfo, Quick switch to clipboard number 5.
			GuiControl,, DisplayDescriptionInfo, This hotkey will switch to the designated clipboard (specifically, clipboard number 5).
			GuiControl,, DisplayNoteInfo, < None >
		}
Else If (SelCom = "Windows key + 6")
		{
			GuiControl,, DisplayCmdInfo, Quick switch to clipboard number 6.
			GuiControl,, DisplayDescriptionInfo, This hotkey will switch to the designated clipboard (specifically, clipboard number 6).
			GuiControl,, DisplayNoteInfo, < None >
		}
Else If (SelCom = "Windows key + 7")
		{
			GuiControl,, DisplayCmdInfo, Quick switch to clipboard number 7.
			GuiControl,, DisplayDescriptionInfo, This hotkey will switch to the designated clipboard (specifically, clipboard number 7).
			GuiControl,, DisplayNoteInfo, < None >
		}
Else If (SelCom = "Windows key + 8")
		{
			GuiControl,, DisplayCmdInfo, Quick switch to clipboard number 8.
			GuiControl,, DisplayDescriptionInfo, This hotkey will switch to the designated clipboard (specifically, clipboard number 8).
			GuiControl,, DisplayNoteInfo, < None >
		}
Else If (SelCom = "Windows key + 9")
		{
			GuiControl,, DisplayCmdInfo, Quick switch to clipboard number 9.
			GuiControl,, DisplayDescriptionInfo, This hotkey will switch to the designated clipboard (specifically, clipboard number 9).
			GuiControl,, DisplayNoteInfo, < None >
		}
Else If (SelCom = "Windows key + [+ key]")
		{
			GuiControl,, DisplayCmdInfo, Switch to next clipboard.
			GuiControl,, DisplayDescriptionInfo, This hotkey saves the current clipboard data and switches to the next clipboard number if possible.
			GuiControl,, DisplayNoteInfo, < None >
		}
Else If (SelCom = "Windows key + [- key]")
		{
			GuiControl,, DisplayCmdInfo, Switch to previous clipboard.
			GuiControl,, DisplayDescriptionInfo, This hotkey saves the current clipboard data and switches to the previous clipboard number if possible.
			GuiControl,, DisplayNoteInfo, < None >
		}
Else If (SelCom = "Windows key + [Delete key]")
		{
			GuiControl,, DisplayCmdInfo, Clear all clipboards
			GuiControl,, DisplayDescriptionInfo, Clears ALL clipboards and the data on them, including the currently used clipboard.
			GuiControl,, DisplayNoteInfo, < None >
		}
Else If (SelCom = "Esc key")
		{
			GuiControl,, DisplayCmdInfo, Exit a screencap or the MasterBoard program.
			GuiControl,, DisplayDescriptionInfo, This is a dual purpose key. When a screencap is in progress, hit this key to exit it. Alternatively, this key can exit MasterBoard all together by holding it.
			GuiControl,, DisplayNoteInfo, < None >
		}
Else If (SelCom = "Windows key + [PrtSc key]")
		{
			GuiControl,, DisplayCmdInfo, Screenshot a portion of the screen to the clipboard.
			GuiControl,, DisplayDescriptionInfo, This command allows you to select an area of the screen which can be stored on your clipboard. Hit the hotkey and then drag your left mouse to select the piece of the screen which will be captured. Once captured the portion of the screen will be directly sent to your clipboard.
			GuiControl,, DisplayNoteInfo, If you do not wish to take a screenshot, the command can be exited via the ESC key.
		}
Else If (SelCom = "Number of supported clipboards")
		{
			GuiControl,, DisplayCmdInfo, Changable number of supported clipboards.
			GuiControl,, DisplayDescriptionInfo, This is only available within the MasterBoard Control Panel. It allows you to edit the number of supported clipboards you can use.
			GuiControl,, DisplayNoteInfo, < None >
		}
else ; If a command is not documented
{
	GuiControl,, DisplayCmdInfo, <No command>
	GuiControl,, DisplayDescriptionInfo, <A command for this hotkey has not yet been implemented>
	GuiControl,, DisplayNoteInfo, <No notes/remarks are available for this command>
}
return

4GuiClose:
HelpList := ""
Gui, 4: Destroy
LoadCmdListFlag := 0
return


; ###################### rseding91's updater function ####################################################
Check_ForUpdate(_ReplaceCurrentScript = 0, _SuppressMsgBox = 0, _CallbackFunction = "", ByRef _Information = "")
{
	;Version.ini file format
	;
	;[Info]
	;Version=1.4
	;URL=http://www.mywebsite.com/my%20file.ahk or .exe
	;MD5=00000000000000000000000000000000 or omit this key completly to skip the MD5 file validation
	
	Static Script_Name := "MasterBoard" ;Your script name
	, Version_Number := 1.3 ;The script's version number
	, Update_URL := "http://www.autohotkey.net/~jpjazzy/MasterBoard/Version.ini" ;The URL of the version.ini file for your script
	, Retry_Count := 3 ;Retry count for if/when anything goes wrong
	
	Random,Filler,10000000,99999999
	Version_File := A_Temp . "\" . Filler . ".ini"
	, Temp_FileName := A_Temp . "\" . Filler . ".tmp"
	, VBS_FileName := A_Temp . "\" . Filler . ".vbs"
	
	Loop,% Retry_Count
	{
		_Information := ""
		
		UrlDownloadToFile,%Update_URL%,%Version_File%
		
		IniRead,Version,%Version_File%,Info,Version,N/A
		
		If (Version = "N/A"){
			FileDelete,%Version_File%
			
			If (A_Index = Retry_Count)
				_Information .= "The version info file doesn't have a ""Version"" key in the ""Info"" section or the file can't be downloaded."
			Else
				Sleep,500
			
			Continue
		}
		
		If (Version > Version_Number){
			If (_SuppressMsgBox != 1 and _SuppressMsgBox != 3){
				MsgBox,0x4,New version available,There is a new version of %Script_Name% available.`nCurrent version: %Version_Number%`nNew version: %Version%`n`nWould you like to download it now?
				
				IfMsgBox,Yes
					MsgBox_Result := 1
			}
			
			If (_SuppressMsgBox or MsgBox_Result){
				IniRead,URL,%Version_File%,Info,URL,N/A
				
				If (URL = "N/A")
					_Information .= "The version info file doesn't have a valid URL key."
				Else {
					SplitPath,URL,,,Extension
					
					If (Extension = "ahk" And A_AHKPath = "")
						_Information .= "The new version of the script is an .ahk filetype and you do not have AutoHotKey installed on this computer.`r`nReplacing the current script is not supported."
					Else If (Extension != "exe" And Extension != "ahk")
						_Information .= "The new file to download is not an .EXE or an .AHK file type. Replacing the current script is not supported."
					Else {
						IniRead,MD5,%Version_File%,Info,MD5,N/A
						
						Loop,% Retry_Count
						{
							UrlDownloadToFile,%URL%,%Temp_FileName%
							
							IfExist,%Temp_FileName%
							{
								If (MD5 = "N/A"){
									_Information .= "The version info file doesn't have a valid MD5 key."
									, Success := True
									Break
								} Else {
									H := DllCall("CreateFile","Str",Temp_FileName,"UInt",0x80000000,"UInt",3,"UInt",0,"UInt",3,"UInt",0,"UInt",0)
									, VarSetCapacity(FileSize,8,0)
									, DllCall("GetFileSizeEx","UInt",H,"Int64",&FileSize)
									, FileSize := NumGet(FileSize,0,"Int64")
									, FileSize := FileSize = -1 ? 0 : FileSize
									
									If (FileSize != 0){
										VarSetCapacity(Data,FileSize,0)
										, DllCall("ReadFile","UInt",H,"UInt",&Data,"UInt",FileSize,"UInt",0,"UInt",0)
										, DllCall("CloseHandle","UInt",H)
										, VarSetCapacity(MD5_CTX,104,0)
										, DllCall("advapi32\MD5Init",Str,MD5_CTX)
										, DllCall("advapi32\MD5Update",Str,MD5_CTX,"UInt",&Data,"UInt",FileSize)
										, DllCall("advapi32\MD5Final",Str,MD5_CTX)
										
										FileMD5 := ""
										Loop % StrLen(Hex:="123456789ABCDEF0")
											N := NumGet(MD5_CTX,87+A_Index,"Char"), FileMD5 .= SubStr(Hex,N>>4,1) . SubStr(Hex,N&15,1)
										
										VarSetCapacity(Data,FileSize,0)
										, VarSetCapacity(Data,0)
										
										If (FileMD5 != MD5){
											FileDelete,%Temp_FileName%
											
											If (A_Index = Retry_Count)
												_Information .= "The MD5 hash of the downloaded file does not match the MD5 hash in the version info file."
											Else										
												Sleep,500
											
											Continue
										} Else
											Success := True
									} Else {
										DllCall("CloseHandle","UInt",H)
										Success := True
									}
								}
							} Else {
								If (A_Index = Retry_Count)
									_Information .= "Unable to download the latest version of the file from " %URL% "."
								Else
									Sleep,500
								Continue
							}
						}
					}
				}
			}
		} Else
			_Information .= "No update was found."
		
		FileDelete,%Version_File%
		Break
	}
	
	If (_ReplaceCurrentScript And Success){
		SplitPath,URL,,,Extension
		Process,Exist
		MyPID := ErrorLevel
		
		VBS_P1 =
		(LTrim Join`r`n
			On Error Resume Next
			Set objShell = CreateObject("WScript.Shell")
			objShell.Run "TaskKill -f -im %MyPID%", WindowStyle, WaitOnReturn
			WScript.Sleep 1000
			Set objFSO = CreateObject("Scripting.FileSystemObject")
		)
		
		If (A_IsCompiled){
			If (Extension = "exe"){
				VBS_P2 =
				(LTrim Join`r`n
					objFSO.CopyFile "%Temp_FileName%", "%A_ScriptFullPath%", True
					objFSO.DeleteFile "%Temp_FileName%", True
					objShell.Run """%A_ScriptFullPath%"""
				)
				
				Return_Val :=  Temp_FileName
			} Else { ;Extension is ahk
				SplitPath,A_ScriptFullPath,,FDirectory,,FName
				FileMove,%Temp_FileName%,%FDirectory%\%FName%.ahk,1
				FileDelete,%Temp_FileName%
				
				VBS_P2 =
				(LTrim Join`r`n
					objFSO.DeleteFile "%A_ScriptFullPath%", True
					objShell.Run """%FDirectory%\%FName%.ahk"""
				)
				
				Return_Val := FDirectory . "\" . FName . ".ahk"
			}
		} Else {
			If (Extension = "ahk"){
				FileMove,%Temp_FileName%,%A_ScriptFullPath%,1
				If (Errorlevel)
					_Information .= "Error (" Errorlevel ") unable to replace current script with the latest version."
				Else {
					VBS_P2 = 
					(LTrim Join`r`n
						objShell.Run """%A_ScriptFullPath%"""
					)
					
					Return_Val :=  A_ScriptFullPath
				}
			} Else If (Extension = "exe"){
				SplitPath,A_ScriptFullPath,,FDirectory,,FName
				FileMove,%Temp_FileName%,%FDirectory%\%FName%.exe,1
				FileDelete,%A_ScriptFullPath%
				
				VBS_P2 =
				(LTrim Join`r`n
					objShell.Run """%FDirectory%\%FName%.exe"""
				)
				
				Return_Val :=  FDirectory . "\" . FName . ".exe"
			} Else {
				FileDelete,%Temp_FileName%
				_Information .= "The downloaded file is not an .EXE or an .AHK file type. Replacing the current script is not supported."
			}
		}
		
		VBS_P3 =
		(LTrim Join`r`n
			objFSO.DeleteFile "%VBS_FileName%", True
			Set objFSO = Nothing
			Set objShell = Nothing
		)
		
		If (_SuppressMsgBox < 2)
			VBS_P3 .= "`r`nWScript.Echo ""Update complected successfully."""
		
		FileDelete,%VBS_FileName%
		FileAppend,%VBS_P1%`r`n%VBS_P2%`r`n%VBS_P3%,%VBS_FileName%
		
		If (_CallbackFunction != ""){
			If (IsFunc(_CallbackFunction))
				%_CallbackFunction%()
			Else
				_Information .= "The callback function is not a valid function name."
		}
		
		RunWait,%VBS_FileName%,%A_Temp%,VBS_PID
		Sleep,2000
		
		Process,Close,%VBS_PID%
		_Information := "Error (?) unable to replace current script with the latest version.`r`nPlease make sure your computer supports running .vbs scripts and that the script isn't running in a pipe."
	}
	
	_Information := _Information = "" ? "None" : _Information
	
	Return Return_Val
}