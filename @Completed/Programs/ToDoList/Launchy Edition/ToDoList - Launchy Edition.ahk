#NoEnv

#SingleInstance Force

IniRead, ToDoListPath, %A_ScriptDir%\Settings.ini, Settings, PathToToDoList, %A_ScriptDir%\ToDoList.txt
IniRead, MainHotkey, %A_ScriptDir%\Settings.ini, Settings, ShowRemindersHotkey, F2
IniRead, ReminderInterval, %A_ScriptDir%\Settings.ini, Settings, ReminderIntervalInMinutes, 15

IfNotExist, %A_ScriptDir%\Settings.ini
 FileAppend, [Settings]`nPathToToDoList=C:\Users\Anthony\Scripts\@Completed\ToDoList\ToDoList.txt`nShowRemindersHotkey=F2`nReminderIntervalInMinutes=15, %A_ScriptDir%\Settings.ini
IfNotExist, %ToDoListPath%
{
 FormatTime, Temp1,, yyyy/MM/dd HH:mm:ss
 FileAppend, %Temp1%%A_Tab%Done%A_Tab%Unknown%A_Tab%Do Stuff, %ToDoListPath%
}

If %1%
{
 FormatTime, Temp1,, yyyy/MM/dd HH:mm:ss
 If Not %2%
 {
  InputBox, 2, Time Needed, How much time will this task need?,,,,,,,, Unknown
  If ErrorLevel
   2 = Unknown
 }
 If %2% = Unknown
  FileAppend, `n%Temp1%%A_Tab%Pending%A_Tab%Unknown%A_Tab%%1%, %ToDoListPath%
 Else
  FileAppend, `n%Temp1%%A_Tab%Pending%A_Tab%%2% Minutes%A_Tab%%1%, %ToDoListPath%
}
MsgBox, 64, COPYRIGHT NOTICE, This program is copyrighted by The Technical Difficulty`, 2010`n`nDeveloper: Anthony`nInspired by: Justin

Hotkey, %MainHotkey%, Main
Gosub, Startup
Temp1 := ReminderInterval * 60000
SetTimer, Main, %Temp1%
Return

Main:
Gui, 1:Show
Return

Startup:
Gui, 1:+LastFound
Gui, 1:Default
Gui, 1:Font, S8 CDefault, Arial
Gui, 1:Add, ListView, x2 y0 w500 h200 gSelected vToDoList AltSubmit -Multi Sort, Date Added|Status|Time Needed|Task

Gui, 1:Add, GroupBox, x2 y200 w100 h120, Tasks
Gui, 1:Add, Button, x12 y220 w80 h30, New
Gui, 1:Add, Button, x12 y250 w80 h30, Delete
Gui, 1:Add, DropDownList, x12 y290 w80 h30 R3 vTaskStatus gEditStatus, Pending|In Progress|Done

Gui, 1:Add, GroupBox, x112 y200 w390 h120, Info
Gui, 1:Add, Text, x122 y220 w70 h20, Date Added:
Gui, 1:Add, Edit, x192 y220 w190 h20 +ReadOnly vDateAdded

Gui, 1:Add, Text, x392 y220 w40 h20, Status:
Gui, 1:Add, Progress, x432 y220 w60 h20 BackgroundWhite vTaskCol
Gui, 1:Add, Text, x432 y220 w60 h20 +BackgroundTrans +Center vStatus

Gui, 1:Add, Text, x122 y250 w40 h20, Task:
Gui, 1:Add, Edit, x162 y250 w330 h20 +ReadOnly vTask
Gui, 1:Add, Button, x122 y280 w370 h30 Default Disabled, Suggest a task for me to do

LV_ModifyCol(1,115)
LV_ModifyCol(1,"Sort Logical")
LV_ModifyCol(2,70)
LV_ModifyCol(3,75)
LV_ModifyCol(4,235)

Gui, 1:Show, w505 h325 Hide, To-Do List (COPYRIGHT 2010`, The Technical Difficulty)
LoadList()
Gosub, ViewList
Return

Gui, 2:Font, S18 CDefault Bold, Arial
Gui, 2:Add, Button, x2 y0 w690 h70 +Default gButtonSuggestATaskForMeToDo, I have some free time right now. Give me something to do.
Gui, 2:Add, Button, x2 y70 w690 h70 gButtonNew, I need to add a new item to my to-do list.
Gui, 2:Add, Button, x2 y140 w690 h70 gViewList, I want to view my to-do list.
Gui, 2:Show, w695 h210 Hide, To-Do
Return

2GuiEscape:
2GuiClose:
Gui, 2:Hide
Return

