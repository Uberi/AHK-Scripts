#NoEnv

Width := 760
Height := 490
Interval := 200

Gui, Font, s18 Bold, Arial
Gui, Add, Text, x172 y70 w390 h60 +Center, Move Mouse Within Window To Generate Random Numbers
Gui, Font, Norm
Gui, Add, Text, x172 y240 w260 h30 , Numbers Generated:
Gui, Add, Text, x432 y240 w130 h30 +Right vGeneratedNum, 0
Gui, Add, Button, x172 y310 w400 h50 gDOne Default, Done
Gui, +ToolWindow +LastFound
Gui, Show, w%Width% h%Height%, Random Numbers

;get position of client area within window
UPtr := A_PtrSize ? "UPtr" : "UInt"
VarSetCapacity(ClientPoint,8,0), DllCall("ClientToScreen",UPtr,WinExist(),UPtr,&ClientPoint)
WinGetPos, PosX, PosY
ClientX := NumGet(ClientPoint,0,"UInt") - PosX, ClientY := NumGet(ClientPoint,4,"UInt") - PosY

MouseGetPos, PosX1, PosY1
PosX1 -= ClientX, PosY1 -= ClientY
GeneratedNum := 0
SetTimer, Generate, %Interval%
Return

GuiClose:
ExitApp

Generate:
MouseGetPos, PosX, PosY
PosX -= ClientX, PosY -= ClientY ;change the position base to the upper left corner of the client area
If (PosX < 0 || PosY < 0 || PosX > Width || PosY > Height || (PosX = PosX1 && PosY = PosY1)) ;cursor is outside of window or has not moved
 Return
PosX1 := PosX, PosY1 := PosY

PosX /= Width, PosY /= Height ;get the ratios of the mouse position and the window size
Seed := Round(Mod(PosX + PosY,1) * 1000000) ;calculate integer seed for random number generator
Random,, %Seed% ;seed the random number generator with first coordinate element

SetFormat, IntegerFast, Hex
Random, Num, 0x0, 0xFF ;generate random number
RandomNumbers .= SubStr("0" . SubStr(Num,3),-1)
SetFormat, IntegerFast, D

GeneratedNum ++
GuiControl,, GeneratedNum, %GeneratedNum%
Return

Done:
Thread, NoTimers
MsgBox, 262212, Random Numbers, Generated %GeneratedNum% numbers:`n`n%RandomNumbers%`n`nCopy to Clipboard?
IfMsgBox, Yes
 Clipboard := RandomNumbers
Return