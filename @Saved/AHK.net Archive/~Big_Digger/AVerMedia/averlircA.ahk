/*
AVerLIRC Client
Author Big Digger

Requirements
* Windows 2000/XP/Vista/7
* AutoHotkey v1.0.48.05 http://www.autohotkey.com/
* AVerTV v6.3.0 or higher http://www.avermedia.com/avertv/Support/Download.aspx?Type=APDriver
* AVerLIRC v1.0.1.17 http://averlirc.sourceforge.net/
*/

#NoEnv
#SingleInstance On
If (A_IsUnicode = 1)
{
	MsgBox, 16, AVerLIRC Client, This version is not compatible with AutoHotkey_L Unicode.
	ExitApp
}
SetBatchLines, -1
OnExit, ExitSub

DetectHiddenWindows, On
WinGet, hWnd, ID, % "ahk_pid " DllCall("GetCurrentProcessId", "UInt") " ahk_class AutoHotkey"

WinGet, ProcessId, PID, ahk_class AVerQuickAPP
If hProcess := DllCall("OpenProcess", "UInt", 0x0010 | 0x0400, "Int", False, "UInt", ProcessId, "UInt") ; PROCESS_VM_READ | PROCESS_QUERY_INFORMATION
{
	VarSetCapacity(AVerQuickApp, 260, 0) ; MAX_PATH
	DllCall("psapi.dll\GetModuleFileNameExA", "UInt", hProcess, "UInt", 0, "Str", AVerQuickApp, "UInt", 261, "UInt")
	DllCall("CloseHandle", "UInt", hProcess, "Int")
	VarSetCapacity(AVerQuickApp, -1)
	FileGetVersion, AVerQuickVer, %AVerQuickApp%
	If (ErrorLevel = 0)
		WinClose, ahk_pid %ProcessId%
	Else
		AVerQuickApp := ""
}

DllCall("LoadLibrary", "Str", "ws2_32", "UInt")
DllCall("LoadLibrary", "Str", "advapi32", "UInt")

SetWorkingDir, %A_ScriptDir%
IniRead, Host, averlirc.ini, Main, Host, localhost
IniRead, Port, averlirc.ini, Main, Port, 8765

Gui, Add, Edit, xm ym+1 w90 r1 vEdit1 gEditSub, %Host%
Gui, Add, Edit, ym+1 w40 r1 vEdit2 gEditSub Limit5 Number, %Port%
Gui, Add, Button, ym w80 vButton1 Default, Connect
GuiControl, Focus, Button1
Gui, Add, Button, xm+300 ym w80 vButton2, Query
Gui, Add, ListView, xm w380 r10 Grid -LV0x10 LV0x4000 NoSortHdr, Elapsed|Repeat|Button|Device
LV_ModifyCol(1, 50)
LV_ModifyCol(2, 50)
LV_ModifyCol(3, 100)
LV_ModifyCol(4, 150)
Gui, Show, , AVerLIRC Client

Menu, Tray, Tip, AVerLIRC Client
Return


ExitSub:
If FileExist(AVerQuickApp)
{
	SplitPath, AVerQuickApp, , AVerQuickDir
	Run, %AVerQuickApp%, %AVerQuickDir%, UseErrorLevel
}
If (Socket != "")
	Gosub, Connection
If hLib := DllCall("GetModuleHandle", "Str", "ws2_32", "UInt")
	DllCall("FreeLibrary", "UInt", hLib, "Int")
If hLib := DllCall("GetModuleHandle", "Str", "advapi32", "UInt")
	DllCall("FreeLibrary", "UInt", hLib, "Int")
IniWrite, %Host%, averlirc.ini, Main, Host
IniWrite, %Port%, averlirc.ini, Main, Port
ExitApp

GuiClose:
ExitApp

EditSub:
If (A_GuiControl = "Edit1")
	GuiControlGet, Host, , Edit1
Else If (A_GuiControl = "Edit2")
	GuiControlGet, Port, , Edit2
Return

ButtonConnect:
GuiControl, Disable, Edit1
GuiControl, Disable, Edit2
GuiControl, Disable, Button1
Sleep, -1
Gosub, Connection
If (Socket != "")
	GuiControl, , Button1, Disconnect
