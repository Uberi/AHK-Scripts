;http://www.iconarchive.com/show/must-have-icons-by-visualpharm/Save-icon.html
;http://www.iconarchive.com/show/must-have-icons-by-visualpharm/Open-icon.html
;http://www.iconarchive.com/show/must-have-icons-by-visualpharm/Delete-icon.html
;http://www.iconarchive.com/show/must-have-icons-by-visualpharm/Settings-icon.html
;http://www.iconarchive.com/show/play-stop-pause-icons-by-icons-land/Step-Forward-Hot-icon.html
;http://www.iconarchive.com/show/play-stop-pause-icons-by-icons-land/Stop-Normal-Red-icon.html
;http://www.iconarchive.com/show/must-have-icons-by-visualpharm/Find-icon.html
;http://www.clker.com/cliparts/e/5/a/2/1206570547560908424akiross_Audio_Button_Set_4.svg.med.png
;http://www.iconarchive.com/icons/icons-land/play-stop-pause/256/Stop-Normal-Red-icon.png
;http://www.iconarchive.com/category/application/play-stop-pause-icons-by-icons-land.html

;http://desmond.yfrog.com/Himg576/scaled.php?tn=0&server=576&filename=minmaxclose.png&xsize=640&ysize=640

;todo:
;-filebrowser
;-when you have the menu selected, and press down, have the menu at the bottom show up, with the button on the left selected, then you can move to the left or right to select a different button

CoordMode, Mouse
SetWinDelay, 0
SetControlDelay, 0
Critical
#IfWinActive ahk_group EditorWindow

;Dark orange
BackgroundColor = 000000
SecondaryColor = FF8800
TextColor = FFFFFF

MainFont = Calibri
CodeFont = Courier New

;Light blue
/*
BackgroundColor = F0FFF3
SecondaryColor = C5CFDF
TextColor = 000000
*/

EditorTitle = Some Text Editor
MenuList = &File|New:Open:Save:Save As:Close:Exit:Test:Test1,&Edit|Cut:Copy:Paste,&View|,&Text,&Search,&Help|About:Credits:Help

MainGUI()
TrayMenu()
Return

Left::MenuSwitchTo("-")
Right::MenuSwitchTo("+")
Up::ShowDropDown()
Down::HideDropdown(1)
Space::ShowMessage("Some Title","Some body text, that may describe what is happening...",4)

ResizeControls(Width,Height)
{
 global MessageShown
 global LowerMenuState
 global hEdit
 GuiControl, 1:Move, ResizeButton, % "x" . (Width - 12) . " y" . (Height - 20)

 Temp1 := Height - 40
 GuiControl, 1:Move, LowerMenuDivider, y%Temp1%
 Temp1 ++
 Loop, 8
  GuiControl, 1:Move, LowerMenu%A_Index%, y%Temp1%

 If MessageShown
 {
  Temp1 := (Width / 2) - 180
  GuiControl, 1:Move, MessageBorderTop, x%Temp1%
  GuiControl, 1:Move, MessageBorderBottom, x%Temp1%
  GuiControl, 1:Move, MessageBorderLeft, x%Temp1%
  GuiControl, 1:Move, MessageBorderRight, % "x" . Temp1 + 359
  GuiControl, 1:Move, MessageTitle, x%Temp1%
  GuiControl, 1:Move, MessageBody, x%Temp1%
 }

 Temp1 := Width - 21
 GuiControl, 1:Move, ScrollBarMask, % "x" . Temp1 . " y" . Height - ((LowerMenuState = 2) ? 20 : 50)
 GuiControl, 1:Move, ScrollBarLine, % "x" . Temp1 + 4
 GuiControl, 1:Move, ScrollBarArea, x%Temp1%
 GuiControl, 1:Move, ScrollBar, x%Temp1%
 ResizeScroll()

 ControlMove,,,, % Width - 30, % Height - 100, ahk_id %hEdit%

 WinSet, Region, 7-7 w%Width% h%Height%
}

ResizeScroll()
{
 
}

SetScroll()
{
 
}

Scroll:
Gui, 1:+LastFound
WinGetPos,, Temp1,, Temp2
GuiControlGet, Temp, 1:Pos, ScrollBarMask
MaxScroll := TempY
GuiControlGet, Temp, 1:Pos, ScrollBar
MaxScroll -= TempH
MouseGetPos,, OffsetY
OffsetY -= TempY + Temp1, LastPos := ""
While, GetKeyState("LButton","P")
{
 MouseGetPos,, Temp2
 Temp2 -= Temp1, Temp2 -= OffsetY, (Temp2 > MaxScroll) ? Temp2 := MaxScroll : "", (Temp2 < 50) ? Temp2 := 50
 If Temp2 <> %LastPos%
 {
  GuiControl, 1:Move, ScrollBar, y%Temp2%
  GuiControl, 1:MoveDraw, ScrollBarArea, y%Temp2%
  SetScroll(), LastPos := Temp2
 }
 Sleep, 10
}
GuiControl, 1:MoveDraw, ScrollBarArea
Return

