

#NoEnv  
SendMode Input  
SetWorkingDir %A_ScriptDir%  
#SingleInstance Force
;#Include LTPInOut.ahk
GoSub Off

Gui, Add, Checkbox, x5 y5 vb1 gRealtime, 1
Gui, Add, Checkbox, x5 y+5 vb2 gRealtime, 2
Gui, Add, Checkbox, x5 y+5 vb3 gRealtime, 3
Gui, Add, Checkbox, x5 y+5 vb4 gRealtime, 4
Gui, Add, Checkbox, x5 y+5 vb5 gRealtime, 5
Gui, Add, Checkbox, x5 y+5 vb6 gRealtime, 6
Gui, Add, Checkbox, x5 y+5 vb7 gRealtime, 7
Gui, Add, Checkbox, x5 y+5 vb8 gRealtime, 8
Gui, Add, Checkbox, x5 y+5 vb9 gRealtime, 9
Gui, Add, Checkbox, x5 y+5 vb10 gRealtime, 10
Gui, Add, Checkbox, x5 y+5 vb11 gRealtime, 11
Gui, Add, Checkbox, x5 y+5 vb12 gRealtime, 12

Gui, Add, GroupBox, x60 y5 w60 h40 Center, Port 1-8
Gui, Add, Edit, x65 y20 w50 vLPTA, 0x378

Gui, Add, GroupBox, x60 y50 w60 h40 Center, Port 9-12
Gui, Add, Edit, x65 y65 w50 vLPTB, 0x37A

Gui, Add, Button, x60 y160 w60 h25 gAllOn, All On
Gui, Add, Button, x60 y190 w60 h25 gAllOff, All Off

Gui, Show, w125 h220, LPT Port Controler
Return

Realtime:
GoSub 1to8 
GoSub 9to12 
LPTInOut_Out(1thru8,LPTA)
LPTInOut_Out(9thru12,LPTB)
Return

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

AllOn:
Loop , 12
	{
	cont = b%A_Index% 
	GuiControl , , %cont%, 1
	}
GoSub, Realtime
Return

AllOff:
GoSub Off
Loop , 12
	{
	cont = b%A_Index% 
	GuiControl , , %cont%, 0 
	}
Return

Off:
LPTInOut_Off(LPTA,LPTB)
Return

GuiEscape:
Exit:
GuiClose:
GoSub Off
Gui, Destroy
ExitApp
Return




