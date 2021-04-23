/*
Title: Your Calculator
Compiled/Written 01.16.2008 by labouche10
This is just a basic calculator that I wrote that was inspired by my favorite calculator. 
I wrote this for the people in my office to use.
I'm a noob so don't come down on me too hard! I hope someone can use this as much as I know I will.
*/


#NoEnv
SendMode Input
SetWorkingDir %A_ScriptDir%
CoordMode, tooltip, relative
groupadd, calculatorgroup, %A_Username%'s Calculator

; Add Menus
Menu, FileMenu, add, &Print           Ctrl+P, printout
Menu, FileMenu, add, &Save          Ctrl+S, save
Menu, FileMenu, add, Save &As     Ctrl+Shift+S, saveas
Menu, FileMenu, add, E&xit            Alt+F4, guiclose
Menu, MyMenuBar, Add, &File, :FileMenu
Menu, EditMenu, add, &Copy History      Ctrl+C, copyhistorytoclipboard
Menu, EditMenu, add, Clear History      Ctrl+Backspace, clearhistory
Menu, EditMenu, add, &Undo Clear         Ctrl+Z, undoclearhistory
Menu, MyMenuBar, Add, &Edit, :EditMenu

; Gui functions
Gui, Menu, MyMenuBar
Gui, +Resize +MinSize
Gui, Color, 0xD2E8F2, 0xFFFFFF
Gui, font, s10 bold c2D7597, copperplate gothic
Gui, add, text,, Description
Gui, font, s10 norm cblack, copperplate gothic
Gui, add, edit, w175 R1 +veditdescription
Gui, font, s10 bold c2D7597, copperplate gothic
Gui, add, text,, History
Gui, font, s10 norm cblack, copperplate gothic
Gui, add, edit, w175 h200 +readonly +vedithistory
Gui, font, s10 bold c2D7597, copperplate gothic
Gui, add, text,+vinput, Input
Gui, Font, s12 bold cblack, copperplate gothic
Gui, add, edit, w175 R1 +veditcalculate
Gui, Font, s10 norm, copperplate gothic
Guicontrol, +0x40, edithistory
Guicontrol, focus, editcalculate
Gui, Show,, %A_Username%'s Calculator
Return

; Context sensitive GUI hotkeys 
#IfWinActive ahk_group calculatorgroup
Enter::
Gosub, Calculate
Return

; The following four functions use the most recent result as the first argument when pressing only +,-,*,/ 
NumpadAdd::
Gui, Submit, NoHide
If editcalculate =
{
	ControlGetFocus, focusvar, ahk_group calculatorgroup
	If focusvar = edit3
	{
		If answerall =
		{
			ToolTip, Enter a numerical calculation., % A_GuiWidth - 5, % A_GuiHeight - 5
			SetTimer, Removetooltip, 5000
			Return
		}
		Else
			Sendraw, answer+
	}
	Else
		Sendraw, +
}
Else
	Sendraw, +
Return

NumpadSub::
Gui, Submit, NoHide
If editcalculate =
{
	ControlGetFocus, focusvar, ahk_group calculatorgroup
	If focusvar = edit3
	{
		If answerall =
		{
			ToolTip, Enter a numerical calculation., % A_GuiWidth - 5, % A_GuiHeight - 5
			SetTimer, Removetooltip, 5000
			Return
		}
		Else
			Sendraw, answer-
	}
	Else
		Sendraw, -
}
Else
	Sendraw, -
Return

NumpadMult::
Gui, Submit, NoHide
If editcalculate =
{
	ControlGetFocus, focusvar, ahk_group calculatorgroup
	If focusvar = edit3
	{
		If answerall =
		{
			ToolTip, Enter a numerical calculation., % A_GuiWidth - 5, % A_GuiHeight - 5
			SetTimer, Removetooltip, 5000
			Return
		}
		Else
			Sendraw, answer*
	}
	Else
		Sendraw, *
}
Else
	SendRaw, *
Return

NumpadDiv::
Gui, Submit, NoHide
If editcalculate =
{
	ControlGetFocus, focusvar, ahk_group calculatorgroup
	If focusvar = edit3
	{
		If answerall =
		{
			ToolTip, Enter a numerical calculation., % A_GuiWidth - 5, % A_GuiHeight - 5
			SetTimer, Removetooltip, 5000
			Return
		}
		Else
			Sendraw, answer/
	}
	Else
		Sendraw, /
}
Else
	Sendraw, /
Return

