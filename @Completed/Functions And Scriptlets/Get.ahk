Get(URL)
{
    WebRequest := ComObjCreate("WinHttp.WinHttpRequest.5.1")
    WebRequest.Open("GET",URL)
    WebRequest.Send()
    Result := WebRequest.ResponseText
    WebRequest := ""
    Return, Result
}