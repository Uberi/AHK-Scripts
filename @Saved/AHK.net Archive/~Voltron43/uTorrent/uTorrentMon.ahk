;===============================================================================
;
; SCRIPT NAME: 	Remote uTorrent Monitor
; VERSION: 		v0.1.3
; DATE: 		4/29/09
; LINK:			http://www.autohotkey.com/forum/topic43055.htm 
;
; AUTHOR: 		Voltron43
; EMAIL: 		voltron43@gmail.com
; HOMEPAGE:		http://www.autohotkey.net/~Voltron43/
;
; ------------------------------------------------------------------------------
;
; DESCRIPTION:	This script is used to remotely monitor files downloading in
;				uTorrent v1.8.3 Beta using the WebUI 0.361
;
; FEATURES: 	-New download notification
;				-Finsihed download notification
; 				-ToolTip with download status
; 				-uTorrent connection status notification
; 				-Internet connection status notification
; 				-Pause all torrents	via Hotkey & context menu
; 				-UnPause all torrents via Hotkey & context menu
; 				-Stop torrents once torrent has reached set ratio
;				-Auto update
;				-Add new torrent via URL
;				-View Hotkeys via Alt+Shift+h
;				
; ------------------------------------------------------------------------------
; BIBLIOGRAPHY
; ------------------------------------------------------------------------------
;
; (1) uTorrent_WebUI_Connector.ahk
; 		Author: Twhyman
;		Title:	"[Functions]uTorrent Web Connector Library"
;		Link: 	http://www.autohotkey.com/forum/viewtopic.php?t=37127
; 
; (2) uTorrent WebUI
;		Author:	Ultima
;		Title:	"Web UI API"
;		Link: 	http://forum.utorrent.com/viewtopic.php?id=25661 
; 
; (3) Library for Text File Manipulation
; 		Author: heresy
;		Title:	"Library for Text File Manipulation"
;		Link: 	http://www.autohotkey.com/forum/viewtopic.php?t=32757
;
; (4) KeyList.ahk
;		Author: Vixay Xavier
;		Title:	"Display and Sort Hotkeys"
;		Link:	http://www.autohotkey.com/forum/topic215.html
;
; (5) httpQuery.ahk
; 		Author: DerRaphael
;		Title:	"[function] httpQuery GET and POST requests - update 0.3.4"
;		Link:	http://www.autohotkey.com/forum/viewtopic.php?t=33506
;
; (6) Hash
; 		Author:	Laszlo
;		Title:	MD5
;		Link: 	http://www.autohotkey.com/forum/viewtopic.php?p=113252#113252
;
; (7) Write Binary File - Example III
; 		Author: DerRaphael
;		Title:	"[function] httpQuery GET and POST requests - update 0.3.4"
;		Link:	http://www.autohotkey.com/forum/viewtopic.php?t=33506
;
; (8) Auto Updater
;		Author:	DerRaphael
;		Title:	"[function] AutoUpdater 1.1-yet another selfupdating function"
;		Link:	http://www.autohotkey.com/forum/viewtopic.php?t=34583
;
; (9) AHK_NOTIFYICON
;		Author:	animeaime
;		Title:	"Yet another right menu thing...but I think this works..."
;		Link:	http://www.autohotkey.com/forum/topic38338.html
;
; (10) ini.ahk v1.08
;		Author:	Titan
;		Title:	"INI Library"
;		Link: 	http://www.autohotkey.net/~Titan/#ini
;
; ------------------------------------------------------------------------------
; CHANGE LOG:
; ------------------------------------------------------------------------------
; 
;	v0.1.3	04/29/09	-Added Auto Update
;						-Merged all AHK files into one
;						-Added References (6), (7), (8), (9) & (10)
;						-Moved icons to icons directory
;						-Auto download of icons
;						-Switched from using UrlDownloadToFile to httpQuery
;						-Added settings to context menu & HotKeys
;						-Prompt Connection settings GUI if empty
;						-Auto paste Torrent URL in New Torrent dialog box
;						-Renamed Add Torrent -> New Torrent
;
;	v0.1.2	04/13/09	-Reformat INI file
;						-Added StopRatio
;						-Added Exit Hotkey
;
;	v0.1.1	04/12/09	-Added Add Torrent feature
;						-Fixed DOWNLOAD_Field
;						-Fixed ToolTip format
;						-Added uTorrentFileStatus function
;						-Made StartupNotifications functional
;
; ------------------------------------------------------------------------------
; TODO
; ------------------------------------------------------------------------------
;
; 	4/30/09
;	[ ]	-icon md5
;	[ ] -INI md5
;	[ ] -Settings GUI
;	[ ] -Auto update error msgbox, take to download site
;	[ ] -About GUI
;	[ ] -Proxy support
;	[ ] -Timer issue
;	[ ] -httpQuery timout
;	[X] -Check old hash/name with new hash/name to reset balloons
;	[X] -New download notification
;	[X] -Shorten gettings uTor values with loops
;	[X] -test update
; 	[X]	-Paste URL in Add Torrent from clipboard
;	[X]	-test httpQuerry for Add Torrent command
;	[X]	-copy ini settings during update
;	[X] -make restart on update functional
;	[X] -archives directory
;	[X] -Input box/check for username/pw
;	[X] -Connection Settings GUI error
;	[X] -Settings GUI Esc
;	[X] -Make read ini section shorter
;
;===============================================================================
; INCLUDED SCRIPTS
; ------------------------------------------------------------------------------

; ------------------------------------------------------------------------------
; INITIAL COMMANDS
; ------------------------------------------------------------------------------

#Persistent
#SingleInstance, Force
#NoEnv

; ---Get name of script and then name the input data file and output ini
SplitPath,A_ScriptFullPath,,,Extension,File_Name
SetWorkingDir, %A_ScriptFullPath%				; Set working directory to script directory
File_Input=%A_Temp%\%File_Name%.data			; Name data file [script_name].data
File_Output=%File_Name%.ini						; Name ini file [script_name].ini

; ---Write default ini if it does not already exist
IfNotExist, %File_Output%
	DefaultIni(File_Output)

; ---Write script modified date to ini file
Loop, %File_Name%.%Extension%
{
	ThisVersionTime=%A_LoopFileTimeModified%
	IniWrite, %ThisVersionTime%, %File_Output%, General, ThisVersionTime
}

; ---Submenu									  ______________
Menu, Submenu1, Add, Connection, GuiConn	 ;|> | Connection	|
Menu, Submenu1, Add, General, Settings			;|_General______|

; ---Icon context menu							  ______________
Menu, MyMenu, Add, WebUI, Chrome				;| WebUI		|
Menu, MyMenu, Add								;|--------------|
Menu, MyMenu, Add, New Torrent, NewTorrent		;| New Torrent	|
Menu, MyMenu, Add, Pause All, PauseAll			;| Pause All	|
Menu, MyMenu, Add, Resume All, UnPauseAll		;| Resume All	|
Menu, MyMenu, Add								;|--------------|
Menu, MyMenu, Add, Settings, :Submenu1			;| Settings	 |> |
Menu, MyMenu, Add								;|--------------|
Menu, MyMenu, Add, Exit, ExitProgram			;|_Exit_________|
Menu, MyMenu, Default, WebUI
OnMessage(0x404, "AHK_NOTIFYICON")				

; ------------------------------------------------------------------------------
; Read INI File
; ------------------------------------------------------------------------------

; ---Load INI file
ini_Load(File,File_Output)

; ---Read INI sections and trim
Sections := ini_GetSections(File)
StringTrimLeft, Sections, Sections,1
StringTrimRight, Sections, Sections,1

; ---Read keys in sections
Loop, Parse, Sections,`n
{
	sec=%A_LoopField%
	var:=ini_GetKeys(File, A_LoopField)
	StringTrimRight, var,var,1
	%sec%:=var
	
	; ---Get value of keys
	Loop, Parse, %A_LoopField%,`n
	{
		key=%A_LoopField%
		var:=ini_Read(File,sec,A_LoopField)
		%key%:=var
	}
}

; ---Remove period from StopRatio
StringReplace, StopRatio,StopRatio,.	

; ------------------------------------------------------------------------------
; PRE LOOP
; ------------------------------------------------------------------------------

; ---Change to custom icon.
IconChange()

; ---Check for update
If (ShouldDoUpdate=1)
	UpdateMySelf(1)

