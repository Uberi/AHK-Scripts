#NoEnv

#Warn All
#Warn LocalSameAsGlobal, Off

#Include %A_ScriptDir%\Lib\Sundance.ahk

SetBatchLines, -1
g := new Radiance()
g.Start()
ExitApp

class Radiance extends Sundance
{
    __New()
    {
        base.__New(800,600,"Test Game")
    }

    Initialize()
    {
        p := this.Pens := {}
        b := this.Brushes := {}
        f := this.Fonts := {}
        s := this.Surface

        ;draw loading message
        Grey := new Canvas.Brush(0xFFAAAAAA)
        Loading := new Canvas.Font("Courier New",18)
        Loading.Align := "Center"
        s.Clear(0xFF000000)
         .Text(Grey,Loading,"Loading...",400,300)
        this.Viewport.Refresh()

        ;create resources
        p.White := new Canvas.Pen(0xFFFFFFFF,5)
        b.White := new Canvas.Brush(0xFFFFFFFF)

        s.Smooth := "Good"

        this.ViewX := 0
        this.ViewY := 0

        this.Player := new this.PlayerEntity(0,0)
        this.Register(this.Player)
    }

    Update(Duration)
    {
        b := this.Brushes
        f := this.Fonts
        s := this.Surface

        s.Clear(0xFFFF0000)

        ;move the view towards the player
        this.ViewX := (this.ViewX * 0.95) - (this.Player.X * 0.05)
        this.ViewY := (this.ViewY * 0.95) - (this.Player.Y * 0.05)

        s.Push().Translate(this.ViewX + (this.Width / 2),this.ViewY + (this.Height / 2))

        this.DrawWorld()

        ;wip: update in radius functionality
        For Entity In this.Entities
            Entity.Update(this,Duration)

        ;wip: view clipping draw functionality
        For Entity In this.Entities
            Entity.Draw(this)

        s.Pop()

        this.Viewport.Refresh()
    }

    DrawWorld()
    {
        p := this.Pens
        b := this.Brushes
        f := this.Fonts
        s := this.Surface

        s.DrawEllipse(p.White,-80,-80,160,160)
    }

    class PlayerEntity extends Sundance.Entity
    {
        __New(X,Y)
        {
            this.X := X
            this.Y := Y
            this.MoveSpeed := 250
        }

        Update(Engine,Duration)
        {
            ;handle input
            Movement := Duration * this.MoveSpeed
            If GetKeyState("Left","P")
                this.X -= Movement
            If GetKeyState("Right","P")
                this.X += Movement
            If GetKeyState("Up","P")
                this.Y -= Movement
            If GetKeyState("Down","P")
                this.Y += Movement
        }

        Draw(Engine)
        {
            b := Engine.Brushes
            s := Engine.Surface

            s.FillEllipse(b.White,this.X - 25,this.Y - 25,50,50)
        }
    }
}