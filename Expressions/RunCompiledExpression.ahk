#NoEnv

;wip: can't handle several cases yet
;MsgBox % RunCompiledExpression("(- (+ 100 (. 5 0)) 30)") ;120

#Include MatchPair.ahk

RunCompiledExpression(Expression)
{
 Temp1 := InStr(Expression,"(")
 If Not Temp1
  MsgBox % Expression
 If Not Temp1
  Return, Apply(Expression)
 FoundPos := 0, Field := SubStr(Expression,1,Temp1 - 1)
 While, (FoundPos := InStr(Expression,"(",False,FoundPos + 1))
 {
  RightBracket := FoundPos, BracketCount := 0, Temp1 := SubStr(Expression,FoundPos,InStr(Expression,")",False,FoundPos) - FoundPos)
  StringReplace, Temp1, Temp1, (, (, UseErrorLevel
  While, ErrorLevel
  {
   BracketCount += ErrorLevel, LeftBracket := InStr(FoundPos,"(",False,RightBracket), RightBracket := InStr(FoundPos,")",False,LeftBracket)
   StringGetPos, Bracket, Expression, ), L%BracketCount%, FoundPos
   Bracket ++, Temp1 := SubStr(Expression,RightBracket,Bracket - RightBracket)
   StringReplace, Temp1, Temp1, (, (, UseErrorLevel
  }
  FoundPos ++, Field .= RunCompiledExpression(SubStr(Expression,FoundPos,Bracket - FoundPos)) . " ", FoundPos := Bracket + 1
 }
 Field := SubStr(Field,1,-1), Field .= SubStr(Expression,Bracket + 1)
 Return, Apply(Field)
}

Apply(Field)
{ ;wip: commas and ternary operator (x ? y : z) not working
 local Field0, Field1, Field2, Field3, Field4, Field5, Field6, Field7, Item2, Item3, Result
 StringSplit, Field, Field, %A_Space%
 If Field1 Is Number
  Return, Field1 . Field2
 If (SubStr(Field1,1,1) = "(")
  Return, Field1 . Field2
 If Field2 Is Not Number
  % (SubStr(Field2,1,1) = """") ? (Field2 := SubStr(Field2,2,-1)) : (Item2 := Field2, Field2 := %Field2%)
 If Field3 Is Not Number
  % (SubStr(Field3,1,1) = """") ? (Field3 := SubStr(Field3,2,-1)) : (Item3 := Field3, Field3 := %Field3%)
 If Field1 = ++
  Result := Field2 ++, Changed := 1
 Else If Field1 = --
  Result := Field2 --, Changed := 1
 Else If Field1 = !
  Result := !Field2
 Else If Field1 = ~
  Result := ~Field2
 Else If Field1 = &
  Result := &Field2
 Else If Field1 = **
  Result := Field2 ** Field3
 Else If Field1 = *
  Result := (Field0 = 1) ? (*Field2) : (Field2 * Field3) ;dereference or multiply
 Else If Field1 = /
  Result := Field2 / Field3
 Else If Field1 = //
  Result := Field2 // Field3
 Else If Field1 = +
  Result := Field2 + Field3
 Else If Field1 = -
  Result := Field2 - Field3
 Else If Field1 = <<
  Result := Field2 << Field3
 Else If Field1 = >>
  Result := Field2 >> Field3
 Else If Field1 = &
  Result := Field2 & Field3
 Else If Field1 = ^
  Result := Field2 ^ Field3
 Else If Field1 = |
  Result := Field2 | Field3
 Else If Field1 = .
  Result := Field2 . Field3
 Else If Field1 = <
  Result := Field2 < Field3
 Else If Field1 = >
  Result := Field2 > Field3
 Else If Field1 = =
  Result := Field2 = Field3
 Else If Field1 = ==
  Result := Field2 == Field3
 Else If Field1 = <>
  Result := Field2 <> Field3
 Else If Field1 = &&
  Result := Field2 && Field3
 Else If Field1 = ||
  Result := Field2 || Field3
 Else If Field1 = :=
  Result := Field2 := Field3, Changed := 1
 Else If Field1 = +=
  Result := Field2 += Field3, Changed := 1
 Else If Field1 = -=
  Result := Field2 -= Field3, Changed := 1
 Else If Field1 = *=
  Result := Field2 *= Field3, Changed := 1
 Else If Field1 = /=
  Result := Field2 /= Field3, Changed := 1
 Else If Field1 = //=
  Result := Field2 //= Field3, Changed := 1
 Else If Field1 = .=
  Result := Field2 .= Field3, Changed := 1
 Else If Field1 = |=
  Result := Field2 |= Field3, Changed := 1
 Else If Field1 = &=
  Result := Field2 &= Field3, Changed := 1
 Else If Field1 = ^=
  Result := Field2 ^= Field3, Changed := 1
 Else If Field1 = >>=
  Result := Field2 >>= Field3, Changed := 1
 Else If Field1 = <<=
  Result := Field2 <<= Field3, Changed := 1
 Else If Field0 = 1
 {
  If Field1 Is Number
   Return, Field1
  If (SubStr(Field1,1,1) = """")
   Return, Field1
  Result := %Field1%()
 }
 Else If Field0 = 2
  Result := %Field1%(Field2)
 Else If Field0 = 3
  Result := %Field1%(Field2,Field3)
 Else If Field0 = 4
  Result := %Field1%(Field2,Field3,Field4)
 Else If Field0 = 5
  Result := %Field1%(Field2,Field3,Field4,Field5)
 Else If Field0 = 6
  Result := %Field1%(Field2,Field3,Field4,Field5,Field6)
 Else If Field0 = 7
  Result := %Field1%(Field2,Field3,Field4,Field5,Field6,Field7)
 If (Item2 && Changed)
  %Item2% := Field2
 If Result Is Not Number
  Result = "%Result%"
 Return, Result
}

/*
RecursiveParse(Expression,CallBack)
{
 Temp1 := InStr(Expression,"(")
 If Not Temp1
  Return, %CallBack%(Expression)
 FoundPos := 0, Field := SubStr(Expression,1,Temp1 - 1)
 While, (FoundPos := InStr(Expression,"(",False,FoundPos + 1))
  Temp1 := MatchPair(Expression,FoundPos), FoundPos ++, Field .= RecursiveParse(SubStr(Expression,FoundPos,Temp1 - FoundPos),CallBack) . " ", FoundPos := Temp1 + 1
 Field := SubStr(Field,1,-1), Field .= SubStr(Expression,Temp1 + 1)
 Return, %CallBack%(Field)
}
*/