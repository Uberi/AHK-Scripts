/*
======================================================================================================================================================
							[    AHKArray Version 5.38   ]
							[     Make 2007:0617:1255    ]
							[  Compatible With 5.00 &Up  ]
							[ Created by Oleg Lokhvitsky ]
							[        No Copyright        ]
							[ Please Send All Bugs Found ]
							[    To: olegbl@gmail.com    ]
							[         Thank You!         ]
======================================================================================================================================================
[ Availiable Features - Development Checklist ]
	[ General Functions ]	; USED BY USER
		01. [X] NewArray		[0 bugs known]	[0 bugs fixed]
		02. [X] Size			[0 bugs known]	[1 bugs fixed]
		03. [X] Add			[0 bugs known]	[6 bugs fixed]
		04. [X] Get			[0 bugs known]	[1 bugs fixed]
		05. [X] Remove			[0 bugs known]	[0 bugs fixed]
		06. [X] Set			[0 bugs known]	[0 bugs fixed]
		07. [X] Split			[0 bugs known]	[2 bugs fixed]
		08. [X] Convert			[0 bugs known]	[1 bugs fixed]
		09. [X] Sort			[0 bugs known]	[5 bugs fixed]
		10. [X] Swap			[0 bugs known]	[0 bugs fixed]
		11. [X] Find			[0 bugs known]	[0 bugs fixed]
		12. [X] Minimum			[0 bugs known]	[0 bugs fixed]
		13. [X] Maximum			[0 bugs known]	[0 bugs fixed]
		14. [X] Reverse			[0 bugs known]	[1 bugs fixed]
		15. [X] Trim			[0 bugs known]	[0 bugs fixed]
		16. [X] Merge			[0 bugs known]	[1 bugs fixed]
		17. [X] String			[0 bugs known]	[0 bugs fixed]
		18. [ ] Compare			[0 bugs known]	[0 bugs fixed]	; Needs Documentation	;Compare by Size & Values[numberical+alphabetical] ;Choice of priority of comparison method
	[ Utility Functions ]	; USED BY OTHER FUNCTIONS
		01. [X] Open			[0 bugs known]	[0 bugs fixed]
		02. [X] Close			[0 bugs known]	[0 bugs fixed]
		03. [X] GetFirstDimension	[0 bugs known]	[4 bugs fixed]
		04. [X] GetDimension		[0 bugs known]	[2 bugs fixed]
		05. [X] ParseFirst		[0 bugs known]	[4 bugs fixed]
		06. [X] Parse			[0 bugs known]	[0 bugs fixed]
		07. [X] Unparse			[0 bugs known]	[2 bugs fixed]
		08. [X] Floor			[0 bugs known]	[0 bugs fixed]
		09. [X] Abs			[0 bugs known]	[0 bugs fixed]
		10. [X] CharToHex		[0 bugs known]	[0 bugs fixed]
		11. [X] CharFromHex		[0 bugs known]	[0 bugs fixed]
		12. [X] Hex			[0 bugs known]	[2 bugs fixed]
		13. [X] GetSimple		[0 bugs known]	[2 bugs fixed]
	[ Debug Functions ]	; USED BY OTHER FUNCTIONS IN CASE USER DOES SOMETHING WRONG (OR I MESS UP =P)
		01. [X] Error			[0 bugs known]	[0 bugs fixed]
		02. [X] IsArray			[0 bugs known]	[0 bugs fixed]
	[ Various Features ]	; COOL LITTLE FEATURES OF AHKARRAY
		[X] Free-Style Array Creation
			~ For Hex-Mode use { Array := AHKANewArray("1,2,31&32,4", ",") } but only with ONE dimension
			~ For Non-Hex-Mode use { Array := "[1,2,[31,32],4]" }
		[X] Full Multidimensional Support
			~ [00,10,[20,[21,[22,23],24],25,26],AE,BF,[CD,1D,5A],7F]
		[X] HEX Data Storage
			~ Needs more testing
	[ Documentation ]	; SO THE USER KNOWS HOW TO USE THIS
		Please check the thread on the autohotkey.com forum for documentation.
		[ http://www.autohotkey.com/forum/viewtopic.php?t=14881 ]
	[ To-Do List - By Priority]
		~ Keep fixing more bugs
		~ Keep adding more functions
		~ Add "AHKA" prefix to all local (+global where they exist) variables (just in case) for compatibility
		~ Add more extensive error support, such as Index out of bounds message (instead of just returning 0)
		~ Overload some functions such as Merge to allow a bunch of stuff to be added
======================================================================================================================================================
[                        Starting with v5.35, all characters may be used inside AHKArrays as data can be stored in HEX format                        ]
======================================================================================================================================================
*/
; === === === ERROR & DEBUG SUPPORT === === ===
	AHKAError(Err="")
	{
		MsgBox,An error occured while working with an AHKA Array!`r`n%Err%
	}
	AHKAIsArray(Array)
	{
		AHKA_SYMBOL_LEFT	:= "["
		AHKA_SYMBOL_RIGHT	:= "]"
		if not SubStr(Array,1,1)=AHKA_SYMBOL_LEFT
		{
			return false
		}
		if not SubStr(Array,0,1)=AHKA_SYMBOL_RIGHT
		{
			return false
		}
		return true
	}
