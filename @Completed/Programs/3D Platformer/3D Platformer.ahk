#NoEnv

MoveLeft = s
MoveRight = w
MoveJump = d

ClearColor := "0.6,0.6,0.8"
LevelAmbientColor := "0.2,0.2,0.2"
LevelDiffuseColor := "0.8,0.8,0.8"
LevelSpecularColor := "1,1,1"
FuelBlockAmbientColor := "0.5,1,0.5"
FuelBlockDiffuseColor := "0,1,0"
FuelBlockSpecularColor := "1,1,1"
GoalAmbientColor := "0.6,0.6,0.8"
GoalDiffuseColor := "0.8,0.8,1"
GoalSpecularColor := "1,1,1"

Difficulty = 1000
FuelAction = +100

StartingRotation = -90

/*
Width = 600
Height = 600

CurrentRect = 10.0,20.0,20.0,30.0
GoalRect = 102.0,200.0,40.0,50.0

Rectangles = 
(
12,150,110,20
112,110,60,20
192,210,170,20
292,360,50,20
152,140,30,190
172,480,60,30
22,180,30,320
72,430,90,20
92,250,60,20
402,110,20,290
10,520,400,20
)

FuelBlocks = 
(
120,40,20,20
250,150,20,20
200,300,20,20
)
*/

Width = 820
Height = 620

CurrentRect = 742,500,30,40
GoalRect = 532,170,60,60

Rectangles = 
(
312,560,480,30
42,420,350,40
172,160,40,260
72,160,100,30
162,60,280,20
442,110,100,20
562,60,100,30
702,220,100,30
512,230,100,30
)

FuelBlocks = 
(
272,310,40,30
472,70,40,30
)

SpeedX := -3, SpeedY := -5

Fuel := 100
FrameRate := 20

Gravity := 0.9
AirResistance := 0.98
Restitution := 0.4
Friction := 0.8
JitterDetection := 1.5

SetBatchLines, -1
SetMouseDelay, -1

Ptr := A_PtrSize ? "Ptr" : "UInt" ;set compatibility constants
hGDI32 := DllCall("LoadLibrary","Str","gdi32"), hOpenGL32 := DllCall("LoadLibrary","Str","opengl32") ;load libraries
OnExit, ExitSub

StringSplit, Temp, GoalRect, `,
GoalRectX := Temp1, GoalRectY := Temp2, GoalRectW := Temp3, GoalRectH := Temp4

StringSplit, Temp, CurrentRect, `,
CurrentRectX := Temp1, CurrentRectY := Temp2, CurrentRectW := Temp3, CurrentRectH := Temp4

Gosub, Initialize
Gosub, EventLoop
FailureReason := (Fuel <= 0) ? "Out of fuel." : "Out of time."
Gosub, Failure
ExitApp

GuiEscape:
GuiClose:
ExitApp

Tab::SlowMotion := !SlowMotion

Draw()
{
 global TextType, Score, Fuel, InfoText, CurrentRectX, CurrentRectY, CurrentRectW, CurrentRectH, hDC, RotX, RotY, FuelBlocks, Ptr, FontList
 DllCall("opengl32\glClear","UInt",0x4100) ;GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT
 DllCall("opengl32\glLoadIdentity")

 DllCall("opengl32\glRasterPos3f","Float",0.46,"Float",0.49,"Float",-1)
 DrawText := "Score: " . Score
 DllCall("opengl32\glCallLists","Int",StrLen(DrawText),"UInt",TextType,Ptr,&DrawText)
 DllCall("opengl32\glRasterPos3f","Float",0.46,"Float",0.455,"Float",-1)
 DrawText := "Remaining Fuel: " . Round(Fuel)
 DllCall("opengl32\glCallLists","Int",StrLen(DrawText),"UInt",TextType,Ptr,&DrawText)
 Loop, Parse, InfoText, `n
 {
  DllCall("opengl32\glRasterPos3f","Float",-0.68,"Float",0.53 - (A_Index * 0.035),"Float",-1)
  DrawText := A_LoopField, DllCall("opengl32\glCallLists","Int",StrLen(DrawText),"UInt",TextType,Ptr,&DrawText)
 }

 DllCall("opengl32\glRotatef","Float",RotY,"Float",1.0,"Float",0.0,"Float",0.0)
 DllCall("opengl32\glRotatef","Float",RotX,"Float",0.0,"Float",1.0,"Float",0.0)

 DllCall("opengl32\glTranslatef","Float",0 - ((CurrentRectX / 5) + (CurrentRectW / 10)),"Float",(CurrentRectY / 5) + (CurrentRectH / 10),"Float",0)

 DllCall("opengl32\glCallList","UInt",1) ;draw main level
 Loop, Parse, FuelBlocks, `n
  DllCall("opengl32\glCallList","UInt",SubStr(A_LoopField,InStr(A_LoopField,",",False,0) + 1)) ;draw fuel blocks

 DllCall("gdi32\SwapBuffers","UInt",hDC)
}

