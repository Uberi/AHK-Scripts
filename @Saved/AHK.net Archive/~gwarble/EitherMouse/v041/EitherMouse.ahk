;=========================
 Name    = EitherMouse
 Version =    0.41
;=== made by joel - aug09 
;=== automatically swaps mouse buttons on secondary
;===============================================
;=========================================
;==================================
;============================
#SingleInstance, Force
#NoEnv
#NoTrayIcon
Critical
SetBatchLines, -1
SetWorkingDir, %A_ScriptDir%
OnExit, Exit
If !A_IsCompiled
 Notify("Compiling...", A_ScriptName,0)
Compile("Run")
 GoSub, CreateTray
 RegRead, Swapped, HKEY_CURRENT_USER, Control Panel\Mouse, SwapMouseButtons 	; windows setting for mouse button swap
 IniRead, FirstMouse, %Name%.ini, Assignments, Primary , 0
 If FirstMouse
  GoSub, IniFound
 Else
  GoSub, Initialize
Return
;==================================
;=== End Auto-Execute Section =====
;==================================


;==================================
;=== Initialization Section =======
;==================================
IniFound:
 IniRead, SecondMouse, %Name%.ini, Assignments, Swapped , "0"			;mouse to swap buttons on
 IniRead, Swapped,     %Name%.ini, Windows Settings, Swapped , % Swapped 	;windows setting
 TrayTip, % Name " " Version, % "Settings loaded successfully!`n`nPrimary Mouse: " FirstMouse "`nSwapped Mouse: " SecondMouse "`nWindows Swapped: " Swapped, , 16
 GoSub, StartMonitor
 SetTimer, TrayTip, -3000
Return

Initialize: 			;===================================================
 IfExist, EitherMouse.ini 	;<<< COMMENT THIS LINE TO ALWAYS AUTO SAVE =========
  AutoSave = 1 			;===================================================
 If 1 = -save 			;<== command line param for autosave
  AutoSave = 1
 SecondMouse = 0
 LastMouse   = 0
 SwappedDesc := !Swapped ? "right" : "left"
 SwappedDesc2 := Swapped ? "right" : "left"
 TrayTip, %Name% %Version%, Initializing...`n`nMove the %SwappedDesc% mouse first!, , 16
 GoSub, FirstGui
 SetTimer, FlashIcon, 300

