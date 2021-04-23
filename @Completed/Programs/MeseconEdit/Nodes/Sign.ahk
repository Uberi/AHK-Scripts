#NoEnv

class Sign extends Nodes.Basis
{
    static hBrush := DllCall("CreateSolidBrush","UInt",0x224488,"UPtr")

    __New(IndexX,IndexY)
    {
        global Grid
        this.State := 1
        this.Text := "Punch`nto modify"
        base.__New(IndexX,IndexY)
    }

    Punch()
    {
        global SignEditText, SignEditInstance
        SignEditInstance := this

        Gui, Main:+Disabled
        Gui, SignEdit:Font, s14 Bold, Arial
        Gui, SignEdit:Add, Edit, x10 y10 w150 h50 vSignEditText gSignEditModify Center -VScroll, % this.Text
        Gui, SignEdit:Show, w170 h70, Edit sign text
        Gui, SignEdit:+LastFound +OwnerMain +ToolWindow
        WinWaitClose
        Return

        SignEditModify:
        GuiControlGet, SignEditText, SignEdit:, SignEditText
        SignEditInstance.Text := SignEditText
        Return

        SignEditGuiEscape:
        SignEditGuiClose:
        Gui, Main:-Disabled
        Gui, SignEdit:Destroy
        Return
    }

    Draw(hDC,X,Y,W,H)
    {
        static hFont := 0, PreviousH := -1

        VarSetCapacity(Rectangle,16)

        ;draw rectangle
        NumPut(Round(X + (W * 0.1)),Rectangle,0,"Int")
        NumPut(Round(Y + (H * 0.2)),Rectangle,4,"Int")
        NumPut(Round(X + (W * 0.9)),Rectangle,8,"Int")
        NumPut(Round(Y + (H * 0.7)),Rectangle,12,"Int")
        DllCall("FillRect","UPtr",hDC,"UPtr",&Rectangle,"UPtr",this.base.hBrush)

        ;set up text properties
        If (H != PreviousH)
        {
            If hFont
                DllCall("DeleteObject","UPtr",hFont)
            hFont := DllCall("CreateFont"
                ,"Int",Round(H * 0.2) ;height
                ,"Int",0 ;width
                ,"Int",0 ;angle of string (0.1 degrees)
                ,"Int",0 ;angle of each character (0.1 degrees)
                ,"Int",100 ;font weight
                ,"UInt",False ;font italic
                ,"UInt",False ;font underline
                ,"UInt",False ;font strikeout
                ,"UInt",1 ;DEFAULT_CHARSET: character set
                ,"UInt",0 ;OUT_DEFAULT_PRECIS: output precision
                ,"UInt",0 ;CLIP_DEFAULT_PRECIS: clipping precision
                ,"UInt",4 ;ANTIALIASED_QUALITY: output quality
                ,"UInt",0 ;DEFAULT_PITCH | (FF_DONTCARE << 16): font pitch and family
                ,"Str","Arial" ;typeface name
                ,"UPtr")
        }
        DllCall("SetTextColor","UPtr",hDC,"UInt",0xFFFFFF)
        DllCall("SetBkMode","UPtr",hDC,"Int",1) ;TRANSPARENT
        DllCall("SetTextAlign","UPtr",hDC,"UInt",6) ;TA_CENTER | TA_TOP: align text to the center and the top

        ;draw text
        hOriginalFont := DllCall("SelectObject","UPtr",hDC,"UPtr",hFont,"UPtr")
        PositionX := X + (W * 0.5), PositionY := Y + (H * 0.25)
        Text := this.Text
        Loop, Parse, Text, `n
        {
            DllCall("TextOut","UPtr",hDC,"Int",Round(PositionX),"Int",Round(PositionY),"Str",A_LoopField,"Int",StrLen(A_LoopField))
            PositionY += H * 0.2
        }
        DllCall("SelectObject","UPtr",hDC,"UPtr",hOriginalFont,"UPtr")
    }

    Serialize()
    {
        Return, this.Text
    }

    Deserialize(IndexX,IndexY,Value)
    {
        Result := new this(IndexX,IndexY)
        StringReplace, Value, Value, ``n, `n, All
        Result.Text := Value
        Return, Result
    }
}