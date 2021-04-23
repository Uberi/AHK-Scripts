#NoEnv

#Include %A_ScriptDir%\LoadOBJ.ahk

;wip: use arrays instead of strings and stringsplit, so OOP idioms can be used (e.g., "MonkeyTorus.Translate(-1,2,-3)")

Width = 600
Height = 600

FrameRate = 30
HideCursor = 1
ClearColor = 0.5,0.5,0.9

SetBatchLines, -1

SetMouseDelay, -1

UPtr := A_PtrSize ? "UPtr" : "UInt" ;set compatibility constants
hGDI32 := DllCall("LoadLibrary","Str","gdi32"), hOpenGL32 := DllCall("LoadLibrary","Str","opengl32") ;load libraries
OnExit, ExitSub
Gui, +LastFound +Resize +MinSize150x150
hWindow := WinExist()

If HideCursor
 DllCall("ShowCursor","Int",0) ;hide the cursor

AddViewport(hWindow,hDC,hRC)

Camera := "0,0,0|0,0,0|1,1,1"
DllCall("opengl32\glShadeModel","UInt",0x1D01) ;GL_SMOOTH
StringSplit, Temp, ClearColor, `,
DllCall("opengl32\glClearColor","Float",Temp1,"Float",Temp2,"Float",Temp3,"Float",0.0)
DllCall("opengl32\glClearDepth","Double",1.0)
DllCall("opengl32\glEnable","UInt",0xB71) ;GL_DEPTH_TEST
DllCall("opengl32\glEnable","UInt",0x803A) ;GL_RESCALE_NORMAL
DllCall("opengl32\glDepthFunc","UInt",0x201) ;GL_LESS
DllCall("opengl32\glHint","UInt",0xC50,"UInt",0x1102) ;GL_PERSPECTIVE_CORRECTION_HINT, GL_NICEST
DllCall("opengl32\glPolygonMode","UInt",0x408,"UInt",0x1B02) ;GL_FRONT_AND_BACK, GL_FILL

TranslateCamera("0,0,-7")

AddLight()
SetLightColor(0,"0.2,0.2,0.2,1","0.7,0.7,0.7,1","1,1,1,1")
SetLightProperties(0,"1,1,1","Positional","Linear",0.05)

SetMaterial("0.2,0,0","1,0,0","1,1,1")

FileRead, Temp1, %A_ScriptDir%\Test Scene.obj
MonkeyScene := LoadOBJ(Temp1,"Test")
FileRead, Temp1, %A_ScriptDir%\Mesh.obj
MonkeyTorus := LoadOBJ(Temp1,"Torus")
DrawList := "MonkeyTorus,MonkeyScene"

Gui, Show, w%Width% h%Height%, OpenGL Objects

FrameRate := 1000 / FrameRate, Frames := 0, StartTime := A_TickCount
Loop
{
 DrawTime := A_TickCount
 DrawScene()

 Frames ++
 If ((A_TickCount - StartTime) >= 1000) ;show FPS every second
 {
  ToolTip, Frames per second: %Frames%`nCamera: %Camera%, 0, 0
  Frames := 0, StartTime := A_TickCount
 }
 Sleep, % FrameRate - (A_TickCount - DrawTime) ;compensate for lag to maintain framerate
}
Return

