Width := 800, Height := 600
DisplayText = 
(
[14:13] <infogulch> !multiple input devices
[14:13] <robokins> Found "SendInput bug with long strings - AutoHotkey": http://www.autohotkey.com/forum/topic37968.html
[14:13] <infogulch> hurr
[14:13] <Uberi> !-1073741819
[14:13] <infogulch> !multiple mice
[14:13] <robokins> Found "Using multiple mice to control one computer. - AutoHotkey": http://www.autohotkey.com/forum/topic29496.html
[14:13] <tidbit> Uberi: tried on explorer, nothing shows up.
[14:13] <infogulch> rmax: try that ^
[14:13] <Uberi> awww
[14:13]  * tidbit closes blender
[14:14] <rmax> sweet!
[14:14] <Uberi> that's a cool solution
[14:14] <tidbit> Uberi: oh well. a screenshot will be enough :)
[14:15] <infogulch> Uberi: it crashes on my system
[14:15] <Uberi> :O
[14:15] <Uberi> why?
[14:15] <Uberi> error codes?
[14:15] <tidbit> Uberi: is it 32bit or 64? and what ahk version?
[14:15] <Uberi> all versions
[14:15] <Uberi> tested
[14:15] <Uberi> http://www.pasteall.org/pic/show.php?id=16868
[14:16] <Uberi> ^ screenie
[14:16] <Uberi> my card has no AA, so it's nice and blocky :)
[14:16] <tidbit> extruded text! sexy!
)

Gosub, Initialize
OnExit, ExitSub
Loop
{
 Gosub, Update
 Sleep, 60
}
Return

Initialize:
Ptr := A_PtrSize ? "Ptr" : "UInt" ;set compatibility constants
hGDI32 := DllCall("LoadLibrary","Str","gdi32"), hOpenGL32 := DllCall("LoadLibrary","Str","opengl32") ;load libraries

Gui, +LastFound +Resize +MinSize150x150
hWindow := WinExist()

hDC := DllCall("GetDC","UInt",hWindow)
VarSetCapacity(Struct,40,0), NumPut(40,Struct,0,"UShort"), NumPut(1,Struct, 2,"UShort")
NumPut(0x25,Struct,4,"UInt") ;PFD_DRAW_TO_WINDOW | PFD_SUPPORT_OPENGL | PFD_DOUBLEBUFFER
NumPut(0,Struct,8,"UChar") ;PFD_TYPE_RGBA
NumPut(24,Struct,9,"UChar") ;Color bit depth
NumPut(16,Struct,23,"UChar") ;Depth buffer bit depth
DllCall("gdi32\SetPixelFormat","UInt",hDC,"Int",DllCall("gdi32\ChoosePixelFormat","UInt",hDC,Ptr,&Struct,"Int"),Ptr,&Struct)
hRC := DllCall("opengl32\wglCreateContext","UInt",hDC), DllCall("opengl32\wglMakeCurrent","UInt",hDC,"UInt",hRC)

DllCall("opengl32\glShadeModel","UInt",0x1D01) ;GL_SMOOTH
DllCall("opengl32\glClearColor","Float",0.0,"Float",0.0,"Float",0.0,"Float",0.0)
DllCall("opengl32\glClearDepth","Double",1.0)
DllCall("opengl32\glEnable","UInt",0xB71) ;GL_DEPTH_TEST
DllCall("opengl32\glDepthFunc","UInt",0x201) ;GL_LESS
DllCall("opengl32\glHint","UInt",0xC50,"UInt",0x1102) ;GL_PERSPECTIVE_CORRECTION_HINT, GL_NICEST
DllCall("opengl32\glEnable","UInt",0x803A) ;GL_RESCALE_NORMAL
;DllCall("opengl32\glPolygonMode","UInt",0x408,"UInt",0x1B02) ;GL_FRONT_AND_BACK, GL_FILL

