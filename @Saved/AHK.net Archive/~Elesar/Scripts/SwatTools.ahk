/*

   SwatTools
   Author: Elesar
   
   This script was made to simplify the gameplay for the Warcraft III
      custom map SWAT: Aftermath. It provides camera movement via WASD
      and remaps several hotkeys for quicker access.

   History:
      1.03 - 06/02/2011
         Altered ProcessCheck to be off while Options window is open
         Removed frame from window when in windowed maximized mode
         Removed frame from window when in windowed mode

      1.02  - 05/20/2011
         Updated all variables assignments to := instead of =
         Updated to pull WarPath from Registry Key

      1.01 - Unknown
         Minor bug fixes
         Implementation of Options window

      1.00 - Unknown
         Initial Build

   To Do:
      !Fix Options window to launch game when closed if option selected and not found
      *Clean up Options window handling to hide/show instead of destroy
      *Implement better GUI updating for Options window
      +Add option for removing sizing frame when in windowed mode
      ? Implement options for hotkey settings instead of being hard-coded

*/

;<=====  System Settings  ====================================================>
#SingleInstance Force
#NoEnv
SendMode Play

;<=====  Timers  =============================================================>
SetTimer, SusCheck, 2000
SetTimer, ProcessCheck, 2000

;<=====  Version Number  =====================================================>
Ver := 1.03

;<=====  Warcraft Installation Path  =========================================>
RegRead, WarPath, HKEY_CURRENT_USER, Software\Blizzard Entertainment\Warcraft III, InstallPath
War3 := WarPath . "\Warcraft III.exe"
TFT := WarPath . "\Frozen Throne.exe"

;<=====  Read INI  ===========================================================>
INIFile := A_MyDocuments . "\SwatOptions.ini"
IfNotExist, %INIFile%
{
   MsgBox, Settings not found!
   GoSub, Options
}
IniRead, View, %INIFile%, Options, View, -99
IniRead, Pool, %INIFile%, Options, Pool, 0
IniRead, FPS, %INIFile%, Options, FPS, 0
IniRead, AKill, %INIFile%, Options, AKill, 0
IniRead, ALaunch, %INIFile%, Options, ALaunch, 0
IniRead, WinMode, %INIFile%, Options, WinMode, 0
IniRead, WinMax, %INIFile%, Options, WinMax, 0

;<=====  AutoLauncher  =======================================================>
If(ALaunch == 1){
   GoSub, RunGame
}

;<=====  Menu  ===============================================================>
Menu, Tray, Icon, %TFT%,,1
Menu, Tray, Tip, SWAT Tools
Menu, Tray, Add, Launch War3, RunGame
Menu, Tray, Add, Options
Menu, Tray, Add
Menu, Tray, NoStandard
Menu, Tray, Standard

;<=====  GUI  ================================================================>
Gui, +ToolWindow +AlwaysOnTop
Gui, Add, Text, x10 y10 w100 h20 +Center, View Angle (0-60):
Gui, Add, Edit, x120 y10 w100 h20 vView, %View%
Gui, Add, Text, x10 y40 w100 h20 +Center, Pool Value:
Gui, Add, Edit, x120 y40 w100 h20 vPool, %Pool%
Gui, Add, CheckBox, x10 y70 w200 h20 +Center Checked%FPS% vFPS, Enable FPS Meter.
Gui, Add, CheckBox, x10 y100 w200 h20 +Center Checked%AKill% vAKill, ExitApp when Warcraft III closed.
Gui, Add, CheckBox, x10 y130 w200 h20 +Center Checked%ALaunch% vALaunch gUpdateGUI, Launch Warcraft III on script load.
Gui, Add, CheckBox, x10 y160 w200 h20 +Center +Disabled Checked%WinMode% vWinMode gUpdateGUI, Start Warcraft III in Window.
Gui, Add, CheckBox, x10 y190 w200 h20 +Center +Disabled Checked%WinMax% vWinMax gUpdateGUI, Maximize the Warcraft III Window.
Gui, Add, Button, x10 y220 w200 h20 gSaveOptions, Save Options
Gui, Show, xCenter yCenter w230 Hide, SWAT Tools Options v%Ver%
GoSub, UpdateGUI
Return

;<=====  Labels  =============================================================>
Options:
   SetTimer, ProcessCheck, Off
   Gui, Show
   Return

