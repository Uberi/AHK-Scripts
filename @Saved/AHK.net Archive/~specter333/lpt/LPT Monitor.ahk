
#NoEnv 
SetWorkingDir %A_ScriptDir%  
#SingleInstance Force
;#Include LTPInOut.ahk

Gui, Add, GroupBox, xm ym w50 h40, In
Gui, Add, Text, x20 y25 w30 r1 vInMsg, Port 379

Gui, Add, GroupBox, x70 ym w100 h40, Pins
Gui, Add, Text, x80 y25 w80 vText1, 

Gui, Add, GroupBox, x180 ym w70 h40, Port
Gui, Add, Edit, x190 y20 w50 vPortNum, 0x379

Gui, Add, GroupBox, xm y50 w240 h150, Subroutine
Gui, Add, Edit, x20 y70 w220 r7 vsubr, 
Gui, Add, Button, x20 y170 w220 gsubr, Add Subroutine

Gui, Show, w260, LPT Port Monitor
SetTimer, Go, 100
Return

Go:
Gui, Submit, NoHide
B := LPTInOut_In(PortNum)

If B = %LastPort%
	Return

GuiControl, , InMsg, %B%

0 = S3 S4 S5 S6
8 = S4 S5 S6
16 = S3 S5 S6
24 = S5 S6
32 = S3 S4 S6
40 = S4 S6
48 = S3 S6
56 = S6
64 = S3 S4 S5
72 = S4 S5
80 = S3 S5
88 = S5
96 = S3 S4
104 = S4
112 = S3
120 = All Open
128 = S3 S4 S5 S6 S7
136 = S4 S5 S6 S7
144 = S3 S5 S6 S7
152 = S5 S6 S7
160 = S3 S4 S6 S7
168 = S4 S6 S7
176 = S3 S6 S7
184 = S6 S7
192 = S3 S4 S5 S7
200 = S4 S5 S7
208 = S3 S5 S7
216 = S5 S7
224 = S3 S4 S7
232 = S4 S7
240 = S3 S7
248 = S7

GuiControl, , Text1, % (%B%)
LastPort = %B%
LTPlabel = LPT_%B%
If IsLabel(LTPlabel)
	GoTo %LTPlabel%
GuiControl, , subr, %LTPlabel%:`n`nReturn
Return

GuiEscape:
Exit:
GuiClose:
Gui, Destroy
ExitApp
Return

subr:
Gui, Submit, NoHide
FileAppend , %subr% `n`n, LPT Monitor.ahk
Sleep, 250
Reload
Return



