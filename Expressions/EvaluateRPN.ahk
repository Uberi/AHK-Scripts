#NoEnv

#Include Stack.ahk
#Include ParseExpression.ahk
#Include OperatorTable.ahk

/*
ternary and short circuiting idea:

-convert ternary/logical AND/logical OR parameters into blocks (anonymous functions using a "{ SomeCode() }" syntax)
-rpn evaluator stores the functions as values, passes the functions to operator
-operator pops functions off of stack, uses function evaluator mechanism to conditionally execute functions

-possibility 1: tokeniser should output escaped version of the anonymous function, so it is read as one token. decode it immediately before evaluating the function. escape function can be StringEscape()
-possibility 2: use AHK_L arrays, so no need to encode, just nest arrays. possible way is tokenising to an array of Token objects, with the format: Object.Type, Object.Value, where Object.Value would contain an array representing the tokenised expression if it was an anonymous function, otherwise it would contain the actual value. this is similar to an AST. each function would have to undergo the shunting yard algorithm, perhaps by recursing into it when parsing in ConvertToRPN().
-possibility 3: do as mentioned above, but use separate Array library to keep AHK Basic compatability
*/

;/*
SomeText = The original content of the variable.

SomeVar = Test
Test = World
;Expression = ToolTip(SomeText), Sleep(2000), ToolTip(SomeText := "Hello, " . `%SomeVar`% . "!"), Sleep(2000), ToolTip()
Expression = Round(2**(5+10)/38,-1),1+(2<<3)*4
;Expression = Bla ? 123 : "abc"

CompiledExpression := ConvertToRPN(Expression) ;1.813918 ms
Result := EvaluateRPN(CompiledExpression) ;0.496152 ms
MsgBox Original expression:`n`n%Expression%`n`nCompiled expression:`n`n%CompiledExpression%`n`nExpression result:`n`n%Result%`n`nNew value of "SomeText":`n`n%SomeText%
Return

ToolTip(Text = "",X = "",Y = "",WhichToolTip = 1)
{
 ToolTip, %Text%, %X%, %Y%, %WhichToolTip%
 Return, "The return value of ToolTip()."
}

Sleep(Delay)
{
 Sleep, %Delay%
 Return, "The return value of Sleep()."
}
;*/

EvaluateRPN(RPN)
{
 Chr1 := Chr(1)
 Loop, Parse, RPN, %Chr1% ;iterate over each token
 {
  TokenType := SubStr(A_LoopField,1,1), Token := SubStr(A_LoopField,2)
  If TokenType In l,v ;if the token is a value or variable
   Push(Stack,A_LoopField) ;push it onto the stack
  Else ;token is a function or operator
  {
   If TokenType = f ;token is a function
    Temp1 := InStr(Token," "), Arguments := SubStr(Token,1,Temp1 - 1), Token := SubStr(Token,Temp1 + 1) ;retrieve argument count
   Else ;token is an operator
    Arguments := ArgumentCount(Token) ;retrieve argument count
   Push(Stack,Apply(Token,Stack,Arguments))
  }
 }
 Loop, Parse, Stack, %Chr1%
 {
  If (SubStr(A_LoopField,1,1) = "v") ;token is a variable reference
   Temp1 := SubStr(A_LoopField,2), Result .= %Temp1% . Chr1
  Else ;token is a literal
   Result .= SubStr(A_LoopField,2) . Chr1
 }
 Return, SubStr(Result,1,-1)
}