; This char doesn't belong in the edit box
=::
ControlGetFocus, focusvar, ahk_group calculatorgroup
If focusvar = edit3
{
	ToolTip, Enter a numerical calculation., % A_GuiWidth - 5, % A_GuiHeight - 5
	SetTimer, Removetooltip, 5000
	Return
}
Else
	Sendraw, =
Return

; Proceed with the calculation
NumPadEnter::
ControlGetFocus, focusvar, ahk_group calculatorgroup
If focusvar = edit3
	Gosub, Calculate
Else
	Sendinput, {Enter}
Return


; Print results in a sort of 'adding machine' output.
^p::
printout:
Gui, Submit, NoHide
FormatTime, currentime
edit = 
edit := "`nPrinted by: " . A_Username . "`n`nPrinted time: " . currentime . "`n`n`n`nDescription: " . editdescription . "`n`n`n`nCalculations:`n`n" . answerall
Print(edit)
Return

; Why would you want to save your results? I dunno if you want to then do it.
^s::
save:
If savefilename =
	Fileselectfile, savefilename, 2, %A_Desktop%\calchistory.rtf, Save As, *.rtf
Gui, Submit, NoHide
FormatTime, currentime
edit = 
edit := "`nPrinted by: " . A_Username . "`n`nPrinted time: " . currentime . "`n`n`n`nDescription: " . editdescription . "`n`n`n`nCalculations:`n`n" . answerall
fileappend, %edit%, %savefilename%
Return

^+s::
saveas:
Fileselectfile, savefilename, , %A_Desktop%\calchistory.rtf, Save As, *.rtf
savefilename := savefilename . ".rtf"
Gui, Submit, NoHide
FormatTime, currentime
edit = 
edit := "`nPrinted by: " . A_Username . "`n`nPrinted time: " . currentime . "`n`n`n`nDescription: " . editdescription . "`n`n`n`nCalculations:`n`n" . answerall
fileappend, %edit%, %savefilename%
Return


; Just a helpful idea (hopefully)
^c::
copyhistorytoclipboard:
clipboard := answerall
Return

; Clear the history box
^Backspace::
clearhistory:
Answerallbackup := Answerall
Answerall = 
Guicontrol, text, edithistory, %Answerall%
Return

; I wished my last calculator actually had this
^z::
Undoclearhistory:
If answerallbackup = 
	Return
Answerall := Answerallbackup
Guicontrol, text, edithistory, %Answerall%
ControlSend Edit2, ^{End}, ahk_group calculatorgroup
Return

; While in the 'Input' box this will just bring the last calculation back to be edited
up::						;Brings back the last calculation
Guicontrol, text, edit3, %editcalculatevar%
controlsend edit3, ^{End}, ahk_group calculatorgroup
Return


; The superficial portion of the calculation
Calculate:
Gui, Submit, NoHide
editcalculatevar := RegExReplace(editcalculate,"answer",answer)
workingvar := eval(editcalculatevar)
If workingvar is not number
{
	If answerall = 
	{
		answerall := "ERROR"
		ToolTip, ERROR: There is something wrong with your calculation. Check it and try again., A_GuiWidth - 5, A_GuiHeight - 5
		SetTimer, Removetooltip, 5000
	}
	Else
		answerall := answerall . "`nERROR"
		ToolTip, ERROR: There is something wrong with your calculation. Check it and try again., % A_GuiWidth - 5, % A_GuiHeight - 5
		SetTimer, Removetooltip, 5000
}
Else
{
	Loop,
	{
		stringright, rightvar, workingvar, 1
		if rightvar = .
		{
			Stringtrimright, workingvar, workingvar, 1
			answer := workingvar
			Continue
		}
		Else if rightvar = 0
		{
			Stringtrimright, workingvar, workingvar, 1
			answer := workingvar
			Continue
		}
		Else
		{
			answer := workingvar
			Break
		}
	
	}
	If answerall = 
	{
		answerall := editcalculate . " =`n                " . answer
		Guicontrol, text, editcalculate, 
	}
	Else
	{
		answerall := answerall . "`n" . editcalculate . " =`n                " . answer
		Guicontrol, text, editcalculate, 
	}
}
Guicontrol, text, edithistory, %Answerall%
ControlSend Edit2, ^{End}, ahk_group calculatorgroup
Return

removetooltip:
settimer, removetooltip, off
tooltip
return

guiclose:
exitapp



; FUNCTIONS



