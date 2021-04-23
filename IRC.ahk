#NoEnv

Channel := "#ahk"

Name := "WinsockTestBot"
Nickname := Name
Password := ""

ScrollBack := ""

Gui, Add, Edit, x10 y10 vScrollBack hwndhScrollBack ReadOnly Multi
Gui, Add, Edit, x10 h20 vInputText
Gui, Add, Button, w50 h20 vAppendLine gAppendLine Default, Add
Gui, +Resize +MinSize100x100
GuiControl, Focus, InputText
Gui, Show, w390 h400, Test

Initialize()
Socket := Connect("chat.freenode.net",6667)
RequestNotifications(Socket,"ReceiveData")

Message(Socket,"PASS",[Password])
Message(Socket,"USER",[Nickname,"google.com","AHKBOT",Name])
Message(Socket,"NICK",[Nickname])
Message(Socket,"JOIN",[Channel])

OnExit, ExitSub
Return

ExitSub:
Message(Socket,"QUIT",["Good day everyone"])
DisableNotifications()
Disconnect(Socket)
ExitApp

GuiEscape:
GuiClose:
ExitApp

GuiSize:
GuiControl, Move, ScrollBack, % "w" . (A_GuiWidth - 20) . " h" . (A_GuiHeight - 50)
GuiControl, Move, InputText, % "y" . (A_GuiHeight - 30) . " w" . (A_GuiWidth - 70)
GuiControl, Move, AppendLine, % "x" . (A_GuiWidth - 60) . " y" . (A_GuiHeight - 30)
Return

AppendLine:
GuiControlGet, InputText,, InputText
GuiControl,, InputText
AppendLine(InputText)
Return

AppendLine(Text)
{
    global hScrollBack
    SendMessage, 0x0E, 0, 0,, ahk_id %hScrollBack% ;WM_GETTEXTLENGTH
    SendMessage, 0xB1, ErrorLevel, ErrorLevel,, ahk_id %hScrollBack% ;EM_SETSEL
    Text .= "`n"
    SendMessage, 0xC2, 0, &Text,, ahk_id %hScrollBack% ;EM_REPLACESEL
}

