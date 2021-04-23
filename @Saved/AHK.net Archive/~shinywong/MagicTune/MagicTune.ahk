; Name: MagicTune AutoHotkey script.
; Version: 1.0 (01/26/2012)
; Author: Shiny Wong
; Contact me: shinywong.studio AT gmail.com

#SingleInstance Force
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
SetStoreCapslockMode, Off

; Settings region start ============================================================

; The maximum supported number of Samsung montiors.
; If you have less than %monitorCapacity% monitors, you don't have to change this value.
; If you have more than %monitorCapacity% monitors, and at least one Samsung monitor's index is larger than %monitorCapacity%
; then you should enlarge this value; Otherwise, you don't have to change this value neither.
; If you want to change this value, you should modify "monitorsAreSamsung", "monitorModes" below at the same time.
monitorCapacity := 3

; If the monitor number is omitted in the function calls, following monitor is used.
; And currently, because Auto MagicBright only check one single monitor,
; so this monitor number is also used in Auto MagicBright to indicate which monitor to check.
; The monitor number here is one-based.
defaultMonitor := 1

; Internal use. Do NOT change the values of following 10 variables.
standard := "A"
text := "B"
internet := "C"
game := "D"
sports := "E"
cinema := "F"
movie := "G"
entertain := "H"
custom := "I"
dynamicContrast := "J"

; Whether to load resource from MagicTune dll. If the value is false, this script will use custom strings.
loadResourceFromMagicTuneDll := true

useCustomLanguage := false

; Possible values are:
; "en" (English)
; "de" (Deutsch)
; "es" (Español)
; "fr" (Français)
; "hu" (Magyar)
; "it" (Italiano)
; "ja" (???)
; "ko" (???)
; "pl" (Polski)
; "pt" (Português)
; "ru" (???????)
; "sv" (Svenska)
; "tr" (Türkçe)
; "zh-Hans" (??(??))
; "zh-Hant" (??(??))
customLanguage := "en"

; if loadResourceFromMagicTuneDll=false, the script will use following text.
customModeNames := { (standard): "Standard"
    ,                    (text): "Text"
    ,                (internet): "Internet"
    ,                    (game): "Game"
    ,                  (sports): "Sports"
    ,                  (cinema): "Cinema"
    ,                   (movie): "Movie"
    ,               (entertain): "Entertain"
    ,                  (custom): "Custom"
    ,         (dynamicContrast): "Dynamic Contrast" }

; Set which monitor is Samsung, which is not.
monitorsAreSamsung := [true, false, false]

; Supported MagicBright modes of every monitor.
; You must modify the value to match actual modes.
monitorModes := Object()
monitorModes[1] := [standard, game, cinema, custom, dynamicContrast] ; Default value: [standard, game, cinema, custom, dynamicContrast]
monitorModes[2] := Object() ; If the 2nd monitor is the same as 1st monitor, you can use:  monitorModes[2] := monitorModes[1]
monitorModes[3] := Object()

; In Auto MagicBright: Standard, Game and Cinema don't really mean to set Standard/Game/Cinema mode,
; It will find the first available mode in the group.
; For example, if your Samsung monitor is an old model, it doesn't have Standard moode, but it has Text mode.
; So to set Standard mode means to set Text mode in Auto MagicBright.
; Generally, you don't have to change the definitions of the three groups.
standardGroup := [standard, text, internet] ; Default value: [standard, text, internet]
gameGroup := [game, sports] ; Default value: [game, sports]
cinemaGroup := [cinema, movie, entertain] ; Default value: [cinema, movie, entertain]

; If you havn't specify monitor number when set MagicBright manually,
; useActiveMonitorWhenMonitorOmitted=true: use the monitor of current active window.
; useActiveMonitorWhenMonitorOmitted=false: always use 1st monitor.
useActiveMonitorWhenMonitorOmitted := false ; Default value: false

; Whether to start Auto MagicBright upon the launching of this script.
startAutoMagicBrightByDefault := true ; Default value: true

; Time interval in Auto MagicBright to check acitve window. (Unit: millisecond)
autoMagicBrightTimerInterval := 500 ; Default value: 500

 ; (Unit: millisecond)
autoMagicBrightMinimumModeMaintainDuration := 5000 ; Default value: 5000

; Internal use. Do NOT change this value.
autoMagicBrightLastSetTime := A_TickCount

; True: Auto MagicBright will be valid when the active window is located in default monitor.
; False: Auto MagicBright will be valid whether the acitve window is located in any monitor.
autoMagicBrightCheckAllSamsungMonitors := false

; Format: ProcessName/ClassName/Title.
; ClassName and Title can be omitted (no slash needed).
; ProcessName, ClassName and Title are in AND relationship.
; If you want them in OR relationship, just write two or more entries.
; Process names are case insensitive, but class names are case sensitive.
; I assume that there is no slashes (/) in class names.
; If you have encountered any class name that contains a slash, please tell me. I will change the separator.
; Wildcards are not supported, but you can implement it by yourself.

