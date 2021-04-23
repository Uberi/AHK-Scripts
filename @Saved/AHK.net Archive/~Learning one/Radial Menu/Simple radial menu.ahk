;===Description=========================================================================
; Simple radial menu (40x40 buttons)       by Learning one
; AHK forum location: http://www.autohotkey.com/forum/viewtopic.php?p=308352#308352

; "Newbie friendly style"
; This script draws radial menu when you press & hold RButton. Click on item with LButton to execute item's subroutine.
; Short RButton click (shorter than BuildDelay variable's value in "settings") sends normal RButton click
; Press Escape to ExitApp

; Script can also serve as AlwaysOnTop toolbar. No "touch to select", so click to select.
; Some thoughts: You can draw multiple rings of buttons, so you can have much more than 8 items per menu.
; You can reposition 1, 3, 5, 7, (or all) items closer to center. Than you will form square menu.
; You can even form larger control panels that are AlwaysOnTop, transparent, movable, unfocused. (To move showed menu/control panel
; just press hotkey again at new position)



;===Settings============================================================================
BuildDelay = 200                ; Menu show delay (in miliseconds). This delay gives you opportunity to send normal RButton click
ButtonBack = Button3 40x40.png  ; Button's background
TransBack = 1                   ; Sets transparent Gui's background on/off.    1 means: on, 0 means: off
UnfocusMenu = 1                 ; Activates window that was active before pressing hotkey, so you can scroll it, type text, etc...
ReturnMouse = 1                 ; Returns mouse in initial position   

;===Set item names here=== (use `n if you need)
Item1_name = Item1      
Item2_name = Item2
Item3_name = Item3
Item4_name = Item4
Item5_name = Item5
Item6_name = Item6
Item7_name = Item7
Item8_name = Item8

; Define your own BUTTON ACTIONS, and a HOTKEY few lines lower. You will se the marks: ;===SET BUTTON ACTIONS HERE=== ;===SET HOTKEY HERE===
   


;===Auto-execute========================================================================
IfNotExist, %A_scriptdir%\%ButtonBack%
{
   URLDownloadToFile, http://www.autohotkey.net/~Learning one/Radial Menu/%ButtonBack%, %A_scriptdir%\%ButtonBack%
   Sleep, 500
}

Gui 90: +AlwaysOnTop +ToolWindow -caption +LastFound
WinSet, Region, 1-0 W180 H180 R180-180
Gui 90:Font, s7 cwhite, Arial
Gui 90:Color, fffffd

Gui 90:Add, Picture, x70 y10 w40 h40 BackgroundTrans gItem1, %A_scriptdir%\%ButtonBack%
Gui 90:Add, Picture, x115 y25 w40 h40 BackgroundTrans gItem2, %A_scriptdir%\%ButtonBack%
Gui 90:Add, Picture, x130 y70 w40 h40 BackgroundTrans gItem3, %A_scriptdir%\%ButtonBack%
Gui 90:Add, Picture, x115 y115 w40 h40 BackgroundTrans gItem4, %A_scriptdir%\%ButtonBack%
Gui 90:Add, Picture, x70 y130 w40 h40 BackgroundTrans gItem5, %A_scriptdir%\%ButtonBack%
Gui 90:Add, Picture, x25 y115 w40 h40 BackgroundTrans gItem6, %A_scriptdir%\%ButtonBack%
Gui 90:Add, Picture, x10 y70 w40 h40 BackgroundTrans gItem7, %A_scriptdir%\%ButtonBack%
Gui 90:Add, Picture, x25 y25 w40 h40 BackgroundTrans gItem8, %A_scriptdir%\%ButtonBack%
Gui 90:Add, Picture, x70 y70 w40 h40 BackgroundTrans gGuiClose, %A_scriptdir%\%ButtonBack%

Gui 90:Add, Text, x73 y13 w34 h34 Center BackgroundTrans gItem1, %Item1_name%   
Gui 90:Add, Text, x118 y28 w34 h34 Center BackgroundTrans gItem2, %Item2_name%
Gui 90:Add, Text, x133 y73 w34 h34 Center BackgroundTrans gItem3, %Item3_name%
Gui 90:Add, Text, x118 y118 w34 h34 Center BackgroundTrans gItem4, %Item4_name%
Gui 90:Add, Text, x73 y133 w34 h34 Center BackgroundTrans gItem5, %Item5_name%
Gui 90:Add, Text, x28 y118 w34 h34 Center BackgroundTrans gItem6, %Item6_name%
Gui 90:Add, Text, x13 y73 w34 h34 Center BackgroundTrans gItem7, %Item7_name%
Gui 90:Add, Text, x28 y28 w34 h34 Center BackgroundTrans gItem8, %Item8_name%
Gui 90:Add, Text, x73 y78 w34 h24 Center BackgroundTrans gGuiClose, Close`nMenu
Return



;===Subroutines=========================================================================
;===SET BUTTON ACTIONS HERE===
Item1:
Gosub, MutualActions
MsgBox,,You selected:, %A_ThisLabel%,1      ;  Define your own button actions! (MsgBox is just example)
Return

Item2:
Gosub, MutualActions
MsgBox,,You selected:, %A_ThisLabel%,1      ;  Define your own button actions! (MsgBox is just example)
Return

Item3:
Gosub, MutualActions
MsgBox,,You selected:, %A_ThisLabel%,1      ;  Define your own button actions! (MsgBox is just example)
Return

Item4:
Gosub, MutualActions
MsgBox,,You selected:, %A_ThisLabel%,1      ;  Define your own button actions! (MsgBox is just example)
Return

Item5:
Gosub, MutualActions
MsgBox,,You selected:, %A_ThisLabel%,1      ;  Define your own button actions! (MsgBox is just example)
Return

Item6:
Gosub, MutualActions
MsgBox,,You selected:, %A_ThisLabel%,1      ;  Define your own button actions! (MsgBox is just example)
Return

Item7:
Gosub, MutualActions
MsgBox,,You selected:, %A_ThisLabel%,1      ;  Define your own button actions! (MsgBox is just example)
Return

Item8:
Gosub, MutualActions
MsgBox,,You selected:, %A_ThisLabel%,1      ;  Define your own button actions! (MsgBox is just example)
Return

GuiClose:      ; (Close Menu, central button)
MutualActions:
SendInput, {LButton up}
Gui 90:Hide                  
CoordMode, mouse, Screen
if ReturnMouse = 1            ; returns mouse in initial position   
MouseMove,  %mx1%, %my1%      
CoordMode, mouse, Relative
if UnfocusMenu = 1
WinActivate, %ActiveWin%
Return



;===Hotkey==============================================================================
;===SET HOTKEY HERE=== (don't forget to change: if not (GetKeyState("RButton","p")) and SendInput, {RButton})
RButton::
WinGetActiveTitle, ActiveWin
Sleep, %BuildDelay%
if not (GetKeyState("RButton","p"))
{
   SendInput, {RButton}
   Return
}
CoordMode, mouse, Screen
MouseGetPos, mx1, my1         ; gets mouse initial position
RMGuiX := mx1 - 90
RMGuiY := my1 - 90
Gui 90:Show, x%RMGuiX% y%RMGuiY% w180 h180, RadialMenuGui
if TransBack = 1
WinSet, TransColor, fffffd 255, RadialMenuGui
if UnfocusMenu = 1
WinActivate, %ActiveWin%
Return



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ExitApp
Pause::
Suspend
Pause,,1
return

Escape::
Suspend
ExitApp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;