#NoEnv

WaitPeriod := 500
DefaultIterations := 1000000 ;between 10000 and 5000000 will yield good results.
OutputStyle := "Desaturated"

SetBatchLines, -1
Process, Priority,, Realtime
Gui, Font, s18 Bold, Arial
Gui, Add, Text, x12 y0 w410 h30 Center, Benchmarking...
Gui, Add, Progress, x12 y40 w410 h20 0x8 -Smooth vTestProgress
Gui, Font, s10
Gui, Add, Text, x12 y65 w90 h20, Action:
Gui, Font, Norm
Gui, Add, Text, x102 y65 w320 h20 Right vCurrentTest, SomeTest
Gui, Font, Bold
Gui, Add, Text, x12 y90 w90 h20, Iterations:
Gui, Font, Norm
Gui, Add, Text, x102 y90 w320 h20 Right vIterations, 0
Temp1 := A_IsUnicode ? "Unicode" : "ANSI"
Gui, Show, w435 h115, Benchmark (AHK v%A_AhkVersion% %Temp1%)
SetTimer, UpdateGUI, 100
Gosub, UpdateGUI

StyleDesaturated = body{background:#F3F3F3;font-family:Constantia,"Lucida Serif",Lucida,"DejaVu Serif","Bitstream Vera Serif","Liberation Serif",Georgia,serif;margin:2em;font-size:1em;color:#BBBBBB;}table{width:100`%;border-collapse:collapse;color:#707070;}h1{font-size:2.8em;text-shadow:#555555 0 -1px 0.04em;color:#D5D5D5;text-align:center;}h2{font-size:1.9em;text-shadow:#555555 0 -1px 0.035em;}td,th{background:#D0D0D0;text-shadow:#FFFFFF 0 0.5px 0.3em;border:1px solid #D5D5D5;padding:0.2em;}th{font-size:1.2em;text-align:left;background-color:#E0E0E0;text-shadow:#888888 0 -1px 0.04em;color:#AAAAAA;}tr.alt td{background-color:#BFBFBF;}pre{background-color:#6F6F6F;margin:0.1em;padding:0.4em;font-size:0.8em;font-family:"Courier New",Courier,monospace;color:#FFFFFF;-webkit-border-radius:0.2em;-moz-border-radius:0.2em;border-radius:0.2em;}ul{padding:1em;background-color:#E5E5E5;-webkit-box-shadow:inset 1px 2px 0.3em #555555;-moz-box-shadow:inset 1px 2px 0.3em #555555;box-shadow:inset 1px 2px 0.3em #555555;line-height:1.5;width:13em;list-style-type:none;}a{text-shadow:#FFFFFF 0 0.5px 0.3em;}a:link{color:#A0A0A0;}a:visited{color:#B8B8B8;}a:hover{color:#FFFFFF;}
StyleDark = body{background:#000000;font-family:Arial,Helvetica,sans-serif;margin:2em;font-size:1em;color:#EAEAEA;}table{width:100`%;border-collapse:collapse;color:#FFFFFF;}h1{font-size:2.8em;text-shadow:#FFFFFF 0px 0px 0.25em;color:#FFFFFF;text-align:center;}h2{font-size:1.9em;text-shadow:#FFFFFF 0 0 0.15em;}td,th{background:#4A4A4A;border:1px solid #FFFFFF;padding:0.2em;}th{font-size:1.2em;text-align:left;background-color:#777777;color:#E0E0E0;text-shadow:#FFFFFF 0 0 0.1em;}tr.alt td{background-color:#222222;}pre{background-color:#656565;margin:0.1em;padding:0.4em;font-size:0.8em;font-family:"Courier New",Courier,monospace;color:#FFFFFF;-webkit-border-radius:0.8em;-moz-border-radius:0.8em;border-radius:0.5em;}ul{padding:1em;background-color:#383838;border:0.15em solid #FFFFFF;line-height:1.5;-webkit-border-radius:0.8em;-moz-border-radius:0.8em;border-radius:0.8em;width:13em;list-style-type:none;}a{text-shadow:#FFFFFF 0 0 0.1em;}a:link{color:#EFEFEF;}a:visited{color:#BABABA;}a:hover{text-shadow:#FFFFFF 0 0 0.25em;}
StyleGreen = body{background:#668844;font-family:Arial,Helvetica,sans-serif;margin:2em;font-size:1em;color:#D0E0B0;}table{width:100`%;border-collapse:collapse;color:#F0FFCC;}h1{font-size:2.8em;color:#BBCC99;text-align:center;}h2{font-size:1.9em;}td,th{background:#B7D952;border:1px solid #98BF21;padding:0.2em;}th{font-size:1.2em;text-align:left;background-color:#94B532;color:#E0EEBB;}tr.alt td{background-color:#A7C942;}pre{background:#A0BD32;margin:0.1em;padding:0.4em;font-size:0.8em;font-family:"Courier New",Courier,monospace;}ul{padding:1em;background-color:#94B532;width:13em;list-style-type:none;}a:link{color:#D9F59C;}a:visited{color:#C4E088;}

Temp1 := Style%OutputStyle%
LogFile = <!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd"><html><head><meta http-equiv="Content-Type" content="text/html;charset=UTF-8"><title>AutoHotkey Benchmarks</title><style>%Temp1%</style></head><body><h1>AutoHotkey Benchmarks</h1><h2 id="Contents">Contents</h2><ul>

DllCall("QueryPerformanceFrequency","Int64*",TicksPerMillisecond), TicksPerMillisecond /= 1000
While, IsLabel("Test" . A_Index)
{
 GuiControl,, CurrentTest, Setup
 Iterations1 := Iterations
 Gosub, Test%A_Index%Setup
 If (A_Index = 1)
 {
  StringReplace, TempCategory, Category, %A_Space%,, All
  LogFile1 .= "</ul><h2 id=""" . TempCategory . """>" . Category . "</h2><table><tr><th>Benchmark</th><th>Code</th><th>Average time per run (ms)</th></tr>", OddCount := 0, LogFile .= "<li><a href=""#" . TempCategory . """>" . Category . "</a></li>"
 }
 Else If (Category != Category1)
 {
  StringReplace, TempCategory, Category, %A_Space%,, All
  LogFile1 .= "</table><p>" . RegExReplace(Iterations1,"\G\d+?(?=(\d{3})+(?:\D|$))","$0,") . " iterations each</p><h2 id=""" . TempCategory . """>" . Category . "</h2><table><tr><th>Benchmark</th><th>Code</th><th>Average time per run (ms)</th></tr>", OddCount := 0, LogFile .= "<li><a href=""#" . TempCategory . """>" . Category . "</a></li>"
 }
 Category1 := Category, OddCount ++
 Transform, Code, HTML, %Code%
 StringReplace, Code, Code, <br>,, All
 GuiControl,, CurrentTest, Waiting
 Sleep, %WaitPeriod%
 GuiControl,, CurrentTest, Testing "%Category%: %TestName%"
 CurrentIterations := 0, A_Index1 := A_Index, DllCall("QueryPerformanceCounter","Int64*",TimerBefore)
 Loop, %Iterations%
 {
  Gosub, Test%A_Index1%
  CurrentIterations ++
 }
 DllCall("QueryPerformanceCounter","Int64*",TimerAfter), CurrentIterations := 1
 LogFile1 .= "<tr" . ((OddCount & 1) ? " class=""alt""" : "") . "><td>" . TestName . "</td><td><pre>" . Code . "</pre></td><td>" . (((TimerAfter - TimerBefore) / TicksPerMillisecond) / Iterations) . "</td></tr>"
}
LogFile .= "<li><a href=""#SystemInformation"">System Information</a></li>"
LogFile .= LogFile1 . "</table><p>" . RegExReplace(Iterations,"\G\d+?(?=(\d{3})+(?:\D|$))","$0,") . " iterations each</p><h2 id=""SystemInformation"">System Information</h2><table><tr><th>Field</th><th>Value</th></tr>"
CurrentIterations := 1, Iterations := 1
GuiControl,, CurrentTest, Collecting System Information
SystemInfo := "AutoHotkey Version|AutoHotkey v" . A_AhkVersion . " " . (A_IsUnicode ? "Unicode" : "ANSI") . " (x" . ((A_PtrSize = 8) ? "64" : "86") . ")`n" . GetSystemInfo()
Loop, Parse, SystemInfo, `n
{
 StringSplit, Temp, A_LoopField, |
 LogFile .= "<tr" . ((A_Index & 1) ? " class=""alt""" : "") . "><td>" . Temp1 . "</td><td>" . Temp2 . "</td></tr>"
}
LogFile .= "</table></body></html>"
Gui, Destroy
FileSelectFile, FileName, S16, Benchmarks v%A_AhkVersion%.html, Select a save path for the benchmark summary., *.html
If !ErrorLevel
{
 FileDelete, %FileName%
 FileAppend, %LogFile%, %FileName%
}
ExitApp

UpdateGUI:
GuiControl,, TestProgress, +7
GuiControl,, Iterations, %CurrentIterations% of %Iterations%
Return

GuiClose:
ExitApp

Test1Setup:
Iterations := DefaultIterations, Category := "Control Group", TestName := "Blank Run"
Code = (None)
Return
Test1:
Return

Test2Setup:
Category := "Assignment", TestName := "Classic", Variable := ""
Code = Variable = Lorem ipsum dolor sit amet
Return
Test2:
Variable = Lorem ipsum dolor sit amet
Return

Test3Setup:
Category := "Assignment", TestName := "Classic with variable", Variable := ""
Code = Variable = Lorem ipsum `%OtherVariable`% dolor sit amet
Return
Test3:
Variable = Lorem ipsum%OtherVariable% dolor sit amet
Return

Test4Setup:
TestName := "Expression", Variable := ""
Code = Variable := "Lorem ipsum dolor sit amet"
Return
Test4:
Variable := "Lorem ipsum dolor sit amet"
Return

Test5Setup:
TestName := "Expression with variable", Variable := ""
Code = Variable := "Lorem ipsum" . OtherVariable . " dolor sit amet"
Return
Test5:
Variable := "Lorem ipsum" . OtherVariable . " dolor sit amet"
Return

Test6Setup:
TestName := "Expression explicit concatenation", Variable := ""
Code = Variable := "Lorem ipsum" . " dolor sit amet"
Return
Test6:
Variable := "Lorem ipsum" . " dolor sit amet"
Return

Test7Setup:
TestName := "Expression implicit concatenation", Variable := ""
Code = Variable := "Lorem ipsum" " dolor sit amet"
Return
Test7:
Variable := "Lorem ipsum" " dolor sit amet"
Return

Test8Setup:
Category := "Comparison", TestName := "Classic If statement", Variable := "abcdeg"
Code = If Variable = abcdef`n Return
Return
Test8:
If Variable = abcdef
 Return
Return

Test9Setup:
TestName := "Expression If statement"
Code = If (Variable = "abcdef")`n Return
Return
Test9:
If (Variable = "abcdef")
 Return
Return

Test10Setup:
TestName := "List comparison"
Code = If Variable In abcdef`n Return
Return
Test10:
If Variable In abcdef
 Return
Return

Test11Setup:
TestName := "Ternary"
Code = `% (Variable = "abcdef") ? "" : ""
Return
Test11:
% (Variable = "abcdef") ? ""
Return

Test12Setup:
TestName := "Classic If between", Variable := 123
Code = If Variable Between 123 And 124`n Return
Return
Test12:
If Variable Between 123 And 124
 Return
Return

Test13Setup:
TestName := "Expression If between"
Code = If (Variable >= 123 && Variable <= 124)`n Return
Return
Test13:
If (Variable >= 123 && Variable <= 124)
 Return
Return

Test14Setup:
Category := "String Searching", TestName := "String search statement", Variable := "abcdeg"
Code = IfInString, Variable, abcdef`n Return
Return
Test14:
IfInString, Variable, abcdef
 Return
Return

Test15Setup:
TestName := "List search statement"
Code = If Variable Contains abcdef`n Return
Return
Test15:
If Variable Contains abcdef
 Return
Return

Test16Setup:
TestName := "String get position command"
Code = StringGetPos, Temp1, Variable, abcdef
Return
Test16:
StringGetPos, Temp1, Variable, abcdef
Return

Test17Setup:
TestName := "In string function"
Code = InStr(Variable,"abcdef")
Return
Test17:
InStr(Variable,"abcdef")
Return

Test18Setup:
Iterations := DefaultIterations // 2, Category := "Regular Expressions", TestName := "Match function", Variable := "abcdeg", RegExMatch(Variable,"S)ab.*?.f$")
Code = RegExMatch(Variable,"S)ab.*?.f$")
Return
Test18:
RegExMatch(Variable,"S)ab.*?.f$")
Return

Test19Setup:
TestName := "Replace function", RegExReplace(Variable,"S)ab.*?.f$")
Code = RegExReplace(Variable,"S)ab.*?.f$","$0")
Return
Test19:
RegExReplace(Variable,"S)ab.*?.f$","$0")
Return

Test20Setup:
TestName := "Static match", RegExMatch(Variable,"S)abcdef")
Code = RegExMatch(Variable,"S)abcdef")
Return
Test20:
RegExMatch(Variable,"S)abcdef")
Return

Test21Setup:
TestName := "Static replace", RegExReplace(Variable,"S)c","c")
Code = RegExReplace(Variable,"c","c")
Return
Test21:
RegExReplace(Variable,"S)c","c")
Return

Test22Setup:
Iterations := DefaultIterations, Category := "String Manipulation", TestName := "Substring function"
Code = SubStr(Variable,2,3)
Return
Test22:
SubStr(Variable,2,3)
Return

Test23Setup:
TestName := "String middle command"
Code = StringMid, Temp1, Variable, 2, 3
Return
Test23:
StringMid, Temp1, Variable, 2, 3
Return

Test24Setup:
TestName := "String trim command"
Code = StringTrimLeft, Temp1, Variable, 1
Return
Test24:
StringTrimLeft, Temp1, Variable, 1
Return

Test25Setup:
TestName := "String replace command"
Code = StringReplace, Temp1, Variable, c, c, All
Return
Test25:
StringReplace, Temp1, Variable, c, c, All
Return

Test26Setup:
Category := "String Operations", TestName := "String length function"
Code = StrLen(Variable)
Return
Test26:
StrLen(Variable)
Return

Test27Setup:
TestName := "String length command"
Code = StringLen, Temp1, Variable
Return
Test27:
StringLen, Temp1, Variable
Return

Test28Setup:
TestName := "String split command"
Code = StringSplit, Temp, Variable, c
Return
Test28:
StringSplit, Temp, Variable, c
Return

Test29Setup:
TestName := "Case conversion"
Code = StringUpper, Temp1, Variable
Return
Test29:
StringUpper, Temp1, Variable
Return

Test30Setup:
Iterations := DefaultIterations // 200, Category := "Files", TestName := "File attributes and exists function"
Code = FileExist(A_ScriptFullPath)
Return
Test30:
FileExist(A_ScriptFullPath)
Return

Test31Setup:
TestName := "If file exists"
Code = IfExist, `%A_ScriptFullPath`%`n Return
Return
Test31:
IfExist, %A_ScriptFullPath%
 Return
Return

Test32Setup:
TestName := "Get size"
Code = FileGetSize, Temp1,`%A_ScriptFullPath`%
Return
Test32:
FileGetSize, Temp1,%A_ScriptFullPath%
Return

Test33Setup:
TestName := "Read file"
Code = FileRead, Temp1, *m100 `%A_ScriptFullPath`%
Return
Test33:
FileRead, Temp1, *m100 %A_ScriptFullPath%
Return

Test34Setup:
TestName := "Read file line"
Code = FileReadLine, Temp1, `%A_ScriptFullPath`%, 2
Return
Test34:
FileReadLine, Temp1, %A_ScriptFullPath%, 2
Return

Test35Setup:
TestName := "Append to file"
FileDelete, %A_Temp%\Temp.txt
Code = FileAppend, c, `%A_Temp`%\Temp.txt
Return
Test35:
FileAppend, c, %A_Temp%\Temp.txt
Return

Test36Setup:
TestName := "Copy file"
FileDelete, %A_Temp%\Temp.txt
FileAppend, Lorem ipsum dolor sit amet, %A_Temp%\Temp.txt
Code = FileCopy, `%A_Temp`%\Temp.txt, `%A_Temp`%\Temp1.txt, 1
Return
Test36:
FileCopy, %A_Temp%\Temp.txt, %A_Temp%\Temp1.txt, 1
Return

Test37Setup:
TestName := "Move file"
Code = FileMove, `%A_Temp`%\Temp.txt, `%A_Temp`%\Temp.txt, 1
Return
Test37:
FileMove, %A_Temp%\Temp.txt, %A_Temp%\Temp.txt, 1
Return

Test38Setup:
TestName := "Filesystem loop"
Code = Loop, `%A_ScriptFullPath`%`n Return
Return
Test38:
Loop, %A_ScriptFullPath%
 Return
Return

Test39Setup:
TestName := "File reading loop"
Code = Loop, Read, `%A_ScriptFullPath`%`n Return
Return
Test39:
Loop, Read, %A_ScriptFullPath%
 Return
Return

Test40Setup:
Iterations := DefaultIterations, Category := "Control Flow", TestName := "Normal loop"
Code = Loop, 1`n{`n `n}
Return
Test40:
Loop, 1
{
 
}
Return

Test41Setup:
TestName := "While loop"
Code = While, (A_Index = 1)`n{`n `n}
Return
Test41:
While, (A_Index = 1)
{
 
}
Return

Test42Setup:
TestName := "Parsing loop", Variable := "abcdeg"
Code = Loop, Parse, Variable, `,`n{`n `n}
Return
Test42:
Loop, Parse, Variable, `,
{
 
}
Return

Test43Setup:
TestName := "Blank subroutine call"
Code = Gosub, BlankLabel
Return
Test43:
Gosub, BlankLabel
Return

BlankLabel:
Return

Test44Setup:
TestName := "Blank function call"
Code = BlankFunction()
Return
Test44:
BlankFunction()
Return

BlankFunction()
{
 
}

Test45Setup:
Iterations := DefaultIterations // 2, Category := "Environment Variables", TestName := "Set environment variable"
Code = EnvSet, EnvVar, abcdeg
Return
Test45:
EnvSet, EnvVar, abcdeg
Return

Test46Setup:
TestName := "Get environment variable"
Code = EnvGet, Temp1, EnvVar
Return
Test46:
EnvGet, Temp1, EnvVar
Return

Test47Setup:
Iterations := DefaultIterations // 100, Category := "Keyboard and mouse", TestName := "Get mouse position"
Code = MouseGetPos, Temp1, Temp2
Return
Test47:
MouseGetPos, Temp1, Temp2
Return

Test48Setup:
TestName := "Move mouse"
SetMouseDelay, -1
Code = MouseMove, 0, 0, 0, R
Return
Test48:
MouseMove, 0, 0, 0, R
Return

Test49Setup:
Iterations := DefaultIterations, Category := "Dynamic Variables", TestName := "Dynamic variable access", Variable := "Variable"
Code = `% `%Variable`%
Return
Test49:
% (%Variable%)
Return

Test50Setup:
Iterations := DefaultIterations, Category := "Dynamic Variables", TestName := "Dynamic variable assignment", Variable := "Variable"
Code = `%Variable`% = abcdeg
Return
Test50:
%Variable% = abcdeg
Return

;all different kinds of Send, sent to a non-input control (like a text control)
;onmessage(), registercallback(), dllcall(), numput(), numget(), varsetcapacity(), (misc functions)

GetSystemInfo()
{
    Length := RunToVar(Data,"cmd /c ""SystemInfo /fo CSV""")
    If A_IsUnicode
        StrGetFunc := "StrGet", Data := %StrGetFunc%(&Data,Length,"CP0")
    Else
        VarSetCapacity(Data,-1), Data := SubStr(Data,1,Length)

    StringSplit, Temp, Data, `n
    Fields := "OS Name,OS Version,OS Configuration,OS Build Type,System Manufacturer,System Model,System Type,Processor(s),BIOS Version,Total Physical Memory,Available Physical Memory,Virtual Memory: Max Size,Virtual Memory: Available,Virtual Memory: In Use"
    Loop, Parse, Temp1, CSV
    {
        If A_LoopField In %Fields%
        FieldsPos .= "," . A_Index
    }
    FieldsPos := SubStr(FieldsPos,1,-1), Fields := "," . Fields . ",", Index := 0
    Loop, Parse, Temp2, CSV
    {
        If A_Index In %FieldsPos%
        {
            Index ++
            StringGetPos, Temp1, Fields, `,, % "L" . Index
            Temp1 += 1
            StringGetPos, Temp3, Fields, `,, L1, Temp1
            SystemInfo .= SubStr(Fields,Temp1 + 1,Temp3 - Temp1) . "|" . A_LoopField . "`n"
        }
    }
    Return, SubStr(SystemInfo,1,-1)
}

RunToVar(ByRef Result,CommandLine,WorkingDirectory = "")
{
    If A_PtrSize
        PointerSize := A_PtrSize, UPtr := "UPtr"
    Else
        PointerSize := 4, UPtr := "UInt"

    If (StrLen(CommandLine) > 32000) ;command line too long
        Return, 0

    ;set the security attributes of the pipe
    VarSetCapacity(SecurityAttributes,PointerSize + 8,0)
    NumPut(PointerSize + 8,SecurityAttributes,UPtr)
    NumPut(1,SecurityAttributes,PointerSize + 4,UPtr)

    hRead := 0, hWrite := 0
    If !DllCall("CreatePipe",UPtr . "*",hRead,UPtr . "*",hWrite,UPtr,&SecurityAttributes,"Int",0) ;create the pipe
        Return, 0

    ;create the STARTUPINFO structure
    VarSetCapacity(StartupInfo,(PointerSize * 7) + 40,0), NumPut((PointerSize * 7) + 40,StartupInfo,0,UPtr) ;initialize the structure
    DllCall("GetStartupInfo",UPtr,&StartupInfo) ;obtain process startup information
    NumPut(0x101,StartupInfo,(PointerSize * 3) + 32,UPtr) ;dwFlags: STARTF_USESTDHANDLES | STARTF_USESHOWWINDOW
    NumPut(hWrite,StartupInfo,(PointerSize * 5) + 40,UPtr) ;hStdOutput
    NumPut(hWrite,StartupInfo,(PointerSize * 6) + 40,UPtr) ;hStdError

    pWorkingDirectory := (WorkingDirectory = "") ? 0 : &WorkingDirectory ;obtain a pointer to the working directory string, or a null pointer if a working directory was not specified
    VarSetCapacity(ProcessInformation,(PointerSize << 1) + 8,0) ;initialize the structure
    If !DllCall("CreateProcess",UPtr,0,UPtr,&CommandLine,UPtr,0,UPtr,0,"UInt",1,"UInt",0,UPtr,0,UPtr,pWorkingDirectory,UPtr,&StartupInfo,UPtr,&ProcessInformation) ;create the child process
        Return, 0

    ProcessID := NumGet(ProcessInformation,PointerSize << 1,"UInt") ;obtain the process PID
    DllCall("CloseHandle",UPtr,NumGet(ProcessInformation,0)) ;close the process handle
    DllCall("CloseHandle",UPtr,NumGet(ProcessInformation,PointerSize)) ;close the main thread handle

    Process, WaitClose, %ProcessID% ;wait for the process to close

    ;retrieve the length of the data to be read
    BytesAvailable := 0
    If (DllCall("PeekNamedPipe",UPtr,hRead,UPtr,0,"UInt",0,UPtr,0,"UInt*",BytesAvailable,UPtr,0) && BytesAvailable > 0) ;found data to read
    {
        Result := ""
        VarSetCapacity(Result,BytesAvailable) ;allocate memory to store the result
        If !DllCall("PeekNamedPipe",UPtr,hRead,UPtr,&Result,"UInt",BytesAvailable,UPtr,0,"UInt*",BytesRead,UPtr,0) ;retrieve the data
            BytesAvailable := 0
    }

    DllCall("CloseHandle",UPtr,hRead) ;close the pipe read handle
    DllCall("CloseHandle",UPtr,hWrite) ;close the pipe write handle

    Return, BytesAvailable
}