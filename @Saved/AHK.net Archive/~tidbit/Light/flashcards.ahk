/*
Light: Flash Cards
by: tidbit

Card databases are TAB DELIMITED.
One question per line. 
No unicode characters allowed.
A blank line repeats the previous question.

Features:
Custom databases
Statistics
---right
---wrong
---right/wrong
---Question position and position %
---What questions were right
---What questions were wrong
View the wrong questions and there answers.

*/
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance off
SetFormat, Float, .1

Gui, Add, Button, x6 y6 w50 h20 gLoad, Load
Gui, Show, x131 y91 h377 w218, Load a Library.
Return

Load:
	Gui, destroy
	Gui, 3: destroy
	Gui, 4: destroy
	Fileselectfile, file, 3, %A_ScriptDir%, Choose a library., Libraries (*.txt; *.Lib; *.light)
	If Errorlevel
		Return

	cur=1
	Right=0
	wrong=0
	max:=getmax(file)
	Gosub, main
return

main:
	Filereadline, question, %file%, %cur%
	StringSplit, question, question, %A_tab%
	parse()
	Gui, color, white
	Gui, Add, Button, x6 y6 w50 h20 gLoad, Load
	Gui, Add, Button, x6 y6 w50 h20 , Load
	percent:=cur/max*100
	Gui, Add, Text, x106 y6 h20 w100 vdisp, %cur%/%max% (%percent%`%)

	Gui, Add, Edit, x6 y28 w200 h150 vquestion +readonly, %question1%
	Gui, Add, Button, x6 y188 w200 h150 vanswerbtn ganswerbtn +readonly, Answer
	Gui, Add, Edit, x6 y188 w200 h150 vanswer, %question2%
	GuiControl, hide, answer

	Gui, Add, Button, x126 y348 w60 h20 gcorrect, Correct
	Gui, Add, Button, x26 y348 w60 h20 gincorrect, Incorrect
	GuiControl, Disable, Incorrect
	GuiControl, Disable, Correct

	; Generated using SmartGUI Creator 4.0
	Gui, Show, x131 y91, FlashCard`, By: tidbit
Return

answerbtn:
	Gui, Submit, NoHide
	GuiControl, hide, answerbtn
	GuiControl, show, answer
	GuiControl, Enable, Incorrect
	GuiControl, Enable, Correct
return

correct:
	Gui, Submit, NoHide
	Rightones.=cur ", "
	cur+=1
	Right+=1
	percRight:=Right/max*100
	If (cur>max)
	{
		GuiControl, Disable, Incorrect
		GuiControl, Disable, Correct
		Gosub, results
		return
	}

	Filereadline, question, %file%, %cur%
	StringSplit, question, question, %A_tab%
	parse()
	GuiControl, , Question, %question1%
	GuiControl, , Answer, %question2%

	GuiControl, show, answerbtn
	GuiControl, hide, answer
	percent:=cur/max*100
	GuiControl,, disp, %cur%/%max% (%percent%`%)
	GuiControl, Disable, Incorrect
	GuiControl, Disable, Correct
return

incorrect:
	Gui, Submit, NoHide
	wrongones.=cur ", "
	cur+=1
	wrong+=1
	percwrong:=wrong/max*100
	If (cur>max)
	{
		GuiControl, Disable, Incorrect
		GuiControl, Disable, Correct
		Gosub, results
		return
	}

	Filereadline, question, %file%, %cur%
	StringSplit, question, question, %A_tab%
	parse()
	GuiControl, , Question, %question1%
	GuiControl, , Answer, %question2%

	GuiControl, show, answerbtn
	GuiControl, hide, answer
	percent:=cur/max*100
	GuiControl,, disp, %cur%/%max% (%percent%`%)
	GuiControl, Disable, Incorrect
	GuiControl, Disable, Correct
return

results:
	Gui, Submit, NoHide

	stringtrimRight, wrongones, wrongones, 2
	stringtrimRight, Rightones, Rightones, 2
	If Right=0
		percRight=0
	If wrong=0
		percwrong=0

	Gui, 3: Add, Text, x6 y6 , Questions: %max%
	Gui, 3: Add, Text, x6 y26 +Disabled, _______Right_______
	Gui, 3: Add, Text, x6 y46 , Correct: %Right% (%percRight%`%)
	Gui, 3: Add, Text, x6 y66 , Which: %Rightones%
	Gui, 3: Add, Text, x6 y86  +Disabled, _______Wrong_______
	Gui, 3: Add, Text, x6 y106 , Wrong: %wrong% (%percwrong%`%)
	Gui, 3: Add, Text, x6 y126 , Which: %wrongones%
	Gui, 3: Add, Text, x6 y146 cblue gshowwrong, Show wrong answers.
	Gui, 3:Show, , Results
return

showwrong:
	Gui, Submit, NoHide
	If wrong=0
	{
		msgbox, ,Congratulations, You answered nothing wrong.
		Return
	}
	Gui, 4: Default
	Gui, 4: Add, ListView, r13 w480, Number|Question|Answer
	Loop, Parse, wrongones, `,
	{
		Stringreplace, line, A_loopfield, %A_Space%
		Filereadline, question, %file%, %line%
		StringSplit, question, question, %A_tab%
		Stringreplace, question1, question1, ``n, %A_Space%, all
		Stringreplace, question1, question1, ``t, %A_Space%, all
		Stringreplace, question2, question2, ``n, %A_Space%, all
		Stringreplace, question2, question2, ``t, %A_Space%, all
		LV_Add("", a_loopfield, question1, question2)
	}

	LV_ModifyCol(1, "AutoHDR")
	LV_ModifyCol(2, "Auto")
	LV_ModifyCol(3, "Auto")
	Gui, 4: Show,, Wrong Question Review
return

4GuiClose:
	Gui, 4: Destroy
return

3GuiClose:
	Gui, 3: Destroy
return

GuiClose:
	ExitApp
return

;FUNCTIONS
getmax(file)
	{
		Fileread, output, %file%
		Loop, Parse, output,`n
			max+=1
		return max
	}
parse()
	{
	Global
		Stringreplace, question1, question1, ``n, `n, all
		Stringreplace, question1, question1, ``t, %A_Tab%, all
		Stringreplace, question2, question2, ``n, `n, all
		Stringreplace, question2, question2, ``t, %A_Tab%, all
	}

