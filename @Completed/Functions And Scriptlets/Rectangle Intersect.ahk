#NoEnv

;/*
Width1 := 200, Height1 := 100
Left2 := 350, Top2 := 200, Width2 := 100, Height2 := 200
Gui, Add, Text, x10 y10 w100 h20 vDirection
Gui, Add, Progress, vRectangle1 BackgroundRed
Gui, Add, Progress, x%Left2% y%Top2% w%Width2% h%Height2% BackgroundBlue
Gui, Add, Progress, vIntersection BackgroundGreen
SetTimer, MoveRectangle, 200
Gosub, MoveRectangle
Gui, Show, w800 h600
Return

GuiEscape:
GuiClose:
ExitApp

MoveRectangle:
MouseGetPos, Left1, Top1
Direction := RectangleIntersect(Left1,Left1 + Width1,Top1,Top1 + Height1,Left2,Left2 + Width2,Top2,Top2 + Height2,IntersectLeft,IntersectTop,IntersectRight,IntersectBottom)
GuiControl,, Direction, %Direction%
GuiControl, Move, Rectangle1, x%Left1% y%Top1% w%Width1% h%Height1%
GuiControl, Move, Intersection, % "x" . IntersectLeft . " y" . IntersectTop . " w" . (IntersectRight - IntersectLeft) . " h" . (IntersectBottom - IntersectTop)
Gui, +LastFound
WinSet, Redraw
Return
*/

RectangleIntersect(Left1,Right1,Top1,Bottom1,Left2,Right2,Top2,Bottom2,ByRef IntersectLeft = "",ByRef IntersectTop = "",ByRef IntersectRight = "",ByRef IntersectBottom = "")
{
 If (Right1 < Left2 || Right2 < Left1 || Bottom1 < Top2 || Bottom2 < Top1) ;not intersecting
 {
  IntersectLeft := 0, IntersectTop := 0, IntersectRight := 0, IntersectBottom := 0
  Return, 0
 }
 ;calculate the relative positions, and the intersection rectangle
 IntersectLeft := ((Left1 < Left2) ? Left2 : Left1), IntersectRight := ((Right1 < Right2) ? Right1 : Right2)
 IntersectTop := ((Top1 < Top2) ? Top2 : Top1), IntersectBottom := ((Bottom1 < Bottom2) ? Bottom1 : Bottom2)

 If ((IntersectRight - IntersectLeft) < (IntersectBottom - IntersectTop)) ;intersection is more on the left or right side than the top or bottom
  Direction := ((((Left1 + Right1) / 2) < ((Left2 + Right2) / 2)) ? "Left" : "Right") ;determine the side the intersection is occurring relative to the second rectangle by comparing the centers
 Else ;intersection is more on the top or bottom side than the left or right
  Direction := ((((Top1 + Bottom1) / 2) < ((Top2 + Bottom2) / 2)) ? "Top" : "Bottom") ;determine the side the intersection is occurring relative to the second rectangle by comparing the centers
 Return, Direction
}