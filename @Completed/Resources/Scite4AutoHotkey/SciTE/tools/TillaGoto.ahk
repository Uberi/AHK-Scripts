/*! TheGood    
	TillaGoto - Go to functions and labels in your script
	Last updated: December 30, 2010
	
	Usage, changelog and help can be found in the thread:
	http://www.autohotkey.com/forum/viewtopic.php?t=41575
*/

/*! SciTE4AutoHotkey version - Many, MANY changes in order to make it well-behaved
*/

; Get SciTE object
oSciTE := GetSciTEInstance()
if !oSciTE
{
	MsgBox, 16, TillaGoto, Cannot find SciTE!
	ExitApp
}

; Get SciTE window handle
oSciTE_hwnd := oSciTE.SciTEHandle

; Read TillaGoto settings using SciTE's property system
bTrayIcon        := oSciTE.ResolveProp("tillagoto.show.tray.icon") + 0
iGUIWidth        := oSciTE.ResolveProp("tillagoto.gui.width") + 0
iGUIHeight       := oSciTE.ResolveProp("tillagoto.gui.height") + 0
iMargin          := oSciTE.ResolveProp("tillagoto.gui.margin") + 0
iTransparency    := oSciTE.ResolveProp("tillagoto.gui.transparency") + 0
bPosLeft         := oSciTE.ResolveProp("tillagoto.gui.posleft") + 0
bWideView        := oSciTE.ResolveProp("tillagoto.gui.wide.view") + 0
iAlignFilenames  := oSciTE.ResolveProp("tillagoto.gui.align.filenames") + 0
cGUIBG           := oSciTE.ResolveProp("tillagoto.gui.bgcolor")
cControlBG       := oSciTE.ResolveProp("tillagoto.gui.controlbgcolor")
cControlFG       := oSciTE.ResolveProp("tillagoto.gui.controlfgcolor")
iControlFontSize := oSciTE.ResolveProp("tillagoto.gui.font.size") + 0
fControlFont     := oSciTE.ResolveProp("tillagoto.gui.font")
bSortEntries     := oSciTE.ResolveProp("tillagoto.gui.sort.entries") + 0
uSummonGUI       := oSciTE.ResolveProp("tillagoto.hk.summon.gui")
uGoBack          := oSciTE.ResolveProp("tillagoto.hk.go.back")
uGoForward       := oSciTE.ResolveProp("tillagoto.hk.go.forward")
uGotoDef         := oSciTE.ResolveProp("tillagoto.hk.goto.def")
bFilterComments  := oSciTE.ResolveProp("tillagoto.filter.comments") + 0
bQuickMode       := oSciTE.ResolveProp("tillagoto.quick.mode") + 0
bQuitWithEditor  := oSciTE.ResolveProp("tillagoto.quit.with.editor") + 0
bMatchEverywhere := oSciTE.ResolveProp("tillagoto.match.everywhere") + 0
bUseMButton      := oSciTE.ResolveProp("tillagoto.use.mbutton") + 0
iCancelWait      := oSciTE.ResolveProp("tillagoto.cancel.timeout") + 0
iIncludeMode     := oSciTE.ResolveProp("tillagoto.include.mode") + 0
bCacheFiles      := oSciTE.ResolveProp("tillagoto.cache.files") + 0
bDirectives      := oSciTE.ResolveProp("tillagoto.directives") + 0

_AhkScriptIsActive()
{
	global oSciTE
	return _SciTEIsActive() ;&& oSciTE.ResolveProp("Language") = "ahk1" ; Alternate test: FileExt = "ahk"
}

_GetSciTEHandle()
{
	global oSciTE_hwnd
	return oSciTE_hwnd
}

_GetSciTEFile()
{
	global oSciTE
	return oSciTE.CurrentFile
}

_SciTEIsActive()
{
	global oSciTE
	return WinActive("ahk_id " _GetSciTEHandle())
}

; Necessary for the conditional hotkey/hotstring expression to be registered
#if _AhkScriptIsActive()

	;Keep backup values
	bFilterCommentsOrig := bFilterComments
	iIncludeModeOrig := iIncludeMode
	
	#NoEnv
	#NoTrayIcon
	#SingleInstance Ignore
	SetTitleMatchMode, RegEx
	DetectHiddenWindows, On
	Menu, Tray, NoStandard
	Menu, Tray, Icon, %A_ScriptDir%\..\toolicon.icl, 16
	Menu, Tray, Tip, TillaGoto for SciTE4AutoHotkey
	Menu, Tray, Add, Close, TrayClose
	
	;Show tray icon if necessary
	If bTrayIcon
		Menu, Tray, Icon
	
	;Get scrollbar width and height
	SysGet, SM_CXVSCROLL, 2
	SysGet, SM_CYHSCROLL, 3
	
	;Check if we'll be using the caching feature
	If bCacheFiles {
		GetFileCRC32() ;Initialize GetFileCRC32
		OnExit, DeleteCache ;Register sub to delete cache upon exiting the script
	}
	
	;Create GUI
	Gui, +AlwaysOnTop +Border +ToolWindow +LastFound -Caption
	Gui, Font, s%iControlFontSize% c%cControlFG%, %fControlFont%
	Gui, Color, %cGUIBG%, %cControlBG%
	Gui, Margin, %iMargin%, %iMargin%
	Gui, Add, Edit, h20 w%iGUIWidth% vtxtSearch gtxtSearch_Event hwndhtxtsearch
	sortOpt := bSortEntries ? "Sort" : ""
	Gui, Add, ListBox, %sortOpt% wp vlblList glblList_Event hwndhlblList +HScroll +256 ;LBS_NOINTEGRALHEIGHT
	hGui := WinExist()
	
	;Get the height of a listbox item
	SendMessage, 417,,,, ahk_id %hlblList% ;LB_GETITEMHEIGHT
	iGUIItemHeight := ErrorLevel
	
	;Catch WM_INPUT, WM_KEYDOWN and WM_MOUSEWHEEL
	OnMessage(255, "GUIInteract")
	OnMessage(256, "GUIInteract")
	OnMessage(522, "GUIInteract")
	
	;Register the mouse with RIDEV_INPUTSINK
	If HID_Register(1, 2, hGui, 0x00000100)
		MsgBox, 0x1010, HID_Register failed!, ErrorLevel = %ErrorLevel%`nMouse features will not properly work.
	
	;Register summon hotkey before Quick Mode
	Hotkey, IfWinActive, ahk_id %hGui%
	Hotkey, %uSummonGUI%, SummonGUI
	
	;Check if we're in quick mode
	If bQuickMode
		Goto SummonGUI ;Go straight to summoning the GUI
	
	;Register main hotkeys
	Hotkey, If, _AhkScriptIsActive()
	Hotkey, %uSummonGUI%, SummonGUI
	Hotkey, %uGotoDef%,   GotoDefinition
	Hotkey, %uGoBack%,    PreviousView
	Hotkey, %uGoForward%, NextView
	
	;Optimize before starting loop or ending autoexecute section
	EmptyMem()
	
	If bQuitWithEditor {
		Loop {
			Sleep, 1000 ;Check if we need to quit
			If Not WinExist("ahk_id " _GetSciTEHandle())
				ExitApp
		}
	}
	
Return

TrayClose:
ExitApp

/************\
 GUI related |
		   */

;User summoned the GUI
SummonGUI:
	
	;Switch thread to full speed
	SetBatchLines, -1
	
	;Check if focus is not on us
	If Not WinActive("ahk_id " hGui) {
		
		;Check if editor is valid
		hEditor := _SciTEIsActive()
		If !hEditor
			Return ;We were summoned from a foreign active window
	}
	
	;Check if we're already showing
	If bShowing {
		
		;Check if we're currently active
		If WinActive("ahk_id " hGui) {
			
			;Check if there's an item currently selected. LB_GETCURSEL
			SendMessage, 0x188, 0, 0,, ahk_id %hlblList%
			
			;Check for LB_ERR
			If (ErrorLevel <> 0xFFFFFFFF)
				Goto SelectItem
			Else ControlFocus,, ahk_id %htxtSearch% ;Put focus back on the textbox
			
		} Else { ;We're not active. That means the editor is active
			
			;Check if the mouse was used
			If bCheckClick {
				If CheckTextClick(clickX, clickY) {
					Gosub, SelectItem
					If Not bCheckClick
						Return ;SelectItem found a match. We're done
				}
				bCheckClick := False
				
				;clickText failed. Validate listbox selection if any. LB_GETCURSEL
				SendMessage, 0x188, 0, 0,, ahk_id %hlblList%
				
				;Check for error. LB_ERR
				If (ErrorLevel <> 0xFFFFFFFF)
					Goto, SelectItem
			}
			
			;Check if new text has been selected
			s := Sci_GetSelText(hSci)
			If (s <> sSelText) And Not InStr(s, "`n") {
				
				;Keep the old
				sSelText := s
				
				;Copy the selected text in the textbox
				GuiControl,, txtSearch, %sSelText%
				
				;Create a list based on sel
				CreateList(sSelText)
				
				;Check if it's just one match. If so, go to it. LB_GETCOUNT.
				SendMessage, 395, 0, 0,, ahk_id %hlblList%
				If (ErrorLevel = 1)
					Goto SelectItem
				
				;Select all. EM_SETSEL
				SendMessage, 177, 0, -1,, ahk_id %htxtSearch%
			}
			
			;Focus on textbox
			WinActivate, ahk_id %hGui%
			ControlFocus,, ahk_id %htxtSearch%
		}
	}
	
	;Get handle to focused control
	ControlGetFocus, cSci, ahk_id %hEditor%
	
	;Check if it fits the class name
	If InStr(cSci, "Scintilla")
		ControlGet, hSci, Hwnd,, %cSci%, ahk_id %hEditor%
	Else Return
	
	;Get the filename
	sScriptPath := _GetSciTEFile()
	
	Gosub, AnalyseScript
	
	;Check if we're doing CheckOnClick
	If bCheckClick {
		If CheckTextClick(clickX, clickY) {
			Gosub, SelectItem
			If Not bCheckClick
				Return
		}
		bCheckClick := False
	}
	
	;Check if we have to append filename
	If (iIncludeMode & 0x10000000)
		AppendFilename()
	
	;Check if text is selected
	sSelText := Sci_GetSelText(hSci)
	If (sSelText <> "") And Not RegExMatch(sSelText, "[\r\n]") {
		
		;Copy the selected text in the textbox
		GuiControl,, txtSearch, %sSelText%
		
		;Create a list based on sel
		CreateList(sSelText)
		
		;Check if it's just one match. If so, go to it. LB_GETCOUNT.
		SendMessage, 395, 0, 0,, ahk_id %hlblList%
		If (ErrorLevel = 1)
			Goto SelectItem
		
		;Select all. EM_SETSEL
		SendMessage, 177, 0, -1,, ahk_id %htxtSearch%
		
	} Else {    ;Otherwise, empty the textbox and show the whole list
		GuiControl,, txtSearch,
		CreateList()
	}
	
	;Set up textbox and listbox width
	If bWideView {
		
		;We need to calculate the dimensions of the GUI to accomodate all items
		
		;Check if there will be a vscroll if filter is empty
		bVScroll := (sLabels0 + sFuncs0 > iGUIHeight)
		
		;Get the longest item if filter is empty
		iW := GetLongestItem(hlblList) + (bVScroll ? SM_CXVSCROLL : 0) + 4
		iW := iW < iGUIWidth ? iGUIWidth : iW
		
		;Make sure there's no hscroll
		PostMessage, 404,,,, ahk_id %hlblList% ;LB_SETHORIZONTALEXTENT
		
		;Update the size of the controls
		ControlMove,,,, iW,, ahk_id %htxtSearch%
		ControlMove,,,, iW,, ahk_id %hlblList%
	} Else iW := iGUIWidth
	
	;Check if hscroll will appear and adjust height to make sure %iGUIHeight% items are visible
	SendMessage, 403, 0, 0,, ahk_id %hlblList% ;LB_GETHORIZONTALEXTENT
	ControlMove,,,,, iGUIHeight * iGUIItemHeight + (ErrorLevel > iW ? SM_CYHSCROLL : 0) + 4, ahk_id %hlblList%
	
	;Get window info
	WinGetPos, iX, iY,,, ahk_id %hEditor%
	ControlGetPos, sX, sY, sW, sH, %cSci%, ahk_id %hEditor%
	iX += sX + (Not bPosLeft ? sW - (iW + (iMargin * 2)*A_ScreenDPI/96) - (Sci_VScrollVisible(hSci) ? SM_CXVSCROLL : 0) - 2 : 2)
	iY += sY + 2
	
	;Make sure we should still show the GUI
	If !_SciTEIsActive()
		Return
	
	Gui, Show, w0 h0
	WinSet, Transparent, 0, ahk_id %hGui%
	Gui, Show, AutoSize x%iX% y%iY%
	
	bShowing := True
	SetTimer, CheckFocus, 50
	
	;Put the focus on the textbox
	ControlFocus,, ahk_id %htxtSearch%
	
	;Do the fade-in effect
	i := 0
	While (i <= iTransparency) {
		WinSet, Transparent, %i%, ahk_id %hGui%
		i += 15
		Sleep, 10
	}
	
	If Not iTransparency Or (iTransparency = 255) ;Turn off if opaque
		WinSet, Transparent, OFF, ahk_id %hGui%
	
