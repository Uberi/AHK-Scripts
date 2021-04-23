#NoEnv

global Infinity := 0xFFFFFFFFFFFFFFF
global Degrees := 180 / 3.141592653589793

;wip: see if angular velocity calculations are right (using degrees/s instead of rads/s?)
;wip: add support for arbitrary polygons and calculate area/centroid with http://paulbourke.net/geometry/polyarea/, moment of inertia with http://math.stackexchange.com/questions/59470/calculating-moment-of-inertia-in-2d-planar-polygon or http://www.gamedev.net/topic/342822-moment-of-inertia-of-a-polygon-2d/

#Warn All
#Warn LocalSameAsGlobal, Off

SetBatchLines, -1

DurationLimit := 1 / 60
Width := 10 ;meters
Height := 10 ;meters

s := new Canvas.Surface(400,400)
s.Smooth := "Good"

Gui, +LastFound
v := (new Canvas.Viewport(WinExist())).Attach(s)

Gui, Show, w400 h400, Physics Test

p := new Parasol

/*
Particles := [new p.Particle(2.5,2.5)
             ,new p.Particle(7.5,5.5)
             ,new p.Particle(2.5,5)
             ,new p.Particle(4,5)
             ,new p.Particle(6,2)]
For Index, Particle In Particles
{
    ;Particle.Mass := 10000000000
    p.AddEntity(Particle)
    ;p.Register(new Gravity(Particle))
    p.Register(new p.Drag(Particle,0.9))
    ;p.Register(new Buoyancy(Particle,6,4,5))
}

;/*
p.Register(new p.Rod(Particles[1],Particles[4],0,0,0,0,2))
p.Register(new p.Cable(Particles[1],Particles[2],0,0,0,0,3,0.5))
p.Register(new p.Rod(Particles[3],Particles[4],0,0,0,0,2.5))
p.Register(new p.Rod(Particles[1],Particles[3],0,0,0,0,2.5))
p.Register(new p.Rod(Particles[1],Particles[5],0,0,0,0,2.5))
p.Register(new p.Rod(Particles[2],Particles[5],0,0,0,0,2.5))
p.Register(new p.Spring(Particles[2],Particles[4],0,0,0,0,3,30))
*/

;/*
Anchor := new p.Particle(5,1)
Anchor.Mass := Infinity
p.AddEntity(Anchor)

Shape1 := new Parasol.Polygon(5,7,[{X: -1, Y: -0.5}, {X: 1, Y: -0.5}, {X: 1, Y: 1}, {X: 0, Y: 1.5}, {X: -1, Y: 1}],45)
Shape1.Mass := Infinity
Shape1.RotationalInertia := Infinity
p.AddEntity(Shape1)

Shape2 := new Parasol.Polygon(2,2,[{X: -1, Y: -1}, {X: 1, Y: -1}, {X: 0.5, Y: 1}, {X: -0.5, Y: 1}],-25)
Shape2.Mass := 3
Shape2.RotationalInertia := 0.5
p.Register(new p.Gravity(Shape2))
p.Register(new p.Drag(Shape2,0.3))
;p.Register(new p.Force(Shape2,1,-1,0,-28,True))
;p.Register(new p.Motor(Shape2,90))
p.Register(new p.Bungee(Shape2,Anchor,-1,-1,0,0,4,50))
;p.Register(new p.Cable(Shape2,Anchor,1,-1,0,0,4,0.2))
p.AddEntity(Shape2)

Shape3 := new Parasol.Polygon(8,2,[{X: -1, Y: -1}, {X: 1, Y: -1}, {X: 0, Y: 1}],-25)
Shape3.Mass := 3
Shape3.RotationalInertia := 0.5
p.Register(new p.Gravity(Shape3))
p.Register(new p.Drag(Shape3,0.3))
p.Register(new p.Bungee(Shape3,Anchor,1,-1,0,0,3,30))
p.AddEntity(Shape3)

p.Register(new p.Collision)
*/

TickFrequency := 0, Ticks1 := 0, Ticks := 0
If !DllCall("QueryPerformanceFrequency","Int64*",TickFrequency) ;obtain ticks per second
    throw Exception("Could not obtain performance counter frequency.")
