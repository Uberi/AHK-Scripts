#NoEnv

Space::
If Frozen
{
 Frozen = 
 FreezeMouse(0)
}
Else
{
 Frozen = 1
 FreezeMouse(1)
}
Return

FreezeMouse(Block = 1)
{
 ParseList := "LButton,RButton,MButton,WheelDown,WheelUp,WheelLeft,WheelRight,XButton1,XButton2"
 If Block
 {
  BlockInput, MouseMove
  Loop, Parse, ParseList, CSV
   Hotkey, %A_LoopField%, FreezeMouse, On
 }
 Else
 {
  BlockInput, MouseMoveOff
  Loop, Parse, ParseList, CSV
   Hotkey, %A_LoopField%, Off
 }

 FreezeMouse:
 Return
}