Initialize:
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
VarSetCapacity(ClientPoint,8,0), DllCall("ClientToScreen","UInt",hWindow,Ptr,&ClientPoint)
ControlPosX := NumGet(ClientPoint), ControlPosY := NumGet(ClientPoint,4)

Camera := "0,0,0|0,0,0|1,1,1"
DllCall("opengl32\glShadeModel","UInt",0x1D01) ;GL_SMOOTH
StringSplit, Temp, ClearColor, `,
DllCall("opengl32\glClearColor","Float",Temp1,"Float",Temp2,"Float",Temp3,"Float",0.0)
DllCall("opengl32\glClearDepth","Double",1.0)
DllCall("opengl32\glEnable","UInt",0xB71) ;GL_DEPTH_TEST
DllCall("opengl32\glDepthFunc","UInt",0x201) ;GL_LESS
DllCall("opengl32\glHint","UInt",0xC50,"UInt",0x1102) ;GL_PERSPECTIVE_CORRECTION_HINT, GL_NICEST
DllCall("opengl32\glPolygonMode","UInt",0x408,"UInt",0x1B02) ;GL_FRONT_AND_BACK, GL_FILL

DllCall("opengl32\glEnable","UInt",0xB50) ;GL_LIGHTING
DllCall("opengl32\glEnable","UInt",0x4000) ;GL_LIGHT0
VarSetCapacity(Struct,16)
NumPut(1,Struct,0,"Float"), NumPut(1,Struct,4,"Float"), NumPut(1,Struct,8,"Float"), NumPut(1,Struct,12,"Float") ;light with color 1,1,1
DllCall("opengl32\glLightfv","UInt",0x4000,"UInt",0x1200,Ptr,&Struct) ;GL_LIGHT0, GL_AMBIENT
NumPut(1,Struct,0,"Float"), NumPut(1,Struct,4,"Float"), NumPut(1,Struct,8,"Float"), NumPut(1,Struct,12,"Float")
DllCall("opengl32\glLightfv","UInt",0x4000,"UInt",0x1201,Ptr,&Struct) ;GL_LIGHT0, GL_DIFFUSE
NumPut(Temp1,Struct,0,"Float"), NumPut(Temp2,Struct,4,"Float"), NumPut(Temp3,Struct,8,"Float"), NumPut(Temp4,Struct,12,"Float")
DllCall("opengl32\glLightfv","UInt",0x4000,"UInt",0x1202,Ptr,&Struct) ;GL_LIGHT0, GL_SPECULAR

NumPut(0,Struct,0,"Float"), NumPut(0,Struct,4,"Float"), NumPut(0,Struct,8,"Float"), NumPut(1,Struct,12,"Float") ;positional light at 0,0,0
DllCall("opengl32\glLightfv","UInt",0x4000,"UInt",0x1203,Ptr,&Struct) ;GL_LIGHT0, GL_POSITION
DllCall("opengl32\glLightf","UInt",0x4000,"UInt",0x1208,"Float",0.01) ;GL_LIGHT0, GL_LINEAR_ATTENUATION

DllCall("opengl32\glEnable","UInt",0xDE1) ;GL_TEXTURE_2D

IfNotExist, %A_ScriptDir%\Level.jpg
 URLDownloadToFile, http://www.autohotkey.net/~Uberi/Scripts/3D`%20Platformer/Level.jpg, %A_ScriptDir%\Level.jpg
IfNotExist, %A_ScriptDir%\Item.jpg
 URLDownloadToFile, http://www.autohotkey.net/~Uberi/Scripts/3D`%20Platformer/Fuel.jpg, %A_ScriptDir%\Item.jpg
IfNotExist, %A_ScriptDir%\Goal.jpg
 URLDownloadToFile, http://www.autohotkey.net/~Uberi/Scripts/3D`%20Platformer/Goal.jpg, %A_ScriptDir%\Goal.jpg
