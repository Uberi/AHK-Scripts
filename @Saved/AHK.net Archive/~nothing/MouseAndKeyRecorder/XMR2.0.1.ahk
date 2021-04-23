
KeyList :=
(Join
"Browser_Back|Browser_Forward|Browser_Refresh|Browser_Stop|Browser_Search|Browser_Favorites|Browser_Home|Volume_Mute|Volume_Down|Volume_Up|Media_Next|Media_Prev|Media_Stop|Media_Play_Pause|Launch_Mail|Launch_Media|Launch_App1|Launch_App2|
Esc|F1|F2|F3|F4|F5|F6|F7|F8|F9|F10|F11|F12|PrintScreen|Pause|Ins|Del|
``|1|2|3|4|5|6|7|8|9|0|-|=|Backspace|Home|
Tab|q|w|e|r|t|y|u|i|o|p|[|]|\|PgUp|
a|s|d|f|g|h|j|k|l|;|'|Enter|PgDn|
z|x|c|v|b|n|m|,|.|/|End|
Space|AppsKey|
ScrollLock|CapsLock|NumLock|
Up|Down|Left|Right|
Numpad0|NumpadIns|
Numpad1|NumpadEnd|
Numpad2|NumpadDown|
Numpad3|NumpadPgDn|
Numpad4|NumpadLeft|
Numpad5|NumpadClear|
Numpad6|NumpadRight|
Numpad7|NumpadHome|
Numpad8|NumpadUp|
Numpad9|NumpadPgUp|
NumpadDot|NumpadDel|
NumpadDiv|NumpadMult|
NumpadAdd|NumpadSub|
NumpadEnter|
WheelUp|WheelDown|
LControl|RControl|LShift|RShift|LAlt|RAlt|LWin|RWin"
)
ListControlMove := "Group1|XPos|UD1|YPos|UD2|GetPos"
ListControlClick := ListControlMove "|Group2|ButtonClick|Group3|StateClick|CurrentClick"
ListControlKey := "Group4|Group5|Group6|SendKey|SendString|KeyName|KeyState|StringText"
ListControlWin := "Group1|XPos|UD1|YPos|UD2|GetWin|Group7|WidthSize|UD3|HeightSize|UD4|Group8|WinTitle|Group9|WinClass"
ListControlDelay := "Group10|Delayms|UD5"
SetBatchLines,-1
CoordMode,Mouse,Screen
SetMouseDelay,-1
SetWinDelay, 0
DetectHiddenWindows, On
SetControlDelay, -1
#MaxThreadsBuffer On
#InstallMouseHook
#MaxHotkeysPerInterval 999999999
#HotkeyInterval 9999999999
SendMode,Event
SetKeyDelay, -1 
Send {Shift}
TitleName := "XMR v2.1 by ___x@___"
Menu,Tray,Add,Start/Stop Recording,Record
Menu,Tray,Add,Start/Stop Play Record,PlayRecord
Menu,Tray,Add,Exit,GuiClose
Menu,Tray,Nostandard
Menu,Tray,Default,Start/Stop Recording
Menu,Tray,Click,1
Gui, Add, ListView, x202 y70 w500 h280 Grid +NoSortHdr, Command|Information
Gui, Add, GroupBox, x12 y0 w180 h70 , Settings
Gui, Add, Checkbox, x32 y160 w140 h30 +Checked vWinInfo gWinInfo, Window Titles && Classes
Gui, Add, Checkbox, x52 y190 w60 h20 vWPos, Positions
Gui, Add, Checkbox, x122 y190 w50 h20 vWSize, Sizes
Gui, Add, Checkbox, x32 y230 w130 h20 +Checked vMouseMovemnets, Mouse Movements
Gui, Add, Checkbox, x32 y210 w130 h20 +Checked vClicks, Mouse Clicks
Gui, Add, Checkbox, x32 y250 w130 h20 +Checked vKeyboardActions, Keyboard Actions
Gui, Add, Checkbox, x32 y270 w90 h20 +Checked vDelayTime gDelayTime, Time Intervals
Gui, Add, Edit, x132 y270 w52 h20 +number vDefaultDelay +Disabled, 50
Gui, Add, UpDown, x152 y270 w18 h20 , 50
Gui, Add, GroupBox, x12 y140 w180 h160 , Record options
Gui, Add, Text, x22 y20 w60 h20 , CoordMode
Gui, Add, Text, x22 y40 w60 h20 , BlockInput
Gui, Add, DropDownList, x82 y20 w90 h21 +R7 vCoordType, Screen||Window
Gui, Add, DropDownList, x82 y40 w90 h21 +R7 vBlockInputType, On|Off|MouseMove||
Gui, Add, GroupBox, x12 y70 w180 h70 , Hotkeys
Gui, Add, Text, x22 y90 w30 h20 , Rec
Gui, Add, Text, x22 y110 w30 h20 , Play
Gui, Add, DropDownList, x52 y90 w100 h20 vRecordKey +R7 gSaveHotKey, F1|F2|F3|F4|F5|F6|F7||F8|F9|F10|F11|F12
Gui, Add, DropDownList, x52 y110 w100 h20 vPlayKey +R7 gSaveHotKey, F1|F2|F3|F4|F5|F6|F7|F8||F9|F10|F11|F12
Gui, Add, GroupBox, x202 y0 w500 h60 , Control
Gui, Add, Button, x222 y20 w70 h30 gRecord, Record
Gui, Add, Button, x292 y20 w70 h30 gPlayRecord, Play
Gui, Add, Button, x402 y20 w70 h30 , nothing
Gui, Add, Button, x472 y20 w70 h30 gAHKSave, >>AHK
Gui, Add, Button, x542 y20 w70 h30 gSave, >>XMR
Gui, Add, Button, x612 y20 w70 h30 gLoad, Load...
Gui, Add, GroupBox, x12 y300 w180 h50 , Play Options
Gui, Add, Edit, x82 y320 w104 h20 vRepeatTime +number, 
Gui, Add, Updown, x164 y320 w18 h20 Range0-999999999, 0
Gui, Add, Text, x22 y320 w60 h20 , Repeat
Gui, Add, Button, x722 y20 w70 h30 gInsertInfo, Insert
Gui, Add, Button, x792 y20 w70 h30 gDelInfo, Delete
Gui, Add, Button, x862 y20 w70 h30 gDelAll, Delete All
Gui, Add, DropDownList, x752 y90 w140 h21 +R7 gCommandMode vCommandMode, Move Mouse||Click|KeyBoard|Window|Delay
Gui, Add, GroupBox, x712 y60 w230 h290 , Command
Gui, Add, GroupBox, x712 y120 w230 h50 vGroup1, Position (X - Y)
Gui, Add, Edit, x722 y140 w90 h20 vXPos, x
Gui, Add, Updown, x164 y320 w18 h20 Range0-999999999 vUD1, 0
Gui, Add, Edit, x812 y140 w90 h20 vYPos, y
Gui, Add, Updown, x164 y320 w18 h20 Range0-999999999 vUD2, 0
Gui, Add, Text, x910 y140 w20 h20 +Center cRed vGetPos gGetPos, <<
Gui, Add, GroupBox, x712 y210 w130 h50 vGroup2, Button
Gui, Add, DropDownList, x722 y230 w110 h21 +R7 vButtonClick, Left||Right|Middle
Gui, Add, GroupBox, x842 y210 w100 h50 vGroup3, State
Gui, Add, DropDownList, x852 y230 w80 h21 +R7 vStateClick, Normal||Up|Down
Gui, Add, CheckBox, x722 y180 w200 h20 vCurrentClick gCurrentClick, Click at Current Position
Gui, Add, GroupBox, x712 y120 w130 h50 vGroup4, 
Gui, Add, GroupBox, x842 y120 w100 h50 vGroup5, State
Gui, Add, GroupBox, x712 y180 w230 h110 vGroup6, 
Gui, Add, Radio, x722 y120  h20 vSendKey +Checked gKeyRadio, Key
Gui, Add, Radio, x722 y180  h20 vSendString gKeyRadio, String
Gui, Add, DropDownList, x722 y140 w110 h21 +R7 vKeyName +Choose1, % KeyList
Gui, Add, DropDownList, x852 y140 w70 h21 +R7 vKeyState, Normal||Up|Down
Gui, Add, Edit, x722 y210 w210 h70 vStringText +Disabled, ___x@____
Gui, Add, Text, x902 y90 w30 h20 vGetWin gGetWin cRed, >><<
Gui, Add, GroupBox, x712 y170 w230 h50 vGroup7, Size (W - H)
Gui, Add, Edit, x722 y190 w90 h20 vWidthSize +number, 
Gui, Add, Updown, x164 y320 w18 h20 Range0-999999999 vUD3, 
Gui, Add, Edit, x812 y190 w90 h20 vHeightSize +number, 
Gui, Add, Updown, x164 y320 w18 h20 Range0-999999999 vUD4, 
Gui, Add, GroupBox, x712 y220 w230 h50 vGroup8, Title
Gui, Add, Edit, x722 y240 w180 h20 vWinTitle, 
Gui, Add, GroupBox, x712 y270 w230 h50 vGroup9, Class
Gui, Add, Edit, x722 y290 w180 h20 vWinClass, 
Gui, Add, GroupBox, x712 y120 w230 h50 vGroup10, Delay (ms)
Gui, Add, Edit, x732 y140 w168 h20 vDelayms +number, DelayTime
Gui, Add, Updown, x164 y320 w18 h20 Range1-999999999 vUD5, 1
Gui, Add, GroupBox, x712 y0 w230 h60 , Edit
Gui, Show, x213 y159 h363 w961, %TitleName%
gosub, CommandMode
gosub,SaveHotkey
OnExit,IsSave
Return
DelAll:
LV_Delete()
XMR_Data := ""
return
IsSave:
Gui +OwnDialogs
if LV_GetCount()
{
	MsgBox,35,Save?,Do you want to save before exiting?
	IfMsgBox,Cancel
		return
	IfMsgBox,Yes
		gosub,Save
}
ExitApp
return
AHKSave:
Gui +OwnDialogs
if !XMR_Data
	return
