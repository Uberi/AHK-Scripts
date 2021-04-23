#NoEnv

Width := 800, Height := 600
PosX := 0, PosY := 0, PosZ := -5
RotX := 0, RotY := 4.8
ClipNear := 0.1, ClipFar := 200, FieldOfView := 90.0

SetWorkingDir, %A_ScriptDir%

UPtr := A_PtrSize ? "UPtr" : "UInt"

Gui, +LastFound
hWindow := WinExist()

;set the pixel format descriptor
VarSetCapacity(PFD,40,0), NumPut(40,PFD,0,"UShort"), NumPut(1,PFD, 2,"UShort")
NumPut(0x25,PFD,4,"UInt") ;PFD_DRAW_TO_WINDOW | PFD_SUPPORT_OPENGL | PFD_DOUBLEBUFFER
NumPut(0,PFD,8,"UChar") ;PFD_TYPE_RGBA
NumPut(24,PFD,9,"UChar") ;color bit depth
NumPut(16,PFD,23,"UChar") ;depth buffer bit depth

hDC := DllCall("GetDC",UPtr,hWindow,UPtr) ;get the device context for the viewport
DllCall("gdi32\SetPixelFormat",UPtr,hDC,"Int",DllCall("gdi32\ChoosePixelFormat",UPtr,hDC,UPtr,&PFD,"Int"),UPtr,&PFD) ;set the pixel format
hRC := DllCall("opengl32\wglCreateContext",UPtr,hDC,UPtr) ;create the rendering context
DllCall("opengl32\wglMakeCurrent",UPtr,hDC,UPtr,hRC) ;make the rendering context the current rendering context

;OpenGL initialization
DllCall("LoadLibrary","Str","opengl32") ;load libraries
DllCall("opengl32\glShadeModel","UInt",0x1D01) ;GL_SMOOTH
DllCall("opengl32\glClearDepth","Double",1.0) ;set the depth of the background
DllCall("opengl32\glClearColor","Float",0.0,"Float",0.0,"Float",0.0,"Float",1.0) ;set the background color
DllCall("opengl32\glEnable","UInt",0xB71) ;GL_DEPTH_TEST
DllCall("opengl32\glEnable","UInt",0xDE1) ;GL_TEXTURE_2D
DllCall("opengl32\glDepthFunc","UInt",0x201) ;GL_LESS
DllCall("opengl32\glHint","UInt",0xC50,"UInt",0x1102) ;GL_PERSPECTIVE_CORRECTION_HINT, GL_NICEST
DllCall("opengl32\glPolygonMode","UInt",0x408,"UInt",0x1B02) ;GL_FRONT_AND_BACK, GL_FILL

OnExit, ExitSub

Gui, +Resize +MinSize100x100
Gui, Show, w%Width% h%Height%, OBJ Viewer

Model := LoadOBJ("window.obj")

SetTimer, Draw, 50
Return

GuiClose:
ExitApp

#IfWinActive OBJ Viewer ahk_class AutoHotkeyGUI

~LButton::
CoordMode, Mouse, Relative
MouseGetPos, OffsetX, OffsetY
RotX1 := RotX, RotY1 := RotY
While, GetKeyState("LButton","P")
{
    MouseGetPos, MouseX, MouseY
    RotX := RotX1 + (((MouseX - OffsetX) / Width) * 180)
    RotY := RotY1 + (((MouseY - OffsetY) / Height) * 180)
    Sleep, 100
}
Return

Draw:
UPtr := A_PtrSize ? "UPtr" : "UInt"

DllCall("opengl32\glClear","UInt",0x4100) ;GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT
DllCall("opengl32\glLoadIdentity") ;load identity matrix

DllCall("opengl32\glTranslatef","Float",PosX,"Float",PosY,"Float",PosZ)

DllCall("opengl32\glRotatef","Float",RotY,"Float",1.0,"Float",0.0,"Float",0.0)
DllCall("opengl32\glRotatef","Float",RotX,"Float",0.0,"Float",1.0,"Float",0.0)

DllCall("opengl32\glCallList","UInt",Model) ;draw model

DllCall("gdi32\SwapBuffers",UPtr,hDC)
Return

