class Solid extends Nodes.Basis
{
    static hBrush := DllCall("CreateSolidBrush","UInt",0x00AA00,"UPtr")

    __New(IndexX,IndexY)
    {
        this.Send := False
        this.Receive := False
    }

    Draw(hDC,X,Y,W,H)
    {
        VarSetCapacity(Rectangle,16)

        ;draw rectangle
        NumPut(Round(X + (W * 0.1)),Rectangle,0,"Int")
        NumPut(Round(Y + (H * 0.1)),Rectangle,4,"Int")
        NumPut(Round(X + (W * 0.9)),Rectangle,8,"Int")
        NumPut(Round(Y + (H * 0.9)),Rectangle,12,"Int")
        DllCall("FillRect","UPtr",hDC,"UPtr",&Rectangle,"UPtr",this.base.hBrush)
    }

    Serialize()
    {
        Return, ""
    }

    Deserialize(IndexX,IndexY,Value)
    {
        Return, new this(IndexX,IndexY)
    }
}