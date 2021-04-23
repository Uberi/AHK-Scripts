GuiEscape:
GuiClose:
Gui, 1:+AlwaysOnTop
FadeOut()
ExitApp

MenuSwitch:
If A_GuiControl
{
 Temp1 := SubStr(MenuList,1,InStr(MenuList,A_GuiControl))
 StringReplace, Temp1, Temp1, `,, `,, UseErrorLevel
 MenuSwitchTo(ErrorLevel + 1)
}
Else
 MenuSwitchTo(InStr(MenuKeyList,SubStr(A_ThisHotkey,2)))
Return

ShowWindow:
Gui, 1:Show
Return

DragWin:
Gui, +LastFound
PostMessage, 0xA1, 2
Return

TrayMenu()
{
 ;Menu, Tray, NoStandard
 Menu, Tray, Add, Show Window, ShowWindow
 Menu, Tray, Add, Exit, GuiClose
 Menu, Tray, Default, Show Window
 Menu, Tray, Click, 1
}

ShowMessage(Title,Body,TimeOut = -1)
{
 global MessageShown
 global Notified
 If MessageShown
  Return
 GuiControl, 1:, MessageTitle, %Title%
 GuiControl, 1:, MessageBody, %Body%

 Gui, 1:+LastFound
 WinGetPos,,, Width
 Hotkey, Esc, NotifierAction, On
 MessageShown := 1, EaseIn((Width / 2) - 180,"","MessageBorderTop,MessageBorderBottom,MessageBorderLeft,MessageBorderRight,MessageTitle,MessageBody",30)
 Notified := 0
 If TimeOut > 0
  SetTimer, NotifierAction, % TimeOut * -1000
 While, !Notified
  Sleep, 20
 Hotkey, Esc, Off
 HideMessage()
}

NotifierAction:
Notified = 1
MsgBox
Return

HideMessage()
{
 global MessageShown
 If !MessageShown
  Return
 Gui, 1:+LastFound
 WinGetPos,,, Width
 MessageShown := 0, EaseOut(Width,"","MessageBorderTop,MessageBorderBottom,MessageBorderLeft,MessageBorderRight,MessageTitle,MessageBody",30)
 GuiControl, 1:Move, MessageBorderTop, x-360
 GuiControl, 1:Move, MessageBorderBottom, x-360
 GuiControl, 1:Move, MessageBorderLeft, x-360
 GuiControl, 1:Move, MessageBorderRight, x-1
 GuiControl, 1:Move, MessageTitle, x-360
 GuiControl, 1:Move, MessageBody, x-360
}

GuiSize:
If (A_EventInfo = 1 || ResizingWindow)
 Return
Gui, 1:+LastFound
WinGetPos,,, Temp1, Temp2
If (Temp1 = LastWidth && Temp2 = LastHeight)
 Return
ResizeControls(Temp1 - 18,Temp2 - 15), LastWidth := Temp1, LastHeight := Temp2
SetTimer, RedrawWin, -100
Return

RedrawWin:
Gui, 1:+LastFound
WinSet, Redraw
Return

ResizeWin:
Gui, 1:+LastFound
WinGetPos, Temp1, Temp2
ResizingWindow := 1
While, GetKeyState("LButton","P")
{
 MouseGetPos, Temp3, Temp4
 Temp3 -= Temp1, Temp4 -= Temp2
 If Temp3 < %MinWidth%
  Temp3 = %MinWidth%
 If Temp4 < %MinHeight%
  Temp4 = %MinHeight%
 ResizeControls(Temp3,Temp4)
 Gui, 1:Show, w%Temp3% h%Temp4%
 Sleep, 10
}
WinSet, Redraw
ResizingWindow = 0
Return

ShowDropdown()
{
 global LowerMenuState
 If Not LowerMenuState
  Return
 If LowerMenuState = 2
 {
  GuiControlGet, Pos, 1:Pos, LowerMenuDivider
  EaseIn(PosX,PosY - 25,"LowerMenuDivider,ScrollBarMask"), ResizeScroll()
 }
 LowerMenuState = 0
 EaseIn(5,"","LowerMenu1,LowerMenu2,LowerMenu3,LowerMenu4,LowerMenu5,LowerMenu6,LowerMenu7,LowerMenu8")
}

