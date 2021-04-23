#NoEnv

SetBatchLines, -1
SetMouseDelay, -1

Width := 800
Height := 600
FrameRate := 30
FullScreen := 0
AutoFly := 0
BlockCountX := 20
BlockCountY := 30

PosX := -40
PosY := -20
PosZ := 30
Speed := 0.3

Ptr := A_PtrSize ? "Ptr" : "UInt" ;set compatibility constants
Radian := 3.141592 / 180
hGDI32 := DllCall("LoadLibrary","Str","gdi32"), hOpenGL32 := DllCall("LoadLibrary","Str","opengl32") ;load libraries
OnExit, ExitSub

If FullScreen
 Gui, -Caption +AlwaysOnTop
Gui, +LastFound +Resize +MinSize150x150
hWindow := WinExist()

DllCall("ShowCursor","Int",0) ;hide the cursor

hDC := DllCall("GetDC","UInt",hWindow)
VarSetCapacity(Struct,40,0), NumPut(40,Struct,0,"UShort"), NumPut(1,Struct, 2,"UShort")
NumPut(0x25,Struct,4,"UInt") ;PFD_DRAW_TO_WINDOW | PFD_SUPPORT_OPENGL | PFD_DOUBLEBUFFER
NumPut(0,Struct,8,"UChar") ;PFD_TYPE_RGBA
NumPut(24,Struct,9,"UChar") ;Color bit depth
NumPut(16,Struct,23,"UChar") ;Depth buffer bit depth
DllCall("gdi32\SetPixelFormat","UInt",hDC,"Int",DllCall("gdi32\ChoosePixelFormat","UInt",hDC,Ptr,&Struct,"Int"),Ptr,&Struct)
hRC := DllCall("opengl32\wglCreateContext","UInt",hDC), DllCall("opengl32\wglMakeCurrent","UInt",hDC,"UInt",hRC)

;get the position of the control on screen
VarSetCapacity(ClientPoint,8,0), DllCall("ClientToScreen","UInt",hWindow,Ptr,&ClientPoint), ControlPosX := NumGet(ClientPoint), ControlPosY := NumGet(ClientPoint,4)

BackgroundRed := 0.4, BackgroundGreen := 0.4, BackgroundBlue := 0.5

DllCall("opengl32\glShadeModel","UInt",0x1D01) ;GL_SMOOTH
DllCall("opengl32\glClearColor","Float",BackgroundRed,"Float",BackgroundGreen,"Float",BackgroundBlue,"Float",0.0)
DllCall("opengl32\glClearDepth","Double",1.0)
DllCall("opengl32\glEnable","UInt",0xB71) ;GL_DEPTH_TEST
DllCall("opengl32\glDepthFunc","UInt",0x201) ;GL_LESS
DllCall("opengl32\glHint","UInt",0xC50,"UInt",0x1102) ;GL_PERSPECTIVE_CORRECTION_HINT, GL_NICEST
DllCall("opengl32\glPolygonMode","UInt",0x408,"UInt",0x1B02) ;GL_FRONT_AND_BACK, GL_FILL

DllCall("opengl32\glEnable","UInt",0xB50) ;GL_LIGHTING
VarSetCapacity(Struct,16)

DllCall("opengl32\glEnable","UInt",0x4000) ;GL_LIGHT0
VarSetCapacity(Struct,16)
NumPut(1.0,Struct,0,"Float"), NumPut(1.0,Struct,4,"Float"), NumPut(1.0,Struct,8,"Float"), NumPut(1,Struct,12,"Float") ;ambient color
DllCall("opengl32\glLightfv","UInt",0x4000,"UInt",0x1200,Ptr,&Struct) ;GL_LIGHT0, GL_AMBIENT
NumPut(BackgroundRed,Struct,0,"Float"), NumPut(BackgroundGreen,Struct,4,"Float"), NumPut(BackgroundBlue,Struct,8,"Float"), NumPut(1,Struct,12,"Float")
DllCall("opengl32\glLightfv","UInt",0x4000,"UInt",0x1201,Ptr,&Struct) ;GL_LIGHT0, GL_DIFFUSE

