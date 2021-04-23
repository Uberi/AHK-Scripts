;DbgHelper_RunDebugView()





donotupdate :=false
test1 :=false  ;if true no cmostimer and no Shutdown and Hidden columns are shown
rowNumber=
programmfenster1=Kronomium
programmfenster2=Kronomium Optionen - Options

zeittest=
(
20080330174937# 110000000 ,000120 ,153042 ,00# prog# run.ahk
20080405093143# 011111111 ,000020 ,002010 ,00# start# run.ahk
20080408141613# 100010000 ,000100 ,163010 ,00# shutdown# run.ahk
20080324101807# 111000111 ,000300 ,225900 ,00# kommentar fünf# run.ahk
20080329003532# 110000000 ,001000 ,163010 ,10# progtest normale wiederholung# run.ahk
20080330003445# 110000000 ,000100 ,000000 ,10# progtest wiederholung bis mitternacht# runimmortal2.ahk
20080330003511# 110000000 ,000100 ,000000 ,10# immortal# runimmortal.ahk
20080401073610# 010000000 ,001000 ,163010 ,10# # run.ahk
20080405093143# 011111111 ,000020 ,002010 ,1# kommentar drei# run.ahk
20080408141613# 100010000 ,000100 ,163010 ,1# geändert id1# run.ahk
)

timefile=KronomiumTimes.lst
IfNotExist,%timefile%
  FileAppend,%zeittest%,%timefile%

IniVar=
(
[lang]
actualLang=fr
possibleLangs=de,en,fr

[de]
MenulanguageTitel = Sprachauswahl
tooltip_txt = tooltip
LV1_tit = Zeit
LV2_tit = Status
LV3_tit = Optionen
LV4_tit = Kommentar
LV5_tit = Programm/Befehl starten
LV6_tit = hidden time
LV7_tit = hidden opt
LV8_tit = hidden repeat
LV9_tit = hidden repeatuntil
LV10_tit = hidden id
LV11_tit =wiederhole Programm
LV12_tit =hidden im/mortal
LV11_c1= alle
LV11_c2= (hh:mm:ss) bis  
LV11_c3= Uhr
status1 = nächster Start
status2 = Rechner herunterfahren
status3 = nächster Prg starten
opt1 = So
opt2 = Mo
opt3 = Di
opt4 = Mi
opt5 = Do
opt6 = Fr
opt7 = Sa
menutxt1 = Über
traytxt1 =Doppelklick um das Haupfenster zu zeigen
traytxt2 =zeige Programmfenster
traytxt3 =verstecke Programmfenster
traytxt4 =Rechner herunterfahren
traytxt5 =beende Programm
traytip2 =kein
traytip3 =Herunterfahren
traytip4 =Starten eines Programms
OptGuiTxt4  =Ändern
OptGuiTxt5  =Löschen
OptGuiTxt6  =Aktualisieren
OptGuiTxt7  =(tgl) Täglich
OptGuiTxt8  =Hinzufügen
OptGuiTxt9  =(Mo) Montags
OptGuiTxt10 =(Di) Dienstags
OptGuiTxt11 =(Mi) Mittwochs
OptGuiTxt12 =(Do) Donnerstags
OptGuiTxt13 =(Fr) Freitags
OptGuiTxt14 =(Sa) Samstags
OptGuiTxt15 =(So) Sonntags
OptGuiTxt16 =(WT) Wochentags
OptGuiTxt17 =(WE) Wochenende
OptGuiTxt21 =Starte Bioseintrag
OptGuiTxt22 =nächste Weckzeit
OptGuiTxt23 =Aufweckzeit wurde ins Bios eingetragen
OptGuiTxt25 =wiederkehrende Zeiten
OptGuiTxt27 =kurzer Kommentar
OptGuiTxt28 =Weckzeit + Kommentar
OptGuiTxt29 =speichert die Liste und trägt den nächsten Termin ins Bios ein
OptGuiTxt32 =Rechner abschalten (standby)
OptGuiTxt33 =wiederhole das Prog. alle hh:mm:ss. Bsp.: 01:03:50 > 1h3m50s dh. starte alle 63min50s
OptGuiTxt34 =Die obige Wiederholung geht bis zu dieser Uhrzeit HH:mm:ss.
OptGuiTxt35 =Bsp.: 235500 bis 5min vor Mitternacht (geht niemals darüber)
OptGuiTxt36 =starte Programme
OptGuiTxt37 =Programme werden ab Termin immer wiederholt - kein Stop um Mitternacht
hO1TT = aktuelles Datum
hO2TT = aktuelle Zeit
hO3TT = Eingabe entfernen
TTLV = Doppelklick öffnet das Optionsfenster
shutdownTxt1 =Shutdown in
SDAbbruchTxt1 =Rechner wird in Kürze heruntergefahren
LastWarnTxt1 =Rechner fährt herunter
CrdTxt1 =Autor:`t`thaichen
CrdTxt2 =Adresse:`tDeutschland
CrdTxt3 =Danke an:

[en]
MenulanguageTitel =language menu
tooltip_txt = tooltip
LV1_tit = time
LV2_tit = status
LV3_tit = Options
LV4_tit = comments
LV5_tit = command
LV6_tit = hidden time
LV7_tit = hidden opt
LV8_tit = hidden repeat
LV9_tit = hidden repeatuntil
LV10_tit = hidden id
LV11_tit =repeat program
LV12_tit =hidden im/mortal
LV11_c1= every
LV11_c2= (hh:mm:ss) until  
LV11_c3= o' clock
status1 = next start
status2 = next shutdown
status3 = next Prg start
opt1 = Su
opt2 = Mo
opt3 = Tu
opt4 = Wd
opt5 = Th
opt6 = Fr
opt7 = Sa
menutxt1 = about
traytxt1 =doubleclick on icon to show or hide mainwindow
traytxt2 =show timer   
traytxt3 =hide timer
traytxt4 =shutdown PC
traytxt5 =Exit program
traytip2 =no
traytip3 =next shutdown at
traytip4 =next start of a program
OptGuiTxt4  =Change
OptGuiTxt5  =Delete
OptGuiTxt6  =Refresh
OptGuiTxt7  =(ED) every day
OptGuiTxt8  =add
OptGuiTxt9  =(Mo) mondays
OptGuiTxt10 =(Tu) tuesdays
OptGuiTxt11 =(We) wednesdays
OptGuiTxt12 =(Th) thursdays
OptGuiTxt13 =(Fr) fridays
OptGuiTxt14 =(Sa) saturdays
OptGuiTxt15 =(Su) sundays
OptGuiTxt16 =(WD) weekdays
OptGuiTxt17 =(WeE) weekend
OptGuiTxt21 =set Bios
OptGuiTxt22 =next wakeup
OptGuiTxt23 =wakeuptime was set to Bios
OptGuiTxt25 =returning times
OptGuiTxt27 =short comment
OptGuiTxt28 =waketime + comment
OptGuiTxt29 =save the list and set next waketime into the bios
OptGuiTxt32 =shutdown (standby)
OptGuiTxt33 =repeat the program every hh:mm:ss. Ex.: 01:03:50 > 1h3m50s means start every 63min50s
OptGuiTxt34 =the above recurrence runs until HH:mm:ss. Ex.: 23:55:00 means
OptGuiTxt35 =repeat until 5min before midnight
OptGuiTxt36 =Run Programs
OptGuiTxt37 =Programs are repeated without end
hO1TT = current date
hO2TT = current time
hO3TT = remove Input
TTLV = DoubleClick to change this
shutdownTxt1 =Shutdown in
SDAbbruchTxt1 =Rechner wird in Kürze heruntergefahren
LastWarnTxt1 =Rechner fährt herunter
CrdTxt1 =Author:`t`thaichen
CrdTxt2 =Adress:`t`tGermany
CrdTxt3 =Thanks to:

[fr]
MenulanguageTitel =Sprachauswahl
tooltip_txt = tooltip
LV1_tit = Zeit
LV2_tit = Status
LV3_tit = Optionen
LV4_tit = commentar
LV5_tit = befehl
LV6_tit = hidden time
LV7_tit = hidden opt
LV8_tit = hidden repeat
LV9_tit = hidden repeatuntil
LV10_tit = hidden id
LV11_tit =repeat program
LV12_tit =hidden im/mortal
LV11_c1= every
LV11_c2= (hh:mm:ss) until  
LV11_c3= o' clock
status1 = next Start
status2 = next herunterfahren
status3 = next Prg starten
opt1 = So
opt2 = Mo
opt3 = Di
opt4 = Mi
opt5 = Do
opt6 = Fr
opt7 = Sa
menutxt1 = about
traytxt1 =doubleclick on icon to show or hide main window
traytxt2 =show timer   
traytxt3 =hide timer
traytxt4 =shutdown PC
traytxt5 =Close
traytip2 =non
traytip3 =next shutdown at
traytip4 =next start of a program
OptGuiTxt4  =Change
OptGuiTxt5  =Delete
OptGuiTxt6  =Refresh
OptGuiTxt7  =(ED) every day
OptGuiTxt8  =add
OptGuiTxt9  =(Mo) mondays
OptGuiTxt10 =(Tu) tuesdays
OptGuiTxt11 =(We) wednesdays
OptGuiTxt12 =(Th) thursdays
OptGuiTxt13 =(Fr) fridays
OptGuiTxt14 =(Sa) saturdays
OptGuiTxt15 =(Su) sundays
OptGuiTxt16 =(WD) weekdays
OptGuiTxt17 =(WeE) weekend
OptGuiTxt21 =set Bios
OptGuiTxt22 =next wakeup
OptGuiTxt23 =wakeuptime was set to Bios
OptGuiTxt25 =returning times
OptGuiTxt27 =short comment
OptGuiTxt28 =waketime + comment
OptGuiTxt29 =save the list and set next waketime into the bios
OptGuiTxt32 =shutdown (standby)
OptGuiTxt33 =repeat the program every hh:mm:ss. Ex.: 01:03:50 > 1h3m50s means start every 63min50s
OptGuiTxt34 =the above recurrence runs until HH:mm:ss. Ex.: 23:55:00 means
OptGuiTxt35 =repeat until 5min before midnight (never! above midnight)
OptGuiTxt36 =Run Programs
OptGuiTxt37 =Programs are repeated without end
hO1TT = current date
hO2TT = current time
hO3TT = remove Input
TTLV = DoubleClick to change this
shutdownTxt1 =Shutdown in
SDAbbruchTxt1 =Rechner wird in Kürze heruntergefahren
LastWarnTxt1 =Rechner fährt herunter
CrdTxt1 =Author:`t`thaichen
CrdTxt2 =Adress:`tGermany
CrdTxt3 =Merci a:

[program]
Pwidth=648
pX=84
pY=481
p2X=517
p2Y=39
)


MCode(DelSp3)
Toggle =0

;-------------------------------------------------------------
Inifile=lan.ini



LangHelp_NewStartINI(Inifile,INIVar)
IniWrite, %actualLang%, %INIfile%, lang, actualLang
FileRead, Inivar, %INIfile%
LangHelp_loadVarsFromIniVar(IniVar,"program")
LangHelp_loadVarsFromIniVar(IniVar,"lang")
LangHelp_loadVarsFromIniVar(IniVar,actualLang)
LangHelp_LoadLanguageVars(IniVar,"updateLang","MyMenuBar")
Gosub, main

Return

;------------------------------------------------------------
;-------------------------------------------------------------

