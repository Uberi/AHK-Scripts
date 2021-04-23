
#NoEnv 
SendMode Input  
SetWorkingDir %A_ScriptDir%  
#SingleInstance, Force
GoSub Off
; FederationBold
Gui, Font, cffd950 s16, Federation
Gui, Add, Pic, x0 y0, Engineering-1-.jpg
Gui, Add, Text, x5 y0 BackgroundTrans, Engineering 1
Gui, Font, ccc4a1b s10, FederationBold
Gui, Add, Text, x200 y0 w20 BackgroundTrans gExit, X

Gui, Add, Pic, x170 y34 w33 h17 Hidden vS1, s1.jpg
Gui, Add, Pic, x18 y81 w33 h17 Hidden vS2, s1.jpg
Gui, Add, Pic, x170 y70 w33 h17 Hidden vS3, s1.jpg
Gui, Add, Pic, x18 y108 w33 h18 Hidden vS4, s1.jpg
Gui, Add, Pic, x170 y109 w33 h17 Hidden vS5, s1.jpg
Gui, Add, Pic, x18 y136 w33 h18 Hidden vS6, s1.jpg
Gui, Add, Pic, x170 y192 w33 h17 Hidden vS7, s1.jpg
Gui, Add, Pic, x170 y221 w33 h17 Hidden vS8, s1.jpg

Gui, Add, Pic, x135 y29 w30 h30 Hidden vC1, c1.jpg
Gui, Add, Pic, x15 y175 w30 h30 Hidden vC2, c1.jpg
Gui, Add, Pic, x15 y215 w30 h30 Hidden vC3, c1.jpg

Gui, -Caption
Gui, Show, x400 y10 w216 h253, Eng1
OnMessage(0x201, "WM_LBUTTONDOWN")
GoTo Start
Return

Start:
Loop
	{
	GoSub Step1
	GoSub Step2
	GoSub Step3
	GoSub Step4
	GoSub Step5
	GoSub Step6
	GoSub Step7
	GoSub Step8
	GoSub Step9
	}
Return

Step1:
Off("S1") 
Off("S2") 
Off("S3") 
Off("S4") 
Off("S5") 
On("S6") 
On("S7") 
On("S8") 
On("C1") 
On("C2") 
On("C3")
AjaxLPT(224,"0x378")
AjaxLPT(12,"0x37A")
Sleep , 300
Return

Step2:
On("S3") 
On("S4") 
Off("C3") 
AjaxLPT(236,"0x378")
AjaxLPT(8,"0x37A")
Sleep , 700
Return

Step3:
On("S1")
On("S2")  
On("S3") 
On("S5") 
Off("S6")
Off("S7")
Off("S8")
Off("C2") 
AjaxLPT(31,"0x378")
AjaxLPT(10,"0x37A")
Sleep , 900
Return

Step4:
Off("S3")
Off("S4")
Off("C1")
On("C3") 
AjaxLPT(19,"0x378")
AjaxLPT(15,"0x37A")
Sleep , 300
Return

Step5:
On("S7") 
On("C2") 
AjaxLPT(71,"0x378")
AjaxLPT(13,"0x37A")
Sleep , 250
Return

Step6:
Off("S1") 
Off("S2") 
Off("S5") 
On("S6") 
On("S8") 
AjaxLPT(224,"0x378")
AjaxLPT(13,"0x37A")
Sleep , 1000
Return

Step7:
On("S3") 
On("S4") 
On("C1") 
Off("C3") 
AjaxLPT(236,"0x378")
AjaxLPT(8,"0x37A")
Sleep , 700
Return

Step8:
Off("C2") 
Off("S7") 
AjaxLPT(172,"0x378")
AjaxLPT(10,"0x37A")
Sleep , 100
Return

Step9:
On("S1") 
On("S2") 
On("S2") 
On("S5") 
Off("S6") 
Off("S8") 
AjaxLPT(31,"0x378")
AjaxLPT(10,"0x37A")
Sleep , 1050
Return

Off:
AjaxLPT(0,"0x378")
AjaxLPT(11,"0x37A")
Return

Exit:
GuiClose:
AjaxLPT(0,"0x378")
AjaxLPT(11,"0x37A")
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
WM_LBUTTONDOWN()
	{
	PostMessage, 0xA1, 2
	} 
Return
AjaxLPT(num,port)
	{
	DllCall("INPOUT32\Out32",int,port,int,num)
	}
