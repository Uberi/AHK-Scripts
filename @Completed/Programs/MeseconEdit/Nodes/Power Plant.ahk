#NoEnv

class PowerPlant extends Nodes.Power
{
    static hPen := DllCall("GetStockObject","Int",8,"UPtr") ;NULL_PEN
    static hBrush := DllCall("CreateSolidBrush","UInt",0x00FFFF,"UPtr")

    __New(IndexX,IndexY)
    {
        this.State := 1
        base.__New(IndexX,IndexY)
    }

    Draw(hDC,X,Y,W,H)
    {
        hOriginalPen := DllCall("SelectObject","UPtr",hDC,"UPtr",this.base.hPen,"UPtr") ;select the pen
        hOriginalBrush := DllCall("SelectObject","UPtr",hDC,"UPtr",this.base.hBrush,"UPtr") ;select the brush

        ;draw the power plant
        DllCall("Ellipse","UPtr",hDC,"Int",Round(X + (W * 0.1)),"Int",Round(Y + (H * 0.1)),"Int",Round(X + (W * 0.9)),"Int",Round(Y + (H * 0.9)))

        DllCall("SelectObject","UPtr",hDC,"UPtr",hOriginalPen,"UPtr") ;deselect the pen
        DllCall("SelectObject","UPtr",hDC,"UPtr",hOriginalBrush,"UPtr") ;deselect the brush
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