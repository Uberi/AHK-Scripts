; Folder Menu 2    by rexx
f_CurrentVer = 2.08
;
; ** CREDITS **
; Based on "Easy Access to Favorite Folders" by Savage
; http://www.autohotkey.com/docs/scripts/FavoriteFolders.htm
;
; Icons from "Silk Icons" by Mark James @ FAMFAMFAM
; http://www.famfamfam.com/lab/icons/silk/
;
; Open Registry entry based on
; http://www.appinn.com/ahk-fast-food-restaurant-8-interactive-with-reader-1/
;
; SendBig5 by Lumania @ Ptt
; http://www.ptt.cc/bbs/EzHotKey/M.1224744552.A.029.html
;
; Menu Icon Support by Lexikos
; http://www.autohotkey.net/~Lexikos/AutoHotkey_L/
;
; TreeView eXtension by majkinetor
; http://www.autohotkey.com/forum/topic19021.html
;
; GUI ToolTip by Micahs
; http://www.autohotkey.com/forum/topic43105.html
;
; ShellContextMenu by Sean
; http://www.autohotkey.com/forum/topic22120.html
;
; xpath v3 XPath Lib by Titan
; http://www.autohotkey.net/~Titan/#xpath
;
; GetCommandLine by Sean & SKAN
; http://www.autohotkey.com/forum/topic16575.html
;
;===============================================================================
; 301, Add Favorite , add.ico
; 302, Reload       , arrow_refresh_small.ico
; 303, Option       , cog.ico
; 304, Edit         , page_white_edit.ico
; 305, Exit         , cross.ico
; 306, Debug        , bug.ico
; 307, Recent       , folder_explore.ico
; 308, Folder       , folder.ico
; 309, Drive        , drive.ico
; 310, Computer     , computer.ico
; 311, Drive Network, drive_network.ico
;===============================================================================



;==================== Auto Execute ====================;

;#SingleInstance, Force	; Needed since the hotkey is dynamically created.
#NoTrayIcon
#SingleInstance, OFF
#MaxThreads 255
SetBatchLines, -1

; by MILK
; This code detects a previous instance and if it exists
; it sends the menu hotkey and exit.
; This makes possible to "pin" FolderMenu.exe to
; Windows 7 superbar, QuickLaunch, StartMenu,
; ObjectDock, RocketDock and other applications.
; The user will then be able to open the menu without
; using the hotkey.
if A_IsCompiled
{
	Process, Exist, %A_ScriptName%
	f_PrevPID := ErrorLevel
	f_ThisPID := DllCall("GetCurrentProcessId")
	if f_ThisPID != %f_PrevPID%
	{
		Send, #!+^x
		ExitApp
	}
}

f_Icons = %A_ScriptFullPath%

if A_IsCompiled =
{
	StringReplace, f_Icons, f_Icons, .ahk , .exe, All
	Menu, Tray, UseErrorLevel
	Menu, Tray, Icon, %A_ScriptDir%\Compiler\folder_goX.ico
	Menu, Tray, UseErrorLevel, OFF
}

Menu, Tray, Tip, Folder Menu 2
Menu, Tray, NoStandard

