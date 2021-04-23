#NoEnv

CoordMode, Mouse

MButton::
Suspend, Permit
If UseWheelMouse
{
 Suspend, Off
 UseWheelMouse = 0
}
Else
{
 Suspend, On
 UseWheelMouse = 1
}
Return

LButton::
If GetKeyState("LButton")
 Send, {LButton Up}
Else
 Send, {LButton Down}
Return

RButton::Send, {RButton}

RButton & LButton::
If Axis
 Axis = 0
Else
 Axis = 1
Return

LButton & RButton::
If Slow
 Slow = 0
Else
 Slow = 1
Return

WheelUp::
If Axis
{
 If Slow
  MouseMove, 1, 0, 0, R
 Else
  MouseMove, 15, 0, 0, R
}
Else
{
 If Slow
  MouseMove, 0, -1, 0, R
 Else
  MouseMove, 0, -15, 0, R
}
Return

WheelDown::
If Axis
{
 If Slow
  MouseMove, -1, 0, 0, R
 Else
  MouseMove, -15, 0, 0, R
}
Else
{
 If Slow
  MouseMove, 0, 1, 0, R
 Else
  MouseMove, 0, 15, 0, R
}
Return