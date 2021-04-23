/*     ActiveGoTo4SciTE
__________________________________________
_____Active GoTo    - Rajat_______________
__________________________________________

v4 Changes:
- List Auto-Updates if there is a change in the sections (or their positions) in the script.
- The auto-update changes the order of the list ONLY if there is a change in the sections in the script,
  and not if the change is only in their positions
- Support for hotstrings added 
- Support for same line comments on section line added/improved
- If there are no sections in a file (eg. a new script), the ActiveGoTo window doesn't pop up.
- The hotkey Win+Tab toggles the gui hide/show. (Thanks toralf)
- The GUI only shows up when its hotkey is pressed, and not automatically (Thanks toralf)
- All Hotkeys context sensitive (Thanks toralf)
- The refresh hotkey (F5) is gone
- Removed support for .au3 scripts (Don't even know why I added that in the first place!)


v3 Changes:
- Auto update of list based on the currently open file in editor.
- Pressing F5 will refresh the list
- Check if the file open in editor is a script or not 

v2 Changes:
- The ActiveGoto GUI gets hidden when neither it or Editor window are active (Thanks MsgBox)
- Support for OTB added (Thanks toralf)
- The alphabetical sort of function list is now optional (Thanks toralf)
- Hotkeys are now easily configurable (Thanks toralf)
- Some code optimizations
__________________________________________

To Customize for any other Editor besides
PSPad, change title settings and keys
for 'go to' function of your editor in this script.

Write here the text shown on the left & 
right of the filename in the window's title.

Don't write the * if its shown when a file
is changed in the editor.

(Default) Keyboard Help:

Win + Tab	: Show Active Goto Window
Win + Left	: Goto last browsed control
Esc			: Hide Active Goto Window

*/

TitleStart := ".ahk" ;PSPad - [
TitleEnd := "SciTE" ;]

