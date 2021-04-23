GL_Init()
{
  __GL_MCode("INIT")
  e := A_LastError
  h1 := DllCall("LoadLibrary", "str", "opengl32", __GL_PTR())
  h2 := DllCall("LoadLibrary", "str", "glu32", __GL_PTR())
  if (h3 := DllCall("LoadLibrary", "str", "gdiplus", __GL_PTR()))
  {
    VarSetCapacity(pgt, 4, 0)
    VarSetCapacity(pgi, 16, 0)
    NumPut(1, pgi)
    DllCall("gdiplus\GdiplusStartup", __GL_PTR(), &pgt, __GL_PTR(), &pgi, __GL_PTR(), 0)
    __GL_GdipToken(NumGet(pgt, 0, "uint"))
  }
  if ((h1) && (h2) && (h3))
  {
    DllCall("SetLastError", "uint", e)
    return 1.00
  }
  if (!h3)
    return -1
  return 0
}

GL_Cleanup()
{
  c1 := DllCall("FreeLibrary", __GL_PTR(), DllCall("GetModuleHandle", "str", "opengl32", __GL_PTR()))
  c2 := DllCall("FreeLibrary", __GL_PTR(), DllCall("GetModuleHandle", "str", "glu32", __GL_PTR()))
  if (hGdip := DllCall("GetModuleHandle", "str", "gdiplus", __GL_PTR()))
  {
    VarSetCapacity(pgt, 4, 0)
    NumPut(__GL_GdipToken(), pgt, 0, "uint")
    DllCall("gdiplus\GdiplusShutdown", __GL_PTR(), &pgt)
    c3 := DllCall("FreeLibrary", __GL_PTR(), hGdip)
  }
  if ((c1) && (c2))
    return 1
  return 0
}

GL_GetProcAddress(func)
{
  if (proc := DllCall("opengl32\wglGetProcAddress", __GL_ASTR(), func, __GL_PTR()))
    return proc
  if (proc := DllCall("GetProcAddress", __GL_PTR(), DllCall("GetModuleHandle", "str", "opengl32", __GL_PTR()), __GL_ASTR(), func, __GL_PTR()))
    return proc
  if (proc := DllCall("GetProcAddress", __GL_PTR(), DllCall("GetModuleHandle", "str", "glu32", __GL_PTR()), __GL_ASTR(), func, __GL_PTR()))
    return proc
}





GL_GetDC(wnd)
{
  return __GL_hDC(__GL_Wnd(wnd))
}

GL_PIXELFORMATDESCRIPTOR(byref pfd, flags, pixeltype, colorbits, rb, rs, gb, gs, bb, bs, ab, as, accumbits, arb, agb, abb, aab, depthbits, stencilbits, overlayplanes, underlayplanes, visiblemask)
{
  VarSetCapacity(pfd, 40, 0)
  NumPut(40, pfd, 0, "ushort")
  NumPut(1, pfd, 2, "ushort")
  NumPut(__GL_PFD_OR(flags), pfd, 4, "uint")
  NumPut(__GL_PFD_(pixeltype), pfd, 8, "uchar")
  NumPut(colorbits, pfd, 9, "uchar")
  NumPut(rb, pfd, 10, "uchar")
  NumPut(rs, pfd, 11, "uchar")
  NumPut(gb, pfd, 12, "uchar")
  NumPut(gs, pfd, 13, "uchar")
  NumPut(bb, pfd, 14, "uchar")
  NumPut(bs, pfd, 15, "uchar")
  NumPut(ab, pfd, 16, "uchar")
  NumPut(as, pfd, 17, "uchar")
  NumPut(accumbits, pfd, 18, "uchar")
  NumPut(arb, pfd, 19, "uchar")
  NumPut(agb, pfd, 20, "uchar")
  NumPut(abb, pfd, 21, "uchar")
  NumPut(aab, pfd, 22, "uchar")
  NumPut(depthbits, pfd, 23, "uchar")
  NumPut(stencilbits, pfd, 24, "uchar")
  NumPut((underlayplanes & 0xF) | ((overlayplanes & 0xF) << 4), pfd, 27, "uchar")
  NumPut(visiblemask, pfd, 32, "uint")
  return &pfd
}

GL_ChoosePixelFormat(hDC, ppfd)
{
  return DllCall("ChoosePixelFormat", __GL_PTR(), hDC, __GL_PTR(), ppfd)
}

GL_SetPixelFormat(hDC, pixelformat)
{
  return DllCall("SetPixelFormat", __GL_PTR(), hDC, "int", pixelformat)
}

GL_CreateContext(hDC)
{
  return DllCall("opengl32\wglCreateContext", __GL_PTR(), hDC, __GL_PTR())
}

GL_MakeCurrent(hDC, hRC)
{
  return DllCall("opengl32\wglMakeCurrent", __GL_PTR(), hDC, __GL_PTR(), hRC)
}

GL_DeleteContext(hRC)
{
  return DllCall("opengl32\wglDeleteContext", __GL_PTR(), hRC)
}

GL_GetCurrentDC()
{
  return DllCall("opengl32\wglGetCurrentDC", __GL_PTR())
}

GL_GetCurrentContext()
{
  return DllCall("opengl32\wglGetCurrentContext", __GL_PTR())
}

GL_ShareLists(hRC1, hRC2)
{
  return DllCall("opengl32\wglShareLists", __GL_PTR(), hRC1, __GL_PTR(), hRC2)
}

