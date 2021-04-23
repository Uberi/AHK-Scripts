;regionstart <<< Initial Comments >>>
/*
	Author:
		Salvatore Agostino Romeo
	E-Mail:
		romeo84@gmail.com
	Description:
		AHkxplorer is a powerfull file manager. It's portable, small(<1MB) and
		it doesn't make use of the registry
	Functions:
		1)Browse folders and open files
		2)Favourites folders submenu
		3)Browse folder quickly with right click on a folder and select Fast Browse
			3.1)browse rapidely your folders and open files from here
			3.2)favourites folders submenu(saved when you close the program)
			3.3)option to browse for folders and open this folders in dialogs such as Open Dialog box
			3.4)root submenu wich contains drives, cdrom drives and removable media
			3.5)submenu "back to" to quickly switch up 1,2,3,....  levels 
			3.6)other minor functions
		4)Move or resize a window
		5)Support for tabs
		6)Copy selected files/folders in an open tab, in a specified folder or in the other panel
		7)Back to previous folder
		8)Toggle between large icon and list list with detailed informations
		9)Manage tabs with tab button
		10)History menu of most recent folders
		11)Append function: view not only current folder contenent, but append 
		   other folder contenent to this one(different from copying them)
		12)Browse up 1,2,3,... levels
		13)Special Address bar:
			13.1)Write a folder path and jump to it.
			13.2)Write "p " followed by a command to launch it in command prompt
			     example: "p cd E:\" will go to E:\ in prompt
			13.3)Write "r " before a command to run it like in Run dialog
			13.4)Write "f " followed by a filter to apply this filter to the folder
			13.5)Write "s " followed by a word to search for it in this 
				 folder and its subfolders
			13.6)Write "l " followed by a char or a number to show files 
			     and folders that start with it
		14)Double panel
		15)Filter a folder to show only what you want
			15.1)show only folders
			15.2)show only files
			15.3)show only documents, audio, video, images
			15.4)show only files or folders containing a specified word
			15.5)save personal filter
		16)Layer support: a layer is a set of files from different folders
			16.1)save a layers by append files to current folder or clear them from it
			16.2)delete layers
			16.3)load layer
		17)Move selected files/folders in an open tab, in a specified folder
		   or in the other panel
		18)Create new files
		19)Create new folders
			19.1)simple folder
			19.2)a folder structure with numbers
			19.3)a folder structure with alphabet
			19.4)a folder with date, month, hour, day, ....
			19.4)specify prefix or postfix for folder structures
		20)Delete files and folders (maybe it doesn't work)
			20.1)completly remove
			20.2)send to recycle bin
		21)Remember last section tabs
		22)Hotkey for each button. In order F2(NumPad.) for back, F3 for tab, NumPad1 to copy to....
		23)Basic menu with all command (new, copy to) and others. 
		   Call it with ALT + SPACE
		24)Use ALT + "driveLetter" to go to that drive. Example ALT+c will jump to c:\
		26)Use CTRL+PageUp or CTRL+PageDown to navigate between tabs
		27)WIN+r to update the folder
		28)View icons as they are
		29)Preview image files as icons
		30)Select a file and single click it in its name to rename it
		31)Extract 7z, zip, gzip, bzip2, Z and tar archive here or to a folder
		32)Archive a folder to folder.7z, folder.zip or with 
		   gzip, bzip2, Z and tar format
		33)Special folder menu
		34)Menu bar
		35)Integrated search engine
		36)Built in search engine
			36.1)Search in this folder or in a specified one
			36.2)Specify extensions, if more or less than X KB
			36.3)Include or exclude folder
		37)Initial support for Drag&Drop (copying and moving files and folder)
		38)Double click in blank region will update current folder
		39)Tab session
			39.1)The program save current open tabs on exit
			39.2)User can save current tabs session via tab menu
			39.3)User can load tabs sessions via tab menu
			39.4)User can delete tabs sessions via tab menu
		40)Print a folder from Main menu in menu bar:
			40.1)Print a folder with subfolders
			40.2)Print a folder without subfolders
		41)Personalize any icon
			41.1)If you do nothing, things work
			41.2)If you insert an image(ico,bmp,png,gif,jpg,...) in 
			     icons\files, with the name of an extension, then 
				 this file type is displayed with that icon. Example:
				 if a file icons\files\txt.png exists, then all .txt files
				 will be shown with that icon
			41.3)Folders are shown with image  icons\folder.png
		42)Images files are showed with their own image
		43)Link management: clicking on a link will open a submenu:
		   "Open" will open that link, "Go to this folder" will jump 
		   to this link folder
		44)Possibility to open not registered files in notepad
		45)XButton1 to go back
		46)Customize single folder icon with your own
		47)Status bar showing: status of program, free disk space,
    	   current folder space, selected file space
	Version:
		0.5.2 alpha
	License:
		GPL
	Note:
		This is an alpha version. Use it at your own risk
		This program use 7za.exe to extract and to archive
	ToDo: 
		many many things. right shell menu,
		run programs, finish dragging, control move and copy, adjusting delete,
		buttons with icons in the middle of the panels, different thread when 
		copying or for any elaborate task
	Bugs:
		?(surly many bugs)
*/
;regionend

;regionstart <<< Initialize all stuff  and create gui>>>
#SingleInstance off
SetTimer, flowOfControl, 800
FileInstall, 7za.exe, 7za.exe
Process, priority, , H
SetBatchLines, -1
OnExit, ExitSub
tempFolder=%A_Desktop%
Gui +Resize ; Allow the user to maximize or drag-resize the window:
gosub, crateButtons



Gui, add, Edit, xm y30 vAddress w650 cBlue , %A_Desktop%
Gui, add, Button, Default x+2 y29 ggo vgo ,go

Gui, add, ListView, y54 vPanel2 w400 gPanel1 +AltSubmit -ReadOnly, Name|In Folder|Size (KB)|Type
Gui, Add, ListView, xm y54 w400 h400 vPanel1 gPanel1 +AltSubmit -ReadOnly, Name|In Folder|Size (KB)|Type ; Create the ListView and its columns:
currentPanel=Panel1

Gui, add, tab, xm y557 h25 w700 vtabs Bottom -Wrap AltSubmit gTabs,
Gui,add, text, xm vstatustext y635 w20, Status:
Gui, add, Picture, vstatus x+2 y638 w16 h-1, icone\status_free.png
status1=
status2=
status3=
Gui,add, text, vstatusbar x+18 y635 w600
toggleStatus:=0

currentTabs=%A_Desktop%

LV_ModifyCol(3, "Integer")  ; For sorting, indicate that the Size column is an integer.
ImageListID1 := IL_Create(10) ; Create an ImageList so that the ListView can display some icons:
ImageListID2 := IL_Create(10, 10, true)  ; A list of large icons to go with the small ones.
LV_SetImageList(ImageListID1) ; Attach the ImageLists to the ListView so that it can later display the icons:
LV_SetImageList(ImageListID2)

Gui, ListView, Panel2
currentPanel=Panel2
LV_ModifyCol(3, "Integer")  ; For sorting, indicate that the Size column is an integer.
LV_SetImageList(ImageListID1) ; Attach the ImageLists to the ListView so that it can later display the icons:
LV_SetImageList(ImageListID2)

imageFiles=GIF|JPG|BMP|ICO|CUR|ANI|PNG|TIF|EXIF|WMF|EMF
ilFolder=icons\files
gosub, populateIL


loadFolder( A_Desktop )
Gui, ListView, Panel1



panel1Folder=%A_Desktop%
panel2Folder=%A_Desktop%

FileRead, myFavouritesFilters, filters.txt
IfNotExist, layers
	FileCreateDir, layers
IfNotExist, tabs
	FileCreateDir, tabs
IfNotExist, printed
	FileCreateDir, printed
IfNotExist, conf
	FileCreateDir, conf	
; Display the window and return. The OS will notify the script whenever the user
; performs an eligible action:
gosub, createMenuBar



Gui, Show, w800 h650 , AHkxplorer
GuiControl, +Icon, Panel1    ; Show icon view first.
GuiControl, +Icon, Panel2    ; Show icon view first.
history=

loadFolder( A_Desktop )

FileRead, myFavouritesFolders, favourites.txt
; relative to Folder Navigator
if(myFavouritesFolders="")
	myFavouritesFolders=E:\Programmi|E:\ahk

gosub, folderMenuCreation
alphabet=abcdefghijklmnopqrstuvwxyz
switchPanel()
update()


createDrivesHotkey()
gosub, archiveFormatMenu
gosub, createVariousMenu
gosub, createSearchGui
gosub, createDragMenu

return
;regionend

