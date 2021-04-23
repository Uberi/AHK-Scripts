/*  AutoReload: 
 *  	Automatically reloads when stack falls below 100 Big blinds.
 *  
 *  License:
 *  	v0.0.1 by Xander
 *  	GNU General Public License 3.0 or higher: http://www.gnu.org/licenses/gpl-3.0.txt
 */


#NoEnv
#SingleInstance Force
#NoTrayIcon
#Include Includes/Functions.ahk
#Include Includes/Display.ahk
#Include Includes/List.ahk
SetTitleMatchMode, 2

FullTilt_1 := CreateArea("210,311,2,2", 472, 325)
FullTilt_2 := CreateArea("92,278,2,2", 472, 325)
FullTilt_3 := CreateArea("7,214,2,2", 472, 325)
FullTilt_4 := CreateArea("26,122,2,2", 472, 325)
FullTilt_5 := CreateArea("133,78,2,2", 472, 325)
FullTilt_6 := CreateArea("284,78,2,2", 472, 325)
FullTilt_7 := CreateArea("391,122,2,2", 472, 325)
FullTilt_8 := CreateArea("411,214,2,2", 472, 325)
FullTilt_9 := CreateArea("323,278,2,2", 472, 325)
FullTilt_10 := CreateArea("14,219,2,2", 472, 325)
FullTilt_11 := CreateArea("47,107,2,2", 472, 325)
FullTilt_12 := CreateArea("210,75,2,2", 472, 325)
FullTilt_13 := CreateArea("370,107,2,2", 472, 325)
FullTilt_14 := CreateArea("404,219,2,2", 472, 325)

FullTilt_RT1 := CreateArea("205,270,2,2", 472, 325)
FullTilt_RT2 := CreateArea("75,261,2,2", 472, 325)
FullTilt_RT3 := CreateArea("17,188,2,2", 472, 325)
FullTilt_RT4 := CreateArea("17,105,2,2", 472, 325)
FullTilt_RT5 := CreateArea("106,61,2,2", 472, 325)
FullTilt_RT6 := CreateArea("302,61,2,2", 472, 325)
FullTilt_RT7 := CreateArea("393,105,2,2", 472, 325)
FullTilt_RT8 := CreateArea("393,188,2,2", 472, 325)
FullTilt_RT9 := CreateArea("331,261,2,2", 472, 325)
FullTilt_RT10 := CreateArea("393,158,2,2", 472, 325)
FullTilt_RT11 := CreateArea("286,274,2,2", 472, 325)
FullTilt_RT12 := CreateArea("122,274,2,2", 472, 325)
FullTilt_RT13 := CreateArea("17,158,2,2", 472, 325)

IniRead, Maximum, PokerPad.ini, Reload, Maximum, 1
IniRead, BigBlinds, PokerPad.ini, Reload, BigBlinds, 100

OnMessage(0x5555, "HandleMessage")
Start()

return

HandleMessage(wParam, lParam) {
	GoSub, HandleMessage%wParam%
	return
	HandleMessage2:
	HandleMessage3:
		if !WinExist("ahk_id " . lParam)
			return
		WinGetClass, class
		if IsLabel(class) {
			GoSub, %class%
		}
		return
}

Start() {
	DetectHiddenWindows, On
	pid := DllCall("GetCurrentProcessId")
	SendMessage, 0x5555, 2, pid, , PokerPad.ahk ahk_class AutoHotkey
	SendMessage, 0x5555, 3, pid, , PokerPad.ahk ahk_class AutoHotkey
	DetectHiddenWindows, Off
}

;#Include Debug.ahk



FTC_TableViewFull:
	if FullTilt_GetSeat()
		SetTimer, FullTilt, -2000
	return
FullTilt:
	FullTilt_AutoReload()
	return

