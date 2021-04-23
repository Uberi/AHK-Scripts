;#NoTrayIcon
;DetectHiddenWindows, On


/*
TB_SETINSERTMARK
TB_SETINSERTMARKCOLOR
http://msdn.microsoft.com/en-us/library/bb762722%28VS.85%29.aspx
*/

;SDR()

MsgBox % TaskButton_GetInfo() ;%


TaskButton_GetInfo(sExeName = "")
{
	DetectHiddenWindows, On
	idxTB := TaskButton_GetSwBar()
	WinGet, pidTaskbar, PID, ahk_class Shell_TrayWnd

	hProc := DllCall("OpenProcess", "Uint", 0x38, "int", 0, "Uint", pidTaskbar)
	pRB := DllCall("VirtualAllocEx", "Uint", hProc, "Uint", 0, "Uint", 20, "Uint", 0x1000, "Uint", 0x4)

	VarSetCapacity(btn, 20)
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
		
		DllCall("ReadProcessMemory", "Uint", hProc, "Uint", dwData, "UintP", hWnd, "Uint", 4, "Uint", 0)
		
		If	!hWnd
			Continue
		
		WinGet, pid, PID,              ahk_id %hWnd%
		WinGet, sProcess, ProcessName, ahk_id %hWnd%
		WinGetClass, sClass,           ahk_id %hWnd%
		
		If !sExeName || (sExeName = sProcess) || (sExeName = pid)
		{
			DllCall("ReadProcessMemory", "Uint", hProc, "Uint", iString, "Uint", &wTooltip, "Uint", 128 * 2, "Uint", 0)
			DllCall("WideCharToMultiByte", "Uint", 0, "Uint", 0, "str", wTooltip, "int", -1, "str", sTooltip, "int", 128, "Uint", 0, "Uint", 0)
			sTaskButton_GetInfo .= ">>> idx: " . A_Index - 1 . " | idn: " . idn . " | pid: " . pid . " | hWnd: " . hWnd . " | Class: " . sClass . " | Process: " . sProcess . "   | Tooltip: " . sTooltip . "`n"
		}
	}

	DllCall("VirtualFreeEx", "Uint", hProc, "Uint", pRB, "Uint", 0, "Uint", 0x8000)
	DllCall("CloseHandle", "Uint", hProc)

	Return	sTaskButton_GetInfo
}

TaskButton_Hide(idn, bHide = True)
{
	DetectHiddenWindows, On
	idxTB := TaskButton_GetSwBar()
	SendMessage, 0x404, idn, bHide, ToolbarWindow32%idxTB%, ahk_class Shell_TrayWnd   ; TB_HIDEBUTTON
}

TaskButton_Delete(idx)
{
	DetectHiddenWindows, On
	idxTB := TaskButton_GetSwBar()
	SendMessage, 0x416, idx, 0, ToolbarWindow32%idxTB%, ahk_class Shell_TrayWnd   ; TB_DELETEBUTTON
}

TaskButton_Move(idxOld, idxNew)
{
	DetectHiddenWindows, On
	idxTB := TaskButton_GetSwBar()
	SendMessage, 0x452, idxOld, idxNew, ToolbarWindow32%idxTB%, ahk_class Shell_TrayWnd    ; TB_MOVEBUTTON
}

TaskButton_GetSwBar()
{
	DetectHiddenWindows, On
	WinGet, ControlList, ControlList, ahk_class Shell_TrayWnd
	RegExMatch(ControlList, "(?<=ToolbarWindow32)\d+(?!.*ToolbarWindow32)", nTB)

	Loop, %nTB%
	{
		ControlGet, hWnd, hWnd,, ToolbarWindow32%A_Index%, ahk_class Shell_TrayWnd
		hParent := DllCall("GetParent", "Uint", hWnd)
		WinGetClass, sClass, ahk_id %hParent%
		If (sClass <> "MSTaskSwWClass")
			Continue
		idxTB := A_Index
			Break
	}

	Return	idxTB
}

TaskButton_GetHotItem()
{
   idxTB := TaskButton_GetSwBar()
   SendMessage, 0x447, 0, 0, ToolbarWindow32%idxTB%, ahk_class Shell_TrayWnd   ; TB_GETHOTITEM
   Return ErrorLevel << 32 >> 32
}