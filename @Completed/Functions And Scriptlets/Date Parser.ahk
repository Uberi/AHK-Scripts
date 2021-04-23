#NoEnv

;MsgBox % DateParse("Saturday, November 27, 2010 12:04:16 AM")

DateParse(OriginalDate)
{
 OriginalDate := RegExReplace(OriginalDate,"S)((?:Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec)\w*)(\s*)(\d{1,2})\b","$3$2$1","",1)
 If RegExMatch(OriginalDate, "iS)^\s*(?:(\d{4})([\s\-:\/])(\d{1,2})\2(\d{1,2}))?(?:\s*[T\s](\d{1,2})([\s\-:\/])(\d{1,2})(?:\6(\d{1,2})\s*(?:(Z)|(\+|\-)?(\d{1,2})\6(\d{1,2})(?:\6(\d{1,2}))?)?)?)?\s*$",i)
  d3 := i1, d2 := i3, d1 := i4, t1 := i5, t2 := i7, t3 := i8
 Else If !RegExMatch(OriginalDate,"S)^\W*(\d{1,2}?)(\d{2})(\d{2}+)?(?:\s*([ap]m))?\W*$",t)
  RegExMatch(OriginalDate,"iS)(\d{1,2})\s*:\s*(\d{1,2})(?:(?:\s*:\s*)(\d{1,2}))?(?:\s*([ap]m))?",t), RegExMatch(OriginalDate,"iS)(?:(\d{1,2}+)[\s\.\-\/,]+)?(\d{1,2}|(?:Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec)\w*)[\s\.\-\/,']+(\d{1,4})",d)
 If d2 Is Not Integer
  d2 := InStr("|Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec|","|" . SubStr(d2,1,3) . "|"), d2 := d2 ? ((d2 // 4) + 1) : A_MM
 !t4 ? t4 := "am" : "", (!d1 ? d1 := A_DD : ""), (d3 ? (Temp1 := 4 - StrLen(d3), (Temp1 ? d3 := SubStr(A_YYYY,1,Temp1) . d3 : "")) : d3 := A_YYYY), ((t4 = "pm") && (t1 < 12)) ? t1 += 12 : ((t4 = "am" && t1 = 12) ? t1 := 0 : ""), FormattedDate := d3 . SubStr("0" . d2,-1) . SubStr("0" . d1,-1) . SubStr("0" . t1,-1) . SubStr("0" . t2,-1) . SubStr("0" . t3,-1)
 If FormattedDate Is Time
  Return, FormattedDate
}