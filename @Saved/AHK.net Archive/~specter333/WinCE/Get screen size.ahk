#SingleInstance Force
Gui, Color, Blue

Gui, Add, Edit, x5 y5 w40 r1 vEdit1, %A_ScreenWidth%
Gui, Add, Text, x+5, Screen_Width.

Gui, Add, Edit, x5 y+10 w40 r1 vEdit2, %A_ScreenHeight%
Gui, Add, Text, x+5, Screen_Hieght.

Gui, Add, Edit, x5 y+10 w40 r1 vEdit3, 
Gui, Add, Text, x+5, Gui_Width.

Gui, Add, Edit, x5 y+10 w40 r1 vEdit4, 
Gui, Add, Text, x+5, Gui_Hieght.

Gui, Add, Button, x5 y120 gMax, Maximize
Gui, Add, Button, x+5 gRes, Restore
Gui, Add, Button, x+5 gExit, Exit

Gui, +Resize  ;-Caption
Gui, Show, w170 h150, Screen Size
Return

GuiSize:
GuiControl, , Edit3, %A_GuiWidth%
GuiControl, , Edit4, %A_GuiHeight%
Return

Max:
Gui, Show,  Maximize
Return

Res:
Gui, Show,  Restore
Return

Esc:
Exit:
GuiClose:
Gui, Destroy
ExitApp