/*
< WinCtrl >
 ScriptVersion := 0.9
 Script created using Autohotkey (http://www.autohotkey.com)
 AHK version: AHK_L
 Dependencies: 
 Ini.ahk (lib) by tuncay < http://www.autohotkey.com/forum/viewtopic.php?t=46226 >
 AUTHOR: Simon Strålberg, sumon @ the Autohotkey forums, < simon.stralberg (@) gmail.com>
 CHANGELOG:
 0.9
 Prompts now work (bug)
 Script exits when no item is selected (bug)
 Added menu icons
 Added header
 Added indicator to show prompts/default having values
  || To-do ||
 Add support for more syntax?
 Nicer look for GUI
*/
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance, Force
ClipBoardSaved := ClipBoardAll

Menu, Tray, Nostandard
Menu, Tray, Add, Paste, ShowMenu
Menu, Tray, Add, Manage pasties, Manage
Menu, Tray, Add, Change mode, ChangeMode
Menu, Tray, Add, Exit, ForceExit

If (!FileExist("data\license.txt"))
{
	Gui, 33:Default
	Gui, +owner
	gui, font, s10, Verdana  ; Set 10-point Verdana.
	Gui, Add, Text,, This is the first time you run Pastej `n`nExtract data to "/data" directory?
	Gui, Add, Button, x10 w125 h40 gGuiInstall default, Sure!
	Gui, Add, Button, x135 w125 yp h40 gGuiNoInstall, No thanks!
	Gui, -Caption +Border
	Gui, Color, ffFFff
	Gui, Show
	return
}
IfExist, data\PastejSettings.ini
{
	IniRead, AlwaysOn, data\PastejSettings.ini, General, AlwaysOn, 0
	If (AlwaysOn = 1)
	{
		Hotkey := "#v"
		IniRead, Hotkey, data\PastejSettings.ini, General, Hotkey, #v
		Hotkey, %Hotkey%, ShowMenu
		Traytip, Pastej:, Pastej is in "Always on" mode`nHotkey: %Hotkey%, 4
		ShowMenuDirectly := "No"
	}
}

DefineMenu: ; Return here after installing
OnExit, Exit
IfExist, data\ico\Pastej.ico
	Menu, Tray, Icon, data\ico\Pastej.ico
; #v:: ADD HOTKEY HERE! (If you want one)
ini_load(Pasties, "data\pasties.ini")
SectionNames := ini_getAllSectionNames(Pasties)
Sort, SectionNames, D`, ; Alphabetical order
Loop, Parse, SectionNames, `, ; Get all Pasties
{
	Menu, PasteMenu, Add, %A_LoopField%, Paste
		ini_read(Icon, Pasties, A_LoopField, "Icon", "data\ico\default.ico")
	IfExist, %icon%
		Menu, PasteMenu, Icon, %A_LoopField%, %icon%,, 32
	else
		Menu, PasteMenu, Icon, %A_LoopField%, data\ico\default.ico,, 32
}
Menu, PasteMenu, Add
Menu, PasteMenu, Add, Manage Pasties..., Manage
If (ShowMenuDirectly = "No")
{
	ShowMenuDirectly := Yes
	return
}
ShowMenu:
Menu, PasteMenu, Show

Sleep 500
If (InaSub)
	return
Gosub, Exit ; If no sub was pressed 
return

Paste:
; Pasties are in the format of [url=@ins@]@clip@[/url] where "@ins@" gets replaced by any Prompt input, and @clip@ by the Clipboard
Inasub := "True" ; To prevent exiting 
ini_read(Prompt, Pasties, A_ThisMenuItem, "Prompt", "")
If (Prompt)
{
	ini_read(PromptDefault, Pasties, A_ThisMenuItem, "Promptdefault", "")
	If (PromptDefault = "@clip@")
		PromptDefault := Clipboard
	InputBox, Input, Pastej:, %Prompt%,,300,140,,,,, %PromptDefault%
	If (Errorlevel)
		return
}
ini_read(String, Pasties, A_ThisMenuItem, "String", "")
StringReplace, String, String, @ins@, %Input%, All
StringReplace, String, String, @clip@, %Clipboard%, All
Clipboard := String
Send ^v

Sleep 200
Gosub, Exit
; Uncomment if you want to keep running (add a hotkey, too)
; ClipBoard := ClipBoardSaved
return

Manage: ; Guis should be in an #include file, probably

Inasub := "True" ; To prevent exiting 
Gui, Add, Picture, x20, data\ico\gui\header.jpg
Gui, Font
/*
Gui, Add, Text, x150 gGuiStringHelp, String (?)
Gui, Add, Text, yp x550 gGuiPromptHelp, Prompt (?)
*/
SectionNames := ini_getAllSectionNames(Pasties)
Sort, SectionNames, D`, ; Alphabetical order
Loop, Parse, SectionNames, `, ; List pasties
{
	Section := variableSafe(A_LoopField)
	ini_read(Icon, Pasties, A_LoopField, "Icon", "data\ico\default.ico")
	IfExist, %icon%
		Gui, Add, Picture, x10 w32 h32 gGuiChangeIcon vIcon_%Section%, %icon%
	else
		Gui, Add, Picture, x10 w32 h32 gGuiChangeIcon vIcon_%Section%, data\ico\default.ico
	
	Gui, Add, Text, yp+10 x50 w85 gGuiChangeName v%Section%, %A_LoopField%
		
	Gui, Add, Picture, yp x132 w16 h16 gGuiRemovePastie vRemove_%Section%, data\ico\gui\remove.ico
	
	ini_read(String, Pasties, A_LoopField, "String", "")
	ini_read(Prompt, Pasties, A_LoopField, "Prompt", "")
	ini_read(PromptDefault, Pasties, A_LoopField, "PromptDefault", "")
	Gui, Add, Edit, yp-2 x150 w400 vString_%Section%, %String%
	Gui, Add, Picture, yp+2 x560 vPrompt_%Section% gGuiChangePrompt, data\ico\gui\prompt.ico
	Gui, Add, Picture, yp x580 vPromptDefault_%Section% gGuiChangePromptDefault, data\ico\gui\promptdefault.ico
	If (Prompt)
		GuiControl,, Prompt_%Section%, data\ico\gui\prompt_sel.ico
	If (PromptDefault)
		GuiControl,, PromptDefault_%Section%, data\ico\gui\promptdefault_sel.ico
	; Default values
	Icon_%Section% := (FileExist(Icon) ? Icon : "data\ico\default.ico")
	String_%Section% := String
	Prompt_%Section% := Prompt
	PromptDefault_%Section% := PromptDefault
}
Gui, Font, s12 w700, Verdana
Gui, Add, Button, x10 h40 w90 gGuiAddPastie, &Add
Gui, Add, Button, yp x105 h40 w40 gGuiInfo, &i
Gui, Add, Button, yp x150 h40 w400 gGuiSubmit, &Save && close
Gui, Add, Button, yp x555 h40 w50 gGuiHelp, ?
Gui, Show,, Pastej
return

GuiAddPastie:
Gui, Submit, Nohide
Gosub, GuiSubmitNohide
InputBox, SectionName, New pastie:, New pastie name,,300,100,,,,, My pastie
If Errorlevel
	return
If (SectionName = "")
{
	MsgBox, 48, Error: No name, You must give your pastie a name!
	return
}
AllSections := ini_getAllSectionNames(Pasties)
If (InStr(AllSections, SectionName))
{
	MsgBox, 48, Error: Duplicate, Pastie exists! You must use a unique name!
	return
}
ini_insertSection(Pasties, SectionName, "`r`nIcon=`r`nPrompt=`r`nPromptDefault=`r`nString=`r`n")
Gui, Destroy
Gosub, Manage
return

GuiSubmit: ; Submit, then gosub
Gui, Submit
GuiSubmitNoHide: 
Loop, Parse, SectionNames, `, ; List pasties
{
	Section := variableSafe(A_LoopField)	
	Icon := Icon_%Section%
	String := String_%Section%
	Prompt := Prompt_%Section%
	PromptDefault := PromptDefault_%Section%
	If (InStr(Icon, A_ScriptDir)) ; Add support for directory-relative icons
	{
		Dirlen := StrLen(A_ScriptDir)+1 ; +1 to remove preceding slash \
		StringTrimLeft, Icon, Icon, %DirLen%
	}
	PastieName := variableUnsafe(Section)
	ini_replaceValue(Pasties, PastieName, "Icon", Icon)
	ini_replaceValue(Pasties, PastieName, "String", String)
	if (Prompt)
		ini_replaceValue(Pasties, PastieName, "Prompt", Prompt)
	if (PromptDefault)
		ini_replaceValue(Pasties, PastieName, "PromptDefault", PromptDefault)
}
ini_save(Pasties, "data\pasties.ini")
return

GuiRemovePastie:
StringTrimLeft, Section, A_GuiControl, 7
Section := VariableUnsafe(Section)
MsgBox, 52, Delete pastie?, Are you sure you want to delete %Section% permanently?
IfMsgBox, No
{
	variableSafe(Section)
	return
}
Ini_Delete(Pasties, Section, "String")
Ini_Delete(Pasties, Section)
Section := VariableSafe(Section)
GuiControl, Disable, Icon_%Section%
GuiControl, Disable, %Section%
GuiControl, Disable, Remove_%Section%
GuiControl, Disable, String_%Section%
GuiControl, Disable, Prompt_%Section%
GuiControl, Disable, PromptDefault_%Section%
/*
Icon_%Section% := 
%Section% := 
Remove_%Section% :=
String_%Section% :=
Prompt_%Section% :=
PromptDefault_%Section% :=
*/
return

GuiChangeIcon:
FileSelectFile, NewIcon, S, data\ico, Select icon..., *.ico
If Errorlevel
	return
StringTrimLeft, PastieName, A_GuiControl, 5 ; Get Pastiename (varsafe)
PastieName := VariableSafe(PastieName)
GuiControl,, %A_GuiControl%, %NewIcon%
Icon_%PastieName% := NewIcon
return

GuiChangeName:
InputBox, NewName, Pastie name:, Change Pastie name,,300,100,,,,, %A_GuiControl%
If Errorlevel
	return
GuiControl,, %A_GuiControl%, %NewName%
;~ ini_write(Icon, Pasties, A_GuiControl, "Icon")
return

GuiChangePrompt:
StringTrimLeft, PastieName, A_GuiControl, 7 ; Gets the Pastiename
PastieName := VariableUnsafe(PastieName)
ini_read(Prompt, Pasties, PastieName, "Prompt", "")
InputBox, NewPrompt, Prompt:, Enter pastie prompt,,300,100,,,,, %Prompt%
If Errorlevel
	return
ini_replaceValue(Pasties, PastieName, "Prompt", NewPrompt)
Section := VariableSafe(PastieName)
Prompt_%Section% := NewPrompt ; Set the GUI value
GuiControl,, Prompt_%Section%, % (NewPrompt ? "data\ico\gui\prompt_sel.ico" : "data\ico\gui\prompt.ico")
return

GuiChangePromptDefault: 
StringTrimLeft, PastieName, A_GuiControl, 14 ; Gets the Pastiename
PastieName := VariableUnsafe(PastieName)
ini_read(PromptDefault, Pasties, PastieName, "Promptdefault", "")
InputBox, NewPromptDefault, Prompt default:, Enter prompt default value,,300,100,,,,, %PromptDefault%
If Errorlevel
	return
ini_replaceValue(Pasties, PastieName, "PromptDefault", NewPromptDefault)
Section := VariableSafe(PastieName)
PromptDefault_%Section% := NewPromptDefault ; Set the GUI value
GuiControl,, PromptDefault_%Section%, % (NewPromptDefault ? "data\ico\gui\promptdefault_sel.ico" : "data\ico\gui\promptdefault.ico")
return

GuiInfo:
;~ TrayTip, Help:, Pastej (TM) was made by Simon Strålberg 2011.`nIt lets you paste your clipboard in set formats`, to speed up everyday tasks. You can freely define your own pasties using the builtin tool and format., 20
MsgBox, 64, Pastej Help, Pastej (TM) was made by Simon Strålberg in 2011.`n`nIt lets you paste your clipboard more richly`, to speed up everyday tasks. You can freely define your own pasties using the builtin tool.
return

GuiHelp:
;~ TrayTip, Help, String: How your pastie will be pasted.`n@clip@ will be replaced by clipboard`,`n@ins@ by any insertion from the optional prompt window.`n`nPrompt: A text asking you for input.`nDefault: Default prompt input, 10
MsgBox, 32, Help, String: How your pastie will be pasted.`n@clip@ will be replaced by clipboard`,`n@ins@ by any insertion from the optional prompt window.`n`nPrompt: A text asking to give input.`nDefault: Default prompt input.
return

GuiInstall:
Gui, Destroy
Progress, M,, Pastej is extracting data, Extracting..., Verdana
FileCreateDir, data
FileCreateDir, data\ico
FileCreateDir, data\ico\gui
FileInstall, data\ico\attachment.ico, data\ico\attachment.ico
Progress, 10
FileInstall, data\ico\attention.ico, data\ico\attention.ico
FileInstall, data\ico\code.ico, data\ico\code.ico
Progress, 20
FileInstall, data\ico\colors.ico, data\ico\colors.ico
FileInstall, data\ico\date.ico, data\ico\date.ico
Progress, 30
FileInstall, data\ico\default.ico, data\ico\default.ico
FileInstall, data\ico\document.ico, data\ico\document.ico
FileInstall, data\ico\google.ico, data\ico\google.ico
FileInstall, data\ico\help.ico, data\ico\help.ico
FileInstall, data\ico\help_green.ico, data\ico\help_green.ico
FileInstall, data\ico\html.ico, data\ico\html.ico
Progress, 40
FileInstall, data\ico\img.ico, data\ico\img.ico
FileInstall, data\ico\letter_a.ico, data\ico\letter_a.ico
FileInstall, data\ico\message_out.ico, data\ico\message_out.ico
FileInstall, data\ico\message_star.ico, data\ico\message_star.ico
FileInstall, data\ico\movie.ico, data\ico\movie.ico
Progress, 50
FileInstall, data\ico\Pastej.ico, data\ico\Pastej.ico
FileInstall, data\ico\path.ico, data\ico\path.ico
FileInstall, data\ico\picture.ico, data\ico\picture.ico
FileInstall, data\ico\script.ico, data\ico\script.ico
FileInstall, data\ico\star.ico, data\ico\star.ico
FileInstall, data\ico\star_blue.ico, data\ico\star_blue.ico
Progress, 60
FileInstall, data\ico\std.ico, data\ico\std.ico
FileInstall, data\ico\text.ico, data\ico\text.ico
FileInstall, data\ico\text2.ico, data\ico\text2.ico
Progress, 70
FileInstall, data\ico\time.ico, data\ico\time.ico
FileInstall, data\ico\url.ico, data\ico\url.ico
Progress, 80
FileInstall, data\ico\url2.ico, data\ico\url2.ico
FileInstall, data\ico\web.ico, data\ico\web.ico
Progress, 90
FileInstall, data\ico\web_search.ico, data\ico\web_search.ico
FileInstall, data\ico\icons_from.txt, data\ico\icons_from.txt
; Gui imgs
FileInstall, data\ico\gui\header.jpg, data\ico\gui\header.jpg
FileInstall, data\ico\gui\prompt.ico, data\ico\gui\prompt.ico
FileInstall, data\ico\gui\prompt_sel.ico, data\ico\gui\prompt_sel.ico
FileInstall, data\ico\gui\promptdefault.ico, data\ico\gui\promptdefault.ico
FileInstall, data\ico\gui\promptdefault_sel.ico, data\ico\gui\promptdefault_sel.ico
FileInstall, data\ico\gui\remove.ico, data\ico\gui\remove.ico
; Non-icon files
FileInstall, data\license.txt, data\license.txt
FileInstall, data\pasties.ini, data\pasties.ini
IfExist, data\PastejSettings.ini
	FileInstall, data\PastejSettings.ini, data\PastejSettings.ini
Progress, Off
Traytip, Pastej:, Finished!, 4
Gosub, DefineMenu
return

ChangeMode: 
Gui, Destroy
IniRead, AlwaysOn, data\PastejSettings.ini, General, AlwaysOn, 0
IniRead, Hotkey, data\PastejSettings.ini, General, Hotkey, #v
Gui, Add, Checkbox, Checked%AlwaysOn% vAlwaysOn, Always on?
Gui, Add, Text,, Hotkey:
Gui, Add, Hotkey, vHotkey, %Hotkey%
Gui, Add, Button, gChangeModeSave, Save changes
Gui, Show
return

ChangeModeSave: 
Gui, Submit
IniWrite, %AlwaysOn%, data\PastejSettings.ini, General, AlwaysOn
IniWrite, %Hotkey%, data\PastejSettings, General, Hotkey
Traytip, Saved!, AlwaysOn: %AlwaysOn%`nHotkey: %Hotkey%, 4
return

GuiNoInstall:
MsgBox, 48, Pastej cannot launch, Pastej cannot launch without its' required files. Please restart Pastej and extract the files if you wish to continue.
GuiClose:
Gui, Destroy
Gosub, Exit
~Esc::
Exit:
ClipBoard := ClipBoardSaved
IfExist, data\PastejSettings.ini
{
	IniRead, AlwaysOn, data\PastejSettings.ini, General, AlwaysOn, 0
	If (ForceExit = 1)
		ExitApp
	If (AlwaysOn = 1)
		return
}
ExitApp

ForceExit:
ForceExit = 1
Gosub, Exit

variableSafe(String)
{
	StringReplace, String, String, %A_Space%, _, All
	return String
}

variableUnsafe(String)
{
	StringReplace, String, String, _, %A_Space%, All
	return String
}