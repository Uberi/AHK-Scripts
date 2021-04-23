#NoEnv

/*
Conway's Game Of Life is a grid in which each cell can assume one of two possible values: true or false. Iteratively, the grid is changed, based on a few simple rules applied to each grid cell:

* The value of each cell is determined by the values of the eight adjacent grid cells.
* If three adjacent cells are true, then the value of the cell will be true in the next iteration.
* If two adjacent cells are true, then the value of the cell will not be changed in the next iteration.
* Otherwise, the value of the cell will be set to false in the next iteration.

At the edges of the grid, cells may either act as though missing neighbors are cells set to false, or the grid may wrap around, with the left edge connected to the right edge, and the top edge connected to the bottom edge.
*/

RowCount := 64, ColumnCount := 128
;RowCount := 128, ColumnCount := 512
CellSize := 2
CellFull := "#", CellEmpty := " "
StartGrid = 
(
00000000000000000
00000000000000000
00101001010010100
00011000110001100
00010000100001000
00000000000000000
00000000000000000
00000000000000000
00101001010010100
00011000110001100
00010000100001000
00000000000000000
00000000000000000
00000000000000000
00101001010010100
00011000110001100
00010000100001000
00000000000000000
)

SetBatchLines, -1

CellGridInit(CellGrid1,RowCount,ColumnCount)
CellGridInit(CellGrid2,RowCount,ColumnCount)
Populate(CellGrid1,StartGrid,RowCount,ColumnCount)
Result := Display(CellGrid1,RowCount,ColumnCount,CellFull,CellEmpty)
CurrentGrid := 2

Gui, Font, s%CellSize% q3, Courier New
Gui, Add, Text, x0 y30 vCellGrid -Wrap, %Result%
GuiControlGet, Position, Pos, CellGrid

Gui, Font, s8 q0 Bold, Arial
Gui, Add, Text, x0 y0 w60 h20, Iterations:
Gui, Font, Norm
Gui, Add, Text, x60 y0 w60 h20 vIterations Right, 0
Gui, Add, Button, % "x" . (PositionW - 60) . " y0 w60 h20 vTogglePause gTogglePause Default", Pause

CellWidth := PositionW / ColumnCount, CellHeight := PositionH / (RowCount + 1)
Gui, +LastFound
VarSetCapacity(ClientPoint,8,0), DllCall("ClientToScreen","UInt",WinExist(),A_PtrSize ? "UPtr" : "UInt",&ClientPoint)
ControlPosX := PositionX + NumGet(ClientPoint), ControlPosY := PositionY + (NumGet(ClientPoint,4) - 4)

Gui, +ToolWindow + AlwaysOnTop
PositionW += PositionX, PositionH += Round(PositionY - CellHeight)
Gui, Show, w%PositionW% h%PositionH%, Game of Life

Hotkey, Enter, FastForward

Gosub, MainLoop
Return

GuiEscape:
GuiClose:
ExitApp

TogglePause:
GuiControl,, TogglePause, % A_IsPaused ? "Pause" : "Unpause"
Pause, Toggle, 1
Return

FastForward:
Thread, Interrupt, -1
While, GetKeyState("Enter","P")
{
 TimerBefore := StartTimer()
 If (CurrentGrid = 1)
  Step(CellGrid1,CellGrid2,RowCount,ColumnCount), CurrentGrid := 0
 Else
  Step(CellGrid2,CellGrid1,RowCount,ColumnCount), CurrentGrid := 1
 Iterations ++
 StepTime := StopTimer(TimerBefore)
 GuiControl,, Iterations, %Iterations%
 ToolTip, Step time: %StepTime%
}
Return

MainLoop:
Iterations := 0
Loop
{
 Critical
 TimerBefore := StartTimer()

 If (CurrentGrid = 1)
  Step(CellGrid1,CellGrid2,RowCount,ColumnCount), CurrentGrid := 0
 Else
  Step(CellGrid2,CellGrid1,RowCount,ColumnCount), CurrentGrid := 1

 StepTime := StopTimer(TimerBefore)
 TimerBefore := StartTimer()

 Result := (CurrentGrid = 1) ? Display(CellGrid1,RowCount,ColumnCount,CellFull,CellEmpty) : Display(CellGrid2,RowCount,ColumnCount,CellFull,CellEmpty)

 DisplayTime := StopTimer(TimerBefore)
 TimerBefore := StartTimer()

 GuiControl,, CellGrid, %Result%

 DrawTime := StopTimer(TimerBefore)
 TotalTime := StepTime + DisplayTime + DrawTime

 MouseGetCell(CellX,CellY,RowCount,ColumnCount)

 Iterations ++
 GuiControl,, Iterations, %Iterations%
 ToolTip, Step time: %StepTime%`nDisplay time: %DisplayTime%`nDraw time: %DrawTime%`nTotal time: %TotalTime%`n`nCell X: %CellX%`nCell Y: %CellY%
 Critical, Off
 Sleep, 100
}
Return

