/*
BetterRun! 1.0
2009-11-26
Autohotkey v1.0.48
http://autohotkey.net/~gahks
http://creativecommons.org/licenses/by-sa/3.0/
*/
#NoTrayIcon
#NoEnv
#SingleInstance, Force
s_name:="BetterRun!",s_ext:="brun",s_ext_len:=StrLen(s_ext)+1
RegRead, s_configured, HKCU, Software\%s_name%, Configured ;REGISTRY!
If s_configured <> 1 
{ ;Init config gui
	Gui, Add, GroupBox, x6 y7 w340 h110 , Step 1
	Gui, Add, Text, x16 y27 w320 h80 , It seems you haven't used %s_name% yet. In order to use it, you'll need to go through a small installation process.`nTo learn more about the changes %s_name% will make on your system click on the Details button.`nTo start the configuration/installation process click on the Next button.
	Gui, Add, Button, x6 y127 w80 h20 +Default gConfigurationStep2, &Next
	Gui, Add, Button, x106 y127 w80 h20 gConfigurationDetails, &Details
	Gui, Add, Button, x206 y127 w80 h20 gGuiClose, Ex&it
	Gui, Show, h160 w354, %s_name% - Configuration
	Return
	
	ConfigurationDetails:
	Gui, 99:Destroy
	Gui, 99:Add, GroupBox, x6 y7 w340 h280 , Installation details
	Gui, 99:Add, Text, x16 y27 w320 h20 , %s_name% will...
	Gui, 99:Add, Button, x116 y297 w100 h20 +Default g99GuiClose, O&k
	Gui, 99:Add, Text, x16 y57 w320 h20 , - Add a new subkey to to registry:
	Gui, 99:Add, Text, x16 y77 w320 h20 , HKCU\Software\%s_name%
	Gui, 99:Add, Text, x16 y97 w320 h30 , - Add "short command directory" (the directory you'll specify in installation Step 2) to the current user's PATH environment variable at:
	Gui, 99:Add, Text, x16 y127 w320 h30 , HKCU\Environment
	Gui, 99:Add, Text, x16 y157 w320 h20 , - Create "short command directory" if it doesn't exist
	Gui, 99:Add, Text, x16 y177 w320 h30 , - Copy itself to "short command directory"
	Gui, 99:Add, Text, x16 y197 w320 h20 , - Create a shortcut of %s_name% in that directory
	Gui, 99:Add, Text, x16 y217 w320 h30 , - Create a shortcut of %s_name% on the Desktop.
	Gui, 99:+owner1
	Gui, 1:+Disabled
	Gui, 1:Hide
	Gui, 99:Show, h327 w355, %s_name% - Installation details
	Return

	99GuiClose:
	Gui, 1:-Disabled
	Gui, 1:Show
	Gui, 1:Default
	Gui, 99:Destroy
	return
	
	ConfigurationStep2:
	Gui, Destroy
	Gui, Add, GroupBox, x6 y7 w340 h80, Step 2
	Gui, Add, Button, x6 y127 w80 h20 +Default vbtn_config_install gConfigurationStep3, &Next
	Gui, Add, Button, x106 y127 w80 h20 vbtn_config_details gConfigurationDetails, &Details
	Gui, Add, Button, x206 y127 w80 h20 vbtn_config_exit gGuiClose, E&xit
	Gui, Add, Text, x16 y27 w336 h20, Select a folder for the short command files:
	Gui, Add, Edit, x16 y57 w220 h20 Disabled vvs_sc_dir,
	Gui, Add, Text, x16 y97 w336 h20 cRed verr_txt0 Center, The short command folder field cannot be blank!
	Gui, Add, Button, x246 y57 w90 h20 vbtn_config_browse gConfigurationBrowse, &Browse
	Gui, Show, Hide h162 w356, %s_name% - Configuration
	GuiControl, Hide, err_txt0
	Gui, Show
	Return
	
	ConfigurationBrowse:
	Gui, +OwnDialogs
	FileSelectFolder, s_sc_dir,,3, %s_name% - Select Short Command Folder
	If (errorlevel <> 1 && s_sc_dir)
		GuiControl,,vs_sc_dir, %s_sc_dir%
	return
	
	ConfigurationStep3:
	Gui, Submit, Nohide
	If !vs_sc_dir 
	{
		GuiControl, Show, err_txt0
		return
	}
	Gui, Destroy
	Gui, Add, GroupBox, x6 y7 w340 h80 , Step 3
	Gui, Add, Button, x6 y127 w80 h20 +Default vbtn_config_install gConfigurationFinish, &Install
	Gui, Add, Button, x106 y127 w80 h20 vbtn_config_details gConfigurationDetails, &Details
	Gui, Add, Button, x206 y127 w80 h20 vbtn_config_exit gGuiClose, E&xit
	Gui, Add, Text, x16 y27 w336 h20 , Select a short command for %s_name%
	Gui, Add, Edit, x16 y57 w220 h20 vvs_sc, br
	Gui, Add, Text, x16 y97 w336 h20 verr_txt1 Center, Installation in progress...
	Gui, Add, Text, x16 y97 w336 h20 cRed verr_txt2 Center, The short command field cannot be blank!
	Gui, Add, Text, x16 y97 w336 h20 cGreen verr_txt3 Center, Installation successful...
	Gui, Add, Button, x327 y27 w15 h20 +Center gConfigurationStep3Help, ?
	Gui, Show, Hide h164 w358, %s_name% - Configuration
	GuiControl, Hide, err_txt1
	GuiControl, Hide, err_txt2
	GuiControl, Hide, err_txt3
	Gui, Show
	return
	
	ConfigurationStep3Help:
	Gui, 99:Destroy
	Gui, 99:Add, Text, x16 y27 w320 h20 , Short command for %s_name%:
	Gui, 99:Add, Button, x106 y207 w110 h20 +Default g99GuiClose, O&k
	Gui, 99:Add, Text, x16 y57 w320 h50 , You will be able to access %s_name% by entering this short command (as opposed to entering the full path to the %s_name% executable)
	Gui, 99:Add, GroupBox, x6 y7 w340 h190 , Installation help
	Gui, 99:Add, Text, x16 y107 w320 h80 , E.g.:`nInstead of "c:\SomeDir\%s_name%.exe" you can simply enter for example "asd" and %s_name% will be executed.
	Gui, 99:+owner1
	Gui, 1:+Disabled
	Gui, 1:Hide
	Gui, 99:Show, h218 w377, %s_name% - Installation help
	return

	ConfigurationFinish:
	Gui, +OwnDialogs
	GuiControl, Hide, err_txt1
	GuiControl, Hide, err_txt2
	Gui, Submit, Nohide
	If !vs_sc 
	{
		GuiControl, Show, err_txt2
		return
	}
	GuiControl, Disable, btn_config_exit
	GuiControl, Disable, btn_config_browse
	GuiControl, Disable, btn_config_details
	GuiControl, Disable, btn_config_install
	GuiControl, Disable, vs_sc_dir
	GuiControl, Show, err_txt1
	err := install()
	If err 
	{
		uninstall()
		MsgBox, 64, %s_name%: Error!, Installation failed.`n%s_name% couldn't write to the registry, or couldn't create/copy the necessary files. Please check if you have read/write access to the registry and to the drive on which you want to use %s_name%, and try again.
		Sleep, 2000
		Reload
		return
	}	
	GuiControl, Show, err_txt3
	GuiControl, Enable, btn_config_exit
	MsgBox, 64, %s_name%: Installation successful!, %s_name% successfully created/modified all the necessary registry entries/files/folders.`nYou may now run %s_name% by typing "%vs_sc%" in Start menu\Run or by clicking on the desktop shortcut.
	Sleep, 1000
	FileDelete, %a_scriptfullpath% ;UNCOMMENT IT!
	ExitApp
 	return
}	
;Reading script settings
RegRead, s_sc_dir, HKCU, Software\%s_name%, ShortCutDir ;REGISTRY!
RegRead, s_sc, HKCU, Software\%s_name%, ShortCommand ;REGISTRY!
RegRead, s_exec, HKCU, Software\%s_name%, ExecutableName ;REGISTRY!
IfNotExist, %s_sc_dir%\%s_sc%.lnk
	FileCreateShortcut, %s_sc_dir%\%a_scriptname%, %s_sc_dir%\%s_sc%.lnk
If 0 = 0 ;No command line parameters, jump to the GUI
	Goto, MainGUI
;; Showing info about short commands specified after -info
If 1 = -info 
{
	0-- ;'cause -info is the first parameter
	Gui, Add, Listview, w300 r10, Short Command|Name|Destination
	Loop, %0% 
	{
		c_par := a_index+1, c_par := %c_par%
		IniRead, c_sc_name, %s_sc_dir%\%c_par%.%s_ext%, Short Command, name
		;IniRead, c_sc_type, %s_sc_dir%\%c_par%.%s_ext%, Short Command, type
		IniRead, c_sc_dest, %s_sc_dir%\%c_par%.%s_ext%, Short Command, destination
		Lv_add("", c_par, c_sc_name, c_sc_dest)
	}
	LV_ModifyCol()
	Gui, Add, Button,gGuiClose w100, Close 
	Gui, Show, Autosize, %s_name% - Short Command Information
	return
} 
Else 
{ ;; Processing short commands
	c_buffer =
	p_total = %0%
	Loop, % p_total+1
	{
		c_par := %a_index%
		If (SubStr(c_par, 1, 1) = "@" || SubStr(c_par, 1, 1) = "\") 
		{
			StringTrimLeft, c_par, c_par, 1
			StringSplit, c_sc, c_par, &&
			c_sc_par = ;Deleting parameters from previous session
			Loop, %c_sc0%
			{
				c_sub_par := c_sc%a_index%
				c_sc_par .= c_sub_par . " "
			}	
			If !c_buffer
				Continue
			If (c_sc_type = "file")
				Run, %c_sc_dest% %c_sc_par%,, UseErrorLevel
			Else if (c_sc_type = "folder")
			{
				If (SubStr(c_sc_type, 0) = "\")
					Run, %c_sc_dest%%c_sc_par%,, UseErrorLevel ;missing ending backslash
				Else
					Run, %c_sc_dest%\%c_sc_par%,, UseErrorLevel
			}	
			Else if (c_sc_type = "url")
				Run, %c_sc_dest%%c_sc_par%,, UseErrorLevel ;missing ending backslash
			c_buffer =
		} 
		Else 
		{ ;Short command doesn't have parameters
			If c_buffer
				Run, %c_buffer%,,UseErrorLevel
			IniRead, c_sc_dest, %s_sc_dir%\%c_par%.%s_ext%, Short Command, destination
			IniRead, c_sc_type, %s_sc_dir%\%c_par%.%s_ext%, Short Command, type
			If (!c_sc_dest || c_sc_dest = "ERROR") ;Failed attempt to load short command destination
				Continue ;Error, continue with the next short command
			c_buffer := c_sc_dest
		}
	}	
}
ExitApp

;//MAIN GUI
MainGui:
;Context menu
;---------------------------------
Menu, cMenu, Add, Refresh list, Refresh
Menu, cMenu, Add, 
Menu, cMenu, Add, Open containing directory, OpenCTDir
Menu, cMenu, Add, 
Menu, cMenu, Add, Run, LaunchSCDest
Menu, cMenu, Add, 
Menu, cMenu, Add, &Add, AddShortCommand
Menu, cMenu, Add, &Edit, EditShortCommand
Menu, cMenu, Default, &Edit
Menu, cMenu, Add, &Delete, DeleteShortCommand
Menu, cMenu, Add, 
Menu, cMenu, Add, Re&load, Reload
Menu, cMenu, Add, E&xit, GuiClose
;---------------------------------
Menu, cMenuS, Add, &Add new Short Command, AddShortCommand
Menu, cMenuS, Default, &Add new Short Command
Menu, cMenuS, Add, &Open Short Command directory, OpenSCDir
Menu, cMenuS, Add, 
Menu, cMenuS, Add, &Edit configuration, EditConfiguration
Menu, cMenuS, Add, 
Menu, cMenuS, Add, A&bout, About
Menu, cMenuS, Add, Re&load, Reload
Menu, cMenuS, Add, E&xit, GuiClose
;---------------------------------
;Gui
w_lv := a_screenwidth/3
Gui, Add, ListView, x6 y7 w450 h320 -LV0x10 gMainGUIListView vlv_maingui, Command|Name|Destination|Type
LV_Delete() ;Cleaning
IL_Destroy(IconList) ;Cleaning
Iconlist := IL_Create(10)
LV_SetImageList(IconList)
Loop, %s_sc_dir%\*.%s_ext%, 1
{
	IniRead, c_type, %A_LoopFileLongPath%, Short Command, type
	IniRead, c_name, %A_LoopFileLongPath%, Short Command, name
	IniRead, c_dest, %a_loopfilelongpath%, Short Command, destination
	StringSplit, c_sc, a_loopfilelongpath, \
	c_sc := c_sc%c_sc0%
	StringTrimRight, c_sc, c_sc, %s_ext_len%
	If c_type = url
		Il_Add(IconList, "shell32.dll", 15) ;on Windows XP/Vista
	Else if c_type = file
	{
		StringSplit, c_ext, c_dest, \
		c_ext := c_ext%c_ext0%
		StringSplit, c_ext, c_ext, .
		c_ext_nr := c_ext0, c_ext := c_ext%c_ext0%
		If  !Il_Add(Iconlist, c_dest, 1) 
		{
			If c_ext_nr <= 1
				Il_Add(IconList, "shell32.dll", 1) ;on Windows XP/Vista	
			Else
			{
				hIcon := DllCall("Shell32\ExtractAssociatedIconA", UInt, 0, Str, c_dest, UShortP, iIndex)
				DllCall("ImageList_ReplaceIcon", UInt, IconList, Int, -1, UInt, hIcon)
				DllCall("DestroyIcon", Uint, hIcon)			
			}
		}	
	} 
	Else 
	{
		hIcon := DllCall("Shell32\ExtractAssociatedIconA", UInt, 0, Str, c_dest, UShortP, iIndex)
		DllCall("ImageList_ReplaceIcon", UInt, IconList, Int, -1, UInt, hIcon)
		DllCall("DestroyIcon", Uint, hIcon)
	}	
	If (!c_type || c_type="ERROR" || !c_name || c_name="ERROR" || !c_dest || c_dest="ERROR" || InStr(c_dest, "shell32.dll"))
		Continue
	LV_Add("Icon" . a_index, c_sc, c_name, c_dest, c_type) 
	If (StrLen(c_sc) < 1 && StrLen(c_name) < 6 && StrLen(c_dest) < 11)
		align_hdr = 1
	Else
		align_hdr = 0
}	
c_sc_total := LV_GetCount()
If (c_sc_total <> 0 && align_hdr <> 1)
	Lv_ModifyCol()
Else ;no short commands
	Lv_ModifyCol("Hdr")
Lv_ModifyCol(4, 0)
Loop, 3
LV_ModifyCol(a_index, "Text")
Gui, Add, GroupBox, x466 y7 w120 h110 , Short commands
Gui, Add, Button, x476 y27 w90 h20 gAddShortCommand, &Add
Gui, Add, Button, x476 y57 w90 h20 gEditShortCommand Default, &Edit
Gui, Add, Button, x476 y87 w90 h20 vbtn_delsc gDeleteShortCommand, &Delete
Gui, Add, GroupBox, x466 y127 w120 h80 , Configuration
Gui, Add, Button, x476 y147 w90 h20 gEditConfiguration, Ed&it
Gui, Add, Button, x476 y177 w90 h20 gDeleteConfiguration, De&lete
Gui, Add, Button, x476 y237 w90 h20 gGuiClose, E&xit
Gui, Add, GroupBox, x466 y217 w120 h50 , Close
Gui, Show, h336 w601, %s_name% - Current short commands (%c_sc_total%)
return

GuiClose:
Exitapp
return

Reload:
Reload
return

Refresh:
refreshList()
return

GuiContextMenu:
If a_guicontrol = lv_maingui
	Menu, cMenu, Show
Else
	Menu, cMenuS, Show
return

MainGUIListView:
If a_guievent = DoubleClick  
{ ;Open clicked items on double click 
	Goto, EditShortCommand
}
return

LaunchSCDest:
Gui, 1:+Owndialogs
c_count:=LV_GetCount("Selected"),i_pr:=0
If ( c_count = 0) 
{
	MsgBox, 64, %s_name% - Error, You must select a short command first.
	return
}
Loop, %c_count%
{
	i_pr := LV_GetNext(i_pr)
	Lv_GetText(c_dest, i_pr, 3)
	Run, %c_dest%,,UseErrorLevel
	If ErrorLevel
		Run, rundll32.exe shell32.dll`,OpenAs_RunDLL %c_dest%,,UseErrorLevel ;If no associated exe, open Open With window
}	
return

