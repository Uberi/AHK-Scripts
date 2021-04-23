class Basis
{
    Punch()
    {
        
    }

    WalkOver()
    {
        
    }

    Draw(hDC,X,Y,W,H)
    {
        
    }

    Serialize()
    {
        Return, this.State
    }

    Deserialize(IndexX,IndexY,Value)
    {
        Result := new this(IndexX,IndexY)
        Result.State := Value
        Return, Result
    }
}

class Power extends Nodes.Basis
{
    __New(IndexX,IndexY)
    {
        global Grid

        this.IndexX := IndexX, this.IndexY := IndexY
        this.Send := True
        this.Receive := False

        this.Propagate(this.State)
    }

    __Delete()
    {
        global Grid
        this.Propagate(-this.State)
    }

    Propagate(Amount)
    {
        global Grid

        ;obtain neighbor nodes
        Left := Grid[this.IndexX - 1,this.IndexY]
        Right := Grid[this.IndexX + 1,this.IndexY]
        Top := Grid[this.IndexX,this.IndexY - 1]
        Bottom := Grid[this.IndexX,this.IndexY + 1]

        ;propagate state to neighbors
        If Left.Receive
            Left.ModifyState(Amount,[])
        If Right.Receive
            Right.ModifyState(Amount,[])
        If Top.Receive
            Top.ModifyState(Amount,[])
        If Bottom.Receive
            Bottom.ModifyState(Amount,[])
    }

    ModifyState(Amount,OpenList)
    {
        global Grid
        this.State += Amount
        OpenList[this.IndexX,this.IndexY] := 1

        ;obtain neighbor nodes
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

    PowerSourceConnected()
    {
        Return, this.State
    }
}

class Load extends Nodes.Basis
{
    __New(IndexX,IndexY)
    {
        this.IndexX := IndexX, this.IndexY := IndexY
        this.Send := False
        this.Receive := True

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

        ;obtain total state from neighbors
        this.State := 0
        If Left.Send && Left.State && !OpenList[Left.IndexX,Left.IndexY]
            this.State += Left.State
        If Right.Send && Right.State && !OpenList[Right.IndexX,Right.IndexY]
            this.State += Right.State
        If Top.Send && Top.State && !OpenList[Top.IndexX,Top.IndexY]
            this.State += Top.State
        If Bottom.Send && Bottom.State && !OpenList[Bottom.IndexX,Bottom.IndexY]
            this.State += Bottom.State
    }

    PowerSourceConnected(OpenList)
    {
        Return, 0
    }

    ModifyState(Amount,OpenList)
    {
        this.State += Amount
    }
}