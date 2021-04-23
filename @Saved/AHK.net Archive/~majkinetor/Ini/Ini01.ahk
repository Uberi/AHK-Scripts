; Title:		Ini
;				Helper functions for easier ini file handling
;:
;by majkinetor
;v0.1
;-------------------------------------------------------------------------------------
; Function:		2Var
;				Read content of INI section
;
; Parametesr:
;				pIniFile	-	INI file name
;				pSection	-	Section to read and return as function value.
;							    If equals to empty string (default) all sections will be read and array of globals will be created.
;				pPrefix		-	Prefix to use for globals. The names will be created as %pPrefix%SectionName.
;								Used only when pSection is empty string
;
; Examples:
;>				Ini_2Var("Config.ini")				;read all sections and create array of inis_SectionName variables
;>				Ini_2Var("Config.ini", "", "cfg")	;read all sections and create array of cfg_SectionName variables
;>				Ini_2Var("Config.ini", "Test")		;return section data
;
Ini_2Var( pIniFile, pSection="", pPrefix="INIS_") {
	local sIni,var=0,val,j
	
	FileRead, sIni, *t %pIniFile%
	
	;remove comments & empty Lines
	sIni := RegExReplace(RegExReplace(sIni, "`nm)^;.+\R" ), "`nm)^\n" )

	if pSection=
	Loop{
		j := RegExMatch( sIni, "(?<=\[).+?(?=\])", var)
		if !j
			break
		j := RegExMatch(sIni, "s)(?<=`n)[^[].*?(?=(\R\[)|$)", val)
		if !j
			j := Strlen(var)+3

		%pPrefix%%var% := val
		StringTrimleft, sIni, sIni, j+StrLen(val)
	}
	else {
		j := RegExmatch(sIni, "is)(?<=\Q[" pSection "]\E).+?(?=(?:\R\[)|(?:\s*$))", val)
		if !j
			return

		StringTrimLeft, val, val, InStr(val, "`n")
		return val
	}
}

;-------------------------------------------------------------------------------------
; Function:		Section2Var
;				Read content of INI section or string.
;
; Parametesr:
;				pSection	-	Section string otaining usin 2Var function, or ;IniFileName:Section.
;				pInfo		-	Specify 1 to get only key names separated by new linse or >1 to get key values as the 
;								return value of the function. Default is 0 (create globals for each key)			
;				pPrefix		-	Prefix to use for globals. The globals will be created as %pPrefix%VarName.
;								Used only when pInfo equals to 0.
;
; Examples:
;>				Ini_Section2Var(";Config.ini:Test")		;read all keys from the section Test into globals iniv_IniVar
;>				Ini_Section2Var(pSection, 0, "")		;read all keys from the section string into globals IniVar (no prefix)
;>				Ini_Section2Var(pSection, 1)			;return string containing all section keys
;
Ini_Section2Var( pSection, pInfo=0, pPrefix="INIV_") {
	local j, res, prop
	if (*&pSection = 59)
		j := InStr(pSection, ":"), pSection := Ini_2Var( SubStr(pSection, 2, j-1), SubStr(pSection, j+1) )

    loop, parse, pSection, `n, `r
	{
		j := InStr( A_LoopField, "=" ), prop := SubStr(A_LoopField, 1, j-1)  
	  
		if pInfo=0
			%pPrefix%%prop%:=SubStr(A_LoopField, j+1)
		else res .= pInfo=1 ? prop "`n" : SubStr(A_LoopField, j+1) "`n"
	}
	
	if res !=
		return SubStr(res, 1, -1)
}