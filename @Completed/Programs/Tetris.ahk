#NoEnv

RowCount := 16, ColumnCount := 20
CellActive := "@"
CellEmpty := "."
CellFull := "#"
StartRow := 0, StartColumn := 7

Score := 0

SetBatchLines, -1

CellGridInit(CellGrid,RowCount,ColumnCount)
CurrentShape := RandomShape(StartRow,StartColumn,RowCount,ColumnCount)
Result := Display(CurrentShape,CellGrid,RowCount,ColumnCount,CellActive,CellFull,CellEmpty)

Gui, Font, s12, Courier New
Gui, Add, Text, x0 y20 vCellGrid -Wrap, %Result%
GuiControlGet, Position, Pos, CellGrid

Gui, Font, s8 Bold, Arial
Gui, Add, Text, x0 y0 w40 h20, Score:
Gui, Add, Text, x40 y0 w60 h20 vScore Right, 0
Gui, Add, Button, % "x" . (PositionW - 60) . " y0 w60 h20 vTogglePause gTogglePause Default", Pause
Gui, +ToolWindow + AlwaysOnTop
PositionW += PositionX, PositionH += Round(PositionY - CellHeight)
Gui, Show, w%PositionW% h%PositionH%, Tetris

Gosub, MainLoop
Return

GuiEscape:
GuiClose:
ExitApp

TogglePause:
GuiControl,, TogglePause, % A_IsPaused ? "Pause" : "Unpause"
Pause, Toggle, 1
Return

#IfWinActive ahk_class AutoHotkeyGUI

Up::
RotateClockwise(CurrentShape)
GuiControl,, CellGrid, % Display(CurrentShape,CellGrid,RowCount,ColumnCount,CellActive,CellFull,CellEmpty)
Return

Left::
MoveLeft(CurrentShape,CellGrid,RowCount,ColumnCount)
GuiControl,, CellGrid, % Display(CurrentShape,CellGrid,RowCount,ColumnCount,CellActive,CellFull,CellEmpty)
Return

Right::
MoveRight(CurrentShape,CellGrid,RowCount,ColumnCount)
GuiControl,, CellGrid, % Display(CurrentShape,CellGrid,RowCount,ColumnCount,CellActive,CellFull,CellEmpty)
Return

Space::
While, !MoveDown(CurrentShape,CellGrid,RowCount,ColumnCount)
{
 
}
Gosub, SwitchShape
GuiControl,, CellGrid, % Display(CurrentShape,CellGrid,RowCount,ColumnCount,CellActive,CellFull,CellEmpty)
Return

MainLoop:
Loop
{
 Sleep, 400
 Critical
 If MoveDown(CurrentShape,CellGrid,RowCount,ColumnCount)
  Gosub, SwitchShape
 GuiControl,, CellGrid, % Display(CurrentShape,CellGrid,RowCount,ColumnCount,CellActive,CellFull,CellEmpty)
 Critical, Off
}
Return

SwitchShape:
FinalizeShape(CurrentShape,CellGrid,RowCount,ColumnCount)
RemovedRows := ProcessFullRows(CellGrid,RowCount,ColumnCount)
If (RemovedRows != 0)
{
 Score += 10 * (RemovedRows ** 2)
 GuiControl,, Score, %Score%
}
CurrentShape := RandomShape(StartRow,StartColumn,RowCount,ColumnCount)
Return

CellGridInit(ByRef CellGrid,RowCount,ColumnCount)
{
 VarSetCapacity(CellGrid,RowCount * ColumnCount,0)
}

MoveDown(CurrentShape,ByRef CellGrid,RowCount,ColumnCount)
{
 TotalCount := RowCount * ColumnCount
 Shape := CurrentShape.Shape, Position := CurrentShape.Position + ColumnCount, ShapeColumn := Mod(Position,ColumnCount)
 Collided := 0
 Loop, Parse, Shape
 {
  Position ++
  If (A_LoopField = "1")
  {
   If (Position > TotalCount || NumGet(CellGrid,Position - 1,"UChar") = 1)
    Return, 1
  }
  Else If (A_LoopField = "`n")
   Position += Mod((ColumnCount + ShapeColumn) - Mod(Position,ColumnCount),ColumnCount)
 }
 CurrentShape.Position += ColumnCount ;move the shape down by one row
 Return, 0
}

MoveLeft(CurrentShape,ByRef CellGrid,RowCount,ColumnCount)
{
 Shape := CurrentShape.Shape, Position := CurrentShape.Position, ShapeColumn := Mod(Position,ColumnCount)
 Collided := 0
 Loop, Parse, Shape
 {
  CurrentColumn := Mod(Position,ColumnCount), Position ++
  If (A_LoopField = "1")
  {
   If (CurrentColumn = 0 || NumGet(CellGrid,Position - 2,"UChar") = 1)
    Return, 1
  }
  Else If (A_LoopField = "`n")
   Position += Mod((ColumnCount + ShapeColumn) - Mod(Position,ColumnCount),ColumnCount)
 }
 CurrentShape.Position -- ;move the shape left by one column
 Return, 0
}

