#NoEnv

;http://msdn.microsoft.com/en-us/library/ms534049(v=vs.85).aspx - pen functions
;ask in the forums the best way to do animations and resize the canvas
;add a cover-flow like control
;add theming for each control
;add delay support for callbacks

/*
Needed bitmaps:
-background image/fill combined
-client frame (minimize, close), background fill, app title
-one bitmap per screen, each containing controls, etc.
*/

;/*
MetroInit(1000,500)
MetroBackground("88000000",A_ScriptDir . "\City.jpg","FFFFFFFF")
;DllCall("gdiplus\GdipGraphicsClear","UInt",MetroGraphics,"Int",0)
MetroShow()
Return

MetroDragWindowMouseIn:
ToolTip TitleBar
Return

MetroDragWindowMouseOut:
ToolTip
Return

MetroDragWindow:
PostMessage, 0xA1, 2,,, ahk_id %MetroWindow%
Return

MetroMinimizeMouseIn:
ToolTip Minimize
Return

MetroMinimizeMouseOut:
ToolTip
Return

MetroMinimize:
MetroWindowFade("Out")
WinMinimize, ahk_id %MetroWindow%
Return

MetroCloseMouseIn:
ToolTip Close
Return

MetroCloseMouseOut:
ToolTip
Return

MetroClose:
MetroWindowFade("In")
ExitApp
;*/

MetroInit(Width = "",Height = "")
{
 local Temp1
 local Temp2
 CoordMode, Mouse
 If Width = 
  Width = %A_ScreenWidth%
 If Height = 
  Height = %A_ScreenHeight%
 MetroWidth := Width, MetroHeight := Height
 MetroSize := Width | (Height << 32)
 MetroAlpha := 33488896
 MetroGDIP := DllCall("LoadLibrary","Str","gdiplus.dll")
 VarSetCapacity(Temp1,16,0), NumPut(1,Temp1,0,"Char")
 DllCall("gdiplus\GdiplusStartup","UInt*",MetroGDIPToken,"UInt",&Temp1,"UInt",0)
 OnExit, MetroCleanup
 Gui, Destroy
 Gui, -Caption +E0x80000 +LastFound +OwnDialogs
 Gui, Show, w%Width% h%Height% Hide
 WinGetPos, Temp1, Temp2
 MetroWindow := WinExist()

 VarSetCapacity(MetroTrackMouseEvent,16)
 NumPut(16,MetroTrackMouseEvent,0) ;structure size
 NumPut(2,MetroTrackMouseEvent,4) ;TME_LEAVE
 NumPut(MetroWindow,MetroTrackMouseEvent,8) ;window handle
 DllCall("TrackMouseEvent","UInt",&MetroTrackMouseEvent) ;wip

 MetroBitmap := CreateBitmap(Width,Height)
 MetroWindowDC := DllCall("CreateCompatibleDC","UInt",0)
 DllCall("gdi32\SelectObject","UInt",MetroWindowDC,"UInt",MetroBitmap)
 DllCall("gdiplus\GdipCreateFromHDC","UInt",MetroWindowDC,"UInt*",MetroGraphics)
 DllCall("gdiplus\GdipSetSmoothingMode","UInt",MetroGraphics,"Int",4)

 DllCall("gdiplus\GdipSetTextRenderingHint","UInt",MetroGraphics,"Int",4)
 FontName = Segoe UI Light

 OnMessage(0x200,"MetroMouseEvent") ;WM_MOUSEMOVE
 OnMessage(0x201,"MetroMouseEvent") ;WM_LBUTTONDOWN
 OnMessage(0x2A3,"Test") ;WM_MOUSELEAVE
}

Test()
{
 ToolTip, Left Window.,,, 2
}

MetroSetAlpha(Amount = 255)
{
 global MetroAlpha
 MetroAlpha := (Amount << 16) | 16777216
}

MetroRefresh()
{
 global MetroWindow
 global MetroWindowDC
 global MetroSize
 global MetroAlpha
 DllCall("UpdateLayeredWindow","UInt",MetroWindow,"UInt",0,"UInt",0,"Int64*",MetroSize,"UInt",MetroWindowDC,"Int64*",0,"UInt",0,"UInt*",MetroAlpha,"UInt",2)
}

