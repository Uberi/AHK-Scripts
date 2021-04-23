;
; AutoHotkey Version: 1.0.47 (MINIMUM), tested on 1.0.47.4
; Language:       English
; Platform:       Windows 98 and later? (REQUIRED), tested on Windows Vista (IE7).
; Author:         Lexikos
;
; Momentum-related code and ideas were developed for a different script by various users at:
;   http://www.autohotkey.com/forum/viewtopic.php?t=19773
;
; Script Function:
;	Apply momentum to scroll bars.
;
; Idea by FireGirl:
;   http://www.autohotkey.com/forum/viewtopic.php?t=21790

#NoEnv
CoordMode, Mouse, Screen

;
; CONFIGURATION
;

UPDATE_RATE = 10 ; milliseconds
SENSITIVITY = 0.5
INERTIA = 0.95

;
; WIN32 DEFINES
;
; SetWinEventHook Flags
WINEVENT_OUTOFCONTEXT       = 0x0000
; Events
EVENT_SYSTEM_SCROLLINGSTART = 0x0012
EVENT_SYSTEM_SCROLLINGEND   = 0x0013
; Scrollbar Constants
SB_HORZ = 0
SB_VERT = 1

;
; INITIALIZATION
;

SpeedA := 1 - SENSITIVITY

; Register callback proc.
cbOnScrollEvent := RegisterCallback("OnScrollEvent")
; Set scrolling start/end hook to call OnScrollEvent().
hScrollHook := DllCall("SetWinEventHook"
    , "uint", EVENT_SYSTEM_SCROLLINGSTART   ; eventMin
    , "uint", EVENT_SYSTEM_SCROLLINGEND     ; eventMax
    , "uint", 0                             ; hmodWinEventProc (only for in-context hooks)
    , "uint", cbOnScrollEvent               ; lpfnWinEventProc
    , "uint", 0                             ; idProcess (0 = all processes)
    , "uint", 0                             ; idThread (0 = all threads)
    , "uint", WINEVENT_OUTOFCONTEXT)        ; dwflags

if (!hScrollHook)
    MsgBox, 48, Error, SetWinEventHook failed. Standard Windows scrollbars will not have momentum applied.

; IE support init.
WM_HTML_GETOBJECT := DllCall("RegisterWindowMessage", "str", "WM_HTML_GETOBJECT")
COM_CoInitialize()

OnExit, CleanupAndExit

return


CleanupAndExit:
    ; May not be necessary; but for good measure...
    if hScrollHook
        DllCall("UnhookWinEvent", "uint", hScrollHook)
ExitApp


ContinueScroll:
    start_tick := A_TickCount

    Scroll_Speed *= INERTIA
    
    ; Continue until
    ;   the scroll bar slows to a stop,
    ;   the window is closed,
    ;   or something else moves the scroll bar.

    if (Abs(Scroll_Speed)>0.01
        && GetAbstractScrollInfo(Scroll_Container, Scroll_Type, Scroll_Pos_Int)
        && Scroll_Pos_Int = Last_Pos)
    {
        ; Apply momentum.
        Scroll_Pos += Scroll_Speed
        ; Check if it hit the end.
        hit_the_end := false
        if (Scroll_Pos <  Scroll_Min)
            Scroll_Pos := Scroll_Min, hit_the_end := true
        if (Scroll_Pos >  Scroll_Max)
            Scroll_Pos := Scroll_Max, hit_the_end := true
        ; If it has come to a stop, stop the timer.
        if (Scroll_Pos = Last_Pos) {
            SetTimer, ContinueScroll, Off
            return
        }
        ; Move scroll bar.
        if SetAbstractScrollPos(Scroll_Container, Scroll_Type, Round(Scroll_Pos)) && !hit_the_end
        {   ; Update position (to detect if something else moves the bar.)
            GetAbstractScrollInfo(Scroll_Container, Scroll_Type, Last_Pos)
            return
        }
    }
    SetTimer, ContinueScroll, Off
    gosub ReleaseScrollContainerIfNecessary
return

TrackScrollBar:
    ; Update scroll position.
    if GetAbstractScrollInfo(Scroll_Container, Scroll_Type, Scroll_Pos)
    {   ; Recalculate velocity.
        Scroll_Speed := Scroll_Speed*SpeedA + (Scroll_Pos-Last_Pos)*SENSITIVITY
        Last_Pos := Scroll_Pos
    }
    else
    {   ; Error: maybe the window closed?
        SetTimer, TrackScrollBar, Off
        gosub ReleaseScrollContainerIfNecessary
    }
return

