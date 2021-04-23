App=Attributizer v0.60
Menu, Tray, Tip, %App%

/*
Requested by Mio on 2008-06-05
Thread = http://www.autohotkey.com/forum/viewtopic.php?p=200516

-------------------------------------

Version 0.10 | By rhys   | 2008-06-05
    - Created script
    - Gave it "System" attribute modification abilities

Version 0.20 | By Mio | 2008-06-05
    - Added "Hidden" attribute modification ablities
    - Changed name from "Systemifier" to "Attributizer"

Version 0.30 | By Mio | Unknown
    - Added an Info popup
    
Version 0.40 | By Mio | 2009-05-24
    - Added "Read-Only" support"
    - Detects if path was manually typed in
    - More cleaner interface
    
Version 0.50 | By Mio | 2009-05-26
    - Optimized Code
    - Added changing the Date Accessed, Modified, and Created times
    - Minor "Error Control" bug fixed

Version 0.60 | By Mio | 2009-06-01
    - Included option to confirm changing date-related attributes
      (Enabled by default, writes to a .cfg file in the Script Directory)
    - Customized Tray Menu

-------------------------------------
*/

Gui,Add,Edit,+Section x+0 y+7 vTarget w208 gCheckExist
Gui,Add,Button,yp x+5 gSelectFile,File...
Gui,Add,Button,yp x+5 gSelectFolder,Folder...
Gui,Add,Button,x+10 yp gSystem +Disabled,+"System"
Gui,Add,Button,x+5 yp gHide +Disabled,+"Hide"
Gui,Add,Button,x+5 yp gReadOnly +Disabled,+"Read-Only"
Gui, Add, DateTime, xm y+5 w190 vTimeDate, MM/dd/yyyy hh:mm:ss tt
Gui,Add,Button,x+5 yp gDateAccess +Disabled, Date Accessed
Gui,Add,Button,x+5 yp gDateCreated +Disabled, Date Created
Gui,Add,Button,x+5 yp gDateModified +Disabled, Date Modified
Gui,Add,Button,x+24 yp  gOptions, Options
Gui, Add, StatusBar, gStatusBar,Type a path into the box, or press the "File..." or "Folder..." buttons
Gui,Show,,%App%
If 1 = 
{
}
else
{
GuiControl,, Target, %1%
GuiControl, -Disabled, +"System"
GuiControl, -Disabled, +"Hide"
GuiControl, -Disabled, +"Read-Only"
GuiControl, -Disabled, Date Accessed
GuiControl, -Disabled, Date Created
GuiControl, -Disabled, Date Modified
}

sbar=0
IniRead, ChangeDateConfirm, %A_ScriptDir%\Attributizer.cfg, Main Options, ChangeDateConfirm, Y
Gosub MenuCreate
Menu, Tray, NoStandard
Menu, Tray, Add, &Options, :Options
Menu, Tray, Add, &Exit, GuiClose
Return

StatusBar:
If sbar=0
{
  return
}
If sbarshow=reg
  {
    Gosub DisplayStatus2
  }
  else
  {
    Gosub DisplayStatus
  }
return

GuiClose:
ExitApp
return

CheckExist:
Gui, Submit, nohide
Gosub GotTarget
If Status2 =
{
GuiControl,,msctls_statusbar321, %Status%
}
else
{
Gosub DisplayStatus
}
return

DisplayStatus:
sbarshow=reg
Gui, Submit, Nohide
GuiControl,,msctls_statusbar321, %Status4% Attributes: %Status%, %Status2%, and %Status3%
return

DisplayStatus2:
sbarshow=time
Gui, Submit, Nohide
GuiControl,,msctls_statusbar321, %Status4% Time Attributes: (A)=%Status5%, (C)=%Status6%, and (M)=%Status7%
return

Done:
Tooltip, Done!
SetTimer, RemoveTooltip, 500
return

RemoveTooltip:
SetTimer, RemoveTooltip, Off
Tooltip
return

;------------------------Setting the Attributes---------------------------------

