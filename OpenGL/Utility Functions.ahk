InspectError()
{
 ErrorCode := DllCall("opengl32\glGetError"), 
 If A_IsUnicode
  ErrorString := StrGet(DllCall("glu32\gluErrorString","UInt",ErrorCode,"UPtr"),"","CP0")
 Else
  ErrorString := DllCall("glu32\gluErrorString","UInt",ErrorCode,"Str")
 Return, "ErrorLevel: """ . ErrorLevel . """`n" . ErrorCode . ": """ . ErrorString . """"
}

ShowExtensions()
{
 Extensions := "OpenGL " . DllCall("opengl32\glGetString","UInt",0x1F02,"AStr") . "`n`nAvailable OpenGL Extensions:`n" . DllCall("opengl32\glGetString","UInt",0x1F03,"AStr") . "`n`nAvailable WGL Extensions:`n" . DllCall(DllCall("opengl32\wglGetProcAddress","AStr","wglGetExtensionsStringARB","Ptr"),"Ptr",DllCall("opengl32\wglGetCurrentDC","Ptr"),"AStr")
}