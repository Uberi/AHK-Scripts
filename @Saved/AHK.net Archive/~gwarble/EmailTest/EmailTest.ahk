; EmailTest v0.5

#NoEnv
#SingleInstance, Force
#NoTrayIcon
SetWorkingDir %A_ScriptDir%
;Compile("Run")

If Instance("","-")
 Return

 FromName    = Test Author
 FromAddress = test@email.com
 From := """" FromName """ <" FromAddress ">"

 EmailCount = 1

Method=BlatDll
; Email, EmailBlat, EmailBlatExe, EmailMailsend less Email

 IniRead, To,   EmailTest.ini, Config, To, someone@email.com
 IniRead, From,   EmailTest.ini, Config, From, %From%
 IniRead, Host, EmailTest.ini, Config, Host, % A_Space
 IniRead, Port, EmailTest.ini, Config, Port, % A_Space
 IniRead, User, EmailTest.ini, Config, User, % A_Space
 IniRead, Pass, EmailTest.ini, Config, Pass, % A_Space

 Gui, Destroy
 Gui, Default
 Gui, +Resize +LabelCompose +MinSize400x300
 Gui  +LastFound
 Gui, Add, StatusBar,,
 SB_SetText("Compose a new email...",1)
 Gui, Font, s8 w550, Arial
 Gui, Add,	Edit, 		x-10 y-10 w0 h0

 Gui, Add,	Edit, 		x10 y10    w160 R1	vHost hWndhwndHost, % Host
 Gui, Add,	Edit, 		x+5    w40 R1	vPort hWndhwndPort, % Port
 Gui, Add,	Edit, 		x10 y+5    w110 R1	vUser hWndhwndUser, % User
 Gui, Add,	Edit, 		x+5    w110 R1	vPass hWndhwndPass, % Pass

 Gui, Add, Text, 		x315 y13 w80 Right, Method: 
 Gui, Add, DropDownList,	x+5 w120 y10  vMethod hwndhwndMethod, COM||COM Instance|Blat Dll|Blat Exe|Mailsend

 Gui, Add,	Text, 		 x315 y+7 w80 Right R1	, Loop:
 Gui, Add,	Edit, 		 x+5 y+-18    w50 R1	vEmailCount hWndhwndCount, 1
 Gui, Add,	UpDown, 	Range1-100, 1

 Gui, Add, Button,	x10 w100 y70 vSave gSaveSettings, Save Settings

 SetCue(hwndHost, " SMTP Host...")
 SetCue(hwndPort, " Port...")
 SetCue(hwndUser, " UserName...")
 SetCue(hwndPass, " Password...")
 SetCue(hwndCount, " # to send...")

 Gui, Add,	Button,		x5   y105  w48 h48 Center gComposeSend BackgroundTrans, Send
 Gui, Font, s10 w550, Arial
 Gui, Add,	Text, 		x65  y108  w40		Right		, From:
 Gui, Add,	Edit, 		x110 y106  w800 R1	vFrom	, %From%
 Gui, Add,	Text, 		x65  y140  w40		Right		, To:
 Gui, Add,	Edit, 		x110 y138       R1	vTo Default, %To%
 Gui, Add,	Text, 		x45   y172  w60		Right		, Subject:
 Gui, Add,	Edit, 		x110 y170       R1	vSubject, %Subject%
 Gui, Add,	Text, 		x5   y185  w30		Right		, Body:
 Gui, Add,	Edit, 		x5   y204   w375    R5	vBody, %Body%

 Gui, Add,	Listview, 	x+5   y204 w240 Grid	vAttachments, File|kB|Path
 LV_ModifyCol(1,110)
 LV_ModifyCol(2,"50 Integer")
 Gui, Show, h470 w535, Email Method Test
Return

SaveSettings:
 IniWrite, % To,   EmailTest.ini, Config, To 
 IniWrite, % From, EmailTest.ini, Config, From
 IniWrite, % Host, EmailTest.ini, Config, Host 
 IniWrite, % Port, EmailTest.ini, Config, Port
 IniWrite, % User, EmailTest.ini, Config, User
 IniWrite, % Pass, EmailTest.ini, Config, Pass
Return