CellGridInit(ByRef CellGrid,RowCount,ColumnCount)
{
 VarSetCapacity(CellGrid,RowCount * ColumnCount,0)
}

/*
Populate(ByRef CellGrid,ByRef StartGrid,RowCount,ColumnCount)
{
 Position := -1
 Loop, Parse, StartGrid, `n
 {
  Loop, Parse, A_LoopField
   NumPut(A_LoopField,CellGrid,Position + A_Index,"UChar")
  Position += ColumnCount
 }
}
*/

;/*
Populate(ByRef CellGrid,ByRef StartGrid,RowCount,ColumnCount)
{
 Loop, % RowCount * ColumnCount
 {
  Random, Temp1, 0, 1
  NumPut(Temp1,CellGrid,A_Index - 1,"UChar")
 }
}
*/

/*
Step(ByRef CellGrid,ByRef OriginalCellGrid,RowCount,ColumnCount)
{
 Row := 0, TotalCount := RowCount * ColumnCount
 Loop, %RowCount%
 {
  Column := 0, TopRow := Row - ColumnCount, (TopRow < 0) ? (TopRow += TotalCount)
  BottomRow := Row + ColumnCount, (BottomRow = TotalCount) ? (BottomRow -= TotalCount)
  Loop, %ColumnCount%
  {
   LeftColumn := Column - 1, (LeftColumn < 0) ? (LeftColumn += ColumnCount)
   RightColumn := Column + 1, (RightColumn = ColumnCount) ? (RightColumn -= ColumnCount)
   AdjacentCount := NumGet(OriginalCellGrid,TopRow + LeftColumn,"UChar")
                  + NumGet(OriginalCellGrid,TopRow + Column,"UChar")
                  + NumGet(OriginalCellGrid,TopRow + RightColumn,"UChar")
                  + NumGet(OriginalCellGrid,Row + LeftColumn,"UChar")
                  + NumGet(OriginalCellGrid,Row + RightColumn,"UChar")
                  + NumGet(OriginalCellGrid,BottomRow + LeftColumn,"UChar")
                  + NumGet(OriginalCellGrid,BottomRow + Column,"UChar")
                  + NumGet(OriginalCellGrid,BottomRow + RightColumn,"UChar")

   Position := Row + Column
   If (AdjacentCount = 3)
    NumPut(1,CellGrid,Position,"UChar")
   Else If (AdjacentCount = 2)
    NumPut(NumGet(OriginalCellGrid,Position,"UChar"),CellGrid,Position,"UChar")
   Else
    NumPut(0,CellGrid,Position,"UChar")
   Column ++
  }
  Row += ColumnCount
 }
}
*/

