#NoEnv

Gui, Font, s16 Bold, Arial
Gui, Add, Text, x2 y0 w120 h30, Characters:
Gui, Add, Text, x122 y0 w60 h30 Right vCurrentLength, 0
Gui, Add, Text, x182 y0 w20 h30 Center, /
Gui, Add, Edit, x202 y0 w60 h30 Right Number Limit vMaxLength gLimitText, 200
Gui, Font, Norm
Gui, Add, Edit, x2 y40 w260 h130 -VScroll vLimitedText gLimitText, Text Goes Here
Gui, Add, Button, x2 y180 w260 h30 Default vCopy gCopy, Copy
Gosub, LimitText
Gui, Show, w265 h210, Text Length
Return

GuiClose:
ExitApp

LimitText:
Gui, Submit, NoHide
CurrentLength := StrLen(LimitedText)
If CurrentLength > %MaxLength%
 GuiControl, Disable, Copy
Else
 GuiControl, Enable, Copy
GuiControl,, CurrentLength, %CurrentLength%
Return

Copy:
GuiControlGet, Clipboard,, LimitedText
Return