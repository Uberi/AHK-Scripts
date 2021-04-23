/* TheGood
    NetFileEnum example
*/

;Leave blank for local machine. Otherwise insert the NetBIOS name (ie. the computer name on the network) or IP address.
sServerName := "192.168.0.100"

;MSDN NetFileEnum function
;http://msdn.microsoft.com/en-us/library/bb525378.aspx
;MSDN FILE_INFO_3 struct info
;http://msdn.microsoft.com/en-us/library/bb525375.aspx

;Create GUI
Gui, +Resize -MaximizeBox
Gui, Add, ListView, R10 W500 vMyListView, User|Opened File

;NetFileEnum return values
NERR_Success            := 0
ERROR_ACCESS_DENIED     := 5
ERROR_INVALID_LEVEL     := 124
ERROR_MORE_DATA         := 234
ERROR_NOT_ENOUGH_MEMORY := 8
NERR_BufTooSmall        := 2123

;Prep variables
VarSetCapacity(pFileInfo, 4)    ;Pointer to the FILE_INFO_3 array
VarSetCapacity(iCount, 4)       ;iCount is the number of elements in the array
VarSetCapacity(iTotal, 4)       ;iTotal is the number of elements that could have been received

;Convert the servername to Unicode
ConvertMBtoW(&sServerName, sServerNameW)

;Call function
r := DllCall("netapi32\NetFileEnum", "int", &sServerNameW, "int", 0, "int", 0, "int", 3, "int*", pFileInfo, "int", 0xFFFFFFFE, "int*", iCount, "int*", iTotal, "int", 0)

;Check return value
If (r <> NERR_Success) And (r <> ERROR_MORE_DATA) {
    If (r = ERROR_ACCESS_DENIED)
        MsgBox You do not have access to the requested information.`nThe program will now exit.
    Else If (r = ERROR_INVALID_LEVEL)
        MsgBox The value specified for the level parameter is not valid.`nThe program will now exit.
    Else If (r = ERROR_NOT_ENOUGH_MEMORY)	
        MsgBox Insufficient memory is available.`nThe program will now exit.
    Else If (r = NERR_BufTooSmall)
        MsgBox The supplied buffer is too small.`nThe program will now exit.
    
    ;Free buffer and exit
    DllCall("netapi32\NetApiBufferFree", "int", pFileInfo)
    ExitApp
    
} Else If (r = ERROR_MORE_DATA) Or (iCount < iTotal) ;Check if the buffer is too small
    MsgBox More entries are available. Specify a large enough buffer to receive all entries.

