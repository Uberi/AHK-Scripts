Version = 2.0.0 Beta build 9
/*
Plans
	*Make per-user log (for version 2+)
	*Look into enable logging even if shutdown stopper disabled (version 2)
	*Crash detection, write to a file every minute, when close properly clears time, if not will check time on startup then log as a crash (Version 2+)
	*Shutdown coutner (version 1.9)
	*Catalogue log by date (version 2+)
	*Options in gui, more logging options (version 2) [enable/disable tooltips]
	*Shutdown menu (version 2) DONE
	*Delayed shutdown on menu (version 2+)
	*(ignore) Stuck on warning icon if refresh after del log
	---------------------------------------------------------------------------------------------------
	TO DO:
	*Prompt and change registy keys for auto end hung applications and time out HKCU\Desktop\Explorer (started)
	*Use a traytip method for windows 95/NT/98/ME (standard message boxes on timeout?)
	*Seperate option for standby enable, remeber in INI file, must be completely disabled on vista except to log event
	*Need extra detection of OS as can be tricked by compatability mode
Version 2.0.0
	*Vista Compatable, will now prevent Vista Shutdown - DONE
	*Standby Stopper, now prevent machine from hibernating or going into standby - ADDED, NOT VISTA COMPATIBLE
	*Added shutdown options from tray icon - DONE
	*Detects forced shutdown, will log if shutdown stopper was forced to close - DONE - WORKS ON VISTA
	*Can now always block without a prompt (Not on vista) (can't stop force shutdown)
	*Fixed bug about ballon tips even if they're running - DONE
	*Fixed bug where loggin on shutdown would always accour even with logging turned off - COMPLETE
	*Note suspend does not work on vista
*/

#Persistent
#SingleInstance Ignore
Process , Priority,, H
Menu,Tray,NoStandard
IfExist,Shutdown Stopper active.ico
Menu,Tray,Icon,Shutdown Stopper active.ico
DllCall("kernel32.dll\SetProcessShutdownParameters", UInt, 0x4FF, UInt, 0, "int")

If A_OSVersion in WIN_NT4,WIN_95,WIN_98,WIN_ME
{
	IfExist , Shutdown Stopper warning.ico
	Menu , Tray , Icon , Shutdown Stopper warning.ico
	Msgbox , 52, OS Compatability , Shutdown Stopper is designed to work with Windows 2000/XP/2003/Vista.`nYou are not running one of these OS's. One problem you will experience is no ToolTips and possibily more.`nDo you wish to continue?
}
IfMsgbox No
ExitApp

If A_OSVersion in WIN_2000,WIN_XP,WIN_2003,WIN_VISTA
{
	RegRead , Ballons, HKEY_CURRENT_USER, Software\Microsoft\Windows\CurrentVersion\Explorer, EnableBalloonTips
	If Ballons = 0
	{
		IfExist , Shutdown Stopper warning.ico
		Menu , Tray , Icon , Shutdown Stopper warning.ico
		Msgbox , 52, Ballon Tips disabled, Shutdown Stopper requires ballon tips for certain functions.`nYou can run shutdown stopper but ballon tip events will not occur.`nDo you wish to continue?
		IfMsgbox No
		ExitApp
	}
}

If A_OSVersion in WIN_VISTA
{
	Vista = 1
	;TrayTip,Vista Detected,Suspend blocking is not available on vista,15,3
}
	

