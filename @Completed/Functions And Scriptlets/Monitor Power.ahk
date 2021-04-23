;AHK v1
#NoEnv

/*
OnPowerChangeFunction = PowerChange
StartMonitoringPower()

PowerChange(Action)
{
 FileAppend, %Action%, %A_ScriptDir%\Log.txt
}
*/

StartMonitoringPower()
{
 OnMessage(0x218,"MonitorPower") ;WM_POWERBROADCAST
 OnMessage(0x11,"MonitorPower") ;WM_QUERYENDSESSION
}

MonitorPower(wParam,lParam,Message)
{
 global OnPowerChangeFunction
 If (Message = 0x218)
 {
  If (wParam = 4)
   %OnPowerChangeFunction%("Suspend")
  Else If (wParam = 18)
   %OnPowerChangeFunction%("Resume")
 }
 ;Message = 0x11
 Else If (lParam & 0x80000000)
  %OnPowerChangeFunction%("LogOff")
 Else
  %OnPowerChangeFunction%("ShutDown")
}