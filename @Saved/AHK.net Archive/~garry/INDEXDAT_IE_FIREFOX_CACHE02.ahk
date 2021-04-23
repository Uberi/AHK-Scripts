DATEMOD=20071117

/*

      SHORT DESCRIPTION
      -----------------
      download pasco.exe/cygwin1.dll > http://www.foundstone.com/us/resources/proddesc/pasco.htm

      start this script

      menu
      1-INDEX-DAT-SEARCH (once)  >  then doubleclick on ----- \Temporary Internet Files\Content.IE5\index.dat
        if you want always just read from here (MS-IE)  use only the REFRESH button


      *******
      example if you use MS-IE
      if you want download shown video files from youtube, select video, click REFRESH and see links, download by doubleclick column2



      *******
      example if you use FIREFOX   ( look first for the correct path for variable AA2)
        C:\.......\Mozilla\Firefox\Profiles\kjf29nqa.default\Cache

      MP3/FLV from FIREFOX    < push Button    > you see the files in C:\_REC_FIREFOX_CACHE
         example: while listening music in  http://www.jango.com     the songs  are saved
                  while watching  video in  http://www.youtube.com   the videos are saved


*/




/*
DATE.......................2006-10-16 garry
NAME.......................IndexDat_IE_FIREFOX_CACHE02.ahk
ADD-PROG...................run,http://www.foundstone.com/us/resources/proddesc/pasco.htm

...........................C:\......\Temporary Internet Files\Content.IE5\index.dat
german =   C:\Dokumente und Einstellungen\Administrator\Lokale Einstellungen\Temporary Internet Files\Content.IE5\index.dat
...........................http://www.autohotkey.net/~garry/INDEXDAT_FIREFOX02.jpg

*/


#NoEnv
#NoTrayIcon
setworkingdir, %a_scriptdir%



;------- this is the path for FIREFOX searches for xy.flv and xy.mp3 -----------------------------
;-------
AA2=C:\Dokumente und Einstellungen\Administrator\Lokale Einstellungen\Anwendungsdaten\Mozilla\Firefox\Profiles\kjf29nqa.default\Cache


ifnotexist,%AA2%
 {
 msgbox,If use Firefox`nSearch for the correct path in (example):`nC:\.....\Mozilla\Firefox\Profiles\kjf29nqa.default\Cache
 exitapp
 return
 }

else
   {
R3CACHE=C:\_REC_FIREFOX_CACHE     ;copies found mp3/flv here
ifnotexist,%R3CACHE%
FileCreateDir,%R3CACHE%
    }






NPEX=0
ifnotexist,pasco.exe
  NPEX=1
ifnotexist,cygwin1.dll
  NPEX=1
if NPEX=1
{
   text31=
(
Download first for MS-IE
-pasco.exe
-cygwin1.dll

from
http://www.foundstone.com/us/resources/proddesc/pasco.htm

Want you download Pasco.exe and cygwin1.dll for MS-IE ?
)
msgbox, 262180, Pasco Download,%text31%
ifmsgbox,NO
   {
   exitapp
   return
   }
else
   {
   run,http://www.foundstone.com/us/resources/proddesc/pasco.htm
   exitapp
   return
   }
}





;-------------------------------------------------------------------------------------------------

F1=index.txt
transform,S,chr,127
transform,S1,chr,32

Gui,1:Color, 000000
Gui,1:Font,  CDefault , FixedSys


   menu,S1,Add,&How to use    ,MH1
   menu,S1,Add,&About         ,MH2
   menu,S1,Add,Run www.autohotkey.com,MH3
   menu,S1,Add,Download pasco.exe and cygwin.dll ,MH4
   menu,S1,Add,Firefox-Cache(dont move)  ,MH5
   menu,S1,Add,Last INDEX.DAT ,MH6

   menu,S2,Add,Index-DAT search (once) ,MH11


   menu,myMenuBar,Add,Help,:S1
   menu,myMenuBar,Add,Index-DAT search (once),:S2

   gui,1:menu,MyMenuBar


T1= 50
T2=910
T3=0         ;modified time
T4=160       ;access time
T5=0
T6=0
T7=0

