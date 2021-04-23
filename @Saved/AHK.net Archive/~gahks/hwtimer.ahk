;///////////////////////////
;GAHKS' GUI
;v1.0 
;2009-01-10
;http://www.autohotkey.net/~gahks/
;///////////////////////////
;Delete standard menu, set custom menu items
Menu, tray, NoStandard
Menu, tray, add, &Help, MenuHelp
Menu, tray, add, &About, MenuAbout
Menu, tray, add, E&xit, ButtonCancel

;Get current local time, parse it, store lt in variables for the GUI Timer
FormatTime, CDate,, yyyy-M-d-H-m
Loop, parse, CDate, -,
{
	if A_Index = 1
		CYear=%A_LoopField%
	else if A_Index = 2
		CMonth=%A_LoopField%
	else if A_Index = 3
		CDay=%A_LoopField%
	else if A_Index = 4
		CHour=%A_LoopField%
	else
		CMin=%A_Loopfield%
}

;Start GUI
Gui, Add, GroupBox, w330 h120, Timer Settings
Gui, Add, Text, ym+40 xm+10, Year | 
Gui, Add, Text, ym+40 x+5, Month | 
Gui, Add, Text, ym+40 x+5, Day
Gui, Add, Edit, ym+40 xm+150 w65
Gui, Add, UpDown, Wrap 0x80 vGUIYear Range2009-2050, %CYear%
Gui, Add, Edit, ym+40 w35 x+1
Gui, Add, UpDown, Wrap vGUIMonth Range1-12, %CMonth%
Gui, Add, Edit, ym+40 w35 x+1
Gui, Add, UpDown, Wrap vGUIDay Range1-31, %CDay%
Gui, Add, Text, ym+70 xm+10, Hour | 
Gui, Add, Text, ym+70 x+5, Minute
Gui, Add, Edit, ym+70 w35 xm+150
Gui, Add, UpDown, Wrap vGUIHour Range0-23, %CHour%
Gui, Add, Edit, ym+70 w35 x+1
Gui, Add, UpDown, Wrap vGUIMinute Range1-59, %CMin%
Gui, Add, Radio, vGUIHibernate ym+140 xm+10, Hibernate now (Ignore the timer)
Gui, Add, Radio, vGUIStandby ym+170 xm+10, Standby now (Ignore the timer)
Gui, Add, Radio, vGUIResume ym+200 xm+10, Schedule a restoration point from Hibernation/Standby mode
Gui, Add, Radio, vGUIHibernateResume ym+230 xm+10, Hibernate now and schedule a restoration point
Gui, Add, Radio, vGUIStandbyResume ym+260 xm+10, Standby now and schedule a restoration point
Gui, Add, Text, ym+300 xm+10, Select files to run
;File selection
Gui, Add, Edit, vFileToRunEdit1 ym+320 xm+20 w236
Gui, Add, Button, gOpen1 vFileToRun1 ym+320 xm+256 w50, Browse 
GuiControl, Disable, FileToRunEdit1
Gui, Add, Edit, vFileToRunEdit2 ym+350 xm+20 w236
Gui, Add, Button, gOpen2 vFileToRun2 ym+350 xm+256 w50, Browse 
GuiControl, Disable, FileToRunEdit2
Gui, Add, Edit, vFileToRunEdit3 ym+380 xm+20 w236
Gui, Add, Button, gOpen3 vFileToRun3 ym+380 xm+256 w50, Browse 
GuiControl, Disable, FileToRunEdit3
;Buttons
Gui, Add, Button, ym+430 xm+20 w133 Default, OK
Gui, Add, Button, ym+430 x+20 w133, Cancel
;Build menu and show GUI
Menu, FileMenu, Add, E&xit, ButtonCancel
Menu, HelpMenu, Add, &About, MenuAbout
Menu, HelpMenu, Add, &Help, MenuHelp
Menu, MyMenuBar, Add, &File, :FileMenu
Menu, MyMenuBar, Add, &Help, :HelpMenu
Gui, Menu, MyMenuBar
Gui, Show, AutoSize, Hibernation Wake Up Timer
Return

;File selection
Open1:
Gui +OwnDialogs
FileSelectFile, RunAfterResume1, 3,, Selecting a file...
if RunAfterResume1 =  
    return
GuiControl,, FileToRunEdit1, %RunAfterResume1%
Return

Open2:
Gui +OwnDialogs
FileSelectFile, RunAfterResume2, 3,, Selecting a file...
if RunAfterResume2 =  
    return
GuiControl,, FileToRunEdit2, %RunAfterResume2%
Return