FileSelectFile,IniFile,S,% root,Save as AHK file - %TitleName%,AHK (*.ahk)
if !IniFile
	Return
SplitPath,IniFile,,root,ext
if (ext<>"ahk")
	IniFile .= ".ahk"
TempVar := 
(
";~ ###Settings###
SetBatchLines,-1
CoordMode,Mouse,Screen
SetMouseDelay,-1
SetWinDelay, 0
DetectHiddenWindows, On
SetControlDelay, -1
#MaxThreadsBuffer On
SendMode, Input
SetKeyDelay, -1 
"
)
TempVar .= XMR2AHK(XMR_Data,CoordType,BlockInputType) "`nExitApp"
IfExist,% IniFile
	FileDelete,% IniFile
FileAppend,% TempVar,% IniFile,UTF-8
return
DelInfo:
Loop,% LV_GetCount("S")
{
	DelInfo(LV_GetNext())
	LV_Delete(LV_GetNext())
}
return
InsertInfo:
Gui,Submit,Nohide
SelectedRow := ( (SelectedRow := LV_GetNext()) ? SelectedRow : LV_GetCount())
if (CommandMode = "Move Mouse")
{
	if (XPos="" OR YPos="")
		return
	InsertInfo("M" Chr(252) XPos Chr(251) YPos,SelectedRow)
	DisplayInfo("M",XPos Chr(251) YPos,SelectedRow)
}
else if (CommandMode = "Click")
{
	if (XPos="" && YPos<>"") OR (XPos<>"" && YPos="")
		return
	InsertInfo("C" Chr(252) ButtonClick Chr(251) XPos Chr(251) YPos Chr(251) StateClick,SelectedRow)
	DisplayInfo("C",ButtonClick Chr(251) XPos Chr(251) YPos Chr(251) StateClick,SelectedRow)
}
if (CommandMode="Window")
{
	if (!WinClass && !WinTitle) OR (XPos="" && YPos<>"") OR (XPos<>"" && YPos="") OR (WidthSize="" && HeightSize<>"") OR (WidthSize<>"" && HeightSize="")
		return
	InsertInfo("W" Chr(252) XPos Chr(251) YPos Chr(251) WidthSize Chr(251)  HeightSize Chr(251) WinClass Chr(251) WinTitle,SelectedRow)
	DisplayInfo("W",XPos Chr(251) YPos Chr(251) WidthSize Chr(251)  HeightSize Chr(251) WinClass Chr(251) WinTitle,SelectedRow)
}
else if (CommandMode="KeyBoard")
{
	TempVar := ""
	if (SendKey=1)
		TempVar := KeyName . (KeyState<>"Normal" ? " " KeyState : "")
	else Loop,Parse,StringText
	if (A_LoopField="`n")
		TempVar .= "{Enter}"
	else if (A_LoopField=" ")
		TempVar .= "{Space}"
	else TempVar .= "{" A_LoopField "}"
	if !(SendKey=1)
		TempVar := SubStr(TempVar,2,StrLen(TempVar)-2)
	If (Tempvar = "")
		return
	InsertInfo("K" Chr(252) TempVar,SelectedRow)
	DisplayInfo("K",TempVar,SelectedRow)
}
else if (CommandMode="Delay")
{
	if !Delayms
		return
	InsertInfo("D" Chr(252) Delayms,SelectedRow)
	DisplayInfo("D",Delayms,SelectedRow)
}
LV_ModifyCol(1,"AutoHdr")
LV_ModifyCol(2,"AutoHdr")
return
CurrentClick:
GuiControlGet,CurrentClick,,CurrentClick
if CurrentClick
{
	GuiControl,,XPos,
	GuiControl,,YPos,
	ControlDisableEnable("XPos|YPos|GetPos","")
}
else
ControlDisableEnable("","XPos|YPos|GetPos")
return
KeyRadio:
GuiControlGet,SendKey,,SendKey
if (SendKey=1)
	ControlDisableEnable("StringText","KeyName|KeyState")