IfNotExist, %A_ScriptDir%\Config.xml	;if config file doesn't exist
{
	f_ErrorMsg = Config file not exist.`nDefault config file is installed.
	FileInstall, Default.xml, %A_ScriptDir%\Config.xml
}

xpath_load(f_ConfigXML, A_ScriptDir . "\Config.xml")
s_Language := f_ReadXML("/FolderMenu/Settings/Others/Setting[@Name='Language']/@Value/text()", "")
f_ReadLanguage()

;StartTime := A_TickCount
;Loop, 50
;	f_ReadLanguage()
;ElapsedTime1 := A_TickCount - StartTime
;ElapsedTime1 := ElapsedTime1/50

;StartTime := A_TickCount
;Loop, 500
;	f_ReadLanguage2()
;ElapsedTime2 := A_TickCount - StartTime
;ElapsedTime2 := ElapsedTime2/500

;f_ErrorMsg = %ElapsedTime1%`n%ElapsedTime2%

;gui, 5:Add, Edit, w800 h500, %aaa%
;gui, 5:show

Menu, Tray, Add, &Folder Menu, f_DisplayMenu15
Menu, Tray, Add
Menu, Tray, Add, %lang_ToolAdd%   , f_AddFavorite
Menu, Tray, Add
Menu, Tray, Add, %lang_ToolReload%, f_ToolReload
Menu, Tray, Add, %lang_ToolOption%, f_ToolOptions
Menu, Tray, Add, %lang_ToolEdit%  , f_ToolEdit
Menu, Tray, Add
Menu, Tray, Add, %lang_ToolExit%  , f_ToolExit

f_SetMenuIcon("Tray", "&Folder Menu" , f_Icons)
f_SetMenuIcon("Tray", lang_ToolAdd   , f_Icons . ",-301")
f_SetMenuIcon("Tray", lang_ToolReload, f_Icons . ",-302")
f_SetMenuIcon("Tray", lang_ToolOption, f_Icons . ",-303")
f_SetMenuIcon("Tray", lang_ToolEdit  , f_Icons . ",-304")
f_SetMenuIcon("Tray", lang_ToolExit  , f_Icons . ",-305")

Menu, Tray, Default, &Folder Menu
Menu, Tray, Click, 1

;	StartTime := A_TickCount
f_ReadConfig()
;	MsgBox, % A_TickCount - StartTime . " milliseconds have elapsed."
f_SetConfig()
;	StartTime := A_TickCount
f_ReadFavorites()
;	MsgBox, % A_TickCount - StartTime . " milliseconds have elapsed."
TrayTip ; remove old one
if f_ErrorMsg !=
{
	TrayTip, !, %f_ErrorMsg%, , 1
	f_ErrorMsg =
}

if s_CheckVersion
	f_CheckVersion(1)

gui_hh = 0
gui_ww = 0
;Gosub, f_TOoLoPtIOnS

return
;=================================== End Auto Execute =;

f_CheckVersion(Quiet=0)
{
	Global
	Local VerFileName, LatestVer
	VerFileName = %Temp%\f_version.tmp
	UrlDownloadToFile, http://www.autohotkey.net/~rexx/FolderMenu/ver2.txt, %VerFileName%
	FileRead, LatestVer, %VerFileName%
	FileDelete, %VerFileName%
	if LatestVer =
	{
		if !Quiet
			MsgBox, 16, %lang_Error%, %lang_CannotConnect%
	}
	else
	{
		Local NewVerAvailable, NewVerNotAvailable
		if f_CurrentVer < %LatestVer%
		{
			StringReplace, NewVerAvailable, lang_NewVerAvailable, `%LatestVer`%, %LatestVer%
			MsgBox, 36, Folder Menu, %NewVerAvailable%
			IfMsgBox Yes
				Gosub, f_GoWebsite
		}
		else
		{
			StringReplace, NewVerNotAvailable, lang_NewVerNotAvailable, `%CurrentVer`%, %f_CurrentVer%
			if !Quiet
				MsgBox, 64, Folder Menu, %NewVerNotAvailable%
		}
	}
	return
}



;==================== Read Config File ====================;
f_ReadXML(XMLPath, DefaultValue)
{
	Global f_ConfigXML
	Value := f_XMLUnescape(xpath(f_ConfigXML, XMLPath))
	if Value =
		return DefaultValue
	else
		return Value
}

f_ReadConfig()
{
	Global
	Local SectionPath

	; applications
	SectionPath := "/FolderMenu/Settings/Applications/Setting[@Name='ApplicationList']"
	s_ApplicationsCount := xpath(f_ConfigXML, SectionPath . "/Application/count()")
	Loop, % s_ApplicationsCount
	{
		s_Applications%A_Index%Name := f_XMLUnescape(xpath(f_ConfigXML, SectionPath . "/Application[" . A_Index . "]/@Name/text()"))
		s_Applications%A_Index%Class:= f_XMLUnescape(xpath(f_ConfigXML, SectionPath . "/Application[" . A_Index . "]/@Class/text()"))
		s_Applications%A_Index%Type := xpath(f_ConfigXML, SectionPath . "/Application[" . A_Index . "]/@Type/text()")
		s_Applications%A_Index%Check:= xpath(f_ConfigXML, SectionPath . "/Application[" . A_Index . "]/@Check/text()")
	}

	; hotkeys
	SectionPath := "/FolderMenu/Settings/Hotkeys/Setting[@Name='HotkeyList']"
	s_HotkeysCount := xpath(f_ConfigXML, SectionPath . "/Hotkey/count()")
	Loop, % s_HotkeysCount
	{
;		s_Hotkeys%A_Index%Name := xpath(f_ConfigXML, SectionPath . "/Hotkey[" . A_Index . "]/@Name/text()")
		s_Hotkeys%A_Index%Key  := xpath(f_ConfigXML, SectionPath . "/Hotkey[" . A_Index . "]/@Key/text()")
		s_Hotkeys%A_Index%Lab  := xpath(f_ConfigXML, SectionPath . "/Hotkey[" . A_Index . "]/@Lab/text()")
	}

	; icons
	SectionPath := "/FolderMenu/Settings/Icons"
	s_NoMenuIcon := f_ReadXML(SectionPath . "/Setting[@Name='NoMenuIcon']/@Value/text()", "0")
	s_IconSize   := f_ReadXML(SectionPath . "/Setting[@Name='IconSize']/@Value/text()"  , "")
	SectionPath := "/FolderMenu/Settings/Icons/Setting[@Name='IconList']"
	s_IconsCount := xpath(f_ConfigXML, SectionPath . "/Icon/count()")
	Loop, % s_IconsCount
	{
		s_Icons%A_Index%Ext   := f_XMLUnescape(xpath(f_ConfigXML, SectionPath . "/Icon[" . A_Index . "]/@Ext/text()"))
		s_Icons%A_Index%Path  := f_XMLUnescape(xpath(f_ConfigXML, SectionPath . "/Icon[" . A_Index . "]/@Path/text()"))
		s_Icons%A_Index%Index := xpath(f_ConfigXML, SectionPath . "/Icon[" . A_Index . "]/@Index/text()")
		s_Icons%A_Index%Size  := xpath(f_ConfigXML, SectionPath . "/Icon[" . A_Index . "]/@Size/text()")
	}

	; recent
	SectionPath := "/FolderMenu/Settings/Recents"
	s_RecentSize        := f_ReadXML(SectionPath . "/Setting[@Name='RecentSize']/@Value/text()", "16")
	s_RecentSizeS       := f_ReadXML(SectionPath . "/Setting[@Name='RecentSizeS']/@Value/text()", "16")
	s_RecentOnlyFolder  := f_ReadXML(SectionPath . "/Setting[@Name='RecentOnlyFolder']/@Value/text()", "0")
	s_RecentOnlyFolderS := f_ReadXML(SectionPath . "/Setting[@Name='RecentOnlyFolderS']/@Value/text()", "0")
	s_RecentShowIndex   := f_ReadXML(SectionPath . "/Setting[@Name='RecentShowIndex']/@Value/text()", "1")
	SectionPath := "/FolderMenu/Settings/Recents/Setting[@Name='RecentList']"
	Loop, % s_RecentSize
		s_Recents%A_Index% := f_XMLUnescape(xpath(f_ConfigXML, SectionPath . "/Recent[" . A_Index . "]/@Path/text()"))

	; menu
	SectionPath := "/FolderMenu/Settings/Others"
	s_MenuPositionX := f_ReadXML(SectionPath . "/Setting[@Name='MenuPositionX']/@Value/text()", "" )
	s_MenuPositionY := f_ReadXML(SectionPath . "/Setting[@Name='MenuPositionY']/@Value/text()", "" )
	s_MenuPosition  := f_ReadXML(SectionPath . "/Setting[@Name='MenuPosition']/@Value/text()" , "1")
	s_TempShowAll   := f_ReadXML(SectionPath . "/Setting[@Name='TempShowAll']/@Value/text()"  , "0")
	s_ShowFileExt   := f_ReadXML(SectionPath . "/Setting[@Name='ShowFileExt']/@Value/text()"  , "*")
	s_AltFolderIcon := f_ReadXML(SectionPath . "/Setting[@Name='AltFolderIcon']/@Value/text()", "1")
	s_BrowseMode    := f_ReadXML(SectionPath . "/Setting[@Name='BrowseMode']/@Value/text()"   , "0")
	s_HideExt       := f_ReadXML(SectionPath . "/Setting[@Name='HideExt']/@Value/text()"      , "0")
	s_TCMenu        := f_ReadXML(SectionPath . "/Setting[@Name='TCMenu']/@Value/text()"       , "0")
	s_TCPath        := f_ReadXML(SectionPath . "/Setting[@Name='TCPath']/@Value/text()"       , "C:\totalcmd" )

	; others
	s_Language      := f_ReadXML(SectionPath . "/Setting[@Name='Language']/@Value/text()"     , "" )
	s_StartWithWin  := f_ReadXML(SectionPath . "/Setting[@Name='StartWithWin']/@Value/text()" , "0")
	s_NoTray        := f_ReadXML(SectionPath . "/Setting[@Name='NoTray']/@Value/text()"       , "0")
	s_CheckItmePath := f_ReadXML(SectionPath . "/Setting[@Name='CheckItmePath']/@Value/text()", "0")
	s_FileManager   := f_ReadXML(SectionPath . "/Setting[@Name='FileManager']/@Value/text()"  , "explore")
	s_Browser       := f_ReadXML(SectionPath . "/Setting[@Name='Browser']/@Value/text()"      , "" )
	s_TrayIconClick := f_ReadXML(SectionPath . "/Setting[@Name='TrayIconClick']/@Value/text()", "2")
	s_AddFavBottom  := f_ReadXML(SectionPath . "/Setting[@Name='AddFavBottom']/@Value/text()" , "0")
	s_AddFavSkipGUI := f_ReadXML(SectionPath . "/Setting[@Name='AddFavSkipGUI']/@Value/text()", "0")
	s_AddFavReplace := f_ReadXML(SectionPath . "/Setting[@Name='AddFavReplace']/@Value/text()", "0")
	s_AddFavApp     := f_ReadXML(SectionPath . "/Setting[@Name='AddFavApp']/@Value/text()"    , "1")
	s_AddFavAppCmd  := f_ReadXML(SectionPath . "/Setting[@Name='AddFavAppCmd']/@Value/text()" , "0")
	s_SearchSel     := f_ReadXML(SectionPath . "/Setting[@Name='SearchSel']/@Value/text()"    , "0")
	s_SearchSelUrl  := f_ReadXML(SectionPath . "/Setting[@Name='SearchSelUrl']/@Value/text()" , "http://www.google.com/search?q=%s")

	s_CheckVersion  := f_ReadXML(SectionPath . "/Setting[@Name='CheckVersion']/@Value/text()" , "1")

	return
}

f_ReadLanguage()
{
	Global
	Local Name, String, LangFile
	f_ReadLanguageDefault()
	LangFile := A_ScriptDir . "\" . s_Language . ".lng"
	Loop, Read, %LangFile%
	{
		if SubStr(A_LoopReadLine, 1, 1) != ";" && A_LoopReadLine != ""
		{
			f_Split2(A_LoopReadLine, "=", Name, String)
			Name   = %Name%
			String = %String% ; trim blanks
			StringReplace, String, String, ``n, `n, All
			StringReplace, String, String, ``t, % "	", All ; `t dont work??
			lang_%Name% := String
;			aaa .= Name . "`n--`n" . String . "`n------------------------------------------------`n"
		}
	}
	return
}

f_ReadLanguageDefault()
{
	Global
	; ToolMenu
	lang_ToolAdd   := "&Add Favorite"
	lang_ToolReload:= "&Reload"
	lang_ToolOption:= "&Options"
	lang_ToolEdit  := "&Edit"
	lang_ToolExit  := "E&xit"

	; MsgBox
	lang_Error  := "Error"
	lang_Warning:= "Warning"

	lang_CannotConnect    := "Cannot connect to the Internet."
	lang_ItemDuplicate    := "Item [%ItemName%] duplicated.`n`nPlease check your config file."
	lang_ItemPathDuplicate:= "Path of item [%ItemName%] duplicated.`n`n(%Item%)"
	lang_TooManyItems     := "There are more than 500 items (%ItemCount% items)`n`nDo you want to continue?"

	lang_NewVer            := "New Version!"
	lang_NewVerAvailable   := "There's a new version v%LatestVer% available.`n`nGo to website?"
	lang_NewVerNotAvailable:= "You are using the latest version v%CurrentVer%."

	lang_AddApp       := "Add Application"
	lang_AddAppEdit1  := "Title:`t[%Title%]`nClass:`t[%Class%]`n`nEdit1 exist!`n`nIs this the addressbar of that application?"
	lang_AddAppPrompt := "Do you want to add this application?"
	lang_AddAppNoEdit1:= "Title:`t[%Title%]`nClass:`t[%Class%]`n`nEdit1 do NOT exist!`n`nDo you still want to add this application?"

	lang_AddFav   := "Add Favorite"
	lang_ItemExist:= "[%NewItemName%] already exist.`n`n(%ItemName%)`n`nDo you want to replace it?"
	lang_PathExist:= "This path already exist.`n`n(%ItemName%)"
	lang_SaveChange:= "Would you like to save changes?"
	lang_EditReload:= "You have to reload Folder Menu to take effect after editing the xml file by notepad."

	lang_ServerDown:= "%ThisPathIP% is down."

	; ToolTip
	lang_LoadFav   := "Loading Favorites..."
	lang_LoadRecent:= "Loading Recent Items..."
	lang_LoadTemp  := "Loading Items..."

	; TrayTip
	lang_CannotOpenPath := "Could not open`n""%ItemPath%"""
	lang_CannotOpenBlank:= "Could not open`n""%ItemName%""`nIts path is blank."
	lang_CannotOpenClip := "Could not open`n""%Clipboard%"""
	lang_FavoriteAdded  := "[%ItemName%] added."
	lang_ShowHidden     := "Show hidden files."
	lang_HideHidden     := "Hide hidden files."
	lang_ShowFileExt    := "Show file extension."
	lang_HideFileExt    := "Hide file extension."
	lang_SVSDeactivate  := "Deactivating SVS Layer..."
	lang_SVSActivate    := "Activating SVS Layer..."

	; TrayTip Error Message
	lang_ErrSpecial := """%ItemPath%"" is not a valid special item."
	lang_ErrHotkey  := "Hotkey [%HotkeyKey%] (%HotkeyName%) error. (%ErrorLevel%)"

	; Option
	lang_OptionsTitle:= "Options"

	lang_OK    := "OK"
	lang_Cancel:= "Cancel"
	lang_Apply := "&Apply"

	lang_TipEdit:= "Edit Config.xml"
	lang_BiggerWindow := "Show a bigger options window"
	lang_SmallerWindow:= "Show a smaller options window"

	lang_Favorite   := "Favorites"
	lang_Application:= "Applications"
	lang_Hotkey     := "Hotkey"
	lang_Icon       := "Icons"
	lang_Menu       := "Menu"
	lang_Other      := "Others"
	lang_About      := "About"

	;favorite
	lang_Name := "Name"
	lang_Path := "Path"
	lang_Size := "Size"
	lang_Depth:= "Depth"

	lang_Up   := "^"
	lang_Down := "v"
	lang_Add  := "+"
	lang_Del  := "-"

	lang_TipBrowse:= "Browse a file or folder"
	lang_TipIcon  := "Pick icon"
	lang_TipAdd   := "Ins`nHolding Shift to insert a submenu"
	lang_TipDel   := "Del`nHolding Shift to delete a submenu"
	lang_TipDepth := "Max depth of auto created submenu`nIf this field is not blank, a submenu will be auto created`n0 for unlimited"

	lang_NewItem:= "New Item"
	lang_NewMenu:= "New Menu"

	lang_SelectFile  := "Select File"
	lang_SelectFolder:= "Select Folder"

	lang_MyComputer     := "My Computer"
	lang_AddFavorite    := "Add Favorite"
	lang_AddFavoriteHere:= "Add Favorite Here"
	lang_Reload         := "Reload"
	lang_Options        := "Options"
	lang_Edit           := "Edit Config File"
	lang_Exit           := "Exit"
	lang_ToggleHidden   := "Toggle Hidden Files"
	lang_ToggleFileExt  := "Toggle Hide File Extension"
	lang_SystemRecent   := "System Recent Menu"
	lang_ExplorerList   := "Explorer List"
	lang_DriveList      := "Drive List"
	lang_ToolMenu       := "Tool Menu"
	lang_RecentMenu     := "Recent Menu"
	lang_SVSMenu        := "SVS Menu"
	lang_TCMenu         := "TC Menu"
	lang_Separator      := "Separator"
	lang_BrowseFolder   := "&Browse Folder"
	lang_BrowseFile     := "B&rowse File"
	lang_SpecialItems   := "&Special Items"

	lang_TCDirMenu      := "Total Commander Directory Menu"
	lang_TipTCDirMenu   := "Use Total Commander to edit favorite folders"

	;application
	lang_SupportApplications:= "Select applications that you want to use Folder Menu"

	lang_Type := "Type"
	lang_Class:= "Class"

	lang_Match  := "Match"
	lang_Contain:= "Contain"

	lang_TipCSV       := "Can be comma separated value"
	lang_TipMatch     := """Match"" means the classname must exactly match the string.`n""Contain"" means the classname can contain the string anywhere"
	lang_TipAddDefault:= "Insert default items"

	lang_Explorer:= "Explorer"
	lang_Dialog  := "Open/Save Dialog"
	lang_DialogO := "Office Dialog"
	lang_Command := "Command"
	lang_Desktop := "Desktop"
	lang_7zFM    := "7-Zip File Manager"

	;hotkey
	lang_Action     := "Action"
	lang_ShowMenu   := "Show Menu"
	lang_OpenSelText:= "Open Selected Text"
	lang_HotkeyHelpB:= "&How to set hotkeys?"
	lang_HotkeyD    := "Double Click"
	lang_HotkeyN    := "Keep native function"
	lang_HotkeyHelp := "You can use the following modifiers:`n        #    Win        !    Alt        ^    Ctrl        +    Shift`n`nYou can also use double press as hotkey.`nFor example, ""DB~LButton"" means double click left mouse button.`nJust add the ""DB"" prefix to the hotkey.`n`nSee more details?"

	;icon
	lang_NoMenuIcon:= "Don't use any menu &icon"
	lang_IconSize  := "Icon size"
	lang_Extension := "Extension"
	lang_TipSize   := "Set size to 0 for maximum available size`nLeave blank for default size"
	lang_IconPath  := "Icon Path"
	lang_TipIconExt:= "Extension can be the following special items:`nUnknown   `tUnknown file type`nComputer  `tComputer item`nDrive        `tHDD items`nShare      `tUNC path item`nFolder      `tFolder items`nFolderS      `tFolder items which has subfolder`nMenu       `tSubmenu items`nRecent      `tSystem Recent item`nExplorer      `tExplorer List item"

	;menu
	lang_MenuPosition    := "Menu position"
	lang_RelativeToScreen:= "Relative to screen"
	lang_RelativeToWindow:= "Relative to window"
	lang_TipMenuPosition := "Leave coordinate blank to use mouse position"

	lang_RecentSize      := "Recent list size"
	lang_RecentSizeS     := "System recent list size"
	lang_RecentOnlyFolder:= "Keeps only folders"
	lang_RecentShowIndex := "Show index"
	lang_ClearRecent     := "Clear recent items"

	lang_TempMenu     := """Ctrl-Click"" Subfolder Menu"
	lang_TempShowAll  := "Show &files"
	lang_AltFolderIcon:= "Show different icon for folders which has subfolder"
	lang_TipTempExt   := "List the file extensions you want to show in the menu`n(Comma separated)"
	lang_UseTCMenu    := "Use TC menu as main menu"
	lang_TCPath       := "TC path"

	;other
	lang_Language     := "Language"
	lang_StartWithWin := "&Start with windows"
	lang_NoTray       := "No &tray icon"
	lang_CheckVersion := "Check for &new version at startup"
	lang_BrowseMode   := "Use &browse mode when capslock is off"
	lang_HideExt      := "Hide e&xtension"
	lang_CheckItmePath:= "Check duplicated item &path"
	lang_FileManager  := "File manager path"
	lang_Browser      := "Browser path"
	lang_TipFileManager:="Set the file manager to open folders`n""explore"" will use the default explorer`n""open"" will directly open the folder"
	lang_TrayIconClick:= "Action for clicking on tray icon"
	lang_AddFavBottom := "Add new item at bottom"
	lang_AddFavSkipGUI:= "Skip options GUI"
	lang_AddFavReplace:= "Replace existing item without asking"
	lang_AddFavApp    := "Add application to favorite"
	lang_AddFavAppCmd := "Get command line"
	lang_TipAddFavApp := "If the active window is not a supported application, add the application as a favorite"
	lang_SearchSel    := "Search with this url if selected text could not be opened"
	lang_Search       := "Search"

	;about
	lang_Website  := "Website"
	lang_CheckVer := "Check for new version"
	lang_Translate:= "Translated by rexx"

	;hotkey to set focus on addressbar in windows explorer, !d by default (Alt+D)
	lang_AddrHotkey := "!d"

	;menu item
	lang_RunSVSAdmin:= "Run SVS Admin"
	lang_Empty      := "Empty"

	return
}

f_SetConfig()
{
	Global

	f_SupportApps =
	f_SupportAppsC =
	Loop, % s_ApplicationsCount
	{
		if s_Applications%A_Index%Check
		{
			if s_Applications%A_Index%Type = C
				f_SupportAppsC .= "," . s_Applications%A_Index%Class
			else
				f_SupportApps .= "," . s_Applications%A_Index%Class
		}
	}
;	if SubStr(f_SupportApps, 1, 1) = ","
	StringTrimLeft, f_SupportApps, f_SupportApps, 1
;	if SubStr(f_SupportAppsC, 1, 1) = ","
	StringTrimLeft, f_SupportAppsC, f_SupportAppsC, 1

	if s_NoTray = 1
		Menu, Tray, NoIcon
	else
		Menu, Tray, Icon

	if s_StartWithWin = 1
		RegWrite, REG_SZ, HKCU, Software\Microsoft\Windows\CurrentVersion\Run, FolderMenu, %A_ScriptFullPath%
	else
		RegDelete, HKCU, Software\Microsoft\Windows\CurrentVersion\Run, FolderMenu

	Local ThisExt, ThisSize, ThisPath, ThisIndex
	Loop, % s_IconsCount
	{
		ThisExt   := f_TrimVarName(s_Icons%A_Index%Ext)
		ThisPath  := s_Icons%A_Index%Path
		ThisPath  := f_DerefPath(ThisPath)
		ThisIndex := s_Icons%A_Index%Index
		ThisSize  := s_Icons%A_Index%Size
		f_Icons_%ThisExt% = %ThisPath%,%ThisIndex%`n%ThisSize%
	}

	if s_TrayIconClick = 1
		Hotkey, #!+^x, f_DisplayMenu1, UseErrorLevel
	else if s_TrayIconClick = 2
		Hotkey, #!+^x, f_DisplayMenu15, UseErrorLevel
	else if s_TrayIconClick = 3
		Hotkey, #!+^x, f_DisplayMenu2, UseErrorLevel

	if s_TrayIconClick = 1
		Menu, Tray, Add, &Folder Menu, f_DisplayMenu1
	else if s_TrayIconClick = 2
		Menu, Tray, Add, &Folder Menu, f_DisplayMenu15
	else if s_TrayIconClick = 3
		Menu, Tray, Add, &Folder Menu, f_DisplayMenu2

	Local ThisName, ThisKey, ThisLab
	Loop, % s_HotkeysCount
	{
		; disable old
		StringReplace, ThisKey, f_Hotkeys%A_Index%Key, DB
		Hotkey, %ThisKey%, Off, UseErrorLevel
		; update
		f_Hotkeys%A_Index%Key := s_Hotkeys%A_Index%Key
		; set new
		ThisKey  := s_Hotkeys%A_Index%Key
		ThisLab  := s_Hotkeys%A_Index%Lab
		ThisName := f_HotkeyLab2Name(ThisLab) ;s_Hotkeys%A_Index%Name
		if ThisKey !=
		{
			if InStr(ThisKey, "DB")
			{
				StringReplace, ThisKey, ThisKey, DB
				Hotkey, %ThisKey%, %ThisLab%DB, UseErrorLevel
			}
			else
			{
				Hotkey, %ThisKey%, %ThisLab%, UseErrorLevel
			}
			if ErrorLevel in 2,3,4
			{
				Local ErrHotkey
				StringReplace, ErrHotkey, lang_ErrHotkey, `%HotkeyName`%, %ThisName%
				StringReplace, ErrHotkey, ErrHotkey, `%HotkeyKey`%, %ThisKey%
				StringReplace, ErrHotkey, ErrHotkey, `%ErrorLevel`%, %ErrorLevel%
				f_ErrorMsg = %f_ErrorMsg%%ErrHotkey%`n
			}
		}
		; enable which didn't change
		Hotkey, %ThisKey%, On, UseErrorLevel
	}

	COMMANDER_PATH := s_TCPath

	return
}

f_ReadFavorites()
{
	Global lang_LoadFav, s_TCMenu
	ToolTip, %lang_LoadFav%
	Global s_FavoritesCount = 0
	if s_TCMenu
		f_CreateTCMenu()
	else
		f_CreateMenu("/FolderMenu/Menu/Item[1]", "MainMenu")
	ToolTip
	return
}

f_CreateMenu(XMLPath, MenuName)
{
	Global
	Critical
	Local ItemType, ItemName, ItemPath, ItemIcon, ItemSize, ItemDepth, ItemVarName
	Menu, %MenuName%, Add
	Menu, %MenuName%, DeleteAll
	i_%MenuName%ItemPos = 1
	Loop, % xpath(f_ConfigXML, XMLPath . "/Item/count()")
	{
;		ToolTip, Loading Favorites...`nMenu %MenuName%`, Item %A_Index%
		ItemType := xpath(f_ConfigXML, XMLPath . "/Item[" . A_Index . "]/@Type/text()")
		if ItemType = Separator
		{
			Menu, %MenuName%, Add
			i_%MenuName%ItemPos++
		}
		else if ItemType = Item
		{
			ItemName := f_XMLUnescape(xpath(f_ConfigXML, XMLPath . "/Item[" . A_Index . "]/@Name/text()"))
			if ItemName =
				ItemName = [No Name]
			ItemPath := f_XMLUnescape(xpath(f_ConfigXML, XMLPath . "/Item[" . A_Index . "]/@Path/text()"))
			ItemIcon := f_XMLUnescape(xpath(f_ConfigXML, XMLPath . "/Item[" . A_Index . "]/@Icon/text()"))
			ItemSize := f_XMLUnescape(xpath(f_ConfigXML, XMLPath . "/Item[" . A_Index . "]/@Size/text()"))
			if s_CheckItmePath
			{
				Local ThisItem := f_ItemPathExist(ItemPath)
				if ThisItem
				{
					Local ItemPathDuplicate
					StringReplace, ItemPathDuplicate, lang_ItemPathDuplicate, `%ItemName`%, %ItemName%
					StringReplace, ItemPathDuplicate, ItemPathDuplicate, `%Item`%, %ThisItem%
					MsgBox, 48, %lang_Warning%, %ItemPathDuplicate%
				}

			}
			s_FavoritesCount++
			s_Favorites%s_FavoritesCount%Name := ItemName
			s_Favorites%s_FavoritesCount%Path := ItemPath
			if f_MenuItemExist(MenuName, ItemName)
			{
				Local ItemDuplicate
				StringReplace, ItemDuplicate, lang_ItemDuplicate, `%ItemName`%, %ItemName%
				MsgBox, 16, %lang_Error%, %ItemDuplicate%
				Loop
				{
					if !f_MenuItemExist(MenuName, ItemName . "	" . A_Index+1)
					{
						ItemName := ItemName . "	" . A_Index+1
						break
					}
				}
;				return "duplicate"
			}
			if SubStr(ItemPath, 1, 1) = "_" ; special items
			{
				if ItemPath = _ToolAdd
				{
					Menu, %MenuName%, Add, %ItemName%, f_AddFavorite
					if ItemIcon =
						ItemIcon := f_Icons . ",-301"
				}
				else if ItemPath = _ToolAddHere
				{
					Menu, %MenuName%, Add, %ItemName%, f_AddFavoriteHere
					if ItemIcon =
						ItemIcon := f_Icons . ",-301"
				}
				else if ItemPath = _ToolReload
				{
					Menu, %MenuName%, Add, %ItemName%, f_ToolReload
					if ItemIcon =
						ItemIcon := f_Icons . ",-302"
				}
				else if ItemPath = _ToolToggleHidden
				{
					Menu, %MenuName%, Add, %ItemName%, f_ToolToggleHidden
					if ItemIcon =
						ItemIcon := f_Icons . ",-302"
				}
				else if ItemPath = _ToolToggleFileExt
				{
					Menu, %MenuName%, Add, %ItemName%, f_ToolToggleFileExt
					if ItemIcon =
						ItemIcon := f_Icons . ",-302"
				}
				else if ItemPath = _ToolOptions
				{
					Menu, %MenuName%, Add, %ItemName%, f_ToolOptions
					if ItemIcon =
						ItemIcon := f_Icons . ",-303"
				}
				else if ItemPath = _ToolEdit
				{
					Menu, %MenuName%, Add, %ItemName%, f_ToolEdit
					if ItemIcon =
						ItemIcon := f_Icons . ",-304"
				}
				else if ItemPath = _ToolExit
				{
					Menu, %MenuName%, Add, %ItemName%, f_ToolExit
					if ItemIcon =
						ItemIcon := f_Icons . ",-305"
				}
				else if ItemPath = _SystemRecent
				{
					Menu, %MenuName%, Add, %ItemName%, f_SystemRecent
					if ItemIcon =
						ItemIcon := f_GetIcon("Recent")
				}
				else if ItemPath = _ExplorerList
				{
					Menu, %MenuName%, Add, %ItemName%, f_ExplorerList
					if ItemIcon =
						ItemIcon := f_GetIcon("Explorer")
				}
				else if ItemPath = _DriveList
				{
					Menu, %MenuName%, Add, %ItemName%, f_DriveList
					if ItemIcon =
						ItemIcon := f_GetIcon("Computer")
				}
				else if ItemPath = _ToolMenu
				{
					f_CreateToolMenu()
					Menu, %MenuName%, Add, %ItemName%, :ToolMenu
					if ItemIcon =
						ItemIcon := f_Icons . ",0"
				}
				else if ItemPath = _RecentMenu
				{
					f_RecentEnabled = 1
					f_CreateRecentMenu()
					Menu, %MenuName%, Add, %ItemName%, :RecentMenu
					if ItemIcon =
						ItemIcon := f_Icons . ",-307"
				}
				else if ItemPath = _DebugMenu
				{
					f_CreateDebugMenu()
					Menu, %MenuName%, Add, %ItemName%, :DebugMenu
					if ItemIcon =
						ItemIcon := f_Icons . ",-306"
				}
				else if ItemPath = _SVSMenu
				{
					f_CreateSVSMenu()
					Menu, %MenuName%, Add, %ItemName%, :SVSMenu
					if ItemIcon =
						ItemIcon := "svsadmin.exe"
				}
				else if ItemPath = _TCMenu
				{
					f_CreateTCMenu()
					Menu, %MenuName%, Add, %ItemName%, :TCMenu
					if ItemIcon =
						ItemIcon := s_TCPath . "\totalcmd.exe"
				}
				else
				{
					Local ErrSpecial
					StringReplace, ErrSpecial, lang_ErrSpecial, `%ItemPath`%, %ItemPath%
					f_ErrorMsg = %f_ErrorMsg%%ErrSpecial%`n
				}
			}
			else ; a normal item
			{
				Local ItemPos
				ItemPos := i_%MenuName%ItemPos
				; Resolve any references to variables within either field
				i_%MenuName%Path%ItemPos% := ItemPath
;				i_%MenuName%Path%ItemPos% := f_DerefPath(ItemPath)
				Menu, %MenuName%, Add, %ItemName%, f_OpenFavorite
				if ItemIcon =
					ItemIcon := f_GetIcon(i_%MenuName%Path%ItemPos%)
				if ItemIcon = This ; default icon is %1
					ItemIcon := i_%MenuName%Path%ItemPos%
			}
			SetWorkingDir % i_%MenuName%Path%ItemPos%
			f_SetMenuIcon(MenuName, ItemName, ItemIcon, ItemSize)
			SetWorkingDir %A_ScriptDir%
			i_%MenuName%ItemPos++
		}
		else if ItemType = ItemMenu
		{
			ItemName := f_XMLUnescape(xpath(f_ConfigXML, XMLPath . "/Item[" . A_Index . "]/@Name/text()"))
			if ItemName =
				ItemName = [No Name]
			ItemVarName := MenuName . "@" . f_TrimVarName(ItemName)
			ItemPath := f_XMLUnescape(xpath(f_ConfigXML, XMLPath . "/Item[" . A_Index . "]/@Path/text()"))
			ItemIcon := f_XMLUnescape(xpath(f_ConfigXML, XMLPath . "/Item[" . A_Index . "]/@Icon/text()"))
			ItemSize := f_XMLUnescape(xpath(f_ConfigXML, XMLPath . "/Item[" . A_Index . "]/@Size/text()"))
			ItemDepth:= f_XMLUnescape(xpath(f_ConfigXML, XMLPath . "/Item[" . A_Index . "]/@Depth/text()"))
			if s_CheckItmePath
			{
				Local ThisItem := f_ItemPathExist(ItemPath)
				if ThisItem
				{
					Local ItemPathDuplicate
					StringReplace, ItemPathDuplicate, lang_ItemPathDuplicate, `%ItemName`%, %ItemName%
					StringReplace, ItemPathDuplicate, ItemPathDuplicate, `%Item`%, %ThisItem%
					MsgBox, 48, %lang_Warning%, %ItemPathDuplicate%
				}
			}
			s_FavoritesCount++
			s_Favorites%s_FavoritesCount%Name := ItemName
			s_Favorites%s_FavoritesCount%Path := ItemPath
			if f_MenuItemExist(MenuName, ItemName)
			{
				Local ItemDuplicate
				StringReplace, ItemDuplicate, lang_ItemDuplicate, `%ItemName`%, %ItemName%
				MsgBox, 16, %lang_Error%, %ItemDuplicate%
				Loop
				{
					if !f_MenuItemExist(MenuName, ItemName . "	" . A_Index+1)
					{
						ItemName := ItemName . "	" . A_Index+1
						break
					}
				}
;				return "duplicate"
			}
			Local ItemPos
			ItemPos := i_%MenuName%ItemPos
			; Resolve any references to variables within either field
			i_%MenuName%Path%ItemPos% := ItemPath
;			i_%MenuName%Path%ItemPos% := f_DerefPath(ItemPath)
			f_CreateItemMenu(i_%MenuName%Path%ItemPos%, ItemVarName, ItemDepth)
			Menu, %MenuName%, Add, %ItemName%, :%ItemVarName%
			if ItemIcon =
				ItemIcon := f_GetIcon(i_%MenuName%Path%ItemPos%)
			if ItemIcon = This ; default icon is %1
				ItemIcon := i_%MenuName%Path%ItemPos%
			SetWorkingDir % i_%MenuName%Path%ItemPos%
			f_SetMenuIcon(MenuName, ItemName, ItemIcon, ItemSize)
			SetWorkingDir %A_ScriptDir%
			i_%MenuName%ItemPos++
		}
		else if ItemType = Menu
		{
			ItemName := f_XMLUnescape(xpath(f_ConfigXML, XMLPath . "/Item[" . A_Index . "]/@Name/text()"))
			if ItemName =
				ItemName = [No Name]
			if f_MenuItemExist(MenuName, ItemName)
			{
				Local ItemDuplicate
				StringReplace, ItemDuplicate, lang_ItemDuplicate, `%ItemName`%, %ItemName%
				MsgBox, 16, %lang_Error%, %ItemDuplicate%
				Loop
				{
					if !f_MenuItemExist(MenuName, ItemName . "	" . A_Index+1)
					{
						ItemName := ItemName . "	" . A_Index+1
						break
					}
				}
;				return "duplicate"
			}
			ItemVarName := f_TrimVarName(ItemName)
			f_Menu_%ItemVarName% := ItemName
			ItemVarName := MenuName . "@" . ItemVarName
			ItemIcon := f_XMLUnescape(xpath(f_ConfigXML, XMLPath . "/Item[" . A_Index . "]/@Icon/text()"))
			ItemSize := f_XMLUnescape(xpath(f_ConfigXML, XMLPath . "/Item[" . A_Index . "]/@Size/text()"))
			f_CreateMenu(XMLPath . "/Item[" . A_Index . "]", ItemVarName)
			Menu, %MenuName%, Add, %ItemName%, :%ItemVarName%
			if ItemIcon =
				ItemIcon := f_GetIcon("Menu")
			f_SetMenuIcon(MenuName, ItemName, ItemIcon, ItemSize)
			i_%MenuName%ItemPos++
		}
	}
;	ToolTip
	return
}

f_WriteXML(XMLPath, Name, Value)
{
	Global f_ConfigXML
	Name  := f_XMLEscape(Name)
	Value := f_XMLEscape(Value)
;	xpath(f_ConfigXML, XMLPath . "/Setting[@Name='" . Name . "']/remove()")
	xpath(f_ConfigXML, XMLPath . "/Setting[+1]/@Name/text()", Name)
	xpath(f_ConfigXML, XMLPath . "/Setting[@Name='" . Name . "']/@Value/text()", Value)
	return
}

f_WriteConfig()
{
	Global
	Local SectionPath

	; applications
	SectionPath := "/FolderMenu/Settings/Applications"
	xpath(f_ConfigXML, SectionPath . "/Setting[@Name='ApplicationList']/remove()")
	xpath(f_ConfigXML, SectionPath . "/Setting[+1]/@Name/text()", "ApplicationList")
	Local ThisName, ThisClass, ThisType, ThisCheck
	Loop, % s_ApplicationsCount
	{
		ThisName := f_XMLEscape(s_Applications%A_Index%Name)
		ThisClass:= f_XMLEscape(s_Applications%A_Index%Class)
		ThisType := s_Applications%A_Index%Type
		ThisCheck:= s_Applications%A_Index%Check
		xpath(f_ConfigXML, SectionPath . "/Setting[@Name='ApplicationList']/Application[+1]", "<Application Name=""" . ThisName . """ Class=""" . ThisClass . """ Type=""" . ThisType . """ Check=""" . ThisCheck . """ />")
	}

	; hotkeys
	SectionPath := "/FolderMenu/Settings/Hotkeys"
	xpath(f_ConfigXML, SectionPath . "/Setting[@Name='HotkeyList']/remove()")
	xpath(f_ConfigXML, SectionPath . "/Setting[+1]/@Name/text()", "HotkeyList")
	Local ThisName, ThisKey, ThisLab
	Loop, % s_HotkeysCount
	{
		ThisKey  := s_Hotkeys%A_Index%Key
		ThisLab  := s_Hotkeys%A_Index%Lab
		xpath(f_ConfigXML, SectionPath . "/Setting[@Name='HotkeyList']/Hotkey[+1]", "<Hotkey Key=""" . ThisKey . """ Lab=""" . ThisLab . """ />")
	}

	; icons
	SectionPath := "/FolderMenu/Settings/Icons"
	xpath(f_ConfigXML, SectionPath . "/remove()")
	xpath(f_ConfigXML, SectionPath . "[+1]")
	f_WriteXML(SectionPath, "NoMenuIcon", s_NoMenuIcon)
	f_WriteXML(SectionPath, "IconSize"  , s_IconSize  )
	xpath(f_ConfigXML, SectionPath . "/Setting[@Name='IconList']/remove()")
	xpath(f_ConfigXML, SectionPath . "/Setting[+1]/@Name/text()", "IconList")
	Local ThisExt, ThisPath, ThisIndex, ThisSize
	Loop, % s_IconsCount
	{
		ThisExt   := f_XMLEscape(s_Icons%A_Index%Ext)
		ThisPath  := f_XMLEscape(s_Icons%A_Index%Path)
		ThisIndex := s_Icons%A_Index%Index
		ThisSize  := s_Icons%A_Index%Size
		xpath(f_ConfigXML, SectionPath . "/Setting[@Name='IconList']/Icon[+1]", "<Icon Ext=""" . ThisExt . """ Path=""" . ThisPath . """ Index=""" . ThisIndex . """ Size=""" . ThisSize . """ />")
	}

	; recent
	SectionPath := "/FolderMenu/Settings/Recents"
	xpath(f_ConfigXML, SectionPath . "/remove()")
	xpath(f_ConfigXML, SectionPath . "[+1]")
	f_WriteXML(SectionPath, "RecentSize"       , s_RecentSize       )
	f_WriteXML(SectionPath, "RecentSizeS"      , s_RecentSizeS      )
	f_WriteXML(SectionPath, "RecentOnlyFolder" , s_RecentOnlyFolder )
	f_WriteXML(SectionPath, "RecentOnlyFolderS", s_RecentOnlyFolderS)
	f_WriteXML(SectionPath, "RecentShowIndex"  , s_RecentShowIndex  )
	xpath(f_ConfigXML, SectionPath . "/Setting[@Name='RecentList']/remove()")
	xpath(f_ConfigXML, SectionPath . "/Setting[+1]/@Name/text()", "RecentList")
	Loop, % s_RecentSize
		xpath(f_ConfigXML, SectionPath . "/Setting[@Name='RecentList']/Recent[+1]/@Path/text()", f_XMLEscape(s_Recents%A_Index%))

	; menu
	SectionPath := "/FolderMenu/Settings/Others"
	xpath(f_ConfigXML, SectionPath . "/remove()")
	xpath(f_ConfigXML, SectionPath . "[+1]")
	f_WriteXML(SectionPath, "MenuPositionX", s_MenuPositionX)
	f_WriteXML(SectionPath, "MenuPositionY", s_MenuPositionY)
	f_WriteXML(SectionPath, "MenuPosition" , s_MenuPosition )
	f_WriteXML(SectionPath, "TempShowAll"  , s_TempShowAll  )
	f_WriteXML(SectionPath, "ShowFileExt"  , s_ShowFileExt  )
	f_WriteXML(SectionPath, "AltFolderIcon", s_AltFolderIcon)
	f_WriteXML(SectionPath, "BrowseMode"   , s_BrowseMode   )
	f_WriteXML(SectionPath, "HideExt"      , s_HideExt      )
	f_WriteXML(SectionPath, "TCMenu"       , s_TCMenu       )
	f_WriteXML(SectionPath, "TCPath"       , s_TCPath       )

	; others
	f_WriteXML(SectionPath, "Language"     , s_Language     )
	f_WriteXML(SectionPath, "StartWithWin" , s_StartWithWin )
	f_WriteXML(SectionPath, "NoTray"       , s_NoTray       )
	f_WriteXML(SectionPath, "CheckItmePath", s_CheckItmePath)
	f_WriteXML(SectionPath, "FileManager"  , s_FileManager  )
	f_WriteXML(SectionPath, "Browser"      , s_Browser      )
	f_WriteXML(SectionPath, "TrayIconClick", s_TrayIconClick)
	f_WriteXML(SectionPath, "AddFavBottom" , s_AddFavBottom )
	f_WriteXML(SectionPath, "AddFavSkipGUI", s_AddFavSkipGUI)
	f_WriteXML(SectionPath, "AddFavReplace", s_AddFavReplace)
	f_WriteXML(SectionPath, "AddFavApp"    , s_AddFavApp    )
	f_WriteXML(SectionPath, "AddFavAppCmd" , s_AddFavAppCmd )
	f_WriteXML(SectionPath, "SearchSel"    , s_SearchSel    )
	f_WriteXML(SectionPath, "SearchSelUrl" , s_SearchSelUrl )

	f_WriteXML(SectionPath, "CheckVersion" , s_CheckVersion )

	; favorites
	f_WriteFavorites()

	return
}



;==================== Display The Menu ====================;

f_DisplayMenu1:
f_Hotkey1_Always = 0
Gosub, f_DisplayMenu
return

f_DisplayMenu15:
f_Hotkey1_Always = 1
Gosub, f_DisplayMenu
return

f_DisplayMenu2:	; Always show menu
; Clear the w_Edit1Pos to do the default action
;w_WinID =
WinGet, w_WinID, ID, A
WinGet, w_WinMin, MinMax, ahk_id %w_WinID%
if w_WinMin = -1	; Only detect windows not Minimized.
	return
w_Class =
w_Edit1Pos =
f_ShowMenu("MainMenu")
return

f_DisplayMenu:
; These first few variables are set here and used by f_OpenFavorite:
WinGet, w_WinID, ID, A
WinGet, w_WinMin, MinMax, ahk_id %w_WinID%
if w_WinMin = -1	; Only detect windows not Minimized.
	return
WinGetClass, w_Class, ahk_id %w_WinID%

; by MILK
; This code checks for the known "dockable" applications/windows so that
; when the user clicks on the icon (instead of pressing the hotkey), the
; app will detect the previous activate window, get its ID and class
; and let it be the FolderMenu target.
if !w_Class ; Windows 7/AHK problem: doesnt return active window
	w_Class = ***

; This is the list of windows classes for the applications that are supposed
; to run FolderMenu.exe from its icons. If any of these classes are detected
; than I know I have to get the previously active window so that the context
; menu works. We can add classes, maybe make it an option in the ini, futurely.
; Currently, it works with Taskbar Tray Icon, Windows QuickLauch,
; Windows 7 Superbar, Windows 7 Notification Icons, ObjectDock Docklet and
; RocketDock. They have all been tested successfully.
f_DockableApps = ***,DockItemClass,DockItemTitleWindow,DockCatcher,DockBackgroundClass,ODIndicator,RocketDock,Shell_TrayWnd,NotifyIconOverflowWindow
if w_Class in %f_DockableApps%
{
	; here we check to see if it is a top level window
	WS_OVERLAPPEDWINDOW := 0x0cf0000
	WS_POPUPWINDOW := 0x80880000
	WinGet, w_WinIDs, List
	Loop, %w_WinIDs%
	{
		w_WinID := w_WinIDs%A_Index%
		WinGet, w_Style, Style, ahk_id %w_WinID%
		WinGet, w_ExStyle, ExStyle, ahk_id %w_WinID%
		; for the window to be considered a valid target we discard non-toplevel windows
		; AND topmost (always on top) windows. We skip the topmost because they are the
		; first to come in the list. Also, topmost windows don't usually have context
		; meaning such as TaskManager, Sidebar, System Monitors, etc.
		if ((w_Style & WS_OVERLAPPEDWINDOW) || (w_Style & WS_POPUPWINDOW)) && !(w_ExStyle & 0x8)
		{
			WinGet, w_WinMin, MinMax, ahk_id %w_WinID%
			if w_WinMin != -1
			{
				WinGetClass, w_Class, ahk_id %w_WinID%
				if w_Class not in %f_DockableApps%
				{
					WinActivate ahk_id %w_WinID%
					break
				}
			}
		}
	}
}

w_Edit1Pos =

; return if not supported
if w_Class not in %f_SupportApps%
if w_Class not contains %f_SupportAppsC%
{
	if f_Hotkey1_Always
	{
		w_WinID =
		w_Class =
		w_Edit1Pos =
		f_ShowMenu("MainMenu")
		return
	}
	else
		return
}

; Vista Explorer
if w_Class = CabinetWClass
{
	ControlGetPos, w_Edit1Pos,,,, Edit1, ahk_id %w_WinID%
	if A_OSVersion = WIN_VISTA	; For new addresbar in Vista or 7
	{
		if w_Edit1Pos =
		{
;			if SubStr(A_Language, 3, 2) = 07
;				Send, !e ; Set focus on addressbar to enable Edit1
;			else
;				Send, !d ; Set focus on addressbar to enable Edit1
			Send, %lang_AddrHotkey% ; Set focus on addressbar to enable Edit1
			Sleep, 100
			ControlGetPos, w_Edit1Pos,,,, Edit1, ahk_id %w_WinID%
		}
	}
	if w_Edit1Pos !=
		f_ShowMenu("MainMenu")
	return
}
; Dialog, Explorer, Total Commander, FileZilla 3
if w_Class in #32770,ExploreWClass,TTOTAL_CMD,TxUNCOM.UnicodeClass,FM,wxWindowClassNR ; no spaces around ','
{
	ControlGetPos, w_Edit1Pos,,,, Edit1, ahk_id %w_WinID%
	if w_Edit1Pos !=
		f_ShowMenu("MainMenu")
	return
}
; Microsoft Office application
if w_Class contains bosa_sdm_
{
	ControlGetPos, w_Edit1Pos,,,, RichEdit20W2, ahk_id %w_WinID%
	if w_Edit1Pos !=
		f_ShowMenu("MainMenu")
	return
}
; Rxvt command prompt
if w_Class contains rxvt
{
	w_Edit1Pos = 1
	f_ShowMenu("MainMenu")
	return
}
; Command Prompt, Emacs, FreeCommander, Console2
if w_Class in ConsoleWindowClass,Emacs,TfcForm ;,Console_2_Main
{
	w_Edit1Pos = 1
	f_ShowMenu("MainMenu")
	return
}
; Desktop
if w_Class in Progman,WorkerW
{
	w_WinID =
	w_Class =
	w_Edit1Pos =
	f_ShowMenu("MainMenu")
	return
}
; Others
if w_Class in %f_SupportApps%
{
;	ControlGetPos, w_Edit1Pos,,,, Edit1, ahk_id %w_WinID%
;	if w_Edit1Pos !=
	w_Edit1Pos = 1
	f_ShowMenu("MainMenu")
	return
}
; Others
if w_Class contains %f_SupportAppsC%
{
;	ControlGetPos, w_Edit1Pos,,,, Edit1, ahk_id %w_WinID%
;	if w_Edit1Pos !=
	w_Edit1Pos = 1
	f_ShowMenu("MainMenu")
	return
}
; Else don't display menu
return

f_ShowMenu(Menu)
{
	Global
	Local X, Y, W, H
	CoordMode, Mouse , Screen
	if s_MenuPosition = 1 ; relative to screen
	{
		if s_MenuPositionX =
			MouseGetPos, X
		else
			X = %s_MenuPositionX%
		if s_MenuPositionY =
			MouseGetPos, , Y
		else
			Y = %s_MenuPositionY%
	}
	else if s_MenuPosition = 2 ; relative to window
	{
		WinGetPos, X, Y, W, H, A
		if s_MenuPositionX = ; blank, use current mouse position
			MouseGetPos, X
		else if s_MenuPositionX < %W% ; < window width, inside window
			X := X + s_MenuPositionX
		else ; out of window, use window edge
			X := X + W
		if s_MenuPositionY =
			MouseGetPos, , Y
		else if s_MenuPositionY < %H%
			Y := Y + s_MenuPositionY
		else
			Y := Y + H
	}
	CoordMode, Menu , Screen
	if s_TCMenu && Menu = "MainMenu" ; use TC menu as main menu
		Menu := "TCMenu"
	Menu, %Menu%, Show, %X%, %Y%
	return
}

;==================== Open Favorite Item ====================;

f_OpenFavorite:
; Fetch the array element that corresponds to the selected menu item:
f_OpenFavPath := i_%A_ThisMenu%Path%A_ThisMenuItemPos%
if f_OpenFavPath =
{
	StringReplace, lang_CannotOpenBlank_, lang_CannotOpenBlank, `%ItemName`%, %A_ThisMenuItem%
	TrayTip, %lang_Error%, %lang_CannotOpenBlank_%, , 3
	return
}

if InStr(f_OpenFavPath, "%F_CurrentDir%")
	StringReplace, f_OpenFavPath, f_OpenFavPath, `%F_CurrentDir`%, % f_GetPath(w_WinID, w_Class) . "\", All

if f_OpenFavPath = Computer
	f_OpenFavPath = "::{20D04FE0-3AEA-1069-A2D8-08002B30309D}"
if (f_OpenFavPath = "::{20D04FE0-3AEA-1069-A2D8-08002B30309D}")
	f_OpenFavPath = "::{20D04FE0-3AEA-1069-A2D8-08002B30309D}"

f_OpenFavPath := f_DerefPath(f_OpenFavPath)

if SubStr(f_OpenFavPath, 1, 1) = "*" ; file filter
{
	; Dialog
	if w_Class = #32770
	{
		WinActivate ahk_id %w_WinID%
		ControlGetText, w_Edit1Text, Edit1, ahk_id %w_WinID%
		ControlClick, Edit1, ahk_id %w_WinID%
		ControlSetText, Edit1, %f_OpenFavPath%, ahk_id %w_WinID%
		ControlSend, Edit1, {Enter}, ahk_id %w_WinID%
		Sleep, 100	; It needs extra time on some dialogs or in some cases.
		ControlSetText, Edit1, %w_Edit1Text%, ahk_id %w_WinID%
	}
	; Microsoft Office application
	else if w_Class contains bosa_sdm_
	{
		WinActivate ahk_id %w_WinID%
		ControlGetText, w_Edit1Text, RichEdit20W2, ahk_id %w_WinID%
		ControlClick, RichEdit20W2, ahk_id %w_WinID%
		ControlSetText, RichEdit20W2, %f_OpenFavPath%, ahk_id %w_WinID%
		ControlSend, RichEdit20W2, {Enter}, ahk_id %w_WinID%
		Sleep, 100
		ControlSetText, RichEdit20W2, %w_Edit1Text%, ahk_id %w_WinID%
	}
	; Command Prompt (thanks to Mr. Milk)
	else if w_Class = ConsoleWindowClass
	{
		StringReplace, f_OpenFavPath, f_OpenFavPath, `;, %A_Space%, All
		f_OpenFavPath := "for /R %a in (" . f_OpenFavPath . ") do @echo %~aa %~ta %~za`t%~Fa"
		WinActivate, ahk_id %w_WinID% ; Because sometimes the mclick deactivates it.
		SetKeyDelay, 0 ; This will be in effect only for the duration of this thread.
		f_SendBig5("cmd.exe /F:OFF")
		Send, {Enter}
		f_SendBig5(f_OpenFavPath)
		Send, {Enter}exit{Enter}
	}
	; Vista Explorer (thanks to Mr. Milk)
	else if A_OSVersion = WIN_VISTA
	{
		if f_OpenFavPath != *.*
		{
			StringReplace, f_OpenFavPath, f_OpenFavPath, *., ext:, All
			StringReplace, f_OpenFavPath, f_OpenFavPath, `;, %A_Space%OR%A_Space%, All
		}
		if w_Class in CabinetWClass
			Send, ^e ; Set focus on searchbox to enable Edit2
		else
		{
			Send, #f ; Open vista search
			WinWaitActive, ahk_class CabinetWClass, , 5
			WinGet, w_WinID, ID
			Sleep, 100
		}
;		ControlSetText, Edit2, %f_OpenFavPath%, ahk_id %w_WinID%
		Send, %f_OpenFavPath%
		WinActivate ahk_id %w_WinID%
	}
	return
}

if SubStr(f_OpenFavPath, 1, 10) = "svscmd.exe"
{
	if SubStr(f_OpenFavPath, -1) = " D"
		TrayTip, SVS, %lang_SVSDeactivate%, , 1
	else
		TrayTip, SVS, %lang_SVSActivate%, , 1
	RunWait, %f_OpenFavPath%, , Hide UseErrorLevel
;	Sleep, 1000
;	TrayTip
	f_CreateSVSMenu()
	return
}

; if CapsLock is on, use browse mode
if (!s_BrowseMode && GetKeyState("CapsLock", "T")) || (s_BrowseMode && !GetKeyState("CapsLock", "T"))
{
	if A_ThisMenu = TempMenu
	{
		if (A_ThisMenuItemPos = 2) || (A_ThisMenuItemPos = 1 && A_ThisMenuItem != "..\") ; current folder item
		{
			f_OpenPath(f_OpenFavPath)
			return
		}
	}
	if f_IsFolder(f_OpenFavPath)
	{
		if GetKeyState("Shift") && GetKeyState("Ctrl")
			f_OpenTempMenu(f_OpenFavPath, 1)
		else if GetKeyState("Shift") || GetKeyState("Ctrl") || GetKeyState("RButton")
			f_OpenPath(f_OpenFavPath)
		else
			f_OpenTempMenu(f_OpenFavPath, s_TempShowAll)
		return
	}
}
; Holding ctrl (or shift) (or right mouse button)
; Holding both ctrl and shift for files and folders
if GetKeyState("Shift") && GetKeyState("Ctrl")
{
	if f_IsFolder(f_OpenFavPath)
		f_OpenTempMenu(f_OpenFavPath, 1)
	else
		ShellContextMenu(f_OpenFavPath)
}
else if GetKeyState("Shift") || GetKeyState("Ctrl") || GetKeyState("RButton")
{
	if f_IsFolder(f_OpenFavPath)
		f_OpenTempMenu(f_OpenFavPath, s_TempShowAll)
	else
		ShellContextMenu(f_OpenFavPath)
}
else
	f_OpenPath(f_OpenFavPath)
return

f_OpenUNC(ThisPath)
{
	Global lang_Error, lang_ServerDown
	if InStr(ThisPath, "\", "", 3)
		ThisPathIP := SubStr(ThisPath, 3, InStr(ThisPath, "\", "", 3)-3)
	else
		ThisPathIP := SubStr(ThisPath, 3)
	RunWait, cmd /c ping %ThisPathIP% -n 1 > %Temp%\f_ping.tmp, , Hide
	FileRead, PingResult, %Temp%\f_ping.tmp
	FileDelete, %Temp%\f_ping.tmp
	if InStr(PingResult, "ms")
		Run, %ThisPath%, , UseErrorLevel
	else
	{
		StringReplace, ServerDown, lang_ServerDown, `%ThisPathIP`%, %ThisPathIP%
		MsgBox, 16, %lang_Error%, %ServerDown%
	}
	return
}

f_OpenPath(ThisPath)
{
	Global
	; not a folder, file not exist, not UNC path, run it
	if !f_IsFolder(ThisPath) && !FileExist(ThisPath) && SubStr(ThisPath, 1, 2) <> "\\"
	{
		if !f_RunPath(ThisPath) ; if no error
			if f_RecentEnabled = 1
				if !s_RecentOnlyFolder ; if recent not only record folders
					f_AddRecent(ThisPath)
		return
	}

	if w_Edit1Pos =
	{
		Run, %s_FileManager% %ThisPath%, , UseErrorLevel	; Might work on more systems without double quotes.
		if ErrorLevel
			f_RunPath(ThisPath)
	}
	else
	{
		; Dialog
		if w_Class = #32770
		{
			; Activate the window so that if the user is middle-clicking
			; outside the dialog, subsequent clicks will also work:
			WinActivate ahk_id %w_WinID%
			; Retrieve any filename that might already be in the field so
			; that it can be restored after the switch to the new folder:
			ControlGetText, w_Edit1Text, Edit1, ahk_id %w_WinID%
			ControlClick, Edit1, ahk_id %w_WinID%
			ControlSetText, Edit1, %ThisPath%, ahk_id %w_WinID%
			ControlSend, Edit1, {Enter}, ahk_id %w_WinID%
			Sleep, 100	; It needs extra time on some dialogs or in some cases.
			ControlSetText, Edit1, %w_Edit1Text%, ahk_id %w_WinID%
		}
		; Explorer
		else if w_Class in CabinetWClass,ExploreWClass
		{
			;ControlClick, Edit1, ahk_id %w_WinID%
			Local PathEdit := f_GetPathEdit(w_WinID)
			ControlSetText, %PathEdit%, %ThisPath%, ahk_id %w_WinID%
			; Tekl reported the following: "If I want to change to Folder L:\folder
			; then the addressbar shows http://www.L:\folder.com. To solve this,
			; I added a {right} before {Enter}":
			ControlSend, %PathEdit%, {Right}{Enter}, ahk_id %w_WinID%
			WinActivate ahk_id %w_WinID%
		}
		; 7-Zip File Manager
		else if w_Class = FM
		{
			MouseGetPos, , , , w_Control
			if w_Control = SysListView322 ; second panel
			{
				ControlSetText, Edit2, %ThisPath%, ahk_id %w_WinID%
				ControlSend, Edit2, {Enter}, ahk_id %w_WinID%
			}
			else
			{
				ControlSetText, Edit1, %ThisPath%, ahk_id %w_WinID%
				ControlSend, Edit1, {Enter}, ahk_id %w_WinID%
			}
		}
		; FileZilla 3
		else if w_Class = wxWindowClassNR
		{
			if InStr(FileExist(ThisPath), "D")
			{
				ControlGetPos, w_Edit1Pos,,,, Edit5, ahk_id %w_WinID%
				if w_Edit1Pos != ; it has quick connect bar, addressbar is edit5
				{
					ControlSetText, Edit5, %ThisPath%, ahk_id %w_WinID%
					ControlSend, Edit5, {Enter}, ahk_id %w_WinID%
				}
				else
				{
					ControlSetText, Edit1, %ThisPath%, ahk_id %w_WinID%
					ControlSend, Edit1, {Enter}, ahk_id %w_WinID%
				}
				ControlFocus, SysListView321, ahk_id %w_WinID% ; Set focus to file list
			}
			else
				f_RunPath(ThisPath)
		}
		; Microsoft Office application
		else if w_Class contains bosa_sdm_
		{
			WinActivate ahk_id %w_WinID%
			ControlGetText, w_Edit1Text, RichEdit20W2, ahk_id %w_WinID%
			ControlClick, RichEdit20W2, ahk_id %w_WinID%	;<----------important!!!
			ControlSetText, RichEdit20W2, %ThisPath%, ahk_id %w_WinID%
			ControlSend, RichEdit20W2, {Enter}, ahk_id %w_WinID%
			Sleep, 100
			ControlSetText, RichEdit20W2, %w_Edit1Text%, ahk_id %w_WinID%
		}
		; Total Commander (thanks to FatZgrED)
		else if w_Class in TTOTAL_CMD,TxUNCOM.UnicodeClass
		{
			;Total Commander has Edit1 control but you need to cd to location
			if InStr(FileExist(ThisPath), "D")
			{
				ControlSetText, Edit1, cd %ThisPath%, ahk_id %w_WinID%
				ControlSend, Edit1, {Enter}, ahk_id %w_WinID%
			}
			else
				f_RunPath(ThisPath)
		}
		; FreeCommander (thanks to catweazle (John))
		else if w_Class = TfcForm
		{
			Send, !g
			ControlClick, TfcPathEdit1, ahk_id %w_WinID%
			ControlSetText, TfcPathEdit1, %ThisPath%, ahk_id %w_WinID%
			ControlSend, TfcPathEdit1, {Enter}, ahk_id %w_WinID%
		}
		; Command Prompt
		else if w_Class = ConsoleWindowClass
		{
			if InStr(FileExist(ThisPath), "D")
			{
				WinActivate, ahk_id %w_WinID%	; Because sometimes the mclick deactivates it.
				SetKeyDelay, 0	; This will be in effect only for the duration of this thread.
				f_SendBig5("cd /d " . ThisPath . "\") ; (thanks to tireless for the /d switch)
				Send, {Enter}
			}
			else
				f_RunPath(ThisPath)
		}
		; Emacs (thanks to catweazle (John))
		else if w_Class = Emacs
		{
			WinActivate, ahk_id %w_WinID%
			SetKeyDelay, 0
			Send, !xfind-file{Enter}
			Send, %ThisPath%{Tab}
		}
		; Rxvt command prompt (thanks to catweazle (John))
		else if w_Class contains rxvt
		{
			if InStr(FileExist(ThisPath), "D")
			{
				WinActivate, ahk_id %w_WinID%
				SetKeyDelay, 0
				Send, cd `'%ThisPath%`'{Enter}
				Send, ls{Enter}
			}
			else
				f_RunPath(ThisPath)
		}
		; Others
		else if w_Class in %f_SupportApps%
		{
			if InStr(FileExist(ThisPath), "D")
			{
				ControlClick, Edit1, ahk_id %w_WinID%
				ControlSetText, Edit1, %ThisPath%, ahk_id %w_WinID%
				ControlSend, Edit1, {Right}{Enter}, ahk_id %w_WinID%
			}
			else
				f_RunPath(ThisPath)
		}
		; Others
		else if w_Class contains %f_SupportAppsC%
		{
			if InStr(FileExist(ThisPath), "D")
			{
				ControlClick, Edit1, ahk_id %w_WinID%
				ControlSetText, Edit1, %ThisPath%, ahk_id %w_WinID%
				ControlSend, Edit1, {Right}{Enter}, ahk_id %w_WinID%
			}
			else
				f_RunPath(ThisPath)
		}
	}
	if f_RecentEnabled = 1
	{
		if f_IsFolder(ThisPath) or SubStr(ThisPath, 1, 2) = "\\" ; it's a folder
			f_AddRecent(ThisPath)
		else
			if !s_RecentOnlyFolder ; if recent not only record folders
				f_AddRecent(ThisPath)
	}
	return
}

f_RunPath(ThisPath)
{
	Global lang_Error, lang_CannotOpenPath
	if InStr(ThisPath, "http://") or InStr(ThisPath, "https://") ; url
		if !f_OpenUrl(ThisPath)
			return 0
	Run, %ThisPath%, , UseErrorLevel ; run a file
	if ErrorLevel
	{
		if f_OpenReg(ThisPath) ; open reg
		{
			StringReplace, CannotOpenPath, lang_CannotOpenPath, `%ItemPath`%, %ThisPath%
			TrayTip, %lang_Error%, %CannotOpenPath%, , 3
			return 1
		}
	}
	return 0
}

f_OpenUrl(ThisPath)
{
	Global s_Browser
	Run, %s_Browser% %ThisPath%, , UseErrorLevel ; run a file or url
	return ErrorLevel
}

f_IsFolder(ThisPath)
{
	if InStr(FileExist(ThisPath), "D")
	|| (ThisPath = """::{20D04FE0-3AEA-1069-A2D8-08002B30309D}""")
;	|| SubStr(ThisPath, 1, 2) = "\\"
		return 1
	else
		return 0
}

f_GetPathEdit(ThisID) ; get the classnn of the addressbar, thanks to F1reW1re
{
	WinGetClass, ThisClass, ahk_id %ThisID%
	if ThisClass not in ExploreWClass,CabinetWClass
		return
	ControlGetText, ComboBoxEx321_Content, ComboBoxEx321, ahk_id %ThisID%
	WinGet, ActiveControlList, ControlList, ahk_id %ThisID%
	Loop, Parse, ActiveControlList, `n
	{
		StringLeft, WhichControl, A_LoopField, 4
		if WhichControl = Edit
		{
			ControlGetText, Edit_Content, %A_LoopField%, ahk_id %ThisID%
			if ComboBoxEx321_Content = %Edit_Content%
			{
				return % A_LoopField
			}
		}
	}
	return
}



;==================== Add Favorite ====================;

f_AddFavoriteK:
; Clear the w_WinID to get info from active window
;w_WinID =
;w_Class =
Gosub, f_AddFavorite
return

f_GetPath(WindowID, Class)
{
	Global f_SupportApps, f_SupportAppsC, lang_AddrHotkey
	if Class in #32770
	{
		if A_OSVersion = WIN_VISTA
		{
			ControlGetPos, ToolbarPos,,,, ToolbarWindow322, ahk_id %WindowID%
			if ToolbarPos !=
			{
;				Send, !d ; Set focus on addressbar to enable Edit2
				Send, %lang_AddrHotkey% ; Set focus on addressbar to enable Edit2
				Sleep, 100
				ControlGetText, ThisPath, Edit2, ahk_id %WindowID%
			}
		}
		if ThisPath = ; nothing retrieved, maybe it's an old open/save dialog
		{
			ControlGetText, ThisFolder, ComboBox1, ahk_id %WindowID% ; current folder name
			ControlGet, List, List,, ComboBox1, ahk_id %WindowID% ; list of folders on the path
			Loop, Parse, List, `n ; create array and get position of this folder
			{
				List%A_Index% = %A_LoopField%
				if A_LoopField = %ThisFolder%
					ThisIndex = %A_Index%
			}
			Loop, % ThisIndex ; add path til root
			{
				Index0 := ThisIndex - A_Index + 1 ; ThisIndex ~ 1
				IfInString, List%Index0%, : ; drive root
				{
					ThisPath := SubStr(List%Index0%, InStr(List%Index0%, ":")-1, 2) . "\" . ThisPath
					break
				}
				ThisPath := List%Index0% . "\" . ThisPath
			}
		}
	}
	else if Class in CabinetWClass,ExploreWClass
	{
		if A_OSVersion = WIN_VISTA
		{
			ControlGetPos, ToolbarPos,,,, ToolbarWindow322, ahk_id %WindowID%
			if ToolbarPos !=
			{
;				if SubStr(A_Language, 3, 2) = 07
;					Send, !e ; Set focus on addressbar to enable Edit1
;				else
;					Send, !d ; Set focus on addressbar to enable Edit1
				Send, %lang_AddrHotkey% ; Set focus on addressbar to enable Edit1
				Sleep, 100
				ControlGetText, ThisPath, ComboBoxEx321, ahk_id %WindowID%
;				ControlGetText, ThisPath, Edit1, ahk_id %WindowID%
			}
		}
		else
			ControlGetText, ThisPath, ComboBoxEx321, ahk_id %WindowID%
;			ControlGetText, ThisPath, Edit1, ahk_id %WindowID%
	}
	else if Class = FM
	{
		MouseGetPos, , , , w_Control
		if w_Control = SysListView322 ; second panel
			ControlGetText, ThisPath, Edit2, ahk_id %WindowID%
		else
			ControlGetText, ThisPath, Edit1, ahk_id %WindowID%
	}
	else if Class = wxWindowClassNR
	{
		ControlGetPos, Edit1Pos,,,, Edit5, ahk_id %WindowsID%
		if Edit1Pos != ; it has quick connect bar, addressbar is edit5
			ControlGetText, ThisPath, Edit5, ahk_id %WindowID%
		else
			ControlGetText, ThisPath, Edit1, ahk_id %WindowID%
	}
	else if Class in TTOTAL_CMD,TxUNCOM.UnicodeClass
	{
		ControlGetText, Edit1Text, Edit1, ahk_id %WindowID%
		Send, {Esc}^p ; get current path, thanks to winflowers
		ControlGetText, ThisPath, Edit1, ahk_id %WindowID%
		ControlSetText, Edit1, %Edit1Text%, ahk_id %WindowID%
	}
	else if Class = TfcForm
	{
		Send, !g
		ControlGetText, ThisPath, TfcPathEdit1, ahk_id %WindowID%
	}
	else if Class = ConsoleWindowClass
	{
		SetKeyDelay, 0	; This will be in effect only for the duration of this thread.
		Send, cd > %Temp%\f_cd.tmp{Enter}
		Sleep, 100
		FileReadLine, ThisPath, %Temp%\f_cd.tmp, 1
		FileDelete, %Temp%\f_cd.tmp
	}
	else if Class in %f_SupportApps% ; others
	{
		ControlGetText, ThisPath, Edit1, ahk_id %WindowID%
	}
	else if Class contains %f_SupportAppsC%
	{
		ControlGetText, ThisPath, Edit1, ahk_id %WindowID%
	}
	; Remove the trailing backslash.
	if ThisPath !=
		if f_LastIsBackslash(ThisPath)
			StringTrimRight, ThisPath, ThisPath, 1
	return ThisPath
}

f_GetName(ThisPath)
{
	StringReplace, ThisPath, ThisPath, `", , All
	if ThisPath !=
		f_SplitPath(ThisPath, ThisName, a)
	Global s_HideExt
	if s_HideExt
		SplitPath, ThisName, , , , ThisName
	if ThisName =	; if empty, use whole path as name.
		ThisName = %ThisPath%
	return ThisName
}



;==================== Get Win Class Hotkey ====================;

f_AddApp:
WinGet, w_WinID, ID, A
WinGet, w_WinMin, MinMax, ahk_id %w_WinID%
if w_WinMin = -1	; Only detect windows not Minimized.
	return
WinGetTitle, w_Title, ahk_id %w_WinID%
WinGetClass, w_Class, ahk_id %w_WinID%

if f_AddAppEdit1(w_WinID) ; edit1 exist
{
	StringReplace, lang_AddAppEdit1_, lang_AddAppEdit1 , `%Title`%, %w_Title%
	StringReplace, lang_AddAppEdit1_, lang_AddAppEdit1_, `%Class`%, %w_Class%
	MsgBox, 36, %lang_AddApp%, %lang_AddAppEdit1_%
	IfMsgBox Yes
	{
		MsgBox, 36, %lang_AddApp%, %lang_AddAppPrompt%
		IfMsgBox Yes
			Gosub, f_AddApplication
	}
}
else
{
	StringReplace, lang_AddAppNoEdit1_, lang_AddAppNoEdit1 , `%Title`%, %w_Title%
	StringReplace, lang_AddAppNoEdit1_, lang_AddAppNoEdit1_, `%Class`%, %w_Class%
	MsgBox, 308, %lang_AddApp%, %lang_AddAppNoEdit1_%
	IfMsgBox Yes
		Gosub, f_AddApplication
}
Gui, 3:Destroy
return

f_AddAppEdit1(WinID)
{
	WinGetPos, wx, wy, , , ahk_id %WinID%
	ControlGetPos, x, y, w, h, Edit1, ahk_id %WinID%	; Get edit1
	if x = ; edit1 not found
		return 0
	x := wx + x
	y := wy + y
	Gui 3:+LastFound +AlwaysOnTop -Caption +ToolWindow  ; +ToolWindow avoids a taskbar button and an alt-tab menu item.
	Gui, 3:Color, FFBBBB
	WinSet, Transparent, 128
	WinSet, ExStyle, ^0x00000020 ; click through
	Gui, 3:Show, x%x% y%y% w%w% h%h% NoActivate  ; NoActivate avoids deactivating the currently active window.
	return 1
}

f_AddApplication:
;gui_hh = 0
;gui_ww = 0
gui_Tab = %lang_Application%
Gosub, f_OptionsGUI
GuiControl, ChooseString, gui_Tab, %gui_Tab%
Gosub, f_ApplicationAdd
gui_AppSelected := LV_GetNext()
LV_Modify(gui_AppSelected, "Vis", w_Title, "M", w_Class)
return



;==================== Open Selected Path Hotkey ====================;

f_OpenSel:
f_ClipSaved := ClipboardAll
Send, ^c
Clipwait
f_OpenSelected(Clipboard)
Clipboard := f_ClipSaved
f_ClipSaved = ; Free the memory in case the clipboard was very large.
return

f_OpenSelected(SelectedPath)
{
	SelectedPath := f_DerefPath(SelectedPath)
	StringReplace, SelectedPath, SelectedPath, \, \, All
	; Remove the trailing backslash.
	if f_LastIsBackslash(SelectedPath)
		StringTrimRight, SelectedPath, SelectedPath, 1
	if SelectedPath !=
	{
		if SubStr(SelectedPath, 1, 2) = "\\" ; UNC path
		{
			f_OpenUNC(SelectedPath)
			if f_RecentEnabled = 1
				f_AddRecent(SelectedPath)
			return
		}
		else if InStr(SelectedPath, "http://") or InStr(SelectedPath, "https://")
		{
			f_OpenUrl(SelectedPath)
		}
		else
		{
			Run, %s_FileManager% %SelectedPath%, , UseErrorLevel
			if ErrorLevel
				if f_RunPath(SelectedPath)
				{
					Global lang_Error, lang_CannotOpenClip, s_SearchSel
					StringReplace, CannotOpenClip, lang_CannotOpenClip, `%Clipboard`%, %Clipboard%
					if s_SearchSel
					{
						Global s_SearchSelUrl, lang_Search
						CannotOpenClip .= "`n" . lang_Search . "`n""" . Clipboard . """"
						StringReplace, SearchSelUrl, s_SearchSelUrl, `%s, %Clipboard%
						TrayTip, %lang_Error%, %CannotOpenClip%, , 1
						f_OpenUrl(SearchSelUrl)
					}
					return ; don't keep error item
				}
		}
		Global f_RecentEnabled
		if f_RecentEnabled = 1
		{
			if f_IsFolder(SelectedPath) ; it's a folder
				f_AddRecent(SelectedPath)
			else
				if !s_RecentOnlyFolder ; if recent not only record folders
					f_AddRecent(SelectedPath)
		}
	}
	return
}



;==================== Functions ====================;

f_Split2(String, Separator, ByRef LeftStr, ByRef RightStr)
{
	SplitPos := InStr(String, Separator)
	if SplitPos = 0 ; Separator not found, L = Str, R = ""
	{
		LeftStr := String
		RightStr:= ""
	}
	else
	{
		SplitPos--
		StringLeft, LeftStr, String, %SplitPos%
		SplitPos++
		StringTrimLeft, RightStr, String, %SplitPos%
	}
	return
}

f_OpenReg(RegPath)
{
	StringLeft, RegPathFirst4, RegPath, 4
	if RegPathFirst4 = HKCR
		StringReplace, RegPath, RegPath, HKCR, HKEY_CLASSES_ROOT
	if RegPathFirst4 = HKCU
		StringReplace, RegPath, RegPath, HKCU, HKEY_CURRENT_USER
	if RegPathFirst4 = HKLM
		StringReplace, RegPath, RegPath, HKLM, HKEY_LOCAL_MACHINE

	StringLeft, RegPathFirst4, RegPath, 4
	if RegPathFirst4 = HKEY
	{
		RegRead, MyComputer, HKEY_CURRENT_USER, Software\Microsoft\Windows\CurrentVersion\Applets\Regedit, LastKey
		f_Split2(MyComputer, "\", MyComputer, aaa)
		RegWrite, REG_SZ, HKEY_CURRENT_USER, Software\Microsoft\Windows\CurrentVersion\Applets\Regedit, LastKey, %MyComputer%\%RegPath%
		Run regedit.exe /m ; thanks to DemoJameson for the /m switch
		return 0
	}
	else
		return 1
}

f_SendBig5(xx) ; Thanks to Lumania @ Ptt
{
	i := StrLen(xx)
	if i=0
		return
	Loop
	{
		tmp1 := NumGet(xx, 0, "UChar")
		if tmp1<128
		{
			i--
			StringTrimLeft, xx, xx, 1
		}
		else
		{
			tmp1 := (tmp1<<8) | NumGet(xx, 1, "UChar")
			i -= 2
			StringTrimLeft, xx, xx, 2
		}
		Send, {ASC %tmp1%}
		if i = 0
			break
	}
}

f_SetMenuIcon(Menu, Item, IconPath, Size="") ; Index start from 0, IconPath: [Path],[Index]`n[Size]
{
	Global s_NoMenuIcon, s_IconSize
	StringReplace, IconPath, IconPath, `", , All
	IconPath := f_DerefPath(IconPath)
	if Size = ; if size not specified, look iconpath for size
	{
		f_Split2(IconPath, "`n", IconPath, Size)
		if Size = ; if still not specified, use default
			Size := s_IconSize
	}
	if !s_NoMenuIcon
	{
		Menu, Tray, UseErrorLevel
		f_Split2(IconPath, ",", IconPath, Index)
		if Index > 0 ; dont change negative index
			Index++ ; index start from 1 for ahk
		Menu, %Menu%, Icon, %Item%, %IconPath%, %Index%, %Size%
;		if ErrorLevel
;			MsgBox, Menu, %Menu%, Icon, %Item%, %IconPath%, %Index%, %Size%
		Menu, Tray, UseErrorLevel, OFF
	}
	return
}

f_DerefPath(ThisPath)
{
	StringReplace, ThisPath, ThisPath, ``, ````, All
;	StringReplace, ThisPath, ThisPath, `", , All
;	StringReplace, ThisPath, ThisPath, `%, ```%, All
	StringReplace, ThisPath, ThisPath, `%F_CurrentDir`%, ```%F_CurrentDir```%, All
	Transform, ThisPath, deref, %ThisPath%
	return ThisPath
}

f_GetIcon(ThisPath)
{
	Global
	StringReplace, ThisPath, ThisPath, `", , All
	ThisPath := f_DerefPath(ThisPath)
	if f_LastIsBackslash(ThisPath)
		StringTrimRight, ThisPath, ThisPath, 1
	if SubStr(ThisPath, 1, 2) = "\\" ; UNC
	{
		if f_Icons_Share =
		{
			f_Icons_Share = %f_Icons%,-311 ; built-in icon
			f_Icons_Share := f_DerefPath(f_Icons_Share)
		}
		return f_Icons_Share
	}
	else if SubStr(ThisPath, 0) = ":" ; Drive
	{
		if f_Icons_Drive =
		{
			f_Icons_Drive = %f_Icons%,-309 ; built-in icon
			f_Icons_Drive := f_DerefPath(f_Icons_Drive)
		}
		return f_Icons_Drive
	}
	else if InStr(FileExist(ThisPath), "D") ; Folder
	{
		; read from desktop.ini first
		Local IconPath, IconFile, IconIndex
		IniRead, IconPath, %ThisPath%\Desktop.ini, `.ShellClassInfo, IconResource, %A_Space%
		if IconPath =
		{
			IniRead, IconFile , %ThisPath%\Desktop.ini, `.ShellClassInfo, IconFile , %A_Space%
			IniRead, IconIndex, %ThisPath%\Desktop.ini, `.ShellClassInfo, IconIndex, %A_Space%
			if IconFile !=
				IconPath = %IconFile%,%IconIndex%
		}
		if IconPath !=
		{
			IconPath := f_DerefPath(IconPath)
			return IconPath
		}
		if f_Icons_Folder =
		{
			f_Icons_Folder = %f_Icons%,-308 ; built-in icon
			f_Icons_Folder := f_DerefPath(f_Icons_Folder)
		}
		return f_Icons_Folder
	}
	else if ThisPath = FolderS ; Folder with subfolders
	{
		if f_Icons_FolderS =
		{
			f_Icons_FolderS = %f_Icons%,-1 ; built-in icon
			f_Icons_FolderS := f_DerefPath(f_Icons_FolderS)
		}
		return f_Icons_FolderS
	}
	else if ThisPath in Computer,"::{20D04FE0-3AEA-1069-A2D8-08002B30309D}",::{20D04FE0-3AEA-1069-A2D8-08002B30309D} ; Computer
	{
		if f_Icons_Computer =
		{
			f_Icons_Computer = %f_Icons%,-310 ; built-in icon
			f_Icons_Computer := f_DerefPath(f_Icons_Computer)
		}
		return f_Icons_Computer
	}
	else if ThisPath = Recent ; Recent
	{
		if f_Icons_Recent =
		{
			if A_OSVersion = WIN_VISTA
				f_Icons_Recent := "imageres.dll,-117"
			else
				f_Icons_Recent := "shell32.dll,-21"

			f_Icons_Recent := f_DerefPath(f_Icons_Recent)
		}
		return f_Icons_Recent
	}
	else if ThisPath = Menu ; Menu
	{
		if f_Icons_Menu =
		{
			f_Icons_Menu = %f_Icons%,0
			f_Icons_Menu := f_DerefPath(f_Icons_Menu)
		}
		return f_Icons_Menu
	}
	else if ThisPath = Explorer ; Explorer
	{
		if f_Icons_Explorer =
		{
			f_Icons_Explorer := "explorer.exe,1"
			f_Icons_Explorer := f_DerefPath(f_Icons_Explorer)
		}
		return f_Icons_Explorer
	}
	else ; a file, use its icon
	{
		Local ThisExtension ; get file extension
		SplitPath, ThisPath, , , ThisExtension
		; URL
		if InStr(ThisPath, "http://") or InStr(ThisPath, "https://")
			ThisExtension = url
		; Registry key
		if SubStr(ThisPath, 1, 2) = "HK"
			ThisExtension = reg
		; Link file
		if ThisExtension = lnk
		{
			Local TargetPath, IconPath, IconIndex
			FileGetShortcut, %ThisPath%, TargetPath, , , , IconPath, IconIndex
			if IconPath !=
				return IconPath . "," . IconIndex-1
			else
				return f_GetIcon(TargetPath)
		}
		; Unknown
		if ThisExtension =
			ThisExtension = Unknown
		if ThisExtension contains !, ,&,',(,),*,+,-,.,/,:,<,=,>,\,^,{,|,},~,``,`,,`",`%,`;
			ThisExtension = Unknown
		; Normal file
		; first check variables
		if f_Icons_%ThisExtension% =
		{
			; second read registry for system default icon
			if ThisExtension = Unknown
				RegRead, IconPath, HKEY_CLASSES_ROOT, Unknown\DefaultIcon
			else
			{
				Local FileType
				RegRead, FileType, HKEY_CLASSES_ROOT, .%ThisExtension%
				RegRead, IconPath, HKEY_CLASSES_ROOT, %FileType%\DefaultIcon
				if IconPath = ; check CLSID
				{
					Local CLSID
					RegRead, CLSID, HKEY_CLASSES_ROOT, %FileType%\CLSID
					RegRead, IconPath, HKEY_CLASSES_ROOT, CLSID\%CLSID%\DefaultIcon
				}
				if InStr(IconPath, "%1") ; the file icon is itself (%1 or "%1")
				{
					RegRead, CLSID, HKEY_CLASSES_ROOT, %FileType%\CLSID
					RegRead, IconPath, HKEY_CLASSES_ROOT, CLSID\%CLSID%\DefaultIcon
					if IconPath =
						IconPath = This
				}
				if IconPath =
					IconPath := f_GetIcon("") ; get unknown icon
				if FileType =
					IconPath := f_GetIcon("") ; get unknown icon
			}
			f_Icons_%ThisExtension% := f_DerefPath(IconPath)
		}
		return f_Icons_%ThisExtension%
	}
}

f_MenuItemExist(Menu, Item)
{
	Menu, %Menu%, UseErrorLevel
	Menu, %Menu%, Enable, %Item%
	if ErrorLevel	; Not exist
	{
		Menu, %Menu%, UseErrorLevel, OFF
		return 0
	}
	else	; Exist
	{
		Menu, %Menu%, UseErrorLevel, OFF
		return 1
	}
}

f_ItemPathExist(ThisPath)
{
	Global
	if ThisPath =
		return
	Loop, % s_FavoritesCount
	{
		if s_Favorites%A_Index%Path = %ThisPath%
			return s_Favorites%A_Index%Name . " = " . s_Favorites%A_Index%Path
	}
	return
}

f_TrimVarName(Str){
	StringReplace, Str, Str, @, _, All
	StringReplace, Str, Str, !, _, All
	StringReplace, Str, Str, &, _, All
	StringReplace, Str, Str, ', _, All
	StringReplace, Str, Str, (, _, All
	StringReplace, Str, Str, ), _, All
	StringReplace, Str, Str, *, _, All
	StringReplace, Str, Str, +, _, All
	StringReplace, Str, Str, -, _, All
	StringReplace, Str, Str, ., _, All
	StringReplace, Str, Str, /, _, All
	StringReplace, Str, Str, :, _, All
	StringReplace, Str, Str, <, _, All
	StringReplace, Str, Str, =, _, All
	StringReplace, Str, Str, >, _, All
	StringReplace, Str, Str, \, _, All
	StringReplace, Str, Str, ^, _, All
	StringReplace, Str, Str, {, _, All
	StringReplace, Str, Str, |, _, All
	StringReplace, Str, Str, }, _, All
	StringReplace, Str, Str, ~, _, All
	StringReplace, Str, Str, ``, _, All
	StringReplace, Str, Str, `,, _, All
	StringReplace, Str, Str, `", _, All
	StringReplace, Str, Str, `%, _, All
	StringReplace, Str, Str, `;, _, All
	StringReplace, Str, Str, % "	", _, All
	StringReplace, Str, Str, %A_Space%, _, All
	return Str
}

f_LastIsBackslash(ThisPath)
{
	if SubStr(ThisPath, 0) = "\" ; if last is \
	{
		StringTrimRight, ThisPath, ThisPath, 1 ; trim last \
		Loop ; prevent ??? problem
		{
			if ThisPath =
				return Mod(A_Index, 2)
			if Asc(SubStr(ThisPath, 0)) < 128 ; if last char is not lead byte
				return Mod(A_Index, 2) ; if 1, last char is \
			else
				StringTrimRight, ThisPath, ThisPath, 1 ; trim last, go to next char
		}
	}
	else
		return 0
}

f_SplitPath(ThisPath, ByRef FileName, ByRef Dir)
{
	Temp = %ThisPath%
	Loop
	{
		if f_LastIsBackslash(Temp)
		{
			FileNameLength := A_Index-1
			break
		}
		else
			StringTrimRight, Temp, Temp, 1 ; trim last, go to next char
	}
	StringRight, FileName, ThisPath, FileNameLength
	StringTrimRight, Dir, ThisPath, FileNameLength+1
	return
}

f_CreateMenuItem(ThisMenu, ThisItem, Quiet=0)
{
	Global
	if ThisMenu =
		return "empty"
	if ThisItem =
		return "empty"
	Local ThisItemName, ThisItemPath
	if ThisItem = - ; a separator
	{
		Menu, %ThisMenu%, Add
		i_%ThisMenu%ItemPos++
	}
	else	; a normal item
	{
		f_Split2(ThisItem, "=", ThisItemName, ThisItemPath)
		ThisItemName = %ThisItemName% ; Trim leading and trailing spaces.
		ThisItemPath = %ThisItemPath%
		if f_MenuItemExist(ThisMenu, ThisItemName)
		{
			Local ItemDuplicate
			StringReplace, ItemDuplicate, lang_ItemDuplicate, `%ItemName`%, %ThisItemName%
			if !Quiet
				MsgBox, 16, %lang_Error%, %ItemDuplicate%
			Loop
			{
				if !f_MenuItemExist(ThisMenu, ThisItemName . "	" . A_Index+1)
				{
					ThisItemName := ThisItemName . "	" . A_Index+1
					break
				}
			}
;			return "duplicate"
		}
		Local ItemPos := i_%ThisMenu%ItemPos
		i_%ThisMenu%Path%ItemPos% := f_DerefPath(ThisItemPath)
		Menu, %ThisMenu%, Add, %ThisItemName%, f_OpenFavorite

		if !s_NoMenuIcon && !InStr(ThisItemPath, "svscmd.exe")
		{
			Local ThisIcon := f_GetIcon(i_%ThisMenu%Path%ItemPos%)
			if ThisIcon = This ; default icon is %1
				ThisIcon := i_%ThisMenu%Path%ItemPos%

			; show different icon for folders which has subfolder
			if s_AltFolderIcon
				if ThisMenu = TempMenu
					if SubStr(ThisItemPath, 0) != ":" && SubStr(ThisItemName, 0) != "\" && ThisItemName != "..\"
						Loop, %ThisItemPath%\*, 2
						{
							ThisIcon := f_GetIcon("FolderS")
							break
						}

			SetWorkingDir % i_%ThisMenu%Path%ItemPos%
			f_SetMenuIcon(ThisMenu, ThisItemName, ThisIcon)
			SetWorkingDir %A_ScriptDir%
		}
		i_%ThisMenu%ItemPos++
	}
	return
}

f_CreateItemMenu(ThisFolderPath, MenuName, MaxDepth, Depth=1)
{
	Global
	Local ItemCount, FolderList, FileList
	Menu, %MenuName%, Add
	Menu, %MenuName%, DeleteAll	; delete old menu
	i_%MenuName%ItemPos = 1
	f_CreateMenuItem(MenuName, "[Open]=" . ThisFolderPath)
	f_CreateMenuItem(MenuName, "-")

	; Remove the trailing backslash
	if f_LastIsBackslash(ThisFolderPath)
		StringTrimRight, ThisFolderPath, ThisFolderPath, 1

	if MaxDepth =
		MaxDepth = 2

	if ThisFolderPath in Computer,"::{20D04FE0-3AEA-1069-A2D8-08002B30309D}",::{20D04FE0-3AEA-1069-A2D8-08002B30309D} ; Computer, list HDDs
	{
		ItemCount++
		Local DriveList, DriveSpace, FreeSpace, DriveName
		DriveGet, DriveList, List ;, FIXED
		Loop, Parse, DriveList
		{
			DriveGet, DriveSpace, Capacity, %A_LoopField%:\
			if DriveSpace =
				Continue
			DriveSpaceFree, FreeSpace, %A_LoopField%:\
			DriveName := A_LoopField . ":\	" . Round(FreeSpace/1024,1) . "GB/" . Round(DriveSpace/1024,1) . "GB    " . 100*FreeSpace//DriveSpace . "% Free"
			if (Depth < MaxDepth || MaxDepth = 0)
			{
				Local ItemName, ItemVarName, ItemIcon
				ItemName := DriveName
				ItemVarName := MenuName . "@" . f_TrimVarName(ItemName)
				ItemIcon := f_GetIcon("C:")
				f_CreateItemMenu(A_LoopField . ":\", ItemVarName, MaxDepth, Depth+1)
				Menu, %MenuName%, Add, %ItemName%, :%ItemVarName%
				f_SetMenuIcon(MenuName, ItemName, ItemIcon)
				i_%MenuName%ItemPos++
			}
			else
				FolderList = %FolderList%%DriveName%=%A_LoopField%:`n
		}
	}

	Loop, %ThisFolderPath%\*, 2
	{
		ItemCount++
		if (Depth < MaxDepth || MaxDepth = 0)
		{
			Local ItemName, ItemVarName, ItemIcon
			ItemName := A_LoopFileName
			ItemVarName := MenuName . "@" . f_TrimVarName(ItemName)
			ItemIcon := f_GetIcon(A_LoopFileFullPath)
			f_CreateItemMenu(A_LoopFileFullPath, ItemVarName, MaxDepth, Depth+1)
			Menu, %MenuName%, Add, %ItemName%, :%ItemVarName%
			SetWorkingDir % A_LoopFileFullPath
			f_SetMenuIcon(MenuName, ItemName, ItemIcon)
			SetWorkingDir %A_ScriptDir%
			i_%MenuName%ItemPos++
		}
		else
			FolderList = %FolderList%%A_LoopFileName%`=%A_LoopFileFullPath%`n
	}
	Loop, Parse, s_ShowFileExt, `,
	{
		Loop, %ThisFolderPath%\*.%A_LoopField%, 0
		{
			ItemCount++
			Local Name := A_LoopFileName
			if s_HideExt
				SplitPath, Name, , , , Name
			FileList = %FileList%%Name%`=%A_LoopFileFullPath%`n
		}
	}
	; sort and merge list
	Sort, FolderList
	Sort, FileList, U
	FileList = %FolderList%%FileList%

	; Create items
;	ToolTip, Loading Item Menu...
	Loop, parse, FileList, `n
	{
;		ToolTip, Loading Item Menu...`nItem %A_Index%
		if A_Index = 500
		{
			Local TooManyItems
			StringReplace, TooManyItems, lang_TooManyItems, `%ItemCount`%, %ItemCount%
			MsgBox, 308, %lang_Warning%, %TooManyItems%
			IfMsgBox No
				break
		}
		if A_LoopField !=
			f_CreateMenuItem(MenuName, A_LoopField, 1)
	}
;	ToolTip
	if i_%MenuName%ItemPos = 3
	{
		f_CreateMenuItem(MenuName, lang_Empty . " = nothing")
		Menu, %MenuName%, Disable, %lang_Empty%
	}
	return
}

f_ToolMenu:
f_CreateToolMenu()
f_ShowMenu("ToolMenu")
return

f_CreateToolMenu()
{
	Global
	Menu, ToolMenu, Add
	Menu, ToolMenu, DeleteAll	; delete old menu
	Menu, ToolMenu, Add, %lang_ToolAdd%   , f_AddFavorite
	Menu, ToolMenu, Add
	Menu, ToolMenu, Add, %lang_ToolReload%, f_ToolReload
	Menu, ToolMenu, Add, %lang_ToolOption%, f_ToolOptions
	Menu, ToolMenu, Add, %lang_ToolEdit%  , f_ToolEdit
	Menu, ToolMenu, Add
	Menu, ToolMenu, Add, %lang_ToolExit%  , f_ToolExit
	f_SetMenuIcon("ToolMenu", lang_ToolAdd   , f_Icons . ",-301")
	f_SetMenuIcon("ToolMenu", lang_ToolReload, f_Icons . ",-302")
	f_SetMenuIcon("ToolMenu", lang_ToolOption, f_Icons . ",-303")
	f_SetMenuIcon("ToolMenu", lang_ToolEdit  , f_Icons . ",-304")
	f_SetMenuIcon("ToolMenu", lang_ToolExit  , f_Icons . ",-305")
	return
}

f_CreateDebugMenu()
{
	Global
	Menu, DebugMenu, Add
	Menu, DebugMenu, DeleteAll	; delete old menu
	Menu, DebugMenu, Add, List&Lines, f_ListLines
	Menu, DebugMenu, Add, List&Vars, f_ListVars
	Menu, DebugMenu, Add, List&Hotkeys, f_ListHotkeys
	Menu, DebugMenu, Add, &KeyHistory, f_KeyHistory
	f_SetMenuIcon("DebugMenu", "List&Lines"  , f_Icons . ",1")
	f_SetMenuIcon("DebugMenu", "List&Vars"   , f_Icons . ",1")
	f_SetMenuIcon("DebugMenu", "List&Hotkeys", f_Icons . ",1")
	f_SetMenuIcon("DebugMenu", "&KeyHistory" , f_Icons . ",1")
	return
}

f_RecentMenu:
f_CreateRecentMenu()
f_ShowMenu("RecentMenu")
return

f_CreateRecentMenu()
{
	Global
	Menu, RecentMenu, Add
	Menu, RecentMenu, DeleteAll	; delete old menu
	i_RecentMenuItemPos = 1
	if s_Recents1 != ; if the list is not empty, create recent menu
	{
		Local Indexa
		Loop, % s_RecentSize
		{
			if s_Recents%A_Index% = ; it's blank
				continue
			if A_Index < 11
				Indexa := A_Index-1
			else
				Indexa := Chr(86+A_Index)
			Local ThisName, ThisDir, ThisNameNoExt
			ThisName := s_Recents%A_Index%
			if s_HideExt
			{
				SplitPath, ThisName, , ThisDir, , ThisNameNoExt
				ThisName = %ThisDir%\%ThisNameNoExt%
			}
			if s_RecentShowIndex
				f_CreateMenuItem("RecentMenu", "&" . indexa . "    " . ThisName . "=" . s_Recents%A_Index%)
			else
				f_CreateMenuItem("RecentMenu", ThisName . "=" . s_Recents%A_Index%)
		}
		Menu, RecentMenu, Add
		Menu, RecentMenu, Add, &r    %lang_ClearRecent%, f_ClearRecent
		f_SetMenuIcon("RecentMenu", "&r    " . lang_ClearRecent, f_Icons . ",-305")
		Menu, RecentMenu, Add
	}
	Menu, RecentMenu, Add, &s    %lang_SystemRecent%, f_SystemRecent
	f_SetMenuIcon("RecentMenu", "&s    " . lang_SystemRecent, f_GetIcon("Recent"))
	return
}

f_AddRecent(ThisPath)
{
	Global
	Local Index0, Index1, ThisIndex
	Loop, % s_RecentSize ; find if the item already exists
	{
		if s_Recents%A_Index% = %ThisPath%
			ThisIndex := A_Index
	}
	if ThisIndex = ; not found
		ThisIndex := s_RecentSize ; move all
	Loop, % ThisIndex-1 ; move only items above this item
	{
		Index0 := ThisIndex - A_Index ; ThisIndex-1 ~ 0
		Index1 := Index0 + 1           ; ThisIndex   ~ 1
		s_Recents%Index1% := s_Recents%Index0%
	}
	s_Recents1 = %ThisPath%
;	if s_RecentsCount < %s_RecentSize%
;		s_RecentsCount++

	xpath(f_ConfigXML, "/FolderMenu/Settings/Recents/Setting[@Name='RecentList']/remove()")
	xpath(f_ConfigXML, "/FolderMenu/Settings/Recents/Setting[+1]/@Name/text()", "RecentList")
	Loop, % s_RecentSize
		xpath(f_ConfigXML, "/FolderMenu/Settings/Recents/Setting[@Name='RecentList']/Recent[+1]/@Path/text()", f_XMLEscape(s_Recents%A_Index%))
	xpath_save(f_ConfigXML, A_ScriptDir . "\Config.xml")

	f_CreateRecentMenu()
	return
}

f_ClearRecent:
Loop, % s_RecentSize
	s_Recents%A_Index% =
;s_RecentsCount = 0
xpath(f_ConfigXML, "/FolderMenu/Settings/Recents/Setting[@Name='RecentList']/remove()")
xpath(f_ConfigXML, "/FolderMenu/Settings/Recents/Setting[+1]/@Name/text()", "RecentList")
xpath_save(f_ConfigXML, A_ScriptDir . "\Config.xml")
f_CreateRecentMenu()
return

f_SystemRecent:
f_CreateSystemRecentMenu()
f_ShowMenu("SystemRecentMenu")
return

f_CreateSystemRecentMenu()
{
	Menu, SystemRecentMenu, Add
	Menu, SystemRecentMenu, Delete	; delete old menu

	if A_OSVersion = WIN_VISTA
		RecentPath = %AppData%\Microsoft\Windows\Recent ; For Vista / 7
	else
		RecentPath = %UserProfile%\Recent ; For XP

	Global lang_LoadRecent
	ToolTip, %lang_LoadRecent%
	Loop, %RecentPath%\*.lnk
	{
;		ToolTip, Loading Recent Items...`nItem %A_Index%
		FileGetTime, ItemTime
		FormatTime, ItemTime, %ItemTime%, yyyy/MM/dd HH:mm:ss
		FileGetShortcut, %A_LoopFileLongPath%, ThisFolderPath
		Global s_RecentOnlyFolderS
		if !s_RecentOnlyFolderS ; not only folder, add all
		{
			if FileExist(ThisFolderPath)
			{
				ThisFolderName = %ThisFolderPath%
				Global s_HideExt
				if s_HideExt
				{
					SplitPath, ThisFolderPath, , ThisDir, , ThisNameNoExt
					ThisFolderName = %ThisDir%\%ThisNameNoExt%
				}
				RecentFolderList = %RecentFolderList%`n%ItemTime%    %ThisFolderName%`=%ThisFolderPath%
			}
		}
		else ; add only folders
		{
			if InStr(FileExist(ThisFolderPath), "D")
				RecentFolderList = %RecentFolderList%`n%ItemTime%    %ThisFolderPath%`=%ThisFolderPath%
		}
	}
	ToolTip
	if RecentFolderList =
	{
		Global lang_Empty
		f_CreateMenuItem("SystemRecentMenu", lang_Empty . " = nothing")
		Menu, SystemRecentMenu, Disable, %lang_Empty%
	}
	else
	{
		; Sort and create items
		Sort, RecentFolderList, R ; latest first
		Global i_SystemRecentMenuItemPos = 1
		Loop, parse, RecentFolderList, `n
		{
			Global s_RecentSizeS
			if A_Index > %s_RecentSizeS%
				break
			if A_LoopField !=
			{
				if A_Index < 11
					Indexa := A_Index-1
				else
					Indexa := Chr(86+A_Index)
				Global s_RecentShowIndex
				if s_RecentShowIndex
					f_CreateMenuItem("SystemRecentMenu", "&" . indexa . "    " . A_LoopField)
				else
					f_CreateMenuItem("SystemRecentMenu", A_LoopField)
			}
		}
	}
	return
}

f_DriveList:
f_OpenTempMenu("""::{20D04FE0-3AEA-1069-A2D8-08002B30309D}""")
return

f_OpenTempMenu(ThisFolderPath, ShowAll=0)
{
	Global
	; fix temp menu position
	; by MILK
	CoordMode, Mouse, Screen
	Local X, Y, sX, sY
	MouseGetPos, X, Y
	sX := s_MenuPositionX
	sY := s_MenuPositionY
	; -65 and -35 aligns current folder item with the mouse position
	s_MenuPositionX := X - 65
	s_MenuPositionY := Y - 35
	if f_CreateTempMenu(ThisFolderPath, ShowAll) ; has subfolders
	{
		f_ShowMenu("TempMenu")
		s_MenuPositionX := sX
		s_MenuPositionY := sY
		return 1
	}
	else ; no subfolder
	{
		f_ShowMenu("TempMenu")
		s_MenuPositionX := sX
		s_MenuPositionY := sY
		return 0
	}
}

f_CreateTempMenu(ThisFolderPath, ShowAll)
{
	Menu, TempMenu, Add
	Menu, TempMenu, Delete	; delete old menu

	; Remove the trailing backslash
	if f_LastIsBackslash(ThisFolderPath)
		StringTrimRight, ThisFolderPath, ThisFolderPath, 1

	; Get subfolders list
	if ThisFolderPath = "::{20D04FE0-3AEA-1069-A2D8-08002B30309D}" ; Computer, list HDDs
	{
		DriveGet, DriveList, List ;, FIXED
		Loop, Parse, DriveList
		{
			DriveGet, DriveSpace, Capacity, %A_LoopField%:\
			if DriveSpace =
				Continue
			DriveSpaceFree, FreeSpace, %A_LoopField%:\
			DriveName := A_LoopField . ":\	" . Round(FreeSpace/1024,1) . "GB/" . Round(DriveSpace/1024,1) . "GB    " . 100*FreeSpace//DriveSpace . "% Free"
			SubFolderList = %SubFolderList%%DriveName%=%A_LoopField%:`n
		}
	}
	else
	{
		Global s_ShowFileExt
		if ShowAll
			Loop, Parse, s_ShowFileExt, `,
			{
				Loop, %ThisFolderPath%\*.%A_LoopField%, 0
				{
					ItemCount++
					Name := A_LoopFileName
					Global s_HideExt
					if s_HideExt
						SplitPath, Name, , , , Name
					SubFileList = %SubFileList%%Name%`=%A_LoopFileFullPath%`n
				}
			}
		Loop, %ThisFolderPath%\*, 2
		{
			ItemCount++
			SubFolderList = %SubFolderList%%A_LoopFileName%`=%A_LoopFileFullPath%`n
		}
		; sort and merge list
		Sort, SubFileList, U
		Sort, SubFolderList
		SubFolderList = %SubFolderList%%SubFileList%
	}

	Global i_TempMenuItemPos = 1

	if ThisFolderPath = "::{20D04FE0-3AEA-1069-A2D8-08002B30309D}" ; Computer
	{
		ThisFolderName = Computer
	}
	else if SubStr(ThisFolderPath, 0) = ":" ; it's root, use path as name
	{
		ThisFolderName = %ThisFolderPath%\
		f_CreateMenuItem("TempMenu", "..\=""::{20D04FE0-3AEA-1069-A2D8-08002B30309D}""")
	}
	else ; it's not root, add parent folder item ..\
	{
		f_SplitPath(ThisFolderPath, ThisFolderName, ParentFolderPath)
		ThisFolderName = %ThisFolderName%\
		f_CreateMenuItem("TempMenu", "..\=" . ParentFolderPath)
	}

	f_CreateMenuItem("TempMenu", ThisFolderName "=" . ThisFolderPath)
	f_CreateMenuItem("TempMenu", "-")

	if SubFolderList =	; if no subfolder
	{
		Global lang_Empty
		f_CreateMenuItem("TempMenu", lang_Empty . " = nothing")
		Menu, TempMenu, Disable, %lang_Empty%
		return 0
	}
	else
	{
		; Create items
		Global lang_LoadTemp
		ToolTip, %lang_LoadTemp%
		Loop, parse, SubFolderList, `n
		{
;			ToolTip, Loading Items...`nItem %A_Index%
			if A_Index = 500
			{
				Global lang_Warning, lang_TooManyItems
				StringReplace, TooManyItems, lang_TooManyItems, `%ItemCount`%, %ItemCount%
				MsgBox, 308, %lang_Warning%, %TooManyItems%
				IfMsgBox No
					break
			}
			if A_LoopField !=
				f_CreateMenuItem("TempMenu", A_LoopField, 1)
		}
		ToolTip
		return 1
	}
}