GL_SaveImage(file, type="BMP")
{
  filename := file
  if (p := instr(file, "\", 0, 0))
    filename := substr(file, p+1)
  if (!instr(filename, "."))
  {
    StringLower, ext, type
    file .= "." ext
  }
  if (!(hBitmap := GL_GetCurrentBitmap()))
    return 0
  VarSetCapacity(bmi, size := (20+((A_PtrSize) ? A_PtrSize : 4)), 0)
  DllCall("GetObject", __GL_PTR(), hBitmap, "int", size, __GL_PTR(), &bmi)
  w := NumGet(bmi, 4, "int")
  h := NumGet(bmi, 8, "int")
  GL_CreateBitmap(w, h, bits)
  GL_Flush()
  DllCall("opengl32\glReadPixels", "int", 0, "int", 0, "int", w, "int", h, "uint", __GL_("RGBA"), "uint", __GL_("UNSIGNED_BYTE"), __GL_PTR(), bits)
  if (DllCall("gdiplus\GdipCreateBitmapFromHBITMAP", __GL_PTR(), hBitmap, __GL_PTR(), 0, __GL_PPTR(), bitmap)!=0)
    return 0
  DllCall("gdiplus\GdipGetImageEncodersSize", "uint*", numEncoders, "uint*", size)
  VarSetCapacity(encoders, size, 0)
  DllCall("gdiplus\GdipGetImageEncoders", "uint", numEncoders, "uint", size, __GL_PTR(), &encoders)
  Loop, % numEncoders
  {
    currentEncoders := __GL_GetWSTR(NumGet(encoders, (A_Index-1)*76+44, __GL_PTR()))
    if (instr(currentEncoders ";", "*." type ";"))
      encoderAddr := (A_Index-1)*76+&encoders
  }
  if (!encoderAddr)
  {
    DllCall("gdiplus\GdipDisposeImage", __GL_PTR(), bitmap)
    return 0
  }
  result := DllCall("gdiplus\GdipSaveImageToFile", __GL_PTR(), bitmap, __GL_PTR(), __GL_PWCHAR(pfile, file), __GL_PTR(), encoderAddr, __GL_PTR(), 0)
  DllCall("gdiplus\GdipDisposeImage", __GL_PTR(), bitmap)
  return (result=0) ? 1 : 0
}







GL_UseWindow(wnd, ppfd=0)
{
  if (!(hDC := GL_GetDC(wnd)))
    return 0
  if (ppfd=0)
    ppfd := GL_PIXELFORMATDESCRIPTOR(pfd, "DRAW_TO_WINDOW | SUPPORT_OPENGL | DOUBLEBUFFER", "TYPE_RGBA", 32, 0, 0, 0, 0, 0, 0, 0, 0, 32, 0, 0, 0, 0, 24, 8, 0, 0, 0)
  if ((!(pf := GL_ChoosePixelFormat(hDC, ppfd))) || (!GL_SetPixelFormat(hDC, pf)))
    return 0
  if (!(hRC := GL_CreateContext(hDC)))
    return 0
  if (!GL_MakeCurrent(hDC, hRC))
  {
    GL_DeleteContext(hRC)
    return 0
  }
  return hRC
}






GL_BITMAPINFO(byref bmi, width, height, bitcount, compression, sizeimage, xpelspermeter, ypelspermeter, clrused, clrimportant)
{
  VarSetCapacity(bmi, 40, 0)
  NumPut(40, bmi, 0, "uint")
  NumPut(width, bmi, 4, "int")
  NumPut(height, bmi, 8, "int")
  NumPut(1, bmi, 12, "ushort")
  NumPut(bitcount, bmi, 14, "ushort")
  NumPut(__GL_BI(compression), bmi, 16, "uint")
  NumPut(sizeimage, bmi, 20, "uint")
  NumPut(xpelspermeter, bmi, 24, "int")
  NumPut(ypelspermeter, bmi, 28, "int")
  NumPut(clrused, bmi, 32, "uint")
  NumPut(clrimportant, bmi, 36, "uint")
  return &bmi
}

GL_CreateBitmap(width, height, byref bits=0, pbmi=0)
{
  if (!pbmi)
    pbmi := GL_BITMAPINFO(bmi, 0, 0, 32, 0, 0, 0, 0, 0, 0)
  if (width)
    NumPut(width, pbmi+0, 4, "int")
  if (height)
    NumPut(height, pbmi+0, 8, "int")
  return DllCall("CreateDIBSection", __GL_PTR(), GL_GetDC("GUI 99"), __GL_PTR(), pbmi, "uint", __GL_DIB_("RGB_COLORS"), __GL_PPTR(), bits, __GL_PTR(), 0, "uint", 0, __GL_PTR())
}

GL_CreateCompatibleDC(hDC)
{
  return DllCall("CreateCompatibleDC", __GL_PTR(), hDC, __GL_PTR())
}

GL_UseBitmap(hDC, hBitmap, ppfd=0)
{
  if ((!hDC) || (!hBitmap))
    return 0
  DllCall("SelectObject", __GL_PTR(), hDC, __GL_PTR(), hBitmap)
  if (ppfd=0)
    ppfd := GL_PIXELFORMATDESCRIPTOR(pfd, "DRAW_TO_BITMAP | SUPPORT_OPENGL", "TYPE_RGBA", 32, 0, 0, 0, 0, 0, 0, 0, 0, 32, 0, 0, 0, 0, 24, 8, 0, 0, 0)
  if ((!(pf := GL_ChoosePixelFormat(hDC, ppfd))) || (!GL_SetPixelFormat(hDC, pf)))
    return 0
  if (!(hRC := GL_CreateContext(hDC)))
    return 0
  if (!GL_MakeCurrent(hDC, hRC))
  {
    GL_DeleteContext(hRC)
    return 0
  }
  return hRC
}

GL_GetCurrentBitmap()
{
  if (!(hDC := GL_GetCurrentDC()))
    return 0
  return DllCall("GetCurrentObject", __GL_PTR(), hDC, "uint", 7, __GL_PTR())
}

GL_DeleteBitmap(hBitmap)
{
  return DllCall("DeleteObject", __GL_PTR(), hBitmap)
}

GL_DeleteDC(hDC)
{
  return DllCall("DeleteDC", __GL_PTR(), hDC)
}






GL_GetString(name)
{
  return __GL_GetASTR(DllCall("opengl32\glGetString", "uint", __GL_(name)))
}

GL_GetVersion()
{
  major := 0
  minor := 0
  if (p := instr(s := GL_GetString("VERSION"), " "))
    s := substr(s, 1, p-1)
  if (p := instr(s, "."))
  {
    major := substr(s, 1, p-1)
    minor := substr(s, p+1)
    if (p := instr(minor, "."))
      minor := substr(minor, 1, p-1)
    return major "." minor
  }
  return s ".0"
}

GL_IsExtension(ext)
{
  static
  if ((dc := GL_GetCurrentDC()) != lastdc)
  {
    extensions := GL_GetString("EXTENSIONS")
    lastdc := dc
  }
  return (instr(" " extensions " ", " " ext " ")) ? 1 : 0
}

GL_GetBoolean(pname, num=1, byref params=0)
{
  VarSetCapacity(params, size := num, 0)
  DllCall("opengl32\glGetBooleanv", "uint", __GL_(pname), __GL_PTR(), &params)
  return (num=1) ? NumGet(params, 0, "uchar") : size
}

GL_GetBooleanIndex(byref params, index)
{
  return NumGet(params, index-1, "uchar")
}

GL_SetBooleanIndex(byref params, index, boolean)
{
  if ((boolean != 1) && (boolean != 0))
    return 0
  NumPut(boolean, params, index-1, "uchar")
  return 1
}

GL_GetDouble(pname, num=1, byref params=0)
{
  VarSetCapacity(params, size := (num*8), 0)
  DllCall("opengl32\glGetDoublev", "uint", __GL_(pname), __GL_PTR(), &params)
  return (num=1) ? NumGet(params, 0, "double") : size
}

GL_GetDoubleIndex(byref params, index)
{
  return NumGet(params, (index-1)*8, "double")
}

GL_SetDoubleIndex(byref params, index, double)
{
  NumPut(double, params, (index-1)*8, "double")
  return 1
}

GL_GetFloat(pname, num=1, byref params=0)
{
  VarSetCapacity(params, size := (num*4), 0)
  DllCall("opengl32\glGetFloatv", "uint", __GL_(pname), __GL_PTR(), &params)
  return (num=1) ? NumGet(params, 0, "float") : size
}

GL_GetFloatIndex(byref params, index)
{
  return NumGet(params, (index-1)*4, "float")
}

GL_SetFloatIndex(byref params, index, float)
{
  NumPut(float, params, (index-1)*4, "float")
  return 1
}

GL_GetInteger(pname, num=1, byref params=0)
{
  VarSetCapacity(params, size := (num*4), 0)
  DllCall("opengl32\glGetIntegerv", "uint", __GL_(pname), __GL_PTR(), &params)
  return (num=1) ? NumGet(params, 0, "int") : size
}

GL_GetIntegerIndex(byref params, index)
{
  return NumGet(params, (index-1)*4, "int")
}

GL_SetIntegerIndex(byref params, index, integer)
{
  NumPut(integer, params, (index-1)*4, "int")
  return 1
}

GL_GetError()
{
  return __GL_FROM(DllCall("opengl32\glGetError"), "NO_ERROR INVALID_ENUM INVALID_VALUE INVALID_OPERATION STACK_OVERFLOW STACK_UNDERFLOW OUT_OF_MEMORY")
}







GL_Ortho(left, right, bottom, top, znear=-1, zfar=1)
{
  DllCall("opengl32\glOrtho", "double", left, "double", right, "double", bottom, "double", top, "double", znear, "double", zfar)
  return 1
}

GL_Frustum(left, right, bottom, top, znear=0.001, zfar=1000)
{
  DllCall("opengl32\glFrustum", "double", left, "double", right, "double", bottom, "double", top, "double", znear, "double", zfar)
  return 1
}

GL_Perspective(fovy, aspect="AUTO", znear=0.0001, zfar=1000)
{
  if (aspect="AUTO")
  {
    hBitmap := GL_GetCurrentBitmap()
    VarSetCapacity(bmi, size := (20+((A_PtrSize) ? A_PtrSize : 4)), 0)
    DllCall("GetObject", __GL_PTR(), hBitmap, "int", size, __GL_PTR(), &bmi)
    aspect := NumGet(bmi, 4, "int") / NumGet(bmi, 8, "int")
  }
  return DllCall("glu32\gluPerspective", "double", fovy, "double", aspect, "double", znear, "double", zfar)
}

GL_Viewport(x=0, y=0, width="AUTO", height="AUTO")
{
  if ((width="AUTO") || (height="AUTO"))
  {
    hBitmap := GL_GetCurrentBitmap()
    VarSetCapacity(bmi, size := (20+((A_PtrSize) ? A_PtrSize : 4)), 0)
    DllCall("GetObject", __GL_PTR(), hBitmap, "int", size, __GL_PTR(), &bmi)
    if (width="AUTO")
      width := NumGet(bmi, 4, "int")-x
    if (height="AUTO")
      height := NumGet(bmi, 8, "int")-y
  }
  DllCall("opengl32\glViewport", "int", x, "int", y, "int", width, "int", height)
  return 1
}





GL_Enable(cap)
{
  DllCall("opengl32\glEnable", "uint", __GL_(cap))
  return 1
}

GL_Disable(cap)
{
  DllCall("opengl32\glDisable", "uint", __GL_(cap))
  return 1
}

GL_IsEnabled(cap)
{
  return DllCall("opengl32\glIsEnabled", "uint", __GL_(cap), "uchar")
}

GL_Hint(mode, hint)
{
  DllCall("opengl32\glHint", "uint", __GL_(mode), "uint", __GL_(hint))
  return 1
}

GL_ShadeModel(mode)
{
  DllCall("opengl32\glShadeModel", "uint", __GL_(mode))
  return 1
}




GL_Clear(bits)
{
  DllCall("opengl32\glClear", "uint", __GL_OR(bits))
  return 1
}

GL_ClearColor(r_or_argb, g="", b="", a="")
{
  if (!__GL_Color(r_or_argb, g, b, a, xr, xg, xb, xa))
    return 0
  DllCall("opengl32\glClearColor", "float", xr, "float", xg, "float", xb, "float", xa)
  return 1
}

GL_Begin(mode)
{
  DllCall("opengl32\glBegin", "uint", __GL_(mode))
  return 1
}

GL_End()
{
  DllCall("opengl32\glEnd")
  return 1
}

GL_Vertex(x, y, z=0, w=1)
{
  DllCall("opengl32\glVertex4d", "double", x, "double", y, "double", z, "double", w)
  return 1
}

GL_Color(r_or_argb, g="", b="", a="")
{
  if (!__GL_Color(r_or_argb, g, b, a, xr, xg, xb, xa))
    return 0
  DllCall("opengl32\glColor4f", "float", xr, "float", xg, "float", xb, "float", xa)
  return 1
}

GL_TexCoord(s, t=0, r=0, q=1)
{
  DllCall("opengl32\glTexCoord4d", "double", s, "double", t, "double", r, "double", q)
  return 1
}

GL_Normal(nx, ny, nz)
{
  DllCall("opengl32\glNormal3d", "double", nx, "double", ny, "double", nz)
  return 1
}

GL_Index(c)
{
  DllCall("opengl32\glIndexd", "double", c)
  return 1
}

GL_SwapBuffers()
{
  __GL_LimitFrameRate()
  __GL_FrameRate()
  return DllCall("SwapBuffers", __GL_PTR(), GL_GetCurrentDC())
}

GL_Flush()
{
  DllCall("opengl32\glFlush")
  return 1
}





GL_PushAttrib(attrib="ALL_ATTRIB_BITS")
{
  DllCall("opengl32\glPushAttrib", "uint", __GL_(attrib))
  return 1
}

GL_PopAttrib()
{
  DllCall("opengl32\glPopAttrib")
  return 1
}






GL_MaterialAmbient(face, r_or_argb, g="", b="", a="")
{
  if (!__GL_PColorf(r_or_argb, g, b, a, color))
    return 0
  DllCall("opengl32\glMaterialfv", "uint", __GL_(face), "uint", __GL_("AMBIENT"), __GL_PTR(), &color)
  return 1
}

GL_MaterialDiffuse(face, r_or_argb, g="", b="", a="")
{
  if (!__GL_PColorf(r_or_argb, g, b, a, color))
    return 0
  DllCall("opengl32\glMaterialfv", "uint", __GL_(face), "uint", __GL_("DIFFUSE"), __GL_PTR(), &color)
  return 1
}

GL_MaterialSpecular(face, r_or_argb, g="", b="", a="")
{
  if (!__GL_PColorf(r_or_argb, g, b, a, color))
    return 0
  DllCall("opengl32\glMaterialfv", "uint", __GL_(face), "uint", __GL_("SPECULAR"), __GL_PTR(), &color)
  return 1
}

GL_MaterialEmision(face, r_or_argb, g="", b="", a="")
{
  if (!__GL_PColorf(r_or_argb, g, b, a, color))
    return 0
  DllCall("opengl32\glMaterialfv", "uint", __GL_(face), "uint", __GL_("EMISION"), __GL_PTR(), &color)
  return 1
}

GL_MaterialShininess(face, param)
{
  DllCall("opengl32\glMaterialf", "uint", __GL_(face), "uint", __GL_("SHININESS"), "float", param)
  return 1
}

GL_MaterialAmbientAndDiffuse(face, r_or_argb, g="", b="", a="")
{
  if (!__GL_PColorf(r_or_argb, g, b, a, color))
    return 0
  DllCall("opengl32\glMaterialfv", "uint", __GL_(face), "uint", __GL_("AMBIENT_AND_DIFFUSE"), __GL_PTR(), &color)
  return 1
}

GL_MaterialColorIndexes(face, ambient, diffuse, specular)
{
  VarSetCapacity(indexes, 12, 0)
  NumPut(ambient, indexes, 0, "float")
  NumPut(diffuse, indexes, 4, "float")
  NumPut(specular, indexes, 8, "float")
  DllCall("opengl32\glMaterialfv", "uint", __GL_(face), "uint", __GL_("COLOR_INDEXES"), __GL_PTR(), &indexes)
  return 1
}

GL_ColorMaterial(face, mode)
{
  DllCall("opengl32\glColorMaterial", "uint", __GL_(face), "uint", __GL_(mode))
  return 1
}





GL_IsLight(light)
{
  if ((light<1) || (light>GL_MaxLights()))
    return 0
  return 1
}

GL_EnableLight(light)
{
  if (!GL_IsLight(light))
    return 0
  DllCall("opengl32\glEnable", "uint", __GL_("LIGHT0") + light-1)
  return 1
}

GL_DisableLight(light)
{
  if (!GL_IsLight(light))
    return 0
  DllCall("opengl32\glDisable", "uint", __GL_("LIGHT0") + light-1)
  return 1
}

GL_IsLightEnabled(light)
{
  if (!GL_IsLight(light))
    return 0
  return DllCall("opengl32\glIsEnabled", "uint", __GL_("LIGHT0") + light-1, "uchar")
}

GL_MaxLights()
{
  return GL_GetInteger("MAX_LIGHTS")
}

GL_LightAmbient(light, r_or_argb, g="", b="", a="")
{
  if (!__GL_PColorf(r_or_argb, g, b, a, color))
    return 0
  DllCall("opengl32\glLightfv", "uint", __GL_("LIGHT0") + light-1, "uint", __GL_("AMBIENT"), __GL_PTR(), &color)
  return 1
}

GL_LightDiffuse(light, r_or_argb, g="", b="", a="")
{
  if (!__GL_PColorf(r_or_argb, g, b, a, color))
    return 0
  DllCall("opengl32\glLightfv", "uint", __GL_("LIGHT0") + light-1, "uint", __GL_("DIFFUSE"), __GL_PTR(), &color)
  return 1
}

GL_LightSpecular(light, r_or_argb, g="", b="", a="")
{
  if (!__GL_PColorf(r_or_argb, g, b, a, color))
    return 0
  DllCall("opengl32\glLightfv", "uint", __GL_("LIGHT0") + light-1, "uint", __GL_("SPECULAR"), __GL_PTR(), &color)
  return 1
}

GL_LightPosition(light, x, y, z=1, w=0)
{
  VarSetCapacity(params, 16, 0)
  NumPut(x, params, 0, "float")
  NumPut(y, params, 4, "float")
  NumPut(z, params, 8, "float")
  NumPut(w, params, 12, "float")
  DllCall("opengl32\glLightfv", "uint", __GL_("LIGHT0") + light-1, "uint", __GL_("POSITION"), __GL_PTR(), &params)
  return 1
}

GL_LightSpotDirection(light, x, y, z)
{
  VarSetCapacity(params, 12, 0)
  NumPut(x, params, 0, "float")
  NumPut(y, params, 4, "float")
  NumPut(z, params, 8, "float")
  DllCall("opengl32\glLightfv", "uint", __GL_("LIGHT0") + light-1, "uint", __GL_("SPOT_DIRECTION"), __GL_PTR(), &params)
  return 1
}

GL_LightSpotExponent(light, param)
{
  DllCall("opengl32\glLightf", "uint", __GL_("LIGHT0") + light-1, "uint", __GL_("SPOT_EXPONENT"), "float", param)
  return 1
}

GL_LightSpotCutoff(light, param)
{
  DllCall("opengl32\glLightf", "uint", __GL_("LIGHT0") + light-1, "uint", __GL_("SPOT_CUTOFF"), "float", param)
  return 1
}

GL_LightConstantAttenuation(light, param)
{
  DllCall("opengl32\glLightf", "uint", __GL_("LIGHT0") + light-1, "uint", __GL_("CONSTANT_ATTENUATION"), "float", param)
  return 1
}

GL_LightLinearAttenuation(light, param)
{
  DllCall("opengl32\glLightf", "uint", __GL_("LIGHT0") + light-1, "uint", __GL_("LINEAR_ATTENUATION"), "float", param)
  return 1
}

GL_LightQuadraticAttenuation(light, param)
{
  DllCall("opengl32\glLightf", "uint", __GL_("LIGHT0") + light-1, "uint", __GL_("QUADRARIC_ATTENUATION"), "float", param)
  return 1
}

GL_LightModelAmbient(r_or_argb, g="", b="", a="")
{
  if (!__GL_PColorf(r_or_argb, g, b, a, color))
    return 0
  DllCall("opengl32\glLightModelfv", "uint", __GL_("LIGHT_MODEL_AMIBENT"), __GL_PTR(), &color)
  return 1
}

GL_LightModelLocalViewer(param)
{
  DllCall("opengl32\glLightModelf", "uint", __GL_("LIGHT_MODEL_LOCAL_VIEWER"), "float", param)
  return 1
}

GL_LightModelTwoSide(param)
{
  if ((param!=1) && (param!=0))
    return 0
  DllCall("opengl32\glLightModeli", "uint", __GL_("LIGHT_MODEL_TWO_SIDE"), "int", param)
  return 1
}

GL_LightModelColorControl(param)
{
  if ((param!=1) && (param!=0))
    return 0
  DllCall("opengl32\glLightModeli", "uint", __GL_("LIGHT_MODEL_TWO_SIDE"), "int", __GL_(param))
  return 1
}




GL_LoadIdentity()
{
  DllCall("opengl32\glLoadIdentity")
  return 1
}

GL_Translate(x, y, z=0)
{
  DllCall("opengl32\glTranslated", "double", x, "double", y, "double", z)
  return 1
}

GL_Scale(x, y="x", z="x")
{
  if (y="x")
    y := x
  if (z="x")
    z := x
  DllCall("opengl32\glScaled", "double", x, "double", y, "double", z)
  return 1
}

GL_Rotate(angle, x, y, z)
{
  DllCall("opengl32\glRotated", "double", angle, "double", x, "double", y, "double", z)
  return 1
}

GL_RotateX(angle)
{
  return GL_Rotate(angle, 1, 0, 0)
}

GL_RotateY(angle)
{
  return GL_Rotate(angle, 0, 1, 0)
}

GL_RotateZ(angle)
{
  return GL_Rotate(angle, 0, 0, 1)
}

GL_PushMatrix()
{
  DllCall("opengl32\glPushMatrix")
  return 1
}

GL_PopMatrix()
{
  DllCall("opengl32\glPopMatrix")
  return 1
}

GL_MatrixMode(mode)
{
  DllCall("opengl32\glMatrixMode", "uint", __GL_(mode))
  return 1
}

GL_GetMatrixMode()
{
  return __GL_FROM(GL_GetInteger("MATRIX_MODE"), "MODELVIEW PROJECTION TEXTURE COLOR")
}

GL_GetMatrix(byref matrix)
{
  return GL_GetDouble(GL_GetMatrixMode() "_MATRIX", 16, matrix)
}

GL_SetMatrixArray(matrixaddr, m, n, value)
{
  if ((!matrixaddr) || (m<1) || (m>4) || (n<1) || (n>4))
    return 0
  NumPut(value, matrixaddr+0, m*4+n, "double")
  return 1
}

GL_GetMatrixArray(matrixaddr, m, n)
{
  if ((!matrixaddr) || (m<1) || (m>4) || (n<1) || (n>4))
    return 0
  return NumGet(matrixaddr+0, m*4+n, "double")
}

GL_LoadMatrix(matrixaddr)
{
  DllCall("opengl32\glLoadMatrixd", __GL_PTR(), matrixaddr)
  return 1
}

GL_MultMatrix(matrixaddr)
{
  DllCall("opengl32\glMultMatrixd", __GL_PTR(), matrixaddr)
  return 1
}






GL_DepthFunc(func="LEQUAL")
{
  DllCall("opengl32\glDepthFunc", "uint", __GL_(func))
  return 1
}

GL_ClearDepth(depth)
{
  DllCall("opengl32\glClearDepth", "double", depth)
  return 1
}

GL_GetDepthFunc()
{
  return __GL_FROM(GL_GetInteger("DEPTH_FUNC"), "NEVER LESS EQUAL LEQUAL GREATER NOTEQUAL GEQUAL ALWAYS")
}

GL_DepthRange(znear=0, zfar=1)
{
  DllCall("opengl32\glDepthRange", "double", znear, "double", zfar)
  return 1
}

GL_PolygonOffset(factor=0, units=0)
{
  DllCall("opengl32\glPolygonOffset", "float", factor, "float", units)
  return 1
}










GL_GenTexture()
{
  VarSetCapacity(textures, 4, 0)
  DllCall("opengl32\glGenTextures", "uint", 1, __GL_PTR(), &textures)
  return NumGet(textures, 0, "uint")
}

GL_DeleteTexture(texture)
{
  VarSetCapacity(textures, 4, 0)
  NumPut(texture, textures, 0, "uint")
  DllCall("opengl32\glDeleteTextures", "uint", 1, __GL_PTR(), &textures)
  return 1
}

GL_IsTexture(texture)
{
  return DllCall("opengl32\glIsTexture", "uint", texture, "uchar")
}

GL_BindTexture(target, texture)
{
  DllCall("opengl32\glBindTexture", "uint", __GL_TexTarget(target), "uint", texture)
  return 1
}

GL_GetTextureBinding1D()
{
  return GL_GetInteger("TEXTURE_BINDING_1D")
}

GL_GetTextureBinding2D()
{
  return GL_GetInteger("TEXTURE_BINDING_2D")
}

GL_GetTextureBinding3D()
{
  return GL_GetInteger("TEXTURE_BINDING_3D")
}

GL_GetTextureBindingCubeMap()
{
  return GL_GetInteger("TEXTURE_BINDING_CUBE_MAP")
}

GL_TexParameterMinFilter(target, param)
{
  DllCall("opengl32\glTexParameteri", "uint", __GL_TexTarget(target), "uint", __GL_("TEXTURE_MIN_FILTER"), "int", __GL_(param))
  return 1
}

GL_TexParameterMagFilter(target, param)
{
  DllCall("opengl32\glTexParameteri", "uint", __GL_TexTarget(target), "uint", __GL_("TEXTURE_MAG_FILTER"), "int", __GL_(param))
  return 1
}

GL_TexParameterMinLod(target, param)
{
  DllCall("opengl32\glTexParameterf", "uint", __GL_TexTarget(target), "uint", __GL_("TEXTURE_MIN_LOD"), "float", param)
  return 1
}

GL_TexParameterMaxLod(target, param)
{
  DllCall("opengl32\glTexParameterf", "uint", __GL_TexTarget(target), "uint", __GL_("TEXTURE_MAX_LOD"), "float", param)
  return 1
}

GL_TexParameterBaseLevel(target, param)
{
  DllCall("opengl32\glTexParameteri", "uint", __GL_TexTarget(target), "uint", __GL_("TEXTURE_BASE_LEVEL"), "int", param)
  return 1
}

GL_TexParameterMaxLevel(target, param)
{
  DllCall("opengl32\glTexParameteri", "uint", __GL_TexTarget(target), "uint", __GL_("TEXTURE_MAX_LEVEL"), "int", param)
  return 1
}

GL_TexParameterWrapS(target, param)
{
  DllCall("opengl32\glTexParameteri", "uint", __GL_TexTarget(target), "uint", __GL_("TEXTURE_WRAP_S"), "int", __GL_(param))
  return 1
}

GL_TexParameterWrapT(target, param)
{
  DllCall("opengl32\glTexParameteri", "uint", __GL_TexTarget(target), "uint", __GL_("TEXTURE_WRAP_T"), "int", __GL_(param))
  return 1
}

GL_TexParameterWrapR(target, param)
{
  DllCall("opengl32\glTexParameteri", "uint", __GL_TexTarget(target), "uint", __GL_("TEXTURE_WRAP_R"), "int", __GL_(param))
  return 1
}

GL_TexParameterBorderColor(target, r_or_argb, g="", b="", a="")
{
  if (!__GL_PColorf(r_or_argb, g, b, a, color))
    return 0
  DllCall("opengl32\glTexParameterfv", "uint", __GL_TexTarget(target), "uint", __GL_("TEXTURE_BORDER_COLOR"), __GL_PTR(), &color)
  return 1
}

GL_TexParameterPriority(target, param)
{
  DllCall("opengl32\glTexParameterf", "uint", __GL_TexTarget(target), "uint", __GL_("TEXTURE_PRIORITY"), "float", param)
  return 1
}

GL_TexParameterCompareMode(target, param)
{
  DllCall("opengl32\glTexParameteri", "uint", __GL_TexTarget(target), "uint", __GL_("TEXTURE_COMPARE_MODE"), "int", __GL_(param))
  return 1
}

GL_TexParameterCompareFunc(target, param)
{
  DllCall("opengl32\glTexParameteri", "uint", __GL_TexTarget(target), "uint", __GL_("TEXTURE_COMPARE_FUNC"), "int", __GL_(param))
  return 1
}

GL_TexParameterDepthTextureMode(target, param)
{
  DllCall("opengl32\glTexParameteri", "uint", __GL_TexTarget(target), "uint", __GL_("DEPTH_TEXTURE_MODE"), "int", __GL_(param))
  return 1
}

GL_TexParameterGenerateMipmap(target, param)
{
  DllCall("opengl32\glTexParameteri", "uint", __GL_TexTarget(target), "uint", __GL_("GENERATE_MIPMAP"), "int", __GL_(param))
  return 1
}

GL_TexGenMode(coord, param)
{
  DllCall("opengl32\glTexGeni", "uint", __GL_(coord), "uint", __GL_("TEXTURE_GEN_MODE"), "int", __GL_(param))
  return 1
}

GL_TexGenObjectLinear(coord, param1, param2, param3, param4)
{
  VarSetCapacity(params, 16, 0)
  Loop, 4
    NumPut(param%A_Index%, params, (A_Index-1)*4, "float")
  DllCall("opengl32\glTexGenfv", "uint", __GL_(coord), "uint", __GL_("OBJECT_LINEAR"), __GL_PTR(), &params)
  return 1
}

GL_TexGenEyeLinear(coord, param1, param2, param3, param4)
{
  VarSetCapacity(params, 16, 0)
  Loop, 4
    NumPut(param%A_Index%, params, (A_Index-1)*4, "float")
  DllCall("opengl32\glTexGenfv", "uint", __GL_(coord), "uint", __GL_("EYE_LINEAR"), __GL_PTR(), &params)
  return 1
}

GL_TexGenSphereMap(coord, param1, param2, param3, param4)
{
  VarSetCapacity(params, 16, 0)
  Loop, 4
    NumPut(param%A_Index%, params, (A_Index-1)*4, "float")
  DllCall("opengl32\glTexGenfv", "uint", __GL_(coord), "uint", __GL_("SPHERE_MAP"), __GL_PTR(), &params)
  return 1
}

GL_TexImage1D(target, level, internalformat, width, border, format, type, data)
{
  DllCall("opengl32\glTexImage1D", "uint", __GL_TexTarget(target), "int", level, "int", __GL_(internalformat), "int", width, "int", border, "uint", __GL_(format), "uint", __GL_(type), __GL_PTR(), data)
  return 1
}

GL_TexImage2D(target, level, internalformat, width, height, border, format, type, data)
{
  DllCall("opengl32\glTexImage2D", "uint", __GL_TexTarget(target), "int", level, "int", __GL_(internalformat), "int", width, "int", height, "int", border, "uint", __GL_(format), "uint", __GL_(type), __GL_PTR(), data)
  return 1
}

GL_TexImage3D(target, level, internalformat, width, height, depth, border, format, type, data)
{
  DllCall("opengl32\glTexImage3D", "uint", __GL_TexTarget(target), "int", level, "int", __GL_(internalformat), "int", width, "int", height, "int", depth, "int", border, "uint", __GL_(format), "uint", __GL_(type), __GL_PTR(), data)
  return 1
}

GL_Build1DMipmaps(target, internalformat, width, format, type, data)
{
  DllCall("glu32\gluBuild1DMipmaps", "uint", __GL_TexTarget(target), "int", __GL_(internalformat), "int", width, "uint", __GL_(format), "uint", __GL_(type), __GL_PTR(), data)
  return 1
}

GL_Build2DMipmaps(target, components, width, height, format, type, data)
{
  DllCall("glu32\gluBuild2DMipmaps", "uint", __GL_TexTarget(target), "int", components, "int", width, "int", height, "uint", __GL_(format), "uint", __GL_(type), __GL_PTR(), data)
  return 1
}

GL_LoadTexImage1D(target, filename, internalformat=4, minfilter="LINEAR", magfilter="LINEAR")
{
  if (!fileexist(filename))
    return 0

  if (hbm := __GL_GDIP_Load(filename, 0, w, h, bmbits, format))
  {
    target := __GL_TexTarget(target)
    texture := GL_GenTexture()
    old_tex := GL_GetTextureBinding1D()
    GL_BindTexture(target, texture)
    GL_TexParameterMinFilter(target, minfilter)
    GL_TexParameterMagFilter(target, magfilter)
    GL_TexImage1D(target, 0, internalformat, w, 0, format, "UNSIGNED_BYTE", bmbits)
    __GL_GDIP_Delete(hbm)
    if (old_tex)
      GL_BindTexture(target, oldtex)
    return texture
  }
  return 0
}

GL_LoadTexImage2D(target, filename, internalformat=4, minfilter="LINEAR", magfilter="LINEAR")
{
  if (!fileexist(filename))
    return 0

  if (hbm := __GL_GDIP_Load(filename, 0, w, h, bmbits, format))
  {
    target := __GL_TexTarget(target)
    texture := GL_GenTexture()
    old_tex := GL_GetTextureBinding2D()
    GL_BindTexture(target, texture)
    GL_TexParameterMinFilter(target, minfilter)
    GL_TexParameterMagFilter(target, magfilter)
    GL_TexImage2D(target, 0, internalformat, w, h, 0, format, "UNSIGNED_BYTE", bmbits)
    __GL_GDIP_Delete(hbm)
    if (old_tex)
      GL_BindTexture(target, oldtex)
    return texture
  }
  return 0
}

GL_Load1DMipmaps(target, filename, internalformat=4, minfilter="LINEAR_MIPMAP_NEAREST", magfilter="LINEAR")
{
  if (!fileexist(filename))
    return 0

  if (hbm := __GL_GDIP_Load(filename, 1, w, h, bmbits, format))
  {
    target := __GL_TexTarget(target)
    texture := GL_GenTexture()
    old_tex := GL_GetTextureBinding1D()
    GL_BindTexture(target, texture)
    GL_TexParameterMinFilter(target, minfilter)
    GL_TexParameterMagFilter(target, magfilter)
    GL_Build1DMipmaps(target, internalformat, w, format, "UNSIGNED_BYTE", bmbits)
    __GL_GDIP_Delete(hbm)
    if (old_tex)
      GL_BindTexture(target, oldtex)
    return texture
  }
  return 0
}

GL_Load2DMipmaps(target, filename, components=4, minfilter="LINEAR_MIPMAP_NEAREST", magfilter="LINEAR")
{
  if (!fileexist(filename))
    return 0

  if (hbm := __GL_GDIP_Load(filename, 1, w, h, bmbits, format))
  {
    target := __GL_TexTarget(target)
    texture := GL_GenTexture()
    old_tex := GL_GetTextureBinding2D()
    GL_BindTexture(target, texture)
    GL_TexParameterMinFilter(target, minfilter)
    GL_TexParameterMagFilter(target, magfilter)
    GL_Build2DMipmaps(target, components, w, h, format, "UNSIGNED_BYTE", bmbits)
    __GL_GDIP_Delete(hbm)
    if (old_tex)
      GL_BindTexture(target, oldtex)
    return texture
  }
  return 0
}







GL_GenLists(range=1)
{
  return DllCall("opengl32\glGenLists", "uint", range, "uint")
}

GL_DeleteLists(list, range=1)
{
  DllCall("opengl32\glDeleteLists", "uint", list, "uint", range)
  return 1
}

GL_NewList(list, mode="COMPILE")
{
  DllCall("opengl32\glNewList", "uint", list, "uint", __GL_(mode))
  return 1
}

GL_EndList()
{
  DllCall("opengl32\glEndList")
  return 1
}

GL_ListBase(base)
{
  DllCall("opengl32\glListBase", "uint", base)
  return 1
}

GL_CallList(list)
{
  DllCall("opengl32\glCallList", "uint", list)
  return 1
}

GL_CallLists(num, type, addr)
{
  DllCall("opengl32\glCallLists", "uint", num, "uint", __GL_(type), __GL_PTR(), addr)
  return 1
}





GL_BlendFunc(src, dst)
{
  DllCall("opengl32\glBlendFunc", "uint", __GL_(src), "uint", __GL_(dst))
  return 1
}





GL_CullFace(face)
{
  DllCall("opengl32\glCullFace", "uint", __GL_(face))
  return 1
}







GL_Accum(op, value)
{
  DllCall("opengl32\glAccum", "uint", __GL_(op), "float", value)
  return 1
}

GL_ClearAccum(r_or_argb, g="", b="", a="")
{
  if (!__GL_Color(r_or_argb, g, b, a, xr, xg, xb, xa))
    return 0
  DllCall("opengl32\glClearAccum", "float", xr, "float", xg, "float", xb, "float", xa)
  return 1
}





GL_Sphere(stacks, slices, radius=1)
{
  if ((quadric := DllCall("glu32\gluNewQuadric", __GL_PTR()))=0)
    return 0
  DllCall("glu32\gluQuadricTexture", __GL_PTR(), quadric, "uchar", 1)
  result := DllCall("glu32\gluSphere", __GL_PTR(), quadric, "double", radius, "int", slices, "int", stacks)
  DllCall("glu32\gluDeleteQuadric", __GL_PTR(), quadric)
  return result
}






GL_CreateTextureAnimation(tex, h, v, sh=1, sv="sh", z=0, callback="", pushattrib="ALL_ATTRIB_BITS")
{
  if (sv="sh")
    sv := sh
  sh := sh/2
  sv := sv/2
  list := GL_GenLists(h*v)
  n := 0
  Loop, % v
  {
    t := (A_Index-1)/v
    Loop, % h
    {
      s := (A_Index-1)/h
      GL_NewList(list+n)
      GL_PushAttrib(pushattrib)
      if (callback="")
      {
        GL_Disable("DEPTH_TEST")
        GL_Disable("LIGHTING")
        GL_Enable("BLEND")
        GL_BlendFunc("SRC_ALPHA", "ONE_MINUS_SRC_ALPHA")
        GL_Disable("TEXTURE_GEN_S")
        GL_Disable("TEXTURE_GEN_T")
        GL_Enable("TEXTURE_2D")
        GL_BindTexture("TEXTURE_2D", tex)
      }
      else
        %calback%(n+1)
      GL_Begin("QUADS")
      GL_TexCoord(s, 1-t)
      GL_Vertex(-sh, sv, z)
      GL_TexCoord(s, 1-t-(1/v))
      GL_Vertex(-sh, -sv, z)
      GL_TexCoord(s+(1/h), 1-t-(1/v))
      GL_Vertex(sh, -sv, z)
      GL_TexCoord(s+(1/h), 1-t)
      GL_Vertex(sh, sv, z)
      GL_End()
      GL_PopAttrib()
      GL_EndList()
      n++
    }
  }
  return list
}

GL_CalcDistance(p1x, p1y, p1z, p2x, p2y, p2z)
{
  return sqrt((sqrt((abs(p1x-p2x)**2)+(abs(p1y-p2y)**2))**2)+(abs(p1z-p2z)**2))
}

GL_IsPointBetween(p, m1, m2, m3="", m4="")
{
  if (__GL_Between(p, m1, m2))
    return 1
  if ((m3!="") && (__GL_Between(p, m1, m3)))
    return 1
  if ((m4!="") && (__GL_Between(p, m1, m4)))
    return 1
  return 0
}

__GL_Distance(p1x, p1y, p2x, p2y)
{
  return sqrt((abs(p1x-p2x)**2)+(abs(p1y-p2y)**2))
}

__GL_Between(p, m1, m2)
{
  return ((((p>m1) && (p<=m2)) || ((p>m2) && (p<=m1))))
}

GL_IsPointInTriangle(px, py, t1x, t1y, t2x, t2y, t3x, t3y)
{
  if (((t1x<=px) && (t2x<=px) && (t3x>px)) || ((t1x>px) && (t2x>px) && (t3x<=px)))
    return __GL_Between(py, t3y+((px-t3x)*(t1y-t3y)/(t1x-t3x)), t3y+((px-t3x)*(t2y-t3y)/(t2x-t3x)))
  if (((t1x<=px) && (t2x>px) && (t3x<=px)) || ((t1x>px) && (t2x<=px) && (t3x>px)))
    return __GL_Between(py, t2y+((px-t2x)*(t1y-t2y)/(t1x-t2x)), t2y+((px-t2x)*(t3y-t2y)/(t3x-t2x)))
  if (((t1x>px) && (t2x<=px) && (t3x<=px)) || ((t1x<=px) && (t2x>px) && (t3x>px)))
    return __GL_Between(py, t1y+((px-t1x)*(t2y-t1y)/(t2x-t1x)), t1y+((px-t1x)*(t3y-t1y)/(t3x-t1x)))
  return 0
}

GL_IsPointInQuad(px, py, q1x, q1y, q2x, q2y, q3x, q3y, q4x, q4y)
{
  return (GL_IsPointInTriangle(px, py, q1x, q1y, q2x, q2y, q3x, q3y) || GL_IsPointInTriangle(px, py, q2x, q2y, q4x, q4y, q3x, q3y))
}

GL_IsPointInCircle(px, py, cx, cy, r)
{
  return (sqrt((abs(px-cx)**2)+(abs(py-cy)**2))<=r)
}

GL_CalcClip(byref clip, p="", m="")
{
  if (p="")
    p := GL_GetDouble("PROJECTION_MATRIX", 16, p_p)
  if (m="")
    m := GL_GetDouble("MODELVIEW_MATRIX", 16, p_m)
  Loop, 16
  {
    p_%A_Index% := NumGet(p+0, (A_Index-1)*8, "double")
    m_%A_Index% := NumGet(m+0, (A_Index-1)*8, "double")
  }
  c_1  := m_1*p_1  + m_2*p_5  + m_3*p_9   + m_4*p_13
  c_2  := m_1*p_2  + m_2*p_6  + m_3*p_10  + m_4*p_14
  c_3  := m_1*p_3  + m_2*p_7  + m_3*p_11  + m_4*p_15
  c_4  := m_1*p_4  + m_2*p_8  + m_3*p_12  + m_4*p_16
  c_5  := m_5*p_1  + m_6*p_5  + m_7*p_9   + m_8*p_13
  c_6  := m_5*p_2  + m_6*p_6  + m_7*p_10  + m_8*p_14
  c_7  := m_5*p_3  + m_6*p_7  + m_7*p_11  + m_8*p_15
  c_8  := m_5*p_4  + m_6*p_8  + m_7*p_12  + m_8*p_16
  c_9  := m_9*p_1  + m_10*p_5 + m_11*p_9  + m_12*p_13
  c_10 := m_9*p_2  + m_10*p_6 + m_11*p_10 + m_12*p_14
  c_11 := m_9*p_3  + m_10*p_7 + m_11*p_11 + m_12*p_15
  c_12 := m_9*p_4  + m_10*p_8 + m_11*p_12 + m_12*p_16
  c_13 := m_13*p_1 + m_14*p_5 + m_15*p_9  + m_16*p_13
  c_14 := m_13*p_2 + m_14*p_6 + m_15*p_10 + m_16*p_14
  c_15 := m_13*p_3 + m_14*p_7 + m_15*p_11 + m_16*p_15
  c_16 := m_13*p_4 + m_14*p_8 + m_15*p_12 + m_16*p_16

  f_1_1 := c_4-c_1    ;RIGHT
  f_1_2 := c_8-c_5
  f_1_3 := c_12-c_9
  f_1_4 := c_16-c_13
  f_2_1 := c_4+c_1    ;LEFT
  f_2_2 := c_8+c_5
  f_2_3 := c_12+c_9
  f_2_4 := c_16+c_13
  f_3_1 := c_4-c_2    ;BOTTOM
  f_3_2 := c_8-c_6
  f_3_3 := c_12-c_10
  f_3_4 := c_16-c_14
  f_4_1 := c_4+c_2    ;TOP
  f_4_2 := c_8+c_6
  f_4_3 := c_12+c_10
  f_4_4 := c_16+c_14
  f_5_1 := c_4-c_3    ;FAR
  f_5_2 := c_8-c_7
  f_5_3 := c_12-c_11
  f_5_4 := c_16-c_15
  f_6_1 := c_4+c_3    ;NEAR
  f_6_2 := c_8+c_7
  f_6_3 := c_12+c_11
  f_6_4 := c_16+c_15

  VarSetCapacity(frustum, 128, 0)
  Loop, 6
  {
    m := sqrt(f_%A_Index%_1**2) + (f_%A_Index%_2**2) + (f_%A_Index%_3**2)
    NumPut(f_%A_Index%_1 / m, clip, (A_Index-1)*32, "double")
    NumPut(f_%A_Index%_2 / m, clip, (A_Index-1)*32+8, "double")
    NumPut(f_%A_Index%_3 / m, clip, (A_Index-1)*32+16, "double")
    NumPut(f_%A_Index%_4 / m, clip, (A_Index-1)*32+24, "double")
  }
  return &frustum
}

GL_IsPointInClip(x, y, z, clip=0)
{
  if (clip = 0)
    clip := GL_CalcClip(bclip)
  Loop, 6
  {
    f_1 := NumGet(clip+0, (A_Index-1)*32, "double")
    f_2 := NumGet(clip+0, (A_Index-1)*32+8, "double")
    f_3 := NumGet(clip+0, (A_Index-1)*32+16, "double")
    f_4 := NumGet(clip+0, (A_Index-1)*32+24, "double")
    if ((f_1*x + f_2*y + f_3*z + f_4) <= 0)
      return 0
  }
  return 1
}

GL_IsSphereInClip(x, y, z, radius, clip=0)
{
  if (clip = 0)
    clip := GL_CalcClip(bclip)
  Loop, 6
  {
    f_1 := NumGet(clip+0, (A_Index-1)*32, "double")
    f_2 := NumGet(clip+0, (A_Index-1)*32+8, "double")
    f_3 := NumGet(clip+0, (A_Index-1)*32+16, "double")
    f_4 := NumGet(clip+0, (A_Index-1)*32+24, "double")
    if ((f_1*x + f_2*y + f_3*z + f_4) <= -radius)
      return 0
  }
  return 1
}

GL_IsBoxInClip(BoxX, BoxY, BoxZ, BoxWidth, BoxHeight, BoxDepth, clip=0)
{
  if (pfrustum = 0)
    clip := GL_CalcClip(bclip)
  x := BoxX
  y := BoxY
  z := BoxZ
  wx := BoxWidth/2
  wy := BoxHeight/2
  wz := BoxDepth/2
  Loop, 6
  {
    f_1 := NumGet(clip+0, (A_Index-1)*32, "double")
    f_2 := NumGet(clip+0, (A_Index-1)*32+8, "double")
    f_3 := NumGet(clip+0, (A_Index-1)*32+16, "double")
    f_4 := NumGet(clip+0, (A_Index-1)*32+24, "double")
    if ((f_1*(x-wx) + f_2*(y-wy) + f_3*(z-wz) + f_4) > 0)
      continue
    if ((f_1*(x+wx) + f_2*(y-wy) + f_3*(z-wz) + f_4) > 0)
      continue
    if ((f_1*(x-wx) + f_2*(y+wy) + f_3*(z-wz) + f_4) > 0)
      continue
    if ((f_1*(x+wx) + f_2*(y+wy) + f_3*(z-wz) + f_4) > 0)
      continue
    if ((f_1*(x-wx) + f_2*(y-wy) + f_3*(z+wz) + f_4) > 0)
      continue
    if ((f_1*(x+wx) + f_2*(y-wy) + f_3*(z+wz) + f_4) > 0)
      continue
    if ((f_1*(x-wx) + f_2*(y+wy) + f_3*(z+wz) + f_4) > 0)
      continue
    if ((f_1*(x+wx) + f_2*(y+wy) + f_3*(z+wz) + f_4) > 0)
      continue
    return 0
  }
  return 1
}

GL_ProjectCurrent(objx, objy, objz, byref winx, byref winy, byref winz)
{
  ptr := __GL_PTR()
  GL_GetDouble("MODELVIEW_MATRIX", 16, m)
  GL_GetDouble("PROJECTION_MATRIX", 16, p)
  GL_GetInteger("VIEWPORT", 4, v)
  return DllCall("glu32\gluProject", "double", objx, "double", objy, "double", objz, ptr, &m, ptr, &p, ptr, &v, "double*", winx, "double*", winy, "double*", winz)
}

GL_UnProjectCurrent(winx, winy, winz, byref objx, byref objy, byref objz)
{
  ptr := __GL_PTR()
  GL_GetDouble("MODELVIEW_MATRIX", 16, m)
  GL_GetDouble("PROJECTION_MATRIX", 16, p)
  GL_GetInteger("VIEWPORT", 4, v)
  return DllCall("glu32\gluUnProject", "double", winx, "double", winy, "double", winz, ptr, &m, ptr, &p, ptr, &v, "double*", objx, "double*", objy, "double*", objz)
}

GL_Project(objx, objy, objz, m, p, v, byref winx, byref winy, byref winz)
{
  ptr := __GL_PTR()
  return DllCall("glu32\gluProject", "double", objx, "double", objy, "double", objz, ptr, m, ptr, p, ptr, v, "double*", winx, "double*", winy, "double*", winz)
}

GL_UnProject(winx, winy, winz, m, p, v, byref objx, byref objy, byref objz)
{
  ptr := __GL_PTR()
  return DllCall("glu32\gluUnProject", "double", winx, "double", winy, "double", winz, ptr, m, ptr, p, ptr, v, "double*", objx, "double*", objy, "double*", objz)
}

GL_TranslateUnProject(winx, winy, winz, m, p, v)
{
  ptr := __GL_PTR()
  result := DllCall("glu32\gluUnProject", "double", winx, "double", winy, "double", winz, ptr, m, ptr, p, ptr, v, "double*", objx, "double*", objy, "double*", objz)
  DllCall("opengl32\glTranslatei", "int", Round(objx), "int", Round(objy), "int", Round(objz))
  return result
}

GL_GetFramesPerSecond()
{
  return __GL_FrameRate("PER_SECOND")
}

GL_LimitFrameRate(maxfps)
{
  if (maxfps="")
    return 0
  return __GL_LimitFrameRate(maxfps)
}










__GL_MCode(code="")
{
  static
  if (code="INIT")
  {
    code = ;GL_IsPointInTriangle = 1
    (Join Ltrim
      558BECDD4508DD4518D8D1DFE0DD4538DD4528F6C4417A16D8D3DFE0F6C4417A
      0DD9C9D8D3DFE0F6C4417427D9C9D9CAD8D3DFE0F6C4410F8580000000D9CAD8
      D3DFE0F6C4417573D9C9D8D3DFE0F6C4417A66DCEBDD4520DD4540DCE9D9C9D8
      CDD9CCD8E2DEFCDCC3DD4530D8E1DECDD9CADEE1DEFBDEC2DD4510D8D1DFE0F6
      C4417509D8D2DFE0F6C4417B1AD8D2DFE0DDDAF6C441751ADED9DFE0F6C4010F
      85F3000000EB06DDD8DDD9DDD833C0405DC3DDD9E9DD000000D9C9D9CAD8D3DF
      E0F6C4417A1AD9CAD8D3DFE0F6C441750DD9C9D8D3DFE0F6C4417B23D9C9D9CA
      D8D3DFE0F6C441754DD9CAD8D3DFE0F6C4417A40D9C9D8D3DFE0F6C441752AD9
      CBD8E1DD4520DD4530DCE9D9C9D8CAD9CCD8E3DEFCDCC3DD4540D8E1DECAD9CC
      DEE2DEF1E94DFFFFFFD8D3DFE0F6C4417B23D9C9D9CAD8D3DFE0F6C4417A42D9
      CAD8D3DFE0F6C4417540D9C9D8D3DFE0F6C441753BD9CBD8E2DD4530DD4520DC
      E9D9C9D8CAD9CBD8E4DEFBDCC2DD4540D8E1DECAD9CCDEE3DEF2D9C9E9F5FEFF
      FFDDDBDDD8E928FFFFFFDDDBDDD8EB04DDDBDDDADDD8DDD833C05DC3

    )
    VarSetCapacity(code1b, s := strlen(code)/2)
    Pcode1 := __GL_GetMCode(&code1b, code, s)
    code := ""
    return 1
  }
  return Pcode%code%
}

__GL_GetMCode(addr, code, s)
{
  Loop % s
    NumPut("0x" . SubStr(code, 2*A_Index-1 ,2), addr+0, A_Index-1, "uchar")
  return addr
}

__GL_PTR()
{
  return (A_PtrSize) ? "ptr" : "uint"
}

__GL_PPTR()
{
  return (__GL_PTR() "*")
}

__GL_ASTR()
{
  return (A_IsUnicode) ? "astr" : "str"
}

__GL_PWCHAR(byref wchar, str)
{
  VarSetCapacity(wchar, size := (strlen(str)*2+2), 0)
  if ((!A_IsUnicode) && (!A_PtrSize))
  {
    DllCall("MultiByteToWideChar", "uint", 0, "uint", 0, __GL_PTR(), &str, "int", -1, __GL_PTR(), &wchar, "int", size)
    return &wchar
  }
  StrPut := "StrPut"
  %StrPut%(str, &wchar, strlen(str)+1, "cp1200")
  return &wchar
}

__GL_GetWSTR(address)
{
  if ((!A_IsUnicode) && (!A_PtrSize))
  {
    size := DllCall("WideCharToMultiByte", "uint", 0, "uint", 0, __GL_PTR(), address, "int", -1, __GL_PTR(), 0, "int", 0, __GL_PTR(), 0, __GL_PTR(), 0)
    VarSetCapacity(str, size, 0)
    DllCall("WideCharToMultiByte", "uint", 0, "uint", 0, __GL_PTR(), address, "int", -1, __GL_PTR(), &str, "int", size, __GL_PTR(), 0, __GL_PTR(), 0)
    Loop, % size
      astr .= Chr(NumGet(str, A_Index-1, "uchar"))
    return astr
  }
  StrGet := "StrGet"
  return %StrGet%(address, "cp1200")
}

__GL_GetASTR(address)
{
  if ((!A_IsUnicode) && (!A_PtrSize))
  {
    Loop
    {
      if ((a := NumGet(address+0, A_Index-1, "uchar"))=0)
        return astr
      astr .= Chr(a)
    }
  }
  StrGet := "StrGet"
  return %StrGet%(address, "cp0")
}

__GL_GdipToken(set="")
{
  static
  if (set!="")
    return (token := set)
  return token
}

__GL_TexTarget(target)
{
  if (t := __GL_(target))
    return t
  else if (instr(target, "CUBE"))
    return __GL_("TEXTURE_CUBE_MAP")
  else if (instr(target, "2"))
    return __GL_("TEXTURE_2D")
  else if (instr(target, "1"))
    return __GL_("TEXTURE_1D")
  else if (instr(target, "3"))
    return __GL_("TEXTURE_3D")
  return
}

__GL_GDIP_Load(filename, mipmap, byref w, byref h, byref bmbits, byref format)
{
  ptr := __GL_PTR()
  pptr := __GL_PPTR()
  DllCall("gdiplus\GdipCreateBitmapFromFile", ptr, __GL_PWCHAR(buffer, filename), pptr, g_srcbitmap)
  DllCall("gdiplus\GdipGetImageWidth", ptr, g_srcbitmap, "uint*", w)
  DllCall("gdiplus\GdipGetImageHeight", ptr, g_srcbitmap, "uint*", h)
  if ((!g_srcbitmap) || (w=0) || (h=0))
    return -1
  format := "BGRA"

  if (!(maxsize := GL_GetInteger("MAX_TEXTURE_SIZE")))
    maxsize := 512
  neww := w
  newh := h
  if ((!mipmap) && ((w>maxsize) || (h>maxsize) || ((GL_GetVersion() < 2.0) && (!GL_IsExtension("GL_ARB_texture_non_power_of_two")))))
  {
    sizes := 0
    Loop
    {
      if ((2**(A_Index-1)) > maxsize)
        break
      sizes ++
    }
    Loop, % sizes-1
    {
      if ((2**(A_Index-1))>=w)
        break
      neww := (2**A_Index)
    }
    Loop, % sizes-1
    {
      if ((2**(A_Index-1))>=h)
        break
      newh := (2**A_Index)
    }
  }
  if ((mipmap) || (GL_GetVersion() < 1.2) || (w!=neww) || (h!=newh))
  {
    DllCall("gdiplus\GdipCreateBitmapFromScan0", "int", neww, "int", newh, "int", 0, "int", 0x26200A, ptr, 0, pptr, g_dstbitmap)
    DllCall("gdiplus\GdipGetImageGraphicsContext", ptr, g_dstbitmap, pptr, g_dstgraphic)
    if ((w!=neww) || (h!=newh))
      DllCall("gdiplus\GdipSetInterpolationMode", ptr, g_dstgraphic, "int", 7)
    DllCall("gdiplus\GdipCreateImageAttributes", pptr, g_attrib)
    DllCall("gdiplus\GdipCreateMatrix", pptr, g_matrix)

    if ((mipmap) || (GL_GetVersion() < 1.2))
    {
      Matrix := "0|0|1|0|0|0|1|0|0|0|1|0|0|0|0|0|0|0|1|0|0|0|0|0|1"
      format := "RGBA"
      VarSetCapacity(pMatrix, 100, 0)
      Loop, parse, Matrix, |, % " `t"
        NumPut(A_LoopField, pMatrix, (A_Index-1)*4, "float")
    }

    DllCall("gdiplus\GdipSetImageAttributesColorMatrix", ptr, g_attrib, "int", 1, "int", 1, ptr, ((mipmap) || (GL_GetVersion() < 1.2)) ? &pMatrix : 0, "int", 0, "int", 0)
    DllCall("gdiplus\GdipDrawImageRectRectI", ptr, g_dstgraphic, ptr, g_srcbitmap, "int", 0, "int", 0, "int", w, "int", h, "int", 0, "int", 0, "int", neww, "int", newh, "int", 2, ptr, g_attrib, ptr, 0, ptr, 0)

    DllCall("gdiplus\GdipDeleteGraphics", ptr, g_dstgraphic)
    DllCall("gdiplus\GdipDisposeImage", ptr, g_srcbitmap)
    DllCall("gdiplus\GdipDisposeImageAttributes", ptr, g_attrib)
    DllCall("gdiplus\GdipDeleteMatrix", ptr, g_matrix)
    w := neww
    h := newh
  }
  else
    g_dstbitmap := g_srcbitmap

  DllCall("gdiplus\GdipCreateHBITMAPFromBitmap", ptr, g_dstbitmap, pptr, hBitmap, "uint", 0xFF000000)
  DllCall("gdiplus\GdipDisposeImage", ptr, g_dstbitmap)
  if (!hBitmap)
    return -2
  size := DllCall("GetObject", ptr, hBitmap, "uint", 24, ptr, 0)
  VarSetCapacity(imginfo, size, 0)
  if (!DllCall("GetObject", ptr, hBitmap, "uint", size, ptr, &imginfo))
    return -3
  sptr := (A_PtrSize) ? A_PtrSize : 4
  bmbits := NumGet(imginfo, 16+sptr, ptr)
  w := NumGet(imginfo, 4, "int")
  h := NumGet(imginfo, 8, "int")
  return hBitmap
}

__GL_GDIP_Delete(hBitmap)
{
  return DllCall("DeleteObject", __GL_PTR(), hBitmap)
}

__GL_Wnd(wnd)
{
  static
  local n, h

  if (instr(wnd, "GUI ")=1)
  {
    n := substr(wnd, instr(wnd, " ")+1)
    n += 0
    if (n)
    {
      if (gui_%n%)
        return gui_%n%
      Gui, %n%: +LastFound
        return (gui_%n% := WinExist())
    }
    return 0
  }
  if wnd is xdigit
  {
    if (wnd_%wnd%)
      return wnd_%wnd%
    if (h := WinExist(wnd))
      return (wnd_%wnd% := h)
    return 0
  }
  if (ctrl_%wnd%)
    return ctrl_%wnd%
  GuiControlGet, h, Hwnd, % wnd
  if (h)
    return (ctrl_%wnd% := h)
  return 0
}

__GL_hDC(hWnd)
{
  static
  local i
  i := A_FormatInteger
  SetFormat, Integer, h
  hWnd += 0
  SetFormat, Integer, % i
  if (dc_%hWnd%)
    return dc_%hWnd%
  return (dc_%hWnd% := DllCall("GetDC", __GL_PTR(), hWnd, __GL_PTR()))
}

__GL_Color(r_or_argb, g, b, a, byref xr, byref xg, byref xb, byref xa)
{
  if ((g="") || (b="") || (a=""))
  {
    xr := ((r_or_argb & 0xFF0000) >> 16) / 0xFF
    xg := ((r_or_argb & 0xFF00) >> 8) / 0xFF
    xb := (r_or_argb & 0xFF) / 0xFF
    xa := 1-(((r_or_argb & 0xFF000000) >> 24) / 0xFF)
    return 1
  }
  else if ((g!="") && (b!=""))
  {
    xr := r_or_argb
    xg := g
    xb := b
    xa := (a) ? a : 0
    return 1
  }
  return 0
}

__GL_PColorf(r_or_argb, g, b, a, byref color)
{
  VarSetCapacity(color, 16, 0)
  if ((g="") || (b="") || (a=""))
  {
    NumPut(((r_or_argb & 0xFF0000) >> 16) / 0xFF, color, 0, "float")
    NumPut(((r_or_argb & 0xFF00) >> 8) / 0xFF, color, 4, "float")
    NumPut((r_or_argb & 0xFF) / 0xFF, color, 8, "float")
    NumPut(1-(((r_or_argb & 0xFF000000) >> 24) / 0xFF), color, 12, "float")
    return &color
  }
  else if ((g!="") && (b!=""))
  {
    NumPut(r, color, 0, "float")
    NumPut(g, color, 4, "float")
    NumPut(b, color, 8, "float")
    NumPut((a) ? a : 0, color, 12, "float")
    return &color
  }
  return 0
}

__GL_FrameRate(t="")
{
  static
  if (t="")
  {
    time := 1000/(A_TickCount-lastframe)
    lastframe := A_TickCount
    if ((starttime="") || (starttime <= (A_TickCount-1000)))
    {
      starttime := A_TickCount
      frames := framecount
      framecount := 0
    }
    else
      framecount ++
  }
  if (t="PER_FRAME")
    return time
  if (t="PER_SECOND")
    return frames
  return 0
}

__GL_LimitFrameRate(maxfps="")
{
  static
  if (maxfps!="")
  {
    if (maxfps = 0)
    {
      enabled := 0
      return 1
    }
    if (maxfps > 0)
    {
      enabled := 1
      lastsleep := 0
      fps := maxfps
      return 1
    }
    return 0
  }
  if (enabled)
  {
    diff := (A_TickCount - lasttime)
    lasttime := A_TickCount
    if ((sleeptime := (1000/fps - (diff - lastsleep))) > 0)
    {
      sleep, % sleeptime
      lastsleep := sleeptime
    }
    else
      lastsleep := 0
    return 1
  }
  return 0
}

__GL_(def)
{
  static _BYTE := 0x1400
  static _UNSIGNED_BYTE := 0x1401
  static _SHORT := 0x1402
  static _UNSIGNED_SHORT := 0x1403
  static _INT := 0x1404
  static _UNSIGNED_INT := 0x1405
  static _FLOAT := 0x1406
  static _DOUBLE := 0x140A
  static _2_BYTES := 0x1407
  static _3_BYTES := 0x1408
  static _4_BYTES := 0x1409
  static _POINTS := 0x0000
  static _LINES := 0x0001
  static _LINE_LOOP := 0x0002
  static _LINE_STRIP := 0x0003
  static _TRIANGLES := 0x0004
  static _TRIANGLE_STRIP := 0x0005
  static _TRIANGLE_FAN := 0x0006
  static _QUADS := 0x0007
  static _QUAD_STRIP := 0x0008
  static _POLYGON := 0x0009
  static _VERTEX_ARRAY := 0x8074
  static _NORMAL_ARRAY := 0x8075
  static _COLOR_ARRAY := 0x8076
  static _INDEX_ARRAY := 0x8077
  static _TEXTURE_COORD_ARRAY := 0x8078
  static _EDGE_FLAG_ARRAY := 0x8079
  static _VERTEX_ARRAY_SIZE := 0x807A
  static _VERTEX_ARRAY_TYPE := 0x807B
  static _VERTEX_ARRAY_STRIDE := 0x807C
  static _NORMAL_ARRAY_TYPE := 0x807E
  static _NORMAL_ARRAY_STRIDE := 0x807F
  static _COLOR_ARRAY_SIZE := 0x8081
  static _COLOR_ARRAY_TYPE := 0x8082
  static _COLOR_ARRAY_STRIDE := 0x8083
  static _INDEX_ARRAY_TYPE := 0x8085
  static _INDEX_ARRAY_STRIDE := 0x8086
  static _TEXTURE_COORD_ARRAY_SIZE := 0x8088
  static _TEXTURE_COORD_ARRAY_TYPE := 0x8089
  static _TEXTURE_COORD_ARRAY_STRIDE := 0x808A
  static _EDGE_FLAG_ARRAY_STRIDE := 0x808C
  static _VERTEX_ARRAY_POINTER := 0x808E
  static _NORMAL_ARRAY_POINTER := 0x808F
  static _COLOR_ARRAY_POINTER := 0x8090
  static _INDEX_ARRAY_POINTER := 0x8091
  static _TEXTURE_COORD_ARRAY_POINTER := 0x8092
  static _EDGE_FLAG_ARRAY_POINTER := 0x8093
  static _V2F := 0x2A20
  static _V3F := 0x2A21
  static _C4UB_V2F := 0x2A22
  static _C4UB_V3F := 0x2A23
  static _C3F_V3F := 0x2A24
  static _N3F_V3F := 0x2A25
  static _C4F_N3F_V3F := 0x2A26
  static _T2F_V3F := 0x2A27
  static _T4F_V4F := 0x2A28
  static _T2F_C4UB_V3F := 0x2A29
  static _T2F_C3F_V3F := 0x2A2A
  static _T2F_N3F_V3F := 0x2A2B
  static _T2F_C4F_N3F_V3F := 0x2A2C
  static _T4F_C4F_N3F_V4F := 0x2A2D
  static _MATRIX_MODE := 0x0BA0
  static _MODELVIEW := 0x1700
  static _PROJECTION := 0x1701
  static _TEXTURE := 0x1702
  static _POINT_SMOOTH := 0x0B10
  static _POINT_SIZE := 0x0B11
  static _POINT_SIZE_GRANULARITY := 0x0B13
  static _POINT_SIZE_RANGE := 0x0B12
  static _LINE_SMOOTH := 0x0B20
  static _LINE_STIPPLE := 0x0B24
  static _LINE_STIPPLE_PATTERN := 0x0B25
  static _LINE_STIPPLE_REPEAT := 0x0B26
  static _LINE_WIDTH := 0x0B21
  static _LINE_WIDTH_GRANULARITY := 0x0B23
  static _LINE_WIDTH_RANGE := 0x0B22
  static _POINT := 0x1B00
  static _LINE := 0x1B01
  static _FILL := 0x1B02
  static _CW := 0x0900
  static _CCW := 0x0901
  static _FRONT := 0x0404
  static _BACK := 0x0405
  static _POLYGON_MODE := 0x0B40
  static _POLYGON_SMOOTH := 0x0B41
  static _POLYGON_STIPPLE := 0x0B42
  static _EDGE_FLAG := 0x0B43
  static _CULL_FACE := 0x0B44
  static _CULL_FACE_MODE := 0x0B45
  static _FRONT_FACE := 0x0B46
  static _POLYGON_OFFSET_FACTOR := 0x8038
  static _POLYGON_OFFSET_UNITS := 0x2A00
  static _POLYGON_OFFSET_POINT := 0x2A01
  static _POLYGON_OFFSET_LINE := 0x2A02
  static _POLYGON_OFFSET_FILL := 0x8037
  static _COMPILE := 0x1300
  static _COMPILE_AND_EXECUTE := 0x1301
  static _LIST_BASE := 0x0B32
  static _LIST_INDEX := 0x0B33
  static _LIST_MODE := 0x0B30
  static _NEVER := 0x0200
  static _LESS := 0x0201
  static _EQUAL := 0x0202
  static _LEQUAL := 0x0203
  static _GREATER := 0x0204
  static _NOTEQUAL := 0x0205
  static _GEQUAL := 0x0206
  static _ALWAYS := 0x0207
  static _DEPTH_TEST := 0x0B71
  static _DEPTH_BITS := 0x0D56
  static _DEPTH_CLEAR_VALUE := 0x0B73
  static _DEPTH_FUNC := 0x0B74
  static _DEPTH_RANGE := 0x0B70
  static _DEPTH_WRITEMASK := 0x0B72
  static _DEPTH_COMPONENT := 0x1902
  static _LIGHTING := 0x0B50
  static _LIGHT0 := 0x4000
  static _LIGHT1 := 0x4001
  static _LIGHT2 := 0x4002
  static _LIGHT3 := 0x4003
  static _LIGHT4 := 0x4004
  static _LIGHT5 := 0x4005
  static _LIGHT6 := 0x4006
  static _LIGHT7 := 0x4007
  static _SPOT_EXPONENT := 0x1205
  static _SPOT_CUTOFF := 0x1206
  static _CONSTANT_ATTENUATION := 0x1207
  static _LINEAR_ATTENUATION := 0x1208
  static _QUADRATIC_ATTENUATION := 0x1209
  static _AMBIENT := 0x1200
  static _DIFFUSE := 0x1201
  static _SPECULAR := 0x1202
  static _SHININESS := 0x1601
  static _EMISSION := 0x1600
  static _POSITION := 0x1203
  static _SPOT_DIRECTION := 0x1204
  static _AMBIENT_AND_DIFFUSE := 0x1602
  static _COLOR_INDEXES := 0x1603
  static _LIGHT_MODEL_TWO_SIDE := 0x0B52
  static _LIGHT_MODEL_LOCAL_VIEWER := 0x0B51
  static _LIGHT_MODEL_AMBIENT := 0x0B53
  static _FRONT_AND_BACK := 0x0408
  static _SHADE_MODEL := 0x0B54
  static _FLAT := 0x1D00
  static _SMOOTH := 0x1D01
  static _COLOR_MATERIAL := 0x0B57
  static _COLOR_MATERIAL_FACE := 0x0B55
  static _COLOR_MATERIAL_PARAMETER := 0x0B56
  static _NORMALIZE := 0x0BA1
  static _CLIP_PLANE0 := 0x3000
  static _CLIP_PLANE1 := 0x3001
  static _CLIP_PLANE2 := 0x3002
  static _CLIP_PLANE3 := 0x3003
  static _CLIP_PLANE4 := 0x3004
  static _CLIP_PLANE5 := 0x3005
  static _ACCUM_RED_BITS := 0x0D58
  static _ACCUM_GREEN_BITS := 0x0D59
  static _ACCUM_BLUE_BITS := 0x0D5A
  static _ACCUM_ALPHA_BITS := 0x0D5B
  static _ACCUM_CLEAR_VALUE := 0x0B80
  static _ACCUM := 0x0100
  static _ADD := 0x0104
  static _LOAD := 0x0101
  static _MULT := 0x0103
  static _RETURN := 0x0102
  static _ALPHA_TEST := 0x0BC0
  static _ALPHA_TEST_REF := 0x0BC2
  static _ALPHA_TEST_FUNC := 0x0BC1
  static _BLEND := 0x0BE2
  static _BLEND_SRC := 0x0BE1
  static _BLEND_DST := 0x0BE0
  static _ZERO := 0x0
  static _ONE := 0x1
  static _SRC_COLOR := 0x0300
  static _ONE_MINUS_SRC_COLOR := 0x0301
  static _SRC_ALPHA := 0x0302
  static _ONE_MINUS_SRC_ALPHA := 0x0303
  static _DST_ALPHA := 0x0304
  static _ONE_MINUS_DST_ALPHA := 0x0305
  static _DST_COLOR := 0x0306
  static _ONE_MINUS_DST_COLOR := 0x0307
  static _SRC_ALPHA_SATURATE := 0x0308
  static _CONSTANT_COLOR := 0x8001
  static _ONE_MINUS_CONSTANT_COLOR := 0x8002
  static _CONSTANT_ALPHA := 0x8003
  static _ONE_MINUS_CONSTANT_ALPHA := 0x8004
  static _FEEDBACK := 0x1C01
  static _RENDER := 0x1C00
  static _SELECT := 0x1C02
  static _2D := 0x0600
  static _3D := 0x0601
  static _3D_COLOR := 0x0602
  static _3D_COLOR_TEXTURE := 0x0603
  static _4D_COLOR_TEXTURE := 0x0604
  static _POINT_TOKEN := 0x0701
  static _LINE_TOKEN := 0x0702
  static _LINE_RESET_TOKEN := 0x0707
  static _POLYGON_TOKEN := 0x0703
  static _BITMAP_TOKEN := 0x0704
  static _DRAW_PIXEL_TOKEN := 0x0705
  static _COPY_PIXEL_TOKEN := 0x0706
  static _PASS_THROUGH_TOKEN := 0x0700
  static _FEEDBACK_BUFFER_POINTER := 0x0DF0
  static _FEEDBACK_BUFFER_SIZE := 0x0DF1
  static _FEEDBACK_BUFFER_TYPE := 0x0DF2
  static _SELECTION_BUFFER_POINTER := 0x0DF3
  static _SELECTION_BUFFER_SIZE := 0x0DF4
  static _FOG := 0x0B60
  static _FOG_MODE := 0x0B65
  static _FOG_DENSITY := 0x0B62
  static _FOG_COLOR := 0x0B66
  static _FOG_INDEX := 0x0B61
  static _FOG_START := 0x0B63
  static _FOG_END := 0x0B64
  static _LINEAR := 0x2601
  static _EXP := 0x0800
  static _EXP2 := 0x0801
  static _LOGIC_OP := 0x0BF1
  static _INDEX_LOGIC_OP := 0x0BF1
  static _COLOR_LOGIC_OP := 0x0BF2
  static _LOGIC_OP_MODE := 0x0BF0
  static _CLEAR := 0x1500
  static _SET := 0x150F
  static _COPY := 0x1503
  static _COPY_INVERTED := 0x150C
  static _NOOP := 0x1505
  static _INVERT := 0x150A
  static _AND := 0x1501
  static _NAND := 0x150E
  static _OR := 0x1507
  static _NOR := 0x1508
  static _XOR := 0x1506
  static _EQUIV := 0x1509
  static _AND_REVERSE := 0x1502
  static _AND_INVERTED := 0x1504
  static _OR_REVERSE := 0x150B
  static _OR_INVERTED := 0x150D
  static _STENCIL_TEST := 0x0B90
  static _STENCIL_WRITEMASK := 0x0B98
  static _STENCIL_BITS := 0x0D57
  static _STENCIL_FUNC := 0x0B92
  static _STENCIL_VALUE_MASK := 0x0B93
  static _STENCIL_REF := 0x0B97
  static _STENCIL_FAIL := 0x0B94
  static _STENCIL_PASS_DEPTH_PASS := 0x0B96
  static _STENCIL_PASS_DEPTH_FAIL := 0x0B95
  static _STENCIL_CLEAR_VALUE := 0x0B91
  static _STENCIL_INDEX := 0x1901
  static _KEEP := 0x1E00
  static _REPLACE := 0x1E01
  static _INCR := 0x1E02
  static _DECR := 0x1E03
  static _NONE := 0x0
  static _LEFT := 0x0406
  static _RIGHT := 0x0407
  static _FRONT_LEFT := 0x0400
  static _FRONT_RIGHT := 0x0401
  static _BACK_LEFT := 0x0402
  static _BACK_RIGHT := 0x0403
  static _AUX0 := 0x0409
  static _AUX1 := 0x040A
  static _AUX2 := 0x040B
  static _AUX3 := 0x040C
  static _COLOR_INDEX := 0x1900
  static _RED := 0x1903
  static _GREEN := 0x1904
  static _BLUE := 0x1905
  static _ALPHA := 0x1906
  static _LUMINANCE := 0x1909
  static _LUMINANCE_ALPHA := 0x190A
  static _ALPHA_BITS := 0x0D55
  static _RED_BITS := 0x0D52
  static _GREEN_BITS := 0x0D53
  static _BLUE_BITS := 0x0D54
  static _INDEX_BITS := 0x0D51
  static _SUBPIXEL_BITS := 0x0D50
  static _AUX_BUFFERS := 0x0C00
  static _READ_BUFFER := 0x0C02
  static _DRAW_BUFFER := 0x0C01
  static _DOUBLEBUFFER := 0x0C32
  static _STEREO := 0x0C33
  static _BITMAP := 0x1A00
  static _COLOR := 0x1800
  static _DEPTH := 0x1801
  static _STENCIL := 0x1802
  static _DITHER := 0x0BD0
  static _RGB := 0x1907
  static _RGBA := 0x1908
  static _MAX_LIST_NESTING := 0x0B31
  static _MAX_ATTRIB_STACK_DEPTH := 0x0D35
  static _MAX_MODELVIEW_STACK_DEPTH := 0x0D36
  static _MAX_NAME_STACK_DEPTH := 0x0D37
  static _MAX_PROJECTION_STACK_DEPTH := 0x0D38
  static _MAX_TEXTURE_STACK_DEPTH := 0x0D39
  static _MAX_EVAL_ORDER := 0x0D30
  static _MAX_LIGHTS := 0x0D31
  static _MAX_CLIP_PLANES := 0x0D32
  static _MAX_TEXTURE_SIZE := 0x0D33
  static _MAX_PIXEL_MAP_TABLE := 0x0D34
  static _MAX_VIEWPORT_DIMS := 0x0D3A
  static _MAX_CLIENT_ATTRIB_STACK_DEPTH := 0x0D3B
  static _ATTRIB_STACK_DEPTH := 0x0BB0
  static _CLIENT_ATTRIB_STACK_DEPTH := 0x0BB1
  static _COLOR_CLEAR_VALUE := 0x0C22
  static _COLOR_WRITEMASK := 0x0C23
  static _CURRENT_INDEX := 0x0B01
  static _CURRENT_COLOR := 0x0B00
  static _CURRENT_NORMAL := 0x0B02
  static _CURRENT_RASTER_COLOR := 0x0B04
  static _CURRENT_RASTER_DISTANCE := 0x0B09
  static _CURRENT_RASTER_INDEX := 0x0B05
  static _CURRENT_RASTER_POSITION := 0x0B07
  static _CURRENT_RASTER_TEXTURE_COORDS := 0x0B06
  static _CURRENT_RASTER_POSITION_VALID := 0x0B08
  static _CURRENT_TEXTURE_COORDS := 0x0B03
  static _INDEX_CLEAR_VALUE := 0x0C20
  static _INDEX_MODE := 0x0C30
  static _INDEX_WRITEMASK := 0x0C21
  static _MODELVIEW_MATRIX := 0x0BA6
  static _MODELVIEW_STACK_DEPTH := 0x0BA3
  static _NAME_STACK_DEPTH := 0x0D70
  static _PROJECTION_MATRIX := 0x0BA7
  static _PROJECTION_STACK_DEPTH := 0x0BA4
  static _RENDER_MODE := 0x0C40
  static _RGBA_MODE := 0x0C31
  static _TEXTURE_MATRIX := 0x0BA8
  static _TEXTURE_STACK_DEPTH := 0x0BA5
  static _VIEWPORT := 0x0BA2
  static _AUTO_NORMAL := 0x0D80
  static _MAP1_COLOR_4 := 0x0D90
  static _MAP1_GRID_DOMAIN := 0x0DD0
  static _MAP1_GRID_SEGMENTS := 0x0DD1
  static _MAP1_INDEX := 0x0D91
  static _MAP1_NORMAL := 0x0D92
  static _MAP1_TEXTURE_COORD_1 := 0x0D93
  static _MAP1_TEXTURE_COORD_2 := 0x0D94
  static _MAP1_TEXTURE_COORD_3 := 0x0D95
  static _MAP1_TEXTURE_COORD_4 := 0x0D96
  static _MAP1_VERTEX_3 := 0x0D97
  static _MAP1_VERTEX_4 := 0x0D98
  static _MAP2_COLOR_4 := 0x0DB0
  static _MAP2_GRID_DOMAIN := 0x0DD2
  static _MAP2_GRID_SEGMENTS := 0x0DD3
  static _MAP2_INDEX := 0x0DB1
  static _MAP2_NORMAL := 0x0DB2
  static _MAP2_TEXTURE_COORD_1 := 0x0DB3
  static _MAP2_TEXTURE_COORD_2 := 0x0DB4
  static _MAP2_TEXTURE_COORD_3 := 0x0DB5
  static _MAP2_TEXTURE_COORD_4 := 0x0DB6
  static _MAP2_VERTEX_3 := 0x0DB7
  static _MAP2_VERTEX_4 := 0x0DB8
  static _COEFF := 0x0A00
  static _DOMAIN := 0x0A02
  static _ORDER := 0x0A01
  static _FOG_HINT := 0x0C54
  static _LINE_SMOOTH_HINT := 0x0C52
  static _PERSPECTIVE_CORRECTION_HINT := 0x0C50
  static _POINT_SMOOTH_HINT := 0x0C51
  static _POLYGON_SMOOTH_HINT := 0x0C53
  static _DONT_CARE := 0x1100
  static _FASTEST := 0x1101
  static _NICEST := 0x1102
  static _SCISSOR_TEST := 0x0C11
  static _SCISSOR_BOX := 0x0C10
  static _MAP_COLOR := 0x0D10
  static _MAP_STENCIL := 0x0D11
  static _INDEX_SHIFT := 0x0D12
  static _INDEX_OFFSET := 0x0D13
  static _RED_SCALE := 0x0D14
  static _RED_BIAS := 0x0D15
  static _GREEN_SCALE := 0x0D18
  static _GREEN_BIAS := 0x0D19
  static _BLUE_SCALE := 0x0D1A
  static _BLUE_BIAS := 0x0D1B
  static _ALPHA_SCALE := 0x0D1C
  static _ALPHA_BIAS := 0x0D1D
  static _DEPTH_SCALE := 0x0D1E
  static _DEPTH_BIAS := 0x0D1F
  static _PIXEL_MAP_S_TO_S_SIZE := 0x0CB1
  static _PIXEL_MAP_I_TO_I_SIZE := 0x0CB0
  static _PIXEL_MAP_I_TO_R_SIZE := 0x0CB2
  static _PIXEL_MAP_I_TO_G_SIZE := 0x0CB3
  static _PIXEL_MAP_I_TO_B_SIZE := 0x0CB4
  static _PIXEL_MAP_I_TO_A_SIZE := 0x0CB5
  static _PIXEL_MAP_R_TO_R_SIZE := 0x0CB6
  static _PIXEL_MAP_G_TO_G_SIZE := 0x0CB7
  static _PIXEL_MAP_B_TO_B_SIZE := 0x0CB8
  static _PIXEL_MAP_A_TO_A_SIZE := 0x0CB9
  static _PIXEL_MAP_S_TO_S := 0x0C71
  static _PIXEL_MAP_I_TO_I := 0x0C70
  static _PIXEL_MAP_I_TO_R := 0x0C72
  static _PIXEL_MAP_I_TO_G := 0x0C73
  static _PIXEL_MAP_I_TO_B := 0x0C74
  static _PIXEL_MAP_I_TO_A := 0x0C75
  static _PIXEL_MAP_R_TO_R := 0x0C76
  static _PIXEL_MAP_G_TO_G := 0x0C77
  static _PIXEL_MAP_B_TO_B := 0x0C78
  static _PIXEL_MAP_A_TO_A := 0x0C79
  static _PACK_ALIGNMENT := 0x0D05
  static _PACK_LSB_FIRST := 0x0D01
  static _PACK_ROW_LENGTH := 0x0D02
  static _PACK_SKIP_PIXELS := 0x0D04
  static _PACK_SKIP_ROWS := 0x0D03
  static _PACK_SWAP_BYTES := 0x0D00
  static _UNPACK_ALIGNMENT := 0x0CF5
  static _UNPACK_LSB_FIRST := 0x0CF1
  static _UNPACK_ROW_LENGTH := 0x0CF2
  static _UNPACK_SKIP_PIXELS := 0x0CF4
  static _UNPACK_SKIP_ROWS := 0x0CF3
  static _UNPACK_SWAP_BYTES := 0x0CF0
  static _ZOOM_X := 0x0D16
  static _ZOOM_Y := 0x0D17
  static _TEXTURE_ENV := 0x2300
  static _TEXTURE_ENV_MODE := 0x2200
  static _TEXTURE_1D := 0x0DE0
  static _TEXTURE_2D := 0x0DE1
  static _TEXTURE_WRAP_S := 0x2802
  static _TEXTURE_WRAP_T := 0x2803
  static _TEXTURE_MAG_FILTER := 0x2800
  static _TEXTURE_MIN_FILTER := 0x2801
  static _TEXTURE_ENV_COLOR := 0x2201
  static _TEXTURE_GEN_S := 0x0C60
  static _TEXTURE_GEN_T := 0x0C61
  static _TEXTURE_GEN_MODE := 0x2500
  static _TEXTURE_BORDER_COLOR := 0x1004
  static _TEXTURE_WIDTH := 0x1000
  static _TEXTURE_HEIGHT := 0x1001
  static _TEXTURE_BORDER := 0x1005
  static _TEXTURE_COMPONENTS := 0x1003
  static _TEXTURE_RED_SIZE := 0x805C
  static _TEXTURE_GREEN_SIZE := 0x805D
  static _TEXTURE_BLUE_SIZE := 0x805E
  static _TEXTURE_ALPHA_SIZE := 0x805F
  static _TEXTURE_LUMINANCE_SIZE := 0x8060
  static _TEXTURE_INTENSITY_SIZE := 0x8061
  static _NEAREST_MIPMAP_NEAREST := 0x2700
  static _NEAREST_MIPMAP_LINEAR := 0x2702
  static _LINEAR_MIPMAP_NEAREST := 0x2701
  static _LINEAR_MIPMAP_LINEAR := 0x2703
  static _OBJECT_LINEAR := 0x2401
  static _OBJECT_PLANE := 0x2501
  static _EYE_LINEAR := 0x2400
  static _EYE_PLANE := 0x2502
  static _SPHERE_MAP := 0x2402
  static _DECAL := 0x2101
  static _MODULATE := 0x2100
  static _NEAREST := 0x2600
  static _REPEAT := 0x2901
  static _CLAMP := 0x2900
  static _S := 0x2000
  static _T := 0x2001
  static _R := 0x2002
  static _Q := 0x2003
  static _TEXTURE_GEN_R := 0x0C62
  static _TEXTURE_GEN_Q := 0x0C63
  static _VENDOR := 0x1F00
  static _RENDERER := 0x1F01
  static _VERSION := 0x1F02
  static _EXTENSIONS := 0x1F03
  static _NO_ERROR := 0x0
  static _INVALID_VALUE := 0x0501
  static _INVALID_ENUM := 0x0500
  static _INVALID_OPERATION := 0x0502
  static _STACK_OVERFLOW := 0x0503
  static _STACK_UNDERFLOW := 0x0504
  static _OUT_OF_MEMORY := 0x0505
  static _CURRENT_BIT := 0x00000001
  static _POINT_BIT := 0x00000002
  static _LINE_BIT := 0x00000004
  static _POLYGON_BIT := 0x00000008
  static _POLYGON_STIPPLE_BIT := 0x00000010
  static _PIXEL_MODE_BIT := 0x00000020
  static _LIGHTING_BIT := 0x00000040
  static _FOG_BIT := 0x00000080
  static _DEPTH_BUFFER_BIT := 0x00000100
  static _ACCUM_BUFFER_BIT := 0x00000200
  static _STENCIL_BUFFER_BIT := 0x00000400
  static _VIEWPORT_BIT := 0x00000800
  static _TRANSFORM_BIT := 0x00001000
  static _ENABLE_BIT := 0x00002000
  static _COLOR_BUFFER_BIT := 0x00004000
  static _HINT_BIT := 0x00008000
  static _EVAL_BIT := 0x00010000
  static _LIST_BIT := 0x00020000
  static _TEXTURE_BIT := 0x00040000
  static _SCISSOR_BIT := 0x00080000
  static _ALL_ATTRIB_BITS := 0x000FFFFF
  static _PROXY_TEXTURE_1D := 0x8063
  static _PROXY_TEXTURE_2D := 0x8064
  static _TEXTURE_PRIORITY := 0x8066
  static _TEXTURE_RESIDENT := 0x8067
  static _TEXTURE_BINDING_1D := 0x8068
  static _TEXTURE_BINDING_2D := 0x8069
  static _TEXTURE_INTERNAL_FORMAT := 0x1003
  static _ALPHA4 := 0x803B
  static _ALPHA8 := 0x803C
  static _ALPHA12 := 0x803D
  static _ALPHA16 := 0x803E
  static _LUMINANCE4 := 0x803F
  static _LUMINANCE8 := 0x8040
  static _LUMINANCE12 := 0x8041
  static _LUMINANCE16 := 0x8042
  static _LUMINANCE4_ALPHA4 := 0x8043
  static _LUMINANCE6_ALPHA2 := 0x8044
  static _LUMINANCE8_ALPHA8 := 0x8045
  static _LUMINANCE12_ALPHA4 := 0x8046
  static _LUMINANCE12_ALPHA12 := 0x8047
  static _LUMINANCE16_ALPHA16 := 0x8048
  static _INTENSITY := 0x8049
  static _INTENSITY4 := 0x804A
  static _INTENSITY8 := 0x804B
  static _INTENSITY12 := 0x804C
  static _INTENSITY16 := 0x804D
  static _R3_G3_B2 := 0x2A10
  static _RGB4 := 0x804F
  static _RGB5 := 0x8050
  static _RGB8 := 0x8051
  static _RGB10 := 0x8052
  static _RGB12 := 0x8053
  static _RGB16 := 0x8054
  static _RGBA2 := 0x8055
  static _RGBA4 := 0x8056
  static _RGB5_A1 := 0x8057
  static _RGBA8 := 0x8058
  static _RGB10_A2 := 0x8059
  static _RGBA12 := 0x805A
  static _RGBA16 := 0x805B
  static _CLIENT_PIXEL_STORE_BIT := 0x00000001
  static _CLIENT_VERTEX_ARRAY_BIT := 0x00000002
  static _ALL_CLIENT_ATTRIB_BITS := 0xFFFFFFFF
  static _CLIENT_ALL_ATTRIB_BITS := 0xFFFFFFFF
  static _RESCALE_NORMAL := 0x803A
  static _CLAMP_TO_EDGE := 0x812F
  static _MAX_ELEMENTS_VERTICES := 0x80E8
  static _MAX_ELEMENTS_INDICES := 0x80E9
  static _BGR := 0x80E0
  static _BGRA := 0x80E1
  static _UNSIGNED_BYTE_3_3_2 := 0x8032
  static _UNSIGNED_BYTE_2_3_3_REV := 0x8362
  static _UNSIGNED_SHORT_5_6_5 := 0x8363
  static _UNSIGNED_SHORT_5_6_5_REV := 0x8364
  static _UNSIGNED_SHORT_4_4_4_4 := 0x8033
  static _UNSIGNED_SHORT_4_4_4_4_REV := 0x8365
  static _UNSIGNED_SHORT_5_5_5_1 := 0x8034
  static _UNSIGNED_SHORT_1_5_5_5_REV := 0x8366
  static _UNSIGNED_INT_8_8_8_8 := 0x8035
  static _UNSIGNED_INT_8_8_8_8_REV := 0x8367
  static _UNSIGNED_INT_10_10_10_2 := 0x8036
  static _UNSIGNED_INT_2_10_10_10_REV := 0x8368
  static _LIGHT_MODEL_COLOR_CONTROL := 0x81F8
  static _SINGLE_COLOR := 0x81F9
  static _SEPARATE_SPECULAR_COLOR := 0x81FA
  static _TEXTURE_MIN_LOD := 0x813A
  static _TEXTURE_MAX_LOD := 0x813B
  static _TEXTURE_BASE_LEVEL := 0x813C
  static _TEXTURE_MAX_LEVEL := 0x813D
  static _SMOOTH_POINT_SIZE_RANGE := 0x0B12
  static _SMOOTH_POINT_SIZE_GRANULARITY := 0x0B13
  static _SMOOTH_LINE_WIDTH_RANGE := 0x0B22
  static _SMOOTH_LINE_WIDTH_GRANULARITY := 0x0B23
  static _ALIASED_POINT_SIZE_RANGE := 0x846D
  static _ALIASED_LINE_WIDTH_RANGE := 0x846E
  static _PACK_SKIP_IMAGES := 0x806B
  static _PACK_IMAGE_HEIGHT := 0x806C
  static _UNPACK_SKIP_IMAGES := 0x806D
  static _UNPACK_IMAGE_HEIGHT := 0x806E
  static _TEXTURE_3D := 0x806F
  static _PROXY_TEXTURE_3D := 0x8070
  static _TEXTURE_DEPTH := 0x8071
  static _TEXTURE_WRAP_R := 0x8072
  static _MAX_3D_TEXTURE_SIZE := 0x8073
  static _TEXTURE_BINDING_3D := 0x806A
  static _COLOR_TABLE := 0x80D0
  static _POST_CONVOLUTION_COLOR_TABLE := 0x80D1
  static _POST_COLOR_MATRIX_COLOR_TABLE := 0x80D2
  static _PROXY_COLOR_TABLE := 0x80D3
  static _PROXY_POST_CONVOLUTION_COLOR_TABLE := 0x80D4
  static _PROXY_POST_COLOR_MATRIX_COLOR_TABLE := 0x80D5
  static _COLOR_TABLE_SCALE := 0x80D6
  static _COLOR_TABLE_BIAS := 0x80D7
  static _COLOR_TABLE_FORMAT := 0x80D8
  static _COLOR_TABLE_WIDTH := 0x80D9
  static _COLOR_TABLE_RED_SIZE := 0x80DA
  static _COLOR_TABLE_GREEN_SIZE := 0x80DB
  static _COLOR_TABLE_BLUE_SIZE := 0x80DC
  static _COLOR_TABLE_ALPHA_SIZE := 0x80DD
  static _COLOR_TABLE_LUMINANCE_SIZE := 0x80DE
  static _COLOR_TABLE_INTENSITY_SIZE := 0x80DF
  static _CONVOLUTION_1D := 0x8010
  static _CONVOLUTION_2D := 0x8011
  static _SEPARABLE_2D := 0x8012
  static _CONVOLUTION_BORDER_MODE := 0x8013
  static _CONVOLUTION_FILTER_SCALE := 0x8014
  static _CONVOLUTION_FILTER_BIAS := 0x8015
  static _REDUCE := 0x8016
  static _CONVOLUTION_FORMAT := 0x8017
  static _CONVOLUTION_WIDTH := 0x8018
  static _CONVOLUTION_HEIGHT := 0x8019
  static _MAX_CONVOLUTION_WIDTH := 0x801A
  static _MAX_CONVOLUTION_HEIGHT := 0x801B
  static _POST_CONVOLUTION_RED_SCALE := 0x801C
  static _POST_CONVOLUTION_GREEN_SCALE := 0x801D
  static _POST_CONVOLUTION_BLUE_SCALE := 0x801E
  static _POST_CONVOLUTION_ALPHA_SCALE := 0x801F
  static _POST_CONVOLUTION_RED_BIAS := 0x8020
  static _POST_CONVOLUTION_GREEN_BIAS := 0x8021
  static _POST_CONVOLUTION_BLUE_BIAS := 0x8022
  static _POST_CONVOLUTION_ALPHA_BIAS := 0x8023
  static _CONSTANT_BORDER := 0x8151
  static _REPLICATE_BORDER := 0x8153
  static _CONVOLUTION_BORDER_COLOR := 0x8154
  static _COLOR_MATRIX := 0x80B1
  static _COLOR_MATRIX_STACK_DEPTH := 0x80B2
  static _MAX_COLOR_MATRIX_STACK_DEPTH := 0x80B3
  static _POST_COLOR_MATRIX_RED_SCALE := 0x80B4
  static _POST_COLOR_MATRIX_GREEN_SCALE := 0x80B5
  static _POST_COLOR_MATRIX_BLUE_SCALE := 0x80B6
  static _POST_COLOR_MATRIX_ALPHA_SCALE := 0x80B7
  static _POST_COLOR_MATRIX_RED_BIAS := 0x80B8
  static _POST_COLOR_MATRIX_GREEN_BIAS := 0x80B9
  static _POST_COLOR_MATRIX_BLUE_BIAS := 0x80BA
  static _POST_COLOR_MATRIX_ALPHA_BIAS := 0x80BB
  static _HISTOGRAM := 0x8024
  static _PROXY_HISTOGRAM := 0x8025
  static _HISTOGRAM_WIDTH := 0x8026
  static _HISTOGRAM_FORMAT := 0x8027
  static _HISTOGRAM_RED_SIZE := 0x8028
  static _HISTOGRAM_GREEN_SIZE := 0x8029
  static _HISTOGRAM_BLUE_SIZE := 0x802A
  static _HISTOGRAM_ALPHA_SIZE := 0x802B
  static _HISTOGRAM_LUMINANCE_SIZE := 0x802C
  static _HISTOGRAM_SINK := 0x802D
  static _MINMAX := 0x802E
  static _MINMAX_FORMAT := 0x802F
  static _MINMAX_SINK := 0x8030
  static _TABLE_TOO_LARGE := 0x8031
  static _BLEND_EQUATION := 0x8009
  static _MIN := 0x8007
  static _MAX := 0x8008
  static _FUNC_ADD := 0x8006
  static _FUNC_SUBTRACT := 0x800A
  static _FUNC_REVERSE_SUBTRACT := 0x800B
  static _BLEND_COLOR := 0x8005
  static _TEXTURE0 := 0x84C0
  static _TEXTURE1 := 0x84C1
  static _TEXTURE2 := 0x84C2
  static _TEXTURE3 := 0x84C3
  static _TEXTURE4 := 0x84C4
  static _TEXTURE5 := 0x84C5
  static _TEXTURE6 := 0x84C6
  static _TEXTURE7 := 0x84C7
  static _TEXTURE8 := 0x84C8
  static _TEXTURE9 := 0x84C9
  static _TEXTURE10 := 0x84CA
  static _TEXTURE11 := 0x84CB
  static _TEXTURE12 := 0x84CC
  static _TEXTURE13 := 0x84CD
  static _TEXTURE14 := 0x84CE
  static _TEXTURE15 := 0x84CF
  static _TEXTURE16 := 0x84D0
  static _TEXTURE17 := 0x84D1
  static _TEXTURE18 := 0x84D2
  static _TEXTURE19 := 0x84D3
  static _TEXTURE20 := 0x84D4
  static _TEXTURE21 := 0x84D5
  static _TEXTURE22 := 0x84D6
  static _TEXTURE23 := 0x84D7
  static _TEXTURE24 := 0x84D8
  static _TEXTURE25 := 0x84D9
  static _TEXTURE26 := 0x84DA
  static _TEXTURE27 := 0x84DB
  static _TEXTURE28 := 0x84DC
  static _TEXTURE29 := 0x84DD
  static _TEXTURE30 := 0x84DE
  static _TEXTURE31 := 0x84DF
  static _ACTIVE_TEXTURE := 0x84E0
  static _CLIENT_ACTIVE_TEXTURE := 0x84E1
  static _MAX_TEXTURE_UNITS := 0x84E2
  static _NORMAL_MAP := 0x8511
  static _REFLECTION_MAP := 0x8512
  static _TEXTURE_CUBE_MAP := 0x8513
  static _TEXTURE_BINDING_CUBE_MAP := 0x8514
  static _TEXTURE_CUBE_MAP_POSITIVE_X := 0x8515
  static _TEXTURE_CUBE_MAP_NEGATIVE_X := 0x8516
  static _TEXTURE_CUBE_MAP_POSITIVE_Y := 0x8517
  static _TEXTURE_CUBE_MAP_NEGATIVE_Y := 0x8518
  static _TEXTURE_CUBE_MAP_POSITIVE_Z := 0x8519
  static _TEXTURE_CUBE_MAP_NEGATIVE_Z := 0x851A
  static _PROXY_TEXTURE_CUBE_MAP := 0x851B
  static _MAX_CUBE_MAP_TEXTURE_SIZE := 0x851C
  static _COMPRESSED_ALPHA := 0x84E9
  static _COMPRESSED_LUMINANCE := 0x84EA
  static _COMPRESSED_LUMINANCE_ALPHA := 0x84EB
  static _COMPRESSED_INTENSITY := 0x84EC
  static _COMPRESSED_RGB := 0x84ED
  static _COMPRESSED_RGBA := 0x84EE
  static _TEXTURE_COMPRESSION_HINT := 0x84EF
  static _TEXTURE_COMPRESSED_IMAGE_SIZE := 0x86A0
  static _TEXTURE_COMPRESSED := 0x86A1
  static _NUM_COMPRESSED_TEXTURE_FORMATS := 0x86A2
  static _COMPRESSED_TEXTURE_FORMATS := 0x86A3
  static _MULTISAMPLE := 0x809D
  static _SAMPLE_ALPHA_TO_COVERAGE := 0x809E
  static _SAMPLE_ALPHA_TO_ONE := 0x809F
  static _SAMPLE_COVERAGE := 0x80A0
  static _SAMPLE_BUFFERS := 0x80A8
  static _SAMPLES := 0x80A9
  static _SAMPLE_COVERAGE_VALUE := 0x80AA
  static _SAMPLE_COVERAGE_INVERT := 0x80AB
  static _MULTISAMPLE_BIT := 0x20000000
  static _TRANSPOSE_MODELVIEW_MATRIX := 0x84E3
  static _TRANSPOSE_PROJECTION_MATRIX := 0x84E4
  static _TRANSPOSE_TEXTURE_MATRIX := 0x84E5
  static _TRANSPOSE_COLOR_MATRIX := 0x84E6
  static _COMBINE := 0x8570
  static _COMBINE_RGB := 0x8571
  static _COMBINE_ALPHA := 0x8572
  static _SOURCE0_RGB := 0x8580
  static _SOURCE1_RGB := 0x8581
  static _SOURCE2_RGB := 0x8582
  static _SOURCE0_ALPHA := 0x8588
  static _SOURCE1_ALPHA := 0x8589
  static _SOURCE2_ALPHA := 0x858A
  static _OPERAND0_RGB := 0x8590
  static _OPERAND1_RGB := 0x8591
  static _OPERAND2_RGB := 0x8592
  static _OPERAND0_ALPHA := 0x8598
  static _OPERAND1_ALPHA := 0x8599
  static _OPERAND2_ALPHA := 0x859A
  static _RGB_SCALE := 0x8573
  static _ADD_SIGNED := 0x8574
  static _INTERPOLATE := 0x8575
  static _SUBTRACT := 0x84E7
  static _CONSTANT := 0x8576
  static _PRIMARY_COLOR := 0x8577
  static _PREVIOUS := 0x8578
  static _DOT3_RGB := 0x86AE
  static _DOT3_RGBA := 0x86AF
  static _CLAMP_TO_BORDER := 0x812D
  static _DEPTH_BUFFER_BIT := 0x00000100
  static _STENCIL_BUFFER_BIT := 0x00000400
  static _COLOR_BUFFER_BIT := 0x00004000
  static _POINTS := 0x0000
  static _LINES := 0x0001
  static _LINE_LOOP := 0x0002
  static _LINE_STRIP := 0x0003
  static _TRIANGLES := 0x0004
  static _TRIANGLE_STRIP := 0x0005
  static _TRIANGLE_FAN := 0x0006
  static _NEVER := 0x0200
  static _LESS := 0x0201
  static _EQUAL := 0x0202
  static _LEQUAL := 0x0203
  static _GREATER := 0x0204
  static _NOTEQUAL := 0x0205
  static _GEQUAL := 0x0206
  static _ALWAYS := 0x0207
  static _ZERO := 0
  static _ONE := 1
  static _SRC_COLOR := 0x0300
  static _ONE_MINUS_SRC_COLOR := 0x0301
  static _SRC_ALPHA := 0x0302
  static _ONE_MINUS_SRC_ALPHA := 0x0303
  static _DST_ALPHA := 0x0304
  static _ONE_MINUS_DST_ALPHA := 0x0305
  static _DST_COLOR := 0x0306
  static _ONE_MINUS_DST_COLOR := 0x0307
  static _SRC_ALPHA_SATURATE := 0x0308
  static _NONE := 0
  static _FRONT_LEFT := 0x0400
  static _FRONT_RIGHT := 0x0401
  static _BACK_LEFT := 0x0402
  static _BACK_RIGHT := 0x0403
  static _FRONT := 0x0404
  static _BACK := 0x0405
  static _LEFT := 0x0406
  static _RIGHT := 0x0407
  static _FRONT_AND_BACK := 0x0408
  static _NO_ERROR := 0
  static _INVALID_ENUM := 0x0500
  static _INVALID_VALUE := 0x0501
  static _INVALID_OPERATION := 0x0502
  static _OUT_OF_MEMORY := 0x0505
  static _CW := 0x0900
  static _CCW := 0x0901
  static _POINT_SIZE := 0x0B11
  static _POINT_SIZE_RANGE := 0x0B12
  static _POINT_SIZE_GRANULARITY := 0x0B13
  static _LINE_SMOOTH := 0x0B20
  static _LINE_WIDTH := 0x0B21
  static _LINE_WIDTH_RANGE := 0x0B22
  static _LINE_WIDTH_GRANULARITY := 0x0B23
  static _POLYGON_SMOOTH := 0x0B41
  static _CULL_FACE := 0x0B44
  static _CULL_FACE_MODE := 0x0B45
  static _FRONT_FACE := 0x0B46
  static _DEPTH_RANGE := 0x0B70
  static _DEPTH_TEST := 0x0B71
  static _DEPTH_WRITEMASK := 0x0B72
  static _DEPTH_CLEAR_VALUE := 0x0B73
  static _DEPTH_FUNC := 0x0B74
  static _STENCIL_TEST := 0x0B90
  static _STENCIL_CLEAR_VALUE := 0x0B91
  static _STENCIL_FUNC := 0x0B92
  static _STENCIL_VALUE_MASK := 0x0B93
  static _STENCIL_FAIL := 0x0B94
  static _STENCIL_PASS_DEPTH_FAIL := 0x0B95
  static _STENCIL_PASS_DEPTH_PASS := 0x0B96
  static _STENCIL_REF := 0x0B97
  static _STENCIL_WRITEMASK := 0x0B98
  static _VIEWPORT := 0x0BA2
  static _DITHER := 0x0BD0
  static _BLEND_DST := 0x0BE0
  static _BLEND_SRC := 0x0BE1
  static _BLEND := 0x0BE2
  static _LOGIC_OP_MODE := 0x0BF0
  static _COLOR_LOGIC_OP := 0x0BF2
  static _DRAW_BUFFER := 0x0C01
  static _READ_BUFFER := 0x0C02
  static _SCISSOR_BOX := 0x0C10
  static _SCISSOR_TEST := 0x0C11
  static _COLOR_CLEAR_VALUE := 0x0C22
  static _COLOR_WRITEMASK := 0x0C23
  static _DOUBLEBUFFER := 0x0C32
  static _STEREO := 0x0C33
  static _LINE_SMOOTH_HINT := 0x0C52
  static _POLYGON_SMOOTH_HINT := 0x0C53
  static _UNPACK_SWAP_BYTES := 0x0CF0
  static _UNPACK_LSB_FIRST := 0x0CF1
  static _UNPACK_ROW_LENGTH := 0x0CF2
  static _UNPACK_SKIP_ROWS := 0x0CF3
  static _UNPACK_SKIP_PIXELS := 0x0CF4
  static _UNPACK_ALIGNMENT := 0x0CF5
  static _PACK_SWAP_BYTES := 0x0D00
  static _PACK_LSB_FIRST := 0x0D01
  static _PACK_ROW_LENGTH := 0x0D02
  static _PACK_SKIP_ROWS := 0x0D03
  static _PACK_SKIP_PIXELS := 0x0D04
  static _PACK_ALIGNMENT := 0x0D05
  static _MAX_TEXTURE_SIZE := 0x0D33
  static _MAX_VIEWPORT_DIMS := 0x0D3A
  static _SUBPIXEL_BITS := 0x0D50
  static _TEXTURE_1D := 0x0DE0
  static _TEXTURE_2D := 0x0DE1
  static _POLYGON_OFFSET_UNITS := 0x2A00
  static _POLYGON_OFFSET_POINT := 0x2A01
  static _POLYGON_OFFSET_LINE := 0x2A02
  static _POLYGON_OFFSET_FILL := 0x8037
  static _POLYGON_OFFSET_FACTOR := 0x8038
  static _TEXTURE_BINDING_1D := 0x8068
  static _TEXTURE_BINDING_2D := 0x8069
  static _TEXTURE_WIDTH := 0x1000
  static _TEXTURE_HEIGHT := 0x1001
  static _TEXTURE_INTERNAL_FORMAT := 0x1003
  static _TEXTURE_BORDER_COLOR := 0x1004
  static _TEXTURE_RED_SIZE := 0x805C
  static _TEXTURE_GREEN_SIZE := 0x805D
  static _TEXTURE_BLUE_SIZE := 0x805E
  static _TEXTURE_ALPHA_SIZE := 0x805F
  static _DONT_CARE := 0x1100
  static _FASTEST := 0x1101
  static _NICEST := 0x1102
  static _BYTE := 0x1400
  static _UNSIGNED_BYTE := 0x1401
  static _SHORT := 0x1402
  static _UNSIGNED_SHORT := 0x1403
  static _INT := 0x1404
  static _UNSIGNED_INT := 0x1405
  static _FLOAT := 0x1406
  static _DOUBLE := 0x140A
  static _CLEAR := 0x1500
  static _AND := 0x1501
  static _AND_REVERSE := 0x1502
  static _COPY := 0x1503
  static _AND_INVERTED := 0x1504
  static _NOOP := 0x1505
  static _XOR := 0x1506
  static _OR := 0x1507
  static _NOR := 0x1508
  static _EQUIV := 0x1509
  static _INVERT := 0x150A
  static _OR_REVERSE := 0x150B
  static _COPY_INVERTED := 0x150C
  static _OR_INVERTED := 0x150D
  static _NAND := 0x150E
  static _SET := 0x150F
  static _TEXTURE := 0x1702
  static _COLOR := 0x1800
  static _DEPTH := 0x1801
  static _STENCIL := 0x1802
  static _STENCIL_INDEX := 0x1901
  static _DEPTH_COMPONENT := 0x1902
  static _RED := 0x1903
  static _GREEN := 0x1904
  static _BLUE := 0x1905
  static _ALPHA := 0x1906
  static _RGB := 0x1907
  static _RGBA := 0x1908
  static _POINT := 0x1B00
  static _LINE := 0x1B01
  static _FILL := 0x1B02
  static _KEEP := 0x1E00
  static _REPLACE := 0x1E01
  static _INCR := 0x1E02
  static _DECR := 0x1E03
  static _VENDOR := 0x1F00
  static _RENDERER := 0x1F01
  static _VERSION := 0x1F02
  static _EXTENSIONS := 0x1F03
  static _NEAREST := 0x2600
  static _LINEAR := 0x2601
  static _NEAREST_MIPMAP_NEAREST := 0x2700
  static _LINEAR_MIPMAP_NEAREST := 0x2701
  static _NEAREST_MIPMAP_LINEAR := 0x2702
  static _LINEAR_MIPMAP_LINEAR := 0x2703
  static _TEXTURE_MAG_FILTER := 0x2800
  static _TEXTURE_MIN_FILTER := 0x2801
  static _TEXTURE_WRAP_S := 0x2802
  static _TEXTURE_WRAP_T := 0x2803
  static _PROXY_TEXTURE_1D := 0x8063
  static _PROXY_TEXTURE_2D := 0x8064
  static _REPEAT := 0x2901
  static _R3_G3_B2 := 0x2A10
  static _RGB4 := 0x804F
  static _RGB5 := 0x8050
  static _RGB8 := 0x8051
  static _RGB10 := 0x8052
  static _RGB12 := 0x8053
  static _RGB16 := 0x8054
  static _RGBA2 := 0x8055
  static _RGBA4 := 0x8056
  static _RGB5_A1 := 0x8057
  static _RGBA8 := 0x8058
  static _RGB10_A2 := 0x8059
  static _RGBA12 := 0x805A
  static _RGBA16 := 0x805B
  static _DEPTH_COMPONENT32F := 0x8CAC
  static _DEPTH32F_STENCIL8 := 0x8CAD
  static _FLOAT_32_UNSIGNED_INT_24_8_REV := 0x8DAD
  static _INVALID_FRAMEBUFFER_OPERATION := 0x0506
  static _FRAMEBUFFER_ATTACHMENT_COLOR_ENCODING := 0x8210
  static _FRAMEBUFFER_ATTACHMENT_COMPONENT_TYPE := 0x8211
  static _FRAMEBUFFER_ATTACHMENT_RED_SIZE := 0x8212
  static _FRAMEBUFFER_ATTACHMENT_GREEN_SIZE := 0x8213
  static _FRAMEBUFFER_ATTACHMENT_BLUE_SIZE := 0x8214
  static _FRAMEBUFFER_ATTACHMENT_ALPHA_SIZE := 0x8215
  static _FRAMEBUFFER_ATTACHMENT_DEPTH_SIZE := 0x8216
  static _FRAMEBUFFER_ATTACHMENT_STENCIL_SIZE := 0x8217
  static _FRAMEBUFFER_DEFAULT := 0x8218
  static _FRAMEBUFFER_UNDEFINED := 0x8219
  static _DEPTH_STENCIL_ATTACHMENT := 0x821A
  static _MAX_RENDERBUFFER_SIZE := 0x84E8
  static _DEPTH_STENCIL := 0x84F9
  static _UNSIGNED_INT_24_8 := 0x84FA
  static _DEPTH24_STENCIL8 := 0x88F0
  static _TEXTURE_STENCIL_SIZE := 0x88F1
  static _TEXTURE_RED_TYPE := 0x8C10
  static _TEXTURE_GREEN_TYPE := 0x8C11
  static _TEXTURE_BLUE_TYPE := 0x8C12
  static _TEXTURE_ALPHA_TYPE := 0x8C13
  static _TEXTURE_DEPTH_TYPE := 0x8C16
  static _UNSIGNED_NORMALIZED := 0x8C17
  static _FRAMEBUFFER_BINDING := 0x8CA6
  static _DRAW_FRAMEBUFFER_BINDING := 0x8CA6
  static _RENDERBUFFER_BINDING := 0x8CA7
  static _READ_FRAMEBUFFER := 0x8CA8
  static _DRAW_FRAMEBUFFER := 0x8CA9
  static _READ_FRAMEBUFFER_BINDING := 0x8CAA
  static _RENDERBUFFER_SAMPLES := 0x8CAB
  static _FRAMEBUFFER_ATTACHMENT_OBJECT_TYPE := 0x8CD0
  static _FRAMEBUFFER_ATTACHMENT_OBJECT_NAME := 0x8CD1
  static _FRAMEBUFFER_ATTACHMENT_TEXTURE_LEVEL := 0x8CD2
  static _FRAMEBUFFER_ATTACHMENT_TEXTURE_CUBE_MAP_FACE := 0x8CD3
  static _FRAMEBUFFER_ATTACHMENT_TEXTURE_LAYER := 0x8CD4
  static _FRAMEBUFFER_COMPLETE := 0x8CD5
  static _FRAMEBUFFER_INCOMPLETE_ATTACHMENT := 0x8CD6
  static _FRAMEBUFFER_INCOMPLETE_MISSING_ATTACHMENT := 0x8CD7
  static _FRAMEBUFFER_INCOMPLETE_DRAW_BUFFER := 0x8CDB
  static _FRAMEBUFFER_INCOMPLETE_READ_BUFFER := 0x8CDC
  static _FRAMEBUFFER_UNSUPPORTED := 0x8CDD
  static _MAX_COLOR_ATTACHMENTS := 0x8CDF
  static _COLOR_ATTACHMENT0 := 0x8CE0
  static _COLOR_ATTACHMENT1 := 0x8CE1
  static _COLOR_ATTACHMENT2 := 0x8CE2
  static _COLOR_ATTACHMENT3 := 0x8CE3
  static _COLOR_ATTACHMENT4 := 0x8CE4
  static _COLOR_ATTACHMENT5 := 0x8CE5
  static _COLOR_ATTACHMENT6 := 0x8CE6
  static _COLOR_ATTACHMENT7 := 0x8CE7
  static _COLOR_ATTACHMENT8 := 0x8CE8
  static _COLOR_ATTACHMENT9 := 0x8CE9
  static _COLOR_ATTACHMENT10 := 0x8CEA
  static _COLOR_ATTACHMENT11 := 0x8CEB
  static _COLOR_ATTACHMENT12 := 0x8CEC
  static _COLOR_ATTACHMENT13 := 0x8CED
  static _COLOR_ATTACHMENT14 := 0x8CEE
  static _COLOR_ATTACHMENT15 := 0x8CEF
  static _DEPTH_ATTACHMENT := 0x8D00
  static _STENCIL_ATTACHMENT := 0x8D20
  static _FRAMEBUFFER := 0x8D40
  static _RENDERBUFFER := 0x8D41
  static _RENDERBUFFER_WIDTH := 0x8D42
  static _RENDERBUFFER_HEIGHT := 0x8D43
  static _RENDERBUFFER_INTERNAL_FORMAT := 0x8D44
  static _STENCIL_INDEX1 := 0x8D46
  static _STENCIL_INDEX4 := 0x8D47
  static _STENCIL_INDEX8 := 0x8D48
  static _STENCIL_INDEX16 := 0x8D49
  static _RENDERBUFFER_RED_SIZE := 0x8D50
  static _RENDERBUFFER_GREEN_SIZE := 0x8D51
  static _RENDERBUFFER_BLUE_SIZE := 0x8D52
  static _RENDERBUFFER_ALPHA_SIZE := 0x8D53
  static _RENDERBUFFER_DEPTH_SIZE := 0x8D54
  static _RENDERBUFFER_STENCIL_SIZE := 0x8D55
  static _FRAMEBUFFER_INCOMPLETE_MULTISAMPLE := 0x8D56
  static _MAX_SAMPLES := 0x8D57
  static _FRAMEBUFFER_SRGB := 0x8DB9
  static _HALF_FLOAT := 0x140B
  static _MAP_READ_BIT := 0x0001
  static _MAP_WRITE_BIT := 0x0002
  static _MAP_INVALIDATE_RANGE_BIT := 0x0004
  static _MAP_INVALIDATE_BUFFER_BIT := 0x0008
  static _MAP_FLUSH_EXPLICIT_BIT := 0x0010
  static _MAP_UNSYNCHRONIZED_BIT := 0x0020
  static _COMPRESSED_RED_RGTC1 := 0x8DBB
  static _COMPRESSED_SIGNED_RED_RGTC1 := 0x8DBC
  static _COMPRESSED_RG_RGTC2 := 0x8DBD
  static _COMPRESSED_SIGNED_RG_RGTC2 := 0x8DBE
  static _RG := 0x8227
  static _RG_INTEGER := 0x8228
  static _R8 := 0x8229
  static _R16 := 0x822A
  static _RG8 := 0x822B
  static _RG16 := 0x822C
  static _R16F := 0x822D
  static _R32F := 0x822E
  static _RG16F := 0x822F
  static _RG32F := 0x8230
  static _R8I := 0x8231
  static _R8UI := 0x8232
  static _R16I := 0x8233
  static _R16UI := 0x8234
  static _R32I := 0x8235
  static _R32UI := 0x8236
  static _RG8I := 0x8237
  static _RG8UI := 0x8238
  static _RG16I := 0x8239
  static _RG16UI := 0x823A
  static _RG32I := 0x823B
  static _RG32UI := 0x823C
  static _VERTEX_ARRAY_BINDING := 0x85B5
  static _UNIFORM_BUFFER := 0x8A11
  static _UNIFORM_BUFFER_BINDING := 0x8A28
  static _UNIFORM_BUFFER_START := 0x8A29
  static _UNIFORM_BUFFER_SIZE := 0x8A2A
  static _MAX_VERTEX_UNIFORM_BLOCKS := 0x8A2B
  static _MAX_GEOMETRY_UNIFORM_BLOCKS := 0x8A2C
  static _MAX_FRAGMENT_UNIFORM_BLOCKS := 0x8A2D
  static _MAX_COMBINED_UNIFORM_BLOCKS := 0x8A2E
  static _MAX_UNIFORM_BUFFER_BINDINGS := 0x8A2F
  static _MAX_UNIFORM_BLOCK_SIZE := 0x8A30
  static _MAX_COMBINED_VERTEX_UNIFORM_COMPONENTS := 0x8A31
  static _MAX_COMBINED_GEOMETRY_UNIFORM_COMPONENTS := 0x8A32
  static _MAX_COMBINED_FRAGMENT_UNIFORM_COMPONENTS := 0x8A33
  static _UNIFORM_BUFFER_OFFSET_ALIGNMENT := 0x8A34
  static _ACTIVE_UNIFORM_BLOCK_MAX_NAME_LENGTH := 0x8A35
  static _ACTIVE_UNIFORM_BLOCKS := 0x8A36
  static _UNIFORM_TYPE := 0x8A37
  static _UNIFORM_SIZE := 0x8A38
  static _UNIFORM_NAME_LENGTH := 0x8A39
  static _UNIFORM_BLOCK_INDEX := 0x8A3A
  static _UNIFORM_OFFSET := 0x8A3B
  static _UNIFORM_ARRAY_STRIDE := 0x8A3C
  static _UNIFORM_MATRIX_STRIDE := 0x8A3D
  static _UNIFORM_IS_ROW_MAJOR := 0x8A3E
  static _UNIFORM_BLOCK_BINDING := 0x8A3F
  static _UNIFORM_BLOCK_DATA_SIZE := 0x8A40
  static _UNIFORM_BLOCK_NAME_LENGTH := 0x8A41
  static _UNIFORM_BLOCK_ACTIVE_UNIFORMS := 0x8A42
  static _UNIFORM_BLOCK_ACTIVE_UNIFORM_INDICES := 0x8A43
  static _UNIFORM_BLOCK_REFERENCED_BY_VERTEX_SHADER := 0x8A44
  static _UNIFORM_BLOCK_REFERENCED_BY_GEOMETRY_SHADER := 0x8A45
  static _UNIFORM_BLOCK_REFERENCED_BY_FRAGMENT_SHADER := 0x8A46
  static _INVALID_INDEX := 0xFFFFFFFF
  static _COPY_READ_BUFFER := 0x8F36
  static _COPY_WRITE_BUFFER := 0x8F37
  static _DEPTH_CLAMP := 0x864F
  static _QUADS_FOLLOW_PROVOKING_VERTEX_CONVENTION := 0x8E4C
  static _FIRST_VERTEX_CONVENTION := 0x8E4D
  static _LAST_VERTEX_CONVENTION := 0x8E4E
  static _PROVOKING_VERTEX := 0x8E4F
  static _TEXTURE_CUBE_MAP_SEAMLESS := 0x884F
  static _MAX_SERVER_WAIT_TIMEOUT := 0x9111
  static _OBJECT_TYPE := 0x9112
  static _SYNC_CONDITION := 0x9113
  static _SYNC_STATUS := 0x9114
  static _SYNC_FLAGS := 0x9115
  static _SYNC_FENCE := 0x9116
  static _SYNC_GPU_COMMANDS_COMPLETE := 0x9117
  static _UNSIGNALED := 0x9118
  static _SIGNALED := 0x9119
  static _ALREADY_SIGNALED := 0x911A
  static _TIMEOUT_EXPIRED := 0x911B
  static _CONDITION_SATISFIED := 0x911C
  static _WAIT_FAILED := 0x911D
  static _SYNC_FLUSH_COMMANDS_BIT := 0x00000001
  static _TIMEOUT_IGNORED := 0xFFFFFFFFFFFFFFFF
  static _SAMPLE_POSITION := 0x8E50
  static _SAMPLE_MASK := 0x8E51
  static _SAMPLE_MASK_VALUE := 0x8E52
  static _MAX_SAMPLE_MASK_WORDS := 0x8E59
  static _TEXTURE_2D_MULTISAMPLE := 0x9100
  static _PROXY_TEXTURE_2D_MULTISAMPLE := 0x9101
  static _TEXTURE_2D_MULTISAMPLE_ARRAY := 0x9102
  static _PROXY_TEXTURE_2D_MULTISAMPLE_ARRAY := 0x9103
  static _TEXTURE_BINDING_2D_MULTISAMPLE := 0x9104
  static _TEXTURE_BINDING_2D_MULTISAMPLE_ARRAY := 0x9105
  static _TEXTURE_SAMPLES := 0x9106
  static _TEXTURE_FIXED_SAMPLE_LOCATIONS := 0x9107
  static _SAMPLER_2D_MULTISAMPLE := 0x9108
  static _INT_SAMPLER_2D_MULTISAMPLE := 0x9109
  static _UNSIGNED_INT_SAMPLER_2D_MULTISAMPLE := 0x910A
  static _SAMPLER_2D_MULTISAMPLE_ARRAY := 0x910B
  static _INT_SAMPLER_2D_MULTISAMPLE_ARRAY := 0x910C
  static _UNSIGNED_INT_SAMPLER_2D_MULTISAMPLE_ARRAY := 0x910D
  static _MAX_COLOR_TEXTURE_SAMPLES := 0x910E
  static _MAX_DEPTH_TEXTURE_SAMPLES := 0x910F
  static _MAX_INTEGER_SAMPLES := 0x9110
  static _SAMPLE_SHADING_ARB := 0x8C36
  static _MIN_SAMPLE_SHADING_VALUE_ARB := 0x8C37
  static _TEXTURE_CUBE_MAP_ARRAY_ARB := 0x9009
  static _TEXTURE_BINDING_CUBE_MAP_ARRAY_ARB := 0x900A
  static _PROXY_TEXTURE_CUBE_MAP_ARRAY_ARB := 0x900B
  static _SAMPLER_CUBE_MAP_ARRAY_ARB := 0x900C
  static _SAMPLER_CUBE_MAP_ARRAY_SHADOW_ARB := 0x900D
  static _INT_SAMPLER_CUBE_MAP_ARRAY_ARB := 0x900E
  static _UNSIGNED_INT_SAMPLER_CUBE_MAP_ARRAY_ARB := 0x900F
  static _MIN_PROGRAM_TEXTURE_GATHER_OFFSET_ARB := 0x8E5E
  static _MAX_PROGRAM_TEXTURE_GATHER_OFFSET_ARB := 0x8E5F
  static _SHADER_INCLUDE_ARB := 0x8DAE
  static _NAMED_STRING_LENGTH_ARB := 0x8DE9
  static _NAMED_STRING_TYPE_ARB := 0x8DEA
  static _COMPRESSED_RGBA_BPTC_UNORM_ARB := 0x8E8C
  static _COMPRESSED_SRGB_ALPHA_BPTC_UNORM_ARB := 0x8E8D
  static _COMPRESSED_RGB_BPTC_SIGNED_FLOAT_ARB := 0x8E8E
  static _COMPRESSED_RGB_BPTC_UNSIGNED_FLOAT_ARB := 0x8E8F
  static _SRC1_COLOR := 0x88F9
  static _ONE_MINUS_SRC1_COLOR := 0x88FA
  static _ONE_MINUS_SRC1_ALPHA := 0x88FB
  static _MAX_DUAL_SOURCE_DRAW_BUFFERS := 0x88FC
  static _ANY_SAMPLES_PASSED := 0x8C2F
  static _SAMPLER_BINDING := 0x8919
  static _RGB10_A2UI := 0x906F
  static _TEXTURE_SWIZZLE_R := 0x8E42
  static _TEXTURE_SWIZZLE_G := 0x8E43
  static _TEXTURE_SWIZZLE_B := 0x8E44
  static _TEXTURE_SWIZZLE_A := 0x8E45
  static _TEXTURE_SWIZZLE_RGBA := 0x8E46
  static _TIME_ELAPSED := 0x88BF
  static _TIMESTAMP := 0x8E28
  static _INT_2_10_10_10_REV := 0x8D9F
  static _DRAW_INDIRECT_BUFFER := 0x8F3F
  static _DRAW_INDIRECT_BUFFER_BINDING := 0x8F43
  static _GEOMETRY_SHADER_INVOCATIONS := 0x887F
  static _MAX_GEOMETRY_SHADER_INVOCATIONS := 0x8E5A
  static _MIN_FRAGMENT_INTERPOLATION_OFFSET := 0x8E5B
  static _MAX_FRAGMENT_INTERPOLATION_OFFSET := 0x8E5C
  static _FRAGMENT_INTERPOLATION_OFFSET_BITS := 0x8E5D
  static _DOUBLE_VEC2 := 0x8FFC
  static _DOUBLE_VEC3 := 0x8FFD
  static _DOUBLE_VEC4 := 0x8FFE
  static _DOUBLE_MAT2 := 0x8F46
  static _DOUBLE_MAT3 := 0x8F47
  static _DOUBLE_MAT4 := 0x8F48
  static _DOUBLE_MAT2x3 := 0x8F49
  static _DOUBLE_MAT2x4 := 0x8F4A
  static _DOUBLE_MAT3x2 := 0x8F4B
  static _DOUBLE_MAT3x4 := 0x8F4C
  static _DOUBLE_MAT4x2 := 0x8F4D
  static _DOUBLE_MAT4x3 := 0x8F4E
  static _ACTIVE_SUBROUTINES := 0x8DE5
  static _ACTIVE_SUBROUTINE_UNIFORMS := 0x8DE6
  static _ACTIVE_SUBROUTINE_UNIFORM_LOCATIONS := 0x8E47
  static _ACTIVE_SUBROUTINE_MAX_LENGTH := 0x8E48
  static _ACTIVE_SUBROUTINE_UNIFORM_MAX_LENGTH := 0x8E49
  static _MAX_SUBROUTINES := 0x8DE7
  static _MAX_SUBROUTINE_UNIFORM_LOCATIONS := 0x8DE8
  static _NUM_COMPATIBLE_SUBROUTINES := 0x8E4A
  static _COMPATIBLE_SUBROUTINES := 0x8E4B
  static _PATCHES := 0x000E
  static _PATCH_VERTICES := 0x8E72
  static _PATCH_DEFAULT_INNER_LEVEL := 0x8E73
  static _PATCH_DEFAULT_OUTER_LEVEL := 0x8E74
  static _TESS_CONTROL_OUTPUT_VERTICES := 0x8E75
  static _TESS_GEN_MODE := 0x8E76
  static _TESS_GEN_SPACING := 0x8E77
  static _TESS_GEN_VERTEX_ORDER := 0x8E78
  static _TESS_GEN_POINT_MODE := 0x8E79
  static _ISOLINES := 0x8E7A
  static _FRACTIONAL_ODD := 0x8E7B
  static _FRACTIONAL_EVEN := 0x8E7C
  static _MAX_PATCH_VERTICES := 0x8E7D
  static _MAX_TESS_GEN_LEVEL := 0x8E7E
  static _MAX_TESS_CONTROL_UNIFORM_COMPONENTS := 0x8E7F
  static _MAX_TESS_EVALUATION_UNIFORM_COMPONENTS := 0x8E80
  static _MAX_TESS_CONTROL_TEXTURE_IMAGE_UNITS := 0x8E81
  static _MAX_TESS_EVALUATION_TEXTURE_IMAGE_UNITS := 0x8E82
  static _MAX_TESS_CONTROL_OUTPUT_COMPONENTS := 0x8E83
  static _MAX_TESS_PATCH_COMPONENTS := 0x8E84
  static _MAX_TESS_CONTROL_TOTAL_OUTPUT_COMPONENTS := 0x8E85
  static _MAX_TESS_EVALUATION_OUTPUT_COMPONENTS := 0x8E86
  static _MAX_TESS_CONTROL_UNIFORM_BLOCKS := 0x8E89
  static _MAX_TESS_EVALUATION_UNIFORM_BLOCKS := 0x8E8A
  static _MAX_TESS_CONTROL_INPUT_COMPONENTS := 0x886C
  static _MAX_TESS_EVALUATION_INPUT_COMPONENTS := 0x886D
  static _MAX_COMBINED_TESS_CONTROL_UNIFORM_COMPONENTS := 0x8E1E
  static _MAX_COMBINED_TESS_EVALUATION_UNIFORM_COMPONENTS := 0x8E1F
  static _UNIFORM_BLOCK_REFERENCED_BY_TESS_CONTROL_SHADER := 0x84F0
  static _UNIFORM_BLOCK_REFERENCED_BY_TESS_EVALUATION_SHADER := 0x84F1
  static _TESS_EVALUATION_SHADER := 0x8E87
  static _TESS_CONTROL_SHADER := 0x8E88
  static _TRANSFORM_FEEDBACK := 0x8E22
  static _TRANSFORM_FEEDBACK_BUFFER_PAUSED := 0x8E23
  static _TRANSFORM_FEEDBACK_BUFFER_ACTIVE := 0x8E24
  static _TRANSFORM_FEEDBACK_BINDING := 0x8E25
  static _MAX_TRANSFORM_FEEDBACK_BUFFERS := 0x8E70
  static _MAX_VERTEX_STREAMS := 0x8E71
  static _FIXED := 0x140C
  static _IMPLEMENTATION_COLOR_READ_TYPE := 0x8B9A
  static _IMPLEMENTATION_COLOR_READ_FORMAT := 0x8B9B
  static _LOW_FLOAT := 0x8DF0
  static _MEDIUM_FLOAT := 0x8DF1
  static _HIGH_FLOAT := 0x8DF2
  static _LOW_INT := 0x8DF3
  static _MEDIUM_INT := 0x8DF4
  static _HIGH_INT := 0x8DF5
  static _SHADER_COMPILER := 0x8DFA
  static _NUM_SHADER_BINARY_FORMATS := 0x8DF9
  static _MAX_VERTEX_UNIFORM_VECTORS := 0x8DFB
  static _MAX_VARYING_VECTORS := 0x8DFC
  static _MAX_FRAGMENT_UNIFORM_VECTORS := 0x8DFD
  static _PROGRAM_BINARY_RETRIEVABLE_HINT := 0x8257
  static _PROGRAM_BINARY_LENGTH := 0x8741
  static _NUM_PROGRAM_BINARY_FORMATS := 0x87FE
  static _PROGRAM_BINARY_FORMATS := 0x87FF
  static _VERTEX_SHADER_BIT := 0x00000001
  static _FRAGMENT_SHADER_BIT := 0x00000002
  static _GEOMETRY_SHADER_BIT := 0x00000004
  static _TESS_CONTROL_SHADER_BIT := 0x00000008
  static _TESS_EVALUATION_SHADER_BIT := 0x00000010
  static _ALL_SHADER_BITS := 0xFFFFFFFF
  static _PROGRAM_SEPARABLE := 0x8258
  static _ACTIVE_PROGRAM := 0x8259
  static _PROGRAM_PIPELINE_BINDING := 0x825A
  static _MAX_VIEWPORTS := 0x825B
  static _VIEWPORT_SUBPIXEL_BITS := 0x825C
  static _VIEWPORT_BOUNDS_RANGE := 0x825D
  static _LAYER_PROVOKING_VERTEX := 0x825E
  static _VIEWPORT_INDEX_PROVOKING_VERTEX := 0x825F
  static _UNDEFINED_VERTEX := 0x8260
  static _SYNC_CL_EVENT_ARB := 0x8240
  static _SYNC_CL_EVENT_COMPLETE_ARB := 0x8241
  static _DEBUG_OUTPUT_SYNCHRONOUS_ARB := 0x8242
  static _DEBUG_NEXT_LOGGED_MESSAGE_LENGTH_ARB := 0x8243
  static _DEBUG_CALLBACK_FUNCTION_ARB := 0x8244
  static _DEBUG_CALLBACK_USER_PARAM_ARB := 0x8245
  static _DEBUG_SOURCE_API_ARB := 0x8246
  static _DEBUG_SOURCE_WINDOW_SYSTEM_ARB := 0x8247
  static _DEBUG_SOURCE_SHADER_COMPILER_ARB := 0x8248
  static _DEBUG_SOURCE_THIRD_PARTY_ARB := 0x8249
  static _DEBUG_SOURCE_APPLICATION_ARB := 0x824A
  static _DEBUG_SOURCE_OTHER_ARB := 0x824B
  static _DEBUG_TYPE_ERROR_ARB := 0x824C
  static _DEBUG_TYPE_DEPRECATED_BEHAVIOR_ARB := 0x824D
  static _DEBUG_TYPE_UNDEFINED_BEHAVIOR_ARB := 0x824E
  static _DEBUG_TYPE_PORTABILITY_ARB := 0x824F
  static _DEBUG_TYPE_PERFORMANCE_ARB := 0x8250
  static _DEBUG_TYPE_OTHER_ARB := 0x8251
  static _MAX_DEBUG_MESSAGE_LENGTH_ARB := 0x9143
  static _MAX_DEBUG_LOGGED_MESSAGES_ARB := 0x9144
  static _DEBUG_LOGGED_MESSAGES_ARB := 0x9145
  static _DEBUG_SEVERITY_HIGH_ARB := 0x9146
  static _DEBUG_SEVERITY_MEDIUM_ARB := 0x9147
  static _DEBUG_SEVERITY_LOW_ARB := 0x9148
  static _CONTEXT_FLAG_ROBUST_ACCESS_BIT_ARB := 0x00000004
  static _LOSE_CONTEXT_ON_RESET_ARB := 0x8252
  static _GUILTY_CONTEXT_RESET_ARB := 0x8253
  static _INNOCENT_CONTEXT_RESET_ARB := 0x8254
  static _UNKNOWN_CONTEXT_RESET_ARB := 0x8255
  static _RESET_NOTIFICATION_STRATEGY_ARB := 0x8256
  static _NO_RESET_NOTIFICATION_ARB := 0x8261
  static _UNSIGNED_BYTE_3_3_2 := 0x8032
  static _UNSIGNED_SHORT_4_4_4_4 := 0x8033
  static _UNSIGNED_SHORT_5_5_5_1 := 0x8034
  static _UNSIGNED_INT_8_8_8_8 := 0x8035
  static _UNSIGNED_INT_10_10_10_2 := 0x8036
  static _TEXTURE_BINDING_3D := 0x806A
  static _PACK_SKIP_IMAGES := 0x806B
  static _PACK_IMAGE_HEIGHT := 0x806C
  static _UNPACK_SKIP_IMAGES := 0x806D
  static _UNPACK_IMAGE_HEIGHT := 0x806E
  static _TEXTURE_3D := 0x806F
  static _PROXY_TEXTURE_3D := 0x8070
  static _TEXTURE_DEPTH := 0x8071
  static _TEXTURE_WRAP_R := 0x8072
  static _MAX_3D_TEXTURE_SIZE := 0x8073
  static _UNSIGNED_BYTE_2_3_3_REV := 0x8362
  static _UNSIGNED_SHORT_5_6_5 := 0x8363
  static _UNSIGNED_SHORT_5_6_5_REV := 0x8364
  static _UNSIGNED_SHORT_4_4_4_4_REV := 0x8365
  static _UNSIGNED_SHORT_1_5_5_5_REV := 0x8366
  static _UNSIGNED_INT_8_8_8_8_REV := 0x8367
  static _UNSIGNED_INT_2_10_10_10_REV := 0x8368
  static _BGR := 0x80E0
  static _BGRA := 0x80E1
  static _MAX_ELEMENTS_VERTICES := 0x80E8
  static _MAX_ELEMENTS_INDICES := 0x80E9
  static _CLAMP_TO_EDGE := 0x812F
  static _TEXTURE_MIN_LOD := 0x813A
  static _TEXTURE_MAX_LOD := 0x813B
  static _TEXTURE_BASE_LEVEL := 0x813C
  static _TEXTURE_MAX_LEVEL := 0x813D
  static _SMOOTH_POINT_SIZE_RANGE := 0x0B12
  static _SMOOTH_POINT_SIZE_GRANULARITY := 0x0B13
  static _SMOOTH_LINE_WIDTH_RANGE := 0x0B22
  static _SMOOTH_LINE_WIDTH_GRANULARITY := 0x0B23
  static _ALIASED_LINE_WIDTH_RANGE := 0x846E
  static _CONSTANT_COLOR := 0x8001
  static _ONE_MINUS_CONSTANT_COLOR := 0x8002
  static _CONSTANT_ALPHA := 0x8003
  static _ONE_MINUS_CONSTANT_ALPHA := 0x8004
  static _BLEND_COLOR := 0x8005
  static _FUNC_ADD := 0x8006
  static _MIN := 0x8007
  static _MAX := 0x8008
  static _BLEND_EQUATION := 0x8009
  static _FUNC_SUBTRACT := 0x800A
  static _FUNC_REVERSE_SUBTRACT := 0x800B
  static _TEXTURE0 := 0x84C0
  static _TEXTURE1 := 0x84C1
  static _TEXTURE2 := 0x84C2
  static _TEXTURE3 := 0x84C3
  static _TEXTURE4 := 0x84C4
  static _TEXTURE5 := 0x84C5
  static _TEXTURE6 := 0x84C6
  static _TEXTURE7 := 0x84C7
  static _TEXTURE8 := 0x84C8
  static _TEXTURE9 := 0x84C9
  static _TEXTURE10 := 0x84CA
  static _TEXTURE11 := 0x84CB
  static _TEXTURE12 := 0x84CC
  static _TEXTURE13 := 0x84CD
  static _TEXTURE14 := 0x84CE
  static _TEXTURE15 := 0x84CF
  static _TEXTURE16 := 0x84D0
  static _TEXTURE17 := 0x84D1
  static _TEXTURE18 := 0x84D2
  static _TEXTURE19 := 0x84D3
  static _TEXTURE20 := 0x84D4
  static _TEXTURE21 := 0x84D5
  static _TEXTURE22 := 0x84D6
  static _TEXTURE23 := 0x84D7
  static _TEXTURE24 := 0x84D8
  static _TEXTURE25 := 0x84D9
  static _TEXTURE26 := 0x84DA
  static _TEXTURE27 := 0x84DB
  static _TEXTURE28 := 0x84DC
  static _TEXTURE29 := 0x84DD
  static _TEXTURE30 := 0x84DE
  static _TEXTURE31 := 0x84DF
  static _ACTIVE_TEXTURE := 0x84E0
  static _MULTISAMPLE := 0x809D
  static _SAMPLE_ALPHA_TO_COVERAGE := 0x809E
  static _SAMPLE_ALPHA_TO_ONE := 0x809F
  static _SAMPLE_COVERAGE := 0x80A0
  static _SAMPLE_BUFFERS := 0x80A8
  static _SAMPLES := 0x80A9
  static _SAMPLE_COVERAGE_VALUE := 0x80AA
  static _SAMPLE_COVERAGE_INVERT := 0x80AB
  static _TEXTURE_CUBE_MAP := 0x8513
  static _TEXTURE_BINDING_CUBE_MAP := 0x8514
  static _TEXTURE_CUBE_MAP_POSITIVE_X := 0x8515
  static _TEXTURE_CUBE_MAP_NEGATIVE_X := 0x8516
  static _TEXTURE_CUBE_MAP_POSITIVE_Y := 0x8517
  static _TEXTURE_CUBE_MAP_NEGATIVE_Y := 0x8518
  static _TEXTURE_CUBE_MAP_POSITIVE_Z := 0x8519
  static _TEXTURE_CUBE_MAP_NEGATIVE_Z := 0x851A
  static _PROXY_TEXTURE_CUBE_MAP := 0x851B
  static _MAX_CUBE_MAP_TEXTURE_SIZE := 0x851C
  static _COMPRESSED_RGB := 0x84ED
  static _COMPRESSED_RGBA := 0x84EE
  static _TEXTURE_COMPRESSION_HINT := 0x84EF
  static _TEXTURE_COMPRESSED_IMAGE_SIZE := 0x86A0
  static _TEXTURE_COMPRESSED := 0x86A1
  static _NUM_COMPRESSED_TEXTURE_FORMATS := 0x86A2
  static _COMPRESSED_TEXTURE_FORMATS := 0x86A3
  static _CLAMP_TO_BORDER := 0x812D
  static _BLEND_DST_RGB := 0x80C8
  static _BLEND_SRC_RGB := 0x80C9
  static _BLEND_DST_ALPHA := 0x80CA
  static _BLEND_SRC_ALPHA := 0x80CB
  static _POINT_FADE_THRESHOLD_SIZE := 0x8128
  static _DEPTH_COMPONENT16 := 0x81A5
  static _DEPTH_COMPONENT24 := 0x81A6
  static _DEPTH_COMPONENT32 := 0x81A7
  static _MIRRORED_REPEAT := 0x8370
  static _MAX_TEXTURE_LOD_BIAS := 0x84FD
  static _TEXTURE_LOD_BIAS := 0x8501
  static _INCR_WRAP := 0x8507
  static _DECR_WRAP := 0x8508
  static _TEXTURE_DEPTH_SIZE := 0x884A
  static _TEXTURE_COMPARE_MODE := 0x884C
  static _TEXTURE_COMPARE_FUNC := 0x884D
  static _BUFFER_SIZE := 0x8764
  static _BUFFER_USAGE := 0x8765
  static _QUERY_COUNTER_BITS := 0x8864
  static _CURRENT_QUERY := 0x8865
  static _QUERY_RESULT := 0x8866
  static _QUERY_RESULT_AVAILABLE := 0x8867
  static _ARRAY_BUFFER := 0x8892
  static _ELEMENT_ARRAY_BUFFER := 0x8893
  static _ARRAY_BUFFER_BINDING := 0x8894
  static _ELEMENT_ARRAY_BUFFER_BINDING := 0x8895
  static _VERTEX_ATTRIB_ARRAY_BUFFER_BINDING := 0x889F
  static _READ_ONLY := 0x88B8
  static _WRITE_ONLY := 0x88B9
  static _READ_WRITE := 0x88BA
  static _BUFFER_ACCESS := 0x88BB
  static _BUFFER_MAPPED := 0x88BC
  static _BUFFER_MAP_POINTER := 0x88BD
  static _STREAM_DRAW := 0x88E0
  static _STREAM_READ := 0x88E1
  static _STREAM_COPY := 0x88E2
  static _STATIC_DRAW := 0x88E4
  static _STATIC_READ := 0x88E5
  static _STATIC_COPY := 0x88E6
  static _DYNAMIC_DRAW := 0x88E8
  static _DYNAMIC_READ := 0x88E9
  static _DYNAMIC_COPY := 0x88EA
  static _SAMPLES_PASSED := 0x8914
  static _BLEND_EQUATION_RGB := 0x8009
  static _VERTEX_ATTRIB_ARRAY_ENABLED := 0x8622
  static _VERTEX_ATTRIB_ARRAY_SIZE := 0x8623
  static _VERTEX_ATTRIB_ARRAY_STRIDE := 0x8624
  static _VERTEX_ATTRIB_ARRAY_TYPE := 0x8625
  static _CURRENT_VERTEX_ATTRIB := 0x8626
  static _VERTEX_PROGRAM_POINT_SIZE := 0x8642
  static _VERTEX_ATTRIB_ARRAY_POINTER := 0x8645
  static _STENCIL_BACK_FUNC := 0x8800
  static _STENCIL_BACK_FAIL := 0x8801
  static _STENCIL_BACK_PASS_DEPTH_FAIL := 0x8802
  static _STENCIL_BACK_PASS_DEPTH_PASS := 0x8803
  static _MAX_DRAW_BUFFERS := 0x8824
  static _DRAW_BUFFER0 := 0x8825
  static _DRAW_BUFFER1 := 0x8826
  static _DRAW_BUFFER2 := 0x8827
  static _DRAW_BUFFER3 := 0x8828
  static _DRAW_BUFFER4 := 0x8829
  static _DRAW_BUFFER5 := 0x882A
  static _DRAW_BUFFER6 := 0x882B
  static _DRAW_BUFFER7 := 0x882C
  static _DRAW_BUFFER8 := 0x882D
  static _DRAW_BUFFER9 := 0x882E
  static _DRAW_BUFFER10 := 0x882F
  static _DRAW_BUFFER11 := 0x8830
  static _DRAW_BUFFER12 := 0x8831
  static _DRAW_BUFFER13 := 0x8832
  static _DRAW_BUFFER14 := 0x8833
  static _DRAW_BUFFER15 := 0x8834
  static _BLEND_EQUATION_ALPHA := 0x883D
  static _MAX_VERTEX_ATTRIBS := 0x8869
  static _VERTEX_ATTRIB_ARRAY_NORMALIZED := 0x886A
  static _MAX_TEXTURE_IMAGE_UNITS := 0x8872
  static _FRAGMENT_SHADER := 0x8B30
  static _VERTEX_SHADER := 0x8B31
  static _MAX_FRAGMENT_UNIFORM_COMPONENTS := 0x8B49
  static _MAX_VERTEX_UNIFORM_COMPONENTS := 0x8B4A
  static _MAX_VARYING_FLOATS := 0x8B4B
  static _MAX_VERTEX_TEXTURE_IMAGE_UNITS := 0x8B4C
  static _MAX_COMBINED_TEXTURE_IMAGE_UNITS := 0x8B4D
  static _SHADER_TYPE := 0x8B4F
  static _FLOAT_VEC2 := 0x8B50
  static _FLOAT_VEC3 := 0x8B51
  static _FLOAT_VEC4 := 0x8B52
  static _INT_VEC2 := 0x8B53
  static _INT_VEC3 := 0x8B54
  static _INT_VEC4 := 0x8B55
  static _BOOL := 0x8B56
  static _BOOL_VEC2 := 0x8B57
  static _BOOL_VEC3 := 0x8B58
  static _BOOL_VEC4 := 0x8B59
  static _FLOAT_MAT2 := 0x8B5A
  static _FLOAT_MAT3 := 0x8B5B
  static _FLOAT_MAT4 := 0x8B5C
  static _SAMPLER_1D := 0x8B5D
  static _SAMPLER_2D := 0x8B5E
  static _SAMPLER_3D := 0x8B5F
  static _SAMPLER_CUBE := 0x8B60
  static _SAMPLER_1D_SHADOW := 0x8B61
  static _SAMPLER_2D_SHADOW := 0x8B62
  static _DELETE_STATUS := 0x8B80
  static _COMPILE_STATUS := 0x8B81
  static _LINK_STATUS := 0x8B82
  static _VALIDATE_STATUS := 0x8B83
  static _INFO_LOG_LENGTH := 0x8B84
  static _ATTACHED_SHADERS := 0x8B85
  static _ACTIVE_UNIFORMS := 0x8B86
  static _ACTIVE_UNIFORM_MAX_LENGTH := 0x8B87
  static _SHADER_SOURCE_LENGTH := 0x8B88
  static _ACTIVE_ATTRIBUTES := 0x8B89
  static _ACTIVE_ATTRIBUTE_MAX_LENGTH := 0x8B8A
  static _FRAGMENT_SHADER_DERIVATIVE_HINT := 0x8B8B
  static _SHADING_LANGUAGE_VERSION := 0x8B8C
  static _CURRENT_PROGRAM := 0x8B8D
  static _POINT_SPRITE_COORD_ORIGIN := 0x8CA0
  static _LOWER_LEFT := 0x8CA1
  static _UPPER_LEFT := 0x8CA2
  static _STENCIL_BACK_REF := 0x8CA3
  static _STENCIL_BACK_VALUE_MASK := 0x8CA4
  static _STENCIL_BACK_WRITEMASK := 0x8CA5
  static _PIXEL_PACK_BUFFER := 0x88EB
  static _PIXEL_UNPACK_BUFFER := 0x88EC
  static _PIXEL_PACK_BUFFER_BINDING := 0x88ED
  static _PIXEL_UNPACK_BUFFER_BINDING := 0x88EF
  static _FLOAT_MAT2x3 := 0x8B65
  static _FLOAT_MAT2x4 := 0x8B66
  static _FLOAT_MAT3x2 := 0x8B67
  static _FLOAT_MAT3x4 := 0x8B68
  static _FLOAT_MAT4x2 := 0x8B69
  static _FLOAT_MAT4x3 := 0x8B6A
  static _SRGB := 0x8C40
  static _SRGB8 := 0x8C41
  static _SRGB_ALPHA := 0x8C42
  static _SRGB8_ALPHA8 := 0x8C43
  static _COMPRESSED_SRGB := 0x8C48
  static _COMPRESSED_SRGB_ALPHA := 0x8C49
  static _COMPARE_REF_TO_TEXTURE := 0x884E
  static _CLIP_DISTANCE0 := 0x3000
  static _CLIP_DISTANCE1 := 0x3001
  static _CLIP_DISTANCE2 := 0x3002
  static _CLIP_DISTANCE3 := 0x3003
  static _CLIP_DISTANCE4 := 0x3004
  static _CLIP_DISTANCE5 := 0x3005
  static _CLIP_DISTANCE6 := 0x3006
  static _CLIP_DISTANCE7 := 0x3007
  static _MAX_CLIP_DISTANCES := 0x0D32
  static _MAJOR_VERSION := 0x821B
  static _MINOR_VERSION := 0x821C
  static _NUM_EXTENSIONS := 0x821D
  static _CONTEXT_FLAGS := 0x821E
  static _DEPTH_BUFFER := 0x8223
  static _STENCIL_BUFFER := 0x8224
  static _COMPRESSED_RED := 0x8225
  static _COMPRESSED_RG := 0x8226
  static _CONTEXT_FLAG_FORWARD_COMPATIBLE_BIT := 0x0001
  static _RGBA32F := 0x8814
  static _RGB32F := 0x8815
  static _RGBA16F := 0x881A
  static _RGB16F := 0x881B
  static _VERTEX_ATTRIB_ARRAY_INTEGER := 0x88FD
  static _MAX_ARRAY_TEXTURE_LAYERS := 0x88FF
  static _MIN_PROGRAM_TEXEL_OFFSET := 0x8904
  static _MAX_PROGRAM_TEXEL_OFFSET := 0x8905
  static _CLAMP_READ_COLOR := 0x891C
  static _FIXED_ONLY := 0x891D
  static _MAX_VARYING_COMPONENTS := 0x8B4B
  static _TEXTURE_1D_ARRAY := 0x8C18
  static _PROXY_TEXTURE_1D_ARRAY := 0x8C19
  static _TEXTURE_2D_ARRAY := 0x8C1A
  static _PROXY_TEXTURE_2D_ARRAY := 0x8C1B
  static _TEXTURE_BINDING_1D_ARRAY := 0x8C1C
  static _TEXTURE_BINDING_2D_ARRAY := 0x8C1D
  static _R11F_G11F_B10F := 0x8C3A
  static _UNSIGNED_INT_10F_11F_11F_REV := 0x8C3B
  static _RGB9_E5 := 0x8C3D
  static _UNSIGNED_INT_5_9_9_9_REV := 0x8C3E
  static _TEXTURE_SHARED_SIZE := 0x8C3F
  static _TRANSFORM_FEEDBACK_VARYING_MAX_LENGTH := 0x8C76
  static _TRANSFORM_FEEDBACK_BUFFER_MODE := 0x8C7F
  static _MAX_TRANSFORM_FEEDBACK_SEPARATE_COMPONENTS := 0x8C80
  static _TRANSFORM_FEEDBACK_VARYINGS := 0x8C83
  static _TRANSFORM_FEEDBACK_BUFFER_START := 0x8C84
  static _TRANSFORM_FEEDBACK_BUFFER_SIZE := 0x8C85
  static _PRIMITIVES_GENERATED := 0x8C87
  static _TRANSFORM_FEEDBACK_PRIMITIVES_WRITTEN := 0x8C88
  static _RASTERIZER_DISCARD := 0x8C89
  static _MAX_TRANSFORM_FEEDBACK_INTERLEAVED_COMPONENTS := 0x8C8A
  static _MAX_TRANSFORM_FEEDBACK_SEPARATE_ATTRIBS := 0x8C8B
  static _INTERLEAVED_ATTRIBS := 0x8C8C
  static _SEPARATE_ATTRIBS := 0x8C8D
  static _TRANSFORM_FEEDBACK_BUFFER := 0x8C8E
  static _TRANSFORM_FEEDBACK_BUFFER_BINDING := 0x8C8F
  static _RGBA32UI := 0x8D70
  static _RGB32UI := 0x8D71
  static _RGBA16UI := 0x8D76
  static _RGB16UI := 0x8D77
  static _RGBA8UI := 0x8D7C
  static _RGB8UI := 0x8D7D
  static _RGBA32I := 0x8D82
  static _RGB32I := 0x8D83
  static _RGBA16I := 0x8D88
  static _RGB16I := 0x8D89
  static _RGBA8I := 0x8D8E
  static _RGB8I := 0x8D8F
  static _RED_INTEGER := 0x8D94
  static _GREEN_INTEGER := 0x8D95
  static _BLUE_INTEGER := 0x8D96
  static _RGB_INTEGER := 0x8D98
  static _RGBA_INTEGER := 0x8D99
  static _BGR_INTEGER := 0x8D9A
  static _BGRA_INTEGER := 0x8D9B
  static _SAMPLER_1D_ARRAY := 0x8DC0
  static _SAMPLER_2D_ARRAY := 0x8DC1
  static _SAMPLER_1D_ARRAY_SHADOW := 0x8DC3
  static _SAMPLER_2D_ARRAY_SHADOW := 0x8DC4
  static _SAMPLER_CUBE_SHADOW := 0x8DC5
  static _UNSIGNED_INT_VEC2 := 0x8DC6
  static _UNSIGNED_INT_VEC3 := 0x8DC7
  static _UNSIGNED_INT_VEC4 := 0x8DC8
  static _INT_SAMPLER_1D := 0x8DC9
  static _INT_SAMPLER_2D := 0x8DCA
  static _INT_SAMPLER_3D := 0x8DCB
  static _INT_SAMPLER_CUBE := 0x8DCC
  static _INT_SAMPLER_1D_ARRAY := 0x8DCE
  static _INT_SAMPLER_2D_ARRAY := 0x8DCF
  static _UNSIGNED_INT_SAMPLER_1D := 0x8DD1
  static _UNSIGNED_INT_SAMPLER_2D := 0x8DD2
  static _UNSIGNED_INT_SAMPLER_3D := 0x8DD3
  static _UNSIGNED_INT_SAMPLER_CUBE := 0x8DD4
  static _UNSIGNED_INT_SAMPLER_1D_ARRAY := 0x8DD6
  static _UNSIGNED_INT_SAMPLER_2D_ARRAY := 0x8DD7
  static _QUERY_WAIT := 0x8E13
  static _QUERY_NO_WAIT := 0x8E14
  static _QUERY_BY_REGION_WAIT := 0x8E15
  static _QUERY_BY_REGION_NO_WAIT := 0x8E16
  static _BUFFER_ACCESS_FLAGS := 0x911F
  static _BUFFER_MAP_LENGTH := 0x9120
  static _BUFFER_MAP_OFFSET := 0x9121
  static _SAMPLER_2D_RECT := 0x8B63
  static _SAMPLER_2D_RECT_SHADOW := 0x8B64
  static _SAMPLER_BUFFER := 0x8DC2
  static _INT_SAMPLER_2D_RECT := 0x8DCD
  static _INT_SAMPLER_BUFFER := 0x8DD0
  static _UNSIGNED_INT_SAMPLER_2D_RECT := 0x8DD5
  static _UNSIGNED_INT_SAMPLER_BUFFER := 0x8DD8
  static _TEXTURE_BUFFER := 0x8C2A
  static _MAX_TEXTURE_BUFFER_SIZE := 0x8C2B
  static _TEXTURE_BINDING_BUFFER := 0x8C2C
  static _TEXTURE_BUFFER_DATA_STORE_BINDING := 0x8C2D
  static _TEXTURE_BUFFER_FORMAT := 0x8C2E
  static _TEXTURE_RECTANGLE := 0x84F5
  static _TEXTURE_BINDING_RECTANGLE := 0x84F6
  static _PROXY_TEXTURE_RECTANGLE := 0x84F7
  static _MAX_RECTANGLE_TEXTURE_SIZE := 0x84F8
  static _RED_SNORM := 0x8F90
  static _RG_SNORM := 0x8F91
  static _RGB_SNORM := 0x8F92
  static _RGBA_SNORM := 0x8F93
  static _R8_SNORM := 0x8F94
  static _RG8_SNORM := 0x8F95
  static _RGB8_SNORM := 0x8F96
  static _RGBA8_SNORM := 0x8F97
  static _R16_SNORM := 0x8F98
  static _RG16_SNORM := 0x8F99
  static _RGB16_SNORM := 0x8F9A
  static _RGBA16_SNORM := 0x8F9B
  static _SIGNED_NORMALIZED := 0x8F9C
  static _PRIMITIVE_RESTART := 0x8F9D
  static _PRIMITIVE_RESTART_INDEX := 0x8F9E
  static _CONTEXT_CORE_PROFILE_BIT := 0x00000001
  static _CONTEXT_COMPATIBILITY_PROFILE_BIT := 0x00000002
  static _LINES_ADJACENCY := 0x000A
  static _LINE_STRIP_ADJACENCY := 0x000B
  static _TRIANGLES_ADJACENCY := 0x000C
  static _TRIANGLE_STRIP_ADJACENCY := 0x000D
  static _PROGRAM_POINT_SIZE := 0x8642
  static _MAX_GEOMETRY_TEXTURE_IMAGE_UNITS := 0x8C29
  static _FRAMEBUFFER_ATTACHMENT_LAYERED := 0x8DA7
  static _FRAMEBUFFER_INCOMPLETE_LAYER_TARGETS := 0x8DA8
  static _GEOMETRY_SHADER := 0x8DD9
  static _GEOMETRY_VERTICES_OUT := 0x8916
  static _GEOMETRY_INPUT_TYPE := 0x8917
  static _GEOMETRY_OUTPUT_TYPE := 0x8918
  static _MAX_GEOMETRY_UNIFORM_COMPONENTS := 0x8DDF
  static _MAX_GEOMETRY_OUTPUT_VERTICES := 0x8DE0
  static _MAX_GEOMETRY_TOTAL_OUTPUT_COMPONENTS := 0x8DE1
  static _MAX_VERTEX_OUTPUT_COMPONENTS := 0x9122
  static _MAX_GEOMETRY_INPUT_COMPONENTS := 0x9123
  static _MAX_GEOMETRY_OUTPUT_COMPONENTS := 0x9124
  static _MAX_FRAGMENT_INPUT_COMPONENTS := 0x9125
  static _CONTEXT_PROFILE_MASK := 0x9126
  static _VERTEX_ATTRIB_ARRAY_DIVISOR := 0x88FE
  static _SAMPLE_SHADING := 0x8C36
  static _MIN_SAMPLE_SHADING_VALUE := 0x8C37
  static _MIN_PROGRAM_TEXTURE_GATHER_OFFSET := 0x8E5E
  static _MAX_PROGRAM_TEXTURE_GATHER_OFFSET := 0x8E5F
  static _TEXTURE_CUBE_MAP_ARRAY := 0x9009
  static _TEXTURE_BINDING_CUBE_MAP_ARRAY := 0x900A
  static _PROXY_TEXTURE_CUBE_MAP_ARRAY := 0x900B
  static _SAMPLER_CUBE_MAP_ARRAY := 0x900C
  static _SAMPLER_CUBE_MAP_ARRAY_SHADOW := 0x900D
  static _INT_SAMPLER_CUBE_MAP_ARRAY := 0x900E
  static _UNSIGNED_INT_SAMPLER_CUBE_MAP_ARRAY := 0x900F
  static _TRUE := 1
  static _FALSE := 0
  if (_%def%)
    return _%def%
  else if def is xdigit
    return def
  return 0
}

__GL_OR(def)
{
  r := 0
  Loop, parse, def, |, % " `t`r`n"
    r |= __GL_(A_LoopField)
  return r
}

__GL_FROM(def, from)
{
  Loop, parse, from, % " "
  {
    if (__GL_(A_LoopField) = def)
      return A_LoopField
  }
}

__GL_GLU_(def)
{
  static _VERSION_1_1 := 1
  static _VERSION_1_2 := 1
  static _VERSION := 100800
  static _EXTENSIONS := 100801
  static _INVALID_ENUM := 100900
  static _INVALID_VALUE := 100901
  static _OUT_OF_MEMORY := 100902
  static _INVALID_OPERATION := 100904
  static _OUTLINE_POLYGON := 100240
  static _OUTLINE_PATCH := 100241
  static _NURBS_ERROR1 := 100251
  static _NURBS_ERROR2 := 100252
  static _NURBS_ERROR3 := 100253
  static _NURBS_ERROR4 := 100254
  static _NURBS_ERROR5 := 100255
  static _NURBS_ERROR6 := 100256
  static _NURBS_ERROR7 := 100257
  static _NURBS_ERROR8 := 100258
  static _NURBS_ERROR9 := 100259
  static _NURBS_ERROR10 := 100260
  static _NURBS_ERROR11 := 100261
  static _NURBS_ERROR12 := 100262
  static _NURBS_ERROR13 := 100263
  static _NURBS_ERROR14 := 100264
  static _NURBS_ERROR15 := 100265
  static _NURBS_ERROR16 := 100266
  static _NURBS_ERROR17 := 100267
  static _NURBS_ERROR18 := 100268
  static _NURBS_ERROR19 := 100269
  static _NURBS_ERROR20 := 100270
  static _NURBS_ERROR21 := 100271
  static _NURBS_ERROR22 := 100272
  static _NURBS_ERROR23 := 100273
  static _NURBS_ERROR24 := 100274
  static _NURBS_ERROR25 := 100275
  static _NURBS_ERROR26 := 100276
  static _NURBS_ERROR27 := 100277
  static _NURBS_ERROR28 := 100278
  static _NURBS_ERROR29 := 100279
  static _NURBS_ERROR30 := 100280
  static _NURBS_ERROR31 := 100281
  static _NURBS_ERROR32 := 100282
  static _NURBS_ERROR33 := 100283
  static _NURBS_ERROR34 := 100284
  static _NURBS_ERROR35 := 100285
  static _NURBS_ERROR36 := 100286
  static _NURBS_ERROR37 := 100287
  static _AUTO_LOAD_MATRIX := 100200
  static _CULLING := 100201
  static _SAMPLING_TOLERANCE := 100203
  static _DISPLAY_MODE := 100204
  static _PARAMETRIC_TOLERANCE := 100202
  static _SAMPLING_METHOD := 100205
  static _U_STEP := 100206
  static _V_STEP := 100207
  static _PATH_LENGTH := 100215
  static _PARAMETRIC_ERROR := 100216
  static _DOMAIN_DISTANCE := 100217
  static _MAP1_TRIM_2 := 100210
  static _MAP1_TRIM_3 := 100211
  static _POINT := 100010
  static _LINE := 100011
  static _FILL := 100012
  static _SILHOUETTE := 100013
  static _ERROR := 100103
  static _SMOOTH := 100000
  static _FLAT := 100001
  static _NONE := 100002
  static _OUTSIDE := 100020
  static _INSIDE := 100021
  static _TESS_BEGIN := 100100
  static _BEGIN := 100100
  static _TESS_VERTEX := 100101
  static _VERTEX := 100101
  static _TESS_END := 100102
  static _END := 100102
  static _TESS_ERROR := 100103
  static _TESS_EDGE_FLAG := 100104
  static _EDGE_FLAG := 100104
  static _TESS_COMBINE := 100105
  static _TESS_BEGIN_DATA := 100106
  static _TESS_VERTEX_DATA := 100107
  static _TESS_END_DATA := 100108
  static _TESS_ERROR_DATA := 100109
  static _TESS_EDGE_FLAG_DATA := 100110
  static _TESS_COMBINE_DATA := 100111
  static _CW := 100120
  static _CCW := 100121
  static _INTERIOR := 100122
  static _EXTERIOR := 100123
  static _UNKNOWN := 100124
  static _TESS_WINDING_RULE := 100140
  static _TESS_BOUNDARY_ONLY := 100141
  static _TESS_TOLERANCE := 100142
  static _TESS_ERROR1 := 100151
  static _TESS_ERROR2 := 100152
  static _TESS_ERROR3 := 100153
  static _TESS_ERROR4 := 100154
  static _TESS_ERROR5 := 100155
  static _TESS_ERROR6 := 100156
  static _TESS_ERROR7 := 100157
  static _TESS_ERROR8 := 100158
  static _TESS_MISSING_BEGIN_POLYGON := 100151
  static _TESS_MISSING_BEGIN_CONTOUR := 100152
  static _TESS_MISSING_END_POLYGON := 100153
  static _TESS_MISSING_END_CONTOUR := 100154
  static _TESS_COORD_TOO_LARGE := 100155
  static _TESS_NEED_COMBINE_CALLBACK := 100156
  static _TESS_WINDING_ODD := 100130
  static _TESS_WINDING_NONZERO := 100131
  static _TESS_WINDING_POSITIVE := 100132
  static _TESS_WINDING_NEGATIVE := 100133
  static _TESS_WINDING_ABS_GEQ_TWO := 100134
  static _INCOMPATIBLE_GL_VERSION := 100903
  static _TESS_MAX_COORD := 1.0
  static _TRUE := 1
  static _FALSE := 0
  if (_%def%)
    return _%def%
  else if def is xdigit
    return def
  return 0
}

__GL_GLU_OR(def)
{
  r := 0
  Loop, parse, def, |, % " `t`r`n"
    r |= __GL_GLU_(A_LoopField)
  return r
}

__GL_GLU_FROM(def, from)
{
  Loop, parse, from, % " "
  {
    if (__GL_GLU_(A_LoopField) = def)
      return A_LoopField
  }
}

__GL_WGL_(def)
{
  static _SWAP_MAIN_PLANE := 1
  static _SWAP_OVERLAY1 := 2
  static _SWAP_OVERLAY2 := 4
  static _SWAP_OVERLAY3 := 8
  static _SWAP_OVERLAY4 := 16
  static _SWAP_OVERLAY5 := 32
  static _SWAP_OVERLAY6 := 64
  static _SWAP_OVERLAY7 := 128
  static _SWAP_OVERLAY8 := 256
  static _SWAP_OVERLAY9 := 512
  static _SWAP_OVERLAY10 := 1024
  static _SWAP_OVERLAY11 := 2048
  static _SWAP_OVERLAY12 := 4096
  static _SWAP_OVERLAY13 := 8192
  static _SWAP_OVERLAY14 := 16384
  static _SWAP_OVERLAY15 := 32768
  static _SWAP_UNDERLAY1 := 65536
  static _SWAP_UNDERLAY2 := 0x20000
  static _SWAP_UNDERLAY3 := 0x40000
  static _SWAP_UNDERLAY4 := 0x80000
  static _SWAP_UNDERLAY5 := 0x100000
  static _SWAP_UNDERLAY6 := 0x200000
  static _SWAP_UNDERLAY7 := 0x400000
  static _SWAP_UNDERLAY8 := 0x800000
  static _SWAP_UNDERLAY9 := 0x1000000
  static _SWAP_UNDERLAY10 := 0x2000000
  static _SWAP_UNDERLAY11 := 0x4000000
  static _SWAP_UNDERLAY12 := 0x8000000
  static _SWAP_UNDERLAY13 := 0x10000000
  static _SWAP_UNDERLAY14 := 0x20000000
  static _SWAP_UNDERLAY15 := 0x40000000
  static _FONT_LINES := 0
  static _FONT_POLYGONS := 1
  if (_%def%)
    return _%def%
  else if def is xdigit
    return def
  return 0
}

__GL_WGL_OR(def)
{
  r := 0
  Loop, parse, def, |, % " `t`r`n"
    r |= __GL_WGL_(A_LoopField)
  return r
}

__GL_WGL_FROM(def, from)
{
  Loop, parse, from, % " "
  {
    if (__GL_WGL_(A_LoopField) = def)
      return A_LoopField
  }
}

__GL_PFD_(def)
{
  static _TYPE_RGBA := 0
  static _TYPE_COLORINDEX := 1
  static _MAIN_PLANE := 0
  static _OVERLAY_PLANE := 1
  static _UNDERLAY_PLANE := -1
  static _DOUBLEBUFFER := 1
  static _STEREO := 2
  static _DRAW_TO_WINDOW := 4
  static _DRAW_TO_BITMAP := 8
  static _SUPPORT_GDI := 16
  static _SUPPORT_OPENGL := 32
  static _GENERIC_FORMAT := 64
  static _NEED_PALETTE := 128
  static _NEED_SYSTEM_PALETTE := 0x00000100
  static _SWAP_EXCHANGE := 0x00000200
  static _SWAP_COPY := 0x00000400
  static _SWAP_LAYER_BUFFERS := 0x00000800
  static _GENERIC_ACCELERATED := 0x00001000
  static _DEPTH_DONTCARE := 0x20000000
  static _DOUBLEBUFFER_DONTCARE := 0x40000000
  static _STEREO_DONTCARE := 0x80000000
  if (_%def%)
    return _%def%
  else if def is xdigit
    return def
  return 0
}

__GL_PFD_OR(def)
{
  r := 0
  Loop, parse, def, |, % " `t`r`n"
    r |= __GL_PFD_(A_LoopField)
  return r
}

__GL_PFD_FROM(def, from)
{
  Loop, parse, from, % " "
  {
    if (__GL_PFD_(A_LoopField) = def)
      return A_LoopField
  }
}

__GL_LPD_(def)
{
  static _DOUBLEBUFFER := 1
  static _STEREO := 2
  static _SUPPORT_GDI := 16
  static _SUPPORT_OPENGL := 32
  static _SHARE_DEPTH := 64
  static _SHARE_STENCIL := 128
  static _SHARE_ACCUM := 256
  static _SWAP_EXCHANGE := 512
  static _SWAP_COPY := 1024
  static _TRANSPARENT := 4096
  static _TYPE_RGBA := 0
  static _TYPE_COLORINDEX := 1
  if (_%def%)
    return _%def%
  else if def is xdigit
    return def
  return 0
}

__GL_LPD_OR(def)
{
  r := 0
  Loop, parse, def, |, % " `t`r`n"
    r |= __GL_LPD_(A_LoopField)
  return r
}

__GL_LPD_FROM(def, from)
{
  Loop, parse, from, % " "
  {
    if (__GL_LPD_(A_LoopField) = def)
      return A_LoopField
  }
}

__GL_DIB_(def)
{
  static _RGB_COLORS := 0
  static _PAL_COLORS := 1
  if (_%def%)
    return _%def%
  else if def is xdigit
    return def
  return 0
}

__GL_BI(def)
{
  static _RGB := 0
  static _RLE8 := 1
  static _RLE4 := 2
  static _BITFIELDS := 3
  static _JPEG := 4
  static _PNG := 5
  if (_%def%)
    return _%def%
  else if def is xdigit
    return def
  return 0
}