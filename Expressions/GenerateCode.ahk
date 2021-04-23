#NoEnv

/*
;Expression = (3*2)+5,12-7

Tree = |0!.|0!|1!+|1!|2!*|2!3|2!2|2!|1!5|1!|0!|1!-|1!12|1!7|1!|0!
StringReplace, Tree, Tree, |, % Chr(1), All
StringReplace, Tree, Tree, !, % Chr(2), All

MsgBox % """" . ParseSyntaxTree(Tree) . """"
Return
*/

GenerateCode(Element,RecursionDepth,ElementType)
{
 If ElementType = Leaf
 {
  ;wip: do some value preprocessing here, like variable format and function names
 }
 Else ;If ElementType = Branch
 {
  ListDelimiter := Chr(1) . RecursionDepth . Chr(2)
  StringReplace, Element, Element, %ListDelimiter%, %A_Space%, All
  Element := "(" . SubStr(Element,2,-1) . ")"
 }
 Return, Element
}

ParseSyntaxTree(Tree,RecursionDepth = 0)
{
 Chr1 := Chr(1), ListDelimiter := SubStr(Tree,1,InStr(Tree,Chr(2),False,2)), Temp1 := StrLen(ListDelimiter), Output := ListDelimiter, FoundPos := 1
 While, (FoundPos := InStr(Tree,ListDelimiter,False,FoundPos))
 {
  FoundPos += Temp1, Temp2 := InStr(Tree,ListDelimiter,False,FoundPos)
  If Not Temp2
   Break
  Temp2 := SubStr(Tree,FoundPos,Temp2 - FoundPos), Output .= ((SubStr(Temp2,1,1) = Chr1) ? ParseSyntaxTree(Temp2,RecursionDepth + 1) : GenerateCode(Temp2,RecursionDepth,"Leaf")) . ListDelimiter
 }
 Return, GenerateCode(Output,RecursionDepth,"Branch")
}