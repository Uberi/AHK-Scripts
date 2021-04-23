/*
 * * * Compile_AHK SETTINGS BEGIN * * *

[AHK2EXE]
Exe_File=%In_Dir%\AVNotifyDisabler.exe
NoDecompile=1
Execution_Level=4
[VERSION]
Set_Version_Info=1
Company_Name=ladiko
File_Description=AVNotify Disabler
File_Version=0.0.0.3
Inc_File_Version=0
Internal_Name=AVNotifyDisabler.ahk
Legal_Copyright=(c) ladiko
Original_Filename=AVNotifyDisabler.ahk
Product_Name=AVNotifyDisabler
Product_Version=1.0.48.5
Set_AHK_Version=1
[ICONS]
Icon_1=%In_Dir%\AVNotifyDisabler.ahk_1.ico
Icon_2=0
Icon_3=0
Icon_4=0
Icon_5=0
Icon_6=0
Icon_7=0

* * * Compile_AHK SETTINGS END * * *
*/

#NoTrayIcon
#NoEnv ; Recommended for performance and compatibility with future AutoHotkey releases.
#SingleInstance force ; Run script only one time in memory
SendMode Input ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir% ; Ensures a consistent starting directory.

LogEdit := "+++ Status quo:`n"
NotifyPath := GetNotifyPath()
GUID := CreateGUID()
TransparentEnableKey := "SOFTWARE\Policies\Microsoft\Windows\Safer\CodeIdentifiers"
PolicyKey := TransparentEnableKey . "\0\Paths"
RunKey := "SOFTWARE\Microsoft\Windows\CurrentVersion\Run"
Error = 0

OSStatus := CheckOSAdmin()
SplashStatus := CheckSplash()
NotifyStatus := CheckNotify()

Gui , Add , Text , Section w134 , AntiVir Start Splash Screen:
Gui , Add , Text , x+20 , AntiVir Notifier:

Gui , Add , Radio , xs y+5 vSplashEnabled , Enabled
Gui , Add , Radio , x+10 vSplashDisabled Checked , Disabled

Gui , Add , Radio , x+20 vNotifyEnabled Group , Enabled
Gui , Add , Radio , x+10 vNotifyDisabled Checked , Disabled

Gui , Add , Button , y+15 xs+23 vApplyBT gApply w88 h26 Disabled%OSStatus% , Apply
Gui , Add , Button , x+60 gGuiClose w88 h26 , Exit
Gui , Add , Text , xs y+15 , Log:
Gui , Add , Edit , xs y+5 vLogEdit HScroll ReadOnly -Wrap r5 w300 , %LogEdit%

GuiControl , , SplashEnabled , %SplashStatus%
GuiControl , , NotifyEnabled , %NotifyStatus%

Gui , Show

Return

/*
	# functions section
*/

Apply:
	Gui , Submit , NoHide
	NewSplashStatus := SplashEnabled
	NewNotifyStatus := NotifyEnabled
	
	If (NewSplashStatus <> SplashStatus)
		ChangeSplash(NewSplashStatus)
	If (NewNotifyStatus <> NotifyStatus)
		ChangeNotify(NewNotifyStatus)
	GuiControl , Disable , ApplyBT
Return

GuiClose:
GuiEscape:
	Gui , Destroy
	_EXIT_MSG()
Return

CheckOSAdmin()
{
	If (A_OSType = "WIN32_WINDOWS")
	{
		_ERROR("This program cannot be run on your system cause " . A_OSVersion . " does not support software restriction policies.`n`nSorry!")
		Return 1
	}

	If (!A_IsAdmin)
	{
		_ERROR("Please start this program with administrator privileges.")
		Return 1
	}
	
	Return 0
}