ComposeDropFiles:
 If A_GuiControl <> Attachments
  Return
 StringSplit, Attach, A_GuiEvent, `n
 Loop, %Attach0%
 {
;SplitPath, InputVar [, OutFileName, OutDir, OutExtension, OutNameNoExt, OutDrive
  SplitPath, Attach%A_Index%, Attach%A_Index%File, Attach%A_Index%Path
  FileGetSize, Attach%A_Index%Size, % Attach%A_Index%
  LV_Add("",Attach%A_Index%File, Ceil(Attach%A_Index%Size/1024), Attach%A_Index%Path)
;  Notify(Attach%A_Index%File "`n" Ceil(Attach%A_Index%Size/1024) "kb`n" Attach%A_Index%Path)
  AttachmentList .= Attach%A_Index% "|"
 }
Return

ComposeSend:
 Gui, Submit,NoHide
 Gui, +Disabled
 GoSub, SaveSettings
 GuiControl, +Disabled, Send
 GuiControl, +Disabled, From
 GuiControl, +Disabled, To
 GuiControl, +Disabled, Subject
 GuiControl, +Disabled, Body
 SB_SetText("Sending email...",1)
 StringTrimRight, _Attach, AttachmentList, 1
; Notify(_Attach)
 If (Subject="") AND (Body="")
 {
  MsgBox, , Error, No email subject or body...
  SB_SetText("Add a subject or body...",1)
 } 
 Else If !EmailMethod(Method,To,Subject,Body,From,_Attach,User,Pass,Host,Port,TLS)
 {
  SB_SetText("Error sending email...",1)
  MsgBox, , Error, Error sending email...
 }
 Else
 {
  SB_SetText("Finished sending email...",1)
  Sleep, 1000
  SetTimer, SBReset, -1000
 }

 Gui, -Disabled
 GuiControl, -Disabled, Send
 GuiControl, -Disabled, From
 GuiControl, -Disabled, To
 GuiControl, -Disabled, Subject
 GuiControl, -Disabled, Body
Return

SBReset:
  SB_SetText("Compose a new email...",1)
Return

ComposeSize:
 GuiControl, Move, From, 	% "w" A_GuiWidth-115
 GuiControl, Move, To, 		% "w" A_GuiWidth-115
 GuiControl, Move, Subject, 	% "w" A_GuiWidth-115
 GuiControl, Move, Body, 	% "w" A_GuiWidth-260  " h" A_GuiHeight-231
 GuiControl, MoveDraw, Attachments, 	% "x" A_GuiWidth-247  " h" A_GuiHeight-231
Return

ComposeClose:
ComposeEscape:
 Gui, Destroy
ExitApp
Return

-Email: ; for Instance()
 A_0 = %0%
 Loop, %A_0%
  A_%A_Index% := % %A_Index%
 If Email(A_2,A_3,A_4,A_5,A_6,A_7,A_8,A_9,A_10)
  SendMessage, 0x1357, 1357, 9, , % "ahk_pid " A_11
 Else
  SendMessage, 0x1357, 1357, 8, , % "ahk_pid " A_11
ExitApp
Return

Instance_8:
 InstanceDone=-1
Return
Instance_9:
 InstanceDone=1
Return

EmailMethod(Method, To="",Subject="",Body="",From="",_Attach="",User="",Pass="",SMTP="",Port="",TLS="") {
 global
 If Method = COM
 {
 Loop %EmailCount%
  If !Email(To,Subject,Body,From,_Attach,User,Pass,Host,Port,TLS)
   Return 0 ;, % Email(To,Subject,Body,From,_Attach,User,Pass,Host,Port,TLS)
  Else
   sleep, 1000
 Return 1
 }
 If Method = COM Instance
 {
  Loop %EmailCount%
  {
   Instance("-Email" , To " " Subject " " Body " " From " """ _Attach """ """ User """ """ Pass """ """ Host """ """ Port """ """ TLS)
   Loop
    If InstanceDone = 1
     break
    Else If InstanceDone = -1
    {
     InstanceDone = 0
     Return 0
    }
   InstanceDone = 0
   Return 1
  }
 }
 If Method = Blat Dll
  Return, % EmailBlatDll(To,Subject,Body,From,_Attach,User,Pass,Host,Port,TLS)
 If Method = Blat Exe
  Return, % EmailBlatExe(To,Subject,Body,From,_Attach,User,Pass,Host,Port,TLS)
 If Method = Mailsend
  Return, % EmailMailsend(To,Subject,Body,From,_Attach,User,Pass,Host,Port,TLS)
Return 0
}

Email(To="",Subject="",Body="",From="",_Attach="",User="",Pass="",SMTP="",Port="",TLS="") {
 Critical     ;= set defaults here:
 static _To   := ""
 static _Subj := ""
 static _Body := ""
 static _From := """From"" <sender@email.com>"
 static _User := "sender@email.com"
 static _Pass := "pass"
 static _SMTP := "smtp.email.com"   ;gmail:smtp.gmail.com
 static _Port := 587                ;gmail:465 norm:25 ifblocked:587
 static _TLS  := False              ;gmail:True
 static _Send := 2                  ;cdoSendUsingPort
 static _Auth := 1                  ;cdoBasic

 If To   <>
  _To   := To
 IfNotInString, _To, @
  Return 0
 If Subject <> 
  _Subj := Subject
 If Body <>
  _Body := Body
 If From <>
  _From := From
 If User <>
  _User := User
 If Pass <>
  _Pass := Pass
 If SMTP <>
  _SMTP := SMTP
 If Port <>
  _Port := Port
 If TLS  <>
  _TLS  := TLS

 COM_Init()
 pmsg :=   COM_CreateObject("CDO.Message")
 pcfg :=   COM_Invoke(pmsg, "Configuration")
 pfld :=   COM_Invoke(pcfg, "Fields")

 COM_Invoke(pfld, "Item", "http://schemas.microsoft.com/cdo/configuration/sendusing", _Send)
 COM_Invoke(pfld, "Item", "http://schemas.microsoft.com/cdo/configuration/smtpconnectiontimeout", 60)
 COM_Invoke(pfld, "Item", "http://schemas.microsoft.com/cdo/configuration/smtpserver", _SMTP)
 COM_Invoke(pfld, "Item", "http://schemas.microsoft.com/cdo/configuration/smtpserverport", _Port)
 COM_Invoke(pfld, "Item", "http://schemas.microsoft.com/cdo/configuration/smtpusessl", _TLS)
 COM_Invoke(pfld, "Item", "http://schemas.microsoft.com/cdo/configuration/smtpauthenticate", _Auth)
 COM_Invoke(pfld, "Item", "http://schemas.microsoft.com/cdo/configuration/sendusername", _User)
 COM_Invoke(pfld, "Item", "http://schemas.microsoft.com/cdo/configuration/sendpassword", _Pass)
 COM_Invoke(pfld, "Update")

 COM_Invoke(pmsg, "From",     _From)
 COM_Invoke(pmsg, "To",       _To)
 COM_Invoke(pmsg, "Subject",  _Subj)
 COM_Invoke(pmsg, "TextBody", _Body)
 Loop, Parse, _Attach, |, %A_Space%%A_Tab%
  COM_Invoke(pmsg, "AddAttachment", A_LoopField)
 COM_Invoke(pmsg, "Send")

 COM_Release(pfld)
 COM_Release(pcfg)
 COM_Release(pmsg)
 COM_Term()

Return 1
}

EmailBlatDll(To="",Subject="",Body="",From="",_Attach="",User="",Pass="",SMTP="",Port="",TLS="")
{
 IfNotExist, blat.dll
  UrlDownloadToFile, http://www.autohotkey.net/~gwarble/EmailTest/blat.dll, blat.dll
 IfNotExist, blat.dll
  Return 0
 StringReplace, From, From, ",,A
 EmailString= - -f "%From%" -u %User% -pw %Pass% -server %SMTP% -body "%Body%" -subject "%Subject%" -to %To%
 Return % !DllCall("blat.dll\Send",str,EmailString)
}

EmailBlatExe(To="",Subject="",Body="",From="",_Attach="",User="",Pass="",SMTP="",Port="",TLS="")
{
 IfNotExist, blat.exe
  UrlDownloadToFile, http://www.autohotkey.net/~gwarble/EmailTest/blat.exe, blat.exe
 IfNotExist, blat.exe
  Return 0
 StringReplace, From, From, ",,A
 EmailString= - -f "%From%" -u %User% -pw %Pass% -server %SMTP% -body "%Body%" -subject "%Subject%" -to %To%
 If _Attach <> ""
 {
  StringReplace, _Attach, _Attach, |, `,, A
  EmailString .= " -attach """ _Attach """"
 }
 RunWait, blat %EmailString%,, UseErrorLevel Hide
 Return, % !ErrorLevel
}
EmailMailsend(To="",Subject="",Body="",From="",_Attach="",User="",Pass="",SMTP="",Port="",TLS="")
{
;mailsend -f muquit@example.com -d example.com -smtp 10.100.30.1
; -t muquit@muquit.com -sub test -a "nf.jpg,image/jpeg,i"
; -M "content disposition is inline"
 IfNotExist, mailsend.exe
  UrlDownloadToFile, http://www.autohotkey.net/~gwarble/EmailTest/mailsend.exe, mailsend.exe
 IfNotExist, mailsend.exe
  Return 0
 EmailString= -f "%From%" -user %User% -pass %Pass% -smtp %SMTP% -M "%Body%" -sub "%Subject%" -t %To%
 If _Attach <> ""
 {
  StringReplace, _Attach, _Attach, |, `,, A
  EmailString .= " -attach """ _Attach """"
 }
; clipboard := EmailString
 RunWait, mailsend %EmailString%,, UseErrorLevel Hide
 Return, % ErrorLevel
}

SetCue( control, text ) { ; -------------------------------
; Sets the text which appears in a blank edit control when the control
; does not have focus. 'Control' should either be the HWND of an edit
; control, an edit control's variable name, or the edit control's
; classNN (which will be 'EditNN'). Returns true if successful.
; IMPORTANT! Does NOT work for MULTILINE edit controls.
   Static EM_SETCUEBANNER := 5377
   OEL := ErrorLevel, OLFW := WinExist()
   If WinExist( "AHK_ID " . Abs( control ) ) = control
      hwnd := control
   Else GuiControlGet, hwnd, HWND, %control%
   VarSetCapacity( wText, 2 * len := StrLen( text ) + 1, 0 )
   DllCall("MultiByteToWideChar", "UInt", 65001, "UInt", 0
      , "Str", text, "Int", -1, "Str", wText, "Int", len )
   SendMessage, EM_SETCUEBANNER, 0, &wText, , ahk_id %hwnd%
   Return ErrorLevel+0, ErrorLevel := OEL, WinExist( "AHK_ID " OLFW )
}

; Instance() - 0.41 - gwarble
;  creates another instance to perform a task
;    help: http://www.autohotkey.com/forum/viewtopic.php?p=310694
;
; Instance(Label,Params,AltWM)
;
;  Label   "" to initialize, in autoexecute section usually
;          "Label" to start a new instance, whose execution will be
;            redirected to the "Label" subroutine
;
;  Params  parameters to pass to new instance (retrieved normally, ie: %2%)
;          when initializing (ie: label="") Params is a label prefix for all calls
;          last param received by script is calling-instance's ProcessID
;
;  AltWM   Alternate WindowsMessage number if 0x1357 (arbitrary anyway) will conflict
;
;  Return  0 on normal initialization (ie: label="" and %1% <> any label:)
;          Process ID of new instance
;          0 on failed new instance (called label name not exist)

Instance(Label="", Params="", WM="0x1357") {
 global 1		; uses first command line parameter to redirect auto-execute section
 If Label =
 {
  Label = %1%
  If (InStr(Label, Params) = 1)
  {
   If IsLabel(Label)
   {
    GoSub, %Label%
    Return 1
   }
  }
  Else
  {
   pDHW := A_DetectHiddenWindows
   DetectHiddenWindows, On
   WinGet, Instance_ID, List, %A_ScriptFullPath%
   If (Params <> "Single")
    Loop %Instance_ID%
     SendMessage, WM, WM, 0, , % "ahk_id " Instance_ID%A_Index%
   DetectHiddenWindows, %pDHW%
   OnMessage(WM, "Instance_")
  }
  Return 0
 }
 Else
 {
  If IsLabel(Label)
  {
   ProcessID := DllCall("GetCurrentProcessId")
   If A_IsCompiled
    Run, "%A_ScriptFullPath%" /f "%Label%" %Params% %ProcessID%,,,Instance_PID
   Else
    Run, "%A_AhkPath%" /f "%A_ScriptFullPath%" "%Label%" %Params% %ProcessID%,,,Instance_PID 
   Return %Instance_PID%
  }
  Return 0
 }
 #SingleInstance, Off 	; your script needs this anyway for Instance() to be useful
}


Instance_(wParam, lParam) {	; OnMessage Handler for singleInstance behavior or to
 Critical		; send messages back to calling instance via subroutine to run
 If lParam = 0		; (ie status updates, "i'm finished", etc)
  ExitApp		 ; if message lparam sent back besides 0, calling
 Else If IsLabel(Label := "Instance_" lParam) ; ; instance looks for and runs label Instance_%lParam%
  GoSub, %Label%		; so the script would have a label like:
 Return		; Instance_1: and Instance_2: or Instance_%Integer%:
}		; and the new instance can SendMessage,WM,WM,Integer to the calling instance



;;
;  Compile() - 0.41 - by gwarble
;    compile your script on demand, with local icons/AutoHotkey.bin
;
; Compile(Action,Name,Password)
;
;    Action   "" [Default]  -waits for the compiler to finish before returning
;             Run           -to run the compiled script and close the running script
;             NoWait        -starts compiling and continues running your script
;             Recompile     -closes the running .exe and launches the .ahk (if compiled)
;                             (useful for a self-editing compiled script)
;
;    Name     "" [Default]  -uses filename of script for exe/ico/bin filenames
;             Other         -specify a different name for the input ico/bin and output exe
;
;    Password **            -compilation password
;
;    Return   1 on success
;             0 on failure, compiler not found, already compiled, etc...
;
;    Notes    save custom icon as ScriptName.ico (in a subdir is ok) or
;             save modified AutoHotkeySC.bin as ScriptName.AHK.bin
;
Compile(Action="",Name="",Password="") {
 If A_IsCompiled	
  If Action <> Recompile	; unless "ReCompile", function does nothing when running compiled
   Return 0
  Else
  {
   SplitPath, A_ScriptFullPath,,,,ScriptName
   Run, %ScriptName%.ahk 	; if is Recompile, will close the running exe and launch the ahk script
   Return 1		; which should have its own auto-exeute Compile("Run")
  }
 SplitPath, A_ScriptFullPath,, ScriptDir,, ScriptName
 If Name <>
  ScriptName := Name	; Name parameter overrides icon/exe name from Scripts name
 Icon := ExeFile := ScriptDir "\" ScriptName ".exe"
 Loop, %ScriptName%.AHK.bin, 0, 1	; find .AHK.bin file if it exists, including subdirs
  IfExist %A_LoopFileFullPath%
  {
   Icon := CompilerBin := A_LoopFileFullPath
   Break
  }
 If CompilerBin =		; otherwise, use a found ScriptName.ico for the compile process
  Loop, %ScriptName%.ico, 0, 1	; including subdirs
   IfExist %A_LoopFileFullPath%	
   {
    ScriptIcon = /icon "%A_LoopFileFullPath%"
    Icon = %A_LoopFileFullPath%	; and sets it for the run string to run the compiler later
    Break
   }
 SplitPath, A_AhkPath,, Compiler,,,  ; find compiler...
 Compiler := Compiler "\Compiler\Ahk2Exe.exe"	; assumes compiler is in AHKPath default Compiler dir
 IfNotExist %Compiler%		; otherwise, checks registry for AHK install dir
 {			; poor method checks the context menu for the compile command
  RegRead, Compiler, HKCR, AutoHotkeyScript\Shell\Compile\Command ; for location of compiler
  StringReplace, Compiler, Compiler, ",,All
  StringReplace, Compiler, Compiler, % "/in %l"	; and clean up that context menu command to the exe path
  IfNotExist %Compiler%
  {
   Loop %A_StartMenuCommon%\*.*, 0, 1	; otherwise check the start menu for compiler's default shortcut
    If A_LoopFileName contains convert .ahk to .exe
    {
     FileGetShortcut, % A_LoopFileFullPath, Compiler
     Break
    }
   IfNotExist %Compiler%		; otherwise assumes AHK (and compiler) is not installed
    Loop, %A_ScriptDir%\Ahk2Exe.exe, 0, 1	; so checks the local dir for the compiler
     Compiler := %A_LoopFileFullPath% 	; including subdirs
  }
  IfNotExist %Compiler%		; and after all that if no compiler is found, returns error (0)
   Return 0   			; compiler not found
 }

 Prev_DetectHiddenWindows := A_DetectHiddenWindows
 DetectHiddenWindows On		; loop to WinClose all running processes before compiling
 Loop
  IfWinExist, % ExeFile
   WinClose,,,30
  Else
   Break
 DetectHiddenWindows %Prev_DetectHiddenWindows%

 If (Password)  			; sets compilation password
  Password := "/pass " Password		; untested feature

 Loop, %ScriptName%.AHK.bin, 0, 1
  IfExist %A_LoopFileFullPath%		; if custom .bin is used, copy it in place
  {			; after backing up the original
   SplitPath, Compiler,, CompilerDir,,,
   CompilerBin := CompilerDir "\AutoHotkeySC.bin"
   FileCopy, % CompilerBin, % CompilerDir "\AutoHotkeySC.Last.bin", 1 ; backed up original every run
   FileCopy, % CompilerBin, % CompilerDir "\AutoHotkeySC.Orig.bin", 0 ; first backup made won't be overwritten
   FileCopy, % A_LoopFileFullPath , % CompilerBin, 1
   Break
  }			; and finally, put all those options together
 RunLine = %Compiler% /in "%A_ScriptFullPath%" /out "%ExeFile%" %ScriptIcon% %Password%
 If Action = NoWait		; decide how to run it (first parameter)
  Run,     % RunLine, % A_ScriptDir, Hide
 Else
  RunWait, % RunLine, % A_ScriptDir, Hide
 If (CompilerBin)			; restore the original SC.bin file if a custom one was used
  FileCopy, % CompilerDir "\AutoHotkeySC.Last.bin", % CompilerBin, 1
 If Action = Run			; and run the compiled script if "Run" option is used (typical)
 {
  Run, % ScriptName
  ExitApp
 }
Return 1
}


;------------------------------------------------------------------------------
; COM.ahk Standard Library
; by Sean
; http://www.autohotkey.com/forum/topic22923.html
;------------------------------------------------------------------------------

COM_Init()
{
	Return	DllCall("ole32\OleInitialize", "Uint", 0)
}

COM_Term()
{
	Return	DllCall("ole32\OleUninitialize")
}

COM_VTable(ppv, idx)
{
	Return	NumGet(NumGet(1*ppv)+4*idx)
}

COM_QueryInterface(ppv, IID = "")
{
	If	DllCall(NumGet(NumGet(1*ppv)+0), "Uint", ppv, "Uint", COM_GUID4String(IID,IID ? IID : IID=0 ? "{00000000-0000-0000-C000-000000000046}" : "{00020400-0000-0000-C000-000000000046}"), "UintP", ppv)=0
	Return	ppv
}

COM_AddRef(ppv)
{
	Return	DllCall(NumGet(NumGet(1*ppv)+4), "Uint", ppv)
}

COM_Release(ppv)
{
	Return	DllCall(NumGet(NumGet(1*ppv)+8), "Uint", ppv)
}

COM_QueryService(ppv, SID, IID = "")
{
	DllCall(NumGet(NumGet(1*ppv)+4*0), "Uint", ppv, "Uint", COM_GUID4String(IID_IServiceProvider,"{6D5140C1-7436-11CE-8034-00AA006009FA}"), "UintP", psp)
	DllCall(NumGet(NumGet(1*psp)+4*3), "Uint", psp, "Uint", COM_GUID4String(SID,SID), "Uint", IID ? COM_GUID4String(IID,IID) : &SID, "UintP", ppv:=0)
	DllCall(NumGet(NumGet(1*psp)+4*2), "Uint", psp)
	Return	ppv
}

COM_FindConnectionPoint(pdp, DIID)
{
	DllCall(NumGet(NumGet(1*pdp)+ 0), "Uint", pdp, "Uint", COM_GUID4String(IID_IConnectionPointContainer, "{B196B284-BAB4-101A-B69C-00AA00341D07}"), "UintP", pcc)
	DllCall(NumGet(NumGet(1*pcc)+16), "Uint", pcc, "Uint", COM_GUID4String(DIID,DIID), "UintP", pcp)
	DllCall(NumGet(NumGet(1*pcc)+ 8), "Uint", pcc)
	Return	pcp
}

COM_GetConnectionInterface(pcp)
{
	VarSetCapacity(DIID, 16, 0)
	DllCall(NumGet(NumGet(1*pcp)+12), "Uint", pcp, "Uint", &DIID)
	Return	COM_String4GUID(&DIID)
}

COM_Advise(pcp, psink)
{
	DllCall(NumGet(NumGet(1*pcp)+20), "Uint", pcp, "Uint", psink, "UintP", nCookie)
	Return	nCookie
}

COM_Unadvise(pcp, nCookie)
{
	Return	DllCall(NumGet(NumGet(1*pcp)+24), "Uint", pcp, "Uint", nCookie)
}

COM_Enumerate(penum, ByRef Result, ByRef vt = "")
{
	VarSetCapacity(varResult,16,0)
	If (0 =	hr:=DllCall(NumGet(NumGet(1*penum)+12), "Uint", penum, "Uint", 1, "Uint", &varResult, "UintP", 0))
		Result:=(vt:=NumGet(varResult,0,"Ushort"))=8||vt<0x1000&&DllCall("oleaut32\VariantChangeTypeEx","Uint",&varResult,"Uint",&varResult,"Uint",LCID,"Ushort",1,"Ushort",8)=0 ? COM_Ansi4Unicode(bstr:=NumGet(varResult,8)) . COM_SysFreeString(bstr) : NumGet(varResult,8)
	Return	hr
}

COM_Invoke(pdsp,name="",prm0="vT_NoNe",prm1="vT_NoNe",prm2="vT_NoNe",prm3="vT_NoNe",prm4="vT_NoNe",prm5="vT_NoNe",prm6="vT_NoNe",prm7="vT_NoNe",prm8="vT_NoNe",prm9="vT_NoNe")
{
	If	name=
	Return	COM_Release(pdsp)
	If	name contains .
	{
		SubStr(name,1,1)!="." ? name.=".":name:=SubStr(name,2) . ".",COM_AddRef(pdsp)
	Loop,	Parse,	name, .
	{
	If	A_Index=1
	{
		name :=	A_LoopField
		Continue
	}
	Else If	name not contains [,(
		prmn :=	""
	Else If	InStr("])",SubStr(name,0))
	Loop,	Parse,	name, [(,'")]
	If	A_Index=1
		name :=	A_LoopField
	Else	prmn :=	A_LoopField
	Else
	{
		name .=	"." . A_LoopField
		Continue
	}
	If	A_LoopField!=
		pdsp:=	COM_Invoke(pdsp,name,prmn!="" ? prmn:"vT_NoNe")+COM_Release(pdsp)*0,name:=A_LoopField
	Else	Return	prmn!="" ? COM_Invoke(pdsp,name,prmn,prm0,prm1,prm2,prm3,prm4,prm5,prm6,prm7,prm8):COM_Invoke(pdsp,name,prm0,prm1,prm2,prm3,prm4,prm5,prm6,prm7,prm8,prm9),COM_Release(pdsp)
	}
	}
	sParams	:= "0123456789"
	Loop,	Parse,	sParams
		If	(prm%A_LoopField% == "vT_NoNe")
		{
			sParams	:= SubStr(sParams,1,A_Index-1)
			Break
		}
	VarSetCapacity(varg,16*nParams:=StrLen(sParams),0), VarSetCapacity(DispParams,16,0), VarSetCapacity(varResult,32,0), VarSetCapacity(ExcepInfo,32,0)
	Loop, 	Parse,	sParams
;		If	prm%A_LoopField%+0=="" || InStr(prm%A_LoopField%,".") || prm%A_LoopField%>=0x80000000 || prm%A_LoopField%<-0x80000000
		If	prm%A_LoopField% is not integer
			NumPut(COM_SysAllocString(prm%A_LoopField%),NumPut(8,varg,(nParams-A_Index)*16),4)
		Else	NumPut(SubStr(prm%A_LoopField%,1,1)="+" ? 9:prm%A_LoopField%=="-0" ? (prm%A_LoopField%:=0x80020004)*0+10:3,NumPut(prm%A_LoopField%,varg,(nParams-A_Index)*16+8),-12,"Ushort")
	If	nParams
		NumPut(nParams,NumPut(&varg,DispParams),4)
	If	(nvk :=	SubStr(name,0)="=" ? 12:3)=12
		name :=	SubStr(name,1,-1),NumPut(1,NumPut(NumPut(-3,varResult,4)-4,DispParams,4),4)
	Global	COM_HR, COM_LR:=""
	If	(COM_HR:=DllCall(NumGet(NumGet(1*pdsp)+20),"Uint",pdsp,"Uint",&varResult+16,"UintP",COM_Unicode4Ansi(wname,name),"Uint",1,"Uint",LCID,"intP",dispID,"Uint"))=0&&(COM_HR:=DllCall(NumGet(NumGet(1*pdsp)+24),"Uint",pdsp,"int",dispID,"Uint",&varResult+16,"Uint",LCID,"Ushort",nvk,"Uint",&DispParams,"Uint",&varResult,"Uint",&ExcepInfo,"Uint",0,"Uint"))!=0&&nParams&&nvk!=12&&(COM_LR:=DllCall(NumGet(NumGet(1*pdsp)+24),"Uint",pdsp,"int",dispID,"Uint",&varResult+16,"Uint",LCID,"Ushort",12,"Uint",NumPut(1,NumPut(NumPut(-3,varResult,4)-4,DispParams,4),4)-16,"Uint",0,"Uint",0,"Uint",0,"Uint"))=0
		COM_HR:=0
	Loop, %	nParams
		NumGet(varg,(A_Index-1)*16,"Ushort")=8 ? COM_SysFreeString(NumGet(varg,(A_Index-1)*16+8)) : ""
	Global	COM_VT := NumGet(varResult,0,"Ushort")
	Return	COM_HR=0 ? COM_VT>1 ? COM_VT=8||COM_VT<0x1000&&DllCall("oleaut32\VariantChangeTypeEx","Uint",&varResult,"Uint",&varResult,"Uint",LCID,"Ushort",1,"Ushort",8)=0 ? COM_Ansi4Unicode(bstr:=NumGet(varResult,8)) . COM_SysFreeString(bstr):NumGet(varResult,8):"":COM_Error(COM_HR,COM_LR,&ExcepInfo,name)
}

COM_Invoke_(pdsp,name,typ0="",prm0="",typ1="",prm1="",typ2="",prm2="",typ3="",prm3="",typ4="",prm4="",typ5="",prm5="",typ6="",prm6="",typ7="",prm7="",typ8="",prm8="",typ9="",prm9="")
{
	If	name contains .
	{
		SubStr(name,1,1)!="." ? name.=".":name:=SubStr(name,2) . ".", COM_AddRef(pdsp)
	Loop,	Parse,	name, .
	{
	If	A_Index=1
	{
		name :=	A_LoopField
		Continue
	}
	Else If	name not contains [,(
		prmn :=	""
	Else If	InStr("])",SubStr(name,0))
	Loop,	Parse,	name, [(,'")]
	If	A_Index=1
		name :=	A_LoopField
	Else	prmn :=	A_LoopField
	Else
	{
		name .=	"." . A_LoopField
		Continue
	}
	If	A_LoopField!=
		pdsp:=	COM_Invoke(pdsp,name,prmn!="" ? prmn:"vT_NoNe")+COM_Release(pdsp)*0,name:=A_LoopField
	Else	Return	COM_Invoke_(pdsp,name,typ0,prm0,typ1,prm1,typ2,prm2,typ3,prm3,typ4,prm4,typ5,prm5,typ6,prm6,typ7,prm7,typ8,prm8,typ9,prm9),COM_Release(pdsp)
	}
	}
	sParams	:= "0123456789"
	Loop,	Parse,	sParams
		If	(typ%A_LoopField% = "")
		{
			sParams	:= SubStr(sParams,1,A_Index-1)
			Break
		}
	VarSetCapacity(varg,16*nParams:=StrLen(sParams),0), VarSetCapacity(DispParams,16,0), VarSetCapacity(varResult,32,0), VarSetCapacity(ExcepInfo,32,0)
	Loop,	Parse,	sParams
		NumPut(typ%A_LoopField%,varg,(nParams-A_Index)*16,"Ushort"),typ%A_LoopField%&0x4000=0 ? NumPut(typ%A_LoopField%=8 ? COM_SysAllocString(prm%A_LoopField%):prm%A_LoopField%,varg,(nParams-A_Index)*16+8,typ%A_LoopField%=5||typ%A_LoopField%=7 ? "double":typ%A_LoopField%=4 ? "float":"int64"):typ%A_LoopField%=0x400C||typ%A_LoopField%=0x400E ? NumPut(prm%A_LoopField%,varg,(nParams-A_Index)*16+8):(VarSetCapacity(_ref_%A_LoopField%,8,0),NumPut(&_ref_%A_LoopField%,varg,(nParams-A_Index)*16+8),NumPut((prmx:=prm%A_LoopField%)&&typ%A_LoopField%=0x4008 ? COM_SysAllocString(%prmx%):%prmx%,_ref_%A_LoopField%,0,typ%A_LoopField%=0x4005||typ%A_LoopField%=0x4007 ? "double":typ%A_LoopField%=0x4004 ? "float":"int64"))
	If	nParams
		NumPut(nParams,NumPut(&varg,DispParams),4)
	If	(nvk :=	SubStr(name,0)="=" ? 12:3)=12
		name :=	SubStr(name,1,-1),NumPut(1,NumPut(NumPut(-3,varResult,4)-4,DispParams,4),4)
	Global	COM_HR, COM_LR:=""
	If	(COM_HR:=DllCall(NumGet(NumGet(1*pdsp)+20),"Uint",pdsp,"Uint",&varResult+16,"UintP",COM_Unicode4Ansi(wname,name),"Uint",1,"Uint",LCID,"intP",dispID,"Uint"))=0&&(COM_HR:=DllCall(NumGet(NumGet(1*pdsp)+24),"Uint",pdsp,"int",dispID,"Uint",&varResult+16,"Uint",LCID,"Ushort",nvk,"Uint",&DispParams,"Uint",&varResult,"Uint",&ExcepInfo,"Uint",0,"Uint"))!=0&&nParams&&nvk!=12&&(COM_LR:=DllCall(NumGet(NumGet(1*pdsp)+24),"Uint",pdsp,"int",dispID,"Uint",&varResult+16,"Uint",LCID,"Ushort",12,"Uint",NumPut(1,NumPut(NumPut(-3,varResult,4)-4,DispParams,4),4)-16,"Uint",0,"Uint",0,"Uint",0,"Uint"))=0
		COM_HR:=0
	Loop,	Parse,	sParams
		typ%A_LoopField%&0x4000=0 ? (typ%A_LoopField%=8 ? COM_SysFreeString(NumGet(varg,(nParams-A_Index)*16+8)):""):typ%A_LoopField%=0x400C||typ%A_LoopField%=0x400E ? "":(prmx:=prm%A_LoopField%,%prmx%:=typ%A_LoopField%=0x4008 ? COM_Ansi4Unicode(prmx:=NumGet(_ref_%A_LoopField%)) . COM_SysFreeString(prmx):NumGet(_ref_%A_LoopField%,0,typ%A_LoopField%=0x4005||typ%A_LoopField%=0x4007 ? "double":typ%A_LoopField%=0x4004 ? "float":"int64"))
	Global	COM_VT := NumGet(varResult,0,"Ushort")
	Return	COM_HR=0 ? COM_VT>1 ? COM_VT=8||COM_VT<0x1000&&DllCall("oleaut32\VariantChangeTypeEx","Uint",&varResult,"Uint",&varResult,"Uint",LCID,"Ushort",1,"Ushort",8)=0 ? COM_Ansi4Unicode(bstr:=NumGet(varResult,8)) . COM_SysFreeString(bstr):NumGet(varResult,8):"":COM_Error(COM_HR,COM_LR,&ExcepInfo,name)
}

COM_DispInterface(this, prm1="", prm2="", prm3="", prm4="", prm5="", prm6="", prm7="", prm8="")
{
	Critical
	If	A_EventInfo = 6
		hr:=DllCall(NumGet(NumGet(0+p:=NumGet(this+8))+28),"Uint",p,"Uint",prm1,"UintP",pname,"Uint",1,"UintP",0), hr==0 ? (VarSetCapacity(sfn,63),DllCall("user32\wsprintfA","str",sfn,"str","%s%S","Uint",this+40,"Uint",pname,"Cdecl"),COM_SysFreeString(pname),%sfn%(prm5,this,prm6)):""
	Else If	A_EventInfo = 5
		hr:=DllCall(NumGet(NumGet(0+p:=NumGet(this+8))+40),"Uint",p,"Uint",prm2,"Uint",prm3,"Uint",prm5)
	Else If	A_EventInfo = 4
		NumPut(0*hr:=0x80004001,prm3+0)
	Else If	A_EventInfo = 3
		NumPut(0,prm1+0)
	Else If	A_EventInfo = 2
		NumPut(hr:=NumGet(this+4)-1,this+4)
	Else If	A_EventInfo = 1
		NumPut(hr:=NumGet(this+4)+1,this+4)
	Else If	A_EventInfo = 0
		COM_IsEqualGUID(this+24,prm1)||InStr("{00020400-0000-0000-C000-000000000046}{00000000-0000-0000-C000-000000000046}",COM_String4GUID(prm1)) ? NumPut(NumPut(NumGet(this+4)+1,this+4)-8,prm2+0):NumPut(0*hr:=0x80004002,prm2+0)
	Return	hr
}

COM_DispGetParam(pDispParams, Position = 0, vt = 8)
{
	VarSetCapacity(varResult,16,0)
	DllCall("oleaut32\DispGetParam", "Uint", pDispParams, "Uint", Position, "Ushort", vt, "Uint", &varResult, "UintP", nArgErr)
	Return	NumGet(varResult,0,"Ushort")=8 ? COM_Ansi4Unicode(NumGet(varResult,8)) . COM_SysFreeString(NumGet(varResult,8)) : NumGet(varResult,8)
}

COM_DispSetParam(val, pDispParams, Position = 0, vt = 8)
{
	Return	NumPut(vt=8 ? COM_SysAllocString(val) : val,NumGet(NumGet(pDispParams+0)+(NumGet(pDispParams+8)-Position)*16-8),0,vt=11||vt=2 ? "short" : "int")
}

COM_Error(hr = "", lr = "", pei = "", name = "")
{
	Static	bDebug:=1
	If Not	pei
	{
	bDebug:=hr
	Global	COM_HR, COM_LR
	Return	COM_HR&&COM_LR ? COM_LR<<32|COM_HR:COM_HR
	}
	Else If	!bDebug
	Return
	hr ? (VarSetCapacity(sError,1023),VarSetCapacity(nError,10),DllCall("kernel32\FormatMessageA","Uint",0x1000,"Uint",0,"Uint",hr<>0x80020009 ? hr : (bExcep:=1)*(hr:=NumGet(pei+28)) ? hr : hr:=NumGet(pei+0,0,"Ushort")+0x80040200,"Uint",0,"str",sError,"Uint",1024,"Uint",0),DllCall("user32\wsprintfA","str",nError,"str","0x%08X","Uint",hr,"Cdecl")) : sError:="The COM Object may not be a valid Dispatch Object!`n`tFirst ensure that COM Library has been initialized through COM_Init().`n", lr ? (VarSetCapacity(sError2,1023),VarSetCapacity(nError2,10),DllCall("kernel32\FormatMessageA","Uint",0x1000,"Uint",0,"Uint",lr,"Uint",0,"str",sError2,"Uint",1024,"Uint",0),DllCall("user32\wsprintfA","str",nError2,"str","0x%08X","Uint",lr,"Cdecl")) : ""
	MsgBox, 260, COM Error Notification, % "Function Name:`t""" . name . """`nERROR:`t" . sError . "`t(" . nError . ")" . (bExcep ? SubStr(NumGet(pei+24) ? DllCall(NumGet(pei+24),"Uint",pei) : "",1,0) . "`nPROG:`t" . COM_Ansi4Unicode(NumGet(pei+4)) . COM_SysFreeString(NumGet(pei+4)) . "`nDESC:`t" . COM_Ansi4Unicode(NumGet(pei+8)) . COM_SysFreeString(NumGet(pei+8)) . "`nHELP:`t" . COM_Ansi4Unicode(NumGet(pei+12)) . COM_SysFreeString(NumGet(pei+12)) . "," . NumGet(pei+16) : "") . (lr ? "`n`nERROR2:`t" . sError2 . "`t(" . nError2 . ")" : "") . "`n`nWill Continue?"
	IfMsgBox, No, Exit
}

COM_CreateIDispatch()
{
	Static	IDispatch
	If Not	VarSetCapacity(IDispatch)
	{
		VarSetCapacity(IDispatch,28,0),   nParams=3112469
		Loop,   Parse,   nParams
		NumPut(RegisterCallback("COM_DispInterface","",A_LoopField,A_Index-1),IDispatch,4*(A_Index-1))
	}
	Return &IDispatch
}

COM_GetDefaultInterface(pdisp, LCID = 0)
{
	DllCall(NumGet(NumGet(1*pdisp) +12), "Uint", pdisp , "UintP", ctinf)
	If	ctinf
	{
	DllCall(NumGet(NumGet(1*pdisp)+16), "Uint", pdisp, "Uint" , 0, "Uint", LCID, "UintP", ptinf)
	DllCall(NumGet(NumGet(1*ptinf)+12), "Uint", ptinf, "UintP", pattr)
	DllCall(NumGet(NumGet(1*pdisp)+ 0), "Uint", pdisp, "Uint" , pattr, "UintP", ppv)
	DllCall(NumGet(NumGet(1*ptinf)+76), "Uint", ptinf, "Uint" , pattr)
	DllCall(NumGet(NumGet(1*ptinf)+ 8), "Uint", ptinf)
	If	ppv
	DllCall(NumGet(NumGet(1*pdisp)+ 8), "Uint", pdisp),	pdisp := ppv
	}
	Return	pdisp
}

COM_GetDefaultEvents(pdisp, LCID = 0)
{
	DllCall(NumGet(NumGet(1*pdisp)+16), "Uint", pdisp, "Uint" , 0, "Uint", LCID, "UintP", ptinf)
	DllCall(NumGet(NumGet(1*ptinf)+12), "Uint", ptinf, "UintP", pattr)
	VarSetCapacity(IID,16), DllCall("RtlMoveMemory", "Uint", &IID, "Uint", pattr, "Uint", 16)
	DllCall(NumGet(NumGet(1*ptinf)+76), "Uint", ptinf, "Uint" , pattr)
	DllCall(NumGet(NumGet(1*ptinf)+72), "Uint", ptinf, "UintP", ptlib, "UintP", idx)
	DllCall(NumGet(NumGet(1*ptinf)+ 8), "Uint", ptinf)
	Loop, %	DllCall(NumGet(NumGet(1*ptlib)+12), "Uint", ptlib)
	{
		DllCall(NumGet(NumGet(1*ptlib)+20), "Uint", ptlib, "Uint", A_Index-1, "UintP", TKind)
		If	TKind <> 5
			Continue
		DllCall(NumGet(NumGet(1*ptlib)+16), "Uint", ptlib, "Uint", A_Index-1, "UintP", ptinf)
		DllCall(NumGet(NumGet(1*ptinf)+12), "Uint", ptinf, "UintP", pattr)
		nCount:=NumGet(pattr+48,0,"Ushort")
		DllCall(NumGet(NumGet(1*ptinf)+76), "Uint", ptinf, "Uint" , pattr)
		Loop, %	nCount
		{
			DllCall(NumGet(NumGet(1*ptinf)+36), "Uint", ptinf, "Uint", A_Index-1, "UintP", nFlags)
			If	!(nFlags & 1)
				Continue
			DllCall(NumGet(NumGet(1*ptinf)+32), "Uint", ptinf, "Uint", A_Index-1, "UintP", hRefType)
			DllCall(NumGet(NumGet(1*ptinf)+56), "Uint", ptinf, "Uint", hRefType , "UintP", prinf)
			DllCall(NumGet(NumGet(1*prinf)+12), "Uint", prinf, "UintP", pattr)
			nFlags & 2 ? DIID:=COM_String4GUID(pattr) : bFind:=COM_IsEqualGUID(pattr,&IID)
			DllCall(NumGet(NumGet(1*prinf)+76), "Uint", prinf, "Uint" , pattr)
			DllCall(NumGet(NumGet(1*prinf)+ 8), "Uint", prinf)
		}
		DllCall(NumGet(NumGet(1*ptinf)+ 8), "Uint", ptinf)
		If	bFind
			Break
	}
	DllCall(NumGet(NumGet(1*ptlib)+ 8), "Uint", ptlib)
	Return	bFind ? DIID : "{00000000-0000-0000-0000-000000000000}"
}

COM_GetGuidOfName(pdisp, Name, LCID = 0)
{
	DllCall(NumGet(NumGet(1*pdisp)+16), "Uint", pdisp, "Uint", 0, "Uint", LCID, "UintP", ptinf)
	DllCall(NumGet(NumGet(1*ptinf)+72), "Uint", ptinf, "UintP", ptlib, "UintP", idx)
	DllCall(NumGet(NumGet(1*ptinf)+ 8), "Uint", ptinf), ptinf:=0
	DllCall(NumGet(NumGet(1*ptlib)+44), "Uint", ptlib, "Uint", COM_Unicode4Ansi(Name,Name), "Uint", 0, "UintP", ptinf, "UintP", memID, "UshortP", 1)
	DllCall(NumGet(NumGet(1*ptlib)+ 8), "Uint", ptlib)
	DllCall(NumGet(NumGet(1*ptinf)+12), "Uint", ptinf, "UintP", pattr)
	GUID := COM_String4GUID(pattr)
	DllCall(NumGet(NumGet(1*ptinf)+76), "Uint", ptinf, "Uint" , pattr)
	DllCall(NumGet(NumGet(1*ptinf)+ 8), "Uint", ptinf)
	Return	GUID
}

COM_GetTypeInfoOfGuid(pdisp, GUID, LCID = 0)
{
	DllCall(NumGet(NumGet(1*pdisp)+16), "Uint", pdisp, "Uint", 0, "Uint", LCID, "UintP", ptinf)
	DllCall(NumGet(NumGet(1*ptinf)+72), "Uint", ptinf, "UintP", ptlib, "UintP", idx)
	DllCall(NumGet(NumGet(1*ptinf)+ 8), "Uint", ptinf), ptinf := 0
	DllCall(NumGet(NumGet(1*ptlib)+24), "Uint", ptlib, "Uint", COM_GUID4String(GUID,GUID), "UintP", ptinf)
	DllCall(NumGet(NumGet(1*ptlib)+ 8), "Uint", ptlib)
	Return	ptinf
}

; A Function Name including Prefix is limited to 63 bytes!
COM_ConnectObject(psource, prefix = "", DIID = "")
{
	If Not	DIID
		0+(pconn:=COM_FindConnectionPoint(psource,"{00020400-0000-0000-C000-000000000046}")) ? (DIID:=COM_GetConnectionInterface(pconn))="{00020400-0000-0000-C000-000000000046}" ? DIID:=COM_GetDefaultEvents(psource) : "" : pconn:=COM_FindConnectionPoint(psource,DIID:=COM_GetDefaultEvents(psource))
	Else	pconn:=COM_FindConnectionPoint(psource,SubStr(DIID,1,1)="{" ? DIID : DIID:=COM_GetGuidOfName(psource,DIID))
	If	!pconn || !ptinf:=COM_GetTypeInfoOfGuid(psource,DIID)
	{
		MsgBox, No Event Interface Exists!
		Return
	}
	psink:=COM_CoTaskMemAlloc(40+StrLen(prefix)+1), NumPut(1,NumPut(COM_CreateIDispatch(),psink+0)), NumPut(psource,NumPut(ptinf,psink+8))
	DllCall("RtlMoveMemory", "Uint", psink+24, "Uint", COM_GUID4String(DIID,DIID), "Uint", 16)
	DllCall("RtlMoveMemory", "Uint", psink+40, "Uint", &prefix, "Uint", StrLen(prefix)+1)
	NumPut(COM_Advise(pconn,psink),NumPut(pconn,psink+16))
	Return	psink
}

COM_DisconnectObject(psink)
{
	Return	COM_Unadvise(NumGet(psink+16),NumGet(psink+20))=0 ? (0,COM_Release(NumGet(psink+16)),COM_Release(NumGet(psink+8)),COM_CoTaskMemFree(psink)) : 1
}

COM_CreateObject(CLSID, IID = "", CLSCTX = 5)
{
	DllCall("ole32\CoCreateInstance", "Uint", SubStr(CLSID,1,1)="{" ? COM_GUID4String(CLSID,CLSID) : COM_CLSID4ProgID(CLSID,CLSID), "Uint", 0, "Uint", CLSCTX, "Uint", COM_GUID4String(IID,IID ? IID : IID=0 ? "{00000000-0000-0000-C000-000000000046}" : "{00020400-0000-0000-C000-000000000046}"), "UintP", ppv)
	Return	ppv
}

COM_ActiveXObject(ProgID)
{
	DllCall("ole32\CoCreateInstance", "Uint", SubStr(ProgID,1,1)="{" ? COM_GUID4String(ProgID,ProgID) : COM_CLSID4ProgID(ProgID,ProgID), "Uint", 0, "Uint", 5, "Uint", COM_GUID4String(IID_IDispatch,"{00020400-0000-0000-C000-000000000046}"), "UintP", pdisp)
	Return	COM_GetDefaultInterface(pdisp)
}

COM_GetObject(Moniker)
{
	DllCall("ole32\CoGetObject", "Uint", COM_Unicode4Ansi(Moniker,Moniker), "Uint", 0, "Uint", COM_GUID4String(IID_IDispatch,"{00020400-0000-0000-C000-000000000046}"), "UintP", pdisp)
	Return	COM_GetDefaultInterface(pdisp)
}

COM_GetActiveObject(ProgID)
{
	DllCall("oleaut32\GetActiveObject", "Uint", SubStr(ProgID,1,1)="{" ? COM_GUID4String(ProgID,ProgID) : COM_CLSID4ProgID(ProgID,ProgID), "Uint", 0, "UintP", punk)
	DllCall(NumGet(NumGet(1*punk)+0), "Uint", punk, "Uint", COM_GUID4String(IID_IDispatch,"{00020400-0000-0000-C000-000000000046}"), "UintP", pdisp)
	DllCall(NumGet(NumGet(1*punk)+8), "Uint", punk)
	Return	COM_GetDefaultInterface(pdisp)
}

COM_CLSID4ProgID(ByRef CLSID, ProgID)
{
	VarSetCapacity(CLSID, 16)
	DllCall("ole32\CLSIDFromProgID", "Uint", COM_Unicode4Ansi(ProgID,ProgID), "Uint", &CLSID)
	Return	&CLSID
}

COM_GUID4String(ByRef CLSID, String)
{
	VarSetCapacity(CLSID, 16)
	DllCall("ole32\CLSIDFromString", "Uint", COM_Unicode4Ansi(String,String,38), "Uint", &CLSID)
	Return	&CLSID
}

COM_ProgID4CLSID(pCLSID)
{
	DllCall("ole32\ProgIDFromCLSID", "Uint", pCLSID, "UintP", pProgID)
	Return	COM_Ansi4Unicode(pProgID) . COM_CoTaskMemFree(pProgID)
}

COM_String4GUID(pGUID)
{
	VarSetCapacity(String, 38 * 2 + 1)
	DllCall("ole32\StringFromGUID2", "Uint", pGUID, "Uint", &String, "int", 39)
	Return	COM_Ansi4Unicode(&String, 38)
}

COM_IsEqualGUID(pGUID1, pGUID2)
{
	Return	DllCall("ole32\IsEqualGUID", "Uint", pGUID1, "Uint", pGUID2)
}

COM_CoCreateGuid()
{
	VarSetCapacity(GUID, 16, 0)
	DllCall("ole32\CoCreateGuid", "Uint", &GUID)
	Return	COM_String4GUID(&GUID)
}

COM_CoTaskMemAlloc(cb)
{
	Return	DllCall("ole32\CoTaskMemAlloc", "Uint", cb)
}

COM_CoTaskMemFree(pv)
{
		DllCall("ole32\CoTaskMemFree", "Uint", pv)
}

COM_CoInitialize()
{
	Return	DllCall("ole32\CoInitialize", "Uint", 0)
}

COM_CoUninitialize()
{
		DllCall("ole32\CoUninitialize")
}

COM_SysAllocString(sString)
{
	Return	DllCall("oleaut32\SysAllocString", "Uint", COM_Ansi2Unicode(sString,wString))
}

COM_SysFreeString(bstr)
{
		DllCall("oleaut32\SysFreeString", "Uint", bstr)
}

COM_SysStringLen(bstr)
{
	Return	DllCall("oleaut32\SysStringLen", "Uint", bstr)
}

COM_SafeArrayDestroy(psa)
{
	Return	DllCall("oleaut32\SafeArrayDestroy", "Uint", psa)
}

COM_VariantClear(pvarg)
{
	Return	DllCall("oleaut32\VariantClear", "Uint", pvarg)
}

COM_AccInit()
{
	COM_Init()
	If Not	DllCall("GetModuleHandle", "str", "oleacc")
	Return	DllCall("LoadLibrary", "str", "oleacc")
}

COM_AccTerm()
{
	COM_Term()
	If h:=	DllCall("GetModuleHandle", "str", "oleacc")
	Return	DllCall("FreeLibrary", "Uint", h)
}

COM_AccessibleChildren(pacc, cChildren, ByRef varChildren)
{
	VarSetCapacity(varChildren,cChildren*16,0)
	If	DllCall("oleacc\AccessibleChildren", "Uint", pacc, "Uint", 0, "Uint", cChildren+0, "Uint", &varChildren, "UintP", cChildren:=0)=0
	Return	cChildren
}

COM_AccessibleObjectFromEvent(hWnd, idObject, idChild, ByRef _idChild_="")
{
	VarSetCapacity(varChild,16,0)
	If	DllCall("oleacc\AccessibleObjectFromEvent", "Uint", hWnd, "Uint", idObject, "Uint", idChild, "UintP", pacc, "Uint", &varChild)=0
	Return	pacc, _idChild_:=NumGet(varChild,8)
}

COM_AccessibleObjectFromPoint(x, y, ByRef _idChild_="")
{
	VarSetCapacity(varChild,16,0)
	If	DllCall("oleacc\AccessibleObjectFromPoint", "int", x, "int", y, "UintP", pacc, "Uint", &varChild)=0
	Return	pacc, _idChild_:=NumGet(varChild,8)
}

COM_AccessibleObjectFromWindow(hWnd, idObject=-4, IID = "")
{
	If	DllCall("oleacc\AccessibleObjectFromWindow", "Uint", hWnd, "Uint", idObject, "Uint", COM_GUID4String(IID, IID ? IID : idObject&0xFFFFFFFF==0xFFFFFFF0 ? "{00020400-0000-0000-C000-000000000046}":"{618736E0-3C3D-11CF-810C-00AA00389B71}"), "UintP", pacc)=0
	Return	pacc
}

COM_WindowFromAccessibleObject(pacc)
{
	If	DllCall("oleacc\WindowFromAccessibleObject", "Uint", pacc, "UintP", hWnd)=0
	Return	hWnd
}

COM_GetRoleText(nRole)
{
	nSize:=	DllCall("oleacc\GetRoleTextA", "Uint", nRole, "Uint", 0, "Uint", 0)
	VarSetCapacity(sRole,nSize)
	If	DllCall("oleacc\GetRoleTextA", "Uint", nRole, "str", sRole, "Uint", nSize+1)
	Return	sRole
}

COM_GetStateText(nState)
{
	nSize:=	DllCall("oleacc\GetStateTextA", "Uint", nState, "Uint", 0, "Uint", 0)
	VarSetCapacity(sState,nSize)
	If	DllCall("oleacc\GetStateTextA", "Uint", nState, "str", sState, "Uint", nSize+1)
	Return	sState
}

COM_AtlAxWinInit(Version = "")
{
	COM_Init()
	If Not	DllCall("GetModuleHandle", "str", "atl" . Version)
		DllCall("LoadLibrary", "str", "atl" . Version)
	Return	DllCall("atl" . Version . "\AtlAxWinInit")
}

COM_AtlAxWinTerm(Version = "")
{
	COM_Term()
	If h:=	DllCall("GetModuleHandle", "str", "atl" . Version)
	Return	DllCall("FreeLibrary", "Uint", h)
}

COM_AtlAxAttachControl(pdsp, hWnd, Version = "")
{
	Return	DllCall("atl" . Version . "\AtlAxAttachControl", "Uint", punk:=COM_QueryInterface(pdsp,0), "Uint", hWnd, "Uint", 0), COM_Release(punk)
}

COM_AtlAxCreateControl(hWnd, Name, Version = "")
{
	If	DllCall("atl" . Version . "\AtlAxCreateControl", "Uint", COM_Unicode4Ansi(Name,Name), "Uint", hWnd, "Uint", 0, "Uint", 0)=0
	Return	COM_AtlAxGetControl(hWnd, Version)
}

COM_AtlAxGetControl(hWnd, Version = "")
{
	If	DllCall("atl" . Version . "\AtlAxGetControl", "Uint", hWnd, "UintP", punk)=0
		pdsp:=COM_QueryInterface(punk), COM_Release(punk)
	Return	pdsp
}

COM_AtlAxGetHost(hWnd, Version = "")
{
	If	DllCall("atl" . Version . "\AtlAxGetHost", "Uint", hWnd, "UintP", punk)=0
		pdsp:=COM_QueryInterface(punk), COM_Release(punk)
	Return	pdsp
}

COM_AtlAxCreateContainer(hWnd, l, t, w, h, Name = "", Version = "")
{
	Return	DllCall("CreateWindowEx", "Uint",0x200, "str", "AtlAxWin" . Version, "Uint", Name ? &Name : 0, "Uint", 0x54000000, "int", l, "int", t, "int", w, "int", h, "Uint", hWnd, "Uint", 0, "Uint", 0, "Uint", 0)
}

COM_AtlAxGetContainer(pdsp, bCtrl = "")
{
	DllCall(NumGet(NumGet(1*pdsp)+ 0), "Uint", pdsp, "Uint", COM_GUID4String(IID_IOleWindow,"{00000114-0000-0000-C000-000000000046}"), "UintP", pwin)
	DllCall(NumGet(NumGet(1*pwin)+12), "Uint", pwin, "UintP", hCtrl)
	DllCall(NumGet(NumGet(1*pwin)+ 8), "Uint", pwin)
	Return	bCtrl ? hCtrl : DllCall("GetParent", "Uint", hCtrl)
}

COM_Ansi4Unicode(pString, nSize = "")
{
	If (nSize = "")
	    nSize:=DllCall("kernel32\WideCharToMultiByte", "Uint", 0, "Uint", 0, "Uint", pString, "int", -1, "Uint", 0, "int",  0, "Uint", 0, "Uint", 0)
	VarSetCapacity(sString, nSize)
	DllCall("kernel32\WideCharToMultiByte", "Uint", 0, "Uint", 0, "Uint", pString, "int", -1, "str", sString, "int", nSize + 1, "Uint", 0, "Uint", 0)
	Return	sString
}

COM_Unicode4Ansi(ByRef wString, sString, nSize = "")
{
	If (nSize = "")
	    nSize:=DllCall("kernel32\MultiByteToWideChar", "Uint", 0, "Uint", 0, "Uint", &sString, "int", -1, "Uint", 0, "int", 0)
	VarSetCapacity(wString, nSize * 2 + 1)
	DllCall("kernel32\MultiByteToWideChar", "Uint", 0, "Uint", 0, "Uint", &sString, "int", -1, "Uint", &wString, "int", nSize + 1)
	Return	&wString
}

COM_Ansi2Unicode(ByRef sString, ByRef wString, nSize = "")
{
	If (nSize = "")
	    nSize:=DllCall("kernel32\MultiByteToWideChar", "Uint", 0, "Uint", 0, "Uint", &sString, "int", -1, "Uint", 0, "int", 0)
	VarSetCapacity(wString, nSize * 2 + 1)
	DllCall("kernel32\MultiByteToWideChar", "Uint", 0, "Uint", 0, "Uint", &sString, "int", -1, "Uint", &wString, "int", nSize + 1)
	Return	&wString
}

COM_Unicode2Ansi(ByRef wString, ByRef sString, nSize = "")
{
	pString := wString + 0 > 65535 ? wString : &wString
	If (nSize = "")
	    nSize:=DllCall("kernel32\WideCharToMultiByte", "Uint", 0, "Uint", 0, "Uint", pString, "int", -1, "Uint", 0, "int",  0, "Uint", 0, "Uint", 0)
	VarSetCapacity(sString, nSize)
	DllCall("kernel32\WideCharToMultiByte", "Uint", 0, "Uint", 0, "Uint", pString, "int", -1, "str", sString, "int", nSize + 1, "Uint", 0, "Uint", 0)
	Return	&sString
}

COM_ScriptControl(sCode, sLang = "", bEval = False, sFunc = "", sName = "", pdisp = 0, bGlobal = False)
{
	COM_Init()
	psc  :=	COM_CreateObject("MSScriptControl.ScriptControl")
		COM_Invoke(psc, "Language", sLang ? sLang : "VBScript")
	sName ?	COM_Invoke(psc, "AddObject", sName, "+" . pdisp, bGlobal) : ""
	sFunc ?	COM_Invoke(psc, "AddCode", sCode) : ""
	ret  :=	COM_Invoke(psc, bEval ? "Eval" : "ExecuteStatement", sFunc ? sFunc : sCode)
	COM_Release(psc)
	COM_Term()
	Return	ret
}
