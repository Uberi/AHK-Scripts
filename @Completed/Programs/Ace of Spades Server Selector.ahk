#NoEnv

;check for portable versions
If FileExist(A_ScriptDir . "\AoS\client.exe")
    Path := """%A_ScriptDir%\AoS\client.exe"" ""%Server%""", Config := A_ScriptDir . "\AoS\config.ini"
Else If FileExist(A_ScriptDir . "\AceOfSpades\client.exe")
    Path := """%A_ScriptDir%\AceOfSpades\client.exe"" ""%Server%""", Config := A_ScriptDir . "\AceOfSpades\config.ini"
Else If FileExist(A_ScriptDir . "\Ace of Spades\client.exe")
    Path := """%A_ScriptDir%\Ace of Spades\client.exe"" ""%Server%""", Config := A_ScriptDir . "\Ace of Spades\config.ini"
Else If FileExist(A_ScriptDir . "\client.exe")
    Path := """%A_ScriptDir%\client.exe"" ""%Server%""", Config := A_ScriptDir . "\config.ini"
Else
{
    Path := "%Server%"
    RegRead, Temp1, HKEY_CLASSES_ROOT, aos\shell\open\command
    RegExMatch(Temp1,"S)""\K[^""]*",Temp1)
    SplitPath, Temp1,, Config
    Config .= "\config.ini"
}

ConnectAddress := "127.0.0.1"
SortColumns := [0,0,0,0,0]

IniRead, Username, %Config%, client, name

Gui, Font, s16 Bold, Arial
Gui, Add, Text, x10 y0 w780 h30 vTitle Center, Server List
Gui, Font, s8 Norm
Gui, Add, ListView, x10 y30 w780 h580 vServerList gListViewEvent, Name|Map|Mode|Players|Capacity|Ping|Address
Gui, Font, Bold
Gui, Add, Text, x10 y620 w150 h20 vServerCount
Gui, Add, Button, x620 y620 w80 h20 vIPAddress gIPAddress, &IP Address
Gui, Add, Button, x710 y620 w80 h20 vRefreshList gRefreshList Default, &Refresh
Gui, Font, Norm
Gui, Add, Text, x420 y622 w60 h20 vUsernameLabel, Playing as
Gui, Add, Edit, x480 y620 w120 h20 vUsername, %Username%

Gui, +Resize +MinSize530x150

Gosub, RefreshList

Gui, Show, Center w800 h650
Return

GuiEscape:
GuiClose:
Gosub, WriteName
ExitApp

GuiSize:
GuiControl, Move, Title, % "w" . (A_GuiWidth - 20)
GuiControl, Move, ServerList, % "w" . (A_GuiWidth - 20) . " h" . (A_GuiHeight - 70)
GuiControl, Move, ServerCount, % "y" . (A_GuiHeight - 30)
GuiControl, Move, IPAddress, % "x" . (A_GuiWidth - 180) . " y" . (A_GuiHeight - 30)
GuiControl, Move, RefreshList, % "x" . (A_GuiWidth - 90) . " y" . (A_GuiHeight - 30)
GuiControl, Move, UsernameLabel, % "x" . (A_GuiWidth - 380) . " y" . (A_GuiHeight - 30)
GuiControl, Move, Username, % "x" . (A_GuiWidth - 320) . " y" . (A_GuiHeight - 30)
WinSet, Redraw
Return

WriteName:
Gui, Submit, NoHide
IniWrite, %Username%, %Config%, client, name
Return

IPAddress:
Gui, +OwnDialogs
Loop
{
    InputBox, Value, Connect to IP address, Enter the server IP address:,, 200, 120,,,,, 127.0.0.1
    If ErrorLevel
        Return
    If RegExMatch(Value,"S)^(\d{1,3})\.(\d{1,3})\.(\d{1,3})\.(\d{1,3})(:\d+)?$",Address)
        Break
}
ConnectAddress := Value
Server := "aos://" . (Address1 | (Address2 << 8) | (Address3 << 16) | (Address4 << 24)) . Address5
Gui, Hide
JoinServer(Server,Path,"IP Address " . ConnectAddress)
Gui, Show
Return

