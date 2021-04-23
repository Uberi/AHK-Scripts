;--Written by AmA--

OpenMemoryfromProcess(process)
{
Process,Exist,%process%
PID = %ErrorLevel%
HWND := DllCall("OpenProcess","Uint",0x38,"int",0,"int",PID)
return HWND
}

OpenMemoryfromTitle(title)
{
WinGet,PID,PID,%title%
HWND := DllCall("OpenProcess","Uint",0x38,"int",0,"int",PID)
return HWND
}

CloseMemory(hwnd)
{
return DllCall("CloseHandle", "int", hwnd)
}

WriteMemory(hwnd,address,writevalue,datatype="int",length=4,offset=0)
{
VarSetCapacity(finalvalue,length, 0)
NumPut(writevalue,finalvalue,0,datatype)
return DllCall("WriteProcessMemory","Uint",hwnd,"Uint",address+offset,"Uint",&finalvalue,"Uint",length,"Uint",0)
}

ReadMemory(hwnd,address,datatype="int",length=4,offset=0)
{
VarSetCapacity(readvalue,length, 0)
DllCall("ReadProcessMemory","Uint",hwnd,"Uint",address+offset,"Str",readvalue,"Uint",length,"Uint *",0)
finalvalue := NumGet(readvalue,0,datatype)
return finalvalue
}

WriteMemoryPointer(hwnd,base,writevalue,datatype="int",length=4,offset1=0,offset2=0,offset3=0,offset4=0,offset5=0,offset6=0,offset7=0,offset8=0)
{
offset9=0
Loop 8
{
next := A_Index + 1
if (offset%A_Index% = 0) && (offset%next% = 0)
{
}
else
{
baseresult := ReadMemory(hwnd,base)
Offset := Offset%A_Index%
SetFormat, integer, h
base := baseresult + Offset
SetFormat, integer, d
}
}
return WriteMemory(hwnd,address,writevalue,datatype,length)
}

ReadMemoryPointer(hwnd,base,datatype="int",length=4,offset1=0,offset2=0,offset3=0,offset4=0,offset5=0,offset6=0,offset7=0,offset8=0)
{
offset9=0
Loop 8
{
next := A_Index + 1
if (offset%A_Index% = 0) && (offset%next% = 0)
{
}
else
{
baseresult := ReadMemory(hwnd,base)
Offset := Offset%A_Index%
SetFormat, integer, h
base := baseresult + Offset
SetFormat, integer, d
}
}
return ReadMemory(hwnd,base,datatyp,length)
}

SetPrivileg(privileg = "SeDebugPrivilege")
{
success := DllCall("advapi32.dll\LookupPrivilegeValueA","uint",0,"str",privileg,"int64*",luid_SeDebugPrivilege)
if (success = 1) && (ErrorLevel = 0)
{
returnval = 0
}
else
{
returnval = %ErrorLevel%
}
return %returnval%
}