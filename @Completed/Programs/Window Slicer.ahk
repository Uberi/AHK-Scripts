#NoEnv

WindowOpacity := 200
MinSize := 30

CoordMode, Mouse, Relative
CoordMode, ToolTip, Relative
SetWinDelay, 0
Return

+Space::
Gui, TitleBar:Destroy
SelectWindow()
SelectRegion(RegionX,RegionY,RegionW,RegionH)
WinGet, PreviousOpacity, Transparent, ahk_id %WindowID%
If (PreviousOpacity = "")
    PreviousOpacity := "Off"

Gui, TitleBar:+LastFound
If Round(WindowOpacity) = 255
{
    WinSet, Transparent, Off
    WinSet, Transparent, Off, ahk_id %WindowID%
}
Else
{
    WinSet, Transparent, %WindowOpacity%
    WinSet, Transparent, %WindowOpacity%, ahk_id %WindowID%
}
WinGet, PreviousStyle, Style, ahk_id %WindowID%
WinSet, Style, -0xC40000, ahk_id %WindowID%
WinSet, AlwaysOnTop, On, ahk_id %WindowID%
WinSet, Region, %RegionX%-%RegionY% w%RegionW% h%RegionH% r5-5, ahk_id %WindowID%

WinGetPos, TempX, TempY,,, ahk_id %WindowID%

Gui, TitleBar:Add, Text, x5 y1 w25 h20 gMoveWin, ::::::::
Gui, TitleBar:Add, Button, x32 y1 w50 h20 Default gToggleDisable vToggleDisable, Disable
Gui, TitleBar:Add, Button, x82 y1 w50 h20 gRestoreWin, Restore
Gui, TitleBar:Add, Button, x132 y1 w80 h20 gChangeOpacity, Opacity
Gui, TitleBar:+AlwaysOnTop -Caption +ToolWindow
WinSet, Region, 0-0 w215 h23 R10-10

Gui, TitleBar:Show, % "x" . (RegionX + TempX) . " y" . (RegionY + TempY - 23) . " w215 h23"
Return

GuiClose:
Return

MoveWin:
MouseGetPos, PosX, PosY
Gui, TitleBar:+LastFound
WinGetPos, TempX, TempY
WinGetPos, OffsetX, OffsetY,,, ahk_id %WindowID%
OffsetX -= TempX
OffsetY -= TempY
SetTimer, DragWin, 100

DragWin:
If !GetKeyState("LButton","P")
{
    SetTimer, DragWin, Off
    Return
}
CoordMode, Mouse
MouseGetPos, TempX, TempY
Gui, TitleBar:+LastFound
WinMove,,, TempX - PosX, TempY - PosY
WinMove, ahk_id %WindowID%,, (TempX + OffsetX) - PosX, (TempY + OffsetY) - PosY
Return

ToggleDisable:
Gui, TitleBar:+LastFound
If WinDisabled
{
    WinDisabled := False
    WinSet, Enable,, ahk_id %WindowID%
    WinSet, ExStyle, -0x20, ahk_id %WindowID%
    GuiControl, TitleBar:, ToggleDisable, Disable
}
Else
{
    WinDisabled := True
    WinSet, ExStyle, +0x20, ahk_id %WindowID%
    WinSet, Disable,, ahk_id %WindowID%
    GuiControl, TitleBar:, ToggleDisable, Enable
}
Return

ChangeOpacity:
WindowOpacity /= 2.55
Gui, OpacitySettings:Add, Text, x2 y0 w70 h20 +Left, Opacity:
Gui, OpacitySettings:Add, Edit, x72 y0 w50 h20 gUpdateSlider vUpdateSlider
Gui, OpacitySettings:Add, UpDown, vWindowOpacity gWindowOpacity, %WindowOpacity%
Gui, OpacitySettings:Add, Slider, x2 y20 w120 h30 AltSubmit vSlidingTrans gSlidingTrans, %WindowOpacity%
Gui, OpacitySettings:Add, Button, x2 y52 w120 h20 Default gSaveOpacity, OK
Gui, OpacitySettings:+ToolWindow -Border +LastFound +AlwaysOnTop
WindowOpacity *= 2.55
GuiControl, OpacitySettings:Focus, SlidingTrans
Gui, OpacitySettings:Show, w125 h73, Opacity Settings
Return

UpdateSlider:
GuiControlGet, Temp1, OpacitySettings:, UpdateSlider
GuiControl, OpacitySettings:, SlidingTrans, %Temp1%
Return

WindowOpacity:
GuiControl, OpacitySettings:, SlidingTrans, %WindowOpacity%
Return

SlidingTrans:
GuiControl, OpacitySettings:, WindowOpacity, %SlidingTrans%
Return

SaveOpacity:
GuiControlGet, WindowOpacity, OpacitySettings:, WindowOpacity
Gui, OpacitySettings:Destroy
WindowOpacity *= 2.55
Gui, TitleBar:+LastFound
If Round(WindowOpacity) = 255
{
    WinSet, Transparent, Off
    WinSet, Transparent, Off, ahk_id %WindowID%
}
Else
{
    If WindowOpacity < 51
        WinSet, Transparent, 51
    Else
        WinSet, Transparent, %WindowOpacity%
    WinSet, Transparent, %WindowOpacity%, ahk_id %WindowID%
}
Return

RestoreWin:
RestoreWin()
Gui, TitleBar:Destroy
Return

Null:
Return

