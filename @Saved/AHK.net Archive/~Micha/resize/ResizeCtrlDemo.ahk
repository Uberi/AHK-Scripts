;
; AutoHotkey Version: 1.x
; Language:       English
; Platform:       Win9x/NT
; Author:         micha  misifusc-mail@yahoo.de
;
; Script Function:
;	Resizing Dialog-Controls
;

;Homepath is the path to the dll (relative to script)
;HomePath=AHKResizeSupport\debug\AHKResizeSupport.dll
HomePath=AHKResizeSupport.dll
Gui, +resize
Gui, Add, Button, x6 y10 w110 h40, 
Gui, Add, Checkbox, x126 y20 w150 h40,Checkbox with a very very long text for the resizedemo
Gui, Add, ComboBox, x296 y20 w170 h20, 
Gui, Add, Edit, x6 y60 w460 h30, 
Gui, Add, ListBox, x6 y110 w180 h150, 
Gui, Add, ListBox, x196 y110 w270 h150, 
Gui, Add, Progress, x6 y260 w120 h100, 25
Gui, Add, Slider, x146 y270 w320 h30, 25
Gui, Add, Edit, x146 y310 w160 h50, edit
Gui, Add, Edit, x316 y310 w150 h50,edit with a very very long text for the resizedemo---with a very very long text for the resizedemo---with a very very long text for the resizedemo
Gui, Show, x217 y279 h380 w479, ResizeDemo_by_Micha

WindowIdent = ResizeDemo_by_Micha

WinActivate, %WindowIdent%
WinWaitActive, %WindowIdent%
WinGet, WinID, ID, %WindowIdent%
hModule := DllCall("LoadLibrary", "str", HomePath)
nCounter = 0 
nRC = 0 
; -------------------------- Initialize ---------------------------------
; -----------------------------------------------------------------------
nRC := DllCall("AHKResizeSupport\SetDlgParameters", DWORD, WinID, "Cdecl Int")
if (errorlevel <> 0) || (nRC = 0)
{
	MsgBox error while calling SetDlgParameters Errorlevel: %errorlevel%
	return
}
CtrlHWnd := GetChildHWND(WinID, "Button1")
nRC := DllCall("AHKResizeSupport\AddControl", DWORD, CtrlHWnd, int, 2, int, 1, int, 1, double, 0.5, double, 0.5, "Cdecl Int")
CtrlHWnd := GetChildHWND(WinID, "Button2")
nRC := DllCall("AHKResizeSupport\AddControl", DWORD, CtrlHWnd, int, 4, int, 1, int, 1, double, 0.5, double, 1, "Cdecl Int")
CtrlHWnd := GetChildHWND(WinID, "ComboBox1")
nRC := DllCall("AHKResizeSupport\AddControl", DWORD, CtrlHWnd, int, 5, int, 1, int, 1, double, 1, double, 1, "Cdecl Int")
CtrlHWnd := GetChildHWND(WinID, "Edit2")
nRC := DllCall("AHKResizeSupport\AddControl", DWORD, CtrlHWnd, int, 4, int, 1, int, 1, double, 1, double, 1, "Cdecl Int")
CtrlHWnd := GetChildHWND(WinID, "ListBox1")
nRC := DllCall("AHKResizeSupport\AddControl", DWORD, CtrlHWnd, int, 2, int, 1, int, 1, double, 0.5, double, 1, "Cdecl Int")
CtrlHWnd := GetChildHWND(WinID, "ListBox2")
nRC := DllCall("AHKResizeSupport\AddControl", DWORD, CtrlHWnd, int, 4, int, 4, int, 1, double, 0.5, double, 1, "Cdecl Int")
CtrlHWnd := GetChildHWND(WinID, "msctls_progress321")
nRC := DllCall("AHKResizeSupport\AddControl", DWORD, CtrlHWnd, int, 2, int, 4, int, 1, double, 0.5, double, 1, "Cdecl Int")
CtrlHWnd := GetChildHWND(WinID, "msctls_trackbar321")
nRC := DllCall("AHKResizeSupport\AddControl", DWORD, CtrlHWnd, int, 5, int, 5, int, 1, double, 0.5, double, 1, "Cdecl Int")
CtrlHWnd := GetChildHWND(WinID, "edit3")
nRC := DllCall("AHKResizeSupport\AddControl", DWORD, CtrlHWnd, int, 4, int, 5, int, 1, double, 0.5, double, 1, "Cdecl Int")
CtrlHWnd := GetChildHWND(WinID, "edit4")
nRC := DllCall("AHKResizeSupport\AddControl", DWORD, CtrlHWnd, int, 5, int, 5, int, 1, double, 1, double, 1, "Cdecl Int")
return

!r::reload

GuiSize:
DllCall("AHKResizeSupport\OnSize")
return

Guiclose:
exitapp
return


GetChildHWND(ParentHWND, ChildClassNN)
{
	WinGetPos, ParentX, ParentY,,, ahk_id %ParentHWND%
	if ParentX =
		return  ; Parent window not found (possibly due to DetectHiddenWindows).
	ControlGetPos, ChildX, ChildY,,, %ChildClassNN%, ahk_id %ParentHWND%
	if ChildX =
		return  ; Child window not found, so return a blank value.
	; Convert child coordinates -- which are relative to its parent's upper left
	; corner -- to absolute/screen coordinates for use with WindowFromPoint().
	; The following INTENTIONALLY passes too many args to the function because
	; each arg is 32-bit, which allows the function to automatically combine
	; them into one 64-bit arg (namely the POINT structure):
	return DllCall("WindowFromPoint", "int", ChildX + ParentX, "int", ChildY + ParentY)
}
