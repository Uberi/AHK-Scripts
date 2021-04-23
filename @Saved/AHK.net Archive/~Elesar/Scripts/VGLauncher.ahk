/*

   VGLauncher
   Author: Elesar

   This script handles launching Vanguard while patching in
      fixed cursor files and allows the tweaking of game
      engine settings.

   LaunchPad3 is required for this script, and this works best
      with the "remember me" option set in the LaunchPad.

   History:
      v 0.1 - 08/05/2011
         Initial build

   To Do:
      Improve DL sequence for LaunchPad3
      Improve location and organization of LaunchPad3 files

*/
;<=====  System Settings  ====================================================>
#SingleInstance Force
#NoEnv
CoordMode, Pixel, Relative
CoordMode, Mouse, Relative

;<=====  Read in user settings  ==============================================>
INIRead, firstrun, vglauncher.ini, General, firstrun, 0
INIRead, path, vglauncher.ini, General, path
INIRead, user, vglauncher.ini, General, user
INIRead, pass, vglauncher.ini, General, pass
INIRead, remu, vglauncher.ini, General, remu
INIRead, remp, vglauncher.ini, General, remp
INIRead, ui, vglauncher.ini, Settings, ui
INIRead, cursorfix, vglauncher.ini, Settings, cursorfix
INIRead, cache, vglauncher.ini, Tweaks, cache
INIRead, channels, vglauncher.ini, Tweaks, channels
INIRead, minfps, vglauncher.ini, Tweaks, minfps
INIRead, maxfps, vglauncher.ini, Tweaks, maxfps

;<=====  Firstrun Notification  ==============================================>
If ((firstrun == "ERROR")||(firstrun != 1)){
   MsgBox,4,, This script requires that you have`nLaunchPad3 installed for starting Vanguard.`n If  you do not have this, or are unsure, click yes to download now.
   INIWrite, 1, vglauncher.ini, General, firstrun
   IfMsgBox Yes
      URLDownloadToFile, http://launch.soe.com/app/installer/Vanguard_setup.exe, Vanguard_setup.exe
}

;<=====  Validate settings  ==================================================>
If ((path == "ERROR"_)||(path == "")){
   FileSelectFolder, path,*C:\ProgramData\Sony Online Entertainment\Installed Games\Vanguard
      ,,Select your Vanguard: SoH install location
   INIWrite, %path%, vglauncher.ini, General, path
}

;<=====  Build list of installed UIs  ========================================>
uilist := "Default|"
Loop, %path%\VGUIAssets\Shells\*, 2, 0
{
   If (A_LoopFileName != "Default")
      uilist .= "|" . A_LoopFileName
}

;<=====  Build GUI  ==========================================================>
Gui, Add, GroupBox, x5 y5 w315 h45, Settings
Gui, Add, Text, x25 y22 w25, UI:
Gui, Add, DropDownList, x+5 y20 w100 vui, %uilist%
Gui, Add, CheckBox, x+30 y22 w100 vcursorfix, Use cursor fix

Gui, Add, GroupBox, x5 y60 w315 h135, Tweaks
Gui, Add, Text, x55 y77 w100, Cache size:
Gui, Add, Edit, x+5 y75 w100 Number vcache, 32
Gui, Add, Text, x55 y107 w100, Audio Channels:
Gui, Add, Edit, x+5 y105 w100 Number vchannels, 32
Gui, Add, Text, x55 y137 w100, Minimum FPS:
Gui, Add, Edit, x+5 y135 w100 Number vminfps, 35
Gui, Add, Text, x55 y167 w100, Maximum FPS:
Gui, Add, Edit, x+5 y165 w100 Number vmaxfps, 100

Gui, Add, Button, x5 y205 w315 h30 gLaunch +Default, Launch Game

;<=====  Update GUI to user settings  ========================================>
If (user != "ERROR")
   GuiControl,, user, %user%
If (pass != "ERROR")
   GuiControl,, pass, %pass%
If (remu != "ERROR")
   GuiControl,, remu, %remu%
If (remp != "ERROR")
   GuiControl,, remp, %remp%
If (ui != "ERROR")
   GuiControl, ChooseString, ui, %ui%
If (cursorfix != "ERROR")
   GuiControl,, cursorfix, %cursorfix%
If (cache != "ERROR")
   GuiControl,, cache, %cache%
If (channels != "ERROR")
   GuiControl,, channels, %channels%
If (minfps != "ERROR")
   GuiControl,, minfps, %minfps%
If (maxfps != "ERROR")
   GuiControl,, maxfps, %maxfps%

;<=====  Show GUI  ===========================================================>
Gui, Show, w325, VGLauncher
Return

;<=====  Labels  =============================================================>
Launch:
   Gui, Submit, NoHide

   ; Write settings to INI
   INIWrite, %user%, vglauncher.ini, General, user
   INIWrite, %pass%, vglauncher.ini, General, pass
   INIWrite, %remu%, vglauncher.ini, General, remu
   INIWrite, %remp%, vglauncher.ini, General, remp
   INIWrite, %ui%, vglauncher.ini, Settings, ui
   INIWrite, %cursorfix%, vglauncher.ini, Settings, cursorfix
   INIWrite, %cache%, vglauncher.ini, Tweaks, cache
   INIWrite, %channels%, vglauncher.ini, Tweaks, channels
   INIWrite, %minfps%, vglauncher.ini, Tweaks, minfps
   INIWrite, %maxfps%, vglauncher.ini, Tweaks, maxfps

   ; Launch the game
   Run, %path%\LaunchPad.exe, %path%

   ; Wait for scan to complete
   Loop
   {
      WinActivate, Vanguard
      WinWaitActive, Vanguard
      ImageSearch, xx, yy, 500, 100, 600, 200, *50 %A_ScriptDir%\images\PLAY.jpg
      If (ErrorLevel == 0){
         Sleep, 250
         Break
      }
   }

   ; Patch in fixes
   INIWrite, %ui%, %path%\bin\VGClient.ini, UI, ShellName
   If (cursorfix == 1){
      FileCopy, %A_ScriptDir%\images\ResizeDiagonal.cur, %path%\VGUIAssets\Global\Cursors, 1
      FileCopy, %A_ScriptDir%\images\ResizeDiagonal2.cur, %path%\VGUIAssets\Global\Cursors, 1
      FileCopy, %A_ScriptDir%\images\ResizeHorizontal.cur, %path%\VGUIAssets\Global\Cursors, 1
      FileCopy, %A_ScriptDir%\images\ResizeVertical.cur, %path%\VGUIAssets\Global\Cursors, 1
   }
   INIWrite, %cache%, %path%\bin\sysconfig.ini, Engine.GameEngine, CacheSizeMegs
   INIWrite, %channels%, %path%\bin\VGClient.ini, ALAudio.ALAudioSubsystem, Channels
   INIWrite, %minfps%, %path%\bin\VGClient.ini, WinDrv.WindowsClient, MinDesiredFrameRate
   INIWrite, %maxfps%, %path%\bin\VGClient.ini, WinDrv.WindowsClient, MaxDesiredFrameRate

   ; Click play
   Click, 510, 120

   ; Exit script
   ExitApp
   Return

GuiClose:
   ExitApp
   Return