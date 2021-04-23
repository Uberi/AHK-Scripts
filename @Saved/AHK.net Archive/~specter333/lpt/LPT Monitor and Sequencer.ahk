
#NoEnv 
SetWorkingDir %A_ScriptDir%  
#SingleInstance Force
GoSub Off

Gui, Add, Checkbox, x5 y15 vb1 gRealtime, 1
Gui, Add, Checkbox, x+10 vb2 gRealtime, 2
Gui, Add, Checkbox, x+10 vb3 gRealtime, 3
Gui, Add, Checkbox, x+10 vb4 gRealtime, 4
Gui, Add, Checkbox, x+10 vb5 gRealtime, 5
Gui, Add, Checkbox, x+10 vb6 gRealtime, 6
Gui, Add, Checkbox, x+10 vb7 gRealtime, 7
Gui, Add, Checkbox, x+10 vb8 gRealtime, 8
Gui, Add, Text, x+10, []
Gui, Add, Checkbox, x+10 vb9 gRealtime, 9
Gui, Add, Checkbox, x+10 vb10 gRealtime, 10
Gui, Add, Checkbox, x+10 vb11 gRealtime, 11
Gui, Add, Checkbox, x+10 vb12 gRealtime, 12
Gui, Add, Button, x+10 w40 h15 vb13 g1allon, All On
Gui, Add, Button, x+5 w40 h15 vb14 g1alloff, All Off

Gui, Add, Checkbox, x5 y35 vUseHotKeys gUseHotkeys, Use F-keys as hotkeys. (^Space)
Gui, Add, Text, x474 y30 Hidden vpm, (+ or =)   (- minus)
Gui, Add, Text, x458 y45 Hidden vude, (Up/Down)  (Enter)

Gui, Add, Edit, x460 y60 w50 R1 Number vTime,
Gui, Add, UpDown, 0x80 Range0-10000, 1000
Gui, Add, Button, x+5 w40 h20 gRecord, Rec


Gui, Add, Button, x460 y85 w50 h20 gTest, Test
Gui, Add, Checkbox, x+5 vloop, Loop
Gui, Add, Text, x465 y105 Hidden vtl, (+Enter)    (+L)

Gui, Add, Text, x475 y125, LPT Address
Gui, Add, Groupbox, x460 y140 w95 h40 Center, 1 to 8  -  9 to 12
Gui, Add, Edit, x465 y155 w40 R1 vLPTA, 0x378
Gui, Add, Edit, x+5 w40 R1 vLPTB, 0x37A

Gui, Add, Groupbox, x460 y180 w95 h40 Center, Input Monitor
Gui, Add, Edit, x465 y195 w40 R1 vLPTI, 0x379
Gui, Add, Edit, x+5 w40 R1 vpIn, 

Gui, Add, ListView, x5 y60 w450 r10 AltSubmit -ReadOnly Grid NoSortHdr -LV0x10 vlv glv, Time|1-8|9-12
LV_ModifyCol(1,60)
LV_ModifyCol(2,40)
LV_ModifyCol(3,40)
Gui, Add, Edit, x5 y+5 w250 R1 vSaveAs,
Gui, Add, Button, x+5 w60 h20 gSave, Save (^s)
Gui, Add, Button, x+10 w80 h20 gClear, Clear All (^c)

Gui, Show, Center w560 h250, LPT Port Input Monitor and Output Sequencer
SetTimer, GetIn, 100
Return

Test:
Gui, Submit, NoHide
Loop % LV_GetCount() ;%
	{
    	LV_GetText(T1, A_Index,1)
    	LV_GetText(T2, A_Index,2)
	LV_GetText(T3, A_Index,3)
	LPTInOut_Out(T2,LPTA)
	LPTInOut_Out(T3,LPTB)
	Sleep , %T1%
	}
If Loop = 1
	GoTo Test
Return

