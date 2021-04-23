#NoEnv

/*
SetBatchLines, -1
ShellHook(A_ScriptHwnd)
Return

Esc::ExitApp
*/

ShellHook(hWindow)
{
    DllCall("RegisterShellHookWindow","UPtr",A_ScriptHwnd)
    OnMessage(DllCall("RegisterWindowMessage","Str","SHELLHOOK"),"ShellHookMessage")
}
 
ShellHookMessage(wParam,lParam)
{
    ;http://msdn.microsoft.com/en-us/library/windows/desktop/ms644989(v=vs.85).aspx
    static Messages := Object(1,     "HSHELL_WINDOWCREATED"
                             ,2,     "HSHELL_WINDOWDESTROYED"
                             ,3,     "HSHELL_ACTIVATESHELLWINDOW"
                             ,4,     "HSHELL_WINDOWACTIVATED"
                             ,5,     "HSHELL_GETMINRECT"
                             ,6,     "HSHELL_REDRAW"
                             ,7,     "HSHELL_TASKMAN"
                             ,8,     "HSHELL_LANGUAGE"
                             ,9,     "HSHELL_SYSMENU"
                             ,10,    "HSHELL_ENDTASK"
                             ,11,    "HSHELL_ACCESSIBILITYSTATE"
                             ,12,    "HSHELL_APPCOMMAND"
                             ,13,    "HSHELL_WINDOWREPLACED"
                             ,14,    "HSHELL_WINDOWREPLACING"
                             ,0x8006,"HSHELL_FLASH"
                             ,0x8004,"HSHELL_RUDEAPPACTIVATED")
    ToolTip, % "Received message " . Messages[wParam] . " with lParam " . lParam . "."
}