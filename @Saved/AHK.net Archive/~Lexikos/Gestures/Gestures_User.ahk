Gestures:

/*
 * Gestures
 */

; Wheel:        Switch between tabs.
Gesture_WheelUp = ^+{Tab}
Gesture_WheelDown = ^{Tab}

; Up:           Launch My Computer (usually).
Gesture_U = {Launch_App1}

; Down:         Launch Calculator (usually).
Gesture_D = {Launch_App2}

; Left, Up:     Go up one level in explorer.
Gesture_L_U = !{Up}

; Up, ...:      Control media player.
Gesture_U_L = {Media_Prev}
Gesture_U_R = {Media_Next}
Gesture_U_D = {Media_Play_Pause}
Gesture_U_D_U = {Media_Stop}
Gesture_U_L_R = {Launch_Media}

Gesture_D_L = ^{F4}

; Down, Right, Left: Close window immediately.
Gesture_D_R_L = !{F4}

/*
 * Option Overrides
 */

m_PenWidth = 6
m_NodePenWidth = 4
m_PenColor = 0000FF

m_EnabledIcon = 

/*
 * Init for Additional Scripts
 */

SetWinDelay, 2  ; For EasyWindowDrag.ahk

; Windows which gestures are disabled in.  Search below for "#if" or "G_Blacklisted()".
GroupAdd, Blacklist, ahk_class VMPlayerFrame
GroupAdd, Blacklist, ahk_class SynergyDesk
GroupAdd, Blacklist, ahk_class TSSHELLWND
GroupAdd, Blacklist, ahk_class TaskSwitcherWnd  ; Aero Alt+Tab
GroupAdd, Blacklist, Sun VirtualBox ahk_class QWidget

; Use WinClose instead of !{F4} with these windows.
GroupAdd, WinCloseGroup, ahk_class ConsoleWindowClass
GroupAdd, WinCloseGroup, ahk_class AutoHotkey

/*
 * END OF INIT/CONFIG SECTION
 */
return

; Hold XButton1 to show the Alt+Tab dialog.  Release to switch applications.
; With the Aero task-switcher, one can also click the thumbnail to switch.
*XButton1::
    if m_WaitForRelease ; Holding gesture button.
    {
        m_ScrolledWheel := true
        m_ExitLoop := true
        Send {Media_Next}
        return
    }
    Send {Blind}{Alt Down}{Tab}
    MouseGetPos, x, y
    if (x < 0) ; Put it on the appropriate monitor, assumes only two monitors,
    {          ; where the secondary monitor is to the left of the primary.
        WinWait, ahk_class TaskSwitcherWnd,, 0.2
        if !ErrorLevel
        {
            SysGet, Mon2, MonitorWorkArea, 1
            WinGetPos, x, y, w, h
            x := Mon2Left+(Mon2Right-Mon2Left-w)//2
            y := Mon2Top+(Mon2Bottom-Mon2Top-h)//2
            WinMove, x, y
            ifWinExist, ahk_class TaskSwitcherOverlayWnd
                WinMove, x, y
        }
    }
    KeyWait, XButton1
    Send {Blind}{Alt Up}
*XButton1 Up::
    return

; Allow WheelLeft/Right keybindings.
#IfWinActive ahk_class Valve001 ; HALF-LIFE 2
*WheelLeft::Send, {Blind}-
*WheelRight::Send, {Blind}=
#IfWinActive World of Warcraft ahk_class GxWindowClassD3d
*WheelLeft::Send, {Blind}[
*WheelRight::Send, {Blind}]

#IfWinActive
; Use AutoHotkey_L's #if feature for more effective blacklisting.
; #if m_WaitForRelease || !G_Blacklisted()

#Include *i ..\EasyWindowDrag.ahk

XButton2&WheelUp:
    if WinActive("ahk_class SciTEWindow")
        Send ^{PgUp}
    else if WinActive("ahk_class ShImgVw:CPreviewWnd")
        Send {Left}
    else
        Send ^+{tab}
return

XButton2&WheelDown:
    if WinActive("ahk_class SciTEWindow")
        Send ^{PgDn}
    else if WinActive("ahk_class ShImgVw:CPreviewWnd")
        Send {Right}
    else
        Send ^{tab}
return

XButton2&LButton:
    if WinActive("XP - Microsoft Virtual PC 2007")
        Send {Alt Down} n{Alt Up}
    else
        G_MinimizeActiveWindow()
return

XButton2&RButton:
    if WinActive("ahk_group WinCloseGroup")
        WinClose
    else
        Send {Alt Down}{F4}{Alt Up}
return

; Implement XButton2 as a prefix key while also allowing the
; duration of the press to decide its final (default) effect.
XButton2::
    if m_WaitForRelease ; Holding gesture button.
    {
        m_ScrolledWheel := true
        m_ExitLoop := true
        KeyWait, XButton2
        Send {Media_Prev}
        return
    }
    Hotkey, WheelUp,   XButton2&WheelUp,   On
    Hotkey, WheelDown, XButton2&WheelDown, On
    Hotkey, LButton,   XButton2&LButton,   On
    Hotkey, RButton,   XButton2&RButton,   On
    
    XButton2_tick := A_TickCount

    KeyWait, XButton2
    
    if (A_ThisHotkey = "XButton2") {
        short_press := (A_TickCount - XButton2_tick) < 200
        if short_press
            Send ^{Tab}
        else
            Send ^+{Tab}
    } ; else: some other hotkey has fired
        
    Hotkey, WheelUp,   Off
    Hotkey, WheelDown, Off
    Hotkey, LButton,   Off
    Hotkey, RButton,   Off
    
    ; Reapply gesture keys in case they overlap with the above.
    Hotkey, %m_GestureKey%, GestureKey_Down, On
    if m_GestureKey2
        Hotkey, %m_GestureKey2%, GestureKey_Down, On
return


G_Blacklisted()
{
    MouseGetPos,,, MouseWinId
    return WinExist("ahk_group Blacklist ahk_id " MouseWinId)
}