ListViewEvent:
If (A_GuiEvent = "ColClick")
    Gosub, SortColumns
If (A_GuiEvent != "DoubleClick")
    Return
Gosub, SelectServer
Return

SelectServer:
Gosub, WriteName
Row := LV_GetNext()
LV_GetText(Server,Row,7) ;retrieve the server address from the fifth column of the selected row
LV_GetText(Name,Row,1) ;retrieve the server name from the first column of the selected row
LV_GetText(Map,Row,2) ;retrieve the map from the second column of the selected row
Gui, Hide
JoinServer(Server,Path,Name . " (" . Map . ")")
Gui, Show
Return

UpdatePing:
Index := 1
Loop
{
    If (Index > LV_GetCount())
        Break
    Index1 := Index
    Addresses := []
    Loop, 64
    {
        If (Index > LV_GetCount())
            Break
        LV_GetText(Server,Index,7) ;retrieve the server address from the fifth column of the selected row
        RegExMatch(Server,"iS)aos://\K\d+",Address)
        Addresses[A_Index] := Address
        Index ++
    }
    try Times := RoundTripTimeList(Addresses)
    catch
        Times := []
    For Key, Value In Times
        LV_Modify(Index1 + Key,"Col6",Value = -1 ? "?" : Value)
}
Return

SortColumns:
If SortColumns[A_EventInfo]
    SortColumns[A_EventInfo] := (SortColumns[A_EventInfo] & 1) + 1 ;toggle sorting types between ascending and descending
Else
    SortColumns[A_EventInfo] := (A_EventInfo = 4 || A_EventInfo = 5) ? 2 : 1 ;enable sorting for the column

For Index In SortColumns ;disable sorting on all other columns
{
    If (Index != A_EventInfo)
        SortColumns[Index] := 0
}
Return

RefreshList:
Gui, Show,, Ace of Spades Servers

GuiControl, -Redraw, ServerList ;prevent redrawing of the ListView
LV_Delete() ;remove all listview entries

