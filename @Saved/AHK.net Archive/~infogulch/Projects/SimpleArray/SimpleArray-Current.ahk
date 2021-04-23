;#########################################################################################
;                               SimpleArray by Infogulch
;#########################################################################################
;               v3.5 : http://www.autohotkey.com/forum/viewtopic.php?p=216134#216134
;#########################################################################################

; 
; Todo: 
;	Count lines executed in each function
; 	Replace values
;	Add recursiveness
; 	Find support negative
; 	Create swap
;	Create shift 
; 	Create unique
; 	Create replace
; 	Add option to Find to include name
; 	Document functions
; 	Create examples/standard test code
; 	

; 
; Changed:
; Element names are forced exclusive
; Optimized SA_EncRE
; Simplified SA_Set, SA_Get, SA_Trim, SA_Del
; Changed paramater order
; 
; Added: SA_Sort, SA_Find, SA_FindCnt, SA_ConvertPsuedo, SA_ConvertDelimited, SA_Join
; (Others for internal use: SA_NameExists, SA_Idx, SA_EleOfPos, SA_Sort_)
;  

; 
; !Important Note:
; ! The nIdx in SA_Set and Idx in SA_Set_ now only accept names or indexes
; ! and the "add to end + option" is now in the opt param:
; ! param, opt:
; ! 	1.specify the first character as the "+" character and Idx will be treated
; ! 	  as an offset from the end, effectifly "push"ing Val
; ! 	2.Specify zero or nothing as the second character to overwrite the element
; ! 	  at Idx position, otherwise any positive number to insert Val into that position
; 

SA_Set( Array, Val, nIdx="1", opt="+1", giveName="" ) {
	If !nIdx := SA_Idx(Array, nIdx)
		return Array
	return SA_Set_( Array, Val, nIdx, opt, giveName )
}
SA_Set_( Array, Val, Idx="1", opt="+1", giveName="" ) { ;only pass an integer for index
	Count := SA_Len(Array)
	If (SubStr(opt, 1, 1) = "+")
		Idx += Count
	Loop % Idx - Count
		Array .= " "
	StringGetPos, lPos, Array,  , % Idx>0 ? "L" Idx-1 : "R" Abs(Idx)
	lStr := SubStr( Array, 1, lPos+ErrorLevel )
	If opt + 0
		rStr := SubStr(Array, lPos+2)
	Else If isNext:=InStr(Array, " ", 0, lPos+2)
		rStr := SubStr(Array, isNext+1)
	return (lStr="" ? "" : lStr " ")
		. (SA_ValidName(giveName) && !SA_NameExists(Array, giveName) ? SA_Enc(giveName) ":" : "") 
		. SA_Enc(Val) 
		. (rStr="" ? "" : " " rStr)
}

SA_Get( Array, nIdx1=1, nIdx2="", nIdx3="", nIdx4="", nIdx5="" ) {
	Loop
		If !nameIdx:=SA_Idx(Array, nIdx%A_Index%)
			Break
		Else
			Array := SA_Get_(Array, nameIdx)
	Return Array
}
SA_Get_( ByRef Array, Idx=1 ) { ;only pass an integer for Idx
	StringGetPos, lPos, Array,  , % Idx>0 ? "L" Idx-1 : "R" Abs(Idx)
	StringGetPos, rPos, Array,  , L1, lPos+1 ; use instr
	If ErrorLevel
		rPos := StrLen(Array)
	lPos += 2
	return SA_Dec( SubStr(Array,lPos, rPos+1 - lPos) )
}

