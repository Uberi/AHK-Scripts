/*
Octree
------

    struct node {
        boolean leaf                    whether the node is a leaf or not
        char    full                    bit mask of full subnodes
        char    empty                   bit mask of empty subnodes
        
    }
*/

Resolution := 1
VarSetCapacity(Octree,8 ** Resolution,0)

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