try ;request the BuildAndShoot page
{
    GuiControl,, ServerCount, Checking BuildAndShoot...
    WebRequest := ComObjCreate("WinHttp.WinHttpRequest.5.1") ;create request
    WebRequest.SetTimeouts(2000,3000,5000,5000)
    WebRequest.Open("GET","http://buildandshoot.com/") ;open request
    WebRequest.Send() ;send request
    ServerPage := WebRequest.ResponseText ;retrieve response

    If InStr(ServerPage,">DOWNLOAD THE GAME!<") ;backup minimal page
    {
        ;retrieve the server list
        ServerPage := SubStr(ServerPage,InStr(ServerPage,"<tbody") + 6) ;remove everything before the server list
        ServerPage := SubStr(ServerPage,1,InStr(ServerPage,"</tbody>") - 1) ;remove everything after the server list

        ;populate the ListView
        FoundPos := 1, FoundPos1 := 1
        While, FoundPos := RegExMatch(ServerPage,"iS)<tr[^>]*>[^<]*<td[^>]*>\s*(?P<Players>\d+)\s*/\s*(?P<Capacity>\d+)\s*</td>"
                                                           . "[^<]*<td[^>]*>\s*<a\s+href=""(?P<Address>[^""]*)""[^>]*>(?P<Name>[^<]*)</a>\s*</td>"
                                                           . "[^<]*<td[^>]*>(?P<Mode>[^<]*)</td>"
                                                           . "[^<]*<td[^>]*>(?P<Map>[^<]*)</td>"
                                                           ,Server,FoundPos)
        {
            LV_Add("",ConvertEntities(ServerName),ServerMap,ServerMode,ServerPlayers,ServerCapacity,"?",ServerAddress)
            FoundPos += StrLen(Server), FoundPos1 := FoundPos
        }
    }
    Else If InStr(ServerPage,"<th>Players</th>") ;normal page
    {
        ;retrieve the server list
        ServerPage := SubStr(ServerPage,InStr(ServerPage,"<tbody") + 6) ;remove everything before the server list
        ServerPage := SubStr(ServerPage,1,InStr(ServerPage,"</tbody>") - 1) ;remove everything after the server list

        ;populate the ListView
        FoundPos := 1, FoundPos1 := 1
        While, FoundPos := RegExMatch(ServerPage,"iS)<tr[^>]*>[^<]*<td[^>]*>\s*(?P<Players>\d+)\s*</td>"
                                                           . "[^<]*<td[^>]*>\s*(?P<Capacity>\d+)\s*</td>"
                                                           . "[^<]*<td[^>]*>\s*<a\s+href=""(?P<Address>[^""]*)""[^>]*>(?P<Name>[^<]*)</a>\s*</td>"
                                                           . "[^<]*<td[^>]*>(?P<Mode>[^<]*)</td>"
                                                           . "[^<]*<td[^>]*>(?P<Map>[^<]*)</td>"
                                                           ,Server,FoundPos)
        {
            LV_Add("",ConvertEntities(ServerName),ServerMap,ServerMode,ServerPlayers,ServerCapacity,"?",ServerAddress)
            FoundPos += StrLen(Server), FoundPos1 := FoundPos
        }
    }
    Else
        throw
    If FoundPos = 1 ;no matches found
        throw
}
catch
{
    try ;request the AcornServer page
    {
        GuiControl,, ServerCount, Checking AcornServer...
        WebRequest := ComObjCreate("WinHttp.WinHttpRequest.5.1") ;create request
        WebRequest.SetTimeouts(2000,3000,5000,5000)
        WebRequest.Open("GET","http://aos.acornserver.com/") ;open request
        WebRequest.Send() ;send request
        ServerPage := WebRequest.ResponseText ;retrieve response

        If !InStr(ServerPage,"<title>Ace of Spades Server List</title>")
            throw

        ;retrieve the server list
        ServerPage := SubStr(ServerPage,InStr(ServerPage,"<tbody") + 6) ;remove everything before the server list
        ServerPage := SubStr(ServerPage,1,InStr(ServerPage,"</tbody>") - 1) ;remove everything after the server list

        ;populate the ListView
        FoundPos := 1, FoundPos1 := 1
        While, FoundPos := RegExMatch(ServerPage,"iS)<tr[^>]*>.*?<td[^>]*>.*?<a\s+href='(?P<Address>[^']*)'[^>]*>(?P<Name>[^<]*)</a>.*?</td>"
                                                           . ".*?<td[^>]*>.*?(?P<Capacity>\d+).*?</td>"
                                                           . ".*?<td[^>]*>.*?(?P<Players>\d+).*?</td>"
                                                           . ".*?<td[^>]*>.*?<font[^>]*>(?P<Mode>[^<]*).*?</td>"
                                                           . ".*?<td[^>]*>.*?<b>(?P<Map>[^<]*).*?</td>"
                                                           ,Server,FoundPos)
        {
            LV_Add("",ConvertEntities(ServerName),ServerMap,ServerMode,ServerPlayers,ServerCapacity,"?",ServerAddress)
            FoundPos += StrLen(Server), FoundPos1 := FoundPos
        }
    }
    catch
    {
        try ;request the Minit page
        {
            GuiControl,, ServerCount, Checking Minit...
            WebRequest := ComObjCreate("WinHttp.WinHttpRequest.5.1") ;create request
            WebRequest.SetTimeouts(2000,3000,5000,5000)
            WebRequest.Open("GET","http://minit.nu/serverlist/") ;open request
            WebRequest.Send() ;send request
            ServerPage := WebRequest.ResponseText ;retrieve response

            If !InStr(ServerPage,"<h2>Server List</h2>")
                throw

            ;retrieve the server list
            ServerPage := SubStr(ServerPage,InStr(ServerPage,"<tbody") + 6) ;remove everything before the server list
            ServerPage := SubStr(ServerPage,1,InStr(ServerPage,"</tbody>") - 1) ;remove everything after the server list

            ;populate the ListView
            FoundPos := 1, FoundPos1 := 1
            While, FoundPos := RegExMatch(ServerPage,"iS)<tr[^>]*>[^<]*<td[^>]*>\s*(?P<Players>\d+)\s*</td>"
                                                               . "[^<]*<td[^>]*>\s*(?P<Capacity>\d+)\s*</td>"
                                                               . "[^<]*<td[^>]*>\s*<a\s+href=""(?P<Address>[^""]*)""[^>]*>\s*</a>(?P<Name>[^<]*)</td>"
                                                               . "[^<]*<td[^>]*>(?P<Map>[^<]*)</td>"
                                                               . "[^<]*<td[^>]*>(?P<Mode>[^<]*)</td>"
                                                               ,Server,FoundPos)
            {
                LV_Add("",ConvertEntities(ServerName),ServerMap,ServerMode,ServerPlayers,ServerCapacity,"?",ServerAddress)
                FoundPos += StrLen(Server), FoundPos1 := FoundPos
            }
        }
        catch Error ;could not retrieve server list
        {
            ServerPage := ""
            MsgBox, 16, Error, Could not obtain server list.
        }
    }
}
WebRequest := "" ;free request