GuiSize:
Width := A_GuiWidth, Height := A_GuiHeight
DllCall("opengl32\glViewport","Int",0,"Int",0,"Int",Width,"Int",Height)
DllCall("opengl32\glMatrixMode","UInt",0x1701) ;GL_PROJECTION
DllCall("opengl32\glLoadIdentity")
MaxY := ClipNear * Tan(FieldOfView * (3.141592 / 360)), MaxX := MaxY * (Width / Height)
DllCall("opengl32\glFrustum","Double",0 - MaxX,"Double",MaxX,"Double",0 - MaxY,"Double",MaxY,"Double",ClipNear,"Double",ClipFar)
DllCall("opengl32\glMatrixMode","UInt",0x1700) ;GL_MODELVIEW
Return

ExitSub:
UPtr := A_PtrSize ? "UPtr" : "UInt"
;DllCall("opengl32\glDeleteLists","UInt",Model,"Int",1) ;delete geometry ;wip
;DllCall("opengl32\glDeleteTextures","Int",1,"UInt",Texture) ;delete texture ;wip
DllCall("opengl32\wglMakeCurrent",UPtr,0,UPtr,0)
DllCall("opengl32\wglDeleteContext",UPtr,hRC)
ExitApp

LoadTexture(Filename,Filter = "Linear")
{
    UPtr := A_PtrSize ? "UPtr" : "UInt"
    hGDIP := DllCall("LoadLibrary","Str","gdiplus",UPtr)
    VarSetCapacity(GDIPStartupInput,16,0), NumPut(1,GDIPStartupInput)
    pToken := 0, DllCall("gdiplus\GdiplusStartup",UPtr . "*",pToken,UPtr,&GDIPStartupInput,UPtr,0)
    pBitmap := 0
    If A_IsUnicode
        DllCall("gdiplus\GdipCreateBitmapFromFile","Str",Filename,UPtr . "*",pBitmap)
    Else
    {
        FilenameLength := DllCall("MultiByteToWideChar","UInt",0,"UInt",0,"Str",Filename,"Int",-1,UPtr,0,"Int",0) << 1
        VarSetCapacity(wFilename,FilenameLength,0)
        DllCall("MultiByteToWideChar","UInt",0,"UInt",0,"Str",Filename,"Int",-1,UPtr,&wFilename,"Int",FilenameLength)
        DllCall("gdiplus\GdipCreateBitmapFromFile",UPtr,&wFilename,UPtr . "*",pBitmap)
    }
    hBitmap := 0, DllCall("gdiplus\GdipCreateHBITMAPFromBitmap",UPtr,pBitmap,UPtr . "*",hBitmap,"UInt",0xFF000000)
    DllCall("gdiplus\GdipDisposeImage",UPtr,pBitmap)
    DllCall("gdiplus\GdiplusShutdown",UPtr,pToken)
    DllCall("FreeLibrary",UPtr,hGDIP)
    If !hBitmap
        Return, 0
    VarSetCapacity(BitmapInfo,24,0)
    DllCall("GetObject",UPtr,hBitmap,"UInt",24,UPtr,&BitmapInfo)
    Bits := NumGet(BitmapInfo,20), Width := NumGet(BitmapInfo,4), Height := NumGet(BitmapInfo,8)
    Texture := 0, DllCall("opengl32\glGenTextures","Int",1,"UInt*",Texture)
    DllCall("opengl32\glBindTexture","UInt",0xDE1,"UInt",Texture) ;GL_TEXTURE_2D
    Linear := 0x2601, Nearest := 0x2600 ;GL_LINEAR, GL_NEAREST
    Filter := %Filter%
    DllCall("opengl32\glTexParameteri","UInt",0xDE1,"UInt",0x2801,"Int",Filter) ;GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER. Set the minifying filter
    DllCall("opengl32\glTexParameteri","UInt",0xDE1,"UInt",0x2800,"Int",Filter) ;GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER. Set the magnification filter
    DllCall("opengl32\glTexImage2D","UInt",0xDE1,"Int",0,"Int",4,"Int",Width,"Int",Height,"Int",0,"UInt",0x80E1,"UInt",0x1401,"UInt",Bits) ;GL_TEXTURE_2D, GL_BGRA, GL_UNSIGNED_BYTE. Import image data
    DllCall("DeleteObject",UPtr,hBitmap)
    Return, Texture
}