If A_OSVersion in WIN_NT4,WIN_95,WIN_98,WIN_ME,WIN_2000,WIN_XP,WIN_2003,WIN_VISTA
{}
Else
{
	IfExist , Shutdown Stopper warning.ico
	Menu , Tray , Icon , Shutdown Stopper warning.ico
	Msgbox,52, Unknown OS, Your using an unreconised version of Windows and Shutdown Stopper may not run correctly.`nDo you wish to continue?
	IfMsgBox No
	ExitApp
}

RegRead,AutoEndAppsUser,HKEY_CURRENT_USER,Control Panel\Desktop,AutoEndTasks
RegRead,AutoEndAppsDefault,HKEY_USERS,.Default\Control Panel\Desktop,AutoEndTasks,
RegRead,EndTimeoutUser,HKEY_CURRENT_USER,Control Panel\Desktop,HungAppTimeout
RegRead,EndTimeoutDefault,HKEY_USERS,.Default\Control Panel\Desktop,HungAppTimeout

If AutoEndAppsUser = 1
{
	IfExist , Shutdown Stopper warning.ico
	Menu , Tray , Icon , Shutdown Stopper warning.ico
	MsgBox,51,Force Shutdown On,A setting on your computer has been enabled which will prevent Shutdown Stopper from stopping a shutdown event.`nTechnical: The registry key "HKEY_CURRENT_USER\Control Panel\Desktop\AutoEndTasks" is set to "1"`n`nDo you wish shutdown stopper to disable this feature so it can work correctly?
	IfMsgBox,Yes
	RegWrite,REG_SZ,HKEY_CURRENT_USER,Control Panel\Desktop,AutoEndTasks,0
	If ErrorLevel <> 0
	Msgbox,16,Registry write failure,Shutdown Stopper could not change the setting nessesary to make it work correctly.`nTechnical: Could not change the registry key "HKEY_CURRENT_USER\Control Panel\Desktop\AutoEndTasks" to 0.
	IfMsgBox,Cancel
	ExitApp
}

RegRead , StartSet, HKEY_CURRENT_USER, Software\Microsoft\Windows\CurrentVersion\Run, Shutdown Stopper
IniRead , LogOn , Shutdown Stopper.ini, Logging, Shutdown, 0
IniRead , SELogon , Shutdown Stopper.ini, Logging, Start & Exit, 0
If SELogon = 1
FileAppend , Shutdown Stopper started by %A_UserName% on %A_DD%\%A_MM%\%A_YYYY% at %A_Hour%:%A_Min%:%A_Sec%.`n, Shutdown log.txt

Enabled = 1
NoLog = 0
If StartSet = %A_ScriptFullPath%
Startup = 1
else
Startup = 0
IgnoreES = 0
OwnSus = 0

OnMessage(0x11, "WM_QUERYENDSESSION")
OnMessage(0x16, "WM_ENDSESSION")
If Vista <> 1
OnMessage(0x218, "WM_POWERBROADCAST")

Menu:
Menu , Tray, Add, S&hutdown Stopper v%version%, About
Menu , Tray, Add
Menu , Tray, Add, Enable &Shudown Stopper, Enable
If Enabled = 1
Menu , Tray, Check, Enable &Shudown Stopper
;If A_OSVersion in WIN_NT4,WIN_95,WIN_98,WIN_ME,WIN_2000,WIN_XP,WIN_2003
Menu,Tray,Add,&Block Always,BlockAlways
If A_OSVersion in WIN_VISTA
Menu,Tray,Disable,&Block Always
If BlockAlways = 1
Menu,Tray,Check,&Block Always
Menu , Tray , Add, &Log Shutdowns, Log
If Logon = 1
Menu , Tray , Check, &Log Shutdowns
Menu , Tray , Add , Log &Start && Exits , SELog
If SELogon = 1
Menu , Tray , Check , Log &Start && Exits
Menu , Tray, Add, &Run on Startup, Startup
If StartSet = %A_ScriptFullPath%
Menu , Tray, Check, &Run on Startup
Menu , Tray , Add
Menu , Tray, Add, &View Shutdown Log , RunLog 
Menu , Tray, Add, &Clear log, ClearLog
Menu , Tray , Add
Menu , Shutdown, Add,
Menu, tray, add, Shutdown, :Shutdown
Menu, Shutdown , Add, Shutdown, Shutdown
Menu, Shutdown , Add, Restart,Restart
Menu, Shutdown , Add, Logoff, Logoff
Menu, Shutdown , Add, Standby, Standby
Menu, Shutdown , Add, Hibernate, Hibernate
Menu, Shutdown , Add, Forced Shutdown, FShutdown
Menu, Shutdown , Add, Forced Restart, FRestart
Menu, Shutdown , Add, Forced Logoff, FLogoff
Menu, Shutdown , Add, Forced Standby, FStandby
Menu, Shutdown , Add, Forced Hibernate, FHibernate
Menu , Tray , Add, Res&tart, Reload
Menu, Tray, add, &Exit, Exit
Menu ,Tray, Default, S&hutdown Stopper v%Version%
Menu, Tray, Tip, Shutdown Stopper v%version%
If Enabled = 1
{
	IfExist , Shutdown Stopper active.ico
	Menu , Tray , Icon , Shutdown Stopper active.ico
}
If Enabled = 0
{
	IfExist , Shutdown Stopper disabled.ico
	Menu , Tray , Icon , Shutdown Stopper disabled.ico
}
return

WM_QUERYENDSESSION(wParam, lParam)
{
	global Enabled
	global Logon
	global Vista
	global EventType
	global IgnoreES
	global BlockAlways
	InProgress = 1
    ENDSESSION_LOGOFF = 0x80000000
    if (lParam & ENDSESSION_LOGOFF)  ; User is logging off.
        EventType = Logoff
    else  ; System is either shutting down or restarting.
        EventType = Shutdown
	If Enabled = 1
	{
		Menu , Tray , DeleteAll
		If Vista = 1
		{
			If lParam = 1073741824
			{
				If Logon = 1
				FileAppend , Forced %EventType% by %A_UserName% on %A_DD%\%A_MM%\%A_YYYY% at %A_Hour%:%A_Min%:%A_Sec%.`n, Shutdown log.txt
				TrayTip , Forced Shutdown, Shutdown Stopper has been forced to close down`nShutdown in progress,, 3
				Return True
			}
			SetTimer,BlockVista,100
			Msgbox,4144,Shutdown Stopper,This box is currently stopping Vista from performing a %EventType%.`nTo stop %EventType% wait for this window to close`nTo %EventType% press %EventType% now.,6
			IfMsgBox OK
			{
				If Logon = 1	
				FileAppend , Computer was %EventType% by %A_UserName% on %A_DD%\%A_MM%\%A_YYYY% at %A_Hour%:%A_Min%:%A_Sec%.`n, Shutdown log.txt
				TrayTip , %EventType% Allowed, %EventType% in progress., 120, 
				IgnoreES = 1
				Return True
			}
			IfMsgBox Timeout
			{
				If Logon = 1
				FileAppend , %EventType% blocked by %A_UserName% on %A_DD%\%A_MM%\%A_YYYY% at %A_Hour%:%A_Min%:%A_Sec%.`n, Shutdown log.txt
				TrayTip , %EventType% Blocked, %EventType% was blocked., 30, 2
				GoSub , Menu
				Return False
			}
		}
		If Vista <> 1
		{
			If BlockAlways <> 1
			MsgBox, 4132, Confirm %EventType%, %EventType% is being attempted. Allow it?, 4.9
			IfMsgBox Yes
			{
				IfExist , Shutdown Stopper allowed.ico
				Menu , Tray , Icon , Shutdown Stopper allowed.ico
				If Logon = 1
				FileAppend , Computer was %EventType% by %A_UserName% on %A_DD%\%A_MM%\%A_YYYY% at %A_Hour%:%A_Min%:%A_Sec%.`n, Shutdown log.txt
				DllCall("kernel32.dll\SetProcessShutdownParameters", UInt, 0x1FF, UInt, 0, "int")
				TrayTip , %EventType% Allowed, %EventType% in progress., 120, 2
				IgnoreES = 1
				return true  ; Tell the OS to allow the shutdown/logoff to continue.
			}
			IfMsgbox No
			{
				If Logon = 1
				FileAppend , %EventType% blocked by %A_UserName% on %A_DD%\%A_MM%\%A_YYYY% at %A_Hour%:%A_Min%:%A_Sec%.`n, Shutdown log.txt
				TrayTip , %EventType% Blocked, %EventType% was blocked by user., 30, 2
				GoSub , Menu
				return false ; block shutdown
			}
			IfMsgbox Timeout
			{
				If Logon = 1
				FileAppend , %EventType% auto blocked by %A_UserName% on %A_DD%\%A_MM%\%A_YYYY% at %A_Hour%:%A_Min%:%A_Sec%.`n, Shutdown log.txt
				TrayTip ,  %EventType% Auto Blocked, %EventType% was automatically prevented at %A_Hour%:%A_Min%:%A_Sec%., 864000, 2
				GoSub , Menu
				return false
			}
			If BlockAlways = 1
			{
				If Logon = 1
				FileAppend , %EventType% auto blocked by %A_UserName% on %A_DD%\%A_MM%\%A_YYYY% at %A_Hour%:%A_Min%:%A_Sec%.`n, Shutdown log.txt
				TrayTip ,%EventType% Auto Blocked, %EventType% was automatically prevented at %A_Hour%:%A_Min%:%A_Sec%.`nBlock Always On, 864000, 2
				GoSub , Menu
				return false ; block shutdown
			}
		}
	}
	return true
}
return

WM_POWERBROADCAST(wParam, lParam)
{
	;MsgBox,,Suspend Message recieved,wParam = %wParam%  -  lParam = %lParam%
	global Enabled
	global Logon
	global Vista
	global OwnSus
	If lParam = 1
	{
		If (Enabled = "1" and OwnSus = "0")
		{
			Menu , Tray , DeleteAll
			MsgBox, 4132, Confirm Suspend, Suspend is being attempted. Allow it?, 5 ;`nwParam = %wParam% - lParam = %lParam%
			IfMsgBox, Yes
			{
				If Logon = 1
				FileAppend , Computer was Suspended by %A_UserName% on %A_DD%\%A_MM%\%A_YYYY% at %A_Hour%:%A_Min%:%A_Sec%.`n, Shutdown log.txt
				TrayTip , Suspend Allowed, Suspend in progress., 10, 1
				GoSub , Menu
				Return
			}
			IfMsgBox, No
			{
				If Logon = 1
				FileAppend , Suspend blocked by %A_UserName% on %A_DD%\%A_MM%\%A_YYYY% at %A_Hour%:%A_Min%:%A_Sec%.`n, Shutdown log.txt
				TrayTip , Suspend Blocked, Suspend was blocked by user., 15, 2
				GoSub , Menu
				Return 0x424D5144
			}
			IfMsgbox Timeout
			{
			If Logon = 1
			FileAppend , Suspend auto blocked by %A_UserName% on %A_DD%\%A_MM%\%A_YYYY% at %A_Hour%:%A_Min%:%A_Sec%.`n, Shutdown log.txt
			TrayTip ,  Suspend Auto Blocked, Suspend was automatically prevented at %A_Hour%:%A_Min%:%A_Sec%., 864000, 2
			GoSub , Menu
			return 0x424D5144
			}
		}
	}
	If wParam = 7
	{
		OwnSus = 0
		If Enabled = 1
		{
				If Logon = 1
				FileAppend , Resume Session by %A_UserName% on %A_DD%\%A_MM%\%A_YYYY% at %A_Hour%:%A_Min%:%A_Sec%.`n, Shutdown log.txt
				TrayTip,Session Resumed,Now resumed from suspend,15,1

		}
	}
}


BlockVista:
SetTimer,BlockVista,Off
WinSet, Style, -0x80000, Shutdown Stopper
WinWait,Shutdown Stopper,This box is currently stopping Vista
ControlSetText,Button1,&%Eventtype%,Shutdown Stopper,This box is currently stopping Vista
WinWait,ahk_class BlockedShutdownResolver
;ControlClick,Cancel,ahk_class BlockedShutdownResolver
ControlSend,Cancel,{Space},ahk_class BlockedShutdownResolver
WinWaitClose,ahk_class BlockedShutdownResolver
WinHide,Shutdown Stopper
Return

WM_ENDSESSION(wParam, lParam)
{
	global IgnoreES
	global Logon
	global EventType
	;MsgBox,wParam - %wParam%  -  lParam - %lParam%
	If wParam = 1
	{
		If IgnoreES = 0
		{
			If Logon = 1
			FileAppend , Forced %EventType% by %A_UserName% on %A_DD%\%A_MM%\%A_YYYY% at %A_Hour%:%A_Min%:%A_Sec%.`n, Shutdown log.txt
			TrayTip , Forced Shutdown, Shutdown Stopper has been forced to close down`nShutdown in progress,, 3
		}
		IgnoreES = 0
	}
	Return
}

Enable:
Menu , Tray , ToggleCheck, Enable &Shudown Stopper
If Enabled = 1
{
	Enabled = 0
	IfExist , Shutdown Stopper disabled.ico
	Menu , Tray , Icon , Shutdown Stopper disabled.ico
	Menu , Tray , Disable, &Log shutdowns
	Menu , Tray , Uncheck, &Log shutdowns
	TrayTip , Shutdown Stopper disabled, Shutdown stopper has been disabled. Any shutdown requests will be allowed., 10,2
}
else If Enabled = 0
{
	Enabled = 1
	IfExist , Shutdown Stopper active.ico
	Menu , Tray , Icon , Shutdown Stopper active.ico
	Menu , Tray , Enable, &Log shutdowns
	If Logon = 1
	Menu , Tray , Check, &Log shutdowns
	TrayTip , Shutdown Stopper enabled, Shutdown stopper has been enabled. Any shutdown requests will be blockable., 8,1
}
return

Startup:
If Startup = 1
{
	RegDelete, HKEY_CURRENT_USER, Software\Microsoft\Windows\CurrentVersion\Run, Shutdown Stopper
	If errorlevel = 1
	{
		Menu , Tray , DeleteAll
		IfExist , Shutdown Stopper warning.ico
		Menu , Tray , Icon , Shutdown Stopper warning.ico
		Msgbox, 16, Remove Startup Error, Shutdown stopper had an error removing from startup
		GoSub , Menu
	}
	else
	{
		Menu , Tray , UnCheck,&Run on Startup
		Startup = 0
	}
}
else if Startup = 0
{
	RegWrite, REG_SZ, HKEY_CURRENT_USER, Software\Microsoft\Windows\CurrentVersion\Run, Shutdown Stopper, %A_ScriptFullPath%
	If errorlevel = 1
	{
		Menu , Tray , DeleteAll
		IfExist , Shutdown Stopper warning.ico
		Menu , Tray , Icon , Shutdown Stopper warning.ico
		Msgbox, 16, Startup Error, Shutdown stopper had an error adding to run on startup
		GoSub , Menu
	}
	else
	{
		Menu , Tray , Check,&Run on Startup
		Startup = 1
	}
}
return

BlockAlways:
Menu,Tray,ToggleCheck,&Block Always
If BlockAlways <> 1
{
	BlockAlways = 1
	TrayTip,Block Always,All shutdown attempts will be blocked without prompting.,10,1
}
Else
{
	BlockAlways = 0
	TrayTip,Block Always Disabled,All shutdown attempts will be prompted to user.,10,1
}
Return

Log:
If Logon = 1
{
	IniWrite , 0 , Shutdown Stopper.ini, Logging , Shutdown
	If errorlevel = 1
	{
		Logon = 0
		Menu , Tray , DeleteAll
		IfExist , Shutdown Stopper warning.ico
		Menu , Tray , Icon , Shutdown Stopper warning.ico
		Msgbox , 48, Setting Error, Logging has been disabled however logging will continue on next run.`nMake sure you have permission to write to the application directory`nand the shutdown stopper.ini file is not read-only.`nAlso try manually deleting the shutdown stopper.ini to disable logging.
		GoSub , Menu
	}
	else
	{
		Logon = 0
		Menu , Tray , UnCheck, &Log shutdowns
	}
}
else
{
	IniWrite , 1 , Shutdown Stopper.ini, Logging , Shutdown
	If errorlevel = 1
	{
		Logon = 1
		Menu , Tray , DeleteAll
		IfExist , Shutdown Stopper warning.ico
		Menu , Tray , Icon , Shutdown Stopper warning.ico
		Msgbox , 48, Setting Error, Logging has been enabled however logging maybe disabled on next run.`nMake sure you have permission to write to the application directory`nand the shutdown stopper.ini file is not read-only.
		GoSub , Menu
	}
	else
	{
		Logon = 1
		Menu , Tray , Check, &Log shutdowns
	}
}
return

SELog:
If SELogon = 1
{
	IniWrite , 0 , Shutdown Stopper.ini, Logging , Start & Exit
	If errorlevel = 1
	{
		SELogon = 0
		Menu , Tray , DeleteAll
		IfExist , Shutdown Stopper warning.ico
		Menu , Tray , Icon , Shutdown Stopper warning.ico
		Msgbox , 48, Setting Error, Logging has been disabled however logging will continue on next run.`nMake sure you have permission to write to the application directory`nand the shutdown stopper.ini file is not read-only.`nAlso try manually deleting the shutdown stopper.ini to disable logging.
		GoSub , Menu
	}
	else
	{
		SELogon = 0
		Menu , Tray , UnCheck, Log &Start && Exits
	}
}
else
{
	IniWrite , 1 , Shutdown Stopper.ini, Logging , Start & Exit
	If errorlevel = 1
	{
		SELogon = 1
		Menu , Tray , DeleteAll
		IfExist , Shutdown Stopper warning.ico
		Menu , Tray , Icon , Shutdown Stopper warning.ico
		Msgbox , 48, Setting Error, Logging has been enabled however logging maybe disabled on next run.`nMake sure you have permission to write to the application directory`nand the shutdown stopper.ini file is not read-only.
		GoSub , Menu
	}
	else
	{
		SELogon = 1
		Menu , Tray , Check, Log &Start && Exits
	}
}
return

RunLog:
IfNotExist Shutdown log.txt
{
	IfExist,Shutdown Stopper warning.ico
	Menu , Tray , Icon , Shutdown Stopper warning.ico
	Menu , Tray , DeleteAll
	Msgbox , 16, No Log, No log has been created or not found.
	Gosub , Menu
	return
}
else
{
	IfWinNotExist,Shutdown Log,Shutdown Stopper v%version%
	{
		FileRead , Log , Shutdown log.txt
		Gui, 2: Add,Text,hidden,Shutdown Stopper v%version%
		Gui ,2: Add , Edit, x10 y10 h240 w360 +ReadOnly -WantCtrlA +HScroll,%Log%
		Gui, 2: Add , Button, x10 y220 h30 w100 gRefresh, &Refresh Log
		Gui ,2: Add, Button , x360 y220 h30 w100 gNotepadLog,Open in &Notepad
		Gui ,2: Show ,xCenter yCenter w380 h250, Shutdown Log
		Gui ,2: +Resize +MinSize300x100
		GuiControl,2: Focus, Button1
		WinActivate , Shutdown Log,Shutdown Stopper v%version%
	}
	Else
	WinActivate, Shutdown Log,Shutdown Stopper v%version%
}
return

NotepadLog:
Run , %A_WinDir%\system32\notepad.exe %A_ScriptDir%\Shutdown log.txt,, UseErrorLevel
If errorlevel = ERROR
{
	IfExist , Shutdown Stopper warning.ico
	Menu , Tray , Icon , Shutdown Stopper warning.ico
	Menu , Tray , DeleteAll
	Msgbox , 16, No Log, No log has been created or not found.
	Gosub , Menu
}
return

Refresh:
Gui , Destroy
Goto, RunLog
return

2GuiSize:
LHeight := A_GuiHeight - 50
LWidth := A_GuiWidth - 20
BY := A_GuiHeight - 35
BX := A_GuiWidth - 110
GuiControl ,2:Move, Edit1 , x10 y10 w%LWidth% h%LHeight%
GuiControl, 2:Move, Button2, x%bx% y%by% h30 w100
GuiControl, 2:Move, Button1 , x10 y%by% h30 w100
return

2GuiClose:
Gui , Destroy
return

/*
Run , %A_ScriptDir%\Shutdown log.txt,, UseErrorLevel
If errorlevel = ERROR
{
	IfExist , Shutdown Stopper warning.ico
	Menu , Tray , Icon , Shutdown Stopper warning.ico
	Menu , Tray , DeleteAll
	Msgbox , 16, No Log, No log has been created or not found.
	Gosub , Menu
}
return
*/
ClearLog:
IfExist , Shutdown log.txt
	{
		IfExist , Shutdown Stopper warning.ico
		Menu , Tray , Icon , Shutdown Stopper warning.ico
		Menu , Tray , DeleteAll
		MsgBox , 36 , Confirm, Are you sure you wish to delete log file?
		IfMsgBox Yes
		{
			FileDelete , Shutdown log.txt
			If errorlevel <> 0
			{
				IfExist , Shutdown Stopper warning.ico
				Menu , Tray , Icon , Shutdown Stopper warning.ico
				Menu , Tray , DeleteAll
				Msgbox , 16, Can not delete Log, Log cannot be cleared, make sure you have permissions to delete the file.
				GoSub , Menu
			}
			else
			{
			TrayTip , Log Cleared, The log file has been deleted., 20, 1
			GoSub , Menu
			}
		}
		IfMsgBox No
		{
		Gosub , Menu
		Return
		}
	}
else
TrayTip , No Log exists, The log has already been cleared.	, 20, 3
return


About:
IfWinNotExist,Shutdown Stopper About,Shutdown Stopper v%version%
{
	FileRead , ChangeLog, Changelog.txt
	If Changelog =
	Changelog = Changelog not found.
	Gui , Font , S12 w700 cRed, Arial
	Gui , Add , Text , x105 , Shutdown Stopper v%Version%
	Gui , Font , s10 w600 cBlue, Arial
	Gui , Add, Text , x143 y27, By Paul Watson
	Gui , Font,
	Gui , Add, GroupBox, x60 y45 w290 h75, About
	Gui , Font , S10 w200 cBlack, 
	Gui , Add, Text, x65 y65 , This program will prevent your computer from`nshutting down unless confirmed by the user.`nIt also contains logging features.
	Gui , Font
	Gui , Add, GroupBox, x5 y120 w406 h175, ChangeLog
	Gui , Add , Edit, x10 y135 w296 h155 +ReadOnly -WantCtrlA, %ChangeLog%
	GuiControl, Focus, Static1
	Gui , Show, xcenter ycenter w416 h300, Shutdown Stopper About
	Gui , +Resize +MaximizeBox +MinSize416x300 ;+MaxSize416
	WinActivate , Shutdown Stopper About,Shutdown Stopper v%version%
}
Else
WinActivate , Shutdown Stopper About,Shutdown Stopper v%version%
return 

;Confirm in messagebox
;Disable works fine for shutdown, can disable for suspend then enable on wake up message

Shutdown:
Menu , Tray , DeleteAll
Msgbox,36,Shutdown?,This will not be blockable.`n`nDo you wish to shutdown?
Gosub,Menu
IfMsgBox,Yes
{
	Enabled = 0
	If Logon = 1
	FileAppend , Computer was Shutdown by %A_UserName% on %A_DD%\%A_MM%\%A_YYYY% at %A_Hour%:%A_Min%:%A_Sec%.`n, Shutdown log.txt
	Shutdown,1
	ExitApp
}
IfMsgBox,No
Exit

Restart:
Menu , Tray , DeleteAll
Msgbox,36,Restart?,This will not be blockable.`n`nDo you wish to restart?
Gosub,Menu
IfMsgBox,Yes
{
	Enabled = 0
	If Logon = 1
	FileAppend , Computer was Shutdown by %A_UserName% on %A_DD%\%A_MM%\%A_YYYY% at %A_Hour%:%A_Min%:%A_Sec%.`n, Shutdown log.txt
	Shutdown,2
	ExitApp
}
IfMsgBox,No
Exit
	
Logoff:
Menu , Tray , DeleteAll
Msgbox,36,Logoff?,This will not be blockable.`n`nDo you wish to logoff?
Gosub,Menu
IfMsgBox,Yes
{
	Enabled = 0
	If Logon = 1
	FileAppend , Computer was Logoff by %A_UserName% on %A_DD%\%A_MM%\%A_YYYY% at %A_Hour%:%A_Min%:%A_Sec%.`n, Shutdown log.txt
	Shutdown,0
	ExitApp
}
IfMsgBox,No
Exit
	
Standby:
Menu , Tray , DeleteAll
Msgbox,36,Standby?,This will not be blockable.`n`nDo you wish to Standby?
Gosub,Menu
IfMsgBox,Yes
{
	OwnSus = 0
	If Logon = 1
	FileAppend , Computer was Suspended by %A_UserName% on %A_DD%\%A_MM%\%A_YYYY% at %A_Hour%:%A_Min%:%A_Sec%.`n, Shutdown log.txt
	DllCall("PowrProf\SetSuspendState", "int", 0, "int", 0, "int", 0)
	Return
}
IfMsgBox,No
Exit

Hibernate:
Menu , Tray , DeleteAll
Msgbox,36,Hibernate?,This will not be blockable.`n`nDo you wish to Hibernate?
Gosub,Menu
IfMsgBox,Yes
{
	OwnSus = 0
	If Logon = 1
	FileAppend , Computer was Suspended by %A_UserName% on %A_DD%\%A_MM%\%A_YYYY% at %A_Hour%:%A_Min%:%A_Sec%.`n, Shutdown log.txt
	DllCall("PowrProf\SetSuspendState", "int", 1, "int", 0, "int", 0)
	Return
}
IfMsgBox,No
Exit

FShutdown:
Menu , Tray , DeleteAll
Msgbox,52,Force Shutdown?,This will not be blockable.`nWARNING: Using force shutdown may cause applications to lose data.`nDo you wish to force shutdown?
Gosub,Menu
IfMsgBox,Yes
{
	Enabled = 0
	If Logon = 1
	FileAppend , Computer was Shutdown by %A_UserName% on %A_DD%\%A_MM%\%A_YYYY% at %A_Hour%:%A_Min%:%A_Sec%.`n, Shutdown log.txt
	Shutdown,5
	ExitApp
}
IfMsgBox,No
Exit

FRestart:
Menu , Tray , DeleteAll
Msgbox,52,Force Restart?,This will not be blockable.`nWARNING: Using force restart may cause applications to lose data.`nDo you wish to force restart?
Gosub,Menu
IfMsgBox,Yes
{
	Enabled = 0
	If Logon = 1
	FileAppend , Computer was Shutdown by %A_UserName% on %A_DD%\%A_MM%\%A_YYYY% at %A_Hour%:%A_Min%:%A_Sec%.`n, Shutdown log.txt
	Shutdown,6
	ExitApp
}
IfMsgBox,No
Exit

FLogoff:
Menu , Tray , DeleteAll
Msgbox,52,Force Logoff?,This will not be blockable.`nWARNING: Using force logoff may cause applications to lose data.`nDo you wish to force logoff?
Gosub,Menu
IfMsgBox,Yes
{
	Enabled = 0
	If Logon = 1
	FileAppend , Computer was Logoff by %A_UserName% on %A_DD%\%A_MM%\%A_YYYY% at %A_Hour%:%A_Min%:%A_Sec%.`n, Shutdown log.txt
	Shutdown,4
	ExitApp
}
IfMsgBox,No
Exit

FStandby:
Menu , Tray , DeleteAll
Msgbox,52,Force Standby?,This will not be blockable.`nWARNING: Using force standby may cause applications to lose data.`nOnly use if normal standby fails.`nDo you wish to force standby?
Gosub,Menu
IfMsgBox,Yes
{
	If Logon = 1
	FileAppend , Computer was Suspended by %A_UserName% on %A_DD%\%A_MM%\%A_YYYY% at %A_Hour%:%A_Min%:%A_Sec%.`n, Shutdown log.txt
	DllCall("PowrProf\SetSuspendState", "int", 0, "int", 1, "int", 1)
	Return
}
IfMsgBox,No
Exit

FHibernate:
Menu , Tray , DeleteAll
Msgbox,52,Force Hibernate?,This will not be blockable.`nWARNING: Using force hibernate may cause applications to lose data.`nOnly use if normal hibernate fails.`nDo you wish to force hibernate?
Gosub,Menu
IfMsgBox,Yes
{
	If Logon = 1
	FileAppend , Computer was Suspended by %A_UserName% on %A_DD%\%A_MM%\%A_YYYY% at %A_Hour%:%A_Min%:%A_Sec%.`n, Shutdown log.txt
	DllCall("PowrProf\SetSuspendState", "int", 1, "int", 1, "int", 1)
	Return
}
IfMsgBox,No
Exit

GuiClose:
Gui , Destroy
return

GuiSize:
Width1 := A_GuiWidth-20
Height1 := A_GuiHeight-145
Width2 := A_GuiWidth-10
Height2 := A_GuiHeight-125
GuiControl , Move, Button2 ,x5 y120 w%Width2% h%Height2%
GuiControl , Move, Edit1 , x10 y135 w%Width1% h%Height1%
return 

Reload:
Reload
Return

Exit:
If SELogon = 1
FileAppend , Shutdown Stopper exited by %A_UserName% on %A_DD%\%A_MM%\%A_YYYY% at %A_Hour%:%A_Min%:%A_Sec%.`n, Shutdown log.txt
ExitApp