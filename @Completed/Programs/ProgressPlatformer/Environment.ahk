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

class Environment ;wip: effects should use density instead of upper/lower bounds, and automatically generate or degenerate when the layer resizes
{
    Snow(ByRef Layer,FlakeMinimum = 80,FlakeMaximum = 100,Height = 0.5)
    {
        Layer.Entities.Insert(new Environment.Background)
        Random, FlakeCount, FlakeMinimum, FlakeMaximum
        Loop, %FlakeCount% ;add snowflakes
            Layer.Entities.Insert(new Environment.Snowflake(Layer))
    }

    Clouds(ByRef Layer,CloudMinimum = 6,CloudMaximum = 10)
    {
        Layer.Entities.Insert(new Environment.Background)
        Random, CloudCount, 6, 10
        Loop, %CloudCount% ;add clouds
            Layer.Entities.Insert(new Environment.Cloud(Layer))
    }

    class Background extends ProgressEntities.Rectangle
    {
        __New()
        {
            base.__New()
            this.X := 0
            this.Y := 0
            this.W := 10
            this.H := 10
            this.Color := ColorTint(0xCCCCCC)
        }
    }

    class Snowflake extends ProgressEntities.Rectangle
    {
        __New(Layer)
        {
            base.__New()
            this.Color := ColorTint(0xE8E8E8)
            Random, Temp1, 0.0, 10
            this.X := Temp1
            Random, Temp1, -10, 10
            this.Y := Temp1
            this.W := 0.2
            this.H := 0.2
            Random, Temp1, -0.3, 0.3
            this.SpeedX := Temp1
            Random, Temp1, 0.2, 0.5
            this.SpeedY := Temp1
        }

        Step(Delta,Layer,Viewport)
        {
            this.X += this.SpeedX * Delta
            this.Y += this.SpeedY * Delta
            If (this.X + this.W) < 0
                this.X := 10
            Else If this.X > 10
                this.X := -this.W
            If this.Y > 10
                this.Y := -this.H
        }
    }

    class Cloud extends ProgressEntities.Rectangle
    {
        __New(Layer)
        {
            base.__New()
            this.Color := ColorTint(0xE8E8E8)
            Random, Temp1, 0.0, 10.0
            this.X := Temp1
            Random, Temp1, 0.0, 10.0
            this.Y := Temp1
            Random, Temp1, 1.0, 2.5
            this.W := Temp1
            Random, Temp1, 0.5, 1.2
            this.H := Temp1
            Random, Temp1, 0.1, 0.4
            this.SpeedX := Temp1
        }

        Step(Delta,Layer,Viewport)
        {
            global Game
            this.X += this.SpeedX * Delta
            If this.X > (Layer.X + 10)
                this.X := Layer.X - this.W
        }
    }
}