SA_Del( Array, nIdxFm, nIdxTo="", Count=0 ) {
	If !(nIdxFm := SA_Idx(Array, nIdxFm)), nIdxTo := SA_Idx(Array, nIdxTo)
		return Array
	If (!Count && nIdxTo!="") {
		tot := SA_Len( Array )
		cnt := Abs((nIdxTo > 0 ? nIdxTo : tot + nIdxTo + 1)-(nIdxFm > 0 ? nIdxFm : tot + nIdxFm + 1))
	} Else
		cnt := 1
	return SA_Del_( Array, nIdxFm, Count ? Count : cnt )
}
SA_Del_( ByRef Array, IdxFm, cnt=1 ) { ;only pass an integer for Idx
	StringGetPos, lPos, Array,  , % IdxFm >0 ? "L" IdxFm -1 : "R" Abs(IdxFm)
	lStr := SubStr(Array, 1, lPos += ErrorLevel)
	StringGetPos, rPos, Array,  , % "L" cnt+0, lPos + 1
	rStr := !ErrorLevel ? SubStr(Array, rPos+2) : ""
	return lStr (lStr!="" && rStr!="" ? " " : "") rStr
}

SA_Trim( Array, nIdxFm, nIdxTo=-1 ) {
	If !(nIdxFm := SA_Idx(Array, nIdxFm)) || (!nIdxTo := SA_Idx(Array, nIdxTo))
		return Array
	return SA_Trim_( Array, nIdxFm, nIdxTo)
}
SA_Trim_( ByRef Array, IdxFm, IdxTo=-1 ) { ;only pass an integer for Idx
	StringGetPos, lPos, Array,  , % IdxFm > 0 ? "L" IdxFm - 1 : "R" Abs(IdxFm)
	StringGetPos, rPos, Array,  , % IdxTo > 0 ? "L" IdxTo     : "R" Abs(IdxTo) - 1
	return SubStr(Array, lPos+2, rPos - lPos - 1)
}

SA_Len( Array ) { ;Lines: 3
	StringReplace, blank, Array,  ,, UseErrorLevel
	retVal := ErrorLevel + 1
	return retVal, ErrorLevel := 0
}

SA_Sort( Array, options = "" ) { ;Lines: 4
; 
; Sorts Array using autohotkey's built-in search function
;
; Array: a valid SA array
; options: 
; 	Do not specify the delimeter in options ("Dx")
; 
; Returns: A SA array sorted
; ErrorLevel: False
; 
; Max Lines count: 4 (for the two sort functions)
; 
	ErrorLevel := 0
	Sort, Array, F SA_Sort_ %options% D  Z
	return Array
}
SA_Sort_( a, b, o ) { ;Lines: 1
	return ((a := SubStr(a, InStr(a,":")+1)) = (b := SubStr(b, InStr(b,":")+1)) ? 0 : a > b ? 1 : -1)
}

SA_Unique( array, Case = False, Whole = True ) {
	While SA_Len(array) > A_Index
		Loop % SA_FindCnt( array, Str := SA_Get( array, A_Index ), Case ) - 1
			array := SA_Del_( array, SA_Find( array, Str, 2, Case ) )
	return array
}

SA_Shift( Array, nIdxFm, nIdxTo ) {
	If !(nIdxFm := SA_Idx(Array, nIdxFm)) || !(nIdxTo := SA_Idx(Array, nIdxTo))
		return Array, ErrorLevel := True
	ele := SA_Get_( Array, nIdxFm ), name := SA_NameIdx( Array, nIdxFm )
	Array := SA_Del_( Array, nIdxFm )
	Array := SA_Set_( Array, ele, nIdxTo - (nIdxFm > nIdxTo), True, name)
	return Array, ErrorLevel := False
}
SA_Swap( Array, nIdx1, nIdx2 ) {
	If !(nIdx1 := SA_Idx(Array, nIdx1)) || !(nIdx2 := SA_Idx(Array, nIdx2))
		return Array, ErrorLevel := True
	ele1 := SA_Get_(Array, nIdx1), ele1n := SA_NameIdx(Array, nIdx1)
	ele2 := SA_Get_(Array, nIdx2), ele2n := SA_NameIdx(Array, nIdx2)
	Array := SA_Del_(Array, nIdx1)
	Array := SA_Del_(Array, nIdx2)
	Array := SA_Set_(Array, ele1, nIdx1 > 0 ? nIdx1 : nIdx1 + 1, True, ele1n)
	Array := SA_Set_(Array, ele2, nIdx2 > 0 ? nIdx2 : nIdx2 + 1, True, ele2n)
	return Array, ErrorLevel := False
}