T1A :=T1
T2A :=T1+T2
T3A :=T1+T2+T3
T3Ac:=(T3A+20)
T4A :=T1+T2+T3+T4
T5A :=T1+T2+T3+T4+T5
T6A :=T1+T2+T3+T4+T5+T6
T7A :=T1+T2+T3+T4+T5+T6+T7
T7AL:=T1+T2+T3+T4+T5+T6+T7+20  ;listview width
T7AG:=T7A+30                   ;guishow width
T7B1:=T7A-70                   ;xPosition Button1
T7B2:=T7A-160                  ;xPosition Button2

Gui,1:Add,ListView,grid r19 y20 w%T7AL% +hscroll altsubmit vMyListView gMyListView, TYPE|URL|MOD-TIME|ACC-TIME|FILENAME|DIRECTORY|HTTP HEADERS

Gui,1:Add,Button, x490    y420  w50  h20 gGO,<GO

Gui,1:Add,Button, x490    y450  w50  h20 gBACK,BACK
Gui,1:Add,Button, x550    y450  w90  h20 gREFRESH      ,REFRESH
Gui,1:Add,Button, x650    y450  w100 h20 gINDEXDAT     ,INDEX-DATS

Gui,1:Add,Button,x70     y477  w170 h20 gFIREFOXCACHE,MP3FLV from FIREFOX

Gui,1:Add,Button,      x900   y420      h20  w120  gYOUTUBE ,YOUTUBE
Gui,1:Add,Button,      x900   y450      h20  w120  gDADX    ,DADX
Gui,1:Add,Button,      x900   y477      h20  w120  gJango   ,JANGO



Gui,1:Add,Edit,  x70     y450  w400 h20 vSRCX
Gui,1:Add,Button,default x0 y0 w0 h0  gSEARCH ,

Gui,1:Font, S9 cwhite, Verdana
Gui,1:Add,Text,  x10    y450   w60  h20 ,SEARCH
Gui,1:Add,Text,  x20    y2     w100  vTotal1    ,%I%
Gui,1:Add, Edit, x12 y355 w%T7A% h60 ReadOnly vC,

    Gui,1:add,GroupBox, w0 h0,P1
    Gui,1:Add, Radio,x20   y420  vACR checked   ,ALL
    Gui,1:Add, Radio,x90   y420          ,XML
    Gui,1:Add, Radio,x160  y420          ,HTM
    Gui,1:Add, Radio,x240  y420          ,MUSIC
    Gui,1:Add, Radio,x320  y420          ,PICT
    Gui,1:Add, Radio,x400  y420          ,VIDEO




gosub,clock

Gui,1:Show, x2 y0 w%T7AG% h500,INDEX-DAT

BACK:
LB:
I=0
LV_Delete()
LV_ModifyCol(1,T1)
LV_ModifyCol(2,T2)
LV_ModifyCol(3,T3)
LV_ModifyCol(4,T4)
LV_ModifyCol(5,T5)
LV_ModifyCol(6,T6)
LV_ModifyCol(7,T7)

gosub,GS1
gosub,GO

GuiControl,1:Focus,SRCX
GuiControl,1:,total1,%I%
return

;------------------------------------------------

CLOCK:
;Gui,1:Font, cFF0000 s9 , verdana ;red
;Gui,1:Font, c000000 s9 , verdana ;black
Gui,1:Font, cFFFFFF s9 , verdana  ;white
Gui,1:Add, Text, x%T3Ac% y3 vD , %A_YYYY%-%A_MM%-%A_DD% %a_hour%:%a_min%:%a_sec%
SetTimer, RefreshD, 1000
return

RefreshD:
GuiControl,1:,D,%A_YYYY%-%A_MM%-%A_DD% %a_hour%:%a_min%:%a_sec%
return
;----------------------------------------------------------------












MH2:
msgbox,IndexDatRead.ahk %DATEMOD%-- garry`r`nhttp://www.autohotkey.com
return

