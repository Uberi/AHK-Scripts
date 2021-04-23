ChangeWindow:
Gui, Destroy
WindowID := SelectWindow()
WinActivate, ahk_id %WindowID%
Gui, Add, Text, x2 y0 w120 h20, Window ID: %WindowID%
Gui, Add, Button, x2 y20 w120 h20 gWindow, Change Title
Gui, Add, Button, x2 y40 w120 h20 gWindow, Kill Window
Gui, Add, Button, x2 y60 w120 h20 gWindow, Toggle AlwaysOnTop
Gui, Add, Button, x2 y80 w120 h20 gWindow, Set Transparency
Gui, Add, Button, x2 y110 w120 h30 gChangeControl, Change Control
Gui, Show, w125 h140, Change Window
Return

ChangeControl:
Gui, Destroy
ControlName := SelectControl(WindowID)
Gui, Add, Text, x2 y0 w120 h20, Control: %ControlName%
Gui, Add, Button, x2 y20 w120 h20 gControl, Change Text
Gui, Add, Button, x2 y40 w120 h20 gControl, Hide Control
Gui, Add, Button, x2 y60 w120 h20 gControl, Toggle Disabled
Gui, Add, Button, x2 y80 w120 h20 gControl, Add Entry
Gui, Add, Button, x2 y100 w120 h20 gControl, Remove Entry
Gui, Add, Button, x2 y130 w120 h30 gChangeWindow, Change Window
Gui, Show, w125 h160, Change Window
Return

Window:
Gui, Hide
IfWinNotExist, ahk_id %WindowID%
{
 MsgBox, 64, Window Not Found, Window could not be found.
 Gui, Show
 Return
}
StringReplace, Temp1, A_GuiControl, %A_Space%,, All
%Temp1%(WindowID)
Gui, Show
Return

Control:
Gui, Hide
StringReplace, Temp1, A_GuiControl, %A_Space%,, All
%Temp1%(WindowID,ControlName)
Gui, Show
Return

Esc::
GuiClose:
ExitApp

;Window Functions

ChangeTitle(WindowID)
{
 WinGetTitle, Temp1, ahk_id %WindowID%
 InputBox, Temp1, New Title, Please enter a new title for this window.,, W, H, X, Y,,, %Temp1%
 If Not ErrorLevel
  WinSetTitle, ahk_id %WindowID%,, %Temp1%
}

KillWindow(WindowID)
{
 MsgBox, 36, Kill Window, Are you sure you want to kill this window?
 IfMsgBox, Yes
  WinKill, ahk_id %WindowID%
}

ToggleAlwaysOnTop(WindowID)
{
 WinSet, AlwaysOnTop, Toggle
 MsgBox, 64, Success, Always-on-top toggled.
}

SetTransparency(WindowID)
{
 static Transparency
 WinGet, Temp1, Transparent, ahk_id %WindowID%
 If Temp1 = 
  Temp1 = 255
 Temp1 := Round(Temp1 / 2.55)
 Gui, 99:Add, Text, x2 y0 w130 h20 +Center, Transparency Settings
 Gui, 99:Add, Text, x2 y20 w70 h20, Percentage:
 Gui, 99:Add, Edit, x72 y20 w60 h20 +Right
 Gui, 99:Add, UpDown, vTransparency, %Temp1%
 Gui, 99:Add, Button, x2 y50 w130 h20 gSetTransparent +Default, OK
 Gui, 99:+AlwaysOnTop +ToolWindow
 Gui, 99:Show, w135 h70, Transparency
 While Not Done
  Sleep, 10
 Gui, 99:Destroy
 Return
 
 SetTransparent:
 Gui, 99:Submit
 If Transparency = 100
 {
  WinSet, Transparent, Off, ahk_id %WindowID%
  Done = 1
  Return
 }
 WinSet, Transparent, % Transparency * 2.55, ahk_id %WindowID%

 99GuiClose:
 Done = 1
 Return
}

;Control Functions

ChangeText(WindowID,ControlName)
{
 ControlGetText, Temp1, %ControlName%, ahk_id %WindowID%
 InputBox, Temp1, New Text, Please enter the new label for this control.,, W, H,,,,, %Temp1%
 If Not ErrorLevel
  ControlSetText, %ControlName%, %Temp1%, ahk_id %WindowID%
}

HideControl(WIndowID,ControlName)
{
 Control, Hide,, %ControlName%, ahk_id %WindowID%
 MsgBox, 64, Success, Control has been hidden.
}

