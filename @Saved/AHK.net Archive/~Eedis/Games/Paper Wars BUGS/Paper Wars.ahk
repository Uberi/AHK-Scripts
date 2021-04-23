;Creator: Eedis
;Email: Killerbender53@yahoo.com
Images=%A_ScriptDir%\Images
Shots=1
Turn=2
CoordMode, Mouse, Relative

Menu, FileMenu, Add, Start New Game, StartNewGame

Menu, MyMenuBar, Add, File, :Filemenu
Menu, MyMenuBar, Add, Exit

Gui, Menu, MyMenuBar
Gui, Color, FFFFFF
Gui, Add, StatusBar,, Please start new game.
Gui, Add, Tab2, vTab x0 y0 w0 h0, Player1|Player2
Gui, Tab, 2
;~ Gui, Add, Picture, vCheckShot2 x-20 y-20 w5 h5, %Images%\Shot.bmp
Gui, Add, Picture, x0 y390 w800 h1, %Images%\Line.bmp
Gui, Tab, 1
;~ Gui, Add, Picture, vCheckShot1 x-20 y-20 w5 h5, %Images%\Shot.bmp
Gui, Add, Picture, x0 y390 w800 h1, %Images%\Line.bmp
Gui, Show, w800 h801, Paper Wars
Return

StartNewGame:
If ! Started
{
	Started++
	Gosub NewGame
}
Else
	Reload

^A::
NewGame:
SB_SetText("Player 1, please place your units.")
ShowToolTip("Player 1, please place your units.", 1000)
Loop 9
{
	MouseGetPos("BX", "BY")
	A_I:=A_Index
	If (A_Index <= 5)
	{
		Gui, Add, Picture, vP1%A_Index% x%BX% y%BY% w10 h26, %Images%\Soldier2.bmp
		P1%A_Index%HP=1
		P1HP+=1
	}
	If (A_Index > 5 AND A_Index < 9)
	{
		Gui, Add, Picture, vP1%A_Index% x%BX% y%BY% w20 h18, %Images%\Bunker2.bmp
		P1%A_Index%HP=2
		P1HP+=2
	}
	If (A_Index = 9)
	{
		Gui, Add, Picture, vP1%A_Index% x%BX% y%BY% w40 h40, %Images%\TankD.bmp
		P1%A_Index%HP=3
		P1HP+=3
	}
	Sleep 100
	Loop
	{
		MouseGetPos("FX", "FY")
		If (FX < 1)
			FX=1
		If (FX > 790)
			FX=790
		If (FY < 1)
			FY=1
		If (FY > 350)
			FY=350
		GuiControl, Move, P1%A_I%, x%fx% y%fy%
		GetKeyState, State, LButton
		If (State = "D")
		{
			P1X%A_I%:=FX
			P1Y%A_I%:=FY
			If (A_I <= 5)
			{
				P1XX%A_I%:=FX + 10	
				P1YY%A_I%:=FY + 26
			}
			If (A_I > 5 AND A_I < 9)
			{	
				P1XX%A_I%:=FX + 20
				P1YY%A_I%:=FY + 18
			}
			If (A_I = 9)
			{
				P1XX%A_I%:=FX + 40
				P1YY%A_I%:=FY + 40
			}
			CheckPlacement(1, A_I)
			If  (No = 0)
				Break
			No=0
			P1X%A_I%:=0
			P1Y%A_I%:=0
			P1XX%A_I%:=0
			P1YY%A_I%:=0
		}
	}
	Sleep 100
}
GuiControl, Choose, Tab, 2
Gui, Tab, 2
SB_SetText("Player 2, please place your units.")
ShowToolTip("Player 2, please place your units.", 1000)
Sleep 1000
Loop 9
{
	MouseGetPos("BX", "BY")
	A_I:=A_Index
	If (A_Index <= 5)
	{
		Gui, Add, Picture, vP2%A_Index% x%BX% y%BY% w10 h26, %Images%\Soldier2.bmp
		P2%A_Index%HP=1
		P2HP+=1
	}
	If (A_Index > 5 AND A_Index < 9)
	{
		Gui, Add, Picture, vP2%A_Index% x%BX% y%BY% w20 h18, %Images%\Bunker2.bmp
		P2%A_Index%HP=2
		P2HP+=2
	}
	If (A_Index = 9)
	{
		Gui, Add, Picture, vP2%A_Index% x%BX% y%BY% w40 h40, %Images%\TankD.bmp
		P2%A_Index%HP=3
		P2HP+=3
	}
	Sleep 100
	Loop
	{
		MouseGetPos("FX", "FY")
;~ 		ToolTip, %FX% - %FY%
		If (FX < 1)
			FX=1
		If (FX > 790)
			FX=790
		If (FY < 1)
			FY=1
		If (FY > 350)
			FY=350
		GuiControl, Move, P2%A_I%, x%fx% y%fy%
		GetKeyState, State, LButton
		If (State = "D")
		{
			P2X%A_I%:=FX
			P2Y%A_I%:=FY
			If (A_I <= 5)
			{
				P2XX%A_I%:=FX + 10	
				P2YY%A_I%:=FY + 26
			}
			If (A_I > 5 AND A_I < 9)
			{	
				P2XX%A_I%:=FX + 20
				P2YY%A_I%:=FY + 18
			}
			If (A_I = 9)
			{
				P2XX%A_I%:=FX + 40
				P2YY%A_I%:=FY + 40
			}
			CheckPlacement(2, A_I)
			If  (No = 0)
				Break
			No=0
			P2X%A_I%:=0
			P2Y%A_I%:=0
			P2XX%A_I%:=0
			P2YY%A_I%:=0
		}
	}
	Sleep 100
}