DllCall("opengl32\glLightf","UInt",0x4000,"UInt",0x1208,"Float",0.003) ;GL_LIGHT0, GL_LINEAR_ATTENUATION
NumPut(20,Struct,0,"Float"), NumPut(10,Struct,4,"Float"), NumPut(10,Struct,8,"Float"), NumPut(1,Struct,12,"Float") ;positional light at 20,10,10

DllCall("opengl32\glEnable","UInt",0xB60) ;GL_FOG
DllCall("opengl32\glFogi","UInt",0xB65,"UInt",0x800) ;GL_FOG_MODE, GL_LINEAR
NumPut(BackgroundRed,Struct,0,"Float"), NumPut(BackgroundGreen,Struct,4,"Float"), NumPut(BackgroundBlue,Struct,8,"Float"), NumPut(1,Struct,12,"Float") ;fog color
DllCall("opengl32\glFogfv","UInt",0xB66,Ptr,&Struct) ;GL_FOG_COLOR
DllCall("opengl32\glFogf","UInt",0xB62,"Float",0.03) ;GL_FOG_DENSITY
DllCall("opengl32\glHint","UInt",0xC54,"UInt",0x1102) ;GL_FOG_HINT, GL_NICEST
DllCall("opengl32\glFogf","UInt",0xB63,"Float",10.0) ;GL_FOG_START
DllCall("opengl32\glFogf","UInt",0xB64,"Float",100.0) ;GL_FOG_END

DllCall("opengl32\glEnable","UInt",0xDE1) ;GL_TEXTURE_2D

IfNotExist, %A_ScriptDir%\Building.png
 URLDownloadToFile, http://www.autohotkey.net/~Uberi/Scripts/Procedural`%20City/Building.png, %A_ScriptDir%\Building.png
BuildingTexture := LoadTexture(A_ScriptDir . "\Building.png","Nearest")

City := CreateCity(0,0,0,4,2.5,3,BlockCountX,BlockCountY,7)

If FullScreen
 Gui, Show, Maximize, Procedural City
Else
 Gui, Show, w%Width% h%Height%, Procedural City

;move cursor to center of the window
MouseGetPos, TempX, TempY
TempX -= ControlPosX, TempY -= ControlPosY
MouseMove, 0 - (TempX - (Width / 2)), 0 - (TempY - (Height / 2)), 0, R

FrameRate := 1000 / FrameRate
If AutoFly
{
 NavigationIndex := 3.141592 / 2
 Loop
 {
  TempTime := A_TickCount
  PosX += (Sin(NavigationIndex) * Speed) / 2
  PosZ += (Cos(NavigationIndex) * Speed) / 2
  NavigationIndex += Speed / 20
  RotX  += 0.2
  Draw()
  Sleep, % FrameRate - (A_TickCount - TempTime) ;conpensate for lag
 }
 Return
}
Loop
{
 TempTime := A_TickCount
 GetMouseMovement(RotX,RotY), RotX *= 120, RotY *= 120
 If GetKeyState("W")
  PosX -= Sin(RotX * Radian) * Speed, PosY += Sin(RotY * Radian) * Speed, PosZ += Cos(RotX * Radian) * Speed
 If GetKeyState("S")
  PosX += Sin(RotX * Radian) * Speed, PosY -= Sin(RotY * Radian) * Speed, PosZ -= Cos(RotX * Radian) * Speed
 If GetKeyState("A")
  PosX += Cos(RotX * Radian) * Speed, PosZ += Sin(RotX * Radian) * Speed
 If GetKeyState("D")
  PosX -= Cos(RotX * Radian) * Speed, PosZ -= Sin(RotX * Radian) * Speed
 If GetKeyState("Q")
  PosY += Speed
 If GetKeyState("E")
  PosY -= Speed
 ;ToolTip "%PosX%" "%PosY%" "%PosZ%" "%RotX%" "%RotY%"
 Draw()
 Sleep, % FrameRate - (A_TickCount - TempTime) ;conpensate for lag
}
Return

GuiEscape:
GuiClose:
ExitApp

GuiSize:
Width := A_GuiWidth ? A_GuiWidth : 1, Height := A_GuiHeight ? A_GuiHeight : 1
ResizeScene(0,0,Width,Height,55.0,0.5,200)
Return

