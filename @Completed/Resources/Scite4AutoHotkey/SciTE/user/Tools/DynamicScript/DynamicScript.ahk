#NoEnv

Path := A_ScriptDir . "\Script.ahk"

Running := False

If FileExist(Path)
    FileRead, Script, %Path%
Else
    Script := "MsgBox, Hello`, World!"

Gui, Font, s14 Bold, Arial
Gui, Add, Text, x0 y0 h30 Center vTitle, Code:
Gui, Font, s10 Norm, Courier New
Gui, Add, Edit, x10 y30 vScript Multi, %Script%
Gui, Font, Bold, Arial
Gui, Add, Button, x10 h30 vExecute gExecute Default, Execute
Gui, +Resize +MinSize300x200
Gui, Show, w400 h270, Dynamic Execution
OnExit, SaveScript
Return

GuiEscape:
GuiClose:
ExitApp

SaveScript:
Gui, Submit, NoHide
FileDelete, %Path%
FileAppend, %Script%, %Path%
ExitApp

GuiSize:
GuiControl, Move, Title, w%A_GuiWidth%
GuiControl, Move, Script, % "w" . (A_GuiWidth - 20) . " h" . (A_GuiHeight - 70)
GuiControl, Move, Execute, % "y" . (A_GuiHeight - 40) . " w" . (A_GuiWidth - 20)
WinSet, Redraw
Return

Execute:
Gui, Submit, NoHide
FileDelete, %Path%
FileAppend, %Script%, %Path%

GuiControl, Disable, Execute
RunWait, %Path%
GuiControl, Enable, Execute
Return