; ---Check to see if uTorrent connection info is present
IF (!uTorrent_Address OR !uTorrent_Username OR !uTorrent_Password OR !uTorrent_Port)
{	
	IconChange("yellow")
	GOTO, GuiConn
}	

PreLoop:

; ---Check uTorrent status. Loop until connection has been made
uTorrentStatus(File_Input)

; ---Count the number of torrents.
TorCount:=uTorrent_TorrentCount(File_Input)

; ---Checks if torrents are finished upon initiation of script.
IF StartupNotifications=1
	ResetTrayTips(TorCount)

; ---Property fields to obtain during loop
PropFields=NAME,HASH,DOWNLOADED,SIZE,PERCENT_PROGRESS,RATIO,STATUS

; ------------------------------------------------------------------------------
; MAIN LOOP START
; ------------------------------------------------------------------------------

SetTimer, uTorrent, %RefreshRate%

uTorrent:
	; ---Check uTorrent connection status.
	uTorrentStatus(File_Input)
	; ---Count number of torrents
	TorCount:=uTorrent_TorrentCount(File_Input)
	; ---Reset finished tooltip
	ToolTipFinished=
	; ---Reset downloading tooltip
	ToolTipDownload=
	; ---Reset tooltip
	Name_Array=
	
	; ---Start Torrent loop.  Loop once for each torrent
	Loop, %TorCount%
	{
		TorNum=%A_Index%
		Loop, Parse, PropFields,`,
		{
			%A_LoopField%_%TorNum%:=uTorrent_TorrentProperties(File_Input, TorNum, A_LoopField)
			%A_LoopField%_Field:=%A_LoopField%_%TorNum%
		}
			
		;---Reformat name field.  Take first 5 delimiters
		NAME_Field=
		StringSplit, tmp, NAME_%A_Index%,.,
		Loop, 5
		{
			var:=tmp%A_Index%
			NAME_Field=%NAME_Field%%A_Space%%var%
		}
		
		; ---HASH Array
		HASH_Array=%HASH_Array%,%HASH_Field%
		
		; ---Reset TrayTips if new download
		If(StartupNotifications=1 && !RegExMatch(HASH_Old,HASH_Field))
		{
			NewDL_%A_Index%=0
			StatChange_%A_Index%=0
		}
		
		; ---StatChange
		StatChange_Field:=StatChange_%A_Index%
		NewDL_Field:=NewDL_%A_Index%
		
		; ---Convert STATUS Field from number to words
		STATUS_Field:=uTorrentFileStatus(STATUS_Field, PERCENT_PROGRESS_Field)
		
		; ---New download TrayTip
		IF (DOWNLOADED_%A_Index%<5000000) && (NewDL_Field=0)
		{
			; ---TrayTip
			TrayTip, New Download,%Name_Field% has started downloading!,,1
			sleep %TrayTipDelay%
			TrayTip
			; ---Prevent TrayTip from showing up again on the next loop
			NewDL_%A_Index%++
		}
			
		; ---Torrent download finished	
		IF (DOWNLOADED_Field=SIZE_Field && StatChange_Field=0)
		{
			; ---TrayTip
			TrayTip, Download Complete,%Name_Field% has finished downloading!,,1
			sleep %TrayTipDelay%
			TrayTip
			; ---Prevent TrayTip from showing up the next loop
			StatChange_%A_Index%++
		}
		
		PERCENT_PROGRESS_Field:=PercentDownload(PERCENT_PROGRESS_Field)
		
		; ---Create tooltip for finished torrents
		IF (DOWNLOADED_Field=SIZE_Field)
			ToolTipFinished=%ToolTipFinished%`n%PERCENT_PROGRESS_Field% - %Name_Field% 
		
		; ---Torrent still downloading
		ELSE IF (DOWNLOADED_Field<>SIZE_Field)
			ToolTipDownload=%ToolTipDownload%`n%PERCENT_PROGRESS_Field% - %Name_Field%	
		
		; ---Stop torrent if ratio is satisfied
			IF (StopSeeding=1 && STATUS_Field="Seeding" && RATIO_Field>=StopRatio)
					uTorrent_TorrentAction(Hash_%A_Index%, "stop",URL=0)
	}
	
	; ---Keep track of old HASH array
	HASH_Old=%HASH_Array%
	HASH_Array=
	
	; ---Format ToolTip
	NAME_Array=[ %ScriptName% - %Version% ]
	IF ToolTipFinished!=
	{
		StringReplace, ToolTipFinished,ToolTipFinished,`n
		NAME_Array=%NAME_Array%`n%ToolTipFinished%
	}
		
	IF ToolTipDownload!=
	{
		StringReplace, ToolTipDownload,ToolTipDownload,`n
		NAME_Array=%NAME_Array%`n%ToolTipDownload%
	}
	Menu, Tray, Tip, %NAME_Array%
Return

; ------------------------------------------------------------------------------
; HOTKEYS QUICK REFERENCE
; ------------------------------------------------------------------------------
;
; 	+	Shift	
; 	!	Alt
; 	#	Win
; 	^	Ctrl
;
; ------------------------------------------------------------------------------
; HOTKEYS
; ------------------------------------------------------------------------------
; ---Add double semicolon, ";;" in front of hotkey name to show in KeyList window.

+!a:: GOTO, NewTorrent		;;Add Torrent
+!c:: GOTO, GuiConn			;;Connection Settings
+!u:: GOTO, Chrome			;;WebUI
+!h:: GOTO, HotkeyList		;;HotKeys
+!p:: GOTO, PauseAll		;;Pause All
+!r:: GOTO, UnPauseAll		;;Resume All
+!s:: GOTO, Settings		;;Settings
+!x:: GOTO, ExitProgram		;;Exit  

; ---Esc key exits settings GUI
Hotkey, IfWinActive, ahk_class AutoHotkeyGUI
Esc:: Goto ButtonCancel

; ==============================================================================
; HOTKEY COMMANDS
; ==============================================================================

GuiConn:
	; ---Gui Options
	Gui, Destroy
	Gui +AlwaysOnTop -SysMenu +Owner

	; ---uTorrent Connection Gui 	
; 	Gui	 	Sub-Com	Param2		Param3						Param4							Default Values
; -------------------------------------------------------------------------------------------------------------
	Gui, 	Add, 	Text,		,							Address:
	Gui, 	Add, 	Text,		,							User Name:
	Gui, 	Add, 	Text,		,							Password:
	Gui, 	Add, 	Text,		,							Port:
	Gui, 	Add, 	Button, 	xp+40 yp+30 w50	default, 	OK
	Gui, 	Add, 	Edit, 		x70 ym w150					vuTorrent_Address, 					%uTorrent_Address%
	Gui, 	Add, 	Edit, 		w150 						vuTorrent_Username,					%uTorrent_Username%
	Gui, 	Add, 	Edit, 		w150 						vuTorrent_Password Password,		%uTorrent_Password%
	Gui, 	Add, 	Edit, 		w35 						vuTorrent_Port,						%uTorrent_Port%
	Gui, 	Add, 	Button,		xp+60 yp+30 w50, 			Cancel
	Gui, 	Show,	,										uTorrent Login Info
return

ButtonCancel:
	Gui, Cancel
	GOTO, PreLoop
Return

ButtonOK:
	IconChange()
	Gui, Submit
	Loop, Parse, Connection,`n,
	{
		var:=%A_LoopField%
		IniWrite, %var%, %File_Output%, Connection, %A_LoopField%
	}
	GOTO, PreLoop
Return

RemoveTrayTip:
	SetTimer,RemoveTrayTip,Off
	TrayTip
Return

NewTorrent:
	; ---Copy clipboard contents
	var=%Clipboard%
	; ---Check to see if clipboard contents is a url
	If var contains http,www,.com,.net,.org,.torrent
		Contents=%var%
	; ---Input box.  Paste clipboard if it contains a url
	InputBox, URL, New Torrent, Enter Torrent URL,,400,120,,,,,%Contents%
	uTorrent_TorrentAction(HASH,"add-url",URL)
Return

PauseAll:
	; ---Get the list of torrents
	uTorrent_GetTorrentList(File_Input)
	; ---Count the number of torrents
	TorCount:=uTorrent_TorrentCount(File_Input)
	; ---Pause each torrent
	Loop %TorCount%
	{
		HASH_%A_Index%:=uTorrent_TorrentProperties(File_Input,A_Index, "HASH")
		HASH_Field:=HASH_%A_Index%
		uTorrent_TorrentAction(Hash_%A_Index%, "pause")
	}
	; ---TrayTip
	TrayTip, uTorrent, Pause All,,1
	Sleep, %TrayTipDelay%
	TrayTip
	GOTO, uTorrent
Return

UnPauseAll:
	seAll:
	Result:=uTorrent_GetTorrentList(File_Input)

	TorCount:=uTorrent_TorrentCount(File_Input)
	
	Loop %TorCount%
	{
		HASH_%A_Index%:=uTorrent_TorrentProperties(File_Input,A_Index, "HASH")
		HASH_Field:=HASH_%A_Index%
		uTorrent_TorrentAction(Hash_%A_Index%, "unpause")
	}
	; ---TrayTip
	TrayTip, uTorrent, Resume All,,1
	Sleep, %TrayTipDelay%
	TrayTip
	GOTO, uTorrent
Return

HotkeyList:
	If A_IsCompiled { 
		StringTrimRight, script, A_ScriptFullPath, 3 
		script = %script%ahk 
	} 
	Else { 
		script = %A_ScriptFullPath% 
	} 
	KeyList(script) 
	Sleep 2000 
	KeyWait, h 
	Progress, off 
Return

ExitProgram:
	ExitApp
Return

Chrome:	
	App=--app=http://%uTorrent_Username%:%uTorrent_Password%@%uTorrent_address%:%uTorrent_Port%/gui
	If ChromeApp=1
	{
		; ---Get Application Data directory
		path=%A_AppData%
		
		; ---If OS is Vista
		If A_OSVersion in WIN_VISTA
		{
			; ---Go up one directory
			StringReplace, path, path, \Roaming
			; ---Chrome .exe path
			ChromePath=%path%\Local\Google\Chrome\Application\chrome.exe
		}	
		
		; ---If OS is not Vista
		Else
		{
			; ---Go up one directory
			StringReplace, path, path, \Application Data
			; ---Chrome .exe path
			ChromePath=%path%\Local Settings\Application Data\Google\Chrome\Application\chrome.exe
		}
		; --Launch Chrome
		IfExist, %ChromePath%
			Run %ChromePath% %App%	
	}
	Else
	{
		StringReplace, App, App, --app=
		Run %App%
	}
Return

Settings:
	IfExist %File_Output%
		Run, %File_Output%
Return

; ==============================================================================
; FUNCTIONS
; ==============================================================================
ResetTrayTips(TorCount) {
	Global
	Loop %TorCount%
	{
		StatChange_%A_Index%=0
		NewDL_%A_Index%=0
	}
	Return
}
; ---Get torrent status
uTorrentFileStatus(STATUS, PERCENT_PROGRESS){
	IF STATUS=128
		STATUS=Stopped
	Else IF STATUS=130
		STATUS=Checking
	ELSE IF STATUS=152
		STATUS=Error
	ELSE IF STATUS=169
		STATUS=Paused
	ELSE IF STATUS=233
		STATUS=Paused
	ELSE IF STATUS=136
	{
		IF PERCENT_PROGRESS=1000
			STATUS=Finished
		IF PERCENT_PROGRESS<1000
			STATUS=Stopped
	}
	ELSE IF STATUS=137
	{
		IF PERCENT_PROGRESS=1000
			STATUS=[F] Seeding
		IF PERCENT_PROGRESS<1000
			STATUS=[F] Downloading
	}
	ELSE IF STATUS=200
	{
		IF PERCENT_PROGRESS=1000
			STATUS=Queued
		IF PERCENT_PROGRESS<1000
			STATUS=Queued
	}
	ELSE IF STATUS=201
	{
		IF PERCENT_PROGRESS=1000
			STATUS=Seeding
		IF PERCENT_PROGRESS<1000
			STATUS=Downloading
	}
	RETURN, %STATUS%
}

; ---Percent download format
PercentDownload(num)	{
	StringLen,Length,num
	If Length<2
		numL=0
	Else
		StringTrimRight, numL, num,1
	StringRight, numR, num,1
	num=%numL%.%numR%`%
	Return, %num%
}

; ---Internet connection test
ConnectedToInternet(flag=0x40) { 
	Return DllCall("Wininet.dll\InternetGetConnectedState", "Str", flag,"Int",0)
}

; ---Change icon
IconChange(color="green")	{
Global TrayIcons,Server,IconDir,ProgressBar
	If TrayIcons=1
	{
		IfNotExist, icons
			FileCreateDir, icons
		IconColors=green,yellow,red
		Loop, Parse, IconColors,`,	
		{
			IfNotExist, icons\icon_%A_LoopField%.ico
			{
				IconFile = icon_%A_LoopField%.ico
				length := httpQuery(data := "",Server IconDir IconFile)
				prog:=Round((A_Index/3)*100)
				If ProgressBar=1
					Progress, %prog%,, Downloading icon_%A_LoopField%.ico,Downloading Icons
				write_bin(data,IconFile,length)
				Sleep, 500
				If prog=100
					Progress, off
				FileMove, %IconFile%, icons/%IconFile%
			}
		}
		IfExist, icons\icon_%color%.ico
				Menu, Tray, icon, icons\icon_%color%.ico
	}
}

