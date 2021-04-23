;Program Name: MyIpChanger
;Version: 1.1                      
;Author: DataLife
;Thanks to Snowy for his example batch file to change the IP address. Snowys Ip Changer can be found here http://www.autohotkey.com/forum/viewtopic.php?t=76790 

;Thanks to BZ_FRW for his additions to support the Chinese language 

;Thanks to Veovis for "Include a bitmap in your uncompiled script!!!" found here http://www.autohotkey.com/forum/topic10957.html 
;and aCkRiTe modified version of Veovis' writefile function to include a bitmap in an uncompiled script found here http://www.autohotkey.com/forum/topic12220.html 

;Thanks to AVGuy for his example for retreiving the lan adapter names. AVGuys AutoIp - Easy IP script can be found here http://www.autohotkey.com/forum/viewtopic.php?t=40578 

#NoTrayIcon
#SingleInstance, Ignore
gosub, JoinPicture                                                                 ; creates ip.ico 
menu,tray,icon,ip.ico                                                              ;displays the icon in the title bar
if A_OSVersion = WIN_XP 
 {
  ip = ip
  timeout =                                                                        ;used for the batch file MyIpAddress.bat
 }
else
 {
  ip = ipv4
  timeout := "TIMEOUT 5"                                                           ;used for the batch file MyIpAddress.bat
 }
Custom:
FileDelete, NetChange.tmp
FileDelete, NetChange1.tmp
FileDelete, NetChange.bat
RunWait, %Comspec% /c netsh interface show interface >>NetChange.tmp, , Hide       ;get list of Lan adapters on PC
Iniread,Lan,MyIpChanger.ini,config,Lanchoice
LanNumber = 0
Loop, Read, NetChange.tmp
 { ; added by BZ_FRW, For Chinese_PRC OS, START
  OLD_STRING = A_LoopReadLine
  if A_Language = 0804                                                             ;Chinese language
   {
    SavedAddressesFontSize = 8
    ClearAllButtonxPos1 := 10,SubmitButtonxPos2:=112,3ButtonsWidth := 100
    StringReplace, Delimiter, %OLD_STRING%, ????, ??, UseErrorLevel
    If ErrorLevel = 0
     Continue
    Loop, Parse, Delimiter, ??
     {
      If A_LoopField not contains ??
       {
        Counter++
        LAN_Name = %A_LoopField%
        If Lan = Error
         {
          if Lan_Name = ????????
          LanNumber = %Counter%
         }
        else
         {
          if Lan = %Lan_Name%
           LanNumber = %Counter%
         }
        If Lan_Name !=  
         FileAppend, %LAN_Name%|, NetChange1.tmp
        LAN_Cnt++
       } ;If A_LoopField not contains ?? - closing brace
     } ;Loop, Parse, Delimiter, ?? - closing brace
   } ;if A_Language = 0804 - closing brace
  else
   { 
    SavedAddressesFontSize = 11                                                    ;font size for the 10 most recently used Ip addresses
    ClearAllButtonxPos1 := 30,SubmitButtonxPos2:=122,3ButtonsWidth := 80           ;buttons x and y positions and width
    StringReplace, Delimiter, A_LoopReadLine, Dedicated, ?, UseErrorLevel
    If ErrorLevel = 0
     Continue
    Loop, Parse, Delimiter, ?
     {
      If A_LoopField not contains able
       {
        Counter++
        StringReplace, LAN_Name, A_LoopField, %A_Space%%A_Space%, , All
        If Lan = Error                                                             ;Lan would be error if not able to read Lanchoice from ini file
         {
          if Lan_Name = Local Area Connection
           LanNumber = %Counter%                                                   ;Used to have the last selected Network Adapter on startup in dropdown list
         }
        else
         {
          if Lan = %Lan_Name% 
           LanNumber = %Counter%                                                   ;Used to have the last selected Network Adapter on startup in dropdown list
         }
        FileAppend, %LAN_Name%|, NetChange1.tmp
        LAN_Cnt++                                                                  ;Used to display number of rows for Select Network Adapter dropdown
        Lan%Lan_Cnt% = %LAN_Name%                                                  ;Used to display the IP address of the currertly selected Lan Adapter.
       } ;If A_LoopField not contains able - closing brace
     } ;Loop, Parse, Delimiter, ? - closing brace
   } ;else - closing brace 
 } ;Loop, Read, NetChange.tmp - closing brace
FileRead, Lan, NetChange1.tmp
StringTrimRight, Lan, Lan, 1
FileDelete, NetChange.tmp
FileDelete, NetChange1.tmp
IfWinExist, MyIpChanger
 Gui 1: destroy
                                                                                   ;create GUI
Gui 1: add, GroupBox, x10 y1 w300 h40
Gui 1: Add, DropDownList, w155 x20 y14 gSubmitLanChange vLanChoice Choose%LanNumber% R%LAN_Cnt%, %Lan%
Gui 1: font, s8 c000000 , Arial 
Gui 1: add, text, x+10 y+-17, Select Network Adapter
Gui 1: Font                                                                        ;added to reset font so numbers in edit boxes fit properly 
IniRead,DHCPorSTATIC,MyIpChanger.ini,config,DHCPorSTATIC,2                         ;determine if DHCP or Static is checked
if DHCPorSTATIC = 1
   DHCP = Checked
else
   Static = Checked
Gui 1: add, GroupBox, x10 y42 w300 h40                                             ;create Groupbox with DHCP, Static, and AutoFill                     
Gui 1: Add, radio,gDHCPorSTATIC %Dhcp%  vDHCPorSTATIC x35  y60,Dhcp                ;radio button DHCP                  
Gui 1: Add, radio,gDHCPorSTATIC %Static%    x127 y60,Static                        ;radio button Static
                                                                                   ;AutoFill is added last due to being an after thought and putting it here messes up
                                                                                   ;my static control numbering

Gui 1: Font, s12, 
Gui 1: Add, Text, x12  y+30  w100 h30 , Ip address                                 ;add ipaddress octet edit boxes
Gui 1: Add, Edit, x122 yp-5  w35  h25 Limit3 gTab vIPoct1 Number , 
Gui 1: Add, Text, x162 yp+5  w10  h30 , .
Gui 1: Add, Edit, x172 yp-5  w35  h25 Limit3 gTab vIPoct2 Number , 
Gui 1: Add, Text, x212 yp+5  w10  h30 , .
Gui 1: Add, Edit, x222 yp-5  w35  h25 Limit3 gTab vIPoct3 Number , 
Gui 1: Add, Text, x262 yp+5  w10  h30 , .
Gui 1: Add, Edit, x272 yp-5  w35  h25 Limit3 gTab vIPoct4 Number , 

Gui 1: Add, Text, x12  yp+45  w100 h30 , Subnet mask                               ;add subnet octet edit boxes
Gui 1: Add, Edit, x122 yp-5  w35  h25 Limit3 gTab vSMoct1 Number ,
Gui 1: Add, Text, x162 yp+5  w10  h30 , .
Gui 1: Add, Edit, x172 yp-5  w35  h25 Limit3 gTab vSMoct2 Number , 
Gui 1: Add, Text, x212 yp+5  w10  h30 , .
Gui 1: Add, Edit, x222 yp-5  w35  h25 Limit3 gTab vSMoct3 Number ,
Gui 1: Add, Text, x262 yp+5  w10  h30 , .
Gui 1: Add, Edit, x272 yp-5  w35  h25 Limit3 gTab vSMoct4 Number ,

Gui 1: Add, Text, x12  yp+45 w100 h30 , Gateway                                    ;add gateway address octet edit boxes
Gui 1: Add, Edit, x122 yp-5 w35  h25 Limit3 gTab vGWoct1 Number ,
Gui 1: Add, Text, x162 yp+5 w10  h30 , .
Gui 1: Add, Edit, x172 yp-5 w35  h25 Limit3 gTab vGWoct2 Number , 
Gui 1: Add, Text, x212 yp+5 w10  h30 , .
Gui 1: Add, Edit, x222 yp-5 w35  h25 Limit3 gTab vGWoct3 Number , 
Gui 1: Add, Text, x262 yp+5 w10  h30 , .
Gui 1: Add, Edit, x272 yp-5 w35  h25 Limit3 gTab vGWoct4 Number ,
Gui 1: Font, s11, 


