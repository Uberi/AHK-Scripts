#NoEnv

MsgBox % GetInternetTime()

GetInternetTime()
{
 hModule := DllCall("LoadLibrary","Str","wininet.dll"), hInternet := DllCall("wininet\InternetOpenA","Str","","UInt",0,"UInt",0,"UInt",0,"UInt",0), hURL := DllCall("wininet\InternetOpenUrlA","UInt",hInternet,"Str","http://time.nist.gov:13/","Str","","UInt",0,"UInt",0x80000000,"UInt",0), VarSetCapacity(Temp1,56,0), DllCall("wininet\InternetReadFile","UInt",hURL,"UInt",&Temp1,"UInt",56,"UInt*",ReadAmount), VarSetCapacity(Temp1,-1), DllCall("wininet\InternetCloseHandle","UInt",hURL), DllCall("wininet\InternetCloseHandle","UInt",hInternet), DllCall("FreeLibrary","UInt",hModule)
 If !Temp1
  Return
 Temp2 := InStr(Temp1," ") + 1, Temp3 := InStr(Temp1," ",False,Temp2), Temp2 := SubStr(Temp1,Temp2,Temp3 - Temp2), Temp3 ++, Temp4 := InStr(Temp1," ",False,Temp3), Temp3 := SubStr(Temp1,Temp3,Temp4 - Temp3)
 StringReplace, Temp2, Temp2, -,, All
 StringReplace, Temp3, Temp3, :,, All
 TimeStamp := SubStr(A_YYYY,1,2) . Temp2 . Temp3
 If TimeStamp Is Time
  Return, TimeStamp
}