SB_SetText("Prepare for battle...")
ShowToolTip("Prepare for battle in...", 500)
Sleep 500
ShowToolTip("3", 1000)
Sleep 1000
ShowToolTip("2", 1000)
Sleep 1000
ShowToolTip("1", 1000)
Sleep 1000
ShowToolTip("Fight!", 1000)
SB_SetText("Battle has been engaged!")

^S::
Shooting:
Loop
{
	Sleep 200
	Send, {LButton Up}
	MouseGetPos("BX", "BY")
	Gui, Add, Picture, vShot%Shots% x%BX% y%BY% w5 h5, %Images%\Shot.bmp
	Loop
	{
		MouseGetPos("FX", "FY")
		If (FX < 1)
			FX=1
		If (FX > 795)
			FX=795
		If (FY <= 391)
			FY=391
		If (FY > 775)
			FY=775
		GuiControl, Move, Shot%Shots%, x%fx% y%fy%
		GetKeyState, State, LButton
		If (State = "D")
		{
			ShotX%Shots%:=FX
			ShotY%Shots%:=FY
			ShotXX%Shots%:=FX + 5
			ShotYY%shots%:=FY + 5
			ShotAY%Shots%:=FigureShot(FY)
			ShotAYY%Shots%:=FigureShot(FY) + 5
			CheckShotY:=ShotAY%Shots%
			Gui, Add, Picture, vCheckShot%Shots% x%FX% y%CheckShotY% w5 h5, %Images%\Shot.bmp
;~ 			GuiControl, Move, CheckShot%Turn%, % "x"FX "y"ShotAY%Shots%
			CheckShot(ShotX%Shots%, ShotY%Shots%, ShotAY%Shots%, ShotAYY%Shots%)
;~ 			GuiControl, Move, CheckShot%Turn%, x-20 y-20
			Shots++
			Break
		}
	}
}
Return

CheckShot(TCX, TCXX, TCY, TCYY)
{
	global
	Loop 9
	{
		GuiControlGet, CheckThis, Pos, P%Turn%%A_Index%
		CheckThisxx:=CheckThisx + CheckThisw
		CheckThisyy:=CheckThisy + CheckThish
		If (TCX >= CheckThisx AND TCX <= CheckThisxx OR TCXX >= CheckThisx AND TCXX <= CheckThisxx)
			If (TCY >= CheckThisy AND TCY <= CheckThisyy OR TCYY >= CheckThisy AND TCYY <= CheckThisyy)
			{
				ShowToolTip("Hit!", 500)
				Sleep 500
				P%Turn%%A_Index%HP--
				P%Turn%HP--
				If (P%Turn%%A_Index%HP < 1)
					GuiControl, Move, P%Turn%%A_Index%, x-50 y-50
				Sleep 500
				GuiControl, Move, CheckShot%Shots%, x-20 y-20
				GuiControl, Move, Shot%Shots%, x-20 y-20
				If (P%Turn%HP < 1)
				{
					If (Turn = 1)
						Turn=2
					Else
						Turn=1
					Msgbox, 4, Game over., Player%Turn% has won the game! Would you like to play again?
					IfMsgBox, Yes
						Reload
					IfMsgBox, No
						ExitApp
				}
				If (Turn = 1)
					Turn=2
				Else
					Turn=1
				GuiControl, Choose, Tab, %Turn%
				Gui, Tab, %Turn%
				Return
			}
	}
	If (Turn = 1)
		Turn=2
	Else
		Turn=1
	Sleep 1000
	GuiControl, Choose, Tab, %Turn%
	Gui, Tab, %Turn%
}

FigureShot(SY)
{
	NN:=SY - 388
	NNY:=388 - NN
	Return NNY
}
	
ShowToolTip(TTS, DTS)
{
	global
	Text=%TTS%
	Gosub, ToolTip
	SetTimer, ToolTip, %DTS%
	Return
	
	ToolTip:
	If ! HMT
	{
		ToolTip, %Text%
		HMT++
	}
	Else
	{
		HMT:=""
		ToolTip
		SetTimer, ToolTip, Off
	}
	Return
}

CheckPlacement(PT, NoL)
{
	Global
	NoL--
	If (NoL = 0)
		Return
	Loop %NoL%
	{
		If (P%PT%X%A_I% >= P%PT%X%A_Index% AND P%PT%X%A_I% <= P%PT%XX%A_Index% OR P%PT%XX%A_I% >= P%PT%X%A_Index% AND P%PT%XX%A_I% <= P%PT%XX%A_Index%)
			If (P%PT%Y%A_I% >= P%PT%Y%A_Index% AND P%PT%Y%A_I% <= P%PT%YY%A_Index% OR P%PT%YY%A_I% >= P%PT%Y%A_Index% AND P%PT%YY%A_I% <= P%PT%YY%A_Index%)
			{
				ShowToolTip("You cannot place a unit on top of another.", 1000)
				No=1
				Return
			}
	}
}

MouseGetPos(TX, TY)
{
	MouseGetPos, %TX%, %TY%
	%TY%-=50
}

UP::Msgbox, Player1 HP:%P1HP%`nPlayer2 HP:%P2HP%
DOWN::GuiControl, Choose, Tab, 1

Exit:
GuiClose:
ESC::ExitApp
