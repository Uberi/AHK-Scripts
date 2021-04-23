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

class ProgressEngine
{
    __New(hWindow)
    {
        this.Layers := []

        this.FrameRate := 60

        this.hWindow := hWindow
        this.hDC := DllCall("GetDC","UPtr",hWindow,"UPtr")
        If !this.hDC
            throw Exception("Could not obtain window device context.")

        this.hMemoryDC := DllCall("CreateCompatibleDC","UPtr",this.hDC,"UPtr")
        If !this.hMemoryDC
            throw Exception("Could not create memory device context.")

        this.hOriginalBitmap := 0
        this.hBitmap := 0

        If !DllCall("SetBkMode","UPtr",this.hMemoryDC,"Int",1) ;TRANSPARENT
            throw Exception("Could not set background mode.")
    }

    __Delete()
    {
        If this.hOriginalBitmap && !DllCall("SelectObject","UPtr",this.hMemoryDC,"UPtr",this.hOriginalBitmap,"UPtr") ;deselect the bitmap from the device context
            throw Exception("Could not deselect bitmap from memory device context.")
        If this.hBitmap && !DllCall("DeleteObject","UPtr",this.hBitmap) ;delete the bitmap
            throw Exception("Could not delete bitmap.")
        If !DllCall("DeleteObject","UPtr",this.hMemoryDC) ;delete the memory device context
            throw Exception("Could not delete memory device context.")
        If !DllCall("ReleaseDC","UPtr",this.hWindow,"UPtr",this.hDC) ;release the window device context
            throw Exception("Could not release window device context.")
    }

    Start(DeltaLimit = 0.05)
    {
        ;calculate the amount of time each iteration should take
        If this.FrameRate != 0
            FrameDelay := 1000 / this.FrameRate

        TickFrequency := 0, PreviousTicks := 0, CurrentTicks := 0, ElapsedTime := 0
        If !DllCall("QueryPerformanceFrequency","Int64*",TickFrequency) ;obtain ticks per second
            throw Exception("Could not obtain performance counter frequency.")
        If !DllCall("QueryPerformanceCounter","Int64*",PreviousTicks) ;obtain the performance counter value
            throw Exception("Could not obtain performance counter value.")
        Loop
        {
            ;calculate the total time elapsed since the last iteration
            If !DllCall("QueryPerformanceCounter","Int64*",CurrentTicks)
                throw Exception("Could not obtain performance counter value.")
            Delta := (CurrentTicks - PreviousTicks) / TickFrequency
            PreviousTicks := CurrentTicks

            ;clamp delta to the upper limit
            If (Delta > DeltaLimit)
                Delta := DeltaLimit

            Result := this.Update(Delta)
            If Result
                Return, Result

            ;calculate the time elapsed during stepping in milliseconds
            If !DllCall("QueryPerformanceCounter","Int64*",ElapsedTime)
                throw Exception("Could not obtain performance counter value.")
            ElapsedTime := ((ElapsedTime - CurrentTicks) / TickFrequency) * 1000

            ;sleep the amount of time required to limit the framerate to the desired value
            If (this.FrameRate != 0 && ElapsedTime < FrameDelay)
                Sleep, % Round(FrameDelay - ElapsedTime)
        }
    }

    class Layer
    {
        __New()
        {
            this.Visible := 1
            this.X := 0
            this.Y := 0
            this.W := 10
            this.H := 10
            this.Entities := []
        }
    }

