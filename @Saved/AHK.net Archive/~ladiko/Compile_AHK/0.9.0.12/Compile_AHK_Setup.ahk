; ------------------------------------------------------------------------------
; AutoHotkey Version:	1.0.47.04
; Language:				Deutsch // English
; Platform:				Win2k // WinXP // WinVista
; Author:				<= 1.00 @ denick // >= 1.10 @ ladiko
; Version:				1.10 // 2007-09-09 // ladiko
; Script Function:		Compile_AHK Setup
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
s_GUITITLE := "Compile_AHK Setup"
s_SELECT := "Please select AHK \Compiler folder"
s_WELCOME := "Welcome to the Compile_AHK Setup"
s_SETUPOK := "Compile_AHK Setup was done successfully!"
s_COMPILE_AHK := A_Tab . "Compile_AHK.exe"
s_GORC := A_Tab . "GoRC.exe"
s_RESHACKER := A_Tab . "ResHacker.exe"
s_REGISTRY := "Add Compile with Options to AHK context menu"

IF A_OSVersion = WIN_VISTA
   {
   s_INSTALL_DIR := A_AppDataCommon . "\AutoHotKey\Compiler"
   s_INSTALL_DIR_ANZEIGE := A_AppDataCommon . "\AutoHotKey\Compiler"
   }
Else
   {
   StringSplit, s_INSTALL_DIR_, A_AppDataCommon, \
   s_INSTALL_DIR_ANZEIGE = %s_INSTALL_DIR_1%\%s_INSTALL_DIR_2%...`n%A_Tab%%A_Tab%\%s_INSTALL_DIR_3%\%s_INSTALL_DIR_4%...`n%A_Tab%%A_Tab%%A_Tab%%A_Tab%\AutoHotKey\Compiler
   s_INSTALL_DIR := s_INSTALL_DIR_1 "\" s_INSTALL_DIR_2 "\" s_INSTALL_DIR_3 "\" s_INSTALL_DIR_4 . "\AutoHotKey\Compiler"
   }
s_AHK_ERROR =
(
Could not find the AutoHotkey installation folder!

Run the AutoHotkey Setup and try again, please.
)
s_SETUP =
(

 This setup will install

 Compile_AHK.exe
 GoRC.exe
 ResHacker.exe

 into

 %s_INSTALL_DIR_ANZEIGE%.

 ResHacker is Copyright © 1999-2004 Angus Johnson
 http://www.angusj.com/resourcehacker/
 GoRC is Copyright © Jeremy Gordon 1997-2006 [MrDuck Software]
 http://www.jorgon.freeserve.co.uk/ResourceFrame.htm

 Click Next to continue.
 
)
; ------------------------------------------------------------------------------
; Variable
; ------------------------------------------------------------------------------
GUI2_CB_1 := 1
GUI2_CB_2 := 1
GUI2_CB_3 := 1
GUI2_CB_4 := 1
; ------------------------------------------------------------------------------
; Start
; ------------------------------------------------------------------------------
SetBatchLines, -1
SetWinDelay, 0
SetWorkingDir %A_ScriptDir%

