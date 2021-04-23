#NoEnv

;/*
Characters := 1000

Benchmark := "URL decoding with " . Characters . " character strings"
Iterations := 10000
Test1 := "Replace Decoder"
Test2 := "Rebuild Decoder"
*/

/*
Benchmark:       URL decoding with 50 character strings
Iterations:      100000
Control Run:     112.884459 ms.  (0.001129 ms. per run)
Replace Decoder: 4891.371948 ms. (0.048914 ms. per run)
Rebuild Decoder: 2407.297017 ms. (0.024073 ms. per run)
*/

Gosub, Start
Return

Setup:
;/*
Original := "This+is+a+test%3b+this+%0a%25+is+also+%2d%2d+a+test..a%21b%40c%23d%24e%25f%5eg%26h%2ai%28jk%22%29l%3c%3e%3f%7b%7d%7c%5b%5d%5csome+more+symbols%60~%5c%22and+", OriginalLength := StrLen(Original)
Loop, % Characters // OriginalLength
 String .= Original
String .= SubStr(Original,1,Mod(Characters,OriginalLength))
*/
Return

Test1:
URLDecode2(String)
Return

Test2:
URLDecode1(String)
Return

URLDecode1(Encoded)
{
 FoundPos := 0
 While, (FoundPos := InStr(Encoded,"%",False,FoundPos + 1))
 {
  If ((Temp1 := SubStr(Encoded,FoundPos + 1,2)) <> 25)
   StringReplace, Encoded, Encoded, `%%Temp1%, % Chr("0x" . Temp1), All
 }
 StringReplace, Encoded, Encoded, `%25, `%, All
 StringReplace, Encoded, Encoded, +, %A_Space%, All
 Return, Encoded
}

URLDecode2(Encoded)
{
 StringReplace, Encoded, Encoded, +, %A_Space%, All
 Loop, Parse, Encoded, `%
  `(A_Index = 1) ? Decoded := A_LoopField : Decoded .= Chr("0x" . SubStr(A_LoopField,1,2)) . SubStr(A_LoopField,3)
 Return, Decoded
}

Blank:

Return

Update:
Percentage := Round((CurrentIterations / Iterations) * 100)
GuiControl,, TestProgress, %Percentage%
GuiControl,, Percentage, %Percentage%`%
GuiControl,, Iterations, %CurrentIterations%
Return

Start:
SetBatchLines, -1
Process, Priority,, Realtime
CurrentIterations = 0
Gui, Font, s18 Bold, Arial
Gui, Add, Text, x12 y0 w410 h30 Center, Benchmarking...
Gui, Add, Progress, x12 y40 w410 h20 -Smooth vTestProgress
Gui, Font, s12
Gui, Add, Text, x12 y60 w410 h15 Center vPercentage
Gui, Font, s10
Gui, Add, Text, x12 y85 w90 h20, Now testing:
Gui, Font, Norm
Gui, Add, Text, x102 y85 w320 h20 vCurrentTest
Gui, Font, Bold
Gui, Add, Text, x12 y105 w90 h20, Iterations:
Gui, Font, Norm
Gui, Add, Text, x102 y105 w320 h20 vIterations, 0
Gui, Show, w435 h130, Benchmark
SetTimer, Update, 100
Gosub, Update

GuiControl,, CurrentTest, Setup
Gosub, Setup
DllCall("QueryPerformanceFrequency","Int64*",TicksPerMillisecond), TicksPerMillisecond /= 1000, CurrentIterations := 0
GuiControl,, CurrentTest, Waiting
Sleep, 1000
GuiControl,, CurrentTest, Control run
DllCall("QueryPerformanceCounter","Int64*",TimerBefore)
Loop, %Iterations%
{
    Gosub, Blank
    CurrentIterations ++
}
DllCall("QueryPerformanceCounter","Int64*",TimerAfter), BlankRun := (TimerAfter - TimerBefore) / TicksPerMillisecond, BlankRunSingle := BlankRun / Iterations, CurrentIterations := 0
GuiControl,, CurrentTest, Waiting
Sleep, 1000
GuiControl,, CurrentTest, Test 1 - %Test1%
DllCall("QueryPerformanceCounter","Int64*",TimerBefore)
Loop, %Iterations%
{
    Gosub, Test1
    CurrentIterations ++
}
DllCall("QueryPerformanceCounter","Int64*",TimerAfter), Time1 := (TimerAfter - TimerBefore) / TicksPerMillisecond, Time1Single := Time1 / Iterations, CurrentIterations := 0
GuiControl,, CurrentTest, Waiting
Sleep, 1000
GuiControl,, CurrentTest, %Test2%
DllCall("QueryPerformanceCounter","Int64*",TimerBefore)
Loop, %Iterations%
{
    Gosub, Test2
    CurrentIterations ++
}
DllCall("QueryPerformanceCounter","Int64*",TimerAfter), Time2 := (TimerAfter - TimerBefore) / TicksPerMillisecond, Time2Single := Time2 / Iterations

Temp1 := StrLen(Test1), Temp2 := StrLen(Test2), MaxLen := ((Temp1 > 11 && Temp2 > 11) ? ((Temp1 > Temp2) ? Temp1 : Temp2) : 11) + 1, Temp3 := StrLen(BlankRun), Temp4 := StrLen(Time1), Temp5 := StrLen(Time2), MaxNumLen := ((Temp3 > Temp4) ? ((Temp3 > Temp5) ? Temp3 : Temp5) : ((Temp4 > Temp5) ? Temp4 : Temp5)) + 1, Temp6 := StrLen(BlankRunSingle), Temp7 := StrLen(Time1Single), Temp8 := StrLen(Time2Single), MaxNumSingleLen := ((Temp6 > Temp7) ? ((Temp6 > Temp7) ? Temp6 : Temp8) : ((Temp7 > Temp8) ? Temp7 : Temp8)) + 1
% (Benchmark = "") ? Benchmark := """" . Test1 . """ versus """ . Test2 . """"
Info := "Benchmark:" . Pad(MaxLen - 9) . Benchmark . "`nIterations:" . Pad(MaxLen - 10) . Iterations . "`nControl Run:" . Pad(MaxLen - 11) . BlankRun . " ms." . Pad(MaxNumLen - Temp3) . "(" . BlankRunSingle . Pad(MaxNumSingleLen - Temp6) . "ms. per run)`n" . Test1 . ":" . Pad(MaxLen - Temp1) . Time1 . " ms." . Pad(MaxNumLen - Temp4) . "(" . Time1Single . Pad(MaxNumSingleLen - Temp7) . "ms. per run)`n" . Test2 . ":" . Pad(MaxLen - Temp2) . Time2 . " ms." . Pad(MaxNumLen - Temp5) . "(" . Time2Single . Pad(MaxNumSingleLen - Temp8) . "ms. per run)"

SetTimer, Update, Off
Gui, Destroy
Gui, Font, s18 Bold, Arial
Gui, Add, Text, x12 y0 w450 h30 +Center, Results
Gui, Font, s8
Gui, Add, Text, x12 y40 w70 h20, Benchmark:
Gui, Font, Norm
Gui, Add, Edit, x82 y40 w380 h20 ReadOnly, %Benchmark%
Gui, Font, Bold
Gui, Add, Text, x12 y70 w70 h20, Iterations:
Gui, Font, Norm
Gui, Add, Edit, x82 y70 w380 h20 ReadOnly Center, %Iterations%
Gui, Font, Bold
Gui, Add, Text, x12 y110 w70 h20, Control Run:
Gui, Font, Norm
Gui, Add, Edit, x82 y110 w140 h20 ReadOnly Right, %BlankRun%
Gui, Add, Text, x222 y110 w30 h20, %A_Space%ms.
Gui, Add, Edit, x262 y110 w140 h20 ReadOnly Right, %BlankRunSingle%
Gui, Add, Text, x402 y110 w60 h20, %A_Space%ms. per run
Gui, Font, Bold
Gui, Add, Text, x12 y140 w70 h20, Test 1:
Gui, Font, Norm
Gui, Add, Edit, x82 y140 w110 h20 ReadOnly, %Test1%
Gui, Add, Edit, x202 y140 w80 h20 ReadOnly Right, %Time1%
Gui, Add, Text, x282 y140 w30 h20, %A_Space%ms.
Gui, Add, Edit, x322 y140 w80 h20 ReadOnly Right, %Time1Single%
Gui, Add, Text, x402 y140 w60 h20, %A_Space%ms. per run
Gui, Font, Bold
Gui, Add, Text, x12 y170 w70 h20, Test 2:
Gui, Font, Norm
Gui, Add, Edit, x82 y170 w110 h20 ReadOnly, %Test2%
Gui, Add, Edit, x202 y170 w80 h20 ReadOnly Right, %Time2%
Gui, Add, Text, x282 y170 w30 h20, %A_Space%ms.
Gui, Add, Edit, x322 y170 w80 h20 Right +ReadOnly, %Time2Single%
Gui, Add, Text, x402 y170 w60 h20, %A_Space%ms. per run
Gui, Font, s10 Bold
Gui, Add, Text, x12 y200 w450 h20 Center, Summary
Gui, Font, s8 Norm, Courier New
Gui, Add, Edit, x12 y220 w450 h80 ReadOnly -Wrap -VScroll, %Info%
Gui, Font, Bold, Arial
Gui, Add, Button, x12 y300 w450 h30 gCopy Default, Copy
Gui, Show, w475 h340, Benchmark
Return

Copy:
Clipboard = %Info%
MsgBox, 64, Copied, Benchmark summary copied to clipboard.
Return

GuiClose:
ExitApp

Pad(Length)
{
    Pad := ""
    Loop, %Length%
        Pad .= " "
    Return, Pad
}