main:
  Gui, Submit, NoHide
  ;------------------------------------------
  SetTimer, ToolTips, 2000
  SetFormat, Float, 2.0
  rebootrequired()
  Gui, +Resize
  Gui, Add, ListView,Grid HWNDhTTLV Sort NoSortHdr AltSubmit w%Pwidth% vMyListView gClickLV, %LV1_tit%|%LV2_tit%|%LV3_tit%|%LV4_tit%|%LV5_tit%|%LV6_tit%|%LV7_tit%|%LV8_tit%|%LV9_tit%|%LV10_tit%|%LV11_tit%|%LV12_tit%
  AddToolTip(hTTLV,TTLV)
  LVX_Setup("MyListView")
  FileRead,zeit, %timefile%
  zeitneu:=NeueZeit(zeit)
  LVFill(zeitneu)
  zeit:=LV_ReadAndSave(timefile)

  Menu, MyMenuBar, Add, %traytxt5%, GuiClose
  Menu, MyMenuBar, Add, %traytxt3%, hidetimer


  Gosub,showTrayTip
  ;Menu, Tray, Tip, %traytxt1%
  Menu, tray, NoStandard
  Menu, tray, add, Kronomium,about
  Menu, tray, add  ; Creates a separator line.
  oldtitel1 :=LangHelp_showLangTrayMenu(possibleLangs, MenulanguageTitel)

  Menu, tray, add, %traytxt3%,hidetimer ;hide timer-verstecke Programmfenster
  Menu, tray, add, %traytxt2%,showtimer ;show timer-zeige Programmfenster
  Menu, tray, Disable, %traytxt3%
  Menu, Tray, Default, %traytxt2%
  Menu, tray, add
  Menu, tray, add,%traytxt4%, PCShutdown ;instantShutdown
  Menu, tray, add,%traytxt5%, GuiClose

  Menufile=%file%
  Menuopen=%Open%
  MenuExit=%Exit%
  oldMenu1=%traytxt3%
  oldMenu2=%traytxt5%
  oldMenu3=%Menutxt1%
  oldtray1=%traytxt1%
  oldtray2=%traytxt2%
  oldtray3=%traytxt3%
  oldtray4=%traytxt4%
  oldtray5=%traytxt5%
  ;oldtitel1 :=LangHelp_showLangTrayMenu(possibleLangs, MenulanguageTitel)
  LangHelp_showLangMenu(possibleLangs, MenulanguageTitel)
  Menu, MyMenuBar, Add, %Menutxt1%, about
  Menu, MyMenuBar, Add, ,void
  Gui, Menu, MyMenuBar
  ;LangHelp_showLangRadioMenu(possibleLangs, actualLang)
  Gosub, updateLang
  ;--------------------------
  Process, Exist
  pid_this := ErrorLevel

  ; Retrieve unique ID number (HWND/handle)
  WinGet, hw_Gui, ID, ahk_class AutoHotkeyGui ahk_pid %pid_this%

  ; Call "HandleMessage" when script receives WM_SETCURSOR message
  WM_SETCURSOR = 0x20
  OnMessage(WM_SETCURSOR, "HandleMessage")

  ; Call "HandleMessage" when script receives WM_MOUSEMOVE message
  WM_MouseMove = 0x200
  OnMessage(WM_MouseMove, "HandleMessage")
  ;-------------------------------------------
Return



tooltips:
  ToolTip
  CoordMode, Mouse, Screen
  MouseGetPos, xm, ym, hWnd
  Mousearea := NCHITTEST(xm, ym, hWnd)
  IfWinActive, cmostimer
    If (Mousearea = "MINButton")
      ToolTip, %ToolTip_txt%

Return


newTimer:
  zeit:=LV_ReadAndSave(timefile)
  zeitneu:=NeueZeit(zeit)
  LVX_Setup("MyListView")
  LVFill(zeitneu)
Return

void:
Return