If !FileExist(A_AHKPath) {
	MsgBox, 262160, %s_GUITITLE%, %s_AHK_ERROR%
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
Gui, Margin, 20, 20
Gui, Font, s9, Verdana
Gui, Add, Text, vText1, %s_SETUP%
GuiControlGet, Text1, Pos
_W := Text1W + 10
_H := Text1H + 10
Gui, Destroy
Gui, +AlwaysOnTop -SysMenu +Owner +LabelGUI1
Gui, Margin, 20, 20
Gui, Font, s12 cNavy, Verdana
Gui, Add, Text, Center w%_W%, %s_WELCOME%
Gui, Font, s9
Gui, Add, Progress, xp y+20 wp h%_H% 0x1000 BackgroundWhite
Gui, Add, Text, xp+5 yp+5 BackgroundTrans, %s_SETUP%
Gui, Font, s10
Gui, Add, Button, Default xm w60 gGUI1_BT_NEXT, Next >
_X := _W + 20 - 60
Gui, Add, Button, x%_X% yp wp gGUI1Close, Cancel
Gui, Show, Autosize, % s_GUITITLE
Return
; ------------------------------------------------------------------------------
; Gui1 Close
; ------------------------------------------------------------------------------
GUI1Close:
Gui, Destroy
ExitApp
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
Gui, 2:default
Gui, +AlwaysOnTop -SysMenu +LabelGUI2
Gui, Margin, 20, 20
Gui, Font, s10 cBlack, Arial
Gui, Font, cNavy

IF A_OSVersion = WIN_VISTA
	{
	Gui, Add, GroupBox, x20 y20 w400 h60, Compiler Directory
	Gui, Font, cBlack
	Gui, Add, Text, xp+10 yp+25 h20, %s_INSTALL_DIR_ANZEIGE%
	Gui, Font, cNavy
	Gui, Add, GroupBox, x20 y+30 w400 h95, Install Components
	}
Else
	{
	Gui, Add, GroupBox, x20 y20 w400 h90, Compiler Directory
	Gui, Font, cBlack
	Gui, Add, Text, xp+10 yp+25 h20, %s_INSTALL_DIR_ANZEIGE%
	Gui, Font, cNavy
	Gui, Add, GroupBox, x20 y+35 w400 h95, Install Components
	}
Gui, Font, cBlack
Gui, Add, Checkbox, xp+10 yp+25 h20 Checked Disabled vGUI2_CB_1, % s_COMPILE_AHK . " (essential component)"
Gui, Add, Checkbox, xp yp+20 h20 Checked vGUI2_CB_2, % s_GORC
Gui, Add, Checkbox, xp yp+20 h20 Checked vGUI2_CB_3, % s_RESHACKER
Gui, Font, cNavy
Gui, Add, GroupBox, x20 y+30 w400 h60, Registry Settings
Gui, Font, cBlack
Gui, Add, Checkbox, xp+10 yp+25 h20 Checked vGUI2_CB_4, % s_REGISTRY
Gui, Add, Button, Default x20 y340 w60 gGUI2_BT_OK, Setup
Gui, Add, Button, gGUI2Close x+280 yp w60, Cancel
Gui, Show, Autosize, %s_GUITITLE%
GuiControl, Focus, Setup
Return
; ------------------------------------------------------------------------------
; Gui2 Close
; ------------------------------------------------------------------------------
GUI2Close:
Gui, Destroy
ExitApp
; ------------------------------------------------------------------------------
; Gui2 Button Setup
; ------------------------------------------------------------------------------
GUI2_BT_OK:
Gui, 2:Default
Gui, +OwnDialogs
Gui, Submit, NoHide
_Install()
MsgBox, 262208, %s_GUITITLE%, %s_SETUPOK%
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
	If Not FileExist(s_INSTALL_DIR) {
		FileCreateDir, %s_INSTALL_DIR%
		If (ErrorLevel) {
			sMSG := "Couldn't create " . s_INSTALL_DIR . "!`n`nSetup will exit!"
			MsgBox, 262160, %s_GUITITLE%, %sMSG%
			Gui, Destroy
			ExitApp
		}
	}
	If (GUI2_CB_1) {
		FileInstall, Compile_AHK.exe, %s_INSTALL_DIR%\Compile_AHK.exe, 1
		If (ErrorLevel) {
			_Install_Error("Compile_AHK.exe")
		}
	}
	If (GUI2_CB_2) {
		FileInstall, GoRC.exe, %s_INSTALL_DIR%\GoRC.exe,1
		If (ErrorLevel) {
			_Install_Error("GoRC.exe")
		}
	}
	If (GUI2_CB_3) {
		FileInstall, ResHacker.exe, %s_INSTALL_DIR%\ResHacker.exe,1
		If (ErrorLevel) {
			_Install_Error("ResHacker.exe")
		}
	}
	If (GUI2_CB_4) {
		_Set_Registry()
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
			, , "%s_INSTALL_DIR%\Compile_AHK.exe" "`%l"
	If (ErrorLevel) {
		sMSG := "Couldn't write Registry Settings!`n`nSetup will exit!"
		MsgBox, 262160, %s_GUITITLE%, %sMSG%
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

	%s_INSTALL_DIR%

	Setup will exit!
	)
	MsgBox, 262160, %s_GUITITLE%, %sMSG%
	Gui, Destroy
	ExitApp
}
