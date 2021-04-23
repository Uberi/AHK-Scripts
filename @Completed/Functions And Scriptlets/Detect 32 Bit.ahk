;AHK v1
#NoEnv

;MsgBox % Is64Bit()

Is64Bit()
{
 If (A_PtrSize = 8)
  Return, 1
 UPtr := A_PtrSize ? "UPtr" : "UInt", Is64Bit := 0
 DllCall("IsWow64Process",UPtr,DllCall("GetCurrentProcess",UPtr),"Int*",Is64Bit)
 Return, Is64Bit
}