; Written by A.N.Suresh Kumar aka "Goyyah"
; 21-Jun-2006

#NoTrayIcon

SetWorkingDir, %A_ScriptDir%
SplitPath, A_ScriptFullPath,,,,ScriptName

Param1=%1%
  if Param1=/ExtractSource
     {
       GoSub, ExtractSource
       ExitApp
     }

Gui, 1:-Caption +ToolWindow +AlwaysOnTop +Border
Gui, 1:Color, FFFFFF
Gui, 1:Margin, 25, 25
Gui, 1:Font, S10 Bold, Verdana
Gui, 1:Add, Text, c000000 BackgroundTrans,Loading %ScriptName%... Please Wait!
Gui, 1:Show

RunDir= %A_Temp%\%ScriptName%
IfNotExist, %RunDir%
  FileCreateDir, %RunDir%

FileInstall, Other\ImageList.txt           , %RunDir%\ImageList.txt
FileInstall, Other\Gradient.bmp            , %RunDir%\Gradient.bmp
FileInstall, Other\Eminem-Mocking_Bird.mid , %RunDir%\Eminem-Mocking_Bird.mid

mFileOpen:="Open " RunDir "\Eminem-Mocking_Bird.mid ALIAS MidiIns"
Dllcall("winmm.dll\mciExecute","Str",mFileOpen)

InstallImages(RunDir)

Gui, 99:-Caption +AlwaysOnTop
Gui, 99:+LastFound
GUI_99 :=WinExist()

Gui, 99:Margin, 0,0
Gui, 99:Add,Picture, w%A_ScreenWidth% h%A_ScreenHeight%, %RunDir%\Gradient.bmp
Gui, 99:Show,Hide  , %ScriptName%.AHK.SlideShow: 99

Gui,1:Destroy

DllCall("AnimateWindow","UInt",GUI_99,"Int",3000
       ,"UInt", AniEffect("Zoom_In") )

mFilePlay :="Play MidiIns"
Dllcall("winmm.dll\mciExecute","Str",mFilePlay)