;Go To Settings (Name of GoTo window and Editor's related key)
GotoWin = ahk_class #32770  ;TfGotoLine
GotoKey = ^g

;Sort Section List Alphabetically? (1 = Yes)
ASort = 0

;Hotkeys for showing GUI and going to last section
HK_ShowGUI = #Tab
HK_LastSection = #Left

;checks if the currently open file in the editor is a .ahk file
ScriptCheck = Y 

;___________________________________________
SetTitleMatchMode,2
#SingleInstance Force
SetBatchLines, -1

MainWnd = Active GoTo

IfWinNotExist, %TitleStart%
{
	CoordMode, ToolTip, Screen
	TrayTip,, Editor window doesn't exist!
	Sleep, 2000
	ExitApp
}

WinGetTitle, WinTitle, %TitleStart% 
WinGet, EWID, ID, %WinTitle% 

GroupAdd, HtkGrp, ahk_id %EWID% 
Hotkey, IfWinActive, ahk_group HtkGrp 
Hotkey, %HK_ShowGUI%, ShowGUI 
Hotkey, %HK_LastSection%, LastSection 
Hotkey, IfWinActive 


;check for editor window
SetTimer, EWCheck, 500


Return



EWCheck:
	IfNotEqual, EWID,
	IfWinNotExist, ahk_id %EWID%
		ExitApp

	;wait for ctrl key to be up again while changing tabs
	GetKeyState, Ctrl, Ctrl
	IfEqual, Ctrl, D
		Return

	IfWinNotActive ahk_id %MWID% 
;	IfWinNotActive ahk_id %EWID% 
		DllCall( "AnimateWindow", "Int", MWID, "Int", 200, "Int", 0x00050002 ) 

	;______Extracting Filename
	StartLen=1 ;StringLen, StartLen, TitleStart
	;StringLen, EndLen, TitleEnd
	
	WinGetTitle, WinTitle, %TitleStart%
	WinGet, EWID, ID, %WinTitle%
	
	;StringTrimLeft, FileName, WinTitle, %StartLen%
	StringTrimRight, FileName, WinTitle, 8 ;FileName, %EndLen%
	
	;StringRight, Test, FileName, 1
	;IfEqual, Test, *, StringTrimRight, FileName, FileName, 1
	FileName = %FileName%

	IfNotInString, FileName, .ahk
		Return

	IfNotEqual, FileName, %LastFileName%
	{
		Gosub, GenerateBM
		LastFileName = %FileName%
	}
Return	



GenerateBM:
	;_______Reading file and creating bookmarks

	FileRead, FileData, %FileName%
	SplitPath, FileName,,, FileType
	
	List =
	PosList =
	Count =
	Loop, Parse, FileData, `n, `r
	{
		SectionLine =
		CurrLine = %A_LoopField%
		CurrLine = %CurrLine%
		CurrLineN = %A_Index%
	
		IfEqual, FileType, ahk
		{
			;commented line
			StringLeft, Check, CurrLine, 1
			IfEqual, Check, `;, Continue
			
			;removing same line comment
			StringGetPos, Check, CurrLine, `;
			Error = %ErrorLevel%
			StringLeft, Check, CurrLine, %Check%
			StringRight, Check2, Check, 1
			IfNotEqual, Check2, ``
			IfNotEqual, Error, 1
			{
				Check = %Check%
				CurrLine = %Check%
			}
			

			;function line
			IfInString, CurrLine, `(
			IfInString, CurrLine, `)
			{
				;non OTB function
				IfNotInString, CurrLine, `{
				{
					FileReadLine, CheckF, %FileName%, % A_Index + 1
					CheckF = %CheckF%
					IfNotEqual, CheckF, `{
						Continue
				}
				
				;OTB function
				IfInString, CurrLine, `{
				{
					StringRight, CheckF, CurrLine, 1
					IfNotEqual, CheckF, `{	
						Continue
				}
		
				StringGetPos, CPos, CurrLine, `(
				StringLeft, CurrLine, CurrLine, %CPos%
				CurrLine = %CurrLine%`(`)
				SectionLine = Y
			}
		
			;hotkey/hotstring line
			IfInString, CurrLine, `:`:
			{
				StringGetPos, CPos, CurrLine, `:`:
				
				;hotstring line
				IfEqual, CPos, 0
				{
					StringTrimLeft, CurrLine, CurrLine, 2
					StringGetPos, CPos, CurrLine, `:`:
					StringLeft, CurrLine, CurrLine, %CPos%
					CurrLine = `:`:%CurrLine%`:`:
				}
				;hotkey line
				Else
				{
					CPos += 2
					StringLeft, CurrLine, CurrLine, %CPos%
				}
				SectionLine = Y
			}
		
			IfNotInString, CurrLine, `:`:
			{
				IfInString, CurrLine, `,, Continue
				IfInString, CurrLine, %A_Space%, Continue
				IfInString, CurrLine, %A_Tab%, Continue
			}
		
			StringRight, Check2, CurrLine, 1
			StringRight, Check3, CurrLine, 2
			StringLeft, Check3, Check3, 1
			
			IfEqual, Check2, `:
			IfNotEqual, Check3, ``
				SectionLine = Y
		}
		
	
		IfEqual, SectionLine, Y
		{
			Count ++
			Text%Count% = %CurrLine%
			Pos%Count% = %CurrLineN%
			List = %List%|%CurrLine%
			PosList = %PosList%|%CurrLineN%
		}
	}
	
	StringTrimLeft, List, List, 1
	IfEqual, ASort, 1
		Sort, List, D|

	;update list only if there is a change in sections, and not if the change is
	;only in the position of the sections
	CheckList1 = %List%
	CheckList2 = %LastList%
	
	Sort, CheckList1, D|
	Sort, CheckList2, D|
Return




GuiClose:
	ExitApp





ShowGUI:
	SetTimer, EWCheck, Off

	DetectHiddenWindows, Off
 
	IfWinActive, ahk_id %MWID%
	{
		Gosub, GuiEscape 
		SetTimer, EWCheck, On
		Return
	}
	DetectHiddenWindows, On 

	Gosub, GenerateBM

	;generate controls only once
	IfNotEqual, GuiMade, Y
	{
		Gui, +AlwaysOnTop -Caption +Border +ToolWindow
		Gui, Add, Edit, x6 y6 w200 h20 vSearch gSearch AltSubmit,
		Gui, Add, ListBox, x6 y30 w200 h440 vSelItem gMSelect,
		Gui, Add, Button, x-10 y-10 w1 h1 gSelect Default,
	}


	;only update list if the sections have changed
	IfNotEqual, CheckList1, %CheckList2%
	{
		GuiControl,, SelItem, |
		GuiControl,, SelItem, %List%

		GUIList = %List%
		LastList = %List%
		LastPosList = %PosList%
	}


	;only add ID to group once
	IfNotEqual, GuiMade, Y
	{
		Gui, Show, x0 y44 h471 w212 Hide, %MainWnd%
		WinGet, MWID, ID, %MainWnd%
		GroupAdd, MWGrp, ahk_id %MWID%
		GroupAdd, HtkGrp, ahk_id %MWID% 

		GuiMade = Y
	}

	;no gui for empty list
	IfNotEqual, List,
	{
		DllCall( "AnimateWindow", "Int", MWID, "Int", 200, "Int", 0x00040001 ) 
		WinActivate, ahk_id %MWID%
	} 

	SetTimer, EWCheck, On 
Return


GuiEscape:
	WinActivate, ahk_id %EWID%
	DllCall( "AnimateWindow", "Int", MWID, "Int", 200, "Int", 0x00050002 )
Return


MSelect:
	IfNotEqual, A_GuiControlEvent, DoubleClick, Return

Select:
	;selects the search text
	ControlGetFocus, ACtrl, ahk_id %MWID%
	IfEqual, ACtrl, Edit1
		Send, +{Home}

	Gui, Submit, NoHide
	
	Loop, %Count%
	{
		IfEqual, Text%A_Index%, %SelItem%
		{
			LastLine = %GotoLine%

			GotoLine := Pos%A_Index%
			WinActivate, ahk_id %EWID%
			WinWaitActive, ahk_id %EWID%
			Send, %GotoKey%
			WinWaitActive, %GotoWin%
			Send, %GotoLine%{Enter}
			
			IfEqual, LastLine,
				LastLine = %GotoLine%

			;moving selected item to top
			TmpList = |%GUIList%|
			StringReplace, TmpList, TmpList, |%SelItem%|, |, A
			StringTrimLeft, TmpList, TmpList, 1
			StringTrimRight, TmpList, TmpList, 1
			GUIList = %SelItem%|%TmpList%
			GuiControl,, SelItem, ||
			GuiControl,, SelItem, |%GUIList%
			GuiControl, ChooseString, SelItem, %SelItem%
			
			Break
		}
	}
	DllCall( "AnimateWindow", "Int", MWID, "Int", 200, "Int", 0x00050002 )
Return



Search:
	Gui, Submit, NoHide
	Loop, Parse, List, | 
	{ 
		IfInString, A_LoopField, %Search% 
		{ 
			GuiControl, Choose, SelItem, %A_Index% 
			Break 
		} 
	}
Return



LastSection:
	IfEqual, LastLine,, Return

	Gosub, GenerateBM

	WinActivate, ahk_id %EWID%
	WinWaitActive, ahk_id %EWID%
	Send, %GotoKey%
	WinWaitActive, %GotoWin%
	Send, %LastLine%{Enter}
	Swp = %LastLine%
	LastLine = %GotoLine%
	GotoLine = %Swp%
Return


#IfWinActive, ahk_group MWGrp 
Up::  ControlSend, ListBox1, {Up}, %MainWnd% 
Down::  ControlSend, ListBox1, {Down}, %MainWnd% 
PgUp::  ControlSend, ListBox1, {PgUp}, %MainWnd% 
PgDn::  ControlSend, ListBox1, {PgDn}, %MainWnd% 
WheelUp::  ControlSend, ListBox1, {Up}, %MainWnd% 
WheelDown::  ControlSend, ListBox1, {Down}, %MainWnd% 
MButton:: GoSub, Select 
^BackSpace:: Send,^+{Left}{Del} 
^Esc:: ExitApp
#IfWinActive