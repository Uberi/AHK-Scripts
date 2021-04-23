; ------------------------------------------------------------------------------
; AutoHotkey Version:  1.0.45.04
; Language:            English
; Platform:            WinXP
; Author:              denick
; Version:             1.00/12006-11-18/denick
; Script Function:     Compile_AHK Setup
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
s_GUITITLE := "    Compile_AHK Setup"
s_SELECT := "Please select AHK \Compiler folder"
s_WELCOME := "Welcome to the Compile_AHK Setup"
s_SEL_ERROR =
(
The chosen folder %sDir%

does not contain the Compiler Ahk2Exe.exe.

Select again, please.
)
s_SETUP =
(

 This setup will install

 Compile_AHK.exe
 GoRC.exe
 ResHacker.exe

 into your AHK \Compiler directory.

 ResHacker is Copyright © 1999-2004 Angus Johnson
 http://www.angusj.com/resourcehacker/
 GoRC is Copyright © Jeremy Gordon 1997-2006 [MrDuck Software]
 http://www.jorgon.freeserve.co.uk/ResourceFrame.htm

 Click Next to continue.
)
s_SETUPOK := "Compile_AHK Setup was done successfully!"
s_COMPILE_AHK := "   Compile_AHK.exe"
s_GORC := "   GoRC.exe"
s_RESHACKER := "   ResHacker.exe"
s_REGISTRY := "   Add ""Compile with Options"" to AHK context menu"
; ------------------------------------------------------------------------------
; Variable
; ------------------------------------------------------------------------------
GUI2_TX_1 := ""
GUI2_CB_1 := 0
GUI2_CB_2 := 0
GUI2_CB_3 := 0
GUI2_CB_4 := 0
s_CMP_DIR := ""
; ------------------------------------------------------------------------------
; Start
; ------------------------------------------------------------------------------
SetBatchLines, -1
SetWinDelay, 0
SetWorkingDir %A_ScriptDir%
s_CMP_DIR := _Get_AHK_Path()
Gosub, GUI1_SHOW
Return
; ==============================================================================
; GUI 1 SECTION ================================================================
; ==============================================================================
; ------------------------------------------------------------------------------
; Gui1 Show
; ------------------------------------------------------------------------------
GUI1_SHOW:
Gui, +AlwaysOnTop -SysMenu +LabelGUI1
Gui, Margin, 20, 20
Gui, Font, s16 cNavy, Arial
Gui, Add, Text, Center x20 y20 w400 h30, %s_WELCOME%
Gui, Font, s9 cBlack
Gui, Add, Progress, xp y+20 w400 h250 0x1000 BackgroundWhite
Gui, Add, Text, xp+5 yp+5 w390 h240 BackgroundTrans, %s_SETUP%
Gui, Font, s10
Gui, Add, Button, Default x20 y340 w60 gGUI1_BT_NEXT, Next >
Gui, Add, Button, gGUI1Close x+280 yp w60, Cancel
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
Gui, Add, GroupBox, x20 y20 w400 h60, Compiler Directory
Gui, Font, cBlack
Gui, Add, Text, xp+10 yp+25 w300 h20 0x1000 vGUI2_TX_1, %s_CMP_DIR%
Gui, Add, Button, x+20 yp w60 h20 gGUI2_BT_SEL, Select
Gui, Font, cNavy
Gui, Add, GroupBox, x20 y+30 w400 h95, Install Compoments
Gui, Font, cBlack
Gui, Add, Checkbox, xp+10 yp+25 h20 vGUI2_CB_1, % s_COMPILE_AHK
Gui, Add, Checkbox, xp yp+20 h20 vGUI2_CB_2, % s_GORC
Gui, Add, Checkbox, xp yp+20 h20 vGUI2_CB_3, % s_RESHACKER
Gui, Font, cNavy
Gui, Add, GroupBox, x20 y+30 w400 h60, Registry Settings
Gui, Font, cBlack
Gui, Add, Checkbox, xp+10 yp+25 h20 vGUI2_CB_4, % s_REGISTRY
Gui, Add, Button, Default x20 y340 w60 gGUI2_BT_OK, Setup
Gui, Add, Button, gGUI2Close x+280 yp w60, Cancel
Gui, Show, Autosize, % s_GUITITLE
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
GuiControlGet, GUI2_TX_1, , GUI2_TX_1
If (GUI2_TX_1 = "") {
   MsgBox, 262192, %s_GUITITLE%, %s_SELECT%!
   Return
}
_Install()
If (GUI2_CB_4) {
   _Set_Registry()
}
MsgBox, 262208, %s_GUITITLE%, %s_SETUPOK%
Gui, Destroy
ExitApp
; ------------------------------------------------------------------------------
; Gui2 Button Select
; ------------------------------------------------------------------------------
GUI2_BT_SEL:
Gui, 2:Default
Gui, +OwnDialogs
_Select_AHK_Path()
Return
; ==============================================================================
; FUNCTIONS SECTION ============================================================
; ==============================================================================
; ------------------------------------------------------------------------------
; Get AHK Path
; ------------------------------------------------------------------------------
_Get_AHK_Path()
{
   Global
   Local sDir
   If (A_AhkPath = "") {
      Return ""
   }
   SplitPath, A_AhkPath, , sDir
   If FileExist(sDir "\Compiler\Ahk2Exe.exe") {
      Return sDir . "\Compiler"
   }
   Return ""
}
; ------------------------------------------------------------------------------
; Select AHK Path
; ------------------------------------------------------------------------------
_Select_AHK_Path()
{
   Global
   Local sDir
   Loop
   {
      FileSelectFolder, sDir, *%A_ProgramFiles%, 0, %s_SELECT%:
      If (sDir = ""){
         Break
      }
      If (!FileExist(sDir . "\Ahk2Exe.exe")) {
         MsgBox, 262192, %s_GUITITLE%, %s_SEL_ERROR%
      } Else {
         GuiControl, , GUI2_TX_1, %sDir%
         Break
      }
   }
   Return
}
; ------------------------------------------------------------------------------
; Install Files
; ------------------------------------------------------------------------------
_Install()
{
   Global
   Local sDir
   sDir := GUI2_TX_1
   If (GUI2_CB_1) {
      FileInstall, Compile_AHK.exe, %sDir%\Compile_AHK.exe, 1
      If (ErrorLevel) {
         _Install_Error("Compile_AHK.exe")
      }
   }
   If (GUI2_CB_1) {
      FileInstall, GoRC.exe, %sDir%\GoRC.exe,1
      If (ErrorLevel) {
         _Install_Error("GoRC.exe")
      }
   }
   If (GUI2_CB_1) {
      FileInstall, ResHacker.exe, %sDir%\ResHacker.exe,1
      If (ErrorLevel) {
         _Install_Error("ResHacker.exe")
      }
   }
   Return
}
; ------------------------------------------------------------------------------
; Set Registry
; ------------------------------------------------------------------------------
_Set_Registry()
{
   Global
   Local sDir, sMSG
   sDir := GUI2_TX_1
   RegWrite, REG_SZ
         , HKEY_CLASSES_ROOT
         , AutoHotkeyScript\Shell\Compile_AHK
         , , Compile with Options
   RegWrite, REG_SZ
         , HKEY_CLASSES_ROOT
         , AutoHotkeyScript\Shell\Compile_AHK\Command
         , , "%sDir%\Compile_AHK.exe" /in "`%l"
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
   
   %GUI2_TX_1%
   
   Setup will exit!
   )
   MsgBox, 262160, %s_GUITITLE%, %sMSG%
   Gui, Destroy
   ExitApp
}