;regionstart <<< Menu bar >>>
createMenuBar:
	Menu, FileMenu, Add, &Tab (F4),ButtonTab
	Menu, FileMenu, Add, &New (WIN + n), ButtonNew
	Menu, FileMenu, Add, &Append (F10), ButtonAppend
	Menu, FileMenu, Add, Print this folder with subfolders, print+s
	Menu, FileMenu, Add, Print this folder without subfolders, print-s
	Menu, FileMenu, Add, E&xit, GuiClose
	Menu, menuBar, Add, &Main, :FileMenu 
	
	Menu, EditMenu, Add, Copy to, ButtonCopyTo
	Menu, EditMenu, Add, Move to, ButtonMoveTo
	Menu, menuBar, Add, &Edit, :EditMenu 
	
	Menu, GoToMenu, Add, &Back (F3), ButtonBack
	Menu, GoToMenu, Add, &Root (F7), ButtonRoot
	Menu, GoToMenu, Add, &JumpTo (F8), ButtonJumpTo
	Menu, GoToMenu, Add, &History (WIN + h), ButtonHistory
	Menu, GoToMenu, Add, &Favourites (WIN + b), ButtonFavourites
	Menu, GoToMenu, Add, &Special Folders (WIN + s), SpecialFolder
	Menu, menuBar, Add, &GoTo, :GoToMenu
	
	Menu, ViewMenu, Add, &Switch between Large icons and details, ButtonSwitchView
	Menu, ViewMenu, Add, &Update , update
	Menu, menuBar, Add, &View, :ViewMenu
	
	Menu, menuBar, Add, &Filter, ButtonFilter
	
	Menu, menuBar, Add, &Layer, ButtonLayer
	
	
	Menu, menuBar, Add, &Help, ~F1
	Gui, Menu, menuBar
return
;regionend

;regionstart <<< Various menus >>>
createVariousMenu:

Menu, tabSessionLoad, add
Menu, tabSessionDelete, add
Menu, TabManager, Add, new, tabmanagement
Menu, TabManager, Add, close this tab, tabmanagement
Menu, TabManager, Add, save this tab session, tabmanagement
Menu, TabManager, Add, load session, :tabSessionLoad
Menu, TabManager, Add, delete session, :tabSessionDelete 

; Create a popup menu to be used as the context menu:
Menu, MyContextMenu, Add, Open, ContextOpenFile
Menu, MyContextMenu, Add, Fast Browse, ContextOpenFile
Menu, MyContextMenu, Add, Add to favourites, ContextOpenFile
Menu, MyContextMenu, Add, Delete, deletefirst
Menu, MyContextMenu, Add, Clear from this Panel, ContextClearRows
Menu, MyContextMenu, Add, Extract, ExtractTo
Menu, MyContextMenu, Add, Archive, selectFormat
Menu, MyContextMenu, Add, Customize icon, iconCustomize
Menu, MyContextMenu, Add, Properties, ContextProperties

pfilt1=doc,pdf
pfilt2=jpg,bmp,ico
pfilt3=mpg,avi,mov,rm,wmv
pfilt4=mp3,wav,wma

Menu, predefFilters, add, documents(%pfilt1%),prefiltri
Menu, predefFilters, add, images(%pfilt2%),prefiltri
Menu, predefFilters, add, video(%pfilt3%),prefiltri
Menu, predefFilters, add, audio(%pfilt4%),prefiltri

Menu, recentFilters, add
Menu, filter, add, show folders only, filter
Menu, filter, add, show files only, filter
Menu, filter, add, show only file with..., filter
Menu, filter, add, show only, :predefFilters
Menu, filter, add, show last ones, :recentFilters
Menu, filter, add, show all, filter

Menu, loadLayer, add
Menu, deleteLayer, add
Menu, layer, add, append a new folder ,ButtonAppend
Menu, layer, add, save ,layer
Menu, layer, add, load, :loadLayer
Menu, layer, add, delete, :deleteLayer

; prepare open menu
Menu, open, add, here, openLab
Menu, open, add, in xplorer2, openLab
Menu, open, add, in Dialogs Windows, openLab

Menu, del, add, completly remove, delete
Menu, del, add, move to recycle bin, delete

Menu, all, add, SwitchView, allCMD
Menu, all, add, Back, allCMD
Menu, all, add, Tab, allCMD
Menu, all, add, Copy to, allCMD
Menu, all, add, Move to, allCMD
Menu, all, add, Root, allCMD
Menu, all, add, Jump to, allCMD
Menu, all, add, Favourites, allCMD
Menu, all, add, Append, allCMD
Menu, all, add, Filter, allCMD
Menu, all, add, Layer, allCMD
Menu, all, add, New, allCMD
Menu, all, add, History, allCMD
Menu, all, add, Context, allCMD
Menu, all, add, Fast Browse from this folder, allCMD
; Menu, all, add, Favourite programs, allCMD
; Menu, all, add, Favourite dos commands, allCMD

Menu, specialFolders, add, Desktop, specialFolders
Menu, specialFolders, add, Desktop for all users, specialFolders
Menu, specialFolders, add, Start Menu, specialFolders
Menu, specialFolders, add, Start Menu for all users, specialFolders
Menu, specialFolders, add, Programs, specialFolders
Menu, specialFolders, add, Programs for all users, specialFolders
Menu, specialFolders, add, Startup, specialFolders
Menu, specialFolders, add, Startup for all users, specialFolders
Menu, specialFolders, add, My documents, specialFolder

return
;regionend

;regionstart <<< Create Buttons >>>
crateButtons:
Gui, Add, Button, xm, Switch View
Gui, Add, Button, x+10, Back
Gui, Add, Button, x+10, Tab
Gui, Add, Button, x+10, Copy to
Gui, Add, Button, x+10, Move to
Gui, Add, Button, x+10, Root
Gui, Add, Button, x+10, Jump to
Gui, Add, Button, x+10, History
Gui, Add, Button, x+10, Favourites
Gui, Add, Button, x+10, Append
Gui, Add, Button, x+10, Filter
Gui, Add, Button, x+10, Layer
Gui, Add, Button, x+10, New
Gui, Add, Button, x+10, Search

return
;regionend

;regionstart <<< Copy section >>>
ButtonCopyTo:
	Menu, copyTo, add
	Menu, copyTo, deleteall
	Menu, tabsSnap, add
	Menu, tabsSnap, deleteall
	StringSplit, ct, currentTabs, |
	Loop, %ct0%
		{
			SplitPath, ct%A_Index%, , , , name
			if (name = "")
				name := ct%A_Index%
			if (name != "")
				Menu, tabsSnap, add, %name%, copyToTab
		}
	Menu, copyTo, add, tab, :tabsSnap
	Menu, copyTo, add, folder, copyToFolder
	Menu, copyTo, add, other panel, copyToPanel
	Menu, copyTo, show
return
copyToFolder:
	FileSelectFolder, folderWhereToSaveFiles 
	if (folderWhereToSaveFiles="")
		return
	copySelectedTo(folderWhereToSaveFiles)