; ---Check to see if connected to Internet	
ConnectionStatus(color="green")	{
	global TrayTipDelay
	IntConnStatus=0
	While ConnectedToInternet() = 0  {
		If IntConnStatus=0
		{
			IconChange("red")
			TrayTip, Internet Connection,Internet connection lost!,,3
			Sleep, %TrayTipDelay%
			TrayTip
			IntConnStatus=1
			NAME_Array=No Internet Connection...
			Menu, Tray, Tip, %NAME_Array%
		}
	}
	; ---Check is Internet connection is up
	If IntConnStatus=1
	{
		IconChange(color)
		TrayTip, Internet Connection,Now connected!,,1
		Sleep, %TrayTipDelay%
		TrayTip
		IntConnStatus=0
	} 
	Return, %IntConnStatus%   
}

; ---Check to see if uTorrent is up and running
uTorrentStatus(File_Input)	{
	global TrayTipDelay
	uTorrentStatus=0
	uTorrent_GetTorrentList(File_Input)
	While uTorrent_GetTorrentList(File_Input)=1 {
		ConnectionStatus("yellow")	
		
		If uTorrentStatus=0	; uTorrent is down
		{
			; ---Change icon to yellow
			IconChange("yellow")
			; ---TrayTip
			TrayTip, uTorrent Status, uTorrent is not running!,,2
			Sleep, %TrayTipDelay%
			TrayTip
			uTorrentStatus=1
			NAME_Array=uTorrent is not running...
			Menu, Tray, Tip, %NAME_Array%
		}
	}
	If uTorrentStatus=1 	; uTorrent is up and running
	{
		; ---Change icon to green
		IconChange()
		; ---TrayTip
		TrayTip, uTorrent Status, uTorrent is now running!,,1
		Sleep, %TrayTipDelay%
		TrayTip
		uTorrentStatus=0
	}
	Return
}

; ------------------------------------------------------------------------------
; AHK NOTIFYICON (9)
; ------------------------------------------------------------------------------

AHK_NOTIFYICON(wParam, lParam)
{
    global 	  MouseDownMenuLocX
			, MouseDownMenuLocY
			, uTorrent_Password
			, uTorrent_Username
			, uTorrent_address
			, uTorrent_Port
			, ChromeApp

    if (lParam = 0x201 || lParam = 0x204)
    {
        ;WM_LBUTTONDOWN || WM_RBUTTONDOWN
        MouseGetPos, MouseDownMenuLocX, MouseDownMenuLocY
        return 0
    }
    else if (lParam = 0x202) ; WM_LBUTTONUP
    {
        MouseGetPos, MouseX, MouseY
		App=--app=http://%uTorrent_Username%:%uTorrent_Password%@%uTorrent_address%:%uTorrent_Port%/gui
        If ChromeApp=1
        {
			; ---Get Application Data directory
			path=%A_AppData%
			
			If A_OSVersion in WIN_VISTA
			{
				; ---Go up one directory
				StringReplace, path, path, \Roaming
				; ---Chrome .exe path
				ChromePath=%path%\Local\Google\Chrome\Application\chrome.exe
			}	
			Else
			{
				; ---Go up one directory
				StringReplace, path, path, \Application Data
				; ---Chrome .exe path
				ChromePath=%path%\Local Settings\Application Data\Google\Chrome\Application\chrome.exe
			}
			; --Launch Chrome
			IfExist, %ChromePath%
				Run %ChromePath% %App%	
		}
		Else
		{
			StringReplace, App, App, --app=
			Run %App%
		}
        return 0
    }
    else if (lParam = 0x205) ; WM_RBUTTONUP
    {
        MouseGetPos, MouseX, MouseY
		; ---Show context menu
        Menu, MyMenu, Show, %MouseDownMenuLocX%, %MouseDownMenuLocY%
        return 0
    }
}

