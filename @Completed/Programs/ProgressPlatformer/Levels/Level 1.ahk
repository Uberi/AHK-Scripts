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

MessageScreen(Game,"Level 1","May the odds be ever in your favour!")

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
        Entities.Insert(new GameEntities.Block(3.444,6.444,5.333,0.333))
        Entities.Insert(new GameEntities.Block(0.467,4.889,3.889,0.444))
        Entities.Insert(new GameEntities.Block(1.889,2.0,0.444,2.889))
        Entities.Insert(new GameEntities.Block(0.778,2.0,1.111,0.333))
        Entities.Insert(new GameEntities.Block(1.778,0.889,3.111,0.222))
        Entities.Insert(new GameEntities.Block(4.889,1.444,1.111,0.222))
        Entities.Insert(new GameEntities.Block(6.222,0.889,1.111,0.333))
        Entities.Insert(new GameEntities.Block(7.778,2.667,1.111,0.333))
        Entities.Insert(new GameEntities.Block(5.667,2.778,1.111,0.333))
        Entities.Insert(new GameEntities.Goal(5.689,2.111,0.667,0.667))
        Entities.Insert(new GameEntities.Player(8.222,4.667,0.333,0.444,0.0,0.0))
        Entities.Insert(new GameEntities.Enemy(3.667,3.889,0.333,0.444,0.0,0.0))
        Entities.Insert(new GameEntities.Enemy(3.889,5.556,0.333,0.444,0.0,0.0))
        Entities.Insert(new GameEntities.Enemy(6.111,2.000,0.333,0.444,0.0,0.0))
        Entities.Insert(new GameEntities.Enemy(5.556,0.556,0.333,0.444,0.0,0.0))

        Game.Layers[3].Entities.Insert(new GameEntities.HealthBar(Game.Layers[2]))
    }
    Result := Game.Start()
    StartLevel := 1
    If Result = 1 ;reached goal
        Break
    Else If Result = 4 ;game paused
        MessageScreen(Game,"- You are experiencing -","A space-time paradox"), StartLevel := 0
    Else
        LayerX := Game.Layers[2].X, LayerY := Game.Layers[2].Y
/*
Enemy	- You are experiencing -	pair annihilation
Bounds	- You are experiencing -	What happens when you think outside the box
*/
}
Game.Layers := []