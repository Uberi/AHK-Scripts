/*
 **************************************** CLIP PALETTE ****************************************
 * Author : r0k                         version : 1.0 b1                     requires : AHK_L *
 *                                                                                            *
 *---------------------------------------- Description ---------------------------------------*
 * This is a "Clipboard palette" for use with SciTE. It will store often used custom keywords *
 * like variable names, labels, functions... so you can easily access them.                   *
 *                                                                                            *
 *-------------------------------------------- Use -------------------------------------------*
 * # Call the palette with alt-space while SciTE has focus. The palette will show where the   *
 *   caret is (unless this would cause the palette to be off-screen).                         *
 * # Start typing any keyword, if the string typed matches any stored item, they will be      *
 *   displayed in the list below the edit box.                                                *
 * # If the word you are typing is not in the list, just finish typing it and press return.   *
 *   The new word will be inserted in SciTE at the Caret position and added to the palette    *
 *   for future use.                                                                          *
 * # At any time, use the down arrow to move to the list. You can navigate the list with up   *
 *   and down arrow. You can also select an Item with your mouse. When in the list, press     *
 *   return and the currently highlighted item will be copied to SciTE.                       *
 * # Escape will hide the palette without copying anything to SciTE.                          *
 * # A Palette Collection is a .pal file stored inside the SciTE folder. A Collection can     *
 *   contain an unlimited number of Palettes. You can switch between palettes with left and   *
 *   right arrows while the palette window is visible.                                        *
 * # When in the palette window, pressing alt-space again shows the palette editor window. In *
 *   the palette editor, you can rename your palettes, add new palettes to you collection or  *
 *   even create another collection. You can also edit the items list directly in it's raw    *
 *   pipe delimited format to remove items or copy-past many items at once. Use save palette  *
 *   if you manually modified a palette.                                                      *
 *                                                                                            *
 *--------------------------------------- Known Issues ---------------------------------------*
 * When in the palette editor, dialog boxes don't respond correctly to return. If you press   *
 * return rather than click OK, the editor and the dialog box will hide below the SciTE       *
 * window and the palette window won't answer correctly untill you actually click OK          *
 **********************************************************************************************
 */
 
;---------------------------------------------------------------
; global _Log := "Clip_Palette.log" ; Uncomment to allow logging
;---------------------------------------------------------------

; #NoTrayIcon
#InstallKeybdHook

SetKeyDelay, -1, 0
CoordMode, Caret, Screen
OnExit, _On_exit
_Tmp_Put := A_MyDocuments "\AutoHotKey\SciTE\Palettes"
IfNotExist, %A_MyDocuments%\AutoHotKey\SciTE\Palettes\Default.pal
{ ; Create the palette folder and default palette file
	FileCreateDir, %_Tmp_Put%
	SetWorkingDir, %_Tmp_Put%
	fn_New_Palette("Default")
}
; Initialize important variables (better safe than sorry)
SetWorkingDir, %_Tmp_Put%
_PaletteFile := "Default.pal"
_Palette# := 0
_Clip := ""
_Title := ""
global Palette_Name := Array()
global Palette_Clip := Array()

