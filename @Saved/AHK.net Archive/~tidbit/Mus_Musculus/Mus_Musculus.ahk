/*
Name: Mus Musculus
created: Sat September 11, 2010
Version: 1.6 (Wed August 01, 2011)
Author: tidbit
Description:
Keeps track of how many inches, feet, miles and pixels you have moved your cursor.
It also keeps track of speed in Inches Per Second and Miles Per Hour.

The Close button on th GUI minimizes the widow to the tray. You can right-click the tray to show it again.
You can also save the current data into a .txt file. It will be saved into the script Directory.
*/

#LTrim Off
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#singleInstance force

SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

Process, Priority,, Low
RegRead, DPI, HKCU, Control Panel\Desktop\WindowMetrics, AppliedDPI
; if you know your actual DPI (registry isn't always accurate)
; change it here. uncomment the line below.
; DPI:=141

SetFormat, float, 0.3
CoordMode, Mouse, Screen
OnExit, exitlabel

; initiate some default values
sfile=%A_ScriptDir%\Mouse_Distance_Log.txt
time:=50
pixels:=0
feet:=0
miles:=0
fastestins:=0
fastestkmh:=0
fastestmph:=0

gosub, load

if (latest=="")
{
	latest:=1
	gosub, log
}

; gui, font,, Courier New
Menu, tray, NoStandard
Menu, tray, add, Show, showGUI
Menu, tray, add, Save, log
Menu, tray, add, Folder, folder
Menu, tray, add,
Menu, tray, add, Reset, reset
Menu, tray, add, Exit, exitlabel
Menu, tray, Default, Show

Gui, +Owner -MinimizeBox +Resize
Gui, add, edit,   x6  y6  w300 h70 vedit +readonly ,
Gui, add, button, x+3 y6       h70 vbtn1 glog, Save
Gui, add, button, x+2 yp  w64  h34 vbtn2 gaddSection, New Set
Gui, add, button, xp  y+2 w64  h34 vbtn3 greset, reset
Gui, show, NA x0 y0, Algernon (set %latest%)
mousegetpos, ex, ey

; the majic begins here
gosub, dist
return


guisize:
	anchor("edit", "w h")
	anchor("btn1", "x")
	anchor("btn2", "x")
	anchor("btn3", "x")
Return


load:
	FileRead, latest, %sfile%
	latest:=max(RegExReplace(agrep(latest, "\[(\d+)\]"), "[\[\]]", ""))

	FormatTime, datetime,, dddd dd`, yyyy. HH:mm
	
	IniRead, StartDate, %sfile% , %latest%, start, %datetime%

	IniRead, DistStats, %sfile% , %latest%, totals, Pixels: 0`, Inches: 0`, Feet: 0`, Miles: 0
	RegExMatch(DistStats, "i)Pixels: (\d+), Inches: ([0-9\.]+), Feet: (\d+), Miles: (\d+)", distance)
	IniRead, SpeedStats, %sfile% , %latest%, fastest, 0 KM/H.`, 0 MP/H
	RegExMatch(SpeedStats, "i)([0-9\.]+) KM/H.,\s+([0-9\.]+) MP/H", speed)

	tot_distancePixels+=distance1
	tot_distance+=distance2
	feet:=distance3
	miles:=distance4
	fastestkmh:=speed1
	fastestmph:=speed2
Return


addSection:
	latest+=1
	gosub, Log
	Gui, show, NoActivate AutoSize, Algernon (set %latest%)
Return


log:
	FormatTime, datetime,, dddd dd`, yyyy. HH:mm
	if (StartDate=="")
		StartDate:=datetime
	IniWrite, %StartDate%, %sfile%, %latest%, start
	IniWrite, %datetime%, %sfile%, %latest%, end
	IniWrite, Pixels: %tot_distancePixels%`, Inches: %tot_distance%`, Feet: %feet%`, Miles: %miles%, %sfile%, %latest%, Totals
	IniWrite, Fastest: %fastestkmh% KM/H.`, %fastestmph% MP/H, %sfile%, %latest%, Fastest
return


reset:
	MsgBox, 36, Overwrite?, This will set all data in section %latest% to 0 (zero). Is this okay?
	IfMsgBox, No
		Return
		
	FormatTime, datetime,, dddd dd`, yyyy. HH:mm
	StartDate:=datetime
	EndDate:=datetime
	tot_distancePixels:=0
	tot_distance:=0
	feet:=0
	miles:=0
	fastestins:=0
	fastestmph:=0
	fastestkmh:=0
	
	IniWrite, %StartDate%, %sfile%, %latest%, start
	IniWrite, %EndDate%, %sfile%, %latest%, end
	IniWrite, Pixels: %tot_distancePixels%`, Inches: %tot_distance%`, Feet: %feet%`, Miles: %miles%, %sfile%, %latest%, Totals
	IniWrite, Fastest: %fastestkmh% KM/H.`, %fastestmph% MP/H, %sfile%, %latest%, Fastest
Return


dist:
	Loop
	{
		mousegetpos, sx, sy
		distancePixels:=ceil(abs(sqrt((ex-sx)**2+(ey-sy)**2)))
		distance:=abs(sqrt((ex-sx)**2+(ey-sy)**2))/DPI
		
	; ToolTip a %a_index% | %distancePixels% | %distance% | %sx% %sy%
		if (distancePixels>10000 || distance>500)
			Continue
			
		mousegetpos, ex, ey
		tot_distancePixels+=distancePixels
		tot_distance+=distance
		
		velocity:=(distance/time)*(time*(1000/time)) ; compensate for the delay (time)
		mph:=velocity*0.05681
		kmh:=velocity*0.09144
		
		if (velocity>fastestins)
			fastestins:=velocity
		if (mph>fastestmph)
			fastestmph:=mph
		if (kmh>fastestkmh)
			fastestkmh:=kmh

		
		while (tot_distance>=12)
		{
	; ToolTip b %a_index% | %distancePixels% | %distance% | %tot_distance% | %feet% x %inches%
			tot_distance-=12
			feet+=1
			
			if (feet>=5280)
			{
				feet-=5280
				miles+=1
			}
		}

		text=
		(
Current: %distance% Inches (%distancePixels% Pixels)
Totals: Pixels: %tot_distancePixels%, Inches: %tot_distance%, Feet: %feet%, Miles: %miles%
Speed:   %kmh% KM/H (%MPH% MP/H)
Fastest: %fastestkmh% KM/H., %fastestmph% MP/H
		)
		GuiControl, , edit, %text%
		
		sleep, %time%
	}
return


GuiClose:
	Gui, hide
return

showGUI:
	Gui, show, NoActivate AutoSize, Algernon (set %latest%)
return

exitlabel:
	gosub, Log
	ExitApp
Return

folder:
	run %A_ScriptDir%
Return


; --------- FUNCTIONS
; -------------------
agrep(ByRef _haystack="", _pattern="", _ignoreCase=false, _invert=false, _lineMatch=false, _replace="")
{
    Return SubStr( RegExReplace(_haystack . "`n", (_ignoreCase ? "i" : "") . "`am)(*BSR_ANYCRLF)(?" . (_invert ? "=" : "!") . "(?:" . (_lineMatch ? "^" . _pattern . "$" : ".*?" . _pattern . ".*?") . "))^.*?\R", _replace, ErrorLevel), 1, -1)
}


max(list, delim="`n", exdelim="`r")
{
	loop, Parse, list, %delim%, %exdelim%
		if (A_LoopField>maxnum)
			maxnum:=A_LoopField
	Return maxnum

}



Anchor(i, a = "", r = false) {
	static c, cs = 12, cx = 255, cl = 0, g, gs = 8, gl = 0, gpi, gw, gh, z = 0, k = 0xffff
	If z = 0
		VarSetCapacity(g, gs * 99, 0), VarSetCapacity(c, cs * cx, 0), z := true
	If (!WinExist("ahk_id" . i)) {
		GuiControlGet, t, Hwnd, %i%
		If ErrorLevel = 0
			i := t
		Else ControlGet, i, Hwnd, , %i%
	}
	VarSetCapacity(gi, 68, 0), DllCall("GetWindowInfo", "UInt", gp := DllCall("GetParent", "UInt", i), "UInt", &gi)
		, giw := NumGet(gi, 28, "Int") - NumGet(gi, 20, "Int"), gih := NumGet(gi, 32, "Int") - NumGet(gi, 24, "Int")
	If (gp != gpi) {
		gpi := gp
		Loop, %gl%
			If (NumGet(g, cb := gs * (A_Index - 1)) == gp) {
				gw := NumGet(g, cb + 4, "Short"), gh := NumGet(g, cb + 6, "Short"), gf := 1
				Break
			}
		If (!gf)
			NumPut(gp, g, gl), NumPut(gw := giw, g, gl + 4, "Short"), NumPut(gh := gih, g, gl + 6, "Short"), gl += gs
	}
	ControlGetPos, dx, dy, dw, dh, , ahk_id %i%
	Loop, %cl%
		If (NumGet(c, cb := cs * (A_Index - 1)) == i) {
			If a =
			{
				cf = 1
				Break
			}
			giw -= gw, gih -= gh, as := 1, dx := NumGet(c, cb + 4, "Short"), dy := NumGet(c, cb + 6, "Short")
				, cw := dw, dw := NumGet(c, cb + 8, "Short"), ch := dh, dh := NumGet(c, cb + 10, "Short")
			Loop, Parse, a, xywh
				If A_Index > 1
					av := SubStr(a, as, 1), as += 1 + StrLen(A_LoopField)
						, d%av% += (InStr("yh", av) ? gih : giw) * (A_LoopField + 0 ? A_LoopField : 1)
			DllCall("SetWindowPos", "UInt", i, "Int", 0, "Int", dx, "Int", dy
				, "Int", InStr(a, "w") ? dw : cw, "Int", InStr(a, "h") ? dh : ch, "Int", 4)
			If r != 0
				DllCall("RedrawWindow", "UInt", i, "UInt", 0, "UInt", 0, "UInt", 0x0101) ; RDW_UPDATENOW | RDW_INVALIDATE
			Return
		}
	If cf != 1
		cb := cl, cl += cs
	bx := NumGet(gi, 48), by := NumGet(gi, 16, "Int") - NumGet(gi, 8, "Int") - gih - NumGet(gi, 52)
	If cf = 1
		dw -= giw - gw, dh -= gih - gh
	NumPut(i, c, cb), NumPut(dx - bx, c, cb + 4, "Short"), NumPut(dy - by, c, cb + 6, "Short")
		, NumPut(dw, c, cb + 8, "Short"), NumPut(dh, c, cb + 10, "Short")
	Return, true
}
; esc::ExitApp