;adjust column widths to suit their headers and contents
LV_ModifyCol(1,"AutoHdr") ;server name
LV_ModifyCol(2,"AutoHdr") ;map
LV_ModifyCol(3,"AutoHdr") ;game mode
LV_ModifyCol(4,"AutoHdr Integer Desc") ;players
LV_ModifyCol(5,"AutoHdr Integer Desc") ;capacity
LV_ModifyCol(6,"AutoHdr Integer") ;ping
LV_ModifyCol(7,"AutoHdr") ;server

For Index, Value In SortColumns
{
    If Value
    {
        LV_ModifyCol(Index,"Sort" . ((Value = 1) ? "" : "Desc"))
        Break
    }
}

GuiControl, +Redraw, ServerList ;allow the ListView to be redrawn

GuiControl,, ServerCount, % LV_GetCount() . " servers." ;update the server count

Gosub, UpdatePing
Return

JoinServer(Server,Path,Name)
{
    global AutoJoin
    AutoJoin := False
    Transform, Path, Deref, %Path%
    SetTitleMatchMode, RegEx
    Loop
    {
        ;open Ace of Spades
        Run, %Path%,, UseErrorLevel
        If ErrorLevel
        {
            MsgBox, 16, Error, Could not open Ace of Spades with command line "%Path%".
            Return, 1
        }
        WinWait, Ace of Spades|ERROR ahk_class Ace of Spades|#32770,, 5

        ;check for connection errors
        WinGetClass, WindowClass
        If (WindowClass != "Ace of Spades") ;error dialog found
        {
            ControlGetText, Message, Static1
            WinClose ;close error dialog
            If !AutoJoin
            {
                MsgBox, 22, Error, Could not connect to "%Name%": %Message%.`n`nSelect "Try Again" to retry the connection`, or "Continue" to automaticially join.
                IfMsgBox, Cancel
                {
                    Gosub, StopAutoJoin
                    Break
                }
                IfMsgBox, Continue
                {
                    AutoJoin := True
                    ToolTip, Press Esc to stop automatic retrying.
                    Hotkey, Esc, StopAutoJoin, On
                }
            }
        }
        Else ;game window found
        {
            If ErrorLevel ;window wait operation timed out
                Return, 1
            WinSetTitle, Ace of Spades ahk_class Ace of Spades,, Ace of Spades - %Name%
            WinWait, ERROR ahk_class #32770,, 3 ;handle the error dialog possibly showing up
            If !ErrorLevel ;error dialog
            {
                ControlGetText, Message, Static1
                WinClose ;close error dialog
                WinWaitClose, Ace of Spades ahk_class Ace of Spades
                If !AutoJoin
                {
                    If (Message = "Quit map transfer") ;quit game while loading
                    {
                        Gosub, StopAutoJoin
                        Break
                    }
                    MsgBox, 22, Error, Could not connect to "%Name%": %Message%.`n`nSelect "Try Again" to retry the connection`, or "Continue" to automaticially join.
                    IfMsgBox, Cancel
                    {
                        Gosub, StopAutoJoin
                        Break
                    }
                    IfMsgBox, Continue
                    {
                        AutoJoin := True
                        ToolTip, Press Esc to stop automatic retrying.
                        Hotkey, Esc, StopAutoJoin, On
                    }
                }
            }
            Else
            {
                Gosub, StopAutoJoin
                WinWaitClose, Ace of Spades ahk_class Ace of Spades
                Break
            }
        }
    }
    Return, 0

    StopAutoJoin:
    AutoJoin := False
    ToolTip
    Hotkey, Esc, StopAutoJoin, Off
    Return
}