OpenSCDir: ;Open short command directory
Run, explorer.exe "%s_sc_dir%",,UseErrorLevel
return

OpenCTDir: ;Open containing directory
Gui, 1:+OwnDialogs
c_count:=LV_GetCount("Selected"),i_pr:=0
If (c_count = 0) 
{
	MsgBox, 64, %s_name% - Error, You must select a short command first.
	return
}
Loop, %c_count%
{
	i_pr := LV_GetNext(i_pr)
	LV_GetText(c_type, i_pr, 4)
	LV_GetText(c_dest_f, i_pr, 3)
	If c_type = url
		return
	StringSplit, c_dest, c_dest_f, \
	StringTrimRight, c_dest, c_dest_f, StrLen(c_dest%c_dest0%)
	Run, %c_dest%,,UseErrorLevel
}	
c_dest:="",c_type:="",c_dest_f:=""
return

About: ;About
Gui, 98:Add, GroupBox, x6 y7 w280 h110 , About
Gui, 98:Add, Text, x16 y27 w260 h20 , %s_name%
Gui, 98:Add, Text, x16 y47 w260 h20 , (c) 2009
Gui, 98:Add, Text, x16 y67 w260 h20 , Under CC Attribution-Share Alike 3.0:
Gui, 98:Add, Text, x16 y87 w260 h20 +cBlue vgoto_cc gOpenURL, http://creativecommons.org/licenses/by-sa/3.0/
Gui, 98:Add, Button, x6 y127 w110 h20 g98GuiClose, Close
Gui, 98:Add, Button, x136 y127 w110 h20 gOpenURL, Visit website
Gui, 98:Add, Text, x76 y47 w184 h20 +cBlue vgoto_home gOpenURL, http://autohotkey.net/~gahks
Gui, 98:+AlwaysOnTop
Gui, 98:+owner1
Gui, 98:+ToolWindow
Gui, 1:+Disabled
Gui, 98:Show, h157 w295, %s_name% - About
Return