Eval(x)								; Thanks to Laszlo for this function! http://www.autohotkey.com/forum/topic26435.html&highlight=calculator
{ 
   StringGetPos i, x, +, R 
   StringGetPos j, x, -, R 
   If (i > j) 
      Return Left(x,i)+Right(x,i) 
   If (j > i) 
      Return Left(x,j)-Right(x,j) 
   StringGetPos i, x, *, R 
   StringGetPos j, x, /, R 
   If (i > j) 
      Return Left(x,i)*Right(x,i) 
   If (j > i) 
      Return Left(x,j)/Right(x,j) 
   Return x 
} 

Left(x,i) 
{ 
   StringLeft x, x, i 
   Return Eval(x) 
} 
Right(x,i) 
{ 
   StringTrimLeft x, x, i+1 
   Return Eval(x) 
}

Guisize:
settitlematchmode, 3
;Guicontrol, Move, edithistory, w100 h100
Anchor("editdescription", "w")
Anchor("edithistory", "wh")
Anchor("editcalculate", "yw")
Anchor("history", "yw")
Anchor("input", "yw")
controlgetpos, , yvar,,,edit2,Mike's Calculator
controlmove, static2,, yvar - 20,,,Mike's Calculator
Return

Anchor(i, a = "", r = false) {						; Thanks to Titan and all who contributed to the anchor function!
	static c, cs = 12, cx = 255, cl = 0, g, gs = 8, z = 0, k = 0xffff, gx = 1
	If z = 0
		VarSetCapacity(g, gs * 99, 0), VarSetCapacity(c, cs * cx, 0), z := true
	If a =
	{
		StringLeft, gn, i, 2
		If gn contains :
		{
			StringTrimRight, gn, gn, 1
			t = 2
		}
		StringTrimLeft, i, i, t ? t : 3
		If gn is not digit
			gn := gx
	}
	Else gn := A_Gui
	If i is not xdigit
	{
		GuiControlGet, t, Hwnd, %i%
		If ErrorLevel = 0
			i := t
		Else ControlGet, i, Hwnd, , %i%
	}
	gb := (gn - 1) * gs
	Loop, %cx%
		If (NumGet(c, cb := cs * (A_Index - 1)) == i) {
			If a =
			{
				cf = 1
				Break
			}
			Else gx := A_Gui
			d := NumGet(g, gb), gw := A_GuiWidth - (d >> 16 & k), gh := A_GuiHeight - (d & k), as := 1
				, dx := NumGet(c, cb + 4, "Short"), dy := NumGet(c, cb + 6, "Short")
				, dw := NumGet(c, cb + 8, "Short"), dh := NumGet(c, cb + 10, "Short")
			Loop, Parse, a, xywh
				If A_Index > 1
					av := SubStr(a, as, 1), as += 1 + StrLen(A_LoopField)
						, d%av% += (InStr("yh", av) ? gh : gw) * (A_LoopField + 0 ? A_LoopField : 1)
			DllCall("SetWindowPos", "UInt", i, "Int", 0, "Int", dx, "Int", dy, "Int", dw, "Int", dh, "Int", 4)
			If r != 0
				DllCall("RedrawWindow", "UInt", i, "UInt", 0, "UInt", 0, "UInt", 0x0101) ; RDW_UPDATENOW | RDW_INVALIDATE
			Return
		}
	If cf != 1
		cb := cl, cl += cs
	If (!NumGet(g, gb)) {
		Gui, +LastFound
		WinGetPos, , , , gh
		VarSetCapacity(pwi, 68, 0), DllCall("GetWindowInfo", "UInt", WinExist(), "UInt", &pwi)
			, NumPut(((bx := NumGet(pwi, 48)) << 16 | by := gh - A_GuiHeight - NumGet(pwi, 52)), g, gb + 4)
			, NumPut(A_GuiWidth << 16 | A_GuiHeight, g, gb)
	}
	Else d := NumGet(g, gb + 4), bx := d >> 16, by := d & k
	ControlGetPos, dx, dy, dw, dh, , ahk_id %i%
	If cf = 1
	{
		Gui, +LastFound
		WinGetPos, , , gw, gh
		d := NumGet(g, gb), dw -= gw - bx * 2 - (d >> 16), dh -= gh - by - bx - (d & k)
	}
	NumPut(i, c, cb), NumPut(dx - bx, c, cb + 4, "Short"), NumPut(dy - by, c, cb + 6, "Short")
		, NumPut(dw, c, cb + 8, "Short"), NumPut(dh, c, cb + 10, "Short")
	Return, true
}

Print( edit ){						;Thanks to Fry for this and for majkinetor for surprising him with a better version!
	FileAppend %edit%, Calculations.txt
	Run, notepad /p calculations.txt
	Sleep, 1500
	FileDelete, calculations.txt
}