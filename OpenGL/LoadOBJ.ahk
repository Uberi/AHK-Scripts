#NoEnv

;LoadOBJ(A_ScriptDir . "\Mesh.obj")

LoadOBJ(ByRef Mesh,ObjectName)
{
 VerticesIndex := 1, TexCoordsIndex := 1, VertexNormalsIndex := 1
 Str := A_IsUnicode ? "AStr" : "Str"
 hOpenGL32 := DllCall("GetModuleHandle","Str","opengl32")
 pBegin := DllCall("GetProcAddress","UInt",hOpenGL32,Str,"glBegin")
 pNormal := DllCall("GetProcAddress","UInt",hOpenGL32,Str,"glNormal3f")
 pTexCoord := DllCall("GetProcAddress","UInt",hOpenGL32,Str,"glTexCoord2f")
 pVertex := DllCall("GetProcAddress","UInt",hOpenGL32,Str,"glVertex3f")
 pEnd := DllCall("GetProcAddress","UInt",hOpenGL32,Str,"glEnd")

 ListIndex := DllCall("opengl32\glGenLists","Int",1)
 DllCall("opengl32\glNewList","UInt",ListIndex,"UInt",0x1300) ;GL_COMPILE
 Loop, Parse, Mesh, `n, `r
 {
  Temp1 := InStr(A_LoopField," "), Action := SubStr(A_LoopField,1,Temp1 - 1), Temp1 := SubStr(A_LoopField,Temp1 + 1)
  If IsLabel("LoadOBJAction" . Action)
   Gosub, LoadOBJAction%Action%
 }
 DllCall("opengl32\glEndList")
 Return, ListIndex . "|0,0,0|0,0,0|1,1,1|"

 LoadOBJActionv:
 Vertices%VerticesIndex% := Temp1, VerticesIndex ++
 Return
 LoadOBJActionvt:
 TexCoords%TexCoordsIndex% := Temp1, TexCoordsIndex ++
 Return
 LoadOBJActionvn:
 VertexNormals%VertexNormalsIndex% := Temp1, VertexNormalsIndex ++
 Return
 LoadOBJActionf:
 DllCall(pBegin,"UInt",0x9) ;GL_POLYGON
 Loop, Parse, Temp1, %A_Space%
 {
  StringSplit, TempVar, A_LoopField, /
  If TempVar3
  {
   StringSplit, TempVertexNormals, VertexNormals%TempVar3%, %A_Space%
   DllCall(pNormal,"Float",TempVertexNormals1,"Float",TempVertexNormals2,"Float",TempVertexNormals3)
  }
  If TempVar2
  {
   StringSplit, TempTexCoords, TexCoords%TempVar2%, %A_Space%
   DllCall(pTexCoord,"Float",TempTexCoords1,"Float",TempTexCoords2)
  }
  StringSplit, TempVertices, Vertices%TempVar1%, %A_Space%
  DllCall(pVertex,"Float",TempVertices1,"Float",TempVertices2,"Float",TempVertices3)
 }
 DllCall(pEnd)
 Return
}