ViewList:
Gui, 2:Hide
Gui, 1:-Disabled
Gui, 1:Default
Gui, 1:Show
GuiControl, 1:Focus, ToDoList
LV_Modify(1,"Focus Select")
LV_ModifyCol(2,"SortDesc")
Return

ButtonNew:
{
Gui, 1:Hide
Gui, 2:Hide
Gui, 1:+Disabled
Gui, 2:+Disabled
Gui, 3:-Disabled
Gui, 3:+Owner1
Gui, 3:Font, S18 CDefault Bold, Arial
Gui, 3:Add, Text, x2 y0 w110 h30, I need to
Gui, 3:Add, Edit, x112 y0 w270 h30 vNewTask
Gui, 3:Add, Text, x382 y0 w10 h30, `,
Gui, 3:Add, Text, x2 y30 w220 h30, which will take me
Gui, 3:Add, Edit, x222 y30 w50 h30
Gui, 3:Add, UpDown, Range0-60 vTimeNeeded, 15
Gui, 3:Add, DropDownList, x272 y30 w120 h30 +R6 vTimeUnit, seconds||minutes|hours|days|months|years
Gui, 3:Add, Button, x2 y70 w390 h40 gAddTask +Default, Add Task
Gui, 3:Show, w395 h110, New Task
}
Return

AddTask:
{
Gui, 3:Submit
Gui, 1:-Disabled
Gui, 2:-Disabled
Gui, 3:Destroy
Gui, 1:Default
If TimeNeeded = 0
 TimeNeeded = Unknown
Else
 TimeNeeded .= " " . TimeUnit
FormatTime, Temp1,, yyyy/MM/dd HH:mm:ss
StringReplace, NewTask, NewTask, %A_Tab%, %A_Space%, All
LV_Add("Focus Select Vis",Temp1,"Pending",TimeNeeded,NewTask)
Gui, 1:Show
GuiControl, 1:Focus, ToDoList
SaveList()
}
Return

ButtonDelete:
{
Temp1 := LV_GetNext()
LV_Delete(Temp1)
If Not LV_GetCount()
{
 GuiControl, 1:, DateAdded, N/A
 GuiControl, 1:, Status, N/A
 GuiControl, 1:+BackgroundWhite, TaskCol
 GuiControl, 1:, Task, N/A
 Return
}
If Not LV_Modify(Temp1,"Focus Select")
 LV_Modify(Temp1 - 1,"Focus Select")
GuiControl, 1:Focus, ToDoList
SaveList()
}
Return

EditStatus:
{
GuiControlGet, TaskStatus, 1:, TaskStatus
LV_GetText(Temp1,LV_GetNext())
If Temp1 <> TaskStatus
 LV_Modify(LV_GetNext(),"Focus Select Col2",TaskStatus)
Gosub, ShowInfo
GuiControl, 1:Focus, ToDoList
SaveList()
}
Return

ButtonSuggestATaskForMeToDo:
{
Gui, 1:Hide
Gui, 2:Hide
Gui, 1:+Disabled
Gui, 2:+Disabled
Gui, 3:-Disabled
Gui, 3:+Owner1
Gui, 3:Font, S18 CDefault Bold, Arial
Gui, 3:Add, Text, x2 y10 w80 h30 , I have
Gui, 3:Add, Edit, x82 y10 w50 h30
Gui, 3:Add, UpDown, Range0-60 vFreeTime, 15
Gui, 3:Add, DropDownList, x132 y10 w120 h30 +R6 vTimeUnit, seconds||minutes|hours|days|months|years
Gui, 3:Add, Text, x252 y10 w140 h30, of free time.
Gui, 3:Add, Button, x2 y50 w390 h40 gSuggest +Default, Suggest a task for me
Gui, 3:Show, w395 h90, Task Suggestion
}
Return

3GuiClose:
{
Gui, 1:-Disabled
Gui, 2:-Disabled
Gui, 3:Destroy
Gui, 1:+LastFound
Gui, 1:Default
Gui, 1:Show
GuiControl, 1:Focus, ToDoList
}
Return

Suggest:
{
Gui, 3:Submit
Gui, 1:-Disabled
Gui, 2:-Disabled
Gui, 3:Destroy
Gui, 1:Default
Loop, % LV_GetCount()
{
 LV_GetText(Temp1,A_Index,3)
 If ((SubStr(Temp1,1,InStr(Temp1," ") - 1) <= FreeTime) && SubStr(Temp1,1 - (StrLen(Temp1) - InStr(Temp1," "))) = TimeUnit)
 {
  LV_GetText(Temp1,A_Index,4)
  StringReplace, Temp1, Temp1, `r,, All
  TaskList .= "|" . Temp1
 }
}
If Not TaskList
{
 MsgBox, 36, Tasks, No tasks can be completed within %FreeTime% %TimeUnit%.`n`nView tasks that take unknown amounts of time?
 IfMsgBox, Yes
 {
  Loop, % LV_GetCount()
  {
   LV_GetText(Temp1,A_Index,3)
   StringReplace, Temp1, Temp1, `r,, All
   If Temp1 = Unknown
   {
    LV_GetText(Temp1,A_Index,4)
    TaskList .= "|" . Temp1
   }
  }
  If Not TaskList
  {
   MsgBox, 64, Task Suggestion, No tasks that require an unknown amount of time were found.
   Gui, Show
   Return
  }
  StringReplace, TaskList, TaskList, |, |, UseErrorLevel
  Temp1 = %ErrorLevel%
  Random, Temp1, 1, %Temp1%
  TaskList .= "|"
  StringGetPos, Temp1, TaskList, |, L%Temp1%
  Temp1 := SubStr(TaskList,Temp1 + 2,InStr(TaskList,"|",False,Temp1 + 2) - (Temp1 + 2))
  MsgBox, 36, Task Suggestion, You should %Temp1% right now.`n`nWould you like to view all possible tasks?
  IfMsgBox, Yes
  {
   StringTrimRight, TaskList, TaskList, 1
   StringReplace, TaskList, TaskList, |, `n%A_Space%-, All
   MsgBox, 64, Task Suggestion, You should do one of the following:`n%TaskList%
  }
 }
 Gui, Show
 GuiControl, 1:Focus, ToDoList
 Return
}
StringReplace, TaskList, TaskList, |, |, UseErrorLevel
Temp1 = %ErrorLevel%
Random, Temp1, 1, %Temp1%
TaskList .= "|"
StringGetPos, Temp1, TaskList, |, L%Temp1%
Temp1 := SubStr(TaskList,Temp1 + 2,InStr(TaskList,"|",False,Temp1 + 2) - (Temp1 + 2))
MsgBox, 36, Task Suggestion, You should %Temp1% right now.`n`nWould you like to view all possible tasks?
IfMsgBox, Yes
{
 StringTrimRight, TaskList, TaskList, 1
 StringReplace, TaskList, TaskList, |, `n%A_Space%-, All
 MsgBox, 64, Task Suggestion, You should do one of the following:`n%TaskList%
}
TaskList = 
Gui, Show
}
Return

Selected:
Critical
If (A_GuiEvent = "I" && (InStr(ErrorLevel,"S",True) || InStr(ErrorLevel,"F",True)))
 Gosub, ShowInfo
Return

ShowInfo:
{
Critical
SelectedRow := LV_GetNext()
LV_GetText(DateAdded,SelectedRow,1)
LV_GetText(TaskStatus,SelectedRow,2)
LV_GetText(TimeNeeded,SelectedRow,3)
LV_GetText(Task,SelectedRow,4)
StringReplace, DateAdded, DateAdded, %A_Space%,, All
StringReplace, DateAdded, DateAdded, :,, All
StringReplace, DateAdded, DateAdded, /,, All
FormatTime, DateAdded, %DateAdded%, h:mm:ss tt (dddd, MMMM d, yyyy)

GuiControl, 1:, DateAdded, %DateAdded%
GuiControl, 1:ChooseString, TaskStatus, %TaskStatus%
GuiControl, 1:, Status, %TaskStatus%
If TaskStatus = Pending
 GuiControl, 1:+BackgroundRed, TaskCol
Else If TaskStatus = In Progress
 GuiControl, 1:+BackgroundLime, TaskCol
Else
 GuiControl, 1:+BackgroundWhite, TaskCol
GuiControl, 1:, Task, %Task%
}
Return

GuiClose:
GuiEscape:
Gui, 1:Hide
Return

SaveList()
{
 global ToDoListPath
 Loop, % LV_GetCount()
 {
  A_Index1 = %A_Index%
  Loop, 4
  {
   LV_GetText(Temp1,A_Index1,A_Index)
   TaskList .= Temp1 . A_Tab
  }
  StringTrimRight, TaskList, TaskList, 1
  TaskList .= "`n"
 }
 StringTrimRight, TaskList, TaskList, 1
 IfExist, %ToDoListPath%
  FileDelete, %ToDoListPath%
 FileAppend, %TaskList%, %ToDoListPath%
}

LoadList()
{
 global ToDoListPath
 Gui, 1:Default
 FileRead, FileContents, %ToDoListPath%
 GuiControl, 1:-Redraw, ToDoList
 LV_Delete()
 Loop, Parse, FileContents, `n
 {
  IfNotInString, A_LoopField, %A_Tab%
   Continue
  StringSplit, Temp, A_LoopField, %A_Tab%
  LV_Add("",Temp1,Temp2,Temp3,Temp4)
 }
 GuiControl, 1:+Redraw, ToDoList
}