Open3:
Gui +OwnDialogs
FileSelectFile, RunAfterResume3, 3,, Selecting a file...
if RunAfterResume3 =  
    return
GuiControl,, FileToRunEdit3, %RunAfterResume3%
Return

;Cancel and X
ButtonCancel:
GuiClose:
ExitApp
Return

;Help menu
MenuHelp:
IfWinExist, Hibernation Wake Up Timer Help
{
WinActivate
}
else
{
Gui +OwnDialogs
Gui, 3:Add, Tab2, w300 h330, Timer|Options||Select files|
Gui, 3:Add, Text,, Timer Settings:
Gui, 3:Add, Text,w270, Year format: YYYY | Month format: m | Day format: d 
Gui, 3:Add, Text,, Time format H (0-23) m (1-59)
Gui, 3:Add, Text,, Eg.
Gui, 3:Add, Text,w270, 11:02 PM - January 09, 2009
Gui, 3:Add, Text,, will be
Gui, 3:Add, Text,, 2009 1 9 - 23 2
Gui, 3:Tab, 2 
Gui, 3:Add, Text,, Wake up timer options:
Gui, 3:Add, Text, w270, Hibernate now (Ignore timer) - Hibernates your PC right away ignoring your file selections and timer settings.
Gui, 3:Add, Text, w270, Standby now (Ignore timer) - Activates the Standby mode right away ignoring your file selections and timer settings.
Gui, 3:Add, Text, w270, Schedule a restoration point... - You can specify a date and time, when your PC will be restored from Hibernated/Standby state automatically and three files to run right after your PC is restored.
Gui, 3:Add, Text, w270, Hibernate now and schedule... - Hibernates your PC right away restores it at the specified time, and runs the specified files.
Gui, 3:Add, Text, w270, Standby now and schedule... - Activates Standby mode right away restores your PC from Standby mode at the specified time, and runs the specified files.
Gui, 3:Add, Text,,
Gui, 3:Tab, 3
Gui, 3:Add, Text,, Select files:
Gui, 3:Add, Text, w270, You can specify three files to run after your PC is restored from Hibernated/Standby state.
Gui, 3:Show, AutoSize, Hibernation Wake Up Timer Help
Return

3GUIClose:
Gui, 3:Destroy
Return
}
Return

;About menu
MenuAbout:
IfWinExist, About Hibernation Wake Up Timer
{
WinActivate
}
else
{
Gui, 2:Add, Text, w270, A simple GUI for Bosknop's Wake-up-timer/scheduler 
Gui, 2:Add, Text, w270, Wake up timer created by Bosknop
Gui, 2:Add, Text, w270, GUI created by gahks
Gui, 2:Add, Text, w270 xm cBlue g2LaunchWebsitegui, http://www.autohotkey.net/~gahks/
Gui, 2:Add, Text, w270, Wake-up-timer's website: 
Gui, 2:Add, Text, w270 xm cBlue g2LaunchWebsite, http://www.autohotkey.com/forum/topic11620.html
Gui, 2:Add, Button, y+20 w100, Close
Gui, 2:Show, AutoSize, About Hibernation Wake Up Timer
Return

2LaunchWebsitegui:
Run http://www.autohotkey.net/~gahks/
Return

2LaunchWebsite:
Run http://www.autohotkey.com/forum/topic11620.html
Return

2ButtonClose:
Gui, 2:Destroy
Return
}
Return

;OK Button
ButtonOK:
Gui, Submit

;End of GUI
;Setting variables, executing Bosknop's code
Year=%GUIYear%
Month=%GUIMonth%   ;1-12
Day=%GUIDay%      ;1-31
Hour=%GUIHour%   ;0-23
Minute=%GUIMinute% ;1-59

if GUIHibernate = 1
{
Resume=1
Hibernate=0
} 
else if GUIStandby = 1
{
Resume=0
Hibernate=1
}
else if GUIResume = 1
{
Resume=0
Hibernate=2
}
else if GUIHibernateResume = 1
{
Resume=1
Hibernate=1
}
else
{
Resume=1
Hibernate=2
}

Name=%A_Now%

;Last question
if (GUIResume = 1 or GUIHibernateResume = 1 or GUIStandbyResume = 1)
{
    MsgBox,,Timer settings, Your timer settings are: %Year%.%Month%.%Day% %Hour%:%Minute% (yyyy.m.d H:m) 
}
MsgBox, 4,Wake-up-timer GUI, Do you really want to continue? (Press YES or NO)
IfMsgBox No
    ExitApp