return
copySelectedTo(fwtsf)
	{
		global
		Sleep, 100
		total := LV_GetCount( "S" )
		switchStatus()
		status2=Copying files to %fwtsf%
		updateStatusBar()
		Loop, %total%
			{
				
				RowNumber := LV_GetNext(RowNumber)
				LV_GetText(FileName, RowNumber , 1)
				LV_GetText(FileFolder, RowNumber , 2)
				FileGetAttrib, attr, %FileFolder%\%FileName%
				Tooltip, Copying file %A_Index% of %total%. `nSpecifically %FileName% to %fwtsf%
				IfNotInString, attr, D
					FileCopy, %FileFolder%\%FileName% ,%fwtsf%\%FileName%
				else if (FileFolder != "InFolder" )
					FileCopyDir, %FileFolder%\%FileName% , %fwtsf%\%FileName%
			}
		Tooltip,
		total=
		switchStatus()
		status2=
		updateStatusBar()
		return
	}
copyToPanel:
	if ( currentPanel = "Panel1")
		copySelectedTo(panel2Folder)
	else if ( currentPanel = "Panel2")
		copySelectedTo(panel1Folder)
return
;regionend

;regionstart <<< Move section >>>
ButtonMoveTo:
	Menu, moveTo, add
	Menu, moveTo, deleteall
	Menu, tabsSnap, add
	Menu, tabsSnap, deleteall
	StringSplit, ct, currentTabs, |
	Loop, %ct0%
		{
			SplitPath, ct%A_Index%, , , , name
			if (name = "")
				name := ct%A_Index%
			if (name != "")
				Menu, tabsSnap, add, %name%, moveToTab
		}
	Menu, moveTo, add, tab, :tabsSnap
	Menu, moveTo, add, folder, moveToFolder
	Menu, moveTo, add, other panel, moveToPanel
	Menu, moveTo, show
return
moveToFolder:
	FileSelectFolder, folderWhereToMoveFiles 
	if (folderWhereToMoveFiles="")
		return
	moveSelectedTo(folderWhereToMoveFiles)
return
moveSelectedTo(fwtmf)
	{
		global
		switchStatus()
		status2=Moveing files to %fwtsf%
		updateStatusBar()
		Sleep, 100
		Loop, % LV_GetCount( "S" )	;%
			{
				RowNumber := LV_GetNext(RowNumber)
				LV_GetText(FileName, RowNumber , 1)
				LV_GetText(FileFolder, RowNumber , 2)
				FileGetAttrib, attr, %FileFolder%\%FileName%
				IfNotInString, attr, D
					FileMove, %FileFolder%\%FileName% ,%fwtsf%\%FileName%
				else if (FileFolder != "InFolder" )
					FileMoveDir, %FileFolder%\%FileName% , %fwtmf%\%FileName%
			}
		update()
		switchStatus()
		status2=
		updateStatusBar()
		return
	}
moveToPanel:
	if ( currentPanel = "Panel1")
		moveSelectedTo(panel2Folder)
	else if ( currentPanel = "Panel2")
		moveSelectedTo(panel1Folder)
return
;regionend

;regionstart  <<< Tabs Region >>>
updateTabs()
	{
		global
			currentTabsName = 
			StringSplit, ct, currentTabs, |
			Loop, %ct0%
				{
					SplitPath, ct%A_Index%, , , , name
					if (name = "")
						name := ct%A_Index%
					currentTabsName = %currentTabsName%%name%|
				}
			GuiControl, , tabs, |%currentTabsName%
		return
	}
Tabs:
	Gui, submit ,nohide
	StringReplace, currentTabs, currentTabs, ||, |
	StringSplit, ct, currentTabs, |
	currentTabs=
	dir := ct%tabs%
	Loop, %ct0%
		{
			currentCT := ct%A_Index%
			if (currentCT != "")
				{
					if ( A_Index = tabs)
						currentTabs = %currentTabs%%currentCT%||
					else
						currentTabs = %currentTabs%%currentCT%|
				}
		}
	StringTrimRight, currentTabs, currentTabs, 1
	loadFolder(dir)
return


Buttontab:
	Menu, tabSessionLoad, add
	Menu, tabSessionDelete, add
	Menu, tabSessionLoad, deleteall
	Menu, tabSessionDelete, deleteall
	Loop, tabs\*.txt
		{	
			StringTrimRight, tabSessionName, A_LoopFileName, 4
			Menu, tabSessionLoad, add, %tabSessionName%, tabLoadDel
			Menu, tabSessionDelete, add	, %tabSessionName%, tabLoadDel
		}
	Menu, TabManager,show
return

tabLoadDel:
	if ( A_ThisMenu = "tabSessionLoad")
		{
			FileRead, currentTabs, tabs\%A_ThisMenuItem%.txt
			updateTabs()
		}
	else
		{
			MsgBox, 4, , Are you sure you want to delete %A_ThisMenuItem% tabs session?
			IfMsgBox, No
				return
			FileDelete, tabs\%A_ThisMenuItem%.txt
		}
return



tabmanagement:
	if ( A_ThisMenuItemPos = 1) ; new tab
		{
			currentTabs = %currentTabs%|%A_Desktop%|
			updateTabs()
		}
	else if ( A_ThisMenuItemPos = 2) ; close this tab
		{
			StringReplace, currentTabs, currentTabs, ||, |
			StringSplit, ct, currentTabs, |
			currentTabs=
			dir := ct%tabs%
			Loop,%ct0%
				{
					currentCT := ct%A_Index%
					if (currentCT != "")
						{
							if ( A_Index != tabs)
								currentTabs = %currentTabs%%currentCT%|
						}
				}
			StringTrimRight, currentTabs, currentTabs, 1
			updateTabs()
		}
	
	else if ( A_ThisMenuItemPos = 3) ; save this tab session
		{
			InputBox, name , Name for this tab session, Select a name for this tab session ,,,,,,,, %A_DDD% %A_DD%-%A_MM% %A_Hour%,%A_Min% session
			FileAppend , %currentTabs%, tabs\%name%.txt
		}
return

copyToTab:
	StringReplace, currentTabs, currentTabs, ||, |
	StringSplit, ct, currentTabs, |
	dir := ct%A_ThisMenuItemPos%
	copySelectedTo(dir)
return
moveToTab:
	StringReplace, currentTabs, currentTabs, ||, |
	StringSplit, ct, currentTabs, |
	dir := ct%A_ThisMenuItemPos%
	moveSelectedTo(dir)
return

;regionend

;regionstart <<<  FolderNavigator >>>
#Space::
	dir=%A_Desktop%
	navigate(dir)
return

navigate(folder)
	{
		global
		; get favourites folder menu
		Menu, myFavFolders, add
		Menu, myFavFolders, deleteall
		StringSplit, mff, myFavouritesFolders, |
		Loop, %mff0%
			{
				currentFolder := mff%A_Index%
				Menu, myFavFolders, add, %currentFolder%, gotoFolder 
			}
		; get drives for "root" menu
		DriveGet, drvFixed, List, Fixed
		DriveGet, drvRemovable, List, REMOVABLE
		DriveGet, drvCD, List, CDROM
		drv=%drvFixed%%drvRemovable%%drvCD%
		StringSplit, d, drv
		item_num=0
		Loop,%d0%
			{
				tem:=d%A_Index% ":\"
				Menu, roots, add, %tem%, gotoFolder
			}
		StringRight, LastChar, Folder, 1
		if LastChar = \
			StringTrimRight, Folder, Folder, 1  ; Remove the trailing backslash.
		currentFolder = 
		until := 0 
		Menu, folderNavigator, add
		Menu, folderNavigator, deleteall
		Menu, backTo, add
		Menu, backTo, deleteall
		; get folders for "back to" menu
		StringSplit, backToFolder, folder, \
		Loop, % backToFolder0-1  ;%
			{
				tempFold := backToFolder%A_Index%
				currentFolder = %currentFolder%%tempFold%\ 
				Menu, backTo, add,  %currentFolder%, gotoFolder
			}
		Menu, folderNavigator , add	, open ...,:open
		Menu, folderNavigator , add	, favourites ...,:myFavFolders
		Menu, folderNavigator , add	, root ...,:roots
		Menu, folderNavigator , add	,
		Menu, folderNavigator , add	, back to ...,:backTo
		Loop, %folder%\* ,2
			{
				Menu, folderNavigator, add , %A_LoopFileName%%A_Tab% -> ,gotoFolder
				dir%A_Index% = %A_LoopFileFullPath%
				until := A_Index
			}
			
		Loop, %folder%\*
			{
				Menu, folderNavigator, add , %A_LoopFileName% ,gotoFolder
				num := A_Index + until
				dir%num% = %A_LoopFileFullPath%
			}
		MouseGetPos, x, y
		in_x := x-20
		in_y := y-20
		currentFolder=%folder%
		Menu, folderNavigator, show, %in_x%, %in_y%
		return
	}

openLab:
	if ( A_ThisMenuItemPos = 1)
		loadFolder(currentFolder)
	else if ( A_ThisMenuItemPos = 2)
		{
			ControlFocus, Edit1 , ahk_class ATL:ExplorerFrame
			ControlSend , Edit1, {BS}%currentFolder%\{Enter}, ahk_class ATL:ExplorerFrame
		}
	else if ( A_ThisMenuItemPos = 3)
		{
			ControlFocus, Edit1 , ahk_class #32770
			ControlSend , Edit1, {BS}%currentFolder%\{Enter}{BS}, ahk_class #32770
		}
return

gotoFolder:
	itemNum := A_ThisMenuItemPos - 5
	;msgbox, % dir%itemNum%
	;msgbox, until %until% itn %itemNum%
	if ( A_ThisMenu = "folderNavigator" and itemNum<=until)
		navigate(dir%itemNum%)
	else if ( A_ThisMenu = "folderNavigator" and itemNum>until)
		run, % dir%itemNum%
	else
		navigate(A_ThisMenuItem)
return
;regionend

;regionstart <<<  Panel events>>>
Panel1:
	switchPanel()
	if A_GuiEvent = DoubleClick  ; There are many other possible values the script can check.
	{
		LV_GetText(FileName, A_EventInfo, 1) ; Get the text of the first field.
		LV_GetText(FileDir, A_EventInfo, 2)  ; Get the text of the second field.
		; se si tratta di una directory allora aprila nella finestra, altrimenti lancia il file
		;regionstart  <<< Gestione directory e files>>>
		if (FileName = "Name")
			if ( FileDir= "In Folder")
				{
					update()
					return
				}
		FileGetAttrib, Attributes, %FileDir%\%FileName%
		IfInString, Attributes, D ; è una directory
			{
				folder=%FileDir%\%FileName%
				loadFolder(folder)
			}
		else
		{
			IfInString, FileName, lnk
				{
					dir=%FileDir%\%FileName%
					link(dir)
				}
			else
				Run %FileDir%\%FileName%,, UseErrorLevel
		}
		if ErrorLevel
			{
				folder=%FileDir%\%FileName%
				MsgBox , 4, Not known file, File not registered.`nDo you want to open it in Notepad?
				IfMsgBox, Yes
					Run, notepad.exe %folder%
			}
		;regionend
	}
	else if A_GuiEvent = e
		{
			LV_GetText(FileName, A_EventInfo, 1) ; Get the text of the first field.
			LV_GetText(FileDir, A_EventInfo, 2)  ; Get the text of the second field.
			if (first = "")
				{
					first = %FileDir%\%FileName%
				}
			else
				{
					than=%FileDir%\%FileName%
					before=%first%
					FileGetAttrib, attr, %before%
					IfInString, attr, D
						FileMoveDir, %before%, %than%
					else
						FileMove, %before%, %than%
					first=
				}
		}
	else if A_GuiEvent = D
		{
			SetTimer, checkLButton, off
			SetTimer, dragLButton, off
			IfWinActive, AHkxplorer
					SetTimer, checkLButton, 1000
		}
	else if A_GuiEvent = Normal
		{
			LV_GetText(FileName, A_EventInfo, 1) 
			LV_GetText(FileDir, A_EventInfo, 2)
			FileGetSize, statusFile , %FileDir%\%FileName%, K
			FolderSize=0
			Loop, %tempFolder%\*.*
				FolderSize += %A_LoopFileSizeKB%
			if(statusFile!="")
				statusFile= <%FileName%: %statusFile% KB> 
			statusDir = <This folder: %FolderSize% KB >
			status3=%statusFile%%statusDir%
			updateStatusBar()
			statusFile=
		}
