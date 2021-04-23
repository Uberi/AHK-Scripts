#NoEnv

Loop
{
    hWindow := WinExist("A") ;get the active window
    ControlGetFocus, CurrentControl, ahk_id %hWindow% ;get the currently focused control
    If RegExMatch(CurrentControl,"S)Edit\d") ;current control is an edit control
    {
        ControlGet, Line, CurrentLine
        ControlGet, Value, Line, %Line%
        ToolTip, The current line is "%Value%".
    }
    Sleep, 100
}