else ControlDisableEnable("KeyName|KeyState","StringText")
return
GetWin:
Gui,Hide
while (GetKeyState("LButton","P")) {
	MouseGetPos,,,WinID
	WinGetPos,XPos,YPos,WidthSize,HeightSize,ahk_id %WinID%  
	WinGetTitle,WinTitle,ahk_id %WinID%
	WinGetClass,WinClass, ahk_id %WinID%
	ToolTip,% "X=" XPos "`nY=" YPos "`nW=" WidthSize "`nH=" HeightSize "`nTitle=" WinTitle "`nClass=" WinClass
	Sleep 100
}
ToolTip
GuiControl,,XPos,% XPos
GuiControl,,YPos,% YPos
GuiControl,,WidthSize,% WidthSize
GuiControl,,HeightSize,% HeightSize
GuiControl,,WinClass,% WinClass
GuiControl,,WinTitle,% WinTitle
Gui,Show
return
GetPos:
Gui,Hide
GuiControlGet,CoordType,,CoordType
CoordMode,Mouse,% CoordType
while (GetKeyState("LButton","P")) {
	MouseGetPos,XPos,YPos
	ToolTip,% "X=" XPos "`nY=" YPos
}
ToolTip
GuiControl,,XPos,% XPos
GuiControl,,YPos,% YPos
Gui,Show
return
Record:
if PlayRecordFlag
	return
