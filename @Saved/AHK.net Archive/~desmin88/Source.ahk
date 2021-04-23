#Include ini.ahk
Version = 2.7
FileInstall, Lock.jpg, Lock.jpg, 1
FileInstall, ini.ahk, ini.ahk, 1
PinDir = %A_AppDataCommon%\Book.dll
SetBatchLines -1

Gui +Toolwindow
Gui, Add, Edit, x6 y10 w460 h300 vMOTD, Loading
Gui, Add, Button, x6 y317 w70 h20 gMainGui, Continue
Gui, Add, Button, x116 y317 w100 h20 gToWebsite, Go To Website
Gui, Add, Button, x386 y317 w80 h20 gExit, Exit
Gui, Add, Button, x236 y317 w100 h20 gGetUpdates, Get Updates
Gui, Show, x321 y156 h345 w479, Message Of The Day
gosub getMotd
return

MainGui:
Gui,Destroy
Menu, DelM, add, Rename, Rename
Menu, DelM, Add
Menu, DelM, add, Delete Password, Delete  ; Creates a new menu item.
Menu, DelM, add, Reset Account, DeleteA
IfExist,%PinDir%
   { 
   gosub Login
   return
   }
Else
   gosub Start
return
Start:
Settimer,checkstr,1000
Gui, Add, Text, x6 y10 w180 h40 , Welcome to Password Guard`nFirst off you need to create a account.
Gui, Add, Edit, x6 y60 w180 h20 vUser1, Username
Gui, Add, Edit, x6 y90 w180 h20 +Password* vPass1, Password
Gui, Add, Button, x6 y160 w180 h20 gSave, Create
Gui, Add, Button, x206 y60 w20 h20 g1, ?
Gui, Add, Button, x206 y90 w20 h20 g2, ?
Gui, Add, Text, x189 y62 w16 h18 , >>
Gui, Add, Text, x190 y91 w16 h18 , >>
Gui, Add, Progress, x6 y120 w180 h20 vSTR r1-100, 
Gui, Add, Button, x206 y120 w20 h20 g3, ?
Gui, Add, Text, x189 y119 w16 h18 , >>
Gui, Add, Text, x6 y141 w183 h15 vShowSTR,
Gui, Show, x331 y299 h196 w249, Create Account
return

getMotd:
UrlDownloadToFile, http://www.autohotkey.net/~desmin88/MOTD.dat, %TEMP%\Motd.dat
Loop 5 {
Guicontrol,,MOTD, Loading.
sleep 250
Guicontrol,,MOTD, Loading..
sleep 200
Guicontrol,,MOTD, Loading...
sleep 300
Guicontrol,,MOTD, Loading....
sleep 225
}
Fileread,MOTD2,%TEMP%\Motd.dat
Guicontrol,,MOTD, %MOTD2%
return

GetUpdates:
UrlDownloadToFile, http://www.autohotkey.net/~desmin88/Server.dat, %TEMP%\Server.dat
sleep 100
Filereadline,VersionC,%TEMP%\Server.dat,1
Filereadline,URL,%TEMP%\Server.dat,2
If (Version == VersionC)
   {
    Guicontrol,,MOTD, No new versions available`nYou have the current version.
    return
   }
