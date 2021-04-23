; ------------------------------------------------------------------------------
; AutoHotkey Version : 1.0.47.05
; Language           : Deutsch // English
; Platform           : Win2k // WinXP // WinVista
; Author             : <= 1.00 @ denick // >= 1.10 @ ladiko
; Version            : 1.10 // 2007-09-09 // ladiko
; Script Function    : Compile_AHK Setup
; ------------------------------------------------------------------------------
; ==============================================================================
; AUTO EXECUTE SECTION =========================================================
; ==============================================================================
; ------------------------------------------------------------------------------
; AutoHotkey Directives
; ------------------------------------------------------------------------------
#SingleInstance Force
#NoEnv
#NoTrayIcon
; ------------------------------------------------------------------------------
; Constants
; ------------------------------------------------------------------------------
s_GuiTitle := " Compile_AHK Setup"
s_Welcome := "Welcome to the Compile_AHK Setup"
s_SetupOk := "Compile_AHK Setup was done successfully!"
s_Compile_AHK := "Compile_AHK.exe"
s_GoRC := "GoRC.exe"
s_ResHacker := "ResHacker.exe"
s_Registry := "Add ""Compile with Options"" to AHK context menu"
s_DeskLnk := "Add Shortcut to the desktop"
s_MenuLnk := "Add Shortcut to the start menu"
s_InstallDir := A_ProgramFiles . "\AutoHotkey\Compiler"
; lookup registry for old install path
RegRead , s_LastInstallDir , HKCR , AutoHotkeyScript\Shell\Compile_AHK\Command
If !Errorlevel
{
	s_LastInstallDir := PathGetPath(s_LastInstallDir)
	IfExist , %s_LastInstallDir%
		SplitPath, s_LastInstallDir , , s_InstallDir
}
Else
{
	RegRead , s_AHKInstallDir , HKCR , AutoHotkeyScript\Shell\Compile\Command
	If !Errorlevel
	{
		s_AHKInstallDir := PathGetPath(s_AHKInstallDir)
		IfExist , %s_AHKInstallDir%
			SplitPath, s_AHKInstallDir , , s_InstallDir
	}
}

s_AHK_Error := "Could not find the AutoHotkey installation folder!`n`n"
				. "Run the AutoHotkey Setup and try again, please."
				
s_Setup := "`nThis setup will install`n`n"
			. "Compile_AHK.exe (essential component)`n"
			. "GoRC.exe`n"
			. "ResHacker.exe`n`n"
			. "into`n`n"
			. s_InstallDir . ".`n`n"
			. "ResHacker is Copyright © 1999-2004 Angus Johnson`n"
			. "http://www.angusj.com/resourcehacker/`n`n"
			. "GoRC is Copyright © Jeremy Gordon 1997-2006 [MrDuck Software]`n"
			. "http://www.jorgon.freeserve.co.uk/ResourceFrame.htm`n`n"
			. "Click Next to continue.`n"
s_Setup1 := "`nThis setup will install`n`n"
			. "Compile_AHK.exe (essential component)`n"
			. "GoRC.exe`n"
			. "ResHacker.exe`n`n"
			. "into`n`n"
			. s_InstallDir . ".`n`n"
			. "ResHacker is Copyright © 1999-2004 Angus Johnson`n"
s_ResHackerURL := "http://www.angusj.com/resourcehacker/"

s_Setup2 := "GoRC is Copyright © Jeremy Gordon 1997-2006 [MrDuck Software]`n`n`n"
s_GoRC_URL := "http://www.jorgon.freeserve.co.uk/ResourceFrame.htm"

s_Setup3 := "Click Next to continue.`n"


 
; ------------------------------------------------------------------------------
; Variable
; ------------------------------------------------------------------------------
GUI2_CB_1 := 1
GUI2_CB_2 := 1
GUI2_CB_3 := 1
GUI2_CB_4 := 1
GUI2_CB_4 := 0
GUI2_CB_4 := 0
; ------------------------------------------------------------------------------
; Start
; ------------------------------------------------------------------------------
SetBatchLines, -1
SetWinDelay, 0
SetWorkingDir %A_ScriptDir%