DllCall("opengl32\glEnable","UInt",0xB50) ;GL_LIGHTING
DllCall("opengl32\glEnable","UInt",0x4000) ;GL_LIGHT0
VarSetCapacity(Struct,16)
NumPut(1,Struct,0,"Float"), NumPut(1,Struct,4,"Float"), NumPut(1,Struct,8,"Float"), NumPut(1,Struct,12,"Float") ;light with color 1,1,1
DllCall("opengl32\glLightfv","UInt",0x4000,"UInt",0x1200,Ptr,&Struct) ;GL_LIGHT0, GL_AMBIENT
NumPut(1,Struct,0,"Float"), NumPut(1,Struct,4,"Float"), NumPut(1,Struct,8,"Float"), NumPut(1,Struct,12,"Float")
DllCall("opengl32\glLightfv","UInt",0x4000,"UInt",0x1201,Ptr,&Struct) ;GL_LIGHT0, GL_DIFFUSE
NumPut(Temp1,Struct,0,"Float"), NumPut(Temp2,Struct,4,"Float"), NumPut(Temp3,Struct,8,"Float"), NumPut(Temp4,Struct,12,"Float")
DllCall("opengl32\glLightfv","UInt",0x4000,"UInt",0x1202,Ptr,&Struct) ;GL_LIGHT0, GL_SPECULAR

NumPut(0,Struct,0,"Float"), NumPut(5,Struct,4,"Float"), NumPut(5,Struct,8,"Float"), NumPut(1,Struct,12,"Float") ;positional light at 0,0,0
DllCall("opengl32\glLightfv","UInt",0x4000,"UInt",0x1203,Ptr,&Struct) ;GL_LIGHT0, GL_POSITION
DllCall("opengl32\glLightf","UInt",0x4000,"UInt",0x1208,"Float",0.005) ;GL_LIGHT0, GL_LINEAR_ATTENUATION

FontList := DllCall("opengl32\glGenLists","Int",256)
hFont := DllCall("CreateFont","Int",-16,"Int",0,"Int",0,"Int",0,"Int",100,"UInt",0,"UInt",0,"UInt",0,"UInt",0,"UInt",4,"UInt",0,"UInt",4,"UInt",0,"Str","Arial")
hTempFont := DllCall("SelectObject","UInt",hDC,"UInt",hFont)
VarSetCapacity(GlyphMetrics,6144,0) ;256 * 24
DllCall("opengl32\wglUseFontOutlines" . (A_IsUnicode ? "W" : "A"),"UInt",hDC,"UInt",0,"UInt",256,"UInt",FontList,"Float",0,"Float",0.1,"Int",1,UPtr,&GlyphMetrics)
DllCall("SelectObject","UInt",hDC,"UInt",hTempFont)
DllCall("DeleteObject","UInt",hFont)
TextType := A_IsUnicode ? 0x1403 : 0x1401 ;GL_UNSIGNED_SHORT, GL_UNSIGNED_BYTE
DllCall("opengl32\glListBase","UInt",FontList)

VerticalPosition := -4
Angle := -60

Gui, Show, w%Width% h%Height%, 3D Scroller
Return

Up::VerticalPosition += 0.05
Down::VerticalPosition -= 0.05
Right::Angle ++
Left::Angle --

Update:
DllCall("opengl32\glClear","UInt",0x4100) ;GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT
DllCall("opengl32\glLoadIdentity")
DllCall("opengl32\glTranslatef","Float",-5,"Float",-1,"Float",-10)
DllCall("opengl32\glRotatef","Float",Angle,"Float",1.0,"Float",0.0,"Float",0.0)
DllCall("opengl32\glTranslatef","Float",0,"Float",VerticalPosition,"Float",0)
DllCall("opengl32\glScalef","Float",0.7,"Float",0.7,"Float",0.7)

Loop, Parse, DisplayText, `n, `r
{
 DllCall("opengl32\glPushMatrix")
 Temp1 := A_LoopField, DllCall("opengl32\glCallLists","Int",StrLen(Temp1),"UInt",TextType,Ptr,&Temp1)
 DllCall("opengl32\glPopMatrix")
 DllCall("opengl32\glTranslatef","Float",0,"Float",-1,"Float",0)
}

DllCall("gdi32\SwapBuffers","UInt",hDC)

VerticalPosition += 0.04
Return

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

GuiClose:
ExitApp

ExitSub:
DllCall("opengl32\glDeleteLists","UInt",FontList,"Int",256)
DllCall("opengl32\wglMakeCurrent","UInt",0,"UInt",0)
DllCall("opengl32\wglDeleteContext","UInt",hRC)
DllCall("FreeLibrary","UInt",hOpenGL32)
ExitApp