; ------------------------------------------------------------------------------
; UTORRENT WEBUI CONNECTOR LIBRARY (1)
; ------------------------------------------------------------------------------                                                                                                     
; ---Grabs all of details of the currently loaded torrent on uTorrent to a file.
uTorrent_GetTorrentList(File_Output)	{
	Global uTorrent_address,uTorrent_Port,uTorrent_Username,uTorrent_Password
	FileDelete, %File_Output%
	url=http://%uTorrent_Username%:%uTorrent_Password%@%uTorrent_address%:%uTorrent_Port%/gui/?
	postdata:="list=1"
	httpQuery(data:="",url postdata)
	VarSetCapacity(data,-1)
	StringSplit, tmp,data,:				; Get first delimiter before the ":"
	StringReplace, tmp,tmp1,{			; Remove the brace "{"
	if tmp="build"						; Check to see if the first delim is "build"
	{
		FileAppend,%data%,%File_Output%		
		Return,0
	}
	Return,1
}

; ---Count how many torrents are currently loaded in uTorrent
uTorrent_TorrentCount(File_Input)
{
  Total_Torrents=0

  Loop, Read, %File_Input%
  {
    Current_Line_Number=%A_Index%
    ; ---Get first delim
    Current_Delim_TXT:=TXT_GetCSV(File_Input,Current_Line_Number) 
    ; ---Get length of first delim
    Current_Delim_Length:=StrLen(Current_Delim_TXT)	
	; ---Check to see if length of first delim is length of Hash
	If Current_Delim_Length=43 
		Torrent_Line:=1
	else
		Torrent_Line:=0
	
    If (Torrent_Line=1)
     Total_Torrents++
  }
  Return, %Total_Torrents%
}

; ---Grab all properties of a torrent or a specific property.
uTorrent_TorrentProperties(File_Input,Torrent_Number,Single_Item=False)
{
  Requested_Torrent=0
  
  Loop, Read, %File_Input%
  {
    Current_Line_TXT=%A_LoopReadLine%
    Current_Line_Number=%A_Index%

	Current_Delim_TXT:=TXT_GetCSV(File_Input,Current_Line_Number)
    Current_Delim_Length:=StrLen(Current_Delim_TXT)
	
	If Current_Delim_Length=43
		Torrent_Line:=1
	else
		Torrent_Line:=0

    If (Torrent_Line=1)
     Requested_Torrent++
    
    If(Requested_Torrent=Torrent_Number)
    {
      RegexMatch(Current_Line_TXT,"^\[""(.*?)""
										,(\d{3})
										,""(.*?)""
										,(.*?)
										,(.*?)
										,(.*?)
										,(.*?)
										,(.*?)
										,(.*?)
										,(.*?)
										,(.*?)
										,""(.*?)""
										,(.*?)
										,(.*?)
										,(.*?)
										,(.*?)
										,(.*?)
										,(.*?)
										,(.*?)\]"
										,R_Torrent_Line)
    
      HASH=%R_Torrent_Line1%
      STATUS=%R_Torrent_Line2%
      NAME=%R_Torrent_Line3%
      SIZE=%R_Torrent_Line4%
      PERCENT_PROGRESS=%R_Torrent_Line5%
      DOWNLOADED=%R_Torrent_Line6%
      UPLOADED=%R_Torrent_Line7%
      RATIO=%R_Torrent_Line8%
      UPLOAD_SPEED=%R_Torrent_Line9%
      DOWNLOAD_SPEED=%R_Torrent_Line10%
      ETA=%R_Torrent_Line11%
      LABEL=%R_Torrent_Line12%
      PEERS_CONNECTED=%R_Torrent_Line13%
      PEERS_IN_SWARM=%R_Torrent_Line14%
      SEEDS_CONNECTED=%R_Torrent_Line15%
      SEEDS_IN_SWARM=%R_Torrent_Line16%
      AVAILABILITY=%R_Torrent_Line17%
      TORRENT_QUEUE_ORDER=%R_Torrent_Line18%
      REMAINING=%R_Torrent_Line19%
      
      If(Single_Item!=False)
      {
        Req_Value:=%Single_Item%
        Return, Req_Value
      }
      Torrent_Properties_Array=%HASH%`
								,%STATUS%`
								,%NAME%`
								,%SIZE%`
								,%PERCENT_PROGRESS%`
								,%DOWNLOADED%`
								,%UPLOADED%`
								,%RATIO%`
								,%UPLOAD_SPEED%`
								,%DOWNLOAD_SPEED%`
								,%ETA%`
								,%LABEL%`
								,%PEERS_CONNECTED%`
								,%PEERS_IN_SWARM%`
								,%SEEDS_CONNECTED%`
								,%SEEDS_IN_SWARM%`
								,%AVAILABILITY%`
								,%TORRENT_QUEUE_ORDER%`
								,%REMAINING%
								
      Return, %Torrent_Properties_Array%
    }
  }
 Return, -1
}

; ---Perform any of the following actions on a torrent
; ---	start, add-url, stop, pause, removedata, remove, recheck, forcestart, unpause
uTorrent_TorrentAction(Torrent_Hash, Action,URL=0)
{
	Global uTorrent_address,uTorrent_Port,uTorrent_Username,uTorrent_Password
	baseurl=http://%uTorrent_Username%:%uTorrent_Password%@%uTorrent_address%:%uTorrent_Port%/gui/?
	If (URL!=0)
	{
;   	UrlDownloadToFile, http://%uTorrent_Username%:%uTorrent_Password%@%uTorrent_address%:%uTorrent_Port%/gui/?action=%Action%&s=%URL% ,%A_Temp%\junk.txt
		postdata:="action=" Action "&s=" URL
	}
	Else
	{
		;UrlDownloadToFile, http://%uTorrent_Username%:%uTorrent_Password%@%uTorrent_address%:%uTorrent_Port%/gui/?action=%Action%&hash=%Torrent_Hash% ,%A_Temp%\junk.txt
		postdata:="action=" Action "&hash=" Torrent_Hash
	}
	httpQuery(data:="",baseurl postdata)
	VarSetCapacity(data,-1)
  If (ErrorLevel=0)
  {
    ;FileDelete, %A_Temp%\junk.txt
    Return, 0
  }
  Else
  Return, 1
}

; ------------------------------------------------------------------------------
; TEXT FILE MANIPULATION (3)
; ------------------------------------------------------------------------------                                                                                                                                                    #
; ---Remove blank lines
TXT_RemoveBlankLines(TextFile,Destination){
	Original := A_BatchLines
	SetBatchLines, -1
    TextFile := (SubStr(TextFile,1,1)="!") ? (SubStr(TextFile,2),OW=1) : TextFile
    FileRead, Str, %TextFile%
    Loop, Parse, Str, `r`n
        OutPut .= (RegExMatch(A_LoopField,"[\S]+?")) ? A_LoopField "`n" :
    If OW {
        FileDelete, %TextFile%
        FileAppend, %OutPut%, %TextFile%
    }
    Else 
        FileAppend, %OutPut%, %Destination%
	SetBatchLines, %Original%
}

; ---
TXT_GetCSV(TextFile, Row=1, Column=1, Delimiter=","){ ;A_Tab, A_Space
	Original := A_BatchLines
	SetBatchLines, -1
    FileReadLine, Str, %TextFile%, %Row%
    StringSplit, Line, Str, %Delimiter%
    Output := Line%Column%
	SetBatchLines, %Original%
    Return Output
}

; ------------------------------------------------------------------------------
; KEYLIST (4)
; ------------------------------------------------------------------------------ 

