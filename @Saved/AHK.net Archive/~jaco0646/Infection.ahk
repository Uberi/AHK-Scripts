#SingleInstance force
#NoTrayIcon
#NoEnv
SetBatchLines, -1
;
;		Default Settings:
Players= 1	;1|2 	Number of people to play.
Level=   1	;1|2	Strength of the PC.
P1clr= 8B0000	;The RGB color of Player 1's cells.
P2clr= 00008B	;The RGB color of Player 2's cells.
Delay= 250	;Infection rate (in milliseconds):
;		 slows down the game for beginners.
;_________________________________
all = A|B|C|D|E
A=1,8,15,22,29,36,43
B=2,9,16,23,30,37,44
C=3,4,5,10,11,12,17,18,19,24,25,26,31,32,33,38,39,40,45,46,47
D=6,13,20,27,34,41,48
E=7,14,21,28,35,42,49
TwinA=-7,-6,1,8,7
JumpA=-14,-13,-12,-5,2,9,14,15,16
TwinB=-8,-7,-6,1,8,7,6,-1
JumpB=-15,-14,-13,-12,-5,2,9,13,14,15,16
TwinC=-8,-7,-6,1,8,7,6,-1
JumpC=-16,-15,-14,-13,-12,-9,-5,-2,2,5,9,12,13,14,15,16
TwinD=-8,-7,-6,1,8,7,6,-1
JumpD=-16,-15,-14,-13,-9,-2,5,12,13,14,15
TwinE=-8,-7,7,6,-1
JumpE=-16,-15,-14,-9,-2,5,12,13,14
;_________________________________
Menu, Menu1, Add, New Game, NewGame
Menu, Menu1, Add, Blocks..., BlocksGUI
Menu, Menu1, Add, About..., About
Menu, Menu1, Add, Exit  ( Esc ), GuiClose
Menu, Menu2, Add, Level 1, Level
Menu, Menu2, Add, Level 2, Level
Menu, Menu2, Check, Level %Level%
Menu, Menu3, Add, 1 Player, Players
Menu, Menu3, Add, 2 Player, Players
Menu, Menu3, Check, %Players% Player
Menu, Menu4, Add, Pressibus.org, URL
Menu, Menu4, Add, Extreme Ataxx, URL
Menu, Menu4, Add, Wikipedia, URL
Menu, MenuBar1, Add, Infection, :Menu1
Menu, MenuBar1, Add, Level, :Menu2
Menu, MenuBar1, Add, Players, :Menu3
Menu, MenuBar1, Add, Help, :Menu4
Menu, MenuBar1, Color, 000000, Single
Gui, Menu, MenuBar1
Gui, Color, 000000
Gui, Font, s50 c696969, WebDings
Gui, Margin, 5,5
Loop,49
{
 If A_Index in 1,8,15,22,29,36,43
  xPos = m
 Else xPos = +5
 Gui, Add, Text, x%xPos% v%A_Index% gClick, g
 If A_Index in 1,49
  Gui, Font, c%P1clr%
 Else If A_Index in 7,43
  Gui, Font, c%P2clr%
 Gui, Add, Text, xp yp vC%A_Index% BackgroundTrans, n
 Gui, Font, c696969
}
Gui, Font, s12 cDefault, Tahoma
Gui, Add, Button, xm+226 gPass, Pass
Gui, Font, s50 c%P1clr%, WebDings
Gui, Add, Text, xm+4 vTurn1, 4
Gui, Add, Text, xm+60 yp, =
Gui, Font,,Courier New Bold
Gui, Add, Text, vP1count x+5,% "2 "
Gui, Font, c%P2clr%
Gui, Add, Text, vP2count x+75,% " 2"
Gui, Font,,WebDings
Gui, Add, Text, x+5, =
Gui, Font, c000000
Gui, Add, Text, x+-7 vTurn2, 3
Gui, Show,,Infection (~Ataxx~)
BlockCount=0
NewGame:
If A_ThisMenu
{
 Loop,49
 {
  Gui, Font, c696969
  GuiControl, Font, %A_Index%
  If A_Index in 1,49
   Gui, Font, c%P1clr%
  Else If A_Index in 7,43
   Gui, Font, c%P2clr%
  Else If A_Index in %Blocks%
   Gui, Font, c000000
  GuiControl, Font, C%A_Index%
 }
 GuiControl,,P1count,% "2 "
 GuiControl,,P2count,% " 2"
 GuiControl,,Turn1, 4
 GuiControl,,Turn2, 3
 GameOver = 0
 turn = 2
 GoSub, NewTurn
 WinSet, ReDraw,,Infection ahk_class AutoHotkeyGUI
}
turn=1
click=1
P1=1,49
P2=7,43
LastCell=
return
GuiEscape:
GuiClose:
ExitApp

