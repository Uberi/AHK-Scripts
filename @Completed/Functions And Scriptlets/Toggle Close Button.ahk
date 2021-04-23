;AHK v1
#NoEnv

/*
WindowID := WinExist("A")
DisableClose(WindowID)
Sleep, 2000
EnableClose(WindowID)
ExitApp
*/

DisableClose(WindowID)
{
 DllCall("user32\DeleteMenu","UInt",DllCall("user32\GetSystemMenu","UInt",WindowID,"UInt",0),"UInt",0xF060,"UInt",0x0)
 DllCall("user32\DrawMenuBar","UInt",WindowID)
}

EnableClose(WindowID)
{
 DllCall("user32\GetSystemMenu","UInt",WindowID,"UInt",1)
 DllCall("user32\DrawMenuBar","UInt",WindowID)
}