    Update(Delta)
    {
        static Width1 := -1, Height1 := -1, Viewport := Object()
        ;obtain the dimensions of the client area
        VarSetCapacity(ClientRectangle,16)
        If !DllCall("GetClientRect","UPtr",this.hWindow,"UPtr",&ClientRectangle) ;wip: also support controls rather than just windows
            throw Exception("Could not obtain client area dimensions.")
        Width := NumGet(ClientRectangle,8,"Int"), Height := NumGet(ClientRectangle,12,"Int")

        ;update bitmap if window was resized
        If (Width != Width1 || Height != Height1)
        {
            ;deselect the old bitmap if present
            If this.hOriginalBitmap
            {
                If !DllCall("SelectObject","UPtr",this.hMemoryDC,"UPtr",this.hOriginalBitmap,"UPtr")
                    throw Exception("Could not select original bitmap into memory device context.")
            }

            ;create a new bitmap with the correct dimensions
            this.hBitmap := DllCall("CreateCompatibleBitmap","UPtr",this.hDC,"Int",Width,"Int",Height,"UPtr")
            If !this.hBitmap
                throw Exception("Could not create bitmap.")

            ;select the new bitmap into the device context
            this.hOriginalBitmap := DllCall("SelectObject","UPtr",this.hMemoryDC,"UPtr",this.hBitmap,"UPtr")
            If !this.hOriginalBitmap
                throw Exception("Could not select bitmap into memory device context.")
        }
        Width1 := Width, Height1 := Height

        ;initialize the viewport
        Viewport.ScreenX := 0, Viewport.ScreenY := 0 ;wip: change to allow controls as viewports that are not at the top left corner of the client area
        Viewport.ScreenW := Width, Viewport.ScreenH := Height

        ;iterate through each layer
        For Index, Layer In this.Layers ;step entities
        {
            ;check for layer visibility
            If !Layer.Visible ;wip: two properties: Layer.Active and Layer.Visible, as well as for entities, which determine whether to step and whether to draw, respectively
                Continue

            ;set up the viewport
            Viewport.X := Layer.X, Viewport.Y := Layer.Y
            Viewport.W := 10, Viewport.H := 10

            ProportionX := Width * (Layer.W / 100), ProportionY := Height * (Layer.H / 100)

            ;set up properties of each entity in the layer
            For Key, Entity In Layer.Entities ;wip: log(n) occlusion culling here
            {
                ;set the screen coordinates of the bounding rectangle
                Entity.ScreenX := (Entity.X - Layer.X) * ProportionX, Entity.ScreenY := (Entity.Y - Layer.Y) * ProportionY
                Entity.ScreenW := Entity.W * ProportionX, Entity.ScreenH := Entity.H * ProportionY

                ;set the coordinate transformations of the bounding rectangle
                Entity.OffsetX := 0, Entity.OffsetY := 0
                Entity.ScaleX := ProportionX, Entity.ScaleY := ProportionY
            }

            ;start each entity in the layer
            For Key, Entity In Layer.Entities ;wip: log(n) occlusion culling here
            {
                Result := Entity.Start(Delta,Layer,Viewport) ;step the entity
                If Result
                    Return, Result
            }

            ;step each entity in the layer
            For Key, Entity In Layer.Entities ;wip: log(n) occlusion culling here
            {
                Result := Entity.Step(Delta,Layer,Viewport) ;step the entity
                If Result
                    Return, Result
            }

            ;end each entity in the layer
            For Key, Entity In Layer.Entities ;wip: log(n) occlusion culling here
            {
                Result := Entity.End(Delta,Layer,Viewport) ;step the entity
                If Result
                    Return, Result
            }
        }

        ;iterate through each layer
        For Index, Layer In this.Layers
        {
            ;check for layer visibility
            If !Layer.Visible
                Continue

            ;set up the viewport
            Viewport.X := Layer.X, Viewport.Y := Layer.Y
            Viewport.W := Layer.W, Viewport.H := Layer.H

            ;iterate through each entity in the layer
            For Key, Entity In Layer.Entities ;wip: log(n) occlusion culling here
                Entity.Draw(this.hMemoryDC,Layer,Viewport) ;draw the entity
        }

        If !DllCall("BitBlt","UPtr",this.hDC,"Int",0,"Int",0,"Int",Width,"Int",Height,"UPtr",this.hMemoryDC,"Int",0,"Int",0,"UInt",0xCC0020) ;SRCCOPY
            throw Exception("Could not transfer pixel data to window device context.")
        Return, 0
    }
}

class ProgressEntities
{
    class Basis
    {
        __New()
        {
            this.X := 0
            this.Y := 0
            this.W := 10
            this.H := 10
            this.Visible := 1
            this.ScreenX := 0
            this.ScreenY := 0
            this.ScreenW := 0
            this.ScreenH := 0
        }

        Start(Delta,Layer,Viewport)
        {
            
        }

        Step(Delta,Layer,Viewport)
        {
            
        }

        End(Delta,Layer,Viewport)
        {
            
        }

        Draw(hDC,Layer,Viewport)
        {
            
        }

        NearestEntities(Layer,Distance = 2)
        {
            ;wip: use occlusion culling to return only entities within the distance
            ;wip: accept a rectangle object instead of a distance
            Return, Layer.Entities
        }

