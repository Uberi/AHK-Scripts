/*
Light: Flash Cards Creator
by: tidbit

You may use enters and tabs to format the text to your liking.
*/
Gui, Add, Button, x166 y8 w60 h20 gfile, Save As
Gui, Add, edit, x26 y8 w138 h20 vfile,
Gui, Add, Edit, x26 y38 w200 h150 vq +wanttab,
Gui, Add, Edit, x26 y198 w200 h150 va +wanttab,
Gui, Add, Button, x26 y358 w50 h20 gclear, Clear
Gui, Add, Button, x96 y358 w60 h20 gopen, Open
Gui, Add, Button, x176 y358 w50 h20 gadd, Add
Gui, font, bold
Gui, Add, Text, x6 y58 w20 , Q`nu`ne`ns`nt`ni`no`nn
Gui, Add, Text, x6 y228 w20 , A`nn`ns`nw`ne`nr
Gui, font, norm
GuiControl, Disable, q,
GuiControl, Disable, a,
; Generated using SmartGUI Creator 4.0
Gui, Show, x131 y91, Light Editor`,By: tidbit
Return

file:
	fileselectfile, file, S2, %A_ScriptDir%, Where to save this library, Libraries (*.txt; *.Lib; *.light)
	If Errorlevel
		Return
	GuiControl, , file, %file%
	GuiControl, Enable, q
	GuiControl, Enable, a
return

add:
	q=
	a=
	Gui, Submit, NoHide
	If (RegExMatch(q, "^\s*$") || RegExMatch(a, "^\s*$") || RegExMatch(File, "^\s*$"))
	{
		msgbox, 48, ERROR, Please don't leave the Save As field, Question field or Answer field blank.`nDoing so may cause issues.
		Return
	}
	q := RegExReplace(q, "\n", "``n")
	q := RegExReplace(q, "\t", "``t")
	a := RegExReplace(a, "\n", "``n")
	a := RegExReplace(a, "\t", "``t")

	Fileappend, `n%q%%A_tab%%a%, %file%
return

open:
	Gui, submit, nohide
	if RegExMatch(File, "^\s*$")
	{
		Msgbox, You need to choose a file first.
		Return
	}
	Run, %file%
return

clear:
	GuiControl, , a,
	GuiControl, , q,
return

GuiClose:
	ExitApp