; Part of Sparrow Webserver Core Version 0.1.3
;  - (w) Sep, 23 2008 derRaphael - 
; hkml.helpLibrary v0.2.1

; This needs to be tested with binary raw data
echo(string,length=0) {
	FileAppend,%string%,*
}


; Include the same procedure in the spwaned scrippets as in hkmlParserCore
; for sending WM_COPYMSG
; Note: This style of calling results in serious trouble for AHK
#includeScript %Sparrow[IncludeDir]% "\sparrow.helper.ahk"
