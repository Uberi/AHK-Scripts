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

#includeAgain Music/Yellow.ahk

Game.Layers[1] := new ProgressEngine.Layer
Game.Layers[2] := new ProgressEngine.Layer
Environment.Snow(Game.Layers[1])
Game.Layers[2].Entities.Insert(new Credits)
Game.Start()
Game.Layers := []

Notes.Stop()
Notes.Device.__Delete() ;wip

class Credits extends ProgressEntities.Container
{
    __New()
    {
        base.__New()
        this.X := 1
        this.Y := 6
        this.W := 8
        this.H := 10

        this.Layers[1] := new ProgressEngine.Layer
        Entities := this.Layers[1].Entities

        PositionY := 0
        Entities.Insert(new this.EndHeading("Game Complete",PositionY)), PositionY += 6

        Entities.Insert(new this.CreditHeading("Design",PositionY)), PositionY += 1.2
        Entities.Insert(new this.CreditMessage("Anthony Zhang",PositionY)), PositionY += 1.2
        Entities.Insert(new this.CreditMessage("Henry Lu",PositionY)), PositionY += 2.2

        Entities.Insert(new this.CreditHeading("Programming",PositionY)), PositionY += 1.2
        Entities.Insert(new this.CreditMessage("Anthony Zhang",PositionY)), PositionY += 2.2

        Entities.Insert(new this.CreditHeading("Content",PositionY)), PositionY += 1.2
        Entities.Insert(new this.CreditMessage("Henry Lu",PositionY)), PositionY += 1.2
        Entities.Insert(new this.CreditMessage("Anthony Zhang",PositionY)), PositionY += 7.2

        Entities.Insert(new this.EndHeading("Achromatic",PositionY)), PositionY += 1.2
        Entities.Insert(new this.EndMessage("Press Space to exit.",PositionY))

        this.EndY := this.Y - PositionY
    }

    Step(Delta,Layer,Viewport)
    {
        If this.Y > this.EndY
            ;this.Y -= 0.7 * Delta
            this.Y -= 1.5 * Delta
        Return, base.Step(Delta,Layer,Viewport)
    }

    Draw(hDC,Layer,Viewport)
    {
        ;iterate through each layer
        For Index, CurrentLayer In this.Layers
        {
            ;check for layer visibility
            If !CurrentLayer.Visible
                Continue

            ;iterate through each entity in the layer
            For Key, Entity In CurrentLayer.Entities
                Entity.Draw(hDC,CurrentLayer,Viewport) ;draw the entity
        }
    }

    class EndHeading extends ProgressEntities.Text
    {
        __New(Text,PositionY)
        {
            base.__New()
            this.X := 5
            this.Y := PositionY
            this.H := 1.7
            this.Color := 0x444444
            this.Weight := 100
            this.Typeface := "Georgia"
            this.Text := Text
        }
    }

    class EndMessage extends ProgressEntities.Text
    {
        __New(Text,PositionY)
        {
            base.__New()
            this.X := 5
            this.Y := PositionY
            this.H := 0.4
            this.Color := 0x666666
            this.Weight := 100
            this.Typeface := "Georgia"
            this.Text := Text
        }

        Step(Delta,Layer,Viewport)
        {
            global Game
            If GetKeyState("Space","P") && WinActive("ahk_id " . Game.hWindow)
            {
                KeyWait, Space
                Return, 1
            }
        }
    }

    class CreditHeading extends ProgressEntities.Text
    {
        __New(Text,PositionY)
        {
            base.__New()
            this.X := 5
            this.Y := PositionY
            this.H := 0.5
            this.Color := 0x666666
            this.Weight := 300
            this.Typeface := "Georgia"
            this.Text := Text
        }
    }

    class CreditMessage extends ProgressEntities.Text
    {
        __New(Text,PositionY)
        {
            base.__New()
            this.X := 5
            this.Y := PositionY
            this.H := 1.1
            this.Color := 0x444444
            this.Weight := 100
            this.Typeface := "Georgia"
            this.Text := Text
        }
    }
}