StartMonitor:
 DetectHiddenWindows, On
 Process, Exist
 hwnd := WinExist("ahk_class AutoHotkey ahk_pid " ErrorLevel)
 DetectHiddenWindows, Off
 Usage       = 2   ; Usage=6:kbd 2:mouse
 UsagePage   = 1
 VarSetCapacity(dev, 12, 0)
 NumPut(UsagePage,   dev, 0, "UShort")
 NumPut(Usage,       dev, 2, "UShort")
 NumPut(0x100,       dev, 4)
 NumPut(hwnd,        dev, 8)
 RawReturn := DllCall("RegisterRawInputDevices"
  , "uint", &dev  ; pRawInputDevices (pointer to an array of RAWINPUTDEVICE)
  , "uint", 1     ; uiNumDevices
  , "uint", 12)   ; cbSize (size of a RAWINPUTDEVICE structure)
 If (ErrorLevel or !RawReturn)
 {
  GoSub, GuiClose
  MsgBox, , % Name " " Version, Registering mouse`ndevices failed.`n`nExiting..., 5
  ExitApp
 }
 FirstIcon := !Swapped ? 3 : 2
 SecondIcon := Swapped ? 3 : 2
 GoSub, DefineHotKeys
 SetTimer, OnInput, -500 		;small delay in case you start app with non-default mouse
Return
OnInput:
 OnMessage(0xFF, "WM_INPUT")
Return
;==================================
;=== End Initialization Section ===
;==================================


;==================================
;=== Device/WM_Input Sections =====
;==================================
WM_INPUT(wParam, lParam) 		;=== detects raw device handle input change
{
 Critical
 SetBatchLines, -1
 global ThisMouse, LastMouse, FirstMouse, SecondMouse
 VarSetCapacity(raw, 40, 0)
 RawReturn := DllCall("GetRawInputData", "uint", lParam, "uint", 0x10000003
     , "uint", &raw, "uint*", 40, "uint", 16, "int")
 If (ErrorLevel or RawReturn = -1 or !ThisMouse := NumGet(raw, 8))
  Return 0
 If LastMouse <> % ThisMouse
  GoSub, MouseChange
 Return 0
}
MouseChange:
 If !FirstMouse
 {
  SetTimer, FlashIcon, 150
  TrayTip, %Name% %Version%, Initializing...`n`nNow move the %SwappedDesc2% mouse!, , 16
  Gui  2:+LastFound
  Winset, AlwaysOnTop, Off
  Gui  1:+LastFound
  Winset, AlwaysOnTop, Off
  GuiControl, 1:, GuiText, % "Now move the`n" SwappedDesc2 " mouse"
  If !Swapped
  {
   GuiControl, 1:, GuiPicL, % "*icon2 " IconFile
   GuiControl, 1:, GuiPicR, % "*icon6 " IconFile
  }
  Else
  {
   GuiControl, 1:, GuiPicL, % "*icon6 " IconFile
   GuiControl, 1:, GuiPicR, % "*icon3 " IconFile
  }
  Gui, 1:Add, Button, x75 y132 w55 h18 cSilver gClearReload vRetry, Retry

  FirstMouse := ThisMouse
  LastMouse := FirstMouse
  SetTimer, GuiClose, -7000
  SetTimer, TrayTip, -6800
  If AutoSave
   SetTimer, Save, -7800
  Return
 }
 If !SecondMouse
 {
  SecondMouse := ThisMouse
  If AutoSave
   TrayTip, % Name " " Version, Second mouse found!`n`nSettings will be saved automatically..., 30, 16
  Else
   TrayTip, % Name " " Version, Second mouse found!`n`nSave settings from this menu..., 30, 16
  SetTimer, FlashIcon, Off
  GuiControl, 1:, GuiPicL,   % "*icon6 " IconFile
  GuiControl, 1:, GuiPicR,   % "*icon6 " IconFile
  GuiControl, 1:, GuiTitle,  % "Success!"
  GuiControl, 1:, GuiTitle2, % "Both mice assigned"
  GuiControl, 1:Move, GuiText, y85
  GuiControl, 1:Move, Retry, x69 y118 w44 h20
  GuiControl, 1:, GuiText,   % "  First   Second`n"FirstMouse " - " SecondMouse
  Gui, 1:Add, Button, x15 y118 w44 h20 cSilver gSave, Save
  SetTimer, GuiClose,  -7000
  SetTimer, TrayTip, -6800
  If AutoSave
   SetTimer, Save, -7800 		;auto-save upon SecondMouse defined
 }
SetMode:
 If ThisMouse = % SecondMouse
 {
  Hotkey, *$LButton, On
  Hotkey, *$RButton, On
  Menu, Tray, Icon, % IconFile, % SecondIcon
 }
 Else
 {
  Hotkey, *$LButton, Off
  Hotkey, *$RButton, Off
  Menu, Tray, Icon, % IconFile, % FirstIcon
 }
 LastMouse := ThisMouse
Return
;==================================
;=== End Device/WM_Input Sections =
;==================================


;==================================
;=== Hotkey Sections ============== ;=== this should be optimized
;==================================
DefineHotkeys:
 If !Swapped
 {
  Hotkey, *$LButton, LButton, Off
  Hotkey, *$RButton, RButton, Off
 }
 Else
 {
  Hotkey, *$LButton, LButtonSwapped, Off
  Hotkey, *$RButton, RButtonSwapped, Off
 }
Return
;=== better handling of switched mouse buttons, thanks to Chris' [of ahk] post
LButton:
 MouseClick, right,,,,, D
 KeyWait, LButton
 MouseClick, right,,,,, U
Return
RButton:
 MouseClick, left,,,,, D
 KeyWait, RButton
 MouseClick, left,,,,, U