return

;regionend

;regionstart <<<  GuiContextMenu >>>	
GuiContextMenu:  ; Launched in response to a right-click or press of the Apps key.
	if A_GuiControl <> %currentPanel%  ; Display the menu only for clicks inside the ListView.
		return
	; Show the menu at the provided coordinates, A_GuiX and A_GuiY.  These should be used
	; because they provide correct coordinates even if the user pressed the Apps key:
	FocusedRowNumber := LV_GetNext(0, "F")  ; Find the focused row.
	if not FocusedRowNumber  ; No row is focused.
		return
	LV_GetText(FileName, FocusedRowNumber, 1) ; Get the text of the first field.
	LV_GetText(FileDir, FocusedRowNumber, 2)  ; Get the text of the second field.
	Menu, MyContextMenu, Show, %A_GuiX%, %A_GuiY%
	return

	ContextOpenFile:  ; The user selected "Open" in the context menu.
	ContextProperties:  ; The user selected "Properties" in the context menu.
	ContextFastBrowse:
	; For simplicitly, operate upon only the focused row rather than all selected rows:
	FocusedRowNumber := LV_GetNext(0, "F")  ; Find the focused row.
	if not FocusedRowNumber  ; No row is focused.
		return
	LV_GetText(FileName, FocusedRowNumber, 1) ; Get the text of the first field.
	LV_GetText(FileDir, FocusedRowNumber, 2)  ; Get the text of the second field.
	if ( A_ThisMenuItem = "Open")  ; User selected "Open" from the context menu.
		Run %FileDir%\%FileName%,, UseErrorLevel
	else if( A_ThisMenuItem = "Fast Browse" )
		{
			dir=%FileDir%\%FileName%
			navigate(dir)
		}
	else if( A_ThisMenuItem = "Add to favourites" )
		myFavouritesFolders = %myFavouritesFolders%|%FileDir%\%FileName%
	else  ; User selected "Properties" from the context menu.
		Run Properties "%FileDir%\%FileName%",, UseErrorLevel
	;if ErrorLevel
	;	MsgBox Could not perform requested action on "%FileDir%\%FileName%".
return
;regionend

;regionstart <<< ContextClearRows >>>
ContextClearRows:  ; The user selected "Clear" in the context menu.
	RowNumber = 0  ; This causes the first iteration to start the search at the top.
	Loop
	{
		; Since deleting a row reduces the RowNumber of all other rows beneath it,
		; subtract 1 so that the search includes the same row number that was previously
		; found (in case adjacent rows are selected):
		RowNumber := LV_GetNext(RowNumber - 1)
		if not RowNumber  ; The above returned zero, so there are no more selected rows.
			break
		LV_Delete(RowNumber)  ; Clear the row from the ListView.
	}
	LV_ModifyCol()  ; Auto-size each column to fit its contents.
	LV_ModifyCol(3, 60) ; Make the Size column at little wider to reveal its header.
	LV_ModifyCol(1, "Sort")
return
;regionend

;regionstart <<< GuiSize >>>
GuiSize:  ; Allows the ListView to grow or shrink in response user's resizing of window.
	if A_EventInfo = 1  ; The window has been minimized.  No action needed.
		return
	; Otherwise, the window has been resized or maximized. Resize the ListView to match.
	GuiControl, Move, Panel1, % "W" . (A_GuiWidth * 0.55) . " H" . (A_GuiHeight -100)  ;%
	GuiControl, Move, Panel2, % "X" . (A_GuiWidth * 0.57) .  "W" . (A_GuiWidth * 0.42) . " H" . (A_GuiHeight -100)  ;%
	GuiControl, Move, tabs, % "W" . (A_GuiWidth - 20) . " Y" . (A_GuiHeight -45)  ;%
	GuiControl, Move, statustext, % " Y" . (A_GuiHeight -15)  ;%
	GuiControl, Move, status, % " Y" . (A_GuiHeight -12)  ;%
	GuiControl, Move, statusbar, % " Y" . (A_GuiHeight -15)  ;%
	GuiControl, Move, Address, % "W" . (A_GuiWidth - 40)   ;%
	GuiControl, Move, go, % "X" . (A_GuiWidth - 28)   ;%
	update()
return
;regionend	