Click:
If GameOver
 return
If (A_GuiControl = LastCell)
{
 Gui, Font, c696969
 GuiControl, Font, %LastCell%
 Gui, Font,% "c" P%turn%clr
 GuiControl, Font, C%LastCell%
 LastCell=
 click = 1
 return
}
If click = 1
{
 Loop,2
  If (turn = A_Index)
   If A_GuiControl not in % P%A_Index%
    return
 Gui, Font, c32CD32
 GuiControl, Font, %A_GuiControl%
 Gui, Font,% "c" P%turn%clr
 GuiControl, Font, C%A_GuiControl%
 LastCell := A_GuiControl
 click = 2
 return
}
Loop,2
 If A_GuiControl in % P%A_Index%
  return
If A_GuiControl in %Blocks%
 return
Loop, Parse, all, |
 If LastCell in % %A_LoopField%
 {
  twin := Twin%A_LoopField%
  jump := Jump%A_LoopField%
  break
 }
move := A_GuiControl - LastCell
If move in %twin%
 move = 1
Else If move in %jump%
 move = 2
Else move = 0
Move:
If (Players = 1) AND (turn = 2)
{
 If Level = 1
  Sleep,% Delay * 2
}
Else NewCell := A_GuiControl
If move
{
 Gui, Font, c696969
 GuiControl, Font, %LastCell%
 If move = 2
  GuiControl, Font, C%LastCell%
 Gui, Font,% "c" P%turn%clr
 If move = 1
  GuiControl, Font, C%LastCell%
 GuiControl, Font, C%NewCell%
 Loop, Parse, all, |
  If NewCell in % %A_LoopField%
  {
   twin := Twin%A_LoopField%
   break
  }
 infection := "," NewCell
 invs := turn=1 ? 2:1
 Loop, Parse, twin, `,
 {
  infect := NewCell + A_LoopField
  If infect in % P%invs%
  {
   Sleep,%Delay%
   GuiControl, Font, C%infect%
   infection .= "," infect
  }
 }
 P%turn% .= infection
 If move = 2
 {
  temp := P%turn%
  P%turn%=
  Loop, Parse, temp, `,
  {
   If (A_LoopField = LastCell)
    continue
   P%turn% .= "," A_LoopField
  }
  StringTrimLeft, P%turn%, P%turn%, 1
 }
 If StrLen(infection) > 3
 {
  temp := P%invs%
  P%invs%=
  Loop, Parse, temp, `,
  {
   If A_LoopField in %infection%
    continue
   P%invs% .= "," A_LoopField
  }
  StringTrimLeft, P%invs%, P%invs%, 1
 }
 Loop,2
 {
  num := A_Index
  P%num%count = 0
  Loop, Parse, P%num%, `,
   P%num%count++
  If (num = 2) AND (P%num%count < 10)
   P%num%count := A_Space P%num%count
  GuiControl,,P%num%count,% P%num%count
 }
 If (P1count + P2count) = (49 - BlockCount)
 {
  num := P1count > P2count ? 1:2
  Gui, +OwnDialogs
  MsgBox,64,Infection
  , Game Over.`n`nPlayer %num% wins!
  GameOver = 1
  turn := num=1 ? 2:1
 }
 Else If P%invs%count = 0
 {
  Gui, +OwnDialogs
  MsgBox,64,Infection
  , Game Over.`n`nPlayer %invs% is eliminated.
  GameOver = 1
  turn := invs
 }
 LastCell=
 click = 1
 GoSub, NewTurn
}
return