MH1:
MessageboxText =
  (
   Read index.dat with pasco.exe
   Download pasco.exe ( and cygwin.dll)
   run,http://www.foundstone.com/us/resources/proddesc/pasco.htm

   Push first (in menu)  INDEX-DAT-SEARCH (once)
   Doubleclick File C:\.....\Temporary Internet Files\Content.IE5\index.dat

   *******
   example if you use MS-IE
   if you want download shown video files from youtube, select video, click REFRESH and see links, download by doubleclick column2


   *******
   example if you use FIREFOX   ( look first for the correct path for variable AA2)
   C:\........\Mozilla\Firefox\Profiles\kjf29nqa.default\Cache

   MP3/FLV from FIREFOX-Button    > you see the files in C:\_REC_FIREFOX_CACHE
)

msgbox,%messageboxtext%
return

MH3:
run,http://www.autohotkey.com
return

MH4:
;run,http://www.foundstone.com/us/resources-free-tools.asp
run,http://www.foundstone.com/us/resources/proddesc/pasco.htm
;run,http://www.foundstone.com/us/index.asp
return

MH5:
ifexist,%AA2%
run,%AA2%
return

MH6:
ifexist,index.txt
run,index.txt
return
;-----------------------------------------------------------

YOUTUBE:
gui,1:submit,nohide
;stringreplace,SRCX,SRCX,%S1%,+,all
;SRCX=`%22%SRCX%`%22
run,http://www.youtube.com/results?search_query=%SRCX%&search=Search
return
;----------------

DADX:
run,http://www.dadx.com
return
;----------------

JANGO:
run,http://www.jango.com
return

;----------------
CACHE:
run,%AA2%
return
;-----------------

REFRESH:
ifnotexist,lastselected.txt
  return
Filereadline,LAST1,lastselected.txt,1

Splashimage,,b1 x10  y5 w%T7AG%  CWred zh0,PASCO READS %LAST1% > INDEX.DAT
Process,exist,pasco.exe
PID2 = %ErrorLevel%
runwait,%comspec% /C pasco -t%S% "%LAST1%" >index.txt,,hide
;sleep,2000
Splashimage,off
goto,LB

return





;----------------
INDEX1:
run,index.txt
return

;------------------------------------------------
SEARCH:
Gui,1:submit,nohide
LV_Delete()
I:=0
GuiControl,1:,total1,%I%


loop,read,%F1%
 {
 gosub,GS1
 ifinstring,A_LOOPREADLINE,%SRCX%
     {
     SplitPath,BX2,name,dir,ext,name_no_ext,drive
     StringRight x,BX2,5
     StringRight y,BX2,4
     StringRight z,BX2,3

        if ACR=1
          {
          I++
          LV_Add("",BX1,BX2,BX3N,BX4N,BX5,BX6,BX7)
          }


        if ACR=2
          {
          If (y =".xml")
              {
              I++
              LV_Add("",BX1,BX2,BX3N,BX4N,BX5,BX6,BX7)
              }
          }

        if ACR=3
          {
          If (x =".html" or y =".htm")
              {
              I++
              LV_Add("",BX1,BX2,BX3N,BX4N,BX5,BX6,BX7)
              }
          }

        if ACR=4
          {
          If (y =".mp3" or y =".wav" or y =".ram" or y =".wma" or y =".mid" or z =".rm" or z =".ra")
              {
              I++
              LV_Add("",BX1,BX2,BX3N,BX4N,BX5,BX6,BX7)
              }
          }

        if ACR=5
          {
          If (y =".gif" or y =".jpg" or y=".bmp")
              {
              I++
              LV_Add("",BX1,BX2,BX3N,BX4N,BX5,BX6,BX7)
              }
          }

        if ACR=6
          {
          If (y =".flv" or y =".mov" or y =".mpg")
              {
              I++
              LV_Add("",BX1,BX2,BX3N,BX4N,BX5,BX6,BX7)
              }
          }


        if ACR=6
          {
          if BX2 contains get_video?video_id=
              {
              I++
              LV_Add("",BX1,BX2,BX3N,BX4N,BX5,BX6,BX7)
              }
          }


     }
 }

LV_ModifyCol(4, "SortDesc")
GuiControl,1:,total1,%I%
return


;------------ search for all index.dat --------------------------------------------
MH11:
;INDEXDATSRCH:
Gui,1:submit,nohide
GuiControl,1:,ACR,1