        MouseHovering(Viewport)
        {
            CoordMode, Mouse, Client
            MouseGetPos, MouseX, MouseY
            MouseX -= Viewport.ScreenX
            MouseY -= Viewport.ScreenY
            If (MouseX >= this.ScreenX && MouseX <= (this.ScreenX + this.ScreenW)
                && MouseY >= this.ScreenY && MouseY <= (this.ScreenY + this.ScreenH))
                Return, 1
            Return, 0
        }

        Intersect(Rectangle,ByRef IntersectX = "",ByRef IntersectY = "")
        {
            Left1 := this.X, Left2 := Rectangle.X
            Right1 := Left1 + this.W, Right2 := Left2 + Rectangle.W
            Top1 := this.Y, Top2 := Rectangle.Y
            Bottom1 := Top1 + this.H, Bottom2 := Top2 + Rectangle.H

            ;check for collision
            If (Right1 < Left2 || Right2 < Left1 || Bottom1 < Top2 || Bottom2 < Top1)
            {
                IntersectX := 0, IntersectY := 0
                Return, 0 ;no collision occurred
            }

            ;find width of intersection
            If (Left1 < Left2)
                IntersectX := ((Right1 < Right2) ? Right1 : Right2) - Left2
            Else
                IntersectX := Left1 - ((Right1 < Right2) ? Right1 : Right2)

            ;find height of intersection
            If (Top1 < Top2)
                IntersectY := ((Bottom1 < Bottom2) ? Bottom1 : Bottom2) - Top2
            Else
                IntersectY := Top1 - ((Bottom1 < Bottom2) ? Bottom1 : Bottom2)
            Return, 1 ;collision occurred
        }

        Inside(Rectangle)
        {
            Return, this.X >= Rectangle.X
                    && (this.X + this.W) <= (Rectangle.X + Rectangle.W)
                    && this.Y >= Rectangle.Y
                    && (this.Y + this.H) <= (Rectangle.Y + Rectangle.H)
        }
    }

    class Container extends ProgressEntities.Basis ;wip: occlusion culling for this
    {
        __New()
        {
            base.__New()
            this.Layers := []
        }

        Step(Delta,Layer,Viewport)
        {
            ;initialize the current viewport
            CurrentViewport := Object()
            CurrentViewport.ScreenX := this.ScreenX, CurrentViewport.ScreenY := this.ScreenY
            CurrentViewport.ScreenW := this.ScreenW, CurrentViewport.ScreenH := this.ScreenH

            ;iterate through each layer
            For Index, CurrentLayer In this.Layers
            {
                ;check for layer visibility
                If !CurrentLayer.Visible
                    Continue

                ;calculate viewport transformations
                ProportionX := Viewport.ScreenW / CurrentLayer.W, ProportionY := Viewport.ScreenH / CurrentLayer.H
                RatioX := this.W / CurrentLayer.W, RatioY := this.H / CurrentLayer.H
                PositionX := this.OffsetX + (this.X + (CurrentLayer.X * RatioX)) * ProportionX, PositionY := this.OffsetY + (this.Y + (CurrentLayer.Y * RatioY)) * ProportionY

                ;set up the current viewport
                CurrentViewport.X := this.X + CurrentLayer.X, CurrentViewport.Y := this.Y + CurrentLayer.Y
                CurrentViewport.W := this.W, CurrentViewport.H := this.H

                ;set up properties of each object in the layer
                For Key, Entity In CurrentLayer.Entities
                {
                    ;set the coordinate transformations of the bounding rectangle
                    Entity.OffsetX := (this.OffsetX + this.X) * ProportionX, Entity.OffsetY := (this.OffsetY + this.Y) * ProportionY
                    Entity.ScaleX := ProportionX * RatioX, Entity.ScaleY := ProportionY * RatioY

                    ;set the screen coordinates of the bounding rectangle
                    Entity.ScreenX := PositionX + (Entity.X * Entity.ScaleX), Entity.ScreenY := PositionY + (Entity.Y * Entity.ScaleY)
                    Entity.ScreenW := Entity.W * Entity.ScaleX, Entity.ScreenH := Entity.H * Entity.ScaleY
                }

                ;start each entity in the layer
                For Key, Entity In CurrentLayer.Entities ;wip: log(n) occlusion culling here
                {
                    Result := Entity.Start(Delta,CurrentLayer,CurrentViewport) ;step the entity
                    If Result
                        Return, Result
                }

                ;step each entity in the layer
                For Key, Entity In CurrentLayer.Entities ;wip: log(n) occlusion culling here
                {
                    Result := Entity.Step(Delta,CurrentLayer,CurrentViewport) ;step the entity
                    If Result
                        Return, Result
                }

                ;end each entity in the layer
                For Key, Entity In CurrentLayer.Entities ;wip: log(n) occlusion culling here
                {
                    Result := Entity.End(Delta,CurrentLayer,CurrentViewport) ;step the entity
                    If Result
                        Return, Result
                }
            }
        }

