#NoEnv

#Persistent

Gravity = 0.0 ;0.9
Restitution = 0.8
AirResistance = 0.02
JitterDetection = 1.5

MouseStrength = 40
MouseDampen = 0.8

MinParticleSize = 20
MaxParticleSize = 60

Transparency = 80

ClickThrough = 1

SetWinDelay, 0
CoordMode, Mouse
SysGet, ScreenWidth, 78
SysGet, ScreenHeight, 79

MouseStrength := 400 / MouseStrength
Transparency := (Transparency / 100) * 255
ParticleCount = 1
AddParticles(6)
SetTimer, StepAll, 80
Return

~Up::AddParticles(1,1)
~Down::RemoveParticles(1)

~LButton::
~RButton::
ThisHotkey := SubStr(A_ThisHotkey,2)
If ThisHotkey = RButton
 PushOut = 1
While, GetKeyState(ThisHotkey,"P")
{
 MouseGetPos, GoalX, GoalY
 Sleep, 50
}
GoalX = 
GoalY = 
PushOut = 
Return

Esc::
ExitApp

StepAll:
Critical
Loop, Parse, ParticleList, `n
{
 If A_LoopField = 
  Continue
 If (SpeedX%A_LoopField% = "" || SpeedY%A_LoopField% = "")
 {
  Random, SpeedX%A_LoopField%, -50, 50
  Random, SpeedY%A_LoopField%, -50, 50
 }
 Step(A_LoopField,SpeedX%A_LoopField%,SpeedY%A_LoopField%)
}
Return

AddParticles(Amount = 15,AtMouse = 0)
{
 global ParticleList
 global ScreenWidth
 global ScreenHeight
 global MinParticleSize
 global MaxParticleSize
 global Transparency
 global ClickThrough
 global ParticleCount

 ColorList = ,Red,Yellow,Blue,
 Loop, %Amount%
 {
  If ParticleCount = 100
   Return
  Temp1 := Mod(ParticleCount,3) + 1
  StringGetPos, Temp1, ColorList, `,, L%Temp1%
  Temp1 += 2
  Gui, %ParticleCount%:Color, % SubStr(ColorList,Temp1,InStr(ColorList,"`,",False,Temp1) - Temp1)
  Gui, %ParticleCount%:+LastFound +AlwaysOnTop -Caption +ToolWindow
  ParticleList .= WinExist() . "`n"
  If (Transparency <> 255 || ClickThrough)
   WinSet, Transparent, %Transparency%
  If ClickThrough
   Gui, %ParticleCount%:+E0x20
  Random, Temp1, %MinParticleSize%, %MaxParticleSize%
  If AtMouse
  {
   MouseGetPos, Temp2, Temp3
   Temp4 := ScreenWidth - Temp1
   If Temp2 > %Temp4%
    Temp2 = %Temp4%
   Temp4 := ScreenHeight - Temp1
   If Temp3 > %Temp4%
    Temp3 = %Temp4%
  }
  Else
  {
   Random, Temp2, 0, ScreenWidth - Temp1
   Random, Temp3, 0, ScreenHeight - Temp1
  }
  WinSet, Region, 0-0 w%Temp1% h%Temp1% E
  Gui, %ParticleCount%:Show, x%Temp2% y%Temp3% w%Temp1% h%Temp1% NoActivate
  ParticleCount ++
 }
}

RemoveParticles(Amount = 3)
{
 global ParticleCount
 Loop, %Amount%
 {
  If ParticleCount = 1
   Return
  Temp1 := ParticleCount - (A_Index - 1)
  Gui, %Temp1%:+LastFound
  Temp2 := WinExist()
  StringReplace, ParticleList, ParticleList, %Temp2%`n
  SpeedX%Temp2% = 
  SpeedY%Temp2% = 
  Gui, %Temp1%:Destroy
  ParticleCount --
 }
}

Step(WindowID,ByRef SpeedX,ByRef SpeedY)
{
 global ScreenWidth
 global ScreenHeight
 global AirResistance
 global Restitution
 global Gravity
 global JitterDetection
 global MouseStrength
 global MouseDampen
 global GoalX
 global GoalY
 global PushOut
 
 Critical
 WinGetPos, WinX, WinY, WinW, WinH, ahk_id %WindowID%

 If (GoalX <> "" || GoalY <> "")
 {
  SpeedX *= MouseDampen
  SpeedY *= MouseDampen
  If PushOut
   SpeedX -= (GoalX - (WinX + (WinW / 2))) / MouseStrength, SpeedY -= (GoalY - (WinY + (WinH / 2))) / MouseStrength
  Else
   SpeedX += (GoalX - (WinX + (WinW / 2))) / MouseStrength, SpeedY += (GoalY - (WinY + (WinH / 2))) / MouseStrength
 }

 SpeedX -= AirResistance * SpeedX, SpeedY -= AirResistance * SpeedY ;Calculate air resistance

 LeftRightUsed := 0, UpDownUsed := 0

 If (((WinX + SpeedX) <= 0) || ((WinX + WinW + SpeedX) >= ScreenWidth)) ;Collided with one side of boundary.
  SpeedX *= -1 * Restitution, LeftRightUsed := 1 ;Calculate bounce for X direction
 If (((WinY + SpeedY) <= 0) || ((WinY + WinH + SpeedY) >= ScreenHeight)) ;Collided with bottom or top of boundary.
  SpeedY *= -1 * Restitution, UpDownUsed := 1 ;Calculate bounce for Y direction

 SpeedY += Gravity ;Calculate gravity

 If SpeedX Between -0.05 And 0.05 ;Very slow sliding along X direction
  SpeedX = 0 ;Stop X direction sliding

 If (LeftRightUsed && SpeedX >= -0.5 && SpeedX <= 0.5) ;Prevent jitter when bouncing off of sides
  SpeedX = 0 ;Stop X direction sliding
 If (UpDownUsed && SpeedY >= Gravity * JitterDetection * -1 && SpeedY <= Gravity * JitterDetection) ;Prevent gravity jitter when bouncing off of the bottom or top of the boundary
  SpeedY = 0 ;Stop Y direction sliding

 WinX += SpeedX, WinY += SpeedY ;Calculate final position
 WinMove, ahk_id %WindowID%,, %WinX%, %WinY%
}