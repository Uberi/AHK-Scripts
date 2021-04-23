#NoEnv

;add encryption and hashes for verification
SettingsFile = %A_ScriptDir%\Settings.ini

SMTPServer = smtp.gmail.com
Port = 465

IfExist, %SettingsFile%
{
 IniRead, Username, %SettingsFile%, Settings, Username, %A_Space%
 IniRead, Password, %SettingsFile%, Settings, Password, %A_Space%
 IniRead, Recipient, %SettingsFile%, Settings, Recipient, %A_Space%

 IniRead, SMTPServer, %SettingsFile%, Settings, Server, %SMTPServer%
 IniRead, Port, %SettingsFile%, Settings, Port, %Port%
}

Gui, Font, S12 Bold CDefault, Arial

Gui, Add, Text, x2 y2 w190 h30 +Center, Email Sender For Gmail

Gui, Font, S8 Normal CDefault, Arial

Gui, Add, Text, x2 y42 w60 h20, Username:
Gui, Add, Edit, x62 y42 w70 h20 vUsername, %Username%
Gui, Add, Text, x132 y42 w60 h20, @gmail.com

Gui, Add, Text, x2 y72 w60 h20, Password:
Gui, Add, Edit, x62 y72 w130 h20 +Password vPassword, %Password%

Gui, Add, Text, x2 y102 w60 h20, To:
Gui, Add, Edit, x62 y102 w130 h20 vRecipient, %Recipient%

Gui, Add, Text, x2 y132 w190 h20 +Center, Attachments:
Gui, Add, ListBox, x2 y152 w190 h60 vAttachmentList AltSubmit Multi
Gui, Add, Button, x2 y212 w95 h20 gAddAttachments, Add
Gui, Add, Button, x97 y212 w95 h20 gRemoveAttachments, Remove

Gui, Add, Text, x202 y2 w60 h20, Subject:
Gui, Add, Edit, x262 y2 w160 h20 vSubject, %Subject%

Gui, Add, Text, x202 y32 w220 h20 +Center, Message:
Gui, Add, Edit, x202 y52 w220 h120 vBody, %Body%

Gui, Add, Checkbox, x202 y180 w220 h20 vSaveFields, Save credentials and recipient

Gui, Font, S10 Bold CDefault, Arial

Gui, Add, Button, x202 y202 w220 h30 gSendEmail +Default, Send

If Username
 GuiControl, Focus, Subject
Gui, Show, h235 w425, Gmail Sender
Return

GuiEscape:
GuiClose:
ExitApp

AddAttachments:
AddAttachments()
Return

RemoveAttachments:
RemoveAttachments()
Return

SendEmail:
Gui, Submit
If CheckErrors()
 Return
If SaveFields
{
 IniWrite, %Username%, %SettingsFile%, Settings, Username
 IniWrite, %Password%, %SettingsFile%, Settings, Password
 IniWrite, %Recipient%, %SettingsFile%, Settings, Recipient
}
Username .= "@gmail.com"
StringTrimLeft, FileList, FileList, 1
If Not DllCall("Wininet\InternetGetConnectedState","Str","0x40","Int",0)
{
 MsgBox, 16, Error, There is currently no internet connection.
 Gui, Show
 Return
}
Else
 SendEmail(Username,Password,SMTPServer,Port,Username,Recipient,Subject,Body,FileList)
ExitApp

CheckErrors()
{
 global
 If Not RegExMatch(Username,"i)^[\.a-z0-9]{6,30}$")
 {
  MsgBox, 262160, Error, Username is invalid.
  Gui, Show
  Return, 1
 }
 If (StrLen(Password) < 8)
 {
  MsgBox, 262160, Error, Password is invalid
  Gui, Show
  Return, 1
 }
 If Not RegExMatch(Recipient,"i)^[\.a-z0-9]+@[\.a-z0-9]+\.[\.a-z0-9]+$")
 {
  MsgBox, 262160, Error, Recipient is invalid.
  Gui, Show
  Return, 1
 }
}

AddAttachments()
{
 local FileName
 local Temp1
 local Temp2
 local FileName1
 Gui, +OwnDialogs
 FileSelectFile, FileName, M59, %FileName%, Please Select File(s) To Attach
 If (ErrorLevel || FileName = "")
  Return
 IfInString, FileName, `n
 {
  StringReplace, FileName, FileName, `n, |, All
  Temp1 := SubStr(FileName,1,InStr(FileName,"|") - 1)
  Loop, Parse, FileName, |
  {
   If A_Index = 1
    Continue
   Temp2 = %Temp1%\%A_LoopField%
   FileName1 .= "|" . Temp2
  }
  StringTrimLeft, FileName1, FileName1, 1
  FileName = %FileName1%
 }
 AttachmentList = 
 Loop, Parse, FileName, |
 {
  If (StrLen(A_LoopField) > 30)
   Temp1 := "..." . SubStr(A_LoopField,-29)
  Else
   Temp1 = %A_LoopField%
  AttachmentList .= "|" . Temp1
 }
 StringTrimLeft, AttachmentList, AttachmentList, 1
 GuiControl,, AttachmentList, %AttachmentList%
 FileList .= "|" . FileName
}