        Draw(hDC,Layer,Viewport)
        {
            ;initialize the current viewport
            CurrentViewport := Object()
            CurrentViewport.ScreenX := this.ScreenX, CurrentViewport.ScreenY := this.ScreenY
            CurrentViewport.ScreenW := this.ScreenW, CurrentViewport.ScreenH := this.ScreenH

            ;iterate through each layer
            For Index, CurrentLayer In this.Layers
            {
                ;check for layer visibility
                If !CurrentLayer.Visible
                    Continue

                ;set up current viewport
                CurrentViewport.X := this.X + CurrentLayer.X, CurrentViewport.Y := this.Y + CurrentLayer.Y
                CurrentViewport.W := this.W, CurrentViewport.H := this.H

                ;iterate through each entity in the layer
                For Key, Entity In CurrentLayer.Entities ;wip: log(n) occlusion culling here
                    Entity.Draw(hDC,CurrentLayer,CurrentViewport) ;draw the entity
            }
        }
    }

    class Rectangle extends ProgressEntities.Basis
    {
        __New()
        {
            ObjInsert(this,"",Object())
            base.__New()
            this.Color := 0xFFFFFF
            this.Physical := 0
            this.hPen := 0
            this.hBrush := 0
        }

        Draw(hDC,Layer,Viewport)
        {
            ;check for entity visibility
            If !this.Visible
                Return

            ;check for entity moving out of bounds
            If (this.ScreenX + this.ScreenW) < 0 || this.ScreenX > (Viewport.ScreenX + Viewport.ScreenW)
                || (this.ScreenY + this.ScreenH) < 0 || this.ScreenY > (Viewport.ScreenY + Viewport.ScreenH)
                Return

            ;update the color if it has changed
            If this.ColorModified
            {
                ;delete the old pen and brush if present
                If this.hPen && !DllCall("DeleteObject","UPtr",this.hPen)
                    throw Exception("Could not delete pen.")
                If this.hBrush && !DllCall("DeleteObject","UPtr",this.hBrush)
                    throw Exception("Could not delete brush.")

                ;create the pen and brush
                this.hPen := DllCall("CreatePen","Int",0,"Int",0,"UInt",this.Color,"UPtr") ;PS_SOLID
                If !this.hPen
                    throw Exception("Could not create pen.")
                this.hBrush := DllCall("CreateSolidBrush","UInt",this.Color,"UPtr")
                If !this.hBrush
                    throw Exception("Could not create brush.")

                this.ColorModified := 0 ;reset the color modified flag
            }

            ;select the pen and brush
            hOriginalPen := DllCall("SelectObject","UPtr",hDC,"UPtr",this.hPen,"UPtr")
            If !hOriginalPen
                throw Exception("Could not select pen into memory device context.")
            hOriginalBrush := DllCall("SelectObject","UPtr",hDC,"UPtr",this.hBrush,"UPtr")
            If !hOriginalBrush
                throw Exception("Could not select brush into memory device context.")

            ;draw the rectangle
            If !DllCall("Rectangle","UPtr",hDC
                ,"Int",Round(this.ScreenX)
                ,"Int",Round(this.ScreenY)
                ,"Int",Round(this.ScreenX + this.ScreenW)
                ,"Int",Round(this.ScreenY + this.ScreenH))
                throw Exception("Could not draw rectangle.")

            ;deselect the pen and brush
            If !DllCall("SelectObject","UPtr",hDC,"UPtr",hOriginalPen,"UPtr")
                throw Exception("Could not deselect pen from the memory device context.")
            If !DllCall("SelectObject","UPtr",hDC,"UPtr",hOriginalBrush,"UPtr")
                throw Exception("Could not deselect brush from the memory device context.")
        }

