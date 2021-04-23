/*
======================================================
Battlefield 2 HitFixer 
by WaltBerkman
Contact: DupaSoftware@gmail.com
Info: http://forums.bf2s.com/viewtopic.php?id=104544&p=1
======================================================
*/

SendMode Input 
#Persistent
#NoEnv 
#SingleInstance force
#InstallKeybdHook

programName=Battlefield HitFixer
CurrentVersion := 2.0
LowestCompatibleIniVersion := 2.0
v_WindowWidth := 340  ;Width of Main Window, used for scalable GUI
v_WindowHeight := 470  ;Height of Main Window, used for scalable GUI

GoSub CreateIni
GoSub ReadIni
GoSub DownloadIcon

   FileGetSize, Temp02, %A_ProgramFiles%\HitFixer\HitFixerIcon.ico
   if (Temp02 != 0) and (Temp02 != "")
      Menu Tray, Icon, %A_ProgramFiles%\HitFixer\HitFixerIcon.ico

GoSub BuildMainGui
if v_AutoRunOnStart
   GoSub RunBFSoap

HotKey ~%v_HitFixKey%, Hitregfix, On UseErrorLevel

/*
======================================================
Tray Menu 
======================================================
*/

Menu, Tray, Tip, %programName% %CurrentVersion%
Menu, Tray, NoStandard
Menu Tray, Add, About, About
Menu, Tray, Add 
Menu, Tray, Add, Hide, GeneralHideButton
Menu, Tray, Add, Show, GeneralShowButton
Menu, Tray, Disable, Show
Menu, Tray, Default, Show
Menu, Tray, Add 
Menu, Tray, Add 
Menu, Tray, Add, Exit, Exit 

if v_AutoUpdateOnStart
{
   StartupUpdateCheck := 1
   GoSub CheckforUpdates
}
return


/*
======================================================
Tray Menu Actions
======================================================
*/

GeneralHideButton:
   Gui, 6:Submit
   Gui, 6:Hide
   Menu, Tray, Disable, Hide
   Menu, Tray, Enable, Show
return

GeneralShowButton:
   Gui, 6:Show
   Menu, Tray, Disable, Show
   Menu, Tray, Enable, Hide
return


/*
======================================================
About Page
======================================================
*/

About:

   v_AboutPageWidth := 320
   v_AboutPageHeight := 350
   Gui 91:Destroy
   Gui 91: -MaximizeBox +Theme +ToolWindow +AlwaysonTop
   Gui 91:Font, ;bold
      YPosition := 15
   FileGetSize, Temp02, %A_ProgramFiles%\HitFixer\HitFixerIcon.ico
   if (Temp02 != 0) and (Temp02 != "")
   {
      v_AboutPageHeight := 400
      TempX := (v_AboutPageWidth/2) - 64
      Gui, 91: Add, Picture, w128 h128 x%TempX% y%YPosition% vv_AboutPageIcon, %A_ProgramFiles%\HitFixer\HitFixerIcon.ico
      YPosition += 135
   }

      XPosition := 8
      TempH := v_AboutPageHeight - 195
      TempW := v_AboutPageWidth - 16
   Gui, 91:Add, GroupBox, x%XPosition% y%YPosition% w%TempW% h%TempH%,
      YPosition += 25
      XPosition := 22
      TempX := v_AboutPageWidth - 120 -22
   Gui, 91:Add, Text, x%XPosition% y%YPosition%, %programName% %CurrentVersion% by WaltBerkman
      YPosition += 18
   Gui, 91:Add, Text, x%XPosition% y%YPosition%, DupaSoftware@gmail.com
      YPosition += 45
      TempX := (v_AboutPageWidth/2) - 60
   Gui, 91:Add, Button, x%TempX% y%YPosition% w120 h23 gLaunchContactEmail, Contact Email
      YPosition += 28
   Gui, 91:Add, Button, x%TempX% y%YPosition% w120 h23 gLaunchHitFixThread, View Website

      TempX := v_AboutPageWidth - 80 - 8
      TempY := v_AboutPageHeight - 32
      Gui 91:Add, Button,x%TempX% y%TempY% w80 h23 gCloseAboutWindow, OK
      Gui 91:Show, w%v_AboutPageWidth% h%v_AboutPageHeight%, About %programName% %CurrentVersion%
return

LaunchContactEmail:
   Run mailto:dupasoftware@gmail.com
return

LaunchHitFixThread:
   Run http://forums.bf2s.com/viewtopic.php?id=104544
return

CloseAboutWindow:
   Gui 91:Destroy
return


/*
======================================================
Download Graphics
======================================================
*/

DownloadIcon:

   FileGetSize, Temp02, %A_ProgramFiles%\HitFixer\HitFixerIcon.ico
   if (Temp02 = 0) or (Temp02 = "")
   {
      Gui, 90:Destroy
      Gui, 90:Font
      Gui, 90: -MaximizeBox +Theme +AlwaysOnTop +ToolWindow ;-SysMenu
      Gui, 90:Add, GroupBox, x12 y8 w276 h60,
      Gui, 90:Add, Text, x55 y28 ,Please wait while initial files download...
      Gui, 90:Add, Progress, x55 y45 w180 h5 -Smooth vv_IconProgressBar, 0
      SetTimer, UpdateIconProgress, 400
      Gui, 90:Show, w300 h80 , Battlefield HitFixer
      URLDownloadToFile http://www.autohotkey.net/~DupaUnit/HitFixerIcon.ico, %A_ProgramFiles%\HitFixer\HitFixerIcon.ico
      Gui, 90:Destroy
   }
return


UpdateIconProgress:
   GuiControl, 90: , v_IconProgressBar, +14
   GuiControlGet, Temp05, 90: , v_IconProgressBar
   if (Temp05 >= 100)
      SetTimer, UpdateIconProgress, Off
return


/*
======================================================
Gui - Build and Tab calls
======================================================
*/

BuildMainGui:
   Gui, 6:Destroy
   Gui, 6:Font
   Gui, 6: -MaximizeBox +Theme +ToolWindow ;-SysMenu
   TempX := v_WindowWidth - 85
   TempY := v_WindowHeight - 33
   ;TempX -= 73
   Gui, 6:Add, Button, x%TempX% y%TempY% w65 h23 gMainHelpButton, Help
   TempX -= 73
   Gui, 6:Add, Button, x%TempX% y%TempY% w65 h23 gGeneralHideButton, Hide
   TempW := v_WindowWidth - 14
   TempH := v_WindowHeight - 50
   Gui, 6:Add, Tab2, x7 w%TempW%  h%TempH% y5 Choose%v_SelectedTab% AltSubmit -Background vv_SelectedTab,General|BFSoap|Update|Advanced

   GoSub GeneralPrefTab
   GoSub AdvancedPrefTab
   GoSub CleanServerHistoryTab
   GoSub UpdatePrefTab

   if (v_EnableAdvancedCommands = 0)
      GoSub EnableAdvancedCommandsTab

   Gui, 6:Show, w%v_WindowWidth% h%v_WindowHeight% x%v_PositionX% y%v_PositionY%, %programName% %CurrentVersion%
return


EnableAdvancedCommandsTab:
   Gui 6: Submit, NoHide
   if v_EnableAdvancedCommands
   {
      GuiControl, 6: , v_SelectedTab, |General|BFSoap|Update|Advanced
      GuiControl, 6: Show, v_VideoGroupbox
      GuiControl, 6: Show, v_FrameRate
      GuiControl, 6: Show, v_MaxFramesText
      GuiControl, 6: Show, v_ShowFPS
   }
   else
   {
      GuiControl, 6: , v_SelectedTab, |General|BFSoap|Update
      GuiControl, 6: Hide, v_VideoGroupbox
      GuiControl, 6: Hide, v_FrameRate
      GuiControl, 6: Hide, v_MaxFramesText
      GuiControl, 6: Hide, v_ShowFPS
   }
return

Exit:
6GuiClose:
   GoSub UpdateIni
   ExitApp
return


/*
======================================================
Gui General Tab - 1
======================================================
*/

