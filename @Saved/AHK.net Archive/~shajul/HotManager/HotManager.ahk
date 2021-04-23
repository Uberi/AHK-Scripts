; Sript to Manage Hotkeys and Hotstrings ahk file
; Author: Shajul
; 
#SingleInstance force
#NoTrayIcon
;; TO DO

if 0>0
  Hotkeyfile = %1%
else
{
  IfExist,MyHotKeys.ahk
	Hotkeyfile = MyHotKeys.ahk
  else
  {
	  MsgBox, 35, HotManager, No script file specified.`n`nTo select your script file`, click YES`nTo create a new script file`, click NO
	  IfMsgBox, Yes
		{
		FileSelectFile,Hotkeyfile,,%A_ScriptDir%,Kindly select script file to manage..,Autohotkey scripts (*.ahk)
		If Errorlevel
			ExitApp
		}
	  Else IfMsgBox, No
		{
		URLDownloadToFile,http://www.autohotkey.net/~shajul/bin/MyHotKeys.ahk,MyHotKeys.ahk
		If !Errorlevel
			Hotkeyfile = MyHotKeys.ahk
		Else
		  {
			MsgBox, 48, Failed!, Download failed! Please try again later.
			ExitApp
		  }
		}
	  Else
		ExitApp  
  }
}
myObject := Object()
gosub CreateGUI									;Create GUI of main window

GuiControl, -Redraw, MyLV
gosub KeyList
LV_ModifyCol(1, 80)
LV_ModifyCol(2, 200)
LV_ModifyCol(3, 200)
LV_ModifyCol(4, 30)
GuiControl, +Redraw, MyLV

Gui, Font, s8 cNavy Bold, Verdana  ; Setting new font
GuiControl, Font, MList
GuiControl, , MList, %MList%				    ;  populate Hotkeyz list
MList=

Gui, Show, center h400 w780,  Hotkeyz - Shajul
Return

MyHelp:
MsgBox, 64,Hotkeyz v1.2, Hotkeyz Help`nZZZZZZZZZZZ`nAutoHotkey unleashes the full potential of your keyboard
		, joystick, and mouse. For example, in addition to the typical Control, Alt
		, and Shift modifiers, you can use the Windows key and the Capslock key as modifiers
		. `nIn fact, you can make any key or mouse button act as a modifier.`n`n- Automate almost anything by sending keystrokes and mouse clicks. `n- You can write macros by hand or use the macro recorder.`n- Remap keys and buttons on your keyboard, joystick, and mouse.
return

MyAbout:
MsgBox,64,About Hotkeyz!,Hotkeyz v1.2`n`n`nHotkeys GUI and functionality scripts!              `n`n`n(c) Shajul, 2005`ndr_shajul@rediffmail.com
return


;- - - - - - - - - - - - - - - - - - MAIN GUI - - - - - - - - - - - - - - - - - 
CreateGUI:
Gui, Add, ListView, x380 y0 r100 w400 h400 vMyLV gMyLV, Hotkey|Description|Code|ID
Gui, Add, Button, x5 y370 w70 h23 gButtonEdit, &Edit Script
Gui, Add, Button, x75 y370 w70 h23 gGuiClose, &Close
Gui, Add, GroupBox, x2 y25 w375 h340, Add..

;FIRST TAB CONTROL
Gui, Add, Tab2, x2 y2 h20 w160 Buttons vTab1 AltSubmit,Add Hotkey|Add Hotstring

;Add Hotkey
Gui, Add, Text, x10 y274 h19 , Hotkeys:
Gui, Add, Hotkey, x+5 y274 w164 h21 vMyHot, 
Gui, Add, Checkbox, x+5 y276 w100 h20 vWinKy Checked, Add &WIN Key
Gui, Add, Button, x100 y335 w100 h23 gAddHotkey, &Add Hotkey

;Add Hotstring
Gui, Tab, 2
Gui, Add, Text, x10 y274 h19 , Hotstring:
Gui, Add, Edit, x+5 y274 w164 h21 vMyHotstring, 
Gui, Add, Checkbox, x+5 y276 h20 vAutocorrect Checked, &Autocorrect mode
Gui, Add, Button, x100 y335 w100 h23 gAddHotstring, &Add HotString

Gui, Tab	;End of first tab control

;SECOND TAB CONTROL
Gui, Add, Tab2, x170 y2 w200 h20 buttons vTab2 AltSubmit,Application/File|Code/AutoCorrect

;Run file/application
Gui, Add, Text, x10 y40 w190 h17 , Hotkey for file/application:
Gui, Add, Edit, x10 y56 w240 h21 vEdt, 
Gui, Add, Button, x250 y56 w25 h23 , ...

Gui, Add, Text, x10 y90 w160 h19 , Working Directory:
Gui, Add, Edit, x10 y107 w255 h21 vWrk, 
Gui, Add, Checkbox, x147 y90 w122 h16 vUseWrk, Use Work &Directory
Gui, Add, Text, x270 y90 h18 , Start Mode:
Gui, Add, DropDownList, x270 y107 w100 h21 r4 vMdChoice Choose1, |Max|Min|Hide

;Run Code
Gui, Tab, 2
Gui, Add, Text, x10 y40 h17 , Run code/Autocorrect (only for hotstrings):
Gui, Add, Edit, x10 y56 w360 h205 vEdtCode,

Gui, Tab	;End of second tab control

Gui, Add, Text, x10 y305 h18 , Description:
Gui, Add, Edit, x+5 y305 w271 h20 vDesc, 
Gui, Add, Button, x200 y335 w66 h23 , &Reset
; Generated using SmartGUI Creator 4.0

;Menu, Standard, Standard
Menu, MyFile, add, &Edit Script, ButtonEdit
Menu, MyFile, add
Menu, MyFile, add, &Close	Alt+F4, guiclose
Menu, MyHlp, add, Hotkeyz Help, MyHelp
Menu, MyHlp, add, &About, MyAbout
Menu, MyMain, add, &File, :MyFile
;Menu, MyMain, add, &Default, :Standard
Menu, MyMain, add, &Help, :MyHlp
Gui, Menu, MyMain
return


;- - - - - - - - - - - - - - - - - - TAB HOTKEYZ - - - - - - - - - - - - - - - - - - 
Button...:
FileSelectFile, HotFile, 3, C:\Program Files, Select file to assign hotkey, All Files (*.*)
SplitPath,HotFile,,MyODir,,MyDesc,  ;SPLIT PATH, ASSIGN VALUES TO EDIT CONTROLS
GuiControl,, Edt,%HotFile%
GuiControl,, Wrk,%MyODir%
GuiControl,, Desc,%MyDesc%
Return

ButtonEdit:
Run, edit %Hotkeyfile%
Gui, Hide
return

MyLV:
hotstring=
ChHot=
if A_GuiEvent != DoubleClick
	return
myln := A_EventInfo
LV_GetText(MDesc,myln,2)
IfInString, MDesc, -------------------------  ;it is a comment
	return
LV_GetText(CurHot,myln)
LV_GetText(tvar3,myln,3)
LV_GetText(tvar4,myln,4)
Gui, 3:Add, Text, x110 w241 h20 vCurHot, %CurHot%
Gui, 3:Add, Text, x6 y25 w100 h15,Description:
Gui, 3:Add, Edit, vMDesc x+3 y25 w180 h25, %MDesc%
Gui, 3:Add, Edit, vMEdit x6 y56 w365 h150, 
Gui, 3:Add, CheckBox,gChHot x6 y211 h15 w100,Change Hotkey:
if (InStr(tvar3,":")=1) ;it is a hotstring
{
	hotstring=1
	Gui, 3:Add, Text, x6 y5 h15 w100,Current Hotstring:
	Gui, 3:Add, Edit, vMEdHot x180 y211 w180 h25 Disabled
	if (InStr(tvar3,"*")=2)
		StringTrimLeft,tvar3,tvar3,3  ;it is a :*: hotstring
	else
		StringTrimLeft,tvar3,tvar3,2		
}
else
{
	Gui, 3:Add, Text, x6 y5 h15 w100,Current Hotkey:
	Gui, 3:Add, Hotkey, vMEdHot x+3 y211 w180 h25 Disabled
	Gui, 3:Add, CheckBox, vAddWnKy3 x+3 y211 h15 Checked Disabled,Add WIN Key
}
StringReplace, tvar3, tvar3,`:`:,|
StringSplit, tvar, tvar3, |
GuiControl,3:,MEdit,%tvar2%						;tvar1 is hotkey, tvar2 is cmd, 
oldhotk=%tvar1%
Gui, 3:Add, Button, x5 y240 w70 h25 gSaveEdit, &Ok
Gui, 3:Add, Button, x+5 w70 h25 g3GuiClose, &Cancel
Gui, 3:Add, Button, x270 y240 w100 h25 gDeleteItem, &Delete Selected
Gui, 3:Show, Center h270 w377, Edit Hotkey/Hotstring!
return

3GuiClose:
Gui, 3:Destroy
return

SaveEdit:
Gui, 3:Submit, Nohide
Autotrim on
StringSplit, tvar, MEdit, `n					; split at all carraige return
StringReplace,tvar, tvar%tvar0%, %A_Space%,,All		; trim spaces if any
IfInString, tvar, return
   {
	StringReplace,tvar, tvar1, %A_Space%,,All		; trim spaces if any
   	if tvar										; if it contains anything,
		MEdit = `n%MEdit%							; add a carraige return
   }

Gui,1:Default  ;Otherwise listview will fail
if hotstring
{
	If MEdHot
		{
		LV_Modify(myln,"",MEdHot,MDesc,"`:`:" . MEdHot . "`:`:" . MEdit)
		myObject[tvar4,"cmd"] := "`:`:" . MEdHot . "`:`:" . MEdit
		myObject[tvar4,"desc"] := MDesc
		}
	Else
		{
		LV_Modify(myln,"Col2",MDesc,"`:`:" . oldhotk . "`:`:" . MEdit)
		myObject[tvar4,"cmd"] := "`:`:" . oldhotk . "`:`:" . MEdit
		myObject[tvar4,"desc"] := MDesc
		}
}
else
{
	If MEdHot
		{
		If AddWnKy3
		MEdHot=`#%MEdHot%
		StringReplace,NewHot,MEdHot,#,Win- 
		StringReplace,NewHot,NewHot,!,Alt- 
		StringReplace,NewHot,NewHot,^,Ctrl- 
		StringReplace,NewHot,NewHot,+,Shft- 
		LV_Modify(myln,"",NewHot,MDesc,MEdHot . "`:`:" . MEdit)
		myObject[tvar4,"cmd"] := MEdHot . "`:`:" . MEdit
		myObject[tvar4,"desc"] := MDesc
		}
	Else
		{
		LV_Modify(myln,"Col2",MDesc,oldhotk . "`:`:" . MEdit)
		myObject[tvar4,"cmd"] := oldhotk . "`:`:" . MEdit
		myObject[tvar4,"desc"] := MDesc
		}
}
Gui,3:Destroy
m_change_flag=1
gosub SaveAs
return

DeleteItem:
Gui, 3:Submit, Nohide
Autotrim on
Gui,1:Default  ;Otherwise listview will fail
myObject[tvar4,"cmd"] := ""
myObject[tvar4,"desc"] := ""
LV_Delete(myln)
Gui,3:Destroy
m_change_flag=1
gosub SaveAs
return

SaveAs:
Loop,2
{
	tvar := 3 - A_Index
	tvar1 := tvar + 1
	FileMove,%Hotkeyfile%.bak%tvar%,%Hotkeyfile%.bak%tvar1%,1
}
FileMove,%Hotkeyfile%,%Hotkeyfile%.bak1,1 ;Backup

Loop % myObject.MaxIndex()
{
    ODesc := myObject[A_Index,"desc"]
    OCmd := myObject[A_Index,"cmd"]
	if (!OCmd AND !ODesc)
		continue
	if !ODesc
		OData = %OCmd%
	else if !OCmd  ;It is a comment line
		OData=`;`;%ODesc%	
	else
	{
		IfInString, OCmd, `n ;multi-line command block
		{
			Loop,Parse,OCmd,`n
			{
				if A_Index=1
					OData = %A_LoopField%%A_Space%`;%ODesc%`n	;add the description to the first line
				else
					OData .= A_LoopField . "`n" 
			}
		}
		else
			OData = %OCmd%%A_Space%`;%ODesc%
	}
	
	FileAppend,%OData%`n,%Hotkeyfile%
	OData=
}
return

ChHot:
chHot := chHot ? 0:1
GuiControl,3:Enable%chHot%,MEdHot
GuiControl,3:Enable%chHot%,AddWnKy3
GuiControl,,MEdHot,
return


ButtonReset:
GuiControl,, Edt,
GuiControl,, Wrk,
GuiControl,, Desc,
GuiControl,Choose, MdChoice,1
GuiControl,, MyHot,
return

guiclose:
ExitApp
return

AddHotkey:
gui, submit, nohide
if !MyHot  ;CHECK IF HOTKEY IS NOT ASSIGNED
	Gosub Upd
descf := Desc ? ";" . Desc:""  ; IF NO DESCRIPTION, DONT ADD IT
WinKy := WinKy=1 ? "#":""  ; CHECK IF WINDOWS KEY REQUIRED
if Tab2=1
{
	If !Edt
		Gosub Upd
	if UseWrk!=1 ; CHECK IF WORKING DIRECTORY REQUIRED
		Wrk=
	clipd=%WinKy%%MyHot%`:`:Run %Edt%,%Wrk%,%MdChoice%,%A_Space% %descf%
}
else
{
	If !EdtCode
		Gosub Upd
	IfNotInString,EdtCode,return
		EdtCode = %EdtCode%`nreturn
	clipd=%WinKy%%MyHot%`:`:%A_Space% %descf%`n%EdtCode%
}
FileAppend,`n%clipd%, %Hotkeyfile%
gosub ParseCode
Run %Hotkeyfile%
MsgBox,64,HotKeyz, Congratulations, New hotkey added!
return



AddHotstring:
gui, submit, nohide
if !MyHotstring  ;CHECK IF HOTKEY IS NOT ASSIGNED
	Gosub Upd
descf := Desc ? ";" . Desc:""  ; IF NO DESCRIPTION, DONT ADD IT
if Tab2=1
{
	If !Edt
		Gosub Upd
	if UseWrk!=1 ; CHECK IF WORKING DIRECTORY REQUIRED
		Wrk=
	clipd=`:`:%MyHotstring%`:`: %A_Space% %descf%`nRun %Edt%,%Wrk%,%MdChoice%`nreturn
}
else
{
	If !EdtCode
		Gosub Upd
	If !AutoCorrect
	{
		IfNotInString,EdtCode,return
			EdtCode = %EdtCode%`nreturn
		clipd=`:`:%MyHotstring%`:`:%A_Space% %descf%`n%EdtCode%
	}
	else
		clipd=`:`:%MyHotstring%`:`:%EdtCode%%A_Space% %descf%
}
FileAppend,`n%clipd%, %Hotkeyfile%
gosub ParseCode
Run %Hotkeyfile%
MsgBox,64,HotKeyz, Congratulations, New hotstring added!
return

Upd:
  MsgBox,48,Invalid Hotkey/Hotstring/File, No Hotkey/Botstring and/or run command assigned.`n`nAssign a Run Command or browse for a file/program`nPress any combination of CTRL, SHIFT, ALT, KEY to use as hotkey or select a hotstring!
Exit
return



KeyList: 
my_i=1
Loop,Read,%Hotkeyfile%
{
	if getmore
		{
		 StringReplace, tvar, A_LoopReadLine,%A_Tab%,,All
		 if CheckLine(A_LoopReadLine)                      ;i.e., it is not a hotkey/hotstring
		  {
		 Cmd=%Cmd%`n%tvar%
		 continue
		  }
		getmore=
		LV_Add("",Keys,Desc,Cmd,my_i)
		myobject[my_i,"cmd"] := Cmd
		myobject[my_i,"desc"] := Desc
		my_i++
		}
	if getmorejunk
		{
		 StringReplace, tvar, A_LoopReadLine,%A_Tab%,,All
		 if CheckLine(A_LoopReadLine)                      ;i.e., it is not a hotkey/hotstring
		  {
		 Cmd1=%Cmd1%`n%tvar%
		 continue
		  }
		getmorejunk=
		myobject[my_i,"cmd"] := Cmd1
		myobject[my_i,"desc"] := ""
		my_i++
		}	
	Cmd := ParseHotLine(A_LoopReadLine)
	if !Cmd
		{
		getmorejunk=1
		Cmd1:=A_LoopReadLine
		continue
		}
	if Cmd=comment
		{
		LV_Add("",Keys,Desc,Cmd,my_i)
		myobject[my_i,"cmd"] := ""
		myobject[my_i,"desc"] := Desc
		my_i++
		Continue 
		}
	StringSplit RCmd,Cmd,`:,%A_Space%%A_Tab%
	if (RCmd0>2 and RCmd3 != "")
		{
		LV_Add("",Keys,Desc,Cmd,my_i)
		myobject[my_i,"cmd"] := Cmd
		myobject[my_i,"desc"] := Desc
		my_i++
		}
	else
		getmore=1
} 
if getmore
{
	getmore=
	LV_Add("",Keys,Desc,Cmd,my_i)
	myobject[my_i,"cmd"] := Cmd
	myobject[my_i,"desc"] := Desc
	my_i++
}
if getmorejunk
{
	getmorejunk=
	myobject[my_i,"cmd"] := Cmd1
	myobject[my_i,"desc"] := ""
	my_i++
}	
return

ParseCode: 
  Loop,Parse,clipd,`n
  {
	if getmore=1
		{
		 StringReplace, tvar, A_LoopField,%A_Tab%,,All
		 if CheckLine(A_LoopField)                      ;i.e., it is not a hotkey/hotstring
		  {
  		 Cmd=%Cmd%`n%tvar%
  		 continue
		  }
	    getmore=
	    LV_Add("",Keys,Desc,Cmd,my_i)
	    myobject[my_i,"cmd"] := Cmd
		myobject[my_i,"desc"] := Desc
		my_i++
		}
	if getmorejunk=1
		{
		 StringReplace, tvar, A_LoopField,%A_Tab%,,All
		 if CheckLine(A_LoopField)                      ;i.e., it is not a hotkey/hotstring
		  {
  		 Cmd1=%Cmd1%`n%tvar%
  		 continue
		  }
	    getmorejunk=
	    myobject[my_i,"cmd"] := Cmd1
		myobject[my_i,"desc"] := ""
		my_i++
		}	
	Cmd := ParseHotLine(A_LoopField)
	if !Cmd
		{
		getmorejunk=1
		Cmd1:=A_LoopField
		continue
		}
	if Cmd=comment
		{
		LV_Add("",Keys,Desc,Cmd,my_i)
	    myobject[my_i,"cmd"] := ""
		myobject[my_i,"desc"] := Desc
		my_i++
		Continue 
		}
	StringSplit RCmd,Cmd,`:,%A_Space%%A_Tab%
	if (RCmd0>2 and RCmd3 != "")
		{
		LV_Add("",Keys,Desc,Cmd,my_i)
	    myobject[my_i,"cmd"] := Cmd
		myobject[my_i,"desc"] := Desc
		my_i++
		}
	else
		getmore=1
  } 
if getmore
{
	getmore=
	LV_Add("",Keys,Desc,Cmd,my_i)
	myobject[my_i,"cmd"] := Cmd
	myobject[my_i,"desc"] := Desc
	my_i++
}
if getmorejunk
{
	getmorejunk=
	myobject[my_i,"cmd"] := Cmd1
	myobject[my_i,"desc"] := ""
	my_i++
}
return
;- - - - - - - - - - - - - - - - - - COMMON SUBROUTINES - - - - - - - - - - - - - - - - - - 

ParseHotLine(Line)		 ;Function to parse HotKey data file
{
  AutoTrim,off 
  global Keys, Desc
  StringLeft,C2,Line,2 
							; Insert Seperator 
  IfEqual,C2,`;`;
	{ 
	  StringTrimLeft, Desc, Line, 2
	  Desc = %Desc%
    Keys=
	  Desc := "----  " . Desc . "  -------------------------"
	  return "comment"
	}
							; Insert Hotstrings 
  IfEqual,C2,`:`: 
  { 
    StringSplit,Keys,Line,`: 
    Keys=%Keys3%
    StringSplit,Desc,Line,`; 
    StringTrimLeft,Desc,Desc%Desc0%,0
    Line=
  return Desc1
  } 
						; Insert Hotkeys  
  IfInString,Line,`:`: 
  { 
    StringSplit,Keys,Line,`: 
    StringReplace,Keys,Keys1,#,Win- 
    StringReplace,Keys,Keys,!,Alt- 
    StringReplace,Keys,Keys,^,Ctrl- 
    StringReplace,Keys,Keys,+,Shft- 
    StringReplace,Keys,Keys,`;, 
    StringSplit,Desc,Line,`;
    StringTrimLeft,Desc,Desc%Desc0%,0  
    Desc = %Desc%
    Return Desc1
  }
	Else
	{
  	Desc=
  	Keys=
  	return 0
  }
}

CheckLine(Line)		 ;Function to parse HotKey data file
{
  AutoTrim,off 
  If (Instr(line,";;")=1 OR Instr(line,"::"))
	return 0	;Seperator/Hotkey/Hotstring
  Else
    return 1
}