        __Get(Key)
        {
            If (Key != "")
                Return, this[""][Key]
        }

        __Set(Key,Value)
        {
            If (Key = "Color" && this[Key] != Value)
                this.ColorModified := 1
            ObjInsert(this[""],Key,Value)
            Return, this
        }

        __Delete()
        {
            If this.hPen && !DllCall("DeleteObject","UPtr",this.hPen)
                throw Exception("Could not delete pen.")
            If this.hBrush && !DllCall("DeleteObject","UPtr",this.hBrush)
                throw Exception("Could not delete brush.")
        }
    }

    class Image extends ProgressEntities.Basis
    {
        __New()
        {
            ObjInsert(this,"",Object())
            base.__New()
            this.Image := ""
            this.TransparentColor := 0xFFFFFF
            this.hBitmap := 0
            this.ImageModified := 1
            this.ImageW := 0
            this.ImageH := 0
            this.Physical := 0
        }

        Draw(hDC,Layer,Viewport)
        {
            ;check for entity visibility
            If !this.Visible
                Return

            ;check for entity moving out of bounds
            If (this.ScreenX + this.ScreenW) < 0 || this.ScreenX > (Viewport.ScreenX + Viewport.ScreenW)
                || (this.ScreenY + this.ScreenH) < 0 || this.ScreenY > (Viewport.ScreenY + Viewport.ScreenH)
                Return

            ;update the image if it has changed
            If this.ImageModified
            {
                ;delete the old bitmap if present
                If this.hBitmap && !DllCall("DeleteObject","UPtr",this.hBitmap)
                    throw Exception("Could not delete bitmap.")

                ;load the bitmap
                this.hBitmap := DllCall("LoadImage","UPtr",0,"Str",this.Image,"UInt",0,"Int",0,"Int",0,"UInt",0x10,"UPtr") ;IMAGE_BITMAP, LR_LOADFROMFILE
                If !this.hBitmap
                    throw Exception("Could not load bitmap.")

                ;retrieve the image dimensions
                Length := 20 + A_PtrSize, VarSetCapacity(Bitmap,Length)
                If !DllCall("GetObject","UPtr",this.hBitmap,"Int",Length,"UPtr",&Bitmap)
                    throw Exception("Could not retrieve bitmap dimensions.")
                this.ImageW := NumGet(Bitmap,4,"Int"), this.ImageH := NumGet(Bitmap,8,"Int")

                this.ImageModified := 0 ;reset image modified flag
            }

            hTempDC := DllCall("CreateCompatibleDC","UPtr",hDC,"UPtr") ;create a temporary device context
            hOriginalBitmap := DllCall("SelectObject","UPtr",hTempDC,"UPtr",this.hBitmap,"UPtr") ;select the bitmap

            ;draw the image with a color drawn as transparent
            If !DllCall("Msimg32\TransparentBlt","UPtr",hDC
                ,"Int",Round(this.ScreenX)
                ,"Int",Round(this.ScreenY)
                ,"Int",Round(this.ScreenW)
                ,"Int",Round(this.ScreenH)
                ,"UPtr",hTempDC,"Int",0,"Int",0,"Int",this.ImageW,"Int",this.ImageH,"UInt",this.TransparentColor)
                throw Exception("Could not draw bitmap.")

            If !DllCall("SelectObject","UPtr",hTempDC,"UPtr",hOriginalBitmap,"UPtr") ;deselect the bitmap
                throw Exception("Could not deselect pen from the memory device context.")
            If !DllCall("DeleteDC","UPtr",hTempDC) ;delete the temporary device context
                throw Exception("Could not delete temporary device context.")
        }

        __Get(Key)
        {
            If (Key != "")
                Return, this[""][Key]
        }

        __Set(Key,Value)
        {
            If (Key = "Image" && this[Key] != Value)
                this.ImageModified := 1
            ObjInsert(this[""],Key,Value)
            Return, this
        }

        __Delete()
        {
            If this.hPen && !DllCall("DeleteObject","UPtr",this.hBitmap)
                throw Exception("Could not delete bitmap.")
        }
    }

    class Text extends ProgressEntities.Basis
    {
        __New()
        {
            ObjInsert(this,"",Object())
            base.__New()
            this.Text := "Text"
            this.Typeface := "Verdana"
            this.Align := "Center"
            this.Weight := 500
            this.Italic := 0
            this.Underline := 0
            this.Strikeout := 0
            this.hFont := 0
            this.PreviousViewportH := -1
        }