System:
If Status=system
{
   FileSetAttrib,-S,%Target%
}
 else
{
   FileSetAttrib,+S,%Target%
}
GoSub,GotTarget
Gosub DisplayStatus
Gosub Done
Return

Hide:
If Status2=not hidden
{
   FileSetAttrib,+H,%Target%
}
 else
{
   FileSetAttrib,-H,%Target%
}
GoSub,GotTarget
Gosub DisplayStatus
Gosub Done
Return

ReadOnly:
If Status3=not read-Only
{
   FileSetAttrib,+R,%Target%
}
 else
{
   FileSetAttrib,-R,%Target%
}
GoSub,GotTarget
Gosub DisplayStatus
Gosub Done
return

DateAccess:
ChangeWhatTime=Date Accessed
ChangeWhatTime2=A
Gosub ChangeDate
return

DateCreated:
ChangeWhatTime=Date Created
ChangeWhatTime2=C
Gosub ChangeDate
return

DateModified:
ChangeWhatTime=Date Modified
ChangeWhatTime2=M
Gosub ChangeDate
return

;---------------------------End Setting the Attributes--------------------------

SelectFile:
TargetBackup=%Target%
FileSelectFile,Target,2,,%app% :: Select a file...
If ErrorLevel=1
{
   Target=%TargetBackup%
   return
}
If (Target)
   GuiControl,,Target,%Target%
   GoSub,GotTarget
Gosub DisplayStatus
Return

SelectFolder:
TargetBackup=%Target%
FileSelectFolder,Target,,,%app% :: Select a folder...
If ErrorLevel=1
{
   Target=%TargetBackup%
   return
}
If (Target)
   GuiControl,,Target,%Target%
   GoSub,GotTarget
Gosub DisplayStatus
Return

GotTarget:
IfNotExist, %Target%
{
Gosub NoValid
GuiControl, +Disabled, +"System"
GuiControl, +Disabled, -"System"
GuiControl, +Disabled, +"Hide"
GuiControl, +Disabled, -"Hide"
GuiControl, +Disabled, +"Read-Only"
GuiControl, +Disabled, -"Read-Only"
GuiControl, +Disabled, Date Accessed
GuiControl, +Disabled, Date Modified
GuiControl, +Disabled, Date Created
return
}
sbar=1

FileGetAttrib,StatusCheck,%Target%
GuiControl, -Disabled, +"System"
GuiControl, -Disabled, -"System"
GuiControl, -Disabled, +"Hide"
GuiControl, -Disabled, -"Hide"
GuiControl, -Disabled, +"Read-Only"
GuiControl, -Disabled, -"Read-Only"
GuiControl, -Disabled, Date Accessed
GuiControl, -Disabled, Date Modified
GuiControl, -Disabled, Date Created
IfInString,StatusCheck,S
{
   Status=System
   GuiControl,, Button3, -"System"
}
Else
{
   Status=Not system
   GuiControl,, Button3, +"System"
}
IfInString,StatusCheck,H
{
   Status2=hidden
   GuiControl,, Button4, -"Hide"
}
Else
{
   Status2=not hidden
   GuiControl,, Button4, +"Hide"
}
IfInString,StatusCheck,R
{
   Status3=read-only
   GuiControl,, Button5, -"Read-Only"
}
Else
{
   Status3=not read-only
   GuiControl,, Button5, +"Read-Only"
}
IfInString,StatusCheck,D
{
   Status4=Directory
}
Else
{
   Status4=File
}
Gosub FixTime
Return

GatherTime:
Gui, Submit, Nohide
StringTrimRight, Year, TimeDate, 10
StringTrimRight, Month, TimeDate, 8
StringTrimLeft,  Month, Month, 4
StringTrimRight, Day, TimeDate, 6
StringTrimLeft,  Day, Day, 6
StringTrimRight, Hour, TimeDate, 4
StringTrimLeft,  Hour, Hour, 8
StringTrimRight, Minutes, TimeDate, 2
StringTrimLeft,  Minutes, Minutes, 10
StringTrimLeft,  Seconds, TimeDate, 12
return

