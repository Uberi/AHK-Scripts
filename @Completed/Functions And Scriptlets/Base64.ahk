;AHK v1
#NoEnv

;/*
String := "Hello, World!"
Value := Base64Encode(String)
Base64Decode(Output,Value,True)
MsgBox %Value%`n`n%Output%
*/

;binary base64 encode
Base64Encode(ByRef Data,Length = "")
{ ;returns the Base64 encoded version of the input
    static CharSet := "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
    If (Length = "") ;autodetect length if it was not given
        Length := StrLen(Data) << !!A_IsUnicode ;make sure the length is the number of bytes, not the number of characters
    VarSetCapacity(Output,Ceil(Length / 3) << 2) ;set the size of the Base64 output
    Index := 0
    Loop, % Length // 3 ;process 3 bytes per iteration
    {
        ;convert the 3 bytes to 4 Base64 characters
        Value := (NumGet(Data,Index,"UChar") << 16)
               | (NumGet(Data,Index + 1,"UChar") << 8)
               | NumGet(Data,Index + 2,"UChar")
        Index += 3
        Output .= SubStr(CharSet,(Value >> 18) + 1,1)
                . SubStr(CharSet,((Value >> 12) & 63) + 1,1)
                . SubStr(CharSet,((Value >> 6) & 63) + 1,1)
                . SubStr(CharSet,(Value & 63) + 1,1)
    }
    Length := Mod(Length,3) ;determine the number of bytes that remain
    If Length = 0 ;no bytes remaining
        Return, Output
    Value := NumGet(Data,Index,"UChar") << 10
    If Length = 1 ;one byte remains
    {
        Return, Output
                 . SubStr(CharSet,(Value >> 12) + 1,1)
                 . SubStr(CharSet,((Value >> 6) & 63) + 1,1) . "=="
    }

    ;two bytes remain
    Value |= NumGet(Data,Index + 1,"UChar") << 2 ;insert the third byte
    Return, Output
             . SubStr(CharSet,(Value >> 12) + 1,1)
             . SubStr(CharSet,((Value >> 6) & 63) + 1,1)
             . SubStr(CharSet,(Value & 63) + 1,1) . "="
}

;binary base64 decode
Base64Decode(ByRef Data,Code,IsString = False)
{ ;returns the length of the binary buffer
    static CharSet := "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
    Length := StrLen(Code)

    ;remove padding if present
    If SubStr(Code,0) = "="
    {
        If SubStr(Code,-1,1) = "="
            Length -= 2
        Else
            Length --
    }

    BufferSize := Ceil((Length * 3) / 4), VarSetCapacity(Data,BufferSize) ;calculate the correct buffer size
    Index := 1, BinPos := 0
    Loop, % Length >> 2 ;process 4 characters per iteration
    {
        ;decode the characters and store them in the output buffer
        Value := ((InStr(CharSet,SubStr(Code,Index,1),1) - 1) << 18)
               | ((InStr(CharSet,SubStr(Code,Index + 1,1),1) - 1) << 12)
               | ((InStr(CharSet,SubStr(Code,Index + 2,1),1) - 1) << 6)
               | (InStr(CharSet,SubStr(Code,Index + 3,1),1) - 1)
        NumPut(Value >> 16,Data,BinPos,"UChar")
        NumPut((Value >> 8) & 255,Data,BinPos + 1,"UChar")
        NumPut(Value & 255,Data,BinPos + 2,"UChar")
        Index += 4, BinPos += 3
    }
    Length &= 3 ;determine the number of characters that remain
    If Length > 0 ;characters remain
    {
        ;decode the first of the remaining characters and store it in the output buffer
        Value := ((InStr(CharSet,SubStr(Code,Index,1),1) - 1) << 18)
               | ((InStr(CharSet,SubStr(Code,Index + 1,1),1) - 1) << 12)
        NumPut(Value >> 16,Data,BinPos,"UChar")

        ;a second character remains
        If Length = 3
        {
            ;decode the character and store it in the output buffer
            Value |= (InStr(CharSet,SubStr(Code,Index + 2,1),1) - 1) << 6
            NumPut((Value >> 8) & 255,Data,BinPos + 1,"UChar")
        }
    }
    If IsString ;resize the buffer if the output is a string
        VarSetCapacity(Data,-1)
    Return, BufferSize
}

/* ;string based base64 encode
Base64Encode(String)
{
    static CharSet := "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
    VarSetCapacity(Output,Ceil(Length / 3) << 2)
    Index := 1, Length := StrLen(String)
    Loop, % Length // 3
    {
        Value := Asc(SubStr(String,Index,1)) << 16
            | Asc(SubStr(String,Index + 1,1)) << 8
            | Asc(SubStr(String,Index + 2,1))
        Index += 3
        Output .= SubStr(CharSet,(Value >> 18) + 1,1)
            . SubStr(CharSet,((Value >> 12) & 63) + 1,1)
            . SubStr(CharSet,((Value >> 6) & 63) + 1,1)
            . SubStr(CharSet,(Value & 63) + 1,1)
    }
    Length := Mod(Length,3)
    If Length = 0 ;no characters remain
        Return, Output
    Value := Asc(SubStr(String,Index,1)) << 10
    If Length = 1
    {
        Return, Output ;one character remains
            . SubStr(CharSet,(Value >> 12) + 1,1)
            . SubStr(CharSet,((Value >> 6) & 63) + 1,1) . "=="
    }
    Value |= Asc(SubStr(String,Index + 1,1)) << 2 ;insert the third character
    Return, Output ;two characters remain
        . SubStr(CharSet,(Value >> 12) + 1,1)
        . SubStr(CharSet,((Value >> 6) & 63) + 1,1)
        . SubStr(CharSet,(Value & 63) + 1,1) . "="
}
*/

/* ;string based base64 decode
Base64Decode(Code)
{
    static CharSet := "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
    Length := StrLen(Code)

    ;remove padding if present
    If SubStr(Code,0) = "="
    {
        If SubStr(Code,-1,1) = "="
            Length -= 2
        Else
            Length --
    }

    BufferSize := Ceil((Length / 4) * 3), VarSetCapacity(Data,BufferSize) ;calculate the correct buffer size
    Index := 1, BinPos := 0
    Loop, % Length >> 2 ;process 4 characters per iteration
    {
        ;decode the characters and store them in the output buffer
        Value := ((InStr(CharSet,SubStr(Code,Index,1),1) - 1) << 18)
            | ((InStr(CharSet,SubStr(Code,Index + 1,1),1) - 1) << 12)
            | ((InStr(CharSet,SubStr(Code,Index + 2,1),1) - 1) << 6)
            | (InStr(CharSet,SubStr(Code,Index + 3,1),1) - 1)
        Index += 4
        Data .= Chr(Value >> 16) . Chr((Value >> 8) & 255) . Chr(Value & 255)
    }
    Length &= 3 ;determine the number of characters that remain
    If Length > 0 ;characters remain
    {
        ;decode the first of the remaining characters and store it in the output buffer
        Value := ((InStr(CharSet,SubStr(Code,Index,1),1) - 1) << 18)
            | ((InStr(CharSet,SubStr(Code,Index + 1,1),1) - 1) << 12)
        Data .= Chr(Value >> 16)

        ;another character remains
        If Length = 3
        {
            ;decode the character and store it in the output buffer
            Value |= (InStr(CharSet,SubStr(Code,Index + 2,1),1) - 1) << 6
            Data .= Chr((Value >> 8) & 255)
        }
    }
    Return, Data
}
*/