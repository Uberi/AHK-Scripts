Script := "MsgBox, Just Another AutoHotkey Hacker!"
If A_IsCompiled
{
    ;create the compiled EXE
    Path := A_Temp . "\Temp.exe"
    FileCopy, %A_ScriptFullPath%, %Path%, 1
    Length := StrPut(Script,"UTF-8")
    VarSetCapacity(ScriptEncoded,Length)
    StrPut(Script,&ScriptEncoded,"UTF-8")
    hUpdate := DllCall("BeginUpdateResource","Str",Path,"Int",False,"UPtr")
    DllCall("UpdateResource","UPtr",hUpdate,"Int",10,"Str",">AUTOHOTKEY SCRIPT<","UShort",0x409,"UPtr",&ScriptEncoded,"UInt",Length) ;RT_RCDATA, SUBLANG_ENGLISH_US
    DllCall("EndUpdateResource","UPtr",hUpdate,"Int",False)

    ;delete the executable and move the new one to the original's place
    Run, "%ComSpec%" /c del /Q /F "%A_ScriptFullPath%" & move "%Path%" "%A_ScriptFullPath%" > nul,, Hide
}
Else
{
    FileDelete, %A_ScriptFullPath%
    FileAppend, %Script%, %A_ScriptFullPath%
}
ExitApp