Space::
GetMouseMovement(PosX,PosY)
ToolTip %PosX%`, %PosY%,,, 2
Return

GetMouseMovement(ByRef PosX = "",ByRef PosY = "")
{
 global ControlPosX, ControlPosY, Width, Height, hWindow
 static PosX1 := 0, PosY1 := 0, AbsoluteX := 0, AbsoluteY := 0
 MouseGetPos, PosX, PosY, TempWindow
 PosX -= ControlPosX, PosY -= ControlPosY
 If TempWindow <> %hWindow% ;if the mouse is currently not in the window
 {
  PosX := PosX1, PosY := PosY1 ;retore the previous position
  Return
 }
 MouseMove, 0 - (PosX - (Width / 2)), 0 - (PosY - (Height / 2)), 0, R
 AbsoluteX += (PosX / Width) - 0.5, AbsoluteY += (PosY / Height) - 0.5, PosX := AbsoluteX, PosY := AbsoluteY, PosX1 := PosX, PosY1 := PosY
}

w::TranslateCamera("0,0,0.1")
s::TranslateCamera("0,0,-0.1")
a::TranslateCamera("-0.1,0,0")
d::TranslateCamera("0.1,0,0")
q::TranslateCamera("0,-0.1,0")
e::TranslateCamera("0,0.1,0")
z::
ScaleCamera("0,-0.1,0")
Return
x::
ScaleCamera("0,0.1,0")
Return

i::TranslateObject(MonkeyTorus,"0,0,0.1")
k::TranslateObject(MonkeyTorus,"0,0,-0.1")
j::TranslateObject(MonkeyTorus,"-0.1,0,0")
l::TranslateObject(MonkeyTorus,"0.1,0,0")
u::TranslateObject(MonkeyTorus,"0,-0.1,0")
o::TranslateObject(MonkeyTorus,"0,0.1,0")
Up::RotateObject(MonkeyTorus,"5,0,0")
Down::RotateObject(MonkeyTorus,"-5,0,0")
Left::RotateObject(MonkeyTorus,"0,5,0")
Right::RotateObject(MonkeyTorus,"0,-5,0")
m::
ScaleObject(MonkeyTorus,"0.05,0,0")
Return
,::
ScaleObject(MonkeyTorus,"-0.05,0,0")
Return

SetObjectMaterial(ObjectName,AmbientColor = "",DiffuseColor = "",SpecularColor = "",Shininess = 0.5,EmitColor = "") ;wip: make this set an object's material, and have it drawn by DrawObject()
{
 
}

SetMaterial(AmbientColor = "",DiffuseColor = "",SpecularColor = "",Shininess = 0.5,EmitColor = "")
{
 global UPtr
 VarSetCapacity(Struct,16)
 If AmbientColor
 {
  StringSplit, Temp, AmbientColor, `,
  NumPut(Temp1,Struct,0,"Float"), NumPut(Temp2,Struct,4,"Float"), NumPut(Temp3,Struct,8,"Float"), NumPut(Temp4,Struct,12,"Float")
  DllCall("opengl32\glMaterialfv","UInt",0x408,"UInt",0x1200,UPtr,&Struct) ;GL_FRONT_AND_BACK, GL_AMBIENT
 }
 If DiffuseColor
 {
  StringSplit, Temp, DiffuseColor, `,
  NumPut(Temp1,Struct,0,"Float"), NumPut(Temp2,Struct,4,"Float"), NumPut(Temp3,Struct,8,"Float"), NumPut(Temp4,Struct,12,"Float")
  DllCall("opengl32\glMaterialfv","UInt",0x408,"UInt",0x1201,UPtr,&Struct) ;GL_FRONT_AND_BACK, GL_DIFFUSE
 }
 If SpecularColor
 {
  StringSplit, Temp, SpecularColor, `,
  NumPut(Temp1,Struct,0,"Float"), NumPut(Temp2,Struct,4,"Float"), NumPut(Temp3,Struct,8,"Float"), NumPut(Temp4,Struct,12,"Float")
  DllCall("opengl32\glMaterialfv","UInt",0x408,"UInt",0x1202,UPtr,&Struct) ;GL_FRONT_AND_BACK, GL_SPECULAR
 }
 If Shininess
  DllCall("opengl32\glMaterialf","UInt",0x408,"UInt",0x1601,"Float",Shininess * 128) ;GL_FRONT_AND_BACK, GL_SHININESS
 If EmitColor
 {
  StringSplit, Temp, EmitColor, `,
  NumPut(Temp1,Struct,0,"Float"), NumPut(Temp2,Struct,4,"Float"), NumPut(Temp3,Struct,8,"Float"), NumPut(Temp4,Struct,12,"Float")
  DllCall("opengl32\glMaterialfv","UInt",0x408,"UInt",0x1600,UPtr,&Struct) ;GL_FRONT_AND_BACK, GL_EMISSION
 }
}

AddLight(LightIndex = 0)
{
 static LightingEnabled := 0
 If Not LightingEnabled
  LightingEnabled := 1, DllCall("opengl32\glEnable","UInt",0xB50) ;GL_LIGHTING
 DllCall("opengl32\glEnable","UInt",0x4000 + LightIndex) ;GL_LIGHT0 + The zero based index of the light
}

SetLightColor(Light = 0,AmbientColor = "",DiffuseColor = "",SpecularColor = "") ;RGBA: "0.6,0.6,0.6,1.0"
{
 global UPtr
 Light += 0x4000 ;GL_LIGHT0 = 0x4000, ..., GL_LIGHT7 = 0x4007
 VarSetCapacity(Struct,16)
 If AmbientColor
 {
  StringSplit, Temp, AmbientColor, `,
  NumPut(Temp1,Struct,0,"Float"), NumPut(Temp2,Struct,4,"Float"), NumPut(Temp3,Struct,8,"Float"), NumPut(Temp4,Struct,12,"Float")
  DllCall("opengl32\glLightfv","UInt",Light,"UInt",0x1200,UPtr,&Struct) ;GL_AMBIENT
 }
 If DiffuseColor
 {
  StringSplit, Temp, DiffuseColor, `,
  NumPut(Temp1,Struct,0,"Float"), NumPut(Temp2,Struct,4,"Float"), NumPut(Temp3,Struct,8,"Float"), NumPut(Temp4,Struct,12,"Float")
  DllCall("opengl32\glLightfv","UInt",Light,"UInt",0x1201,UPtr,&Struct) ;GL_DIFFUSE
 }
 If SpecularColor
 {
  StringSplit, Temp, SpecularColor, `,
  NumPut(Temp1,Struct,0,"Float"), NumPut(Temp2,Struct,4,"Float"), NumPut(Temp3,Struct,8,"Float"), NumPut(Temp4,Struct,12,"Float")
  DllCall("opengl32\glLightfv","UInt",Light,"UInt",0x1202,UPtr,&Struct) ;GL_SPECULAR
 }
}