LevelTexture := LoadTexture(A_ScriptDir . "\Level.jpg")
FuelTexture := LoadTexture(A_ScriptDir . "\Item.jpg")
GoalTexture := LoadTexture(A_ScriptDir . "\Goal.jpg")

CreateLevel()

FontList := DllCall("opengl32\glGenLists","Int",256)
hFont := DllCall("CreateFont","Int",-12,"Int",0,"Int",0,"Int",0,"Int",0,"UInt",0,"UInt",0,"UInt",0,"UInt",0,"UInt",4,"UInt",0,"UInt",4,"UInt",0,"Str","Arial")
hTempFont := DllCall("SelectObject","UInt",hDC,"UInt",hFont)
DllCall("opengl32\wglUseFontBitmaps" . (A_IsUnicode ? "W" : "A"),"UInt",hDC,"UInt",0,"UInt",256,"UInt",FontList)
DllCall("SelectObject","UInt",hDC,"UInt",hTempFont)
DllCall("DeleteObject","UInt",hFont)
TextType := A_IsUnicode ? 0x1403 : 0x1401 ;GL_UNSIGNED_SHORT, GL_UNSIGNED_BYTE
DllCall("opengl32\glListBase","UInt",FontList)

Gui, Show, w%Width% h%Height%, 3D Platformer

;move cursor to center of the window
MouseGetPos, PosX, PosY
PosX -= ControlPosX, PosY -= ControlPosY
MouseMove, 0 - (PosX - (Width / 2)), 0 - (PosY - (Height / 2)), 0, R
Return

Failure:
MsgBox, Game over.`n%FailureReason%
Return

Completion:
MsgBox, You win!
Return

EventLoop:
FrameRate := 1000 / FrameRate, Frames := 0, StartTime := A_TickCount, DisplayTime := A_TickCount
Loop
{
 GameLogic()
 StepAll()
 Score := Round((Difficulty - ((A_TickCount - StartTime) / 500)) * (Fuel / 100))
 If Score <= 0
  Break
 TempTime := A_TickCount
 Draw()
 Frames ++
 If ((A_TickCount - DisplayTime) >= 1000) ;show FPS every second
 {
  InfoText = Frames per second: %Frames%`nLocation: %CurrentRectX%, %CurrentRectY%`nRotation: %RotX%, %RotY%
  Frames := 0, DisplayTime := A_TickCount
 }
 Sleep, % FrameRate - (A_TickCount - TempTime) ;conpensate for lag
 If SlowMotion
  Sleep, % FrameRate * 2
}
Return

GameLogic()
{
 global MoveLeft, MoveRight, MoveJump, IsClimbing, SpeedX, SpeedY, Fuel, CanJump, CanClimb, CurrentRectX, CurrentRectY, Width, Height, RotX, RotY, StartingRotation, FailureReason
 static Direction1
 LeftDown := GetKeyState(MoveLeft,"P"), RightDown := GetKeyState(MoveRight,"P"), IsClimbing := LeftDown || RightDown
 If IsClimbing
  Direction := Direction1
 Else
  Temp1 := Mod(RotX,360), Direction := ((Temp1 < -180) || (Temp1 > 0 && Temp1 < 180)) ? 1 : -1, Direction1 := Direction
 If LeftDown
  SpeedX -= Direction, Fuel -= 0.2
 If RightDown
  SpeedX += Direction, Fuel -= 0.2
 If (CanJump && GetKeyState(MoveJump,"P"))
  SpeedY -= CanClimb ? 3 : 10, CanJump := 0, Fuel -= 2
 If (CurrentRectX < -100 || CurrentRectX > (Width + 100) || CurrentRectY < -100 || CurrentRectY > (Height + 100))
 {
  FailureReason := "Out of bounds."
  Gosub, Failure
  ExitApp
 }
 GetMouseMovement(RotX,RotY), RotX := (RotX * 120) + StartingRotation, RotY *= 120
}

StepAll()
{
 global Rectangles, FuelBlocks, FuelAction, CurrentRectX, CurrentRectY, CurrentRectW, CurrentRectH, GoalRectX, GoalRectY, GoalRectW, GoalRectH, SpeedX, SpeedY, AirResistance, Gravity, CanJump, Fuel
 SpeedX *= AirResistance, SpeedY *= AirResistance, SpeedY += Gravity
 If (CanJump && (A_TickCount - CanJump) > 100)
  CanJump = 0
 Loop, Parse, Rectangles, `n
  Temp1 := Step(A_LoopField)
 CurrentRectX += SpeedX, CurrentRectY += SpeedY
 Loop, Parse, FuelBlocks, `n
 {
  StringSplit, Temp, A_LoopField, `,
  If RectangleCollide(Temp1,Temp1 + Temp3,Temp2,Temp2 + Temp4,CurrentRectX,CurrentRectX + CurrentRectW,CurrentRectY,CurrentRectY + CurrentRectH)
  {
   If (SubStr(FuelAction,1,1) = "+")
    Fuel += SubStr(FuelAction,2)
   Else
    Fuel := FuelAction
   GuiControl, Hide, Fuel%Temp5%
   FuelBlocks := "`n" . FuelBlocks . "`n"
   StringGetPos, Temp1, FuelBlocks, `n, L%A_Index%
   FuelBlocks := SubStr(FuelBlocks,2,Temp1) . SubStr(FuelBlocks,InStr(FuelBlocks,"`n",False,Temp1 + 2) + 1,-1)
   Break
  }
 }
 If RectangleInside(CurrentRectX,CurrentRectX + CurrentRectW,CurrentRectY,CurrentRectY + CurrentRectH,GoalRectX,GoalRectX + GoalRectW,GoalRectY,GoalRectY + GoalRectH)
 {
  Gosub, Completion
  ExitApp
 }
}