Else,
   {
    Guicontrol,,MOTD, New version available, %VersionC%. Download link below.`n%URL%
    return
   }
return
ToWebsite:
run http://76.188.17.251:55555/
return

Exit:
Exitapp
return

1:
Msgbox,64,Password Guard, The Username that will be used when logging in.
return

2:
Msgbox,64,Password Guard, The Password that will be used when logging in.
return

3:
Msgbox,64,Password Guard, This progress bar measures the strength of your password using an algorithim.`nReccomended to have half the bar filled in.`nIf not it should at least be 1/3 filled.
return

checkstr:
Gui,submit,nohide
If (User1 = "" && Pass1 = "" )
    {
    GuiControl,,ShowSTR, 
    GuiControl,,STR, 0
    return
    }
If (User1 = "")
    {
    GuiControl,,ShowSTR, 
    GuiControl,,STR, 0
    return
    }
If (Pass1 = "")
    {
    GuiControl,,ShowSTR, 
    GuiControl,,STR, 0
    return
    }
If (User1 = "Username" && Pass1 = "Password" )
       {
    GuiControl,,ShowSTR, 
    GuiControl,,STR, 0
    return
    }
Else 
   {
    strength := passwordStrength(Pass1,User1)
    GuiControl,,STR,%Strength%
    If strength = Too short
       {
       GuiControl,,ShowSTR,%Strength%
       return
       }
    GuiControl,,ShowSTR,%Strength%`%
    return
}
return



GuiClose:
Exitapp

Save:
Gui, Submit, NoHide

If (Strength < 33)
   {
    Msgbox,64,Password Guard, Password Too Weak, Consider adding some numbers, or more characters.
    return
    }
If Strength = Too short
   {
    Msgbox,64,Password Guard, Password Too Short, Consider adding some numbers, or more characters.
    return
    }
Settimer,checkstr,off
Write =
(
[Passwords:]
Username=%User1%
Password=%Pass1%
)
NewWrite := RC4txt2hex(Write,Pass1)
Fileappend,%NewWrite%,%PinDir%
Msgbox,64,,Password Guard,Account made,Your Account was made.`nClick ok to continue
sleep 100
gosub login
return

Login:
Gui, Destroy
User1 = 
Pass1 =
Gui, Color, FFFFFF
Gui, Add, Text, x6 y10 w230 h30 , Welcome to Password Guard!`nEnter your username and password to continue
Gui, Add, Picture, x6 y50 w230 h340 , Lock.jpg
Gui, Add, Edit, x16 y200 w200 h20 vUser, Username
Gui, Add, Edit, x16 y230 w200 h20 +Password* vPass -WantReturn, Password
Gui, Add, Button, x16 y260 w60 h20 gUnlock Default, Login
Gui, Show, x327 y209 h396 w241, Login
return

Unlock:
Gui,Submit,NoHide
;CheckPW-----------------------------
Fileread,ReadData,%PinDir%
Dec := RC4hex2txt(ReadData,Pass)
If Dec =
   {
    Msgbox,64,Password Guard, Wrong password entered.
    return
   }
Content := ini_getSection(Dec, "Passwords:") 
UserTCP := ini_getValue(Content, "Passwords:", "Username")
If (UserTCP == User)
  { 
   Msgbox,64,Password Guard,Your account was accepted.`nClick ok to gain access to your passwords.
   TDec = %Pass%
   gosub PassAccess
  }
Else 
  {
   Msgbox,64,Password Guard,The entered username was incorrect.`nPlease re-enter.
   return
  }
return