If !DllCall("QueryPerformanceCounter","Int64*",Ticks1) ;obtain the performance counter value
    throw Exception("Could not obtain performance counter value.")
Loop
{
    If !DllCall("QueryPerformanceCounter","Int64*",Ticks) ;obtain the performance counter value
        throw Exception("Could not obtain performance counter value.")
    Duration := (Ticks - Ticks1) / TickFrequency, Ticks1 := Ticks
    If Duration < 0
        Duration := 0
    If (Duration > DurationLimit)
        Duration := DurationLimit

    p.Step(Duration)

    Draw(p,s,v)
    Sleep, 10
}
Return

GuiEscape:
GuiClose:
ExitApp

Esc::ExitApp

#Include %A_ScriptDir%\..\Canvas-AHK\
#Include Canvas.ahk

#Include %A_ScriptDir%\Parasol
#Include Parasol.ahk

Draw(Parasol,Surface,Viewport)
{
    global Width
    global Height

    ScaleX := 400 / Width
    ScaleY := 400 / Height

    static Grid := new Canvas.Pen(0x88000000,1)
    static Buoyancy := new Canvas.Pen(0xBBFFFF00,3)
    static Ground := new Canvas.Pen(0xBB00FF00,3)
    static Shape := new Canvas.Pen(0xFF000000,5), _ := Shape.Join := "Round"
    static Particle := new Canvas.Brush(0xFFFF0000)

    Surface.Clear(0xFFFFFFFF)

    ;draw grid
    Loop, 9
        Surface.Line(Grid,0,A_Index * ScaleY,Width * ScaleX,A_Index * ScaleY)
    Loop, 9
        Surface.Line(Grid,A_Index * ScaleX,0,A_Index * ScaleX,Height * ScaleY)

    ;draw generators
    For Index, Generator In Parasol.Generators
    {
        If Generator.__Class = "Parasol.Force"
            Draw.Force(Surface,Generator,ScaleX,ScaleY)
        Else If Generator.__Class = "Parasol.Cable"
            Draw.Cable(Surface,Generator,ScaleX,ScaleY)
        Else If Generator.__Class = "Parasol.Rod"
            Draw.Rod(Surface,Generator,ScaleX,ScaleY)
        Else If Generator.__Class = "Buoyancy"
            Surface.Line(Buoyancy,0,Generator.LiquidLevel * ScaleY,Width * ScaleX,Generator.LiquidLevel * ScaleY)
        Else If Generator.__Class = "Parasol.Spring"
            Draw.Spring(Surface,Generator,ScaleX,ScaleY)
        Else If Generator.__Class = "Parasol.Bungee"
            Draw.Bungee(Surface,Generator,ScaleX,ScaleY)
    }

    For Entity In Parasol.Entities
    {
        If Entity.__Class = "Parasol.Polygon"
        {
            Points := []
            For Index, Point In Entity.Points
                Points[Index] := [Point.X * ScaleX, Point.Y * ScaleY]
            Surface.Push()
                   .Translate(Entity.X * ScaleX,Entity.Y * ScaleY)
                   .Rotate(Entity.Angle)
                   .DrawPolygon(Shape,Points)
                   .Pop()
        }
        Else
            Surface.FillEllipse(Particle,(Entity.X * ScaleX) - 5,(Entity.Y * ScaleY) - 5,10,10)
    }
    Viewport.Refresh()
}

class Draw
{
    Force(Surface,Generator,ScaleX,ScaleY)
    {
        static Pen := new Canvas.Pen(0xBBFFFF00,6), _ := Pen.EndCap := "Triangle"
        Generator.Entity.Transformed(Generator.X,Generator.Y,X,Y)
        X *= ScaleX, Y *= ScaleY
        If Generator.Local
        {
            Generator.Entity.Transformed(Generator.ForceX,Generator.ForceY,ForceX,ForceY)
            ForceX := (ForceX - Generator.Entity.X) / 10, ForceY := (ForceY - Generator.Entity.Y ) / 10
        }
        Else
            ForceX := Generator.ForceX / 10, ForceY := Generator.ForceY / 10
        NewX := X + (ForceX * ScaleX), NewY := Y + (ForceY * ScaleY)
        Surface.Line(Pen,X,Y,NewX,NewY)
        Surface.Line(Pen,NewX,NewY,NewX - 10,NewY - 10) ;wip: draw the arrowhead properly
        Surface.Line(Pen,NewX,NewY,NewX + 10,NewY - 10)
        
    }

