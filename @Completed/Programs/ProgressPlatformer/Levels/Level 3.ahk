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

MessageScreen(Game,"Level 3","Remember: Black hurts. White is your friend.")

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
        Entities.Insert(new GameEntities.Block(0.889,5.222,0.222,1.333))
        Entities.Insert(new GameEntities.Block(0.111,6.333,0.778,0.222))
        Entities.Insert(new GameEntities.Block(0.889,5.000,6.889,0.222))
        Entities.Insert(new GameEntities.Block(8.444,3.000,0.222,1.111))
        Entities.Insert(new GameEntities.Block(7.000,1.778,0.222,1.000))
        Entities.Insert(new GameEntities.Block(2.667,0.889,6.111,0.222))
        Entities.Insert(new GameEntities.Block(3.333,1.667,0.222,0.889))
        Entities.Insert(new GameEntities.Block(3.556,2.333,1.111,0.222))
        Entities.Insert(new GameEntities.Block(4.667,1.667,0.222,0.889))
        Entities.Insert(new GameEntities.Block(1.889,0.778,0.222,1.222))
        Entities.Insert(new GameEntities.Goal(8.111,0.111,0.556,0.778))
        Entities.Insert(new GameEntities.KillBlock(8.778,0.889,0.1,0.222))
        Entities.Insert(new GameEntities.Player(0.322,5.111,0.333,0.444,0.000,0.000))
        Entities.Insert(new GameEntities.Enemy(3.889,4.444,0.333,0.444,0.000,0.000))
        Entities.Insert(new GameEntities.Enemy(6.667,4.444,0.333,0.444,0.000,0.000))
        Entities.Insert(new GameEntities.Enemy(3.778,1.667,0.333,0.444,0.000,0.000))

        Game.Layers[3].Entities.Insert(new GameEntities.HealthBar(Game.Layers[2]))
    }
    Result := Game.Start()
    StartLevel := 1
    If Result = 1 ;reached goal
        Break
    Else If Result = 4 ;game paused
        MessageScreen(Game,"- Remember -","space doesn't need to be spammed"), StartLevel := 0
    Else
        LayerX := Game.Layers[2].X, LayerY := Game.Layers[2].Y
/*
Slain by enemy		- Remember -		they aren't your friends
Out of bounds		- Remember -		to stay inside a flosting island
kill block		- Remember -		Black hurts. White is your friend.
*/
}
Game.Layers := []