ReleaseScrollContainerIfNecessary:
    if Scroll_Type in scrollbarHThumb,scrollbarVThumb
        COM_Release(Scroll_Container), Scroll_Container:=0
return

~LButton::
    gosub GetIEDocumentAtMouse
    if !pDoc
        return
    pWin := COM_Invoke(pDoc, "parentWindow"), COM_Release(pDoc), pDoc := 0
    if !pWin
        return

    ; Currently only one scroll bar can be moving at a time.
    SetTimer, ContinueScroll, Off

    MouseGetPos, x, y

    if (GetDeepestScrollElement(pWin, x, y, Scroll_Container, pElementWin))
    {   ; Hit-test for scrollbarHThumb or scrollbarVThumb.
        cx:=COM_Invoke(pElementWin,"screenLeft"), cy:=COM_Invoke(pElementWin,"screenTop"), pWin!=pElementWin ? (cx-=2, cy-=2) : ""
        Scroll_Type := COM_Invoke(Scroll_Container,"componentFromPoint",x-cx,y-cy)
        if Scroll_Type not in scrollbarHThumb,scrollbarVThumb
            Scroll_Container:=0, Scroll_Type:=""
        pElementWin!=pWin ? COM_Release(pElementWin) . pElementWin:=0 : ""
    }
    COM_Release(pWin), pWin:=0
    
    if !Scroll_Container
        return

    GetAbstractScrollInfo(Scroll_Container, Scroll_Type, Scroll_Pos, Scroll_Min, Scroll_Max)
    Last_Pos := Scroll_Pos
    Scroll_Speed := 0

    ; Set the tracking timer.
    SetTimer, TrackScrollBar, %UPDATE_RATE%

    KeyWait, LButton
    
    ; Scrolling has stopped, so stop tracking the scroll position.
    SetTimer, TrackScrollBar, Off
    
    if Scroll_Container
    {   ; Apply momentum.
        SetTimer, ContinueScroll, %UPDATE_RATE%
        ; Update Last_Pos in case it has changed since the last TrackScrollBar iteration.
        GetAbstractScrollInfo(Scroll_Container, Scroll_Type, Last_Pos)
    }
return


;
; CALLBACK - Standard Windows Scrollbars
;
OnScrollEvent(hWinEventHook, event, hwnd, idObject, idChild, dwEventThread, dwmsEventTime)
{
    global
    local trackpos
    
    static OBJID_VSCROLL = 0xFFFFFFFB, OBJID_HSCROLL = 0xFFFFFFFA
    
    if (event = EVENT_SYSTEM_SCROLLINGSTART)
    {
        Scroll_Container := hwnd
        Scroll_Type := (idObject=OBJID_HSCROLL) ? SB_HORZ : SB_VERT
        
        ; Get this scroll bar's parameters.
        GetScrollInfo(Scroll_Container, Scroll_Type, Scroll_Pos, trackpos, Scroll_Min, Scroll_Max, Scroll_Page)
        Last_Pos := Scroll_Pos
        
        ; Set the tracking timer.
        SetTimer, TrackScrollBar, %UPDATE_RATE%
        ; Currently only one scroll bar can be moving at a time.
        SetTimer, ContinueScroll, Off
    }
    else if (event = EVENT_SYSTEM_SCROLLINGEND)
    {
        ; Scrolling has stopped, so stop tracking the scroll position.
        SetTimer, TrackScrollBar, Off
        ; Apply momentum.
        SetTimer, ContinueScroll, %UPDATE_RATE%
        ; Update Last_Pos in case it has changed since the last TrackScrollBar iteration.
        GetScrollInfo(Scroll_Container, Scroll_Type, Last_Pos)
    }
}


;
; FUNCTIONS - Standard Windows Scrollbars
;
GetScrollInfo(hwnd, fnBar, ByRef nPos=0, ByRef nTrackPos=0, ByRef nMin=0, ByRef nMax=0, ByRef nPage=0)
{
    VarSetCapacity(si, 28, 0) ; SCROLLINFO si
    NumPut(28  , si, 0) ; si.cbSize := sizeof(SCROLLINFO)
    NumPut(0x17, si, 4) ; si.fMask := SIF_ALL
    
    if ! DllCall("GetScrollInfo", "uint", hwnd, "int", fnBar, "uint", &si)
        return false
    
    nPos        := NumGet(si, 20)
    nTrackPos   := NumGet(si, 24)
    nMin        := NumGet(si,  8)
    nMax        := NumGet(si, 12)
    nPage       := NumGet(si, 16)
    return true
}