SaveOptions:
   Gui, Submit
   IniWrite, %View%, %INIFile%, Options, View
   IniWrite, %Pool%, %INIFile%, Options, Pool
   IniWrite, %FPS%, %INIFile%, Options, FPS
   IniWrite, %AKill%, %INIFile%, Options, AKill
   IniWrite, %ALaunch%, %INIFile%, Options, ALaunch
   IniWrite, %WinMode%, %INIFile%, Options, WinMode
   IniWrite, %WinMax%, %INIFile%, Options, WinMax
   SetTimer, ProcessCheck, On
   Return

GuiClose:
   Gui, Hide
   Return

UpdateGUI:
   Gui, Submit, NoHide
   If(ALaunch == 1){
      GuiControl, Enable, WinMode
   }Else{
      GuiControl, Disable, WinMode
      GuiControl,, WinMode, 0
      GuiControl, Disable, WinMax
      GuiControl,, WinMax, 0
   }
   If(WinMode == 1){
      GuiControl, Enable, WinMax
   }Else{
      GuiControl, Disable, WinMax
      GuiControl,, WinMax, 0
   }
   Return

RunGame:
   IfWinExist, ahk_class Warcraft III
      Return
   If(WinMode == 0){
      Run, %TFT%
   }Else{
      Run, %TFT% -window
   }
   Sleep, 3000
   GoSub, WinMax
   Return

WinMax:
   If(WinMax == 1){
      WinMove, ahk_class Warcraft III,,0, 0, %A_ScreenWidth%, %A_ScreenHeight%
      WinActivate, ahk_class Warcraft III
      WinSet, Style, -0xC00000, A
      WinSet, Style, -0x40000, A
      WinSet, AlwaysOnTop, Off, A
   }Else{
      WinActivate, ahk_class Warcraft III
      WinSet, Style, -0xC00000, A
      WinSet, Style, -0x40000, A
      WinSet, AlwaysOnTop, Off, A
   }
   Return

SusCheck:
   If (A_IsSuspended == 1){
      IfWinActive, ahk_class Warcraft III
         SoundPlay,*64
   }
   Return

ProcessCheck:
   If (AKill == 1){
      IfWinNotExist, ahk_class Warcraft III
         ExitApp
   }
   Return

;<=====  Hotkeys  ============================================================>
#IfWinActive ahk_class Warcraft III
LWin::Return

; HotKey Toggle
+Enter::
   Suspend, Permit
   Suspend
   If (A_IsSuspended == 1){
      SoundPlay,*64
      Menu, Tray, Icon, %War3%,,1
   }Else{
      SoundPlay,*48
      Menu, Tray, Icon, %TFT%,,1
   }
   Return

; Basic remapping
Q:: Send {Esc}

E:: Send a

G:: Send o

1:: Send {NumPad1}

2:: Send {NumPad2}

3:: Send {NumPad4}

4:: Send {NumPad5}

5:: Send {NumPad7}

6:: Send {NumPad8}

; Upgrade and cycle Nanites
F::
   If (A_PriorHotKey = "G" AND A_TimeSincePriorHotkey < 500){
      Send f
      Sleep, 550
      Send f
      Sleep, 550
      Send f
   }Else{
      Send f
   }
   Return

; Directional Remaps
W::
   Send {Up Down}
   Loop {
      Sleep, 10
      GetKeyState, WState, W, P
      If (WState == "U"){
         Send {Up Up}
         Sleep, 10
         Send {Up Up}
         Break
      }
   }
   Return

A::
   Send {Left Down}
   Loop {
      Sleep, 10
      GetKeyState, AState, A, P
      If (AState == "U"){
         Send {Left Up}
         Sleep, 10
         Send {Left Up}
         Break
      }
   }
   Return

S::
   Send {Down Down}
   Loop {
      Sleep, 10
      GetKeyState, SState, S, P
      If (SState == "U"){
         Send {Down Up}
         Sleep, 10
         Send {Down Up}
         Break
      }
   }
   Return

D::
   Send {Right Down}
   Loop {
      Sleep, 10
      GetKeyState, DState, D, P
      If (DState == "U"){
         Send {Right Up}
         Sleep, 10
         Send {Right Up}
         Break
      }
   }
   Return

; Code Loader
+`::
   StringReplace, Code, clipboard, -,, All
   Send {Enter}%Code%{Enter}
   Sleep, 500
   Send {Enter}-view %View%{Enter}
   Sleep, 500
   Send {Enter}-pool %Pool%{Enter}
   If (FPS == 1){
      Sleep, 500
      Send {Enter}/fps{Enter}
   }
   Return

; Open RCPD
^R::
   IfWinExist, RCPD:
      WinActivate, RCPD:
   Else
      Run, http://night.org/swat2/playerdb/
   Return