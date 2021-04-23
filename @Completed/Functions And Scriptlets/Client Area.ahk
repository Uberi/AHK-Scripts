#NoEnv

/*
Gui, 1:+LastFound
Gui, 1:Show, w200 h100

GetFrameSize(WinExist(),ClientX,ClientY)
MsgBox %ClientX% %ClientY%
Return

GuiClose:
ExitApp
*/

GetFrameSize(hWindow,ByRef ClientX,ByRef ClientY)
{
    DetectHidden := A_DetectHiddenWindows
    DetectHiddenWindows, On
    WinGetPos, PosX, PosY,,, ahk_id %hWindow%
    DetectHiddenWindows, %DetectHidden%

    VarSetCapacity(ClientPoint,8,0)
    If DllCall("ClientToScreen","UInt",hWindow,"UPtr",&ClientPoint)
    {
        ClientX := NumGet(ClientPoint,0,"UInt") - PosX, ClientY := NumGet(ClientPoint,4,"UInt") - PosY
        If (ClientX > 0 && ClientY > 0)
            Return, 0
    }
    Return, 1
}