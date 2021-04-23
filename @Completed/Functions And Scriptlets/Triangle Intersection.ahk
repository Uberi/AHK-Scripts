#NoEnv

;/*
Triangle1X = 100
Triangle1Y = 100
Triangle2X = 300
Triangle2Y = 100
Triangle3X = 500
Triangle3Y = 400

hModule := DllCall("LoadLibrary","Str","gdiplus.dll")
VarSetCapacity(Temp1,16,0), NumPut(1,Temp1,0,"Char")
DllCall("gdiplus\GdiplusStartup","UInt*",pToken,"UInt",&Temp1,"UInt",0)
OnExit, ExitSub
Gui, -Caption +E0x80000 +LastFound +Owner
Gui, Show, w515 h515
hWnd := WinExist()
hDC := DllCall("GetDC","UInt",0)
VarSetCapacity(Temp1,40,0), NumPut(515,Temp1,4), NumPut(515,Temp1,8), NumPut(40,Temp1,0), NumPut(1,Temp1,12,"UShort"), NumPut(0,Temp1,16), NumPut(32,Temp1,14,"UShort")
hBitmap := DllCall("CreateDIBSection","UInt",hDC,"UInt",&Temp1,"UInt",0,"UInt",0,"UInt",0,"UInt",0)
DllCall("ReleaseDC","UInt",0,"UInt",hDC)
hDC := DllCall("CreateCompatibleDC","UInt",0)
DllCall("gdi32\SelectObject","UInt",hDC,"UInt",hBitmap)
DllCall("gdiplus\GdipCreateFromHDC","UInt",hDC,"UInt*",pGraphics)
DllCall("gdiplus\GdipSetSmoothingMode","UInt",pGraphics,"Int",4)
DllCall("gdiplus\GdipCreateSolidFill","Int",0xAA7777FF,"UInt*",pBrushTriangleFill)
DllCall("gdiplus\GdipCreateSolidFill","Int",0xFFAAAAFF,"UInt*",pBrushTrianglePoint)
DllCall("gdiplus\GdipCreateSolidFill","Int",0xFFCCCCFF,"UInt*",pBrushOverlay)
DllCall("gdiplus\GdipCreatePen1","Int",0xFFAAAAFF,"Float",5,"Int",2,"UInt*",pPenTriangleOutline)
DllCall("gdiplus\GdipCreatePen1","Int",0xFFCCCCFF,"Float",5,"Int",2,"UInt*",pPenOverlay)
Shape = %Triangle1X%,%Triangle1Y%|%Triangle2X%,%Triangle2Y%|%Triangle3X%,%Triangle3Y%|%Triangle1X%,%Triangle1X%
SetTimer, Moved, 100
Gosub, Moved
OnMessage(0x201,"DragWin")
Return

Moved:
MouseGetPos, PosX, PosY
Gui, +LastFound
IfWinNotActive
 Return
If (PosX = PosX1 && PosY = PosY1)
 Return
PosX1 := PosX, PosY1 := PosY
DllCall("gdiplus\GdipGraphicsClear","UInt",pGraphics,"Int",0xFFFFFF)
If PointInTriangle(PosX,PosY,Triangle1X,Triangle1Y,Triangle2X,Triangle2Y,Triangle3X,Triangle3Y)
 Gdip_FillPolygon(pGraphics,pBrushTriangleFill,Shape)
Gdip_DrawLines(pGraphics,pPenTriangleOutline,Shape)
DllCall("gdiplus\GdipFillEllipse","UInt",pGraphics,"UInt",pBrushOverlay,"Float",Triangle1X - 7,"Float",Triangle1Y - 7,"Float",14,"Float",14)
DllCall("gdiplus\GdipDrawLine","UInt",pGraphics,"UInt",pPenOverlay,"Float",Triangle1X,"Float",Triangle1Y,"Float",PosX,"Float",PosY)
DllCall("gdiplus\GdipFillEllipse","UInt",pGraphics,"UInt",pBrushOverlay,"Float",PosX - 7,"Float",PosY - 7,"Float",14,"Float",14)
DllCall("UpdateLayeredWindow","UInt",hWnd,"UInt",0,"UInt",0,"Int64*",0x20300000203,"UInt",hDC,"Int64*",0,"UInt",0,"UInt*",0x1FF0000,"UInt",2)
Return

GuiEscape:
GuiClose:
ExitApp

ExitSub:
DllCall("gdiplus\GdiplusShutdown","UInt",pToken)
DllCall("FreeLibrary","UInt",hModule)
ExitApp

DragWin()
{
 Gui, +LastFound
 PostMessage, 0xA1, 2
}

Gdip_FillPolygon(pGraphics,pBrush,Points,FillMode = 0)
{
 StringSplit, Points, Points, |
 VarSetCapacity(PointF,8 * Points0)
 Loop, %Points0%
 {
  StringSplit, Coord, Points%A_Index%, `,
  NumPut(Coord1,PointF,8 * (A_Index - 1),"Float"), NumPut(Coord2,PointF,(8 * (A_Index - 1)) + 4,"Float")
 }
 Return, DllCall("gdiplus\GdipFillPolygon","UInt",pGraphics,"UInt",pBrush,"UInt",&PointF,"Int",Points0,"Int",FillMode)
}

Gdip_DrawLines(pGraphics,pPen,Points)
{
 StringSplit, Points, Points, |
 VarSetCapacity(PointF,8 * Points0)
 Loop, %Points0%
 {
  StringSplit, Coord, Points%A_Index%, `,
  NumPut(Coord1,PointF,8 * (A_Index - 1),"Float"), NumPut(Coord2,PointF,(8 * (A_Index - 1)) + 4,"Float")
 }
 Return, DllCall("gdiplus\GdipDrawLines","UInt",pGraphics,"UInt",pPen,"UInt",&PointF,"Int",Points0)
}
*/

PointInTriangle(PointX,PointY,X1,Y1,X2,Y2,X3,Y3)
{
 Area := (X1 * Y3) - (X1 * Y2) + (X2 * Y1) - (X2 * Y3) + (X3 * Y2) - (X3 * Y1)
 Return, ((Area * (((PointX - X1) * (Y2 - Y1)) - ((PointY - Y1) * (X2 - X1)))) >= 0) && ((Area * (((PointX - X2) * (Y3 - Y2)) - (PointY - Y2) * (X3 - X2))) >= 0) && ((Area * (((PointX - X3) * (Y1 - Y3)) - ((PointY - Y3) * (X1 - X3)))) >= 0)
}