#NoEnv

/*
Gui, Show, w800 h600, WebBrowser
Gui, +LastFound
hWnd := WinExist()

CreateHTMLControl(hWnd,0,0,800,600)
Navigate("http://bing.ca/")
MsgBox
Navigate("http://yahoo.com")
MsgBox
GoBack()
MsgBox
GoForward()
MsgBox
CleanUp()
ExitApp
*/

CreateHTMLControl(hWnd,PosX,PosY,Width,Height)
{
 global IWEB
 global ppWebBrowser
 global hModule
 hModule := DllCall("LoadLibrary","Str","atl.dll"), VarSetCapacity(IWEB,16), NumPut(0xD30C1661,IWEB), NumPut(0x11D0CDAF,IWEB,4), NumPut(0xC0003E8A,IWEB,8), NumPut(0x6EE2C94F,IWEB,12), DllCall("atl\AtlAxWinInit"), hCtrl := DllCall("CreateWindowEx","UInt",0x200,"Str","AtlAxWin","Str","Shell.Explorer","UInt",0x50000000,"Int",PosX,"Int",PosY,"Int",Width,"Int",Height,"UInt",hWnd,"UInt",0,"UInt",0,"UInt",0), DllCall("atl\AtlAxGetControl","UInt",hCtrl,"UIntP",ppunk), Temp1 := NumGet(NumGet(ppunk + 0)), DllCall(Temp1,"UInt",ppunk,"UInt",&IWEB,"UIntP",ppWebBrowser), DllCall(Temp1 + 8,"UInt",ppunk)
 If Not ppWebBrowser
  Return, -1
}

Navigate(URL)
{
 global ppWebBrowser
 VarSetCapacity(URL1,(StrLen(URL) * 2) + 2), DllCall("MultiByteToWideChar","UInt",0,"UInt",0,"UInt",&URL,"Int",-1,"UInt",&URL1,"Int",StrLen(URL) + 1), DllCall(NumGet(NumGet(ppWebBrowser + 0) + 44),"UInt",ppWebBrowser,"UInt",&URL1,"UInt",0,"UInt",0,"UInt",0,"UInt",0)
}

GoBack()
{
 global ppWebBrowser
 DllCall(NumGet(NumGet(ppWebBrowser + 0) + 28),"UInt",ppWebBrowser)
}

GoForward()
{
 global ppWebBrowser
 DllCall(NumGet(NumGet(ppWebBrowser + 0) + 32),"UInt",ppWebBrowser)
}

CleanUp()
{
 global ppWebBrowser
 global hModule
 DllCall(NumGet(NumGet(ppWebBrowser + 0) + 8),"UInt",ppWebBrowser), DllCall("FreeLibary","UInt",hModule)
}