        Draw(hDC,Layer,Viewport)
        {
            ;check for entity visibility
            If !this.Visible
                Return

            ;check for entity moving out of bounds
            If (this.ScreenX + this.ScreenW) < 0 || (this.ScreenX - this.ScreenW) > (Viewport.ScreenX + Viewport.ScreenW)
                || (this.ScreenY + this.ScreenH) < 0 || (this.ScreenY - this.ScreenH) > (Viewport.ScreenY + Viewport.ScreenH)
                Return

            ;set the text alignment
            If (this.Align = "Left")
                AlignMode := 24 ;TA_LEFT | TA_BASELINE: align text to the left and the baseline
            Else If (this.Align = "Center")
                AlignMode := 30 ;TA_CENTER | TA_BASELINE: align text to the center and the baseline
            Else If (this.Align = "Right")
                AlignMode := 26 ;TA_RIGHT | TA_BASELINE: align text to the right and the baseline
            Else
                throw Exception("Invalid text alignment: " . this.Align . ".")
            DllCall("SetTextAlign","UPtr",hDC,"UInt",AlignMode)

            ;update the font if it has changed or if the viewport size has changed
            If this.FontModified || this.PreviousViewportH != Viewport.ScreenH
            {
                this.LineHeight := this.H * (Viewport.ScreenH / 10)

                ;delete the old font if present
                If this.hFont && !DllCall("DeleteObject","UPtr",this.hFont)
                    throw Exception("Could not delete font.")

                ;create the font
                ;wip: doesn't work
                ;If this.H Is Not Number
                    ;throw Exception("Invalid font size: " . this.H . ".")
                ;If this.Weight Is Not Integer
                    ;throw Exception("Invalid font weight: " . this.Weight . ".")
                this.hFont := DllCall("CreateFont"
                    ,"Int",Round(this.LineHeight) ;height
                    ,"Int",0 ;width
                    ,"Int",0 ;angle of string (0.1 degrees)
                    ,"Int",0 ;angle of each character (0.1 degrees)
                    ,"Int",this.Weight ;font weight
                    ,"UInt",this.Italic ;font italic
                    ,"UInt",this.Underline ;font underline
                    ,"UInt",this.Strikeout ;font strikeout
                    ,"UInt",1 ;DEFAULT_CHARSET: character set
                    ,"UInt",0 ;OUT_DEFAULT_PRECIS: output precision
                    ,"UInt",0 ;CLIP_DEFAULT_PRECIS: clipping precision
                    ,"UInt",4 ;ANTIALIASED_QUALITY: output quality
                    ,"UInt",0 ;DEFAULT_PITCH | (FF_DONTCARE << 16): font pitch and family
                    ,"Str",this.Typeface ;typeface name
                    ,"UPtr")
                If !this.hFont
                    throw Exception("Could not create font.")

                this.FontModified := 0 ;reset font modified flag
                this.PreviousViewportH := Viewport.ScreenH ;reset the previous viewport width
            }

            ;set the text color
            If (DllCall("SetTextColor","UPtr",hDC,"UInt",this.Color) = 0xFFFFFFFF) ;CLR_INVALID
                throw Exception("Could not set text color.")

            ;select the font
            hOriginalFont := DllCall("SelectObject","UPtr",hDC,"UPtr",this.hFont,"UPtr")
            If !hOriginalFont
                throw Exception("Could not select font into memory device context.")

            ;draw the text
            Text := this.Text ;wip: Loop, Parse, this.Text, `n
            PositionY := this.ScreenY
            VarSetCapacity(Size,8), Width := 0, Height := 0
            Loop, Parse, Text, `n
            {
                ;draw the current line of text
                If !DllCall("TextOut","UPtr",hDC,"Int",Round(this.ScreenX),"Int",Round(PositionY),"Str",A_LoopField,"Int",StrLen(A_LoopField))
                    throw Exception("Could not draw text.")
                PositionY += this.LineHeight ;move down by the height of the line

                ;obtain the dimensions of the text
                If !DllCall("GetTextExtentPoint32","UPtr",hDC,"Str",Text,"Int",StrLen(Text),"UPtr",&Size)
                    throw Exception("Could not retrieve text dimensions.")
                Temp1 := NumGet(Size,0,"UInt"), (Temp1 > Width) ? (Width := Temp1) : ""
            }

            ;update entity dimensions
            this.W := Width / this.ScaleX
            this.ScreenW := Width
            this.ScreenH := Height

            ;deselect the font
            If !DllCall("SelectObject","UPtr",hDC,"UPtr",hOriginalFont,"UPtr")
                throw Exception("Could not deselect font from memory device context.")
        }