NewTurn:
Gui, Font, c000000
GuiControl, Font, Turn%turn%
turn := turn=1 ? 2:1
Gui, Font,% "c" P%turn%clr
GuiControl, Font, Turn%turn%
If GameOver
 GuiControl,,Turn%turn%, `%
Else If (Players = 1) AND (turn = 2)
 GoSub, Pass
return

Pass:
If GameOver
 return
trap = 0
viable=
Loop, Parse, P%turn%, `,
{
 LastCell := A_LoopField
 Loop, Parse, all, |
  If LastCell in % %A_LoopField%
  {
   twin := Twin%A_LoopField%
   jump := Jump%A_LoopField%
   break
  }
 Loop,2
 {
  move := A_Index=1 ? 1:2
  moves := A_Index=1 ? twin:jump
  Loop, Parse, moves, `,
  {
   NewCell := LastCell + A_LoopField
   If (NewCell < 1) OR (NewCell > 49)
    continue
   If NewCell not in %P1%
    If NewCell not in %P2%
     If NewCell not in %Blocks%
      If (Players = 1) AND (turn = 2)
      {
       Loop, Parse, all, |
        If NewCell in % %A_LoopField%
        {
         twin := Twin%A_LoopField%
         break
        }
       If Level = 2
       {
        If move = 2
        {
         temp := NewCell
         Loop, Parse, P2, `,
         {
          If (A_LoopField = LastCell)
           continue
          temp .= "," A_LoopField
         }
        }
        Else temp := P2 "," NewCell
       }
       infection := move=1 ? 1:0
       Loop, Parse, twin, `,
       {
        infect := NewCell + A_LoopField
        If infect in %P1%
        {
         infection++
         If Level = 2
          temp .= "," infect
        }
       }
       If Level = 2
       {
        tempP1=
        Loop, Parse, P1, `,
        {
         If A_LoopField in %temp%
          continue
         tempP1 .= "," A_LoopField
        }
        If !(tempP1)
        {
         GoSub, Move
         return
        }
        StringTrimLeft, tempP1, tempP1, 1
        bestMoveP1 = 0
        Loop, Parse, tempP1, `,
        {
         LastCellP1 := A_LoopField
         Loop, Parse, all, |
          If LastCellP1 in % %A_LoopField%
          {
           twinP1 := Twin%A_LoopField%
           jumpP1 := Jump%A_LoopField%
           break
          }
         Loop,2
         {
          moveP1 := A_Index=1 ? 1:2
          movesP1 := A_Index=1 ? twinP1:jumpP1
          Loop, Parse, movesP1, `,
          {
           NewCellP1 := LastCellP1 + A_LoopField
           If (NewCellP1 < 1) OR (NewCellP1 > 49)
            continue
           If NewCellP1 not in %tempP1%
            If NewCellP1 not in %temp%
             If NewCellP1 not in %Blocks%
             {
              Loop, Parse, all, |
               If NewCellP1 in % %A_LoopField%
               {
                twinP1 := Twin%A_LoopField%
                break
               }
              infectionP1 := moveP1=1 ? 1:0
              Loop, Parse, twinP1, `,
              {
               infect := NewCellP1 + A_LoopField
               If infect in %temp%
                infectionP1++
              }
              If (infectionP1 > bestMoveP1)
               bestMoveP1 := infectionP1
             }
          }
         }
        }
        infection -= bestMoveP1
       }
       viable .= infection "." move "=" LastCell ":" NewCell "`n"
      }
      Else GoTo, Msg
  }
 }
}
If (Players = 1) AND (turn = 2) AND (viable)
{
 Sort, viable, RN
 Loop, Parse, viable, `n
 {
  If A_Index = 1
  {
   invs := A_LoopField
   bestMove := invs
   num = 1
   continue
  }
  If (SubStr(A_LoopField,1,2) < SubStr(invs,1,2))
   break
  bestMove .= "`n" A_LoopField
  invs := A_LoopField
  num := A_Index
 }
 Random, random, 1, %num%
 Loop, Parse, bestMove, `n
  If (A_Index = random)
  {
   If (SubStr(A_LoopField,1,1) = "-")
    StringTrimLeft, bestMove, A_LoopField, 1
   Else bestMove := A_LoopField
   move := SubStr(bestMove,3,1)
   LastCell := SubStr(bestMove,5,2)
   StringReplace, LastCell, LastCell, :
   NewCell := SubStr(bestMove,7)
   StringReplace, NewCell, NewCell, :
   break
  }
 GoSub, Move
 return
}
trap = 1
Msg:
Gui, +OwnDialogs
If trap
{
 invs := turn=1 ? 2:1
 If (P%invs%count > P%turn%count)
 {
  MsgBox,64,Infection
  , Game Over.`n`nPlayer %invs% wins!
  GameOver = 1
 }
 Else MsgBox,64,Infection
 , Player %turn% is trapped.`nThe turn is forfeit.
 GoSub, NewTurn
}
Else MsgBox,48,Infection
 , You may pass only when`nno moves are available.
return

BlocksGUI:
Gui, 2:+LastFoundExist
IfWinExist
{
 Gui, 2:Show
 return
}
;___________________
Block2 = 2|6|44|48
Block3 = 3|5|45|47
Block4 = 4|46
Block8 = 8|14|36|42
Block9 = 9|13|37|41
Block10= 10|12|38|40
Block11= 11|39
Block15= 15|21|29|35
Block16= 16|20|30|34
Block17= 17|19|31|33
Block18= 18|32
Block22= 22|28
Block23= 23|27
Block24= 24|26
Block25= 25
;___________________
Gui, 2:+Owner1
Gui, 2:Margin, 5,10
Loop,49
{
 If A_Index in 1,8,15,22,29,36,43
  xPos = m+15
 Else xPos = +0
 If A_Index in 2,3,4,8,9,10,11,15,16,17,18,22,23,24,25
  On = 0
 Else On = 1
 Gui, 2:Add, CheckBox
 , x%xPos% v%A_Index% Disabled%On% gBlocks Check3
}
Gui, 2:Add, Button, xm+15 w50 gBlocks Default, OK
Gui, 2:Add, Button, x+15 w50 gCancel, Cancel
Gui, 2:Add, Button, X+15 w50 gBlocks, Clear
Gui, 2:Show,,Blocks
return
2GuiClose:
Gui, 2:Hide
return

Blocks:
If A_GuiControl is digit
{
 GuiControlGet, On,,%A_GuiControl%
 On := On=1 ? -1:0
 Loop, Parse, Block%A_GuiControl%, |
  GuiControl,,%A_LoopField%, %On%
 return
}
If A_GuiControl = Clear
 Loop,49
  GuiControl,,%A_Index%, 0
Else If A_GuiControl = OK
{
 temp := Blocks
 Blocks=
 Loop,49
 {
  GuiControlGet, On,, %A_Index%
  If On
   Blocks .= "," A_Index
 }
 StringReplace, Blocks, Blocks, `,, `,, UseErrorLevel
 If ErrorLevel > 24
 {
  Gui, +OwnDialogs
  MsgBox,48,Blocks
  , Too many blocks (%ErrorLevel%).`n`nThe maximum allowed is 24.
  Blocks := temp
  GoSub, Cancel
  return
 }
 BlockCount := ErrorLevel
 StringTrimLeft, Blocks, Blocks, 1
 Gui, 2:Hide
 Gui, 1:Default
 GoSub, NewGame
 Gui, Font, c000000
 Loop,49
  If A_Index in %Blocks%
  {
   GuiControl,,C%A_Index%, !
   GuiControl, Font, C%A_Index%
  }
  Else GuiControl,,C%A_Index%, n
}
return

Cancel:
Loop,49
 If A_Index in %Blocks%
  GuiControl,2:,%A_Index%, -1
 Else GuiControl,2:,%A_Index%, 0
If A_GuiControl = Cancel
 Gui, 2:Hide
return

About:
MsgBox,,About: Infection
, Composed in AutoHotkey by:
(
`njaco0646`nv1.0`nhttp://autohotkey.net/~jaco0646/
`nInfection is an Ataxx game.
See the links in the Help menu for more info.
)
return

Level:
Loop,2
 If (A_ThisMenuItemPos = A_Index)
  Menu, Menu2, Check, %A_ThisMenuItem%
 Else Menu, Menu2, UnCheck, Level %A_Index%
Level := A_ThisMenuItemPos
return

Players:
Loop,2
 If (A_ThisMenuItemPos = A_Index)
  Menu, Menu3, Check, %A_ThisMenuItem%
 Else Menu, Menu3, UnCheck, %A_Index% Player
Players := A_ThisMenuItemPos
If (Players = 1) AND (turn = 2)
 GoSub, Pass
return

URL:
If A_ThisMenuItemPos = 1
 Run, http://www.pressibus.org/ataxx/indexgb.html
Else If A_ThisMenuItemPos = 2
 Run, http://www.geocities.com/mark_gamez/extreme-ataxx/
Else If A_ThisMenuItemPos = 3
 Run, http://en.wikipedia.org/wiki/Ataxx
return