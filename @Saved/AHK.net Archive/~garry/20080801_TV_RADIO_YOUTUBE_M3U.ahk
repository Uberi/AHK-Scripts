;---- example to record radio download youtube M3U -----------------

MODIFIED =20080801/2
CREATED  =20080624
NAME101  =TV_RADIO_YOUTUBE_M3U
TESTPICT =%A_scriptdir%\test.jpg


;===================================================================================
/*
Uploaded TOOLS ................. http://www.autohotkey.net/~garry/20080801_TV_YOUTUBE.zip
This File      ................. http://www.autohotkey.net/~garry/20080801_TV_RADIO_YOUTUBE_M3U.ahk
TV Television embed ............ http://www.autohotkey.com/forum/topic27264.html


 USE         = VIDEO YOUTUBE MUSIC M3U PHOTO AUDIORECORD PLAYER
               download youtube

needs.......................... = lbbrowse3.dll
................................  http://www.alycesrestaurant.com/lbbrowse.htm
................................  http://www.alycesrestaurant.com/zips/browsdll3.zip


Streamripper.exe................ http://sourceforge.net/projects/streamripper
                                 streamripper.exe   &   tre.dll
                                 records radio found in shoutcast

audio level meter .............. meterh.exe
................................ http://www.darkwood.demon.co.uk/PC/meter.html

MIXMP3  ........................ http://ldb.tpv.ru/
................................ MIXMP3.exe  &  mp3enc.dll
                                 record audio to MP3

MPLAYERC.exe ................... http://www.codecguide.com/download_mega.htm

MP3GAIN.exe 1.2.5 .............. http://mp3gain.sourceforge.net/


OCTOSHAPE ...................... http://www.octoshape.com/files/octosetup_v_l_odd.exe
                                 http://www.octoshape.com/play/play.asp?lang=de
                                 (to see some video/radio like=
 TV     http://127.0.0.1:6498/ms2/1213987018765/0MediaPlayer+0+/octoshape+h+RTP.400/RTP400?MSWMExt=.asf
 radio  http://www.rtvslo.si/;http://127.0.0.1:6498/ms2/1217572603847/0MediaPlayer+0+/octoshape+h+RTVSLO.Koper/RTVSLOKoper?MSWMExt=.asf




=========================================================================================
Description.....................

-YOUTUBE     watch in GUI when rightclick url (save link) in youtube
-YOUTUBE     download and keep a logfile (can also download when no more exist)
-RECORD      record what you hear with mixmp3
-RADIO       record with streamripper multiple radio stations
-Television  see embedded
-Search      type in search word and start links


LISTVIEW     select predefined folder to search from here
             ( edit /delete / addnew )

-FOTO        slide show
-VIDEO       see with predefined size and black background
-MUSIC       M3UPlayer
=========================================================================================





some problems with command=[Gui,add,picture] when using dllbrowse

*/
;===================================================================================








;--------------------------------------------
#NoEnv

setworkingdir, %a_scriptdir%
SetBatchLines -1
settitlematchmode,2
;DetectHiddenText,on
Detecthiddenwindows,on
;SetKeyDelay, 100
SetFormat Float, 0.0
   transform,S,chr,32
   transform,ten,chr,10
   transform,tre,chr,13
   CF=%TRE%%TEN%



ifnotexist,lbbrowse3.dll
   goto,LBBROWSE3




R3Ya=Links_YOUTUBE.txt
R3Y =%A_scriptdir%\%R3Ya%

R3Wa=Youtube_Logfile.txt
R3W =%A_scriptdir%\%R3Wa%


R3Ra=Links_RADIO.txt
R3R =%A_scriptdir%\%R3Ra%

R3Ta=Links_Television.txt
R3T =%A_scriptdir%\%R3Ta%

R3Sa=Links_SEARCH.txt
R3S =%A_scriptdir%\%R3Sa%


R3Za=TV_links_BeeLineTV.txt
R3Z =%A_scriptdir%\%R3Za%



;gosub,createstfiles





MPL          =%A_programfiles%\K-Lite Codec Pack\Media Player Classic\mplayerc.exe
VLC          =%A_programfiles%\VideoLAN\VLC\vlc.exe
STREAMRIPPER =%A_ScriptDir%\streamripper\streamripper.exe
GAIN         =%A_ScriptDir%\MP3GAIN\mp3gain.exe


REC        =c:\_RECORDED1                                ;---- <<< place for recorded music
GAINFOLDER =c:\_MP3GAIN                                  ;---- <<< MP3GAINFOLDER
GRAY       =%A_scriptdir%\dgray.bmp


run,%COMSPEC% /C if not exist \%REC%\NUL MD %REC%,,hide
run,%COMSPEC% /C if not exist \%GAINFOLDER%\NUL MD %GAINFOLDER%,,hide


MX3    =%A_scriptdir%\mixmp3.exe


RSSINI=%A_scriptdir%\RSSINI.txt

;-------- menu ----------------------------------------------


     ;--------------- SETTINGS ------------------
     menu ,S1 ,Add,&Set a predefined Folder MUSIC [Search from here],MH1
     menu ,S1 ,Add,&Set a predefined Folder VIDEO [Search from here],MH1TV
     menu ,S1 ,Add,&Set a predefined Folder PHOTO [Search from here],MH1PHOTO
     menu ,S1 ,Add,&TV BeeLine Update             ,UpdateBeeLineTV
     menu ,S1 ,Add,&How to use              ,MH2


     ;------------ Select Folder ---------------------
     menu ,S2 ,Add,&Select Music Folder     ,MS1MUS
     menu ,S2 ,Add,&Select Video Folder     ,MS1VID
     menu ,S2 ,Add,&Select PHOTO Folder     ,MS1PHOTO
     menu ,S2 ,Add,&Create M3U              ,MFM3U



     ;-------------- TOOLS ---------------------------
     Menu,S3,add,BLANK             ,MH3
     Menu,S3,add,SCREEN            ,MH3
     Menu,S3,add,LEVELMETER        ,MH3
     Menu,S3,add,RECORDMP3         ,MH3
     Menu,S3,add,LBBROWSE3         ,MH3
     Menu,S3,add,MPLAYERC          ,MH3
     Menu,S3,add,OCTOSHAPE         ,MH3




     ;------------ SELECT -----------------------
     menu, S4, add,RADIO                    ,MH4
     menu, S4, add,TELEVISION               ,MH4
     menu, S4, add,BeeLineTV                ,MH4
     menu, S4, add,YOUTUBE                  ,MH4
     menu, S4, add,YOUTUBE_LOG              ,MH4
     menu, S4, add,YOUTUBE_REC              ,MH4
     menu, S4, add,SEARCHLINKS              ,MH4
     menu, S4, add,_MUSIC                   ,MH4
     menu, S4, add,_VIDEO                   ,MH4
     menu, S4, add,_PHOTO                   ,MH4




     ;-------- EXAMPLES ----------------------------
     Menu, S5, add,MAP1              ,MH5
     Menu, S5, add,RADIO DANMARK     ,MH5
     Menu, S5, add,YOUTUBE1          ,MH5
     Menu, S5, add,MUSIC_GROOVESHARK ,MH5
     Menu, S5, add,MUSIC_ESNIPS      ,MH5
     Menu, S5, add,VIDEO1            ,MH5
     Menu, S5, add,GMANEWS           ,MH5
     Menu, S5, add,SHORTFILM         ,MH5
     Menu, S5, add,PHOTO1            ,MH5
     Menu, S5, add,TELEVISION1       ,MH5



   menu, myMenuBar, Add, SELECT        ,:S4
   menu, myMenuBar, Add, Settings      ,:S1
   menu, myMenuBar, Add, Select Folder ,:S2
   menu, myMenuBar, Add, TOOLS         ,:S3
   menu, myMenuBar, Add, EXAMPLES      ,:S5

gui,2:menu,MyMenuBar
;----------------------------------------------------






;------------- VOLUME works with XP ------------------------------
SM1:=7                         ;record Stereo Mix
SM3:=100                       ;volume
SM4:=80                        ;wave
SM5:=2                         ;gainvolume

soundset,0,master,mute         ;SPEAKER=MASTER ON
SoundSet,%SM3%,master          ;SPEAKER=MASTER volume

soundset,0,WAVE,mute           ; WAVE EIN
SoundSet,%SM4%,WAVE            ; WAVE