Step(Rectangle)
{
 global CurrentRectX, CurrentRectY, CurrentRectW, CurrentRectH, SpeedX, SpeedY, Gravity, Restitution, Friction, JitterDetection, CanJump, IsClimbing, CanClimb
 StringSplit, Temp, Rectangle, `,
 Direction := RectangleCollide(Temp1,Temp1 + Temp3,Temp2,Temp2 + Temp4,CurrentRectX + SpeedX,CurrentRectX + SpeedX + CurrentRectW,CurrentRectY + SpeedY,CurrentRectY + SpeedY + CurrentRectH,IntersectX,IntersectY)
 If Direction
 {
  If Direction = Y
   SpeedY *= -1 * Restitution, CurrentRectY += IntersectY + Gravity, SpeedX *= Friction, CanJump := A_TickCount, CanClimb := 0
  Else If IsClimbing ;Direction equals X here
   SpeedX := 0, SpeedY *= Friction, SpeedY -= Gravity, CanJump := A_TickCount, CanClimb := 1
  Else ;If Direction = X
   SpeedX *= -1 * Restitution, CurrentRectX += IntersectX, SpeedY *= Friction, CanClimb := 0
  If (SpeedY >= Gravity * JitterDetection * -1 && SpeedY <= Gravity * JitterDetection)
   SpeedY = 0
  If SpeedX Between -0.05 And 0.05
   SpeedX = 0
 }
 Return, Collision
}

RectangleInside(Left1,Right1,Top1,Bottom1,Left2,Right2,Top2,Bottom2)
{
 If (Left1 >= Left2 && Right1 <= Right2 && Top1 >= Top2 && Bottom1 <= Bottom2)
  Return, 1
 Return, 0
}

RectangleCollide(Left1,Right1,Top1,Bottom1,Left2,Right2,Top2,Bottom2,ByRef IntersectX = "",ByRef IntersectY = "")
{
 If (Right1 < Left2 || Right2 < Left1 || Bottom1 < Top2 || Bottom2 < Top1)
 {
  IntersectX := 0, IntersectY := 0
  Return
 }
 ;find area of the rectangle intersection
 Temp1 := (Left1 < Left2), IntersectX := (Temp1 ? Left2 : Left1) - ((Right1 < Right2) ? Right1 : Right2), Temp1 ? (IntersectX *= -1)
 Temp1 := (Top1 < Top2), IntersectY := (Temp1 ? Top2 : Top1) - ((Bottom1 < Bottom2) ? Bottom1 : Bottom2), Temp1 ? (IntersectY *= -1)
 ;IntersectX := ((Left1 < Left2) ? Left2 : Left1) - ((Right1 < Right2) ? Right1 : Right2)
 ;IntersectY := ((Top1 < Top2) ? Top2 : Top1) - ((Bottom1 < Bottom2) ? Bottom1 : Bottom2)
 Return, (Abs(IntersectX) < Abs(IntersectY)) ? "X" : "Y" ;the axis the collision occurred in
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
 AbsoluteX += (PosX / Width) - 0.5, AbsoluteY += (PosY / Height) - 0.5, (AbsoluteY > 0.75) ? (AbsoluteY := 0.75) : ((AbsoluteY < -0.75) ? (AbsoluteY := -0.75))
 PosX := AbsoluteX, PosY := AbsoluteY
}

CreateLevel(Scale = 5,Width = 40)
{
 global Rectangles, FuelBlocks, GoalRectX, GoalRectY, GoalRectW, GoalRectH, LevelAmbientColor, LevelDiffuseColor, LevelSpecularColor, FuelBlockAmbientColor, FuelBlockDiffuseColor, FuelBlockSpecularColor, GoalAmbientColor, GoalDiffuseColor, GoalSpecularColor, LevelTexture, FuelTexture, GoalTexture
 DllCall("opengl32.dll\glNewList","UInt",1,"UInt",0x1300) ;GL_COMPILE

 SetMaterial(LevelAmbientColor,LevelDiffuseColor,LevelSpecularColor,0.7)

 DllCall("opengl32\glBindTexture","UInt",0xDE1,"UInt",LevelTexture) ;GL_TEXTURE_2D
 Loop, Parse, Rectangles, `n
 {
  StringSplit, Temp, A_LoopField, `,
  Temp1 /= Scale, Temp2 /= Scale, Temp3 /= Scale, Temp4 /= Scale
  Box(Temp1,0 - (Temp2 + Temp4),0 - (Width / 2),Temp3,Temp4,Width)
 }

 SetMaterial(GoalAmbientColor,GoalDiffuseColor,GoalSpecularColor,0.7)
 DllCall("opengl32\glBindTexture","UInt",0xDE1,"UInt",GoalTexture) ;GL_TEXTURE_2D
 Temp1 := GoalRectX / Scale, Temp2 := GoalRectY / Scale, Temp3 := GoalRectW / Scale, Temp4 := GoalRectH / Scale
 Box(Temp1,0 - (Temp2 + Temp4),-5,Temp3,Temp4,10)

 SetMaterial(FuelBlockAmbientColor,FuelBlockDiffuseColor,FuelBlockSpecularColor,0.7) ;set the correct material for the Fuelblocks
 DllCall("opengl32\glBindTexture","UInt",0xDE1,"UInt",FuelTexture) ;GL_TEXTURE_2D

 DllCall("opengl32.dll\glEndList")

 Loop, Parse, FuelBlocks, `n
 {
  Index := A_Index + 1
  DllCall("opengl32.dll\glNewList","UInt",Index,"UInt",0x1300) ;GL_COMPILE
  StringSplit, Temp, A_LoopField, `,
  Temp1 /= Scale, Temp2 /= Scale, Temp3 /= Scale, Temp4 /= Scale
  Box(Temp1,0 - (Temp2 + Temp4),-3,Temp3,Temp4,6)
  DllCall("opengl32.dll\glEndList")

  FuelBlocks1 .= A_LoopField . "," . Index . "`n"
 }
 FuelBlocks := SubStr(FuelBlocks1,1,-1)
}

SetMaterial(AmbientColor = "",DiffuseColor = "",SpecularColor = "",Shininess = 0.5,EmitColor = "")
{
 global Ptr
 VarSetCapacity(Struct,16)
 If AmbientColor
 {
  StringSplit, Temp, AmbientColor, `,
  NumPut(Temp1,Struct,0,"Float"), NumPut(Temp2,Struct,4,"Float"), NumPut(Temp3,Struct,8,"Float"), NumPut(Temp4,Struct,12,"Float")
  DllCall("opengl32\glMaterialfv","UInt",0x408,"UInt",0x1200,Ptr,&Struct) ;GL_FRONT_AND_BACK, GL_AMBIENT
 }
 If DiffuseColor
 {
  StringSplit, Temp, DiffuseColor, `,
  NumPut(Temp1,Struct,0,"Float"), NumPut(Temp2,Struct,4,"Float"), NumPut(Temp3,Struct,8,"Float"), NumPut(Temp4,Struct,12,"Float")
  DllCall("opengl32\glMaterialfv","UInt",0x408,"UInt",0x1201,Ptr,&Struct) ;GL_FRONT_AND_BACK, GL_DIFFUSE
 }
 If SpecularColor
 {
  StringSplit, Temp, SpecularColor, `,
  NumPut(Temp1,Struct,0,"Float"), NumPut(Temp2,Struct,4,"Float"), NumPut(Temp3,Struct,8,"Float"), NumPut(Temp4,Struct,12,"Float")
  DllCall("opengl32\glMaterialfv","UInt",0x408,"UInt",0x1202,Ptr,&Struct) ;GL_FRONT_AND_BACK, GL_SPECULAR
 }
 If Shininess
  DllCall("opengl32\glMaterialf","UInt",0x408,"UInt",0x1601,"Float",Shininess * 128) ;GL_FRONT_AND_BACK, GL_SHININESS
 If EmitColor
 {
  StringSplit, Temp, EmitColor, `,
  NumPut(Temp1,Struct,0,"Float"), NumPut(Temp2,Struct,4,"Float"), NumPut(Temp3,Struct,8,"Float"), NumPut(Temp4,Struct,12,"Float")
  DllCall("opengl32\glMaterialfv","UInt",0x408,"UInt",0x1600,Ptr,&Struct) ;GL_FRONT_AND_BACK, GL_EMISSION
 }
}

ResizeScene(PosX,PosY,Width,Height,FieldOfView = 45.0,ClipNear = 0.5,ClipFar = 100.0)
{
 DllCall("opengl32\glViewport","Int",PosX,"Int",PosY,"Int",Width,"Int",Height)
 DllCall("opengl32\glMatrixMode","UInt",0x1701) ;GL_PROJECTION
 DllCall("opengl32\glLoadIdentity")
 MaxY := ClipNear * Tan(FieldOfView * 0.00872664626), MaxX := MaxY * (Width / Height), DllCall("opengl32\glFrustum","Double",0 - MaxX,"Double",MaxX,"Double",0 - MaxY,"Double",MaxY,"Double",ClipNear,"Double",ClipFar)
 DllCall("opengl32\glMatrixMode","UInt",0x1700) ;GL_MODELVIEW
}

GuiSize:
Width := A_GuiWidth ? A_GuiWidth : 1, Height := A_GuiHeight ? A_GuiHeight : 1
ResizeScene(0,0,Width,Height,55.0,0.5,Width / 4)
Return

ExitSub:
DllCall("opengl32\glDeleteLists","UInt",FontList,"Int",256)
DllCall("opengl32\glDeleteTextures","Int",1,"UInt",LevelTexture)
DllCall("opengl32\wglMakeCurrent","UInt",0,"UInt",0)
DllCall("opengl32\wglDeleteContext","UInt",hRC)
DllCall("FreeLibrary","UInt",hOpenGL32)
DllCall("ShowCursor","Int",1) ;show the cursor
ExitApp

Box(PosX,PosY,PosZ,Length,Height,Width)
{
 Str := A_IsUnicode ? "AStr" : "Str"
 hOpenGL32 := DllCall("GetModuleHandle","Str","opengl32")
 pBegin := DllCall("GetProcAddress","UInt",hOpenGL32,Str,"glBegin")
 pNormal := DllCall("GetProcAddress","UInt",hOpenGL32,Str,"glNormal3f")
 pTexCoord := DllCall("GetProcAddress","UInt",hOpenGL32,Str,"glTexCoord2f")
 pVertex := DllCall("GetProcAddress","UInt",hOpenGL32,Str,"glVertex3f")
 pEnd := DllCall("GetProcAddress","UInt",hOpenGL32,Str,"glEnd")
 PosX1 := PosX + Length, PosY1 := PosY + Height, PosZ1 := PosZ + Width

 ;front face
 DllCall(pBegin,"UInt",0x7) ;GL_QUADS
 DllCall(pNormal,"Float",0,"Float",0,"Float",1)
 DllCall(pTexCoord,"Float",0.0,"Float",0.0), DllCall(pVertex,"Float",PosX1,"Float",PosY1,"Float",PosZ1)
 DllCall(pTexCoord,"Float",0.0,"Float",1.0), DllCall(pVertex,"Float",PosX,"Float",PosY1,"Float",PosZ1)
 DllCall(pTexCoord,"Float",1.0,"Float",1.0), DllCall(pVertex,"Float",PosX,"Float",PosY,"Float",PosZ1)
 DllCall(pTexCoord,"Float",1.0,"Float",0.0), DllCall(pVertex,"Float",PosX1,"Float",PosY,"Float",PosZ1)
 DllCall(pEnd)

 ;back face
 DllCall(pBegin,"UInt",0x7) ;GL_QUADS
 DllCall(pNormal,"Float",0,"Float",0,"Float",-1)
 DllCall(pTexCoord,"Float",0.0,"Float",0.0), DllCall(pVertex,"Float",PosX1,"Float",PosY1,"Float",PosZ)
 DllCall(pTexCoord,"Float",0.0,"Float",1.0), DllCall(pVertex,"Float",PosX,"Float",PosY1,"Float",PosZ)
 DllCall(pTexCoord,"Float",1.0,"Float",1.0), DllCall(pVertex,"Float",PosX,"Float",PosY,"Float",PosZ)
 DllCall(pTexCoord,"Float",1.0,"Float",0.0), DllCall(pVertex,"Float",PosX1,"Float",PosY,"Float",PosZ)
 DllCall(pEnd)

 ;right face
 DllCall(pBegin,"UInt",0x7) ;GL_QUADS
 DllCall(pNormal,"Float",1,"Float",0,"Float",0)
 DllCall(pTexCoord,"Float",0.0,"Float",0.0), DllCall(pVertex,"Float",PosX1,"Float",PosY1,"Float",PosZ1)
 DllCall(pTexCoord,"Float",0.0,"Float",1.0), DllCall(pVertex,"Float",PosX1,"Float",PosY1,"Float",PosZ)
 DllCall(pTexCoord,"Float",1.0,"Float",1.0), DllCall(pVertex,"Float",PosX1,"Float",PosY,"Float",PosZ)
 DllCall(pTexCoord,"Float",1.0,"Float",0.0), DllCall(pVertex,"Float",PosX1,"Float",PosY,"Float",PosZ1)
 DllCall(pEnd)

 ;left face
 DllCall(pBegin,"UInt",0x7) ;GL_QUADS
 DllCall(pNormal,"Float",-1,"Float",0,"Float",0)
 DllCall(pTexCoord,"Float",0.0,"Float",0.0), DllCall(pVertex,"Float",PosX,"Float",PosY1,"Float",PosZ1)
 DllCall(pTexCoord,"Float",0.0,"Float",1.0), DllCall(pVertex,"Float",PosX,"Float",PosY1,"Float",PosZ)
 DllCall(pTexCoord,"Float",1.0,"Float",1.0), DllCall(pVertex,"Float",PosX,"Float",PosY,"Float",PosZ)
 DllCall(pTexCoord,"Float",1.0,"Float",0.0), DllCall(pVertex,"Float",PosX,"Float",PosY,"Float",PosZ1)
 DllCall(pEnd)

 ;top face
 DllCall(pBegin,"UInt",0x7) ;GL_QUADS
 DllCall(pNormal,"Float",0,"Float",1,"Float",0)
 DllCall(pTexCoord,"Float",0.0,"Float",0.0), DllCall(pVertex,"Float",PosX1,"Float",PosY1,"Float",PosZ1)
 DllCall(pTexCoord,"Float",0.0,"Float",1.0), DllCall(pVertex,"Float",PosX1,"Float",PosY1,"Float",PosZ)
 DllCall(pTexCoord,"Float",1.0,"Float",1.0), DllCall(pVertex,"Float",PosX,"Float",PosY1,"Float",PosZ)
 DllCall(pTexCoord,"Float",1.0,"Float",0.0), DllCall(pVertex,"Float",PosX,"Float",PosY1,"Float",PosZ1)
 DllCall(pEnd)

 ;bottom face
 DllCall(pBegin,"UInt",0x7) ;GL_QUADS
 DllCall(pNormal,"Float",0,"Float",-1,"Float",0)
 DllCall(pTexCoord,"Float",0.0,"Float",0.0), DllCall(pVertex,"Float",PosX1,"Float",PosY,"Float",PosZ1)
 DllCall(pTexCoord,"Float",0.0,"Float",1.0), DllCall(pVertex,"Float",PosX1,"Float",PosY,"Float",PosZ)
 DllCall(pTexCoord,"Float",1.0,"Float",1.0), DllCall(pVertex,"Float",PosX,"Float",PosY,"Float",PosZ)
 DllCall(pTexCoord,"Float",1.0,"Float",0.0), DllCall(pVertex,"Float",PosX,"Float",PosY,"Float",PosZ1)
 DllCall(pEnd)
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