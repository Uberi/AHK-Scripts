; =============================================================================================================
;								THE FAKE VIRUS SCRIPT! PRANK YOUR FRIENDS!
;
;		Author: jpjazzy (with main scripts from the GDI+ and BRA Librarys examples)
;		Tools/Scripts used:
;							Tic's GDI+ library - http://www.autohotkey.com/forum/viewtopic.php?t=32238&highlight=tic
;							awannaknow's remove lines - http://www.autohotkey.com/forum/viewtopic.php?t=77699
;							Compilation/Decompilation
;
;		Description:
;							Want to prank a friend? This is a great script to use and completely harmless.
;							No files are written to your computer except the .bra file which is instantly deleted.
;							All dialogs are fake, but look real and will freak your friend out.
;							Watch them open task manager to try and close it and see what happens! >:D
;							Sequence:   Fake countdown using bra and GDI+
;										Show the desktop with Windows+D hotkey
;										Fake download files using GDI+ progress bar
;										Fake showing deleted files GUI
;										Show the user they have been pranked at the end!
;
;							All fun, no harm. All you have to do is set the timer in seconds!
;							
									TimeLimitInS := 60 ; AMOUNT OF TIME TO GIVE THE COUNTDOWN 
;														(DEFAULT IS 1 MINUTE OR 60 SECONDS AND MAX IS 100 MINUTES OR 6000 SECONDS)
;
; =============================================================================================================




; ========================================= LET THE FUN BEGIN ==================================================
SetTitleMatchMode, 2
#SingleInstance, Force
#NoEnv
#NoTrayIcon
StartTime:=A_TickCount ; Start time of the countdown

NaughtyVar := 0
SetTimer, NaughtyCheck, 50
If (!FileExist(A_MyDocuments "\AutoHotkey\Lib\Gdip.ahk") || !FileExist(A_ProgramFiles "\AutoHotkey\Lib\Gdip.ahk"))
	UrlDownloadToFile, http://www.autohotkey.net/~tic/Gdip.ahk, %A_ProgramFiles%\AutoHotkey\Lib\Gdip.ahk
If (!FileExist(A_MyDocuments "\AutoHotkey\Lib\BRA.ahk") || !FileExist(A_ProgramFiles "\AutoHotkey\Lib\BRA.ahk"))
	UrlDownloadToFile, http://www.autohotkey.net/~tic/BRA.ahk, %A_ProgramFiles%\AutoHotkey\Lib\BRA.ahk	
IfNotExist, %A_MyDocuments%\AutoHotkey\Lib\
{
	
}


