#NoEnv

Box(PosX = -1,PosY = -1,PosZ = -1,Length = 2,Height = 2,Width = 2)
{
 ListLines, Off
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
 ListLines, On
}