Gui 1: Add, Button,x%ClearAllButtonxPos1%  yp+47 w%3ButtonsWidth% gClearAll,Clear All
Gui 1: Add, Button,x%SubmitButtonxPos2% yp w%3ButtonsWidth% gSubmit  ,Submit
Gui 1: Add, Button,x214 yp w%3ButtonsWidth% gExit  ,Exit

IfExist,save.txt                                                                   ;add any saved addresses to bottom of GUI
 {
  Gui 1: Add, Text,x87 yp+45,Use one of the following
  Gui 1: Add, text,x28 yp+25,IP Address
  Gui 1: Add, text,x122 yp,Subnet Mask
  Gui 1: Add, text,x222 yp,Gateway

  counter = 0
  breakLoop = 0
  Loop ;loop for each address set         
   {
    Loop ; for each octet
     {
      FileReadLine,Value,save.txt,%a_index%
      if Errorlevel = 1
       {
        BreakLoop = 1
        break
       }
        counter++
        Octet%Counter% := Value
        if counter = 4
         {
          NextOctSet++
          counter = 0
          if NextOctSet = 1
           IPAddress := ( octet1 "." octet2 "." octet3 "." octet4 )
          if NextOctSet = 2
           SMAddress := ( octet1 "." octet2 "." octet3 "." octet4 )
          if NextOctSet = 3
           {
            NextOctSet = 0
            If CountRadioButtons = 10
             goto NoMoreRadioButtons
            Gui 1: Font, s%SavedAddressesFontSize%, ;xx either 8 for Chinese or 11 for english
            Gui 1: Add, Radio,x7  y+5 -Group gRadioButton,%IPAddress%
            Gui 1: add, text,x122 yp-0 -Group , %SMAddress%
            GWAddress := ( octet1 "." octet2 "." octet3 "." octet4 )
            IfInString,GWAddress,x
             GWAddress =
            Gui 1: add, text,x222 yp-0 -Group , %GWAddress%
            CountRadioButtons++
           }
         } ;if counter = 4 - ending brace
     } ;Loop ;for each octet - ending brace
    NoMoreRadioButtons:
    CountRadioButtons = 0  
    BreakLoop = 1
    If BreakLoop = 1
     break  
   } ;loop for each address - ending brace
   Gui 1: Font, s11, Arial
  Gui 1: Add, Button,x62 w200 gClearSavedAddresses,Remove saved addresses
} ;IfExist,save.txt closing bracket
IniRead,CheckedValue,MyIpChanger.ini,config,AutoFill,1                             ;add AutoFill checkbox
if CheckedValue = 1
 Checked = Checked
else
 Checked =
Gui 1: Font          ;xx
Gui 1: add, checkbox,x220 y60 vAutoFill gAutoFill %Checked%,AutoFill
IniRead,GUIxPos,MyIpChanger.ini,config,GUIxPos,100
IniRead,GUIyPos,MyIpChanger.ini,config,GUIyPos,100
Gui 1: Show, x%GUIxPos% y%GUIyPos% w323, MyIpChanger
Gui 1: color, 0x8080ff
if DHCPorSTATIC = 1                                                                ;if DHCP is checked then disable each octet box
 {
  loop 12
   Control,disable,,edit%A_Index%, MyIpChanger
 }
else
 ControlFocus,edit1, MyIpChanger
Return
AutoFill:                                                                          ;When entering an IP address and you enter TAB on octet 3
Gui 1: Submit, nohide
IniWrite,%AutoFill%,MyIpChanger.ini,config,AutoFill
return
DHCPorSTATIC:
Gui 1: submit, NoHide
if DHCPorSTATIC = 1
 {
  loop 12
   Control,disable,,edit%A_Index%, MyIpChanger
 }
if DHCPorSTATIC = 2
 {
  Loop 12
   Control, enable,,edit%a_index%, MyIpChanger
  ControlFocus,edit1, MyIpChanger
 }
return
SubmitLanChange:                                                                   ;Select Lan Adapter drop downdown
Gui 1: submit, NoHide
IniWrite,%Lanchoice%,MyIpChanger.ini,config,Lanchoice
ControlFocus,edit1, MyIpChanger
Return
ClearSavedAddresses:                                                               ;removed saved addresses button
FileDelete,save.txt
goto Custom
RadioButton:              ;Retrieve IP, Subnet and GW addresses from controls and fill addresses into Edit boxes when a Saved Address Radio button is selected.
ControlClick,
SetControlDelay -1
ControlClick,button4,MyIpChanger                                                   ;insure Static radio button is selected when a Saved IP address is selected
Gui 1: Submit , NoHide
MouseGetPos,,,,Control                                                             ;get name of control just clicked
ControlGetText,IPAddress,%Control%, MyIpChanger                                    ;Get text of control (IPaddress)
StringTrimLeft,Num,Control,6                                       
Numm = 0
LoopNum := ( Num - 4 ) 
 Loop %LoopNum%
  Numm++                 
Num := (Num + 6 + Numm) 
Control := ( "Static" Num ) 
ControlGetText,SMAddress,%Control%, MyIpChanger                                    ;Get text of control (Subnet)
Num++
Control := ( "Static" Num )
ControlGetText,GWAddress,%Control%, MyIpChanger                                    ;Get text of control (Gateway)
StringSplit, Octet, IPAddress, .
ControlSetText,edit1,%octet1%, MyIpChanger                                         ;Fill IP address in to octet edit boxes
ControlSetText,edit2,%octet2%, MyIpChanger
ControlSetText,edit3,%octet3%, MyIpChanger
ControlSetText,edit4,%octet4%, MyIpChanger
StringSplit, Octet, SMAddress, .
ControlSetText,edit5,%octet1%, MyIpChanger                                         ;Fill subnet address in to octet edit boxes
ControlSetText,edit6,%octet2%, MyIpChanger
ControlSetText,edit7,%octet3%, MyIpChanger
ControlSetText,edit8,%octet4%, MyIpChanger
If GWAddress = 
 {
  ControlSetText,edit9,, MyIpChanger                                               ;Clear gateway address in octet edit boxes
  ControlSetText,edit10,, MyIpChanger
  ControlSetText,edit11,, MyIpChanger
  ControlSetText,edit12,, MyIpChanger
 }
else
 {
  StringSplit, Octet, GWAddress, .
  ControlSetText,edit9,%octet1%, MyIpChanger                                       ;Fill gateway address in to octet edit boxes
  ControlSetText,edit10,%octet2%, MyIpChanger
  ControlSetText,edit11,%octet3%, MyIpChanger
  ControlSetText,edit12,%octet4%, MyIpChanger
 }
GWAddress =
return
#IfWinActive,MyIpChanger
.::
GuiControlGet, WhichControl, 1:Focus                                               ;get the name of the control that has focus
GuiControlGet,IsFieldBlank,1:,%WhichControl%                                       ;get text of the control that has focus              
if IsFieldBlank =                                                                  ;if edit box is blank then return
 return
else
 send {tab}                                                                        ;if edit box is not blank then send TAB
return
WatchForEdit5Control:                                                              ;autofill subnet and gateway when 
GuiControlGet, WhichControl, 1:Focus                                               ;after number has been entered into the 4th octet of the ipaddress and tab has been
if WhichControl = Edit5                                                            ;press or if Edit5 (Subnet octet 1 edit box) is clicked then autofill subnet and GW
 {
  GuiControlGet,IPoctet1,1:,Edit1
  if IPoctet1 between 1 and 127
   GuiControl,1:, Edit5,255
  if IPoctet1 between 128 and 191
   {
    GuiControl,1:, Edit5,255
    GuiControl,1:, Edit6,255
   }
   
  if (IPoctet1>191)
   {
    GuiControl,1:, Edit5,255
    GuiControl,1:, Edit6,255
    GuiControl,1:, Edit7,255
   }
  GuiControlGet,Octet1,1:,Edit1
  GuiControlGet,Octet2,1:,Edit2
  GuiControlGet,Octet3,1:,Edit3
  GuiControl,1:, Edit9,%Octet1%
  GuiControl,1:, Edit10,%Octet2% 
  GuiControl,1:, Edit11,%Octet3% 
  Loop 12
   {
    GuiControlGet,String,,Edit%a_index%                                            ;put focus on first blank octet edit box
    if String =
     {
      ControlFocus,Edit%a_index%,MyIpChanger
      break
     }
   }
  SetTimer,WatchForEdit5Control,Off
 }