MetroBackground(BackgroundColor = "88000000",BackgroundImage = "",ClientColor = "FFFFFFFF")
{
 local Temp1
 local Temp2
 local Temp3
 If BackgroundImage
 {
  If A_IsUnicode
   DllCall("gdiplus\GdipCreateBitmapFromFile","UInt",&BackgroundImage,"UInt*",Temp3)
  Else
   VarSetCapacity(Temp1,1023), DllCall("kernel32\MultiByteToWideChar","UInt",0,"UInt",0,"UInt",&BackgroundImage,"Int",-1,"UInt",&Temp1,"Int",512), DllCall("gdiplus\GdipCreateBitmapFromFile","UInt",&Temp1,"UInt*",Temp3)
  If Temp3
  {
   DllCall("gdiplus\GdipGetImageWidth","UInt",Temp3,"UInt*",Temp1)
   DllCall("gdiplus\GdipGetImageHeight","UInt",Temp3,"UInt*",Temp2)
   DllCall("gdiplus\GdipSetInterpolationMode","UInt",MetroGraphics,"Int",7)
   DllCall("gdiplus\GdipDrawImageRectRect","UInt",MetroGraphics,"UInt",Temp3,"Float",0,"Float",0,"Float",(Temp1 < MetroWidth) ? MetroWidth : Temp1,"Float",(Temp2 < MetroHeight) ? MetroHeight : Temp2,"Float",0,"Float",0,"Float",Temp1,"Float",Temp2,"Int",2,"UInt",0,"UInt",0,"UInt",0)
  }
  DllCall("DeleteObject","UInt",Temp3)
 }

 DllCall("gdiplus\GdipCreateSolidFill","Int","0x" . BackgroundColor,"UInt*",Temp1)
 DllCall("gdiplus\GdipFillRectangle","UInt",MetroGraphics,"Int",Temp1,"Float",0,"Float",0,"Float",MetroWidth,"Float",MetroHeight)
 DllCall("gdiplus\GdipDeleteBrush","UInt",Temp1)

 DllCall("gdiplus\GdipCreatePen1","Int","0x" . ClientColor,"Float",3,"Int",2,"UInt*",Temp1)
 DllCall("gdiplus\GdipDrawLine","UInt",MetroGraphics,"UInt",Temp1,"Float",MetroWidth - 60,"Float",30,"Float",MetroWidth - 40,"Float",30)
 DllCall("gdiplus\GdipDrawLine","UInt",MetroGraphics,"UInt",Temp1,"Float",MetroWidth - 30,"Float",10,"Float",MetroWidth - 10,"Float",30)
 DllCall("gdiplus\GdipDrawLine","UInt",MetroGraphics,"UInt",Temp1,"Float",MetroWidth - 30,"Float",30,"Float",MetroWidth - 10,"Float",10)
 DllCall("gdiplus\GdipDeletePen","UInt",Temp1)
 MetroRegisterRectangle("MetroMinimize",MetroWidth - 60,10,MetroWidth - 40,30)
 StringTrimLeft, MetroBoundingRects, MetroBoundingRects, 1
 MetroRegisterRectangle("MetroClose",MetroWidth - 30,10,MetroWidth - 10,30)
 MetroRegisterRectangle("MetroDragWindow",0,0,MetroWidth - 70,30)
}

MetroWindowFade(Action = "Out",Speed = 10)
{
 If Action = In
 {
  
 }
 Else If Action = Out
 {
  
 }
}

MetroShow(PosX = "",PosY = "",Activate = 1,Title = "Metro UI")
{
 global MetroTrackMouseEvent
 Gui, Show, % ((PosX <> "") ? "x" . PosX : "") . ((PosY <> "") ? " y" . PosY : "") . (Activate ? "" : " NoActivate"), %Title%
 MetroDraw()
 MetroRefresh()
}

MetroDraw()
{
 
}

GuiClose:
Gosub, MetroClose
Return

MetroCleanup:
DllCall("gdiplus\GdiplusShutdown","UInt",MetroGDIPToken)
DllCall("FreeLibrary","UInt",MetroGDIP)
ExitApp

MetroRegisterRectangle(CallBack,PosX1,PosY1,PosX2,PosY2)
{
 global MetroBoundingRects
 MetroBoundingRects .= "`n" . CallBack . "," . PosX1 . "," . PosY1 . "," . PosX2 . "," . PosY2
}

MetroMouseEvent(wParam,lParam,Msg)
{
 global MetroWindow
 global MetroBoundingRects
 static LastHoverLabel
 Critical

 WinGetPos, WinX, WinY,,, ahk_id %MetroWindow%
 MouseGetPos, PosX, PosY ;should be a way to use wParam or lParam instead of this
 PosX -= WinX, PosY -= WinY
 Loop, Parse, MetroBoundingRects, `n
 {
  StringSplit, Field, A_LoopField, `,
  If (PosX < Field2 || PosX > Field4 || PosY < Field3 || PosY > Field5)
   Continue
  If Msg = 0x200
  {
   If Field1 = %LastHoverLabel%
    Return, 0
   LastHoverLabel := Field1
   If IsLabel(LastHoverLabel . "MouseOut")
    Gosub, %LastHoverLabel%MouseOut
   If IsLabel(Field1 . "MouseIn")
    Gosub, %Field1%MouseIn
   Return, 0
  }
  If IsLabel(Field1)
   Gosub, %Field1%
  Return, 0
 }
 If IsLabel(LastHoverLabel . "MouseOut")
  Gosub, %LastHoverLabel%MouseOut
 LastHoverLabel := ""
 Return, 0
}

CreateBitmap(Width,Height,hDC = "",bpp = 32,ByRef pBits = 0)
{
 If Not hDC
  hDC := DllCall("GetDC","UInt",0), IsTemp := 1
 VarSetCapacity(BitmapInfo,40,0), NumPut(Width,BitmapInfo,4), NumPut(Height,BitmapInfo,8), NumPut(40,BitmapInfo,0), NumPut(1,BitmapInfo,12,"UShort"), NumPut(0,BitmapInfo,16), NumPut(bpp,BitmapInfo,14,"UShort")
 hBitmap := DllCall("CreateDIBSection","UInt",hDC,"UInt",&BitmapInfo,"UInt",0,"UInt*",pBits,"UInt",0,"UInt",0), IsTemp ? DllCall("ReleaseDC","UInt",0,"UInt",hDC)
 Return, hBitmap
}

InRect(PointX,PointY,Rect) ;Rect = X1,X2,Y1,Y2
{
 StringSplit, Temp, Rect, `,
 If (PointX >= Temp1 && PointX <= Temp2 && PointY >= Temp3 && PointY <= Temp4)
  Return, 1
}

;TextSize = 20,TextColor = 0xFFFFFFFF,TextFont = "Segoe UI Light"
DrawText(TextString,PosX,PosY,Width,Height,TextVerticalPos = "Top",TextWrap = 0,Styles = "")
{
 
}