CMOSTimer:
  SetTimer, refresh,% tdiff(cmostime) ; falls cmostime erreicht wurde ohne den Rechner heRunterzufahren
  FormatTime, formattedTime, %CmosTime% ,dd.MM.yyyy HH:mm
  IfExist, %A_ScriptDir%\CMOSTimer.exe
  {
    target = %A_ScriptDir%\CMOSTimer.exe /wakeuponly=%formattedTime%
    test:=false
  }	Else
    test:=true
  ; set Bios-Starte Bioseintrag                 next wakeup:-nächste Weckzeit:

  If (!donotupdate)
  {
    MsgBox,1,%OptGuiTxt21% %formattedTime%,%OptGuiTxt22% `n%formattedTime%,15
    IfMsgBox Cancel
      Return
    IfMsgBox OK
    {
      If (!test1)
        Run,%target%,%A_ScriptDir%
      MsgBox, 0,Cmostimer cmd,%OptGuiTxt23% ,1 ;Aufweckzeit wurde ins Bios eingetragen.
      Return                              ;wakeuptime was set to Bios
    }
    IfMsgBox Timeout
    {
      If (!test1)
        Run,%target%,%A_ScriptDir%
      MsgBox, 0,Cmostimer cmd,%OptGuiTxt23% ,1 ;Aufweckzeit wurde ins Bios eingetragen.
    }
  }
  donotupdate:=false
Return

PCShutdown:
  t=LastWarn
  CDTimer(10000,t)
  Gosub,SDabbruch
  Gosub, refresh
Return

CDTimer(Countdowntimer,byref label){
    global unvpura9AA7B2F0_Counter  ,unvpura9AA7B2F0_Countdowntime,Shutdowntxt1
    unvpura9AA7B2F0_Counter:=Countdowntimer
    unvpura9AA7B2F0_Countdowntime:=Countdowntimer
    Gosub, CDTimer
    SetTimer, CDTimer, % (( Toggle := !Toggle ) ? "1000" : "off" )


CDTimer:
  Gui, Submit, NoHide
  unvpura9AA7B2F0_Counter -= 1000
  Count :=  unvpura9AA7B2F0_Counter*100/unvpura9AA7B2F0_Countdowntime
  sdt:=unvpura9AA7B2F0_Counter/1000
  SetFormat, Float, 3.0
  yy:= A_ScreenHeight-100
  Progress,b y%yy% x0 w%A_ScreenWidth%, %sdt% sec, %Shutdowntxt1%, ShutdownProgress
  Progress, %Count%
  If (Count <= 0 ){
    Progress, off
    SetTimer, CDTimer,off
    Gosub,%Label%
  }
Return
Return
}

SDabbruch:
  MsgBox 1,,%SDAbbruchTxt1%,15
  IfMsgBox Cancel
  {
    Progress, off
    SetTimer, CDTimer,off
    Return
  }
  IfMsgBox OK
  {
    Progress, off
    SetTimer, CDTimer,off
    If (!test1)
    {
      If (ReBootRequired = 1)
      {
        IniWrite,1,cmosreboot.ini, Section1, isrebooted
        Shutdown,6
      }Else
        Shutdown,9
      ExitApp
    }
  }
  IfMsgBox Timeout
  {
    Progress, off
    SetTimer, CDTimer,off
    If (!test1)
    {
      If (ReBootRequired = 1)
      {
        IniWrite,1,cmosreboot.ini, Section1, isrebooted
        Shutdown,6
      }Else
        Shutdown,9
      ExitApp
    }
  }
Return

LastWarn:
  SplashTextOn,200,40, %LastWarnTxt1%,..%LastWarnTxt1%..
  Sleep 5000
  SplashTextOff
Return

runProgram:
  Run, %Runner%
  immortal=%immortal1%1
  Gui,1:Default
  Loop % LV_GetCount()
  {
    LV_GetText(dummy, A_Index,10)
    If (dummy = RunnerId){
      LV_Modify(RowNumber,"Col12",  immortal)
    }
  }
  donotupdate:=true
  Gosub, refresh
  donotupdate:=false
Return



ClickLV:
  Gui, Submit, NoHide
  IfWinExist, %programmfenster2%
    ev =Normal
  Else
    ev =DoubleClick

  If A_GuiEvent = %ev%
  {

    LV_GetText(date, A_EventInfo,6)
    LV_GetText(options, A_EventInfo,7)
    LV_GetText(comment, A_EventInfo,4)
    LV_GetText(Runprog, A_EventInfo,5)
    LV_GetText(Repeat, A_EventInfo,8)
    LV_GetText(Repeatuntil, A_EventInfo,9)
    LV_GetText(RowID, A_EventInfo,10)
    LV_GetText(immortal, A_EventInfo,12)
    immortal1:=SubStr(immortal,1,1)
    immortal2:=SubStr(immortal,2,1)
    If (immortal=""){
      immortal1:=0
      immortal2:=0
    }

    RowNumber := A_EventInfo
    Gui, 2:Destroy
    Gosub, winOption
    Gosub, updatewinoption
  }



Return

;-------------optionen---------------

winOption:
  Gui, 1:Submit, NoHide
  Gui, 2:Submit, NoHide
  Gui, 2:+Owner1
  Gui, 2:Add, MonthCal ,y30 w200 vMyDate ,

  Gui, 2:Add, DateTime,w80  vMyTime ,Time
  Gui, 2:Add, text,  yp+5 xp+90 gnowh, hh:
  Gui, 2:Add, text,  yp+0 xp+16 gnowm, mm:
  Gui, 2:Add, text,  yp+0 xp+19 HWNDTestTT gvoid, ss
  Gui, 2:Add, text,  yp+0 xp+21 vttnow HWNDhO1 gnow,<+>
  AddToolTip(hO1,hO1TT)

  Gui, 2:Add, text,  x10 w200 vOptGuiTxt27,%OptGuiTxt27%  ;kurzer Kommentar-short comment
  Gui, 2:Add, Edit, yp+15 R1 x10  w200 vComment


  Gui, 2:Add, Button,yp+50  w70 vAddTime gAddTime,%OptGuiTxt8%                    ;Add-Hinzufügen
  Gui, 2:Add, Button, xp+80 w60 gChangeTime vChangeTime,%OptGuiTxt4%            ;Change-Ändern
  Gui, 2:Add, Button, xp+65 w60 gDelTime vDelTime,%OptGuiTxt5%                  ;Delete-Löschen
  Gui, 2:Add, Button, x10 w70 yp+40 grefresh vnextTimer,%OptGuiTxt6%                ;Refresh List-Aktualisieren
  Gui, 2:Add, text,   xp+80 R2 w200 vOptGuiTxt29,%OptGuiTxt29%

  Gui, 2:Add, Checkbox, x240 y30 w150 ggetopted   vEveryDay,  %OptGuiTxt7%        ;every Day-täglich
  Gui, 2:Add, Checkbox, x240 yp+24 w150 ggetoption vMondays,   %OptGuiTxt9%       ;mondays-Montags
  Gui, 2:Add, Checkbox, x240 yp+24 w150 ggetoption vTuesdays,  %OptGuiTxt10%     ;tuesdays-Dienstags
  Gui, 2:Add, Checkbox, x240 yp+24 w150 ggetoption vWednesdays, %OptGuiTxt11% ;Wednesdays-Mittwochs
  Gui, 2:Add, Checkbox, x240 yp+24 w150 ggetoption vThursdays, %OptGuiTxt12%   ;Thursdays-Donnerstags
  Gui, 2:Add, Checkbox, x240 yp+24 w150 ggetoption vFridays,   %OptGuiTxt13%       ;Fridays-Freitags
  Gui, 2:Add, Checkbox, x240 yp+24 w150 ggetoption vSaturdays, %OptGuiTxt14%   ;Saturdays-Samstags
  Gui, 2:Add, Checkbox, x240 yp+24 w150 ggetoption vSundays,   %OptGuiTxt15%       ;Sundays-Sonntags
  Gui, 2:Add, Checkbox, x240 yp+24 w150 ggetoptwd vWeekdays,  %OptGuiTxt16% ;all Weekdays-Wochentags
  Gui, 2:Add, Checkbox, x240 yp+24 w150 ggetoptwe vWeekend,   %OptGuiTxt17%  ;only Weekend-Wochenende
  Gui, 2:Add, Checkbox, x240 yp+30 w180 ggetoptSD vShutdown, %OptGuiTxt32%
  Gui, 2:Add, GroupBox, x220 y10 h260 w200 vOptGuiTxt25, %OptGuiTxt25% ; Returning times-wiederkehrende Zeiten
  Gui, 2:Add, GroupBox, x5 y10 h260 w210 vOptGuiTxt28, %OptGuiTxt28% ;


  Gui, 2:Add, GroupBox, x5  h180 w420 vOptGuiTxt36, %OptGuiTxt36%
  Gui, 2:Add, Checkbox, x10 w200 yp+20 ggetoptRP vRunPrg, %OptGuiTxt36%

  Gui, 2:Add, Edit, yp+25 R2 x10  w410 vRunProg
  Gui, 2:Add, DateTime,yp+50  x10 w80 gmytime2 vMyTime1 ,Time
  Gui, 2:Add, text, xp+82 HWNDhO3 gdelValue1,< >
  AddToolTip(hO3,hO3TT)
  Gui, 2:Add, text, yp+0  xp+18 w310  vOptGuiTxt33, %OptGuiTxt33%

  Gui, 2:Add, DateTime,yp+25  x10 w80 gmytime2 vMyTime2 ,Time
  Gui, 2:Add, text, xp+82 HWNDhO4 gdelValue2,< >
  AddToolTip(hO4,hO3TT)
  Gui, 2:Add, text, yp+0 xp+18  w310  vOptGuiTxt34, %OptGuiTxt34% `n%OptGuiTxt35%
  Gui, 2:Add, text, yp+12 xp-19  vTTaddnow HWNDhO2 gaddnow,<+>   ;
  AddToolTip(hO2,hO2TT)
  Gui, 2:Add, Checkbox,yp+20 x10 w410 gimtest vimmortal1, %OptGuiTxt37%

  ;	TTControls=TTaddnow,TTnow
  ;  StringSplit ctr, TTControls, `,,%a_space%
  Gui, 2:show, x%p2x% y%p2y%, %programmfenster2%



Return

imtest:
  Gui, Submit, NoHide
  ;if (!immortal1)
  ;msgbox, immortal1%immortal1%
Return
addnow:
  GuiControl, 2:,MyTime2, %a_now%
Return

delValue1:
  Gui, Submit, NoHide
  leer:=SubStr(MyTime1,1,8) . "000000"
  Repeat=000000
  Repeatuntil=000000
  GuiControl, 2:,MyTime2, %leer%
  GuiControl, 2:,MyTime1, %leer%
Return

delValue2:
  Gui, Submit, NoHide
  leer:=SubStr(MyTime2,1,8) . "000000"
  Repeatuntil=000000
  GuiControl, 2:,MyTime2, %leer%
Return

mytime2:
  Repeat:=SubStr(MyTime1,9,6)
  Repeatuntil:= SubStr(MyTime2,9,6)
Return



updateLang:
  Gui, Submit, NoHide
  ;  WinActivate, %programmfenster1%
  ;  Gui,Default
  ;---this is up to yours ----------------------
  ; Hier müssen die eigenen Controls aktualisiert werden

  GuiControl, 2:,OptGuiTxt27,%OptGuiTxt27%  ;kurzer Kommentar-short comment
  GuiControl, 2:,AddTime,%OptGuiTxt8%          ;Add-Hinzufügen
  GuiControl, 2:,ChangeTime,%OptGuiTxt4%         ;Change-Ändern
  GuiControl, 2:,DelTime,%OptGuiTxt5%              ;Delete-Löschen
  GuiControl, 2:,nextTimer,%OptGuiTxt6%           ;Refresh List-Aktualisieren
  GuiControl, 2:,OptGuiTxt29,%OptGuiTxt29%
  GuiControl, 2:,EveryDay, %OptGuiTxt7%        ;every Day-täglich
  GuiControl, 2:,Mondays, %OptGuiTxt9%       ;mondays-Montags
  GuiControl, 2:,Tuesdays, %OptGuiTxt10%     ;tuesdays-Dienstags
  GuiControl, 2:,Wednesdays, %OptGuiTxt11% ;Wednesdays-Mittwochs
  GuiControl, 2:,Thursdays, %OptGuiTxt12%   ;Thursdays-Donnerstags
  GuiControl, 2:,Fridays, %OptGuiTxt13%       ;Fridays-Freitags
  GuiControl, 2:,Saturdays, %OptGuiTxt14%   ;Saturdays-Samstags
  GuiControl, 2:,Sundays, %OptGuiTxt15%       ;Sundays-Sonntags
  GuiControl, 2:,Weekdays, %OptGuiTxt16% ;all Weekdays-Wochentags
  GuiControl, 2:,Weekend, %OptGuiTxt17%  ;only Weekend-Wochenende
  GuiControl, 2:,Shutdown, %OptGuiTxt32%
  GuiControl, 2:,OptGuiTxt25, %OptGuiTxt25% ; Returning times-wiederkehrende Zeiten
  GuiControl, 2:,OptGuiTxt28, %OptGuiTxt28% ;
  GuiControl, 2:,OptGuiTxt33, %OptGuiTxt33% ;

  GuiControl, 2:,OptGuiTxt34, %OptGuiTxt34% `n%OptGuiTxt35%
  GuiControl, 2:,OptGuiTxt36, %OptGuiTxt36%
  GuiControl, 2:,RunPrg, %OptGuiTxt36%
  GuiControl, 2:,immortal1, %OptGuiTxt37%
  GuiControl, 54:,CrdTxt1, %CrdTxt1%
  GuiControl, 54:,CrdTxt2, %CrdTxt2%
  GuiControl, 54:,CrdTxt3, %CrdTxt3%
  
  AddToolTip(hO1,hO1TT,1)
  AddToolTip(hO2,hO2TT,1)
  AddToolTip(hO3,hO3TT,1)
  AddToolTip(hO4,hO3TT,1)
  AddToolTip(hTTLV,TTLV,1)
  ;bei menu änderungen muss man sich den alten namen merken
  ;außerdem dürfen alter und neuer name nicht gleich sein

  If (oldMenu1<>traytxt3)
    Menu, MyMenuBar, Rename, %oldMenu1%, %traytxt3%
  oldMenu1=%traytxt3%

  If (oldMenu2<>traytxt5)
    Menu, MyMenuBar, Rename, %oldMenu2%, %traytxt5%
  oldMenu2=%traytxt5%

  If (oldMenu3<>Menutxt1)
    Menu, MyMenuBar, Rename, %oldMenu3%, %Menutxt1%
  oldMenu3=%Menutxt1%

  If (oldtitel1<>MenulanguageTitel)
    Menu,Tray,Rename,%oldtitel1%,%MenulanguageTitel%


  If (oldtitel1<>MenulanguageTitel)
    Menu,MyMenuBar,Rename,%oldtitel1%,%MenulanguageTitel%

  oldtitel1=%MenulanguageTitel%

  If (oldtray2<>traytxt2)
    Menu, Tray, Rename, %oldtray2%, %traytxt2%
  oldtray2=%traytxt2%

  If (oldtray3<>traytxt3)
    Menu, Tray, Rename, %oldtray3%, %traytxt3%
  oldtray3=%traytxt3%

  If (oldtray4<>traytxt4)
    Menu, Tray, Rename, %oldtray4%, %traytxt4%
  oldtray4=%traytxt4%

  If (oldtray5<>traytxt5)
    Menu, Tray, Rename, %oldtray5%, %traytxt5%
  oldtray5=%traytxt5%


  Gosub, showTrayTip

  LV_ModifyCol(1,"100", LV1_tit)
  LV_ModifyCol(2,"100", LV2_tit)
  LV_ModifyCol(3,"80",  LV3_tit)
  LV_ModifyCol(4,"200", LV4_tit)
  LV_ModifyCol(5,"200", LV5_tit)
  LV_ModifyCol(6,"20",  LV6_tit)
  LV_ModifyCol(7,"20",  LV7_tit)
  LV_ModifyCol(11,"100",  LV11_tit)

  IniWrite, %actualLang%, %INIfile%, lang, actualLang
  zeitneu:=NeueZeit(zeit)
  LVFill(zeitneu,0)

Return




updatewinoption:
  Gui, Submit, NoHide
  GuiControl, 2:,MyDate, %date%
  GuiControl, 2:,MyTime, %date%
  GuiControl, 2:,Comment, %comment%
  GuiControl, 2:,Sundays, % SubStr(options,3,1)
  GuiControl, 2:,Mondays, % SubStr(options,4,1)
  GuiControl, 2:,Tuesdays, % SubStr(options,5,1)
  GuiControl, 2:,Wednesdays, % SubStr(options,6,1)
  GuiControl, 2:,Thursdays, % SubStr(options,7,1)
  GuiControl, 2:,Fridays, % SubStr(options,8,1)
  GuiControl, 2:,Saturdays, % SubStr(options,9,1)
  GuiControl, 2:,immortal1, %immortal1%
  GuiControl, 2:,Runprog, %Runprog%
  GuiControl, 2:,Repeat, %Repeat%
  mytime1 := SubStr(a_now,1,8) . Repeat
  mytime2 := SubStr(a_now,1,8) . Repeatuntil
  ;  msgbox, %mytime1% %repeat% `n%mytime2% %repeatuntil%
  GuiControl, 2:,mytime1, %mytime1%
  GuiControl, 2:,mytime2, %mytime2%


  If (SubStr(options,3,7)="1111111")
    GuiControl, 2:,Everyday,1
  Else
    GuiControl, 2:,Everyday,0

  If (SubStr(options,4,5)="11111")
    GuiControl, 2:,weekdays,1
  Else
    GuiControl, 2:,weekdays,0

  If (SubStr(options,3,1) and SubStr(options,9,1))
    GuiControl, 2:,Weekend,1
  Else
    GuiControl, 2:,Weekend,0

  If (SubStr(options,1,2)="10")
  {
    GuiControl, 2:,Shutdown,1
    GuiControl, 2:,RunPrg,0
  }
  Else If (SubStr(options,1,2)="11")
  {
    GuiControl, 2:,Shutdown,0
    GuiControl, 2:,RunPrg,1
  }
Return

now:
  Gui, Submit, NoHide
  GuiControl,2:,MyTime, %a_now%
Return

nowm:
  Gui, Submit, NoHide
  nowplusmin := MyTime
  EnvAdd,nowplusmin, 10, Minutes
  GuiControl,2:,MyTime, %nowplusmin%
Return

nowh:
  Gui, Submit, NoHide
  nowplush := MyTime
  EnvAdd,nowplush, 1, Hours
  GuiControl,2:,MyTime, %nowplush%
Return


getopted:
  Gui, Submit, NoHide
  t1=1
  Gosub,getoption
  t1=0
Return

getoptwe:
  Gui, Submit, NoHide
  t2=1
  Gosub,getoption
  t2=0
Return

getoptwd:
  Gui, Submit, NoHide
  t3=1
  Gosub,getoption
  t3=0
Return

getoptSD:
  Gui, Submit, NoHide
  ;  t4=1
  Gosub,getoption
  ;  t4=0
Return

getoptRP:
  Gui, Submit, NoHide
  ;  t5=1
  Gosub,getoption
  ;  t5=0
Return

gettime:
  Gui, 2:Submit, NoHide
  MT := SubStr(MyTime,-5)
  MD =%MyDate%%MT%
  date := md
  ; MD := StandardTimeToCmosTime(MD)
Return


getoption:
  Gui, Submit, NoHide
  options = %sundays%%mondays%%tuesdays%%Wednesdays%%Thursdays%%fridays%%Saturdays%
  w := SubStr(options,2,5)
  su :=SubStr(options,1,1)
  sa :=SubStr(options,7,1)

  If (everyday and t1)
    options =1111111
  Else If (!everyday and t1)
    options =0000000
  Else If (weekend and t2)
    options =1%w%1
  Else If (!weekend  and t2)
    options =0%w%0
  Else If (weekdays and t3)
    options =%su%11111%sa%
  Else If (!weekdays and t3)
    options =%su%00000%sa%

  If (Shutdown)
    options =10%options%
  Else If (Runprg)
    options =11%options%
  Else
    options =01%options%

  Gosub, gettime

  Gosub,updatewinoption
Return



AddTime:
  Gui, 2:Submit, NoHide
  Gui, 1:Submit, NoHide

  Gosub, gettime
  ;----- WochenTage bestimmen ----------
  ss := SubStr(options,3)          ;die ersten beiden bits auschließen
  s=
  Loop,7
    If (SubStr(ss,a_index,1))
      s .= opt%a_index% . a_Space  ;opt1 -opt7 sind wie alle Übersetzungsvar global

    ;----- WochenTage bestimmen ende ----------
  FormatTime, MDf, %MD% ,dd.MM.yyyy HH:mm

  Gui,1:Default
  rowID := LV_GetCount()+1
  LV_Add("",MDf,"",s,comment,Runprog,MD,options,Repeat,Repeatuntil,RowID )

  RowNumber:=LV_GetCount()
  ; LVX_SetColour(Rownumber, 0xcccccc, 0xaaaaa)

  ;   LV_ModifyCol(6,"text Sort")

  LV_ReadAndSave(timefile)
  Gui,2:Default
Return



ChangeTime:
  Gui, 2:Submit, NoHide
  Gui, 1:Submit, NoHide
  Gui,2:Default
  Gosub, gettime
  immortal=%immortal1%0
  ;----- WochenTage bestimmen ----------
  ss := SubStr(options,3)          ;die ersten beiden bits auschließen
  s=
  Loop,7
    If (SubStr(ss,a_index,1))
      s .= opt%a_index% . a_Space  ;opt1 -opt7 sind wie alle Übersetzungsvar global

    ;----- WochenTage bestimmen ende ----------
  FormatTime, MDf, %MD% ,dd.MM.yyyy HH:mm
  Gui,1:Default
  Loop % LV_GetCount()
  {
    LV_GetText(dummy, A_Index,10)
    If (dummy = RowId){
      rowNumber:=a_index
      ;msgbox, %dummy% %RowId% %rownumber%
    }
  }

  LV_Modify(RowNumber,"",MDF,"",s,comment,Runprog,MD,options,Repeat,Repeatuntil )
  LV_Modify(RowNumber,"Col12",  immortal)

  LV_ReadAndSave(timefile)
  Gui,2:Default
Return

DelTime:
  Gui, Submit, NoHide
  Gui,1:Default
  If (rowNumber > LV_GetCount() or rowNumber ="" )
    rowNumber := LV_GetCount()
  LV_Delete(RowNumber)
  LVX_SetColour(RowNumber, 0xdddddd, 0xbbbbbb) ;backgr,text
  Loop % LV_GetCount()
    LV_Modify(A_Index,"Col10",  a_index)

  LV_ReadAndSave(timefile)
  Gui,2:Default
Return

refresh:
  Gui, Submit, NoHide
  Gui,1:Default
  Sleep, 1000
  LVX_Setup("MyListView")
  ; msgbox,%immortal%
  zeit:=LV_ReadAndSave(timefile)
  zeit:=NeueZeit(zeit)
  LVFill(zeit)

Return
;
; ~LButton::
;    If A_TimeSincePriorHotKey > 250
;         Return
;    DClickT := DllCall("GetDoubleClickTime")
;    WinGet Win0, ID, A           ; ID of active window when lbutton pressed
;    WinGetClass Class, ahk_id %Win0%
;    MouseGetPos X0, Y0,hWnd, Cntrl   ; Store starting mouse position
;    StringTrimRight Cntrl,Cntrl,1 ;Remove instance number
; 	 If ((Win0 = Win) && (A_TimeSincePriorHotKey <= DClickT)  && (A_PriorHotKey = A_ThisHotKey) )
;       GoTo, MinimizeToTray
;    KeyWait LButton              ; Wait until mouse button is released
;    MouseGetPos X, Y             ; Ending mouse position
;    WinGet Win, ID, A            ; ID of active window at lbutton release
;    If (Abs(X-X0)<4 && Abs(Y-Y0)<4 || A_TimeSinceThisHotKey < 150 || Win0<>Win)
;         Return                    ; Nothing to do If mouse not moved, clicked fast or active window changed
;
;   MinimizeToTray:
;   CoordMode, Mouse, Screen
;   MouseGetPos, , , id, Control
;   WinGetTitle, title, ahk_id %id%
;   MouseGetPos, xm, ym, hWnd
;   Mousearea := NCHITTEST(xm, ym, hWnd)
;   If title = %programmfenster1%
;     IfWinActive, %programmfenster1%
;       If (Mousearea = "CAPTION")
;            gosub,hidetimer
;   Return
; Return

;----------Tray-------------------

hidetimer:
  Gui, Submit, NoHide
  WinActivate,%programmfenster1%


  WinHide,%programmfenster1%
  Menu, tray, Disable,%traytxt3%
  Menu, tray, Enable, %traytxt2%
  Menu, Tray, Default,%traytxt2%
Return

showtimer:
  Gui, Submit, NoHide

  Gui, Show,x%px% y%py% w%pWidth% ,%programmfenster1%    ;x%C1X% y%C1Y%
  Menu, tray, Disable, %traytxt2%    ;zeige Programmfenster
  Menu, tray, Enable, %traytxt3%     ;hide timer
  Menu, Tray, Default, %traytxt3%
Return

showTrayTip:
  Gui, Submit, NoHide
  t1 := (timetest1="") ? false : true
  FormattedCMOSStartTime := (FormattedCMOSStartTime ="") ? TrayTip2 : FormattedCMOSStartTime
  FormattedShutdownTime := (FormattedShutdownTime ="") ? TrayTip2 : FormattedShutdownTime
  FormattedProgramStartTime := (FormattedProgramStartTime ="") ? TrayTip2 : FormattedProgramStartTime
  traytxt=
  (
%traytxt1% 
%FormattedCMOSStartTime% PC start
%FormattedShutdownTime% ShutDown
%FormattedProgramStartTime% Prg start
  )
  Menu, Tray, Tip, %traytxt%
Return
;-----------------------------------------------
GuiSize:
  Gui, Submit, NoHide
  pWidth :=a_Guiwidth -20
  Anchor("MyListView", "wh")
Return


2GuiClose:
  WinGetPos, p2X, p2Y, , , %programmfenster2%
  ;  Gosub, refresh
  Gui, 2:Destroy
Return



about:
  Gui, Submit, NoHide
  Gosub,54GuiClose

  titel= Credits:


  Gui, 54: +LastFound +Resize ; +Owner1
  hwnd  := WinExist()

  Gui, 54:Font, w1000 s17
  Gui, 54: +LastFound +Owner1
  Gui, 54: Add, Text,  w300 x30 Center , Kronomium
  Gui, 54:Font, w400 s8 Normal
  
  Gui, 54: Add, Text, vCrdTxt1 s5 w300 x30 , %CrdTxt1% ;Autor:`t`thaichen
  
  Gui, 54: Add, Text, vCrdTxt2 s5 w300 x30 , %CrdTxt2% ;Adresse:`tGermany
  Gui, 54: Add, Text, s5 w300 x30 , WWW:`t`t
  Gui,54: Add, Text, xp+80 yp cBlue gLinks vURL_Link11, http://www.autohotkey.net/~haichen/
  Gui, 54: Add, Text, s5 w300 x30 ,  E-Mail:`t`t
  Gui, 54: Add, Text, xp+80 yp cBlue gLinks vURL_Link12, haihai001@hotmail.com
  Gui, 54: Add, Text, vCrdTxt3 yp+35 x30, %CrdTxt3%

  
  Gui, 54: Add, Text,  hwndht h180,
  Rebar_Add(hwnd, ht, "")
  Gui, 55:Destroy
  Gui 55:+LastFound   -Caption +ToolWindow +Owner54
  h := WinExist()

  Gui,55: Add, Picture, vIcon1 y50 x10  h16 w16 Icon44, shell32.dll
  Gui,55: Add, Text,    vText1 yp x30, Chris - AutoHotkey
  Gui,55: Add, Text, xp+8 yp+25 cBlue gLinks vURL_Link1, www.autoHotkey.com

  Gui,55: Add, Picture, vIcon2 yp+50 x10  h16 w16 Icon44, shell32.dll
  Gui,55: Add, Text,    vText2 yp+0 x30, AGermanUser - Hyperlinks
  Gui,55: Add, Text, xp+8 yp+25 cBlue gLinks vURL_Link2, http://de.autoHotkey.com/forum/post-8568.html#8568

  Gui,55: Add, Picture, vIcon3 yp+50 x10  h16 w16 Icon44, shell32.dll
  Gui,55: Add, Text,    vText3 yp+0 x30, Majkinetor - ReBar, ScriptMerge092
  Gui,55: Add, Text, xp+8 yp+25 cBlue gLinks vURL_Link3, http://www.autoHotkey.com/forum/post-171139.html#171139
  Gui,55: Add, Text, xp yp+25 cBlue gLinks vURL_Link3a, http://www.autoHotkey.com/forum/topic18545.html
  Gui,55: Add, Text, xp yp+25 cBlue gLinks vURL_Link3b, http://www.autoHotkey.net/~haichen/m/ScriptMerge092.ahk

  Gui,55: Add, Picture, vIcon4 yp+50 x10  h16 w16 Icon44, shell32.dll
  Gui,55: Add, Text,    vText4 yp+0 x30, Laszlo, AGU - Credits Gui
  Gui,55: Add, Text, xp+8 yp+25 cBlue gLinks vURL_Link4, http://www.autoHotkey.com/forum/post-40027.html#40027

  Gui,55: Add, Picture, vIcon5 yp+50 x10  h16 w16 Icon44, shell32.dll
  Gui,55: Add, Text,    vText5 yp+0 x30, Titan - Anchor, LVX u.v.a.
  Gui,55: Add, Text, xp+8 yp+25 cBlue gLinks vURL_Link5, http://www.autoHotkey.net/~Titan/#

  Gui,55: Add, Picture, vIcon6 yp+50 x10  h16 w16 Icon44, shell32.dll
  Gui,55: Add, Text,    vText6 yp+0 x30, Superfraggles - dynamic ToolTips
  Gui,55: Add, Text, xp+8 yp+25 cBlue gLinks vURL_Link6, http://www.autoHotkey.com/forum/post-188241.html#188241


  Gui,55: Add, Picture, vIcon7 yp+50 x10  h16 w16 Icon44, shell32.dll
  Gui,55: Add, Text,    vText7 yp+0 x30, Borax - CmosTimer
  Gui,55: Add, Text, xp+8 yp+25 cBlue gLinks vURL_Link7, http://www.boraxsoft.de/

  Gui,55: Add, Picture, vIcon8 yp+50 x10  h16 w16 Icon44, shell32.dll
  Gui,55: Add, Text,    vText8 yp+0 x30, Ladiko - Compile_AHK II
  Gui,55: Add, Text, xp+8 yp+25 cBlue gLinks vURL_Link8, http://www.autoHotkey.com/forum/post-146598.html#146598

  Gui,55: Add, Picture, vIcon9 yp+50 x10  h16 w16 Icon44, shell32.dll
  Gui,55: Add, Text,    vText9 yp+0 x30, Not-logged-in-daonlyfreez - Ini handling
  Gui,55: Add, Text, xp+8 yp+25 cBlue gLinks vURL_Link9, http://www.autoHotkey.com/forum/post-41881.html#41881

  Gui,55: Add, Picture, vIcon10 yp+50 x10  h16 w16 Icon44, shell32.dll
  Gui,55: Add, Text,    vText10 yp+0 x30, Andreone - WM_NCHITTEST
  Gui,55: Add, Text, xp+8 yp+25 cBlue gLinks vURL_Link10, http://www.autoHotkey.com/forum/post-141574.html#141574


  Gui,55: Add, Picture, vIcon14 yp+50 x10  h16 w16 Icon44, shell32.dll
  Gui,55: Add, Text,    vText14 yp+0 x30, HermannDerUser - CMOSTimer
  Gui,55: Add, Text, xp+8 yp+25 cBlue gLinks vURL_Link13, http://de.autohotkey.com/forum/topic1370.html
  Gui,55: Add, Text, xp yp+25 cBlue gLinks vURL_Link14, http://de.autohotkey.com/forum/topic2709.html


  Gui,55: Add, Picture, vIcon11 yp+50 x10  h16 w16 Icon44, shell32.dll
  Gui,55: Add, Picture, vIcon12 yp xp+20  h16 w16 Icon44, shell32.dll
  Gui,55: Add, Picture, vIcon13 yp xp+20  h16 w16 Icon44, shell32.dll
  Gui,55: Add, Text,    vText11 yp xp+30, Dolly
  Gui,55: Add, Picture,         yp xp+50  h16 w16 Icon44, shell32.dll
  Gui,55: Add, Picture,         yp xp+20  h16 w16 Icon44, shell32.dll
  Gui,55: Add, Picture,         yp xp+20  h16 w16 Icon44, shell32.dll

  ;Gui,55: Add, Text,    vText4 yp+30 x10, %TestText%
  Gui,55: Add, Text,    vText12 yp+80 x10, made by haichen
  Gui,55: Add, Text,    vText13 xp yp+20, 2008

  Gui,55: Show,hide   x50 y30 h155 ,%titel%
  Gui,54: Add, Text,      yp+160 x30, (c) 2008
  Gui,54: Add, Picture,  yp+0 x10  h16 w16 Icon44, shell32.dll
  Gui,54: Add, Button,   yp+0  g54GuiClose    x360,OK
  Gui,54: Show,AlwaysOnTop w400 h380,Credit

  Rebar_Add(hwnd, h, "", true)
  credits("Credit",100,70,55)
Return



54GuiClose:
  Gui, Submit, NoHide
  Gui, 55:Destroy
  Gui, 54:Destroy
Return

esc::
GuiEscape:
GuiClose:
  WinGetPos, pX, pY, , , %programmfenster1%
  IniWrite, %pWidth%, %INIfile%, program, pWidth
  IniWrite, %pX%, %INIfile%, program, pX
  IniWrite, %pY%, %INIfile%, program, pY
  IniWrite, %p2X%, %INIfile%, program, p2X
  IniWrite, %p2Y%, %INIfile%, program, p2Y
  ExitApp
Return


;-------------------------------------------
; MOUSEMOVE() {
;    Global ctr0, txt0,ttnow,ttaddnow,hO1TT,hO2TT
;    ToolTip
;     If (A_GuiControl = "ttnow")
;       ToolTip,%hO1TT%
;     Else If (A_GuiControl="ttaddnow")
;       ToolTip,%hO2TT%
; }

; WM_MOUSEMOVE(wParam, lParam, msg, hwnd){
;     global hO1,hO2  ; HWND of the monitored Control
;     global hO1TT,hO2TT ; ToolTip for the monitored Control
;     ToolTip
;     MouseGetPos,MouseX,MouseY,, MouseOveRControl,2
;     If (MouseOveRControl<>"")
;       If (MouseOveRControl=hO1)
;         ToolTip,%hO1TT%
;       Else If (MouseOveRControl=hO2)
;         ToolTip,%hO2TT%
;     Return
;   }


LV_ReadAndSave(timefile){
    Gui,1:Default
    zeit =
    Loop % LV_GetCount()
    {
      dummy1 =
      dummy4 =
      dummy5 =
      dummy7 =
      dummy8 =
      dummy9 =
      dummy10 =
      dummy12 =
      LV_GetText(dummy12, A_Index,12) ;immortal
      LV_GetText(dummy10, A_Index,10) ;rowId
      LV_GetText(dummy9, A_Index,9) ;Repeatuntil
      LV_GetText(dummy8, A_Index,8) ;Repeat
      LV_GetText(dummy7, A_Index,7) ;optionstring
      LV_GetText(dummy4, A_Index,4) ;Kommentar
      LV_GetText(dummy5, A_Index,5) ;Befehl
      LV_GetText(dummy1, A_Index,6) ;Standard datestring
      If (dummy8<>"")
        dummy8 =,%dummy8%
      If (dummy9<>"")
        dummy9 =,%dummy9%
      If (dummy12<>"")
        dummy12 =,%dummy12%
      dummy10 =%dummy10%
      zeitS =%zeitS%%dummy1%# %dummy7% %dummy8% %dummy9% %dummy12%# %dummy4%# %dummy5%`n
      zeit   =%zeit%%dummy1%# %dummy7% %dummy8% %dummy9% %dummy12%# %dummy4%# %dummy5% #%dummy10%`n
    }
    zeit :=RegExReplace(zeit,"\R$") ;Delete last 'n
    zeitS :=RegExReplace(zeitS,"\R$")
    FileDelete,%timefile%
    Loop
    {
      IfNotExist, %timefile%
      {
        FileAppend,%zeitS%,%timefile%
        If Errorlevel = 0
          Break
      }
    }
    Return zeit
  }


NeueZeit(zeit){
    zeit = %zeit%

    zeit :=RegExReplace(zeit,"\R$")
    StringSplit,zeit,zeit,`n,`n`r
    zeitneu =
    Loop, %zeit0%
    {
      dummy := zeit%a_index%
      FoundPos :=RegExMatch(dummy,"([0-9]{14,14})",time)
      FoundPos :=RegExMatch(dummy,"(#\s?([0-1]{9,9})\s?)",opt)
      FoundPos :=RegExMatch(dummy,"(,\s?([0-9]{6,6})\s?)",Repeat)
      FoundPos :=RegExMatch(dummy,"(,\s?([0-9]{6,6})\s?,\s?([0-9]{6,6}))",Repeatuntil)
      FoundPos :=RegExMatch(dummy,"(,\s?([0-1]{1,2})#)",immortals)
      ;  msgbox, opt2=%opt2% repeat2=%repeat2% repeatuntil3=%repeatuntil3% immortals2=%immortals1%|%immortals2%
      testday :=next(time,opt2,Repeat2,Repeatuntil3,immortals2)
      ;msgbox, opt2=%opt2% %testday% %repeat2% %repeatuntil3%
      d:= dummy
      StringReplace,dummy,dummy,%time%,%testday%
      ; msgbox, %d% `n%dummy% `n%time% `n%testday%
      zeitneu .= dummy . "`n"
    }
    zeitneu = %zeitneu%
    zeitneu :=RegExReplace(zeitneu,"\R$")

    OutputDebug, %zeit%  `n`n%zeitneu%
    Return zeitneu
  }


