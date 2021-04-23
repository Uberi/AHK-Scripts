;AHK v1
#NoEnv

MsgBox % GetSystemInfo()

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