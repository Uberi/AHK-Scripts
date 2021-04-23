#NoEnv

Transparency := 150

Gui, Color, Black
Gui, -Caption +ToolWindow +E0x20 +AlwaysOnTop +LastFound
WinSet, Transparent, %Transparency%
Gui, Show, x0 y0 w%A_ScreenWidth% h%A_ScreenHeight% NoActivate
Return

GuiClose:
Return

^PGUP::
If Transparency <= 10
    Return
Transparency -= 10
Gui, +LastFound
WinSet, Transparent, %Transparency%
Return

^PGDN::
If Transparency >= 230
    Return
Transparency += 10
Gui, +LastFound
WinSet, Transparent, %Transparency%
Return