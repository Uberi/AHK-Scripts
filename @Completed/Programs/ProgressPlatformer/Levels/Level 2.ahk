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

MessageScreen(Game,"Level 2","Don't hate the game just yet. Wait a few more levels.")

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
        Entities.Insert(new GameEntities.Block(4.333,0.556,0.222,5.111))
        Entities.Insert(new GameEntities.Block(0.111,6.444,1.222,0.333))
        Entities.Insert(new GameEntities.Block(1.667,5.556,1.778,0.333))
        Entities.Insert(new GameEntities.Block(0.111,4.667,1.889,0.222))
        Entities.Insert(new GameEntities.Block(2.444,3.667,1.889,0.333))
        Entities.Insert(new GameEntities.Block(4.222,0.000,3.778,0.222))
        Entities.Insert(new GameEntities.Block(6.444,0.778,0.222,5.444))
        Entities.Insert(new GameEntities.Block(6.667,0.778,3.667,0.222))
        Entities.Insert(new GameEntities.Block(4.556,2.556,1.444,0.222))
        Entities.Insert(new GameEntities.Block(6.111,6.667,2.000,0.222))
        Entities.Insert(new GameEntities.Block(7.556,5.889,1.111,0.333))
        Entities.Insert(new GameEntities.Goal(7.778,5.000,0.667,0.889))
        Entities.Insert(new GameEntities.Player(0.222,5.556,0.333,0.444,0.000,0.000))
        Entities.Insert(new GameEntities.Enemy(0.333,3.889,0.333,0.444,0.000,0.000))
        Entities.Insert(new GameEntities.Enemy(3.778,2.778,0.333,0.444,0.000,0.000))
        Entities.Insert(new GameEntities.Enemy(4.667,1.667,0.333,0.444,0.000,0.000))
        Entities.Insert(new GameEntities.Enemy(7.000,0.222,0.333,0.444,0.000,0.000))
        Entities.Insert(new GameEntities.Enemy(8.000,5.000,0.333,0.444,0.000,0.000))

        Game.Layers[3].Entities.Insert(new GameEntities.HealthBar(Game.Layers[2]))
    }
    Result := Game.Start()
    StartLevel := 1
    If Result = 1 ;reached goal
        Break
    Else If Result = 4 ;game paused
        MessageScreen(Game,"- Don't hate -","Press space to resume"), StartLevel := 0
    Else
        LayerX := Game.Layers[2].X, LayerY := Game.Layers[2].Y
/*
Enemy	- Don't hate -		They are just doing thier job
Bounds	- Don't hate -		confined areas of play
*/
}
Game.Layers := []