#NoEnv

/*
;create an example tree
Tree := "|0!Bla|0!|1!Hello|1!World.|1!|2!|3!Test|3!abc|3!|4!123|4!456|4!|3!|2!|1!|0!SomeString|0!"
;Tree := "|0||1|+|1||2|*|2|3|2|2|2||1|5|1||0||1|-|1|12|1|7|1||0|"
StringReplace, Tree, Tree, |, % Chr(1), All
StringReplace, Tree, Tree, !, % Chr(2), All

MsgBox % TreeCount(Tree,"2.3.3.3,,1") ;count the number of elements in the node 2.3.3.3, the root node, and the node 1
MsgBox % TreeFind(Tree,"456","2.3") ;find the path of an element that contains "456", starting at node 2.3
MsgBox % TreeGet(Tree,"2.3.1.2") ;get the element located at 2.3.1.2

TempTree := TreeGet(Tree,"2.3.1") ;get the subtree of the main tree at 2.3.1
MsgBox % TreeGetDepth(TempTree) ;get the depth of the subtree
MsgBox % TreeGet(TempTree,"3.1") ;get an element of the subtree

Temp1 := TempTree ;save the subtree in another variable
TreeSetDepth(TempTree,0) ;set the depth of the subtree to 0
MsgBox "%Temp1%"`n`n"%TempTree%" ;display the "before" and "after" versions of the subtree

TreeSet(Tree,"2.3.1.3.2,8.3","BlaBlaBla") ;set the node 2.3.1.3.2, overwriting the existing contents, and set the node 8.3, which will be created automatically as it does not yet exist
TreeSet(Tree,"2.1",TempTree) ;reinsert the subtree into the main tree, overwriting the existing contents
TreeRemove(Tree,"4,4,4") ;remove the fourth node three times, which removes 3 nodes starting at position 4 in the tree

TempTree := TreeTraverse(Tree,"TreeTraverseCallBack") ;traverse the tree, with a callback to format and rebuild it
MsgBox %Result%`n`n"%TempTree%" ;display the formatted version, as well as the modified and rebuilt version
Return

TreeTraverseCallBack(Element,Path,ElementType)
{
 global Result
 ;MsgBox "%Element%"`n%Path%
 If (ElementType = "Leaf")
  Result .= Path . A_Tab . Element . "`n"
 Else
  Return, Element
 Return, "(" . Element . ")"
}
*/

