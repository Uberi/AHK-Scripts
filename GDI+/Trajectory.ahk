#Include <Gdip>
#SingleInstance, Force
#NoEnv
SetBatchLines, -1

If !pToken := Gdip_Startup()
{
 MsgBox, 48, gdiplus error!, Gdiplus failed to start. Please ensure you have gdiplus on your system
 ExitApp
}
OnExit, ExitSub

Width := 600, Height := 400
BallX := 100, BallY := 100

Gui, 1:-Caption +E0x80000 +LastFound +AlwaysOnTop
Gui, 1: Show
hwnd1 := WinExist()
GroupAdd, Main, ahk_id %hwnd1%
hbm := CreateDIBSection(Width,Height)
hdc := CreateCompatibleDC()
obm := SelectObject(hdc, hbm)
G := Gdip_GraphicsFromHDC(hdc)
Gdip_SetSmoothingMode(G, 4)

pPenSides := Gdip_CreatePen(0xD0AA5500,20)
pPenPath := Gdip_CreatePen(0xE000FF00,5)
pBrushBall := Gdip_BrushCreateSolid(0xFFFF0000)

/*
pBrush := Gdip_BrushCreateSolid(0xFFFF0000)
Gdip_FillEllipse(G, pBrush, 100, 50, 200, 300)
Gdip_DeleteBrush(pBrush)

pBrush := Gdip_BrushCreateSolid(0x660000ff)
Gdip_FillRectangle(G, pBrush, 250, 80, 300, 200)
Gdip_DeleteBrush(pBrush)
*/

/*
SelectObject(hdc, obm)
DeleteObject(hbm)
DeleteDC(hdc)
Gdip_DeleteGraphics(G)
*/
SetTimer, Draw, 100
Return

Draw:
Gdip_GraphicsClear(G,0xCC00AA00)
Gdip_DrawRectangle(G,pPenSides,0,0,Width,Height)

MouseGetPos, MouseX, MouseY
If (LineIntersect(10,10,Width - 10,10,BallX + 10,BallY + 10,MouseX,MouseY,PosX,PosY) || LineIntersect(10,Height - 10,Width - 10,Height - 10,BallX + 10,BallY + 10,MouseX,MouseY,PosX,PosY))
{
 Gdip_DrawLine(G,pPenPath,BallX + 10,BallY + 10,PosX,PosY)
 Gdip_DrawLine(G,pPenPath,PosX,PosY,(PosX * 2) - (BallX + 10),BallY + 10)
}
Else If (LineIntersect(10,10,10,Height - 10,BallX + 10,BallY + 10,MouseX,MouseY,PosX,PosY) || LineIntersect(Width - 10,10,Width - 10,Height - 10,BallX + 10,BallY + 10,MouseX,MouseY,PosX,PosY))
{
 Gdip_DrawLine(G,pPenPath,BallX + 10,BallY + 10,PosX,PosY)
 Gdip_DrawLine(G,pPenPath,PosX,PosY,BallX + 10,PosY + (PosY - (BallY + 10)))
}

/*
________________________
|
|         o
|.
*/

Gdip_FillEllipse(G,pBrushBall,BallX,BallY,20,20)

UpdateLayeredWindow(hwnd1, hdc, 100, 100, Width, Height)
Return

GuiClose:
ExitApp

ExitSub:
Gdip_Shutdown(pToken)
ExitApp

#IfWinActive ahk_group Main

LineIntersect(AX,AY,BX,BY,CX,CY,DX,DY,ByRef PosX,ByRef PosY)
{
 If ((AX = BX && AY = BY) || (CX = DX && CY = DY)) ;line length is 0
  Return, 0
 If ((AX = CX && AY = CY) || (BX = CX && BY = CY) || (AX = DX && AY = DY) || (BX = DX && BY = DY)) ;lines share a point
  Return, 0

 Bx -= Ax, By -= Ay, Cx -= Ax, Cy -= Ay, Dx -= Ax, Dy -= Ay ;move point A to the orgin
 DistanceAB := Sqrt((Bx ** 2) + (By ** 2)) ;length of line AB

 theCos := BX / DistanceAB, theSin := By / DistanceAB, NewX := (CX * theCos) + (CY * theSin), CY := (CY * theCos) - (CX * theSin), CX := NewX, NewX := (DX * theCos) + (DY * theSin), DY := (DY * theCos) - (DX * theSin), DX := NewX ;rotate system so point B is on positive Y axis

 If ((CY < 0 && DY < 0) || (CY >= 0 && DY >= 0)) ;lines do not cross
  Return, 0

 PosAB := DX + (((CX - DX) * DY) / (DY - CY)) ;intersection point
 PosX := AX + (PosAB * theCos), PosY := AY + (PosAB * theSin) ;apply original coordinate system to point
 If (PosAB < 0 || PosAB > DistanceAB) ;intersects outside of segment
  Return, 0
 Return, 1
}