; Version 2011.10.29

;==== Summary ==================================================================

; This script is intended for use with a wheel in free-spinning mode, on mice
; that have that feature. The acceleration profile is linear, since the accuracy
; of acceleration is really noticeable on a free-spinning wheel. It also has an
; algorithm that attempts to prevent "phantom scrolls". Without this algorithm,
; I find the free-spinning mode to be unusable; adding this algorithm made all
; the difference, fixing most of the negative aspects of free-spinning mode. Now
; I really like the feel, and it resembles the inertial scrolling on an iPhone.
;
; Though I have not tested my script on another mouse, it would probably work
; well if you spend a little time changing the constants under the heading
; "WheelUp/Down Initialize". If you find some numbers that work well, please
; post them in the thread for this script in the forum at AutoHotKey.com. I
; would be curious to know if the algorithms in my script are beneficial for a
; standard mouse. I would be happy to help if you need assistance.

;==== Script Initialize ========================================================

#SingleInstance force                                                               ; replace the previous instance, in case the script reload as Admin occurs before previous instance quits
#MaxThreads 2                                                                       ; need two "threads", one to accumulate buffered events and one to send scroll messages
#MaxThreadsPerHotkey 2
#MaxHotkeysPerInterval 2000                                                         ; the hyper wheel on a Logitech mouse generates events very quickly when in free spinning mode

