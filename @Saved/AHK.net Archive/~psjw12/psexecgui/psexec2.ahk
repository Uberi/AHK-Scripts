;Ini Last used configuration
#SingleInstance,Off
#NoEnv
#NoTrayIcon
GuiVersion = 1.0.3.7
CompatibleVersion = 1.85

Start:
IfNotExist,psexec.exe
{
	Msgbox,18,PsExec not found,File PsExec.exe could not be found. You can download from www.sysinternals.com
	IfMsgBox,Abort
	ExitApp
	IfMsgBox,Retry
	GoTo,Start
}

IniRead,VistaWarning,psexec.ini,Warnings,Vista,0
If VistaWarning <> 1
{
	If A_OSversion in WIN_VISTA
	{
		IsVista = 1
		Msgbox,49,Windows Vista Compatibility,PsExec GUI has detected your running Windows Vista.`nTo make PsExec run the application must have administrative privileges.`nPlease ensure you grant administrative rights to psexec.exe (not the GUI [this] application).
		IfMsgbox, Cancel
		{
			IniWrite,1,psexec.ini,Warnings,Vista
			ExitApp
		}
		IfMsgBox,Ok
		IniWrite,1,psexec.ini,Warnings,Vista
	}
}

If IsVista <> 1
{
	If A_IsAdmin = 0
	{
		Msgbox,49,Limited User,PsExec GUI has detected you are not an administrator.`nPlease run under an administrator account to run correctly.
		IfMsgbox, Cancel
		ExitApp
	}
}

FileGetVersion,PEVersion,%A_ScriptDir%\psexec.exe
StringTrimRight,PEVersion,PEVersion,4
;Msgbox,%PEVersion%
If PEVersion > %CompatibleVersion%
{
	Msgbox,49,New PsExec,The PsExec being used is newer than the GUI compatibility so some new features may not yet be available in the Gui.`nCheck for program updates.`nGUI Version: %GUIVersion%`nPsExec Version: %PEVersion%`nCompatible PsExec Version: %CompatibleVersion%
	IfMsgBox,Cancel
	ExitApp
}
If PEVersion < %CompatibleVersion%
{
	Msgbox,48,Old PsExec,It has been detected you are using an older version of PsExec. Some features of the GUI may not work.`nDownload the latest version from www.sysinternals.com`nGUI Version: %GUIVersion%`nPsExec Version: %PEVersion%`nCompatible PsExec Version: %CompatibleVersion%
	IfMsgBox,Cancel
	ExitApp
}
;------------------------------GUI-------------------------------------
IniRead,LastRun,psexec.ini,Run,LastRun,%A_Space%
IniRead,LastCmdLines,psexec.ini,Run,CommandLines,%A_Space%
IniRead,LastPC,psexec.ini,Run,PCName,%A_Space%
NextRunNo = 1
Gui,Add,Text,x5 y5,Application to run on remote PC
Gui,Add,Edit,x5 y20 w250 vRunFile -wrap h20, %LastRun%
Gui,Add,Button,x260 y19 h23,&Browse
Gui,Add,Text,x5 y42 -Wrap h20,Command lines
Gui,Add,Edit,x5 y57 w300 vCmdLines,%LastCmdLines%
Gui,Add,Text,x5 y80,User Name
Gui,Add,Edit,x5 y95 w140 vUserName -wrap h20, ;-u
Gui,Add,Text,x160 y80 ,Password
Gui,Add,Edit,x160 y95 w140 Password vPassword -wrap h20, ;-p
Gui,Add,GroupBox,x3 y120 w310 h255,Parameters
Gui,Add,Checkbox, x7 y140 gLocalRun vLocalRun,Run on &Local system
Gui,Add,Checkbox,x127 y140 vInteractive gInteractive,&Interact with user desktop ; -i interactive
Gui,Add,Text,x268 y128,Session
Gui,Add,Edit,x269 y142 vISession h18 w42 number Disabled, ; interactive session
Gui,Add,UpDown,Disabled, ;For interactive session
GuiControl,,Edit5,
Gui,Add,Checkbox,x7 y160 gRunSystem vRunAsSystem,Run as &System ;-s run as system
Gui,Add,Checkbox, x130 y160 vLimited,Run with Limited &User credentials ;-l limited credentials
Gui,Add,Checkbox,x7 y180 vLoadAccount,Load specified accounts &profile ;-e load specified usser account
Gui,Add,Checkbox,x7 y200 vCopy gCopy,&Copy program to remote computer ;-c copy to remote computer
Gui,Add,Checkbox,x190 y200 gOverwriteFile vOverwriteFile Disabled,&Overwrite existing file ;-f replace file
Gui,Add,Checkbox,x7 y220 gOverwriteIfNew vOverwriteIfNew Disabled,Overwrite if &New version ;-v replace file if new verion
Gui,Add,Checkbox,x7 y240 vDWTerm,Don't wait for &Termination ;-d don't wait for termination
Gui,Add,Checkbox,x160 y240 Disabled vWinlogon,Run on &Winlogon Desktop ;-x run on winlogon desktop (local only)
Gui,Add,GroupBox,x7 y260 h105 w100,Process Priority
Gui,Add,Radio,x10 y275 vp1,&1.Realtime
Gui,Add,Radio,x10 y290 vp2,&2.High
Gui,Add,Radio,x10 y305 vp3,&3.AboveNormal
Gui,Add,Radio,x10 y320 vp4 Checked,&4.Normal
Gui,Add,Radio,x10 y335 vp5,&5.BelowNormal
Gui,Add,Radio,x10 y350 vp6,&6.Idle
Gui,Add,Text,x115 y260,Working Directory
Gui,Add,Edit,x115 y275 w140 vWorkingDir -Wrap h20, ;-w set working directory, needs FileSelectFile
Gui,Add,Button,x260 y274 w45 h23 gWorkDir,Bro&wse
Gui,Add,Text,x115 y297,Run on Processors
Gui,Add,Edit,x115 y310 w95 vProcessors -Wrap h20, ;-a with number scroll boxes, processors to use
Gui,Add,Text,x210 y313,Seperate with comma
Gui,Add,Text,x115 y332,Connection Timeout
Gui,Add, Edit,x115 y347 w50 Number vTimeout -Wrap h20,
Gui,Add,UpDown,, ;-n timeout to connect
Gui,Add,Text,x170 y350,Seconds
Gui,Add,Text,x5 y377,Export to .bat
Gui,Add,Edit,x5 y392 w180 vExport -wrap h20,
Gui,Add,Button,x190 y391 w45 h23 gExport,Brows&e
Gui,Add,Button,x240 y380 w70 h40 Default,&Run
;Second Column
Gui,Add,Text,x320 y5,Remote PC Name/IP
Gui,Add,Edit,x320 y20 w140 vPC -wrap h20,%LastPC%
Gui,Add,Button,x465 y19 h22 w33 Disabled,&Add
Gui,Add,Checkbox,x320 y45 gMulti vMultiOn,&Multiple PC's
Gui,Add,ListView,x320 y65 w180 h206 grid -LV0x20 -LV0x10 NoSortHdr NoSort +Multi Disabled,Remote Computer Name
Gui,Add,Button,x320 y275 w85 h22 Disabled,L&oad Names
Gui,Add,Button,x415 y275 w85 h22 Disabled,Sa&ve
Gui,Add,Button,x320 y300 w85 h22 Disabled,Re&move
Gui,Add,Button,x415 y300 w85 h22 Disabled,Clear List
Gui,Add,CHeckbox, x312 y406 vHide,&Hide CMD
Gui,Add,Text,x410 y324,For PsExec v%CompatibleVersion%
Gui,Add,Button,x380 y337 w120 h30 gSysinternals,www.s&ysinternals.com
Gui,Add,Text,x341 y370,Made by Paul Watson (PSJW14)
Gui,Add,Button,x380 y385 gAHK w120 h36,Made with AutoHot&key`nwww.autohotkey.com
Gui,Show,xcenter ycenter w508 h425,PsExec GUI v%GUIVersion%
;Variables
RunLocal = 0
MultiOn = 0
DisableOverIfNew = 0
DisableOverFile = 0
SetTimer,Focus,100
return
;--------------------------END-GUI-------------------------------------

Focus:
ControlGetFocus,CurFocus,PsExec GUI v%GUIVersion%
If CurFocus = Edit10
{
	If MultiOn = 1
	GuiControl,+Default,Button23
}
Else
GuiControl,+Default,Button22
return

ButtonBrowse:
GuiControlGet,RunFile
If RunFile =
IniRead,LastBrowseFile,psexec.ini,Browse,Run,C:\Windows\System32
Else
LastBrowseFile = %RunFile%
Gui +OwnDialogs
FileSelectFile,BrowseFile,3,%LastBrowseFile%,Select File,Application (*.exe;*.bat;*.com;*.scr;*.cmd)
If BrowseFile <> ; If blank don't change edit box
{
	GuiControl,,Edit1,%BrowseFile% ;enter selected file into edit box
	IniWrite,%BrowseFile%,psexec.ini,Browse,Run
}
return

RunSystem: ;If System user is selected will disable User Name and Password boxes
GuiControlGet,RunAsSystem
If RunAsSystem  = 1
{
	GuiControl,Disable,Edit3 ;disable user name edit
	GuiControl,Disable,Edit4 ;disable Password edit
	GuiControl,,Edit3,
	GuiControl,,Edit4
}
Else If RunAsSystem = 0
{
	GuiControl,Enable,Edit3 ;enable user name edit
	GuiControl,Enable,Edit4 ;enable Password edit
}
return

Interactive:
GuiControlGet,Interactive
If Interactive = 1
{
	GuiControl,Enable,Edit5
	GuiControl,Enable,msctls_updown321
	GuiControl,,Edit5,0
}

Else
{
	GuiControl,Disable,Edit5
	GuiControl,Disable,msctls_updown321
	GuiControl,,Edit5,
}
return

LocalRun: ;If Run on local system is selected
GuiControlGet,LocalRun
IF LocalRun = 1
{
	RunLocal = 1
	GuiControl,,Static1,Application to run on local PC
	GuiControl,Disable,Button8 ;Disable "Copy Program..."
	GuiControl,Disable,Button9 ;Disable "Overwrite existing file"
	GuiControl,Disable,Button10 ;Disable "Overwrite if new version"
	GuiControl,,Button8,0 ;Unchecks "Copy Program..."
	GuiControl,,Button9,0 ;Unchecks "Overwrite existing file"
	GuiControl,,Button10,0 ;Unchecks "Overwrite if new version"
	GuiControl,Enable,Button12 ;Enable "Run on Winlogon Desktop"
	GuiControl,Disable,Edit8 ;Disable Connection Timeout edit box
	GuiControl,,Edit8,
	GuiControl,Disable,msctls_updown322 ;Disable Connection Timeout UpDown
	GuiControl,Disable,Edit10 ;Disable Add PC edit
	;GuiControl,Disable,Button22 ;Disable Add PC button
	GuiControl,Disable,Button23 ;Disable Add button
	GuiControlGet,MultiOn
	If MultiOn = 1
	MultiWasOn = 1
	Else
	MultiWasOn = 0
	GuiControl,,Button24,0
	GuiControl,Disable,Button24 ;Disable Multiple PC's checkbox
	GuiControl,Disable,Button25 ;Disable Load Table button
	GuiControl,Disable,SysListView321 ;Disable Table
	GuiControl,Disable,Button26 ;Disable Save Table Button
	GuiControl,Disable,Button27 ;Disable Remove Button
	GuiControl,Disable,Button28 ;Disable Clear Table Button
	DisableOverFile = 0
	DisableOverIfNew = 0
	;Gui,Show,w320
}
else if LocalRun = 0
{
	GuiControl,,Static1,Application to run on remote PC
	GuiControlGet,Copy
	RunLocal = 0
	GuiControl,Enable,Button8 ;Enable "Copy Program..."
	If Copy = 1
	GuiControl,Enable,Button9 ;Enable "Overwrite existing file"
	If Copy = 1
	GuiControl,Enable,Button10 ;Enable "Overwrite if new version"
	GuiControl,Disable,Button12 ;Disable "Run on Winlogon Desktop"
	GuiControl,,Button12,0 ;Unchecks "Run on Winlogon Desktop
	GuiControl,Enable,Edit8 ;Enable Connection Timeout edit box
	GuiControl,Enable,msctls_updown322 ;Enable Connection Timeout UpDown
	GuiControl,Enable,Edit10 ;Enable Add PC edit
	;GuiControl,Enable,Button22 ;Enable Add PC button
	GuiControl,Enable,Button24 ;Enable Multiple PC's checkbox
	If MultiWasOn = 1
	{
	GuiControl,,Button24,1
	GuiControl,Enable,SysListView321 ;Enable Table
	GuiControl,Enable,Button23 ;Enable Add button
	GuiControl,Enable,Button25 ;Enable Load Table button
	GuiControl,Enable,Button26 ;Enable Save Table Button
	GuiControl,Enable,Button27 ;Enable Remove Button
	GuiControl,Enable,Button28 ;Enable Clear Table Button
	}
	;Gui,Show,w510
}
Return

Copy:
GuiControlGet,Copy
If Copy = 0
{
	GuiControl,Disable,Button9
	GuiControl,,Button9,0
	GuiControl,Disable,Button10
	GuiControl,,Button10,0
	DisableOverFile = 0
	DisableOverIfNew = 0
}
Else
{
	If DisableOverFile = 0
	GuiControl,Enable,Button9
	If DisableOverIfNew = 0
	GuiControl,Enable,Button10
}
Return

OverwriteFile: ;Overwrite Existing file checkbox
GuiControlGet,OverwriteFile
If OverwriteFile = 1
{
	DisableOverIfNew = 1
	;GuiControl,Disable,Button10 ;Disable "Overwrite if new version"
	GuiControl,,Button10,0 ;Unchecks "Overwrite if new version"
}
Else If OverwriteFile = 0
{
	DisableOverIfNew = 0
	GuiControl,Enable,Button10 ;Enable "Overwrite if new version"
}
Return

OverwriteIfNew: ;Overwrite if new file checkbox
GuiControlGet,OverwriteIfNew
If OverwriteIfNew = 1
{
	DisableOverFile = 1
	;GuiControl,Disable,Button9 ;Disable "Overwrite existing file"
	GuiControl,,Button9,0 ;Unchecks "Overwrite existing file"
}
else If OverwriteIfNew = 0
{
	DisableOverFile = 0
	GuiControl,Enable,Button9 ;Enable "Overwrite existing file"
}
Return

WorkDir: ;select working directory
GuiControlGet,WorkingDir
If WorkingDir =
IniRead,LastBrowseFile,psexec.ini,Browse,WorkingDir,C:\Windows\System32
Else
LastBrowseWorkingDir = %WorkingDir%
Gui +OwnDialogs
FileSelectFolder,WorkDir,%WorkingDir%,3, Select Working Directory ;Starts in My Computer
If WorkDir <>
{
	GuiControl,,Edit5,%WorkDir%
	IniWrite,%WorkDir%,psexec,Browse,WorkingDir
}
return

Export:
GuiControlGet,Export
If Export =
IniRead,LastExport,psexec.ini,Browse,Export,%A_Space%
Else
LastExport = %Export%
Gui +OwnDialogs
FileSelectFile,ExportBAT,S 16,%LastExport%,Save to bat,Batch (*.bat)
If ExportBAT <>
{
	EndBat := RegExMatch(ExportBAT,".bat")
	If EndBat = 0
	ExportBAT = %ExportBAT%.bat
	GuiControl,,Edit9,%ExportBAT%
	IniWrite,%ExportBAT%,psexec,Browse,Export
}
Return

Multi:
GuiControlGet,MultiOn,
If MultiOn = 1
{
	GuiControl,Enable,SysListView321 ;Enable Table
	GuiControl,Enable,Button23 ;Enable Add button
	GuiControl,Enable,Button25 ;Enable Load Table button
	GuiControl,Enable,Button26 ;Enable Save Table Button
	GuiControl,Enable,Button27 ;Enable Remove Button
	GuiControl,Enable,Button28 ;Enable Clear Table Button
	;GuiControl,+Default,Button23
}
else If MultiOn = 0
{
	GuiControl,Disable,Button23 ;Disable Add button
	GuiControl,Disable,Button25 ;Disable Load Table button
	GuiControl,Disable,SysListView321 ;Disable Table
	GuiControl,Disable,Button26 ;Disable Save Table Button
	GuiControl,Disable,Button27 ;Disable Remove Button
	GuiControl,Disable,Button28 ;Disable Clear Table Button
	;GuiControl,+Default,Button22
}
Return

ButtonAdd: ;Add to table
GuiControlGet,AddPC,,Edit10
If AddPC <>
LV_Add("",AddPC)
GuiControl,,Edit10,
Return

ButtonLoadNames:
Gui +OwnDialogs
FileSelectFile,LoadList,3,::{450d8fba-ad25-11d0-98a8-0800361b1103},Load Remote Name List,Plain Text File (*.txt)
LV_Delete()
Loop
{
	;	StringTrimRight, lineshort, line, 1
    FileReadLine, line,%LoadList%, %A_Index%
    if ErrorLevel
        break
	StringReplace, lineshort, line, `,,, 1
	if(line= "")
		sleep 5
	else
		LV_Add("", lineshort)
}
Return

ButtonSave:
Gui +OwnDialogs
FileSelectFile,SaveList,S 16,::{450d8fba-ad25-11d0-98a8-0800361b1103},Save List,Plain Text File (*.txt)
LV_Modify(0, "Select")
RowNumber = 0  ; This causes the first loop iteration to start the search at the top of the list.
FileDelete, %SaveList%
Loop
{
    RowNumber := LV_GetNext(RowNumber)  ; Resume the search at the row after that found by the previous iteration.
    if not RowNumber  ; The above returned zero, so there are no more selected rows.
        break
    LV_GetText(Texts, RowNumber)
    FileAppend, %Texts%`n, %SaveList%
}
return

ButtonRemove:
RowNumber = 0  
Loop
{
    RowNumber := LV_GetNext(RowNumber - 1)
    if not RowNumber  ; The above returned zero, so there are no more selected rows.
        break
    LV_Delete(RowNumber)  ; Clear the row from the ListView.
}
return

ButtonClearList:
LV_Delete()
return

ButtonRun:
Gui,+Disabled
GuiControlGet,RunFile
If RunFile =
{
	Gui, +OwnDialogs
	Msgbox,48,Error,Please enter program to run
	Gui,-Disabled
	GuiControl,Focus,Edit1
	Exit
}
GuiControlGet,LocalRun
GuiControlGet,PC
GuiControlGet,MultiOn
If LocalRun = 0
{
	If MultiOn = 0
	{
		If PC =
		{
			Gui, +OwnDialogs
			Msgbox,48,No PC name,Please enter a remote PC Name or IP address
			Gui,-Disabled
			GuiControl,Focus,Edit10
			Exit
		}
		Else
		{
		ZPC = \\%PC%	
		IniWrite,%PC%,psexec.ini,Run,PCName
		}
	}
}
IniWrite,%RunFile%,psexec.ini,Run,LastRun

GuiControlGet,RunAsSystem
If RunAsSystem = 0
{
	GuiControlGet,Username
	If Username = 
		{
		ZUsername =
		NoUser = 1
		}
	Else
		ZUsername = -u %Username%
	GuiControlGet,Password
	If Password =
		ZPassword =
	Else
		{
		If NoUser = 1
		{
			Gui, +OwnDialogs
			Msgbox,48,No Username,Please enter username or remove password
			Gui,-Disabled
			GuiControl,Focus,Edit3
			Exit
		}
		ZPassword = -p %password%
	}
}

GuiControlGet,Interactive
If Interactive = 1
{
	Parameters = %Parameters% `-i
	GuiControlGet,ISession
	If (ISession = "") Or (ISession = 0)
	{}
	Else
	Parameters = %Parameters% %ISession%
}
;GuiControlGet,RunAsSystem
If RunAsSystem = 1
Parameters = %Parameters% `-s
GuiControlGet,Limited
If Limited = 1
Parameters = %Parameters% `-l
GuiControlGet,LoadAccount
If LoadAccount = 1
Parameters = %Parameters% `-e
GuiControlGet,Copy
If Copy = 1
Parameters = %Parameters% `-c
GuiControlGet,OverwriteFile
If OverwriteFile = 1
Parameters = %Parameters% `-f
GuiControlGet,OverwriteIfNew
If OverwriteIfNew = 1
Parameters = %Parameters% `-v
GuiControlGet,DWTerm
If DWTerm = 1
Parameters = %Parameters% `-d
GuiControlGet,WinLogon
If WinLogon = 1
Parameters = %Parameters% `-x

GuiControlGet,p1
If p1 = 1
	ZPriority = -realtime
GuiControlGet,p2
If p2 = 1
	ZPriority = -high
GuiControlGet,p3
If p3 = 1
	ZPriority = -abovenormal
GuiControlGet,p4
If p4 = 1
	ZPriority =
GuiControlGet,p5
If p5 = 1
	ZPriority = -belownormal
GuiControlGet,p6
If p6 = 1
	ZPriority = -low
GuiControlGet,WorkingDir
If WorkingDir =
	ZWorkingDir =
Else
	ZWorkingDir = -w %WorkingDir%
GuiControlGet,Processors
If Processors =
	ZProcessors =
Else
	ZProcessors = -a %Processors%
GuiControlGet,Timeout
If (Timeout = "") or (Timeout = 0)
	ZTimeout = 
Else
	ZTimeout = -n %Timeout%

GuiControlGet,CmdLines
IniWrite,%CmdLines%,psexec.ini,Run,CommandLines
GuiControlGet,Export
If MultiOn = 0
{
	If Export <>
	{
		FileDelete,%Export%
		FileAppend,"%A_ScriptDir%\psexec.exe" %Parameters% %ZPriority% %ZWorkingDir% %ZProcessors% %ZTimeout% %ZUsername% %ZPassword% %ZPC% "%RunFile%" %CmdLines%`n,%Export%
		If ErrorLevel <> 0
		{
			Gui, +OwnDialogs
			Msgbox,49,Export Error,There was an error exporting to bat.`nPress OK to continue run.
			IfMsgBox, Cancel
			{
				Gui,-Disabled
				Exit
			}
		}
	}
}
;MsgBox,%Parameters%
;The Final RUN----------------------------------------------------------
GuiControlGet,Hide
If Hide = 1
	ZHide = Hide
Else If Hide = 0
	ZHide =
If MultiOn = 0
{
	Run,psexec.exe %parameters% %ZPriority% %ZWorkingDir% %ZProcessors% %ZTimeout% %ZUsername% %ZPassword% %ZPC% "%RunFile%" %CmdLines%,,%ZHide% UseErrorLevel
	If ErrorLevel = Error
	{
		Gui, +OwnDialogs
		Msgbox,16, PsExec not found,File PsExec.exe could not be found. You can download from www.sysinternals.com
	}
	
}
Else
{
	LV_Modify(0, "Select")
	RowNumber = 0 
	ZeroEntries = 1
	FileDelete,%Export%
	Loop
	{
		RowNumber := LV_GetNext(RowNumber)  ; Resume the search at the row after that found by the previous iteration.
		if not RowNumber  ; The above returned zero, so there are no more selected rows.
		{
			If ZeroEntries = 1
			{
				Gui, +OwnDialogs
				Msgbox,48,No entries found,No PC names have been added to the table.
				Break
			}
			Else
			break
		}
		ZeroEntries = 0
		LV_GetText(PC, RowNumber)
		ZPC = \\%PC%
		Run,psexec.exe %parameters% %ZPriority% %ZWorkingDir% %ZProcessors% %ZTimeout% %ZUsername% %ZPassword% %ZPC% "%RunFile%" %CmdLines%,,%ZHide% UseErrorLevel
		If Export <>
		FileAppend,"%A_ScriptDir%\psexec.exe" %Parameters% %ZPriority% %ZWorkingDir% %ZProcessors% %ZTimeout% %ZUsername% %ZPassword% %ZPC% "%RunFile%" %CmdLines%`n,%Export%
	}
	If Export <>
	{
		If ErrorLevel <> 0
		{
			Gui, +OwnDialogs
			Msgbox,48,Export Error,There was an error exporting to bat.`nPress OK to continue run.
		}
	}
}
Parameters =
Gui,-Disabled
return

/*
GuiControlGet,Run,,Edit1
If Run =
{
	Gui, +OwnDialogs
	Msgbox,48,Error,Please enter program to run
	GuiControl,Focus,Edit1
	Exit
}
If RunLocal = 0
{
	GuiControlGet,PCName,,Edit9
	If PCName =
	{
		Gui, +OwnDialogs
		Msgbox,48,Error,Please enter PC name
		Exit
	}
}
Msgbox,Run
return
*/

AHK:
Run,www.autohotkey.com,, UseErrorLevel
return

Sysinternals:
Run,www.sysinternals.com,,UseErrorLevel
Return

GuiClose:
ExitApp