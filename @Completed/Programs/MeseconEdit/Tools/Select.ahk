#NoEnv

class Select
{
    Select()
    {
        Return, ["Area","Extend","Connected"]
    }

    Activate(Grid) ;wip
    {
        global hMemoryDC, Width, Height, Viewport
        static hPen := DllCall("CreatePen","Int",0,"Int",2,"UInt",0x0000FF,"UPtr") ;PS_SOLID
        static hBrush := DllCall("GetStockObject","Int",5,"UPtr") ;NULL_BRUSH
        VarSetCapacity(Rectangle,16)

        IndexX := Floor(Viewport.X), IndexY := Floor(Viewport.Y)
        BlockW := Width / Viewport.W, BlockH := Height / Viewport.H
        BlockX := Mod(-Viewport.X,1) * BlockW
        If BlockX > 0
            BlockX -= BlockW
        BlockY := Mod(-Viewport.Y,1) * BlockH
        If BlockY > 0
            BlockY -= BlockH

        GetMouseCoordinates(Width,Height,StartX,StartY)
        X := BlockX + (BlockW * (StartX - IndexX))
        Y := BlockY + (BlockH * (StartY - IndexY))

        MouseX1 := ~0, MouseY1 := ~0
        While, GetKeyState("LButton","P")
        {
            GetMouseCoordinates(Width,Height,MouseX,MouseY)
            ;If (MouseX != MouseX1 || MouseY != MouseY1) ;wip
            ;{
                W := BlockW * ((MouseX + 1) - StartX)
                H := BlockH * ((MouseY + 1) - StartY)

                hOriginalPen := DllCall("SelectObject","UPtr",hMemoryDC,"UPtr",hPen,"UPtr") ;select the pen
                hOriginalBrush := DllCall("SelectObject","UPtr",hMemoryDC,"UPtr",hBrush,"UPtr") ;select the brush

                ;draw rectangle
                DllCall("Rectangle","UPtr",hMemoryDC,"Int",Round(X),"Int",Round(Y),"Int",Round(X + W),"Int",Round(Y + H))
                global hDC
                If !DllCall("BitBlt","UPtr",hDC,"Int",0,"Int",0,"Int",Width,"Int",Height,"UPtr",hMemoryDC,"Int",0,"Int",0,"UInt",0xCC0020) ;SRCCOPY
                    throw Exception("Could not transfer pixel data to window device context.")

                DllCall("SelectObject","UPtr",hMemoryDC,"UPtr",hOriginalPen,"UPtr") ;deselect the pen
                DllCall("SelectObject","UPtr",hMemoryDC,"UPtr",hOriginalBrush,"UPtr") ;deselect the brush

                MouseX1 := MouseX, MouseY1 := MouseY
            ;}
            Sleep, 1
        }
    }
}