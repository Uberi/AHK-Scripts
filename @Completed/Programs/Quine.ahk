Script := "Script := #, Temp1 := Script$StringReplace, Script, Script, % Chr(36), % Chr(13) . Chr(10), All$StringReplace, Script, Script, #, % Chr(34) . Temp1 . Chr(34)$MsgBox, %Script%", Temp1 := Script
StringReplace, Script, Script, % Chr(36), % Chr(13) . Chr(10), All
StringReplace, Script, Script, #, % Chr(34) . Temp1 . Chr(34)
MsgBox, %Script%