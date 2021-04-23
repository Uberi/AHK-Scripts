DATEMOD=20071015
/*
============================================================================
DATE.............................2007-08-23
NAME.............................YOUTUBE_AUDIO.ahk
USE..............................find and download video/music
ADD WGET.........................http://www.gnu.org/software/wget/wget.html              instead of ahk urldownloadtofile
                                 http://users.ugent.be/~bpuype/wget/#download
ADD RECORD ......................http://ldb.tpv.ru/    MIXMP3.exe and mp3enc.dll  record audio to MP3
                                 sndvol32 set record StereoMix on 10 %
MP3DirectCut 2.03 ...............http://www.mpesch3.de/     and also mpglib.dll and lame_enc.dll (F12)   for record ram.. to MP3
.................................http://www-users.york.ac.uk/~raa110/audacity/lame.html  lame_enc.dll    for MP3DirectCut
MIXMP3...........................http://ldb.tpv.ru/
.................................MIXMP3.exe  &  mp3enc.dll  record audio to MP3
SCREAMER CONSOLE ................http://www.screamer-radio.com/download.php
.................................sc.exe 20070222 record r (not used)
WAVMIDMP3........................http://www.autohotkey.net/~skwire/apps/misc/wav.zip
.................................wav.exe plays wav mid mp3
STREAMRIPPER.....................http://streamripper.sourceforge.net/     streamripper.exe  &  tre.dll
.................................records URL internet radio
;------------------------------------------------------------------
ONLINE CONVERT...........http://vconvert.net/
                         http://vixy.net/
MINILYRICS...............http://www.crintsoft.com/index.htm   (shareware)
SMPLAYER ................http://smplayer.sourceforge.net/en/index.php
FLVPLAYER ...............http://keepvid.com/
GOMPLAYER ...............http://www.gomplayer.com/codec/success.html?intCodec=10
KMPLAYER ................http://www.kmplayer.com/forums/index.php
Mediapler Classic........http://www.codecguide.com/download_mega.htm
.........................http://www.youtube.com/v/Hxx2KcPWWZg
.........................http://www.youtube.com/jp.swf?video_id=Hxx2KcPWWZg
REMARKS..................
put wget in subfolder
...wget\wget.exe
;------------------------------------------------------------------
*/






#NoEnv
setworkingdir, %a_scriptdir%

NAMELV      =YOUTUBE_AUDIO
MyPLAYER    =%A_ProgramFiles%\K-Lite Codec Pack\Media Player Classic\mplayerc.exe     ;myplayer or else default player
WGET        ="%A_SCRIPTDIR%\wget\wget.exe"
WGET2       =%A_SCRIPTDIR%\wget\wget.exe
DIRECTCUT   =%A_scriptDir%\MP3DIRECTCUT\mp3directcut.exe
STREAMRIPPER=%A_scriptdir%\streamripper\streamripper.exe


AutoTrim Off
transform,S,chr,32
transform,HK,chr,96
transform,PR,chr,37
transform,SS,chr,47



;--- FOLDERS ----------------
R3C=%A_scriptDir%\_TEXT
ifnotexist,%R3C%
FileCreateDir,%R3C%

RT1=%A_scriptDir%\_TEXT\TEXT1    ;text prov
ifnotexist,%RT1%
FileCreateDir,%RT1%

RT2=%A_scriptDir%\_TEXT\TEXT2    ;text log
ifnotexist,%RT2%
FileCreateDir,%RT2%


R3M=%A_scriptDir%\_MUSIC
ifnotexist,%R3M%
FileCreateDir,%R3M%
R3Ma=_MUSIC

;R3V=C:\_VIDEO
R3V=%A_scriptDir%\_VIDEO
ifnotexist,%R3V%
FileCreateDir,%R3V%
R3Va=_VIDEO      ;for wget


RU4=%A_SCRIPTDIR%\_RECORDING
ifnotexist,%RU4%
FileCreateDir,%RU4%




;---- FILES ----------------
 F71=%RT2%\dogpile_prov.txt
 F72=%RT2%\dogpile_last.txt
 F74=%RT2%\dogpile_log.txt

 F81=%RT2%\youtube_prov.txt
 F82=%RT2%\youtube_last.txt
 F84=%RT2%\youtube_log.txt
;----------------------------

 Gui,1:default
 Gui,1:Color, 000000


WA=%A_screenwidth%
HA=%A_screenheight%
SW  :=(WA*95)/100  ;width    guishow width
SH  :=(HA*90)/100  ;height

TDY :=(SH*96)/100                  ;Y position Textfield below when mplayerc starts
LSW :=(SW-20)         ;ListView width
LSH :=(HA*36)/100     ;ListView height
GSH :=(HA*75)/100     ;Gui height

EH1:=(SH*11.5)/100                  ;H height   from editfield below H2
EW1:=(SW*69  )/100                  ;W                               H2

XR1:=(SW*90  )/100                  ;xpos from right


TY1  :=(GSH-25)        ;Text Y
TY2  :=(GSH-50)        ;Text Y
TY3  :=(GSH-75)        ;Text Y
TY4  :=(GSH-100)       ;Text Y
TY5  :=(GSH-125)       ;Text Y
TY6  :=(GSH-150)       ;Text Y
TY7  :=(GSH-175)       ;Text Y
TY8  :=(GSH-200)       ;Text Y
TY9  :=(GSH-225)       ;Text Y
TY10 :=(GSH-250)       ;Text Y
TY11 :=(GSH-275)       ;Text Y
TY12 :=(GSH-300)       ;Text Y
TY13a:=(GSH-318)       ;Text Y
TY13 :=(GSH-325)       ;Text Y
TY14a:=(GSH-335)       ;Text Y
TY14 :=(GSH-350)       ;Text Y
TY15a:=(GSH-360)       ;Text Y
TY15 :=(GSH-375)       ;Text Y


;---- COLUMN ------------------
T1 :=(SW*9  )/100   ;I
T2 :=(SW*46 )/100   ;name     ;should start fullpath (C4) http://  or c:\
T3 :=(SW*41 )/100   ;dir
T4 :=(SW*0  )/100   ;fullpath

T1A:=T1
T2A:=T1+T2
T3A:=T1+T2+T3
T4A:=T1+T2+T3+T4
;-------------------------------


;----------------------------


LAC1=.mp3`,.wav`,.rm`,.ra`,.ram`,.wma`,.mid
MAX1:=10000
I=0
DetectHiddenText,on
DetectHiddenWindows, on
SetTitleMatchMode,2

menu,S1,Add,&How to use,MH1
menu,S1,Add,&About,MH4
menu,myMenuBar,Add,Help,:S1
gui,menu,MyMenuBar

;---------- this for test  desactivate it ----------------------------------------
;AL5=http://www.midtod.com/audio          ;find here 380 songs from jim reeves
;AL5=http://pcdon.com/jimreeves.html      ;no more
;AL5=http://goldencondor.net/music/Jim`%20Reeves/Jim`%20Reeves-cd`%201/    ;sometimes
AL5=jim reeves
;AL5=http://www.youtube.com/watch?v=ztHcGoSS_vA      ;not integrated use auto
;----------------------------------------------------------------------

Gui,1:Font,S10 cDefault, Verdana
Gui,1:Add, ListView,sort grid backgroundGray cWhite w%LSW% h%LSH% +hscroll altsubmit vA1 gA2,NR/DATE|NAME|DIR|PATH
Gui,1:Font,S8 cDefault, Verdana

Gui,1:Add,Edit,cBlack x100  y%TY12%    w580    h20              vAL,%AL5%        ;search  AL
Gui,1:Add, Button,    x690  y%TY12%   default  w0 h0   gMUSIC1                   ;default search select later

PAGE:=1
Gui,1:Add,Edit,cRed   x700  y%TY12%    w40     h20  vPAGE,%PAGE%

Gui,1:Font, S8 cwhite, Verdana
Gui,1:Add,checkbox,   x750   y%TY12%   vAUTOX gAUTOX2,AUTO
Gui,1:Font, S8 cBlack, Verdana



;---------- radiobox --------------
Gui,1:Font, S8 cwhite, Verdana
Gui, Add, GroupBox,  x100   y%TY14a%  w280  h25  +Center     ,MUSIK2
Gui, Add, Radio,     x10    y%TY13%  vACR checked            ,MUSIK1
Gui, Add, Radio,     x110   y%TY13%             ,ALL
Gui, Add, Radio,     x160   y%TY13%             ,SONG
Gui, Add, Radio,     x300   y%TY13%             ,ARTIST

Gui, Add, Radio,     x400   y%TY13%             ,MUSIK3

Gui, Add, Radio,     x500   y%TY13%             ,YOUTUBE

Gui,1:Add,checkbox,  x600   y%TY13%   vEXACT        ,Exact
GuiControl,1:,Exact,1
Gui,1:Font, S8 cBlack, Verdana
;---------------------------------


Gui,1:Add, Button, x100   y%TY15% w80  h20 gDNLSELMUS     ,DNLSEL_M
Gui,1:Add, Button, x200   y%TY15% w80  h20 gDNLALLMUS     ,DNLALL_M
Gui,1:Add, Button, x400   y%TY15% w80  h20 gDNLALLVID     ,DNLALL_V


ifexist,%directcut%
Gui,1:Add, Button, x500   y%TY15% w80  h20 gRECORD1       ,RECORD1



ifexist,%A_scriptdir%\mixmp3.exe
   {
   Gui,1:Add, Button, x600   y%TY15% w80  h20 gRECORD2       ,RECORD2
   Gui,1:Font, S8 cwhite, Verdana
   Gui,1:Add,Edit,    x700   y%TY15% w90  h20 ReadOnly  vREC
   Gui,1:Font, S8 cBlack, Verdana
   Gui,1:Add, Button, x800   y%TY15% w80  h20 gRECSTOP       ,STOP-REC
   }


Gui,1:Add, Button, x10    y%TY11% w80  h20 gESNIPS        ,ESNIPS
Gui,1:Add, Button, x100   y%TY11% w90  h20 gSKREEMR       ,SKREEMR
;Gui,1:Add, Button, x200   y%TY11% w90  h20 gMUSOTIK       ,MUSOTIK
Gui,1:Add, Button, x200   y%TY11% w90  h20 gALTAVISTA     ,ALTAVISTA
Gui,1:Add, Button, x300   y%TY11% w90  h20 gGOOINDEX      ,GOO_INDX
Gui,1:Add, Button, x400   y%TY11% w90  h20 gGOOURL        ,GOO_URL
Gui,1:Add, Button, x500   y%TY11% w90  h20 gGOOGLE        ,GOOGLE
Gui,1:Add, Button, x600   y%TY11% w90  h20 gDOGPILE       ,DOGPILE
Gui,1:Add, Button, x700   y%TY11% w90  h20 gLYRIC         ,LYRIC
Gui,1:Add, Button, x800   y%TY11% w90  h20 gDOWNLOADING   ,DNLOADING

