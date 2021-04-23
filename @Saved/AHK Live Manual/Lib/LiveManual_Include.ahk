;===================================================
;== AHK Live-Manual - Lucid_Method =================
;=====Include Code==================================
;===================================================

	LiveManual_Setup: ;Place in startup of LiveManual CodeGen Pages
{
	LiveManual_Version = 1.2

	LiveManual_Update_Server = http://www.autohotkey.net/~Lucid_Method/AHK_Live_Manual

	SplitPath, A_ScriptFullPath,,, A_ScriptExt, A_ScriptName_No_Ext, A_ScriptDrive ;A_ScriptName & A_ScriptDir

	NotePadPath = %A_ScriptDrive%\SmartGui+\Lib\Code_Tools\Notepad++\Notepad++_Portable.exe ;Configure with your Code Editor's Path

	LiveManualINI = %A_WorkingDir%\Lib\Live_Manual.ini
	
	GoSub LiveManual_Define_Icons ;Define Icon Locations
	GoSub LiveManual_Build_TrayMenu
	
	Return
}	

	LiveManual_Build_MenuBar:
{

	Menu, LiveManual_About, Add, 
	Menu, LiveManual_About, Add, Check For Update, LiveManual_Server_Update_Check
	Menu, LiveManual_About, Add, AHK Forum Post, LiveManual_Forum_Post
	Menu, LiveManual_About, Add, About Live-Manual, LiveManual_About	
	Menu, LiveManual_About, Add, 

	;Loop Through LiveManual Dir for All AHK to Load into Menu
	Loop, %A_WorkingDir%\*.ahk, 0, 0
		{
		SplitPath, A_LoopFileFullPath, name, dir, ext, name_no_ext, drive
		Menu, LiveManual_CodeGens, Add, %name_no_ext%, LiveManual_Load_CodeGen
		}
		
	Menu, LiveManual_CodeGens, Check, %AHKCommand% ;Check the currently running codegen name
	
	Menu, LiveManual_View, Add, 
	Menu, LiveManual_View, Add, AlwaysOnTop, LiveManual_AlwaysOnTop
	Menu, LiveManual_View, Add, 
	
	Menu, LiveManual_File, Add, 
	Menu, LiveManual_File, Add, AHK Manual, LiveManual_AHK_Manual
	Menu, LiveManual_File, Add, 
	Menu, LiveManual_File, Add, Edit Code, LiveManual_Edit
	Menu, LiveManual_File, Add, Edit Include, LiveManual_Edit_IncludeFile
	Menu, LiveManual_File, Add, Script Folder, LiveManual_Open_ScriptDir
	Menu, LiveManual_File, Add, 
	Menu, LiveManual_File, Add, Reload, LiveManual_Reload
	Menu, LiveManual_File, Add, Exit, LiveManual_Exit
	Menu, LiveManual_File, Add, 
	
	Menu, LiveManualMenuBar, Add, File, :LiveManual_File
	Menu, LiveManualMenuBar, Add, View, :LiveManual_View
	Menu, LiveManualMenuBar, Add, Code Generators, :LiveManual_CodeGens
	Menu, LiveManualMenuBar, Add, Help, :LiveManual_About
	
	Gui, Menu, LiveManualMenuBar ; Attach the menu bar to the window
	Menu, LiveManualMenuBar, Color, White ;Make Menu Color White
	
	GoSub LiveManual_UpdateGUISettings
Return
}

	LiveManual_UpdateGUISettings:
{
	IniRead, AlwaysOnTop, %LiveManualINI%, LiveManual, AlwaysOnTop, %A_Space%
	If AlwaysOnTop = 1
		{
		AlwaysOnTop = ;Reset variable to set to AOT 
		GoSub LiveManual_AlwaysOnTop
		}
	Return
}	
	
	LiveManual_Load_CodeGen:
{
	Gui +OwnDialogs 
	IfExist %A_WorkingDir%\%A_ThisMenuItem%.ahk
		{
		Run %A_WorkingDir%\%A_ThisMenuItem%.ahk
		ExitApp
		}
	IfNotExist %A_WorkingDir%\%A_ThisMenuItem%.ahk
		Msgbox Unable to Locate %A_WorkingDir%\%A_ThisMenuItem%.ahk
Return
}

	LiveManual_About: ;About Pop Up
{
	CreditLine = AHK Live-Manual (v%LiveManual_Version%) - Lucid_Method`n`n%AHKCommand% (v%Command_Version%) - %Manual_Credit%`n`nILButton() by tkoi

	If AHKCommand = MsgBox
		CreditLine = Create MessageBox by Thalon`n`nAHK Live-Manual (v%LiveManual_Version%) by Lucid_Method`n`nAHK Command = %AHKCommand% (v%Command_Version%)
	
	Gui +OwnDialogs 
		Msgbox , 262208, AHK Live-Manual, %CreditLine%
		
	Return
}	

	LiveManual_CopyCode: ;Copy Code to Clipboard
{
	Gui, Submit, NoHide
	Clipboard = 
	;GoSub SubmitCode
	Clipboard = %CodeDisplay%
	TrayTip, Clipboard (%AHKCommand%), %CodeDisplay%, 30, 1
	Return
}	

	LiveManual_Write_Test_AHK: ;Test 
{
FileDelete %TestAHK%

GoSub SubmitCode

FileAppend,
(
#NoEnv
#Persistent
#SingleInstance force

%CodeLine%

ExitApp

), %TestAHK%  ;End of File Append

Run %TestAHK%

Return
}

	LiveManual_AHK_Manual:
{
	AHK_Manual(AHKCommand)	
	Return
}	

	LiveManual_Open_ScriptDir:
{
	Run %A_ScriptDir%
	Return
}	

	LiveManual_Server_Update_Check:
{
	LiveManual_ServerScriptPath = %LiveManual_Update_Server%/%AHKCommand%.ahk  ;Download the Current Command's Editor
	UrlDownloadToFile, %LiveManual_ServerScriptPath%, %A_ScriptFullPath%
	
	LiveManual_IncludeServerPath = %LiveManual_Update_Server%/Lib/LiveManual_Include.ahk ;Download the Include Library for Live-Manual
	UrlDownloadToFile, %LiveManual_IncludeServerPath%, %A_ScriptDir%\Lib\LiveManual_Include.ahk
	
	If ErrorLevel != 1 ;1 if there was a problem, otherwise reload with update
		Reload 
		
	Return
}	
	