OpenURL:
If a_guicontrol = goto_cc
	Run, http://creativecommons.org/licenses/by-sa/3.0/,,UseErrorLevel
Else
	Run, http://autohotkey.net/~gahks,,UseErrorLevel
return

98GuiClose:
Gui, 1:-Disabled
Gui, 98:Destroy
Gui, 1:Show
return ;End of About
;//END of MAIN GUI

;// EDIT SHORT COMMAND
EditShortCommand:
Gui, 1:+Owndialogs
If LV_GetCount("Selected") > 1 
{
	MsgBox, 64, %s_name%: Error, You can edit only one short command at a time.
	return
} 
Else if LV_GetCount("Selected") = 0 
{
	MsgBox, 64, %s_name%: Error, You must select a short command first.
	return
}	
c_row := LV_GetNext()
LV_GetText(c_sc, c_row, 1)
LV_GetText(c_name, c_row, 2)
LV_GetText(c_dest, c_row, 3)
LV_GetText(c_type, c_row, 4)
Gui, 2:Default
Gui, 2:Add, Text, x16 y27 w130 h20 , Name:
Gui, 2:Add, Text, x16 y57 w130 h20 , Short command:
Gui, 2:Add, Text, x16 y87 w270 h20 , Destination:
Gui, 2:Add, Edit, x156 y27 w280 h20 vv_name, %c_name%
Gui, 2:Add, GroupBox, x6 y7 w450 h150 ,  Edit short command
Gui, 2:Add, Edit, x156 y57 w280 h20 vv_sc, %c_sc%
Gui, 2:Add, Edit, x16 y117 w280 h20 vv_dest hwndhDest, %c_dest%
DllCall( "ole32\CoInitialize", UInt,0 )
DllCall( "shlwapi\SHAutoComplete", UInt,hDest, UInt,0x1|0x10000000 )
If (c_type = "file" || c_type = "folder") 
	Gui, 2:Add, Button, x306 y117 w140 h20 gEditShortCommandBrowse, B&rowse
