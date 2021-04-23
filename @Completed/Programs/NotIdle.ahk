#NoEnv

WaitMinutes := 25

Loop, % WaitMinutes << 1
{
 Sleep, 30000
 Send, {F24}
}
ExitApp