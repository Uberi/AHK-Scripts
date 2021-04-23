#NoEnv

ScrollBack := ""

Gui, Add, Edit, x10 y10 vScrollBack hwndhScrollBack Multi ReadOnly
Gui, Add, Edit, x10 h20 vInputText
Gui, Add, Button, w50 h20 vAppendLine gAppendLine Default, Add
Gui, +Resize +MinSize100x100
GuiControl, Focus, InputText
Gui, Show, w390 h400, Test
Return

GuiClose:
ExitApp

;GuiSize:
GuiControl, Move, ScrollBack, % "w" . (A_GuiWidth - 20) . " h" . (A_GuiHeight - 50)
GuiControl, Move, InputText, % "y" . (A_GuiHeight - 30) . " w" . (A_GuiWidth - 70)
GuiControl, Move, AppendLine, % "x" . (A_GuiWidth - 60) . " y" . (A_GuiHeight - 30)
Return

AppendLine:
;add the text to the scrollback, clear the input, and scroll to the bottom of the control
GuiControlGet, InputText,, InputText
InputText .= "`n"
GuiControl,, InputText ;clear the input control
SendMessage, 0x0E, 0, 0,, ahk_id %hScrollBack% ;WM_GETTEXTLENGTH
SendMessage, 0xB1, ErrorLevel, ErrorLevel,, ahk_id %hScrollBack% ;EM_SETSEL
SendMessage, 0xC2, 0, &InputText,, ahk_id %hScrollBack% ;EM_REPLACESEL

;scroll to the bottom of the edit control
;SendMessage, 0x115, 7, 0,, ahk_id %hScrollBack% ;WM_VSCROLL
Return