CheckNotify()
{
	Global
	
	Loop, HKLM , %PolicyKey% , 2
	{
		RegRead , CurrentPath , HKLM , %PolicyKey%\%A_LoopRegName% , ItemData
		IfInString , CurrentPath , \avnotify.exe
		{
			RegRead , CurrentFlags , HKLM , %PolicyKey%\%A_LoopRegName% , SaferFlags
			If (CurrentFlags = 0) {
				_LOG_EDIT("Activ software restriction policy found: HLKM\" . PolicyKey . "\" . A_LoopRegName)
				Return , 0
			}
		}
	}
	_LOG_EDIT("No activ software restriction policy found.")
	Return , 1
}

CheckSplash()
{
	Global
	
	RegRead , avgnt , HKLM , %RunKey% , avgnt
	StringRight , params , avgnt , 8
	If (params = "/min /ns" || params = "/nosplash")
	{
		_LOG_EDIT("avgnt.exe is started without splash: """ . params . """")
		Return , 0
	}
	Else {
		_LOG_EDIT("avgnt.exe is started without /ns or /nosplash -> splash enabled.")
		Return , 1
	}
}

ChangeNotify(NewStatus)
{
	Global

	; fix for a group policy bug from http://support.microsoft.com/kb/828538
	RegDelete , HKCU , Software\Microsoft\Windows\CurrentVersion\Group Policy Objects
	_LOG_EDIT("+++ Change notifier settings`nFix for group policy bug from http://support.microsoft.com/kb/828538`nDelete: HKCU\Software\Microsoft\Windows\CurrentVersion\Group Policy Objects")

	If (NewStatus)
	{	
		; delete existing Policies and re-enable AVNotify
		_LOG_EDIT("Delete existing policies to enable avnotify.exe")
		Loop, HKLM , %PolicyKey% , 2
		{
			RegRead , CurrentPath , HKLM , %PolicyKey%\%A_LoopRegName% , ItemData
			IfInString , CurrentPath , \avnotify.exe
			{
				RegRead , CurrentFlags , HKLM , %PolicyKey%\%A_LoopRegName% , SaferFlags
				If (CurrentFlags = 0)
				{
					RegDelete , HKLM , %PolicyKey%\%A_LoopRegName%
					If ErrorLevel
						_ERROR("Error while writing to registry:`nHKLM\" . PolicyKey . "\" . A_LoopField)
					_LOG_EDIT("Deleted: HKLM\" . PolicyKey . "\" . A_LoopRegName)
				}
			}
		}
		_LOG_EDIT("AVNotify is re-enable.`n`nYou have to log off and on again or reboot for the changes to take effect.")
	}
	Else
	{
		; enable software restriction policies
		_LOG_EDIT("Enable software restricion policies:`nRegWrite: HKLM\" . TransparentEnableKey . " -> TransparentEnable = 1")
		RegWrite , REG_DWORD , HKLM , %TransparentEnableKey% , TransparentEnable , 1
		
		; create policy entries to disable AVNotify
		_LOG_EDIT("Add policy:")
		_LOG_EDIT("HKLM " . PolicyKey . "\" . GUID . " -> ItemData = " . NotifyPath . "avnotify.exe")
		_LOG_EDIT("HKLM " . PolicyKey . "\" . GUID . " -> Description = Disable AVNotify by AVNotifyDisabler")
		_LOG_EDIT("HKLM " . PolicyKey . "\" . GUID . " -> SaferFlags = 0")

		RegWrite , REG_SZ, HKLM , %PolicyKey%\%GUID% , ItemData , %NotifyPath%avnotify.exe
		RegWrite , REG_SZ, HKLM , %PolicyKey%\%GUID% , Description , Disable AVNotify by AVNotifyDisabler
		RegWrite , REG_DWORD , HKLM , %PolicyKey%\%GUID% , SaferFlags , 0
		If ErrorLevel
			_ERROR("Error while writing to registry:`nHKLM\" . PolicyKey . "\" . GUID)
		Else
			_LOG_EDIT("AVNotify is disabled.`n`nYou have to log off and on again or reboot for the changes to take effect.")
	}
	Return
}

ChangeSplash(NewStatus)
{
	; disable antivir splash screen
	Global
	_LOG_EDIT("+++ Change splash settings")
	
	If (NewStatus)
	{
		_LOG_EDIT("Remove command line options /ns and /nosplash:")
		_LOG_EDIT("RegWrite: HKLM\" . RunKey . " -> avgnt = " . avgnt)
		
		StringReplace , avgnt , avgnt , %A_Space%/ns
		StringReplace , avgnt , avgnt , %A_Space%/nosplash
		RegWrite , REG_SZ , HKLM , %RunKey% , avgnt , %avgnt%
		If ErrorLevel
			_ERROR("Error while writing to registry:`nHKLM\" . RunKey . " -> avgnt")
	}
	Else
	{
		_LOG_EDIT("Add command line options:")
		FileGetVersion , avgnt_version , %NotifyPath%avgnt.exe
		_LOG_EDIT("File version of avgnt.exe is " . avgnt_version)
		
		If (comp_FileVersion(avgnt_version, "9.0.0.0") < 0)
			ns_param := " /nosplash"
		Else
			ns_param := " /ns"
		_LOG_EDIT("Use parameter" . ns_param)
		_LOG_EDIT("RegWrite: HKLM\" . RunKey . " -> avgnt = " avgnt . ns_param)
		RegWrite , REG_SZ , HKLM , %RunKey% , avgnt , %avgnt%%ns_param%
		If ErrorLevel
			_ERROR("Error while writing to registry:`nHKLM\" . RunKey . " -> avgnt")
	}
	Return
}

GetNotifyPath()
{
	Global
	
	IfExist , %A_ScriptDir%\avnotify.exe
		AntiVirPath = %A_ScriptDir%\
	Else
	{
		RootKey = Software\H+BEDV
		Loop, HKLM , %RootKey% , 2
		{
			RegRead , AntiVirPath , HKLM , %RootKey%\%A_LoopRegName% , Path
		}
		If AntiVirPath =
		{
			RootKey = Software\Avira
			Loop, HKLM , %RootKey% , 2
			{
				RegRead , AntiVirPath , HKLM , %RootKey%\%A_LoopRegName% , Path
			}
		}
		If AntiVirPath = 
			_ERROR("AntiVir is not installed properly.")
	}
	
	IfNotExist , %AntiVirPath%avnotify.exe
		_ERROR("""" . AntiVirPath . "avnotify.exe"" not found.")
	Else {
		_LOG_EDIT("AntiVir is in " . AntiVirPath . "")
		Return %AntiVirPath%
	}
}
_LOG_EDIT(sMSG)
{
	Global
	
	If Error
		Return 1
	
	LogEdit .= sMSG . "`n"
	GuiControl , , LogEdit , %LogEdit%
	
	Return
}

_ERROR(sMSG)
{
	Global
	
	_LOG_EDIT("ERROR: " . sMSG)
	
	Error = 1
	
	Return
}

_EXIT_MSG()
{
	Msgbox , Send your questions and suggestions to: ladiko@go.to
	ExitApp
}

CreateGUID()
{
	VarSetCapacity(Guid, 16, 0)    ; GUID structure itself.
	VarSetCapacity(szGuid, 39, 0)  ; Its string representation.

	DllCall("ole32\CoCreateGuid", "uint", &Guid)
	DllCall("ole32\StringFromCLSID", "uint", &Guid, "uint *", pOleStr)

	DllCall("WideCharToMultiByte", "uint", 0, "int", 0, "uint", pOleStr
								 , "int", -1, "str", szGuid, "uint", 39
								 , "int", 0, "int", 0)

	DllCall("ole32\CoTaskMemFree", "uint", pOleStr)
	
	StringLower, szGuid, szGuid

	Return , szGuid
}

comp_FileVersion(A, B)
{
   StringSplit, A, A, .
   StringSplit, B, B, .
   loop, %A0%
   {
      if (A%A_Index% > B%A_Index%)
         return , 1
      if (A%A_Index% < B%A_Index%)
         return , -1
   }
   return , 0
}