return
Tab:                                                                               ;check to see if octet numbers are within valid ipaddress ranges
GuiControlGet, WhichControl, 1:Focus
IniRead,CheckedValue,MyIpChanger.ini,config,AutoFill,1
if ( CheckedValue = 1 and WhichControl = "Edit4" )                                  ;when TAB is pressed check to see if the current octet is IP address octet 4
 SetTimer,WatchForEdit5Control,100                                                  ;WatchForEdit5Control label AutoFills subnet and gateway addresses
GuiControlGet,String,,%WhichControl%
IfNotInString,String,Clear
 {
  if ( WhichControl = "Edit1" or WhichControl = "Edit9" )                            ;check to see if octet numbers are within valid ipaddress ranges
   {
    if String > 223
     {
      MsgBox, 4112,Error,%String% is not a valid entry.  Please specify a value between 1 and 223.
      send {BS}{BS}{BS}
      return
     }
   } 
  else
   {
    if String > 255
     {
      MsgBox,4112,Error,%String% is not a valid entry.  Please specify a value between 0 and 255.
      send {BS}{BS}{BS}
      return
     }
   }
  Len := StrLen(String)
  if Len > 2                                                                         ;auto advance to next octet of this octet has 3 digits
   {
    send {tab}
    sleep 250
   }
 }
return
ClearAll:                                                                          ;clear all edit boxes
Loop 12
 GuiControl, , Edit%a_index%
ControlFocus,edit1, MyIpChanger
return
Submit:                                                                            ;change ip, subnet and gateway addresses on selected adapter
SetTimer,WatchForEdit5Control,Off
AddressFound = 0
Gui 1: Submit , NoHide
WinGetPos,GUIxPos,GUIyPos,,MyIpChanger
IniWrite,%GUIxPos%,MyIpChanger.ini,config,GUIxPos
IniWrite,%GUIyPos%,MyIpChanger.ini,config,GUIyPos
IniWrite,%DHCPorSTATIC%,MyIpChanger.ini,config,DHCPorSTATIC

if LanChoice =
 {
  MsgBox,4112,Error,Please select a Network Adapter
  return
 }

If DHCPorSTATIC = 1
 {
  goto Dhcp
  return
 }

Loop 4
 {
  if IPoct%a_index% =
   {
    MsgBox, 4112,Error, IP address octet %a_index% can not be blank
    ControlFocus,edit%a_index%, MyIpChanger
    return
   }
 }
Loop 4
 {
  if SMoct%a_index% =
   {
    MsgBox, 4112,Error, Subnet address octet %a_index% can not be blank
    EditControl := ( A_index + 4)
    ControlFocus,edit%EditControl%, MyIpChanger
    return
   }
 }
loop 4
 {
  if GWoct%a_index% <>
   {
    Loop 4
     {
      if GWoct%a_index% =
       {
        MsgBox, 4112,Error, Gateway address octet %a_index% can not be blank
        EditControl := ( A_index + 8)
        ControlFocus,edit%EditControl%, MyIpChanger
        return
       }
     }
   }
 }

Loop 4
  IPoct%A_Index% := ( IPoct%A_Index% + 0 )
Loop 4
 SMoct%A_Index% := ( SMoct%A_Index% + 0 )
If GWoct1 <>                                                                       ;only strip leading zeros if gateway octet 1 is not blank
 {
  Loop 4
    GWoct%A_Index% := ( GWoct%A_Index% + 0 )
 }

IPAddress := (IPoct1 "." IPoct2 "." IPoct3 "." IPoct4 )
SMAddress := (SMoct1 "." SMoct2 "." SMoct3 "." SMoct4 )
if GWoct1 <>
 GWAddress := (GWoct1 "." GWoct2 "." GWoct3 "." GWoct4 )
else
 GWAddress =
LookForDuplicateAddress := ( IPAddress SMAddress GWAddress )
counter = 0
breakLoop = 0
AddressFound = 0
Loop ;loop for each address set
 {
  Loop ; for each octet
   {
    FileReadLine,Value,save.txt,%a_index%
    if Errorlevel = 1
     {
      BreakLoop = 1
      break
     }
      counter++
      Octet%Counter% := Value
      if counter = 4
       {
        NextOctSet++
        counter = 0
        if NextOctSet = 1
         IPAddress1 := ( octet1 "." octet2 "." octet3 "." octet4 )
        if NextOctSet = 2
         SMAddress1 := ( octet1 "." octet2 "." octet3 "." octet4 )
        if NextOctSet = 3
         {
          NextOctSet = 0
          if octet1 <> x
           {
            GWAddress1 := ( octet1 "." octet2 "." octet3 "." octet4 )
            AddressSet := ( IPAddress1 SMAddress1 GWAddress1 )
            if AddressSet = %LookForDuplicateAddress%
             AddressFound = 1
           }
          else
           {
            GwAddress1 =
            AddressSet := ( IPAddress1 SMAddress1 GWAddress1 )
            if AddressSet = %LookForDuplicateAddress%
             AddressFound = 1
            }
          }
        } ;if counter = 4 - ending brace
   } ;Loop ;for each octet - ending brace
   If BreakLoop = 1
    break  
 } ;loop for each address - ending brace
