;
; AutoHotkey Version: 1.x
; Language:       English
; Platform:       Win9x/NT
; Author:         A.N.Other <myemail@nowhere.com>
;
; Script Function:
;	sorts sections and keys in WIHU (Windows Installation Helper Utility) ini-files:
;          http://www.kalytta.com/wihu.php
;
;       based on the original script by Camarade_Tux:
;          http://www.msfn.org/board/Release-WIHU-alphabetic-sorter-t78361.html

Template script (you can customize this template by editing "ShellNew\Template.ahk" in your Windows folder)
;
; SetBatchLines -1
; #NoTrayIcon
#SingleInstance force ; Run script only one time in memory

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
;#NoTrayIcon

Gui, Add, Text, y9, Input file :
Gui, Add, Edit, vsource x15 w300
Gui, Add, Button, gBrowseInput x320 y27 w60, Browse
Gui, Add, Text, x10, Output File :
Gui, Add, Edit, vout x15 w300
Gui, Add, Button, gBrowseOutput x320 y74 w60, Browse
Gui, Add, Text, x10, Maximal Index :
Gui, Add, DDL, vmax w60 x15, 10|20|40|60|80||100|120|150|180|200
Gui, Add, Button, gRun x170 y144 w50, Run!

ShowMain:
	Gui, Show
return

