#NoEnv

DetectHiddenWindows, On
OnExit, GuiClose

Gui, +LastFound
WinGet, ScriptID, ID
Gui, Show, w422 h422, Grapher

GraphX = 11
GraphY = 11
GraphW = 400
GraphH = 400
GraphCreate(ScriptID)

Values = 0,100|100,200|200,100|300,200|400,100

GraphLine(Values,5,0xFF0000)
Return

GuiEscape:
GraphClear()
Return

GuiClose:
GraphDestroy()
ExitApp

GraphCreate(WindowID)
{
 global GraphColor,GraphLineWidth,GraphXUnitPixels,GraphYUnitPixels,GraphX,GraphY,GraphW,GraphH,GraphWindowDC,GraphDC,GraphDCBitmap,GraphMemoryDC,GraphMemoryDCBitmap

 paperColor = 0xFFFFFF ;background color (white)
 axisColor = 0x000000 ;color for axes (black)
 gridColor = 0xDFDFDF ;grid color (grey)
 GraphColor = 0x0000FF ;default color for new equations (blue)
 GraphLineWidth = 3 ;width of equations' Graphs
 XScale = 1 ;scale of grid for the x plane
 YScale = 1 ;scale of grid for the y plane
 XMin = -10 ;lowest x-value shown on Graph
 YMin = -10 ;lowest y-value shown on Graph
 XMax = 10 ;highest x-value shown on Graph
 YMax = 10 ;highest y-value shown on Graph
 GraphXUnitPixels := GraphW  / (XMax - XMin) ;how many X units on the Graph each pixel corresponds to
 GraphYUnitPixels := GraphH / (YMax - YMin) ;how many Y units on the Graph each pixel corresponds to
 GraphLeftUnits := XMin * GraphXUnitPixels ;how many X units the left edge is from the origin
 GraphTopUnits  := YMax * GraphYUnitPixels ;how many Y units the top edge is from the origin

 GraphWindowDC := DllCall("GetDC","UInt",WindowID)
 If Not GraphWindowDC
  Return
 GraphDC := DllCall("CreateCompatibleDC","UInt",GraphWindowDC)
 If Not GraphDC
  Return
 GraphDCBitmap := DllCall("CreateCompatibleBitmap","UInt",GraphWindowDC,"UInt",GraphW,"UInt",GraphH)
 DllCall("SelectObject","UInt",GraphDC,"UInt",GraphDCBitmap)
 GraphMemoryDC := DllCall("CreateCompatibleDC","UInt",GraphWindowDC)
 If Not GraphMemoryDC
  Return
 GraphMemoryDCBitmap := DllCall("CreateCompatibleBitmap","UInt",GraphWindowDC,"UInt",GraphW,"UInt",GraphH)
 DllCall("SelectObject","UInt",GraphMemoryDC,"UInt",GraphMemoryDCBitmap)
 Pen := DllCall("CreatePen","UInt",0,"UInt",0,"UInt",paperColor)
 DllCall("SelectObject","UInt",GraphDC,"UInt",Pen)
 Brush := DllCall("CreateSolidBrush","UInt",paperColor)
 DllCall("SelectObject","UInt",GraphDC,"UInt",Brush)
 DllCall("Rectangle","UInt",GraphDC,"UInt",0,"UInt",0,"UInt",GraphW,"UInt",GraphH)
 DllCall("DeleteObject","UInt",Pen)
 DllCall("DeleteObject","UInt",Brush)
 Pen := DllCall("CreatePen","UInt",0,"UInt",0,"UInt",gridColor)
 DllCall("SelectObject","UInt",GraphDC,"UInt",Pen)

 ;Vertical lines
 Loop
 {
  If (A_Index >= ((XMax - XMin) / XScale))
   Break
  DllCall("MoveToEx","UInt",GraphDC,"UInt",Round(A_Index * GraphXUnitPixels * XScale),"UInt",0,"UInt",0)
  DllCall("LineTo","UInt",GraphDC,"UInt",Round(A_Index * GraphXUnitPixels * XScale),"UInt",GraphH)
 }
 ;Horizontal lines
 Loop
 {
  If (A_Index >= ( (YMax - YMin) / YScale ))
   Break
  DllCall("MoveToEx","UInt",GraphDC,"UInt",0,"UInt",Round(A_Index*GraphYUnitPixels*YScale),"UInt",0)
  DllCall("LineTo","UInt",GraphDC,"UInt",GraphW,"UInt",Round(A_Index*GraphYUnitPixels*YScale))
 }
 DllCall("DeleteObject","UInt",Pen)
 ;Axis lines
 Pen := DllCall("CreatePen","UInt",0,"UInt",0,"UInt",axisColor)
 DllCall("SelectObject","UInt",GraphDC,"UInt",Pen)
 If (XMin < 0 && XMax > 0)
 {
  DllCall("MoveToEx","UInt",GraphDC,"UInt",Round((-XMin)*GraphXUnitPixels),"UInt",0,"UInt",0)
  DllCall("LineTo","UInt",GraphDC,"UInt",Round((-XMin)*GraphXUnitPixels),"UInt",GraphH)
 }
 If (YMin < 0 && YMax > 0)
 {
  DllCall("MoveToEx","UInt",GraphDC,"UInt",0,"UInt",Round(YMax*GraphYUnitPixels),"UInt",0)
  DllCall("LineTo","UInt",GraphDC,"UInt",GraphW,"UInt",Round(YMax*GraphYUnitPixels))
 }
 DllCall("DeleteObject","UInt",Pen)

 GraphClear()
 OnMessage(0x0F,"GraphDraw")
 Return, 1
}

