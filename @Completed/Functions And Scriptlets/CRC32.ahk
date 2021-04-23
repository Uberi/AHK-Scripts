;AHK v1
#NoEnv

/*
;CRC checksums are suitable only for error checking, as they can be faked easily
Temp1 = abcdefghijklmnopqrstuvwxyz
MsgBox % CRC32(Temp1,StrLen(Temp1))
*/

CRC32(ByRef Data,DataLen)
{
 Return, DllCall("ntdll\RtlComputeCrc32","UInt",0,A_PtrSize ? "UPtr" : "UInt",&Data,"Int",DataLen)
}