R3F=indexdatpath.txt
runwait,%comspec% /C del %R3F%,,hide

Splashimage,,b1 x140 y0 w500 h30 CWred zh0,SEARCH INDEX.DAT >>
mx:=0

  Loop,C:\index.dat, 0,1
     {
     if A_LoopFileFullPath=C:\WINDOWS\pchealth\helpctr\OfflineCache\index.dat           ;don't use
        continue
     Fileappend,%A_LoopFileFullPath%`r`n,%R3F%
     mx++
     }
Splashimage,off
;return


;--------  show founded  index.dat  -----------------------------------------
INDEXDAT:
Gui,1:submit,nohide
GuiControl,1:,ACR,1

R3F=indexdatpath.txt

ifnotexist,%R3F%
  {
  Splashimage,,b1 x140 y0 w500 h30 CWred zh0,SEARCH INDEX.DAT >>
  mx:=0
  Loop,C:\index.dat, 0,1
      {
      Fileappend,%A_LoopFileFullPath%`r`n,%R3F%
      mx++
      }
   Splashimage,off
  }


LV_Delete()
LV_ModifyCol(1,0)
LV_ModifyCol(2,T7A)
LV_ModifyCol(3,0)
LV_ModifyCol(4,0)
LV_ModifyCol(5,0)
LV_ModifyCol(6,0)
LV_ModifyCol(7,0)

Splashimage,,b1 x140 y5 w500 h30 CWred zh0,START READ
I:=0
GuiControl,1:,total1,%I%
loop,read,%R3F%
      {
      if A_LoopReadLine=
      continue
      I++
      LV_Add("",%NOTHING%,A_loopReadLine)
      }
Splashimage,off
GuiControl,1:,total1,%I%
return
;-----------------------------------------------------------------------------





;-----------------------------------------------------------------------------
GO:
Gui,1:submit,nohide
LV_Delete()
I=0
GuiControl,1:,total1,%I%



;ALL
if ACR=1
{
  loop,read,%F1%
     {
     if A_LoopReadLine=
     continue
     gosub,GS1
     I++
    stringsplit,BX,A_LoopReadLine,%S%,
    LV_Add("",BX1,BX2,BX3N,BX4N,BX5,BX6,BX7)
    }
LV_ModifyCol(4, "SortDesc")
GuiControl,1:,total1,%I%
return
}



;XML
if ACR=2
{
  loop,read,%F1%
  {
     if A_LoopReadLine=
     continue
  gosub,GS1
  SplitPath,BX2,name,dir,ext,name_no_ext,drive
  StringRight x,BX2,4
  If (x =".xml")
    {
    I++
    LV_Add("",BX1,BX2,BX3N,BX4N,BX5,BX6,BX7)
    }
  }
LV_ModifyCol(4, "SortDesc")
GuiControl,1:,total1,%I%
return
}



;HTM
if ACR=3
{
  loop,read,%F1%
  {
     if A_LoopReadLine=
     continue
  gosub,GS1
  SplitPath,BX2,name,dir,ext,name_no_ext,drive
  StringRight x,BX2,5
  StringRight y,BX2,4
  If (x =".html" or y =".htm")
    {
    I++
    LV_Add("",BX1,BX2,BX3N,BX4N,BX5,BX6,BX7)
    }
  }
LV_ModifyCol(4, "SortDesc")
GuiControl,1:,total1,%I%
return
}



;MUSIC
if ACR=4
{
  loop,read,%F1%
  {
     if A_LoopReadLine=
     continue
     gosub,GS1
  SplitPath,BX2,name,dir,ext,name_no_ext,drive
  StringRight x,BX2,4
  StringRight y,BX2,3
  If (x =".mp3" or x =".wav" or x =".ram" or x =".wma" or x =".mid" or y =".rm" or y =".ra")
    {
    I++
    LV_Add("",BX1,BX2,BX3N,BX4N,BX5,BX6,BX7)
    }
  }
LV_ModifyCol(4, "SortDesc")
GuiControl,1:,total1,%I%
return
}



