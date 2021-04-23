#NoEnv
#singleinstance off
sendmode input

;---- cells, numbers ----
cells =
loop, 9
{
	row = %a_index%
	loop, 9
	{
		column = %a_index%
		cells = %cells%%row%%column%-
		number%row%%column% = 0
		loop, 9
			PencilMark%row%%column%%a_index% = 0
	}
}
stringtrimright, cells, cells, 1
;---- GUI ----
gui, +resize

menu, NewMenu, add, &symmetrical, symmetrical
menu, NewMenu, add, &difficult, difficult

menu, SolveMenu, add, find &one	Ctrl+page down, FindOne
menu, SolveMenu, add, find &all, FindAll

menu, PencilMarksMenu, add, &set obvious pencil marks, SetObviousPencilMarks
menu, PencilMarksMenu, add, &remove pencil marks, RemovePencilMarks

menu, PlayMenu, add, &pencil marks, :PencilMarksMenu
menu, PlayMenu, add, &back	page up, back
menu, PlayMenu, add, &forward	page down, forward
menu, PlayMenu, add, &save, save
menu, PlayMenu, add, &restore, restore
menu, PlayMenu, add, &empty board, EmptyBoard
menu, PlayMenu, add, show &colors, ShowColors

menu, MenuBar, add, &new, :NewMenu
menu, MenuBar, add, &solve, :SolveMenu
menu, MenuBar, add, &play, :PlayMenu
menu, MenuBar, add, &help, help

gui, menu, MenuBar

loop, parse, cells, -
{
	gui, add, text, vcell%a_loopfield% 0x1000 0x1
	loop, 9
		gui, add, text, vPencilMark%a_loopfield%%a_index% 0x1
}

gui, show, w768 h768, Sudoku
;---- units ----
; With units, rows and columns and blocks can be looped in one loop.
unit1 = 11-12-13-14-15-16-17-18-19
unit2 = 21-22-23-24-25-26-27-28-29
unit3 = 31-32-33-34-35-36-37-38-39
unit4 = 41-42-43-44-45-46-47-48-49
unit5 = 51-52-53-54-55-56-57-58-59
unit6 = 61-62-63-64-65-66-67-68-69
unit7 = 71-72-73-74-75-76-77-78-79
unit8 = 81-82-83-84-85-86-87-88-89
unit9 = 91-92-93-94-95-96-97-98-99
unit10 = 11-21-31-41-51-61-71-81-91
unit11 = 12-22-32-42-52-62-72-82-92
unit12 = 13-23-33-43-53-63-73-83-93
unit13 = 14-24-34-44-54-64-74-84-94
unit14 = 15-25-35-45-55-65-75-85-95
unit15 = 16-26-36-46-56-66-76-86-96
unit16 = 17-27-37-47-57-67-77-87-97
unit17 = 18-28-38-48-58-68-78-88-98
unit18 = 19-29-39-49-59-69-79-89-99
unit19 = 11-12-13-21-22-23-31-32-33
unit20 = 14-15-16-24-25-26-34-35-36
unit21 = 17-18-19-27-28-29-37-38-39
unit22 = 41-42-43-51-52-53-61-62-63
unit23 = 44-45-46-54-55-56-64-65-66
unit24 = 47-48-49-57-58-59-67-68-69
unit25 = 71-72-73-81-82-83-91-92-93
unit26 = 74-75-76-84-85-86-94-95-96
unit27 = 77-78-79-87-88-89-97-98-99
;---- connected cells ----
loop, parse, cells, -
{
	rc = %a_loopfield%
	string =
	loop, 27
		ifinstring, unit%a_index%, %rc%
		loop, parse, unit%a_index%, -
		if a_loopfield <> %rc%
		ifnotinstring, string, %a_loopfield%
		string = %string%%a_loopfield%-
	stringtrimright, ConnectedCells%rc%, string, 1
}
return

;_____________________________________________________________________________________________
;________ hotkeys ____________________________________________________________________________


#ifwinactive Sudoku ahk_class AutoHotkeyGUI

~left::
~right::
~up::
~down::
tooltip
stringtrimleft, key, a_thishotkey, 1
if key = left
{
	hor = -1
	ver = 0
}
else if key = right
{
	hor = 1
	ver = 0
}
else if key = up
{
	hor = 0
	ver = -1
}
else if key = down
{
	hor = 0
	ver = 1
}
loop, 99
{
	getkeystate, k, %key%, p
	if (k = "u")
		break
	l := (hor <> 0) ? wCell//7 : hCell//7
	loop, %l%
		mousemove hor, ver,, R
	sleep 10
}
gosub MouseGetNearestCell
click %xm%, %ym%, 0
return

;---- set numbers/colors ---------------------------------------------------------------------

1::
2::
3::
4::
5::
6::
7::
8::
9::
numpad1::
numpad2::
numpad3::
numpad4::
numpad5::
numpad6::
numpad7::
numpad8::
numpad9::
gosub MouseGetNearestCell
stringright, n, a_thislabel, 1
if number%rm%%cm% <> %n%  ; if not already filled with n
{
	valid = 1
	loop, parse, ConnectedCells%rm%%cm%, -
		if number%a_loopfield% = %n%
	{
		valid = 0
		break
	}
	if valid = 1
	{
		BackListAdd(rm . cm)
		fill(rm . cm, n)
	}
	else
	{
		n0 := number%rm%%cm%
		fill(rm . cm, n)
		sleep 200
		fill(rm . cm, n0)
	}
}
return

