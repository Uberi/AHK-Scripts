#NoEnv
;Parameters
infile := "WinCrypt.h"
outfile := "CryptConst1.ahk"
func_name := "CryptConst"
include_comments := 0

;---------------
f_in := FileOpen(infile,"r","CP0")
if !isObject(f_in)
{
	msgbox fail to open in file
	return
}
f_out := FileOpen(outfile,"w")
if !isObject(f_out)
{
	msgbox fail to open out file
	return
}
f_out.Write(func_name . "(name)`n{`n")
FileBuf := f_in.Read()
f_in.close()
add_next_string := 0
box_comment := 0
box_struct := 0
vars_list =
cur_struct =
cur_struct_aliases =
sc := 0
get_aliases := 0
loop,parse, FileBuf,`n,%A_Tab%%A_Space%
{
	if (A_LoopField = "")
		continue
	line := A_LoopField
	if box_struct																;if parsing the struct
	{
		if RegExMatch(line,"^\s*{\s*$")											;skip open bracer alone on line
			continue
		if RegExMatch(line,"^\s*(union|struct)\s*{\s*$")						;if struct contains unions - increasing some counter to use later
			sc++
		if (RegExMatch(line,"^\s*}\s*\K.*",aliases) || get_aliases)				;if "}" found at the beginning of line
		{
			if (sc > 0)															;if we had a unions before - skip that "}" symbol
			{
				cur_struct .= line . "`n"
				sc--
				continue
			}
			if !RegExMatch(line,";\s*$")										;the end of struct definition - cheking if that line ends with ";"
				get_aliases := 1												;if not - continue getting structs aliases on next line
			else
				get_aliases := 0
			if !aliases
				aliases := line
			StringSplit,al,aliases,`,,%A_Tab%%A_Space%
			loop, %al0%
				if RegExMatch(al%A_Index%,"^\w+$")
					cur_struct_aliases .= " := " al%A_Index%
			if !get_aliases														;end of struct parsing
			{
				box_struct := 0
				cur_struct := cur_struct_aliases " := ""`n" . RegExReplace(cur_struct,"""","'") . ")""`n"
				f_out.Write(cur_struct . "`n")
				cur_struct =
				cur_struct_aliases =
				sc := 0
			}
		}
		else
			cur_struct .= line . "`n"
		continue
	}
	;Comments translation
	StringReplace, line, line, //, `;,1										;replacing all C comments // syntax with ahk syntax
	line := RegExReplace(line,"/\*(?=.*?\*/)",";")							;replacing all C on-line box comments /* with ;
	line := RegExReplace(line,".+?\K/\*(?=.*)",";")							;replacing all C on-line box comments /* with ;
	if (include_comments && !box_comment && RegExMatch(line,"^\s*;"))		;if line is whole - comment, add it and continue
		f_out.Write(line),continue
	if box_comment
	{
		if RegExMatch(line,".*\*/\s*$")										;end of box comment
			line := RegExReplace(line,".*?\K\*/\s*$","`n*/`n"),box_comment := 0	;replacing with ahk-like end of box comment
		f_out.Write(line)
		continue
	}	
	if (include_comments && RegExMatch(line,"^\s*/\*(?!.*?\*/)"))			;if line is start of box comment like /*
			f_out.Write(line),box_comment := 1,continue
	;---------------------------
	if add_next_string														;if current line - continuation of previous
	{
		if !ParseValue(line,HasNext)
			continue
		if HasNext
		{
			prev_string .= RegExReplace(line,"^\s*(?=.*)"," ")				;adding that string to previous removing all preceding spaces
			continue
		}
		add_next_string := 0
		f_out.Write(prev_string . RegExReplace(line,"^\s*(?=.*)"," "))		;writing previous string + current(removing all preceding extra spaces)
		prev_string =
		continue
	}
	if RegExMatch(line,"^\s*#define\s+\K[^()\s]+?\s+.+",result)			;check if this is #define string with one variable(name must exclude bracers() and spaces) and value with at least one space between
	{
		if RegExMatch(result,"{|}")											;if value contains {} symbols - skip that string
			continue
		if RegExMatch(result,"^[^()\s]+?(?=\s+.+)",var_name)				;getting variable name from result string
			IfInString, vars_list,% "|" . var_name . "|"					;checking if that var name already been parsed to avoid dubls
				continue
			else 
				vars_list .= "|" . var_name . "|"							;adding var name to list
		RegExMatch(result,"^[^()\s]+?\s+\K.+",value)						;getting variable's value from result string
		if !ParseValue(value,HasNext)
			continue
		if HasNext															;if value is continued on next line
		{
			prev_string := var_name . " := " value
			add_next_string := 1
		}
		else
			f_out.Write(var_name . " := " value)
	}
	if RegExMatch(line,"^\s*typedef\s*struct\s*_?\K\w+(?=\s*({\s*$|\s*$))",fsname)	;oh yeah, it's struct here, i can't believe...
	{
		;~ msgbox % line "`n" fsname
		box_struct := 1															;variable indication that we parsing a struct
		cur_struct_aliases .= fsname											;getting the first alias for current struct
		cur_struct .= "(`n"														;the beginning of struct itself
		continue
	}
}
t = 																		;a final part of code
(
	StringReplace,name,name,``n,``,,1				;replacing new lines with comma
	IfInString, name,,
	{
		arr := {}
		StringSplit,const,name,``,,`%A_TAB`%`%A_SPACE`%``n
		loop,`%const0`%
		{
			v := const`%A_Index`%
			if !v
				continue
			arr[v] := `%v`%
		}
		return arr
	}
	else
	{
		p := `%name`%
		if (p = "")
			p = err
		return p
	}
}
;usage example
msgbox `% %func_name%("TIMESTAMP_NO_AUTH_RETRIEVAL")
;or you can get array of constants at once by passing comma delimited list
k = 
`(
TIMESTAMP_NO_AUTH_RETRIEVAL,TIMESTAMP_DONT_HASH_DATA
TIMESTAMP_VERIFY_CONTEXT_SIGNATURE,CRYPT_TIMESTAMP_PARA
`)
array := CryptConst(k)
msgbox `% array.TIMESTAMP_VERIFY_CONTEXT_SIGNATURE
)
f_out.Write(t)
f_out.close()
msgbox % "Done!"

;return 0 to skip current line and continue
ParseValue(ByRef value,ByRef HasNext)
{
	HasNext := 0
	qr = \\\\(?=.*?")													;query for replacing occurances of \\ in C strings by single \
	if RegExMatch(value,"\\\s*$")										;check if string contain continuation \ symbol at the end
	{
		value := RegExReplace(value,"\s*\\\s*$"," ")					;removing that symbol and all spaces					
		HasNext := 1
	}
	if RegExMatch(value,"\w+\(.*?\)(\s+|$)")							;excluding values like function calls MACRO(x)
		return 0
	value := RegExReplace(value,"L(?="".*"")")							;removing L symbols from C strings like L"some c string"
	value := RegExReplace(value,"[\dABCDEF]\KL(?=(\s+|$|\)))")			;removing L after digit like 0x0001L
	value := RegExReplace(value,qr,"\")									;replacing \\ with \ in strings
	return 1
}