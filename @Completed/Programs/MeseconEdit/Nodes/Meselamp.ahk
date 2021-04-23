#NoEnv

class Meselamp extends Nodes.Load
{
    static hOffBrush := DllCall("CreateSolidBrush","UInt",0x777777,"UPtr")
    static hOnBrush := DllCall("CreateSolidBrush","UInt",0xFFFFFF,"UPtr")

    Draw(hDC,X,Y,W,H)
    {
        hBrush := this.State ? this.base.hOnBrush : this.base.hOffBrush ;select the brush

        VarSetCapacity(Rectangle,16)

        ;draw rectangle
        NumPut(Round(X + (W * 0.1)),Rectangle,0,"Int")
        NumPut(Round(Y + (H * 0.3)),Rectangle,4,"Int")
        NumPut(Round(X + (W * 0.9)),Rectangle,8,"Int")
        NumPut(Round(Y + (H * 0.7)),Rectangle,12,"Int")
        DllCall("FillRect","UPtr",hDC,"UPtr",&Rectangle,"UPtr",hBrush)
    }
}