ExitSub:
DllCall("opengl32\glDeleteLists","UInt",City,"Int",1) ;delete geometry
DllCall("opengl32\glDeleteTextures","Int",1,"UInt",BuildingTexture) ;delete texture
DllCall("opengl32\wglMakeCurrent","UInt",0,"UInt",0)
DllCall("opengl32\wglDeleteContext","UInt",hRC)
DllCall("ShowCursor","Int",1) ;show the cursor
ExitApp

Draw()
{
 global hDC, City, RotX, RotY, PosX, PosY, PosZ, Struct, Ptr, BuildingTexture
 DllCall("opengl32\glClear","UInt",0x4100) ;GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT
 DllCall("opengl32\glLoadIdentity") ;load identity matrix

 DllCall("opengl32\glRotatef","Float",RotY,"Float",1.0,"Float",0.0,"Float",0.0)
 DllCall("opengl32\glRotatef","Float",RotX,"Float",0.0,"Float",1.0,"Float",0.0)

 DllCall("opengl32\glTranslatef","Float",PosX,"Float",PosY,"Float",PosZ)

 DllCall("opengl32\glLightfv","UInt",0x4000,"UInt",0x1203,Ptr,&Struct) ;GL_LIGHT0, GL_POSITION

 DllCall("opengl32\glBindTexture","UInt",0xDE1,"UInt",BuildingTexture) ;GL_TEXTURE_2D
 DllCall("opengl32\glCallList","UInt",City) ;draw city

 DllCall("gdi32\SwapBuffers","UInt",hDC)
}

GetMouseMovement(ByRef PosX = "",ByRef PosY = "")
{
 global ControlPosX, ControlPosY, Width, Height, hWindow
 static AbsoluteX := 0, AbsoluteY := 0, PosX1, PosY1
 IfWinNotActive, ahk_id %hWindow%
 {
  PosX := PosX1, PosY := PosY1
  Return
 }
 MouseGetPos, PosX, PosY
 PosX -= ControlPosX, PosY -= ControlPosY, PosX1 := PosX, PosY1 := PosY
 MouseMove, 0 - (PosX - (Width / 2)), 0 - (PosY - (Height / 2)), 0, R
 AbsoluteX += (PosX / Width) - 0.5, AbsoluteY += (PosY / Height) - 0.5
 PosX := AbsoluteX, PosY := AbsoluteY
}

ResizeScene(PosX,PosY,Width,Height,FieldOfView = 45.0,ClipNear = 0.5,ClipFar = 100.0)
{
 DllCall("opengl32\glViewport","Int",PosX,"Int",PosY,"Int",Width,"Int",Height)
 DllCall("opengl32\glMatrixMode","UInt",0x1701) ;GL_PROJECTION
 DllCall("opengl32\glLoadIdentity")
 MaxY := ClipNear * Tan(FieldOfView * 0.00872664626), MaxX := MaxY * (Width / Height), DllCall("opengl32\glFrustum","Double",0 - MaxX,"Double",MaxX,"Double",0 - MaxY,"Double",MaxY,"Double",ClipNear,"Double",ClipFar)
 DllCall("opengl32\glMatrixMode","UInt",0x1700) ;GL_MODELVIEW
}