KeyList(scriptfile)
{ 
  AutoTrim,off 
  Loop,Read,%scriptfile% 
  { 
    Line=%A_LoopReadLine% 
	; ---Only show lines that contain double semicolons 
    IfInString,Line,`;`; 
    { 
      StringLeft,First2Chars,Line,2 
      StringLeft,FirstChar,Line,1
	; ---Insert blank or comment lines (start with double semicolon) 
      IfEqual,First2Chars,`;`; 
      { 
        StringTrimLeft,Desc,Line,2 
        KeyList=%KeyList%%Desc%`n 
        Continue 
      } 
	; ---Insert Hotkeys and Hotstrings (must contain double colon) 
      IfInString,Line,`:`: 
      { 
		; ---Extract description (after last semicolon) 
        StringSplit,Desc,Line,`;`: 
        StringTrimLeft,Desc,Desc%Desc0%,0 
		; ---If description is blank, use command or hotstring text instead 
        If Desc= 
        { 
          EnvSub,Desc0,2 
          StringTrimLeft,Desc,Desc%Desc0%,0 
        } 
		; ---Extract keys 
        StringSplit,Keys,Line,`: 
		; ---Hotstrings (start with double colon) 
        IfEqual,First2Chars,`:`: 
        { 
          Keys=%Keys3% 
          IfEqual,Desc,,SetEnv,Desc,%Keys5% 
        } 
		; ---Hotstrings (start with single colon) - i.e. those hotstrings with options given. e.g. :c:tt::ta ta
        Else IfEqual,FirstChar,`: 
        { 
          Keys=%Keys3% 
          IfEqual,Desc,,SetEnv,Desc,%Keys5% 
          ;MsgBox, 1st char = %FirstChar% 2 chars = %First2Chars% split = %Keys% line = %line% ;DEBUG
        }        
		; ---Hotkeys (start with anything else) 
        Else 
        { 
          StringReplace,Keys,Keys1,#,Win- ;Why the Keys1 here instead of Keys?
          StringReplace,Keys,Keys,!,Alt- 
          StringReplace,Keys,Keys,^,Ctrl- 
          StringReplace,Keys,Keys,+,Shift- 
          StringReplace,Keys,Keys,`;, 
        } 
		; ---Add to the list 
		; ---Make keys 15 long with trailing spaces to keep the list neatly formatted 
        Keys=%Keys%               ! 
        StringLeft,Keys,Keys,15 
        Desc=%Keys% %Desc% 
        KeyList=%KeyList%%Desc%`n 
        
		; ---Keep track of longest line to set window width later 
        StringLen,Len,Desc 
        If Len > %MaxLen% 
          MaxLen = %Len% 
      } 
    } 
  } 
; ---Now show the list 
  EnvMult,MaxLen,8.0 ; pixel width of 1 character 
  EnvAdd,MaxLen,20 ; + 2 x 10 pixel margins 
  StringTrimRight,KeyList,KeyList,1 
;  ---Sort, KeyList, P16 ; sort the comments 
  Progress, M2 C00 ZH0 FS10 W%MaxLen%,%KeyList%,,Hotkeys and Hotstrings list,courier new 
  KeyList= 
  MaxLen= 
Return
}

; ---a function to take care of replacing symbols in shortcut keys with their words
HumanReadableShortcut(key)
{
  StringReplace,Key,Key,+,Shift%A_Space%+%A_Space%
  StringReplace,Key,Key,#,Win%A_Space%+%A_Space%
  StringReplace,Key,Key,!,Alt%A_Space%+%A_Space%
  StringReplace,Key,Key,^,Ctrl%A_Space%+%A_Space%
  Return %Key%
}


; ==============================================================================
; HTTPQUERY (5)
; ==============================================================================

httpQuery(byref Result, lpszUrl, POSTDATA="", HEADERS="")
{   ; v0.3.4 (w) Sep, 8 2008 by Heresy & derRaphael / zLib-Style release   
   ; currently the verbs showHeader, storeHeader, and updateSize are supported in httpQueryOps
   ; in case u need a different UserAgent, Proxy, ProxyByPass, Referrer, and AcceptType just 
   ; specify them as global variables - mind the varname for referrer is httpQueryReferer [sic].
   ; Also if any special dwFlags are needed such as INTERNET_FLAG_NO_AUTO_REDIRECT or cache
   ; handling this might be set using the httpQueryDwFlags variable as global
   global httpQueryOps, httpAgent, httpProxy, httpProxyByPass, httpQueryReferer, httpQueryAcceptType
       , httpQueryDwFlags
   ; Get any missing default Values
   defaultOps = 
   (LTrim Join|
      httpAgent=AutoHotkeyScript|httpProxy=0|httpProxyByPass=0|INTERNET_FLAG_SECURE=0x00800000
      SECURITY_FLAG_IGNORE_UNKNOWN_CA=0x00000100|SECURITY_FLAG_IGNORE_CERT_CN_INVALID=0x00001000
      SECURITY_FLAG_IGNORE_CERT_DATE_INVALID=0x00002000|SECURITY_FLAG_IGNORE_CERT_WRONG_USAGE=0x00000200
      INTERNET_OPEN_TYPE_PROXY=3|INTERNET_OPEN_TYPE_DIRECT=1|INTERNET_SERVICE_HTTP=3
   )
   Loop,Parse,defaultOps,|
   {
      RegExMatch(A_LoopField,"(?P<Option>[^=]+)=(?P<Default>.*)",http)
      if StrLen(%httpOption%)=0
         %httpOption% := httpDefault
   }

   ; ---Load Library
   hModule := DllCall("LoadLibrary", "Str", "WinINet.Dll")

   ; ---SetUpStructures for URL_COMPONENTS / needed for InternetCrackURL
   ; ---http://msdn.microsoft.com/en-us/library/aa385420(VS.85).aspx
   offset_name_length:= "4-lpszScheme-255|16-lpszHostName-1024|28-lpszUserName-1024|"
                  . "36-lpszPassword-1024|44-lpszUrlPath-1024|52-lpszExtrainfo-1024"
   VarSetCapacity(URL_COMPONENTS,60,0)
   ; Struc Size               ; Scheme Size                  ; Max Port Number
   NumPut(60,URL_COMPONENTS,0), NumPut(255,URL_COMPONENTS,12), NumPut(0xffff,URL_COMPONENTS,24)
   
   Loop,Parse,offset_name_length,|
   {
      RegExMatch(A_LoopField,"(?P<Offset>\d+)-(?P<Name>[a-zA-Z]+)-(?P<Size>\d+)",iCU_)
      VarSetCapacity(%iCU_Name%,iCU_Size,0)
      NumPut(&%iCU_Name%,URL_COMPONENTS,iCU_Offset)
      NumPut(iCU_Size,URL_COMPONENTS,iCU_Offset+4)
   }

   ; Split the given URL; extract scheme, user, pass, authotity (host), port, path, and query (extrainfo)
   ; http://msdn.microsoft.com/en-us/library/aa384376(VS.85).aspx
   DllCall("WinINet\InternetCrackUrlA","Str",lpszUrl,"uInt",StrLen(lpszUrl),"uInt",0,"uInt",&URL_COMPONENTS)

   ; Update variables to retrieve results
   Loop,Parse,offset_name_length,|
   {
      RegExMatch(A_LoopField,"-(?P<Name>[a-zA-Z]+)-",iCU_)
      VarSetCapacity(%iCU_Name%,-1)
   }
   nPort:=NumGet(URL_COMPONENTS,24,"uInt")
   
   ; Import any set dwFlags
   dwFlags := httpQueryDwFlags
   ; For some reasons using a selfsigned https certificates doesnt work
   ; such as an own webmin service - even though every security is turned off
   ; https with valid certificates works when 
   if (lpszScheme = "https") 
      dwFlags |= (INTERNET_FLAG_SECURE|SECURITY_FLAG_IGNORE_CERT_CN_INVALID
               |SECURITY_FLAG_IGNORE_CERT_WRONG_USAGE)

   ; Check for Header and drop exception if unknown or invalid URL
   if (lpszScheme="unknown") {
      Result := "ERR: No Valid URL supplied."
      Return StrLen(Result)
   }

   ; Initialise httpQuery's use of the WinINet functions.
   ; http://msdn.microsoft.com/en-us/library/aa385096(VS.85).aspx
   hInternet := DllCall("WinINet\InternetOpenA" 
                  ,"Str",httpAgent,"UInt"
                  ,(httpProxy != 0 ?  INTERNET_OPEN_TYPE_PROXY : INTERNET_OPEN_TYPE_DIRECT )
                  ,"Str",httpProxy,"Str",httpProxyBypass,"Uint",0)

   ; Open HTTP session for the given URL
   ; http://msdn.microsoft.com/en-us/library/aa384363(VS.85).aspx
   hConnect := DllCall("WinINet\InternetConnectA"
                  ,"uInt",hInternet,"Str",lpszHostname, "Int",nPort
                  ,"Str",lpszUserName, "Str",lpszPassword,"uInt",INTERNET_SERVICE_HTTP
                  ,"uInt",0,"uInt*",0)

   ; Do we POST? If so, check for header handling and set default
   if (Strlen(POSTDATA)>0) {
      HTTPVerb:="POST"
      if StrLen(Headers)=0
         Headers:="Content-Type: application/x-www-form-urlencoded"
   } else ; otherwise mode must be GET - no header defaults needed
      HTTPVerb:="GET"   

   ; Form the request with proper HTTP protocol version and create the request handle
   ; http://msdn.microsoft.com/en-us/library/aa384233(VS.85).aspx
   hRequest := DllCall("WinINet\HttpOpenRequestA"
                  ,"uInt",hConnect,"Str",HTTPVerb,"Str",lpszUrlPath . lpszExtrainfo
                  ,"Str",ProVer := "HTTP/1.1", "Str",httpQueryReferer,"Str",httpQueryAcceptTypes
                  ,"uInt",dwFlags,"uInt",Context:=0 )

   ; Send the specified request to the server
   ; http://msdn.microsoft.com/en-us/library/aa384247(VS.85).aspx
   sRequest := DllCall("WinINet\HttpSendRequestA"
                  , "uInt",hRequest,"Str",Headers, "uInt",Strlen(Headers)
                  , "Str",POSTData,"uInt",Strlen(POSTData))

   VarSetCapacity(header, 2048, 0)  ; max 2K header data for httpResponseHeader
   VarSetCapacity(header_len, 4, 0)
   
   ; Check for returned server response-header (works only _after_ request been sent)
   ; http://msdn.microsoft.com/en-us/library/aa384238.aspx
   Loop, 5
     if ((headerRequest:=DllCall("WinINet\HttpQueryInfoA","uint",hRequest
      ,"uint",21,"uint",&header,"uint",&header_len,"uint",0))=1)
      break

   If (headerRequest=1) {
      VarSetCapacity(res,headerLength:=NumGet(header_len),32)
      DllCall("RtlMoveMemory","uInt",&res,"uInt",&header,"uInt",headerLength)
      Loop,% headerLength
         if (*(&res-1+a_index)=0) ; Change binary zero to linefeed
            NumPut(Asc("`n"),res,a_index-1,"uChar")
      VarSetCapacity(res,-1)
   } else 
      res := "timeout"

   ; Get 1st Line of Full Response
   Loop,Parse,res,`n,`r
   {
      RetValue := A_LoopField
      break
   }
   
   ; No Connection established - drop exception
   If (RetValue="timeout") {
      html := "Error: timeout"
      return -1
   }
   ; Strip protocol version from return value
   RetValue := RegExReplace(RetValue,"\Q" ProVer "\E\s+")
   
    ; List taken from http://en.wikipedia.org/wiki/List_of_HTTP_status_codes
   HttpRetCodes := "100=Continue|101=Switching Protocols|102=Processing (WebDAV) (RFC 2518)|"
              . "200=OK|201=Created|202=Accepted|203=Non-Authoritative Information|204=No"
              . " Content|205=Reset Content|206=Partial Content|207=Multi-Status (WebDAV)"
              . "|300=Multiple Choices|301=Moved Permanently|302=Found|303=See Other|304="
              . "Not Modified|305=Use Proxy|306=Switch Proxy|307=Temporary Redirect|400=B"
              . "ad Request|401=Unauthorized|402=Payment Required|403=Forbidden|404=Not F"
              . "ound|405=Method Not Allowed|406=Not Acceptable|407=Proxy Authentication "
              . "Required|408=Request Timeout|409=Conflict|410=Gone|411=Length Required|4"
              . "12=Precondition Failed|413=Request Entity Too Large|414=Request-URI Too "
              . "Long|415=Unsupported Media Type|416=Requested Range Not Satisfiable|417="
              . "Expectation Failed|418=I'm a teapot (RFC 2324)|422=Unprocessable Entity "
              . "(WebDAV) (RFC 4918)|423=Locked (WebDAV) (RFC 4918)|424=Failed Dependency"
              . " (WebDAV) (RFC 4918)|425=Unordered Collection (RFC 3648)|426=Upgrade Req"
              . "uired (RFC 2817)|449=Retry With|500=Internal Server Error|501=Not Implem"
              . "ented|502=Bad Gateway|503=Service Unavailable|504=Gateway Timeout|505=HT"
              . "TP Version Not Supported|506=Variant Also Negotiates (RFC 2295)|507=Insu"
              . "fficient Storage (WebDAV) (RFC 4918)|509=Bandwidth Limit Exceeded|510=No"
              . "t Extended (RFC 2774)"
   
   ; Gather numeric response value
   RetValue := SubStr(RetValue,1,3)
   
   ; Parse through return codes and set according informations
   Loop,Parse,HttpRetCodes,|
   {
      HttpReturnCode := SubStr(A_LoopField,1,3)    ; Numeric return value see above 
      HttpReturnMsg  := SubStr(A_LoopField,5)      ; link for additional information
      if (RetValue=HttpReturnCode) {
         RetMsg := HttpReturnMsg
         break
      }
   }

   ; Global HttpQueryOps handling
   if strlen(HTTPQueryOps)>0 {
      ; Show full Header response (usefull for debugging)
      if (instr(HTTPQueryOps,"showHeader"))
         MsgBox % res
      ; Save the full Header response in a global Variable
      if (instr(HTTPQueryOps,"storeHeader"))
         global HttpQueryHeader := res
      ; Check for size updates to export to a global Var
      if (instr(HTTPQueryOps,"updateSize")) {
         Loop,Parse,res,`n
            If RegExMatch(A_LoopField,"Content-Length:\s+?(?P<Size>\d+)",full) {
               global HttpQueryFullSize := fullSize
               break
            }
         if (fullSize+0=0)
            HttpQueryFullSize := "size unavailable"
      }
   }

   ; Check for valid codes and drop exception if suspicious
   if !(InStr("100 200 201 202 302",RetValue)) {
      Result := RetValue " " RetMsg
      return StrLen(Result)
   }

   VarSetCapacity(BytesRead,4,0)
   fsize := 0
   Loop            ; the receiver loop - rewritten in the need to enable 
   {               ; support for larger file downloads
      bc := A_Index
      VarSetCapacity(buffer%bc%,1024,0) ; setup new chunk for this receive round
      ReadFile := DllCall("wininet\InternetReadFile"
                  ,"uInt",hRequest,"uInt",&buffer%bc%,"uInt",1024,"uInt",&BytesRead)
      ReadBytes := NumGet(BytesRead)    ; how many bytes were received?
      If ((ReadFile!=0)&&(!ReadBytes))  ; we have had no error yet and received no more bytes
         break                         ; we must be done! so lets break the receiver loop
      Else {
         fsize += ReadBytes            ; sum up all chunk sizes for correct return size
         sizeArray .= ReadBytes "|"
      }
      if (instr(HTTPQueryOps,"updateSize"))
         Global HttpQueryCurrentSize := fsize
   }
   sizeArray := SubStr(sizeArray,1,-1)   ; trim last PipeChar
   
   VarSetCapacity(result,fSize+1,0)      ; reconstruct the result from above generated chunkblocks
   Dest := &result                       ; to a our ByRef result variable
   Loop,Parse,SizeArray,|
      DllCall("RtlMoveMemory","uInt",Dest,"uInt",&buffer%A_Index%,"uInt",A_LoopField)
      , Dest += A_LoopField
      
   DllCall("WinINet\InternetCloseHandle", "uInt", hRequest)   ; close all opened 
   DllCall("WinINet\InternetCloseHandle", "uInt", hInternet)
   DllCall("WinINet\InternetCloseHandle", "uInt", hConnect)
   DllCall("FreeLibrary", "UInt", hModule)                    ; unload the library
   return fSize                          ; return the size - strings need update via VarSetCapacity(res,-1)
}

; ==============================================================================
; HASH (6)
; ==============================================================================

; ---Get the Hash of a file
HASH(ByRef sData, nLen, SID = 3) { ; SID = 3: MD5, 4: SHA1
   DllCall("advapi32\CryptAcquireContextA", UIntP,hProv, UInt,0, UInt,0, UInt,1, UInt,0xF0000000)
   DllCall("advapi32\CryptCreateHash", UInt,hProv, UInt,0x8000|0|SID, UInt,0, UInt,0, UIntP, hHash)
   DllCall("advapi32\CryptHashData", UInt,hHash, UInt,&sData, UInt,nLen, UInt,0)
   DllCall("advapi32\CryptGetHashParam", UInt,hHash, UInt,2, UInt,0, UIntP,nSize, UInt,0)
   VarSetCapacity(HashVal, nSize, 0)
   DllCall("advapi32\CryptGetHashParam", UInt,hHash, UInt,2, UInt,&HashVal, UIntP,nSize, UInt,0)
   DllCall("advapi32\CryptDestroyHash", UInt,hHash)
   DllCall("advapi32\CryptReleaseContext", UInt,hProv, UInt,0)
   IFormat := A_FormatInteger
   SetFormat Integer, H
   Loop %nSize%
      sHash .= SubStr(*(&HashVal+A_Index-1)+0x100,-1)
   SetFormat Integer, %IFormat%
   Return sHash
}

; ==============================================================================
; WRITE BINARY FILE - EXAMPLE III (7)
; ==============================================================================

write_bin(byref bin,filename,size){
   h := DllCall("CreateFile","str",filename,"Uint",0x40000000
            ,"Uint",0,"UInt",0,"UInt",4,"Uint",0,"UInt",0)
   IfEqual h,-1, SetEnv, ErrorLevel, -1
   IfNotEqual ErrorLevel,0,ExitApp ; couldn't create the file
   r := DllCall("SetFilePointerEx","Uint",h,"Int64",0,"UInt *",p,"Int",0)
   IfEqual r,0, SetEnv, ErrorLevel, -3
   IfNotEqual ErrorLevel,0, {
      t = %ErrorLevel%              ; save ErrorLevel to be returned
      DllCall("CloseHandle", "Uint", h)
      ErrorLevel = %t%              ; return seek error
   }
   result := DllCall("WriteFile","UInt",h,"Str",bin,"UInt"
               ,size,"UInt *",Written,"UInt",0)
   h := DllCall("CloseHandle", "Uint", h)
   return, 1
}

; ==============================================================================
; AUTO UPDATER (8)
; ==============================================================================

UpdateMySelf(Progress=0){
	global
	; ---Remove v from the version variable, Version
	StringReplace, ThisVersion, Version,v
   ; ---Lets get the latest info from web
   length := httpQuery(VersionInfo := "",Server UpdateDir WebVersionInfo)
   VarSetCapacity(VersionInfo,-1)
   StringSplit,tmp,VersionInfo,`n,`r
   netVersion  := tmp1
   VersionTime := tmp2
   CheckTime := ThisVersionTime
   EnvSub,CheckTime,%VersionTime%,Seconds
	if ( CheckTime <= 0 ) OR ( ThisVersion < netVersion ){            ; Check = ThisVersion-LatestVersion
	 MsgBox,65,Message,% "There is a newer version available.`n"
					 . "Should I update?"
	 IfMsgBox,ok
	 {
		length := httpQuery(md5:="",Server UpdateDir MD5Sum)    ; The md5 hash of the new Script
		VarSetCapacity(md5,-1)                            ; located online
		StringSplit,tmp,md5,`n,`r
		md5Script := tmp1
		md5Ini	  := tmp2
		; The script will be downloaded here. If the function has been called to show update
		; informations, a progressbar of the download will be displayed
		if (Progress=1) {
		   httpQueryOps := "updateSize"
		   Progress, 0,, Updating Script..., Please wait
		   SetTimer,ProgressUpdate,50
		}
		
		lengthScript := httpQuery(Script:="", Server FileDownload)
		VarSetCapacity(lengthScript,-1)
		lengthIni	:= httpQuery(Ini:="", Server IniDownload)
		VarSetCapacity(lengthIni,-1)
		
		if (Progress=1) {
		   httpQueryOps := ""
		   Progress, OFF
		   SetTimer,ProgressUpdate,OFF
		}
	 
		ScriptMD5 	:= hash(Script,lengthScript)
		IniMD5	  	:= hash(Ini,lengthIni)
		If (ScriptMD5=RegExReplace(md5Script,"\s.*"))	; Versions are equal
		{               
			SplitPath,A_ScriptFullPath,,,Extension,NameNoExt
			ArchivesDir=archives
			INI_Old=%NameNoExt%_v%ThisVersion%.ini
			IfNotExist, %ArchivesDir%
				FileCreateDir, %A_ScriptDir%\%ArchivesDir%
			FileMove,%A_ScriptFullPath%,%A_ScriptDir%\%ArchivesDir%\%NameNoExt%_v%ThisVersion%.%Extension%
			FileMove,%A_ScriptDir%\%NameNoExt%.ini,%A_ScriptDir%\%ArchivesDir%\%INI_Old%
			
			; ---Write new script and INI
			FileAppend,%Script%,%A_ScriptFullPath%
			FileAppend,%Ini%,%File_Output%
			
			; ---Copy settings from old ini to new
			ini_Load(File,ArchivesDir "\" INI_Old)
			Sections := ini_GetSections(File)
			StringTrimLeft, Sections, Sections,1
			StringTrimRight, Sections, Sections,1
			StringSplit, Sections, Sections, `n
			StringReplace, Sections, Sections, %Sections1%`n
			Loop, Parse, Sections,`n
			{
				sec=%A_LoopField%
				var:=ini_GetKeys(File, A_LoopField)
				StringTrimRight, var,var,1
				%sec%:=var
				Loop, Parse, %A_LoopField%,`n
				{
					key=%A_LoopField%
					var:=ini_Read(File,sec,A_LoopField)
					iniWrite, %var%, %File_Output%,%sec%,%key%
				}
			} 

			; ---Retart confirmation
			Progress, Off
			MsgBox,65,Message: Success, Updated successfully. Press OK to restart.
			IfMsgBox,ok
			{
				Run, %A_ScriptFullPath%
				ExitApp
			}
		} 
		Else
		{
		   MsgBox,16,Message: Error, There was an updating Error. The old version remains
		}
		}
	} 
	Else
	{
		TrayTip, Script Auto Update,Script is up to date!,,1
		sleep %TrayTipDelay%
		TrayTip
	}
   return
   
   ; Progress, ProgressParam1 [, SubText, MainText, WinTitle, FontName]
   ProgressUpdate:
      ;Progress, % Round((HttpQueryCurrentSize/HttpQueryFullSize)*100), Updating Script..., Please wait
      Progress,100,,Update Finished, Please wait
   return
}

; ------------------------------------------------------------------------------
; INI LIBRARY V1.08 (10)
; ------------------------------------------------------------------------------

/*
		Title: INI Library
		
		A set of functions for modifying INI files in memory and writing them later to file.
		Useful for parsing a large data sets with minimal disk reads.
		
		License:
			- Version 1.08 by Titan <http://www.autohotkey.net/~Titan/#ini>
			- zlib License <http://www.autohotkey.net/~Titan/zlib.txt>
*/

/*

		Function: ini_Read
			Get the value of a key within a specifed section.
		
		Parameters:
			var - ini object
			sec - name of section to look under
			key - key name
			default - (optional) value to return if key was not found
		
		Returns:
			Key value.
		
		Example:
		
> ini_Load(phpconfig, ProgramFiles . "\PHP\php.ini") ; load INI file
> ; read variable under section named "MySQL":
> links := ini_Read(phpconfig, "MySQL", "mysql.max_links")
> MsgBox, %links%

*/
ini_Read(ByRef var, sec, key, default = "") {
	NumPut(160, var, 0, "UChar")
	f = `n%sec%/%key%=
	StringGetPos, p, var, %f%
	If ErrorLevel = 0
	{
		StringGetPos, p, var, =, , %p%
		StringMid, v, var, p += 2, InStr(var, "`n", "", p) - p
	}
	NumPut(0, var, 0, "UChar")
	Return, v == "" ? default : _ini_unescape(v)
}

/*

		Function: ini_GetKeys
			Get a list of key names for a section.
		
		Parameters:
			var - ini object
			sec - name of section to look under
		
		Returns:
			List of `n (LF) delimited key names.

*/
ini_GetKeys(ByRef var, sec = "") {
	NumPut(160, var, 0, "UChar")
	p = 0
	Loop {
		StringGetPos, p, var, `n%sec%/, , p
		If ErrorLevel = 1
			Break
		StringGetPos, p1, var, /, , p
		StringGetPos, p2, var, =, , p
		p1 += 2
		StringMid, n, var, p1, p2 - p1 + 1
		l = %l%%n%`n
		p++
	}
	NumPut(0, var, 0, "UChar")
	Return, l
}

/*

		Function: ini_GetSections
			Get the complete list of sections.
		
		Parameters:
			var - ini object
		
		Returns:
			List of `n (LF) delimited section names.

*/
ini_GetSections(ByRef var) {
	NumPut(160, var, 0, "UChar")
	Loop, Parse, var, `n
	{
		StringGetPos, p, A_LoopField, /
		StringLeft, n, A_LoopField, p
		n = %n%`n
		If (!InStr(s, n))
			s = %s%%n%
	}
	NumPut(0, var, 0, "UChar")
	Return, s
}

