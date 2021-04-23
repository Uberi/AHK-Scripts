CoordMode, Mouse, Screen

Gui, CrosshairHorizontal:Color, Red
Gui, CrosshairHorizontal:-Caption +ToolWindow +E0x20 +AlwaysOnTop +LastFound
WinSet, Transparent, 150
Gui, CrosshairVertical:Color, Red
Gui, CrosshairVertical:-Caption +ToolWindow +E0x20 +AlwaysOnTop +LastFound
WinSet, Transparent, 150
SetTimer, Update, 50

Update:
MouseGetPos, X, Y
Gui, CrosshairVertical:Show, x%X% y0 w1 h%A_ScreenHeight% NoActivate
Gui, CrosshairHorizontal:Show, x0 y%Y% w%A_ScreenWidth% h1 NoActivate
Return