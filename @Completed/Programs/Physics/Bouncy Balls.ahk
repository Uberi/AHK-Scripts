NumBalls = 5
Spring = 0.5
Gravity = 0.5 ;0.9
Friction = 0.03
Restitution = 0.8

Color1 = Red
Color2 = FF8800
Color3 = Yellow
Color4 = Lime
Color5 = Blue
Color6 = Purple

Balls1X := 100, Balls1Y := 100, Balls1SpeedX := 0, Balls1SpeedY := 0
Balls2X := 250, Balls2Y := 100, Balls2SpeedX := 0, Balls2SpeedY := 0
Balls3X := 100, Balls3Y := 250, Balls3SpeedX := 0, Balls3SpeedY := 0
Balls4X := 250, Balls4Y := 250, Balls4SpeedX := 0, Balls4SpeedY := 0
Balls5X := 550, Balls5Y := 550, Balls5SpeedX := -70, Balls5SpeedY := -70

Message3 = Happy
Message1 = Birthday
Message4 = Dad!
Message2 = -Anthony

Width = 1024 ;%A_ScreenWidth%
Height = 768 ;%A_ScreenHeight%
SetWinDelay, 0
CoordMode, Mouse
Loop, %NumBalls%
{
 ;Random, Balls%A_Index%X, 0, Width
 ;Random, Balls%A_Index%Y, 0, Height - 200
 ;Random, Diameter, 100, 200
 Diameter = 170 ;140
 Balls%A_Index%Diameter = %Diameter%
 
 If A_Index = 5
 {
  Gui, %A_Index%:Font, s16 Bold cWhite, Arial
  Gui, %A_Index%:Add, Text, x30 y40 w110 h30 Center, Drag Me
  Gui, %A_Index%:Font, s12 Norm, Arial
  Gui, %A_Index%:Add, Button, x20 y70 w130 h30 gRestart, Click to restart
  Gui, %A_Index%:Font, s8 Bold, Arial
  Gui, %A_Index%:Add, Button, x50 y110 w70 h20 gExitSub, Exit
 }
 Else
 {
  Gui, %A_Index%:Font, s24 Bold cWhite, Arial
  Gui, %A_Index%:Add, Text, x10 y60 w150 h40 Center, % Message%A_Index%
 }
 Gui, %A_Index%:Color, % Color%A_Index%
 Gui, %A_Index%:+LastFound +ToolWindow -Caption +AlwaysOnTop
 WinSet, Region, 0-0 w%Diameter% h%Diameter% E
 Gui, %A_Index%:Show, x-500 y-500 w%Diameter% h%Diameter% NoActivate, Ball%A_Index%
}
Gosub, Step
Gui, 99:Font, s36 cWhite Bold, Arial
Gui, 99:Add, Text, x10 y10 w420 h60 Center gStart, Click here to start
Gui, 99:Color, Black
Gui, 99:+AlwaysOnTop +ToolWindow -Caption +LastFound
Gui, 99:Show, Hide
WinSet, Region, 0-0 w450 h75 r20-20
Gui, 99:Show, w450 h75, Ball99
Return

Start:
Gui, 99:Destroy
Loop
{
 If Not Dragging
  Gosub, Step
 Sleep, 10
}
Return

Restart:
Reload
ExitApp

ExitSub:
ExitApp

~LButton::
MouseGetPos, OffsetX, OffsetY, Temp1
WinGetClass, Temp2, ahk_id %Temp1%
If Temp2 <> AutoHotkeyGUI
 Return
WinGetTitle, TempIndex, ahk_id %Temp1%
TempIndex := SubStr(TempIndex,5)
If TempIndex = 99
 Return
Gui, %TempIndex%:+LastFound
WinGetPos, TempX, TempY
OffsetX -= TempX, OffsetY -= TempY
Dragging = 1
While, GetKeyState("LButton","P")
{
 MouseGetPos, Temp2, Temp3
 WinMove, Temp2 - OffsetX, Temp3 - OffsetY
 TempTime := A_Index
 Sleep, 50
}
WinGetPos, Temp1, Temp2
;MsgBox % (Temp1 - TempX) / TempTime . " " . (Temp2 - TempY) / TempTime
Balls%TempIndex%SpeedX := (Temp1 - TempX) / TempTime, Balls%TempIndex%SpeedY := (Temp2 - TempY) / TempTime
Balls%TempIndex%X := Temp1, Balls%TempIndex%Y := Temp2
Dragging = 0
Return

Step:
Loop, %NumBalls%
{
 TempX := Balls%A_Index%X, TempY := Balls%A_Index%Y
 TempDiameter := Balls%A_Index%Diameter
 Collide(A_Index,TempX,TempY,Balls%A_Index%SpeedX,Balls%A_Index%SpeedY,TempDiameter)
 MoveBall(A_Index,TempX,TempY,Balls%A_Index%SpeedX,Balls%A_Index%SpeedY,TempDiameter)
 Gui, %A_Index%:+LastFound
 WinMove, TempX, TempY
 Balls%A_Index%X := TempX, Balls%A_Index%Y := TempY
}
Return

Collide(BallNum,ByRef PosX,ByRef PosY,ByRef SpeedX,ByRef SpeedY,ByRef Diameter)
{
 local Temp1
 local Temp2
 local TempX
 local TempY
 local dx
 local dy
 local Distance
 local MinDistance
 local Angle
 local ax
 local ay
 Loop, %NumBalls%
 {
  If A_Index = %BallNum%
   Continue
  Temp1 := Balls%A_Index%Diameter, Temp2 := (Temp1 - Diameter) / 2, TempX := Balls%A_Index%X + Temp2, TempY := Balls%A_Index%Y + Temp2, dx := TempX - PosX, dy := TempY - PosY, Distance := Sqrt((dx ** 2) + (dy ** 2)), MinDistance := (Temp1 / 2) + (Diameter / 2)
  If Distance < %MinDistance%
   Angle := (dx < 0 && dy = 0) ? 3.141597 : 2 * ATan(dy / (dx + Distance)), ax := ((PosX + (Cos(Angle) * MinDistance)) - TempX) * Spring, ay := ((PosY + (Sin(Angle) * MinDistance)) - TempY) * Spring, SpeedX -= ax, SpeedY -= ay, Balls%A_Index%SpeedX += ax, Balls%A_Index%SpeedY += ay
 }
}

MoveBall(BallNum,ByRef PosX,ByRef PosY,ByRef SpeedX,ByRef SpeedY,ByRef Diameter)
{
 global Gravity
 global Friction
 global Restitution
 global Width
 global Height
 If ((PosX + Diameter) > Width)
  PosX := Width - Diameter, SpeedX *= -1 * Restitution
 Else If PosX < 0
  PosX := 0, SpeedX *= -1 * Restitution
 If ((PosY + Diameter) > Height)
  PosY := Height - Diameter, SpeedY *= -1 * Restitution
 Else If PosY < 0
  PosY := 0, SpeedY *= -1 * Restitution
 SpeedY += Gravity, SpeedX *= 1 - Friction, SpeedY *= 1 - Friction, PosX += SpeedX, PosY += SpeedY
}