SelectWindow()
{
    global WindowID
    SelectButton = RButton
    Gui, SelectionArea:Color, Black
    Gui, SelectionArea:-Caption +ToolWindow +LastFound +AlwaysOnTop +E0x20
    WinSet, Transparent, 100
    SetTimer, Darken, 800
    Gosub, Darken
    Hotkey, %SelectButton%, Null, On
    KeyWait, %SelectButton%, D
    KeyWait, %SelectButton%
    SetTimer, Darken, Off
    Gui, SelectionArea:Destroy
    MouseGetPos,,, WindowID
    ToolTip
    Hotkey, %SelectButton%, Off
    Return

    Darken:
    MouseGetPos,,, TempID
    If (TempID = TempID1)
        Return
    WinGetPos, TempX, TempY, TempW, TempH, ahk_id %TempID%
    Gui, SelectionArea:Show, x%TempX% y%TempY% w%TempW% h%TempH% NoActivate
    ToolTip, Press %SelectButton% on a window to select it.
    TempID1 := TempID
    Return
}

SelectRegion(ByRef RegionX,ByRef RegionY,ByRef RegionW,ByRef RegionH)
{
    global WindowID
    global MinSize
    DragKey := "LButton"
    ControlKey := "RButton"
    ConfirmKey := "Enter"
    Gui, SelectionArea:Color, Black
    Gui, SelectionArea:-Caption +ToolWindow +LastFound +AlwaysOnTop
    WinSet, Transparent, 100
    WinActivate, ahk_id %WindowID%
    WinGetPos, TempX, TempY, TempW, TempH, ahk_id %WindowID%
    Gui, SelectionArea:+LastFound
    Gui, SelectionArea:Show, x%TempX% y%TempY% w%TempW% h%TempH% NoActivate
    Hotkey, %DragKey%, Drag, On
    Hotkey, %ControlKey%, ControlSelect, On
    Loop
    {
        ToolTip, Drag %DragKey% over the region to keep on top`, or press %ControlKey% to select a control. Press %ConfirmKey% when done
        Hotkey, %ConfirmKey%, Null, On
        KeyWait, %ConfirmKey%, D
        KeyWait, %ConfirmKey%
        ToolTip
        If (SelectX = "")
            Continue
        If (SelectY = "")
            Continue
        If (SelectX > SelectW)
            Temp1 := SelectX, SelectX := SelectW, SelectW := Temp1
        If (SelectY > SelectH)
            Temp1 := SelectY, SelectY := SelectH, SelectH := Temp1
        RegionX := SelectX
        RegionY := SelectY
        RegionW := Abs(SelectW - SelectX)
        RegionH := Abs(SelectH - SelectY)
        If (RegionW < MinSize || RegionH < MinSize)
        {
            ToolTip, The width and height of selection must be at least %MinSize% pixels each.
            WinSet, Region
            Sleep, 2000
        }
        Else
            Break
    }
    Gui, SelectionArea:Destroy
    Hotkey, %DragKey%, Off
    Hotkey, %ControlKey%, Off
    Hotkey, %ConfirmKey%, Off
    Return

    Drag:
    MouseGetPos, SelectX, SelectY
    SelectY -= TitleBarSize
    WinGetPos,,, TempW, TempH, ahk_id %WindowID%
    If (SelectX < 0 || SelectY < 0 || SelectX > TempW || SelectY > TempH)
        Return
    SetTimer, ResizeSelection, 100

    DragUp:
    If !GetKeyState(DragKey,"P")
    {
        SetTimer, ResizeSelection, Off
        Return
    }
    Return

    ResizeSelection:
    MouseGetPos, SelectW, SelectH
    If (SelectW = SelectW1 && SelectH = SelectH1)
        Return
    If SelectW < 0
        SelectW = 0
    If SelectH < 0
        SelectH = 0
    If (SelectW > TempW)
        SelectW := TempW
    If (SelectH > TempH)
        SelectH := TempH
    Gui, SelectionArea:+LastFound
    If !GetKeyState(DragKey,"P")
    {
        SetTimer, ResizeSelection, Off
        Return
    }
    WinSet, Region, 0-0 %TempW%-0 %TempW%-%TempH% 0-%TempH% 0-0 %SelectX%-%SelectY% %SelectW%-%SelectY% %SelectW%-%SelectH% %SelectX%-%SelectH% %SelectX%-%SelectY%
    SelectW1 = %SelectW%
    SelectH1 = %SelectH%
    Return

    ControlSelect:
    Gui, SelectionArea:Hide
    MouseGetPos,,,, hControl, 2
    Gui, SelectionArea:Show
    ControlGetPos, SelectX, SelectY, SelectW, SelectH,, ahk_id %hControl%
    SelectW += SelectX, SelectH += SelectY
    Gui, SelectionArea:+LastFound
    WinSet, Region, 0-0 %TempW%-0 %TempW%-%TempH% 0-%TempH% 0-0 %SelectX%-%SelectY% %SelectW%-%SelectY% %SelectW%-%SelectH% %SelectX%-%SelectH% %SelectX%-%SelectY%
    ToolTip %SelectX% %SelectY%`n%SelectW% %SelectH%
    Return
}

RestoreWin()
{
    global WindowID
    global PreviousOpacity
    global PreviousStyle
    WinSet, Enable,, ahk_id %WindowID%
    WinSet, Region,, ahk_id %WindowID%
    WinSet, AlwaysOnTop, Off, ahk_id %WindowID%
    WinSet, Transparent, %PreviousOpacity%, ahk_id %WindowID%
    WinSet, Style, %PreviousStyle%, ahk_id %WindowID%
    WinGetPos, X, Y,,, ahk_id %WindowID%
    If Y < 0
        WinMove, ahk_id %WindowID%,, %X%, 0
}