If !FileExist(A_AHKPath) {
	MsgBox, 262160, %s_GuiTitle%, %s_AHK_Error%
	ExitApp
}
Gosub, GUI1_SHOW
Return

; ==============================================================================
; GUI 1 SECTION ================================================================
; ==============================================================================
; ------------------------------------------------------------------------------
; Gui1 Show
; ------------------------------------------------------------------------------
GUI1_SHOW:
	; white areas , progress bars: above , left , under , right
	Gui, Color, White
	Gui, Margin, 0, 0
	Gui, Add, Progress, Disabled x0 y0 w357 h17 cF0F0F0 , 100
	Gui, Add, Progress, Disabled x0 y0 w11 h310 cF0F0F0 , 100
	Gui, Add, Progress, Disabled x0 y277 w357 h33 cF0F0F0 , 100
	Gui, Add, Progress, Disabled x347 y0 w10 h310 cF0F0F0 , 100
	
	Gui, Add, GroupBox, x10 y10 w338 h268 , %s_Welcome%

	Gui, Add, Text, xp+10 yp+15, %s_Setup1%
	Gui, Add, Text, yp+156 gOpenLink vURL_ResHacker , %s_ResHackerURL%
	
	Gui, Add, Text, yp+26 , %s_Setup2%
	Gui, Add, Text, yp+13 gOpenLink vURL_GoRC , %s_GoRC_URL%
	
	Gui, Add, Text, yp+26 , %s_Setup3%
	
	Gui, Add, Button, Default x10 y+10 w60 gGUI1_BT_NEXT, Next >
	Gui, Add, Button, x288 yp wp gGUI1Close, Cancel
	Gui, Show, Autosize, %s_GuiTitle%
	
	; Retrieve unique ID number (HWND/handle)
	Gui +LastFound
	WinGet, hw_gui, ID
 
	; Call "HandleMessage" when script receives WM_SETCURSOR message
	WM_SETCURSOR = 0x20
	OnMessage(WM_SETCURSOR, "HandleMessage")
 
	; Call "HandleMessage" when script receives WM_MOUSEMOVE message
	WM_MOUSEMOVE = 0x200
	OnMessage(WM_MOUSEMOVE, "HandleMessage")
Return

; ------------------------------------------------------------------------------
; Gui1 Close
; ------------------------------------------------------------------------------
GUI1Close:
	Gui, Destroy
	ExitApp
Return

; ------------------------------------------------------------------------------
; Gui1 Button Next
; ------------------------------------------------------------------------------
GUI1_BT_NEXT:
	Gui, Destroy
	Gosub, GUI2_SHOW
Return

; ==============================================================================
; GUI 2 SECTION ================================================================
; ==============================================================================
; ------------------------------------------------------------------------------
; Gui2 Show
; ------------------------------------------------------------------------------
GUI2_SHOW:
	
	Gui, Add, GroupBox, x10 y10 w338 h60, Compiler Directory
	Gui, Add, Edit, xp+10 yp+25 w270 r1 vGUI2_INSTALL_DIR, %s_InstallDir%
	Gui, Add, Button, x+5 gReset , «
	Gui, Add, Button, x+5 gINSTALL_DIR, ...

	Gui, Add, GroupBox, x10 y+20 w338 h96, Install Components
	Gui, Add, Checkbox, xp+10 yp+25 h20 Checked Disabled vGUI2_CB_1, % s_Compile_AHK . " (essential component)"
	Gui, Add, Checkbox, xp yp+20 h20 Checked vGUI2_CB_2, %s_GoRC%
	Gui, Add, Checkbox, xp yp+20 h20 Checked vGUI2_CB_3, %s_ResHacker%

	Gui, Add, GroupBox, x10 y+20 w338 h96, Shortcut Settings
	Gui, Add, Checkbox, xp+10 yp+25 h20 Checked vGUI2_CB_4, % s_Registry
	Gui, Add, Checkbox, xp yp+20 h20 vGUI2_CB_5, % s_DeskLnk
	Gui, Add, Checkbox, xp yp+20 h20 vGUI2_CB_6, % s_MenuLnk

	Gui, Add, Button, Default x10 y+20 w60 gGUI2_BT_OK, Setup
	Gui, Add, Button, gGUI2Close x288 yp w60, Cancel
	Gui, Show, Autosize, %s_GuiTitle%
	GuiControl, Focus, Setup