;PICTURE
if ACR=5
{
  loop,read,%F1%
  {
  if A_LoopReadLine=
  continue
  gosub,GS1
  SplitPath,BX2,name,dir,ext,name_no_ext,drive
  StringRight x,BX2,4
  StringRight y,BX2,3
  If (x =".gif" or x =".jpg" or x=".bmp")
    {
    I++
    LV_Add("",BX1,BX2,BX3N,BX4N,BX5,BX6,BX7)
    }
  }
LV_ModifyCol(4, "SortDesc")
GuiControl,1:,total1,%I%
return
}



;VIDEO
if ACR=6
{
  loop,read,%F1%
  {
  if A_LoopReadLine=
  continue
  gosub,GS1
  SplitPath,BX2,name,dir,ext,name_no_ext,drive
  StringRight x,BX2,4
  StringRight y,BX2,3
  If (x =".flv" or x =".mov" or x =".mpg")
    {
    I++
    LV_Add("",BX1,BX2,BX3N,BX4N,BX5,BX6,BX7)
    }

   if BX2 contains get_video?video_id=
    {
    I++
    LV_Add("",BX1,BX2,BX3N,BX4N,BX5,BX6,BX7)
    }

  }
LV_ModifyCol(4, "SortDesc")
GuiControl,1:,total1,%I%
return
}





GS1:
  YYYY=
  MONS=
  DATS=
  TIMS=
  BX1=
  BX2=
  BX3=
  BX4=
  BX5=
  BX6=
  BX7=
  stringsplit,BX,A_LoopReadLine,%S%,
  Stringmid,MONS,BX3,5,3
  Stringmid,YYYY,BX3,21,4
  Stringmid,TIMS,BX3,12,8
  Stringmid,DATS,BX3,9,2
  if MONS=Jan
  MONS=01
  if MONS=Feb
  MONS=02
  if MONS=Mar
  MONS=03
  if MONS=Apr
  MONS=04
  if MONS=May
  MONS=05
  if MONS=Jun
  MONS=06
  if MONS=Jul
  MONS=07
  if MONS=Aug
  MONS=08
  if MONS=Sep
  MONS=09
  if MONS=Oct
  MONS=10
  if MONS=Nov
  MONS=11
  if MONS=Dec
  MONS=12
  BX3N=%YYYY%%MONS%%DATS%-%TIMS%
  if BX3=Modified Time
  BX3N=Modified Time

  YYYY=
  MONS=
  DATS=
  TIMS=
  Stringmid,MONS,BX4,5,3
  Stringmid,YYYY,BX4,21,4
  Stringmid,TIMS,BX4,12,8
  Stringmid,DATS,BX4,9,2
  if MONS=Jan
  MONS=01
  if MONS=Feb
  MONS=02
  if MONS=Mar
  MONS=03
  if MONS=Apr
  MONS=04
  if MONS=May
  MONS=05
  if MONS=Jun
  MONS=06
  if MONS=Jul
  MONS=07
  if MONS=Aug
  MONS=08
  if MONS=Sep
  MONS=09
  if MONS=Oct
  MONS=10
  if MONS=Nov
  MONS=11
  if MONS=Dec
  MONS=12
  BX4N=%YYYY%%MONS%%DATS%-%TIMS%
  if BX4=Access Time
  BX4N=Access Time
return




;---------------------------------------------------------------




MyListView:
Gui,1:submit,nohide
GuiControlGet, MyListView
LV_GetText(C1,A_EventInfo,1)
LV_GetText(C2,A_EventInfo,2)
LV_GetText(C3,A_EventInfo,3)
LV_GetText(C4,A_EventInfo,4)
LV_GetText(C5,A_EventInfo,5)
LV_GetText(C6,A_EventInfo,6)
LV_GetText(C7,A_EventInfo,7)


