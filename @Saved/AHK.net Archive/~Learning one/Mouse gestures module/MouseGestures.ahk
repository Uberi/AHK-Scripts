/*==Description=========================================================================

[module] Mouse gestures
Author:		Learning one (Boris Mudrini?)
Contact:	boris-mudrinic@net.hr
AHK forum:	http://www.autohotkey.com/forum/topic56472.html


License:
Redistribution and use (both commercial and non-commercial) in source and binary forms, are permitted free of charge if
you give a credit to the author in a documentation or "About MsgBox". Author is not responsible for any damages arising
from use or redistribution of his work. If redistributed in source form, you are not allowed to remove comments from this file.


Documentation.
Mouse gestures are specific mouse movements which can be recognized by this module. 
Gestures recognition system recognizes 4 basic mouse movements; up, down, right, left.
Abbreviations for those movements are U (up), D (down) , R (right), and L (left).
Minimal mouse movement distance which this module recognizes as movement is 9 pixels.

To recognize mouse gesture, you have to call MG_Recognize() function. By performing mouse gesture you can:
1) 	execute appropriate function that has "MG_" prefix (default) or some other specified prefix.
	Syntaxs: "MG_" means mouse gesture. "U" means up, "D" down, "R" right, "L" left.
	So, for example, if function MG_R() exists in your script, it will be executed when you perform "drag right gesture"
	MG_RU() will be executed when you perform "drag right up gesture", MG_UDU() - "drag up down up gesture", etc.
2) 	store performed gesture in variable. Example: Gesture := MG_Recognize()

MG_Recognize(FuncPrefix="", MGHotkey="", ToolTip=0, MaxMoves=3, ExecuteMGFunction=1, SendIfNoDrag=1)
All parameters are optional and are very rarely used. In majority of cases you will not need them - just call "MG_Recognize()"
- 	FuncPrefix	prefix of function to execute. If empty, "MG_" prefix applies.
-	MGHotkey 	mouse gesture hotkey. Can be: 1) any mouse button that can be pressed down and 2) any keyboard key
				except alt, control, shift (modifiers). If empty, MGHotkey is set to refined last pressed hotkey 
-	ToolTip 	1 means show gesture in tooltip while performing it, 0 means don't show it.
-	MaxMoves	maximum number of moves (directions) in one gesture. If you perform more moves than specified,
				gesture will be cancelled.
-	ExecuteMGFunction	1 means execute existing %FuncPrefix%<gesture> function. 0 means don't execute it.
-	SendIfNoDrag		1 means send MGHotkey click (press) if drag was under 9 pixels. 0 Means don't send it.

MG_Recognize() return values:
- blank	if gesture is cancelled
- 0 if you dragged MGHotkey for less than 9 pixels
- <performed gesture> for example; R, D, LD, LUL, URL, etc.

If SendIfNoDrag = 1 (default), normal MGHotkey's click function is preserved; just click and don't drag and module will
send normal click. There are no built-in actions on gestures. It's up to you to write your commands that fit your needs.
You can find more informations about this type of mouse gestures in Radial menu help file. You will find Radial menu here:
http://www.autohotkey.com/forum/viewtopic.php?p=308352#308352
*/


;===Example scripts=====================================================================

/*;===Example 1=== 		; just one key for mouse gestures
MButton::MG_Recognize()	; recognizes performed mouse gesture and executes appropriate function

MG_R() {	; mouse gesture: Right
	MsgBox,,, %A_ThisFunc%, 1	; specify your action here
}

MG_RD() {	; mouse gesture: Right, Down
	MsgBox,,, %A_ThisFunc%, 1	; specify your action here
}

MG_RDL() {	; mouse gesture: Right, Down, Left
	MsgBox,,, %A_ThisFunc%, 1	; specify your action here
}
; etc.
*/