f_CreateExplorerMenu()
{
	Global
	Local AllExplorerPaths := f_GetExplorerList()
	Menu, ExplorerMenu, Add
	Menu, ExplorerMenu, DeleteAll
	Local ItemPos = 1
	Local Name
	Loop, Parse, AllExplorerPaths, `n
	{
		if A_LoopField =
			continue
		f_Split2(A_LoopField, "=", i_ExplorerMenuID%ItemPos%, Name)
		Menu, ExplorerMenu, Add, %Name%, f_ActivateWindow
		f_SetMenuIcon("ExplorerMenu", Name, f_GetIcon("Explorer"))
		ItemPos++
	}
	if ItemPos = 1
	{
		Menu, ExplorerMenu, Add, %lang_Empty%, f_ActivateWindow
		Menu, ExplorerMenu, Disable, %lang_Empty%
	}
	return
}

f_ExplorerList:
f_CreateExplorerMenu()
f_ShowMenu("ExplorerMenu")
return

f_ActivateWindow:
if GetKeyState("Shift") || GetKeyState("Ctrl") || GetKeyState("RButton")
{
	f_OpenFavPath := A_ThisMenuItem
	f_OpenPath(f_OpenFavPath)
}
else
{
	f_OpenFavPath := i_%A_ThisMenu%ID%A_ThisMenuItemPos%
	WinActivate, ahk_id %f_OpenFavPath%
}
return

f_GetExplorerList() ; Thanks to F1reW1re
{
	WinGet, IDList, list, , , Program Manager
	Loop, %IDList%
	{
		ThisID := IDList%A_Index%
		WinGetClass, ThisClass, ahk_id %ThisID%
		if ThisClass in ExploreWClass,CabinetWClass
		{
			if A_OSVersion = WIN_VISTA
			{
;				ControlGetPos, w_Edit1Pos,,,, ComboBoxEx321, ahk_id %ThisID%
;				if w_Edit1Pos =
;				{
;					WinActivate, ahk_id %ThisID%
;					Global lang_AddrHotkey
;					Send, %lang_AddrHotkey%
;					Send, !d
;				}
;				ControlGetText, ThisPath, ComboBoxEx321, ahk_id %ThisID%
				ControlGetText, ThisPath, ToolbarWindow322, ahk_id %ThisID%
				f_Split2(ThisPath, ":", ThisPath, ThisPath)
				ThisPath = %ThisPath%
			}
			else
				ControlGetText, ThisPath, ComboBoxEx321, ahk_id %ThisID%
			if ThisPath = ; if cannot get path, use title instead
				WinGetTitle, ThisPath, ahk_id %ThisID%
			PathList = %PathList%%ThisID%=%ThisPath%`n
		}
	}
	return PathList
}