Gui,1:Add, Button, x300   y%TY10% w90  h20 gWIKI          ,WIKIPEDIA
;Gui,1:Add, Button, x400   y%TY10% w90  h20 gWEIRD         ,WEIRD
Gui,1:Add, Button, x500   y%TY10% w90  h20 gYTBRUN        ,YOUTUBE
Gui,1:Add, Button, x600   y%TY10% w90  h20 gYAHOO         ,YAHOO
Gui,1:Add, Button, x700   y%TY10% w90  h20 gWeather       ,WEATHER



Gui,1:Add,Edit,cWhite x10   y%TY10%    w80     h20    ReadOnly vNRR,             ;Row
Gui,1:Add,Edit,cWhite x100  y%TY10%    w80     h20    ReadOnly vTOT,             ;Row Total I
Gui,1:Add,Edit,cWhite x200  y%TY10%    w80     h20    ReadOnly vWGT,             ;WGET
Gui,1:Add,Edit,cWhite x10   y%TY9%     w%EW1%  h%EH1% ReadOnly vH2,              ;H2



Gui,1:Add,Progress,    x10  y%TY4% w380 h20  vPRBAR cFF7200
Gui,1:Add,Text, cBlack x10  y%TY4% w380  +0x200 +Center +BackgroundTrans vText22,
ifexist,%WGET2%
Gui,1:Add,Button,     x400  y%TY4%    w90     h20    gSKIPDNL        ,SKIP
Gui,1:Add,Button,     x500  y%TY4%    w90     h20    gSTOPDNL        ,STOP
Gui,1:Add,Button,     x600  y%TY4%    w90     h20    gRELOAD         ,RELOAD


Gui,1:Add, Button, x10     y%TY2% w80  h20 gVOLUME        ,VOLUME

ifexist,%Streamripper%
   {
   Gui,1:Add, Button, x100    y%TY2% w80  h20 gSTR1       ,REC1
   Gui,1:Add, Button, x200    y%TY2% w80  h20 gSTR2       ,REC2
   }

Gui,1:Add, Button, x100    y%TY1% w80  h20 gCOUNTRY       ,COUNTRY
Gui,1:Add, Button, x200    y%TY1% w80  h20 gBRAZIL        ,BRASILIA

Gui,1:Add, Button, x10     y%TY1% w80  h20 gYOUTUBE       ,YOUTUBE



;-------- right corner
Gui,1:Add, Button, x%XR1%  y%TY8% w120  h20 gVIDEOFOLDER   ,VIDEO
Gui,1:Add, Button, x%XR1%  y%TY7% w120  h20 gMUSICFOLDER   ,MUSIC
Gui,1:Add, Button, x%XR1%  y%TY6% w120  h20 gVFOLDER       ,V_FOLDER
Gui,1:Add, Button, x%XR1%  y%TY5% w120  h20 gMFOLDER       ,M_FOLDER
Gui,1:Add, Button, x%XR1%  y%TY4% w120  h20 gRECFOLDER     ,R_FOLDER


;-------------------------
LB1:
Gui,submit,nohide

  LV_Delete()
  LV_ModifyCol(1,T1)
  LV_ModifyCol(2,T2)
  LV_ModifyCol(3,T3)
  LV_ModifyCol(4,T4)


GuiControl,1:Text,TOT,%I%           ;show total
GuiControl,1:Text,NRR,%RF%          ;show first position
GuiControl,1:Focus,AL

GuiControl,1:Disable,DNLALL_V
GuiControl,1:Disable,DNLSEL_M
GuiControl,1:Disable,DNLALL_M
GuiControl,1:Disable,RECORD1
GuiControl,1:Disable,RECORD2
GuiControl,1:Disable,STOP-REC


;-----------------------------------------------------------------------------------------
Gui,1:Show, x2 y0 w%SW% h%GSH% ,%NAMELV%
Return
;================================== END GUI SHOW =========================================




;================= AUTO SHOW for Youtube =======================
autoX2:
Gui,1:submit,nohide
if autox = 1
   settimer,DDDD,1500
else
   settimer,DDDD,OFF
return
;===============================================================


;-------------------------- SKIP DOWNLOAD ----------------------------
SKIPDNL:
winclose,ahk_class ConsoleWindowClass
settimer,AAS,OFF
return
;--------------------------- STOP DOWNLOAD  ------------------------------
STOPDNL:
Gui,1:submit,nohide
SDL=1
winclose,ahk_class ConsoleWindowClass
GuiControl,1:Text,WGT,STOP
return
;------------------------------------------------------------------------------------
RELOAD:
winclose,ahk_class ConsoleWindowClass
process,close,%PID2%    ;flv
reload
return
;--------------------------------


WEATHER:
Gui,1:submit,nohide
;http://search.yahoo.com/search?p=weather+in+manila&fr=yfp-t-501&toggle=1&cop=mss&ei=UTF-8&vc=&fp_ip=CH
run,http://search.yahoo.com/search?p=weather+%AL%&fr=yfp-t-501&toggle=1&cop=mss&ei=UTF-8&vc=
return





;======================= RECORD MP3directcut   =======================================
RECORD1:
gui,1:submit,nohide

ifnotexist,%directcut%
{
msgbox,262144,,Download MP3DirectCut and save in subfolder ...MP3DIRECTCUT\mp3directcut.exe`r`nDownload also mpglib.dll and lame_enc.dll (see settings F12)`r`n`r`nhttp://www.mpesch3.de/`r`nhttp://www-users.york.ac.uk/~raa110/audacity/lame.html
return
}

if RF=
  {
msgbox,262144,,Select a row
return
  }

if MUSIC=YES
    {
    C2a=%R3M%\%C2%
    }

if VIDEO=YES
    {
    C2a=%R3V%\%C2%
    }


      SplitPath,C2a, name, dir, ext, name_no_ext, drive
      if ext=mp3
          {
          msgbox, Don't record an mp3 file
          return
          }

      run,%DirectCut% %RU4%\%name_no_ext%.mp3 /rec
      ;run,sndvol32
      sleep,1000
      run,%C2a%
  return
;====================== END RECORD MP3DIRECTCUT ===============================




;======================= RECORD ===================================================
RECORD2:
Gui,1:submit,nohide


if RF=
  {
msgbox,262144,,Select a row
return
  }


   GuiControl,1:Enable,STOP-REC
   ;run,sndvol32
   SplitPath,C2,namex, dir, ext, name_no_ext, drive
   if ext=mp3
      {
      msgbox, Don't record an mp3 file
      return
      }


if MUSIC=YES
    {
    C2a=%R3M%\%C2%
    }

if VIDEO=YES
    {
    C2a=%R3V%\%C2%
    }



   Loop %RU4%,1
      SP1= %A_LoopFileShortPath%         ;shortpath for mixmp3.exe
      SP2=%SP1%\%name_no_ext%.mp3


   GuiControl,1:Text,REC,RECORD
   ;run,%comspec% /c mixmp3 -b 128 %SP2%
   run,%comspec% /c mixmp3 -b 128 %SP2%,,hide
   Process,wait,mixmp3.exe
   PID3 = %ErrorLevel%
   Process,exist,mixmp3.exe
   sleep,1000
   run,%C2a%
return
;--------------------------------------------------------



RecStop:
Gui,1:submit,nohide
process,close,%PID3%
GuiControl,1:Text,REC,STOP
sleep,2000
GuiControl,1:Text,REC,
GuiControl,1:Disable,STOP-REC
return
;=========================  END RECORD ===============================================




;============================== STREAMRIPPER =========================================
STR1:
C21=http://130.166.72.1:8006
ifexist,%Streamripper%
run,%COMSPEC% /K streamripper\streamripper.exe %C21% --xs_padding=5000:5000 -t -d "%RU4%"
return
;=====================================================================================
STR2:
C21=http://collectors.no-ip.org:8000
ifexist,%Streamripper%
run,%COMSPEC% /K streamripper\streamripper.exe %C21% --xs_padding=5000:5000 -t -d "%RU4%"
return
;=====================================================================================






;============================ ALTAVISTA =======================================
ALTAVISTA:
Gui,1:submit,nohide
stringreplace,AL,AL,%S%,+,all
if ACR=1
   {
   run,http://www.altavista.com/audio/results?itag=ody&q=%AL%&maf=mp3&maf=wav&maf=msmedia&maf=realmedia&maf=aiff&maf=other&mad=long
   return
   }

if ACR=6
   {
   run,http://www.altavista.com/video/results?itag=ody&q=%AL%&mvf=mpeg&mvf=avi&mvf=qt&mvf=msmedia&mvf=realmedia&mvf=flash&mvf=other&mvd=long
   return
   }
run,http://www.altavista.com/web/results?itag=ody&q=%AL%&kgs=0&kls=0
return
;=========================================================================




;===================== YOUTUBE ==========================
YTBRUN:
Gui,1:submit,nohide
stringreplace,AL,AL,%S%,+,all
run,http://www.youtube.com/results?search_query=%AL%&search=Search
return





WEIRD:
run,http://www.weirdomusic.com/downloads.htm
return



WIKI:
Gui,1:submit,nohide
;http://en.wikipedia.org/wiki/sa kabukiran    > replace to Sa_Kabukiran

  StringUpper,wikip,AL,T                 ;set Title case
  StringReplace,wikip,wikip,%A_space%,_,All
  ;run,http://en.wikipedia.org/wiki/%wikip%
run,http://wikipedia.org/wiki/%wikip%
return






DOWNLOADING:
;http://www.downloading-music.org/Jim+Reeves.html
Gui,1:submit,nohide
stringreplace,AL,AL,%S%,+,all
run,http://www.downloading-music.org/%AL%.html
return



;========================= YAHOO ==========================
YAHOO:
Gui,1:submit,nohide
stringreplace,AL,AL,%S%,+,all
if ACR=1
   {
   run,http://audio.search.yahoo.com/search/audio;_ylt=A0oGkkCqJA1HxhsBwNZXNyoA?ei=UTF-8&p=%AL%&fr2=tab-web&fr=
   return
   }

if ACR=6
   {
   run,http://video.search.yahoo.com/search/video;_ylt=A0SO5xi_JA1HxO8ALUl0N8gF?ei=UTF-8&p=%AL%&fr=&fr2=tab-aud
   return
   }
run,http://search.yahoo.com/search?p=%AL%
return


;==========================================================



