; AutoHotkey Version: 1.x
; Language:       English
; Platform:       WinXP
; Author:         Micha
;
; Script Function:
;	Support for X10-Remote-Controls (I.E. for Aldi Medion Notebook MD96500)
; You need VC8 Runtime
; http://www.microsoft.com/downloads/details.aspx?FamilyID=25ae0cd6-783b-4968-a841-38a2743307d9&DisplayLang=en
HomePath=AutohotkeyRemoteX10.dll

hModule := DllCall("LoadLibrary", "str", HomePath) 
nRC = 0 
; --------------- How many entries are in TreeCtrl? ---------------------
; -----------------------------------------------------------------------
DetectHiddenWindows On
MainHWND := WinExist(A_ScriptFullPath . " ahk_class AutoHotkey")

nRC := DllCall("AutohotkeyRemoteX10\Initialize", int, MainHWND, "Cdecl Int")
if (errorlevel <> 0) || (nRC <> 0)
{
	MsgBox error while calling TreeGetCount Errorlevel: %errorlevel%
	return
}	
OnMessage(0x0501, "InputMsg")
return

InputMsg(wParam, lParam, msg, hwnd)
{  
	ToolTip, %wParam%
	DataLength := DllCall("lstrlen", UInt, wParam)
	VarSetCapacity(CopyOfData, DataLength)
	DllCall("lstrcpy", str, CopyOfData, UInt, wParam)  ; Copy the string out of the structure.
	StringSplit, Ziel, CopyOfData, %A_Tab%
	DoAction(Ziel3,Ziel4)
}
return

DoAction(Command,OnOff)
{
	ToolTip, %Command% - %OnOff%
}