If Not A_IsAdmin                                                                    ; need Admin privilege to scroll programs run as Admin
{
    DllCall("shell32\ShellExecuteA", uint, 0, str, "RunAs", str, A_AhkPath, str, """" . A_ScriptFullPath . """", str, A_WorkingDir, int, 0)
    ExitApp
}

Process Priority, , H                                                               ; run in high speed
SetBatchLines -1                                                                    ; do not interrupt a "thread" after processing a number of script lines
CoordMode Mouse, Screen                                                             ; use screen coordinates

;==== WheelUp/Down Initialize ==================================================

ScrollLines := 1                                                                    ; scroll 1 line at once, though 3 is system default
DllCall("SystemParametersInfo", UInt, 0x69, UInt, ScrollLines, UInt, 0, UInt, 0)    ; 0x69 is SPI_SETWHEELSCROLLLINES
WheelUnits := 120                                                                   ; most mice report 120 units per detent (WheelUp/Down "click")
WheelDelta := WheelUnits << 16                                                      ; shift value 2 bytes to the left, as the scrollwheel message expects step size in the most significant 2 bytes

DllCall("QueryPerformanceFrequency",  "Int64 *", Freq)                              ; retrieve the frequency of the high-resolution performance counter
TickPerMs := Freq / 1000                                                            ; ticks per millisecond

; These numbers are designed for a wheel in free-spinning mode
ThresholdCtrl := 200 * TickPerMs                                                    ; threshold to block Ctrl + WheelUp/Down until wheel stops scrolling
ThresholdIgnore := 0 * TickPerMs                                                    ; threshold to ignore an accidental single step scroll (set 0 to disable this feature)
ThresholdSingle := 400 * TickPerMs                                                  ; threshold to determine whether it is an intended continuous scrolling
ThresholdAccelMin := 140 * TickPerMs                                                ; threshold to begin accelerating the wheel scrolling speed
ThresholdAccelMax := 20 * TickPerMs                                                 ; threshold of maximum acceleration of the wheel scrolling speed
BoostPeak := 6                                                                      ; limit on peak boost

; *** Contributed by Dx: these numbers should work better with a regular click
; stop wheel...
;ThresholdCtrl := 200 * TickPerMs                                                    ; threshold to block Ctrl + WheelUp/Down until wheel stops scrolling
;ThresholdIgnore := 0 * TickPerMs                                                    ; threshold to ignore an accidental single step scroll (set 0 to disable this feature)
;ThresholdSingle := 300 * TickPerMs                                                  ; threshold to determine whether it is an intended continuous scrolling
;ThresholdAccelMin := 40 * TickPerMs                                                 ; threshold to begin accelerating the wheel scrolling speed
;ThresholdAccelMax := 20 * TickPerMs                                                 ; threshold of maximum acceleration of the wheel scrolling speed
;BoostPeak := 10                                                                     ; limit on peak boost

BoostMult := BoostPeak / (ThresholdAccelMin - ThresholdAccelMax)                    ; multiplier for linear acceleration profile, in x / tick (1 / 10 is 1x boost per 10 tick below ThresholdAccelMin)

WheelSteps := 0                                                                     ; wheel steps, used when wheel steps have been buffered or accelerated
Available := true                                                                   ; lock to allow buffering while only one "thread" sends scroll messages
MsgType := 0x0                                                                      ; bitmask describing the type of scroll message to send

MoveAllowSq := 3 ** 2                                                               ; number of pixels, squared, of allowed mouse movement where the hovered control can change without stopping scroll; this is necessary because some lists return the name of a control within the list, which changes while scrolling, and otherwise would stop the scrolling
PriorTick := 0                                                                      ; previous value of the high-resolution performance counter (tick since boot)
PriorX := 0                                                                         ; previously hovered x screen coordinate
PriorY := 0                                                                         ; previously hovered y screen coordinate
PriorWin := 0                                                                       ; previously hovered window
PriorCtl := ""                                                                      ; previously hovered control

MoveSuppress := 400 / Freq                                                          ; number of pixels per second of mouse movement during which a single step scroll should be suppressed
CheckTick := 0                                                                      ; last checked value of the high-resolution performance counter (tick since boot)
CheckX := 0                                                                         ; last checked x screen coordinate
CheckY := 0                                                                         ; last checked y screen coordinate

SetTimer CheckMove, 125                                                             ; start timer to check mouse movement, interval in milliseconds
Return

;==== Mouse Movement Check Timer ===============================================

CheckMove:
    Critical
    DllCall("QueryPerformanceCounter", "Int64 *", CheckTick)                        ; retrieves the current value of the high-resolution performance counter (tick since boot)
    MouseGetPos CheckX, CheckY                                                      ; get the coordinates of the mouse cursor
    ; uncomment the following 4 lines to display a tooltip showing the speed of mouse movement
    ;Tooltip % Round(Sqrt((CheckX - PriorCheckX) ** 2 + (CheckY - PriorCheckY) ** 2) * Freq / (CheckTick - PriorCheckTick)), 300, 300 ;% ; (the commented second '%' is only there to fix syntax highlighting in Notepad++)
    ;PriorCheckTick := CheckTick
    ;PriorCheckX := CheckX
    ;PriorCheckY := CheckY
    Critical Off
    Return

;==== WheelUp/Down Handler =====================================================

WheelUp::
WheelDown::
    Critical

    DllCall("QueryPerformanceCounter", "Int64 *", Tick)                             ; retrieves the current value of the high-resolution performance counter (tick since boot)
    Dur := (Tick - PriorTick) / A_EventInfo                                         ; time since last WheelUp/Down (most mice combine multiple WheelUp/Down within 8ms into one event)
    If (ThresholdIgnore > 0 && Dur > ThresholdIgnore && A_EventInfo == 1)           ; this is an accidental single step scroll
    { }
    Else If (Dur > ThresholdSingle || A_ThisHotkey != A_PriorHotkey)                ; this is a single step, as opposed to continuous scrolling
        WheelSteps := A_EventInfo                                                   ; clear leftover buffered message
    Else If (Dur <= ThresholdAccelMax)                                              ; fastest continuous wheel scrolling
        WheelSteps += (BoostPeak + 1) * A_EventInfo                                 ; add peak acceleration boost to wheel steps
    Else If (Dur < ThresholdAccelMin)                                               ; fast continuous wheel scrolling
        WheelSteps += ((ThresholdAccelMin - Dur) * BoostMult + 1) * A_EventInfo     ; add linear acceleration boost to wheel steps
    Else
        WheelSteps += A_EventInfo                                                   ; add wheel steps
    PriorTick := Tick

    If (Available)                                                                  ; only enter the send message section if it's not already running in the other "thread"
    {
        Available := false                                                          ; lock this send message section to run one single instance

        Loop                                                                        ; loop to continue sending messages as they are accumulated in the other "thread", and also to handle the program that does not handle larger scrolls
        {
            Critical Off
            Sleep -1                                                                ; interrupt this "thread" here to accumulate wheel steps for any buffered WheelUp/Down events
            Critical

            Step := Round(WheelSteps)                                               ; round to nearest whole wheel step
            If (Step < 1)                                                           ; wheel steps have reached zero or close to zero
                Break                                                               ; exit the loop

            MouseGetPos X, Y, Win, Ctl, 1                                           ; get the coordinates, window, and control under the mouse cursor
            If Ctl contains SysTabControl32                                         ; control is not scrollable (HTML Help Control 6.1)
                MouseGetPos,,,, Ctl                                                 ; use alternate method to get control under the mouse cursor
            Else If Ctl in TUiEditorWindow.UnicodeClass3                            ; control is not scrollable (Beyond Compare 3.2.3 - right pane)
                Ctl := "TUiEditorWindow.UnicodeClass4"                              ; redirect scrollbar message to a control that is scrollable (left pane)
            If (Dur > ThresholdSingle || PriorWin != Win || PriorCtl != Ctl)        ; mouse was moved over a different window or control
            {
                If (Dur > ThresholdCtrl && WheelSteps < 2 && (CheckX - X) ** 2 + (CheckY - Y) ** 2 > (MoveSuppress * (Tick - CheckTick)) ** 2) ; wheel did a single step scroll, but mouse moved quickly just prior, so suppress the scroll
                {
                    ;Tooltip % Round(Dur / TickPerMs) . " > " . Round(ThresholdCtrl / TickPerMs) . "`n" . WheelSteps . " < 2`n" . Round(Sqrt((CheckX - X) ** 2 + (CheckY - Y) ** 2) * Freq / (Tick - CheckTick)) . " > " . Round(MoveSuppress * Freq) ;%
                    WheelSteps := 0                                                 ; clear buffered message
                    CheckTick := Tick
                    CheckX := X
                    CheckY := Y
                    Break                                                           ; exit the loop
                }
                Else If (Dur <= ThresholdSingle && (PriorX - X) ** 2 + (PriorY - Y) ** 2 <= MoveAllowSq) ; wheel is doing a continuous scroll, and mouse is not moving, so continue sending the scroll to the same control
                {
                    Win := PriorWin
                    Ctl := PriorCtl
                }
                Else If (Dur <= ThresholdCtrl && A_ThisHotkey == A_PriorHotkey)     ; the wheel is still doing a scroll from before mouse was moved over a different window or control
                {
                    WheelSteps := 0                                                 ; clear buffered message
                    Break                                                           ; exit the loop
                }
                Else
                {
                    WinGetTitle Title, ahk_id %Win%                                 ; get the title of the window under the mouse cursor
                    MsgType := 0x0                                                  ; use send message to post scrollwheel message
                    ;If Title contains Microsoft Visual Studio                       ; program doesn't always expose the correct control name (Visual Studio 2010 10.0.30319.1)
                    ;{
                    ;    If Ctl contains HwndWrapper[DefaultDomain;;                 ; when control name starts with this, it won't accept a scroll message unless it's activated, so activate the one under the mouse cursor
                    ;        MouseClick Middle                                       ; activate the hovered control
                    ;    Else If (Ctl == "")                                         ; when control name is blank, we need to activate a control, so activate the one under the mouse cursor
                    ;        MouseClick Middle                                       ; activate the hovered control
                    ;}
                    ;Else If ...
                    If Title contains Process Explorer - Sysinternals               ; program only does 3 line scrolls regardless of setting (Process Explorer 12.03)
                        MsgType := 0x4                                              ; bit 3 means program scrolls 3 lines regardless of setting
                    Else If Title contains TortoiseMerge                            ; program only does 3 line scrolls regardless of setting (TortoiseMerge 1.6.8)
                        MsgType := 0x4                                              ; bit 3 means program scrolls 3 lines regardless of setting
                    Else If Title contains Remote Desktop Connection                ; program only does 3 line scrolls regardless of setting (Remote Desktop 6.1.7600)
                        MsgType := 0xC                                              ; bit 3 means program scrolls 3 lines regardless of setting; bit 4 means disallow scrollbar messages (only use scrollwheel messages)
                    Else If Ctl in VimTextArea1,TSideBySideFolders1,TXListBox1,TXListBox2,hh_kwd_vlist1 ; program does not handle larger scrolls (Vim 7.3, Beyond Compare 2.5.3, HTML Help Control 6.1)
                        MsgType := 0x2                                              ; bit 2 means repeat message for each wheel step instead of sending a single message with size of step
                    ; *** Contributed by Dx: additional compatibility for SolidWorks and FAR...
                    Else If Ctl in Afx:0000000140000000:b:0000000000010005:0000000000000000:00000000000000002
                        MsgType := 0x1                                              ; SolidWorks 2011 CommandManager FIX
                    Else If Ctl in VirtualConsoleClass1                             ; ConEmu for FAR
                        MsgType := 0x2
                    Else If Title in PictureView                                    ; PictureView Plugin for FAR
                        MsgType := 0x1
                    PriorX := X
                    PriorY := Y
                    PriorWin := Win
                    PriorCtl := Ctl
                }
            }

            If (MsgType & 0x4)                                                      ; bit 3 means program scrolls 3 lines regardless of setting
            {
                Step := Round(Step * ScrollLines / 3)                               ; multiply steps by ScrollLines/3 (probably 1/3) so scroll is similar to programs without this limitation
                If (Step < 1 && MsgType & 0x8)                                      ; bit 4 means disallow scrollbar messages (only use scrollwheel messages)
                    Step := 1
            }
            If (MsgType & 0x2)                                                      ; bit 2 means repeat message for each wheel step instead of sending a single message with size of step
                Step := 1                                                           ; setting step to 1 means it will loop again for each wheel step
            ; *** Contributed by Dx: fix for bit 1, shouldn't check active window...
            If (MsgType & 0x1) ;&& Win == WinExist("A"))                            ; bit 1 means use compatible way of sending scrollwheel message
                MouseClick %A_ThisHotkey%, , , %Step%                               ; send scrollwheel message in compatible way
            Else If (WheelSteps >= 45 && Step < 4 && !(MsgType & 0x8))              ; scrolling is happening slowly (almost a page full of scroll steps is buffered), and we're sending a single step per message so it won't catch up; bit 4 means disallow scrollbar messages (only use scrollwheel messages)
            {
                Step := 54                                                          ; average size of a page is around this many lines
                SendMessage 0x115, (A_ThisHotkey == "WheelUp" ? 2 : 3), , %Ctl%, ahk_id %Win% ; post scrollbar message to window under cursor, and wait for response; 0x115 is WM_VSCROLL, 2 is SB_PAGEUP, 3 is SB_PAGEDOWN
            }
            Else If (Step < 1 && MsgType & 0x4 && !(MsgType & 0x8))                 ; bit 3 means program scrolls 3 lines regardless of setting; bit 4 means disallow scrollbar messages (only use scrollwheel messages)
            {
                Step := ScrollLines / 3                                             ; the scrollbar message only scrolls a single line, which is ScrollLines/3 (probably 1/3)
                SendMessage 0x115, (A_ThisHotkey == "WheelUp" ? 0 : 1), , %Ctl%, ahk_id %Win% ; post scrollbar message to window under cursor, and wait for response; 0x115 is WM_VSCROLL, 0 is SB_LINEUP, 1 is SB_LINEDOWN
            }
            Else                                                                    ; use send message to post scrollwheel message
                SendMessage 0x20A, (A_ThisHotkey == "WheelUp" ? 1 : -1) * Step * WheelDelta, Y << 16 | (X & 0xFFFF), %Ctl%, ahk_id %Win% ; post scrollwheel message to window under cursor, and wait for response; 0x20A is WM_MOUSEWHEEL

            If (MsgType & 0x4)                                                      ; bit 3 means program scrolls 3 lines regardless of setting
            {
                WheelSteps -= Step * 3 / ScrollLines                                ; multiply steps by 3/ScrollLines (probably 3/1) so we subtract actual distance scrolled
                if (WheelSteps < -0.5)                                              ; don't let buffered wheel steps get too far negative, so scrolling with bit 3 set doesn't get blocky
                    WheelSteps := -0.5
            }
            Else
                WheelSteps -= Step                                                  ; subtract whole wheel steps, leaving the remainder buffered for the next post
            ; uncomment the following line to display a tooltip showing a bar graph of wheel acceleration
            ;Tooltip % Step . SubStr("  ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||", 1 + (Step >= 10) + (Step >= 100), Step + (Step < 10) + (Step < 100)) ;% ; (the commented second '%' is only there to fix syntax highlighting in Notepad++)
        }

        Available := true                                                           ; unlock this send message section
    }

    Critical Off
    Return

;==== Ctrl + WheelUp/Down Handler ==============================================

*WheelUp::                                                                          ; * means any modifier key
*WheelDown::
    Critical
    DllCall("QueryPerformanceCounter", "Int64 *", Tick)                             ; retrieves the current value of the high-resolution performance counter (tick since boot)
    Dur := (Tick - PriorTick) / A_EventInfo                                         ; time since last WheelUp/Down (most mice combine multiple WheelUp/Down within 8ms into one event)
    If (Dur <= ThresholdCtrl)                                                       ; the wheel is still doing a scroll from before Ctrl was pressed
        PriorTick := Tick                                                           ; continue to block Ctrl + WheelUp/Down until wheel stops scrolling
    Else If (Dur > ThresholdSingle)                                                 ; skip the first turn in this direction
        MouseClick % SubStr(A_ThisHotKey, 2) ;%                                     ; send only a single Ctrl + WheelUp/Down, no acceleration (the commented second '%' is only there to fix syntax highlighting in Notepad++)
    WheelSteps := 0                                                                 ; clear leftover buffered message, so acceleration is not boosted by this
    Critical Off
    Return
