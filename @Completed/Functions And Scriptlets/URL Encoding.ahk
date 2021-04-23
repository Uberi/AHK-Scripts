;AHK v1
#NoEnv

/*
String := "This is a test; this `n% is also -- a test..a!b@c#d$e%f^g&h*i(jk"")l<>?{}|[]\some more symbols``~\""and "
Encoded := URLEncode(String)
Decoded := URLDecode(Encoded)
MsgBox % """" . Decoded . """`n""" . Encoded . """`n" . (Decoded = String)
*/

;MsgBox % URLEncode(Chr(9679))

URLEncode(Text)
{
    StringReplace, Text, Text, `%, `%25, All
    FormatInteger := A_FormatInteger
    SetFormat, IntegerFast, Hex
    FoundPos := 0
    VarSetCapacity(Buffer,5), pBuffer := &Buffer ;4 bytes for largest unicode codepoint plus null terminator
    While, FoundPos := RegExMatch(Text,"S)[^\w-\.~%]",Char,FoundPos + 1) ;find each URL-unsafe character
    {
        Value := Asc(Char)
        If Value > 255 ;multibyte character
        {
            StrPut(Char,pBuffer,"UTF-8") ;convert to UTF-8
            Value := ""
            Loop, % StrPut(Char,"UTF-8") - 1
                Value .= "%" . SubStr("0" . SubStr(NumGet(Buffer,A_Index - 1,"UChar"),3),-1)
            StringReplace, Text, Text, %Char%, %Value%, All
        }
        Else ;normal character
            StringReplace, Text, Text, %Char%, % "%" . SubStr("0" . SubStr(Value,3),-1), All
    }
    SetFormat, IntegerFast, %FormatInteger%
    Return, Text
}

URLDecode(Encoded)
{
    ;StringReplace, Encoded, Encoded, +, %A_Space%, All
    FoundPos := 0
    While, FoundPos := InStr(Encoded,"%",False,FoundPos + 1)
    {
        Value := SubStr(Encoded,FoundPos + 1,2)
        If (Value != "25")
            StringReplace, Encoded, Encoded, `%%Value%, % Chr("0x" . Value), All
    }
    StringReplace, Encoded, Encoded, `%25, `%, All
    Return, Encoded
}