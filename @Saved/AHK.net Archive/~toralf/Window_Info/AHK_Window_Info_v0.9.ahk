ScriptName = AHK Window Info 0.9
; License: GNU General Public License
; for details see: www.autohotkey.com/docs/license.htm
;
; by toralf
; forum thread: www.autohotkey.com/forum/viewtopic.php?t=8732
; export code by sosaited www.autohotkey.com/forum/viewtopic.php?t=8732&p=53372#53372
; idea and lot of code of frame drawing by shimanov

; ideas taken from these scripts: 
; Ahk Window Spy 1.3.3 by Decarlo www.autohotkey.com/forum/viewtopic.php?t=4679 
; WinInfo Menu by Jon www.autohotkey.com/forum/viewtopic.php?t=8617

;   OS: Windows XP
;   AHK version: 1.0.42.07     (http://www.autohotkey.com/download/)
;   Language: English
;   Date: 2006-03-19

;changes since 0.8
; - fixed: When script launches, it doesn't flicker at wrong position  
; - added: advanced mouse color picker. A 9x9 field of controls that show the colors of pixels around the mouse pointer
; - added: easy tab - a tab that only has controls for window title/window class/control class/control text/mouse coords
; - added: floating tooltip can be de-/activated with a master option
; - added: when the window text controls or the large list get turned on (on the "advanced" tab )or the radio buttons for the large list change, data is collected from the last window looked at.
; - added: Update is stoppen when Window Info becomes the active window (allows to stop the update by Alt+Tab)
; - changed: GUI has been changed from ToolWindow to normal window to allow Alt+Tab to work
; - changed: renamed tabs to: Easy|Advanced|Mouse|Opt A|Opt B|Log
; - changed: The text in the control text field in the GUI is limited to 200 characters, since it cause 100% CPU load on some PCs. When clicked on it the full text will be put into the clipboard (when "copy-on-focus" is active).
; - changed: The text in the fast window text fields (below the "advanced" tab) in the GUI is limited to 1000 characters. When clicked on it the full text will be put into the clipboard (when "copy-on-focus" is active). This doesn't slow down the data collection, so the auto-update can be kept "ON".
; - changed: Priority of script is set to normal. 
; - changed: Only the collection of data is set to "SetBatchLines, -1" 
; - changed: Export tab has been moved to be the last tab and renamed to "Log"
; - changed: Mouse Pointer has been renamed to Mouse Cursor
; - changed: Control Class as been renamed to Control ClassNN
; - changed: AOT state of GUI is made "On" as default 
; - changed: replaced the clip-on-copy routine with a much simpler one 
;todo
; - update info text
;bugs ?!?!:
; - "Control" fields reflect the wrong control when you hover the mouse over controls inside a GroupBox: they always reflect GroupBox properties instead of the controls inside the GroupBox.  Tested with options dialogs such as Metapad and Outlook.

;changes since 0.7
; - changed: Control text in the GUI is limited to 200 characters, since it cause 100% CPU load on some PCs
; - changed: set priority from above normal to normal (seams to work fine as well)
; - changed: removed the SetBatchlines from the GUI, Only the timed routines to update data have "SetBatchlines, -1"
; - changed: floating tooltip now contains script name, thus mouse can be moved on it and doesn't influence data.

;changes since 0.6
; - improved: if windows upper left corner is outside the screen, it is assumed that the window is maximized and the frame is made smaller to be visible
; - changed: made export tab second tab
; - added: optional tooltip that floats with the mouse pointer now also available with limited data when GUI is hidden
; - changed: Info page, now is a gui that uses a edit control to display the text, the gui is resizable

;changes since 0.5
; - added: option to append export data to file
; - added: AOT state of GUI is stored in INI
; - added: option to turn on/off Info-ToolTips
; - added: optional tooltip that floats with the mouse pointer
; - added: option to adjust update frequency
; - changed: frame tooltips will be shown above frame when enough space available, for contols they might be shown below if there is no space above and left of windows tooltip if their positions would be identical
; - changed: mouse can be moved on frames and tooltips, but data will not be updated, this solves the problem of "pumping" frames.
; - changed: Gui with frames is repetively set to AOT, so that frames are also drawn on AOT apps.
; - improved: Gui resize on changing visibilty of window text and large list control.
; - changed: tooltip for Pause now shows "AHK Window Info`n---------------------`nUpdate data: Off/On" 

;changes since 0.4
; - added: acknowledgement for shimanovs frame drawing code 
; - added: customize hotkey for auto-update toggle
; - added: GNU General Public License
; - fixed: Read ChkUseSaveHotkey from ini
; - fixed: Some draw frame issues
; - changed: layout of settings tab 
; - changed: Info-Text (I hope it is better to understand now)
; - reordered code  

;changes since 0.3
; - improved code: HideGui handling
; - improved code: CopyOnClick handling
; - added: export code by sosaited 
; - added: more export code 
; - added: Tray menu: Show 
; - added: Draw frame around control and/or window

InformationText =
  (LTrim
    This Gui will reveal information on windows, controls, etc.
    This software is under the GNU General Public License for details see: www.autohotkey.com/docs/license.htm
    
    Move your mouse over the area of interest and see the data in this GUI changing accordingly (auto-update).
    
    When the window text is updated or the data for the large list is collected, the auto-update of the data is stoped to allow you to work with the data. Use the toggle hotkey (see below) to create a new snapshot of data.
    
    These shortcuts exist:
    =================
    
    => Toggle Auto-Update Hotkey (default: Pause):
    ---------------------------------------------------------------------------
    Toggles (start/stop) auto-updating data in GUI OR creates a new snapshot of data when auto-update has been stoped. 
    
    => Middle-Mouse Button:
    ---------------------------------------
    Toggles AlwaysOnTop status of this window. Click inside the window, it will not work on the titlebar.
    
    => Win+s hotkey combination:
    ------------------------------------------------
    Exports data to file. It will only work, when auto-update has been stoped. 
    
    Remarks:
    =======
    - You can change the toggle auto-update hotkey (you will not see keys that do not produces visible characters, e.g. the default Pause key). A key has to be specified. A single Ctrl, Shift, Alt, Win key or their combinations are not allowed.
    - The option "Hide/Show Gui" allows you to create snapshots of data while the GUI is hidden. The toggle auto-update hotkey will toggle the visibility of the GUI. Just before the GUI is shown again the data gets collected and the GUI updated.
    - The option "Copy data to clipboard on set-focus" allows you to get the data into the clipboard and paste it anywhere with a single left-click into the data field. It only works, when auto-update has been stoped.
    - The option "Win+s for export" allows you to quickly create a file will all the data you want. It only works, when auto-update has been stoped. See Export Option (below) for more details.  
    
    Export Options:
    ============
    - Use the export tab to store more then a single data field to a file (when auto-update has been stoped).
    - Check the data you want to export to file.
    - Specify a file name you wanto to save the data too. Insert #'s into the filename, if you want %ScriptName% to number the files automatically. 
  )  

#SingleInstance force
GoSub, ReadIni
GoSub, CreateTrayMenu
GoSub, BuildGui

;activate auto-update toggle hotkey
HotKey, %HtkPauseAction%, PauseAction, On

;toggle AOT attribute of GUI with middle mouse click
WM_MBUTTONDOWN = 0x207
OnMessage(WM_MBUTTONDOWN , "ToggleOnTopGui1")

;activate copy-on-click
WM_LBUTTONDOWN = 0x201
If ChkCopyToCB
    OnMessage(WM_LBUTTONDOWN , "WM_LBUTTONDOWN")

;initialize Save hotkey, so it can be easily turned on/off 
HotKey, #s, BtnSaveExport, Off

;set static parameters to draw frames around control and window
Sysget, ScreenWidth, 78   ; get screen size from virtual screen 
Sysget, ScreenHeight, 79 
frame_cc = 0x0000FF       ;set color for frame, 0x00BBGGRR
frame_cw = 0x00FF00       ;set color for frame, 0x00BBGGRR
frame_t  = 2              ;set line thickness for frame, 1-10

;set timer once, so that it knows its interval and can be easily turned on/off
SetTimer, UpdateFrameWhenHidden, %CbbUpdateInterval%
SetTimer, UpdateFrameWhenHidden, Off
SetTimer, UpdateInfo, %CbbUpdateInterval%
If ChkHideGui {
    StopUpdate := True
    SetTimer, UpdateInfo, Off
    ToolTip("Press Pause to hide GUI", 2000)
}Else{
    StopUpdate := False
  }
GoSub, ToogleExportActions
GoSub, PrepareFrameDraw  ;create or destroy frame drawing objects
Return
;######## End of Auto-Exec-Section

ReadIni:
  SplitPath, A_ScriptName, , , , OutNameNoExt
  IniFile = %OutNameNoExt%.ini
  
  IniRead, Gui1Pos                 , %IniFile%, Settings, Gui1Pos                , x0 y0
  IniRead, Gui1AOTState            , %IniFile%, Settings, Gui1AOTState           , 1
  IniRead, RadWindow               , %IniFile%, Settings, RadWindow              , 2
  IniRead, RadControl              , %IniFile%, Settings, RadControl             , 2
  IniRead, SelectedRadList         , %IniFile%, Settings, SelectedRadList        , 1
  IniRead, ChkShowWinText          , %IniFile%, Settings, ChkShowWinText         , 0
  IniRead, ChkShowList             , %IniFile%, Settings, ChkShowList            , 0
  IniRead, HtkPauseAction          , %IniFile%, Settings, HtkPauseAction         , Pause
  IniRead, ChkCopyToCB             , %IniFile%, Settings, ChkCopyToCB            , 1
  IniRead, ChkHideGui              , %IniFile%, Settings, ChkHideGui             , 0
  IniRead, ChkUseSaveHotkey        , %IniFile%, Settings, ChkUseSaveHotkey       , 0
  IniRead, ChkExportMousePosScreen , %IniFile%, Export  , ChkExportMousePosScreen, 1
  IniRead, ChkExportMousePosAWin   , %IniFile%, Export  , ChkExportMousePosAWin  , 0
  IniRead, ChkExportMousePosWin    , %IniFile%, Export  , ChkExportMousePosWin   , 1
  IniRead, ChkExportMousePointer   , %IniFile%, Export  , ChkExportMousePointer  , 0
  IniRead, ChkExportMouseColorRGB  , %IniFile%, Export  , ChkExportMouseColorRGB , 0
  IniRead, ChkExportMouseColorHex  , %IniFile%, Export  , ChkExportMouseColorHex , 0
  IniRead, ChkExportCtrlText       , %IniFile%, Export  , ChkExportCtrlText      , 1
  IniRead, ChkExportCtrlClass      , %IniFile%, Export  , ChkExportCtrlClass     , 1
  IniRead, ChkExportCtrlPos        , %IniFile%, Export  , ChkExportCtrlPos       , 0
  IniRead, ChkExportCtrlSize       , %IniFile%, Export  , ChkExportCtrlSize      , 0
  IniRead, ChkExportWinTitle       , %IniFile%, Export  , ChkExportWinTitle      , 1
  IniRead, ChkExportWinPos         , %IniFile%, Export  , ChkExportWinPos        , 0
  IniRead, ChkExportWinSize        , %IniFile%, Export  , ChkExportWinSize       , 0
  IniRead, ChkExportWinClass       , %IniFile%, Export  , ChkExportWinClass      , 1
  IniRead, ChkExportWinProcess     , %IniFile%, Export  , ChkExportWinProcess    , 1
  IniRead, ChkExportWinUID         , %IniFile%, Export  , ChkExportWinUID        , 0
  IniRead, ChkExportWinPID         , %IniFile%, Export  , ChkExportWinPID        , 0
  IniRead, ChkExportWinStatusText  , %IniFile%, Export  , ChkExportWinStatusText , 1
  IniRead, ChkExportWinTextVisible , %IniFile%, Export  , ChkExportWinTextVisible, 1
  IniRead, ChkExportWinTextHidden  , %IniFile%, Export  , ChkExportWinTextHidden , 0
  IniRead, ChkExportLargeList      , %IniFile%, Export  , ChkExportLargeList     , 1
  IniRead, EdtExportFile           , %IniFile%, Export  , EdtExportFile          , AHK_Window_Info_Data_###.txt
  IniRead, ChkExportAutoNumber     , %IniFile%, Export  , ChkExportAutoNumber    , 1
  IniRead, ChkExportAppend         , %IniFile%, Export  , ChkExportAppend        , 0
  IniRead, ChkShowInfoToolTip      , %IniFile%, Advanced, ChkShowInfoToolTip     , 1
  IniRead, ChkDrawRectCtrl         , %IniFile%, Advanced, ChkDrawRectCtrl        , 0
  IniRead, ChkDrawRectWin          , %IniFile%, Advanced, ChkDrawRectWin         , 0
  IniRead, ChkTtpMaster            , %IniFile%, Advanced, ChkTtpMSPos            , 0
  IniRead, ChkTtpMSPos             , %IniFile%, Advanced, ChkTtpMSPos            , 0
  IniRead, ChkTtpMWPos             , %IniFile%, Advanced, ChkTtpMWPos            , 0
  IniRead, ChkTtpMColor            , %IniFile%, Advanced, ChkTtpMColor           , 0
  IniRead, ChkTtpCClass            , %IniFile%, Advanced, ChkTtpCClass           , 0
  IniRead, ChkTtpCPos              , %IniFile%, Advanced, ChkTtpCPos             , 0
  IniRead, ChkTtpCSize             , %IniFile%, Advanced, ChkTtpCSize            , 0
  IniRead, ChkTtpWClass            , %IniFile%, Advanced, ChkTtpWClass           , 0
  IniRead, ChkTtpWTitle            , %IniFile%, Advanced, ChkTtpWTitle           , 0
  IniRead, CbbUpdateInterval       , %IniFile%, Advanced, CbbUpdateInterval      , 100
  IniRead, CbbColorPickDim         , %IniFile%, Advanced, CbbColorPickDim        , 1x1
Return

CreateTrayMenu:
  ;location of icon file
  IconFile := A_WinDir "\system" iif(A_OSType = "WIN32_WINDOWS","","32") "\shell32.dll"
  ;create traybar menu
  Menu, Tray, Icon, %IconFile%, 172   ;icon for taskbar and for proces in task manager
  Menu, Tray, NoStandard
  Menu, Tray, Tip, %ScriptName%
  Menu, Tray, Add, Show , GuiShow
  Menu, Tray, Default, Show 
  Menu, Tray, Add, Exit , GuiClose
  Menu, Tray, Click, 1
Return

GuiShow:
  Gui, 1:Show                   ;show window again if it has been hidden
  ;GuiControl, Choose, Tab1, 1   ;go to data tab
Return

BuildGui:
  Gui, 1: +Resize +LastFound
  Gui1UniqueID := WinExist() 
  Gui, 1:Margin, 0, 0
  Gui, 1:Add, Tab, w287 h518 vTab1 -Wrap , Easy|Advanced|Mouse|Opt A|Opt B|Log
    Gui, 1:Tab, Easy
      Gui, 1:Add, Text, x5 y28 , Window Title
      Gui, 1:Add, Edit, x+2 yp-3 w211 vEdtEasyWindowTitle, 
    
      Gui, 1:Add, Text, x5 y+5, Window Class
      Gui, 1:Add, Edit, x+2 yp-3 w206 vEdtEasyWindowClass, 

      Gui, 1:Add, Text, x5 y+5, Control ClassNN
      Gui, 1:Add, Edit, x+2 yp-3 w196 vEdtEasyControlClass, 

      Gui, 1:Add, Text, x5 y+5, Control Text
      Gui, 1:Add, Edit, x+2 yp-3 w216 vEdtEasyControlText, 

      Gui, 1:Add, Text, x5 y+5, Mouse Position relative to Window
      Gui, 1:Add, Edit, x+2 yp-3 w110 vEdtEasyMousePosWin,

      Gui, 1:Add, Button, x5 y+20 vBtnShowInfo gBtnShowInfo, Introduction - Please read

    Gui, 1:Tab, Advanced
      Gui, 1:Add, CheckBox, x5 y25 Section vChkShowWinText gChkShowWinText Checked%ChkShowWinText%, Show Window Text below
      Gui, 1:Add, CheckBox, x+0 vChkShowList gChkShowList Checked%ChkShowList%, Show large List on right

      Gui, 1:Add, Text, xs y+10, Mouse Pos. rel. to Window
      Gui, 1:Add, Edit, x+2 yp-3 w73 vEdtDataMousePosWin,
      
      Gui, 1:Add, GroupBox, xs w274 h62, Control      
        Gui, 1:Add, Text, xs+4 yp+18, Text
        Gui, 1:Add, Edit, x+2 yp-3 w104 vEdtControlText, 
      
        Gui, 1:Add, Text, x+5 yp+3, ClassNN
        Gui, 1:Add, Edit, x+2 yp-3 w91 vEdtControlClass, 
      
        Gui, 1:Add, Text, xs+4 y+5, Position
        Gui, 1:Add, Edit, x+2 yp-3 w88 vEdtControlPos, 
      
        Gui, 1:Add, Text, x+5 yp+3, Size
        Gui, 1:Add, Edit, x+2 yp-3 w112 vEdtControlSize, 
        
      Gui, 1:Add, GroupBox, xs w274 h198, Window
        Gui, 1:Add, Text, xs+4 yp+18 , Title
        Gui, 1:Add, Edit, x+2 yp-3 w244 vEdtWindowTitle, 
      
        Gui, 1:Add, Text, xs+4 y+5, Position
        Gui, 1:Add, Edit, x+2 yp-3 w88 vEdtWindowPos, 
      
        Gui, 1:Add, Text, x+5 yp+3, Size
        Gui, 1:Add, Edit, x+2 yp-3 w112 vEdtWindowSize,
      
        Gui, 1:Add, Text, xs+4 y+5, Class
        Gui, 1:Add, Edit, x+2 yp-3 w100 vEdtWindowClass, 
      
        Gui, 1:Add, Text, x+5 yp+3, Process
        Gui, 1:Add, Edit, x+2 yp-3 w94 vEdtWindowProcess, 
      
        Gui, 1:Add, Text, xs+4 y+5, Unique ID
        Gui, 1:Add, Edit, x+2 yp-3 w77 vEdtWindowUID, 
      
        Gui, 1:Add, Text, x+5 yp+3, Process ID
        Gui, 1:Add, Edit, x+2 yp-3 w80 vEdtWindowPID, 
    
        Gui, 1:Add, Text, xs+4 y+4, StatusbarText (Part# - Text)  
        Gui, 1:Add, ListBox, xs+4 y+2 r5 w266 vLsbStatusbarText, 
        
      Gui, 1:Add, GroupBox, xs Section w135 h185 vGrbWindowTextVisible, Visible Window Text
        Gui, 1:Add, Edit, xp+5 yp+14 r12 w125 vEdtWindowTextVisible, 

      Gui, 1:Add, GroupBox, x+8 ys w135 h185 vGrbWindowTextHidden, With Hidden Window Text
        Gui, 1:Add, Edit, xp+5 yp+14 r12 w125 vEdtWindowTextHidden, 
      
    Gui, 1:Tab, Mouse
      Gui, 1:Add, Text, x5 y28, Window
      Gui, 1:Add, Edit, x+2 yp-3 w106 vEdtMousePosWin,
      
      Gui, 1:Add, Text, x+5 yp+3, Screen
      Gui, 1:Add, Edit, x+2 yp-3 w88 vEdtMousePosScreen,
    
      Gui, 1:Add, Text, x5 y+5, Active Window
      Gui, 1:Add, Edit, x+2 yp-3 w73 vEdtMousePosAWin,
    
      Gui, 1:Add, Text, x+5 yp+3, Cursor
      Gui, 1:Add, Edit, x+2 yp-3 w92 vEdtMousePointer,
    
      Gui, 1:Add, Text, x5 y+5, RGB Color
      Gui, 1:Add, Edit, x+2 yp-3 w95 vEdtMouseColorRGB,
    
      Gui, 1:Add, Text, x+5 yp+3, RGB Color
      Gui, 1:Add, Edit, x+2 yp-3 w72 vEdtMouseColorHex,
        
      Gui, 1:Add, GroupBox, x5 y+10 Section w274 h230, Advanced Color Picker
        Gui, 1:Add, Text, xs+4 yp+18, Choose Update Dimension:
        Gui, 1:Add, ComboBox, x+5 yp-3 vCbbColorPickDim gRefreshControlStates, 1x1||3x3|5x5|7x7|9x9

        Gui, 1:Add, Text, xs+4 y+5 w10 h5 Section,
        
        Loop, 9 {
            Row = %A_index%
            Gui, 1:Add, Progress, xs+40 y+1 w18 h18 vPgbColorPicker%Row%1,
            Loop, 8 {
                Column := A_Index + 1
                Gui, 1:Add, Progress, x+1 w18 h18 vPgbColorPicker%Row%%Column%,
              }
          }

    Gui, 1:Tab, Opt A
      Gui, 1:Add, Text, x5 y25 Section , Show window and control data for
      Gui, 1:Add, Radio, xs y+5 vRadWindow gRefreshControlStates, Active Window
      Gui, 1:Add, Radio, xs y+5 Checked gRefreshControlStates, Window under Mouse Pointer

      Gui, 1:Add, Text, xs y+20, Show control data for
      Gui, 1:Add, Radio, xs y+5 vRadControl gRefreshControlStates, Active Control in Window
      Gui, 1:Add, Radio, xs y+5 Checked gRefreshControlStates, Control under Mouse Pointer

      Gui, 1:Add, Checkbox, xs y+15 vChkChangePauseHotkey gChkChangePauseHotkey, Change hotkey to toogle auto-update (default: Pause)
      Gui, 1:Add, Hotkey, xp+15 y+5 w150 vHtkPauseAction gHtkPauseAction Disabled, %HtkPauseAction%

      Gui, 1:Add, Checkbox, xs y+5 vChkHideGui gChkHideGui Checked%ChkHideGui%, Hide/Show GUI with above hotkey`;`nbefore the GUI is shown data will be collected  
       
      Gui, 1:Add, Text, xs y+12, When update is turned off:
      Gui, 1:Add, Checkbox, xs y+5 vChkCopyToCB gChkCopyToCB Checked%ChkCopyToCB%, Copy data to clipboard on set-focus (left-click)  

      Gui, 1:Add, Checkbox, xs y+5 vChkUseSaveHotkey gChkUseSaveHotkey Checked%ChkUseSaveHotkey%, Use Win+S as hotkey to log data to file
                                                         
    Gui, 1:Tab, Opt B
      Gui, 1:Add, Checkbox, x5 y25 Section vChkShowInfoToolTip gRefreshControlStates Checked%ChkShowInfoToolTip%, Show info-tooltips

      Gui, 1:Add, Text, xs y+10 , Draw a rectangle during update around
        Gui, 1:Add, Checkbox, xp+15 y+5 vChkDrawRectCtrl gChkDrawRectCtrl Checked%ChkDrawRectCtrl%, control (red)
        Gui, 1:Add, Checkbox, y+5 vChkDrawRectWin gChkDrawRectWin Checked%ChkDrawRectWin%, window (green)

      Gui, 1:Add, Checkbox, xs y+10 vChkTtpMaster gChkTtpMaster Checked%ChkTtpMaster%, Show tooltip at pointer with data for
        Gui, 1:Add, Checkbox, xp+15 y+5 vChkTtpMSPos gRefreshControlStates Checked%ChkTtpMSPos%, Mouse position on screen *
        Gui, 1:Add, Checkbox, y+5 vChkTtpMWPos gRefreshControlStates Checked%ChkTtpMWPos%, Mouse position on window
        Gui, 1:Add, Checkbox, y+5 vChkTtpMColor gRefreshControlStates Checked%ChkTtpMColor%, Color under mouse pointer
        Gui, 1:Add, Checkbox, y+5 vChkTtpCClass gRefreshControlStates Checked%ChkTtpCClass%, Control class under mouse pointer *
        Gui, 1:Add, Checkbox, y+5 vChkTtpCPos gRefreshControlStates Checked%ChkTtpCPos%, Control position
        Gui, 1:Add, Checkbox, y+5 vChkTtpCSize gRefreshControlStates Checked%ChkTtpCSize%, Control size
        Gui, 1:Add, Checkbox, y+5 vChkTtpWClass gRefreshControlStates Checked%ChkTtpWClass%, Window class *                (* = available when
        Gui, 1:Add, Checkbox, y+5 vChkTtpWTitle gRefreshControlStates Checked%ChkTtpWTitle%, Window title *                          Gui is hidden)
      
      Gui, 1:Add, Text, xs y+10, Select milliseconds to auto-update data
      Gui, 1:Add, ComboBox, xp+15 y+5 vCbbUpdateInterval gCbbUpdateInterval, 100||200|300|400|500|1000|2000

    Gui, 1:Tab, Log
      Gui, 1:Add, GroupBox, x5 y25 Section w274 h70 , Log this Mouse Data
        Gui, 1:Add, Checkbox, vChkExportMousePosScreen Checked%ChkExportMousePosScreen% xs+4 yp+18, Position on Screen 
        Gui, 1:Add, Checkbox, vChkExportMousePosAWin   Checked%ChkExportMousePosAWin%   xs+125 yp, Pos. rel. to active Window 
        Gui, 1:Add, Checkbox, vChkExportMousePosWin    Checked%ChkExportMousePosWin%    xs+4 y+5, Pos. rel. to Window 
        Gui, 1:Add, Checkbox, vChkExportMousePointer   Checked%ChkExportMousePointer%   xs+125 yp, Cursor Style 
        Gui, 1:Add, Checkbox, vChkExportMouseColorRGB  Checked%ChkExportMouseColorRGB%  xs+4 y+5, RGB Color 
        Gui, 1:Add, Checkbox, vChkExportMouseColorHex  Checked%ChkExportMouseColorHex%  xs+125 yp, Hex Color 
      Gui, 1:Add, GroupBox, xs w274 h55 , Log this Control Data 
        Gui, 1:Add, Checkbox, vChkExportCtrlText  Checked%ChkExportCtrlText%            xs+4 yp+18, Control Text 
        Gui, 1:Add, Checkbox, vChkExportCtrlClass Checked%ChkExportCtrlClass%           xs+125 yp, Control ClassNN 
        Gui, 1:Add, Checkbox, vChkExportCtrlPos   Checked%ChkExportCtrlPos%             xs+4 y+5, Control Position 
        Gui, 1:Add, Checkbox, vChkExportCtrlSize  Checked%ChkExportCtrlSize%            xs+125 yp, Control Size 
      Gui, 1:Add, GroupBox, xs w274 h125 , Log this Window Data 
        Gui, 1:Add, Checkbox, vChkExportWinTitle       Checked%ChkExportWinTitle%       xs+4 yp+18, Window Title 
        Gui, 1:Add, Checkbox, vChkExportWinPos         Checked%ChkExportWinPos%         xs+4 y+5, Window Position 
        Gui, 1:Add, Checkbox, vChkExportWinSize        Checked%ChkExportWinSize%        xs+125 yp, Window Size 
        Gui, 1:Add, Checkbox, vChkExportWinClass       Checked%ChkExportWinClass%       xs+4 y+5, Window Class 
        Gui, 1:Add, Checkbox, vChkExportWinProcess     Checked%ChkExportWinProcess%     xs+125 yp, Window Process 
        Gui, 1:Add, Checkbox, vChkExportWinUID         Checked%ChkExportWinUID%         xs+4 y+5, Window Unique ID 
        Gui, 1:Add, Checkbox, vChkExportWinPID         Checked%ChkExportWinPID%         xs+125 yp, Win Process ID 
        Gui, 1:Add, Checkbox, vChkExportWinStatusText  Checked%ChkExportWinStatusText%  xs+4 y+5, Statusbar Text 
        Gui, 1:Add, Checkbox, vChkExportWinTextVisible Checked%ChkExportWinTextVisible% xs+4 y+5, Window Visible Text 
        Gui, 1:Add, Checkbox, vChkExportWinTextHidden  Checked%ChkExportWinTextHidden%  xs+125 yp, Window Hidden Text 

      Gui, 1:Add, Checkbox, xs y+12 vChkExportLargeList  Checked%ChkExportLargeList%, Log Large List         Check:

      ExportOptions =           ;collect all checkboxes, so they can be parsed in a loop
        (LTrim Join,
          ChkExportMousePosScreen,ChkExportMousePosAWin,ChkExportMousePosWin
          ChkExportMousePointer,ChkExportMouseColorRGB,ChkExportMouseColorHex
          ChkExportCtrlText,ChkExportCtrlClass,ChkExportCtrlPos
          ChkExportCtrlSize,ChkExportWinTitle,ChkExportWinPos
          ChkExportWinSize,ChkExportWinClass,ChkExportWinProcess
          ChkExportWinUID,ChkExportWinPID,ChkExportWinStatusText
          ChkExportWinTextVisible,ChkExportWinTextHidden,ChkExportLargeList
        )

      Gui, 1:Add, Button, x+2 yp-5 gBtnExportCheckAll, All 
      Gui, 1:Add, Button, x+2 gBtnExportCheckNone , None 
      Gui, 1:Add, Button, x+2 gBtnExportCheckReverse , Rev

      Gui, 1:Add, Text, xs y+8 ,File: 
      Gui, 1:Add, Edit, x+2 yp-3 w230 vEdtExportFile, %EdtExportFile%
      Gui, 1:Add, Button, x+2 yp-1 gBtnBrowseExportFile,... 

      Gui, 1:Add, Checkbox, xs+20 y+2 Section vChkExportAutoNumber gChkExportAutoNumber Checked%ChkExportAutoNumber%, Replace "#" in filename with Numbers
      Gui, 1:Add, Checkbox, y+2 vChkExportAppend gChkExportAppend Checked%ChkExportAppend%, Append data to file
      
      Gui, 1:Add, Button, x+107 ys+8 vBtnSaveExport gBtnSaveExport, Save 
      
  Gui, 1:Tab
  Gui, 1:Add, Radio, x290 y2 Section vRadList1 gRadList, Slow Visible or
  Gui, 1:Add, Radio, x+5 vRadList2 gRadList, Slow Visible and Hidden Window Text,     or Info on 
  Gui, 1:Add, Radio, x+5 vRadList3 gRadList, all Controls 
  Gui, 1:Add, Radio, x+5 vRadList4 gRadList, all Windows
  Gui, 1:Add, ListView, xs y+5 w370 h339 vLV1 Hidden Count200
    , Z or Stack Order|Unique ID|Window PID|Window Class|Process Name|Hidden|Title or Text|X|Y|Width|Height|Style|ExStyle|Selected|CurrentCol|CurrentLine|LineCount|Choice|Tab|Enabled|Checked
  Gui, 1:Add, Edit, xp+0 yp+0 w370 h339 vEdtSlowWindowText Hidden, 

  ;Apply settings
  If RadWindow = 1
      GuiControl, 1:, RadWindow, 1
  If RadControl = 1
      GuiControl, 1:, RadControl, 1

  GuiControl, 1:, RadList%SelectedRadList%, 1
  If SelectedRadList in 1,2
      GuiControl, 1:Show, EdtSlowWindowText
  Else
      GuiControl, 1:Show, LV1

  GuiControl, 1:ChooseString, CbbUpdateInterval, %CbbUpdateInterval%
  GuiControl, 1:ChooseString, CbbColorPickDim, %CbbColorPickDim%

  GuiIsBuild := False

  GoSub, ChkShowWinText 
  GoSub, ChkShowList 
  GoSub, ChkUseSaveHotkey
  GoSub, ChkExportAutoNumber
  GoSub, ChkExportAppend
  GoSub, ChkTtpMaster

  If Gui1AOTState {
      Gui, 1:+AlwaysOnTop
      TitleExtension = - *AOT*
    }
      
  Gui, 1:Show, AutoSize %Gui1Pos%, %ScriptName% %TitleExtension%
  GuiIsBuild := True

  StringTrimRight, CtrlHandelList, CtrlHandelList, 1    ;remove last comma
Return

;###############################################################################
;###   prepare hotkey or mouse interaction with GUI   ##########################
;###############################################################################

WM_LBUTTONDOWN(wParam, lParam, msg, hwnd){       ;Copy-On-Click for controls
    global 
    local Content 

    If A_GuiControl is space                     ;Control is not known
        Return
    If A_GuiControl not contains Edt,Lsb,Pgb     ;Control something else then edit, listbox or Progressbar control
        Return
    
    ;Check for full text vars
    Fulltext = %A_GuiControl%Full
    If (%Fulltext% <> "")
        Content := %Fulltext%
    Else {
        If A_GuiControl contains Pgb                 ;get value from color pickers
            Content := %A_GuiControl%
        Else
            GuiControlGet, Content, , %A_GuiControl% ;get controls content
      }
    
    If Content is space                     ;content is empty or couldn't be retrieved
        Return
  
    If A_GuiControl contains Class               ;change data for specific fields
        Content = ahk_class %Content%
    Else If A_GuiControl contains UID
        Content = ahk_id %Content%
    Else If A_GuiControl contains PID
        Content = ahk_pid %Content%
    Else If A_GuiControl contains Process
        Content = ahk_pname %Content%
    Else If A_GuiControl contains Pos,Size
      {
        StringReplace, Content, Content, x
        StringReplace, Content, Content, y
        StringReplace, Content, Content, w
        StringReplace, Content, Content, h
        StringReplace, Content, Content, %A_Space%, `,
      }
    Else If A_GuiControl contains Pgb
        Content = 0x%Content%
    ClipBoard = %Content%                   ;put content in clipboard 
  
    If ChkShowInfoToolTip {
        If (StrLen(Content) > 200){             ;give feedback (limit size to 200 characters)
            StringLeft, Content, Content, 200 
            Content = %Content% ...
          }
          ToolTip("ClipBoard = " Content)
      }
  }

PauseAction:                    ;user has pressed toogle auto-update hotkey
  If ChkHideGui {                 ;user wants hide/show toggle
      SetTimer, UpdateInfo, Off   ;update timer not needed
      If not StopUpdate {         ;gui was hidden
          SetTimer, UpdateFrameWhenHidden, Off
          GoSub, UpdateInfo       ;collect data
          StopUpdate := False     ;needs to be set (in case window text or large list has set it to true), will be toggled to True
          GoSub, GuiShow          ;bring GUI to front and show data tab
      }Else {
          Gui, 1:Hide 
          If (ChkDrawRectCtrl OR ChkDrawRectWin)
              SetTimer, UpdateFrameWhenHidden, On  ;turn on timer to draw frames
        }
      ;toggle update status  and show feedback
      StopUpdate := not StopUpdate  
      If ChkShowInfoToolTip
          ToolTip(iif(StopUpdate,"Press " HtkPauseAction " to hide GUI","Wait for " HtkPauseAction " key to`nupdate data and show GUI"),2000)
  }Else {
      ;toggle update status and show feedback
      StopUpdate := not StopUpdate  
      If StopUpdate               ;when stopped, bring GUI to front and show data tab
          GoSub, GuiShow
      If ChkShowInfoToolTip
          ToolTip(Scriptname "`n----------------------------`nUpdate data : " iif(StopUpdate,"Off","On"))
      SetTimer, UpdateInfo, On    ;turn timer on, if it had been off due to previous ChkHideGui=1
    }

  GoSub, ToogleExportActions
  GoSub, PrepareFrameDraw  ;create or destroy frame drawing objects
Return

ToogleExportActions:
  ;Disable Export Save button during update 
  GuiControl, 1:Enable%StopUpdate%, BtnSaveExport

  ;Enable Export Save hotkey when update is stopped and hotkey wanted 
  If (ChkUseSaveHotkey AND StopUpdate)
      HotKey, #s, , On
  Else                 ; ... otherwise de-activate Export Save hotkey
      HotKey, #s, , Off UseErrorLevel
Return

PrepareFrameDraw:           ;create or destroy frame drawing objects
  If (StopUpdate OR (ChkDrawRectCtrl = 0 AND ChkDrawRectWin = 0)){
      DeleteObject( h_brushC )       ;destroy objects 
      DeleteObject( h_brushW ) 
      DeleteObject( h_region ) 
      DeleteObject( hbm_buffer ) 
        
      DeleteDC( hdc_frame ) 
      DeleteDC( hdc_buffer ) 
      Gui, 2:Destroy                 ;destory gui
      FrameGUIExists := False
      ToolTip, , , , 2               ;remove control frame tooltip
      ToolTip, , , , 3               ;remove window frame tooltip
  ;create GUI Only if Gui doesn't exist yet and is needed.
  }Else If ( (ChkDrawRectCtrl OR ChkDrawRectWin) And not FrameGUIExists ){
      ;create transparent GUI covering the whole screen 
      Gui, 2:+Lastfound +AlwaysOnTop
      Gui, 2:Color, Black 
      WinSet, TransColor, Black
      Gui, 2: -Caption +ToolWindow
      Gui, 2:Show, x0 y0 w%ScreenWidth% h%ScreenHeight%, FrameDrawGUI2
      UniqueIDGui2 := WinExist()
      FrameGUIExists := True

      ;create draw objects for that window 
      CreateDrawHandles(UniqueIDGui2, ScreenWidth, ScreenHeight, frame_cc, frame_cw) 
    }
  ;set previous control/window to mothing, so that the frames start to draw after immediatly
  PreviousControlID = 
  PreviousWindowID =
Return

;###############################################################################
;###   Interactions with GUI controls   ########################################
;###############################################################################

ChkShowWinText:
  GuiControlGet, ChkShowWinText, 1:                          ;get current value
  GuiControl, 1:Show%ChkShowWinText%, GrbWindowTextVisible   ;show/hide controls
  GuiControl, 1:Show%ChkShowWinText%, GrbWindowTextHidden
  GuiControl, 1:Show%ChkShowWinText%, EdtWindowTextVisible
  GuiControl, 1:Show%ChkShowWinText%, EdtWindowTextHidden
  If ChkShowWinText {                                        ;set tab and listview to default sizes
      GuiControl, 1:Move, Tab1, h518                         
      GuiControl, 1:Move, LV1,  h492 
  }Else If not ChkShowList
      GuiControl, 1:Move, Tab1, h365 
  If GuiIsBuild
      Gui, 1:Show, AutoSize                                      ;autosize GUI
  If EdtWindowUID is not space
    {
      If ChkShowWinText {                                             ;get data 
          WindowUniqueID = %EdtWindowUID%
          GoSub, GetVisibleHiddenWindowtext
        }
    }
Return
    
ChkShowList:
  Gui, 1:Submit, NoHide                     
  GuiControl, 1:Show%ChkShowList%, RadList1      ;show/hide controls
  GuiControl, 1:Show%ChkShowList%, RadList2
  GuiControl, 1:Show%ChkShowList%, RadList3
  GuiControl, 1:Show%ChkShowList%, RadList4

  Loop, 4                                        ;get choice for large list
      If (RadList%A_Index% = 1)
          SelectedRadList = %A_Index%
  If ChkShowList{                                ;show/hide large list
      If SelectedRadList in 1,2
          GuiControl, 1:Show, EdtSlowWindowText
      Else
          GuiControl, 1:Show, LV1
  }Else {
      GuiControl, 1:Hide, LV1
      GuiControl, 1:Hide, EdtSlowWindowText
    }
  If not ChkShowWinText
      GuiControl, 1:Move, Tab1, h365
  If GuiIsBuild
      Gui, 1:Show, AutoSize                         ;autosize GUI
  If ChkShowList                                    ;get data 
      GoSub, GetDataForLargeList 
Return

RadList:
  LV_Delete()                                      ;clear controls
  GuiControl, 1:, EdtSlowWindowText
  Gui, 1:Submit, NoHide
  StringRight, SelectedRadList, A_GuiControl, 1    ;get which got pressed
  Loop, 4                                          ;deactivate the other
      If (A_Index <> SelectedRadList)
          GuiControl, 1:, RadList%A_Index%, 0
  GoSub, GetDataForLargeList 
Return

GetDataForLargeList:
  If SelectedRadList in 1,2                        ;show/hide edit or listview control
    {
      GuiControl, 1:Hide, LV1
      GuiControl, 1:Show, EdtSlowWindowText
      If EdtWindowUID is not space
        {
          WindowUniqueID = %EdtWindowUID%
          If SelectedRadList = 1                  ;get data depending on choice
              GoSub, GetSlowVisibleWindowText
          Else If SelectedRadList = 2
              GoSub, GetSlowHiddenWindowText
        }
  }Else {
      GuiControl, 1:Show, LV1
      GuiControl, 1:Hide, EdtSlowWindowText
      If (SelectedRadList = 3){                   ;get data depending on choice
          WindowUniqueID = %EdtWindowUID%
          If EdtWindowUID is not space
              GoSub, GetControlListInfo
        }
      Else
          GoSub, GetAllWindowsInfo   
    }
Return

RefreshControlStates:
  Gui, 1:Submit, NoHide           ;get current values
Return

ChkChangePauseHotkey:
  GuiControlGet, ChkChangePauseHotkey, 1:      ;get current value
  If ChkChangePauseHotkey {
      ;de-activate current auto-update toggle hotkey
      HotKey, %HtkPauseAction%, Off
      GuiControl, 1:Enable, HtkPauseAction
  }Else
      GoSub, HtkPauseAction
Return

HtkPauseAction:
  GuiControlGet, HtkPauseAction, 1:      ;get current value
  If HtkPauseAction {
      If HtkPauseAction in ^,+,!
          return
      ;activate new auto-update toggle hotkey
      HotKey, %HtkPauseAction%, PauseAction, On
      GuiControl, 1:Disable, HtkPauseAction
      GuiControl, 1:, ChkChangePauseHotkey, 0
  }Else{
      GuiControl, 1:, ChkChangePauseHotkey, 1
      GuiControl, 1:Enable, HtkPauseAction
      ToolTip("You need to specify a hotkey", 2000)          
    }
Return

ChkCopyToCB:
  GuiControlGet, ChkCopyToCB, 1:      ;get current value
  If ChkCopyToCB
      OnMessage( WM_LBUTTONDOWN, "WM_LBUTTONDOWN" )   ;activate copy-on-click
  Else
      OnMessage( WM_LBUTTONDOWN, "" )             ;deactivate copy-on-click
Return

ChkHideGui:
  GuiControlGet, ChkHideGui, 1:      ;get current value
  GoSub, PauseAction  
  GuiControl, Choose, Tab1, 4        ;go back to settings tab
Return

ChkUseSaveHotkey:
  GuiControlGet, ChkUseSaveHotkey, 1:      ;get current value
  GoSub, ToogleExportActions
Return

ChkDrawRectCtrl:
  GuiControlGet, ChkDrawRectCtrl, 1:      ;get current value
  GoSub, PrepareFrameDraw
  ToolTip, , , , 2
Return

ChkDrawRectWin:
  GuiControlGet, ChkDrawRectWin, 1:      ;get current value
  GoSub, PrepareFrameDraw
  ToolTip, , , , 3
Return

CbbUpdateInterval:
  GuiControlGet, CbbUpdateInterval, 1:      ;get current value
  If not ChkHideGui
      SetTimer, UpdateInfo, %CbbUpdateInterval%
  SetTimer, UpdateFrameWhenHidden, %CbbUpdateInterval%
  SetTimer, UpdateFrameWhenHidden, Off
Return

ChkTtpMaster:
  GuiControlGet, ChkTtpMaster, 1:      ;get current value
  GuiControl, 1:Enable%ChkTtpMaster%, ChkTtpMSPos  
  GuiControl, 1:Enable%ChkTtpMaster%, ChkTtpMWPos  
  GuiControl, 1:Enable%ChkTtpMaster%, ChkTtpMColor  
  GuiControl, 1:Enable%ChkTtpMaster%, ChkTtpCClass  
  GuiControl, 1:Enable%ChkTtpMaster%, ChkTtpCPos  
  GuiControl, 1:Enable%ChkTtpMaster%, ChkTtpCSize  
  GuiControl, 1:Enable%ChkTtpMaster%, ChkTtpWClass  
  GuiControl, 1:Enable%ChkTtpMaster%, ChkTtpWTitle  
return

;###############################################################################
;###   GUI actions   ###########################################################
;###############################################################################

GuiSize:
  GuiControl, 1:Move, Tab1, h%A_GuiHeight% 
  w := A_GuiWidth - 290
  h := A_GuiHeight - 22
  GuiControl, 1:Move, LV1, w%w% h%h%
  GuiControl, 1:Move, EdtSlowWindowText, w%w% h%h% 
  h := h - 313
  GuiControl, 1:Move, GrbWindowTextVisible, h%h% 
  GuiControl, 1:Move, GrbWindowTextHidden, h%h% 
  h := h - 20
  GuiControl, 1:Move, EdtWindowTextVisible, h%h% 
  GuiControl, 1:Move, EdtWindowTextHidden, h%h% 
Return

WriteIni:
  Gui, 1:Submit, NoHide
  WinGetPos, PosX, PosY, SizeW, SizeH, %WinNameGui1%
  Loop, 4
      If (RadList%A_Index% = 1)
          IniWrite, %A_Index%    , %IniFile%, Settings, SelectedRadList
  IniWrite, x%PosX% y%PosY%      , %IniFile%, Settings, Gui1Pos
  IniWrite, %Gui1AOTState%       , %IniFile%, Settings, Gui1AOTState
  IniWrite, %RadWindow%          , %IniFile%, Settings, RadWindow
  IniWrite, %RadControl%         , %IniFile%, Settings, RadControl
  IniWrite, %ChkShowWinText%     , %IniFile%, Settings, ChkShowWinText
  IniWrite, %ChkShowList%        , %IniFile%, Settings, ChkShowList
  IniWrite, %HtkPauseAction%     , %IniFile%, Settings, HtkPauseAction
  IniWrite, %ChkCopyToCB%        , %IniFile%, Settings, ChkCopyToCB
  IniWrite, %ChkHideGui%         , %IniFile%, Settings, ChkHideGui
  IniWrite, %ChkUseSaveHotkey%   , %IniFile%, Settings, ChkUseSaveHotkey
  
  Loop, Parse, ExportOptions, `,
      IniWrite, % %A_LoopField%  , %IniFile%, Export  , %A_LoopField%
  IniWrite, %EdtExportFile%      , %IniFile%, Export  , EdtExportFile          
  IniWrite, %ChkExportAutoNumber%, %IniFile%, Export  , ChkExportAutoNumber
  IniWrite, %ChkExportAppend%    , %IniFile%, Export  , ChkExportAppend
  IniWrite, %ChkShowInfoToolTip% , %IniFile%, Advanced, ChkShowInfoToolTip  
  IniWrite, %ChkDrawRectCtrl%    , %IniFile%, Advanced, ChkDrawRectCtrl
  IniWrite, %ChkDrawRectWin%     , %IniFile%, Advanced, ChkDrawRectWin
  IniWrite, %ChkTtpMaster%       , %IniFile%, Advanced, ChkTtpMaster         
  IniWrite, %ChkTtpMSPos%        , %IniFile%, Advanced, ChkTtpMSPos         
  IniWrite, %ChkTtpMWPos%        , %IniFile%, Advanced, ChkTtpMWPos         
  IniWrite, %ChkTtpMColor%       , %IniFile%, Advanced, ChkTtpMColor        
  IniWrite, %ChkTtpCClass%       , %IniFile%, Advanced, ChkTtpCClass        
  IniWrite, %ChkTtpCPos%         , %IniFile%, Advanced, ChkTtpCPos          
  IniWrite, %ChkTtpCSize%        , %IniFile%, Advanced, ChkTtpCSize         
  IniWrite, %ChkTtpWClass%       , %IniFile%, Advanced, ChkTtpWClass        
  IniWrite, %ChkTtpWTitle%       , %IniFile%, Advanced, ChkTtpWTitle        
  IniWrite, %CbbUpdateInterval%  , %IniFile%, Advanced, CbbUpdateInterval   
  IniWrite, %CbbColorPickDim%    , %IniFile%, Advanced, CbbColorPickDim
Return

GuiClose:
GuiEscape:
  GoSub, WriteIni
  ExitApp
Return

;###############################################################################
;###   GUI for information text   ##############################################
;###############################################################################

BtnShowInfo:
  GuiControl, 1:Disable, BtnShowInfo 
  Gui, 3:+Owner1 +AlwaysOnTop +ToolWindow +Resize
  Gui, 3:Add, Button, gCloseInfoGui, Close
  Gui, 3:Add, Edit, w600 h400 vEdtInfoText, %InformationText%
  Gui, 3:Show,, Info - %ScriptName%
Return

3GuiClose:
3GuiEscape:
CloseInfoGui:
  GuiControl, 1:Enable, BtnShowInfo 
  Gui, 3: Destroy
Return

3GuiSize:
  w := A_GuiWidth - 20
  h := A_GuiHeight - 45
  GuiControl, 3:Move, EdtInfoText, w%w% h%h%
Return

;###############################################################################
;###   draw frame around control and or window   ###############################
;###############################################################################

;a speed optimized version of "UpdateInfo" (see below), to allow frames to be drawn, wenn GUI is hidden
UpdateFrameWhenHidden:       
  SetBatchLines, -1

  GoSub, CheckForFramesAndTipsAndGetMousePos
  GoSub, SetWhichWindow
  GoSub, SetWhichControl

  ;pptional tooltip
  If ChkTtpMaster {
      InfoString := iif(ChkTtpMSPos,"MScreen: " MouseScreenX "," MouseScreenY "`n")
                  . iif(ChkTtpCClass,"Control ClassNN: " MouseControlID "`n")
                  . iif(ChkTtpWClass,"Window Class: " WindowClass "`n")
                  . iif(ChkTtpWTitle,"Window Title: " WindowTitle "`n")
      StringTrimRight, InfoString, InfoString, 1    ;remove last `n
      If InfoString
          ToolTip(Scriptname "`n----------------------------`n" InfoString)
    }
  
  If ( ( PreviousControlID <> ControlID )                              ;the control has changed
     AND StatusDrawFrame )                                             ;AND the Mouse is not on the active window which should be drawn 
     DrawFrameAroundControl(ControlID, WindowUniqueID, frame_t) 

  ;memorize IDs
  PreviousControlID = %ControlID%
  PreviousWindowID = %WindowID%
Return

;check if frames or tool tips are under mouse pointer
CheckForFramesAndTipsAndGetMousePos:
  ;get mouse positions relative to screen
  CoordMode, Mouse, Screen  
  MouseIsOnFrameGUI := False
  MouseGetPos, MouseScreenX, MouseScreenY, MouseWindowUID, MouseControlID, 1  
  WinGetClass, WindowClass, ahk_id %MouseWindowUID%
  WinGetTitle, WindowTitle, ahk_id %MouseWindowUID% 
  If ( MouseWindowUID = UniqueIDGui2                    ;if window is frame gui
       OR (WindowClass = "tooltips_class32"                ;or window is tooltip
           AND ( WindowTitle = PreviousControlID               ;and has the title of the last control
                 OR WindowTitle = PreviousWindowID             ;or has the title of the last window
                 OR InStr(WindowTitle,Scriptname)) ) ) ;{      ;or has a title that contains the script name, then it might be one of the info tooltips   
      MouseIsOnFrameGUI := True
Return

;set UID of window for which the following data should be retrieved
SetWhichWindow:
  StatusDrawFrame := True
  If (RadWindow = 1){                      ;for active window
      WinGet, WindowUniqueID, ID, A
      If (WindowUniqueID <> MouseWindowUID)  ;mouse is not in active window, don't redraw frames
          StatusDrawFrame := False
  }Else                                    ;for window under mouse pointer
      WindowUniqueID = %MouseWindowUID%
Return
 
;set control ID for which the data should be retrieved 
SetWhichControl:
  If (RadControl = 1)        ;for active control
      ControlGetFocus, ControlID, ahk_id %WindowUniqueID%
  Else                       ;for control under mouse pointer
      ControlID = %MouseControlID%
Return

;draw frames around controls and/or windows
DrawFrameAroundControl(ControlID, WindowUniqueID, frame_t){
    global h_brushC, h_brushW, ChkDrawRectCtrl, ChkDrawRectWin
    
    ;get coordinates of Window and control again
    ;(could have been past into the function but it seemed too much parameters)
    WinGetPos, WindowX, WindowY, WindowWidth, WindowHeight, ahk_id %WindowUniqueID%
    ControlGetPos, ControlX, ControlY, ControlWidth, ControlHeight, %ControlID%, ahk_id %WindowUniqueID%
    
    ;find upper left corner relative to screen
    StartX := WindowX + ControlX 
    StartY := WindowY + ControlY 
      
    ;show ID in upper left corner
    CoordMode, ToolTip, Screen
    
    ;show frame gui above AOT apps
    Gui, 2: +AlwaysOnTop
    
    If ChkDrawRectWin {
        ;if windows upper left corner is outside the screen
        ; it is assumed that the window is maximized and the frame is made smaller
        If ( WindowX < 0 AND WindowY < 0 ){
            WindowX += 4
            WindowY += 4
            WindowWidth -= 8
            WindowHeight -= 8
          }

        ;remove old rectangle from screen and save/buffer screen below new rectangle
        BufferAndRestoreRegion( WindowX, WindowY, WindowWidth, WindowHeight ) 

        ;draw rectangle frame around window
        DrawFrame( WindowX, WindowY, WindowWidth, WindowHeight, frame_t, h_brushW )

        ;show tooltip above window frame when enough space
        If ( WindowY > 22)
            WindowY -= 22

        ;Show tooltip with windows unique ID 
        ToolTip, %WindowUniqueID%, WindowX, WindowY, 3
      }
    Else
        ;remove old rectangle from screen and save/buffer screen below new rectangle
        BufferAndRestoreRegion( StartX, StartY, ControlWidth, ControlHeight )             

    If ChkDrawRectCtrl {
        ;draw rectangle frame around control
        DrawFrame( StartX, StartY, ControlWidth, ControlHeight, frame_t, h_brushC )

        ;show tooltip above control frame when enough space, or below
        If ( StartY > 22)
            StartY -= 22
        Else 
            StartY += ControlHeight
        
        ;show control tooltip left of window tooltip if position identical (e.g. Windows Start Button on Taskbar) 
        If (StartY = WindowY
            AND StartX < WindowX + 50)
            StartX += 50
                        
        ;Show tooltip with controls unique ID 
        ToolTip, %ControlID%, StartX, StartY, 2
      }
    ;set back ToolTip position to default
    CoordMode, ToolTip, Relative
  }

;###############################################################################
;###   getting the data    #####################################################
;###############################################################################

UpdateInfo:
  If StopUpdate
      Return
  
  If (WinActive("A") = Gui1UniqueID )    ;don't update when window becomes the active one
      Return
  
  SetBatchLines, -1
  
  ;get mouse pos and make mouse is not on frames or tooltips
  GoSub, CheckForFramesAndTipsAndGetMousePos
  If MouseIsOnFrameGUI
      Return

  GoSub, GetMouseInfo
  GoSub, SetWhichWindow
  GoSub, GetControlInfo

  ;optional tooltip
  If ChkTtpMaster {
      InfoString := iif(ChkTtpMSPos,"MScreen: " MouseScreenX "," MouseScreenY "`n")
                    . iif(ChkTtpMWPos,"MWindow: " MouseWindowX "," MouseWindowY "`n")
                    . iif(ChkTtpMColor,"MColor: " MouseColorRGB "`n")
                    . iif(ChkTtpCClass,"Control ClassNN: " MouseControlID "`n")
                    . iif(ChkTtpCPos,"Control Pos: " ControlX "," ControlY "`n")
                    . iif(ChkTtpCSize,"Control Size: " ControlWidth "," ControlHeight "`n")
                    . iif(ChkTtpWClass,"Window Class: " WindowClass "`n")
                    . iif(ChkTtpWTitle,"Window Title: " WindowTitle "`n")
        StringTrimRight, InfoString, InfoString, 1    ;remove last `n
        If InfoString
            ToolTip(Scriptname "`n----------------------------`n" InfoString)
    }
    
  GoSub, GetWindowInfo
  If ChkShowWinText
      GoSub, GetVisibleHiddenWindowtext
  
  If ChkShowList {                        ;if large list is shown
      Loop, 4                             ;get choice
          If (RadList%A_Index% = 1)
              SelectedRadList = %A_Index%
      
      If SelectedRadList = 1              ;get data depending on choice
          GoSub, GetSlowVisibleWindowText
      Else If SelectedRadList = 2
          GoSub, GetSlowHiddenWindowText
      Else If SelectedRadList = 3
          GoSub, GetControlListInfo
      Else
          GoSub, GetAllWindowsInfo

      StopUpdate := True                  ;give feedback and stop updating
      If ChkShowInfoToolTip
          ToolTip("Stoped to update data to allow working with "
                  . iif(SelectedRadList = 1,"slow visible window text")
                  . iif(SelectedRadList = 2,"slow visible and hidden window text")
                  . iif(SelectedRadList = 3,"list of controls")
                  . iif(SelectedRadList = 4,"list of windows")
                  . "`nPress Pause key to create a new snapshot", 2000)
    }

  If StopUpdate {             ;when update stopped within this routine, behave as if toggle hotkey was pressed 
      GoSub, ToogleExportActions      
      GoSub, PrepareFrameDraw  ;create or destroy frame drawing objects
      GoSub, GuiShow
    }
Return

GetMouseInfo:
  ;get mouse pos relative to windows
  WinGetPos, WindowActiveX, WindowActiveY,,, A
  WinGetPos, WindowX, WindowY,,, ahk_id %MouseWindowUID%
  MouseWindowActiveX := MouseScreenX - WindowActiveX
  MouseWindowActiveY := MouseScreenY - WindowActiveY
  MouseWindowX := MouseScreenX - WindowX
  MouseWindowY := MouseScreenY - WindowY
  GuiControl, 1:, EdtMousePosScreen, x%MouseScreenX% y%MouseScreenY%
  GuiControl, 1:, EdtMousePosWin, x%MouseWindowX% y%MouseWindowY%
  GuiControl, 1:, EdtEasyMousePosWin, x%MouseWindowX% y%MouseWindowY%
  GuiControl, 1:, EdtDataMousePosWin, x%MouseWindowX% y%MouseWindowY%
  GuiControl, 1:, EdtMousePosAWin, x%MouseWindowActiveX% y%MouseWindowActiveY%

  ;get pointer shape
  GuiControl, 1:, EdtMousePointer, %A_Cursor%
  
  ;get color below mouse pointer
  CoordMode, Pixel, Screen 
  PixelGetColor, MouseColorRGB, %MouseScreenX%, %MouseScreenY%, RGB
  StringMid, MouseColorR, MouseColorRGB, 3, 2
  StringMid, MouseColorG, MouseColorRGB, 5, 2
  StringMid, MouseColorB, MouseColorRGB, 7, 2
  GuiControl, 1:, EdtMouseColorRGB, % "R" HEXtoDEC(MouseColorR) " G" HEXtoDEC(MouseColorG)" B" HEXtoDEC(MouseColorB)
  GuiControl, 1:, EdtMouseColorHex, %MouseColorRGB%

  StringLeft, Dim, CbbColorPickDim, 1
  HalfDim := Dim // 2 + 1
  
  x := MouseScreenX - HalfDim
  Loop, %Dim% {
      x++
      Row := A_Index + 5 - HalfDim
      y := MouseScreenY - HalfDim
      Loop, %Dim% {
          y++
          PixelGetColor, ColorRGB, %x%, %y%, RGB
          StringTrimLeft, ColorRGB, ColorRGB, 2
          Control := "PgbColorPicker" (A_Index + 5 - HalfDim) Row
          %Control% = %ColorRGB%  
          GuiControl, 1:+Background%ColorRGB%,%Control% 
        }
    }
Return

GetControlInfo:
  GoSub, SetWhichControl
  GuiControl, 1:, EdtControlClass, %ControlID%
  GuiControl, 1:, EdtEasyControlClass, %ControlID%

  ;get Pos, Size, Text
  ControlGetPos, ControlX, ControlY, ControlWidth, ControlHeight, %ControlID%, ahk_id %WindowUniqueID%
  ControlGetText, ControlText , %ControlID%, ahk_id %WindowUniqueID%
  EdtControlTextFull := ControlText       ;store full text in extra var 
  EdtEasyControlTextFull := ControlText   ;store full text in extra var 
  If (StrLen(ControlText) > 200){         ;limits the control text in the GUI to 200 characters. An unlimited length caused on some PCs 100% CPU load
      StringLeft, ControlText, ControlText, 200
      ControlText = %ControlText% ...
    }
  GuiControl, 1:, EdtControlText, %ControlText%
  GuiControl, 1:, EdtEasyControlText, %ControlText%
  GuiControl, 1:, EdtControlPos, x%ControlX% y%ControlY%
  GuiControl, 1:, EdtControlSize, w%ControlWidth% h%ControlHeight%

  ;for debug
  ;ToolTip( "( " ChkDrawRectCtrl " OR " ChkDrawRectWin " )`nAND ( " PreviousControlID " <> " ControlID " OR " PreviousControlID " = nix)`nAND " FramesAndToolTipsRemoved " = 0`nAND " ChkHideGui " = 0`nAND " StatusDrawFrame ")")
                                              ;only draw new frames, when
  If ( ( ChkDrawRectCtrl OR ChkDrawRectWin )                           ;user wants to see at least one of the frames
     AND ( PreviousControlID <> ControlID )                            ;AND the control has changed
     AND ChkHideGui = 0                                                ;AND the GUIHide option is off
     AND StatusDrawFrame )                                             ;AND the Mouse is not on the active window which should be drawn 
      DrawFrameAroundControl(ControlID, WindowUniqueID, frame_t) 
  ;memorize IDs
  PreviousControlID = %ControlID%
  PreviousWindowID = %WindowID%
Return

GetWindowInfo:
  ;get Title, Pos, Size, PID, Process, Class
  WinGetTitle, WindowTitle, ahk_id %WindowUniqueID% 
  WinGetPos, WindowX, WindowY, WindowWidth, WindowHeight, ahk_id %WindowUniqueID%
  WinGet, WindowPID, PID, ahk_id %WindowUniqueID% 
  WinGet, WindowProcessName, ProcessName, ahk_pid %WindowPID%
  WinGetClass, WindowClass, ahk_id %WindowUniqueID%
  GuiControl, 1:, EdtWindowTitle, %WindowTitle%
  GuiControl, 1:, EdtEasyWindowTitle, %WindowTitle%
  GuiControl, 1:, EdtWindowPos, x%WindowX% y%WindowY%
  GuiControl, 1:, EdtWindowSize, w%WindowWidth% h%WindowHeight%
  GuiControl, 1:, EdtWindowClass, %WindowClass%
  GuiControl, 1:, EdtEasyWindowClass, %WindowClass%
  GuiControl, 1:, EdtWindowProcess, %WindowProcessName%
  GuiControl, 1:, EdtWindowUID, %WindowUniqueID%
  GuiControl, 1:, EdtWindowPID, %WindowPID%

  ;get and set statusbartext (maximum 10)
  ListOfStatusbarText = 
  Loop, 10 { 
      StatusBarGetText, StatusBarText, %A_Index%, ahk_id %WindowUniqueID%
      If StatusBarText
          ListOfStatusbarText = %ListOfStatusbarText%%A_Index% - %StatusBarText%|
    }
  If ListOfStatusbarText is space
      ListOfStatusbarText = No text found in statusbar
  GuiControl, 1:, LsbStatusbarText, |%ListOfStatusbarText%
Return

GetVisibleHiddenWindowtext:
  ;get visible/hidden window text
  DetectHiddenText, Off
  WinGetText, EdtWindowTextVisible, ahk_id %WindowUniqueID%
  DetectHiddenText, On
  WinGetText, EdtWindowTextHidden, ahk_id %WindowUniqueID%
  DetectHiddenText, Off

  EdtWindowTextVisibleFull := EdtWindowTextVisible       ;store full text in extra var 
  If (StrLen(EdtWindowTextVisible) > 1000){              ;limit the control text in the GUI to 1000 characters
      StringLeft, EdtWindowTextVisible, EdtWindowTextVisible, 1000
      EdtWindowTextVisible = %EdtWindowTextVisible% ...
    }
  EdtWindowTextHiddenFull := EdtWindowTextHidden       ;store full text in extra var 
  If (StrLen(EdtWindowTextHidden) > 1000){             ;limit the control text in the GUI to 1000 characters
      StringLeft, EdtWindowTextHidden, EdtWindowTextHidden, 1000
      EdtWindowTextHidden = %EdtWindowTextHidden% ...
    }

  GuiControl, 1:, EdtWindowTextVisible, %EdtWindowTextVisible%
  GuiControl, 1:, EdtWindowTextHidden, %EdtWindowTextHidden%
Return

GetSlowVisibleWindowText:
  ;get and set slow visible window text
  VarSetCapacity(EdtSlowWindowText, 10000) 
  SetTitleMatchMode, Slow
  WinGetText, EdtSlowWindowText, ahk_id %WindowUniqueID%
  GuiControl, 1:, EdtSlowWindowText, %EdtSlowWindowText%
  SetTitleMatchMode, Fast
Return

GetSlowHiddenWindowText:
  ;get and set slow hidden and visible window text
  VarSetCapacity(EdtSlowWindowText, 10000) 
  SetTitleMatchMode, Slow
  DetectHiddenText, On
  WinGetText, EdtSlowWindowText, ahk_id %WindowUniqueID%
  GuiControl, 1:, EdtSlowWindowText, %EdtSlowWindowText%
  SetTitleMatchMode, Fast
  DetectHiddenText, Off
Return

GetControlListInfo:
  ;get list of controls in z order
  WinGet, ControlList, ControlList, ahk_id %WindowUniqueID%
  
  ;get all data for these controls
  Loop, Parse, ControlList, `n
    {
      ControlID0 = %A_Index%
      ControlID = %A_LoopField%
      ControlID%A_Index% = %ControlID%
      ControlGetPos, ControlX%A_Index%, ControlY%A_Index%, ControlWidth%A_Index%, ControlHeight%A_Index%, %ControlID%, ahk_id %WindowUniqueID%
      ControlGetText, ControlText%A_Index%, %ControlID%, ahk_id %WindowUniqueID%
      ControlGet, ControlChecked%A_Index%, Checked, , %ControlID%, ahk_id %WindowUniqueID%
      ControlGet, ControlEnabled%A_Index%, Enabled, , %ControlID%, ahk_id %WindowUniqueID%
      ControlGet, ControlVisible%A_Index%, Visible, , %ControlID%, ahk_id %WindowUniqueID%
      ControlGet, ControlTab%A_Index%, Tab, , %ControlID%, ahk_id %WindowUniqueID%
      ControlGet, ControlChoice%A_Index%, Choice, , %ControlID%, ahk_id %WindowUniqueID%
      ControlGet, ControlLineCount%A_Index%, LineCount, , %ControlID%, ahk_id %WindowUniqueID%
      ControlGet, ControlCurrentLine%A_Index%, CurrentLine, , %ControlID%, ahk_id %WindowUniqueID%
      ControlGet, ControlCurrentCol%A_Index%, CurrentCol, , %ControlID%, ahk_id %WindowUniqueID%
      ControlGet, ControlSelected%A_Index%, Selected, , %ControlID%, ahk_id %WindowUniqueID%
      ControlGet, ControlStyle%A_Index%, Style, , %ControlID%, ahk_id %WindowUniqueID%
      ControlGet, ControlExStyle%A_Index%, ExStyle, , %ControlID%, ahk_id %WindowUniqueID%
    }

  ;add all data to listview
  GuiControl, -Redraw, LV1          ; speed up adding data
  LV_Delete()                       ; remove old data
  Loop, %ControlID0% {
      LV_Add(""
        , A_Index                     ; Z or Stack Order
        , ControlID%A_Index%          ; Unique ID
        , "" , "", ""                 ; Window PID, Class and Process Name
        , ControlVisible%A_Index%     ; Visible or Hidden?
        , ControlText%A_Index%        ; Title or Text
        , ControlX%A_Index%           ; X
        , ControlY%A_Index%           ; Y
        , ControlWidth%A_Index%       ; Width
        , ControlHeight%A_Index%      ; Height
        , ControlStyle%A_Index%       ; Style
        , ControlExStyle%A_Index%     ; ExStyle
        , ControlSelected%A_Index%    ; Selected
        , ControlCurrentCol%A_Index%  ; CurrentCol
        , ControlCurrentLine%A_Index% ; CurrentLine
        , ControlLineCount%A_Index%   ; LineCount
        , ControlChoice%A_Index%      ; Choice
        , ControlTab%A_Index%         ; Tab
        , ControlEnabled%A_Index%     ; Enabled
        , ControlChecked%A_Index%)    ; Checked
    }   
  LV_ModifyCol()                    ; Auto-size all columns 
  LV_ModifyCol(1, "Integer Left")   ; column Z Order 
  LV_ModifyCol(3, 0)                ; hide column Window PID 
  LV_ModifyCol(4, 0)                ; hide column Window Class 
  LV_ModifyCol(5, 0)                ; hide column Window Process Name 
  LV_ModifyCol(7, "150")            ; column Text 
  GuiControl, +Redraw, LV1
Return

GetAllWindowsInfo:
  ;get list of all visible windows in stack order
  DetectHiddenWindows, Off 
  WinGet, WinIDs, List 
  Loop, %WinIDs% 
      winListIDsVisible := winListIDsVisible WinIDs%A_Index% "`n" 
  
  ;get list of all windows in stack order
  DetectHiddenWindows, On 
  WinGet, WinIDs, List 

  ;get all data for all windows
  Loop, %WinIDs% {
      UniqueID := "ahk_id " WinIDs%A_Index% 
      WinGetPos, WindowX%A_Index%, WindowY%A_Index%, WindowWidth%A_Index%, WindowHeight%A_Index%, %UniqueID%
      WinGet, winPID%A_Index%, PID, %UniqueID% 
      WinGet, processName%A_Index%, ProcessName, % "ahk_pid " winPID%A_Index%
      WinGetTitle, winTitle%A_Index%, %UniqueID%   
      WinGetClass, winClass%A_Index%, %UniqueID%
    } 
  DetectHiddenWindows, off
  
  ;add all data to listview
  GuiControl, -Redraw, LV1          ; speed up adding data
  LV_Delete()                       ; remove old data
  Loop, %WinIDs% {
      LV_Add(""
        , A_Index                   ; Z or Stack Order
        , WinIDs%A_Index%           ; Unique ID
        , winPID%A_Index%           ; Window PID
        , winClass%A_Index%         ; Window Class
        , processName%A_Index%      ; Process Name
        , iif(InStr(winListIDsVisible,WinIDs%A_Index%),"","Hidden")  ; Visible or Hidden?
        , winTitle%A_Index%         ; Title or Text
        , WindowX%A_Index%          ; X
        , WindowY%A_Index%          ; Y
        , WindowWidth%A_Index%      ; Width
        , WindowHeight%A_Index%)    ; Height
    }   
  LV_ModifyCol()                    ; Auto-size all columns 
  LV_ModifyCol(1, "Integer Left")   ; column Stack Order 
  LV_ModifyCol(4, "100")            ; column Class
  LV_ModifyCol(7, "150")            ; column Title
  GuiControl, +Redraw, LV1
Return

;###############################################################################
;###   export the data    ######################################################
;###############################################################################

BtnExportCheckAll:
  Loop, Parse, ExportOptions, `,
      GuiControl, 1:, %A_LoopField%, 1
Return
BtnExportCheckNone:
  Loop, Parse, ExportOptions, `,
      GuiControl, 1:, %A_LoopField%, 0
Return
BtnExportCheckReverse:
  Gui, 1:Submit, NoHide
  Loop, Parse, ExportOptions, `,
      GuiControl, 1:, %A_LoopField%, % not %A_LoopField%
Return

BtnBrowseExportFile:
  Gui, 1:Submit, NoHide
  SelectFile("EdtExportFile", EdtExportFile, "email")
Return

ChkExportAutoNumber:
  Gui, 1:Submit, NoHide
  If ChkExportAutoNumber
      GuiControl, 1:Disable, ChkExportAppend
  Else
      GuiControl, 1:Enable, ChkExportAppend   
Return
ChkExportAppend:
  Gui, 1:Submit, NoHide
  If ChkExportAppend
      GuiControl, 1:Disable, ChkExportAutoNumber
  Else
      GuiControl, 1:Enable, ChkExportAutoNumber   
Return
  
BtnSaveExport:
  Gui, 1:Submit, NoHide

  ;return if no filename is given
  If EdtExportFile is space
    {
      ToolTip("No filename for export specified.", 3000)
      MsgBox, 48, Problem , No export filename is given.
      Return
    }

  ;return if no data is selected for export
  NumberOfExports = 0
  Loop, Parse, ExportOptions, `,
      NumberOfExports := NumberOfExports + %A_LoopField%
  If (NumberOfExports = 0){
      ToolTip("No data selected for export.", 3000)
      Return
    }

  ;get filename
  If (ChkExportAutoNumber){
      FileNameForExport := GetAvailableFileName(EdtExportFile)
      If not FileNameForExport {
          ToolTip("Could get filename for export.`n" ErrorLevel, 3000)
          Return
        }
  }Else
      FileNameForExport = %EdtExportFile%
       
  GuiControl, 1:Disable, BtnSaveExport
  GoSub, ExportDataToFile
  GuiControl, 1:Enable, BtnSaveExport
  If ChkShowInfoToolTip
      ToolTip("Data exported to file: " FileNameForExport, 3000) 
Return

ExportDataToFile: 
  If ChkExportAppend
      FileAppend, `n===========next snapshot===========`n, %FileNameForExport% 
  Else 
      FileDelete, %FileNameForExport%
      
  ExportString := "Data exported from " ScriptName " at " A_Now "`n`nMouse Data`n" 
               . iif(ChkExportMousePosScreen,"Mouse position relative to Screen :`n" EdtMousePosScreen "`n`n")
               . iif(ChkExportMousePosWin,"Mouse position relative to window under mouse pointer :`n" EdtMousePosWin "`n`n")
               . iif(ChkExportMousePosAWin,"Mouse position relative to active window :`n" EdtMousePosAWin "`n`n")
               . iif(ChkExportMousePointer,"Mouse cursor style :`n" EdtMousepointer "`n`n")
               . iif(ChkExportMouseColorRGB,"Pixel Color in RGB format under mouse pointer :`n" EdtMouseColorRGB "`n`n")
               . iif(ChkExportMouseColorHex,"Pixel Color in Hex format (RGB) mouse pointer :`n" EdtMouseColorHex "`n`n")
               . "`nControl data for "
               . iif(RadControl = 1,"active control of " iif(RadWindow = 1,"active window","window under mouse pointer") ,"control under mouse pointer")
               . "`n"
               . iif(ChkExportCtrlText,"Control text :`n" EdtControlText "`n`n")
               . iif(ChkExportCtrlClass,"Control classNN :`n" EdtControlClass "`n`n")
               . iif(ChkExportCtrlPos,"Control position :`n" EdtControlPos "`n`n")
               . iif(ChkExportCtrlSize,"Control size :`n" EdtControlSize "`n`n")
               . "`nWindow data for "
               . iif(RadWindow = 1,"active window","window under mouse pointer")
               . "`n"
               . iif(ChkExportWinTitle,"Window title :`n" EdtWindowTitle "`n`n")
               . iif(ChkExportWinPos,"Window position :`n" EdtWindowPos "`n`n")
               . iif(ChkExportWinSize,"Window size :`n" EdtWindowSize "`n`n")
               . iif(ChkExportWinClass,"Window class :`n" EdtWindowClass "`n`n")
               . iif(ChkExportWinProcess,"Window process name:`n" EdtWindowprocess "`n`n")
               . iif(ChkExportWinUID,"Window unique ID :`n" EdtWindowUID "`n`n")
               . iif(ChkExportWinPID,"Window PID :`n" EdtWindowPID "`n`n")
  FileAppend, %ExportString%, %FileNameForExport% 

  ExportString =
  If ChkExportWinStatusText {
      StringReplace, StatusbarText, ListOfStatusbarText, |, `n, All
      ExportString = `n######## Window Statusbar Text (Part# - Text) :`n%StatusbarText%`n`n
    } 
  If ChkExportWinTextVisible
      ExportString = %ExportString%`n######## Visible Window Text :`n%EdtWindowTextVisible%`n`n
  If ChkExportWinTextHidden
      ExportString = %ExportString%`n######## Visible and Hidden Window Text :`n%EdtWindowTextHidden%`n`n
  FileAppend, %ExportString%, %FileNameForExport% 

  If ChkExportLargeList {
      If EdtSlowWindowText is not space
          ExportString = `n######## Slow visible Window Text :`n%EdtSlowWindowText%
      Else If LV_GetCount() {
          ExportString := "`n########"
                          . iif(RadList3,"Data of all controls of the " iif(RadWindow = 1,"active window","window under the mousepointer") ,"Data of all windows")
          ExportString = %ExportString% :`n
             (LTrim Join`s
                ######## Z or Stack Order, Unique ID, Window PID, Window Class,
                Process Name, Hidden, Title or Text, X, Y, Width, Height, Style,
                ExStyle, Selected, CurrentCol, CurrentLine, LineCount, Choice,
                Tab, Enabled, Checked
                
             )
          Columns := LV_GetCount("Col")
          Loop, % LV_GetCount() {
              Row = %A_Index%
              Loop %Columns% {
                  LV_GetText(Text, Row , A_Index)
                  ExportString = %ExportString%%Text%, 
                } 
              StringTrimRight,ExportString,ExportString,1  ;remove last comma 
              ExportString = %ExportString%`n              ;start new line
            } 
        }  
      If ExportString
          FileAppend, %ExportString%, %FileNameForExport% 
    } 
Return

;###############################################################################
;###   small helper functions   ################################################
;###############################################################################

iif(expr, a, b=""){
    If expr
        Return a
    Return b
  }

ToggleOnTopGui1(wParam, lParam, msg, hwnd) {
    Global Gui1UniqueID, Gui1AOTState

    WinGetTitle, CurrentTitle , ahk_id %Gui1UniqueID%
    If (Gui1AOTState){
        Gui, 1: -AlwaysOnTop
        StringTrimRight, CurrentTitle, CurrentTitle, 8
        WinSetTitle, ahk_id %Gui1UniqueID%, , %CurrentTitle%
    }Else { 
        Gui, 1: +AlwaysOnTop
        WinSetTitle, ahk_id %Gui1UniqueID%, , %CurrentTitle% - *AOT* 
      }
    Gui1AOTState := not Gui1AOTState
  }

ToolTip(Text, TimeOut=1000){
    ToolTip, %Text%
    SetTimer, RemoveToolTip, %TimeOut%
    Return
  }
RemoveToolTip:
   ToolTip
Return

HEXtoDEC(HEX){ 
    StringUpper, HEX, HEX 
    Loop, % StrLen(HEX) { 
        StringMid, Col, HEX, % (StrLen(HEX) + 1) - A_Index, 1 
        If Col is integer 
            DEC1 := Col * 16 ** (A_Index - 1) 
        Else 
            DEC1 := (Asc(Col) - 55) * 16 ** (A_Index - 1) 
        DEC += %DEC1% 
      } 
    return DEC 
  }

SelectFile(Control, OldFile, Text){
    Gui, 1:+OwnDialogs
    StringReplace, OutputVar, OldFile, #, *, All
    IfExist %A_ScriptDir%\%OutputVar%
        StartFolder = %A_ScriptDir%
    Else IfExist %OldFile%
        SplitPath, OldFile, , StartFolder
    Else 
        StartFolder = 
    FileSelectFile, SelectedFile, S18, %StartFolder%, Select file for %Text%, Text file (*.txt)
    If SelectedFile {
        StringReplace, SelectedFile, SelectedFile, %A_ScriptDir%\
        GuiControl, 1: ,%Control%, %SelectedFile%
      }
  }

;#############   Get next free/available File Name   ##########################
GetAvailableFileName(ExportFileName){ 
    ;separate FileName and FileDir
    SplitPath, ExportFileName, FileName, FileDir
  
    ;return ExportFileName if FileName doesn't contain "#"
    If (InStr(FileName, "#") = 0)
        Return, ExportFileName
  
    ;add "\" to FileDir again
    If FileDir
        FileDir = %FileDir%\
  
    ;split FileName with #
    StringSplit, NameArray, FileName, #
    
    ;Search from StartID = 1
    StartID = 1
    Loop { 
        Number := A_Index + StartID - 1
               
        ;untill number is too large ...
        If ( StrLen(Number) > NameArray0 - 1 ) {
            ErrorLevel =
              (LTrim
                All files exist for >%ExportFileName%<
                with all "#" between %StartID% and %Number%.
              )
            Return 0
          }
  
        ;otherwise fill number with leading zeros
        Loop, % NameArray0 - 1 - StrLen(Number)
            Number = 0%Number% 
        
        ;split number in an array
        StringSplit, NumberArray, Number
        
        ;mix and concatenate the names array with the numbers array
        FileName =
        Loop, %NameArray0%
            FileName := FileName . NameArray%A_Index% . NumberArray%A_Index%
        
        ;check if GivenFileName doesn't exist
        If not FileExist(FileDir . FileName)
            Return FileDir . FileName
      } 
  }

;#############   destroy draw objects   ####################################### 
DeleteObject( p_object ) { 
    ;deletes a logical pen, brush, font, bitmap, region, or palette, freeing all system resources 
    DllCall( "gdi32.dll\DeleteObject", "uint", p_object ) 
  } 

DeleteDC( p_dc ) { 
    ;deletes the specified device context (DC). 
    DllCall( "gdi32.dll\DeleteDC", "uint", p_dc ) 
  } 

;#############   create draw objects   ######################################## 
CreateDrawHandles(UniqueID, ScreenWidth, ScreenHeight, frame_cc, frame_cw){ 
    global   hdc_frame, hdc_buffer, h_region, h_brushC, h_brushW 
  
    ;Get handle to display device context (DC) for the client area of a specified window 
    hdc_frame := DllCall( "GetDC" 
                        , "uint", UniqueID ) 
                        
    ;create buffer to store old color data to remove drawn rectangles 
    hdc_buffer := DllCall( "gdi32.dll\CreateCompatibleDC" 
                         , "uint", hdc_frame ) 
    
    ;Create Bitmap buffer to remove drawn rectangles 
    hbm_buffer := DllCall( "gdi32.dll\CreateCompatibleBitmap" 
                         , "uint", hdc_frame 
                         , "int", ScreenWidth 
                         , "int", ScreenHeight ) 
    
    ;Select Bitmap buffer in buffer to remove drawn rectangles 
    DllCall( "gdi32.dll\SelectObject" 
           , "uint", hdc_buffer 
           , "uint", hbm_buffer ) 
  
    ;create a dummy rectangular region. 
    h_region := DllCall( "gdi32.dll\CreateRectRgn" 
                       , "int", 0 
                       , "int", 0 
                       , "int", 0 
                       , "int", 0 ) 
  
    ;specify the color of the control frame. 
    h_brushC := DllCall( "gdi32.dll\CreateSolidBrush" 
                       , "uint", frame_cc ) 
    ;specify the color of the window frame. 
    h_brushW := DllCall( "gdi32.dll\CreateSolidBrush" 
                       , "uint", frame_cw ) 
  }
  
;#############   remove old rectangle and save screen below new rectangle   ### 
BufferAndRestoreRegion( p_x, p_y, p_w, p_h ) { 
    global   hdc_frame, hdc_buffer 
    static   buffer_state, old_x, old_y, old_w, old_h 
      
    ;Copies the source rectangle directly to the destination rectangle. 
    SRCCOPY   = 0x00CC0020 
        
    ;remove previously drawn rectangle (restore previoulsy buffered color data) 
    if ( buffer_state = "full") 
       ;perform transfer of color data of rectangle from source DC into destination DC 
       ; from buffer to screen, erasing the previously darwn reactangle 
       DllCall( "gdi32.dll\BitBlt" 
              , "uint", hdc_frame 
              , "int", old_x 
              , "int", old_y 
              , "int", old_w 
              , "int", old_h 
              , "uint", hdc_buffer 
              , "int", 0 
              , "int", 0 
              , "uint", SRCCOPY ) 
    else 
       buffer_state = full 
  
    ;remember new rectangle for next loop (to be removed) 
    old_x := p_x 
    old_y := p_y 
    old_w := p_w 
    old_h := p_h 
  
    ; Store current color data of new rectangle in buffer 
    DllCall( "gdi32.dll\BitBlt" 
           , "uint", hdc_buffer 
           , "int", 0 
           , "int", 0 
           , "int", p_w 
           , "int", p_h 
           , "uint", hdc_frame 
           , "int", p_x 
           , "int", p_y 
           , "uint", SRCCOPY ) 
  } 
  
;#############   draw frame   ################################################# 
DrawFrame( p_x, p_y, p_w, p_h, p_t, h_brush ) { 
    global   hdc_frame, h_region
      
    ; modify dummy rectangular region to desired reactangle 
    DllCall( "gdi32.dll\SetRectRgn" 
           , "uint", h_region 
           , "int", p_x 
           , "int", p_y 
           , "int", p_x+p_w 
           , "int", p_y+p_h ) 
    
    ; draw region frame with thickness (width and hight are the same) 
    DllCall( "gdi32.dll\FrameRgn" 
           , "uint", hdc_frame 
           , "uint", h_region 
           , "uint", h_brush 
           , "int", p_t 
           , "int", p_t ) 
  } 
