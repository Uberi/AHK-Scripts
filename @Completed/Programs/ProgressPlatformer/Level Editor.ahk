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

#Include %A_ScriptDir%

#Include ProgressEngine.ahk
#Include Environment.ahk

#Warn All
#Warn LocalSameAsGlobal, Off

LevelBackground := "Clouds"

Gui, +Resize +LastFound +OwnDialogs
Gui, Show, w800 h600, ProgressPlatformer

Editor := new ProgressEngine(WinExist())

Editor.Hue := 0.05, Editor.Saturation := 0.1

Editor.Layers[1] := new ProgressEngine.Layer
Environment[LevelBackground](Editor.Layers[1])

Editor.Layers[2] := new ProgressEngine.Layer

Editor.Layers[3] := new ProgressEngine.Layer
Editor.Layers[3].Entities.Insert(new EditingPane(7,2,2.5,6,"Level Editor"))

Loop
{
    Result := Editor.Start()
    If Result = 1 ;save
        SaveLevel(Editor.Layers[2])
    Else If Result = 2 ;change background
    {
        Editor.Layers[1] := new ProgressEngine.Layer
        Environment[LevelBackground](Editor.Layers[1])
    }
}
ExitApp

GuiClose:
Try Editor.__Delete() ;wip: this is related to a limitation of the reference counting mechanism in AHK (Although references in static and global variables are released automatically when the program exits, references in non-static local variables or on the expression evaluation stack are not. These references are only released if the function or expression is allowed to complete normally.). normal exiting (game complete) works fine though
Catch
{
    
}
ExitApp

SaveLevel(Layer)
{
    Precision := 3
    Entities := Object()
    For Index, Entity In Layer.Entities
    {
        If Entity.__Class = "Block" || Entity.__Class = "Goal"
            Entities.Blocks .= "Entities.Insert(new GameEntities." . Entity.__Class . "("
                . Round(Entity.X,Precision) 
                . "," . Round(Entity.Y,Precision)
                . "," . Round(Entity.W,Precision)
                . "," . Round(Entity.H,Precision) . "))`n"
        Else If Entity.__Class = "Platform"
            Entities.Blocks .= "Entities.Insert(new GameEntities.Platform("
                . Round(Entity.X,Precision)
                . "," . Round(Entity.Y,Precision)
                . "," . Round(Entity.W,Precision)
                . "," . Round(Entity.H,Precision)
                . "," . Round(Entity.RangeW ? "1" : "0",Precision)
                . "," . Round(Entity.RangeW ? Entity.RangeX : Entity.RangeY,Precision)
                . "," . Round(Entity.RangeW ? Entity.RangeW : Entity.RangeH,Precision)
                . "," . Round(Entity.Speed,Precision) . "))`n"
        Else If Entity.__Class = "Box" || Entity.__Class = "Player" || Entity.__Class = "Enemy"
            Entities.Blocks .= "Entities.Insert(new GameEntities." . Entity.__Class . "("
                . Round(Entity.X,Precision)
                . "," . Round(Entity.Y,Precision)
                . "," . Round(Entity.W,Precision)
                . "," . Round(Entity.H,Precision)
                . "," . Round(Entity.SpeedX,Precision)
                . "," . Round(Entity.SpeedY,Precision) . "))`n"
    }
    Result := Entities.Blocks . Entities.Platforms . Entities.Goals . Entities.Players . Entities.Enemies

    Code = 
    (
#NoEnv

StartLevel := 1
Loop
{
    If StartLevel
    {
        Game.Layers[1] := new ProgressEngine.Layer
        Game.Layers[2] := new ProgressEngine.Layer
        Game.Layers[3] := new ProgressEngine.Layer

        Game.Layers[1].Entities.Insert(new KeyboardController)
        Environment.%LevelBackground%(Game.Layers[1])

        Entities := Game.Layers[2].Entities
        %Result%
        Game.Layers[3].Entities.Insert(new GameEntities.HealthBar(Game.Layers[2]))
    }
    Result := Game.Start()
    StartLevel := 1
    If Result = 1 ;reached goal
        Break
    If Result = 2 ;out of health
        MessageScreen(Game,"Try again","Press Space to restart the level.")
    Else If Result = 3 ;out of bounds
        MessageScreen(Game,"Out of bounds","Press Space to restart the level.")
    Else If Result = 4 ;game paused
        MessageScreen(Game,"Paused","Press Space to resume."), StartLevel := 0
}
Game.Layers := []
    )
    Return, Code
}

class EditingPane extends ProgressEntities.Container
{
    __New(X,Y,W,H,Title)
    {
        base.__New()
        this.X := X
        this.Y := Y
        this.W := W
        this.H := H

        this.Layers[1] := new ProgressEngine.Layer
        this.Layers[1].Entities.Insert(new this.Background)
        this.Layers[1].Entities.Insert(new this.Title(Title))
        this.Layers[1].Entities.Insert(new Button(0.5,1.5,9,1,"Add"))
    }

    class Background extends ProgressEntities.Rectangle
    {
        __New()
        {
            base.__New()
            this.X := 0
            this.Y := 0
            this.W := 10
            this.H := 10
            this.Color := 0x555555
        }
    }

    class Title extends ProgressEntities.Text
    {
        __New(Text)
        {
            base.__New()
            this.X := 5
            this.Y := 1
            this.W := 10
            this.H := 2
            this.Color := 0xFFFFFF
            this.Weight := 100
            this.Typeface := "Georgia"
            this.Text := Text
        }
    }
}

class Button extends ProgressEntities.Container
{
    __New(X,Y,W,H,Text)
    {
        base.__New()
        this.X := X
        this.Y := Y
        this.W := W
        this.H := H

        this.Layers[1] := new ProgressEngine.Layer
        this.Layers[1].Entities.Insert(new this.Background)
        this.Layers[1].Entities.Insert(new this.Label(Text))
    }

    class Background extends ProgressEntities.Rectangle
    {
        __New()
        {
            base.__New()
            this.X := 0
            this.Y := 0
            this.W := 10
            this.H := 10
            this.Color := 0x888888
        }

        Step(Delta,Layer,Viewport)
        {
            If GetKeyState("LButton","P") && this.MouseHovering
                ToolTip Hovering!
            Else
                ToolTip Not hovering!
        }
    }

    class Label extends ProgressEntities.Text
    {
        __New(Text)
        {
            base.__New()
            this.X := 5
            this.Y := 1
            this.W := 10
            this.H := 2
            this.Color := 0xFFFFFF
            this.Weight := 100
            this.Typeface := "Georgia"
            this.Text := Text
        }
    }
}

ColorTint(Color)
{
    global Editor
    Hue := Editor.Hue, Saturation := Editor.Saturation

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