if (RecordFlag := !RecordFlag) {
while (GetKeyState(A_ThisHotkey,"P"))
	Sleep 1
SetTimer,StartRecording,-1
}
else
	SetTimer,StopRecording,-1
return
StartRecording:
WindowInfoRecord(1)
Gui, Submit
TrayTip,%TitleName%,% "Recording...`nPress " RecordKey " to Stop",15000
TempVar := XMR((StopRecordingFlag:=0),CoordType )
XMF(TempVar,WinInfo,WinInfo,WPos,WSize,MouseMovemnets,Clicks,KeyboardActions,DelayTime,DefaultDelay)
XMR_Data := Trim(XMR_Data "`n" TempVar,"`n")
ShowInfo:
LV_Delete()
Loop,Parse,XMR_Data,`n
{
	StringSplit,Info,A_LoopField,% Chr(252)
	DisplayInfo(Info1,Info2)
}
LV_ModifyCol(1,"AutoHdr")
LV_ModifyCol(2,"AutoHdr")
Gui, Show
return
StopRecording:
Critical
StopRecordingFlag := 1
return
PlayRecord:
if RecordFlag
{
	gosub, Record
	return
}
Gui,Submit
if (PlayRecordFlag := !PlayRecordFlag)
	SetTimer,StartPlaying,-10
else SetTimer,StopPlaying,-1
return
StartPlaying:
StopXMPFlag := 0
while (!StopXMPFlag && RepeatTime>=0)
{
	XMP(StopXMPFlag,XMR_Data,CoordType,BlockInputType)
	RepeatTime--
}
PlayRecordFlag := 0
Gui,Show
return
StopPlaying:
Critical
StopXMPFlag := 1
return
CommandMode:
GuiControlGet,CommandMode,,CommandMode
if (CommandMode_Old = CommandMode)
	return
ControlHideShow(ListControlClick "|" ListControlWin "|" ListControlKey "|" ListControlDelay)
if (CommandMode = "Move Mouse")
	ControlHideShow("",ListControlMove)
else if (CommandMode = "Click")
	ControlHideShow("",ListControlClick)
if (CommandMode="Window")
	ControlHideShow("",ListControlWin)
else if (CommandMode="KeyBoard")
	ControlHideShow("",ListControlKey)
else if (CommandMode="Delay")
	ControlHideShow("",ListControlDelay)
CommandMode_Old := CommandMode
return
About:
MsgBox, 0, %TitleName%, Author : ___x@___  (nothing)`nEmail: anhnhoktvn@gmail.com`nFeedbacks are welcome!`n`nCredits:`nAutohotkey by  Chris `nAutohotkey_L by Lexikos`nAhk2Exe by fincs
return
DelayTime:
GuiControlGet,DelayTime,,DelayTime
GuiControl,Disable%DelayTime%,DefaultDelay
return
WinInfo:
GuiControlGet,WinInfo,,WinInfo
	GuiControl,Enable%WinInfo%,WPos
	GuiControl,Enable%WinInfo%,WSize
	GuiControl,,WPos,%WinInfo%
	GuiControl,,WSize,%WinInfo%