Apply(Operator,ByRef Stack,Arguments)
{
 local Index, Temp1, Argument1, Argument2, Argument3, Argument4, Argument5, Argument6, Argument1IsVar, Argument2IsVar, Argument3IsVar, Argument4IsVar, Argument5IsVar, Argument6IsVar
 Loop, %Arguments%
  Index := Arguments - (A_Index - 1), Temp1 := Pop(Stack), Argument%Index% := SubStr(Temp1,2), (SubStr(Temp1,1,1) = "v") ? (Argument%Index%IsVar := 1)
 If Operator = ++
  Return, "l" . %Argument1% ++
 If Operator = --
  Return, "l" . %Argument1% --
 If Operator = \++ ;prefix increment
  Return, "l" . ++ %Argument1%
 If Operator = \-- ;prefix decrement
  Return, "l" . -- %Argument1%
 If Operator = `%
  Return, "v" . %Argument1%
 If Operator = !
  Return, "l" . !(Argument1IsVar ? %Argument1% : Argument1)
 If Operator = \! ;low-precendence logical NOT
  Return, "l" . (Argument1IsVar ? %Argument1% : Argument1)
 If Operator = ~
  Return, "l" . ~(Argument1IsVar ? %Argument1% : Argument1)
 If Operator = **
  Return, "l" . ((Argument1IsVar ? %Argument1% : Argument1) ** (Argument2IsVar ? %Argument2% : Argument2))
 If Operator = *
  Return, "l" . ((Argument1IsVar ? %Argument1% : Argument1) * (Argument2IsVar ? %Argument2% : Argument2))
 If Operator = \* ;dereference
  Return, "l" . *(Argument1IsVar ? %Argument1% : Argument1)
 If Operator = /
  Return, "l" . ((Argument1IsVar ? %Argument1% : Argument1) / (Argument2IsVar ? %Argument2% : Argument2))
 If Operator = //
  Return, "l" . ((Argument1IsVar ? %Argument1% : Argument1) // (Argument2IsVar ? %Argument2% : Argument2))
 If Operator = +
  Return, "l" . ((Argument1IsVar ? %Argument1% : Argument1) + (Argument2IsVar ? %Argument2% : Argument2))
 If Operator = -
  Return, "l" . ((Argument1IsVar ? %Argument1% : Argument1) - (Argument2IsVar ? %Argument2% : Argument2))
 If Operator = \- ;unary minus
  Return, "l" . -(Argument1IsVar ? %Argument1% : Argument1)
 If Operator = <<
  Return, "l" . ((Argument1IsVar ? %Argument1% : Argument1) << (Argument2IsVar ? %Argument2% : Argument2))
 If Operator = >>
  Return, "l" . ((Argument1IsVar ? %Argument1% : Argument1) >> (Argument2IsVar ? %Argument2% : Argument2))
 If Operator = &
  Return, "l" . ((Argument1IsVar ? %Argument1% : Argument1) & (Argument2IsVar ? %Argument2% : Argument2))
 If Operator = \& ;address
  Return, "l" . &(Argument1IsVar ? %Argument1% : Argument1)
 If Operator = ^
  Return, "l" . ((Argument1IsVar ? %Argument1% : Argument1) ^ (Argument2IsVar ? %Argument2% : Argument2))
 If Operator = |
  Return, "l" . ((Argument1IsVar ? %Argument1% : Argument1) | (Argument2IsVar ? %Argument2% : Argument2))
 If Operator = \. ;concatenation
  Return, "l" . ((Argument1IsVar ? %Argument1% : Argument1) . (Argument2IsVar ? %Argument2% : Argument2))
 If Operator = . ;object access
  Return, ;wip: needs to be universally compatible
 If Operator = <
  Return, "l" . ((Argument1IsVar ? %Argument1% : Argument1) < (Argument2IsVar ? %Argument2% : Argument2))
 If Operator = >
  Return, "l" . ((Argument1IsVar ? %Argument1% : Argument1) > (Argument2IsVar ? %Argument2% : Argument2))
 If Operator = =
  Return, "l" . ((Argument1IsVar ? %Argument1% : Argument1) = (Argument2IsVar ? %Argument2% : Argument2))
 If Operator = ==
  Return, "l" . ((Argument1IsVar ? %Argument1% : Argument1) == (Argument2IsVar ? %Argument2% : Argument2))
 If Operator = <>
  Return, "l" . ((Argument1IsVar ? %Argument1% : Argument1) <> (Argument2IsVar ? %Argument2% : Argument2))
 If Operator = &&
  Return, "l" . ((Argument1IsVar ? %Argument1% : Argument1) && (Argument2IsVar ? %Argument2% : Argument2))
 If Operator = ||
  Return, "l" . ((Argument1IsVar ? %Argument1% : Argument1) || (Argument2IsVar ? %Argument2% : Argument2))
 If Operator = :=
 {
  %Argument1% := (Argument2IsVar ? %Argument2% : Argument2)
  Return, "v" . Argument1
 }
 If Operator = +=
 {
  %Argument1% += (Argument2IsVar ? %Argument2% : Argument2)
  Return, "v" . Argument1
 }
 If Operator = -=
 {
  %Argument1% -= (Argument2IsVar ? %Argument2% : Argument2)
  Return, "v" . Argument1
 }
 If Operator = *=
 {
  %Argument1% *= (Argument2IsVar ? %Argument2% : Argument2)
  Return, "v" . Argument1
 }
 If Operator = /=
 {
  %Argument1% /= (Argument2IsVar ? %Argument2% : Argument2)
  Return, "v" . Argument1
 }
 If Operator = //=
 {
  %Argument1% //= (Argument2IsVar ? %Argument2% : Argument2)
  Return, "v" . Argument1
 }
 If Operator = .=
 {
  %Argument1% .= (Argument2IsVar ? %Argument2% : Argument2)
  Return, "v" . Argument1
 }
 If Operator = |=
 {
  %Argument1% |= (Argument2IsVar ? %Argument2% : Argument2)
  Return, "v" . Argument1
 }
 If Operator = &=
 {
  %Argument1% &= (Argument2IsVar ? %Argument2% : Argument2)
  Return, "v" . Argument1
 }
 If Operator = ^=
 {
  %Argument1% ^= (Argument2IsVar ? %Argument2% : Argument2)
  Return, "v" . Argument1
 }
 If Operator = >>=
 {
  %Argument1% >>= (Argument2IsVar ? %Argument2% : Argument2)
  Return, "v" . Argument1
 }
 If Operator = <<=
 {
  %Argument1% <<= (Argument2IsVar ? %Argument2% : Argument2)
  Return, "v" . Argument1
 }

 ;Operator is a function
 If Arguments = 0
  Return, "l" . %Operator%()
 If Arguments = 1
  Return, "l" . %Operator%(Argument1IsVar ? %Argument1% : Argument1)
 If Arguments = 2
  Return, "l" . %Operator%((Argument1IsVar ? %Argument1% : Argument1),(Argument2IsVar ? %Argument2% : Argument2))
 If Arguments = 3
  Return, "l" . %Operator%((Argument1IsVar ? %Argument1% : Argument1),(Argument2IsVar ? %Argument2% : Argument2),(Argument3IsVar ? %Argument3% : Argument3))
 If Arguments = 4
  Return, "l" . %Operator%((Argument1IsVar ? %Argument1% : Argument1),(Argument2IsVar ? %Argument2% : Argument2),(Argument3IsVar ? %Argument3% : Argument3),(Argument4IsVar ? %Argument4% : Argument4))
 If Arguments = 5
  Return, "l" . %Operator%((Argument1IsVar ? %Argument1% : Argument1),(Argument2IsVar ? %Argument2% : Argument2),(Argument3IsVar ? %Argument3% : Argument3),(Argument4IsVar ? %Argument4% : Argument4),(Argument5IsVar ? %Argument5% : Argument5))
 If Arguments = 6
  Return, "l" . %Operator%((Argument1IsVar ? %Argument1% : Argument1),(Argument2IsVar ? %Argument2% : Argument2),(Argument3IsVar ? %Argument3% : Argument3),(Argument4IsVar ? %Argument4% : Argument4),(Argument5IsVar ? %Argument5% : Argument5),(Argument6IsVar ? %Argument6% : Argument6))
 If Arguments = 7
  Return, "l" . %Operator%((Argument1IsVar ? %Argument1% : Argument1),(Argument2IsVar ? %Argument2% : Argument2),(Argument3IsVar ? %Argument3% : Argument3),(Argument4IsVar ? %Argument4% : Argument4),(Argument5IsVar ? %Argument5% : Argument5),(Argument6IsVar ? %Argument6% : Argument6),(Argument7IsVar ? %Argument7% : Argument7))
 If Arguments = 8
  Return, "l" . %Operator%((Argument1IsVar ? %Argument1% : Argument1),(Argument2IsVar ? %Argument2% : Argument2),(Argument3IsVar ? %Argument3% : Argument3),(Argument4IsVar ? %Argument4% : Argument4),(Argument5IsVar ? %Argument5% : Argument5),(Argument6IsVar ? %Argument6% : Argument6),(Argument7IsVar ? %Argument7% : Argument7),(Argument8IsVar ? %Argument8% : Argument8))
 If Arguments = 9
  Return, "l" . %Operator%((Argument1IsVar ? %Argument1% : Argument1),(Argument2IsVar ? %Argument2% : Argument2),(Argument3IsVar ? %Argument3% : Argument3),(Argument4IsVar ? %Argument4% : Argument4),(Argument5IsVar ? %Argument5% : Argument5),(Argument6IsVar ? %Argument6% : Argument6),(Argument7IsVar ? %Argument7% : Argument7),(Argument8IsVar ? %Argument8% : Argument8),(Argument9IsVar ? %Argument9% : Argument9))
 If Arguments = 10
  Return, "l" . %Operator%((Argument1IsVar ? %Argument1% : Argument1),(Argument2IsVar ? %Argument2% : Argument2),(Argument3IsVar ? %Argument3% : Argument3),(Argument4IsVar ? %Argument4% : Argument4),(Argument5IsVar ? %Argument5% : Argument5),(Argument6IsVar ? %Argument6% : Argument6),(Argument7IsVar ? %Argument7% : Argument7),(Argument8IsVar ? %Argument8% : Argument8),(Argument9IsVar ? %Argument9% : Argument9),(Argument10IsVar ? %Argument10% : Argument10))
}