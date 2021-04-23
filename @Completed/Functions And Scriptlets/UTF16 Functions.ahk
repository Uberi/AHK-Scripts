;AHK v1
#NoEnv

/*
String := "abc 123"
ANSIToUnicode(String,UnicodeString)
UnicodeToANSI(UnicodeString,String1)
MsgBox % String1
*/

ANSIToUnicode(ByRef String,ByRef UnicodeString,CodePage = 0)
{
 UPtr := A_PtrSize ? "Ptr" : "UInt"
 StringLength := DllCall("MultiByteToWideChar","UInt",CodePage,"UInt",0,UPtr,&String,"Int",-1,UPtr,0,"Int",0), VarSetCapacity(UnicodeString,StringLength << 1), DllCall("MultiByteToWideChar","UInt",CodePage,"UInt",0,UPtr,&String,"Int",-1,UPtr,&UnicodeString,"Int",StringLength)
}

UnicodeToANSI(ByRef UnicodeString,ByRef String,CodePage = 0)
{
 UPtr := A_PtrSize ? "Ptr" : "UInt"
 StringLength := DllCall("WideCharToMultiByte","UInt",CodePage,"UInt",0,UPtr,&UnicodeString,"Int",-1,UPtr,0,"Int",0,UPtr,0,UPtr,0), VarSetCapacity(String,StringLength), DllCall("WideCharToMultiByte","UInt",CodePage,"UInt",0,UPtr,&UnicodeString,"Int",-1,UPtr,&String,"Int",StringLength,UPtr,0,UPtr,0)
}