BrowseInput:
	Gui, +OwnDialogs
	FileSelectFile, source, 1, %A_ScriptDir%\install.ini, Please select the file to be sorted.
	GuiControl,, source, %source%
	Gui, Submit
	if (!out) {
		StringGetPos, pos, source, `\, R
		StringTrimRight, out, source, Strlen(source)-pos-1
		GuiControl,, out, %out%\install_sorted.ini
	}
	Gui, Show
return

BrowseOutput:
	Gui, +OwnDialogs
	if (out)
		FileSelectFile, out, S2, %out%\install_sorted.ini, Please select where to place the file once sorted.
	else
		FileSelectFile, out, S2, %A_ScriptDir%\install_sorted.ini, Please select where to place the file once sorted.
	if (out)
		GuiControl,, out, %out%
	Gui, Show
return

Run:
	Gui, Submit
	Gui, +OwnDialogs
	IfNotExist, %source%
	{
		MsgBox, 0, Error!, Input file could not be found
		Goto, ShowMain
	}
	if (source=out) {
		MsgBox, 0, Error, Input and output files must be different!`r`nPlease change this.
		Goto, ShowMain
	}
	MsgBox, 0, Processing..., The script will take some time to complete.`r`nPlease press OK and wait.
	FileDelete, %out%

	ini_Load(IniVar, Source)
	SectionsList := ini_GetSections(IniVar)
	Sort , SectionsList
	IfInString , SectionsList , Environment
	{
		StringReplace , SectionsList , SectionsList , Environment
		CopyDefaultSections("Environment")
	}
	IfInString , SectionsList , Settings
	{
		StringReplace , SectionsList , SectionsList , Settings
		CopyDefaultSections("Settings")
	}
	IfInString , SectionsList , Users
	{
		StringReplace , SectionsList , SectionsList , Users
		CopyDefaultSections("Users")
	}
	SectionsList := RegExReplace(SectionsList , "\R\R","`n")
	SectionsList := RegExReplace(SectionsList , "^\R")
	SectionsList := RegExReplace(SectionsList , "\R$")

	Loop, Parse, SectionsList , `n, `r ; parses sections to sort
	{
		section:=A_LoopField
		Write("","", "description") ;calls the write function for each item (exceptionnal one)
		Write("", "", "command")
		Write("", "", "selected")
		Write("", "", "hidden")
		Write("", "", "collapsed")
		Write("", "", "locked")
		Write("", "", "disabled")
		Write("", "", "group")
		Write("", "", "flags")
		Write("", "", "workdir")
		Write("", "", "helptext")
		Write("", "", "help")
		Write("", "", "ext_creator_switchtype")
		Write("", "", "ext_creator_originalcommand")
		Sort()
	}

	FileRead, sorted, %out% ;needed for the three followig lines
	StringReplace, sorted, sorted, Description, `r`nDescription, All ;adds linefeeds so the file can be read by an human
	StringReplace, sorted, sorted, [, `r`n[, All ;same
	; StringReplace, sorted, sorted, ]`r`n, ], All ;removes some non-necessary linefeeds introduced just before
	StringReplace, sorted, sorted, `r`n[, [ ; removes the first linefeed
	
	Adjust(sorted)
	
	FileDelete, %out% ;deletes the file so...
	FileAppend, %sorted%, %out% ;it can be 'overwritten'
	
	CheckContent(source,out)

	MsgBox, 0, Operation Complete, Input file has been sorted.
	
	ExitApp
return

GuiClose:
	ExitApp
return

CopyDefaultSections(SectionName)
{
	Global IniVar , Source, Out
	
	KeysList := ini_GetKeys(IniVar, SectionName)
	Sort , KeysList , F MyStringSort
	
	KeysList := RegExReplace(KeysList , "\R\R","\R")
	KeysList := RegExReplace(KeysList , "^\R")
	KeysList := RegExReplace(KeysList , "\R$")
	Loop, Parse, KeysList,`n,`r
	{
		CurrentKey := A_LoopField
		
		IniRead, CurrentValue, %Source%, %SectionName%, %CurrentKey%, %A_Space%
		If CurrentValue = ""
		{
			MsgBox , 0 , Error , Error reading Ini file:`nCurrentValue = %CurrentValue%`nSource = %Source%`nSectionName = %SectionName%`nCurrentKey = %CurrentKey%
			ExitApp
		}
		IniWrite, %CurrentValue%, %Out%, %SectionName%, %CurrentKey%
	}
	return
}

CheckContent(source,out)
{
	Loop , Read , %source%
	{
		If (A_LoopReadLine = "")
			continue
		
		OldLine := RegExReplace(A_LoopReadLine , "^\s*") ; remove leading whitespaces
		OldLine := RegExReplace(OldLine , "\s*$") ; remove tailing whitespaces
		IfInString , OldLine , `;
			If (RegExReplace(OldLine , "^`;.*") = "")
			{
				Msgbox , comment found in line %A_Index%:`n# # # # # # # # # #`n%OldLine%`n# # # # # # # # # #`ncomments are not copied
				continue
			}
		
		IfInString , OldLine , "
		{
			SearchMarks := OldLine
			Loop
			{
				IfNotInString , SearchMarks , "
					break
				SearchMarks := RegExReplace(SearchMarks , "[^""]*""[^""]*" , "*")
				; SearchMarks := RegExReplace(SearchMarks , "[^""]*""" , "*")
			}
			If Mod(StrLen(SearchMarks),2) != 0
				Msgbox , The line %A_Index% has an odd amount of quotation marks:`n# # # # # # # # # #`n%OldLine%`n# # # # # # # # # #`n
		}

		OldLine := RegExReplace(A_LoopReadLine , "^[^=]*=")
		OldLine = %OldLine%
		Found := 0
		
		Loop , Read , %out%
		{
			NewLine := RegExReplace(A_LoopReadLine , "^[^=]*=")
			NewLine = %NewLine%
			
			blubb := "RS freuddd"
			IfInString , NewLine , %blubb%
				IfInString , OldLine , %blubb%
					Msgbox , |%oldLine%|`n|%newLine%|
			If (OldLine = NewLine)
			{
				Found := 1
				break
			}
		}
		If (Found = 0)
			Msgbox , Line %A_Index% not found:`n%A_LoopReadLine%
}
}

Sort(oldlevel="", newlevel="") ;the main function, recursively called
{
	Global max, source, out, section
	
	Loop, %max%
	{
		i:=A_Index - 1 ;WIHU's first index is 0 whereas AHK's one is 1
		IniRead, iuv, %source%, %section%, description%oldlevel%.%i%, %A_Space%
		if (iuv="") ;avoid adding non-existant indexes
		{
			IniRead, iuv2, %source%, %section%, command%oldlevel%.%i%, %A_Space% ;retrieves command
			if (iuv2="")
				continue
			else
			{
				MsgBox , 0 , Error , Error: command without description found in:`nSection: %section%`nLevel: command%oldlevel%.%i%`nCommand: %iuv2%
				ExitApp
			}
		}
		if (Names) ;appends a semi-column and the section name (iuv) with its old index (@i) to the list, except if ...
			Names .= ";" iuv "@" i
		else ;... except if the list is empty (would bug otherwise)
			Names:=iuv "@" i
	}
	Sort, Names, D`;
	StringSplit, Names, Names, `;
	Loop, %Names0%
	{
		i:=A_Index - 1 ;same as before : WIHU's first index is 0 whereas AHK's one is 1
		Stringsplit, oldrank, Names%A_Index%, `@ ;retrieves old index
		Write(oldlevel "." oldrank2, newlevel "." i, "description") ;calls the write function for each item
		Write(oldlevel "." oldrank2, newlevel "." i, "command")
		Write(oldlevel "." oldrank2, newlevel "." i, "selected")
		Write(oldlevel "." oldrank2, newlevel "." i, "hidden")
		Write(oldlevel "." oldrank2, newlevel "." i, "collapsed")
		Write(oldlevel "." oldrank2, newlevel "." i, "locked")
		Write(oldlevel "." oldrank2, newlevel "." i, "disabled")
		Write(oldlevel "." oldrank2, newlevel "." i, "group")
		Write(oldlevel "." oldrank2, newlevel "." i, "flags")
		Write(oldlevel "." oldrank2, newlevel "." i, "workdir")
		Write(oldlevel "." oldrank2, newlevel "." i, "helptext")
		Write(oldlevel "." oldrank2, newlevel "." i, "help")
		Write(oldlevel "." oldrank2, newlevel "." i, "ext_creator_switchtype")
		Write(oldlevel "." oldrank2, newlevel "." i, "ext_creator_originalcommand")
		IniRead, iuv, %source%, %section%, description%oldlevel%.%oldrank2%.0, %A_Space% ;is there a deeper level to sort ?
		if (iuv!="")
			Sort(oldlevel "." oldrank2, newlevel "." i) ;recursive call because when there is a deeper level
	}

}

Write(old, new, var) ;the function used to write in the ini
{
	global source, out, section, ERROR
	IniRead, iuv, %source%, %section%, %var%%old%, %A_Space% ;retrieves the old value
	if (iuv != "") ;keys with empty values are not copied over, should *maybe* be changed
	{
		StringUpper, var, var , T
		IniWrite, %iuv%, %out%, %section%, %var%%new% ;writes the new value
	}
}

Adjust(ByRef IniText)
{
	NewIniText := "" ; new text
	Loop, parse, IniText, `n, `r
	{
		NewLine := A_LoopField ; if nothing changed, it's the default value for this line
		Key := RegExReplace(A_LoopField , "=.*")
		KeyList = description,command,selected,hidden,collapsed,locked,disabled,group,flags,workdir,helptext,ext_creator_switchtype,ext_creator_originalcommand
		If key contains %keylist%
		{
			Level := RegExReplace(Key , "^[^\.]*\.")
			If (Level != Key)
			{
				Offset := ""
				Loop % StrLen("." . Level) / 2
					Offset .= A_Tab
				
				NewLine := Offset . NewLine
			}
		}
		NewIniText .= NewLine . "`n"
	}
	IniText := NewIniText
	return
}


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

		Function: ini_Delete
			Removes a key within a specifed section.
		
		Parameters:
			var - ini object
			sec - name of section to 
			look under
			key - key name

*/
ini_Delete(ByRef var, sec, key) {
	NumPut(160, var, 0, "UChar")
	f = `n%sec%/%key%=
	StringGetPos, p, var, %f%
	If ErrorLevel = 0
		var := SubStr(var, 1, p) . SubStr(var, 1 + InStr(var, "`n", "", p + 2))
	NumPut(0, var, 0, "UChar")
	Return, true
}

/*

		Function: ini_Write
			Change the value of a key within a section or create one if it does not exist.
		
		Parameters:
			var - ini object
			sec - name of section to look under
			key - key name
			value - a string to store as the keys content
		
		Returns:
			Key value.

*/
ini_Write(ByRef var, sec, key, value = "") {
	NumPut(160, var, 0, "UChar")
	f = `n%sec%/%key%=
	l := _ini_escape(value)
	StringGetPos, p, var, %f%
	If ErrorLevel = 1
	{
		var = %var%%f%%l%`n
		NumPut(0, var, 0, "UChar")
		Return, false
	}
	p += StrLen(f) + 1
	StringGetPos, p1, var, `n, , p
	StringLeft, d1, var, p - 1
	StringTrimLeft, d2, var, p1
	var = %d1%%l%%d2%
	NumPut(0, var, 0, "UChar")
	Return, true
}

/*

		Function: ini_MoveKey
			Copies or moves a key and its value from one section to another.
		
		Parameters:
			var - ini object
			from - name of parent section to the specified key
			to - section to inherit the new key
			copy - true to remove the old key, false otherwise
		
		Returns:
			True if the key was found and moved.

*/
ini_MoveKey(ByRef var, from, to, key, copy = false) {
	NumPut(160, var, 0, "UChar")
	to := SubStr(var, InStr(var, "`n" . to . "/") + 1, StrLen(to))
	f = `n%from%/%key%
	StringGetPos, p, var, %f%
	If ErrorLevel = 1
	{
		NumPut(0, var, 0, "UChar")
		Return, false
	}
	p++
	StringGetPos, p1, var, `n, , p
	StringMid, e, var, p, p1 - p + 2
	v := SubStr(e, InStr(e, "=") + 1, -1)
	StringGetPos, p, var, `n%to%/%key%=
	If ErrorLevel = 0
	{
		p++
		StringGetPos, p1, var, `n, , p
		StringMid, r, var, p, p1 - p + 2
		StringReplace, var, var, %r%, `n%to%/%key%=%v%`n
	}
	Else var = %var%`n%to%/%key%=%v%
	If (!copy)
		StringReplace, var, var, %e%
	NumPut(0, var, 0, "UChar")
	Return, true
}

/*

		Function: ini_FindKeysRE
			Get a list of key names for a section from a regular expression.
		
		Parameters:
			var - ini object
			sec - name of section to look under
			exp - regular expression for key name
		
		Returns:
			List of `n (LF) delimited key names.

*/
ini_FindKeysRE(ByRef var, sec, exp) {
	NumPut(160, var, 0, "UChar")
	s = %sec%/
	StringLen, b, s
	b++
	Loop, Parse, var, `n
	{
		If A_LoopField =
			Continue
		StringMid, k, A_LoopField, b, InStr(A_LoopField, "=") - b
		If (InStr(A_LoopField, s) == 1 and RegExMatch(k, exp))
			l = %l%%k%`n
	}
	NumPut(0, var, 0, "UChar")
	Return, l
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

		Function: ini_FindSectionsRE
			Get a list of section names that match a regular expression.
		
		Parameters:
			var - ini object
			exp - regular expression for section names
		
		Returns:
			List of `n (LF) delimited section names.

*/
ini_FindSectionsRE(ByRef var, exp) {
	NumPut(160, var, 0, "UChar")
	Loop, Parse, var, `n
	{
		If A_LoopField =
			Continue
		StringLeft, s, A_LoopField, InStr(A_LoopField, "/") - 1
		If (RegExMatch(s, exp) and !InStr(l, s . "`n"))
			l = %l%%s%`n
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

		Function: ini_MergeSections
			Merges two sections.
		
		Parameters:
			var - ini object
			from - section to move
			to - section to inherit new keys
			replace - true to replace existing keys from the destination section
		
		Returns:
			Number of keys moved.

*/
ini_MergeSections(ByRef var, from, to, replace = true) {
	NumPut(160, var, 0, "UChar")
	f = %from%/
	t = %to%/
	StringGetPos, p, var, %t%
	StringMid, t, var, p + 1, StrLen(t)
	StringLen, l, f
	Loop, Parse, var, `n
	{
		If A_LoopField =
			Continue
		If (InStr(A_LoopField, f) == 1) {
			StringGetPos, p, A_LoopField, =
			StringMid, k, A_LoopField, l + 1, p - l
			StringMid, v, A_LoopField, p + 2
			e = `n%t%%k%=%v%`n
			StringGetPos, p, var, `n%t%%k%=
			If ErrorLevel = 0
			{
				If replace
				{
					p++
					StringGetPos, p1, var, `n, , p
					StringMid, x, var, p, p1 - p + 2
					StringReplace, var, var, %x%, %e%
				}
			}
			Else var = %var%%e%
			StringReplace, var, var, `n%f%%k%=%v%`n
			c++
		}
	}
	NumPut(0, var, 0, "UChar")
	Return, c
}

/*

		Function: ini_DeleteSection
			Get the complete list of sections.
		
		Parameters:
			var - ini object
			sec - name of section
		
		Returns:
			Number of child keys removed.

*/
ini_DeleteSection(ByRef var, sec) {
	NumPut(160, var, 0, "UChar")
	n = %sec%/
	Loop, Parse, var, `n
	{
		If A_LoopField =
			Continue
		If (InStr(A_LoopField, n) == 1) {
			StringReplace, var, var, `n%A_LoopField%`n
			c++
		}
	}
	NumPut(0, var, 0, "UChar")
	Return, c
}


/*

		Function: ini_Duplicate
			Copies the INI variable to another.
		
		Parameters:
			var - ini object
			newVar - new ini object
		
		Returns:
			True if data was copied successfully, flase otherwise.

*/
ini_Duplicate(ByRef var, ByRef newVar) {
	NumPut(160, var, 0, "UChar")
	newVar := var
	NumPut(0, newVar, 0, "UChar")
	NumPut(0, var, 0, "UChar")
	Return, VarSetCapacity(var) == VarSetCapacity(newVar)
}

/*

		Function: ini_ToXML
			Converts the INI structure to XML.
		
		Parameters:
			var - ini object
			ind - (optional) tag indentation character(s) (default: two spaces ("  "))
			root - (optional) root element (default: ini)
		
		Remarks:
			Empty key nodes are automatically fused.
		
		Returns:
			An XML document.
		
		Example:
		
> ini_Load(phpconfig, ProgramFiles . "\PHP\php.ini")
> xmlsource := ini_ToXML(phpconfig)
> 
> ; the following requires the xpath library:
> xpath_load(xmldata, xmlsource)
> MsgBox, % xpath(xmldata, "/ini/PHP/*[3]")

*/
ini_ToXML(ByRef var, ind = "  ", root = "ini") {
	NumPut(160, var, 0, "UChar")
	VarSetCapacity(x, StrLen(var) * 1.5)
	x = <?xml version="1.0" encoding="iso-8859-1"?>`n<%root%>
	Loop, Parse, var, `n,  
	{
		If A_LoopField =
			Continue
		StringLeft, s, A_LoopField, b := InStr(A_LoopField, "/") - 1
		StringMid, k, A_LoopField, b += 2, InStr(A_LoopField, "=") - b
		StringTrimLeft, v, A_LoopField, InStr(A_LoopField, "=")
		If s != %ls%
		{
			If ls !=
				x = %x%`n%ind%</%ls%>
			x = %x%`n%ind%<%s%>
			ls = %s%
		}
		x = %x%`n%ind%%ind%<%k%>%v%</%k%>
	}
	NumPut(0, var, 0, "UChar")
	Return, RegExReplace(x . "`n" . ind . "</" . ls . ">`n</" . root . ">"
		, "<([\w:]+)([^>]*)>\s*<\/\1>", "<$1$2 />")
}

/*

		Function: ini_Save
			Save the INI content to a file, 
			preserving the positions of previously existing sections and their keys.
		
		Parameters:
			var - ini object
			src - (optional) path to a file or source as text
		
		Returns:
			The output source if src is not a file path, 
			otherwise a boolean indicating file write success or failure.

*/
ini_Save(ByRef var, src = "") {
	NumPut(160, var, 0, "UChar")
	IfExist, %src%
	{
		src_file = 1
		FileRead, src, %src%
	}
	StringReplace, src, src, `r`n, `n, All
	StringReplace, src, src, `r, `n, All
	ls := ini_GetSections(var)
	_at = %A_LoopField%
	AutoTrim, On
	s =
	z =
	x = 1
	Loop, Parse, src, `n
	{
		l = %A_LoopField%
		If (InStr(l, "[") == 1) {
			StringReplace, ls, ls, %s%`n
			Loop, Parse, z, `n
				If A_LoopField
					d .= A_LoopField . " = " . ini_Read(var, s, A_LoopField) . "`n"
			s := SubStr(l, 2, -2), x := InStr(ls, s . "`n"), z := ini_GetKeys(var, s)
			If x
				d = %d%%l%`n
			Continue
		}
		If x
		{
			StringGetPos, p, l, =
			StringLeft, k, l, p
			k = %k%
			If k !=
				If k not contains /,`t, , ,#
					If (InStr(z, k . "`n")) {
						d .= k . " = " . ini_Read(var, s, k) . "`n"
						StringReplace, z, z, %k%`n
						Continue
					}
			d = %d%%l%`n
		}
	}
	Loop, Parse, ls, `n
	{
		s = %A_LoopField%
		If s !=
			d = %d%`n[%s%]`n
		z := ini_GetKeys(var, s)
		Loop, Parse, z, `n
			If A_LoopField !=
				d .= A_LoopField . " = " . ini_Read(var, s, A_LoopField) . "`n"
	}
	AutoTrim, %_at%
	NumPut(0, var, 0, "UChar")
	If (InStr(d, "`n") == 1)
		StringTrimLeft, d, d, 1
	StringTrimRight, d, d, 1
	If src_file = 1
	{
		FileDelete, %file%
		FileAppend, %d%, %file%
		Return, !ErrorLevel
	}
	Return, d
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
		If k contains /,`t, , ,#
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

MyKeySort(a1, a2)
{
	global
	a1_pos := InStr(a1,".")
	a2_pos := InStr(a2,".")
	
	If (a1_pos = 0 || a2_pos = 0)
	{
		if (a1_pos = a2_pos)
			return MyStringSort(a1,a2)
		else if (a1_pos > a2_pos)
			return 1
		else
			return -1
	}
	
	StringTrimLeft , num_a1 , a1 , %a1_pos%
	StringTrimLeft , num_a2 , a2 , %a2_pos%
	num_a1 = a%num_a1%
	num_a2 = a%num_a2%
	If (num_a1 = num_a2)
		return MyStringSort(a1,a2)
	Else If (num_a1 > num_a2)
		return 1
	Else
		return -1
}

MyStringSort(a1,a2)
{
	StringTrimRight , str_a1 , a1 , %a1_pos%
	StringTrimRight , str_a2 , a2 , %a2_pos%
	
	If (str_a1 = str_a2)
		return 0
	Else If (str_a1 > str_a2)
		return 1
	Else
		return -1
}