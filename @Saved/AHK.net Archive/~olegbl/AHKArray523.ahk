/*
Make Version : AHKArray.ahk [20070314:2310]
======================================================================================================================================================
							[    AHKArray Version 5.23   ]
							[ Created by Oleg Lokhvitsky ]
							
							[          WARNING!          ]
							[ THIS IS STILL NOT FINISHED ]
							[  THERE ARE SOME BUGS LEFT  ]
							
							[ Please Send All Bugs Found ]
							[    To: olegbl@gmail.com    ]
							[         Thank You!         ]
======================================================================================================================================================
[ Availiable Features - Development Checklist ]
	[ General Functions ]	; USED BY USER
		[X] NewArray		[0 bugs known]	[0 bugs fixed]
		[X] Size		[0 bugs known]	[1 bug  fixed]
		[X] Add			[0 bugs known]	[4 bugs fixed]
		[X] Get			[0 bugs known]	[0 bugs fixed]
		[X] Remove		[0 bugs known]	[0 bugs fixed]
		[X] Set			[0 bugs known]	[0 bugs fixed]
		[X] Split		[0 bugs known]	[0 bugs fixed]
		[X] Convert		[0 bugs known]	[0 bugs fixed]
		[X] Sort		[0 bugs known]	[1 bugs fixed]	; THIS IS CURRENTLY BUBBLE SORT, WILL UPGRADE SORT LATER =)
	[ Utility Functions ]	; USED BY OTHER FUNCTIONS
		[X] Open		[0 bugs known]	[0 bugs fixed]
		[X] Close		[0 bugs known]	[0 bugs fixed]
		[X] GetFirstDimension	[0 bugs known]	[4 bugs fixed]
		[X] GetDimension	[0 bugs known]	[2 bugs fixed]
		[X] ParseFirst		[0 bugs known]	[4 bugs fixed]
		[X] Parse		[0 bugs known]	[0 bugs fixed]
		[X] Unparse		[0 bugs known]	[2 bugs fixed]
	[ Debug Functions ]	; USED BY OTHER FUNCTIONS IN CASE USER DOES SOMETHING WRONG
		[X] Error		[0 bugs known]	[0 bugs fixed]
	[ Various Features ]	; COOL LITTLE FEATURES OF AHKARRAY
		[X] Free-Style Array Creation		( Array := "[1,2,[31,32],4]" )
		[X] Full Multidimensional Support	( Array := "[1,2,[31,[321,[3221,3222],323],33,34],4,5,[61,62,63],7]" )
	[ Documentation ]	; SO THE USER KNOWS HOW TO USE THIS
		Please check the thread on the autohotkey.com forum for documentation. [http://www.autohotkey.com/forum/viewtopic.php?t=14881]
======================================================================================================================================================
[ Reserved Characters, One Per Line. You may not use these as they are part of the AHKA syntax structure ]
	AHKA_SYMBOL_LEFT	:= "[" ;THIS CAN BE CHANGED
	AHKA_SYMBOL_RIGHT	:= "]" ;THIS CAN BE CHANGED
	AHKA_SYMBOL_DIMENSION	:= "|" ;THIS CAN BE CHANGED
	AHKA_SYMBOL_SEPARATOR	:= "," ;THIS CAN NOT BE CHANGED
======================================================================================================================================================
*/
; === === === CONSTRUCTOR SUPPORT === === ===
	AHKANewArray()
	{
		return "[]"
	}
; === === === DEFAULT FUNCTION SUPPORT === === ===
	AHKAOpen(Array)
	{
		AHKA_SYMBOL_LEFT	:= "["
		AHKA_SYMBOL_RIGHT	:= "]"
		if not SubStr(Array,1,1)=AHKA_SYMBOL_LEFT
		{
			AHKAError("Invalid AHKA Array (Starts with " . SubStr(Array,1,1) . " when should start with " . AHKA_SYMBOL_LEFT . " )")
			return ""
		}
		if not SubStr(Array,0,1)=AHKA_SYMBOL_RIGHT
		{
			AHKAError("Invalid AHKA Array (Ends with " . SubStr(Array,0,1) . " when should end with " . AHKA_SYMBOL_RIGHT . " )")
			return ""
		}
		return SubStr(Array,2,-1)
	}
	AHKAClose(Array)
	{
		AHKA_SYMBOL_LEFT	:= "["
		AHKA_SYMBOL_RIGHT	:= "]"
		return AHKA_SYMBOL_LEFT . Array . AHKA_SYMBOL_RIGHT
	}
; === === === ERROR & DEBUG SUPPORT === === ===
	AHKAError(Err)
	{
		MsgBox,Error occured while working with an AHKA Array`r`n%Err%
	}