SetLightProperties(LightIndex = 0,Position = "",LightType = "",AttenuationMethod = "",AttenuationAmount = "",SpotDirection = "",SpotExponent = 0.2,SpotCutoff = 60) ;wip: SpotCutoff can be 0-90, or 180
{
 global UPtr
 static Light0Pos := "0,0,0", Light0Type := "Positional", Light0AttentuationMethod := "Linear", Light0AttenuationAmount := 0.05
 static Light1Pos := "0,0,0", Light1Type := "Positional", Light1AttentuationMethod := "Linear", Light1AttenuationAmount := 0.05
 static Light2Pos := "0,0,0", Light2Type := "Positional", Light2AttentuationMethod := "Linear", Light2AttenuationAmount := 0.05
 static Light3Pos := "0,0,0", Light3Type := "Positional", Light3AttentuationMethod := "Linear", Light3AttenuationAmount := 0.05
 static Light4Pos := "0,0,0", Light4Type := "Positional", Light4AttentuationMethod := "Linear", Light4AttenuationAmount := 0.05
 static Light5Pos := "0,0,0", Light5Type := "Positional", Light5AttentuationMethod := "Linear", Light5AttenuationAmount := 0.05
 static Light6Pos := "0,0,0", Light6Type := "Positional", Light6AttentuationMethod := "Linear", Light6AttenuationAmount := 0.05
 static Light7Pos := "0,0,0", Light7Type := "Positional", Light7AttentuationMethod := "Linear", Light7AttenuationAmount := 0.05
 If LightIndex Not Between 0 And 7
  Return
 Light := LightIndex + 0x4000 ;GL_LIGHT0 = 0x4000, ..., GL_LIGHT7 = 0x4007
 If (Position || LightType)
 {
  If Position = 
   Position := Light%LightIndex%Pos
  Else
   Light%LightIndex%Pos := Position
  If LightType Not In Directional,Positional,Spotlight
   LightType := Light%LightIndex%Type
  Else
   Light%LightIndex%Type := LightType
  StringSplit, Temp, Position, `,
  VarSetCapacity(Struct,16), NumPut(Temp1,Struct,0,"Float"), NumPut(Temp2,Struct,4,"Float"), NumPut(Temp3,Struct,8,"Float"), NumPut(!(LightType = "Directional"),Struct,12,"Float")
  DllCall("opengl32\glLightfv","UInt",Light,"UInt",0x1203,UPtr,&Struct) ;GL_POSITION
 }
 If AttenuationMethod
 {
  If AttenuationMethod Not In Constant,Linear,Quadratic
   AttenuationMethod := Light%LightIndex%AttenuationMethod
  Else
   Light%LightIndex%AttenuationMethod := AttenuationMethod
  If AttenuationAmount = 
   AttenuationAmount := Light%LightIndex%AttenuationAmount
  Else
   Light%LightIndex%AttenuationAmount := AttenuationAmount
  Constant := 0x1207, Linear := 0x1208, Quadratic := 0x1209 ;GL_CONSTANT_ATTENUATION, GL_LINEAR_ATTENUATION, GL_QUADRATIC_ATTENUATION
  DllCall("opengl32\glLightf","UInt",Light,"UInt",%AttenuationMethod%,"Float",AttenuationAmount)
 }
 If LightType = Spotlight
 {
  If SpotDirection
  {
   StringSplit, Temp, SpotDirection, `,
   VarSetCapacity(Struct,12), NumPut(Temp1,Struct,0,"Float"), NumPut(Temp2,Struct,4,"Float"), NumPut(Temp3,Struct,8,"Float")
   DllCall("opengl32\glLightfv","UInt",Light,"UInt",0x1204,UPtr,&Struct) ;GL_SPOT_DIRECTION
  }
  If SpotCutoff
   DllCall("opengl32\glLightf","UInt",Light,"UInt",0x1206,"Float",SpotCutoff) ;GL_SPOT_CUTOFF
  If SpotExponent
   DllCall("opengl32\glLightf","UInt",Light,"UInt",0x1205,"Float",SpotExponent * 128) ;GL_SPOT_EXPONENT
 }
}