GeneralPrefTab:
   Gui, 6: Tab, 1
      YPosition := 35
      XPosition := 16

   FileGetSize, Temp02, %A_ProgramFiles%\HitFixer\HitFixerIcon.ico
   if (Temp02 != 0) and (Temp02 != "")
   {
      TempX := (v_WindowWidth / 2)- 36
      YPosition += 2
      Gui, 6: Add, Picture, w64 h64 x%TempX% y%YPosition% vv_MainPageIcon, %A_ProgramFiles%\HitFixer\HitFixerIcon.ico
      YPosition += 68
   }

      TempW := v_WindowWidth - 32
   Gui, 6:Add, GroupBox, x%XPosition% y%YPosition% w%TempW% h88,
      YPosition += 18
      XPosition := 28
   Gui, 6:Add, Checkbox, x%XPosition% y%YPosition% vv_AutoOpenConsole gSaveHotkeyFunction Checked%v_AutoOpenConsole%,Auto open console when running HitFixer
      YPosition += 22
   Gui, 6:Add, Checkbox, x%XPosition% y%YPosition% vv_AutoRunOnStart gSaveHotkeyFunction Checked%v_AutoRunOnStart%,Run BFSoap on startup
      YPosition += 22
   Gui, 6:Add, Checkbox, x%XPosition% y%YPosition% vv_EnableAdvancedCommands gEnableAdvancedCommandsTab Checked%v_EnableAdvancedCommands%,Enable advanced options

      YPosition += 34
      XPosition := 16
      TempW := v_WindowWidth - 32
   Gui, 6:Add, GroupBox, x%XPosition% y%YPosition% w%TempW% h54,HitFixer Key
      YPosition += 24
      XPosition := 28
   Gui, 6:Add, Hotkey, x%XPosition% y%YPosition% w95 h20 Limit8 Limit128 vv_HitfixKeyDisplayOnly, %v_HitfixKey%
   GuiControl 6: Disable, v_HitfixKeyDisplayOnly
   TempX := v_WindowWidth - 86
      YPosition -= 3
   Gui, 6:Add, Button, x%TempX% y%YPosition% w60 h23 gModifyHotkey, Edit...
      YPosition += 42
      XPosition := 16

      TempW := v_WindowWidth - 32
   Gui, 6:Add, GroupBox, x%XPosition% y%YPosition% w%TempW% h57 vv_ProtectGroupbox,Protection
      YPosition += 25
      XPosition := 28
   Gui, 6:Add, Text, x%XPosition% y%YPosition% w160 gProtectUserSettingsFunction vv_UserSettingsStatus,Usersettings Status Unknown
      TempX := v_WindowWidth - 96
      YPosition -= 2
   Gui, 6:Add, Button, x%TempX% y%YPosition% w70 h23 gProtectUserSettingsFunction vv_ProtectButton, Protect...
   GoSub CheckUserSettingsFunction

      YPosition += 42
      XPosition := 16
      TempW := v_WindowWidth - 32
   Gui, 6:Add, GroupBox, x%XPosition% y%YPosition% w%TempW% h54 vv_VideoGroupbox,Video
      YPosition += 24
      XPosition := 28
   Gui, 6:Add, Edit, x%XPosition% y%YPosition% w30 Limit3 Number gSaveHotkeyFunction vv_FrameRate, %v_FrameRate%
      YPosition += 4
      XPosition += 33
   Gui, 6:Add, Text, x%XPosition% y%YPosition% vv_MaxFramesText,Max Framerate
      XPosition += 97
   Gui, 6:Add, Checkbox, x%XPosition% y%YPosition% vv_ShowFPS gSaveHotkeyFunction Checked%v_ShowFPS%,Show FPS
return


SaveHotkeyFunction:
   Gui 6: Submit, NoHide
return


/*
======================================================
Gui Advanced Tab - 2
======================================================
*/

AdvancedPrefTab:
   Gui, 6: Tab, 4
      YPosition := 35
      XPosition := 16
      TempW := v_WindowWidth - 32
   Gui, 6:Add, GroupBox, x%XPosition% y%YPosition% w%TempW% h48,
      YPosition += 18
      XPosition += 9
   Gui, 6:Add, Slider, Range-20-20 Center Thick15 NoTicks x%XPosition% y%YPosition% w128 AltSubmit gUpdateBasePingDevSlider vv_BasePingDevSlider,%v_BasePingDevSlider% Ping Offset
      XPosition += 128
      YPosition += 2
   Gui, 6:Add, Text, x%XPosition% y%YPosition% w120 vBasePingDevSliderPercent,
      GoSub UpdateBasePingDevSlider
      YPosition += 37
      XPosition := 16
      TempW := v_WindowWidth - 32
   Gui, 6:Add, GroupBox, x%XPosition% y%YPosition% w%TempW% h108, Ratios
      YPosition += 20
      XPosition += 9
   Gui, 6:Add, Slider, Range1-300 Center Thick15 NoTicks x%XPosition% y%YPosition% w128 AltSubmit gUpdateLatCompSlider vv_LatCompSlider, %v_LatCompSlider%
      YPosition += 1
      XPosition += 128
   Gui, 6:Add, Text, x%XPosition% w120 y%YPosition% vLatCompSliderPercent,%v_LatCompSlider%`% Latency Comp
      YPosition += 27
      XPosition -= 128
   Gui, 6:Add, Slider, Range1-300 Center Thick15 NoTicks x%XPosition% y%YPosition% w128 AltSubmit gUpdateExtrapSlider vv_ExtrapSlider, %v_ExtrapSlider%
      YPosition += 1
      XPosition += 128
   Gui, 6:Add, Text, x%XPosition% w120 y%YPosition% vExtrapSliderPercent,%v_ExtrapSlider%`% Extrapolation
      YPosition += 27
      XPosition -= 128
   Gui, 6:Add, Slider, Range1-300 Center Thick15 NoTicks x%XPosition% y%YPosition% w128 AltSubmit gUpdateInterpSlider vv_InterpSlider, %v_InterpSlider%
      YPosition += 1
      XPosition += 128
   Gui, 6:Add, Text, x%XPosition% w120 y%YPosition% vInterpSliderPercent,%v_InterpSlider%`% Interpolation
      YPosition += 37
      XPosition := 16
      TempW := v_WindowWidth - 32
   Gui, 6:Add, GroupBox, x%XPosition% y%YPosition% w%TempW% h78,
      YPosition += 18
      XPosition := 28
   Gui, 6:Add, Edit, x%XPosition% y%YPosition% w30 Limit2 Number gSaveHotkeyFunction vv_PerfLog, %v_PerfLog%
      YPosition += 4
      XPosition += 33
   Gui, 6:Add, Text, x%XPosition% y%YPosition%,Log Player Count
      XPosition += 97
   Gui, 6:Add, Checkbox, x%XPosition% y%YPosition% vv_ShowNetGraph gSaveHotkeyFunction Checked%v_ShowNetGraph%, Show NetGraph
      YPosition += 25
      XPosition -= 130
   Gui, 6:Add, Checkbox, x%XPosition% y%YPosition% vv_ExtrapFrame gSaveHotkeyFunction Checked%v_ExtrapFrame%, Extrapolate Frame
      XPosition += 130
   Gui, 6:Add, Checkbox, x%XPosition% y%YPosition% vv_UseObjectCache gSaveHotkeyFunction Checked%v_UseObjectCache%, Use Object Cache
      YPosition += 39
      XPosition := 16
      TempW := v_WindowWidth - 32
   Gui, 6:Add, GroupBox, x%XPosition% y%YPosition% w%TempW% h54,Hitreg Formula
   if (v_NewEquation = 1)
   {
      Temp01 := 1
      Temp02 := 0
   }
   else
   {
      Temp01 := 0
      Temp02 := 1
   }
      YPosition += 25
      XPosition := 28
   Gui, 6:Add, Radio, x%XPosition% y%YPosition%v Checked%Temp01% gSaveHotkeyFunction vv_NewEquation, Default
      xPosition += 65
   Gui, 6:Add, Radio, x%XPosition% y%YPosition% Checked%Temp02% gSaveHotkeyFunction,Restricted Range
   TempX := v_WindowWidth - 105
   TempY := v_WindowHeight - 78
   Gui, 6:Add, Button, x%TempX% y%TempY% w85 h23 gSetAdvancedtoDefaults, Defaults
return


UpdateBasePingDevSlider:
   if (v_BasePingDevSlider >= 0)
   {
      GuiControl, 6:Text, BasePingDevSliderPercent,+%v_BasePingDevSlider% Ping Offset
   }
   else
   {
      GuiControl, 6:Text, BasePingDevSliderPercent,%v_BasePingDevSlider% Ping Offset
   }
return


UpdateLatCompSlider:
   GuiControl, 6:Text, LatCompSliderPercent,%v_LatCompSlider%`% Latency Comp
return
UpdateExtrapSlider:
   GuiControl, 6:Text, ExtrapSliderPercent, %v_ExtrapSlider%`% Extrapolation
return
UpdateInterpSlider:
   GuiControl, 6:Text, InterpSliderPercent, %v_InterpSlider%`% Interpolation
return