HideDropdown(CloseMenu = 0)
{
 global LowerMenuState
 If LowerMenuState
  Return
 EaseOut(-555,"","LowerMenu1,LowerMenu2,LowerMenu3,LowerMenu4,LowerMenu5,LowerMenu6,LowerMenu7,LowerMenu8")
 If CloseMenu
 {
  GuiControlGet, Pos, 1:Pos, LowerMenuDivider
  EaseIn(PosX,PosY + 25,"LowerMenuDivider,ScrollBarMask"), ResizeScroll()
  LowerMenuState = 2
 }
 Else
  LowerMenuState = 1
}

MenuSwitchTo(MenuNum = "+")
{
 local Temp0
 static CurrentPosition := 1
 If MenuNum In +,-
  MenuNum := (MenuNum . 1) + CurrentPosition
 If MenuNum Not Between 1 And %MenuSize%
  Return
 If MenuNum = %CurrentPosition%
  Return
 EaseIn(((MenuNum - 1) * 50) + 5,25,"MenuBarBackground"), CurrentPosition := MenuNum
 StringSplit, Temp, MenuList%MenuNum%, :
 HideDropDown(!Temp0)
 Loop, 8
 {
  GuiControl,, LowerMenu%A_Index%, % Temp%A_Index%
  Temp%A_Index% = 
 }
 If Temp0
  SetTimer, ShowDropdown, -300
}

ShowDropdown:
ShowDropdown()
Return

EaseIn(DestX,DestY,ControlNameList,Speed = 15,GuiNum = 1)
{
 Loop, Parse, ControlNameList, CSV
  GuiControlGet, Pos%A_Index%, %GuiNum%:Pos, %A_LoopField%
 % (DestX = "") ? SpeedX := 0 : SpeedX := (DestX - Pos1X) / 45, (DestY = "") ? SpeedY := 0 : SpeedY := (DestY - Pos1Y) / 45
 ListLines, Off
 Loop, 9
 {
  A_Index1 := 10 - A_Index
  Loop, Parse, ControlNameList, CSV
  {
   Pos%A_Index%X += A_Index1 * SpeedX, Pos%A_Index%Y += A_Index1 * SpeedY
   GuiControl, %GuiNum%:Move, %A_LoopField%, % "x" . Pos%A_Index%X . " y" . Pos%A_Index%Y
  }
  Sleep, %Speed%
 }
 Loop, Parse, ControlNameList, CSV
  GuiControl, %GuiNum%:MoveDraw, %A_LoopField%
 ListLines, On
}

EaseOut(DestX,DestY,ControlNameList,Speed = 15,GuiNum = 1)
{
 Loop, Parse, ControlNameList, CSV
  GuiControlGet, Pos%A_Index%, %GuiNum%:Pos, %A_LoopField%
 % (DestX = "") ? SpeedX := 0 : SpeedX := (DestX - Pos1X) / 45, (DestY = "") ? SpeedY := 0 : SpeedY := (DestY - Pos1Y) / 45
 ListLines, Off
 Loop, 9
 {
  A_Index1 = %A_Index%
  Loop, Parse, ControlNameList, CSV
  {
   Pos%A_Index%X += A_Index1 * SpeedX, Pos%A_Index%Y += A_Index1 * SpeedY
   GuiControl, %GuiNum%:Move, %A_LoopField%, % "x" . Pos%A_Index%X . " y" . Pos%A_Index%Y
  }
  Sleep, %Speed%
 }
 ListLines, On
}

FadeIn(GuiNumber = 1,Speed = 10)
{
 Gui, %GuiNumber%:+LastFound
 WinSet, Transparent, 0
 Gui, %GuiNumber%:Show, NoActivate
 Loop, 14
 {
  Sleep, %Speed%
  WinSet, Transparent, % A_Index * 17
 }
 Sleep, %Speed%
 WinSet, Transparent, Off
}

FadeOut(GuiNumber = 1,Speed = 10)
{
 Gui, %GuiNumber%:+LastFound
 WinSet, Transparent, Off
 Loop, 14
 {
  Sleep, %Speed%
  WinSet, Transparent, % 255 - (A_Index * 17)
 }
 Sleep, %Speed%
 Gui, %GuiNumber%:Hide
}