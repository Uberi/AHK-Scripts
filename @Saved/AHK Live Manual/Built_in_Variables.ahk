;===================================================
; AHK Live Manual - Built_in_Variables
; Lucid_Method (01-04-2011)
;===================================================

#NoEnv
#Persistent
#SingleInstance force

TestAHK = %A_WorkingDir%\Lib\TestAHK.ahk
FileDelete %TestAHK%
AHKCommand = Built_in_Variables
Command_Version = 1.0
GoSub LiveManual_Setup

;===================================================
Gui, Font, S10

	LiveManual_Build_Built_in_Variables:
{

;===================================================
; Build Buttons
;===================================================

Gui, Add, Button, x10 y10 w50 h50 gBuilt_In_Vars_LV_Load_Section, All
Gui, Add, Button, xp+50 yp w90 hp gBuilt_In_Vars_LV_Load_Section, Script Properties
Gui, Add, Button, xp+90 yp wp hp gBuilt_In_Vars_LV_Load_Section -Wrap, Date Time 
Gui, Add, Button, xp+90 yp wp hp gBuilt_In_Vars_LV_Load_Section, Script`nSettings
Gui, Add, Button, xp+90 yp wp hp gBuilt_In_Vars_LV_Load_Section -Wrap, User Idle
Gui, Add, Button, xp+90 yp wp hp gBuilt_In_Vars_LV_Load_Section -Wrap, GUI Win
Gui, Add, Button, xp+90 yp wp hp gBuilt_In_Vars_LV_Load_Section -Wrap, Hotkeys
Gui, Add, Button, xp+90 yp wp hp gBuilt_In_Vars_LV_Load_Section -Wrap, User Info
Gui, Add, Button, xp+90 yp wp hp gBuilt_In_Vars_LV_Load_Section -Wrap, Misc
Gui, Add, Button, xp+90 yp wp hp gBuilt_In_Vars_LV_Load_Section -Wrap, Loops

;Gui, Add, Button, xp+90 yp wp hp gLiveManual_Exit -Wrap, Exit
Gui, Add, Button, xp+95 yp w70 hp gLiveManual_Reload -Wrap, Reload


;===================================================
; Build ListView
;===================================================

Gui, Add, ListView, x10 y80 w930 h480 vSysListView321 hwndSysListView321_Hwnd gBuilt_In_Vars_LV AltSubmit, Variable Name|Variable Value
	; Add Rows
	Gui, ListView, SysListView321 ;Define LV to Send Commands To
	Gosub Built_In_Vars_LV_All ;Loads all Sections

	;=====================
	; Modify Columns
	;=====================
		LV_ModifyCol(1, "250")
		LV_ModifyCol(2, "650")
		
Gui, Add, StatusBar,,
SB_SetParts(250)
		
GoSub LiveManual_Build_MenuBar
Gui, Show, xCenter yCenter w971 h610, %AHKCommand% (AHK Live-Manual)

Return
}

;===================================================
; ListView
;===================================================

Built_In_Vars_LV: ;ListView Actions
{
	SelectedText := LV_GetSelectedText("1") ;Column 1 Text
	Clipboard = `%%SelectedText%`%
	Message = Clipboard = `%%SelectedText%`%
	SB_SetText(Message)
	Return
}	
	

	Built_In_Vars_LV_Load_Section: ;Button Actions - Loads Different Sections in LV
{
	GoSub Built_In_Vars_ClearLV
	GoSub Built_In_Vars_LV_BreakLine
	If A_GuiControl = All
		Gosub Built_In_Vars_LV_All ;Loads all Sections
	If A_GuiControl = Script Properties
		GoSub Built_In_Vars_LV_Script_Properties
	If A_GuiControl = Date Time
		GoSub Built_In_Vars_LV_Date_Time		
	If A_GuiControl = Script`nSettings
		GoSub Built_In_Vars_LV_Script_Settings
	If A_GuiControl = User Idle
		GoSub Built_In_Vars_LV_User_Idle_Time
	If A_GuiControl = GUI Win
		GoSub Built_In_Vars_LV_GUI_Windows_Menu_Bars
	If A_GuiControl = Hotkeys
		GoSub Built_In_Vars_LV_Hotkeys_Hotstring_MenuItems
	If A_GuiControl = User Info
		GoSub Built_In_Vars_LV_OS_User_Info
	If A_GuiControl = Misc 	
		GoSub Built_In_Vars_LV_Misc		
	If A_GuiControl = Loops
		GoSub Built_In_Vars_LV_Loop		
		
	Return
}

	Built_In_Vars_LV_BreakLine: ; Define Break Line
{
	BreakLineShort = ===================
	BreakLineLong = =============================================================
	
	LV_Add("", BreakLineShort, BreakLineLong)
	Return
}	

	Built_In_Vars_ClearLV: ; Clear Listview
{
	Gui, ListView, SysListView321 ;Define LV to Send Commands To
	LV_Delete()
	Return
}	

	Built_In_Vars_LV_All:  ;Loads all Sections in LV
{	
	GoSub Built_In_Vars_ClearLV
	GoSub Built_In_Vars_LV_BreakLine
	GoSub Built_In_Vars_LV_Script_Properties
	GoSub Built_In_Vars_LV_Date_Time
	GoSub Built_In_Vars_LV_Script_Settings
	GoSub Built_In_Vars_LV_User_Idle_Time
	GoSub Built_In_Vars_LV_GUI_Windows_Menu_Bars
	GoSub Built_In_Vars_LV_Hotkeys_Hotstring_MenuItems
	GoSub Built_In_Vars_LV_Loop
	GoSub Built_In_Vars_LV_OS_User_Info
	GoSub Built_In_Vars_LV_Misc
	Return
}	
	
		Built_In_Vars_LV_Script_Properties:	 ; Script Properties
{
	; Display Command Line Parameters for script if values found
	If 0 != 0
		{
			LV_Add("", "0", 0)
		If 1 !=
			LV_Add("", "1", 1)
		If 2 !=
			LV_Add("", "2", 2)
		If 3 !=
			LV_Add("", "3", 3)
		If 4 !=
			LV_Add("", "4", 4)
		If 5 !=
			LV_Add("", "5", 5)
		If 6 !=
			LV_Add("", "6", 6)
		If 7 !=
			LV_Add("", "7", 7)
		If 8 !=
			LV_Add("", "8", 8)
		If 9 !=
			LV_Add("", "9", 9)		
		GoSub Built_In_Vars_LV_BreakLine
	} ;end of if 0 != 0 (Command Line parameters)
	
	LV_Add("", "A_WorkingDir", A_WorkingDir)
	LV_Add("", "A_ScriptDir", A_ScriptDir)
	LV_Add("", "A_ScriptName", A_ScriptName)
	LV_Add("", "A_ScriptFullPath", A_ScriptFullPath)
	LV_Add("", "A_LineNumber", A_LineNumber)
	LV_Add("", "A_LineFile", A_LineFile)
	LV_Add("", "A_ThisFunc", A_ThisFunc)
	LV_Add("", "A_ThisLabel", A_ThisLabel)
	LV_Add("", "A_AhkVersion", A_AhkVersion)
	LV_Add("", "A_AhkPath", A_AhkPath)
	LV_Add("", "A_IsCompiled", A_IsCompiled)
	LV_Add("", "A_ExitReason", A_ExitReason)
		GoSub Built_In_Vars_LV_BreakLine
	Return
}	
		
		Built_In_Vars_LV_Date_Time:	; Date and Time
{
	LV_Add("", "A_YYYY", A_YYYY)
	LV_Add("", "A_MM", A_MM)
	LV_Add("", "A_DD", A_DD)
	LV_Add("", "A_MMMM", A_MMMM)
	LV_Add("", "A_MMM", A_MMM)
	LV_Add("", "A_DDDD", A_DDDD)
	LV_Add("", "A_DDD", A_DDD)
	LV_Add("", "A_WDay", A_WDay)
	LV_Add("", "A_YDay", A_YDay)
	LV_Add("", "A_YWeek", A_YWeek)
	LV_Add("", "A_Hour", A_Hour)
	LV_Add("", "A_Min", A_Min)
	LV_Add("", "A_Sec", A_Sec)
	LV_Add("", "A_MSec", A_MSec)
	LV_Add("", "A_Now", A_Now)
	LV_Add("", "A_NowUTC", A_NowUTC)
	LV_Add("", "A_TickCount", A_TickCount)
		GoSub Built_In_Vars_LV_BreakLine
	Return
}	
		
		Built_In_Vars_LV_Script_Settings:  ; Script Settings
{
	LV_Add("", "A_IsSuspended", A_IsSuspended)
	LV_Add("", "A_IsPaused", A_IsPaused)
	LV_Add("", "A_IsCritical", A_IsCritical)
	LV_Add("", "A_BatchLines", A_BatchLines)
	LV_Add("", "A_TitleMatchMode", A_TitleMatchMode)
	LV_Add("", "A_TitleMatchModeSpeed", A_TitleMatchModeSpeed)
	LV_Add("", "A_DetectHiddenWindows", A_DetectHiddenWindows)
	LV_Add("", "A_DetectHiddenText", A_DetectHiddenText)
	LV_Add("", "A_AutoTrim", A_AutoTrim)
	LV_Add("", "A_StringCaseSense", A_StringCaseSense)
	LV_Add("", "A_FormatInteger", A_FormatInteger)
	LV_Add("", "A_FormatFloat", A_FormatFloat)
	LV_Add("", "A_KeyDelay", A_KeyDelay)
	LV_Add("", "A_WinDelay", A_WinDelay)
	LV_Add("", "A_ControlDelay", A_ControlDelay)
	LV_Add("", "A_MouseDelay", A_MouseDelay)
	LV_Add("", "A_DefaultMouseSpeed", A_DefaultMouseSpeed)
	LV_Add("", "A_IconHidden", A_IconHidden)
	LV_Add("", "A_IconFile", A_IconFile)
	LV_Add("", "A_IconNumber", A_IconNumber)
	LV_Add("", "A_IconTip", A_IconTip)	
		GoSub Built_In_Vars_LV_BreakLine
	Return
}	
	
		Built_In_Vars_LV_User_Idle_Time:  ; User Idle Time 
{
	LV_Add("", "A_TimeIdle", A_TimeIdle)
	LV_Add("", "A_TimeIdlePhysical", A_TimeIdlePhysical)
		GoSub Built_In_Vars_LV_BreakLine
	Return
}	

		Built_In_Vars_LV_GUI_Windows_Menu_Bars:  ; GUI Windows and Menu Bars 
{
	LV_Add("", "A_Gui", A_Gui)
	LV_Add("", "A_GuiControl", A_GuiControl)
	LV_Add("", "A_GuiWidth", A_GuiWidth)
	LV_Add("", "A_GuiHeight", A_GuiHeight)
	LV_Add("", "A_GuiX", A_GuiX)
	LV_Add("", "A_GuiY", A_GuiY)
	LV_Add("", "A_GuiEvent", A_GuiEvent)
	LV_Add("", "A_EventInfo", A_EventInfo)
		GoSub Built_In_Vars_LV_BreakLine
	Return
}	

		Built_In_Vars_LV_Hotkeys_Hotstring_MenuItems:  ; Hotkeys, Hotstrings, and Custom Menu Items
{
	LV_Add("", "A_ThisMenuItem", A_ThisMenuItem)
	LV_Add("", "A_ThisMenu", A_ThisMenu)
	LV_Add("", "A_ThisMenuItemPos", A_ThisMenuItemPos)
	LV_Add("", "A_ThisHotkey", A_ThisHotkey)
	LV_Add("", "A_PriorHotkey", A_PriorHotkey)
	LV_Add("", "A_TimeSinceThisHotkey", A_TimeSinceThisHotkey)
	LV_Add("", "A_TimeSincePriorHotkey", A_TimeSincePriorHotkey)
	LV_Add("", "A_EndChar", A_EndChar)
		GoSub Built_In_Vars_LV_BreakLine
	Return
}	

		Built_In_Vars_LV_OS_User_Info: ; Operating System and User Info 
{
	LV_Add("", "ComSpec", ComSpec)
	LV_Add("", "A_Temp", A_Temp)
	LV_Add("", "A_OSType", A_OSType)
	LV_Add("", "A_OSVersion", A_OSVersion)
	LV_Add("", "A_Language", A_Language)
	LV_Add("", "A_ComputerName", A_ComputerName)
	LV_Add("", "A_UserName", A_UserName)
	LV_Add("", "A_WinDir", A_WinDir)
	LV_Add("", "A_ProgramFiles", A_ProgramFiles)
	LV_Add("", "A_AppData", A_AppData)
	LV_Add("", "A_AppDataCommon", A_AppDataCommon)
	LV_Add("", "A_Desktop", A_Desktop)
	LV_Add("", "A_DesktopCommon", A_DesktopCommon)
	LV_Add("", "A_StartMenu", A_StartMenu)
	LV_Add("", "A_Programs", A_Programs)
	LV_Add("", "A_ProgramsCommon", A_ProgramsCommon)
	LV_Add("", "A_Startup", A_Startup)
	LV_Add("", "A_StartupCommon", A_StartupCommon)
	LV_Add("", "A_MyDocuments", A_MyDocuments)
	LV_Add("", "A_IsAdmin", A_IsAdmin)
	LV_Add("", "A_ScreenWidth", A_ScreenWidth)
	LV_Add("", "A_ScreenHeight", A_ScreenHeight)
	LV_Add("", "A_IPAddress1", A_IPAddress1)
	LV_Add("", "A_IPAddress2", A_IPAddress2)		
	LV_Add("", "A_IPAddress3", A_IPAddress3)
	LV_Add("", "A_IPAddress4", A_IPAddress4)
		GoSub Built_In_Vars_LV_BreakLine
	Return
}	

		Built_In_Vars_LV_Misc: ; Misc
{
	LV_Add("", "A_Cursor", A_Cursor)
	LV_Add("", "A_CaretX", A_CaretX)
	LV_Add("", "A_CaretY", A_CaretY)
	LV_Add("", "Clipboard", Clipboard)
	LV_Add("", "ClipboardAll", ClipboardAll)
	LV_Add("", "ErrorLevel", ErrorLevel)
	LV_Add("", "A_LastError", A_LastError)
		GoSub Built_In_Vars_LV_BreakLine
	Return
}	

		Built_In_Vars_LV_Loop:  ; Loop
{
	LV_Add("", "A_Index", A_Index)
	LV_Add("", "A_LoopFileName", A_LoopFileName)
	LV_Add("", "A_LoopRegName", A_LoopRegName)
	LV_Add("", "A_LoopReadLine", A_LoopReadLine)
	LV_Add("", "A_LoopField", A_LoopField)
		GoSub Built_In_Vars_LV_BreakLine
	Return
}	


;===================================================

	SubmitCode:
{
	Gui, Submit, NoHide
	CodeLine = %AHKCommand%, %Frequency%, %Duration%
	GuiControl,,CodeDisplay, %CodeLine%
	Return
}


;===================================================
; INCLUDE CODE
;===================================================
#Include Lib\LiveManual_Include.ahk
;===================================================
