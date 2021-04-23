#NoEnv

CheckInterval = 20000
MaxEmails = 3
SavePath = %A_ScriptDir%\Settings.ini

IniRead, GmailUsername, %SavePath%, Settings, Username, %A_Space%
IniRead, GmailPassword, %SavePath%, Settings, Password, %A_Space%
IniRead, SaveCreds, %SavePath%, Settings, SaveCredentials, 1

Gui, Add, Text, x2 y0 w60 h20, Username:
Gui, Add, Edit, x62 y0 w120 h20 vGmailUsername, %GmailUsername%
Gui, Add, Text, x2 y20 w60 h20, Password:
Gui, Add, Edit, x62 y20 w120 h20 Password vGmailPassword, %GmailPassword%
Gui, Add, CheckBox, x2 y40 w100 h20 Checked%SaveCreds% vSaveCreds, Save Credentials
Gui, Add, Button, x102 y40 w80 h20 Default, Go
Gui, Show, h65 w190, Gmail Checker
Return

GuiClose:
ExitApp

ButtonGo:
Gui, Submit
StringReplace, GmailPassword, GmailPassword, %A_Space%, `%20, All
If SaveCreds
{
 IniWrite, %GmailUsername%, %SavePath%, Settings, Username
 IniWrite, %GmailPassword%, %SavePath%, Settings, Password
 IniWrite, %SaveCreds%, %SavePath%, Settings, SaveCredentials
}
Else
 FileDelete, %SavePath%
SetTimer, CheckGmail, %CheckInterval%

CheckGmail:
MessageLog := URLDownloadToVar("https://" . GmailUsername . ":" . GmailPassword . "@mail.google.com/mail/feed/atom")
EmailLog := CheckEmails(MessageLog)
If Not EmailLog
 Return
NewEmailList := CheckNewEmails(EmailLog,MaxEmails)
If Not NewEmailList
 Return
ShowEmails(NewEmailList,EmailLog)
NewEmailList = 
Return

CheckEmails(MessageLog)
{
 StringGetPos, Temp1, MessageLog, <fullcount>
 StringGetPos, Temp2, MessageLog, </fullcount>,, %Temp1%
 Temp2 -= Temp1 + 11
 StringMid, MessageCount, MessageLog, Temp1 + 12, Temp2 ;Number Of Messages
 EmailLog = %MessageCount%
 If MessageCount <> 0
 {
  Loop
  {
   StringGetPos, Temp1, MessageLog, <entry>, L%A_Index%
   If ErrorLevel
    Break
   StringGetPos, Temp2, MessageLog, </entry>,, %Temp1%
   Temp2 -= Temp1
   StringMid, CurrentMessage, MessageLog, Temp1, Temp2 ;Current Message
   StringGetPos, Temp1, CurrentMessage, <title>
   StringGetPos, Temp2, CurrentMessage, </title>
   Temp1 += 8
   Temp2 -= Temp1 - 1
   StringMid, Subject, CurrentMessage, Temp1, Temp2 ;Subject
   StringGetPos, Temp1, CurrentMessage, <summary>
   StringGetPos, Temp2, CurrentMessage, </summary>
   Temp1 += 10
   Temp2 -= Temp1 - 1
   StringMid, Message, CurrentMessage, Temp1, Temp2 ;Message
   StringGetPos, Temp1, CurrentMessage, <issued>
   Temp1 += 9
   StringMid, MessageTime, CurrentMessage, Temp1, 19
   StringReplace, MessageTime, MessageTime, -,, All
   StringReplace, MessageTime, MessageTime, :,, All
   StringReplace, MessageTime, MessageTime, T,, All ;Time Sent
   StringGetPos, Temp1, CurrentMessage, <name>
   StringGetPos, Temp2, CurrentMessage, </name>
   Temp1 += 7
   Temp2 -= Temp1 - 1
   StringMid, AuthorName, CurrentMessage, Temp1, Temp2 ;Name Of Author
   StringGetPos, Temp1, CurrentMessage, <id>
   StringGetPos, Temp2, CurrentMessage, </id>
   Temp1 += 5
   Temp2 -= Temp1 - 1
   StringMid, MessageID, CurrentMessage, Temp1, Temp2 ;Email ID
   StringGetPos, Temp1, CurrentMessage, <email>
   StringGetPos, Temp2, CurrentMessage, </email>
   Temp1 += 8
   Temp2 -= Temp1 - 1
   StringMid, Author, CurrentMessage, Temp1, Temp2 ;Email Of Author
   EmailLog = %EmailLog%`n%MessageID%"%Author%"%AuthorName%"%MessageTime%"%Subject%"%Message%
  }
 }
 Return, EmailLog
}