TranslateObject(ByRef CurrentObject,Translation,Absolute = 0)
{
 Temp1 := InStr(CurrentObject,"|") + 1
 If Absolute
  CurrentObject := SubStr(CurrentObject,1,Temp1 - 1) . Translation . SubStr(CurrentObject,InStr(CurrentObject,"|",False,Temp1))
 Else
 {
  StringSplit, Translation, Translation, `,
  Temp2 := SubStr(CurrentObject,Temp1,InStr(CurrentObject,"|",False,Temp1) - Temp1)
  StringSplit, Temp1, Temp2, `,
  CurrentObject := SubStr(CurrentObject,1,Temp1 - 1) . Temp11 + Translation1 . "," . Temp12 + Translation2 . "," . Temp13 + Translation3 . SubStr(CurrentObject,InStr(CurrentObject,"|",False,Temp1))
 }
}

RotateObject(ByRef CurrentObject,Rotation,Absolute = 0)
{
 StringGetPos, Temp1, CurrentObject, |, L2
 Temp1 += 2
 If Absolute
  CurrentObject := SubStr(CurrentObject,1,Temp1 - 1) . Rotation . SubStr(CurrentObject,InStr(CurrentObject,"|",False,Temp1))
 Else
 {
  StringSplit, Rotation, Rotation, `,
  Temp2 := SubStr(CurrentObject,Temp1,InStr(CurrentObject,"|",False,Temp1) - Temp1)
  StringSplit, Temp1, Temp2, `,
  CurrentObject := SubStr(CurrentObject,1,Temp1 - 1) . Temp11 + Rotation1 . "," . Temp12 + Rotation2 . "," . Temp13 + Rotation3 . SubStr(CurrentObject,InStr(CurrentObject,"|",False,Temp1))
 }
}