LoadOBJ(Path)
{
    FileRead, Mesh, %Path%

    Str := A_IsUnicode ? "AStr" : "Str", UPtr := A_PtrSize ? "UPtr" : "UInt"
    VerticesIndex := 1, TexCoordsIndex := 1, NormalsIndex := 1
    hOpenGL32 := DllCall("GetModuleHandle","Str","opengl32",UPtr)
    pBegin := DllCall("GetProcAddress",UPtr,hOpenGL32,Str,"glBegin",UPtr)
    pNormal := DllCall("GetProcAddress",UPtr,hOpenGL32,Str,"glNormal3f",UPtr)
    pTexCoord := DllCall("GetProcAddress",UPtr,hOpenGL32,Str,"glTexCoord2f",UPtr)
    pVertex := DllCall("GetProcAddress",UPtr,hOpenGL32,Str,"glVertex3f",UPtr)
    pEnd := DllCall("GetProcAddress",UPtr,hOpenGL32,Str,"glEnd",UPtr)

    MaterialsCount := 0
    Materials := "`n"
    Loop, Parse, Mesh, `n, `r
    {
        Temp1 := InStr(A_LoopField," ")
        If SubStr(A_LoopField,1,Temp1 - 1) = "mtllib"
        {
            FileRead, Material, % SubStr(A_LoopField,Temp1 + 1)
            Loop, Parse, Material, `n, `r
            {
                Temp1 := InStr(A_LoopField," "), Action := SubStr(A_LoopField,1,Temp1 - 1), Temp1 := SubStr(A_LoopField,Temp1 + 1)
                If IsLabel("LoadMTLAction_" . Action)
                    Gosub, LoadMTLAction_%Action%
            }
            Loop, %MaterialsCount%
                Materials .= Materials%A_Index%_Name . ":" . LoadTexture(Materials%A_Index%_TextureFile) . "`n"
        }
    }

    ListIndex := DllCall("opengl32\glGenLists","Int",1)
    DllCall("opengl32\glNewList","UInt",ListIndex,"UInt",0x1300) ;GL_COMPILE
    Loop, Parse, Mesh, `n, `r
    {
        Temp1 := InStr(A_LoopField," "), Action := SubStr(A_LoopField,1,Temp1 - 1), Temp1 := SubStr(A_LoopField,Temp1 + 1)
        If IsLabel("LoadOBJAction_" . Action)
            Gosub, LoadOBJAction_%Action%
    }
    DllCall("opengl32\glEndList")
    Return, ListIndex

    LoadOBJAction_o:
    ;wip
    Return
    LoadOBJAction_g:
    ;wip
    Return
    LoadOBJAction_v:
    Vertices%VerticesIndex% := Temp1, VerticesIndex ++
    Return
    LoadOBJAction_vt:
    TexCoords%TexCoordsIndex% := Temp1, TexCoordsIndex ++
    Return
    LoadOBJAction_vn:
    Normals%NormalsIndex% := Temp1, NormalsIndex ++
    Return
    LoadOBJAction_f:
    DllCall(pBegin,"UInt",0x9) ;GL_POLYGON
    Loop, Parse, Temp1, %A_Space%
    {
        StringSplit, TempVar, A_LoopField, /
        If TempVar3
        {
            If TempVar3 <= 0
                TempVar3 += NormalsIndex
            StringSplit, TempNormals, Normals%TempVar3%, %A_Space%
            DllCall(pNormal,"Float",TempNormals1,"Float",TempNormals2,"Float",TempNormals3)
        }
        If TempVar2
        {
            If TempVar2 <= 0
                TempVar2 += NormalsIndex
            StringSplit, TempTexCoords, TexCoords%TempVar2%, %A_Space%
            DllCall(pTexCoord,"Float",TempTexCoords1,"Float",TempTexCoords2)
        }
        If TempVar1 <= 0
            TempVar1 += NormalsIndex
        StringSplit, TempVertices, Vertices%TempVar1%, %A_Space%
        DllCall(pVertex,"Float",TempVertices1,"Float",TempVertices2,"Float",TempVertices3)
    }
    DllCall(pEnd)
    Return
    LoadOBJAction_usemtl:
    Temp1 := InStr(Materials,"`n" . Temp1 . ":") + StrLen(Temp1) + 2
    Temp1 := SubStr(Materials,Temp1,InStr(Materials,"`n",1,Temp1) - Temp1)
    DllCall("opengl32\glBindTexture","UInt",0xDE1,"UInt",Temp1) ;GL_TEXTURE_2D ;wip: use pBindTexture for this
    Return

    LoadMTLAction_newmtl:
    MaterialsCount ++
    Materials%MaterialsCount%_Name := Temp1
    Return
    LoadMTLAction_map_Kd:
    Materials%MaterialsCount%_TextureFile := Temp1
    Return
}