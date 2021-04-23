#NoEnv

SetBatchLines, -1

;move OpenGL cleanup code to OpenGLDeleteViewport(Viewport)
;use display lists for materials and meshes, and have meshes call the display list for materials, so materials can be modified
;fog effect, per-viewport
;global, flat namespace for materials and textures, and nestanble, local namespace of objects

/*
;Method 1: Using a GUI as the viewport

Viewport := OpenGLAddViewport()
Viewport.Width := 1000, Viewport.Height := 600 ;set the viewport size
*/

;/*
;Method 2: Using a GUI control as the viewport

Gui, Add, Text, x50 y100 w400 h400 vViewportControl
Gui, Add, Text, x550 y100 w400 h400 vViewportControl1
Viewport := OpenGLAddViewport("","ViewportControl")
Viewport1 := OpenGLAddViewport("","ViewportControl1")
Viewport.Width := 800, Viewport.Height := 400 ;set the viewport size
Viewport1.Width := 800, Viewport1.Height := 400 ;set the viewport size
*/

Viewport.BackgroundColor := 0x8080FA ;set the background color to a light blue 
Viewport1.BackgroundColor := 0x8080FA ;set the background color to a light blue 

Viewport.Camera.PosX += 4 ;move to the right 2 units
Viewport1.Camera.PosX += 4 ;move to the right 2 units

Viewport.Objects.TestBox1 := OpenGLObject().LoadData("Box.obj") ;create a new OpenGL Object, and load some data into it
Viewport1.Objects.TestBox1 := OpenGLObject().LoadData("Box.obj") ;create a new OpenGL Object, and load some data into it
Viewport1.Objects.TestBox1.PosZ += 10
TestBox1 := Viewport.Objects.TestBox1
TestBox1.PosZ += 10

/*
Viewport.Camera.Children.ParentedBox1 := TestBox1.Duplicate()
ParentedBox1 := Viewport.Camera.Children.ParentedBox1
ParentedBox1.Children.ChildBox := ParentedBox1.Duplicate()
ParentedBox1.Children.ChildBox.PosX += 5
;Viewport.Objects.Remove("TestBox1")
*/

;MsgBox % Clipboard := ShowObject(Viewport)
;MsgBox % Clipboard := ShowObject(Viewport1)

Gui, Show, w1000 h600, OpenGL Objects
;SetTimer, Draw, 20
SetTimer, Draw, 1000
Gosub, Draw
Return

Left::ParentedBox1.RotY -= 2
Right::ParentedBox1.RotY += 2
Up::TestBox1.PosZ += 0.1
Down::TestBox1.PosZ -= 0.1

GuiClose:
ExitApp

Draw:
Critical
Viewport.Draw()
Viewport1.Draw()
Return

ShowObject(ShowObject,Padding = "")
{
 ListLines, Off
 If !IsObject(ShowObject)
 {
  ListLines, On
  Return, ShowObject
 }
 ObjectContents := ""
 For Key, Value In ShowObject
 {
  If IsObject(Value)
   Value := "`n" . ShowObject(Value,Padding . A_Tab)
  ObjectContents .= Padding . Key . ": " . Value . "`n"
 }
 ObjectContents := SubStr(ObjectContents,1,-1)
 If (Padding = "")
  ListLines, On
 Return, ObjectContents
}

OpenGLObjectDuplicate(Func,DuplicateObject,ReservedList = 0)
{
 If !ReservedList
  ReservedList := Object(&DuplicateObject,"") ;keep track of unique objects within root object
 If !IsObject(DuplicateObject)
  Return, DuplicateObject
 ObjectCopy := Object("base",OpenGLObjectDuplicate("",DuplicateObject.base))
 For Key, Value In DuplicateObject
 {
  If ReservedList[&Value]
   Continue ;skip circular references
  ObjectCopy._Insert(Key,OpenGLObjectDuplicate("",Value,ReservedList))
 }
 Return, ObjectCopy
}

OpenGLObject()
{
 static LoadDataFunc := Object("base",Object("__Call","OpenGLLoadData")), DuplicateFunc := Object("base",Object("__Call","OpenGLObjectDuplicate"))
 Return, Object("PosX",0,"PosY",0,"PosZ",0,"RotX",0,"RotY",0,"RotZ",0,"ScaleX",1,"ScaleY",1,"ScaleZ",1,"Data",0,"Children",Object(),"LoadData",LoadDataFunc,"Duplicate",DuplicateFunc)
}

