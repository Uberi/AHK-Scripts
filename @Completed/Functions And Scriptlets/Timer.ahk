;AHK v1
#NoEnv

/*
TimerBefore := StartTimer()
Sleep, 1000
MsgBox % StopTimer(TimerBefore) . " milliseconds have elapsed."
Timer()
Sleep, 1000
MsgBox % Timer() . " milliseconds have elapsed."
*/

/*
;running StartTimer() and StopTimer() with "SetBatchLines, -1" and "Process, Priority,, RealTime" takes about 0.005628 milliseconds on average
;running Timer() with "SetBatchLines, -1" and "Process, Priority,, RealTime" takes about 0.005315 milliseconds on average
;running "Something := 5" takes about 0.005812 milliseconds on average, or 184 nanoseconds (0.000184 milliseconds) more than the control run

Iterations := 100000

SetBatchLines, -1
Process, Priority,, RealTime
Average1 := 0, Average2 := 0
Loop, %Iterations%
{
    Timer := StartTimer()
    Timer := StopTimer(Timer)
    Average1 += Timer

    ;Timer := StartTimer()
    ;Something := 5
    ;Timer := StopTimer(Timer)
    ;Average2 += Timer
}
Average1 /= Iterations, Average2 /= Iterations, Difference := Average2 - Average1

Result := "Control run: " . Average1 . " milliseconds`nBenchmark run: " . Average2 . " milliseconds`nDifference: " . Difference . " milliseconds"
Clipboard := Result
MsgBox, %Result%
*/

Timer()
{
    static TimerBefore := 0
    If TimerBefore = 0
        DllCall("QueryPerformanceCounter","Int64*",TimerBefore)
    Else
    {
        TimerAfter := 0, DllCall("QueryPerformanceCounter","Int64*",TimerAfter)
        TickFrequency := 0, DllCall("QueryPerformanceFrequency","Int64*",TickFrequency)
        TimerAfter := (TimerAfter - TimerBefore) / (TickFrequency / 1000), TimerBefore := 0
        Return, TimerAfter
    }
}

StartTimer()
{
    TimerBefore := 0, DllCall("QueryPerformanceCounter","Int64*",TimerBefore)
    Return, TimerBefore
}

StopTimer(ByRef TimerBefore)
{
    TimerAfter := 0, DllCall("QueryPerformanceCounter","Int64*",TimerAfter)
    TickFrequency := 0, DllCall("QueryPerformanceFrequency","Int64*",TickFrequency)
    Return, (TimerAfter - TimerBefore) / (TickFrequency / 1000)
}