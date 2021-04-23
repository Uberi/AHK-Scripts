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

MessageScreen(Game,"Level 7","Touchdown")

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

        Entities := Game.Layers[2].Entities
        Entities.Insert(new GameEntities.KillBlock(0.5,1,0.5,3))
        Entities.Insert(new GameEntities.KillBlock(3.5,1,0.5,3))
        Entities.Insert(new GameEntities.Block(10,0.5,0.444,3.5))
        Entities.Insert(new GameEntities.Block(2,3.5,0.5,0.2))
        Entities.Insert(new GameEntities.KillBlock(2,3.7,0.5,2.8))
        Entities.Insert(new GameEntities.Block(5,5,3.5,0.2))

        Entities.Insert(new GameEntities.Bounce(6,3.2,0.5,0.5,6))
        Entities.Insert(new GameEntities.Block(5,6,1,0.2))
        Entities.Insert(new GameEntities.KillBlock(6,6,2.5,0.2))

        Entities.Insert(new GameEntities.Block(5,6.2,0.2,1))
        Entities.Insert(new GameEntities.Block(4,8,0.2,2))
        Entities.Insert(new GameEntities.Block(8,8.6,1.5,0.2))
        Entities.Insert(new GameEntities.Block(0.5,10,3.7,0.2))
        Entities.Insert(new GameEntities.KillBlock(4.2,10,3.8,0.2))
        Entities.Insert(new GameEntities.Block(8.4,10,0.5,0.2))

        Entities.Insert(new GameEntities.Enemy(1,9.5,0.1,0.1,0,0))
        Entities.Insert(new GameEntities.Enemy(2,9.5,0.1,0.1,0,0))
        Entities.Insert(new GameEntities.Enemy(3,9.5,0.1,0.1,0,0))
        Entities.Insert(new GameEntities.Enemy(10,-0.2,0.45,0.6,0,0))
        Entities.Insert(new GameEntities.Goal(2,2.7,0.5,0.8))
        Entities.Insert(new GameEntities.Player(8.5,9.5,0.333,0.444,0,0))

        
        Game.Layers[3].Entities.Insert(new GameEntities.HealthBar(Game.Layers[2]))
    }
    Result := Game.Start()
    StartLevel := 1
    If Result = 1 ;reached goal
        Break
    Else If Result = 4 ;game paused
        MessageScreen(Game,"- Referee -","Time out"), StartLevel := 0
    Else
        LayerX := Game.Layers[2].X, LayerY := Game.Layers[2].Y

/*
Enemy		- Referee -	10 down
Bounds		- Referee -	out
KillBlock	- Referee -	Too bad
*/
}
Game.Layers := []