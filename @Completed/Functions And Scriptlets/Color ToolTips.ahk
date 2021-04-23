#NoEnv

/*
ToolTipNum = 0
Loop, 10
{
 If A_Index In 1,3,5,7,9
  AppendToolTip("BlaBlaBlaBlaBla" . A_Index,"Red","White")
 Else
  AppendToolTip("BlaBlaBlaBlaBla" . A_Index,"Blue","Lime")
}

Space::DeleteToolTip(2)
Tab::
Message .= "1"
If Mod(StrLen(Message),2)
 AppendToolTip("BlaBlaBlaBlaBla" . Message,"Red","White")
Else
 AppendToolTip("BlaBlaBlaBlaBla" . Message,"Blue","Lime")
Return

Esc::ExitApp
*/

AppendToolTip(ToolTipText,ToolTipColor,TextColor)
{
 local Width
 local PosY
 ToolTipNum ++
 Temp1 := 100 - ToolTipNum
 Gui, %Temp1%:Color, %ToolTipColor%
 Gui, %Temp1%:Font, c%TextColor% s12, Lucida Console
 Width := StrLen(ToolTipText) * 10 + 10
 Gui, %Temp1%:Add, Text, x4 y4 w%Width% h20 vColorToolTip%ToolTipNum%, %ToolTipText%
 ColorToolTip%ToolTipNum% = %ToolTipColor%|%TextColor%
 Gui, %Temp1%:-Caption +LastFound +AlwaysOnTop +ToolWindow
 WinSet, Transparent, 150
 WinSet, Region, 0-0 w%Width% h25 r10-10
 PosY := A_ScreenHeight - ToolTipNum * 40
 Gui, %Temp1%:Show, x10 y%PosY% h25 w%Width%
}

ChangeToolTip(ToolTipNum,ToolTipText,ToolTipColor = "",TextColor = "")
{
 Temp1 := 100 - ToolTipNum
 GuiControl, %Temp1%:, ColorToolTip%ToolTipNum%, %ToolTipText%
 If ToolTipColor
 {
  Gui, %Temp1%:Color, %ToolTipColor%
  StringRight, ColorToolTip%ToolTipNum%, ColorToolTip%ToolTipNum%, StrLen(ColorToolTip%ToolTipNum%) - InStr(ColorToolTip%ToolTipNum%,"|")
  ColorToolTip%ToolTipNum% := ToolTipColor . "|" . ColorToolTip%ToolTipNum%
 }
 If TextColor
 {
  Gui, %Temp1%:Font, c%TextColor% s12
  GuiControl, %Temp1%:Font, ColorToolTip%ToolTipNum%
  StringLeft, ColorToolTip%ToolTipNum%, ColorToolTip%ToolTipNum%, InStr(ColorToolTip%ToolTipNum%,"|") - 1
  ColorToolTip%ToolTipNum% .= "|" . TextColor
 }
 Width := StrLen(ToolTipText) * 10 + 10
 GuiControl, %Temp1%:Move, ColorToolTip%ToolTipNum%, w%Width%
 Gui, %Temp1%:+LastFound
 WinSet, Region, 0-0 h25 w%Width% r10-10
 Gui, %Temp1%:Show, w%Width%
}

GetToolTip(ToolTipNum,ByRef ToolTipText,ByRef ToolTipColor,ByRef TextColor)
{
 local Temp0
 local Temp1
 local Temp2
 StringSplit, Temp, ColorToolTip%ToolTipNum%, |
 ToolTipColor = %Temp1%
 TextColor = %Temp2%
 GuiControlGet, ToolTipText, % (100 - ToolTipNum) . ":", ColorToolTip%ToolTipNum%
}

DeleteToolTip(ToolTipNum1)
{
 local Temp1
 local Temp2
 local ToolTipColor
 local TextColor
 If ToolTipNum1 > %ToolTipNum%
  Return
 Loop, % ToolTipNum - ToolTipNum1
 {
  ToolTipNum1 ++
  Temp1 := 100 - ToolTipNum1
  GetToolTip(ToolTipNum1,Temp2,ToolTipColor,TextColor)
  ChangeToolTip(ToolTipNum1 - 1,Temp2,ToolTipColor,TextColor)
 }
 Temp1 := 100 - ToolTipNum
 Gui, %Temp1%:Destroy
 ToolTipNum --
}