; Build the GUIs (don't show them yet)
Gui, Palette_:New, +AlwaysOnTop +ToolWindow -SysMenu -Caption +Resize +MinSize +MaxSize hwnd_ID_Palette
Gui, Palette_:Margin, 2, 2
Gui, Palette_:Font, s9 bold
Gui, Palette_:Add, Text, w240 r1 +Center v_Title gCtrl_Title
Gui, Palette_:Font, s9 norm
Gui, Palette_:Add, Edit, w240 r1 v_Edit gCtrl_Edit
Gui, Palette_:add, ListBox, v_List w240 h360 y+2 gCtrl_List +Sort

Gui, Editor_:New, +ToolWindow hwnd_ID_Editor
Gui, Editor_:Margin,0,0
; Script menu construction
Menu,Menu_Script,Add,Close Editor,Menu_Exit
Menu,Menu_Script,Add,Reload Script,_Start
Menu,Menu_Script,Add,Load Palette Collection,Menu_LoadPalFile
Menu,Menu_Script,Add,New Palette Collection,Menu_NewPalFile
Menu,Menu_Script,Add,Quit Script,Menu_Quit
	Menu,Palette_Menu,Add,&Script,:Menu_Script ; Add script menu to main menu-bar
; Palette menu construction
Menu,Menu_Palette,Add,New Palette	Ctrl+N,Menu_NewPal
Menu,Menu_Palette,Add,Save current Palette	Ctrl+S,Menu_SavePal
Menu,Menu_Palette,Add,Rename current Palette	Ctrl+R,Menu_RenPal
	Menu,Palette_Menu,Add,&Palette,:Menu_Palette ; Add palette menu to main menu-bar
Gui, Editor_:Menu, Palette_Menu
Gui, Editor_:Add, StatusBar
Gui, Editor_:Add, Edit, w460 h380 v_Clip

gosub, _Start

WinWait, ahk_class SciTEWindow ; Main thread will wait for SciTE to be open if it was not.
WinWaitClose ; Main thread will wait for SciTE to close then automatically exit.
ExitApp

_Start: ; Initialize arrays and palette
fn_Process_File("r", _PaletteFile, _Palette#)
_Palette# := _Palette#<1 ? 1 : _Palette# ; If palette n° was not retrieved, use 1 as palette n°
fn_Palette_Rotate(_Palette#,_Clip,_Title)
Return

Menu_Exit:
	Gui, Editor_:Cancel
Return

Menu_LoadPalFile:
	Gui Editor_:+OwnDialogs
	fn_Palette_Rotate(_Palette#,_Clip,_Title) ; Rotate with no change saves _Clip and _Title to the Array
	fn_Process_File("w",_PaletteFile,_Palette#) ; Save current file
	FileSelectFile, _PaletteFile , 1, %A_WorkingDir%, Select a Palette collection to load, Palette File (*.pal)
	if _PaletteFile
		gosub, _Start
	fn_GUI_Update()
Return

Menu_NewPalFile:
	Gui Editor_:+OwnDialogs
	fn_Palette_Rotate(_Palette#,_Clip,_Title) ; Rotate with no change saves _Clip and _Title to the Array
	fn_Process_File("w",_PaletteFile,_Palette#) ; Save current file
	InputBox, _NewPaletteName, Palette name, Choose name of the new collection.,,320,150,,,,,New Palette
	_PaletteFile := _NewPaletteName ".pal"
	fn_New_Palette(_NewPaletteName)
	gosub, _Start
	fn_GUI_Update()
return

Menu_Quit:
	ExitApp
Return

Menu_NewPal:
	fn_DMsg("*** New palette control was called ***",1)
	Gui Editor_:+OwnDialogs
	fn_Palette_Rotate(_Palette#,_Clip,_Title) ; Rotate with no change saves _Clip and _Title to the Array. Save current palette.
	InputBox, _Title, Palette name, Choose a name for the new palette.,, 300, 150,,,,,New Palette
	_Palette# := Palette_Name.MaxIndex()+1 ; set the active palette after the last existing palette.
	_Clip := "|" ; Put opening pipe of the new palette into _Clip
	fn_GUI_Update()
	fn_Palette_Rotate(_Palette#,_Clip,_Title) ; Save the new palette to the new position
	fn_Process_File("w",_PaletteFile,_Palette#) ; Save to file
Return

Menu_SavePal:
	fn_DMsg("*** Save palette was called ***",1)
	Gui, Editor_:Submit , NoHide ; Save gVar content
	fn_Palette_Rotate(_Palette#,_Clip,_Title) ; Rotate with no change saves _Clip and _Title to the Array
	fn_Process_File("w",_PaletteFile,_Palette#) ; Save to file
Return

Menu_RenPal:
	fn_DMsg("*** Rename palette was called ***",1)
	Gui Editor_:+OwnDialogs
	InputBox, _Title, Palette name, Choose the new name of this palette.,,320,150,,,,,%_Title%
	fn_Palette_Rotate(_Palette#,_Clip,_Title) ; Rotate with no change saves _Clip and _Title to the Array
	fn_GUI_Update()
Return

; ******************* GUI CONTROLS *********************

Ctrl_Edit:
{ ; This control will perform a search in the list each time a character is typed into the edit box
	ControlGetFocus, _ActiveCtrl , Palette
	IfNotInString, _ActiveCtrl, Edit, return ; if another control caused this gLabel to trigger, do nothing
	Gui, Palette_:Submit , NoHide
	if !_Edit
	  {	; If empty, put all Items back into the list
		GuiControl, Palette_:, _List, %_Clip%
		return
	  }
	_Tmp_Put := "|" ; need one pipe at the start to replace the list rather than add to
	Loop, Parse, _Clip , | ; Will look for entries matching the typed characters and copy them to a temporary var.
		IfInString, A_LoopField, %_Edit%
		  { ; Checks for the edit string in the Item being looked at
			_Tmp_Put .= A_LoopField
			_Tmp_Put .= "|"
		  } ; End of if and end of loop too (loop only contains if)
	if (StrLen(_Tmp_Put) >1) ; Omit last pipe unless there is only one pipe (means no Items)
		_Tmp_Put := SubStr(_Tmp_Put,1,StrLen(_Tmp_Put)-1)
	GuiControl, Palette_:, _List, %_Tmp_Put%
	_Tmp_Put := "" ; restet temp var, saves memory
}
return

Ctrl_List:
	Gui, Palette_:Submit , NoHide
	GuiControl, Palette_:, _Edit, %_List%
return

Ctrl_Title:
return

Palette_GuiEscape:
	Gui, Palette_:Cancel
return

Editor_GuiEscape:
	Gui, Editor_:Cancel
return

Editor_GuiClose:
	Gui, Editor_:Cancel
return

; ***************** FUNCTIONS ****************

fn_Process_File(prm_Mode,prm_File,ByRef prm_Palette) { ; byref returns palette n° in read mode
	fn_DMsg("Processing " prm_File " in " prm_Mode " mode",1)
	_File := FileOpen(prm_File,prm_Mode)
	_Count := 0
	if (prm_Mode="r") { ; this is read mode
		while !_File.AtEOF { ; check we are not at the end of file
			_Line := _File.ReadLine()
			fn_DMsg("Read line : " _Line)
			if (substr(_Line,1,2)="//") ; this is a coment line (//)
				continue
			if (substr(_Line,1,2)="#C") { ; #C serves to store the last used palette n°
				_Palette := substr(_Line,3)
				continue
			}
			++_Count ; Main part. Read the line and store palette name/content in the arrays
			_Line := RTrim(_Line, "`n`r")
			_SepPos := InStr(_Line,"|")
			fn_DMsg("Palette n° : " _Count)
			fn_DMsg("Palette name : " substr(_Line, 1, _SepPos-1))
			fn_DMsg("Palette content : " substr(_Line, _SepPos))
			Palette_Name[_Count] := substr(_Line, 1, _SepPos-1)
			Palette_Clip[_Count] := substr(_Line, _SepPos)
		}
	} else if (prm_Mode="w") { ; this is write mode. It will replace the previous file
		_File.WriteLine("//This file is auto-generated. Do not change it!//")
		_File.WriteLine("#C" prm_Palette)
		while _Count < Palette_Name.MaxIndex() { 
			++_Count
			_Line := Palette_Name[_Count]
			_Line .= Palette_Clip[_Count]
			_Count < Palette_Name.MaxIndex() ? _File.WriteLine(_Line) : _File.Write(_Line) ; Last line must not have linefeed
			fn_DMsg("Written line : " _Count RTrim(_Line, "`n`r"))
		}
	}
	_File.Close
return
}

fn_Palette_Rotate(ByRef prm_Palette, ByRef prm_Clip, ByRef prm_Name, prm_Change=0) { ; Palette rotation
	fn_DMsg("Palette rotation called." ,1)
	fn_DMsg(prm_Palette " , " prm_Name " , " prm_Clip " , " prm_Change)
	if prm_Name
	{ ; if prm_Name is not empty, palette was loaded and might have been changed by the user. Save it.
		Palette_Clip[prm_Palette] := prm_Clip
		Palette_Name[prm_Palette] := prm_Name
	}
	prm_Palette := prm_Palette + prm_Change
	prm_Clip := Palette_Clip[prm_Palette]
	prm_Name := Palette_Name[prm_Palette]
	fn_DMsg("Rotation complete : " prm_Palette " , " prm_Name " , " prm_Clip)
}

fn_Limit(prm_X,prm_min,prm_max) { ; Will return X if between min and max, else will return min or max
	If prm_X between %prm_min% and %prm_max%
		_X := prm_X
	IfLess, prm_X, %prm_min%
		_X := prm_min
	IfGreater, prm_X, %prm_max%
		_X := prm_max
return _X
}

fn_GUI_Update() { ; Updates all GUIs
	global ; assume global mode (no local variables are needed)
	fn_DMsg("Updating GUI state.",1)
	fn_DMsg("Palette : " _Title " , " _Clip)
	GuiControl, Palette_:, _Title, %_Title% ; Put palette name into the "title" box
	GuiControl, Palette_:, _List, %_Clip% ; Put palette content into list
	GuiControl, Palette_:, _Edit, ; Empty edit box
	GuiControl, Editor_:, _Clip, %_Clip% ; Put palette content into edit box
	Gui, Editor_:Default ; Status bar commands can only operate on default window
	SB_SetText(" Palette : " _Palette# "/" Palette_Name.MaxIndex() "`t" _Title "`tFile : " _PaletteFile " ")
	Gui, Palette_:Default
}

fn_New_Palette(prm_Name) { ; Creates a new palette collection file
	_File := FileOpen(prm_Name ".pal","w")
	_File.WriteLine("//This file is auto-generated. Do not change it!//")
	_File.WriteLine("#C1")
	_File.WriteLine("Sample|This|is|a|sample|palette")
	_File.Close	
}

fn_DMsg(Prm_Message,Prm_NewBlock=0) { ; Debug Messages. Set log to "" to disable logging.
if !_Log
	return
if (Prm_NewBlock > 0) {
	FormatTime, Loc_Time ,,yyyy'/'MM'/'dd' at 'HH':'mm':'ss' : '
	FileAppend, `n , %_Log%
	FileAppend, %Loc_Time%`n, %_Log%
  }
  FileAppend, %Prm_Message%`n, %_Log%
}

; ************* HOTKEYS *************

#IfWinActive ahk_class SciTEWindow ; Hotkeys enabled when SciTE is the active window.
!Space::
{ ; alt-space will show the palette when focus is on an SciTE window.
	fn_GUI_Update()
	_X_Carret := A_CaretX - 10
	_Y_Carret := A_CaretY + 20
	_x := fn_Limit(_X_Carret, 10, A_ScreenWidth - 260)
	_y := fn_Limit(_Y_Carret, 10, A_ScreenHeight - 420)
	Gui, Palette_:Show, x%_x% y%_y% , Palette ; Show at caret position
	ControlFocus, Edit1, Palette ; In case focus was not on the correct control
}
return

#IfWinActive Palette ; Hotkeys enabled when the Palette window is active.
!Space::
{ ; alt-space when palette is active will show the editor
	fn_GUI_Update()
	Gui, Editor_:Show, , Editor
	Gui, Palette_:Cancel
	WinWaitClose, Editor
	Gui, Palette_:Show
}
return
Enter::
{ ; i wasn't able to capture return any other way so i made a context hotkey
Gui, Palette_:Submit , NoHide
ControlGetFocus, _ActiveCtrl , Palette
IfInString, _ActiveCtrl, Edit
  { ; If last active control is Edit, copy it's content to SciTE and add it to the list.
	if (instr(_Clip,"|" _Edit)=0) { ; Don't add to the list if it's already in!
		_Clip .= "|"
		_Clip .= _Edit
	   }
	ControlSend,, %_Edit%, ahk_class SciTEWindow
  }
IfInString, _ActiveCtrl, List ; If last active control is List, copy the selected item to SciTE.
	ControlSend,, %_List%, ahk_class SciTEWindow
Gui, Palette_:Cancel
WinActivate, ahk_class SciTEWindow ; Make sure SciTE is frontmost again
}
return
Down:: ; if edit is currently focused, activate list then send down. Allows one key switch and select first item
	ControlGetFocus, _ActiveCtrl , Palette
	IfInString, _ActiveCtrl, Edit, ControlFocus, ListBox1, Palette
	SendInput, {down}
return
Left:: ; activate the previous palette. If first palette was active, cycle back to the last
	_Palette# > 1 ? fn_Palette_Rotate(_Palette#,_Clip,_Title,-1)
				  : fn_Palette_Rotate(_Palette#,_Clip,_Title,(Palette_Name.MaxIndex()-1))
	fn_GUI_Update()
return
Right:: ; activate the next palette. If last palette was active, cycle back to the first
	_Palette# < Palette_Name.MaxIndex() ? fn_Palette_Rotate(_Palette#,_Clip,_Title,1)
				  : fn_Palette_Rotate(_Palette#,_Clip,_Title,-(Palette_Name.MaxIndex()-1))
	fn_GUI_Update()
return

; ********************* EXIT SUBROUTINE *******************

_On_exit:
fn_Process_File("w",_PaletteFile,_Palette#)
ExitApp
return