Return

GuiEscape:
	If bQuickMode
		ExitApp
	bShowing := False
	Gui, Cancel
	Gui, Show, Hide w0 h0
	VarSetCapacity(sScript, 0)
	EmptyMem()
Return

CheckFocus:
	t := _GetSciTEFile()
	If Not WinActive("ahk_id " hGui) And Not WinActive("ahk_id " hEditor) Or (t <> sScriptPath) {
		SetTimer, CheckFocus, Off
		Gosub, GuiEscape
	}
Return

;Incremental searching
txtSearch_Event:
	If bShowing {
		GuiControlGet, s,, txtSearch
		CreateList(s)        
	}
Return

PreviousView:
	LineHistory(False)
Return

NextView:
	LineHistory(True)
Return

GotoDefinition:
	clickX := -1, clickY := -1, bCheckClick := True
	Goto, SummonGUI
Return

lblList_Event:
	If (A_GuiEvent <> "DoubleClick")
		Return
SelectItem:
	
	;Check if we're doing CheckTextClick
	If bCheckClick {
		
		;Try with functions first (internal first)
		clickedFunc .= "()", i := 0
		While (A_Index <= sFuncs0) And Not i
			If (sFuncs%A_Index% = clickedFunc)
				i := A_Index
		
		;Check if we found something
		If Not i {
			
			;Try with labels
			i := CheckLabelMatch(clickedLabel, iInLinePos)
			If Not i
				Return
			
			bIsFunc := False
		} Else bIsFunc := True
		
		;Move the caret to the position before going to item
		SendMessage, 2025, iPos, 0,, ahk_id %hSci% ;SCI_GOTOPOS
		
		bCheckClick := False
		
	} Else {
		
		;Get selected item index. LB_GETCURSEL
		SendMessage, 0x188, 0, 0,, ahk_id %hlblList%
		
		;Check for error. LB_ERR
		If (ErrorLevel = 0xFFFFFFFF)
			Return
		
		;Get the associated item data
		i := GetListBoxItemData(hlblList, ErrorLevel) 
		
		;Retrieve function flag in high-word and set i to the index in low-word
		bIsFunc := (i >> 16)
		i &= 0xFFFF
	}
	
	If bIsFunc {
		
		;Check if it's external
		If sFuncs%i%_File
			LaunchFile(GetFile(sFuncs%i%_File, True), sFuncs%i%_Line)
		Else ShowLine(sFuncs%i%_Line)
		
	} Else {
		
		;Check if it's external
		If sLabels%i%_File
			LaunchFile(GetFile(sLabels%i%_File, True), sLabels%i%_Line)
		Else ShowLine(sLabels%i%_Line)
	}
	
	Goto GuiEscape  ;Done
Return

LaunchFile(sFilePath, iLine) {
	Global cSci, oSciTE
	
	;Open the file in SciTE
	oSciTE.OpenFile(sFilePath)
	
	;Get handle to Scintilla control
	ControlGet, hSci, Hwnd,, %cSci%, A
	
	;Make the target line appear on top
	SendMessage, 2370, 0, 0,, ahk_id %hSci%
	SendMessage, 2024, iLine + ErrorLevel - 1, 0,, ahk_id %hSci%
	SendMessage, 2024, iLine - 1, 0,, ahk_id %hSci%
}

CheckLabelMatch(sHaystack, iPos) {
	Global sLabels0
	
	maxLen := 0, maxIdx := 0
	Loop % sLabels0 ;We need to do it without the trailing colon
		If (i := InStr(sHaystack, SubStr(sLabels%A_Index%, 1, (j := StrLen(sLabels%A_Index%)) - 1)))
			If (i <= iPos) And (i + j >= iPos) And (j > maxLen)
				maxLen := j, maxIdx := A_Index
	
	Return maxIdx
}

GUIInteract(wParam, lParam, msg, hwnd) {
	Local iCount, flags, bMDown, bMUp, sControl, cX, cY, bForward
	Static bLButtonDown := False, bIgnoreMUp := False
	
	Critical
	
	;Check which message it is
	If (msg = 256) {    ;WM_KEYDOWN
		
		IfEqual wParam, 13, Gosub SelectItem ;Enter
		
		;Check if it's the textbox
		If (hwnd = htxtSearch) {
			If (wParam = 38) {  ;Up
				If Not WrapSel(True) {
					ControlSend,, {Up}, ahk_id %hlblList%
					Return True
				}
			} Else If (wParam = 40) {  ;Down
				If Not WrapSel(False) {
					ControlSend,, {Down}, ahk_id %hlblList%
					Return True
				}
			} Else If (wParam = 33) {  ;Page Up
					ControlSend,, {PgUp}, ahk_id %hlblList%
					Return True
			} Else If (wParam = 34) {  ;Page Down
					ControlSend,, {PgDn}, ahk_id %hlblList%
					Return True
			} Else If (wParam = 35) And GetKeyState("Ctrl", "P") {  ;Ctrl+End
					ControlSend,, {End}, ahk_id %hlblList%
					Return True
			} Else If (wParam = 36) And GetKeyState("Ctrl", "P") {  ;Ctrl+Home
					ControlSend,, {Home}, ahk_id %hlblList%
					Return True
			}
		} Else If (hwnd = hlblList) {   ;Make up/down wrap around
			If (wParam = 38) Or (wParam = 40)
				Return WrapSel(wParam = 38) ? True : ""
		}
	} Else If (msg = 522) And (hwnd = htxtSearch) { ;WM_MOUSEWHEEL
		
		;Check if the listbox is even populated
		SendMessage, 395, 0, 0,, ahk_id %hlblList%
		If Not ErrorLevel
			Return  ;Listbox is empty
		
		;Sign it if needed
		wParam := wParam > 0x7FFFFFFF ? -(~wParam) - 1 : wParam
		
		;Get notches turned
		wParam := Round((wParam >> 16) / 120)
		bForward := wParam > 0
		
		Loop % Abs(wParam)
			If Not WrapSel(bForward)
				ControlSend,, % bForward ? "{Up}" : "{Down}", ahk_id %hlblList%
		
	} Else If (msg = 255) { ;WM_INPUT
		
		;Get flags
		flags := HID_GetInputInfo(lParam, (12 + A_PtrSize * 2) | 0x0100)
		
		If (flags = -1) ;Check if we got an error
			Return 0
		
		;Check if middle mouse button is down/up
		bMDown := flags & 0x0010
		bMUp   := flags & 0x0020
		
		;Check for line history
		If (flags & 0x0400) And GetKeyState("Shift", "P") And _SciTEIsActive() {
			iWheelTurns := HID_GetInputInfo(lParam, (14 + A_PtrSize * 2) | 0x1100)
			If (iWheelTurns <> -1) {    ;Check for error
				iWheelTurns := Round(iWheelTurns / 120)
				bForward := iWheelTurns > 0
				Loop % Abs(iWheelTurns)
					LineHistory(bForward)
			}
			
			;Done here
			Return 0
		}
		
		;To save time for most cases this branch will be executed
		If Not (bMDown Or bMUp)
			Return 0
		
		If bMDown And bShowing {
			SetTimer, GuiEscape, -%iCancelWait%
			bIgnoreMUp := True
		} Else If bMDown And Not _SciTEIsActive()
			bIgnoreMUp := True ;So that we don't launch if the press started somewhere else
		Else If bMUp And bUseMButton And (Not bIgnoreMUp Or bShowing) And _SciTEIsActive() {
			
			;Cancel timer
			SetTimer, GuiEscape, Off
			
			;Get mouse data
			MouseGetPos, clickX, clickY,, sControl
			
			;Make sure the click was made inside the Scintilla control
			If Not InStr(sControl, "Scintilla")
				Return 0
			
			;Prep data for check click
			ControlGet, hSci, Hwnd,, %sControl%
			ControlGetPos, cX, cY,,, %sControl%
			clickX -= cX, clickY -= cY, bCheckClick := True
			
			SetTimer, SummonGUI, -1
		}
		
		If bMUp And bIgnoreMUp
			bIgnoreMUp := False
		
		Return 0
	
	}
}

WrapSel(bUp) {
	Local iCount, iSel
	
	;Get selected item index and count. LB_GETCOUNT. LB_GETCURSEL.
	SendMessage, 395, 0, 0,, ahk_id %hlblList%
	iCount := ErrorLevel
	SendMessage, 392, 0, 0,, ahk_id %hlblList%
	iSel := ErrorLevel
	
	;Select the first/last item. LB_SETCURSEL
	If bUp And (iSel = 0) {
		SendMessage 390, iCount - 1, 0,, ahk_id %hlblList%
		Return 1
	} Else If Not bUp And (iSel = iCount - 1) {
		SendMessage 390, 0, 0,, ahk_id %hlblList%
		Return 1
	}
	Return 0
}

;This sub deletes all cache files on exit
DeleteCache:
	FileDelete, %A_Temp%\*.TGcache
	ExitApp
Return

/*******************\
 Scanning functions |
				  */