If !pToken := Gdip_Startup()
{
	MsgBox, 48, gdiplus error!, Gdiplus failed to start. Please ensure you have gdiplus on your system
	ExitApp
}
if (Gdip_LibraryVersion() < 1.30)
{
	MsgBox, 48, version error!, Please download the latest version of the gdi+ library
	ExitApp
}
SysGet, MonitorPrimary, MonitorPrimary
SysGet, WA, MonitorWorkArea, %MonitorPrimary%
WAWidth := WARight-WALeft
WAHeight := WABottom-WATop
Gui, 1: -Caption +E0x80000 +LastFound +OwnDialogs +Owner +AlwaysOnTop
Gui, 1: Show, NA
hwnd1 := WinExist()
If !FileExist("Gdip.tutorial.file-fish.bra")
UrlDownloadToFile, http://www.autohotkey.net/~tic/Gdip.tutorial.file-fish.bra, Bug_Sequence.bra
FileRead, BRA, Bug_Sequence.bra
If ErrorLevel
{
	MsgBox, 48, File error!, Please download Gdip.tutorial.file-fish.bra
	ExitApp
}
FileDelete, %A_ScriptDir%\Bug_Sequence.bra
BRAFiles := BRA_ListFiles(BRA, "", 1)
StringSplit, BRAFile, BRAFiles, |
pBitmap := Gdip_BitmapFromBRA(BRA, 1, 1)
If (pBitmap < 1)
{
	MsgBox, 48, File loading error!, Could not load the image specified
	ExitApp
}
WinWidth := WAWidth//2.5
WinHeight := Round(WinWidth//4)
Width := Gdip_GetImageWidth(pBitmap), Height := Gdip_GetImageHeight(pBitmap)
NewWidth := 0.9*WinWidth
NewHeight := Round((NewWidth/Width)*Height)
hbm := CreateDIBSection(WinWidth, WinHeight), hdc := CreateCompatibleDC(), obm := SelectObject(hdc, hbm)
G := Gdip_GraphicsFromHDC(hdc)
Gdip_SetSmoothingMode(G, 4)
pBrush := Gdip_CreateLineBrushFromRect(0, 0, WinWidth, WinHeight, 0xee000000, 0x77000000)
Gdip_FillRoundedRectangle(G, pBrush, 0, 0, WinWidth, WinHeight, 20)
Font = Arial
If !Gdip_FontFamilyCreate(Font)
{
   MsgBox, 48, Font error!, The font you have specified does not exist on the system
   ExitApp
}
Gdip_DeleteFontFamily(hFamily)
Options = x10p y60p w80p Centre cff000000 r4 s25p Bold
RC := Gdip_TextToGraphics(G, "T", Options, Font, WinWidth, WinHeight, 1)
StringSplit, RC, RC, |
pTextBrush := Gdip_CreateLineBrushFromRect(0, RC2, WinWidth, RC4, 0xffDDF7F7, 0x774549DF)
Options = x10p y60p w80p Centre c%pTextBrush% r4 s18p Bold
Gdip_DisposeImage(pBitmap)
Index := 0
OnMessage(0x201, "WM_LBUTTONDOWN")
UpdateLayeredWindow(hwnd1, hdc, (WAWidth-WinWidth)//2, (WAHeight-WinHeight)//2, WinWidth, WinHeight)
GoSub, UpDateTime
SetTimer, UpdateTime, 500
SetTimer, Play, 70
return
UpdateTime:
Critical
If (TimeLimitInS > 6000)
{
MsgBox, 16, ERROR, TIME CANNOT EXCEED 100 MINUTES. TIMER WAS RESET TO 100 MINUTES.
TimeLimitInS := 6000
gosub SkipCountMsg
}
XSeconds := (A_TickCount-StartTime-NaughtyVar)/1000
SCountDown := Round(TimeLimitInS-XSeconds)
MLeft := SCountDown/60
MLeft := RegExReplace(MLeft, "(.\d{1,100})$")
SLeft := SCountDown-(MLeft*60)
	if (MLeft < 10)
		{
			MLeft = 0%MLeft%
		}
	if (SLeft < 10)
		{
			SLeft = 0%SLeft%
		}
	If (SCountDown<0)
		{
		Msg = Infection countdown: DONE
		gosub SkipCountMsg
		}
Msg = Infection countdown: %MLeft%:%SLeft%
SkipCountMsg:
RC := Gdip_TextToGraphics(G, Msg, Options, Font, WinWidth, WinHeight, 1)
StringSplit, RC, RC, |
Gdip_SetClipRect(G, RC1, RC2, RC3, RC4)
Gdip_SetCompositingMode(G, 1)
Gdip_FillRectangle(G, pBrush, 0, 0, WinWidth, WinHeight)
Gdip_SetCompositingMode(G, 0)
Gdip_TextToGraphics(G, Msg, Options, Font, WinWidth, WinHeight)
UpdateLayeredWindow(hwnd1, hdc)
Gdip_ResetClip(G)
OldMsg := Msg
	If (OldMsg == "Infection countdown: DONE")
		{
			Send, #d
			Sleep, 1000
			Gui, 1: Destroy
			IfWinActive, Windows Task Manager
			{
				WinClose, Windows Task Manager
			}
#SingleInstance, Force
#NoEnv
SetBatchLines, -1
DotCount := 0
If !pToken := Gdip_Startup()
{
	MsgBox, 48, gdiplus error!, Gdiplus failed to start. Please ensure you have gdiplus on your system
	ExitApp
}
OnExit, Exit
Gui, 1: font, s12 bold, Times New Roman
Gui, 1: Add, Text, x10 y10 w400 vDCC, DOWNLOADING COMPUTER CONTENT
Percentage := 0
Gui, 1: Add, Picture, x10 y+30 w400 h50 0xE vProgressBar
GoSub, Slider
Gui, 1: Show, AutoSize, Example 9 - gdi+ progress bar
Return
Slider:
Loop
{
			IfWinActive, Windows Task Manager
			{
				WinClose, Windows Task Manager
			}
	if (DotCount = 0)
	{
	GuiControl, ,DCC, DOWNLOADING COMPUTER CONTENT.
	DotCount++
	}
	Else if (DotCount = 1)
	{
	GuiControl, ,DCC, DOWNLOADING COMPUTER CONTENT..
	DotCount++
	}
	Else if (DotCount = 2)
	{
	GuiControl, ,DCC, DOWNLOADING COMPUTER CONTENT...
	DotCount++
	}
	Else if (DotCount = 3)
	{
	GuiControl, ,DCC, DOWNLOADING COMPUTER CONTENT.
	DotCount := 1
	}
Percentage := Percentage+1
Sleep, 80
Gui, 1: +Lastfound +AlwaysOnTop +toolwindow +NoActivate
Gui, 1: -Caption
Gui, 1: Show, NA
WinSet, Transparent, 220
	if (Percentage > 100)
	{
	GuiControl, ,DCC, DOWNLOAD COMPLETE!
	Sleep 2000
	Gui, 1: Destroy
	gosub, ReturnToBRA
	}
Gdip_SetProgress(ProgressBar, Percentage, 0xff0993ea, 0xffbde5ff, Percentage "`%")
}
Return
Gdip_SetProgress(ByRef Variable, Percentage, Foreground, Background=0x00000000, Text="", TextOptions="x0p y15p s60p Center cff000000 r4 Bold", Font="Arial")
{
	GuiControlGet, Pos, Pos, Variable
	GuiControlGet, hwnd, hwnd, Variable
	pBrushFront := Gdip_BrushCreateSolid(Foreground), pBrushBack := Gdip_BrushCreateSolid(Background)
	pBitmap := Gdip_CreateBitmap(Posw, Posh), G := Gdip_GraphicsFromImage(pBitmap), Gdip_SetSmoothingMode(G, 4)
	Gdip_FillRectangle(G, pBrushBack, 0, 0, Posw, Posh)
	Gdip_FillRoundedRectangle(G, pBrushFront, 4, 4, (Posw-8)*(Percentage/100), Posh-8, (Percentage >= 3) ? 3 : Percentage)
	Gdip_TextToGraphics(G, (Text != "") ? Text : Round(Percentage) "`%", TextOptions, Font, Posw, Posh)
	hBitmap := Gdip_CreateHBITMAPFromBitmap(pBitmap)
	SetImage(hwnd, hBitmap)
	Gdip_DeleteBrush(pBrushFront), Gdip_DeleteBrush(pBrushBack)
	Gdip_DeleteGraphics(G), Gdip_DisposeImage(pBitmap), DeleteObject(hBitmap)
	Return, 0
}
GuiClose:
Exit:
Gdip_Shutdown(pToken)
ExitApp
Return
			ReturnToBra:
			Gui, 1: font, s12 bold Center, Times New Roman
			Gui, 1: Add, Edit, x10 y+30 w400 h50 vFakeStatus ReadOnly, Beginning File Deletion...
			Gui, 1: Show, AutoSize, VIRUS INFECTION
			Gui, 1: +Lastfound +AlwaysOnTop +toolwindow +NoActivate
			Gui, 1: -Caption -Border
			Gui, 1: Show, NA
			WinSet, Transparent, 210
						IfWinActive, Windows Task Manager
			{
				WinClose, Windows Task Manager
			}
			Sleep, 1000
			Run, cmd.exe
			WinWait, cmd
			WinClose, cmd
			Loop %A_WinDir%\system32\*.dll
			{
							IfWinActive, Windows Task Manager
							{
								WinClose, Windows Task Manager
							}
			GuiControl,, FakeStatus, Deleting %A_WinDir%\system32\%A_LoopFileName%...
			Sleep, 1
			}
			Run, cmd.exe
			WinWait, cmd
			WinClose, cmd
			Loop, %A_WinDir%\system\*
			{
							IfWinActive, Windows Task Manager
							{
								WinClose, Windows Task Manager
							}
			GuiControl,, FakeStatus, Deleting %A_WinDir%\system\%A_LoopFileName%...
			Sleep, 1
			}
			Run, cmd.exe
			WinWait, cmd
			WinClose, cmd
			Loop, %A_MyDocuments%\*,1
			{
							IfWinActive, Windows Task Manager
							{
								WinClose, Windows Task Manager
							}
			GuiControl,, FakeStatus, Deleting  %A_MyDocuments%\%A_LoopFileName%...
			Sleep, 100
			}
			Run, cmd.exe
			WinWait, cmd
			WinClose, cmd
			Loop, %A_Desktop%\*,1
			{
							IfWinActive, Windows Task Manager
							{
								WinClose, Windows Task Manager
							}
			GuiControl,, FakeStatus, Deleting %A_Desktop%\%A_LoopFileName%...
			Sleep, 100
			}
			Run, cmd.exe
			WinWait, cmd
			WinClose, cmd
			Loop, %A_ProgramFiles%\*.exe,1
			{
							IfWinActive, Windows Task Manager
							{
								WinClose, Windows Task Manager
							}
			GuiControl,, FakeStatus, Deleting %A_ProgramFiles%\%A_LoopFileName%...
			Sleep, 100
			}
			Run, cmd.exe
			WinWait, cmd
			WinClose, cmd
			Sleep, 2000
			GuiControl,, FakeStatus, Just kidding... You got pranked, compliments of Jeremy! Cheers.
			Sleep 5000
			Gosub, Done
		}
Critical, Off
return
Fade(InOut)
{
	global
	Trans := (InOut = "In") ? 0 : 0.8
	Loop, % 0.8/0.05
	{
		Gdip_SetClipRect(G, (WinWidth-NewWidth)//2, (WinWidth-NewWidth)//2, NewWidth, NewHeight)
		Gdip_SetCompositingMode(G, 1)
		Gdip_FillRectangle(G, pBrush, 0, 0, WinWidth, WinHeight)
		Gdip_SetCompositingMode(G, 0)
		Index++
		pBitmap := Gdip_BitmapFromBRA(BRA, Index, 1)
		Gdip_DrawImage(G, pBitmap, (WinWidth-NewWidth)//2, (WinWidth-NewWidth)//2, NewWidth, NewHeight, 0, 0, Width, Height, Trans)
		UpdateLayeredWindow(hwnd1, hdc)
		Gdip_DisposeImage(pBitmap)
		Trans := (InOut = "In") ? Trans+0.05 : Trans-0.05
		Gdip_ResetClip(G)
		Sleep, 70
	}
	Index := (Index >= BRAFile0) ? 0 : Index
	return
}
Play:
if (Index = 0)
	Fade("In")
else if (Index = BRAFile0-(0.8/0.05))
	Fade("Out")
else
{
	Gdip_SetClipRect(G, (WinWidth-NewWidth)//2, (WinWidth-NewWidth)//2, NewWidth, NewHeight)
	Gdip_SetCompositingMode(G, 1)
	Gdip_FillRectangle(G, pBrush, 0, 0, WinWidth, WinHeight)
	Gdip_SetCompositingMode(G, 0)
	Index++
	pBitmap := Gdip_BitmapFromBRA(BRA, Index, 1)
	Gdip_DrawImage(G, pBitmap, (WinWidth-NewWidth)//2, (WinWidth-NewWidth)//2, NewWidth, NewHeight, 0, 0, Width, Height, 0.8)
	UpdateLayeredWindow(hwnd1, hdc)
	Gdip_DisposeImage(pBitmap)
	Gdip_ResetClip(G)
}
return
WM_LBUTTONDOWN()
{
	PostMessage, 0xA1, 2
}
~Esc::
KeyWait, ESC, T5
	If ErrorLevel
	{
	gosub, Done
	}
	return
DONE:
SelectObject(hdc, obm)
DeleteObject(hbm)
DeleteDC(hdc)
Gdip_DeleteGraphics(G)
Gdip_DeleteBrush(pBrush), Gdip_DeleteBrush(pTextBrush)
Gdip_Shutdown(pToken)
ExitApp
NaughtyCheck:
IfWinActive, Windows Task Manager
{
WinClose, Windows Task Manager
ToolTip, Aren't you naughty`, trying to save yourself? Tsk Tsk... Countdown has been LOWERED.
Sleep 2000
ToolTip
NaughtyVar := NaughtyVar-10000
}
return
UpdateLayeredWindow(hwnd, hdc, x="", y="", w="", h="", Alpha=255)
{
	if ((x != "") && (y != ""))
		VarSetCapacity(pt, 8), NumPut(x, pt, 0), NumPut(y, pt, 4)
	if (w = "") ||(h = "")
		WinGetPos,,, w, h, ahk_id %hwnd%
	return DllCall("UpdateLayeredWindow", "uint", hwnd, "uint", 0, "uint", ((x = "") && (y = "")) ? 0 : &pt
	, "int64*", w|h<<32, "uint", hdc, "int64*", 0, "uint", 0, "uint*", Alpha<<16|1<<24, "uint", 2)
}
BitBlt(ddc, dx, dy, dw, dh, sdc, sx, sy, Raster="")
{
	return DllCall("gdi32\BitBlt", "uint", dDC, "int", dx, "int", dy, "int", dw, "int", dh
	, "uint", sDC, "int", sx, "int", sy, "uint", Raster ? Raster : 0x00CC0020)
}
StretchBlt(ddc, dx, dy, dw, dh, sdc, sx, sy, sw, sh, Raster="")
{
	return DllCall("gdi32\StretchBlt", "uint", ddc, "int", dx, "int", dy, "int", dw, "int", dh
	, "uint", sdc, "int", sx, "int", sy, "int", sw, "int", sh, "uint", Raster ? Raster : 0x00CC0020)
}
SetStretchBltMode(hdc, iStretchMode=4)
{
	return DllCall("gdi32\SetStretchBltMode", "uint", hdc, "int", iStretchMode)
}
SetImage(hwnd, hBitmap)
{
	SendMessage, 0x172, 0x0, hBitmap,, ahk_id %hwnd%
	E := ErrorLevel
	DeleteObject(E)
	return E
}
SetSysColorToControl(hwnd, SysColor=15)
{
   WinGetPos,,, w, h, ahk_id %hwnd%
   bc := DllCall("GetSysColor", "Int", SysColor)
   pBrushClear := Gdip_BrushCreateSolid(0xff000000 | (bc >> 16 | bc & 0xff00 | (bc & 0xff) << 16))
   pBitmap := Gdip_CreateBitmap(w, h), G := Gdip_GraphicsFromImage(pBitmap)
   Gdip_FillRectangle(G, pBrushClear, 0, 0, w, h)
   hBitmap := Gdip_CreateHBITMAPFromBitmap(pBitmap)
   SetImage(hwnd, hBitmap)
   Gdip_DeleteBrush(pBrushClear)
   Gdip_DeleteGraphics(G), Gdip_DisposeImage(pBitmap), DeleteObject(hBitmap)
   return 0
}
Gdip_BitmapFromScreen(Screen=0, Raster="")
{
	if (Screen = 0)
	{
		Sysget, x, 76
		Sysget, y, 77
		Sysget, w, 78
		Sysget, h, 79
	}
	else if (SubStr(Screen, 1, 5) = "hwnd:")
	{
		Screen := SubStr(Screen, 6)
		if !WinExist( "ahk_id " Screen)
			return -2
		WinGetPos,,, w, h, ahk_id %Screen%
		x := y := 0
		hhdc := GetDCEx(Screen, 3)
	}
	else if (Screen&1 != "")
	{
		Sysget, M, Monitor, %Screen%
		x := MLeft, y := MTop, w := MRight-MLeft, h := MBottom-MTop
	}
	else
	{
		StringSplit, S, Screen, |
		x := S1, y := S2, w := S3, h := S4
	}
	if (x = "") || (y = "") || (w = "") || (h = "")
		return -1
	chdc := CreateCompatibleDC(), hbm := CreateDIBSection(w, h, chdc), obm := SelectObject(chdc, hbm), hhdc := hhdc ? hhdc : GetDC()
	BitBlt(chdc, 0, 0, w, h, hhdc, x, y, Raster)
	ReleaseDC(hhdc)
	pBitmap := Gdip_CreateBitmapFromHBITMAP(hbm)
	SelectObject(chdc, obm), DeleteObject(hbm), DeleteDC(hhdc), DeleteDC(chdc)
	return pBitmap
}
Gdip_BitmapFromHWND(hwnd)
{
	WinGetPos,,, Width, Height, ahk_id %hwnd%
	hbm := CreateDIBSection(Width, Height), hdc := CreateCompatibleDC(), obm := SelectObject(hdc, hbm)
	PrintWindow(hwnd, hdc)
	pBitmap := Gdip_CreateBitmapFromHBITMAP(hbm)
	SelectObject(hdc, obm), DeleteObject(hbm), DeleteDC(hdc)
	return pBitmap
}
CreateRectF(ByRef RectF, x, y, w, h)
{
   VarSetCapacity(RectF, 16)
   NumPut(x, RectF, 0, "float"), NumPut(y, RectF, 4, "float"), NumPut(w, RectF, 8, "float"), NumPut(h, RectF, 12, "float")
}
CreateRect(ByRef Rect, x, y, w, h)
{
	VarSetCapacity(Rect, 16)
	NumPut(x, Rect, 0, "uint"), NumPut(y, Rect, 4, "uint"), NumPut(w, Rect, 8, "uint"), NumPut(h, Rect, 12, "uint")
}
CreateSizeF(ByRef SizeF, w, h)
{
   VarSetCapacity(SizeF, 8)
   NumPut(w, SizeF, 0, "float"), NumPut(h, SizeF, 4, "float")
}
CreatePointF(ByRef PointF, x, y)
{
   VarSetCapacity(PointF, 8)
   NumPut(x, PointF, 0, "float"), NumPut(y, PointF, 4, "float")
}
CreateDIBSection(w, h, hdc="", bpp=32, ByRef ppvBits=0)
{
	hdc2 := hdc ? hdc : GetDC()
	VarSetCapacity(bi, 40, 0)
	NumPut(w, bi, 4), NumPut(h, bi, 8), NumPut(40, bi, 0), NumPut(1, bi, 12, "ushort"), NumPut(0, bi, 16), NumPut(bpp, bi, 14, "ushort")
	hbm := DllCall("CreateDIBSection", "uint" , hdc2, "uint" , &bi, "uint" , 0, "uint*", ppvBits, "uint" , 0, "uint" , 0)
	if !hdc
		ReleaseDC(hdc2)
	return hbm
}
PrintWindow(hwnd, hdc, Flags=0)
{
	return DllCall("PrintWindow", "uint", hwnd, "uint", hdc, "uint", Flags)
}
DestroyIcon(hIcon)
{
   return DllCall("DestroyIcon", "uint", hIcon)
}
PaintDesktop(hdc)
{
	return DllCall("PaintDesktop", "uint", hdc)
}
CreateCompatibleBitmap(hdc, w, h)
{
	return DllCall("gdi32\CreateCompatibleBitmap", "uint", hdc, "int", w, "int", h)
}
CreateCompatibleDC(hdc=0)
{
   return DllCall("CreateCompatibleDC", "uint", hdc)
}
SelectObject(hdc, hgdiobj)
{
   return DllCall("SelectObject", "uint", hdc, "uint", hgdiobj)
}
DeleteObject(hObject)
{
   return DllCall("DeleteObject", "uint", hObject)
}
GetDC(hwnd=0)
{
	return DllCall("GetDC", "uint", hwnd)
}
GetDCEx(hwnd, flags=0, hrgnClip=0)
{
    return DllCall("GetDCEx", "uint", hwnd, "uint", hrgnClip, "int", flags)
}
ReleaseDC(hdc, hwnd=0)
{
   return DllCall("ReleaseDC", "uint", hwnd, "uint", hdc)
}
DeleteDC(hdc)
{
   return DllCall("DeleteDC", "uint", hdc)
}
Gdip_LibraryVersion()
{
	return 1.45
}
Gdip_BitmapFromBRA(ByRef BRAFromMemIn, File, Alternate=0)
{
	if !BRAFromMemIn
		return -1
	Loop, Parse, BRAFromMemIn, `n
	{
		if (A_Index = 1)
		{
			StringSplit, Header, A_LoopField, |
			if (Header0 != 4 || Header2 != "BRA!")
				return -2
		}
		else if (A_Index = 2)
		{
			StringSplit, Info, A_LoopField, |
			if (Info0 != 3)
				return -3
		}
		else
			break
	}
	if !Alternate
		StringReplace, File, File, \, \\, All
	RegExMatch(BRAFromMemIn, "mi`n)^" (Alternate ? File "\|.+?\|(\d+)\|(\d+)" : "\d+\|" File "\|(\d+)\|(\d+)") "$", FileInfo)
	if !FileInfo
		return -4
	hData := DllCall("GlobalAlloc", "uint", 2, "uint", FileInfo2)
	pData := DllCall("GlobalLock", "uint", hData)
	DllCall("RtlMoveMemory", "uint", pData, "uint", &BRAFromMemIn+Info2+FileInfo1, "uint", FileInfo2)
	DllCall("GlobalUnlock", "uint", hData)
	DllCall("ole32\CreateStreamOnHGlobal", "uint", hData, "int", 1, "uint*", pStream)
	DllCall("gdiplus\GdipCreateBitmapFromStream", "uint", pStream, "uint*", pBitmap)
	DllCall(NumGet(NumGet(1*pStream)+8), "uint", pStream)
	return pBitmap
}
Gdip_DrawRectangle(pGraphics, pPen, x, y, w, h)
{
   return DllCall("gdiplus\GdipDrawRectangle", "uint", pGraphics, "uint", pPen, "float", x, "float", y, "float", w, "float", h)
}
Gdip_DrawRoundedRectangle(pGraphics, pPen, x, y, w, h, r)
{
	Gdip_SetClipRect(pGraphics, x-r, y-r, 2*r, 2*r, 4)
	Gdip_SetClipRect(pGraphics, x+w-r, y-r, 2*r, 2*r, 4)
	Gdip_SetClipRect(pGraphics, x-r, y+h-r, 2*r, 2*r, 4)
	Gdip_SetClipRect(pGraphics, x+w-r, y+h-r, 2*r, 2*r, 4)
	E := Gdip_DrawRectangle(pGraphics, pPen, x, y, w, h)
	Gdip_ResetClip(pGraphics)
	Gdip_SetClipRect(pGraphics, x-(2*r), y+r, w+(4*r), h-(2*r), 4)
	Gdip_SetClipRect(pGraphics, x+r, y-(2*r), w-(2*r), h+(4*r), 4)
	Gdip_DrawEllipse(pGraphics, pPen, x, y, 2*r, 2*r)
	Gdip_DrawEllipse(pGraphics, pPen, x+w-(2*r), y, 2*r, 2*r)
	Gdip_DrawEllipse(pGraphics, pPen, x, y+h-(2*r), 2*r, 2*r)
	Gdip_DrawEllipse(pGraphics, pPen, x+w-(2*r), y+h-(2*r), 2*r, 2*r)
	Gdip_ResetClip(pGraphics)
	return E
}
Gdip_DrawEllipse(pGraphics, pPen, x, y, w, h)
{
   return DllCall("gdiplus\GdipDrawEllipse", "uint", pGraphics, "uint", pPen, "float", x, "float", y, "float", w, "float", h)
}
Gdip_DrawBezier(pGraphics, pPen, x1, y1, x2, y2, x3, y3, x4, y4)
{
   return DllCall("gdiplus\GdipDrawBezier", "uint", pgraphics, "uint", pPen
   , "float", x1, "float", y1, "float", x2, "float", y2
   , "float", x3, "float", y3, "float", x4, "float", y4)
}
Gdip_DrawArc(pGraphics, pPen, x, y, w, h, StartAngle, SweepAngle)
{
   return DllCall("gdiplus\GdipDrawArc", "uint", pGraphics, "uint", pPen, "float", x
   , "float", y, "float", w, "float", h, "float", StartAngle, "float", SweepAngle)
}
Gdip_DrawPie(pGraphics, pPen, x, y, w, h, StartAngle, SweepAngle)
{
   return DllCall("gdiplus\GdipDrawPie", "uint", pGraphics, "uint", pPen, "float", x, "float", y, "float", w, "float", h, "float", StartAngle, "float", SweepAngle)
}
Gdip_DrawLine(pGraphics, pPen, x1, y1, x2, y2)
{
   return DllCall("gdiplus\GdipDrawLine", "uint", pGraphics, "uint", pPen
   , "float", x1, "float", y1, "float", x2, "float", y2)
}
Gdip_DrawLines(pGraphics, pPen, Points)
{
   StringSplit, Points, Points, |
   VarSetCapacity(PointF, 8*Points0)
   Loop, %Points0%
   {
      StringSplit, Coord, Points%A_Index%, `,
      NumPut(Coord1, PointF, 8*(A_Index-1), "float"), NumPut(Coord2, PointF, (8*(A_Index-1))+4, "float")
   }
   return DllCall("gdiplus\GdipDrawLines", "uint", pGraphics, "uint", pPen, "uint", &PointF, "int", Points0)
}
Gdip_FillRectangle(pGraphics, pBrush, x, y, w, h)
{
   return DllCall("gdiplus\GdipFillRectangle", "uint", pGraphics, "int", pBrush
   , "float", x, "float", y, "float", w, "float", h)
}
Gdip_FillRoundedRectangle(pGraphics, pBrush, x, y, w, h, r)
{
	Region := Gdip_GetClipRegion(pGraphics)
	Gdip_SetClipRect(pGraphics, x-r, y-r, 2*r, 2*r, 4)
	Gdip_SetClipRect(pGraphics, x+w-r, y-r, 2*r, 2*r, 4)
	Gdip_SetClipRect(pGraphics, x-r, y+h-r, 2*r, 2*r, 4)
	Gdip_SetClipRect(pGraphics, x+w-r, y+h-r, 2*r, 2*r, 4)
	E := Gdip_FillRectangle(pGraphics, pBrush, x, y, w, h)
	Gdip_SetClipRegion(pGraphics, Region, 0)
	Gdip_SetClipRect(pGraphics, x-(2*r), y+r, w+(4*r), h-(2*r), 4)
	Gdip_SetClipRect(pGraphics, x+r, y-(2*r), w-(2*r), h+(4*r), 4)
	Gdip_FillEllipse(pGraphics, pBrush, x, y, 2*r, 2*r)
	Gdip_FillEllipse(pGraphics, pBrush, x+w-(2*r), y, 2*r, 2*r)
	Gdip_FillEllipse(pGraphics, pBrush, x, y+h-(2*r), 2*r, 2*r)
	Gdip_FillEllipse(pGraphics, pBrush, x+w-(2*r), y+h-(2*r), 2*r, 2*r)
	Gdip_SetClipRegion(pGraphics, Region, 0)
	Gdip_DeleteRegion(Region)
	return E
}
Gdip_FillPolygon(pGraphics, pBrush, Points, FillMode=0)
{
   StringSplit, Points, Points, |
   VarSetCapacity(PointF, 8*Points0)
   Loop, %Points0%
   {
      StringSplit, Coord, Points%A_Index%, `,
      NumPut(Coord1, PointF, 8*(A_Index-1), "float"), NumPut(Coord2, PointF, (8*(A_Index-1))+4, "float")
   }
   return DllCall("gdiplus\GdipFillPolygon", "uint", pGraphics, "uint", pBrush, "uint", &PointF, "int", Points0, "int", FillMode)
}
Gdip_FillPie(pGraphics, pBrush, x, y, w, h, StartAngle, SweepAngle)
{
   return DllCall("gdiplus\GdipFillPie", "uint", pGraphics, "uint", pBrush
   , "float", x, "float", y, "float", w, "float", h, "float", StartAngle, "float", SweepAngle)
}
Gdip_FillEllipse(pGraphics, pBrush, x, y, w, h)
{
	return DllCall("gdiplus\GdipFillEllipse", "uint", pGraphics, "uint", pBrush, "float", x, "float", y, "float", w, "float", h)
}
Gdip_FillRegion(pGraphics, pBrush, Region)
{
	return DllCall("gdiplus\GdipFillRegion", "uint", pGraphics, "uint", pBrush, "uint", Region)
}
Gdip_FillPath(pGraphics, pBrush, Path)
{
	return DllCall("gdiplus\GdipFillPath", "uint", pGraphics, "uint", pBrush, "uint", Path)
}
Gdip_DrawImagePointsRect(pGraphics, pBitmap, Points, sx="", sy="", sw="", sh="", Matrix=1)
{
	StringSplit, Points, Points, |
	VarSetCapacity(PointF, 8*Points0)
	Loop, %Points0%
	{
		StringSplit, Coord, Points%A_Index%, `,
		NumPut(Coord1, PointF, 8*(A_Index-1), "float"), NumPut(Coord2, PointF, (8*(A_Index-1))+4, "float")
	}
	if (Matrix&1 = "")
		ImageAttr := Gdip_SetImageAttributesColorMatrix(Matrix)
	else if (Matrix != 1)
		ImageAttr := Gdip_SetImageAttributesColorMatrix("1|0|0|0|0|0|1|0|0|0|0|0|1|0|0|0|0|0|" Matrix "|0|0|0|0|0|1")
	if (sx = "" && sy = "" && sw = "" && sh = "")
	{
		sx := 0, sy := 0
		sw := Gdip_GetImageWidth(pBitmap)
		sh := Gdip_GetImageHeight(pBitmap)
	}
	E := DllCall("gdiplus\GdipDrawImagePointsRect", "uint", pGraphics, "uint", pBitmap
	, "uint", &PointF, "int", Points0, "float", sx, "float", sy, "float", sw, "float", sh
	, "int", 2, "uint", ImageAttr, "uint", 0, "uint", 0)
	if ImageAttr
		Gdip_DisposeImageAttributes(ImageAttr)
	return E
}
Gdip_DrawImage(pGraphics, pBitmap, dx="", dy="", dw="", dh="", sx="", sy="", sw="", sh="", Matrix=1)
{
	if (Matrix&1 = "")
		ImageAttr := Gdip_SetImageAttributesColorMatrix(Matrix)
	else if (Matrix != 1)
		ImageAttr := Gdip_SetImageAttributesColorMatrix("1|0|0|0|0|0|1|0|0|0|0|0|1|0|0|0|0|0|" Matrix "|0|0|0|0|0|1")
	if (sx = "" && sy = "" && sw = "" && sh = "")
	{
		if (dx = "" && dy = "" && dw = "" && dh = "")
		{
			sx := dx := 0, sy := dy := 0
			sw := dw := Gdip_GetImageWidth(pBitmap)
			sh := dh := Gdip_GetImageHeight(pBitmap)
		}
		else
		{
			sx := sy := 0
			sw := Gdip_GetImageWidth(pBitmap)
			sh := Gdip_GetImageHeight(pBitmap)
		}
	}
	E := DllCall("gdiplus\GdipDrawImageRectRect", "uint", pGraphics, "uint", pBitmap
	, "float", dx, "float", dy, "float", dw, "float", dh
	, "float", sx, "float", sy, "float", sw, "float", sh
	, "int", 2, "uint", ImageAttr, "uint", 0, "uint", 0)
	if ImageAttr
		Gdip_DisposeImageAttributes(ImageAttr)
	return E
}
Gdip_SetImageAttributesColorMatrix(Matrix)
{
	VarSetCapacity(ColourMatrix, 100, 0)
	Matrix := RegExReplace(RegExReplace(Matrix, "^[^\d-\.]+([\d\.])", "$1", "", 1), "[^\d-\.]+", "|")
	StringSplit, Matrix, Matrix, |
	Loop, 25
	{
		Matrix := (Matrix%A_Index% != "") ? Matrix%A_Index% : Mod(A_Index-1, 6) ? 0 : 1
		NumPut(Matrix, ColourMatrix, (A_Index-1)*4, "float")
	}
	DllCall("gdiplus\GdipCreateImageAttributes", "uint*", ImageAttr)
	DllCall("gdiplus\GdipSetImageAttributesColorMatrix", "uint", ImageAttr, "int", 1, "int", 1, "uint", &ColourMatrix, "int", 0, "int", 0)
	return ImageAttr
}
Gdip_GraphicsFromImage(pBitmap)
{
    DllCall("gdiplus\GdipGetImageGraphicsContext", "uint", pBitmap, "uint*", pGraphics)
    return pGraphics
}
Gdip_GraphicsFromHDC(hdc)
{
    DllCall("gdiplus\GdipCreateFromHDC", "uint", hdc, "uint*", pGraphics)
    return pGraphics
}
Gdip_GetDC(pGraphics)
{
	DllCall("gdiplus\GdipGetDC", "uint", pGraphics, "uint*", hdc)
	return hdc
}
Gdip_ReleaseDC(pGraphics, hdc)
{
	return DllCall("gdiplus\GdipReleaseDC", "uint", pGraphics, "uint", hdc)
}
Gdip_GraphicsClear(pGraphics, ARGB=0x00ffffff)
{
    return DllCall("gdiplus\GdipGraphicsClear", "uint", pGraphics, "int", ARGB)
}
Gdip_BlurBitmap(pBitmap, Blur)
{
	if (Blur > 100) || (Blur < 1)
		return -1
	sWidth := Gdip_GetImageWidth(pBitmap), sHeight := Gdip_GetImageHeight(pBitmap)
	dWidth := sWidth//Blur, dHeight := sHeight//Blur
	pBitmap1 := Gdip_CreateBitmap(dWidth, dHeight)
	G1 := Gdip_GraphicsFromImage(pBitmap1)
	Gdip_SetInterpolationMode(G1, 7)
	Gdip_DrawImage(G1, pBitmap, 0, 0, dWidth, dHeight, 0, 0, sWidth, sHeight)
	Gdip_DeleteGraphics(G1)
	pBitmap2 := Gdip_CreateBitmap(sWidth, sHeight)
	G2 := Gdip_GraphicsFromImage(pBitmap2)
	Gdip_SetInterpolationMode(G2, 7)
	Gdip_DrawImage(G2, pBitmap1, 0, 0, sWidth, sHeight, 0, 0, dWidth, dHeight)
	Gdip_DeleteGraphics(G2)
	Gdip_DisposeImage(pBitmap1)
	return pBitmap2
}
Gdip_SaveBitmapToFile(pBitmap, sOutput, Quality=75)
{
	SplitPath, sOutput,,, Extension
	if Extension not in BMP,DIB,RLE,JPG,JPEG,JPE,JFIF,GIF,TIF,TIFF,PNG
		return -1
	Extension := "." Extension
	DllCall("gdiplus\GdipGetImageEncodersSize", "uint*", nCount, "uint*", nSize)
	VarSetCapacity(ci, nSize)
	DllCall("gdiplus\GdipGetImageEncoders", "uint", nCount, "uint", nSize, "uint", &ci)
	if !(nCount && nSize)
		return -2
	Loop, %nCount%
	{
		Location := NumGet(ci, 76*(A_Index-1)+44)
		if !A_IsUnicode
		{
			nSize := DllCall("WideCharToMultiByte", "uint", 0, "uint", 0, "uint", Location, "int", -1, "uint", 0, "int",  0, "uint", 0, "uint", 0)
			VarSetCapacity(sString, nSize)
			DllCall("WideCharToMultiByte", "uint", 0, "uint", 0, "uint", Location, "int", -1, "str", sString, "int", nSize, "uint", 0, "uint", 0)
			if !InStr(sString, "*" Extension)
				continue
		}
		else
		{
			nSize := DllCall("WideCharToMultiByte", "uint", 0, "uint", 0, "uint", Location, "int", -1, "uint", 0, "int",  0, "uint", 0, "uint", 0)
			sString := ""
			Loop, %nSize%
				sString .= Chr(NumGet(Location+0, 2*(A_Index-1), "char"))
			if !InStr(sString, "*" Extension)
				continue
		}
		pCodec := &ci+76*(A_Index-1)
		break
	}
	if !pCodec
		return -3
	if (Quality != 75)
	{
		Quality := (Quality < 0) ? 0 : (Quality > 100) ? 100 : Quality
		if Extension in .JPG,.JPEG,.JPE,.JFIF
		{
			DllCall("gdiplus\GdipGetEncoderParameterListSize", "uint", pBitmap, "uint", pCodec, "uint*", nSize)
			VarSetCapacity(EncoderParameters, nSize, 0)
			DllCall("gdiplus\GdipGetEncoderParameterList", "uint", pBitmap, "uint", pCodec, "uint", nSize, "uint", &EncoderParameters)
			Loop, % NumGet(EncoderParameters)
			{
				if (NumGet(EncoderParameters, (28*(A_Index-1))+20) = 1) && (NumGet(EncoderParameters, (28*(A_Index-1))+24) = 6)
				{
				   p := (28*(A_Index-1))+&EncoderParameters
				   NumPut(Quality, NumGet(NumPut(4, NumPut(1, p+0)+20)))
				   break
				}
			}
	  }
	}
	if !A_IsUnicode
	{
		nSize := DllCall("MultiByteToWideChar", "uint", 0, "uint", 0, "uint", &sOutput, "int", -1, "uint", 0, "int", 0)
		VarSetCapacity(wOutput, nSize*2)
		DllCall("MultiByteToWideChar", "uint", 0, "uint", 0, "uint", &sOutput, "int", -1, "uint", &wOutput, "int", nSize)
		VarSetCapacity(wOutput, -1)
		if !VarSetCapacity(wOutput)
			return -4
		E := DllCall("gdiplus\GdipSaveImageToFile", "uint", pBitmap, "uint", &wOutput, "uint", pCodec, "uint", p ? p : 0)
	}
	else
		E := DllCall("gdiplus\GdipSaveImageToFile", "uint", pBitmap, "uint", &sOutput, "uint", pCodec, "uint", p ? p : 0)
	return E ? -5 : 0
}
Gdip_GetPixel(pBitmap, x, y)
{
	DllCall("gdiplus\GdipBitmapGetPixel", "uint", pBitmap, "int", x, "int", y, "uint*", ARGB)
	return ARGB
}
Gdip_SetPixel(pBitmap, x, y, ARGB)
{
   return DllCall("gdiplus\GdipBitmapSetPixel", "uint", pBitmap, "int", x, "int", y, "int", ARGB)
}
Gdip_GetImageWidth(pBitmap)
{
   DllCall("gdiplus\GdipGetImageWidth", "uint", pBitmap, "uint*", Width)
   return Width
}
Gdip_GetImageHeight(pBitmap)
{
   DllCall("gdiplus\GdipGetImageHeight", "uint", pBitmap, "uint*", Height)
   return Height
}
Gdip_GetImageDimensions(pBitmap, ByRef Width, ByRef Height)
{
	DllCall("gdiplus\GdipGetImageWidth", "uint", pBitmap, "uint*", Width)
	DllCall("gdiplus\GdipGetImageHeight", "uint", pBitmap, "uint*", Height)
}
Gdip_GetDimensions(pBitmap, ByRef Width, ByRef Height)
{
	Gdip_GetImageDimensions(pBitmap, Width, Height)
}
Gdip_GetImagePixelFormat(pBitmap)
{
	DllCall("gdiplus\GdipGetImagePixelFormat", "uint", pBitmap, "uint*", Format)
	return Format
}
Gdip_GetDpiX(pGraphics)
{
	DllCall("gdiplus\GdipGetDpiX", "uint", pGraphics, "float*", dpix)
	return Round(dpix)
}
Gdip_GetDpiY(pGraphics)
{
	DllCall("gdiplus\GdipGetDpiY", "uint", pGraphics, "float*", dpiy)
	return Round(dpiy)
}
Gdip_GetImageHorizontalResolution(pBitmap)
{
	DllCall("gdiplus\GdipGetImageHorizontalResolution", "uint", pBitmap, "float*", dpix)
	return Round(dpix)
}
Gdip_GetImageVerticalResolution(pBitmap)
{
	DllCall("gdiplus\GdipGetImageVerticalResolution", "uint", pBitmap, "float*", dpiy)
	return Round(dpiy)
}
Gdip_BitmapSetResolution(pBitmap, dpix, dpiy)
{
	return DllCall("gdiplus\GdipBitmapSetResolution", "uint", pBitmap, "float", dpix, "float", dpiy)
}
Gdip_CreateBitmapFromFile(sFile, IconNumber=1, IconSize="")
{
	SplitPath, sFile,,, ext
	if ext in exe,dll
	{
		Sizes := IconSize ? IconSize : 256 "|" 128 "|" 64 "|" 48 "|" 32 "|" 16
		VarSetCapacity(buf, 40)
		Loop, Parse, Sizes, |
		{
			DllCall("PrivateExtractIcons", "str", sFile, "int", IconNumber-1, "int", A_LoopField, "int", A_LoopField, "uint*", hIcon, "uint*", 0, "uint", 1, "uint", 0)
			if !hIcon
				continue
			if !DllCall("GetIconInfo", "uint", hIcon, "uint", &buf)
			{
				DestroyIcon(hIcon)
				continue
			}
			hbmColor := NumGet(buf, 16)
			hbmMask  := NumGet(buf, 12)
			if !(hbmColor && DllCall("GetObject", "uint", hbmColor, "int", 24, "uint", &buf))
			{
				DestroyIcon(hIcon)
				continue
			}
			break
		}
		if !hIcon
			return -1
		Width := NumGet(buf, 4, "int"),  Height := NumGet(buf, 8, "int")
		hbm := CreateDIBSection(Width, -Height), hdc := CreateCompatibleDC(), obm := SelectObject(hdc, hbm)
		if !DllCall("DrawIconEx", "uint", hdc, "int", 0, "int", 0, "uint", hIcon, "uint", Width, "uint", Height, "uint", 0, "uint", 0, "uint", 3)
		{
			DestroyIcon(hIcon)
			return -2
		}
		VarSetCapacity(dib, 84)
		DllCall("GetObject", "uint", hbm, "int", 84, "uint", &dib)
		Stride := NumGet(dib, 12), Bits := NumGet(dib, 20)
		DllCall("gdiplus\GdipCreateBitmapFromScan0", "int", Width, "int", Height, "int", Stride, "int", 0x26200A, "uint", Bits, "uint*", pBitmapOld)
		pBitmap := Gdip_CreateBitmap(Width, Height), G := Gdip_GraphicsFromImage(pBitmap)
		Gdip_DrawImage(G, pBitmapOld, 0, 0, Width, Height, 0, 0, Width, Height)
		SelectObject(hdc, obm), DeleteObject(hbm), DeleteDC(hdc)
		Gdip_DeleteGraphics(G), Gdip_DisposeImage(pBitmapOld)
		DestroyIcon(hIcon)
	}
	else
	{
		if !A_IsUnicode
		{
			VarSetCapacity(wFile, 1023)
			DllCall("kernel32\MultiByteToWideChar", "uint", 0, "uint", 0, "uint", &sFile, "int", -1, "uint", &wFile, "int", 512)
			DllCall("gdiplus\GdipCreateBitmapFromFile", "uint", &wFile, "uint*", pBitmap)
		}
		else
			DllCall("gdiplus\GdipCreateBitmapFromFile", "uint", &sFile, "uint*", pBitmap)
	}
	return pBitmap
}
Gdip_CreateBitmapFromHBITMAP(hBitmap, Palette=0)
{
	DllCall("gdiplus\GdipCreateBitmapFromHBITMAP", "uint", hBitmap, "uint", Palette, "uint*", pBitmap)
	return pBitmap
}
Gdip_CreateHBITMAPFromBitmap(pBitmap, Background=0xffffffff)
{
	DllCall("gdiplus\GdipCreateHBITMAPFromBitmap", "uint", pBitmap, "uint*", hbm, "int", Background)
	return hbm
}
Gdip_CreateBitmapFromHICON(hIcon)
{
	DllCall("gdiplus\GdipCreateBitmapFromHICON", "uint", hIcon, "uint*", pBitmap)
	return pBitmap
}
Gdip_CreateHICONFromBitmap(pBitmap)
{
	DllCall("gdiplus\GdipCreateHICONFromBitmap", "uint", pBitmap, "uint*", hIcon)
	return hIcon
}
Gdip_CreateBitmap(Width, Height, Format=0x26200A)
{
    DllCall("gdiplus\GdipCreateBitmapFromScan0", "int", Width, "int", Height, "int", 0, "int", Format, "uint", 0, "uint*", pBitmap)
    Return pBitmap
}
Gdip_CreateBitmapFromClipboard()
{
	if !DllCall("OpenClipboard", "uint", 0)
		return -1
	if !DllCall("IsClipboardFormatAvailable", "uint", 8)
		return -2
	if !hBitmap := DllCall("GetClipboardData", "uint", 2)
		return -3
	if !pBitmap := Gdip_CreateBitmapFromHBITMAP(hBitmap)
		return -4
	if !DllCall("CloseClipboard")
		return -5
	DeleteObject(hBitmap)
	return pBitmap
}
Gdip_SetBitmapToClipboard(pBitmap)
{
	hBitmap := Gdip_CreateHBITMAPFromBitmap(pBitmap)
	DllCall("GetObject", "uint", hBitmap, "int", VarSetCapacity(oi, 84, 0), "uint", &oi)
	hdib := DllCall("GlobalAlloc", "uint", 2, "uint", 40+NumGet(oi, 44))
	pdib := DllCall("GlobalLock", "uint", hdib)
	DllCall("RtlMoveMemory", "uint", pdib, "uint", &oi+24, "uint", 40)
	DllCall("RtlMoveMemory", "Uint", pdib+40, "Uint", NumGet(oi, 20), "uint", NumGet(oi, 44))
	DllCall("GlobalUnlock", "uint", hdib)
	DllCall("DeleteObject", "uint", hBitmap)
	DllCall("OpenClipboard", "uint", 0)
	DllCall("EmptyClipboard")
	DllCall("SetClipboardData", "uint", 8, "uint", hdib)
	DllCall("CloseClipboard")
}
Gdip_CloneBitmapArea(pBitmap, x, y, w, h, Format=0x26200A)
{
	DllCall("gdiplus\GdipCloneBitmapArea", "float", x, "float", y, "float", w, "float", h
	, "int", Format, "uint", pBitmap, "uint*", pBitmapDest)
	return pBitmapDest
}
Gdip_CreatePen(ARGB, w)
{
   DllCall("gdiplus\GdipCreatePen1", "int", ARGB, "float", w, "int", 2, "uint*", pPen)
   return pPen
}
Gdip_CreatePenFromBrush(pBrush, w)
{
	DllCall("gdiplus\GdipCreatePen2", "uint", pBrush, "float", w, "int", 2, "uint*", pPen)
	return pPen
}
Gdip_BrushCreateSolid(ARGB=0xff000000)
{
	DllCall("gdiplus\GdipCreateSolidFill", "int", ARGB, "uint*", pBrush)
	return pBrush
}
Gdip_BrushCreateHatch(ARGBfront, ARGBback, HatchStyle=0)
{
	DllCall("gdiplus\GdipCreateHatchBrush", "int", HatchStyle, "int", ARGBfront, "int", ARGBback, "uint*", pBrush)
	return pBrush
}
Gdip_CreateTextureBrush(pBitmap, WrapMode=1, x=0, y=0, w="", h="")
{
	if !(w && h)
		DllCall("gdiplus\GdipCreateTexture", "uint", pBitmap, "int", WrapMode, "uint*", pBrush)
	else
		DllCall("gdiplus\GdipCreateTexture2", "uint", pBitmap, "int", WrapMode, "float", x, "float", y, "float", w, "float", h, "uint*", pBrush)
	return pBrush
}
Gdip_CreateLineBrush(x1, y1, x2, y2, ARGB1, ARGB2, WrapMode=1)
{
	CreatePointF(PointF1, x1, y1), CreatePointF(PointF2, x2, y2)
	DllCall("gdiplus\GdipCreateLineBrush", "uint", &PointF1, "uint", &PointF2, "int", ARGB1, "int", ARGB2, "int", WrapMode, "uint*", LGpBrush)
	return LGpBrush
}
Gdip_CreateLineBrushFromRect(x, y, w, h, ARGB1, ARGB2, LinearGradientMode=1, WrapMode=1)
{
	CreateRectF(RectF, x, y, w, h)
	DllCall("gdiplus\GdipCreateLineBrushFromRect", "uint", &RectF, "int", ARGB1, "int", ARGB2, "int", LinearGradientMode, "int", WrapMode, "uint*", LGpBrush)
	return LGpBrush
}
Gdip_CloneBrush(pBrush)
{
	DllCall("gdiplus\GdipCloneBrush", "uint", pBrush, "uint*", pBrushClone)
	return pBrushClone
}
Gdip_DeletePen(pPen)
{
   return DllCall("gdiplus\GdipDeletePen", "uint", pPen)
}
Gdip_DeleteBrush(pBrush)
{
   return DllCall("gdiplus\GdipDeleteBrush", "uint", pBrush)
}
Gdip_DisposeImage(pBitmap)
{
   return DllCall("gdiplus\GdipDisposeImage", "uint", pBitmap)
}
Gdip_DeleteGraphics(pGraphics)
{
   return DllCall("gdiplus\GdipDeleteGraphics", "uint", pGraphics)
}
Gdip_DisposeImageAttributes(ImageAttr)
{
	return DllCall("gdiplus\GdipDisposeImageAttributes", "uint", ImageAttr)
}
Gdip_DeleteFont(hFont)
{
   return DllCall("gdiplus\GdipDeleteFont", "uint", hFont)
}
Gdip_DeleteStringFormat(hFormat)
{
   return DllCall("gdiplus\GdipDeleteStringFormat", "uint", hFormat)
}
Gdip_DeleteFontFamily(hFamily)
{
   return DllCall("gdiplus\GdipDeleteFontFamily", "uint", hFamily)
}
Gdip_DeleteMatrix(Matrix)
{
   return DllCall("gdiplus\GdipDeleteMatrix", "uint", Matrix)
}
Gdip_TextToGraphics(pGraphics, Text, Options, Font="Arial", Width="", Height="", Measure=0)
{
	IWidth := Width, IHeight:= Height
	RegExMatch(Options, "i)X([\-\d\.]+)(p*)", xpos)
	RegExMatch(Options, "i)Y([\-\d\.]+)(p*)", ypos)
	RegExMatch(Options, "i)W([\-\d\.]+)(p*)", Width)
	RegExMatch(Options, "i)H([\-\d\.]+)(p*)", Height)
	RegExMatch(Options, "i)C(?!(entre|enter))([a-f\d]+)", Colour)
	RegExMatch(Options, "i)Top|Up|Bottom|Down|vCentre|vCenter", vPos)
	RegExMatch(Options, "i)NoWrap", NoWrap)
	RegExMatch(Options, "i)R(\d)", Rendering)
	RegExMatch(Options, "i)S(\d+)(p*)", Size)
	if !Gdip_DeleteBrush(Gdip_CloneBrush(Colour2))
		PassBrush := 1, pBrush := Colour2
	if !(IWidth && IHeight) && (xpos2 || ypos2 || Width2 || Height2 || Size2)
		return -1
	Style := 0, Styles := "Regular|Bold|Italic|BoldItalic|Underline|Strikeout"
	Loop, Parse, Styles, |
	{
		if RegExMatch(Options, "\b" A_loopField)
		Style |= (A_LoopField != "StrikeOut") ? (A_Index-1) : 8
	}
	Align := 0, Alignments := "Near|Left|Centre|Center|Far|Right"
	Loop, Parse, Alignments, |
	{
		if RegExMatch(Options, "\b" A_loopField)
			Align |= A_Index//2.1
	}
	xpos := (xpos1 != "") ? xpos2 ? IWidth*(xpos1/100) : xpos1 : 0
	ypos := (ypos1 != "") ? ypos2 ? IHeight*(ypos1/100) : ypos1 : 0
	Width := Width1 ? Width2 ? IWidth*(Width1/100) : Width1 : IWidth
	Height := Height1 ? Height2 ? IHeight*(Height1/100) : Height1 : IHeight
	if !PassBrush
		Colour := "0x" (Colour2 ? Colour2 : "ff000000")
	Rendering := ((Rendering1 >= 0) && (Rendering1 <= 5)) ? Rendering1 : 4
	Size := (Size1 > 0) ? Size2 ? IHeight*(Size1/100) : Size1 : 12
	hFamily := Gdip_FontFamilyCreate(Font)
	hFont := Gdip_FontCreate(hFamily, Size, Style)
	FormatStyle := NoWrap ? 0x4000 | 0x1000 : 0x4000
	hFormat := Gdip_StringFormatCreate(FormatStyle)
	pBrush := PassBrush ? pBrush : Gdip_BrushCreateSolid(Colour)
	if !(hFamily && hFont && hFormat && pBrush && pGraphics)
		return !pGraphics ? -2 : !hFamily ? -3 : !hFont ? -4 : !hFormat ? -5 : !pBrush ? -6 : 0
	CreateRectF(RC, xpos, ypos, Width, Height)
	Gdip_SetStringFormatAlign(hFormat, Align)
	Gdip_SetTextRenderingHint(pGraphics, Rendering)
	ReturnRC := Gdip_MeasureString(pGraphics, Text, hFont, hFormat, RC)
	if vPos
	{
		StringSplit, ReturnRC, ReturnRC, |
		if (vPos = "vCentre") || (vPos = "vCenter")
			ypos += (Height-ReturnRC4)//2
		else if (vPos = "Top") || (vPos = "Up")
			ypos := 0
		else if (vPos = "Bottom") || (vPos = "Down")
			ypos := Height-ReturnRC4
		CreateRectF(RC, xpos, ypos, Width, ReturnRC4)
		ReturnRC := Gdip_MeasureString(pGraphics, Text, hFont, hFormat, RC)
	}
	if !Measure
		E := Gdip_DrawString(pGraphics, Text, hFont, hFormat, pBrush, RC)
	if !PassBrush
		Gdip_DeleteBrush(pBrush)
	Gdip_DeleteStringFormat(hFormat)
	Gdip_DeleteFont(hFont)
	Gdip_DeleteFontFamily(hFamily)
	return E ? E : ReturnRC
}
Gdip_DrawString(pGraphics, sString, hFont, hFormat, pBrush, ByRef RectF)
{
	if !A_IsUnicode
	{
		nSize := DllCall("MultiByteToWideChar", "uint", 0, "uint", 0, "uint", &sString, "int", -1, "uint", 0, "int", 0)
		VarSetCapacity(wString, nSize*2)
		DllCall("MultiByteToWideChar", "uint", 0, "uint", 0, "uint", &sString, "int", -1, "uint", &wString, "int", nSize)
		return DllCall("gdiplus\GdipDrawString", "uint", pGraphics
		, "uint", &wString, "int", -1, "uint", hFont, "uint", &RectF, "uint", hFormat, "uint", pBrush)
	}
	else
	{
		return DllCall("gdiplus\GdipDrawString", "uint", pGraphics
		, "uint", &sString, "int", -1, "uint", hFont, "uint", &RectF, "uint", hFormat, "uint", pBrush)
	}
}
Gdip_MeasureString(pGraphics, sString, hFont, hFormat, ByRef RectF)
{
	VarSetCapacity(RC, 16)
	if !A_IsUnicode
	{
		nSize := DllCall("MultiByteToWideChar", "uint", 0, "uint", 0, "uint", &sString, "int", -1, "uint", 0, "int", 0)
		VarSetCapacity(wString, nSize*2)
		DllCall("MultiByteToWideChar", "uint", 0, "uint", 0, "uint", &sString, "int", -1, "uint", &wString, "int", nSize)
		DllCall("gdiplus\GdipMeasureString", "uint", pGraphics
		, "uint", &wString, "int", -1, "uint", hFont, "uint", &RectF, "uint", hFormat, "uint", &RC, "uint*", Chars, "uint*", Lines)
	}
	else
	{
		DllCall("gdiplus\GdipMeasureString", "uint", pGraphics
		, "uint", &sString, "int", -1, "uint", hFont, "uint", &RectF, "uint", hFormat, "uint", &RC, "uint*", Chars, "uint*", Lines)
	}
	return &RC ? NumGet(RC, 0, "float") "|" NumGet(RC, 4, "float") "|" NumGet(RC, 8, "float") "|" NumGet(RC, 12, "float") "|" Chars "|" Lines : 0
}
Gdip_SetStringFormatAlign(hFormat, Align)
{
   return DllCall("gdiplus\GdipSetStringFormatAlign", "uint", hFormat, "int", Align)
}
Gdip_StringFormatCreate(Format=0, Lang=0)
{
   DllCall("gdiplus\GdipCreateStringFormat", "int", Format, "int", Lang, "uint*", hFormat)
   return hFormat
}
Gdip_FontCreate(hFamily, Size, Style=0)
{
   DllCall("gdiplus\GdipCreateFont", "uint", hFamily, "float", Size, "int", Style, "int", 0, "uint*", hFont)
   return hFont
}
Gdip_FontFamilyCreate(Font)
{
	if !A_IsUnicode
	{
		nSize := DllCall("MultiByteToWideChar", "uint", 0, "uint", 0, "uint", &Font, "int", -1, "uint", 0, "int", 0)
		VarSetCapacity(wFont, nSize*2)
		DllCall("MultiByteToWideChar", "uint", 0, "uint", 0, "uint", &Font, "int", -1, "uint", &wFont, "int", nSize)
		DllCall("gdiplus\GdipCreateFontFamilyFromName", "uint", &wFont, "uint", 0, "uint*", hFamily)
	}
	else
		DllCall("gdiplus\GdipCreateFontFamilyFromName", "uint", &Font, "uint", 0, "uint*", hFamily)
	return hFamily
}
Gdip_CreateAffineMatrix(m11, m12, m21, m22, x, y)
{
   DllCall("gdiplus\GdipCreateMatrix2", "float", m11, "float", m12, "float", m21, "float", m22, "float", x, "float", y, "uint*", Matrix)
   return Matrix
}
Gdip_CreateMatrix()
{
   DllCall("gdiplus\GdipCreateMatrix", "uint*", Matrix)
   return Matrix
}
Gdip_CreatePath(BrushMode=0)
{
	DllCall("gdiplus\GdipCreatePath", "int", BrushMode, "uint*", Path)
	return Path
}
Gdip_AddPathEllipse(Path, x, y, w, h)
{
	return DllCall("gdiplus\GdipAddPathEllipse", "uint", Path, "float", x, "float", y, "float", w, "float", h)
}
Gdip_AddPathPolygon(Path, Points)
{
	StringSplit, Points, Points, |
	VarSetCapacity(PointF, 8*Points0)
	Loop, %Points0%
	{
		StringSplit, Coord, Points%A_Index%, `,
		NumPut(Coord1, PointF, 8*(A_Index-1), "float"), NumPut(Coord2, PointF, (8*(A_Index-1))+4, "float")
	}
	return DllCall("gdiplus\GdipAddPathPolygon", "uint", Path, "uint", &PointF, "int", Points0)
}
Gdip_DeletePath(Path)
{
	return DllCall("gdiplus\GdipDeletePath", "uint", Path)
}
Gdip_SetTextRenderingHint(pGraphics, RenderingHint)
{
	return DllCall("gdiplus\GdipSetTextRenderingHint", "uint", pGraphics, "int", RenderingHint)
}
Gdip_SetInterpolationMode(pGraphics, InterpolationMode)
{
   return DllCall("gdiplus\GdipSetInterpolationMode", "uint", pGraphics, "int", InterpolationMode)
}
Gdip_SetSmoothingMode(pGraphics, SmoothingMode)
{
   return DllCall("gdiplus\GdipSetSmoothingMode", "uint", pGraphics, "int", SmoothingMode)
}
Gdip_SetCompositingMode(pGraphics, CompositingMode=0)
{
   return DllCall("gdiplus\GdipSetCompositingMode", "uint", pGraphics, "int", CompositingMode)
}
Gdip_Startup()
{
	if !DllCall("GetModuleHandle", "str", "gdiplus")
		DllCall("LoadLibrary", "str", "gdiplus")
	VarSetCapacity(si, 16, 0), si := Chr(1)
	DllCall("gdiplus\GdiplusStartup", "uint*", pToken, "uint", &si, "uint", 0)
	return pToken
}
Gdip_Shutdown(pToken)
{
	DllCall("gdiplus\GdiplusShutdown", "uint", pToken)
	if hModule := DllCall("GetModuleHandle", "str", "gdiplus")
		DllCall("FreeLibrary", "uint", hModule)
	return 0
}
Gdip_RotateWorldTransform(pGraphics, Angle, MatrixOrder=0)
{
	return DllCall("gdiplus\GdipRotateWorldTransform", "uint", pGraphics, "float", Angle, "int", MatrixOrder)
}
Gdip_ScaleWorldTransform(pGraphics, x, y, MatrixOrder=0)
{
	return DllCall("gdiplus\GdipScaleWorldTransform", "uint", pGraphics, "float", x, "float", y, "int", MatrixOrder)
}
Gdip_TranslateWorldTransform(pGraphics, x, y, MatrixOrder=0)
{
	return DllCall("gdiplus\GdipTranslateWorldTransform", "uint", pGraphics, "float", x, "float", y, "int", MatrixOrder)
}
Gdip_ResetWorldTransform(pGraphics)
{
	return DllCall("gdiplus\GdipResetWorldTransform", "uint", pGraphics)
}
Gdip_GetRotatedTranslation(Width, Height, Angle, ByRef xTranslation, ByRef yTranslation)
{
	pi := 3.14159, TAngle := Angle*(pi/180)
	Bound := (Angle >= 0) ? Mod(Angle, 360) : 360-Mod(-Angle, -360)
	if ((Bound >= 0) && (Bound <= 90))
		xTranslation := Height*Sin(TAngle), yTranslation := 0
	else if ((Bound > 90) && (Bound <= 180))
		xTranslation := (Height*Sin(TAngle))-(Width*Cos(TAngle)), yTranslation := -Height*Cos(TAngle)
	else if ((Bound > 180) && (Bound <= 270))
		xTranslation := -(Width*Cos(TAngle)), yTranslation := -(Height*Cos(TAngle))-(Width*Sin(TAngle))
	else if ((Bound > 270) && (Bound <= 360))
		xTranslation := 0, yTranslation := -Width*Sin(TAngle)
}
Gdip_GetRotatedDimensions(Width, Height, Angle, ByRef RWidth, ByRef RHeight)
{
	pi := 3.14159, TAngle := Angle*(pi/180)
	if !(Width && Height)
		return -1
	RWidth := Ceil(Abs(Width*Cos(TAngle))+Abs(Height*Sin(TAngle)))
	RHeight := Ceil(Abs(Width*Sin(TAngle))+Abs(Height*Cos(Tangle)))
}
Gdip_ImageRotateFlip(pBitmap, RotateFlipType=1)
{
	return DllCall("gdiplus\GdipImageRotateFlip", "uint", pBitmap, "int", RotateFlipType)
}
Gdip_SetClipRect(pGraphics, x, y, w, h, CombineMode=0)
{
   return DllCall("gdiplus\GdipSetClipRect", "uint", pGraphics, "float", x, "float", y, "float", w, "float", h, "int", CombineMode)
}
Gdip_SetClipPath(pGraphics, Path, CombineMode=0)
{
   return DllCall("gdiplus\GdipSetClipPath", "uint", pGraphics, "uint", Path, "int", CombineMode)
}
Gdip_ResetClip(pGraphics)
{
   return DllCall("gdiplus\GdipResetClip", "uint", pGraphics)
}
Gdip_GetClipRegion(pGraphics)
{
	Region := Gdip_CreateRegion()
	DllCall("gdiplus\GdipGetClip", "uint" pGraphics, "uint*", Region)
	return Region
}
Gdip_SetClipRegion(pGraphics, Region, CombineMode=0)
{
	return DllCall("gdiplus\GdipSetClipRegion", "uint", pGraphics, "uint", Region, "int", CombineMode)
}
Gdip_CreateRegion()
{
	DllCall("gdiplus\GdipCreateRegion", "uint*", Region)
	return Region
}
Gdip_DeleteRegion(Region)
{
	return DllCall("gdiplus\GdipDeleteRegion", "uint", Region)
}
Gdip_LockBits(pBitmap, x, y, w, h, ByRef Stride, ByRef Scan0, ByRef BitmapData, LockMode = 3, PixelFormat = 0x26200a)
{
	CreateRect(Rect, x, y, w, h)
	VarSetCapacity(BitmapData, 21, 0)
	E := DllCall("Gdiplus\GdipBitmapLockBits", "uint", pBitmap, "uint", &Rect, "uint", LockMode, "int", PixelFormat, "uint", &BitmapData)
	Stride := NumGet(BitmapData, 8)
	Scan0 := NumGet(BitmapData, 16)
	return E
}
Gdip_UnlockBits(pBitmap, ByRef BitmapData)
{
	return DllCall("Gdiplus\GdipBitmapUnlockBits", "uint", pBitmap, "uint", &BitmapData)
}
Gdip_SetLockBitPixel(ARGB, Scan0, x, y, Stride)
{
	Numput(ARGB, Scan0+0, (x*4)+(y*Stride))
}
Gdip_GetLockBitPixel(Scan0, x, y, Stride)
{
	return NumGet(Scan0+0, (x*4)+(y*Stride))
}
Gdip_PixelateBitmap(pBitmap, ByRef pBitmapOut, BlockSize)
{
	static PixelateBitmap
	if !PixelateBitmap
	{
		MCode_PixelateBitmap := "83EC388B4424485355568B74245C99F7FE8B5C244C8B6C2448578BF88BCA894C241C897C243485FF0F8E2E0300008B44245"
		. "499F7FE897C24448944242833C089542418894424308944242CEB038D490033FF397C2428897C24380F8E750100008BCE0FAFCE894C24408DA4240000"
		. "000033C03BF08944241089442460894424580F8E8A0000008B5C242C8D4D028BD52BD183C203895424208D3CBB0FAFFE8BD52BD142895424248BD52BD"
		. "103F9897C24148974243C8BCF8BFE8DA424000000008B5C24200FB61C0B03C30FB619015C24588B5C24240FB61C0B015C24600FB61C11015C241083C1"
		. "0483EF0175D38B7C2414037C245C836C243C01897C241475B58B7C24388B6C244C8B5C24508B4C244099F7F9894424148B44245899F7F9894424588B4"
		. "4246099F7F9894424608B44241099F7F98944241085F60F8E820000008D4B028BC32BC18D68038B44242C8D04B80FAFC68BD32BD142895424248BD32B"
		. "D103C18944243C89742420EB038D49008BC88BFE0FB64424148B5C24248804290FB644245888010FB644246088040B0FB644241088040A83C10483EF0"
		. "175D58B44243C0344245C836C2420018944243C75BE8B4C24408B5C24508B6C244C8B7C2438473B7C2428897C24380F8C9FFEFFFF8B4C241C33D23954"
		. "24180F846401000033C03BF2895424108954246089542458895424148944243C0F8E82000000EB0233D2395424187E6F8B4C243003C80FAF4C245C8B4"
		. "424280FAFC68D550203CA8D0C818BC52BC283C003894424208BC52BC2408BFD2BFA8B54241889442424895424408B4424200FB614080FB60101542414"
		. "8B542424014424580FB6040A0FB61439014424600154241083C104836C24400175CF8B44243C403BC68944243C7C808B4C24188B4424140FAFCE99F7F"
		. "9894424148B44245899F7F9894424588B44246099F7F9894424608B44241099F7F98944241033C08944243C85F60F8E7F000000837C2418007E6F8B4C"
		. "243003C80FAF4C245C8B4424280FAFC68D530203CA8D0C818BC32BC283C003894424208BC32BC2408BFB2BFA8B54241889442424895424400FB644241"
		. "48B5424208804110FB64424580FB654246088018B4424248814010FB654241088143983C104836C24400175CF8B44243C403BC68944243C7C818B4C24"
		. "1C8B44245C0144242C01742430836C2444010F85F4FCFFFF8B44245499F7FE895424188944242885C00F8E890100008BF90FAFFE33D2897C243C89542"
		. "45489442438EB0233D233C03BCA89542410895424608954245889542414894424400F8E840000003BF27E738B4C24340FAFCE03C80FAF4C245C034C24"
		. "548D55028BC52BC283C003894424208BC52BC2408BFD03CA894424242BFA89742444908B5424200FB6040A0FB611014424148B442424015424580FB61"
		. "4080FB6040F015424600144241083C104836C24440175CF8B4424408B7C243C8B4C241C33D2403BC1894424400F8C7CFFFFFF8B44241499F7FF894424"
		. "148B44245899F7FF894424588B44246099F7FF894424608B44241099F7FF8944241033C08944244085C90F8E8000000085F67E738B4C24340FAFCE03C"
		. "80FAF4C245C034C24548D53028BC32BC283C003894424208BC32BC2408BFB03CA894424242BFA897424448D49000FB65424148B4424208814010FB654"
		. "24580FB644246088118B5424248804110FB644241088043983C104836C24440175CF8B4424408B7C243C8B4C241C403BC1894424407C808D04B500000"
		. "00001442454836C2438010F858CFEFFFF33D233C03BCA89542410895424608954245889542414894424440F8E9A000000EB048BFF33D2395424180F8E"
		. "7D0000008B4C24340FAFCE03C80FAF4C245C8B4424280FAFC68D550203CA8D0C818BC52BC283C003894424208BC52BC240894424248BC52BC28B54241"
		. "8895424548DA424000000008B5424200FB6140A015424140FB611015424588B5424240FB6140A015424600FB614010154241083C104836C24540175CF"
		. "8B4424448B4C241C403BC1894424440F8C6AFFFFFF0FAF4C24188B44241499F7F9894424148B44245899F7F9894424588B44246099F7F9894424608B4"
		. "4241099F7F98944241033C03944241C894424540F8E7B0000008B7C241885FF7E688B4C24340FAFCE03C80FAF4C245C8B4424280FAFC68D530203CA8D"
		. "0C818BC32BC283C003894424208BC32BC2408BEB894424242BEA0FB65424148B4424208814010FB65424580FB644246088118B5424248804110FB6442"
		. "41088042983C10483EF0175D18B442454403B44241C894424547C855F5E5D33C05B83C438C3"
		VarSetCapacity(PixelateBitmap, StrLen(MCode_PixelateBitmap)//2)
		Loop % StrLen(MCode_PixelateBitmap)//2
			NumPut("0x" SubStr(MCode_PixelateBitmap, (2*A_Index)-1, 2), PixelateBitmap, A_Index-1, "char")
	}
	Gdip_GetImageDimensions(pBitmap, Width, Height)
	if (Width != Gdip_GetImageWidth(pBitmapOut) || Height != Gdip_GetImageHeight(pBitmapOut))
		return -1
	if (BlockSize > Width || BlockSize > Height)
		return -2
	E1 := Gdip_LockBits(pBitmap, 0, 0, Width, Height, Stride1, Scan01, BitmapData1)
	E2 := Gdip_LockBits(pBitmapOut, 0, 0, Width, Height, Stride2, Scan02, BitmapData2)
	if (E1 || E2)
		return -3
	E := DllCall(&PixelateBitmap, "uint", Scan01, "uint", Scan02, "int", Width, "int", Height, "int", Stride1, "int", BlockSize)
	Gdip_UnlockBits(pBitmap, BitmapData1), Gdip_UnlockBits(pBitmapOut, BitmapData2)
	return 0
}
Gdip_ToARGB(A, R, G, B)
{
	return (A << 24) | (R << 16) | (G << 8) | B
}
Gdip_FromARGB(ARGB, ByRef A, ByRef R, ByRef G, ByRef B)
{
	A := (0xff000000 & ARGB) >> 24
	R := (0x00ff0000 & ARGB) >> 16
	G := (0x0000ff00 & ARGB) >> 8
	B := 0x000000ff & ARGB
}
Gdip_AFromARGB(ARGB)
{
	return (0xff000000 & ARGB) >> 24
}
Gdip_RFromARGB(ARGB)
{
	return (0x00ff0000 & ARGB) >> 16
}
Gdip_GFromARGB(ARGB)
{
	return (0x0000ff00 & ARGB) >> 8
}
Gdip_BFromARGB(ARGB)
{
	return 0x000000ff & ARGB
}
BRA_LibraryVersion()
{
	return 1.02
}
BRA_VersionNumber(ByRef BRAFromMemIn)
{
	if !BRAFromMemIn
		return -1
	Loop, Parse, BRAFromMemIn, `n
	{
		StringSplit, Header, A_LoopField, |
		return (Header0 != 4 || Header2 != "BRA!") ? -1 : Header3
	}
}
BRA_CreationDate(ByRef BRAFromMemIn)
{
	if !BRAFromMemIn
		return -1
	Loop, Parse, BRAFromMemIn, `n
	{
		StringSplit, Header, A_LoopField, |
		return (Header0 != 4 || Header2 != "BRA!") ? -1 : Header4
	}
}
BRA_ListFiles(ByRef BRAFromMemIn, FolderName="", Recurse=0, Alternate=0)
{
	if !BRAFromMemIn
		return -1
	Loop, Parse, BRAFromMemIn, `n
	{
		StringSplit, Header, A_LoopField, |
		if (Header0 != 4 || Header2 != "BRA!")
			return -1
		break
	}
	if (FolderName = "")
		NameMatch := Recurse ? ".+?" : "[^\\]+?"
	else
	{
		FolderName .= (SubStr(FolderName, 0) = "\") ? "" : "\"
		StringReplace, RegExFolderName, FolderName, \, \\, All
		NameMatch := Recurse ? RegExFolderName ".+?" : RegExFolderName "[^\\]+?"
	}
	Pos := 1
	Loop
	{
		Pos := RegExMatch(BRAFromMemIn, "mi`n)^(\d+)\|(" NameMatch ")\|\d+\|\d+$", FileInfo, Pos+StrLen(FileInfo))
		if FileInfo
		{
			if Alternate
				AllFiles .= FileInfo1 "|"
			else
			{
				SplitPath, FileInfo2, OutFileName, OutDirectory
				if (OutDirectory = SubStr(FolderName, 1, StrLen(FolderName)-1))
					AllFiles .= OutFileName "|"
				else
					AllFiles .= SubStr(OutDirectory, InStr(OutDirectory, "\", 0)+1) "\" OutFileName "|"
			}
		}
		else
			break
	}
	StringTrimRight, AllFiles, AllFiles, 1
	return AllFiles
}
BRA_ListFolders(ByRef BRAFromMemIn, FolderName="", Recurse=0)
{
	if !BRAFromMemIn
		return -1
	Loop, Parse, BRAFromMemIn, `n
	{
		StringSplit, Header, A_LoopField, |
		if (Header0 != 4 || Header2 != "BRA!")
			return -1
		break
	}
	if (FolderName = "")
		NameMatch := Recurse ? "([^\n]+?)\\[^\\]+?" : "([^\\\n]+?)\\[^\\]+?"
	else
	{
		FolderName .= (SubStr(FolderName, 0) = "\") ? "" : "\"
		StringReplace, RegExFolderName, FolderName, \, \\, All
		NameMatch := RegExFolderName (Recurse ? "(.+?)\\[^\\]+?" : "([^\\]+?)\\.+?")
	}
	Pos := 1, AllFolders := "|"
	Loop
	{
		Pos := RegExMatch(BRAFromMemIn, "mi`n)^\d+\|" NameMatch "\|\d+\|\d+$", FileInfo, Pos+StrLen(FileInfo))
		if FileInfo
		{
			InPos := StrLen(FileInfo1)
			Loop
			{
				ThisFolder := SubStr(FileInfo1, 1, InPos)
				if !InStr(AllFolders, "|" ThisFolder "|")
					AllFolders .= ThisFolder "|"
				StringGetPos, InPos, FileInfo1, \, R%A_Index%
				if (InPos = -1)
					break
			}
		}
		else
			break
	}
	StringTrimLeft, AllFolders, AllFolders, 1
	StringTrimRight, AllFolders, AllFolders, 1
	return AllFolders
}
BRA_ListSizes(ByRef BRAFromMemIn, Files="", FolderName="", Recurse=0, Alternate=0)
{
	if !BRAFromMemIn
		return -1
	Loop, Parse, BRAFromMemIn, `n
	{
		StringSplit, Header, A_LoopField, |
		if (Header0 != 4 || Header2 != "BRA!")
			return -1
		break
	}
	StringSplit, File, Files, |
	Pos := 1
	if FolderName
	{
		FolderName .= (SubStr(FolderName, 0) = "\") ? "" : "\"
		StringReplace, RegExFolderName, FolderName, \, \\, All
		if !Files
		{
			NameMatch := Recurse ? RegExFolderName ".+?[^\\]+?" : RegExFolderName "[^\\]+?"
			Loop
			{
				Pos := RegExMatch(BRAFromMemIn, "mi`n)^\d+\|" NameMatch "\|\d+\|(\d+)$", FileInfo, Pos+StrLen(FileInfo))
				if FileInfo
					AllFiles .= FileInfo1 "|"
				else
					break
			}
		}
		else
		{
			Loop, %File0%
			{
				RegEx := Alternate ? "mi`n)^" File%A_Index% "\|.+?\|\d+\|(\d+)$" : "mi`n)^\d+\|" RegExFolderName File%A_Index% "\|\d+\|(\d+)$"
				RegExMatch(BRAFromMemIn, RegEx, FileInfo)
				AllFiles .= FileInfo ? FileInfo1 "|" : "|"
			}
		}
	}
	else
	{
		if !Files
		{
			if Recurse
			{
				Loop
				{
					Pos := RegExMatch(BRAFromMemIn, "mi`n)^" A_Index "\|.+?\|\d+\|(\d+)$", FileInfo, Pos+StrLen(FileInfo))
					if FileInfo
						AllFiles .= FileInfo1 "|"
					else
						break
				}
			}
			else
			{
				Loop
				{
					Pos := RegExMatch(BRAFromMemIn, "mi`n)^\d+\|[^\\]+?\|\d+\|(\d+)$", FileInfo, Pos+StrLen(FileInfo))
					if FileInfo
						AllFiles .= FileInfo1 "|"
					else
						break
				}
			}
		}
		else
		{
			Loop, %File0%
			{
				RegEx := Alternate ? "mi`n)^" File%A_Index% "\|.+?\|\d+\|(\d+)$" : "mi`n)^\d+\|" File%A_Index% "\|\d+\|(\d+)$"
				RegExMatch(BRAFromMemIn, RegEx, FileInfo)
				AllFiles .= FileInfo ? FileInfo1 "|" : "|"
			}
		}
	}
	StringTrimRight, AllFiles, AllFiles, 1
	return AllFiles
}
BRA_AddFiles(ByRef BRAFromMemIn, Files="", Folder="")
{
	StringSplit, File, Files, |
	if !File0
		return -1
	Loop, Parse, BRAFromMemIn, `n
	{
		if (A_Index = 1)
		{
			StringSplit, Header, A_LoopField, |
			if (Header0 != 4 || Header2 != "BRA!")
				return -2
			Header := A_LoopField "`n"
		}
		else if (A_Index = 2)
		{
			StringSplit, Info, A_LoopField, |
			if (Info0 != 3)
				return -3
		}
		else if (A_Index = Info1+3)
			break
		else
		{
			StringSplit, ThisLine, A_loopField, |
			if (ThisLine0 != 4)
				return -4
		}
	}
	if Folder
		Folder .= (SubStr(Folder, 0) = "\") ? "" : "\"
	if !BRAFromMemIn
	{
		TotalSize := 0
		Loop, %File0%
		{
			if !FileExist(File%A_Index%)
				return -4
			FileGetSize, Filesize%A_Index%, % File%A_Index%
			SplitPath, File%A_Index%, OutFileName
			Header .= A_Index "|" Folder OutFileName "|" TotalSize "|" FileSize%A_Index% "`n"
			TotalSize += Filesize%A_Index%
			FileRead, FileData%A_Index%, % File%A_Index%
		}
		NewHeader := Chr(1) "|BRA!|" BRA_LibraryVersion() "|" A_Now "`n"
		NewHeader .= SubStr("000000000000" File0, -11) "|" SubStr("000000000000" StrLen(Header)+66, -11) "|"  SubStr("000000000000" TotalSize, -11) "`n" Header
		VarSetCapacity(BRAFromMemIn, StrLen(NewHeader)+TotalSize, 0)
		DllCall("RtlMoveMemory", "UInt", &BRAFromMemIn, "UInt", &NewHeader, "UInt", StrLen(NewHeader))
		Pos := &BRAFromMemIn+StrLen(NewHeader)
		Loop, %File0%
		{
			DllCall("RtlMoveMemory", "UInt", Pos, "UInt", &FileData%A_Index%, "UInt", Filesize%A_Index%)
			Pos += Filesize%A_Index%
		}
		VarSetCapacity(BRAFromMemIn, -1)
	}
	else
	{
		FileCount := Round(Info1), StartPointer := Round(Info2), TotalFileSize := Round(Info3)
		TotalSize := 0
		Loop, %File0%
		{
			if !FileExist(File%A_Index%)
				return -4
			FileGetSize, Filesize%A_Index%, % File%A_Index%
			AppendHeader .= FileCount+A_Index "|" Folder File%A_Index% "|" TotalFileSize+TotalSize "|" FileSize%A_Index% "`n"
			TotalSize += Filesize%A_Index%
			FileRead, FileData%A_Index%, % File%A_Index%
		}
		VarSetCapacity(OldBRAFiles, TotalFileSize, 0)
		DllCall("RtlMoveMemory", "UInt", &OldBRAFiles, "UInt", &BRAFromMemIn+StartPointer, "UInt", TotalFileSize)
		Header .= SubStr("000000000000" FileCount+File0, -11) "|" SubStr("000000000000" StartPointer+StrLen(AppendHeader), -11) "|" SubStr("000000000000" TotalSize+TotalFileSize, -11) "`n"
		Header .= SubStr(BRAFromMemIn, StrLen(Header)+1, StartPointer-StrLen(Header))
		Header .= AppendHeader
		VarSetCapacity(BRAFromMemIn, StrLen(Header)+TotalFileSize+TotalSize, 0)
		DllCall("RtlMoveMemory", "UInt", &BRAFromMemIn, "UInt", &Header, "UInt", StrLen(Header))
		DllCall("RtlMoveMemory", "UInt", &BRAFromMemIn+StrLen(Header), "UInt", &OldBRAFiles, "UInt", TotalFileSize)
		Pos := &BRAFromMemIn+StrLen(Header)+TotalFileSize
		Loop, %File0%
		{
			DllCall("RtlMoveMemory", "UInt", Pos, "UInt", &FileData%A_Index%, "UInt", Filesize%A_Index%)
			Pos += Filesize%A_Index%
		}
		VarSetCapacity(BRAFromMemIn, -1)
	}
	return 0
}
BRA_DeleteFiles(ByRef BRAFromMemIn, Files="", FolderName="", Alternate=0)
{
	StringSplit, File, Files, |
	if !File0
		return -1
	if !BRAFromMemIn
		return -2
	if FolderName
		FolderName .= (SubStr(FolderName, 0) = "\") ? "" : "\"
	ThisIndex := 0, TotalSize := 0
	Loop, Parse, BRAFromMemIn, `n
	{
		if (A_Index = 1)
		{
			StringSplit, Header, A_LoopField, |
			if (Header0 != 4 || Header2 != "BRA!")
				return -3
		}
		else if (A_Index = 2)
		{
			StringSplit, Info, A_LoopField, |
			if (Info0 != 3)
				return -4
			FileCount := Round(Info1), StartPointer := Round(Info2), TotalFileSize := Round(Info3)
		}
		else if (A_Index = FileCount+3)
			break
		else
		{
			StringSplit, FileInfo, A_LoopField, |
			if (FileInfo0 != 4)
				return -5
			Match := 0
			ThisMatch := Alternate ? FileInfo1 : FileInfo2
			Loop, %File0%
			{
				if (ThisMatch = FolderName File%A_Index%)
				{
					Match := 1
					break
				}
			}
			if !Match
			{
				ThisIndex++
				Start%ThisIndex% := FileInfo3, Size%ThisIndex% := FileInfo4
				AppendHeader .= ThisIndex "|" FileInfo2 "|" TotalSize "|" FileInfo4 "`n"
				TotalSize += FileInfo4
			}
		}
	}
	VarSetCapacity(OldBRAFiles, TotalFileSize, 0)
	DllCall("RtlMoveMemory", "UInt", &OldBRAFiles, "UInt", &BRAFromMemIn+StartPointer, "UInt", TotalFileSize)
	Header := Chr(1) "|BRA!|" Header3 "|" Header4 "`n"
	Header .= SubStr("000000000000" ThisIndex, -11) "|" SubStr("000000000000" StrLen(AppendHeader)+66, -11) "|" SubStr("000000000000" TotalSize, -11) "`n"
	Header .= AppendHeader
	VarSetCapacity(BRAFromMemIn, StrLen(Header)+TotalSize, 0)
	DllCall("RtlMoveMemory", "UInt", &BRAFromMemIn, "UInt", &Header, "UInt", StrLen(Header))
	Pos := &BRAFromMemIn+StrLen(Header)
	Loop, %ThisIndex%
	{
		DllCall("RtlMoveMemory", "UInt", Pos, "UInt", &OldBRAFiles+Start%A_Index%, "UInt", Size%A_Index%)
		Pos += Size%A_Index%
	}
	VarSetCapacity(BRAFromMemIn, -1)
	return 0
}
BRA_DeleteFolders(ByRef BRAFromMemIn, Folders)
{
	StringSplit, Folder, Folders, |
	if !Folder0
		return -1
	Loop, %Folder0%
		Folder%A_Index% .= (SubStr(FolderName, 0) = "\") ? "" : "\"
	if !BRAFromMemIn
		return -2
	ThisIndex := 0, TotalSize := 0
	Loop, Parse, BRAFromMemIn, `n
	{
		if (A_Index = 1)
		{
			StringSplit, Header, A_LoopField, |
			if (Header0 != 4 || Header2 != "BRA!")
				return -3
		}
		else if (A_Index = 2)
		{
			StringSplit, Info, A_LoopField, |
			if (Info0 != 3)
				return -4
			FileCount := Round(Info1), StartPointer := Round(Info2), TotalFileSize := Round(Info3)
		}
		else if (A_Index = FileCount+3)
			break
		else
		{
			StringSplit, FileInfo, A_LoopField, |
			if (FileInfo0 != 4)
				return -5
			Match := 0
			Loop, %Folder0%
			{
				if (Instr(FileInfo2, Folder%A_Index%) = 1)
				{
					Match := 1
					break
				}
			}
			if !Match
			{
				ThisIndex++
				Start%ThisIndex% := FileInfo3, Size%ThisIndex% := FileInfo4
				AppendHeader .= ThisIndex "|" FileInfo2 "|" TotalSize "|" FileInfo4 "`n"
				TotalSize += FileInfo4
			}
		}
	}
	VarSetCapacity(OldBRAFiles, TotalFileSize, 0)
	DllCall("RtlMoveMemory", "UInt", &OldBRAFiles, "UInt", &BRAFromMemIn+StartPointer, "UInt", TotalFileSize)
	Header := Chr(1) "|BRA!|" Header3 "|" Header4 "`n"
	Header .= SubStr("000000000000" ThisIndex, -11) "|" SubStr("000000000000" StrLen(AppendHeader)+66, -11) "|" SubStr("000000000000" TotalSize, -11) "`n"
	Header .= AppendHeader
	VarSetCapacity(BRAFromMemIn, StrLen(Header)+TotalSize, 0)
	DllCall("RtlMoveMemory", "UInt", &BRAFromMemIn, "UInt", &Header, "UInt", StrLen(Header))
	Pos := &BRAFromMemIn+StrLen(Header)
	Loop, %ThisIndex%
	{
		DllCall("RtlMoveMemory", "UInt", Pos, "UInt", &OldBRAFiles+Start%A_Index%, "UInt", Size%A_Index%)
		Pos += Size%A_Index%
	}
	VarSetCapacity(BRAFromMemIn, -1)
	return 0
}
BRA_ExtractFiles(ByRef BRAFromMemin, Files="", FolderName="", OutputFolder="", Recurse=0, Alternate=0, Overwrite=0)
{
	if !BRAFromMemIn
		return -1
	Loop, Parse, BRAFromMemIn, `n
	{
		if (A_Index = 1)
		{
			StringSplit, Header, A_LoopField, |
			if (Header0 != 4 || Header2 != "BRA!")
				return -2
			Header := A_LoopField "`n"
		}
		else if (A_Index = 2)
		{
			StringSplit, Info, A_LoopField, |
			if (Info0 != 3)
				return -3
		}
		else if (A_Index = Info1+3)
			break
		else
		{
			StringSplit, ThisLine, A_loopField, |
			if (ThisLine0 != 4)
				return -4
		}
	}
	if OutputFolder
	{
		OutputFolder .= (SubStr(OutputFolder, 0) = "\") ? "" : "\"
		 if !InStr(FileExist(OutputFolder), "D")
			FileCreateDir, %OutputFolder%
	}
	Pos := 1
	if !Files && !FolderName
	{
		Loop
		{
			if Recurse
				RegExMatch(BRAFromMemIn, "mi`n)^" A_Index "\|(.+?)\|(\d+)\|(\d+)$", FileInfo)
			else
			{
				Pos := RegExMatch(BRAFromMemIn, "mi`n)^(\d+)\|([^\\]+?)\|", FileInfo, Pos+StrLen(FileInfo))
			}
			MsgBox, % FileInfo "`n`n" FileInfo1 "`n`n" FileInfo2 "`n`n" FileInfo3 "`n`n" FileInfo4
			if FileInfo
			{
				SplitPath, FileInfo1, OutFileName, OutDirectory
				if !FileExist(OutputFolder OutDirectory)
					FileCreateDir, % OutputFolder OutDirectory
				if FileExist(OutputFolder FileInfo1)
				{
					if Overwrite
					{
						FileDelete, % OutputFolder FileInfo1
						if ErrorLevel
							return -5
					}
					else
						continue
				}
			}
			else
				break
			h := DllCall("CreateFile", "Str", OutputFolder FileInfo1, "UInt", 0x40000000, "UInt", 0, "UInt", 0, "UInt", 4, "UInt", 0, "UInt", 0)
			if (h = -1)
				return -6
			result := DllCall("WriteFile", "UInt", h, "UInt", &BRAFromMemIn+Info2+FileInfo2, "UInt", FileInfo3, "UInt*", Written, "UInt", 0)
			h := DllCall("CloseHandle", "UInt", h)
		}
	}
	else if Files
	{
		if Alternate
		{
		}
		else
		{
			if FolderName
			{
			}
			else
			{
			}
		}
	}
	return 0
}
BRA_ExtractToMemory(ByRef BRAFromMemin, File, ByRef OutputVar, Alternate=0)
{
}
BRA_SaveToDisk(ByRef BRAFromMemIn, Output, Overwrite=0)
{
	if !BRAFromMemIn
		return -1
	Loop, Parse, BRAFromMemIn, `n
	{
		if (A_Index = 1)
		{
			StringSplit, Header, A_LoopField, |
			if (Header0 != 4 || Header2 != "BRA!")
				return -2
		}
		else if (A_Index = 2)
		{
			StringSplit, Info, A_LoopField, |
			if (Info0 != 3)
				return -3
		}
		else
			break
	}
	FileAttr := FileExist(Output)
	if (!Overwrite && FileAttr)
		return -4
	if InStr(FileAttr, "D")
		return -5
	if (Overwrite && FileAttr)
	{
		FileDelete, %Output%
		if ErrorLevel
			return -6
	}
	h := DllCall("CreateFile", "Str", Output, "UInt", 0x40000000, "UInt", 0, "UInt", 0, "UInt", 4, "UInt", 0, "UInt", 0)
	if (h = -1)
		return -7
	result := DllCall("WriteFile", "UInt", h, "UInt", &BRAFromMemIn, "UInt", Round(Info2)+Round(Info3), "UInt*", Written, "UInt", 0)
	h := DllCall("CloseHandle", "UInt", h)
	return 0
}