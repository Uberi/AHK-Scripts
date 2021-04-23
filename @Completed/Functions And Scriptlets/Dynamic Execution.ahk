;AHK AHK_L
#NoEnv

/*
Gui, Font, s14 Bold, Arial
Gui, Add, Text, x0 y0 h30 Center vTitle, Code:
Gui, Font, s10 Norm, Courier New
Gui, Add, Edit, x10 y30 vScript Multi, MsgBox, Hello`, World!
Gui, Font, Bold, Arial
Gui, Add, Button, x10 h30 vExecute gExecute Default, Execute
Gui, +Resize +MinSize300x200
Gui, Show, w400 h270, Dynamic Execution
Return

GuiEscape:
GuiClose:
ExitApp

GuiSize:
GuiControl, Move, Title, w%A_GuiWidth%
GuiControl, Move, Script, % "w" . (A_GuiWidth - 20) . " h" . (A_GuiHeight - 70)
GuiControl, Move, Execute, % "y" . (A_GuiHeight - 40) . " w" . (A_GuiWidth - 20)
WinSet, Redraw
Return

Execute:
Gui, Submit, NoHide
Execute(Script)
Return
*/

Execute(Script,Parameters = "")
{
    ;create named pipes to hold the script code
    PipeName := "\\.\pipe\AHK_Script_" . A_ScriptHwnd . "_" . A_TickCount ;create a globally unique pipe name
    hTempPipe := DllCall("CreateNamedPipe","Str",PipeName,"UInt",2,"UInt",0,"UInt",255,"UInt",0,"UInt",0,"UInt",0,"UInt",0) ;temporary pipe
    If hTempPipe = -1
        throw Exception("Could not create temporary named pipe.")
    hExecutablePipe := DllCall("CreateNamedPipe","Str",PipeName,"UInt",2,"UInt",0,"UInt",255,"UInt",0,"UInt",0,"UInt",0,"UInt",0) ;executable pipe
    If hExecutablePipe = -1
        throw Exception("Could not create executable named pipe.")

    ;start the script
    CodePage := A_IsUnicode ? 1200 : 65001 ;UTF-16 or UTF-8
    Run, % """" . A_AhkPath . """ /CP" . CodePage . " """ . PipeName . """ " . Parameters,, UseErrorLevel, ScriptPID
    If ErrorLevel
    {
        DllCall("CloseHandle","UPtr",hTempPipe) ;close the temporary pipe
        DllCall("CloseHandle","UPtr",hExecutablePipe) ;close the executable pipe
        throw Exception("Could not run script.")
    }

    ;wait for the script to connect to the temporary pipe and close it
    DllCall("ConnectNamedPipe","UPtr",hTempPipe,"UPtr",0)
    DllCall("CloseHandle","UPtr",hTempPipe)

    ;wait for the script to connect the executable pipe and transfer the code
    DllCall("ConnectNamedPipe","UPtr",hExecutablePipe,"UPtr",0)
    DllCall("WriteFile","UPtr",hExecutablePipe,"Str",Script,"UInt",StrLen(Script) << !!A_IsUnicode,"UPtr",0,"UPtr",0)
    DllCall("CloseHandle","UPtr",hExecutablePipe)

    Return, ScriptPID
}

