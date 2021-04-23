;==================================================
;=	AHKPad
;=		v1.6
;=	Created by Michael Peters
;=	Original code from GUI section of AHK help
;=	Segments of code from other peoples stuff
;=	Thanks everyone!
;==================================================

;===========================================
;=--------------Initialization-------------=
;===========================================
#SingleInstance off  ; allows multiple pads to be open
#notrayicon
#LTrim
StatusLength = 3000
OnMessage(0x200, "WM_MOUSEMOVE")    ;these are used to control the buttons
OnMessage(0x201, "WM_MOUSEDOWN")
OnMessage(0x202, "WM_MOUSEUP")
if %0% = 0     ; no parameters have been passed (%0% = num of params passed)
	currentfilename = Untitled
Gosub CreatePad
Gosub CreateWindows
if %0% <> 0  ;a file has been dropped on the exe and will be passed as a parameter
{
	selectedfilename = %1%     ;read the file that was dropped (1st param)
	gosub FileRead
}
return

CreatePad:
;-= read the ini file for position and size of Editpad
	iniread, EditPadPos, resource/settings.ini, Settings, EditPadPos
	iniread, EditPadSize, resource/settings.ini, Settings, EditPadSize
	iniread, fontsize, resource/settings.ini, Settings, fontsize
	iniread, fontfamily, resource/settings.ini, Settings, fontfamily
	iniread, wraptext, resource/settings.ini, Settings, wraptext
	iniread, wrap, resource/settings.ini, Settings, wrap

