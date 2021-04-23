/*  FullTiltTableRotator: 
 *  	Rotates multiple tables based on those requiring attention.
 *  
 *  License:
 *  	v0.0.1 by Xander
 *  	GNU General Public License 3.0 or higher: http://www.gnu.org/licenses/gpl-3.0.txt
 */

#NoEnv
#SingleInstance Force
#NoTrayIcon

CreateLayout()
SetTimer, CheckTables, 1000

return


^!R:: Reset()
Reset() {
	local id
	Critical, On
	if MainID {
		Slots_%MainID% =
		MainID = 
	}
	Loop, %Slots% {
		id := Slots%A_Index%
		Slots_%id% =
	}
	Slots := 0
	CheckTables()
	Critical, Off
}

GetMainID() {
	global
	return MainID ? MainID : 0
}


Create2MonitorLayout(slots) {
	local area, areaTop, areaBottom, areaLeft, areaRight, caption, border
	SysGet, area, MonitorWorkArea
	local area2, area2Top, area2Bottom, area2Left, area2Right
	SysGet, area2, MonitorWorkArea, 2
	SysGet, caption, 4
	SysGet, border, 32
	border *= 2
	MainWidth := area2Right - area2Left
	MainHeight := area2Bottom - area2Top
	MainX := area2Left
	MainY := area2Top
	Width := areaRight - areaLeft
	Height := areaBottom - areaTop
	local xSlots, ySlots
	if (slots < 5) {
		xSlots := 2
		ySlots := 2
	} else if (slots < 7) {
		xSlots := 3
		ySlots := 2
	} else if (slots < 10) {
		xSlots := 3
		ySlots := 3
	} else if (slots < 13) {
		xSlots := 4
		ySlots := 3
	} else {
		xSlots := 4
		ySlots := 4
	}
	Width := Floor(Width/xSlots)
	Height := Floor(Height/ySlots)
	local w := Width + border
	local dw := w < 472 ? 472 - w : 0
	local h := Round((Width+w - border) * 547 / 794) + border + caption
	local dh := h > Height ? h - Height : 0
	local slot := 0
	Loop, %ySlots% {
		local i := A_Index - 1
		local y := areaTop + Height * i
		if dh && i
			y -= Floor(dh * i / (A_Index == ySlots ?  1 : 2))
		Loop, %xSlots% {
			slot++
			i := A_Index - 1/
			X%slot% := areaLeft + Width * i
			if dw && i
				X%slot% -= Floor(dw * i / (A_Index == xSlots ?  1 : 2))
			Y%slot% := y
		}
	}
	Width := w
	Height := h
	Slots := 0
	MainID =
}


CreateLayout() {
	local area, areaTop, areaBottom, areaLeft, areaRight, caption, border
	SysGet, area, MonitorWorkArea
	SysGet, caption, 4
	SysGet, border, 32
	border *= 2
	MainWidth := areaRight - areaLeft
	MainHeight := areaBottom - areaTop
	Width := Floor(MainWidth / 3)
	Height := Floor(MainHeight / 3)
	MainWidth -= Width
	MainHeight -= Height
	MainX := Width
	MainY := Height
	X3 := areaLeft
	Y3 := areaTop
	X4 := areaLeft + Width
	Y4 := areaTop
	X5 := areaLeft + Width * 2
	Y5 := areaTop
	X2 := areaLeft
	Y2 := areaTop + Height
	X1 := areaLeft
	Y1 := areaTop + Height * 2
	Slots := 0
	local w := 472 - Width + border
	if (w > 0) {
		MainWidth -= w
		MainX += w
		X4 -= Round(w / 2)
		X5 -= w
		Width := 472 + border
	}
	local h := Round((Width - border) * 547 / 794) + border + caption
	if (h > Height) {
		Y1 -= (h - Height)
		Y2 -= Round((h - Height) / 2)
	}
	Height := h
	h := Round((MainWidth - border) * 547 / 794) + border + caption
	MainY += MainHeight - h
	MainHeight := h
	MainID =
}


CheckTables:
	CheckTables()
	return
CheckTables() {
	local visible, toMiniID
	if MainID { ; Check if main window should be rotated
		ControlGet, visible, Visible, , FTCSkinButton11, ahk_id %MainID%
		if visible
			return
		toMiniID := MainID
		MainID =
	}
	local tables, id, minTime := 0, time
	WinGet tables, List, ahk_class FTC_TableViewFull
	Loop, %tables% {
		id := tables%A_Index%
		time := Time%id%
		ControlGet, visible, Visible, , FTCSkinButton11, ahk_id %id%
		if visible { ; obtain the table that has been waiting action the longest
			if !time
				time := Time%id% := A_TickCount
			if (!minTime || time < minTime) {
				minTime := time
				MainID := id
			}
		} else {
			if time
				Time%id% := 0
		}
		if !Slots_%id% { ; check if table has been placed in a slot
			local s := 0
			if (toMiniID && !WinExist("ahk_id " . toMiniID)) {
				Slots_%id% :=  6
				toMiniID := id
				WinMove, ahk_id %id%, , MainX, MainY, MainWidth, MainHeight
			} else {
				if Slots {
					Loop, %Slots% { ; scan slots for a closed table
						if !WinExist("ahk_id " . Slots%A_Index%) {
							s := A_Index
							break
						}
					}
				}
				if !s ; no empty slot found, append to end
					s := ++Slots
				Slots_%id% := s
				Slots%s% := id
				WinMove, ahk_id %id%, , X%s%, Y%s%, Width, Height
			}
		}
	}
	if !MainID { ; did not find a table waiting action
		if !toMiniID { ; a table is not in the main slot
			if Slots { ; so put the table at the end of the slot stack there if exists
				MainID := Slots%Slots%
				Slots_%Slots% =
				Slots--
				WinMove, ahk_id %MainID%, , MainX, MainY, MainWidth, MainHeight
			}
		} else
			MainID := toMiniID
	} else {
		; move the new main window first, so that it is visible from where the table came from
		WinMove, ahk_id %MainID%, , MainX, MainY, MainWidth, MainHeight
		WinActivate, ahk_id %MainID%
		; put a sleep call here if you want this visualization effect to be more prominent
		if toMiniID { ; move current table at main slot to slot where the table to be in the main slot was located
			local toSlot := Slots_%MainID%
			Slots%toSlot% := toMiniID
			Slots_%toMiniID% := toSlot
			WinMove, ahk_id %toMiniID%, , X%toSlot%, Y%toSlot%, Width, Height
		}
	}
}





