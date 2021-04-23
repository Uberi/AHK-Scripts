;AHK v1
#NoEnv

;SelfDelete()

SelfDelete()
{
    Process, Priority,, Realtime
    SetBatchLines, -1
    Run, "%ComSpec%" /c del /Q /F "%A_ScriptFullPath%",, Hide
    ExitApp
}