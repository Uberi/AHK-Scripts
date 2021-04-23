
; -------------------------------------------
; NetKeeper Infiltrator
; ver. 1.7 alpha
; NetKeeper Infiltrator.ahk
; 
; Wrote by Augusto Croppo
;
; Started in Nov 2009
; augustocroppo@hotmail.co.uk
;
; Interpretation and compilation by AutoHotkey
; http://www.autohotkey.com/
; -------------------------------------------



; PICK-LOCK MODULE
; ****************
SetBatchLines, -1

#SingleInstance ignore
#NoTrayIcon
#Persistent

reloadmodule = 
writerunkey = 

Menu, TRAY, NoStandard
Menu, TRAY, DeleteAll

; SORT OUT THE INFILTRATION TASK
IfExist, C:\NetKeeper
{
	IfExist, C:\NetKeeper\NetKeeper.exe
	{
		IfExist, N:\Applications\Netkeeper\NetKeeper.exe
		{
			FileGetTime, time1, C:\NetKeeper\NetKeeper.exe, M
			FileGetTime, time2, N:\Applications\Netkeeper\NetKeeper.exe, M
			EnvSub, time2, %time1%, S
			if time2 > 1
			{
				Goto UpdateFiles
			}
			Else
			{
				Goto VerifyRegistry
			}
		}
		Else
		{
			ExitApp
		}
	}
	Else
	{
		Goto Install
	}
}
Else
{
	Goto Install
}

VerifyRegistry:
; SPY THE REGISTRY TO FIND THE RUN KEY
RegRead, verifyrunregistry, HKLM, SOFTWARE\Microsoft\Windows\CurrentVersion\Run, NetKeeper Startup
If Errorlevel
{
	Goto ForceRun
}
Else
{
	If verifyrunregistry <> C:\NetKeeper\NetKeeper.exe
	{
		Goto Install
	}
	Else
	{
		ExitApp
	}
}

Install:
; TRY TO INSERT A KEY INTO THE REGISTRY
If A_IsAdmin = 1
{
	FileCreateDir, C:\NetKeeper
	If ErrorLevel
	{
		ExitApp
	}
	Else
	{
		FileCreateDir, C:\NetKeeper\VMF
		Run %comspec% /C "cacls.exe C:\NetKeeper /e /t /c /g "Authenticated Users":F",, Hide UseErrorLevel
		If ErrorLevel
		{
			ExitApp
		}
		Else
		{
			writerunkey = 1
			Goto UpdateFiles
		}
	}
}
Else
{
	Goto ForceRun
}
	
UpdateFiles:
; DELIVER THE TOOLS AND MATERIALS
FileDelete, C:\NetKeeper\*.*
Loop, N:\Applications\Netkeeper\*.*, 0, 0
{
	if A_LoopFileAttrib contains H,S
		continue
	newline = "%A_LoopFileFullPath%","C:\NetKeeper\%A_LoopFileName%"`n`r
	copylist .= newline
	filecount += 1
}
If copylist <>
{	
	Process, Exist, NetKeeper.exe, 
	If ErrorLevel
	{
		Process, Close, NetKeeper.exe,
		reloadmodule = 1
	}
	Gui, Add, GroupBox, x11 y50 w282 h64 , 
	Gui, Font, S8 CDefault, Verdana
	Gui, Add, Text, x15 y12 w280 h30 center, NetKeeper is syncronizing with the central server to update itself in this terminal computer.
	Gui, Add, Progress, x20 y66 w265 h15 vProgress Range0-%filecount% BackgroundWhite,
	Gui, Add, Text, x22 y88 w260 h16 vCountup center,
	Gui, Show, x480 y274 center, NetKeeper Infiltrator!,
	Loop, Parse, copylist, `r
	{
		If A_LoopField <>
		{
			Loop, Parse, A_LoopField, CSV, "
			{
				If A_Index = 1
					source = %A_LoopField%
				If A_Index = 2
					target = %A_LoopField%
			}
			GuiControl,, Progress, +1
			FileCopy, %source%, %target%, 1
			if ErrorLevel
			{
				Continue
			}
			GuiControl,, Countup, %A_Index% of %filecount% files copied...
			countup += 1
			If %countup% >= %filecount%
				Break
		}
	}
	GuiControl,, Progress, +1
	Sleep 2000
	If writerunkey = 1
	{
		RegWrite, REG_SZ, HKEY_LOCAL_MACHINE, SOFTWARE\Microsoft\Windows\CurrentVersion\Run, NetKeeper Startup, C:\NetKeeper\NetKeeper.exe
		If Errorlevel
		{
			Goto ForceRun
		}
		GuiControl,, Countup, Logging off to load the NetKeeper!
		Sleep 2000
		Shutdown, 4
	}
	If reloadmodule = 1
	{
		GuiControl,, Countup, Reloading the NetKeeper!
		Sleep 2000
		Goto ForceRun
	}
	ExitApp
}

ForceRun:
; RUN INTO THE BUILDING IF THE KEY DO NOT WORK
IfExist, C:\NetKeeper\NetKeeper.exe
	Run %comspec% /C "start /b C:\NetKeeper\NetKeeper.exe",, Hide
ExitApp

GuiClose:
; JUST LEAVE WHEN THE INFILTRATION IS DONE
Return