; Exclude these processes in Auto MagicBright (do nothing when they are active), whether or not they are in full screen.
alwaysExclude := ["MagicTune.exe" ; MagicTune Premium.
	, "AutoHotkey.exe" ; AutoHotkey.
	, "explorer.exe/Shell_TrayWnd" ; Windows Taskbar.
	, "explorer.exe/Button" ; Windows Start button.
	, "explorer.exe/DV2ControlHost" ; Windows Start Menu.
	, "explorer.exe/NotifyIconOverflowWindow" ; Windows Notification popup.
	, "explorer.exe/ClockFlyoutWindow" ; Windows clock popup.
	, "explorer.exe/TaskSwitcherOverlayWnd" ; Alt+Tab list in Vista+.
	, "explorer.exe/TaskSwitcherWnd" ; Alt+Tab list in Vista+.
	, "dwm.exe/Flip3D" ; Win+Tab Flip3D.
	, "consent.exe" ; UAC window (but seems doesn't work).
	, "sidebar.exe/SideBar_AppBarBullet" ; Windows Vista Sidebar main module.
	, "sidebar.exe/SideBar_HTMLHostWindow" ; Windows Sidebar gadget.
	, "Workrave.exe"] ; Workrave.

; Normal means is not full screen.
; The purpose is not to set Game mode for not full screen window.
; It is for the windows that are actual full screen, but it tell you it is not.
normalSetGame := Object()

; It is actually only used for full screen Windows Media Player.
; Sometimes a control named "CWmpControlCntr" will be the active window when WMP is in full screen
; but the control is not full screen.
normalSetCinema := ["wmplayer.exe/CWmpControlCntr/FullScreenTopLayout"
	, "wmplayer.exe/CWmpControlCntr/FullScreenTopLayout"]

; When Auto MagicBright is enabled, if following process is active and in full screen, set MagicBright to Game mode.
; I only tested Windows games and Counter-Strike Source (hl2.exe) in the following list, others are untested.
; Games are too many, so you should add your games by yourself.
; You can launch these Windows 7 games in full screen mode from Windows Media Center.
fullScreenSetGame := ["chess.exe"
	, "Mahjong.exe"
	, "PurplePlace.exe"
	, "Hearts.exe"
	, "FreeCell.exe"
	, "SpiderSolitaire.exe"
	, "Solitaire.exe"
	, "hl2.exe" ; Counter-Strike Source.
	, "cstrike.exe"
	, "hl.exe"
	, "stream.exe"
	, "war3.exe"]

; When Auto MagicBright is enabled, if following process is active and in full screen, set MagicBright to Cinema mode.
fullScreenSetCinema := ["/ShockwaveFlashFullScreen" ; Adobe Flash in webpages.
	, "/AGFullScreenWinClass/Microsoft Silverlight" ; Silverlight in webpages.
	, "PicasaPhotoViewer.exe" ; Picasa Photo Viewer.
	, "googleearth.exe" ; Google Earth.
	, "KMPlayer.exe" ; KMPlayer.
	, "PotPlayerMini.exe" ; PotPlayer.
	, "GOM.exe" ; GOM Player.
	, "mpc-hc.exe" ; Media Player Classic - Home Cinema.
	, "wmplayer.exe" ; Windows Media Player.
	, "uTotalMediaTheatre5.exe" ; TotalMedia Theatre 5.
	, "ehshell.exe" ; Windows Media Center.
	, "TVUPlayer.exe"]

; Following text are used when loadResourceFromMagicTuneDll=false.
autoString := "Auto" ; Default value: "Auto"
magicBrightString := "MagicBright" ; Default value: "MagicBright"
insertSpaceBetweenAutoAndMagicBright := true ; Default value: true
onString := "ON" ; Default value: "ON"
offString := "OFF" ; Default value: "OFF"

waitingString := "……" ; Default value: "……"

; Whether or not to display OSD.
showOsd := true ; Default value: true

; See "Gui, Font" section in AutoHotkey help.
; Don't set the font size too large (say, greater than 50).
osdFontFamily := "Segoe UI" ; Default value: "Segoe UI"
osdFontSize := 28 ; Default value: 28
osdFontStyle := "w600 italic q5" ; Default value: "w600 italic q5"
osdColor := "Lime" ; Default value: "Lime"
osdTransparencyLevel := 180 ; Default value: 180

osdPreAllocateWidthText := "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"

; The OSD shows at the lower-right corner of the monitor (or working area),
; If you change the font size, you might want to slightly adjust the offset of OSD's location.
; If osdOffsetX is negative, OSD will move left; Otherwise, it will move right.
; If osdOffsetY is negative, OSD will move up; Otherwise, it will move down.
osdOffsetX := -6 ; Default value: -6
osdOffsetY := -7 ; Default value: -7

; How much time will OSD be shown (unless replaced by next message) (Unit: millisecond).
osdShowDuration := 2500 ; Default value: 2500

brightnessString := "Brightness" ; Default value: "Brightness"
contrastString := "Contrast" ; Default value: "Contrast"

; Internal use. Do NOT change this value.
isAutoMagicBrightFirstSetMode := true

; Settings region end ============================================================


magicTuneTitle := "MagicTune Premium ahk_class #32770"
scriptName := "MagicTune AutoHotkey script"

Initialize()

; Shortcuts region start ============================================================

; Start or restart Auto MagicBright.
#Numpad0::
#NumpadIns::
	StartAutoMagicBright(true)
return

; Stop Auto MagicBright.
#NumpadDot::
#NumpadDel::
	StopAutoMagicBright()
return

; Set MagicTune to Standard mode.
; You can also use SetMagicBright(1) (if your first mode is "Standard").
; If you want to set MagicBright mode of monitor 2, use SetMagicBright(standard, 2)
#Numpad1::
#NumpadEnd::
	SetMagicBright(standard)
return

; Set MagicTune to Game mode.
#Numpad2::
#NumpadDown::
	SetMagicBright(game)
return

; Set MagicTune to Cinema mode.
#Numpad3::
#NumpadPgdn::
	SetMagicBright(cinema)
return

; Set MagicTune to Custom mode.
#Numpad4::
#NumpadLeft::
	SetMagicBright(custom)
return

; Set MagicTune to Dynamic Contrast mode.
#Numpad5::
#NumpadClear::
	SetMagicBright(dynamicContrast)
return

; Show active window info.
#Numpad9::
#NumpadPgup::
	WinGet, processName, ProcessName, A
	WinGetClass, class, A
	WinGetActiveTitle, title
	WinGetPos, x, y, width, height, A
	WinGet, id, ID, A
	isFullScreen := "No"
	if (CheckWindowIsFullScreen(id))
	{
		isFullScreen := "Yes"
	}
	monitorNumber := GetMonitorIndexFromWindow(id)
	SysGet, mon, Monitor, %monitorNumber%
	monWidth := monRight - monLeft
	monHeight := monBottom - monTop
	global scriptName
	MsgBox, 0, %scriptName%, Info of active window:`n`nProcess name: %processName%`nClass name: %class%`nTitle: %title%`n`nIdentity string (internal use): %processName%/%class%/%title%`n`nLocation (x, y): %x%, %y%`nSize (w, h): %width%, %height%`nFull screen: %isFullScreen%`n`nMonitor number: %monitorNumber%`nMonitor location (x, y): %monLeft%, %monTop%`nMonitor size (w, h): %monWidth%, %monHeight%`n`n(Press Ctrl+C/Insert to copy this message.)
return

; Shortcuts region end ============================================================

#If WinActive(magicTuneTitle)

; Because hiding window from Close button or Okay button has a different effect than WinHide.
; The difference is described in MoveMagicTuneWindowToMonitor().
; So here if you are about to click Close button or Okay button, MagicTune will be hidden through WinHide.
~LButton::
	id := GetMagicTuneId()
	CoordMode, Mouse, Relative
	MouseGetPos, x, y, win
	
	; MagicTune is under the mouse cursor.
	; User is about to click (release mouse) close button or okay button.
	if ((win = id)
		and	(((565 <= x) and (x <= 603) and (1 <= y) and (y <= 16))
			or ((474 <= x) and (x <= 557) and (386 <= y) and (y <= 413))))
	{
		; This has no effect when notification icon is disabled,
		; so notification icon is forced to show when starting.
		WinHide, ahk_id %id%
	}
return

; Use Escape to hide MagicTune.
Escape::
	id := GetMagicTuneId()
	WinHide, ahk_id %id%
return

; Disable Alt+F4.
!F4::
!Space::
return

#If

Initialize()
{
	global

	RunMagicTune()
	
	RegRead, localRes, HKEY_CURRENT_USER, Software\Magic Tune\MagicTune\MONINFO, LocalRes
	
	languages := {"en": "Eng"
		, "de": "Ger"
		, "es": "Esp"
		, "fr": "Fra"
		, "hu": "Hgr"
		, "it": "Ita"
		, "ja": "Jap"
		, "ko": "Kor"
		, "pl": "Pol"
		, "pt": "Por"
		, "ru": "Rus"
		, "sv": "Swe"
		, "tr": "Tur"
		, "zh-Hans": "Chi"
		, "zh-Hant": "TChi"}
	
	if (localRes != "")
	{
		localRes := magicTunePath . "\" . localRes
	}
	
	customRes := ""
	
	if (useCustomLanguage)
	{
		customRes := languages[customLanguage]
		
		if (customRes != "")
		{
			customRes := magicTunePath . "\MTRes" . customRes . ".dll"
			
			IfExist, %customRes%
			{
				localRes := customRes
			}
		}
	}
	
	; Load strings from MagicTune resource dll.
	if (loadResourceFromMagicTuneDll and (localRes != ""))
	{
		IfExist, %localRes%
		{		
			; 0x2 = LOAD_LIBRARY_AS_DATAFILE.
			hModule := DllCall("LoadLibraryEx", "Str",localRes, "UInt",0, "UInt",0x2)
			
			customModeNames[standard]        := GetStringResourceFromDll(localRes, hModule, 337)
			customModeNames[text]            := GetStringResourceFromDll(localRes, hModule, 309)
			customModeNames[internet]        := GetStringResourceFromDll(localRes, hModule, 310)
			customModeNames[game]            := GetStringResourceFromDll(localRes, hModule, 338)
			customModeNames[sports]          := GetStringResourceFromDll(localRes, hModule, 314)
			customModeNames[cinema]          := GetStringResourceFromDll(localRes, hModule, 339)
			customModeNames[movie]           := GetStringResourceFromDll(localRes, hModule, 315)
			customModeNames[entertain]       := GetStringResourceFromDll(localRes, hModule, 311)
			customModeNames[custom]          := GetStringResourceFromDll(localRes, hModule, 316)
			customModeNames[dynamicContrast] := GetStringResourceFromDll(localRes, hModule, 318)
			autoString                       := GetStringResourceFromDll(localRes, hModule, 506)
			magicBrightString                := GetStringResourceFromDll(localRes, hModule, 124)
			onString                         := GetStringResourceFromDll(localRes, hModule, 477)
			offString                        := GetStringResourceFromDll(localRes, hModule, 478)
			brightnessString                 := GetStringResourceFromDll(localRes, hModule, 121)
			contrastString                   := GetStringResourceFromDll(localRes, hModule, 122)
			
			if (magicBrightString = "Samsung MagicBright")
			{
				magicBrightString := "MagicBright"
				insertSpaceBetweenAutoAndMagicBright := true
			}
			; This only occurs in Simplified Chinese.
			else
			{
				insertSpaceBetweenAutoAndMagicBright := false
			}
			
			; Convert onString / offString to uppercase.
			StringUpper, onString, onString
			StringUpper, offString, offString
			
			; Must free the library at the end.
			DllCall("FreeLibrary", "UInt",hModule)
		}
	}
	
	; Store last clicked DIFFERENT two modes (Used in SetMagicBright function).
	lastClickedTwoDifferentTwoModes := Object()

	Loop, %monitorCapacity%
	{
		if ((monitorsAreSamsung[A_Index]) and (monitorModes[A_Index].MaxIndex() != ""))
		{			
			; Here assumes that the monitor has more than two modes.
			lastClickedTwoDifferentTwoModes[A_Index] := [monitorModes[A_Index].MinIndex(), monitorModes[A_Index].MaxIndex()]
		}
		else
		{
			lastClickedTwoDifferentTwoModes[A_Index] := [0, 0]
		}
	}
	
	if (startAutoMagicBrightByDefault)
	{
		StartAutoMagicBright()
	}
}

GetStringResourceFromDll(dllPath, hModule, number)
{
	VarSetCapacity(string, 1024)
	DllCall("LoadString", "UInt",hModule, "UInt",number, "UInt",&string, "Int",1024)
	
	; Update the variable's internally-stored length to the length of its current contents.
	VarSetCapacity(string, -1)
	
	StringReplace, string, string, `r`n, %A_SPACE%, All
	StringReplace, string, string, `r, %A_SPACE%, All
	StringReplace, string, string, `n, %A_SPACE%, All
	
	return string
}

RunMagicTune()
{	
	DetectHiddenWindows, On
	SetTitleMatchMode, 3

	global magicTuneTitle
	global magicTunePath
	global magicTuneFullName
		
	RegRead, magicTunePath, HKEY_LOCAL_MACHINE, SOFTWARE\Magic Tune, InstallLocation

	IfWinNotExist, %magicTuneTitle%
	{
		isInstalled := true
		magicTuneFullName := ""
				
		If (magicTunePath = "")
		{
			isInstalled := false
		}
		
		if (isInstalled)
		{
			magicTuneFullName := magicTunePath . "\MagicTuneLauncher.exe"
			
			IfNotExist, %magicTuneFullName%
			{
				isInstalled := false
			}
		}
		
		if (isInstalled = false)
		{
			; 276 = Yes/No (4) + error icon (16) + make 2nd button default (256).
			MsgBox, 276, %scriptName%, MagicTune is not installed on your system,`nthis script will terminate.`n`nOpen MagicTune download page?
			IfMsgBox, Yes
			{
				Run, http://www.samsung.com/us/consumer/learningresources/monitor/magetune/pop_download.html
			}
			ExitApp
		}
		
		; Force to enable tray icon.
		
		RegRead, trayEnabled, HKEY_CURRENT_USER, Software\Magic Tune\MagicTune\Client, Task Tray Enable
		
		if (trayEnabled != 1)
		{
			RegWrite, REG_DWORD, HKEY_CURRENT_USER, Software\Magic Tune\MagicTune\Client, Task Tray Enable, 1
		}

		Run, %magicTuneFullName%
		
		WinWait, %magicTuneTitle%, , 60
		If ErrorLevel
		{
			MsgBox, 20, %scriptName%, MagicTune didn't start sucessfully. Reload this script?
			IfMsgBox, Yes
			{
				Reload
			}
			return
		}
		
		WinGet, id, ID, %magicTuneTitle%
		DismissIncompatibleMessageBox(id)
	}
}

; MagicTune is always started in monitor #1,
; if the first monitor is not Samsung, a "This Computer system does not support MagicTune" message box will popup.
; The same situation occurs after you move MagicTune to another incompatible monitor.
; This function here is to detect the message box and close it.
; I don't konw if the message box is shown, whether or not you can still move MagicTune to another monitor.
; I don't have the conditions to test it.
DismissIncompatibleMessageBox(id)
{
	; Not implemented.
}

; monitor is one-based.
SetMagicBright(mode, monitor=0, userSet=true)
{
	global
	
	if (userSet and timerIsEnabled)
	{
		MsgBox, 0, %scriptName%, You cannot set MagicBright mode manually when Auto MagicBright is turned on,`nplease turn off Auto MagicBright first.
		return
	}
	
	; Make sure do not call this function simultaneously twice.
	if (isSettingMode)
	{
		return
	}
	
	isSettingMode := true

	if monitor is not Integer
	{
		monitor := 0
	}
	
	tempDefaultMonitor := 0
	
	if (useActiveMonitorWhenMonitorOmitted)
	{
		WinGet, id, ID, A
		tempDefaultMonitor := GetMonitorIndexFromWindow(id)
	}
	else
	{
		tempDefaultMonitor := defaultMonitor
	}
	
	if (monitor = 0)
	{
		monitor := tempDefaultMonitor
	}
	
	SysGet, monitorCount, MonitorCount
	
	if ((monitor < 1) or (monitor > monitorCount))
	{
		monitor := tempDefaultMonitor
	}
	
	if (monitor > monitorCapacity)
	{
		; Do not use "return".
		goto, EndSet
	}
	
	if (monitorsAreSamsung[monitor] = false)
	{
		goto, EndSet
	}
	
	modeIndex := 0
	modeName := ""
	
	if mode is Integer
	{
		if (monitorModes[monitor].MaxIndex() != "")
		{
			if ((1 <= mode) and (mode <= monitorModes[monitor].MaxIndex()))
			{
				modeIndex := mode
				modeName := customModeNames[monitorModes[monitor][modeIndex]]
			}
		}
	}
	else
	{
		for index, value in monitorModes[monitor]
		{
			if (mode = value)
			{
				modeIndex := index
				modeName := customModeNames[value]
				
				break
			}
		}
	}
	
	if (modeIndex = 0)
	{
		if (userSet)
		{
			MsgBox, 16, %scriptName%, Specifed MagicBright mode is invalid.
		}
		
		goto, EndSet
	}	

	magicTuneId := GetMagicTuneId()
	
	if (magicTuneId < 0)
	{
		goto, EndSet
	}
	
	; If the command is called from user, because mode changing will take 1~2 sec to take effect,
	; so display some text to show that it is in process.
	if (userSet)
	{
		ShowOsd(waitingString, monitor, 10000)
	}
	
	monitorChanged := MoveMagicTuneWindowToMonitor(magicTuneId, monitor)
	
	; Delay some time between clicking "Picture" and "MagicBright".
	; the actual needed delay is about 300~400 ms.
	delay := 600
	
	; Click "Picture".
	PostClickMessage(magicTuneId, 72, 61)
	Sleep, delay

	; Click "MagicBright".
	PostClickMessage(magicTuneId, 45, 207)
	Sleep, delay
	
	modeX := 203
	modeYBase := 154
	modeYInterval := 32
	modeY := modeYBase + modeYInterval * (modeIndex - 1)
	
	; If you don't want to click last clicked mode, disable this variable.
	forceClickLast := false
	
	if (isAutoMagicBrightFirstSetMode or forceClickLast or monitorChanged)
	{
		; For my test result, because I use 1 physical monitor using two inputs,
		; So if MagicTune is moved to another window, sometimes its MagicBright won't reflect current monitor's real settings.
		; For example, MagicTune shows it is in Standard mode, but actually it is Cinema mode.
		; But you cannot click Standard mode because it is already checked.
		; You must click another mode first, then click Standard mode again.
		
		; This also often happens after you changed the resolution,
		; or the monitor is turned off and turned on again.
		
		isAutoMagicBrightFirstSetMode := false
		
		lastMode := lastClickedTwoDifferentTwoModes[monitor][1]
		
		if (modeIndex = lastMode)
		{
			lastMode := lastClickedTwoDifferentTwoModes[monitor][2]
		}
		
		lastModeY := modeYBase + modeYInterval * (lastMode - 1)
		
		PostClickMessage(magicTuneId, modeX, lastModeY)
		
		; This delay is to make sure the modes don't change too fast.
		Sleep, 1000
	}
	
	; Store last two (different) clicked modes.
	if (modeIndex != lastClickedTwoDifferentTwoModes[monitor][1])
	{
		lastClickedTwoDifferentTwoModes[monitor][2] := lastClickedTwoDifferentTwoModes[monitor][1]
		lastClickedTwoDifferentTwoModes[monitor][1] := modeIndex
	}
	
	; Click the specified MagicBright mode.
	PostClickMessage(magicTuneId, modeX, modeY)

	ShowOsd(modeName, monitor)

EndSet:
	isSettingMode := false
}

GetMagicTuneId()
{
	global
	
	DetectHiddenWindows, On
	SetTitleMatchMode, 3

	IfWinNotExist, %magicTuneTitle%
	{
		RunMagicTune()
	}
	
	; DetectHiddenWindows is turned off in RunMagicTune().
	DetectHiddenWindows, On
	SetTitleMatchMode, 3
	
	IfWinExist, %magicTuneTitle%
	{
		WinGet, id, ID, %magicTuneTitle%
		return, id
	}
	else
	{
		return, -1
	}
}

GetMonitorIndexFromWindow(windowHandle)
{
	; Monitor number is one-based.
	monitorIndex := 1

	VarSetCapacity(monitorInfo, 40)
	NumPut(40, monitorInfo)
	
	if (monitorHandle := DllCall("MonitorFromWindow", "UInt",windowHandle, "UInt",0x2)) 
		&& DllCall("GetMonitorInfo", "UInt",monitorHandle, "UInt",&monitorInfo) 
	{
		monitorLeft   := NumGet(monitorInfo,  4, "Int")
		monitorTop    := NumGet(monitorInfo,  8, "Int")
		monitorRight  := NumGet(monitorInfo, 12, "Int")
		monitorBottom := NumGet(monitorInfo, 16, "Int")
		workLeft      := NumGet(monitorInfo, 20, "Int")
		workTop       := NumGet(monitorInfo, 24, "Int")
		workRight     := NumGet(monitorInfo, 28, "Int")
		workBottom    := NumGet(monitorInfo, 32, "Int")
		isPrimary     := NumGet(monitorInfo, 36, "Int") & 1

		SysGet, monitorCount, MonitorCount

		Loop, %monitorCount%
		{
			SysGet, tempMon, Monitor, %A_Index%

			; Compare location to determine the monitor index.
			if ((monitorLeft = tempMonLeft) and (monitorTop = tempMonTop)
				and (monitorRight = tempMonRight) and (monitorBottom = tempMonBottom))
			{
				monitorIndex := A_Index
				break
			}
		}
	}
	
	return monitorIndex
}

; To make MagicTune perform actions on a monitor,
; You must move MagicTune window to the monitor first.
MoveMagicTuneWindowToMonitor(id, destMonitor)
{
	monitorChanged := false
	
	DetectHiddenWindows, On
	
	IfWinExist, ahk_id %id%
	{
		currentMonitor := GetMonitorIndexFromWindow(id)
		
		; Move window only when needed.
		if (destMonitor != currentMonitor)
		{
			; UNDONE
			WinGet, style, Style, ahk_id %id%
			WS_VISIBLE := 0x10000000
			visible := (style & WS_VISIBLE)
			
			WinGetPos, , , magicTuneWidth, magicTuneHeight, ahk_id %id%
			SysGet, work, MonitorWorkArea, %destMonitor%	

			; Must move MagicTune window to the center of Working Area.
			WinMove, ahk_id %id%, , ((workRight - workLeft - magicTuneWidth) / 2 + workLeft), ((workBottom - workTop - magicTuneHeight) / 2 + workTop)
			
			; Click title bar to trigger the detection of current monitor.
			; If MagicTune is hidden by clicking OK button or close button on the window,
			; this message will make MagicTune got focus (Even if it's hidden).
			PostClickMessage(id, 15, 15)
			
			; If MagicTune is visible, use a more stable apporach.
			if (false and visible)
			{
				DetectHiddenWindows, Off
				WinWaitClose, ahk_id %id%
				WinWait, ahk_id %id%
				DetectHiddenWindows, On
			}
			else
			{
				; The window is always hidden and exists, cannot use WinWaitClose and WinWait here.
				; So wait a long time for MagicTune to close and reappear.
				Sleep, 3000
			}
			
			DismissIncompatibleMessageBox(id)
			
			monitorChanged := true
		}
	}
	
	return montiorChanged
}

ShowOsd(message, monitor=1, customDuration=0)
{
	global 

	if (showOsd = false)
	{
		return
	}
	
	if monitor is not Integer
	{
		monitor := 1
	}
	
	SysGet, monitorCount, MonitorCount
	
	if ((monitor < 1) or (monitor > monitorCount))
	{
		monitor := 1
	}

	; It's a bad trick though.
	Gui, 1: Destroy

	customColor = FFFFFF  ; Can be any RGB color (it will be made transparent below).
	Gui +LastFound +AlwaysOnTop -Caption +ToolWindow  ; +ToolWindow avoids a taskbar button and an alt-tab menu item.
	Gui, Color, %customColor%
	Gui, Font, , Microsoft Sans Serif
	Gui, Font, , Tahoma
	Gui, Font, , Segoe UI
	Gui, Font, s%osdFontSize% %osdFontStyle%, %osdFontFamily%
	Gui, Add, Text, vmyText c%osdColor% Right, %osdPreAllocateWidthText% ; XX & YY serve to auto-size the window.

	SysGet, work, MonitorWorkArea, %monitor%
	SysGet, mon, Monitor, %monitor%
		
	; If current active window is in the specified monitor, and is not in full screen,
	; show OSD in the lower-right corner of working area.
	; Otherwise, show in lower-right corner of monitor.
	
	anchorRight := workRight
	anchorBottom := workBottom
	
	WinGet, id, ID, A
	inMonitor := GetMonitorIndexFromWindow(id)
	
	if (inMonitor = monitor)
	{
		WinGet, pid, PID, ahk_id %id%
		
		SetTitleMatchMode, 3
		WinGet, desktopId, ID, Program Manager ahk_class Progman
		WinGet, desktopPid, PID, ahk_id %desktopId%
	
		; Excluding Program Manager (Desktop), because desktop is always full screen.
		; Do not use "IfWinNotActive, Program Manager ahk_class Progman",
		; otherwise TransColor will not work. I dunno why.
		if ((id != desktopId) and (pid != desktopPid))
		{			
			; Current process (any window of it) is in full screen.
			if (CheckProcessIsFullScreen(id))
			{
				anchorRight := monRight
				anchorBottom := monBottom
			}
		}
	}
	
	GuiControlGet, myText, Pos
	
	osdX := anchorRight - myTextW - myTextX + osdOffsetX
	osdY := anchorBottom - myTextH - myTextY + osdOffsetY
	
	; Make all pixels of this color transparent and make the text itself translucent.
	WinSet, TransColor, %customColor% %osdTransparencyLevel%

	if (customDuration > osdShowDuration)
	{
		SetTimer, CloseOsd, %customDuration%
	}
	else
	{
		SetTimer, CloseOsd, -%osdShowDuration%
	}
	
	; Because of the italic font, last character doesn't show completely, so a space is appended.
	message := message . " "
	GuiControl, , myText, %message%
	
	; NoActivate avoids deactivating the currently active window.
	Gui, Show, x%osdX% y%osdY% NoActivate
return

CloseOsd:
	Gui, Destroy
return
}

CheckWindowIsFullScreen(id)
{
	WinGetPos, x, y, width, height, ahk_id %id%
	monitor := GetMonitorIndexFromWindow(id)
	SysGet, mon, Monitor, %monitor%
	
	if ((x = monLeft) and (y = monTop) and ((x + width) = monRight) and ((y + height) = monBottom))
	{
		return true
	}
	else
	{
		return false
	}
}

; ID of any window in the process.
CheckProcessIsFullScreen(id)
{
	isFullScreen := CheckWindowIsFullScreen(id)
	
	if (isFullScreen = false)
	{
		WinGet, pid, PID, ahk_id %id%
		DetectHiddenWindows, Off
		WinGet, list, List, ahk_pid %pid%
		
		Loop, %list%
		{
			thisId := list%A_Index%
			if (CheckWindowIsFullScreen(thisId))
			{
				isFullScreen := true
				break
			}
		}
	}
	
	return isFullScreen
}

PostClickMessage(handle, x, y)
{
	; Must detect hidden window, because MagicTune is usually closed to tray.
	DetectHiddenWindows, On
	
	lParam := y * 65536 + x
	
	; WM_MOUSEMOVE, must send mouse move message first. Dunno why must do that.
	PostMessage, 0x200, 0x00, %lParam%, , ahk_id %handle%
	
	; Actually, not necessary.
	Sleep, 10
	
	; WM_LBUTTONDOWN.
	PostMessage, 0x201, 0x01, %lParam%, , ahk_id %handle%
	
	; Not necessary.
	Sleep, 50
	
	; WM_LBUTTONUP.
	PostMessage, 0x202, 0x00, %lParam%, , ahk_id %handle%
}

StartAutoMagicBright(showOsd=true)
{
	StopAutoMagicBright(false)
	
	if (showOsd)
	{
		global autoString, magicBrightString, insertSpaceBetweenAutoAndMagicBright, onString
		
		message := autoString
		
		if (insertSpaceBetweenAutoAndMagicBright)
		{
			message := message . " " . magicBrightString
		}
		else
		{
			message := message . magicBrightString
		}
		
		message := message . ": " . onString
		ShowOsd(message, defaultMonitor)
	}

	global currentMagicTuneMode
	global timerIsEnabled
	currentMagicTuneMode := 0

	timerIsEnabled := true

	global autoMagicBrightTimerInterval, isAutoMagicBrightFirstSetMode
	isAutoMagicBrightFirstSetMode := true
	SetTimer, AutoMagicBright, %autoMagicBrightTimerInterval%
}

; If Auto MagicBright somewhat doesn't work well, call this to restart.
; For example, the monitor is auto turned off in Cinema mode (because media player is paused),
; after turned on, the mode is automatically back to Standard,
; but MagicTune can't reflect the change.
; TODO: Detect monitor on/off status in the future. (SPI_GETPOWEROFFACTIVE won't work in Vista+ OS.)
StopAutoMagicBright(showOsd=true)
{
	if (showOsd)
	{
		global autoString, magicBrightString, insertSpaceBetweenAutoAndMagicBright, offString
		
		message := autoString
		
		if (insertSpaceBetweenAutoAndMagicBright)
		{
			message := message . " " . magicBrightString
		}
		else
		{
			message := message . magicBrightString
		}
		
		message := message . ": " . offString
		ShowOsd(message, defaultMonitor)
	}
	
	global timerIsEnabled
	timerIsEnabled := false
	SetTimer, AutoMagicBright, Off
}

ToggleAutoMagicBright()
{
	if (timerIsEnabled)
	{
		StopAutoMagicBright()
	}
	else
	{
		StartAutoMagicBright()
	}
}

; Limitations: It will only check the active window of specified monitor.
; so if there is another full screen window in another monitor, the monitor won't set MagicBright.
AutoMagicBright:
	if (isSettingMode)
	{
		return
	}
	
	if (isInAutoMagicBright)
	{
		goto, EndAuto
	}
	
	isInAutoMagicBright := true
	
	WinGet, id, ID, A
	inMonitor := GetMonitorIndexFromWindow(id)
	
	; If check default monitor only.
	if ((autoMagicBrightCheckAllSamsungMonitors = false) and (inMonitor != defaultMonitor))
	{
		goto, EndAuto
	}
	
	if (inMontior > monitorCapacity)
	{
		goto, EndAuto
	}	
	
	if (monitorsAreSumsung[inMonitor] = false)
	{
		goto, EndAuto
	}

	WinGet, processName, ProcessName, ahk_id %id%
	WinGetClass, class, ahk_id %id%
	WinGetTitle, title, ahk_id %id%
	
	; Some weird window I've encourntered (when use Ctrl+O in full screen KMPlayer), processName/class/title are all blank.
	; Ingore it.
	if ((processName = "") and (class = "") and (title = ""))
	{
		goto, EndAuto
	}
	
	; Check all windows of the process.
	; There is some scenario that you open a dialog in a full screen media player.
	isFullScreen := CheckProcessIsFullScreen(id)	

	mode := ""

	if (MatchProcess(alwaysExclude, false, "", mode, processName, class, title, false))
	{
		goto, EndAuto
	}
	
	if (MatchProcess(normalSetGame, false, game, mode, processName, class, title, isFullScreen)
		or MatchProcess(normalSetCinema, false, cinema, mode, processName, class, title, isFullScreen)
		or MatchProcess(fullScreenSetGame, true, game, mode, processName, class, title, isFullScreen)
		or MatchProcess(fullScreenSetCinema, true, cinema, mode, processName, class, title, isFullScreen))
	{
	}
	else
	{
		mode := standard
	}

	modeToSet := 0
	
	; Find available mode in mode group.
	if (((mode = standard) and (modeToSet := GetModeFromGroup(monitorModes[inMonitor], standardGroup)))
		or ((mode = game) and (modeToSet := GetModeFromGroup(monitorModes[inMonitor], gameGroup)))
		or ((mode = cinema) and (modeToSet := GetModeFromGroup(monitorModes[inMonitor], cinemaGroup))))
	{
	}
	else
	{
		goto, EndAuto
	}

	if (modeToSet != currentMagicTuneMode)
	{
		if (isSettingMode != true)
		{
			if (A_TickCount < autoMagicBrightLastSetTime)
			{
				autoMagicBrightLastSetTime = A_TickCount
			}
			
			if (A_TickCount - autoMagicBrightLastSetTime >= autoMagicBrightMinimumModeMaintainDuration)
			{				
				SetMagicBright(modeToSet, inMonitor, false)
				currentMagicTuneMode := modeToSet
				autoMagicBrightLastSetTime := A_TickCount
			}
		}
	}

EndAuto:
	isInAutoMagicBright := false
return

MatchProcess(array, matchFullScreen, matchMode, ByRef mode, processName, class, title, isFullScreen)
{
	match := false
	
	if (IsObject(array))
	{
		if (isFullScreen = matchFullScreen)
		{
			for index, value in array
			{
				matchProcessName := value
				matchClass := ""
				matchTitle := ""
				
				if (firstSlash := InStr(value, "/", false, 1, 1))
				{
					matchProcessName := SubStr(value, 1, (firstSlash - 1))
					matchClass := SubStr(value, (firstSlash + 1))
					
					if (secondSlash := InStr(matchClass, "/", false, 1, 1))
					{
						matchClass := SubStr(matchClass, 1, (secondSlash - 1))
						matchTitle := SubStr(matchClass, (secondSlash + 1))
					}
				}
				
				if ((matchProcessName != "") or (matchClass != "") or (matchTitle != ""))
				{
					; For process name, perform a case-insensitve comparasion;
					; For class and title, perform a case-sensitive comparasion.
					if (((matchProcessName = "") or (processName = matchProcessName))
						and ((matchClass = "") or (class == matchClass))
						and ((matchTitle = "") or (title == matchTitle)))
					{
						mode := matchMode
						match := true
					}
				}
			}
		}
	}
	
	return match
}

GetModeFromGroup(modes, group)
{
	mode := 0
	
	for groupIndex, groupValue in Group
	{
		for modeIndex, modeValue in modes
		{
			if (modeValue = groupValue)
			{
				mode := modeIndex
				goto, EndGetMode
			}
		}
	}
	
EndGetMode:
	return mode
}

; USE FOLLOWING THREE FUNCTIONS AT YOUR OWN RISK!
; It's strongly NOT recommended to use these functions to adjust brightness and contrast.
; If you insist to use these, make sure brightness and contrast are all available in MagicTune window.
; For example, if you adjust brightness in Dynamic Contrast mode, it may DAMAGE your monitor.
; Multi-monitors are not supported, it will only affect the monitor which MagicTune is currently located at.
; If you really want multi-monitor support, you must move MagicTune window to the specified monitor,
; and click title bar (send mouse message) to activate it.

AdjustBrightness(brightness, customOsd="")
{
	AdjustBrightnessContrast(brightness, -1, customOsd)
}

AdjustContrast(contrast, customOsd="")
{
	AdjustBrightnessContrast(-1, contrast, customOsd)
}

AdjustBrightnessContrast(brightness, contrast, customOsd="")
{
	MsgBox, 48, %scriptName%, AdjustBrightnessContrast function is NOT recommended to use,`nIf you insist to use, read the warning in the source carefully and then comment out this MsgBox.
	return
	
	global isAdjusting
	
	if (isAdjusting)
	{
		goto, EndAdjust
	}
	
	isAdjusting := true
	
	id := GetMagicTuneId()
	
	if (id < 0)
	{
		goto, EndAdjust
	}
	
	brightnessIsValid := false
	
	if brightness is Integer
	{
		if ((0 <= brightness) and (brightness <= 100))
		{
			brightnessIsValid := true
			PostMessage, 0x28d1, 0x3f2, brightness, , ahk_id %id%
		}
	}
	
	contrastIsValid := false
	
	if contrast is Integer
	{
		if ((0 <= contrast) and (contrast <= 100))
		{
			contrastIsValid := true
			
			if (brightnessIsValid)
			{
				Sleep, 500
			}
			
			PostMessage, 0x28d2, 0x3f4, contrast, , ahk_id %id%
		}
	}
	
	brightnessOsd := ""
	contrastOsd := ""
	
	if (brightnessIsValid)
	{
		global brightnessString
		brightnessOsd := brightnessString . ": " . brightness
	}
	
	if (contrastIsValid)
	{
		global contrastString
		contrastOsd := contrastString . ": " . contrast
	}
	
	osdText := ""
	
	if (brightnessIsValid)
	{
		if (contrastIsValid)
		{
			osdText := brightnessOsd . " " . contrastOsd
		}
		else
		{
			osdText := brightnessOsd
		}
	}
	else
	{
		osdText := contrastOsd
	}
	
	if (customOsd != "")
	{
		osdText := customOsd
	}
	
	ShowOsd(osdText, monitor)
	
EndAdjust:
	isAdjusting := false
}