LoadTexture(Filename,Filter = "Linear")
{
 hGDIP := DllCall("LoadLibrary","Str","gdiplus")
 VarSetCapacity(Temp1,16,0), NumPut(1,Temp1), DllCall("gdiplus\GdiplusStartup","UInt*",pToken,"UInt",&Temp1,"UInt",0)
 If A_IsUnicode
  DllCall("gdiplus\GdipCreateBitmapFromFile","UInt",&Filename,"UInt*",pBitmap)
 Else
  FilenameLength := DllCall("MultiByteToWideChar","UInt",0,"UInt",0,"UInt",&Filename,"Int",-1,"UInt",0,"Int",0) << 1, VarSetCapacity(wFilename,FilenameLength,0), DllCall("MultiByteToWideChar","UInt",0,"UInt",0,"UInt",&Filename,"Int",-1,"UInt",&wFilename,"UInt",FilenameLength), DllCall("gdiplus\GdipCreateBitmapFromFile","UInt",&wFilename,"UInt*",pBitmap)
 DllCall("gdiplus\GdipCreateHBITMAPFromBitmap","UInt",pBitmap,"UInt*",hBitmap,"UInt",0xFF000000)
 DllCall("gdiplus\GdipDisposeImage","UInt",pBitmap)
 DllCall("gdiplus\GdiplusShutdown","UInt",pToken)
 DllCall("FreeLibrary","UInt",hGDIP)
 If Not hBitmap
  Return, 0
 VarSetCapacity(BitmapInfo,24,0), DllCall("GetObject","UInt",hBitmap,"UInt",24,"UInt",&BitmapInfo), Bits := NumGet(BitmapInfo,20), Width := NumGet(BitmapInfo,4), Height := NumGet(BitmapInfo,8)
 DllCall("opengl32\glGenTextures","Int",1,"UInt*",Texture)
 DllCall("opengl32\glBindTexture","UInt",0xDE1,"UInt",Texture) ;GL_TEXTURE_2D
 Linear := 0x2601, Nearest := 0x2600 ;GL_LINEAR, GL_NEAREST
 DllCall("opengl32\glTexParameteri","UInt",0xDE1,"UInt",0x2801,"Int",%Filter%) ;GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER. Set the minifying filter
 DllCall("opengl32\glTexParameteri","UInt",0xDE1,"UInt",0x2800,"Int",%Filter%) ;GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER. Set the magnification filter
 DllCall("opengl32\glTexImage2D","UInt",0xDE1,"Int",0,"Int",4,"Int",Width,"Int",Height,"Int",0,"UInt",0x80E1,"UInt",0x1401,"UInt",Bits) ;GL_TEXTURE_2D, GL_BGRA, GL_UNSIGNED_BYTE. Import image data
 DllCall("DeleteObject","UInt",hBitmap)
 Return, Texture
}