;Check OS version for Windows 2000 or higher (to know if we have to convert Unicode
If A_OSVersion in WIN_NT4,WIN_95,WIN_98,WIN_ME
{   
    ;Loop through each item
    Loop %iCount% {
        
        ;Get string pointer
        iPtrFN := NumGet(pFileInfo + 0, ((A_Index - 1) * 20) + 12)
        iPtrUN := NumGet(pFileInfo + 0, ((A_Index - 1) * 20) + 16)
        
        ;Get strings
        sFN := DllCall("MulDiv", "int", iPtrFN, "int", 1, "int", 1, "str")
        sUN := DllCall("MulDiv", "int", iPtrUN, "int", 1, "int", 1, "str")
        
        ;MsgBox FILENAME:%A_Tab%%sFN%`nUSERNAME:%A_Tab%%sUN%
        LV_Add("", sUN, sFN)
    }
} Else {
    
    ;Loop through each FILE_INFO struct
    Loop %iCount% {
        
        ;Get string pointer
        iPtrFN := NumGet(pFileInfo + 0, ((A_Index - 1) * 20) + 12)
        iPtrUN := NumGet(pFileInfo + 0, ((A_Index - 1) * 20) + 16)
        
        ;Get string
        sFN := ConvertWtoMB(iPtrFN)
        sUN := ConvertWtoMB(iPtrUN)
        
        ;MsgBox FILENAME:%A_Tab%%sFN%`nUSERNAME:%A_Tab%%sUN%
        LV_Add("", sUN, sFN)
    }
}

;Free buffer
DllCall("netapi32\NetApiBufferFree", "int", pFileInfo)

;Done
Gui, Show

Return

GuiClose:
    ExitApp
Return

GuiSize:
    Anchor("MyListView", "wh")
Return

ConvertWtoMB(iPtr) {
    
    ;Get length needed
    iLen := DllCall("WideCharToMultiByte", "int", 0, "int", 0, "int", iPtr, "int", -1, "int", 0, "int", 0, "int", 0, "int", 0)
    
    ;Prep var
    VarSetCapacity(buf, iLen + 1, 0)
    
    ;Convert var
    DllCall("WideCharToMultiByte", "int", 0, "int", 0, "int", iPtr, "int", -1, "int", &buf, "int", iLen, "int", 0, "int", 0)
    
    ;Get string
    Return DllCall("MulDiv", int, &buf, int, 1, int, 1, str)
}

ConvertMBtoW(iPtr, ByRef buf) {
    
    ;Get length needed
    iLen := DllCall("MultiByteToWideChar", "int", 0, "int", 0, "int", iPtr, "int", -1, "int", 0, "int", 0, "int", 0, "int", 0)
    
    ;Prep var
    VarSetCapacity(buf, iLen + 1, 0)
    
    ;Convert var
    DllCall("MultiByteToWideChar", "int", 0, "int", 0, "int", iPtr, "int", -1, "int", &buf, "int", iLen, "int", 0, "int", 0)
    
    ;Return
    Return
}

;Anchor by Titan
;http://www.autohotkey.com/forum/viewtopic.php?t=4348
Anchor(i, a = "", r = false) {

	static c, cs = 12, cx = 255, cl = 0, g, gs = 8, z = 0, k = 0xffff, gx = 1
	If z = 0
		VarSetCapacity(g, gs * 99, 0), VarSetCapacity(c, cs * cx, 0), z := true
	If a =
	{
		StringLeft, gn, i, 2
		If gn contains :
		{
			StringTrimRight, gn, gn, 1
			t = 2
		}
		StringTrimLeft, i, i, t ? t : 3
		If gn is not digit
			gn := gx
	}
	Else gn := A_Gui
	If i is not xdigit
	{
		GuiControlGet, t, Hwnd, %i%
		If ErrorLevel = 0
			i := t
		Else ControlGet, i, Hwnd, , %i%
	}
	gb := (gn - 1) * gs
	Loop, %cx%
		If (NumGet(c, cb := cs * (A_Index - 1)) == i) {
			If a =
			{
				cf = 1
				Break
			}
			Else gx := A_Gui
			d := NumGet(g, gb), gw := A_GuiWidth - (d >> 16 & k), gh := A_GuiHeight - (d & k), as := 1
				, dx := NumGet(c, cb + 4, "Short"), dy := NumGet(c, cb + 6, "Short")
				, dw := NumGet(c, cb + 8, "Short"), dh := NumGet(c, cb + 10, "Short")
			Loop, Parse, a, xywh
				If A_Index > 1
					av := SubStr(a, as, 1), as += 1 + StrLen(A_LoopField)
						, d%av% += (InStr("yh", av) ? gh : gw) * (A_LoopField + 0 ? A_LoopField : 1)
			DllCall("SetWindowPos", "UInt", i, "Int", 0, "Int", dx, "Int", dy, "Int", dw, "Int", dh, "Int", 4)
			If r != 0
				DllCall("RedrawWindow", "UInt", i, "UInt", 0, "UInt", 0, "UInt", 0x0101) ; RDW_UPDATENOW | RDW_INVALIDATE
			Return
		}
	If cf != 1
		cb := cl, cl += cs
	If (!NumGet(g, gb)) {
		Gui, %gn%:+LastFound
		WinGetPos, , , , gh
		VarSetCapacity(pwi, 68, 0), DllCall("GetWindowInfo", "UInt", WinExist(), "UInt", &pwi)
			, NumPut(((bx := NumGet(pwi, 48)) << 16 | by := gh - A_GuiHeight - NumGet(pwi, 52)), g, gb + 4)
			, NumPut(A_GuiWidth << 16 | A_GuiHeight, g, gb)
	}
	Else d := NumGet(g, gb + 4), bx := d >> 16, by := d & k
	ControlGetPos, dx, dy, dw, dh, , ahk_id %i%
	If cf = 1
	{
		Gui, %gn%:+LastFound
		WinGetPos, , , gw, gh
		d := NumGet(g, gb), dw -= gw - bx * 2 - (d >> 16), dh -= gh - by - bx - (d & k)
	}
	NumPut(i, c, cb), NumPut(dx - bx, c, cb + 4, "Short"), NumPut(dy - by, c, cb + 6, "Short")
		, NumPut(dw, c, cb + 8, "Short"), NumPut(dh, c, cb + 10, "Short")
	Return, true
}