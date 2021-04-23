#NoEnv

/*
A := "x2-y7"
B := "x2-y08"
Value := NaturalCompare(A,B)
If Value = -1
    MsgBox, %A% < %B%
Else If Value = 1
    MsgBox, %A% > %B%
Else
    MsgBox %A% = %B%
ExitApp
*/

NaturalCompare(String1,String2)
{
    Index1 := 1, Index2 := 1
    Loop
    {
        ;skip whitespace
        While, (Character1 := SubStr(String1,Index1,1)) = " " || Character1 = "`t"
            Index1 ++
        While, (Character2 := SubStr(String2,Index2,1)) = " " || Character2 = "`t"
            Index2 ++
        Index1 ++, Index2 ++

        ;check for end of strings
        If (Character1 = "")
        {
            If (Character2 = "")
                Return, 0
            Return, -1
        }
        If (Character2 = "")
            Return, 1

        If InStr("0123456789",Character1) && InStr("0123456789",Character2) ;digit run
        {
            ;digit comparison
            Bias := 0
            Loop
            {
                ;set value bias if lengths are the same
                If Bias = 0
                {
                    If (Character1 < Character2)
                        Bias := -1
                    Else If (Character1 > Character2)
                        Bias := 1
                }

                Character1 := SubStr(String1,Index1,1), Index1 ++
                Character2 := SubStr(String2,Index2,1), Index2 ++

                ;check for end of strings
                If (Character1 = "")
                {
                    If (Character2 = "")
                        Return, Bias
                    Return, -1
                }
                Else If (Character2 = "")
                {
                    If !InStr("0123456789",Character1)
                        Return, -1
                    Return, 1
                }

                ;check for end of digit runs
                If !InStr("0123456789",Character1)
                {
                    If !InStr("0123456789",Character2)
                        Break
                    Return, -1
                }
                Else If !InStr("0123456789",Character2)
                    Return, 1
            }
        }
        Else ;normal comparison
        {
            If (Character1 < Character2)
                Return, -1
            If (Character1 > Character2)
                Return, 1
        }
    }
}