/* ;longer version that waits for the script to close and returns any text in stdout
Execute(Script,Parameters = "")
{
    ;create named pipes to hold the script code
    PipeName := "\\.\pipe\AHK_Script_" . A_ScriptHwnd . "_" . A_TickCount ;create a globally unique pipe name
    hTempPipe := DllCall("CreateNamedPipe","Str",PipeName,"UInt",2,"UInt",0,"UInt",255,"UInt",0,"UInt",0,"UInt",0,"UInt",0) ;temporary pipe
    If hTempPipe = -1
        throw Exception("Could not create temporary named pipe.")
    hExecutablePipe := DllCall("CreateNamedPipe","Str",PipeName,"UInt",2,"UInt",0,"UInt",255,"UInt",0,"UInt",0,"UInt",0,"UInt",0) ;executable pipe
    If hExecutablePipe = -1
        throw Exception("Could not create executable named pipe.")

    ;start the script
    CodePage := A_IsUnicode ? 1200 : 65001 ;UTF-16 or UTF-8
    CommandLine := """" . A_AhkPath . """ /CP" . CodePage . " """ . PipeName . """ " . Parameters,, UseErrorLevel, WorkerPID

    ;set the security attributes of the pipe
    VarSetCapacity(SecurityAttributes,A_PtrSize + 8,0)
    NumPut(A_PtrSize + 8,SecurityAttributes,"UPtr")
    NumPut(1,SecurityAttributes,A_PtrSize + 4,"UPtr")

    hRead := 0, hWrite := 0
    If !DllCall("CreatePipe","UPtr" . "*",hRead,"UPtr" . "*",hWrite,"UPtr",&SecurityAttributes,"Int",0) ;create the pipe
        Return, 0

    ;create the STARTUPINFO structure
    VarSetCapacity(StartupInfo,(A_PtrSize * 7) + 40,0), NumPut((A_PtrSize * 7) + 40,StartupInfo,0,"UPtr") ;initialize the structure
    DllCall("GetStartupInfo","UPtr",&StartupInfo) ;obtain process startup information
    NumPut(0x101,StartupInfo,(A_PtrSize * 3) + 32,"UPtr") ;dwFlags: STARTF_USESTDHANDLES | STARTF_USESHOWWINDOW
    NumPut(hWrite,StartupInfo,(A_PtrSize * 5) + 40,"UPtr") ;hStdOutput
    NumPut(hWrite,StartupInfo,(A_PtrSize * 6) + 40,"UPtr") ;hStdError

    VarSetCapacity(ProcessInformation,(A_PtrSize << 1) + 8,0) ;initialize the structure
    If !DllCall("CreateProcess","UPtr",0,"UPtr",&CommandLine,"UPtr",0,"UPtr",0,"UInt",1,"UInt",0,"UPtr",0,"UPtr",0,"UPtr",&StartupInfo,"UPtr",&ProcessInformation) ;create the child process
    {
        DllCall("CloseHandle","UPtr",hTempPipe) ;close the temporary pipe
        DllCall("CloseHandle","UPtr",hExecutablePipe) ;close the executable pipe
        throw Exception("Could not run script.")
    }

    ;wait for the script to connect to the temporary pipe and close it
    DllCall("ConnectNamedPipe","UPtr",hTempPipe,"UPtr",0)
    DllCall("CloseHandle","UPtr",hTempPipe)

    ;wait for the script to connect the executable pipe and transfer the code
    DllCall("ConnectNamedPipe","UPtr",hExecutablePipe,"UPtr",0)
    DllCall("WriteFile","UPtr",hExecutablePipe,"Str",Script,"UInt",StrLen(Script) << !!A_IsUnicode,"UPtr",0,"UPtr",0)
    DllCall("CloseHandle","UPtr",hExecutablePipe)

    ProcessID := NumGet(ProcessInformation,A_PtrSize << 1,"UInt") ;obtain the process PID
    DllCall("CloseHandle","UPtr",NumGet(ProcessInformation,0)) ;close the process handle
    DllCall("CloseHandle","UPtr",NumGet(ProcessInformation,A_PtrSize)) ;close the main thread handle

    Process, WaitClose, %ProcessID% ;wait for the process to close

    ;retrieve the length of the data to be read
    BytesAvailable := 0
    If DllCall("PeekNamedPipe","UPtr",hRead,"UPtr",0,"UInt",0,"UPtr",0,"UInt*",BytesAvailable,"UPtr",0) && BytesAvailable > 0 ;found data to read
    {
        VarSetCapacity(Result,BytesAvailable) ;allocate memory to store the result
        DllCall("PeekNamedPipe","UPtr",hRead,"UPtr",&Result,"UInt",BytesAvailable,"UPtr",0,"UInt*",BytesRead,"UPtr",0) ;retrieve the data
        Result := StrGet(&Result,BytesRead,"CP0")
    }
    Else
        Result := ""

    DllCall("CloseHandle","UPtr",hRead) ;close the pipe read handle
    DllCall("CloseHandle","UPtr",hWrite) ;close the pipe write handle

    Return, Result
}