;=======================  MUSIC  ===============================================
MUSICFOLDER:
  Gui,1:submit,nohide
  gosub,clearvar

  MUSIC=YES
  VIDEO=NO

  LV_Delete()
  I:=0
  Loop %R3M%\*.*,,1
     {
      LR=%A_LoopFileLongPath%
      SplitPath,LR,name, dir, ext, name_no_ext, drive
          I++
          FileGetSize,FSize,%LR%
          Filegettime,TM1,%LR%,C
          stringleft,TM1,TM1,12
          LV_Add("",TM1,A_loopfilename,Fsize,A_LoopFileLongPath)
      }

  LV_ModifyCol(1,"integer")

GuiControl,1:Text,TOT,%I%

       LV_Modify(GC,"+Select +Focus")
       ControlSend, SysListView321,{END},%NAMELV%

GuiControl,1:Disable,DNLALL_V
GuiControl,1:Disable,DNLSEL_M
GuiControl,1:Disable,DNLALL_M
return


;----------------------------
MFOLDER:
run,%R3M%
return


RECFOLDER:
run,%RU4%
return














;====================================  VIDEO FOLDER  ==========================================
VIDEOFOLDER:
  Gui,1:submit,nohide
  gosub,clearvar

  VIDEO=YES
  MUSIC=NO

  LV_Delete()
  I:=0
  FSIZE:=0
  Loop %R3V%\*.*,,1
     {
      LR=%A_LoopFileLongPath%
      SplitPath,LR,name, dir, ext, name_no_ext, drive
          I++
          FileGetSize,FSize,%LR%
          Filegettime,TM1,%LR%,C
          stringleft,TM1,TM1,12
          LV_Add("",TM1,A_loopfilename,Fsize,A_LoopFileLongPath)
      }

  LV_ModifyCol(1,"integer")


GuiControl,1:Text,TOT,%I%

       LV_Modify(GC,"+Select +Focus")
       ControlSend, SysListView321,{END},%NAMELV%

GuiControl,1:Disable,DNLALL_V
GuiControl,1:Disable,DNLSEL_M
GuiControl,1:Disable,DNLALL_M
return
;======================================================================================

;----------------------------
VFOLDER:
run,%R3V%
return
;========================================================================================








SKREEMR:
Gui,1:submit,nohide
  if exact=1
      {
      stringreplace,AL,AL,%S%,+,all
      AL=`%22%AL%`%22
      }

run,http://skreemr.com/results.jsp?q=%AL%&l=100
;run,http://skreemr.com/advanced_results.jsp?advanced=true&l=100&song=&artist=%AL%&album=&genre=&bitrate=0&length=00`%3A00`%3A60&button=SkreemR+Search
return



GOOINDEX:
Gui,1: Submit, NoHide
if exact=1
   {
  stringreplace,AL,AL,%S%,`.,all
  AL=`%22%AL%`%22
   }
STRING2=-inurl:(htm|html|php|ringtones|ringtone|polyphone) intitle:"index of" +(wav|mp3|rm|wma)
;STRING2=-inurl:(ringtones|ringtone) intitle:(index of|last modified|parent of) +(wma|mp3|ram|rm|wav|ogg) -free -download -ringtones -ringtone -polyphone
;STRING2=-inurl:(php|asp|txt|pls) +(mp3|wma|ram|rm|wav|ogg) -free -download -downloads -ringtones -ringtone -polyphone -musikshop -lyric -lyrics -prices -lowest
;STRING2= -free -download -downloads -ringtones -ringtone -polyphone -musikshop -lyric -lyrics
stringreplace,STRING2,STRING2,`:,`%3A,all
stringreplace,STRING2,STRING2,`",`%22,all
stringreplace,STRING2,STRING2,`(,`%28,all
stringreplace,STRING2,STRING2,`),`%29,all
stringreplace,STRING2,STRING2,`|,`%7C,all
stringreplace,STRING2,STRING2,`+,`%20,all
stringreplace,AL,AL,`:,`%3A,all
;stringreplace,AL,AL,`",`%22,all
stringreplace,AL,AL,`(,`%28,all
stringreplace,AL,AL,`),`%29,all
stringreplace,AL,AL,`|,`%7C,all
run,http://www.google.ch/search?q=%STRING2% %AL%
return




GOOURL:
Gui,1: Submit, NoHide
if exact=1
   {
  stringreplace,AL,AL,%S%,`.,all
  AL=`%22%AL%`%22
   }
STRING2=allinurl:(%AL%)
;STRING2=allinlinks:(%AL%)
run,http://www.google.ch/search?q=%STRING2%
return




MUSOTIK:
Gui,1:submit,nohide
if exact=1
  stringreplace,AL,AL,%S%,+,all
run,http://www.musotik.com/index.php?artist=%AL%
return


GOOGLE:
Gui,1:submit,nohide
if exact=1
  stringreplace,AL,AL,%S%,.,all
run,http://www.google.com/search?hl=de&q=%AL%&btnG=Google-Suche&meta=
;run,www.google.com
return

DOGPILE:
Gui,1:submit,nohide
if exact=1
  stringreplace,AL,AL,%S%,.,all
run,http://www.dogpile.com/info.dogpl/search/web/%AL%/1/100/1/-/-/-/1/-/-/-/1/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/417/top/-/-/-/1
return


ESNIPS:
Gui,submit,nohide
if exact=1
  AL=`%22%AL%`%22
run,http://www.esnips.com/_t_/%AL%/?tab=1&type=MUSIC_FILES&sort=RELEVANCY&page=1
;run,http://www.esnips.com/_t_/%AL%/?tab=1&type=DOCUMENTS&sort=RELEVANCY&page=1
return
;------------------------------------------------------


;========================= SEARCH FOR LYRIC ==================================================
LYRIC:
gui,1:submit,nohide
stringmid,CCP1,AL,1,7
stringmid,CCP2,AL,1,4
if (CCP1="http://" OR CCP2="www.")
     {
Msgbox,262144,,Should not beginning with http`nType in edit field SRCH a song title or artist
return
     }


if AL=
     {
Msgbox,262144,,Type in edit field SEARCH-NET a song title or artist
return
     }

F12=%RT1%\lirama1.txt
APPX1=http://lirama.net/search?searchobj=name&search=%AL%
URLDownloadToFile,%APPX1%,%F12%

A=<li><a href="/
B="/
C=">
Loop,Read,%F12%
      {
      LR=%A_LoopReadLine%
      IfInString,LR,%A%
         {
      IfInString,LR,%AL%
               {
         StringGetPos,VAR1,LR,%B%
         StringGetPos,VAR2,LR,%C%
         VAR1:=(VAR1+2)
         VAR2:=(VAR2+1)
         VAR3:=(VAR2-VAR1)
         stringmid,NEW,LR,VAR1,VAR3
         GOTO,FOUND1
                }
         }
      }

;TRYsecond for musica popular brasileira
F13=%RT1%\lirama2.txt
StringReplace,NewStr,AL,%S%,-,All
URLDownloadToFile,http://www.beakauffmann.com/%NEWSTR%.html,%F13%
Loop,Read,%F13%
      {
      LR=%A_LoopReadLine%
      IfInString,LR,404
         {
      Goto,TRY3
         }
       }
run,http://www.beakauffmann.com/%NEWSTR%.html
return


TRY3:
if AL=
return
run,http://www.dogpile.com/info.dogpl/search/web/%AL% lyric/1/-/1/-/-/-/1/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/417/top/-/-/-/0
return


FOUND1:
run,http://lirama.net/search?searchobj=name&search=%AL%
return
;========================================== END SEARCH FOR LYRIC ======================================================






COUNTRY:
Gui,1:submit,nohide
C21=http://130.166.72.1:8006
G=%A_scriptdir%\COUNTRY1.PLS
ifNotExist,%G%
 FILEAPPEND, [playlist]`r`nnumberofentries=1`r`nFile1=%C21%`r`nTitle1=`r`nLength1=`r`nVersion=2`r`n,%G%
;run,%myplayer% "%G%"
run,%G%
return



BRAZIL:
Gui,1:submit,nohide
C21=http://collectors.no-ip.org:8000
G=%A_scriptdir%\BRASILIA.PLS
ifNotExist,%G%
 FILEAPPEND, [playlist]`r`nnumberofentries=1`r`nFile1=%C21%`r`nTitle1=`r`nLength1=`r`nVersion=2`r`n,%G%
;run,%myplayer% "%G%"
run,%G%
return








;---------------------- MENU ----------------------------------
MH1:
msgbox,262144,,Select Audio/Video Type in Jim Reeves ENTER`nDownload Audio/Video
return


MH4:
msgbox,262144,,%DATEMOD% AutoHotKey garry`r`nDownload Music and Video
return
;---------------------------------------------------------------


;------------------- VOLUME -------------------------------------
VOLUME:
run,sndvol32
return
;------------------- YOUTUBE ------------------------------------
YOUTUBE:
Gui,1:submit,nohide
stringreplace,AL,AL,%S%,+,all
run,http://www.youtube.com/results?search_query=%AL%&search=Search
return
;----------------------------------------------------------------










;================== DOWNLOAD SELECTED MUSIC  ==========================
DNLSELMUS:
Gui,1:submit,nohide
gosub,clearvar
SUCCES2:=0
        LV_Modify(RF, "+Select +Focus")
        LV_GetText(C1,RF,1)
        LV_GetText(C2,RF,2)
        LV_GetText(C3,RF,3)
        LV_GetText(C4,RF,4)             ;fullpath
        SplitPath,C4,name,dir,ext,name_no_ext,drive

        NOTHING1=%S%                                                     %S%
        GuiControl,1:TEXT,WGT,%NOTHING1%



       ;---------- remove special characters from name C4 --------------------
       new11=
       new12=
       Loop,Parse,name_no_ext
            {
            A:=(Asc(A_LoopField))
            B:=chr(a)
            if (B="_" OR B=" ")     ;allow _space   autotrim,off
            Goto,SKIP19
            if ((a<48 or a>57) AND A<65 OR A>90 AND A<97 OR A>122)
            continue
            SKIP19:
            new11=%new11%%b%
            }
      stringreplace,new11,new11,%S%,_,all
      stringreplace,new11,new11,20,_,all
      new12=%new11%.%ext%
      N54=%R3M%\%NEW12%
      ifexist,%N54%
          N54=%R3M%\%NEW11%_%A_NOW%.%ext%
      SplitPath,N54,nameN54, dir, ext, name_no_ext, drive
      ;-----------------  end nameN54 ------------------------------------------------





     ifexist,%wget2%
        ;-------- test with wget.exe -------------------------------------------------
        {
        SUCCES1=NO
        settimer,AAS,500
        stringreplace,C4,C4,&,`%26,all                 ;replace &  with %26
        setworkingdir, %R3M%
        runwait,%COMSPEC% /K %wget% %C4% --tries=1 --output-document=%nameN54%
        ;runwait,%COMSPEC% /K %wget% %C4% --tries=1 --directory-prefix=%R3Ma%
        setworkingdir, %a_scriptdir%
        settimer,AAS,OFF
        gosub,GOSUBFILECHECK           ;----------------------
        if SUCCES1=YES
            {
            run,%N54%
            return
            }
        return
        }
        ;------------------------------------------------------------------------------