Return
; ------------------------------------------------------------------------------
; Gui2 Close
; ------------------------------------------------------------------------------
GUI2Close:
Gui, Destroy
ExitApp

; ------------------------------------------------------------------------------
; Gui2 - Reset
; ------------------------------------------------------------------------------
Reset:
	GuiControl,, GUI2_INSTALL_DIR, %A_ProgramFiles%\AutoHotkey\Compiler
Return
; ------------------------------------------------------------------------------
; Gui2 - INSTALL_DIR
; ------------------------------------------------------------------------------
INSTALL_DIR:
	Gui, Submit , NoHide
	Gui, +OwnDialogs
	FileSelectFolder, s_InstallDir_NEW, *%s_InstallDir%, 1, Compiler Directory
	If s_InstallDir_NEW !=
	{
		s_InstallDir := s_InstallDir_NEW
		GuiControl,, GUI2_INSTALL_DIR, %s_InstallDir%
	}
Return
; ------------------------------------------------------------------------------
; Gui2 Button Setup
; ------------------------------------------------------------------------------
GUI2_BT_OK:
	Gui, +OwnDialogs
	Gui, Submit, NoHide
	s_InstallDir := GUI2_INSTALL_DIR
	_Install()
	MsgBox, 262208, %s_GuiTitle%, %s_SetupOk%
	Gui, Destroy
ExitApp
; ==============================================================================
; FUNCTIONS SECTION ============================================================
; ==============================================================================
; ------------------------------------------------------------------------------
; Install Files
; ------------------------------------------------------------------------------
_Install()
{
	Global
	Local sMsg
	If Not FileExist(s_InstallDir) {
		FileCreateDir, %s_InstallDir%
		If (ErrorLevel) {
			sMSG := "Couldn't create " . s_InstallDir . "!`n`nSetup will exit!"
			MsgBox , 262160, %s_GuiTitle%, %sMSG%
			Gui, Destroy
			ExitApp
		}
	}
	If (GUI2_CB_1) {
		FileInstall, Compile_AHK.exe, %s_InstallDir%\Compile_AHK.exe, 1
		If (ErrorLevel) {
			_Install_Error("Compile_AHK.exe")
		}
	}
	If (GUI2_CB_2) {
		FileInstall, GoRC.exe, %s_InstallDir%\GoRC.exe,1
		If (ErrorLevel) {
			_Install_Error("GoRC.exe")
		}
	}
	If (GUI2_CB_3) {
		FileInstall, ResHacker.exe, %s_InstallDir%\ResHacker.exe,1
		If (ErrorLevel) {
			_Install_Error("ResHacker.exe")
		}
	}
	If (GUI2_CB_4) {
		_Set_Registry()
	}
	If (GUI2_CB_5) {
		If A_IsAdmin
			PlaceShortCut(A_DesktopCommon , s_InstallDir . "\Compile_AHK.exe")
		Else
			PlaceShortCut(A_Desktop,s_InstallDir . "\Compile_AHK.exe")
	}
	If (GUI2_CB_6) {
		If A_IsAdmin
			PlaceShortCut(A_StartMenuCommon , s_InstallDir . "\Compile_AHK.exe")
		Else
			PlaceShortCut(A_StartMenu , s_InstallDir . "\Compile_AHK.exe")
	}
	Return
}
; ------------------------------------------------------------------------------
; Set Registry
; ------------------------------------------------------------------------------
_Set_Registry()
{
	Global
	Local sMSG
	RegWrite, REG_SZ
			, HKEY_CLASSES_ROOT
			, AutoHotkeyScript\Shell\Compile_AHK
			, , Compile with Options
	RegWrite, REG_SZ
			, HKEY_CLASSES_ROOT
			, AutoHotkeyScript\Shell\Compile_AHK\Command
			, , "%s_InstallDir%\Compile_AHK.exe" "`%l"
	If (ErrorLevel) {
		sMSG := "Couldn't write Registry Settings!`n`nSetup will exit!"
		MsgBox, 262160, %s_GuiTitle%, %sMSG%
		Gui, Destroy
		ExitApp
	}
	Return
}
; ------------------------------------------------------------------------------
; Place Shortcut
; ------------------------------------------------------------------------------
PlaceShortCut(s_ShortcutDir , s_Target)
{
	Global
	Local blubb
	SplitPath , s_Target , , , , s_TargetNoExt
	IfExist , %s_ShortcutDir%\AutoHotkey
		s_ShortcutDir = %s_ShortcutDir%\AutoHotkey
	FileCreateShortcut, %s_Target% , %s_ShortcutDir%\%s_TargetNoExt%.lnk , %A_Temp% , , Compile AutoHotkey Scripts with Options
	If (ErrorLevel)
	{
		sMSG := "Couldn't set up a shortcut file in " . s_ShortcutDir . "!`n`nSetup will exit!"
		MsgBox, 262160, %s_GuiTitle%, %sMSG%
		Gui, Destroy
		ExitApp
	}
	Return
}
; ------------------------------------------------------------------------------
; Install Error
; ------------------------------------------------------------------------------
_Install_Error(sAPP)
{
	Global
	Local sMSG
	sMSG =
	(
	Couldn't write %sAPP% into

	%s_InstallDir%\

	Setup will exit!
	)
	MsgBox, 262160, %s_GuiTitle%, %sMSG%
	Gui, Destroy
	ExitApp
}
OpenLink:
	If A_GuiControl = URL_ResHacker
		Run, http://www.angusj.com/resourcehacker/
	Else If A_GuiControl = URL_GoRC
		Run, http://www.jorgon.freeserve.co.uk/ResourceFrame.htm