Gui, 2:Add, Button, x16 y167 w80 h20 gEditShortCommandSave +Border Default, &Save
Gui, 2:Add, Button, x106 y167 w80 h20 +Border g2GuiClose, &Cancel
Gui, 2:-Caption
Gui, 2:+owner1
Gui, 1:+Disabled
Gui, 1:Hide
Gui, 2:Show, h201 w462, %s_name% - Edit %c_name%
Return

2GuiClose:
Gui, 1:-Disabled
Gui, 1:Default
refreshList()
Gui, 2:Destroy
Gui, 1:Show, h336 w601, %s_name% - Current short commands (%c_sc_total%)
return

EditShortCommandBrowse:
Gui, 2:+OwnDialogs
If c_type = file 
{
	FileSelectFile, c_dest, 3,,%s_name% - Select Short Command Destination
	If (errorlevel <> 1 && c_dest)
		GuiControl,,v_dest, %c_dest%
} 
Else if c_type = folder 
{
	FileSelectFolder, c_dest,,3, %s_name% - Select Short Command Destination
	If (errorlevel <> 1 && c_dest)
		GuiControl,,v_dest, %c_dest%
}	
return

EditShortCommandSave:
Gui, 2:+Owndialogs
Gui, 2:Submit, NoHide
If c_sc <> v_sc 
{
	err = 0
	StringSplit, v_sc_check, v_sc
	Loop, %v_sc_check0%
	{
		If v_sc_check%a_index% is not digit 
		{
			If v_sc_check%a_index% is not alpha 
			{
				err = 1
				break
			}	
		}	
	}	
	If err = 1 
	{
		MsgBox, 64, %s_name%: Error, The short command cannot contain spaces or special characters.
		return
	}
	FileMove, %s_sc_dir%\%c_sc%.%s_ext%, %s_sc_dir%\%v_sc%.%s_ext%
	FileDelete, %s_sc_dir%\%c_sc%.lnk
	FileCreateShortCut, %s_sc_dir%\%s_exec%, %s_sc_dir%\%v_sc%.lnk,,%v_sc%
}
IniWrite, %v_name%, %s_sc_dir%\%v_sc%.%s_ext%, Short Command, name
If c_type = url 
{
	If (!InStr(v_dest, "http://") && !InStr(v_dest, "www.") && !InStr(v_dest, "ftp://")) 
	{
		MsgBox, 64, %s_name%: Error, The URL must contain "http://", "www." or "ftp://" to be recognized as a URL.
		return
	}
}	
IniWrite, %v_dest%, %s_sc_dir%\%v_sc%.%s_ext%, Short Command, destination
Gui, 1:Default
refreshList()
Gui, 1:-Disabled
Gui, 2:Destroy
Gui, 1:Show, h336 w601, %s_name% - Current short commands (%c_sc_total%)
return
;//END of EDIT SHORT COMMAND

;//ADD NEW SHORT COMMAND
AddShortCommand:
AddShortCommandStep1:
Gui, 3:Add, GroupBox, x6 y7 w330 h90 , Step 1
Gui, 3:Add, Button, x16 y57 w90 h30 gAddShortCommandType vfile Default, &File
Gui, 3:Add, Button, x116 y57 w90 h30 gAddShortCommandType vfolder, F&older
Gui, 3:Add, Button, x216 y57 w100 h30 gAddShortCommandType vurl, &URL
Gui, 3:Add, Text, x16 y27 w300 h20 , You want to add a short command for a...
Gui, 3:-Caption
Gui, 3:+owner1
Gui, 1:+Disabled
Gui, 1:Hide
Gui, 3:Show, h104 w348, %s_name% - Creating new Short Command
return

3GuiClose:
Gui, 1:-Disabled
Gui, 3:Destroy
Gui, 1:Default
return

AddShortCommandType:
Stringreplace, c_type, a_guicontrol, &, 
url:="",file:=""folder:="" 
Gui, 3:Destroy

AddShortCommandStep2:
Gui, 2:Add, Text, x16 y97 w130 h20 , Name:
Gui, 2:Add, Text, x16 y127 w130 h20 , Short command:
Gui, 2:Add, Text, x16 y27 w270 h20 , Destination:
Gui, 2:Add, Edit, x166 y97 w280 h20 vv_name,
Gui, 2:Add, GroupBox, x6 y7 w450 h150, Step 2
Gui, 2:Add, Edit, x166 y127 w280 h20 vv_sc,
Gui, 2:Add, Edit, x16 y57 w280 h20 hwndhDest vv_dest,
DllCall( "ole32\CoInitialize", UInt,0 )
DllCall( "shlwapi\SHAutoComplete", UInt,hDest, UInt,0x1|0x10000000 )
If (c_type = "file" || c_type = "folder")
	Gui, 2:Add, Button, x306 y57 w140 h20 gAddShortCommandBrowse, B&rowse