Return
RButtonSwapped:
 MouseClick, right,,,,, D
 KeyWait, RButton 	; <--- difference if swapped
 MouseClick, right,,,,, U
Return
LButtonSwapped:
 MouseClick, left,,,,, D
 KeyWait, LButton 	; <--- difference if swapped
 MouseClick, left,,,,, U
Return
;==================================
;=== End Hotkey Sections ==========
;==================================


;==================================
;=== User Interface Section =======
;==================================
FlashIcon: 	;=== flashes tray icon until mice are assigned
 If !FlashIcon
  If (FirstMouse = 0)
  {
   Menu, Tray, Icon, % IconFile, % FirstIcon + 2
   GuiControl, 1:, GuiPicR,   % "*icon" FirstIcon + 2 " " IconFile
  }
  Else
  {
   Menu, Tray, Icon, % IconFile, % SecondIcon + 2
   GuiControl, 1:, GuiPicL,   % "*icon" SecondIcon + 2 " " IconFile
  }
 Else
  If (FirstMouse = 0)
  {
   Menu, Tray, Icon, % IconFile, % FirstIcon ; + 2
   GuiControl, 1:, GuiPicR,   % "*icon" FirstIcon " " IconFile
  }
  Else
  {
   Menu, Tray, Icon, % IconFile, % SecondIcon ; + 2
   GuiControl, 1:, GuiPicL,   % "*icon" SecondIcon " " IconFile
  }

 FlashIcon := !FlashIcon
Return

FirstGui:       ;=== gui created when no mice are defined
 Gui, 1:-Caption +Border +AlwaysOnTop +ToolWindow
 Gui  1:+LastFound
 Gui, 1:Color, White
 If !Swapped
 {
  Gui, 1:Add, Picture, x32   y55 w32  h32 Icon6 vGuiPicL, % IconFile
  Gui, 1:Add, Picture, x64   y55 w32  h32 Icon3 vGuiPicR, % IconFile
 }
 Else
 {
  Gui, 1:Add, Picture, x32   y55 w32  h32 Icon2 vGuiPicL, % IconFile
  Gui, 1:Add, Picture, x64   y55 w32  h32 Icon6 vGuiPicR, % IconFile
 } 
 Gui, 1:Font, s12 w600 cBlack
 Gui, 1:Add, Text,    x5   y5 w118 h30 Center vGuiTitle, %Name%
 Gui, 1:Font, s10 w100
 Gui, 1:Add, Text,    x5   y25 w118 h20 Center BackgroundTrans vGuiTitle2, %Version%
 Gui, 1:Add, Text,    x5   y100 w118 h40 Center BackgroundTrans vGuiText, Move the %SwappedDesc%`nmouse first
 Gui, 2:-Caption +Border +AlwaysOnTop +ToolWindow +LabelBackground +E0x20
 Gui  2:+LastFound
 Gui, 2:Color, Black
 WinSet, Transparent, 135
 WinSet, Region, 0-0 w276 h296 R27-27
 Gui, 2:Show, w276 h296, %Name% Background
 Gui, 1:Show, w128 h148, %Name% %Version%
Return
;==================================
;=== End GUI Sections =============
;==================================


;==================================
;=== Settings Sections ============
;==================================
MouseSettings:
 TrayTip, % Name " " Version, % "EitherMouse will restart when`nMouse Properties is closed...", 30, 16
 Run control mouse
 WinWait, Mouse Properties
 WinWaitClose
 GoSub, ClearReload
Return
SwapWindows:
 MsgBox, 260, % Name, This automatically:`n`nopen%A_Tab%[Mouse Properties]`ntoggle%A_Tab%[Swap Mouse Buttons]`nclose%A_Tab%[Mouse Properties]`nreload%A_Tab%[%Name%],5
 IfMsgBox Yes
 {
  Run control mouse
  WinWait Mouse Properties
  WinActivate
  ControlGetText, OutputVar
  If OutputVar = Button Configuration
   Send {space}{Enter}
  GoSub, ClearReload
 }
Return
SwappedSwap:
 MsgBox, 260, % Name, Override windows registry setting?`n[this may require a reboot],5
 IfMsgBox Yes
 {
  RegWrite, REG_SZ, HKEY_CURRENT_USER, Control Panel\Mouse, SwapMouseButtons, % !Swapped
  GoSub, ClearReload
 }
