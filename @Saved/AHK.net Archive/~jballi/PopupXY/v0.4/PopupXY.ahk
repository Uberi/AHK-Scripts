;-----------------------------
;
; Function: PopupXY
;
; Description:
; 
;   This function calculates the center position for the child window relative
;   to the parent window.  If necessary, the calculated window positions are
;   adjusted so that the child window will fit within the primary monitor work
;   area.
;
;
; Parameters:
;
;   p_Parent - For the parent window, this parameter can contain the GUI
;       window number (integer from 1 to 99), the window handle (hWnd), or
;       _WinTitle_.  From the AHK documentation: WinTitle is the title or
;       partial title of the window (the matching behavior is determined by
;       SetTitleMatchMode). To use a window class, specify ahk_class
;       ExactClassName (shown by Window Spy). To use a process identifier (PID),
;       specify ahk_pid %VarContainingPID%. To use a window's unique ID number,
;       specify ahk_id %VarContainingID%.
;
;   p_Child - For the child (pop-up) window, this parameter can contain the GUI
;       window number (from 1 to 99), the window handle (hWnd), or the window
;       title.  See the p_Parent description for more information.
;
;   r_ChildX - The calculated horizontal (X) position for the child window is
;       returned in this variable. [Optional] If defined, the parameter must
;       contain a variable name.
;
;   r_ChildY - The calculated vertical (Y) position for the child window is
;       returned in this variable. [Optional] If defined, the parameter must
;       contain a variable name.
;
;
; Returns:
;
;   The calculated horizontal (X) and vertical (Y) coordinates for the child
;   window. The LOWORD contains the horizontal coordinate and the HIWORD
;   contains the vertical coordinate.  To extract the coordinates from the
;   return value, use the following logic:
;
;       (start code)
;       Coordinates:=PopUpXY(...
;       XPos:=Coordinates & 0xFFFF  ;-- LOWORD
;       YPos:=Coordinates >> 16     ;-- HIWORD
;       (end)
;
;   If defined, the r_ChildX and r_ChildY variables are updated to contain the
;   calculated X/Y values.  If the parent or child windows cannot be found, all
;   return values are set to 0.
;
;-------------------------------------------------------------------------------
PopupXY(p_Parent,p_Child,ByRef r_ChildX="",ByRef r_ChildY="")
    {
    ;[==============]
    ;[  Initialize  ]
    ;[==============]
    r_ChildX:=0
    r_ChildY:=0

    ;[===============]
    ;[  Environment  ]
    ;[===============]
    l_DetectHiddenWindows:=A_DetectHiddenWindows
    DetectHiddenWindows On
    SysGet l_MonitorWorkArea,MonitorWorkArea

    ;[=================]
    ;[  Parent window  ]
    ;[=================]
    ;-- If necessary, collect/format hWnd
    if p_Parent is Integer
        {
        if p_Parent Between 1 and 99
            {
            gui %p_Parent%:+LastFoundExist
            IfWinExist
                {
                gui %p_Parent%:+LastFound
                p_Parent:="ahk_id " . WinExist()
                }
            }
         else
            p_Parent:="ahk_id " . p_Parent
        }

    ;-- Collect position/size.  Bounce if nothing is found
    WinGetPos l_ParentX,l_ParentY,l_ParentW,l_ParentH,%p_Parent%
    if l_ParentX is Space
        return

    ;[================]
    ;[  Child window  ]
    ;[================]
    ;-- If necessary, collect/format hWnd
    if p_Child is Integer
        {
        if p_Child Between 1 and 99
            {
            gui %p_Child%:+LastFoundExist
            IfWinExist
                {
                gui %p_Child%:+LastFound
                p_Child:="ahk_id " . WinExist()
                }
            }
         else
            p_Child:="ahk_id " . p_Child
        }

    ;-- Collect position/size.  Bounce if nothing is found
    WinGetPos,,,l_ChildW,l_ChildH,%p_Child%
    if l_ChildW is Space
        return

    ;[=====================]
    ;[  Reset environment  ]
    ;[=====================]
    DetectHiddenWindows %l_DetectHiddenWindows%

    ;[=======================]
    ;[  Calculate child X/Y  ]
    ;[=======================]
    r_ChildX:=Round(l_ParentX+((l_ParentW-l_ChildW)/2))
    r_ChildY:=Round(l_ParentY+((l_ParentH-l_ChildH)/2))

    ;-- Adjust if necessary
    if (r_ChildX<l_MonitorWorkAreaLeft)
        r_ChildX:=l_MonitorWorkAreaLeft

    if (r_ChildY<l_MonitorWorkAreaTop)
        r_ChildY:=l_MonitorWorkAreaTop

    l_MaximumX:=l_MonitorWorkAreaRight-l_ChildW
    if (r_ChildX>l_MaximumX)
        r_ChildX:=l_MaximumX

    l_MaximumY:=l_MonitorWorkAreaBottom-l_ChildH
    if (r_ChildY>l_MaximumY)
        r_ChildY:=l_MaximumY

    ;[====================]
    ;[  Return to sender  ]
    ;[====================]
    Return (r_ChildY<<16)|r_ChildX
    }