TreeCount(ByRef Tree,Path = "",ElementDelimiter = "`n")
{
 Chr1 := Chr(1), Chr2 := Chr(2), RecursionDepth := SubStr(Tree,2,InStr(Tree,Chr2,False,2) - 2)
 If (Path = "") ;handle the counting of the root node, when it is the only thing being counted
 {
  StringReplace, Tree, Tree, %Chr1%%RecursionDepth%%Chr2%, %Chr1%%RecursionDepth%%Chr2%, UseErrorLevel
  Return, ErrorLevel - 1
 }
 Loop, Parse, Path, `, ;parse multiple paths to count, if present
 {
  TempTree := Tree, Index := RecursionDepth
  Loop, Parse, A_LoopField, . ;extract the node to count from the tree
  {
   ListDelimiter := Chr1 . Index . Chr2, Index ++
   StringGetPos, Temp1, TempTree, %ListDelimiter%, L%A_LoopField%
   Temp3 := StrLen(ListDelimiter), Temp2 := InStr(TempTree,ListDelimiter,False,Temp1 + Temp3 + 1)
   If Not Temp2
    Return
   Temp1 += Temp3, TempTree := SubStr(TempTree,Temp1 + 1,(Temp2 - 1) - Temp1)
  }
  StringReplace, TempTree, TempTree, %Chr1%%Index%%Chr2%, %Chr1%%Index%%Chr2%, UseErrorLevel
  Result .= (ErrorLevel - 1) . ElementDelimiter
 }
 Return, SubStr(Result,1,0 - StrLen(ElementDelimiter))
}

TreeFind(ByRef Tree,Item,StartPath = "",Occurence = 1)
{
 Chr1 := Chr(1), Chr2 := Chr(2), RecursionDepth := SubStr(Tree,2,InStr(Tree,Chr2,False,2) - 2) - 1, StartingOffset := 0, TempTree := Tree, Index := RecursionDepth
 Loop, Parse, StartPath, . ;find the starting position from the starting path
 {
  Index ++, ListDelimiter := Chr1 . Index . Chr2
  StringGetPos, Temp1, TempTree, %ListDelimiter%, L%A_LoopField%
  Temp3 := StrLen(ListDelimiter) + 1, Temp2 := InStr(TempTree,ListDelimiter,False,Temp1 + Temp3)
  If Not Temp2
   Return
  Temp1 += Temp3, TempTree := SubStr(TempTree,Temp1,Temp2 - Temp1), StartingOffset += Temp1 - 1
 }
 StringGetPos, Temp1, Tree, %Chr2%%Item%%Chr1%, L%Occurence%, StartingOffset
 If ErrorLevel
  Return, -1
 ;extract the path from the found position
 Temp1 := SubStr(Tree,1,Temp1 + 1)
 While, InStr(Temp1,ListDelimiter := Chr1 . (RecursionDepth + A_Index) . Chr2)
 {
  StringReplace, Temp1, Temp1, %ListDelimiter%, %ListDelimiter%, UseErrorLevel
  FoundPath .= "." . ErrorLevel
  Temp1 := SubStr(Temp1,InStr(Temp1,ListDelimiter,False,0) + StrLen(ListDelimiter))
 }
 Return, SubStr(FoundPath,2)
}

TreeGet(ByRef Tree,Path,ElementDelimiter = "`n")
{
 Chr1 := Chr(1), Chr2 := Chr(2), RecursionDepth := SubStr(Tree,2,InStr(Tree,Chr2,False,2) - 2)
 Loop, Parse, Path, `, ;parse multiple paths to count, if present
 {
  TempTree := Tree, Index := RecursionDepth
  Loop, Parse, A_LoopField, . ;extract the requested node from the tree
  {
   ListDelimiter := Chr1 . Index . Chr2, Index ++
   StringGetPos, Temp1, TempTree, %ListDelimiter%, L%A_LoopField%
   Temp3 := StrLen(ListDelimiter) + 1, Temp2 := InStr(TempTree,ListDelimiter,False,Temp1 + Temp3)
   If (ErrorLevel || !Temp2)
    Return
   Temp1 += Temp3, TempTree := SubStr(TempTree,Temp1,Temp2 - Temp1)
  }
  Result .= TempTree . ElementDelimiter
 }
 Return, SubStr(Result,1,0 - StrLen(ElementDelimiter))
}

TreeSet(ByRef Tree,Path,Data)
{
 Chr1 := Chr(1), Chr2 := Chr(2), RecursionDepth := SubStr(Tree,2,InStr(Tree,Chr2,False,2) - 2), IsTree := InStr(Data,Chr1)
 Loop, Parse, Path, `, ;parse multiple paths to count, if present
 {
  Index := RecursionDepth
  Loop, Parse, A_LoopField, . ;isolate the node to overwrite, and rebuild the tree with the data in the node's place
  {
   ListDelimiter := Chr1 . Index . Chr2, Index ++, Temp3 := StrLen(ListDelimiter)
   StringReplace, Tree, Tree, %ListDelimiter%, %ListDelimiter%, UseErrorLevel
   Loop, % (A_LoopField - ErrorLevel) + 1
    Tree .= ListDelimiter
   StringGetPos, Temp1, Tree, %ListDelimiter%, L%A_LoopField%
   Temp2 := InStr(Tree,ListDelimiter,False,Temp1 + Temp3 + 1)
   If (ErrorLevel || !Temp2)
    Return
   Temp1 += Temp3, LeftSide .= SubStr(Tree,1,Temp1), RightSide := SubStr(Tree,Temp2) . RightSide, Temp1 ++, Tree := SubStr(Tree,Temp1,Temp2 - Temp1)
  }
  Tree := LeftSide . (IsTree ? TreeSetDepth(Data,Index) : Data) . RightSide, LeftSide := "", RightSide := ""
 }
 Return, 1
}

TreeRemove(ByRef Tree,Path)
{
 Chr1 := Chr(1), Chr2 := Chr(2), RecursionDepth := SubStr(Tree,2,InStr(Tree,Chr2,False,2) - 2)
 Loop, Parse, Path, `, ;parse multiple paths to count, if present
 {
  Index := RecursionDepth
  Loop, Parse, A_LoopField, . ;isolate the node to remove, then rebuild the tree without it
  {
   ListDelimiter := Chr1 . Index . Chr2, Index ++
   StringReplace, Tree, Tree, %ListDelimiter%, %ListDelimiter%, UseErrorLevel
   Loop, % (A_LoopField - ErrorLevel) + 1
    Tree .= ListDelimiter
   StringGetPos, Temp1, Tree, %ListDelimiter%, L%A_LoopField%
   Temp2 := InStr(Tree,ListDelimiter,False,Temp1 + StrLen(ListDelimiter) + 1)
   If (ErrorLevel || !Temp2)
    Return
   LeftSide .= SubStr(Tree,1,Temp1), RightSide := SubStr(Tree,Temp2) . RightSide, Temp1 ++, Tree := SubStr(Tree,Temp1,Temp2 - Temp1)
  }
  Tree := LeftSide . RightSide, LeftSide := "", RightSide := ""
 }
 Return, 1
}

TreeGetDepth(ByRef Tree)
{
 Return, SubStr(Tree,2,InStr(Tree,Chr(2),False,2) - 2)
}

TreeSetDepth(ByRef Tree,Depth = 0)
{
 Chr1 := Chr(1), Chr2 := Chr(2), RecursionDepth := SubStr(Tree,2,InStr(Tree,Chr2,False,2) - 2)
 If (Depth < RecursionDepth) ;replace the list delimiters from lowest to highest
 {
  Depth --, RecursionDepth --
  While, InStr(Tree,Chr1 . (Temp1 := RecursionDepth + A_Index) . Chr2) ;set the tree depth
   StringReplace, Tree, Tree, %Chr1%%Temp1%%Chr2%, % Chr1 . (Depth + A_Index) . Chr2, All
 }
 Else If (Depth > RecursionDepth) ;replace the list delimiters from highest to lowest
 {
  RecursionDepth --
  While, InStr(Tree,Chr1 . (RecursionDepth + A_Index) . Chr2) ;find the highest list delimiter
   MaxDepth := A_Index
  RecursionDepth += MaxDepth + 1, Depth += MaxDepth
  Loop, %MaxDepth% ;set the tree depth
   StringReplace, Tree, Tree, % Chr1 . (RecursionDepth - A_Index) . Chr2, % Chr1 . (Depth - A_Index) . Chr2, All
 }
 Return, 1
}

TreeTraverse(Tree,CallBack,Recurse = 1,Path = "")
{
 Chr1 := Chr(1), ListDelimiter := SubStr(Tree,1,InStr(Tree,Chr(2),False,2)), Temp1 := StrLen(ListDelimiter), TempTree := ListDelimiter, FoundPos := 1
 While, (FoundPos := InStr(Tree,ListDelimiter,False,FoundPos))
 {
  FoundPos += Temp1, Temp2 := InStr(Tree,ListDelimiter,False,FoundPos)
  If Not Temp2
   Break
  Temp2 := SubStr(Tree,FoundPos,Temp2 - FoundPos), TempTree .= ((SubStr(Temp2,1,1) = Chr1) ? (Recurse ? TreeTraverse(Temp2,CallBack,1,Path . "." . A_Index) : %CallBack%(Temp2,A_Index,"Branch")) : %CallBack%(Temp2,SubStr(Path . "." . A_Index,2),"Leaf")) . ListDelimiter
 }
 Return, Recurse ? %CallBack%(TempTree,SubStr(Path,2),"Branch") : TempTree
}