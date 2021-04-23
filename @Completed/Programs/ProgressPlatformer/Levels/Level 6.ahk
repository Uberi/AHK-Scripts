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

MessageScreen(Game,"Level 6","Downstairs")

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
        Entities.Insert(new GameEntities.Block(3,1,6,0.2))
        Entities.Insert(new GameEntities.Block(3,1.2,0.2,1.8))
        Entities.Insert(new GameEntities.Block(3,3,2,0.2))
        Entities.Insert(new GameEntities.Block(8.8,1.2,0.2,2.4))

        Entities.Insert(new GameEntities.Block(4.5,3.1,0.5,1.4))
        Entities.Insert(new GameEntities.Block(6,3.5,3.5,0.2))
        Entities.Insert(new GameEntities.Block(4,3.8,0.5,1.7))
        Entities.Insert(new GameEntities.Block(4.5,5,0.5,0.5))
        Entities.Insert(new GameEntities.Block(5,5,0.5,1.5))

        Entities.Insert(new GameEntities.Block(7.3,3.6,0.2,6.4))
        Entities.Insert(new GameEntities.Block(9.3,3.6,0.2,4.4))
        Entities.Insert(new GameEntities.Block(8,4.5,0.5,4.2))
        Entities.Insert(new GameEntities.Block(4.5,6,0.5,1.5))
        Entities.Insert(new GameEntities.Block(5,7,1,0.5))
        Entities.Insert(new GameEntities.Block(5.5,7.5,0.5,0.5))
        Entities.Insert(new GameEntities.Block(5,8,1,0.5))

        Entities.Insert(new GameEntities.Block(8,8.5,2,0.2))
        Entities.Insert(new GameEntities.Block(3.5,10,5.5,0.2))
        Entities.Insert(new GameEntities.Block(9.5,9.5,0.3,0.2)) ; bottom right corner block

        Entities.Insert(new GameEntities.Enemy(4,3.5,0.333,0.444,0,0))
        Entities.Insert(new GameEntities.Enemy(4.5,5.5,0.333,0.444,0,0))
        Entities.Insert(new GameEntities.Enemy(5,7.5,0.333,0.444,0,0))
        Entities.Insert(new GameEntities.Enemy(3.5,2,0.333,0.444,0,0))
        Entities.Insert(new GameEntities.Enemy(4.5,4.5,0.333,0.444,0,0))
        Entities.Insert(new GameEntities.Enemy(5,6.5,0.333,0.444,0,0))
        Entities.Insert(new GameEntities.Enemy(5,1,0.333,0.444,0,0))
        Entities.Insert(new GameEntities.Enemy(8,4,0.333,0.444,0,0))
        Entities.Insert(new GameEntities.Enemy(4,9.5,0.333,0.444,0,0))
        Entities.Insert(new GameEntities.Goal(8,4,0.5,0.8))
        Entities.Insert(new GameEntities.Player(7,3,0.333,0.444,0,0))
        
        Game.Layers[3].Entities.Insert(new GameEntities.HealthBar(Game.Layers[2]))
    }
    Result := Game.Start()
    StartLevel := 1
    If Result = 1 ;reached goal
        Break
    Else If Result = 4 ;game paused
        MessageScreen(Game,"- You have to be -","Press space to resume"), StartLevel := 0
    Else
        LayerX := Game.Layers[2].X, LayerY := Game.Layers[2].Y
/*
Enemy	- You have to be -	Frustrated
Bound	- You have to be -	Really Unfourtunate
*/
}
Game.Layers := []