Else
{
	GuiControl, Enable, Edit1
	GuiControl, Enable, Edit2
	GuiControl, , Button1, Connect
}
GuiControl, Enable, Button1
GuiControl, Focus, Button1
Return

ButtonQuery:
Gui, +OwnDialogs
If !hSCM := DllCall("advapi32\OpenSCManagerA", "UInt", 0, "UInt", 0, "UInt", 4, "UInt") ; SC_MANAGER_ENUMERATE_SERVICE
{
	MsgBox, 48, AVerLIRC Client, Failed to open the service control manager (%A_LastError%).
	Return
}
If !hSvc := DllCall("advapi32\OpenServiceA", "UInt", hSCM, "Str", "AVerLIRCService", "UInt", 4, "UInt") ; SERVICE_QUERY_STATUS
{
	If (A_LastError = 1060)
		MsgBox, 16, AVerLIRC Client, The AVerLIRC service does not exist as an installed service.
	Else
		MsgBox, 48, AVerLIRC Client, Failed to open the AVerLIRC service (%A_LastError%).
	DllCall("advapi32\CloseServiceHandle", "UInt", hSCM, "Int")
	Return
}
VarSetCapacity(SvcStatus, 36, 0)
If !DllCall("advapi32\QueryServiceStatusEx", "UInt", hSvc, "Int", 0, "UInt", &SvcStatus, "UInt", 36, "UInt*", Size, "Int") ; SC_STATUS_PROCESS_INFO
	MsgBox, 48, AVerLIRC Client, Failed to query the AVerLIRC service (%A_LastError%).
Else
{
	SvcState := NumGet(SvcStatus, 4, "UInt")
	If (SvcState = 5) ; SERVICE_CONTINUE_PENDING
		MsgBox, 48, AVerLIRC Client, The AVerLIRC service is about to continue.
	Else If (SvcState = 6) ; SERVICE_PAUSE_PENDING
		MsgBox, 16, AVerLIRC Client, The AVerLIRC service is pausing.
	Else If (SvcState = 7) ; SERVICE_PAUSED
		MsgBox, 16, AVerLIRC Client, The AVerLIRC service is paused.
	Else If (SvcState = 4) ; SERVICE_RUNNING
		MsgBox, 64, AVerLIRC Client, The AVerLIRC service is running.
	Else If (SvcState = 2) ; SERVICE_START_PENDING
		MsgBox, 48, AVerLIRC Client, The AVerLIRC service is starting.
	Else If (SvcState = 3) ; SERVICE_STOP_PENDING
		MsgBox, 16, AVerLIRC Client, The AVerLIRC service is stopping.
	Else If (SvcState = 1) ; SERVICE_STOPPED
		MsgBox, 16, AVerLIRC Client, The AVerLIRC service has stopped.
}
DllCall("advapi32\CloseServiceHandle", "UInt", hSvc, "Int")
DllCall("advapi32\CloseServiceHandle", "UInt", hSCM, "Int")
Return

Connection:
Gui, +OwnDialogs
If (Socket != "")
{
	OnMessage(0x5678, "")
	DllCall("ws2_32\closesocket", "UInt", Socket, "Int")
	DllCall("ws2_32\WSACleanup", "Int"), Socket := ""
	Return
}
VarSetCapacity(WSAData, 32, 0)
Result := DllCall("ws2_32\WSAStartup", "UShort", 0x0202, "UInt", &WSAData, "Int")
If (Result != 0)
{
	MsgBox, 16, AVerLIRC Client, Failed to initialize the Winsock DLL (%Result%).
	Return
}
Else If NumGet(WSAData, 2, "UShort") < 0x0202
{
	MsgBox, 16, AVerLIRC Client, The DLL does not support the Winsock version 2.2.
	DllCall("ws2_32\WSACleanup", "Int")
	Return
}
VarSetCapacity(Hints, 32, 0)
NumPut(2, Hints, 4, "Int") ; AF_INET
NumPut(1, Hints, 8, "Int") ; SOCK_STREAM
NumPut(6, Hints, 12, "Int") ; IPPROTO_TCP
Result := DllCall("ws2_32\getaddrinfo", "UInt", &Host, "UInt", &Port, "UInt", &Hints, "UInt*", pAddrInfo, "Int")
If (Result != 0)
{
	MsgBox, 16, AVerLIRC Client, Failed to resolve the server address and port (%Result%).
	DllCall("ws2_32\WSACleanup", "Int")
	Return
}
Socket := DllCall("ws2_32\socket"
	, "Int", NumGet(pAddrInfo + 0, 4, "Int")
	, "Int", NumGet(pAddrInfo + 0, 8, "Int")
	, "Int", NumGet(pAddrInfo + 0, 12, "Int")
	, "UInt")
