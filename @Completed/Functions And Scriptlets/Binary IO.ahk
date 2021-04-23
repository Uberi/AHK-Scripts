;AHK v1
#NoEnv

/*
File := A_ScriptFullPath
File1 := A_ScriptDir . "\Test.txt"

DataLen := BinRead(File,Data)
BinWrite(File1,Data,DataLen)
*/

BinWrite(File,ByRef Data,DataLen,WriteLength = 0,Offset = 0,SetEnd = 0)
{
 UPtr := A_PtrSize ? "UPtr" : "UInt"
 Return, (hFile := DllCall("CreateFile",UPtr,&File,"UInt",0x40000000,"UInt",0,"UInt",0,"UInt",4,"UInt",0,"UInt",0) && DllCall("SetFilePointerEx","UInt",hFile,"Int64",Offset,"UInt",0,"Int",(Offset < 0) ? 2 : 0) && DllCall("WriteFile","UInt",hFile,UPtr,&Data,"UInt",DataLen,"UInt",0,"UInt",0) && DllCall("CloseHandle","UInt",hFile))
}

BinRead(File,ByRef Data,ReadAmount = 0,Offset = 0)
{
 UPtr := A_PtrSize ? "UPtr" : "UInt", hFile := DllCall("CreateFile",UPtr,&File,"UInt",0x80000000,"UInt",3,"UInt",0,"UInt",3,"UInt",0,"UInt",0), DllCall("SetFilePointerEx","UInt",hFile,"Int64",Offset,"UInt",0,"Int",(Offset < 0) ? 2 : 0)
 If !hFile
  Return, 0
 FileGetSize, FileSize, %File%
 % (!ReadAmount || ReadAmount > FileSize) ? (ReadAmount := FileSize)
 VarSetCapacity(Data,ReadAmount,10), DllCall("ReadFile","UInt",hFile,UPtr,&Data,"UInt",ReadAmount,"UInt*",AmountRead,"UInt",0), DllCall("CloseHandle","UInt",hFile)
 Return, AmountRead
}