    Cable(Surface,Generator,ScaleX,ScaleY)
    {
        static Pen := new Canvas.Pen(0xBBFF00FF,3)
        Generator.Entity1.Transformed(Generator.X1,Generator.Y1,X1,Y1)
        Generator.Entity2.Transformed(Generator.X2,Generator.Y2,X2,Y2)
        Surface.Line(Pen,X1 * ScaleX,Y1 * ScaleY,X2 * ScaleX,Y2 * ScaleY)
    }

    Rod(Surface,Generator,ScaleX,ScaleY)
    {
        static Pen := new Canvas.Pen(0xBB00FFFF,3)
        Generator.Entity1.Transformed(Generator.X1,Generator.Y1,X1,Y1)
        Generator.Entity2.Transformed(Generator.X2,Generator.Y2,X2,Y2)
        Surface.Line(Pen,X1 * ScaleX,Y1 * ScaleY,X2 * ScaleX,Y2 * ScaleY)
    }

    Spring(Surface,Generator,ScaleX,ScaleY)
    {
        static Pen := new Canvas.Pen(0xBB00FF00,3)
        Generator.Entity1.Transformed(Generator.X1,Generator.Y1,X1,Y1)
        Generator.Entity2.Transformed(Generator.X2,Generator.Y2,X2,Y2)
        Surface.Line(Pen,X1 * ScaleX,Y1 * ScaleY,X2 * ScaleX,Y2 * ScaleY)
    }

    Bungee(Surface,Generator,ScaleX,ScaleY)
    {
        static Pen := new Canvas.Pen(0xBB0000FF,3)
        Generator.Entity1.Transformed(Generator.X1,Generator.Y1,X1,Y1)
        Generator.Entity2.Transformed(Generator.X2,Generator.Y2,X2,Y2)
        Surface.Line(Pen,X1 * ScaleX,Y1 * ScaleY,X2 * ScaleX,Y2 * ScaleY)
    }
}

class Gravity
{
    __New(Entity) ;Newtons/kilograms
    {
        this.Entity := Entity
    }
    
    Step(Duration,Instance)
    {
        For Entity In Instance.Entities
        {
            If this.Entity = Entity
                Continue
            If this.Entity.Mass = Infinity || Entity.Mass = Infinity
                Continue
            X := Entity.X - this.Entity.X, Y := Entity.Y - this.Entity.Y ;meters = meters - meters
            DistanceSquared := (X ** 2) + (Y ** 2) ;meters^2 = meters ^ 2 + meters ^ 2
            Distance := Sqrt(DistanceSquared) ;meters = sqrt(meters^2)
            X /= Distance, Y /= Distance ;1 = meters / meters
            GravitationalConstant := 0.00000000006673 ;meters^3/kilograms*seconds^2
            Magnitude := (GravitationalConstant * this.Entity.Mass * Entity.Mass) / DistanceSquared ;Newtons = meters^3/kilograms*seconds^2 * kilograms * kilograms / meters^2
            If Magnitude > 100000000000
                Continue
            this.Entity.Force(this.Entity.X,this.Entity.Y,X * Magnitude,Y * Magnitude)
        }
    }
}

class Buoyancy
{
    __New(Entity,Volume,LiquidLevel,LiquidDensity)
    {
        this.Entity := Entity
        this.Volume := Volume
        this.LiquidLevel := LiquidLevel
        this.LiquidDensity := LiquidDensity
    }

    Step(Duration,Instance) ;wip: doesn't work with rigid bodies (see page 244 for other implementation or src/fgen.cpp), for box add bouyancy check at each of four points
    {
        Depth := this.Entity.Y - this.LiquidLevel
        If Depth < -5 ;outside of the liquid
            Return
        If Depth > 5 ;fully submerged ;wip
            this.Entity.Force(this.Entity.X,this.Entity.Y,0,-this.Volume * this.LiquidDensity)
        Else
            this.Entity.Force(this.Entity.X,this.Entity.Y,0,-this.Volume * this.LiquidDensity * ((Depth + 5) / 10))
    }
}