FixTime:
FileGetTime, tempfixtime, %Target%, A
Gosub FixTime2
Status5=%Montht%/%Dayt%/%Yeart% %Hourt%:%Minutest%:%Secondst%
FileGetTime, tempfixtime, %Target%, C
Gosub FixTime2
Status6=%Montht%/%Dayt%/%Yeart% %Hourt%:%Minutest%:%Secondst%
FileGetTime, tempfixtime, %Target%, M
Gosub FixTime2
Status7=%Montht%/%Dayt%/%Yeart% %Hourt%:%Minutest%:%Secondst%
return

FixTime2:
StringTrimRight, Yeart, tempfixtime, 10
StringTrimRight, Montht, tempfixtime, 8
StringTrimLeft,  Montht, Montht, 4
StringTrimRight, Dayt, tempfixtime, 6
StringTrimLeft,  Dayt, Dayt, 6
StringTrimRight, Hourt, tempfixtime, 4
StringTrimLeft,  Hourt, Hourt, 8
StringTrimRight, Minutest, tempfixtime, 2
StringTrimLeft,  Minutest, Minutest, 10
StringTrimLeft,  Secondst, tempfixtime, 12
return

ChangeDate:
Gui, Submit, Nohide
Gosub FixTime
Gosub GatherTime
If ChangeDateConfirm=Y
{
   If ChangeWhatTime2=A
      TempChangeTime=%Status5%
   If ChangeWhatTime2=C
      TempChangeTime=%Status6%
   If ChangeWhatTime2=M
      TempChangeTime=%Status7%
   Msgbox, 4, Confirmation: %ChangeWhatTime%, Press 'Yes' if you want to change the %ChangeWhatTime% time...`n`nFrom:`n%TempChangeTime%`n`nTo:`n%Month%/%Day%/%Year% %Hour%:%Minutes%:%Seconds%`n`nNote: Remember, you can make the StatusBar display`ntime attributes instead of regular attributes by clicking on it.
   IfMsgbox Yes
   {
      Gosub SetTimeAndChange
   }
}
else
{
   Gosub SetTimeAndChange
}
ChangeWhatTime=
ChangeWhatTime2=
TempChangeTime=
return

SetTimeAndChange:
FileSetTime, Year . Month . Day . Hour . Minutes . Seconds, %Target%,%ChangeWhatTime2%,1
Gosub FixTime
Gosub DisplayStatus2
Gosub Done
return

NoValid:
sbar=0
Status = No valid file or directory has been inputted...
Status2 =
Status3 =
return

Options:
Gosub MenuCreate
Menu, Options, Show
return

MenuCreate:
Menu, Options, Add, &Confirm Date-Related Attribute Changes, ChangeDateConfirmPick
Menu, Options, Add, &About %App%, About
If ChangeDateConfirm=D
   Menu, Options, Uncheck, &Confirm Date-Related Attribute Changes
else
   Menu, Options, Check, &Confirm Date-Related Attribute Changes
return

About:
Msgbox,, About..., %App%`nBy Mio`nhttp://mio.co.cc`n`nSpecial Thanks To:`nrhys (Started this script)`nwww.ganato.com (Icon)`n`nInstructions:`nSelect a file or folder, then`nclick the corresponding button`nto edit its attributes.`n`nTo switch between showing`nregular attributes and time`nattributes, click the StatusBar.
Return

ChangeDateConfirmPick:
If ChangeDateConfirm=D
   Gosub EnableChangeDateConfirm
else
   Gosub DisableChangeDateConfirm
return

EnableChangeDateConfirm:
Iniwrite, Y, %A_ScriptDir%\Attributizer.cfg, Main Options, ChangeDateConfirm
ChangeDateConfirm=Y
return

DisableChangeDateConfirm:
Iniwrite, D, %A_ScriptDir%\Attributizer.cfg, Main Options, ChangeDateConfirm
ChangeDateConfirm=D
return