return
SaveHotkey:
GuiControlGet,RecordKey,,RecordKey
GuiControlGet,PlayKey,,PlayKey
if (RecordKey=PlayKey)
{
	MsgBox,48,ERROR,Please choose another hotkey!
	GuiControl,ChooseString,RecordKey,% RecordKey_Old
	GuiControl,ChooseString,PlayKey,% PlayKey_Old
	return
}
Hotkey, %RecordKey_Old%, Record, Off UseErrorLevel
Hotkey, %RecordKey%, Record, On UseErrorLevel
RecordKey_Old := RecordKey
Hotkey, %PlayKey_Old%, PlayRecord, Off UseErrorLevel
Hotkey, %PlayKey%, PlayRecord, On UseErrorLevel
PlayKey_Old:=PlayKey
TrayTip,% TitleName,% "Press " RecordKey " to Start Recording`nPress " PlayKey " to Start Playing Record",15000,1
return
GuiClose:
ExitApp
return
Save:
Gui +OwnDialogs
if !LV_GetCount()
{
	MsgBox,48, %TitleName%, Nothing to Save!
	return
}
FileSelectFile,IniFile,S,%root%,Save data - %TitleName%,X-Macro Recorder (*.xmr)
if !IniFile
	Return
SplitPath,IniFile,,root,ext
if (ext<>"xmr")
	IniFile .= ".xmr"
IfExist, % IniFile
{
	MsgBox, 36, %TitleName%, %IniFile% already exists.`nDo you want to replace it?
		IfMsgBox,No
			return
}
FileDelete, %IniFile%
TrayTip,%TitleName% ,Saving Data!`nPlease Wait..., 15000
IniWrite,% CoordType,% IniFile,CoordMode
IniWrite,% BlockInputType,% IniFile,BlockInput
IniWrite,% XMR_Data,% IniFile,Data
TrayTip,%TitleName% ,Saved!, 5000
return
Load:
Gui +OwnDialogs
FileSelectFile,IniFile,,%root%,Load data - %TitleName%,X-Macro Recorder (*.xmr)
if !IniFile
	Return
SplitPath,IniFile,,root,ext
if (ext<>"xmr")
	return
IniRead,TempVar,% IniFile, CoordMode
GuiControlGet,CoordType,,CoordType
if (TempVar<>CoordType)
{
	if LV_GetCount() {
	Gui +OwnDialogs
	MsgBox,48,ERROR,Different CoordMode!
	return
	}
	else GuiControl,Choose,CoordType,2
}
GuiControl,,CoordType,% TempVar
IniRead,BlockInputType,% IniFile, BlockInput
GuiControl,,BlockInputType,BlockInputType
IniRead,TempVar,% IniFile,Data
StringReplace,TempVar,TempVar,`r`n,`n,All
XMR_Data := Trim(XMR_Data "`n" TempVar,"`n")
gosub,ShowInfo
return
ControlDisableEnable(DisableList="",EnableList="")
{
	if DisableList
		Loop, Parse, DisableList,|
			GuiControl,Disable,% A_LoopField
	if EnableList
		Loop, Parse, EnableList,|
			GuiControl,Enable,% A_LoopField
}
ControlHideShow(HideList="",ShowList="")
{
	if HideList
		Loop, Parse, HideList,|
			GuiControl,Hide,% A_LoopField
	if ShowList
		Loop, Parse, ShowList,|
			GuiControl,Show,% A_LoopField
}
DisplayInfo(Info1,Info2,Position=0)
{
	if !Position
		Position := 999999999
	Position++
	StringSplit,DisInfo,Info2,% Chr(251)
	if (Info1="M")
		LV_Insert(Position,"","Move Mouse","X=" DisInfo1 "   " "Y=" DisInfo2)
	else if (Info1="C")
		LV_Insert(Position,"","Click",(DisInfo1 = "L" ? "Button=Left" : (DisInfo1 = "R" ? "Button=Right" : "Button=Middle")) "   " (DisInfo2="" ? "" : "X=" DisInfo2) "   " (DisInfo3="" ? "" : "Y=" DisInfo3) "   " (DisInfo4="" ? "" : DisInfo4="D" ? "State=Down" : "State=Up"))
	else if (Info1="K")
		LV_Insert(Position,"","Keyboard",Info2)
	else if (Info1="D")		
		LV_Insert(Position,"","Delay",Info2 " ms")
	else if (Info1="W")		
		LV_Insert(Position,"","Window",(DisInfo6="" ? "" : "Title=" DisInfo6) "   " (DisInfo5="" ? "" : "Class=" DisInfo5) "   " (DisInfo1="" ? "" : "X=" DisInfo1) "   " (DisInfo2="" ? "" : "Y=" DisInfo2) "   " (DisInfo3="" ? "" : "W=" DisInfo3) "   " (DisInfo4="" ? "" : "H=" DisInfo3))
}
InsertInfo(Info,Line)
{
	global XMR_Data
	Loop,Parse,XMR_Data,`n
	{
		Result.= A_LoopField "`n"
		if (A_Index=Line)
			Result .= Info "`n"
	}
	XMR_Data := RTrim(Result,"`n")
	if !Line
		XMR_Data := Info
}
DelInfo(Line)
{
	global XMR_Data
	Loop,Parse,XMR_Data,`n
	{
		if (A_Index=Line)
			continue
		Result.= A_LoopField "`n"
	}
	XMR_Data := RTrim(Result,"`n")
}
	;~ StopXMRFlag		; (Required) 
		;~ StopXMRFlag := 0	; Keep Recording.
		;~ StopXMRFlag := 1	; Stop Recording and return the time has passed.
	;~ CoordType	;~ Affects to get Mouse Movements and Mouse Clicks Coordinates. See More in AHK help file > CoordMode
		;~ CoordType := Client	;~ (Default) Coordinates are relative to the active window's client area, which excludes the window's title bar, menu.
								;~ You can use the file you recorded on almost computer (with Windows OS >= 2k) with Screen Resolution >= Yours.
		;~ CoordType := Screen ;~ () Coordinates are relative to the desktop.
								;~ You can only use the file you recorded on the computers that have the same Screen Resolution with  yours.
		;~ BlockInputType	 := On || Off || MouseMove		; See AHK help file > BlockInput
