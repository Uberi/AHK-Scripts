	/*! Adapted by TheGood, Updated by Rseding91
	http://www.autohotkey.com/forum/viewtopic.php?p=364922
	Last updated: September 3rd, 2011
	*/

	;Check for command-line parameters
	iParamCount = %0%
	If (iParamCount){
		
		;Get last parameter
		sFile := %iParamCount%

		optOpt := 1, optWarn := 0, optLang := (SubStr(sFile, -2) = "cpp" ? 2 : 1), optCompiler := 1
		Loop % (iParamCount - 1) {
			sParam := %A_Index%

			If (sParam = "-minsize")
				optOpt := 1
			Else If (sParam = "-maxspeed")
				optOpt := 2
			Else If (sParam = "-c")
				optLang := 1
			Else If (sParam = "-cpp")
				optLang := 2
			Else If (sParam = "-notify")
				bNotify := True
			Else If (sParam = "-x86")
				optCompiler := 1
			Else If (sParam = "-x64")
				optCompiler := 2
			Else If (InStr(sParam, "-warn") = 1) And (s := SubStr(sParam, 6)) {
				If s is integer
					optWarn := s <= 4 ? s : optWarn
			}
		}
		
		;Check if file exists
		If (!FileExist(sFile)){
			s = The file "%sFile%" does not exist.`nThe program will now exit.
			If (!bNotify)
				MsgBox, 0x1010, MCodeGen, %s%
			Else {
				TrayTip, MCodeGen, %s%,, 3
				Sleep, 5000
			}
			ExitApp
		}
	}
	
	;Check for a Visual Studio installation (and retrieve the highest installation if multiple)
	sVS := 0
	Loop, HKLM, SOFTWARE\Microsoft\VisualStudio\SxS\VC7, 0
	{
		If A_LoopRegName is number
		{
			If (A_LoopRegName > sVS And A_LoopRegName != 11.0)
				sVS := A_LoopRegName
		}
	}
	
	If (!sVS Or sVS < 8){
		s := "You do not have Visual Studio 2005 or more recent installed.`nYou can install the VS C++ Express for free from`nhttp://www.microsoft.com/express/`n`nThe program will now exit."
		If (!bNotify)
			MsgBox, 0x1010, MCodeGen, %s%
		Else {
			TrayTip, MCodeGen, %s%,, 3
			Sleep, 5000
		}
		
		ExitApp
	}
	
	;Get value
	RegRead, sVS, HKLM, SOFTWARE\Microsoft\VisualStudio\SxS\VC7, %sVS%
	
	;Make sure vcvarsall.bat exist
	sBAT := sVS "vcvarsall.bat"
	If (!FileExist(sBAT)){
		s := "vcvarsall.bat is missing!`nThe program will now exit."
		If (!bNotify)
			MsgBox, 0x1010, MCodeGen, %s%
		Else {
			TrayTip, MCodeGen, %s%,, 3
			Sleep, 5000
		}
		
		ExitApp
	}
	
	;Check if we're doing command-line or GUI
	If (iParamCount)
		Goto, Create
	
	SetWorkingDir, %A_Temp%
	FileRead, sCode, code.c
	sCode := sCode ? sCode : "MyFunction() {`n`treturn 42;`n}"
	
	Gui, Font, s10, Courier New
	Gui, Font, s10, Inconsolata
	Gui, Font, s10, Consolas
	Gui, Add, Edit, xm w700 r20 T8 WantTab HScroll VScroll vtxtCode -wrap, %sCode%
	Gui, Font
	
	Gui, Add, Text, Section, Optimization:
	Gui, Add, Radio, voptOpt Checked, Optimize for size
	Gui, Add, Radio,, % "Optimize for speed"
	Gui, Add, Text, ys Section, % "Code language:"
	Gui, Add, Radio, voptLang Checked, C
	Gui, Add, Radio,, C++
;	GuiControl,Disable,C++
	Gui, Add, Text, ys Section, Warnings:
	Gui, Add, Radio, voptWarn Checked, Level 0
	Gui, Add, Radio,, Level 1
	Gui, Add, Radio, ys -0x10000000,
	Gui, Add, Radio,, Level 2
	Gui, Add, Radio,, Level 3
	Gui, Add, Radio, ys -0x10000000,
	Gui, Add, Radio,, Level 4
	Gui, Add, Text, ys, Platform/Compiler:
	Gui, Add, Radio, Group Checked voptCompiler, x86
	Gui, Add, Radio,, x64
	Gui, Add, Button, xm w450 gbtnCreate, Create machine code!
	Gui, Show,, MCodeGen
	
	GuiControl, Focus, txtCode
Return

GuiEscape:
GuiClose:
	Gui, Submit, NoHide
	FileDelete,%A_Temp%\code.c
	FileAppend,%txtCode%,%A_Temp%\code.c
ExitApp

btnCreate:
	Gui, Submit, NoHide
	If (optWarn = 4 or optWarn = 5)
		optWarn --
	Else if (optWarn = 7)
		optWarn -= 2
	optWarn --
Create:
	If (iParamCount){
		;Get absolute path
		If (DllCall("shlwapi\PathIsRelative" (A_IsUnicode ? "W" : "A"), "uint", &sFile)) {
			n := DllCall("GetFullPathName", "uint", &sFile, "uint", 0, "uint", 0, "int", 0)
			, VarSetCapacity(sAbs, A_IsUnicode ? n*2 : n)
			, DllCall("GetFullPathName", "uint", &sFile, "uint", n, "str", sAbs, "uint*", iName)
			, sName := DllCall("MulDiv", "int", iName, "int", 1, "int", 1, "str")
			, sFile := sAbs
		}
		
		SetWorkingDir, %A_Temp%
	} Else {
		SetWorkingDir, %A_Temp%
		FileDelete, code.c ;Save code to a temporary file
		FileAppend, %txtCode%, code.c
		sFile := "code.c"
	}
	
;	If (optLang = 2){
;		s := "This version of the Mcode gen script does not support C++ compilation at the moment.`r`nIf you want C++ compilation please post (http://www.autohotkey.com/forum/topic59593.html).`r`nElse, I have no plan to get it working."
;		If (!bNotify)
;			MsgBox, 0x1010, MCodeGen, %s%
;		Else {
;			TrayTip, MCodeGen, %s%,, 3
;			Sleep, 5000
;		}
;	}
	
	If (optCompiler = 2){
		;Prep the parameters
		sCompileBAT := """" sVS "bin\amd64\cl.exe" """" (optLang = 1 ? " /TC " : " /TP ") """" A_Temp "\" sFile """" " /c /FAc /Fa" """" A_Temp "\code.cod" """" " /Ox /W" optWarn " > " """" A_Temp "\out.txt" """"
		, sRunBAT := "compile.bat"
	} Else {
		;Prep the parameters
		sCompiler := optCompiler = 1 ? "x86" : "x86_amd64"
		, sParams := (optLang = 1 ? "/TC" : "/TP" ) " /c /FAc /Facode.cod /Ox /W" optWarn
		
		sCompileBAT =
		( LTrim
			@echo off
			call "%sBAT%" %sCompiler%
			cl %sParams% "%sFile%"
			echo `%ERRORLEVEL`%
		)
		
		sRunBAT := "compile.bat >> out.txt"
	}
	
	FileDelete, compile.bat
	FileAppend, %sCompileBAT%, compile.bat
	FileDelete, out.txt
	
	If (optCompiler = 2){
		IfNotExist,%sVS%bin\amd64\cl.exe
			FileAppend,File Missing : error C???? the x64 compiler is missing.`r`n,%A_Temp%\out.txt
		Else
			RunWait, %sRunBAT%,, Hide
	} Else
		RunWait, %sRunBAT%,, Hide
	
	iErr := ""
	, iWarn := ""
	
	FileRead, Out, out.txt
	
	Loop,Parse,Out,`r,`n
	{
		If (InStr(A_LoopField,": warning C"))
			iWarn .= iWarn ? "`r`n" A_LoopField : A_LoopField
		Else If (InStr(A_LoopField,": error C"))
			iErr .= iErr ? "`r`n" A_LoopField : A_LoopField
	}
	
	If (iWarn){
		FileDelete, warnings.txt
		FileAppend, %iWarn%, warnings.txt
		Run, warnings.txt
	}
	
	If (iErr){
		s := "Compiling failed!"
		
		If (optCompiler = 2 and optLang = 1){
			FileDelete, errors.txt
			FileAppend, %iErr%, errors.txt
			Run, errors.txt
		} Else
			Run, out.txt
		
		If (!bNotify)
			MsgBox, 0x1010, MCodeGen, %s%
		Else {
			TrayTip, MCodeGen, %s%,, 3
			Sleep, 5000
		}
		
		If (iParamCount)
			ExitApp
		Else
			Return
	}
	
	;Read the code listing
	FileRead, sCode, code.cod
	
	;Extract function
	p := 0
	, Clipboard := ""
    ; get the part between PROC to ENDP, with the same function name at the beginning and end
    while (p := RegExMatch(sCode, "ms)^([\w#@?]+)\sPROC.*(?=\r?\n\1\s+ENDP)", hex, p+1)){
		sFunc%A_Index%_Name := hex1

		; remove the first line ("PROC" line)
		hex := RegExReplace(hex, "^.*+")

		; remove lines that start with ; or $
		hex := RegExReplace(hex, "m)^\s*[;$].*(\r?+\n)?+")

		; get all contiguous groups of 2 hex digits
		hex := RegExReplace(hex, "m)(?(DEFINE)(?<x>[0-9a-fA-F]))^\s*(?:(?&x){5,})?\s+(?<h>(?:\b(?&x){2} ?)+).*", "${h}")

		; replace all whitespace
		hex := RegExReplace(hex, "\s+")

		, sFunc%A_Index% := hex
		StringUpper, sFunc%A_Index%, sFunc%A_Index%
		
		If (optCompiler = 1)
			sFunc%A_Index%_Name := SubStr(sFunc%A_Index%_Name,2)
		If (optCompiler = 2 and optLang = 2)
			sFunc%A_Index%_Name := SubStr(sFunc%A_Index%_Name,2)
		
		StringReplace,sFunc%A_Index%_Name,sFunc%A_Index%_Name,@@YA_JPEA_J0@Z
		StringReplace,sFunc%A_Index%_Name,sFunc%A_Index%_Name,@@YA_JPA_J0@Z
		
		Clipboard .= "MCode(" sFunc%A_Index%_Name ", """ sFunc%A_Index% """)`r`n"
		, sFunc%A_Index%_Name := ""
		, sFunc%A_Index% := ""
	}
	
	s := (iParamCount ? sName : "The code") " has been successfully compiled!`nThe machine code has been placed on the clipboard."
	If (!bNotify){
		MsgBox, 0x44, MCodeGen, %s%`n`nWould you like to see the log?
		IfMsgBox, Yes
			Run, out.txt
	} Else {
		TrayTip, MCodeGen, %s%,, 1
		Sleep, 5000
	}
	
	If (iParamCount) ;Check if we were called from command-line
		ExitApp
Return