rebootrequired(){
    ReBootRequired := 0
    RegRead, ReBootRequired,  HKEY_CURRENT_USER,Software\VB and VBA Program Settings\CMosTimer\StartUp, ReBootRequired
    RegRead, ReBootTime,  HKEY_CURRENT_USER,Software\VB and VBA Program Settings\CMosTimer\StartUp, ReBootTime

    If (ReBootRequired = 1)
    {
      IfNotExist, cmosreboot.ini
        IniWrite,0,cmosreboot.ini, Section1, isrebooted
      IniRead, isrebooted, cmosreboot.ini, Section1, isrebooted
      If (isrebooted = 1)
      {
        isrebooted := 0
        IniWrite,0,cmosreboot.ini, Section1, isrebooted
        Sleep 120000
        OutputDebug,line%A_LineNumber% Shutdown,9
      }
    }
    Return
  }




LVFill(zeit,nottest=1){
    global LV11_c1,LV11_c2,LV11_c3
    ; LVX_Setup("MyListView")
    OutputDebug, LVFill `n%zeit%`n
    LV_Delete()                      ;ListView leeren
    zeit = %zeit%                    ;Leerzeichen entfernen
    zeit :=RegExReplace(zeit,"\R$")  ;Delete last 'n
    StringSplit,zeit,zeit,`n,`n`r  ;In Zeilen zerlegen
    c=0
    Loop, %zeit0%
    {
      dummy := zeit%a_index%          ;Zeile
      dumm1=
      dumm2=
      dumm3=
      dumm4=
      dummy5=
      c++
      StringSplit,dummy,dummy,#,%a_Space%%a_tab%   ;Zeile zerlegen
      StringSplit,dumm,dummy2,`,,%a_Space%%a_tab%  ;option,Repeat,Repeatuntil
      ;      msgbox,%dumm1%,%dumm2%
      ;----- WochenTage bestimmen ----------
      ss := SubStr(dumm1,3)          ;die ersten beiden bits auschließen
      s=
      Loop,7
        If (SubStr(ss,a_index,1))
          s .= opt%a_index% . a_Space  ;opt1 -opt7 sind wie alle Übersetzungsvar global

        ;----- WochenTage bestimmen ende ----------
      If (dumm2<>"")
      {
        r:=LV11_c1 . " " . SubStr(dumm2,1,2) . ":" . SubStr(dumm2,3,2) . ":" . SubStr(dumm2,5,2)
      }
      If (dumm3<>"")
      {
        r.=" " . LV11_c2 . " " . SubStr(dumm3,1,2) . ":" . SubStr(dumm3,3,2) . ":" . SubStr(dumm3,5,2) . " " . LV11_c3
      }

      FormatTime, dummy1f, %dummy1% ,dd.MM.yyyy HH:mm
      If (dummy5="")
        dummy5 := c
      LV_Add("", dummy1f,"", s, dummy3, dummy4, dummy1, dumm1, dumm2 , dumm3,dummy5,r,dumm4)
    }
    If (!test1)
    {
      LV_ModifyCol(6, 0)
      LV_ModifyCol(7, 0)
      LV_ModifyCol(8, 0) ;Repeat
      LV_ModifyCol(9, 0) ;Repeat until
      LV_ModifyCol(10, 0)
      LV_ModifyCol(12, 0) ;immortal
      LV_ModifyCol(1,"autohdr")
      ;LV_ModifyCol(2,"autohdr")
      LV_ModifyCol(3,"autohdr")
      LV_ModifyCol(4,"autohdr")
      LV_ModifyCol(5,"autohdr")
      LV_ModifyCol(11,"autohdr")

    }

    LV_ModifyCol(6,"text Sort left") ; nach spalte Hidden Sortieren
    statussetzen(nottest)
    Return
  }

