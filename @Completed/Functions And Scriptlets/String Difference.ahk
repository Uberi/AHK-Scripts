#NoEnv

;MsgBox % TextDifference3("To","Ostrich")

TextDifference(String1,String2)
{ ;Levenshtein distance algorithm, returns distance
 String1Length := StrLen(String1), String2Length := StrLen(String2), d0_0 := 0
 If (String1Length = 0)
  Return, String2Length
 If (String2Length = 0)
  Return, String1Length
 Loop, %String1Length%
  d%A_Index%_0 := A_Index
 Loop, %String2Length%
  d0_%A_Index% := A_Index
 PreviousIndex := 0
 Loop, Parse, String1
 {
  Index := A_Index, LoopField := A_LoopField, PreviousIndex1 := 0
  Loop, Parse, String2
   a := d%PreviousIndex%_%A_Index% + 1, b := d%PreviousIndex%_%PreviousIndex1% + 1, c := d%PreviousIndex%_%PreviousIndex1% + (LoopField != A_LoopField), (b < a) ? (a := b) : "", d := (c < a) ? c : a, d%Index%_%A_Index% := d, PreviousIndex1 ++
  PreviousIndex := Index
 }
 Return, d%String1Length%_%String2Length%
}

TextDifference1(String1,String2,CaseSensitive = 1,MaxOffset = 5)
{ ;SIFT3 algorithm, returns difference between 0 and 1
 If ((CaseSensitive && String1 == String2) || String1 = String2)
  Return, 0
 If (String1 = "" || String2 = "")
  Return, (String1 = String2) ? 0 : 1
 StringSplit, Str1Array, String1
 StringSplit, Str2Array, String2
 Str1ArrayIndex := 1, Str2ArrayIndex := 1, LargestCommonSubstring := 0
 While, (Str1ArrayIndex <= Str1Array0) && (Str2ArrayIndex <= Str2Array0)
 {
  If ((CaseSensitive && Str1Array%Str1ArrayIndex% == Str2Array%Str2ArrayIndex%) || Str1Array%Str1ArrayIndex% = Str2Array%Str2ArrayIndex%)
   LargestCommonSubstring ++
  Else If (Str1Array%Str1ArrayIndex% = Str2Array%Str2ArrayIndex%)
   LargestCommonSubstring += 0.8
  Else Loop, %MaxOffset%
  {
   oi := Str1ArrayIndex + A_Index, pi := Str2ArrayIndex + A_Index
   If (Str1Array%oi% = Str2Array%Str2ArrayIndex% && oi <= n0)
   {
    Str1ArrayIndex := oi, LargestCommonSubstring += (!CaseSensitive || Str1Array%oi% == Str2Array%Str2ArrayIndex%) ? 1 : 0.8
    Break
   }
   If (Str1Array%Str1ArrayIndex% = Str2Array%pi% && pi <= Str2Array0)
   {
    Str2ArrayIndex := pi, LargestCommonSubstring += (!CaseSensitive || Str1Array%Str1ArrayIndex% == Str2Array%pi%) ? 1 : 0.8
    Break
   }
  }
  Str1ArrayIndex ++, Str2ArrayIndex ++
 }
 Return, (((Str1Array0 + Str2Array0) / 2) - LargestCommonSubstring) / ((Str1Array0 > Str2Array0) ? Str1Array0 : Str2Array0)
}

TextDifference2(String1,String2)
{ ;calculates additions needed using a simple scanning strategy, returns distance
 Distance := 0, (String1Len := StrLen(String1)) < (String2Len := StrLen(String2)) ? (ShorterString := String1, LongerString := String2) : (ShorterString := String2, LongerString := String1)
 Loop, Parse, ShorterString
  `(SubStr(LongerString,A_Index,1) != A_LoopField) ? Distance ++
 Return, Distance + Abs(String1Len - String2Len)
}

TextDifference3(String1,String2)
{ ;Damerau Levenshtein distance algorithm, returns distance
 String1Len := StrLen(String1), String2Len := StrLen(String2)
 IfEqual, String1Len, 0, Return, String2Len
 IfEqual, String2Len, 0, Return, String1Len
 String1Len > String2Len ? (Temp1 := String1, String1 := String2, String2 := Temp1, Temp1 := String2Len, String2Len := String1Len, String1Len := Temp1)
 Loop, % String1Len + 1
  d0_%A_Index% := A_Index
 Loop, % String2Len + 1
  d%A_Index%_0 := A_Index
 ix := 0, iy := -1, d0_0 := 0
 Loop, Parse, String1
 {
  sc := A_LoopField, i := A_Index, jx := 0, jy := -1
  Loop, Parse, String2
   a := d%ix%_%jx% + 1, b := d%i%_%jx% + 1, c := (A_LoopField != sc) + d%ix%_%jx%, d%i%_%A_Index% := d := a < b ? a < c ? a : c : b < c ? b : c, i > 1 && A_Index > 1 && sc == tx && sx == A_LoopField ? d%i%_%A_Index% := d < c += d%iy%_%ix% ? d : c, jx ++, jy ++, tx := A_LoopField
  ix ++, iy ++, sx := A_LoopField
 }
 Return, d%String1Len%_%String2Len%
}

TextDifference4(String1,String2,MaxOffset = 5)
{ ;Simple scanning with offset, returns distance
 LowestDistance := 0, (ShortLen := StrLen(String1)) < (LongLen := StrLen(String2)) ? (ShorterString := String1, LongerString := String2) : (ShorterString := String2, LongerString := String1, Temp1 := ShortLen, ShortLen := LongLen, LongLen := Temp1), Temp1 := LongLen - 1, MaxOffset := (MaxOffset > Temp1) ? Temp1 : MaxOffset
 Loop, %MaxOffset%
 {
  TempLongerString := SubStr(LongerString,A_Index), Distance := 0
  Loop, Parse, ShorterString
   SubStr(TempLongerString,A_Index,1) <> A_LoopField ? Distance ++
  % (Distance < LowestDistance || A_Index = 1) ? LowestDistance := Distance
 }
 Return, LowestDistance + (LongLen - ShortLen)
}