CreateCity(PosX = 0,PosY = 0,PosZ = 0,BlockLength = 4,BlockHeight = 2.5,BlockWidth = 3,BlockCountX = 20,BlockCountY = 20,BlockCountZ = 7)
{
 Str := A_IsUnicode ? "AStr" : "Str"
 hOpenGL32 := DllCall("GetModuleHandle","Str","opengl32")
 pBegin := DllCall("GetProcAddress","UInt",hOpenGL32,Str,"glBegin")
 pNormal := DllCall("GetProcAddress","UInt",hOpenGL32,Str,"glNormal3f")
 pTexCoord := DllCall("GetProcAddress","UInt",hOpenGL32,Str,"glTexCoord2f")
 pVertex := DllCall("GetProcAddress","UInt",hOpenGL32,Str,"glVertex3f")
 pEnd := DllCall("GetProcAddress","UInt",hOpenGL32,Str,"glEnd")

 ;generate display lists
 ListIndex := DllCall("opengl32\glGenLists","Int",1)
 DllCall("opengl32.dll\glNewList","UInt",ListIndex,"UInt",0x1300) ;GL_COMPILE

 Loop, %BlockCountX%
 {
  TempPosZ := PosZ
  PosX1 := PosX + BlockLength
  Loop, %BlockCountY%
  {
   TempPosZ -= BlockWidth, PosZ1 := TempPosZ + BlockWidth, StartPosY := PosY

   ;determine the block height level
   Random, Temp1, 0.0, 1.0
   Temp1 := Round((Temp1 ** 3) * BlockCountZ)

   If Not Temp1
    PosY1 := StartPosY
   Loop, %Temp1%
   {
    PosY1 := PosY + BlockHeight

    ;front face
    DllCall(pBegin,"UInt",0x7) ;GL_QUADS
    DllCall(pNormal,"Float",0,"Float",0,"Float",1)
    DllCall(pTexCoord,"Float",0.0,"Float",0.0)
    DllCall(pVertex,"Float",PosX1,"Float",PosY1,"Float",PosZ1)
    DllCall(pTexCoord,"Float",0.0,"Float",1.0)
    DllCall(pVertex,"Float",PosX,"Float",PosY1,"Float",PosZ1)
    DllCall(pTexCoord,"Float",1.0,"Float",1.0)
    DllCall(pVertex,"Float",PosX,"Float",PosY,"Float",PosZ1)
    DllCall(pTexCoord,"Float",1.0,"Float",0.0)
    DllCall(pVertex,"Float",PosX1,"Float",PosY,"Float",PosZ1)
    DllCall(pEnd)

    ;back face
    DllCall(pBegin,"UInt",0x7) ;GL_QUADS
    DllCall(pNormal,"Float",0,"Float",0,"Float",-1)
    DllCall(pTexCoord,"Float",0.0,"Float",0.0)
    DllCall(pVertex,"Float",PosX1,"Float",PosY1,"Float",TempPosZ)
    DllCall(pTexCoord,"Float",0.0,"Float",1.0)
    DllCall(pVertex,"Float",PosX,"Float",PosY1,"Float",TempPosZ)
    DllCall(pTexCoord,"Float",1.0,"Float",1.0)
    DllCall(pVertex,"Float",PosX,"Float",PosY,"Float",TempPosZ)
    DllCall(pTexCoord,"Float",1.0,"Float",0.0)
    DllCall(pVertex,"Float",PosX1,"Float",PosY,"Float",TempPosZ)
    DllCall(pEnd)

    ;right face
    DllCall(pBegin,"UInt",0x7) ;GL_QUADS
    DllCall(pNormal,"Float",1,"Float",0,"Float",0)
    DllCall(pTexCoord,"Float",0.0,"Float",0.0)
    DllCall(pVertex,"Float",PosX1,"Float",PosY1,"Float",PosZ1)
    DllCall(pTexCoord,"Float",0.0,"Float",1.0)
    DllCall(pVertex,"Float",PosX1,"Float",PosY1,"Float",TempPosZ)
    DllCall(pTexCoord,"Float",1.0,"Float",1.0)
    DllCall(pVertex,"Float",PosX1,"Float",PosY,"Float",TempPosZ)
    DllCall(pTexCoord,"Float",1.0,"Float",0.0)
    DllCall(pVertex,"Float",PosX1,"Float",PosY,"Float",PosZ1)
    DllCall(pEnd)

    ;left face
    DllCall(pBegin,"UInt",0x7) ;GL_QUADS
    DllCall(pNormal,"Float",-1,"Float",0,"Float",0)
    DllCall(pTexCoord,"Float",0.0,"Float",0.0)
    DllCall(pVertex,"Float",PosX,"Float",PosY1,"Float",PosZ1)
    DllCall(pTexCoord,"Float",0.0,"Float",1.0)
    DllCall(pVertex,"Float",PosX,"Float",PosY1,"Float",TempPosZ)
    DllCall(pTexCoord,"Float",1.0,"Float",1.0)
    DllCall(pVertex,"Float",PosX,"Float",PosY,"Float",TempPosZ)
    DllCall(pTexCoord,"Float",1.0,"Float",0.0)
    DllCall(pVertex,"Float",PosX,"Float",PosY,"Float",PosZ1)
    DllCall(pEnd)

    PosY += BlockHeight
   }

   ;top face
   DllCall(pBegin,"UInt",0x7) ;GL_QUADS
   DllCall(pNormal,"Float",0,"Float",1,"Float",0)
   ;DllCall(pTexCoord,"Float",0.0,"Float",0.0)
   DllCall(pVertex,"Float",PosX1,"Float",PosY1,"Float",PosZ1)
   ;DllCall(pTexCoord,"Float",0.0,"Float",1.0)
   DllCall(pVertex,"Float",PosX1,"Float",PosY1,"Float",TempPosZ)
   ;DllCall(pTexCoord,"Float",1.0,"Float",1.0)
   DllCall(pVertex,"Float",PosX,"Float",PosY1,"Float",TempPosZ)
   ;DllCall(pTexCoord,"Float",1.0,"Float",0.0)
   DllCall(pVertex,"Float",PosX,"Float",PosY1,"Float",PosZ1)
   DllCall(pEnd)
   
   PosY := StartPosY
  }
  PosX += BlockLength
 }
 DllCall("opengl32.dll\glEndList")
 Return, ListIndex
}