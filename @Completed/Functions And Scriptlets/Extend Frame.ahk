;AHK v1
#NoEnv

/*
Gui, +LastFound -Caption +Resize
ExtendFrame(WinExist())
Gui, Add, Button,, Hello`, World!
Gui, Color, Black
Gui, Show, w200 h200
Return

GuiEscape:
GuiClose:
ExitApp
*/

ExtendFrame(hWindow,Left = -1,Right = -1,Top = -1,Bottom = -1)
{
    VarSetCapacity(Rectangle,16)
    NumPut(Left,Rectangle,0,"Int"), NumPut(Right,Rectangle,4,"Int"), NumPut(Top,Rectangle,8,"Int"), NumPut(Bottom,Rectangle,12,"Int")
    UPtr := A_PtrSize ? "UPtr" : "UInt"
    DllCall("dwmapi\DwmExtendFrameIntoClientArea",UPtr,hWindow,UPtr,&Rectangle)
}