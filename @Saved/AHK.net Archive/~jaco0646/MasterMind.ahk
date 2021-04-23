#SingleInstance force
#NoTrayIcon
#NoEnv
SetBatchLines, -1
;
#Codes= 4	;Length of code to crack.
Rounds= 8	;Number of guesses per game.
Colors= FF0000|FFFF00|FF8C00|008000|0000FF|8B4513
;
Gui, Add, GroupBox, w240, Color Picker
Gui, Font, s20, WebDings
Loop, Parse, Colors, |
{
 Color%A_Index% := A_LoopField
 Gui, Add, Text, c%A_LoopField% v%A_LoopField% gPick xp+30 ym+20, g
}
Loop,%#Codes% {
 pos := A_Index=1 ? 70:"p+23"
 Gui, Add, Text, vCode%A_Index% x%pos%, g
 Gui, Font, cWhite, Times New Roman
 Gui, Add, Text, xp+7 BackgroundTrans, ?
 Gui, Font, cDefault, WebDings
}
Loop,%Rounds% {
 Row := A_Index
 Loop,%#Codes% {
  pos := A_Index=1 ? 10:"+0"
  Gui, Add, Checkbox
  , check3 vChk%Row%_%A_Index% gChkBox x%pos% w20 h20
 }
 Loop,%#Codes% {
  pos := A_Index=1 ? "+20":"+10"
  Gui, Add, Text, vBox%Row%_%A_Index% gClick x%pos%, g
 }
}
Gui, Font
Gui, Add, Button, vButton gSubmit x90, Submit Guess
Gui, Show,,MasterMind  ;v1.4
NewGame:
Loop,%#Codes% {
 Random, Code%A_Index%, 1,6
 Transform, Code%A_Index%, Deref,% "%Color" Code%A_Index% "%"
}
A_Guess := Rounds
If !A_Color
 return
Gui, Font, cDefault
Loop,%#Codes%
 GuiControl, Font, Code%A_Index%
Loop,%Rounds% {
 Row := A_Index
 Loop,%#Codes% {
  GuiControl,,Chk%Row%_%A_Index%,0
  GuiControl, Enable, Chk%Row%_%A_Index%
  GuiControl, Font, Box%Row%_%A_Index%
 }
}
WinSet, ReDraw
GuiControl,,Button, Submit
GuiControl, +gSubmit, Button
return
GuiClose:
ExitApp

Pick:
GuiControl,,%A_Color%, g
GuiControl,,%A_GuiControl%, n
A_Color := A_GuiControl
return

ChkBox:
GuiControl,,%A_GuiControl%, 0
return

Click:
If InStr(A_GuiControl,A_Guess) != 4
 return
Gui, Font, c%A_Color% s20, WebDings
GuiControl, Font, %A_GuiControl%
num := SubStr(A_GuiControl,0)
Guess%num% := A_Color
return

Submit:
Loop,%#Codes%
 If !(Guess%A_Index%) {
  Gui, +OwnDialogs
  MsgBox,48, MasterMind, Please fill in all %#Codes% boxes.
  return
 }
pos:=0,clr:=0
Loop,%#Codes% {
 tmp_Code%A_Index% := Code%A_Index%
 If (Guess%A_Index% = Code%A_Index%)
  pos++,Guess%A_Index%:=0,tmp_Code%A_Index%:=0
}
Loop,%#Codes% {
 If !(Guess%A_Index%)
  continue
 num := A_Index
 Loop,%#Codes%
  If (tmp_Code%A_Index%) AND (Guess%num% = Code%A_Index%) {
   clr++,tmp_Code%A_Index%:=0
   break
  }
}
Loop,%pos%
 GuiControl,,Chk%A_Guess%_%A_Index%,1
Loop,%clr% {
 num := A_Index + pos
 GuiControl,,Chk%A_Guess%_%num%,-1
}
Loop,%#Codes% {
 GuiControl, Disable, Chk%A_Guess%_%A_Index%
 Guess%A_Index%=
}
A_Guess--
If (pos = #Codes) OR !(A_Guess)
{
 msg := pos=#Codes ? "You Win!":"You Lose."
 Gui, +OwnDialogs
 MsgBox,64, MasterMind, Game Over.`n%msg%
 Loop,%#Codes% {
  Gui, Font,% "c" Code%A_Index%
  GuiControl, Font, Code%A_Index%
 }
 WinSet, ReDraw
 GuiControl,,Button, New Game
 GuiControl, +gNewGame, Button
}
return