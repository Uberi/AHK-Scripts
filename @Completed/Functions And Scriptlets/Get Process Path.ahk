;AHK AHK_L
#NoEnv

;/*
Process, Exist
MsgBox % GetProcessPath(ErrorLevel)
*/

GetProcessPath(ProcessPID)
{ ;returns the process path on success, otherwise a blank string
 Length := 4096
 hProcess := DllCall("OpenProcess","UInt",0x0010 | 0x0400,"Int",0,"UInt",ProcessPID,"Ptr") ;PROCESS_VM_READ (0x0010) | PROCESS_QUERY_INFORMATION (0x0400)
 If !hProcess
  Return
 VarSetCapacity(ProcessPath,Length,0)
 Length >>= !!A_IsUnicode
 DllCall("QueryFullProcessImageName","UPtr",hProcess,"Int",0,"UPtr",&ProcessPath,"UInt*",Length)
 DllCall("CloseHandle","UPtr",hProcess)
 Return, StrGet(&ProcessPath,Length + 1)
}