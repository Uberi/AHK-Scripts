~LButton::
MouseGetPos,,, WindowID, ControlName
WinSet, Enable,, ahk_id %WindowID%
If ControlName Not Contains Edit,Button
 Return
ControlGet, IsEnabled, Enabled,, %ControlName%, ahk_id %WindowID%
If Not IsEnabled
 Control, Enable,, %ControlName%, ahk_id %WindowID%
Return