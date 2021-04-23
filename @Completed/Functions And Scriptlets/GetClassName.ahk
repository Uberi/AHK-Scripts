#NoEnv

Gui, Add, Edit, hwndhControl, Test 123
Gui, +LastFound
hWindow := WinExist()
MsgBox % "The class of the window is: " . GetClassFromHwnd(hWindow) . "`n"
    . "The class of the edit control is: " . GetClassFromHwnd(hControl) . "`n"
    . "The class of the edit control is: " . GetClassFromClassNN(hWindow,"Edit1")
ExitApp

GetClassFromHwnd(hWindow)
{
    VarSetCapacity(Name, 256, 0)
    Count := DllCall("GetClassName","UPtr",hWindow,"UPtr",&Name,"Int",256,"Int")
    Return, StrGet(&Name,Count,"UTF-16")
}

GetClassFromClassNN(hWindow, ClassNN)
{
    ControlGet, hControl, Hwnd,, %ClassNN%, ahk_id %hWindow%
    VarSetCapacity(Name, 256, 0)
    Count := DllCall("GetClassName","UPtr",hControl,"UPtr",&Name,"Int",256,"Int")
    Return, StrGet(&Name,Count,"UTF-16")
}