if A_GuiEvent = Normal
{
MouseGetPos,x,y
 {

if x<%T1A%
   {
LV_GetText(C2,A_EventInfo,2)
LV_GetText(C5,A_EventInfo,5)
LV_GetText(C7,A_EventInfo,7)
GuiControl,1:,C,%C2%`n%C5%`n%C7%
   MSGG=
   (
   %C1%
   %C2%
   %C3%
   %C4%
   %C5%
   %C6%
   %C7%
   )
  msgbox,%MSGG%
return
   }


if x<%T2A%
   {
LV_GetText(C2,A_EventInfo,2)
LV_GetText(C5,A_EventInfo,5)
LV_GetText(C7,A_EventInfo,7)
GuiControl,1:,C,%C2%`n%C5%`n%C7%
return
   }

if x<%T3A%
   {
LV_GetText(C3,A_EventInfo,3)
GuiControl,1:,C,%C3%
return
   }


if x<%T4A%
   {
LV_GetText(C4,A_EventInfo,4)
GuiControl,1:,C,%C4%
return
   }


if x<%T5A%
   {
LV_GetText(C5,A_EventInfo,5)
GuiControl,1:,C,%C5%
return
   }


if x<%T6A%
   {
LV_GetText(C6,A_EventInfo,6)
GuiControl,1:,C,%C6%
return
   }


if x<%T7A%
   {
LV_GetText(C7,A_EventInfo,7)
GuiControl,1:,C,%C7%
return
   }


 }
}



if A_GuiEvent=K
{
  GetKeyState,state,UP
  if state=D
     {
    RF:=LV_GetNext("F")
    LV_GetText(C2,RF,2)
    LV_GetText(C5,RF,5)
    LV_GetText(C7,RF,7)
    GuiControl,1:,C,%C2%`n%C5%`n%C7%
    }

GetKeyState,state,DOWN
  if state=D
    {
    RF:=LV_GetNext("F")
    LV_GetText(C2,RF,2)
    LV_GetText(C5,RF,5)
    LV_GetText(C7,RF,7)
    GuiControl,1:,C,%C2%`n%C5%`n%C7%
   }
}