else

         {
         SUCCES1=NO
         SIZE5:=0
         SIZE5:=HttpQueryInfo(C4,5)
         GuiControl,1:,Text22,%SIZE5%
         sleep,1000
         if (SIZE5<10  OR SIZE5="timeout")                ;skip size too small
               {
               GuiControl,1:Text,WGT,BREAK
               return
               }


        GuiControl,1:Text,WGT,RUN
        GuiControl,1:+RANGE0-%SIZE5%,PRBAR       ;CHANGE processbar
        settimer,AAS5,500
        ;stringreplace,C4,C4,&,`%26,all                 ;replace &  with %26
        Splashimage,,M2 x80 y5 CWred   fs10,%nameN54%,DOWNLOAD >>>
        urldownloadtofile,%C4%,%N54%
        Splashimage,off
        settimer,AAS5,OFF
        gosub,GOSUBFILECHECK            ;----------------------
        if SUCCES1=YES
            {
            SUCCES2++
            GuiControl,1:,PRBAR, %SIZE5%
            GuiControl,1:,Text22,FINISHED   100 `%      SIZE=%SIZE5%
            run,%N54%
            return
            }
        return
         }


;==================== END DNL MUSIK SELECTED  =========================================








;#############################  DOWNLOAD MUSIC 2-MUSIC DOWNLOAD #################################################
DNLALLMUS:
Gui,1:submit,nohide