ToggleDisabled(WindowID,ControlName)
{
 ControlGet, Temp1, Enabled,, %ControlName%, ahk_id %WindowID%
 If Temp1
 {
  Control, Disable,, %ControlName%, ahk_id %WindowID%
  MsgBox, 64, Success, Control has been disabled.
 }
 Else
 {
  Control, Enable,, %ControlName%, ahk_id %WindowID%
  MsgBox, 64, Success, Control has been disabled.
 }
}

AddEntry(WindowID,ControlName)
{
 ControlTypes = ListBox,ComboBox
 If ControlName Not Contains %ControlTypes%
 {
  MsgBox, 64, Control Type, This feature only works with the following controls:`n`n%ControlTypes%
  Return
 }
 InputBox, Temp1, New Entry, Please enter a new entry for this control.,, W, H
 If ErrorLevel
  Return
 Control, Add, %Temp1%, %ControlName%, ahk_id %WindowID%
}

RemoveEntry(WindowID,ControlName)
{
 ControlTypes = ListBox,ComboBox
 If ControlName Not Contains %ControlTypes%
 {
  MsgBox, 64, Control Type, This feature only works with the following controls:`n`n%ControlTypes%
  Return
 }
 InputBox, Temp1, New Entry, Please enter the numerical position of the entry to remove.,, W, H
 If ErrorLevel
  Return
 If Temp1 Is Not Digit
 {
  MsgBox, 64, Remove Entry, Position must be a number between 1 and the number of entries in the control.
  Return
 }
 Control, Add, %Temp1%, %ControlName%, ahk_id %WindowID%
}

SelectWindow()
{
 SelectButton = RButton
 Gui, 99:Color, Black
 Gui, 99:-Caption +ToolWindow +LastFound +E0x20
 WinSet, Transparent, 100
 SetTimer, Darken, 800
 Gosub, Darken
 Hotkey, %SelectButton%, Null
 KeyWait, %SelectButton%, D
 KeyWait, %SelectButton%
 SetTimer, Darken, Off
 Gui, 99:Destroy
 MouseGetPos,,, WindowID
 ToolTip
 Hotkey, %SelectButton%, Off
 Return, WindowID

 Darken:
 MouseGetPos,,, TempID
 WinGetPos, TempX, TempY, TempW, TempH, ahk_id %TempID%
 If TempID = %TempID1%
 {
  If ((TempX = TempX1) && (TempY = TempY1))
   Return
 }
 Gui, 99:+AlwaysOnTop
 Gui, 99:Show, x%TempX% y%TempY% w%TempW% h%TempH% NoActivate
 ToolTip, Press %SelectButton% on a window to select it.
 TempID1 = %TempID%
 TempX1 = %TempX%
 TempY1 = %TempY%
 Return
}

SelectControl(WindowID)
{
 SelectButton = RButton
 ControlTypes = SysTreeView32,SysListView32,Button,Edit,ComboBox,ListBox,SysDateTimePick32,SysMonthCal32,msctls_trackbar32,msctls_hotkey32,SysTabControl32

 Gui, 99:Color, Black
 Gui, 99:-Caption +ToolWindow +LastFound +E0x20
 WinSet, Transparent, 100
 SetTimer, ControlDarken, 800
 Gosub, ControlDarken
 Hotkey, %SelectButton%, Null
 KeyWait, %SelectButton%, D
 KeyWait, %SelectButton%
 SetTimer, ControlDarken, Off
 Gui, 99:Destroy
 MouseGetPos,,,, TempControl
 If TempControl Not Contains %ControlTypes%
  Return
 ToolTip
 Hotkey, %SelectButton%, Off
 Return, TempControl

 ControlDarken:
 MouseGetPos,,,, TempControl
 If TempControl = %TempControl1%
  Return
 If TempControl Not Contains %ControlTypes%
 {
  Gui, 99:Hide
  Return
 }
 ControlGetPos, TempX, TempY, TempW, TempH, %TempControl%, ahk_id %WindowID%
 WinGetPos, OffsetX, OffsetY,,, ahk_id %WindowID%
 TempX += OffsetX
 TempY += OffsetY
 Gui, 99:+AlwaysOnTop
 Gui, 99:Show, x%TempX% y%TempY% w%TempW% h%TempH% NoActivate
 ToolTip, Press %SelectButton% on a control to select it.
 TempControl1 = %TempControl%
 Return
}

Null:
Return