MoveRight(CurrentShape,ByRef CellGrid,RowCount,ColumnCount)
{
 Shape := CurrentShape.Shape, Position := CurrentShape.Position, ShapeColumn := Mod(Position,ColumnCount)
 Collided := 0
 Loop, Parse, Shape
 {
  Position ++, CurrentColumn := Mod(Position,ColumnCount)
  If (A_LoopField = "1")
  {
   If (CurrentColumn = 0 || NumGet(CellGrid,Position,"UChar") = 1)
    Return, 1
  }
  Else If (A_LoopField = "`n")
   Position += Mod((ColumnCount + ShapeColumn) - Mod(Position,ColumnCount),ColumnCount)
 }
 CurrentShape.Position ++ ;move the shape right by one column
 Return, 0
}

RotateClockwise(ByRef CurrentShape)
{
 Shape := CurrentShape.Shape
 Rows := 0, Columns := 0
 Loop, Parse, Shape, `n
  Rows ++, Temp1 := StrLen(A_LoopField), (Temp1 > Columns) ? (Columns := Temp1)

 Grid := []
 Loop, Parse, Shape, `n
 {
  Grid[A_Index] := [], CurrentRow := Grid[A_Index], Index := 1
  Loop, Parse, A_LoopField
   CurrentRow[Index] := A_LoopField, Index ++
  Loop, % Columns - StrLen(A_LoopField)
   CurrentRow[Index] := 0
 }

 Result := []
 Loop, %Columns%
  Result[A_Index] := []
 For RowIndex, Row In Grid
 {
  For ColumnIndex, Entry In Row
   Result[ColumnIndex][1 - RowIndex] := Entry
 }

 Shape := ""
 For RowIndex, Row In Result
 {
  For ColumnIndex, Entry In Row
   Shape .= Entry
  Shape .= "`n"
 }

 CurrentShape.Shape := SubStr(Shape,1,-1)
}

ProcessFullRows(ByRef CellGrid,RowCount,ColumnCount)
{
 Position := 0, FullCount := 0
 Loop, %RowCount%
 {
  Total := 0
  Loop, %ColumnCount%
   Total += NumGet(CellGrid,Position,"UChar"), Position ++
  If (Total = ColumnCount)
  {
   FullCount ++
   Position1 := (((Position // ColumnCount) - 1) * ColumnCount) - 1
   Loop, %Position1%
    NumPut(NumGet(CellGrid,Position1,"UChar"),CellGrid,Position1 + ColumnCount,"UChar"), Position1 --
  }
 }
 Return, FullCount
}

FinalizeShape(CurrentShape,ByRef CellGrid,RowCount,ColumnCount)
{
 Shape := CurrentShape.Shape, Position := CurrentShape.Position, ShapeColumn := Mod(Position,ColumnCount)
 Collided := 0
 Loop, Parse, Shape
 {
  Position ++
  If (A_LoopField = "1")
   NumPut(1,CellGrid,Position - 1,"UChar")
  Else If (A_LoopField = "`n")
   Position += Mod((ColumnCount + ShapeColumn) - Mod(Position,ColumnCount),ColumnCount)
 }
}

RandomShape(Row,Column,RowCount,ColumnCount)
{
 static Shapes := ["01`n111","1111","11`n1`n1","11`n01`n01","11`n11"], MaxIndex := ObjMaxIndex(Shapes)
 Random, Index, 1, MaxIndex
 Result := Object()
 Result.Shape := Shapes[Index]
 Result.Position := (Row * ColumnCount) + Column
 Return, Result
}

Display(CurrentShape,ByRef CellGrid,RowCount,ColumnCount,CellActive,CellFull,CellEmpty)
{
 ;retrieve the result
 TotalCount := RowCount * ColumnCount, VarSetCapacity(Result,TotalCount), Position := 0
 Loop, %TotalCount%
  Result .= NumGet(CellGrid,Position,"UChar"), Position ++

 ;insert the shape into the result
 Position := CurrentShape.Position, Shape := CurrentShape.Shape, ShapeColumn := Mod(CurrentShape.Position,ColumnCount)
 TempResult := SubStr(Result,1,Position)
 Loop, Parse, Shape
 {
  Position ++
  If (A_LoopField = "0")
   TempResult .= SubStr(Result,Position,1)
  Else If (A_LoopField = "1")
   TempResult .= "2"
  Else ;If (A_LoopField = "`n")
  {
   Temp1 := Mod((ColumnCount + ShapeColumn) - Mod(Position,ColumnCount),ColumnCount)
   TempResult .= SubStr(Result,Position,Temp1 + 1), Position += Temp1
  }
 }
 TempResult .= SubStr(Result,Position + 1)

 ;partition the result into columns
 VarSetCapacity(Result,TotalCount + RowCount), Position := 1
 Loop, %RowCount%
  Result .= SubStr(TempResult,Position,ColumnCount) . "`n", Position += ColumnCount

 StringReplace, Result, Result, 2, %CellActive%, All
 StringReplace, Result, Result, 1, %CellFull%, All
 StringReplace, Result, Result, 0, %CellEmpty%, All
 Return, Result
}