SDL=
if RF<>
RF=%RF%
else
RF:=1

  I2:=0
  if RF>I
  RF:=1
  if RF>1
  I2:=(RF-1)
  Y=0


 Loop % LV_GetCount()
 {
  GuiControl,1:,Text22,
  GuiControl,1:Text,WGT,

        if SDL=1
             {
           RF=
           break
             }

        I2++
        LV_Modify(RF, "+Select +Focus")


        LV_GetText(C1,RF,1)
        LV_GetText(C2,RF,2)
        LV_GetText(C3,RF,3)
        LV_GetText(C4,RF,4)
        SplitPath,C4,name,dir,ext,name_no_ext,drive
        ;GuiControl,1:Text,N54A,%name%
        GuiControl,1:Text,NRR,%RF%
        GuiControl,1:,H2,A=%C1%`nB=%C2%`nC=%C3%`nD=%C4%



       ;---------- remove special characters from name C5 --------------------
       new11=
       new12=
       Loop,Parse,name_no_ext
            {
            A:=(Asc(A_LoopField))
            B:=chr(a)
            if (B="_" OR B=" ")     ;allow _space   autotrim,off
            Goto,SKIP18
            if ((a<48 or a>57) AND A<65 OR A>90 AND A<97 OR A>122)
            continue
            SKIP18:
            new11=%new11%%b%
            }
      stringreplace,new11,new11,%S%,_,all
      stringreplace,new11,new11,20,_,all
      new12=%new11%.%ext%
      N54=%R3M%\%NEW12%
      ifexist,%N54%
          N54=%R3M%\%NEW11%_%A_NOW%.%ext%
      SplitPath,N54,nameN54, dir, ext, name_no_ext, drive

         SIZE5:=HttpQueryInfo(C4,5)
         GuiControl,1:,Text22,%SIZE5%
         sleep,1000
         if (SIZE5<10  OR SIZE5="timeout")                ;skip size too small
               {
               GuiControl,1:Text,WGT,SKIPP
               sleep,1200
               LV_Modify(RF, "-Select +Focus")
               RF:=(RF+1)
               if I2=%I%
                   {
                   settimer,AAS5,OFF
                   LV_Modify(RF, "-Select +Focus")
                   RF=
                   break
                   }
               continue
               }



  ifexist,%wget2%
        {
        ;-------- test with wget.exe ----------------------------------------
        SUCCES1=NO
        settimer,AAS,500
        ;setworkingdir, %R3M%
        stringreplace,C4,C4,&,`%26,all                 ;replace &  with %26
        runwait,%COMSPEC% /C %wget% %C4% --tries=1 --output-document=%R3Ma%\%nameN54%,,hide
        ;runwait,%COMSPEC% /K %wget% %C4% --tries=1 --directory-prefix=%R3Ma%                   ;setworkingdir R3M
        ;setworkingdir, %a_scriptdir%
        settimer,AAS,OFF
        }

 else
        {
        GuiControl,1:+RANGE0-%SIZE5%,PRBAR       ;CHANGE processbar
        settimer,AAS5,250
        URLDownloadToFile,%C4%,%N54%    ;downloads to _MUSIC
        GuiControl,1:,PRBAR, %SIZE5%
        GuiControl,1:,Text22,FINISHED   100 `%      SIZE=%SIZE5%
        settimer,AAS5,OFF
        }



        gosub,gosubfilecheck
        ;=====================


          LV_Modify(RF, "-Select +Focus")
          RF:=(RF+1)

       if SDL=1
          break


        if I2=%I%
              {
            settimer,AAS5,OFF
            LV_Modify(RF, "-Select +Focus")
            RF=
            break
              }
  }


GuiControl,1:Text,WGT,FINISHED
GuiControl,1:,Text22,LOOP FINISHED
goto,MUSICFOLDER
return


;================================= END DOWNLOAD MUSIC ALL =================================================================================





















;###############################################################################
;============== when press ENTER decisions here ================================
;==================  SEARCH FOR MUSIC BEGIN ====================================
MUSIC1:
 Gui,1:Submit, NoHide
 gosub,clearvar






;---------------  CASE-12 ----------------------------------------------
;          opens www.xy search for music

          stringmid,CCP1,AL,1,7
          stringmid,CCP2,AL,1,4
          if (CCP1="http://" OR CCP2="www.")
            goto,TESTAA
;--------------- end case-12 --------------------------------------------




;----------- select decisions here ---------------------------------
/*

;--------------- CASE-1 --------------------------------------------
;   http://www.youtube.com/watch?v=ztHcGoSS_vA      (LEN=42)
;   if so then show 20 RelatedVideo in C3 (name1) then start check for name and size
if AL contains http://www.youtube.com/watch?v=
  {
  stringlen,L5,AL
    if L5=42
       {
       goto,alonevid2            ;only 1 otherwise 20 RelatedVideo
       ;gosub,YOUTUBE1
       ;goto,CHECKVID
       }
   }
;----------------  end case-1 -----------------------------------------
*/




/*
;--------------- CASE-3 ------------------------------------------------
;               if not music selected  goto video
if musicx=0
   GOTO,YOUTUBE1
;---------------- end case-3 -------------------------------------------
*/



;-----------------------------------  ACR=1  DOGPILE -------------------------





if ACR=1
   {
   F71=%RT2%\dogpile_prov.htm
   F72=%RT2%\dogpile_last.txt
   F74=%RT2%\dogpile_log.txt

   Filedelete,%F72%

PAGEX:=0
PAGEX:=((PAGE-1)*20)+1

;ACX=http://www.dogpile.com/dogpile/ws/results/Audio/%AL%/2/0/0/Relevance/zoom=off/qi=1/qk=40/bepersistence=false/_iceUrlFlag=7?_IceUrl=true
ACX=http://www.dogpile.com/dogpile/ws/results/Audio/%AL%/1/0/0/Relevance/wsTermsShown=1/zoom=off/qi=%pagex%/qk=20/bepersistence=false/_iceUrlFlag=7?_IceUrl=true   ;OK
;ACX=http://www.dogpile.com/dogpile/ws/results/Audio/jim`%20reeves/1/281/Other/Relevance/wsTermsShown=1/zoom=off/_iceUrlFlag=7?_IceUrl=true      ;OK
;ACX=http://www.dogpile.com/dogpile/ws/results/Audio/jim`%20reeves/1/0/0/Relevance/zoom=off/_iceUrlFlag=7?_IceUrl=true
;ACX=http://www.dogpile.com/info.dogpl/search/audio/jim reeves/1/100/1/-/1/-/0/1/1/0/_self/-/-/on5`%25253A1188142465172/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/0/-/-/-/-/-/-/-/-/-/-/0/418/top/off/-/0
;ACX=http://www.dogpile.com/info.dogpl/search/audio/jim reeves/1/100/1/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/417/top/-/-/0
urldownloadtofile,%ACX%,%F71%

AXA   =.mp3,.wav,.ram,.mid,.ra,.rm,.wma
AXA2  =mp3,wav,ram,mid,ra,rm,wma
VANAF =rawURL=http
UNTIL =&amp;
Loop,Read,%F71%
      {
      LR=%A_LoopReadLine%
      If LR contains %AXA%
         {
         StringGetPos,VAR1,LR,%VANAF%
         StringGetPos,VAR2,LR,%UNTIL%
         VAR1:=(VAR1+8)
         VAR2:=(VAR2+1)
         VAR3:=(VAR2-VAR1)
         stringmid,NEW,LR,VAR1,VAR3
           stringreplace,NEW,NEW,`%3A,:,all
           stringreplace,NEW,NEW,`%2F,/,all
           ;stringreplace,NEW,NEW,`%2520,%A_space%,all
           stringreplace,NEW,NEW,`%2520,`%20,all
         stringlen,L1,NEW
         stringmid,FA,NEW,11,L1-11
           if FA contains www
               continue
         SplitPath,NEW,name, dir, ext, name_no_ext, drive
           if ext contains %AXA2%
            {
             stringmid,LS3,NEW,1,3
             stringmid,LS7,NEW,1,7

               if LS3=../
                {
                K++
                stringlen,L1,NEW
                L2:=(L1-3)
                stringmid,NEW1,NEW,4,L2
                Fileappend,%NEW1%`r`n,%F72%
                }

               if LS7=http://
                {
                K++
                if DIR contains http://walterweyburn.250free.com
                continue
                Fileappend,%NEW%`r`n,%F72%
               }
            }
         }
      }
;run,%F72%
;exitapp

















/*                      ----------------  before 2007-10-01 ----------------
if ACR=1
   {
   F71=%RT2%\dogpile_prov.htm
   F72=%RT2%\dogpile_last.txt
   F74=%RT2%\dogpile_log.txt

   Filedelete,%F72%
      ;APPX=http://www.dogpile.com/dogpile/ws/results/Audio/'%AL%'/1/485/TopNavigation/Relevance/zoom=off/_iceUrlFlag=7?_IceUrl=true&adv=qphrase%AL%
      APPX=http://www.dogpile.com/dogpile/ws/results/Audio/%AL%/2/0/0/Relevance/zoom=off/qi=1/qk=40/bepersistence=false/_iceUrlFlag=7?_IceUrl=true
      ;APPX=http://www.dogpile.com/dogpile/ws/results/Audio/%AL%/2/0/0/Relevance/zoom=off/qi=1/qk=80/bepersistence=true/_iceUrlFlag=7?_IceUrl=true
      ;APPX=http://www.dogpile.com/dogpile/ws/results/Audio/%AL%/1/281/Other/Relevance/wsTermsShown=1/zoom=off/_iceUrlFlag=7?_IceUrl=true&CollationGroup=1
      ;APPX=http://www.dogpile.com/dogpile/ws/results/Audio/jim`%20reeves/1/417/TopNavigation/Relevance/zoom=off/_iceUrlFlag=7?_IceUrl=true
      ;APPX=http://www.dogpile.com/dogpile/ws/results/Audio/jim`%20reeves/1/417/TopNavigation/Relevance/zoom=off/_iceUrlFlag=7?_IceUrl=true
      ;APPX=http://www.dogpile.com/dogpile/ws/results/Audio/%AL%/1/100/1/-/1/-/0/1/1/0/_self/
      ;APPX=http://www.dogpile.com/dogpile/ws/results/Audio/%AL%/1/417/TopNavigation/Relevance/zoom=off/_iceUrlFlag=7?_IceUrl=true
      ;APPX=http://www.dogpile.com/dogpile/ws/results/Audio/%AL%/1/281/Other/Relevance/wsTermsShown=1/zoom=off/_iceUrlFlag=7?_IceUrl=true
      ;APPX=http://www.dogpile.com/info.dogpl/search/audio/%AL%/1/100/1/-/1/-/0/1/1/0/_self/-/-/on5%25253A1188142465172/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/0/-/-/-/-/-/-/-/-/-/-/0/418/top/moderate/-/0
      ;APPX=http://www.dogpile.com/info.dogpl/search/audio/%AL%/1/100/1/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/417/top/-/-/0
      Splashimage,,M2 x80 y5 CWred   fs10,%AL%,DOWNLOAD >>>
      ;URLDownloadToFile,%APPX%,%F71%
      runwait,%COMSPEC% /K %wget% %APPX% wgettest.txt

      Splashimage, off


LSZ2:
K=0
TM1=%A_NOW%
stringleft,TM1,TM1,12

FileRead,AA,%F71%
Loop Parse,AA,<>="'%S%
{
   ALF=%A_LoopField%
   SplitPath,ALF,name, dir, ext, name_no_ext, drive
   StringRight x, ALF, 4
   StringRight y, ALF, 3
   If (x =".mp3" or x =".wav" or x =".ram" or x =".wma" or x =".mid" or y =".rm" or y =".ra")
   {
   stringmid,LS3,ALF,1,3
   stringmid,LS7,ALF,1,7

      if LS3=../
       {
       K++
       stringlen,L1,ALF
       L2:=(L1-3)
       stringmid,ALF1,ALF,4,L2
       Fileappend,%ALF1%`r`n,%F72%
       ;Fileappend,%TM1%;%NOTHING%;%NOTHING%;%name%;%drive%/%ALF1%;%dir%;%drive%`r`n,%F72%   ;date,,,name,fullpath,dir,drive
       }
   if LS7=http://
       {
       K++
       if DIR contains http://walterweyburn.250free.com
       continue
       Fileappend,%ALF%`r`n,%F72%
       ;Fileappend,%TM1%;%NOTHING%;%NOTHING%;%name%;%ALF%;%dir%;%drive%`r`n,%F72%
       }
    }
}
*/ ----------------------------------- OLD --------------------------------------------------------------





;-------------------------------------
READDOG:
if K>0
  {
  LV_Delete()
  I:=0
        AA=
        FileRead,AA,%F72%
        FileDelete ,%F72%
        Sort,AA,U                ;remove double lines
        FileAppend,%AA%,%F72%


  loop,read,%F72%
    {
    I++
    LR=%A_loopreadline%
    SplitPath,LR,name, dir, ext, name_no_ext, drive
    LV_Add("",I,name,DIR,LR)
    }
  LV_ModifyCol(1,"integer")
  LV_ModifyCol(1, "Sort")


  RF:=1
  LV_Modify(RF, "+Select +Focus")
  GuiControl,1:Text,TOT,%I%

  GuiControl,1:Disable,ALONE_V
  GuiControl,1:Disable,DNLSEL_V
  GuiControl,1:Disable,DNLALL_V
  GuiControl,1:Enable,DNLSEL_M
  GuiControl,1:Enable,DNLALL_M
  return
  }
 msgbox,262144,INFO,No music-files found for %AL%
 return
}

;=====================  END ACR=1 DOGPILE    ==========================================================


; here continue












;-----------------------------------  ACR=2  SKREEMR  -------------------------

if ((ACR="2") OR (ACR="3")  OR (ACR="4"))
   {

    ;   APPX=http://skreemr.com/results.jsp?q=`%22tiny+bubbles`%22&l=100
     F71=%RT2%\skreemr_prov.txt
     F72=%RT2%\skreemr_last.txt
     F74=%RT2%\skreemr_log.txt
         Filedelete,%F72%


  if exact=1
      {
      stringreplace,AL,AL,%S%,+,all
      AL=`%22%AL%`%22
      }


  if ACR=2
      {
      APPX=http://skreemr.com/results.jsp?q=%AL%&l=100
      }


  if ACR=3
     {
     APPX=http://skreemr.com/advanced_results.jsp?advanced=true&l=100&song=%AL%&artist=&album=&genre=&bitrate=0&length=00`%3A00`%3A60&button=SkreemR+Search
     }


  if ACR=4
     {
     APPX=http://skreemr.com/advanced_results.jsp?advanced=true&l=100&song=&artist=%AL%&album=&genre=&bitrate=0&length=00`%3A00`%3A60&button=SkreemR+Search
     }


    Splashimage,,M2 x80 y5 CWred   fs10,%AL%,DOWNLOAD >>>
    URLDownloadToFile,%APPX%,%F71%
    Splashimage, off




;-- thanx   LASZLO ---
K=0
A=http://
Loop,Read,%F71%
{
T=%A_LoopReadLine%
StringReplace t,T,.%A_Space%,`,,All
StringRight r,t,1
IfEqual r,., StringTrimRight t,t,1
Loop Parse,t,`,`'` `"`;?`!=< >()`&
     {
   StringLeft r,A_LoopField,7
   If r=%A%
   fileappend,%A_LoopField%`r`n,%F72%
   K++
     }
}



if K>0
     {
     LAC1a=mp3`,wav`,rm`,ra`,ram`,wma`,mid
     LV_Delete()

        AA=
        FileRead,AA,%F72%
        FileDelete,%F72%
        Sort,AA,U                ;remove double lines
        FileAppend,%AA%,%F72%




  I:=0
  loop,read,%F72%
    {
    LR=%A_loopreadline%
    SplitPath,LR,name, dir, ext, name_no_ext, drive
       if ext contains %LAC1a%
            {
            I++
            LV_Add("",I,name,dir,LR)
            }
    }
  LV_ModifyCol(1,"integer")
  LV_ModifyCol(1, "Sort")


  RF:=1
  LV_Modify(RF, "+Select +Focus")
  GuiControl,1:Text,TOT,%I%

  GuiControl,1:Disable,ALONE_V
  GuiControl,1:Disable,DNLSEL_V
  GuiControl,1:Disable,DNLALL_V
  GuiControl,1:Enable,DNLSEL_M
  GuiControl,1:Enable,DNLALL_M
  return
  }
 msgbox,262144,INFO,No music-files found for %AL%
 return
}







;---------------------------- END ACR-2 SKREEMR --------------------------------------------------------------











;-----------------   http://www.downloading-music.org/pearly+shells.html     ------

if ACR=5
{
     /*
     search for
     "http://www.bellybongo.com/mp3/04-pearly_shells.mp3"
     in
     http://www.downloading-music.org/pearly+shells_p1.html
     http://www.downloading-music.org/pearly+shells_p2.html
     */

     F71=%RT2%\dnload_prov.txt
     F72=%RT2%\dnload_last.txt
     F74=%RT2%\dnload_log.txt
         Filedelete,%F72%


      stringreplace,AL,AL,%S%,+,all
      APPX=http://www.downloading-music.org/%AL%_p%page%.html

       Splashimage,,M2 x80 y5 CWred   fs10,%AL%,DOWNLOAD >>>
       URLDownloadToFile,%APPX%,%F71%
       Splashimage, off


ifexist,%F72%
Filedelete,%F72%

V:=0
FileRead,AA,%F71%
  Loop Parse,AA,"
  {
     ALF=%A_LoopField%
     StringRight x,ALF,4
     StringRight y,ALF,3
     If (x =".mp3" or x =".wav" or x =".ram" or x =".wma" or x =".mid" or y =".rm" or y =".ra")
       {
       stringmid,LS7,ALF,1,7
       if LS7=http://
          {
          V++
          Fileappend,%ALF%`r`n,%F72%
          continue
          }
      }
  }


if V>0
     {
     LAC1a=mp3`,wav`,rm`,ra`,ram`,wma`,mid
     LV_Delete()

     I:=0
     loop,read,%F72%
         {
         LR=%A_loopreadline%
         SplitPath,LR,name, dir, ext, name_no_ext, drive
         if ext contains %LAC1a%
             {
             I++
             LV_Add("",I,name,dir,LR)
             }
         }

    LV_ModifyCol(1,"integer")
    LV_ModifyCol(1, "Sort")

    RF:=1
    LV_Modify(RF, "+Select +Focus")
    GuiControl,1:Text,TOT,%I%
    GuiControl,1:Disable,ALONE_V
    GuiControl,1:Disable,DNLSEL_V
    GuiControl,1:Disable,DNLALL_V
    GuiControl,1:Enable,DNLSEL_M
    GuiControl,1:Enable,DNLALL_M
    return
    }

 msgbox,262144,INFO,No music-files found for %AL%
 return
}




































;=========================== YOUTUBE-1 ========================================================
if ACR=6
{
YOUTUBE1:
Gui,1:submit,nohide
 stringreplace,AL,AL,%S%,+,all
 AL=`%22%AL%`%22

;---------- example when searched for ----------------
;http://www.youtube.com/results?search_type=search_videos&search_query=jim%20reeves&search_sort=relevance&search_category=0&search=Search&v=&page=2


  Filedelete,%RT1%\*.tx_
  FLX=%RT1%\Site_%A_NOW%.tx_

  ifexist,%F82%
      filedelete,%F82%


if AL<>
  {
  if AL not contains youtube
      {
      AL=http://www.youtube.com/results?search_type=search_videos&search_query=%AL%&search_sort=relevance&search_category=0&search=Search&v=&page=%PAGE%
      stringsplit,SSP,AL,`=,
      }
  }

  urldownloadtofile,%AL%,%FLX%




K:=0
A=/watch?v=
Loop,Read, %FLX%
{
T=%A_LoopReadLine%
StringReplace t,T,.%A_Space%,`,,All
StringRight r,t,1
IfEqual r,., StringTrimRight t,t,1
Loop Parse,t,`"
   {
   StringLeft r,A_LoopField,9
   If r=%A%
      {
      stringlen,L3,A_loopfield
      if L3 <10
        continue
      ;1 ---- in same line  search for _hbLink('        ;namex  -----------------------------
      ;<a href="/watch?v=BLITACXW734" rel="nofollow" onclick="_hbLink('IWontForgetYou','VidHorz');">
      StringGetPos,P1,T,_hbLink('
      P1:=P1+10
      stringlen,L2,T
      stringmid,A6,T,P1,L2-P1
      I4=0
      Loop,parse,A6,`
          {
          I4++
          Transform,D2,ASC,%A_LOOPFIELD%
          if D2=39       ;search for '
          GOTO,GG4
          }
      GG4:
      P2:=((P1+I4)-(P1+1))
      StringMid,namex,T,P1,P2
      K++
      ;fileappend,;;%namex%;;;http://www.youtube.com%A_LoopField%`r`n,%F82%     ;name and URL1
      fileappend,%namex%;http://www.youtube.com%A_LoopField%`r`n,%F82%
      }
   }
}


if K>0
     {
     LV_Delete()

        FileRead,AA,%F82%
        FileDelete,%F82%
        Sort,AA,U                ;remove double lines
        FileAppend,%AA%,%F82%

     I:=0
     loop,read,%F82%
       {
       I++
       BX1=
       BX2=
       stringsplit,BX,A_LoopReadLine,`;,
       LV_Add("",I,BX1,BX2,BX2)
       }
     LV_ModifyCol(1,"integer")
     LV_ModifyCol(1, "Sort")


    RF:=1
    LV_Modify(RF, "+Select +Focus")


    LV_GetText(C1,RF,1)
    LV_GetText(C2,RF,2)
    LV_GetText(C3,RF,3)
    LV_GetText(C4,RF,4)
    GuiControl,1:,H2,A=%C1%`nB=%C2%`nC=%C3%`nD=%C4%


   GuiControl,1:Text,TOT,%I%           ;show total
   GuiControl,1:Text,NRR,%RF%          ;show first position
  ;GuiControl,1:Enable,ALONE_V
   GuiControl,1:Enable,DNLSEL_V
   GuiControl,1:Enable,DNLALL_V
   ;GuiControl,1:Enable,CHECK_V
   GuiControl,1:Disable,DNLSEL_M
   GuiControl,1:Disable,DNLALL_M
   return
   }

   else
       {
      msgbox,262144,No video found in Youtube
      return
       }

}

;============================ END YOUTUBE-1 ===================================================









return
;============================= END FROM ACR 1-5 ===============================================================













;============================ YOUTUBE-2 DOWNLOAD ===============================================
ALONEVID2:
ALONE=YES
gosub,clearvar
goto,SKIPALONE

;-------------------
DNLALLVID:
Gui,1:submit,nohide
gosub,clearvar
ALONE=NO
DNLSELVID=NO



SDL=
SEL=
if RF<>
RF=%RF%
else
RF:=1
msgbox,262147,DownLoad ALL,Download starts from Row= %RF%`r`n (Or select another ROW)
ifmsgbox,NO
return
ifmsgbox,Cancel
return


;------------
SKIPALONE:
Gui,1:submit,nohide


SDL=
SEL=



  I2:=0
  if RF>I
  RF:=1
  if RF>1
  I2:=(RF-1)
  LV_Modify(RF, "+Select +Focus")
  Y=0


  Filedelete,%RT1%\*.tx_


  loop
   {
   new1=
   new2=
   name=
   name54=
   size3=
   FLN=

        if SDL=1                   ;STOP DNL BUTTON
                   {
              settimer,AAS4,OFF
              LV_Modify(RF, "-Select +Focus")
              GuiControl,1:Enable,DNLALL
              RF=
              break
                   }

        I2++
        GuiControl,1:Text,NRR,%RF%
        GuiControl,1:Text,WGT,RUN
        LV_Modify(RF, "+Select +Focus")


        C1=
        C2=
        C3=
        C4=
        LV_GetText(C1,RF,1)                    ;
        LV_GetText(C2,RF,2)                    ;
        LV_GetText(C3,RF,3)                    ;
        LV_GetText(C4,RF,4)                    ;
        GuiControl,1:,H2,A=%C1%`nB=%C2%`nC=%C3%`nD=%C4%



        stringmid,C4NN,C4,1,18
        if C4NN=Broadcast_Yourself
           goto,continue2


        ;FLN=%RT1%\alone.tx_

        stringsplit,FF,C3,`=,
        FLN=%RT1%\00%RF%_%FF2%.tx_                ;new text to search for URL-2



            if autox=1
                {
                ALONE=YES
                FLN=%RT1%\alone.tx_
                ;http://www.youtube.com/watch?v=ztHcGoSS_vA
                if CL contains youtube
                     {
                     C4=%CL%
                     Splashimage,,b w600 h30 CWred m9 b fs10 zh0,DOWNLOAD >>> %C4%
                     sleep,3000
                     Splashimage, off
                     }
                else
                  return
                }






        if C4=
           {
           msgbox, Empty nothing selected
           break
           }


        urldownloadtofile,%C4%,%FLN%           ;URL-1




/*
var fullscreenUrl = '/watch_fullscreen?video_id=nECoA-uVGfw&l=229&t=OEgsToPDskIe4kxBJTU2Hhybd8rFTgEU&sk=StKEYI4fjqNQJM9bFTGZNAC&fs=1&title=Jim Reeves - I Love You Because';
*/




        ;-------------- YOUTUBE URL2 & NAME SEARCH ------------------------------------
         ;B=var fs = window.open( "/watch_fullscreen?video_id=              ;Anfang
         B=watch_fullscreen?video_id=                                      ;ANFANG
         CA=&fs=                                                           ;ende
         V=0
         Loop,Read,%FLN%
         {
         LR=%A_LoopReadLine%

           ifinstring,LR,<title>                     ;name
               {
            name=
            Loop Parse,LR,<> ,%A_Space%%A_Tab%
            If (A_Index & 2)
            Name=%A_LOOPFIELD%
                }

           IfInString,LR,%CA%                         ;URL-2
                {
               V++
               StringGetPos,VAR1,LR,%B%
               StringGetPos,VAR2,LR,%CA%
               ;VAR1:=(VAR1+51)
               VAR1:=(VAR1+27)
               VAR2:=(VAR2+1)
               VAR3:=(VAR2-VAR1)
               stringmid,ADRESS,LR,VAR1,VAR3
                }
        }
       stringlen,len,name
       dif:=(len-9)
       stringmid,name,name,11,DIF

       ;CY2=http://www.youtube.com/get_video?video_id=%ADRESS%          ;--####--new download adress URL-2
       ;http://cache.googlevideo.com/get_video?video_id=nECoA-uVGfw&origin=ash-v118.ash.youtube.com     ;new changed

       CY2=http://cache.googlevideo.com/get_video?video_id=%ADRESS%

       GuiControl,1:,Text22,

       ;msgbox,CY2=%CY2%

       ;---------- remove special characters ----------------------



       new2=
       Loop,Parse,NAME
            {
            A:=(Asc(A_LoopField))
            B:=chr(a)
            if (B="_" OR B=" ")     ;allow _space   autotrim,off
            Goto,SKIP9
            if ((a<48 or a>57) AND A<65 OR A>90 AND A<97 OR A>122)
            continue
            SKIP9:
            new1=%new1%%b%
            }
      stringreplace,new1,new1,%S%,_,all
      stringreplace,new1,new1,20,_,all
      new2=%new1%.flv
      F54=%R3V%\%NEW2%
      ifexist,%F54%
          F54=%R3V%\%NEW1%_%A_NOW%.flv
      SplitPath,F54,name54, dir, ext, name_no_ext, drive
      ;GuiControl,1:Text,N54A,%name54%
      ;-------------------------------------------------------------



      ;msgbox,name=%F54%   CY2=%CY2%
      ;return

      ;----------------------------
      SIZE3:=HttpQueryInfo(CY2,5)
      if size3<50000
           {
           GuiControl,1:,Text22,%SIZE3% is TOO SMALL
           sleep,2000
           goto,continue2
           }


      ;------------------- start download  ---------
          if autox=1                      ;show start
             {
             clipboard=
             settimer,DDDD,off

             stringmid,C4NN,name54,1,18
             if C4NN=Broadcast_Yourself
                    {
                    Splashimage,,b w600 h30 CWred m9 b fs10 zh0,DO NOT DOWNLOAD >>> %name54%
                    sleep,2000
                    Splashimage, off
                    break
                    }

             Splashimage,,b w600 h30 CWred m9 b fs10 zh0,DOWNLOAD >>> %name54%
             sleep,2000
             Splashimage, off
             }




    GuiControl,1:+RANGE0-%SIZE3%,PRBAR       ;CHANGE processbar
    settimer,AAS4,250
    URLDownloadToFile,%CY2%,%F54%    ;downloads to _VIDEO
    settimer,AAS4,OFF
        GuiControl,1:Text,WGT,OK
        sleep,1000


          if autox=1
             {
            Splashimage,,b w600 h30  CWlime m9 b fs10 zh0,DOWNLOAD >>> %name54%  FINISHED
            sleep,3000
            Splashimage, off
            settimer,DDDD,1000
             }



    ;------------------------------------------------------------------------
    GuiControl,1:+cFF7200,PRBAR




/*

        settimer,AAS,500
        setworkingdir, %R3V%
        stringreplace,CY2,CY2,&,`%26,all                 ;replace &  with %26
        stringreplace,CY2,CY2,&,%HK%&,all
        runwait,%COMSPEC% /K %wget% %CY2% --tries=1 --output-document=%name54%
        setworkingdir, %a_scriptdir%
        settimer,AAS,OFF
        ;gosub,GOSUBFILECHECK            ;----------------------

*/



        if ALONE=YES
            break


        CONTINUE2:
        GuiControl,1:Text,WGT,OK
        LV_Modify(RF, "-Select +Focus")
        RF:=(RF+1)
          if I2=%I%
              {
            settimer,AAS4,OFF
            LV_Modify(RF, "-Select +Focus")
            RF=
            break
              }



     }
END4:
GuiControl,1:Text,WGT,FINISHED
CL=
C4=
goto,videofolder
return




;============================================== END YOUTUBE DOWNLOAD ==========================================================
























;################## SEARCH NET TEST AA ######################################################
;================== SEARCH NET TEST AA ======================================================
;http://goldencondor.net/music/Jim%20Reeves/Jim%20Reeves-cd%201/      (201-205)
;http://pcdon.com/jimreeves.html
;------------------ test search for music -------
SEARCHNET:
Gui,1:submit,nohide

stringmid,CCP1,AL,1,7
stringmid,CCP2,AL,1,4
stringright,CCP3,AL,1

if (CCP1="http://" OR CCP2="www.")
          goto,TESTAA
msgbox,262144,INFO,Search for music inside an URL`nAdress should begin with www.  or http://
return


;------------
TESTAA:
gosub,clearvar

F21 =%RT1%\_URL1.htm
ifexist,%F21%
  filedelete,%F21%

SplitPath,AL,name, dir, ext, name_no_ext, drive
stringmid,CCP1,AL,1,7
stringmid,CCP2,AL,1,4
stringright,CCP3,AL,1

       Splashimage,,M2 x80 y5 w 500 CWred   fs10,%AL%,DOWNLOAD >>>
       URLDownloadToFile,%AL%,%F21%
       Splashimage, off


SKIP15:
ifnotexist,%F21%
   {
   msgbox,262144,,URL Download was not successfull
   return
   }


CONVERT:
F21a=%RT1%\_converted.txt
Filedelete,%F21a%
transform,ten,chr,10
transform,tre,chr,13
CF=%TRE%%TEN%
loop,read,%F21%
  {
  LR=%A_loopreadline%
  stringreplace,A,LR,%tre%,%CF%,all
  fileappend,%A%`r`n,%F21a%
  }


TESTAB:
F22=%RT1%\_URL2.txt
ifexist,%F22%
  filedelete,%F22%


V=0
Splashimage,,M2 x80 y55 w600 CWWhite   fs10,%AL%,READ >>>
FileRead,AA,%F21a%
;Loop Parse,AA,"<>=
Loop Parse,AA,"<>=`'%S%
{
   ALF=%A_LoopField%
   stringreplace,ALF,ALF,&amp`;,`&,all
   StringRight x,ALF,4
   StringRight y,ALF,3
   If (x =".mp3" or x =".wav" or x =".ram" or x =".wma" or x =".mid" or y =".rm" or y =".ra")
   {
   stringmid,LS1,ALF,1,1
   stringmid,LS3,ALF,1,3
   stringmid,LS7,ALF,1,7
   stringmid,LS9,ALF,1,13



      if LS1=/
       {
       V++
       stringlen,L1,ALF
       L2:=(L1-1)
       stringmid,ALF1,ALF,2,L2
       ;msgbox,CASE=1
       Fileappend,%DRIVE%/%ALF1%`r`n,%F22%
       continue
       }

      if LS3=../
       {
       V++
       stringlen,L1,ALF
       L2:=(L1-3)
       stringmid,ALF1,ALF,4,L2
       ;msgbox,CASE=2
       Fileappend,%DRIVE%/%ALF1%`r`n,%F22%
       continue
       }

   if LS7=http://
       {
       V++
       ;msgbox,CASE=3
       Fileappend,%ALF%`r`n,%F22%
       continue
       }

   if LS9=http%PR%3A%PR%2F%PR%2F
       {
       V++

       stringreplace,ALF,ALF,`%3A,:,all
       stringreplace,ALF,ALF,`%2F,/,all
       stringreplace,ALF,ALF,`%2520,%A_space%,all

       ;stringreplace,ALF,ALF,`%2520,%S%
       ;msgbox,CASE=4
       Fileappend,%ALF%`r`n,%F22%
       continue
       }



   V++
   if ALF contains /
   Fileappend,%DRIVE%/%ALF%`r`n,%F22%
   else
      {
      if CCP3=/
      Fileappend,%AL%%ALF%`r`n,%F22%
      else
      Fileappend,%AL%/%ALF%`r`n,%F22%
      }



   }
}


             if V>0
                {
                ifexist,%F72%
                        filedelete,%F72%

                 TM1=%A_NOW%
                 stringleft,TM1,TM1,12

                  LV_Delete()
                  FileRead,AA,%F22%
                  FileDelete,%F22%
                  Sort,AA,U
                  FileAppend,%AA%,%F22%

                  I:=0
                  loop,read,%F22%
                    {
                    LR=%A_LoopReadLine%
                    if LR=
                    continue
                    I++
                    name=
                    dir=
                    SplitPath,LR,name, dir, ext, name_no_ext, drive
                    ;LV_Add("",I,%NOTHING%,%NOTHING%,NAME,LR)
                    LV_Add("",I,name,dir,LR)
                    ;Fileappend,%TM1%;%NOTHING%;%NOTHING%;%name%;%LR%;%dir%;%drive%`r`n,%F72%   ;date,,,name,fullpath,dir,drive
                    }

                    LV_ModifyCol(1,"integer")
                    ;LV_ModifyCol(2,"integer")
                    LV_ModifyCol(1, "Sort")




                   RF:=1
                   LV_Modify(RF, "+Select +Focus")
                   LV_GetText(C1,RF,1)
                   LV_GetText(C2,RF,2)
                   LV_GetText(C3,RF,3)
                   LV_GetText(C4,RF,4)
                   GuiControl,1:,H2,A=%C1%`nB=%C2%`nC=%C3%`nD=%C4%`nE=%C5%`nF=%C6%`nG=%C7%
                   GuiControl,1:Text,TOT,%I%           ;show total

                   GuiControl,1:Disable,DNLSEL_V
                   GuiControl,1:Disable,DNLALL_V
                   ;GuiControl,1:Disable,CHECK_V
                   GuiControl,1:Enable,DNLSEL_M
                   GuiControl,1:Enable,DNLALL_M

                   Splashimage, off
                   return
                }
Splashimage, off
msgbox, 262144, ,Nothing found,1
return
;########################################################################




































;###########################################################
;----------------------   LISTVIEW A2 ----------------------
A2:
  Gui,1:Submit, NoHide
  Gui,1:ListView,A1
  If A_GuiEvent = Normal
    {
    RN:=LV_GetNext("C")
    RF:=LV_GetNext("F")
    GC:=LV_GetCount()
    C1=
    C2=
    C3=
    C4=
    LV_GetText(C1,A_EventInfo,1)
    LV_GetText(C2,A_EventInfo,2)
    LV_GetText(C3,A_EventInfo,3)
    LV_GetText(C4,A_EventInfo,4)
    GuiControl,1:,H2,A=%C1%`nB=%C2%`nC=%C3%`nD=%C4%`nE=%C5%`nF=%C6%`nG=%C7%
    ;GuiControl,1:Text,TOT,%I%           ;show total
    GuiControl,1:Text,NRR,%RF%
    ;GuiControl,1:Text,Edit3,%RF%


     if RF<>
        {
        if (VIDEO="YES" OR MUSIC="YES")
            {
            GuiControl,1:Enable,RECORD1
            GuiControl,1:Enable,RECORD2
            }
        }

     if RF=
        {
        GuiControl,1:Disable,RECORD1
        GuiControl,1:Disable,RECORD2
        }




    MouseGetPos,x,y
      {
     if x<%T1A%
        {
        LV_GetText(C1,A_EventInfo,1)
        return
        }

     if x<%T2A%                              ;name should run fullpath
        {
        LV_GetText(C2,A_EventInfo,2)
        LV_GetText(C4,A_EventInfo,4)
        ;msgbox,%C4%
        stringmid,C4a,C4,2,1
        if C4a=`:                 ;is it a drive
            {
           ifexist,%C4%
               goto,BLACK
             else
                {
                msgbox,262144,INFO,File %C4% no more exist in this path`nIt's maybe moved or removed
                return
                }
             }
        run,%C4%
        return
        }


     if x<%T3A%                              ;dir should run dir
        {
        LV_GetText(C3,A_EventInfo,3)
        LV_GetText(C4,A_EventInfo,4)
        stringmid,C4a,C4,2,1
        if C4a=`:                 ;is it a drive
            {
           ifexist,%C4%
               goto,BLACK
             else
                {
                msgbox,262144,INFO,File %C4% no more exist in this path`nIt's maybe moved or removed
                return
                }
             }
        if C3<>digit
        run,%C3%
        return
        }


     if x<%T4A%                           ;fullpath not visible
        {
        LV_GetText(C4,A_EventInfo,4)
        return
        }


     }
  }





