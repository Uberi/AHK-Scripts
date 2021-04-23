/*  * * * * * * * * * * * * * * * * * * * * * * * * * * * *
    Disclaimer:

    I do not foresee any risk in running this script but
    you may run this file "ONLY" at your own risk. 

    * * * * * * * * * * * * * * * * * * * * * * * * * * * * 

File Name   : OSD_VOL_Gradient.ahk

Download    : http://file.autohotkey.net/goyyah/Tips-N-Tricks/Gradients/OSD_VOL_Gradient.ahk
SnapShot    : http://file.autohotkey.net/goyyah/Tips-N-Tricks/Gradients/osd_vol_green.png
Post        : http://www.autohotkey.com/forum/viewtopic.php?p=61081#61081

Main Title  : Multimedia Utility
Sub Title   : OSD Volume Control - Gradient

Description :  Just an another OSD Volume Control Display for Windows!
               Written as an demonstration for BITMAP Gradients.
   
               Requires the following file for proper On Screen Display:

               http://file.autohotkey.net/goyyah/Tips-N-Tricks/Gradients/OSD_Green.bmp
                   
Author      : A.N.Suresh Kumar aka "Goyyah"
Email       : arian.suresh@gmail.com

Created     : 2006-03-24
Modified    : 2006-03-24

Version     : 0.50

Scripted in : AutoHotkey Version 1.0.44.00 , www.autohotkey.com 
*/

IfNotExist, OSD_Green.bmp
 URlDownloadToFile
 , http://file.autohotkey.net/goyyah/Tips-N-Tricks/Gradients/OSD_Green.bmp
 ,OSD_Green.bmp

Gui, Color, EEAA99 
Gui, +Lastfound 
WinSet, TransColor, EEAA99 250
Gui, -Caption 
Gui, Font, s36 Bold, Verdana
Gui, Add, Text, x0 y10,+
X=25

  Loop,25 {
  Var=Pic%A_Index%
  X+=20
  Gui, Add, Picture, x%X% y10 w12 h50 Hidden Border v%var% , OSD_Green.bmp
  }

Gui, Add, Text, x+10 y10,-
Return 

^!#NumpadEnter::
 Reload
Return

Volume_UP::
#NumpadAdd::
 SetVolume(+4)
Return

Volume_Down::
#NumpadSub::
 SetVolume(-4)
Return

UpdateOSD:
 Gui, Show
 SoundGet,Volume,MASTER, VOLUME
 Volume:=Round((Volume/4),0)

 Loop,25 {
   Var=Pic%A_Index%
   If A_Index <= %Volume%
      GuiControl Show, %Var%
   else
      GuiControl Hide, %Var%
 }

SetTimer, GuiHide, 1000
Return

SetVolume(Val) {
 SoundGet,Volume,MASTER, VOLUME
 Volume+=%Val%
 If Volume < 4
    Volume = 0
 SoundSet, %Volume%, MASTER, VOLUME
 GoSub, UpdateOSD
Return
}

GuiEscape:
GuiHide:
SetTimer, GuiHide, OFF
Gui, Hide
Return