/*

		Function: ini_Load
			Load an INI file into memory so that it may be used with all the other functions in this library.
		
		Parameters:
			var - a reference to the loaded INI file as a variable (use for all other functions requiring this parameter)
			file - path to a file or source as text
		
		Returns:
			True if the file loaded successfully, false otherwise.

*/
ini_Load(ByRef var, src) {
	IfExist, %src%
		FileRead, src, %src%
	If src =
		Return
	StringReplace, src, src, `r`n, `n, All
	StringReplace, src, src, `r, `n, All
	_at = %A_AutoTrim%
	AutoTrim, On
	Loop, Parse, src, `n
	{
		l = %A_LoopField%
		If (InStr(l, ";") == 1)
			Continue
		StringGetPos, p, l, `;
		If ErrorLevel = 0
			StringLeft, l, l, p
		If (InStr(l, "[") == 1) {
			s := SubStr(l, 2, -1)
			Continue
		}
		StringGetPos, p, l, =
		If pe = 0
			Continue
		StringLeft, k, l, p
		k = %k%
		If k =
			Continue
		If k contains /,`t, , ,#
			Continue
		StringTrimLeft, v, l, p + 1
		v = %v%
		StringLeft, a0, v, 1
		If a0 in ",'
		{
			StringRight, a1, v, 1
			If a0 = %a1%
			{
				StringTrimLeft, v, v, 1
				StringTrimRight, v, v, 1
			}
		}
		e = `n%s%/%k%=
		StringGetPos, p, d, %e%
		If ErrorLevel = 1
			d = %d%%e%%v%`n
		Else {
			StringGetPos, p1, d, =, , p
			StringGetPos, p2, d, `n, , p + 1
			d := SubStr(d, 1, p1 + 1) . v . SubStr(d, p2 + 1)
		}
	}
	AutoTrim, %_at%
	NumPut(0, var := " " . d, 0, "UChar")
	Return, true
}

_ini_escape(val) {
	StringReplace, val, val, \, \\, All
	StringReplace, val, val, `r, \r, All
	StringReplace, val, val, `n, \n, All
	Return, val
}

_ini_unescape(val) {
	StringReplace, val, val, \\, \, All
	StringReplace, val, val, \r, `r, All
	StringReplace, val, val, \n, `n, All
	Return, val
}

; ------------------------------------------------------------------------------
; DEFAULT INI
; ------------------------------------------------------------------------------

DefaultIni(File_Output)	{
	Global ThisVersionTime,File_Name,Extension
	FileAppend,
	(	
;===============================================================================
; INI Key
; ------------------------------------------------------------------------------
; [General]
; 	ScriptName 					-Name of script
; 	Version						-Version of script including preceding "v"
;	ThisVersionTime				-Modification date in form YYYYMMDDHHmmss
;
; [Settings]
; 	TrayIcons					-Enable/Disable Tray Icons
;	ProgressBar					-Enable/Disable download progress bar
; 	StartupNotifications		-Enable/Disable Startup Notifications
; 	ChromeApp					-Enable/Disable Google Chrome App for WebUI
; 	StopSeeding					-Stop seeding torrent when finished
;		"						-	Related to StopRatio
;	Proxy						-Enable/Disable proxy. Future feature
;	ShouldDoUpdate				-Auto update
;
; [Connection]
; 	uTorrent_address			-uTorrent address without http://... & .../gui
; 	uTorrent_Port				-Port number
; 	uTorrent_Username			-uTorrent user name
;	uTorrent_Password			-uTorrent password
;
; [Proxy]						-To be implemented later
;	Proxy_User					-Proxy username
;	Proxy_PW					-Proxy password
;	Proxy_Adr					-Proxy address incl. "http://"
;	Proxy_Port					-Proxy port
;
; [AutoUpadate]
;	Server						-Server address of update location. Inc post "/"
;	IconDir						-Directory of icons. Inc post "/"
;	UpdateDir					-Directory of update information. Inc post "/"
;	WebIconInfo					-iconCheck.md5 source of icon md5 check sum
;	WebVersionInfo				-latestVersion.txt - Usage example
;		"						-	1.1
;		"						-	20080811130000
;	MD5Sum						-versionCheck.md5 - source of md5 check sum
;	FileDownload				-Name of web version script
;
; [Miscellaneous]
;	TrayTipDelay				-Delay of TrayTip in ms
;	RefreshRate					-Script refresh rate in ms
;	StopRatio					-Stop seeding ratio
;		"						-	3 decimal places [i.e. 1.000]
;		"						-	Set to 0.000 to stop immediately
;		"						-	StopSeeding must be set to 1
;
;===============================================================================

[General]
ScriptName=Remote uTorrent Monitor
Version=v0.1.3
ThisVersionTime=20090430002349

[Settings]
TrayIcons=1
ProgressBar=1
StartupNotifications=1
ChromeApp=1
StopSeeding=1
Proxy=0
ShouldDoUpdate=1

[Connection]
uTorrent_address=
uTorrent_Port=8080
uTorrent_Username=
uTorrent_Password=

[Proxy]
Proxy_User=
Proxy_PW=
Proxy_Adr=
Proxy_Port=8080

[AutoUpdate]
Server=http://www.autohotkey.net/~Voltron43/uTorrent/
IconDir=icons/
UpdateDir=update/
WebIconInfo=iconCheck.md5
WebVersionInfo=latestVersion.txt
MD5Sum=versionCheck.md5
FileDownload=uTorrentMon.ahk
IniDownload=Default.ini

[Miscellaneous]
TrayTipDelay=7000
RefreshRate=3000
StopRatio=0.000

	),%File_Output%
}

; ==============================================================================
; EOS
; ==============================================================================
; REFERENCE
; ------------------------------------------------------------------------------
;
; AUTHOR:	Lord Alderaan
; TITLE:	Bitwise Status
; LINK:		http://forum.utorrent.com/viewtopic.php?id=50779
;
;128 = Stopped (file is also not fully hash checked) Loaded
;130 = Checking Loaded, Checking
;152 = Error Loaded, Error, Checked
;169 = Paused (torrent is forced) Loaded, Paused, Checked, Started
;233 = Paused (torrent is not forced) Loaded, Queued, Paused, Checked, Started
;
;If PERCENT PROGRESS = 1000:
;136 = Finished Loaded, Checked
;137 = [F] Seeding Loaded, Checked, Started
;200 = Queued Seed Loaded, Queued, Checked
;201 = Seeding Loaded, Queued, Checked, Started
;
;If PERCENT PROGRESS < 1000:
;136 = Stopped (file is fully hash checked) Loaded, Checked
;137 = [F] Downloading Loaded, Checked, Started
;200 = Queued Loaded, Queued, Checked
;201 = Downloading Loaded, Queued, Checked, Started
;
; Torrent_Fields
;	[1] 	HASH
;	[2] 	STATUS
;	[3]		NAME
;	[4]		SIZE
;	[5]		PERCENT_PROGRESS
;	[6]		DOWNLOADED
;	[7]		UPLOADED
;	[8]		RATIO
;	[9]		UPLOAD_SPEED
;	[10]	DOWNLOAD_SPEED
;	[11]	ETA
;	[12]	LABEL
;	[13]	PEERS_CONNECTED
;	[14]	PEERS_IN_SWARM
;	[15]	SEEDS_CONNECTED;
;	[16]	SEEDS_IN_SWARM
;	[17]	AVAILABILITY
;	[18]	TORRENT_QUEUE_ORDER
;	[19]	REMAINING

; ---Get PID of current script
;PID := DllCall("GetCurrentProcessId")

; ------------------------------------------------------------------------------