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

MessageScreen(Game,"Level 5","I know it's cheap. Deal with it.")

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
        Entities.Insert(new GameEntities.Block(1,8,9,0.2)) ;floor
        Entities.Insert(new GameEntities.Block(3.5,6.5,4,0.2)) ;middle block
        Entities.Insert(new GameEntities.Block(9,5,0.2,2)) ;top right vertical
        Entities.Insert(new GameEntities.Block(9,5,2,0.2)) ;top right horizontal
        Entities.Insert(new GameEntities.Block(2,2,5,0.2)) ;top block
        Entities.Insert(new GameEntities.Block(8,3.14,0.5,0.5)) ;stepping block
        Entities.Insert(new GameEntities.Block(2.5,3.8,1.4,0.2)) ;left top block
        Entities.Insert(new GameEntities.Block(1.2,6,1.6,0.2)) ;left bottom block
        Entities.Insert(new GameEntities.KillBlock(6,2,0.2,6)) ;kill
        Entities.Insert(new GameEntities.Enemy(3.5,5.732,0.333,0.444,0.0,0.0))
        Entities.Insert(new GameEntities.Enemy(5,7.566,0.333,0.444,0.0,0.0))
        Entities.Insert(new GameEntities.Enemy(8,2,0.333,0.444,0.0,0.0))
        Entities.Insert(new GameEntities.Enemy(5,5.732,0.333,0.444,0.0,0.0))
        Entities.Insert(new GameEntities.Goal(5,5.732,0.556,0.778))
        Entities.Insert(new GameEntities.Player(8,7.566,0.333,0.444,0.000,0.000))

        Game.Layers[3].Entities.Insert(new GameEntities.HealthBar(Game.Layers[2]))
    }
    Result := Game.Start()
    StartLevel := 1
    If Result = 1 ;reached goal
        Break
    Else If Result = 4 ;game paused
        MessageScreen(Game,"- I know -","You want to rage quit"), StartLevel := 0
    Else
        LayerX := Game.Layers[2].X, LayerY := Game.Layers[2].Y
/*
Enemy		- I know -	It's immpossible
Bound		- I know -	Your hand slipped
KillBlock	- I know -	You want to sue me
*/
}
Game.Layers := []