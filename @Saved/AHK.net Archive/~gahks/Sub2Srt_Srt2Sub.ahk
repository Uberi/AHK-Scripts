;===============================
; Sub2Srt() 
; Srt2Sub()
;
; MicroDVD (.sub) to SubRip (.srt) 
; and SubRip to MicroDVD
; converter functions.
,
; 2010 by gahks
; http://autohotkey.net/~gahks
; GPL v3
;
; A simple application utilizing these functions
; is also available at the website.
;===============================

Sub2Srt(InputSubtitles,FPS){
   if (!InputSubtitles)
      return false
   if (!FPS)
   {
      if (!RegExMatch(SubStr(InputSubtitles,1,InStr(InputSubtitles,"`n")-1), "\Q{1}{1}\E([\d]+[.][\d]+)", match))
         return false
      else
         FPS := match1, o_temp := true
   }   
   formatfloat := a_formatfloat
   SetFormat, float, 0.3
   Loop, Parse, InputSubtitles, `r`n
   {
      if (a_index = 1 && o_temp) || (!RegexMatch(a_loopfield, "{(\d+)}{(\d+)}(.*)", match))
         continue
      o_line++ ;line number
      timer_start := match1/FPS ;eg. 3712.123 s
      timer_end := match2/FPS
      StringReplace, o_text, match3, |, `r`n ;line breaks
	  RegExReplace(o_text, "{([a-zA-Z0-9:\$]+)}\s?", "") 
	  ;removing tags --> currently doesn't support converting tags
      Loop, 2
      {
         c_timer := a_index=1 ? "start" : "end" ;timer consists of two parts
         StringSplit, temp, timer_%c_timer%, . ;splitting by the decimal dot
         o_ms_%c_timer% := temp2 ;eg. 123 ms
         o_temp := temp1 ;eg. 3712 s
         ;eg. o_temp/3600 = 1.031
         o_hh_%c_timer% := SubStr(o_temp/3600,1,InStr(o_temp/3600,".")-1) ;eg. 1 h
         o_temp := Mod(o_temp,3600) ;eg. 112 (s)
         ;eg. o_temp/60 = 1.866
         o_mm_%c_timer% := SubStr(o_temp/60,1,InStr(o_temp/60,".")-1) ;eg. 1 m
         o_ss_%c_timer% := Mod(o_temp,60) ;eg. 52 s
         
         ;taking care of single-digit timer parts, applying padding with zeros
         ;eg. 1 h   1 m  52 s    ->    01 h  01 m  52 s
         o_temp = hh|mm|ss
         StringSplit, o_temp, o_temp, |
         Loop, 3
         {
            o_temp := o_temp%a_index%
            o_%o_temp%_%c_timer% := (StrLen(o_%o_temp%_%c_timer%)=1 ? "0" : "") o_%o_temp%_%c_timer%
         }   
      }
   OutputSubtitles .= o_line "`r`n" o_hh_start ":" o_mm_start ":" o_ss_start "," o_ms_start
   .         " --> " o_hh_end ":" o_mm_end ":" o_ss_end "," o_ms_end "`r`n" o_text "`r`n`r`n"
   }
   SetFormat, float, %formatfloat%
   return OutputSubtitles
}

Srt2Sub(InputSubtitles,FPS){
	if (!InputSubtitles) || (!FPS)
		return false
	Loop, Parse, InputSubtitles, `r`n
	{
		if a_loopfield is digit
			Continue ;line numbers discarded
		if RegexMatch(a_loopfield,"(\d+):(\d\d):(\d\d),(\d\d\d)\s-->\s(\d+):(\d\d):(\d\d),(\d\d\d)",match)
		{	
			o_frame_start := (match1*3600)+(match2*60)+match3 "." match4
			o_frame_start *= FPS, o_frame_start := Round(o_frame_start)
			o_frame_end :=  (match5*3600)+(match6*60)+match7 "." match8
			o_frame_end *= FPS, o_frame_end := Round(o_frame_end)
			o_temp .= "`r`n" "{" o_frame_start "}{" o_frame_end "}"
		}
		else
			o_temp .= RegExReplace(a_loopfield, "<([a-zA-Z0-9\\]+)>\s?", "") "|" 
			;removing tags --> currently doesn't support converting tags
	}
	o_temp .= "`r`n" ;an ugly tweak
	;Taking care of the extra "|"-s and line breaks
	Loop, Parse, o_temp, `n
	{
		if a_index=1
			continue ;first line is a line break
		o_temp := ""
		if (SubStr(a_loopfield,-1,1) = "|")
			StringTrimRight, o_temp, a_loopfield, 2 ;extra pipes at the ends of lines
		OutputSubtitles .= (o_temp ? o_temp : a_loopfield) "`r`n"
	}
	return OutputSubtitles
}