RemoveAttachments()
{
 local Temp1
 local Temp2
 Gui, +OwnDialogs
 GuiControlGet, Temp1,, AttachmentList
 If Not Temp1
 {
  MsgBox, 64, Selection, No items selected for removal.
  Return
 }
 MsgBox, 36, Attachment Removal, Are you sure you want to remove the selected attachment(s)?
 IfMsgBox, Yes
 {
  StringReplace, Temp1, Temp1, |, `,, All
  StringTrimLeft, FileList, FileList, 1
  Loop, Parse, FileList, |
  {
   If A_Index Not In %Temp1%
    Temp2 .= "|" . A_LoopField
  }
  FileList = %Temp2%
  AttachmentList = 
  Loop, Parse, FileList, |
  {
   If A_Index = 1
    Continue
   If (StrLen(A_LoopField) > 30)
    Temp1 := "..." . SubStr(A_LoopField,-29)
   Else
    Temp1 = %A_LoopField%
   AttachmentList .= "|" . Temp1
  }
  If AttachmentList <> 
   GuiControl,, AttachmentList, %AttachmentList%
  Else
   GuiControl,, AttachmentList, |
 }
}

SendEmail(sUsername,sPassword,sServer,nPort,sFrom,sTo,sSubject = "",sBody = "",sAttach = "",bTLS = True,nSend = 2,nAuth = 1)
{
 DllCall("ole32\OleInitialize", "Uint", 0)
 pmsg := COM_CreateObject("CDO.Message")
 pcfg := COM_Invoke(pmsg,"Configuration")
 pfld := COM_Invoke(pcfg,"Fields")
 COM_Invoke(pfld,"Item","http://schemas.microsoft.com/cdo/configuration/sendusing",nSend)
 COM_Invoke(pfld,"Item","http://schemas.microsoft.com/cdo/configuration/smtpconnectiontimeout",60)
 COM_Invoke(pfld,"Item","http://schemas.microsoft.com/cdo/configuration/smtpserver",sServer)
 COM_Invoke(pfld,"Item","http://schemas.microsoft.com/cdo/configuration/smtpserverport",nPort)
 COM_Invoke(pfld,"Item","http://schemas.microsoft.com/cdo/configuration/smtpusessl",bTLS)
 COM_Invoke(pfld,"Item","http://schemas.microsoft.com/cdo/configuration/smtpauthenticate",nAuth)
 COM_Invoke(pfld,"Item","http://schemas.microsoft.com/cdo/configuration/sendusername",sUsername)
 COM_Invoke(pfld,"Item","http://schemas.microsoft.com/cdo/configuration/sendpassword",sPassword)
 COM_Invoke(pfld,"Update")
 COM_Invoke(pmsg,"From",sFrom)
 COM_Invoke(pmsg,"To",sTo)
 COM_Invoke(pmsg,"Subject",sSubject)
 COM_Invoke(pmsg,"TextBody",sBody)
 Loop, Parse, sAttach, |, %A_Space%%A_Tab%
 {
  IfExist, %A_LoopField%
   COM_Invoke(pmsg,"AddAttachment",A_LoopField)
 }
 COM_Invoke(pmsg,"Send")
 DllCall(NumGet(NumGet(1 * ppv) + 8), "Uint", pfld)
 DllCall(NumGet(NumGet(1 * ppv) + 8), "Uint", pcfg)
 DllCall(NumGet(NumGet(1 * ppv) + 8), "Uint", pmsg)
 DllCall("ole32\OleUninitialize")
}

COM_CreateObject(CLSID,IID = "",CLSCTX = 5)
{
 DllCall("ole32\CoCreateInstance", "Uint", SubStr(CLSID,1,1) = "{" ? COM_GUID4String(CLSID,CLSID) : COM_CLSID4ProgID(CLSID,CLSID), "Uint", 0, "Uint", CLSCTX, "Uint", COM_GUID4String(IID,IID ? IID : IID = 0 ? "{00000000-0000-0000-C000-000000000046}" : "{00020400-0000-0000-C000-000000000046}"), "UintP", ppv)
 Return, ppv
}

COM_GUID4String(ByRef CLSID, String)
{
 VarSetCapacity(CLSID, 16)
 DllCall("ole32\CLSIDFromString", "Uint", COM_SysString(String,String), "Uint", &CLSID)
 Return, &CLSID
}

COM_Invoke(pdsp,name = "",prm0 = "vT_NoNe",prm1 = "vT_NoNe",prm2 = "vT_NoNe",prm3 = "vT_NoNe",prm4 = "vT_NoNe",prm5 = "vT_NoNe",prm6 = "vT_NoNe",prm7 = "vT_NoNe",prm8 = "vT_NoNe",prm9 = "vT_NoNe")
{
 If name = 
  Return, DllCall(NumGet(NumGet(1 * ppv) + 8), "Uint", pdsp)
 If name Contains .
 {
  SubStr(name,1,1) != "." ? name .= "." : name := SubStr(name,2) . ".",DllCall(NumGet(NumGet(1*ppv)+4), "Uint", pdsp)
  Loop, Parse, name, .
  {
   If A_Index = 1
   {
    name := A_LoopField
    Continue
   }
   Else If name not contains [,(
    prmn := ""
   Else If InStr("])",SubStr(name,0))
    Loop, Parse, name, [(,'")]
     If A_Index = 1
      name := A_LoopField
     Else prmn := A_LoopField
   Else
   {
    name .= "." . A_LoopField
    Continue
   }
   If A_LoopField != 
    pdsp := COM_Invoke(pdsp,name,prmn != "" ? prmn : "vT_NoNe") + DllCall(NumGet(NumGet(1 * ppv) + 8), "Uint", pdsp) * 0,name := A_LoopField
   Else Return, prmn != "" ? COM_Invoke(pdsp,name,prmn,prm0,prm1,prm2,prm3,prm4,prm5,prm6,prm7,prm8) : COM_Invoke(pdsp,name,prm0,prm1,prm2,prm3,prm4,prm5,prm6,prm7,prm8,prm9),DllCall(NumGet(NumGet(1 * ppv) + 8), "Uint", pdsp)
  }
 }
 sParams := "0123456789"
 Loop, Parse, sParams
  If (prm%A_LoopField% == "vT_NoNe")
  {
   sParams := SubStr(sParams,1,A_Index - 1)
   Break
  }
 VarSetCapacity(varg,16 * nParams := StrLen(sParams),0), VarSetCapacity(DispParams,16,0), VarSetCapacity(varResult,32,0), VarSetCapacity(ExcepInfo,32,0)
 Loop, Parse, sParams
 ;If prm%A_LoopField%+0=="" || InStr(prm%A_LoopField%,".") || prm%A_LoopField%>=0x80000000 || prm%A_LoopField%<-0x80000000
  If prm%A_LoopField% Is Not Integer
   NumPut(COM_SysString(prm%A_LoopField%,prm%A_LoopField%),NumPut(8,varg,(nParams - A_Index) * 16),4)
  Else NumPut(SubStr(prm%A_LoopField%,1,1) = "+" ? 9 : prm%A_LoopField% == "-0" ? (prm%A_LoopField% := 0x80020004) * 0 + 10 : 3,NumPut(prm%A_LoopField%,varg,(nParams-A_Index) * 16 + 8),-12,"Ushort")
 If nParams
  NumPut(nParams,NumPut(&varg,DispParams),4)
 If (nvk := SubStr(name,0) = "=" ? 12 : 3) = 12
  name := SubStr(name,1,-1),NumPut(1,NumPut(NumPut(-3,varResult,4)-4,DispParams,4),4)
 global COM_HR, COM_LR := ""
 If (COM_HR := DllCall(NumGet(NumGet(1 * pdsp) + 20),"Uint",pdsp,"Uint",&varResult + 16,"UintP",COM_SysString(wname,name),"Uint",1,"Uint",1024,"intP",dispID,"Uint")) = 0 && (COM_HR := DllCall(NumGet(NumGet(1 * pdsp) + 24),"Uint",pdsp,"int",dispID,"Uint",&varResult + 16,"Uint",1024,"Ushort",nvk,"Uint",&DispParams,"Uint",&varResult,"Uint",&ExcepInfo,"Uint",0,"Uint")) != 0 && nParams && nvk != 12 && (COM_LR := DllCall(NumGet(NumGet(1 * pdsp) + 24),"Uint",pdsp,"int",dispID,"Uint",&varResult + 16,"Uint",1024,"Ushort",12,"Uint",NumPut(1,NumPut(NumPut(-3,varResult,4)-4,DispParams,4),4)-16,"Uint",0,"Uint",0,"Uint",0,"Uint")) = 0
 COM_HR := 0
 global COM_VT := NumGet(varResult,0,"Ushort")
 Return, COM_HR = 0 ? COM_VT > 1 ? COM_VT = 9 || COM_VT = 13 ? NumGet(varResult,8) : COM_VT = 8 || COM_VT < 0x1000 && COM_VariantChangeType(&varResult,&varResult) = 0 ? COM_Ansi4Unicode(NumGet(varResult,8)) . COM_VariantClear(&varResult) : NumGet(varResult,8) : "" : COM_Error(COM_HR,COM_LR,&ExcepInfo,name)
}

COM_CLSID4ProgID(ByRef CLSID, ProgID)
{
 VarSetCapacity(CLSID, 16)
 DllCall("ole32\CLSIDFromProgID", "Uint", COM_SysString(ProgID,ProgID), "Uint", &CLSID)
 Return, &CLSID
}

COM_Error(hr = "", lr = "", pei = "", name = "")
{
 Static bDebug := 1
 If Not pei
 {
  bDebug := hr
  global COM_HR, COM_LR
  Return, COM_HR && COM_LR ? COM_LR << 32 | COM_HR : COM_HR
 }
 Else If !bDebug
  Return
 hr ? (VarSetCapacity(sError,1023),VarSetCapacity(nError,10),DllCall("kernel32\FormatMessageA","Uint",0x1000,"Uint",0,"Uint",hr <> 0x80020009 ? hr : (bExcep := 1) * (hr := NumGet(pei + 28)) ? hr : hr := NumGet(pei + 0,0,"Ushort") + 0x80040200,"Uint",0,"str",sError,"Uint",1024,"Uint",0),DllCall("user32\wsprintfA","str",nError,"str","0x%08X","Uint",hr,"Cdecl")) : sError := "The COM Object may not be a valid Dispatch Object!`n`tFirst ensure that COM Library has been initialized through COM_Init().`n", lr ? (VarSetCapacity(sError2,1023),VarSetCapacity(nError2,10),DllCall("kernel32\FormatMessageA","Uint",0x1000,"Uint",0,"Uint",lr,"Uint",0,"str",sError2,"Uint",1024,"Uint",0),DllCall("user32\wsprintfA","str",nError2,"str","0x%08X","Uint",lr,"Cdecl")) : ""
 MsgBox, 260, COM Error Notification, % "Function Name:`t""" . name . """`nERROR:`t" . sError . "`t(" . nError . ")" . (bExcep ? SubStr(NumGet(pei+24) ? DllCall(NumGet(pei+24),"Uint",pei) : "",1,0) . "`nPROG:`t" . COM_Ansi4Unicode(NumGet(pei+4)) . COM_SysFreeString(NumGet(pei+4)) . "`nDESC:`t" . COM_Ansi4Unicode(NumGet(pei+8)) . COM_SysFreeString(NumGet(pei+8)) . "`nHELP:`t" . COM_Ansi4Unicode(NumGet(pei+12)) . COM_SysFreeString(NumGet(pei+12)) . "," . NumGet(pei+16) : "") . (lr ? "`n`nERROR2:`t" . sError2 . "`t(" . nError2 . ")" : "") . "`n`nWill Continue?"
 IfMsgBox, No, Exit
}

COM_SysFreeString(bstr)
{
 DllCall("oleaut32\SysFreeString", "Uint", bstr)
}

COM_VariantClear(pvar)
{
 DllCall("oleaut32\VariantClear", "Uint", pvar)
}

COM_SysString(ByRef wString, sString)
{
 VarSetCapacity(wString,3+2*nLen:=1+StrLen(sString))
 Return, NumPut(DllCall("kernel32\MultiByteToWideChar","Uint",0,"Uint",0,"Uint",&sString,"int",nLen,"Uint",&wString + 4,"int",nLen,"Uint") * 2 - 2,wString)
}

COM_VariantChangeType(pvarDst, pvarSrc, vt = 8)
{
 Return, DllCall("oleaut32\VariantChangeTypeEx", "Uint", pvarDst, "Uint", pvarSrc, "Uint", 1024, "Ushort", 0, "Ushort", vt)
}

COM_Ansi4Unicode(pString, nSize = "")
{
 If (nSize = "")
  nSize:=DllCall("kernel32\WideCharToMultiByte", "Uint", 0, "Uint", 0, "Uint", pString, "int", -1, "Uint", 0, "int",  0, "Uint", 0, "Uint", 0)
 VarSetCapacity(sString, nSize)
 DllCall("kernel32\WideCharToMultiByte", "Uint", 0, "Uint", 0, "Uint", pString, "int", -1, "str", sString, "int", nSize + 1, "Uint", 0, "Uint", 0)
 Return, sString
}