ScaleObject(ByRef CurrentObject,Scale,Absolute = 0)
{
 StringGetPos, Temp1, CurrentObject, |, L3
 Temp1 += 2
 If Absolute
  CurrentObject := SubStr(CurrentObject,1,Temp1 - 1) . Scale . SubStr(CurrentObject,InStr(CurrentObject,"|",False,Temp1))
 Else
 {
  StringSplit, Scale, Scale, `,
  Temp2 := SubStr(CurrentObject,Temp1,InStr(CurrentObject,"|",False,Temp1) - Temp1)
  StringSplit, Temp1, Temp2, `,
  CurrentObject := SubStr(CurrentObject,1,Temp1 - 1) . Temp11 + Scale1 . "," . Temp12 + Scale2 . "," . Temp13 + Scale3 . SubStr(CurrentObject,InStr(CurrentObject,"|",False,Temp1))
 }
}

TranslateCamera(Translation,Absolute = 0)
{
 global Camera
 Temp1 := InStr(Camera,"|")
 If Absolute
  Camera := Translation . SubStr(Camera,Temp1)
 Else
 {
  StringSplit, Translation, Translation, `,
  Temp2 := SubStr(Camera,1,Temp1 - 1)
  StringSplit, Temp1, Temp2, `,
  Camera := Temp11 - Translation1 . "," . Temp12 - Translation2 . "," . Temp13 + Translation3 . SubStr(Camera,Temp1)
 }
}

RotateCamera(Rotation,Absolute = 0)
{
 global Camera
 Temp1 := InStr(Camera,"|") + 1
 If Absolute
  Camera := SubStr(Camera,1,Temp1 - 1) . Rotation . SubStr(Camera,InStr(Camera,"|",False,Temp1))
 Else
 {
  StringSplit, Rotation, Rotation, `,
  Temp2 := SubStr(Camera,Temp1,InStr(Camera,"|",False,Temp1) - Temp1)
  StringSplit, Temp1, Temp2, `,
  Camera := SubStr(Camera,1,Temp1 - 1) . Temp11 + Rotation1 . "," . Temp12 + Rotation2 . "," . Temp13 + Rotation3 . SubStr(Camera,InStr(Camera,"|",False,Temp1))
 }
}

ScaleCamera(Scale,Absolute = 0)
{
 global Camera
 StringGetPos, Temp1, Camera, |, L2
 Temp1 += 2
 If Absolute
  Camera := SubStr(Camera,1,Temp1 - 1) . Scale
 Else
 {
  StringSplit, Scale, Scale, `,
  Temp2 := SubStr(Camera,Temp1)
  StringSplit, Temp1, Temp2, `,
  Camera := SubStr(Camera,1,Temp1 - 1) . Temp11 - Scale1 . "," . Temp12 - Scale2 . "," . Temp13 - Scale3
 }
}

DrawScene()
{
 local Temp0, Temp1, Temp2, Temp3, Temp10, Temp11, Temp12, Temp13
 DllCall("opengl32\glClear","UInt",0x4100) ;GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT
 DllCall("opengl32\glLoadIdentity")

 ;wip: temporary demo
 GetMouseMovement(RotX,RotY)
 RotateCamera((RotY * 100) . "," . (RotX * 100) . ",0",1)

 StringSplit, Temp, Camera, |
 StringSplit, Temp1, Temp2, `,
 DllCall("opengl32\glRotatef","Float",Temp11,"Float",1.0,"Float",0.0,"Float",0.0)
 DllCall("opengl32\glRotatef","Float",Temp12,"Float",0.0,"Float",1.0,"Float",0.0)
 DllCall("opengl32\glRotatef","Float",Temp13,"Float",0.0,"Float",0.0,"Float",1.0)
 StringSplit, Temp1, Temp1, `,
 DllCall("opengl32\glTranslatef","Float",Temp11,"Float",Temp12,"Float",Temp13)
 StringSplit, Temp1, Temp3, `,
 DllCall("opengl32\glScalef","Float",Temp11,"Float",Temp12,"Float",Temp13)

 Loop, Parse, DrawList, `,
  DrawObject(%A_LoopField%)

 DllCall("gdi32\SwapBuffers","UInt",hDC)
}

