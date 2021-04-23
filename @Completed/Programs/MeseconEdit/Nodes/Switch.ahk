#NoEnv

class Switch extends Nodes.Power
{
    static hOffBrush := DllCall("CreateSolidBrush","UInt",0x008888,"UPtr")
    static hOnBrush := DllCall("CreateSolidBrush","UInt",0x00FFFF,"UPtr")
    static hBackgroundBrush := DllCall("CreateSolidBrush","UInt",0x888888,"UPtr")

    __New(IndexX,IndexY)
    {
        this.State := 0
        base.__New(IndexX,IndexY)
    }

    Punch()
    {
        this.ModifyState(this.State ? -1 : 1,[])
    }

    Draw(hDC,X,Y,W,H)
    {
        VarSetCapacity(Rectangle,16)

        ;draw main rectangle
        NumPut(Round(X + (W * 0.1)),Rectangle,0,"Int")
        NumPut(Round(Y + (H * 0.1)),Rectangle,4,"Int")
        NumPut(Round(X + (W * 0.9)),Rectangle,8,"Int")
        NumPut(Round(Y + (H * 0.9)),Rectangle,12,"Int")
        DllCall("FillRect","UPtr",hDC,"UPtr",&Rectangle,"UPtr",this.base.hBackgroundBrush)

        hBrush := this.State ? this.base.hOnBrush : this.base.hOffBrush ;select the brush

        ;draw overlay rectangle
        NumPut(Round(X + (W * 0.3)),Rectangle,0,"Int")
        NumPut(Round(Y + (H * 0.3)),Rectangle,4,"Int")
        NumPut(Round(X + (W * 0.7)),Rectangle,8,"Int")
        NumPut(Round(Y + (H * 0.7)),Rectangle,12,"Int")
        DllCall("FillRect","UPtr",hDC,"UPtr",&Rectangle,"UPtr",hBrush)
    }
}