ImgWid:= A_ScreenWidth/100*78.2
Ins:=1
Loop, Read, %RunDir%\ImageList.txt
{
    StringSplit, Opt, A_LoopReadLine, `;

    Gui, %Ins%:+Owner99
    Gui, %Ins%:-Caption +AlwaysOnTop
    Gui, %Ins%:+LastFound
    GUI_ID:=WinExist()
    Gui, %Ins%:Margin, 0,0

    Gui, %Ins%:Add,Picture, w%ImgWid% h-1 E0x200, %RunDir%\%Opt1%
    Gui, %Ins%:Show,Hide, %ScriptName%.AHK.Slide: %Ins%

    WinGet, GuiMin, MinMax, ahk_id %GUI_99%
    If GuiMin<0
       Sleep %Opt2%
    else
       DllCall("AnimateWindow","UInt",GUI_ID,"Int",Opt2
              ,"UInt", AniEffect(Opt4) )

    WaitTime:=Opt3-Opt2
    Sleep %WaitTime%


    If Ins=1 
      {
       Gui, 3:Destroy
       Ins=2
      }    
    Else If Ins=2 
      {
       Gui, 1:Destroy
       Ins=3
      }
    Else If Ins=3 
     {
       Gui, 2:Destroy
       Ins=1
      }    
  }

  DllCall("AnimateWindow","UInt",GUI_ID,"Int",1000
         ,"UInt", AniEffect("Fade_Out") )

  DllCall("AnimateWindow","UInt",GUI_99,"Int",3000
         ,"UInt", AniEffect("Zoom_Out") )

  mFileClose :="Close MidiIns"
  Dllcall("winmm.dll\mciExecute","Str",mFileClose)

  ExitApp
Return

~Escape::
99GuiClose:
   ExitApp
Return

ExtractSource:
 xDir= %A_WorkingDir%\Source\
 IfNotExist, %xDir%
   FileCreateDir, %xDir%
 IfNotExist, %xDir%\Images
   FileCreateDir, %xDir%\Images
 IfNotExist, %xDir%\Other
   FileCreateDir, %xDir%\Other

 FileInstall, Other\ImageList.txt           , %A_WorkingDir%\Source\Other\ImageList.txt
 FileInstall, Other\Gradient.bmp            , %A_WorkingDir%\Source\Other\Gradient.bmp
 FileInstall, Other\Eminem-Mocking_Bird.mid , %A_WorkingDir%\Source\Other\Eminem-Mocking_Bird.mid
 FileInstall, Other\SlideShow.ico           , %A_WorkingDir%\Source\Other\SlideShow.ico
 FileInstall, Other\SlideShow.ahk           , %A_WorkingDir%\Source\Other\%ScriptName%.ahk
 FileInstall, Other\AniEffect.ahk           , %A_WorkingDir%\Source\Other\AniEffect.ahk
 
 FileInstall, Other\SlideShow.ahk           , %A_WorkingDir%\Source\%ScriptName%.ahk
 FileInstall, Other\AniEffect.ahk           , %A_WorkingDir%\Source\AniEffect.ahk

 InstallImages(A_WorkingDir . "\Source\Images\")
Return

;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

InstallImages(Target) {             ; The following code was Auto Created with an another AHK Script

IfNotExist, %Target%\Slide01a.jpg 
 FileInstall, Images\Slide01a.jpg, %Target%\Slide01a.jpg 
IfNotExist, %Target%\Slide01b.jpg 
 FileInstall, Images\Slide01b.jpg, %Target%\Slide01b.jpg 

IfNotExist, %Target%\Slide02a.jpg 
 FileInstall, Images\Slide02a.jpg, %Target%\Slide02a.jpg 
IfNotExist, %Target%\Slide02b.jpg 
 FileInstall, Images\Slide02b.jpg, %Target%\Slide02b.jpg 

IfNotExist, %Target%\Slide03a.jpg 
 FileInstall, Images\Slide03a.jpg, %Target%\Slide03a.jpg 
IfNotExist, %Target%\Slide03b.jpg 
 FileInstall, Images\Slide03b.jpg, %Target%\Slide03b.jpg 

IfNotExist, %Target%\Slide04a.jpg 
 FileInstall, Images\Slide04a.jpg, %Target%\Slide04a.jpg 
IfNotExist, %Target%\Slide04b.jpg 
 FileInstall, Images\Slide04b.jpg, %Target%\Slide04b.jpg 

IfNotExist, %Target%\Slide05a.jpg 
 FileInstall, Images\Slide05a.jpg, %Target%\Slide05a.jpg 
IfNotExist, %Target%\Slide05b.jpg 
 FileInstall, Images\Slide05b.jpg, %Target%\Slide05b.jpg 

IfNotExist, %Target%\Slide06a.jpg 
 FileInstall, Images\Slide06a.jpg, %Target%\Slide06a.jpg 
IfNotExist, %Target%\Slide06b.jpg 
 FileInstall, Images\Slide06b.jpg, %Target%\Slide06b.jpg 

IfNotExist, %Target%\Slide07a.jpg 
 FileInstall, Images\Slide07a.jpg, %Target%\Slide07a.jpg 
IfNotExist, %Target%\Slide07b.jpg 
 FileInstall, Images\Slide07b.jpg, %Target%\Slide07b.jpg 

IfNotExist, %Target%\Slide08a.jpg 
 FileInstall, Images\Slide08a.jpg, %Target%\Slide08a.jpg 
IfNotExist, %Target%\Slide08b.jpg 
 FileInstall, Images\Slide08b.jpg, %Target%\Slide08b.jpg 

IfNotExist, %Target%\Slide09a.jpg 
 FileInstall, Images\Slide09a.jpg, %Target%\Slide09a.jpg 
IfNotExist, %Target%\Slide09b.jpg 
 FileInstall, Images\Slide09b.jpg, %Target%\Slide09b.jpg 

IfNotExist, %Target%\Slide10a.jpg 
 FileInstall, Images\Slide10a.jpg, %Target%\Slide10a.jpg 
IfNotExist, %Target%\Slide10b.jpg 
 FileInstall, Images\Slide10b.jpg, %Target%\Slide10b.jpg 

IfNotExist, %Target%\Slide11a.jpg 
 FileInstall, Images\Slide11a.jpg, %Target%\Slide11a.jpg 
IfNotExist, %Target%\Slide11b.jpg 
 FileInstall, Images\Slide11b.jpg, %Target%\Slide11b.jpg 

IfNotExist, %Target%\Slide12a.jpg 
 FileInstall, Images\Slide12a.jpg, %Target%\Slide12a.jpg 
IfNotExist, %Target%\Slide12b.jpg 
 FileInstall, Images\Slide12b.jpg, %Target%\Slide12b.jpg 

IfNotExist, %Target%\Slide13a.jpg 
 FileInstall, Images\Slide13a.jpg, %Target%\Slide13a.jpg 
IfNotExist, %Target%\Slide13b.jpg 
 FileInstall, Images\Slide13b.jpg, %Target%\Slide13b.jpg 

IfNotExist, %Target%\Slide14a.jpg 
 FileInstall, Images\Slide14a.jpg, %Target%\Slide14a.jpg 
IfNotExist, %Target%\Slide14b.jpg 
 FileInstall, Images\Slide14b.jpg, %Target%\Slide14b.jpg 

IfNotExist, %Target%\Slide15a.jpg 
 FileInstall, Images\Slide15a.jpg, %Target%\Slide15a.jpg 
IfNotExist, %Target%\Slide15b.jpg 
 FileInstall, Images\Slide15b.jpg, %Target%\Slide15b.jpg 

IfNotExist, %Target%\Slide16a.jpg 
 FileInstall, Images\Slide16a.jpg, %Target%\Slide16a.jpg 
IfNotExist, %Target%\Slide16b.jpg 
 FileInstall, Images\Slide16b.jpg, %Target%\Slide16b.jpg 

IfNotExist, %Target%\Slide17a.jpg 
 FileInstall, Images\Slide17a.jpg, %Target%\Slide17a.jpg 
IfNotExist, %Target%\Slide17b.jpg 
 FileInstall, Images\Slide17b.jpg, %Target%\Slide17b.jpg 

IfNotExist, %Target%\Slide18a.jpg 
 FileInstall, Images\Slide18a.jpg, %Target%\Slide18a.jpg 
IfNotExist, %Target%\Slide18b.jpg 
 FileInstall, Images\Slide18b.jpg, %Target%\Slide18b.jpg 

IfNotExist, %Target%\Slide19a.jpg 
 FileInstall, Images\Slide19a.jpg, %Target%\Slide19a.jpg 
IfNotExist, %Target%\Slide19b.jpg 
 FileInstall, Images\Slide19b.jpg, %Target%\Slide19b.jpg 

IfNotExist, %Target%\Slide20a.jpg 
 FileInstall, Images\Slide20a.jpg, %Target%\Slide20a.jpg 
IfNotExist, %Target%\Slide20b.jpg 
 FileInstall, Images\Slide20b.jpg, %Target%\Slide20b.jpg 

IfNotExist, %Target%\Slide21a.jpg 
 FileInstall, Images\Slide21a.jpg, %Target%\Slide21a.jpg 
IfNotExist, %Target%\Slide21b.jpg 
 FileInstall, Images\Slide21b.jpg, %Target%\Slide21b.jpg 

IfNotExist, %Target%\Slide22a.jpg 
 FileInstall, Images\Slide22a.jpg, %Target%\Slide22a.jpg 
IfNotExist, %Target%\Slide22b.jpg 
 FileInstall, Images\Slide22b.jpg, %Target%\Slide22b.jpg 

IfNotExist, %Target%\Slide23a.jpg 
 FileInstall, Images\Slide23a.jpg, %Target%\Slide23a.jpg 
IfNotExist, %Target%\Slide23b.jpg 
 FileInstall, Images\Slide23b.jpg, %Target%\Slide23b.jpg 

IfNotExist, %Target%\Slide24a.jpg 
 FileInstall, Images\Slide24a.jpg, %Target%\Slide24a.jpg 
IfNotExist, %Target%\Slide24b.jpg 
 FileInstall, Images\Slide24b.jpg, %Target%\Slide24b.jpg 

IfNotExist, %Target%\Slide25a.jpg 
 FileInstall, Images\Slide25a.jpg, %Target%\Slide25a.jpg 
IfNotExist, %Target%\Slide25b.jpg 
 FileInstall, Images\Slide25b.jpg, %Target%\Slide25b.jpg 

IfNotExist, %Target%\Slide26a.jpg 
 FileInstall, Images\Slide26a.jpg, %Target%\Slide26a.jpg 
IfNotExist, %Target%\Slide26b.jpg 
 FileInstall, Images\Slide26b.jpg, %Target%\Slide26b.jpg 

IfNotExist, %Target%\Slide27a.jpg 
 FileInstall, Images\Slide27a.jpg, %Target%\Slide27a.jpg 
IfNotExist, %Target%\Slide27b.jpg 
 FileInstall, Images\Slide27b.jpg, %Target%\Slide27b.jpg 

IfNotExist, %Target%\Slide28a.jpg 
 FileInstall, Images\Slide28a.jpg, %Target%\Slide28a.jpg 
IfNotExist, %Target%\Slide28b.jpg 
 FileInstall, Images\Slide28b.jpg, %Target%\Slide28b.jpg 

IfNotExist, %Target%\Slide29a.jpg 
 FileInstall, Images\Slide29a.jpg, %Target%\Slide29a.jpg 
IfNotExist, %Target%\Slide29b.jpg 
 FileInstall, Images\Slide29b.jpg, %Target%\Slide29b.jpg 

IfNotExist, %Target%\Slide30a.jpg 
 FileInstall, Images\Slide30a.jpg, %Target%\Slide30a.jpg 
IfNotExist, %Target%\Slide30b.jpg 
 FileInstall, Images\Slide30b.jpg, %Target%\Slide30b.jpg 

IfNotExist, %Target%\Slide31a.jpg 
 FileInstall, Images\Slide31a.jpg, %Target%\Slide31a.jpg 
IfNotExist, %Target%\Slide31b.jpg 
 FileInstall, Images\Slide31b.jpg, %Target%\Slide31b.jpg 

IfNotExist, %Target%\Slide32a.jpg 
 FileInstall, Images\Slide32a.jpg, %Target%\Slide32a.jpg 
IfNotExist, %Target%\Slide32b.jpg 
 FileInstall, Images\Slide32b.jpg, %Target%\Slide32b.jpg 

IfNotExist, %Target%\Slide33a.jpg 
 FileInstall, Images\Slide33a.jpg, %Target%\Slide33a.jpg 
IfNotExist, %Target%\Slide33b.jpg 
 FileInstall, Images\Slide33b.jpg, %Target%\Slide33b.jpg 

IfNotExist, %Target%\Slide34a.jpg 
 FileInstall, Images\Slide34a.jpg, %Target%\Slide34a.jpg 
IfNotExist, %Target%\Slide34b.jpg 
 FileInstall, Images\Slide34b.jpg, %Target%\Slide34b.jpg 

IfNotExist, %Target%\Slide35a.jpg 
 FileInstall, Images\Slide35a.jpg, %Target%\Slide35a.jpg 
IfNotExist, %Target%\Slide35b.jpg 
 FileInstall, Images\Slide35b.jpg, %Target%\Slide35b.jpg 

IfNotExist, %Target%\Slide36a.jpg 
 FileInstall, Images\Slide36a.jpg, %Target%\Slide36a.jpg 
IfNotExist, %Target%\Slide36b.jpg 
 FileInstall, Images\Slide36b.jpg, %Target%\Slide36b.jpg 

IfNotExist, %Target%\Slide37a.jpg 
 FileInstall, Images\Slide37a.jpg, %Target%\Slide37a.jpg 
IfNotExist, %Target%\Slide37b.jpg 
 FileInstall, Images\Slide37b.jpg, %Target%\Slide37b.jpg 

IfNotExist, %Target%\Slide38a.jpg 
 FileInstall, Images\Slide38a.jpg, %Target%\Slide38a.jpg 
IfNotExist, %Target%\Slide38b.jpg 
 FileInstall, Images\Slide38b.jpg, %Target%\Slide38b.jpg 

IfNotExist, %Target%\Slide39a.jpg 
 FileInstall, Images\Slide39a.jpg, %Target%\Slide39a.jpg 
IfNotExist, %Target%\Slide39b.jpg 
 FileInstall, Images\Slide39b.jpg, %Target%\Slide39b.jpg 

IfNotExist, %Target%\Slide40a.jpg 
 FileInstall, Images\Slide40a.jpg, %Target%\Slide40a.jpg 
IfNotExist, %Target%\Slide40b.jpg 
 FileInstall, Images\Slide40b.jpg, %Target%\Slide40b.jpg 

IfNotExist, %Target%\Slide41a.jpg 
 FileInstall, Images\Slide41a.jpg, %Target%\Slide41a.jpg 
IfNotExist, %Target%\Slide41b.jpg 
 FileInstall, Images\Slide41b.jpg, %Target%\Slide41b.jpg 

IfNotExist, %Target%\Slide42a.jpg 
 FileInstall, Images\Slide42a.jpg, %Target%\Slide42a.jpg 
IfNotExist, %Target%\Slide42b.jpg 
 FileInstall, Images\Slide42b.jpg, %Target%\Slide42b.jpg 

IfNotExist, %Target%\Slide43a.jpg 
 FileInstall, Images\Slide43a.jpg, %Target%\Slide43a.jpg 
IfNotExist, %Target%\Slide43b.jpg 
 FileInstall, Images\Slide43b.jpg, %Target%\Slide43b.jpg 

IfNotExist, %Target%\Slide44a.jpg 
 FileInstall, Images\Slide44a.jpg, %Target%\Slide44a.jpg 
IfNotExist, %Target%\Slide44b.jpg 
 FileInstall, Images\Slide44b.jpg, %Target%\Slide44b.jpg 

IfNotExist, %Target%\Slide45a.jpg 
 FileInstall, Images\Slide45a.jpg, %Target%\Slide45a.jpg 
IfNotExist, %Target%\Slide45b.jpg 
 FileInstall, Images\Slide45b.jpg, %Target%\Slide45b.jpg 

IfNotExist, %Target%\Slide46a.jpg 
 FileInstall, Images\Slide46a.jpg, %Target%\Slide46a.jpg 
IfNotExist, %Target%\Slide46b.jpg 
 FileInstall, Images\Slide46b.jpg, %Target%\Slide46b.jpg 

IfNotExist, %Target%\Slide47a.jpg 
 FileInstall, Images\Slide47a.jpg, %Target%\Slide47a.jpg 
IfNotExist, %Target%\Slide47b.jpg 
 FileInstall, Images\Slide47b.jpg, %Target%\Slide47b.jpg 
}

#Include AniEffect.ahk