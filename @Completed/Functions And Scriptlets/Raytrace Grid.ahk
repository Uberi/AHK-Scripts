#NoEnv

/*
Callback := Func("Visit")
RayTraceGrid(0.5,0.5,-45,Callback)
LineTraceGrid(0.5,0.5,2.5,3.5,Callback)
ExitApp

Visit(X,Y,Distance)
{
    MsgBox, %X% %Y%`n%Distance%
}
*/

LineTraceGrid(X1,Y1,X2,Y2,Callback)
{
    If (X1 > X2)
        Temp1 := X1, X1 := X2, X2 := Temp1
    If (Y1 > Y2)
        Temp1 := Y1, Y1 := Y2, Y2 := Temp1

    X := Floor(X1), Y := Floor(Y1)
    ExtentX := X2 - X1, ExtentY := Y2 - Y1

    Count := 1 ;number of cells intersecting with the line

    If ExtentX = 0
    {
        ComponentX := 0
        IntersectX := ~0 ;wip: represents infinity
    }
    Else
    {
        ComponentX := 1 / ExtentX
        IntersectX := ((X - X1) + 1) * ComponentX
        Count += Floor(X2) - X
    }

    If ExtentY = 0
    {
        ComponentY := 0
        IntersectY := ~0 ;wip: represents infinity
    }
    Else
    {
        ComponentY := 1 / ExtentY
        IntersectY := ((Y - Y1) + 1) * ComponentY
        Count += Floor(Y2) - Y
    }

    Distance := 0
    Loop, %Count%
    {
        Callback.(X,Y,Distance)

        If (IntersectX < IntersectY) ;intersection with left or right
        {
            X ++
            Distance := IntersectX
            IntersectX += ComponentX
        }
        Else If (IntersectX > IntersectY) ;intersection with top or bottom
        {
            Y ++
            Distance := IntersectY
            IntersectY += ComponentY
        }
        Else ;passing through the grid corner exactly
        {
            X ++, Y ++
            Distance := IntersectX
            IntersectX += ComponentX, IntersectY += ComponentY
        }
    }
}

/* ;2D specialized variant
LineTraceGrid(X1,Y1,X2,Y2,Callback)
{
    If (X1 > X2)
        Temp1 := X1, X1 := X2, X2 := Temp1
    If (Y1 > Y2)
        Temp1 := Y1, Y1 := Y2, Y2 := Temp1

    X := Floor(X1), Y := Floor(Y1)
    ExtentX := X2 - X1, ExtentY := Y2 - Y1

    Count := 1 ;number of cells intersecting with the line
    Bias := 0 ;difference of X and Y axis intersection distances

    If ExtentX = 0
        Bias += ~0 ;wip: represents infinity
    Else
    {
        Bias += ((X - X1) + 1) * ExtentX
        Count += Floor(X2) - X
    }

    If ExtentY = 0
        Bias -= ~0 ;wip: represents infinity
    Else
    {
        Bias -= ((Y - Y1) + 1) * ExtentY
        Count += Floor(Y2) - Y
    }

    Loop, %Count%
    {
        Callback.(X,Y)

        If Bias < 0 ;intersection with left or right
        {
            X ++
            Bias += ExtentX
        }
        Else If Bias > 0 ;intersection with top or bottom
        {
            Y ++
            Bias -= ExtentY
        }
        Else ;passing through the grid corner exactly
        {
            X ++, Y ++
            Bias += ExtentX - ExtentY
        }
    }
}
*/

/* ;2D specialized variant for integer coordinates
LineTraceGrid(X1,Y1,X2,Y2,Callback)
{
    If (X1 > X2)
        Temp1 := X1, X1 := X2, X2 := Temp1
    If (Y1 > Y2)
        Temp1 := Y1, Y1 := Y2, Y2 := Temp1

    X := Floor(X1), Y := Floor(Y1)
    ExtentX := X2 - X1, ExtentY := Y2 - Y1

    Count := ExtentX + ExtentY + 1 ;number of cells intersecting with the line
    Bias := ExtentX - ExtentY ;difference of X and Y axis intersection distances

    Loop, %Count%
    {
        Callback.(X,Y)

        If Bias < 0 ;intersection with left or right
        {
            X ++
            Bias += ExtentX
        }
        Else If Bias > 0 ;intersection with top or bottom
        {
            Y ++
            Bias -= ExtentY
        }
        Else ;passing through the grid corner exactly
        {
            X ++, Y ++
            Bias += ExtentX - ExtentY
        }
    }
}
*/

RayTraceGrid(X,Y,Angle,Callback)
{
    static Radians := 3.141592653589793 / 180

    ;limit the angle to between 0 and limit 360
    Angle := Mod(Angle,360)
    If Angle < 0
        Angle += 360

    BaseX := Floor(X), BaseY := Floor(Y)

    If (Angle = 0 || Angle = 180) ;vertical ray
    {
        StepX := 0
        ComponentX := 0
        IntersectX := ~0 ;wip: represents infinity
    }
    Else If Angle < 180 ;line slopes rightward
    {
        StepX := 1
        ComponentX := 1 / Sin(Angle * Radians)
        IntersectX := ((BaseX - X) + 1) * ComponentX
    }
    Else ;line slopes leftward
    {
        StepX := -1
        ComponentX := 1 / -Sin(Angle * Radians)
        IntersectX := (X - BaseX) * ComponentX
    }

    If (Angle = 90 || Angle = 270) ;horizontal ray
    {
        StepY := 0
        ComponentY := 0
        IntersectY := ~0 ;wip: represents infinity
    }
    Else If (Angle < 90 || Angle > 270) ;line slopes upward
    {
        StepY := 1
        ComponentY := 1 / Cos(Angle * Radians)
        IntersectY := ((BaseY - Y) + 1) * ComponentY
    }
    Else ;line slopes downward
    {
        StepY := -1
        ComponentY := 1 / -Cos(Angle * Radians)
        IntersectY := (Y - BaseY) * ComponentY
    }

    Distance := 0
    Loop
    {
        Callback.(BaseX,BaseY,Distance)

        If (IntersectX < IntersectY) ;intersection with left or right
        {
            Distance := IntersectX
            BaseX += StepX
            IntersectX += ComponentX
        }
        Else If (IntersectX > IntersectY) ;intersection with top or bottom
        {
            Distance := IntersectY
            BaseY += StepY
            IntersectY += ComponentY
        }
        Else ;passing through the grid corner exactly
        {
            Distance := IntersectX
            BaseX += StepX, BaseY += StepY
            IntersectX += ComponentX, IntersectY += ComponentY
        }
    }
}