statussetzen(nottest)
  {
    ;----- Status bestimmen ----------
    global Status1,Status2,Status3,Runner,CmosTime,FormattedCMOSStartTime
            ,FormattedShutdownTime,FormattedProgramStartTime,PrgID,RunnerID
    loopend1 :=0
    loopend2 :=0
    loopend3 :=0
    timetest1=
    timetest2=
    timetest3=

    Loop % LV_GetCount()
    {
      LV_GetText(dummy, A_Index,7)
      LV_GetText(FormattedDummy, A_Index,1)
      LV_GetText(time, A_Index,6)
      dummy=%dummy%
      dummy:= SubStr(dummy,1,2)

      If (time<a_now)
        LVX_SetColour(A_Index, 0xf1f1f1, 0x999999) ;backgr,text Vergangenheit


      If (dummy = "01") and (time>a_now) and (!loopend1){
        LV_Modify(A_Index,"Col2",  Status1)  ;cmostimer
        LVX_SetColour(A_Index, 0xffe0d0, 0x10aa10) ;backgr,text
        CmosTime:=time
        timetest1:=tdiff(time)
        loopend1 :=1
        FormattedCMOSStartTime =%FormattedDummy%
        Gosub, showTrayTip
      }

      If (dummy = "10") and (time>a_now) and (!loopend2){
        LV_Modify(A_Index,"Col2",  Status2)  ;Shutdown
        LVX_SetColour(A_Index, 0xffe0d0, 0xff0000)
        timetest2:=tdiff(time)
        loopend2 :=1
        FormattedShutdownTime =%FormattedDummy%
        Gosub, showTrayTip
      }

      If (dummy = "11") and (time>a_now) and (!loopend3){
        LV_GetText(Runner, A_Index,5)       ;Run this
        LV_GetText(PrgID, A_Index,10)
        LV_Modify(A_Index,"Col2",  Status3)  ;Run Prg
        LVX_SetColour(A_Index, 0xffe0d0, 0x0000ff)
        timetest3:=tdiff(time)
        loopend3 :=1
        FormattedProgramStartTime =%FormattedDummy%
        Gosub, showTrayTip
      }

      If (loopend1) and (loopend2) and (loopend3)
        Break
    }
    LV_ModifyCol(2,"autohdr")
    LV_ModifyCol(11,"autohdr")
    If (A_ThisLabel <> %updatelang%) and (nottest)
      timersetzen(timetest1,timetest2,timetest3)
    Return
  }


timersetzen(timetest1,timetest2,timetest3)
  {
    global CmosTime,PrgID,RunnerID
    ;static c=1

    MyVar = %timetest1%,%timetest2%,%timetest3%
    Sort MyVar, NR D,
    StringSplit,time,MyVar,`,
    ;msgbox,drin|%time1%|%time2%|%time3%|`n%timetest1%|%timetest2%|%timetest3%|

    t1 := (timetest1="") ? false : true
    t2 := (timetest2="") ? false : true
    t3 := (timetest3="") ? false : true
    testRunbeforeShutdown:= timetest3>timetest2
    testRunbeforenewstart:= timetest3>timetest1
    testRun:=((t2) and (t3) and (timetest3<timetest2) ) or ((timetest3<timetest1) and (t1) and (t3)) or ((!t2 or !t1) and t3)
    testif1:=(t2) and (t3) and (timetest3>timetest2)
    testif2:=(timetest3>timetest1) and (t1) and (t3)
    testif3:=(!t2 or !t1) and t3

    testif4:= timetest2 < timetest1
    OutputDebug,timersetzen%timetest1% %timetest2% %timetest3%
    OutputDebug,%testRun% %t1% %t2% %t3% %testRunbeforeShutdown% %testRunbeforenewstart%  %testif1% %testif2% %testif3%
    OutputDebug,testif4:= timetest2 < timetest1 %testif4%

    If ( (t2) and (t3) and (timetest3>timetest2) ) or ((timetest3>timetest1) and (t1) and (t3)) or ((!t2 or !t1) and t3)
    {
      RunnerID:=PrgID
      OutputDebug, programmstart |%timetest3%|
      SetTimer RunProgram,%timetest3% ;Run once
    }

    If  t1  and !t2
    {
      OutputDebug, keine Shutdownzeit
      Gosub, CMOSTimer
    }
    Else If t2 and !t1
    {
      OutputDebug, nur Shutdownzeit
      SetTimer pcShutdown,%timetest2%
    }
    Else If (timetest2 > timetest1)
    {
      OutputDebug, Shutdown liegt vor startzeit daher beides
      Gosub, CMOSTimer
      SetTimer pcShutdown,%timetest2%
    }
    Else If (timetest2 < timetest1)
    {
      OutputDebug,Shutdown liegt nach startzeit daher nur start
      Gosub, CMOSTimer
    }

    Gosub, showTrayTip
    Return
  }

tdiff(date)
  {
    var1 := a_now
    EnvSub,var1, %date%, Seconds
    diff := var1 * 1000  ;+ 10000
    Return diff ;in -millisekunden ;+ 10 sek
  }



