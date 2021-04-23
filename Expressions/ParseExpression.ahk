#NoEnv

;#Include Tree.ahk
#Include Stack.ahk
#Include OperatorTable.ahk
#Include Tokenise.ahk

/*
Tree structure:

1.1   Function name
1.2   Param1
1.3.1 Function Name
1.3.2 Param1
1.4   Param3
...
*/

;MsgBox % """" . (ClipBoard := ConvertToRPN("2*2+20/4")) . """"
;MsgBox % """" . (ClipBoard := ConvertToRPN("""abctest"" = %Bla1% . Bla !!TestFunc(1**3 - #(23 2),""Hello"",Bla)")) . """"
;MsgBox % Clipboard := ConvertToRPN("SubStr(Peek(Stack-5+Abc()),0x20)=""f""")
;MsgBox % Clipboard := ConvertToRPN("3 + TestFunc(a,b) * 2, Bla + 2")
;ExitApp

ParseExpression(Expression)
{
 
 Return, Tree
}

;wip: see if this can directly generate an abstract syntax tree
ConvertToRPN(Expression)
{
 Expression := Tokenise(Expression)
 Loop, Parse, Expression, % Chr(1) ;iterate over each token
 {
  TokenType := SubStr(A_LoopField,1,1), Token := SubStr(A_LoopField,2)
  If TokenType = f ;a function token
   Push(Stack,A_LoopField) ;place function token onto the stack
  Else If A_LoopField = , ;function argument separator, or multi-statement separator
  {
   While, ((Stack <> "") && (Peek(Stack) <> "(")) ;loop until matching left parenthesis is found or stack is empty
    Push(Output,Pop(Stack)) ;move top stack item to output
  }
  Else If A_LoopField = (
   Push(Stack,"(") ;push the left parenthesis to the stack
  Else If A_LoopField = )
  {
   While, (Peek(Stack) <> "(") ;loop until matching left parenthesis is found
   {
    If Stack = ;exhausted stack without matching parenthesis
     Return
    Push(Output,Pop(Stack)) ;move top stack item to output
   }
   Pop(Stack) ;remove left parenthesis from stack
   If (SubStr(Peek(Stack),1,1) = "f") ;token at the top of the stack is a function
    Push(Output,Pop(Stack)) ;move function token to output
  }
  Else If TokenType = o ;operator token
  {
   While, (SubStr(StackOperator := Peek(Stack),1,1) = "o") ;loop while the token at the top of the stack is an operator token
   {
    TokenAssociativity := Associativity(Token), TokenPrecedence := Precedence(Token), StackOperatorPrecedence := Precedence(SubStr(StackOperator,2))
    If ((TokenAssociativity = "L") && (TokenPrecedence > StackOperatorPrecedence)) ;current operator is left associative and has a precedence less than or equal to the operator on the top of the stack
     Break
    If ((TokenAssociativity = "R") && TokenPrecedence >= StackOperatorPrecedence) ;current operator is right associative and has a precedence less than the operator on the top of the stack
     Break
    Push(Output,Pop(Stack)) ;move top stack item to output
   }
   Push(Stack,A_LoopField) ;place operator token onto the stack
  }
  Else ;variable or literal token
   Push(Output,A_LoopField) ;move directly to output
 }
 While, (Stack <> "") ;move remaining stack items to output
 {
  Temp1 := Pop(Stack)
  If Temp1 In (,) ;unmatched parenthesis
   Return
  Push(Output,Temp1)
 }
 Return, Output
}