If (Socket = 0xFFFFFFFF) ; INVALID_SOCKET
{
	MsgBox, 16, AVerLIRC Client, Failed to create a socket for connecting to server (%A_LastError%).
	DllCall("ws2_32\freeaddrinfo", "UInt", pAddrInfo)
	DllCall("ws2_32\WSACleanup", "Int"), Socket := ""
	Return
}
Result := DllCall("ws2_32\connect"
	, "UInt", Socket
	, "UInt", NumGet(pAddrInfo + 0, 24, "UInt")
	, "Int", NumGet(pAddrInfo + 0, 16, "Int")
	, "Int")
If (Result = -1) ; SOCKET_ERROR
{
	MsgBox, 16, AVerLIRC Client, Failed to establish connection with the server (%A_LastError%).
	DllCall("ws2_32\freeaddrinfo", "UInt", pAddrInfo)
	DllCall("ws2_32\closesocket", "UInt", Socket, "Int")
	DllCall("ws2_32\WSACleanup", "Int"), Socket := ""
	Return
}
DllCall("ws2_32\freeaddrinfo", "UInt", pAddrInfo)
Result := DllCall("ws2_32\WSAAsyncSelect", "UInt", Socket, "UInt", hWnd, "UInt", 0x5678, "Int", 0x01 | 0x20, "Int") ; FD_READ | FD_CLOSE
If (Result = -1) ; SOCKET_ERROR
{
	MsgBox, 16, AVerLIRC Client, Failed to request event notification for a socket (%A_LastError%).
	DllCall("ws2_32\closesocket", "UInt", Socket, "Int")
	DllCall("ws2_32\WSACleanup", "Int"), Socket := ""
	Return
}
If !OnMessage(0x5678)
	OnMessage(0x5678, "ReceiveProc")
Return

ReceiveProc(wParam, lParam)
{
	Critical
	Global Socket
	Static PriorTick
	If (Socket != wParam)
		Return
	EventCode := lParam & 0xFFFF, ErrorCode := lParam >> 16
	If (EventCode = 0x01) ; FD_READ
	{
		If (ErrorCode != 0)
			Return
		VarSetCapacity(Buffer, 4096, 0)
		Result := DllCall("ws2_32\recv", "UInt", wParam, "UInt", &Buffer, "Int", 4096, "Int", 0, "Int")
		If (Result > 0)
		{
			VarSetCapacity(Buffer, -1)
			If RegExMatch(Buffer, "i)^0{16} (?P<Repeat>\d+) (?P<Button>\w+) (?P<Device>.+)$", This)
			{
				Elapsed := A_TickCount - PriorTick, PriorTick := A_TickCount
				LV_Modify(0, "-Select")
				RowNumber := LV_Add("Select", Elapsed, ThisRepeat, ThisButton, ThisDevice)
				LV_Modify(RowNumber, "Vis")
				If IsLabel(ThisButton)
					Gosub, %ThisButton%
			}
		}
		Else If (Result = -1 and A_LastError = 10035) ; SOCKET_ERROR and WSAEWOULDBLOCK
			Return, 1
		Return, Result
	}
	Else If (EventCode = 0x20) ; FD_CLOSE
	{
		While, ReceiveProc(wParam, 0x01) > 0
			Sleep, -1
		Gosub, ButtonConnect
	}
}

#Include *i buttons.ahk