next(date,s,repeat,repeatuntil,immortal)
  {
    global testdays
    offset :=2
    z:=s . SubStr(s,offset+1)
    immortal1:=SubStr(immortal,1,1)
    immortal2:=SubStr(immortal,2,1)
    ;    msgbox,immortal=|%immortal1%|%immortal2%|%immortal%|
    If immortal1
      Repeatuntil=

    If (SubStr(s,offset+A_Wday,1)) ; die woche durchgehen von Wochentag bis zum 1. termin
      date := SubStr(A_Now, 1, 8) . SubStr(date, 9) ;neues datum - alte zeit

    If (Repeat = "000000")
      Repeat=
    If (Repeatuntil = "000000")
      Repeatuntil=

    if(SubStr(s,1,2)="01") or (SubStr(s,1,2)="10")
    {
      Repeat =
      Repeatuntil =
    }


newdate := date
testdays :=true

br := (Repeat<>"")
bru := (Repeatuntil<>"")

;msgbox, %repeatuntil%
If (bru)
{
  ru := SubStr(a_now,1,8) . Repeatuntil
}
;msgbox, |%repeat%| |%br%| |%bru%|
if(testdays)  ;startprog
{
  ;tt:=NowIsTodaybetweenTimes(date,ru)
  ;msgbox, stop1 %date% %ru% %repeat% %bru% %tt%
  If ((bru) and (NowIsTodaybetweenTimes(date,ru))) ;or (bru and immortal2)
  {
    testdays:=false
    newdate :=date
    ;msgbox, stop2
    Loop
    {
      newdate := tadd(newdate,Repeat)
      If (newdate	> a_now)
        Break
    }
    ;msgbox, stop3
  }
  Else If (!bru) and (br) and NowIsTodayAfterDate(date)
  {
    newdate :=date
    makemeimmortal:= !immortal1  ; false macht unsterblich
    ;msgbox, stop4 %makemeimmortal%
    Loop
    {
      lastdatebefore:=newdate ;keine wiederholungen über 0 Uhr
      newdate := tadd(newdate,Repeat)
      NotImmortal:= (SubStr(lastdatebefore,9)-SubStr(newdate,9))  >0 ;true wenn über mitternacht
      NotImmortal:= NotImmortal and makemeimmortal
      ;keine wiederholungen über 0 Uhr hinweg ansonsten läuft er ewig
      If (newdate	> a_now)
      {
        If (NotImmortal) ;keine wiederholungen über 0 Uhr; true nur beim schritt über 0Uhr
          newdate:=lastdatebefore ;keine wiederholungen über 0 Uhr
        Break
      }
    }
  }
  Else If (NowIsTodayBeforeDate(date))
  {
    ;msgbox, stop7
    newdate := date
    testdays:=false
  }
  Else If (bru) and NowIsTodayAfterDate(ru)
  {
    newdate := date
    ;msgbox, stop5
    testdays:=true
  }
  Else If (NowIsTodayAfterDate(date))
  {
    newdate := date
    ;msgbox, 6
    testdays:=true
  }
}


If testdays
{
  Loop,7
  {
    If (SubStr(z,offset+A_Wday+A_index,1)) ; die woche durchgehen von Wochentag bis zum 1. termin
    {
      neuertag := A_Now
      neuertag += A_index,days
      newdate := SubStr(neuertag, 1, 8) . SubStr(date, 9, 14) ;neues datum - alte zeit
      Break
    }
  }

}
;msgbox, |%a_now%| `n|%date%| `n|%newdate%| `ntestdays:%testdays%
Return newdate
}





NowIsTodaybetweenTimes(ddate,ddate2)
  {
    date:=ddate
    date2:=ddate2
    If (StrLen(date) <> 14) or (StrLen(date2) <> 14)
      MsgBox, NowIsTodaybetweenTimes(ddate,ddate2) Error1 in date format: |%date%|  |%date2%|
    Else If (date < a_now) and (date2 > a_now) and (SubStr(date,1,8)=SubStr(a_now,1,8)) and (SubStr(date2,1,8)=SubStr(a_now,1,8))
      Return true
    Else
      Return false
  }

NowIsTodayAfterDate(ddate)
  {
    date:=ddate
    s:=StrLen(date)
    If (StrLen(date) <> 14)
      MsgBox, NowIsTodayAfterDate(ddate) Error2 in date format: |%date%| |%s%| |%ddate%|
    Else If (date < a_now) and (SubStr(date,1,8)=SubStr(a_now,1,8))
      Return true
    Else
      Return false
  }

NowIsTodayBeforeDate(ddate)
  {
    date:=ddate
    s:=StrLen(date)
    If (StrLen(date) <> 14)
      MsgBox NowIsTodayBeforeDate(ddate) Error3 in date format: %date% %s%
    Else If (date > a_now) and (SubStr(date,1,8)=SubStr(a_now,1,8))
      Return true
    Else
      Return false
  }

tadd(date,time)  ;time in hhmmss 240130
  {
    h:=SubStr(time,1,2)
    m:=SubStr(time,3,2)
    s:=SubStr(time,5,2)
    h := (h>24) ? 24 : h
    m := (m>60) ? 60 : m
    s := (s>60) ? 60 : s
    var1 := date
    EnvAdd,var1, %s%, Seconds
    EnvAdd,var1, %m%, Minutes
    EnvAdd,var1, %h%, Hours
    Return var1
  }



AddToolTip(con,text,Modify = 0){
    global
    static TThwnd,GuiHwnd
    If (!TThwnd){
      Gui, +LastFound
      GuiHwnd:=WinExist()
      TThwnd:=CreateTooltipControl(GuiHwnd)
    }
    VarSetCapacity(TInfo,44,0)
    NumPut(44,TInfo)
    NumPut(1|16,TInfo,4)
    NumPut(GuiHwnd,TInfo,8)
    NumPut(con,TInfo,12)
    NumPut(&text,TInfo,36)

    DetectHiddenWindows,on
    If (Modify){
      SendMessage,1036,0,&TInfo,,ahk_id %TThwnd% ;Slider Range 1036?
      SendMessage,1048,0,300,,ahk_id %TThwnd%
    }
    Else
      SendMessage, 1028,0,&TInfo,,ahk_id %TThwnd%
    DetectHiddenWindows,off
    Return
  }



CreateTooltipControl(hwind){

    Ret:=DllCall("CreateWindowEx"
            ,"Uint",0
            ,"Str","TOOLTIPS_CLASS32"
            ,"Str",""
            ,"Uint",0|3
            ,"Uint",0
            ,"Uint",0
            ,"Uint",0
            ,"Uint",0
            ,"Uint",hwind
            ,"Uint",0
            ,"Uint",0
            ,"Uint",0)
    Return Ret
  }



credits(WinTitel,Yend=0,repeat=1,GuiID=1){
    global
    Gui, Submit, NoHide
    test  := WinExist(WinTitel)
    WinGetPos,,,WinW,WinH,%WinTitel%
    WinGet, ActiveControlList, ControlList,%WinTitel%

    ctr=0
    OutputDebug,cred1
    Loop, Parse, ActiveControlList, `n,%a_Space%
    {
      ctr++
      GuiControlGet GC%a_index%Pos, %GuiID%:Pos,%A_LoopField%
      If (GC%a_index%PosY<>"")and(GC%a_index%PosY>0)
        LastPos := GC%a_index%PosY
      If (A_LoopField="autoHotkeyGui1") or (A_LoopField="ReBarWindow321")
        GC%a_index%PosY = 0
      tGC%a_index%PosY := GC%a_index%PosY
    }
    IfWinNotExist ahk_id %test%
      Return
    OutputDebug,cred2
    Loop,%Repeat%
    {
      OutputDebug, %LastPos% -%Yend%
      Loop,% LastPos -Yend
      {
        i=0
        Loop, Parse, ActiveControlList, `n
        {
          i++
          OutputDebug,cred4
          GC%i%PosY--
          PosY:= GC%i%PosY
          GuiControl %GuiID%:Move ,%A_LoopField%, y%PosY%
        }
        ;Sleep 50

        IfWinNotExist ahk_id %test%
          Return
      }
      Sleep 15000

      Loop, %ctr%
        GC%a_index%PosY:= tGC%a_index%PosY
    }

    Gui,%GuiID%:Destroy
    Return
  }



Rebar_Add(hGui, hCtrl, text, break = false) {
    static  ICC_COOL_CLASSES := 0x400, REBARCLASSNAME = "ReBarWindow32"
    static  WS_EX_ToolWindow := 0x80, WS_CHILD := 0x40000000, WS_Visible := 0x10000000,  WS_CLIPSIBLINGS = 0x4000000, WS_CLIPCHILDREN = 0x2000000

    static  RBS_VARHEIGHT=0x200, CCS_NODIVIDER = 0x40, RBS_BANDBorderS=0x400, RB_InsertBAND   = 0x401
    static  RBBIM_CHILD = 0x10, RBBIM_Style = 0x1, RBBIM_TEXT = 0x4, RBBIM_CHILDSIZE = 0x20,RBBIM_SIZE = 0x40
    static  RBBS_Break=1, RBBS_FIXEDBMP=0x20, RBBS_NOVERT=0x10, RBBS_CHILDEDGE=0x4, RBBS_USECHEVRON=0x200, RBBS_FIXEDSIZE=0x2, RBBS_GRIPPERALWAYS = 0x80, RBBS_HIDETITLE = 0x400, RBBS_NOGRIPPER = 0x100, RBBS_TOPALIGN = 0x800
    static  hReBar, init
    ;init := false,
    IfWinNotExist ahk_id %hGui%
    {
      init := false
      hReBar := 0x0
    }


    DetectHiddenWindows, on
    If !init
    {
      init := true
      ;msgbox, drin
      VarSetCapacity(ICCE, 8)
      NumPut(8, ICCE, 0)
      NumPut(ICC_COOL_CLASSES, ICCE, 4)

      If !DllCall("comctl32.dll\InitCommonControlsEx", "uint", &ICCE)
        Return "Err: can't initialise common Controls"


      hRebar := DllCall("CreateWindowEx"
              , "uint", WS_EX_TOOLWINDOW
              , "str",  REBARCLASSNAME
              , "uint", 0
              , "uint", WS_CHILD | WS_VISIBLE | WS_CLIPSIBLINGS |  WS_CLIPCHILDREN | RBS_VARHEIGHT | CCS_NODIVIDER | RBS_BANDBORDERS
              , "uint", 0, "uint", 0, "uint", 0, "uint", 0
              , "uint", hGui
              , "uint", 0
              , "uint", 0
              , "uint", 0, "Uint")
      IfEqual, hRebar, 0, Return "Err: can't create rebar"
    }

    VarSetCapacity( BAND, 80, 0 )
    NumPut(80,BAND, 0)

    fMask  := RBBIM_Style | RBBIM_TEXT | RBBIM_CHILD | RBBIM_CHILDSIZE | RBBIM_SIZE
    fStyle := RBBS_CHILDEDGE | RBBS_GRIPPERALWAYS ; | RBBS_FIXEDSIZE
    fStyle |= Break ? RBBS_Break : 0
    NumPut(fMask,  BAND, 4)
    NumPut(fStyle, BAND, 8)

    If DllCall("IsChild", "uint", hCtrl)
      ControlGetPos, ,,,h, ,ahk_id %hCtrl%
    Else WinGetPos    , ,,,h, ahk_id %hCtrl%
    NumPut(&Text   ,BAND, 20)         ;lpText
    NumPut(hCtrl   ,BAND, 32)         ;hwndChild
    NumPut(80      ,BAND, 36)         ;cyMinChild
    NumPut(h      ,BAND, 40)         ;cyMinChild
    NumPut(100      ,BAND, 44)         ;cx


    SendMessage, RB_InsertBAND, -1, &BAND,, ahk_id %hReBar%
    IfEqual, ErrorLevel, 0, Return "Err: can't create band"
    DetectHiddenWindows,off
    Return
  }



;######## GUI glabels ##########################################################
Links:
Gui,Submit, NoHide
loop, 12
{
	GuiControlGet, URL_Link%a_index%
	IfInString, URL_Link%a_index% , @
	  URL_Link%a_index% := "mailto:" .  URL_Link%a_index%
	If (A_GuiControl="URL_Link" a_index)
    Run,% URL_Link%a_index%        
}
Return
;######## End Of GUI glabels ###################################################

HandleMessage(p_w, p_l, p_m, p_hw)
  {
    global   WM_SETCURSOR, WM_MouseMove,
    static   URL_hover, h_cursor_hand, h_old_cursor, CtrlIsURL, LastCtrl

    If (p_m = WM_SETCURSOR)
    {
      If URL_hover
        Return, true
    }
    Else If (p_m = WM_MouseMove)
    {
      ; Mouse cursor hovers URL text control
      StringLeft, CtrlIsURL, A_GuiControl, 3
      If (CtrlIsURL = "URL")
      {
        If URL_hover=
        {
          Gui, Font, cBlue underline
          GuiControl, Font, %A_GuiControl%
          LastCtrl = %A_GuiControl%

          h_cursor_hand := DllCall("LoadCursor", "uint", 0, "uint", 32649)

          URL_hover := true
        }
        h_old_cursor := DllCall("SetCursor", "uint", h_cursor_hand)
      }
      ; Mouse cursor doesn't hover URL text control
      Else
      {
        If URL_hover
        {
          Gui, Font, norm cBlue
          GuiControl, Font, %LastCtrl%

          DllCall("SetCursor", "uint", h_old_cursor)

          URL_hover=
        }
      }
    }
  }

;==================== START: #Include anchor.ahk :B1AD529B-BF4E-477F-8B9F-3080CAC55AE3
/*

	Function: Anchor
		Defines how controls should be automatically positioned relative to the new dimensions of a GUI when resized.
	
	Parameters:
		cl - a control HWND, associated variable name or ClassNN to operate on
		a - (optional) one or more of the anchors: 'x', 'y', 'w' (width) and 'h' (height),
				optionally followed by a relative factor, e.g. "x h0.5"
		r - (optional) true to redraw controls, recommended for GroupBox and Button types
	
	Examples:
> "xy" ; bounds a control to the bottom-left edge of the window
> "w0.5" ; any change in the width of the window will resize the width of the control on a 2:1 ratio
> "h" ; similar to above but directrly proportional to height
	
	Remarks:
		Anchor must always be called within a GuiSize label where AutoHotkey assigns a real value to A_Gui.
		The only exception is when the second and third parameters are omitted to reset the stored positions for a control.
		For a complete example see anchor-example.ahk.
	
	License:
		- Version 4.56 by Titan <http://www.autohotkey.net/~Titan/#anchor>
		- GNU General Public License 3.0 or higher <http://www.gnu.org/licenses/gpl-3.0.txt>

*/

Anchor(i, a = "", r = false) {
	static c, cs = 12, cx = 255, cl = 0, g, gs = 8, z = 0, k = 0xffff, gx = 1
	If z = 0
		VarSetCapacity(g, gs * 99, 0), VarSetCapacity(c, cs * cx, 0), z := true
	If a =
	{
		StringLeft, gn, i, 2
		If gn contains :
		{
			StringTrimRight, gn, gn, 1
			t = 2
		}
		StringTrimLeft, i, i, t ? t : 3
		If gn is not digit
			gn := gx
	}
	Else gn := A_Gui
	If i is not xdigit
	{
		GuiControlGet, t, Hwnd, %i%
		If ErrorLevel = 0
			i := t
		Else ControlGet, i, Hwnd, , %i%
	}
	gb := (gn - 1) * gs
	Loop, %cx%
		If (NumGet(c, cb := cs * (A_Index - 1)) == i) {
			If a =
			{
				cf = 1
				Break
			}
			Else gx := A_Gui
			d := NumGet(g, gb), gw := A_GuiWidth - (d >> 16 & k), gh := A_GuiHeight - (d & k), as := 1
				, dx := NumGet(c, cb + 4, "Short"), dy := NumGet(c, cb + 6, "Short")
				, dw := NumGet(c, cb + 8, "Short"), dh := NumGet(c, cb + 10, "Short")
			Loop, Parse, a, xywh
				If A_Index > 1
					av := SubStr(a, as, 1), as += 1 + StrLen(A_LoopField)
						, d%av% += (InStr("yh", av) ? gh : gw) * (A_LoopField + 0 ? A_LoopField : 1)
			DllCall("SetWindowPos", "UInt", i, "Int", 0, "Int", dx, "Int", dy, "Int", dw, "Int", dh, "Int", 4)
			If r != 0
				DllCall("RedrawWindow", "UInt", i, "UInt", 0, "UInt", 0, "UInt", 0x0101) ; RDW_UPDATENOW | RDW_INVALIDATE
			Return
		}
	If cf != 1
		cb := cl, cl += cs
	If (!NumGet(g, gb)) {
		Gui, %gn%:+LastFound
		WinGetPos, , , , gh
		VarSetCapacity(pwi, 68, 0), DllCall("GetWindowInfo", "UInt", WinExist(), "UInt", &pwi)
			, NumPut(((bx := NumGet(pwi, 48)) << 16 | by := gh - A_GuiHeight - NumGet(pwi, 52)), g, gb + 4)
			, NumPut(A_GuiWidth << 16 | A_GuiHeight, g, gb)
	}
	Else d := NumGet(g, gb + 4), bx := d >> 16, by := d & k
	ControlGetPos, dx, dy, dw, dh, , ahk_id %i%
	If cf = 1
	{
		Gui, %gn%:+LastFound
		WinGetPos, , , gw, gh
		d := NumGet(g, gb), dw -= gw - bx * 2 - (d >> 16), dh -= gh - by - bx - (d & k)
	}
	NumPut(i, c, cb), NumPut(dx - bx, c, cb + 4, "Short"), NumPut(dy - by, c, cb + 6, "Short")
		, NumPut(dw, c, cb + 8, "Short"), NumPut(dh, c, cb + 10, "Short")
	Return, true
}
;==================== END: #Include anchor.ahk :B1AD529B-BF4E-477F-8B9F-3080CAC55AE3

;==================== START: #Include LVX.ahk :B1AD529B-BF4E-477F-8B9F-3080CAC55AE3
/*
		Title: LVX Library
		
		Row colouring and cell editing functions for ListView controls.
		
		Remarks:
			Cell editing code adapted from Michas <http://www.autohotkey.com/forum/viewtopic.php?t=19929>;
			row colouring by evl <http://www.autohotkey.com/forum/viewtopic.php?t=9266>.
			Many thanks to them for providing the code base of these functions!
		
		License:
			- Version 1.04 by Titan <http://www.autohotkey.net/~Titan/#lvx>
			- zlib License <http://www.autohotkey.net/~Titan/zlib.txt>
*/

/*
		
		Function: LVX_Setup
			Initalization function for the LVX library. Must be called before all other functions.
		
		Parameters:
			name - associated variable name (or Hwnd) of ListView control to setup for colouring and cell editing.
		
*/
LVX_Setup(name) {
	global lvx
	If name is xdigit
		h = %name%
	Else GuiControlGet, h, Hwnd, %name%
	VarSetCapacity(lvx, 4 + 255 * 9, 0)
	NumPut(h + 0, lvx)
	OnMessage(0x4e, "WM_NOTIFY")
	LVX_SetEditHotkeys() ; initialize default hotkeys
}

/*
		
		Function: LVX_CellEdit
			Makes the specified cell editable with an Edit control overlay.
		
		Parameters:
			r - (optional) row number (default: 1)
			c - (optional) column (default: 1)
			set - (optional) true to automatically set the cell to the new user-input value (default: true)
		
		Remarks:
			The Edit control may be slightly larger than its corresponding row,
			depending on the current font setting. 
		
*/
LVX_CellEdit(set = true) {
	global lvx, lvxb
	static i = 1, z = 48, e, h, k = "Enter|Esc|NumpadEnter"
	If i
	{
		Gui, %A_Gui%:Add, Edit, Hwndh ve Hide r1
		;Gui,99:Add, MonthCal , ve
		;gui,99:show,,date
		;Gui, %A_Gui%:Add, DateTime,w80  ve,time
		;make row resize to fit this height.. then back
		h += i := 0
	}
	If r < 1
		r = %A_EventInfo%
	If !LV_GetNext()
		Return
	If !(A_Gui or r)
		Return
	l := NumGet(lvx)
	SendMessage, 4135, , , , ahk_id %l% ; LVM_GETTOPINDEX
	vti = %ErrorLevel%
	VarSetCapacity(xy, 16, 0)
	ControlGetPos, bx, t, , , , ahk_id %l%
	bw = 0
	by = 0
	bpw = 0
	SendMessage, 4136, , , , ahk_id %l% ; LVM_GETCOUNTPERPAGE
	Loop, %ErrorLevel% {
		cr = %A_Index%
		NumPut(cr - 1, xy, 4), NumPut(2, xy) ; LVIR_LABEL
		SendMessage, 4152, vti + cr - 1, &xy, , ahk_id %l% ; LVM_GETSUBITEMRECT
		by := NumGet(xy, 4)
		If (LV_GetNext() - vti == cr)
			Break
	}
	by += t + 1
	cr--
	VarSetCapacity(xy, 16, 0)
	CoordMode, Mouse, Relative
	MouseGetPos, mx
	Loop, % LV_GetCount("Col") {
		cc = %A_Index%
		NumPut(cc - 1, xy, 4), NumPut(2, xy) ; LVIR_LABEL
		SendMessage, 4152, cr, &xy, , ahk_id %l% ; LVM_GETSUBITEMRECT
		bx += bw := NumGet(xy, 8) - NumGet(xy, 0)
		If !bpw
			bpw := NumGet(xy, 0)
		If (mx <= bx)
			Break
	}
	bx -= bw - bpw - 2
	LV_GetText(t, cr + 1, cc)
	GuiControl, , e, %t%
	ControlMove, , bx, by, bw, , ahk_id %h%
	GuiControl, Show, e
	GuiControl, Focus, e
	VarSetCapacity(g, z, 0)
	NumPut(z, g)
	LVX_SetEditHotkeys(~1, h)
	Loop {
		DllCall("GetGUIThreadInfo", "UInt", 0, "Str", g)
		If (lvxb or NumGet(g, 12) != h)
			Break
		Sleep, 100
	}
	GuiControlGet, t, , e
	If (set and lvxb != 2)
		LVX_SetText(t, cr + 1, cc)
	GuiControl, Hide, e
	Return, lvxb == 2 ? "" : t
}

/*
		
		Function: LVX_SetText
			Set the text of a specified cell.
		
		Parameters:
			text - new text content of cell
			row - (optional) row number
			col - (optional) column number
		 
*/
LVX_SetText(text, row = 1, col = 1) {
	global lvx
	l := NumGet(lvx)
	row--
	VarSetCapacity(d, 60, 0)
	SendMessage, 4141, row, &d, , ahk_id %l%  ; LVM_GETITEMTEXT
	NumPut(col - 1, d, 8)
	NumPut(&text, d, 20)
	SendMessage, 4142, row, &d, , ahk_id %l% ; LVM_SETITEMTEXT
}

/*
		
		Function: LVX_SetEditHotkeys
			Change accept/cancel hotkeys in cell editing mode.
		
		Parameters:
			enter - comma seperated list of hotkey names/modifiers that will save
				the current input text and close editing mode
			esc - same as above but will ignore text entry (i.e. to cancel)
		
		Remarks:
			The default hotkeys are Enter and Esc (Escape) respectively,
				and such will be used if either parameter is blank or omitted.
		 
*/
LVX_SetEditHotkeys(enter = "Enter,NumpadEnter", esc = "Esc") {
	global lvx, lvxb
	static h1, h0
	If (enter == ~1) {
		If esc > 0
		{
			lvxb = 0
			Hotkey, IfWinNotActive, ahk_id %esc%
		}
		Loop, Parse, h1, `,
			Hotkey, %A_LoopField%, _lvxb
		Loop, Parse, h0, `,
			Hotkey, %A_LoopField%, _lvxc
		Hotkey, IfWinActive
		Return
	}
	If enter !=
		h1 = %enter%
	If esc !=
		h0 = %esc%
}

_lvxc: ; these labels are for internal use:
lvxb++
_lvxb:
lvxb++
LVX_SetEditHotkeys(~1, -1)
Return

/*
		
		Function: LVX_SetColour
			Set the background and/or text colour of a specific row on a ListView control.
		
		Parameters:
			index - row index (1-based)
			back - (optional) background row colour, must be hex code in RGB format (default: 0xffffff)
			text - (optional) similar to above, except for font colour (default: 0x000000)
		
		Remarks:
			Sorting will not affect coloured rows. 
		 
*/
LVX_SetColour(index, back = 0xffffff, text = 0x000000) {
	global lvx
	a := (index - 1) * 9 + 5
	NumPut(LVX_RevBGR(text) + 0, lvx, a)
	If !back
		back = 0x010101 ; since we can't use null
	NumPut(LVX_RevBGR(back) + 0, lvx, a + 4)
	h := NumGet(lvx)
	WinSet, Redraw, , ahk_id %h%
}

/*
		
		Function: LVX_RevBGR
			Helper function for internal use. Converts RGB to BGR.
		
		Parameters:
			i - BGR hex code
		
*/
LVX_RevBGR(i) {
	Return, (i & 0xff) << 16 | (i & 0xffff) >> 8 << 8 | i >> 16
}

/*
		Function: LVX_Notify
			Handler for WM_NOTIFY events on ListView controls. Do not use this function.
*/
LVX_Notify(wParam, lParam, msg) {
	global lvx
	If (NumGet(lParam + 0) == NumGet(lvx) and NumGet(lParam + 8, 0, "Int") == -12) {
		st := NumGet(lParam + 12)
		If st = 1
			Return, 0x20
		Else If (st == 0x10001) {
			a := NumGet(lParam + 36) * 9 + 9
			If NumGet(lvx, a)
      	NumPut(NumGet(lvx, a - 4), lParam + 48), NumPut(NumGet(lvx, a), lParam + 52)
		}
	}
}

WM_NOTIFY(wParam, lParam, msg, hwnd) {
	; if you have your own WM_NOTIFY function you will need to merge the following three lines:
	global lvx
	If (NumGet(lParam + 0) == NumGet(lvx))
		Return, LVX_Notify(wParam, lParam, msg)
}

;==================== END: #Include LVX.ahk :B1AD529B-BF4E-477F-8B9F-3080CAC55AE3

;==================== START: #Include langHelp.ahk :B1AD529B-BF4E-477F-8B9F-3080CAC55AE3
/*
  Title: Language Helper
  note:
  You only need four functions, one label and a variable
  with the Translations to make your script compatible
  with plenty languages.
  
 Example:
  (start code)
 IniVar=
 (
 [lang]
 actualLang=fr
 possibleLangs=de,en,fr
 
 [de]
 MenulanguageTitel=Sprachauswahl
 testvar  =deutsch
 
 [en]
 MenulanguageTitel=Languages
 testvar =english
 
 [fr]
 MenulanguageTitel=Language
 testvar =francais
 
 )
 ; ---------------------------------------------------------------------
 LangHelp_LoadLanguageVars(IniVar,"updateLang")
 ; ---------------------------------------------------------------------
 
 Gui,Add, text, vtestvar w300, testvar=%testvar%
 Gui,Add, text,
 
 ; ---------------------------------------------------------------------
 Menualt := LangHelp_showLangTrayMenu(possibleLangs, MenulanguageTitel)
 LangHelp_showLangMenu(possibleLangs, MenulanguageTitel)
 LangHelp_showLangRadioMenu(possibleLangs, actualLang)
 ; ---------------------------------------------------------------------
 
 Gui,Show, ,Language - Sprache
 Return
 
 ; --------------------------------------------------------------------- 
 updateLang:
 GuiControl, ,testvar, testvar=%testvar%
 return  
 ; --------------------------------------------------------------------- 
 
 esc::
 GuiEscape:
 GuiClose:
   ExitApp
 Return 
 

 
 (end)
 
 Function: LangHelp_LoadLanguageVars(IniVar,"updatelabel",MyMenuBarName="MyMenu")
 Load Languagevars possibleLangs,actualLang from an ini-like Variable
 Sets a Label where you can update your Controls
  
 Parameters:
 IniVar - Variable like an ini-file
 updatelabel - Label where you update your controls
 MyMenuBarName - If you want to set later a menubar 
 
 Returns:
 nothing
  
  
   
 Remarks: 
 			IniVar must have the above format. 
 			You can easily load inifiles with readfile			
 			updatelabel is a Label where you update your controls
 			
 
 Example:

>  LangHelp_LoadLanguageVars(IniVar,"updatelabel")
>  LangHelp_LoadLanguageVars(IniVar,"updatelabel","MyMenuBar")

 
 Function: LangHelp_showLangRadioMenu(possibleLangs,possibleLangs)
 Make a Bar from Radiobuttons
 
 Parameters:
 possibleLangs - Stringvar like de,en,fr, ...
 actualLang - one of the above: de or en or fr
 
 Remarks: 
       nothing
       
 Example:      
>                       
> LangHelp_showLangRadioMenu(possibleLangs,possibleLangs)
>       
 
 
 Function: LangHelp_showLangMenu(possibleLangs,possibleLangs)
 Make a Languagemenu
 
 Parameters:
 possibleLangs - Stringvar like de,en,fr, ...
 actualLang - one of the above: de or en or fr
 
 Remarks: 
       nothing
       
 Example:      
>                       
> LangHelp_showLangMenu(possibleLangs,possibleLangs)
>          
  
  
 
  Function: LangHelp_showLangTrayMenu(possibleLangs,possibleLangs)
  Make a Languagemenu
 
 Parameters:
 possibleLangs - Stringvar like de,en,fr, ...
 actualLang - one of the above: de or en or fr
 
 Remarks: 
       nothing
       
 Example:      
>                       
> LangHelp_showLangTrayMenu(possibleLangs,possibleLangs)
>   

The other functions  and Labels in LangHelp.ahk are helpercode.
       
 	About: License
 		- Version 0.0.0.1 by haichen
 
*/

LangHelp_LoadLanguageVars(IniVarr,updatelabel,MyMenuBarrName="MyMenu"){
    global 
    inivar :=inivarr
    MyMenuBarName :=MyMenuBarrName
    updateLang =%updatelabel%
    LangHelp_loadVarsFromIniVar(IniVar,"lang")
    LangHelp_loadVarsFromIniVar(IniVar,actualLang)
  }



LangHelp_showLangRadioMenu(possibleLangs, actualLang){
    global	ChkLang1, ChkLang2, ChkLang3, ChkLang4, ChkLang5
    global ChkLang6, ChkLang7, ChkLang8, ChkLang9, ChkLang10

    StringSplit, LangString, possibleLangs, `,%A_Space%%A_Tab%`n`r
    Loop,%LangString0%
    {
      r1 := (LangString%a_index% = actualLang) ? 1 : 0
      r2 := (a_index = 1) ? "+0" : "+20"
      Gui,Add, Radio, vChkLang%a_index% x%r2% yp+0 Checked%r1% gLangHelp_ChangeLanguageByRadio, % LangString%a_index%
    }
    Menualt:=MenulanguageTitel
    Return :=Menualt
  }

LangHelp_ChangeLanguageByRadio:
  Gui, Submit, NoHide
  actualLang :=LangHelp_ChangeLanguageByRadio(possibleLangs)
  LangHelp_loadVarsFromIniVar(IniVar,actualLang)
  Gosub,%updateLang% ;updateLang
Return

LangHelp_ChangeLanguageByRadio(possibleLangs){
    Gui, Submit, NoHide
    StringSplit, LangString, possibleLangs, `,%A_Space%%A_Tab%`n`r
    Loop,%LangString0%
      If (ChkLang%a_index%)
        actualLang := LangString%a_index%
    Return actualLang
  }

LangHelp_showLangMenu(possibleLangs, MenulanguageTitel,adddmenu=""){
	  global 
	  addmenu:= adddmenu
    StringSplit, LangString, possibleLangs, `,%A_Space%%A_Tab%`n`r
    Loop,%LangString0%
    {
      l:= LangString%a_index%
      Menu, LangMenu, Add, &%l%, LangHelp_ChangeLanguageByMenu
    }
  
    if (addmenu ="")
      Menu, %MyMenuBarName%, Add, %MenulanguageTitel%, :LangMenu  ; Attach the two sub-Menus that were created above.
    else
      menu, %addmenu%,Add, %MenulanguageTitel%, :LangMenu
    Menualt:=MenulanguageTitel
  }

LangHelp_showLangTrayMenu(possibleLangs, MenulanguageTitel){
    Gui, Submit, NoHide
    Menu, tray, NoStandard
    StringSplit, LangString, possibleLangs, `,%A_Space%%A_Tab%`n`r
    Loop,%LangString0%
    {
      l:= LangString%a_index%
      Menu, MySubMenu1, add,%l%,LangHelp_ChangeLanguageByMenu
    }
    Menu, tray, add, %MenulanguageTitel%, :MySubMenu1
    Menualt:=MenulanguageTitel
    Return Menualt
  }

LangHelp_ChangeLanguageByMenu:
  Gui, Submit, NoHide
  actualLang :=LangHelp_ChangeLanguageByMenu(possibleLangs)
  LangHelp_loadVarsFromIniVar(IniVar,actualLang)  
  Gosub,%updateLang%
Return 

LangHelp_ChangeLanguageByMenu(possibleLangs){
    Gui, Submit, NoHide
    StringSplit, LangString, possibleLangs, `,%A_Space%%A_Tab%`n`r
    actualLang := LangString%A_ThisMenuItemPos%
		GuiControl, ,ChkLang%A_ThisMenuItemPos%, 1      
    Return, actualLang
  }



LangHelp_loadVarsFromIniVar(iniVar,iniSectionsToLoad)  {
    ; from not-logged-in-daonlyfreez
    ; http://www.autohotkey.com/forum/post-41881.html#41881
    global
    local loadEm
    loadEm = 0
    Counter := 0
    Loop, Parse, iniVar, `n, `r
    {
      ; Scan for section, if the line is a section, get section name,
      ; compare to iniSectionsToLoad, set loadEm flag
      If A_LoopField Contains [
      {
        If A_LoopField Contains ]
        {
          StringMid, anIniSection, A_LoopField, InStr(A_LoopField,"]")-1, StrLen(A_LoopField)-2, L ; Get Section name
          If anIniSection in %iniSectionsToLoad% ; is it in our matchlist?
            loadEm = 1
          Else
            loadEm = 0
          If iniSectionsToLoad = ; is it empty? -> get nothing ;all
            loadEm = 0 ;1
        }
      }
      ; Set key and value of the line to a variable named like the key
      ; and with the value of the key
      If loadEm = 1
      {
        If A_LoopField Contains =
        {
          Counter++
          StringSplit, Fiel, A_LoopField, = ,%A_Space%%A_Tab%`n`r ;after the last comma its from Haichen (ekliger fehler):-)
          field =%field1%=
          StringSplit, Field, A_LoopField, = ,%A_Space%%A_Tab%`n`r ;after the last comma its from Haichen :-)
          %Field1% := Fiel2
        }
      }
    }
    Return Counter
  }
