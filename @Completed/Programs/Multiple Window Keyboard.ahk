#NoEnv

Windows := []

hWindow := SelectWindow("Select the first window")
If !hWindow
    ExitApp
Windows.Insert(hWindow)

hWindow := SelectWindow("Select the second window")
If !hWindow
    ExitApp
Windows.Insert(hWindow)

Keys := "abcdefghijklmnopqrstuvwxyz0123456789"
Loop, Parse, Keys
    Hotkey, %A_LoopField%, SendKey
Return

SendKey:
SendWindows(A_ThisHotkey,Windows)
Return

SendWindows(Keys,WindowList)
{
    For Index, hWindow In WindowList
        ControlSend,, %Keys%, ahk_id %hWindow%
}

SelectWindow(Prompt = "Select a window")
{
    Gui, SelectWindow:Color, Black
    Gui, SelectWindow:Font, s18 q4 cWhite, Arial
    Gui, SelectWindow:Add, Text, x50 y50, Right click`nEscape
    Gui, SelectWindow:Add, Text, x250 y50, Select`nCancel
    Gui, SelectWindow:Font, s36
    Gui, SelectWindow:Add, Text, x50 y150, %Prompt%
    Gui, SelectWindow:-Caption +ToolWindow +LastFound +E0x20
    WinSet, Transparent, 100
    SetTimer, SelectWindowDarken, 100
    Gosub, SelectWindowDarken
    Cancel := False
    Selected := 0
    Hotkey, RButton, SelectWindowConfirm, On
    Hotkey, Esc, SelectWindowCancel, On
    While, !(Selected || Cancel)
        Sleep, 10
    SetTimer, SelectWindowDarken, Off
    Gui, SelectWindow:Destroy
    MouseGetPos,,, WindowID
    ToolTip
    If Cancel
    {
        KeyWait, Esc
        Hotkey, Esc, Off
        Return, 0
    }
    KeyWait, RButton
    Hotkey, RButton, Off
    Return, Selected

    SelectWindowDarken:
    MouseGetPos,,, TempID
    If (TempID = TempID1)
        Return
    WinGetPos, TempX, TempY, TempW, TempH, ahk_id %TempID%
    Gui, SelectWindow:Show, x%TempX% y%TempY% w%TempW% h%TempH% NoActivate
    Gui, SelectWindow:+AlwaysOnTop
    TempID1 := TempID
    Return

    SelectWindowConfirm:
    Selected := TempID
    Return

    SelectWindowCancel:
    Cancel := True
    Return
}