Gui, 2:Add, Button, x16 y167 w80 h20 gAddShortCommandSave +Border Default, &Save
Gui, 2:Add, Button, x106 y167 w80 h20 +Border g2GuiClose, &Cancel
Gui, 2:Add, Text, xp+90 cRed verr_txt1_1, The destination field cannot be blank!
Gui, 2:Add, Text, xp cRed verr_txt1_2, The short command field cannot be blank!
Gui, 2:Add, Text, xp cRed verr_txt2, The specified short command already exists!
Gui, 2:Add, Text, xp cGreen verr_txt3, Short command successfully created!
Gui, 2:Add, Text, xp cRed verr_txt4, The short command can contain only numbers and letters!
Gui, 2:-Caption
Gui, 2:+owner1
Gui, 1:+Disabled
Gui, 1:Hide
Gui, 2:Show, Hide h201 w462, %s_name% - Creating new short command
Gui, 2:Default
GuiControl, Hide, err_txt1_1
GuiControl, Hide, err_txt1_2
GuiControl, Hide, err_txt2
GuiControl, Hide, err_txt3
GuiControl, Hide, err_txt4
Gui, 2:Show
Return

AddShortCommandBrowse:
Gui, 2:+OwnDialogs
If c_type = file 
{
	FileSelectFile, c_dest, 3,,%s_name% - Select short command Destination
	If (errorlevel <> 1 && c_dest)
	{
		GuiControl,,v_dest, %c_dest%
		StringSplit, v_name, c_dest, \
		v_name_file := v_name%v_name0%
		StringSplit, v_name, v_name_file, .
		If v_name0 = 1
			v_name :=  v_name1
		Else
		{
			If (v_name%v_name0% = "exe")
				StringTrimRight, v_name, v_name_file, Strlen(v_name%v_name0%)+1
			Else
				v_name:=v_name_file
		}
		GuiControl,,v_name, %v_name%
	}
} 
Else if c_type = folder 
{
	FileSelectFolder, c_dest,,3, %s_name% - Select Short Command Destination
	If (errorlevel <> 1 && c_dest)
	{
		GuiControl,,v_dest, %c_dest%
		StringSplit, v_name, c_dest, \
		v_name := v_name%v_name0%
		GuiControl,,v_name, %v_name%
	}	
}	
return

