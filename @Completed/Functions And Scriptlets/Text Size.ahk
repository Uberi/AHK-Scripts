#NoEnv

/*
TextSize(Width,Height,"Hello","Georgia",12)
MsgBox Width: %Width%`nHeight: %Height%
ExitApp
*/

TextSize(ByRef Width,ByRef Height,Text,Typeface,Size,Italic = 0,Underline = 0,Strikeout = 0)
{
    ;obtain the device context
    hDC := DllCall("GetDC","UPtr",0,"UPtr")
    If !hDC
        throw Exception("Could not obtain device context.")

    ;create the font
    hFont := DllCall("CreateFont"
        ,"Int",Size ;height
        ,"Int",0 ;width
        ,"Int",0 ;angle of string (0.1 degrees)
        ,"Int",0 ;angle of each character (0.1 degrees)
        ,"Int",Weight ;font weight
        ,"UInt",Italic ;font italic
        ,"UInt",Underline ;font underline
        ,"UInt",Strikeout ;font strikeout
        ,"UInt",1 ;DEFAULT_CHARSET: character set
        ,"UInt",0 ;OUT_DEFAULT_PRECIS: output precision
        ,"UInt",0 ;CLIP_DEFAULT_PRECIS: clipping precision
        ,"UInt",4 ;ANTIALIASED_QUALITY: output quality
        ,"UInt",0 ;DEFAULT_PITCH | (FF_DONTCARE << 16): font pitch and family
        ,"Str",Typeface ;typeface name
        ,"UPtr")
    If !hFont
        throw Exception("Could not create font.")

    ;select the font
    hOriginalFont := DllCall("SelectObject","UPtr",hDC,"UPtr",hFont,"UPtr")
    If !hOriginalFont
        throw Exception("Could not select font into device context.")

    ;obtain the text size
    VarSetCapacity(Size,8)
    DllCall("GetTextExtentPoint32","UPtr",hDC,"Str",Text,"Int",StrLen(Text),"UPtr",&Size)
    Width := NumGet(Size,0,"UInt")
    Height := NumGet(Size,4,"UInt")

    ;deselect the font
    If !DllCall("SelectObject","UPtr",hDC,"UPtr",hOriginalFont,"UPtr")
        throw Exception("Could not deselect font from device context.")

    ;delete the font
    If !DllCall("DeleteObject","UPtr",hFont)
        throw Exception("Could not delete font.")

    ;release the device context
    If !DllCall("ReleaseDC","UPtr",0,"UPtr",hDC)
        throw Exception("Could not release device context.")
}