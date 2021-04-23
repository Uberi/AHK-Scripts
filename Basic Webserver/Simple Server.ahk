#NoEnv
#SingleInstance Ignore
SetBatchLines, -1
Menu, Tray, Icon,,, 1
AutoTrim, Off

NetworkAddress = 0.0.0.0
NetworkPort = 80 ;make this a random number, to have a private server
WebRoot = %A_ScriptDir%\WebRoot
IndexPage := "index.html"
AHKPath := A_ScriptDir . "\Resources\AutoHotkey.exe"
LogFilePath := A_ScriptDir . "\Log.txt"

MIMEListFile = %A_ScriptDir%\Resources\MIME.txt
DefaultContentType = application/x-unknown-content-type
ScriptTypesListFile = %A_ScriptDir%\Resources\ScriptTypes.txt
RewriteRulesFile = %A_ScriptDir%\Resources\RewriteRules.txt
OpenTag := "<AHK>"
CloseTag := "</AHK>"
ScriptErrorText := "SCRIPT_ERROR"
ScriptTimeOut := 800

;use objects for URL parameters
;fix bugs in binary transfers from scripts to server
;page caching using binary dictionary array library
;add header (especially referrer, and maybe the referring search engine and search term) retrieval support, with simple to use functions, to supportlib
;for script pages, use the PHP design, where "DataEcho()" appends HTML to the page being built, and "DataFlush()" will immediately send everything so far to the client, and clear the HTML, and "DataClear()", which just clears the HTML, and "DataSend()", which simply sends some data to the client. this will allow streaming to the client
;allow simple changing of the HTTP return code and headers (add/remove/edit)
;add an URLEncode() function, and a HTMLEscape() function to the Support Lib
;when the server exits, send a message to all scripts (maybe using the broadcast mode of PostMessage, but preferably to each script individually) to exit, rather than checking from the scripts
;let multiple page handler processes do the page processing and logging, for better load balancing. make sure there is one centralized queue, so that blocking processes can handle traffic spikes. each queue job should not be an entire request, but just a nonblocking section, like a single Select(), Open(), or SendData(). use asynchronous events for file reads, database access, etc.
;try to add gzip support (currently may be broken due to binary transfer bugs). gzipped version of page can just be directly served to client
;make pages different based on the user agent (content negotiation), like serving gzipped files if the user agent states it's support
;allow GetVars to get all variables, and optimise it to not parse all parameters. also, if there are duplicate GET params, only retrieve the first occurence (NOT the last)
;caching of dynamic pages by the page generator scripts, or just parts of these pages, if these parts require a lot of resources to generate
;allow access control to certain files and directories (deny access, allow priveledges, digest access authentication, etc.)
;limit requests per IP address to counter DoS attacks
;port over multipart requests from Sparrow
;add easy support for setting and getting cookies
;if there is a need to serve HTTPS content beside HTTP content on the same server, use different port numbers. (user must still type in port number though: https://domain:port/)
;allow filtering of requests, to block malicious ones (e.g., extremely long running requests), using a rule based system
;in page generator scripts, make a function to restart the script if it cannot generate the page before timing out, possibly with a timer
;add a 404 error page with an image of Domo and "404: This page has been eaten by a grue"
Temp1 := StartServer(NetworkAddress,NetworkPort)
If Temp1
{
 MsgBox, 16, Error, WinSock Error: %Temp1%
 ExitApp
}
Return

ReceiveData(Socket,lParam)
{
 Critical
 SizeOfSocketAddress = 30
 VarSetCapacity(SocketAddress,SizeOfSocketAddress,0)
 If (DllCall("Ws2_32\accept","UInt",Socket,"UInt",&SocketAddress,"Int*",SizeOfSocketAddress) > 1)
  Return, 1
 RemoteAddress := DllCall("Ws2_32\inet_ntoa","UInt",NumGet(SocketAddress,4),"Str")
 ReceivedDataSize = 4096
 Loop
 {
  VarSetCapacity(ReceivedData,ReceivedDataSize,0)
  If (DllCall("Ws2_32\recv","UInt",Socket,"Str",ReceivedData,"Int",ReceivedDataSize,"Int",0) > 0 || DllCall("Ws2_32\WSAGetLastError") = 10040)
  {
   Contents := "", Header := "", DataLen := 0, Header := "", SendText := "", ProcessData(ReceivedData,Contents,DataLen,Header,RemoteAddress) ;wip: make this handle binary data in "receiveddata"
   Temp1 := StrLen(Header), VarSetCapacity(SendText,Temp1 + DataLen,13), NumPut(10,SendText,Temp1 + DataLen + 1,"UChar"), DllCall("RtlMoveMemory","UInt",&SendText,"UInt",&Header,"UInt",Temp1), DllCall("RtlMoveMemory","UInt",&SendText + Temp1,"UInt",&Contents,"UInt",DataLen)
   DllCall("Ws2_32\send","UInt",Socket,"UInt",&SendText,"Int",Temp1 + DataLen,"Int",0)
  }
  Else
   Break
 }
 DllCall("Ws2_32\closesocket","UInt",Socket)
 Return, 1
}

ProcessData(ByRef ReceivedData,ByRef Contents,ByRef DataLen,ByRef Header,ByRef RemoteAddress)
{
 global WebRoot
 global IndexPage
 global AHKPath
 global TagText
 global TagTextLen
 global DefaultContentType
 global ScriptTypes

 If !(SubStr(ReceivedData,1,4) = "GET " || SubStr(ReceivedData,1,5) = "POST ")
 {
  NotImplemented(ReceivedData,File,Contents,DataLen,Header,RemoteAddress)
  Return
 }
 File := InStr(ReceivedData,A_Space) + 1, File := SubStr(ReceivedData,File,InStr(ReceivedData,A_Space,False,File) - File) ;Requested File
 RewriteURL(File)
 IfInString, File, ? ;isolate and separate the parameters passed in the url
 {
  Temp1 := InStr(File,"?")
  Values := SubStr(File,Temp1 + 1)
  File := SubStr(File,1,Temp1 - 1)
 }
 File := URLDecode(File)
 StringReplace, File, File, /, \, All
 File := RegExReplace(File,"S)[^\w\.\\]") ;sanitize filename
 If ErrorLevel
 {
  NotFound(ReceivedData,File,Contents,DataLen,Header,RemoteAddress)
  Return
 }
 If (SubStr(File,0,1) = "\") ;get the default page
  File .= IndexPage
 File := WebRoot . File
 Temp1 := ""
 Loop, %File% ;resolve the name to the long path
 {
  If (SubStr(A_LoopFileLongPath,1,StrLen(WebRoot)) = WebRoot) ;if the file is inside the webroot
   Temp1 := A_LoopFileLongPath
  Break
 }
 File := Temp1
 SplitPath, File,,, FileExt
 IfNotInString, ScriptTypes, `n%FileExt%`n
 {
  FileRead, Contents, %File%
  If ErrorLevel
  {
   NotFound(ReceivedData,File,Contents,DataLen,Header,RemoteAddress)
   Return
  }
  GetContentType(FileExt,ContentType)
  If RunScripts(Contents,Values,ReceivedData,Header,RemoteAddress)
   DataLen := StrLen(Contents)
  Else
   FileGetSize, DataLen, %File%
 }
 Else
 {
  Temp1 := SubStr(File,StrLen(WebRoot) + 2)
  PollScript(Temp1,Values,ReceivedData,Header,RemoteAddress)
  VarSetCapacity(Contents,TagTextLen,13)
  DllCall("RtlMoveMemory","UInt",&Contents,"UInt",&TagText,"UInt",TagTextLen)
  ContentType := DefaultContentType
  DataLen := TagTextLen
 }
 If (Header = "")
  Header = HTTP/1.0 200 OK`r`nContent-Length: %DataLen%`r`nContent-Type: %ContentType%`r`n`r`n
 Else If !InStr(Header,"`n")
  Header = HTTP/1.0 200 OK`r`nContent-Length: %DataLen%`r`nContent-Type: %Header%`r`n`r`n
}

NotFound(ByRef ReceivedData,ByRef File,ByRef Contents,ByRef DataLen,ByRef Header,ByRef RemoteAddress)
{
 Header = HTTP/1.0 200 OK`r`nContent-Type: text/plain`r`n`r`n
 Contents = 404 Not Found`r`n%File%
 DataLen := StrLen(Contents)
}

NotImplemented(ByRef ReceivedData,ByRef File,ByRef Contents,ByRef DataLen,ByRef Header,ByRef RemoteAddress)
{
 Header = HTTP/1.0 501 Not Implemented`r`nContent-Type: text/plain`r`n`r`n
 Contents = 501 Not Implemented
 DataLen := StrLen(Contents)
}

PollScript(ByRef ScriptFile,ByRef Values,ByRef ReceivedData,ByRef Header,ByRef RemoteAddress)
{
 global ScriptErrorText
 global TagText
 global TagTextLen
 global WebRoot
 global AHKPath
 global ScriptMainID
 global ScriptTimeOut

 Values = %RemoteAddress%`n%Values%`n%ReceivedData%
 StringReplace, ScriptFile, ScriptFile, /, \, All
 % (SubStr(ScriptFile,1,1) = "\") ? ScriptFile := SubStr(ScriptFile,2)
 IfNotExist, %WebRoot%\%ScriptFile%
 {
  TagText = %ScriptErrorText%
  TagTextLen := StrLen(TagText)
  Return
 }
 DetectHiddenWindows, On
 SetTitleMatchMode, 2
 IfWinNotExist, %WebRoot%\%ScriptFile% ahk_class AutoHotkey
 {
  Run, "%AHKPath%" "%WebRoot%\%ScriptFile%" "%ScriptMainID%"
  WinWait, %WebRoot%\%ScriptFile% ahk_class AutoHotkey,, 2
  If ErrorLevel
  {
   TagText = %ScriptErrorText%
   TagTextLen := StrLen(TagText)
   Return
  }
  Sleep, 150
 }
 OnMessage(0x4a,"GetData")
 TagText = 
 If GiveData(Values,WebRoot . "\" . ScriptFile)
 {
  StartTime = %A_TickCount%
  While, !TagText
  {
   Sleep, 0
   If ((A_TickCount - StartTime) > ScriptTimeOut)
   {
    TagText = |%ScriptErrorText%
    TagTextLen := StrLen(TagText)
    Break
   }
  }
 }
 Else
 {
  TagText = |%ScriptErrorText%
  TagTextLen := StrLen(TagText)
 }
 OnMessage(0x4a,"")
 Temp1 := InStr(TagText,"|")
 Header := SubStr(TagText,1,Temp1 - 1)
 TagTextLen -= Temp1
 DllCall("RtlMoveMemory","UInt",&TagText,"UInt",&TagText + Temp1,"UInt",TagTextLen)
}

GetData(wParam,lParam) ;wip: make use of wparam to store length
{
 global TagText
 global TagTextLen
 TagTextLen := NumGet(lParam + 4)
 StringAddress := NumGet(lParam + 8)
 VarSetCapacity(TagText,TagTextLen,13)
 DllCall("RtlMoveMemory","UInt",&TagText,"UInt",StringAddress,"UInt",TagTextLen)
 Return, 1
}

GiveData(ByRef Data,Target)
{
 Critical
 VarSetCapacity(CopyDataStruct, 12, 0)
 NumPut(StrLen(Data) + 1,CopyDataStruct,4)
 NumPut(&Data,CopyDataStruct,8)
 SendMessage, 0x4a, 0, &CopyDataStruct,, %Target% ahk_class AutoHotkey
 Return, ErrorLevel
}

RewriteURL(ByRef URL)
{
 global RewriteRules
 Loop, Parse, RewriteRules, `n
 {
  StringSplit, Temp, A_LoopField, %A_Tab%
  URL := RegExReplace(URL,Temp1,Temp2,ReplaceCount)
  If ReplaceCount
   Return
 }
}

GetContentType(ByRef FileExt,ByRef ContentType)
{
 global MIMETypes
 global DefaultContentType
 Temp1 := InStr(MIMETypes,"`n" . FileExt . A_Tab)
 If Not Temp1
 {
  ContentType = %DefaultContentType%
  Return
 }
 Temp1 += StrLen(FileExt) + 2
 ContentType := SubStr(MIMETypes,Temp1,InStr(MIMETypes,"`n",False,Temp1) - Temp1), !ContentType ? ContentType := DefaultContentType
}

URLDecode(ByRef Encoded)
{
 StringReplace, Encoded, Encoded, +, %A_Space%, All
 Loop, Parse, Encoded, `%
  % (A_Index = 1) ? Decoded := A_LoopField : Decoded .= Chr("0x" . SubStr(A_LoopField,1,2)) . SubStr(A_LoopField,3)
 Return, RegExReplace(Decoded,"S)[^\w\s[::punct::]]")
}

RunScripts(ByRef Contents,ByRef Values,ByRef ReceivedData,ByRef Header,ByRef RemoteAddress)
{
 global TagText
 global OpenTag
 global CloseTag

 IfNotInString, Contents, %OpenTag%
  Return
 Temp1 := StrLen(OpenTag)
 Loop
 {
  TagPos := InStr(Contents,OpenTag) + Temp1
  If Not TagPos
   Break
  EndTagPos := InStr(Contents,CloseTag,False,TagPos)
  If Not EndTagPos
   Break
  Used = 1
  TagFile := SubStr(Contents,TagPos,EndTagPos - TagPos)
  TagOrig = %TagFile%
  PollScript(TagFile,Values,ReceivedData,Header,RemoteAddress)
  StringReplace, Contents, Contents, %OpenTag%%TagOrig%%CloseTag%, %TagText%
 }
 Return, Used
}

StartServer(NetworkAddress,NetworkPort)
{
 global Socket
 global ScriptMainID

 LoadSettings()
 Socket := PrepareConnection(NetworkAddress,NetworkPort)
 If Socket = -1
  ExitApp
 NotificationMessage = 0x5555
 FD_READ = 1 ;Data available to be read
 FD_CLOSE = 32 ;Connection closed
 FD_CONNECT = 20 ;Connection made
 FD_ACCEPT = 8 ;Connection accepted
 If DllCall("Ws2_32\WSAAsyncSelect","UInt",Socket,"UInt",ScriptMainID,"UInt",NotificationMessage,"Int",FD_ACCEPT | FD_READ | FD_CLOSE | FD_CONNECT)
  Return, DllCall("Ws2_32\WSAGetLastError")
 OnExit, ExitSub
 OnMessage(NotificationMessage,"ReceiveData")
}

PrepareConnection(IPAddress,Port)
{
 VarSetCapacity(WSAData,32)
 Result := DllCall("Ws2_32\WSAStartup","UShort",0x0002,"UInt",&WSAData)
 If ErrorLevel
 {
  MsgBox, 262160, Error, WSAStartup() could not be called due to error %ErrorLevel%. Winsock 2.0 or higher is required.
  Return, -1
 }
 If Result
 {
  MsgBox, 262160, Error, % "Winsock error: " . DllCall("Ws2_32\WSAGetLastError")
  Return, -1
 }
 AF_INET = 2 ;wip: maybe this can be replaced by AF_INET6, to use IPv6?
 ;AF_INET6 = 10
 SOCK_STREAM = 1
 IPPROTO_TCP = 6
 Socket := DllCall("Ws2_32\socket","Int",AF_INET,"Int",SOCK_STREAM,"Int",IPPROTO_TCP)
 If Socket = -1
 {
  MsgBox, 262160, Error, % "Winsock error: " . DllCall("Ws2_32\WSAGetLastError")
  Return, -1
 }
 SizeOfSocketAddress = 16
 VarSetCapacity(SocketAddress, SizeOfSocketAddress)
 NumPut(2,SocketAddress,0,AF_INET)
 NumPut(DllCall("Ws2_32\htons","UShort",Port),SocketAddress,2,2)
 NumPut(DllCall("Ws2_32\inet_addr","UInt",&IPAddress),SocketAddress,4,4)
 If DllCall("Ws2_32\bind","UInt",Socket,"UInt",&SocketAddress,"Int",SizeOfSocketAddress)
 {
  MsgBox, 262160, Error, % "Winsock error: " . DllCall("Ws2_32\WSAGetLastError")
  Return, -1
 }
 If DllCall("Ws2_32\listen","UInt",Socket,"UInt","SOMAXCONN")
 {
  MsgBox % "Winsock error: " . DllCall("Ws2_32\WSAGetLastError")
  Return, -1
 }
 Return, Socket
}

LoadSettings()
{
 global MIMEListFile
 global MIMETypes
 global ScriptTypesListFile
 global ScriptTypes
 global RewriteRulesFile
 global RewriteRules
 global ScriptMainID
 global hWs2_32

 FileRead, MIMETypes, %MIMEListFile%
 If ErrorLevel
  MIMETypes = `nhtm%A_Tab%text/html`nhtml%A_Tab%text/html`njpg%A_Tab%image/jpeg`ngif%A_Tab%image/gif`npng%A_Tab%image/png`n
 Else
 {
  StringReplace, MIMETypes, MIMETypes, `r,, All
  StringReplace, MIMETypes, MIMETypes, .,, All
  MIMETypes = `n%MIMETypes%`n
 }

 FileRead, ScriptTypes, %ScriptTypesListFile%
 If ErrorLevel
  ScriptTypes = `nahk`ncgi`n
 Else
 {
  StringReplace, ScriptTypes, ScriptTypes, `r,, All
  ScriptTypes = `n%ScriptTypes%`n
 }

 FileRead, RewriteRules, %RewriteRulesFile%
 StringReplace, RewriteRules, RewriteRules, `r,, All

 DetectHiddenWindows, On
 Process, Exist
 ScriptMainID := WinExist("ahk_class AutoHotkey ahk_pid " . ErrorLevel)
 DetectHiddenWindows, Off

 hWs2_32 := DllCall("LoadLibrary","Str","Ws2_32")

 SetEnvironment()
}

SetEnvironment()
{
 local ParseList
 ParseList = WebRoot,NetworkAddress,NetworkPort
 Loop, Parse, ParseList, CSV
  EnvSet, ENV_%A_LoopField%, % %A_LoopField%
}

!Esc::ExitApp

ExitSub:
MsgBox, 262180, Confirm Exit, Are you sure you want to shutdown the server?
IfMsgBox, No
 Return
DllCall("Ws2_32\WSACleanup")
DllCall("FreeLibrary","UInt",hWs2_32)
ExitApp