;--- see stereo mix slider -----------
;--- analog:8  or analog:9 -----------
soundset,    0,ANALOG:9,mute   ;activate doesn`t work
SoundSet,%SM1%,ANALOG:9        ;Stereo Mix recording work
;---------------------------------------------------------------


WA=%A_screenwidth%
HA=%A_screenheight%




X10 :=(WA*1  )/100
X11 :=(WA*4  )/100
X12 :=(WA*7  )/100
X13 :=(WA*9 )/100
X14 :=(WA*12 )/100
X15 :=(WA*14 )/100
X16 :=(WA*16 )/100
X17 :=(WA*18 )/100
X18 :=(WA*20 )/100
X19 :=(WA*22 )/100
X20 :=(WA*24 )/100
X21 :=(WA*26 )/100
X22 :=(WA*28 )/100
X23 :=(WA*30 )/100
X24 :=(WA*32 )/100
X25 :=(WA*34 )/100
X26 :=(WA*36 )/100
X27 :=(WA*38 )/100
X28 :=(WA*40 )/100
X29 :=(WA*42 )/100
X30 :=(WA*44 )/100
X31 :=(WA*46 )/100
X32 :=(WA*48 )/100
X33 :=(WA*50 )/100
X34 :=(WA*52 )/100
X35 :=(WA*54 )/100
X36 :=(WA*56 )/100
X37 :=(WA*58 )/100
X38 :=(WA*60 )/100
X39 :=(WA*62 )/100
X40 :=(WA*64 )/100
X41 :=(WA*66 )/100
X42 :=(WA*68 )/100
X43 :=(WA*70 )/100
X43a:=(WA*70.8)/100
X44 :=(WA*72 )/100
X45 :=(WA*74 )/100
X45a:=(WA*74.8 )/100
X46 :=(WA*76 )/100
X47 :=(WA*78 )/100
X47a:=(WA*78.8 )/100
X48 :=(WA*80 )/100
X48a:=(WA*80.8)/100
X49 :=(WA*82 )/100
X50 :=(WA*84 )/100
X50a:=(WA*84.8 )/100
X51 :=(WA*86 )/100
X52 :=(WA*88 )/100
X53 :=(WA*90 )/100
X53a:=(WA*90.8)/100
X54 :=(WA*92 )/100
X55 :=(WA*94 )/100
X55a:=(WA*94.8)/100
X56 :=(WA*96 )/100



Y10 :=(HA*1  )/100
Y11 :=(HA*4  )/100
Y12 :=(HA*7  )/100
Y13 :=(HA*9 )/100
Y14 :=(HA*12 )/100
Y15 :=(HA*15 )/100
Y16 :=(HA*18 )/100
Y17 :=(HA*21 )/100
Y18 :=(HA*24 )/100
Y19 :=(HA*27 )/100
Y19a:=(HA*29.2)/100
Y20 :=(HA*30 )/100
Y21 :=(HA*33 )/100
Y22 :=(HA*36 )/100
Y23 :=(HA*39 )/100
Y24 :=(HA*42 )/100
Y25 :=(HA*45 )/100
Y26 :=(HA*48 )/100
Y27 :=(HA*51 )/100
Y28 :=(HA*54 )/100
Y29 :=(HA*57 )/100
Y30 :=(HA*60 )/100
Y31 :=(HA*63 )/100
Y32 :=(HA*66 )/100
Y33 :=(HA*69 )/100
Y34 :=(HA*72 )/100
Y35 :=(HA*75 )/100
Y36 :=(HA*78 )/100
Y37 :=(HA*81 )/100
Y38 :=(HA*84 )/100
Y39 :=(HA*87 )/100
Y40 :=(HA*90 )/100
Y41 :=(HA*90.5 )/100


W07 :=(WA*2  )/100
W08 :=(WA*3  )/100
W09 :=(WA*4  )/100
W10 :=(WA*5  )/100
W11 :=(WA*6  )/100
W12 :=(WA*7  )/100
W13 :=(WA*8  )/100
W14 :=(WA*9  )/100
W15 :=(WA*10 )/100
W16 :=(WA*11 )/100
W17 :=(WA*12 )/100
W18 :=(WA*13 )/100
W19 :=(WA*14 )/100
W20 :=(WA*15 )/100

W31 :=(WA*32 )/100   ;groupbox width
W32 :=(WA*35 )/100   ;YouTube edit width

WGS:=(WA*99  )/100   ;GUI WIDTH
HGS:=(HA*92.7)/100   ;GUI HEIGHT


H10:=(HA*1.6)/100
H11:=(HA*2  )/100

H31:=(HA*23 )/100     ;groupbox height


T1:=(X25)    ;NAME
T2:=(X14)    ;LINK
T3:=(0)      ;STREAM
T4:=(X11)    ;RECORD

T1A:=T1
T2A:=T1+T2
T3A:=T1+T2+T3
T4A:=T1+T2+T3+T4

T9A:=T1+T2+T3+T4+20
T9B:=T1+T2+T3+T4+50

Gui,2:Color,black
Gui,2:Font,  S10 CDefault , Lucida Console



;-------------- UP RIGHT CORNER ----------
Gui,2: Add, Picture, gCLEARHTML           x%X55%    y%Y10%   w%W09%  h%H10% ,%GRAY%
Gui,2: Add, Text   ,                      x%X55%    y%Y10%   w%W09%  h%H10% cWhite center BackgroundTrans,CLEAR


;Gui,2: Add, Picture, gTEST31              x%X55%    y%Y11%   w%W09%  h%H10% ,%GRAY%
;Gui,2: Add, Text   ,                      x%X55%    y%Y11%   w%W09%  h%H10% cWhite center BackgroundTrans,TEST31





;--------- LAST LINE ------------------------------------------------------------------------------------------------
AAX1=Jim Reeves
Gui,2:Add,Edit,                           x%X10%    y%Y40%   w%W19%  h%H11%    vSRCH1,%AAX1%          ;AAX1 for test EDIT1 SEARCH


LVSRCHX:=(X16)
LVSRCHY:=(Y40)
LVSRCHW:=(W10)
LVSRCHH:=(H11)

SHOWALLX:=(X19)
SHOWALLY:=(Y40)
SHOWALLW:=(W10)
SHOWALLH:=(H11)


Gui,2: Add, Picture, gSEARCH              x%LVSRCHX%    y%LVSRCHY%   w%LVSRCHW%  h%LVSRCHH% vSEARCH5,%GRAY%
Gui,2: Add, Text   ,                      x%LVSRCHX%    y%LVSRCHY%   w%LVSRCHW%  h%LVSRCHH% cWhite center BackgroundTrans,<LVSRCH

;Gui,2: Add, Picture, gCREALISTVIEWMUSIC   x%SHOWALLX%    y%SHOWALLY%   w%SHOWALLW%  h%SHOWALLH% vSHOWALL5,%GRAY%
Gui,2: Add, Picture, gSHOWALL             x%SHOWALLX%    y%SHOWALLY%   w%SHOWALLW%  h%SHOWALLH% vSHOWALL5,%GRAY%
Gui,2: Add, Text   ,                      x%SHOWALLX%    y%SHOWALLY%   w%SHOWALLW%  h%SHOWALLH% cWhite center BackgroundTrans,SHOWALL

Gui,2:Add,Edit,                           x%X22%    y%Y40%   w%W10%  h%H11%  vCounter1    ,                            ;EDIT2 COUNTER OK
;---------------------------------------



;--------------------------------------------- LISTVIEW ---------------------------------------------------------

Gui,2:Add,ListView,backgroundGray   cWhite grid x%X10% y%Y30% w%T9A% h%Y19a% +hscroll altsubmit gMLV1 vMLV2,A|B|C|D



;----------------------------------------







;----------------------PLAY BREAK ADD2FAV -----------------------------------------------

PLAYX:=(X35)
PLAYY:=(Y34)
PLAYW:=(W10)
PLAYH:=(H11)

BREAKX:=(X35)
BREAKY:=(Y35)
BREAKW:=(W10)
BREAKH:=(H11)

ADD2FAVX:=(X35)
ADD2FAVY:=(Y37)
ADD2FAVW:=(W10)
ADD2FAVH:=(H11)

Gui,2: Add, Picture, gPLAY1        x%PLAYX%    y%PLAYY%    w%PLAYW%    h%PLAYH% vPLAY5 ,%GRAY%
Gui,2: Add, Text   ,               x%PLAYX%    y%PLAYY%    w%PLAYW%    h%PLAYH% cWhite center BackgroundTrans,<PLAY

Gui,2: Add, Picture, gBREAK1       x%BREAKX%   y%BREAKY%   w%BREAKW%   h%BREAKH% vBREAK5,%GRAY%
Gui,2: Add, Text   ,               x%BREAKX%   y%BREAKY%   w%BREAKW%   h%BREAKH% cWhite center BackgroundTrans,<BREAK

Gui,2: Add, Picture, gADD2FAV      x%ADD2FAVX%   y%ADD2FAVY%   w%ADD2FAVW%   h%ADD2FAVH% vADD2FAV5,%GRAY%
Gui,2: Add, Text   ,               x%ADD2FAVX%   y%ADD2FAVY%   w%ADD2FAVW%   h%ADD2FAVH% cWhite center BackgroundTrans,<ADD2FAV


;---------------------------------------------------------------------------------------
Gui,2: Add, GroupBox,             x%X41%  y%Y30%  w%W31%  h%H31% ,


RECVOLX:=(X42)
RECVOLY:=(Y31)
RECVOLW:=(W11)
RECVOLH:=(H11)

WAVVOLX:=(X47)
WAVVOLY:=(Y31)
WAVVOLW:=(W11)
WAVVOLH:=(H11)

GAINEXX:=(X52)
GAINEXY:=(Y31)
GAINEXW:=(W11)
GAINEXH:=(H11)

Gui,2: Add, Picture, gRECVOLUME  x%RECVOLX%    y%RECVOLY%   w%RECVOLW%    h%RECVOLH%  vRECVOLUME5 ,%GRAY%
Gui,2: Add, Text   ,             x%RECVOLX%    y%RECVOLY%   w%RECVOLW%    h%RECVOLH%  cWhite center BackgroundTrans,REC-VOL
Gui,2:Add,Slider,                x%X42%        y%Y32%       w%W14%        h%H11%      vSlider Range5-50 gSliderRel,%SM1%
Gui,2:Add,Edit,cred              x%X45a%       y%RECVOLY%   w%W07%        h%H11%      vEditText3 gEdit3,

Gui,2: Add, Picture, gWAVEVOLUME x%WAVVOLX%    y%WAVVOLY%   w%WAVVOLW%    h%WAVVOLH%  vWAVEVOLUME5 ,%GRAY%
Gui,2: Add, Text   ,             x%WAVVOLX%    y%WAVVOLY%   w%WAVVOLW%    h%WAVVOLH%  cWhite center BackgroundTrans,WAV-VOL
Gui,2:Add,Slider,                x%X47%        y%Y32%       w%W14%        h%H11%      vVolume Range0-99 gVolumeX,%SM4%
Gui,2:Add,Edit,                  x%X50a%       y%WAVVOLY%   w%W07%        h%H11%      vEditText4 gEdit4,

Gui,2: Add, Picture, gGAINEXE    x%GAINEXX%    y%GAINEXY%   w%GAINEXW%    h%GAINEXH%  vGAINEXE5 ,%GRAY%
Gui,2: Add, Text   ,             x%GAINEXX%    y%GAINEXY%   w%GAINEXW%    h%GAINEXH%  cWhite center BackgroundTrans,GAIN-EXE
Gui,2:Add,Slider,                x%X52%        y%Y32%       w%W14%        h%H11%      vGAIN1 Range0-10 gGAIN1X,%SM5%
Gui,2:Add,Edit,                  x%X55a%       y%GAINEXY%   w%W07%        h%H11%      vEditText2 gEdit2,



;---------------------------------------------------------------------------------------
Gui,2: Add, Edit,                 x%X52%  y%Y33%  w%W14%  h%H11% vEditRecord cGray ReadOnly          ;EDIT record

Gui,2: Add, Picture, gRECORDAUDIO x%X42%  y%Y33%  w%W14%  h%H11% vRECAUDIO5 ,%GRAY%
Gui,2: Add, Text   ,              x%X42%  y%Y33%  w%W14%  h%H11% cWhite center BackgroundTrans,AUDIO-RECORD

Gui,2: Add, Picture, gSTOPMIX     x%X47%  y%Y33%  w%W14%  h%H11% vSTOPMIX5 ,%GRAY%
Gui,2: Add, Text   ,              x%X47%  y%Y33%  w%W14%  h%H11% cWhite center BackgroundTrans,STOP






;-----------------------------------------------------------------------------------------------------------------
Gui,2: Add, Edit,               x%X10%   y%Y29%   w%T9A%    h%H11% vEditTitle  cGray ReadOnly         ;EDIT Title


Gui,2:Add,DateTime,x%X35% y%Y29% w%W15% h%H11% vMydate2,                                              ;CALENDER





;-------------------------------- YOUTUBE ------------------------------------------------------------------------


Gui,2:Font,S16 cyellow, Verdana
Gui,2:Add,Text,center x0  y%Y28%  w%WGS% vAL1,%new2%
Gui,2:Font,  S10 CDefault , Lucida Console




;Gui,2: Add, Picture, gPLAYYOUTUBE    x%X36%  y%Y39%  w%W12%  h%H11% ,%GRAY%
;Gui,2: Add, Text   ,                 x%X36%  y%Y39%  w%W12%  h%H11% cWhite center BackgroundTrans,PLAY-YTB

Gui,2: Add, Picture, gYOUTUBE        x%X36%  y%Y39%  w%W12%  h%H11% ,%GRAY%
Gui,2: Add, Text   ,                 x%X36%  y%Y39%  w%W12%  h%H11% cWhite center BackgroundTrans,YOUTUBE

Gui,2: Add, Picture, gDOWNLOAD1      x%X40%  y%Y39%  w%W16%  h%H11% ,%GRAY%
Gui,2: Add, Text   ,                 x%X40%  y%Y39%  w%W16%  h%H11% cWhite center BackgroundTrans,DOWNLOAD-YOUTUBE

Gui,2: Add, Picture, gFOLDERREC      x%X46%  y%Y39%  w%W16%  h%H11% ,%GRAY%
Gui,2: Add, Text   ,                 x%X46%  y%Y39%  w%W16%  h%H11% cWhite center BackgroundTrans,FOLDER-REC



;ALCC=http://www.youtube.com/watch?v=iCKMzrPy4t4                      ;for TEST aquela janela
Gui,2: Add, Edit,               x%X36%   y%Y40%   w%W32%    h%H11% vEditYoutube cRed,%ALCC%          ;EDIT YOUTUBE
Gui,2: add, button,             x%X36%   y%Y40% h0  w0   default gDOWNLOAD1,
;-----------------------------------------------------------------------------------------------------------------





;----  LAST LINE -------------------



Gui,2:Add,Button,               x%X25%    y%Y40%    w%W10%    h%H11% gADDNEW96 ,ADDNEW
Gui,2:Add,Button,               x%X28%    y%Y40%    w%W10%    h%H11% gEDIT97   ,EDITLV

DELETELVX:=(X31)
DELETELVY:=(Y40)
DELETELVW:=(W12)
DELETELVH:=(H11)

Gui,2: Add, Picture, gDELETELV    x%DELETELVX%  y%DELETELVY%  w%DELETELVW%  h%DELETELVH% vDELETELV5 ,%GRAY%
Gui,2: Add, Text   ,              x%DELETELVX%  y%DELETELVY%  w%DELETELVW%  h%DELETELVH% cWhite center BackgroundTrans,DELETELV

;--------------------------------------------------------------------------------------------------------






GuiControl,2:,edittext3,%SM1%    ;stereo mix record
GuiControl,2:,edittext4,%SM4%    ;WAVE PLAYBACK
GuiControl,2:,edittext2,%SM5%    ;Gain Volume
;-----------------------------------

   Process,exist,mixmp3.exe
   if ErrorLevel=0
      GuiControl,2:Text,EditRecord,NO_RECORD



run,%comspec% /C meterh.exe,,hide
Process,wait,meterh.exe
PID3 = %ErrorLevel%
Process,exist,meterh.exe
sleep,200






Gui,2: Show, x2 y0 w%WGS% h%HGS%,%NAME101%-%MODIFIED%
;--------------------------------------------------
LB2:
Gui,2:default
LV_Delete()
LV_ModifyCol(1,T1)
LV_ModifyCol(2,T2)
LV_ModifyCol(3,T3)
LV_ModifyCol(4,T4)

gosub,createstfiles                            ;============>>


R3XX=%R3Z%
gosub,Filllistpath2                            ;============>>


lbbHandle := DllCall("LoadLibrary", "str", "lbbrowse3.dll")
WinGet, mainGuiHandle, ID, A
AS2=about:blank
DLLCall("lbbrowse3\CreateBrowser","uint",mainGuiHandle,"Int",X2,"Int",Y2,"Int",W2,"Int",H2,"Str",AS2,"Int",1)
DllCall("lbbrowse3\ShowStatusbar","int",0)
DllCall("lbbrowse3\EnableBrowser","int",1)
;DllCall("lbbrowse3\ShowBrowser","int",0)
OnExit, Cleanup

gosub,picture1                          ;============>>


gosub,DDDD
settimer,DDDD,1000           ;means goto start


return
;================================================================================================

















;=================  SETTIMER =====================================================
DDDD:
Gui,2:submit,nohide
URL11=%clipboard%
if URL11 contains watch?v=
  goto,start2
return
;---------------------------

START2:
GuiControl,2:Text,EditYoutube,%URL11%
clipboard=

settimer,DDDD,off
gosub,playyoutube
settimer,DDDD,ON
Gui,2: Show,max
return
;====================================================================================








YOUTUBE:
;run,http://wwww.youtube.com
GuiControlGet, SRCH1
   stringreplace,SRCH1,SRCH1,%S%,`%20,all
run,http://www.youtube.com/results?search_query=%SRCH1%&search=Search
return
;====================================================================================




FOLDERREC:
run,%REC%
return
;====================================================================================















;====================== TOOLS =================================================
MH3:
GuiControl,2:Text,AL1,%nothing%

if A_thisMenuItem=BLANK
   goto,CLEARHTML
if A_thisMenuItem=SCREEN
   goto,SCREEN1
if A_thisMenuItem=LEVELMETER
   goto,LEVELMETER
if A_thisMenuItem=RECORDMP3
   goto,RECORDMP3
if A_thisMenuItem=LBBROWSE3
   goto,BROWSE3
if A_thisMenuItem=MPLAYERC
   goto,MPLAYERC1
if A_thisMenuItem=OCTOSHAPE
   goto,OCTOSHAPE1
return



MPLAYERC1:
run,http://www.codecguide.com/download_mega.htm
return


SCREEN1:
run,c:\windows\system32\Desk.cpl
return

LEVELMETER:
run,http://www.darkwood.demon.co.uk/PC/meter.html
return

RECORDMP3:
run,http://ldb.tpv.ru/
return

BROWSE3:
run,http://www.alycesrestaurant.com/lbbrowse.htm
return

OCTOSHAPE1:
run,http://www.octoshape.com/play/play.asp
;run,http://www.octoshape.com/
return
;--------------------------------------------------------------------------------


























;===========================================================================================
RECVOLUME:
run,sndvol32 /rec
return
;-----------------

WAVEVOLUME:
run,sndvol32
return
;-----------------



;--- see stereo mix slider -----------
;--- analog:8  or analog:9 -----------
SliderRel:
Gui,2:Submit, NoHide
SoundSet,%slider%,Analog:9
GuiControl,2:, EditText3, %Slider%
Return

Edit3:
Gui,2:Submit, Nohide
GuiControl,2:, Slider, %EditText3%
Return

;----------------------------------------
VolumeX:
Gui,2:Submit, NoHide
SoundSet,%volume%,WAVE
GuiControl,2:, EditText4,%volume%
Return

Edit4:
Gui,2:Submit, Nohide
GuiControl,2:,volume,%EditText4%
Return
;-----------------------------------------



;----------------------------------------
Gain1X:
Gui,2: Submit, NoHide
GuiControl,2:, EditText2,%GAIN1%
Return

Edit2:
Gui,2: Submit, Nohide
GuiControl,2:,GAIN1,%EditText2%
Return
;----------------------------------------


;===================================================================================================



;----------------------------------------------------------------
GAINEXE:

ifexist,%GAIN%
  {
  Loop,%GAINFOLDER%\*.*
  SPN=%A_LoopFileShortPath%
  stringlen,LenLine,SPN
  StringGetPos,C,SPN,\,R1   ;sucht ersten \ von rechts
  stringmid,SRQN,SPN,1,C
  if C=-1
     {
     msgbox,Folder %GAINFOLDER%   >> is empty
     return
     }

  runwait,%COMSPEC% /K mp3gain\mp3gain.exe /d%GAIN1% /r %SRQN%\*.MP3
  return
  }

else
  {
  msgbox,mp3gain.exe 1.2.5 is missing,download from http://mp3gain.sourceforge.net/
  return
  }
return
;--------------------------------------------------------------------------------------




RECORDSTREAMRIPPER:
ifexist,%Streamripper%
   run,%COMSPEC% /K streamripper\streamripper.exe %C3% --xs_padding=5000:5000 -t -d "%REC%"
   ;run,%COMSPEC% /K streamripper\streamripper.exe %C3% -a -A -T -c -t -d "%REC%"
return
;------------------------------------------------------------------------------------------









BLANK:
AX1=about:blank
DllCall("lbbrowse3\Navigate", "str",AX1)
return
;-------------------------------------------------------------------------0




CLEARHTML:
SDL=1
process,close,%PIDX%
GuiControl,2:Text,AL1,
soundplay,notexisted.mp3  ;stop playing
if (RXX="MUSIC" OR RXX="PHOTO")
    {
    GuiControl,2:Enable,PLAY5
    Gui,2: Add, Text   ,               x%PLAYX%    y%PLAYY%    w%PLAYW%    h%PLAYH% cWhite center BackgroundTrans,<PLAY

    GuiControl,2:Enable,BREAK5
    Gui,2: Add, Text   ,               x%BREAKX%   y%BREAKY%   w%BREAKW%   h%BREAKH% cWhite center BackgroundTrans,<BREAK
    }

    ;-------- clear DLLHTML -----------
    W5=0
    H5=0
    DLLCall("lbbrowse3\MoveBrowser","Int",X2,"Int",Y2,"Int",W5,"Int",H5)
    ;DllCall("lbbrowse3\EnableBrowser","int",0)
    AX1=about:blank
    DllCall("lbbrowse3\Navigate", "str",AX1)
    sleep,100
return
;----------------------------------------------------------------------------










;-------------- ADD TVBeeLine to TVFavorites ------------------------
ADD2FAV:
   if C1=
     {
     msgbox, 262208,Select First a Row, Select first a row ( at left border )
     return
     }


Fileappend,%C1%;%C2%;%C3%`r`n,%R3T%
msgbox,%C1% is added to %R3Ta%
return
;--------------------------------------------------------








;---------------------------------- PICTURE ------------------------------------
PICTURE1:
Gui,2:submit,nohide
C211=file:///%testpict%
gosub,background1

aa4=
(
<img src="%C211%" frameborder="0" style="width:%W2%px; height:%H2%px; display:block; background: black;" scrolling="no">
)

gosub,skip2
DLLCall("lbbrowse3\MoveBrowser","Int",X2,"Int",Y2,"Int",W2,"Int",H2)
DllCall("lbbrowse3\Navigate", "str",M3)
return
;================================================================================























BACKGROUND1:
;----  size from background-screen ------------------
X2 :=(X15)
Y2 :=(Y10)
W2 :=(WA*58)/100  ;width
H2 :=(HA*51)/100  ;height

;----- size from television inside background -------
W3 :=(WA*57)/100  ;width
H3 :=(HA*45)/100  ;height

;--------------------------------------
return






BACKGROUND2:
;----  size from background-screen ------------------
                 X2 :=(X10)
                 Y2 :=(Y10)
                 H2 :=(HA*51)/100  ;height
                 W2 :=(WA*95)/100  ;height
;----- size from inside background -------
        W3 :=(W2)
        H3 :=(H2)
return










;========================= SELECT ==============================
MH4:

if A_thisMenuItem=_MUSIC
   {
   R3XX=MUSIC
   goto,crealistviewmusic
   }

if A_thisMenuItem=_VIDEO
   {
   R3XX=VIDEO
   goto,crealistviewVideo
   }


if A_thisMenuItem=_PHOTO
   {
   R3XX=PHOTO
   goto,crealistviewPHOTO
   }


if A_thisMenuItem=Radio
   {
   R3XX=%R3R%
   goto,Filllistpath2
   }


if A_thisMenuItem=Youtube
   {
   R3XX=%R3Y%
   goto,Filllistpath2
   }

if A_thisMenuItem=Youtube_LOG
   {
   R3XX=%R3W%
   goto,Filllistpath2
   }

if A_thisMenuItem=Youtube_REC
   {
   R3XX=%REC%
   goto,crealistviewYoutube
   }


if A_thisMenuItem=Television
   {
   R3XX=%R3T%
   goto,Filllistpath2
   }

if A_thisMenuItem=SearchLinks
   {
   R3XX=%R3S%
   goto,Filllistpath2
   }

if A_thisMenuItem=BeeLineTV
   {
   R3XX=%R3Z%
   goto,Filllistpath2
   }


return
;--------------------------------------------------------------------------






;====================== EXAMPLES =================================================
MH5:
GuiControl,2:Text,AL1,%nothing%

if A_thisMenuItem=MAP1
   goto,ATT101
if A_thisMenuItem=RADIO DANMARK
   goto,ATT102
if A_thisMenuItem=YOUTUBE1
   goto,ATT103
if A_thisMenuItem=MUSIC_GROOVESHARK
   goto,ATT104
if A_thisMenuItem=VIDEO1
   goto,ATT105
if A_thisMenuItem=MUSIC_ESNIPS
   goto,ATT106
if A_thisMenuItem=GMANEWS
   goto,ATT107
if A_thisMenuItem=SHORTFILM
   goto,ATT108
if A_thisMenuItem=PHOTO1
   goto,ATT109
if A_thisMenuItem=TELEVISION1
   goto,TELEVISION2

return
;================================================================================


;---------------  example MAP  ---------------
ATT101:
GuiControl,2:Text,AL1,
gosub,BACKGROUND1

aa4=
(
<iframe width="%W2%" height="%H2%" frameborder="0" scrolling="no" marginheight="0" marginwidth="0" src="http://maps.google.com/maps?f=q&amp;hl=de&amp;geocode=&amp;q=kobenhavn&amp;ie=UTF8&amp;z=12&amp;ll=55.700034,12.584839&amp;output=embed&amp;s=AARTsJouXxDoZtfyv3vzI3PDZxdILW79tg"></iframe><br /><small><a href="http://maps.google.com/maps?f=q&amp;hl=de&amp;geocode=&amp;q=kobenhavn&amp;ie=UTF8&amp;z=12&amp;ll=55.700034,12.584839&amp;source=embed" style="color:#0000FF;text-align:left">Größere Kartenansicht</a></small>
)

gosub,skip2
DLLCall("lbbrowse3\MoveBrowser","Int",X2,"Int",Y2,"Int",W2,"Int",H2)
DllCall("lbbrowse3\Navigate", "str",M3)
return
;================================================================================


;-------- listen to Danmarks Radio evergreen ---------------------------
ATT102:
GuiControl,2:Text,AL1,
AX1=http://netradio.dr.dk/content.asp?station=29&#
gosub,BACKGROUND1
;H2 :=(HA*51)/100  ;height
H2 :=(HA*29)/100  ;height
DLLCall("lbbrowse3\MoveBrowser","Int",X2,"Int",Y2,"Int",W2,"Int",H2)
DllCall("lbbrowse3\Navigate", "str",AX1)
return

;================================================================================


;------------------ youtube example ----------------------------
ATT103:
GuiControl,2:Text,AL1,
gosub,BACKGROUND1
C3=http://www.youtube.com/watch?v=82ZuxWbO8QY
stringreplace,C3,C3,/watch?v=,/v/,all

   aa4=
   (
   <object width="%W2%" height="%H2%"> <param name="movie" value="%C3%"> </param> <embed src="%C3%" type="application/x-shockwave-flash" width="%W2%" height="%H2%"> </embed> </object>
   )

gosub,skip2
DLLCall("lbbrowse3\MoveBrowser","Int",X2,"Int",Y2,"Int",W2,"Int",H2)
DllCall("lbbrowse3\Navigate", "str",M3)
return




;----------------------------- MUSIC GROOVESHARK -------------------
ATT104:
GuiControl,2:Text,AL1,
AX1=http://listen.grooveshark.com/index.php?searchQuery=distant+drums
gosub,BACKGROUND2
DLLCall("lbbrowse3\MoveBrowser","Int",X2,"Int",Y2,"Int",W2,"Int",H2)
DllCall("lbbrowse3\Navigate", "str",AX1)
return



;-------------- example PLAY VIDEO FLV -----------------------
ATT105:
GuiControl,2:Text,AL1,
name1=aquela janela virada pro mar
C3=file:///c:\_recording\aquela janela virada pro mar.flv
W3:=(W2)
H3:=(H2)
goto,skip1
return




;-------- MUSIC ESNIPS ---------------------------
ATT106:
GuiControl,2:Text,AL1,
AX1=http://www.esnips.com/_t_/`%22jim+reeves`%22?to=120&gen=Any+Gender&t=1&sort=0&cnt=Any+Country&uf=0&page=1&st=4&from=13&pp=10&q=`%22jim+reeves`%22
;AX1=http://www.tvchannelsfree.com/watch/4643/Ehrensenf---Comedy-TV.html
gosub,BACKGROUND2
DLLCall("lbbrowse3\MoveBrowser","Int",X2,"Int",Y2,"Int",W2,"Int",H2)
DllCall("lbbrowse3\Navigate", "str",AX1)
return

;================================================================================




;---------------  GMANEWS  ---------------
ATT107:
GuiControl,2:Text,AL1,
gosub,BACKGROUND1

C1=http://www.gmanews.tv/evideo/24831/Saksi--GMA-reporter-films-recovery-effort-on-'Princess'

aa4=
(
<iframe src="%C1%" frameborder="0" style="width:%W2%px; height:%H2%px; display:block; background: black;" scrolling="no">
)

gosub,skip2
DLLCall("lbbrowse3\MoveBrowser","Int",X2,"Int",Y2,"Int",W2,"Int",H2)
DllCall("lbbrowse3\Navigate", "str",M3)
return
;================================================================================




;---------------  SHORTFILM  ---------------
ATT108:
GuiControl,2:Text,AL1,
gosub,BACKGROUND1

;http://www.vimeo.com/moogaloop.swf?clip_id=1004501
;http://www.vimeo.com/moogaloop.swf?clip_id=1189256

;IDN=1004501
IDN=1189256

aa4=
(
<object width="%W2%" height="%H2%">
<param name="allowfullscreen" value="true" />
<param name="allowscriptaccess" value="always" />
<param name="movie" value="http://www.vimeo.com/moogaloop.swf?clip_id=%IDN%&amp;server=www.vimeo.com&amp;show_title=1&amp;show_byline=1&amp;show_portrait=0&amp;color=&amp;fullscreen=1" />
<embed src="http://www.vimeo.com/moogaloop.swf?clip_id=%IDN%&amp;server=www.vimeo.com&amp;show_title=1&amp;show_byline=1&amp;show_portrait=0&amp;color=&amp;fullscreen=1" type="application/x-shockwave-flash" allowfullscreen="true" allowscriptaccess="always" width="%W2%" height="%H2%">
</embed>
</object>
)

gosub,skip2
DLLCall("lbbrowse3\MoveBrowser","Int",X2,"Int",Y2,"Int",W2,"Int",H2)
DllCall("lbbrowse3\Navigate", "str",M3)
return
;================================================================================








;--------------- PHOTO ----------------------
ATT109:
GuiControl,2:Text,AL1,
gosub,background1

         C220=file:///%A_scriptdir%\test.jpg
         X2 :=(X15)
         Y2 :=(0)
         W2 :=(WA*65)/100  ;width
         H2 :=(HA*54)/100  ;height

         aa4=
            (
            <img src="%C220%" frameborder="0" style="width:%W2%px; height:%H2%px; display:block; background: black;" scrolling="no">
            )

         gosub,skip2
         DLLCall("lbbrowse3\MoveBrowser","Int",X2,"Int",Y2,"Int",W2,"Int",H2)
         DllCall("lbbrowse3\Navigate", "str",M3)

         ;C200=%A_scriptdir%\test.jpg
         ;Gui,2:Add, Picture, x%X2%   y%Y2% w%W2% h%H2% ,%C200%
return
;================================================================================


















;==========================  show tv ===========================================================
TELEVISION2:      ;for test
C3     =http://streams.planet.nl/cgi-bin/reflector.cgi?stream=streamgate72
name1  =NL_NOS24

SKIP1:
TELEVISION:
GuiControl,2:Text,AL1,
gosub,background1

aa4=
(
  <center>
  <h1>%Name1%</h1>
      <param name="url" value="%C3%" />
      <param name="autostart" value="true" />
      <param name="uimode" value="mini" />
      <embed
        type="video/x-ms-wmv"
        src="%C3%"
        width="%W3%" height="%H3%"
        autostart="True"
        uimode="mini">
      </embed>
    </object>
)

gosub,SKIP2

DLLCall("lbbrowse3\MoveBrowser","Int",X2,"Int",Y2,"Int",W2,"Int",H2)
DllCall("lbbrowse3\Navigate", "str",M3)
return
;===============================================================================


;========================= SKIP2 =============================================
SKIP2:
Gui,2:submit,nohide
M3   =%A_scriptdir%\TEST.htm
ifexist,%M3%
   filedelete,%M3%

e1=
(
<HTML>
<HEAD>

<TITLE>MAP_TEST</TITLE>
</HEAD>
<BODY>

<style type="text/css">
  body {
       background-color: #008080;
       margin:  0px;
       padding: 0px;
       color: #fff;
       overflow-y: hidden;
       overflow-x: hidden;
       }
</style>

%AA4%

</BODY>
</HTML>
)

stringreplace,A,e1,%TEN%,%CF%,all
Fileappend,%A%`r`n,%M3%
return
;===============================================================================









;------------------ gosub create listview MUSIC -----------------------
CREALISTVIEWMUSIC:
Gui,2:Default
Gui,2:Listview,MLV2
GuiControl,2:Text,AL1,

   R3XX=MUSIC

IS=0
GuiControl,2:Text,Counter1,
LV_Delete()
LV_ModifyCol(1,T1)
LV_ModifyCol(2,T2)
LV_ModifyCol(3,T3)
LV_ModifyCol(4,T4)

IniRead, MF      , %rssini%  ,LASTSELECTED MUSIC , KEY3
if MF=
   return


FFR=mp3,wav,rm,wma

Loop, %MF%\*.*, 0,1
   {
   LR=%A_LoopFileFullPath%
   LC=%A_loopfiletimecreated%
   ;LM=%A_loopfiletimemodified%
   SplitPath,LR, namex, dir, ext, name_no_ext, drive
   if ext contains %FFR%
       {
       IS++
       SplitPath,LR, namex, dir, ext, name_no_ext, drive
       LV_Add("",namex,LC,LR)
       }
   }


  ;LV_ModifyCol(2,"integer")
  ;LV_ModifyCol(2, "Sort")                 ;sort column2
  ;LV_Modify(LV_GetCount(), "Vis")         ;goto last position

if IS>0
  gosub,picture1

GuiControl,2:Text,Counter1,%IS%


gosub,enableall

GuiControl,2:Disable,ADDNEW
GuiControl,2:Disable,EDITLV
    GuiControl,2:Disable,DELETELV5
    Gui,2: Add, Text   ,               x%DELETELVX%  y%DELETELVY%  w%DELETELVW%  h%DELETELVH% cBlack center BackgroundTrans,DELETELV
    Gui,2: Add, Text   ,               x%DELETELVX%  y%DELETELVY%  w%DELETELVW%  h%DELETELVH% cBlack center BackgroundTrans,DELETELV

    GuiControl,2:Disable,ADD2FAV5
    Gui,2: Add, Text   ,               x%ADD2FAVX%   y%ADD2FAVY%   w%ADD2FAVW%   h%ADD2FAVH% cBlack center BackgroundTrans,<ADD2FAV
    Gui,2: Add, Text   ,               x%ADD2FAVX%   y%ADD2FAVY%   w%ADD2FAVW%   h%ADD2FAVH% cBlack center BackgroundTrans,<ADD2FAV


return
;-------------------------------------------------------------------











;------------------ gosub create listview  YOUTUBE -----------------------
CREALISTVIEWYOUTUBE:
Gui,2:Default
Gui,2:Listview,MLV2
GuiControl,2:Text,AL1,


   R3XX=YOUTUBE


IS=0
GuiControl,2:Text,Counter1,
LV_Delete()
LV_ModifyCol(1,T1)
LV_ModifyCol(2,T2)
LV_ModifyCol(3,T3)
LV_ModifyCol(4,T4)


FFR=flv,mpg,avi

Loop, %REC%\*.*, 0,1
   {
   LR=%A_LoopFileFullPath%
   LC=%A_loopfiletimecreated%
   ;LM=%A_loopfiletimemodified%
   SplitPath,LR, namex, dir, ext, name_no_ext, drive
   if ext contains %FFR%
       {
       IS++
       SplitPath,LR, namex, dir, ext, name_no_ext, drive
       LV_Add("",namex,LC,LR)
       }
   }

  ;LV_ModifyCol(2,"integer")
  ;LV_ModifyCol(2, "Sort")                 ;sort column2
  ;LV_Modify(LV_GetCount(), "Vis")         ;goto last position
GuiControl,2:Text,Counter1,%IS%

gosub,disableall
    GuiControl,2:Enable,SEARCH5
    Gui,2: Add, Text   ,                      x%LVSRCHX%    y%LVSRCHY%   w%LVSRCHW%  h%LVSRCHH% cWhite center BackgroundTrans,<LVSRCH
    Gui,2: Add, Text   ,                      x%LVSRCHX%    y%LVSRCHY%   w%LVSRCHW%  h%LVSRCHH% cWhite center BackgroundTrans,<LVSRCH

    GuiControl,2:Enable,SHOWALL5
    Gui,2: Add, Text   ,                      x%SHOWALLX%    y%SHOWALLY%   w%SHOWALLW%  h%SHOWALLH% cWhite center BackgroundTrans,SHOWALL
    Gui,2: Add, Text   ,                      x%SHOWALLX%    y%SHOWALLY%   w%SHOWALLW%  h%SHOWALLH% cWhite center BackgroundTrans,SHOWALL

return
;-------------------------------------------------------------------























;------------------ gosub create listview  VIDEO -----------------------
CREALISTVIEWVIDEO:
Gui,2:Default
Gui,2:Listview,MLV2
GuiControl,2:Text,AL1,

   R3XX=VIDEO

IS=0
GuiControl,2:Text,Counter1,
LV_Delete()
LV_ModifyCol(1,T1)
LV_ModifyCol(2,T2)
LV_ModifyCol(3,T3)
LV_ModifyCol(4,T4)

IniRead, MFVID      , %rssini%  ,LASTSELECTED VIDEO , KEY4
if MFVID=
   return

FFR=flv,mpg,avi

Loop, %MFVID%\*.*, 0,1
   {
   LR=%A_LoopFileFullPath%
   LC=%A_loopfiletimecreated%
   ;LM=%A_loopfiletimemodified%
   SplitPath,LR, namex, dir, ext, name_no_ext, drive
   if ext contains %FFR%
       {
       IS++
       SplitPath,LR, namex, dir, ext, name_no_ext, drive
       LV_Add("",namex,LC,LR)
       }
   }

  ;LV_ModifyCol(2,"integer")
  ;LV_ModifyCol(2, "Sort")                 ;sort column2
  ;LV_Modify(LV_GetCount(), "Vis")         ;goto last position
GuiControl,2:Text,Counter1,%IS%