;-= Create the sub-menus for the menu bar
	Menu, FileMenu, Add, &New `tCtrl-N, FileNew
	Menu, FileMenu, Add, &Open `tCtrl-O, FileOpen
	Menu, FileMenu, Add, &Save `tCtrl-S, FileSave
	Menu, FileMenu, Add, Save &As `tCtrl-Shift-S, FileSaveAs
	Menu, FileMenu, Add  ; Separator line.
	Menu, FileMenu, Add, E&xit, FileExit
	Menu, EditMenu, Add, Find or Replace..., OpenFindReplace
	Menu, EditMenu, Add, &Preferences...,Options
	Menu, HelpMenu, Add, AHK &Help `tF1, AHKHELP
	Menu, HelpMenu, Add, &About AHKEditPad, HelpAbout

;-= Create the Menu Bar
	Menu, MyMenuBar, Add, &File, :FileMenu
	Menu, MyMenuBar, Add, &Edit, :EditMenu
	Menu, MyMenuBar, Add, &Help, :HelpMenu
	Gui, Menu, MyMenuBar

;-= Create picts for save, open, etc.
	gui, margin, 3,3

	gui, add, pic,x10   vNewPicUp Hidden, resource/up.png
	gui, add, pic,xp yp vNewPicDown Hidden, resource/down.png
	gui, add, pic,xp yp vNewPic gNothing BackgroundTrans,resource/new.png

	gui, add, pic,ym    vOpenPicUp Hidden, resource/up.png
	gui, add, pic,xp yp vOpenPicDown Hidden, resource/down.png
	gui, add, pic,xp yp vOpenPic gNothing BackgroundTrans,resource/open.png

	gui, add, pic,ym    vSavePicUp Hidden, resource/up.png
	gui, add, pic,xp yp vSavePicDown Hidden, resource/down.png
	gui, add, pic,xp yp vSavePic gNothing BackgroundTrans,resource/save.png

	gui, add, pic,ym    vTestPicUp Hidden, resource/up.png
	gui, add, pic,xp yp vTestPicDown Hidden, resource/down.png
	gui, add, pic,xp yp vTestPic gNothing BackgroundTrans, resource/test.png
 
	gui, add, pic,ym    vFindPicUp Hidden, resource/up.png
	gui, add, pic,xp yp vFindPicDown Hidden, resource/down.png
	gui, add, pic,xp yp vFindPic gNothing BackgroundTrans, resource/find.png

	gui, add, pic,ym    vPrefsPicUp Hidden, resource/up.png
	gui, add, pic,xp yp vPrefsPicDown Hidden, resource/down.png
	gui, add, pic,xp yp vPrefsPic gNothing BackgroundTrans, resource/prefs.png

	gui, add, pic,ym    vHelpPicUp Hidden, resource/up.png
	gui, add, pic,xp yp vHelpPicDown Hidden, resource/down.png
	gui, add, pic,xp yp vHelpPic gNothing BackgroundTrans,resource/help.png
	gui, margin, 10,10

	Gui, +Resize  ; Make the window resizable.

;-= Create main Edit control and then display the window
	gui, font, s%fontsize%, %fontfamily%
	Gui, Add, Edit, %wrap% xm yp+28 vMainEdit WantTab W500 R60 , %MainEdit%
	guicontrolget, MainEdit, pos
	Statusy := MainEdity + MainEditH
	gui, font, s10, Lucida Console
	gui, add, text, y%Statusy% xm vStatus, AHKPad Initialized
	gui, font, s%fontsize%, %fontfamily%
	SetTimer, StatusBarWait,%StatusLength%
	Gui, Show,%EditPadSize% %EditPadPos%, AHKPad - %currentfilename%
return

CreateWindows:
;-= Create Options window
	gui, 2:add, text, ,Font:
	gui, 2:add, DDL, xm vFontFamily, Arial|Courier|Lucida Console|MS Sans Serif|MS Serif|Tahoma|Times New Roman|Verdana
	gui, 2:add, text,xm ,Font Size:
	gui, 2:add, edit,yp  vfontsize w40, %currentfontsize%
	gui, 2:add, upDown, %currentfontsize%
	gui, 2:add, checkbox, vwraptext, Wrap Text?
	gui, 2:add, button, gSetSettings, OK

;-= create find/replace window
	gui, 3:add, text, ,Find:
	gui, 3:add, text, xm,Replace With:
	gui, 3:add, edit, vFindThis ym w100
	gui, 3:add, edit, vReplace w100
	gui, 3:add, button,xm gFindNext, FindNext
	gui, 3:add, button,xm gReplaceNext, Replace Next
	gui, 3:add, button,xm gReplaceAll, Replace ALL
return

;==========================================
;=----------------Commands----------------=
;==========================================

;-= New =-
	$^N:: ;the dollar sign prevents this hotkey from being triggered by the send below
		ifwinnotactive, AHKPad - %CurrentFileName%
		{
			send, ^n
			return
		}
	FileNew:
		Msgbox, 4, ,Save Changes to %CurrentFileName%
		ifmsgbox, yes
			gosub, FileSave
		CurrentFileName = Untitled
		Gui, Show,, AHKPad - %CurrentFileName%   ; Show file name in title bar.
		GuiControl,, MainEdit   ; Clear the Edit control.
		GuiControl,,Status, New Document Opened
		SetTimer, StatusBarWait,%StatusLength%
	return

;-= Open =-
	$^O::
		ifwinnotactive, AHKPad - %CurrentFileName%
		{
			send, ^o
			return
		}
	FileOpen:
		FileSelectFile, SelectedFileName, 3,, Open File, AHK Scripts (*.ahk)
		if SelectedFileName =  ; No file selected.
			return
		Gosub FileRead
	return

   ;-= FileRead =-
	FileRead:  
		FileRead, MainEdit, %SelectedFileName%  ; Read the file's contents into the variable.
		if ErrorLevel <> 0
		{
			MsgBox Could not open "%SelectedFileName%".
			return
		}
		GuiControl,, MainEdit, %MainEdit%  ; Put the text into the control.
		CurrentFileName = %SelectedFileName%
		GuiControl,,Status,File Opened
		SetTimer, StatusBarWait,%StatusLength%
		Gui, Show,, AHKPad - %CurrentFileName%   ; Show file name in title bar.
	return

;-= Save =-
	$^S::
		ifwinnotactive, AHKPad - %CurrentFileName%
		{
			send, ^s
			return
		}
	
	FileSave:
		if CurrentFileName = Untitled  ; No filename selected yet, so do Save-As instead.
			Goto FileSaveAs
		Gosub SaveCurrentFile
	return

   ;-= Save-As =-
	$^+S::
		ifwinnotactive, AHKPad - %CurrentFileName%
		{
			send, ^+s
			return
		}
	FileSaveAs:
		FileSelectFile, SelectedFileName, S16,.ahk, Save File, AHK Scripts (*.ahk)
		if SelectedFileName =  ; No file selected.
			return
		CurrentFileName = %SelectedFileName%
		Gosub SaveCurrentFile
	return

   ;-= Save Current File =-
	SaveCurrentFile:  ; Caller has ensured that CurrentFileName is not blank.
		IfExist %CurrentFileName%
		{
			FileDelete %CurrentFileName%
			if ErrorLevel <> 0
			{	
				MsgBox The attempt to overwrite "%CurrentFileName%" failed.
				return
			}
		}
		GuiControlGet, MainEdit  ; Retrieve the contents of the Edit control.
		ifnotinstring, currentfilename , .ahk
			currentfilename = %currentfilename%.ahk
		FileAppend, %MainEdit%, %CurrentFileName%  ; Save the contents to the file.
		Gui, Show,, AHKPad - %CurrentFileName%
		Guicontrol,,Status,Script Saved
		SetTimer, StatusBarWait,%StatusLength%
	return

;-= Test Script =-
	$F5::
		ifwinnotactive, AHKPad - %CurrentFileName%
		{
			send, {F5}
			return
		}
	TestScript:
		ifexist resource/test_script.ahk
		{
		FileDelete resource/test_script.ahk
		if ErrorLevel <> 0
			{	
				MsgBox The attempt to overwrite "resource/test_script.ahk" failed.
				return
			}
		}
		GuiControlGet, MainEdit  ; Retrieve the contents of the Edit control.
		FileAppend, %MainEdit%, resource/test_script.ahk  ; Save the contents to the file.
		Guicontrol,,Status,Script Launched
		SetTimer, StatusBarWait,%StatusLength%
		Run, resource/test_script.ahk
	return

;-= Find and Replace =-
   ;-= open window =-
	OpenFindReplace:    ;open the window
		gui 3:show,,Find or Replace
		findnum = 1
	return

   ;-= find next =-
	FindNext:
	return

   ;-= replace next =-
	ReplaceNext:
	return

   ;-= replace all =-
	ReplaceAll:
	return

;-= Options =-
	Options:
		gui, 2:show,,Options
	return

   ;-= Set Font =-
	SetSettings:
		gui, 2:Submit
		IniWrite, %fontfamily%, resource/settings.ini, Settings, fontfamily
		IniWrite, %fontsize%, resource/settings.ini, Settings, fontsize
		IniWrite, %Wraptext%, resource/settings.ini, Settings, wraptext
		if wraptext
			IniWrite, wrap, resource/settings.ini, Settings, wrap
		else
			IniWrite, -wrap, resource/settings.ini, Settings, wrap
		;gui, submit, nohide
		;gui, destroy
		;gosub, createPad
		Gui, Font, s%fontsize%, %fontfamily%
		guicontrol, font, mainedit
		gui, 2:hide
	return

;-= AHK Help =-
	$F1::
		ifwinnotactive, AHKPad - %CurrentFileName%
		{
			send, {F1}
			return
		}
	AHKHELP:
		RegRead, ahk_dir, HKEY_LOCAL_MACHINE, SOFTWARE\AutoHotkey, InstallDir
		if ErrorLevel <> 0  ; Use a best guess location instead.
			ahk_dir = %ProgramFiles%\AutoHotkey
		
		IfNotExist %ahk_dir%
		{
			MsgBox Could not find the AutoHotkey folder.
			return
		}
		Run, %ahk_dir%/AutoHotKey.chm
		Guicontrol,,Status,AHK Help Launched
	return

;-= About =-
	HelpAbout:
		MsgBox,,About AHKPad,
		(
		AHKPad
		Made by Veovis
		Original Source from GUI section of AutoHotKey Help.

		Help From:
		evl  -  Buttons
		)
	return

;-=-=-=-=-=-=-=-=-=-=-=-=-

;-= Gui Drop =-
	GuiDropFiles:  ; Support drag & drop.
		Loop, parse, A_GuiControlEvent, `n
		{
			SelectedFileName = %A_LoopField%  ; Get the first file only (in case there's more than one).
			break
		}
		Gosub FileRead
	return

;-= Gui Size =-
	GuiSize:
		if ErrorLevel = 1  ; The window has been minimized.  No action needed.
			return
		
		NewWidth := A_GuiWidth - 20
		NewHeight := A_GuiHeight - 51
		GuiControl, Move, MainEdit, W%NewWidth% H%NewHeight%
		guicontrolget, MainEdit, pos
		Statusy := MainEditH + MainEditY + 5
		GuiControl, Move, Status, y%StatusY%
		iniwrite, w%A_GuiWidth% h%A_GuiHeight%, resource/settings.ini, Settings, EditPadSize
	return

;-= Quit =-
	FileExit:	; User chose "Exit" from the File menu.
	GuiClose:	; User closed the window.
		WinGetPos, Xpos, Ypos,,, AHKPad - %currentFilename%
		IniWrite, x%Xpos% y%Ypos%, resource/settings.ini, Settings, EditPadPos
		gui, submit
		if MainEdit = 
			exitapp
		Msgbox, 4, ,Save Changes to %CurrentFileName% before closing?
		ifmsgbox, yes
		{
			if currentfilename = Untitled
				gosub, filesaveas
			gosub, FileSave
		}
	ExitApp

;-= Other Stuff =-
	Nothing:  
	return

	StatusBarWait:
	GuiControl,,Status,  ;empty
	return
;====================================
;=---------Button Controls----------=
;====================================
WM_MouseMove()
{
	global old_GuiControl ; define as global so it survives untill next MOUSEMOVE
	global Tooltip
	If A_GuiControl = NewPic
		Tooltip = New Script
	If A_GuiControl = OpenPic
		Tooltip = Open
	If A_GuiControl = SavePic
		Tooltip = Save Script
	If A_GuiControl = TestPic
		Tooltip = Test Script
	If A_GuiControl = FindPic
		Tooltip = Find/Replace
	If A_GuiControl = PrefsPic
		Tooltip = Preferences
	If A_GuiControl = HelpPic
		Tooltip = AHK Help
	If A_GuiControl =     ; mouse is over nothing
		Tooltip =
	If A_GuiControl = MainEdit ; mouse is over mainedit
		Tooltip =
	Tooltip, %tooltip%
	SetTimer, KillToolTip, 500
	if A_Guicontrol = %Old_GuiControl% ; the mouse is above the same thing it was last MOUSEMOVE
		return

	GetKeyState, MouseState, LButton
	If MouseState = D 
	{
		guicontrol, Hide, %A_GuiControl%Up
		guicontrol, Show, %A_GuiControl%Down
	}
	If MouseState = U 
	{
		guicontrol, Show, %A_GuiControl%Up
		guicontrol, Hide, %A_GuiControl%Down
	}
	guicontrol, Hide, %old_GuiControl%Up
	guicontrol, Hide, %old_GuiControl%Down
	old_Guicontrol = %A_GuiControl%
	
	return
}

KillToolTip:
	Tooltip   ;remove
return

WM_MOUSEDOWN()
{
	global old_GuiControl
	old_GuiControl = clicked
	WM_MOUSEMOVE()
}
WM_MOUSEUP()
{
	If A_GuiControl = NewPic
		Gosub, FileNew
	Else If A_GuiControl = OpenPic
		Gosub, FileOpen
	Else If A_GuiControl = SavePic
		Gosub, FileSave
	Else If A_GuiControl = TestPic
		Gosub, TestScript
	Else If A_GuiControl = FindPic
		Gosub, OpenFindReplace
	Else If A_GuiControl = PrefsPic
		Gosub, Options
	Else If A_GuiControl = HelpPic
		Gosub, AHKHelp
	global old_GuiControl
	old_GuiControl = released
	WM_MOUSEMOVE()
}