ProcessMessage(Socket,Prefix,Command,Parameters)
{
    global Channel, Nickname
    RegExMatch(Prefix,"S)^[^!@ ]+(?=[!@ ])",Source)
    Target := (Parameters[1] = Channel) ? Channel : Source
    If (Command = "PING")
        Message(Socket,"PONG",Parameters) ;reply with the same parameters
    Else If (Command = "JOIN")
        Message(Socket,"PRIVMSG",[Channel,"Hello, " . Source . "!"])
    Else If (Command = "PRIVMSG")
    {
        Contents := Parameters[2]
        If (SubStr(Contents,1,1) = "?" || Parameters[1] = Nickname) ;script was directly addressed in the message
        {
            Contents := SubStr(Contents,2)
            Message(Socket,"PRIVMSG",[Target,Target . " said , """ . Contents . """?"])
        }
    }
}

Initialize()
{
    VarSetCapacity(WSAData,32), Result := DllCall("Ws2_32\WSAStartup","UShort",2,"UPtr",&WSAData) ;initialize WinSock library
    If Result
    {
        DllCall("Ws2_32\WSACleanup") ;clean up resources
        Throw Exception("Could not initialize WinSock library.`n`nError: " . Result)
    }
}

Connect(Host,Port)
{
    Result := DllCall("Ws2_32\getaddrinfo","AStr",Host,"AStr",Port,"UPtr",0,"UPtr*",pAddressInfo)
    If Result
    {
        DllCall("Ws2_32\WSACleanup") ;clean up resources
        Throw Exception("Could not retrieve host address:" . Host . " at port " . Port . ".`n`nError: " . Result)
    }

    AddressFamily := NumGet(pAddressInfo + 0,4,"Int")
    pSocketAddress := NumGet(pAddressInfo + 0,16 + (A_PtrSize << 1),"UPtr")
    If AddressFamily = 2 ;AF_INET: IPv4 address family
        pAddress := pSocketAddress + 4
    Else If AddressFamily = 23 ;AF_INET6: IPv6 address family
        pAddress := pSocketAddress + 8
    Else
    {
        DllCall("Ws2_32\WSACleanup") ;clean up resources
        DllCall("Ws2_32\freeaddrinfo","UPtr",pAddressInfo) ;free the AddressInfo structure
        Throw Exception("Unknown address family:" . AddressFamily . ".")
    }

    ;create a socket
    Socket := DllCall("Ws2_32\socket","Int",AddressFamily,"Int",1,"Int",6,"Ptr") ;SOCK_STREAM, IPPROTO_TCP ;wip: SOCKET type is supposed to be unsigned, but here it is signed because it needs to be checked against INVALID_SOCKET afterwards
    If Socket = -1 ;INVALID_SOCKET
    {
        DllCall("Ws2_32\WSACleanup") ;clean up resources
        DllCall("Ws2_32\freeaddrinfo","UPtr",pAddressInfo) ;free the AddressInfo structure
        Throw Exception("Could not create socket.`n`nError: " . DllCall("Ws2_32\WSAGetLastError"))
    }

    ;connect to the socket
    If DllCall("Ws2_32\connect","UPtr",Socket,"UPtr",pSocketAddress,"Int",NumGet(pAddressInfo + 0,16)) = -1 ;SOCKET_ERROR
    {
        DllCall("Ws2_32\WSACleanup") ;clean up resources
        DllCall("Ws2_32\freeaddrinfo","UPtr",pAddressInfo) ;free the AddressInfo structure
        Throw Exception("Could not connect to socket.`n`nError: " . DllCall("Ws2_32\WSAGetLastError"))
    }

    DllCall("Ws2_32\freeaddrinfo","UPtr",pAddressInfo) ;free the AddressInfo structure

    Return, Socket
}

Disconnect(Socket)
{
    ;close the socket
    If DllCall("Ws2_32\closesocket","UPtr",Socket) = -1 ;SOCKET_ERROR
        Throw Exception("Could not close socket.`n`nError: " . DllCall("Ws2_32\WSAGetLastError"))
}

RequestNotifications(Socket,NotificationHandler,Message = 0x8000) ;WM_APP
{
    ;request to be notified by message when network events occur
    OnMessage(0x8000,NotificationHandler)
    If DllCall("Ws2_32\WSAAsyncSelect","UPtr",Socket,"UPtr",A_ScriptHwnd,"UInt",Message,"Int",0x21) = -1 ;FD_READ | FD_CLOSE, SOCKET_ERROR
    {
        DllCall("Ws2_32\WSACleanup") ;clean up resources
        Throw Exception("Could not request network event notifications.`n`nError: " . DllCall("Ws2_32\WSAGetLastError"))
    }
}

DisableNotifications(Message = 0x8000)
{
    OnMessage(Message,"")
}

Message(Socket,Command,Parameters)
{
    Result := Command
    MaxIndex := ObjMaxIndex(Parameters)
    If MaxIndex
    {
        Loop, % MaxIndex - 1
            Result .= " " . Parameters[A_Index]
        Result .= " :" . Parameters[MaxIndex] . "`r`n" ;wip: should probably use carriage return too
    }
    Else
        Result .= " :`r`n"

    If (DllCall("Ws2_32\send","UInt",Socket,"AStr",Result,"Int",StrLen(Result),"Int",0) = -1) ;SOCKET_ERROR
        Throw Exception("Could not send data.`n`nError: " . DllCall("Ws2_32\WSAGetLastError"))
}

ReceiveData(Socket,lParam) ;wip
{
    ErrorCode := lParam >> 16
    If ErrorCode
        Throw Exception("Could not receive event notification.`n`nError: " . ErrorCode)
    Event := lParam & 0xFFFF ;wip
    VarSetCapacity(Buffer,4096)
    Data := ""
    Loop
    {
        BytesReceived := DllCall("Ws2_32\recv","UPtr",Socket,"UPtr",&Buffer,"Int",4096,"Int",0)
        If BytesReceived = 0
            Break
        If BytesReceived = -1 ;SOCKET_ERROR
        {
            ErrorCode := DllCall("Ws2_32\WSAGetLastError")
            If ErrorCode = 10035 ;WSAEWOULDBLOCK: resource temporarily unavailable
                Break
            If ErrorCode = 10054 ;WSAECONNRESET: connection reset
            {
                ;wip: do something about it
                Return, 1
            }
            Throw Exception("Could not receive data.`n`nError: " . ErrorCode)
        }
        Data .= StrGet(&Buffer,BytesReceived,"UTF-8")
    }
    ProcessData(Socket,Data)
    Return, 1
}

ProcessData(Socket,Data)
{
    Data := RTrim(Data,"`r`n") ;trim off trailing newlines
    Loop, Parse, Data, `n, `r ;multiple lines may be sent at a time
    {
        If !RegExMatch(A_LoopField,"S)^(?::(?P<Prefix>[^ ]+) +)?(?P<Command>[a-zA-Z]+|\d\d\d)(?P<ParameterList>.*)$",Message) ;malformed message
            Return ;ignore it
        AppendLine(A_LoopField)
        MessageParameters := [], FoundPos := 1, FoundPos1 := 1
        While, FoundPos := RegExMatch(MessageParameterList,"S) +((?=:).*$|[^ ]+)",Match,FoundPos)
        {
            If (SubStr(Match1,1,1) = ":")
                Match1 := SubStr(Match1,2)
            ObjInsert(MessageParameters,Match1)
            FoundPos += StrLen(Match), FoundPos1 := FoundPos
        }
        ProcessMessage(Socket,MessagePrefix,MessageCommand,MessageParameters)
    }
}