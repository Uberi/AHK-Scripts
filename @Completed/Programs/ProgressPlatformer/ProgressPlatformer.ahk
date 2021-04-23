#NoEnv

/*
Copyright 2011-2012 Anthony Zhang <azhang9@gmail.com>

This file is part of ProgressPlatformer. Source code is available at <https://github.com/Uberi/ProgressPlatformer>.

ProgressPlatformer is free software: you can redistribute it and/or modify
it under the terms of the GNU Affero General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Affero General Public License for more details.

You should have received a copy of the GNU Affero General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

;wip: use exception throwing for game loop breaking
;wip: sleeping for physical entities
;wip: text size unit doesn't support containers
;wip: total asynchronocity or parallelism (tasklets)
;wip: input manager that supports keyboard and joystick and mouse input
;wip: onclick() and onhover() callbacks for ProgressEntities.Rectangle
;wip: animated and partially transparent images support
;wip: save and load progress
;wip: slow down player movespeed when in the air
;wip: entities completely outside of containers do not draw; should use screen clipping

#Include %A_ScriptDir%

#Include ProgressEngine.ahk
#Include Music.ahk
#Include Environment.ahk

#Warn All
#Warn LocalSameAsGlobal, Off

Gravity := -9.81

SetBatchLines, -1
DetectHiddenWindows, On

Gui, +Resize +MinSize300x200 +LastFound +OwnDialogs
Gui, Show, w800 h600, ProgressPlatformer

Game := new ProgressEngine(WinExist())

Game.Hue := 4, Game.Saturation := 0.0

#Include Levels/Title.ahk
#Include Levels/Tutorial.ahk

Game.Saturation := 0.1

#Include Music/Red.ahk

#Include Levels/Level 1.ahk
#Include Levels/Level 2.ahk
#Include Levels/Level 3.ahk
#Include Levels/Level 4.ahk
#Include Levels/Level 5.ahk
#Include Levels/Level 6.ahk
#Include Levels/Level 7.ahk
#Include Levels/Level 8.ahk

Notes.Stop()
Notes.Device.__Delete() ;wip

#Include Levels/End.ahk
ExitApp

GuiClose:
Try Game.__Delete() ;wip: this is related to a limitation of the reference counting mechanism in AHK (Although references in static and global variables are released automatically when the program exits, references in non-static local variables or on the expression evaluation stack are not. These references are only released if the function or expression is allowed to complete normally.). normal exiting (game complete) works fine though
Catch
{
    
}
Try Notes.Device.__Delete() ;wip: also a garbage collection issue
Catch
{
    
}
ExitApp

class KeyboardController
{
    Start(ByRef Delta,Layer,Viewport)
    {
        global Game
        If !WinActive("ahk_id " . Game.hWindow)
            Return, 4 ;paused

        If GetKeyState("Tab","P") ;slow motion
            Delta *= 0.25

        If GetKeyState("F5","P") ;level skip
        {
            KeyWait, F5
            Return, 1 ;skip level
        }

        If GetKeyState("Space","P") ;pause
        {
            KeyWait, Space
            Return, 4 ;paused
        }
    }
}

class GameEntities
{
    class HealthBar extends ProgressEntities.Rectangle
    {
        __New(Layer)
        {
            base.__New()
            this.Color := ColorTint(0x555555)
            this.X := 1
            this.Y := 9.5
            this.TotalWidth := 8
            this.W := this.TotalWidth
            this.H := 0
            For Key, Entity In Layer.Entities
            {
                If Entity.__Class = "GameEntities.Player"
                    this.Player := Entity
            }
            this.Player.Health := 100
        }

        Step(Delta,Layer,Viewport)
        {
            this.W := (Mod(this.Player.Health,100) / 100) * this.TotalWidth
            this.H := 0.08 * ((this.Player.Health // 100) + 1)

            this.Player.Health -= Delta ;subtract health over time
            If this.Player.Health <= 0
                Return, 2 ;out of health
        }
    }

    class Block extends ProgressEntities.StaticRectangle
    {
        __New(X,Y,W,H)
        {
            base.__New()
            this.X := X
            this.Y := Y
            this.W := W
            this.H := H
            this.Color := ColorTint(0x333333)
        }
    }

    class Bounce extends ProgressEntities.StaticRectangle
    {
        __New(X,Y,W,H,Speed)
        {
            base.__New()
            this.X := X
            this.Y := Y
            this.W := W
            this.H := H
            this.Color := ColorTint(0x333333)
            this.Speed := Speed
        }
    }

    class Platform extends ProgressEntities.StaticRectangle
    {
        __New(StartX,StartY,W,H,EndX,EndY,SpeedX,SpeedY)
        {
            base.__New()
            this.X := StartX
            this.Y := StartY
            this.W := W
            this.H := H
            this.X1 := StartX
            this.Y1 := StartY
            this.X2 := EndX
            this.Y2 := EndY

            this.DirectionX := 1
            this.DirectionY := 1

            this.SpeedX := SpeedX
            this.SpeedY := SpeedY
            this.Color := ColorTint(0x777777)
        }

        Step(Delta,Layer,Viewport)
        {
            ;wip: need to push player along direction of platform
            If this.X > this.X2 ;If X is at the end of the range move back
                this.DirectionX := -1
            Else If this.X < this.X1 ;And forth
                this.DirectionX := 1
            If this.Y > this.Y2
                this.DirectionY := -1
            Else If this.Y < this.Y1
                this.DirectionY := 1

            this.X += (Abs(this.X2 - this.X1) * this.SpeedX) * this.DirectionX * Delta
            this.Y += (Abs(this.Y2-this.Y1) * this.SpeedY) * this.DirectionY * Delta
        }
    }

    class Box extends ProgressEntities.DynamicRectangle
    {
        __New(X,Y,W,H,SpeedX,SpeedY)
        {
            base.__New()
            this.X := X
            this.Y := Y
            this.W := W
            this.H := H
            this.SpeedX := SpeedX
            this.SpeedY := SpeedY
            this.Color := ColorTint(0x777777)
            this.Density := 0.5
        }

        Step(Delta,Layer,Viewport)
        {
            global Gravity

            this.SpeedY += Gravity * Delta ;process gravity
            base.Step(Delta,Layer,Viewport)
        }
    }

    class Player extends ProgressEntities.DynamicRectangle
    {
        __New(X,Y,W,H,SpeedX,SpeedY)
        {
            base.__New()
            this.X := X
            this.Y := Y
            this.W := W
            this.H := H
            this.FullH := H
            this.SpeedX := SpeedX
            this.SpeedY := SpeedY
            this.Color := ColorTint(0xAFAFAF)
            this.CanClimb := 0
            this.LastContact := 0
        }

        Start(Delta,Layer,Viewport)
        {
            For Key, Entity In Layer.Entities ;wip: use NearestEntities()
            {
                If (Entity.__Class = "GameEntities.Goal" && this.Inside(Entity)) ;player is inside the goal
                    Return, 1 ;reached goal
                If Entity.__Class = "GameEntities.KillBlock" && this.Intersect(Entity) ;player collided with kill block
                    Return, 5 ;slain by kill block
            }

            Padding := 8
            If (this.X > (10 + Padding) || (this.X + this.W) < -Padding || this.Y > (10 + Padding) || (this.Y + this.H) < -Padding) ;out of bounds
                Return, 3 ;out of bounds

            base.Start(Delta,Layer,Viewport)
        }

        Step(Delta,Layer,Viewport)
        {
            global Gravity
            static FullMoveSpeed := 10
            static JumpSpeed := FullMoveSpeed * 0.3

            Left := GetKeyState("Left","P")
            Right := GetKeyState("Right","P")
            Jump := GetKeyState("Up","P")
            Crouch := GetKeyState("Down","P")

            If Crouch
            {
                this.H := this.FullH * 0.75
                MoveSpeed := FullMoveSpeed * 0.5
            }
            Else
            {
                this.H := this.FullH
                MoveSpeed := FullMoveSpeed
            }

            If Left
                this.SpeedX -= MoveSpeed * Delta ;move left
            If Right
                this.SpeedX += MoveSpeed * Delta ;move right

            If (Left || Right) && this.CanClimb ;climb
            {
                this.SpeedX *= 0.05 ;slow down player horizontal motion while wall grabbing
                If Jump
                    this.SpeedY += MoveSpeed * Delta
                If this.SpeedY > JumpSpeed
                    this.SpeedY := JumpSpeed
            }
            Else ;jump
            {
                this.SpeedY += Gravity * Delta ;process gravity
                If Jump && (A_TickCount - this.LastContact) < 500 ;jump
                    this.SpeedY += JumpSpeed, this.LastContact := 0
            }

            SpeedLimit := 8
            If this.SpeedX > SpeedLimit
                this.SpeedX := SpeedLimit
            Else If this.SpeedX < -SpeedLimit
                this.SpeedX := -SpeedLimit
            If this.SpeedY > SpeedLimit
                this.SpeedY := SpeedLimit
            Else If this.SpeedY < -SpeedLimit
                this.SpeedY := -SpeedLimit

            Weight := Delta * 2
            If Weight > 1
                Weight := 1
            Layer.X := (Layer.X * (1 - Weight)) + ((this.X + (this.W * 0.5) - 5) * Weight)
            Layer.Y := (Layer.Y * (1 - Weight)) + ((this.Y + (this.H * 0.5) - 5) * Weight)

            this.CanClimb := 0
            base.Step(Delta,Layer,Viewport)
        }

        Collide(Delta,Entity,Layer,IntersectX,IntersectY)
        {
            If Entity.__Class = "GameEntities.Enemy" ;player collided with an enemy
            {
                If Abs(IntersectY) < Abs(IntersectX) && this.Y < Entity.Y
                {
                    ;remove the enemy ;wip: not very efficient
                    For Index, LayerEntity In Layer.Entities
                    {
                        If (Entity = LayerEntity)
                        {
                            Layer.Entities.Remove(Index)
                            Break
                        }
                    }
                    this.Health += 30
                }
                Else
                    this.Health -= 150 * Delta
            }
            Else If Entity.__Class = "GameEntities.Bounce" ;player collided with bounce block
            {
                If Abs(IntersectY) > Abs(IntersectX)
                {
                    If this.Y < Entity.Y ;player above bounce block
                        this.SpeedY := Entity.Speed
                    Else ;player below bounce block
                        this.SpeedY := -Entity.Speed
                }
                Else If this.X < Entity.X ;player left of bounce block
                    this.SpeedX := -Entity.Speed
                Else ;player right of bounce block
                    this.SpeedX := Entity.Speed
            }
            Else If Entity.__Class = "GameEntities.Platform"
            {
                If Abs(IntersectX) > Abs(IntersectY) ;player collided with top or bottom
                    this.X += ((Entity.X2 - Entity.X1) * Entity.SpeedX) * Delta * Entity.DirectionX
                Else ;player collided with sides
                    this.Y += ((Entity.Y2 - Entity.Y1) * Entity.SpeedY) * Delta * Entity.DirectionY
            }
            If (Abs(IntersectX) >= Abs(IntersectY)) ;player contacted horizontal surface
                this.LastContact := A_TickCount
            Else ;player contacted vertical surface
                this.CanClimb := 1

            base.Collide(Delta,Entity,Layer,IntersectX,IntersectY)
        }
    }

    class Goal extends ProgressEntities.Rectangle ;wip: have this detect the player instead of the player detecting this
    {
        __New(X,Y,W,H)
        {
            base.__New()
            this.X := X
            this.Y := Y
            this.W := W
            this.H := H
            this.Color := ColorTint(0xFFFFFF)
        }
    }

    class KillBlock extends ProgressEntities.Rectangle
    {
        __New(X,Y,W,H)
        {
            base.__New()
            this.X := X
            this.Y := Y
            this.W := W
            this.H := H
            this.Color := ColorTint(0x000000)
        }
    }

    class Enemy extends ProgressEntities.DynamicRectangle
    {
        __New(X,Y,W,H,SpeedX,SpeedY)
        {
            base.__New()
            this.X := X
            this.Y := Y
            this.W := W
            this.H := H
            this.SpeedX := SpeedX
            this.SpeedY := SpeedY
            this.Color := ColorTint(0x777777)
        }

        Start(Delta,Layer,Viewport)
        {
            If this.IntersectY ;contacting top or bottom of a block
                this.LastContact := A_TickCount
        }

        Step(Delta,Layer,Viewport)
        {
            global Gravity
            static MoveSpeed := 8
            static JumpSpeed := MoveSpeed * 0.25

            ;move towards the player
            For Key, Entity In this.NearestEntities(Layer,4) ;find all entities within 4 units
            {
                If (Entity.__Class = "GameEntities.Player")
                {
                    If (Entity.Y - this.Y) < JumpSpeed && Abs(Entity.X - this.X) < (MoveSpeed / 2)
                    {
                        If (this.Y >= Entity.Y)
                        {
                            If this.CanClimb
                            {
                                this.SpeedY -= Gravity * Delta
                                this.SpeedY += MoveSpeed * Delta
                            }
                            Else If (A_TickCount - this.LastContact) < 500 ;jump
                                this.SpeedY += JumpSpeed, this.LastContact := 0
                        }
                        If this.X < Entity.X
                            this.SpeedX += MoveSpeed * Delta
                        Else
                            this.SpeedX -= MoveSpeed * Delta
                    }
                }
            }

            this.SpeedY += Gravity * Delta ;process gravity
            this.CanClimb := 0
            base.Step(Delta,Layer,Viewport)
        }

        Collide(Delta,Entity,Layer,IntersectX,IntersectY)
        {
            If (Abs(IntersectX) >= Abs(IntersectY))
                this.LastContact := A_TickCount
            Else
                this.CanClimb := 1
            base.Collide(Delta,Entity,Layer,IntersectX,IntersectY)
        }
    }
}

MessageScreen(ByRef Game,Title = "",Message = "")
{
    PreviousLayers := Game.Layers
    Game.Layers := []
    Game.Layers[1] := new ProgressEngine.Layer
    Entities := Game.Layers[1].Entities
    Entities.Insert(new MessageScreenEntities.Background)
    Entities.Insert(new MessageScreenEntities.Title(Title))
    Entities.Insert(new MessageScreenEntities.Message(Message))
    Game.Start()
    Game.Layers := PreviousLayers
}

class MessageScreenEntities
{
    class Background extends ProgressEntities.Rectangle
    {
        __New()
        {
            base.__New()
            this.X := 0
            this.Y := 0
            this.W := 10
            this.H := 10
            this.Color := 0x444444
        }
    }

    class Title extends ProgressEntities.Text
    {
        __New(Text)
        {
            base.__New()
            this.X := 5
            this.Y := 4.5
            this.H := 1
            this.Color := 0xD0D0D0
            this.Weight := 100
            this.Typeface := "Georgia"
            this.Text := Text
        }
    }

    class Message extends ProgressEntities.Text
    {
        __New(Text)
        {
            base.__New()
            this.X := 5
            this.Y := 5.5
            this.H := 0.4
            this.Color := 0xF5F5F5
            this.Weight := 100
            this.Typeface := "Georgia"
            this.Text := Text
        }

        Start(Delta,Layer,Viewport)
        {
            global Game
            If GetKeyState("Space","P") && WinActive("ahk_id " . Game.hWindow)
            {
                KeyWait, Space
                Return, 1
            }
        }
    }
}

ColorTint(Color)
{
    global Game
    Hue := Game.Hue, Saturation := Game.Saturation

    Red := Color >> 16, Green := (Color >> 8) & 0xFF, Blue := Color & 0xFF

    Value := (Red > Green) ? ((Red > Blue) ? Red : Blue) : ((Green > Blue) ? Green : Blue)
    Sector := Floor(Hue)
    FractionalHue := Hue - Sector
    Component1 := Round(Value * (1 - Saturation))
    Component2 := Round(Value * (1 - (Saturation * FractionalHue)))
    Component3 := Round(Value * (1 - (Saturation * (1 - FractionalHue))))

    If Sector = 0 ;zeroth sector
        Red := Value, Green := Component3, Blue := Component1
    Else If Sector = 1 ;first sector
        Red := Component2, Green := Value, Blue := Component1
    Else If Sector = 2 ;second sector
        Red := Component1, Green := Value, Blue := Component3
    Else If Sector = 3 ;third sector
        Red := Component1, Green := Component2, Blue := Value
    Else If Sector = 4 ;fourth sector
        Red := Component3, Green := Component1, Blue := Value
    Else ;If Sector = 5 ;fifth sector
        Red := Value, Green := Component1, Blue := Component2

    Return, (Red << 16) | (Green << 8) | Blue
}

/*
ColorTint(Color,Hue,Saturation = 0.5)
{
    Red := Color >> 16, Green := (Color >> 8) & 0xFF, Blue := Color & 0xFF

    Value := (Red > Green) ? ((Red > Blue) ? Red : Blue) : ((Green > Blue) ? Green : Blue)
    Sector := Floor(Hue)
    FractionalHue := Hue - Sector
    Component1 := Round(Value * (1 - Saturation))
    Component2 := Round(Value * (1 - (Saturation * FractionalHue)))
    Component3 := Round(Value * (1 - (Saturation * (1 - FractionalHue))))

    If Sector = 0 ;zeroth sector
        Red := Value, Green := Component3, Blue := Component1
    Else If Sector = 1 ;first sector
        Red := Component2, Green := Value, Blue := Component1
    Else If Sector = 2 ;second sector
        Red := Component1, Green := Value, Blue := Component3
    Else If Sector = 3 ;third sector
        Red := Component1, Green := Component2, Blue := Value
    Else If Sector = 4 ;fourth sector
        Red := Component3, Green := Component1, Blue := Value
    Else ;If Sector = 5 ;fifth sector
        Red := Value, Green := Component1, Blue := Component2

    Return, (Red << 16) | (Green << 8) | Blue
}