;/*
Step(ByRef CellGrid,ByRef OriginalCellGrid,RowCount,ColumnCount)
{
 Row := 0, TotalCount := RowCount * ColumnCount
 Loop, %RowCount%
 {
  TopRow := Row - ColumnCount, (TopRow < 0) ? (TopRow += TotalCount)
  BottomRow := Row + ColumnCount, (BottomRow = TotalCount) ? (BottomRow -= TotalCount)

  LeftColumn := ColumnCount - 1
  AdjacentCount := NumGet(OriginalCellGrid,TopRow + LeftColumn,"UChar")
                 + NumGet(OriginalCellGrid,TopRow,"UChar")
                 + NumGet(OriginalCellGrid,TopRow + 1,"UChar")
                 + NumGet(OriginalCellGrid,Row + LeftColumn,"UChar")
                 + NumGet(OriginalCellGrid,Row + 1,"UChar")
                 + NumGet(OriginalCellGrid,BottomRow + LeftColumn,"UChar")
                 + NumGet(OriginalCellGrid,BottomRow,"UChar")
                 + NumGet(OriginalCellGrid,BottomRow + 1,"UChar")

  If (AdjacentCount = 3)
   NumPut(1,CellGrid,Row,"UChar")
  Else If (AdjacentCount = 2)
   NumPut(NumGet(OriginalCellGrid,Row,"UChar"),CellGrid,Row,"UChar")
  Else
   NumPut(0,CellGrid,Row,"UChar")
  Column := 1
  Loop, % ColumnCount - 2
  {
   LeftColumn := Column - 1
   RightColumn := Column + 1
   AdjacentCount := NumGet(OriginalCellGrid,TopRow + LeftColumn,"UChar")
                  + NumGet(OriginalCellGrid,TopRow + Column,"UChar")
                  + NumGet(OriginalCellGrid,TopRow + RightColumn,"UChar")
                  + NumGet(OriginalCellGrid,Row + LeftColumn,"UChar")
                  + NumGet(OriginalCellGrid,Row + RightColumn,"UChar")
                  + NumGet(OriginalCellGrid,BottomRow + LeftColumn,"UChar")
                  + NumGet(OriginalCellGrid,BottomRow + Column,"UChar")
                  + NumGet(OriginalCellGrid,BottomRow + RightColumn,"UChar")

   Position := Row + Column
   If (AdjacentCount = 3)
    NumPut(1,CellGrid,Position,"UChar")
   Else If (AdjacentCount = 2)
    NumPut(NumGet(OriginalCellGrid,Position,"UChar"),CellGrid,Position,"UChar")
   Else
    NumPut(0,CellGrid,Position,"UChar")
   Column ++
  }
  LeftColumn := Column - 1
  AdjacentCount := NumGet(OriginalCellGrid,TopRow + LeftColumn,"UChar")
                 + NumGet(OriginalCellGrid,TopRow + Column,"UChar")
                 + NumGet(OriginalCellGrid,TopRow,"UChar")
                 + NumGet(OriginalCellGrid,Row + LeftColumn,"UChar")
                 + NumGet(OriginalCellGrid,Row,"UChar")
                 + NumGet(OriginalCellGrid,BottomRow + LeftColumn,"UChar")
                 + NumGet(OriginalCellGrid,BottomRow + Column,"UChar")
                 + NumGet(OriginalCellGrid,BottomRow,"UChar")

  Position := Row + Column
  If (AdjacentCount = 3)
   NumPut(1,CellGrid,Position,"UChar")
  Else If (AdjacentCount = 2)
   NumPut(NumGet(OriginalCellGrid,Position,"UChar"),CellGrid,Position,"UChar")
  Else
   NumPut(0,CellGrid,Position,"UChar")

  Row += ColumnCount
 }
}
*/

Display(ByRef CellGrid,RowCount,ColumnCount,CellFull,CellEmpty)
{
 TotalCount := RowCount * ColumnCount, VarSetCapacity(TempResult,TotalCount), Position := 0
 Loop, %TotalCount%
  TempResult .= NumGet(CellGrid,Position,"UChar") ? CellFull : CellEmpty, Position ++
 VarSetCapacity(Result,TotalCount + RowCount), Position := 1
 Loop, %RowCount%
  Result .= SubStr(TempResult,Position,ColumnCount) . "`n", Position += ColumnCount
 Return, Result
}

MouseGetCell(ByRef CellX,ByRef CellY,RowCount,ColumnCount)
{
 global CellWidth, CellHeight, ControlPosX, ControlPosY
 static CellX1 := 0, CellY1 := 0
 Gui, +LastFound
 If !WinActive()
 {
  CellX := CellX1, CellY := CellY1
  Return
 }
 MouseGetPos, PosX, PosY
 CellX := Floor((PosX - ControlPosX) // CellWidth), CellY := Floor((PosY - ControlPosY) // CellHeight)
 If (CellX < 0 || CellX >= ColumnCount || CellY < 0 || CellY >= RowCount)
 {
  CellX := CellX1, CellY := CellY1
  Return
 }
 CellX1 := CellX, CellY1 := CellY
}

StartTimer()
{
 TimerBefore := 0, DllCall("QueryPerformanceCounter","Int64*",TimerBefore)
 Return, TimerBefore
}

StopTimer(ByRef TimerBefore)
{
 TimerAfter := 0, DllCall("QueryPerformanceCounter","Int64*",TimerAfter), TickFrequency := 0, DllCall("QueryPerformanceFrequency","Int64*",TickFrequency)
 Return, (TimerAfter - TimerBefore) / (TickFrequency / 1000)
}