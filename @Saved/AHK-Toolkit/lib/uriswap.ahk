uriSwap(str, action){

    if (action = "e"){
        f := A_FormatInteger
        SetFormat, Integer, hex
        
        ; the next two lines fix some bugs
        ; the first prevents literal hex code embeded in the text to be converted
        ; the next one prevents that a space or any other non word character that ends in 0
        ; converts a normal x into "hex code" e.g. h5 x20 --> h50x20x20 --> the parser sees that as:
        ; h5 (0x2) (0x20) and ends up like: h5%2%20 which is totally incorrect.
        StringReplace, str, str, 0x, ƒ, All ; remove all literal hex code before working.
        StringReplace, str, str, %a_space%x, ¥, All
        
        while (RegExMatch(str, "i)[^\w\.~:\/ƒ¥©]", char))
        {
            nchar := strlen(nchar:=Asc(char))<4 ? regexreplace(nchar,"(0x)(.)","${1}0${2}") : nchar
            StringReplace, str, str, %char%, %nchar%, All
        }

        StringReplace, str, str, 0x, `%, All
        
        ; these next two lines are the opposite of what was made in lines 18-19
        StringReplace, str, str, ƒ, 0x, All ; restore all literal hex code.
        StringReplace, str, str, ¥,%a_space%x, All
        
        SetFormat, Integer, %f%
        Return, str
    }
    
    if (action = "d"){
    
        while (RegExMatch(str, "i)(?<=%)[\da-f]{1,2}", hex))
                StringReplace, str, str, `%%hex%, % Chr("0x" . hex), All

        Return, str
    }
}
