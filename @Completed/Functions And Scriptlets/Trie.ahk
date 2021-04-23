#NoEnv

/*
WordList := "He`nHeathen`nHere`nIdentify`nIndignant`nIndividual"
Trie := TrieCreate(WordList)
Words := TrieSearch(Trie)
Serialized := TrieSerialize(Trie)
Deserialized := TrieDeserialize(Serialized,Position := 0)
SearchTrie := TrieSearch(Trie,"Ind")
SearchDeserialized := TrieSearch(Deserialized,"He")
MsgBox, WordList:`n"%WordList%"`n`nWords:`n"%Words%"`n`nSerialized:`n"%Serialized%"`n`nTrie search:`n"%SearchTrie%"`n`nDeserialized trie search:`n"%SearchDeserialized%"
*/

TrieCreate(ByRef WordList)
{
 Trie := Object("A",0,"B",0,"C",0,"D",0,"E",0,"F",0,"G",0,"H",0,"I",0,"J",0,"K",0,"L",0,"M",0,"N",0,"O",0,"P",0,"Q",0,"R",0,"S",0,"T",0,"U",0,"V",0,"W",0,"X",0,"Y",0,"Z",0,"'",0,"End",0)
 Loop, Parse, WordList, `n
 {
  CurrentObject := Trie
  Loop, Parse, A_LoopField
  {
   If !IsObject(CurrentObject[A_LoopField])
    CurrentObject[A_LoopField] := Object("A",0,"B",0,"C",0,"D",0,"E",0,"F",0,"G",0,"H",0,"I",0,"J",0,"K",0,"L",0,"M",0,"N",0,"O",0,"P",0,"Q",0,"R",0,"S",0,"T",0,"U",0,"V",0,"W",0,"X",0,"Y",0,"Z",0,"'",0,"End",0)
   CurrentObject := CurrentObject[A_LoopField]
  }
  CurrentObject.End := 1
 }
 Return, Trie
}

TrieSerialize(Trie)
{
 Serialized := ""
 For Key, Value In Trie
 {
  If (Key = "End" || !IsObject(Value))
   Continue
  Serialized .= Key . TrieSerialize(Value) . "^"
 }
 If Trie.End
  Serialized .= "~"
 Return, Serialized
}

TrieDeserialize(ByRef Serialized,ByRef Position)
{
 Trie := Object("A",0,"B",0,"C",0,"D",0,"E",0,"F",0,"G",0,"H",0,"I",0,"J",0,"K",0,"L",0,"M",0,"N",0,"O",0,"P",0,"Q",0,"R",0,"S",0,"T",0,"U",0,"V",0,"W",0,"X",0,"Y",0,"Z",0,"'",0,"End",0)
 Loop
 {
  Position ++, CurrentChar := SubStr(Serialized,Position,1)
  If (CurrentChar = "" || CurrentChar = "^")
   Return, Trie
  If (CurrentChar = "~")
   Trie.End := 1
  Else
   Trie[CurrentChar] := TrieDeserialize(Serialized,Position)
 }
}

TrieSearch(Trie,Word = "")
{
 CurrentObject := Trie, MatchList := Array(), MatchList := ""
 Loop, Parse, Word
 {
  CurrentObject := CurrentObject[A_LoopField]
  If !IsObject(CurrentObject)
   Return, 0
 }
 If CurrentObject.End
  MatchList .= Word . "`n"
 TrieDeepSearch(CurrentObject,Word,MatchList)
 Return, SubStr(MatchList,1,-1)
}

TrieDeepSearch(Trie,Word,ByRef MatchList)
{
 For Key, Value In Trie
 {
  If IsObject(Value)
  {
   If Value.End
    MatchList .= Word . Key . "`n"
   TrieDeepSearch(Value,Word . Key,MatchList)
  }
 }
}