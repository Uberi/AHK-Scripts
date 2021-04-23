#NoEnv

/*
Copyright 2011 Anthony Zhang <azhang9@gmail.com>

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

MessageScreen(Game,"Level 4","The vast outdoors")

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
        Entities.Insert(new GameEntities.Block(8,7,0.778,0.222))
        Entities.Insert(new GameEntities.Block(8,5.000,2,0.222))
        Entities.Insert(new GameEntities.Block(1.778,3.000,0.222,1.111))
        Entities.Insert(new GameEntities.Block(3.222,1.778,0.222,1.000))
        Entities.Insert(new GameEntities.Goal(2.445,0.111,0.556,0.778))
        Entities.Insert(new GameEntities.Player(8,5,0.333,0.444,0.000,0.000))
        Entities.Insert(new GameEntities.Enemy(8,2,0.333,0.444,0.000,0.000))

        Entities.Insert(new TutorialText("Go left",5,8))
        Game.Layers[3].Entities.Insert(new GameEntities.HealthBar(Game.Layers[2]))
    }
    Result := Game.Start()
    StartLevel := 1
    If Result = 1 ;reached goal
        Break
    Else If Result = 4 ;game paused
        MessageScreen(Game,"- Allergic to -","Playing Achromatic"), StartLevel := 0
    Else
        LayerX := Game.Layers[2].X, LayerY := Game.Layers[2].Y
/*
 Death by enemy		- Allergic to -		Enemies
 OUt of bounds		- Allergic to -		Near-sightedness
*/
}
Game.Layers := []