AddShortCommandSave:
GuiControl, Hide, err_txt1_1
GuiControl, Hide, err_txt1_2
GuiControl, Hide, err_txt2
GuiControl, Hide, err_txt3
GuiControl, Hide, err_txt4
Gui, 2:Submit, Nohide
If (!v_dest) 
{
	GuiControl, Hide0, err_txt1_1 ;Blank fields
	return
}
Else if (!v_sc) 
{
	GuiControl, Hide0, err_txt1_2 ;Blank fields
	return
}	
Else if FileExist(s_sc_dir . "\" . v_sc . "." . s_ext)
{
	GuiControl, Hide0, err_txt2 ;Existing short command
	return
}
err = 0
StringSplit, v_sc_check, v_sc
Loop, %v_sc_check0% ;Check for special chars in short command
{
	If v_sc_check%a_index% is not digit 
	{
		If v_sc_check%a_index% is not alpha 
		{
			err = 1
			break
		}	
	}	
}	
If err = 1 
{
	GuiControl, Hide0, err_txt4 ;Short command contains illegal characters
	return
}
If c_type = url 
{
	If (!InStr(v_dest, "http://") && !InStr(v_dest, "www.") && !InStr(v_dest, "ftp://")) 
	{
		MsgBox, 64, %s_name%: Error, The URL must contain "http://", "www." or "ftp://" to be recognized as a URL.
		return
	}
}	
If (!v_name) 
{
	;User didn't enter name, extracting it from the destination file/folder
	If c_type = url
		v_name = New Url
	Else if c_type = file 
	{
		StringSplit, v_name, v_dest, \
		v_name_file := v_name%v_name0%
		StringSplit, v_name, v_name_file, .
		If v_name0 = 1
			v_name :=  v_name1
		Else
		{
			If (v_name%v_name0% = "exe")
				StringTrimRight, v_name, v_name_file, Strlen(v_name%v_name0%)+1
			Else
				v_name:=v_name_file
		}
	} Else { ;type=folder
		StringSplit, v_name, v_dest, \
		v_name := v_name%v_name0%
	}	
}	
IniWrite, %c_type%, %s_sc_dir%\%v_sc%.%s_ext%, short command, type
err1 := errorlevel
IniWrite, %v_name%, %s_sc_dir%\%v_sc%.%s_ext%, short command, name
err2 := errorlevel
IniWrite, %v_dest%, %s_sc_dir%\%v_sc%.%s_ext%, short command, destination
err3 := ErrorLevel
FileCreateShortCut, %s_sc_dir%\%s_exec%, %s_sc_dir%\%v_sc%.lnk,,%v_sc%
If (err1 || err2 || err3 || errorlevel) 
{
	MsgBox, 64, %s_name%: Error!, Short command creation failed!
	FileDelete, %s_sc_dir%\%v_sc%.%s_ext%
	FileDelete, %s_sc_dir%\%v_sc%.lnk
	return
}
GuiControl,,v_dest,
GuiControl,,v_name,
GuiControl,,v_sc,
GuiControl, Hide0, err_txt3
return
;//END of ADD NEW SHORT COMMAND

;//DELETE SELECTED SHORT COMMANS
DeleteShortCommand:
Gui, 1:+OwnDialogs
If !Lv_GetCount("Selected")
	return
MsgBox, 68, %s_name%: Delete short command, Are you sure you want to delete the selected short command(s)?
IfMsgBox, No
	return
GuiControl, Disable, btn_delsc
Loop, % Lv_GetCount("Selected")
{
	c_row := Lv_GetNext()
	Lv_Gettext(c_sc, c_row)
	FileDelete, %s_sc_dir%\%c_sc%.%s_ext%
	FileDelete, %s_sc_dir%\%c_sc%.lnk
	Lv_Delete(c_row)
}	
refreshList()
Gui, Show, h336 w601, %s_name% - Current short commands (%c_sc_total%)
GuiControl, Enabled, btn_delsc
return
;//END of DELETE SELECTED SHORT COMMANDS

;//DELETE CONFIGURATION AND SHORT COMMANDS (UNINSTALL)
DeleteConfiguration:
Gui, 99:Add, GroupBox, x6 y7 w340 h87, Uninstall
Gui, 99:Add, Text, x16 y27 w320 h40 , If you continue, %s_name% will remove all all changes it made on your PC since installation.
Gui, 99:Add, Button, x106 y137 w80 h20 vbtn_unsintall gDeleteConfigurationDo, &Uninstall
Gui, 99:Add, Button, x206 y137 w80 h20 +Default g99GuiClose vbtn_cancelD, &Cancel
Gui, 99:Add, Text, x16 y67 w320 h20 , Are you sure you want to continue?
Gui, 99:Add, Text, x16 y107 w320 h20 verr_txtD1 Center, Uninstallation in progress...
Gui, 99:Add, Text, x16 y107 w320 h20 cGreen verr_txtD2 Center, Uninstallation successful.
Gui, 99:+owner1
Gui, 99:Default
Gui, 1:+Disabled
Gui, 1:Hide
Gui, 99:Show, Hide h164 w358, Uninstall %s_name%
GuiControl, Hide, err_txtD1
GuiControl, Hide, err_txtD2
GuiControl, Disable, btn_unsintall
Gui, 99:Show
c_d := 8
Loop, %c_d%
{
	GuiControl,, btn_unsintall, Uninstall (%c_d%)
	c_d--
	Sleep, 1000
}
GuiControl,, btn_unsintall, Uninstall	
GuiControl, Enable, btn_unsintall
Return

DeleteConfigurationDo:
GuiControl, Disable, btn_unsintall
GuiControl, Disable, btn_cancelD
GuiControl, Hide, err_txtD1
GuiControl, Hide, err_txtD2
Gui, 99:-Caption
Gui, 99:Show, h124 w358, Uninstalling %s_name%...
uninstall(1)
GuiControl, Show, err_txtD2
Sleep, 3000
ExitApp
return
;//END of DELETE CONFIGURATION AND SHORT COMMANDS (UNINSTALL)

;//EDIT CONFIGURATION
EditConfiguration:
Gui, 2:Add, Text, x16 y32 w296 h20, %s_exec% short command:
Gui, 2:Add, Text, x16 y62 w270 h20, Change short command directory to...
Gui, 2:Add, GroupBox, x6 y7 w450 h180, Configuration
Gui, 2:Add, Edit, x306 y32 w140 h20 vv_scEC, %s_sc%
Gui, 2:Add, Edit, x16 y92 w280 h20 vv_sc_dirEC, %s_sc_dir%
Gui, 2:Add, Button, x306 y92 w140 h20 gEditConfigurationBrowse, B&rowse
Gui, 2:Add, Button, x16 y207 w80 h20 gEditConfigurationSave vbtn_EC_save +Border Default, &Save
Gui, 2:Add, Button, x106 y207 w80 h20 +Border g2GuiClose vbtn_EC_cancel, &Cancel
Gui, 2:Add, Text, x16 y122 w270 h20 , Backup short commands
Gui, 2:Add, Edit, x16 y152 w280 h20 vv_bakEC, 
Gui, 2:Add, Button, x306 y152 w60 h20 vbtn_EC_savebak gEditConfigurationBackup, Sa&ve
Gui, 2:Add, Button, x386 y152 w60 h20 vbtn_EC_loadbak gEditConfigurationBackup, &Load
Gui, 2:Add, Text, x206 y207 w250 h20 cGreen +Center verr_txtEC, Configuration changed.
Gui, 2:Add, Text, x206 y207 w250 h20 cRed +Center verr_txt2EC, Configuration not saved.
Gui, 2:Add, Text, x206 y207 w250 h20 cGreen +Center verr_txt3EC, Backup loaded.
Gui, 2:Add, Text, x206 y207 w250 h20 cGreen +Center verr_txt4EC, Backup saved.
Gui, 2:-Caption
Gui, 2:+owner1
Gui, 1:+Disabled
Gui, 1:Hide
Gui, 2:Show, Hide h238 w462, %s_name% - Creating new short command
Gui, 2:Default
GuiControl, Hide, err_txtEC
GuiControl, Hide, err_txt2EC
GuiControl, Hide, err_txt3EC
GuiControl, Hide, err_txt4EC
GuiControl, Disable, v_sc_dirEC
GuiControl, Disable, v_bakEC
Gui, 2:Show
Return

EditConfigurationBrowse:
Gui, 2:+OwnDialogs
FileSelectFolder, c_dest,,3, %s_name% - Select new short command directory
If (errorlevel <> 1 && c_dest)
	GuiControl,,v_sc_dirEC, %c_dest%
return

EditConfigurationBackup:
Gui, 2:+OwnDialogs
GuiControl, Hide, err_txtEC
GuiControl, Hide, err_txt2EC
GuiControl, Hide, err_txt3EC
GuiControl, Hide, err_txt4EC
GuiControl, Disable, btn_EC_save
GuiControl, Disable, btn_EC_cancel
GuiControl, Disable, btn_EC_savebak
GuiControl, Disable, btn_EC_loadbak
FileSelectFolder, c_dest,,3, %s_name% - Select short command backup directory
If (errorlevel = 1 || !c_dest) 
{
	GuiControl, Enable, btn_EC_save
	GuiControl, Enable, btn_EC_cancel
	GuiControl, Enable, btn_EC_savebak
	GuiControl, Enable, btn_EC_loadbak
	return
}
If a_guicontrol = btn_EC_savebak
	MsgBox, 68, %s_name%: Saving Backup, Are you sure you want to backup your short commands to the selected directory?
Else
	MsgBox, 68, %s_name%: Saving Backup, Are you sure you want copy short commands from the selected directory?
IfMsgBox, No 
{
	GuiControl, Enable, btn_EC_save
	GuiControl, Enable, btn_EC_cancel
	GuiControl, Enable, btn_EC_savebak
	GuiControl, Enable, btn_EC_loadbak
	return
}	

GuiControl,,v_bakEC, %c_dest%
If a_guicontrol = btn_EC_savebak 
{ ;Saving backup
	Loop, %s_sc_dir%\*.%s_ext%
	{
		StringTrimRight, c_sc, a_loopfilename, StrLen(a_loopfileext) + 1
		FileCopy, %A_LoopFileFullPath%, %c_dest%, 1
		FileCopy, %s_sc_dir%\%c_sc%.lnk, %c_dest%, 1
	}	
	GuiControl, Hide0, err_txt4EC
}
Else if a_guicontrol = btn_EC_loadbak 
{ ;Loading a backup
	overwrite = 0
	Loop, %c_dest%\*.%s_ext%
	{	
		If (!overwrite) 
		{
			IfExist, %s_sc_dir%\%A_LoopFileName%
			{
				MsgBox, 68, %s_name%: Loading Backup, Do you want to overwrite existing files?
				IfMsgBox, No
					Continue
				Else
					overwrite = 1
			}
		}
		StringTrimRight, c_sc, a_loopfilename, StrLen(a_loopfileext) + 1
		FileCopy, %A_LoopFileFullPath%, %s_sc_dir%, 1
		FileCopy, %c_dest%\%c_sc%.lnk, %s_sc_dir%, 1
		FileCreateShortcut, %s_sc_dir%\%s_exec%, %s_sc_dir%\%c_sc%.lnk,,%c_sc%
	}	
	GuiControl, Hide0, err_txt3EC
}	
GuiControl, Enable, btn_EC_save
GuiControl, Enable, btn_EC_cancel
GuiControl, Enable, btn_EC_savebak
GuiControl, Enable, btn_EC_loadbak
return

EditConfigurationSave:
Gui, 2:+OwnDialogs
Gui, 2:Submit, Nohide
GuiControl, Disable, btn_EC_save
GuiControl, Disable, btn_EC_cancel
GuiControl, Disable, btn_EC_savebak
GuiControl, Disable, btn_EC_loadbak
GuiControl, Hide, err_txtEC
GuiControl, Hide, err_txt2EC
GuiControl, Hide, err_txt3EC
GuiControl, Hide, err_txt4EC
If (v_scEC <> s_sc) 
{ ;Short command for the script's main executable changed
	err = 0
	StringSplit, v_sc_check, v_scEC
	Loop, %v_sc_check0%
	{
		If v_sc_check%a_index% is not digit 
		{
			If v_sc_check%a_index% is not alpha	
			{
				err = 1
				break
			}	
		}	
	}
	If err = 1 
	{
		MsgBox, 64, %s_name%: Error, The %s_name% short command can only contain numbers and letters.
		GuiControl, Hide0, err_txt2EC
		GuiControl, Enable, btn_EC_save
		GuiControl, Enable, btn_EC_cancel
		return
	}
	IfExist, %s_sc_dir%\%v_scEC%.lnk
	{
		MsgBox, 64, %s_name%: Error, This short command already exists! Please choose another one!
		return
	}
	FileDelete, %s_sc_dir%\%s_sc%.lnk
	FileCreateShortCut, %s_sc_dir%\%s_exec%, %s_sc_dir%\%v_scEC%.lnk
	RegWrite, REG_SZ, HKCU, Software\%s_name%, ShortCommand, %v_scEC% ;REGISTRY!
	s_sc := v_scEC
}
If (s_sc_dir <> v_sc_dirEC) 
{ ;Script's main directory changed
	IfNotExist, %v_sc_dirEC%
	{
		MsgBox, 64, %s_name%: Error, The specified directory does not exist!
		GuiControl, Hide0, err_txt2EC
		GuiControl, Enable, btn_EC_save
		GuiControl, Enable, btn_EC_cancel
		return
	}	
	MsgBox, 68, %s_name%: Change short command directory, If you continue, all short commands and your %s_name% executable will be moved to the specified directory.`nAre you sure you want to continue?
	IfMsgBox, No
	{
		GuiControl, Enable, btn_EC_save
		GuiControl, Enable, btn_EC_cancel
		return
	}
	Loop, %s_sc_dir%\*.%s_ext%
	{
		If (a_loopfileext <> s_ext)
			Continue
		StringTrimRight, c_sc, a_loopfilename, StrLen(a_loopfileext) + 1
		FileMove, %s_sc_dir%\%c_sc%.lnk, %v_sc_dirEC%
		FileMove, %a_loopfilelongpath%, %v_sc_dirEC%
	}
	FileMove, %s_sc_dir%\%s_exec%, %v_sc_dirEC%
	FileMove, %s_sc_dir%\%s_sc%.lnk, %v_sc_dirEC%
	RegWrite, REG_SZ, HKCU, Software\%s_name%, ShortCutDir, %v_sc_dirEC% ;REGISTRY!
	RegRead, c_path_check, HKCU, Environment, PATH ;REGISTRY!
	If InStr(c_path_check, s_sc_dir)
		StringReplace, c_path_check, c_path_check, %s_sc_dir%, %v_sc_dirEC%
	Else 
	{
		StringRight, c_l, c_path_check, 1
		If (c_l <> "`;")
			c_path_check .= "`;" . vs_sc_dir
		Else
			c_path_check .= vs_sc_dir
	}	
	RegWrite, REG_SZ, HKCU, Environment, PATH, %c_path_check% ;REGISTRY!
	EnvUpdate 
	s_sc_dir := v_sc_dirEC
}	
GuiControl, Enable, btn_EC_save
GuiControl, Enable, btn_EC_cancel
GuiControl, Enable, btn_EC_savebak
GuiControl, Enable, btn_EC_loadbak
GuiControl, Hide0, err_txtEC
return
;//END of EDIT CONFIGURATION

