#NoEnv

;/*
MsgBox % HTTPQuery(Result,"https://www.dropbox.com/") . "`n""" . SubStr(Result,1) . """"

;MsgBox % HTTPQuery(Result,"http://127.0.0.1:8888") . "`n""" . SubStr(Result,1) . """"
;MsgBox % HTTPQuery(Result,"http://m.xkcd.com:80/") . "`n""" . SubStr(Result,1) . """"

;httpQueryOps = showheader
;MsgBox % HTTPQuery(Result,"http://checkip.dyndns.com/") . "`n""" . SubStr(Result,1) . """"
*/

HTTPQuery(ByRef Result,URL,POSTData = "",Headers = "",POSTDataLength = "")
{
    ;Currently the verbs showHeader, storeHeader, and updateSize are supported in httpQueryOps. In case you need a different UserAgent, Proxy, ProxyBypass, Referrer, and AcceptType just specify them as global variables. Also if any special Flags are needed such as INTERNET_FLAG_NO_AUTO_REDIRECT or cache handling this might be set using the httpQueryDwFlags variable as global
    global HTTPQueryOps, HTTPAgent, HTTPProxy, HTTPProxyBypass, HTTPQueryReferrer, HTTPQueryAcceptType, HTTPQueryDwFlags, HttpQueryFullSize, HttpQueryHeader, HttpQueryCurrentSize
    CharSize := A_IsUnicode ? 2 : 1, Suffix := A_IsUnicode ? "W" : "A", UPtr := A_PtrSize ? "UPtr" : "UInt", Char := A_IsUnicode ? "UShort" : "UChar", PtrSize := A_PtrSize ? A_PtrSize : 4, StrGetFunc := "StrGet"

    If (HTTPAgent = "")
        HTTPAgent := "AutoHotkeyScript"

    VarSetCapacity(URL_COMPONENTS,(6 * PtrSize) + 36,0), Offset := 0, NumPut(60,URL_COMPONENTS,Offset,"UInt"), Offset += 4
    VarSetCapacity(URLScheme,255,0), NumPut(&URLScheme,URL_COMPONENTS,Offset), Offset += PtrSize, NumPut(255,URL_COMPONENTS,Offset,"UInt"), Offset += 4, NumPut(255,URL_COMPONENTS,Offset,"UInt"), Offset += 4
    VarSetCapacity(URLHostName,1024,0), NumPut(&URLHostName,URL_COMPONENTS,Offset), Offset += PtrSize, NumPut(1024,URL_COMPONENTS,Offset,"UInt"), Offset += 4, NumPut(0xFFFF,URL_COMPONENTS,Offset,"UInt"), Offset += 4
    VarSetCapacity(URLUserName,1024,0), NumPut(&URLUserName,URL_COMPONENTS,Offset), Offset += PtrSize, NumPut(1024,URL_COMPONENTS,Offset,"UInt"), Offset += 4
    VarSetCapacity(URLPassword,1024,0), NumPut(&URLPassword,URL_COMPONENTS,Offset), Offset += PtrSize, NumPut(1024,URL_COMPONENTS,Offset,"UInt"), Offset += 4
    VarSetCapacity(URLPath,1024,0), NumPut(&URLPath,URL_COMPONENTS,Offset), Offset += PtrSize, NumPut(1024,URL_COMPONENTS,Offset,"UInt"), Offset += 4
    VarSetCapacity(URLExtraInfo,1024,0), NumPut(&URLExtraInfo,URL_COMPONENTS,Offset), Offset += PtrSize, NumPut(1024,URL_COMPONENTS,Offset), Offset += 4
    hModule := DllCall("LoadLibrary","Str","WinINet.dll")

    ;split the given URL: extract scheme, user, pass, authority (host), port, path, and query (extrainfo)
    If !DllCall("WinINet\InternetCrackUrl" . Suffix,UPtr,&URL,"UInt",StrLen(URL),"UInt",0,UPtr,&URL_COMPONENTS)
        Return, "Error retrieving URL components."

    ;update variables
    VarSetCapacity(URLScheme,-1), VarSetCapacity(URLHostName,-1), VarSetCapacity(URLUserName,-1), VarSetCapacity(URLPassword,-1), VarSetCapacity(URLPath,-1), VarSetCapacity(URLExtraInfo,-1)
    PortNumber := NumGet(URL_COMPONENTS,24)

    URLPath .= URLExtraInfo

    ;wip: use another way of specifying flags
    ;detect additional Flags
    Flags := HTTPQueryDwFlags

    ;INTERNET_FLAG_SECURE=0x00800000
    ;SECURITY_FLAG_IGNORE_UNKNOWN_CA=0x00000100
    ;SECURITY_FLAG_IGNORE_CERT_DATE_INVALID=0x00002000
    ;SECURITY_FLAG_IGNORE_CERT_CN_INVALID=0x00001000
    ;SECURITY_FLAG_IGNORE_CERT_WRONG_USAGE=0x0000200
    If (URLScheme = "https")
        Flags |= 0x801200 ;INTERNET_FLAG_SECURE | SECURITY_FLAG_IGNORE_CERT_CN_INVALID | SECURITY_FLAG_IGNORE_CERT_WRONG_USAGE

    ;detect unknown or invalid URL
    If (URLScheme = "unknown")
        Return, "Invalid URL."
    hInternet := DllCall("WinINet\InternetOpen" . Suffix,UPtr,&HTTPAgent,"UInt",(HTTPProxy ? 3 : 0),UPtr,&HTTPProxy,UPtr,&HTTPProxyBypass,"UInt",0)
    hConnect := DllCall("WinINet\InternetConnect" . Suffix,UPtr,hInternet,UPtr,&URLHostName,"Int",PortNumber,UPtr,URLUserName ? &URLUserName : 0,UPtr,URLPassword ? &URLPassword : 0,"UInt",3,"UInt",0,"UInt*",0)
    If !hConnect
        Return, "Connection failed."

    ;Select the correct HTTP verb
    If (POSTData = "")
        HTTPVerb := "GET"
    Else
    {
        HTTPVerb := "POST"
        If (Headers = "")
            Headers := "Content-Type: application/x-www-form-urlencoded"
    }

    hRequest := DllCall("WinINet\HttpOpenRequest" . Suffix,UPtr,hConnect,UPtr,&HTTPVerb,UPtr,&URLPath,"Str","HTTP/1.1",UPtr,&HTTPQueryReferrer,UPtr,&HTTPQueryAcceptType,"UInt",Flags,"UInt",0)
    If !hRequest
        Return, "Error opening request."

    If !DllCall("WinINet\HttpSendRequest" . Suffix,UPtr,hRequest,UPtr,&Headers,"Int",-1,UPtr,&POSTData,"UInt",(POSTDataLength = "") ? Strlen(POSTData) : POSTDataLength)
        Return, "Error sending request."

    VarSetCapacity(ReturnedHeaders,512,0), HeaderLen := 512
    Loop, 5
    {
        If (HeaderRequest := DllCall("WinINet\HttpQueryInfo" . Suffix,UPtr,hRequest,UInt,21,UPtr,&ReturnedHeaders,"UInt*",HeaderLen,"UInt",0))
            Break
        VarSetCapacity(ReturnedHeaders,HeaderLen,0)
    }
    Temp1 := 0
    If HeaderRequest
    {
        Loop, % HeaderLen / CharSize
        {
            If !NumGet(ReturnedHeaders,Temp1,Char)
                NumPut(10,ReturnedHeaders,Temp1,Char) ;Asc("`n") = 10
            Temp1 += CharSize
        }
        VarSetCapacity(ReturnedHeaders,-1)
    }
    Else
        Return, "Timed out."

    Loop, Parse, ReturnedHeaders, `n, `r
    {
        RegExMatch(A_LoopField,"S)HTTP/1\.[01]\s+(\d+)",HTTPReturnValue)
        Break
    }

    ;HttpQueryOps handling
    If (HTTPQueryOps <> "")
    {
        IfInString, HTTPQueryOps, ShowHeader ;show all returned headers
            MsgBox, %ReturnedHeaders%
        IfInString, HTTPQueryOps, StoreHeader ;store returned headers in a global variable
            HttpQueryHeader := ReturnedHeaders
        IfInString, HTTPQueryOps, UpdateSize ;store the size of the content in a global variable
        {
            If RegExMatch(A_LoopField,"\nContent-Length:\s*?(\d+)",HeaderSize)
                HttpQueryFullSize := HeaderSize1
            Else
                HttpQueryFullSize := "Size unavailable"
        }
    }

    If HTTPReturnValue1 Not In 100,200,201,202,302
    {
        HTTPReturnCodes := "|100=Continue|101=Switching Protocols|102=Processing (WebDAV) (RFC 2518)|200=OK|201=Created|202=Accepted|203=Non-Authoritative Information|204=No Content|205=Reset Content|206=Partial Content|207=Multi-Status (WebDAV)|300=Multiple Choices|301=Moved Permanently|302=Found|303=See Other|304=Not Modified|305=Use Proxy|306=Switch Proxy|307=Temporary Redirect|400=Bad Request|401=Unauthorized|402=Payment Required|403=Forbidden|404=Not Found|405=Method Not Allowed|406=Not Acceptable|407=Proxy Authentication Required|408=Request Timeout|409=Conflict|410=Gone|411=Length Required|412=Precondition Failed|413=Request Entity Too Large|414=Request-URI Too Long|415=Unsupported Media Type|416=Requested Range Not Satisfiable|417=Expectation Failed|418=I'm a teapot (RFC 2324)|422=Unprocessable Entity (WebDAV) (RFC 4918)|423=Locked (WebDAV) (RFC 4918)|424=Failed Dependency (WebDAV) (RFC 4918)|425=Unordered Collection (RFC 3648)|426=Upgrade Required (RFC 2817)|449=Retry With|500=Internal Server Error|501=Not Implemented|502=Bad Gateway|503=Service Unavailable|504=Gateway Timeout|505=HTTP Version Not Supported|506=Variant Also Negotiates (RFC 2295)|507=Insufficient Storage (WebDAV) (RFC 4918)|509=Bandwidth Limit Exceeded|510=Not Extended (RFC 2774)|"
        Temp1 := InStr(HTTPReturnCodes,"|" . HTTPReturnValue1 . "=")
        If !Temp1
            Return, "Invalid return code"
        Temp1 += StrLen(HTTPReturnValue1) + 2, HTTPMessage := SubStr(HTTPReturnCodes,Temp1,InStr(HTTPReturnCodes,"|",False,Temp1) - Temp1), Result := HTTPReturnValue1 . " " . HTTPMessage
        Return, StrLen(Result)
    }

    TotalSize := 0, BytesRead := 0
    Loop
    {
        VarSetCapacity(Buffer%A_Index%,1024,0)
        ReadFile := DllCall("WinINet\InternetReadFile",UPtr,hRequest,UPtr,&Buffer%A_Index%,"UInt",1024,"UInt*",BytesRead)
        If ReadFile && !BytesRead
            Break
        Else
            TotalSize += BytesRead, SizeArray .= BytesRead . "|"
    }
    If InStr(HTTPQueryOps,"UpdateSize")
        HttpQueryCurrentSize := TotalSize
    SizeArray := SubStr(SizeArray,1,-1)

    VarSetCapacity(Result,TotalSize)
    pData := &Result
    Loop, Parse, SizeArray, |
        DllCall("RtlMoveMemory",UPtr,pData,UPtr,&buffer%A_Index%,"UInt",A_LoopField), pData += A_LoopField

    IsText := RegExMatch(ReturnedHeaders,"iS)\nContent-Type:.*?\btext\b.*?(?:\bcharset=\K[\w-]+|$\K)",CharSet)
    pData := &Result
    ;check for a byte order mark
    If ((NumGet(Result) & 0xFFFFFF) = 0xBFBBEF) ;UTF-8 BOM: EF BB BF
        pData += 3, CharSet := "utf-8"
    Else If (NumGet(Result) & 0xffff) = 0xFEFF ; UTF-16 BOM: FF FE
        pData += 2, CharSet := "utf-16"
    If CharSet In UTF-8,UTF-16
    {
        If IsFunc("StrGet")
            Result := %StrGetFunc%(pData,CharSet)
        Else
        {
            If (CharSet = "utf-8")
            {
                CharCount := DllCall("MultiByteToWideChar","UInt",65001,"UInt",0,UPtr,pData,"Int",-1,"UInt",0,"Int",0)
                VarSetCapacity(Temp1,CharCount << 1), DllCall("MultiByteToWideChar","UInt",65001,"UInt",0,UPtr,pData,"Int",CharCount,UPtr,&Temp1,"Int",CharCount << 1)
                DllCall("WideCharToMultiByte","UInt",0,"UInt",0x400,UPtr,&Temp1,"Int",CharCount,UPtr,&Result,"Int",CharCount,"UInt",0,"UInt",0), VarSetCapacity(Result,-1)
            }
            Else
            {
                CharCount := DllCall("WideCharToMultiByte","UInt",0,"UInt",0x400,UPtr,pData,"Int",-1,"UInt",0,"UInt",0,"UInt",0,"UInt",0)
                DllCall("WideCharToMultiByte","UInt",0,"UInt",0x400,UPtr,pData,"Int",CharCount,UPtr,&Result,"Int",CharCount,"UInt",0,"UInt",0), VarSetCapacity(Result,-1)
            }
        }
    }
    ;treat all unrecognized names as this system's ANSI code page.
    Else If (IsText && A_IsUnicode)
        Result := %StrGetFunc%(pData,"CP0")
    DllCall("WinINet\InternetCloseHandle",UPtr,hRequest), DllCall("WinINet\InternetCloseHandle",UPtr,hInternet), DllCall("WinINet\InternetCloseHandle",UPtr,hConnect), DllCall("FreeLibrary",UPtr,hModule)
    Return, TotalSize
}