PassAccess:
Gui, Destroy
Gui, Add, ListBox, x6 y10 w70 h190 vPasslist gRetrieve, 
Gui, Add, GroupBox, x86 y10 w270 h190 , Info
Gui, Add, Edit, x166 y30 w180 h20 vUser, Username
Gui, Add, Text, x96 y30 w60 h20 , Username
Gui, Add, Text, x96 y60 w60 h20 , Password
Gui, Add, Edit, x166 y60 w180 h20 vPass, Password
Gui, Add, Text, x96 y90 w60 h20 , Email
Gui, Add, Edit, x166 y90 w180 h20 vEmail, Email
Gui, Add, Text, x96 y120 w60 h20 , Misc
Gui, Add, Text, x96 y150 w60 h20 , Misc
Gui, Add, Edit, x166 y120 w180 h20 vMisc1, Misc1
Gui, Add, Edit, x166 y150 w180 h20 vMisc2, Misc2
Gui, Add, Button, x93 y175 w60 h20 gSaveEntry2, Save
Gui, Add, DropDownList, x376 y30 w90 h20 vSelectM R5, Yahoo|G-Mail|Hotmail|AIM Mail
Gui, Add, Button, x376 y60 w90 h20 gLoginM, Logon
Gui, Add, Edit, x376 y130 w90 h20 vNewEntry, New Entry
Gui, Add, Button, x376 y160 w90 h20 gSaveEntry, Add
Gui, Add, GroupBox, x366 y10 w110 h190 , Controls
Gui, Show, x404 y485 h210 w489, Passwords for %A_UserName% - V%Version%
Gui,Submit,NoHide
Fileread,ReadData,%PinDir%
Dec := RC4hex2txt(ReadData,TDec)
i = 0 ;Index used for array element number
   Loop,Parse,Dec,`n,`r
   {
      StringLeft, L, A_LoopField, 1
      ;Possible Section name, so check right side
      If L = [
      {
         StringRight, R, A_LoopField, 1
         ;If its a right bracket Section found
         If R = ]
         {
            i++
            ;Econt = Element Contents
            ECont = %A_LoopField%
            StringTrimLeft, ECont, ECont, 1
            StringTrimRight, ECont, ECont, 1
            ECont = %ECont%|
            GuiControl,, Passlist, %PassList%%ECont%
         }
      }
   }
return

SaveEntry:
Gui, Submit, NoHide
If NewEntry = Passwords:
   {
   Msgbox,64,Password Guard,Password cannot be created with the name "Passwords".
   return
   }
Else
{
f =
(
[%Newentry%]
User=%User%
Pass=%Pass%
Email=%Email%
Misc1=%Misc1%
Misc2=%Misc2%
)
Fileread,ReadData,%PinDir%
Dec := RC4hex2txt(ReadData,TDec)
TEnc = %Dec%`n%f%
;msgbox,%TEnc%
Enc := RC4txt2hex(TEnc,TDec)
Filedelete,%PinDir%
Fileappend,%Enc%,%PinDir%  
sleep 100
Gosub Auto
}
return


SaveEntry2:
Gui, Submit, NoHide
Fileread,ReadData,%PinDir%
Dec := RC4hex2txt(ReadData,TDec)
ini_replaceValue(Dec, Passlist, "User", User, 1)
ini_replaceValue(Dec, Passlist, "Pass", Pass, 1)
ini_replaceValue(Dec, Passlist, "Email", Email, 1)
ini_replaceValue(Dec, Passlist, "Misc1", Misc1, 1)
ini_replaceValue(Dec, Passlist, "Misc2", Misc2, 1)
Enc := RC4txt2hex(Dec,TDec)
Filedelete, %PinDir%
Fileappend,%Enc%,%PinDir%  
sleep 100
return
return

Retrieve:
Gui,Submit,Nohide
If A_GuiEvent = DoubleClick
   {
    If PassList = Passwords:
        return
    Else
    {
    Menu, DelM, Show
    return
    }
   }
Else
{
If PassList = Passwords:
    return
Else
{
ToUser =
ToPass =
ToEmail =
ToMisc1 =
ToMisc2 =
Fileread,ReadData,%PinDir%
Dec := RC4hex2txt(ReadData,TDec)
Content := ini_getSection(Dec, Passlist) 
ToUser := ini_getValue(Content, Passlist, "User",1)
ToPass := ini_getValue(Content, Passlist, "Pass",1)
ToEmail := ini_getValue(Content, Passlist, "Email",1)
ToMisc1 := ini_getValue(Content, Passlist, "Misc1",1)
ToMisc2 := ini_getValue(Content, Passlist, "Misc2",1)
GuiControl,, User, %ToUser%
GuiControl,, Pass, %ToPass%
GuiControl,, Email, %ToEmail%
GuiControl,, Misc1, %ToMisc1%
GuiControl,, Misc2, %ToMisc2%
}
}
return
 


return

DeleteA:
Gui, Submit, Nohide
Msgbox,4,,Password Guard, This will reset your account and passwords. Click yes to continue
IfMsgBox Yes
    {
     FileDelete, %PinDir%
     Msgbox,64,Password Guard,Deleted All Passwords`nClick ok to close.
     exitapp
     return
    }