#If ListViewFocused()

ListViewFocused()
{
    GuiControlGet, CurrentFocus, FocusV
    Return, CurrentFocus = "ServerList" && LV_GetNext()
}

Enter::Gosub, SelectServer

#If

RoundTripTimeList(AddressList,Timeout = 800)
{
    Count := AddressList.MaxIndex()
    If Count > 64 ;MAXIMUM_WAIT_OBJECTS
        throw Exception("Could not send over 64 requests.")

    If DllCall("LoadLibrary","Str","ws2_32","UPtr") = 0 ;NULL
        throw Exception("Could not load WinSock library.")
    If DllCall("LoadLibrary","Str","icmp","UPtr") = 0 ;NULL
        throw Exception("Could not load ICMP library.")

    hPort := DllCall("icmp\IcmpCreateFile","UPtr") ;open port
    If hPort = -1 ;INVALID_HANDLE_VALUE
        throw Exception("Could not open port.")

    Replies := []
    Result := []

    StructLength := 250 + 20 + (A_PtrSize * 2) ;ICMP_ECHO_REPLY structure
    VarSetCapacity(Events,Count * A_PtrSize)
    For Index, Address In AddressList
    {
        hEvent := DllCall("CreateEvent"
            ,"UPtr",0 ;security attributes structure
            ,"UInt",True ;manual reset event
            ,"UInt",False ;initially not signalled
            ,"UPtr",0 ;event name
            ,"UPtr")
        If !hEvent
            throw Exception("Could not create event.")
        NumPut(hEvent,Events,(Index - 1) * A_PtrSize)

        Replies.SetCapacity(Index,StructLength)
        DllCall("icmp\IcmpSendEcho2"
            ,"UPtr",hPort ;ICMP handle
            ,"UPtr",hEvent ;event handle
            ,"UPtr",0 ;APC routine handle
            ,"UPtr",0 ;APC routine context
            ,"UInt",Address ;IP address
            ,"Str","" ;request data
            ,"UShort",0 ;length of request data
            ,"UPtr",0 ;pointer to IP options structure
            ,"UPtr",Replies.GetAddress(Index) ;reply buffer
            ,"UInt",StructLength ;length of reply buffer
            ,"UInt",Timeout) ;ping timeout
        If A_LastError != 0x3E5 ;ERROR_IO_PENDING
            throw Exception("Could not send echo.")
    }

    While, Replies.MaxIndex()
    {
        Index := DllCall("WaitForMultipleObjects","UInt",Count,"UPtr",&Events,"UInt",False,"UInt",Timeout * 2)
        If (Index < 0 || Index >= Count) ;WAIT_OBJECT_0, WAIT_OBJECT_0 + Count - 1
            throw Exception("Could not detect ping completions." . Index . " " . A_LastError)

        If !DllCall("ResetEvent","UPtr",NumGet(Events,Index * A_PtrSize)) ;reset event to nonsignalled state
            throw Exception("Could not reset ping event.")

        Index ++ ;zero based index to one based
        Status := NumGet(Replies.GetAddress(Index),4,"UInt")
        If Status In 11002,11003,11004,11005,11010 ;IP_DEST_NET_UNREACHABLE, IP_DEST_HOST_UNREACHABLE, IP_DEST_PROT_UNREACHABLE, IP_DEST_PORT_UNREACHABLE, IP_REQ_TIMED_OUT
            Result[Index] := -1
        Else If Status = 0 ;IP_SUCCESS
            Result[Index] := NumGet(Replies.GetAddress(Index),8,"UInt") ;obtain round trip time
        Else
            throw Exception("Could not retrieve echo response." . Status)
        Replies.Remove(Index,"") ;remove reply entry to signify ping completion
    }

    Loop, %Count%
    {
        If !DllCall("CloseHandle","UPtr",NumGet(Events,(A_Index - 1) * A_PtrSize)) ;close event
            throw Exception("Could not close event.")
    }
    If !DllCall("icmp\IcmpCloseHandle","UInt",hPort) ;close port
        throw Exception("Could not close port.")

    Return, Result
}

