#NoEnv

#Include %A_LineFile%\..\..\..\Canvas-AHK\Canvas.ahk

;run demo if directly executed
If (A_LineFile = A_ScriptFullPath)
{
    SetBatchLines, -1
    g := new TestGame()
    g.Start()
    ExitApp
}

;skip to the end
Goto, __SundanceStart

class TestGame extends Sundance
{
    __New()
    {
        base.__New(800,600,"Test Game")
    }
}

class Sundance
{
    static GuiMap := {}

    __New(Width,Height,Name = "Game")
    {
        this.Width := Width
        this.Height := Height
        this.Name := Name

        ;create graphics surface
        this.Surface := new Canvas.Surface(Width,Height)

        this.FrameRate := 60
        this.Running := False

        ;set up display window
        this.GuiID := "__Sundance" . &this
        Gui, % this.GuiID . ":+LastFound +Resize +Label__Sundance"
        this.Viewport := new Canvas.Viewport(WinExist())
        this.Viewport.Attach(this.Surface)
        this.base.GuiMap[this.GuiID] := &this ;register the GUI globally
        Gui, % this.GuiID . ":Show", w%Width% h%Height%, %Name%
    }

    __Delete()
    {
        Gui, % this.GuiID . ":Destroy"
        this.base.GuiMap.Remove(this.GuiID) ;unregister the GUI globally
    }

    Initialize()
    {
        b := this.Brushes := {}
        f := this.Fonts := {}

        ;draw loading message
        Grey := new Canvas.Brush(0xFFAAAAAA)
        Loading := new Canvas.Font("Courier New",18)
        Loading.Align := "Center"
        this.Surface.Clear(0xFF000000)
            .Text(Grey,Loading,"Loading...",400,300)
        this.Viewport.Refresh()

        ;create resources
        b.White := new Canvas.Brush(0xFFFFFFFF)

        this.Surface.Smooth := "Good"

        this.Register(new this.Entity(this.Width / 2,this.Height / 2))
    }

    Update(Duration)
    {
        b := this.Brushes
        f := this.Fonts

        this.Surface.Clear(0xFF000000)

        For Entity In this.Entities
            Entity.Update(this,Duration)

        For Entity In this.Entities
            Entity.Draw(this)

        this.Viewport.Refresh()
    }

    Start(DurationLimit = 0.05)
    {
        this.Running := True
        this.Initialize()

        ;amount of time each iteration should take in milliseconds
        FrameDelay := 1000 / this.FrameRate

        TickFrequency := 0
        If !DllCall("QueryPerformanceFrequency","Int64*",TickFrequency) ;obtain ticks per second
            throw Exception("Could not obtain performance counter frequency.")
        PreviousTicks := 0
        If !DllCall("QueryPerformanceCounter","Int64*",PreviousTicks) ;obtain the performance counter value
            throw Exception("Could not obtain performance counter value.")
        CurrentTicks := 0, ElapsedTime := 0
        While, this.Running
        {
            ;calculate the total time elapsed since the last iteration
            If !DllCall("QueryPerformanceCounter","Int64*",CurrentTicks)
                throw Exception("Could not obtain performance counter value.")
            Duration := (CurrentTicks - PreviousTicks) / TickFrequency
            PreviousTicks := CurrentTicks

            ;clamp duration to upper limit
            If (Duration > DurationLimit)
                Duration := DurationLimit

            ;run game update
            this.Update(Duration)

            ;calculate the time elapsed during stepping in milliseconds
            If !DllCall("QueryPerformanceCounter","Int64*",ElapsedTime)
                throw Exception("Could not obtain performance counter value.")
            ElapsedTime := ((ElapsedTime - CurrentTicks) / TickFrequency) * 1000

            ;limit framerate to desired value
            RemainingTime := Round(FrameDelay - ElapsedTime)
            If RemainingTime > 0
                Sleep, RemainingTime
        }
        Return, this
    }

    Stop()
    {
        this.Running := False
        Return, this
    }

    Register(Entity)
    {
        this.Entities[Entity] := True
        Return, this
    }

    Unregister(Entity)
    {
        this.Entities.Remove(Entity)
        Return, this
    }

    class Entity
    {
        __New(X,Y)
        {
            this.X := X
            this.Y := Y
            this.MoveSpeed := 200
        }

        Update(Engine,Duration)
        {
            ;handle input
            Movement := Duration * this.MoveSpeed
            If GetKeyState("Left","P") && this.X > Movement + 25
                this.X -= Movement
            If GetKeyState("Right","P") && this.X < Engine.Width - 25 - Movement
                this.X += Movement
            If GetKeyState("Up","P") && this.Y > Movement + 25
                this.Y -= Movement
            If GetKeyState("Down","P") && this.Y < Engine.Height - 25 - Movement
                this.Y += Movement
        }

        Draw(Engine)
        {
            b := Engine.Brushes
            s := Engine.Surface

            s.FillEllipse(b.White,this.X - 25,this.Y - 25,50,50)
        }
    }

    OnClose()
    {
        ExitApp
    }

    OnResize(Width,Height)
    {
        this.Width := Width
        this.Height := Height
        ;OldSurface := this.Surface
        ;this.Surface := new Canvas.Surface(Width,Height)
        ;this.Viewport.Attach(this.Surface)
        ;wip: copy surface contents and settings, possibly need to add a Surface.Resize() method
    }

    OnDropFiles(X,Y,Files)
    {
        Result := ""
        For Index, File In Files
            Result .= "`n" . File
        MsgBox The following files were dropped at %X%`, %Y%:`n%Result%
    }
}

__SundanceClose:
__SundanceInstance := Object(Sundance.GuiMap[A_Gui])
__SundanceInstance.OnClose()
__SundanceInstance := ""
Return

__SundanceSize:
__SundanceInstance := Object(Sundance.GuiMap[A_Gui])
__SundanceInstance.OnResize(A_GuiWidth,A_GuiHeight)
__SundanceInstance := ""
Return

__SundanceDropFiles:
__SundanceInstance := Object(Sundance.GuiMap[A_Gui])
__SundanceFileList := []
Loop, Parse, A_GuiEvent, `n
    __SundanceFileList[A_Index] := A_LoopField
__SundanceInstance.OnDrop(A_GuiX,A_GuiY,__SundanceFileList)
__SundanceInstance := ""
Return

__SundanceStart:
