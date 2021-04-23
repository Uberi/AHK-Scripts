; Sparrow Webserver Core Version 0.1.3
; (w) Sep, 23 2008 derRaphael
; 
; Parts base on Zed Gecko's TCP/IP Script. Thank You!
; Many thanks to Lexikos, for testing and suggesting code improvements

; Many different parts from this code were written by many different people
; where the code originated to be someone else's it's writte so in the comments

; This server is to be in so called ALPHA DEVELOPMENT STATE.
; It is NOT under NO CIRCUMSTANCES to be taken as a Webserver for a production 
; environment. There are too many unresolved issues on stability and security.

; If you are looking for a reliable webserver, take a look at 
;   - Lighttpd
;   - Apache
; Both Server are available for Windows, too (whoever needs that)

; This Version works to a certain degree and has been tested. There are still
; many issues not fully working, not working at all or causing all kinds of
; unexpected side effects.

   #NoEnv

   SetBatchLines,-1
   Process, priority, , High
   FileRead,Sparrow[MimeTypesLst],mime.lst
   OnExit, ExitSub
      
   #include sparrow.settings.ahk
   SVars := "METHOD,REQUEST,QUERY,PROTOCOL"
   HeaderList := "Host,User-Agent,Accept,Accept-Language,Accept-Charset,"
               . "Keep-Alive,Connection,Referer"
   
   Menu,Tray,NoStandard
   Menu,Tray,Add, Debug`t(CTRL+F11), ^f11
   if (Sparrow[debugToolTips]="on")
      Menu,Tray,Check, Debug`t(CTRL+F11)
   Menu,Tray,Add
   Menu,Tray,Add, Restart`t(CTRL+F12), ^f12
   Menu,Tray,Add, Exit`t(Alt+F12), !f12
   Menu,Tray,Icon, sparrow.ico,1
   
   ; Start to listen at the defined port and address

   socket := WatchConnection(Sparrow[BindToAddress], Sparrow[ListenToPort])
   if socket = -1
      ExitApp

   DetectHiddenWindows On
   Process, Exist
   PID := ErrorLevel
   ScriptMainWindowId := WinExist("ahk_class AutoHotkey ahk_pid " PID)
   DetectHiddenWindows Off
   NotificationMsg = 0x5555
   OnMessage(NotificationMsg, "ReceiveData")
   
   FD_READ    := 0x1     ; Received when data is available to be read.
   FD_ACCEPT  := 0x8     ; Initialising a new Accept when a conncetion been made
   
   if DllCall("Ws2_32\WSAAsyncSelect", "UInt", socket, "UInt", ScriptMainWindowId, "UInt", NotificationMsg, "Int", FD_READ|FD_ACCEPT)
   {
      MsgBox % "WSAAsyncSelect() indicated Winsock error " . DllCall("Ws2_32\WSAGetLastError")
      ExitApp
   }
return

WatchConnection(IPAddress, Port)
{
   VarSetCapacity(wsaData, 32)
   result := DllCall("Ws2_32\WSAStartup", "UShort", 0x0002, "UInt", &wsaData)
   if ErrorLevel
   {
      MsgBox WSAStartup() could not be called due to error %ErrorLevel%. Winsock 2.0 or higher is required.
      return -1
   }
   if result
   {
      MsgBox % "WSAStartup() indicated Winsock error " . DllCall("Ws2_32\WSAGetLastError")
      return -1
   }

   AF_INET = 2
   SOCK_STREAM = 1
   IPPROTO_TCP = 6
   socket := DllCall("Ws2_32\socket", "Int", AF_INET, "Int", SOCK_STREAM, "Int", IPPROTO_TCP)
   if socket = -1
   {
      MsgBox % "socket() indicated Winsock error " . DllCall("Ws2_32\WSAGetLastError")
      return -1
   }

   SizeOfSocketAddress = 16
   VarSetCapacity(SocketAddress, SizeOfSocketAddress)
   NumPut(AF_INET, SocketAddress, 0, "UShort")
   NumPut(DllCall("Ws2_32\htons", "UShort", Port), SocketAddress, 2, "UShort")
   NumPut(DllCall("Ws2_32\inet_addr", "Str", IPAddress), SocketAddress, 4)

   if DllCall("Ws2_32\bind", "UInt", socket, "UInt", &SocketAddress, "Int", SizeOfSocketAddress)
   {
      MsgBox % "bind() indicated Winsock error " . DllCall("Ws2_32\WSAGetLastError") . "?"
      return -1
   }
   if DllCall("Ws2_32\listen", "UInt", socket, "UInt", 0x7fffffff)
   {
      MsgBox % "LISTEN() indicated Winsock error " . DllCall("Ws2_32\WSAGetLastError") . "?"
      return -1
   }

   return socket
}

