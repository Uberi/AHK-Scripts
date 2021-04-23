#NoEnv

SetBatchLines, -1
GuiNum = 0
Return

Space::
If HiddenList
{
 ShowAllWindows(HiddenList)
 HiddenList = 
}
Else
 HiddenList := PeekAllWindows()
Return

Esc::
If HiddenList
 ShowAllWindows(HiddenList)
ExitApp

PeekAllWindows()
{
 global GuiNum
 SetWinDelay, -1
 WinGet, TempList, List
 WinGet, TempActive, ID, A
 Loop, % (TempList < 100) ? TempList : 99
 {
  Temp1 := TempList - (A_Index - 1)
  Temp1 := TempList%Temp1%
  CreateWindow(Temp1)
  HiddenList .= Temp1 . "|"
 }
 StringTrimRight, HiddenList, HiddenList, 1
 Return, TempActive . ":" HiddenList
}

CreateWindow(WindowID)
{
 global GuiNum
 WinGetTitle, TempTitle, ahk_id %WindowID%
 If TempTitle In ,Program Manager,Start
  Return
 WinGet, Temp1, MinMax, ahk_id %WindowID%
 If Temp1 = -1
  Return
 WinGetPos, TempX, TempY, TempW, TempH, ahk_id %WindowID%
 If Temp1 = 1
 {
  TempX = 0
  TempY = 0
  TempW = %A_ScreenWidth%
  TempH = %A_ScreenHeight%
 }
 StringLeft, TempTitle, TempTitle, Round(TempW / 30)
 GuiNum ++
 Gui, %GuiNum%:Default
 Gui, Font, S36 CSilver, Arial
 Temp1 := (TempH / 2) - 25
 Gui, Add, Text, x0 y%Temp1% w%TempW% r1 Center, %TempTitle%
 Gui, Color, 006080
 Gui, -Caption +ToolWindow +LastFound +E0x20
 WinSet, Transparent, 100
 Temp1 := ((TempW > TempH) ? TempH : TempW) / 5
 WinSet, Region, 0-0 w%TempW% h%TempH% R%Temp1%-%Temp1%
 Gui, Show, x%TempX% y%TempY% w%TempW% h%TempH%, Peek_%TempTitle%

 WinHide, ahk_id %WindowID%
}

ShowAllWindows(HiddenList)
{
 global GuiNum
 If Not HiddenList
  Return
 Temp1 := InStr(HiddenList,":")
 StringLeft, TempActive, HiddenList, Temp1 - 1
 StringTrimLeft, HiddenList, HiddenList, %Temp1%
 Loop, %GuiNum%
  Gui, %A_Index%:Cancel
 Loop, Parse, HiddenList, |
  WinShow, ahk_id %A_LoopField%
 WinActivate, ahk_id %TempActive%
 Loop, %GuiNum%
  Gui, %A_Index%:Destroy
}