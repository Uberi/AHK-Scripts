#SingleInstance, Force
IsCharging := % GetBatt("charge")
CurrentBatt := % GetBatt()
If IsCharging = 1
   Charge = Charging
Else Charge = 
Gui, Add, Progress, x5 y5 w200 vBattCharge, %CurrentBatt%
Gui, Add, Text, x5 y25 w40, 0`%
Gui, Add, Text, x50 y25 w40, 25`%
Gui, Add, Text, x100 y25 w40, 50`%
Gui, Add, Text, x150 y25 w30, 75`%
Gui, Show, w210 , Battery %CurrentBatt%`% %Charge%
SetTimer, Check, 5000
Return
Check:
IsCharging := % GetBatt("charge")
CurrentBatt := % GetBatt()
If IsCharging = 1
   Charge = Charging
Else Charge = 
GuiControl, , BattCharge, %CurrentBatt%
WinSetTitle, Battery, , Battery %CurrentBatt%`% %Charge%
Return

GuiClose:
Gui, Destroy
ExitApp

GetBatt(x="") {
VarSetCapacity(OutVar, 24, 0)
DllCall("GetSystemPowerStatusEx", "Uint", &OutVar, "Uint", 1)
If (x="")
Return NumGet(OutVar,2,"char")
If (x="charge")
Return (NumGet(OutVar,1,"char")&8=8) ? 1 : 0
}