GUICode = 
(
Gui, Add, Button, x742 y500 w30 h40 , Button
Gui, Add, Edit, x312 y560 w480 h30 , Edit
Gui, Add, Edit, x42 y420 w350 h40 , Edit
Gui, Add, Edit, x172 y160 w40 h260 , Edit
Gui, Add, Edit, x72 y160 w100 h30 , Edit
Gui, Add, Edit, x162 y60 w280 h20 , Edit
Gui, Add, Edit, x442 y110 w100 h20 , Edit
Gui, Add, Edit, x562 y60 w100 h30 , Edit
Gui, Add, Edit, x702 y220 w100 h30 , Edit
Gui, Add, Edit, x512 y230 w100 h30 , Edit
Gui, Add, Progress, x532 y170 w60 h60 , 25
Gui, Add, ListBox, x272 y310 w40 h30 , ListBox
Gui, Add, ListBox, x472 y70 w40 h30 , ListBox
; Generated using SmartGUI Creator 4.0
Gui, Show, w827 h614, Untitled GUI
Return

GuiClose:
ExitApp
)

MsgBox % Clipboard := LoadGUI(GUICode)

LoadGUI(GUICode)
{
 global Rectangles, ItemBlocks, CurrentRectX, CurrentRectY, CurrentRectW, CurrentRectH, GoalRectX, GoalRectY, GoalRectW, GoalRectH, Width, Height
 Loop, Parse, GUICode, `n, `r%A_Space%%A_Tab%
 {
  If Not RegExMatch(A_LoopField,"iS)Gui,? *Add, *(Edit|ListBox), *x(\d+) *y(\d+) *w(\d+) *h(\d+)",Match)
   Continue
  If Match1 = Edit
   Rectangles .= Match2 . ","Match3 . ","Match4 . ","Match5 . "`n"
  Else
   ItemBlocks .= Match2 . ","Match3 . ","Match4 . ","Match5 . "`n"
 }
 Rectangles := SubStr(Rectangles,1,-1), ItemBlocks := SubStr(ItemBlocks,1,-1)
 If RegExMatch(GUICode,"iS)Gui,? *Add, *Button, *x(\d+) *y(\d+) *w(\d+) *h(\d+)",Match)
  CurrentRectX := Match1, CurrentRectY := Match2, CurrentRectW := Match3, CurrentRectH := Match4
 If RegExMatch(GUICode,"iS)Gui,? *Add, *Progress, *x(\d+) *y(\d+) *w(\d+) *h(\d+)",Match)
  GoalRectX := Match1, GoalRectY := Match2, GoalRectW := Match3, GoalRectH := Match4
 If RegExMatch(GUICode,"iS)Gui,? *Show, *(?:x\d+ *y\d+ *)?w(\d+) *h(\d+)",Match)
  Width := Match1, Height := Match2
 Return, "Width = " . Width . "`n" . "Height = " . Height . "`n`nCurrentRect = " . CurrentRectX . "," . CurrentRectY . "," . CurrentRectW . "," . CurrentRectH . "`nGoalRect = " . GoalRectX . "," . GoalRectY . "," . GoalRectW . "," . GoalRectH . "`n`nRectangles = `n(`n" . Rectangles . "`n)`n`nItemBlocks = `n(`n" . ItemBlocks . "`n)"
}