gosub,disableall
    GuiControl,2:Enable,SEARCH5
    Gui,2: Add, Text   ,                      x%LVSRCHX%    y%LVSRCHY%   w%LVSRCHW%  h%LVSRCHH% cWhite center BackgroundTrans,<LVSRCH
    Gui,2: Add, Text   ,                      x%LVSRCHX%    y%LVSRCHY%   w%LVSRCHW%  h%LVSRCHH% cWhite center BackgroundTrans,<LVSRCH

    GuiControl,2:Enable,SHOWALL5
    Gui,2: Add, Text   ,                      x%SHOWALLX%    y%SHOWALLY%   w%SHOWALLW%  h%SHOWALLH% cWhite center BackgroundTrans,SHOWALL
    Gui,2: Add, Text   ,                      x%SHOWALLX%    y%SHOWALLY%   w%SHOWALLW%  h%SHOWALLH% cWhite center BackgroundTrans,SHOWALL

return
;-------------------------------------------------------------------




;------------------ gosub create listview  PHOTO -----------------------
CREALISTVIEWPHOTO:
Gui,2:Default
Gui,2:Listview,MLV2
GuiControl,2:Text,AL1,

    R3XX=PHOTO

    W5=0
    H5=0
    DLLCall("lbbrowse3\MoveBrowser","Int",X2,"Int",Y2,"Int",W5,"Int",H5)
    ;DllCall("lbbrowse3\EnableBrowser","int",0)
    AX1=about:blank
    DllCall("lbbrowse3\Navigate", "str",AX1)


IS=0
GuiControl,2:Text,Counter1,
LV_Delete()
LV_ModifyCol(1,T1)
LV_ModifyCol(2,T2)
LV_ModifyCol(3,T3)
LV_ModifyCol(4,T4)

IniRead, MFFOTO      , %rssini%  ,LASTSELECTED PHOTO , KEY4
if MFFOTO=
   return


FFR=jpg,bmp

Loop, %MFFOTO%\*.*, 0,1
   {
   LR=%A_LoopFileFullPath%
   LC=%A_loopfiletimecreated%
   ;LM=%A_loopfiletimemodified%
   SplitPath,LR, namex, dir, ext, name_no_ext, drive
   if ext contains %FFR%
       {
       IS++
       SplitPath,LR, namex, dir, ext, name_no_ext, drive
       LV_Add("",namex,LC,LR)
       }
   }


  ;LV_ModifyCol(2,"integer")
  ;LV_ModifyCol(2, "Sort")                 ;sort column2
  ;LV_Modify(LV_GetCount(), "Vis")         ;goto last position
GuiControl,2:Text,Counter1,%IS%


gosub,disableall

    GuiControl,2:Enable,PLAY5
    Gui,2: Add, Text   ,               x%PLAYX%    y%PLAYY%    w%PLAYW%    h%PLAYH% cWhite center BackgroundTrans,<PLAY
    Gui,2: Add, Text   ,               x%PLAYX%    y%PLAYY%    w%PLAYW%    h%PLAYH% cWhite center BackgroundTrans,<PLAY

    GuiControl,2:Enable,BREAK5
    Gui,2: Add, Text   ,               x%BREAKX%   y%BREAKY%   w%BREAKW%   h%BREAKH% cWhite center BackgroundTrans,<BREAK
    Gui,2: Add, Text   ,               x%BREAKX%   y%BREAKY%   w%BREAKW%   h%BREAKH% cWhite center BackgroundTrans,<BREAK


    GuiControl,2:Enable,SEARCH5
    Gui,2: Add, Text   ,                      x%LVSRCHX%    y%LVSRCHY%   w%LVSRCHW%  h%LVSRCHH% cWhite center BackgroundTrans,<LVSRCH
    Gui,2: Add, Text   ,                      x%LVSRCHX%    y%LVSRCHY%   w%LVSRCHW%  h%LVSRCHH% cWhite center BackgroundTrans,<LVSRCH

    GuiControl,2:Enable,SHOWALL5
    Gui,2: Add, Text   ,                      x%SHOWALLX%    y%SHOWALLY%   w%SHOWALLW%  h%SHOWALLH% cWhite center BackgroundTrans,SHOWALL
    Gui,2: Add, Text   ,                      x%SHOWALLX%    y%SHOWALLY%   w%SHOWALLW%  h%SHOWALLH% cWhite center BackgroundTrans,SHOWALL

return
;-------------------------------------------------------------------











;--------------- txt csv -----------------------------
Filllistpath2:

Gui,2:Default
Gui,2:Listview,MLV2
GuiControl,2:Text,AL1,

LV_Delete()
LV_ModifyCol(1,T1)
LV_ModifyCol(2,T2)
LV_ModifyCol(3,T3)
LV_ModifyCol(4,T4)


