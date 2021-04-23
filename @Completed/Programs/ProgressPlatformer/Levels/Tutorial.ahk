#NoEnv

/*
Copyright 2011-2012 Anthony Zhang <azhang9@gmail.com>, Henry Lu <redacted@redacted.com>

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

#Include Music/Green.ahk

MessageScreen(Game,"Let's Play Achromatic and fail!","Press space to skip messages and pause the action")

LayerX := 0, LayerY := 0
StartLevel := 1
Loop
{
    If StartLevel
    {
        Game.Layers[1] := new ProgressEngine.Layer
        Game.Layers[2] := new ProgressEngine.Layer
        Game.Layers[3] := new ProgressEngine.Layer
        Game.Layers[1].Entities.Insert(new KeyboardController)
        Environment.Clouds(Game.Layers[1])

        Game.Layers[2].X := LayerX, Game.Layers[2].Y := LayerY
        Entities := Game.Layers[2].Entities
        Entities.Insert(new GameEntities.Block(1,9,8,0.5))
        Entities.Insert(new GameEntities.Goal(7,8.2,0.5,0.8))
        Entities.Insert(new GameEntities.Player(1.5,7,0.333,0.444,0,0))

        Entities.Insert(new TutorialText("Use the arrow keys to move, duck and jump",5,5))

    Game.Layers[3].Entities.Insert(new GameEntities.HealthBar(Game.Layers[2]))
    }
    Result := Game.Start()
    StartLevel := 1
    If Result = 1 ;reached goal
        Break
    Else If Result = 4 ;game paused
        MessageScreen(Game,"Game paused","Press space to resume"), StartLevel := 0
    Else
        LayerX := Game.Layers[2].X, LayerY := Game.Layers[2].Y
}
Game.Layers := []

LayerX := 0, LayerY := 0
StartLevel := 1
Loop
{
    If StartLevel
    {
        Game.Layers[1] := new ProgressEngine.Layer
        Game.Layers[2] := new ProgressEngine.Layer
        Game.Layers[3] := new ProgressEngine.Layer
        Game.Layers[1].Entities.Insert(new KeyboardController)
        Environment.Clouds(Game.Layers[1])

        Game.Layers[2].X := LayerX, Game.Layers[2].Y := LayerY
        Entities := Game.Layers[2].Entities
        Entities.Insert(new GameEntities.Block(1,9,4,0.5))
        Entities.Insert(new GameEntities.Block(7,9,2,0.5))
        Entities.Insert(new GameEntities.Goal(8,8.2,0.5,0.8))
        Entities.Insert(new GameEntities.Player(1.5,7,0.333,0.444,0,0))

        Entities.Insert(new GameEntities.Box(7,5,0.5,0.5,0,0))
        Entities.Insert(new GameEntities.Box(7,4.5,0.5,0.5,0,0))
        Entities.Insert(new GameEntities.Box(7,4,0.5,0.5,0,0))

        Entities.Insert(new TutorialText("Momentum is a very big part of this game"))

        Game.Layers[3].Entities.Insert(new GameEntities.HealthBar(Game.Layers[2]))
    }
    Result := Game.Start()
    StartLevel := 1
    If Result = 1 ;reached goal
        Break
    Else If Result = 4 ;game paused
        MessageScreen(Game,"Game paused","Press space to resume"), StartLevel := 0
    Else
        LayerX := Game.Layers[2].X, LayerY := Game.Layers[2].Y
}
Game.Layers := []

LayerX := 0, LayerY := 0
StartLevel := 1
Loop
{
    If StartLevel
    {
        Game.Layers[1] := new ProgressEngine.Layer
        Game.Layers[2] := new ProgressEngine.Layer
        Game.Layers[3] := new ProgressEngine.Layer
        Game.Layers[1].Entities.Insert(new KeyboardController)
        Environment.Clouds(Game.Layers[1])

        Game.Layers[2].X := LayerX, Game.Layers[2].Y := LayerY
        Entities := Game.Layers[2].Entities
        Entities.Insert(new GameEntities.Block(3,6,5,0.5))
        Entities.Insert(new GameEntities.Block(8,1,0.5,5.5))
        Entities.Insert(new GameEntities.Block(3,1,5,0.5))
        Entities.Insert(new GameEntities.Goal(5,1.5,0.5,0.8))
        Entities.Insert(new GameEntities.Player(4.5,3,0.333,0.444,0,0))

        Entities.Insert(new TutorialText("Hold a direction to stick to it.",5,5))

        Game.Layers[3].Entities.Insert(new GameEntities.HealthBar(Game.Layers[2]))
    }
    Result := Game.Start()
    StartLevel := 1
    If Result = 1 ;reached goal
        Break
    Else If Result = 4 ;game paused
        MessageScreen(Game,"Game paused","Press space to resume"), StartLevel := 0
    Else
        LayerX := Game.Layers[2].X, LayerY := Game.Layers[2].Y
}
Game.Layers := []

LayerX := 0, LayerY := 0
StartLevel := 1
Loop
{
    If StartLevel
    {
        Game.Layers[1] := new ProgressEngine.Layer
        Game.Layers[2] := new ProgressEngine.Layer
        Game.Layers[3] := new ProgressEngine.Layer
        Game.Layers[1].Entities.Insert(new KeyboardController)
        Environment.Clouds(Game.Layers[1])

        Game.Layers[2].X := LayerX, Game.Layers[2].Y := LayerY
        Entities := Game.Layers[2].Entities
        Entities.Insert(new GameEntities.Block(1,7,5,0.5))
        Entities.Insert(new GameEntities.Block(4,8,5,0.5))
        Entities.Insert(new GameEntities.Block(3,1,8,0.2))

        Entities.Insert(new GameEntities.Block(1,2,0.5,5,0,0))
        Entities.Insert(new GameEntities.Block(2,3,0.5,4,0,0))
        Entities.Insert(new GameEntities.KillBlock(3,4,0.5,3,0,0))
        Entities.Insert(new GameEntities.Block(4,5,0.5,2,0,0))
        Entities.Insert(new GameEntities.Block(5,6,0.5,1,0,0))

        Entities.Insert(new GameEntities.Enemy(4,0.2,0.333,0.444,0,0))
        Entities.Insert(new GameEntities.Goal(9,0.2,0.5,0.8))
        Entities.Insert(new GameEntities.Player(2,7.499,0.333,0.444,0,0))

        Entities.Insert(new TutorialText("A couple more things.",2,9))
        Entities.Insert(new TutorialText("Beware black.",4.1,3.6))
        Entities.Insert(new TutorialText("There may be more than one solution.",8.4,5.5))
        Entities.Insert(new TutorialText("Jump on enemies to kill them",0.6,1.8))

        Game.Layers[3].Entities.Insert(new GameEntities.HealthBar(Game.Layers[2]))
    }
    Result := Game.Start()
    StartLevel := 1
    If Result = 1 ;reached goal
        Break
    Else If Result = 4 ;game paused
        MessageScreen(Game,"Game paused","Just a bit more, until your done the tutorial"), StartLevel := 0
    Else
        LayerX := Game.Layers[2].X, LayerY := Game.Layers[2].Y
}
Game.Layers := []

Notes.Stop()
Notes.Device.__Delete() ;wip

class TutorialText extends ProgressEntities.Text
{
    __New(Text,X = 5,Y = 3.6)
    {
        base.__New()
        this.X := X
        this.Y := Y
        this.H := 0.7
        this.Color := 0x444444
        this.Weight := 100
        this.Typeface := "Georgia"
        this.Text := Text
    }
}