return

LangHelp_NewStartINI(Inifile,INIVarr)
{
	 global
   inivar :=inivarr
 
	 IfNotExist, %INIfile%
	 {
	 	fileappend,%Inivar%,%INIfile%
    LangHelp_loadVarsFromIniVar(IniVar,"lang")
    LangHelp_loadVarsFromIniVar(IniVar,actualLang)
    
    Gui,55:Add, GroupBox, x10  h70 w120 , Language - Sprache
    
    StringSplit, LangString, possibleLangs, `,%A_Space%%A_Tab%`n`r

    Loop,%LangString0%
    {
      r1 := (LangString%a_index% = actualLang) ? 1 : 0
      Gui,55:Add, Radio, vChkLang%a_index% x30 yp+20 Checked%r1% gtest , % LangString%a_index%
    }
    Menualt:=MenulanguageTitel


    Gui,55:Show,   ,Language - Sprache
    
    WinGetPos , X, Y,GW ,GH , Language - Sprache
    GWinH := GH +20
    GBH := GH  -30
    WinMove, Language - Sprache, , , ,GW, GWinH
    GuiControl, 55:Move, button1,   h%GBH%

    } Else{
    FileRead, IniVar, %iniFile%
    LangHelp_loadVarsFromIniVar(IniVar,"lang")
    LangHelp_loadVarsFromIniVar(IniVar,actualLang)
    }
WinWaitClose ,Language - Sprache
return
}

test:
Gui,Submit, NoHide
Loop,%LangString0%
{
  if (ChkLang%a_index%)
      actualLang := LangString%a_index%    
}
IniWrite, %actualLang%, %INIfile%, lang, actualLang
FileRead, IniVar, %iniFile%
LangHelp_loadVarsFromIniVar(IniVar,"lang")
LangHelp_loadVarsFromIniVar(IniVar,actualLang)

Gui, 55:Destroy

return



;==================== END: #Include langHelp.ahk :B1AD529B-BF4E-477F-8B9F-3080CAC55AE3

;==================== START: #Include c:\programme\autoHotkey\myInclude.ahk :B1AD529B-BF4E-477F-8B9F-3080CAC55AE3
MCode(DelSp3) 



DeleteWhiteSpaces(str){
	global DelSp3
	Out := Str, DllCall(&DelSp3, "str", Out)
	return out
}

; MCodeAz(ByRef pDestination, pCodeHexa) {
MCodeAz(ByRef pDestination){   
   Static lMcode
pCodeHexa =
(Join
5589E583EC0C8B45088945FC8B45088945F8C645F6018B45FC0FB6008845F7807DF700751B807DF600740D8B
45F83B450876058D45F8FF088B45F8C60000EB40807DF7207408807DF7097402EB17807DF60075258B45F8C6
00208D45F8FF00C645F601EB148B45F889C20FB645F788028D45F8FF00C645F6008D45FCFF00EB968B4508C9C3
)  
   VarSetCapacity(pDestination, StrLen(pCodeHexa) // 2)
   If (lMcode)
      Return DllCall(&lMcode, "Str", pCodeHexa, "UInt", &pDestination, "cdecl UInt")
   lMcode:="608B7424248B7C242833C9FCAC08C074243C397604245F2C072C30C0E0048AE0AC08C074103C397604245F2C072C3008E0AA41EBD7894C241C61C3"
   Loop % StrLen(lMcode)//2
      NumPut("0x" . SubStr(lMcode,2*A_Index-1,2), lMcode, A_Index-1, "UChar")
   Return DllCall(&lMcode, "Str", pCodeHexa, "UInt", &pDestination, "cdecl UInt")
}


MCode(ByRef code) { ; allocate memory and write Machine Code there
hex =
(Join
5589E583EC0C8B45088945FC8B45088945F8C645F6018B45FC0FB6008845F7807DF700751B807DF600740D8B
45F83B450876058D45F8FF088B45F8C60000EB40807DF7207408807DF7097402EB17807DF60075258B45F8C6
00208D45F8FF00C645F601EB148B45F889C20FB645F788028D45F8FF00C645F6008D45FCFF00EB968B4508C9C3
)  

   VarSetCapacity(code,StrLen(hex)//2)
   Loop % StrLen(hex)//2
      NumPut("0x" . SubStr(hex,2*A_Index-1,2), code, A_Index-1, "Char")
}




NCHITTEST(x, y, hWnd)
{
   SendMessage, 0x84, 0, (x & 0xFFFF) | (y & 0xFFFF) << 16,, ahk_id %hWnd%
   ErrorLevel >= 0 ? RegExMatch("NOWHERE CLIENT CAPTION SYSMENU SIZE MENU HSCROLL VSCROLL MINBUTTON MAXBUTTON LEFT RIGHT TOP TOPLEFT TOPRIGHT BOTTOM BOTTOMLEFT BOTTOMRIGHT BORDER OBJECT CLOSE HELP", "(?:\w+\s+){" . ErrorLevel . "}(?<AREA>\w+\b)", HT) : ErrorLevel = -1 ? HTAREA:="TRANSPARENT" : HTAREA:="ERROR"
   Return   HTAREA
}


;---------------------------------------------------------
;Convert a dynamic local variable to a global variable
; 
; testfunction()
; msgbox,%testfunction_localvar_testglobal% %testglobal%
; Return
; 
; 
; testfunction()
; {
;   testlocal=this was local
;   globalWrapper("testglobal", testlocal) 
;   globalWrapper(A_ThisFunc "_localvar" "_testglobal", testlocal) 	
; }


globalWrapper(NameOfTheGlobalVar, LocalVar)   ;this turns a dynamic local variable into a global variable
{
   global
   %NameOfTheGlobalVar% := LocalVar
}
;-----------------------------------------------------------------


;==================== END: #Include c:\programme\autoHotkey\myInclude.ahk :B1AD529B-BF4E-477F-8B9F-3080CAC55AE3


