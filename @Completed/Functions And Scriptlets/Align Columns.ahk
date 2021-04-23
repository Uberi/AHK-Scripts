;AHK AHK_L
#NoEnv

/*
Sample = 
(
"John ""Da Man""",Repici,120 Jefferson St.,Riverside, NJ,08075
John,Doe,120 jefferson st.,Riverside, NJ, 08075
Jack,McGinnis,220 hobo Av.,Phila, PA,09119
Stephen,Tyler,"7452 Terrace ""At the Plaza"" road",SomeTown,SD, 91234
,Blankman,,SomeTown, SD, 00298
"Joan ""the bone"", Anne",Jet,"9th, at Terrace plc",Desert City,CO,00123
)
MsgBox % Clipboard := AlignColumns(Sample,"CSV","|","Center")
*/

AlignColumns(Text,Delimiter = "CSV",Separator = "",PadMode = "Left",PadChar = " ",ExtraPadding = 2)
{
    MaxColumnLength := []
    Loop, Parse, Text, `n, `r
    {
        Index := A_Index
        Loop, Parse, A_LoopField, %Delimiter%
        {
            If (Index = 1)
                MaxColumnLength[A_Index] := StrLen(A_LoopField), ColCount := A_Index
            Else
                Temp1 := StrLen(A_LoopField), (Temp1 > MaxColumnLength[A_Index]) ? (MaxColumnLength[A_Index] := Temp1)
        }
    }
    Aligned := ""
    Loop, Parse, Text, `n, `r
    {
        Loop, Parse, A_LoopField, %Delimiter%
        {
            Size := (MaxColumnLength[A_Index] - StrLen(A_LoopField)) + ExtraPadding
            If (A_Index != 1)
                Aligned .= Separator
            If (PadMode = "Left")
            {
                Aligned .= A_LoopField
                If (A_Index != ColCount)
                {
                    Loop, %Size%
                    Aligned .= PadChar
                }
            }
            Else If (PadMode = "Center")
            {
                Loop, % Size // 2
                    Aligned .= PadChar
                Aligned .= A_LoopField
                If (A_Index != ColCount)
                {
                    Loop, % Ceil(Size / 2)
                        Aligned .= PadChar
                }
            }
            Else If (PadMode = "Right")
            {
                Loop, %Size%
                    Aligned .= PadChar
                Aligned .= A_LoopField
            }
        }
        Aligned .= "`n"
    }
    Return, SubStr(Aligned,1,-1)
}