;Retrieves labels and functions of the script
AnalyseScript:
	
	;Reset counters
	sLabels0 := 0
	sFuncs0 := 0
	sPaths0 := 0
	sScanFile0 := 0
	
	;Get full text
	sScript := Sci_GetText(hSci)
	
	If bDirectives
		GetScriptDirectives(sScript)
	
	;Ban comments if necessary
	If bFilterComments
		FilterComments(sScript)
	
	;Get labels and functions
	GetScriptLabels(sScript)
	GetScriptHotkeys(sScript)
	GetScriptFunctions(sScript)
	
	;Check if we're doing #Include files
	If (iIncludeMode & 0x00000001) {
		
		;Get the script's dir
		StringLeft, sScriptDir, sScriptPath, InStr(sScriptPath, "\", False, 0) - 1
		
		;Set the default include path to the script directory
		sWorkDir := sScriptDir
		SetWorkingDir, %sWorkDir%
		
		;Loop through each #Include file
		i := 1
		Loop {
			
			;Get the next include directive
			i := RegExMatch(sScript, "im)(*ANYCRLF)^[[:blank:]]*#Include(Again)?[[:blank:]]*"
								   . "(,|[[:blank:]]+)[[:blank:]]*(\*i[[:blank:]]+)?\K.*?$", t, i)
			
			;Make sure we've got something
			If Not i
				Break
			
			;Replace path variables
			StringReplace t, t, % "%A_ScriptDir%", %sScriptDir%
			StringReplace t, t, % "%A_AppData%", %A_AppData%
			StringReplace t, t, % "%A_AppDataCommon%", %A_AppDataCommon%
			
			;Check if it's a directory or file
			s := FileExist(t)
			If InStr(s, "D") {    ;It's a folder. Change working directory
				sWorkDir := t
				SetWorkingDir, %sWorkDir%
			} Else If s {            ;It's a file
				ScanScriptFile(t, iIncludeMode & 0x01000000, False, True)
				SetWorkingDir, %sWorkDir% ;Put the working dir's path back to here
			}
			
			;Start at next line
			i := RegExMatch(sScript, "[\r\n]+\K.", "", i)
			If Not i ;Check if that was the last line
				Break
		}
		
		;Free memory
		sScript := ""
		
		;Put working dir back to here
		sWorkDir := sScriptDir
		SetWorkingDir, %sWorkDir%
		
		;Loop through Scan directives, if any
		Loop %sScanFile0% {
			
			t := sScanFile%A_Index%
			
			;Replace path variables
			StringReplace t, t, % "%A_ScriptDir%", %sScriptDir%
			StringReplace t, t, % "%A_AppData%", %A_AppData%
			StringReplace t, t, % "%A_AppDataCommon%", %A_AppDataCommon%
			
			;Check if it's a directory or file
			s := FileExist(t)
			If InStr(s, "D") { ;It's a folder. Change working directory
				sWorkDir := t
				SetWorkingDir, %sWorkDir%
			} Else If s {            ;It's a file
				ScanScriptFile(t, iIncludeMode & 0x01000000, False, True)
				SetWorkingDir, %sWorkDir% ;Put the working dir's path back to here
			} Else If RegExMatch(t, "<\K.*(?=\>)", t) And (t := FindLibFile(t)) { ;Check if it's a lib file
				ScanScriptFile(t, iIncludeMode & 0x01000000, True, False)
			}
		}
	}
	
	;Check if we're also scanning library functions
	If (iIncludeMode & 0x00000010) {
		
		;User library takes priority
		Loop, %sScriptDir%\Lib\*.ahk, 1, 1
			ScanScriptFile(A_LoopFileLongPath, iIncludeMode & 0x01000000, True, False) ;With bFuncsOnly flag
		
		Loop, %A_MyDocuments%\AutoHotkey\Lib\*.ahk, 1, 1
			ScanScriptFile(A_LoopFileLongPath, iIncludeMode & 0x01000000, True, False) ;With bFuncsOnly flag
		
		;Get path of running AutoHotkey
		; <fincs-edit> Use actual AutoHotkey build instead of internal one
		UsedAhkPath := oSciTE.ResolveProp("AutoHotkey")
		
		StringLeft, sLibPattern, UsedAhkPath, InStr(UsedAhkPath, "\", False, 0)
		sLibPattern .= "Lib\*.ahk"
		
		Loop, %sLibPattern%, 1, 1
			ScanScriptFile(A_LoopFileLongPath, iIncludeMode & 0x01000000, True, False) ;With bFuncsOnly flag
	}
	
Return

FindLibFile(sLib) {
	global oSciTE
	
	;Append extension if none given
	StringRight, t, sLib, 4
	If (t <> ".ahk")
		sLib .= ".ahk"
	
	;User library takes priority
	Loop, %sScriptDir%\Lib\*.ahk, 1, 1
		If (A_LoopFileName = sLib)
			Return A_LoopFileLongPath
	
	Loop, %A_MyDocuments%\AutoHotkey\Lib\*.ahk, 1, 1
		If (A_LoopFileName = sLib)
			Return A_LoopFileLongPath
	
	;Get path of running AutoHotkey
	; <fincs-edit> Use actual AutoHotkey build instead of internal one
	UsedAhkPath := oSciTE.ResolveProp("AutoHotkey")
	
	StringLeft, sLibPattern, UsedAhkPath, InStr(UsedAhkPath, "\", False, 0)
	sLibPattern .= "Lib\*.ahk"
	
	Loop, %sLibPattern%, 1, 1
		If (A_LoopFileName = sLib)
			Return A_LoopFileLongPath
}

ScanScriptFile(sPath, bRecurse = False, bFuncsOnly = False, bIsInclude = False) {
	Local sFile, s, i, sInclude, sScriptDir, iCacheIndex, iCacheType, sWorkDir
	
	sPath := AbsolutePath(sPath)
	
	;Make sure it's not the same as the script
	If (sPath = sScriptPath)
		Return
	
	;Make sure it hasn't already been done
	Loop %sPaths0%
		If (sPaths%A_Index% = sPath)
			Return
	
	sPaths0 += 1
	sPaths%sPaths0% := sPath
	sPaths%sPaths0%_Inc := bIsInclude
	
	;Get the script's dir and set the default include path to it
	StringLeft sScriptDir, sPath, InStr(sPath, "\", False, 0) - 1
	sWorkDir := sScriptDir
	SetWorkingDir, %sWorkDir%
	
	If bCacheFiles {
		
		;iCacheType := 0x1111 - 0x1000 = file changed/not found, 0x100 = hotkeys, 0x10 = labels, 0x1 = funcs
		iCacheIndex := IsCached(sPath, iCacheType)
		
		;Expand cache array if it is not cached
		If Not iCacheIndex {
			sCache0 += 1
			iCacheIndex := sCache0
			sCache%iCacheIndex%_Path := sPath
		}
		
		If (iIncludeMode & 0x00000100) {
			If Not (iCacheType & 0x001) Or (iCacheType & 0x001) And GetCachedScriptFunctions(iCacheIndex) {
				
				If Not sFile {
					FileRead, sFile, %sPath%
					ApplyCommentFilterSetting(sFile)
				}
				
				i := sFuncs0
				GetScriptFunctions(sFile, True)
				If (i <> sFuncs0)
					CacheFile("Functions", i, sFuncs0, iCacheIndex)
			}
		}
		
		If Not bFuncsOnly {
			If (iIncludeMode & 0x00001000) {
				If Not (iCacheType & 0x010) Or (iCacheType & 0x010) And GetCachedScriptLabels(iCacheIndex) {
					
					If Not sFile {
						FileRead, sFile, %sPath%
						ApplyCommentFilterSetting(sFile)
					}
					
					i := sLabels0
					GetScriptLabels(sFile, True)
					If (i <> sLabels0)
						CacheFile("Labels", i, sLabels0, iCacheIndex)
				}
			}
			
			If (iIncludeMode & 0x00010000) {
				If Not (iCacheType & 0x100) Or (iCacheType & 0x100) And GetCachedScriptHotkeys(iCacheIndex) {
					
					If Not sFile {
						FileRead, sFile, %sPath%
						ApplyCommentFilterSetting(sFile)
					}
					
					i := sLabels0
					GetScriptHotkeys(sFile, True)
					If (i <> sLabels0)
						CacheFile("Hotkeys", i, sLabels0, iCacheIndex)
				}
			}
		}
		
		;Calculate CRC and add to cache array
		sCache%iCacheIndex%_CRC := GetFileCRC32(sPath)
		
	} Else {    ;We don't cache
		
		;Load file and comment if requested
		FileRead, sFile, %sPath%
		ApplyCommentFilterSetting(sFile)
		
		If (iIncludeMode & 0x00000100)
			GetScriptFunctions(sFile, True)
		If Not bFuncsOnly {
			If (iIncludeMode & 0x00001000)
				GetScriptLabels(sFile, True)
			If (iIncludeMode & 0x00010000)
				GetScriptHotkeys(sFile, True)
		}
	}
	
	;Check if we're recursing
	If bRecurse {
		
		;Check if include files are cached
		If bCacheFiles And (iCacheIndex < sCache0) And Not (iCacheType & 0x1000) {
			Loop, Parse, sCache%iCacheIndex%_IncFiles, `n ;Get the list of cached files
				If FileExist(A_LoopField)
					ScanScriptFile(A_LoopField, bRecurse, False, bIsInclude)
		} Else { ;We'll have to manually look for the include files
			
			If Not sFile {
				FileRead, sFile, %sPath%
				ApplyCommentFilterSetting(sFile)
			}
			
			;Loop through each #Include file
			i := 1
			Loop {
				
				;Get the next include directive
				i := RegExMatch(sFile, "im)(*ANYCRLF)^[[:blank:]]*#Include(Again)?[[:blank:]]*"
									 . "(,|[[:blank:]]+)[[:blank:]]*(\*i[[:blank:]]+)?\K.*?$", sInclude, i)
				
				;Make sure we've got something
				If Not i
					Break
				
				;Replace path variables
				StringReplace sInclude, sInclude, % "%A_ScriptDir%", %sScriptDir%
				StringReplace sInclude, sInclude, % "%A_AppData%", %A_AppData%
				StringReplace sInclude, sInclude, % "%A_AppDataCommon%", %A_AppDataCommon%
				
				;Check if it's a directory or file
				s := FileExist(sInclude)
				If InStr(s, "D") { ;It's a folder. Change working directory
					sWorkDir := sInclude
					SetWorkingDir, %sWorkDir%
				} Else If s {            ;It's a file
					
					s := AbsolutePath(sInclude)
					
					;Add the file to the cache array
					If bCacheFiles
						sCache%iCacheIndex%_IncFiles .= s "`n"
					
					ScanScriptFile(s, bRecurse, False, bIsInclude)
					SetWorkingDir, %sWorkDir% ;Put the working dir's path back to here
				}
				
				;Start at next line
				i := RegExMatch(sFile, "[\r\n]+\K.", "", i)
				If Not i ;Check if that was the last line
					Break
			}
		}
	}
}

AbsolutePath(sPath) {
	If DllCall("shlwapi\PathIsRelative", "Ptr", &sPath) {
		n := DllCall("GetFullPathName", "Ptr", &sPath, "UInt", 0, "UInt", 0, "Int", 0)
		VarSetCapacity(sAbs, A_IsUnicode ? n * 2 : n)
		DllCall("GetFullPathName", "Ptr", &sPath, "UInt", n, "Str", sAbs, "Ptr*", 0)
		Return sAbs
	} Else Return sPath
}

IsCached(sPath, ByRef iCacheType) {
	Local i
	
	;Default value
	iCacheType := 0
	
	;Look for path in cache array
	Loop %sCache0% {
		If (sCache%A_Index%_Path = sPath) {
			i := A_Index
			Break
		}
	}
	
	;Check if we found the path
	If Not i
		Return 0
	Else {
		
		;Check first if it's the same file
		If (GetFileCRC32(sPath) = sCache%i%_CRC) {
			iCacheType |= FileExist(A_Temp "\" sCache%i%_Functions ".TGcache")  ? 0x001 : 0
			iCacheType |= FileExist(A_Temp "\" sCache%i%_Labels ".TGcache")     ? 0x010 : 0
			iCacheType |= FileExist(A_Temp "\" sCache%i%_Hotkeys ".TGcache")    ? 0x100 : 0
		} Else iCacheType := 0x1000
		
		Return i
	}
}

CacheFile(sType, iStart, iStop, iCacheIndex) {
	Local i, iRand, sAppend
	
	While Not iRand { ;Loop until we have a unique number
		Random, iRand, 1 ;Choose random number
		Loop %sCache0% ;Make sure it's not already taken
			If (sCache%A_Index%_Functions = iRand)
				Or (sCache%A_Index%_Labels = iRand)
				Or (sCache%A_Index%_Hotkeys = iRand) {
				iRand := 0 ;Already taken. Cancel it.
				Break
			}
	}
	
	;Delete file in case it exists
	FileDelete, %A_Temp%\%iRand%.TGcache
	
	;Prep var for file append
	If (sType = "Functions") {
		Loop % (iStop - iStart) {
			i := iStart + A_Index
			sAppend .= sFuncs%i% "`n" sFuncs%i%_Line "`n"
		}
	} Else {
		Loop % (iStop - iStart) {
			i := iStart + A_Index
			sAppend .= sLabels%i% "`n" sLabels%i%_Line "`n"
		}
	}
	
	;Write var to file
	FileAppend, %sAppend%, %A_Temp%\%iRand%.TGcache
	
	;Add cache reference to cache array
	sCache%iCacheIndex%_%sType% := iRand
}

;This sub analyses the script and add the labels in it to the array
GetScriptLabels(ByRef s, bExternal = False) {
	Local i, t, u, v
	
	u := GetScriptEscapeChar(s)
	v := GetScriptCommentFlag(s)
	
	;Reset counter
	i := 1
	Loop {
		
		;Get next label. All valid (non-hotkey) labels are detected.
		;(invalid characters are commas, spaces, and escape char)
		i := RegExMatch(s, "m)(*ANYCRLF)^[[:blank:]]*(?!\Q" v "\E)"
						 . "\K[a-zA-Z0-9\Q@#$_[]?~``!%^&*+-()={}|\:;""'<>./\E]+:"
						 . "(?=([[:blank:]]*[\r\n]|[[:blank:]]+\Q" v "\E))", t, i)
		
		;Make sure we found something
		If Not i
			Break
		
		;We found a label. Trim everything after the last colon
		StringLeft t, t, InStr(t, ":", False, 0)
		
		;Make sure it doesn't contain an escape character (unless if it's to escape the comment flag)
		If Not RegExMatch(t, "\Q" u "\E(?!\Q" v "\E)") {
			
			;Erase any occurence of the escape char
			StringReplace, t, t, %u%,, All
			
			sLabels0 += 1    ;Increase counter
			If bExternal {
				sLabels%sLabels0%_File := sPaths0
				sLabels%sLabels0%_Line := LineFromPosEx(s, i)
			} Else {
				sLabels%sLabels0%_File := 0
				sLabels%sLabels0%_Line := LineFromPos(i)
			}
			
			sLabels%sLabels0% := t    ;Add to array
		}
		
		;Set i to the beginning of the next line
		i := RegExMatch(s, "[\r\n]+\K.", "", i)
		If Not i
			Break
	}
}

GetCachedScriptLabels(iCacheIndex) {
	Local s, bLineType
	
	;Formulate path
	s := A_Temp "\" sCache%iCacheIndex%_Labels ".TGcache"
	
	;Check if the file exists
	If Not FileExist(s)
		Return True ;Error
	Else {
		
		Loop, Read, %s%
		{   
			If bLineType
				sLabels%sLabels0%_Line := A_LoopReadLine
			Else {
				sLabels0 += 1
				sLabels%sLabels0% := A_LoopReadLine
				sLabels%sLabels0%_File := sPaths0
			}
			bLineType := Not bLineType
		}
	}
}

;This sub analyses the script and add the hotkeys in it to the array (uses the same array as labels)
GetScriptHotkeys(ByRef s, bExternal = False) {
	Local i, n, t, u, v
	
	i := 1
	Loop {
		
		;Get next hotkey
		i := RegExMatch(s, "m)(*ANYCRLF)^[[:blank:]]*\K[a-zA-Z0-9\Q%(){}|:""?#_!@^+&<>*~$``-=\[]';/\.,\E]+"
						 . "([[:blank:]]+&[[:blank:]]+[a-zA-Z0-9\Q%(){}|:""?#_!@^+&<>*~$``-=\[]';/\.,\E]+)?"
						 . "([[:blank:]]+Up)?(?=::)", t, i)
		
		;Make sure we found something
		If Not i
			Break
		
		;Check if it's a valid hotkey
		If Not IsValidHotkey(t) { ;It failed validity test. Check if it's the exception [escapechar][commentflag]
			
			;Get the script's escape character and append comment flag
			u := u ? u : GetScriptEscapeChar(s)
			v := v ? v : GetScriptCommentFlag(s)
			
			StringReplace, t, t, %u%%v%, %v%, UseErrorLevel
			
			;Check if it's worth rechecking validity
			If (Not ErrorLevel) Or (ErrorLevel And Not IsValidHotkey(t))
				Goto, NextIteration
		}
		
		;Append the semi-colons
		t .= "::"
		
		;Expand the array and fill in the elements
		sLabels0 += 1    ;Increase counter
		If bExternal {
			sLabels%sLabels0%_File := sPaths0
			sLabels%sLabels0%_Line := LineFromPosEx(s, i)
		} Else {
			sLabels%sLabels0%_File := 0
			sLabels%sLabels0%_Line := LineFromPos(i)
		}
		
		sLabels%sLabels0% := t    ;Add to array
		
		NextIteration:
		
		;Set i to the beginning of the next line
		i := RegExMatch(s, "[\r\n]+\K.", "", i)
		If Not i
			Break
	}
}

GetCachedScriptHotkeys(iCacheIndex) {
	Local s, bLineType
	
	;Formulate path
	s := A_Temp "\" sCache%iCacheIndex%_Hotkeys ".TGcache"
	
	;Check if the file exists
	If Not FileExist(s)
		Return True ;Error
	Else {
		
		Loop, Read, %s%
		{
			If bLineType
				sLabels%sLabels0%_Line := A_LoopReadLine
			Else {
				sLabels0 += 1
				sLabels%sLabels0% := A_LoopReadLine
				sLabels%sLabels0%_File := sPaths0
			}
			bLineType := Not bLineType
		}
	}
}

;This sub checks the validity of a hotkey
IsValidHotkey(ByRef s) {
	Critical
	Hotkey, IfWinActive, Title ;Make sure it'll be a variant and not override a current shortcut
	Hotkey, % s, SummonGUI, UseErrorLevel Off ;Using SummonGUI only to test
	i := ErrorLevel ;Keep ErrorLevel value (because the next command will change it)
	Hotkey, IfWinActive ;Turn off context sensitivity
	Return (i <> 2)
}

;This sub analyses the script and add the functions in it to the array
GetScriptFunctions(ByRef s, bExternal = False) {
	Local i, t, u
	
	u := GetScriptCommentFlag(s)
	
	;Loop through the functions
	i := 1
	Loop {
		
		;Get the next function
		i := RegExMatch(s, "m)(*ANYCRLF)^[[:blank:]]*\K[a-zA-Z0-9#_@\$\?\[\]]+"
						 . "(?=\(.*?\)(\s+\Q" u "\E.*?[\r\n]+)*?\s+\{)", t, i)
		
		;Check if we found something
		If Not i
			Break
		
		;Make sure it's a valid function
		If t Not In If,While
		{   ;Increment counter
			sFuncs0 += 1
			
			t .= "()"
			If bExternal {
				sFuncs%sFuncs0%_File := sPaths0
				sFuncs%sFuncs0%_Line := LineFromPosEx(s, i)
			} Else {
				sFuncs%sFuncs0%_File := 0
				sFuncs%sFuncs0%_Line := LineFromPos(i)
			}
			
			sFuncs%sFuncs0% := t
		}
		
		;Get the next function
		i := RegExMatch(s, "[\r\n]+\K.", "", i)
		If Not i
			Break
	}
}

GetCachedScriptFunctions(iCacheIndex) {
	Local s, bLineType
	
	;Formulate path
	s := A_Temp "\" sCache%iCacheIndex%_Functions ".TGcache"
	
	;Check if the file exists
	If Not FileExist(s)
		Return True ;Error
	Else {
		
		Loop, Read, %s%
		{
			If bLineType
				sFuncs%sFuncs0%_Line := A_LoopReadLine
			Else {
				sFuncs0 += 1
				sFuncs%sFuncs0% := A_LoopReadLine
				sFuncs%sFuncs0%_File := sPaths0
			}
			bLineType := Not bLineType
		}
	}
}

GetScriptDirectives(ByRef s) {
	Local i, u, val
	
	;Get the comment flag used
	u := GetScriptCommentFlag(s)
	
	;Check for TillaGoto.bFilterComments
	bFilterComments := RegExMatch(s, "im)(*ANYCRLF)^[[:blank:]]*\Q" u "\E[[:blank:]]*"
								   . "TillaGoto\.bFilterComments[[:blank:]]*=[[:blank:]]*\K.*?$", val)
								   ? val : bFilterCommentsOrig

	;Check for TillaGoto.iIncludeMode
	iIncludeMode := RegExMatch(s, "im)(*ANYCRLF)^[[:blank:]]*\Q" u "\E[[:blank:]]*"
								. "TillaGoto\.iIncludeMode[[:blank:]]*=[[:blank:]]*\K.*?$", val)
								? val : iIncludeModeOrig
	
	;Check for Include directives
	i := 1
	Loop {
		i := RegExMatch(s, "im)(*ANYCRLF)^[[:blank:]]*\Q" u "\E[[:blank:]]*"
						 . "TillaGoto\.ScanFile[[:blank:]]*=[[:blank:]]*\K.*?$", val, i)
		
		If Not i
			Break
		
		;Add to array
		sScanFile0 += 1
		sScanFile%sScanFile0% := val
		
		;Move to next line
		i += StrLen(val) + 1
	}
}

ApplyCommentFilterSetting(ByRef sFile) {
	Global iIncludeMode
	
	;Remove comments if necessary
	bOverride := GetScriptCommentOverride(sFile)
	If (bOverride <> -1)
		bOverride ? FilterComments(sFile, True)
	Else If (iIncludeMode & 0x00100000)
		FilterComments(sFile, True)
}

GetScriptCommentOverride(ByRef s) {
	
	;Get the comment flag used
	sCommentFlag := GetScriptCommentFlag(s)
	
	;Check for TillaGoto.bFilterComments
	Return RegExMatch(s, "im)(*ANYCRLF)^[[:blank:]]*\Q" sCommentFlag "\E[[:blank:]]*"
					   . "TillaGoto\.bFilterComments[[:blank:]]*=[[:blank:]]*\K.*?$", val)
					   ? val : -1
}

FilterComments(ByRef s, bRespectLines = False) {
	Local i, j, len, sCommentFlag, blank, l1, l2
	
	i := 1
	Loop {
		
		;Get next block start
		i := RegExMatch(s, "m)(*ANYCRLF)^[[:blank:]]*/\*[^!]", "", i)
		
		If Not i
			Break
		
		;Get end of block, starting search at next line
		j := RegExMatch(s, "[\r\n]+\K.", "", i)
		j := RegExMatch(s, "Pm)(*ANYCRLF)^[[:blank:]]*\*/", len, j)
		
		;Make sure there's an end of block
		If Not j
			len := StrLen(s) - i
		Else len += (j - i)
		
		blank := GenSpaces(len)
		
		;Check if we need to respect line numbers
		If bRespectLines And j {
			
			;Get number of lines that would be erased
			l1 := LineFromPosEx(s, i)
			l2 := LineFromPosEx(s, j)
			
			;Put in the same amount of line feed characters
			Loop % (l2 - l1)
				NumPut(10, blank, (A_Index - 1) * (1 + !!A_IsUnicode), A_IsUnicode ? "UShort" : "UChar")
		}
		
		;Blank out
		DllCall("RtlMoveMemory", "Ptr", &s + (i - 1) * (1 + !!A_IsUnicode)
							   , "Ptr", &blank, "UInt", len * (1 + !!A_IsUnicode))
		
		If Not j
			Break
		Else i += len
	}
	
	;Get the comment flag used
	sCommentFlag := GetScriptCommentFlag(s)
	
	;Check if the very first line is a comment
	If (SubStr(s, 1, StrLen(sCommentFlag)) = sCommentFlag) {
		
		i := RegExMatch(s, "[\r\n]")
		If Not i ;The script contains only one line
			Return
		
		blank := GenSpaces(len := i - 1)
		DllCall("RtlMoveMemory", "Ptr", &s, "Ptr", &blank, "UInt", len * (1 + !!A_IsUnicode))
	}
}

GetScriptCommentFlag(ByRef s) {
	Return RegExMatch(s, "im)(*ANYCRLF)^[[:blank:]]*#CommentFlag[[:blank:]]*(,|[[:blank:]]+)[[:blank:]]*"
					   . "\K.*?[[:blank:]]*$", sCommentFlag) ? sCommentFlag : ";"
}

GetScriptEscapeChar(ByRef s) {
	Return RegExMatch(s, "im)(*ANYCRLF)^[[:blank:]]*#EscapeChar[[:blank:]]*(,|[[:blank:]]+)[[:blank:]]*"
					   . "\K.*?[[:blank:]]*$", sEscapeChar) ? sEscapeChar : "``"
}

/******************\
 Listbox functions |
				 */

AppendFilename() {
	Local i, max
	
	;Check what mode we're in
	If (iAlignFilenames = 0) { ;Simple append
		
		Loop %sLabels0%
			sLabels%A_Index%_List := sLabels%A_Index% (sLabels%A_Index%_File
								  ? (AppendSymbol(sLabels%A_Index%_File) GetFile(sLabels%A_Index%_File)) : "")
		Loop %sFuncs0%
			sFuncs%A_Index%_List := sFuncs%A_Index% (sFuncs%A_Index%_File
								 ? (AppendSymbol(sFuncs%A_Index%_File) GetFile(sFuncs%A_Index%_File)) : "")
		
	} Else { ;Right-align or left-align
		
		;Populate item lengths and find the longest one
		max := 0
		Loop %sLabels0% {
			sLabels%A_Index%_Len := StrLen(sLabels%A_Index%)
			If (i := sLabels%A_Index%_File) And (iAlignFilenames = 1)
				sLabels%A_Index%_Len += StrLen(GetFile(i)) + 1 ;for symbol
			
			If (sLabels%A_Index%_Len > max)
				max := sLabels%A_Index%_Len
		}
		
		Loop %sFuncs0% {
			sFuncs%A_Index%_Len := StrLen(sFuncs%A_Index%)
			If (i := sFuncs%A_Index%_File) And (iAlignFilenames = 1)
				sFuncs%A_Index%_Len += StrLen(GetFile(i)) + 1 ;for symbol
			
			If (sFuncs%A_Index%_Len > max)
				max := sFuncs%A_Index%_Len
		}
		
		;Pad all other items so that they are of the same length
		Loop %sLabels0%
			sLabels%A_Index%_List := sLabels%A_Index% (sLabels%A_Index%_File 
								  ? (GenSpaces(max - sLabels%A_Index%_Len) AppendSymbol(sLabels%A_Index%_File)
								  . GetFile(sLabels%A_Index%_File)) : "")
		Loop %sFuncs0%
			sFuncs%A_Index%_List := sFuncs%A_Index% (sFuncs%A_Index%_File 
								  ? (GenSpaces(max - sFuncs%A_Index%_Len) AppendSymbol(sFuncs%A_Index%_File)
								  . GetFile(sFuncs%A_Index%_File)) : "")
	}
}

GenSpaces(n) {
	Static func
	If Not func {
		If (A_PtrSize = 8)
			hex := "4963C085D27413660F1F840000000000C601204803C8FFCA75F6F3C3"
		Else hex := "8B44240885C074108B4C24048B54240CC6012003CA4875F8C3"
		
		VarSetCapacity(func, StrLen(hex) // 2)
		Loop % StrLen(hex) // 2
			NumPut("0x" . SubStr(hex, 2 * A_Index - 1, 2), func, A_Index - 1, "UChar")
		DllCall("VirtualProtect", "Ptr", &func, "UInt", VarSetCapacity(func), "UInt", 0x40, "UInt*", 0)
	}
	
	VarSetCapacity(s, (n + 1) * (1 + !!A_IsUnicode), 0)
	DllCall(&func, "Ptr", &s, "UInt", n, "Int", 1 + !!A_IsUnicode, "CDecl")
	VarSetCapacity(s, -1)
	
	Return s
}

AppendSymbol(i) { ;Use \ for include files and | for library functions
	Return sPaths%i%_Inc ? " \" : " |"
}

CreateList(filter = "") { 
	Global sLabels0, sFuncs0, bMatchEverywhere, hlblList, bShowing, iIncludeMode
	Static sLastfilter := "`n"  ;Initialize on an impossible filter
	
	;Trim the right side
	While (SubStr(filter, 0) = A_Space)
		StringTrimRight, filter, filter, 1
	
	;Trim right side if it ends in " !" since it changes nothing
	If (StrLen(filter) > 2) And (SubStr(filter, -1) = " !") And (SubStr(filter, -2, 1) <> A_Space)
		StringTrimRight, filter, filter, 2
	
	;Check if the filter is different
	If (filter = sLastfilter) And bShowing
		Return
	sLastfilter := filter
	
	;Disable redraw
	GuiControl, -Redraw, lblList
	
	;Clear
	GuiControl,, lblList,|
	
	;Check if we need to take from the _List elements
	;Although it looks extremely redundant and inefficient, it is much faster than the alternative
	If (iIncludeMode & 0x10000000) {
		
		If (filter = "") {  ;Split cases for speed
			Loop %sLabels0%
				AddListBoxItem(hlblList, sLabels%A_Index%_List, A_Index)
			Loop %sFuncs0%                                               ;0xFFFF highword means function
				AddListBoxItem(hlblList, sFuncs%A_Index%_List, A_Index + (0xFFFF << 16))
		} Else {
			
			;Split cases for speed
			If bMatchEverywhere {
				
				;Parse words
				StringSplit, words, filter, %A_Space%
				
				;Split cases for speed
				If (words0 > 1) {
					
					;Check for negative conditions (!)
					Loop %words0% {
						i := words0 - (A_Index - 1) ;Proceeding backwards because we're modifying the words
						If (InStr(words%i%, "!") = 1) {
							j := i - 1
							If (j And words%j% <> "") Or Not j {
								StringTrimLeft, words%i%, words%i%, 1
								words%i%_Not := StrLen(words%i%)
							}
						}
					}
					
					Loop %sLabels0% {
						bMatch := True, i := A_Index
						Loop %words0% {
							bMatch := bMatch
									  And ((words%A_Index%_Not And Not InStr(sLabels%i%_List, words%A_Index%))
									  Or (Not words%A_Index%_Not And InStr(sLabels%i%_List, words%A_Index%)))
							If Not bMatch
								Break
						}
						If bMatch
							AddListBoxItem(hlblList, sLabels%A_Index%_List, A_Index)
					}
					Loop %sFuncs0% {
						bMatch := True, i := A_Index
						Loop %words0% {
							bMatch := bMatch
									  And ((words%A_Index%_Not And Not InStr(sFuncs%i%_List, words%A_Index%))
									  Or (Not words%A_Index%_Not And InStr(sFuncs%i%_List, words%A_Index%)))
							If Not bMatch
								Break
						}
						If bMatch
							AddListBoxItem(hlblList, sFuncs%A_Index%_List, A_Index + (0xFFFF << 16))
					}
				;It's one word
				} Else {
					
					;Check if it's a negative condition (!)
					If (InStr(filter, "!") = 1) {
						StringTrimLeft, filter, filter, 1
						bNotWord := StrLen(filter)
					}
					
					Loop %sLabels0%
						If (bNotWord And Not InStr(sLabels%A_Index%_List, filter))
						   Or (Not bNotWord And InStr(sLabels%A_Index%_List, filter))
							AddListBoxItem(hlblList, sLabels%A_Index%_List, A_Index)
					Loop %sFuncs0%
						If (bNotWord And Not InStr(sFuncs%A_Index%_List, filter))
						   Or (Not bNotWord And InStr(sFuncs%A_Index%_List, filter))
							AddListBoxItem(hlblList, sFuncs%A_Index%_List, A_Index + (0xFFFF << 16))
				}
			} Else {
				Loop %sLabels0%
					If (InStr(sLabels%A_Index%_List, filter) = 1)
						AddListBoxItem(hlblList, sLabels%A_Index%_List, A_Index)
				Loop %sFuncs0%
					If (InStr(sFuncs%A_Index%_List, filter) = 1)
						AddListBoxItem(hlblList, sFuncs%A_Index%_List, A_Index + (0xFFFF << 16))
			}
		}
		
	} Else {
		
		If (filter = "") {  ;Split cases for speed
			Loop %sLabels0%
				AddListBoxItem(hlblList, sLabels%A_Index%, A_Index)
			Loop %sFuncs0%
				AddListBoxItem(hlblList, sFuncs%A_Index%, A_Index + (0xFFFF << 16))
		} Else {
			
			;Split cases for speed
			If bMatchEverywhere {
				
				;Parse words
				StringSplit, words, filter, %A_Space%
				
				;Split cases for speed
				If (words0 > 1) {
					
					;Check for negative conditions (!)
					Loop %words0% {
						i := words0 - (A_Index - 1) ;Proceeding backwards because we're modifying the words
						If (InStr(words%i%, "!") = 1) {
							j := i - 1
							If (j And words%j% <> "") Or Not j {
								StringTrimLeft, words%i%, words%i%, 1
								words%i%_Not := StrLen(words%i%)
							}
						}
					}
					
					Loop %sLabels0% {
						bMatch := True, i := A_Index
						Loop %words0% {
							bMatch := bMatch And ((words%A_Index%_Not And Not InStr(sLabels%i%, words%A_Index%))
									  Or (Not words%A_Index%_Not And InStr(sLabels%i%, words%A_Index%)))
							If Not bMatch
								Break
						}
						If bMatch
							AddListBoxItem(hlblList, sLabels%A_Index%, A_Index)
					}
					Loop %sFuncs0% {
						bMatch := True, i := A_Index
						Loop %words0% {
							bMatch := bMatch And ((words%A_Index%_Not And Not InStr(sFuncs%i%, words%A_Index%))
									  Or (Not words%A_Index%_Not And InStr(sFuncs%i%, words%A_Index%)))
							If Not bMatch
								Break
						}
						If bMatch
							AddListBoxItem(hlblList, sFuncs%A_Index%, A_Index + (0xFFFF << 16))
					}
				;It's one word
				} Else {
					
					;Check if it's a negative condition (!)
					If (InStr(filter, "!") = 1) {
						StringTrimLeft, filter, filter, 1
						bNotWord := StrLen(filter)
					}
					
					Loop %sLabels0%
						If (bNotWord And Not InStr(sLabels%A_Index%, filter))
						   Or (Not bNotWord And InStr(sLabels%A_Index%, filter))
							AddListBoxItem(hlblList, sLabels%A_Index%, A_Index)
					Loop %sFuncs0%
						If (bNotWord And Not InStr(sFuncs%A_Index%, filter))
						   Or (Not bNotWord And InStr(sFuncs%A_Index%, filter))
							AddListBoxItem(hlblList, sFuncs%A_Index%, A_Index + (0xFFFF << 16))
				}
			} Else {
				Loop %sLabels0%
					If (InStr(sLabels%A_Index%, filter) = 1)
						AddListBoxItem(hlblList, sLabels%A_Index%, A_Index)
				Loop %sFuncs0%
					If (InStr(sFuncs%A_Index%, filter) = 1)
						AddListBoxItem(hlblList, sFuncs%A_Index%, A_Index + (0xFFFF << 16))
			}
		}
	}
	
	;Add hscrollbar if necessary
	ListBoxAdjustHSB(hlblList)
	
	;Select the first item. LB_SETCURSEL
	SendMessage 390, 0, 0,, ahk_id %hlblList%
	
	;Redraw
	GuiControl, +Redraw, lblList
}

GetFile(i, bWholePath = False) {
	Static s, lastIdx := -1
	If bWholePath
		Return sPaths%i%
	Else {
		If (i = lastIdx)
			Return s
		Else {
			s := SubStr(sPaths%i%, InStr(sPaths%i%, "\", False, 0) + 1)
			s := (SubStr(s, -3) = ".ahk" ? SubStr(s, 1, -4) : s)    ;Trim ".ahk"
			Return s
		}
	}
}

ListBoxAdjustHSB(hLB) {
	
	;Declare variables (for clarity's sake)
	dwExtent := 0
	dwMaxExtent := 0
	hDCListBox := 0
	hFontOld := 0
	hFontNew := 0
	VarSetCapacity(lptm, A_IsUnicode ? 60 : 56)
	
	;Use GetDC to retrieve handle to the display context for the list box and store it in hDCListBox
	hDCListBox := DllCall("GetDC", "Ptr", hLB, "Ptr")
	
	;Send the list box a WM_GETFONT message to retrieve the handle to the 
	;font that the list box is using, and store this handle in hFontNew
	SendMessage 49, 0, 0,, ahk_id %hLB%
	hFontNew := ErrorLevel
	
	;Use SelectObject to select the font into the display context.
	;Retain the return value from the SelectObject call in hFontOld
	hFontOld := DllCall("SelectObject", "Ptr", hDCListBox, "Ptr", hFontNew, "Ptr")
	
	;Call GetTextMetrics to get additional information about the font being used
	;(eg. to get tmAveCharWidth's value)
	DllCall("GetTextMetrics", "Ptr", hDCListBox, "Ptr", &lptm)
	tmAveCharWidth := NumGet(lptm, 20, "UInt")
	
	;Get item count using LB_GETCOUNT
	SendMessage 395, 0, 0,, ahk_id %hLB%
	
	;Loop through the items
	Loop %ErrorLevel% {
		
		;Get list box item text
		s := GetListBoxItem(hLB, A_Index - 1)
		
		;For each string, the value of the extent to be used is calculated as follows:
		DllCall("GetTextExtentPoint32", "Ptr", hDCListBox, "Str", s, "Int", StrLen(s), "Int64P", nSize)
		dwExtent := (nSize & 0xFFFFFFFF) + tmAveCharWidth
		
		;Keep if it's the highest to date
		If (dwExtent > dwMaxExtent)
			dwMaxExtent := dwExtent
	}
	
	;After all the extents have been calculated, select the old font back into hDCListBox and then release it:
	DllCall("SelectObject", "Ptr", hDCListBox, "Ptr", hFontOld)
	DllCall("ReleaseDC", "Ptr", hLB, "Ptr", hDCListBox)
	
	;Adjust the horizontal bar using LB_SETHORIZONTALEXTENT
	SendMessage 404, dwMaxExtent, 0,, ahk_id %hLB%
}

AddListBoxItem(hLB, ByRef sItem, iItemData = 0) {
	SendMessage, 0x0180,, &sItem,, ahk_id %hLB% ;LB_ADDSTRING
	If iItemData
		SendMessage, 0x019A, ErrorLevel, iItemData,, ahk_id %hLB% ;LB_SETITEMDATA
}

GetListBoxItem(hLB, i) {
	
	;Get length of item. LB_GETTEXTLEN
	SendMessage 394, %i%, 0,, ahk_id %hLB%
	
	;Check for error
	If (ErrorLevel = 0xFFFFFFFF)
		Return ""
	
	;Prepare variable
	VarSetCapacity(sText, ErrorLevel * (1 + !!A_IsUnicode), 0)
	
	;Retrieve item. LB_GETTEXT
	SendMessage 393, %i%, &sText,, ahk_id %hLB%
	
	;Check for error
	If (ErrorLevel = 0xFFFFFFFF)
		Return ""
	
	;Done
	Return sText
}

GetListBoxItemData(hLB, i) {
	SendMessage, 0x0199, i,,, ahk_id %hLB% ;LB_GETITEMDATA
	Return ErrorLevel
}

GetLongestItem(hLB) { ;We need the listbox to get the font used
	Global sLabels0, sFuncs0, iIncludeMode
	
	;Declare variables (for clarity's sake)
	dwExtent := 0
	dwMaxExtent := 0
	hDCListBox := 0
	hFontOld := 0
	hFontNew := 0
	VarSetCapacity(lptm, A_IsUnicode ? 60 : 56)
	
	;Use GetDC to retrieve handle to the display context for the list box and store it in hDCListBox
	hDCListBox := DllCall("GetDC", "Ptr", hLB, "Ptr")
	
	;Send the list box a WM_GETFONT message to retrieve the handle to the 
	;font that the list box is using, and store this handle in hFontNew
	SendMessage 49, 0, 0,, ahk_id %hLB%
	hFontNew := ErrorLevel
	
	;Use SelectObject to select the font into the display context.
	;Retain the return value from the SelectObject call in hFontOld
	hFontOld := DllCall("SelectObject", "Ptr", hDCListBox, "Ptr", hFontNew, "Ptr")
	
	;Call GetTextMetrics to get additional information about the font being used
	;(eg. to get tmAveCharWidth's value)
	DllCall("GetTextMetrics", "Ptr", hDCListBox, "Ptr", &lptm)
	tmAveCharWidth := NumGet(lptm, 20, "UInt")
	
	;Now, we need to loop through each label/hotkey/function
	If (iIncludeMode & 0x10000000) { ;Check if we're taking from the _List elements. Split for speed
		
		Loop %sLabels0% {
			
			;For each string, the value of the extent to be used is calculated as follows:
			DllCall("GetTextExtentPoint32", "Ptr", hDCListBox, "Str", sLabels%A_Index%_List
										  , "Int", StrLen(sLabels%A_Index%_List), "Int64P", nSize)
			dwExtent := (nSize & 0xFFFFFFFF) + tmAveCharWidth
			
			;Keep if it's the highest to date
			If (dwExtent > dwMaxExtent)
				dwMaxExtent := dwExtent
		}
		
		Loop %sFuncs0% {
			
			;For each string, the value of the extent to be used is calculated as follows:
			DllCall("GetTextExtentPoint32", "Ptr", hDCListBox, "Str", sFuncs%A_Index%_List
										  , "Int", StrLen(sFuncs%A_Index%_List), "Int64P", nSize)
			dwExtent := (nSize & 0xFFFFFFFF) + tmAveCharWidth
			
			;Keep if it's the highest to date
			If (dwExtent > dwMaxExtent)
				dwMaxExtent := dwExtent
		}
	} Else {
		
		Loop %sLabels0% {
			
			;For each string, the value of the extent to be used is calculated as follows:
			DllCall("GetTextExtentPoint32", "Ptr", hDCListBox, "Str", sLabels%A_Index%
										  , "Int", StrLen(sLabels%A_Index%), "Int64P", nSize)
			dwExtent := (nSize & 0xFFFFFFFF) + tmAveCharWidth
			
			;Keep if it's the highest to date
			If (dwExtent > dwMaxExtent)
				dwMaxExtent := dwExtent
		}
		
		Loop %sFuncs0% {
			
			;For each string, the value of the extent to be used is calculated as follows:
			DllCall("GetTextExtentPoint32", "Ptr", hDCListBox, "Str", sFuncs%A_Index%
										  , "Int", StrLen(sFuncs%A_Index%), "Int64P", nSize)
			dwExtent := (nSize & 0xFFFFFFFF) + tmAveCharWidth
			
			;Keep if it's the highest to date
			If (dwExtent > dwMaxExtent)
				dwMaxExtent := dwExtent
		}
	}
	
	;After all the extents have been calculated, select the old font back into hDCListBox and then release it:
	DllCall("SelectObject", "Ptr", hDCListBox, "Ptr", hFontOld)
	DllCall("ReleaseDC", "Ptr", hLB, "Ptr", hDCListBox)
	
	;Return the longest one found
	Return dwMaxExtent
}

;Used to retrieve the number of characters that can fit in a given width
GetMaxCharacters(hLB, iWidth) { ;We need the listbox to get the font used
	
	;Declare variables (for clarity's sake)
	hDCListBox := 0
	hFontOld := 0
	hFontNew := 0
	VarSetCapacity(lptm, A_IsUnicode ? 60 : 56)
	
	;Use GetDC to retrieve handle to the display context for the list box and store it in hDCListBox
	hDCListBox := DllCall("GetDC", "Ptr", hLB, "Ptr")
	
	;Send the list box a WM_GETFONT message to retrieve the handle to the 
	;font that the list box is using, and store this handle in hFontNew
	SendMessage 49, 0, 0,, ahk_id %hLB%
	hFontNew := ErrorLevel
	
	;Use SelectObject to select the font into the display context.
	;Retain the return value from the SelectObject call in hFontOld
	hFontOld := DllCall("SelectObject", "Ptr", hDCListBox, "Ptr", hFontNew, "Ptr")
	
	;Call GetTextMetrics to get additional information about the font being used
	DllCall("GetTextMetrics", "Ptr", hDCListBox, "Ptr", &lptm)
	tmAveCharWidth := NumGet(lptm, 20, "UInt")
	
	;After all the extents have been calculated, select the old font back into hDCListBox and then release it:
	DllCall("SelectObject", "Ptr", hDCListBox, "Ptr", hFontOld)
	DllCall("ReleaseDC", "Ptr", hLB, "Ptr", hDCListBox)
	
	Return Floor(iWidth / tmAveCharWidth)
}

/********************\
 Scintilla functions |
				   */

Sci_GetText(hSci) {
	
	;Retrieve text length. SCI_GETLENGTH
	SendMessage 2006, 0, 0,, ahk_id %hSci%
	iLength := ErrorLevel + 1
	
	;0x38 = PROCESS_VM_OPERATION | PROCESS_VM_READ | PROCESS_VM_WRITE
	WinGet, pidSci, PID, ahk_id %hSci%
	If Not (hProc := DllCall("OpenProcess", "UInt", 0x38, "Int", 0, "UInt", pidSci, "Ptr"))
		Return
	
	;MEM_COMMIT=0x1000, PAGE_READWRITE=4
	If Not (ptrBuf := DllCall("VirtualAllocEx", "UInt", hProc, "UInt", 0, "UInt", iLength
											  , "UInt", 0x1000, "UInt", 4, "Ptr"))
		Return
	
	;Fill buffer with text. SCI_GETTEXT
	SendMessage 2182, iLength, ptrBuf,, ahk_id %hSci%
	
	;Read buffer
	VarSetCapacity(sText, iLength)
	DllCall("ReadProcessMemory", "Ptr", hProc, "Ptr", ptrBuf, "Ptr", &sText, "UInt", iLength, "UInt", 0)
	VarSetCapacity(sText, -1)
	
	;We're done with the remote buffer
	DllCall("VirtualFreeEx", "Ptr", hProc, "Ptr", ptrBuf, "UInt", 0, "UInt", 0x8000) ;MEM_RELEASE = 0x8000
	DllCall("CloseHandle", "Ptr", hProc)
	
	;Check if codepage conversion is necessary. SCI_GETCODEPAGE
	SendMessage, 2137, 0, 0,, ahk_id %hSci%
	If ((A_IsUnicode And ErrorLevel != 1200) Or (!A_IsUnicode And ErrorLevel != 1252))
		sText := StrGet(&sText, "CP" . ErrorLevel)
	
	Return sText
}

Sci_GetSelText(hSci) {
	
	;Get length. SCI_GETSELTEXT
	SendMessage 2161, 0, 0,, ahk_id %hSci%
	iLength := ErrorLevel
	
	;Check if it's none
	If (iLength = 1)
		Return ""
	
	;0x38 = PROCESS_VM_OPERATION | PROCESS_VM_READ | PROCESS_VM_WRITE
	WinGet, pidSci, PID, ahk_id %hSci%
	If Not (hProc := DllCall("OpenProcess", "UInt", 0x38, "Int", 0, "UInt", pidSci, "Ptr"))
		Return
	
	;MEM_COMMIT=0x1000, PAGE_READWRITE=4
	If Not (ptrBuf := DllCall("VirtualAllocEx", "UInt", hProc, "UInt", 0, "UInt", iLength
											  , "UInt", 0x1000, "UInt", 4, "Ptr"))
		Return
	
	;Fill buffer. SCI_GETSELTEXT
	SendMessage, 2161, 0, ptrBuf,, ahk_id %hSci%
	
	;Read buffer
	VarSetCapacity(sText, iLength)
	DllCall("ReadProcessMemory", "Ptr", hProc, "Ptr", ptrBuf, "Ptr", &sText, "UInt", iLength, "UInt", 0)
	VarSetCapacity(sText, -1)
	
	;We're done with the remote buffer
	DllCall("VirtualFreeEx", "Ptr", hProc, "Ptr", ptrBuf, "UInt", 0, "UInt", 0x8000) ;MEM_RELEASE = 0x8000
	DllCall("CloseHandle", "Ptr", hProc)
	
	;Get the current codepage used. SCI_GETCODEPAGE
	SendMessage, 2137, 0, 0,, ahk_id %hSci%
	If ((A_IsUnicode And ErrorLevel != 1200) Or (!A_IsUnicode And ErrorLevel != 1252))
		sText := StrGet(&sText, "CP" . ErrorLevel)
	
	Return sText
}

Sci_GetLineText(hSci, iLine) {
	
	;Retrieve line length. SCI_LINELENGTH
	SendMessage 2350, iLine, 0,, ahk_id %hSci%
	iLength := ErrorLevel + 1
	
	;0x38 = PROCESS_VM_OPERATION | PROCESS_VM_READ | PROCESS_VM_WRITE
	WinGet, pidSci, PID, ahk_id %hSci%
	If Not (hProc := DllCall("OpenProcess", "UInt", 0x38, "Int", 0, "UInt", pidSci, "Ptr"))
		Return
	
	;MEM_COMMIT=0x1000, PAGE_READWRITE=4
	If Not (ptrBuf := DllCall("VirtualAllocEx", "UInt", hProc, "UInt", 0, "UInt", iLength
											  , "UInt", 0x1000, "UInt", 4, "Ptr"))
		Return
	
	;Fill buffer with text. SCI_GETLINE
	SendMessage 2153, iLine, ptrBuf,, ahk_id %hSci%
	
	;Read buffer
	VarSetCapacity(sText, iLength)
	DllCall("ReadProcessMemory", "Ptr", hProc, "Ptr", ptrBuf, "Ptr", &sText, "UInt", iLength, "UInt", 0)
	VarSetCapacity(sText, -1)
	
	;We're done with the remote buffer
	DllCall("VirtualFreeEx", "Ptr", hProc, "Ptr", ptrBuf, "UInt", 0, "UInt", 0x8000) ;MEM_RELEASE = 0x8000
	DllCall("CloseHandle", "Ptr", hProc)
	
	;Get the current codepage used. SCI_GETCODEPAGE
	SendMessage, 2137, 0, 0,, ahk_id %hSci%
	If ((A_IsUnicode And ErrorLevel != 1200) Or (!A_IsUnicode And ErrorLevel != 1252))
		sText := StrGet(&sText, "CP" . ErrorLevel)
	
	;Trim off ending characters
	sText := RegExReplace(sText, "\R")
	
	Return sText
}

Sci_VScrollVisible(hSci) {
	
	;Get the number of lines visible. SCI_LINESONSCREEN
	SendMessage, 2370, 0, 0,, ahk_id %hSci%
	i := ErrorLevel
	
	;Get the number of lines in the document. SCI_GETLINECOUNT
	SendMessage, 2154, 0, 0,, ahk_id %hSci%
	
	;Check if there are more lines than what can be shown
	Return (ErrorLevel > i)
}

LineFromPos(pos) {
	Global
	SendMessage, 2166, pos - 1, 0,, ahk_id %hSci% ;SCI_LINEFROMPOSITION
	Return ErrorLevel + 1
}

LineFromPosEx(ByRef s, pos) {
	If Not (i := RegExMatch(s, "[\r]?[\n]", t)) ;Get break used
		Return 1 ;We're on the first line
	Else {
		n := 1, j := StrLen(t)
		While i And (i < pos)
			i := InStr(s, t, False, i + j), n++
		Return n
	}
}

CheckTextClick(x, y) {
	Local line, lineText, i
	
	;Check if we need to look for position
	If (x = -1) And (y = -1)
		SendMessage, 2008, 0, 0,, ahk_id %hSci% ;SCI_GETCURRENTPOS
	Else SendMessage, 2023, x, y,, ahk_id %hSci% ;SCI_POSITIONFROMPOINTCLOSE
	iPos := ErrorLevel, iInLinePos := iPos
	
	;Check for error
	If (iPos = 0xFFFFFFFF)
		Return False
	Else {
		
		;SCI_LINEFROMPOSITION
		SendMessage, 2166, iPos, 0,, ahk_id %hSci%
		line := ErrorLevel
		
		;SCI_POSITIONFROMLINE
		SendMessage, 2167, line, 0,, ahk_id %hSci%
		iInLinePos -= ErrorLevel
		
		;Get line text
		lineText := Sci_GetLineText(hSci, line)
		
		;Get possible function name
		clickedFunc := lineText
		
		;Trim after and before the first illegal character
		If (i := RegExMatch(clickedFunc, "[^a-zA-Z0-9#_@\$\?\[\]]", "", iInLinePos + 1))
			StringLeft, clickedFunc, clickedFunc, i - 1
		If (i := RegExMatch(StringReverse(clickedFunc), "[^a-zA-Z0-9#_@\$\?\[\]]", ""
													  , StrLen(clickedFunc) - iInLinePos + 1))
			StringTrimLeft, clickedFunc, clickedFunc, StrLen(clickedFunc) - i + 1
		
		;Get possible label name
		clickedLabel := lineText
		
		;Trim after and before the first illegal character
		If (i := RegExMatch(clickedLabel, "[^a-zA-Z0-9\Q@#$_[]?~``!%^&*+-()={}|\:;""'<>./\E]", ""
										, iInLinePos + 1))
			StringLeft, clickedLabel, clickedLabel, i - 1
		If (i := RegExMatch(StringReverse(clickedLabel), "[^a-zA-Z0-9\Q@#$_[]?~``!%^&*+-()={}|\:;""'<>./\E]", ""
													   , StrLen(clickedLabel) - iInLinePos + 1)) {
			i := StrLen(clickedLabel) - i + 1, iInLinePos -= i
			StringTrimLeft, clickedLabel, clickedLabel, i
		}
		
		;Return true if there's something to check
		Return (clickedLabel Or clickedFunc)
	}
	
	Return False
}

StringReverse(s) {
	DllCall(A_IsUnicode ? "msvcrt\_wcsrev" : "msvcrt\_strrev", "Ptr", &s, "CDecl")
	Return s
}

/***************\
 Line functions |
			  */

ShowLine(line) {
	Global hSci
	
	;Record current line before moving
	LineHistory(0, 1)
	
	;Get the first visible line. SCI_GETFIRSTVISIBLELINE
	SendMessage, 2152, 0, 0,, ahk_id %hSci%
	
	If (ErrorLevel < line - 1) {
		
		;Get the number of lines on screen. SCI_LINESONSCREEN
		SendMessage, 2370, 0, 0,, ahk_id %hSci%
		
		;Go to the line wanted + lines on screen. SCI_GOTOLINE
		SendMessage, 2024, line - 1 + ErrorLevel, 0,, ahk_id %hSci%
	}
	
	;Go to the actual line we want. SCI_GOTOLINE
	SendMessage, 2024, line - 1, 0,, ahk_id %hSci%
	
	;Record new line
	LineHistory(0, 2)
}

LineHistory(bForward, iRecordMode = 0) {
	Static
	Local t
	Global sScriptPath, hEditor, hSci, bShowing
	
	;If we're not showing, we need to find out what script we're on
	If Not bShowing {
		
		If Not (hEditor := _SciTEIsActive())
			Return
		
		;Get Scintilla control handle
		ControlGetFocus, cSci, ahk_id %hEditor%
		If InStr(cSci, "Scintilla")
			ControlGet, hSci, Hwnd,, %cSci%, ahk_id %hEditor%
		Else Return
		
		;Get the filename
		sScriptPath := _GetSciTEFile()
	}
	
	;Match file
	iCurFile := 0
	Loop %iFile0% {
		If (iFile%A_Index% = sScriptPath) {
			iCurFile := A_Index
			iCurLine := iFile%A_Index%_Cur
			Break
		}
	}
	
	;If we're working on a new file, expand array
	If Not iCurFile {
		iFile0 += 1
		iCurLine := 1
		iCurFile := iFile0
		iFile%iCurFile%_Count := 0
		iFile%iCurFile% := sScriptPath
	}
	
	;Check if we just need to record
	If (iRecordMode = 1)    ;Record current line
		LH_GetCurLine(iLines%iCurLine%_%iCurFile%)
	Else If (iRecordMode = 2) { ;Record to the next line
		
		iCurLine += 1
		LH_GetCurLine(iLines%iCurLine%_%iCurFile%)
		
		;Set as the new limit
		iFile%iCurFile%_Count := iCurLine
		
	} Else If bForward {  ;Forward
		
		;Check if it is possible
		If (iCurLine < iFile%iCurFile%_Count) {
			
			;Record the line we're on now
			LH_GetCurLine(iLines%iCurLine%_%iCurFile%)
			
			;Show the next line
			iCurLine += 1
			LH_SetCurLine(iLines%iCurLine%_%iCurFile%)
		}
	} Else {    ;Backward
		
		;Check if it is possible
		If (iCurLine > 1) {
			
			;Record the line we're on now
			LH_GetCurLine(iLines%iCurLine%_%iCurFile%)
			
			;Show the previous line
			iCurLine -= 1
			LH_SetCurLine(iLines%iCurLine%_%iCurFile%)
		}
	}
	
	iFile%iCurFile%_Cur := iCurLine
}

LH_GetCurLine(ByRef uLine) {
	Global hSci
	SendMessage, 2152, 0, 0,, ahk_id %hSci% ;SCI_GETFIRSTVISIBLELINE
	uLine := ErrorLevel
	SendMessage 2008, 0, 0,, ahk_id %hSci% ;SCI_GETCURRENTPOS
	uLine += ErrorLevel << 16
}

LH_SetCurLine(ByRef uLine) {
	Global hSci
	SendMessage, 2025, uLine >> 16, 0,, ahk_id %hSci% ;SCI_GOTOPOS
	SendMessage, 2152, 0, 0,, ahk_id %hSci% ;SCI_GETFIRSTVISIBLELINE
	SendMessage, 2168, 0, (uLine & 0xFFFF) - ErrorLevel,, ahk_id %hSci% ;SCI_LINESCROLL
}

/****************************\
 HID functions (from AHKHID) |
						   */

HID_Register(UsagePage = False, Usage = False, Handle = False, Flags = 0) {
	
	;Prep var
	VarSetCapacity(uDev, (8 + A_PtrSize), 0)
	
	;Check if hwnd needs to be null. RIDEV_REMOVE, RIDEV_EXCLUDE
	Handle := ((Flags & 0x00000001) Or (Flags & 0x00000010)) ? 0 : Handle
	
	NumPut(UsagePage, uDev, 0, "UShort")
	NumPut(Usage,     uDev, 2, "UShort")
	NumPut(Flags,     uDev, 4, "UInt")
	NumPut(Handle,    uDev, 8, "Ptr")
	
	;Call
	r := DllCall("RegisterRawInputDevices", "Ptr", &uDev, "UInt", 1, "UInt", 8 + A_PtrSize)
	
	;Check for error
	If Not r Or ErrorLevel {
		ErrorLevel := "RegisterRawInputDevices call failed."
		. "`nReturn value: " r
		. "`nErrorLevel: "   ErrorLevel
		. "`nLine: "         A_LineNumber
		. "`nLast Error: "   A_LastError
		Return True
	}
	
	Return False
}

HID_GetInputInfo(InputHandle, Flag) {
	Static uRawInput, iLastHandle := 0
	
	;Check if it's the same handle
	If (InputHandle = iLastHandle) ;We can retrieve the data without having to call again
		Return NumGet(uRawInput, Flag, HID_NumIsShort(Flag) ? (HID_NumIsSigned(Flag) ? "Short" : "UShort")
															: (HID_NumIsSigned(Flag) ? "Int"
															: (Flag = 8 ? "Ptr" : "UInt")))
	Else {    ;We need to get a fresh copy
		
		;Get raw data size                                           RID_INPUT
		r := DllCall("GetRawInputData", "Ptr", InputHandle, "UInt", 0x10000003, "Ptr", 0
									  , "UInt*", iSize, "UInt", 8 + A_PtrSize * 2)
		If (r = -1) Or ErrorLevel {
			ErrorLevel := "GetRawInputData call failed."
			. "`nReturn value: " r
			. "`nErrorLevel: "   ErrorLevel
			. "`nLine: "         A_LineNumber
			. "`nLast Error: "   A_LastError
			Return -1
		}
		
		;Prep var
		VarSetCapacity(uRawInput, iSize)
		
		;Get raw data                                                RID_INPUT
		r := DllCall("GetRawInputData", "Ptr", InputHandle, "UInt", 0x10000003, "Ptr", &uRawInput
									  , "UInt*", iSize, "UInt", 8 + A_PtrSize * 2)
		If (r = -1) Or ErrorLevel {
			ErrorLevel := "GetRawInputData call failed."
			. "`nReturn value: " r
			. "`nErrorLevel: "   ErrorLevel
			. "`nLine: "         A_LineNumber
			. "`nLast Error: "   A_LastError
			Return -1
		} Else If (r <> iSize) {
			ErrorLevel := "GetRawInputData call failed."
			. "`nReturn value: " r
			. "`nErrorLevel: "   ErrorLevel
			. "`nLine: "         A_LineNumber
			. "`nLast Error: "   A_LastError
			Return -1
		}
		
		;Keep handle reference of current uRawInput
		iLastHandle := InputHandle
		
		;Retrieve data
		Return NumGet(uRawInput, Flag, HID_NumIsShort(Flag) ? (HID_NumIsSigned(Flag) ? "Short" : "UShort")
															: (HID_NumIsSigned(Flag) ? "Int"
															: (Flag = 8 ? "Ptr" : "UInt")))
	}
}

;Internal use only
HID_NumIsShort(ByRef Flag) {
	If (Flag & 0x0100) {
		Flag ^= 0x0100 ;Remove it
		Return True
	} Return False
}

;Internal use only
HID_NumIsSigned(ByRef Flag) {
	If (Flag & 0x1000) {
		Flag ^= 0x1000 ;Remove it
		Return True
	} Return False
}

/************************\
 Miscellaneous functions |
					   */

;EmptyMem() by heresy
;http://www.autohotkey.com/forum/viewtopic.php?t=32876
EmptyMem(PID="AHK Rocks"){
	pid:=(pid="AHK Rocks") ? DllCall("GetCurrentProcessId") : pid
	h:=DllCall("OpenProcess", "UInt", 0x001F0FFF, "Int", 0, "Int", pid, "Ptr")
	DllCall("SetProcessWorkingSetSize", "Ptr", h, "Int", -1, "Int", -1)
	DllCall("CloseHandle", "Ptr", h)
}

;Based on Lazslo's CRC32() and MCode() functions
;http://www.autohotkey.com/forum/viewtopic.php?p=158999#158999
GetFileCRC32(path = False) {
	Static CRC32, CRC32_Init, CRC32LookupTable

	;Check if we're initiating
	If Not path Or Not CRC32 {
		
		;Prep MCode for CRC32_Init()
		If (A_PtrSize = 8)
			hex := "4533C0418BC0BA080000000F1F440000A8017409D1E8352083B8EDEB02D1E848FFCA75EC41FFC089014883C10441"
				 . "81F80001000072CDF3C3"
		Else hex := "8B54240433C98BC1D1E8F6C1017405352083B8EDA8017409D1E8352083B8EDEB02D1E8A8017409D1E8352083B8ED"
				 . "EB02D1E8A8017409D1E8352083B8EDEB02D1E8A8017409D1E8352083B8EDEB02D1E8A8017409D1E8352083B8EDEB0"
				 . "2D1E8A8017409D1E8352083B8EDEB02D1E8A8017409D1E8352083B8EDEB02D1E889048A4181F9000100000F8279FF"
				 . "FFFFC3"
		
		VarSetCapacity(CRC32_Init, StrLen(hex) // 2)
		Loop % StrLen(hex) // 2
			NumPut("0x" . SubStr(hex, 2 * A_Index - 1, 2), CRC32_Init, A_Index - 1, "UChar")
		
		;Prep MCode for CRC32()
		If (A_PtrSize = 8)
			hex := "85D2742D448BD2660F1F8400000000000FB611418BC048FFC14833D00FB6C2418BD0458B0481C1EA084433C249FF"
				 . "CA75DF41F7D0418BC0C3"
		Else hex := "8B5424088B44240C33C985D2742C53568B742418578B7C24108DA424000000000FB61C3933D881E3FF000000C1E8"
				  . "0833049E413BCA72E95F5E5BF7D0C3"
		
		VarSetCapacity(CRC32, StrLen(hex) // 2)
		Loop % StrLen(hex) // 2
			NumPut("0x" . SubStr(hex, 2 * A_Index - 1, 2), CRC32, A_Index - 1, "UChar")
		
		DllCall("VirtualProtect", "Ptr", &CRC32, "Ptr", VarSetCapacity(CRC32), "UInt", 0x40, "UInt*", 0)
		
		VarSetCapacity(CRC32LookupTable, 256 * 4)
		DllCall(&CRC32_Init, "Ptr", &CRC32LookupTable, "CDecl")
	}
	
	If path {
		FileGetSize, Bytes, %path%
		FileRead, Buffer, %path%
		Return DllCall(&CRC32, "Ptr", &Buffer, "UInt", Bytes, "Int", -1, "Ptr", &CRC32LookupTable, "CDecl UInt")
	}
}
