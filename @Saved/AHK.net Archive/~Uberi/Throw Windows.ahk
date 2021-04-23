#NoEnv

#Persistent

Gravity = 0.9
Restitution = 0.8
AirResistance = 0.02
Friction = 0.1
SpeedX = 0
SpeedY = 0
JitterDetection = 1.5

SetWinDelay, 0
SetTimer, RefreshList, 1000
SetTimer, StepAll, 60

RefreshList:
RefreshWindowList()
Return

Esc::ExitApp

StepAll:
Loop, Parse, WindowList, `n, `r
{
 Temp1 := SubStr(A_LoopField,1,InStr(A_LoopField,"|") - 1)
 GetSpeed(Temp1,TempSpeedX,TempSpeedY)
 If (TempSpeedX = "" || TempSpeedY = "")
 {
  Random, TempSpeedX, -50, 50
  Random, TempSpeedY, -50, 50
 }
 If Not Step(A_LoopField,TempSpeedX,TempSpeedY)
  SetSpeed(Temp1,TempSpeedX,TempSpeedY)
}
Return

GetSpeed(WindowID,ByRef SpeedX,ByRef SpeedY)
{
 global WindowList
 RegExMatch(WindowList,"m)^" . WindowID . "\|(.*)\|(.*)$",Temp), SpeedX := Temp1, SpeedY := Temp2
}

SetSpeed(WindowID,SpeedX,SpeedY)
{
 global WindowList
 WindowList := RegExReplace(WindowList,"m)^(" . WindowID . "\|).*$","$1" . SpeedX . "|" . SpeedY,False,1)
}

Step(WindowID,ByRef SpeedX,ByRef SpeedY)
{
 global AirResistance
 global Restitution
 global Friction
 global Gravity
 global JitterDetection
 
 Critical
 WinGetPos, WinX, WinY, WinW, WinH, ahk_id %WindowID%

 SpeedX -= AirResistance * SpeedX, SpeedY -= AirResistance * SpeedY ;Calculate air resistance

 LeftRightUsed := 0, UpDownUsed = 0

 If (((WinX + SpeedX) <= 0) || ((WinX + WinW + SpeedX) >= A_ScreenWidth)) ;Collided with one side of boundary.
  SpeedX *= -1 * Restitution, LeftRightUsed := 1 ;Calculate bounce for X direction
 If (((WinY + SpeedY) <= 0) || ((WinY + WinH + SpeedY) >= A_ScreenHeight)) ;Collided with bottom or top of boundary.
  SpeedY *= -1 * Restitution, UpDownUsed := 1 ;Calculate bounce for Y direction

 If (LeftRightUsed && SpeedX = 0) ;Sliding vertically along a side boundary
  SpeedY -= SpeedY * Friction * (WinH / 200) ;Calculate sliding friction for Y direction
 If (UpDownUsed && SpeedY = 0) ;Sliding horizontally along either the top or bottom boundary
  SpeedX -= SpeedX * Friction * (WinW / 200) ;Calculate sliding friction for X direction

 SpeedY += Gravity ;Calculate gravity

 If SpeedX Between -0.05 And 0.05 ;Very slow sliding along X direction
  SpeedX = 0 ;Stop X direction sliding

 If (LeftRightUsed && SpeedX >= -0.5 && SpeedX <= 0.5) ;Prevent jitter when bouncing off of sides
  SpeedX = 0 ;Stop X direction sliding
 If (UpDownUsed && SpeedY >= Gravity * JitterDetection * -1 && SpeedY <= Gravity * JitterDetection) ;Prevent gravity jitter when bouncing off of the bottom or top of the boundary
  SpeedY = 0 ;Stop Y direction sliding

 If (UpDownUsed && SpeedX = 0 && SpeedY = 0) ;Sleeping state
  Return, 1

 WinX += SpeedX, WinY += SpeedY ;Calculate final position
 WinMove, ahk_id %WindowID%,, %WinX%, %WinY%
}

~LButton::
CoordMode, Mouse, Relative
MouseGetPos, OffsetX, OffsetY, CurrentWin
CoordMode, Mouse
If Not InStr("`n" . WindowList,"`n" . CurrentWin . "|")
 Return
IfWinNotActive, ahk_id %CurrentWin%
 Return
If OffsetY > 30
 Return
WinSet, Disable,, ahk_id %CurrentWin%
SetTimer, StepAll, Off
SetTimer, MoveWin, 50
Return

MoveWin:
MouseGetPos, MouseX, MouseY
If Not GetKeyState("LButton")
{
 SetSpeed(CurrentWin,MouseX - OffsetX,MouseY - OffsetY)
 WinSet, Enable,, ahk_id %CurrentWin%
 SetTimer, MoveWin, Off
 SetTimer, StepAll, On
 Return
}
WinGetPos, WinX, WinY, WinW, WinH, ahk_id %CurrentWin%
WinX -= OffsetX - MouseX
WinY -= OffsetY - MouseY
If (WinX >= 0 && WinY >= 0 && (WinX + WinW) <= A_ScreenWidth && (WinY + WinH) <= A_ScreenHeight)
 WinMove, ahk_id %CurrentWin%,, WinX, WinY
Return

^!Up::
WinGet, Temp1, ID, A
If InStr("`n" . WindowList,"`n" . Temp1 . "|")
 GetSpeed(Temp1,TempX,TempY), SetSpeed(Temp1,TempX,TempY - 2)
Return

^!Down::
WinGet, Temp1, ID, A
If InStr("`n" . WindowList,"`n" . Temp1 . "|")
 GetSpeed(Temp1,TempX,TempY), SetSpeed(Temp1,TempX,TempY + 2)
Return

^!Left::
WinGet, Temp1, ID, A
If InStr("`n" . WindowList,"`n" . Temp1 . "|")
 GetSpeed(Temp1,TempX,TempY), SetSpeed(Temp1,TempX - 2,TempY)
Return

^!Right::
WinGet, Temp1, ID, A
If InStr("`n" . WindowList,"`n" . Temp1 . "|")
 GetSpeed(Temp1,TempX,TempY), SetSpeed(Temp1,TempX + 2,TempY)
Return

RefreshWindowList()
{
 global WindowList
 Critical
 MinWidth = 100
 MaxWidth = % A_ScreenWidth - 50
 MinHeight = 100
 MaxHeight = % A_ScreenHeight - 50
 
 WinGet, Temp1, List
 Loop, %Temp1%
 {
  Temp2 := Temp1%A_Index%
  WinGetTitle, Temp3, ahk_id %Temp2%
  If Temp3 In ,Program Manager,Start
   Continue
  WinGetPos, PosX, PosY, Width, Height, ahk_id %Temp2%
  If (PosX < 0 || PosY < 0 || PosX + Width > A_ScreenWidth || PosY + Height > A_ScreenHeight)
   Continue
  If Width Not Between %MinWidth% And %MaxWidth%
   Continue
  If Height Not Between %MinHeight% And %MaxHeight%
   Continue
  TempX := "", TempY := ""
  If InStr("`n" . WindowList,"`n" . Temp2 . "|")
   GetSpeed(Temp2,TempX,TempY)
  WindowList1 .= Temp2 . "|" . TempX . "|" . TempY . "`r`n"
 }
 StringTrimRight, WindowList, WindowList1, 1
}