; This procedure receives incoming network Traffic and passes
; hkml requests to proper parsing functions
ReceiveData(wParam, lParam)
{
    critical ; Needed to avoid loosing Messages
   
   if ( Lparam&0xffff = 0x8 ) {
      con := DllCall("Ws2_32\accept", "UInt", wParam, "UInt", 0, "Int", 0)
      return
   } else if ( Lparam&0xffff = 0x20 ) {
      res := DllCall("Ws2_32\closesocket", "UInt", wParam)
      if (res) {
         WinsockError := DllCall("Ws2_32\WSAGetLastError")
         MsgBox % "Ws2_32\closesocket indicated Winsock error " . WinsockError
      }
      return
   }

   ReceivedDataSize = 4096
   Loop
   {
      VarSetCapacity(ReceivedData, ReceivedDataSize, 0)
      ReceivedDataLength := DllCall("Ws2_32\recv", "UInt", wParam, "Str", ReceivedData, "Int", ReceivedDataSize, "Int", 0)
      if (ReceivedDataLength = 0) ; Connetion Gracefully Closed - Return
         return
      if (ReceivedDataLength = -1) {
         WinsockError := DllCall("Ws2_32\WSAGetLastError")
         if WinsockError = 10035
            return 1
         if WinsockError <> 10054
            MsgBox % "recv() indicated Winsock error " . WinsockError
         reload 
         ; This is intend to be failsafe .. reinitialise the complete script, in case
         ; this error happens, it usually cannot be recovered. So a reload is ATM the 
         ; best possible solution
      }
      ProcessRequest(wParam,ReceivedData,ReceivedDataLength)
   }
   return 1
}