XMR(ByRef StopXMRFlag,CoordModeType="Screen")
{
KeyList :=
(Join
"Browser_Back|Browser_Forward|Browser_Refresh|Browser_Stop|Browser_Search|Browser_Favorites|Browser_Home|Volume_Mute|Volume_Down|Volume_Up|Media_Next|Media_Prev|Media_Stop|Media_Play_Pause|Launch_Mail|Launch_Media|Launch_App1|Launch_App2|
Esc|F1|F2|F3|F4|F5|F6|F7|F8|F9|F10|F11|F12|PrintScreen|Pause|Ins|Del|
``|1|2|3|4|5|6|7|8|9|0|-|=|Backspace|Home|
Tab|q|w|e|r|t|y|u|i|o|p|[|]|\|PgUp|
a|s|d|f|g|h|j|k|l|;|'|Enter|PgDn|
z|x|c|v|b|n|m|,|.|/|End|
Space|AppsKey|
ScrollLock|CapsLock|NumLock|
Up|Down|Left|Right|
Numpad0|NumpadIns|
Numpad1|NumpadEnd|
Numpad2|NumpadDown|
Numpad3|NumpadPgDn|
Numpad4|NumpadLeft|
Numpad5|NumpadClear|
Numpad6|NumpadRight|
Numpad7|NumpadHome|
Numpad8|NumpadUp|
Numpad9|NumpadPgUp|
NumpadDot|NumpadDel|
NumpadDiv|NumpadMult|
NumpadAdd|NumpadSub|
NumpadEnter|
WheelUp|WheelDown|
LControl|RControl|LShift|RShift|LAlt|RAlt|LWin|RWin"
)
	FirstTickCount := A_TickCount	;~ Record Time Interval
	TimeIntervalRecord()
	MouseClickRecord()
	KeyboardRecord(KeyList)	;~ Record Keyboard actions
	Loop {	;~ Start recording
		if (StopXMRFlag) {
		KeyboardRecord(KeyList,"Off")
		MouseClickRecord("Off")
		;~ StopXMRFlag := A_TickCount - FirstTickCount
		return, LTrim(XMR_Data,"`n")
		}
		if (KeyName="")
			if (WindowInfo := WindowInfoRecord())	
			{
				if (TimePass := TimeIntervalRecord())
					XMR_Data .= "`nD" Chr(252) TimePass
				XMR_Data .= "`n" WindowInfo 
			}
		if (MouseMove := IsMouseMove(CoordModeType))	;~ Record mouse movement
			XMR_Data .= "`n" MouseMove
		Sleep -1
	}
	KeyBoardRecord:
		Critical
		if StopXMRFlag
			return
		
		KeyName := SubStr(A_ThisHotkey,4)
		if KeyName in LWin Up,RWin Up
			IfInString,A_PriorHotkey,Win
			Send, {LWin}
		if (TimePass :=  TimeIntervalRecord())
			XMR_Data .= "`nD" Chr(252) TimePass
		if (KeyName<>"Up")&& (InStr(KeyName,"Up"))
			 XMR_Data .= "`nK" Chr(252) KeyName 
		else XMR_Data .= "`nK" Chr(252) KeyName " Down"
		KeyName := ""
	return
	MouseClick:
	Critical
		CoordMode,Mouse
		MouseGetPos,XPos,YPos
		if (CoordModeType<>"Screen") {
			WinGetPos,WinX,WinY,,,A
			XPos -= WinX,YPos -= WinY
		}
		if (WindowInfo := WindowInfoRecord())	
			XMR_Data .= "`n" WindowInfo 
		if (TimePass :=  TimeIntervalRecord())
			XMR_Data .= "`nD" Chr(252) TimePass
		if InStr(A_ThisHotkey,"Up")
			XMR_Data .= "`nC" Chr(252) SubStr(A_ThisHotkey,4,1)  Chr(251) XPos Chr(251) YPos Chr(251) "U"
		else XMR_Data .= "`nC" Chr(252) SubStr(A_ThisHotkey,4,1) Chr(251) XPos Chr(251) YPos Chr(251) "D"
	return
}
	KeyboardRecord(KeyList,State = "On") {
	  Loop, Parse, KeyList, |
		{
			Hotkey, ~*$%A_LoopField%, KeyBoardRecord, %State% UseErrorLevel 
			Hotkey, ~*$%A_LoopField% Up, KeyBoardRecord, %State% UseErrorLevel 
		}
	}
	IsMouseMove(CoordModeType="Screen")
	{
		static LastPos
		CoordMode,Mouse
		MouseGetPos,XPos,YPos
		if (LastPos = XPos YPos)
			return
		if !(TimePass := TimeIntervalRecord())
			return
		LastPos :=  XPos YPos
		if (CoordModeType<>"Screen") {	
			WinGetPos,WinX,WinY,,,A
			XPos -= WinX,YPos -= WinY
		}
		return, "D" Chr(252) TimePass "`nM" Chr(252) XPos Chr(251) YPos
	}
	MouseClickRecord(State = "On") {
		Hotkey,~*$LButton,MouseClick, %State% UseErrorLevel
		Hotkey,~*$RButton,MouseClick, %State% UseErrorLevel
		Hotkey,~*$MButton,MouseClick, %State% UseErrorLevel
		Hotkey,~*$LButton Up,MouseClick, %State% UseErrorLevel
		Hotkey,~*$RButton Up,MouseClick, %State% UseErrorLevel
		Hotkey,~*$MButton Up,MouseClick, %State% UseErrorLevel
	}
	WindowInfoRecord(Reset=0) {
		static Info_Old 
		if Reset
		{
			Info_Old := ""
			return
		}
		WinGetActiveStats,WinTitle,W,H,XPos,YPos
		WinGetClass,WinClass,A
		if ((Info_Old = WinTitle WinClass XPos YPos W H) OR !WinClass OR (WinClass="Shell_TrayWnd") OR (WinClass="Button") OR !W)
			return
		Info_Old :=  WinTitle WinClass XPos YPos W H
		return "W" Chr(252)  XPos Chr(251) YPos Chr(251) W Chr(251) H Chr(251) WinClass Chr(251) WinTitle
	}
	TimeIntervalRecord()	{
		static LastTickCount := A_TickCount
		Result := A_TickCount- LastTickCount
		LastTickCount := A_TickCount
		return, Result
	}