;regionstart <<< Functions: loadFolder, update >>>
loadFolder(Folder, back=0, append=0, onlyFolder=0, onlyFiles=0, filtro="", startsWith="")
{
	global
	; msgbox, (%Folder%, %back%, %append%, %onlyFolder%, %onlyFiles%, %filtro%, %startsWith%)
	status3=
	DriveSpaceFree, free, %folder% 
	DriveGet, tot, Cap, %folder%
	status1=This drive: %free%/%tot% MB
	updateStatusBar()
	Gui, submit, nohide
	; memorizza la cartella dei pannelli
	if ( currentPanel = "Panel1")
		panel1Folder=%Folder%
	else if ( currentPanel = "Panel2" )
		panel2Folder=%Folder%
	
	GuiControl, , Address, %Folder%
	if (back = "0")
		history=%tempFolder%`n%history%
	beforeFolder=%tempFolder%
	tempFolder=%Folder%
	Loop, %Folder%
		Folder = %A_LoopFileShortPath%
	if(append = "0")
		LV_Delete()
	StringRight, LastChar, Folder, 1
	if LastChar = \
		StringTrimRight, Folder, Folder, 1  ; Remove the trailing backslash.
		
	StringReplace, currentTabs, currentTabs, ||, |
	StringSplit, ct, currentTabs, |
	currentTabs=
	dir := ct%tabs%
	Loop,%ct0%
		{
			currentCT := ct%A_Index%
			if(currentCT != "")
				{
					if ( A_Index = tabs)
						currentTabs = %currentTabs%%Folder%||
					else
						currentTabs = %currentTabs%%currentCT%|
				}
		}
	StringTrimRight, currentTabs, currentTabs, 1
	updateTabs()
	; Ensure the variable has enough capacity to hold the longest file path. This is done
	; because ExtractAssociatedIconA() needs to be able to store a new filename in it.
	VarSetCapacity(Filename, 260)

	; Gather a list of file names from the selected folder and append them to the ListView:
	if ( onlyFiles = "0")
	Loop %Folder%\* ,2
	{
		FileName := A_LoopFileFullPath  ; Must save it to a writable variable for use below.
		IconNumber=%folderIcon%
		toggle:=1
		custTot:=1
		Loop, parse, specialFolderIcons, |
		{
			toggle:=!toggle
			if ( A_LoopField="" )
				continue
			if toggle
				continue
			if ( A_LoopFileFullPath = A_LoopField)
			{
				IconNumber := customeIcon%custTot% - 1
				break
			}
			custTot++
		}
		if(IconNumber=-1)
			IconNumber:=0
		; Create the new row in the ListView and assign it the icon number determined above:
		if ( filtro = "" and startsWith="")
			LV_Add("Icon" . IconNumber, A_LoopFileName, A_LoopFileDir, A_LoopFileSizeKB, FileExt)
		else if ( filtro !="")
			{
				if A_LoopFileName contains %filtro%
					LV_Add("Icon" . IconNumber, A_LoopFileName, A_LoopFileDir, A_LoopFileSizeKB, FileExt)
			}
		else
			{
				StringMid, sw, A_LoopFileName, 1, 1		
				if (sw = startsWith)
						LV_Add("Icon" . IconNumber, A_LoopFileName, A_LoopFileDir, A_LoopFileSizeKB, FileExt)
			}
	}
	if ( onlyFolder = "0")
	Loop %Folder%\*
	{
		FileName := A_LoopFileFullPath  ; Must save it to a writable variable for use below.

		; Build a unique extension ID to avoid characters that are illegal in variable names,
		; such as dashes.  This unique ID method also performs better because finding an item
		; in the array does not require search-loop.
		SplitPath, FileName,,, FileExt  ; Get the file's extension.
		IfInString, imageFiles, %FileExt%
			{
				IconNumber := IL_ADD(ImageListID2, A_LoopFileFullPath , 1 , true)  
				IL_ADD(ImageListID1, A_LoopFileFullPath , 1 , true) 
			}
		else if FileExt = EXE
		{
			ExtID = EXE  ; Special ID as a placeholder.
			IconNumber := IL_ADD(ImageListID2, A_LoopFileFullPath ,1)
			IL_ADD(ImageListID1, A_LoopFileFullPath ,1)
		}
		else if FileExt = ICO
		{
			ExtID = ICO  ; Special ID as a placeholder.
			IconNumber = 0  ; Flag it as not found so that ICOs can each have a unique icon.
		}
		else if FileExt = LNK
		{
			ExtID = LNK  ; Special ID as a placeholder.
			IconNumber = 0  ; Flag it as not found so that ICOs can each have a unique icon.
		}
		else if (icon%FileExt% != "")
			IconNumber := icon%FileExt%  ; Flag it as not found so that ICOs can each have a unique icon.
		else  ; Non-EXE, so calculate this extension's unique ID.
		{
			ExtID = 0  ; Initialize to handle extensions that are shorter than others.
			Loop 7     ; Limit the extension to 7 characters so that it fits in a 64-bit value.
			{
				StringMid, ExtChar, FileExt, A_Index, 1
				if not ExtChar  ; No more characters.
					break
				; Derive a Unique ID by assigning a different bit position to each character:
				ExtID := ExtID | (Asc(ExtChar) << (8 * (A_Index - 1)))
			}
			; Check if this file extension already has an icon in the ImageLists. If it does,
			; several calls can be avoided and loading performance is greatly improved,
			; especially for a folder containing hundreds of files:
			IconNumber := IconArray%ExtID%
		}
		if not IconNumber  ; There is not yet any icon for this extension, so load it.
		{
			; Get the icon associated with this file extension:
			hIcon := DllCall("Shell32\ExtractAssociatedIconA", UInt, 0, Str, FileName, UShortP, iIndex)
			if not hIcon  ; Failed to load/find icon.
				IconNumber = 9999999  ; Set it out of bounds to display a blank icon.
			else
			{
				; Add the HICON directly to the small-icon and large-icon lists.
				; Below uses +1 to convert the returned index from zero-based to one-based:
				IconNumber := DllCall("ImageList_ReplaceIcon", UInt, ImageListID2, Int, -1, UInt, hIcon) + 1
				DllCall("ImageList_ReplaceIcon", UInt, ImageListID1, Int, -1, UInt, hIcon)
				; Now that it's been copied into the ImageLists, the original should be destroyed:
				DllCall("DestroyIcon", Uint, hIcon)
				; Cache the icon to save memory and improve loading performance:
				icon%FileExt% := IconNumber
			}
		}

		; Create the new row in the ListView and assign it the icon number determined above:
		if ( filtro = "" and startsWith="")
			LV_Add("Icon" . IconNumber, A_LoopFileName, A_LoopFileDir, A_LoopFileSizeKB, FileExt)
		else if ( filtro !="")
			{
				if A_LoopFileName contains %filtro%
					LV_Add("Icon" . IconNumber, A_LoopFileName, A_LoopFileDir, A_LoopFileSizeKB, FileExt)
			}
		else
			{
				StringMid, sw, A_LoopFileName, 1, 1		
				if (sw = startsWith)
						LV_Add("Icon" . IconNumber, A_LoopFileName, A_LoopFileDir, A_LoopFileSizeKB, FileExt)
			}
	}
	LV_ModifyCol()  ; Auto-size each column to fit its contents.
	LV_ModifyCol(3, 60) ; Make the Size column at little wider to reveal its header.
	; msgbox,  p1: %panel1Folder% p2: %panel2Folder%
	updateAddressBar()
	return
}

update()
	{
		global
			loadFolder(tempFolder)
		return
	}
update:
	update()
return
;regionend

;regionstart <<< Buttons: SwitchView, go, Back, History, Root, JumpTo, Favourites, Append >>>

ButtonSwitchView:
	if not IconView
		GuiControl, +Icon, %currentPanel%   ; Switch to icon view.
	else
		GuiControl, +Report, %currentPanel%  ; Switch back to details view.
	IconView := not IconView             ; Invert in preparation for next time.
	LV_ModifyCol()  ; Auto-size each column to fit its contents.
return

go:
	Gui, Submit, nohide
	StringMid, char, Address, 1, 1
	if ( char = "p")
		{
			SetKeyDelay, 0
			StringTrimLeft, Address, Address, 2
			Run, %comspec%
			Sleep, 100
			Send, %Address%
			Send, {Enter}
			return
		}
	else if ( char = "r")
		{
			StringTrimLeft, Address, Address, 2
			Run, %Address%, , UseErrorLevel
			return
		}
	else if ( char = "f")
		{
			StringTrimLeft, Address, Address, 2
			loadFolder(tempFolder,0,0,0,0,Address)
			return
		}
	else if ( char = "s")
		{
			StringTrimLeft, Address, Address, 2
			search( Address , tempFolder)
			return
		}
	else if ( char = "l")
		{
			StringTrimLeft, Address, Address, 2
			ovalue=0
			loadFolder(tempFolder, ovalue, ovalue, ovalue, ovalue, "", Address )
			return
		}
	loadFolder(Address)
return

ButtonBack:
	IfNotInString, history, \
		return
	StringSplit, h, history, `n
	StringReplace, history, history, %h1%`n
	loadFolder( h1, "1")
return

ButtonHistory:
	StringSplit, h, history, `n
	Menu, history, add
	Menu, history, deleteall
	Loop, %h0%
		{
			currHist := h%A_Index%
			IfInString, currHist, \
				Menu, history, add, %currHist%, gotoThis
		}
	Menu, history, show	
return

gotoThis:
	loadFolder(A_ThisMenuItem)
return

ButtonRoot:
	; get drives for "root" menu
	DriveGet, drvFixed, List, Fixed
	DriveGet, drvRemovable, List, REMOVABLE
	DriveGet, drvCD, List, CDROM
	drv=%drvFixed%%drvRemovable%%drvCD%
	StringSplit, d, drv
	Loop,%d0%
		{
			tem:=d%A_Index% ":\"
			Menu, roots, add, %tem%, gotoThis
		}
	Menu, roots, show
return

ButtonJumpTo:
	; get folders for "back to" menu
	currentFolder =
	Loop, % backToFolder0-1  ;%
		backToFolder%A_Index%=
	StringSplit, backToFolder, tempfolder, \
	Menu, backTo, add
	Menu, backTo, deleteall
	Loop, % backToFolder0-1  ;%
		{
			tempFold := backToFolder%A_Index%
			currentFolder = %currentFolder%%tempFold%\ 
			Menu, backTo, add,  %currentFolder%, gotoThis
		}
	Menu, backTo, show
	currentFolder = 
return

ButtonFavourites:
	StringSplit, mff, myFavouritesFolders, |
	Loop, %mff0%
		{
			currentFolder := mff%A_Index%
			Menu, myFavFolders, add, %currentFolder%, gotoThis 
		}
	Menu, myFavFolders, show
return

ButtonAppend:
	FileSelectFolder, folderToAppend
	if(folderToAppend != "")
		loadFolder(folderToAppend,0,1)
return
;regionend

;regionstart <<< Exiting >>>
ExitSub:
	FileDelete, favourites.txt
	FileDelete, filters.txt
	FileDelete, tabs\last session.txt
	FileAppend, %myFavouritesFolders%, favourites.txt
	FileAppend, %myFavouritesFilters%, filters.txt
	StringReplace, currentTabs, currentTabs, ||, |
	FileAppend, %currentTabs%, tabs\last session.txt
	ExitApp
return

GuiClose:  ; When the window is closed, exit the script automatically:
ExitApp
;regionend

;regionstart <<< Panel Manipulation >>>
switchPanel()
	{
		global
			GuiControl, +BackgroundE6F0FF, %currentPanel% ;switch color for inactive listview
			currentPanel=%A_GuiControl% ; update active listview
			GuiControl, +BackgroundFFFFFF, %currentPanel% ; switch color for active listview
			Gui, ListView,%currentPanel%
			updateAddressBar()
		return
	}
updateAddressBar()
	{
		global
			if ( currentPanel = "Panel1")
				GuiControl, , Address, %panel1Folder%
			else if ( currentPanel = "Panel2")
				GuiControl, , Address, %panel2Folder%
		return
	}
;regionend

;regionstart <<< Filter >>>




ButtonFilter:
	StringSplit, mff, myFavouritesFilters, |
	Menu, recentFilters, add
	Menu, recentFilters, deleteall
	Loop, %mff0%
		{
			currentFilter := mff%A_Index%
			Menu, recentFilters, add, %currentFilter%, applyThisFilter 
		}
	Menu, filter, show
return
filter:
	if ( A_ThisMenuItemPos = 1)
		loadFolder(tempFolder,0,0,1)
	else if ( A_ThisMenuItemPos = 2)
		loadFolder(tempFolder,0,0,0,1)
	else if ( A_ThisMenuItemPos = 3)
		{
			InputBox, filtro, Filter, Select a word or an extension for the files you want to mantain
			myFavouritesFilters = %myFavouritesFilters%|%filtro%
			loadFolder(tempFolder,0,0,0,0,filtro)
		}
	else
		loadFolder(tempFolder)
return
prefiltri:
	loadFolder(tempFolder,0,0,0,0,pfilt%A_ThisMenuItemPos%)
return
applyThisFilter:
	loadFolder(tempFolder,0,0,0,0,A_ThisMenuItem)
return

;regionend

;regionstart <<< Layer >>>

layer:
	InputBox, layerName, Layer Name, Select a name for this layer
	if ( layerName="")
		return
	Loop, % LV_GetCount()  ;%
		{
			LV_GetText(FileName, A_Index , 1)
			LV_GetText(FileDir, A_Index , 2)
			layerToSave= %layerToSave%|%FileDir%\%FileName%
		}
	FileAppend, %layerToSave%, layers\%layerName%.txt
	layerName=
	layerToSave=
return

ButtonLayer:
	Menu, loadLayer, add
	Menu, deleteLayer, add
	Menu, loadLayer, deleteall
	Menu, deleteLayer, deleteall
	Loop, layers\*.txt
		{	
			StringTrimRight, layerName, A_LoopFileName, 4
			Menu, loadLayer, add, %layerName%, layerLoadDelete
			Menu, deleteLayer, add, %layerName%, layerLoadDelete
		}
	Menu, layer, show
return

layerLoadDelete:
	if ( A_ThisMenu = "loadLayer")
		{
			FileRead, thisLayer, layers\%A_ThisMenuItem%.txt
			StringSplit, tl, thisLayer, |
			LV_Delete()
			Loop, %tl0%
				loadPath(tl%A_Index%)
			GuiControl, , Address, layer: %A_ThisMenuItem%
		}
	else
		{
			MsgBox, 4, , Are you sure you want to delete %A_ThisMenuItem% layer?
			IfMsgBox, No
				return
			FileDelete, layers\%A_ThisMenuItem%.txt
		}
return

loadPath(percorso)
{
	global
	if (percorso = "")
		return
	StringRight, LastChar, path, 1
	if LastChar = \
		StringTrimRight, path, path, 1  ; Remove the trailing backslash.
	VarSetCapacity(Filename, 260)
	FileName := percorso  ; Must save it to a writable variable for use below.
	SplitPath, FileName,name, dir, FileExt
	if FileExt = EXE
	{
		ExtID = EXE  ; Special ID as a placeholder.
		IconNumber = 0  ; Flag it as not found so that EXEs can each have a unique icon.
	}
	else  ; Non-EXE, so calculate this extension's unique ID.
	{
		ExtID = 0  ; Initialize to handle extensions that are shorter than others.
		Loop 7     ; Limit the extension to 7 characters so that it fits in a 64-bit value.
		{
			StringMid, ExtChar, FileExt, A_Index, 1
			if not ExtChar  ; No more characters.
				break
			; Derive a Unique ID by assigning a different bit position to each character:
			ExtID := ExtID | (Asc(ExtChar) << (8 * (A_Index - 1)))
		}
		; Check if this file extension already has an icon in the ImageLists. If it does,
		; several calls can be avoided and loading performance is greatly improved,
		; especially for a folder containing hundreds of files:
		IconNumber := IconArray%ExtID%
	}
	if not IconNumber  ; There is not yet any icon for this extension, so load it.
	{
		; Get the icon associated with this file extension:
		hIcon := DllCall("Shell32\ExtractAssociatedIconA", UInt, 0, Str, FileName, UShortP, iIndex)
		if not hIcon  ; Failed to load/find icon.
			IconNumber = 9999999  ; Set it out of bounds to display a blank icon.
		else
		{
			; Add the HICON directly to the small-icon and large-icon lists.
			; Below uses +1 to convert the returned index from zero-based to one-based:
			IconNumber := DllCall("ImageList_ReplaceIcon", UInt, ImageListID1, Int, -1, UInt, hIcon) + 1
			DllCall("ImageList_ReplaceIcon", UInt, ImageListID2, Int, -1, UInt, hIcon)
			; Now that it's been copied into the ImageLists, the original should be destroyed:
			DllCall("DestroyIcon", Uint, hIcon)
			; Cache the icon to save memory and improve loading performance:
			IconArray%ExtID% := IconNumber
		}
	}
	LV_Add("Icon" . IconNumber, name, dir, A_LoopFileSizeKB, FileExt)
	LV_ModifyCol()  ; Auto-size each column to fit its contents.
	LV_ModifyCol(3, 60) ; Make the Size column at little wider to reveal its header.
	return
}

;regionend

;regionstart <<< Delete >>>
deletefirst:
	Menu, del, show
return

delete:
	if ( A_ThisMenuItemPos = 1)
		{
			Loop, % LV_GetCount("S")  ;%
				{
					LV_GetText(FileName, A_Index , 1)
					LV_GetText(FileDir, A_Index , 2)
					FileDelete, %FileName%\%FileDir%
					if (ErrorLevel)
						{
							FileRemoveDir, %FileName%\%FileDir%
							if (ErrorLevel)
								msgbox, Coulde not delete file %FileName%. Maybe it's in use
						}
						
				
				}
		}
	else
		{
			Loop, % LV_GetCount( "S" )  ;%
				{
					LV_GetText(FileName, A_Index , 1)
					LV_GetText(FileDir, A_Index , 2)
					FileRecycle, %FileName%\%FileDir%
					if (ErrorLevel)
						{
								msgbox, Coulde not delete file %FileName%. Maybe it's in use
						}
						
				
				}
		}	
return
;regionend

;regionstart <<< New >>>

folderMenuCreation:
Menu, new, add, File, new
Menu, new, add, Folder, new
Menu, folderCreate, add, Simple Folder, folderCreate
Menu, folderCreate, add, Folder Structure(Numbers), folderCreate
Menu, folderCreate, add, Folder Structure(Alphabet), folderCreate
Menu, folderCreate, add, Folder with day , folderCreate
Menu, folderCreate, add, Folder with hour, folderCreate
Menu, folderCreate, add, Folder with day and hour, folderCreate
Menu, folderCreate, add, Folder with month and day, folderCreate
Menu, folderCreate, add, Folder with date, folderCreate
Menu, folderCreate, add, Folder with date and hour, folderCreate

return

ButtonNew:
	Menu, new, show
return

new:
	if ( A_ThisMenuItemPos = 1)
		{
			InputBox, filename, File Name, Insert the name for the file.`nInclude an extension if you want
			FileAppend,,%tempFolder%\%filename%		
			update()
		}
	else
		Menu, folderCreate, show
return

folderCreate:
	if ( A_ThisMenuItemPos = 1)
		{
			InputBox, filename, File Name, Insert the name for the folder
			FileCreateDir,%tempFolder%\%filename%	
		}
	else if ( A_ThisMenuItemPos = 2)
		{
			InputBox, prefix, Prefix, Insert a prefix if you want
			InputBox, postfix, Postfix, Insert a postfix if you want
			InputBox, startFrom, Start from..., Insert the number from wich you want to start,,,,,,,0
			InputBox, howmany, Start from..., Insert how many folder you want to create
			if (howmany="")
				return
			Loop, %howmany%
				{
					index := startFrom + A_Index
					filename=%prefix%%index%%postfix%
					FileCreateDir,%tempFolder%\%filename%
				}
		}
	else if ( A_ThisMenuItemPos = 3)
		{
			InputBox, prefix, Prefix, Insert a prefix if you want
			InputBox, postfix, Postfix, Insert a postfix if you want
			StringSplit, a, alphabet
			Loop, %a0%
			{
				char := a%A_Index%
				filename=%prefix%%char%%postfix%
				FileCreateDir,%tempFolder%\%filename%
			}
		}
	else  if ( A_ThisMenuItemPos = 4)
		{
			InputBox, prefix, Prefix, Insert a prefix if you want
			InputBox, postfix, Postfix, Insert a postfix if you want
			filename=%prefix%%A_DDDD%%postfix%
			FileCreateDir,%tempFolder%\%filename%
		}
	else  if ( A_ThisMenuItemPos = 5)
		{
			InputBox, prefix, Prefix, Insert a prefix if you want
			InputBox, postfix, Postfix, Insert a postfix if you want
			filename=%prefix%%A_Hour%`,%A_Min%%postfix%
			FileCreateDir,%tempFolder%\%filename%
		}
	else  if ( A_ThisMenuItemPos = 6)
		{
			InputBox, prefix, Prefix, Insert a prefix if you want
			InputBox, postfix, Postfix, Insert a postfix if you want
			filename=%prefix%%A_DDDD% - %A_Hour%`,%A_Min%%postfix%
			FileCreateDir,%tempFolder%\%filename%
		}
	else  if ( A_ThisMenuItemPos = 7)
		{
			InputBox, prefix, Prefix, Insert a prefix if you want
			InputBox, postfix, Postfix, Insert a postfix if you want
			filename=%prefix%%A_MMMM% - %A_DDDD%%postfix%
			FileCreateDir,%tempFolder%\%filename%
		}
	else  if ( A_ThisMenuItemPos = 8)
		{
			InputBox, prefix, Prefix, Insert a prefix if you want
			InputBox, postfix, Postfix, Insert a postfix if you want
			filename=%prefix%%A_DD%-%A_MM%-%A_YYYY%%postfix%
			FileCreateDir,%tempFolder%\%filename%
		}
	else  if ( A_ThisMenuItemPos = 9)
		{
			InputBox, prefix, Prefix, Insert a prefix if you want
			InputBox, postfix, Postfix, Insert a postfix if you want
			filename=%prefix%%A_DD%-%A_MM%-%A_YYYY% - %A_Hour%`,%A_Min%%postfix%
			FileCreateDir,%tempFolder%\%filename%
		}
	prefix=
	postfix=
	startFrom=
	howmany=
	update()
return
;regionend

;regionstart <<< Hotkey >>>
~F1::
	IfWinActive , AHkxplorer
			msgbox, help to do
return
~NumPad0::
~F2::
	IfWinActive , AHkxplorer
			goto, ButtonSwitchView
return
~XButton1::
~NumPadDot::
~F3::
	IfWinActive , AHkxplorer
			goto, ButtonBack
return
~F4::
	IfWinActive , AHkxplorer
			goto, Buttontab
return
~NumPad1::
~F5::
	IfWinActive , AHkxplorer
			goto, ButtonCopyTo
return
~NumPad2::
~F6::
	IfWinActive , AHkxplorer
			goto, ButtonMoveTo
return
~NumPad4::
~F7::
	IfWinActive , AHkxplorer
			goto, ButtonRoot
return
~NumPad3::
~F8::
	IfWinActive , AHkxplorer
			goto, ButtonJumpTo
return
~NumPad5::
~F9::
	IfWinActive , AHkxplorer
			goto, ButtonFavourites
return
~NumPad8::
~F10::
	IfWinActive , AHkxplorer
			goto, ButtonAppend
return
~F11::
	IfWinActive , AHkxplorer
			goto, ButtonFilter
return
~NumPad6::
~F12::
	IfWinActive , AHkxplorer
			goto, ButtonLayer
return
~NumPadAdd::
!Space::
	IfWinActive , AHkxplorer
			Menu, all, show
return
~NumPadSub::
	Menu, specialFolders, show
return

#r::
	IfWinActive , AHkxplorer
		update()
return

#f::
	IfWinActive , AHkxplorer
		Menu, folderCreate, show
return

#h::
	IfWinActive , AHkxplorer
		Menu, history, show
return

#b::
	IfWinActive , AHkxplorer
		Menu, myFavFolders, show
return

#s::
	IfWinActive , AHkxplorer
		Menu, specialFolders, show
return

#n::
	IfWinActive , AHkxplorer
		Menu, new, show
return



;regionend

;regionstart <<< Menu of all commands >>>
allCMD:
	if ( A_ThisMenuItemPos = 1)
		goto, ButtonSwitchView
	else if ( A_ThisMenuItemPos = 2)
		goto, ButtonBack
	else if ( A_ThisMenuItemPos = 3)
		goto, Buttontab
	else if ( A_ThisMenuItemPos = 4)
		goto, ButtonCopyTo
	else if ( A_ThisMenuItemPos = 5)
		goto, ButtonMoveTo
	else if ( A_ThisMenuItemPos = 6)
		goto, ButtonRoot
	else if ( A_ThisMenuItemPos = 7)
		goto, ButtonJumpTo
	else if ( A_ThisMenuItemPos = 8)
		goto, ButtonFavourites
	else if ( A_ThisMenuItemPos = 9)
		goto, ButtonAppend
	else if ( A_ThisMenuItemPos = 10)
		goto, ButtonFilter
	else if ( A_ThisMenuItemPos = 11)
		goto, ButtonLayer
	else if ( A_ThisMenuItemPos = 12)
		goto, ButtonNew
	else if ( A_ThisMenuItemPos = 13)
		goto, ButtonHistory
	else if ( A_ThisMenuItemPos = 14)
		goto, GuiContextMenu
	else if ( A_ThisMenuItemPos = 15)
		navigate(tempFolder)
return
;regionend

;regionstart <<< Hotkey for all drives >>>
createDrivesHotkey()
	{
			DriveGet, drvFixed, List, Fixed
			DriveGet, drvCD, List, CDROM
			drvhk=%drvFixed%%drvCD%
			StringSplit, d, drvhk
			Loop,%d0%
				{
					tem:=d%A_Index%
					Hotkey, !%tem%, drvhk
				}
		return
	}
drvhk:
	IfWinNotActive , AHkxplorer
		return
	StringTrimLeft, got , A_ThisHotkey , 1
	got=%got%:\
	loadFolder(got)
return
;regionend

;regionstart <<< Archive >>>
selectFormat:
	Menu, afm, show
return
archiveFormatMenu:
	Menu, afm, add, 7z,createArchive
	Menu, afm, add, zip,createArchive
	Menu, afm, add, gzip,createArchive
	Menu, afm, add, bzip2,createArchive
	Menu, afm, add, tar,createArchive
return

createArchive:
	FocusedRowNumber := LV_GetNext(0, "F")  ; Find the focused row.
	if not FocusedRowNumber  ; No row is focused.
		return
	LV_GetText(FileName, FocusedRowNumber, 1) ; Get the text of the first field.
	LV_GetText(FileDir, FocusedRowNumber, 2)  ; Get the text of the second field.
	wte=%FileDir%\%FileName%
	archive(wte,A_ThisMenuItem)
return

ExtractTo:
	;extract file
	FocusedRowNumber := LV_GetNext(0, "F")  ; Find the focused row.
	if not FocusedRowNumber  ; No row is focused.
		return
	LV_GetText(FileName, FocusedRowNumber, 1) ; Get the text of the first field.
	LV_GetText(FileDir, FocusedRowNumber, 2)  ; Get the text of the second field.
	wte=%FileDir%\%FileName%
	extract(wte)
return

extract(archive)
	{
		InputBox, onnex, Folder,Name of the folder where to extract.`nLeave blank to extract here
		Loop, %archive%
			archive=%A_LoopFileShortPath%
		SplitPath, archive,,dir
		wt7z=7za.exe x %archive% -o%dir%\%onnex%
		Run, %wt7z%
		onnex=
		return
	}
archive(dirtz,format)
	{
		Loop, %dirtz%\*
			dirtz = %A_LoopFileShortPath%
		StringSplit, d, dirtz, \
		dirtz=
		Loop, % d0 - 1 ;%
			{
				currD := d%A_Index%
				dirtz = %dirtz%%currD%\
			}
		StringTrimRight, dirtz, dirtz, 1
		wt7z=7za.exe a -t%format% %dirtz%.%format% %dirtz%
		Run, %wt7z%
		aname=
		format=
		return
	}
;regionend

;regionstart <<< Special Folders >>>

specialFolders:
	if ( A_ThisMenuItemPos = 1)
		loadFolder( A_Desktop )
	else if ( A_ThisMenuItemPos = 2)
		loadFolder( A_DesktopCommon )
	else if ( A_ThisMenuItemPos = 3)
		loadFolder( A_StartMenu )
	else if ( A_ThisMenuItemPos = 4)
		loadFolder( A_StartMenuCommon )
	else if ( A_ThisMenuItemPos = 5)
		loadFolder( A_Programs )
	else if ( A_ThisMenuItemPos = 6)
		loadFolder( A_ProgramsCommon )
	else if ( A_ThisMenuItemPos = 7)
		loadFolder( A_Startup )
	else if ( A_ThisMenuItemPos = 8)
		loadFolder( A_StartupCommon )
	else if ( A_ThisMenuItemPos = 9)
		loadFolder( A_MyDocuments )
return

SpecialFolder:
	Menu, specialFolders, show
return

;regionend

;regionstart <<< Search >>>
createSearchGui:
Gui, 2:+owner +AlwaysOnTop +ToolWindow
Gui, 2:Add, Button, Default x136 y185 w70 h20 vser, Search  
Gui, 2:Add, Text, x6 y14 w40 h20, Search 
Gui, 2:Add, Text, x6 y44 w20 h20, in 
Gui, 2:Add, Text, x6 y74 w60 h20, Extensions 
Gui, 2:Add, Text, x6 y104 w50 h20, More than 
Gui, 2:Add, Text, x6 y134 w50 h20, Less than 
Gui, 2:Add, Text, x6 y164 w100 h20, Include folders too? 
Gui, 2:Add, Radio, x116 y160 w10 h20 vyes, 
Gui, 2:Add, Radio, x156 y160 w10 h20 Checked, 
Gui, 2:Add, Text, x126 y164 w30 h20, Yes 
Gui, 2:Add, Text, x166 y164 w20 h20,No 
Gui, 2:Add, Edit, x46 y10 w160 h20 vWhatToSearch, 
Gui, 2:Add, Edit, x36 y40 w170 h20 vWhereToSearch, 
Gui, 2:Add, Edit, x76 y70 w130 h20 vExtToSearch,
Gui, 2:Add, Edit, x66 y100 w120 h20 vmtkb, 
Gui, 2:Add, Edit, x66 y130 w120 h20 vltkb, 
Gui, 2:Add, Text, x188 y104 w20 h20,KB 
Gui, 2:Add, Text, x188 y134 w20 h20, KB
return

ButtonSearch:
	Gui, 2: show, ,Search
	GuiControl, 2:Focus , whatToSearch	
	GuiControl, 2: , WhereToSearch, %tempfolder% 
return
2ButtonSearch:
	Gui, 2:submit
	if (yes = 1)
		fef=1
	else 
		fef=0
	if ( ExtToSearch="")
		ExtToSearch=-1
	if ( mtkb="")
		mtkb=-1
	if ( ltkb="")
		ltkb=-1
	search(WhatToSearch, WhereToSearch,ExtToSearch, mtkb, ltkb, fef)
	fef=
return
search(what, where,ext = -1 , mtbytes = -1, ltbytes= -1, fef= 0)
	{
		global
		switchStatus()
		status2=Searching %what% in %where%
		updateStatusBar()
		Loop, %where%\*.*, %fef%, 1
			{
				IfInString, A_LoopFileName , %what%
					found = %A_LoopFileName%
				if ( found != "")
				{
					if (ext != -1)
						IfNotInString, ext , %A_LoopFileExt%
							found=
					if ( mtbytes != -1 and A_LoopFileSizeKB < mtbytes)
						found=
					if ( ltbytes != -1 and A_LoopFileSizeKB > ltbytes)
						found=	
					if ( found != "")
						tosave=%tosave%|%A_LoopFileFullPath%
				}
				found=
			}
		name_s=search %A_DD%-%A_MM% %A_Hour%,%A_Min%
		FileAppend, %tosave%, layers\%name_s%.txt
		SetTimer, loadSearched ,100
		return
	}
loadSearched:
	SetTimer, loadSearched , off
	StringSplit, tl, tosave, |
	LV_Delete()
	Loop, %tl0%
		loadPath(tl%A_Index%)
	GuiControl, , Address, layer: %name_s%
	tosave=
	switchStatus()
	status2=
	updateStatusBar()
return
;regionend

;regionstart <<< flowOfControl >>>
flowOfControl:
	MouseGetPos,x,y
	IfWinActive AHkxplorer
	{
		if ( y>80 and y<100)
			{
				if ( inAddress = 0 )
					{
						GuiControl, Focus , Address
						Send, +{End}
					}
				inAddress := 1
			}
		else
			inAddress := 0
	}
return
;regionend

;regionstart <<< DragAndDrop >>>
createDragMenu:
	Menu, drag, add, Move here, dragged
	Menu, drag, add, Copy here, dragged
return

checkLButton:
	SetTimer, checkLButton, off
	if ( !GetKeyState("LButton" , "P") )
		return
	SetTimer, dragLButton, 100
	CoordMode,Mouse,Screen
	RowNumber = 0  ; This causes the first loop iteration to start the search at the top of the list.
	Loop
		{
			RowNumber := LV_GetNext(RowNumber)  ; Resume the search at the row after that found by the previous iteration.
			if not RowNumber  ; The above returned zero, so there are no more selected rows.
				break
			LV_GetText(FileName, RowNumber , 1)
			LV_GetText(FileDir, RowNumber , 2)
			startingFiles=%startingFiles%%FileDir%\%FileName%|
		}	
	MouseGetPos, x, y
	if ( startingFiles!="" )
		SplashImage, icone\mirino16x16.gif, B x%x% y%y%,,, mirino
return
dragLButton:
	if ( GetKeyState("LButton" , "P") )
		{
			MouseGetPos, x, y
			in_x := x+170
			in_y := y+110
			WinMove, mirino, , %in_x% ,%in_y%
		}
	else
		{
			SplashImage, off
			SetTimer, dragLButton, off
			Send, {LButton}
			RowNumber = 0  
			RowNumber := LV_GetNext(RowNumber) 
			LV_GetText(FileName, RowNumber , 1)
			LV_GetText(FileDir, RowNumber , 2)
			endFile=%FileDir%\%FileName%
			if ( startingFiles !="" )
				Menu, drag, show
		}
return

dragged:
	if (endFile="In Folder\Name")
		endFile=
	if ( startingFiles="" )
		return
	if (endFile="" and currentPanel="Panel1")
	{
		if ( A_ThisMenuItemPos = 1)
			msgbox, moving `n %startingFiles% `n to `n %panel2Folder%
		else
			msgbox, copying `n %startingFiles% `n to `n %panel2Folder%
	}
	else if (endFile="" and currentPanel="Panel2")
		{
		if ( A_ThisMenuItemPos = 1)
			msgbox, moving `n %startingFiles% `n to `n %panel1Folder%
		else
			msgbox, copying `n %startingFiles% `n to `n %panel1Folder%
	}
	else
	{
		if ( A_ThisMenuItemPos = 1 )
			msgbox, moving `n %startingFiles% `n to `n %endFile%
		else
			msgbox, copying `n %startingFiles% `n to `n %endFile%
	}
	startingFiles=
	endFile=
return

;regionend

;regionstart <<< Print >>>

printFolderWithoutSubfolders(folder)
{
	global
	SetBatchLines, -1
	Process, Priority, , H
	FileDelete , %folder%_cont-sub_%A_DD%-%A_MM%.txt
	Loop, %folder%\*, 2
		print=%print%+--+>%A_LoopFileName%`n
	Loop, %folder%\*
		print=%print%+--->%A_LoopFileName%`n
	FileAppend, %tempFolder%`n+`n%print%, %folder%_cont-sub_%A_DD%-%A_MM%.txt
	Sleep,200
	Run, %folder%_cont-sub_%A_DD%-%A_MM%.txt
	print=
	return
}
printFolderWithSubfolders(folder)
{
	global
	SetBatchLines, -1
	Process, Priority, , H
	print(folder)
	FileDelete , %folder%_cont_%A_DD%-%A_MM%.txt
	Loop, Parse , print , `n
		{
			StringTrimLeft, last, A_LoopField , 5
			end=%end%%last%`n
		}
	FileAppend, %tempFolder%`n+`n%end%, %folder%_cont_%A_DD%-%A_MM%.txt
	Sleep,200
	Run, %folder%_cont_%A_DD%-%A_MM%.txt
	print=
	end=
	return
}
print(folder)
{
	global
			printTag=%printTag%--+
			Loop, %folder%\*, 2
			{
				print=%print%%printTag%--+>
				print=%print%%A_LoopFileName%`n
				subfolder=%A_LoopFileFullPath%
				gosub, printSubFolder
			}
			if (A_Index = 0)
				StringTrimRight, tag, tag, 3
			Loop, %folder%\*
			{
				print=%print%%printTag%---->
				print=%print%%A_LoopFileName%`n
			}
			StringTrimRight, printTag, printTag, 3
	; msgbox, %print%
	return
}
printSubFolder:
	print(subFolder)
return

print+s:
	printFolderWithSubfolders(tempfolder)
return

print-s:
	printFolderWithoutSubfolders(tempfolder)
return

;regionend

;regionstart <<< Image list >>>
populateIL:
	FileRead, specialFolderIcons , conf\custome icons.txt
	Loop, %ilFolder%\*
		{
			StringTrimRight, name, A_LoopFileName, 4
			file=%ilFolder%\%A_LoopFileName%
			icon%name% := IL_ADD(ImageListID2, file)
			IL_ADD(ImageListID1, file, icon%name%, true)
		}
	; for folders
	folderIcon:=IL_ADD(ImageListID2, "icons\folder.png")
	IL_ADD(ImageListID1, "icons\folder.png", folderIcon, true)
	; for custom folders
	specialFolderIcons= %specialFolderIcons%c:\kiu\kiu|icons\folder.png|
	toggle:=0
	cutTot:=1
	Loop, parse, specialFolderIcons, |
		{
			toggle:=!toggle
			if ( A_LoopField="" )
				continue
			if toggle
				continue
			; msgbox, %A_Index% folderIconTemp=%A_LoopField%
			customeIcon%custTot% :=IL_ADD(ImageListID2, A_LoopField)
			IL_ADD(ImageListID1, A_LoopField, customeFolder%A_Index%, true) 
			custTot++
		}
	custTot=
return
;regionend

;regionstart <<< Link region >>>

link(linkDir)
{
	global
	FileGetShortcut, %linkDir% , OutTarget, OutDir
	Menu, link, add
	Menu, link, deleteall
	Menu, link, add, Open, linkman
	Menu, link, add, Go to this folder, linkman
	Menu, link, show
	return
}

linkman:
	if ( A_ThisMenuItemPos = 1)
		Run, %OutTarget%
	else
		loadFolder(OutDir)
return
;regionend

;regionstart <<< Customize Icon >>>
iconCustomize:
	FocusedRowNumber := LV_GetNext(0, "F")  ; Find the focused row.
	if not FocusedRowNumber  ; No row is focused.
		return
	LV_GetText(FileName, FocusedRowNumber, 1) ; Get the text of the first field.
	LV_GetText(FileDir, FocusedRowNumber, 2) 
	FileSelectFile, iconFile , , %RootDir%, Select an icon for this folder, Images (*.ico; *.jpg; *.png; *.gif; *.bmp)
	if (iconFile="")
		return
	FileAppend,%FileDir%\%FileName%|%iconFile%|, conf\custome icons.txt
	SplitPath, iconFile , , RootDir
	iconFile=
return
;regionend

;regionstart <<< Status >>>
switchStatus()
	{
		global
		toggleStatus:=!toggleStatus
		if (toggleStatus)
			GuiControl, , status, icone\status_work.png
		else
			GuiControl, , status, icone\status_free.png
		return
	}
updateStatusBar()
{
	global
	GuiControl, , statusbar, %status1%  %status2%  %status3%
	return
}
;regionend