; === === === ARRAY SYNTAX SUPPORT === === ===
	AHKANewArray(String="",Splitter="")
	{
		if String=
			return "[]"
		else
			return AHKASplit(String,Splitter)
	}
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
				NArray := AHKAAdd(NArray,AHKAGetDimension(OArray,C),0,0)
				C++
			}
			else
			{
				NArray := AHKAAdd(NArray,A_LoopField,0,0)
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
	AHKAFloor(number)
	{
		if number=0
			return 0
		newnumber := 0
		if number<0
		{
			Loop
			{
				if newnumber>%number%
					newnumber--
				else
					return newnumber
			}
		}
		if number>0
		{
			Loop
			{
				if newnumber<%number%
					newnumber++
				else
					return --newnumber
			}
		}
	}
	AHKAAbs(number)
	{
		if number=0
			return 0
		if number<0
			return -number
		if number>0
			return number
	}
	AHKAHex(String,Way,Enabled=true)
	{
		if Enabled
		{
			if Way=1	; TO HEX
			{
				String2 := ""
				Loop, Parse, String
				{
					String2 := String2 . AHKACharToHex(A_LoopField)
				}
				return String2
			}
			else if Way=0	; FROM HEX
			{
				String2 := ""
				a := 0
				b := ""
				Loop, Parse, String
				{
					if a=0
					{
						b := A_LoopField
						a := "1"
					}
					else if a=1
					{
						b := b . A_LoopField
						a := "0"
						String2 := String2 . AHKACharFromHex(b)
					}
				}
				return String2
			}
			else
			{
				return String
			}
		}
		else
		{
			return String
		}
	}
	AHKACharToHex(String)
	{
		length := StrLen(String)
		if length!=1
		{
			return ""
		}
		else
		{
			Transform, c1, Asc, %String%
			c3 := c1	;modulus
			c2 := "0"	;division
			Loop
			{
				if c3<16
					break
				else
				{
					c3-=16
					c2++
				}
			}
			if c2>15
				c2:="15"
			if c2<0
				c2:="0"
			if c3>15
				c3:="15"
			if c3<0
				c3:="0"
			if c2=10
				c2:="A"
			if c2=11
				c2:="B"
			if c2=12
				c2:="C"
			if c2=13
				c2:="D"
			if c2=14
				c2:="E"
			if c2=15
				c2:="F"
			if c3=10
				c3:="A"
			if c3=11
				c3:="B"
			if c3=12
				c3:="C"
			if c3=13
				c3:="D"
			if c3=14
				c3:="E"
			if c3=15
				c3:="F"
			
			ret := "" . c2 . "" . c3
			;MsgBox, %ret%
			return ret
		}
	}
	AHKACharFromHex(String)
	{
		length := StrLen(String)
		if length!=2
		{
			return ""
		}
		else
		{
			c1 := SubStr(String,1,1)
			if c1=A
				c1:="10"
			if c1=B
				c1:="11"
			if c1=C
				c1:="12"
			if c1=D
				c1:="13"
			if c1=E
				c1:="14"
			if c1=F
				c1:="15"
			if c1>15
				c1:="15"
			if c1<0
				c1:="0"
				
			c2 := SubStr(String,2,1)
			if c2=A
				c2:="10"
			if c2=B
				c2:="11"
			if c2=C
				c2:="12"
			if c2=D
				c2:="13"
			if c2=E
				c2:="14"
			if c2=F
				c2:="15"
			if c2>15
				c2:="15"
			if c2<0
				c2:="0"
				
			c3 := c1*16+c2
			Transform, c4, Chr, %c3%
			return c4
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
	AHKAAdd(Array,Value,Index=0,HexIt=1)
	{
		t := AHKAIsArray(Value)
		;MsgBox, AddingA %Value%
		if HexIt=1
			if not t
				Value := AHKAHex(Value,1)
		;MsgBox, AddingB %Value%
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
					NArray := AHKAAdd(NArray,Value,0,0)
				}
				NArray := AHKAAdd(NArray,A_LoopField,0,0)
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
					NArray := AHKAAdd(NArray,Value,0,0)
				}
				NArray := AHKAAdd(NArray,A_LoopField,0,0)
			}
			return AHKAUnparse(NArray,Array)
		}
	}
	AHKAGet(Array,Index1=0,Index2="",Index3="",Index4="",Index5="",Index6="",Index7="",Index8="",Index9="",Index10="")
	{
		Array := AHKAGetSimple(Array,Index1)
		if Index2!=
		{
			if AHKAIsArray(Array)
			{
				Array := AHKAGet(Array,Index2)
			}
		}
		else
		{
			return Array
		}
		if Index2!=
		{
			if AHKAIsArray(Array)
			{
				Array := AHKAGet(Array,Index2)
			}
		}
		else
		{
			return Array
		}
		if Index3!=
		{
			if AHKAIsArray(Array)
			{
				Array := AHKAGet(Array,Index3)
			}
		}
		else
		{
			return Array
		}
		if Index4!=
		{
			if AHKAIsArray(Array)
			{
				Array := AHKAGet(Array,Index4)
			}
		}
		else
		{
			return Array
		}
		if Index5!=
		{
			if AHKAIsArray(Array)
			{
				Array := AHKAGet(Array,Index5)
			}
		}
		else
		{
			return Array
		}
		if Index6!=
		{
			if AHKAIsArray(Array)
			{
				Array := AHKAGet(Array,Index6)
			}
		}
		else
		{
			return Array
		}
		if Index7!=
		{
			if AHKAIsArray(Array)
			{
				Array := AHKAGet(Array,Index7)
			}
		}
		else
		{
			return Array
		}
		if Index8!=
		{
			if AHKAIsArray(Array)
			{
				Array := AHKAGet(Array,Index8)
			}
		}
		else
		{
			return Array
		}
		if Index9!=
		{
			if AHKAIsArray(Array)
			{
				Array := AHKAGet(Array,Index9)
			}
		}
		else
		{
			return Array
		}
		if Index10!=
		{
			if AHKAIsArray(Array)
			{
				Array := AHKAGet(Array,Index10)
			}
		}
		else
		{
			return Array
		}
		return Array
	}
	AHKAGetSimple(Array,Index=0)
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
						return AHKAHex(A_LoopField,0)
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
						return AHKAHex(A_LoopField,0)
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
						return AHKAHex(A_LoopField,0)
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
					NArray := AHKAAdd(NArray,A_LoopField,0,0)
			}
		}
		else if Index>0
		{
			Loop,Parse,TArray,`,
			{
				if not A_Index=Index
					NArray := AHKAAdd(NArray,A_LoopField,0,0)
			}
		}
		else if Index<0
		{
			Length := AHKASize(Array)
			NIndex := Length+Index
			Loop,Parse,TArray,`,
			{
				if not A_Index=NIndex
					NArray := AHKAAdd(NArray,A_LoopField,0,0)
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
					NArray := AHKAAdd(NArray,A_LoopField,0,0)
				else
					NArray := AHKAAdd(NArray,Value)
			}
		}
		else if Index>0
		{
			Loop,Parse,TArray,`,
			{
				if not A_Index=Index
					NArray := AHKAAdd(NArray,A_LoopField,0,0)
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
					NArray := AHKAAdd(NArray,A_LoopField,0,0)
				else
					NArray := AHKAAdd(NArray,Value)
			}
		}
		return AHKAUnparse(NArray,Array)
	}
	AHKASplit(String,Char="",CaseSensitive=false)
	{
		StartingPos := "1"
		Array := AHKANewArray()
		CharLength := StrLen(Char)
		SplitStart := StartingPos - CharLength
		Loop
		{
			OldStart := SplitStart
			Search := OldStart+CharLength
			if Search < 1
				Search = 1
			SplitStart := InStr(String, Char, CaseSensitive, Search)
			if SplitStart = 0
			{
				Array := AHKAAdd(Array,SubStr(String, OldStart+CharLength))
				break
			}
			SplitString := SubStr(String, OldStart+CharLength, SplitStart-(OldStart+CharLength))
			Array := AHKAAdd(Array,SplitString)
		}
		return Array
	}
	AHKAConvert(Var)
	{
		global
		local Length := %Var%
		if Length =
			local Length := %Var%0
		local Array := AHKANewArray()
		Loop, %Length%
		{
			local TempVar := %Var%%A_Index%
			local Array  := AHKAAdd(Array,TempVar)
		}
		return Array
	}
	AHKASort(Tlist, order=1, first=0, last=-1)
	{
		if order!=0
		{
			first--
			last--
		}
		if order<0
			return Tlist
		if order>2
			return Tlist
		list := Tlist
		if last<0
			last := AHKASize(list)-1
		g := first
		h := last
		midIndex := AHKAFloor((first + last)/2)
		dividingValue := AHKAGet(list,midIndex+1)
		Loop
		{
			Loop
			{
				listG := AHKAGet(list,g+1)
				if listG >= %dividingValue%
					break
				else
					g := g+1
			}
			Loop
			{
				listH := AHKAGet(list,h+1)
				if listH <= %dividingValue%
					break
				else
					h := h-1
			}
			if g <= %h%
			{
				list := AHKASwap(list,g+1,h+1)
				g := g+1
				h := h-1
			}
			if g >= %h%
				break
		}
		if h > %first%
			list := AHKASort(list,0,first,h)
		if g < %last%
			list := AHKASort(list,0,g,last)
		if order=0
			return list
		if order=1
			return list
		if order=2
		{
			TempList := AHKATrim(list,first,AHKASize(list)-(last+1))
			TempList := AHKAReverse(TempList)
			TempListS := AHKATrim(list,0,AHKASize(list)-(first))
			TempListE := AHKATrim(list,last+1,0)
			;MsgBox, O=%list%`r`nS=%TempListS%`r`nM=%TempList%`r`nE=%TempListE%
			return AHKAMerge(AHKAMerge(TempListS,TempList),TempListE)
		}
		return Tlist
	}
	AHKASwap(TArray,IndexA=0,IndexB=0)
	{
		Array := TArray
		TempA := AHKAGet(Array,IndexA)
		TempB := AHKAGet(Array,IndexB)
		Array := AHKASet(Array,TempA,IndexB)
		Array := AHKASet(Array,TempB,IndexA)
		return Array
	}
	AHKAFind(TArray,Value,Number=1)
	{
		Array := TArray
		FoundNum := 0
		len := AHKASize(Array)
		AbsNumber := AHKAAbs(number)
		if Number<=0
			AbsNumber++
		Loop
		{
			if A_Index>%len%
				break
			if Number>0
				Temp := AHKAGet(Array,A_Index)
			if Number<=0
				Temp := AHKAGet(Array,len-A_Index+1)
			if Temp=%Value%
			{
				FoundNum++
				if FoundNum=%AbsNumber%
				{
					if Number<=0
						return len - A_Index + 1
					return A_Index
				}
			}
		}
		return 0
	}
	AHKAMinimum(Array)
	{
		SortedArray := AHKASort(Array)
		return AHKAGet(SortedArray,1)
	}
	AHKAMaximum(Array)
	{
		SortedArray := AHKASort(Array)
		return AHKAGet(SortedArray)
	}
	AHKAReverse(Array)
	{
		NewArray := AHKANewArray()
		len := AHKASize(Array)
		Loop, %len%
		{
			NewArray := AHKAAdd(NewArray,AHKAGet(Array,len-A_Index+1))
		}
		return NewArray
	}
	AHKATrim(Array,First=0,Last=0)
	{
		NewArray := AHKANewArray()
		len := AHKASize(Array)
		Last := len-Last
		Loop, %len%
		{
			if A_Index<=%First%
			{
				;DO NOTHING
			}
			else if A_Index>%Last%
			{
				;DO NOTHING
			}
			else
			{
				NewArray := AHKAAdd(NewArray,AHKAGet(Array,A_Index))
			}
		}
		return NewArray
	}
	AHKAMerge(ArrayA,ArrayB)
	{
		AHKA_SYMBOL_SEPARATOR	:= ","
		SizeA := AHKASize(ArrayA)
		SizeB := AHKASize(ArrayB)
		if SizeA=0
			return ArrayB
		if SizeB=0
			return ArrayA
		return AHKAClose(AHKAOpen(ArrayA) . AHKA_SYMBOL_SEPARATOR . AHKAOpen(ArrayB))
	}
	AHKAString(Array)
	{
		Output := ""
		Length := AHKASize(Array)
		Loop, %Length%
		{
			Output := Output . AHKAGet(Array,A_Index)
		}
		return Output
	}