DrawObject(ByRef CurrentObject) ;wip: finish transforms, materials, local transforms
{
 StringSplit, CurrentObject, CurrentObject, |
 DllCall("opengl32\glPushMatrix")
 DllCall("opengl32\glPushAttrib","UInt",0x1) ;GL_CURRENT_BIT

 StringSplit, Temp, CurrentObject2, `,
 DllCall("opengl32\glTranslatef","Float",Temp1,"Float",Temp2,"Float",Temp3)
 StringSplit, Temp, CurrentObject3, `,
 DllCall("opengl32\glRotatef","Float",Temp1,"Float",1.0,"Float",0.0,"Float",0.0)
 DllCall("opengl32\glRotatef","Float",Temp2,"Float",0.0,"Float",1.0,"Float",0.0)
 DllCall("opengl32\glRotatef","Float",Temp3,"Float",0.0,"Float",0.0,"Float",1.0)
 StringSplit, Temp, CurrentObject4, `,
 DllCall("opengl32\glScalef","Float",Temp1,"Float",Temp2,"Float",Temp3)
 DllCall("opengl32\glCallList","UInt",CurrentObject1)
 DllCall("opengl32\glPopAttrib")
 DllCall("opengl32\glPopMatrix")
}

ResizeScene(PosX,PosY,Width,Height,FieldOfView = 45.0,ClipNear = 0.5,ClipFar = 50.0)
{
 DllCall("opengl32\glViewport","Int",PosX,"Int",PosY,"Int",Width,"Int",Height)
 DllCall("opengl32\glMatrixMode","UInt",0x1701) ;GL_PROJECTION
 DllCall("opengl32\glLoadIdentity")
 MaxY := ClipNear * Tan(FieldOfView * 0.00872664626) ;pi / 180
 MaxX := MaxY * (Width / Height)
 DllCall("opengl32\glFrustum","Double",0 - MaxX,"Double",MaxX,"Double",0 - MaxY,"Double",MaxY,"Double",ClipNear,"Double",ClipFar)
 DllCall("opengl32\glMatrixMode","UInt",0x1700) ;GL_MODELVIEW
}

AddViewport(hWindow,ByRef hDC,ByRef hRC)
{
 global UPtr, ControlPosX, ControlPosY
 hDC := DllCall("GetDC","UInt",hWindow)
 VarSetCapacity(pfd,40,0), NumPut(40,pfd,0,"UShort"), NumPut(1,pfd, 2,"UShort")
 NumPut(0x25,pfd,4,"UInt") ;PFD_DRAW_TO_WINDOW | PFD_SUPPORT_OPENGL | PFD_DOUBLEBUFFER
 NumPut(0,pfd,8,"UChar") ;PFD_TYPE_RGBA
 NumPut(24,pfd,9,"UChar") ;Color bit depth
 NumPut(16,pfd,23,"UChar") ;Depth buffer bit depth
 DllCall("gdi32\SetPixelFormat","UInt",hDC,"Int",DllCall("gdi32\ChoosePixelFormat","UInt",hDC,UPtr,&pfd,"Int"),UPtr,&pfd)
 hRC := DllCall("opengl32\wglCreateContext","UInt",hDC), DllCall("opengl32\wglMakeCurrent","UInt",hDC,"UInt",hRC)

 ;get the position of the control on screen
 VarSetCapacity(ClientPoint,8,0), DllCall("ClientToScreen","UInt",hWindow,UPtr,&ClientPoint), ControlPosX := NumGet(ClientPoint,0,"UInt"), ControlPosY := NumGet(ClientPoint,4,"UInt")
}

GetMouseLocation(ByRef PosX = "",ByRef PosY = "")
{
 global ControlPosX, ControlPosY, Width, Height, hWindow
 static PosX1, PosY1
 MouseGetPos, PosX, PosY, TempWindow
 PosX -= ControlPosX, PosY -= ControlPosY
 If TempWindow <> %hWindow% ;if the mouse is currently not in the window
 {
  PosX := PosX1, PosY := PosY1 ;retore the previous position
  Return
 }
 ;clamp values
 If PosX < 0
  PosX = 0
 Else If PosX > %Width%
  PosX = %Width%
 If PosY < 0
  PosY = 0
 Else If PosY > %Height%
  PosY = %Height%
 PosX /= Width, PosY /= Height, PosX1 := PosX, PosY1 := PosY
}

GuiSize:
Width := A_GuiWidth ? A_GuiWidth : 1, Height := A_GuiHeight ? A_GuiHeight : 1
ResizeScene(0,0,Width,Height,45.0)
Return

Esc::
GuiClose:
ExitApp

ExitSub:
DllCall("opengl32\wglMakeCurrent","UInt",0,"UInt",0)
DllCall("opengl32\wglDeleteContext","UInt",hRC)

;If HideCursor
 ;DllCall("ShowCursor","Int",1) ;show the cursor
ExitApp

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

DeleteTexture(Texture)
{
 DllCall("opengl32\glDeleteTextures","Int",1,"UInt",Texture)
}

/*
pi := 3.1415926535
piover180 := 0.0174532925

glEnable(GL_RESCALE_NORMAL)

glEnable(GL_BLEND)

;glEnable(GL_FOG)
;glFogf(GL_FOG_MODE,GL_LINEAR)
;glFogf(GL_FOG_START,1.0)
;glFogf(GL_FOG_END,10.0)
;glHint(GL_FOG_HINT,GL_NICEST)

glEnable(GL_LIGHTING)
glEnable(GL_COLOR_MATERIAL)
glEnable(GL_LIGHT0)
DrawGLScene()
Loop
{
 Used = 0
 GetKeyState("w","P") ? (xpos -= Sin(yrot * piover180) * 0.05, zpos -= Cos(yrot * piover180) * 0.05, Used := 1)
 GetKeyState("s","P") ? (xpos += Sin(yrot * piover180) * 0.05, zpos += Cos(yrot * piover180) * 0.05, Used := 1)
 GetKeyState("a","P") ? (zpos += Sin(yrot * piover180) * 0.05, xpos -= Cos(yrot * piover180) * 0.05, Used := 1)
 GetKeyState("d","P") ? (zpos -= Sin(yrot * piover180) * 0.05, xpos += Cos(yrot * piover180) * 0.05, Used := 1)
 GetKeyState("q","P") ? (ypos += 0.05, Used := 1)
 GetKeyState("e","P") ? (ypos -= 0.05, Used := 1)
 GetKeyState("Up","P") ? (xrot += 2.5, ((xrot > 360.0) ? (xrot -= 360.0)), Used := 1)
 GetKeyState("Down","P") ? (xrot -= 2.5, ((xrot < 0.0) ? (xrot += 360.0)), Used := 1)
 GetKeyState("Left","P") ? (yrot += 2.5, ((yrot > 360.0) ? (yrot -= 360.0)), Used := 1)
 GetKeyState("Right","P") ? (yrot -= 2.5, ((yrot < 0.0) ? (yrot += 360.0)), Used := 1)
 Used ? DrawGLScene()
 If GetKeyState("Esc","P")
  Gosub, Exit
 Sleep, 30
}
Return

DrawGLScene()
{
 global
 Critical

 glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT)
 glLoadIdentity()

 DrawObject(ObjectMain)

 DllCall("gdi32.dll\SwapBuffers","UInt",hDC)
 Return, 1
}

DrawObject(CurrentObject)
{
 global
 DllCall("opengl32.dll\glPushMatrix")
 DllCall("opengl32.dll\glPushAttrib","UInt",GL_CURRENT_BIT)

 glRotatef(360 - xrot,1.0,0,0)
 glRotatef(360 - yrot,0,1.0,0)
 glRotatef(360 - zrot,0,0,1.0)
 glTranslatef(-xpos,-ypos,-zpos)
 DllCall("opengl32.dll\glCallList","UInt",CurrentObject)
 DllCall("opengl32.dll\glPopAttrib")
 DllCall("opengl32.dll\glPopMatrix")
}