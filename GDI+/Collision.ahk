;;;;;;;;fast mode
#SingleInstance force
#NoEnv
#Persistent
   
   CoordMode, Mouse, Relative
   Process Priority, , High
   SetBatchLines, -1

   ;;;;;;;;load dll
   RectInRegion := DllCall("GetProcAddress" ,"uint",DllCall("GetModuleHandle",str,"gdi32") ,str,"RectInRegion")
   CombineRgn := DllCall("GetProcAddress" ,"uint",DllCall("GetModuleHandle",str,"gdi32") ,str,"CombineRgn")

   ;;;;;;;;draw windows
   Gui, +LastFound -border -caption
   Gui, color, FFFFFF
   hDC := DllCall("GetDC", "uint", ID := WinExist())
   hBrush := DllCall("CreateSolidBrush", "uint", 0xAAAAAA)
   DllCall("SelectObject", "uint", hDC, "uint", hBrush )
   Gui, Show, w512 h384, Crash Test Area

   ;;;;;;;;data polygons
   CursorPp=6,0,13,3,20,0,26,7,26,15,13,22,0,15,0,7
   ListP=
   ( LTrim join`n
   35,240,136,83,155,84,166,255,109,219,115,207,146,227,136,118,54,252
   198,83,208,83,219,158,267,158,274,88,292,90,274,248,254,248,265,178,255,178,221,178,228,251,213,250
   345,82,358,85,355,144,404,101,415,119,363,168,425,236,418,246,355,183,346,251,330,252
   )

   ; a little explanaition of the vairables: capital P = polygon(s), lowercase p = point(s)
   ;;;;;;;;load polygons
   loop, parse, ListP, `n
   {
      countPp := CreatePointsBuffer(PointsP, A_LoopField) ;count of polygon points
      countP  := A_Index  ;count of polygons
      PolygonRegion%A_Index% := DllCall("CreatePolygonRgn", "uint", &PointsP, "int", countPp, "int", 1)
      DllCall("Polygon", "uint", hDC, "uint", &PointsP, "int", countPp)
   }

   TempRegion0 := DllCall("CreatePolygonRgn", "uint", &PointsP, "int", countPp, "int", 1)
   
   cntCursorPp := CreatePointsBuffer( CursorP, CursorPp )

   SetTimer, Collision, 10
return

; note that the cnt vairables coming into and returning from these functions are the count of *points* (not ints)
; and each point has two 4 byte integers
CreatePointsBuffer( ByRef buff, points, cnt = "", sep = ",;" ) {
   if (cnt = "")
      RegExReplace(points, "[" RegExReplace(sep, ".", "\$0") "]", "$0", cnt)
      , cnt := (cnt+1)//2
   VarSetCapacity(buff, cnt*8, 0)
   loop, parse, points, %sep%
      NumPut(A_LoopField, buff, A_Index*4-4, "Int")
   return cnt
}

OffsetPointsBuffer( ByRef buff, cnt, offx, offy ) {
   cnt *= 2
   while 0 < cnt--
      NumPut(NumGet(buff, cnt*4, "int") + (cnt & 1 ? offy : offx), buff, cnt*4, "int")
}

DuplicatePointsBuffer( ByRef out, ByRef in, cnt ) {
   VarSetCapacity(out, cnt*8, 0)
   DllCall( "msvcrt\memmove", "uint", &out, "uint", &in, "int", cnt*8, "Cdecl int" )
   return cnt
}

;;;;;;;;mouse capture
Collision:
   StartTime := A_TickCount
   
   IfWinNotActive, Crash Test Area
       return

   MouseGetPos, PosX, PosY
   
   cntMousePp := DuplicatePointsBuffer( MouseP, CursorP, cntCursorPp )
   ;cntMousePp := CreatePointsBuffer( MouseP, CursorPp )  ;functionally equivalent to above line, only less optimized
   OffsetPointsBuffer(MouseP, cntMousePp, PosX, PosY)
   PolygonRegionMouse := DllCall("CreatePolygonRgn", "uint", &MouseP, "int", cntMousePp, "int", 1)

   loop %countP%
   {
      current := A_Index
      message := DllCall("CombineRgn", "uint", TempRegion0, "uint", PolygonRegion%A_Index% , "uint", PolygonRegionMouse, "int", 1)
      if message <> 1  ;collision
         break
   }

   if message = 1   ; no collision
      DllCall("Polygon", "uint", hDC, "uint", &MouseP, "int", cntMousePp )

   ElapsedTime := A_TickCount - StartTime

   tooltip % (message=1 ? "no collision" : "collision on poly #" current) " - " countP "`n" ElapsedTime "ms"

   DllCall("DeleteObject", "uint", PolygonRegionMouse)
return

Escape::
   loop %countP%
      DllCall("DeleteObject", "uint", PolygonRegion%a_index%)
   DllCall("DeleteObject", "uint", TempRegion0)
exitapp