SetScrollPos(hwnd, fnBar, nPos)
{
    VarSetCapacity(si, 28, 0) ; SCROLLINFO si
    NumPut(28  , si,  0)    ; si.cbSize := sizeof(SCROLLINFO)
    NumPut(0x4 , si,  4)    ; si.fMask := SIF_POS
    NumPut(nPos, si, 20)    ; si.nPos := nPos
 
    ; Use SetScrollInfo first because it supports 32-bit positions.
    ; If an application supports positions < 0 or > 65535, it most likely
    ; ignores WM_#SCROLL's wParam and uses GetScrollPos or GetScrollInfo
    ; to get the actual scroll position.
    DllCall("SetScrollInfo", "uint", hwnd, "int", fnBar, "uint", &si, "int", 0)
    
    ; WM_HSCROLL or WM_VSCROLL must be sent for the window to update it's contents.
    msg := (fnBar=0) ? 0x114 : 0x115
    wParam := 4 ; SB_THUMBPOSITION
        | ((nPos&0xFFFF)<<16)
    SendMessage, msg, wParam,,, ahk_id %hwnd%
    
    return (ErrorLevel != "FAIL")
}


;
; ABSTRACT FUNCTIONS - for both standard Windows scrollbar and IE scrollbar support.
;
GetAbstractScrollInfo(Container, Type, ByRef Pos=0, ByRef Min=0, ByRef Max=0)
{
    if !Container
        return false
    if Type in 0,1 ; SB_HORZ,SB_VERT
        return GetScrollInfo(Container, Type, Pos, track_pos, Min, Max)
    if Type = scrollbarHThumb
        Pos:=COM_Invoke(Container,"scrollLeft"),  Max:=COM_Invoke(Container,"scrollWidth"),  Min:=0
    else if Type = scrollbarVThumb
        Pos:=COM_Invoke(Container,"scrollTop"),  Max:=COM_Invoke(Container,"scrollHeight"),  Min:=0
    return Pos!=""
}
SetAbstractScrollPos(Container, Type, Pos)
{
    if !Container
        return false
    if Type in 0,1 ; SB_HORZ,SB_VERT
        return SetScrollPos(Container, Type, Pos)
    ; TODO: determine success or failure for assignment.
    if Type = scrollbarHThumb
        return true, COM_Invoke(Container,"scrollLeft=",Pos)
    else if Type = scrollbarVThumb
        return true, COM_Invoke(Container,"scrollTop=",Pos)
    return false
}


;
; IE FUNCTIONS & SUBROUTINES
;
GetDeepestScrollElement(pWin, x, y, ByRef pElement, ByRef pElementWin)
{
    win := pWin
    Loop {
        if (!win)
            break ; Error
        if !(doc:=COM_Invoke(win,"document"))
            break ; Error
        if !(element:=COM_Invoke(doc,"elementFromPoint",x-COM_Invoke(win,"screenLeft"),y-COM_Invoke(win,"screenTop")))
            break ; Error
        if (tag:=COM_Invoke(element,"tagName")) != "FRAME"
        {   ; return element.isScrollable ? element : frame.body
            scrollHeight:=COM_Invoke(element,"scrollHeight"), clientHeight:=COM_Invoke(element,"clientHeight")
            if !(clientHeight && clientHeight < scrollHeight)
                COM_Release(element), element:=COM_Invoke(doc,"body")
            break
        }
        COM_Release(doc), doc:=0,  win!=pWin ? COM_Release(win) . win:=0 : ""
        if !(win:=COM_Invoke(element,"contentWindow"))
        {
            COM_Release(element), element:=0
            break ; Error
        }
    }
    doc ? COM_Release(doc) . doc:=0 : ""
    if (!element && pWin!=win)
        COM_Release(win), win:=0
    
    pElement := element
    pElementWin := win
    return pElement
}

GetIEDocumentAtMouse:
    MouseGetPos,,,, hIESvr, 2
    WinGetClass, class, ahk_id %hIESvr%
    if (!hIESvr or class != "Internet Explorer_Server")
    {   ; Try again with alternate method (for "Microsoft Document Explorer" support.)
        MouseGetPos,,,, hIESvr, 3
        WinGetClass, class, ahk_id %hIESvr%
        if (!hIESvr or class != "Internet Explorer_Server")
            return
    }
    
    SendMessage, WM_HTML_GETOBJECT,,,, ahk_id %hIESvr%
    lResult := ErrorLevel
    DllCall("oleacc\ObjectFromLresult", "uint", lResult
        , "uint", COM_GUID4String(IID_IHTMLDocument2,"{332C4425-26CB-11D0-B483-00C04FD90119}")
        , "int", 0, "uint*", pDoc)
return