if AddressFound = 0                                                                ;if address is not in list then read the list, delete the list, re-create list
 {
  loop
   {
    filereadline,var%a_index%,save.txt,%a_index%
    if errorlevel = 1
     {
      Lines := ( a_index - 1 )
      break
     }
   }
  Filedelete,save.txt
  FileAppend,%IPoct1%`n,save.txt
  FileAppend,%IPoct2%`n,save.txt
  FileAppend,%IPoct3%`n,save.txt
  FileAppend,%IPoct4%`n,save.txt
  
  FileAppend,%SMoct1%`n,save.txt
  FileAppend,%SMoct2%`n,save.txt
  FileAppend,%SMoct3%`n,save.txt
  FileAppend,%SMoct4%`n,save.txt
  
  if GWoct1 =
   {
    loop 4
    GWoct%a_index% = x
   }
  FileAppend,%GWoct1%`n,save.txt
  FileAppend,%GWoct2%`n,save.txt
  FileAppend,%GWoct3%`n,save.txt
  FileAppend,%GWoct4%`n,save.txt

  if Lines > 120                                                                   ;limit Saved IP Address list to 10 address (120 octets total)
   Lines = 120

  loop %Lines%                                                                     ;limit Saved IP Address list to 10 address (120 octets total)
   {
    var := ( "var" a_index )                                                       ;octet numbers are already stored in var1, var2, etc...
    var = % %var%
    FileAppend,%var%`n,save.txt
    var%A_Index% =
   }
  } 
Gui 1: submit, NoHide                                                              ;get Lan adapter choice
FileDelete %A_Temp%\MyIpChanger.bat
if GWAddress =
 {
FileAppend,
   (
@ECHO Setting IP Address to          :%IPAddress%
@ECHO Setting Subnet Mask Address to :%SMAddress%
@ECHO OFF
%TIMEOUT%
netsh interface %ip% set address name="%LanChoice%" source=static addr=%IPAddress% mask=%SMAddress% gateway=
@ECHO Current Settings for "%LanChoice%"
netsh interface %ip% show address name="%LanChoice%"
pause 
    ), %A_Temp%\MyIpChanger.bat
 }
else
 {
FileAppend,
   (
@ECHO Setting IP Address to          :%IPAddress%
@ECHO Setting Subnet Mask Address to :%SMAddress%
@ECHO Setting Gateway Address to     :%GWAddress%
@ECHO OFF
netsh interface %ip% set address name="%LanChoice%" source=static addr=%IPAddress% mask=%SMAddress% gateway=%GWAddress% 1 
@ECHO Current Settings for "%LanChoice%"
netsh interface %ip% show address name="%LanChoice%"
pause
    ), %A_Temp%\MyIpChanger.bat 
 }
Runwait, %A_Temp%\MyIpChanger.bat
goto Custom
Dhcp:
Gui 1: submit, NoHide
if LanChoice =
 {
  MsgBox,4112,Error,Please select a Network Adapter
  return
 }
FileDelete %A_Temp%\MyIpChanger.bat

FileAppend,
   (
@ECHO Setting IP Address to DHCP
@ECHO OFF
netsh interface %ip% set address "%LanChoice%" dhcp
netsh interface %ip% show address name="%LanChoice%"
pause
   ), %A_Temp%\MyIpChanger.bat

Run, %A_Temp%\MyIpChanger.bat
return
GuiClose:
Exit:
winget,State,MinMax,MyIpChanger                                                    ;don't write GuiPos to ini file if Gui is minimized
if State <> -1
 {
  WinGetPos,GUIxPos,GUIyPos,,MyIpChanger
  IniWrite,%GUIxPos%,MyIpChanger.ini,config,GUIxPos
  IniWrite,%GUIyPos%,MyIpChanger.ini,config,GUIyPos
 }
ExitApp
JoinPicture:                                                                       ;creates ip.ico
ifnotexist, ip.ico
 {
  icondata1 =
(join
000001000100404000000100200028420000160000002800000040000000800000000100200000000000004200000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000001000000020000000300000
00500000007000000090000000B0000000C0000000E0000000F000000100000001100000012000000120000001200000011
000000100000000F0000000E0000000C0000000A00000009000000070000000500000003000000020000000100000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000100000002000000040000
0006000000080000000A0000000D00000010000000120000001500000017000000190000001B0000001C0000001D0000001
E0000001D0000001C0000001B00000019000000170000001500000013000000100000000D0000000B000000080000000600
000004000000020000000100000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000010000000200000004000
00006000000090000000D0000001000000014000000190000001C0000002000000024000000280000002A0000002D000000
2E0000002F000000300000002F0000002E0000002D0000002A0000002800000024000000210000001D00000019000000150
00000110000000D000000090000000700000004000000020000000100000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000020000000400
000006000000090000000D00000012000000170000001D00000022000000280000002E00000033000000380000003C00000
04100000045000000470000004800000049000000480000004700000045000000420000003D00000039000000330000002E
00000028000000220000001D00000017000000120000000E0000000A0000000600000004000000020000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000030
0000005000000090000000D00000012000000180000001F000000260000002D000000350000003C000000440000004C0000
005100000054000000550000005600000057000000580000005900000058000000570000005500000053000000510000004
F0000004C000000460000003E000000350000002E000000260000001F00000018000000120000000D000000090000000500
000003000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001
00000004000000070000000B00000010000000160000001E000000260000002F00000038000000430000004D00000055000
000580000005C00000066000000760000008A0000009D000000AC000000B7000000BC000000BC000000B6000000AB000000
9A00000086000000710000005F000000540000004F0000004C000000440000003900000030000000260000001E000000160
00000100000000B000000070000000400000002000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000200000004000000080000000D000000130000001B000000230000002D0000003800000044000000510000005900
00005D0000006D0000008D000000B5000000D9000000F2000000FF000000FF000000FF000000FF000000FF000000FF00000
0FF000000FF000000FF000000FF000000F1000000D7000000B10000008500000063000000520000004E0000004700000039
0000002E000000240000001B000000140000000D00000008000000050000000200000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000200000005000000090000000F000000160000001F000000290000003400000041000000500000005A0
00000600000007A000000AE000000E2000000FF000000FF000000FF000000FF000000FE000000FD000000FC000000FC0000
00FC000000FC000000FC000000FC000000FD000000FE000000FF000000FF000000FF000000FF000000DF000000A80000006
F000000530000004E00000044000000350000002A0000001F000000160000000F0000000900000005000000020000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000002000000050000000A0000001000000018000000220000002D0000003A0000004900000059
0000005F00000077000000B5000000F0000000FF000000FF000000FF000000FC000000FD010000FE030100FE040200FE040
200FE040200FF030100FF030100FF030100FF040200FE040200FE030200FE020100FE000000FD000000FC000000FF000000
FF000000FF000000EF000000AE00000069000000500000004B0000003C0000002E0000002200000018000000100000000A0
000000500000002000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000002000000050000000A000000110000001900000024000000310000003F0000005
00000005D00000068000000A3000000EC000000FF000000FF000000FD000000FD000000FE030100FE030200FE000000FF00
0000FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000FE04020
0FE020100FE000000FD000000FD000000FF000000FF000000E900000097000000580000004E000000410000003100000024
0000001A000000110000000A000000050000000200000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000010000000500000009000000100000001A0000002500000033000000
4200000055000000600000007A000000CC000000FF000000FF000000FD000000FE000000FF040200FE000000FF000000FF0
00000FF110900FF3F2000FF6C3800FF904A00FFAA5800FFB75F00FFBA6000FFB35C00FFA05300FF824300FF592E00FF2915
00FF020100FF000000FF000000FF030100FE020100FF000000FE000000FC000000FF000000FF000000C60000006A0000004
F0000004500000033000000250000001A000000110000000A00000005000000020000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000100000004000000080000000F000000190000002500000
0330000004300000057000000610000008C000000E9000000FF000000FC000000FE000000FF020100FE000000FF000000FF
080400FF522B00FFA75700FFE37600FFFF8500FFFF8900FFFF8900FFFF8800FFFF8800FFFF8700FFFF8800FFFF8900FFFF8
A00FFFF8800FFF68000FFCC6A00FF844500FF2D1700FF000000FF000000FF020100FE000000FF000000FE000000FC000000
FF000000E50000007C0000004E0000004600000034000000250000001900000010000000090000000400000001000000000
00000000000000000000000000000000000000000000000000000000000000000000003000000070000000E000000170000
00230000003200000043000000570000006200000099000000F6000000FF000000FC000000FF000000FF020100FE000000F
F090400FF6F3A00FFD67000FFFF8800FFFF8800FFFE8300FFF78000FFF57F00FFF57F00FFF57F00FFF67F00FFF67F00FFF6
7F00FFF57F00FFF57F00FFF67F00FFFA8100FFFF8500FFFF8900FFF88100FFAF5B00FF3C1F00FF000000FF000000FE02010
0FF000000FF000000FC000000FF000000F4000000890000004E000000460000003300000024000000180000000E00000008
00000003000000010000000000000000000000000000000000000000000000000000000000000002000000060000000C000
00014000000200000002F0000004100000057000000620000009B000000FA000000FF000000FD000000FF010000FE000000
FF000000FF4C2700FFD26E00FFFF8900FFFF8400FFF67F00FFF57F00FFF88000FFF98100FFF88000FFF88000FFF98100FFF
98100FFF98100FFF98100FFF98100FFF88000FFF88000FFF88000FFF78000FFF57E00FFF98000FFFF8800FFFB8400FF9C52
00FF170B00FF000000FF020100FE000000FF000000FD000000FF000000F80000008C0000004D00000045000000300000002
1000000150000000C0000000600000002000000000000000000000000000000000000000000000000000000010000000400
00000A000000120000001D0000002B0000003D000000530000006200000093000000F9000000FE000000FD000000FF01000
0FE000000FF060200FF944D00FFFF8700FFFF8400FFF47E00FFF78000FFF98100FFF88000FFF98100FFF98100FFF98100FF
F98100FFF98100FFF98100FFF98100FFF98100FFF98100FFF98100FFF98100FFF98100FFF88000FFF98100FFF88100FFF67
F00FFF77F00FFFF8900FFE27700FF492500FF000000FF020000FE000000FF000000FD000000FE000000F800000082000000
4C000000410000002C0000001E000000120000000A000000040000000100000000000000000000000000000000000000000
0000003000000070000000E0000001900000027000000380000004D0000006000000084000000F2000000FF000000FD0000
00FF020000FE000000FF170B00FFC36600FFFF8A00FFF57F00FFF77F00FFF98100FFF88000FFF98100FFF98100FFF98100F
FF98100FFF98100FFF98100FFF98100FFF98100FFF98100FFF98100FFF98100FFF98100FFF98100FFF98100FFF98100FFF9
8100FFF88000FFF98100FFF98100FFF47E00FFFC8300FFFF8600FF733B00FF000000FF020100FE000000FF000000FD00000
0FF000000EF0000006F0000004A0000003A00000027000000190000000F0000000700000003000000000000000000000000
0000000000000001000000050000000B000000140000002100000031000000450000005C00000070000000DE000000FF000
000FC000000FF010000FE000000FF1B0D00FFD56F00FFFF8700FFF37D00FFF88000FFF98100FFF88000FFF98100FFF98100
FFF98100FFF98100FFF98100FFF98100FFF98100FFF98100FFF98100FFF98100FFF98100FFF98100FFF98100FFF98100FFF
98100FFF98100FFF98100FFF98100FFF98100FFF88000FFF98100FFF67F00FFF57E00FFFF8900FF814200FF000000FF0201
00FE000000FF000000FC000000FF000000D800000059000000470000003300000022000000150000000B000000050000000
100000000000000000000000100000003000000080000000F0000001B0000002A0000003D0000005600000063000000BB00
0000FF000000FC000000FF010000FE000000FF130900FFD36E00FFFF8600FFF37D00FFF98100FFF88100FFF88000FFF8800
0FFF88000FFF88000FFF98100FFF98100FFF98100FFF98100FFF98000FFF98100FFF88000FFF88000FFF88000FFF88000FF
F98000FFF98100FFF98100FFF98100FFF98100FFF98100FFF98100FFF98100FFF88000FFF98100FFF88000FFF37D00FFFF8
900FF7C3F00FF000000FF030100FE000000FF000000FB000000FF000000AE0000004B000000410000002B0000001C000000
100000000800000003000000000000000000000002000000050000000B0000001500000023000000350000004B0000005E0
000008B000000FB000000FD000000FE000000FE020100FF020100FFBD6200FFFF8800FFF37D00FFF98100FFF88000FFF981
00FFF88000FFF88000FFF88000FFF88000FFF98100FFF98100FFF98100FFF98100FFF98000FFF98100FFF88000FFF88000F
FF88000FFF88000FFF98000FFF98100FFF98100FFF98100FFF98100FFF98100FFF98100FFF98100FFF98100FFF88000FFF9
8100FFF88000FFF47E00FFFF8900FF572C00FF000000FF020000FE000000FE000000FD000000FA000000760000004600000
03700000023000000150000000B00000005000000010000000000000003000000070000000F0000001B0000002B0000003F
0000005800000069000000D7000000FF000000FC000000FF020100FE000000FF874500FFFF8B00FFF27D00FFF98100FFF88
000FFF98101FFF87A00FFF9B860FFFBE1A9FFFBDDA4FFFAC87DFFF87E00FFF98100FFF98100FFF98100FFF98101FFF87900
FFF9A23BFFFBE1A9FFFADB9EFFFAD596FFF9870CFFF87E00FFF98100FFF98100FFF98100FFF98100FFF98100FFF98100FFF
98100FFF98100FFF88000FFF98100FFF77F00FFF88100FFF27F00FF251300FF000000FE010000FF000000FC000000FF0000
00CE00000050000000420000002C0000001C00000010000000080000000300000000000000050000000A000000140000002
1000000340000004B0000005D00000098000000FF000000FD000000FE010000FE000000FF391D00FFFE8600FFF67F00FFF8
8000FFF88000FFF98100FFF98202FFF77800FFFAC476FFFCF6CEFFFCF2C8FFFBD899FFF77D00FFF98100FFF98100FFF9810
0FFF98202FFF77700FFFAAA48FFFCF7CFFFFBEFC1FFFBE8B8FFF9890FFFF77D00FFF98100FFF98100FFF98100FFF98100FF
F98100FFF98100FFF98100FFF98100FFF98100FFF88000FFF98100FFF57E00FFFF8700FFBE6200FF010000FF020000FE000
000FE000000FD000000FF00000084000000440000003600000023000000140000000A000000040000000100000007000000
0D00000019000000280000003D0000005600000068000000D7000000FF000000FC000000FF010000FF040100FFC76600FFF
E8600FFF67F00FFF98100FFF88000FFF98100FFF98101FFF87900FFF9C171FFFBF1C5FFFBEDBFFFFAD492FFF87E00FFF981
00FFF98100FFF98100FFF98101FFF87800FFF9A845FFFBF2C6FFFAEAB8FFFAE4AFFFF9880EFFF87E00FFF98100FFF98100F
FF98100FFF98100FFF98100FFF98100FFF98100FFF98100FFF98100FFF98100FFF88000FFF98100FFF57E00FFFF8900FF5D
3000FF000000FF030100FF000000FC000000FF000000CE0000004E0000004000000029000000190000000E0000000600000
00200000009000000100000001E0000002F000000460000005B0000008B000000FC000000FE000000FE030100FE000000FF
572D00FFFF8900FFF57E00FFF98100FFF88000FFF98100FFF98100FFF98202FFF87900FFFAC272FFFCF2C7FFFCEEC1FFFBD
594FFF87E00FFF98100FFF98100FFF98100FFF98202FFF87800FFFAA946FFFCF3C8FFFBEBBAFFFBE5B1FFF9890FFFF87E00
FFF98100FFF98100FFF98100FFF98100FFF98100FFF98100FFF98100FFF98100FFF98100FFF98100FFF98100FFF88100FFF
67F00FFFC8400FFDA7000FF090400FF010000FE000000FE000000FE000000FC0000007400000042000000310000001E0000
001100000008000000030000000C000000140000002300000036000000500000005F000000BA000000FF000000FC000000F
F010000FF010000FFC76600FFFE8600FFF67F00FFF88100FFF98100FFF98100FFF98100FFF98202FFF87900FFFAC272FFFC
F2C7FFFCEEC1FFFBD594FFF87E00FFF98100FFF98100FFF98100FFF98202FFF87800FFFAA946FFFCF3C8FFFBEBBAFFFBE5B
1FFF9890FFFF87E00FFF98100FFF98100FFF98100FFF98100FFF98100FFF98100FFF98100FFF98100FFF98100FFF98100FF
F98100FFF88000FFF98100FFF57E00FFFF8900FF5B2F00FF000000FF030100FF000000FB000000FF000000AC00000044000
0003A00000024000000150000000A000000050000000E00000017000000280000003C000000560000006F000000E5000000
FE000000FD020100FE000000FF381D00FFFD8400FFF77F00FFF98000FFF88000FFF98100FFF98100FFF98100FFF98202FFF
87900FFFAC272FFFCF2C7FFFCEEC1FFFBD594FFF87E00FFF98100FFF98100FFF98100FFF98202FFF87800FFFAA946FFFCF3
C8FFFBEBBAFFFBE5B1FFF9890FFFF87E00FFF98100FFF98100FFF98100FFF98100FFF98100FFF98100FFF98100FFF98100F
FF98100FFF98100FFF98100FFF98100FFF88000FFF57F00FFFE8600FFBF6200FF000000FF020100FE000000FC000000FE00
0000DE000000530000003E00000029000000180000000D00000006000000110000001A0000002C000000430000005900000
089000000FC000000FE000000FE040200FF000000FF8E4900FFFF8900FFF47E00FFF98100FFF98100FFF98100FFF98100FF
F98100FFF98202FFF87900FFFAC272FFFCF2C7FFFCEEC1FFFBD594FFF87E00FFF98100FFF98100FFF98100FFF98202FFF87
800FFFAA946FFFCF3C8FFFBEBBAFFFBE5B1FFF9890FFFF87E00FFF98100FFF98100FFF98100FFF98100FFF98100FFF98100
FFF98100FFF98100FFF98100FFF98100FFF98100FFF98100FFF98100FFF88000FFF98000FFF78000FF281500FF000000FF0
10000FE000000FE000000FB000000710000003F0000002E0000001C0000000F00000008000000130000001E000000310000
004A0000005B000000A7000000FF000000FC000000FF000000FF040200FFD06B00FFFE8500FFF67F00FFF88000FFF98100F
FF98100FFF98100FFF98100FFF98202FFF87900FFFAC272FFFCF2C7FFFCEEC1FFFBD594FFF87E00FFF98100FFF98100FFF9
8100FFF98202FFF87800FFFAA946FFFCF3C8FFFBEBBAFFFBE5B1FFF9890FFFF87E00FFF98100FFF98100FFF98100FFF9810
0FFF98100FFF98100FFF98100FFF98100FFF98100FFF98100FFF98100FFF98100FFF98100FFF98100FFF47E00FFFF8900FF
6C3700FF000000FF030100FF000000FC000000FF0000009500000040000000340000001F000000110000000A00000014000
00020000000340000004E00000060000000C3000000FE000000FB010000FE000000FF261300FFF77F00FFFA8000FFF88000
FFF98100FFF98100FFF98100FFF98100FFF98100FFF98202FFF87900FFFAC272FFFCF2C7FFFCEEC1FFFBD594FFF87E00FFF
98100FFF98100FFF98100FFF98202FFF87800FFFAA946FFFCF3C8FFFBEAB9FFFBE5B1FFF98A11FFF87F02FFF98202FFF982
02FFF98202FFF98202FFF98202FFF98202FFF98100FFF88000FFF98100FFF98100FFF98100FFF98100FFF98100FFF88000F
FF57E00FFFE8800FFA85600FF000000FF030100FE000000FB000000FE000000B60000004400000038000000220000001300
00000A0000001600000022000000380000005100000067000000D9000000FF000000FC030100FF000000FF512900FFFF870
0FFF57F00FFF98100FFF98100FFF98100FFF98100FFF98100FFF98100FFF98202FFF87900FFFAC272FFFCF2C7FFFCEEC1FF
FBD594FFF87E00FFF98100FFF98100FFF98100FFF98202FFF87800FFFAA946FFFCF3C7FFFBEBBAFFFAE4B0FFF88203FFF77
600FFF87900FFF87900FFF87900FFF87900FFF87800FFF87900FFF87E00FFF98201FFF98100FFF88000FFF98100FFF98100
FFF98100FFF98100FFF67F00FFFF8500FFD26C00FF020100FF000000FF000000FC000000FF000000D00000004B0000003A0
0000025000000150000000C00000018000000240000003A000000530000006F000000E7000000FF000000FD040200FF0000
00FF753C00FFFE8900FFF47E00FFF88000FFF98100FFF98100FFF98100FFF98100FFF98100FFF98202FFF87900FFFAC272F
FFCF2C7FFFCEEC1FFFBD594FFF87E00FFF98100FFF98100FFF98100FFF98202FFF87800FFFAA946FFFCF3C8FFFBEAB9FFFB
E9B8FFFAC87EFFFAC478FFFAC578FFFAC578FFFAC577FFFAC170FFFAB65EFFF9A33CFFF98910FFF87800FFF87E00FFF9820
1FFF88000FFF98100FFF98100FFF98100FFF78000FFFC8200FFEC7A00FF150B00FF000000FF000000FC000000FF000000E2
000000540000003B00000027000000160000000C00000019000000250000003C0000005400000077000000F0000000FF000
000FD030100FF000000FF904A00FFFF8900FFF57E00FFF98100FFF98100FFF98100FFF98100FFF98100FFF98100FFF98202
FFF87900FFFAC272FFFCF2C7FFFCEEC1FFFBD594FFF87E00FFF98100FFF98100FFF98100FFF98202FFF87800FFFAA946FFF
CF3C9FFFBE9B8FFFCECBCFFFCF1C5FFFCF2C6FFFCF1C6FFFCF1C6FFFCF1C6FFFCF1C5FFFBF1C6FFFBF1C5FFFBE7B4FFFAC0
71FFF8850DFFF87B00FFF98200FFF88000FFF98100FFF98100FFF88000FFF98100FFF98100FF291500FF000000FF010000F
D000000FF000000EC0000005C0000003C00000028000000170000000D00000019000000260000003D000000540000007C00
0000F5000000FF000000FE040200FF000000FF9F5200FFFF8800FFF57F00FFF98100FFF98100FFF98100FFF98100FFF9
)
   icondata2 =
(join 
8100FFF98100FFF98202FFF87900FFFAC272FFFCF2C7FFFCEEC1FFFBD594FFF87E00FFF98100FFF98100FFF98100FFF9820
2FFF87800FFFAA946FFFCF3C9FFFBE9B8FFFCECBCFFFCEFC1FFFCEFC1FFFCEFC1FFFCEFC1FFFCEFC1FFFCF1C4FFFCF1C5FF
FCEBBAFFFBEBBBFFFBF4CBFFFBDFA6FFF88D1AFFF87C00FFF98100FFF98000FFF98100FFF98100FFF88000FFFE8400FF361
B00FF000000FF020100FE000000FF000000F2000000620000003B00000029000000180000000E0000001A00000026000000
3E000000550000007E000000F7000000FF000000FD040200FF000000FFA35400FFFF8900FFF57E00FFF98100FFF98100FFF
98100FFF98100FFF98100FFF98100FFF98202FFF87900FFFAC272FFFCF2C7FFFCEEC1FFFBD594FFF87E00FFF98100FFF981
00FFF98100FFF98202FFF87800FFFAA946FFFCF3C8FFFBEAB9FFFBE6B3FFF9A23BFFF99A30FFF99C30FFF99C30FFF99C31F
FF9A340FFFABD6DFFFBE7B3FFFBEFC1FFFAE7B4FFFBF2C8FFFBD899FFF87F04FFF87F00FFF88100FFF98100FFF88000FFF7
7F00FFFE8500FF3A1D00FF000000FF010000FD000000FF000000F5000000640000003B0000002A000000180000000D00000
019000000250000003C000000540000007B000000F5000000FF000000FE040200FF000000FF9D5100FFFF8900FFF57F00FF
F98100FFF98100FFF98100FFF98100FFF98100FFF98100FFF98202FFF87900FFFAC272FFFCF2C7FFFCEEC1FFFBD594FFF87
E00FFF98100FFF98100FFF98100FFF98202FFF87800FFFAA946FFFCF3C7FFFBEBBAFFFAE4B0FFF88304FFF77700FFF87A00
FFF87A00FFF87A00FFF87900FFF87600FFF88D1AFFFBDDA2FFFBEFC2FFFAE7B4FFFCF3CAFFF9A946FFF77800FFF98201FFF
98100FFF98100FFF88000FFFE8300FF341A00FF000000FF020100FE000000FF000000F3000000620000003B000000290000
00170000000D00000018000000250000003B0000005300000076000000F0000000FF000000FD030100FF000000FF8C4800F
FFE8900FFF57E00FFF98100FFF98100FFF98100FFF98100FFF98100FFF98100FFF98202FFF87900FFFAC272FFFCF2C7FFFC
EEC1FFFBD594FFF87E00FFF98100FFF98100FFF98100FFF98202FFF87800FFFAA946FFFCF3C8FFFBEAB9FFFBE5B1FFF98A1
1FFF87F02FFF98202FFF98202FFF98202FFF98202FFF98303FFF77700FFF99625FFFBEEC0FFFBE9B8FFFBF1C5FFFACD87FF
F87A00FFF88100FFF98100FFF88000FFF98100FFF78000FF261300FF000000FF010000FD000000FF000000EC0000005B000
0003B00000027000000160000000D000000170000002300000039000000520000006D000000E7000000FF000000FD040200
FF000000FF703900FFFE8900FFF47E00FFF88000FFF98100FFF98100FFF98100FFF98100FFF98100FFF98202FFF87900FFF
AC272FFFCF2C7FFFCEEC1FFFBD594FFF87E00FFF98100FFF98100FFF98100FFF98202FFF87800FFFAA946FFFCF3C8FFFBEB
BAFFFBE5B1FFF9890FFFF87E00FFF98100FFF98100FFF98100FFF98100FFF88000FFF88101FFF87B00FFFAD594FFFCEFC3F
FFBEDBEFFFBDEA4FFF88203FFF87F00FFF98100FFF77F00FFFD8300FFE87800FF120800FF000000FF000000FC000000FF00
0000E1000000520000003A00000026000000150000000C0000001500000021000000360000004F00000065000000D800000
0FF000000FC030100FF000000FF4A2600FFFF8600FFF67F00FFF98100FFF98100FFF98100FFF98100FFF98100FFF98100FF
F98202FFF87900FFFAC272FFFCF2C7FFFCEEC1FFFBD594FFF87E00FFF98100FFF98100FFF98100FFF98202FFF87800FFFAA
946FFFCF3C8FFFBEBBAFFFBE5B1FFF9890FFFF87E00FFF98100FFF98100FFF98100FFF98100FFF98100FFF98201FFF77900
FFFAC579FFFBF2C7FFFBEBBAFFFAE4AFFFF9880DFFF77E00FFF98100FFF67F00FFFF8600FFCC6900FF010000FF010000FF0
00000FC000000FF000000CF000000490000003800000023000000140000000B000000140000001F000000320000004C0000
005C000000C2000000FE000000FB010000FE000000FF1F0F00FFF27D00FFFB8100FFF88000FFF98100FFF98100FFF98100F
FF98100FFF98100FFF98202FFF87900FFFAC272FFFCF2C7FFFCEEC1FFFBD594FFF87E00FFF98100FFF98100FFF98100FFF9
8202FFF87800FFFAA946FFFCF3C8FFFBEBBAFFFBE5B1FFF9890FFFF87E00FFF98100FFF98100FFF98100FFF98100FFF9810
0FFF98202FFF77900FFFAC578FFFBF2C7FFFBEABAFFFAE4AFFFF9880DFFF77D00FFF88000FFF57E00FFFE8900FF9E5100FF
000000FF040200FE000000FB000000FE000000B4000000410000003600000020000000120000000A000000110000001C000
0002E0000004700000057000000A4000000FF000000FC000000FF010000FF010000FFC76600FFFE8600FFF67F00FFF88000
FFF98100FFF98100FFF98100FFF98100FFF98202FFF87900FFFAC272FFFCF2C7FFFCEEC1FFFBD594FFF87E00FFF98100FFF
98100FFF98100FFF98202FFF87800FFFAA946FFFCF3C8FFFBEBBAFFFBE5B1FFF9890FFFF87E00FFF98100FFF98100FFF981
00FFF98100FFF88000FFF88101FFF87B00FFFAD390FFFCF0C3FFFBECBDFFFBDFA5FFF88304FFF87F00FFF98100FFF57E00F
FFF8900FF603100FF000000FF030100FF000000FC000000FF000000920000003D000000310000001D000000100000000900
00000F000000180000002A000000400000005500000084000000FC000000FE000000FE040200FF000000FF7F4100FFFF890
0FFF47E00FFF98100FFF98100FFF98100FFF98100FFF98100FFF98202FFF87900FFFAC272FFFCF2C7FFFCEEC1FFFBD594FF
F87E00FFF98100FFF98100FFF98100FFF98202FFF87800FFFAA946FFFCF3C8FFFBEAB9FFFBE5B1FFF98910FFF87E01FFF98
101FFF98101FFF98101FFF98201FFF98303FFF77900FFF9911CFFFBECBDFFFBEAB9FFFCF0C4FFFACF8AFFF87B00FFF88100
FFF88000FFFB8100FFF27C00FF1D0F00FF000000FF010000FE000000FE000000FB0000006D0000003C0000002B0000001A0
000000E000000070000000D0000001500000025000000380000005100000069000000E3000000FE000000FD010000FE0000
00FF291500FFF98100FFF88000FFF88000FFF88000FFF98100FFF98100FFF98100FFF98202FFF87900FFFAC272FFFCF2C7F
FFCEEC1FFFBD594FFF87E00FFF98100FFF98100FFF98100FFF98202FFF87800FFFAA946FFFCF3C7FFFBEBBAFFFAE4B0FFF8
8407FFF77900FFF87C00FFF87C00FFF87C00FFF87A00FFF87600FFF8850FFFFAD798FFFBF0C4FFFAE7B4FFFCF4CAFFF9AD4
DFFF77800FFF98202FFF57E00FFFF8800FFAF5A00FF000000FF020100FE000000FC000000FE000000DC0000004E0000003B
00000026000000160000000B000000050000000A0000001200000020000000320000004B0000005A000000B7000000FF000
000FC000000FF020100FF000000FFB65E00FFFF8700FFF57E00FFF98100FFF98100FFF98100FFF98100FFF98202FFF87900
FFFAC272FFFCF2C7FFFCEEC1FFFBD594FFF87E00FFF98100FFF98100FFF98100FFF98202FFF87800FFFAA946FFFCF3C8FFF
BEAB9FFFBE6B2FFF9992BFFF8901FFFF9921FFFF9921FFFF99320FFF9992FFFF9B259FFFBE0A7FFFBEFC2FFFAE7B4FFFBF1
C5FFFBDEA3FFF88209FFF87F00FFF98100FFF67E00FFFF8700FF492600FF000000FF030100FF000000FC000000FF000000A
90000003F0000003600000021000000130000000900000004000000080000000E0000001B0000002B000000410000005400
000084000000FC000000FE000000FE030100FE000000FF412100FFFE8600FFF67F00FFF98100FFF88000FFF98100FFF9810
0FFF98101FFF87900FFF9C170FFFBF0C4FFFBECBEFFFAD492FFF87E00FFF98100FFF98100FFF98100FFF98101FFF87800FF
F9A845FFFBF1C6FFFAE8B6FFFBEAB9FFFBEBBBFFFBEBBBFFFBEBBBFFFBEBBBFFFBEBBBFFFCEEC0FFFCF1C5FFFCECBCFFFBE
AB8FFFBF4CAFFFBE6B2FFF89324FFF87B00FFF98101FFF67F00FFFE8600FFC86700FF020100FF020000FE000000FE000000
FE000000FB0000006D0000003D0000002D0000001B0000000F0000000700000003000000060000000B00000016000000240
00000370000005000000061000000D3000000FF000000FC000000FF010000FF000000FFB05A00FFFF8800FFF57E00FFF981
00FFF88000FFF98100FFF98202FFF77800FFFAC578FFFCF8D2FFFCF4CCFFFBDA9CFFF77D00FFF98100FFF98100FFF98100F
FF98202FFF77700FFFAAB4AFFFCF9D4FFFBF0C4FFFCF2C7FFFCF1C6FFFCF1C6FFFCF1C6FFFCF1C6FFFCF1C6FFFCF1C5FFFB
F1C6FFFBF3C9FFFBEDBEFFFACA83FFF88B18FFF87B00FFF98201FFF98000FFF67E00FFFF8700FF452300FF000000FF03010
0FF000000FC000000FF000000CA000000470000003A00000025000000160000000C00000005000000010000000400000008
000000110000001D0000002E000000450000005600000090000000FF000000FD000000FE010000FE000000FF231200FFF37
F00FFF88100FFF77F00FFF98100FFF88000FFF98101FFF87B00FFF9B154FFFBD493FFFBD18FFFFABF6DFFF87E00FFF98100
FFF98100FFF98100FFF98101FFF87A00FFF99E34FFFBD595FFFACF89FFFBD08BFFFBD08BFFFBD08BFFFBD08BFFFBD08BFFF
ACF8AFFFACC83FFFAC171FFF9AD4FFFF9911EFFF87A00FFF87D00FFF98201FFF98100FFF47E00FFFF8900FFA25300FF0000
00FF020100FE000000FE000000FD000000FE0000007C0000003D000000310000001E0000001100000009000000030000000
000000002000000060000000D0000001700000026000000390000005100000060000000D2000000FF000000FC000000FF02
0000FE000000FF663400FFFF8A00FFF27D00FFF88000FFF88000FFF98000FFF98100FFF87D00FFF87B00FFF87B00FFF87D0
0FFF98100FFF98100FFF98100FFF98100FFF98000FFF98100FFF87F00FFF87B00FFF87C00FFF87B00FFF87B00FFF87B00FF
F87B00FFF87B00FFF87B00FFF87B00FFF87900FFF87800FFF87D00FFF98201FFF98101FFF98100FFF57E00FFFB8300FFE07
500FF120900FF010000FE000000FF000000FC000000FF000000C9000000470000003C00000027000000180000000D000000
060000000200000000000000010000000400000009000000110000001E0000002E000000430000005600000082000000FA0
00000FD000000FE000000FF020100FF000000FF9E5100FFFF8900FFF27C00FFF98100FFF88000FFF88000FFF98100FFF981
01FFF98101FFF98101FFF88000FFF98100FFF98100FFF98100FFF98100FFF88000FFF98100FFF98101FFF98101FFF98101F
FF98101FFF98101FFF98101FFF98101FFF98101FFF98202FFF98202FFF98202FFF98101FFF88000FFF98100FFF67F00FFF6
8000FFF98300FF3A1D00FF000000FF010000FE000000FE000000FC000000F80000006D0000003F000000310000001F00000
012000000090000000400000001000000000000000000000002000000060000000D0000001700000024000000360000004E
00000059000000B3000000FF000000FC000000FE000000FE010000FF030100FFB35C00FFFF8900FFF27D00FFF98100FFF98
100FFF88000FFF98100FFF98100FFF98100FFF98100FFF98100FFF98100FFF98100FFF98100FFF98100FFF98100FFF98100
FFF98100FFF98100FFF98100FFF98100FFF98100FFF98100FFF98100FFF98100FFF98100FFF98100FFF88000FFF98100FFF
67F00FFF67F00FFFD8500FF572C00FF000000FF020100FE000000FE000000FB000000FF000000A5000000410000003A0000
0025000000170000000D0000000600000002000000000000000000000000000000000000000400000009000000110000001
C0000002B0000003D0000005300000066000000DB000000FF000000FC000000FF000000FE000000FF080400FFB85F00FFFF
8A00FFF47E00FFF88000FFF98100FFF88000FFF98100FFF98100FFF98100FFF98100FFF98100FFF98100FFF98100FFF9810
0FFF98100FFF98100FFF98100FFF98100FFF98100FFF98100FFF98100FFF98100FFF98100FFF98100FFF98100FFF88000FF
F98100FFF57E00FFFA8200FFFD8500FF5D2F00FF000000FF020100FE000000FF000000FC000000FF000000D50000004F000
000400000002C0000001D000000110000000900000004000000010000000000000000000000000000000000000002000000
050000000B000000140000002100000030000000440000005600000079000000EF000000FF000000FD000000FF010000FE0
00000FF050200FF9D5200FFFF8A00FFF98100FFF57F00FFF98100FFF88000FFF88000FFF98100FFF98100FFF98100FFF981
00FFF98100FFF98100FFF98100FFF98100FFF98100FFF98100FFF98100FFF98100FFF98100FFF98100FFF98100FFF88000F
FF98100FFF88000FFF47E00FFFF8700FFED7D00FF4D2700FF000000FF020100FE000000FF000000FC000000FF000000EC00
000065000000410000003300000022000000150000000C00000006000000020000000000000000000000000000000000000
0000000000000000003000000070000000E000000180000002500000035000000490000005700000088000000F7000000FF
000000FD000000FF010000FE000000FF000000FF6A3700FFF17F00FFFF8800FFF67F00FFF67F00FFF88100FFF98100FFF88
000FFF98100FFF98100FFF98100FFF98100FFF98100FFF98100FFF98100FFF98100FFF98100FFF98100FFF98100FFF88000
FFF98100FFF88000FFF57E00FFFB8200FFFF8A00FFC16500FF271400FF000000FF020100FE000000FF000000FD000000FF0
00000F500000076000000420000003800000025000000180000000E00000008000000030000000000000000000000000000
0000000000000000000000000000000000010000000400000009000000100000001B00000028000000370000004D0000005
600000090000000F8000000FF000000FD000000FF000000FE020000FF000000FF2A1500FFB05C00FFFF8600FFFF8700FFF9
8100FFF57F00FFF67F00FFF88000FFF98100FFF88000FFF98100FFF98100FFF98100FFF98100FFF88000FFF88000FFF8810
0FFF78000FFF57F00FFF67F00FFFE8300FFFF8900FFE87A00FF743C00FF030100FF000000FF020100FE000000FF000000FC
000000FF000000F700000081000000420000003C000000280000001B0000001100000009000000040000000100000000000
0000000000000000000000000000000000000000000000000000000000002000000050000000A000000120000001C000000
2A000000390000004C000000550000008C000000F4000000FF000000FC000000FF000000FF020100FE000000FF000000FF4
62400FFB35D00FFF88100FFFF8A00FFFF8600FFFC8200FFF78000FFF57F00FFF57E00FFF57E00FFF57E00FFF57E00FFF57F
00FFF67F00FFF98100FFFF8400FFFF8800FFFF8800FFE07500FF854500FF1A0D00FF000000FF000000FE010000FF000000F
F000000FB000000FF000000F20000007D000000420000003C0000002A0000001D000000130000000B000000050000000200
000000000000000000000000000000000000000000000000000000000000000000000000000000000000020000000600000
00C000000140000001E0000002B000000390000004C000000550000007F000000E5000000FF000000FD000000FD000000FF
020100FE020100FE000000FF000000FF2F1800FF7E4200FFC36500FFEE7C00FFFF8600FFFF8900FFFF8A00FFFF8A00FFFF8
A00FFFF8A00FFFF8A00FFFF8800FFFC8300FFDF7400FFA85700FF5B2F00FF120900FF000000FF000000FE040200FE000000
FF000000FD000000FC000000FF000000E100000070000000430000003D0000002B0000001F000000140000000C000000060
000000300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000100000003000000070000000C000000140000001E0000002A0000003700000049000000530000006B000000C4000000F
F000000FF000000FC000000FE000000FF030100FE020100FE000000FF000000FF000000FF1A0E00FF412200FF653400FF7E
4100FF8D4900FF904A00FF884600FF743C00FF552C00FF2F1900FF0C0600FF000000FF000000FF000000FE040200FE01000
0FF000000FE000000FC000000FF000000FF000000BD0000005A000000420000003B0000002A0000001E000000140000000D
000000070000000300000001000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000100000003000000070000000C000000130000001C000000280000003400000044000000
500000005800000094000000E6000000FF000000FF000000FC000000FD000000FE020100FE040200FE020100FF000000FF0
00000FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF040200FE030200FE0100
00FE000000FD000000FC000000FF000000FF000000E300000089000000480000004200000037000000280000001D0000001
40000000C000000070000000300000001000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000100000003000000070000000C000000120000001B00000
024000000300000003D0000004C0000004F00000066000000AA000000EC000000FF000000FF000000FF000000FC000000FD
000000FD010000FE030100FE040200FE040200FF040200FF040200FF040200FF040200FE030100FE020100FE000000FD000
000FC000000FC000000FF000000FF000000FF000000EA000000A300000059000000410000003F0000003100000025000000
1B000000120000000C000000070000000300000001000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000100000003000000060000
000A0000001000000017000000200000002A00000035000000430000004C0000004F00000069000000A1000000DB000000F
D000000FF000000FF000000FF000000FF000000FD000000FC000000FC000000FC000000FC000000FC000000FC000000FD00
0000FF000000FF000000FF000000FF000000FD000000D80000009A0000005E0000004300000041000000380000002A00000
02100000018000000100000000B000000060000000300000001000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000010000000200000005000000090000000E000000140000001B000000230000002D00000037000000430000004A000000
4C0000005B0000007D000000A9000000D1000000ED000000FD000000FF000000FF000000FF000000FF000000FF000000FF0
00000FF000000FF000000FD000000EC000000CF000000A4000000750000005200000042000000400000003A0000002E0000
00240000001C000000140000000E00000009000000050000000300000001000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000200000004000000070000000B00000010000000160000001D0000002500000
02D000000360000004000000047000000480000004B0000005400000064000000790000008D0000009E000000AA000000B0
000000AF000000A90000009D0000008B000000760000005F0000004D00000043000000410000003F000000380000002E000
000250000001D00000016000000100000000B00000007000000040000000200000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000010000000300000005000000080000000C0000
0011000000160000001C000000230000002900000030000000370000003E000000420000004400000045000000450000004
6000000460000004700000046000000450000004300000042000000410000003F0000003D00000038000000310000002900
0000230000001D00000017000000110000000D0000000900000006000000030000000100000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000002000
0000400000006000000090000000C0000001000000015000000190000001E00000023000000270000002B0000002F000000
3300000037000000390000003A0000003B0000003A000000390000003700000034000000300000002C00000028000000230
000001E0000001A00000015000000110000000C000000090000000600000004000000020000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000001000000020000000400000006000000080000000B0000000E00000011000000140000001700000
01A0000001D0000001F000000210000002200000023000000230000002300000022000000210000001F0000
)
   icondata3 =
(join
001D0000001A0000001700000014000000110000000E0000000B00000008000000060000000400000002000000010000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000100000002000000040000000600000008
0000000A0000000C0000000E000000100000001200000014000000150000001600000017000000170000001700000016000
000150000001400000012000000100000000E0000000C0000000A0000000800000006000000040000000300000001000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000FFFFC0000007FFFFFFFF00000001FFFFFFFC000000007FFFFFF800000000
3FFFFFE0000000000FFFFFC00000000007FFFF800000000003FFFF000000000001FFFE000000000000FFFC0000000000007
FF80000000000003FF00000000000001FF00000000000000FE00000000000000FC000000000000007C00000000000000780
000000000000030000000000000003000000000000000100000000000000010000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000001000000000000000100000000000000018
000000000000003C000000000000003C000000000000007E00000000000000FE00000000000000FF00000000000001FF800
00000000003FF80000000000003FFC0000000000007FFE000000000000FFFF000000000001FFFF800000000003FFFFE0000
000000FFFFFF0000000001FFFFFFC000000007FFFFFFE00000000FFFFFFFF80000003FFFF
)
 WriteFile_1("ip.ico","icondata1|icondata2|icondata3")
}
return
WriteFile_1(File_1,Blocks)
{
   Global
         Local Handle, Data_1, Hex
         Handle :=  DllCall("CreateFile","Str",File_1,"Uint",0x40000000,"Uint",0,"UInt",0,"UInt",4,"Uint",0,"UInt",0)
         Loop, Parse, Blocks, |
            {
                  Data_1 := %A_LoopField%
                  Loop,
                     {
                        If StrLen(Data_1) = 0
                             Break
                        StringLeft, Hex, Data_1, 2
                        StringTrimLeft, Data_1, Data_1, 2
                        Hex = 0x%Hex%
                        DllCall("WriteFile","UInt", Handle,"UChar *", Hex,"UInt",1,"UInt *",UnusedVariable,"UInt",0)
                     }
            }
      DllCall("CloseHandle", "Uint", Handle)
      Return
}
