;===================================================
;== AHK Live-Manual - Lucid_Method =================
;===================================================

	AHKCommand = ControlGet
	Command_Version = 1.0
	Manual_Credit = Frankie
	Manual_Updated = 01-19-2011
	Manual_Tags = Controls|

;===============================================================
; Startup Actions
;===============================================================	
	LiveManual_Startup_Actions:
{	
	GoSub LiveManual_Setup
	GoSub WinSpyInit

	TestAHK = %A_WorkingDir%\Lib\TestAHK.ahk
	FileDelete %TestAHK%
}	

;===============================================================
; Build GUI
;===============================================================

	LiveManual_Build_GuiControl:
{

#NoEnv
#Persistent
#SingleInstance force

Syntax = ControlGet, OutputVar, Cmd [, Value, Control, WinTitle, WinText, ExcludeTitle, ExcludeText] 
Gui, Add, Button, x16 y10 w500 h30 vButton1 hwnd_Manual gLiveManual_AHK_Manual, %Syntax%
	ILButton(_Manual, Manual_Ico , 16, 16, "Left")
;------------------------------
; Static Gui
;------------------------------
Gui, Add, Text, x10 y50 w60 Right vStatic1, Window:
Gui, Add, Edit, x75 y50 w100 vWindow gSubmitCode
Gui, Add, DropDownList, x200 y50 w150 vWindowType gSubmitCode, Title||ahk_class

Gui, Add, Text, x10 y80 w60 Right vStatic2, ClassNN: 
Gui, Add, Edit, x75 y80 w100 vClassNN gSubmitCode
Gui, Add, Button, x200 y80 w150 gWinSpy hwnd_WinSpy, Launch WinSpy
	ILButton(_WinSpy, Info_ICO, 16, 16, "Left")
	
Gui, Add, Text, x10 y110 w60 Right vStatic3, Data Type:
Gui, Add, DropDownList, x75 y110 w150 vType gChangeType, % "Position|Focus|Text||List|Checked|Enabled|" ;%
. "Visible|Tab|FindString|Choice|LineCount|CurrentLine|CurrentCol|Line|Selected|Style|ExStyle|Hwnd"

;------------------------------
; Dynamic Hide/Show Gui
;------------------------------

; Position Gui Controls
Gui, Add, Text, x10 y140 w60 Right vDPos1, OutputVars:
Gui, Add, Edit, x75 y140 w50 vDPos2 gSubmitCode, X
Gui, Add, Edit, x135 y140 w50 vDPos3 gSubmitCode, Y
Gui, Add, Edit, x195 y140 w50 vDPos4 gSubmitCode, Width
Gui, Add, Edit, x255 y140 w50 vDPos5 gSubmitCode, Height

; Single output var controls
; Used by: Text, Focus
Gui, Add, Text, x10 y140 w60 Right vDTxt1, OutputVar:
Gui, Add, Edit, x75 y140 w100 vDTxt2 gSubmitCode, Output

; List Options
Gui, Add, Text, x10 y140 w60 Right vDList1, OutputVar:
Gui, Add, Edit, x75 y140 w100 vDList2 gSubmitCode, ListOutput
Gui, Add, DropDownList, x200 y140 w150 vDList3 gSubmitCode, Selected||Focused|Col4|Count|Count Selected|Count Focused|Count Col

; Line, N Options
Gui, Add, Text, x10 y140 w60 Right vDLine1, OutputVar:
Gui, Add, Edit, x75 y140 w100 vDLine2 gSubmitCode, OutputVar
Gui, Add, Text, x200 y140 w60 Right vDLine3 gSubmitCode, #
Gui, Add, Edit, x263 y140 w50 Number vDLine4 gSubmitCode, 1
Gui, Add, UpDown, vDLine5

; FindString
Gui, Add, Text, x10 y140 w60 Right vDFS1, OutputVar:
Gui, Add, Edit, x75 y140 w100 vDFS2 gSubmitCode, StringVar
Gui, Add, Text, x200 y140 w100 Right vDFS3 gSubmitCode, Search String:
Gui, Add, Edit, x305 y140 w50 vDFS4 gSubmitCode



;------------------------------
; Static Gui from Lucid_Method
;------------------------------
Gui, Add, Edit, x26 y180 w440 h20 vCodeDisplay , ;Code Display
Gui, Add, Button, x26 y200 w440 h23 hwnd_Clipboard vButton2 gLiveManual_CopyCode, Copy Code
	ILButton(_Clipboard, Clipboard_Ico , 16, 16, "Left")

Gui, Add, Button, x276 y230 w100 h30 vButton4 hwnd_Reload gLiveManual_Reload, Reload
	ILButton(_Reload, Refresh_Ico , 16, 16, "Left")
Gui, Add, Button, x376 y230 w90 h30 vButton5 hwnd_Exit gLiveManual_Exit, Exit
	ILButton(_Exit, Exit_Ico , 22, 22)
Gui, +Resize
GoSub LiveManual_Build_MenuBar
Gui, Show, xCenter yCenter h300 w525, %AHKCommand% (AHK Live-Manual)
GoSub ChangeType
Return
}