MainGUI()
{
 local TempField
 local Temp0
 local Temp1
 local Temp2
 Gui, 1:+LastFound +Resize
 hWnd := WinExist()
 GroupAdd, EditorWindow, ahk_id %hWnd%

 Gui, 1:Font, s14 c%TextColor% Bold, %MainFont%
 Gui, 1:Add, Text, x5 y0 w600 h25 BackgroundTrans gDragWin, %EditorTitle%
 Temp1 := A_ScreenWidth + 10
 Gui, 1:Add, Progress, x0 y25 w%Temp1% h1 Background%SecondaryColor%, 0
 Gui, 1:Add, Progress, x5 y25 w50 h20 vMenuBarBackground Background%SecondaryColor%, 0

 Gui, 1:Add, Text, x600 y50 w10 h100 vScrollBar gScroll
 Gui, 1:Add, Progress, x600 y50 w10 h100 vScrollBarArea c%SecondaryColor% Background%BackgroundColor%, 100
 Gui, 1:Add, Progress, x605 y50 w1 h%A_ScreenHeight% vScrollBarLine Background%SecondaryColor%, 0
 Gui, 1:Add, Text, x600 y330 w10 h%A_ScreenHeight% vScrollBarMask

 Gui, 1:Add, Progress, x0 y0 w%Temp1% h1 vLowerMenuDivider Background%SecondaryColor%, 0

 Gui, 1:Font, s12 c%TextColor% Norm
 Loop, Parse, MenuList, CSV
 {
  StringSplit, Field, A_LoopField, |
  MenuSize := A_Index, Temp1 := InStr(Field1,"&"), MenuList%A_Index% := Field2, Field2 := ""
  If Temp1
  {
   Temp2 := SubStr(Field1,Temp1 + 1,1), MenuKeyList .= Temp2, Field1 := SubStr(Field1,1,Temp1 - 1) . SubStr(Field1,Temp1 + 1)
   Hotkey, % "!" . Temp2, MenuSwitch
  }
  Gui, 1:Add, Text, % "x" . (A_Index * 50) - 45 . " y26 w50 h20 BackgroundTrans Center gMenuSwitch", %Field1%
 }
 MinWidth := (MenuSize * 50) + 10, MinHeight := 200, (MinWidth < 530) ? MinWidth := 530

 Gui, 1:Font, s14 Norm
 StringSplit, Temp, MenuList1, :
 Loop, 8
  Gui, 1:Add, Text, % "x" . ((A_Index * 65) - 60) . " y350 w65 h25 BackgroundTrans Center vLowerMenu" . A_Index, % Temp%A_Index%

 Gui, 1:Add, Text, x0 y0 w15 h16 vResizeButton gResizeWin, +

 Gui, 1:Font, s18 Bold
 Gui, 1:Add, Text, x-360 y2 w360 h30 Center vMessageTitle gNotifierAction, SomeTitle
 Gui, 1:Font, s10 Norm
 Gui, 1:Add, Text, x-360 y32 w360 h20 Center vMessageBody gNotifierAction, Some text that makes up the body of the message...
 Gui, 1:Add, Progress, x-360 y2 w1 h50 Background%SecondaryColor% vMessageBorderTop, 0 ;x0
 Gui, 1:Add, Progress, x-1 y2 w1 h50 Background%SecondaryColor% vMessageBorderRight, 0 ;x359
 Gui, 1:Add, Progress, x-360 y2 w360 h1 Background%SecondaryColor% vMessageBorderLeft, 0 ;x0
 Gui, 1:Add, Progress, x-360 y51 w360 h1 Background%SecondaryColor% vMessageBorderBottom, 0 ;x0

 Gui, 1:Color, %BackgroundColor%
 Gui, 1:-Caption +Resize +MinSize%MinWidth%x%MinHeight% +AlwaysOnTop
 Gui, 1:Show, Hide w626 h379, Editor
 Gosub, GuiSize
 FadeIn()
 Gui, 1:-AlwaysOnTop
 WinActivate
}

RGB2BGR(RGBColor)
{
 SetFormat, IntegerFast, Hex
 Temp1 := (RGBColor & 255) << 16 | (RGBColor & 65280) | (RGBColor >> 16)
 SetFormat, IntegerFast, D
 Return, Temp1
}

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
Gui, 1:+LastFound
WinGetPos, Temp1, Temp2
MouseGetPos, Temp3, Temp4
Temp3 -= Temp1, Temp4 -= Temp2
While, GetKeyState("LButton","P")
{
 MouseGetPos, Temp1, Temp2
 Temp1 -= Temp3, Temp2 -= Temp4
 WinMove, Temp1, Temp2
;~  If MessageShown
 {
  Gui, 99:+LastFound
  WinMove, Temp1 + MessageShown, Temp2 + 50
  Gui, 1:+LastFound
 }
 Sleep, 20
}
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