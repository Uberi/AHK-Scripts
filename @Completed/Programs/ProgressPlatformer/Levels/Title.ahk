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

#Include Music/Yellow.ahk

Game.Layers[1] := new ProgressEngine.Layer
Game.Layers[2] := new ProgressEngine.Layer
Environment.Snow(Game.Layers[1])
Game.Layers[2].Entities.Insert(new TitleHeading("Achromatic"))
Game.Layers[2].Entities.Insert(new TitleMessage("Press Space to begin"))
Game.Start()
Game.Layers := []

Notes.Stop()
Notes.Device.__Delete() ;wip

class TitleHeading extends ProgressEntities.Text
{
    __New(Text)
    {
        base.__New()
        this.X := 5
        this.Y := 5
        this.H := 2
        this.Color := 0x444444
        this.Weight := 100
        this.Typeface := "Georgia"
        this.Text := Text
    }
}

class TitleMessage extends ProgressEntities.Text
{
    __New(Text)
    {
        base.__New()
        this.X := 5
        this.Y := 6
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