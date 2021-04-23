Iterations = ;100000
State = A
DefaultCell = 0
ProgramCode = 10101|01010

UseSaveFile = 1
SaveFilePath = %A_ScriptDir%\TuringProgress.txt

SetBatchLines, -1
ActionA0 := "1|1|B", ActionA1 := "2|-1|A", ActionA2 := "1|-1|A", ActionB0 := "2|-1|A", ActionB1 := "2|1|B", ActionB2 := "0|1|A"

If (UseSaveFile && FileExist(SaveFilePath))
{
 FileRead, Temp1, %SaveFilePath%
 StringSplit, Temp, Temp1, |
 Index := Temp1, IterationCount := Temp2, State := Temp3, NegativeCells := Temp4, PositiveCells := Temp5
}
Else
{
 IfNotInString, ProgramCode, |
  ProgramCode = |%ProgramCode%
 StringSplit, Temp, ProgramCode, |
 NegativeCells := Temp1, PositiveCells := Temp2, Index := 0, IterationCount := 0
}

Gui, Color, Black
Gui, +ToolWindow +AlwaysOnTop +LastFound -Caption
WindowID := WinExist()
Gui, Font, s6 cWhite, Arial
Loop, 61
{
 Temp1 := ((A_Index - 1) * 15) + 1
 Gui, Add, Progress, x%Temp1% y1 w14 h40 vCell%A_Index% BackgroundWhite
 Gui, Add, Text, x%Temp1% y42 w15 h10 vLabel%A_Index% Center
}
Gui, Add, Text, x2 y54 w26 h10 vState
Gui, Add, Text, x35 y54 w50 h10 vCurrentCell
Gui, Add, Text, x350 y54 w158 h10 vActions
Gui, Add, Text, x844 y54 w33 h10, Iterations:
Gui, Add, Text, x884 y54 w29 h10 vIterations Right
Gui, Font, s4 cWhite Bold, Arial
Gui, Add, Text, x450 y1 w15 h10 Center, V
GuiControl, Move, Cell31, x451 y8 w14 h33
Gui, Show, y20 w916 h64, Wolfram's 2-State 3-Symbol Turing Machine

MaxIndex := ProgramOffset + StrLen(ProgramCode), MinIndex := ProgramOffset
While, ((Iterations = "") || IterationCount <= Iterations)
{
 CurrentCell := CellGet(Index)
 StringSplit, Temp, Action%State%%CurrentCell%, |

 ;/*
 Loop, 61
 {
  TempIndex := (Index + A_Index) - 31
  GuiControl,, Label%A_Index%, %TempIndex%
  CellColor := CellGet(TempIndex), CellColor := (CellColor = 2) ? "Red" : ((CellColor = 1) ? "FFCC00" : "White")
  GuiControl, +Background%CellColor%, Cell%A_Index%
 }
 GuiControl,, State, State: %State%
 GuiControl,, Actions, % "Actions: Print " . Temp1 . ", Move " . ((Temp2 = -1) ? "left" : "right") . ", " . ((State <> Temp3) ? "Switch to state " . Temp3 : "Do not switch state")
 GuiControl,, CurrentCell, Current Cell: %CurrentCell%
 GuiControl,, Iterations, %IterationCount%
 Sleep, 100
 ;*/
 IterationCount ++

 CellPut(Index,Temp1), Index += Temp2, (Index > MaxIndex) ? MaxIndex := Index : "", (Index < MinIndex) ? MinIndex := Index : "", State := Temp3
}
MsgBox, 64, Complete, Completed %Iterations% iterations of the Turing machine.
Return

~LButton::
CoordMode, Mouse, Relative
MouseGetPos, OffsetX, OffsetY, CurrentWin
CoordMode, Mouse
If CurrentWin <> %WindowID%
 Return
IfWinNotActive, ahk_id %WindowID%
 Return
SetTimer, MoveWin, 50
Return

MoveWin:
MouseGetPos, MouseX, MouseY
If Not GetKeyState("LButton")
{
 SetTimer, MoveWin, Off
 Return
}
Gui, +LastFound
WinGetPos, WinX, WinY, WinW, WinH
WinX -= OffsetX - MouseX, WinY -= OffsetY - MouseY
WinMove, WinX, WinY
Return

GuiEscape:
GuiClose:
If UseSaveFile
{
 FileDelete, %SaveFilePath%
 FileAppend, %Index%|%IterationCount%|%State%|%NegativeCells%|%PositiveCells%, %SaveFilePath%
}
ExitApp

CellGet(Index)
{
 global NegativeCells
 global PositiveCells
 global DefaultCell
 Temp1 := (Index < 0) ? SubStr(NegativeCells,Abs(Index),1) : SubStr(PositiveCells,Index + 1,1)
 Return, (Temp1 = "") ? DefaultCell : Temp1
}

CellPut(Index,Char)
{
 global NegativeCells, PositiveCells, DefaultCell
 static StrGetFunc := "StrGet"
 CharType := A_IsUnicode ? "UShort" : "UChar", (Index < 0) ? (Index := 0 - Index, Temp1 := Index - StrLen(NegativeCells), (Temp1 > 0) ? (VarSetCapacity(Pad,64), VarSetCapacity(Pad,0), VarSetCapacity(Pad,Temp1,Asc(DefaultCell)), NegativeCells .= A_IsUnicode ? %StrGetFunc%(&Pad,Temp1,"CP0") : Pad) : "", NumPut(Asc(Char),NegativeCells,(Index - 1) << !!A_IsUnicode,CharType)) : (Temp1 := (Index - StrLen(PositiveCells)) + 1, (Temp1 > 0) ? (VarSetCapacity(Pad,64), VarSetCapacity(Pad,0), VarSetCapacity(Pad,Temp1,Asc(DefaultCell)), PositiveCells .= A_IsUnicode ? %StrGetFunc%(&Pad,Temp1,"CP0") : Pad) : "", NumPut(Asc(Char),PositiveCells,Index << !!A_IsUnicode,CharType))
}