Else
    return
return






Delete:
Gui, Submit, NoHide
Msgbox, 4,Password Guard, Do you really want to delete the password, %Passlist%?
IfMsgBox Yes
    {
     Fileread,ReadData,%PinDir%
     Dec := RC4hex2txt(ReadData,TDec)
     ini_replaceSection(Dec, Passlist, "")
     Filedelete, %PinDir%
     Enc := RC4txt2hex(Dec,TDec)
     Fileappend,%Enc%,%PinDir%
     Msgbox,64,,%Passlist%, is now deleted.
     gosub Auto
     }
else
    gosub Auto
return

Auto:
Gosub PassAccess
return


LoginM:
Gui, Submit,NoHide
If PassList = Passwords:
    return
If SelectM = Yahoo
    {
    MailURL = https://login.yahoo.com/config/mail?.intl=us
    gosub Mail
    return
    }
If SelectM = G-Mail
    {
    MailURL = www.gmail.com/?M=A
    gosub Mail
    return
    }
If SelectM = Hotmail
    {
    MailURL = http:\\www.mail.live.com
    gosub Mail
    return
    }
If SelectM = AIM Mail
    {
    MailURL = http:\\mail.aim.com
    gosub Mail
    return
    }

Mail:
Gui, Submit, NoHide
run %MailURL%
sleep 5000
SendInput, %User%
sleep 500
SendInput,{Tab}
sleep 500
SendInput,%Pass%
sleep 500
SendInput {Enter}
return



Rename:
Gui,submit,nohide
InputBox, Newname, Enter New Title, Enter the new password title.
if ErrorLevel
  {
   Msgbox,64,Password Guard, No new title entered.
   return
  }
Fileread,ReadData,%PinDir%
Dec := RC4hex2txt(ReadData,TDec)
Stringreplace,Dec,Dec,[%passlist%],[%Newname%]
Enc := RC4txt2hex(Dec,TDec)
Filedelete, %PinDir%
Fileappend,%Enc%,%PinDir%  
gosub PassAccess
return

RC4txt2hex(Data,Pass) {
   Format := A_FormatInteger
   SetFormat Integer, Hex
   b := 0, j := 0
   VarSetCapacity(Result,StrLen(Data)*2)
   Loop 256 {
      a := A_Index - 1
      Key%a% := Asc(SubStr(Pass, Mod(a,StrLen(Pass))+1, 1))
      sBox%a% := a
   }
   Loop 256 {
      a := A_Index - 1
      b := b + sBox%a% + Key%a%  & 255
      T := sBox%a%
      sBox%a% := sBox%b%
      sBox%b% := T
   }
   Loop Parse, Data
   {
      i := A_Index & 255
      j := sBox%i% + j  & 255
      k := sBox%i% + sBox%j%  & 255
      Result .= SubStr(Asc(A_LoopField)^sBox%k%, -1, 2)
   }
   StringReplace Result, Result, x, 0, All
   SetFormat Integer, %Format%
   Return Result
}

RC4hex2txt(Data,Pass) {
   b := 0, j := 0, x := "0x"
   VarSetCapacity(Result,StrLen(Data)//2)
   Loop 256 {
      a := A_Index - 1
      Key%a% := Asc(SubStr(Pass, Mod(a,StrLen(Pass))+1, 1))
      sBox%a% := a
   }
   Loop 256 {
      a := A_Index - 1
      b := b + sBox%a% + Key%a%  & 255
      T := sBox%a%
      sBox%a% := sBox%b%
      sBox%b% := T
   }
   Loop % StrLen(Data)//2 {
      i := A_Index  & 255
      j := sBox%i% + j  & 255
      k := sBox%i% + sBox%j%  & 255
      Result .= Chr((x . SubStr(Data,2*A_Index-1,2)) ^ sBox%k%)
   }
   Return Result
}


