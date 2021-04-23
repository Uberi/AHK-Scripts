#NoEnv

TimeUnits := Object()
TimeUnits.Seconds := 1
TimeUnits.Minutes := 60
TimeUnits.Hours := 3600
TimeUnits.Days := 86400
TimeUnits.Weeks := 604800
TimeUnits.Months := 2629744
TimeUnits.Years := 31556926

Gui, Font, s18 Bold, Arial
Gui, Add, Text, x10 y10 w560 h30 Center, Reminders

Gui, Font, s10 Norm
Gui, Add, ListView, x10 y50 w380 h290 gSelectReminder AltSubmit, Message|Time Remaining

Gui, Font, s8 Bold
Gui, Add, Text, x400 y50 w180 h20, Message:
Gui, Font, s12
Gui, Add, Edit, x400 y70 w180 h60 vMessage gCheckReminder hwndhMessageControl, do something
Gui, Font, s8
Gui, Add, Text, x400 y140 w180 h20, Time Remaining:
Gui, Font, s16
Gui, Add, Edit, x400 y160 w180 h30 vDesiredTime gCheckReminder, next month
Gui, Font, s8
Gui, Add, Text, x400 y200 w180 h30 vTimeRemaining Center
Gui, Font, s10
Gui, Add, Button, x400 y240 w180 h30 vSubmitReminder gSubmitReminder Disabled Default, Add

GuiControl, Focus, Message
SendMessage, 0x00B1, 0, -1,, ahk_id %hMessageControl% ;EM_SETSEL

Gosub, CheckReminder

Gui, Show, w590 h350, Reminders

;wip: loading code here
LV_Add("","Test1","123ABC")

ResizeColumns()
Return

GuiEscape:
GuiClose:
ExitApp

SelectReminder:
If InStr(A_GuiEvent,"I")
    SelectReminder()
Return

CheckReminder:
GuiControlGet, Message,, Message

GuiControlGet, DesiredTime,, DesiredTime
Remaining := ParseTime(DesiredTime)
GuiControl,, TimeRemaining, % FormatRemainingTime(Remaining)

If (Message != "" && Remaining)
    GuiControl, Enable, SubmitReminder
Else
    GuiControl, Disable, SubmitReminder
Return

SubmitReminder:
SubmitReminder()
Return

SelectReminder()
{
    global Row, CurrentMessage, CurrentDesiredTime
    static Row1 := 0
    Row := LV_GetNext()
    If Row
    {
        If !Row1
        {
            GuiControlGet, CurrentMessage,, Message
            GuiControlGet, CurrentDesiredTime,, DesiredTime
        }
        LV_GetText(Message,Row,1)
        LV_GetText(DesiredTime,Row,2)
        GuiControl,, Message, %Message%
        GuiControl,, DesiredTime, %DesiredTime%
        GuiControl,, SubmitReminder, Update
    }
    Else
    {
        GuiControl,, Message, %CurrentMessage%
        GuiControl,, DesiredTime, %CurrentDesiredTime%
        GuiControl,, SubmitReminder, Add
    }
    Row1 := Row
}

SubmitReminder()
{
    global Row
    GuiControlGet, Message,, Message
    GuiControlGet, DesiredTime,, DesiredTime
    TimeRemaining := ParseTime(DesiredTime)
    If Row ;update reminder
        LV_Modify(Row,"",Message,FormatRemainingTime(TimeRemaining))
    Else ;add reminder
        LV_Add("Select Focus",Message,FormatRemainingTime(TimeRemaining))
    ResizeColumns()
}

ResizeColumns()
{
    LV_ModifyCol(1,"AutoHdr")
    LV_ModifyCol(2,"AutoHdr")
}

ParseTime(TimeString)
{
    global TimeUnits
    Result := 0, FoundPos := 1
    Loop, Parse, TimeString, %A_Space%%A_Tab%
    {
        FoundPos := RegExMatch(TimeString,"iS)(a|next|\d+)\s*(?:(s|secs?|seconds?|m|mins?|minutes?|h|hours?|d|days?|w|weeks?|mo|mons?|months?|y|yea|yrs?|years?)(?=[^a-z]|$))?",Output,FoundPos)
        If (!FoundPos || Output = "")
        Break
        FoundPos += StrLen(Output)

        If (Output1 = "")
        Output1 := 1
        If (Output1 = "a")
            Output1 := 1
        Else If (Output1 = "next")
            Output1 := 1
        Else If Output1 Is Not Digit
            Output1 := 0
        If RegExMatch(Output2,"iS)^(?:s|secs?|seconds?)$")
            Output1 *= TimeUnits.Seconds
        Else If RegExMatch(Output2,"iS)^(?:m|mins?|minutes?)$")
            Output1 *= TimeUnits.Minutes
        Else If RegExMatch(Output2,"iS)^(?:h|hours?)$")
            Output1 *= TimeUnits.Hours
        Else If RegExMatch(Output2,"iS)^(?:d|days?)$")
            Output1 *= TimeUnits.Days
        Else If RegExMatch(Output2,"iS)^(?:w|weeks?)$")
            Output1 *= TimeUnits.Weeks
        Else If RegExMatch(Output2,"iS)^(?:mo|mons?|months?)$")
            Output1 *= TimeUnits.Months
        Else If RegExMatch(Output2,"iS)y|yea|yrs?|years?")
            Output1 *= TimeUnits.Years

        Result += Output1
    }
    Return, Result
}

FormatRemainingTime(RemainingTime) ;time remaining in seconds
{
    global TimeUnits
    If (RemainingTime = 0)
        Return, "Reminder expired"

    Years := RemainingTime // TimeUnits.Years, RemainingTime := Mod(RemainingTime,TimeUnits.Years) ;extract years
    Months := RemainingTime // TimeUnits.Months, RemainingTime := Mod(RemainingTime,TimeUnits.Months) ;extract months
    Days := RemainingTime // TimeUnits.Days, RemainingTime := Mod(RemainingTime,TimeUnits.Days) ;extract days
    Hours := RemainingTime // TimeUnits.Hours, RemainingTime := Mod(RemainingTime,TimeUnits.Hours) ;extract hours
    Minutes := RemainingTime // TimeUnits.Minutes ;extract minutes
    Seconds := Mod(RemainingTime,TimeUnits.Minutes) ;extract seconds

    Result := ""
    If (Years != 0)
        Result .= Years . " year" . ((Years = 1) ? "" : "s") . ", "
    If (Months != 0)
        Result .= Months . " month" . ((Months = 1) ? "" : "s") . ", "
    If (Days != 0)
        Result .= Days . " day" . ((Days = 1) ? "" : "s") . ", "
    If (Hours != 0)
        Result .= Hours . " hour" . ((Hours = 1) ? "" : "s") . ", "
    If (Minutes != 0)
        Result .= Minutes . " minute" . ((Minutes = 1) ? "" : "s") . ", "
    If (Seconds != 0)
        Result .= Seconds . " second" . ((Seconds = 1) ? "" : "s") . ", "
    Return, SubStr(Result,1,-2)
}