ConvertEntities(HTML)
{
    static EntityList := "|quot=34|apos=39|amp=38|lt=60|gt=62|nbsp=160|iexcl=161|cent=162|pound=163|curren=164|yen=165|brvbar=166|sect=167|uml=168|copy=169|ordf=170|laquo=171|not=172|shy=173|reg=174|macr=175|deg=176|plusmn=177|sup2=178|sup3=179|acute=180|micro=181|para=182|middot=183|cedil=184|sup1=185|ordm=186|raquo=187|frac14=188|frac12=189|frac34=190|iquest=191|Agrave=192|Aacute=193|Acirc=194|Atilde=195|Auml=196|Aring=197|AElig=198|Ccedil=199|Egrave=200|Eacute=201|Ecirc=202|Euml=203|Igrave=204|Iacute=205|Icirc=206|Iuml=207|ETH=208|Ntilde=209|Ograve=210|Oacute=211|Ocirc=212|Otilde=213|Ouml=214|times=215|Oslash=216|Ugrave=217|Uacute=218|Ucirc=219|Uuml=220|Yacute=221|THORN=222|szlig=223|agrave=224|aacute=225|acirc=226|atilde=227|auml=228|aring=229|aelig=230|ccedil=231|egrave=232|eacute=233|ecirc=234|euml=235|igrave=236|iacute=237|icirc=238|iuml=239|eth=240|ntilde=241|ograve=242|oacute=243|ocirc=244|otilde=245|ouml=246|divide=247|oslash=248|ugrave=249|uacute=250|ucirc=251|uuml=252|yacute=253|thorn=254|yuml=255|OElig=338|oelig=339|Scaron=352|scaron=353|Yuml=376|circ=710|tilde=732|ensp=8194|emsp=8195|thinsp=8201|zwnj=8204|zwj=8205|lrm=8206|rlm=8207|ndash=8211|mdash=8212|lsquo=8216|rsquo=8217|sbquo=8218|ldquo=8220|rdquo=8221|bdquo=8222|dagger=8224|Dagger=8225|hellip=8230|permil=8240|lsaquo=8249|rsaquo=8250|euro=8364|trade=8482|"
    FoundPos := 1
    While, FoundPos := InStr(HTML,"&",1,FoundPos)
    {
        FoundPos ++ ;move past the ampersand
        Entity := SubStr(HTML,FoundPos,InStr(HTML,";",1,FoundPos) - FoundPos) ;retrieve the entity body
        If SubStr(Entity,1,1) = "#" ;numeric entity code
            EntityCode := SubStr(Entity,2)
        Else ;named entity
        {
            Temp1 := InStr(EntityList,"|" . Entity . "=") + StrLen(Entity) + 2
            EntityCode := SubStr(EntityList,Temp1,InStr(EntityList,"|",1,Temp1) - Temp1)
        }
        If (Entity != "amp") ;convert every entity except the ampersand
            StringReplace, HTML, HTML, &%Entity%;, % Chr(EntityCode), All ;convert the entity
    }
    StringReplace, HTML, HTML, &amp;, &, All ;convert the ampersand entity
    Return, HTML
}