f_ToggleFileExt()
{
	Global lang_ToggleFileExt, lang_ShowFileExt, lang_HideFileExt
	RootKey = HKEY_CURRENT_USER
	SubKey  = Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced
	RegRead, HideFileExt    , % RootKey, % SubKey, HideFileExt
	if HideFileExt = 1
	{
		RegWrite, REG_DWORD, % RootKey, % SubKey, HideFileExt, 0
		TrayTip, %lang_ToggleFileExt%, %lang_ShowFileExt%, , 1
	}
	else
	{
		RegWrite, REG_DWORD, % RootKey, % SubKey, HideFileExt, 1
		TrayTip, %lang_ToggleFileExt%, %lang_HideFileExt%, , 1
	}
	f_RefreshExplorer()
	return
}

f_ToggleHidden() ; thanks to Mr. Milk
{
	Global lang_ToggleHidden, lang_ShowHidden, lang_HideHidden
	RootKey = HKEY_CURRENT_USER
	SubKey  = Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced
	RegRead, HiddenFiles_Status, % RootKey, % SubKey, Hidden
	if HiddenFiles_Status = 2
	{
		RegWrite, REG_DWORD, % RootKey, % SubKey, Hidden, 1
		RegWrite, REG_DWORD, % RootKey, % SubKey, ShowSuperHidden, 1
		TrayTip, %lang_ToggleHidden%, %lang_ShowHidden%, , 1
	}
	else
	{
		RegWrite, REG_DWORD, % RootKey, % SubKey, Hidden, 2
		RegWrite, REG_DWORD, % RootKey, % SubKey, ShowSuperHidden, 0
		TrayTip, %lang_ToggleHidden%, %lang_HideHidden%, , 1
	}
	f_RefreshExplorer()
	return
}

