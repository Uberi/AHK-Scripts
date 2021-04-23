;AHK v1.1
#NoEnv

;MsgBox % FeelingLucky("pillow")

FeelingLucky(Text)
{
    WebRequest := ComObjCreate("WinHttp.WinHttpRequest.5.1")
    WebRequest.Option[6] := False ;WinHttpRequestOption_EnableRedirects

    StringReplace, Text, Text, `%, `%25, All
    FormatInteger := A_FormatInteger, FoundPos := 0
    SetFormat, IntegerFast, Hex
    While, FoundPos := RegExMatch(Text,"S)[^\w-\.~%]",Char,FoundPos + 1)
        StringReplace, Text, Text, %Char%, % "%" . SubStr("0" . SubStr(Asc(Char),3),-1), All
    SetFormat, IntegerFast, %FormatInteger%

    try
    {
        WebRequest.Open("HEAD","http://www.google.com/search?btnI=1&q=" . Text)
        WebRequest.SetRequestHeader("User-Agent","Mozilla/5.0 (Windows NT 6.1)")
        WebRequest.Send()
        Result := WebRequest.GetResponseHeader("Location")
    }
    catch e
        throw Exception("Could not send request.")
    Return, Result
}