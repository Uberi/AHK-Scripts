/*
	DYNAMIC OBFUSCATOR is an obfuscator for autohotkey scripts that
	can obfuscate functions, autohotkey functions, labels,
	parameters, and variables. It can automatically use the dynamic
	variable creation features of autohotkey to create breakable
	code sections and function path rewiring.

	Copyright (C) 2011-2013  David Malia

	This program is free software: you can redistribute it and/or 
	modify it under the terms of the GNU General Public License as
	published by the Free Software Foundation, either version 3 of
	the License, or (at your option) any later version.

	This program is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.

	You should have received a copy of the GNU General Public License
	along with this program.  If not, see
	<http://www.gnu.org/licenses/>.

	David Malia, 11 Cedar Ct, Augusta ME, USA
	dave@dynamicobfuscator.org
	http://davidmalia.com
	
*/

;used to parse the source code both for the translations map creation phase
;and the obfuscation phase

parse_onefile(sourcecodefile, filenumber)
{
	global processcodesection, CUR_OBFCOMM, totalsourcelines
	
	;write file name to window that shows 'running' info		
	GuiControl,, showscodefilename, % sourcecodefile
			
	FileRead, sourcecode, % sourcecodefile
	trimmedsourcecode =
	
	;look for IGNORE_BEFORE_THIS and IGNORE_AFTER_THIS tags
	Loop, parse, sourcecode, `n, `r
	{				
		if IS_OBFCOMM(A_LoopField) {
			if (CUR_OBFCOMM = "IGNORE_BEFORE_THIS") {
				showmyprocmess("found - '" . CUR_OBFCOMM . "'")
				trimmedsourcecode =
				continue					
			} else if (CUR_OBFCOMM = "IGNORE_AFTER_THIS") {
				showmyprocmess("found - '" . CUR_OBFCOMM . "'")
				break					
			}				
		}
		;build it line by line
		trimmedsourcecode .= A_LoopField . "`r`n"
	}
	
	;break into an array of lines for easier processing	
	
	if (!rowstoproc := createsourcearray(trimmedsourcecode, "includefile")) {
		showmyprocmess("**NO PROCESSABLE LINES FOUND IN FILE:`n" . sourcecodefile)
		return
	}
	
	;add into running count of lines processed
	totalsourcelines += rowstoproc	
	showmyprocmess("Source code lines to process: " . rowstoproc)
	
	codesection =	
	;look for "END_AUTOEXECUTE" first if it is the first file
	if (filenumber = 1) {
		while true {
			curline = % nextsourceline("includefile")
			if ENDOFSOURCE("includefile")
				break
			
			if (IS_OBFCOMM(curline) and CUR_OBFCOMM = "END_AUTOEXECUTE") 
				break
						
			codesection .= curline . "`r`n"
		}
		myheader = % ";autoexecute"
		%processcodesection%("", myheader, codesection, "autoexecute", "autoexecute")
	}
					
	preLOFlines =
	
	while !ENDOFSOURCE("includefile") { 
		curline = % nextsourceline("includefile")
		if ENDOFSOURCE("includefile")
			break		
				
		;obfuscater commands should not be outside of functions or label sections
		;unless function 'mapping'is taken place
		if (IS_OBFCOMM(curline) and processcodesection = "MAPcodesection") {
			passthruCOMM()
			continue
		}
		
		;checks whether this line starts a function definition
		;or a label section start. if it is then it will 'consume' the rest of
		;the function or label
		LOFtype =
		LOFname = 
		
		if isLOFheader(curline, LOFtype, LOFname) {
			LOFheaderline = % curline			
			LOFbodylines = % consumebodyLOF(LOFtype)			
			%processcodesection%(preLOFlines, LOFheaderline, LOFbodylines, LOFtype, LOFname)
			preLOFlines =
		} else {
			;if there are comment lines before the label or function
			;they will be preserved
			;stores comment that are 'pre' the function header of label section start
			;if curline is not space
			;if (preLOFlines)
				preLOFlines .= "`r`n"
			preLOFlines .= curline	
		}
	}
}
isLOFheader(programline, ByRef  LOFtype, ByRef LOFname, nestedlabelsonly = 0)
{
	;static lastime := 0
	;static lastline := 0
	;scanning for label or function header line in this code
	
	timepassed := A_TickCount - lastime
	
	if (nestedlabelsonly) {
		;msgbox, hello:%timepassed%`n%lastline%`n%programline%
		;lastime := A_TickCount
		;lastline := programline
		LOFname =
		if (!found1colon := InStr(programline, ":"))
			return, false
			
		found2colons := InStr(programline, "::")
		if (found2colons and found2colons <= found1colon)
			return, false
	
		;get the next character
		mynextchr := SubStr(programline, found1colon + 1, 1)					
		;if the character after the ':' is a '=" then this is NOT A LABEL HEADER
		if (mynextchr = "=")
			return, false
			
		LOFname = % SubStr(programline, 1, (found1colon - 1))
		if !validfuncorlabelchars(LOFname) {
			LOFname =
			return, false	
		}
		
		;assume it is a valid hotkey combo!
		LOFtype = % "label"
		return, true		
	}
	
	;msgbox, hello 2:%timepassed%`n%lastline%`n%programline%
	;lastime := A_TickCount
	;lastline := programline
	
	validbeforesemi := "#!^+$*<>~"
	LOFtype = % ""
	
	if (foundsemi := InStr(programline, ";")) 
		beforesemi := SubStr(programline, (foundsemi - 1), 1)			
	
	if (found2colons := InStr(programline, "::")) {
		;a semicolon can be a hotkey! which complicated things!
		if (foundsemi and foundsemi < found2colons) {
			;a semicolon can be a valid hotkey only if certain characters are
			;found before them. if none of these characters are found
			;then assume that the double colons are part of a comment
			;and it is not a hotkey!
			if !InStr(validbeforesemi, beforesemi)
				return, false
		}	
		
		;assume it is a valid hotkey combo!
		LOFname = % SubStr(programline, 1, (found2colons - 1))	
		LOFtype = % "hotkey"
		return, true	
	}
	
	if (found1colon := InStr(programline, ":")) {		
		;get the next character
		mynextchr := SubStr(programline, found1colon + 1, 1)					
		;if the character after the ':' is a '=" then this is NOT A LABEL HEADER
		if (mynextchr = "=")
			return, false
				
		LOFname = % SubStr(programline, 1, (found1colon - 1))
		if !validfuncorlabelchars(LOFname) {
			LOFname =
			return, false	
		}
		
		;assume it is a valid hotkey combo!
		LOFtype = % "label"
		return, true	
	}
	
	if (foundleftparen := InStr(programline, "(")) {
		;assume colon is part of a comment!
		if (foundsemi and foundsemi < foundleftparen) 
			return, false
			
		;assume it is a valid hotkey combo!
		LOFname = % SubStr(programline, 1, (foundleftparen - 1))
		if !validfuncorlabelchars(LOFname) {
			LOFname =
			return, false	
		}
		
		LOFtype = % "function"
		return, true	
	}
	
	return, false	
}