Return
SynaptSwap:
 MsgBox, 260, % Name, Override Synaptics registry setting?`n[this may require a reboot]`n`nThis is for my specific Synaptics`ndriver installation and is not universal or tested!,5
 IfMsgBox Yes
 {
  RegWrite, REG_SZ, HKEY_CURRENT_USER, Software\Synaptics\SynTPCpl\TouchPadPS2_3, SwapMouseButtons, % !Swapped
  GoSub, ClearReload
 }
Return
SwapAssignments:
 Temp        := FirstMouse
 FirstMouse  := SecondMouse
 SecondMouse := Temp
 IfExist, % Name ".ini"
  GoSub, Save
Return
;==================================
;=== End of Settings Sections =====
;==================================


;==================================
;=== Install Sections =============
;==================================
Install:
 FileCreateDir, %ProgramFiles%\%Name%
 FileCopy, %Name%.ahk, %ProgramFiles%\%Name%\%Name%.ahk, 1
 FileCopy, %Name%.ini, %ProgramFiles%\%Name%\%Name%.ini, 0
 FileCopy, %Name%.exe, %ProgramFiles%\%Name%\%Name%.exe, 1
 If ErrorLevel = 0
 {
  FileCreateDir, %A_Programs%\%Name%
  FileCreateShortcut, %ProgramFiles%\%Name%\%Name%.exe, %A_Programs%\%Name%\%Name%.lnk
  FileCreateShortcut, %ProgramFiles%\%Name%\%Name%.ahk, %A_Programs%\%Name%\%Name%.ahk.lnk
  IfExist, %A_Startup%\%Name%.lnk
  {
   FileDelete, %A_Startup%\%Name%.lnk
   FileCreateShortcut, %ProgramFiles%\%Name%\%Name%, %A_Startup%\%Name%.lnk
  }
  Run, %ProgramFiles%\%Name%\%A_ScriptName%
  ExitApp
 }
Return
DeleteStartup:
 IfExist, %A_Startup%\%Name%.lnk
  FileDelete, %A_Startup%\%Name%.lnk
Return
CreateStartup:
 GoSub, DeleteStartup
 FileCreateShortcut, %A_ScriptFullPath%, %A_Startup%\%Name%.lnk, %A_ScriptDir%
Return
;==================================
;=== End of Install Sections ======
;==================================

;==================================
;=== Save/Exit/Tray Sections ======
;==================================
Save:
 GoSub, GuiClose
 TrayTip, % Name " " Version, % "Saving settings...`n`nPrimary Mouse: " FirstMouse "`nSwapped Mouse: " SecondMouse "`nWindows Swapped: " Swapped, , 16
 IniWrite, % FirstMouse,  %Name%.ini, Assignments, Primary
 IniWrite, % SecondMouse, %Name%.ini, Assignments, Swapped
 IniWrite, % Swapped,     %Name%.ini, Windows Settings,    Swapped
 SetTimer, TrayTip, -7000
Return
;^+F12::
ClearReload:
 FileDelete, %Name%.ini
Reload:
 GoSub, GuiClose
 MsgBox, , % Name, Reloading..., 1
 Reload
DoNothing:
Return

Exit:
 ;GoSub, GuiClose
 ;MsgBox, , % Name, Exiting..., .75
ExitApp:
ExitApp

