/*
[CONFIG]
#__SET__VERSION_=1.0.00.14
*/
/*
[SCRIPT]
*/
Suspend, On
Gui, 11:+LastFound
SetWorkingDir % A_ScriptDir
#__MAIN_HWND_ := WinExist()
#__SET__USER_VARIABLES_ = #__SET__AUTOSTART_|#__SET__WEBBROWSER_|#__SET__EDITOR_|#__SET__GLOBAL_EXT_|#__SET__DIRECTORIES_|#__SET__COLOR_B_|#__SET__COLOR_T_|#__SET__PROPOSAL_|#__SET__FILE_REMINDER_|#__SET__RELOAD_AHK_ON_CHANGE_|#_XPOS_|#_YPOS_|#__SET__AUTOHOTSTRING_|#__SET__HOTSTRING_RUN_|#__SET__HOTSTRING_EDIT_|#__SET__HOTSTRING_SHOW_|#__SET__HOTSTRING_COPY_PATH_|#__SET__HOTSTRING_COPY_DIR_|#__SET__HOTSTRING_MAX_|#__SET__FAVORITS_|#__SET__PROFILES_|#__SET__LANGUAGE_|#__SET__WILDCARD_|#__SET__USECAPSLOCK_|#__SET__HOTSTRING_END_CHAR_|#__SET__WARN_ON_AUTOHOTSTRING_|#__SET__HOTSTRING_OPTION_|#__SET__PROPOSAL_TIMEOUT_|#__SET__WEB_|#__SET__BALLOON_|#__SET__CLICKTROUGH_|#__SET__STANDARD_TOOLTIP_|#__SET_RUN_AHK_AS_EXE_|#__SET_SUGGEST_WEB_|#__SET__PRELOAD_STDOUTTOVAR_|#__SET__PRELOAD_FILEEXPLORER_|#__SET__HOTKEYS_|#__SET__CHECKFORUPDATE_|#__SET__USE_CHORDING_|#__SET__KEYWORD_ENDCHAR_|#__SET__CHORDING_LENGTH_|#__SET__EXPLORER_SEARCH_

#__HELP_MENU = #__HELP_MENU_AutoHotFile|#__HELP_MENU_General_hotkeys|#__HELP_MENU_KeywordLauncher|#__HELP_MENU_Explorer|#__HELP_MENU_Prefix|#__HELP_MENU_Autostart|#__HELP_MENU_Autohotstring|#__HELP_MENU_File_Reminder|#__HELP_MENU_Reload_scripts|#__HELP_MENU_WebBrowser|#__HELP_MENU_Editor|#__HELP_MENU_WorkingDir|#__HELP_MENU_WorkingExtensions|#__HELP_MENU_Suggest|#__HELP_MENU_Advanced|#__HELP_MENU_Profiles

AutoTrim, Off
#SingleInstance ignore
DetectHiddenWindows, On


#MaxThreadsPerHotkey 1
#HotkeyModifierTimeout 0
#NoEnv

#InstallKeybdHook
#UseHook

SetBatchLines -1
SetWinDelay, -1

OnMessage(0x9999, "#__Exit_Launcher")
OnMessage(0x4a, "IPC_OnCopyData")
OnMessage(0x4e,"WM_NOTIFY")
OnMessage(0x0218, "OnPBMsg")

OnExit, OnExit

Process, Exist
#__OWN_PID_ = %Errorlevel%

If A_IsCompiled
{
	FileInstall,_AutoHotFile.exe,_AutoHotFile.exe
	#__INI_FILE_ := SubStr(A_ScriptName, 1, InStr(A_ScriptName, ".",0,0)) . "ini"
	If (FileExist(#__INI_FILE_) = "")
	{
		FileAppend, [CONFIG], %#__INI_FILE_%
	}
	#__AHK_EXE_ = %A_WorkingDir%\_AutoHotFile.exe
	#pData:=0
	#DataSize:=0
	If FileExtract_ToMem(">AUTOHOTKEY SCRIPT<", #pData, #DataSize)
	|| FileExtract_ToMem(">AHF WITH ICON<", #pData, #DataSize)
		#__MAIN_SCRIPT_Str_N:=GetStrN(#pData, #DataSize)
} Else {
	#__INI_FILE_ = %A_ScriptFullPath%
	#__AHK_EXE_ = %A_AhkPath%
	FileRead,#__MAIN_SCRIPT_Str_N,%A_ScriptFullPath%
}

Loop, Parse, #__SET__USER_VARIABLES_, |
	IniRead, %A_LoopField%, %#__INI_FILE_%,CONFIG, %A_LoopField%,%A_Space%
IniRead,#__SET__VERSION_,%#__INI_FILE_%,Config,#__SET__VERSION_,0

Gosub, #__LOAD_PIPES_

If A_AhfVersion
{
	Gosub, CheckForUpdate
	Gosub, #__LOAD_PIPES_
}
IniRead,#__SET__VERSION_,%#__INI_FILE_%,Config,#__SET__VERSION_,0

#__FILE_COUNT_0 = 0
#__SizeOf_FNI_ := ( 1024 * 64 )

#_hIcon_1:=MI_Extracticon(A_AhkPath,1,16)
#_hIcon_2:=MI_Extracticon(A_AhkPath,3,16)
#_hIcon_3:=MI_Extracticon(A_AhkPath,6,16)
#_hIcon_4:=MI_ExtractIcon(A_WinDir . "\system32\calc.exe",1,16)

Gosub, #__Create_Help

Loop, Parse, #__SET__USER_VARIABLES_, |
{
	If (%A_LoopField% ="")
	{
		If A_LoopField in #__SET_RUN_AHK_AS_EXE_,#__SET__HOTSTRING_MAX_,#__SET__FAVORITS_,#__SET__LANGUAGE_,#__SET__WILDCARD_,#_XPOS_,#_YPOS_,#__SET_SUGGEST_WEB_,#__SET__DIRECTORIES_,#__SET__PRELOAD_STDOUTTOVAR_,#__SET__PRELOAD_FILEEXPLORER_,#__SET__HOTSTRING_END_CHAR_,#__SET__CHECKFORUPDATE_,#__SET__USE_CHORDING_,#__SET__CHORDING_LENGTH_,#__SET__KEYWORD_ENDCHAR_,#__SET__EXPLORER_SEARCH_
			continue
		GoSub, #__CREATE_SETTINGS_
		SetTimer, Continue_StartUP, -200
		IfMsgBox Yes
		MsgBox, 0, SETTINGS, Standard AutoHotFile settings were applied`nChange settings and click save settings.`n`nCheck Tab file patterns where you can add folders to scan/watch for.`nYou should set your WebBrowser and Editor as well.`nPress Ok to proceed.
		else
			MsgBox, 0, SETTINGS, Standard AutoHotFile Einstellungen wurden geladen.`n`nÄndern Sie die gewünschten Einstellungen.`nIm Reiter File patterns sollten Sie die Ordner festlegen in welchen nach Dateien gesucht wird.`nEbenfalls sollten Sie den Webbrowser und Editor auswählen.`nDrücken Sie OK um fortzufahren.
		Return
	}
}
Continue_StartUP:
mwt_MaxWindows = 50
mwt_MaxLength = 200

#SUN := 1, #MON := 2, #TUE := 3, #WED := 4, #THU := 5, #FRI := 6, #SAT := 7
#__FILES_CHANGED_:=0

Hotkey, ~CapsLock, CAPSLOCK, % #__SET__USECAPSLOCK_ = "OFF" ? "On" : "Off"
If #__SET__USECAPSLOCK_ = OFF
	SetCapsLockState,AlwaysOff

Gosub,CreateToolTip

ToolTip("StartUp","Please wait while loading settings.`nPress any F key (F2) to select a profile before loading!","AutoHotFile","xTrayIcon yTrayIcon O1 Q1 C1 H1 P11 I" . #_hIcon_2)

If #__SET__LANGUAGE_ = DE
	#__START_UP_ =  - ESCAPE = ABBRECHEN`n- CTRL+H = HILFE
else
	#__START_UP_ =  - ESCAPE = CANCEL`n- CTRL+H = HELP

If (#__SET__HOTSTRING_MAX_ > 39 OR #__SET__HOTSTRING_MAX_ = "")
	#__SET__HOTSTRING_MAX_ = 39

Gosub, #__Create_Hotkeys_and_Menu

StringSplit, #__SET__DIRECTORIES_TO_LOAD_, #__SET__DIRECTORIES_, |
StringSplit, #__SET__GLOBAL_EXT_TO_LOAD_, #__SET__GLOBAL_EXT_, |

Input, #__TEMP_VAR, V L1 T2, {Escape}{AppsKey}{ALT}{LWIN}{RWIN}{SHIFT}{CapsLock}{NumLock}{LControl}{LAlt}{LShift}{Tab}{Backspace}{Enter}{Left}{Right}{Up}{Down}{Delete}{Insert}{Escape}{Home}{End}{PgUp}{PgDn}{Numpad0}{Numpad1}{Numpad2}{Numpad3}{Numpad4}{Numpad5}{Numpad6}{Numpad7}{Numpad8}{Numpad9}{NumpadDot}{NumpadDiv}{NumpadMult}{NumpadAdd}{NumpadSub}{NumpadEnter}{NumpadIns}{NumpadEnd}{NumpadDown}{NumpadPgDn}{NumpadLeft}{NumpadClear}{NumpadRight}{NumpadHome}{NumpadUp}{NumpadPgUp}{NumpadDel}{NumpadDiv}{NumpadMult}{NumpadAdd}{NumpadSub}{NumpadEnter}{F1}{F2}{F3}{F4}{F5}{F6}{F7}{F8}{F9}{F10}{F11}{F12}{F13}{F14}{F15}{F16}{F17}{F18}{F19}{F20}{F21}{F22}{F23}{F24}{Pause}{Break}{PrintScreen}{LWin}{RWin}{RControl}{RAlt}{RShift}{Space}
If InStr(ErrorLevel,"EndKey:F")
	Gosub, Quickprofile
else
	#__LOAD_FILES()

SetTimer, #__START_UP_TOOLTIP, -500

EmptyMem()

SetTimer, WatchFolder, -1000
SetTimer, EmptyMem, 30000
If #__SET__FILE_REMINDER_ = ON
	SetTimer, #__FILE_REMINDER, 5000
Sleep, 400
Suspend, Off
Return
;#################################################################################################
;#                                   END OF AUTOEXECUTE SECTION                                  #
;#################################################################################################
Return:
Return

#__KEYWORD_LAUNCHER:
{
	WaitKeysUp(A_ThisHotkey)
	#__Exit_Launcher_ =
	If #__SPEEDHOTKEY_STATE_ = On
		Toggle_Speed_Hotkey()
	#__TOGGLE_MASTER_HOTKEYS()
	SetCapsLockState, Off
	;SetTimer, Watchfolder, Off
	ToolTip(5,#__START_UP_, "AutoHotFile","GTTM_TRACKPOSITION.TTM_TRACKACTIVATE L1 I" . #_hIcon_3 . " X" . #_XPOS_ . " Y" . #_YPOS_)
	Loop
	{
		;OutputDebug %A_TickCount% Input Activated
		Input, #_INPUT_VAR, L1 M, {ENTER}{ESC}{BS}{F1}{F2}{F3}{F4}{F5}{F6}{F7}{F8}{F9}{F10}{F11}{F12}{TAB}{DOWN}{UP}{PgUp}{PgDn}{DEL}{PrintScreen}{CAPSLOCK}{Left}{Right}
		SetTimer, ShowFound, Off
		SetTimer, #__SHOW_TOOL_TIP, Off
		;OutputDebug %A_TickCount% key pressed %#_INPUT_VAR%
		#__MOD_STATE_ := GetKeyState("CTRL", "P") . GetKeyState("ALT", "P")
		If ErrorLevel in NewInput,EndKey:Escape
				Hide(0)
		else If (ErrorLevel != "EndKey:Down" and ErrorLevel != "EndKey:Up" and ErrorLevel != "EndKey:Right" and ErrorLevel != "EndKey:Left")
			#_loop_add_to_index = 1
		If (ErrorLevel != "EndKey:PgUp" and ErrorLevel != "EndKey:PgDn")
			#__saved =
		If (#__CURRENT_VAR =  "" and ErrorLevel = "EndKey:Tab") {
			Send % (GetKeyState("LWin","P") ? "!" : "") . (GetKeyState("SHIFT","P") ? "+" : "") . (GetKeyState("CTRL","P") ? "^" : "") . (GetKeyState("ALT","P") ? "!" : "") . "{Tab}"
			Hide(0)
		} else If (#__MOD_STATE_ = "00") {
			if Errorlevel = Max
					#__CURRENT_VAR .= #_INPUT_VAR
			else if Errorlevel = EndKey:Delete
				#__CURRENT_VAR =
			else if ErrorLevel = EndKey:PrintScreen
				Send, {PrintScreen}
			else if ErrorLevel = EndKey:PgUp
				GoSub, #__GET_PREVIOUS
			else if (ErrorLevel = "EndKey:PgDn")
				Gosub, #__GET_NEXT
			else if (Errorlevel = "EndKey:Enter") {
				If #__CURRENT_VAR =
					Hide(1)
				Gosub, #__SAVE_CURRENT
				InfoOpening(#__CURRENT_VAR)
				GoTo, #__Run_Var
			} else if Errorlevel = EndKey:Backspace
				StringTrimRight, #__CURRENT_VAR, #__CURRENT_VAR, 1
			Else if (Errorlevel = "EndKey:CapsLock") {
				If !#__CURRENT_VAR
					Gosub, #__SAVE_CURRENT
				Hide(0)
			} Else if (ErrorLevel = "EndKey:Tab") {
				If (GetKeyWord(#_found_script1) = #__CURRENT_VAR)
				{
					Gosub, #__SAVE_CURRENT
					InfoOpening(#__CURRENT_VAR)
					GoTo, #__Run_Var
				}
				else if (#_found_script1 != "" and #__CURRENT_VAR != "")
					#__CURRENT_VAR := GetKeyWord(#_found_script1)
			} else if (InStr(Errorlevel, "EndKey:F") and #__CURRENT_VAR != "") {
				saveouttemp = %#__CURRENT_VAR%
				#_script_found_index := SubStr(ErrorLevel, 9)
				If #_found_script%#_script_found_index% =
					continue
				If GetKeyState("SHIFT","P")
				{
					#__CURRENT_VAR := GetKeyWord(#_found_script%#_script_found_index%)
					Goto, #__SHOW_TOOL_TIP_AGAIN
				}
				Gosub, #__SAVE_CURRENT
				#__CURRENT_VAR := GetKeyWord(#_found_script%#_script_found_index%)
				InfoOpening(#__CURRENT_VAR)
				GoTo, #__Run_Var
		} else if ((ErrorLevel = "EndKey:Left" or ErrorLevel = "EndKey:Right") and #__URL_OUT_ != "") {
				If (#__URL_VAR_=#__CURRENT_VAR)
				{
					If (ErrorLevel = "EndKey:Right"){
						If (#__SET__PROPOSAL_ > 1)
							#_loop_add_to_index += #__SET__PROPOSAL_ - 1
						else
							#_loop_add_to_index += #__SET__PROPOSAL_
					} else {
						If	#__SET__PROPOSAL_ > 1
							#_loop_add_to_index -= #__SET__PROPOSAL_ - 1
						Else
							#_loop_add_to_index -= #__SET__PROPOSAL_
					}
					#__Suggest_Script_=
					#__Cound_Found_Scripts_=
					Loop,Parse,#__URL_OUT_,`n
					{
						If (#_loop_add_to_index>A_Index or SubStr(A_LoopField,InStr(A_LoopField,">",1,0)+1)="" or SubStr(A_LoopField,InStr(A_LoopField,">",1,0)+1)=" " or InStr(A_LoopField,"Im&nbsp;Cache",1))
							continue
						else If (#__Cound_Found_Scripts_+1>#__SET__PROPOSAL_)
							Break
						#__Cound_Found_Scripts_++
						#_found_script%#__Cound_Found_Scripts_%:=SubStr(A_LoopField,1,InStr(A_LoopField,"""",1)-1)
						#__Suggest_Script_ .= "`nF" . #__Cound_Found_Scripts_ . A_Space . SubStr(A_LoopField,InStr(A_LoopField,">",1,0)+1) . " -> " . SubStr(A_LoopField,1,InStr(A_LoopField,"/",1,8)-1)
					}
					If (#__Suggest_Script_!="")
					{
						ToolTip(5,#_WEB_PREFIX_1 . SubStr(#__CURRENT_VAR,2) . #_WEB_PREFIX_2 . "`n" . #__Suggest_Script_,#__CURRENT_VAR,"G1 L1 I" . #_hIcon_3)
						continue
					}
				}
			} else if (ErrorLevel = "EndKey:Down" and #__CURRENT_VAR != "") {
				If (#_Prefix_found_:=InStr(#_Prefix_:="/\<>|",SubStr(#__CURRENT_VAR,1,1)))
				{
					StringTrimLeft,#_Prefix_,#_Prefix_,%#_Prefix_found_%
					#_Prefix_found_=.
					Loop,Parse,#_Prefix_
						If RegExMatch(#__SET__WEB_,StringToRegex(A_LoopField) . "(http:.*)") {
							#_Prefix_found_ = %A_LoopField%
							break
						}
					#__CURRENT_VAR := SubStr(#_Prefix_found_,1,1) . SubStr(#__CURRENT_VAR,2)
				} else If (#__SET__PROPOSAL_ > 1)
					#_loop_add_to_index += #__SET__PROPOSAL_ - 1
				else
					#_loop_add_to_index += #__SET__PROPOSAL_
			} else if (ErrorLevel = "EndKey:Up" and #__CURRENT_VAR != "") {
				If (#_Prefix_found_:=InStr(#_Prefix_:="|><\/",SubStr(#__CURRENT_VAR,1,1)))
				{
					StringTrimLeft,#_Prefix_,#_Prefix_,%#_Prefix_found_%
					#_Prefix_found_=³
					Loop,Parse,#_Prefix_
						If RegExMatch(#__SET__WEB_,StringToRegex(A_LoopField) . "(http:.*)") {
							#_Prefix_found_ = %A_LoopField%
							break
						}
					#__CURRENT_VAR := SubStr(#_Prefix_found_,1,1) . SubStr(#__CURRENT_VAR,2)
				} else If (#_loop_add_to_index < 0)
					#_loop_add_to_index =1
				else
					If	#__SET__PROPOSAL_ > 1
						#_loop_add_to_index -= #__SET__PROPOSAL_ - 1
					Else
						#_loop_add_to_index -= #__SET__PROPOSAL_
			}
		} else	{
			If ErrorLevel = Max
			{
				#_script_found_index = 1
				If (#__CURRENT_VAR != "" and (#_INPUT_VAR = "e" or Asc(#_INPUT_VAR) = 5))
				{
					Gosub, #__SAVE_CURRENT
					#_Run_Action:=#_INPUT_VAR="e" ? "explore" : "edit"
					If (DBArray("files","exist",#__CURRENT_VAR) != "")
						Run(DBArray("files","get",#__CURRENT_VAR),#_Run_Action), Hide(0)
					else Run(#_found_script%#_script_found_index%,#_Run_Action), Hide(0)
				} else if (Asc(#_INPUT_VAR) = 19 and #__CURRENT_VAR != "") {
					Gosub, #__SAVE_FAVORIT
				} else if (Asc(#_INPUT_VAR) = 4 and #__CURRENT_VAR != "" and InStr(#__SET__FAVORITS_, #__CURRENT_VAR)) {
					Gosub, #__DELETE_FAVORIT
				} else if (#_INPUT_VAR = "c" or Asc(#_INPUT_VAR) = 3) {
					If DBArray("files","exist",#__CURRENT_VAR)
						Clipboard := DBArray("files","Get",#__CURRENT_VAR)
					else if (SubStr(#__CURRENT_VAR, 1, 1) = "=")
						Clipboard := Eval(SubStr(#__CURRENT_VAR, 2))
					else if (SubStr(#__CURRENT_VAR, 1, 1) = "#")
						Clipboard := SubStr(#__CMD_COMMAND_, InStr(#__CMD_COMMAND_, "`n"))
					else if InStr(#__CURRENT_VAR,"`n")
						Clipboard = %#__CURRENT_VAR%
					else if (#__CURRENT_VAR != "" and #__Cound_Found_Scripts_ != "")
						Clipboard := #_found_script1
					else if (#__CURRENT_VAR != "")
						Clipboard := DBArray("files","get",#__CURRENT_VAR)
					else
						continue
					Hide(0)
				} else if (#_INPUT_VAR = "v" or Asc(#_INPUT_VAR) = 22) {
					#__CURRENT_VAR .= clipboard
				} Else if (#_INPUT_VAR = "h" or Asc(#_INPUT_VAR) = 8) {
					ToolTip(5,#_info_help,"Help","G1 L1 I" . #_hIcon_3)
					KeyWait, CTRL
				} else if (#_INPUT_VAR = "r" or Asc(#_INPUT_VAR) = 18) {
					GoTo, #__RELOAD
				} else if (#_INPUT_VAR = "a" or Asc(#_INPUT_VAR) = 1)
					ExitApp
				Else
					#__CURRENT_VAR .= #_INPUT_VAR ;not assigned ctrl or alt + key action
			} else if (ErrorLevel = "EndKey:Enter")
					#__CURRENT_VAR .= "`n"
			Else if (InStr(Errorlevel, "EndKey:F") and #__CURRENT_VAR != "") {
				#_script_found_index := SubStr(ErrorLevel, 9)
				Gosub, #__SAVE_CURRENT
				#_Run_Action:= #__MOD_STATE_="01" ? "explore" : "edit"
				If #__MOD_STATE_ = 11
					Clipboard := GetDir(#_found_script%#_script_found_index%)
				else
					Run(#_found_script%#_script_found_index%,#_Run_Action)
				Hide(0)
			}
		}
		#__Cound_Found_Scripts_ =
		#__SHOW_TOOL_TIP_AGAIN:
		If RegExMatch(#__CURRENT_VAR, "^=$|^\*$|^:|^#$")
		{
			If (#__CURRENT_VAR = "*")
				ToolTip(5,"Match anywhere enabled!",#__CURRENT_VAR,"G1 L1 I" . #_hIcon_3)
			else if (SubStr(#__CURRENT_VAR,1,1) = ":")
				ToolTip(5,SubStr(#__CURRENT_VAR,2) . " ","Enter AutoHotkey command(s), (CTRL & ENTER new line).","G1 L1 I" . #_hIcon_3)
			else if (#__CURRENT_VAR = "=")
				ToolTip(5,"Enter Calculation`, e.g. (5+5)*0.3/(100+2)",#__CURRENT_VAR,"G1 L1 I" . #_hIcon_4)
			else if (SubStr(#__CURRENT_VAR,1,1) = "#") {
				If (StrLen(#__CURRENT_VAR) < 2)
					ToolTip(5,"Enter a cmd line entry.`nE.g. #ping www.google.de",#__CURRENT_VAR,"G1 L1 I" . #_hIcon_3)
			}
	} else if (Asc(#__CURRENT_VAR)=35) {
			#__StdoutToVar_SCRIPT := (#__SET__PRELOAD_STDOUTTOVAR_ ? (chr(239) . chr(187) . chr(191)) : "")
									. "`n" . PipeVariables()
									. "`n#__CURRENT_VAR = " . #__CURRENT_VAR
									. "`n" . #__StdOutToVar_Str_N
									. "`n" . #__Includes_Str_N
			If #__SET__PRELOAD_STDOUTTOVAR_
				#__RUN_STDOUTTOVAR_PIPE(#__StdoutToVar_SCRIPT)
			else
				#__StdoutToVar_PID := RunPipeByRef(#__StdoutToVar_SCRIPT,"AutoHotFile_CMD")
			WinWait, ahk_pid %#__StdoutToVar_PID%,,5
			If ErrorLevel
				Hide(0)
			ToolTip(5,"","","gTTM_POP")
			#__CURRENT_VAR =
			;Hotkey, ~CapsLock, Off
			Loop
			{
				IfWinNotExist, ahk_pid %#__StdoutToVar_PID%
					break
				KeyWait, Escape, D T0.001
				If !ErrorLevel
				{
					Process, Exist, %#__StdoutToVar_PID%
					If (Errorlevel != 0)
						Process, Close, %#__StdoutToVar_PID%
					#__Exit_Launcher_ = 1
				}
				KeyWait, Delete, DT0.001
				If !ErrorLevel
				{
					Process, Exist, %#__StdoutToVar_PID%
					If (Errorlevel != 0)
						Process, Close, %#__StdoutToVar_PID%
				}
			}
			If #__SET__PRELOAD_STDOUTTOVAR_
				#__StdoutToVar_PID := #__RUN_STDOUTTOVAR_PIPE(#__START_UP_,"AutoHotFile_CMD",1)
			;Hotkey, ~CapsLock,% #__SET__USECAPSLOCK_ = "On" ? "OFF" : "On"
			If (#__CURRENT_VAR != "")
				GoSub, 	#__SAVE_CURRENT
			If #__Exit_Launcher_ = 1
				Hide(0)
			Else if #__Exit_Launcher_ = 2
				Gosub, #__GET_PREVIOUS
			else if #__Exit_Launcher_ = 3
				Gosub, #__GET_NEXT
			else {
				#__CURRENT_VAR =
				Goto, #__SHOW_TOOL_TIP_AGAIN
			}
		} else if RegexMatch(#__CURRENT_VAR, "^[a-zA-z]:|^\\") {
			#__FILE_EXPLORER_SCRIPT := (#__SET__PRELOAD_FILEEXPLORER_ ? (chr(239) . chr(187) . chr(191)) : "")
									. "`n" . PipeVariables()
									. "`n#__CURRENT_VAR = " . #__CURRENT_VAR
									. "`n" . #__File_Explorer_Str_N
									. "`n" . #__Includes_Str_N
			If #__SET__PRELOAD_FILEEXPLORER_
				ShowExplorer_PIPE(#__FILE_EXPLORER_SCRIPT,"AutoHotFile_FE")
			else
				#__FILE_EXPLORER_PID := RunPipeByRef(#__FILE_EXPLORER_SCRIPT,"AutoHotFile_FE")
			WinWait, ahk_pid %#__FILE_EXPLORER_PID%,,5
			If ErrorLevel
				Hide(0)
			ToolTip(5,"","","gTTM_POP")
			#__CURRENT_VAR =
			;Hotkey, ~CapsLock, Off
			Loop
			{
				IfWinNotExist, ahk_pid %#__FILE_EXPLORER_PID%
					break
				KeyWait, Escape, DT0.001
				If !ErrorLevel
				{
					Process, Exist, %#__FILE_EXPLORER_PID%
					If (Errorlevel != 0)
						Process, Close, %#__FILE_EXPLORER_PID%
					#__Exit_Launcher_ = 1
				}
				KeyWait, Delete, DT0.001
				If !ErrorLevel
				{
					Process, Exist, %#__FILE_EXPLORER_PID%
					If (Errorlevel != 0)
						Process, Close, %#__FILE_EXPLORER_PID%
				}
			}
			If #__SET__PRELOAD_FILEEXPLORER_
				#__FILE_EXPLORER_PID := ShowExplorer_PIPE(#__START_UP_,"AutoHotFile_FE",1)
			;Hotkey, ~CapsLock,% #__SET__USECAPSLOCK_ = "On" ? "OFF" : "On"
			If (#__CURRENT_VAR != "")
				GoSub, #__SAVE_CURRENT
			If #__Exit_Launcher_ = 1
				Hide(0)
			Else if #__Exit_Launcher_ = 2
				Gosub, #__GET_PREVIOUS
			else if #__Exit_Launcher_ = 3
				Gosub, #__GET_NEXT
			else {
				#__CURRENT_VAR =
				Goto, #__SHOW_TOOL_TIP_AGAIN
			}
		} else if (#__CURRENT_VAR!="" and RegExMatch(#__SET__WEB_,StringToRegex(SubStr(#__CURRENT_VAR,1,1)) . "(http:.*)",#_WEB_PREFIX_)){
			If RegExMatch(#_WEB_PREFIX_1,".http:")
				#_WEB_PREFIX_1:=RegExReplace(#_WEB_PREFIX_1,".http:.*")
			If InStr(#_WEB_PREFIX_1," ")
				StringSplit,#_WEB_PREFIX_,#_WEB_PREFIX_1,%A_Space%
			Else
				#_WEB_PREFIX_2=
			If (#__SET_SUGGEST_WEB_ and StrLen(#__CURRENT_VAR)>1)
				SetTimer, #__UrlDownloadToVar_Launch,% (-1 * #__SET__PROPOSAL_TIMEOUT_)
			ToolTip(5,#_WEB_PREFIX_1 . SubStr(#__CURRENT_VAR,2) . #_WEB_PREFIX_2,#__CURRENT_VAR,"G1 L1 I" . #_hIcon_3)
		} else if (#__CURRENT_VAR != ""){
			ToolTip(5,"",#__CURRENT_VAR,"GTTM_TRACKPOSITION L1 I" . #_hIcon_3 . " X" #_XPOS_ . " Y" . #_YPOS_)
 			SetTimer, #__SHOW_TOOL_TIP,% (-1 * (#__SET__PROPOSAL_TIMEOUT_+50))
			;OutputDebug %A_TickCount% settimer placed %#__CURRENT_VAR%
		} else
			ToolTip(5,#__START_UP_, "AutoHotFile","GTTM_TRACKPOSITION.TTM_TRACKACTIVATE L1 I" . #_hIcon_3 . " X" . #_XPOS_ . " Y" . #_YPOS_)
		Loop % #__SET__PROPOSAL_
				#_found_script%A_Index%=
	}
Hide(0)
Return
}
#__SHOW_TOOL_TIP:
{
	;OutputDebug %A_TickCount% Timer activated
	If (Asc(#__CURRENT_VAR)=61){ ;=
		ToolTip(5, "=" . Eval(SubStr(#__CURRENT_VAR, 2)),#__CURRENT_VAR,"G1 L1 I" . #_hIcon_4)
	} else if (Asc(#__CURRENT_VAR)=63){ ;?
		#__Suggest_Script_ =
		#__Found_Scripts_ =
		#__Cound_Found_Scripts_ =
		Loop, Parse, #__SET__FAVORITS_, |
		{
			If InStr(A_LoopField, SubStr(#__CURRENT_VAR, 2))
			{
				#__Cound_Found_Scripts_++
				If (#__Cound_Found_Scripts_ < #_loop_add_to_index)
					continue
				#__Found_Scripts_++
				#_found_script%#__Found_Scripts_% = %A_LoopField%
				#__Suggest_Script_ .= "`nF" . #__Found_Scripts_ . A_Space . A_LoopField
				If (#__Found_Scripts_ > #__SET__PROPOSAL_-1)
					break
			}
		}
		ToolTip(5,#_SETTINGS_GUI_FAVORITENTRIES . #__Suggest_Script_,#__CURRENT_VAR,"G1 L1 I" . #_hIcon_3)
	} else {
		#__Suggest_Script_ =
		#__Found_Scripts_ = 1
		#_found_script := DBArray("files",((#__SET__WILDCARD_ or InStr(#__CURRENT_VAR, "*", 1)=1) ? "regex" : "find"),(InStr(#__CURRENT_VAR, "*", 1)=1 ? SubStr(#__CURRENT_VAR,2) : #__CURRENT_VAR),"",#__SET__PROPOSAL_,#_loop_add_to_index)
		If (#_found_script="")
		{
			ToolTip(5,#_SETTINGS_GUI_NOTFOUND,#__CURRENT_VAR,"G1 L1 I" . #_hIcon_2)
			Return
		}
		Loop,Parse,#_found_script,""
		{
			If !A_LoopField
				break
			#__Suggest_Script_ .= "`nF" . A_Index . A_Space . GetKeyWord(A_LoopField)
			#_found_script%A_Index%:=A_LoopField
			If InStr(A_LoopField,"`n"){
				Loop,Parse,A_LoopField,`n
					#__Suggest_Script_.=(A_Index=1 ? "`n" : "`n") . A_Tab . "<a>" . A_LoopField . "</a>"
			} else
				#__Suggest_Script_.=A_Tab . A_Tab . "<a " . A_LoopField . ">" GetFileName(A_LoopField) . "</a>"
			If (A_Index > #__SET__PROPOSAL_-1)
			break
		}
		;OutputDebug %A_TickCount% Value found
		SetTimer, ShowFound, % (-1 * #__SET__PROPOSAL_TIMEOUT_)
	}
	Return
}
ShowFound:
;OutputDebug %A_TickCount% ToolTip about to show
ToolTip(5,#__Suggest_Script_,#__CURRENT_VAR,"G1 L1 I" . GetAssociatedIcon(#_found_script1))
;OutputDebug %A_TickCount% ToolTip shown
Return
#__Exit_Launcher(wParam)
{
	global
	#__Exit_Launcher_ = %wParam%
	Return
}
UpdatePosition:
MouseGetPos, , , #_Win_AT_MOUSE
If (#_Win_AT_MOUSE!=#__TT_HWND_)
	ToolTip(5,"","","gTTM_TRACKPOSITION L1" . (#_XPOS_ ? (" X" . #_XPOS_) : "") . (#_YPOS_ ? (" Y" . #_YPOS_) : ""))
Return
Hide(fadeout=0)
{
	global
	If fadeout
		AnimateWindow(#__TT_HWND_,200,"HC")
	ToolTip(5,"","","gTTM_POP")
	Loop %#__SET__PROPOSAL_%
		#_found_script%A_Index% =
	#__CURRENT_VAR =
	#__saved =
	#__Exit_Launcher_ =
	#_PARAM_VAR=
	#__TOGGLE_MASTER_HOTKEYS("On")
	Input
	If #__SET__USECAPSLOCK_ = OFF
	{
		SetCapsLockState,Off
		SetCapsLockState,AlwaysOff
	}
	Suspend, Off
	Hotkey,~Escape,On
	Exit
}

WM_NOTIFY(wParam, lParam){
	ToolTip("",lParam,"")
}
ToolTipClose:
hide(0)
Return
ToolTip:
#_FILE:=ErrorLevel
SetTimer, ToolTipRun, -10
Input
Return

ToolTipRun:
#_MOD:=GetKeyState("CTRL","P") . GetKeyState("ALT","P")
Input
If #_File is integer
{
	SetProfile(#_File)
	Gosub, #__UNLOAD_FILES
	Gosub,#__RELOAD_FILES
} else if (RegExMatch(#_FILE,"https?://")=1){
	Web(#_FILE)
} else if FileExist(#_File){
	If #__CURRENT_VAR
	Gosub, #__SAVE_CURRENT	
	If (#_MOD="11")
		Clipboard:=#_FILE
	Else if (#_MOD="10")
		Edit(#_FILE)
	Else if (#_MOD="01")
		Explore(#_FILE)
	Else
		Open(#_File)
} else {
	If (#_MOD="11")
		Clipboard:=#_FILE
	Else if (#_MOD="10")
		Run(#_FILE,"edit")
	Else if (#_MOD="01")
		Run(#_FILE,"explore")
	Else
		Run(#_File)
}
Hide(0)
Return

#__SAVE_CURRENT:
	If (#__CURRENT_VAR != #__savedout1 and #__CURRENT_VAR !="")
	{
		Loop 49
		{
			#__countsave := (A_Index - 51)*-1
			#__countsave2 := (A_Index -50)*-1
			#__savedout%#__countsave% := #__savedout%#__countsave2%
		}
		#__savedout1 = %#__CURRENT_VAR%
	}
Return
#__GET_PREVIOUS:
	If #__saved > 0
	{
		#__saved -= 1
		#__CURRENT_VAR := #__savedout%#__saved%
		If #__savedout%#__saved% =
			#__saved =
	} else {
		#__CURRENT_VAR =
		#__count = 50
		Loop 50
		{
			If (#__savedout%#__count% !="")
			{
				#__saved = %#__count%
				#__CURRENT_VAR := #__savedout%#__count%
				break
			}
			#__count--
		}
	}
Return
#__GET_NEXT:
#__saved += 1
#__CURRENT_VAR := #__savedout%#__saved%
If #__savedout%#__saved% =
	#__saved =
Return
#__SAVE_FAVORIT:
{
	#__SET__FAVORITS_ .= "|" . #__CURRENT_VAR
	StringReplace, #__SET__FAVORITS_, #__SET__FAVORITS_, ||, |, A
	#__SET__FAVORITS_ := RegExReplace(#__SET__FAVORITS_, "\|$")
	#__SET__FAVORITS_ := RegExReplace(#__SET__FAVORITS_, "^\|")
	StringReplace, #__SET__FAVORITS_, #__SET__FAVORITS_, `%,% "``" . "`%", A
	StringReplace, #__SET__FAVORITS_, #__SET__FAVORITS_, `n,% "``" . "n", A
	StringReplace, #__SET__FAVORITS_, #__SET__FAVORITS_, `",% "``""", A
	StringReplace, #__SET__FAVORITS_, #__SET__FAVORITS_, ````,% "``", A
	IniWrite,%#__SET__FAVORITS_%, %#__INI_FILE_%, CONFIG, #__SET__FAVORITS_
Return
}
#__DELETE_FAVORIT:
{
	MsgBox, 262148, REMOVE FAVORIT,% "Do you really want to remove following favorit:`n" . #__CURRENT_VAR
	IfMsgBox No
		Return
	StringReplace, #__SET__FAVORITS_, #__SET__FAVORITS_,% #__CURRENT_VAR
	StringReplace, #__SET__FAVORITS_, #__SET__FAVORITS_, ||, |, A
	#__SET__FAVORITS_ := RegExReplace(#__SET__FAVORITS_, "\|$")
	#__SET__FAVORITS_ := RegExReplace(#__SET__FAVORITS_, "^\|")
	StringReplace, #__SET__FAVORITS_, #__SET__FAVORITS_, `%,% "``" . "`%", A
	StringReplace, #__SET__FAVORITS_, #__SET__FAVORITS_, `n,% "``" . "n", A
	StringReplace, #__SET__FAVORITS_, #__SET__FAVORITS_, `",% "``""", A
	StringReplace, #__SET__FAVORITS_, #__SET__FAVORITS_, ````,% "``", A
	IniWrite,%#__SET__FAVORITS_%, %#__INI_FILE_%, CONFIG, #__SET__FAVORITS_
Return
}
CheckForUpdate:
#_NEW_VERSION:=A_AhfVersion
SplitPath,A_AhkPath,#_AhkName
If #_AhkName=AutoHotFileUpdate.exe
	ExitApp
If #__SET__CHECKFORUPDATE_
	ToolTip(1," ","Checking Version Online","M1 B0000FF FFFFFFF I" . #_hIcon_3),#_Version_Online:=UrlDownloadToVar("http://www.autohotkey.net/~HotKeyIt/AutoHotFile/version.txt")
If (#__SET__CHECKFORUPDATE_ and #_Version_Online and #_Version_Online!=A_AhfVersion)
{
	ToolTip(1,"")
	MsgBox,262148,AutoHotFile Update,% (#__SET__LANGUAGE_="DE" ? "Neue Version ist verfügbar.`nJetzt aktualisieren?" : "New version is available online`nUpdate now?")
	IfMsgBox No
		Return
	#_DLD_PID:=RunPipe("URLDownloadToFile,"
					. "http://www.autohotkey.net/~HotKeyIt/AutoHotFile/AutoHotFile.exe,"
					. A_ScriptDir . "\AutoHotFileUpdate.exe","AutoHotFile_Download")
	Sleep, 500
	Loop
	{
		Loop, %A_ScriptDir%\AutoHotFileUpdate.exe
			ToolTip(1,(StrLen(#_progress)>40 ? (#_progress:=".") : (#_progress.=".")),"Downloading AutoHotFile.exe. " . A_LoopFileSizeKB . " KB","M1 B0000FF FFFFFFF I" . #_hIcon_3)
		Sleep, 500
		Process,Exist,%#_DLD_PID%
		If !ErrorLevel
			break
	}
	#_NEW_VERSION:=#_Version_Online
	Gosub, UpdateScript
}
If (!#__SET__VERSION_ or #__SET__VERSION_!=A_AhfVersion){
	FileCopy,%A_AhkPath%,%A_ScriptDir%\AutoHotFileUpdate.exe,1
	Gosub, UpdateScript
}
FileDelete,%A_ScriptDir%\AutoHotFileBackup.exe
FileDelete,%A_ScriptDir%\AutoHotFileUpdate.exe
ToolTip(1,"")
Return
CreateToolTip:
#__ToolTip_Options:=(#__SET__STANDARD_TOOLTIP_ ? " Q1" : "") . (#__SET__CLICKTROUGH_ ? " M1" : "") . " X" . #_XPOS_ . " Y" . #_YPOS_ " B" . #__SET__COLOR_B_ . " F" . #__SET__COLOR_T_ . " O" . #__SET__BALLOON_ . " L1 H1 P11 Q1 C1"
#__TT_HWND_:=ToolTip(5," ","","N1 " . #__ToolTip_Options)
ToolTip("ProcessTerminator"," ","","N1 " . #__ToolTip_Options . " H0")
Return
UpdateScript:
#_UPDATE_AUTOHOTFILE=
(
DetectHiddenWindows, On
SetBatchLines, 1
SetWorkingDir, %A_ScriptDir%
CoordMode,Mouse,Screen
WinWaitClose, ahk_id %#__MAIN_HWND_%
ToolTip(1,"Updating Script, please wait…","AutoHotFile Update","I1 B0000FF FFFFFFF M1 X" . A_ScreenWidth . " Y" . A_ScreenHeight)
If FileExist("%A_ScriptDir%\AutoHotFileUpdate.exe")	
{
	FileMove,%A_ScriptDir%\AutoHotFile.exe,%A_ScriptDir%\AutoHotFileBackup.exe,1
	If !ErrorLevel
		Loop
			If !FileExist("%A_ScriptDir%\AutoHotFile.exe")
				break
	Sleep, 100
	FileCopy,%A_ScriptDir%\AutoHotFileUpdate.exe,%A_ScriptDir%\AutoHotFile.exe,1
	If !ErrorLevel
		Loop
			If FileExist("%A_ScriptDir%\AutoHotFile.exe")
				break
}
ToolTip(1,"Restoring user settings, please wait…","AutoHotFile Update","I1 B0000FF FFFFFFF M1 X" . A_ScreenWidth . " Y" . A_ScreenHeight)
Sleep, 250
SetBatchLines, -1
#__SET__USER_VARIABLES_=%#__SET__USER_VARIABLES_%
#__SET__PROFILES_=%#__SET__PROFILES_%
)
Loop,Parse,#__SET__PROFILES_,|
{
	IniRead,#_TEMP_VAR,%#__INI_FILE_%, CONFIG,#__SET__PROFILES_%A_LoopField%_,%A_Space%
	#_UPDATE_AUTOHOTFILE.="`n#__SET__PROFILES_" . A_LoopField . "_=" . #_TEMP_VAR
}
Loop, Parse, #__SET__USER_VARIABLES_, |
{
	#_TEMP_VAR:=%A_LoopField%
	StringReplace,#_TEMP_VAR,#_TEMP_VAR,``t,````t,All
	StringReplace,#_TEMP_VAR,#_TEMP_VAR,``n,````n,All
	StringReplace,#_TEMP_VAR,#_TEMP_VAR,`%,```%,All
	StringReplace,#_TEMP_VAR,#_TEMP_VAR,`````%,```%,All
	#_UPDATE_AUTOHOTFILE.="`n" . A_LoopField "=" . #_TEMP_VAR
}
#_UPDATE_AUTOHOTFILE.="`nLoop,Parse,#__SET__USER_VARIABLES_,|`n`tIniWrite,`% `%A_LoopField`%," . A_ScriptFullPath . ",Config, `%A_LoopField`%"
#_UPDATE_AUTOHOTFILE.="`nLoop,Parse,#__SET__PROFILES_,|`n`tIniWrite,`% #__SET__PROFILES_`%A_LoopField`%_," . A_ScriptFullPath . ", Config, #__SET__PROFILES_`%A_LoopField`%_"
#_UPDATE_AUTOHOTFILE.="`nIniWrite," . #_NEW_VERSION . "," . A_ScriptFullPath . ",Config,#__SET__VERSION_`nRun," . A_ScriptDir . "\AutoHotFile.exe`nRun," . A_ScriptDir . "\AutoHotFile.exe`nExitApp`nWaitFileExtract:`nLoop`n{`n`nLoop," . A_ScriptFullPath . "`nfound:=A_LoopFileSize`nSleep, 500`nIf !found`n	continue`nelse If (found and found=foundsize)`nbreak`nfoundsize:=found`nfound=`n}`nReturn`nToolTip(1,""Finished!"",""AutoHotFile Update"",""I1 B0000FF FFFFFFF M1 X"" . A_ScreenWidth . "" Y"" . A_ScreenHeight)" . #__Includes_Str_N . #__UrlDownloadToVar_Str_N
If FileExist(A_ScriptDir . "\AutoHotFileUpdate.exe")	
{
	FileDelete,%A_ScriptFullPath%
	Loop
		If !FileExist(A_ScriptFullPath)
			break
	Run, %A_ScriptDir%\AutoHotFileUpdate.exe,,,#_UPDATE_PID
	WinWaitClose, ahk_id %#_UPDATE_PID%
	RunPipe(#_UPDATE_AUTOHOTFILE,"AutoHotFile_Update",A_ScriptDir . "\AutoHotFileUpdate.exe")
	Gosub, OnExit
	ExitApp
}
Return
#__UrlDownloadToVar_Launch:
	If #_UDTV_PID_
		Process,Close,%#_UDTV_PID_%
	#_UDTV_PID_=
	#__UrlDownloadToVar_SCRIPT := PipeVariables()
								. "`n#__URL_=" . #_WEB_PREFIX_1 . SubStr(#__CURRENT_VAR,2) . #_WEB_PREFIX_2
								. "`n#__CURRENT_VAR = " . SubStr(#__CURRENT_VAR,2)
								. "`n" . #__UrlDownloadToVar_Str_N . "`n" . #__Includes_Str_N
	#_UDTV_PID_:=RunPipeByRef(#__UrlDownloadToVar_SCRIPT,"AutoHotFile_UDTV")
Return
PipeVariables(){
	global
	local v
	v := "#NoTrayIcon"
	. "`n#__MAIN_PID_=" . #__OWN_PID_ 
	. "`n#__MAIN_HWND_=" . #__MAIN_HWND_
	. "`n#_hIcon_1=" . #_hIcon_1
	. "`n#_hIcon_2=" . #_hIcon_2
	. "`n#_hIcon_3=" . #_hIcon_3
	. "`n#__ToolTip_Options:=""" . #__ToolTip_Options . """"
	. "`n#_XPOS_=" . #_XPOS_ 
	. "`n#_YPOS_ = " . #_YPOS_ 
	. "`n#__SET__STANDARD_TOOLTIP_="  . #__SET__STANDARD_TOOLTIP_ 
	. "`n#__SET__EDITOR_ = " . #__SET__EDITOR_ 
	. "`n#__SET__PROPOSAL_TIMEOUT_=" . #__SET__PROPOSAL_TIMEOUT_ 
	. "`n#__SET__PROPOSAL_=" . #__SET__PROPOSAL_
	. "`n#__SET__USE_CHORDING_=" . #__SET__USE_CHORDING_
	. "`n#__SET__LANGUAGE_=" . #__SET__LANGUAGE_
	. "`n#__SET__CHORDING_LENGTH_=" . #__SET__CHORDING_LENGTH_
	. "`n#__SET__EXPLORER_SEARCH_=" . #__SET__EXPLORER_SEARCH_
	Return v
}




;*************************************************************************************************
;*                                      BLINK START UP TOOLTIP                                   *
;*************************************************************************************************
#__START_UP_TOOLTIP:
{
	ToolTip("StartUp","AutoHotFile loaded " . DBArray("files","count") . " keywords (files)`n`nPress Capslock + TAB to start KeyWord launcher`nPress Capslock + F9 for settings and help`nPress Capslock + Pause for AHK process terminator`n`nPress a key to continue","AutoHotFile finished loading","GTTM_TRACKPOSITION.TTM_TRACKACTIVATE xTrayIcon yTrayIcon I" . #_hIcon_1)
	SetTimer,Hide_StartUpToolTip, -5000
	Return
}

Hide_StartUpToolTip:
ToolTip("StartUp","","","gTTM_POP")
Return
StartUpToolTipClose:
Return






;*************************************************************************************************
;*                      SUBROUTINE WILL BE EXECUTED ON EXIT AND RELOAD                           *
;*************************************************************************************************
OnExit:
	If (#__HSS_PID_ != "")
	{
		Process, Exist, %#__HSS_PID_%
		If (Errorlevel != 0)
			Process, Close, %#__HSS_PID_%
	}
	DllCall("gdi32.dll\DeleteObject", UInt,h_region )
	DllCall("gdi32.dll\DeleteObject", UInt,hbm_buffer)
	DllCall("gdi32.dll\DeleteDC", UInt,hdc_frame )
	DllCall("gdi32.dll\DeleteDC", UInt,hdc_buffer)
	Gosub, mwt_RestoreAll
	WatchDirectory()
	ToolTip()
	Loop, Parse, #_hIcons, |
		If A_LoopField
			DllCall("DestroyIcon",UInt,%A_LoopField%)
	ExitApp
Return







;*************************************************************************************************
;*                           SUBROUTINE TO CREATE MENU AND HOTKEYS                               *
;*************************************************************************************************
#__Create_Hotkeys_and_Menu:
{
	Menu, tray, NoStandard
	Menu, Tray, Add, &Settings and help, #__SETTINGS
	Menu, tray, add, &Keyword launcher, #__KEYWORD_LAUNCHER
	Menu, tray, add, &Process terminator, #__PROCESS_TERMINATOR
	If (A_IsCompiled != 1)
		Menu, tray, add, &Edit script, #__EDIT_SCRIPT
	else
		Menu, tray, add, &Edit config, #__EDIT_SCRIPT
	Menu, tray, add, &List hotkeys, #__LIST_HOTKEYS
	Menu, tray, add, &Reload, #__RELOAD
	Menu, tray, add, &Suspend,Suspend
	Menu, tray, add
	Menu, tray, add, E&xit, OnExit
	Menu, tray, add
	Menu, Tray, Add, &Unhide All Hidden Windows, mwt_RestoreAll
	Menu, Tray, Add
	Menu, Tray, Default, &Keyword launcher
	Menu, Tray, Tip, AutoHotFile`n`nPress CapsLock + Tab to start`nPress CapsLock + F9 for settings and help
	
	#_HOTKEY_LABEL=RUNAUTOSTART|QUICKPROFILE|mwt_UnMinimize|mwt_Minimize|RUNCLIPBOARD|RESETTIMER|#__LIST_HOTKEYS|#__EDIT_SCRIPT|#__SETTINGS|Suspend|PAUSEAUTOHOTKEY|#__RELOAD|#__KEYWORD_LAUNCHER|#__SPEEDHOTKEY|#__Run_Var|RESOLVEVARIABLE|#__PROCESS_TERMINATOR
	StringSplit,#_HOTKEY_LABEL,#_HOTKEY_LABEL,|
	Loop,Parse,#__SET__HOTKEYS_,%A_Tab%
	{
		Hotkey,%A_LoopField%,% #_HOTKEY_LABEL%A_Index%,UseErrorLevel
		If ErrorLevel
			ToolTip(1,"Hotkey " . A_LoopField . " cannot be used","Invalid hotkey: " . A_LoopField,"I3 B00FF00 M1 D3")
		If A_Index=6
			If #__SET__FILE_REMINDER_ = Off
				Hotkey, %A_LoopField%, OFF
	}
	Hotkey, ~CapsLock, CAPSLOCK, % #__SET__USECAPSLOCK_ = "On" ? "OFF" : "On"
	Loop 10
		Hotkey,% "NUMLOCK & NUMPAD" . (A_Index - 1), #__RUN_NUMLOCK
	Hotkey, NUMLOCK & NUMPADINS, #__RUN_NUMLOCK
	Hotkey, NUMLOCK & NUMPADRIGHT, #__RUN_NUMLOCK
	Hotkey, NUMLOCK & NUMPADEND, #__RUN_NUMLOCK
	Hotkey, NUMLOCK & NUMPADDOWN, #__RUN_NUMLOCK
	Hotkey, NUMLOCK & NUMPADPGDN, #__RUN_NUMLOCK
	Hotkey, NUMLOCK & NUMPADLEFT, #__RUN_NUMLOCK
	Hotkey, NUMLOCK & NUMPADCLEAR, #__RUN_NUMLOCK
	Hotkey, NUMLOCK & NUMPADHOME, #__RUN_NUMLOCK
	Hotkey, NUMLOCK & NUMPADUP, #__RUN_NUMLOCK
	Hotkey, NUMLOCK & NUMPADPGUP, #__RUN_NUMLOCK
	Hotkey, NUMLOCK & NUMPADDOT, #__RUN_NUMLOCK
	Hotkey, NUMLOCK & NUMPADDEL, #__RUN_NUMLOCK
	Hotkey, NUMLOCK & NUMPADDIV, #__RUN_NUMLOCK
	Hotkey, NUMLOCK & NUMPADMULT, #__RUN_NUMLOCK
	Hotkey, NUMLOCK & NUMPADADD, #__RUN_NUMLOCK
	Hotkey, NUMLOCK & NUMPADSUB, #__RUN_NUMLOCK
	Hotkey, NUMLOCK & NUMPADENTER, #__RUN_NUMLOCK
	#__HOTKEY_MOD_ = CAPS|NUM|SCROLL
	StringSplit, #__HOTKEY_MOD_, #__HOTKEY_MOD_, |
	Loop 10
	{
		A_Index_# = %A_Index%
		Loop %#__HOTKEY_MOD_0%
			Hotkey,% #__HOTKEY_MOD_%A_Index% . "LOCK & " . A_Index_#-1,% "#__RUN_" . #__HOTKEY_MOD_%A_Index% . "LOCK"
	}
	Loop 26
	{
		A_Index_# = %A_Index%
		Loop %#__HOTKEY_MOD_0%
			Hotkey,% #__HOTKEY_MOD_%A_Index% . "LOCK & " . Chr(A_Index_#+96),% "#__RUN_" . #__HOTKEY_MOD_%A_Index% . "LOCK"
	}
	Loop 10
	{
		A_Index_# = %A_Index%
		Loop 10
		{
			If A_Index = %A_Index_#%
				continue
			Hotkey,% "NUMPAD" . (A_Index_# - 1) . " & NUMPAD" . (A_Index-1), #__RUN_HOTKEY_, Off
		}
	}
	Return
}


Suspend:
Suspend,Toggle
Return



;*************************************************************************************************
;*                         TOGGLE SPEEDHOTKEY (SPECIAL 2 LETTERS HOTKEY)                         *
;*************************************************************************************************
#__SPEEDHOTKEY:
	WaitKeysUp(A_ThisHotkey)
	Toggle_Speed_Hotkey()
Return

Toggle_Speed_Hotkey(){
	global
	If #__SPEEDHOTKEY_STATE_ = ON
		#__SPEEDHOTKEY_STATE_ = OFF
	Else {
		#__SPEEDHOTKEY_STATE_ = ON
		ToolTip(5,"SpeedHotkeys are being turned " . #__SPEEDHOTKEY_STATE_, "SpeedHotkey","GTTM_TRACKPOSITION.TTM_TRACKACTIVATE L1 I" . #_hIcon_3 . " x" . #_XPOS_ . " y" . #_YPOS_)
	}
	#_TEMP_VAR:=DBArray("HOTKEY","get")
	Loop,Parse,#_TEMP_VAR,""
	{
		If A_LoopField
			Hotkey,% SubStr(A_LoopField, 1, 1) . " & " . SubStr(A_LoopField, 2), %#__SPEEDHOTKEY_STATE_%
	}
	Loop 10
	{
		A_Index_# = %A_Index%
		Loop 10
		{
			If A_Index = %A_Index_#%
				continue
			Hotkey,% "NUMPAD" . (A_Index_# - 1) . " & NUMPAD" . (A_Index-1), %#__SPEEDHOTKEY_STATE_%
		}
	}
	#__SPEEDHOTKEY_STATE_ := #__SPEEDHOTKEY_STATE_="ON" ? "ON" : "OFF"
	If #__SPEEDHOTKEY_STATE_ = OFF
	{
		If (A_ThisLabel!="#__RUN_HOTKEY_")
			ToolTip(5,"","","gTTM_POP")
	} Else
		ToolTip(5,"If any of loaded files have a string ""HOTKEY??"" ? = [a-z0-9] in their names,`nAutoHotfile creates a SpeedHotkey so you can press two letters to start anything", "SpeedHotkey " #__SPEEDHOTKEY_STATE_,"G1 L1 I" . #_hIcon_3)
	Input
	#__Exit_Launcher_=
	Return
}











;*************************************************************************************************
;*                               RELOAD AHK PROCESSES ON CHANGE                                  *
;*************************************************************************************************
ReloadScript:
	Thread, NoTimers
	If #__RELOAD_SCRIPT_NOW = ""
		Return
	SetTimer, ReloadScript, Off
	StringReplace, #__RELOAD_SCRIPT_NOW, #__RELOAD_SCRIPT_NOW, `n`n, `n, All
	Loop, Parse, #__RELOAD_SCRIPT_NOW, `n
	{
		If (A_LoopField = "" or InStr(A_LoopField, "#NORELOAD"))
			continue
		IfWinExist, %A_LoopField% ahk_class AutoHotkey
		{
			#__WIN_HWND_ := WinExist(A_LoopField . "ahk_class AutoHotkey")
			WinGet, #__WIN_PID_, PID, ahk_id %#__WIN_HWND_%
			If #__SET__RELOAD_AHK_ON_CHANGE_ = KILL
			{
				#__KILL_AHK_SCRIPT(), #__RELOAD_AHK_SCRIPT()
				Continue
			}
			Loop 5
			{
				PostMessage,0x111,65307,,,ahk_pid %#__WIN_PID_%
				Process, WaitClose,%#__WIN_PID_%,0.2
				If !ErrorLevel
					Break
			}
			Process, WaitClose,%#__WIN_PID_%,0.2
			If ErrorLevel
				WinClose, ahk_pid %#__WIN_PID_%
			Process, WaitClose,%#__WIN_PID_%,0.2
			If Errorlevel
			{
				MsgBox, 262148, COULD NOT CLOSE AHK SCRIPT, %A_LoopField%`nCould not be closed for reloading`n`nWould you like to kill process
				IfMsgBox Yes
					#__KILL_AHK_SCRIPT(), #__RELOAD_AHK_SCRIPT()
			} Else {
				RefreshTray()
				#__RELOAD_AHK_SCRIPT()
			}
		}
	}
	#__RELOAD_SCRIPT_NOW =
Return

#__KILL_AHK_SCRIPT(){
	global
	Process, Close, %#__WIN_PID_%
	WinWaitClose, %A_LoopField% ahk_class AutoHotkey,,3
	RefreshTray()
}

#__RELOAD_AHK_SCRIPT(){
	global
	If (SubStr(#__FILE_TO_RUN,-2)="ahk" and #__SET_RUN_AHK_AS_EXE_)
		ErrorLevel := Exe(A_LoopField) ? 0 : 1
	else
		Run % A_LoopField,% SubStr(A_LoopField,1, InStr(A_LoopField, "\",1,0)-1), UseErrorLevel
	If Errorlevel
	{
		ToolTip(9, A_LoopField,"Error opening file","I3 D2 " . #__ToolTip_Options)
		Return
	}
}

RefreshTray(){
	ControlGetPos, ,,w,h,ToolbarWindow321, AHK_class Shell_TrayWnd
	w //=4
	h //=4
	Loop %w%
	{
		x := A_Index
		Loop %h%
		SendMessage, 0x200,%x%,%A_Index%,ToolbarWindow321, AHK_class Shell_TrayWnd
	}
}


;*************************************************************************************************
;*                      I P C   M O D U L E   B Y   M A J K I N E T O R (modified)               *
;*************************************************************************************************
;private IPC function, wm_copydata monitor
IPC_OnCopyData(wparam, lparam) {
	local pStr
	#__ACTION := NumGet(lparam+0), pStr := NumGet(lparam+8)
	IPC_%#__ACTION%(DllCall("MulDiv", "Int", pStr, "Int",1, "Int",1, "str"))
	return 1
}

IPC_1(var){ ;UrlDownLoadToVar
	global
	#__URL_VAR_:=SubStr(var,1,InStr(var,Chr(4),1)-1)
	#__Suggest_Script_=
	#__Cound_Found_Scripts_=
	#_loop_add_to_index=1
	StringTrimLeft,#__URL_OUT_,var,% InStr(var,Chr(4),1)
	If (#__URL_VAR_=SubStr(#__CURRENT_VAR,2) and #__URL_OUT_){
		Loop,Parse,#__URL_OUT_,`n
		{
			If (SubStr(A_LoopField,InStr(A_LoopField,">",1,0)+1)=" " or SubStr(A_LoopField,InStr(A_LoopField,">",1,0)+1)="" or InStr(A_LoopField,"Im&nbsp`;Cache",1))
				continue
			else if (#__Cound_Found_Scripts_+1>#__SET__PROPOSAL_)
				Break
			#__Cound_Found_Scripts_++
			#_found_script%#__Cound_Found_Scripts_%:=SubStr(A_LoopField,1,InStr(A_LoopField,"""",1)-1)
			#__Suggest_Script_ .= "`nF" . #__Cound_Found_Scripts_ . A_Space . "<a " #_found_script%#__Cound_Found_Scripts_% . ">" . SubStr(A_LoopField,InStr(A_LoopField,">",1,0)+1) . "</a>" . A_Tab . SubStr(#_found_script%#__Cound_Found_Scripts_%,1,InStr(#_found_script%#__Cound_Found_Scripts_%,"/",1,8)-1)
		}
		ToolTip(5,#_WEB_PREFIX_1 . SubStr(#__CURRENT_VAR,2) . #_WEB_PREFIX_2 . "`n" . #__Suggest_Script_,#__CURRENT_VAR,"G1 L1 I" . #_hIcon_3)
	}
}
IPC_100(var){ ;Save current entry
	global
	#__CURRENT_VAR=%var%
}




; Title:	CmnDlg
;			*Common Operating System dialogs*

;----------------------------------------------------------------------------------------------
; Function:		Color
;				(See color.png)
;
; Parameters: 
;				pColor	- Initial color and output in RGB format, 
;				hGui	- Optional handle to parents HWND
;  
; Returns:	
;				False if user canceled the dialog or if error occurred	
; 
;
CmnDlg_Color(ByRef pColor, hGui=0){ 
  ;covert from rgb
    clr := ((pColor & 0xFF) << 16) + (pColor & 0xFF00) + ((pColor >> 16) & 0xFF) 

    VarSetCapacity(sCHOOSECOLOR, 0x24, 0) 
    VarSetCapacity(aChooseColor, 64, 0) 

    NumPut(0x24,		 sCHOOSECOLOR, 0)      ; DWORD lStructSize 
    NumPut(hGui,		 sCHOOSECOLOR, 4)      ; HWND hwndOwner (makes dialog "modal"). 
    NumPut(clr,			 sCHOOSECOLOR, 12)     ; clr.rgbResult 
    NumPut(&aChooseColor,sCHOOSECOLOR, 16)     ; COLORREF *lpCustColors 
    NumPut(0x00000103,	 sCHOOSECOLOR, 20)     ; Flag: CC_ANYCOLOR || CC_RGBINIT 

    nRC := DllCall("comdlg32\ChooseColorA", str, sCHOOSECOLOR)  ; Display the dialog. 
    if (errorlevel <> 0) || (nRC = 0) 
       return  false 

  
    clr := NumGet(sCHOOSECOLOR, 12) 
    
    oldFormat = %A_FormatInteger%
    SetFormat, integer, hex  ; Show RGB color extracted below in hex format. 

 ;convert to rgb 
    pColor := (clr & 0xff00) + ((clr & 0xff0000) >> 16) + ((clr & 0xff) << 16) 
    StringTrimLeft, pColor, pColor, 2 
    loop, % 6-strlen(pColor) 
		pColor=0%pColor% 
    pColor=0x%pColor% 
    SetFormat, integer, %oldFormat% 

	return true
}
Return












;==================== START: #Include .\include\_OnPBMsg_# :B1AD529B-BF4E-477F-8B9F-3080CAC55AE3

OnPBMsg(wParam, lParam, msg, hwnd) {
	If (wParam = 0) 
	{   ;PBT_APMQUERYSUSPEND
		If (lParam & 1)   ;Check action flag
		{
			SetTimer, WatchFolder, Off ;500
			WatchDirectory()
			Return true
		}
	} 
	Else If (wParam = 2)   ;PBT_APMQUERYSUSPENDFAILED
	{
		Gosub, ResumeWatchingDirectory
		SetTimer, WatchFolder, -300
	}
	Else If (wParam = 6)   ;PBT_APMRESUMECRITICAL
	{
		SetTimer, WatchFolder, Off
		WatchDirectory()
		Settimer, ResumeWatchingDirectory, -5000
		SetTimer, WatchFolder, -5500
	}
	Else If (wParam = 7)   ;PBT_APMRESUMESUSPEND
	{
		Sleep, 2000
		SetTimer, ResumeWatchingDirectory,-5000
		SetTimer, WatchFolder, -5500
	}
   ;Must return True after message is processed
   Return True
}

;==================== END: #Include .\include\_OnPBMsg_# :B1AD529B-BF4E-477F-8B9F-3080CAC55AE3

;==================== START: #Include .\include\_FileExtract_# :B1AD529B-BF4E-477F-8B9F-3080CAC55AE3

;*************************************************************************************************
;*                 F I L E  E X T R A C T  F U N C T IO N   b y   L e x i k o s                  *
;*************************************************************************************************

GetStrN(Pointer, Length) {
    VarSetCapacity(String, Length)
    DllCall("lstrcpyn", "str", String, "uint", Pointer, "int", Length+1)
    return String
}


/*
    Function: FileExtract
    
    Extracts a file from this compiled script by using a dynamic FileInstall.
    
    Syntax:
        FileExtract( Source, Dest [, Flag ] )
    
    Parameters:
        Source  - The source string used in the original FileInstall.
        Dest    - The name of the file to be created.
        Flag    - Specify 1 to overwrite existing files, otherwise omit.
    
    Remarks:
        Unlike FileInstall, FileExtract() allows variables and expressions for Source,
        and does not cause Ahk2Exe to include a file into the executable.
*/
FileExtract(Source, Dest, Flag=0) {
    static init
    if !init
        cb := RegisterCallback("FileExtract_")
        ; cb->func->mJumpToLine->mActionType := ACT_FILEINSTALL
        , NumPut(A_AhkVersion>="1.0.48" ? 160:159, NumGet(NumGet(cb+28)+4), 0, "UChar") ; Fixed for AutoHotkey v1.0.48: ACT_FILEINSTALL has changed to 160.
        , DllCall("GlobalFree", "uint", cb)
    return FileExtract_(Source, Dest, Flag)
}
FileExtract_(Source, Dest, Flag) {
    FileCopy, %Source%, %Dest%, %Flag%
    return !ErrorLevel
}

/*
    Function: FileExtract_ToMem
    
    Extracts a FileInstall'd file into memory.
    
    Syntax:
        FileExtract_ToMem( Source, pData, DataSize [, InitialBufferSize, InitialBuffer ] )
    
    Parameters:
        Source       [in] - The source string used in the original FileInstall.
        pData    [in/out] - A pointer to the buffer where file data is written. See remarks.
        DataSize     [in] - If pData is zero, this indicates the initial buffer size.
                    [out] - Receives the number of bytes written to the buffer.
    
    Remarks:
        pData must specify zero or a valid pointer to memory allocated with GlobalAlloc().
        
        If the caller specifies a non-zero pData, it is used as the initial data buffer.
        If the buffer is too small, the function will reallocate it and update pData.
        The function does not delete the buffer on failure unless the caller specified zero.
        
        Once the data is no longer needed, free it using GlobalFree:
        
            DllCall("GlobalFree","uint",pData)
        
        DataSize indicates the amount of data written, not the size of the buffer.
        To determine the actual size of the buffer, use GlobalSize:
        
            MemSize := DllCall("GlobalSize","uint",pData)
*/
FileExtract_ToMem(Source, ByRef pData, ByRef DataSize)
{
    static ReadPipe, ConnectNamedPipe, ReadFile, GlobalReAlloc
    if !VarSetCapacity(ReadPipe)
    {
        ; Initialize the machine code function for reading from the pipe.
        hex =
        ( LTrim Join
        558BEC81EC0004000053568B75085733FF397E080F848D000000397E040F848400000057
        FF36FF561057BB00040000EB5E8B46088B4D088BD02B560C3BD1732803C08946088B560C
        2BC23BC1730503D18956086A02FF7608FF7604FF561885C074458B4D088946048B460C03
        460433FF85C976168D9500FCFFFF2BD08A0C0288088B4D0847403BF972F2014E0C6A008D
        450850538D8500FCFFFF50FF36FF561485C0758D40EB0233C05F5E5BC9C20400
        )
        ;~ MCode() - http://www.autohotkey.com/forum/viewtopic.php?t=21172
        VarSetCapacity(ReadPipe,StrLen(hex)//2)
        Loop % StrLen(hex)//2
           NumPut("0x" . SubStr(hex,2*A_Index-1,2), ReadPipe, A_Index-1, "Char")
        ;~ end
        
        ; Resolve ReadPipe()'s dependencies for later.
        hKernel32 := DllCall("GetModuleHandle", "str", "kernel32.dll")
        ConnectNamedPipe := DllCall("GetProcAddress", "uint", hKernel32, "str", "ConnectNamedPipe")
        ReadFile         := DllCall("GetProcAddress", "uint", hKernel32, "str", "ReadFile")
        GlobalReAlloc    := DllCall("GetProcAddress", "uint", hKernel32, "str", "GlobalReAlloc")
    }
    
    UserOwnsData := !!pData ; True if pData is not [blank or zero].
    if !pData
    {   ; If DataSize is non-numeric or < 1, default to 1024.
        if (DataSize+0 < 1)
            DataSize := 1024
        pData := DllCall("GlobalAlloc","uint",0,"uint",DataSize)
    }
    else
    {   ; Get the actual size of the memory block,
        DataSize := DllCall("GlobalSize","uint",pData)
    }
    
    VarSetCapacity(ReadPipeStruct, 28, 0) ; ReadPipeStruct

    ; Fill ReadPipeStruct with ReadPipe()'s dependencies.
    NumPut(ConnectNamedPipe, ReadPipeStruct, 16)
    NumPut(ReadFile, ReadPipeStruct, 20)
    NumPut(GlobalReAlloc, ReadPipeStruct, 24)
    
    Random, pipe_name
    
    ; Create a named pipe (with an unpredictable name) for writing the file into.
    hNamedPipe := DllCall("CreateNamedPipe", "str", "\\.\pipe\" pipe_name, "uint", 3
                    , "uint", 0, "uint", 255, "uint",0, "uint",0, "uint",0, "uint",0)
    ; Set the parameters for the pipe-reading thread.
    NumPut(hNamedPipe, ReadPipeStruct, 0)
    NumPut(pData, ReadPipeStruct, 4)
    NumPut(DataSize, ReadPipeStruct, 8)

    ; Create a thread to read from the pipe into memory.
    ; The thread will start immediately, but will wait for a pipe connection.
    hReadThread := DllCall("CreateThread", "uint", 0, "uint", 0, "uint", &ReadPipe
                            , "uint", &ReadPipeStruct, "uint", 0, "uint*", ReadThreadID)
    
    ; "Replace flag" *must* be specified since the pipe... exists.
    FileExtractResult := FileExtract(Source, "\\.\pipe\" pipe_name, 1)
    
    if !FileExtractResult
    {   ; Open and close a connection to the pipe to terminate the thread.
        FileAppend,, \\.\pipe\%pipe_name%
    }
    
    Loop {
        ; Wait for the thread to terminate, or any window message to be received.
        r := DllCall("MsgWaitForMultipleObjectsEx", "uint", 1, "uint*", hReadThread
                                            , "uint", -1, "uint", 0x4FF, "uint", 0x6)
        if (r = 0) || (r = -1) ; WAIT_OBJECT_0 or WAIT_FAILED
            break
        Sleep, 1 ; Allow AutoHotkey to dispatch messages.
    }

    DllCall("DisconnectNamedPipe", "uint", hNamedPipe)
    DllCall("CloseHandle", "uint", hNamedPipe)
    DllCall("CloseHandle", "uint", hReadThread)

    if FileExtractResult || UserOwnsData
    {
        ; Either it was a success and we are returning the extracted data,
        ; or it failed and we are returning the memory to the caller, since
        ; they may want to reuse it.
        pData := NumGet(ReadPipeStruct,4)
        DataSize := NumGet(ReadPipeStruct,12)
    }
    else
    {
        ; If ReadPipe() fails because of low memory, pData may have been reallocated,
        ; so always use the value in the structure.
        DllCall("GlobalFree", "uint", NumGet(ReadPipeStruct,4))
        pData := DataSize := 0
    }
    return FileExtractResult
}

;==================== END: #Include .\include\_FileExtract_# :B1AD529B-BF4E-477F-8B9F-3080CAC55AE3

;==================== START: #Include .\include\_Eval_# :B1AD529B-BF4E-477F-8B9F-3080CAC55AE3

;*************************************************************************************************
;*                                    EVAL FUNCTION by Laszo                                     *
;*************************************************************************************************
;Eval() by Laszo
; AHK 1.0.46+
; evaluate arithmetic expressions containing
; unary +,- (-2*3; +3)
; +,-,*,/,\(or % = mod); **(or @ = power)
; (..); var (pi, e); abs(),sqrt(),floor()
Eval(x) {
   Static pi = 3.141592653589793, e = 2.718281828459045
   StringReplace x, x,`%, \, All
   StringReplace x, x, `,, ., All
   x := RegExReplace(x,"\s*")
   x := RegExReplace(x,"([a-zA-Z]\w*)([^\w\(]|$)","%$1%$2")
   Transform x, Deref, %x%
   StringReplace x, x, -, #, All
   StringReplace x, x, (#, (0#, All
   If (Asc(x) = Asc("#"))
	  x = 0%x%
   StringReplace x, x, (+, (, All
   If (Asc(x) = Asc("+"))
	  StringTrimLeft x, x, 1
   StringReplace x, x, **, @, All
   Loop {
	  If !RegExMatch(x, "(.*)\(([^\(\)]*)\)(.*)", y)
		 Break
	  x := y1 . Eval@(y2) . y3
   }
   Return Eval@(x)
}
Eval@(x) {
   RegExMatch(x, "(.*)(\+|\#)(.*)", y)
   IfEqual y2,+,  Return Eval@(y1) + Eval@(y3)
   IfEqual y2,#,  Return Eval@(y1) - Eval@(y3)

   RegExMatch(x, "(.*)(\*|\/|\\)(.*)", y)
   IfEqual y2,*,  Return Eval@(y1) * Eval@(y3)
   IfEqual y2,/,  Return Eval@(y1) / Eval@(y3)
   IfEqual y2,\,  Return Mod(Eval@(y1),Eval@(y3))

   StringGetPos i, x, @, R
   IfGreaterOrEqual i,0, Return Eval@(SubStr(x,1,i)) ** Eval@(SubStr(x,2+i))

   If !RegExMatch(x,".*(abs|floor|sqrt)(.*)", y)
	  Return x
   IfEqual y1,abs,  Return abs(  Eval@(y2))
   IfEqual y1,floor,Return floor(Eval@(y2))
   IfEqual y1,sqrt, Return sqrt( Eval@(y2))
}
;==================== END: #Include .\include\_Eval_# :B1AD529B-BF4E-477F-8B9F-3080CAC55AE3

;==================== START: #Include .\include\_Hotkeys_# :B1AD529B-BF4E-477F-8B9F-3080CAC55AE3
CAPSLOCK:
RapidHotkey("#__KEYWORD_LAUNCHER""#__SPEEDHOTKEY""#__PROCESS_TERMINATOR""#__SETTINGS", 1, 0.15, 1)
Return

QUICKPROFILE:
Input
#_TEMP_VAR=
Loop,Parse,#__SET__PROFILES_,|
	#_TEMP_VAR.="`n" . "F" . A_Index . "<a " . A_Index . ">" . A_Tab . A_LoopField . "</a>"
ToolTip(5,#_TEMP_VAR,"Select profile","GTTM_TRACKPOSITION.TTM_TRACKACTIVATE L1 I" . #_hIcon_3 . " x" . #_XPOS_ . " y" . #_YPOS_)
Input,#_TEMP_VAR,L1,{F1}{F2}{F3}{F4}{F5}{F6}{F7}{F8}{F9}{F10}{F11}{F12}{F13}{F14}{F15}{F16}{F17}{F18}{F19}{F20}{F21}{F22}{F23}{F24}
#_ErrorLevel:=ErrorLevel
ToolTip(5,"","","GTTM_POP")
If InStr(#_ErrorLevel,"EndKey:F")
{
	SetProfile(SubStr(#_ErrorLevel,9))
	Gosub, #__UNLOAD_FILES
	Gosub,#__RELOAD_FILES
} else if !#__LOOP_FILE_PATTERNS_
	#__LOAD_FILES()
#__SET__PROFILES_NEW_=
Return

SetProfile(ProfileNr){
	global
	Loop,Parse,#__SET__PROFILES_,|
	{
		If (A_Index=ProfileNr)
		{
			#__SET__PROFILES_NEW_:=A_LoopField . "|" . #__SET__PROFILES_NEW_
			#_TEMP_VAR:=SubStr(#__SET__PROFILES_,1,(InStr(#__SET__PROFILES_,"|") ? (InStr(#__SET__PROFILES_,"|")-1) :))
			IniWrite,%#__SET__DIRECTORIES_%,%#__INI_FILE_%,CONFIG,#__SET__PROFILES_%#_TEMP_VAR%_
			IniRead,#__SET__DIRECTORIES_,%#__INI_FILE_%,CONFIG,#__SET__PROFILES_%A_LoopField%_
			IniWrite,%#__SET__DIRECTORIES_%,%#__INI_FILE_%,CONFIG,#__SET__DIRECTORIES_
		}
		else if A_LoopField
			#__SET__PROFILES_NEW_.=(A_Index=1 ? "" : "|") . A_LoopField
	}
	#__SET__PROFILES_NEW_:=RegExReplace(#__SET__PROFILES_NEW_,"\|\|","|")
	IniWrite,%#__SET__PROFILES_NEW_%,%#__INI_FILE_%,CONFIG,#__SET__PROFILES_
	#__SET__PROFILES_:=#__SET__PROFILES_NEW_
}

RUNAUTOSTART:
MsgBox, 262148, Auto Start, Would you like to Run files including AUTOSTART now?
IfMsgBox Yes
{
	#_ALL_FILES:=DBArray("files","find")
	Loop, Parse, #_ALL_FILES,""
		Loop, Parse, A_LoopField, `n
			If InStr(A_LoopField, "AUTOSTART", 1)
				Run(A_LoopField)
}
ToolTip(5,"","","GTTM_POP")
Return

RUNCLIPBOARD:
	WaitKeysUp(A_ThisHotkey)
	RunPipe(Clipboard)
	Hide(0)
Return

RESETTIMER:
DBArray("Reminder","delete")
IniRead,#__SET__FILE_REMINDER_,%#__INI_FILE_%,CONFIG, #__SET__FILE_REMINDER_,%A_Space%
If #__SET__FILE_REMINDER_ = ON
	SetTimer, #__FILE_REMINDER, 500
Else
	MsgBox, 262144, File Reminder, File Reminder is Off
Return

#__LIST_HOTKEYS:
	ListHotkeys
Return

#__EDIT_SCRIPT:
	If A_IsCompiled
		Run	%#__SET__EDITOR_% "%#__INI_FILE_%"
	Else
		Run	%#__SET__EDITOR_% "%A_ScriptName%"
Return

PAUSEAUTOHOTKEY:
WaitKeysUp(A_ThisHotkey)
	process_list =
	WinGet, #__PID_LIST_, List, AHK_class AutoHotkey
	WinGet, #__HSS_HWND_, ID, ahk_pid %#__HSS_PID_%
	If (#__PID_LIST_ = 1  or (#__PID_LIST_ = 2 and (#__PID_LIST_1 = #__HSS_HWND_ or #__PID_LIST_2 = #__HSS_HWND_)))
		Return
	Loop %#__PID_LIST_%
	{
		WinGet, #__CURRENT_PID_, PID,% "ahk_id " #__PID_LIST_%A_Index%
		If (#__OWN_PID_ = #__CURRENT_PID_ or #__HSS_PID_ = #__CURRENT_PID_)
			continue
		PostMessage, 0x111, 65306,,,% "ahk_id " #__PID_LIST_%A_Index%
	}
Return

#__RELOAD:
	WaitKeysUp(A_ThisHotkey)
	IfWinExist, ahk_id %#__Settings_hwnd%
	{
		WinShow, ahk_id %#__Settings_hwnd%
		WinActivate, ahk_id %#__Settings_hwnd%
		Gosub, SaveSettings
	}
	Reload
Return

;Turn off SPEEDHOTKEY and close FileExplorer
~ESCAPE::
	KeyWait, Escape
	If #__SPEEDHOTKEY_STATE_ = On
		Toggle_Speed_Hotkey()
	Else if WinActive("ahk_id " . #__SETTINGS_HWND)
		Goto,GuiEscape
	ToolTip("StartUp","","","GTTM_POP")
	SetTimer,#_CHECK_PROCESSES,Off
	Hide(0)
	Input
Return

CAPSLOCK & ~LBUTTON::
	KeyWait, CapsLock
	MouseGetPos,,,#__TEMP_WIN_,#__TEMP_CONTROL_
	If InStr(#__TEMP_CONTROL_, "scintilla"){
		ControlGet, #__TEMP_CONTROL_, Hwnd,, %#__TEMP_CONTROL_%, ahk_id %#__TEMP_WIN_%
		#__TEMP_VAR_:=Sci_GetText(#__TEMP_CONTROL_)
	} else if InStr(#__TEMP_CONTROL_,"HiEdit"){
		ControlGet, #__TEMP_CONTROL_, Hwnd,, %#__TEMP_CONTROL_%, ahk_id %#__TEMP_WIN_%
		#__TEMP_VAR_:=HE_GetText(#__TEMP_CONTROL_)
	} else if InStr(#__TEMP_CONTROL_,"edit")
		ControlGetText,#__TEMP_VAR_,%#__TEMP_CONTROL_%,ahk_id %#__TEMP_WIN_%
	RunPipe(#__TEMP_VAR_, A_Now . "." . A_TickCount)
	Hide(0)
Return

;Enter an global environment variable in any explorer address bar (such as run) and press CTRL & ENTER to run. For example temp
RESOLVEVARIABLE:
	WaitKeysUp(A_ThisHotkey)
	Sleep, 100
	Send, {DEL}+5{HOME}+5{ENTER}
Return

~^s::IfWinActive,ahk_id %#__SETTINGS_HWND%,,,,GoTo, SaveSettings







#__TOGGLE_MASTER_HOTKEYS(toggle="Off"){
	global #__SET__HOTKEYS_
	Loop, Parse, #__SET__HOTKEYS_, %A_Tab%
		Hotkey, %A_LoopField%, %toggle%
	Return
}

;==================== END: #Include .\include\_Hotkeys_# :B1AD529B-BF4E-477F-8B9F-3080CAC55AE3

;==================== START: #Include .\include\_LOAD_FILES_# :B1AD529B-BF4E-477F-8B9F-3080CAC55AE3
;*************************************************************************************************
;*         FUNCTION TO LOAD KEYWORDS FOR FILES IN %#__SET__DIRECTORIES_TO_LOAD_% ON START                *
;*************************************************************************************************
#__LOAD_FILES()
{
	global
	Suspend, On
	ToolTip("StartUp","Checking directories…","Loading user directories","GTTM_TRACKPOSITION.TTM_TRACKACTIVATE xTrayIcon yTrayIcon I" . #_hIcon_2)
	#__LOOP_FILE_PATTERNS_ =
	Loop %#__SET__DIRECTORIES_TO_LOAD_0%
	{
		#__CURRENT_PATH_ =
		#__DIRECTORY_PATTERNS_ := #__SET__DIRECTORIES_TO_LOAD_%A_Index%
		If (StrLen(#__CURRENT_PATH_ := SubStr(#__DIRECTORY_PATTERNS_, 1, InStr(#__DIRECTORY_PATTERNS_, "\", 0, 0)-1)) != 2)
		{
			Loop,% #__CURRENT_PATH_, 2, 0
				#__CURRENT_PATH_ = %A_LoopFileLongPath%\
		}
		Else
			#__CURRENT_PATH_ .= "\"
		If (!FileExist(#__CURRENT_PATH_))
			continue
		If (SubStr(#__DIRECTORY_PATTERNS_, InStr(#__DIRECTORY_PATTERNS_, "\",0,0)+1, 1) = "*")
		{
			#__INCLUDE_SUBFOLDERS_ = 1
			#__FILE_WILDCARD_ := SubStr(#__DIRECTORY_PATTERNS_, InStr(#__DIRECTORY_PATTERNS_, "\", 0, 0)+3)
		}
		Else
		{
			#__INCLUDE_SUBFOLDERS_ = 0
			#__FILE_WILDCARD_ := SubStr(#__DIRECTORY_PATTERNS_, InStr(#__DIRECTORY_PATTERNS_, "\", 0, 0)+2)
		}
		WatchDirectory(#__CURRENT_PATH_, #__INCLUDE_SUBFOLDERS_)
		ToolTip("StartUp","Checking " . #__CURRENT_PATH_,"Loading user directories","G1 I" . #_hIcon_2)
		If (#__FILE_WILDCARD_ = "" and SubStr(#__DIRECTORY_PATTERNS_,0)!="/")
		{
			Loop %#__SET__GLOBAL_EXT_TO_LOAD_0%
			{
				#__SET__GLOBAL_EXT_TO_LOAD_ := #__SET__GLOBAL_EXT_TO_LOAD_%A_Index%
				#__LOOP_FILE_PATTERNS_++
				If (#__SET__GLOBAL_EXT_TO_LOAD_="*")
					#__FILE_PATTERNS_%#__LOOP_FILE_PATTERNS_% = %#__CURRENT_PATH_%%#__SET__GLOBAL_EXT_TO_LOAD_%
				else
					#__FILE_PATTERNS_%#__LOOP_FILE_PATTERNS_% = %#__CURRENT_PATH_%*.%#__SET__GLOBAL_EXT_TO_LOAD_%
				#__INCLUDE_SUBFOLDERS_%#__LOOP_FILE_PATTERNS_% = %#__INCLUDE_SUBFOLDERS_%
			}
		}
		else
		{
			StringSplit, #__FILE_WILDCARD_, #__FILE_WILDCARD_, /
			Loop %#__FILE_WILDCARD_0%
			{
				#__LOOP_FILE_PATTERNS_++
				#__FILE_PATTERNS_%#__LOOP_FILE_PATTERNS_% := #__CURRENT_PATH_ . #__FILE_WILDCARD_%A_Index%
				#__INCLUDE_SUBFOLDERS_%#__LOOP_FILE_PATTERNS_% = %#__INCLUDE_SUBFOLDERS_%
			}
		}
	}
	Loop %#__LOOP_FILE_PATTERNS_%
	{
		#__FILE_PATTERNS_      := #__FILE_PATTERNS_%A_Index%
		#__INCLUDE_SUBFOLDERS_ := #__INCLUDE_SUBFOLDERS_%A_Index%
		#__INDEX_ = %A_INDEX%
		ToolTip("StartUp",#__FILE_PATTERNS_%#__INDEX_% . "  (" . #__INCLUDE_SUBFOLDERS_ ")","Loading files, please wait…     " . Round(Round(100/#__LOOP_FILE_PATTERNS_, 16)*(#__INDEX_-1)) . "%  (" . #__FILE_COUNT_0 . ")","G1 I" . #_hIcon_2)
		SetTimer, #__LOAD_TOOLTIP, 300
		#__ADD_KEYWORDS()
		SetTimer, #__LOAD_TOOLTIP, OFF
	}
	#__BUILD_FILE_HOTKEY_INFO_()

	If (#__SET__AUTOHOTSTRING_ = "ON" or #__SET__USE_CHORDING_)
	{
		ToolTip("StartUp","Please wait while hotstring/chording script is being build","Building script","G1 I" . #_hIcon_2)
		GoSub, #__CREATE_HOTSTRINGS_
	}
	SetTimer, #__START_UP_TOOLTIP, -100
	Return
}
#__UNLOAD_FILES:
	SetTimer, WatchFolder, OFF
	SetTimer, #__FILE_REMINDER, OFF
	WatchDirectory()
	DBArray("files","delete")
	IniRead, #__SET__DIRECTORIES_, %#__INI_FILE_%, CONFIG, #__SET__DIRECTORIES_,%A_Space%
	StringSplit, #__SET__DIRECTORIES_TO_LOAD_, #__SET__DIRECTORIES_, |
	StringSplit, #__SET__GLOBAL_EXT_TO_LOAD_, #__SET__GLOBAL_EXT_, |
	Suspend, Off
	SetTimer, WatchFolder, -500
	If #__SET__FILE_REMINDER_ = ON
		SetTimer, #__FILE_REMINDER, 10000
Return
#__RELOAD_FILES:
	SetTimer, WatchFolder, OFF
	SetTimer, #__FILE_REMINDER, OFF
	If #__SET__DIRECTORIES_TO_LOAD_0 < 1
		Return
	#__LOAD_FILES()
	Loop %#__SET__DIRECTORIES_TO_LOAD_0%
		#__SET__DIRECTORIES_TO_LOAD_%A_Index% =
	#__SET__DIRECTORIES_TO_LOAD_0 =
	Suspend, Off
	If #__SET__FILE_REMINDER_ = ON
		SetTimer, #__FILE_REMINDER, 10000
	SetTimer, WatchFolder, -500
Return
#__LOAD_TOOLTIP:
ToolTip("StartUp",#__FILE_PATTERNS_%#__INDEX_% . "  (" . #__INCLUDE_SUBFOLDERS_ ")","Loading files, please wait…     " . Round(Round(100/#__LOOP_FILE_PATTERNS_, 16)*(#__INDEX_-1)) . "%  (" . #__FILE_COUNT_0 . ")","G1 I" . #_hIcon_2)
Return







;*************************************************************************************************
;*                               FUNCTION TO ADD NEW KEYWORDS                                    *
;*************************************************************************************************
#__ADD_KEYWORDS()
{
	global
	Loop, %#__FILE_PATTERNS_%, % (SubStr(#__FILE_PATTERNS_,-1)="\*") ? 2 : 0, %#__INCLUDE_SUBFOLDERS_%
	{
		#__KEY_WORD_ := GetKeyWord(A_LoopFileName)
		#__FILE_LONG_PATH_:=RegExMatch(A_LoopFileFullPath, "^[A-Z][^~]*$|^\\\\") ? A_LoopFileFullPath : A_LoopFileLongPath
		If !DBArray("files","Exist",#__KEY_WORD_){
			DBArray("files","add",#__KEY_WORD_,#__FILE_LONG_PATH_)
		} else {
			#__PATH_EXISTS:=DBArray("files","Get",#__KEY_WORD_)
			Loop,Parse,#__PATH_EXISTS,`n
				If (A_LoopField=#__FILE_LONG_PATH_)
					#__PATH_ALREADY_EXISTS:=1
			If !#__PATH_ALREADY_EXISTS
				DBArray("files","set",#__KEY_WORD_, #__PATH_EXISTS . "`n" . #__FILE_LONG_PATH_)
			#__PATH_ALREADY_EXISTS=
		}
		If #__SET__AUTOSTART_ = ASK
		{
			If InStr(A_LoopFileName, "AUTOSTART", 1)
			{
				MsgBox, 262148, AUTOSTART, Start AUTOSTART files now? , 20
				IfMsgBox Yes
				{
					#__SET__AUTOSTART_ = On
					Open(A_LoopFileFullPath),ToolTip(5,"","","GTTM_POP")
				}
				else
					#__SET__AUTOSTART_ = Off
			}
		} else if (#__SET__AUTOSTART_ = "On" and InStr(A_LoopFileName, "AUTOSTART", 1))
			Open(A_LoopFileFullPath),ToolTip(5,"","","GTTM_POP")
		Suspend, On
		If RegExMatch(A_LoopFileName, "CAPSLOCK.|SCROLLLOCK.|NUMLOCK.|HOTKEY..")
		{
			#__FILE_NAME_ := A_LoopFileName
			#__CREATE_HOTKEY(#__FILE_NAME_)
		}
		#__KEY_WORD_ =
	}
	Return
}












;*************************************************************************************************
;*                               FUNCTION TO ADD NEW KEYWORDS                                    *
;*************************************************************************************************
#__BUILD_FILE_HOTKEY_INFO_()
{
	global
	DBArray("HOTKEY","sort")
	DBArray("files","sort")
	Return
}







;*************************************************************************************************
;*                             FUNCTION TO CREATE HOTKEYS FOR FILES                              *
;*************************************************************************************************
#__CREATE_HOTKEY(#__FILE_NAME_)
{
	If (RegExMatch(#__FILE_NAME_, "CAPSLOCK[\w\d]", 0) != 0)
		DBArray("CAPSLOCK"
				,DBArray("CAPSLOCK","exist",KEY:=SubStr(#__FILE_NAME_,InStr(#__FILE_NAME_, "CAPSLOCK",1)+8,1)) ? "set" : "add"
				,KEY,GetKeyWord(#__FILE_NAME_))
	If (RegExMatch(#__FILE_NAME_, "SCROLLLOCK[\w\d]", 0) != 0)
		DBArray("SCROLLLOCK"
				,DBArray("SCROLLLOCK","exist",KEY:=SubStr(#__FILE_NAME_,InStr(#__FILE_NAME_, "SCROLLLOCK",1)+10,1)) ? "set" : "add"
				,KEY,GetKeyWord(#__FILE_NAME_))
	If (RegExMatch(#__FILE_NAME_, "NUMLOCK[\w\d]", 0) != 0)
		DBArray("NUMLOCK"
				,DBArray("NUMLOCK","exist",KEY:=SubStr(#__FILE_NAME_,InStr(#__FILE_NAME_, "NUMLOCK",1)+7,1)) ? "set" : "add"
				,KEY,GetKeyWord(#__FILE_NAME_))
	If (RegExMatch(#__FILE_NAME_, "HOTKEY[\w\d][\w\d]", 0) = 0)
	Return
	StringMid, #__INFO_STRING_, #__FILE_NAME_, InStr(#__FILE_NAME_, "HOTKEY",1)+6, 2
	DBArray("HOTKEY",DBArray("HOTKEY","exist",#__INFO_STRING_) ? "set" : "add",#__INFO_STRING_,GetKeyWord(#__FILE_NAME_))
	Hotkey,% SubStr(#__INFO_STRING_, 1, 1) . " & " . SubStr(#__INFO_STRING_, 2), #__RUN_HOTKEY_, Off
}



;*************************************************************************************************
;*                              FUNCTION TO DESTROY FILE HOTKEYS                                 *
;*************************************************************************************************
#__DESTROY_HOTKEY(#__FILE_NAME_)
{
	If (RegExMatch(#__FILE_NAME_, "CAPSLOCK[\w\d]", 0) != 0)
		DBArray("CAPSLOCK","delete",#__FILE_NAME_)
	If (RegExMatch(#__FILE_NAME_, "SCROLLLOCK[\w\d]", 0) != 0)
		DBArray("SCROLLLOCK","delete",#__FILE_NAME_)
	If (RegExMatch(#__FILE_NAME_, "NUMLOCK[\w\d]", 0) != 0)
		DBArray("NUMLOCK","delete",#__FILE_NAME_)
	If (RegExMatch(#__FILE_NAME_, "HOTKEY[\w\d][\w\d]", 0) = 0)
		Return
	StringMid, #__INFO_STRING_, #__FILE_NAME_, InStr(#__FILE_NAME_, "HOTKEY",1)+6, 2
	DBArray("HOTKEY","delete",#__INFO_STRING_)
	Hotkey,% SubStr(#__INFO_STRING_, 1, 1) . " & " . SubStr(#__INFO_STRING_, 2), Off
}


;==================== END: #Include .\include\_LOAD_FILES_# :B1AD529B-BF4E-477F-8B9F-3080CAC55AE3

;==================== START: #Include .\include\_Terminator_# :B1AD529B-BF4E-477F-8B9F-3080CAC55AE3

;*************************************************************************************************
;*                                      PROCESS TERMINATOR                                       *
;*************************************************************************************************
;PROCESS TERMINATOR
#__PROCESS_TERMINATOR:
{
	WaitKeysUp(A_ThisHotkey)
	#__TOGGLE_MASTER_HOTKEYS()
	ToolTip("ProcessTerminator","", "PROCESS TERMINATOR","GTTM_TRACKPOSITION.TTM_TRACKACTIVATE L1 I" . #_hIcon_3 . " X" #_XPOS_ . " Y" . #_YPOS_)
	WinGet, #__HSS_HWND_, ID, ahk_pid %#__HSS_PID_%
	Gosub, #_CHECK_PROCESSES
	Loop
	{
		SetTimer,#_CHECK_PROCESSES,-30
		Input, #__TEMP_VAR_, M L1 T0.3, {ESC}{F1}{F2}{F3}{F4}{F5}{F6}{F7}{F8}{F9}{F10}{F11}{F12}{CtrlBreak}{TAB}
		If (ErrorLevel = "EndKey:Escape" or ErrorLevel = "EndKey:Tab"){
			ToolTip("ProcessTerminator","","","GTTM_POP"),#__TOGGLE_MASTER_HOTKEYS("On"),Exit()
		} else if (SubStr(Errorlevel, 1, 8) = "EndKey:F"){
			#__PID_VAR_ := SubStr(ErrorLevel, 9)
			#_MOD_:= GetKeyState("CTRL","P") . GetKeyState("ALT","P")
			Gosub,TerminateProcess
			KeyWait, F%#__PID_VAR_%
		}
		else if Errorlevel = EndKey:CtrlBreak
			GoSub, #__TERMINATE_ALL
		else if ErrorLevel=NewInput
			break
	}
	ToolTip("ProcessTerminator","","","GTTM_POP")
}

ProcessTerminatorToolTip:
If (ErrorLevel = "terminateall"){
	SetTimer, #__TERMINATE_ALL, -100
	Return
}
#__PID_VAR_:=ErrorLevel
#_MOD_:= GetKeyState("CTRL","P") . GetKeyState("ALT","P")
SetTimer, TerminateProcess,-100
Return

ProcessTerminatorToolTipClose:
Input
Return

TerminateProcess:
#_TEMP_VAR:=#__CURRENT_PID_%#__PID_VAR_% 
If (#_MOD_!="00")
{
	If #_MOD_=11
		Process,Close,%#_TEMP_VAR%
	else If #_MOD_=01
		PostMessage,0x111,65305,,,ahk_pid %#_TEMP_VAR%
	else
		PostMessage,0x111,65306,,,ahk_pid %#_TEMP_VAR%
} else if ("#_MOD_ = 00"){
	ToolTip("ProcessTerminator","","PROCESS TERMINATOR -> " . %#_TEMP_VAR%  . " BEING TERMINATED","G1 L1 I" . #_hIcon_3)
	Loop 5
	{
		PostMessage,0x111,65307,,,ahk_pid %#_TEMP_VAR%
		Process, WaitClose,%#_TEMP_VAR%,0.2
		If !ErrorLevel
			Break
	}
	If ErrorLevel
	{
		ToolTip("ProcessTerminator","","PROCESS TERMINATOR -> COULD NOT TERMINATE " . %#_TEMP_VAR%  . " TO KILL PRESS F1","G1 L1 I" . #_hIcon_3)
		Input, #_TEMP_VAR_,M L1 T2,{Escape}{AppsKey}{ALT}{LWIN}{RWIN}{SHIFT}{CapsLock}{NumLock}{LControl}{LAlt}{LShift}{Tab}{Backspace}{Enter}{Left}{Right}{Up}{Down}{Delete}{Insert}{Escape}{Home}{End}{PgUp}{PgDn}{Numpad0}{Numpad1}{Numpad2}{Numpad3}{Numpad4}{Numpad5}{Numpad6}{Numpad7}{Numpad8}{Numpad9}{NumpadDot}{NumpadDiv}{NumpadMult}{NumpadAdd}{NumpadSub}{NumpadEnter}{NumpadIns}{NumpadEnd}{NumpadDown}{NumpadPgDn}{NumpadLeft}{NumpadClear}{NumpadRight}{NumpadHome}{NumpadUp}{NumpadPgUp}{NumpadDel}{NumpadDiv}{NumpadMult}{NumpadAdd}{NumpadSub}{NumpadEnter}{F1}{F2}{F3}{F4}{F5}{F6}{F7}{F8}{F9}{F10}{F11}{F12}{F13}{F14}{F15}{F16}{F17}{F18}{F19}{F20}{F21}{F22}{F23}{F24}{Pause}{Break}{PrintScreen}{LWin}{RWin}{RControl}{RAlt}{RShift}{Space}
		If ErrorLevel=EndKey:F1
			Process,Close,%#_TEMP_VAR%
	}
	Process,WaitClose,%#_TEMP_VAR%,0.2
	RefreshTray()
}
Return

#_CHECK_PROCESSES:
WinGet, #__PID_LIST_, List, AHK_class AutoHotkey
process_list =
#_count = 1
Loop %#__PID_LIST_%
{
	WinGet, #__CURRENT_PID_%#_count%, PID,% "ahk_id " #__PID_LIST_%A_Index%
	If (#__OWN_PID_ = #__CURRENT_PID_%#_count% or #__HSS_PID_ = #__CURRENT_PID_%#_count%)
		continue
	WinGetTitle, #__CURRENT_TITLE_,% "ahk_id " #__PID_LIST_%A_Index%
	If (InStr(#__CURRENT_TITLE_, "#NOPROCESS", 1) and !GetKeyState("SHIFT","P"))
		continue
	#_FILE_START:=InStr(#__CURRENT_TITLE_, "\", 1, 0 )+1
	#_FILE_END:=InStr(#__CURRENT_TITLE_," - AutoHotkey",1,0)-#_FILE_START
	#_FILE_PATH:=SubStr(#__CURRENT_TITLE_, #_FILE_START,#_FILE_END>0 ? #_FILE_END : 100)
	#__KEY_WORD_ := GetKeyWord(#_FILE_PATH)
	process_list .= "`n<a " . #_count . ">F" . #_count . A_Tab . #__CURRENT_PID_%#_count% . A_Tab . #__KEY_WORD_ . "`t`t`t" . #_FILE_PATH . "</a>"
	#_count++
}
If (#_count = 1)
{
	If !GetKeyState("Shift","P")
	{
			ToolTip("ProcessTerminator","","PROCESS TERMINATOR -> NO RUNNING PROCESSES Press Shift to see hidden!","G1 L1 I" . #_hIcon_2)
		KeyWait, SHIFT, D T1
		If ErrorLevel
			ToolTip("ProcessTerminator","","","GTTM_POP"),Input(),#__TOGGLE_MASTER_HOTKEYS("On"),Exit()
	} else
		ToolTip("ProcessTerminator","","PROCESS TERMINATOR -> NO RUNNING PROCESSES, closing terminator…","G1 L1 I" . #_hIcon_2)
		, Sleep(1000),ToolTip("ProcessTerminator","","","GTTM_POP"),Input(),#__TOGGLE_MASTER_HOTKEYS("On"),Exit()
}
ToolTip("ProcessTerminator",#_SETTINGS_GUI_PROCESSTERMINATOR . process_list,"PROCESS TERMINATOR","G1 L1 I" . #_hIcon_2)
Return

#__TERMINATE_ALL:
{
	ToolTip("ProcessTerminator","","TERMINATING ALL PROCESSES", "G1 L1 I" . #_hIcon_3)
	process_list =
	WinGet, #__PID_LIST_, List, AHK_class AutoHotkey
	WinGet, #__HSS_HWND_, ID, ahk_pid %#__HSS_PID_%
	Loop %#__PID_LIST_%
	{
		#__PID_VAR_ := #__PID_LIST_%A_Index%
		WinGet, #__PID_VAR_, PID, ahk_id %#__PID_VAR_%
		If (#__OWN_PID_ = #__PID_VAR_ or #__HSS_PID_ = #__PID_VAR_)
			continue
		WinGetTitle, #__PID_TITLE_,% "ahk_id " #__PID_LIST_%A_Index%
		If (InStr(#__PID_TITLE_, "#NOPROCESS", 1) and !GetKeyState("SHIFT", "P"))
			continue
		ToolTip("ProcessTerminator","" . #__PID_TITLE_,"TERMINATING ALL PROCESSES -> " . #__PID_TITLE_, "G1 L1 I" . #_hIcon_3)
		PostMessage,0x111,65307,,,% "ahk_id " #__PID_LIST_%A_Index%
	}
	RefreshTray()
	Return
}



;==================== END: #Include .\include\_Terminator_# :B1AD529B-BF4E-477F-8B9F-3080CAC55AE3

;==================== START: #Include .\include\_CreateHotString_# :B1AD529B-BF4E-477F-8B9F-3080CAC55AE3
;*************************************************************************************************
;*                              FUNCTION TO CREATE HOTSTRINGS                                    *
;*************************************************************************************************
#__CREATE_HOTSTRINGS_:
{
	If (#__HSS_PID_ != "")
	{
		Process, Exist, %#__HSS_PID_%
		If (Errorlevel != 0)
			Process, Close, %#__HSS_PID_%
	}
	#__HOTSTRING_SCRIPT_ =
	( LTrim
		#SingleInstance, force
		SetBatchLines,-1
		AutoTrim, Off
		DetectHiddenWindows, On
		#MaxThreadsPerHotkey 10
		#MaxThreadsBuffer ON
		#MaxHotkeysPerInterval 999
		#UseHook
		#NoTrayIcon
		#Hotstring EndChars %#__SET__HOTSTRING_END_CHAR_%
		#__SET__HOTSTRING_OPTION_=%#__SET__HOTSTRING_OPTION_%
		#__SET__WARN_ON_AUTOHOTSTRING_=%#__SET__WARN_ON_AUTOHOTSTRING_%
		#__Main_PID_=%#__OWN_PID_%
		#__ToolTip_Options=%#__ToolTip_Options%
		#_XPOS_=%#_XPOS_%
		#_YPOS_=%#_YPOS_%
		#__SET__STANDARD_TOOLTIP_=%#__SET__STANDARD_TOOLTIP_%
		#__SET__HOTSTRING_RUN_=%#__SET__HOTSTRING_RUN_%
		#__SET__HOTSTRING_EDIT_=%#__SET__HOTSTRING_EDIT_%
		#__SET__HOTSTRING_SHOW_=%#__SET__HOTSTRING_SHOW_%
		#__SET__HOTSTRING_COPY_PATH_=%#__SET__HOTSTRING_COPY_PATH_%
		#__SET__HOTSTRING_COPY_DIR_=%#__SET__HOTSTRING_COPY_DIR_%
		#__SET__EDITOR_=%#__SET__EDITOR_%
		#__SET__USE_CHORDING_=%#__SET__USE_CHORDING_%
		#__SET__BALLOON_=%#__SET__BALLOON_%
		If #__SET__USE_CHORDING_
			SetTimer,ActivateChording,-1000
		ToolTip(5," ","","N1 " . #__ToolTip_Options)
		EmptyMem()
		OnMessage(0x4e,"WM_NOTIFY_PIPE")
		#__SET__CHORDING_LENGTH_=%#__SET__CHORDING_LENGTH_%
	)
	#__HOTSTRING_SCRIPT_.="`n#__SET__KEYWORD_ENDCHAR_=" . RegExReplace(#__SET__KEYWORD_ENDCHAR_,"`%","```%") . "`n"
	#_ALL_FILES:=DBArray("files","find")
	Loop,Parse,#_ALL_FILES,""
	{
		If !A_LoopField
			Continue
		StringReplace, #__KEYWORD_PATH,A_LoopField,`n,``n,All
		#__HOTSTRING_SCRIPT_.= "#__FILE_DATABASE.=""" . #__KEYWORD_PATH . """""""`n"
	}
	#__HOTSTRING_SCRIPT_ .= "GoSub, CreateDatabase`nSetTimer, CheckMainProcess, 1000`nReturn`nCheckMainProcess:`nIf !WinExist(""ahk_pid "" #__MAIN_PID_)`nExitApp`nReturn`n"
	If (#__SET__AUTOHOTSTRING_="ON"){
		Loop,Parse,#_ALL_FILES,""
		{
			If !A_LoopField
				Continue
			IfInString,A_LoopField,`n
			{
				If (StrLen(#__KEY_WORD_:=GetKeyWord(SubStr(A_LoopField,1,InStr(A_LoopField,"`n")-1))) > #__SET__HOTSTRING_MAX_)
					Continue
			} else If (StrLen(#__KEY_WORD_:=GetKeyWord(A_LoopField)) > #__SET__HOTSTRING_MAX_)
				Continue
			#__HOTSTRING_SCRIPT_ .= ":" . #__SET__HOTSTRING_OPTION_ . ":" . #__SET__HOTSTRING_RUN_ . #__KEY_WORD_ . "::`n"
		}
		#__HOTSTRING_SCRIPT_ .= "GoSub, Run_Script`nReturn`n"
		Loop,Parse,#_ALL_FILES,""
		{
			If !A_LoopField
				Continue
			IfInString,A_LoopField,`n
			{
				If (StrLen(#__KEY_WORD_:=GetKeyWord(SubStr(A_LoopField,1,InStr(A_LoopField,"`n")-1))) > #__SET__HOTSTRING_MAX_)
					Continue
			} else If (StrLen(#__KEY_WORD_:=GetKeyWord(A_LoopField)) > #__SET__HOTSTRING_MAX_)
				Continue
			#__HOTSTRING_SCRIPT_ .= ":" . #__SET__HOTSTRING_OPTION_ . ":" . #__SET__HOTSTRING_EDIT_ . #__KEY_WORD_ . "::`n"
		}
		#__HOTSTRING_SCRIPT_ .= "GoSub, Edit_Script`nReturn`n"
		Loop,Parse,#_ALL_FILES,""
		{
			If !A_LoopField
				Continue
			IfInString,A_LoopField,`n
			{
				If (StrLen(#__KEY_WORD_:=GetKeyWord(SubStr(A_LoopField,1,InStr(A_LoopField,"`n")-1))) > #__SET__HOTSTRING_MAX_)
					Continue
			} else If (StrLen(#__KEY_WORD_:=GetKeyWord(A_LoopField)) > #__SET__HOTSTRING_MAX_)
				Continue
			#__HOTSTRING_SCRIPT_ .= ":" . #__SET__HOTSTRING_OPTION_ . ":" . #__SET__HOTSTRING_SHOW_ . #__KEY_WORD_ . "::`n"
		}
		#__HOTSTRING_SCRIPT_ .= "GoSub, Show_Script`nReturn`n"
		Loop,Parse,#_ALL_FILES,""
		{
			If !A_LoopField
				Continue
			IfInString,A_LoopField,`n
			{
				If (StrLen(#__KEY_WORD_:=GetKeyWord(SubStr(A_LoopField,1,InStr(A_LoopField,"`n")-1))) > #__SET__HOTSTRING_MAX_)
					Continue
			} else If (StrLen(#__KEY_WORD_:=GetKeyWord(A_LoopField)) > #__SET__HOTSTRING_MAX_)
				Continue
			#__HOTSTRING_SCRIPT_ .= ":" . #__SET__HOTSTRING_OPTION_ . ":" . #__SET__HOTSTRING_COPY_PATH_ . #__KEY_WORD_ . "::`n"
		}
		#__HOTSTRING_SCRIPT_ .= "GoSub, Copy_Path`nReturn`n"
		Loop,Parse,#_ALL_FILES,""
		{
			If !A_LoopField
				Continue
			IfInString,A_LoopField,`n
			{
				If (StrLen(#__KEY_WORD_:=GetKeyWord(SubStr(A_LoopField,1,InStr(A_LoopField,"`n")-1))) > #__SET__HOTSTRING_MAX_)
					Continue
			} else If (StrLen(#__KEY_WORD_:=GetKeyWord(A_LoopField)) > #__SET__HOTSTRING_MAX_)
				Continue
			#__HOTSTRING_SCRIPT_ .= ":" . #__SET__HOTSTRING_OPTION_ . ":" . #__SET__HOTSTRING_COPY_DIR_ . #__KEY_WORD_ . "::`n"
		}
		#__HOTSTRING_SCRIPT_ .= "GoSub, Copy_Dir`nReturn`n"
	}
	#__HOTSTRING_SCRIPT_ .= "`n" . #__Auto_Hot_String_Str_N . "`n" . #__Includes_Str_N
	#__HSS_PID_:=RunPipeByRef(#__HOTSTRING_SCRIPT_, "AutoHotFile_AHS")
	Return
}

;==================== END: #Include .\include\_CreateHotString_# :B1AD529B-BF4E-477F-8B9F-3080CAC55AE3

;==================== START: #Include .\include\_Help_# :B1AD529B-BF4E-477F-8B9F-3080CAC55AE3
#__Create_Help:
#__ALL_MENUS = AutoStart|AutoHotString|FileReminder|ReloadScript|WebBrowser|Editor|WorkingDir|WorkingExtensions|Suggest|Language|Advanced|HelpAutoStart|HelpAutoHotString|HelpFileReminder|HelpReloadScript|HelpWebBrowser|HelpEditor|HelpWorkingDir|HelpWorkingExtensions|HelpSuggest|HelpAdvanced|HelpProfiles
If (#__SET__LANGUAGE_ != "DE")
		Gosub, #__EN_MENU_HELP
	else if #__SET__LANGUAGE_ = DE
		Gosub, #__DE_MENU_HELP

#__Help_MENU_QUICK_TUTORIAL=
(Join
AutoHotfile is a very fast and smart KeyWord Launcher`nIt will speed up your work on computer incredibly
|Access to web and files will be faster and easier than ever
|Opening, searching and editing files scripts and programs will be quicker than ever
|This tutorial will help you to get around with AutoHotFile
|File name is used to define keyword and some options
|Keyword is build from characters of file name`nCharacters before . will represent the keyword`nFor compatibility reason, all non word/digit characters are replaced by _
|So for example a file called "My Main Script.ahk" will be keyworded as My_Main_Script
|Follwing options are optional and can be included in name of the file (those are case sensitive).`n`n - AUTOSTART`tStart this file when AutoHotFile starts up`n`t`tFor example you can start your "always running" AHK scripts that way`n`n - CAPSLOCK[a-z0-9] or SCROLLLOCK[a-z0-9] or NUMLOCK[a-z0-9]`n`t`tThis option will activate a hotkey for this file`n`t`tFor example a file called MyScript.CAPSLOCKm.ahk can be launched by pressing CAPSLOCK & M`n`n - #Timestamp`tThis is used by FileReminder, It an open a file at desired time`nSee more explanation in help`n - HOTKEY[a-z0-9]`tThis is a special hotkey that can be enabled by pressing CAPSLOCK & SHIFT`n`t`tUsing that hotkey you can launch a file by pressing two letters`n`t`tFor example MyScript.HOTKEYms.ahk can be launched by pressing M & S`n`n - #NOPROCESS`tUsed to hide processes in Process Terminator (CapsLock & Pause)
|To start the Launcher, press Capslock & Tab
|A ToolTip will pop up and you can now type your entry to perform desired action
|Following functions/entries are possible, those will be launched depending on the prefix you type:`n`n - KeyWord`tType a Keyword to launch a file or program`n`t`tAutoHotFile will suggest found files and you can launch them by pressing F1-12 key or Enter`n`n`t`tYou can also edit first found file by pressing CTRL & E or CTRL & F1-12`n`t`tALT & E or ALT & F1-12 to open the file in Explorer`n`t`tYou can also copy the path of the file to clipboard `n`t`tTherefore press CTRL & C or CTRL & ALT & F1-12`n`n - Website`tYou can type the name of the website and enter to launch it, e.g. autohotkey`n`n - Web search`tFind something on web very quickly`n`t`tthere are many prefixes available, for those you can set up different web sites`n`n =`t`tQuick calculator, e.g. =(5+5)*2/(3*0.5)`n`n - :`t`tThis is used to launch AutoHotkey commands, you can press CTRL & Enter to add new line, e.g. :MsgBox `% A_Now`n`n - \ or [a-z]:`tSearch for a file or folder on a drive or network path by typing the file and/or folder name, use ? and * wildcard`n`t`tMore details will follow later in this tutorial`n`n - !`t`tSearch trough favorit entries (save those by pressing CTRL & S in KeyWord Launcher)
|Following hotkeys can be used in KeyWord Launcher:`n`n - CTRL & C`tCopy Path of keyword, if no keyword found entry is copied`n - CTRL & V`tPaste from Clipboard`n - CTRL & S`tSave current entry as favorit (find those by entering ! prefix)`n - CTRL & E`tEdit first found file (CTRL & F1-12 for other found files)`n - ALT & E`tShow first found file (ALT & F1-12 for other found files)`n - CTRL + R`tReload`n - CTRL & A`tExit AutoHotFile`n - CTRL & ENTER New line for entry (used for AutoHotkey commands)
)

#_info_help = `n`nENTER`t`t`t- automatically execute required action`n`t`t`t- depends on prefix like ""."" ""#"" ""!"" ""c:""`nF1-F12`t`t`t- execute found file using assigned program`nDOWN and UP`t`t- list next or previously found files`nCTRL+C or V`t`t- copy and paste (CTRL+SHIFT+F1-12)`nCTRL+S or D`t`t- save or delete entry (enter ! to list and select those)`nALT+E or ALT+F1-12`t- show file in explorer or autoselect in a dialog`nCTRL+E or CTRL+F1-12`t- edit files using defined editor`nCTRL+R`t`t- Reload`nCTRL+A`t`t- exit AutoHotFile`nPGDN or PGUP`t`t- Select next or previous entry`nCAPSLOCK hotkeys:`n - F1 AutoStart | F2 Repeat last action | F3/F4 Hide+show window`n - F5 Run AHK script from Clipboard | F6 Reset reminder`n - F7 List all hotkeys | F8 show ini file | F9 Settings`n - F10 Suspend hotkeys | F11 Pause/Unpause all scripts | F12 Restart`n - SPACE Repeat last action | SHIFT Activate SpeedHotkey`n - ENTER Resolve an Windows Environment variable in a dialog Edit field`n - PAUSE Script terminator

#_TT_ALL=Button2|Button3|Button4|Button5|Button6|Button7|Button8|Button9|Button10|Button11|Button12|Button13|Button14|Button15|Button17|Button18|Button25|Button26|Button27|Button28|Button29|Button32|Button33|Button34|Button36|Button37|Button38|Button39|Button40|Button49|Button50|Button51|Button53|Button58|Button59|Button60|Button61|Button62|Button63|Button64|Button65|Button67|Button68|Button69|Button70|Button72|Button75|Button73|Edit1|Edit2|Edit3|Edit4|Edit5|Edit6|Edit7|Edit8|Edit9|Edit10|Edit11|Edit12|Edit14|Edit17|ComboBox1|ComboBox5|ComboBox6|Static6|Static7|Static8|Static9|Static10|Static11|Static15|Static18|Static23|SysListView3250|SysListView3251|SysListView3252
If (#__SET__LANGUAGE_ = "DE")
{
	#_TT_Button2:=#_TT_Button3:=#_TT_Button4:=#_TT_Button5:="Wenn AutoHotFile startet`, sucht es nach Dateien.`nDateien mit dem Wort AUTOSTART (großgeschrieben) werden automatisch gestartet`nAuswahl = beim Start nachfragen."
	#_TT_Button6:=#_TT_Button7:=#_TT_Button8:="Mit AutoHotString kann man Dateien durch tippen starten`nJede geladene Datei bekommt ein Schlüsselwort`, Punkt (.) im Dateinamen bestimmt Ende des Schlüsselwortes.`nDiese Schlüsselwörter werden zum HotString und mann kann z.B. durchs tippen von #keyword{Tab} Datei öffnen."
	#_TT_Button9:=#_TT_Button10:=#_TT_Button11:="File Reminder öffnet Dateien zum benötigtem Zeitpunkt/Datum/Wochentag.`nGebe # im Dateinamen und anschließend eine der folgenden Kombinationen:`n - #200902012000 Zeitpunkt`, kann Monat`, Tag`, Stunde`, Minute sein.`n - #MON1200 - Wochentag (Kürzel in englisch) und Uhrzeit`, Minuten und Stunden sind optional`n - #1200 Zeitpunkt nur Minuten und Stunden`, erinnert täglich wenn Zeitpunkt verstrichen."
	#_TT_Button12:=#_TT_Button13:=#_TT_Button14:=#_TT_Button15:="Neustarten der AutoHotkey Scripte wenn Änderungen gespeichert wurden."
	#_TT_Edit1:=#_TT_Button17:="WebBrowser wird zum starten der Websuche und Webseiten in KeyWord Launcher benötigt.`n - z.B. . (Punkt) Präfix wird zur Suche auf Goolge benutzt`n - ? Präfix für Google Maps`n - - Präfix für Ebay`n - Wenn ein Eintrag ohne Präfix erfolgt`, wird die Google Auf Gut Glück Funktion benutzt.`n - Man kann auch http://www… or 192.168.2.1 eintippen um im Webbrowser zu öffnen."
	#_TT_Edit2:=#_TT_Button18:="Editor wird zum öffnen der scripte und Dateien benutzt.`nDrücke z.B. CTRL & E oder CTRL & F1-12 um die eingegebene Datei im Editor zu öffnen.`nAutoHotString hat ebenfalls ein Startzeichen für editieren der Dateien."
	#_TT_Button25:=#_TT_Button26:=#_TT_Button27:="Mit AutoHotString kann man durch tippen verschiedene Aktionen ausführen.`nJede geladenen Datei wird zu einem Schlüsselwort,`nPunkt (.) in den Dateinamen bestimmt das Ende des Schlüsselwortes. `nDiese Schlüsselwörter werden zum HotString`n Tippe z.B. #keyword{Tab} um die Datei zu öffnen."
	#_TT_ComboBox1:=#_TT_Button28:="Maximale Länge für Hotstrings.`nWenn Schlüsselwort länger als dieser Wert = kein Hotstring." 
	#_TT_Button29:="Timer für AutoHotString.`nWenn du den Hotstring eintippst und die Endtaste drückst`nwird ein ToolTip angezeigt und du kannst den Start abbrechen.`nDu kannst auch Werte unter 1 secunde angeben, z.B. 0.1`nGebe 0 ein um die Datei ohne ToolTip zu starten ."
	#_TT_SysListView3250:=#_TT_Button32:=#_TT_Button33:=#_TT_Button34:="Hier musst die die Ordner angeben. Drücke F2 zum Bearbeiten`nAutoHotFile sucht in diesen Ordnern nach Dateien.`nGebe / nach dem Ordner ein um Filter für Dateien einzugeben`, * und ? können als Wildcard benutzt werden`n!!! Um auch, oder nur nach ordner zu suchen, einfach /* eingeben`n`nz.B. nur nach Musik Dateien suchen: /*.mp3/*.wav/*.avi…`nCheckbox setzen um Suche in unterordner einzuschalten."
	#_TT_SysListView3251:=#_TT_Button36:=#_TT_Button37:="Hier kannst du Dateierweiterungen eingeben und löschen. Drücke F2 um zu bearbeiten`nEs werden nur Dateien geladen die den Erweiterungen entsprechen.`n! Dieser Filter gilt nicht für Ordner mit Dateiparameter (/*.ahk...) !"
	#_TT_SysListView3252:=#_TT_Button38:=#_TT_Button39:=#_TT_Button40:="Doppelclick um Profil auszuwählen.`nGeladene Ordner werden in dem File patterns Reiter angezeigt."
	#_TT_Static18:=#_TT_Button49:=#_TT_Button50:=#_TT_Button51:="Capslock kann deaktiviert werden und als MultiHotkey benutzt werden.`nFolgende Aktionen können ausgeführt werden:`n - ein mal drücken um KeyWord Launcher zu starten`n - 2 mal drücken um SpeedHotkey zu aktivieren`n - 3 mal drücken um AutoHotkey Script Terminator zu starten`n - 4 mal drücken um Einstellungen zu öffnen."
	#_TT_Edit12:=#_TT_Button53:=" (?) auch starten wenn Hotstring im wort vorkommt.`n (B0) Nicht zurücksetzten.`n (C) Klein/Großschreiben beachten`n (0) Endtaste nicht senden`n (*) Keine Endtaste erforderlich (nicht empfehlenswert)"
	#_TT_Button58:=#_TT_Button59:=#_TT_Button60:=#_TT_Button61:=" - Um BalloonTips zu benutzen, müssen diese in Windows aktiviert werden!!!`n - Klick durch ToolTip.`n - Benutze standard ToolTip (ermöglicht farbige ToolTips in Vista)"
	#_TT_Button62:=#_TT_Button63:="Anstatt dein Skript mit AutoHotkey.exe zu starten`, kann AutoHotFile dein Script`nmit umbenenen der Datei AutoHotFile.exe als exe starten.`n - AutoHotFile.exe ist eine umbenannte AutoHotkey.exe 1.0.48`n - z.B. wird MyScript.ahk als MyScript.exe im Task Manager angezeigt.`n - Benutze diese Option ebenfalls wenn AutoHotkey nicht installiert ist."
	#_TT_Button64:=#_TT_Button65:="Beim benutzen von Web Präfix kann AutoHotFile die Webseite in den Speicher laden`nund Links von der Seite zur Auswahl anzeigen."
	#_TT_Edit3:="Timer for AutoHotString.`nIf you about to run your file using AutoHotString and you press end character`na ToolTip will be shown and you can cancel opening file by pressing any key.`nYou can enter a decimal value as well e.g. 0.1`nEnter 0 to start file without showing a Tooltip."
	#_TT_Static6:=#_TT_Edit4:="Durch eintippen dieses Zeichens`, einem Schlüsselwort und der Endtaste wird die Datei geöffnet."
	#_TT_Static7:=#_TT_Edit5:="Durch eintippen dieses Zeichens`, einem Schlüsselwort und der Endtaste wird die Datei im Editor geöffnet."
	#_TT_Static8:=#_TT_Edit6:="Durch eintippen dieses Zeichens`, einem Schlüsselwort und der Endtaste wird die Datei im Explorer oder in einem dialog geöffnet."
	#_TT_Static9:=#_TT_Edit7:="Durch eintippen dieses Zeichens`, einem Schlüsselwort und der Endtaste wird der Dateipfad in die Zwischenablage kopiert"
	#_TT_Static10:=#_TT_Edit8:="Wie oben`, kopiert aber den Ordnerpfad der Datei."
	#_TT_Static11:=#_TT_Edit9:="Endtaste`, feuert den Befehl ab."
	#_TT_Static15:=#_TT_Edit10:=#_TT_Edit11:=" - gebe Caret ein um den Einschaltungszeichen als Koordinaten zu benutzen.`n - gebe TrayIcon ein um den Icon im Tray als coordinaten zu benutzen`n - Leeren um Mauskoordinaten zu benutzen`n - ebenfalls kann man Bildschirmkoordinaten angeben."
	#_TT_Edit14:="Gebe an in Milisekunden die Verzögerung der Suche im KeyWord Launcher`nDas ist z.B. nützlich wenn man 24 Dateien anzeigen will."
	#_TT_Button67:=#_TT_Button68:="Durch das vorladen des Processes started AutoHotFile Datei Explorer schneller."
	#_TT_Button69:=#_TT_Button70:="Durch das vorladen des Processes started AutoHotFile CMD schneller."
	#_TT_Button72:=#_TT_Button73:="AutoHotFile.exe kann beim starten automatisch nach neuer Version überprüfen.`nAnschließend kann diese automatisch heruntergeladen und installiert werden."
	#_TT_Button75:=#_TT_Static23:=#_TT_ComboBox5:="Tippe das Schlüsselwort und halte die erste-vorletzte Taste gedrückt um eine Datei zu öffnen`nMinimale Tasten bedeuted nicht öffnen wenn weniger Tasten nacheinander gedrückt wurden`n - Z.B. Datei Script.ahk, drücke und halte s und tippe cript, lasse s los und Datei wird gestarted`n - Alle Tasten, außer der letzten, können zum abfeuern benutzt werden!"
	#_TT_Edit17:="Zeichen für Erstellen der Schlüsselwörter`n - Es können mehrere Zeichen angegeben werden.`n - | gilt in dem Fall als Trennzeichen`n - Wenn leer, wird kompletter Dateiname als Schlüsselwort benutzt"
	#_TT_ComboBox6:="Standard Suche, wenn AutoHotFile explorer startet sucht dies automatisch nach:`n0 = Nur Dateien`n1 = Dateien und Ordner`n2 = Nur Ordner"
}
else ;if (#__SET__LANGUAGE_ = "EN")
{
		#_TT_Button2:=#_TT_Button3:=#_TT_Button4:=#_TT_Button5:="When you start AutoHotFile it scans for your defined files.`nFiles having word AUTOSTART (must be capital) can be opened on the fly.`nSet On to use that feature`, Set Ask to choose on start whether to open these files."
	#_TT_Button6:=#_TT_Button7:=#_TT_Button8:="AutoHotString will let you perform different actions by typing only.`nEach loaded file becomes a keyword`, dot (.) in file name determines the end of keyword.`nThese keywords can become a hotstring so for example typing #keyword{Tab} opens the file."
	#_TT_Button9:=#_TT_Button10:=#_TT_Button11:="File Reminder can automatically open a file at certain time/date/weeks day.`nInclude # in file name followed by one of following combination:`n - #200902012000 Timestamp`, can be Month`, Day`, Hour`, Minute`n - #MON1200 - Weekday followed by hours and minutes`, minutes+hours are optional`n - #1200 Timestamp hours and minutes only`, will remind any day after this time passed."
	#_TT_Button12:=#_TT_Button13:=#_TT_Button14:=#_TT_Button15:="Reload your AutoHotkey script automatically when changes are saved to the file."
	#_TT_EDIT1:=#_TT_Button17:="WebBrowser is used to launch websites and web searches from KeyWord Launcher.`n - For example . (dot) prefix is used to search on Google`n - ? prefix is used to search on Google Maps`n - - prefix to search on Ebay.`n - If you enter a string without a prefix`, it will be launched trough Google I'm feeling lucky.`n - You can also enter http://www… or 192.168.2.1 to open it in your webbrowser"
	#_TT_Edit2:=#_TT_Button18:="Editor is used to edit your scripts or any other files in your editor.`nPress for example CTRL & E to edit entered file or CTRL & F1-12 to open suggested files.`nAutoHotString includes a start character to open file in editor as well."
	#_TT_Button25:=#_TT_Button26:=#_TT_Button27:="AutoHotString will let you perform different actions by typing only.`nEach loaded file becomes a keyword`, dot (.) in file name determines the end of keyword.`nThese keywords can become a hotstring so for example typing #keyword{Tab} opens the file."
	#_TT_ComboBox1:=#_TT_Button28:="Maximal characters for hotstrings.`nIf keyword is longer than this value`, no hotstring is created for it."
	#_TT_Button29:="Timer for AutoHotString.`nIf you about to run your file using AutoHotString and you press end character`na ToolTip will be shown and you can cancel opening file by pressing any key."
	#_TT_SysListView3250:=#_TT_Button32:=#_TT_Button33:=#_TT_Button34:="Here you need to select directories. Press F2 to edit selected line.`nAutoHotFile will search trough these directories for files.`nSpecify / to add a file filter`, you can use * and ? as wildcard.`n!!! To search for folders as well or only for folders enter /*`n`nFor example search for media files only: /*.mp3/*.wav/*.avi…`nTick checkbox to enable search in sub directories."
	#_TT_SysListView3251:=#_TT_Button36:=#_TT_Button37:="Here you can add and delete extensions. Press F2 to edit selected line.`nWhen searching for files in your directories only these files are loaded.`n! This filter is not valid for directories having / option like /*.ahk !"
	#_TT_SysListView3252:=#_TT_Button38:=#_TT_Button39:=#_TT_Button40:="DoubleClick a profile to select it and load custom directories!`nCustom directories are loaded and shown in File patterns tab."
	#_TT_Button49:=#_TT_Button50:=#_TT_Button51:="You can disable CapsLock and use it as a hotkey to perform several actions.`nIf you do so, pressing Capslock will perform following actions:`n - press once to start KeyWord Launcher`n - press twice to enable SpeedHotkey`n - press 3 times to open AutoHotkey Script Terminator`n - press 4 times to open Settings GUI."
	#_TT_Edit12:=#_TT_Button53:=" (?) trigger even if you are inside a word`n (B0) no backspacing`n (C) case sensitive`n (0) omit ending character`n (*) means no EndCharacter is required (not recommended)"
	#_TT_Button58:=#_TT_Button59:=#_TT_Button60:=#_TT_Button61:=" - To use BalloonTips, those must be enabled in Windows!!!`n - Click trough will let you click trough the ToolTip.`n - Enable usual ToolTip (enables colored ToolTip for Vista!)"
	#_TT_Button62:=#_TT_Button63:="Instead of starting your script with AutoHotKey.exe AutoHotFile can start your script`nrenaming AutoHotFile.exe to scripts name before executing it.`n - AutoHotFile.exe is a renamed AutoHotkey.exe 1.0.48`n - So a script MyScript.ahk will be shown as MyScript.exe in Task Manager`n - Use this option if AutoHotKey is not installed on your computer as well"
	#_TT_Button64:=#_TT_Button65:="When you use web prefix, AutoHotFile can preload links if possible.`nIt will suggest found links and you can open these or copy the url."
	#_TT_Edit3:="Timer for AutoHotString.`nIf you about to run your file using AutoHotString and you press end character`na ToolTip will be shown and you can cancel opening file by pressing any key."
	#_TT_Edit4:="Entering this character`, a keyword and end character will start your file.`nSame as double click it in windows explorer."
	#_TT_Edit5:="Entering this character`, a keyword and end character will open the file in editor."
	#_TT_Edit6:="Entering this character`, a keyword and end character`n opens your file in windows explorer (new window) or open/save dialog."
	#_TT_Edit7:="Entering this character`, a keyword and end character will copy the path of this file to clipboard.`nSo you can easy paste it anywhere via CTRL & V."
	#_TT_Edit8:="Same as above but copies the directory path where the file is in."
	#_TT_Edit9:="End Character indicates to take action`, after pressing this character file will be opened."
	#_TT_Static15:=#_TT_Edit10:=#_TT_Edit11:=" - enter Caret to use caret coordinates.`n - enter TrayIcon to use tray icon coordinates`n - leave empty to use mouse coordinates`n - you can also enter screen coordinates to use."
	;#_TT_Edit12:=" (?) trigger even if you are inside a word`n (B0) not backspacing`n (C) case sensitive`n (0) omit ending character`n (*) means no EndCharacter is required (not recommended)"
	#_TT_Edit14:="Enter how many Miliseconds to wait before searching for a file.`nThis is especially useful if you have a lot of files and suggestion lists 24 items."
	;#_TT_ComboBox1:="Maximal characters for hotstrings.`nIf keyword is longer than this value`, no hotstring is created for it."
	#_TT_Static6:="Entering this character`, a keyword and end character will start your file.`nSame as double click it in windows explorer."
	#_TT_Static7:="Entering this character`, a keyword and end character will open the file in editor."
	#_TT_Static8:="Entering this character`, a keyword and end character`n opens your file in windows explorer (new window) or open/save dialog."
	#_TT_Static9:="Entering this character`, a keyword and end character will copy the path of this file to clipboard.`nSo you can easy paste it anywhere via CTRL & V."
	#_TT_Static10:="Same as above but copies the directory path where the file is in."
	#_TT_Static11:="End Character indicates to take action`, after pressing this character file will be opened."
	#_TT_Static18:="You can disable CapsLock and use it as a hotkey to perform several actions.`nIf you do so, pressing Capslock will perform following actions:`n - press once to start KeyWord Launcher`n - press twice to enable SpeedHotkey`n - press 3 times to open AutoHotkey Script Terminator`n - press 4 times to open Settings GUI."
	#_TT_Button67:=#_TT_Button68:="Preloading AutoHotFile File Explorer will start it faster when typing c:..."
	#_TT_Button69:=#_TT_Button70:="Preloading AutoHotFile CMD will start it faster when typing #..."
	#_TT_Button72:=#_TT_Button73:="AutoHotFile.exe can automatically check for updates on each start.`nAfterwards it can be downloaded and installed automatically."
	#_TT_Button75:=#_TT_Static23:=#_TT_ComboBox5:="Type your KeyWord and keep a key pressed to run a file`nMinimal chars means do not launch if less keys successively pressed`n - E.g. filename is Script.ahk, press and hold s, type cript and release s to start that file`n - Each key can be used to fire up file start but not the last one!"
	#_TT_Edit17:="Characters that will be used for KeyWord creation`n - You can use several different characters. | is used as separator in that case`nLeave empty to use complete filename as KeyWord"
	#_TT_ComboBox6:="Standard search, when AutoHotFile is launched it will search for:`n0 = files only`n1 = files and folders`n2 = folders only"
}
#_SETTINGS_LANGUAGES=EN|DE
Loop,Parse,#_SETTINGS_LANGUAGES,|
	If A_LoopField=%#__SET__LANGUAGE_%
		#_SETTINGS_LANGUAGE:=A_Index
#_SETTINGS_GUI=WELCOME|WELCOME_TEXT|AUTOSTART|ON|OFF|ASK|AUTOHOTSTRING|AUTOHOTSTRINGSETTINGS|AUTOHOTSTRINGTEXT|FILEREMINDER|KILL|RELOAD|CUSTOMAPP|WEBBROWSER|EDITOR|COLOR|COLORBOX|COLORBACKGROUND|COLORTEXT|HOTSTRINGOPEN|HOTSTRINGEDIT|HOTSTRINGSHOW|HOTSTRINGCOPY|HOTSTRINGCOPYPATH|HOTSTRINGENDCHAR|PATHS|ADDPATH|DELPATH|DELALLPATHS|PATHHEADER|EXTENSIONS|ADDEXT|DELEXT|PROFILES|PROFILESINFO|PROFILESLIST|PROFILESHEADER|FAVORITES|FAVORITESINFO|USEWILDCARD|WILDCARDINFO|POS|POSINFO|CAPSLOCK|CAPSLOCKINFO|MULTIHOTKEY|NORMAL|HELP|OPTIONS|LISTSUGGEST|LISTSUGGESTINFO|TIMER|WEBLAUNCHER|WEBLAUNCHERINFO|WEBLAUNCHERMAIN|WEBLAUNCHERPARAMS|WEBLAUNCHERLIST|BALOON|CLICKTROUGH|STANDARDTOOLTIP|TUTORIAL|WEBLOADANDSUGGEST|SAVESETTINGS|RESETSETTINGS|LANGUAGE|SAVERELOADASK|SAVEASKINFO|SAVEASK|RESETASKINFO|RESETASK|RUNAHKASEXE|FILEEXPLORER|PIPEPRELOAD|STDOUTTOVAR|AUTOHOTSTRINGCHARS|HOTKEYS|HOTKEYACTION|HOTKEYACTION1|HOTKEYACTION2|HOTKEYACTION3|HOTKEYACTION4|HOTKEYACTION5|HOTKEYACTION6|HOTKEYACTION7|HOTKEYACTION8|HOTKEYACTION9|HOTKEYACTION10|HOTKEYACTION11|HOTKEYACTION12|HOTKEYACTION13|HOTKEYACTION14|HOTKEYACTION15|HOTKEYACTION16|HOTKEYACTION17|AUTOUPDATE|CHECKFORUPDATE|NOTFOUND|KEYWORDENDCHAR|CHORDING|USECHORDING|CHORDINGLENGTH|FAVORITENTRIES|PROCESSTERMINATOR
#_SETTINGS_GUI_VAR=
(
Welcome|Willkommen
Settings for KeyWord Launcher and other features. Press CapsLock + Tab to start Launcher.|Hier findest du alle Einstellungen für AutoHotFile. Starte AutoHotFile mit CAPSLOCK+TAB.
Autostart Files|Autostart
On|An
Off|Aus
Ask|Auswahl
AutoHotString|AutoHotString
AutoHotString Settings|AutoHotString Einstellungen
Using HotString (a feature by AutoHotkey) it is possible to start a program or open a file by typing a sequence of characters only.<><>Using first character for different actions and last character to indicate execute, you get a great way to open, edit, show, copy a file.<><>For example your file is called MyScript.ahk (myscript will be a keyword for your file).<>If # is open char and ``t endchar, typing #myscript and pressing {Tab} will open that file.|Mit HotString (eine Funktion in AutoHotkey) ist es möglich programme und dateien durchs tippen zu starten.<><>Das erste Zeichen steht für die verschiedenen Aktionen wie öffnen, bearbeiten, anzeigen, pfad kopieren.<>Zum Beispiel deine Datei heißt MyScript.ahk (myscript wird das Schlüsselwort).<> Wenn # das Zeichen für öffnen und ``t für Endzeichen steht, kann man durch tippen von #myscript{TAB} die Datei öffnen.
File Reminder|Erinnerung
Kill and restart|Beenden und starten
Auto reload AHK scripts|AHK Script neustarten
Custom Applications|Programme
&WebBrowser|&WebBrowser
&Editor|&Editor
KeyWord Launcher colors|KeyWord Launcher farben
Color to change|Zu ändernde Farbe
&Background|&Hindergrund
&Text|&Text
Open file(s) using default application|Datei(en) mit standard Programm öffnen
Edit file(s) using specified editor (see general tab)|Datei(en) mit angegebenem Editor öffnen
Show file(s) in windows explorer or autoselect in a dialog|Datei(en) im Explorer anzeigen oder im Dialog auswählen
Copy full file path to clipboard|Dateipfad in die Zwischenablage kopieren
Copy file directory path to clipboard|Ordnerpfad in die Zwischenablage kopieren
EndChar`, this key will execute command (``t`, ``n`,``t ``n)|Endzeichen`, startet den Befehl (``t`, ``n`,``t ``n)
Paths|Pfade
&Add path|&Neuer Pfad
Delete selected &path|&Pfad löschen
Delete a&ll paths|&Alle löschen
Files path/patterns. Tick to search subfolder|Dateipfad/-parameter. Häckhen setzen um Unterordner duchzusuchen.
Extensions|Erweiterungen
A&dd|N&eu
D&el|&Lösch
Why using profiles|Warum brauche ich Profile
Using profiles you can load different files "environment".<><>For example you have one group of directories for your office, one for your home PC, one for your laptop and so on…<>Another great usage is to have one for your media/photo files, another for documents and so on…<><>This way you can assign short keywords and be very quick working on computer.|Mithilfe der Profile kann man verschiedene Dateien/Ordner laden.<><>Zum Beispiel eine gruppe von Ordnern und Dateien für Büro, eins fürs zuhause, eins für Laptop usw.<><>So kann man mithilfe von kurzen Schlüsselwörtern sehr schnell arbeiten und AutoHotFile mobil auf einem Speicherstick benutzen.
Profiles (Select and press Save settings button to change)|Profile (mit Doppelklick auswählen und speichern klicken)
Profiles (Double Click to select and apply)|Profile (Doppelklick um auszuwählen)
Favorite entries|Favoriten
Here you can save often used entries, such as websites, file paths, AutoHotkey commands (using : prefix) and more. Type ? in KeyWord Launcher to search trough favorits.|Hier können oft benutzte Einträge gespeichert werden, z.B. webseiten, ordner, AutoHotkey Befehle (: Präfix) und mehr. ? in KeyWord Laucher eintippen um diese durchzusuchen.
Use wildcard (*)|Wildcard benutzen (*)
You can use wildcard setting to find your keywords even if you start typing in middle of keyword. For example you type scr and it finds your keyword myscript.ahk|Du kannst Wildcard benutzen um nach dem Eintrag in der mitte der Schlüsselwörter zu suchen. Z.B. beim tippen von scr findet AutoHotFile myscript.ahk
KeyWord Laucher position|KeyWord Launcher Position
You can display launcher near your mouse or under caret position. Caret is where you see flashing -- when you type in an edit field. You can also enter coordinates.|Du kannst Launcher unter Einschaltungszeichen anzeigen. Einschaltungszeichen ist wo der Cursor blinkt. Man kann ebenfalls Bildschirmkoordinaten benutzen.
Use CapsLock|CapsLock benutzen
Capslock is used to launch keyword launcher and also for dynamic Hotkeys (those assigned to your files). If you Disable CapsLock, it becomes additionally a multihotkey for AutoHotFile.|CapsLock wird zum Starten von KeyWord Launcher und anderen Funktionen benutzt. Beim deaktivieren mutiert CapsLock zu einem multihotkey für AutoHotFile.
&Multihotkey|&Multihotkey
&Normal|&Normal
AutoHotFile Help|AutoHotFile Hilfe
Options|Optionen
List Suggestions|Vorschläge auflisten
Enter how many found (matched entries) files you would like to have listed. When your keyboard has F1-F24 keys, more files can be listed and selected.|Gebe an wieviele treffer angezeigt werden sollen. Wenn die Tastatur F1-F24 Tasten hat, kann man mehr Vorschläge angezeigt und gewählt werden.
Timer:|Timer:
Web launcher|Weblauncher
Open your entry trough Google's I'm Feeling Lucky function and custom websearches.<><>Enter the website including the search options in front of the prefix into the list below.<>Include space character instead of your search string if it is somewhere in the middle!<>For example you want to search for videos on google, so your web parameter is:<>    http://video.google.com/videosearch?q= &&emb=0&&aq=f#<>In this case following parameter will be passed on to your webbrowser:<>    http://video.google.com/videosearch?q=AutoHotkey&&emb=0&&aq=f#|Öffne den Eintrag im KeyWord Launcher über Google Auf Gut Glück Funktion und andere.<><>Gebe die Webseite inklusive der Suchfunktion unten ein.<>Wenn der Suchbegriff in der Mitte der Eintrags liegt gebe dort ein Leerzeichen ein.<>Z.B. um nach videos auf Goolge Video zu suchen:<>    http://video.google.com/videosearch?q= &&emb=0&&aq=f#<>In diesem fall wird folgender parameter an den Webbrowser übergeben<>    http://video.google.com/videosearch?q=AutoHotkey&&emb=0&&aq=f#
Main search engine. Launched when no prefix or a space as prefix us used!|Hauptsuchmaschiene. Gilt wenn Leerzeichen oder kein Präfix benutzt wird!
Web launcher prefix parameters (press F2 to edit)|Weblauncher Präfix Parameter (F2 zum bearbeiten drücken)
Search engine--Prefix--ASCII|Suchmaschiene--Präfix--ASCII
Balloon Tip|Balloon Tip
Click trough|Klick durch
Standard ToolTip|Standart ToolTip
Quick tutorial|Tutorial
&Load and suggest|&Laden + vorschl.
&Save settings|Einstellungen &speichern
&Reset settings|Einstellungen &wiederherstellen
Language|Sprache
AutoHotFile need to reload now.<>Would you like to save settings and reload?|AutoHotFile muss neugestartet werden.<>Möchten Sie jetzt AutoHotFile neustarten?
Save Settings|Einstellungen speichern
Would you like to save settings?|Möchen Sie die Einstellungen sichern?
Reset now?|Wiederherstellen?
Current settings will be lost!<>Would you like to reset all settings now?|Aktuelle Einstellungen werden verworfen!<>Möchen Sie die Einstellungen wiederherstellen?
R&un *.ahk as *.exe|S&tart *.ahk als *.exe
File Explorer|Datei Explorer
Preload|Vorladen
CMD|CMD
StartChars for different actions and EndCharacters|Startzeichen für verschiedene Aktionen und Endzeichen
Hotkeys|Tastenkürzel
Action|Aktion
Start AUTOSTART files|AUTOSTART Dateien starten
Quick profile selection|Profil ändern
Show last hidden window|Zuletzt verstecktes Fenster anzeigen
Hide active window|Verstecke aktives Fenster
Execute AutoHotkey script from Clipboard|AutoHotkey Script aus dem Clipboard ausführen
Reset File Reminder|Datei erinnerung zurücksetzen
Show all hotkeys|Alle Tastenkürzel anzeigen
Show ini settings file|Ini Datei mit Einstellungen anzeigen
Show settings|Einstellungen anzeigen
Toggle suspend AutoHotFile hotkeys|AutoHotFile Tastenkürzel aus-/einschalten
Toggle pause all AutoHotkey scripts|Alle AutoHotkey Skripte pausieren/fortsetzen
Restart AutoHotFile|AutoHotFile neustarten
KeyWord Launcher|KeyWord Launcher
SpeedHotkey|SpeedHotkey
Repeat Action|Aktion wiederholen
Resolve Windows variable|Windows variable auflösen
Process Terminator|Process Terminator
AutoUpdate|Automatische Aktualisierung
Check on each start|Beim starten prüfen
No keyword/file was found, try * prefix for wildcard search<>Press enter to launch a website, ip address or an environment variable|Keine Datei gefunden, versuchen Sie * Prefix für Wildcard Suche<>Drücken Sie Enter um eine Webseite, IP Adresse oder Windows Variable auszuführen
KeyWord characters|KeyWord Zeichen
Chorded keyboard|Akkordtastatur
Use Chording|Akkord benutzen
Minimum keys|Min. Tasten
You can save any entry to your favorits by pressing CTRL+S<>To delete, select it (Shift+F1-12) then press CTRL+D<>|Um neue Favoriten zu speichern STRG+S drücken<>Um zu löschen, erst auswählen (UMSCHALT+F1-12) danach STRG+D
F1-24 or click (terminate) - CTRL+F1-24 (pause) - ALT+F1-24 (suspend hotkeys)<>CTRL & PAUSE (<a terminateall>terminate all</a>) - hold SHIFT (show all processes) - CTRL+ALT+F1-12 (kill)<><>Fkey`tPid`tName`t`tFile name|F1-24 oder Klick (beenden) - STRG+F1-24 (anhalten, Pause) - ALT+F1-24 (deaktiviere Hotkeys)<>STRG+PAUSE (<a terminateall>alle beenden</a>) - UMSCHALT halten (versteckte Processe anzeigen) - STRG+ALT+F1-12 (kill)<><>FTaste`tPid`tName`t`t`tDatei name
)
StringSplit,#_SETTINGS_GUI,#_SETTINGS_GUI,|
StringSplit,#_SETTINGS_GUI_VAR,#_SETTINGS_GUI_VAR,`n
Loop % #_SETTINGS_GUI0
{
	#_TEMP_VAR:=#_SETTINGS_GUI%A_Index%
	Loop,Parse,#_SETTINGS_GUI_VAR%A_Index%,|
		If A_Index=%#_SETTINGS_LANGUAGE%
			#_SETTINGS_GUI_%#_TEMP_VAR%:=RegExReplace(RegExReplace(A_LoopField,"<>","`n"),"--","|")
}
Return

#__EN_MENU_HELP:
#__HELP_MENU_AutoHotFile = |Welcome to AutoHotFile||AutoHotFile is the ultimate keyword launcher - It's quick - It's crazy - It's unbelivable!|You will have immediate access to your files`, folders`, web and different websearch options.|Along with AutoHotkey it gives you the ultimate power on your computer.||AutoHotFile offers 3 different ways to open your files and programms:|1. KEYWORD LAUNCHER - (Press CAPSLOCK + TAB)|  - Here you can open`, search`, edit or show your keyworded file.|  - You can also open a website or websearch`, explore files and folders`, calculate`, run AHK code and more.|  - See Keyword Launcher help for more.|2. AUTOHOTSTRING - (type # + keyword + {Tab})|  - If AutoHotString is ON you can launch your files by typing only.|  - Type # + keyword + {TAB} and your file or program will be opened.|3. HOTKEY - (CAPSLOCK/SCROLLLOCK/NUMLOCK + [a-z0-9])|  - You can open your file by pressing CAPSLOCK + character from a-z or number 0-9|  - You can use SCROLLLOCK + [a-z0-9] and NUMLOCK + [a-z0-9] in the same way.|  - To assign a hotkey to a file`, you will need to rename it|  - You have to include the word CAPSLOCK`, SCROLLLOCK or NUMLOCK (case sensitive) and a character|     For example if file is called `"m.Main Script CAPSLOCKa.ahk`"`,|     pressing CAPSLOCK + a will open that file. Use SCROLLLOCKa or NUMLOCKa in the same way.||NUMPAD keys can be used with NUMLOCK only`,|each key corresponds to a letter or number on keyboard.|For example NUMLOCK + NumpadSub will be same as NUMLOCK + s|However`, file name must include NUMLOCKs to have hotkey NUMLOCK + NumpadSub.|Use `"a`" for NumpadAdd`, `"d`" for NumpadDel and so on (NumpadDiv = v)

	#__HELP_MENU_AUTOSTART = |AutoStart||Include word AUTOSTART (case sensitive) in your file name to use that feature.|Your file will run when AutoHotFile starts.||For example:| - Your file: C:\AutoHotkey\winspy.Window Spy AUTOSTART.ahk| - One of your Working Directories needs to be C:\AutoHotkey\| - One of your Working Extensions needs to be "ahk"| - Now launch AutoHotFile and it will start your file automatically

	#__HELP_MENU_AUTOHOTSTRING = |AutoHotString||If you turn on that feature`, AutoHotFile will write a script for you dynamically`,|this Script will contain all keywords as Hotstrings.|You can perform 5 different actions with your files:| 1. Run the file by typing %#__SET__HOTSTRING_RUN_% + keyword + {TAB}| 2. Edit your file by typing %#__SET__HOTSTRING_EDIT_% + keyword + {TAB}| 3. Show your file in Explorer by typing %#__SET__HOTSTRING_SHOW_% + keyword + {TAB}| 4. Copy full file path to clipboard by typing %#__SET__HOTSTRING_COPY_PATH_% + keyword + {TAB}| 5. Copy dir path of file to clipboard by typing %#__SET__HOTSTRING_COPY_DIR_%  + keyword + {TAB}|For example you keyword is main`,|enter%#__SET__HOTSTRING_RUN_%main and press {TAB} anywhere to open your file|enter %#__SET__HOTSTRING_EDIT_% and press {TAB} to edit your file and so on…

	#__HELP_MENU_FILE_REMINDER = |File Reminder||Whith this feature you can start your file at given time.|To enable the timer on a file you need to rename the file.|Add a time stamp (# + time) to your file name for example #20081231235959.||Following syntax is supported:| - #MON - Run file on Monday (as soon as AutoHotFile finished Loading)| - #1200 - Start file at 12:00 (When AutoHotFile is launched later than 12:00 file also runs)| - #TUE1200 - Run file on Tuesday at 12:00 (weeks days MON-TUE-WED-THU-FRI-SAT-SUN)| - #200811 - November 2008. You can also ommit the last numbers to a minute, hour, day or month||At given time File Reminder will show you a InputBox containing filename.|Here you can take following action:| 1. Leave file name as it is and press:|    - OK Button to launch that file|    - Cancel Button to not open it|    - IN BOTH CASES REMINDER WILL BE SUSPENDED FOR THAT FILE TILL NEXT START OF AUTOHOTFILE| 2. Change file name to accept new reminder|    - Press OK to open`, Cancel to change reminder only|    - You can also delete reminder here (delete #timestamp string from file name)| 3. Enter time in minutes to suspend reminder completely|    - Here the Reminder will be suspended for given time so no reminders will appear at all|    - To suspend reminder for current file only`, you need to change #timestamp in file name||If you have accidentally suspended reminder for all files|press CAPSLOCK + F6 to show reminder again||If you have dismissed a file reminder accidetially`,|you can set Menu File Reminder to ON and all reminders will be shown again.

	#__HELP_MENU_Reload_scripts = |Reload running AutoHotkey scripts on save||Your scripts can be automatically reloaded when you save changes in editor.|Set to option KILL and your scripts will be terminated and restarted faster.||PLEASE NOTE`, when you set it to kill you might loose unsaved data in script.|Only keyworded scripts will be restarted!

	#__HELP_MENU_WebBrowser = |Web Browser||Here you have to set your standard web browser|It will be used for web launcher|Web launcher offers following features:| - quick website finder (enter website and press Enter)| - google search (enter .searchterm and press Enter. E.g. .autohotkey)| - google maps search (enter ?searchterm and press Enter. E.g. ?restaurant in london)| - ebay search (enter -searchterm and press Enter. E.g. -harddrive)

	#__HELP_MENU_Editor = |Editor||Here you have to set your standard editor.|You can open your file in editor by pressing CTRL + E in KeyWord Launcher| - You can also open a suggested file in Keyword Launcher`,|   before you finished typing press CTRL + F1-F12.||F1-12 stands for corresponding found file in KeyWord Launcher

	#__HELP_MENU_WorkingDir = |Working directories||Here you need to set your folders/directories.|These directories will be searched for files matching your Working Extensions||For example your Working directory is C:\AutoHotkey\* (* stands for subfolder)`,|your Working Extensions are exe and ahk. In this case 2 File loops will be performed.|1: Loop, C:\AutoHotkey\*.ahk, 0, 1|2: Loop, C:\AutoHotkey\*.exe, 0, 1||Each found file will be keyworded|Keyword is based on file name (the first characters before .)|For example if file is called autohotkey.exe`, keyword will be autohotkey|If file is called m.Main Script.ahk`, keyword will be m||You can add as many directories as you like||SPECIAL EXTENSIONS:|You can set special extensions for your directory|For Example C:\AutoHotkey\*/*.ahk|In this case Working Extensions will not be used and it will search of ahk files only|You can also include several extensions/file patterns|For example C:\AutoHotkey\*/*.ahk/*.ini/*.exe

	#__HELP_MENU_WorkingExtensions =|Working extensions||Here you need to set your extensions|Only files matching these extensions will be loaded and keyworded|You can enter several extensions`, use pipe as delimiter

	#__HELP_MENU_Suggest =|AutoHotFile Suggests||Here you can set how many found keywords/files will be suggested while you type|You can open your files before you finished typing| - Press F1-F12 (corresponding to find entries)| - Press CTRL + F1-F12 to open your file in editor| - Press ALT + F1-12 to open your file in explorer|You can also press CTRL + E to edit first found file or ALT + E to show in explorer||If you are typing very quick`, you should set it to a lower value|As your typed letters might be missed because it did not finish searching for keywords

	#__HELP_MENU_ADVANCED = |Advanced settings||Here you can set additional settings||Favorits| - Here you can set you favorite entries.| - You can list and search these by entering !| - Use menu to set and delete Favorits.|  -  In KeyWord Launcher  -  | - Enter your favorite entry and press CTRL + S to save| - delete entry by pressing CTRL + D||WildCard \w*| - This will enable to search for your entry in the middle of keywords| - So if your keyword is main and you type ain it will be also found and sugessted||Position launcher at caret|If this setting is used, Launcher will be shown at caret position instead of Mouse position.
	#__HELP_MENU_PREFIX =|Prefixes for Keyword Launcher||You Can use prefixes in Keyword Launcher`,|depending on prefix AutoHotFile will perform different tasks||Following prefixes exist (. ? - : `" * #)| (.) stands for google search`, so entering .autohotkey would search on google for autohotkey| (?) stands for google maps search`, enter for example ?restaurant in london| (-) stands for ebay`, enter for example -harddrive to search for harddrive on ebay| (:) stands for execute AHK code`, so entering :MsgBox would show a MsgBox. You can add new line by pressing CTRL + ENTER| (`") stands for regex search`, so entering `"ahk$ would show only files that end with ahk| (*) stands for regex search without case sense| (#) stands for command line entry, e.g. ping www.google.de| ([a-z]:) and (\\) are used to enable AutoHotFile explorer| (=) is used for calculator`, enter =2*(5+5)

	#__HELP_MENU_EXPLORER = |AutoHotFile Explorer||Here you can browse trough your drive very quickly.|Enter for example c:`, keyword launcher will add \ automatically`, and turn into an explorer.|Enter a letter and it will search for a file or folder starting with that letter.|You can use * and ? for wildcard| - Press F11 to toggle search in subfolders| - Press F12 to toggle file or folder search.| - Press TAB to take over found folder and continue typing| - Press Arrow Keys to browse trough folders| - Press Ctrl + C to copy selected path.

	#__HELP_MENU_General_hotkeys =|General AutoHotFile hotkeys|| - CAPSLOCK + TAB = Start Keyword Launcher| - CAPSLOCK + PAUSE = Process Terminator| - CAPSLOCK + F9 or CAPSLOCK + RBUTTON = SETTINGS| - CAPSLOCK + F3 / F4 = Show and Hide active window| - CAPSLOCK + F12 = Reload| - CAPSLOCK + F11 = Pause all other AutoHotkey Scripts| - CAPSLOCK + F10 = Suspend all hotkeys| - CAPSLOCK + F8 = Edit this script| - CAPSLOCK + F7 = Show all (generated) hotkeys| - CAPSLOCK + F6 = Reset File Reminder| - CAPSLOCK + F5 = Execute clipboard as AHK script (run a temp script)| - CAPSLOCK + F2 or CAPSLOCK + SPACE = Run last command or file opened in Keyword Launcher| - CAPSLOCK + ESC or CAPSLOCK + SHIFT= Activate SPEEDHOTKEY| - CAPSLOCK + ENTER = Open Environment variable (like temp or windir)| - CAPSLOCK + ENTER works in any windows explorer control like Open dialog

	#__HELP_MENU_KeywordLauncher =|Keyword Launcher (press CAPSLOCK + TAB to start)||This is a GUIless interface realized trough Input command in AutoHotkey.|It monitors your typing and informs you trough a ToolTip.|Whyle you are typing`, it will search for a keyword and display result in ToolTip.|In this way you will get anything you need very quickly.||Use following prefixes for special actions ( . ? - = `" * \ #)|Type the prefix and your entry in Keyword Launcher then press Enter.|For example .google or ?from: london to: bristol or =100/(2*(5+5))| . is used for google search| ? for google maps search| - for ebay search| = is used as a quick calculator| `" performs a regex search on A_LoopFileLongPath on all keywords|* performs a case insensitive regex search.|\ or [a-z]: are used for AutoHotFile Explorer (for more see explorer help).||! NOTE - keyword for your files is created out of first characters of your file !|For example keyword for a file called `"main.Main Script.ahk`" will be `"main`".|. is used to create the keyword out of file name`, other characters are ignored here.|Because of this if 2 files would create same keyword`, only first file will be keyworded.|The second file will be ignored and cannot be used in AutoHotFile.|| - - - - Keyword Launcher hotkeys - - - -||Use these hotkeys to perform different actions in Keyword Launcher|   CTRL + H = show help|   CTRL + C + CTRL + V = copy + paste to/from Clipboard (DEL to delete the whole entry)|   CTRL + ENTER = insert new line|   CTRL + E = open entered or first found keyword in editor|   ALT + E = show entered or first found keyword in Explorer|   Press PgUp /PgDn to call up previous entries|   CTRL + A = exit AutoHotFile|   CTRL + R = restart AutoHotFile|| - SPECIAL HOTKEYS|   Keys F1 to F12 are used to open`, show or edit a found keyworded file|   Press F1 to F12 to open found file|   Press CTRL + F1-F12 to open a found file in editor|   Press ALT + F1-F12 to show it in explorer
	#__HELP_MENU_Profiles =|Profiles||Here you can define profiles that will have their own Working Directories|E.g. one for working in office and the other for working home
Return

#__DE_MENU_HELP:
#__Help_MENU_AutoHotFile = |Willkommen zu AutoHotFile||AutoHotFile ist der ultimative Keyword Launcher - schnell - einfach - unglaublich!|Mit AutoHotFile hast du jede Datei, Ordner, Webseiten und Websuche in wenigen Sekunden|Zusammen mit AutoHotkey bekommst  du die unglaubliche Macht über deinen Computer.||AutoHotFile bietet 3 Wege deine Dateien und Programme zu öffnen: |1. KEYWORD LAUNCHER - (Drücke CAPSLOCK + TAB)|  - hier kannst  du deine Dateien über das Schlüsselwort öffnen, bearbeiten oder anzeigen.|  - du kannst ebenfalls Webseiten und Websuche aufrufen, sowie in Dateien und Ordner durchsuchen|  - zusätzlich kannst du Rechnen und AutoHotkey Code dynamisch ausführen (ohne Datei)|  - mehr Hilfe findest du unter Keyword Launcher.|2. AUTOHOTSTRING - (# + keyword + {Tab} eintippen)|  - wenn AutHotString eingeschaltet ist, kannst du deine Dateien durch einfaches tippen starten.|  - einfach #, dann dein Schlüsselwort und {TAB} tippen und die Datei wird gestartet.|3. HOTKEY - (CAPSLOCK/SCROLLLOCK/NUMLOCK + [a-z0-9])|  - du kannst deine Dateien ebenfalls mit einem Tastenkürzel wie z.B. CAPSLOCK + Buchstabe oder Zahl.|  - SCROLLLOCK + [a-z0-9] and NUMLOCK + [a-z0-9] kannst du ebenso benutzen|  - um einen Tastenkürzel zuzuweisen, musst du die Datei umbenennen|  - in dem Dateinamen muss das Wort CAPSLOCK, SCROLLLOCK oder NUMLOCK und [a-z0-9] vorkommen|  - CAPSLOCK, SCROLLLOCK, NUMLOCK müssen großgeschrieben werden, der Buchstabe oder Zahl nicht.|     Z.B. hast du eine Datei namens `"m.Main Script CAPSLOCKa.ahk`"|     durch das drücken von CAPSLOCK + a wird diese Datei gestartet.||NUMPAD Tasten können nur mit NUMLOCK benutzt werden.|Jede Taste entspricht einem Buchstaben oder einer Zahl.|Z.B. NUMLOCK + NumpadSub entspricht NUMLOCK + s.|Im Dateinamen musst du NUMLOCKs eingeben um NUMLOCK + NumpadSub nutzen zu können.|Benutze "a" für NumpadAdd, "d" für NumpadDel und so weiter. (NumpadDiv = v)

	#__Help_MENU_AUTOSTART = |AutoStart||Wenn das Wort AUTOSTART (großgeschrieben) im Dateinamen vorkommt,|wird diese Datei beim Start von AutoHotFile gestartet.||Z.B.:| - Datei heißt C:\AutoHotkey\winspy.Window Spy AUTOSTART.ahk| - Einer der Ordner muss C:\AutoHotkey\ sein.| - Einer der Dateierweiterungen muss `"ahk`" sein.| - Wenn du dann AutoHotFile startest, wird diese Datei ebenfalls gestartet.

	#__Help_MENU_AUTOHOTSTRING = |AutoHotString||Wenn diese Funktion aktiviert ist wird AutoHotFile ein dynamisches Skript erstellen`,|dieses Skript hat alle Schlüsselwörter als Hotstring gespeichert.|Benutze folgende Befehle durch einfaches tippen. (Funktioniert im jedem Fenster)| 1. Starte die Datei durch tippen von %#__SET__HOTSTRING_RUN_% + Schlüsselwort + {TAB}| 2. Öffne die Datei zum bearbeiten durch tippen von %#__SET__HOTSTRING_EDIT_% + Schlüsselwort + {TAB}| 3. Öffne die Datei im Explorer durch tippen von %#__SET__HOTSTRING_SHOW_% + Schlüsselwort + {TAB}| 4. Kopiere den Dateipfad durch tippen von %#__SET__HOTSTRING_COPY_PATH_% + Schlüsselwort + {TAB}| 5. Kopiere den Ordnerpfad durch tippen von %#__SET__HOTSTRING_COPY_DIR_% + Schlüsselwort + {TAB}||Z.B. dein Schlüsselwort ist main`, tippe %#__SET__HOTSTRING_RUN_%main{Tab} um die Datei zu öffnen.|tippe %#__SET__HOTSTRING_EDIT_%main{TAB} um die Datei zu bearbeiten usw…

	#__Help_MENU_FILE_REMINDER = |Datei Erinnerung||Mit dieser Funktion kannst du deine Dateien zu gewünschter Zeit starten.|Um eine Erinnerung zu aktivieren, musst du die Datei umbenennen.|Füge einen Zeitstempel zu dem Dateinamen, z.B. #20081231235959.||Folgender Syntax wird unterstützt:| - #MON - öffne Datei am Montag (Sobald AutoHotFile alle Dateien geladen hat)| - #1200 - öffne täglich um 12:00 (Wenn AutoHotFile nach 12:00 startet, wird ebenfalls erinnert)| - #TUE1200 - Dienstag um 12:00 (Wochentage in Englisch: MON-TUE-WED-THU-FRI-SAT-SUN)| - #200811 - November 2008. Die letzten zahlen können bis zum Monat weggelassen werden.||Zur angegebenen Zeit wird eine Input Box mit dem Dateinamen erscheinen.|Hier kannst du folgende Aktionen durchführen:| 1. Dateiname nicht geändert:|    - OK um die Datei zu öffnen|    - Cancel um die Datei nicht zu starten|    - IN BEIDEN FÄLLEN WIRD KEINE ERINNERUNG FÜR DIESE DATEI BIS ZUM NÄCHSTEN START ANGEZEIGT.| 2. Ändere den Dateinamen um einen neue Erinnerung festzulegen.|     - Drücke OK um die Datei zu starten, Cancel um nur die Erinnerung zu ändern.| 3. Gebe die Zeit in Minuten an um den Erinnerungsdienst vorübergehend zu deaktivieren.|     - es wird keine Erinnerung innerhalb dieser Zeit angezeigt|     - um die Erinnerung nur für eine Datei vorübergehend zu deaktivieren, muss du den #Zeitstempel ändern||Wenn der Erinnerungsdienst aus versehen zu lang deaktiviert wurde|drücke CAPSLOCK + F6 und dieser wird reaktiviert.||Falls eine Dateierinnerung aus versehen deaktiviert wurde (Cancel gewählt)|kannst du im Menü File Reminder, ON auswählen und alle Erinnerungen werden wieder angezeigt.

	#__Help_MENU_Reload_scripts = |Laufende AHK Skripte beim ändern neustarten.||Deine Skripte können automatisch neugestartet werden wenn du die Datei geändert hast.|Wähle die Option KILL und dein Skript wird schneller neustarten.||BITTE MERKE wenn du KILL Option aktiviert hast könnten nicht gespeicherte Daten verloren gehen

	#__Help_MENU_WebBrowser = |Web Browser||Hier musst du deinen Standard Webbrowser angeben|Dieser wird für folgende Aktionen benötigt:| - Webseiten Finder (Webseite eingeben und Enter drücken)| - Google Suche ( .Suchbegriff eingeben und Enter drücken, z.B. .autohotkey)| - Google Maps Suche ( ?Suchbegriff eingeben und Enter drücken, z.B. ?Restaurant in Frankfurt| - Ebay Suche ( -Suchbegriff eingeben und Enter drücken, z.B. -festplatte)

	#__Help_MENU_Editor = |Editor||Hier musst du den Standard Editor angeben.|Du kannst im Keyword Launcher deine Skripte mit CTRL + E im Editor öffnen.| - Du kannst ebenfalls vorgeschlagene Scripte mit CTRL + F1 bis F12 bearbeiten||F1-12 steht für die gefundenen Schlüsselwörter in Keyword Launcher

	#__HELP_MENU_WorkingDir = |Pfad für Dateien||Hier musst du deine Ordner angeben.|Diese werden nach Dateien durchgesucht die den Dateierweiterungen entsprechen.||Z.B. Ordner ist C:\AutoHotkey\* (* steht für Unterordner)|Deine Dateierweiterungen sind ahk und exe. In diesem Fall wird Loop 2-mal ausgeführt|1: Loop, C:\AutoHotkey\*.ahk, 0, 1|2: Loop, C:\AutoHotkey\*.exe, 0, 1|Dateien werden mit einem Schlüsselwort versehen und Pfad in einer Variable gespeichert.||Schlüsselwort basiert auf dem Dateinamen (die ersten Zeichen vor . )|Z.B. eine Datei heißt autohotkey.exe, Schlüsselwort wird autohotkey sein.|Wenn Datei m.Main Skript.ahk heißt, wird m das Schlüsselwort sein||Du kannst beliebig viele Ordner angeben|Ein Netzlaufwerk wie \\192.168.2.1\C$ wird nicht geladen.||SPEZIELLE DATEIERWEITERUNGEN:|Du kannst spezielle Dateierweiterungen für einen Ordner angeben.|Z.B. C:\AutoHotkey\*/.ahk, in diesem Fall werden nur ahk Dateien geladen.|Globale Dateierweiterungen werden nicht geladen, nur ahk|Du kannst ebenfalls mehrere Dateierweiterungen angeben.|Z.B.: C:\AutoHotkey\*/*.ahk/*.exe

	#__Help_MENU_WorkingExtensions =|Dateierweiterungen||Hier werden die Dateierweiterungen festgelegt.|Nur Dateien mit diesen Erweiterungen werden geladen und mit Schlüsselwort versehen.|Du kannst auch mehrere Dateierweiterungen eingeben (mit Pipe trennen)

	#__Help_MENU_Suggest =|AutoHotFile Suggest||Hier kannst du festlegen wie viele Vorschläge angezeigt werden sollen.|Du kannst dann deine Dateien öffnen bevor du mit dem Tippen fertig bist.| - Drücke F1-F12 um die Datei zu öffnen.| - Halte dabei CTRL um die Datei im Editor zu öffnen.| - Halte dabei ALT um die Datei im Explorer zu öffnen.|Du kannst ebenfalls mit CTRL + E oder ALT + E diese Funktion ausführen||Wenn du sehr schnell tippst, sollten nur wenige Vorschläge (3) angegeben werden.|Ansonsten kann es passieren dass Keyword Launcher einige Buchstaben nicht akzeptiert.

	#__Help_MENU_ADVANCED = |Erweiterte Einstellungen||Hier kannst du weitere Einstellungen festlegen.||Favorits| - Hier kannst du Favoriten festlegen.| - Mit ! kannst du diese aufrufen und suchen|Im Menu Favorits kannst du diese hinzufügen und löschen.|  -  Im KeyWord Launcher:  -  | - Drücke CTRL + S um einen Favoriten zu speichern.| - Drücke CTRL + D um einen Favoriten zu löschen.||WildCard \w*| - Durch aktivieren dieser Option wird auch in Mitte des Dateinamen gesucht.| - Z.B. wenn das Schlüsselwort main ist und du nur ain eintippst, wird es auch gefunden.||Position launcher at caret|Wenn diese Option aktiviert ist, wird der Launcher nicht bei der Maus|sondern bei der Einfügemarke/Positionsmarke angezeigt.
	#__Help_MENU_PREFIX =|Präfixe für Keyword Launcher||Du kannst Präfixe in Keyword Launcher benutzen.|Je nach Präfix wird eine andere Aktion erfolgen.||Folgende Präfixe sind vorhanden (. ? - : `" * #)| (.) steht für Google Suche, gebe z.B. .autohotkey ein|(?) steht für Google Maps Suche, gebe z.B. ?von: Frankfurt nach: Berlin ein.| (-) steht für Ebay Suche, gebe z.B. -festplatte| (:) steht für AHK Code ausführen, gebe z.B. :MsgBox ein und ein MsgBox wird angezeigt|      Mit CTRL + ENTER kann eine neue Zeile eingegeben werden.| (`") stehet für regex Suche in Dateinamen, gebe z.B. `"ahk$ ein um nur ahk Dateien anzuzeigen.| (*) steht für regex Suche ohne Großschreibung zu beachten.| (#) steht für Cmd.exe Befehl, z.B. ping www.google.de| ([a-z]:) und (\\) sind für AutoHotFile Explorer reserviert| (=) wird für Berechnungen benutzt, gebe z.B. =2*(5+5) ein.

	#__Help_MENU_EXPLORER = |AutoHotFile Explorer||Hier kannst du deine Ordner und Dateien durchsuchen.|Gebe z.B. c: ein (\) wird automatisch angefügt.|Keyword Launcher wird jetzt zu einem Explorer.|Tippe jetzt einen Buchstaben und es wird sofort nach einem Ordner gesucht|Du kannst * und ? als Wildcard benutzen.| - Drücke F11 um in Unterordner zu suchen| - Drücke F12 um nach Dateien zu suchen.| - Drücke TAB um den Pfad zu übernehmen| - Benutze die Pfeiltasten um zu browsen| - Mit CTRL + C den Pfad kopieren.

	#__Help_MENU_General_hotkeys =|Allgemeine AutoHotFile Tastaturkürzel|| - CAPSLOCK + TAB = Start Keyword Launcher| - CAPSLOCK + PAUSE = Prozess Terminator| - CAPSLOCK + F9 oder CAPSLOCK + RBUTTON = Einstellungen| - CAPSLOCK + F3 / F4 = Fenster Anzeigen und Verstecken| - CAPSLOCK + F12 = Reload| - CAPSLOCK + F11 = Pause alle anderen AutoHotkey Skripte| - CAPSLOCK + F10 = Suspend alle Tastenkürzel| - CAPSLOCK + F8 = Diesen Skript Editieren| - CAPSLOCK + F7 = Alle Tastenkürzel (generierte) anzeigen| - CAPSLOCK + F6 = Dateierinnerung zurücksetzen| - CAPSLOCK + F5 = Clipboard als AHK Skript ausführen| - CAPSLOCK + F2 oder CAPSLOCK + SPACE = zuletzt ausgeführte Aktion wiederholen| - CAPSLOCK + ESC oder CAPSLOCK + SHIFT= Aktiviere SPEEDHOTKEY| - CAPSLOCK + ENTER = Öffne Umgebungsvariable (wie temp oder windir)|Funktioniert nur in Windows Explorer Control wie Open Dialog

	#__Help_MENU_KeywordLauncher =|Keyword Launcher (press CAPSLOCK + TAB zum starten)||Dies ist eine GUI-lose Schnittstelle, die durch Input Befehl in Autohotkey umgesetzt wurde.|Es beobachtet was du tippst und informiert über einen ToolTip.|Während du tippst, wird nach deinen Schlüsselwörtern gesucht und in ToolTip angezeigt.|Auf diese Weise kannst du alles sehr schnell aufrufen.||Benutzen folgende Präfixe für erweiterte Funktionen ( . : ? - = `" * \ #)|Zuerst Präfix, danach deinen Eintrag eingeben und Enter drücken.|Z.B. .google oder ?taxi in berlin oder =100/20*(5-3)| . wird für Google Suche benutzt| ? für Google Maps| - für Ebay| = für Berechnungen (Taschenrechner)| `" regex suche auf A_LoopFileLongPath in allen Schlüsselwörtern| * regex ohne Großschreibung| / oder [a-z]: werden für AutoHotFile Explorer benutzt.| |! BEACHTE - Schlüsselwort wird aus den ersten Zeichen des Dateinamen erstellt.|Z.B. Schlüsselwort für die Datei main.Main Skript.ahk wird main sein.|. wird benutzt um das Schlüsselwort zu bestimmen.|Aufgrund dessen, wenn 2 Dateien gleiches Schlüsselwort produzieren werden,|wird nur die erste Datei geladen und die anderen ignoriert.||Du kannst den Keyword Launcher auch durch drücken von CTRL und SHIFT starten.|Drücke kurz CTRL danach kurz SHIFT (dies muss innerhalb von 0.8 Sekunden erfolgen).|| - - - - Keyword Launcher Tastenkürzel - - - -||Diese Tastenkürzel können in Keyword Launcher benutzt werden:||   CTRL + H = Hilfe anzeigen|   CTRL + C and CTRL + V = Kopieren und Einfügen zu/vom Clipboard|   CTRL + ENTER = neue Zeile einfügen (ENTF um den ganzen Eintrag zu löschen)|   CTRL + E = eingegebenes oder als erstes gefundenes Schlüsselwort im Editor öffnen.|   ALT + E = eingegebenes oder als erstes gefundenes Schlüsselwort im Explorer öffnen.|   Drücke PgUp /PgDn um zuletzt ausgeführte Aktionen anzuzeigen.|   CTRL + A = AutoHotFile beenden|| - SPEZIELLE TASTATURKÜRZEL|   Tasten F1 bis F12 werden benutzt um gefundene Dateien schnell zu öffnen oder editieren|   F1 bis F12 drücken um Datei zu öffnen|   CTRL + F1-F12 drücken um die Datei im Editor zu öffnen.|   ALT + F1-F12 drücken um die Datei im Explorer anzuzeigen.
	#__HELP_MENU_Profiles =|Profile||Hier kannst du Profile anlegen`, jedes Profil hat eigene Verzeichnisse|Z.B. ein Profil fürs Zuhause und ein für die Arbeit.
	
Return
;==================== END: #Include .\include\_Help_# :B1AD529B-BF4E-477F-8B9F-3080CAC55AE3

;==================== START: #Include .\include\_Run_# :B1AD529B-BF4E-477F-8B9F-3080CAC55AE3



;*************************************************************************************************
;*                             SUBROUTINE FOR HOTKEYS WHEN PRESSED                               *
;*************************************************************************************************
;Hotkeys subroutines will run after CAPSLOCK is released
;when you press several hotkeys holding CAPSLOCK, only the last one will run
;same is for SCROLLLOCK./NUMLOCK. and HOTKEY..
#__Run_CapsLock:
{
	#__RUNNING_CAPSLOCK_++
	StringRight, #__VAR_TO_RUN_, A_ThisHotkey, 1
	If (!DBArray("CAPSLOCK","exist",#__VAR_TO_RUN_) or #__RUNNING_CAPSLOCK_ > 1) ;capslock_var%#__VAR_TO_RUN_% =
	{
		#__RUNNING_CAPSLOCK_--
		Return
	}
	#__MOD_STATE_ := GetKeyState("CTRL", "P") . GetKeyState("ALT", "P")
	WaitKeysUp(#__VAR_TO_RUN_ . "|CAPSLOCK")
	#__RUNNING_CAPSLOCK_ =
	If (#__MOD_STATE_ = "11")
		Clipboard := DBArray("files","get",DBArray("CAPSLOCK","get",#__VAR_TO_RUN_))
	Else if (#__MOD_STATE_ = "10")
		Run(DBArray("files","get",DBArray("CAPSLOCK","get",#__VAR_TO_RUN_)),"edit")
	Else if (#__MOD_STATE_ = "01")
		Run(DBArray("files","get",DBArray("CAPSLOCK","get",#__VAR_TO_RUN_)),"explore")
	Else
		Run(DBArray("files","get",DBArray("CAPSLOCK","get",#__VAR_TO_RUN_)))
	Hide(0)
	Return
}
#__Run_Scrolllock:
{
	#__RUNNING_SCROLLLOCK_++
	StringRight, #__VAR_TO_RUN_, A_ThisHotkey, 1
	If (!DBArray("SCROLLLOCK","exist",#__VAR_TO_RUN_) or #__RUNNING_SCROLLLOCK_ > 1)
	{
		#__RUNNING_SCROLLLOCK_--
		Return
	}
	#__MOD_STATE_ := GetKeyState("CTRL", "P") . GetKeyState("ALT", "P")
	#__RUNNING_SCROLLLOCK_ =
	WaitKeysUp(#__VAR_TO_RUN_ . "|ScrollLock")
	If (#__MOD_STATE_ = "11")
		Clipboard := DBArray("files","get",DBArray("SCROLLLOCK","get",#__VAR_TO_RUN_))
	Else if (#__MOD_STATE_ = "10")
		Run(DBArray("files","get",DBArray("SCROLLLOCK","get",#__VAR_TO_RUN_)),"edit")
	Else if (#__MOD_STATE_ = "01")
		Run(DBArray("files","get",DBArray("SCROLLLOCK","get",#__VAR_TO_RUN_)),"explore")
	Else
		Run(DBArray("files","get",DBArray("SCROLLLOCK","get",#__VAR_TO_RUN_)))
	Hide(0)
	Return
}
#__RUN_NUMLOCK:
{
	#__RUNNING_NUMLOCK_++
	StringRight, #__VAR_TO_RUN_, A_ThisHotkey, 1
	IfInString, A_ThisHotkey, NUMPAD
	{
		StringSplit, #__VAR_TO_REPLACE_, A_ThisHotkey, &, %A_Space%
		If #__VAR_TO_REPLACE_2 = NUMPADINS
			#__VAR_TO_RUN_ = 0
		If #__VAR_TO_REPLACE_2 = NUMPADEND
			#__VAR_TO_RUN_ = 1
		If #__VAR_TO_REPLACE_2 = NUMPADDOWN
			#__VAR_TO_RUN_ = 2
		If #__VAR_TO_REPLACE_2 = NUMPADPGDN
			#__VAR_TO_RUN_ = 3
		If #__VAR_TO_REPLACE_2 = NUMPADLEFT
			#__VAR_TO_RUN_ = 4
		If #__VAR_TO_REPLACE_2 = NUMPADCLEAR
			#__VAR_TO_RUN_ = 5
		If #__VAR_TO_REPLACE_2 = NUMPADRIGHT
			#__VAR_TO_RUN_ = 6
		If #__VAR_TO_REPLACE_2 = NUMPADHOME
			#__VAR_TO_RUN_ = 7
		If #__VAR_TO_REPLACE_2 = NUMPADUP
			#__VAR_TO_RUN_ = 8
		If #__VAR_TO_REPLACE_2 = NUMPADPGUP
			#__VAR_TO_RUN_ = 9
		If #__VAR_TO_REPLACE_2 = NUMPADDEL
			#__VAR_TO_RUN_ = d
		If #__VAR_TO_REPLACE_2 = NUMPADDIV
			#__VAR_TO_RUN_ = v
		If #__VAR_TO_REPLACE_2 = NUMPADMULT
			#__VAR_TO_RUN_ = m
		If #__VAR_TO_REPLACE_2 = NUMPADADD
			#__VAR_TO_RUN_ = a
		If #__VAR_TO_REPLACE_2 = NUMPADSUB
			#__VAR_TO_RUN_ = s
		If #__VAR_TO_REPLACE_2 = NUMPADENTER
			#__VAR_TO_RUN_ = e
	}
	If (!DBArray("NUMLOCK","exist",#__VAR_TO_RUN_) or #__RUNNING_NUMLOCK_ > 1)
	{
		#__RUNNING_NUMLOCK_--
		Return
	}
	#__MOD_STATE_ := GetKeyState("CTRL", "P") . GetKeyState("ALT", "P")
	WaitKeysUp(#__VAR_TO_RUN_ . "|NUMLOCK")
	#__RUNNING_NUMLOCK_ =
	If (#__MOD_STATE_ = "11")
		Clipboard := DBArray("files","get",DBArray("NUMLOCK","get",#__VAR_TO_RUN_))
	Else if (#__MOD_STATE_ = "10")
		Run(DBArray("files","get",DBArray("NUMLOCK","get",#__VAR_TO_RUN_)),"edit")
	Else if (#__MOD_STATE_ = "01")
		Run(DBArray("files","get",DBArray("NUMLOCK","get",#__VAR_TO_RUN_)),"explore")
	Else
		Run(DBArray("files","get",DBArray("NUMLOCK","get",#__VAR_TO_RUN_)))
	Hide(0)
	Return
}
#__RUN_HOTKEY_:
{
	#__RUNNING_HOTKEY_++
	StringSplit, #__HOTKEY_TO_RUN_, A_ThisHotkey, &, %A_Space%
	StringRight, #__VAR_TO_RUN_1, #__HOTKEY_TO_RUN_1, 1
	StringRight, #__VAR_TO_RUN_2, #__HOTKEY_TO_RUN_2, 1
	#__HOTKEY_TO_RUN_ = %#__VAR_TO_RUN_1%%#__VAR_TO_RUN_2%
	If (!DBArray("HOTKEY","exist",#__HOTKEY_TO_RUN_) or #__RUNNING_HOTKEY_ > 1)
	{
		#__RUNNING_HOTKEY_--
		Return
	}
	#__MOD_STATE_ := GetKeyState("CTRL", "P") . GetKeyState("ALT", "P")
	WaitKeysUp(#__VAR_TO_RUN_2 . "|" . #__VAR_TO_RUN_1)
	If #__SPEEDHOTKEY_STATE_ = ON
		Toggle_Speed_Hotkey()
	#__RUNNING_HOTKEY_ =
	If (#__MOD_STATE_ = "11")
		Clipboard := DBArray("files","get",DBArray("HOTKEY","get",#__HOTKEY_TO_RUN_))
	Else if (#__MOD_STATE_ = "10")
		Run(DBArray("files","get",DBArray("HOTKEY","get",#__HOTKEY_TO_RUN_)),"edit")
	Else if (#__MOD_STATE_ = "01")
		Run(DBArray("files","get",DBArray("HOTKEY","get",#__HOTKEY_TO_RUN_)),"explore")
	Else
		Run(DBArray("files","get",DBArray("HOTKEY","get",#__HOTKEY_TO_RUN_)))
	Hide(0)
	Return
}




































;*************************************************************************************************
;*                        FUNCTION TO RUN A KEYWORD AND OTHER ENTRIES                            *
;*************************************************************************************************
;This runs when a hotkey is pressed or any entry in keyword launcher (excluding file and folder explorer) is launched
;It determines what to do on base of entry content
;for example if . is added in front it searches on google for the entry beside . e.g. .weather
;if you add : in front it will write the enty to a file and launch with AutoHotkey.exe e.g. :MsgBox % A_script_Name
;trough this also your scripts are launched
#__Run_Var:
{
	KeyWait, CapsLock
	If #__SPEEDHOTKEY_STATE_ = ON
		Toggle_Speed_Hotkey()
	If #__CURRENT_VAR =
		#__OUT_RUN_VAR_ = %#_current_var_last%
	else
	{
		#__OUT_RUN_VAR_ = %#__CURRENT_VAR%
		#_current_var_last = %#__CURRENT_VAR%
	}
	#__CURRENT_VAR =
	If #__OUT_RUN_VAR_ =
		Return
	If DBArray("files","exist",#__OUT_RUN_VAR_){
		#__OUT_RUN_VAR_:=DBArray("files","get",#__OUT_RUN_VAR_)
		if #_PARAM_VAR
			Run(#_CUT_VAR) ;(RegExMatch(#__OUT_RUN_VAR_, "^\w+$") and %#__OUT_RUN_VAR_%)
		else
			Run(#__OUT_RUN_VAR_)
	} else {
		If (SubStr(#__OUT_RUN_VAR_, 1, 1) = ":")
		{
			StringTrimLeft, #__OUT_RUN_VAR_, #__OUT_RUN_VAR_, 1
			RunPipe(#__OUT_RUN_VAR_,A_Now . "." . A_TickCount)
		}
		else
		{
			Web(#__OUT_RUN_VAR_)
		}
	}
	Hide(0)
	Return
}

Web(#__OUT_RUN_VAR_){
	global
	local web, #__GLOBAL_VAR_
	EnvGet, #__GLOBAL_VAR_, %#__OUT_RUN_VAR_%
	StringLeft,#_WEB_PREFIX_,#__OUT_RUN_VAR_,1
	StringTrimLeft, #__OUT_RUN_VAR__web, #__OUT_RUN_VAR_, 1
	StringReplace, #__OUT_RUN_VAR__web, #__OUT_RUN_VAR__web, %A_Space%, +, A
	If #__GLOBAL_VAR_ =
	{
		#_WEB_PREFIX_1=
		If (InStr(#__OUT_RUN_VAR_, "=") = 1)
			Hide(0)
		else if (RegExMatch(#__OUT_RUN_VAR_, "\d+\.\d+\.\d+\.\d+") or InStr(#__OUT_RUN_VAR_, "http") = 1)
			#__OUT_RUN_VAR__web:=#__OUT_RUN_VAR_,#_WEB_PREFIX_1:=""
		else if !RegExMatch(#__SET__WEB_,StringToRegex(#_WEB_PREFIX_) . "(http:.*)",#_WEB_PREFIX_) 
			#_WEB_PREFIX_1:=#__SET__WEB_,#__OUT_RUN_VAR__web:=RegExReplace(#__OUT_RUN_VAR_,"\s","+")
		If RegExMatch(#_WEB_PREFIX_1,".http:")
			#_WEB_PREFIX_1:=RegExReplace(#_WEB_PREFIX_1,".http:.*")
		If InStr(#_WEB_PREFIX_1," ")
			StringSplit,#_WEB_PREFIX_,#_WEB_PREFIX_1,%A_Space%
		Else
			#_WEB_PREFIX_2=
			;MsgBox % %#_WEB_PREFIX_1%%#__OUT_RUN_VAR__web%%#_WEB_PREFIX_2%
		Run %#__SET__WEBBROWSER_% %#_WEB_PREFIX_1%%#__OUT_RUN_VAR__web%%#_WEB_PREFIX_2%,% GetDir(#__SET__WEBBROWSER_)
	}
	else
	{
		If (InStr(#__GLOBAL_VAR_, "http") = 1)
			Run %#__SET__WEBBROWSER_% %#__GLOBAL_VAR_%,% SubStr(#__SET__WEBBROWSER_,1,Instr(#__SET__WEBBROWSER_, "\",1,0))
		else
			Run explorer /e`, %#__GLOBAL_VAR_%
	}
}


;*************************************************************************************************
;*             FUNCTION TO RUN A VARIABLE AS AUTOHOTKEY SCRIPT TROUGH A PIPE                     *
;*************************************************************************************************
#__LOAD_PIPES_:

StringTrimLeft,#__Includes_Str_N,#__MAIN_SCRIPT_Str_N,% InStr(#__MAIN_SCRIPT_Str_N,"`r`nIncludesScript:`r`n")-1
StringLeft,#__Includes_Str_N,#__Includes_Str_N,% InStr(#__Includes_Str_N,"`r`nIncludesScriptEnd:`r`n")-1

StringTrimLeft,#__UrlDownloadToVar_Str_N,#__MAIN_SCRIPT_Str_N,% InStr(#__MAIN_SCRIPT_Str_N,"`r`nURLDownloadToVarScript:`r`n")-1
StringLeft,#__UrlDownloadToVar_Str_N,#__UrlDownloadToVar_Str_N,% InStr(#__UrlDownloadToVar_Str_N,"`r`nURLDownloadToVarScriptEnd:`r`n")-1

StringTrimLeft,#__File_Explorer_Str_N,#__MAIN_SCRIPT_Str_N,% InStr(#__MAIN_SCRIPT_Str_N,"`r`nFileExplorerScript:`r`n")-1
StringLeft,#__File_Explorer_Str_N,#__File_Explorer_Str_N,% InStr(#__File_Explorer_Str_N,"`r`nFileExplorerScriptEnd:`r`n")-1

StringTrimLeft,#__StdOutToVar_Str_N,#__MAIN_SCRIPT_Str_N,% InStr(#__MAIN_SCRIPT_Str_N,"`r`nStdOutToVarScript:`r`n")-1
StringLeft,#__StdOutToVar_Str_N,#__StdOutToVar_Str_N,% InStr(#__StdOutToVar_Str_N,"`r`nStdOutToVarScriptEnd:`r`n")-1

StringTrimLeft,#__Auto_Hot_String_Str_N,#__MAIN_SCRIPT_Str_N,% InStr(#__MAIN_SCRIPT_Str_N,"`r`nAutoHotStringScript:`r`n")-1
StringLeft,#__Auto_Hot_String_Str_N,#__Auto_Hot_String_Str_N,% InStr(#__Auto_Hot_String_Str_N,"`r`nAutoHotStringScriptEnd:`r`n")-1

If (#__SET__PRELOAD_FILEEXPLORER_ and !#__FILE_EXPLORER_PID)
	#__FILE_EXPLORER_PID:=ShowExplorer_PIPE(#__START_UP_,"AutoHotFile_FE",1)
If (#__SET__PRELOAD_STDOUTTOVAR_ and !#__StdoutToVar_PID)
	#__StdoutToVar_PID:=#__RUN_STDOUTTOVAR_PIPE(#__START_UP_,"AutoHotFile_CMD",1)
Return
CreateNamedPipe(Name, OpenMode=3, PipeMode=0, MaxInstances=255) {
	return DllCall("CreateNamedPipe","str","\\.\pipe\" Name,"uint",OpenMode
		,"uint",PipeMode,"uint",MaxInstances,"uint",0,"uint",0,"uint",0,"uint",0)
}

RunPipe(Script,#__PIPE_NAME_="",AhkPath=""){
	global #__AHK_EXE_, #__ToolTip_Options
	If !#__PIPE_NAME_
		#__PIPE_NAME_ = %A_TickCount%
	script := chr(239) . chr(187) . chr(191) . Script
	#__PIPE_GA_ := CreateNamedPipe(#__PIPE_NAME_, 2)
	#__PIPE_    := CreateNamedPipe(#__PIPE_NAME_, 2)
	if (#__PIPE_=-1 or #__PIPE_GA_=-1)
		ToolTip(5," ","Creating pipe failed","I3 D2 " . #__ToolTip_Options),Exit()
	If AhkPath
		Run, "%AhkPath%" "\\.\pipe\%#__PIPE_NAME_%"
	else
		PID:=Exe("\\.\pipe\" . #__PIPE_NAME_)
	DllCall("ConnectNamedPipe","uint",#__PIPE_GA_,"uint",0)
	DllCall("CloseHandle","uint",#__PIPE_GA_)
	DllCall("ConnectNamedPipe","uint",#__PIPE_,"uint",0)
	if !DllCall("WriteFile","uint",#__PIPE_,"str",script,"uint",StrLen(script)+1,"uint*",0,"uint",0)
		ToolTip(5, "Error message: " . ErrorLevel . "/" . A_LastError, "WriteFile failed","I3 D2 " . #__ToolTip_Options),Exit()
	DllCall("CloseHandle","uint",#__PIPE_)
	Return PID
}

RunPipeByRef(ByRef Script,#__PIPE_NAME_="",AhkPath=""){
	global #__AHK_EXE_, #__ToolTip_Options
	If !#__PIPE_NAME_
		#__PIPE_NAME_ = %A_TickCount%
	script := chr(239) . chr(187) . chr(191) . Script	
	#__PIPE_GA_ := CreateNamedPipe(#__PIPE_NAME_, 2)
	#__PIPE_    := CreateNamedPipe(#__PIPE_NAME_, 2)
	if (#__PIPE_=-1 or #__PIPE_GA_=-1)
		ToolTip(5," ","Creating pipe failed","I3 D2 " . #__ToolTip_Options),Exit()
	If AhkPath
		Run, "%AhkPath%" "\\.\pipe\%#__PIPE_NAME_%"
	else
		PID:=Exe("\\.\pipe\" . #__PIPE_NAME_)
	DllCall("ConnectNamedPipe","uint",#__PIPE_GA_,"uint",0)
	DllCall("CloseHandle","uint",#__PIPE_GA_)
	DllCall("ConnectNamedPipe","uint",#__PIPE_,"uint",0)
	if !DllCall("WriteFile","uint",#__PIPE_,"str",script,"uint",StrLen(script)+1,"uint*",0,"uint",0)
		ToolTip(5, "Error message: " . ErrorLevel . "/" . A_LastError, "WriteFile failed","I3 D2 " . #__ToolTip_Options),Exit()
	DllCall("CloseHandle","uint",#__PIPE_)
	Return PID
}

ShowExplorer_PIPE(ByRef script, name="",prepare="")
{
	global #__AHK_EXE_, #__ToolTip_Options
	static #__PIPE_, #__SCRIPT_PID_
	If prepare
	{
		If name
			#__PIPE_NAME_ := name
		else
			#__PIPE_NAME_ := A_TickCount
		#__PIPE_GA_ := CreateNamedPipe(#__PIPE_NAME_, 2)
		#__PIPE_    := CreateNamedPipe(#__PIPE_NAME_, 2)
		if (#__PIPE_=-1 or #__PIPE_GA_=-1) {
			ToolTip(5," ","Creating pipe failed","I3 D2 " . #__ToolTip_Options)
			Return
		}
		;Run, _AutoHotFile.exe "\\.\pipe\%#__PIPE_NAME_%",,UseErrorLevel,#__SCRIPT_PID_
		#__SCRIPT_PID_:=Exe("\\.\pipe\" . #__PIPE_NAME_)
		DllCall("ConnectNamedPipe","uint",#__PIPE_GA_,"uint",0)
		DllCall("CloseHandle","uint",#__PIPE_GA_)
		DllCall("ConnectNamedPipe","uint",#__PIPE_,"uint",0)
		Return #__SCRIPT_PID_
	}
	else
	{
		if !DllCall("WriteFile","uint",#__PIPE_,"str",script,"uint",StrLen(script)+1,"uint*",0,"uint",0)
			ToolTip(5, "Error message: " . ErrorLevel . "/" . A_LastError, "WriteFile failed","I3 D2 " . #__ToolTip_Options), Exit()
		DllCall("CloseHandle","uint",#__PIPE_)
		#__SCRIPT_PID_=
		Return
	}
}

#__RUN_STDOUTTOVAR_PIPE(ByRef script, name="",prepare="")
{
	global #__AHK_EXE_, #__ToolTip_Options
	static #__PIPE_, #__SCRIPT_PID_
	If prepare
	{
		If name
			#__PIPE_NAME_ := name
		else
			#__PIPE_NAME_ := A_TickCount
		#__PIPE_GA_ := CreateNamedPipe(#__PIPE_NAME_, 2)
		#__PIPE_    := CreateNamedPipe(#__PIPE_NAME_, 2)
		if (#__PIPE_=-1 or #__PIPE_GA_=-1)
			ToolTip(5," ","Creating pipe failed","I3 D2 " . #__ToolTip_Options),Exit()
		#__SCRIPT_PID_:=Exe("\\.\pipe\" . #__PIPE_NAME_)
		;Run, _AutoHotFile.exe "\\.\pipe\%#__PIPE_NAME_%",,UseErrorLevel,#__SCRIPT_PID_
		DllCall("ConnectNamedPipe","uint",#__PIPE_GA_,"uint",0)
		DllCall("CloseHandle","uint",#__PIPE_GA_)
		DllCall("ConnectNamedPipe","uint",#__PIPE_,"uint",0)
		Return #__SCRIPT_PID_
	}
	else
	{
		if !DllCall("WriteFile","uint",#__PIPE_,"str",script,"uint",StrLen(script)+1,"uint*",0,"uint",0)
			ToolTip(5, "Error message: " . ErrorLevel . "/" . A_LastError, "WriteFile failed","I3 D2 " . #__ToolTip_Options),Exit()
		DllCall("CloseHandle","uint",#__PIPE_)
		#__SCRIPT_PID_=
		Return
	}
}

WinGetClass(PID){
	global
	If PID = A
		WinGetClass, class,A
	Else
		WinGetClass, class,ahk_pid %PID%
	Return class
}
;==================== END: #Include .\include\_Run_# :B1AD529B-BF4E-477F-8B9F-3080CAC55AE3

;==================== START: #Include .\include\_FileReminder_# :B1AD529B-BF4E-477F-8B9F-3080CAC55AE3


;*************************************************************************************************
;*                                         FILE REMINDER                                         *
;*************************************************************************************************
#__FILE_REMINDER:
	Thread,Priority, -10
	SetTimer, #__FILE_REMINDER, Off
	#__TIME_STAMP =
	#__File_Remind =
	#__CURR_TIME_STAMP =
	#_ALL_FILES:=DBArray("files","find")
	StringReplace, #_ALL_FILES,#_ALL_FILES,`n,% """",All
	Loop, Parse, #_ALL_FILES, ""
	{
		IfInString, A_LoopField,#
			If (DBArray("Reminder","get",A_LoopField)>A_TickCount)
				Continue
		If RegExMatch(A_LoopField, "#\d\d\d*",#__File_Remind)
		{
			StringTrimLeft, #__TIME_STAMP, #__File_Remind, 1
			If StrLen(#__TIME_STAMP) > 4
				#__CURR_TIME_STAMP := SubStr(A_Now, 1, StrLen(#__TIME_STAMP))
			Else
				#__CURR_TIME_STAMP := SubStr(A_Now, 9, StrLen(#__TIME_STAMP))

			If (#__TIME_STAMP - 1 < #__CURR_TIME_STAMP)
				#__REMIND_FILE(A_LoopField)
		}
		else if RegExMatch(A_LoopField, "#MON\d*|#TUE\d*|#WED\d*|#THU\d*|#FRI\d*|#SAT\d*|#SUN\d*",#__File_Remind)
		{
			If StrLen(#__File_Remind) > 4
			{
				StringTrimLeft, #__TIME_STAMP, #__File_Remind, 4
				StringLeft, #__File_Remind, #__File_Remind, 4
			}
			If (%#__File_Remind% = A_WDay and #__TIME_STAMP = "")
				#__REMIND_FILE(DBArray("files","get",A_LoopField))
			Else if (%#__File_Remind% = A_WDay)
				If (SubStr(A_Now, 9, StrLen(#__TIME_STAMP)) > #__TIME_STAMP - 1)
					#__REMIND_FILE(A_LoopField)
		}
		If (#__SET__FILE_REMINDER_!="On" or #__NEW_FILE_TIMER_!="")
			break
	}
	If #__SET__FILE_REMINDER_=On
	{
		If #__NEW_FILE_TIMER_ =
			SetTimer, #__FILE_REMINDER, 10000
		else
			SetTimer, #__FILE_REMINDER, %#__NEW_FILE_TIMER_%
	}
	#__NEW_FILE_TIMER_ =
Return
#__REMIND_FILE(file)
{
	global #__NEW_FILE_TIMER_, #__ALREADY_REMINDED_FILES_
	IfNotExist, %file%
		Return
	FormatTime,#__NOW_, %A_Now%, dddd, HH:mm:ss
	SplitPath, file,fn,fd
	#_REMINDER_HWND:=ToolTip("Reminder"
		, "<a open|" . file . ">Open</a> - <a explore|" . file . ">Show</a> - <a copy|" . file . ">CopyPath</a> - <a cancel|" . file . ">Cancel for now</a>`n"
		. "`nFileName:`t" . fn . "`nDirectory:`t" . fd
		. "`n`n<a 1|" . file . ">Remind again in  1</a> <a 5|" . file . ">5</a> <a 10|" . file . ">10</a> <a 15|" . file . ">15</a> <a 20|" . file . ">20</a> <a 30|" . file . ">30</a> <a 60|" . file . ">60 minutes</a> - "
		. "<a 120|" . file . ">2</a> <a 180|" . file . ">3</a> <a 240|" . file . ">4</a> <a 480|" . file . ">8</a> <a 720|" . file . ">12 hours</a>"
		. "`n`n<a 1001>Suspend all for   1</a> <a 1005>5</a> <a 1015>15</a> <a 1030>30</a> <a 1060>60 minutes</a>"
		. " - <a 1120>2</a> <a 1240>4</a> <a 1480>8</a> <a 1720>12 hours</a>"
		. "`n`n<a turnoff>Turn Off File Reminder for now</a>"
		, fn . " - " . #__NOW_,"P99 O1 C1 L1 I1 xTrayIcon yTrayIcon")
	WinWaitClose,ahk_id %#_REMINDER_HWND%
	Return
}
ReminderToolTipClose:
#__NEW_FILE_TIMER_ := 300000
ToolTip("Reminder")
Return
ReminderToolTip:
StringSplit, #_Reminder_Action, ErrorLevel,|
If #_Reminder_Action1 is integer
{
	If (#_Reminder_Action1>1000)
	{
		#__NEW_FILE_TIMER_ := (#_Reminder_Action1-1000) * 60000
	} else {
		DBArray("Reminder",DBArray("Reminder","exist",#_Reminder_Action2) ? "set" : "add",#_Reminder_Action2,A_TickCount+#_Reminder_Action1*60000)
	}
	ToolTip("Reminder")
	Return
} else if (#_Reminder_Action1="Cancel"){
	DBArray("Reminder",DBArray("Reminder","exist",#_Reminder_Action2) ? "set" : "add",#_Reminder_Action2,"suspended")
	ToolTip("Reminder")
} else if (#_Reminder_Action1="turnoff")
	#__SET__FILE_REMINDER_:=Off,ToolTip("Reminder")
else if (#_Reminder_Action1="copy")
	Clipboard:=#_Reminder_Action2
else
	SetTimer, RunReminder, -100
Return
RunReminder:
Run(#_Reminder_Action2,#_Reminder_Action1)
Return
;~ #IfWinExist ahk_class tooltips_class32
;~ !LButton::LButton
;~ #IfWinActive





;==================== END: #Include .\include\_FileReminder_# :B1AD529B-BF4E-477F-8B9F-3080CAC55AE3

;==================== START: #Include .\include\_MiniMize_# :B1AD529B-BF4E-477F-8B9F-3080CAC55AE3


;*************************************************************************************************
;*                                HIDE AND UNHIDE ACTIVE WINDOW                                  *
;*************************************************************************************************
;Hides (CAPSLOCK & F4) and unhides (CAPSLOCK & F3) the active window
mwt_Minimize:
{
	if mwt_WindowCount >= %mwt_MaxWindows%
	{
		MsgBox No more than %mwt_MaxWindows% may be hidden simultaneously.
		return
	}
	WinWait, A,, 2
	if ErrorLevel <> 0
		return
	WinGet, mwt_ActiveID, ID
	WinGetTitle, mwt_ActiveTitle
	WinGetClass, mwt_ActiveClass
	if mwt_ActiveClass in Shell_TrayWnd,Progman
	{
		MsgBox The desktop and taskbar cannot be hidden.
		return
	}
	Send, !{esc}
	WinHide
	if mwt_ActiveTitle =
		mwt_ActiveTitle = ahk_class %mwt_ActiveClass%
	StringLeft, mwt_ActiveTitle, mwt_ActiveTitle, %mwt_MaxLength%
	Loop, %mwt_MaxWindows%
	{
		if mwt_WindowTitle%a_index% = %mwt_ActiveTitle%
		{


			StringTrimLeft, mwt_ActiveIDShort, mwt_ActiveID, 2
			StringLen, mwt_ActiveIDShortLength, mwt_ActiveIDShort
			StringLen, mwt_ActiveTitleLength, mwt_ActiveTitle
			mwt_ActiveTitleLength += %mwt_ActiveIDShortLength%
			mwt_ActiveTitleLength++
			if mwt_ActiveTitleLength > %mwt_MaxLength%
			{



				TrimCount = %mwt_ActiveTitleLength%
				TrimCount -= %mwt_MaxLength%
				StringTrimRight, mwt_ActiveTitle, mwt_ActiveTitle, %TrimCount%
			}

			mwt_ActiveTitle = %mwt_ActiveTitle% %mwt_ActiveIDShort%
			break
		}
	}
	mwt_AlreadyExists = n
	Loop, %mwt_MaxWindows%
	{
		if mwt_WindowID%a_index% = %mwt_ActiveID%
		{
			mwt_AlreadyExists = y
			break
		}
	}
	if mwt_AlreadyExists = n
	{
		Menu, Tray, add, %mwt_ActiveTitle%, RestoreFromTrayMenu
		mwt_WindowCount++
		Loop, %mwt_MaxWindows%
		{

			if mwt_WindowID%a_index% =
			{
				mwt_WindowID%a_index% = %mwt_ActiveID%
				mwt_WindowTitle%a_index% = %mwt_ActiveTitle%
				break
			}
		}
	}
	return
}
RestoreFromTrayMenu:
{
	Menu, Tray, delete, %A_ThisMenuItem%

	Loop, %mwt_MaxWindows%
	{
		if mwt_WindowTitle%a_index% = %A_ThisMenuItem%
		{
			StringTrimRight, IDToRestore, mwt_WindowID%a_index%, 0
			WinShow, ahk_id %IDToRestore%
			WinActivate ahk_id %IDToRestore%
			mwt_WindowID%a_index% =
			mwt_WindowTitle%a_index% =
			mwt_WindowCount--
			break
		}
	}
	return
}
mwt_UnMinimize:
{
	if mwt_WindowCount > 0
	{

		StringTrimRight, IDToRestore, mwt_WindowID%mwt_WindowCount%, 0
		WinShow, ahk_id %IDToRestore%
		WinActivate ahk_id %IDToRestore%

		StringTrimRight, MenuToRemove, mwt_WindowTitle%mwt_WindowCount%, 0
		Menu, Tray, delete, %MenuToRemove%

		mwt_WindowID%mwt_WindowCount% =
		mwt_WindowTitle%mwt_WindowCount% =
		mwt_WindowCount--
	}
	return
}
mwt_RestoreAll:
{
Loop, %mwt_MaxWindows%
{
	if mwt_WindowID%a_index% <>
	{
		StringTrimRight, IDToRestore, mwt_WindowID%a_index%, 0
		WinShow, ahk_id %IDToRestore%
		WinActivate ahk_id %IDToRestore%


		StringTrimRight, MenuToRemove, mwt_WindowTitle%a_index%, 0
		Menu, Tray, delete, %MenuToRemove%
		mwt_WindowID%a_index% =
		mwt_WindowTitle%a_index% =
		mwt_WindowCount--
	}
	if mwt_WindowCount = 0
		break
}
return
}

;==================== END: #Include .\include\_MiniMize_# :B1AD529B-BF4E-477F-8B9F-3080CAC55AE3

;==================== START: #Include .\include\_RapidHotkey_# :B1AD529B-BF4E-477F-8B9F-3080CAC55AE3


RapidHotkey(keystroke, times="", delay=0.2, IsLabel=0)
{
	local pattern, backspace, keystr, hotkey, continue
	Pattern := Morse(delay*1000)
	If (StrLen(Pattern) < 2 and Chr(Asc(times)) != "1")
		Return
	If (times = "" and InStr(keystroke, """"))
	{
		Loop, Parse, keystroke,""	
			If (StrLen(Pattern) = A_Index+1)
				continue := A_Index, times := StrLen(Pattern)
	}
	Else if (RegExMatch(times, "^\d+$") and InStr(keystroke, """"))
	{
		Loop, Parse, keystroke,""
			If (StrLen(Pattern) = A_Index+times-1)
				times := StrLen(Pattern), continue := A_Index
	}
	Else if InStr(times, """")
	{
		Loop, Parse, times,""
			If (StrLen(Pattern) = A_LoopField)
				continue := A_Index, times := A_LoopField
	}
	Else if (times = "")
		continue = 1, times = 1
	Else if (times = StrLen(Pattern))
		continue = 1
	If !continue
		Return
	Loop, Parse, keystroke,""
		If (continue = A_Index)
			keystr = %A_LoopField%
	Loop, Parse, IsLabel,""
		If (continue = A_Index)
			IsLabel = %A_LoopField%
	hotkey := RegExReplace(A_ThisHotkey, "[\*\~\$\#\+\!\^]")
	Loop % times
		backspace .= "{Backspace}"
	;keywait = Ctrl|Alt|Shift|LWin|RWin
	;Loop, Parse, keywait, |
	;	KeyWait, %A_LoopField%
	If ((!IsLabel or (IsLabel and IsLabel(keystr))) and InStr(A_ThisHotkey, "~") and !RegExMatch(A_ThisHotkey
	, "i)\^[^\!\d]|![^\d]|#|Control|Ctrl|LCtrl|RCtrl|Shift|RShift|LShift|RWin|LWin|Escape|BackSpace|F\d\d?|"
	. "Insert|Esc|Escape|BS|Delete|Home|End|PgDn|PgUp|Up|Down|Left|Right|ScrollLock|CapsLock|NumLock|AppsKey|"
	. "PrintScreen|CtrlDown|Pause|Break|Help|Sleep|Browser_Back|Browser_Forward|Browser_Refresh|Browser_Stop|"
	. "Browser_Search|Browser_Favorites|Browser_Home|Volume_Mute|Volume_Down|Volume_Up|MButton|RButton|LButton|"
	. "Media_Next|Media_Prev|Media_Stop|Media_Play_Pause|Launch_Mail|Launch_Media|Launch_App1|Launch_App2"))
		Send % backspace
	If (WinExist("AHK_class #32768") and hotkey = "RButton")
		WinClose, AHK_class #32768
	If !IsLabel
		Send % keystr
	else if IsLabel(keystr)
		Gosub, %keystr%
	Return
}	
Morse(timeout = 400) { ;by Laszo -> http://www.autohotkey.com/forum/viewtopic.php?t=16951 (Modified to return: KeyWait %key%, T%tout%)
   tout := timeout/1000
   key := RegExReplace(A_ThisHotKey,"[\*\~\$\#\+\!\^]")
   Loop {
      t = %A_TickCount%
      KeyWait %key%, T%tout%
	  Pattern .= A_TickCount-t > timeout
	  If(ErrorLevel)
		Return Pattern
	  KeyWait %key%,DT%tout%
      If (ErrorLevel)
         Return Pattern
   }
}



;==================== END: #Include .\include\_RapidHotkey_# :B1AD529B-BF4E-477F-8B9F-3080CAC55AE3

;==================== START: #Include .\include\_WATCH_FOLDER_# :B1AD529B-BF4E-477F-8B9F-3080CAC55AE3

;*************************************************************************************************
;*                  FOLDERSPY (by SKAN) - ASYNC (by Lexicos) - AND MY MODIFICATIONS              *
;*************************************************************************************************
WatchFolder:
	SetTimer, WatchFolder, OFF
	;started:=A_TickCount
	WatchDirectory("ReportDirectoryChanges")
	If ((#__SET__AUTOHOTSTRING_ = "ON" or #__SET__USE_CHORDING_) and #__RECREATE_HOTSTRINGS_ and !#__RECREATE_HOTSTRINGS_:=0)
		GoSub, #__CREATE_HOTSTRINGS_
	If (#__RELOAD_SCRIPT_ != "")
	{
		If !InStr(#__RELOAD_SCRIPT_NOW, "`n" . #__RELOAD_SCRIPT_ . "`n")
		{
			#__RELOAD_SCRIPT_NOW .= #__RELOAD_SCRIPT_
			SetTimer, ReloadScript, -100
			SetTimer, WatchFolder, -50
		}
		Else
			SetTimer, WatchFolder, -300
		#__RELOAD_SCRIPT_ =
	}
	else
		SetTimer, WatchFolder, -300
	;OutputDebug % (A_TickCount-started)
Return
ResumeWatchingDirectory:
Loop, %#__SET__DIRECTORIES_TO_LOAD_0%
{
	#__CURRENT_PATH_ =
	#__DIRECTORY_PATTERNS_ := #__SET__DIRECTORIES_TO_LOAD_%A_Index%
	Loop,% SubStr(#__DIRECTORY_PATTERNS_, 1, InStr(#__DIRECTORY_PATTERNS_, "\", 0, 0)-1), 2, 0
		 #__CURRENT_PATH_ := StrLen(A_LoopFileLongPath) = 3 ? A_LoopFileLongPath : A_LoopFileLongPath . "\"
	If !FileExist(#__CURRENT_PATH_)
	 continue
	If (SubStr(#__DIRECTORY_PATTERNS_, InStr(#__DIRECTORY_PATTERNS_, "\",0,0)+1, 1) = "*")
		#__INCLUDE_SUBFOLDERS_ = 1
	Else #__INCLUDE_SUBFOLDERS_ = 0
	WatchDirectory(#__CURRENT_PATH_, #__INCLUDE_SUBFOLDERS_)
}
Return
ReportDirectoryChanges(action,#__FILE_DIR_,#__FILE_NAME_){
	local #__FILE_FULL_PATH_
	static #__FILE_FULL_PATH_SAVE_
	#__FILE_FULL_PATH_:= #__FILE_DIR_ . #__FILE_NAME_
	SplitPath,#__FILE_FULL_PATH_, #__FILE_NAME_, #__FILE_DIR_, #__FILE_EXT_
	#__FILE_DIR_ .= "\"
	#__KEY_WORD_ := GetKeyWord(#__FILE_NAME_)
	If ( Action = 0x3 and !InStr(FileExist(#__FILE_FULL_PATH_), "D"))
	{
		#__FILE := DBArray("files","get",#__KEY_WORD_)
		Loop, Parse,#__FILE, `n
		{
			If (#__SET__RELOAD_AHK_ON_CHANGE_ != "OFF" and A_LoopField = #__FILE_FULL_PATH_)
				IfWinExist, %#__FILE_FULL_PATH_% ahk_class AutoHotkey
					If (!InStr(#__RELOAD_SCRIPT_, "`n" . #__FILE_FULL_PATH_ . "`n") and #__FILE_FULL_PATH_!=A_ScriptFullPath)
						#__RELOAD_SCRIPT_ .= "`n" . #__FILE_FULL_PATH_ . "`n"
		}
	} else if InStr(FileExist(#__FILE_FULL_PATH_), "D") {
		If (Action = 0x5){
			Loop %#__LOOP_FILE_PATTERNS_%
			{
				If InStr(#__FILE_PATTERNS_%A_Index%,#__FILE_FULL_PATH_SAVE_){
					DBArray("files","replace", %#__FILE_FULL_PATH_SAVE_%, %#__FILE_FULL_PATH_%)
					break
				}
			}
		}
	} else If (#__KEY_WORD_ != "") {
		If ( Action = 0x1 or  Action = 0x5 )
		{
			If (#__FILE_FULL_PATH_=A_AhkPath)
				#__AutoHotFile_Renamed_EXE=
			else if #__AutoHotFile_Renamed_EXE
				#__AutoHotFile_Renamed_EXE=%#__FILE_FULL_PATH_%
			else {
				Loop %#__LOOP_FILE_PATTERNS_%
				{
					If (SubStr(#__FILE_PATTERNS_%A_Index%,-1)="\*")
						Continue
					#__FILE_PATTERNS_:= #__FILE_PATTERNS_%A_Index%
					#__FILE_PATTERNS_:=StringToRegEx(#__FILE_PATTERNS_,1)
					#__RegEx_ := !#__INCLUDE_SUBFOLDERS_%A_Index% ? "[^\\]*" : ".*"
					StringReplace, #__FILE_PATTERNS_, #__FILE_PATTERNS_, *, %#__RegEx_%, All
					If RegExMatch(#__FILE_FULL_PATH_, "i)^" . #__FILE_PATTERNS_ . "$")
					{
						If DBArray("files","exist",#__KEY_WORD_)
							DBArray("files","set",#__KEY_WORD_,DBArray("files","get",#__KEY_WORD_) . "`n" . #__FILE_FULL_PATH_)
						Else
							DBArray("files","add",#__KEY_WORD_,#__FILE_FULL_PATH_)
						If RegExMatch(#__FILE_NAME_, "CAPSLOCK.|SCROLLLOCK.|NUMLOCK.|HOTKEY..")
							#__CREATE_HOTKEY(#__FILE_NAME_)
						#__BUILD_FILE_HOTKEY_INFO_()
						#__RECREATE_HOTSTRINGS_ = 1
						break
					}
				}
			}
		}
		else If ( Action = 0x2 or Action = 0x4 )
		{
			If (#__FILE_FULL_PATH_=A_AhkPath)
				#__AutoHotFile_Renamed_EXE=1
			else if (#__FILE_FULL_PATH_=#__AutoHotFile_Renamed_EXE)
				#__AutoHotFile_Renamed_EXE=
			else If DBArray("files","exist",#__KEY_WORD_)
			{
				#_FILES:=DBArray("files","get",#__KEY_WORD_)
				StringReplace,#_FILES,#_FILES,`n%#__FILE_FULL_PATH_%
				StringReplace,#_FILES,#_FILES,%#__FILE_FULL_PATH_%`n
				StringReplace,#_FILES,#_FILES,%#__FILE_FULL_PATH_%
				If #_FILES
					DBArray("files","set",#__KEY_WORD_, #_FILES)
				else
					DBArray("files","delete",#__KEY_WORD_)
				#__TEMP_VAR_:="", #__RECREATE_HOTSTRINGS_:=1
				#__DESTROY_HOTKEY(#__FILE_NAME_), #__CREATE_HOTKEY(#__FILE_NAME_), #__BUILD_FILE_HOTKEY_INFO_()
				#__KEY_WORD_=
				#__BUILD_FILE_HOTKEY_INFO_()
			}
		}
	}
	#__FILE_FULL_PATH_SAVE_:=#__FILE_FULL_PATH_
}
;Function WatchDirectory()
;
;Parameters
;		WatchFolder			- Specify a valid path to watch for changes in.
;			can be directory or drive (e.g. c:\ or c:\Temp) 
;			can be network path e.g. \\192.168.2.101\Shared)
;		WatchSubDirs		- Specify whether to search in subfolders
;
;StopWatching
;		Specify WatchDirectory() to stop watching all directories
;
;ReportChanges
;		Specify WatchDirectory("ReportingFunctionName") to process registered changes.
;		Syntax of ReportingFunctionName(Action,Folder,File)

WatchDirectory(WatchFolder="", WatchSubDirs=true)
{
	static
	local hDir, hEvent, r, Action, FileNameLen, pFileName, Restart, CurrentFolder, PointerFNI, _SizeOf_FNI_=65536
	nReadLen := 0
	If !(WatchFolder){
		Gosub, StopWatchingDirectories
	} else if IsFunc(WatchFolder) {
		r := DllCall("MsgWaitForMultipleObjectsEx", UInt, DirIdx, UInt, &DirEvents, UInt, -1, UInt, 0x4FF, UInt, 0x6) ;Timeout=-1
		if !(r >= 0 && r < DirIdx)
			Return
		r += 1
		CurrentFolder := Dir%r%Path
		PointerFNI := &Dir%r%FNI
		DllCall( "GetOverlappedResult", UInt, hDir, UInt, &Dir%r%Overlapped, UIntP, nReadLen, Int, true )
		Loop {
			pNext   	:= NumGet( PointerFNI + 0  )
			Action      := NumGet( PointerFNI + 4  )
			FileNameLen := NumGet( PointerFNI + 8  )
			pFileName :=       ( PointerFNI + 12 )
			If (Action < 0x6){
				VarSetCapacity( FileNameANSI, FileNameLen )
				DllCall( "WideCharToMultiByte",UInt,0,UInt,0,UInt,pFileName,UInt,FileNameLen,Str,FileNameANSI,UInt,FileNameLen,UInt,0,UInt,0)
				%WatchFolder%(Action,CurrentFolder,SubStr( FileNameANSI, 1, FileNameLen/2 ))
			}
			If (!pNext or pNext = 4129024)
				Break
			Else
				PointerFNI := (PointerFNI + pNext)
		}
		DllCall( "ResetEvent", UInt,NumGet( Dir%r%Overlapped, 16 ) )
		Gosub, ReadDirectoryChanges ;(Dir%r%,Dir%r%FNI,_SizeOf_FNI_,Dir%r%WatchSubDirs,Dir%r%Overlapped)
		return r
	} else {
		Loop % (DirIdx) {
			If InStr(WatchFolder, Dir%A_Index%Path){
				If (Dir%A_Index%Subdirs)
					Return
			} else if InStr(Dir%A_Index%Path, WatchFolder) {
				If (WatchSubDirs){
					DllCall( "CloseHandle", UInt,Dir%A_Index% )
					DllCall( "CloseHandle", UInt,NumGet(Dir%A_Index%Overlapped, 16) )
					Restart := DirIdx, DirIdx := A_Index
				}
			}
		}
		If !Restart
			DirIdx += 1
		r:=DirIdx
		hDir := DllCall( "CreateFile"
					 , Str  , WatchFolder
					 , UInt , ( FILE_LIST_DIRECTORY := 0x1 )
					 , UInt , ( FILE_SHARE_READ     := 0x1 )
							| ( FILE_SHARE_WRITE    := 0x2 )
							| ( FILE_SHARE_DELETE   := 0x4 )
					 , UInt , 0
					 , UInt , ( OPEN_EXISTING := 0x3 )
					 , UInt , ( FILE_FLAG_BACKUP_SEMANTICS := 0x2000000  )
							| ( FILE_FLAG_OVERLAPPED       := 0x40000000 )
					 , UInt , 0 )
		Dir%r%         := hDir
		Dir%r%Path     := WatchFolder
		Dir%r%Subdirs  := WatchSubDirs
		Gosub, WatchDirectory
		If Restart
			DirIdx = %Restart%
	}
	Return
	WatchDirectory:
		VarSetCapacity( Dir%r%FNI, _SizeOf_FNI_ )
		VarSetCapacity( Dir%r%Overlapped, 20, 0 )
		DllCall( "CloseHandle", UInt,hEvent )
		hEvent := DllCall( "CreateEvent", UInt,0, Int,true, Int,false, UInt,0 )
		NumPut( hEvent, Dir%r%Overlapped, 16 )
		if ( VarSetCapacity(DirEvents) < DirIdx*4 and VarSetCapacity(DirEvents, DirIdx*4 + 60))
			Loop %DirIdx%
			{
				If (SubStr(Dir%A_Index%Path,1,1)!="-"){
					action++
					NumPut( NumGet( Dir%action%Overlapped, 16 ), DirEvents, action*4-4 )
				}
			}
		NumPut( hEvent, DirEvents, DirIdx*4-4)
		Gosub, ReadDirectoryChanges ;(Dir%r%,Dir%r%FNI,_SizeOf_FNI_,Dir%r%Subdirs,Dir%r%Overlapped)
	Return
	StopWatchingDirectories:
		Loop % (DirIdx) {
			DllCall( "CloseHandle", UInt,Dir%A_Index% )
			DllCall( "CloseHandle", UInt,NumGet(Dir%A_Index%Overlapped, 16) )
			Dir%A_Index%=
			Dir%A_Index%Path=
			Dir%A_Index%Subdirs=
			Dir%A_Index%FNI=
			DllCall( "CloseHandle", UInt, NumGet(Dir%A_Index%Overlapped,16) )
			VarSetCapacity(Dir%A_Index%Overlapped,0)
		}
		DirIdx=
		VarSetCapacity(DirEvents,0)
	Return
	ReadDirectoryChanges:
		DllCall( "ReadDirectoryChangesW"
			, UInt , Dir%r%
			, UInt , &Dir%r%FNI
			, UInt , _SizeOf_FNI_
			, UInt , Dir%r%SubDirs
			, UInt , ( FILE_NOTIFY_CHANGE_FILE_NAME   := 0x1   )
				   | ( FILE_NOTIFY_CHANGE_DIR_NAME    := 0x2   )
			;	   | ( FILE_NOTIFY_CHANGE_ATTRIBUTES  := 0x4   )
				   | ( FILE_NOTIFY_CHANGE_SIZE        := 0x8   )
				   | ( FILE_NOTIFY_CHANGE_LAST_WRITE  := 0x10  )
				   | ( FILE_NOTIFY_CHANGE_CREATION    := 0x40  )
			;	   | ( FILE_NOTIFY_CHANGE_SECURITY    := 0x100 )
			, UInt , 0
			, UInt , &Dir%r%Overlapped
			, UInt , 0  )
	Return
}

;==================== END: #Include .\include\_WATCH_FOLDER_# :B1AD529B-BF4E-477F-8B9F-3080CAC55AE3

;==================== START: #Include .\include\_SETTINGS_# :B1AD529B-BF4E-477F-8B9F-3080CAC55AE3


#__CREATE_SETTINGS_:
IniWrite, 0, %#__INI_FILE_%,CONFIG, #__SET__CHECKFORUPDATE_
IniWrite, OFF, %#__INI_FILE_%,CONFIG, #__SET__AUTOSTART_
IniWrite, OFF, %#__INI_FILE_%,CONFIG, #__SET__AUTOHOTSTRING_
IniWrite, %A_ProgramFiles%\Internet Explorer\iexplore.exe, %#__INI_FILE_%,CONFIG, #__SET__WEBBROWSER_
IniWrite, %A_WinDir%\notepad.exe, %#__INI_FILE_%,CONFIG, #__SET__EDITOR_
IniWrite, exe|ahk|lnk, %#__INI_FILE_%,CONFIG, #__SET__GLOBAL_EXT_
IniWrite, %A_ProgramFiles%\AutoHotkey\AutoScriptWriter\*|%A_Programs%\*/*.lnk|%A_ProgramsCommon%\*/*.lnk|%A_MyDocuments%\*, %#__INI_FILE_%,CONFIG, #__SET__DIRECTORIES_
IniWrite, 0xFFFFFF, %#__INI_FILE_%,CONFIG, #__SET__COLOR_B_
IniWrite, 0x000000, %#__INI_FILE_%,CONFIG, #__SET__COLOR_T_
IniWrite, 12, %#__INI_FILE_%,CONFIG, #__SET__PROPOSAL_
IniWrite, OFF, %#__INI_FILE_%,CONFIG, #__SET__FILE_REMINDER_
IniWrite, OFF, %#__INI_FILE_%,CONFIG, #__SET__RELOAD_AHK_ON_CHANGE_
IniWrite, #, %#__INI_FILE_%,CONFIG, #__SET__HOTSTRING_RUN_
IniWrite, ', %#__INI_FILE_%,CONFIG, #__SET__HOTSTRING_EDIT_
IniWrite, ?, %#__INI_FILE_%,CONFIG, #__SET__HOTSTRING_SHOW_
IniWrite, <, %#__INI_FILE_%,CONFIG, #__SET__HOTSTRING_COPY_PATH_
IniWrite, >, %#__INI_FILE_%,CONFIG, #__SET__HOTSTRING_COPY_DIR_
IniWrite, 10, %#__INI_FILE_%, CONFIG, #__SET__HOTSTRING_MAX_
IniWrite, DEFAULT, %#__INI_FILE_%, CONFIG, #__SET__PROFILES_
IniWrite, ``t, %#__INI_FILE_%,CONFIG, #__SET__HOTSTRING_END_CHAR_
IniWrite, % "caret",%#__INI_FILE_%,CONFIG, #_XPOS_
IniWrite, % "caret",%#__INI_FILE_%,CONFIG, #_YPOS_
IniWrite, % "",%#__INI_FILE_%,CONFIG, #__SET__FAVORITS_
MsgBox,262148, Select Language,Please Yes for English or No for Deutsch
IfMsgBox Yes
	IniWrite, % "EN",%#__INI_FILE_%,CONFIG, #__SET__LANGUAGE_
else
	IniWrite, % "DE",%#__INI_FILE_%,CONFIG, #__SET__LANGUAGE_
IniWrite, % "",%#__INI_FILE_%,CONFIG, #__SET__WILDCARD_
IniWrite, % "OFF",%#__INI_FILE_%,CONFIG, #__SET__USECAPSLOCK_
IniWrite, 1,%#__INI_FILE_%,CONFIG,#__SET__WARN_ON_AUTOHOTSTRING_
IniWrite, ?O,%#__INI_FILE_%,CONFIG,#__SET__HOTSTRING_OPTION_
IniWrite, 150,%#__INI_FILE_%,CONFIG,#__SET__PROPOSAL_TIMEOUT_
IniWrite, 0,%#__INI_FILE_%,CONFIG,#__SET__BALLOON_
IfMsgBox Yes
	IniWrite, http://www.google.com/search?hl=en&q= &btnI=I'm+Feeling+Lucky&meta=/http://www.google.com/search?hl=en&num=100&q=<http://search-desc.ebay.com/search/search.dll?satitle= &fts=2>http://www.autohotkey.com/search/search.php?site=0&path=&result_page=search.php&query_string=?http://maps.google.com/maps?hl=en&um=1&ie=UTF-8&q= &fb=1&view=text&sa=X&oi=local_group&resnum=5&ct=more-results&cd=1,%#__INI_FILE_%,CONFIG,#__SET__WEB_
Else
	IniWrite, http://www.google.de/search?hl=de&q= &btnI=I'm+Feeling+Lucky&meta=/http://www.google.de/search?hl=de&num=100&q=>http://search-desc.ebay.de/search/search.dll?satitle= &fts=2>http://de.autohotkey.com/search/search.php?site=0&path=&result_page=search.php&query_string=?http://maps.google.com/maps?hl=de&um=1&ie=UTF-8&q= &fb=1&view=text&sa=X&oi=local_group&resnum=5&ct=more-results&cd=1,%#__INI_FILE_%,CONFIG,#__SET__WEB_
IniWrite, 0,%#__INI_FILE_%,CONFIG,#__SET__CLICKTROUGH_
IniWrite, 1,%#__INI_FILE_%,CONFIG,#__SET__STANDARD_TOOLTIP_
IniWrite, 0,%#__INI_FILE_%,CONFIG,#__SET_RUN_AHK_AS_EXE_
IniWrite, 0,%#__INI_FILE_%,CONFIG,#__SET_SUGGEST_WEB_
IniWrite, 0,%#__INI_FILE_%,CONFIG,#__SET__PRELOAD_STDOUTTOVAR_
IniWrite, CapsLock & F1%A_Tab%CapsLock & F2%A_Tab%CapsLock & F3%A_Tab%CapsLock & F4%A_Tab%CapsLock & F5%A_Tab%CapsLock & F6%A_Tab%CapsLock & F7%A_Tab%CapsLock & F8%A_Tab%CapsLock & F9%A_Tab%CapsLock & F10%A_Tab%CapsLock & F11%A_Tab%CapsLock & F12%A_Tab%CapsLock & Tab%A_Tab%CapsLock & Shift%A_Tab%CapsLock & Space%A_Tab%CapsLock & Ctrl%A_Tab%CapsLock & Pause,%#__INI_FILE_%,CONFIG,#__SET__HOTKEYS_
IniWrite,0,%#__INI_FILE_%,CONFIG,#__SET__USE_CHORDING_
IniWrite,3,%#__INI_FILE_%,CONFIG, #__SET__CHORDING_LENGTH_
IniWrite,#|'|+| |~|´|``|]|[|)|(|{|}|&|`%|$|§|!|°|^|-|_|.,%#__INI_FILE_%,Config,#__SET__KEYWORD_ENDCHAR_

IniRead, #__SET__USE_CHORDING_, %#__INI_FILE_%,CONFIG, #__SET__USE_CHORDING_,0
IniRead, #__SET__CHORDING_LENGTH_, %#__INI_FILE_%,CONFIG, #__SET__CHORDING_LENGTH_,3
IniRead, #__SET__KEYWORD_ENDCHAR_, %#__INI_FILE_%,CONFIG, #__SET__KEYWORD_ENDCHAR_,#|'|+| |~|´|``|]|[|)|(|{|}|&|`%|$|§|!|°|^|-|_|.
IniRead, #__SET__CHECKFORUPDATE_, %#__INI_FILE_%,CONFIG, #__SET__CHECKFORUPDATE_,0
IniRead, #__SET__HOTSTRING_OPTION_, %#__INI_FILE_%,CONFIG, #__SET__HOTSTRING_OPTION_,% "?"
IniRead, #__SET__AUTOSTART_, %#__INI_FILE_%,CONFIG, #__SET__AUTOSTART_,%A_Space%
IniRead, #__SET__AUTOHOTSTRING_, %#__INI_FILE_%,CONFIG, #__SET__AUTOHOTSTRING_,%A_Space%
IniRead, #__SET__WEBBROWSER_, %#__INI_FILE_%,CONFIG, #__SET__WEBBROWSER_,%A_Space%
IniRead, #__SET__EDITOR_, %#__INI_FILE_%,CONFIG, #__SET__EDITOR_,%A_Space%
IniRead, #__SET__GLOBAL_EXT_, %#__INI_FILE_%,CONFIG, #__SET__GLOBAL_EXT_,%A_Space%
IniRead, #__SET__DIRECTORIES_, %#__INI_FILE_%,CONFIG, #__SET__DIRECTORIES_,%A_Space%
IniRead, #__SET__COLOR_B_, %#__INI_FILE_%,CONFIG, #__SET__COLOR_B_, 0xFFFFFF
IniRead, #__SET__COLOR_T_, %#__INI_FILE_%,CONFIG, #__SET__COLOR_T_, 0x000000
IniRead, #__SET__PROPOSAL_, %#__INI_FILE_%,CONFIG, #__SET__PROPOSAL_,%A_Space%
IniRead, #__SET__FILE_REMINDER_, %#__INI_FILE_%,CONFIG, #__SET__FILE_REMINDER_,%A_Space%
IniRead, #__SET__RELOAD_AHK_ON_CHANGE_, %#__INI_FILE_%,CONFIG, #__SET__RELOAD_AHK_ON_CHANGE_,%A_Space%
IniRead, #_XPOS_, %#__INI_FILE_%,CONFIG, #_XPOS_,%A_Space%
IniRead, #_YPOS_, %#__INI_FILE_%,CONFIG, #_YPOS_,%A_Space%
IniRead, #__SET__WILDCARD_, %#__INI_FILE_%,CONFIG, #__SET__WILDCARD_,%A_Space%
IniRead, #__SET__HOTSTRING_RUN_, %#__INI_FILE_%,CONFIG, #__SET__HOTSTRING_RUN_,#
IniRead, #__SET__HOTSTRING_EDIT_, %#__INI_FILE_%,CONFIG, #__SET__HOTSTRING_EDIT_,'
IniRead, #__SET__HOTSTRING_SHOW_, %#__INI_FILE_%,CONFIG, #__SET__HOTSTRING_SHOW_, ?
IniRead, #__SET__HOTSTRING_COPY_PATH_, %#__INI_FILE_%,CONFIG, #__SET__HOTSTRING_COPY_PATH_, <
IniRead, #__SET__HOTSTRING_COPY_DIR_, %#__INI_FILE_%,CONFIG, #__SET__HOTSTRING_COPY_DIR_, >
IniRead, #__SET__LANGUAGE_, %#__INI_FILE_%,CONFIG, #__SET__LANGUAGE_,%A_Space%
IniRead, #__SET__HOTSTRING_MAX_, %#__INI_FILE_%,CONFIG, #__SET__HOTSTRING_MAX_, 10
IniRead, #__SET__PROFILES_, %#__INI_FILE_%,CONFIG, #__SET__PROFILES_,%A_Space%
IniRead, #__SET__USECAPSLOCK_, %#__INI_FILE_%,CONFIG, #__SET__USECAPSLOCK_, On
IniRead, #__SET__HOTSTRING_END_CHAR_,    %#__INI_FILE_%,CONFIG, #__SET__HOTSTRING_END_CHAR_, ``t
IniRead, #__SET__FAVORITS_,%#__INI_FILE_%,CONFIG, #__SET__FAVORITS_,%A_Space%
IniRead, #__SET__WARN_ON_AUTOHOTSTRING_, %#__INI_FILE_%, CONFIG, #__SET__WARN_ON_AUTOHOTSTRING_,1
IniRead, #__SET__PROPOSAL_TIMEOUT_, %#__INI_FILE_%, CONFIG, #__SET__PROPOSAL_TIMEOUT_,250
IniRead, #__SET__BALLOON_,%#__INI_FILE_%,CONFIG,#__SET__BALLOON_,0
IniRead, #__SET__WEB_,%#__INI_FILE_%,CONFIG,#__SET__WEB_,http://www.google.com/search?hl=de&q= &btnI=I'm+Feeling+Lucky&meta=.http://www.google.com/search?hl=en&q=-http://search-desc.ebay.com/search/search.dll?satitle= &fts=2?http://maps.google.com/maps?hl=en&um=1&ie=UTF-8&q= &fb=1&view=text&sa=X&oi=local_group&resnum=5&ct=more-results&cd=1
IniRead, #__SET__CLICKTROUGH_,%#__INI_FILE_%,CONFIG,#__SET__CLICKTROUGH_,0
IniRead, #__SET__STANDARD_TOOLTIP_,%#__INI_FILE_%,CONFIG,#__SET__STANDARD_TOOLTIP_,1
IniRead, #__SET_RUN_AHK_AS_EXE_,%#__INI_FILE_%,CONFIG,#__SET_RUN_AHK_AS_EXE_,0
IniRead, #__SET_SUGGEST_WEB_,%#__INI_FILE_%,CONFIG,#__SET_SUGGEST_WEB_,0
IniRead, #__SET__PRELOAD_STDOUTTOVAR_,%#__INI_FILE_%,CONFIG,#__SET__PRELOAD_STDOUTTOVAR_,0
IniRead, #__SET__HOTKEYS_,%#__INI_FILE_%,CONFIG,#__SET__HOTKEYS_,CapsLock & F1%A_Tab%CapsLock & F2%A_Tab%CapsLock & F3%A_Tab%CapsLock & F4%A_Tab%CapsLock & F5%A_Tab%CapsLock & F6%A_Tab%CapsLock & F7%A_Tab%CapsLock & F8%A_Tab%CapsLock & F9%A_Tab%CapsLock & F10%A_Tab%CapsLock & F11%A_Tab%CapsLock & F12%A_Tab%CapsLock & Tab%A_Tab%CapsLock & Shift%A_Tab%CapsLock & Space%A_Tab%CapsLock & Ctrl%A_Tab%CapsLock & Pause,%#__INI_FILE_%
Gosub, #__Create_Help
#__SETTINGS:
CAPSLOCK & RBUTTON::
CapsLock & F9::
IfWinExist, ahk_id %#__Settings_hwnd%
{
	WinActivate, ahk_id %#__Settings_hwnd%
	Return
}
#__SETTINGS_CHANGED_=
Loop, Parse, #__SET__USER_VARIABLES_, |
{
	Backup_%A_LoopField% := %A_LoopField%
	IniRead, %A_LoopField%, %#__INI_FILE_%, CONFIG, %A_LoopField%,%A_Space%
}
Gui, +LastFound
#__SETTINGS_HWND := WinExist()
Gui, Add, Tab, x6 y7 w530 h360 , General|Weblauncher|AutoHotString|File patterns|Profiles|Favorits|Advanced|Hotkeys|Help
Gui, Tab, General
Gui, Font, bold
Gui, Add, GroupBox, x16 y37 w510 h50 , %#_SETTINGS_GUI_WELCOME% (Version %#__SET__VERSION_%)
Gui, Font, norm
Gui, Add, Text, x26 y57 w450 h20 , %#_SETTINGS_GUI_WELCOME_TEXT%
Gui, Font, bold
;AutoStart
	;Check
	Gui, Add, GroupBox, x16 y87 w90 h90 , %#_SETTINGS_GUI_AUTOSTART%
	If #__SET__AUTOSTART_ = On
		#__Checked1 = Checked
	else if #__SET__AUTOSTART_ = Off
		#__Checked2 = Checked
	else
		#__Checked3 = Checked
	;Create Controls
	Gui, Add, Radio, x26 y107 w50 h20 g#__SET__AUTOSTART____________On v#__Radio_AutoStart %#__Checked1%, %#_SETTINGS_GUI_ON%
	Gui, Add, Radio, x26 y127 w50 h20 g#__SET__AUTOSTART____________Off %#__Checked2%, %#_SETTINGS_GUI_OFF%
	Gui, Add, Radio, x26 y147 w70 h20 g#__SET__AUTOSTART____________Ask %#__Checked3%, %#_SETTINGS_GUI_ASK%
	Loop 3
		#__Checked%A_Index% =
;AutoHotString
	;Check
	If #__SET__AUTOHOTSTRING_ = ON
		#__Checked1 = Checked
	else
		#__Checked2 = Checked
	;Create Controls
	Gui, Add, GroupBox, x116 y87 w90 h90 , %#_SETTINGS_GUI_AUTOHOTSTRING%
	Gui, Add, Radio, x126 y107 w50 h20 g#__SET__AUTOHOTSTRING________On v#__Radio_AutoHotString %#__Checked1%, %#_SETTINGS_GUI_ON%
	Gui, Add, Radio, x126 y127 w50 h20 g#__SET__AUTOHOTSTRING________Off %#__Checked2%, %#_SETTINGS_GUI_OFF%
	Loop 3
		#__Checked%A_Index% =
;FileReminder
	;Check
	If #__SET__FILE_REMINDER_ = On
		#__Checked1 = Checked
	else
		#__Checked2 = Checked
	;Create Controls
	Gui, Add, GroupBox, x216 y87 w90 h70 , %#_SETTINGS_GUI_FILEREMINDER%
	Gui, Add, Radio, x226 y107 w50 h20 g#__SET__FILE_REMINDER________On v#__Radio_FileReminder %#__Checked1%, %#_SETTINGS_GUI_ON%
	Gui, Add, Radio, x226 y127 w50 h20 g#__SET__FILE_REMINDER________Off %#__Checked2%, %#_SETTINGS_GUI_OFF%
	Loop 3
		#__Checked%A_Index% =
;Reload AHK scripts
	;check
	If #__SET__RELOAD_AHK_ON_CHANGE_ = On
		#__Checked1 = Checked
	else if #__SET__RELOAD_AHK_ON_CHANGE_ = Off
		#__Checked2 = Checked
	else if #__SET__RELOAD_AHK_ON_CHANGE_ = KILL
		#__Checked3 = Checked
	;Create Controls
	Gui, Add, GroupBox, x316 y87 w210 h90 , %#_SETTINGS_GUI_RELOAD%
	Gui, Add, Radio, x326 y107 w50 h20 g#__SET__RELOAD_AHK_ON_CHANGE_On v#__Radio_ReloadAHK %#__Checked1%, %#_SETTINGS_GUI_ON%
	Gui, Add, Radio, x326 y127 w50 h20 g#__SET__RELOAD_AHK_ON_CHANGE_Off %#__Checked2%, %#_SETTINGS_GUI_OFF%
	Gui, Add, Radio, x326 y147 w150 h20 g#__SET__RELOAD_AHK_ON_CHANGE_Kill %#__Checked3%, %#_SETTINGS_GUI_KILL%
	Loop 3
		#__Checked%A_Index% =
;Custom Applications
	Gui, Add, GroupBox, x16 y177 w350 h70 , %#_SETTINGS_GUI_CUSTOMAPP%
	Gui, Font, norm
	Gui, Add, Edit, x26 y197 w240 h20 gGuiSubmit v#__SET__WEBBROWSER_, %#__SET__WEBBROWSER_%
	Gui, Add, Button, x+10 y197 w80 h20 gWebBrowser, %#_SETTINGS_GUI_WEBBROWSER%
	Gui, Add, Edit, x26 y217 w240 h20 gGuiSubmit v#__SET__EDITOR_, %#__SET__EDITOR_%
	Gui, Add, Button, x+10 y217 w80 h20 gEditor, %#_SETTINGS_GUI_EDITOR%
;Other settings
	Gui, Font, bold
	Gui, Add, GroupBox, x16 y247 w350 h110 , %#_SETTINGS_GUI_COLOR%
	Gui, Font, norm
	#_H=15
	#_W=15
	Gui, Add, ListView, x230 y262 h%#_H% w%#_W% ReadOnly 0x4000 +BackgroundFF8080 AltSubmit gSelColor 
	Gui, Add, ListView, x+0      h%#_H% w%#_W% ReadOnly 0x4000 +BackgroundFFFF80 AltSubmit gSelColor 
	Gui, Add, ListView, x+0      h%#_H% w%#_W% ReadOnly 0x4000 +Background80FF80 AltSubmit gSelColor 
	Gui, Add, ListView, x+0      h%#_H% w%#_W% ReadOnly 0x4000 +Background00FF80 AltSubmit gSelColor 
	Gui, Add, ListView, x+0      h%#_H% w%#_W% ReadOnly 0x4000 +Background80FFFF AltSubmit gSelColor 
	Gui, Add, ListView, x+0      h%#_H% w%#_W% ReadOnly 0x4000 +Background0080FF AltSubmit gSelColor 
	Gui, Add, ListView, x+0      h%#_H% w%#_W% ReadOnly 0x4000 +BackgroundFF80C0 AltSubmit gSelColor 
	Gui, Add, ListView, x+0      h%#_H% w%#_W% ReadOnly 0x4000 +BackgroundFF80FF AltSubmit gSelColor 

	Gui, Add, ListView, x230 y+0 h%#_H% w%#_W% ReadOnly 0x4000 +BackgroundFF0000 AltSubmit gSelColor
	Gui, Add, ListView, x+0      h%#_H% w%#_W% ReadOnly 0x4000 +BackgroundFFFF00 AltSubmit gSelColor 
	Gui, Add, ListView, x+0      h%#_H% w%#_W% ReadOnly 0x4000 +Background80FF00 AltSubmit gSelColor 
	Gui, Add, ListView, x+0      h%#_H% w%#_W% ReadOnly 0x4000 +Background00FF40 AltSubmit gSelColor 
	Gui, Add, ListView, x+0      h%#_H% w%#_W% ReadOnly 0x4000 +Background00FFFF AltSubmit gSelColor 
	Gui, Add, ListView, x+0      h%#_H% w%#_W% ReadOnly 0x4000 +Background0080C0 AltSubmit gSelColor 
	Gui, Add, ListView, x+0      h%#_H% w%#_W% ReadOnly 0x4000 +Background8080C0 AltSubmit gSelColor 
	Gui, Add, ListView, x+0      h%#_H% w%#_W% ReadOnly 0x4000 +BackgroundFF00FF AltSubmit gSelColor 

	Gui, Add, ListView, x230 y+0 h%#_H% w%#_W% ReadOnly 0x4000 +Background804040 AltSubmit gSelColor
	Gui, Add, ListView, x+0      h%#_H% w%#_W% ReadOnly 0x4000 +BackgroundFF8040 AltSubmit gSelColor 
	Gui, Add, ListView, x+0      h%#_H% w%#_W% ReadOnly 0x4000 +Background00FF00 AltSubmit gSelColor 
	Gui, Add, ListView, x+0      h%#_H% w%#_W% ReadOnly 0x4000 +Background008080 AltSubmit gSelColor 
	Gui, Add, ListView, x+0      h%#_H% w%#_W% ReadOnly 0x4000 +Background004080 AltSubmit gSelColor 
	Gui, Add, ListView, x+0      h%#_H% w%#_W% ReadOnly 0x4000 +Background8080FF AltSubmit gSelColor 
	Gui, Add, ListView, x+0      h%#_H% w%#_W% ReadOnly 0x4000 +Background800040 AltSubmit gSelColor 
	Gui, Add, ListView, x+0      h%#_H% w%#_W% ReadOnly 0x4000 +BackgroundFF0080 AltSubmit gSelColor 

	Gui, Add, ListView, x230 y+0 h%#_H% w%#_W% ReadOnly 0x4000 +Background800000 AltSubmit gSelColor
	Gui, Add, ListView, x+0      h%#_H% w%#_W% ReadOnly 0x4000 +BackgroundFF8000 AltSubmit gSelColor 
	Gui, Add, ListView, x+0      h%#_H% w%#_W% ReadOnly 0x4000 +Background008000 AltSubmit gSelColor 
	Gui, Add, ListView, x+0      h%#_H% w%#_W% ReadOnly 0x4000 +Background008040 AltSubmit gSelColor 
	Gui, Add, ListView, x+0      h%#_H% w%#_W% ReadOnly 0x4000 +Background0000FF AltSubmit gSelColor 
	Gui, Add, ListView, x+0      h%#_H% w%#_W% ReadOnly 0x4000 +Background0000A0 AltSubmit gSelColor 
	Gui, Add, ListView, x+0      h%#_H% w%#_W% ReadOnly 0x4000 +Background800080 AltSubmit gSelColor 
	Gui, Add, ListView, x+0      h%#_H% w%#_W% ReadOnly 0x4000 +Background8000FF AltSubmit gSelColor 

	Gui, Add, ListView, x230 y+0 h%#_H% w%#_W% ReadOnly 0x4000 +Background400000 AltSubmit gSelColor
	Gui, Add, ListView, x+0      h%#_H% w%#_W% ReadOnly 0x4000 +Background804000 AltSubmit gSelColor 
	Gui, Add, ListView, x+0      h%#_H% w%#_W% ReadOnly 0x4000 +Background004000 AltSubmit gSelColor 
	Gui, Add, ListView, x+0      h%#_H% w%#_W% ReadOnly 0x4000 +Background004040 AltSubmit gSelColor 
	Gui, Add, ListView, x+0      h%#_H% w%#_W% ReadOnly 0x4000 +Background000080 AltSubmit gSelColor 
	Gui, Add, ListView, x+0      h%#_H% w%#_W% ReadOnly 0x4000 +Background000040 AltSubmit gSelColor 
	Gui, Add, ListView, x+0      h%#_H% w%#_W% ReadOnly 0x4000 +Background400040 AltSubmit gSelColor 
	Gui, Add, ListView, x+0      h%#_H% w%#_W% ReadOnly 0x4000 +Background400080 AltSubmit gSelColor 

	Gui, Add, ListView, x230 y+0 h%#_H% w%#_W% ReadOnly 0x4000 +Background000000 AltSubmit gSelColor
	Gui, Add, ListView, x+0      h%#_H% w%#_W% ReadOnly 0x4000 +Background808000 AltSubmit gSelColor 
	Gui, Add, ListView, x+0      h%#_H% w%#_W% ReadOnly 0x4000 +Background808040 AltSubmit gSelColor 
	Gui, Add, ListView, x+0      h%#_H% w%#_W% ReadOnly 0x4000 +Background808080 AltSubmit gSelColor 
	Gui, Add, ListView, x+0      h%#_H% w%#_W% ReadOnly 0x4000 +Background408080 AltSubmit gSelColor 
	Gui, Add, ListView, x+0      h%#_H% w%#_W% ReadOnly 0x4000 +BackgroundC0C0C0 AltSubmit gSelColor 
	Gui, Add, ListView, x+0      h%#_H% w%#_W% ReadOnly 0x4000 +Background400040 AltSubmit gSelColor 
	Gui, Add, ListView, x+0      h%#_H% w%#_W% ReadOnly 0x4000 +BackgroundFFFFFF AltSubmit gSelColor 

	Gui, Add, Slider, X140 y265   Thick15 w70 h18 Center NoTicks Range0-255 AltSubmit gUpdateSlider vRSlider_#
	Gui, Add, Text, x+1, R
	Gui, Add, Slider, x140 y+18   Thick15 w70 h18 Center NoTicks Range0-255 AltSubmit gUpdateSlider vGSlider_#
	Gui, Add, Text, x+1,G
	Gui, Add, Slider, x140 y+18   Thick15 w70 h18 Center NoTicks Range0-255 AltSubmit gUpdateSlider vBSlider_# 
	Gui, Add, Text, x+1,B
	
	Gui, Add, ListView, x25 y270  h32 w115 ReadOnly 0x4000 +Background%#__SET__COLOR_B_% AltSubmit, _
	Gui, Add, GroupBox, x25 y+3 w115 h48, %#_SETTINGS_GUI_COLORBOX%
	Gui, Add, Radio, x30 y321 Checked v#__ChooseColor, %#_SETTINGS_GUI_COLORBACKGROUND%
	Gui, Add, Radio, x30 y+1, %#_SETTINGS_GUI_COLORTEXT%
	LV_Add("","- ESCAPE = CANCEL")
	LV_Add("","- CTRL+H = HELP")
	;Gui, Font, cRed
	;GuiControl, Font, SysListView3249

Gui, Tab, AutoHotString
	Gui, Font, bold
	Gui, Add, GroupBox, x16 y37 w510 h140 , %#_SETTINGS_GUI_AutoHotString%
	Gui, Add, GroupBox, x16 y177 w510 h180 , %#_SETTINGS_GUI_AUTOHOTSTRINGSETTINGS%
	Gui, Font, norm
	Gui, Add, Text, x26 y57 w490 h110 , %#_SETTINGS_GUI_AutoHotStringTEXT%
	Gui, Font, bold
	Gui, Add, GroupBox, x26 y197 w110 h55 , %#_SETTINGS_GUI_ON%/%#_SETTINGS_GUI_OFF%
;AutoHotString
	;Check
	If #__SET__AUTOHOTSTRING_ = ON
		#__Checked1 = Checked
	else
		#__Checked2 = Checked
	;Create Controls
	Gui, Add, Radio, x36 y210 w50 h20 g#__SET__AUTOHOTSTRING________On v#__Radio_AutoHotString2 %#__Checked1%, %#_SETTINGS_GUI_ON%
	Gui, Add, Radio, x36 y230 w50 h20 g#__SET__AUTOHOTSTRING________Off %#__Checked2%, %#_SETTINGS_GUI_OFF%
	Gui, Add, GroupBox, x25 y255 w110 h45, Max characters
	Loop 3
		#__Checked%A_Index% =
	Gui, Font, norm
	Loop 38
		#__AutoHotStringMax .= A_Index = #__SET__HOTSTRING_MAX_ ? A_Index . "||" : A_Index . "|"
	Gui, Add, DropDownList, x36 y272 w60 h194 gGuiSubmit v#__SET__HOTSTRING_MAX_,%#__AutoHotStringMax%
	Gui,Font,bold
	Gui, Add, GroupBox, x25 y302 w45 h45, Timer
	Gui, Font, norm
	Gui, Add, Edit, x33 y319 w30 h20 gGuiSubmit v#__SET__WARN_ON_AUTOHOTSTRING_,%#__SET__WARN_ON_AUTOHOTSTRING_%
	Gui, Font, bold
	Gui, Add, GroupBox, x136 y197 w380 h150 , %#_SETTINGS_GUI_AUTOHOTSTRINGCHARS%
	Gui, Font, norm
	Gui, Add, Edit, x146 y217 w20 h20 gGuiSubmit v#__SET__HOTSTRING_RUN_, %#__SET__HOTSTRING_RUN_%
	Gui, Add, Edit, x146 y237 w20 h20 gGuiSubmit v#__SET__HOTSTRING_EDIT_, %#__SET__HOTSTRING_EDIT_%
	Gui, Add, Edit, x146 y257 w20 h20 gGuiSubmit v#__SET__HOTSTRING_SHOW_, %#__SET__HOTSTRING_SHOW_%
	Gui, Add, Edit, x146 y277 w20 h20 gGuiSubmit v#__SET__HOTSTRING_COPY_PATH_, %#__SET__HOTSTRING_COPY_PATH_%
	Gui, Add, Edit, x146 y297 w20 h20 gGuiSubmit v#__SET__HOTSTRING_COPY_DIR_, %#__SET__HOTSTRING_COPY_DIR_%
	StringReplace, #__SET__HOTSTRING_END_CHAR_SET, #__SET__HOTSTRING_END_CHAR_, %A_Tab%, ``t
	StringReplace, #__SET__HOTSTRING_END_CHAR_SET, #__SET__HOTSTRING_END_CHAR_, `n, ``n
	Gui, Add, Edit, x146 y317 w20 h20 gGuiSubmit v#__SET__HOTSTRING_END_CHAR_, %#__SET__HOTSTRING_END_CHAR_SET%
	Gui, Add, Text, x170 y219 w270 h20 , %#_SETTINGS_GUI_HOTSTRINGOPEN%
	Gui, Add, Text, x170 y239 w270 h20 , %#_SETTINGS_GUI_HOTSTRINGEDIT%
	Gui, Add, Text, x170 y259 w270 h20 , %#_SETTINGS_GUI_HOTSTRINGSHOW%
	Gui, Add, Text, x170 y279 w270 h20 , %#_SETTINGS_GUI_HOTSTRINGCOPY%
	Gui, Add, Text, x170 y299 w270 h20 , %#_SETTINGS_GUI_HOTSTRINGCOPYPATH%
	Gui, Add, Text, x170 y319 w270 h20 , %#_SETTINGS_GUI_HOTSTRINGENDCHAR%
Gui, Tab, File patterns
	Gui, Font, bold
	Gui, Add, GroupBox, x16 y37 w400 h320 , %#_SETTINGS_GUI_PATHS%
	Gui, Font, norm
	Gui, Add, Button, x26 y57 w70 h20 gAddDirectory, %#_SETTINGS_GUI_ADDPATH%
	Gui, Add, Button, x+5 y57 w130 h20 gDeleteDirectory, %#_SETTINGS_GUI_DELPATH%
	Gui, Add, Button, x+5 y57 w90 h20 gDeleteAllDirectories, %#_SETTINGS_GUI_DELALLPATHS%
	Gui, Add, ListView, x25 y87 w380 h260 AltSubmit NoSortHdr Checked -Multi -ReadOnly v#__Directories gSubDirectory, %#_SETTINGS_GUI_PATHHEADER%
	Gui, ListView, #__Directories
	Loop, parse, #__SET__DIRECTORIES_, |
		LV_Add(RegExMatch(A_LoopField, "\\\*[^\\]*$") ? "Check" : "", A_LoopField)
	Gui, Font, bold
	Gui, Add, GroupBox, x410 y37 w120 h320, %#_SETTINGS_GUI_EXTENSIONS%
	Gui, Font, norm
	Gui, Add, Button, x420 y57 w30 h20 gAddExtensions, %#_SETTINGS_GUI_ADDEXT%
	Gui, Add, Button, x+3 y57 w40 h20 gDeleteExtensions, %#_SETTINGS_GUI_DELEXT%
	Gui, Add, ListView, x420 y87 w105 h260 -ReadOnly v#__Extensions, %#_SETTINGS_GUI_EXTENSIONS%
	Gui, ListView, #__Extensions
	Loop, parse, #__SET__GLOBAL_EXT_, |
		LV_Add("", A_LoopField)
Gui, Tab, Profiles
	Gui, Font, bold
	Gui, Add, GroupBox, x16 y37 w510 h140 , %#_SETTINGS_GUI_PROFILES%
	Gui, Font, norm
	Gui, Add, Text, x26 y57 w420 h110 , %#_SETTINGS_GUI_PROFILESINFO%
	Gui, Font, bold
	Gui, Add, GroupBox, x16 y177 w510 h180 , %#_SETTINGS_GUI_PROFILESLIST%
	Gui, Font, norm
	Gui, Add, Button, x25 y200 w50 h20 Center gAddProfile, %#_SETTINGS_GUI_ADDEXT%
	Gui, Add, Button, x80 y200 w50 h20 Center gDeleteProfile, %#_SETTINGS_GUI_DELEXT%
	Gui, Add, ListView, x25 y230 w490 h120 -ReadOnly -Multi v#__Profiles gSelectProfile, %#_SETTINGS_GUI_PROFILESHEADER%
	Gui, ListView, #__Profiles
	Loop, Parse, #__SET__PROFILES_, |
		LV_Add("", A_LoopField)
Gui, Tab, Favorits
	Gui, Font, bold
	Gui, Add, GroupBox, x16 y37 w510 h320 , %#_SETTINGS_GUI_FAVORITES%
	Gui, Font, norm
	Gui, Add, Text, x25 y57 w490 h140, %#_SETTINGS_GUI_FAVORITESINFO%
	Gui, Add, Button, x25 y90 w50 h20 Center gAddFavorite, %#_SETTINGS_GUI_ADDEXT%
	Gui, Add, Button, x80 y90 w50 h20 Center gDeleteFavorite, %#_SETTINGS_GUI_DELEXT%
	Gui, Add, ListView, x25 y125 w490 h230 -ReadOnly v#__Favorits, %#_SETTINGS_GUI_FAVORITES%
	Gui, ListView, #__Favorits
	Loop, Parse, #__SET__FAVORITS_, |
		LV_Add("", A_LoopField)
Gui, Tab, Advanced
	Gui, Font, bold
	Gui, Add, GroupBox, x16 y37 w320 h80 , %#_SETTINGS_GUI_USEWILDCARD%
	Gui, Font, norm
	Gui, Add, Text, x26 y57 w295 h50 , %#_SETTINGS_GUI_WILDCARDINFO%
	Gui, Font, bold
	If #__SET__WILDCARD_ =
		#__checked2 = Checked
	else
		#__checked1 = Checked
	Gui, Add, Radio, x236 y87 w40 h20 g#__SET__WILDCARD_____________\w* v#__Radio_WildCard %#__checked1%, %#_SETTINGS_GUI_ON%
	Gui, Add, Radio, x+5 y87 w50 h20 g#__SET__WILDCARD_____________ %#__checked2%, %#_SETTINGS_GUI_OFF%
	Loop 3
		#__Checked%A_Index% =
	Gui, Add, GroupBox, x16 y122 w320 h80, %#_SETTINGS_GUI_POS%
	Gui, Font, norm
	Gui, Add, Text, x26 y137 w295 h50 , %#_SETTINGS_GUI_POSINFO%
	Gui, Font, bold
	Gui,Add,Text,x226 y172 w10 h20,X
	Gui, Add, Edit, x246 y172 w30 h20 gGuiSubMit v#_XPOS_,%#_XPOS_%
	Gui,Add,Text,x+5 y172 w10 h20,Y
	Gui, Add, Edit, x+5 y172 w30 h20 gGuiSubMit v#_YPOS_,%#_YPOS_%
	Gui, Add, GroupBox, x16 y207 w320 h80 , %#_SETTINGS_GUI_CAPSLOCK%
	Gui, Font, norm
	Gui, Add, Text, x26 y227 w295 h50 , %#_SETTINGS_GUI_CAPSLOCKINFO%
	Gui, Font, bold
	If #__SET__USECAPSLOCK_ = Off
		#__checked1 = Checked
	else
		#__checked2 = Checked
	Gui, Add, Radio, x26 y267 w100 h18 g#__SET__USECAPSLOCK__________Off v#__Radio_UseCapslock %#__checked1%, %#_SETTINGS_GUI_MULTIHOTKEY%
	Gui, Add, Radio, x+5 y267 w100 h18 g#__SET__USECAPSLOCK__________On %#__checked2%, %#_SETTINGS_GUI_NORMAL%
	Loop 3
		#__Checked%A_Index% =
Gui, Tab, Help
	Gui, Add, GroupBox, x16 y37 w510 h320, %#_SETTINGS_GUI_HELP%
	Gui, font, norm s7
	
	Gui, Add, ListView, x20 y87 w490 h260 ReadOnly AutoSize -Multi NoSortHdr v#__HELP_TAB, - TOPIC - ABOUT -|Desctiption
	Gui, ListView, #__HELP_TAB
	Loop, Parse, #__HELP_MENU, |
	{
		LV_Add("",SubStr((#__CURRENT_HELP_ := A_LoopField), 14))
		Loop, Parse, %A_LoopField%, |
			LV_Add("","",A_LoopField)
	}
	LV_ModifyCol()
Gui,Tab, AutoHotString
	Gui,Font,bold
	Gui, Add, GroupBox, x75 y302 w58 h45, %#_SETTINGS_GUI_OPTIONS%
	Gui, Add, Edit, x85 y319 w35 h20 gGuiSubmit v#__SET__HOTSTRING_OPTION_, %#__SET__HOTSTRING_OPTION_%
Gui, Tab, Advanced
	Gui, Font, bold
	Gui, Add, GroupBox, x16 y287 w320 h75, %#_SETTINGS_GUI_LISTSUGGEST%
	Gui,Font, norm
	Gui, Add, Text, x26 y307 w295 h50,%#_SETTINGS_GUI_LISTSUGGESTINFO%
	Gui, Font, bold
	Gui, Add, Edit, x206 y335 w30 h18 gGuiSubmit v#__SET__PROPOSAL_, %#__SET__PROPOSAL_%
	Gui, Font, Norm
	Gui, Add, Text, x+10 y337, %#_SETTINGS_GUI_TIMER%
	Gui, Font, bold
	Gui, Add, Edit, x+5 y335 w30 h18 gGuiSubmit v#__SET__PROPOSAL_TIMEOUT_, %#__SET__PROPOSAL_TIMEOUT_%
Gui, tab, WebLauncher
	Gui, font, Bold
	Gui, Add, GroupBox,x16 y37 w510 h135, %#_SETTINGS_GUI_WEBLAUNCHER%
	Gui, font, norm
	Gui,Add, Text, x25 y53 w460 h110,%#_SETTINGS_GUI_WEBLAUNCHERINFO%
	Gui, font, Bold
	Gui, Add, GroupBox,x16 y175 w510 h45, %#_SETTINGS_GUI_WEBLAUNCHERMAIN%
	Gui, font, norm
	#__Predefined_web :=RegExReplace(#__SET__WEB_,".http:.*") . "||"
	#__Predefined_web .= "http://www.google.co.uk/search?hl=en&num=100&q= &btnI=I'm+Feeling+Lucky&meta=|http://www.google.com/search?hl=en&num=100&q= &btnI=I'm+Feeling+Lucky&meta=|http://www.google.de/search?hl=de&num=100&q= &btnI=Auf+gut+Glck&meta=|http://uk.search.yahoo.com/search?p= &n=100|http://search.yahoo.com/search?p= &n=100|http://de.search.yahoo.com/search?p= &n=100"
	Gui, Add, ComboBox, x25 y193 w460 h70 v#__SET__WEB_ gGuiSubmit, %#__Predefined_web%
	Gui, font, Bold
	Gui, Add, GroupBox,x16 y227 w510 h133, %#_SETTINGS_GUI_WEBLAUNCHERPARAMS%
	Gui, font, norm
	Gui, Add, ListView, x25 y247 w490 h110 -ReadOnly v#__WebLauncher, %#_SETTINGS_GUI_WEBLAUNCHERLIST%
	Gui, ListView, #__Weblauncher
	#_Prefix_List_ =/.\.<.>.|
	Loop, Parse, #_Prefix_List_, .
	{
		If RegExMatch(#__SET__WEB_,StringToRegex(A_LoopField) . "(http:.*)",#_WEB_PREFIX_)
		{
			If RegExMatch(#_WEB_PREFIX_1,".http:")
				#_WEB_PREFIX_1:=RegExReplace(#_WEB_PREFIX_1,".http:.*")
		}
		LV_Add("", #_WEB_PREFIX_1,A_LoopField,asc(A_LoopField))
		#_WEB_PREFIX_1=
	}
	LV_ModifyCol(1,"SortDesc")
	LV_ModifyCol(1,350)
	LV_ModifyCol(2,"AutoHdr")
Gui, Tab, General
	Gui, font, bold
	Gui, Add, GroupBox,w156 h70 x370 y177 ,ToolTip
	Gui, Add, Checkbox, x380 y198 v#__SET__BALLOON_ gGuiSubmit, %#_SETTINGS_GUI_BALOON%
	If #__SET__BALLOON_
		Control, Check,,Button59,ahk_id %#__SETTINGS_HWND%
	Gui, Add, Checkbox, x380 y213 v#__SET__CLICKTROUGH_ gGuiSubmit, %#_SETTINGS_GUI_CLICKTROUGH%
	If #__SET__CLICKTROUGH_
		Control, Check,,Button60,ahk_id %#__SETTINGS_HWND%
	Gui, Add, Checkbox, x380 y228 v#__SET__STANDARD_TOOLTIP_ gGuiSubmit, %#_SETTINGS_GUI_STANDARDTOOLTIP%
	If #__SET__STANDARD_TOOLTIP_
		Control, Check,,Button61,ahk_id %#__SETTINGS_HWND%
	Gui, font, norm
Gui,Tab, Help
	Gui,Add, Text,x25 y57,Select Tutorial
	Gui,Add, ComboBox,x+5 w300 gTutorial v#_Tutorial,%#_SETTINGS_GUI_TUTORIAL%
Gui,Tab, Advanced
	Gui,Font,bold
	Gui,Add,GroupBox,x340 y37 w185 h40,AHK to EXE
	Gui,Add, Checkbox, x350 y57 gGuiSubMit v#__SET_RUN_AHK_AS_EXE_, %#_SETTINGS_GUI_RUNAHKASEXE%
	If #__SET_RUN_AHK_AS_EXE_
		Control, Check,,Button63,ahk_id %#__SETTINGS_HWND%
	Gui,Add,GroupBox,x340 y77 w185 h40,Suggest Web
	Gui,Add, Checkbox, x350 y97 gGuiSubMit v#__SET_SUGGEST_WEB_, %#_SETTINGS_GUI_WEBLOADANDSUGGEST%
	If #__SET_SUGGEST_WEB_
		Control, Check,,Button65,ahk_id %#__SETTINGS_HWND%
	Gui,Add,GroupBox, x340 y122 w185 h80,%#_SETTINGS_GUI_LANGUAGE%
	#__SET_GUI_LANGUAGE:=#__SET__LANGUAGE_="DE" ? "DE||EN" : "EN||DE"
	Gui,Add,DropDownList, x350 y142 gGuiSubMit v#__SET__LANGUAGE_,%#__SET_GUI_LANGUAGE%
	
	Gui,Add,GroupBox, x340 y207 w185 h40,%#_SETTINGS_GUI_FILEEXPLORER%
	Gui,Add, Checkbox, x350 y227 gGuiSubMit v#__SET__PRELOAD_FILEEXPLORER_,%#_SETTINGS_GUI_PIPEPRELOAD%
	If #__SET__PRELOAD_FILEEXPLORER_
		Control, Check,,Button68,ahk_id %#__SETTINGS_HWND%
	
	Gui,Add,GroupBox, x340 y247 w185 h40,%#_SETTINGS_GUI_STDOUTTOVAR%
	Gui,Add, Checkbox, x350 y267 gGuiSubMit v#__SET__PRELOAD_STDOUTTOVAR_,%#_SETTINGS_GUI_PIPEPRELOAD%
	If #__SET__PRELOAD_STDOUTTOVAR_
		Control, Check,,Button70,ahk_id %#__SETTINGS_HWND%
Gui,Tab,Hotkeys
	Gui, Add, GroupBox, x16 y37 w510 h310 , %#_SETTINGS_GUI_HOTKEYS%
	Gui, Add, ListView, x25 y57 w490 h280 -ReadOnly AltSubmit NoSortHdr gCheckHotkeys v#_Hotkeys, %#_SETTINGS_GUI_HOTKEYACTION%|%#_SETTINGS_GUI_HOTKEYS%
	Loop, Parse,#__SET__HOTKEYS_,%A_Tab%
		LV_Add("",A_LoopField,#_SETTINGS_GUI_HOTKEYACTION%A_Index%)
	LV_ModifyCol()
Gui,Tab, Advanced
	Gui,Add,GroupBox, x340 y287 w185 h40,%#_SETTINGS_GUI_AUTOUPDATE%
	Gui,Add, Checkbox, x350 y307 gGuiSubMit v#__SET__CHECKFORUPDATE_,%#_SETTINGS_GUI_CHECKFORUPDATE%
	If #__SET__CHECKFORUPDATE_=1
		Control, Check,,Button73,ahk_id %#__SETTINGS_HWND%
Gui, Tab, General
	Gui, font, bold
	Gui, Add, GroupBox,w156 h70 x370 y247, %#_SETTINGS_GUI_CHORDING%
	Gui, Add, Checkbox, x380 y265 v#__SET__USE_CHORDING_ gGuiSubmit, %#_SETTINGS_GUI_USECHORDING%
	If #__SET__USE_CHORDING_
		Control,Check,,Button75,ahk_id %#__SETTINGS_HWND%
	#_ChordingLength:="2|3|4|5"
	StringReplace,#_ChordingLength,#_ChordingLength,%#__SET__CHORDING_LENGTH_%|,%#__SET__CHORDING_LENGTH_%||
	Gui, Add, DropDownList, x380 y285 w40 h194 gGuiSubmit v#__SET__CHORDING_LENGTH_,%#_ChordingLength%
	Gui, Add, Text,x425 y287 gReturn,%#_SETTINGS_GUI_CHORDINGLENGTH%
	Gui, Add, GroupBox,x370 y317 w156 h40,%#_SETTINGS_GUI_KEYWORDENDCHAR%
	Gui, Add, Edit,x380 y332 w140 h20 v#__SET__KEYWORD_ENDCHAR_ gGuiSubmit,%#__SET__KEYWORD_ENDCHAR_%
	Gui, font, norm
Gui, Tab, Advanced
	#_SETTINGS_EXPLORER_SEARCH=
	Loop 3
		#_SETTINGS_EXPLORER_SEARCH.=A_Index-1 . "|" . (#__SET__EXPLORER_SEARCH_=A_Index-1 ? "|" : "")
	Gui, Add, DropDownList, x430 y222 w40 gGuiSubMit v#__SET__EXPLORER_SEARCH_, %#_SETTINGS_EXPLORER_SEARCH%
Gui, Tab
	Gui, Font, bold
	Gui, Add, Button, w300 xs y375 gSaveSettings Default, %#_SETTINGS_GUI_SAVESETTINGS%
	Gui, Add, Button, w229 x+1 y375 gRestoreSettings, %#_SETTINGS_GUI_RESETSETTINGS%
	Gui, Font, norm
Loop,Parse,#_TT_ALL,|
	ToolTip(9,#_TT_%A_LoopField%,"","D30 BFFFF32 F000000 V1 W1 P" . #__SETTINGS_HWND . " A" . A_LoopField)

Gui, Show,Hide h400 w545, AutoHotFile Settings
WinActivate,ahk_id %#__SETTINGS_HWND%
AnimateWindow(#__SETTINGS_HWND,300,"AB")
WinSet,Redraw,,ahk_id %#__SETTINGS_HWND%


#__RGB := HEX2RGB(#__SET__COLOR_T_)

StringSplit,_#__RGB, #__RGB, |
GuiControl, , RSlider_#, % _#__RGB1
GuiControl, , GSlider_#, % _#__RGB2
GuiControl, , BSlider_#, % _#__RGB3
Gui, Font, c%#__SET__COLOR_T_% norm
GuiControl, Font, SysListView3249

#__RGB := HEX2RGB(#__SET__COLOR_B_)
StringSplit,_#__RGB, #__RGB, |
GuiControl, , RSlider_#, % _#__RGB1
GuiControl, , GSlider_#, % _#__RGB2
GuiControl, , BSlider_#, % _#__RGB3
GuiControl, +Background%#__SET__COLOR_B_%, SysListView3249
Gui, Submit, NoHide
Gui, Show
Return

CheckHotkeys:
WinSet, Disable,,ahk_id %#__SETTINGS_HWND%
Gui,ListView, #_Hotkeys
Loop,Parse,#__SET__HOTKEYS_,%A_Tab%
{
	LV_GetText(#_TEMP_VAR_,A_Index,1)
	If (#_TEMP_VAR_!=A_LoopField)
	{
		#__SETTINGS_CHANGED_=1
		Hotkey,%#_TEMP_VAR_%,% #_HOTKEY_LABEL%A_Index%,UseErrorLevel
		If ErrorLevel
		{
			ToolTip(5,"This Hotkey cannot be used`nPrevious hotkey was restored","Invalid Hotkey: " #_TEMP_VAR_,"I3 L1 M1 BFF0000 D3")
			LV_Modify(A_Index,"",A_LoopField)
			Hotkey,%A_LoopField%,% #_HOTKEY_LABEL%A_Index%
		}
	}
}
WinSet, Enable,,ahk_id %#__SETTINGS_HWND%
Return

Tutorial:
Gui,Submit
#_TUTORIAL:="#__Help_MENU_" . RegExReplace(#_TUTORIAL,"\s","_")
#_help_hwnd := ToolTip(2,"Press a key to continue.","Welcome to AutoHotFile","x" . A_ScreenWidth . " y" . A_ScreenHeight . " I1 b0000FF fFFFFFF M1 o1")
WaitKey()
Loop,Parse,%#_TUTORIAL%,|
	If A_LoopField
		ToolTip(2,A_LoopField,"Welcome to AutoHotFile","x" . A_ScreenWidth . " y" . A_ScreenHeight), WaitKey()
ToolTip(2,"")
Gui,Show
Return

SubDirectory:
Gui,ListView, #__Directories
WinSet, Disable,,ahk_id %#__SETTINGS_HWND%
If (A_GuiEvent ="K" and A_EventInfo=46)
{
	DeleteCurrentRow()
	Return
}
#__next_checked =
#__NextRow=0
If (A_GuiEvent="C" or (A_GuiEvent="K" and A_EventInfo=32))
{
	Loop
	{
		If (#__NextRow := LV_GetNext(#__NextRow, "Checked"))
			#__next_checked .= "`n" . #__NextRow . "`n"
		else
			break
	}
	Loop % LV_GetCount()
	{
		LV_GetText(#__TEMP_VAR_,A_Index)
		If (RegExMatch(#__TEMP_VAR_, "\\\*") and !InStr(#__next_checked, "`n" . A_Index . "`n"))
		{
			StringReplace, #__TEMP_VAR_, #__TEMP_VAR_, \*, \
			LV_Modify(A_Index, "", #__TEMP_VAR_)
			#__SETTINGS_CHANGED_=2
		}
		else if (!RegExMatch(#__TEMP_VAR_, "\\\*") and InStr(#__next_checked, "`n" . A_Index . "`n"))
		{
			
			#__TEMP_VAR_ := SubStr(#__TEMP_VAR_, 1, InStr(#__TEMP_VAR_, "\",1,0)) . "*" . SubStr(#__TEMP_VAR_, InStr(#__TEMP_VAR_, "\",1,0)+1)
			LV_Modify(A_Index, "Check", #__TEMP_VAR_)
			#__SETTINGS_CHANGED_ = 2
		}
	}
}
else if (A_GuiEvent="E")
	#__SETTINGS_CHANGED_ = 2
else if (A_GuiEvent="Normal")
	#__SETTINGS_CHANGED_ = 2
WinSet, Enable,,ahk_id %#__SETTINGS_HWND%
Return
AddFavorite:
Gui, +OwnDialogs
InputBox, #_TEMP_VAR, Favorite, Enter new Favorite entry.,,250, 120
If (ErrorLevel or !#_TEMP_VAR)
	Return
#__SETTINGS_CHANGED_=1
Gui, ListView, #__Favorits
LV_Add("", #_Temp_var)
#__SET__FAVORITS_ .= "|" . #_Temp_var
Return

DeleteFavorite:
#__SETTINGS_CHANGED_=1
Gui, ListView, #__Favorits
#__Current_Row := LV_GetNext("Focused")
LV_GetText(#__TEMP_VAR_, #__Current_Row)
IfEqual, #__TEMP_VAR_, Favorits., Return
LV_Delete(#__Current_Row)
#__SET__FAVORITS_ := RegExReplace(#__SET__FAVORITS_, "\|?" . #__TEMP_VAR_)
Return

SaveSettings:
Gui, +OwnDialogs
Gui, Submit, NoHide
If #__SETTINGS_CHANGED_=2
	MsgBox, 262147, %#_SETTINGS_GUI_SAVEASKINFO%, %#_SETTINGS_GUI_SAVERELOADASK%
Else if #__SETTINGS_CHANGED_=1
	MsgBox, 262147, %#_SETTINGS_GUI_SAVEASKINFO%, %#_SETTINGS_GUI_SAVEASK%
IfMsgBox Cancel
	Exit
else IfMsgBox No
{
	Loop, Parse, #__SET__USER_VARIABLES_, |
		%A_LoopField% := Backup_%A_LoopField%
		OnMessage(0x200, "")
		OnMessage(0x20A, "")
		#__SETTINGS_CHANGED_=
		#__SETTINGS_HWND=
		Gui, 1:Destroy
}
else
{
	SplashTextOn, 250, 20, SAVING… PLEASE WAIT
	Gui,ListView,#__WebLauncher
	Loop % LV_GetCount()
	{
		LV_GetText(#__RetrievedText, A_Index,1)
		If #__RetrievedText=
			Continue
		LV_GetText(#__RetrievedText2, A_Index,2)
		#__SET__WEB_ .= #__RetrievedText2 . #__RetrievedText
	}
	#__ListViews = #__Directories|#__Extensions|#__Profiles|#__Favorits|#_HOTKEYS
	Loop, parse, #__ListViews, |
	{
		Gui, ListView, %A_LoopField%
		#_TEMP_VAR_ =
		Loop % LV_GetCount()
		{
			LV_GetText(#__RetrievedText, A_Index)
			If #__RetrievedText
				#_TEMP_VAR_ .= (#_TEMP_VAR_ ? "|" : "") . #__RetrievedText
		}
		If A_LoopField = #__Directories
			#__SET__DIRECTORIES_ = %#_TEMP_VAR_%
		else if A_LoopField = #__Extensions
			#__SET__GLOBAL_EXT_ = %#_TEMP_VAR_%
		else if A_LoopField = #__Profiles
			#__SET__PROFILES_ = %#_TEMP_VAR_%
		else if A_LoopField = #__Favorits
		{
			StringReplace, #__SET__FAVORITS_, #__SET__FAVORITS_, ||, |, A
			#__SET__FAVORITS_ := RegExReplace(#__SET__FAVORITS_, "\|$")
			#__SET__FAVORITS_ := RegExReplace(#__SET__FAVORITS_, "^\|")
			StringReplace, #__SET__FAVORITS_, #__SET__FAVORITS_, `%,% "``" . "`%", A
			StringReplace, #__SET__FAVORITS_, #__SET__FAVORITS_, `n,% "``" . "n", A
			StringReplace, #__SET__FAVORITS_, #__SET__FAVORITS_, `",% "``""", A
			StringReplace, #__SET__FAVORITS_, #__SET__FAVORITS_, ````,% "``", A
			#__SET__FAVORITS_ = %#_TEMP_VAR_%
		}
		else if A_LoopField=#_Hotkeys
		{
			Loop,Parse,#__SET__HOTKEYS_,%A_Tab%
			{
				If A_Index=1
					#__SET__HOTKEYS_=
				LV_GetText(#_TEMP_VAR,A_Index,1)
				#__SET__HOTKEYS_.= (A_Index=1 ? "" : A_Tab) . #_TEMP_VAR
			}
		}
	}
	Loop, Parse, #__SET__USER_VARIABLES_, |
	{
		#__TEMP_VAR_ := %A_LoopField%
		IniWrite, %#__TEMP_VAR_%, %#__INI_FILE_%, CONFIG, %A_LoopField%
	}
	SplashTextOff
	If #__SETTINGS_CHANGED_=2
		Reload
	else
	{
;~ 		OnMessage(0x200, "")
;~ 		OnMessage(0x20A, "")
		#__SETTINGS_CHANGED_=
		#__SETTINGS_HWND=
		Gui, 1:Destroy
		If ((!WinExist("ahk_pid " . #__HSS_PID_) and #__SET__AUTOHOTSTRING_="ON") or #__SET__HOTSTRING_RUN_!=Backup_#__SET__HOTSTRING_RUN_ or #__SET__HOTSTRING_EDIT_!=Backup_#__SET__HOTSTRING_EDIT_ or #__SET__HOTSTRING_SHOW_!=Backup_#__SET__HOTSTRING_SHOW_ or #__SET__HOTSTRING_COPY_PATH_!=Backup_#__SET__HOTSTRING_COPY_PATH_ or #__SET__HOTSTRING_COPY_DIR_!=Backup_#__SET__HOTSTRING_COPY_DIR_ or #__SET__HOTSTRING_MAX_!=Backup_#__SET__HOTSTRING_MAX_ or #__SET__HOTSTRING_END_CHAR_!=Backup_#__SET__HOTSTRING_END_CHAR_ or #__SET__WARN_ON_AUTOHOTSTRING_!=Backup_#__SET__WARN_ON_AUTOHOTSTRING_ or #__SET__USE_CHORDING_!=Backup_#__SET__USE_CHORDING_ or Backup_#__SET__CHORDING_LENGTH_!=#__SET__CHORDING_LENGTH_ or Backup_#__SET__AUTOHOTSTRING_!=#__SET__AUTOHOTSTRING_)
			Gosub, #__CREATE_HOTSTRINGS_
		else if (#__HSS_PID_ and WinGetClass(#__HSS_PID_)="AutoHotkey" and #__SET__AUTOHOTSTRING_="OFF")
			Process,Close,%#__HSS_PID_%
		If (#__SET__PRELOAD_FILEEXPLORER_ and !Backup_#__SET__PRELOAD_FILEEXPLORER_)
			#__FILE_EXPLORER_PID:=ShowExplorer_PIPE(#__START_UP_,"AutoHotFile_FE",1)
		else If (!#__SET__PRELOAD_FILEEXPLORER_ and Backup_#__SET__PRELOAD_FILEEXPLORER_)
			Process,Close,%#__FILE_EXPLORER_PID%
		If (#__SET__PRELOAD_STDOUTTOVAR_ and !Backup_#__SET__PRELOAD_STDOUTTOVAR_)
			#__StdoutToVar_PID:=#__RUN_STDOUTTOVAR_PIPE(#__START_UP_,"AutoHotFile_CMD",1)
		else If (!#__SET__PRELOAD_STDOUTTOVAR_ and Backup_#__SET__PRELOAD_STDOUTTOVAR_)
			Process,Close,%#__StdoutToVar_PID%
		ToolTip(5)
		Gosub, CreateToolTip
		Hide(0)
	}
}
Return

RestoreSettings:
MsgBox,262148,%#_SETTINGS_GUI_RESETASKINFO%,%#_SETTINGS_GUI_RESETASK%
Loop,Parse,#__SET__USER_VARIABLES_,
	IniDelete,%#__INI_FILE_%,CONFIG,%A_LoopField%
Gosub, #__RELOAD
Return

AddProfile:
Gui, +OwnDialogs
InputBox	#__TEMP_VAR_, NEW PROFILE, Enter a name for new profile`nONLY LETTERS`, NUMBERS and _ ARE ALLOWED,,300, 140
If ErrorLevel
	Return
#__SETTINGS_CHANGED_=2
If !RegExMatch(#__TEMP_VAR_, "^\w+$")
{
	MsgBox, ONLY LETTERS`, NUMBERS and _ ARE ALLOWED
	Return
}
Loop, Parse, #__SET__PROFILES_, |
{
	If !(#__TEMP_VAR_ = A_LoopField)
		continue
	MsgBox, Profile already Exist
	Return
}
#__SET__PROFILES_ .= "|" . #__TEMP_VAR_
Gui, ListView, #__Profiles
LV_Add("", #__TEMP_VAR_)
IniWrite,% "", %#__INI_FILE_%, CONFIG,% "#__SET__PROFILES_" . #__TEMP_VAR_ . "_"
Return

DeleteProfile:
#__SETTINGS_CHANGED_=2
Gui, +OwnDialogs
Gui, ListView, #__Profiles
#__Current_Row := LV_GetNext("Focused")
LV_GetText(#__TEMP_VAR_, #__Current_Row)
IfEqual, #__TEMP_VAR_, Profiles., Return
If #__Current_Row = 1
{
	WinSet, Disable, , ahk_id %#__SETTINGS_HWND%
	LV_GetText(#__TEMP_VAR_, 2)
	Gui, ListView, #__Directories
	LV_Delete()
	MsgBox % #__SET__DIRECTORIES_%#__TEMP_VAR_%_
	IniRead, #__SET__DIRECTORIES_, %#__INI_FILE_%,CONFIG, #__SET__DIRECTORIES_%#__TEMP_VAR_%_,%A_Space%
	MsgBox % #__SET__DIRECTORIES_
	Loop, parse, #__SET__DIRECTORIES_, |
		LV_Add(RegExMatch(A_LoopField, "\*[^\\]*$") ? "Check" : "", A_LoopField)
	WinSet, Enable, , ahk_id %#__SETTINGS_HWND%
}
Gui, ListView, #__Profiles
LV_GetText(#__TEMP_VAR_, #__Current_Row)
If LV_GetCount() = 1
{
	MsgBox, 262144, DELETE PROFILE, You cannot delete last profile`nYou will need to create a new profile first.
	Return
}
IniDelete, %#__INI_FILE_%,CONFIG,% "#__SET__PROFILES_" . #__TEMP_VAR_ . "_"
#__SET__PROFILES_ := RegExReplace(#__SET__PROFILES_, "\|?" . #__TEMP_VAR_)
LV_Delete(#__Current_Row)
Return


SelectProfile:
Gui, ListView, #__Profiles
If (A_GuiEvent != "DoubleClick")
Return
WinSet, Disable, , ahk_id %#__SETTINGS_HWND%
#__SETTINGS_CHANGED_=2
LV_GetText(#__SET__NEW_PROFILES_, A_EventInfo)
LV_Delete()
LV_Add("",#__SET__NEW_PROFILES_)
#__CURRENT_PROFILE = %#__SET__NEW_PROFILES_%
Loop, Parse, #__SET__PROFILES_, |
{
	If (#__CURRENT_PROFILE = A_LoopField)
		Continue
	LV_Add("", A_LoopField)
	#__SET__NEW_PROFILES_ .= "|" . A_LoopField
}
IniWrite, %#__SET__DIRECTORIES_%, %#__INI_FILE_%, CONFIG,% "#__SET__PROFILES_" . RegExReplace(#__SET__PROFILES_, "\|.*") . "_"
#__SET__PROFILES_ = %#__SET__NEW_PROFILES_%
IniRead, #__SET__DIRECTORIES_, %#__INI_FILE_%, CONFIG, % "#__SET__PROFILES_" . #__CURRENT_PROFILE . "_",%A_Space%
Gui, ListView, #__Directories
LV_Delete()
Loop, parse, #__SET__DIRECTORIES_, |
	LV_Add(RegExMatch(A_LoopField, "\*[^\\]*$") ? "Check" : "", A_LoopField)
WinSet, Enable, , ahk_id %#__SETTINGS_HWND%
Return

AddExtensions:
Gui, +OwnDialogs
InputBox, #__NEW_PATH_, NEW EXTENSION, ENTER NEW EXTENSION`nYOU CAN ADD SEVERAL BY TYPING exe|lnk|pdf…,,400, 140
If ErrorLevel = 1
	Return
Gui, ListView, #__Extensions
#__SETTINGS_CHANGED_=2
#__SET__GLOBAL_EXT_ .= "|" . #__NEW_PATH_
Loop, Parse, #__NEW_PATH_, |
LV_Add("", A_LoopField)
Return

DeleteExtensions:
Gui, ListView, #__Extensions
#__SETTINGS_CHANGED_=2
DeleteCurrentRow()
Return

DeleteCurrentRow(){
#__Current_Row := LV_GetNext("Focused")
LV_GetText(#__CURRENT_PATH_, #__Current_Row)
LV_Delete(#__Current_Row)
}

AddDirectory:
Gui, +OwnDialogs
FileSelectFolder, #__SET__DIRECTORIES_TO_LOAD_1, , 2, SELECT A DIRECTORY TO ADD
If ErrorLevel = 1
	Return
#__SETTINGS_CHANGED_=2
InputBox, #__SPECIAL_EXTENSIONS_, File Pattern, ENTER ANY FILE PATTERNS (/ in front of each pattern is mandatory)`nLEAVE EMPTY TO APPLY GLOBAL EXTENSIONS,,450,140,,,,,/*.exe/*.ahk
If Errorlevel
	#__SPECIAL_EXTENSIONS_ =
MsgBox, 262148, Include Subfolders?,Would you like to search in subfolders
IfMsgBox Yes
	#__SET__DIRECTORIES_TO_LOAD_1 .= (SubStr(#__SET__DIRECTORIES_TO_LOAD_1, 0) = "\" ? "*" : "\*") . #__SPECIAL_EXTENSIONS_
Else
	#__SET__DIRECTORIES_TO_LOAD_1 .= (SubStr(#__SET__DIRECTORIES_TO_LOAD_1, 0) = "\" ? "" : "\") . #__SPECIAL_EXTENSIONS_
IniRead, #__SET__DIRECTORIES_, %#__INI_FILE_%, CONFIG, #__SET__DIRECTORIES_,%A_Space%
If (#__SET__DIRECTORIES_ != "")
	#__SET__DIRECTORIES_ .= "|" . #__SET__DIRECTORIES_TO_LOAD_1
else
	#__SET__DIRECTORIES_ .= #__SET__DIRECTORIES_TO_LOAD_1
Gui, ListView, #__Directories
IfMsgBox Yes
	LV_Add("Check", #__SET__DIRECTORIES_TO_LOAD_1)
else
	LV_Add("", #__SET__DIRECTORIES_TO_LOAD_1)
Return

DeleteAllDirectories:
#__SETTINGS_CHANGED_=2
Gui, +OwnDialogs
Gui, ListView, #__Directories
LV_Delete()
Return

DeleteDirectory:
#__SETTINGS_CHANGED_=2
Gui, +OwnDialogs
Gui, ListView, #__Directories
DeleteCurrentRow()
Return

GuiEscape:
GuiClose:
If #__SETTINGS_CHANGED_
	Gosub, SaveSettings
else
	Loop, Parse, #__SET__USER_VARIABLES_, |
		%A_LoopField% := Backup_%A_LoopField%
ToolTip(9)
#__SETTINGS_CHANGED_=
#__SETTINGS_HWND=
Gui, 1:Destroy
Return

GuiSubmit:
Gui, Submit, NoHide
MouseGetPos,,,#_TEMP_VAR
If (#_TEMP_VAR = #__SETTINGS_HWND)
{
	If A_GuiControl=#__SET__LANGUAGE_
		#__SETTINGS_CHANGED_=2
	else
		#__SETTINGS_CHANGED_=1
}
Return





#__SET__AUTOSTART____________ON:
#__SET__AUTOSTART____________OFF:
#__SET__AUTOSTART____________ASK:
#__SET__FILE_REMINDER________ON:
#__SET__FILE_REMINDER________OFF:
#__SET__RELOAD_AHK_ON_CHANGE_ON:
#__SET__RELOAD_AHK_ON_CHANGE_OFF:
#__SET__RELOAD_AHK_ON_CHANGE_KILL:
#_XPOS___________:
#_YPOS___________:
#__SET__POSITION_____________Caret:
#__SET__AUTOHOTSTRING________ON:
#__SET__AUTOHOTSTRING________OFF:
#__SET__WILDCARD_____________\w*:
#__SET__WILDCARD_____________:
#__SET__USECAPSLOCK__________OFF:
#__SET__USECAPSLOCK__________ON:
#__SETTINGS_CHANGED_=1
#__VARIABLE := SubStr(A_ThisLabel,1,29)
#__VARIABLE := RegExReplace(#__VARIABLE, "_\K_*$")
%#__VARIABLE% := SubStr(A_ThisLabel, 30)
Hotkey, ~CapsLock, CapsLock, % #__SET__USECAPSLOCK_ = "On" ? "Off" : "On"
Return
WebBrowser:
#__SETTINGS_CHANGED_=1
FileSelectFile, new_#__SET__WEBBROWSER_, 2,%A_ProgramFiles%\, Select your default Webbrowser, *.exe
If (FileExist(new_#__SET__WEBBROWSER_)= "")
	ToolTip(9, new_#__SET__WEBBROWSER_, "Error opening file","I3 D2 " . #__ToolTip_Options),Exit()
else
	#__SET__WEBBROWSER_ = %new_#__SET__WEBBROWSER_%
ControlSetText	Edit1, %#__SET__WEBBROWSER_%, ahk_id %#__SETTINGS_HWND%
Return
Editor:
#__SETTINGS_CHANGED_=1
FileSelectFile, new_#__SET__EDITOR_ , 2,%A_ProgramFiles%\, Select your default Editor, *.exe
If (FileExist(new_#__SET__EDITOR_ )= "")
	ToolTip(9, new_#__SET__EDITOR_, "Error opening file","I3 D2 " . #__ToolTip_Options),Exit()
else
	#__SET__EDITOR_ = %new_#__SET__EDITOR_%
	ControlSetText	Edit2, %#__SET__EDITOR_%, ahk_id %#__SETTINGS_HWND%
Return




















	














;*************************************************************************************************
;*                                   Color Picker by SKAN                                        *
;*************************************************************************************************
SelColor:
CoordMode, Mouse, Relative
If A_GuiEvent=Normal
   {
    MouseGetPos,#__X,#__Y
    PixelGetColor,#__CurrentColor,%#__X%,%#__Y%,RGB
    StringRight,#__CurrentColor,#__CurrentColor,6

    #__RGB := HEX2RGB(#__CurrentColor)
    StringSplit,_#__RGB, #__RGB, |

    GuiControl, , RSlider_#, % _#__RGB1
    GuiControl, , GSlider_#, % _#__RGB2
    GuiControl, , BSlider_#, % _#__RGB3
	
    GoSub, UpdateSlider

   }
CoordMode, Mouse, Screen
   Return

   
;--------------------------------------------------------------------------------------------

UpdateSlider:

	Gui, 1:Submit, Nohide

	#__RGB1 = %RSlider_#%
	#__RGB2 = %GSlider_#%
	#__RGB3 = %BSlider_#%
	
	#__RGBString = % #__RGB1 "|" #__RGB2 "|" #__RGB3
	
	#__COLORR := RGB2HEX(#__RGBString)
	
	If #__ChooseColor = 1
	{
		GuiControl, +Background%#__COLORR%, SysListView3249
		#__SET__COLOR_B_ = %#__COLORR%
	}
	else
	{
		Gui, Font, c%#__COLORR% norm
		GuiControl, Font, SysListView3249
		#__SET__COLOR_T_ = %#__COLORR%
	}

Return 

;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - RGB & HEX Functions

HEX2RGB(HEXString,Delimiter="|")
{

 If StrLen(HEXString) > 6
 StringRight, HEXString, HEXString, 6
 StringMid,R,HexString,1,2
 StringMid,G,HexString,3,2
 StringMid,B,HexString,5,2
 
 R = % "0x"R 
 G = % "0x"G
 B = % "0x"B
 R+=0
 G+=0
 B+=0
 RGBString = % R Delimiter G Delimiter B
Return RGBString
}


RGB2HEX(#__RGBString) 
{ 
 
 StringSplit,#_RGB,#__RGBString,|
 
 SetFormat, Integer, Hex 
 #_RGB1+=0
 #_RGB2+=0
 #_RGB3+=0

 If StrLen(#_RGB1) = 3
    #_RGB1= 0%#_RGB1%

 If StrLen(#_RGB2) = 3
    #_RGB2= 0%#_RGB2%

 If StrLen(#_RGB3) = 3
    #_RGB3= 0%#_RGB3%

 SetFormat, Integer, D 
 HEXString = % #_RGB1 . #_RGB2 . #_RGB3

 StringReplace, HEXString, HEXString,0x,,All
 StringUpper, HEXString, HEXString

Return, HEXString
} 

;==================== END: #Include .\include\_SETTINGS_# :B1AD529B-BF4E-477F-8B9F-3080CAC55AE3

;==================== START: #Include .\include\_Get_Text_From_Edit_# :B1AD529B-BF4E-477F-8B9F-3080CAC55AE3
Sci_GetText(hSci) {
    
    ;Used constants
    static SCI_GETLENGTH := 2006, SCI_GETTEXT := 2182

    ;Retrieve text length
    SendMessage SCI_GETLENGTH, 0, 0,, ahk_id %hSci%
    iLength = %ErrorLevel%
    
    ;Open remote buffer (add 1 for 0 at the end of the string)
    RemoteBuf_Open(hBuf, hSci, iLength + 1)
    
    ;Fill buffer with text
    SendMessage SCI_GETTEXT, iLength + 1, RemoteBuf_Get(hBuf),, ahk_id %hSci%
    
    ;Read buffer
    VarSetCapacity(sText, iLength)
    RemoteBuf_Read(hBuf, sText, iLength + 1)
    
    ;We're done with the remote buffer
    RemoteBuf_Close(hBuf)

    Return sText
}

HE_GetText(hEdit){
	static min=0,max=-1,EM_GETTEXTRANGE=1099, WM_GETTEXTLENGTH=14
	
	SendMessage, WM_GETTEXTLENGTH, 0, 0,, ahk_id %hEdit% 
	iLength = %ErrorLevel%

	VarSetCapacity(buf, iLength-min+2)													
	VarSetCapacity(RNG, 12), NumPut(min, RNG), NumPut(iLength, RNG, 4), NumPut(&buf, RNG, 8)													
	SendMessage, EM_GETTEXTRANGE, 0, &RNG,, ahk_id %hEdit%													
	VarSetCapacity(buf, -1)													
	Return buf													
}

;==================== END: #Include .\include\_Get_Text_From_Edit_# :B1AD529B-BF4E-477F-8B9F-3080CAC55AE3

;==================== START: #Include _Includes_# :B1AD529B-BF4E-477F-8B9F-3080CAC55AE3
IncludesScript:
If 0
	Return
RemoteBuf_Open(ByRef H, hwnd, size) {
	static MEM_COMMIT=0x1000, PAGE_READWRITE=4

	WinGet, pid, PID, ahk_id %hwnd%
	hProc   := DllCall( "OpenProcess", "uint", 0x38, "int", 0, "uint", pid)
	IfEqual, hProc,0, return A_ThisFunc ">   Unable to open process (" A_LastError ")"
      
	bufAdr  := DllCall( "VirtualAllocEx", "uint", hProc, "uint", 0, "uint", size, "uint", MEM_COMMIT, "uint", PAGE_READWRITE)
	IfEqual, bufAdr,0, return A_ThisFunc ">   Unable to allocate memory (" A_LastError ")"
	VarSetCapacity(H, 12, 0 )
	NumPut( hProc,	H, 0) 
	NumPut( size,	H, 4)
	NumPut( bufAdr, H, 8)
}

RemoteBuf_Close(ByRef H) {
	static MEM_RELEASE = 0x8000
	
	handle := NumGet(H, 0)
	IfEqual, handle, 0, return A_ThisFunc ">   Invalid remote buffer handle"
	adr    := NumGet(H, 8)

	r := DllCall( "VirtualFreeEx", "uint", handle, "uint", adr, "uint", 0, "uint", MEM_RELEASE)
	ifEqual, r, 0, return A_ThisFunc ">   Unable to free memory (" A_LastError ")"
	DllCall( "CloseHandle", "uint", handle )
	VarSetCapacity(H, 0 )
}


RemoteBuf_Read(ByRef H, ByRef pLocal, pSize, pOffset = 0){
	handle := NumGet( H, 0),   size:= NumGet( H, 4),   adr := NumGet( H, 8)
	IfEqual, handle, 0, return A_ThisFunc ">   Invalid remote buffer handle"	
	IfGreaterOrEqual, offset, %size%, return A_ThisFunc ">   Offset is bigger then size"

	VarSetCapacity( pLocal, pSize )
	return DllCall( "ReadProcessMemory", "uint", handle, "uint", adr + pOffset, "uint", &pLocal, "uint", size, "uint", 0 ), VarSetCapacity(pLocal, -1)
}


RemoteBuf_Write(Byref H, byref pLocal, pSize, pOffset=0) {
	handle:= NumGet( H, 0),   size := NumGet( H, 4),   adr := NumGet( H, 8)
	IfEqual, handle, 0, return A_ThisFunc ">   Invalid remote buffer handle"	
	IfGreaterOrEqual, offset, %size%, return A_ThisFunc ">   Offset is bigger then size"

	return DllCall( "WriteProcessMemory", "uint", handle,"uint", adr + pOffset,"uint", &pLocal,"uint", pSize, "uint", 0 )
}

RemoteBuf_Get(ByRef H, pQ="adr") {
	return pQ = "adr" ? NumGet(H, 8) : pQ = "size" ? NumGet(H, 4) : NumGet(H)
}

InfoOpening(text){
	If DBArray("files","exist",text)
		ToolTip(5,text:=DBArray("files","get",text),"Opening, please wait…","GTTM_TRACKPOSITION.TTM_TRACKACTIVATE L1 I" . GetAssociatedIcon(text) . " x" . #_XPOS_ . " y" . #_YPOS_)
	else
		ToolTip(5,text,"Opening, please wait…","GTTM_TRACKPOSITION.TTM_TRACKACTIVATE L1 I" . #_hIcon_3 . " x" . #_XPOS_ . " y" . #_YPOS_)
}

ToolTip(ID="", text="", title="",options=""){
	;____  Assume Static Mode for internal variables and structures  ____
	
	static
	global #__MAIN_PID_
	;________________________  ToolTip Messages  ________________________
	
	Static TTM_POPUP:=0x422,   		TTM_ADDTOOL:=0x404,     	TTM_UPDATETIPTEXT:=0x40c
	,TTM_POP:=0x41C,     		TTM_DELTOOL:=0x405,     	TTM_GETBUBBLESIZE:=0x41e
	,TTM_UPDATE:=0x41D,  		TTM_SETTOOLINFO:=0x409,		TTN_FIRST:=0xfffffdf8
	,TTM_TRACKPOSITION:=0x412, 	TTM_SETTIPBKCOLOR:=0x413,	TTM_SETTIPTEXTCOLOR:=0x414
	,TTM_SETTITLEA:=0x420,		TTM_SETTITLEW:=0x421,		TTM_SETMARGIN:=0x41a
	,TTM_SETWINDOWTHEME:=0x200b,	TTM_SETMAXTIPWIDTH:=0x418
	
	;_______________Remote Buffer Messages for TrayIcon pos______________
	
	;MEM_COMMIT:=0x1000, 		PAGE_READWRITE:=4, 			MEM_RELEASE:=0x8000
	
	;________________________  ToolTip colors  ________________________
	
	,Black:=0x000000,    Green:=0x008000,		Silver:=0xC0C0C0
	,Lime:=0x00FF00,		Gray:=0x808080,    		Olive:=0x808000
	,White:=0xFFFFFF,    Yellow:=0xFFFF00,		Maroon:=0x800000
    ,Navy:=0x000080,		Red:=0xFF0000,    		Blue:=0x0000FF
	,Purple:=0x800080,   Teal:=0x008080,			Fuchsia:=0xFF00FF
    ,Aqua:=0x00FFFF

	;________________________  Local variables for options ________________________
	
	local option,a,b,c,d,e,f,g,h,i,k,l,m,n,o,p,q,r,s,t,v,w,x,y,xc,yc,xw,yw,update,RECT

	If ((#_DetectHiddenWindows:=A_DetectHiddenWindows)="Off")
		DetectHiddenWindows, On
	
	;____________________________  Delete all ToolTips or return link _____________

	If !ID
	{
		If text
			If text is Xdigit
				GoTo, TTN_LINKCLICK
		Loop, Parse, hWndArray, % Chr(2) ;Destroy all ToolTip Windows
		{
			If WinExist("ahk_id " . A_LoopField)
				DllCall("DestroyWindow","Uint",A_LoopField)
			hWndArray%A_LoopField%=
		}
		hWndArray=
		Loop, Parse, idArray, % Chr(2) ;Destroy all ToolTip Structures
		{
			TT_ID:=A_LoopField
			If TT_ALL_%TT_ID%
				Gosub, TT_DESTROY
		}
		idArray=
		DetectHiddenWindows,%#_DetectHiddenWindows%
		Return
	}
	
	TT_ID:=ID
	TT_HWND:=TT_HWND_%TT_ID%
	
	;___________________  Load Options Variables and Structures ___________________
	
	If (options){
		Loop,Parse,options,%A_Space%
			If (option:= SubStr(A_LoopField,1,1))
				%option%:= SubStr(A_LoopField,2)
	}
	If (G){
		If (Title!=""){
			Gosub, TTM_SETTITLEA
			Gosub, TTM_UPDATE
		}
		If (Text!=""){
			If (InStr(text,"<a") and L){
				TOOLTEXT_%TT_ID%:=text
				text:=RegExReplace(text,"<a\K[^<]*?>",">")
			} else
				TOOLTEXT_%TT_ID%:=
			NumPut(&text,TOOLINFO_%TT_ID%,36)
			Gosub, TTM_UPDATETIPTEXT
		}
		Loop, Parse,G,.
			If IsLabel(A_LoopField)
				Gosub, %A_LoopField%
		DetectHiddenWindows,%#_DetectHiddenWindows%
		Return
	}
	;__________________________  Save TOOLINFO Structures _________________________
	
	If P {
		If (p<100 and !WinExist("ahk_id " p)){
			Gui,%p%:+LastFound
			P:=WinExist()
		}
		If !InStr(TT_ALL_%TT_ID%,Chr(2) . Abs(P) . Chr(2))
			TT_ALL_%TT_ID% .= Chr(2) . Abs(P) . Chr(2)
	} 
	If !InStr(TT_ALL_%TT_ID%,Chr(2) . ID . Chr(2))
		TT_ALL_%TT_ID% .= Chr(2) . ID . Chr(2)
	If H
		TT_HIDE_%TT_ID%:=1
	;__________________________  Create ToolTip Window  __________________________
	
	If (!TT_HWND and text)
	{
		TT_HWND := DllCall("CreateWindowEx", "Uint", 0x8, "str", "tooltips_class32", "str", "", "Uint", 0x02 + (v ? 0x1 : 0) + (l ? 0x100 : 0) + (C ? 0x80 : 0)+(O ? 0x40 : 0), "int", 0x80000000, "int", 0x80000000, "int", 0x80000000, "int", 0x80000000, "Uint", P ? P : 0, "Uint", 0, "Uint", 0, "Uint", 0)
		TT_HWND_%TT_ID%:=TT_HWND
		hWndArray.=(hWndArray ? Chr(2) : "") . TT_HWND
		idArray.=(idArray ? Chr(2) : "") . TT_ID
		Gosub, TTM_SETMAXTIPWIDTH
		DllCall("SendMessage", "Uint", TT_HWND, "Uint", 0x403, "Uint", 2, "Uint", (D ? D*1000 : -1)) ;TTDT_AUTOPOP
		DllCall("SendMessage", "Uint", TT_HWND, "Uint", 0x403, "Uint", 3, "Uint", (W ? W*1000 : -1)) ;TTDT_INITIAL
		DllCall("SendMessage", "Uint", TT_HWND, "Uint", 0x403, "Uint", 1, "Uint", (W ? W*1000 : -1)) ;TTDT_RESHOW
	} else if (!text and !options){
		DllCall("DestroyWindow","Uint",TT_HWND)
		TT_HWND_%TT_ID%=
		Gosub, TT_DESTROY
		DetectHiddenWindows,%#_DetectHiddenWindows%
		Return
	}
	
	;______________________  Create TOOLINFO Structure  ______________________
	
	Gosub, TT_SETTOOLINFO

	If (Q!="")
		Gosub, TTM_SETWINDOWTHEME
	If (E!="")
		Gosub, TTM_SETMARGIN
	If (F!="")
		Gosub, TTM_SETTIPTEXTCOLOR
	If (B!="")
		Gosub, TTM_SETTIPBKCOLOR
	If (title!="")
		Gosub, TTM_SETTITLEA
	
	If (!A){
		Gosub, TTM_UPDATETIPTEXT
		Gosub, TTM_UPDATE
		If D {
			A_Timer := A_TickCount, D *= 1000
			Gosub, TTM_TRACKPOSITION
			Gosub, TTM_TRACKACTIVATE
			Loop
			{
				Gosub, TTM_TRACKPOSITION
				If (A_TickCount - A_Timer > D)
					Break
			}
			Gosub, TT_DESTROY
			DllCall("DestroyWindow","Uint",TT_HWND)
			TT_HWND_%TT_ID%=
		} else {
			Gosub, TTM_TRACKPOSITION
			Gosub, TTM_TRACKACTIVATE
			If T
				WinSet,Transparent,%T%,ahk_id %TT_HWND%
			If M
				WinSet,ExStyle,^0x20,ahk_id %TT_HWND%
		}
	}

	;________  Restore DetectHiddenWindows and return HWND of ToolTip  ________

	DetectHiddenWindows, %#_DetectHiddenWindows%
	Return TT_HWND
	
	;________________________  Internal Labels  ________________________
	
	TTM_POP: 	;Hide ToolTip
	TTM_POPUP: 	;Causes the ToolTip to display at the coordinates of the last mouse message.
	TTM_UPDATE: ;Forces the current tool to be redrawn.
		DllCall("SendMessage", "Uint", TT_HWND, "Uint", %A_ThisLabel%, "Uint", 0, "Uint", 0)
	Return
	TTM_TRACKACTIVATE: ;Activates or deactivates a tracking ToolTip.
	DllCall("SendMessage", "Uint", TT_HWND, "Uint", 0x411, "Uint", (N ? 0 : 1), "Uint", &TOOLINFO_%ID%)
	Return
	TTM_UPDATETIPTEXT:
	TTM_GETBUBBLESIZE:
	TTM_ADDTOOL:
	TTM_DELTOOL:
	TTM_SETTOOLINFO:
		DllCall("SendMessage", "Uint", TT_HWND, "Uint", %A_ThisLabel%, "Uint", 0, "Uint", &TOOLINFO_%ID%)
	Return
	TTM_SETTITLEA:
	TTM_SETTITLEW:
		title := (StrLen(title) < 96) ? title : ("…" . SubStr(title, -97))
		DllCall("SendMessage", "Uint", TT_HWND, "Uint", %A_ThisLabel%, "Uint", I, "Uint", &Title)
	Return
	TTM_SETWINDOWTHEME:
		If Q
			DllCall("uxtheme\SetWindowTheme", "Uint", TT_HWND, "Uint", 0, "UintP", 0)
		else
			DllCall("SendMessage", "Uint", TT_HWND, "Uint", %A_ThisLabel%, "Uint", 0, "Uint", &K)
	Return
	TTM_SETMAXTIPWIDTH:
		DllCall("SendMessage", "Uint", TT_HWND, "Uint", %A_ThisLabel%, "Uint", 0, "Uint", R ? R : A_ScreenWidth)
	Return
	TTM_TRACKPOSITION:
		VarSetCapacity(xc, 20, 0), xc := Chr(20)
		DllCall("GetCursorInfo", "Uint", &xc)
		yc := NumGet(xc,16), xc := NumGet(xc,12)
		xc+=15,yc+=15
		If (x="caret" or y="caret"){
			WinGetPos,xw,yw,,,A
			If x=caret
			{
				SysGet,xl,76
				SysGet,xr,78
				xc:=xw+A_CaretX +1
				xc:=(xl>xc ? xl : (xr<xc ? xr : xc))
			}
			If (y="caret"){
				SysGet,yl,77
				SysGet,yr,79
				yc:=yw+A_CaretY+15
				yc:=(yl>yc ? yl : (yr<yc ? yr : yc))
			}
	} else if (x="TrayIcon" or y="TrayIcon"){
			Process, Exist
			PID:=ErrorLevel
			hWndTray:=WinExist("ahk_class Shell_TrayWnd")
			ControlGet,hWndToolBar,Hwnd,,ToolbarWindow321,ahk_id %hWndTray%
			RemoteBuf_Open(TrayH,hWndToolBar,20)
			DataH:=NumGet(TrayH,0)
			SendMessage, 0x418,0,0,,ahk_id %hWndToolBar%
			Loop % ErrorLevel
			{
				SendMessage,0x417,A_Index-1,RemoteBuf_Get(TrayH),,ahk_id %hWndToolBar%
				RemoteBuf_Read(TrayH,lpData,20)
				VarSetCapacity(dwExtraData,8)
				pwData:=NumGet(lpData,12)
				DllCall( "ReadProcessMemory", "uint", DataH, "uint", pwData, "uint", &dwExtraData, "uint", 8, "uint", 0 )
				BWID:=NumGet(dwExtraData,0)
				WinGet,BWPID,PID, ahk_id %BWID%
				If (BWPID!=PID and BWPID!=#__MAIN_PID_)
					continue
				SendMessage, 0x41d,A_Index-1,RemoteBuf_Get(TrayH),,ahk_id %hWndToolBar%
				RemoteBuf_Read(TrayH,rcPosition,20)
				If (NumGet(lpData,8)>7){
					ControlGetPos,xc,yc,xw,yw,Button2,ahk_id %hWndTray%
					xc+=xw/2
					yc+=yw/4
				} else {
					ControlGetPos,xc,yc,,,ToolbarWindow321,ahk_id %hWndTray%
					halfsize:=NumGet(rcPosition,12)/2
					xc+=NumGet(rcPosition,0)+ halfsize
					yc+=NumGet(rcPosition,4)+ (halfsize/2)
				}
			}
			RemoteBuf_close(TrayH)
		}
		If (!x and !y)
			Gosub, TTM_UPDATE
		else if !WinActive("ahk_id " . TT_HWND)
			DllCall("SendMessage", "Uint", TT_HWND, "Uint", %A_ThisLabel%, "Uint", 0, "Uint", (x<9999999 ? x : xc & 0xFFFF)|(y<9999999 ? y : yc & 0xFFFF)<<16)
	Return
	TTM_SETTIPBKCOLOR:
		If B is alpha
			If (%b%)
				B:=%b%
		B := (StrLen(B) < 8 ? "0x" : "") . B
		B := ((B&255)<<16)+(((B>>8)&255)<<8)+(B>>16) ; rgb -> bgr
		DllCall("SendMessage", "Uint", TT_HWND, "Uint", %A_ThisLabel%, "Uint", B, "Uint", 0)
	Return
	TTM_SETTIPTEXTCOLOR:
		If F is alpha
			If (%F%)
				F:=%f%
		F := (StrLen(F) < 8 ? "0x" : "") . F
		F := ((F&255)<<16)+(((F>>8)&255)<<8)+(F>>16) ; rgb -> bgr
		DllCall("SendMessage", "Uint", TT_HWND, "Uint", %A_ThisLabel%, "Uint",F & 0xFFFFFF, "Uint", 0)
	Return
	TTM_SETMARGIN:
		VarSetCapacity(RECT,16)
		Loop,Parse,E,.
			NumPut(A_LoopField,RECT,(A_Index-1)*4)
		DllCall("SendMessage", "Uint", TT_HWND, "Uint", %A_ThisLabel%, "Uint", 0, "Uint", &RECT)
	Return
	TT_SETTOOLINFO:
		If A {
			If A is not Xdigit
				ControlGet,A,Hwnd,,%A%,ahk_id %P%
			ID :=Abs(A)
			If !InStr(TT_ALL_%TT_ID%,Chr(2) . ID . Chr(2))
				TT_ALL_%TT_ID% .= Chr(2) . ID . Chr(2) . ID+Abs(P) . Chr(2)
			If !TOOLINFO_%ID%
				VarSetCapacity(TOOLINFO_%ID%, 40, 0),TOOLINFO_%ID%:=Chr(40)
			else
				Gosub, TTM_DELTOOL
			Numput((N ? 0 : 1)|16,TOOLINFO_%ID%,4),Numput(P,TOOLINFO_%ID%,8),Numput(ID,TOOLINFO_%ID%,12)
			If (text!="")
				NumPut(&text,TOOLINFO_%ID%,36)
			Gosub, TTM_ADDTOOL
			ID :=ID+Abs(P)
			If !TOOLINFO_%ID%
			{
				VarSetCapacity(TOOLINFO_%ID%, 40, 0),TOOLINFO_%ID%:=Chr(40)
				Numput(0|16,TOOLINFO_%ID%,4), Numput(P,TOOLINFO_%ID%,8), Numput(P,TOOLINFO_%ID%,12)
			}
			Gosub, TTM_ADDTOOL
			ID :=Abs(A)
		} else {
			If !TOOLINFO_%ID%
				VarSetCapacity(TOOLINFO_%ID%, 40, 0),TOOLINFO_%ID%:=Chr(40)
			else update:=True
			If (text!=""){
				If InStr(text,"<a"){
					TOOLTEXT_%ID%:=text
					text:=RegExReplace(text,"<a\K[^<]*?>",">")
				} else
					TOOLTEXT_%ID%:=
				NumPut(&text,TOOLINFO_%ID%,36)
			}
			NumPut((!(x . y) ? 0 : 0x20)|(S ? 0x80 : 0)|(L ? 0x1000 : 0),TOOLINFO_%ID%,4), Numput(P,TOOLINFO_%ID%,8), Numput(P,TOOLINFO_%ID%,12)
			Gosub, TTM_ADDTOOL
		}
	Return
	TTN_LINKCLICK:
		Loop 4
			m += *(text + 8 + A_Index-1) << 8*(A_Index-1)
		If !(TTN_FIRST-2=m or TTN_FIRST-3=m)
			Return
		Loop 4
			p += *(text + 0 + A_Index-1) << 8*(A_Index-1)
		If (TTN_FIRST-3=m)
			Loop 4
				option += *(text + 16 + A_Index-1) << 8*(A_Index-1)
		Loop,Parse,hWndArray,% Chr(2)
			If (p=A_LoopField and i:=A_Index)
				break
		Loop,Parse,idArray,% Chr(2)
		{
			If (i=A_Index){
				text:=TOOLTEXT_%A_LoopField%
				If (TTN_FIRST-2=m){
					If Title
					{
						If IsLabel(A_LoopField . title . "Close")
							Gosub % A_LoopField . title . "Close"
						else If IsLabel(title . "Close")
							Gosub % title . "Close"
					} else {
						If IsLabel(A_LoopField . A_ThisFunc . "Close")
							Gosub % A_LoopField . A_ThisFunc . "Close"
						else If IsLabel(A_ThisFunc . "Close")
							Gosub % A_ThisFunc . "Close"
					}
				} else If (InStr(TOOLTEXT_%A_LoopField%,"<a")){
					Loop % option+1
						StringTrimLeft,text,text,% InStr(text,"<a")+1
					If TT_HIDE_%A_LoopField%
						ToolTip(A_LoopField,"","","gTTM_POP")
					If ((a:=A_AutoTrim)="Off")
						AutoTrim, On
					ErrorLevel:=SubStr(text,1,InStr(text,">")-1)
					StringTrimLeft,text,text,% InStr(text,">")
					text:=SubStr(text,1,InStr(text,"</a>")-1)
					If !ErrorLevel
						ErrorLevel:=text
					ErrorLevel=%ErrorLevel%
					AutoTrim, %a%
					If Title
					{
						If IsFunc(f:=(A_LoopField . title))
							%f%(ErrorLevel)
						else if IsLabel(A_LoopField . title)
							Gosub % A_LoopField . title
						else if IsFunc(title)
							%title%(ErrorLevel)
						else If IsLabel(title)
							Gosub, %title%
					} else {
						if IsFunc(f:=(A_LoopField . A_ThisFunc))
							%f%(ErrorLevel)
						else If IsLabel(A_LoopField . A_ThisFunc)
							Gosub % A_LoopField . A_ThisFunc
						else If IsLabel(A_ThisFunc)
							Gosub % A_ThisFunc
					}
				}
				break
			}
		}
	Return
	TT_DESTROY:
		Loop, Parse, TT_ALL_%TT_ID%,% Chr(2)
			If A_LoopField
			{
				ID:=A_LoopField
				Gosub, TTM_DELTOOL
				TOOLINFO_%A_LoopField%:="", TT_HWND_%A_LoopField%:="", TOOLTEXT_%A_LoopField%:="", TT_HIDE_%A_LoopField%:=""
			}
		TT_ALL_%TT_ID%=
	Return
}
GetTrayIconPosByRef(ByRef x, ByRef y,PID=""){
	If ((#_DetectHiddenWindows:=A_DetectHiddenWindows)="Off")
		DetectHiddenWindows, On
	If !PID
	{
		Process, Exist
		PID:=ErrorLevel
	}
	hWndTray:=WinExist("ahk_class Shell_TrayWnd")
	ControlGet,hWndToolBar,Hwnd,,ToolbarWindow321,ahk_id %hWndTray%
	RemoteBuf_Open(TrayH,hWndToolBar,20)
	DataH:=NumGet(TrayH,0)
	SendMessage, 0x418,0,0,,ahk_id %hWndToolBar%
	Loop % ErrorLevel
	{
		SendMessage,0x417,A_Index-1,RemoteBuf_Get(TrayH),,ahk_id %hWndToolBar%
		RemoteBuf_Read(TrayH,lpData,20)
		pwData:=NumGet(lpData,12)
		VarSetCapacity(dwExtraData,8)
		DllCall( "ReadProcessMemory", "uint", DataH, "uint", pwData, "uint", &dwExtraData, "uint", 8, "uint", 0 )
		BWID:=NumGet(dwExtraData,0)
		WinGet,BWPID,PID, ahk_id %BWID%
		If (BWPID!=PID)
			continue
		SendMessage, 0x41d,A_Index-1,RemoteBuf_Get(TrayH),,ahk_id %hWndToolBar%
		RemoteBuf_Read(TrayH,rcPosition,20)
		If (NumGet(dwExtraData,8)>7){
			ControlGetPos,x,y,w,h,Button2,ahk_id %hWndTray%
			x+=w/2
			y+=h/2
		} else {
			ControlGetPos,x,y,,,ToolbarWindow321,ahk_id %hWndTray%
			halfsize:=NumGet(rcPosition,12)/2
			x+=NumGet(rcPosition,0)+ halfsize
			y+=NumGet(rcPosition,4)+ halfsize
		}
	}
	RemoteBuf_close(TrayH)
	DetectHiddenWindows, %#_DetectHiddenWindows%
}
EmptyMem:
EmptyMem()
Return
EmptyMem(PID="AHK Rocks"){
  pid:=(pid="AHK Rocks") ? DllCall("GetCurrentProcessId") : pid
  h:=DllCall("OpenProcess", "UInt", 0x001F0FFF, "Int", 0, "Int", pid)
  DllCall("SetProcessWork	ingSetSize", "UInt", h, "Int", -1, "Int", -1)
  DllCall("CloseHandle", "Int", h)
}
Input(){
	Input
}
Sleep(t=500){
	Sleep % t
}
IPC_Send(hwnd, msg="", action=100) {
	static WM_COPYDATA = 74, id=951753
	VarSetCapacity(CopyDataStruct, 12, 0), NumPut(action,CopyDataStruct, 0), NumPut(StrLen(msg) + 1, CopyDataStruct, 4), NumPut(&msg,	CopyDataStruct, 8)
   	SendMessage, WM_COPYDATA, action, &CopyDataStruct,, ahk_id %hwnd%
	return ErrorLevel
}

DBArray(@array,@action="add",@key="",@value="",@limit=4294967295,@offset=1){
	static
	local @start, @end, @result
	@end=1
	If (@action="set"){
			Gosub, @DBArrayGet
			@%@array%%@result%:=@value
	} else If (@action = "add"){
		@%@array%Idx++
		%@array% .= Chr(2) . @key . Chr(3) . @%@array%Idx . Chr(4)
		@result:=@%@array%Idx
		@%@array%%@result%:=@value
	} else If (@action = "find"){
		Gosub, @DBArrayFind
		Return @value
	} else if (@action = "sort"){
		Sort, %@array%,% "D" . Chr(4)
	} else if (@key!=""){
		If (@action = "get"){
			Gosub, @DBArrayGet
			Return @%@array%%@result%
		} else If (@action = "regex"){
			Gosub, @DBArrayRegEx
			Return @value
		} else If (@action="delete") {
			Gosub, @DBArrayGet
			Gosub, @DBArrayDelete
		} else if (@action = "exist") {
			If InStr(%@array%,Chr(2) . @key . Chr(3),0)
				Return 1
		}
	} else {
		if (@action="replace") {
			Loop % @%@array%Idx
			{
				@end=
				Loop,Parse,@%@array%%A_Index%,`n
				{
					StringReplace, @start, A_LoopField,%@key%,%@value%
					@end.=(A_Index=1 ? "" : "`n") . @start
				}
				@%@array%%A_Index%:= @end
			}
		} else if (@action="count"){
			Return @%@array%Idx
		} else if (@action="delete"){
			Loop % @%@array%Idx
				@%@array%%A_Index%=
			%@array%=
			@%@array%Idx=
		} else if (@action="get"){
			@value:=RegExReplace(%@array%,Chr(3) . "[^" . Chr(2) . "]*" . Chr(4) . "|" . Chr(2),"""")
			StringReplace, @value, @value, """", "", All
			Return @value
		}
	}
	Return	
	@DBArrayGet:
		If !(@end:=InStr(%@array%,Chr(2) . @key . Chr(3),0,@end))
			Return
		@start:=@end+StrLen(@key)+2
		@end:=(InStr(%@array%,Chr(4),0,@start))
		@result:=SubStr(%@array%,@start,@end-@start)
	Return
	@DBArrayFind:
		Loop % (@limit+@offset) {
			If !(@end:=InStr(%@array%,Chr(2) . @key,0,@end))
				Return
			If (@offset>A_Index){
				@end:=@end+StrLen(@key)+2
				Continue
			}
			@start:=InStr(%@array%,Chr(3),1,@end)+1
			@end:=(InStr(%@array%,Chr(4),0,@start))
			@result:=SubStr(%@array%,@start,@end-@start)
			@value.=@%@array%%@result% . """"
		}
		StringTrimRight, @value,@value,1
	Return
	@DBArrayRegEx:
		Loop % (@limit+@offset) {
			If !(@end:=InStr(%@array%,@key,0,@end))
				break
			If ((InStr(%@array%,Chr(4),1,@end)<@start:=InStr(%@array%,Chr(3),1,@end)) and @end:=@start)
				Continue
			@end:=(InStr(%@array%,Chr(4),0,@start))
			If (@offset>A_Index)
				Continue
			@result:=SubStr(%@array%,@start+1,@end-@start-1)
			@value.=@%@array%%@result% . """"
		}
		StringTrimRight, @value,@value,1
	Return
	@DBArrayDelete:
		@%@array%%@result%=
		StringReplace, %@array%,%@array%,% Chr(2) . @key . Chr(3) . @result . Chr(4)
	Return
}

#IfWinExist ahk_class tooltips_class32
!LButton::LButton
#IfWinActive

ExitApp(exitcode,message="",action="100"){
	global #__MAIN_HWND_,#__MAIN_PID_
	DetectHiddenWindows,On
	If message
		IPC_Send(#__MAIN_HWND_, message,action)
	PostMessage	0x9999,exitcode,,,ahk_pid %#__MAIN_PID_%
	ExitApp
}

AnimateWindow(hwnd,time,options) {
   Static H:=0x10000, A:=0x20000, C:=0x10, B:=0x80000, S:=0x40000, R:=0x1
   Static L:=0x2, D:=0x4, U:=0x8, O:="HACBSLURD"
   Loop,Parse,options
      If InStr(O,A_LoopField)
         opt+=(%A_LoopField%)
   If opt
      DllCall("AnimateWindow", "UInt", hwnd, "Int", time, "UInt", opt)
}


#__RUN_BOSA(path){
	ControlSetText,RichEdit20W2,%path%,A
	ControlClick,RichEdit20W2,A,,,3
	ControlFocus,RichEdit20W2,A
	Sleep, 250
	Send {Enter}
}

#__RUN_DIALOG(path){
	ControlGetPos,#__TEMP_VAR_,,,,Edit1,A
    ControlGetPos,#__TEMP_VAR_X,,,,ComboBox2,A
	ControlGetPos,#__TEMP_VAR_Y,,,,ComboBox1,A
    If (#__TEMP_VAR_ - #__TEMP_VAR_X <> 3 and #__TEMP_VAR_ - #__TEMP_VAR_Y <> 3)
        ShowExplorer(path)
	else {
		ControlSetText,Edit1,%path%,A
		ControlClick,Edit1,A,,,3
		ControlFocus,Edit1,A
		Sleep, 250
		Send {Enter}
	}
}
StringToRegEx(string,path=0){
	StringReplace, string, string, \,\\,All
	StringReplace, string, string, .,\.,All
	StringReplace, string, string, +,\+,All
	StringReplace, string, string, [,\[,All
	StringReplace, string, string, {,\{,All
	StringReplace, string, string, (,\(,All
	StringReplace, string, string, ),\),All
	StringReplace, string, string, ^,\^,All
	StringReplace, string, string, $,\$,All
	StringReplace, string, string, %A_Space%,\s,All
	If !path {
		StringReplace, string, string, *,\*,All
		StringReplace, string, string, ?,\?,All
		StringReplace, string, string, |,\|,All
	}
	Return string
}

Run(var,action="open",select="")
{
	global
	local #__FILE_TO_RUN, #__TEMP_OUT_VAR
	If (#_PARAM_VAR){
		%action%(var,(action="open") ? #_PARAM_VAR : select)
		Return
	}
	If FileExist(var)
		#_current_var_last:=GetKeyWord(var)
	else
		#_current_var_last:=var
	If InStr(var, "`n")
	{
		Loop, Parse, var, `n
			#__TEMP_OUT_VAR .= "`nF" A_Index " <a>" A_LoopField . "</a>"
		ToolTip(5,#__TEMP_OUT_VAR,"PRESS ENTER TO OPEN ALL FILES IN THIS GROUP","GTTM_TRACKPOSITION.TTM_TRACKACTIVATE L1 I" . GetAssociatedIcon(var))
		Input, #__TEMP_VAR, L1, {F1}{F2}{F3}{F4}{F5}{F6}{F7}{F8}{F9}{F10}{F11}{F12}{Esc}{ENTER}
		If (InStr(ErrorLevel, "EndKey:F") or ErrorLevel = "EndKey:Enter")
		{
			#__Errorlevel = %ErrorLevel%
			If #__Errorlevel = EndKey:Enter
			{
				MsgBox, 262404, Open multiple files, You are about to open several files`nDo you want to continue?
				IfMsgBox Yes
				{
					StringSplit, #__FILE_TO_RUN, var, `n
					Loop %#__FILE_TO_RUN0%
						%action%(#__FILE_TO_RUN%A_Index%,(action="open") ? #_PARAM_VAR : "")
				}
			}
			else
			{
				#__TEMP_VAR := SubStr(#__Errorlevel, 9)
				Loop, Parse, var, `n
					If (A_Index = #__TEMP_VAR)
						#__FILE_TO_RUN = %A_LoopField%
				If (#__FILE_TO_RUN != "")
					%action%(#__FILE_TO_RUN,(action="open" ? #_PARAM_VAR : ""))
			}
		}
	} else
		%action%(var,(action="open" ? #_PARAM_VAR : ""))
	ToolTip(5,"","","gTTM_POP")
	Return
}


Open(file,param=""){
	global
	ToolTip(5,file,"Opening, please wait…","GTTM_TRACKPOSITION.TTM_TRACKACTIVATE L1 I" . GetAssociatedIcon(file) . " x" . #_XPOS_ . " y" . #_YPOS_)
	If (InStr(FileExist(file),"D",1))
		Explore(file)
	else If (SubStr(file,-2)="ahk" and #__SET_RUN_AHK_AS_EXE_)
		ErrorLevel := Exe(file) ? 0 : 1
	else {
		If param
			Run, "%file%" %param%,% GetDir(file), UseErrorLevel
		else
			Run, "%file%",% GetDir(file), UseErrorLevel
	}
	If Errorlevel
		ToolTip(9, file, "Error opening file","I3 BFF0000 F000000 D2")
}

Explore(path,select=""){
	WinGetClass,#__ACTIVE_WINDOW_,A
	If InStr(#__ACTIVE_WINDOW_,"bosa_sdm_")
		#__RUN_BOSA(path)
	else if InStr(#__ACTIVE_WINDOW_,"#32770"){
		ControlGetPos,#__TEMP_VAR_,,,,Edit1,A
		ControlGetPos,#__TEMP_VAR_X,,,,ComboBox2,A
		If (#__TEMP_VAR_ - #__TEMP_VAR_X = 3)
			#__RUN_DIALOG(path)
		else
			ShowExplorer(path,select)
	} else
		ShowExplorer(path,select)
	Return
}

ShowExplorer(path,select=""){
	ToolTip(5,path,"Opening, please wait...","GTTM_TRACKPOSITION.TTM_TRACKACTIVATE L1 I" . GetAssociatedIcon(path) . " x" . #_XPOS_ . " y" . #_YPOS_)
	If (InStr(FileExist(path),"D",1) or FileExist(path)="")
		Run % "explorer.exe /e`, /n`," . path
	else
		Run,% "explorer.exe /e`, /n`, /select`," . path
	If Errorlevel
		ToolTip(9, path,"Error opening file","I3 BFF0000 F000000 D2")
	ToolTip(5,"","","gTTM_POP")
}

Edit(path,empty=""){
	global
	InfoOpening(path)
	If (FileExist(path) != "")	
	{
		Run,% #__SET__EDITOR_ " """ path """",% GetDir(file), UseErrorLevel
		If ErrorLevel
			ToolTip(9, #__FILE_TO_RUN, "Error opening file","I3 BFF0000 F000000 D2")
	}
}

Exe(file){
	global #__AHK_EXE_,#__ToolTip_Options, #__SET_RUN_AHK_AS_EXE_
	Filename:=RegExReplace(RegExReplace(File ,"^.*\\"),"\.[^\.]*$")
	if Filename is Time
	{
		FormatTime, Filename,%Filename%, HH.mm.ss
		Filename = _AHK @ %Filename%
	}
	else if !InStr(file,"\\.\pipe\")
		dir:= SubStr(file,1,InStr(file,"\",1,0))
	If (!#__SET_RUN_AHK_AS_EXE_ and !InStr(file,"\\.\pipe\AutoHotFile_"))
	{
		Run, %#__AHK_EXE_% "%file%",%dir%,UseErrorLevel,PID
		If ErrorLevel
			ToolTip(9,#__AHK_EXE_ """\\.\pipe\" #__PIPE_NAME_ """","Error opening pipe","I3 D2 " . #__ToolTip_Options),Exit()
		Return PID
	}
	Loop,%#__AHK_EXE_%
		path=%A_LoopFileDir%
	FileMove,%#__AHK_EXE_%,%path%\%FileName%.exe
	If ErrorLevel
		Return ErrorLevel
	Critical
	Loop
		Loop,%path%\%FileName%.exe
		{
			Run %A_LoopFileFullPath% "%file%",%dir%,UseErrorLevel,PID
			If ErrorLevel
				ToolTip(9,#__AHK_EXE_ """%file%" """","Error opening file","I3 D2 " . #__ToolTip_Options),Exit()
			Process,Wait,%Pid%,5
			FileMove,%A_LoopFileFullPath%,%#__AHK_EXE_%
			Process,Wait,%Pid%,0.1
			Critical, Off
			Return PID
		}
	Critical, off
}

GetFileName(path){
	Return SubStr(path, InStr(path, "\",1,0)+1)
}
GetKeyWord(path){
	global #__SET__KEYWORD_ENDCHAR_
	path:=GetFileName(path)
	If (#__SET__KEYWORD_ENDCHAR_!="" and RegExMatch(path,StringToRegEx(#__SET__KEYWORD_ENDCHAR_,1),"",2))
		Return SubStr(path,1,RegExMatch(path,StringToRegEx(#__SET__KEYWORD_ENDCHAR_,1),"",2)-1)
	Return path
}
GetDir(path){
	Return SubStr(path, 1, InStr(path, "\",1,0)-1)
}
WaitKey(){
	Input,var,V,{AppsKey}{ALT}{LWIN}{RWIN}{SHIFT}{CapsLock}{NumLock}{LControl}{LAlt}{LShift}{Tab}{Backspace}{Enter}{Left}{Right}{Up}{Down}{Delete}{Insert}{Escape}{Home}{End}{PgUp}{PgDn}{Numpad0}{Numpad1}{Numpad2}{Numpad3}{Numpad4}{Numpad5}{Numpad6}{Numpad7}{Numpad8}{Numpad9}{NumpadDot}{NumpadDiv}{NumpadMult}{NumpadAdd}{NumpadSub}{NumpadEnter}{NumpadIns}{NumpadEnd}{NumpadDown}{NumpadPgDn}{NumpadLeft}{NumpadClear}{NumpadRight}{NumpadHome}{NumpadUp}{NumpadPgUp}{NumpadDel}{NumpadDiv}{NumpadMult}{NumpadAdd}{NumpadSub}{NumpadEnter}{F1}{F2}{F3}{F4}{F5}{F6}{F7}{F8}{F9}{F10}{F11}{F12}{F13}{F14}{F15}{F16}{F17}{F18}{F19}{F20}{F21}{F22}{F23}{F24}{Pause}{Break}{PrintScreen}{LWin}{RWin}{RControl}{RAlt}{RShift}{a}{b}{c}{d}{e}{f}{g}{h}{i}{j}{k}{l}{m}{n}{o}{p}{q}{r}{s}{t}{u}{v}{w}{x}{y}{z}{0}{1}{2}{3}{4}{5}{6}{7}{8}{9}{Space}
}
WaitKeysUp(#__ALL_KEYS_ = "AppsKey|ALT|LWIN|RWIN|SHIFT|CapsLock|NumLock|LControl|LAlt|LShift|Tab|Backspace|Enter|Left|Right|Up|Down|Delete|Insert|Escape|Home|End|PgUp|PgDn|Numpad0|Numpad1|Numpad2|Numpad3|Numpad4|Numpad5|Numpad6|Numpad7|Numpad8|Numpad9|NumpadDot|NumpadDiv|NumpadMult|NumpadAdd|NumpadSub|NumpadEnter|NumpadIns|NumpadEnd|NumpadDown|NumpadPgDn|NumpadLeft|NumpadClear|NumpadRight|NumpadHome|NumpadUp|NumpadPgUp|NumpadDel|NumpadDiv|NumpadMult|NumpadAdd|NumpadSub|NumpadEnter|F1|F2|F3|F4|F5|F6|F7|F8|F9|F10|F11|F12|F13|F14|F15|F16|F17|F18|F19|F20|F21|F22|F23|F24|Pause|Break|PrintScreen|LWin|RWin|RControl|RAlt|RShift|a|b|c|d|e|f|g|h|i|j|k|l|m|n|o|p|q|r|s|t|u|v|w|x|y|z|0|1|2|3|4|5|6|7|8|9|Space")
{
	StringReplace,#__ALL_KEYS_,#__ALL_KEYS_,^,CTRL|
	StringReplace,#__ALL_KEYS_,#__ALL_KEYS_,+,SHIFT|
	StringReplace,#__ALL_KEYS_,#__ALL_KEYS_,!,ALT|
	StringReplace,#__ALL_KEYS_,#__ALL_KEYS_,~
	StringReplace,#__ALL_KEYS_,#__ALL_KEYS_,#,LWin|RWin|
	StringReplace,#__ALL_KEYS_,#__ALL_KEYS_,&,|
	Loop, Parse, #__ALL_KEYS_, |,%A_Space%
		KeyWait,% A_LoopField
	Return
}
MI_ExtractIcon(Filename, IconNumber, IconSize)
{
    If A_OSVersion in WIN_VISTA,WIN_2003,WIN_XP,WIN_2000
    {
      DllCall("PrivateExtractIcons", "Str", Filename, "Int", IconNumber-1, "Int", IconSize, "Int", IconSize, "UInt*", hIcon, "UInt*", 0, "UInt", 1, "UInt", 0, "Int")
        If !ErrorLevel
        Return hIcon
    }
    If DllCall("shell32.dll\ExtractIconExA", "Str", Filename, "Int", IconNumber-1, "UInt*", hIcon, "UInt*", hIcon_Small, "UInt", 1)
    {
        SysGet, SmallIconSize, 49        
        If (IconSize <= SmallIconSize) {
         DllCall("DeStroyIcon", "UInt", hIcon)
         hIcon := hIcon_Small
        }
      Else
		DllCall("DeStroyIcon", "UInt", hIcon_Small)
        
        If (hIcon && IconSize)
			hIcon := DllCall("CopyImage", "UInt", hIcon, "UInt", 1, "Int", IconSize, "Int", IconSize, "UInt", 4|8)
    }
    Return, hIcon ? hIcon : 0
}
GetAssociatedIcon(File){
	global
	static sfi, sfi_size:=352
	local Ext,Fileto,FileIcon,FileIcon#
	If not sfi
		VarSetCapacity(sfi, sfi_size)
	IfInString, file,`n
		StringLeft, file, file, % InStr(file,"`n")-1
	SplitPath, File,,, Ext
	if Ext in EXE,ICO,ANI,CUR,LNK
	{
		If ext=LNK
		{
			FileGetShortcut,%File%,Fileto,,,,FileIcon,FileIcon#
			File:=!FileIcon ? FileTo : FileIcon
		}
		SplitPath, File,,, Ext
		If !(#_hIcon%Ext%:=MI_ExtractIcon(InStr(File,"`n") ? SubStr(file,1,InStr(file,"`n")-1) : file,FileIcon# ? FileIcon# : 1,32))
			#_hIcon%Ext%:=#_hIcon_3
	} else If ((!Ext and !#_hIcon) or !InStr(#_hIcons,"|" . Ext . "|")){
		If DllCall("Shell32\SHGetFileInfoA", "str", File, "uint", 0, "str", sfi, "uint", sfi_size, "uint", 0x101){
			Loop 4
				#_hIcon%Ext% += *(&sfi + A_Index-1) << 8*(A_Index-1)
		}
		#_hIcons.= "|" . Ext . "|"
	}
	return #_hIcon%Ext%
}
WM_NOTIFY_PIPE(wParam, lParam){
	ToolTip("",lParam,"PIPECLICK")
}
PipeClick:
#_FILE:=ErrorLevel
SetTimer, ToolTipRunPIPE, -100
Return
ToolTipRunPIPE:
#_MOD:=GetKeyState("CTRL","P") . GetKeyState("ALT","P")
if FileExist(#_File){
	If (#_MOD="11")
		Clipboard:=#_FILE
	Else if (#_MOD="10")
		Edit(#_FILE)
	Else if (#_MOD="01")
		Explore(#_FILE)
	Else
		Open(#_File)
} else {
	If (#_MOD="11")
		Clipboard:=#_FILE
	Else if (#_MOD="10")
		Run(#_FILE,"edit")
	Else if (#_MOD="01")
		Run(#_FILE,"explore")
	Else
		Run(#_File)
}

If !IsLabel("#__SET_FILE")
	ExitApp(1,#__CURRENT_VAR)
Input
#_Function=Hide_AHS
%#_Function%()
Return
;old
Run(#_File)
If !IsLabel("#__SET_FILE")
	ExitApp(1,#__CURRENT_VAR)
Input
#_Function=Hide_AHS
%#_Function%()
Return

PipeClickClose:
If !IsLabel("#__SET_FILE")
ExitApp(1)
Input
#_Function=Hide_AHS
%#_Function%()
Return
Exit(){
	Exit
}
IncludesScriptEnd:
Return
;==================== END: #Include _Includes_# :B1AD529B-BF4E-477F-8B9F-3080CAC55AE3

;==================== START: #Include _URLDownloadToVarScript_# :B1AD5A5R-BF4E-477F-8B9F-3080CAC55AE3
URLDownloadToVarScript:
DetectHiddenWindows,On
#SingleInstance,Force
AutoTrim, Off
IPC_Send(#__MAIN_HWND_,#__CURRENT_VAR . Chr(4) . URLDownloadToVar(#__URL_),1)
ExitApp

UrlDownloadToVar(URL, Proxy="", ProxyBypass="") {
	global
	hModule := DllCall("LoadLibrary", "str", "wininet.dll")

	If (Proxy != "")
	AccessType=3
	Else
	AccessType=1
	
	io_hInternet:=DllCall("wininet\InternetOpenA", "str", "", "uint", AccessType, "str", Proxy, "str", ProxyBypass, "uint", 0)
	iou:=DllCall("wininet\InternetOpenUrlA", "uint", io_hInternet, "str", url, "str", "", "uint", 0, "uint", 0x80000000, "uint", 0)
	If (ErrorLevel != 0 or iou = 0) {
		DllCall("FreeLibrary", "uint", hModule)
		return 0
	}
	VarSetCapacity(buffer, 512, 0)
	VarSetCapacity(NumberOfBytesRead, 4, 0)
	Loop
	{
	  irf := DllCall("wininet\InternetReadFile", "uint", iou, "uint", &buffer, "uint", 512, "uint", &NumberOfBytesRead)
	  NOBR = 0
	  Loop 4
		NOBR += *(&NumberOfBytesRead + A_Index-1) << 8*(A_Index-1)
	  IfEqual, NOBR, 0, break
	  
	  DllCall("lstrcpy", "str", buffer, "uint", &buffer)
	  res = %res%%buffer%
	}
	If (URL="http://www.autohotkey.net/~HotKeyIt/AutoHotFile/version.txt")
		Return res
	StringTrimRight, res, res, 2

	DllCall("wininet\InternetCloseHandle",  "uint", iou)
	DllCall("wininet\InternetCloseHandle",  "uint", io_hInternet)
	DllCall("FreeLibrary", "uint", hModule)
	StringReplace,res,res,`n,,A
	StringReplace,res,res,`r,,A
	replace_html=<wbr>|<wbr />|<em>|</em>|<br>|</br>|<b>|</b>
	Loop,Parse,replace_html,|
		StringReplace,res,res,%A_LoopField%,,A
	StringTrimLeft,res,res,InStr(res,"1 - 1")
	StringReplace,res,res,% "<a ",`n,A
	Loop,Parse,res,`n
	{
		If !(start:=InStr(A_LoopField,"http"))
			continue
		link:=SubStr(A_LoopField,start,InStr(A_LoopField,"/",1,start+9)-start)
		If RegExMatch(link,"\d+\.\d+\.\d+\.\d+")
			continue
		If !RegExMatch(link,"^http://[A-Za-z0-9\.]+$")
			continue
		If (InStr(A_LoopField,"</a",1) and !RegExMatch(thisItem:=SubStr(A_LoopField,start,InStr(A_LoopField,"</a",1)-start),"%|;"))
			If (lastItem!=thisItem)
				out .= (lastItem:=thisItem) . "`n"
	}
	return out
}
UrlDownloadToVarScriptEnd:
Return
;==================== END: #Include _URLDownloadToVarScript_# :B1AD5A5R-BF4E-477F-8B9F-3080CAC55AE3

;==================== START: #Include _FileExplorerScript_# :B1AD5A5U-BF4E-477F-8B9F-3080CAC55AE3

FileExplorerScript:
DetectHiddenWindows, On
AutoTrim, Off
Hotkey,CapsLock,FECapslock
Hotkey,~Del,FEExitApp
Hotkey,~Esc,FEEsc
SetBatchLines,-1
OnMessage(0x4e,"WM_NOTIFY_PIPE")

;~ If (#_XPOS_ ="caret" or #_XPOS_ ="caret")
;~ 	CoordMode, ToolTip, Relative

#__CURRENT_VAR .= StrLen(#__CURRENT_VAR)<3 ? "\" : ""

info = `n`nCAPSLOCK`t`t- Show drive info and this help`nF1-F12`t`t`t- select found path`nALT+N and ALT+P`t- select next or previous drive`nENTER or SHIFT+F1-12`t- open file using assigned program`nTAB or RIGHT`t`t- take over subfolder/file`nSHIFT+TAB or LEFT`t- go to parent folder`nDOWN and UP`t`t- list next or previously found files/folders`nCTRL+C or V`t`t- copy and paste (CTRL+SHIFT+F1-12)`nALT+S`t`t`t- toggle subfolders (this option is shown behind your entry)`nALT+F`t`t`t- toggle search for files or folders`nALT+E or ALT+F1-12`t- show file in explorer or autoselect in a dialog`nCTRL+E or CTRL+F1-12`t- edit files using defined editor`nPGDN or PGUP`t`t- Select next or previous entry`nSHIFT+BACKSPACE`t- Delete last folder/file
searchsubfolders := 0
searchfile := (#__SET__EXPLORER_SEARCH_="" ? 1 : #__SET__EXPLORER_SEARCH_)
searchagain := (StrLen(#__CURRENT_VAR)>3 ? 1 : 0)

ToolTip(5,"CapsLock for help!",#__CURRENT_VAR, #__ToolTip_Options . " L1 I" . #_hIcon_3)
Loop
{
	ErrorLevel =
	If (A_Index!=1 and StrLen(#__CURRENT_VAR) < 3 and #__CURRENT_VAR != "\\")
		ExitApp
	If (A_Index>1 or StrLen(#__CURRENT_VAR)< 4)
		Input, string, M L1, {ENTER}{ESC}{BS}{DOWN}{UP}{LEFT}{RIGHT}{TAB}{PGDN}{PGUP}{CapsLock}{DEL}{F1}{F2}{F3}{F4}{F5}{F6}{F7}{F8}{F9}{F10}{F11}{F12}{F13}{F14}{F15}{F16}{F17}{F18}{F19}{F20}{F21}{F22}{F23}{F24}
	SetTimer,Search,Off
	#__MOD_STATE_ := GetKeyState("CTRL", "P") . GetKeyState("ALT", "P")
	If (ErrorLevel!="EndKey:Up" and ErrorLevel!="EndKey:Down")
		#__EXPLORER_GOBACK_:=0
	If (#__MOD_STATE_="00") {
		If Errorlevel = EndKey:Down
			#__EXPLORER_GOBACK_+=#__SET__PROPOSAL_
		else if Errorlevel = EndKey:Up
			#__EXPLORER_GOBACK_:=(#__EXPLORER_GOBACK_<(#__SET__PROPOSAL_) ? 0 : (#__EXPLORER_GOBACK_-#__SET__PROPOSAL_))
		else if Errorlevel = EndKey:PgUp
			ExitApp(2)
		else if Errorlevel = EndKey:PgDn
			ExitApp(3)
		else if Errorlevel = EndKey:CapsLock
		{
			DriveSpaceFree, #__DRIVE_INFO_,% (#__OUT_TEMP_VAR_ := SubStr(#__CURRENT_VAR,1,InStr(#__CURRENT_VAR, "\")))
			#__#_INPUT_VAR_ = Capacity|Status|Label|Type
			Loop, Parse, #__#_INPUT_VAR_, |
			{
				DriveGet, #__#_INPUT_VAR_, %A_LoopField%, %#__OUT_TEMP_VAR_%
				#__DRIVE_INFO_ .= "|" . #__#_INPUT_VAR_
			}
			StringSplit, #__DRIVE_INFO_, #__DRIVE_INFO_, |
			#__DRIVE_INFO_ = CURRENT DRIVE:`t%#__OUT_TEMP_VAR_%`nNAME:`t`t`t%#__DRIVE_INFO_4%`nTYPE:`t`t`t%#__DRIVE_INFO_5%`nSTATUS:`t`t%#__DRIVE_INFO_3%`n`n%#__DRIVE_INFO_1% of %#__DRIVE_INFO_2% MB free
			ToolTip(5,#__DRIVE_INFO_ . info,"Information","G1 L1 I" . #_hIcon_2)
			KeyWait, CapsLock
		}
		else if (Errorlevel = "EndKey:Backspace" and GetKeyState("Shift","P"))
		{
			#__CURRENT_VAR := RegExReplace(#__CURRENT_VAR, "\\[^\\]*\\?$","\","",1)
			#__EXPLORER_GOBACK_:=0
			If (StrLen(#__CURRENT_VAR) < 3)
				ExitApp
		}
		else if Errorlevel = EndKey:Delete
			ExitApp
		else if (Errorlevel = "EndKey:Backspace")
		{
			StringTrimRight, #__CURRENT_VAR, #__CURRENT_VAR, 1
			#__EXPLORER_GOBACK_:=0
		}
		else if Errorlevel = EndKey:Escape
			ExitApp(1)
		else if (Errorlevel = "EndKey:Enter" or (InStr(ErrorLevel,"EndKey:F",1) and GetKeyState("Shift","P")))
		{
			If InStr(ErrorLevel,"EndKey:F",1)
				#_F_KEY:=SubStr(ErrorLevel,9),#_FOUND_PATH_1:=#_FOUND_PATH_%#_F_KEY%
			else If (SubStr(#__CURRENT_VAR,0)="\")
				#_FOUND_PATH_1=
			If !#_FOUND_PATH_1
			{
				If (InStr(FileExist(#__CURRENT_VAR),"D",1) or FileExist(#__CURRENT_VAR)="")
					Run(#__CURRENT_VAR,"explore")
				else
					Run(#__CURRENT_VAR)
				ExitApp(1,#__CURRENT_VAR)
			} else if GetKeyState("SHIFT","P") {
				#__CURRENT_VAR:=#_FOUND_PATH_%#_F_KEY%
				ToolTip(5,"searching…",#__CURRENT_VAR,"G1 L1 I" . (#_FOUND_PATH_ ?  GetAssociatedIcon(#_FOUND_PATH_1) : #_hIcon_2))
				#_FOUND_PATH_=
				Loop % #__SET__PROPOSAL_
					#_FOUND_PATH_%A_Index%:=""
				SetTimer,Search,% (-1 * #__SET__PROPOSAL_TIMEOUT_)
				Continue
			} else if (InStr(FileExist(#_FOUND_PATH_1),"D",1)){
				Run(#_FOUND_PATH_1,"explore")
			} else {
				Run(#_FOUND_PATH_1)
			}
			ExitApp(1,#__CURRENT_VAR)
		}
		else If InStr(ErrorLevel,"EndKey:F",1)
		{
			#_F_KEY:=SubStr(ErrorLevel,9)
			If (InStr(FileExist(#_FOUND_PATH_%#_F_KEY%),"D",1))
				#__CURRENT_VAR:=#_FOUND_PATH_%#_F_KEY% . "\"
			else if FileExist(#_FOUND_PATH_%#_F_KEY%)
				Run(#_FOUND_PATH_%#_F_KEY%), ExitApp(1,#__CURRENT_VAR)
		}
		else if (ErrorLevel="EndKey:Left" or (ErrorLevel="EndKey:Tab" and GetKeyState("Shift", "P")))
				#__CURRENT_VAR := RegExReplace(#__CURRENT_VAR , "\\\K[^\\]*$|\\\K[^\\]*\\$")
		else If (Errorlevel = "EndKey:Tab" or ErrorLevel = "EndKey:Right")
		{

			If #_FOUND_PATH_1
			{
				If (InStr(FileExist(#_FOUND_PATH_1),"D",1))
					#__CURRENT_VAR = %#_FOUND_PATH_1%\
				else
					#__CURRENT_VAR = %#_FOUND_PATH_1%
			}
			#__EXPLORER_GOBACK_:=0
		} else {
			#__EXPLORER_GOBACK_:=0
			#__CURRENT_VAR .= string
		}
	} else {
		If (ErrorLevel="Max") {
			If Asc(string) = 3
				Clipboard := ((#_FOUND_PATH_1 and SubStr(#__CURRENT_VAR,0)!="\") ? #_FOUND_PATH_1 : #__CURRENT_VAR), ExitApp(1,#__CURRENT_VAR)
			Else if Asc(string) = 5
			{
				#_FOUND_PATH_1:=(#_FOUND_PATH_1 and SubStr(#__CURRENT_VAR,0)!="\") ? #_FOUND_PATH_1 : #__CURRENT_VAR
				Run(#_FOUND_PATH_1,"edit")
				ExitApp(1)
			}
			else if (Asc(string) = 22)
				#__CURRENT_VAR .= Clipboard
			else if string = e
				Run((#_FOUND_PATH_1 and SubStr(#__CURRENT_VAR,0)!="\") ? #_FOUND_PATH_1 : #__CURRENT_VAR,"explore"),ExitApp(1,#__CURRENT_VAR)
			else if string = s
				searchsubfolders := (searchsubfolders > 0 ? 0 : 1), #__EXPLORER_GOBACK_:=0
			else if string = f
				searchfile := (searchfile > 0 ? 0 : 2), #__EXPLORER_GOBACK_:=0
			else if string = o
				searchfile := (searchfile = 2 ? 0 : 2), #__EXPLORER_GOBACK_:=0
			else if String = a
				searchfile := (searchfile = 1 ? 2 : 1), #__EXPLORER_GOBACK_:=0
			else if string = p
			{
				DriveGet,#__LIST_DRIVES,list
				If (InStr(#__LIST_DRIVES,SubStr(#__CURRENT_VAR,1,1))=1)
					#__CURRENT_VAR:= SubStr(#__LIST_DRIVES,0) . ":\"
				else
					#__CURRENT_VAR := SubStr(#__LIST_DRIVES,InStr(#__LIST_DRIVES,SubStr(#__CURRENT_VAR,1,1))-1,1) . ":\"
			}
			else if string = n
			{
				DriveGet,#__LIST_DRIVES,list
				If (StrLen(#__LIST_DRIVES)=InStr(#__LIST_DRIVES,SubStr(#__CURRENT_VAR,1,1)))
					#__CURRENT_VAR:= SubStr(#__LIST_DRIVES,1,1) . ":\"
				else
					#__CURRENT_VAR := SubStr(#__LIST_DRIVES,InStr(#__LIST_DRIVES,SubStr(#__CURRENT_VAR,1,1))+1,1) . ":\"
			}
			else
				#__EXPLORER_GOBACK_:=0, #__CURRENT_VAR .= string
		} else if InStr(ErrorLevel,"EndKey:F") {
			#_F_KEY:=SubStr(ErrorLevel, 9)
			If #__MOD_STATE_ = 01
				Run(#_FOUND_PATH_%#_F_KEY%,"explore")
			else if #__MOD_STATE_ = 10
				Run(#_FOUND_PATH_%#_F_KEY%
			else if #__MOD_STATE_ = 11
				Clipboard := #_FOUND_PATH_%#_F_KEY%
			ExitApp(1,#__CURRENT_VAR)
		} else if ErrorLevel=EndKey:Tab
			#__EXPLORER_GOBACK_++
	}
	ToolTip(5,"",#__CURRENT_VAR . " - (searching…)","gTTM_TRACKPOSITION L1 I" . (#_FOUND_PATH_ ? GetAssociatedIcon(#_FOUND_PATH_1) : #_hIcon_2) . " X" . #_XPOS_ . " Y" . #_YPOS_)
	#_FOUND_PATH_=
	Loop % #__SET__PROPOSAL_
		#_FOUND_PATH_%A_Index%:=""
	SetTimer,Search,% (-1 * #__SET__PROPOSAL_TIMEOUT_)
	Continue

	Search:
	#_CURRENT_POS_=
	Loop, %#__CURRENT_VAR%*, %searchfile%, %searchsubfolders%
	{
		If #__EXPLORER_GOBACK_+1 > A_Index
			Continue
		#_CURRENT_POS_:=A_Index - #__EXPLORER_GOBACK_
		#_FOUND_PATH_%#_CURRENT_POS_%:=RegExMatch(A_LoopFileFullPath, "^[A-Z][^~]*$|^\\\\") ? A_LoopFileFullPath : A_LoopFileLongPath
		#_FOUND_PATH_.="`nF" . #_CURRENT_POS_ . A_Tab . "<a " . #_FOUND_PATH_%#_CURRENT_POS_% . ">" . SubStr(#_FOUND_PATH_%#_CURRENT_POS_%,InStr(#_FOUND_PATH_%#_CURRENT_POS_%,"\",1,0)+1) . "</a>"
		If (A_Index=#__SET__PROPOSAL_+#__EXPLORER_GOBACK_)
			Break
	}
	If (!#_CURRENT_POS_ and #__EXPLORER_GOBACK_>0)
	{
		#__EXPLORER_GOBACK_:=0
		Goto,Search
	}
	else if !#_CURRENT_POS_
		#__EXPLORER_GOBACK_:=0
	ToolTip(5,(#_FOUND_PATH_ ? #_FOUND_PATH_ : "nothing found…"),#__CURRENT_VAR . "   -   (" . (searchsubfolders ? "sub-" : "") . (searchfile ? (searchfile=1 ? "files and folders" : "folders") : "files") . ")","g1 L1 I" . (#_FOUND_PATH_ ? GetAssociatedIcon(#_FOUND_PATH_1) : #_hIcon_2))
	Return
}

FEEsc:
ExitApp(1)
Return

FEExitApp:
ExitApp

FECapsLock:
Send {CapsLock}
SetCapsLockState Off
Return
FileExplorerScriptEnd:
Return
;==================== END: #Include _FileExplorerScript_# :B1AD5A5U-BF4E-477F-8B9F-3080CAC55AE3

;==================== START: #Include _StdOutToVarScript_# :B1AD5S5U-BF4E-477F-8B9F-3080CAC55AE3

StdOutToVarScript:
DetectHiddenWindows, On
AutoTrim, Off
Hotkey,CapsLock,STDCapslock
Hotkey,~Del,STDExitApp
Hotkey,~Esc,STDEsc
CoordMode, Mouse, Screen
SetBatchLines,-1
If (#_XPOS_ ="caret" or #_XPOS_ ="caret")
	CoordMode, ToolTip, Relative

ToolTip(5,"Enter a cmd line entry. E.g. #ping www.google.de", #__CURRENT_VAR,"L1 " . #__ToolTip_Options . " I" #_hIcon_3)

Loop
{
	If #__CURRENT_VAR =
		ExitApp
	Input, #_INPUT_VAR, M L1, {Esc}{Del}{BackSpace}{ENTER}{PGUP}{PGDN}{CapsLock}
	If ErrorLevel = Max
	{
		#__CURRENT_VAR .= #_INPUT_VAR
	}
	else if Errorlevel = EndKey:Enter
	{
		Gosub, #__CMD_COMMAND
		#__CMD_COMMAND_ =
		IPC_Send(#__MAIN_HWND_, #__CURRENT_VAR)
		Continue
	}
	Else if ErrorLevel = EndKey:CapsLock
		ExitApp(1,#__CURRENT_VAR)
	else if Errorlevel = EndKey:Escape
		ExitApp(1)
	else if Errorlevel = EndKey:PgUp
		ExitApp(2)
	else if Errorlevel = EndKey:PgDn
		ExitApp(3)
	else if Errorlevel = EndKey:Delete
		ExitApp
	else if Errorlevel = EndKey:Backspace
		StringTrimRight, #__CURRENT_VAR, #__CURRENT_VAR, 1
	ToolTip(5,"Enter a cmd line entry.`nE.g. #ping www.google.de",#__CURRENT_VAR,"G1 L1 I" . #_hIcon_3)
}
Return

STDEsc:
ExitApp(1)
Return

STDExitApp:
ExitApp

#__CMD_COMMAND:
	ToolTip(5,"Retrieving data...",#__CURRENT_VAR,"G1 L1 I" . #_hIcon_1)
	ToolTip(5,"FINISHED!`n" . StdoutToVar_CreateProcess(SubStr(#__CURRENT_VAR, 2), "#__CMD_COMMAND_STREAM"),#__CURRENT_VAR,"G1 L1 I" . #_hIcon_2)
Return

#__CMD_COMMAND_STREAM(sString)
{
	global
	#__CMD_COMMAND_ .= sString
	ToolTip(5,"Retrieving data...`n" . SubStr(#__CMD_COMMAND_, InStr(#__CMD_COMMAND_, "`n")),#__CURRENT_VAR,"G1 L1 I" . #_hIcon_1)
	Return
}
STDCapsLock:
Send {CapsLock}
SetCapsLockState Off
Return
;*************************************************************************************************
;*                                    S T D O U T   FUNCTION by Sean                             *
;*************************************************************************************************
StdoutToVar_CreateProcess(sCmd, bStream = "", sDir = "", sInput = "")
{
	DllCall("CreatePipe", "UintP", hStdInRd , "UintP", hStdInWr , "Uint", 0, "Uint", 0)
	DllCall("CreatePipe", "UintP", hStdOutRd, "UintP", hStdOutWr, "Uint", 0, "Uint", 0)
	DllCall("SetHandleInformation", "Uint", hStdInRd , "Uint", 1, "Uint", 1)
	DllCall("SetHandleInformation", "Uint", hStdOutWr, "Uint", 1, "Uint", 1)
	VarSetCapacity(pi, 16, 0)
	NumPut(VarSetCapacity(si, 68, 0), si)
	NumPut(0x100	, si, 44)
	NumPut(hStdInRd	, si, 56)
	NumPut(hStdOutWr, si, 60)
	NumPut(hStdOutWr, si, 64)
	If Not	DllCall("CreateProcess", "Uint", 0, "Uint", &sCmd, "Uint", 0, "Uint", 0, "int", True, "Uint", 0x08000000, "Uint", 0, "Uint", sDir ? &sDir : 0, "Uint", &si, "Uint", &pi)
		Return "invalid function"
	DllCall("CloseHandle", "Uint", NumGet(pi,0))
	DllCall("CloseHandle", "Uint", NumGet(pi,4))
	DllCall("CloseHandle", "Uint", hStdOutWr)
	DllCall("CloseHandle", "Uint", hStdInRd)
	If	sInput <>
	DllCall("WriteFile", "Uint", hStdInWr, "Uint", &sInput, "Uint", StrLen(sInput), "UintP", nSize, "Uint", 0)
	DllCall("CloseHandle", "Uint", hStdInWr)
	bStream+0 ? (bAlloc:=DllCall("AllocConsole"),hCon:=DllCall("CreateFile","str","CON","Uint",0x40000000,"Uint",bAlloc ? 0 : 3,"Uint",0,"Uint",3,"Uint",0,"Uint",0)) : ""
	VarSetCapacity(sTemp, nTemp:=bStream ? 64-nTrim:=1 : 4095)
	Loop
		If	DllCall("ReadFile", "Uint", hStdOutRd, "Uint", &sTemp, "Uint", nTemp, "UintP", nSize:=0, "Uint", 0)&&nSize
		{
			NumPut(0,sTemp,nSize,"Uchar"), VarSetCapacity(sTemp,-1), sOutput.=sTemp
			If	bStream
				Loop
					If	RegExMatch(sOutput, "[^\n]*\n", sTrim, nTrim)
						bStream+0 ? DllCall("WriteFile", "Uint", hCon, "Uint", &sTrim, "Uint", StrLen(sTrim), "UintP", 0, "Uint", 0) : %bStream%(sTrim), nTrim+=StrLen(sTrim)
					Else	Break
		}
		Else	Break
	DllCall("CloseHandle", "Uint", hStdOutRd)
	bStream+0 ? (DllCall("Sleep","Uint",1000),hCon+1 ? DllCall("CloseHandle","Uint",hCon) : "",bAlloc ? DllCall("FreeConsole") : "") : ""
	Return	sOutput
}
StdOutToVarScriptEnd:
Return
;==================== END: #Include _StdOutToVarScript_# :B1AD5S5U-BF4E-477F-8B9F-3080CAC55AE3

;==================== START: #Include _AutoHotStringScript_# :B1AD5O4U-BF4E-477F-8B9F-3080CAC55AE3

AutoHotStringScript:
Run_Script:
Edit_Script:
Show_Script:
Copy_Path:
Copy_Dir:
#__OUT_RUN_VAR_:=SubStr(A_ThisHotkey,StrLen(#__SET__HOTSTRING_OPTION_)+StrLen(#__SET__HOTSTRING_RUN_)+3)
#_ACTION:=A_ThisLabel
GoSub, #__SET_FILE
InfoOpening(#__FILE_TO_RUN)
If #_ACTION = Run_Script
	Run, "%#__FILE_TO_RUN%",% GetDir(#__FILE_TO_RUN)
else if #_ACTION=Edit_Script
	Run, %#__SET__EDITOR_% "%#__FILE_TO_RUN%"
else if #_ACTION=Show_Script
{
	WinGetClass, #__ACTIVE_WINDOW_,A
	If InStr(#__ACTIVE_WINDOW_,"bosa_sdm_")
		#__RUN_BOSA(#__FILE_TO_RUN)
	else if InStr(#__ACTIVE_WINDOW_,"#32770"){
		#__RUN_DIALOG(#__FILE_TO_RUN)
	} else
		ShowExplorer(#__FILE_TO_RUN)
} else if #_ACTION=Copy_Path
	Clipboard := #__FILE_TO_RUN
else if #_ACTION=Copy_Dir
	Clipboard := GetDir(#__FILE_TO_RUN)
Hide_AHS()
Return

#__SET_FILE:
#__FILE_TO_RUN:=DBArray("files","get",#__OUT_RUN_VAR_)
If #__SET__WARN_ON_AUTOHOTSTRING_
{
	ToolTip(5,#__FILE_TO_RUN . "`n`n!!! FILE WILL OPEN IN " . #__SET__WARN_ON_AUTOHOTSTRING_ . " SECONDS, PRESS ANY KEY TO CANCEL !!!",SubStr(#__FILE_TO_RUN, InStr(#__FILE_TO_RUN, "\",1,0)+1),"GTTM_TRACKPOSITION.TTM_TRACKACTIVATE L1 I" . GetAssociatedIcon(#__FILE_TO_RUN) . " x" . #_XPOS_ . " y" . #_YPOS_)
	Input, #__TEMP_VAR, V L1 T%#__SET__WARN_ON_AUTOHOTSTRING_%, {Escape}{AppsKey}{ALT}{LWIN}{RWIN}{SHIFT}{CapsLock}{NumLock}{LControl}{LAlt}{LShift}{Tab}{Backspace}{Enter}{Left}{Right}{Up}{Down}{Delete}{Insert}{Escape}{Home}{End}{PgUp}{PgDn}{Numpad0}{Numpad1}{Numpad2}{Numpad3}{Numpad4}{Numpad5}{Numpad6}{Numpad7}{Numpad8}{Numpad9}{NumpadDot}{NumpadDiv}{NumpadMult}{NumpadAdd}{NumpadSub}{NumpadEnter}{NumpadIns}{NumpadEnd}{NumpadDown}{NumpadPgDn}{NumpadLeft}{NumpadClear}{NumpadRight}{NumpadHome}{NumpadUp}{NumpadPgUp}{NumpadDel}{NumpadDiv}{NumpadMult}{NumpadAdd}{NumpadSub}{NumpadEnter}{F1}{F2}{F3}{F4}{F5}{F6}{F7}{F8}{F9}{F10}{F11}{F12}{F13}{F14}{F15}{F16}{F17}{F18}{F19}{F20}{F21}{F22}{F23}{F24}{Pause}{Break}{PrintScreen}{LWin}{RWin}{RControl}{RAlt}{RShift}{Space}
	If (ErrorLevel != "Timeout" and ErrorLevel != "EndKey:Enter" and !InStr(ErrorLevel,"EndKey:F"))
		Hide_AHS(), Exit()
}
If InStr(#__FILE_TO_RUN, "`n")
{
    #__TEMP_OUT_VAR =
    Loop, Parse, #__FILE_TO_RUN, `n
        #__TEMP_OUT_VAR .= "`nF" A_Index " <a>" A_LoopField . "</a>"
    ToolTip(5,#__TEMP_OUT_VAR,"PRESS ENTER TO OPEN ALL FILES IN THIS GROUP","GTTM_TRACKPOSITION.TTM_TRACKACTIVATE L1 I" . GetAssociatedIcon(#__FILE_TO_RUN) . " x" . #_XPOS_ . " y" . #_YPOS_)
    Input, #__TEMP_VAR, L1, {F1}{F2}{F3}{F4}{F5}{F6}{F7}{F8}{F9}{F10}{F11}{F12}{Esc}{ENTER}
    If InStr(ErrorLevel, "EndKey:F")
    {
        #__TEMP_VAR := SubStr(Errorlevel, 9)
        Loop, Parse, #__FILE_TO_RUN, `n
            If (A_Index = #__TEMP_VAR)
                #__FILE_TO_RUN := A_LoopField
    }
    else
        Hide_AHS(),Exit()
}
If #__SET__WARN_ON_AUTOHOTSTRING_
	ToolTip(5,#__FILE_TO_RUN . "`n`nOpening file, please wait...",GetFileName(#__FILE_TO_RUN),"G1 L1 I" . GetAssociatedIcon(#__FILE_TO_RUN))
Return

Hide_AHS(){
    global
	ToolTip(5,"","","gTTM_POP")
    EmptyMem()
	Exit
}

CreateDatabase:
Loop,Parse,#__FILE_DATABASE,""
	If A_LoopField
		DBArray("files","add",GetKeyWord((#_POS_LINEFEED:=InStr(A_LoopField,"`n")) ? SubStr(A_LoopField,1,#_POS_LINEFEED-1) : A_LoopField), A_LoopField)
Return

ActivateChording:
SetKeyDelay -1
#KeySet = abcdefghijklmnopqrstuvwxyz0123456789_^°!§$`%&()[]{}+~#'.,;
Loop Parse, #KeySet
{
   HotKey  ~*$%A_LoopField%,  KeyDown, B
   HotKey ~*%A_LoopField% up, KeyUp, B
}
Return
KeyDown:
   StringReplace #k, A_ThisHotKey, ~
   StringReplace #k, #k, *
   StringReplace #k, #k, $
   #keys .= #k
   KeyWait, %#k%
Return
KeyUp:
	If (StrLen(#keys)<2)
	{
		#pressed=0
		Loop,Parse,#KeySet
			#pressed:=#pressed + GetKeyState(A_LoopField,"P")
		If !#pressed
			#keys=
		Return
	}
	StringReplace #k, A_ThisHotKey, ~
	StringReplace #k, #k, *
	StringReplace #k, #k, %A_Space%up
	#pressed=0
	Loop,Parse,#KeySet
		#pressed:=#pressed + GetKeyState(A_LoopField,"P")
	If (!#pressed and #k!=SubStr(#keys,0) and StrLen(#keys)>=#__SET__CHORDING_LENGTH_){
		If DBArray("files","exist",#keys){
			SendInput % "{BS " . StrLen(#keys) . "}"
			#__OUT_RUN_VAR_:=#keys
			#keys=
			GoSub, #__SET_FILE
			InfoOpening(#__FILE_TO_RUN)
			If ((#_MOD:=GetKeyState("Ctrl","P") . GetKeyState("Alt","P")) = "00")
				Run, "%#__FILE_TO_RUN%",% GetDir(#__FILE_TO_RUN)
			else if #_MOD=10
				Run, %#__SET__EDITOR_% "%#__FILE_TO_RUN%"
			else if #_MOD=01
			{
				WinGetClass, #__ACTIVE_WINDOW_,A
				If InStr(#__ACTIVE_WINDOW_,"bosa_sdm_")
					#__RUN_BOSA(#__FILE_TO_RUN)
				else if InStr(#__ACTIVE_WINDOW_,"#32770"){
					#__RUN_DIALOG(#__FILE_TO_RUN)
				} else
					ShowExplorer(#__FILE_TO_RUN)
			} else if #_MOD=11
				Clipboard := #__FILE_TO_RUN
			Hide_AHS()
		}
	} 
	#pressed=0
	Loop,Parse,#KeySet
		#pressed:=#pressed + GetKeyState(A_LoopField,"P")
	if !#pressed
		#keys=
Return
AutoHotStringScriptEnd:
Return
;==================== END: #Include _AutoHotStringScript_# :B1AD5O4U-BF4E-477F-8B9F-3080CAC55AE3