;---- set pencil marks -----------------------------------------------------------------------

^1::
^2::
^3::
^4::
^5::
^6::
^7::
^8::
^9::
^numpad1::
^numpad2::
^numpad3::
^numpad4::
^numpad5::
^numpad6::
^numpad7::
^numpad8::
^numpad9::
gosub MouseGetNearestCell
stringright, n, a_thislabel, 1
if number%rm%%cm% = 0
{
	BackListAdd(rm . cm)
	if PencilMark%rm%%cm%%n% = 0
		PencilMark(rm . cm, n, 1)
	else
		PencilMark(rm . cm, n, 0)
}
return

;---- delete numbers/colors ------------------------------------------------------------------

space::
gosub MouseGetNearestCell
if number%rm%%cm% <> 0  ; if not already empty
{
	BackListAdd(rm . cm)
	fill(rm . cm, 0)
}
return

;_____________________________________________________________________________________________
;________ Gui menu subroutines _______________________________________________________________


;---- generate a symmetrical Sudoku ----------------------------------------------------------

symmetrical:
gosub EmptyBoard
;---- spill 1 to 9 ----
string1 = 1-2-3-4-5-6-7-8-9
string2 = 1-2-3-4-5-6-7-8-9
sort, string1, random d-
sort, string2, random d-
loop, 9
{
	stringmid, c, string1, 2*a_index-1, 1
	stringmid, n, string2, 2*a_index-1, 1
	fill(a_index . c, n)
}
;---- fill up ----
gosub FirstSearch
NotYetOmitted = %cells%-  ; The trailing - is needed for stringreplace. <---------
loop, parse, cells, -
	full%a_loopfield% := number%a_loopfield%
;---- omit numbers ----
; Omit numbers found by FirstSearch if there was no choice.
sort, NotYetOmitted, random d-
loop, parse, NotYetOmitted, -
	if a_loopfield <>
{
	stringleft, r, a_loopfield, 1
	stringright, c, a_loopfield, 1
	sym := r . 10-c
	ifinstring, NoChoice, %a_loopfield%
		ifinstring, NoChoice, %sym%
	{
		fill(a_loopfield, 0)
		fill(sym, 0)
		stringreplace, NotYetOmitted, NotYetOmitted, %a_loopfield%-,  ; <---------
		stringreplace, NotYetOmitted, NotYetOmitted, %sym%-,
	}
}
; Omit numbers found by GetPossibleNumbers if there was no choice.
sort, NotYetOmitted, random d-
AlreadyLooped =
loop, parse, NotYetOmitted, -
	if a_loopfield <>
	ifnotinstring, AlreadyLooped, %a_loopfield%
{
	stringleft, r, a_loopfield, 1
	stringright, c, a_loopfield, 1
	sym := r . 10-c
	AlreadyLooped = %AlreadyLooped%%sym%-
	number%a_loopfield% = 0
	number%sym% = 0
	GetAll = 1
	gosub GetPossibleNumbers
	GetAll = 0
	both = 0
	ifinstring, WhatNext, 1%a_loopfield%
		ifinstring, WhatNext, 1%sym%
		both = 1
	if both = 1
	{
		guicontrol, text, cell%a_loopfield%
		guicontrol, text, cell%sym%
		stringreplace, NotYetOmitted, NotYetOmitted, %a_loopfield%-,
		stringreplace, NotYetOmitted, NotYetOmitted, %sym%-,
	}
	else
	{
		number%a_loopfield% := full%a_loopfield%
		number%sym% := full%sym%
	}
}
return

;---- generate a difficult Sudoku ------------------------------------------------------------

difficult:
progress, b fm20 wm400,, please wait ...
gosub EmptyBoard
;---- spill 1 to 9 ----
string1 = 1-2-3-4-5-6-7-8-9
string2 = 1-2-3-4-5-6-7-8-9
sort, string1, random d-
sort, string2, random d-
loop, 9
{
	stringmid, c, string1, 2*a_index-1, 1
	stringmid, n, string2, 2*a_index-1, 1
	fill(a_index . c, n)
}
;---- fill up ----
gosub FirstSearch
NotYetOmitted = %cells%-  ; The trailing - is needed for stringreplace. <---------
loop, parse, cells, -
	full%a_loopfield% := number%a_loopfield%
;---- omit numbers ----
; Omit numbers found by FirstSearch if there was no choice.
sort, NotYetOmitted, random d-
loop, parse, NotYetOmitted, -
	if a_loopfield <>
	ifinstring, NoChoice, %a_loopfield%
{
	fill(a_loopfield, 0)
	stringreplace, NotYetOmitted, NotYetOmitted, %a_loopfield%-,
}
progress, % bar:=5
; Omit numbers found by GetPossibleNumbers if there was no choice.
sort, NotYetOmitted, random d-
loop, parse, NotYetOmitted, -
	if a_loopfield <>
{
	number%a_loopfield% = 0
	GetAll = 1
	gosub GetPossibleNumbers
	GetAll = 0
	ifinstring, WhatNext, 1%a_loopfield%
	{
		guicontrol, text, cell%a_loopfield%
		stringreplace, NotYetOmitted, NotYetOmitted, %a_loopfield%-,
		progress, % bar+=1
	}
	else
		number%a_loopfield% := full%a_loopfield%
}
; Try for each remaining number if there is still only one solution when omitted.
loop, parse, NotYetOmitted, -
	if a_loopfield <>
	LoopCount = %a_index%