OpenGLLoadData(LoadData,OpenGLObject,Data)
{
 ListIndex := DllCall("opengl32\glGenLists","Int",1) ;find an empty display list slot
 DllCall("opengl32\glNewList","UInt",ListIndex,"UInt",0x1300) ;GL_COMPILE: create a new display list in the slot

 ;wip: load model here
 Box()

 DllCall("opengl32\glEndList") ;end the list
 OpenGLObject.Data := ListIndex ;set the data index for the object
 Return, OpenGLObject
}

OpenGLAddViewport(GUIIndex = "",ControlVariable = "") ;the index of the GUI to add the viewport to, the control to draw the viewport to (if blank, the entire GUI window is used)
{
 static Init, PFD, DrawFunc := Object("base",Object("__Call","OpenGLDraw"))
 If !Init
 {
  DllCall("LoadLibrary","Str","opengl32") ;load libraries

  ;OpenGL initialization
  DllCall("opengl32\glClearDepth","Double",1.0) ;set the depth of the background
  DllCall("opengl32\glEnable","UInt",0xB71) ;GL_DEPTH_TEST
  DllCall("opengl32\glEnable","UInt",0x803A) ;GL_RESCALE_NORMAL
  DllCall("opengl32\glDepthFunc","UInt",0x201) ;GL_LESS
  ;DllCall("opengl32\glEnable","UInt",0xB50) ;GL_LIGHTING ;wip
  ;DllCall("opengl32\glEnable","UInt",0x4000) ;GL_LIGHT0 ;wip
  DllCall("opengl32\glHint","UInt",0xC50,"UInt",0x1102) ;GL_PERSPECTIVE_CORRECTION_HINT, GL_NICEST
  DllCall("opengl32\glPolygonMode","UInt",0x408,"UInt",0x1B02) ;GL_FRONT_AND_BACK, GL_FILL

  ;set the pixel format descriptor
  VarSetCapacity(PFD,40,0), NumPut(40,PFD,0,"UShort"), NumPut(1,PFD, 2,"UShort")
  NumPut(0x25,PFD,4,"UInt") ;PFD_DRAW_TO_WINDOW | PFD_SUPPORT_OPENGL | PFD_DOUBLEBUFFER
  NumPut(0,PFD,8,"UChar") ;PFD_TYPE_RGBA
  NumPut(24,PFD,9,"UChar") ;color bit depth
  NumPut(16,PFD,23,"UChar") ;depth buffer bit depth
 }
 If ControlVariable = 
 {
  If GUIIndex Is Integer
   Gui, %GUIIndex%:+LastFound
  Else
   Gui, +LastFound
  hWindow := WinExist()
 }
 Else
  GuiControlGet, hWindow, hWnd, %ControlVariable%

 hDC := DllCall("GetDC","UInt",hWindow) ;get the device context for the viewport
 DllCall("gdi32\SetPixelFormat","UInt",hDC,"Int",DllCall("gdi32\ChoosePixelFormat","UInt",hDC,UPtr,&PFD,"Int"),UPtr,&PFD) ;set the pixel format
 hRC := DllCall("opengl32\wglCreateContext","UInt",hDC), DllCall("opengl32\wglMakeCurrent","UInt",hDC,"UInt",hRC) ;create a rendering context, and make it current

 Return, Object("PosX",0,"PosY",0,"Width",300,"Height",200,"FieldOfView",45.0,"ClipNear",0.5,"ClipFar",50.0,"Objects",Object(),"Draw",DrawFunc,"Camera",OpenGLObject(),"_hWindow",hWindow,"_hDC",hDC,"_hRC",hRC)
}

