#NoEnv

URL := "http://ipv4.download.thinkbroadband.com/512MB.zip"
;MsgBox % Download(Result,URL) . "`n" . SubStr(Result,1,100)
MsgBox % DownloadAsync(Result,URL) . "`n" . SubStr(Result,1)

Download(ByRef Result,URL)
{
    UserAgent := "" ;user agent for the request
    Headers := "" ;headers to append to the request

    hModule := DllCall("LoadLibrary","Str","wininet.dll","UPtr")
    hInternet := DllCall("wininet\InternetOpen"
        ,"Str",UserAgent ;user agent string
        ,"UInt",0 ;proxy settings: INTERNET_OPEN_TYPE_PRECONFIG
        ,"UPtr",0 ;proxy name
        ,"UPtr",0 ;proxy bypass
        ,"UInt",0 ;options
        ,"UPtr")
    If !hInternet
        throw Exception("Could not initialize WinINet.")

    hURL := DllCall("wininet\InternetOpenUrl"
        ,"UPtr",hInternet ;WinINet handle
        ,"Str",URL
        ,"Str",Headers ;headers to append
        ,"UInt",-1 ;headers length (null terminated)
        ,"UInt",0x80000000 | 0x4000000 ;options: INTERNET_FLAG_RELOAD | INTERNET_FLAG_NO_CACHE_WRITE
        ,"UInt",0
        ,"UPtr")
    If !hURL
        throw Exception("Could not open resource.")

    TotalRead := 0
    Data := [], Sizes := []
    Loop
    {
        Data.SetCapacity(A_Index,512)
        ReadAmount := 0
        If !DllCall("wininet\InternetReadFile","UPtr",hURL,"UPtr",Data.GetAddress(A_Index),"UInt",512,"UInt*",ReadAmount)
            throw Exception("Could not read resource.")
        If ReadAmount = 0
            Break
        Sizes[A_Index] := ReadAmount
        TotalRead += ReadAmount
    }

    VarSetCapacity(Result,TotalRead)
    pResult := &Result
    Loop, % Data.MaxIndex()
    {
        DllCall("RtlMoveMemory","UPtr",pResult,"UPtr",Data.GetAddress(A_Index),"UPtr",Sizes[A_Index])
        pResult += Sizes[A_Index]
    }

    If !DllCall("wininet\InternetCloseHandle","UPtr",hURL)
        throw Exception("Could not close resource.")
    If !DllCall("wininet\InternetCloseHandle","UPtr",hInternet)
        throw Exception("Could not uninitialize WinINet.")
    If !DllCall("FreeLibrary","UPtr",hModule)
        throw Exception("Could not free WinINet.")
    Return, TotalRead
}

;wip: make this work with multiple calls
DownloadAsync(ByRef Result,URL)
{
    static pCallback := RegisterCallback("DownloadAsyncCallback","F")

    UserAgent := "" ;user agent for the request
    Headers := "" ;headers to append to the request

    hModule := DllCall("LoadLibrary","Str","wininet.dll","UPtr")
    hInternet := DllCall("wininet\InternetOpen"
        ,"Str",UserAgent ;user agent string
        ,"UInt",0 ;proxy settings: INTERNET_OPEN_TYPE_PRECONFIG
        ,"UPtr",0 ;proxy name
        ,"UPtr",0 ;proxy bypass
        ,"UInt",0x10000000 ;options: INTERNET_FLAG_ASYNC
        ,"UPtr")
    If !hInternet
        throw Exception("Could not initialize WinINet.")
    DllCall("wininet\InternetSetStatusCallback","UPtr",hInternet,"UPtr",pCallback,"UPtr")

    global hURL
    Context := 12345
    hURL := DllCall("wininet\InternetOpenUrl"
        ,"UPtr",hInternet ;WinINet handle
        ,"Str",URL
        ,"Str",Headers ;headers to append
        ,"UInt",-1 ;headers length (null terminated)
        ,"UInt",0x80000000 | 0x4000000 | 0x100 ;options: INTERNET_FLAG_RELOAD | INTERNET_FLAG_NO_CACHE_WRITE | INTERNET_FLAG_PRAGMA_NOCACHE
        ,"UPtr",&Context ;context value
        ,"UPtr")
    If !hURL && A_LastError != 997 ;ERROR_IO_PENDING
        throw Exception("Could not open resource.")
    global RequestPending := True
    While, RequestPending
        Sleep, -1

    MsgBox hURL %hURL%
    ContentLength := 0, Length := 10 ;A_PtrSize
    If !DllCall("wininet\HttpQueryInfo"
        ,"UPtr",hURL ;WinINet handle
        ,"UInt",5 ;flags: HTTP_QUERY_CONTENT_LENGTH
        ,"UInt*",ContentLength ;retrieved length
        ,"UInt*",Length) ;buffer length
        throw Exception("Could not retrieve content length.")
    MsgBox Length %ContentLength%

    Length := (A_PtrSize * 3) + 28
    VarSetCapacity(InternetBuffers,Length,0)
    NumPut(Length,InternetBuffers,0,"UInt") ;dwStructSize
    NumPut(pResult,InternetBuffers,(A_PtrSize * 2) + 12)

    TotalRead := 0
    Data := [], Sizes := []
    Loop
    {
        Data.SetCapacity(A_Index,512)
        ReadAmount := 0
        If !DllCall("wininet\InternetReadFileEx"
            ,"UPtr",hURL
            ,"UPtr",&InternetBuffers
            ,"UInt",0x1 ;flags: IRF_ASYNC
            ,"UInt*",ReadAmount)
            throw Exception("Could not read resource.")
        If ReadAmount = 0
            Break
        Sizes[A_Index] := ReadAmount
        TotalRead += ReadAmount
    }

    VarSetCapacity(Result,TotalRead)
    pResult := &Result
    Loop, % Data.MaxIndex()
    {
        DllCall("RtlMoveMemory","UPtr",pResult,"UPtr",Data.GetAddress(A_Index),"UPtr",Sizes[A_Index])
        pResult += Sizes[A_Index]
    }

    If !DllCall("wininet\InternetCloseHandle","UPtr",hURL)
        throw Exception("Could not close resource.")
    If !DllCall("wininet\InternetCloseHandle","UPtr",hInternet)
        throw Exception("Could not uninitialize WinINet.")
    If !DllCall("FreeLibrary","UPtr",hModule)
        throw Exception("Could not free WinINet.")
    Return, TotalRead
}

DownloadAsyncCallback(hInternet,Context,Status,pStatusInformation,StatusInformationLength)
{
    global RequestPending, hURL
    If Status = 100 ;INTERNET_STATUS_REQUEST_COMPLETE
    {
        FileAppend, %pStatusInformation%:%StatusInformationLength%, *
        ;hURL := NumGet(pStatusInformation + 0)
        RequestPending := False
    }
}