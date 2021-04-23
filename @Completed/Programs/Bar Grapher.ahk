;AHK AHK_L
#NoEnv

/*
DataSet := Clipboard ;newline delimited list
StringReplace, DataSet, DataSet, `r,, All
DataArray := []
Loop, Parse, DataSet, `n
 DataArray[A_Index] := A_LoopField
Plot(DataArray)
Gui, Show, w1000 h410
Return
*/

;/*
SetBatchLines, -1
Range := 100, DataSet := []
Loop, %Range%
 DataSet[A_Index] := 0
Loop, 500000
{
 Random, Temp1, 0.0, 1.0
 Temp1 := Floor(Mod(Temp1,1.0) * (Range + 1))
 DataSet[Temp1] ++
}
Plot(DataSet)
Gui, Show, w1000 h410
Return
*/

Plot(DataSet,PosX = 0,PosY = 0)
{
 MaxMin(DataSet,Max,Min)
 MaxScale := RoundToNearest(Max,2,"Ceil")
 MinScale := RoundToNearest(Min,2,"Floor")

 Gui, Font, s14 Bold, Arial
 Gui, Add, Text, x%PosX% y%PosY% w1000 h30 Center, Integer Distribution

 FontSize := 9 - StrLen(Max)
 Gui, Font, s%FontSize% Norm

 AddBarGraph(1,45 + PosX,40 + PosY,950,300,MaxScale,MinScale)
 Index := 1, NumberRange := Max - Min
 For Index, Entry In DataSet
 {
  If Entry Is Not Number
   Continue
  SetFormat, IntegerFast, Hex
  Red := Round(((Entry - Min) / NumberRange) * 0xFF)
  Blue := 0xFF - Red
  BarColor := SubStr("0" . SubStr(Red,3),-1) . "00" . SubStr("0" . SubStr(Blue,3),-1)
  SetFormat, IntegerFast, D
  AddBar(1,Entry,Index,BarColor), Index ++
 }
 RefreshBarSizes(1)
 AddVerticalScales(1)

 Variation := Round((NumberRange * 100) / (Min + (NumberRange / 2)),2)
 Gui, Font, s10 Bold
 Gui, Add, Text, % "x" . PosX . " y" . 380 + PosY . " w1000 h20 Center", Minimum: %Min%    Maximum: %Max%    Range: %NumberRange%    Variation: %Variation%`%
}

GuiClose:
ExitApp

MaxMin(DataSet,ByRef Max = "",ByRef Min = "")
{
 Max := DataSet[1], Min := Max
 For Index, Entry In DataSet
 {
  If Entry Is Not Number
   Continue
  If (Entry > Max)
   Max := Entry
  If (Entry < Min)
   Min := Entry
 }
}

RoundToNearest(Num,RoundTo,Mode = "Floor") ;Floor, Round, Ceil
{
 Return, (Mode = "Round") ? (Round(Num / RoundTo) * RoundTo) : ((Mode = "Ceil") ? (Ceil(Num / RoundTo) * RoundTo) : (Floor(Num / RoundTo) * RoundTo))
}

AddBarGraph(GuiNum,PosX,PosY,Width,Height,MaxScale = 100,MinScale = 0,BackgroundColor = "White")
{
 global
 BarGraphX := PosX, BarGraphY := PosY, BarGraphW := Width, BarGraphH := Height, BarGraphBackgroundColor := BackgroundColor, BarGraphCount := 0, BarGraphMaxScale := MaxScale, BarGraphMinScale := MinScale
}

AddBar(GuiNum,BarLevel,BarLabel = "",BarColor = "Red")
{
 global
 BarGraphCount ++
 Gui, %GuiNum%:Add, Progress, Vertical hwndBarGraphBarHandle Background%BarGraphBackgroundColor% c%BarColor% vBarGraphBar%BarGraphCount% Range%BarGraphMinScale%-%BarGraphMaxScale%, %BarLevel%
 Control, ExStyle, -0x20000,, ahk_id %BarGraphBarHandle% ;remove WS_EX_STATICEDGE extended style
 Control, ExStyle, -0x800000,, ahk_id %BarGraphBarHandle% ;remove WS_BORDER extended style
 Gui, %GuiNum%:Add, Text, Center vBarGraphLabel%BarGraphCount%, |`n%BarLabel%
}

RefreshBarSizes(GuiNum)
{
 global BarGraphX
 global BarGraphY
 global BarGraphW
 global BarGraphH
 global BarGraphCount
 BarWidth := BarGraphW / BarGraphCount
 PosY := BarGraphY + BarGraphH, Index := 0
 Loop, %BarGraphCount%
 {
  PosX := BarGraphX + (BarWidth * Index)
  Temp3 := BarWidth + 2
  GuiControl, %GuiNum%:Move, BarGraphBar%A_Index%, x%PosX% y%BarGraphY% w%Temp3% h%BarGraphH%
  GuiControl, %GuiNum%:Move, BarGraphLabel%A_Index%, x%PosX% y%PosY% w%BarWidth% h30
  Index ++
 }
 Gui, %GuiNum%:+LastFound
 WinSet, Redraw
}

AddVerticalScales(GuiNum,Interval = 20,Precision = 1)
{
 global BarGraphX
 global BarGraphY
 global BarGraphH
 global BarGraphMaxScale
 global BarGraphMinScale
 Temp1 := BarGraphH / Interval
 Temp2 := (BarGraphMaxScale - BarGraphMinScale) / Interval
 Loop, % Interval + 1
  Gui, Add, Text, % "x" . BarGraphX - 50 . " y" . (BarGraphY + (Temp1 * (A_Index - 1))) - 10 . " w45 h" . Temp1 . " Right", % Round(((Interval - (A_Index - 1)) * Temp2) + BarGraphMinScale,Precision) . " -"
}