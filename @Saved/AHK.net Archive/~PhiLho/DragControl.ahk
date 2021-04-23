/*
DragControl.ahk

Shows how to drag a (static: Text or Picture) control within a GUI window.

// by Philippe Lhoste <PhiLho(a)GMX.net> http://Phi.Lho.free.fr
// File/Project history:
 1.00.000 -- 2006/02/17 (PL) -- Creation from extraction from sigma.ahk.

Base code/ideas for dragging by Veovis.
http://www.autohotkey.com/forum/viewtopic.php?p=52717
*/

#SingleInstance Force

Gui Add, Picture, x84 y84 w32 h32 vimageButton gImageClick Icon2, user32.dll
Gui Show, w200 h230
Return

ImageClick:
	DragControl(A_GuiControl)
Return

; @struct: hold the UInt to write
; _value: value to write
; _offset: offset of the UInt from the start of the struct, in UInt size units
SetUInt(ByRef @struct, _value, _offset=0)
{
	local addr
	addr := &@struct + _offset * 4
	DllCall("RtlFillMemory", "UInt", addr,     "UInt", 1, "UChar", (_value & 0x000000FF))
	DllCall("RtlFillMemory", "UInt", addr + 1, "UInt", 1, "UChar", (_value & 0x0000FF00) >> 8)
	DllCall("RtlFillMemory", "UInt", addr + 2, "UInt", 1, "UChar", (_value & 0x00FF0000) >> 16)
	DllCall("RtlFillMemory", "UInt", addr + 3, "UInt", 1, "UChar", (_value & 0xFF000000) >> 24)
}

; @struct: hold the UInt to extract
; _offset: offset of the UInt from the start of the struct, in UInt size units
GetUInt(ByRef @struct, _offset=0)
{
	local addr
	addr := &@struct + _offset * 4
	Return *addr + (*(addr + 1) << 8) +  (*(addr + 2) << 16) + (*(addr + 3) << 24)
}

DragControl(_controlName)
{
	local hWnd, point
	local initScrX, initScrY
	local initWinX, initWinY
	local initCliX, initCliY
	local offsetX, offsetY
	local mouseState, mouseX, mouseY
	; I must declare all four variables to keep them local, not polluting global namespace...
	local controlPos, controlPosX, controlPosY, controlPosW, controlPosH

	; Init.: compute the offsets
	; Screen coordinates of the mouse
	CoordMode Mouse, Screen
	MouseGetPos initScrX, initScrY, hWnd
	; Window relative coordinates of the mouse
	CoordMode Mouse, Relative	; Restore default
	MouseGetPos initWinX, initWinY
	; Compute client area relative coordinates of the mouse
	VarSetCapacity(point, 8)
	SetUInt(point, initScrX)
	SetUInt(point, initScrY, 1)
	DllCall("ScreenToClient", "UInt", hWnd, "UInt", &point)
	initCliX := GetUInt(point)
	initCliY := GetUInt(point, 1)
	; Coordinates of the control, relative to the client area
	GuiControlGet controlPos, Pos, %_controlName%
	mouseX := controlPosX
	mouseY := controlPosY
	; Compute offset between click inside control and top-left corner of control
	offsetX :=  initCliX - controlPosX
	offsetY :=  initCliY - controlPosY
	; Add offset between window and client area
	offsetX += initWinX - initCliX
	offsetY += initWinY - initCliY

	Loop
	{
		GetKeyState mouseState, LButton
		If (mouseState = "u")
			Break	; Mouse button is released
		; Window relative coordinates of the mouse
		MouseGetPos mouseX, mouseY
		; Corrected to client relative coordinates
		mouseX -= offsetX
		mouseY -= offsetY
		GuiControl MoveDraw, %_controlName%, x%mouseX% y%mouseY%
		Sleep 100
	}
	GuiControl Move, %_controlName%, x%mouseX% y%mouseY%
}

GuiClose:
GuiEscape:
ExitApp