IS=0
LV_Delete()
  loop,read,%R3XX%
   {
   LR=%A_loopreadline%
   if LR=
   continue
   IS++
   stringsplit,C,LR,`;
   SplitPath,C3, namex, dir, ext, name_no_ext, drive
   stringmid,C3FF,C3,1,4


   if R3XX=%R3W%
      {
      LV_Add("",C1,C2,C3,"DNL")
      continue
      }


   if R3XX=%R3R%
     {
       if C3 contains :8
           {
           if (ext="smi" or ext="ram" or C3FF="mms:")
               {
               LV_Add("",C1,C2,C3)
               continue
               }

           else
              {
              LV_Add("",C1,C2,C3,"REC")
              continue
              }
           }
     }


   LV_Add("",C1,C2,C3)
   C1=
   C2=
   C3=
   }

  LV_ModifyCol(1, "Sort")             ;sort by first column
  ;LV_Modify(LV_GetCount(), "Vis")     ;scroll down




if (R3XX=R3Z)        ;TVbeeLine
   {
   gosub,disableall

    GuiControl,2:Enable,ADD2FAV5
    Gui,2: Add, Text   ,               x%ADD2FAVX%   y%ADD2FAVY%   w%ADD2FAVW%   h%ADD2FAVH% cWhite center BackgroundTrans,<ADD2FAV
    Gui,2: Add, Text   ,               x%ADD2FAVX%   y%ADD2FAVY%   w%ADD2FAVW%   h%ADD2FAVH% cWhite center BackgroundTrans,<ADD2FAV

    GuiControl,2:Enable,SEARCH5
    Gui,2: Add, Text   ,               x%LVSRCHX%    y%LVSRCHY%   w%LVSRCHW%  h%LVSRCHH% cWhite center BackgroundTrans,<LVSRCH
    Gui,2: Add, Text   ,               x%LVSRCHX%    y%LVSRCHY%   w%LVSRCHW%  h%LVSRCHH% cWhite center BackgroundTrans,<LVSRCH

    GuiControl,2:Enable,SHOWALL5
    Gui,2: Add, Text   ,               x%SHOWALLX%    y%SHOWALLY%   w%SHOWALLW%  h%SHOWALLH% cWhite center BackgroundTrans,SHOWALL
    Gui,2: Add, Text   ,               x%SHOWALLX%    y%SHOWALLY%   w%SHOWALLW%  h%SHOWALLH% cWhite center BackgroundTrans,SHOWALL
    goto,continue07
   }


if (R3XX=R3W)        ;Youtube logfile
   {
   gosub,disableall

    GuiControl,2:Enable,DELETELV5
    Gui,2: Add, Text   ,               x%DELETELVX%  y%DELETELVY%  w%DELETELVW%  h%DELETELVH% cWhite center BackgroundTrans,DELETELV
    Gui,2: Add, Text   ,               x%DELETELVX%  y%DELETELVY%  w%DELETELVW%  h%DELETELVH% cWhite center BackgroundTrans,DELETELV

    GuiControl,2:Enable,SEARCH5
    Gui,2: Add, Text   ,               x%LVSRCHX%    y%LVSRCHY%   w%LVSRCHW%  h%LVSRCHH% cWhite center BackgroundTrans,<LVSRCH
    Gui,2: Add, Text   ,               x%LVSRCHX%    y%LVSRCHY%   w%LVSRCHW%  h%LVSRCHH% cWhite center BackgroundTrans,<LVSRCH

    GuiControl,2:Enable,SHOWALL5
    Gui,2: Add, Text   ,               x%SHOWALLX%    y%SHOWALLY%   w%SHOWALLW%  h%SHOWALLH% cWhite center BackgroundTrans,SHOWALL
    Gui,2: Add, Text   ,               x%SHOWALLX%    y%SHOWALLY%   w%SHOWALLW%  h%SHOWALLH% cWhite center BackgroundTrans,SHOWALL
    goto,continue07
   }


  gosub,disableall
    GuiControl,2:Enable,ADDNEW
    GuiControl,2:Enable,EDITLV

    GuiControl,2:Enable,DELETELV5
    Gui,2: Add, Text   ,              x%DELETELVX%  y%DELETELVY%  w%DELETELVW%  h%DELETELVH% cWhite center BackgroundTrans,DELETELV
    Gui,2: Add, Text   ,              x%DELETELVX%  y%DELETELVY%  w%DELETELVW%  h%DELETELVH% cWhite center BackgroundTrans,DELETELV

    GuiControl,2:Enable,SEARCH5
    Gui,2: Add, Text   ,               x%LVSRCHX%    y%LVSRCHY%   w%LVSRCHW%  h%LVSRCHH% cWhite center BackgroundTrans,<LVSRCH
    Gui,2: Add, Text   ,               x%LVSRCHX%    y%LVSRCHY%   w%LVSRCHW%  h%LVSRCHH% cWhite center BackgroundTrans,<LVSRCH

    GuiControl,2:Enable,SHOWALL5
    Gui,2: Add, Text   ,               x%SHOWALLX%    y%SHOWALLY%   w%SHOWALLW%  h%SHOWALLH% cWhite center BackgroundTrans,SHOWALL
    Gui,2: Add, Text   ,               x%SHOWALLX%    y%SHOWALLY%   w%SHOWALLW%  h%SHOWALLH% cWhite center BackgroundTrans,SHOWALL


CONTINUE07:
GuiControl,2:Text,Counter1,%IS%
return
;----------------------------------------------------------







;----------------------------------------------------------
;--------------- some problems thats because twice --------
ENABLEALL:
    GuiControl,2:Enable,ADDNEW
    GuiControl,2:Enable,EDITLV

    GuiControl,2:Enable,PLAY5
    Gui,2: Add, Text   ,               x%PLAYX%    y%PLAYY%    w%PLAYW%    h%PLAYH% cWhite center BackgroundTrans,<PLAY
    Gui,2: Add, Text   ,               x%PLAYX%    y%PLAYY%    w%PLAYW%    h%PLAYH% cWhite center BackgroundTrans,<PLAY

    GuiControl,2:Enable,BREAK5
    Gui,2: Add, Text   ,               x%BREAKX%   y%BREAKY%   w%BREAKW%   h%BREAKH% cWhite center BackgroundTrans,<BREAK
    Gui,2: Add, Text   ,               x%BREAKX%   y%BREAKY%   w%BREAKW%   h%BREAKH% cWhite center BackgroundTrans,<BREAK

    GuiControl,2:Enable,DELETELV5
    Gui,2: Add, Text   ,               x%DELETELVX%  y%DELETELVY%  w%DELETELVW%  h%DELETELVH% cWhite center BackgroundTrans,DELETELV
    Gui,2: Add, Text   ,               x%DELETELVX%  y%DELETELVY%  w%DELETELVW%  h%DELETELVH% cWhite center BackgroundTrans,DELETELV

    GuiControl,2:Enable,ADD2FAV5
    Gui,2: Add, Text   ,               x%ADD2FAVX%   y%ADD2FAVY%   w%ADD2FAVW%   h%ADD2FAVH% cWhite center BackgroundTrans,<ADD2FAV
    Gui,2: Add, Text   ,               x%ADD2FAVX%   y%ADD2FAVY%   w%ADD2FAVW%   h%ADD2FAVH% cWhite center BackgroundTrans,<ADD2FAV

    GuiControl,2:Enable,SEARCH5
    Gui,2: Add, Text   ,               x%LVSRCHX%    y%LVSRCHY%   w%LVSRCHW%  h%LVSRCHH% cWhite center BackgroundTrans,<LVSRCH
    Gui,2: Add, Text   ,               x%LVSRCHX%    y%LVSRCHY%   w%LVSRCHW%  h%LVSRCHH% cWhite center BackgroundTrans,<LVSRCH

    GuiControl,2:Enable,SHOWALL5
    Gui,2: Add, Text   ,               x%SHOWALLX%    y%SHOWALLY%   w%SHOWALLW%  h%SHOWALLH% cWhite center BackgroundTrans,SHOWALL
    Gui,2: Add, Text   ,               x%SHOWALLX%    y%SHOWALLY%   w%SHOWALLW%  h%SHOWALLH% cWhite center BackgroundTrans,SHOWALL

return
;----------------------------------------------------------





;----------------------------------------------------------
DISABLEALL:
    GuiControl,2:Disable,ADDNEW
    GuiControl,2:Disable,EDITLV

    GuiControl,2:Disable,PLAY5
    Gui,2: Add, Text   ,               x%PLAYX%      y%PLAYY%    w%PLAYW%    h%PLAYH% cBlack center BackgroundTrans,<PLAY
    Gui,2: Add, Text   ,               x%PLAYX%      y%PLAYY%    w%PLAYW%    h%PLAYH% cBlack center BackgroundTrans,<PLAY

    GuiControl,2:Disable,BREAK5
    Gui,2: Add, Text   ,               x%BREAKX%     y%BREAKY%   w%BREAKW%   h%BREAKH% cBlack center BackgroundTrans,<BREAK
    Gui,2: Add, Text   ,               x%BREAKX%     y%BREAKY%   w%BREAKW%   h%BREAKH% cBlack center BackgroundTrans,<BREAK

    GuiControl,2:Disable,DELETELV5
    Gui,2: Add, Text   ,               x%DELETELVX%  y%DELETELVY%  w%DELETELVW%  h%DELETELVH% cBlack center BackgroundTrans,DELETELV
    Gui,2: Add, Text   ,               x%DELETELVX%  y%DELETELVY%  w%DELETELVW%  h%DELETELVH% cBlack center BackgroundTrans,DELETELV

    GuiControl,2:Disable,ADD2FAV5
    Gui,2: Add, Text   ,               x%ADD2FAVX%   y%ADD2FAVY%   w%ADD2FAVW%   h%ADD2FAVH% cBlack center BackgroundTrans,<ADD2FAV
    Gui,2: Add, Text   ,               x%ADD2FAVX%   y%ADD2FAVY%   w%ADD2FAVW%   h%ADD2FAVH% cBlack center BackgroundTrans,<ADD2FAV

    GuiControl,2:Disable,SEARCH5
    Gui,2: Add, Text   ,               x%LVSRCHX%    y%LVSRCHY%    w%LVSRCHW%  h%LVSRCHH% cBlack center BackgroundTrans,<LVSRCH
    Gui,2: Add, Text   ,               x%LVSRCHX%    y%LVSRCHY%    w%LVSRCHW%  h%LVSRCHH% cBlack center BackgroundTrans,<LVSRCH

    GuiControl,2:Disable,SHOWALL5
    Gui,2: Add, Text   ,               x%SHOWALLX%   y%SHOWALLY%    w%SHOWALLW%  h%SHOWALLH% cBlack center BackgroundTrans,SHOWALL
    Gui,2: Add, Text   ,               x%SHOWALLX%   y%SHOWALLY%    w%SHOWALLW%  h%SHOWALLH% cBlack center BackgroundTrans,SHOWALL
return
;----------------------------------------------------------






























BREAK1:
SDL=1
process,close,%PIDX%
soundplay,notexisted.mp3  ;stop playing
if (R3XX="MUSIC" OR R3XX="PHOTO")
    {
    GuiControl,2:Enable,PLAY5
    Gui,2: Add, Text   ,               x%PLAYX%    y%PLAYY%    w%PLAYW%    h%PLAYH% cWhite center BackgroundTrans,<PLAY

    GuiControl,2:Enable,BREAK5
    Gui,2: Add, Text   ,               x%BREAKX%   y%BREAKY%   w%BREAKW%   h%BREAKH% cWhite center BackgroundTrans,<BREAK

    }
return





;-------------------------------------------------------------------
PLAY1:
Gui,2:submit,nohide

   GuiControl,2:Disable,PLAY5



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

  if (RF=0 OR RF="")
     break

        if SDL=1
             {
           RF=
           break
             }


       I2++
       LV_Modify(RF, "+Select +Focus")
       LV_GetText(C3,RF,3)
       ;msgbox,%C3%  %RF%
       SplitPath,C3, namex, dir, ext, name_no_ext, drive
       GuiControl,2:Text,EditTitle,%C3%


       if ext=
         goto,ABC


       if (ext="jpg" or ext="bmp")
         {
         C219=file:///%C3%
         X2 :=(X15)
         Y2 :=(0)
         W2 :=(WA*65)/100  ;width
         H2 :=(HA*56)/100  ;height

         aa4=
            (
            <img src="%C219%" frameborder="0" style="width:%W2%px; height:%H2%px; display:block; background: black;" scrolling="no">
            )

         gosub,skip2
         DLLCall("lbbrowse3\MoveBrowser","Int",X2,"Int",Y2,"Int",W2,"Int",H2)
         DllCall("lbbrowse3\Navigate", "str",M3)
         sleep,4000

         if I2=%IS%
                {
                ;-------- clear DLL -----------
                W5=0
                H5=0
                DLLCall("lbbrowse3\MoveBrowser","Int",X2,"Int",Y2,"Int",W5,"Int",H5)
                ;DllCall("lbbrowse3\EnableBrowser","int",0)
                AX1=about:blank
                DllCall("lbbrowse3\Navigate", "str",AX1)
                goto,ABC2
                }
          else
            goto,ABC
         }



       if (ext="mp3" or ext="wav")
         {
         soundplay,%C3%,wait
         }

        else

         {
         settimer,AAS1,1000
         soundplay,undefinedxy.mp3
         runwait,%MPL% %C3%,,,PIDX
         settimer,AAS1,OFF
         }




         ABC:
          LV_Modify(RF, "-Select +Focus")
          RF:=(RF+1)


       if SDL=1
          break

        ABC2:
        if I2=%IS%
              {
               GuiControl,2:Enable,PLAY5
               Gui,2: Add, Text   ,               x%PLAYX%    y%PLAYY%    w%PLAYW%    h%PLAYH% cWhite center BackgroundTrans,<PLAY

               GuiControl,2:Enable,BREAK5
               Gui,2: Add, Text   ,               x%BREAKX%   y%BREAKY%   w%BREAKW%   h%BREAKH% cWhite center BackgroundTrans,<BREAK


              LV_Modify(RF, "-Select +Focus")
              RF=
              break
              }

  }
return
;--------------------------------------------------------------------



AAS1:
ifwinactive,Media Player Classic
  {
  ControlGetText, Text1, Static3,Media Player Classic
  if Text1=Stopped
  process,close,%PIDX%
  }
return


















;---------------------------- LISTVIEW ------------------------------
MLV1:
GuiControlGet,MLV2
Gui,2:submit,nohide
;Gui,2:Default
Gui,2:Listview,MLV2



if A_GuiEvent = Normal
  {


       RN:=LV_GetNext("C")  ;2  selected checked
       RF:=LV_GetNext("F")  ;2  selected focused
       GC:=LV_GetCount()    ;4  total

  if (RF=0 OR RF="")
     return

  if (RN=0 OR RN="")
     return




      LV_GetText(name1,A_EventInfo,1)
       LV_GetText(C1,A_EventInfo,1)
       LV_GetText(C2,A_EventInfo,2)
       LV_GetText(C3,A_EventInfo,3)
       LV_GetText(C4,A_EventInfo,4)


  MouseGetPos,x,y
    {
   ;---------- COLUMN A -------------------------



   ;---------------------------------------------
   if x<70                ;just mark column
       {
       LV_Modify(RF, "+Select +Focus")
       LV_GetText(name1,A_EventInfo,1)
       LV_GetText(C1,A_EventInfo,1)
       LV_GetText(C2,A_EventInfo,2)
       LV_GetText(C3,A_EventInfo,3)
       LV_GetText(C4,A_EventInfo,4)

       SplitPath,C3, namex, dir, ext, name_no_ext, drive
       GuiControl,2:Text,EditTitle,%C3%
       return
       }
   ;---------------------------------------------






   ;----------------------- T1A -------------------------------
   if x<%T1A%
   {
       ;RN:=LV_GetNext("C")  ;2  selected checked
       ;RF:=LV_GetNext("F")  ;2  selected focused
       ;GC:=LV_GetCount()    ;4  total

       gosub,break1
       gosub,clearhtml
       GuiControl,2:Text,AL1,


       LV_Modify(RF, "+Select +Focus")
       LV_GetText(name1,A_EventInfo,1)
       LV_GetText(C1,A_EventInfo,1)
       LV_GetText(C2,A_EventInfo,2)
       C3=
       LV_GetText(C3,A_EventInfo,3)
       LV_GetText(C4,A_EventInfo,4)
       SplitPath,C3, namex, dir, ext, name_no_ext, drive
       GuiControl,2:Text,EditTitle,%C3%
       ;LV_Modify(RF, "+Select +Focus")
       ;stringreplace,SRCH1,SRCH1,%S%,`%20,all




       ;------------------------ 3S -----------------------------------------
       if R3XX=%R3S%                ;SEARCHLINKS EMBED
             {
                 X2 :=(X10)
                 Y2 :=(Y10)
                 H2 :=(HA*51)/100  ;height
                 W2 :=(WA*95)/100  ;height
                 GuiControlGet, SRCH1

           if C2 contains sound2light
                   {
                   ;http://sound2light.net/LETTERXX/LYRICSXX_lyrics.html`r`n,%R3Sa%
                   ;http://sound2light.net/j/jim_reeves_lyrics.html
                   stringmid,LR1,SRCH1,1,1
                   stringreplace,SRCH1,SRCH1,%S%,_,all
                   stringlower,LR1,LR1
                   stringreplace,C2,C2,LETTERXX,%LR1%,all
                   stringreplace,C2,C2,LYRICSXX,%SRCH1%,all
                   DLLCall("lbbrowse3\MoveBrowser","Int",X2,"Int",Y2,"Int",W2,"Int",H2)
                   DllCall("lbbrowse3\Navigate", "str",C2)
                   return
                   }


          if C2 contains reference.com/browse/wiki
                  {
                  ;http://www.reference.com/browse/wiki/Jim_Reeves
                  StringUpper,wikip,SRCH1,T                 ;set Title case
                  StringReplace,wikip,wikip,%A_space%,_,All
                  CX=http://www.reference.com/browse/wiki/%wikip%
                  DLLCall("lbbrowse3\MoveBrowser","Int",X2,"Int",Y2,"Int",W2,"Int",H2)
                  DllCall("lbbrowse3\Navigate", "str",CX)
                  return
                  }




                stringreplace,SRCH1,SRCH1,%S%,`%20,all
                ;SRCH1=`%22%SRCH1%`%22
                stringreplace,C2,C2,SRCHXX,%SRCH1%,all

               DLLCall("lbbrowse3\MoveBrowser","Int",X2,"Int",Y2,"Int",W2,"Int",H2)
               DllCall("lbbrowse3\Navigate", "str",C2)
              return
         }
         ;-----------------------------------------------------------------











       ;------------------ 3R --------------------------
       if R3XX=%R3R%                ;RADIO STREAM
         {
        ;TEST AOL;;http://scfire-ntc-aa03.stream.aol.com/stream/1065
        ;TEST DIFM;;http://www.di.fm/wma/hardstyle.asx
        ;FR_FAROER RADIO;;mms://media.internet.fo/uf


           NOTHING=
           if (C3="" and C2<>"%NOTHING%")
              {
              run,%C2%
              return
              }


          AFXW=stream.aol.com,mms://,.asx
          if C3 contains %AFXW%
                  goto,television


         ;run,%MPL% %C3%,,,PIDX
         run,%MPL% %C3%

        if C3 contains :8
           {
           EEF=0
           if (ext="smi" or ext="ram")
               EEF=1

           if EEF=0
               {
               C3a=%C3%/played.html
               gosub,BACKGROUND1
               DLLCall("lbbrowse3\MoveBrowser","Int",X2,"Int",Y2,"Int",W2,"Int",H2)
               DllCall("lbbrowse3\Navigate", "str",C3a)
               }
            }

        return
        }
       ;------------------ END  3R --------------------------





       ;------------------  R3T ----------------------------
        if R3XX=%R3T%                ;TELEVISION STREAM
         {

         NOTHING=
         if (C3="" and C2<>"%NOTHING%")
             {
             run,%C2%
             return
             }


         gosub,datecheck
         if DCCC=0
             return
         goto,television
         return
         }
         ;-----------------------------------------------------------------





         ;----------------------------------------------
         if R3XX=%R3Z%                ;TELEVISION BeeLine
             {


               NOTHING=
               if (C3="" and C2<>"%NOTHING%")
                  {
                 run,%C2%
                 return
                  }

            goto,television
            return
            }
         ;----------------------------------------------------






        ;------------------------------------------------
        if (R3XX="VIDEO" OR R3XX="YOUTUBE")                       ;VIDEO files
          {
          C3=file:///%C3%
          goto,skip1
          }
        ;-----------------------------------------------------------------





        ;------------------------------------------------
         if R3XX=PHOTO                       ;PHOTO files
             {
             C212=file:///%C3%
             X2 :=(X15)
             Y2 :=(0)
             W2 :=(WA*65)/100  ;width
             H2 :=(HA*56)/100  ;height

             aa4=
             (
             <img src="%C212%" frameborder="0" style="width:%W2%px; height:%H2%px; display:block; background: black;" scrolling="no">
             )

            gosub,skip2
            DLLCall("lbbrowse3\MoveBrowser","Int",X2,"Int",Y2,"Int",W2,"Int",H2)
            DllCall("lbbrowse3\Navigate", "str",M3)
            return
            }
         ;-----------------------------------------------------------------






         ;------------------------------ YOUTUBE ------------------------
         if C2 contains www.youtube.com/watch?v=
          {
            GuiControl,2:Text,AL1,%C1%
            gosub,background1
            stringreplace,C2,C2,/watch?v=,/v/,all
            ;C2=http://www.youtube.com/v/252oaWH6mAU
            ;C2=http://www.youtube.com/swf/l.swf?video_id=252oaWH6mAU

            aa4=
            (
            <object width="%W2%" height="%H2%"> <param name="movie" value="%C2%"> </param> <embed src="%C2%" type="application/x-shockwave-flash" width="%W2%" height="%H2%"> </embed> </object>
            )

            gosub,skip2
            DLLCall("lbbrowse3\MoveBrowser","Int",X2,"Int",Y2,"Int",W2,"Int",H2)
            DllCall("lbbrowse3\Navigate", "str",M3)
            return
          }
          ;-----------------------------------------------------------------






          ;--------------------- MUSIC ------------------------------------
          if R3XX=MUSIC
              {
              if (ext="mp3" or ext="wav")
                 {
                 soundplay,%C3%
                 }

             else
                 {
                 soundplay,undefinedxy.mp3
                 run,%MPL% %C3%,,,PIDX
                 sleep,1500
                 winactivate,ahk_class AutoHotkeyGUI
                 }
              }

       return
       }
;-----------------------------------------------------------------

;------------- END COLUMN A ------------------------------------












;===========================================================
;------------- COLUMN B ------------------------------------
      if x<%T2A%
      {


       gosub,break1
       gosub,clearhtml
       GuiControl,2:Text,AL1,

       LV_GetText(C1,A_EventInfo,1)
       LV_GetText(C2,A_EventInfo,2)
       LV_GetText(C3,A_EventInfo,3)
       LV_GetText(C4,A_EventInfo,4)
       GuiControlGet, SRCH1
       SplitPath,C2, namex, dir, ext, name_no_ext, drive
       ;GuiControl,2:Text,EditTitle,%C3%
       ;msgbox, 262208, You selected,%C3%


     ;--------------------------- R3S -------------------------------------------
     if R3XX=%R3S%                ;SEARCHLINKS EMBED
         {
         GuiControlGet, SRCH1

         if C2 contains sound2light
            {
            ;http://sound2light.net/LETTERXX/LYRICSXX_lyrics.html`r`n,%R3Sa%
            ;http://sound2light.net/j/jim_reeves_lyrics.html
            stringmid,LR1,SRCH1,1,1
            stringlower,LR1,LR1
            stringreplace,SRCH1,SRCH1,%S%,_,all
            stringreplace,C2,C2,LETTERXX,%LR1%,all
            stringreplace,C2,C2,LYRICSXX,%SRCH1%,all
            GuiControl,2:Text,EditTitle,%C2%
            run,%C2%
            return
            }


         if C2 contains reference.com/browse/wiki
              {
              ;http://www.reference.com/browse/wiki/Jim_Reeves
              StringUpper,wikip,SRCH1,T                 ;set Title case capital letters
              StringReplace,wikip,wikip,%A_space%,_,All
              CX=http://www.reference.com/browse/wiki/%wikip%
              GuiControl,2:Text,EditTitle,%CX%
              run,%CX%
              return
              }


         stringreplace,SRCH1,SRCH1,%S%,`%20,all
         SRCH1=`%22%SRCH1%`%22
         stringreplace,C2,C2,SRCHXX,%SRCH1%,all
         GuiControl,2:Text,EditTitle,%C2%
         run,%C2%
         return
         }
      ;----------------------------------- END R3S --------------------------------







        stringmid,C2EE,C2,1,4
        if (C2EE="http" or C2EE="www.")
             {
            GuiControlGet, SRCH1,2:
            GuiControl,2:Text,EditTitle,%C2%
            stringreplace,SRCH1,SRCH1,%S%,`%20,all
            SRCH1=`%22%SRCH1%`%22
            stringreplace,C2,C2,SRCHXX,%SRCH1%,all
            run,%C2%
            return
            }



      Return
      }
;-------------END  COLUMN B ------------------------------------




;------------- COLUMN C ------------------------------------
      if x<%T3A%
          return
;------------- END COLUMN C --------------------------------














;------------- COLUMN D ------------------------------------
      if x<%T4A%
      {
      LV_GetText(C1,A_EventInfo,1)
      LV_GetText(C2,A_EventInfo,2)
      LV_GetText(C3,A_EventInfo,3)
      LV_GetText(C4,A_EventInfo,4)


      if R3XX=%R3R%                ;RADIO STREAM
        {
        GuiControl,2:Text,EditTitle,%C3%
        if (C4="REC")
           gosub,RECORDSTREAMRIPPER
        return
        }


      if R3XX=%R3W%                ;RADIO STREAM
        {
        GuiControl,2:Text,EditTitle,%C3%
        ;URLDownloadToFile,%URL2%,%REC%\%F2%
        F2  =%C1%.flv
        URL2=%C3%
        if (C4="DNL")
           gosub,DOWNLOAD2
        return
        }



      return
      }









    }
;------------- END MOUSE GETPOS


  }
;============= END LISTVIEW COLUMNS ==============================================






;-------------- UP / DOWN -----------------------------------
if (R3XX="MUSIC" OR R3XX="PHOTO")                  ;only music or photo
{
if A_GuiEvent=K
 {
  GetKeyState,state,UP
  if state=D
    {
    RF:=LV_GetNext("F")
    LV_GetText(C3,RF,3)
    ifnotexist,%C3%
     {
     RF:=RF+1
     LV_GetText(C3,RF,3)
     }
    SplitPath,C3, namex, dir, ext, name_no_ext, drive
    if R3XX=MUSIC
       {
      if (ext="mp3" or ext="wav")
         {
         gosub,break1
         soundplay,%C3%
         return
         }

       else
         {
         soundplay,undefinedxy.mp3
         run,%MPL% %C3%
          Process,wait,mplayerc.exe
          PIDX = %ErrorLevel%
         sleep,1500
         winactivate,ahk_class AutoHotkeyGUI
         return
         }
       }


    if R3XX=PHOTO
       {
    if (ext="jpg" or ext="bmp")
         {
         C212=file:///%C3%
         ;gosub,background1
         X2 :=(X15)
         Y2 :=(0)
         W2 :=(WA*65)/100  ;width
         H2 :=(HA*56)/100  ;height

         aa4=
         (
         <img src="%C212%" frameborder="0" style="width:%W2%px; height:%H2%px; display:block; background: black;" scrolling="no">
         )
         gosub,skip2
         DLLCall("lbbrowse3\MoveBrowser","Int",X2,"Int",Y2,"Int",W2,"Int",H2)
         DllCall("lbbrowse3\Navigate", "str",M3)
         ;Gui,2:Add, Picture, x%X2%  y%Y2%  w%W2%  h%H2% ,%C3%
         GuiControl,2:Text,EditTitle,%C3%
         return
         }
       }

   }




GetKeyState,state,DOWN
  if state=D
  {
    RF:=LV_GetNext("F")
    LV_GetText(C3,RF,3)
    ifnotexist,%C3%
     {
     RF:=RF+1
     LV_GetText(C3,RF,3)
     }

     SplitPath,C3, namex, dir, ext, name_no_ext, drive
     if R3XX=MUSIC
       {
       if (ext="mp3" or ext="wav")
         {
         gosub,break1
         soundplay,%C3%
         return
         }

       else
         {
         soundplay,undefinedxy.mp3
         run,%MPL% %C3%
          Process,wait,mplayerc.exe
          PIDX = %ErrorLevel%
         sleep,1500
         winactivate,ahk_class AutoHotkeyGUI
         return
         }
      }


    if R3XX=PHOTO
       {
    if (ext="jpg" or ext="bmp")
         {
         C212=file:///%C3%
         X2 :=(X15)
         Y2 :=(0)
         W2 :=(WA*65)/100  ;width
         H2 :=(HA*56)/100  ;height

         aa4=
         (
         <img src="%C212%" frameborder="0" style="width:%W2%px; height:%H2%px; display:block; background: black;" scrolling="no">
         )
         gosub,skip2
         DLLCall("lbbrowse3\MoveBrowser","Int",X2,"Int",Y2,"Int",W2,"Int",H2)
         DllCall("lbbrowse3\Navigate", "str",M3)
         ;Gui,2:Add, Picture, x%X2%  y%Y2%  w%W2%  h%H2% ,%C3%
         GuiControl,2:Text,EditTitle,%C3%
         return
         }
       }



  }
 }
}
Return
;================  END LISTVIEW  ================================










;------------------------ LISTVIEW HANDLING ----------------------
;-------------------------------------------------
AddNew96:
  Gui, 2:+Disabled
  Gui, 96:+Owner

    {
    C1=
    C2=
    C3=
    }

   Gui,96:Font,  S10 CDefault , FixedSys

     Gui,96:Add,Text, x1   y5        h20,A-NAME
     Gui,96:Add,Edit, x120 y5   w420 h20 vA41,%C1%

     Gui,96:Add,Text, x1   y35       h20,B-LINK
     Gui,96:Add,Edit, x120 y35  w420 h20 vA42,%C2%

     Gui,96:Add,Text, x1   y65       h20,C-STREAMING
     Gui,96:Add,Edit, x120 y65  w420 h20 vA43,%C3%


   Gui,96:Add, Button, x550 y150 w40 h25, OK
   Gui,96:Show, x300 y410 w600 h180,AddNew
   return
   ;-----------
   96GuiClose:
   96GuiEscape:
   Gui,96:Destroy
   Gui,2:-Disabled
   Gui,2:Default
   return
   ;-----------
   96ButtonOK:
   Gui,96:submit
   FileAppend,%A41%;%A42%;%A43%`r`n,%R3XX%
   Gui,96:Destroy
   Gui,2:-Disabled
   Gosub,filllistpath2
   Gui,2:Default
   return
;------------------------------






;---------------------------------------------
Edit97:
FileToReplace=%R3XX%

   if (RN="" OR RN=0)
     {
     msgbox, 262208,RN Select First a Row, Select first a row ( at left border )
     return
     }

   if (RF="" OR RF=0)
     {
     msgbox, 262208,RF Select First a Row, Select first a row ( at left border )
     return
     }


   if C1=
     {
     msgbox, 262208,C1 Select First a Row, Select first a row ( at left border )
     return
     }

  Gui, 2:+Disabled
  Gui, 97:+Owner


        LV_GetText(C1,RN,1)                    ;
        LV_GetText(C2,RN,2)                    ;
        LV_GetText(C3,RN,3)                    ;


  Gui,97:Font,  S10 CDefault , FixedSys

  Gui,97:Add,Text, x1   y5        h20,A-NAME
  Gui,97:Add,Edit, x120 y5   w420 h20 vA61,%C1%

  Gui,97:Add,Text, x1   y35       h20,B-LINK
  Gui,97:Add,Edit, x120 y35  w420 h20 vA62,%C2%

  Gui,97:Add,Text, x1   y65       h20,C-STREAMING
  Gui,97:Add,Edit, x120 y65  w420 h20 vA63,%C3%

  Gui,97:Add, Button, x550 y150 w40 h25, OK
  Gui,97:Show, x300 y410 w600 h180,Edit
  return
  ;-----------
  97GuiClose:
  97GuiEscape:
  Gui,97:Destroy
  Gui,2:-Disabled
  Gui,2:Default
  return
  ;-----------
  97ButtonOK:
  Gui,97:submit
   FileRead,AA,%FileToReplace%
   FileDelete,%FileToReplace%
   StringReplace,BB,AA,%C1%;%C2%;%C3% , %A61%;%A62%;%A63%
   FileAppend,%BB%,%FileToReplace%
  Gui,2:-Disabled
  Gui,2:Default
  Gosub,filllistpath2
  Gui,97:Destroy
return
;---------------------------------------------------










DELETELV:
Gui,2:Default
Gui,2:Listview,MLV2

FileToDelete=%R3XX%

C1x=
RF = 0
RFL =
Loop
   {
   RF:=LV_GetNext(RF)
   if RF=0
     {
     msgbox, 262208,Select First a Row, Select first a row ( at left border )
     break
     }


   RFL = %RF%|%RFL%
   LV_GetText(C1_Temp, RF, 1)
   C1x = %C1x%`n%C1_Temp%
  }

if C1x !=
  {
   MsgBox, 4, ,Want you delete these lines in textfile=`n%FileToDelete%`n%C1x% ?
   IfMsgBox,No
      Return
   Else
     {

      Loop, parse, RFL, |
             {
             LV_Delete(A_LoopField)
             }

     filedelete,%FileToDelete%
     Loop % LV_GetCount()
            {
            BX1=
            BX2=
            BX3=
            LV_GetText(BX1,A_INDEX,1)
            LV_GetText(BX2,A_INDEX,2)
            LV_GetText(BX3,A_INDEX,3)
            fileappend,%BX1%;%BX2%;%BX3%`r`n,%FileToDelete%
            }
       }

  }
return
;------------------ END DELETE ------------------------------------































;------------------ SEARCHINSIDELV SEARCHINSIDELISTVIEW -----------------
SEARCH:
Gui,2:submit,nohide


if (R3XX="MUSIC" OR R3XX="VIDEO" OR R3XX="PHOTO")
   {
   GuiControl,2:Text,Counter1,
   RN:=LV_GetNext("C")  ;2  selected checked
   RF:=LV_GetNext("F")  ;2  selected focused
   GC:=LV_GetCount()    ;4  total
   RF:=1
   IS=0
   LV_Modify(RF, "+Select +Focus")

   ;------ search in column 3 ----
   Loop % LV_GetCount()
      {
      LV_GetText(C3,RF,3)
       ifinstring,C3,%SRCH1%
        {
        RF:=(RF+1)
        IS++
        continue
         }
      LV_Delete(RF)
      }
   GuiControl,2:Text,Counter1,%IS%
   return
   }


   {
   GuiControl,2:Text,Counter1,
   RN:=LV_GetNext("C")  ;2  selected checked
   RF:=LV_GetNext("F")  ;2  selected focused
   GC:=LV_GetCount()    ;4  total
   RF:=1
   IS=0
   LV_Modify(RF, "+Select +Focus")

   ;------ search in column 3 ----
   Loop % LV_GetCount()
      {
      LV_GetText(C1,RF,1)
      LV_GetText(C2,RF,2)
      LV_GetText(C3,RF,3)
      c123all=%C1%%C2%%C3%
       ifinstring,c123all,%SRCH1%
        {
        RF:=(RF+1)
        IS++
        continue
         }
      LV_Delete(RF)
      }
   GuiControl,2:Text,Counter1,%IS%
   return
   }



return
;--------------------------------------------------------------------------







SHOWALL:
if R3XX=MUSIC
   goto,CREALISTVIEWMUSIC
if R3XX=VIDEO
   goto,CREALISTVIEWVIDEO
if R3XX=PHOTO
   goto,CREALISTVIEWPHOTO
goto,Filllistpath2
return
;--------------------------------------------------------------------------



























;------------- PREDEFINE A FOLDER SEARCH FROM here ------------
MH1:
PRESELECT=%a_desktop%
FileSelectFolder,MF,%PRESELECT%
if MF=
  return
IniWrite,%MF%      , %rssini%  ,PREDEFINED FOLDER MUSIC , KEY1
return
;--------------------------------------------------------------








MH1TV:
PRESELECTVID=%a_desktop%
FileSelectFolder,MFVID,%PRESELECTVID%
if MFVID=
  return
IniWrite,%MFVID%      , %rssini%  ,PREDEFINED FOLDER VIDEO , KEY4
return
;--------------------------------------------------------------





MH1PHOTO:
PRESELECTPHOTO=%a_desktop%
FileSelectFolder,MFPHOTO,%PRESELECTPHOTO%
if MFPHOTO=
  return
IniWrite,%MFPHOTO%      , %rssini%  ,PREDEFINED FOLDER PHOTO , KEY4
return
;--------------------------------------------------------------







MH2:
EE1=
(
Description.....................

-create a predefined folder to search from here

-create an xy.m3u file shown in listview
 you can mark row (right date column) and play song from here (PLAY-button)
 (use mplayerc.exe when stopped jumps to the next song)
 music xy.mp3 or xy.wav dont need a player
 or just play xy.m3u when doubleclick on it

-record audio
-record radio with streamripper
)

msgbox,262208,INFO,%EE1%
return








;--------------- SELECT MUSICFOLDER ---------------------------------
MS1MUS:
IniRead, PRESELECT      , %rssini%  ,PREDEFINED FOLDER MUSIC , KEY1
FileSelectFolder,MF,%PRESELECT%
if MF=
  return

IniWrite,%MF%      , %rssini%  ,LASTSELECTED MUSIC , KEY3
gosub,crealistviewmusic
return
;-------------------------------------------------------------------







;--------------- SELECT VIDEOFOLDER ---------------------------------
MS1VID:
IniRead, PRESELECT      , %rssini%  ,PREDEFINED FOLDER VIDEO , KEY4
FileSelectFolder,MF,%PRESELECT%
if MF=
  return

IniWrite,%MF%      , %rssini%  ,LASTSELECTED VIDEO , KEY4
  gosub,crealistviewvideo
return
;-------------------------------------------------------------------







;--------------- SELECT PHOTOFOLDER ---------------------------------
MS1PHOTO:
IniRead, PRESELECT      , %rssini%  ,PREDEFINED FOLDER PHOTO , KEY4
FileSelectFolder,MF,%PRESELECT%
if MF=
  return

IniWrite,%MF%      , %rssini%  ,LASTSELECTED PHOTO , KEY4
  gosub,crealistviewPhoto
return
;-------------------------------------------------------------------












;-------------- create M3U sorted by date ---------------------
MFM3U:
FILE1=%A_temp%\filem3a.txt
FILE2=%A_temp%\filem3b.txt

IniRead, PRESELECT      , %rssini%  ,PREDEFINED FOLDER MUSIC , KEY1
FileSelectFolder,MF,%PRESELECT%
if MF=
  return

IniWrite,%MF%      , %rssini%  ,LASTSELECTED MUSIC , KEY3


SplitPath,MF, namex, dir, ext, NNE, drive
FILE3=%A_desktop%\%NNE%.m3u


ifexist,%FILE3%
  {
  filedelete,%FILE3%
  sleep,200
  }


FFV=mp3,wav,rm,wma
Loop, %MF%\*.*, 0,1
   {
   LR=%A_LoopFileFullPath%
   LN=%A_loopfiletimecreated%
   SplitPath,LR, namex, dir, ext, name_no_ext, drive
   if ext contains %FFV%
       {
       Fileappend,%LN%%LR%`r`n,%FILE1%
       mx++
       }
   }

if mx>0
  {
  ;AX1=about:blank
  ;DllCall("lbbrowse3\Navigate", "str",AX1)
  str=
  FileRead, Str,%FILE1%
  Sort, Str, U                     ; U removes duplicates
  FileAppend, %Str%,%FILE2%
  str=
    FileRead, Str, %FILE2%
        Loop, Parse, Str,`r,`n
            {
            stringmid,section,A_loopfield,15,200
            OutPut .= Section "`n"
            }

  FileAppend, %output%, %FILE3%
  ;run,%FILE3%
  output=
  filedelete,%FILE1%
  filedelete,%FILE2%
  gosub,crealistviewmusic
  }

return
;--------------------------------------------------------------










;=============================================================================
RECORDAUDIO:
IfNotExist %MX3%
   {
      MsgBox mixmp3.exe does not exist!
      return
   }

   stringreplace,name4,name5,%S%,_,all
   if name4=
      name4=%A_now%
   ifexist,%REC%\%name4%.mp3
      name4=%A_now%_%name4%
   Loop,%REC%,1
        SP2= %A_LoopFileShortPath%                ;shortpath for DOS command

   run,mixmp3.exe -b 128 %SP2%\%name4%,,min                     ;not hidden
   Process,wait,mixmp3.exe
   PID2 = %ErrorLevel%
   if ErrorLevel<>0
   GuiControl,2:Text,EditRecord,RECORD
return
;-----------------------------------------------------------

STOPMIX:
  ControlSend,,{ESCAPE},ahk_pid %PID2%
  GuiControl,2:Text,EditRecord,STOPPED
  process,close,%PID2%
RECORDED:
run,%REC%
return
;------------------------------------------------------------



























cleanup:
2Guiclose:

    ;-------- clear DLLHTML -----------
    W5=0
    H5=0
    DLLCall("lbbrowse3\MoveBrowser","Int",X2,"Int",Y2,"Int",W5,"Int",H5)
    ;DllCall("lbbrowse3\EnableBrowser","int",0)
    AX1=about:blank
    DllCall("lbbrowse3\Navigate", "str",AX1)
    sleep,100

    DllCall("lbbrowse3\DestroyBrowser")
    DllCall("FreeLibrary", "UInt", lbbHandle)
    sleep,100

process,close,%PID2%
process,close,%PID3%
process,close,%PIDX%
sleep,100
exitapp
;=================================================================================









;========================= CREATE TEST FILES ==========================================
CREATESTFILES:

;----------------- TELEVISION ALL BeeLineTV ----------------
ifnotexist,%R3Z%
   gosub,UpdateBeeLineTV


;----------------- YOUTUBE ----------------
;Filedelete,%R3Y%        ;Filedelete only for test
ifnotexist,%R3Y%
  {
  Fileappend,Vauraddi Xetkamti;http://www.youtube.com/watch?v=AVjlEWHaQO0;`r`n,%R3Ya%
  Fileappend,Flickan i Havanna;http://www.youtube.com/watch?v=82ZuxWbO8QY;`r`n,%R3Ya%
  }


;----------------- RADIO ----------------
;Filedelete,%R3R%        ;Filedelete only for test
ifnotexist,%R3R%
  {
  Fileappend,_RADIO DRS CH;http://www.drs.ch/drs.html;`r`n,%R3Ra%
  Fileappend,_RADIO Locator;http://www.radio-locator.com/cgi-bin/home;`r`n,%R3Ra%
  Fileappend,_RADIO Shoutcast;http://www.shoutcast.com;`r`n,%R3Ra%
  Fileappend,Country Heartland;;http://66.90.103.89:8042`r`n,%R3Ra%
  Fileappend,Japan;;http://www.nhk.or.jp:80/rj/on_demand/rj_channel_e/english.smi`r`n,%R3Ra%
  Fileappend,Portugal Fado;;http://195.101.34.4:8005`r`n,%R3Ra%
  Fileappend,AOL;;http://scfire-ntc-aa03.stream.aol.com/stream/1065`r`n,%R3Ra%
  Fileappend,DIFM;;http://www.di.fm/wma/hardstyle.asx`r`n,%R3Ra%
  Fileappend,FAROER RADIO;;mms://media.internet.fo/uf`r`n,%R3Ra%
  }


;----------------- TELEVISION FAVORIT ----------------
;Filedelete,%R3T%          ;Filedelete only for test
ifnotexist,%R3T%
  {
  /*
  Fileappend,`r`n,%R3Ta%
  Fileappend,`r`n,%R3Ta%
  Fileappend,`r`n,%R3Ta%
  Fileappend,`r`n,%R3Ta%
  Fileappend,`r`n,%R3Ta%
  Fileappend,`r`n,%R3Ta%
  Fileappend,`r`n,%R3Ta%
  Fileappend,`r`n,%R3Ta%
  Fileappend,`r`n,%R3Ta%
  */
  Fileappend,_TELEVISION Program CH;http://www.20min.ch/unterhaltung/tv_guide/;`r`n,%R3Ta%
  Fileappend,_TELEVISION;http://www.wwitv.com/portal.htm?http://www.wwitv.com/television/index.html;`r`n,%R3Ta%
  Fileappend,DK_Danmark;;http://www.dr.dk/forside_ny/global/spot/images/update.asx?qid=288417&odp=true&bitrate=high&bitrate=high`r`n,%R3Ta%
  Fileappend,H_DUNA;;http://80.249.168.221/dunatv`r`n,%R3Ta%
  Fileappend,H_HIRTV;;mms://streamer.hirtv.net/hirtv.asf`r`n,%R3Ta%
  Fileappend,LU_Luxembourg;;mms://streaming.newmedia.lu/telehighres`r`n,%R3Ta%
  Fileappend,P_RTPi 400;;http://127.0.0.1:6498/ms2/1213987018765/0MediaPlayer+0+/octoshape+h+RTP.400/RTP400?MSWMExt=.asf`r`n,%R3Ta%
  Fileappend,SK_BRATISLAVA;;mms://81.89.49.210/tvbalive`r`n,%R3Ta%
  Fileappend,SRILANKA Music;;mms://220.247.224.106/swarnavahini`r`n,%R3Ta%
  Fileappend,Belarus _Belarus TV;;mms://bcast.tvr.by/video`r`n,%R3Ta%
  Fileappend,F_France _France 24;;mms://live.france24.com/france24_fr.wsx`r`n,%R3Ta%
  Fileappend,Japan _Yomiuri News;;http://www.yomiuri.co.jp/stream/vnews/vnews-w.asx`r`n,%R3Ta%
  Fileappend,NL_Netherlands NOS Journaal 24;;mms://livemedia2.omroep.nl/nosjournaal24-bb`r`n,%R3Ta%
  Fileappend,RADIO AOL;;http://scfire-ntc-aa03.stream.aol.com/stream/1065`r`n,%R3Ta%
  Fileappend,RADIO DIFM;;http://www.di.fm/wma/hardstyle.asx`r`n,%R3Ta%
  Fileappend,RADIO FAROER;;mms://media.internet.fo/uf`r`n,%R3Ta%
  Fileappend,NL_TEQUILA TEST1;http://www.bnn.nl/page/tequila;`r`n,%R3Ta%
  Fileappend,NL_TEQUILA TEST2;http://www.bnn.nl/page/tequila;http://cgi.omroep.nl/cgi-bin/streams?/id/BNN/serie/POW_00133944/POW_00133951/bb.20071102.asf`r`n,%R3Ta%
  Fileappend,NL_TEQUILA01;;http://cgi.omroep.nl/cgi-bin/streams?/tv/bnn/tequila/bb.20061117.asf`r`n,%R3Ta%
  Fileappend,NL_TEQUILA02;;http://cgi.omroep.nl/cgi-bin/streams?/tv/bnn/tequila/bb.20061124.asf`r`n,%R3Ta%
  Fileappend,NL_TEQUILA03;;http://cgi.omroep.nl/cgi-bin/streams?/tv/bnn/tequila/bb.20061201.asf`r`n,%R3Ta%
  Fileappend,NL_TEQUILA04;;http://cgi.omroep.nl/cgi-bin/streams?/tv/bnn/tequila/bb.20061208.asf`r`n,%R3Ta%
  Fileappend,NL_TEQUILA05;;http://cgi.omroep.nl/cgi-bin/streams?/tv/bnn/tequila/bb.20061215.asf`r`n,%R3Ta%
  Fileappend,NL_TEQUILA06;;http://cgi.omroep.nl/cgi-bin/streams?/tv/bnn/tequila/bb.20061222.asf`r`n,%R3Ta%
  Fileappend,NL_TEQUILA07;;http://cgi.omroep.nl/cgi-bin/streams?/tv/bnn/tequila/bb.20070105.asf`r`n,%R3Ta%
  Fileappend,NL_TEQUILA11;;http://cgi.omroep.nl/cgi-bin/streams?/id/BNN/serie/POW_00133944/POW_00133945/bb.20070921.asf`r`n,%R3Ta%
  Fileappend,NL_TEQUILA12;;http://cgi.omroep.nl/cgi-bin/streams?/id/BNN/serie/POW_00133944/POW_00133946/bb.20070928.asf`r`n,%R3Ta%
  Fileappend,NL_TEQUILA13;;http://cgi.omroep.nl/cgi-bin/streams?/id/BNN/serie/POW_00133944/POW_00133947/bb.20071005.asf`r`n,%R3Ta%
  Fileappend,NL_TEQUILA14;;http://cgi.omroep.nl/cgi-bin/streams?/id/BNN/serie/POW_00133944/POW_00133948/bb.20071012.asf`r`n,%R3Ta%
  Fileappend,NL_TEQUILA15;;http://cgi.omroep.nl/cgi-bin/streams?/id/BNN/serie/POW_00133944/POW_00133949/bb.20071019.asf`r`n,%R3Ta%
  Fileappend,NL_TEQUILA16;;http://cgi.omroep.nl/cgi-bin/streams?/id/BNN/serie/POW_00133944/POW_00133950/bb.20071026.asf`r`n,%R3Ta%
  Fileappend,NL_TEQUILA17;;http://cgi.omroep.nl/cgi-bin/streams?/id/BNN/serie/POW_00133944/POW_00133951/bb.20071102.asf`r`n,%R3Ta%
  Fileappend,A-Steiermark;http://tv.orf.at/ondemand/;mms://stream2.orf.at/radiosteiermark/st_heute_WEEKDAYD.wmv`r`n,%R3Ta%
  Fileappend,KOREA;;mms://61.80.90.52/vod`r`n,%R3Ta%
  Fileappend,A_AUSTRIA;http://tv.orf.at/ondemand/;`r`n,%R3Ta%
  Fileappend,A_BURGENLAND;http://your.orf.at/bheute/player.php?id=bgl;mms://stream2.orf.at/radiobgl/bheute_WEEKDAYD.wmv`r`n,%R3Ta%
  Fileappend,VIETNAM VTC1;;mms://phim2.bonghongxanh.vn:556/VTC1_01`r`n,%R3Ta%
  Fileappend,NL_HILVERSUM;;mms://livemedia.omroep.nl/nos_hilversumbest-bb`r`n,%R3Ta%
  Fileappend,C_CESKA;;mms://stream3a.visual.cz/CT24-High`r`n,%R3Ta%
  Fileappend,RU_VESTI24;;mms://video.rfn.ru/vesti_24`r`n,%R3Ta%
  Fileappend,NL_UITZENDINGGEMIST;http://www.uitzendinggemist.nl/index.php;`r`n,%R3Ta%
  Fileappend,CH_SWITZERLAND;http://www.sf.tv/var/videos.php;`r`n,%R3Ta%
  Fileappend,D_ARD;http://www.daserste.de/plusminus/archiv.asp;`r`n,%R3Ta%
  Fileappend,D_ZDF;http://frontal21.zdf.de/ZDFde/inhalt/1/0,1872,1001633,00.html?dr=1;`r`n,%R3Ta%
  Fileappend,D_NDR;;mms://213.254.239.66/ndrfernsehen$ndr_hh`r`n,%R3Ta%
  Fileappend,RADIO KOPER OCTOSHAPE;http://www.rtvslo.si/;http://127.0.0.1:6498/ms2/1217572603847/0MediaPlayer+0+/octoshape+h+RTVSLO.Koper/RTVSLOKoper?MSWMExt=.asf`r`n,%R3Ta%
  }


;------------------------------ LINKS --------------------------
;Filedelete,%R3S%               ;Filedelete only for test
ifnotexist,%R3S%
  {
  Fileappend,MUSIC ILIKE;http://www.ilike.com/artist/search?artist_qp=SRCHXX&x=0&y=0;`r`n,%R3Sa%
  Fileappend,MUSIC JANGO;http://www.jango.com;`r`n,%R3Sa%
  Fileappend,SEARCH SEARCHME;http://www.searchme.com/#/0/&pi=4/&q=SRCHXX/&ci=all/&session=EE1AB58B28A9F8E9A5776449F1172653276BEE5F/&vs=searchState/;`r`n,%R3Sa%
  Fileappend,SEARCH WIKI POWERSET;http://www.powerset.com/explore/pset?q=SRCHXX&submit.x=0&submit.y=0;`r`n,%R3Sa%
  Fileappend,SEARCH0 CUIL;http://www.cuil.com/search?q=SRCHXX;`r`n,%R3Sa%
  Fileappend,SEARCH LYRICS SOUND2LIGHT english;http://sound2light.net/LETTERXX/LYRICSXX_lyrics.html;`r`n,%R3Sa%
  Fileappend,SEARCH0 YAHOO;http://search.yahoo.com/search?p=SRCHXX;`r`n,%R3Sa%
  Fileappend,SEARCH MININOVA;http://www.mininova.org/search/?search=SRCHXX;`r`n,%R3Sa%
  Fileappend,SEARCH BOARDREADER;http://boardreader.com/s/SRCHXX.html?d=0&group_mode=post;`r`n,%R3Sa%
  Fileappend,SEARCH0 LIVE;http://search.live.com/results.aspx?q=SRCHXX&go=&form=QBLH;`r`n,%R3Sa%
  Fileappend,SEARCH0 ASK;http://www.ask.com/web?q=SRCHXX&qsrc=0&o=0&l=dir;`r`n,%R3Sa%
  Fileappend,MAP CH;http://map.search.ch/SRCHXX;`r`n,%R3Sa%
  Fileappend,MAP GOOGLE;http://maps.google.de/maps?complete=1&hl=de&q=`%22SRCHXX`%22&oe=UTF-8&um=1&ie=UTF-8&sa=N&tab=wl;`r`n,%R3Sa%
  Fileappend,WEATHER;http://search.yahoo.com/search?p=weather+SRCHXX&fr=yfp-t-501&toggle=1&cop=mss&ei=UTF-8&vc=;`r`n,%R3Sa%
  Fileappend,VIDEO GOOGLE;http://video.google.de/videosearch?q=SRCHXX;`r`n,%R3Sa%
  Fileappend,VIDEO TRUVEO;http://www.truveo.com/tag/SRCHXX;`r`n,%R3Sa%
  Fileappend,VIDEO NME;http://www.nme.com/video/search/SRCHXX;`r`n,%R3Sa%
  Fileappend,NEWS CH;http://news.google.de/news?ned=de_ch;`r`n,%R3Sa%
  Fileappend,BOOK GOOGLE;http://www.google.de/books?q=`%22SRCHXX`%22;`r`n,%R3Sa%
  Fileappend,VIDEO YAHOO;http://video.search.yahoo.com/search/video?ei=UTF-8&p=`%22SRCHXX`%22;`r`n,%R3Sa%
  Fileappend,MUSIC YAHOO;http://audio.search.yahoo.com/search/audio?ei=UTF-8&p=`%22SRCHXX`%22;`r`n,%R3Sa%
  Fileappend,NEWS YAHOO;http://news.search.yahoo.com/search/news?ei=UTF-8&p=`%22SRCHXX`%22&datesort=1;`r`n,%R3Sa%
  Fileappend,FOTO GOOGLE;http://images.google.de/images?complete=1&hl=de&q=`%22SRCHXX`%22&oe=UTF-8&um=1&ie=UTF-8&sa=N&tab=li;`r`n,%R3Sa%
  Fileappend,VIDEO YOUTUBE;http://www.youtube.com/results?search_query=SRCHXX&search=Search;`r`n,%R3Sa%
  Fileappend,NEWS-e ALTAVISTA;http://www.altavista.com/news/results?q=SRCHXX&nc=0&nr=0&nd=4&sort=date;`r`n,%R3Sa%
  Fileappend,NEWS DOGPILE;http://www.dogpile.com/dogpile/ws/results/News/!22SRCHXX!22/1/417/TopNavigation/Relevance/iq=true/zoom=off/_iceUrlFlag=7?_IceUrl=true;`r`n,%R3Sa%
  Fileappend,all in URL;http://www.google.com/search?hl=de&q=allinurl:SRCHXX;`r`n,%R3Sa%
  Fileappend,all in title;http://www.google.com/search?hl=de&q=allintitle:SRCHXX;`r`n,%R3Sa%
  Fileappend,all in text;http://www.google.com/search?hl=de&q=allintext:SRCHXX;`r`n,%R3Sa%
  Fileappend,all in define;http://www.google.com/search?hl=de&q=define:SRCHXX;`r`n,%R3Sa%
  Fileappend,MUSIC ALTAVISTA;http://www.altavista.com/audio/results?itag=ody&q=`%22SRCHXX`%22&maf=mp3&maf=wav&maf=msmedia&maf=realmedia&maf=aiff&maf=other&mad=long;`r`n,%R3Sa%
  Fileappend,VIDEO ALTAVISTA;http://www.altavista.com/video/results?itag=ody&q=`%22SRCHXX`%22&mvf=mpeg&mvf=avi&mvf=qt&mvf=msmedia&mvf=realmedia&mvf=flash&mvf=other&mvd=long;`r`n,%R3Sa%
  Fileappend,FOTO FLICKR;http://www.flickr.com/search/?q=`%22SRCHXX`%22&ct=0;`r`n,%R3Sa%
  Fileappend,FOTO ALTAVISTA;http://www.altavista.com/image/results?itag=ody&q=`%22SRCHXX`%22&mik=photo&mik=graphic&mip=all&mis=all&miwxh=all;`r`n,%R3Sa%
  Fileappend,SEARCH0 ALTAVISTA;http://www.altavista.com/web/results?itag=ody&q=`%22SRCHXX`%22&kgs=0&kls=0;`r`n,%R3Sa%
  Fileappend,SEARCH0 DOGPILE;http://www.dogpile.com/info.dogpl/search/web/SRCHXX/1/100/1/-/-/-/1/-/-/-/1/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/417/top/-/-/-/1;`r`n,%R3Sa%
  Fileappend,SEARCH0 REFERENCE;http://www.reference.com/search?q=SRCHXX&db=web;`r`n,%R3Sa%
  Fileappend,SEARCH0 YZOO;http://yzoo.co.uk/searches/web/SRCHXX.xml;`r`n,%R3Sa%
  Fileappend,SEARCH0 GOOGLE EN;http://www.google.com/search?complete=1&q=SRCHXX&btnG=Google+%E6%90%9C%E7%B4%A2&meta=;`r`n,%R3Sa%
  Fileappend,SEARCH0 GOOGLE DE;http://www.google.de/search?complete=1&hl=de&q=SRCHXX&btnG=Google+%E6%90%9C%E7%B4%A2&meta=;`r`n,%R3Sa%
  Fileappend,SEARCH0 WIKI REFERENCE;http://www.reference.com/browse/wiki/SRCHXX;`r`n,%R3Sa%
  Fileappend,VIDEO IXQUICK;http://eu2.ixquick.com/do/metasearch.pl?cat=video&cmd=process_search&language=deutsch&query=`%22SRCHXX`%22&ff=;`r`n,%R3Sa%
  Fileappend,VIDEO VEOH;http://www.veoh.com/search.html?search=`%22SRCHXX`%22&searchId=6317178689186663424;`r`n,%R3Sa%
  Fileappend,VIDEO TV-OCTOSHAPE;http://www.octoshape.com/play/play.asp?lang=de;`r`n,%R3Sa%
  Fileappend,VIDEO TV-MEDIA_ARCHIVE;http://online-media-archive.net/tv/browse.php?;`r`n,%R3Sa%
  Fileappend,VIDEO WWI-TV;http://wwitv.com/portal.htm;`r`n,%R3Sa%
  Fileappend,VIDEO TV-CHANNELSFREE;http://www.tvchannelsfree.com/;`r`n,%R3Sa%
  Fileappend,VIDEO TV-CHANNELCHOOSER;http://www.channelchooser.com/;`r`n,%R3Sa%
  Fileappend,VIDEO BeeLine-TV;http://beelinetv.com/;`r`n,%R3Sa%
  Fileappend,VIDEO TV-InnerLive;http://www.inner-live.com/;`r`n,%R3Sa%
  Fileappend,VIDEO TV-Global-ITV;http://www.global-itv.com/;http://www.global-itv.com/;`r`n,%R3Sa%
  Fileappend,REGEX PhiLho;http://phi.lho.free.fr/programming/RETutorial.en.html;`r`n,%R3Sa%
  Fileappend,FlickrVision;http://flickrvision.com/;`r`n,%R3Sa%
  Fileappend,REGEX;http://gskinner.com/RegExr/;`r`n,%R3Sa%
  Fileappend,_RADIO Locator;http://www.radio-locator.com/cgi-bin/home;`r`n,%R3Sa%
  Fileappend,_RADIO Shoutcast;http://www.shoutcast.com;`r`n,%R3Sa%
  Fileappend,_TELEVISION;http://www.wwitv.com/portal.htm?http://www.wwitv.com/television/index.html;`r`n,%R3Sa%
  Fileappend,_RADIO DRS CH;http://www.drs.ch/drs.html;`r`n,%R3Sa%
  Fileappend,_TELEVISION Program CH;http://www.20min.ch/unterhaltung/tv_guide/;`r`n,%R3Sa%
  Fileappend,PANDORA;http://www.pandora.com;`r`n,%R3Sa%
/*
  Fileappend,`r`n,%R3Sa%
  Fileappend,`r`n,%R3Sa%
  Fileappend,`r`n,%R3Sa%
  Fileappend,`r`n,%R3Sa%
  Fileappend,`r`n,%R3Sa%
  Fileappend,`r`n,%R3Sa%
  Fileappend,`r`n,%R3Sa%
  Fileappend,`r`n,%R3Sa%
  Fileappend,`r`n,%R3Sa%
  Fileappend,`r`n,%R3Sa%
  Fileappend,`r`n,%R3Sa%
*/
  }

return
;======================================================================================================================











UpdateBeeLineTV:
;================ URLDOWNLOAD SEARCH TV LINKS from    http://beelinetv.com/  =======
;-----------------------------------------------------------------------------------
/*
DATE............2006-07-30 garry
MODIFIED........2008-06-17
NAME............urldownload_extract.ahk
USAGE...........extract mms://
................http://beelinetv.com/
*/
;------------------------------------------------------------------------------------

F21 =%A_SCRIPTDIR%\extract01.txt
F22 =%A_SCRIPTDIR%\extract02.txt

Filedelete,%F21%
Filedelete,%F22%
Filedelete,%R3Z%


URL21=http://beelinetv.com/         ;extract from this url
urldownloadtofile,%URL21%,%F21%

;-------------------------------------------------

VANAF1=<a class="lis" target="_blank" href="
UNTIL1=">Media<

;<a class="bit" href="mms://stream.jrtv.jo/jrtv">288</a>
;<a class="lis" target="_blank" href="http://www.jrtv.gov.jo/jrtv/index.php">Jordan TV</a>, Jordan
;<a class="lir" href="mms://stream.jrtv.jo/jrtv">Media</a><br>

stringlen,L1,vanaf1
L1:=L1+1

   Loop,Read,%F21%
      {
      LR=%A_LoopReadLine%
             {
             StringGetPos,VAR1,LR,%VANAF1%
             StringGetPos,VAR2,LR,%UNTIL1%
             VAR1:=(VAR1+L1)
             VAR2:=(VAR2+1)
             VAR3:=(VAR2-VAR1)
             stringmid,ADRESS,LR,VAR1,VAR3
             if adress=
                continue
             K++
             Fileappend,%ADRESS%%UNTIL1%`r`n,%F22%
             }
      }


;http://www.trt.net.tr/">TRT 1</a>, Turkey <a class="lir" href="mms://212.175.166.3/TV1">Media<
;SIZE2=50*42

   Loop,Read,%F22%
      {
      LR=%A_LoopReadLine%
             {
             stringsplit,B,LR,`"
             stringsplit,G,B2,`>
             stringsplit,H,B2,`<
             stringreplace,G2,G2,</a,%nothing%,all
             stringreplace,H2,H2,/a>`,,%nothing%,all
             GX=%H2%_%G2%
             stringreplace,B5,B5,&amp`;,&,all
             Fileappend,%GX%;%B1%;%B5%`r`n,%R3Z%
             ;Albania _Rrokum TV;http://www.rrokum.tv/;mms://82.114.65.202:255/
             }
      }

msgbox,TV_Links are updated from BeeLineTV >>`n%R3Za%
R3XX=%R3Z%
gosub,Filllistpath2
return
;==========================================================================================================















;============================== YOUTUBE ==================================
;------------------------------ GETTITLE and 2nd-URL ----------------------
PLAYYOUTUBE:
YOUTUBETEST=1
DOWNLOAD1:
Gui,2:submit,nohide
GuiControl,2:Text,AL1,

Guicontrolget,EditYoutube,2:
if EditYoutube contains http://www.youtube.com/watch?v=
   URL1=%EditYoutube%

;msgbox,URL1=%URL1%
;return

if URL1=
   return
if URL1 not contains http://www.youtube.com/watch?v=
   return

URL2=
TITLE=
new2=

F1  =%A_scriptdir%\YTB1.txt
UrlDownloadToFile,%URL1%,%F1%

   Fileread,AA,%F1%
   stringreplace,AA,AA,%TEN%,%CF%,all
   filedelete,%F1%
   Fileappend,%AA%`r`n,%F1%
;var fullscreenUrl = '/watch_fullscreen?fs=1&vq=None&video_id=AVjlEWHaQO0&l=301&sk=0U5dsOnMX-hSUqtuX0TNflVN-O6wGvd6C&fmt_map=6%2F720000%2F7%2F0%2F0&t=OEgsToPDskLVSAExE7V7PL8W1Lm8F8G-&hl=en&plid=AARQCI6JdYDNn7g4AAACIAAQAAA&title=EKVAT-Gala RTP Dança Comigo';

CONTEN=var fullscreenUrl =
;VANAF1=watch_fullscreen?fs=1&e=h&video_id=
VANAF1=&video_id=
;UNTIL1=&hl=
UNTIL1=&title=
VANAF2=&title=
UNTIL2=';


V=0
   Loop,Read,%F1%
      {
      LR=%A_LoopReadLine%
      ifinstring,LR,%CONTEN%
             {
             StringGetPos,VAR1,LR,%VANAF1%
             StringGetPos,VAR2,LR,%UNTIL1%
             VAR1:=(VAR1+11)
             VAR2:=(VAR2+1)
             VAR3:=(VAR2-VAR1)
             VAR4=http://www.youtube.com/get_video?video_id=
             stringmid,ADRESS,LR,VAR1,VAR3
             URL2=%VAR4%%ADRESS%                         ;<<<< new adress URL2
             ;msgbox,url2=%URL2%
             ;return

             StringGetPos,VAR11,LR,%VANAF2%
             StringGetPos,VAR12,LR,%UNTIL2%
             VAR11:=(VAR11+8)
             VAR12:=(VAR12+1)
             VAR13:=(VAR12-VAR11)
             stringmid,TITLE,LR,VAR11,VAR13

             stringreplace,TITLE,TITLE,quot,%S%,all
             stringreplace,TITLE,TITLE,&quot,%S%,all
             stringreplace,TITLE,TITLE,&amp,%S%,all
             ;stringreplace,TITLE,TITLE,-,%S%,all
             stringreplace,TITLE,TITLE,ç,c,all
             stringreplace,TITLE,TITLE,é,e,all
             stringreplace,TITLE,TITLE,è,e,all
             stringreplace,TITLE,TITLE,ñ,n,all
             stringreplace,TITLE,TITLE,ã,a,all

             stringreplace,TITLE,TITLE,Ã§,c,all     ;ç
             stringreplace,TITLE,TITLE,Ã£,a,all     ;ã
             stringreplace,TITLE,TITLE,Ã¶,oe,all    ;ö
             stringreplace,TITLE,TITLE,Ã©,e,all     ;é
             stringreplace,TITLE,TITLE,Ã,a,all      ;à

             ;F2=%TITLE%.flv                             ;<<<< found name
               break
             }
        }

; ---  in name should be removed all special characters
gosub,removechr
;msgbox,new2=%new2%  F2=%F2%

Fileappend,%New2%;%URL1%;%URL2%`r`n,%R3Wa%
R3XX=%R3W%
  gosub,filllistpath2
GuiControl,2:Text,AL1,%new2%

if YOUTUBETEST=1
   {
   YOUTUBETEST=0
   gosub,BACKGROUND1
   C3=%URL1%
   stringreplace,C3,C3,/watch?v=,/v/,all

   aa4=
   (
   <object width="%W2%" height="%H2%"> <param name="movie" value="%C3%"> </param> <embed src="%C3%" type="application/x-shockwave-flash" width="%W2%" height="%H2%"> </embed> </object>
   )

   gosub,skip2
   DLLCall("lbbrowse3\MoveBrowser","Int",X2,"Int",Y2,"Int",W2,"Int",H2)
   DllCall("lbbrowse3\Navigate", "str",M3)
   return
   }
;-----------------------------------------------------------------------------------


;-------------------------- DOWNLOAD YOUTUBE VIDEO ---------------------------------
DOWNLOAD2:
YTBDNL:
if URL2=
   {
   msgbox, YOUTUBE URL to download is missing
   return
   }


;Splashimage,,b w600 h30  CWlime m9 b fs10 zh0,DOWNLOAD >>> %F2%
SplashImage,Download,CWLIME x%X15% y%Y27% h40 w800 m2,DOWNLOAD >>> %F2%
URLDownloadToFile,%URL2%,%REC%\%F2%
Splashimage, off

W3:=(W2)
H3:=(H2)


C3=file:///%REC%\%F2%
 stringsplit,GX,F2,`.
 name1=%GX1%

    ;-------- clear DLLHTML -----------
    W5=0
    H5=0
    DLLCall("lbbrowse3\MoveBrowser","Int",X2,"Int",Y2,"Int",W5,"Int",H5)
    ;DllCall("lbbrowse3\EnableBrowser","int",0)
    AX1=about:blank
    DllCall("lbbrowse3\Navigate", "str",AX1)
    sleep,100

goto,skip1
return
;----------------------------------------------------------------------------------





;---------- GOSUB remove special characters from video name ----------------------
REMOVECHR:
autotrim,off
new2=
Loop,Parse,TITLE
         {
         A:=(Asc(A_LoopField))
         B:=chr(a)
         if (B="_" OR B=" " OR B="-")     ;allow _space   autotrim,off
         Goto,SKIP8
         if ((a<48 or a>57) AND A<65 OR A>90 AND A<97 OR A>122)
         continue
         SKIP8:
         new2=%new2%%b%
         }


    stringmid,ANOW1,A_NOW,1,12    ;not readable chinese...
    if new2=
       {
       new3=_%ANOW1%.flv
       F2=%new3%
       return
       }


  new3=%new2%.flv
  F2=%new3%
  ifexist,%REC%\%F2%
      F2=_%ANOW1%_%F2%
return
;========================  END YOUTUBE ============================================













;=============================== DATECHECK REPLACE YEAR4... ===================================
;----------------------------
DATECHECK:                        ;10v10 mo-fr  after 22:00
;mms://82.102.11.10/videostpa/telejornal2008-06-09.wmv
;BX6=rtsp://62.2.180.200:554/sfdrs/vod/10vor10/YEAR4/MONTH2/450k/10vor10_YEAR4MONTH2DAY2.rm
BX6=%C3%

DCCC=1

gosub,datecalc
   if FFF=bigger
         {
         msgbox,You selected date newer then today
         goto,break1
         }


if wday1=1
    {
    WD11=sonntag
    WD21=sunday
    }

if wday1=2
    {
    WD11=montag
    WD21=monday
    }

if wday1=3
    {
    WD11=dienstag
    WD21=tuesday
    }

if wday1=4
    {
    WD11=mittwoch
    WD21=wednesday
    }

if wday1=5
    {
    WD11=donnerstag
    WD21=thursday
    }

if wday1=6
    {
    WD11=freitag
    WD21=friday
    }

if wday1=7
    {
    WD11=samstag
    WD21=saturday
    }



/*
   if (wday1=1 or wday1=7)     ;never on sunday or saturday
     {
     WD=weekend
     msgbox,You selected %WD%`r`nTV not available on saturday/sunday`r`nSelect a weekday
     goto,break1
     }

            if FFF=equal              ;if today
              {
              if H2<22
                 {
                 msgbox,10v10 after 22:00 (GMT +1 )
                 goto,break1
                 }
              }
*/

AASC1=0
AASC=YEAR4,YEAR2,MONTH2,DAY2,WEEKDAYD,WEEKDAYE
if BX6 contains %AASC%
   AASC1=1



            stringreplace,BX6,BX6,YEAR4    ,%Y4%,all
            stringreplace,BX6,BX6,YEAR2    ,%Y2%,all
            stringreplace,BX6,BX6,MONTH2   ,%M2%,all
            stringreplace,BX6,BX6,DAY2     ,%D2%,all

            stringreplace,BX6,BX6,WEEKDAYD  ,%WD11%,all
            stringreplace,BX6,BX6,WEEKDAYE  ,%WD21%,all

if AASC1=1
  {
  msgbox, 262147,DATE CALCULATION,you selected for`n %C3%`n %BX6%`n  WD11=%WD11% WD21=%WD21% WDAY1=%WDAY1%`nWant you start this TV channel ?
  ifmsgbox,cancel
       {
       DCCC=0
       return
       }

  ifmsgbox,NO
       {
       DCCC=0
       return
       }

  }

C3=%BX6%

;  GuiControlGet,CB1,2:
;if CB1=1
;  run,"%A_ProgramFiles%\VideoLAN\VLC\vlc.exe" "%C3%"
;else

  gosub,skip1
return
;-----------------------------------------------------


DATECALC:
Gui,2:submit,nohide
            FFF=
            BD1=%Mydate2%
            AN1=%A_NOW%
            FormatTime,wDAY1,%BD1%,wDay
              stringmid,BD2,BD1,1,8   ;selected
              stringmid,AN2,AN1,1,8   ;today
                stringmid,H2,AN1,9,2
                stringmid,Y4,BD2,1,4
                stringmid,Y2,BD2,3,2
                stringmid,M2,BD2,5,2
                stringmid,D2,BD2,7,2
                BD2:=BD2
                AN2:=AN2
                     if (BD2>AN2)
                         FFF=bigger
                     if (BD2<AN2)
                         FFF=smaller
                     if (BD2=AN2)
                         FFF=equal
return
;-------------------------------------------------
;============================== END DATECHECK ===========================





















;================= DOWNLOAD lbbrowse3.dll==========================================
LBBROWSE3:
{
   text31=
(
This ahk-script needs lbbrowse3.dll

Download
-lbbrowse3.dll

from
http://www.alycesrestaurant.com/lbbrowse.htm

Want you download this program ?
)
msgbox, 262180, Start URL,%text31%
ifmsgbox,NO
   {
   exitapp
   return
   }
else
   {
   ;run,http://www.alycesrestaurant.com/lbbrowse.htm
   run,http://www.alycesrestaurant.com/zips/browsdll3.zip
   exitapp
   return
   }
}
return
;============================================================================






esc::
   {
   SDL=1
   process,close,%PIDX%

    GuiControl,2:Enable,PLAY5
    Gui,2: Add, Text   ,               x%PLAYX%    y%PLAYY%    w%PLAYW%    h%PLAYH% cWhite center BackgroundTrans,<PLAY
    Gui,2: Add, Text   ,               x%PLAYX%    y%PLAYY%    w%PLAYW%    h%PLAYH% cWhite center BackgroundTrans,<PLAY

    GuiControl,2:Enable,BREAK5
    Gui,2: Add, Text   ,               x%BREAKX%   y%BREAKY%   w%BREAKW%   h%BREAKH% cWhite center BackgroundTrans,<BREAK
    Gui,2: Add, Text   ,               x%BREAKX%   y%BREAKY%   w%BREAKW%   h%BREAKH% cWhite center BackgroundTrans,<BREAK

   return
   }
