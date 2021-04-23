#NoEnv

/*
;todo:
- minimap - wide scroolbar containing zoomed out preview of the text
- use Scintilla control
- file browser
- when you have the menu selected, and press down, have the menu at the bottom show up, with the button on the left selected, then you can move to the left or right to select a different button
- increment replace: allow find and replace to replace with numbers that are incremented each time, so in "a,b,a,b,a", replacing "a" with "$i" would yield "1,b,2,b,3". also allow customising the start and step values
- undo/redo tree with diffs
- nonblocking interface, similar to Blender's
- spell checking and bookmarks
- asynchronous file loading so large files don't block the interface
- macros and snippets
- autocomplete and intellisense
- auto-save, exact resume (including window and cursor position), graphical versioning built in
- multiline find/replace input boxes
*/

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

EditorTitle = Untitled - Editor
MenuList = &FILE|new:open:save:save as:close:exit:test:test1,&EDIT|cut:copy:paste,&VIEW|,&TEXT,&HELP|about:credits:help

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

 Gui, 1:Font, s14 c%TextColor%, %MainFont%
 Gui, 1:Add, Text, x5 y0 w600 h25 BackgroundTrans gDragWin, %EditorTitle%
 Temp1 := A_ScreenWidth + 10
 Gui, 1:Add, Progress, x0 y25 w%Temp1% h1 Background%SecondaryColor%, 0
 Gui, 1:Add, Progress, x5 y25 w50 h20 vMenuBarBackground Background%SecondaryColor%, 0

 Gui, 1:Add, Text, x600 y50 w10 h100 vScrollBar gScroll
 Gui, 1:Add, Progress, x600 y50 w10 h100 vScrollBarArea c%SecondaryColor% Background%BackgroundColor%, 100
 Gui, 1:Add, Progress, x605 y50 w1 h%A_ScreenHeight% vScrollBarLine Background%SecondaryColor%, 0
 Gui, 1:Add, Text, x600 y330 w10 h%A_ScreenHeight% vScrollBarMask

 Gui, 1:Add, Progress, x0 y0 w%Temp1% h1 vLowerMenuDivider Background%SecondaryColor%, 0

 Gui, 1:Font, s12 c%TextColor%
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

 hEdit := HE_Add(hWnd,5,50,590,280,"HILIGHT")
 HE_SetFont(hEdit,"s12,Consolas")
 Temp1 := RGB2BGR("0x" . TextColor)
 HE_SetColors(hEdit,"Text=" . Temp1 . "`nBack=" . RGB2BGR("0x" . BackgroundColor) . "`nSelText=" . Temp1 . "`nActSelBack=" . RGB2BGR("0x" . SecondaryColor))

 Gui, 1:Add, Text, x0 y0 w15 h16 vResizeButton gResizeWin, +

 Gui, 1:Font, s18
 Gui, 1:Add, Text, x-360 y2 w360 h30 Center vMessageTitle gNotifierAction, SomeTitle
 Gui, 1:Font, s10
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

#Include %A_ScriptDir%\SupportLib.ahk
#Include %A_ScriptDir%\HiEdit.ahk