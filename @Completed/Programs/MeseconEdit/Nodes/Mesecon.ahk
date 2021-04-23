#NoEnv

class Mesecon extends Nodes.Basis
{
    static hOffBrush := DllCall("CreateSolidBrush","UInt",0x008888,"UPtr")
    static hOnBrush := DllCall("CreateSolidBrush","UInt",0x00FFFF,"UPtr")

    __New(IndexX,IndexY)
    {
        global Grid
        this.IndexX := IndexX, this.IndexY := IndexY
        this.Send := True
        this.Receive := True

        ;obtain neighbor nodes
        Left := Grid[IndexX - 1,IndexY]
        Right := Grid[IndexX + 1,IndexY]
        Top := Grid[IndexX,IndexY - 1]
        Bottom := Grid[IndexX,IndexY + 1]

        ;obtain total state from neighbors
        this.State := 0
        If Left.Send && Left.State
            this.State += Left.State
        If Right.Send && Right.State
            this.State += Right.State
        If Top.Send && Top.State
            this.State += Top.State
        If Bottom.Send && Bottom.State
            this.State += Bottom.State

        If this.State
        {
            OpenList := [], OpenList[IndexX,IndexY] := 1

            ;propagate current state to neighbors ;wip: this is somewhat broken for the following: Power-Mesecon-Plug-Power, when Mesecon is inserted last
            If Left.Receive
            {
                If Left.Send
                    Left.ModifyState(this.State - Left.State,OpenList)
                Else
                    Left.ModifyState(this.State,OpenList)
            }
            If Right.Receive
            {
                If Right.Send
                    Right.ModifyState(this.State - Right.State,OpenList)
                Else
                    Right.ModifyState(this.State,OpenList)
            }
            If Top.Receive
            {
                If Top.Send
                    Top.ModifyState(this.State - Top.State,OpenList)
                Else
                    Top.ModifyState(this.State,OpenList)
            }
            If Bottom.Receive
            {
                If Bottom.Send
                    Bottom.ModifyState(this.State - Bottom.State,OpenList)
                Else
                    Bottom.ModifyState(this.State,OpenList)
            }
        }
    }

    __Delete()
    {
        this.Recalculate([])
    }

    Recalculate(OpenList)
    {
        global Grid
        OpenList[this.IndexX,this.IndexY] := 1

        ;obtain neighbor nodes
        Left := Grid[this.IndexX - 1,this.IndexY]
        Right := Grid[this.IndexX + 1,this.IndexY]
        Top := Grid[this.IndexX,this.IndexY - 1]
        Bottom := Grid[this.IndexX,this.IndexY + 1]

        this.State := this.PowerSourceConnected([])

        ;update neighbor nodes
        If Left.Receive && !OpenList[Left.IndexX,Left.IndexY]
            Left.Recalculate(OpenList)
        If Right.Receive && !OpenList[Right.IndexX,Right.IndexY]
            Right.Recalculate(OpenList)
        If Top.Receive && !OpenList[Top.IndexX,Top.IndexY]
            Top.Recalculate(OpenList)
        If Bottom.Receive && !OpenList[Bottom.IndexX,Bottom.IndexY]
            Bottom.Recalculate(OpenList)
    }

    PowerSourceConnected(OpenList)
    {
        global Grid
        OpenList[this.IndexX,this.IndexY] := 1

        ;obtain neighbor nodes
        Left := Grid[this.IndexX - 1,this.IndexY]
        Right := Grid[this.IndexX + 1,this.IndexY]
        Top := Grid[this.IndexX,this.IndexY - 1]
        Bottom := Grid[this.IndexX,this.IndexY + 1]

        ;obtain power source connectivity of neighbor nodes
        Result := 0
        If Left.Send && !OpenList[Left.IndexX,Left.IndexY]
            Result += Left.PowerSourceConnected(OpenList)
        If Right.Send && !OpenList[Right.IndexX,Right.IndexY]
            Result += Right.PowerSourceConnected(OpenList)
        If Top.Send && !OpenList[Top.IndexX,Top.IndexY]
            Result += Top.PowerSourceConnected(OpenList)
        If Bottom.Send && !OpenList[Bottom.IndexX,Bottom.IndexY]
            Result += Bottom.PowerSourceConnected(OpenList)
        Return, Result
    }