SetAdvancedtoDefaults:
   GuiControl, 6:, v_PerfLog, 99
   GuiControl, 6:, v_ShowNetGraph, 0
   GuiControl, 6:, v_UseObjectCache, 1
   GuiControl, 6:, v_ExtrapFrame, 1
   GuiControl, 6:, Default, 1  ;Hitreg formula
   GuiControl, 6:, v_BasePingDevSlider, 10
   GuiControl, 6:, v_LatCompSlider, 100
   GuiControl, 6:, v_ExtrapSlider, 100
   GuiControl, 6:, v_InterpSlider, 100
   Gui 6: Submit, NoHide
      GoSub UpdateBasePingDevSlider
      GoSub UpdateLatCompSlider
      GoSub UpdateExtrapSlider
      GoSub UpdateInterpSlider 
return


/*
======================================================
Gui Update Tab - 3
======================================================
*/

UpdatePrefTab:
   Gui, 6: Tab, 3
      YPosition := 34
      XPosition := 16
      TempW := v_WindowWidth - 32
   Gui, 6:Add, GroupBox, x%XPosition% y%YPosition% w%TempW% h48,
      YPosition += 20
      XPosition := 28
   Gui, 6:Add, Checkbox, x%XPosition% y%YPosition% vv_AutoUpdateOnStart gSaveHotkeyFunction Checked%v_AutoUpdateOnStart%,Check for updates on startup
      YPosition += 35
      XPosition := 16
   Gui, 6:Add, GroupBox, x%XPosition% y%YPosition% w%TempW% h93 vv_UpdateButtonGroupBox,
      YPosition += 20
      TempX := (v_WindowWidth/2) - 64
   Gui, 6:Add, Button, x%TempX% y%YPosition% w128 h23 gCheckforUpdates vv_CheckUpdatesButton, Check for Updates...
      YPosition += 40
      XPosition := 28
   Gui, 6:Add, Text, x%XPosition% y%YPosition% w290 vv_UpdateAvailStatusText,
      YPosition += 20
      TempW := v_WindowWidth - 56
      UpdateProgressYPos := YPosition
   Gui, 6:Add, Progress, x%XPosition% y-100 w%TempW% h5 -Smooth vv_MainUpdateProgress, 0
      UpdateTabEndingYPos := YPosition 
return


ChooseUpdateMethod:
if A_IsCompiled
   GoSub ExecuteExeUpdate
else
   GoSub ExecuteAhkUpdate
return


/*
======================================================
Check for Updates
======================================================
*/

CheckforUpdates:

   GuiControl, 6: Disable, v_CheckUpdatesButton
   GuiControl, 6:Text, v_UpdateAvailStatusText,Checking...
   GuiControl, 6: , v_MainUpdateProgress, 0
   SetTimer, UpdateUpdateProgress, 100
   GuiControl, 6: Move, v_MainUpdateProgress, y%UpdateTabEndingYPos%

   URLDownloadToFile http://www.autohotkey.net/~DupaUnit/HitFixer_VersionRelease.ini, %A_ProgramFiles%\HitFixer\HitFixer_VersionRelease.ini

      IniRead, v_LatestExeVersion, %A_ProgramFiles%\HitFixer\HitFixer_VersionRelease.ini, LATEST VERSION, ExeVersion
      IniRead, v_LatestAhkVersion, %A_ProgramFiles%\HitFixer\HitFixer_VersionRelease.ini, LATEST VERSION, AhkVersion
      IniRead, v_LatestExeName, %A_ProgramFiles%\HitFixer\HitFixer_VersionRelease.ini, LATEST VERSION, ExeName
      IniRead, v_LatestAhkName, %A_ProgramFiles%\HitFixer\HitFixer_VersionRelease.ini, LATEST VERSION, AhkName

if (v_LatestExeVersion = "ERROR") or (v_LatestAhkVersion = "ERROR") or (v_LatestExeVersion = "") or (v_LatestAhkVersion = "") 
{
   GuiControl, 6:Text, v_UpdateAvailStatusText,There was a problem checking for updates
   GoSub RemoveProgressState
   return
}

if (CurrentVersion < v_LatestExeVersion) or (CurrentVersion < v_LatestAhkVersion)
{
   GuiControl, 6:Text, v_UpdateAvailStatusText ,There is a new version available!
   GuiControl, 6: Disable, v_CheckUpdatesButton
   GuiControl, 6:MoveDraw, v_UpdateButtonGroupBox, h158


if StartupUpdateCheck 
{
   StartupUpdateCheck := 0
TrayTip, HitFixer Update, There is a new HitFixer version available
SetTimer, RemoveUpdateTrayTip, 5000
}

   Temp01 := 0
   GuiControlGet, Temp02, 6: , v_UpdateEXEButton
   Temp01 += ErrorLevel
   GuiControlGet, Temp02, 6: , v_UpdateAhkButton
   Temp01 += ErrorLevel
   if (Temp01 < 2)
   {
      GoSub RemoveProgressState
      return
   }

      YPosition := UpdateTabEndingYPos + 20
      XPosition := 28
   Gui, 6:Add, Text, x%XPosition% y%YPosition% w290 vv_NewExeVersionText,A new .EXE version is available
   TempX := v_WindowWidth - 132
      YPosition -= 3
   Gui, 6:Add, Button, x%TempX% y%YPosition% w100 h23 gChooseUpdateMethod vv_UpdateEXEButton, Download Now
      YPosition += 31
   Gui, 6:Add, Text, x%XPosition% y%YPosition% w290 vv_NewAhkVersionText,A new .AHK version is available
      YPosition -= 3
   Gui, 6:Add, Button, x%TempX% y%YPosition% w100 h23 gChooseUpdateMethod vv_UpdateAhkButton, Download Now

if !(CurrentVersion < v_LatestExeVersion)
   {
      GuiControl, 6:Text, v_NewExeVersionText,No new .EXE version available
      GuiControl, 6: Disable, v_UpdateEXEButton
   }
if !(CurrentVersion < v_LatestAhkVersion)
   {
      GuiControl, 6:Text, v_NewAhkVersionText,No new .AHK version available
      GuiControl, 6: Disable, v_UpdateAhkButton
   }
}
else
{
   GuiControl, 6:Text, v_UpdateAvailStatusText,Your version is up to date
}
   GoSub RemoveProgressState
return


RemoveProgressState:
   SetTimer, UpdateUpdateProgress, Off
   GuiControl, 6: Enable, v_CheckUpdatesButton
   GuiControl, 6: Move, v_MainUpdateProgress, y-100
return


UpdateUpdateProgress:
   GuiControl, 6: , v_MainUpdateProgress, +6
   GuiControlGet, Temp05, 6: , v_MainUpdateProgress
   ;if (Temp05 >= 100)
      ;SetTimer, UpdateUpdateProgress, Off
return


RemoveUpdateTrayTip:
SetTimer, RemoveUpdateTrayTip, Off
TrayTip
return


/*
======================================================
Execute Exe Update
======================================================
*/

ExecuteExeUpdate:

   GuiControl, 6: Disable, v_CheckUpdatesButton
   GuiControl, 6:Text, v_UpdateAvailStatusText,Please wait while updates download...
   GuiControl, 6: , v_MainUpdateProgress, 0
   SetTimer, UpdateUpdateProgress, 600
   GuiControl, 6: Move, v_MainUpdateProgress, y%UpdateTabEndingYPos%

   IfExist, %A_ProgramFiles%\HitFixer\HitFixer_Installer.exe
      FileRecycle, %A_ProgramFiles%\HitFixer\HitFixer_Installer.exe

   if (A_GuiControl = "v_UpdateEXEButton")
      Temp01 := v_LatestExeName
   else
      Temp01 := v_LatestAhkName

      IniWrite, %Temp01%, %A_ProgramFiles%\HitFixer\HitFixer_Installer.ini, UNINSTALL INFO, Requested Version
      IniWrite, %A_ScriptFullPath%, %A_ProgramFiles%\HitFixer\HitFixer_Installer.ini, UNINSTALL INFO, Delete File Path
      IniWrite, %A_ScriptDir%, %A_ProgramFiles%\HitFixer\HitFixer_Installer.ini, UNINSTALL INFO, Download Directory
      IniWrite, %A_ScriptName%, %A_ProgramFiles%\HitFixer\HitFixer_Installer.ini, UNINSTALL INFO, Delete File Name

   URLDownloadToFile http://www.autohotkey.net/~DupaUnit/%Temp01%, %A_ScriptDir%\NEW%Temp01%
   FileGetSize, Temp02, %A_ScriptDir%\NEW%Temp01%
   if (Temp02 = 0)
   {
      GuiControl, 6:Text, v_UpdateAvailStatusText,There was a problem downloading update
      FileRecycle, %A_ScriptDir%\NEW%Temp01%
      FileRecycle, %A_ScriptFullPath%, %A_ProgramFiles%\HitFixer\HitFixer_Installer.ini
      GoSub RemoveProgressState
      return
   }

   GuiControl, 6: , v_MainUpdateProgress, 0
   URLDownloadToFile http://www.autohotkey.net/~DupaUnit/HitFixer_Installer.exe, %A_ProgramFiles%\HitFixer\HitFixer_Installer.exe
   FileGetSize, Temp02, %A_ProgramFiles%\HitFixer\HitFixer_Installer.exe
   if (Temp02 = 0)
   {
      GuiControl, 6:Text, v_UpdateAvailStatusText,There was a problem downloading update
      FileRecycle, %A_ProgramFiles%\HitFixer\HitFixer_Installer.exe
      FileRecycle, %A_ScriptDir%\NEW%Temp01%
      FileRecycle, %A_ScriptFullPath%, %A_ProgramFiles%\HitFixer\HitFixer_Installer.ini
      GoSub RemoveProgressState
      return
   }

   IfExist, %A_ProgramFiles%\HitFixer\HitFixer_Installer.exe
      Run, %A_ProgramFiles%\HitFixer\HitFixer_Installer.exe
   else
   {
      GoSub RemoveProgressState
      return
   }