if A_GuiEvent = DoubleClick
{
LV_GetText(C2,A_EventInfo,2)
SplitPath,C2,name,dir,ext,name_no_ext,drive

if ext=dat
   {
ifexist,lastselected.txt
  filedelete,lastselected.txt
fileappend,%C2%`r`n,lastselected.txt
Splashimage,,b1 x140 y5 w500 h30 CWred zh0,READ INDEX.DAT
Process,exist,pasco.exe
PID2 = %ErrorLevel%
runwait,%comspec% /C pasco -t%S% "%C2%" >index.txt,,hide
Splashimage,off
goto,LB
   }
else



;:2007111620071117: Administrator@file:///C:/Dokumente%20und%20Einstellungen/Administrator/Desktop/filenames.ahk


   {

;Cookie:administrator@winfuture.de/
stringmid,C2Y,C2,1,7
if C2Y=cookie:
   {
   if C2 contains @
       {
       stringlen,L1,C2
       StringGetPos,PX,C2,@
       P1:=PX-0
       L2:=(L1-P1)
       P1:=(P1+2)
       stringmid,CA,C2,P1,L2
       CAX=http://%CA%
       msgbox, 262436, CONTINUE, Want you run =`n%CAX%  ?
       ifmsgbox,NO
            return
         else
            {
            run,%CAX%
            return
            }
       return
       }
    return
    }


stringmid,C2Y,C2,1,7
if C2Y=http://
     {
     msgbox, 262436, CONTINUE, Want you run/download =`n%C2%  ?
       ifmsgbox,NO
            return
         else
            {
            run,%C2%
            return
            }
      return
     }





if C2 contains @file:///
     {
     stringlen,L1,C2
     StringGetPos,P1,C2,@file:///
     L2:=(L1-P1)
     P1:=(P1+10)
     stringmid,CA,C2,P1,L2
     StringReplace,C2,CA,/,\,All
     StringReplace,C2,CA,`%20,%A_SPACE%,All
     ifexist,%C2%
         {
         msgbox, 262436, CONTINUE, Want you run =`n%C2%  ?
         ifmsgbox,NO
            return
         else
            {
            run,%C2%
            return
            }
         }

     else
         msgbox,File %C2% no more exist
     return
     }




if C2 contains @http://
     {
     stringlen,L1,C2
     StringGetPos,P1,C2,@http://
     L2:=(L1-P1)
     P1:=(P1+2)
     stringmid,CA,C2,P1,L2
         {
         msgbox, 262436, CONTINUE, Want you run =`n%CA%  ?
         ifmsgbox,NO
            return
         else
            {
            run,%CA%
            return
            }
         }
     return
     }




;userdata:Administrator@file@C:\Programme\Hewlett-Packard\Digital Imaging\bbfe\scan/oXMLStoreUnit
if C2 contains @
     {
     stringlen,L1,C2
     StringGetPos,PX,C2,:\
     P1:=PX-2
     L2:=(L1-P1)
     P1:=(P1+2)
     stringmid,CA,C2,P1,L2
     ifexist,%CA%
         {
         msgbox, 262436, CONTINUE, Want you run =`n%CA%  ?
         ifmsgbox,NO
            return
         else
            {
            run,%CA%
            return
            }
         }
     else
         msgbox,File %CA% no more exist
     return
     }




stringmid,CC,C2,1,8
if CC contains ://
     {
     ifexist,%C2%
         {
         msgbox, 262436, CONTINUE, Want you run =`n%C2%  ?
         ifmsgbox,NO
            return
         else
            {
            run,%C2%
            return
            }
         }
     else
         msgbox,File %C2% no more exist
     return
     }



msgbox,Do nothing with  %C2%
return
   }
}
return


GuiClose:
process,close,%PID2%
;ifexist,%AA2%
;  gosub,firefoxcache
ExitApp

~esc:
process,close,%PID2%
ExitApp




;-----------------------------------------------
FIREFOXCACHE:
Gui,1:submit,nohide
;AA2=C:\Dokumente und Einstellungen\Administrator\Lokale Einstellungen\Anwendungsdaten\Mozilla\Firefox\Profiles\kjf29nqa.default\Cache

  I7=0
  Loop %AA2%\*.*
     {
      S1=
      S2=
      exten=
      LFP=%A_LoopFileLongPath%
      LFN=%A_LoopFilename%
      stringmid,LFN1,LFN,1,1
      if LFN1=_
      continue

      FileReadLine,VAR1,%LFP%,1
      stringmid,S1,VAR1,1,3
      if S1=FLV
        {
        exten=flv
        }

      FileReadLine,VAR2,%LFP%,1
      stringmid,S2,VAR2,1,3
      if S2=ID3
        {
        exten=mp3
        }

      if (exten="flv" OR exten="mp3")
      goto,skip02
        else
        continue

      SKIP02:
          {
          new=%LFN%.%exten%
          I7++
          FileCopy,%LFP%,%R3CACHE%\%new%,1
          }
      }

if I7>0
   {
   run,%R3CACHE%   ;opens folder if found
   return
   }

else
  {
  msgbox, No files mp3/flv found in FIREFOX CACHE`n%R3CACHE%
  return
  }
return
;-----------------------------------



/*
» Pasco v1.0

An Internet Explorer activity forensic analysis tool.
Author: Keith J. Jones, Principal Computer Forensic Consultant; Foundstone, Inc.
keith.jones@foundstone.com
Copyright 2003 (c) by Foundstone, Inc.
http://www.foundstone.com

Many important files within Microsoft Windows have structures that are undocumented.
One of the principals of computer forensics is that all analysis methodologies must be well documented and repeatable,
and they must have an acceptable margin of error.
Currently, there are a lack of open source methods and tools that forensic analysts can rely upon to examine the data
found in proprietary Microsoft files.
Many computer crime investigations require the reconstruction of a subject's internet activity.
Since this analysis technique is executed regularly, we researched the structure of the data found in Internet Explorer
activity files (index.dat files).
Pasco, the latin word meaning "browse", was developed to examine the contents of Internet Explorer's cache files.
The foundation of Pasco's examination methodology is presented in the white paper located here.
Pasco will parse the information in an index.dat file and output the results in a field delimited manner so that it
may be imported into your favorite spreadsheet program.
Pasco is built to work on multiple platforms and will execute on Windows (through Cygwin), Mac OS X, Linux, and *BSD platforms.

Usage: pasco [options] <filename>
-d Undelete Activity Records
-t Field Delimiter (TAB by default)

Example Usage:

[kjones:pasco/bin]% ./pasco index.dat > index.txt
Open index.txt as a TAB delimited file in MS Excel to further sort and filter your results
*/