^s::
Save:
Gui, Submit, NoHide
If SaveAs = 
	{
	GuiControl, , SaveAs, Please Enter a File Name.
	Return
	} 
If SaveAs = Please Enter a File Name.
	{
	GuiControl, , SaveAs, Please Enter a File Name.
	Return
	} 
FileAppend, #NoEnv`n, %SaveAs%.ahk
FileAppend, SetWorkingDir %A_ScriptDir%`n, %SaveAs%.ahk 
FileAppend, #SingleInstance Force`n`n, %SaveAs%.ahk
FileAppend, OnExit`, Off`n`n, %SaveAs%.ahk
FileAppend, Loop`,`n%A_Tab%{`n, %SaveAs%.ahk
Loop % LV_GetCount() ;%
	{
    	LV_GetText(T1, A_Index,1)
    	LV_GetText(T2, A_Index,2)
	LV_GetText(T3, A_Index,3)
	FileAppend, %A_Tab%LPTInOut_Out(%T2%`,%LPTA%)`n, %SaveAs%.ahk
	FileAppend, %A_Tab%LPTInOut_Out(%T3%`,%LPTB%)`n, %SaveAs%.ahk
	FileAppend, %A_Tab%Sleep %T1%`n, %SaveAs%.ahk
	}
FileAppend, %A_Tab%}`n, %SaveAs%.ahk
FileAppend, Return`n `n, %SaveAs%.ahk	
FileAppend, Esc::`nOff:`nLPTInOut_Off(%LPTA%`,%LPTB%)`nExitApp, %SaveAs%.ahk
Return

Record:
GoSub 1to8
GoSub 9to12
LV_Add(Col1, Time, 1thru8, 9thru12) 
Return

Off:
LPTInOut_Off(LPTA,LPTB)
Return

lv:
If A_GuiEvent = DoubleClick
	GoTo, DeleteRow
If A_GuiEvent = s
	GoTo, lvrd
If A_GuiEvent = RightClick
	GoTo, lvEdit
Return

DeleteRow:
Gui, +OwnDialogs
RowNumber := LV_GetNext(0,Focused)
If RowNumber = 0
	Return
MsgBox, 4,Delete Row, Delete this row?
IfMsgBox Yes
	LV_Delete(RowNumber)
Return

lvrd:
GuiControl, MoveDraw, lv, x5 y60
Return

lvEdit:
Send, {F2}
Return

^c::
Clear:
Gui, +OwnDialogs
RowCount := LV_GetCount()
If RowCount = 0
	Return
MsgBox, 4,Delete Sequence, Clear All?
IfMsgBox Yes
	LV_Delete()
Gosub, 1alloff
Return

Exit:
GuiClose:
LPTInOut_Out(0,LPTA)
LPTInOut_Out(11,LPTB)
Sleep, 250
Gui, Destroy
ExitApp

On(con)
	{
	GuiControl, Hide, %con%
	}
Off(con)
	{
	GuiControl, Show, %con%
	}

1to8:
Gui, Submit, NoHide
If b1 = 1
	b1 = 1
Else b1 = 0
If b2 = 1
	b2 = 2
Else b2 = 0
If b3 = 1
	b3 = 4
Else b3 = 0
If b4 = 1
	b4 = 8
Else b4 = 0
If b5 = 1
	b5 = 16
Else b5 = 0
If b6 = 1
	b6 = 32
Else b6 = 0
If b7 = 1
	b7 = 64
Else b7 = 0
If b8 = 1
	b8 = 128
Else b8 = 0
1thru8 := b1+b2+b3+b4+b5+b6+b7+b8 
Return

9to12:
Gui, Submit, NoHide
if (b9 = 0 and b10 = 0 and b11 = 0 and b12 = 0)
	{
	9thru12 = 11
	}
 if (b9 = 1 and b10 = 0 and b11 = 0 and b12 = 0)
	{
	9thru12 = 10
	}   
if (b9 = 1 and b10 = 1 and b11 = 0 and b12 = 0)
	{
	9thru12 = 8
	}
if (b9 = 1 and b10 = 1 and b11 = 1 and b12 = 0)
	{
	9thru12 = 12
	}
if (b9 = 1 and b10 = 1 and b11 = 1 and b12 = 1)
	{
	9thru12 = 20
	}
if (b9 = 1 and b10 = 0 and b11 = 1 and b12 = 0)
	{
	9thru12 = 14
	}
if (b9 = 1 and b10 = 0 and b11 = 1 and b12 = 1)
	{
	9thru12 = 6
	}
if (b9 = 1 and b10 = 0 and b11 = 0 and b12 = 1)
	{
	9thru12 = 2
	}
if (b9 = 1 and b10 = 1 and b11 = 0 and b12 = 1)
	{
	9thru12 = 16
	}
if (b9 = 0 and b10 = 1 and b11 = 0 and b12 = 0)
	{
	9thru12 = 9
	}
if (b9 = 0 and b10 = 1 and b11 = 0 and b12 = 1)
	{
	9thru12 = 1
	}	
if (b9 = 0 and b10 = 1 and b11 = 1 and b12 = 0)
	{
	9thru12 = 13
	}	
if (b9 = 0 and b10 = 1 and b11 = 1 and b12 = 1)
	{
	9thru12 = 5
	}	
if (b9 = 0 and b10 = 0 and b11 = 1 and b12 = 0)
	{
	9thru12 = 15
	}	
if (b9 = 0 and b10 = 0 and b11 = 1 and b12 = 1)
	{
	9thru12 = 7
	}	
if (b9 = 0 and b10 = 0 and b11 = 0 and b12 = 1)
	{
	9thru12 = 3
	}	
Return

Realtime:
GoSub 1to8 
GoSub 9to12 
LPTInOut_Out(1thru8,LPTA)
LPTInOut_Out(9thru12,LPTB)
Return

1allon:
Loop , 12
	{
	cont = b%A_Index% 
	GuiControl , , %cont%, 1
	}
GoSub, Realtime
Return

1alloff:
GoSub Off
Loop , 12
	{
	cont = b%A_Index% 
	GuiControl , , %cont%, 0 
	}
Return

^Space::
Gui, Submit, NoHide
If useHotKeys = 0
	GuiControl, , UseHotKeys, 1
Else, GuiControl, , UseHotKeys, 0
GoTo, UseHotKeys
Return

UseHotKeys:
Gui, Submit, NoHide
If useHotKeys = 1
	{
	Loop, 12
		{
		Hotkey, IfWinActive, LPT Port Input Monitor and Output Sequencer
		Hotkey, f%A_Index%, hkey, On
		}
	Hotkey, IfWinActive, LPT Port Input Monitor and Output Sequencer
	Hotkey, +, 1allon, On
	Hotkey, IfWinActive, LPT Port Input Monitor and Output Sequencer
	Hotkey, =, 1allon, On
	Hotkey, IfWinActive, LPT Port Input Monitor and Output Sequencer
	Hotkey, -, 1alloff, On
	GuiControl, Show, pm,
	Hotkey, IfWinActive, LPT Port Input Monitor and Output Sequencer
	Hotkey, Return, Record, On
	Hotkey, IfWinActive, LPT Port Input Monitor and Output Sequencer
	Hotkey, Up, ValUp, On
	Hotkey, IfWinActive, LPT Port Input Monitor and Output Sequencer
	Hotkey, Down, ValDn, On
	GuiControl, Show, ude,
	Hotkey, IfWinActive, LPT Port Input Monitor and Output Sequencer
	Hotkey, +Return, Test, On
	Hotkey, IfWinActive, LPT Port Input Monitor and Output Sequencer
	Hotkey, +L, Loop, On
	GuiControl, Show, tl,
	}
If useHotKeys = 0
	{
	Loop, 12
		{
		Hotkey, f%A_Index%, Off
		}
	Hotkey, +, off
	Hotkey, =, off
	Hotkey, -, off
	GuiControl, Hide, pm,
	Hotkey, Return, off
	Hotkey, Up, off
	Hotkey, Down, off
	GuiControl, Hide, ude,
	Hotkey, +Return, off
	Hotkey, +L, off
	GuiControl, Hide, tl,
	}
Return

hkey:
StringReplace, NewKey, A_ThisHotkey, f, b
Gui, Submit, NoHide
If %NewKey% = 1
	GuiControl, , %NewKey%, 0
Else, GuiControl, , %NewKey%, 1 
GoSub, Realtime
Return

ValUp:
Gui, Submit, NoHide
NewNum := Time+5
GuiControl, , Time, %NewNum%
Return

ValDn:
Gui, Submit, NoHide
NewNum := Time-5
GuiControl, , Time, %NewNum%
Return

Loop:
Gui, submit, NoHide
If loop = 0
	GuiControl, , loop, 1
Else, GuiControl, , loop, 0
Return

GetIn:
Gui, submit, NoHide
PortIn := LPTInOut_In(LPTI)
If PortIn = %LastIn%
	Return
GuiControl, , pIn, %PortIn%
LastIn = %PortIn%
InLabel = Input%PortIn%
If IsLabel(InLabel)
	GoTo %InLabel%
Return


Input120:
GoTo, 1alloff
Return

Input112:
GoSub, 1AllOff
GuiControl, , b1, 1
GoTo, RealTime
Return

Input104:
GoSub, 1AllOff
GuiControl, , b2, 1
GoTo, RealTime
Return

Input88:
GoSub, 1AllOff
GuiControl, , b3, 1
GoTo, RealTime
Return

Input56:
GoSub, 1AllOff
GuiControl, , b4, 1
GoTo, RealTime
Return


Input248:
GoSub, 1AllOff
GuiControl, , b5, 1
GoTo, RealTime
Return

Input96:
GoSub, 1AllOff
GuiControl, , b6, 1
GoTo, RealTime
Return

Input80:
GoSub, 1AllOff
GuiControl, , b7, 1
GoTo, RealTime
Return

Input48:
GoSub, 1AllOff
GuiControl, , b8, 1
GoTo, RealTime
Return

Input240:
GoSub, 1AllOff
GuiControl, , b9, 1
GoTo, RealTime
Return

Input72:
GoSub, 1AllOff
GuiControl, , b10, 1
GoTo, RealTime
Return

Input40:
GoSub, 1AllOff
GuiControl, , b11, 1
GoTo, RealTime
Return

Input232:
GoSub, 1AllOff
GuiControl, , b12, 1
GoTo, RealTime
Return

Input128:
GoTo, 1AllOn
Return

/*
S3 = Red/White		112
S4 = Dark Green		104
S5 = Pink		88
S6 = Black		56
S7 = Lite Green		248

0 =	S3 S4 S5 S6
8 =	S4 S5 S6
16 =	S3 S5 S6
24 =	S5 S6
32 =	S3 S4 S6
40 =	S4 S6
48 =	S3 S6
56 =	S6
64 =	S3 S4 S5
72 =	S4 S5
80 =	S3 S5
88 =	S5
96 =	S3 S4
104 = 	S4
112 = 	S3
120 = 	All Open
128 = 	S3 S4 S5 S6 S7
136 = 	S4 S5 S6 S7
144 = 	S3 S5 S6 S7
152 = 	S5 S6 S7
160 = 	S3 S4 S6 S7
168 = 	S4 S6 S7
176 = 	S3 S6 S7
184 = 	S6 S7
192 = 	S3 S4 S5 S7
200 = 	S4 S5 S7
208 = 	S3 S5 S7
216 = 	S5 S7
224 = 	S3 S4 S7
232 = 	S4 S7
240 = 	S3 S7
248 = 	S7
*/