/*;===Example 2=== 		; multiple keys for mouse gestures
MButton::MG_Recognize("MG_MButton_")
RButton::MG_Recognize("MG_RButton_")
F1::MG_Recognize("MG_F1_")
F2::MG_Recognize("MG_F2_")
; etc.


;=MButton gestures=
MG_MButton_R() {	; mouse gesture: MButton; Right
	MsgBox,,, %A_ThisFunc%, 1	; specify your action here
}
MG_MButton_L() {	; mouse gesture: MButton; Left
	MsgBox,,, %A_ThisFunc%, 1	; specify your action here
}
; etc.


;=RButton gestures=
MG_RButton_R() {	; mouse gesture: RButton; Right
	MsgBox,,, %A_ThisFunc%, 1	; specify your action here
}
MG_RButton_L() {	; mouse gesture: RButton; Left
	MsgBox,,, %A_ThisFunc%, 1	; specify your action here
}
; etc.


;=F1 gestures=
MG_F1_R() {	; mouse gesture: F1; Right
	MsgBox,,, %A_ThisFunc%, 1	; specify your action here
}
MG_F1_L() {	; mouse gesture: F1; Left
	MsgBox,,, %A_ThisFunc%, 1	; specify your action here
}
; etc.


;=F2 gestures=
MG_F2_R() {	; mouse gesture: F2; Right
	MsgBox,,, %A_ThisFunc%, 1	; specify your action here
}
MG_F2_L() {	; mouse gesture: F2; Left
	MsgBox,,, %A_ThisFunc%, 1	; specify your action here
}
; etc.
*/


/*;===Example 3=== 	; just return performed gesture
MButton::MsgBox,,, % MG_Recognize(),1
RButton::MsgBox,,, % MG_Recognize(),1
F1::MsgBox,,, % MG_Recognize(),1
F2::MsgBox,,, % MG_Recognize(),1
*/
 

;===Functions===========================================================================
MG_Version() {
	return 1.01
}

MG_GetMove(Angle) {
	Loop, 4
    {
		if (Angle <= 90*A_Index-45)
		{
			Sector := A_Index
			Break
		}
		Else if (A_Index = 4)
		Sector = 1
    }
	
	if Sector = 1
	Return "U"
	else if Sector = 2
	Return "R"
	else if Sector = 3
	Return "D"
	else if Sector = 4
	Return "L"
}

MG_GetAngle(StartX, StartY, EndX, EndY) {
    x := EndX-StartX, y := EndY-StartY
    if x = 0
    {
        if y > 0
        return 180
        Else if y < 0
        return 360
        Else
        return
    }
    deg := ATan(y/x)*57.295779513
    if x > 0
    return deg + 90
    Else
    return deg + 270	
}

MG_GetRadius(StartX, StartY, EndX, EndY) {
	a := Abs(endX-startX), b := Abs(endY-startY), Radius := Sqrt(a*a+b*b)
    Return Radius    
}

MG_Recognize(FuncPrefix="", MGHotkey="", ToolTip=0, MaxMoves=3, ExecuteMGFunction=1, SendIfNoDrag=1) {
	CoordMode, mouse, Screen
	MouseGetPos, mx1, my1
	if (MGHotkey = "")
	MGHotkey := RegExReplace(A_ThisHotkey,"^(\w* & |\W*)")
	if (FuncPrefix = "") 
	FuncPrefix = MG_
	Loop
	{
		if !(GetKeyState(MGHotkey, "p"))
		{
			if ToolTip = 1
			ToolTip
			if Gesture =
			{
				if SendIfNoDrag = 1
				{
					Suspend, on
					SendInput, {%MGHotkey%}
					Suspend, off
				}
				Return 0
			}
			if (IsFunc(FuncPrefix Gesture) <> 0 and ExecuteMGFunction = 1)
			%FuncPrefix%%Gesture%()
			Return Gesture
		}
		Sleep, 20
		MouseGetPos, EndX, EndY
		Radius := MG_GetRadius(mx1, my1, EndX, EndY)
		if (Radius < 9)
		Continue
		
		Angle := MG_GetAngle(mx1, my1, EndX, EndY)
		MouseGetPos, mx1, my1
		CurMove := MG_GetMove(Angle)
		
		if !(CurMove = LastMove)
		{
			Gesture .= CurMove
			LastMove := CurMove
			{
				if (StrLen(Gesture) > MaxMoves)  
				{
					if ToolTip = 1
					ToolTip
					Progress, m2 b fs10 zh0 w80 WMn700, Gesture cancelled
					Sleep, 200
					KeyWait, %MGHotkey%
					Progress, off
					Return
				}
			}
		}
		if ToolTip = 1
		ToolTip, %Gesture%
	}
}