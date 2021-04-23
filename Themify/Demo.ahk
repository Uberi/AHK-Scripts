#Include <Themify>

Gui, Font, q4 s36 cGray, Segoe UI
Gui, Add, Text, x10 y0 w330 h80, buttons
Gui, Font, s10 cBlack
Gui, Add, Button, x50 y90 w100 h40 hwndhButton1, ABCDEF
Gui, Add, Button, x200 y90 w100 h40 hwndhButton2 +Default, ghijkl
Gui, Add, Button, x350 y90 w100 h40 hwndhButton3 +Disabled, I'm disabled!

Theme1 := new Themify.Button(hButton1)
Theme2 := new Themify.Button(hButton2)
Theme3 := new Themify.Button(hButton3)

Gui, Color, 5A5555
Gui, +ToolWindow +AlwaysOnTop
Gui, Show, w500 h180, Ownerdraw
Return

GuiEscape:
GuiClose:
ExitApp