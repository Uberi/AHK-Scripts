#NoEnv

#Warn All
#Warn LocalSameAsGlobal, Off

global Infinity := 0xFFFFFFFFFFFFFFF
global Degrees := 180 / 3.141592653589793

Polygon1 := new Parasol.Polygon(200,200,[{X: -40, Y: -20}, {X: 40, Y: -20}, {X: 40, Y: 40}, {X: 0, Y: 60}, {X: -40, Y: 40}],45)
Polygon2 := new Parasol.Polygon(250,250,[{X: -50, Y: -30}, {X: 50, Y: -30}, {X: 20, Y: 50}, {X: -20, Y: 50}],-25)

s := new Canvas.Surface(400,400)
s.Smooth := "Good"

Gui, +LastFound
v := (new Canvas.Viewport(WinExist())).Attach(s)

Gui, Show, w400 h400, Physics Test

CoordMode, Mouse, Client
Loop
{
    MouseGetPos, X, Y
    Polygon2.X := X
    Polygon2.Y := Y

    Draw(Polygon1,Polygon2,s,v)
    Sleep, 50
}
Return

GuiClose:
ExitApp

#Include %A_ScriptDir%\..\Canvas-AHK\
#Include Canvas.ahk

#Include %A_ScriptDir%\Parasol
#Include Parasol.ahk

Left::Polygon1.Angle -= 5
Right::Polygon1.Angle += 5

Up::Polygon2.Angle += 5
Down::Polygon2.Angle -= 5

Esc::ExitApp

Draw(Entity1,Entity2,Surface,Viewport)
{
    static Normal := new Canvas.Pen(0xFFFFFFFF,2)
    static Mark := new Canvas.Pen(0xFFFF0000,2)

    static Direction := new Canvas.Pen(0xFF00FF00,2)
    static Location := new Canvas.Brush(0xFF00FF00)

    Surface.Clear()

    Polygon1 := RotatePolygon(Entity1.Points,Entity1.Angle)
    For Index, Point In Polygon1
        Point.X += Entity1.X, Point.Y += Entity1.Y
    Polygon2 := RotatePolygon(Entity2.Points,Entity2.Angle)
    For Index, Point In Polygon2
        Point.X += Entity2.X, Point.Y += Entity2.Y

    Value := Parasol.Collision.CollidePolygonPolygon(Polygon1,Polygon2)
    If Value
        b := Mark
    Else
        b := Normal

    Points := []
    For Index, Point In Polygon1
        Points[Index] := [Point.X, Point.Y]
    Surface.DrawPolygon(b,Points)

    Points := []
    For Index, Point In Polygon2
        Points[Index] := [Point.X, Point.Y]
    Surface.DrawPolygon(b,Points)

    If Value
    {
        OffsetX := -Value.NormalX * Value.Overlap
        OffsetY := -Value.NormalY * Value.Overlap
        Surface.FillEllipse(Location,Value.X - 3,Value.Y - 3,6,6)
        Surface.Line(Direction,Value.X,Value.Y,Value.X + OffsetX,Value.Y + OffsetY)

        Points := []
        For Index, Point In Polygon2
            Points[Index] := [Point.X + OffsetX, Point.Y + OffsetY]
        Surface.DrawPolygon(Normal,Points)
    }

    Viewport.Refresh()
}

RotatePolygon(Points,Angle)
{
    Opposite := Sin(Angle / Degrees)
    Adjacent := Cos(Angle / Degrees)
    RotatedPolygon := []
    For Index, Point In Points
        RotatedPolygon[Index] := {X: (Point.X * Adjacent) - (Point.Y * Opposite), Y: (Point.X * Opposite) + (Point.Y * Adjacent)}
    Return, RotatedPolygon
}

Rotate(X,Y,Angle,ByRef NewX,ByRef NewY)
{
    Opposite := Sin(Angle / Degrees)
    Adjacent := Cos(Angle / Degrees)

    NewX := (X * Adjacent) - (Y * Opposite)
    NewY := (X * Opposite) + (Y * Adjacent)
}