XMF(ByRef XMR,WT=0,WC=0,WP=0,WS=0,M=0,C=0,K=0,D=0,DefaultDelay=0)
{
	Loop,Parse,XMR,`n,`r
		{
		W := WT||WC||WP||WS ? 1 : 0
		StringSplit,Info,A_LoopField,% Chr(252)
		if !(%Info1%) {
			if (Info1="D")
				LastDelay += Info2
			continue
			}
		if (Info1="D") {
				LastDelay += Info2
				continue
			}
		if (LastDelay) {
			if (D)
				Result .= "`nD"  Chr(252) LastDelay
			else if (DefaultDelay)
				Result .= "`nD"  Chr(252) DefaultDelay
			LastDelay := 0
		}
		if (Info1="W") {
			StringSplit,WinInfo,Info2,% Chr(251)
			WinInfo := WP ? WinInfo1 Chr(251) WinInfo2 Chr(251) : Chr(251) Chr(251)
			WinInfo .= WS ? WinInfo3 Chr(251) WinInfo4 Chr(251) : Chr(251) Chr(251)
			WinInfo .= WC ? WinInfo5 Chr(251) : Chr(251)
			WinInfo .=  WT ? WinInfo6 : ""
			Result .= "`n" "W" Chr(252) WinInfo
		}
		else 
			Result .= "`n" A_LoopField
		}
	XMR := Trim(Result,"`n")
}
	;~ StopXMRFlag := 0 	; Keep Playing.
	;~ StopXMRFlag := 1	; Stop Playing.
	;~ XMR_Data : var store data recorded.
	;~ Return Value : the time has passed since starting playing.
