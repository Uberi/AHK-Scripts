#NoEnv

Critical

Gui, Font, s18 Bold, Arial
Gui, Add, Text, x2 y0 w470 h40, Enter a chemical equation to balance:
Gui, Font, Norm
Gui, Add, Edit, x2 y40 w470 h40 vEquation gStartBalance, Al + H2SO4 -> H2 + Al2S3O12
Gui, Font, s12
Gui, Add, Edit, x2 y90 w470 h25 vResult ReadOnly
Gui, +ToolWindow +AlwaysOnTop
Gui, Show, w475 h120, Equation Balancer

Balance:
GuiControlGet, Equation,, Equation
GuiControl,, Result, % SolveChemicalEquation(Equation)
Return

StartBalance:
SetTimer, Balance, -500
Return

GuiEscape:
GuiClose:
ExitApp

SolveChemicalEquation(Equation)
{
 StringReplace, Equation, Equation, %A_Space%,, All
 Temp1 := InStr(Equation,"->")
 If Not Temp1
  Return, "Invalid equation."
 LeftSide := SubStr(RegExReplace("+" . SubStr(Equation,1,Temp1 - 1),"S)\+\d?([^\+]+)","+1$1"),2), RightSide := SubStr(RegExReplace("+" . SubStr(Equation,Temp1 + 2),"S)\+\d?([^\+]*)","+1$1"),2)
 StringReplace, LeftSide, LeftSide, +, +, UseErrorLevel
 CenterPos := ErrorLevel + 1
 StringReplace, RightSide, RightSide, +, +, UseErrorLevel
 TermCount := CenterPos + ErrorLevel + 1, VarSetCapacity(Permutation,TermCount,Asc(1)), Permutation --, Sides := "Left,Right", Temp1 := ""
 Loop
 {
  Permutation ++
  IfInString, Permutation, 0
   Continue
  If (StrLen(Permutation) > TermCount)
  {
   VarSetCapacity(Permutation,64)
   Return, "Could not balance equation."
  }
  Loop, Parse, LeftSide, +
   Temp1 .= SubStr(Permutation,A_Index,1) . SubStr(A_LoopField,2) . "+"
  StringTrimRight, LeftSide, Temp1, 1
  Temp1 = 
  Loop, Parse, RightSide, +
   Temp1 .= SubStr(Permutation,A_Index + CenterPos,1) . SubStr(A_LoopField,2) . "+"
  StringTrimRight, RightSide, Temp1, 1

  Loop, Parse, Sides, CSV
  {
   TempList = `n
   Loop, Parse, %A_LoopField%Side, +
   {
    Position := 0, Amount := SubStr(A_LoopField,1,1)
    StringTrimLeft, CurrentTerm, A_LoopField, 1
    Loop
    {
     Position := RegExMatch(CurrentTerm,"S)([A-Z][a-z]*)(\d*)",Temp,Position + 1)
     If Not Position
      Break
     Temp3 := InStr(TempList,"`n" . Temp1 . "|"), Temp4 := Temp2 ? Amount * Temp2 : Amount
     If Temp3
     {
      Temp3 += StrLen(Temp1) + 2, Temp3 := SubStr(TempList,Temp3,InStr(TempList,"`n",False,Temp3 + 1) - Temp3)
      StringReplace, TempList, TempList, `n%Temp1%|%Temp3%`n, % "`n" . Temp1 . "|" . Temp3 + Temp4 . "`n"
     }
     Else
      TempList .= Temp1 . "|" . Temp4 . "`n"
    }
   }
   Sort, TempList
   %A_LoopField%Side1 = %TempList%
  }
  If LeftSide1 = %RightSide1%
  {
   Result = %LeftSide% -> %RightSide%
   StringReplace, Result, Result, +, %A_Space%+%A_Space%, All
   VarSetCapacity(Permutation,64)
   Return, RegExReplace(Result,"S)1([^\d][^ ]*)","$1")
  }
 }
}