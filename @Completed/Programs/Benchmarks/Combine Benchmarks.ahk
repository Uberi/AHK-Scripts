#NoEnv

FileSelectFile, File1, 11, %A_ScriptDir%, Select the first benchmark., *.html
If ErrorLevel
 ExitApp
File1Version := "AHK v1.0.48.05"
If RegExMatch(File1,"S)\d+\.\d+\.\d+\.\d+",Temp1)
 File1Version := "AHK v" . Temp1
InputBox, File1Version, AutoHotkey version, Input the version of AutoHotkey this benchmark was run on:,, 380, 120,,,,, %File1Version%
If ErrorLevel
 ExitApp

FileSelectFile, File2, 11, %A_ScriptDir%, Select the second benchmark., *.html
If ErrorLevel
 ExitApp
File2Version := "AHK v1.1.00.00"
If RegExMatch(File2,"S)\d+\.\d+\.\d+\.\d+",Temp1)
 File2Version := "AHK v" . Temp1
InputBox, File2Version, AutoHotkey version, Input the version of AutoHotkey this benchmark was run on:,, 380, 120,,,,, %File2Version%
If ErrorLevel
 ExitApp

FileRead, File1, %File1%
Temp1 := GetNumbers(File1)
StringSplit, File1Result, Temp1, `n
FileRead, File2, %File2%
Temp1 := GetNumbers(File2)
StringSplit, File2Result, Temp1, `n

FoundPos := 1, FoundPos1 := 1
While, (FoundPos := RegExMatch(File1,"S)(<tr(?: class=""alt"")?><td>[^<]+</td><td><pre>[^<]+</pre></td>)<td>[^<]+</td></tr>",Match,FoundPos))
{
 Temp1 := File1Result%A_Index%, Temp2 := File2Result%A_Index%
 If (Temp1 < Temp2)
  Temp1 := "<em>" . Temp1 . "</em>"
 Else If (Temp1 > Temp2)
  Temp2 := "<em>" . Temp2 . "</em>"
 Result .= SubStr(File1,FoundPos1,FoundPos - FoundPos1) . Match1 . "<td>" . Temp1 . "</td><td>" . Temp2 . "</td></tr>", FoundPos += StrLen(Match), FoundPos1 := FoundPos
}
Result .= SubStr(File1,FoundPos1)
Result := RegExReplace(Result,"S)<th>[^<]+</th><th>[^<]+</th>\K<th>[^<]+</th></tr>","<th>" . File1Version . "</th><th>" . File2Version . "</th></tr>")
StringReplace, Result, Result, </style>, em{font-weight:bold;}</style>, All ;insert the extra style rule for the "em" tag
FileSelectFile, FileName, S16, Combined Benchmarks.html, Select a save path for the combined benchmark., *.html
If !ErrorLevel
{
 FileDelete, %FileName%
 FileAppend, %Result%, %FileName%
}
ExitApp

GetNumbers(Benchmark)
{
 Benchmark := SubStr(Benchmark,InStr(Benchmark,"<tr class=""alt""><td>"))
 StringReplace, Benchmark, Benchmark, <table>,, All
 StringReplace, Benchmark, Benchmark, </table>,, All
 StringReplace, Benchmark, Benchmark, <tr class="alt">, <tr>, All
 Benchmark := SubStr(Benchmark,1,InStr(Benchmark,"<h2 id=""SystemInformation"">",False,0) - 1)
 Benchmark := RegExReplace(Benchmark,"S)<tr><th>[^<]+</th><th>[^<]+</th><th>[^<]+</th></tr>")
 Benchmark := RegExReplace(Benchmark,"S)<p>[^<]+</p>")
 Benchmark := RegExReplace(Benchmark,"S)<h2 id=""[^""]+"">[^<]+</h2>")
 Benchmark := RegExReplace(Benchmark,"S)<tr><td>[^<]+</td><td><pre>[^<]+</pre></td>")
 StringReplace, Benchmark, Benchmark, </td></tr>,, All
 StringReplace, Benchmark, Benchmark, <td>, `n, All
 Return, SubStr(Benchmark,2)
}