OpenGLSetViewport(Viewport)
{
 static LastBackgroundColor, LastPosX, LastPosY, LastWidth, LastHeight, LastFieldOfView, LastClipNear, LastClipFar
 BackgroundColor := Viewport.BackgroundColor
 If (BackgroundColor <> LastBackgroundColor)
  LastBackgroundColor := BackgroundColor, DllCall("opengl32\glClearColor","Float",((BackgroundColor & 0xFF0000) >> 16) / 256,"Float",((BackgroundColor & 0xFF00) >> 8) / 256,"Float",(BackgroundColor & 0xFF) / 256,"Float",0.0) ;set the correct clear color for the viewport

 PosX := Viewport.PosX, PosY := Viewport.PosY, Width := Viewport.Width, Height := Viewport.Height, FieldOfView := Viewport.FieldOfView, ClipNear := Viewport.ClipNear, ClipFar := Viewport.ClipFar
 If (PosX <> LastPosX || PosY <> LastPosY || Width <> LastWidth || Height <> LastHeight || FieldOfView <> LastFieldOfView || ClipNear <> LastClipNear || ClipFar <> LastClipFar) ;detect changes in the viewport, and adjust settings
 {
  LastPosX := PosX, LastPosY := PosY, LastWidth := Width, LastHeight := Height, LastFieldOfView := FieldOfView, LastClipNear := ClipNear, LastClipFar := ClipFar
  DllCall("opengl32\glViewport","Int",PosX,"Int",PosY,"Int",Width,"Int",Height) ;set viewport size
  DllCall("opengl32\glMatrixMode","UInt",0x1701) ;GL_PROJECTION
  DllCall("opengl32\glLoadIdentity") ;reset projection matrix
  MaxY := ClipNear * Tan(FieldOfView * 0.00872664626), MaxX := MaxY * (Width / Height) ;calculate viewport frustum
  DllCall("opengl32\glFrustum","Double",0 - MaxX,"Double",MaxX,"Double",0 - MaxY,"Double",MaxY,"Double",ClipNear,"Double",ClipFar) ;set viewport frustum
  DllCall("opengl32\glMatrixMode","UInt",0x1700) ;GL_MODELVIEW
 }
}

OpenGLDraw(Draw,Viewport,SwapBuffers = 1)
{
 If !IsObject(Viewport)
  Return

 OpenGLSetViewport(Viewport)

 DllCall("opengl32\glClear","UInt",0x4100) ;GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT
 DllCall("opengl32\glLoadIdentity") ;reset matrix

 Camera := Viewport.Camera ;store camera object to reduce object lookups

 For Key, Value In Camera.Children ;objects parented to the camera
  OpenGLDrawObject(Value)

 ;main camera transformation
 DllCall("opengl32\glRotatef","Float",0 - Camera.RotX,"Float",1.0,"Float",0.0,"Float",0.0)
 DllCall("opengl32\glRotatef","Float",Camera.RotY,"Float",0.0,"Float",1.0,"Float",0.0)
 DllCall("opengl32\glRotatef","Float",Camera.RotZ,"Float",0.0,"Float",0.0,"Float",1.0)
 DllCall("opengl32\glTranslatef","Float",0 - Camera.PosX,"Float",0 - Camera.PosY,"Float",Camera.PosZ)
 DllCall("opengl32\glScalef","Float",1 / Camera.ScaleX,"Float",1 / Camera.ScaleY,"Float",1 / Camera.ScaleZ)

 For Key, Value In Viewport.Objects ;objects in the scene
  OpenGLDrawObject(Value)

 ;Box(-3,,-10), Box(0,,-10), Box(3,,-10) ;draw three boxes

 If SwapBuffers
  DllCall("gdi32\SwapBuffers","UInt",Viewport._hDC)
 Return, Viewport
}

OpenGLDrawObject(OpenGLObject)
{
 ;push matrix
 DllCall("opengl32\glPushMatrix")
 DllCall("opengl32\glPushAttrib","UInt",0x1) ;GL_CURRENT_BIT

 ;do transformations
 DllCall("opengl32\glTranslatef","Float",OpenGLObject.PosX,"Float",OpenGLObject.PosY,"Float",0 - OpenGLObject.PosZ)
 DllCall("opengl32\glRotatef","Float",OpenGLObject.RotX,"Float",1.0,"Float",0.0,"Float",0.0)
 DllCall("opengl32\glRotatef","Float",0 - OpenGLObject.RotY,"Float",0.0,"Float",1.0,"Float",0.0)
 DllCall("opengl32\glRotatef","Float",0 - OpenGLObject.RotZ,"Float",0.0,"Float",0.0,"Float",1.0)
 DllCall("opengl32\glScalef","Float",OpenGLObject.ScaleX,"Float",OpenGLObject.ScaleY,"Float",OpenGLObject.ScaleZ)

 If (OpenGLObject.Data > 0) ;object contains data
  DllCall("opengl32\glCallList","UInt",OpenGLObject.Data) ;draw object

 For Key, Value In OpenGLObject.Children ;objects parented to the current object
  OpenGLDrawObject(Value)

 ;pop matrix
 DllCall("opengl32\glPopAttrib")
 DllCall("opengl32\glPopMatrix")
}

Esc::
DllCall("opengl32\wglMakeCurrent","UInt",0,"UInt",0)
DllCall("opengl32\wglDeleteContext","UInt",Viewport._hRC)
ExitApp

#Include Box.ahk