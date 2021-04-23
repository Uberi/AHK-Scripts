; Part of Sparrow Webserver Core Version 0.1.3
;  - (w) Sep, 23 2008 derRaphael - 
;
; This is the sparrow supportive Lib
; ======================================
;   Version 0.1
;   Date: Sep, 19 2008
;   Written by DerRaphael
; ======================================
; It's either used in spawned scrippets
; or from sparrow core
; 

; Part of Lexikos' Scripts: How to: Run Dynamic Script... Through a Pipe!
; http://www.autohotkey.com/forum/topic25867.html
CreateNamedPipe(Name, OpenMode=3, PipeMode=0, MaxInstances=255) {
	return DllCall("CreateNamedPipe","str","\\.\pipe\" Name,"uint",OpenMode
		,"uint",PipeMode,"uint",MaxInstances,"uint",0,"uint",0,"uint",0,"uint",0)
}

; Thx for this custom adaption, Lexikos!
; Parts of this function include code from Sean's StdOutToVar
; http://www.autohotkey.com/forum/topic16823.html
ExecScript(Script,fn)
{
    ; Create a more Unique PipeName
    pipe_name := "ahkpipe-" A_TickCount

    ; Before reading the file, AutoHotkey calls GetFileAttributes(). This causes
    ; the pipe to close, so we must create a second pipe for the actual file contents.
    ; Open them both before starting AutoHotkey, or the second attempt to open the
    ; "file" will be very likely to fail. The first created instance of the pipe
    ; seems to reliably be "opened" first. Otherwise, WriteFile would fail.
    pipe_ga := CreateNamedPipe(pipe_name, 2)
    pipe    := CreateNamedPipe(pipe_name, 2)
    if (pipe=-1 or pipe_ga=-1) {
        MsgBox CreateNamedPipe failed.
        ExitApp
    }
    
    ;Run, %A_AhkPath% "\\.\pipe\%pipe_name%"
    sCmd = %A_AhkPath% /ErrorStdOut "\\.\pipe\%pipe_name%"

    ; From Sean's StdoutToVar() - http://www.autohotkey.com/forum/viewtopic.php?t=16823
    DllCall("CreatePipe", "UintP", hStdInRd , "UintP", hStdInWr , "Uint", 0, "Uint", 0)
    DllCall("CreatePipe", "UintP", hStdOutRd, "UintP", hStdOutWr, "Uint", 0, "Uint", 0)
    DllCall("SetHandleInformation", "Uint", hStdInRd , "Uint", 1, "Uint", 1)
    DllCall("SetHandleInformation", "Uint", hStdOutWr, "Uint", 1, "Uint", 1)

    VarSetCapacity(pi, 16, 0)
    NumPut(VarSetCapacity(si, 68, 0), si)	; size of si
    NumPut(0x100	, si, 44)		; STARTF_USESTDHANDLES
    NumPut(hStdInRd	, si, 56)		; hStdInput
    NumPut(hStdOutWr, si, 60)		; hStdOutput
    NumPut(hStdOutWr, si, 64)		; hStdError
    If Not DllCall("CreateProcess", "Uint", 0, "Uint", &sCmd, "Uint", 0, "Uint", 0, "int", True, "Uint", 0x08000000, "Uint", 0, "Uint", 0, "Uint", &si, "Uint", &pi)	; bInheritHandles and CREATE_NO_WINDOW
        return
    
    DllCall("CloseHandle", "Uint", NumGet(pi,0))
    DllCall("CloseHandle", "Uint", NumGet(pi,4))
    DllCall("CloseHandle", "Uint", hStdOutWr)
    DllCall("CloseHandle", "Uint", hStdInRd)
    DllCall("CloseHandle", "Uint", hStdInWr)
    ; ~ StdoutToVar()
    
    ; Wait for AutoHotkey to connect to pipe_ga via GetFileAttributes().
    DllCall("ConnectNamedPipe","uint",pipe_ga,"uint",0)
    ; This pipe is not needed, so close it now. (The pipe instance will not be fully
    ; destroyed until AutoHotkey also closes its handle.)
    DllCall("CloseHandle","uint",pipe_ga)
    ; Wait for AutoHotkey to connect to open the "file".
    DllCall("ConnectNamedPipe","uint",pipe,"uint",0)
    
    ; AutoHotkey reads the first 3 bytes to check for the UTF-8 BOM. If it is
    ; NOT present, AutoHotkey then attempts to "rewind", thus breaking the pipe.
    Script := chr(239) chr(187) chr(191) Script
    
    if !DllCall("WriteFile","uint",pipe,"str",Script,"uint",StrLen(Script)+1,"uint*",0,"uint",0)
        MsgBox WriteFile failed: %ErrorLevel%/%A_LastError%
    
    DllCall("CloseHandle","uint",pipe)
    
    ; StdoutToVar() ~
    VarSetCapacity(sTemp, nTemp:=4095)
    Loop
        If DllCall("ReadFile", "Uint", hStdOutRd, "Uint", &sTemp, "Uint", nTemp, "UintP", nSize:=0, "Uint", 0)&&nSize
        {
            NumPut(0,sTemp,nSize,"Uchar"), VarSetCapacity(sTemp,-1), sOutput.=sTemp
        }
        Else Break
    DllCall("CloseHandle", "Uint", hStdOutRd)
    
    ; Make the returned Output look more friendly than just the good ol' MsgBox
    sOutput := RegExReplace(sOutput,"\Q\\.\pipe\" pipe_name "\E","<err::cat1>Found Error in Filename: '" fn "'")
    sOutput := RegExReplace(sOutput,"\((\d+)\)\s+\:")
    sOutput := RegExReplace(sOutput,"==>","`n`nAHK [" A_AhkVersion "] Interpreter: ")
    sOutput := RegExReplace(sOutput,"ims)^\s+Specifically","Near")
    sOutput := RegExReplace(sOutput,"i)(Near.*)","$1</err::cat1>")
   
    ; Finally return all grabbed ErrorStdOut content
    return sOutput
}

; Get proper MIME Type by file's ext from a list
MimeType(fn) {
; (w) derRaphael / zLib Style released
   Global Sparrow[MimeTypesLst]
   critical

   SplitPath,fn,,,ext
   
   if (Mime="")
      Loop,Parse,Sparrow[MimeTypesLst],`n,`r
      {
         RegExMatch(A_LoopField,"s)(?P<Ext>.*?)\t(?P<Mime>.*)",Type)
         if (TypeExt = "." ext) {
            Mime := TypeMime
            break
         }
      }
   if (Mime="")
      Mime := "application/octet-stream"
      
   return mime
}

; This function is for debugging purposes
Tooltip(sTooltipTxt,Seconds=5) {
; (w) derRaphael / zLib Style released
   if (Seconds+0=0)
      Seconds = 5
   StartTime := EndTime := A_Now
   EnvAdd,EndTime,Seconds,Seconds
   Loop,
      if (EndTime=A_Now)
         Break
      else {
         ToolTip, %sTooltipTxt%
         sleep, 50
      }
   ToolTip
}

; Actually this is a file from sparrow.core.ahk
; err check needs a rework for custom files
httpServerError(msg) {
   global
   errNo := RegExReplace(msg,"\s.+")
   if (Sparrow[Custom_Err_%errNo%]!="") {
      errFile := Sparrow[errorDocPath] Sparrow[Custom_Err_%errNo%]
      if !(FileExist(errFile))
         AdditionalErr := "Additionally a '404 - Not Found' error occured while processing this message."
      else
            FileRead,content,%errFile%
   } 
   if ((Sparrow[Custom_Err_%errNo%]="") || (AdditionalErr)) {
      content := "<html>`r`n"
               . "<head><title>" Msg "</title></head>`r`n"
               . "<body>`r`n"
               . "<h1>" Msg "</h1>`r`n"
               . ( AdditionalErr ? AdditionalErr : "") . "<br />`r`n"
               . ( Sparrow[ShowServerSig] = "on" ? "<hr />`r`n<i>" Sparrow[ServerSig] "</i>`r`n" : "")
               . "</body></html>"
   }
   return content
}

; Return a file's content
FileContent(name) {
    tmp := ""
    if ((fE:=fileExist(name)) && !(InStr(fE,"D")))
        FileRead,tmp,%name%
    return tmp
}

; Encode a string to an URI-Encoded String
; basically all Chars not being in range of a to z, A to Z, 0 to 9 (and few others)
; get 'translated' to an ASCII Value represented in Hex with a leading percent
uriEncode(str)
{ ; v 0.4 / (w) 21.09.2008 by derRaphael / zLib-Style release
	b_Format := A_FormatInteger
	data := ""
	SetFormat,Integer,H
	Loop,Parse,str
		if (((Asc(A_LoopField)>0x7f) || (Asc(A_LoopField)<0x30) || (asc(A_LoopField)=0x3d)) && (asc(A_LoopField)!=0x20))
			data .= "%" . ((StrLen(c:=SubStr(ASC(A_LoopField),3))<2) ? "0" . c : c)
        else if (asc(A_LoopField)!=0x20)
            data .= "+"
		Else
			data .= A_LoopField
	SetFormat,Integer,%b_format%
	return data
}
; Decodes an uriEncoded String 
uriDecode(str)
{ ; v 0.3 / (w) 21.09.2008 by derRaphael / zLib-Style release
    StringReplace,str,str,+,%A_Space%,All
	Loop,Parse,str,`%
	{
		if (A_Index>1)
			RegExMatch(A_LoopField,"(?P<Hex>..)(?P<rest>.*)",var)
		else
			txt := A_LoopField
		txt .= chr("0x" varHex) varRest
	}
	return txt
}

; writing out binary buffers
write_bin(byref bin,filename,size){
   h := DllCall("CreateFile","str",filename,"Uint",0x40000000
            ,"Uint",0,"UInt",0,"UInt",4,"Uint",0,"UInt",0)
   IfEqual h,-1, SetEnv, ErrorLevel, -1
   IfNotEqual ErrorLevel,0,ExitApp ; couldn't create the file
   r := DllCall("SetFilePointerEx","Uint",h,"Int64",0,"UInt *",p,"Int",0)
   IfEqual r,0, SetEnv, ErrorLevel, -3
   IfNotEqual ErrorLevel,0, {
      t = %ErrorLevel%              ; save ErrorLevel to be returned
      DllCall("CloseHandle", "Uint", h)
      ErrorLevel = %t%              ; return seek error
   }
   result := DllCall("WriteFile","UInt",h,"Str",bin,"UInt"
               ,size,"UInt *",Written,"UInt",0)
   h := DllCall("CloseHandle", "Uint", h)
   return, 1
}

; changes `n in a text to <BR>`n
nl2br(text) {
	Text := RegExReplace(text,"\r")
    Text := RegExReplace(text,"\n","<br/ >`n")
	return Text
}

; Checks if a variable exists
IsSet(var){
  local tst
  VarSetCapacity(tst,0)
  Return (var==tst) ? FALSE : TRUE
}

Send_WM_COPYDATA(ByRef StringToSend, ByRef PID)  ; ByRef saves a little memory in this case.
; This function sends the specified string to the specified window and returns the reply.
; The reply is 1 if the target window processed the message, or 0 if it ignored it.
{
;~     VarSetCapacity(CopyDataStruct, 12, 0)  ; Set up the structure's memory area.
;~     ; First set the structure's cbData member to the size of the string, including its zero terminator:
;~     NumPut(StrLen(StringToSend) + 1, CopyDataStruct, 4)  ; OS requires that this be done.
;~     NumPut(&StringToSend, CopyDataStruct, 8)  ; Set lpData to point to the string itself.
;~     Prev_DetectHiddenWindows := A_DetectHiddenWindows
;~     Prev_TitleMatchMode := A_TitleMatchMode
;~     DetectHiddenWindows On
;~     SetTitleMatchMode 2
;~     SendMessage, 0x4a, 0, &CopyDataStruct,, ahk_pid %PID%  ; 0x4a is WM_COPYDATA. Must use Send not Post.
;~     DetectHiddenWindows %Prev_DetectHiddenWindows%  ; Restore original setting for the caller.
;~     SetTitleMatchMode %Prev_TitleMatchMode%         ; Same.
    return 1  ; Return SendMessage's reply back to our caller.
}