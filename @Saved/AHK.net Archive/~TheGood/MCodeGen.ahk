    /*! Adapted by TheGood
    http://www.autohotkey.com/forum/viewtopic.php?p=364922
    Last updated: August 17th, 2010
    */
    
    ;Check for command-line parameters
    iParamCount = %0%
    If iParamCount {
        
        ;Get last parameter
        sFile := %iParamCount%
        
        optOpt := 1, optWarn := 0, optLang := (SubStr(sFile, -2) = "cpp" ? 2 : 1), optCompiler := 1
        Loop % (iParamCount - 1) {
            sParam := %A_Index%
            
            If (sParam = "-minsize")
                optOpt := 1
            Else If (sParam = "-maxspeed")
                optOpt := 2
            Else If (sParam = "-c")
                optLang := 1
            Else If (sParam = "-cpp")
                optLang := 2
            Else If (sParam = "-notify")
                bNotify := True
            Else If (sParam = "-x86")
                optCompiler := 1
            Else If (sParam = "-x64")
                optCompiler := 2
            Else If (InStr(sParam, "-warn") = 1) And (s := SubStr(sParam, 6)) {
                If s is integer
                    optWarn := s <= 4 ? s : optWarn
            }
        }
        
        ;Check if file exists
        If Not FileExist(sFile) {
            s = The file "%sFile%" does not exist.`nThe program will now exit.
            If Not bNotify
                MsgBox, 0x1010, MCodeGen, %s%
            Else {
                TrayTip, MCodeGen, %s%,, 3
                Sleep, 5000
            }
            ExitApp
        }
    }
    
    ;Check for a Visual Studio installation (and retrieve the highest installation if multiple)
    Loop, HKLM, SOFTWARE\Microsoft\VisualStudio\SxS\VC7, 0
    {   If A_LoopRegName is number
        {   sVS := A_LoopRegName
            Break
        }
    }
    
    If Not sVS Or (sVS < 8) {
        s = You do not have Visual Studio 2005 or more recent installed.`nYou can install the VS C++ Express for free from`nhttp://www.microsoft.com/express/`n`nThe program will now exit.
        If Not bNotify
            MsgBox, 0x1010, MCodeGen, %s%
        Else {
            TrayTip, MCodeGen, %s%,, 3
            Sleep, 5000
        }
        ExitApp
    }
    
    ;Get value
    RegRead, sVS, HKLM, SOFTWARE\Microsoft\VisualStudio\SxS\VC7, %sVS%
    
    ;Make sure vcvarsall.bat exist
    sBAT = %sVS%vcvarsall.bat
    If Not FileExist(sBAT) {
        s = vcvarsall.bat is missing!`nThe program will now exit.
        If Not bNotify
            MsgBox, 0x1010, MCodeGen, %s%
        Else {
            TrayTip, MCodeGen, %s%,, 3
            Sleep, 5000
        }
        ExitApp
    }
    
    ;Check if we're doing command-line or GUI
    If iParamCount
        Goto, Create
    
    SetWorkingDir, %A_Temp%
    FileRead, sCode, code.c
    sCode := sCode ? sCode : "MyFunction() {`n`treturn 42;`n}"
    
    Gui, Font, s10, Courier New
    Gui, Font, s10, Inconsolata
    Gui, Font, s10, Consolas
    Gui, Add, Edit, xm w450 r15 T8 WantTab vtxtCode, %sCode%
    Gui, Font
    
    Gui, Add, Text, Section, Optimization:
    Gui, Add, Radio, voptOpt Checked, Optimize for size
    Gui, Add, Radio,, % "Optimize for speed"
    Gui, Add, Text, ys Section, % "Code language:"
    Gui, Add, Radio, voptLang Checked, C
    Gui, Add, Radio,, C++
    Gui, Add, Text, ys Section, Warnings:
    Gui, Add, Radio, voptWarn Checked, Level 1
    Gui, Add, Radio,, Level 2
    Gui, Add, Radio, ys -0x10000000,
    Gui, Add, Radio,, Level 3
    Gui, Add, Radio,, Level 4
    Gui, Add, Text, ys, Platform/Compiler:
    Gui, Add, Radio, Group Checked voptCompiler, x86
    Gui, Add, Radio,, x64
    Gui, Add, Button, xm w450 gbtnCreate, Create machine code!
    Gui, Show,, MCodeGen
    
    GuiControl, Focus, txtCode
Return

GuiEscape:
GuiClose:
ExitApp

btnCreate:
    Gui, Submit, NoHide
Create:
    
    If iParamCount {
        
        ;Get absolute path
        If DllCall("shlwapi\PathIsRelative" (A_IsUnicode ? "W" : "A"), "uint", &sFile) {
            n := DllCall("GetFullPathName", "uint", &sFile, "uint", 0, "uint", 0, "int", 0)
            VarSetCapacity(sAbs, A_IsUnicode ? n*2 : n)
            DllCall("GetFullPathName", "uint", &sFile, "uint", n, "str", sAbs, "uint*", iName)
            sName := DllCall("MulDiv", "int", iName, "int", 1, "int", 1, "str")
            sFile = %sAbs%
        }
        
        SetWorkingDir, %A_Temp%
    } Else {
        SetWorkingDir, %A_Temp%
        FileDelete, code.c ;Save code to a temporary file
        FileAppend, %txtCode%, code.c
        sFile = code.c
    }
    
    ;Prep the parameters
    sCompiler := optCompiler = 1 ? "x86" : "x86_amd64"
    sParams := (optLang = 1 ? "/TC" : "/TP" ) " /c /FAc /Facode.cod /O" optOpt " /W" optWarn
    
    sCompileBAT =
    ( LTrim
    @echo off
    call "%sBAT%" %sCompiler%
    cl %sParams% "%sFile%"
    echo `%ERRORLEVEL`%
    )
    
    FileDelete, compile.bat
    FileAppend, %sCompileBAT%, compile.bat
    
    FileDelete, out.txt
    RunWait, compile.bat >> out.txt,, Hide
    
    ;Inefficient way of reading the last line (the file is small anyway)
    Loop, Read, out.txt
        iErr = %A_LoopReadLine%
    
    If iErr {
        s = Compiling failed!
        Run, out.txt
        If Not bNotify
            MsgBox, 0x1010, MCodeGen, %s%
        Else {
            TrayTip, MCodeGen, %s%,, 3
            Sleep, 5000
        }
        
        If iParamCount
            ExitApp
        Else Return
    }
    
    ;Read the code listing
    FileRead, sCode, code.cod
    
    ;Extract functions
    sFunc0 := 1, i := 1
    While (i := RegExMatch(sCode, "ms)^[^[:blank:]]+[[:blank:]]PROC[[:blank:]]+.*?ENDP", sFunc%sFunc0%, i)) {
        i += StrLen(sFunc%sFunc0%)
        sFunc0 += 1
    } sFunc0 -= 1
    
    ;Clean the functions
    ;Adapted from Lazslo/jamie
    ;http://www.autohotkey.com/forum/viewtopic.php?p=357209#357209
    Loop % sFunc0 {
        sFunc%A_Index%_Name := SubStr(sFunc%A_Index%, optCompiler = 1 ? 2 : 1, InStr(sFunc%A_Index%, "PROC") - (optCompiler = 1 ? 3 : 2))
        sFunc%A_Index% := RegExReplace(sFunc%A_Index%,"m)^\S.*$") ; wipe out any line that starts in column 1
        sFunc%A_Index% := RegExReplace(sFunc%A_Index%,"m)^[^\t]*\t") ; wipe out anything up to and including the first tab character
        sFunc%A_Index% := RegExReplace(sFunc%A_Index%,"m)\t.*$") ; wipe out the (now) first tab character and everything after it
        sFunc%A_Index% := RegExReplace(sFunc%A_Index%,"m)\s") ; remove all whitespace
        StringUpper, sFunc%A_Index%, sFunc%A_Index%
    }
    
    ;Output functions
    Clipboard =
    Loop % sFunc0 {
        i := sFunc0 - (A_Index - 1)
        Clipboard .= "MCode(" sFunc%i%_Name ", """ sFunc%i% """)`r`n"
    }
    
    s := (iParamCount ? sName : "The code") " has been successfully compiled!`nThe machine code has been placed on the clipboard."
    If Not bNotify {
        MsgBox, 0x44, MCodeGen, %s%`n`nWould you like to see the log?
        IfMsgBox, Yes
            Run, out.txt
    } Else {
        TrayTip, MCodeGen, %s%,, 1
        Sleep, 5000
    }
    
    If iParamCount ;Check if we were called from command-line
        ExitApp
Return
