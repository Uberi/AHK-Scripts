#SingleInstance force
#NoTrayIcon
#NoEnv
SetBatchLines, -1
;___________________
;                   Default Settings:
Gui, Color, DAA520  ;RGB color of the board
Pits_Color= B8860B  ;RGB color of the pits
Pits_Count= 0       ;seeds left in pits count in final score
Seeds = 3           ;number of seeds to start in each pit
Delay = 500         ;sowing rate (in milliseconds)
;                    slows down the game for beginners
;___________________
A_Pad := A_Space A_Space
Gui, Margin, 0,0
Gui, Add, Text, vTurn, Player 1
Loop,14 {
 Gui, Font, s100 c%Pits_Color%, WebDings
 Gui, Add, Text
  ,% A_Index=1 ? "xm y100":A_Index=2 ? "ym Section"
  :A_Index<8 ? "ym":A_Index=8 ? "xs y200 Section"
  :A_Index<14 ? "ys+0":A_Index=14 ? "ys+0 y100":"", n
 Gui, Font, s50 cBlack, Comic Sans MS
 Gui, Add, Text, xp yp wp hp BackgroundTrans vPit%A_Index% gClick
  ,% A_Index=1 ? A_Pad 0:A_Index<14 ? A_Pad seeds:A_Pad 0
}
Gui, Show,,Mancala
return
GuiClose:
ExitApp

Click:
If A_GuiEvent != DoubleClick
 return
Pit := SubStr(A_GuiControl,4)
If !(turn) AND (Pit<8 OR Pit>13)
 return
If (turn) AND (Pit<2 OR Pit>7)
 return
Sow(Pit)
Steal(Pit)
If winner := GameOver() {
 Gui, +OwnDialogs
 MsgBox,68,,Game Over.`n`n%winner%`n`nPlay Again?
 IfMsgBox, Yes
  Reload
 ExitApp
}
If (!turn AND Pit=14) OR (turn AND Pit=1)
 return
turn := !turn
GuiControl,,Turn,% "Player " turn+1
return

Sow(num)
{
 global Pit, Delay, A_Pad, turn
 GuiControlGet, seeds,,Pit%Pit%
 GuiControl,,Pit%Pit%,% A_Pad 0
 While seeds {
  Pit += Pit=1 ? 7:Pit<8 ? -1:Pit<14 ? 1:Pit=14 ? -7:""
  If (!turn AND Pit=1) OR (turn AND Pit=14)
   continue
  Sleep,%Delay%
  GuiControlGet, num,,Pit%Pit%
  GuiControl,,Pit%Pit%,% A_Pad num+1
  seeds--
 }
}

Steal(num)
{
 global Pit, Delay, A_Pad, turn
 If (Pit=1) OR (Pit=14)
 OR (!turn AND Pit<8) OR (turn AND Pit>7)
  Return
 GuiControlGet, seeds,,Pit%Pit%
 If seeds != 1
  Return
 num += Pit<8 ? 6:-6
 GuiControlGet, seeds2,,Pit%num%
 If seeds2 {
  Sleep,%Delay%
  GuiControl,,Pit%num%,% A_Pad 0
  Sleep,%Delay%
  GuiControl,,Pit%Pit%,% A_Pad 0
  Sleep,%Delay%
  num := turn ? 1:14
  GuiControlGet, seeds,,Pit%num%
  GuiControl,,Pit%num%,% A_Pad seeds + seeds2 + 1
 }
}

GameOver()
{
 global Pit, Turn
 Loop,6 {
  num := A_Index+1
  GuiControlGet, num,,Pit%num%
  seeds2 += num
  num := A_Index+7
  GuiControlGet, num,,Pit%num%
  seeds1 += num
  If (seeds1) AND (seeds2)
   Return, 0
 }
 GuiControlGet, score1,,Pit14
 GuiControlGet, score2,,Pit1
 score1 += Pits_Count ? seeds1:0
 score2 += Pits_Count ? seeds2:0
 GuiControl,,Turn,% score1 "-" score2
 Return,% score1=score2 ? "Draw"
  :score1>score2 ? "Player 1 Wins!":"Player 2 Wins!"
}