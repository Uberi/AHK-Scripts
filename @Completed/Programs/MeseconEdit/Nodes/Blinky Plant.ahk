#NoEnv

class BlinkyPlant extends Nodes.Power
{
    static hPen := DllCall("GetStockObject","Int",8,"UPtr") ;NULL_PEN
    static hOffBrush := DllCall("CreateSolidBrush","UInt",0x000088,"UPtr")
    static hOnBrush := DllCall("CreateSolidBrush","UInt",0x0088FF,"UPtr")
    static BlinkyPlantArray := Nodes.BlinkyPlant.SetBlinkyPlantTimer()

    SetBlinkyPlantTimer()
    {
        SetTimer, BlinkyPlantUpdate, 1000
        Return, []

        BlinkyPlantUpdate:
        Critical
        For pNode In Nodes.BlinkyPlant.BlinkyPlantArray
        {
            Node := Object(pNode)
            Node.ModifyState(Node.State ? -1 : 1,[])
        }
        Return
    }

    __New(IndexX,IndexY)
    {
        global Grid
        this.State := 1
        base.__New(IndexX,IndexY)
        this.base.BlinkyPlantArray[&this] := ""
    }

    __Delete()
    {
        this.base.BlinkyPlantArray.Remove(&this,"")
    }

    Draw(hDC,X,Y,W,H)
    {
        hBrush := this.State ? this.base.hOnBrush : this.base.hOffBrush

        hOriginalPen := DllCall("SelectObject","UPtr",hDC,"UPtr",this.base.hPen,"UPtr") ;select the pen
        hOriginalBrush := DllCall("SelectObject","UPtr",hDC,"UPtr",hBrush,"UPtr") ;select the brush

        ;draw the power plant
        DllCall("Ellipse","UPtr",hDC,"Int",Round(X + (W * 0.1)),"Int",Round(Y + (H * 0.1)),"Int",Round(X + (W * 0.9)),"Int",Round(Y + (H * 0.9)))

        DllCall("SelectObject","UPtr",hDC,"UPtr",hOriginalPen,"UPtr") ;deselect the pen
        DllCall("SelectObject","UPtr",hDC,"UPtr",hOriginalBrush,"UPtr") ;deselect the brush
    }
}