;//FUNCTIONS
refreshList(d_prev_lw=1) {
	global
	If d_prev_lw = 1 
	{
		LV_Delete()
		IL_Destroy(IconList)
		Iconlist := IL_Create(10)
		LV_SetImageList(IconList)
	}	
	Loop, %s_sc_dir%\*.%s_ext%, 1
	{
		IniRead, c_type, %A_LoopFileLongPath%, Short Command, type
		IniRead, c_name, %A_LoopFileLongPath%, Short Command, name
		IniRead, c_dest, %a_loopfilelongpath%, Short Command, destination
		StringSplit, c_sc, a_loopfilelongpath, \
		c_sc := c_sc%c_sc0%
		StringTrimRight, c_sc, c_sc, %s_ext_len%
		If c_type = url
			Il_Add(IconList, "shell32.dll", 15) ;on Windows XP/Vista
		Else if c_type = file 
		{
			StringSplit, c_ext, c_dest, \
			c_ext := c_ext%c_ext0%
			StringSplit, c_ext, c_ext, .
			c_ext_nr := c_ext0, c_ext := c_ext%c_ext0%
			If  !Il_Add(Iconlist, c_dest, 1) 
			{
				If c_ext_nr <= 1
					Il_Add(IconList, "shell32.dll", 1) ;on Windows XP/Vista	
				Else 
				{
					hIcon := DllCall("Shell32\ExtractAssociatedIconA", UInt, 0, Str, c_dest, UShortP, iIndex)
					DllCall("ImageList_ReplaceIcon", UInt, IconList, Int, -1, UInt, hIcon)
					DllCall("DestroyIcon", Uint, hIcon)			
				}
			}	
		} Else {
			hIcon := DllCall("Shell32\ExtractAssociatedIconA", UInt, 0, Str, c_dest, UShortP, iIndex)
			DllCall("ImageList_ReplaceIcon", UInt, IconList, Int, -1, UInt, hIcon)
			DllCall("DestroyIcon", Uint, hIcon)
		}	
		If (!c_type || c_type="ERROR" || !c_name || c_name="ERROR" || !c_dest || c_dest="ERROR" || InStr(c_dest, "shell32.dll"))
			Continue
		LV_Add("Icon" . a_index, c_sc, c_name, c_dest, c_type)
		If (StrLen(c_sc) < 1 && StrLen(c_name) < 6 && StrLen(c_dest) < 11)
			align_hdr = 1
		Else
			align_hdr = 0
	}	
	c_sc_total := LV_GetCount()
	If (c_sc_total <> 0 && align_hdr <> 1)
		Lv_ModifyCol()
	Else
		Lv_ModifyCol("Hdr")	
	Lv_ModifyCol(4, 0)
	Lv_Modify(1, "+Select")
}

