/*
 * * * Compile_AHK SETTINGS BEGIN * * *

[AHK2EXE]
Exe_File=%In_Dir%\Aaron's Soundclick Music Player.exe
No_UPX=1
Created_Date=1
Execution_Level=3
[VERSION]
Set_Version_Info=1
Company_Name=Aaron Bewza Music
File_Description=Aaron's Streaming Media Player for Soundclick
File_Version=1.1.0.0
Inc_File_Version=0
Internal_Name=Aaron's Soundclick Music Player
Original_Filename=Aaron's Soundclick Music Player
Product_Name=Aaron's Soundclick Music Player
Product_Version=1.1.0.0
Language_ID=42
[ICONS]
Icon_1=%In_Dir%\icon.ico

* * * Compile_AHK SETTINGS END * * *
*/

If not A_IsAdmin { ; Runs script as Administrator for UAC in Windows Vista and 7+
  Run *RunAs "%A_ScriptFullPath%"
  ExitApp
  }
; ____ ____ ____ ____ _  _ ____    ____ ____ _  _ _  _ ___  ____ _    _ ____ _  _ 
; |__| |__| |__/ |  | |\ | [__     [__  |  | |  | |\ | |  \ |    |    | |    |_/  
; |  | |  | |  \ |__| | \| ___]    ___] |__| |__| | \| |__/ |___ |___ | |___ | \_ 
; _  _ _  _ ____ _ ____    ___  _    ____ _   _ ____ ____ 
; |\/| |  | [__  | |       |__] |    |__|  \_/  |___ |__/ 
; |  | |__| ___] | |___    |    |___ |  |   |   |___ |  \ 

#NoEnv ; No system environment variables
#SingleInstance Ignore
#NoTrayIcon
SetWorkingDir, A_Temp ; Sets working directory here

URLDownloadToFile, http://i1207.photobucket.com/albums/bb474/aaronbewza/loading-1.gif, %A_Temp%\loading.gif ; Loading animation
BkgImg = %A_Temp%\loading.gif ; Sends  image to BkgImg variable

version = Version 1.1.0.0 ; Displays correct version number in the 'Info' button message window
builddate = August 8th 2011 ; Displays correct build date in the 'Info' button message window

w = width="860" ; width of player is now %w%
h = height="340" ; height of player is now %h%

ChosenBandID = 956206 ; Replace this with the BandID of the artist of your choice from Soundclick.com (6 digit ID number from the URL)

src = src="http://www.soundclick.com/widgets/creatives/mp3PlayerVIP.swf" type="application/x-shockwave-flash" menu="false" id="mp3PlayerVIP"
etc =  wmode="transparent" pluginspage="http://www.macromedia.com/go/getflashplayer" %w% %h% flashvars="bandid=%ChosenBandID%&amp;ext=1&amp;autoplay=1" bgcolor="#3A3A3A"
player = %src% %etc% ; combines the above two variables (split for readability) into 'player' variable

code = ; HTML code for the com call, inserts information from 'BkgImg' and 'player' variables
  ( LTrim
    <!DOCTYPE html>`n<html>`n<head>`n<meta http-equiv="Content-Type" content="text/html;charset=utf-8" />`n<title>Aaron's Soundclick Music Player</title>
      <style type="text/css">`nbody {background-color:#3A3A3A; font-size:24px; font-family:Arial; font-weight:bold}`n.fixed {position:fixed}
      .centered {color:#999999; text-align:right; position:fixed; left:330px}`n</style>`n</head>
      <body>
      <p class="centered"><br /><img src="%BkgImg%" alt="" height="220" width="220"></p>`n<span class="fixed"><embed %player% /></span>
      </body>`n</html>`n
  )

COM_AtlAxWinInit()

Gui, +LastFound -Resize ; User does not have the option to resize the window
Gui, Show, w757 h315, Aaron's Soundclick Music Player ; Creates window and shows title

pwb.silent := true 
pwb := COM_AtlAxGetControl(COM_AtlAxCreateContainer(hwnd:=WinExist()
  ,-62 ; left margin of HTML container
  ,-19 ; top margin of HTML container
  ,891 ; width of HTML container
  ,293 ; height of HTML container
  ,"Shell.Explorer"))
COM_Invoke(pwb, "Navigate", "about:blank") ; Opens a blank webpage ready for HTML code to be written to

Gui, Color, c3A3A3A ; Matches grey color of animated loading gif
Gui, Font, s16 Bold
Gui, Add, Button, x5 y280 w182 h30 vReload, Reload ; Refreshes page
Gui, Add, Button, x193 y280 w182 h30 vInfo, Info ; Shows information
Gui, Add, Button, x381 y280 w182 h30 vWebsite, Website ; Opens AaronBewzaMusic.com (currently down due to lack of funds)
Gui, Add, Button, x569 y280 w182 h30 vExit, Exit ; Exits Aaron's Soundclick Player

COM_Invoke(pwb, "document.write", code) ; Writes the HTML to the blank webpage control
Return

ButtonReload:
  COM_Invoke(pwb,"document.location.reload") ; Reloads the player from Aaron's Soundclick music site
Return

ButtonInfo:
  Gui, +OwnDialogs
  MsgBox,
    ( LTrim
      Aaron Bewza records all his music in his studio, track by track
      and instrument by instrument. His musical experience includes:`n
      -Classical piano (and by default, keyboards) since 1980
      -Electric, acoustic and bass guitar since 1987
      -Drums (acoustic and sampled) since 1994`n
      Aaron shares his music freely because he feels music is a gift
      and the more it is given, the more is received by all.`n
      He is currently recording his 6th CD "The Space Junk Project"
      which will be released hopefully by Christmas 2011.`n
      %version%
      %builddate%
      
      System Requirements:
      Adobe Flash Player
      Internet access

    )
Return

ButtonWebsite: ; Opens "Aaron Bewza Music" website (still inactive as of this build date)
  Gui, +OwnDialogs
;  Run, http://www.aaronbewzamusic.com
  MsgBox, Aaron's website is currently down.`nAt some point, it will be functional`nagain and a new version of this player will`nbe released with a working link.
Return

ButtonExit:
GuiClose:
GuiExit:
  Gui, Hide ; Hides the main window until the website stuff is released
  COM_Release(pwb)
  COM_AtlAxWinTerm()
  Gui, Destroy ; Completely closes and releases the main window
ExitApp
