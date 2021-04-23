;wip: deal with keyboard accelerators

class Button extends Themify.Control
{
    __New(hControl)
    {
        base.__New(hControl)

        ;enable owner drawing on control
        WinSet, Style, +0xB, ahk_id %hControl% ;BS_OWNERDRAW
    }

    __Delete()
    {
        base.__Delete()

        ;disable owner drawing on control
        WinSet, Style, -0xB, ahk_id %hControl% ;BS_OWNERDRAW
    }

    ControlMessage(hWindow,Message,wParam,lParam)
    {
        ;ensure double clicks are interpreted as two clicks
        If Message = 0x203 ;WM_LBUTTONDBLCLK
        {
            PostMessage, 0x201, wParam, lParam,, ahk_id %hWindow% ;WM_LBUTTONDOWN
            Return, 1
        }
    }

    WindowMessage(hWindow,Message,wParam,lParam)
    {
        If Message = 0x2B ;WM_DRAWITEM
        {
            ;read DRAWITEMSTRUCT structure
            State := NumGet(lParam + 16,0,"UInt")
            hControl := NumGet(lParam + 20)
            If this.hControl != hControl
                Return
            hDC := NumGet(lParam + 20 + A_PtrSize)
            X1 := NumGet(lParam + 20 + (A_PtrSize << 1),0,"UInt")
            Y1 := NumGet(lParam + 24 + (A_PtrSize << 1),0,"UInt")
            X2 := NumGet(lParam + 28 + (A_PtrSize << 1),0,"UInt")
            Y2 := NumGet(lParam + 32 + (A_PtrSize << 1),0,"UInt")
            Status := {Default: !!(State & 0x20) ;ODS_DEFAULT
                      ,Disabled: !!(State & 0x4) ;ODS_DISABLED
                      ,Focused: !!(State & 0x10) ;ODS_FOCUS
                      ,Hotlit: !!(State & 0x40) ;ODS_HOTLIGHT
                      ,Inactive: !!(State & 0x80) ;ODS_INACTIVE
                      ,Selected: !!(State & 0x1)} ;ODS_SELECTED
            this.Draw(hDC,X1,Y1,X2,Y2,Status)
            Return, 1
        }
    }

    Draw(hDC,X1,Y1,X2,Y2,Status)
    {
        static hBrushDisabled := DllCall("CreateSolidBrush","UInt",0x65656A,"UPtr")
        static hBrushNormal := DllCall("CreateSolidBrush","UInt",0xD0D0DF,"UPtr")
        static hBrushFocus := DllCall("CreateSolidBrush","UInt",0xF8F8FF,"UPtr")
        static hBrushSelected := DllCall("CreateSolidBrush","UInt",0xB0B0C0,"UPtr")
        If Status.Disabled
            hBrush := hBrushDisabled
        Else If Status.Selected
            hBrush := hBrushSelected
        Else If Status.Focused
            hBrush := hBrushFocus
        Else
            hBrush := hBrushNormal
        this.DrawBackground(hDC,X1,Y1,X2,Y2,Status,hBrush)
        this.DrawForeground(hDC,X1,Y1,X2,Y2,Status,0x222222)
    }

    DrawBackground(hDC,X1,Y1,X2,Y2,Status,hBrush)
    {
        hOriginalBrush := DllCall("SelectObject","UPtr",hDC,"UPtr",hBrush,"UPtr") ;select the brush
        DllCall("Rectangle","UPtr",hDC,"Int",X1 - 1,"Int",Y1 - 1,"Int",X2 + 2,"Int",Y2 + 2)
        DllCall("SelectObject","UPtr",hDC,"UPtr",hOriginalBrush,"UPtr") ;deselect the brush
    }

    DrawForeground(hDC,X1,Y1,X2,Y2,Status,Color)
    {
        DllCall("SetTextAlign","UPtr",hDC,"UInt",6) ;TA_CENTER | TA_TOP
        DllCall("SetTextColor","UPtr",hDC,"UInt",Color)
        DllCall("SetBkMode","UPtr",hDC,"Int",1) ;TRANSPARENT
        ControlGetText, Text,, % "ahk_id " . this.hControl
        VarSetCapacity(Dimensions,8)
        DllCall("GetTextExtentPoint32","UPtr",hDC,"Str",Text,"Int",StrLen(Text),"UPtr",&Dimensions)
        Height := NumGet(Dimensions,4,"UInt")
        DllCall("TextOut","UPtr",hDC,"Int",Round((X1 + X2) / 2),"Int",Round(((Y1 + Y2 - Height) / 2) - 1),"Str",Text,"Int",StrLen(Text))
    }
}