IfMsgBox Yes

;///////////////////////////
;BOSKNOP's CODE
;http://www.autohotkey.com/forum/topic11620.html
;///////////////////////////
; AUTOEXECUTE
WakeUp(Year, Month, Day, Hour, Minute, Hibernate, Resume, Name)

if RunAfterResume1 <>
Run, %RunAfterResume1%

if RunAfterResume2 <>
Run, %RunAfterResume2%

if RunAfterResume3 <>
Run, %RunAfterResume3%

ExitApp

; FUNCTIONS
WakeUp(Year, Month, Day, Hour, Minute, Hibernate, Resume, Name)
;Awaits duetime, then returns to the caller (like some sort of "sleep until duetime").
;If the computer is in hibernate or suspend mode
;at duetime, it will be reactivated (hardware support provided)
;Parameters: Year, Month, Day, Hour, Minute together produce duetime
;Hibernate: If Hibernate=1, the function hibernates the computer. If Hibernate=2 the computer is set to
;         suspend-mode
;Resume: If Resume=1, the system is restored from power save mode at due time
;Name: Arbitrary name for the timer
{
    duetime:=GetUTCFileTime(Year, Month, Day, Hour, Minute)

    Handle:=DLLCall("CreateWaitableTimer"
            ,"char *", 0
            ,"Int",0
            ,"Str",name, "UInt")

    DLLCall("CancelWaitableTimer","UInt",handle)

    DLLCall("SetWaitableTimer"
          ,"Uint", handle
          ,"Int64*", duetime        ;duetime must be in UTC-file-time format!
          ,"Int", 1000
          ,"uint",0
          ,"uint",0
          ,"int",resume)
   

    ;Hibernates the computer, depending on variable "Hibernate":
    If Hibernate=1       ;Hibernate
        {
        DllCall("PowrProf\SetSuspendState", "int", 1, "int", 0, "int", 0)
        }
       
    If Hibernate=2      ;Suspend
       {
       DllCall("PowrProf\SetSuspendState", "int", 0, "int", 0, "int", 0)
       }
    Signal:=DLLCall("WaitForSingleObject"
            ,"Uint", handle
            ,"Uint",-1)
           
    DllCall("CloseHandle", uint, Handle)   ;Closes the handle
   
}   


GetUTCFiletime(Year, Month, Day, Hour, Min)
;Converts "System Time" (readable time format) to "UTC File Time" (number of 100-nanosecond intervals since January 1, 1601 in  Coordinated Universal Time UTC)
{
    DayOfWeek=0

    Second=00
    Millisecond=00
   

    ;Converts System Time to Local File Time:
    VarSetCapacity(MyFiletime  , 64, 0)
    VarSetCapacity(MySystemtime, 32, 0)
   
    InsertInteger(Year,       MySystemtime,0)
    InsertInteger(Month,      MySystemtime,2)
    InsertInteger(DayOfWeek,  MySystemtime,4)
    InsertInteger(Day,        MySystemtime,6)
    InsertInteger(Hour,       MySystemtime,8)
    InsertInteger(Min,        MySystemtime,10)
    InsertInteger(Second,     MySystemtime,12)
    InsertInteger(Millisecond,MySystemtime,14)

    DllCall("SystemTimeToFileTime", Str, MySystemtime, UInt, &MyFiletime)
    LocalFiletime := ExtractInteger(MyFiletime, 0, false, 8)

    ;Converts local file time to a file time based on the Coordinated Universal Time (UTC):
    VarSetCapacity(MyUTCFiletime  , 64, 0)
    DllCall("LocalFileTimeToFileTime", Str, MyFiletime, UInt, &MyUTCFiletime)
    UTCFiletime := ExtractInteger(MyUTCFiletime, 0, false, 8)
   
    Return UTCFileTime
}


ExtractInteger(ByRef pSource, pOffset = 0, pIsSigned = false, pSize = 32)
; Documented in Autohotkey Help
{
    Loop %pSize% 
        result += *(&pSource + pOffset + A_Index-1) << 8*(A_Index-1)
    if (!pIsSigned OR pSize > 4 OR result < 0x80000000)
        return result 
    return -(0xFFFFFFFF - result + 1)
}



InsertInteger(pInteger, ByRef pDest, pOffset = 0, pSize = 4)
; Documentated in Autohotkey Help
{
  Loop %pSize%
          DllCall("RtlFillMemory", UInt, &pDest + pOffset + A_Index-1
                  , UInt, 1, UChar, pInteger >> 8*(A_Index-1) & 0xFF)
}

Return