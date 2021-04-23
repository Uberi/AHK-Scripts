#NoEnv

Gui, Font, s36
Gui, Add, Text, x0 y0 w500 h300 Center gDrag, Drag Me
Gui, -Caption
Gui, Show, w500 h300, Draggable Window
Return

GuiClose:
ExitApp

Drag:
Gui, +LastFound
PostMessage, 0xA1, 2
Return