SA_Find( Array, Str, Idx=1, Case = False, Whole = True ) {
; 
; Finds Idx occurence of Str in Array
;
; Array: a valid SA array to search in
; Str: any non-null containing string to search for
; Idx: any non-zero occurence number of Str in Array 
; Case: true if the match is case-sensetive, else false
; Whole: true to match the entire value of the element, else false to be a partial match
; 
; On success: returns the positive element index
;	 ErrorLevel: False
; On Failure: returns 0
;	 ErrorLevel: True
; 
; Max Lines count: 10
; 
	If RegExMatch(Array, (case ? "" : "i") 
	. "SP)(?:[^\x08]*?" (Whole ? "(?:^|\x08)" : "") 
	. "(" SA_EncRE(SA_Enc(str)) "(?=" (!Whole ? "[^:\x08]*" : "") "(?:\x08|$)))){" idx "}"
	, match)
		return SA_EleOfPos( Array, matchPos1 ), ErrorLevel := False
	return 0, ErrorLevel := True
}
SA_FindCnt( Array, Str, Case = False, Whole = True ) { ;Lines: 6
; 
; Finds the number of occurences of Str in Array
; 
; Array: Valid SA array
; Str: the string to search for
; Case: case sensetive search
; 
; Returns: the number of occurences of Str in Array
; Errorlevel: the RegExReplace errorlevel
; 
; Max Lines Count: 6
; 
	return cnt, RegExReplace(Array, (case ? "" : "i") 
	. "S)" (Whole ? "(?<=\x08)" : "")
	. "(" SA_EncRE(SA_Enc(str)) "(?=" (!Whole ? "[^:\x08]*" : "") "(?:\x08|$)))", "", cnt)
}

SA_ConvertPsuedo( SA_AName, SA_Dims, SA_Sep = "" ) {
; 
; Converts a global-scope autohotkey array into a valid SA array
;
; SA_AName: The global variable name of the psuedo-array
; 	May not begin with "SA_"
; 	Note: this is NOT a SA array, the the SA_ prefix is for variable compatibility only
; SA_Dims: A comma-delimited list of dimention sizes in descending order
; SA_Sep: The seperator character between dimentions of SA_AName
; 
; Returns: a valid SA array from the psuedo-array
; ErrorLevel: not modified
; 
	Local SA_Ret, SA_IsLast, SA_Dims1, SA_Pos
	If (SA_Pos := InStr(SA_Dims, ","))
		SA_Dims1 := SubStr(SA_Dims, 1, SA_Pos - 1), SA_Dims := SubStr(SA_Dims, SA_Pos + 1)
	Else
		SA_Dims1 := SA_Dims, SA_Dims := ""
	Loop % SA_Dims1
		SA_Ret := SA_Set( SA_Ret, SA_Dims = ""
			? %SA_AName%%A_Index% 
			: SA_ConvertPsuedo(SA_AName A_Index SA_Sep, SA_Dims, SA_Sep))
	return SA_Ret
}
SA_ConvertDelimited( String, d ) {
; 
; Converts a character delimited string into a SA array
; 
; String: 
; d: 
; 
; Returns: A SA array derived from the string
; ErrorLevel: Not modified
; 
	Loop, Parse, String, % (SubStr(d, 1, 1), d := SubStr(d, 2), len := StrLen(d))
      ret := SA_Set(ret, len ? SA_ConvertDelimited(A_LoopField, d) : A_LoopField)
	return ret
}
SA_Join( Array, joins ) {
; 
; Joins the elements of Array with joinStr
; 
; Array: A valid SA array
; joinStr: the string to put between each element
; 
; Returns: the array with each element decoded and seperated with joinStr
; ErrorLevel: the number of elements joined
; 
	j := SubStr(joins, 1, 1), joins := SubStr(joins, 2), l := StrLen(joins)
	Loop % len := SA_Len(Array)
		ret .= (A_Index = 1 ? "" : j) (l ? SA_Join( SA_Get_( Array, A_Index ), joins ) : SA_Get_( Array, A_Index ))
	return ret, ErrorLevel := len
}