;================================= LISTVIEW RIGHTCLICK  =================================================
if A_GuiEvent = RightClick
{
LV_GetText(C4,A_EventInfo,4)
if C4 not contains youtube
  {
    MouseGetPos,x,y
      {
     if x<%T1A%
        return

     if x<%T2A%
        return


     if x<%T3A%
          {
          AL=
          LV_GetText(C3,A_EventInfo,3)
          stringmid,CCP1,C3,1,7
          stringmid,CCP2,C3,1,4
          if (CCP1="http://" OR CCP2="www.")
            {
            AL=%C3%
            goto,TESTAA
            }
          else
            {
            msgbox,262144,INFO,Search for music inside an URL`nAdress should begin with www.  or http://
            return
            }
          }

     if x<%T4A%
        return
     }
  }
}








;################ DELETE  LISTVIEW LINES /  FILES in the path _VIDEO ##############
if A_GuiEvent=K
{


;============== LV-UP/DOWN ARROW =============================================

  GetKeyState,state,UP
  if state=D
    {
    RF:=LV_GetNext("F")
    LV_GetText(C1,RF,1)
    LV_GetText(C2,RF,2)
    LV_GetText(C3,RF,3)
    LV_GetText(C4,RF,4)
    GuiControl,1:,H2,A=%C1%`nB=%C2%`nC=%C3%`nD=%C4%
    GuiControl,1:Text,NRR,%RF%
    }

GetKeyState,state,DOWN
  if state=D
    {
    RF:=LV_GetNext("F")
    LV_GetText(C1,RF,1)
    LV_GetText(C2,RF,2)
    LV_GetText(C3,RF,3)
    LV_GetText(C4,RF,4)
    GuiControl,1:,H2,A=%C1%`nB=%C2%`nC=%C3%`nD=%C4%
    GuiControl,1:Text,NRR,%RF%
    }
;============================================================================


GetKeyState,state,DEL
if state=D
  {
    RNB=0
    FILESDELETED:=0
    if (VIDEO="YES" OR MUSIC="YES")
         {
        LV_GetText(CM4,RF,4)
        msgbox, 262195, FILE DELETE, Want you really recycle=`n%CM4%`n  and maybe followed files (if marked ) in`n%R3V%\.... ?
           ifmsgbox,NO
                return
           ifmsgbox,CANCEL
                return
         }




    I:=0
    I7:=0
    Loop
    {
    RNB := LV_GetNext(RNB)
     if RNB=0
        break
    LV_GetText(CN4,RNB,4)
    if (VIDEO="YES" OR MUSIC="YES")
            {
            ifexist,%CN4%
                 {
                 LV_Delete(RNB)                                 ;deletes line in listview
                 FILESDELETED++
                 FileRecycle,%CN4%
                 }
            }
    I7++
    RNB:=(RNB-1)
    }


        if (VIDEO="YES" OR MUSIC="YES")
             {
             FSD:=filesdeleted
             I:=(GC-FSD)
             GuiControl,1:Text,TOT,%I%
             if VIDEO=YES
             msgbox, 262208, FILES DELETED INFO, You have now %Filesdeleted% Files recycled from %R3V%\....
             else
             msgbox, 262208, FILES DELETED INFO, You have now %Filesdeleted% Files recycled from %R3M%\....
             return
             }

  I:=(GC-I7)
  GuiControl,1:Text,TOT,%I%
  }
}

return
;================================ END LISTVIEW KEY =====================================================



















return
;===============================  END   LISTVIEW  ==========================================================








;###############################          BLACK  ###################################
;--------------------------------------------------------------------------------------------------

            BLACK:
            SysGet m, MonitorWorkArea
            Gui,2:-Border
            Gui,2:Color,000000   ;BLACK
            Gui,2:Font,S12 cwhite, Verdana
            Gui,2:Add,Text,center y%TDY% w%SW% cWhite,%C2%
            Gui,2:Show,% "x" mLeft+5 " y" mTop+5 " w" mRight-mLeft-10 " h " mBottom-mTop-10, BLACK
            ifexist,%MyPlayer%
                {
                PA="%C4%" /fixedsize 1000,750
                sleep,1000
                Run,%MyPLAYER% %PA%,,hide,pid
                Process,wait,mplayerc.exe
                PID2 = %ErrorLevel%
                Process,exist,mplayerc.exe
;                      {
;                      sleep,2000
;                      send,^0                 ; remove border from mplayerc
;                      }
                return
                }
            run,%C4%
            return

;-------------------------------------------------------------------------------------------------
;###############################  END  BLACK  ###################################





;-------------- GOSUB WGET.exe -------------------------------------------------
AAS:
Gui,1:submit,nohide
WinGetTitle,TM,ahk_class ConsoleWindowClass
stringmid,UM,TM,6,5
if UM=http:
UM=WAIT
if UM=NDOWS
UM=WAIT
GuiControl,1:,WGT,%UM%
   if SDL=1
    {
    winclose,ahk_class ConsoleWindowClass
    settimer,AAS,OFF
    ;GuiControl,1:Enable,DNL-SEL
    ;GuiControl,1:Enable,DNL-ALL
    ;SEL=
    return
    }
return
;------------------------------------------------------------------


;================= GOSUBS YOUTUBE ==================================
AAS4:
  Filegetsize,size1,%F54%
  RES1:=Round((100*SIZE1)/SIZE3)
  GuiControl,1:,PRBAR, %SIZE1%
  GuiControl,1:,Text22,%RES1% `%      SIZE=%SIZE3%
return
;============================================================


;================= GOSUBS MUSIK ==================================
AAS5:
  Filegetsize,size1,%N54%
  RES1:=Round((100*SIZE1)/SIZE5)
  GuiControl,1:,PRBAR, %SIZE1%
  GuiControl,1:,Text22,%RES1% `%      SIZE=%SIZE5%
return
;===========================================================




;================= wait for copy adress ===================
DDDD:
Gui,1:submit,nohide
CL=%clipboard%
if CL contains watch?v=
   {
  AL=%CL%
  goto,alonevid2
   }
return
===========================================================



;=============== clear variables ============
CLEARVAR:
NOTHING1=%S%                                                     %S%
        GuiControl,1:,PRBAR,%NOTHING1%
        GuiControl,1:,Text22,%NOTHING1%
        GuiControl,1:TEXT,WGT,%NOTHING1%
        GuiControl,1:TEXT,SUCCESS,%NOTHING1%
        GuiControl,1:TEXT,NSUCCESS5,%NOTHING1%

MUSIC=
VIDEO=
KEEP=
FXY=
ALONE=
SDL=
return
;=============================================




;-------------   GOSUB-FILECHECK for SIZE  -----------------------------
GOSUBFILECHECK:
    NGG:=0
    size11:=0
    FileGetSize,size11,%N54%
      if size11<1
             {
            NGG=1
            goto,SKIP11
             }


     if (ext="ram")
           {
       if ((size11 <30) OR (size11 >300))
             {
            NGG=1
            goto,SKIP11
             }
           }


     if (ext="rm")
           {
       if size11 <20000
             {
           NGG=1
           goto,SKIP11
             }
           }


     if (ext="mid")
           {
       if size11 <12000
             {
           NGG=1
          goto,SKIP11
             }
           }



     if (ext="mp3" OR ext="wav")
           {
       if size11 <100000
             {
            NGG=1
            goto,SKIP11
             }
           }


     if (ext="wma")
           {
       if size11 <100000
             {
            NGG=1
            goto,SKIP11
             }
           }




     SKIP11:
        if NGG=1                               ;File is too small
           {
           Filedelete,%N54%
           GuiControl,1:Text,WGT,DELETED
           GuiControl,1:+RANGE0,PRBAR
           sleep,1200
            }

        if NGG=0
           {
           GuiControl,1:Text,WGT,OK
           SUCCES1=YES
           sleep,1200
           }
return
;------------------- END GOSUB-FILECHECK ----------------------------------------







;##################  ESCAPE #################################################
ESC::
gui,1:submit,nohide
process,close,%PID2%    ;flv
process,close,%PID3%    ;mp3rec
Gui,2:destroy
return
;===========================================================================



EX:
GuiClose:
GuiEscape:
winclose,ahk_class ConsoleWindowClass
process,close,%PID2%    ;flv
process,close,%PID3%    ;mp3rec
ExitApp










;############################### FUNCTION OLFEN #####################################
;================  BLOCK-A   DETECT URL-2 TYPE(1) SIZE(5) HEADERS(21)  =====================
/* ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; HttpQueryInfo ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;http://www.autohotkey.com/forum/topic10510.html&highlight=dllcall+wininet+internetclosehandle
;SIZE:=HttpQueryInfo(URL, 5)
;msgbox,262144,MESSAGE,SIZE = %SIZE% Byte

QueryInfoFlag:

HTTP_QUERY_RAW_HEADERS = 21
Receives all the headers returned by the server.
Each header is terminated by "\0". An additional "\0" terminates the list of headers.

HTTP_QUERY_CONTENT_LENGTH = 5
Retrieves the size of the resource, in bytes.

HTTP_QUERY_CONTENT_TYPE = 1
Receives the content type of the resource (such as text/html).

Find more at: http://msdn.microsoft.com/library/en-us/wininet/wininet/query_info_flags.asp

Proxy Settings:
INTERNET_OPEN_TYPE_PRECONFIG                    0   // use registry configuration
INTERNET_OPEN_TYPE_DIRECT                       1   // direct to net
INTERNET_OPEN_TYPE_PROXY                        3   // via named proxy
INTERNET_OPEN_TYPE_PRECONFIG_WITH_NO_AUTOPROXY  4   // prevent using java/script/INS
*/ ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

HttpQueryInfo(URL, QueryInfoFlag=21, Proxy="", ProxyBypass="") {
hModule := DllCall("LoadLibrary", "str", "wininet.dll")

If (Proxy != "")
AccessType=3
Else
AccessType=1

io_hInternet := DllCall("wininet\InternetOpenA"
, "str", "" ;lpszAgent
, "uint", AccessType
, "str", Proxy
, "str", ProxyBypass
, "uint", 0) ;dwFlags
If (ErrorLevel != 0 or io_hInternet = 0) {
DllCall("FreeLibrary", "uint", hModule)
return, -1
}

iou_hInternet := DllCall("wininet\InternetOpenUrlA"
, "uint", io_hInternet
, "str", url
, "str", "" ;lpszHeaders
, "uint", 0 ;dwHeadersLength
, "uint", 0x80000000 ;dwFlags: INTERNET_FLAG_RELOAD = 0x80000000 // retrieve the original item
, "uint", 0) ;dwContext
If (ErrorLevel != 0 or iou_hInternet = 0) {
DllCall("FreeLibrary", "uint", hModule)
return, -1
}

VarSetCapacity(buffer, 1024, 0)
VarSetCapacity(buffer_len, 4, 0)

Loop, 5
{
  hqi := DllCall("wininet\HttpQueryInfoA"
  , "uint", iou_hInternet
  , "uint", QueryInfoFlag ;dwInfoLevel
  , "uint", &buffer
  , "uint", &buffer_len
  , "uint", 0) ;lpdwIndex
  If (hqi = 1) {
    hqi=success
    break
  }
}

IfNotEqual, hqi, success, SetEnv, res, timeout
If (hqi = "success") {
p := &buffer
Loop
  {
  l := DllCall("lstrlen", "UInt", p)
  VarSetCapacity(tmp_var, l+1, 0)
  DllCall("lstrcpy", "Str", tmp_var, "UInt", p)
  p += l + 1
  res := res  . "`n" . tmp_var
  If (*p = 0)
  Break
  }
StringTrimLeft, res, res, 1
}

DllCall("wininet\InternetCloseHandle",  "uint", iou_hInternet)
DllCall("wininet\InternetCloseHandle",  "uint", io_hInternet)
DllCall("FreeLibrary", "uint", hModule)
return, res
}
;=================== END FUNCTION  ===========================================









/*


ADD WGET.................http://www.gnu.org/software/wget/wget.html              instead of ahk urldownloadtofile
                         http://users.ugent.be/~bpuype/wget/#download
ADD RECORD ..............http://ldb.tpv.ru/    MIXMP3.exe and mp3enc.dll  record audio to MP3
                         sndvol32 set record StereoMix on 10 %

;------------------------------------------------------------------
REMARKS .................
ONLINE CONVERT...........http://vconvert.net/
                         http://vixy.net/
MP3DirectCut.............http://www.mpesch3.de/     and also mpglib.dll and lame_enc.dll (F12)   for record ram.. to MP3
.........................http://www-users.york.ac.uk/~raa110/audacity/lame.html  lame_enc.dll    for MP3DirectCut
MINILYRICS...............http://www.crintsoft.com/index.htm   (shareware)
SMPLAYER ................http://smplayer.sourceforge.net/en/index.php
FLVPLAYER ...............http://keepvid.com/
GOMPLAYER ...............http://www.gomplayer.com/codec/success.html?intCodec=10
KMPLAYER ................http://www.kmplayer.com/forums/index.php
Mediapler Classic........http://www.codecguide.com/download_mega.htm
.........................http://www.youtube.com/v/Hxx2KcPWWZg
.........................http://www.youtube.com/jp.swf?video_id=Hxx2KcPWWZg

;--------------------------------------
put wget and MP3DirectCut in subfolder
...wget\wget.exe
...MP3DIRECTCUT\mp3directcut.exe
==============================================================================
*/