;===============================
; Graphics
;===============================

	LiveManual_Define_Icons:
{
	LM_IconPath = %A_ScriptDir%\Lib\ICO
	
	About_ICO = %LM_IconPath%\About.ico
	Clipboard_ICO = %LM_IconPath%\Clipboard.ico	
	Command_ICO = %LM_IconPath%\Command.ico	
	Copy_ICO = %LM_IconPath%\Copy.ico
	Desktop_ICO = %LM_IconPath%\Desktop.ico
	
	Edit_ICO = %LM_IconPath%\Edit.ico
	Edit2_ICO = %LM_IconPath%\Edit2.ico
	Exit_ICO = %LM_IconPath%\Exit.ico
	Folder_ICO = %LM_IconPath%\Folder.ico
	Help_ICO = %LM_IconPath%\Help.ico
	Info_ICO = %LM_IconPath%\Info.ico
	Manual_ICO = %LM_IconPath%\Manual.ico
	Play_ICO = %LM_IconPath%\Play.ico
	Play1_ICO = %LM_IconPath%\Play1t.ico
	Test_ICO = %LM_IconPath%\Test.ico
	Reload_ICO = %LM_IconPath%\Reload.ico
	Refresh_ICO = %LM_IconPath%\Refresh.ico
	Save_ICO = %LM_IconPath%\Save.ico
	SmartGUI_ICO = %LM_IconPath%\SmartGUI+.ico
	
	Return
}	
	