;#########################################################################################
; These functions are used internally:
;#########################################################################################

SA_NameExists( Array, Name ) {
	return !!InStr(Array, SA_Enc(Name) ":")
}

SA_IdxName( Array, Name ) { ;Lines: 10
; 
; Finds the element index of Name in Array
; 
; Array: A valid SA array
; Name: the name of the element
; 
; On Success:
; 	Returns: Element index of name in array
; 	ErrorLevel: False
; On Failure:
; 	Return blank
; 	ErrorLevel: True
; 
; Max Lines count: 10
; 
	If Pos := RegExMatch(Array, "(^| )" SA_EncRE(SA_Enc(Name)) ":")
		return SA_EleOfPos( Array, Pos )
	return "", ErrorLevel := True
}
SA_NameIdx( Array, Idx ) { ;Lines: 13
; 
; returns the name (if any) of Idx as a string
; 
; Max Lines count: 13
; 
	If !(Idx + 0)
		return
	StringGetPos, lPos, Array,  , % Idx>0 ? "L" Idx-1 : "R" Abs(Idx)
	StringGetPos, rPos, Array,  , L1, lPos+1 ; use instr
	If ErrorLevel
		rPos := StrLen(Array)
	lPos += 2
	Ele := SubStr(Array, lPos, rPos+1 - lPos)
	return SA_Dec( SubStr(SubStr(Ele, 1, InStr( Ele, ":" )), 1, -1) )
}
SA_Idx( Array, nIdx ) { ;Lines: 12
; 
; Gets the index of nIdx
; 
; Array: A valid SA array
; nIdx: A name or index of an element in Array
; 
; Success:
; 	Determined: nIdx exists as a name or nIdx is not zero
; 	Returns: A positive or negative numeric index
; 	ErrorLevel: False
; On Failure:
; 	Returns: Blank
; 	ErrorLevel: True
; 
; Max Lines count: 12
; 
	return SA_ValidName( nIdx ) ? SA_IdxName( Array, nIdx ) : (nIdx = 0 ? "" : nIdx, ErrorLevel := nIdx = 0)
}

SA_EleOfPos( Array, Pos ) { ;Lines: 3
; 
; Returns the element index where Pos occurs in Array
; 
; Array: Valid SA array
; Pos: Character offset
; 
; Max Lines count: 3
; 
	Array := SubStr(Array, 1, pos)
	StringReplace, Array, Array,  ,, UseErrorLevel
	return ErrorLevel + 1, ErrorLevel := 0
}

SA_Dec( x ) { ;Lines: 5
; returns a value ready to be used outside the array by decoding characters encoded earlier and removing any names
	x  :=   SubStr(x, InStr(x,":")+1) ; remove name
	StringReplace, x, x,  n,  :, All ; n(ame char)
	StringReplace, x, x,  d,   , All ; d(elimeter char)
	StringReplace, x, x,  e,  , All ; e(ncoding char)
	return x
}
SA_Enc( x ) { ;Lines: 4
; returns a value ready to be used as an element or name
	StringReplace, x, x,  ,  e, All ; e(ncoding char)
	StringReplace, x, x,   ,  d, All ; d(elimeter char)
	StringReplace, x, x,  :,  n, All ; n(ame of value)
	return x
}
SA_EncRE( x ) { ;Lines: 1
	return RegExReplace(x, "S)([\\\.\*\?\+\[\]\{\}\|\(\)\^\$])", "\$1")
}

SA_ValidName( x ) { ;Lines: 1
; returns true if the value passed is acceptable as a name
	return x + 0 = "" && !!x  ;not a number and non-blank
}
