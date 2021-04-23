#NoEnv
;increase friction when the width is higher
Gravity = 0.9
Restitution = 0.8
AirResistance = 0.02
Friction = 0.1
SpeedX = 0
SpeedY = 0
Width = 200
Height = 150
WindowX = % (A_ScreenWidth // 2) - (Width // 2)
WindowY = % (A_ScreenHeight // 2) - (Height //2)
JitterDetection = 1.1

Random, SpeedX, -50, 50
Random, SpeedY, -50, 50

SetWinDelay, 0

Gui, Font, S18 CWhite Bold, Arial
Gui, Add, Text, x0 y0 w%Width% h%Height% vInfo, `n   CPU: 0`%`n`n   Memory: 0`%

Gui, Color, 7777FF
Gui, -Caption +AlwaysOnTop +LastFound
WinSet, Region, 0-0 W%Width% H%Height% R40-40
Gui, Show, x%WindowX% y%WindowY% w%Width% h%Height%, Physics Window
WinGetPos, WinX, WinY, WinW, WinH
SetTimer, Step, 50
Loop
{
 CPU := Round(GetCPU())
 Mem := GetMem()
 GuiControl,, Info, `n   CPU: %CPU%`%`n`n   Memory: %Mem%`%
}
Return

Esc::
GuiClose:
ExitApp

Up::SpeedY -= 2
Down::SpeedY += 2
Left::SpeedX -= 2
Right::SpeedX += 2

Step:
Critical
Gui, +LastFound
;WinGetPos, WinX, WinY, WinW, WinH

SpeedX -= AirResistance * SpeedX, SpeedY -= AirResistance * SpeedY ;Calculate air resistance

LeftRightUsed := 0, UpDownUsed = 0

If (((WinX + SpeedX) <= 0) || ((WinX + WinW + SpeedX) >= A_ScreenWidth)) ;Collided with one side of boundary.
 SpeedX *= -1 * Restitution, LeftRightUsed := 1 ;Calculate bounce for X direction
If (((WinY + SpeedY) <= 0) || ((WinY + WinH + SpeedY) >= A_ScreenHeight)) ;Collided with bottom or top of boundary.
 SpeedY *= -1 * Restitution, UpDownUsed := 1 ;Calculate bounce for Y direction

If (LeftRightUsed && SpeedX = 0) ;Sliding vertically along a side boundary
 SpeedY -= SpeedY * Friction * (WinH / 100) ;Calculate sliding friction for Y direction
If (UpDownUsed && SpeedY = 0) ;Sliding horizontally along either the top or bottom boundary
 SpeedX -= SpeedX * Friction * (WinW / 100) ;Calculate sliding friction for X direction

SpeedY += Gravity ;Calculate gravity

If SpeedX Between -0.05 And 0.05 ;Very slow sliding along X direction
 SpeedX = 0 ;Stop X direction sliding

If (LeftRightUsed && SpeedX >= -0.5 && SpeedX <= 0.5) ;Prevent jitter when bouncing off of sides
 SpeedX = 0 ;Stop X direction sliding
If (UpDownUsed && SpeedY >= Gravity * JitterDetection * -1 && SpeedY <= Gravity * JitterDetection) ;Prevent gravity jitter when bouncing off of the bottom or top of the boundary
 SpeedY = 0 ;Stop Y direction sliding

If (UpDownUsed && SpeedX = 0 && SpeedY = 0) ;Sleeping state
 Return

;ToolTip %LeftRightUsed% %UpDownUsed%
;ToolTip, Speed X: %SpeedX%`nSpeed Y: %SpeedY%`n%Temp1%

WinX += SpeedX, WinY += SpeedY ;Calculate final position
WinMove, %WinX%, %WinY%
Return

~LButton::
Gui, +LastFound
IfWinNotActive
 Return
CoordMode, Mouse, Relative
MouseGetPos, OffsetX, OffsetY, CurrentWin
CoordMode, Mouse
SetTimer, Step, Off
SetTimer, MoveWin, 50
Return

MoveWin:
MouseGetPos, MouseX, MouseY
If Not GetKeyState("LButton")
{
 SpeedX := MouseX - OffsetX
 SpeedY := MouseY - OffsetY
 SetTimer, MoveWin, Off
 SetTimer, Step, On
 Return
}
WinGetPos, WinX, WinY, WinW, WinH, ahk_id %CurrentWin%
WinX -= OffsetX - MouseX
WinY -= OffsetY - MouseY
If (WinX >= 0 && WinY >= 0 && (WinX + WinW) <= A_ScreenWidth && (WinY + WinH) <= A_ScreenHeight)
 WinMove, ahk_id %CurrentWin%,, WinX, WinY
Return

GetCPU()
{
 Period = 1000
 VarSetCapacity(Idle1,8)
 If Not DllCall("kernel32.dll\GetSystemTimes", "uint", &Idle1, "uint", 0, "uint", 0)
  Return
 SetFormat, Integer, H
 Value = 0
 Loop, 8
  Value += (*(&Idle1 + (A_Index - 1)) << (8 * (A_Index - 1)))
 SetFormat, Integer, D
 Idle1 = %Value%
 TickTime = %A_TickCount%
 Sleep, %Period%
 TickTime := A_TickCount - TickTime
 VarSetCapacity(Idle2,8)
 If Not DllCall("kernel32.dll\GetSystemTimes", "uint", &Idle2, "uint", 0, "uint", 0)
  Return
 SetFormat, Integer, H
 Value = 0
 Loop, 8
  Value += (*(&Idle2 + (A_Index - 1)) << (8 * (A_Index - 1)))
 SetFormat, Integer, D
 Idle2 = %Value%
 TotalIdle := (Idle2 - Idle1) * 0.0001
 CPU := 100 - (TotalIdle / TickTime * 100)
 Return, CPU
}

GetMem()
{
 global MemoryStatus
 VarSetCapacity(memorystatus,100)
 DllCall("kernel32.dll\GlobalMemoryStatus", "uint",&memorystatus)
 Mem := *( &memorystatus + 4 )
 Return, Mem
}