CreateTray:
 If A_IsCompiled
  IconFile := A_ScriptName
 Else
  IfExist, % Name ".exe"
   IconFile := Name ".exe"
  Else
   IconFile := "main.cpl"    ;=== icon used if .exe is not available for good icons
 Menu, Tray, NoStandard
 Menu, Tray, Icon, % IconFile, 1
 Menu, Tray, Icon
 Menu, Tray1, Add, %Name%, About
 Menu, Tray1, Default, EitherMouse
 Menu, Tray1, Add
 Menu, Install, Add, Install to Program Files, Install
 Menu, Install, Add, Un-Install..., DoNothing 			;uninstall not implemented
 Menu, Install, Add
 Menu, Install, Add, Add to Startup, CreateStartup
 Menu, Install, Add, Delete from Startup, DeleteStartup
 Menu, Advanced, Add, Installation Options, :Install
 Menu, Advanced, Add
 Menu, Advanced, Add, Open Mouse Properties, MouseSettings
 Menu, Advanced, Add
 Menu, Advanced, Add, Swap Windows Setting, SwapWindows
 Menu, Advanced, Add, Swap Registry Setting,  SwappedSwap
 If !A_IsCompiled
  Menu, Advanced, Add, Swap Synaptics Setting,  SynaptSwap
 Menu, Options, Add, Save Assignments...,  Save
 Menu, Options, Add, Swap Assignments, SwapAssignments
 Menu, Options, Add, Delete Assignments..., ClearReload
 Menu, Options, Add
 Menu, Options, Add, Advanced, :Advanced
 Menu, Options, Add
 Menu, Options, Add, Restart..., Reload
 Menu, Tray1, Add, Swap Mouse Buttons, SwapAssignments
 Menu, Tray1, Add, Options, :Options
 Menu, Tray1, Add
 Menu, Tray1, Add, Exit, ExitApp
 Menu, Tray, Tip, % " `n  " Name " " Version "  `n "
 OnMessage(0x404, "AHK_NOTIFYICON") 
Return
AHK_NOTIFYICON(wParam, lParam) { 
 If (lParam = 0x206 or lParam = 0x203) ; WM_RBUTTONDBLCLK or L
 {
  SetTimer, ShowMenu, off
  SetTimer, About, -50
 }
 Else If (lParam = 0x202 or lParam = 0x205 )     ; WM_LBUTTONUP or R
  ;SetTimer, About, Off
  SetTimer, ShowMenu, -50
}
ShowMenu: 
 Menu, Tray1, Show 
Return
TrayTip:
 TrayTip ;destroyed
Return

About:
 GoSub, GuiClose
 Gui, 1:-Caption +Border +AlwaysOnTop +ToolWindow
 Gui  1:+LastFound
 Gui, 1:Color, White
 ;Gui, 1:Add, Picture, x6    y3 w32  h32 Icon2, % IconFile
 Gui, 1:Add, Picture, x6   y3 w32  h32 Icon1, % IconFile
 ;Gui, 1:Add, Picture, x130  y3 w32  h32 Icon3, % IconFile
 Gui, 1:Font, s12 w600 cBlack
 Gui, 1:Add, Text,    x15    y30 w138 h30 Center BackgroundTrans, %Name%
 Gui, 1:Font, s8 w0
 Gui, 1:Add, Text,    x5    y48 w158 h15 Center BackgroundTrans, v%Version% - made by joel - aug 09
 Gui, 1:Add, Text,    x5    y70 w158 h130 Center, Sharing a computer with a left-handed user?`n`nEitherMouse seemlessly swaps mouse buttons for you as the mouse being used changes!`n`nYou can now leave 2 mice connected and use either at any time, immediately
 Gui, 1:Add, Button, x154 y2 w12 h12 cSilver gGuiClose, X
 Gui, 2:-Caption +Border +AlwaysOnTop +ToolWindow +LabelBackground +E0x20
 Gui  2:+LastFound
 Gui, 2:Color, Black
 WinSet, Transparent, 135
 WinSet, Region, 0-0 w276 h296 R27-27
 Gui, 2:Show, w276 h296, EitherMouse Background
 Gui, 1:Show, w168 h208, EitherMouse %Version%
 SetTimer, GuiClose, -15000
Return

GuiClose:
 GuiClosed := 1
 Gui, 1:Destroy
 Gui, 2:Destroy
 SetTimer, TrayTip, -1500
 SetTimer, FlashIcon, Off
 SetTimer, SetMode, -100
Return

Gui2Close:
 Gui, 2:Destroy
Return