; Password strength meter
; This jQuery plugin is written by firas kassem [2007.04.05]
; Firas Kassem  phiras.wordpress.com || phiras at gmail {dot} com
; for more information : http://phiras.wordpress.com/2007/04/08/password-strength-meter-a-jquery-plugin/

passwordStrength(password,username)
{
    static shortPass= "Too short", badPass = "Bad"
        , goodPass = "Good", strongPass = "Strong"

    score = 0

    ;password < 4
    if strLen(password) < 4
        return shortPass

    ;password == username
    if (password = username)
        return badPass

    ;password length
    score += strLen(password) * 4
    score += strLen(passwordStrength_checkRepetition(1,password)) - strLen(password)
    score += strLen(passwordStrength_checkRepetition(2,password)) - strLen(password)
    score += strLen(passwordStrength_checkRepetition(3,password)) - strLen(password)
    score += strLen(passwordStrength_checkRepetition(4,password)) - strLen(password)

    ;password has 3 numbers
    if RegExMatch(password, "^\D*+\d\D*+\d\D*+\d")
    {
        score += 5
        hasNumber := true
    }
    else
        hasNumber := RegExMatch(password, "\d")

    ;password has 2 symbols (list of symbols [!@#$%^&*?_~])
    ;(is a comma counted as a symbol, or is it just the separator??)
    if RegExMatch(password, "^[^!@#$%^&*?_~]*+[!@#$%^&*?_~][^!@#$%^&*?_~]*+[!@#$%^&*?_~]")
    {
        hasSymbol := true
        score += 5
    }
    else
        hasSymbol := RegExMatch(password, "[!@#$%^&*?_~]")
        
    hasUpperChar := RegExMatch(password, "[A-Z]")
    hasLowerChar := RegExMatch(password, "[a-z]")
    hasChar := hasLowerChar || hasUpperChar

    ;password has Upper and Lower chars
    if (hasUpperChar && hasLowerChar)
        score += 10

    ;password has number and chars
    if (hasNumber && hasChar)
        score += 15

    ;password has number and symbol
    if (hasNumber && hasSymbol)
        score += 15
        
    ;password has char and symbol
    if (hasChar || hasSymbol)
        score += 15

    ;password is just numbers or chars
    if RegExMatch(password, "^\w+$")
        score -= 10

    ;verifing 0 < score < 100
    ;(not necessary because handled below)

    if (score < 34 )
        return score
    else if (score < 68 )
        return score
    else if (score > 68 )
        return score
}

; Msgbox,64, % passwordStrength_checkRepetition(1,"aaaaaaabcbc")    ;= "abcbc"
; Msgbox,64, % passwordStrength_checkRepetition(2,"aaaaaaabcbc")    ;= "aabc"
; Msgbox,64, % passwordStrength_checkRepetition(2,"aaaaaaabcdbcd")  ;= "aabcd"

passwordStrength_checkRepetition(pLen,str)
{
	res := ""

    i := 0
    while (i < strLen(str))
    {
        repeated := true
        
        j := 0
        while (j < pLen && (j + i + pLen) < strLen(str))
        {
            ;+1 converts from 0-based to 1-based offset
			repeated := repeated && (subStr(str, j+i+1, 1) == subStr(str, j+i+pLen+1, 1))
			
            ;increment loop
			j++
		}

		if (j < pLen)
			repeated := false
			
		if (repeated) {
			i += pLen - 1
			repeated := false
		} else {
            ;+1 converts from 0-based to 1-based offset
			res .= subStr(str, i+1, 1)
		}

        ;increment loop
        i++
	}

	return res
}