XMP(ByRef StopXMPFlag,XMR_Data="",CoordModeType="Screen",BlockInputType="MouseMove") {
FirstTickCount := A_TickCount
TotalTime := 0
XPos := 0
YPos := 0
CoordMode,Mouse,Screen
if (BlockInputType<>"Off")
	BlockInput, % BlockInputType
	Loop,Parse,XMR_Data,`n
	{
		if StopXMPFlag
			break
		StringSplit,Info,A_LoopField,% Chr(252)
		StringSplit,Detail,Info2,% Chr(251)
		if (Info1 = "M") {
			;~ if (A_TickCount - FirstTickCount <= TotalTime)
				MouseMove,% Detail1 + XPos,% Detail2 + YPos,0
		}
		else if (Info1 = "W") {
					Title := Detail6
					if Detail5
						Title .= " ahk_class " Detail5
					IfWinExist,% Title
					{
						WinGetPos,XPos,YPos,W,H,% Title
						if (XPos YPos <> Detail1 Detail2)&&(Detail1 Detail2 <> "")
							WinMove,% Title,,% Detail1,% Detail2
						if (W H <> Detail3 Detail4)&&(Detail3 Detail4 <> "")
							WinMove,% Title,,,,% Detail3,% Detail4
						IfWinNotActive, % Title
							WinActivate,% Title
						if (CoordModeType="Screen") {
							XPos := 0
							YPos := 0
						}
					}
				}
		else if (Info1 = "K")
				Send,% "{" Detail1 "}"
		else if  (Info1 = "C")
				MouseClick,% Detail1,% Detail2 + XPos,% Detail3 + YPos,1,0,% Detail4
		else if (Info1 = "D")
		{
			TotalTime += Detail1
			while  (A_TickCount - FirstTickCount < TotalTime)
				if StopXMPFlag
					break
			}
	}
if (BlockInputType<>"Off") {
	BlockInput,Off
	BlockInput,MouseMoveOff
	}
return, A_TickCount - FirstTickCount
}
XMR2AHK(XMR,CoordType="Screen",BlockInputType="Off")
{
	AHK_Data := "CoordMode,Mouse," CoordType "`n"
	if (BlockInputType<>"Off")
		AHK_Data .= "BlockInput," BlockInputType "`n"
	Loop,Parse,XMR,`n,`r
	{
		StringSplit,Info,A_LoopField,% Chr(252)
		if (Info1 = "M")
				AHK_Data .= MouseMove2AHK(Info2) "`n"
		else if (Info1 = "C")
			AHK_Data .= Click2AHK(Info2) "`n"
		else if (Info1 = "W")
			AHK_Data .= WindowInfo2AHK(Info2) "`n"
		else if (Info1 = "K")
				AHK_Data .= "Send,{" Info2 "}" "`n"
		else if (Info1 = "D")
				AHK_Data .= "Sleep," Info2 "`n"
	}
	if (BlockInputType<>"Off")
		AHK_Data .= "BlockInput,Off`nBlockInput,MouseMoveOff"
	return, RTrim(AHK_Data,"`n")
}
WindowInfo2AHK(Data) {
	StringSplit,Info,Data,% Chr(251)
	Title := Info6
	if Info5
	Title .= " ahk_class " Info5
	if !Title
		return
	Result := (Info1<>"" && Info3<>"" ? "WinGetPos,XPos,YPos,W,H," Title "`nif (XPos YPos W H <> "  Info1 Info2 Info3 Info4 ")`n WinMove," Title ",," Info1 "," Info2 "," Info3 "," Info4 "`n" : Info1<>"" ? "WinGetPos,XPos,YPos,,," Title "`nif (XPos YPos<> "  Info1 Info2  ")`n WinMove," Title ",," Info1 "," Info2 "`n": Info3<>"" ? "WinGetPos,,,W,H," Title "`nif ( W H <> " Info3 Info4 ")`n WinMove," Title ",,,," Info3 "," Info4 "`n" : "")
	Result .= "IfWinNotActive," Title "`nWinActivate," Title
return Result
}
MouseMove2AHK(Data) {
	StringSplit,Info,Data,% Chr(251)
	return, "MouseMove," Info1 "," Info2
}
Click2AHK(Data)
{
	StringSplit,Info,Data,% Chr(251)
	return, "MouseClick," Info1 "," Info2 "," Info3 ",,," Info4
}