#NoEnv

#Include ParseExpression.ahk
#Include GenerateCode.ahk
;#Include RunCompiledExpression.ahk

Compile(Code)
{
 Tree := ParseExpression(Code)
 Return, ParseSyntaxTree(Tree)
}