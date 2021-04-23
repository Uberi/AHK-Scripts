#NoEnv

class Plug extends Nodes.Load
{
    static hPen := DllCall("GetStockObject","Int",8,"UPtr") ;NULL_PEN
    static hBrush := DllCall("CreateSolidBrush","UInt",0x3333AA,"UPtr")

    Recalculate(OpenList)
    {
        base.Recalculate(OpenList)
        this.UpdatePlug(OpenList)
    }

    ModifyState(Amount,OpenList)
    {
        base.ModifyState(Amount,OpenList)
        this.UpdatePlug(OpenList)
    }

    UpdatePlug(OpenList)
    {
        global Grid
        If this.State ;plug on
        {
            For Index, Offset In [[-2,0]
                                 ,[2,0]
                                 ,[0,-2]
                                 ,[0,2]]
            {
                If !Grid[this.IndexX + (Offset[1] >> 1),this.IndexY + (Offset[2] >> 1)] ;node between the two nodes is empty
                {
                    Cell := Grid[this.IndexX + Offset[1],this.IndexY + Offset[2]]
                    If Cell.__Class = "Nodes.Socket" && !Cell.State
                        Cell.ModifyState(1,OpenList)
                    If Cell.__Class = "Nodes.Inverter" && Cell.State
                        Cell.ModifyState(-1,OpenList)
                }
            }
        }
        Else ;plug off
        {
            For Index, Offset In [[-2,0]
                                 ,[2,0]
                                 ,[0,-2]
                                 ,[0,2]]
            {
                If !Grid[this.IndexX + (Offset[1] >> 1),this.IndexY + (Offset[2] >> 1)] ;node between the two nodes is empty
                {
                    Cell := Grid[this.IndexX + Offset[1],this.IndexY + Offset[2]]
                    If Cell.__Class = "Nodes.Socket" && Cell.State
                        Cell.ModifyState(-1,OpenList)
                    If Cell.__Class = "Nodes.Inverter" && !Cell.State
                        Cell.ModifyState(1,OpenList)
                }
            }
        }
    }

    Draw(hDC,X,Y,W,H)
    {
        hOriginalPen := DllCall("SelectObject","UPtr",hDC,"UPtr",this.base.hPen,"UPtr") ;select the pen
        hOriginalBrush := DllCall("SelectObject","UPtr",hDC,"UPtr",this.base.hBrush,"UPtr") ;select the brush

        Vertices := 3
        VarSetCapacity(Points,8 * Vertices)

        ;draw left arrow
        NumPut(Round(X),Points,0,"Int"), NumPut(Round(Y + (H * 0.5)),Points,4,"Int")
        NumPut(Round(X + (W * 0.3)),Points,8,"Int"), NumPut(Round(Y + (H * 0.3)),Points,12,"Int")
        NumPut(Round(X + (W * 0.3)),Points,16,"Int"), NumPut(Round(Y + (H * 0.7)),Points,20,"Int")
        DllCall("Polygon","UPtr",hDC,"UPtr",&Points,"Int",Vertices)

        ;draw right arrow
        NumPut(Round(X + W),Points,0,"Int")
        NumPut(Round(X + (W * 0.7)),Points,8,"Int")
        NumPut(Round(X + (W * 0.7)),Points,16,"Int")
        DllCall("Polygon","UPtr",hDC,"UPtr",&Points,"Int",Vertices)

        ;draw top arrow
        NumPut(Round(X + (W * 0.5)),Points,0,"Int"), NumPut(Round(Y),Points,4,"Int")
        NumPut(Round(X + (W * 0.3)),Points,8,"Int"), NumPut(Round(Y + (H * 0.3)),Points,12,"Int")
        NumPut(Round(X + (W * 0.7)),Points,16,"Int"), NumPut(Round(Y + (H * 0.3)),Points,20,"Int")
        DllCall("Polygon","UPtr",hDC,"UPtr",&Points,"Int",Vertices)

        ;draw bottom arrow
        NumPut(Round(Y + H),Points,4,"Int")
        NumPut(Round(Y + (H * 0.7)),Points,12,"Int")
        NumPut(Round(Y + (H * 0.7)),Points,20,"Int")
        DllCall("Polygon","UPtr",hDC,"UPtr",&Points,"Int",Vertices)

        DllCall("SelectObject","UPtr",hDC,"UPtr",hOriginalPen,"UPtr") ;deselect the pen
        DllCall("SelectObject","UPtr",hDC,"UPtr",hOriginalBrush,"UPtr") ;deselect the brush
    }
}