f_RefreshExplorer()
{
	WinGet, w_WinID, ID, ahk_class Progman
	if A_OSVersion = WIN_VISTA
		SendMessage, 0x111, 0x1A220,,, ahk_id %w_WinID%
	else
		SendMessage, 0x111, 0x7103,,, ahk_id %w_WinID%
	WinGet, w_WinIDs, List, ahk_class CabinetWClass
	Loop, %w_WinIDs%
	{
		w_WinID := w_WinIDs%A_Index%
		if A_OSVersion = WIN_VISTA
			SendMessage, 0x111, 0x1A220,,, ahk_id %w_WinID%
		else
			SendMessage, 0x111, 0x7103,,, ahk_id %w_WinID%
	}
	WinGet, w_WinIDs, List, ahk_class ExploreWClass
	Loop, %w_WinIDs%
	{
		w_WinID := w_WinIDs%A_Index%
		if A_OSVersion = WIN_VISTA
			SendMessage, 0x111, 0x1A220,,, ahk_id %w_WinID%
		else
			SendMessage, 0x111, 0x7103,,, ahk_id %w_WinID%
	}
	WinGet, w_WinIDs, List, ahk_class #32770
	Loop, %w_WinIDs%
	{
		w_WinID := w_WinIDs%A_Index%
		ControlGet, w_CtrID, Hwnd,, SHELLDLL_DefView1, ahk_id %w_WinID%
		if w_CtrID !=
			SendMessage, 0x111, 0x7103,,, ahk_id %w_CtrID%
	}
	return
}