; === === === MULTI-DIMENSIONAL SUPPORT === === ===
	AHKAParseFirst(Array)
	{
		AHKA_SYMBOL_LEFT	:= "["
		AHKA_SYMBOL_RIGHT	:= "]"
		TArray := AHKAOpen(Array)
		IndexA := InStr(TArray, AHKA_SYMBOL_LEFT)
		if IndexA = 0
			return Array
		IndexT := InStr(TArray, AHKA_SYMBOL_LEFT, false, IndexA+1)
		IndexB := InStr(TArray, AHKA_SYMBOL_RIGHT)
		Loop
		{
			if IndexT > %IndexB%
				break
			if IndexT = 0
				break
			if IndexB = 0
			{
				AHKAError("Invalid AHKA Array (Bad number of Start & End markers)")
				return ""
			}
			IndexT := InStr(TArray, AHKA_SYMBOL_LEFT, false, IndexT+1)
			IndexB := InStr(TArray, AHKA_SYMBOL_RIGHT, false, IndexB+1)
		}
		Ret := AHKA_SYMBOL_LEFT . SubStr(TArray,1,IndexA-1) . "|" . SubStr(TArray,IndexB+1) . AHKA_SYMBOL_RIGHT
		return Ret
	}
	AHKAParse(Array)
	{
		AHKA_SYMBOL_LEFT	:= "["
		AHKA_SYMBOL_RIGHT	:= "]"
		TArray := Array
		Loop
		{
			if InStr(AHKAOpen(TArray), AHKA_SYMBOL_LEFT)=0
				break
			TArray := AHKAParseFirst(TArray)
		}
		return TArray
	}
	AHKAUnparse(Array,OArray)
	{
		AHKA_SYMBOL_DIMENSION	:= "|"
		C := 1
		TArray := AHKAOpen(Array)
		NArray := AHKANewArray()
		Loop, Parse, TArray, `,
		{
			if A_LoopField=%AHKA_SYMBOL_DIMENSION%
			{
				NArray := AHKAAdd(NArray,AHKAGetDimension(OArray,C))
				C++
			}
			else
			{
				NArray := AHKAAdd(NArray,A_LoopField)
			}
		}
		return NArray
	}
	AHKAGetFirstDimension(Array)
	{
		AHKA_SYMBOL_LEFT	:= "["
		AHKA_SYMBOL_RIGHT	:= "]"
		TArray := AHKAOpen(Array)
		IndexA := InStr(TArray, AHKA_SYMBOL_LEFT)
		if IndexA = 0
			return Array
		IndexT := InStr(TArray, AHKA_SYMBOL_LEFT, false, IndexA+1)
		IndexB := InStr(TArray, AHKA_SYMBOL_RIGHT)
		Loop
		{
			if IndexT > %IndexB%
				break
			if IndexT = 0
				break
			if IndexB = 0
			{
				AHKAError("Invalid AHKA Array (Bad number of Start & End markers)")
				return ""
			}
			IndexT := InStr(TArray, AHKA_SYMBOL_LEFT, false, IndexT+1)
			IndexB := InStr(TArray, AHKA_SYMBOL_RIGHT, false, IndexB+1)
		}
		Ret := SubStr(TArray,IndexA,IndexB-IndexA+1)
		return Ret
	}
	AHKAGetDimension(Array,Index=0)
	{
		AHKA_SYMBOL_LEFT	:= "["
		AHKA_SYMBOL_RIGHT	:= "]"
		TArray := Array
		LastDimension := Array
		Loop
		{
			if A_Index=%Index%
				return AHKAGetFirstDimension(TArray)
			if not InStr(AHKAOpen(TArray), AHKA_SYMBOL_LEFT)
				return LastDimension
			LastDimension := AHKAGetFirstDimension(TArray)
			TArray := AHKAParseFirst(TArray)
		}
	}
; === === === MAIN SUPPORT === === ===
	AHKASize(Array)
	{
		TArray := AHKAOpen(AHKAParse(Array))
		C := 0
		Loop, Parse, TArray, `,
		{
			C++
		}
		return C
	}
	AHKAAdd(Array,Value,Index=0)
	{
		BArray := AHKANewArray()
		TArray := AHKAOpen(Array)
		if Array=%BArray%
		{
			return AHKAClose(Value)
		}
		if Index=0
		{
			return AHKAClose(TArray . "," . Value)
		}
		else if Index>0
		{
			TArray := AHKAOpen(AHKAParse(Array))
			NArray := AHKANewArray()
			Loop, Parse, TArray, `,
			{
				if A_Index=%Index%
				{
					NArray := AHKAAdd(NArray,Value)
				}
				NArray := AHKAAdd(NArray,A_LoopField)
			}
			return AHKAUnparse(NArray,Array)
		}
		else if Index<0
		{
			TArray := AHKAOpen(AHKAParse(Array))
			NArray := AHKANewArray()
			Length := AHKASize(Array)
			NIndex := Length + Index + 1
			Loop, Parse, TArray, `,
			{
				if A_Index=%NIndex%
				{
					NArray := AHKAAdd(NArray,Value)
				}
				NArray := AHKAAdd(NArray,A_LoopField)
			}
			return AHKAUnparse(NArray,Array)
		}
	}
	AHKAGet(Array,Index=0)
	{
		AHKA_SYMBOL_DIMENSION	:= "|"
		TArray := AHKAOpen(AHKAParse(Array))
		Inners := 0
		if Index=0
		{
			Length := AHKASize(Array)
			Loop,Parse,TArray,`,
			{
				if A_LoopField=%AHKA_SYMBOL_DIMENSION%
					Inners++
				if A_Index=%Length%
				{
					if A_LoopField=%AHKA_SYMBOL_DIMENSION%
						return AHKAGetDimension(Array,Inners)
					else
						return A_LoopField
				}
			}
		}
		else if Index>0
		{
			Loop,Parse,TArray,`,
			{
				if A_LoopField=%AHKA_SYMBOL_DIMENSION%
					Inners++
				if A_Index=%Index%
				{
					if A_LoopField=%AHKA_SYMBOL_DIMENSION%
						return AHKAGetDimension(Array,Inners)
					else
						return A_LoopField
				}
			}
		}
		else if Index<0
		{
			Length := AHKASize(Array)
			NIndex := Length+Index
			Loop,Parse,TArray,`,
			{
				if A_LoopField=%AHKA_SYMBOL_DIMENSION%
					Inners++
				if A_Index=%NIndex%
				{
					if A_LoopField=%AHKA_SYMBOL_DIMENSION%
						return AHKAGetDimension(Array,Inners)
					else
						return A_LoopField
				}
			}
		}
	}
	AHKARemove(Array,Index=0)
	{
		NArray := AHKANewArray()
		TArray := AHKAOpen(AHKAParse(Array))
		if Index=0
		{
			Length := AHKASize(Array)
			Loop,Parse,TArray,`,
			{
				if not A_Index=Length
					NArray := AHKAAdd(NArray,A_LoopField)
			}
		}
		else if Index>0
		{
			Loop,Parse,TArray,`,
			{
				if not A_Index=Index
					NArray := AHKAAdd(NArray,A_LoopField)
			}
		}
		else if Index<0
		{
			Length := AHKASize(Array)
			NIndex := Length+Index
			Loop,Parse,TArray,`,
			{
				if not A_Index=NIndex
					NArray := AHKAAdd(NArray,A_LoopField)
			}
		}
		return AHKAUnparse(NArray,Array)
	}
	AHKASet(Array,Value,Index=0)
	{
		NArray := AHKANewArray()
		TArray := AHKAOpen(AHKAParse(Array))
		if Index=0
		{
			Length := AHKASize(Array)
			Loop,Parse,TArray,`,
			{
				if not A_Index=Length
					NArray := AHKAAdd(NArray,A_LoopField)
				else
					NArray := AHKAAdd(NArray,Value)
			}
		}
		else if Index>0
		{
			Loop,Parse,TArray,`,
			{
				if not A_Index=Index
					NArray := AHKAAdd(NArray,A_LoopField)
				else
					NArray := AHKAAdd(NArray,Value)
			}
		}
		else if Index<0
		{
			Length := AHKASize(Array)
			NIndex := Length+Index
			Loop,Parse,TArray,`,
			{
				if not A_Index=NIndex
					NArray := AHKAAdd(NArray,A_LoopField)
				else
					NArray := AHKAAdd(NArray,Value)
			}
		}
		return AHKAUnparse(NArray,Array)
	}
	AHKASplit(String,Char)
	{
		/* SPECIAL CHARACTERS SUPPORTED:
			A_Comma = ,
		*/
		Array := AHKANewArray()
		if Char=A_Comma
		{
			Loop, Parse, String, `,
			{
				Array := AHKAAdd(Array,A_LoopField)
			}
		}
		else
		{
			Loop, Parse, String, %Char%
			{
				Array := AHKAAdd(Array,A_LoopField)
			}
		}
		Return Array
	}
	AHKAConvert(Var)
	{
		global
		local Length := %Var%0
		local Array := AHKANewArray()
		Loop, %Length%
		{
			local TempVar := %Var%%A_Index%
			local Array  := AHKAAdd(Array,TempVar)
		}
		Return Array
	}
	AHKASort(IArray) ; INSERTION SORT
	{
		Array := IArray
		
		outer := 0
		Loop
		{
			length := AHKASize(Array)+1
			if outer >= %length%
				break
			inner := 0
			Loop
			{
				length := AHKASize(Array)-outer-1
				if inner >= %length%
					break
				aI := AHKAGet(Array,inner+1)
				aI2 := AHKAGet(Array,inner+1+1)
				if aI > %aI2%
				{
					OA := Array
					Array := AHKASet(Array,aI2,inner+1)
					Array := AHKASet(Array,aI,inner+1+1)
					;MsgBox,%OA%`r`n->`r`n%Array%`r`nOuter[%outer%]`r`nInner[%inner%]`r`nSwap(%aI%,%aI2%)
				}
				inner++
			}
			outer++
		}
		return Array
	}