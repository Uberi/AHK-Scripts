#NoEnv

/*
hWindow := WinExist("A")
PreventRedraw(hWindow)
Sleep, 3000
AllowRedraw(hWindow)
ExitApp
*/

PreventRedraw(hWindow)
{
    SendMessage, 0xB, 0, 0,, ahk_id %hWindow% ;WM_SETREDRAW: prevent the window from redrawing
}

AllowRedraw(hWindow)
{
    SendMessage, 0xB, 1, 0,, ahk_id %hWindow% ;WM_SETREDRAW: allow the window to redraw
}