ExitApp
return


/*
======================================================
Execute Ahk Update
======================================================
*/

ExecuteAhkUpdate:

   GuiControl, 6: Disable, v_CheckUpdatesButton
   GuiControl, 6:Text, v_UpdateAvailStatusText,Please wait while updates download...
   GuiControl, 6: , v_MainUpdateProgress, 0
   SetTimer, UpdateUpdateProgress, 600
   GuiControl, 6: Move, v_MainUpdateProgress, y%UpdateTabEndingYPos%


   if (A_GuiControl = "v_UpdateEXEButton")
      Temp01 := v_LatestExeName
   else
      Temp01 := v_LatestAhkName

   if (Temp01 = "")
   {
      GoSub RemoveProgressState
      return
   }

   URLDownloadToFile http://www.autohotkey.net/~DupaUnit/%Temp01%, %A_ScriptDir%\NEW%Temp01%


   FileGetSize, Temp02, %A_ScriptDir%\NEW%Temp01%
   if (Temp02 = 0)
   {
      GuiControl, 6:Text, v_UpdateAvailStatusText,There was a problem downloading update
      FileRecycle, %A_ScriptDir%\NEW%Temp01%
      GoSub RemoveProgressState
      return
   }

   FileRecycle, %A_ScriptFullPath%
   FileMove, %A_ScriptDir%\NEW%Temp01%, %A_ScriptDir%\%Temp01%

   IfExist, %A_ScriptDir%\%Temp01%
      Run, %A_ScriptDir%\%Temp01%
   ExitApp
return


/*
======================================================
Check Usersettings File Protection
======================================================
*/

CheckUserSettingsFunction:

   v_UserSettingsStatus := "Usersettings Status Unknown"
   Gui, 6:Font, underline
   GuiControl, 6:Text, v_UserSettingsStatus,%v_UserSettingsStatus%
   GuiControl, 6:Font, v_UserSettingsStatus
   Gui, 6:Font
   if (v_BFInstallDirectory = "ERROR")
      return
   IfNotExist, %v_BFInstallDirectory%\BF2.exe
      return

   v_UserSettingsStatus := "Usersettings are Not Protected"
   GuiControl, 6:Text, v_UserSettingsStatus,%v_UserSettingsStatus%

   ;Inspect each Usersettings for stock lines and read-only status
   Loop, %v_BFInstallDirectory%\mods\*, 2, 0
   {
   
   FileReadLine, Temp01, %v_BFInstallDirectory%\mods\%A_LoopFileName%\settings\Usersettings.con, 4
   if !(Temp01 = "SettingsManager.boolSet GSClPunkBuster 1")
      return
   FileReadLine, Temp01, %v_BFInstallDirectory%\mods\%A_LoopFileName%\settings\Usersettings.con, 5
   if !(Temp01 = "SettingsManager.floatSet GSDefaultLatencyCompensation 0.100000")
      return
   FileReadLine, Temp01, %v_BFInstallDirectory%\mods\%A_LoopFileName%\settings\Usersettings.con, 6
   if !(Temp01 = "SettingsManager.boolSet GSExtrapolateFrame 0")
      return
   FileReadLine, Temp01, %v_BFInstallDirectory%\mods\%A_LoopFileName%\settings\Usersettings.con, 7
   if !(Temp01 = "SettingsManager.U32Set GSExtrapolationTime 1200")
      return
   FileReadLine, Temp01, %v_BFInstallDirectory%\mods\%A_LoopFileName%\settings\Usersettings.con, 8
   if !(Temp01 = "SettingsManager.U32Set GSInterpolationTime 100")
      return

   FileGetAttrib, Temp01, %v_BFInstallDirectory%\mods\%A_LoopFileName%\settings\Usersettings.con
   IfNotInString, Temp01, R
      return
   }

   v_UserSettingsStatus := "Usersettings are Protected"

   Gui, 6:Font, italic
   GuiControl, 6:Text, v_UserSettingsStatus,%v_UserSettingsStatus%
   GuiControl, 6:Font, v_UserSettingsStatus
   Gui, 6:Font
   GuiControl, 6:Disable, v_ProtectButton
   GuiControl, 6:Disable, v_UserSettingsStatus
return


/*
======================================================
Protect Usersettings File
======================================================
*/