FullTilt_GetSeat() {
	global
	static GetChips := "FTCSkinButton42"
	if !IsControlVisible(GetChips)
		return false
	local device, context, pixels, x, y, w, h, id, r := false
	Critical, On
	Display_CreateWindowCapture(device, context, pixels)
	local c := "c" . context
	if FullTilt_IsRaceTrack()
		Loop, 13 {
			GetWindowArea(x, y, w, h, FullTilt_RT%A_Index%)
			if (Display_PixelSearch(x, y, w, h, "RedForeground", 0, c) && Display_PixelSearch(x, y - h*2, w, h*2, "LightForeground", 0, c)) {
				WinGet, id, ID
				ListAdd(Fulltilt, id . " RT" . A_Index)
				r := true
				break
			}
		}
	else
		Loop, 14 {
			GetWindowArea(x, y, w, h, FullTilt_%A_Index%)
			local bgr := Display_GetPixel(context, x, y - h * 2)
			if (Display_IsLight(bgr) && Display_PixelSearch(x, y, w, h, "RedForeground", 0, c)) {
				WinGet, id, ID
				ListAdd(Fulltilt, id . " " . A_Index)
				r := true
				break
			}
		}
	Display_DeleteWindowCapture(device, context, pixels)
	return r
}

FullTilt_AutoReload() {
	local array0, array1, array2
	Critical, On
	Loop, Parse, FullTilt, `,
	{
		StringSplit, array, A_LoopField, %A_Space%
		if (!WinExist("ahk_id " . array1) || FullTilt_Process(array2))
			ListRemove(FullTilt, A_LoopField)
	}
	if FullTilt
		SetTimer, FullTilt, -500
}


FullTilt_Process(ByRef seat) {
	local r := false, device, context, pixels, x, y, w, h
	Display_CreateWindowCapture(device, context, pixels)
	local c := "c" . context
	GetWindowArea(x, y, w, h, FullTilt_%seat%)
	WinGetPos, , , w
	local findText := w - 2 * ResizeBorder > 516
	w := Round(w * 33 / 472)
	local chips
	if InStr(seat, "RT", true) {
		y -= 2*h
		if (!Display_PixelSearch(x, y, w, 2*h, "LightForeground", 0, c) && Display_PixelSearch(x, y -= h * 2, w, 1, 0xFFFFFF, 0, c))
			GoSub, FullTilt_Process
	} else {
		y -= h * 2 + (findText ? (h - 2) * 2)
		local bgr := Display_GetPixel(context, x, y)
		if (!Display_IsLight(bgr) && Display_PixelSearch(x, y, w, 1, 0xFFFFFF, 0, c))
			GoSub, FullTilt_Process
	}
	if (chips != "") {
		if chips is not number
			chips := 0
		local t
		WinGetTitle, t
		t := InStr(t, "(deep") ? 2 : 1
		local limit := BigBlinds * t * FullTilt_GetBlind(true)
		if (chips < limit)
			FullTilt_Reload(Maximum || BigBlinds == 100	? -1 : limit - chips)
		r := true
	}
	Display_DeleteWindowCapture(device, context, pixels)
	return r
	
	FullTilt_Process:
		if findText {
			x -= h * 3
			local x2 := x + w
			local w2 := w
			Display_FindText(x2, y, w2, h, 0xFFFFFF, 0, context)
			w *= 2
			chips := CurrencyToFloat(Display_ReadArea(x, y, w, h, 0xFFFFFF, 0, c, 99))
		} else {
			w *= 2
			x -= h * 3
			h := 9
			local x1 := x + w, x2, xp
			Loop {
				x2 := x1
				Loop %w% {
					bgr := Display_GetPixel(context, x2--, y)
					if (bgr == 0xFFFFFF)
						break
				}
				if xp {
					if (xp - x2 > 2)
						break
				} else
					xp := x2
				y++
			}
			y -= h - 2
			chips := CurrencyToFloat(Display_ReadArea(x, y, w, h, 0xFFFFFF, 0, c, Round(h/2)))
		}
		return
}


#Include Includes/FullTilt.ahk