;==============================
; Tray Menu Setup
;==============================

	LiveManual_Build_TrayMenu: 
{
	Menu, Tray, NoStandard  ;Removes Standard Options --- Open/Help/Window Spy/Reload/Edit/Suspend
	Menu, Tray, Click, 1
	
	Menu, AutoHotkey, Standard
	Menu, Tray, Add, &AutoHotkey, :AutoHotkey
	Menu, Tray, Add, 
	Menu, Tray, Add, Display, Toggle_AHKGUI	
	Menu, Tray, Add, Edit, LiveManual_Edit
	Menu, Tray, Add, Reload, LiveManual_Reload
	Menu, Tray, Add, Exit, LiveManual_Exit
	
	Menu, Tray, Default, Display ;Choose the Default Icon-Click Action
	Menu, Tray, Icon, %Manual_ICO%
	
   	Menu, Tray, Tip, AHK Live Manual
	
	;GoSub Setup_Tray_Icons
	Return
}	

	Setup_Tray_Icons: ;Define Icons to Place in Tray Menu
{
	; Icons in the Tray menu!
	; Refer to a menu by handle for efficiency.
	hTM := MI_GetMenuHandle("Tray")
	
	if (A_OSVersion != "WIN_VISTA")
	{   ; It is necessary to hook the tray icon for owner-drawing to work.
		; (Owner-drawing is not used on Windows Vista.)
		OnMessage(0x404, "AHK_NOTIFYICON")
		OnMessage(0x111, "WM_COMMAND") ; To track "pause" status.
		MI_SetMenuStyle(hTM, 0x4000000) ; MNS_CHECKORBMP (optional)
	}
	
	;MI_SetMenuItemIcon(hTM, 1, ClientWare_ICO, 1, 16) 
	;MI_SetMenuItemIcon(hTM, 2, Recording_ICO,   1, 16) 
	MI_SetMenuItemIcon(hTM, 1, Save_ICO, 1, 16) 
	MI_SetMenuItemIcon(hTM, 2, Reload_ICO, 1, 16) 
	MI_SetMenuItemIcon(hTM, 3, Close_ICO, 1, 16)
	;MI_SetMenuItemIcon(hTM, 8, ClientWare_Studio_ICO, 1, 16) 
	;MI_SetMenuItemIcon(hTM, 9, Reload_ICO, 1, 16)
	;MI_SetMenuItemIcon(hTM, 10, Close_ICO, 1, 16)
	
	;MI_SetMenuItemBitmap(hTM, 10, 8) 
Return
}
		AHK_NOTIFYICON(wParam, lParam) ;Used with MI (Icons in Tray Menu)
{
    global hTM, M_IsPaused
    if (lParam = 0x205) ; WM_RBUTTONUP
    {
        ; Update "Suspend Script" and "Pause Script" checkmarks.
        DllCall("CheckMenuItem","uint",hTM,"uint",65305,"uint",A_IsSuspended ? 8:0)
        DllCall("CheckMenuItem","uint",hTM,"uint",65306,"uint",M_IsPaused ? 8:0)
        ; Show menu to allow owner-drawing.
        MI_ShowMenu(hTM)
        return 0
    }
}

		WM_COMMAND(wParam, lParam, Msg, hwnd) ;Used with MI (Icons in Tray Menu)
{
    Critical
    global M_IsPaused
    id := wParam & 0xFFFF
    if id in 65306,65403  ; tray pause, file menu pause
    {
        ; When the script is not paused, WM_COMMAND() is called once for
        ; AutoHotkey --** and once for OwnerDrawnMenuMsgWin **--.
        DetectHiddenWindows, On
        WinGetClass, cl, ahk_id %hwnd%
        if cl != AutoHotkey
            return
       
        ; This will become incorrect if "pause" is used from the script.
        M_IsPaused := ! M_IsPaused
    }
}
	
	Toggle_AHKGUI:
{
	If AHKGUI=
		AHKGUI=Visible

	If AHKGUI=Hidden
		{
		GoSub Show_AHKGUI
		Return
		}
		
	If AHKGUI=Visible
		{
		GoSub Hide_AHKGUI
		Return
		}		
Return
}
	
		Hide_AHKGUI:
{
	Gui, Hide
	AHKGUI=Hidden
	Return
}	

		Show_AHKGUI:
{
	Gui, Show
	AHKGUI=Visible
	Return
}	

	

;===============================
; Basics
;===============================

	LiveManual_Exit:
{
	ExitApp
	Return
}	

	LiveManual_Reload:
{
	Reload
	Return
}

	LiveManual_Edit: ;Edit AHK
{
	NPadOpen(A_ScriptFullPath) 
	Return
}	

	LiveManual_Edit_IncludeFile: ;Edit Include File
{
	EditFile = %A_ScriptDir%\Lib\LiveManual_Include.ahk
	NPadOpen(EditFile) 
	Return
}	
	
	LiveManual_AlwaysOnTop:
{
	If AlwaysOnTop != 1
		{
		Menu, LiveManual_View, Check, AlwaysOnTop
		Gui +AlwaysOnTop
		AlwaysOnTop = 1
		IniWrite, %AlwaysOnTop%, %LiveManualINI%, LiveManual, AlwaysOnTop
		Return
		}
		
	If AlwaysOnTop = 1 ;Already On - Toggle Off
		{
		Menu, LiveManual_View, UnCheck, AlwaysOnTop
		Gui -AlwaysOnTop
		AlwaysOnTop = 0
		IniWrite, %AlwaysOnTop%, %LiveManualINI%, LiveManual, AlwaysOnTop
		Return
		}	

	Return
}	

	LiveManual_Forum_Post:
{
	Run http://www.autohotkey.com/forum/viewtopic.php?p=415860	
	Return
}	