step := (100-bar)/LoopCount
sort, NotYetOmitted, random d-
loop, parse, NotYetOmitted, -
	if a_loopfield <>
{
	TryOmit = %a_loopfield%
	fill(TryOmit, 0)
	StopAt = 1
	gosub FirstSearch
	StopAt = 0
	if filled <> %NoChoice%
	{
		NeedSecondSearch = 1
		loop, parse, cells, -
			if (FirstSolution%a_loopfield% <> full%a_loopfield%)
		{
			NeedSecondSearch = 0
			sudoku%TryOmit% := full%TryOmit%
			break
		}
		if NeedSecondSearch = 1
		{
			gosub SecondSearch
			if identical = 0
				sudoku%TryOmit% := full%TryOmit%
		}
	}
	loop, parse, cells, -
		fill(a_loopfield, sudoku%a_loopfield%)
	progress, % bar+=step
}
progress, off
return

;---- find one -------------------------------------------------------------------------------

^pgdn::
FindOne:
text =
explain = 1
gosub GetPossibleNumbers
explain = 0
stringleft, p, WhatNext, 1
if p = x  ; no possible cell
{
stringtrimleft, WhatNext, WhatNext, 1
stringright, n, WhatNext, 1
stringtrimright, u, WhatNext, 1
loop, parse, unit%u%, -
		if number%a_loopfield% = 0
	{
		stringleft, r, a_loopfield, 1
		stringright, c, a_loopfield, 1
		xm := x%c%
		ym := yt%r%
		click %xm%, %ym%, 0
		sleep 400
	}
	if u <= 9
		unit := "row " . u
	else if u <= 18
		unit := "column " . u-9
	else
		unit := "block " . u-18
	text = Number %n%# can't be set anywhere in %unit%.
	loop, parse, unit%u%, -
		if number%a_loopfield% = 0
		if explain%a_loopfield%%n% <>
		text := text . explain%a_loopfield%%n%
}
else if p = 0  ; no possible number
{
	stringmid, r, WhatNext, 2, 1
	stringmid, c, WhatNext, 3, 1
	xm := x%c%
	ym := yt%r%
	click %xm%, %ym%, 0
	text = This cell can't be filled.
	loop, 9
		if explain%r%%c%%a_index% <>
		text := text . explain%r%%c%%a_index%
}
else if p = 1  ; one possible number
{
	stringmid, r, WhatNext, 2, 1
	stringmid, c, WhatNext, 3, 1
	n := PossibleNumbers%r%%c%
	xm := x%c%
	ym := yt%r%
	click %xm%, %ym%, 0
	BackListAdd(r . c)
	fill(r . c, n)
	if explain%r%%c%%n% =
	{
		text = %n%# is the only possible number in this cell.
		loop, 9
			if explain%r%%c%%a_index% <>
			text := text . explain%r%%c%%a_index%
	}
	else
	{
		u := explain%r%%c%%n%
		if u <= 9
			unit := "row " . u
		else if u <= 18
			unit := "column " . u-9
		else
			unit := "block " . u-18
		text = This is the only possible cell for number %n%# in %unit%.
		loop, parse, unit%u%, -
			if number%a_loopfield% = 0
			if explain%a_loopfield%%n% <>
			text := text . explain%a_loopfield%%n%
	}
}
else if p > 1  ; several possible numbers
{
	stringmid, r0, WhatNext, 2, 1  ; r and c are used by FirstSearch. <---------
	stringmid, c0, WhatNext, 3, 1
	xm := x%c0%
	ym := yt%r0%
	click %xm%, %ym%, 0
	ProvedNumbers =
	loop, parse, PossibleNumbers%r0%%c0%
	{
		fill(r0 . c0, a_loopfield)
		gosub FirstSearch  ; <---------
		if result = 1
			ProvedNumbers = %ProvedNumbers%%a_loopfield%
		sudoku%r0%%c0% = 0
		loop, parse, cells, -
			fill(a_loopfield, sudoku%a_loopfield%)
	}
	stringlen, p, ProvedNumbers
	if p = 0
	{
		text := "This cell could be filled with"
		loop, parse, PossibleNumbers%r0%%c0%
			text = %text% %a_loopfield%# or
		stringtrimright, text, text, 3
		text := text . " but the sudoku can't be completed with any of them."
	}
	else
	{
		if p = 1
		{
			BackListAdd(r0 . c0)
			fill(r0 . c0, ProvedNumbers)
		}
		text := "Possible numbers in this cell:"
		loop, parse, PossibleNumbers%r0%%c0%
			text = %text% %a_loopfield%#,
		stringtrimright, text, text, 1
		text := text . ".Proved by completing the sudoku:"
		loop, parse, ProvedNumbers
			text = %text% %a_loopfield%#,
		stringtrimright, text, text, 1
		text := text . "."
	}
}
if text <>
{
	if ColorsOrNumbers = c
	{
		stringreplace, text, text, number 1#, white, all
		stringreplace, text, text, number 2#, yellow, all
		stringreplace, text, text, number 3#, orange, all
		stringreplace, text, text, number 4#, red, all
		stringreplace, text, text, number 5#, purple, all
		stringreplace, text, text, number 6#, blue, all
		stringreplace, text, text, number 7#, light blue, all
		stringreplace, text, text, number 8#, green, all
		stringreplace, text, text, number 9#, black, all
		stringreplace, text, text, 1#, white, all
		stringreplace, text, text, 2#, yellow, all
		stringreplace, text, text, 3#, orange, all
		stringreplace, text, text, 4#, red, all
		stringreplace, text, text, 5#, purple, all
		stringreplace, text, text, 6#, blue, all
		stringreplace, text, text, 7#, light blue, all
		stringreplace, text, text, 8#, green, all
		stringreplace, text, text, 9#, black, all
		stringreplace, text, text, number, color
	}
	else
		stringreplace, text, text, #,, all
	text2 =
	loop, parse, text, .
		if a_loopfield <>
		ifnotinstring, text2, %a_loopfield%
		text2 = %text2%%a_loopfield%.
	text =
	loop, parse, text2, .
		if a_loopfield <>
	{
		stringleft, x, a_loopfield, 1
		stringupper, x, x
		stringtrimleft, line, a_loopfield, 1
		text = %text%%x%%line%.`n
	}
	stringtrimright, text, text, 1
	tooltip %text%
}
return

;---- find all -------------------------------------------------------------------------------

FindAll:
BackListAdd("all")
gosub FirstSearch
if result = 0
{
	gosub back
	msgbox There is no solution!
}
else if result = 1
{
	BackListAdd("all")
	sleep 1000
	gosub SecondSearch
	if identical = 1
		msgbox, There is only one solution!
	else
		msgbox, There is a second solution!
}
return

;---- set obvious pencil marks ---------------------------------------------------------------

SetObviousPencilMarks:
BackListAdd("all")
loop, parse, cells, -
	if number%a_loopfield% = 0
{
	PencilMarks = 123456789
	loop, parse, ConnectedCells%a_loopfield%, -
		if number%a_loopfield% <> 0
	{
		n := number%a_loopfield%
		stringreplace, PencilMarks, PencilMarks, %n%,
	}
	loop, 9
	{
		ifinstring, PencilMarks, %a_index%
			PencilMark(a_loopfield, a_index, 1)
		else
			PencilMark(a_loopfield, a_index, 0)
	}
}
return

;---- remove pencil marks --------------------------------------------------------------------

RemovePencilMarks:
BackListAdd("all")
loop, parse, cells, -
	if number%a_loopfield% = 0
	loop, 9
	if PencilMark%a_loopfield%%a_index% = 1
	PencilMark(a_loopfield, a_index, 0)
return

;---- back -----------------------------------------------------------------------------------

pgup::
back:
if BackList <>
	loop, parse, BackList, `n
{
	stringlen, len, a_loopfield
	if len = 14
	{
		loop, parse, a_loopfield, -
		{
			if a_index = 1
				rc = %a_loopfield%
			else if a_index = 2
				n1 = %a_loopfield%
			else if a_index = 3
				PencilMarks1 = %a_loopfield%
		}
		n2 := number%rc%
		PencilMarks2 =
		loop, 9
			PencilMarks2 := PencilMarks2 . PencilMark%rc%%a_index%
		ForwardList = %rc%-%n2%-%PencilMarks2%`n%ForwardList%
		fill(rc, n1)
		loop, parse, PencilMarks1
			PencilMark(rc, a_index, a_loopfield)
	}
	else
	{
		all =
		loop, parse, a_loopfield, /
		{
			loop, parse, a_loopfield, -
			{
				if a_index = 1
					rc = %a_loopfield%
				else if a_index = 2
					n1 = %a_loopfield%
				else if a_index = 3
					PencilMarks1 = %a_loopfield%
			}
			n2 := number%rc%
			PencilMarks2 =
			loop, 9
				PencilMarks2 := PencilMarks2 . PencilMark%rc%%a_index%
			all = %all%%rc%-%n2%-%PencilMarks2%/
			fill(rc, n1)
			loop, parse, PencilMarks1
				PencilMark(rc, a_index, a_loopfield)
		}
		stringtrimright, all, all, 1  ; trim last /
		ForwardList = %all%`n%ForwardList%
	}
	stringtrimleft, BackList, BackList, %len%  ; trim first a_loopfield
	stringtrimleft, BackList, BackList, 1  ; trim linefeed
	break
}
return

;---- forward --------------------------------------------------------------------------------

pgdn::
forward:
if ForwardList <>
	loop, parse, ForwardList, `n
{
	stringlen, len, a_loopfield
	if len = 14
	{
		loop, parse, a_loopfield, -
		{
			if a_index = 1
				rc = %a_loopfield%
			else if a_index = 2
				n1 = %a_loopfield%
			else if a_index = 3
				PencilMarks1 = %a_loopfield%
		}
		n2 := number%rc%
		PencilMarks2 =
		loop, 9
			PencilMarks2 := PencilMarks2 . PencilMark%rc%%a_index%
		BackList = %rc%-%n2%-%PencilMarks2%`n%BackList%
		fill(rc, n1)
		loop, parse, PencilMarks1
			PencilMark(rc, a_index, a_loopfield)
	}
	else
	{
		all =
		loop, parse, a_loopfield, /
		{
			loop, parse, a_loopfield, -
			{
				if a_index = 1
					rc = %a_loopfield%
				else if a_index = 2
					n1 = %a_loopfield%
				else if a_index = 3
					PencilMarks1 = %a_loopfield%
			}
			n2 := number%rc%
			PencilMarks2 =
			loop, 9
				PencilMarks2 := PencilMarks2 . PencilMark%rc%%a_index%
			all = %all%%rc%-%n2%-%PencilMarks2%/
			fill(rc, n1)
			loop, parse, PencilMarks1
				PencilMark(rc, a_index, a_loopfield)
		}
		stringtrimright, all, all, 1  ; trim last /
		BackList = %all%`n%BackList%
	}
	stringtrimleft, ForwardList, ForwardList, %len%  ; trim first a_loopfield
	stringtrimleft, ForwardList, ForwardList, 1  ; trim linefeed
	break
}
return

;---- save -----------------------------------------------------------------------------------

save:
string =
loop, parse, cells, -
	string := string . number%a_loopfield%
filedelete, %a_desktop%\Sudokus.txt
fileappend, %string%, %a_desktop%\Sudokus.txt
return

;---- restore --------------------------------------------------------------------------------

restore:
BackListAdd("all")
fileread, string, %a_desktop%\Sudokus.txt
loop, parse, cells, -
{
	stringmid, n, string, a_index, 1
	fill(a_loopfield, n)
}
return

;---- empty board ----------------------------------------------------------------------------

EmptyBoard:
BackListAdd("all")
loop, parse, cells, -
	fill(a_loopfield, 0)
return

;---- show numbers ---------------------------------------------------------------------------

ShowNumbers:
ColorsOrNumbers = n
loop, parse, cells, -
{
	if number%a_loopfield% <> 0
		fill(a_loopfield, number%a_loopfield%)
	else loop, 9
		if PencilMark%a_loopfield%%a_index% = 1
		PencilMark(a_loopfield, a_index, 1)
}
menu, PlayMenu, delete, show &numbers
menu, PlayMenu, add, show &colors, ShowColors
return

;---- show colors ----------------------------------------------------------------------------

ShowColors:
ColorsOrNumbers = c
loop, parse, cells, -
{
	if number%a_loopfield% <> 0
		fill(a_loopfield, number%a_loopfield%)
	else loop, 9
		if PencilMark%a_loopfield%%a_index% = 1
		PencilMark(a_loopfield, a_index, 1)
}
menu, PlayMenu, delete, show &colors
menu, PlayMenu, add, show &numbers, ShowNumbers
return

;---- help -----------------------------------------------------------------------------------

help:
msgbox,
(
You just have to move the mouse, you don't have to click.
The arrow keys also move the mouse cursor.
Set numbers or colors with the number keys/numpad keys.
Delete numbers or colors with the spacebar.
Set/delete pencil marks with Ctrl+number keys/numpad keys.

1 = white
2 = yellow
3 = orange
4 = red
5 = purple
6 = blue
7 = light blue
8 = green
9 = black
)
return

;_____________________________________________________________________________________________
;________ other subroutines __________________________________________________________________


~Esc::tooltip

GuiClose:
exitapp

;---------------------------------------------------------------------------------------------

GuiSize:
wLine := (a_guiwidth < 600 or a_guiheight < 600) ? 1 : 2
wCell := (a_guiwidth-12*wLine)//18*2  ; //18*2 instead of //9 => wCell/2 is an integer
hCell := (a_guiheight-12*wLine)//18*2
wBorder := (a_guiwidth-9*wCell-12*wLine)/2
hBorder := (a_guiheight-9*hCell-12*wLine)/2
sNumber := (wCell < hCell) ? wCell*2//3 : hCell*2//3
sColor := (wCell < hCell) ? wCell*5//7 : hCell*5//7
wPencilMark := wCell//4
hPencilMark := hCell//4
sPencilMark := (wPencilMark < hPencilMark) ? wPencilMark*5//7 : hPencilMark*5//7
x = 0
y = 0
loop, 9
{
	if a_index > 1
	{
		x += (wCell+wLine)
		y += (hCell+wLine)
	}
	if (a_index = 4 or a_index = 7)
	{
		x += 2*wLine
		y += 2*wLine
	}
	x%a_index% := x+wCell/2+wBorder  ; center of column a_index
	y%a_index% := y+hCell/2+hBorder  ; center of row a_index
}
loop, parse, cells, -
{
	stringleft, r, a_loopfield, 1
	stringright, c, a_loopfield, 1
	x := x%c%-wCell/2
	y := y%r%-hCell/2
	guicontrol, movedraw, cell%a_loopfield%, x%x% y%y% w%wCell% h%hCell%
; The moving of pencil mark controls is done within the PencilMark function
; because otherwise overlapping cell and pencil mark controls would damage each other.
	if number%a_loopfield% <> 0
		fill(a_loopfield, number%a_loopfield%)
	else loop, 9
		if PencilMark%a_loopfield%%a_index% = 1
		PencilMark(a_loopfield, a_index, 1)
}
wingetpos,,,, winheight, Sudoku ahk_class AutoHotkeyGUI
loop, 9
	yt%a_index% := y%a_index%+winheight-a_guiheight
; winheight-a_guiheight = title bar + menu bar
return

;---------------------------------------------------------------------------------------------

MouseGetNearestCell:
mousegetpos, xm, ym
rm = 1
cm = 1
loop, 9
	if a_index > 1
{
	if abs(xm-x%a_index%) < abs(xm-x%cm%)
		cm = %a_index%
	if abs(ym-yt%a_index%) < abs(ym-yt%rm%)
		rm = %a_index%
}
xm := x%cm%
ym := yt%rm%
return

;---------------------------------------------------------------------------------------------

fill(rc, n)
{
	global
	tooltip
	loop, 9
		if PencilMark%rc%%a_index% = 1
		PencilMark(rc, a_index, 0)
	number%rc% = %n%
	if n = 0
		guicontrol, text, cell%rc%
	else
	{
		if ColorsOrNumbers = c
		{
			gui, font, s%sColor%, Webdings
			if n = 1
				gui, font, cwhite
			else if n = 2
				gui, font, cyellow
			else if n = 3
				gui, font, cff8040
			else if n = 4
				gui, font, cred
			else if n = 5
				gui, font, c8000ff
			else if n = 6
				gui, font, cblue
			else if n = 7
				gui, font, c80ffff
			else if n = 8
				gui, font, cgreen
			else if n = 9
				gui, font, cblack
			guicontrol, font, cell%rc%
			guicontrol, text, cell%rc%, =
		}
		else
		{
			gui, font, cblack s%sNumber%, Arial
			guicontrol, font, cell%rc%
			guicontrol, text, cell%rc%, %n%
		}
	}
}

;---------------------------------------------------------------------------------------------

PencilMark(rc, n, OnOff)
{
	global
	local r, c, x, y
	tooltip
	if OnOff = 1
	{
		PencilMark%rc%%n% = 1
		if ColorsOrNumbers = c
		{
			gui, font, s%sPencilMark%, Webdings
			if n = 1
				gui, font, cwhite
			else if n = 2
				gui, font, cyellow
			else if n = 3
				gui, font, cff8040
			else if n = 4
				gui, font, cred
			else if n = 5
				gui, font, c8000ff
			else if n = 6
				gui, font, cblue
			else if n = 7
				gui, font, c80ffff
			else if n = 8
				gui, font, cgreen
			else if n = 9
				gui, font, cblack
			guicontrol, font, PencilMark%rc%%n%
			guicontrol, text, PencilMark%rc%%n%, =
		}
		else
		{
			gui, font, cblack s%sPencilMark%, Arial
			guicontrol, font, PencilMark%rc%%n%
			guicontrol, text, PencilMark%rc%%n%, %n%
		}
		loop, %n%  ; Calculate the pencil mark's x- and y-position.
		{
			if a_index = 1
			{
				stringleft, r, rc, 1
				stringright, c, rc, 1
				x := x%c%-wCell/2+wPencilMark//4
				y := y%r%-hCell/2+hPencilMark//4
			}
			else if (a_index = 4 or a_index = 7)
			{
				x -= 2*(wPencilMark+wPencilMark//4)
				y += hPencilMark+hPencilMark//4
			}
			else
				x += wPencilMark+wPencilMark//4
		}
		guicontrol, movedraw, PencilMark%rc%%n%, x%x% y%y% w%wPencilMark% h%hPencilMark%
	}
	else
	{
		PencilMark%rc%%n% = 0
		guicontrol, move, PencilMark%rc%%n%, x9999
	}
}

;---------------------------------------------------------------------------------------------

GetPossibleNumbers:
loop, parse, cells, -
	if number%a_loopfield% = 0
	PossibleNumbers%a_loopfield% = 123456789
if explain = 1
	loop, parse, cells, -
	loop, 9
	explain%a_loopfield%%a_index% =
; Explains why number a_index can't be set in cell a_loopfield
; or contains the index of a unit where number a_index can only be set in cell a_loopfield.
;---- Get possible numbers for every cell. ----
loop, parse, cells, -
{
	rc = %a_loopfield%
	if number%rc% = 0
	{
		loop, parse, ConnectedCells%rc%, -
			if number%a_loopfield% <> 0
		{
			n := number%a_loopfield%
			stringreplace, PossibleNumbers%rc%, PossibleNumbers%rc%, %n%,
		}
		PossibleNumbersR%rc% =
		loop, parse, PossibleNumbers%rc%
			PossibleNumbersR%rc% := a_loopfield . PossibleNumbersR%rc%
		stringlen, p, PossibleNumbers%rc%
		if (p = 0 or p = 1 and GetAll <> 1)
		{
			WhatNext = %p%%rc%
			return
		}
	}
}
loop, 2
;---- Get possible cells for every number in every unit. ----
	loop, 27  ; units
{
	u = %a_index%
	loop, 9  ; numbers
	{
		n = %a_index%
		i = 0
		PossibleCells%n% =
		loop, parse, unit%u%, -
			if number%a_loopfield% = %n%
			{
				i = 1
				break
			}
			else if number%a_loopfield% = 0
				ifinstring, PossibleNumbers%a_loopfield%, %n%
				PossibleCells%n% := PossibleCells%n% . a_loopfield . "-"
		stringlen, p, PossibleCells%n%
		if (i = 0 and p = 0)  ; Number n is not and can not be set in unit u.
		{
			WhatNext = x%u%%n%
			return
		}
		else if p = 3  ; In unit u number n must be ...
		{
			stringleft, rc, PossibleCells%n%, 2  ; ... in cell rc.
			PossibleNumbers%rc% = %n%
			if explain = 1
				explain%rc%%n% = %u%
			if GetAll <> 1
			{
				WhatNext = 1%rc%
				return
			}
		}
		else if (p = 6 or p = 9)
		{
;---- If there are two numbers with the same two possible cells
; then these two numbers are the only possible numbers in these two cells. ----
			if p = 6
				loop, % n-1
				if (PossibleCells%a_index% = PossibleCells%n%)
			{
				n2 = %a_index%
				loop, parse, PossibleCells%n%, -
					if a_loopfield <>
				{
					rc = %a_loopfield%
					if explain = 1
						loop, parse, PossibleNumbers%rc%
						if (a_loopfield <> n and a_loopfield <> n2)
					{
						n3 = %a_loopfield%
						explain%rc%%n3% := explain1(rc,n3,n2,n)
						loop, parse, unit%u%, -
							if number%a_loopfield% = 0
							ifnotinstring, PossibleCells%n%, %a_loopfield%
						{
							ConnectedNumbers =
							loop, parse, ConnectedCells%a_loopfield%, -
								if number%a_loopfield% <> 0
								ConnectedNumbers := ConnectedNumbers . number%a_loopfield%
							ifnotinstring, ConnectedNumbers, %n%
								if (explain%a_loopfield%%n% <> explain2(a_loopfield,n))  ; to avoid recursive explanation
								explain%rc%%n3% := explain%rc%%n3% . explain%a_loopfield%%n%
							ifnotinstring, ConnectedNumbers, %n2%
								if (explain%a_loopfield%%n2% <> explain2(a_loopfield,n2))
								explain%rc%%n3% := explain%rc%%n3% . explain%a_loopfield%%n2%
						}
					}
					PossibleNumbers%rc% = %n2%%n%
					PossibleNumbersR%rc% = %n%%n2%
				}
				break
			}
;---- If number n has two or three possible cells in unit 1 and all of them are also in unit 2
; then number n can't be set anywhere else in unit 2
; because otherwise number n couldn't be set anywhere in unit 1. ----
			loop, 27
			{
				u2 = %a_index%
				if u2 <> %u%
				{
					AllInU2 = 1
					loop, parse, PossibleCells%n%, -
						if a_loopfield <>
						ifnotinstring, unit%u2%, %a_loopfield%
					{
						AllInU2 = 0
						break
					}
					if AllInU2 = 1
					{
						loop, parse, unit%u2%, -
							if number%a_loopfield% = 0
							ifnotinstring, PossibleCells%n%, %a_loopfield%
							ifinstring, PossibleNumbers%a_loopfield%, %n%
						{
							rc = %a_loopfield%
							if explain = 1
							{
								explain%rc%%n% := explain2(rc,n)
								loop, parse, unit%u%, -
									if explain%a_loopfield%%n% <>
									explain%rc%%n% := explain%rc%%n% . explain%a_loopfield%%n%
							}
							stringreplace, PossibleNumbers%rc%, PossibleNumbers%rc%, %n%,
							stringreplace, PossibleNumbersR%rc%, PossibleNumbersR%rc%, %n%,
							stringlen, p, PossibleNumbers%rc%
							if (p = 0 or p = 1 and GetAll <> 1)
							{
								WhatNext = %p%%rc%
								return
							}
						}
					}
				}
			}
		}
	}
}
WhatNext =
loop, parse, cells, -
	if number%a_loopfield% = 0
{
	stringlen, p, PossibleNumbers%a_loopfield%
	WhatNext = %WhatNext%%p%%a_loopfield%-
}
sort, WhatNext, d-
return

;---------------------------------------------------------------------------------------------

explain1(rc,n1,n2,n3)
{
	stringleft, r1, rc, 1
	stringright, c1, rc, 1
	stringleft, r2, PossibleCells%n2%, 1
	stringmid, c2, PossibleCells%n2%, 2, 1
	stringmid, r3, PossibleCells%n2%, 4, 1
	stringmid, c3, PossibleCells%n2%, 5, 1
	string = Number %n1%# can't be in row %r1% column %c1% because %n2%# and %n3%# must be in row %r2% column %c2% and row %r3% column %c3%.
	return string
}

;---------------------------------------------------------------------------------------------

explain2(rc,n)
{
	stringleft, r1, rc, 1
	stringright, c1, rc, 1
	string = Number %n%# can't be in row %r1% column %c1% because it must be in 
	loop, parse, PossibleCells%n%, -
		if a_loopfield <>
	{
		stringleft, r2, a_loopfield, 1
		stringright, c2, a_loopfield, 1
		string := string . " row " . r2 . " column " . c2 . " or"
	}
	stringtrimright, string, string, 3
	string := string . "."
	return string
}

;---------------------------------------------------------------------------------------------

FirstSearch:
filled =
NoChoice =
loop, parse, cells, -
{
	sudoku%a_loopfield% := number%a_loopfield%
	minimum%a_loopfield% = 1
}
loop, 999
{
	gosub GetPossibleNumbers
	if WhatNext =
	{
		result = 1
		loop, parse, cells, -
			FirstSolution%a_loopfield% := number%a_loopfield%
		return
	}
	stringleft, p, WhatNext, 1
	if (p = "x" or p = 0)
	{
		if filled =
		{
			result = 0
			return
		}
		stringtrimright, filled, filled, 1
		stringright, rc, filled, 2
		minimum%rc% := number%rc%+1
		fill(rc, 0)
		stringtrimright, filled, filled, 2
	}
	else if p = 1
	{
		stringmid, rc, WhatNext, 2, 2
		if (PossibleNumbers%rc% < minimum%rc%)
		{
			if filled =
			{
				result = 0
				return
			}
			minimum%rc% = 1
			stringtrimright, filled, filled, 1
			stringright, rc, filled, 2
			minimum%rc% := number%rc%+1
			fill(rc, 0)
			stringtrimright, filled, filled, 2
		}
		else
		{
			fill(rc, PossibleNumbers%rc%)
			filled = %filled%%rc%-
			ifnotinstring, NoChoice, %rc%
				NoChoice = %NoChoice%%rc%-
			if (StopAt = 1 and rc = TryOmit and filled = NoChoice)
				return
		}
	}
	else if p > 1
	{
		stringmid, rc, WhatNext, 2, 2
		CouldFill = 0
		loop, parse, PossibleNumbers%rc%
		{
			if (a_loopfield < minimum%rc%)
				continue
			fill(rc, a_loopfield)
			filled = %filled%%rc%-
			stringreplace, NoChoice, NoChoice, %rc%-,
			CouldFill = 1
			break
		}
		if CouldFill = 0
		{
			if filled =
			{
				result = 0
				return
			}
			minimum%rc% = 1
			stringtrimright, filled, filled, 1
			stringright, rc, filled, 2
			minimum%rc% := number%rc%+1
			fill(rc, 0)
			stringtrimright, filled, filled, 2
		}
	}
}
return

;---------------------------------------------------------------------------------------------

SecondSearch:
filled =
loop, parse, cells, -
{
	fill(a_loopfield, sudoku%a_loopfield%)
	maximum%a_loopfield% = 9
	; SecondSearch tries greater numbers first. If it gets the same solution, then there is only one solution.
}
loop, 999
{
	gosub GetPossibleNumbers
	if WhatNext =
	{
		identical = 1
		loop, parse, cells, -
			if (number%a_loopfield% <> FirstSolution%a_loopfield%)
			{
				identical = 0
				break
			}
		return
	}
	stringleft, p, WhatNext, 1
	if (p = "x" or p = 0)
	{
		stringtrimright, filled, filled, 1
		stringright, rc, filled, 2
		maximum%rc% := number%rc%-1
		fill(rc, 0)
		stringtrimright, filled, filled, 2
	}
	else if p = 1
	{
		stringmid, rc, WhatNext, 2, 2
		if (PossibleNumbers%rc% > maximum%rc%)
		{
			maximum%rc% = 9
			stringtrimright, filled, filled, 1
			stringright, rc, filled, 2
			maximum%rc% := number%rc%-1
			fill(rc, 0)
			stringtrimright, filled, filled, 2
		}
		else
		{
			fill(rc, PossibleNumbers%rc%)
			filled = %filled%%rc%-
		}
	}
	else if p > 1
	{
		stringmid, rc, WhatNext, 2, 2
		CouldFill = 0
		loop, parse, PossibleNumbersR%rc%
		{
			if (a_loopfield > maximum%rc%)
				continue
			fill(rc, a_loopfield)
			filled = %filled%%rc%-
			CouldFill = 1
			break
		}
		if CouldFill = 0
		{
			maximum%rc% = 9
			stringtrimright, filled, filled, 1
			stringright, rc, filled, 2
			maximum%rc% := number%rc%-1
			fill(rc, 0)
			stringtrimright, filled, filled, 2
		}
	}
}
return

;---------------------------------------------------------------------------------------------

BackListAdd(rc)
{
	global
	local all, n, PencilMarks
	ForwardList =
	if (rc = "all")
	{
		all =
		loop, parse, cells, -
		{
			n := number%a_loopfield%
			PencilMarks =
			loop, 9
				PencilMarks := PencilMarks . PencilMark%a_loopfield%%a_index%
			all = %all%%a_loopfield%-%n%-%PencilMarks%/
		}
		stringtrimright, all, all, 1
		BackList = %all%`n%BackList%
	}
	else
	{
		n := number%rc%
		PencilMarks =
		loop, 9
			PencilMarks := PencilMarks . PencilMark%rc%%a_index%
		BackList = %rc%-%n%-%PencilMarks%`n%BackList%
	}
}