; Here we receive any Requests made from outer connections.
; Its intention is to return the files, if any or errormessages
ProcessRequest(wParam, ReceivedData,ReceivedDataLength)
{
   Global
   critical
      sVars := "METHOD,REQUEST,QUERY,PROTOCOL"
      HeaderList := "Host,User-Agent,Accept,Accept-Language,Accept-Charset,"
                  . "Keep-Alive,Connection,Referer"
      fn := content := ""
      Loop, parse, ReceivedData, `n, `r
      {
         HeaderLine := A_LoopField
         if (A_Index=1)
            $_SERVER[QUERY] := HeaderLine
         ; Needs heavy fixing!
         Loop,Parse,HeaderList,`,
         {
			HeaderName := A_LoopField
            If (SubStr(HeaderLine,1,StrLen(HeaderName))=HeaderName) {
               if (InStr(HeaderName,"-"))
                  StringReplace,HeaderName,HeaderName,-,,All
;~                MsgBox % A_LoopField "/" HeaderName "/" A_Index
               $_SERVER[%HeaderName%] := RegExReplace(HeaderLine,"(^[^:]+:\s+)")
               sVars .= "," HeaderName
            }
         }
         If (RegExMatch(HeaderLine,"i)^Content\-Type"))
            break
      }
      FormatTime,cdate,%A_NowUTC%,ddd, d MMM yyyy H:mm:ss UTC
      
      fnp := RegExMatch($_SERVER[QUERY],"(?P<Method>[^\s]+)\s+(?P<Query>[^\s]+)\s+(?P<Protocol>.*)",Request)
      
      p := RegExMatch(RequestQuery,"(?P<URI>[^?]+)\??",r)
      p := RegExMatch(RequestQuery,"(?P<QUERY>\?[^#]+)\#?",r)
      
      $_SERVER[METHOD]   := RequestMethod
      $_SERVER[REQUEST]  := rURI
      $_SERVER[QUERY]    := rQUERY
      $_SERVER[PROTOCOL] := RequestProtocol
      
      fn := Sparrow[documentRoot] $_SERVER[REQUEST]
      
      if ($_SERVER[REQUEST]="/internal/sparrow_ahk_err.png") {
         ; Internal rewrite for funky Error Image
         fn := Sparrow[IncludeDir] "\img\ahk_err.png"
      } else {
         StringReplace,fn,fn,/,\,All
         if (SubStr(fn,0) = "\") {
            Loop,Parse,Sparrow[DftIndexFiles],|
               if (FileExist(fn . A_LoopField)) {
                  fn .= A_LoopField
                  break
               }
         }
      }
      ; Create if possible serverside $_GET Variables and a $_GET[Array]
      tmp := SubStr($_SERVER[QUERY],2), gVars := "", $_GET := "["
      Loop,Parse,tmp,&
      {
         RegExMatch(a_loopfield,"(?P<Name>[^=]+)=(?P<Value>.*)",Var)
         $_GET[%VarName%] := VarValue
         gVars .= "," VarName 
      }
      gVars := SubStr(gVars,2)
      $_GET .= gVars "]"
      
      if ($_SERVER[METHOD]="POST") {
         pVars := "", $_POST := ""
         ; Parse for different Content-Content Transfer Encodings
         Loop, parse, ReceivedData, `n, `r
            if (RegExMatch(A_LoopField,"i)^Content"))
               if (RegExMatch(A_LoopField,"i)application\/x\-www\-form\-urlencoded"))
                  PostDataType := "urlEncoded"
               else if (RegExMatch(A_LoopField,"i)multipart\/form\-data")) {
                  PostDataBoundaryLine := A_LoopField
                  PostDataType := "multiPart"
               } else if (RegExMatch(A_LoopField,"i)text\/plain"))
                  PostDataType := "plainText"
               else if (RegExMatch(A_LoopField,"i)Length")) {
                  PostDataLength := RegExReplace(A_LoopField,"[^\d]+")
                  Break
               }
         ; We now know the type of our postdata and its length. Use the proper routines
         ; to splitup and setup the $_POST array
         pdlOffset := ReceivedDataLength-PostDataLength
         VarSetCapacity(postDataBlock,PostDataLength,32)
         DllCall("RtlMoveMemory","uInt",&postDataBlock,"uInt",&ReceivedData+pdlOffset,"uInt",PostDataLength)
         if (PostDataType="plainText") {
            ; for some reasons i cannot see, this is awfully slow - just dont use it
            ; w3c recommends either using enctype="multipart/form-data" (the default if none given)
            ; or enctype="multipart/form-data" - text/plain just causes too many errors in parsing
            Loop,Parse,postDataBlock,`n,`r
            {
               if (InStr(A_LoopField,"="))
                  RegExMatch(A_LoopField,"(?P<Name>[^=]+)=(?P<Value>.*)",Var)
               if (old!=VarName) {
                  $_POST[%VarName%] := VarValue
                  old := varName
                  pVars .= "," VarName
               } else {
                  $_POST[%old%] .= A_loopField
               }
            }
         } else if (PostDataType="urlEncoded") {
            ; This is the default value if nothing is statet as enctype
            ; keep in mind, that filetransfer wont work this way
            StringReplace,postDataBlock,postDataBlock,&amp;,&,ALl
            Loop,parse,postDataBlock,&
            {
               RegExMatch(A_LoopField,"(?P<Name>[^=]+)=(?P<Value>.*)",Var)
               VarName := uriDecode(VarName)
               $_POST[%VarName%] := uriDecode(VarValue)
               pVars .= "," VarName
            }
         } else if (PostDataType="multiPart") {
            ;Get Boundary
            Boundary := RegExReplace(PostDataBoundaryLine,".*?boundary=")
            BoundaryCount := 0, bOffset := 1, bOffsetList := fVars := ""

            ; This is useful to determine if we use \r\n as lineends or just \n
            bOffsetCorrection := (RegExMatch(substr(PostDataBlock,1,StrLen(Boundary)+10),"\r\n")) ? 2 : 1
            bStart := 0
            ; Make OffsetList for BoundaryBlocks
            ; As Titan stated here,
            ;   http://www.autohotkey.com/forum/viewtopic.php?p=169289#169289
            ; RegEx also works with binary buffers - since a boundary name IMO never ever
            ; should include "\E" in it - proove me wrong - its pretty save to use
            loop,
                If (bOffset := RegExMatch(PostDataBlock,"ms)\Q--" boundary "\E",junk,bOffset)) {
                    if (bStart!=0) {
                        BL := bOffset - bStart - bOffsetCorrection - 1
                        VarSetCapacity(bTMP,BL,32)
                        DllCall("RtlMoveMemory","uInt",&bTMP,"uInt",&postDataBlock+bStart,"uInt",BL)
                        bLength := 0
                        Loop,Parse,bTMP,`n,`r
                        {
                            bLength := bLength + StrLen(A_LoopField) + bOffsetCorrection
                            if (A_LoopField="") {
                                VarSetCapacity(BoundaryValue,bLength,32)
                                DllCall("RtlMoveMemory","uInt",&BoundaryValue
                                                        ,"uInt",&bTMP+bLength
                                                        ,"uInt",BL-bOffsetCorrection)
                                if (StrLen(BoundaryFileName)>0) {
                                    $_POST[%BoundaryName%]           := BoundaryFileName
                                    $_FILE[%BoundaryName%][Name]     := BoundaryFileName
                                    $_FILE[%BoundaryName%][EncType] := BoundaryEncoding
                                    $_FILE[%BoundaryName%][Size]     := BL-bOffsetCorrection
                                    $_FILE[%BoundaryName%][TmpName]  := BoundaryTmpName
                                    res := write_bin(BoundaryValue,Sparrow[TmpDir] "\" BoundaryTmpName
                                                ,BL-bOffsetCorrection)
                                    fVars .= "," BoundaryName
                                } else 
                                    $_POST[%BoundaryName%] := BoundaryValue
                                pVars .= "," BoundaryName
                                break
                            } else if (RegExMatch(A_LoopField,"i)^Content\-Disposition\: form\-data;")) {
                                RegExMatch(A_LoopField,"i)name=""(?P<Name>[^""]+)""?",Boundary)
                                RegExMatch(A_LoopField,"i)filename=""(?P<FileName>[^""]+)""",Boundary)

                            } else if (RegExMatch(A_LoopField,"i)Content\-Type")) {
                                RegExMatch(A_LoopField,"i):\(?P<Encoding>.+)",Boundary)
                            }
                        }
                    }
                    bStart := bOffSet
                    bOffset+=10
                } else
                    Break
         }
         pVars := SubStr(pVars,2)
         fVars := SubStr(fVars,2)
      }
         $_POST := "[" pVars "]"
         $_FILE := "[" fVars "]"
      
      r := FileExist(fn)
      if ((r) && !(Instr(r,"D"))) {
         FileGetSize, size, %fn%
         FileGetTime, ft, %fn%
         FormatTime,ft,%ft%,ddd, d MMM yyyy H:mm:ss
         mime := MimeType(fn)
         
         httpStatus := "200 OK"
         LastModDate := "`r`nLast-Modified: " ft
         if ((Sparrow[hkmlEnabled]="on") && (RegExMatch(fn,"hkml$"))) {
            content := spawn("",fn)
            size := ErrorLevel
         } else
            FileRead,content,%fn%
         
      } Else if ((r) && (Instr(r,"D"))) {
         httpStatus := "403 - Forbidden"
      } else if (r="") {
         httpStatus := "404 - Not Found"
      } else {
         httpStatus := "500 - Internal Error"
      }
      
      ; Not OK? Do the ErrorMsg
      if (SubStr(httpStatus,1,3)!="200") {
         content := httpServerError(httpStatus)
         size := strLen(content)
         mime := "text/html"
      }
      
      ; Form a proper response header
      head =
      (LTrim Join`r`n
         %Sparrow[httpProtocol]% %httpStatus%
         Server: %Sparrow[ServerSig]%
         Date: %cdate%%LastModDate%
         Content-Length: %size%
         Content-Type: %mime%`r`n`r`n
      )
         
      ; Are we in Debug Mode ?
      if (Sparrow[debugToolTips]="on")
         ToolTip(fn "`n`n" head, 10)
            
      VarSetCapacity(sdata,strLen(head)+size+2,13)
      ; Insert Last LineFeed
      NumPut(10,sdata,strLen(head)+size+1,"uchar")
      ; Insert Header Data
      DllCall("RtlMoveMemory","uInt",&sdata,"uInt",&head,"uInt",strlen(head))
      ; Insert Content
      DllCall("RtlMoveMemory","uInt",&sdata+strlen(head),"uInt",&content,"uInt",size)
      ; SendBack the content
      SendData(wParam,sdata,strlen(head)+size)
}

SendData(wParam,byref data,size)
{
   sendret := DllCall("Ws2_32\send", "UInt", wParam, "Str", data, "Int", size, "Int", 0)
   if (sendret<1) {
      WinsockError := DllCall("Ws2_32\WSAGetLastError")
      MsgBox % "Ws2_32\send got an Error`n" WinsockError
   }
}

