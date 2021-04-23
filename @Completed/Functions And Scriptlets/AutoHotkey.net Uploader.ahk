;AHK v1
#NoEnv

;MsgBox % AutoHotkeySiteUpload("Uberi","passwordgoeshere",A_ScriptFullPath,"Test.ahk")

AutoHotkeySiteUpload(SiteUsername,SitePassword,LocalFile,RemoteFile)
{ ;returns 1 on upload error, 0 otherwise
 UPtr := A_PtrSize ? "UPtr" : "UInt"
 hModule := DllCall("LoadLibrary","Str","wininet.dll")
 hInternet := DllCall("wininet\InternetOpen","Str","AutoHotkey","UInt",0,"UInt",0,"UInt",0,"UInt",0)
 If !hInternet
  Return, 1
 hConnection := DllCall("wininet\InternetConnect","UInt",hInternet,"Str","autohotkey.net","UInt",21,UPtr,&SiteUsername,UPtr,&SitePassword,"UInt",1,"UInt",0,"UInt",0)
 If !hConnection
  Return, 1
 If !DllCall("wininet\FtpPutFile","UInt",hConnection,UPtr,&LocalFile,UPtr,&RemoteFile,"UInt",0,"UInt",0)
  Return, 1
 If !DllCall("wininet\InternetCloseHandle","UInt",hConnection)
  Return, 1
 If !DllCall("wininet\InternetCloseHandle","UInt",hInternet)
  Return, 1
 DllCall("FreeLibrary",UPtr,hModule)
 Return, 0
}