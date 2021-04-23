;AHK v1
#NoEnv

/*
Loop
    ToolTip % CPUUsage()

Esc::ExitApp
*/

CPUUsage(Period = 500)
{
    IdleBefore := 0, DllCall("GetSystemTimes","Int64*",IdleBefore,"UInt",0,"UInt",0) ;retrieve the idle time
    TimerBefore := 0, DllCall("QueryPerformanceCounter","Int64*",TimerBefore) ;retrieve the tick time
    Sleep, %Period% ;wait for a predefined period
    IdleAfter := 0, DllCall("GetSystemTimes","Int64*",IdleAfter,"UInt",0,"UInt",0) ;retrieve the idle time
    TimerAfter := 0, DllCall("QueryPerformanceCounter","Int64*",TimerAfter) ;retrieve the tick time after the wait period

    VarSetCapacity(Temp1,36,0), DllCall("GetNativeSystemInfo",A_PtrSize ? "UPtr" : "UInt",&Temp1)
    CPUCount := NumGet(Temp1,20) ;retrieve the number of processing cores
    TicksPerMillisecond := 0, DllCall("QueryPerformanceFrequency","Int64*",TicksPerMillisecond) ;retrieve the tick frequency
    IdleTime := (IdleAfter - IdleBefore) / (CPUCount * 100) ;calculate the actual idle time
    TickTime := (TimerAfter - TimerBefore) / (TicksPerMillisecond / 1000) ;calculate the tick time
    Usage := 100 - (IdleTime / TickTime) ;calculate the CPU usage from the ratio of the times
    Return, (Usage < 0) ? 0 : Usage ;return the CPU usage, clamped to a range between 0 and 100, inclusive
}