;===============================
; Functions
;===============================

	NPadOpen(filename) ;Function to Open File in Notepad++
{
	Global NotePadPath
	Run "%NotePadPath%" "%filename%"
	Return

}

	ControlInfo() ;Displays GUI Event Info
{
	Gui +OwnDialogs 
	;Value := % %A_GUIControl% ; Value of the Control Listed in A_GUIControl
		Msgbox A_Gui = %A_Gui%`nA_EventInfo = %A_EventInfo%`nA_GuiEvent = %A_GuiEvent%`nA_GuiControl = %A_GuiControl%`nA_ThisMenuItem = %A_ThisMenuItem%`nA_ThisMenu = %A_ThisMenu%`nA_ThisMenuItemPos = %A_ThisMenuItemPos%`nA_ThisHotkey = %A_ThisHotkey%
	Return
}	

	LV_GetSelectedText(FromColumns="", ColumnsDelimiter="`t", RowsDelimiter= "`n") {   ; Extract ListView Text
; By Learning One
; Example:
; SelectedFile := LV_GetSelectedText("1") ;Column 1 Text
	
    if FromColumns =   ; than get text from all columns
   {
      Loop, %   LV_GetCount("Column") ; total number of columns in LV ;%
      FromColumns .= A_Index "|"   
   }
   if (SubStr(FromColumns,0) = "|")
    StringTrimRight, FromColumns, FromColumns, 1
   Loop
    {
        RowNumber := LV_GetNext(RowNumber)
        if !RowNumber
        break
      Loop, parse, FromColumns, |
      {
         LV_GetText(FieldText, RowNumber, A_LoopField)
         Selected .= FieldText ColumnsDelimiter
      }
      if (SubStr(Selected,0) = ColumnsDelimiter)
      StringTrimRight, Selected, Selected, 1
      Selected .= RowsDelimiter
   }
   if (SubStr(Selected,0) = RowsDelimiter)
    StringTrimRight, Selected, Selected, 1
    return Selected
}

	AHK_Manual(SearchTerm) ;Lookup AHK Terms in AHK Manual
{
;====================================================================================
; AHK_Manual Section Loader - Lucid_Method
;====================================================================================

;Determine AHK Manual Path (by Rajat)
        if A_AhkPath
            SplitPath, A_AhkPath,, ahk_dir
        else IfExist ..\..\AutoHotkey.chm
            ahk_dir = ..\..
        else IfExist %A_ProgramFiles%\AutoHotkey\AutoHotkey.chm
            ahk_dir = %A_ProgramFiles%\AutoHotkey
        else
        {
            MsgBox Could not find the AutoHotkey folder.
            return
        }
    
	CHM_Path = %ahk_dir%\AutoHotkey.chm
	StringReplace, SearchTerm, SearchTerm, #, _
	SearchTerm = /docs/commands/%SearchTerm%.htm
	
	
	If SearchTerm = /docs/commands/Loop_FilePattern.htm
		SearchTerm = /docs/commands/LoopFile.htm	
	
	If SearchTerm = /docs/commands/Built_In_Variables.htm
		SearchTerm = /docs/Variables.htm#BuiltIn

	;Msgbox SearchTerm = %SearchTerm%
	;::/docs/commands/_Persistent.htm
	
	
	IfExist %CHM_Path%
		Run, hh %CHM_Path%::%SearchTerm%
	
Return
}


;===============================
; Testing
;===============================

	INITest:
{
	IniRead, Version, %A_ScriptFullPath%, VersionInfo, LiveManual_Version, %A_Space%
	Msgbox Version = %Version%
	Return
}	


;===============================
; GUI Events
;===============================

	GuiClose:
{
FileDelete %TestAHK%
ExitApp
}


#Include Lib\MI.ahk
#Include Lib\ILButton.ahk