install() {
	global
	IfNotExist, %vs_sc_dir%
		FileCreateDir, %vs_sc_dir%
	RegWrite, REG_SZ, HKCU, Software\%s_name%, ShortCutDir, %vs_sc_dir% ;REGISTRY!
	err1 := errorlevel
	RegRead, c_path_check, HKCU, Environment, PATH ;REGISTRY!
	err2 := errorlevel
	If !InStr(c_path_check, vs_sc_dir) 
	{
		StringRight, c_l, c_path_check, 1
		If (c_l <> "`;")
			c_path_check .= "`;" . vs_sc_dir
		Else
			c_path_check .= vs_sc_dir
		RegWrite, REG_SZ, HKCU, Environment, PATH, %c_path_check% ;REGISTRY!
		err3 := errorlevel
		EnvUpdate 
}
	if (a_scriptfullpath <> vs_sc_dir . "\" . a_scriptname)
	{
		FileCopy, %a_scriptfullpath%, %vs_sc_dir%, 1
		IfExist, %vs_sc_dir%\%a_scriptname%
			err4 = 0
		Else
			err4 := errorlevel
	}
	else
		err4 = 0
	FileCreateShortcut, %vs_sc_dir%\%a_scriptname%, %vs_sc_dir%\%vs_sc%.lnk 
	err5 := errorlevel
	FileCreateShortcut, %vs_sc_dir%\%a_scriptname%, %a_desktop%\%a_scriptname%.lnk
	RegWrite, REG_SZ, HKCU, Software\%s_name%, ExecutableName, %a_scriptname% ;REGISTRY!
	err6 := errorlevel
	RegWrite, REG_SZ, HKCU, Software\%s_name%, Configured, 1 ;REGISTRY!
	err7 := errorlevel
	RegWrite, REG_SZ, HKCU, Software\%s_name%, ShortCommand, %vs_sc% ;REGISTRY!
	err8 := errorlevel
	If (err1 || err2 || err3 || err4 || err5 || err6 || err7 || err8)
		return "Installation failed."
}	

uninstall(interact=0) {
	global
	If !s_sc_dir
		RegRead, s_sc_dir, HKCU, Software\%s_name%, ShortCutDir ;REGISTRY!
	RegRead, s_sc, HKCU, Software\%s_name%, ShortCommand ;REGISTRY!
	RegRead, s_exename, HKCU, Software\%s_name%, ExecutableName ;REGISTRY!
	RegDelete, HKCU, Software\%s_name% ;REGISTRY!
	RegRead, c_path_check, HKCU, Environment, PATH ;REGISTRY!
	If InStr(c_path_check, s_sc_dir) 
	{
		If InStr(c_path_check, s_sc_dir . "`;")
			StringReplace,c_path_check, c_path_check, %s_sc_dir%`;, 
		Else
			StringReplace,c_path_check, c_path_check, %s_sc_dir%, 
	}
	RegWrite, REG_SZ, HKCU, Environment, PATH, %c_path_check% ;REGISTRY!
	EnvUpdate 
	FileDelete, %s_sc_dir%\%s_sc%.lnk
	FileDelete, %a_desktop%\%s_exename%.lnk
	Loop, %s_sc_dir%\*.%s_ext%
	{
		If (a_loopfileext <> s_ext)
			Continue
		StringTrimRight, c_sc, a_loopfilename, StrLen(a_loopfileext) + 1
		FileDelete, %s_sc_dir%\%c_sc%.lnk
		FileDelete, %a_loopfilelongpath%
	}	
	If interact <> 0 
	{
		MsgBox, 68, %s_name%: Uninstallation, Would you like to remove the %s_name% executable?
		IfMsgBox, Yes
		{
			FileDelete, %s_sc_dir%\%s_name%.exe
			If a_scriptname <> %s_sc_dir%\%s_name%.exe
				FileDelete, %a_scriptfullpath%
		}	
		MsgBox, 64, %s_name%: Uninstallation successful!, %s_name% successfully removed all changes it made on your PC. Thanks for using it!
	}
}

;Thanks to:
;Rajat:
; - SmartGUI: http://www.autohotkey.com/forum/topic775.html
; - nDroid/320MPH: http://www.autohotkey.com/forum/topic3010.html - ExtractAssociatedIconA
;Sean:
; - Winapi autocomplete for edit controls: www.autohotkey.com/forum/viewtopic.php?p=121621#121621