f_SVSMenu:
f_CreateSVSMenu()
f_ShowMenu("SVSMenu")
return

f_CreateSVSMenu() ; thanks to Mr. Milk
{
	Global
	i_SVSMenuItemPos = 1
	Menu, SVSMenu, Add
	Menu, SVSMenu, DeleteAll	; delete old menu

	Local LayerName, SVSCommand, LayerStatus, LayerList

	SVSCommand := "cmd.exe /c svscmd.exe enum -v > " . Temp . "\f_svsstatus.tmp"
	RunWait, %SVSCommand%, %A_ScriptDir%, Hide UseErrorLevel
	if ErrorLevel
		return

	Loop, Read, %Temp%\f_svsstatus.tmp
	{
		if SubStr(A_LoopReadLine, 1, 11) != "Layer name:" && SubStr(A_LoopReadLine, 1, 7) != "Active:"
			continue

		if SubStr(A_LoopReadLine, 1, 11) = "Layer name:"
		{
			StringTrimLeft, LayerName, A_LoopReadLine, 11
			LayerName = %LayerName%
			continue
		}
		if SubStr(A_LoopReadLine, 1, 7) = "Active:"
		{
			StringTrimLeft, LayerStatus, A_LoopReadLine, 7
			LayerStatus = %LayerStatus%
			if LayerStatus = No
				LayerStatus := "A"
			else
				LayerStatus := "D"
			SVSCommand := LayerName . "=" . "svscmd.exe -W " . """" . LayerName . """" . " " . LayerStatus
			LayerList = %LayerList%%SVSCommand%`n
		}
	}
	Sort, LayerList
	Loop, Parse, LayerList, `n
	{
		f_CreateMenuItem("SVSMenu", A_LoopField)
		if SubStr(A_LoopField, -1) = " D"
		{
			LayerName := SubStr(A_LoopField, 1, InStr(A_LoopField, "=")-1)
			Menu, SVSMenu, Check, %LayerName%
		}
	}
	if LayerList !=
		Menu, SVSMenu, Add
	Menu, SVSMenu, Add, %lang_RunSVSAdmin%, f_SVSAdmin
	f_SetMenuIcon("SVSMenu", lang_RunSVSAdmin, "svsadmin.exe")
	return
}

f_TCMenu:
f_CreateTCMenu()
f_ShowMenu("TCMenu")
return

f_CreateTCMenu()
{
	Global

	Menu, TCMenu, Add
	Menu, TCMenu, Delete	; delete old menu

	if s_TCPath =
		s_TCPath := "C:\totalcmd"
	Local TCIniFile := s_TCPath . "\wincmd.ini"
	IniRead, TCIniFile, %TCIniFile%, DirMenu, RedirectSection, %TCIniFile% ; read redirect info
	TCIniFile := f_DerefPath(TCIniFile)

	i_TCMenuItemPos = 1
	Local ThisMenu, ThisName, ThisVarName, ThisPath
	ThisMenu = TCMenu
	Loop
	{
		IniRead, ThisName, %TCIniFile%, DirMenu, menu%A_Index%, %A_Space%
		if ThisName =
			break
		if ThisName = -- ; out of a submenu
		{
			if InStr(ThisMenu, "@", "", 0)
				StringLeft, ThisMenu, ThisMenu, InStr(ThisMenu, "@", "", 0)-1
		}
		else if SubStr(ThisName, 1, 1) = "-" ; into a submenu
		{
			StringTrimLeft, ThisName, ThisName, 1
			if f_MenuItemExist(ThisMenu, ThisName)
			{
				Local ItemDuplicate
				StringReplace, ItemDuplicate, lang_ItemDuplicate, `%ItemName`%, %ThisName%
				MsgBox, 16, %lang_Error%, %ItemDuplicate%
				Loop
				{
					if !f_MenuItemExist(ThisMenu, ThisName . "	" . A_Index+1)
					{
						ThisName := ThisName . "	" . A_Index+1
						break
					}
				}
			}
			ThisVarName := f_TrimVarName(ThisName)
			; initialize submenu
			Menu, %ThisMenu%@%ThisVarName%, Add
			Menu, %ThisMenu%@%ThisVarName%, DeleteAll
			i_%ThisMenu%@%ThisVarName%ItemPos = 1
			; add submenu
			Menu, %ThisMenu%, Add, %ThisName%, :%ThisMenu%@%ThisVarName%
			f_SetMenuIcon(ThisMenu, ThisName, f_GetIcon("Menu"))
			i_%ThisMenu%ItemPos++
			ThisMenu .= "@" . ThisVarName
		}
		else
		{
			IniRead, ThisPath, %TCIniFile%, DirMenu, cmd%A_Index%, %A_Space%
			StringTrimLeft, ThisPath, ThisPath, 3
			f_CreateMenuItem(ThisMenu, ThisName . "=" . ThisPath)
		}
	}
	if i_TCMenuItemPos = 1
	{
		f_CreateMenuItem("TCMenu", lang_Empty . " = nothing")
		Menu, TCMenu, Disable, %lang_Empty%
	}
	return
}

f_XMLEscape(str)
{
	StringReplace, str, str, `&, `&amp; , All
	StringReplace, str, str, `", `&quot;, All
	StringReplace, str, str, `', `&apos;, All
	StringReplace, str, str, `<, `&lt;  , All
	StringReplace, str, str, `>, `&gt;  , All
	return str
}

f_XMLUnescape(str)
{
	StringReplace, str, str, `&amp; , `&, All
	StringReplace, str, str, `&quot;, `", All
	StringReplace, str, str, `&apos;, `', All
	StringReplace, str, str, `&lt;  , `<, All
	StringReplace, str, str, `&gt;  , `>, All
	StringReplace, str, str, `&#44; , `,, All
	return str
}



;==================== Labels ====================;
f_DisplayMenu1DB:
if (A_PriorHotkey = A_ThisHotKey && A_TimeSincePriorHotkey < 500)
{
	if A_ThisHotKey contains LButton
	{
		ControlGet, f_SelectedFile, List, Selected, SysListView321, A
		if f_SelectedFile !=
			return
	}
	Gosub, f_DisplayMenu1
}
return
f_DisplayMenu15DB:
if (A_PriorHotkey = A_ThisHotKey && A_TimeSincePriorHotkey < 500)
{
	if A_ThisHotKey contains LButton
	{
		ControlGet, f_SelectedFile, List, Selected, SysListView321, A
		if f_SelectedFile !=
			return
	}
	Gosub, f_DisplayMenu15
}
return
f_DisplayMenu2DB:
if (A_PriorHotkey = A_ThisHotKey && A_TimeSincePriorHotkey < 500)
{
	if A_ThisHotKey contains LButton
	{
		ControlGet, f_SelectedFile, List, Selected, SysListView321, A
		if f_SelectedFile !=
			return
	}
	Gosub, f_DisplayMenu2
}
return
f_OpenSelDB:
if (A_PriorHotkey = A_ThisHotKey && A_TimeSincePriorHotkey < 500)
	Gosub, f_OpenSel
return
f_AddAppDB:
if (A_PriorHotkey = A_ThisHotKey && A_TimeSincePriorHotkey < 500)
	Gosub, f_AddApp
return
f_AddFavoriteKDB:
if (A_PriorHotkey = A_ThisHotKey && A_TimeSincePriorHotkey < 500)
	Gosub, f_AddFavoriteK
return
f_ToolReloadDB:
if (A_PriorHotkey = A_ThisHotKey && A_TimeSincePriorHotkey < 500)
	Gosub, f_ToolReload
return
f_ToolOptionsDB:
if (A_PriorHotkey = A_ThisHotKey && A_TimeSincePriorHotkey < 500)
	Gosub, f_ToolOptions
return
f_ToolEditDB:
if (A_PriorHotkey = A_ThisHotKey && A_TimeSincePriorHotkey < 500)
	Gosub, f_ToolEdit
return
f_ToolExitDB:
if (A_PriorHotkey = A_ThisHotKey && A_TimeSincePriorHotkey < 500)
	Gosub, f_ToolExit
return
f_ToolToggleHiddenDB:
if (A_PriorHotkey = A_ThisHotKey && A_TimeSincePriorHotkey < 500)
	Gosub, f_ToolToggleHidden
return
f_ToolToggleFileExtDB:
if (A_PriorHotkey = A_ThisHotKey && A_TimeSincePriorHotkey < 500)
	Gosub, f_ToolToggleFileExt
return
f_SystemRecentDB:
if (A_PriorHotkey = A_ThisHotKey && A_TimeSincePriorHotkey < 500)
	Gosub, f_SystemRecent
return
f_ExplorerListDB:
if (A_PriorHotkey = A_ThisHotKey && A_TimeSincePriorHotkey < 500)
	Gosub, f_ExplorerList
return
f_DriveListDB:
if (A_PriorHotkey = A_ThisHotKey && A_TimeSincePriorHotkey < 500)
	Gosub, f_DriveList
return
f_ToolMenuDB:
if (A_PriorHotkey = A_ThisHotKey && A_TimeSincePriorHotkey < 500)
	Gosub, f_ToolMenu
return
f_RecentMenuDB:
if (A_PriorHotkey = A_ThisHotKey && A_TimeSincePriorHotkey < 500)
	Gosub, f_RecentMenu
return
f_SVSMenuDB:
if (A_PriorHotkey = A_ThisHotKey && A_TimeSincePriorHotkey < 500)
	Gosub, f_SVSMenu
return
f_TCMenuDB:
if (A_PriorHotkey = A_ThisHotKey && A_TimeSincePriorHotkey < 500)
	Gosub, f_TCMenu
return

f_ToolReload:
Reload
return
f_ToolOptions:
;	StartTime := A_TickCount
gui_Tab =
Gosub, f_OptionsGUI
;	MsgBox, % A_TickCount - StartTime . " milliseconds have elapsed."
return
f_ToolEdit:
Run, notepad %A_ScriptDir%\Config.xml
return
f_ToolExit:
Exitapp
return
f_ListLines:
ListLines
return
f_ListVars:
ListVars
return
f_ListHotkeys:
ListHotkeys
return
f_KeyHistory:
KeyHistory
return
f_ToolToggleHidden:
f_ToggleHidden()
return
f_ToolToggleFileExt:
f_ToggleFileExt()
return
f_SVSAdmin:
f_CreateSVSMenu()
Run, "svsadmin.exe"
return

#Include %A_ScriptDir%\GUI.ahk
#Include %A_ScriptDir%\Lib.ahk