validfuncorlabelchars(forstr) 
{

	static varspecchars := "#_@$"
	
	loop, % strlen(forstr)
	{
		curchar = % SubStr(forstr, a_index, 1)	
					
		if curchar is alnum
			continue
			
		;allowable spacial characters in function and label headers
		if InStr(varspecchars, curchar) 
			continue

		return, false
	}
	
	return, true
}

consumebodyLOF(labelorfunctype)
{
	;FIND THE REST OF THE BODY OF THE FUNCTION OR LABEL
		
	funcorlabelbody = % ""
	
	while !ENDOFSOURCE("includefile") {
		curline = % nextsourceline("includefile")
		if ENDOFSOURCE("includefile")
			break
	
		funcorlabelbody .= curline . "`r`n"	
		
		if (labelorfunctype = "label" or labelorfunctype = "hotkey") { ;test for label section found
			;test for the end of gosub type label
			first6chars = % SubStr(curline, 1, 6)
			if (ucase(first6chars) = "RETURN") ;implies end of label section
				break				
		
		} else if (labelorfunctype = "function") { ;test for function section found
			;test for end of function body definition
			if (SubStr(curline, 1, 1) = "}") ;implies end of function section
				break	
					
		} else { ;ERROR
			showmyprocmess("FUNC OR LABEL FIND BODY END ERROR")
			return, % ""
		}
	}
	
	return, % funcorlabelbody

}

IS_OBFCOMM(programline)
{
	global CUR_OBFCOMM
	
	if SubStr(programline, 1, 13) = ";$OBFUSCATOR:" {		
		return, % getobfcomm(programline)
	} else {
		CUR_OBFCOMM = % ""
		return, % false
	}
}

getobfcomm(ByRef programline)
{
	global 
	static obfcomm, endcomm
	
	;get the part after ';$OBFUSCATOR:'
	obfcomm = % SubStr(programline, 14)
	;remove spaces
	obfcomm = %obfcomm%
	
	if (SubStr(obfcomm, 1, 1) <> "$") {
		CUR_OBFCOMM = % ""
		return, % false
	}
	
	;find end of command
	if (!endcomm := instr(obfcomm, ":", CaseSensitive = false, 2)) {
		CUR_OBFCOMM = % ""
		return, % false	
	}
	
	CUR_OBFCOMM = % SubStr(obfcomm, 2, endcomm - 2)
	myparams = %  SubStr(obfcomm, endcomm + 1)
	;remove spaces
	myparams = %myparams%
	
	CUR_COMMPARAMS = % myparams	
	
	return, % true		
}


