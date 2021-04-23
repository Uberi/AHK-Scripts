;AHK v1.1
#NoEnv

;MsgBox, % ShortenURL("http://www.autohotkey.net/~Uberi/")

ShortenURL(URL)
{
    StringReplace, URL, URL, \, \\, All
    StringReplace, URL, URL, ", \", All
    StringReplace, URL, URL, `b, \b, All
    StringReplace, URL, URL, `f, \f, All
    StringReplace, URL, URL, `n, \n, All
    StringReplace, URL, URL, `r, \r, All
    StringReplace, URL, URL, `t, \t, All

    try
    {
        WebRequest := ComObjCreate("WinHttp.WinHttpRequest.5.1")
        WebRequest.Open("POST", "https://www.googleapis.com/urlshortener/v1/url")
        WebRequest.SetRequestHeader("Content-Type", "application/json")
        WebRequest.Send("{""longUrl"":""" . URL . """}")
        Response := WebRequest.ResponseText
    }
    catch e
        throw Exception("Could not send request.")

    If !RegExMatch(Response,"iS)""id""\s*:\s*""\K[^""]*",Result)
        throw Exception("Could not obtain shortened URL.")

    Return, Result
}