#NoEnv

;wip: add support for dumping to files and reading from files
;wip: use UPtr for RtlMoveMemory

/*
SomeData := "abc123test1bla"
DictionarySet(SomeDictionary,"SomeKey",SomeData,StrLen(SomeData))
SomeData := "abc123test2"
DictionarySet(SomeDictionary,"SomeOtherKey",SomeData,StrLen(SomeData))
SomeData := "abc123test2bla"
DictionarySet(SomeDictionary,"SomeOtherKey",SomeData,StrLen(SomeData))
SomeData := "abc123testabcdef"
DictionarySet(SomeDictionary,"SomeKey1",SomeData,StrLen(SomeData))

DictionaryGet(SomeDictionary,"SomeKey",OutputVar)
MsgBox "%OutputVar%"
DictionaryGet(SomeDictionary,"SomeOtherKey",OutputVar)
MsgBox "%OutputVar%"
DictionaryGet(SomeDictionary,"SomeKey1",OutputVar)
MsgBox "%OutputVar%"

DictionaryGetKeys(SomeDictionary,OutputVar,OutputCount)
MsgBox "%OutputVar%"`n`n%OutputCount% item(s) in the dictionary.

SomeData := ","
DictionaryJoin(SomeDictionary,OutputVar,SomeData,StrLen(SomeData))
MsgBox "%OutputVar%"

MsgBox "%SomeDictionary%"
DictionaryRemove(SomeDictionary,"SomeOtherKey")
MsgBox "%SomeDictionary%"
DictionaryClear(SomeDictionary)
MsgBox "%SomeDictionary%"
*/

DictionarySet(ByRef Dictionary,Key,ByRef Data,DataLength)
{
 If (Key = "")
  Return, 1
 pDataCopy := DllCall("LocalAlloc","UInt",0,"UInt",DataLength)
 If !pDataCopy
  Return, 1
 InStr("`n" . Dictionary,"`n" . Key . "|") ? DictionaryRemove(Dictionary,Key)
 DllCall("RtlMoveMemory","UInt",pDataCopy,"UInt",&Data,"UInt",DataLength), Dictionary .= Key . "|" . pDataCopy . "|" . DataLength . "`n"
}

DictionaryGet(ByRef Dictionary,Key,ByRef OutputVar,ByRef OutputVarLength = "")
{
 VarSetCapacity(OutputVar,64), VarSetCapacity(OutputVar,0), Temp1 := InStr("`n" . Dictionary,"`n" . Key . "|")
 If !Temp1
  Return, 1
 Temp1 += StrLen(Key) + 1, Temp2 := InStr(Dictionary,"|",0,Temp1) + 1, OutputVarLength := SubStr(Dictionary,Temp2,InStr(Dictionary,"`n",0,Temp2) - Temp2), VarSetCapacity(OutputVar,OutputVarLength,13), DllCall("RtlMoveMemory","UInt",&OutputVar,"UInt",SubStr(Dictionary,Temp1,(Temp2 - 1) - Temp1),"UInt",OutputVarLength)
}

DictionaryRemove(ByRef Dictionary,Key)
{
 Temp1 := InStr("`n" . Dictionary,"`n" . Key . "|")
 If !Temp1
  Return, 1
 Temp1 += StrLen(Key) + 1, Temp1 := SubStr(Dictionary,Temp1,InStr(Dictionary,"`n",0,Temp1) - Temp1), DllCall("LocalFree","UInt",SubStr(Temp1,1,InStr(Temp1,"|") - 1))
 StringReplace, Dictionary, Dictionary, %Key%|%Temp1%`n
}

DictionaryGetKeys(ByRef Dictionary,ByRef OutputVar,ByRef OutputCount)
{
 OutputVar := SubStr(RegExReplace("`n" . Dictionary,"S)(\n[^\|]+)[^\n]+","$1"),2,-1)
 StringReplace, OutputVar, OutputVar, `n, `n, UseErrorLevel
 OutputCount := ErrorLevel + 1
}

DictionaryClear(ByRef Dictionary)
{
 Dictionary := SubStr(Dictionary,1,-1)
 Loop, Parse, Dictionary, `n
  Temp1 := InStr(A_LoopField,"|") + 1, DllCall("LocalFree","UInt",SubStr(A_LoopField,Temp1,InStr(A_LoopField,"|",False,Temp1) - Temp1))
 Dictionary := ""
}

DictionaryJoin(ByRef Dictionary,ByRef OutputVar,ByRef Separator = "",SeparatorLength = -1)
{
 StringReplace, Dictionary, Dictionary, `n, `n, UseErrorLevel
 ItemCount := ErrorLevel, TotalLength := (ItemCount - 1) * SeparatorLength, Dictionary1 := SubStr(Dictionary,1,-1), (SeparatorLength = -1) ? SeparatorLength := StrLen(Separator)
 Loop, Parse, Dictionary1, `n
  TotalLength += SubStr(A_LoopField,InStr(A_LoopField,"|",False,0) + 1)
 VarSetCapacity(OutputVar,64), VarSetCapacity(OutputVar,0), VarSetCapacity(OutputVar,TotalLength,13), pOutput := &OutputVar, pSeparator := &Separator
 Loop, Parse, Dictionary1, `n
  Temp1 := InStr(A_LoopField,"|") + 1, Temp2 := SubStr(A_LoopField,InStr(A_LoopField,"|",0,0) + 1), DllCall("RtlMoveMemory","UInt",pOutput,"UInt",SubStr(A_LoopField,Temp1,InStr(A_LoopField,"|",0,Temp1) - Temp1),"UInt",Temp2), pOutput += Temp2, (A_Index != ItemCount) ? (DllCall("RtlMoveMemory","UInt",pOutput,"UInt",pSeparator,"UInt",SeparatorLength), pOutput += SeparatorLength)
}