;===============================================================
; Submit Code:
; Translates variables into code and displays it to the user
;===============================================================
	SubmitCode:
{
Gui, Submit, NoHide
If (WindowType == "ahk_class")
	Window := "ahk_class " . Window

If (Text_Status)
	CodeLine = ControlGetText, %DTxt2%, %ClassNN%, %Window%
else If (Position_Status)
	CodeLine = ControlGetPos, %DPos2%, %DPos3%, %DPos4%, %DPos5%, %ClassNN%, %Window%
else if (Focus_Status)
	CodeLine = ControlGetFocus, %DTxt2%, %Window%
else if (List_Status)
	CodeLine = ControlGet, %DList2%, List, %DList3%, %ClassNN%, %Window%
else if (Checked_Status)
	CodeLine = ControlGet, %DTxt2%, Checked,, %ClassNN%, %Window% 
else if (Line_Status)
	CodeLine = ControlGet, %DLine2%, Line, %DLine5%, %ClassNN%, %Window%
else if	(FindString_Status)
	CodeLine = ControlGet, %DFS2%, FindString, %DFS4%, %ClassNN%, %Window%
else
	CodeLine = ControlGet, %DTxt2%, %Type%, %ClassNN%, %Window% ; Default - No "Value" parameter
StringReplace, CodeLine, CodeLine, % "  " ; Remove double spaces, this is caused by the List sub-command's options ;%
StringReplace, CodeLine, CodeLine, % " ,", % ",", All ; Remove spaces in blank variables
CodeLine := RegExReplace(CodeLine, ",+$") ; Remove trailing commas
GuiControl,,CodeDisplay, %CodeLine%
return
}

;===============================================================
; ChangeType:
; Called whenever the Type dropdown is changed
; This changes the Gui for the chosen command/sub-command
;===============================================================
	ChangeType:
{
Gui, Submit, NoHide
; Store bool values here based on the drop down
; (This could be rewritten shorter with a loop)
Position_Status := (Type = "Position")
Text_Status := (Type = "Text")
Focus_Status := (Type = "Focus")
List_Status := (Type = "List")
Checked_Status := (Type = "Checked")
Enabled_Status := (Type = "Enabled")
Visible_Status := (Type = "Visible")
Tab_Status := (Type = "Tab")
FindString_Status := (Type = "FindString")
Choice_Status := (Type = "Choice")
LineCount_Status := (Type = "LineCount")
CurrentLine_Status := (Type = "CurrentLine")
CurrentCol_Status := (Type = "CurrentCol")
Line_Status := (Type = "Line")
Selected_Status := (Type = "Selected")
Style_Status := (Type = "Style")
ExStyle_Status := (Type = "ExStyle")
Hwnd_Status := (Type = "Hwnd")

OutputVar_Status := (Text_Status || Focus_Status || Checked_Status || Enabled_Status
|| Visible_Status || Tab_Status || Choice_Status ||  LineCount_Status || CurrentLine_Status
|| CurrentCol_Status || Selected_Status || Style_Status || ExStyle_Status || Hwnd_Status)

Loop, 5
	GuiControl, Show%Position_Status%, DPos%A_Index%
Loop, 2
	GuiControl, Show%OutputVar_Status%, DTxt%A_Index%
Loop, 3
	GuiControl, Show%List_Status%, DList%A_Index%
Loop, 5
	GuiControl, Show%Line_Status%, DLine%A_Index%
Loop, 4
	GuiControl, Show%FindString_Status%, DFS%A_Index%
GuiControl, Disable%Focus_Status%, ClassNN
GoSub, SubmitCode
return
}

	WinSpyInit:
{
;Based off: Determine AHK Manual Path (by Rajat)
if A_AhkPath
	SplitPath, A_AhkPath,, ahk_dir
else IfExist ..\..\AutoHotkey.chm
	ahk_dir = ..\..
else IfExist %A_ProgramFiles%\AutoHotkey\AU3_Spy.exe
	ahk_dir = %A_ProgramFiles%\AutoHotkey
else
	MsgBox Could not find the AutoHotkey folder.
return
}

	WinSpy:
{
Run, %ahk_dir%\AU3_Spy.exe
return
}

;===============================================================
; INCLUDE CODE
;===============================================================
	#Include Lib\LiveManual_Include.ahk
;===============================================================
