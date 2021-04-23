;#NoTrayIcon
;DetectHiddenWindows, On

;MsgBox % TrayIcon_GetInfo() ;%

;SDR()

/*
WM_MOUSEMOVE    = 0x0200
WM_LBUTTONDOWN    = 0x0201
WM_LBUTTONUP    = 0x0202
WM_LBUTTONDBLCLK = 0x0203
WM_RBUTTONDOWN    = 0x0204
WM_RBUTTONUP    = 0x0205
WM_RBUTTONDBLCLK = 0x0206
WM_MBUTTONDOWN    = 0x0207
WM_MBUTTONUP    = 0x0208
WM_MBUTTONDBLCLK = 0x0209

PostMessage, nMsg, uID, WM_RBUTTONDOWN, , ahk_id %hWnd%
PostMessage, nMsg, uID, WM_RBUTTONUP  , , ahk_id %hWnd%
*/



TrayIcon_GetInfo(sExeName = "")
{
	DetectHiddenWindows, On
	idxTB := TrayIcon_GetTrayBar()
	WinGet, pidTaskbar, PID, ahk_class Shell_TrayWnd

	hProc := DllCall("OpenProcess", "Uint", 0x38, "int", 0, "Uint", pidTaskbar)
	pRB := DllCall("VirtualAllocEx", "Uint", hProc, "Uint", 0, "Uint", 20, "Uint", 0x1000, "Uint", 0x4)

	VarSetCapacity(btn, 20)
	VarSetCapacity(nfo, 24)
	VarSetCapacity(sTooltip, 128)
	VarSetCapacity(wTooltip, 128 * 2)

	SendMessage, 0x418, 0, 0, ToolbarWindow32%idxTB%, ahk_class Shell_TrayWnd   ; TB_BUTTONCOUNT

	Loop, %ErrorLevel%
	{
		SendMessage, 0x417, A_Index - 1, pRB, ToolbarWindow32%idxTB%, ahk_class Shell_TrayWnd   ; TB_GETBUTTON

		DllCall("ReadProcessMemory", "Uint", hProc, "Uint", pRB, "Uint", &btn, "Uint", 20, "Uint", 0)

		iBitmap	:= NumGet(btn, 0)
		idn	:= NumGet(btn, 4)
		Statyle := NumGet(btn, 8)
		dwData	:= NumGet(btn,12)
		iString	:= NumGet(btn,16)

		DllCall("ReadProcessMemory", "Uint", hProc, "Uint", dwData, "Uint", &nfo, "Uint", 24, "Uint", 0)

		hWnd	:= NumGet(nfo, 0)
		uID	:= NumGet(nfo, 4)
		nMsg	:= NumGet(nfo, 8)
		hIcon	:= NumGet(nfo,20)

		WinGet, pid, PID,              ahk_id %hWnd%
		WinGet, sProcess, ProcessName, ahk_id %hWnd%
		WinGetClass, sClass,           ahk_id %hWnd%

		If !sExeName || (sExeName = sProcess) || (sExeName = pid)
		{
			DllCall("ReadProcessMemory", "Uint", hProc, "Uint", iString, "Uint", &wTooltip, "Uint", 128 * 2, "Uint", 0)
			DllCall("WideCharToMultiByte", "Uint", 0, "Uint", 0, "str", wTooltip, "int", -1, "str", sTooltip, "int", 128, "Uint", 0, "Uint", 0)
			sTrayIcon_GetInfo .= "idx: " . A_Index - 1 . " | idn: " . idn . " | Pid: " . pid . " | uID: " . uID . " | MessageID: " . nMsg . " | hWnd: " . hWnd . " | Class: " . sClass . " | Process: " . sProcess . "`n" . "   | Tooltip: " . sTooltip . "`n"
		}
	}

	DllCall("VirtualFreeEx", "Uint", hProc, "Uint", pRB, "Uint", 0, "Uint", 0x8000)
	DllCall("CloseHandle", "Uint", hProc)
	
	Return	sTrayIcon_GetInfo
}

TrayIcon_Remove(hWnd, uID, nMsg = 0, hIcon = 0, nRemove = 2)
{
	DetectHiddenWindows, On
	NumPut(VarSetCapacity(ni,444,0), ni)
	NumPut(hWnd , ni, 4)
	NumPut(uID  , ni, 8)
	NumPut(1|2|4, ni,12)
	NumPut(nMsg , ni,16)
	NumPut(hIcon, ni,20)
	Return	DllCall("shell32\Shell_NotifyIconA", "Uint", nRemove, "Uint", &ni)
}

TrayIcon_Hide(idn, bHide = True)
{
	DetectHiddenWindows, On
	idxTB := TrayIcon_GetTrayBar()
	SendMessage, 0x404, idn, bHide, ToolbarWindow32%idxTB%, ahk_class Shell_TrayWnd   ; TB_HIDEBUTTON
	SendMessage, 0x1A, 0, 0, , ahk_class Shell_TrayWnd
}

TrayIcon_Delete(idx)
{
	DetectHiddenWindows, On
	idxTB := TrayIcon_GetTrayBar()
	SendMessage, 0x416, idx - 1, 0, ToolbarWindow32%idxTB%, ahk_class Shell_TrayWnd   ; TB_DELETEBUTTON
	SendMessage, 0x1A, 0, 0, , ahk_class Shell_TrayWnd
}

TrayIcon_Move(idxOld, idxNew)
{
	DetectHiddenWindows, On
	idxTB := TrayIcon_GetTrayBar()
	SendMessage, 0x452, idxOld - 1, idxNew - 1, ToolbarWindow32%idxTB%, ahk_class Shell_TrayWnd ; TB_MOVEBUTTON
}

TrayIcon_GetTrayBar()
{
	DetectHiddenWindows, On
	WinGet, ControlList, ControlList, ahk_class Shell_TrayWnd
	RegExMatch(ControlList, "(?<=ToolbarWindow32)\d+(?!.*ToolbarWindow32)", nTB)

	Loop, %nTB%
	{
		ControlGet, hWnd, hWnd,, ToolbarWindow32%A_Index%, ahk_class Shell_TrayWnd
		hParent := DllCall("GetParent", "Uint", hWnd)
		WinGetClass, sClass, ahk_id %hParent%
		If (sClass <> "SysPager")
			Continue
		idxTB := A_Index
			Break
	}

	Return	idxTB
}

TrayIcon_GetHotItem()
{
   idxTB := TrayIcon_GetTrayBar()
   SendMessage, 0x447, 0, 0, ToolbarWindow32%idxTB%, ahk_class Shell_TrayWnd   ; TB_GETHOTITEM
   Return ErrorLevel << 32 >> 32
}