        __Get(Key)
        {
            If (Key != "")
                Return, this[""][Key]
        }

        __Set(Key,Value)
        {
            If ((Key = "H" || Key = "Weight" || Key = "Italic" || Key = "Underline" || Key = "Strikeout" || Key = "Typeface")
                && this[Key] != Value)
                ObjInsert(this[""],"FontModified",1)
            ObjInsert(this[""],Key,Value)
            Return, this
        }

        __Delete()
        {
            If this.hFont && !DllCall("DeleteObject","UPtr",this.hFont)
                throw Exception("Could not delete font.")
        }
    }

    class StaticRectangle extends ProgressEntities.Rectangle
    {
        __New()
        {
            base.__New()
            this.SpeedX := 0
            this.SpeedY := 0
            this.ForceX := 0
            this.ForceY := 0
            this.Density := 1
            this.Restitution := 0.7
            this.Friction := 1
            this.Physical := 1
            this.Dynamic := 0
        }
    }

    class DynamicRectangle extends ProgressEntities.StaticRectangle
    {
        __New()
        {
            base.__New()
            this.Dynamic := 1
        }

        Step(Delta,Layer,Viewport)
        {
            Friction := 0.05

            this.X += this.SpeedX * Delta, this.Y -= this.SpeedY * Delta ;process momentum

            this.IntersectX := 0, this.IntersectY := 0
            For Index, Entity In Layer.Entities ;wip: use spatial acceleration structure
            {
                If (Entity = this || !Entity.Physical) ;entity is the same as the current entity or is not physical
                    Continue
                If this.Intersect(Entity,IntersectX,IntersectY) ;entity collided with the rectangle
                {
                    Result := this.Collide(Delta,Entity,Layer,IntersectX,IntersectY) ;collision callback
                    If Result
                        Return, Result
                    IntersectX := Abs(IntersectX), IntersectY := Abs(IntersectY)
                    If (IntersectX >= IntersectY) ;collision along top or bottom side
                        this.IntersectX += IntersectX, Entity.IntersectX += IntersectX ;wip: this just gets reset back to 0 when the entity is stepped itself
                    Else
                        this.IntersectY += IntersectY, Entity.IntersectY += IntersectY
                }
            }
            If this.IntersectX ;handle collision along top or bottom side
                this.SpeedX *= (Friction * this.IntersectX) ** Delta
            If this.IntersectY ;handle collision along left or right side
                this.SpeedY *= (Friction * this.IntersectY) ** Delta
        }

        Collide(Delta,Entity,Layer,IntersectX,IntersectY)
        {
            Restitution := this.Restitution * Entity.Restitution
            CurrentMass := this.W * this.H * this.Density
            EntityMass := Entity.W * Entity.H * Entity.Density

            If (Abs(IntersectX) >= Abs(IntersectY)) ;collision along top or bottom side
            {
                If Entity.Dynamic
                {
                    Velocity := ((this.SpeedY - Entity.SpeedY) * Restitution) / ((1 / CurrentMass) + (1 / EntityMass))
                    this.SpeedY := -Velocity / CurrentMass
                    Entity.SpeedY := Velocity / EntityMass
                }
                Else
                    this.SpeedY := -(this.SpeedY - Entity.SpeedY) * Restitution
                this.Y -= IntersectY ;move the entity out of the intersection area
            }
            Else ;collision along left or right side
            {
                If Entity.Dynamic
                {
                    Velocity := ((this.SpeedX - Entity.SpeedX) * Restitution) / ((1 / CurrentMass) + (1 / EntityMass))
                    this.SpeedX := -Velocity / CurrentMass
                    Entity.SpeedX := Velocity / EntityMass
                }
                Else
                    this.SpeedX := -(this.SpeedX - Entity.SpeedX) * Restitution
                this.X -= IntersectX ;move the entity out of the intersection area
            }
        }
    }
}