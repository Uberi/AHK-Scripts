; Created by Frankie Bagnardi
; Forum topic: http://www.autohotkey.com/forum/topic74340.html
; Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
; v0.5
class RegEx
{
	Needle := "."
	static EMAIL := "i)(?:\b|^)[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}(?:\b|$)"
	static EMAIL2 := "[a-z0-9!#$%&'*+/=?^_``{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_``"
	. "{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+(?:[A-Z]{2}|com|org|"
	. "net|edu|gov|mil|biz|info|mobi|name|aero|asia|jobs|museum)\b"
	
	__New(N) {
		this.Needle := N
	}
	
	; All matches are stored in a 2-dimentional object
	; The format is MyMatches[Match_Number, Group_Name]
	; In many cases Group_Name is a number
	; When using a named group, e.g., (?P<MyGroupName>pattern), the result
	; will be stored in MyGroupName also
	Match(H, N=-1) {
		If N is number
			If (N = -1)
				N := this.Needle ; Set default
		Matches := {}
		Groups := this.GetGroups(N)
		Pos := 1, Match_ := ""
		While ( Pos := RegExMatch(H, N, Match_, Pos + StrLen(Match_)) )
		{
			MatchIndex := A_Index
			Matches.Count := MatchIndex
			for key, subpat in Groups
			{
				This_Match := Match_%subpat%
				Matches[MatchIndex, key] := This_Match
				subpat_int := subpat+0
				If subpat_int is not Integer
				{
					Matches[MatchIndex, subpat] := This_Match
				}
			}
		}
		return Matches
	}
	
	; MatchCall is a callout function
	; It calls function F each time your needle matches
	;	F can be a string like "MyFuncName", or an object reference, 
	;	e.g., Class.MyFuncName
	;	Do not include the parenthesis and parameters. Use C.F not C.F(Param)
	; Each subpattern is sent as a parameter
	MatchCall(H, F, N=-1) {
		If N is number
			If (N = -1)
				N := this.Needle ; Set default
		If !IsFunc(F)
			return
		If !IsObject(F)
			F := Func(F) ; Make it an object
		G := this.GetGroups(N)
		Pos := 1, M_ := "", Results := {}
		While ( Pos := RegExMatch(H, N, M_, Pos + StrLen(M_)) ) {
			for key, subpat in G
				P_%key% := M_%Subpat%
			R := F.(M_, P_1, P_2, P_3, P_4, P_5, P_6, P_7, P_8
					 , P_9, P_10, P_11, P_12, P_13, P_14, P_15)
			R ? Results.Insert(R)
		}
	}
	
	; This is essentially a one line RegExMatch, as apposed to a command
	; Subpat refers to the numbered or named subpatern to be returned
	;	For example, 1 or MyNamedPattern
	;	Omit this parameter or use "" to return the entire match
	; To capture multiple matches use Match()
	MatchSimple(H, N=-1, Subpat="") {
		If N is number
			If (N = -1)
				N := this.Needle ; Set default
		RegExMatch(H, N, M)
		return M%Subpat%
	}
	
	; Returns true if any mach is found
	; false otherwise
	Test(H, N=-1) {
		If N is number
			If (N = -1)
				N := this.Needle ; Set default
		Return !!RegExMatch(H, N)
	}
	
	; For each match in haystack H with needle N the function F will be called
	; F must either be a function object or the plain text name of a function
	; In your function F the return value will be used as a replacement
	; The first argument is the entire match and the others are the subpatterns
	ReplaceCall(H, F, Start=1, N=-1) {
		If N is number
			If (N = -1)
				N := this.Needle ; Set default
		If !IsFunc(F)
			return
		If !IsObject(F)
			F := Func(F) ; Make it an object
		G := this.GetGroups(N)
		Pos := 1, M_ := "", Result := ""
		While ( Pos := RegExMatch(H, N, M_, Pos + StrLen(M_)) ) {
			for key, subpat in G
				P_%key% := M_%Subpat%
			R := F.(M_, P_1, P_2, P_3, P_4, P_5, P_6, P_7, P_8
					 , P_9, P_10, P_11, P_12, P_13, P_14, P_15)

			; Credit to majkinetor for the next two lines
			Result .= SubStr(H, Start, Pos-Start) . R ; R is the return value
			Start := Pos + StrLen(M_)
		}
		return Result . SubStr(H, Start)
	}
	
	; This more or less clones RegExReplace with the exception of 
	; the parameter order and the following.
	; This may be used as an alis to ReplaceCall.  If you wish to do this, it
	; requires a function object like MyClass.FuncMember and Func("FuncName") provide
	Replace(H, Rep="", byref OutCount="", Limit=-1, StartPos=1, N=-1) {
		If IsFunc(F) && IsObject(F)
			return this.ReplaceCall(H, Rep, N)
		If N is number
			If (N = -1)
				N := this.Needle ; Set default
		return RegExReplace(H, N, Rep, OutCount, Limit, StartPos)
	}
	
	; Return all pattern group in the needle
	; Unnamed subpatterns and named subpatterns will found
	; Results will be returned in an array
	GetGroups(N) {
		Groups := [] ; Array to be returned
		Pos := 0
		Subpat_Needle := "\(\?P<(?P<NamedMatch>.*?)>.*?\)|\(.*?\)"
		Groups.Insert("")
		While ( Pos := RegExMatch(N, Subpat_Needle, Group_, Pos + 1) )
		{
			If Group_NamedMatch
				Groups.Insert(Group_NamedMatch)
			else
				Groups.Insert(A_Index)
		}
		return Groups
	}
	
	; Sanatize a part of a needle to be literal
	; This is most useful when receiving input from the user
	; The following characters are escaped:
	;	\.*?+[{|()^$
	Literal(N) {
		 return RegExReplace(N, "([.*?+[{|()^$\\])", "\$1")
	}
	
	OptionSet(O*) {
		
	}
}