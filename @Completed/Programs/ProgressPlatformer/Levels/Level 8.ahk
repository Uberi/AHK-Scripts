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

MessageScreen(Game,"Level 8","What comes up")

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

        Entities.Insert(new GameEntities.Block(0,9,2,6))
        Entities.Insert(new GameEntities.KillBlock(2,9,5,6))
        Entities.Insert(new GameEntities.Block(7,9,2,6))

        Entities.Insert(new GameEntities.Block(0,1,1.5,0.2))
        Entities.Insert(new GameEntities.Bounce(1.3,1.2,0.2,1,5))
        Entities.Insert(new GameEntities.Block(7.5,3,1.5,0.2))
        Entities.Insert(new GameEntities.Bounce(7.5,3.2,0.2,1,5))
        Entities.Insert(new GameEntities.Block(0,5,1.5,0.2))
        Entities.Insert(new GameEntities.Bounce(1.3,5.2,0.2,1,5))
        Entities.Insert(new GameEntities.Block(7.5,7,1.5,0.2))
        Entities.Insert(new GameEntities.Bounce(7.5,7.2,0.2,1,5))

        Entities.Insert(new GameEntities.Platform(3,0,3,0.2,3,4,0.2,0.2))
        Entities.Insert(new GameEntities.Platform(2,10,5,0.2,2,5,0.2,0.2))
        Entities.Insert(new GameEntities.Block(1,3,1,0.2))

        Entities.Insert(new GameEntities.Enemy(0.2,0.566,0.333,0.444,0,0))
        Entities.Insert(new GameEntities.Enemy(7.7,2.566,0.333,0.444,0,0))
        Entities.Insert(new GameEntities.Enemy(0.2,4.566,0.333,0.444,0,0))
        Entities.Insert(new GameEntities.Enemy(7.7,6.566,0.333,0.444,0,0)) ; on the platforms
        Entities.Insert(new GameEntities.Enemy(1.2,2.566,0.333,0.444,0,0))
        Entities.Insert(new GameEntities.Enemy(4.8,-0.444,0.333,0.444,0,0))
        Entities.Insert(new GameEntities.Enemy(4.8,9.566,0.333,0.444,0,0))

        Entities.Insert(new GameEntities.Goal(0.2,0.2,0.5,0.8))
        Entities.Insert(new GameEntities.Player(1,8.666,0.333,0.444,0,0))

        
        Game.Layers[3].Entities.Insert(new GameEntities.HealthBar(Game.Layers[2]))
    }
    Result := Game.Start()
    StartLevel := 1
    If Result = 1 ;reached goal
        Break
    Else If Result = 4 ;game paused
        MessageScreen(Game,"- Must -","float in mid air"), StartLevel := 0
    Else
        LayerX := Game.Layers[2].X, LayerY := Game.Layers[2].Y


/*
Enemy		- Must -	come down
Bound		- Must -	hate coming back down
Killblock	- Must -	be trying to commit suicide
*/
}
Game.Layers := []