GraphLine(ByRef Values,size,Color = -1)
{
 local EquDC,EquDC_BM,Pen,FirstVal,GraphSpec,R,G,B

 If Color = -1
  Color = %GraphColor%

 R := Color & 0x0000FF
 G := Color & 0x00FF00
 B := Color & 0xFF0000
 R <<= 16
 B >>= 16
 Color := R | G | B
 Pen := DllCall("CreatePen","UInt",0,"UInt",size,"UInt",Color)
 DllCall("SelectObject","UInt",GraphMemoryDC,"UInt",Pen)
 Loop, Parse, Values, | ;Graph Values
 {
   StringSplit, Temp, A_LoopField, `,
   If A_Index = 1
    DllCall("MoveToEx","UInt",GraphMemoryDC,"UInt", Temp1,"UInt", Temp2,"UInt", 0)
   Else
    DllCall("LineTo","UInt",GraphMemoryDC,"UInt", Temp1,"UInt", Temp2)
 }
 DllCall("DeleteObject","UInt",Pen)
 GraphDraw()
 Return, 1
}

GraphClear()
{
 global
 DllCall("BitBlt","UInt",GraphMemoryDC,"UInt",0,"UInt",0,"UInt",GraphW,"UInt",GraphH,"UInt",GraphDC,"UInt",0,"UInt",0,"UInt",0x00CC0020)
 GraphDraw()
}

GraphDraw()
{
 global
 DllCall("BitBlt","UInt",GraphWindowDC,"UInt",GraphX,"UInt",GraphY,"UInt",GraphW,"UInt",GraphH,"UInt",GraphMemoryDC,"UInt",0,"UInt",0,"UInt",0x00CC0020)
}

GraphDestroy()
{
 global
 OnMessage(0x0F,"")
 DllCall("DeleteObject","UInt",GraphDC)
 DllCall("DeleteObject","UInt",GraphDCBitmap)
 DllCall("DeleteObject","UInt",GraphMemoryDC)
 DllCall("DeleteObject","UInt",GraphMemoryDCBitmap)
 DllCall("ReleaseDC","UInt",0,"UInt",GraphWindowDC)
 GraphDC = 
 GraphDCBitmap = 
 GraphMemoryDC = 
 GraphMemoryDCBitmap = 
 GraphWindowDC = 
 GraphX = 
 GraphY = 
 GraphW = 
 GraphH = 
 GraphColor = 
 GraphLineWidth = 
 GraphXUnitPixels = 
 GraphYUnitPixels = 
}