ProtectUserSettingsFunction:

   IfNotExist, %v_BFInstallDirectory%\BF2.exe
      v_BFInstallDirectory := "ERROR"

   if (v_BFInstallDirectory = "ERROR")
   {
      FileSelectFile, Temp01, 3, C:\Program Files\EA GAMES\Battlefield 2\BF2.exe, Select BF2.exe in Install Directory, Battlefield (BF2.exe)

      if (Temp01 = "")
         return
      v_BFInstallDirectory := Temp01

      Loop, 15
      {
         StringRight, Temp01, v_BFInstallDirectory, 1
         if !(Temp01 = "\")
            StringTrimRight, v_BFInstallDirectory, v_BFInstallDirectory, 1
         else
         {
            StringTrimRight, v_BFInstallDirectory, v_BFInstallDirectory, 1
            break
         }
      }
      IniWrite, %v_BFInstallDirectory%, %A_ProgramFiles%\HitFixer\BattlefieldHitFixer.ini, APP SETTINGS, BFInstallDirectory
   }


   ;Find mod names and reset Usersettings
   Loop, %v_BFInstallDirectory%\mods\*, 2, 0
   {
   
   FileReadLine, Temp01, %v_BFInstallDirectory%\mods\%A_LoopFileName%\settings\Usersettings.con, 10
   StringTrimRight, Temp01, Temp01, 1
   StringTrimLeft, Temp01, Temp01, 40
   
   FileRecycle, %v_BFInstallDirectory%\mods\%A_LoopFileName%\settings\Usersettings.con
   FileAppend, 
(
rem
rem Settingsfile automatically saved by bf2
rem
SettingsManager.boolSet GSClPunkBuster 1
SettingsManager.floatSet GSDefaultLatencyCompensation 0.100000
SettingsManager.boolSet GSExtrapolateFrame 0
SettingsManager.U32Set GSExtrapolationTime 1200
SettingsManager.U32Set GSInterpolationTime 100
SettingsManager.U32Set GSPerfLogAtPlayerCount 30
SettingsManager.stringSet GSPlayerName "%Temp01%"
SettingsManager.boolSet GSShowNetGraph 0
SettingsManager.boolSet GSUseObjectCache 1
),%v_BFInstallDirectory%\mods\%A_LoopFileName%\settings\Usersettings.con

   FileSetAttrib, +R, %v_BFInstallDirectory%\mods\%A_LoopFileName%\settings\Usersettings.con
   }
   GoSub CheckUserSettingsFunction
return


/*
======================================================
Gui - Modify HotKey Window
======================================================
*/

ModifyHotkey:
   Gui, 4:Destroy
   Gui, 4: -SysMenu +ToolWindow +Theme +AlwaysonTop
   Gui, 4:Add, GroupBox, x4 y-2 w195 h38,
   Gui, 4:Add, Text,x11 y12 gModifyHotkey,HitFixer Key:
   Gui, 4:Add, Hotkey,x90 y9 w105 h20 Limit8 Limit128 vv_HitfixKey, %v_HitfixKey%
   Gui, 4:Add, Button, x3 y40 w97 Default gAcceptHotkeyAssignWin vHotKeyModifySaveButton, Save
   Gui, 4:Add, Button, x104 y40 w97 gCancelHotkeyAssignWin, Cancel
   ;GuiControl, 4:Focus, HotKeyModifySaveButton
   Gui, 4:Show, w204 h70, Set Hotkey
return

CancelHotkeyAssignWin:
   Gui, 4:Destroy
return

AcceptHotkeyAssignWin:
   Gui, 4:Submit
   IniWrite, %v_HitfixKey%, %A_ProgramFiles%\HitFixer\BattlefieldHitFixer.ini, HOTKEYS, HitfixerKey
   Gui, 4:Destroy
   GoSub UpdateIni
   Reload
return


/*
======================================================
HitReg Fix
======================================================
*/

Hitregfix:
;Process, Priority, , High

SetTitleMatchMode, 2
If ! (WinActive("BF2142 (v") or WinActive("BF2 (v"))
    return


;-----Open Console-------------------
if (v_AutoOpenConsole = 1)
    {
        Sleep 110
        Send {~ Down}
        Sleep 110
        Send {~ Up}
        Sleep 10
    }
;------------------------------------

    ;SetKeyDelay 5, 5
    Sleep 1
    Send,TYPE  PING  THEN  PRESS  ENTER{Space}{Space}
    Sleep 1
    Input, PingVar, T8 V,{Enter}{Esc}
    KeyWait, Enter, T5

if (ErrorLevel = "EndKey:Escape")
    {
        Send,{Space}(HITFIXER  CANCELLED){ENTER}
        return
    }
if !(PingVar < 1000 and PingVar > 1) 
    {
        Send,PLEASE  TRY  AGAIN  AND  ENTER  A  NUMBER  BETWEEN  1  AND  999.{ENTER}
        return
    }
if PingVar is not digit
    {
        Send,PLEASE  TRY  AGAIN  AND  ENTER  A  NUMBER  BETWEEN  1  AND  999.{ENTER}
        return
    }

;*****Advanced Commands Only*******
if v_EnableAdvancedCommands
   {
   ;-----Send FrameRate Commands---------
      if !(v_FrameRate = 100)
      {
         Send,game.lockFps %v_FrameRate%{Enter}
         Sleep 1
      }
      Send,renderer.drawFps %v_ShowFPS%{Enter}
      Sleep 1
   ;-----Send Misc HitReg Commands-------
   
      Send,SettingsManager.U32Set GSPerfLogAtPlayerCount %v_PerfLog%{Enter}
      Sleep 1
      Send,SettingsManager.boolSet GSShowNetGraph %v_ShowNetGraph%{Enter}
      Sleep 1
      Send,SettingsManager.boolSet GSUseObjectCache %v_UseObjectCache%{Enter}
   }
;**********************************

;-----Send Main HitReg Commands-------

      PingVar += v_BasePingDevSlider

      LatencyComp := (PingVar / 1000) * (v_LatCompSlider / 100)
      Interpol := Floor( PingVar * (v_InterpSlider / 100))
      if (v_NewEquation = 1)
         Extrapol := Floor( (12 * PingVar) * (v_ExtrapSlider / 100) )
      else
         Extrapol := Floor( ((5.5 * PingVar) + 489) * (v_ExtrapSlider / 100) )
/*
y is unknown (extrap)
 delta y/delta x
 y = mx + b
 y - mx = b
 y = 5.5x + 489  (X is ping)
*/
      Send,SettingsManager.boolSet GSExtrapolateFrame %v_ExtrapFrame%{Enter}
      Sleep 2
      Send,SettingsManager.floatSet GSDefaultLatencyCompensation %LatencyComp%{Enter}
      Sleep 2
      Send,SettingsManager.U32Set GSExtrapolationTime %Extrapol%{Enter}
      Sleep 2
      Send,SettingsManager.U32Set GSInterpolationTime %Interpol%{Enter}
      Sleep 2

;Process, Priority, , Normal

;-----Close Console------------------
if (v_AutoOpenConsole = 1)
    {
        Sleep 110
        Send {~ Down}
        Sleep 110
        Send {~ Up}
    }
;------------------------------------

      Send {Control Up}
      Send {Shift Up}
      Send {Alt Up}

return


/*
======================================================
Create ini
======================================================
*/

CreateIni:
   IfNotExist, %A_ProgramFiles%\HitFixer
      FileCreateDir, %A_ProgramFiles%\HitFixer

   IniRead, Temp01, %A_ProgramFiles%\HitFixer\BattlefieldHitFixer.ini, CURRENT VERSION, CurrentVersion
   if (Temp01 < LowestCompatibleIniVersion) or (Temp01 = "ERROR")
      FileDelete, %A_ProgramFiles%\HitFixer\BattlefieldHitFixer.ini

   IfNotExist %A_ProgramFiles%\HitFixer\BattlefieldHitFixer.ini
   {
      IniWrite, %CurrentVersion%, %A_ProgramFiles%\HitFixer\BattlefieldHitFixer.ini, CURRENT VERSION, CurrentVersion
      IniWrite, ^0, %A_ProgramFiles%\HitFixer\BattlefieldHitFixer.ini, HOTKEYS, HitfixerKey
            IniWrite, ., %A_ProgramFiles%\HitFixer\BattlefieldHitFixer.ini, HOTKEYS,.  ;Legability space
      IniWrite, 1, %A_ProgramFiles%\HitFixer\BattlefieldHitFixer.ini, SETTINGS, NewEquation
      IniWrite, 1, %A_ProgramFiles%\HitFixer\BattlefieldHitFixer.ini, SETTINGS, SelectedTab
      IniWrite, 0, %A_ProgramFiles%\HitFixer\BattlefieldHitFixer.ini, SETTINGS, ShowAdvanced
      IniWrite, 0, %A_ProgramFiles%\HitFixer\BattlefieldHitFixer.ini, SETTINGS, HideAdvWarning
      IniWrite, 100, %A_ProgramFiles%\HitFixer\BattlefieldHitFixer.ini, SETTINGS, LatCompSlider
      IniWrite, 100, %A_ProgramFiles%\HitFixer\BattlefieldHitFixer.ini, SETTINGS, ExtrapSlider
      IniWrite, 100, %A_ProgramFiles%\HitFixer\BattlefieldHitFixer.ini, SETTINGS, InterpSlider
      IniWrite, 10, %A_ProgramFiles%\HitFixer\BattlefieldHitFixer.ini, SETTINGS, BasePingDevSlider
      IniWrite, 100, %A_ProgramFiles%\HitFixer\BattlefieldHitFixer.ini, SETTINGS, FrameRate
      IniWrite, 0, %A_ProgramFiles%\HitFixer\BattlefieldHitFixer.ini, SETTINGS, ShowFPS
      IniWrite, 99, %A_ProgramFiles%\HitFixer\BattlefieldHitFixer.ini, SETTINGS, PerfLog
      IniWrite, 1, %A_ProgramFiles%\HitFixer\BattlefieldHitFixer.ini, SETTINGS, ExtrapFrame
      IniWrite, 0, %A_ProgramFiles%\HitFixer\BattlefieldHitFixer.ini, SETTINGS, ShowNetGraph
      IniWrite, 1, %A_ProgramFiles%\HitFixer\BattlefieldHitFixer.ini, SETTINGS, UseObjectCache
            IniWrite, ., %A_ProgramFiles%\HitFixer\BattlefieldHitFixer.ini, SETTINGS,.   ;Legability space

      IniWrite, 1, %A_ProgramFiles%\HitFixer\BattlefieldHitFixer.ini, SOAP SETTINGS, CleanServerHistory
      IniWrite, 1, %A_ProgramFiles%\HitFixer\BattlefieldHitFixer.ini, SOAP SETTINGS, CleanBRHistory
      IniWrite, 1, %A_ProgramFiles%\HitFixer\BattlefieldHitFixer.ini, SOAP SETTINGS, CleanLogoCache
      IniWrite, 0, %A_ProgramFiles%\HitFixer\BattlefieldHitFixer.ini, SOAP SETTINGS, AutoRunOnStart

            IniWrite, ., %A_ProgramFiles%\HitFixer\BattlefieldHitFixer.ini, SOAP SETTINGS,.   ;Legability space

      IniWrite, 0, %A_ProgramFiles%\HitFixer\BattlefieldHitFixer.ini, APP SETTINGS, AutoOpenConsole
      IniWrite, 0, %A_ProgramFiles%\HitFixer\BattlefieldHitFixer.ini, APP SETTINGS, AutoUpdateOnStart
      IniWrite, 0, %A_ProgramFiles%\HitFixer\BattlefieldHitFixer.ini, APP SETTINGS, EnableAdvancedCommands
      IniWrite, 1, %A_ProgramFiles%\HitFixer\BattlefieldHitFixer.ini, APP SETTINGS, AutoProtectUserSettings  ;Unused ATM
      IniWrite, ERROR, %A_ProgramFiles%\HitFixer\BattlefieldHitFixer.ini, APP SETTINGS, BFInstallDirectory

            IniWrite, ., %A_ProgramFiles%\HitFixer\BattlefieldHitFixer.ini, APP SETTINGS,.   ;Legability space
      IniWrite, 100, %A_ProgramFiles%\HitFixer\BattlefieldHitFixer.ini, WIN COORDS, PositionX
      IniWrite, 100, %A_ProgramFiles%\HitFixer\BattlefieldHitFixer.ini, WIN COORDS, PositionY
   }
return


/*
======================================================
Read ini
======================================================
*/

ReadIni:
      IniRead, v_HitFixKey, %A_ProgramFiles%\HitFixer\BattlefieldHitFixer.ini, HOTKEYS, HitfixerKey
      IniRead, v_NewEquation, %A_ProgramFiles%\HitFixer\BattlefieldHitFixer.ini, SETTINGS, NewEquation
      IniRead, v_SelectedTab, %A_ProgramFiles%\HitFixer\BattlefieldHitFixer.ini, SETTINGS, SelectedTab
      IniRead, v_ShowAdvanced, %A_ProgramFiles%\HitFixer\BattlefieldHitFixer.ini, SETTINGS, ShowAdvanced
      IniRead, v_HideAdvWarning, %A_ProgramFiles%\HitFixer\BattlefieldHitFixer.ini, SETTINGS, HideAdvWarning
      IniRead, v_LatCompSlider, %A_ProgramFiles%\HitFixer\BattlefieldHitFixer.ini, SETTINGS, LatCompSlider
      IniRead, v_ExtrapSlider, %A_ProgramFiles%\HitFixer\BattlefieldHitFixer.ini, SETTINGS, ExtrapSlider
      IniRead, v_InterpSlider, %A_ProgramFiles%\HitFixer\BattlefieldHitFixer.ini, SETTINGS, InterpSlider
      IniRead, v_BasePingDevSlider, %A_ProgramFiles%\HitFixer\BattlefieldHitFixer.ini, SETTINGS, BasePingDevSlider
      IniRead, v_FrameRate, %A_ProgramFiles%\HitFixer\BattlefieldHitFixer.ini, SETTINGS, FrameRate
      IniRead, v_ShowFPS, %A_ProgramFiles%\HitFixer\BattlefieldHitFixer.ini, SETTINGS, ShowFPS
      IniRead, v_PerfLog, %A_ProgramFiles%\HitFixer\BattlefieldHitFixer.ini, SETTINGS, PerfLog
      IniRead, v_ExtrapFrame, %A_ProgramFiles%\HitFixer\BattlefieldHitFixer.ini, SETTINGS, ExtrapFrame
      IniRead, v_ShowNetGraph, %A_ProgramFiles%\HitFixer\BattlefieldHitFixer.ini, SETTINGS, ShowNetGraph
      IniRead, v_UseObjectCache, %A_ProgramFiles%\HitFixer\BattlefieldHitFixer.ini, SETTINGS, UseObjectCache

      IniRead, v_CleanServerHistory, %A_ProgramFiles%\HitFixer\BattlefieldHitFixer.ini, SOAP SETTINGS, CleanServerHistory
      IniRead, v_CleanBRHistory, %A_ProgramFiles%\HitFixer\BattlefieldHitFixer.ini, SOAP SETTINGS, CleanBRHistory
      IniRead, v_CleanLogoCache, %A_ProgramFiles%\HitFixer\BattlefieldHitFixer.ini, SOAP SETTINGS, CleanLogoCache
      IniRead, v_AutoRunOnStart, %A_ProgramFiles%\HitFixer\BattlefieldHitFixer.ini, SOAP SETTINGS, AutoRunOnStart

      IniRead, v_AutoOpenConsole, %A_ProgramFiles%\HitFixer\BattlefieldHitFixer.ini, APP SETTINGS, AutoOpenConsole
      IniRead, v_AutoUpdateOnStart, %A_ProgramFiles%\HitFixer\BattlefieldHitFixer.ini, APP SETTINGS, AutoUpdateOnStart
      IniRead, v_EnableAdvancedCommands, %A_ProgramFiles%\HitFixer\BattlefieldHitFixer.ini, APP SETTINGS, EnableAdvancedCommands
      IniRead, v_AutoProtectUserSettings, %A_ProgramFiles%\HitFixer\BattlefieldHitFixer.ini, APP SETTINGS, AutoProtectUserSettings
      IniRead, v_BFInstallDirectory, %A_ProgramFiles%\HitFixer\BattlefieldHitFixer.ini, APP SETTINGS, BFInstallDirectory

      IniRead, v_PositionX, %A_ProgramFiles%\HitFixer\BattlefieldHitFixer.ini, WIN COORDS, PositionX
      IniRead, v_PositionY, %A_ProgramFiles%\HitFixer\BattlefieldHitFixer.ini, WIN COORDS, PositionY

   if (v_PositionX < 0) or (v_PositionX = "ERROR")
      v_PositionX := 100
   if (v_PositionY < 0) or (v_PositionY = "ERROR")
      v_PositionY := 100
return


/*
======================================================
Update ini
======================================================
*/

UpdateIni:
      Gui 6:Submit, NoHide
      IniWrite, %CurrentVersion%, %A_ProgramFiles%\HitFixer\BattlefieldHitFixer.ini, CURRENT VERSION, CurrentVersion
      IniWrite, %v_NewEquation%, %A_ProgramFiles%\HitFixer\BattlefieldHitFixer.ini, SETTINGS, NewEquation
      IniWrite, %v_SelectedTab%, %A_ProgramFiles%\HitFixer\BattlefieldHitFixer.ini, SETTINGS, SelectedTab
      IniWrite, %v_ShowAdvanced%, %A_ProgramFiles%\HitFixer\BattlefieldHitFixer.ini, SETTINGS, ShowAdvanced
      IniWrite, %v_HideAdvWarning%, %A_ProgramFiles%\HitFixer\BattlefieldHitFixer.ini, SETTINGS, HideAdvWarning
      IniWrite, %v_LatCompSlider%, %A_ProgramFiles%\HitFixer\BattlefieldHitFixer.ini, SETTINGS, LatCompSlider
      IniWrite, %v_ExtrapSlider%, %A_ProgramFiles%\HitFixer\BattlefieldHitFixer.ini, SETTINGS, ExtrapSlider
      IniWrite, %v_InterpSlider%, %A_ProgramFiles%\HitFixer\BattlefieldHitFixer.ini, SETTINGS, InterpSlider
      IniWrite, %v_BasePingDevSlider%, %A_ProgramFiles%\HitFixer\BattlefieldHitFixer.ini, SETTINGS, BasePingDevSlider
      IniWrite, %v_FrameRate%, %A_ProgramFiles%\HitFixer\BattlefieldHitFixer.ini, SETTINGS, FrameRate
      IniWrite, %v_ShowFPS%, %A_ProgramFiles%\HitFixer\BattlefieldHitFixer.ini, SETTINGS, ShowFPS
      IniWrite, %v_PerfLog%, %A_ProgramFiles%\HitFixer\BattlefieldHitFixer.ini, SETTINGS, PerfLog
      IniWrite, %v_ExtrapFrame%, %A_ProgramFiles%\HitFixer\BattlefieldHitFixer.ini, SETTINGS, ExtrapFrame
      IniWrite, %v_ShowNetGraph%, %A_ProgramFiles%\HitFixer\BattlefieldHitFixer.ini, SETTINGS, ShowNetGraph
      IniWrite, %v_UseObjectCache%, %A_ProgramFiles%\HitFixer\BattlefieldHitFixer.ini, SETTINGS, UseObjectCache

      IniWrite, %v_CleanServerHistory%, %A_ProgramFiles%\HitFixer\BattlefieldHitFixer.ini, SOAP SETTINGS, CleanServerHistory
      IniWrite, %v_CleanBRHistory%, %A_ProgramFiles%\HitFixer\BattlefieldHitFixer.ini, SOAP SETTINGS, CleanBRHistory
      IniWrite, %v_CleanLogoCache%, %A_ProgramFiles%\HitFixer\BattlefieldHitFixer.ini, SOAP SETTINGS, CleanLogoCache
      IniWrite, %v_AutoRunOnStart%, %A_ProgramFiles%\HitFixer\BattlefieldHitFixer.ini, SOAP SETTINGS, AutoRunOnStart

      IniWrite, %v_AutoOpenConsole%, %A_ProgramFiles%\HitFixer\BattlefieldHitFixer.ini, APP SETTINGS, AutoOpenConsole
      IniWrite, %v_AutoUpdateOnStart%, %A_ProgramFiles%\HitFixer\BattlefieldHitFixer.ini, APP SETTINGS, AutoUpdateOnStart
      IniWrite, %v_EnableAdvancedCommands%, %A_ProgramFiles%\HitFixer\BattlefieldHitFixer.ini, APP SETTINGS, EnableAdvancedCommands
      IniWrite, %v_AutoProtectUserSettings%, %A_ProgramFiles%\HitFixer\BattlefieldHitFixer.ini, APP SETTINGS, AutoProtectUserSettings 

      IfWinExist, %programName% %CurrentVersion%
         WinGetPos, v_PositionX, v_PositionY,,, %programName% %CurrentVersion%
      IniWrite, %v_PositionX%, %A_ProgramFiles%\HitFixer\BattlefieldHitFixer.ini, WIN COORDS, PositionX
      IniWrite, %v_PositionY%, %A_ProgramFiles%\HitFixer\BattlefieldHitFixer.ini, WIN COORDS, PositionY
return


/*
=========================================================================================
Main Help Tooltips
=========================================================================================
*/

MainHelpButton:

GuiControlGet, Temp01, 6: , v_MainPageIcon
if (Temp01 = "")
   YPosition := -52
else
   YPosition := 18

   Gui 6:Submit, NoHide
;Tips for Tab 1--------------------------------------------
if (v_SelectedTab = 1)  ;General
{
if !v_AutoOpenConsole
   Tooltip, 
   (
HITFIXER INSTRUCTIONS

1. Join a Battlefield server and press tilde (~) to show the console

2. Press the assigned HitFixer key, type your ping, then hit Enter

3. Press tilde (~) again to hide the console

   ), -190, %YPosition%, 1
else
   Tooltip, 
   (
HITFIXER INSTRUCTIONS

1. Join a Battlefield server and press the assigned HitFixer key

2. Type your ping, then hit Enter

   ), -190, %YPosition%, 1


YPosition += 120
   Tooltip, 
   (
When checked, you will no longer need to press tilde (~) before running HitFixer.
   ), -190, %YPosition%, 2
      YPosition += 25
   Tooltip, 
   (
Automatically runs BFSoap functions when opening HitFixer.
   ), -190, %YPosition%, 3
      YPosition += 74
   Tooltip, 
   (
This is the assigned Hotkey which will run HitFixer while 
in a Battlefield game.
   ), -190, %YPosition%, 4
      YPosition += 62
   Tooltip, 
   (
Protecting your Usersettings will prevent MD5 kicks for having
a modified Usersettings.con file.  This is done by resetting your 
Usersetting files to default, then setting them to Read-Only.
   ), -190, %YPosition%, 5
      YPosition += 66
if v_EnableAdvancedCommands 
   Tooltip, 
   (
This allows you to change the video framerate cap of Battlefield from 
the default value of 100 FPS and to show the FPS counter in-game.
   ), -190, %YPosition%, 6
}



;Tips for Tab 2--------------------------------------------
if (v_SelectedTab = 2)  ;BFSoap
{
   Tooltip, 
   (
Battlefield keeps a list of recently played servers, which can 
drastically lengthen your "connecting to account server" time.  
Clearing this should cut your login time down to a few seconds.
   ), -190, 68, 1
   Tooltip, 
   (
This clears all BattleRecorder History Bookmarks (left side 
under community tab), NOT your saved BattleRecorder files.
   ), -190, 123, 2
   Tooltip, 
   (
This clears all the saved banners from servers you've joined.
   ), -190, 163, 3
   Tooltip, 
   (
Clearing the video cache is useful when Battlefield randomly changes
your videos settings, such as having your shadows randomly turn on
or off.  Note: After this is cleared, Battlefield will "Optimize 
Shaders" the next time a server is joined.
   ), -190, 243, 4


}
;Tips for Tab 3--------------------------------------------
if (v_SelectedTab = 3)  ;Update
{




}
;Tips for Tab 4--------------------------------------------
if (v_SelectedTab = 4)  ;Advanced
{
   Tooltip, 
   (
This is the initial amount to add to your ping. 
A value of +5 to +10 is recommended.
   ), -150, 70, 1

   Tooltip, 
   (
These sliders control the ratio of each of the
3 Hitreg settings based off the "base" formula.
These should generally be left alone, although
lowering interpolation and raising extrapolation
can yield positive results on certain servers.
   ), -150, 128, 2

   Tooltip, 
   (
These are the remaining 4 settings included in
the Usersettings file.  Their exact nature is
unknown, modify at your own risk.
   ), -150, 240, 3

   Tooltip, 
   (
The Default option sets the extrapolation based 
off the EA formula.  Restricted Range sets the 
extrapolation value higher on low ping servers 
and lower on high ping servers.  Use this setting 
if Default does not give desired results.
   ), -150, 330, 4
}
   MouseGetPos, OldMousePosX, OldMousePosY
   SetTimer, RemoveToolTips, 300
return


RemoveToolTips:
   MouseGetPos, MousePosX, MousePosY
   if !(OldMousePosX = MousePosX) and !(OldMousePosY = MousePosY)
   {
      SetTimer, RemoveToolTips, Off
      Loop, 20
         Tooltip,,,,%A_Index%
      return
   }
   OldMousePosX := MousePosX
   OldMousePosY := MousePosY
return


/*
=========================================================================================
Battlefield Soap Utility
=========================================================================================
*/
/*
======================================================
Read Existing Profiles
======================================================
*/

CleanServerHistoryTab:
Loop, %A_MyDocuments%\Battlefield 2\Profiles\????, 2, 0
{
   FileReadLine, Temp02, %A_LoopFileFullPath%\Profile.con, 1
   StringTrimLeft, Temp02, Temp02, 22
   StringTrimRight, Temp02, Temp02, 1
   StringRight, Temp01, A_LoopFileFullPath, 2
   Profile%Temp01% := Temp02
   NumberOfProfiles := Temp01
}

/*
======================================================
Gui BFCleaner Tab - 3
======================================================
*/

   Gui, 6: Tab, 2
   YPosition := 35
   XPosition := 16
   TempW := v_WindowWidth - 32
   Gui, 6:Add, GroupBox, x%XPosition% y%YPosition% w%TempW% h159,
   YPosition += 15
   XPosition += 67
   TempX := (v_WindowWidth / 2) - 92 + 45
   Gui, 6:Add, DropDownList, x%TempX% y%YPosition% w140 AltSubmit gUpdateCleanerDisplayCounts vProfileSelect, All||
   YPosition += 3
   TempX := (v_WindowWidth / 2) - 92
   Gui, 6:Font, bold
   Gui, 6:Add, Text, x%TempX% y%YPosition%,Profile:  ;Profile and DDL are 184 wide
   Gui, 6:Font,

   ItemPosition := 1
   Loop, %NumberOfProfiles%
   {
      Temp02 := A_Index
      if (Temp02 < 10)
         Temp02 := "0" . Temp02
      Temp01 := Profile%Temp02%

      IfInString, Temp01, |
         StringReplace, Temp01, Temp01, |, l, All

      if !(Temp01 = "")
      {
         ++ItemPosition
         ItemPosition%ItemPosition% := Temp02
         GuiControl, 6: , ProfileSelect, %Temp01% 
      }
   }

XPosition := 28
YPosition += 36
   Gui, 6:Add, Checkbox, x%XPosition% y%YPosition% w240 gCheckforDisableClean vv_CleanServerHistory Checked%v_CleanServerHistory%,
   GoSub CountServerHistory
YPosition += 23
   Gui, 6:Add, Checkbox, x%XPosition% y%YPosition% w240 gCheckforDisableClean vv_CleanBRHistory Checked%v_CleanBRHistory%,
   GoSub AmountofBRbookmarks
YPosition += 23
   Gui, 6:Add, Checkbox, x%XPosition% y%YPosition% w240 gCheckforDisableClean vv_CleanLogoCache Checked%v_CleanLogoCache%,
   GoSub SizeLogoCache
YPosition += 27
   TempX := v_WindowWidth - 106
   Gui, 6:Add, Button, x%TempX% y%YPosition% w80 h23 gRunBFSoap vCleanNowButton, Clean Now
   GoSub CheckforDisableClean


YPosition += 43
XPosition := 16
   TempW := v_WindowWidth - 32
   TempH := v_WindowHeight - 50
   Gui, 6:Add, GroupBox, x%XPosition% y%YPosition% w%TempW% h93, Video Cache
YPosition += 22
XPosition += 12
   TempW := v_WindowWidth - 52
   Gui, 6:Add, Text, x%XPosition% y%YPosition% w%TempW%, Clearing the video cache will cause your game to optimize shaders next time you join a server

YPosition += 38
   TempX := v_WindowWidth - 146
   Gui, 6:Add, Button, x%TempX% y%YPosition% w120 h23 gRemoveVideoCache, Clear Video Cache
return


RunBFSoap:
   Gui, 6: Submit, NoHide
   if v_CleanServerHistory
      GoSub RemoveHistory
   if v_CleanBRHistory
      GoSub RemoveBRboomarks
   if v_CleanLogoCache
      GoSub RemoveLogoCache
return


CheckforDisableClean:
   Gui, 6: Submit, NoHide
   if (v_CleanServerHistory or v_CleanBRHistory or v_CleanLogoCache)
      GuiControl, 6:Enable, CleanNowButton
   else
      GuiControl, 6:Disable, CleanNowButton
return


UpdateCleanerDisplayCounts:
   GoSub AmountofBRbookmarks
   GoSub CountServerHistory
return


/*
======================================================
Remove Video Cache
======================================================
*/

RemoveVideoCache:
   Loop, %A_MyDocuments%\Battlefield 2\mods\*, 2, 0
      FileRecycle, %A_LoopFileLongPath%
   MsgBox Video Cache Cleared!
return


/*
======================================================
Find Size of Logo Cache
======================================================
*/

SizeLogoCache:
   LogoFolderSize := 0
   Loop, %A_MyDocuments%\Battlefield 2\LogoCache\*.*, , 1
      LogoFolderSize += %A_LoopFileSize%

   StringTrimRight, LogoFolderSize, LogoFolderSize, 5
   LogoFolderSize += 0.0
   LogoFolderSize /= 10

   Loop, 15
   {
      StringRight, Temp01, LogoFolderSize, 1
      if (Temp01 = "0")
         StringTrimRight, LogoFolderSize, LogoFolderSize, 1
      else
         break
   }

   if (LogoFolderSize > 0)
      GuiControl, 6:Text, v_CleanLogoCache, Saved Server Logos (%LogoFolderSize% MB)
   else
      GuiControl, 6:Text, v_CleanLogoCache, Saved Server Logos (Clean)
return


/*
======================================================
Remove Logo Cache
======================================================
*/

RemoveLogoCache:
   FileRecycle, %A_MyDocuments%\Battlefield 2\LogoCache
   GoSub SizeLogoCache
return


/*
======================================================
Find Amount of BattleRecorder Bookmarks
======================================================
*/

AmountofBRbookmarks:
   v_BattleRecorderLines := 0
   Gui, 6: Submit, NoHide
   if (ProfileSelect = 1)
   {
      Loop, %NumberOfProfiles%
      {  
         Temp01 := A_Index
         if (Temp01 < 10)
            Temp01 := "0" . Temp01

         ;===COUNT BR LINES

         Loop, Read, %A_MyDocuments%\Battlefield 2\Profiles\00%Temp01%\DemoBookmarks.con
         {
            ++v_BattleRecorderLines
         }
      }
   }
   else
   {
      Temp01 := ItemPosition%ProfileSelect%
      ;===COUNT BR LINES
      Loop, Read, %A_MyDocuments%\Battlefield 2\Profiles\00%Temp01%\DemoBookmarks.con
      {
         ++v_BattleRecorderLines
      }
   }

   if (v_BattleRecorderLines = 1)
      GuiControl, 6:Text, v_CleanBRHistory, BattleRecorder History (%v_BattleRecorderLines% Bookmark)
   else if (v_BattleRecorderLines = 0)
      GuiControl, 6:Text, v_CleanBRHistory, BattleRecorder History (Clean)
   else
      GuiControl, 6:Text, v_CleanBRHistory, BattleRecorder History (%v_BattleRecorderLines% Bookmarks)
return


/*
======================================================
Remove BattleRecorder Bookmarks
======================================================
*/

RemoveBRboomarks:
   Gui, 6: Submit, NoHide
   if (ProfileSelect = 1)
   {
      Loop, %NumberOfProfiles%
      {  
         Temp01 := A_Index
         if (Temp01 < 10)
            Temp01 := "0" . Temp01

         ;===DELETE BOOKMARKS FILE
         FileRecycle, %A_MyDocuments%\Battlefield 2\Profiles\00%Temp01%\DemoBookmarks.con
      }
   }
   else
   {
      Temp01 := ItemPosition%ProfileSelect%

         ;===DELETE BOOKMARKS FILE
         FileRecycle, %A_MyDocuments%\Battlefield 2\Profiles\00%Temp01%\DemoBookmarks.con
   }
   GoSub AmountofBRbookmarks
return


/*
======================================================
Count Server History
======================================================
*/

CountServerHistory:
   v_ServerHistoryLines := 0
   Gui, 6: Submit, NoHide
   if (ProfileSelect = 1)
   {
      Loop, %NumberOfProfiles%
      {  
         Temp01 := A_Index
         if (Temp01 < 10)
            Temp01 := "0" . Temp01
         
         ;===COUNT HISTORY LINES
         Loop, Read, %A_MyDocuments%\Battlefield 2\Profiles\00%Temp01%\General.con
         {
            If InStr(A_LoopReadLine, "GeneralSettings.addServerHistory")
               ++v_ServerHistoryLines 
         }
      }
   }
   else
   {
      Temp01 := ItemPosition%ProfileSelect%
      ;===COUNT HISTORY LINES
      Loop, Read, %A_MyDocuments%\Battlefield 2\Profiles\00%Temp01%\General.con
      {
         If InStr(A_LoopReadLine, "GeneralSettings.addServerHistory")
            ++v_ServerHistoryLines 
      }
   }

   if (v_ServerHistoryLines = 1)
      GuiControl, 6:Text, v_CleanServerHistory, Recently Played Server History (%v_ServerHistoryLines% Server)
   else if (v_ServerHistoryLines = 0)
      GuiControl, 6:Text, v_CleanServerHistory, Recently Played Server History (Clean)
   else
      GuiControl, 6:Text, v_CleanServerHistory, Recently Played Server History (%v_ServerHistoryLines% Servers)
return


/*
======================================================
Remove Played Server History
======================================================
*/

RemoveHistory:

   Gui, 6: Submit, NoHide
   if (ProfileSelect = 1)
   {
      Loop, %NumberOfProfiles%
      {  
         Temp01 := A_Index
         if (Temp01 < 10)
            Temp01 := "0" . Temp01
         
         ;===BACKUP GENERAL.CON
         FileCopy, %A_MyDocuments%\Battlefield 2\Profiles\00%Temp01%\General.con, %A_MyDocuments%\Battlefield 2\Profiles\00%Temp01%\General BACKUP.con

         ;===REMOVE LINES AND COPY TO NEW DOC
         Loop, Read, %A_MyDocuments%\Battlefield 2\Profiles\00%Temp01%\General.con, %A_MyDocuments%\Battlefield 2\Profiles\00%Temp01%\General2.con
         {
            If !InStr(A_LoopReadLine, "GeneralSettings.addServerHistory")
               FileAppend, %A_LoopReadLine%`n
         }

         ;===DELETE ORIGNAL GENERAL.CON AND RENAME NEW ONE
         FileRecycle, %A_MyDocuments%\Battlefield 2\Profiles\00%Temp01%\General.con
         FileMove, %A_MyDocuments%\Battlefield 2\Profiles\00%Temp01%\General2.con, %A_MyDocuments%\Battlefield 2\Profiles\00%Temp01%\General.con
      }
   }
   else
   {
      Temp01 := ItemPosition%ProfileSelect%

      ;===BACKUP GENERAL.CON
      FileCopy, %A_MyDocuments%\Battlefield 2\Profiles\00%Temp01%\General.con, %A_MyDocuments%\Battlefield 2\Profiles\00%Temp01%\General BACKUP.con

      ;===REMOVE LINES AND COPY TO NEW DOC
      Loop, Read, %A_MyDocuments%\Battlefield 2\Profiles\00%Temp01%\General.con, %A_MyDocuments%\Battlefield 2\Profiles\00%Temp01%\General2.con
      {
         If !InStr(A_LoopReadLine, "GeneralSettings.addServerHistory")
            FileAppend, %A_LoopReadLine%`n
      }

      ;===DELETE ORIGNAL GENERAL.CON AND RENAME NEW ONE
      FileRecycle, %A_MyDocuments%\Battlefield 2\Profiles\00%Temp01%\General.con
      FileMove, %A_MyDocuments%\Battlefield 2\Profiles\00%Temp01%\General2.con, %A_MyDocuments%\Battlefield 2\Profiles\00%Temp01%\General.con
   }
   GoSub CountServerHistory
return