ExitSub:
   DllCall("Ws2_32\WSACleanup")
   ChildPID := Substr(ChildPID,2)
   Loop,Parse,ChildPID,|
   {
      Process,Exist,%A_LoopField%
      If (ErrorLevel = A_LoopField)
         Process,Close,%A_LoopField%
   }
   ExitApp


spawn(empty,fn) {
global
critical
hkml := FileContent(fn)

; Generate ServerVars
SERVERVARS := ""

Loop,Parse,sVars,`,
   SERVERVARS .=  "$_SERVER[" A_LoopField "]:=""" $_SERVER[%A_LoopField%] """`n"
   
;~ MsgBox % SERVERVARS
Loop,Parse,gVars,`,
   SERVERVARS .=  "$_GET[" A_LoopField "]:=""" $_GET[%A_LoopField%] """`n"
Loop,Parse,pVars,`,
   SERVERVARS .=  "$_POST[" A_LoopField "]:=""" $_POST[%A_LoopField%] """`n"
Loop,Parse,fVars,`,
   SERVERVARS .= "$_FILE[" A_LoopField "][TmpName]:=""" $_FILE[%A_LoopField%][TmpName] """`n"
               . "$_FILE[" A_LoopField "][Name]:="""    $_FILE[%A_LoopField%][Name] """`n"
               . "$_FILE[" A_LoopField "][Size]:="""    $_FILE[%A_LoopField%][Size] """`n"
               . "$_FILE[" A_LoopField "][EncType]:=""" $_FILE[%A_LoopField%][EncType] """`n"
SERVERVARS .= "$_POST:=""" $_POST """`n"
            . "$_GET:=""" $_GET """`n"
            . "$_FILE:=""" $_FILE """`n"
; Start off with fresh counter settings
scriptCount := RC := 0

; This loop is the heart of parser's core.
; It builds a temporary HTML with placeholders which
; have a unique ID so results will be put at the correct place
loop,
	; Check for the <?ahk ?> tag. It's content will be saved
	; into an ahk array for later reuse.
	if (RegExMatch(hkml,"ims)<\?ahk(.+?)\?>",script)) {
		; we have a match! update our counter
		scriptCount++
		; replace the scrippet with a placeholder
		StringReplace,hkml,hkml,%script%,{ResultOfHKMLScript[%ScriptCount%]}
		; store into array item
		Scriple[%scriptCount%] := script1
	} Else	
		; no more match? we're done!
		Break

; do we have an error yet?
If (StrLen(parser[err])>0) {
   hkml := parser[err]
} else {
; These variables are the standard startup indicating a run script by setting   
; the pipename and a marker which indicates the script gracefully finished.
pipe_name := "hkmlPipe"
%pipe_name%  := "DONE"

Loop, % scriptCount
{
	; Make sure, all embedded scripts run sequentially 
	; this is needed for being abled to use stor() to
	; update the internal VariableStack which gets
	; injected into each scrippet so it can be reused
	Loop,
		if (%pipe_name%!="DONE")
			sleep, 50
		Else
			break

	; The idea to this subroutine is from [VxE] to be found here:
	; http://www.autohotkey.com/forum/post-202143.html#202143
	captureException =
	( LTrim Join`r`n
		WatchMe:
			IfWinExist, `%A_ScriptName`%
			{
				SetTimer, WatchMe, OFF
				WinGetText, sOutput, `%A_ScriptName`%
				WinClose,`%A_ScriptName`%
                sOutput := "<err::cat2>" sOutPut "</err::cat2>"
				FileAppend, `%sOutput`%, *
			}
		return`r`n
	)
	; The last Line took me hours to find. I tried almost every thread
	; I found on AutoHotkey's forum.
	; Drifter's great collection
	;   http://www.autohotkey.com/forum/topic34517.html
	; AHKLerner's great Script from
	;   http://www.autohotkey.com/forum/topic30759.html
	; and Lexikos codes from
	;   http://www.autohotkey.com/forum/post-180763.html#180763
	;   http://www.autohotkey.com/forum/viewtopic.php?t=27854
	; But this solution actually came from AHK's Helpfile
	; a solution i totally missed to look at

	; Script modifications which apply to each script processed
    ; Further security modifications may be made here, too
    ; such as commenting out dangerous / forbidden comments
	Script := "#NoEnv`r`n"                         ; Setting up some standards
	        . "#NoTrayIcon`r`n"                    ; Hide this Script
			. "SetBatchLines,-1`r`n"               ; Execute it fast
			. "TargetPID:=""" DllCall("GetCurrentProcessId") """`r`n"   ; The caller's PID
			. "SetTimer,WatchMe,50`r`n"            ; Spin Off the exceptionWatcher
			. SERVERVARS "`r`n"                    ; Inject variables to be used
			. "IncludeDir:=""" Sparrow[IncludeDir] """`r`n`r`n"
			. Scriple[%A_Index%]                   ; Inject the scrippet
			. "`r`n`r`n"                           ; finally: Include the communication backend
            . "ExitApp`r`n"
            . FileContent(Sparrow[IncludeDir] "\hkml.includeMe.ahk") "`r`n`r`n"
			. captureException                     ; This is for capturing Exceptions from AHK
            
    ; Exchange any {IncludePath} Variables
    Loop
        if (RegExMatch(Script,"ims)%(?P<Name>Sparrow\[[^\]]+\])%",var))
            Script := RegExReplace(Script,"\Q%" varName "%\E","""" %varName% """")
        Else
            Break
    ; At this point, all Sparrow[] Variables are changed now. Lets Fix any ugly " " occurences.
    ; This might not be a good idea to have this in your script :) - the " " i mean.
    Script := RegExReplace(Script,""" """)
    ; Fix the includes
    loop,
    if (RegExMatch(Script,"ims)^\s*?#includescript"))
       Script := RegExReplace(Script,"ims)^\s*?#includescript\s+""(.+?)""","#Include $1")
    else 
       break
       
    ; Start the PipeReader to captchure any modified Variables, like Header
    ; and stuff
    ; GoSub, ReadComPipe

	; This Part has been published by Lexikos
	; Thread: "How to: Run Dynamic Script... Through a Pipe!"
	;         http://www.autohotkey.com/forum/topic25867.html
	; see comments in sparrow.helper.ahk for more details on this
    Result%A_Index% := ExecScript(Script,$_SERVER[REQUEST])
    %pipe_name% := piping := "DONE"
    RC := A_Index
    If (RegExMatch(Result%A_Index%,"ims)<(err\:\:cat.)>(?P<AHK>.*)<\/\1>",ERR)) {
       If (RegExMatch(Result%A_Index%,"ims)<err..cat2>")) {
         RegExMatch(ERRAHK,"ms)\Q--->\E\s+\d+\:(?P<CMD>.+?)\n",Line)
         ; Since the Script gets modified to include all neccessary variables, additional
         ; commands, etc it's no good in giving out the LineNumber
         ; Let's do a link do official documentation, php style :P
         CMD := RegExReplace(LineCMD,"i)^\s+|,.*")
         Link := "<a href=""http://www.autohotkey.com/docs/commands/" CMD ".htm"" style=""color:white;"">" CMD "</a>"
         LineCMD := RegExReplace(LineCMD,"\Q" CMD "\E",Link)
         ERRAHK := RegExReplace(ERRAHK,"ims)Near.*","Specific Command: " LineCMD)
       }
       hkml := "<html><head><title>AHK-Script Error</title></head><body>"
             . "<table align=center cellpadding=5 cellspacing=0 bgcolor=#404040 style=""border: 1px solid silver"">"
             . "<tr><td valign=top width=120px>"
             . "<img src=""/internal/sparrow_ahk_err.png"">"
             . "</td><td><h2 style=""font-family:Verdana;color:white;"">Oops - AHK-Script Error!</h2>"
             . "<hr size=1 width=90% color=#202020/>"
             . "<pre style=""color:silver;"">" ERRAHK "</pre></td></tr>"
             . "</table></html><body>"
   }
}

; Here we are done with every parse Script - even if there were none
; anyways let's return whatever we have
Loop,% RC
	; Parse HKML and insert the proper ScriptResults
    StringReplace,hkml,hkml,% "{ResultOfHKMLScript[" A_Index "]}",% Result%A_Index%
}

ErrorLevel := StrLen(hkml)
return hkml
}

ReadComPipe:
   If (Piping="DONE")
       return
   else if (FileExist("\\.\pipe\includeMe")) {
       Loop,Read,% "\\.\pipe\includeMe"
           Data .= A_LoopReadLine "`n"
       MsgBox % data
       SetTimer,ReadComPipe,-200
   }
Return

:*:lh::http://localhost:81/index.hkml
^f12::
MsgBox,1,Hint,Press OK to reload the Server
IfMsgBox, OK
   reload
return
!f12::ExitApp
^f11::
   Menu,Tray,ToggleCheck, Debug`t(CTRL+F11)
   Sparrow[debugToolTips] := (Sparrow[debugToolTips]="on") ? "off" : "on"
   ToolTip("Debug: " Sparrow[debugToolTips], 3)
return

#include sparrow.helper.ahk