    ModifyState(Amount,OpenList)
    {
        global Grid
        this.State += Amount
        OpenList[this.IndexX,this.IndexY] := 1

        ;obtain neightbor nodes
        Left := Grid[this.IndexX - 1,this.IndexY]
        Right := Grid[this.IndexX + 1,this.IndexY]
        Top := Grid[this.IndexX,this.IndexY - 1]
        Bottom := Grid[this.IndexX,this.IndexY + 1]

        ;propagate current state to neighbors
        If Left.Receive && !OpenList[Left.IndexX,Left.IndexY]
            Left.ModifyState(Amount,OpenList)
        If Right.Receive && !OpenList[Right.IndexX,Right.IndexY]
            Right.ModifyState(Amount,OpenList)
        If Top.Receive && !OpenList[Top.IndexX,Top.IndexY]
            Top.ModifyState(Amount,OpenList)
        If Bottom.Receive && !OpenList[Bottom.IndexX,Bottom.IndexY]
            Bottom.ModifyState(Amount,OpenList)
    }

    Draw(hDC,X,Y,W,H)
    {
        global Grid

        ;obtain neighbor nodes
        Left := Grid[this.IndexX - 1,this.IndexY], Left := Left.Send || Left.Receive
        Right := Grid[this.IndexX + 1,this.IndexY], Right := Right.Send || Right.Receive
        Top := Grid[this.IndexX,this.IndexY - 1], Top := Top.Send || Top.Receive
        Bottom := Grid[this.IndexX,this.IndexY + 1], Bottom := Bottom.Send || Bottom.Receive

        hBrush := this.State ? this.base.hOnBrush : this.base.hOffBrush

        VarSetCapacity(Rectangle,16)

        ;draw horizontal bar
        NumPut(Round(Y + (H * 0.4)),Rectangle,4,"Int")
        NumPut(Round(Y + (H * 0.6)),Rectangle,12,"Int")
        If Left ;left neighbor
        {
            NumPut(Round(X),Rectangle,0,"Int")
            If Right
                NumPut(Round(X + W),Rectangle,8,"Int")
            Else
                NumPut(Round(X + (W * 0.6)),Rectangle,8,"Int")
            DllCall("FillRect","UPtr",hDC,"UPtr",&Rectangle,"UPtr",hBrush)
        }
        Else If Right ;right but not left neighbor
        {
            NumPut(Round(X + (W * 0.4)),Rectangle,0,"Int")
            NumPut(Round(X + W),Rectangle,8,"Int")
            DllCall("FillRect","UPtr",hDC,"UPtr",&Rectangle,"UPtr",hBrush)
        }
        Else If !(Top || Bottom) ;no neighbors
        {
            NumPut(Round(X + (W * 0.4)),Rectangle,0,"Int")
            NumPut(Round(X + (W * 0.6)),Rectangle,8,"Int")
            DllCall("FillRect","UPtr",hDC,"UPtr",&Rectangle,"UPtr",hBrush)
        }

        ;draw vertical bar
        NumPut(Round(X + (W * 0.4)),Rectangle,0,"Int")
        NumPut(Round(X + (W * 0.6)),Rectangle,8,"Int")
        If Top
        {
            NumPut(Round(Y),Rectangle,4,"Int")
            If Bottom
                NumPut(Round(Y + H),Rectangle,12,"Int")
            Else
                NumPut(Round(Y + (H * 0.6)),Rectangle,12,"Int")
            DllCall("FillRect","UPtr",hDC,"UPtr",&Rectangle,"UPtr",hBrush)
        }
        Else If Bottom
        {
            NumPut(Round(Y + (H * 0.4)),Rectangle,12,"Int")
            NumPut(Round(Y + H),Rectangle,12,"Int")
            DllCall("FillRect","UPtr",hDC,"UPtr",&Rectangle,"UPtr",hBrush)
        }
    }
}