Return
; --------------------------------------------------------------------------------
; URL Function
; --------------------------------------------------------------------------------
HandleMessage(p_w, p_l, p_m, p_hw)
{
	global WM_SETCURSOR, WM_MOUSEMOVE,
	static URL_hover, h_cursor_hand, h_old_cursor, CtrlIsURL, LastCtrl
	If (p_m = WM_SETCURSOR)
	{
		If URL_hover
			Return, true
	}
	Else If (p_m = WM_MOUSEMOVE)
	{
		; Mouse cursor hovers URL text control
		StringLeft, CtrlIsURL, A_GuiControl, 3
		If (CtrlIsURL = "URL")
			{
				If URL_hover=
				{
					Gui, Font, cBlue underline
					GuiControl, Font, %A_GuiControl%
					LastCtrl = %A_GuiControl%

					h_cursor_hand := DllCall("LoadCursor", "uint", 0, "uint", 32649)

					URL_hover := true
				}
				h_old_cursor := DllCall("SetCursor", "uint", h_cursor_hand)
			}
		; Mouse cursor doesn't hover URL text control
		Else
		{
			If URL_hover
			{
				Gui, Font, norm cBlack
				GuiControl, Font, %LastCtrl%

				GuiControlGet, T, , %LastCtrl% ; get current text
				GuiControl, , %LastCtrl%, %T% ; rewrite text in normal font

				DllCall("SetCursor", "uint", h_old_cursor)

				URL_hover=
			}
		}
	}
}

PathGetPath(pSourceCmd)
{
	 Local Path, ArgsStartPos = 0
	 
	 If (SubStr(pSourceCmd, 1, 1) = """")
		  Path := SubStr(pSourceCmd, 2, InStr(pSourceCmd, """", False, 2) - 2)
	 Else
	 {
		  ArgsStartPos := InStr(pSourceCmd, " ")
		  If ArgsStartPos
				Path := SubStr(pSourceCmd, 1, ArgsStartPos - 1)
		  Else
				Path = %pSourceCmd%
	 }
	 Return Path
}

GuiClose:
GuiEscape:
	ExitApp
Return