CheckNewEmails(EmailLog,MaxEmails)
{
 static PrevEmailLog
 Loop, Parse, EmailLog, `n
 {
  If A_Index <> 1
  {
   Loop, Parse, A_LoopField, "
   {
    Temp1 = %A_LoopField%
    Break
   }
   IfNotInString, PrevEmailLog, %Temp1%
    NewEmailList = %NewEmailList%"%Temp1%
  }
 }
 PrevEmailLog = %EmailLog%
 StringTrimLeft, NewEmailList, NewEmailList, 1
 StringReplace, NewEmailList, NewEmailList, ", ", UseErrorLevel
 If ErrorLevel >= %MaxEmails%
 {
  MsgBox, 262180, Emails, There are more than %MaxEmails% email(s). Should notices be shown for all of them?
  IfMsgBox, No
  {
   PrevEmailLog = %EmailLog%
   Return
  }
 }
 Return, NewEmailList
}

ShowEmails(NewEmailList,EmailLog)
{
 Loop, Parse, NewEmailList, "
 {
  StringGetPos, TagPos, EmailLog, %A_LoopField%
  StringGetPos, EndPos, EmailLog, `n,, TagPos
  If ErrorLevel
   StringLen, EndPos, EmailLog
  TagPos += (StrLen(A_LoopField) + 2)
  EndPos -= TagPos
  StringMid, CurrentMessage, EmailLog, TagPos, EndPos
  Loop, Parse, CurrentMessage, "
  {
   If A_Index = 1
    Author = %A_LoopField%
   Else If A_Index = 2
    Author = %Author% (%A_LoopField%)
   Else If A_Index = 4
    Subject = %A_LoopField%
   Else If A_Index = 5
    Message = %A_LoopField%
  }
  ShowPopup(Author,Subject,Message)
 }
}

ShowPopup(Author,Subject,Message)
{
 DetectHiddenWindows, On
 SysGet, Workspace, MonitorWorkArea
 Gui, Destroy
 Gui, -Caption +ToolWindow +LastFound +AlwaysOnTop +Border
 Gui, Font, S16 CDefault, Verdana
 Gui, Add, Text, x62 y0 w260 h30 , New email(s) received
 Gui, Font, S12 CDefault, Verdana
 Gui, Add, Text, x2 y40 w60 h20 , Author:
 Gui, Add, Text, x92 y40 w270 h20 , %Author%
 Gui, Add, Text, x2 y70 w70 h20 , Subject:
 Gui, Add, Text, x92 y70 w270 h20 , %Subject%
 Gui, Add, Text, x2 y100 w80 h20 , Message:
 Gui, Add, Text, x92 y100 w270 h20 , %Message%
 Gui, Add, Text, BackgroundTrans x2 y0 w370 h126 gFade
 Gui, Show, Hide w370 h120, New Email
 GUI_ID := WinExist()
 WinGetPos, GUIX, GUIY, GUIWidth, GUIHeight, ahk_id %GUI_ID%
 NewX := WorkSpaceRight-GUIWidth-5
 NewY := WorkspaceBottom-GUIHeight-5
 Gui, Show, Hide x%NewX% y%NewY%
 DllCall("AnimateWindow","UInt",GUI_ID,"Int",500,"UInt","0x00040008")
 Sleep, 3000
 Gosub, Fade
 Return

 Fade:
 DllCall("AnimateWindow","UInt",GUI_ID,"Int",1000,"UInt","0x90000")
 Gui, Destroy
 Return
}

UrlDownloadToVar(URL, Proxy="", ProxyBypass="")
{
 AutoTrim, Off
 hModule := DllCall("LoadLibrary", "str", "wininet.dll") 
 AccessType = 0
 ;INTERNET_OPEN_TYPE_PRECONFIG                    0   // use registry configuration
 ;INTERNET_OPEN_TYPE_DIRECT                       1   // direct to net
 ;INTERNET_OPEN_TYPE_PROXY                        3   // via named proxy
 ;INTERNET_OPEN_TYPE_PRECONFIG_WITH_NO_AUTOPROXY  4   // prevent using java/script/INS
 io_hInternet := DllCall("wininet\InternetOpenA", "str", "", "uint", AccessType, "str", Proxy, "str", ProxyBypass, "uint", 0)
 iou := DllCall("wininet\InternetOpenUrlA", "uint", io_hInternet, "str", url, "str", "", "uint", 0, "uint", 0x80000000, "uint", 0)
 If (ErrorLevel != 0 or iou = 0)
 {
  DllCall("FreeLibrary", "uint", hModule)
  Return 0
 }
 VarSetCapacity(buffer, 512, 0)
 VarSetCapacity(NumberOfBytesRead, 4, 0)
 Loop
 {
  irf := DllCall("wininet\InternetReadFile", "uint", iou, "uint", &buffer, "uint", 512, "uint", &NumberOfBytesRead)
  NOBR = 0
  Loop 4
   NOBR += *(&NumberOfBytesRead + A_Index-1) << 8*(A_Index-1)
  IfEqual, NOBR, 0, break
  DllCall("lstrcpy", "str", buffer, "uint", &buffer)
  res = %res%%buffer%
 }
 StringTrimRight, res, res, 2
 DllCall("wininet\InternetCloseHandle",  "uint", iou)
 DllCall("wininet\InternetCloseHandle",  "uint", io_hInternet)
 DllCall("FreeLibrary", "uint", hModule)
 AutoTrim, on
 Return, res
}