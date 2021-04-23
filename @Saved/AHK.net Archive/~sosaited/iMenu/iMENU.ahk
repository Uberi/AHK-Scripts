#HotString EndChars /
; SetTimer, np_update, 1000
HotKey, Left, L
HotKey, Right, R
HotKey, Left, Off
v_mounted = 0
HotKey, Right, Off
SetTitleMatchMode, 2
Menu, TRAY, NoStandard
Menu, TRAY, Icon, F:\Acligruintos Project\backup\acl\scripts\small\Icon Uncompiled.ico
Menu, TRAY, Add, EXIT, Exit

;SetTimer, close, 1000

:B0:nfsmwlock::
v_lock = 1
return

:B0:nfsmwunlock::
v_lock = 0
return


MButton::

IfNotExist, fav.ini
	FileAppend, No Entries Found, fav.ini


Loop, Read, fav.ini
{
v_currentname =
StringSplit, v_currentname, A_LoopReadLine, |
Menu, open_sub, Add, %v_currentname1%, open
}


Menu, Main, Add, %A_Space%%A_Space%%A_Space%%A_Space%%A_Space%%A_Space%%A_Space%%A_Space%%A_Space%AESAM(Alpha v1.6), Info
Menu, Main, Default, %A_Space%%A_Space%%A_Space%%A_Space%%A_Space%%A_Space%%A_Space%%A_Space%%A_Space%AESAM(Alpha v1.6)
Menu, Main, Add
Menu, Main, Add, Edit AESAM using AI-powered AISE, EDIT

Menu, Main, Add
Menu, Addthis, Add, Add in NEW, new_add
Menu, Addthis, Add, Add in OLD, old_add
Menu, Addthis, Add, Add in Recent, recent_add



Menu, file_folder_control, Add, Add This Folder, :Addthis


Menu, games_control, Add, NFS Most Wanted, nfsmw
Menu, games_control, Add, Brian Lara Cricket 2005, blc2005
Menu, games_control, Add, EA Sports Cricket 2005, blc2005
Menu, games_control, Add, Max Payne 2, blc2005
Menu, games_control, Add, Mafia, mafia
Menu, games_control, Add, Mystery of Silver Earing, blc2005
Menu, games_control, Add, Far Cry, blc2005
Menu, games_control, Add, Prince of Persia: The Two Thrones, blc2005
Menu, games_control, Add, The Movies, blc2005
Menu, games_control, Add, The Matrix: Path of Neo, blc2005
Menu, games_control, Add, GTA: San Andreas, blc2005
Menu, games_control, Add, F16 Multirole Fighter, blc2005
Menu, games_control, Add, Cue Club, blc2005
Menu, games_control, Add, Juiced, blc2005
Menu, games_control, Add, EA Sports NBA Live '06, blc2005
Menu, games_control, Add, Driv3r (Driver 3), blc2005
Menu, games_control, Add, Sims 2, blc2005
Menu, games_control, Add, Trains, blc2005

Menu, smallville, Add, Season 5 Episode 1-Arrival, smallville501
Menu, smallville, Add, Season 5 Episode 2-Mortal, smallville501
Menu, smallville, Add, Season 5 Episode 3-Hidden, smallville501
Menu, smallville, Add, Season 5 Episode 4-Aqua, smallville501
Menu, smallville, Add, Season 5 Episode 5-Thirst, smallville501
Menu, smallville, Add, Season 5 Episode 6-Exposed, smallville501
Menu, smallville, Add, Season 5 Episode 7-Splinter, smallville501
Menu, smallville, Add, Season 5 Episode 8-Solitude, smallville501
Menu, smallville, Add, Season 5 Episode 9-Lexmas, smallville501
Menu, smallville, Add, Season 5 Episode 10-Fanatic, smallville501
Menu, smallville, Add, Season 5 Episode 11-Lockdown, smallville501
Menu, smallville, Add, Season 5 Episode 12-Reckoning, smallville501
Menu, smallville, Add, Season 5 Episode 13-Vengeance, smallville501
Menu, smallville, Add, Season 5 Episode 14-Tomb, smallville501
Menu, smallville, Add, Season 5 Episode 15-Cyborg, smallville501
Menu, smallville, Add, Season 5 Episode 16-Hypnotic, smallville501
Menu, smallville, Add, Season 5 Episode 17-Void, smallville501
Menu, smallville, Add, Season 5 Episode 18-Fragile, smallville501
Menu, smallville, Add, Season 5 Episode 19-Fade, smallville501

Menu, movies_control, Add, Smallville, :smallville
Menu, movies_control, Add, Pearl Harbour, smallville501
Menu, movies_control, Add, Ocean's Eleven, smallville501
Menu, movies_control, Add, Ocean's Twelve, smallville501
Menu, movies_control, Add, Matchstick Men, smallville501
Menu, movies_control, Add, Edward Scissorhands, smallville501

Menu, program_control, Add, Alcohol 120`%, alcohol
Menu, program_control, Add, Anti-Blaxx, antiblaxx
Menu, program_control, Add, Internet Pal, internetpal
Menu, program_control, Add, Creative Surround Mixer, surround
Menu, program_control, Add, PowerDVD, powerdvd
Menu, program_control, Add, Daemon Tools, daemontools
Menu, program_control, Add, DAP, dap
Menu, program_control, Add, eMule, emule
Menu, program_control, Add, FFP, ffp
Menu, program_control, Add, Fraps, fraps
Menu, program_control, Add, LifeView TVR, lifeviewtvr
Menu, program_control, Add, Mozilla Firefox, firefox
Menu, program_control, Add, Stopwatch, stopwatch
Menu, program_control, Add, Object Dock, objectdock
Menu, program_control, Add, Offline Explorer, offlineexplorer
Menu, program_control, Add, Partition Magic, partitionmagic
Menu, program_control, Add, Quicktime, quicktime
Menu, program_control, Add, Realplayer, realplayer
Menu, program_control, Add, Winamp, winamp
Menu, program_control, Add, Windows Media Player, windowsmediaplayer
Menu, program_control, Add, MSN Messenger, msnmessenger
Menu, program_control, Add, No1 DVD Ripper, dvdripper
Menu, program_control, Add, K-Lite, klite
Menu, program_control, Add, Mirascan, mirascan
Menu, program_control, Add, VLC Media Player, vlcmp

Menu, file_folder_control, Add, Open, :open_sub
Menu, Main, Add, Folder Control, :file_folder_control
Menu, Main, Add

Menu, Main, Add, Program Control, :program_control
Menu, Main, Add

Menu, Main, Add, Games Control, :games_control
Menu, Main, Add

Menu, Main, Add, Movies-Tv Serials Control, :movies_control
Menu_AssignBitmap( "movies_control", 1, "smallville_sec.bmp", false )

Menu, Main, Add

Menu, media_sub, Add, Play/Pause, media_play
Menu, media_sub, Add, Next, media_next
Menu, media_sub, Add, Previous, media_previous
Menu, media_sub, Add, Stop, media_stop
Menu, media_sub, Add, Forward, media_forward
Menu, media_sub, Add, Shuffle (Toggle On/Off), media_shuffle
Menu, media_sub, Add, Repeat (Toggle On/Off), media_repeat
Menu, Main, Add, Media Control, :media_sub
Menu, Main, Add
Menu, internet_sub_connect, Add, Brain, brain_connect
Menu, internet_sub_connect, Add, Wol, wol_connect
Menu, Internet_sub, Add, Internet Explorer, ie_launch
Menu, Internet_sub, Add, MSN Messenger, msnmessenger_launch
Menu, internet_sub, Add, Connect/Dc, :internet_sub_connect
Menu, Main, Add, Internet Control, :internet_sub
Menu, Main, Add
Menu, process_control, Add, Kill Active Window, process_kill_active
Menu, Main, Add, Process Control, :process_control
Menu, Main, Add
Menu, Main, Add, Easy Volume Control(Start), volume
Menu, Main, Add, Easy Volume Control(Stop), volume2
Menu, Main, Add
Menu, Main, Add, -=EXIT=-, Exit
Menu, Main, Color, 66A6F0
Menu, file_folder_control, Color, 66A6F0
Menu, movies_control, Color, 66A6F0 
Menu, Internet_sub, Color, 66A6F0
v_menuexist = 1
Menu_AssignBitmap( "Main", "11", "movies.bmp", false )
Menu, Main, Show

GetKeyState, v_mbuttonstate, MButton
If v_mbuttonstate = U
	Menu, Main, DeleteAll



return

;Addthis:
;MouseGetPos, , , v_winid
;WinGetTitle, v_wintitle, ahk_id %v_winid%
;WinActivate
;ControlGetText, v_path, Edit1, %v_wintitle%
;FileAppend, %v_wintitle%|%v_path%, fav.ini
;return

open:
Loop, Read, fav.ini
{
	StringSplit, v_initialpath, A_LoopReadLine, |
	
	If A_ThisMenuItem = %v_initialpath1%
		v_openpath = %A_LoopReadLine%
	StringSplit, v_openpathpath, v_openpath, |
	v_openpathfinal = %v_openpathpath2%
}
Run, %v_openpathfinal%
Menu, Main, DeleteAll

return

new_add:
FileReadLine, v_checkfavline, fav.ini, 1
If v_checkfavline = No Entries Found
	FileDelete, fav.ini
MouseGetPos, , , v_winid
WinGetTitle, v_wintitle, ahk_id %v_winid%
WinActivate
ControlGetText, v_path, Edit1, %v_wintitle%
FileAppend, %v_wintitle%-=(NEW)=-|%v_path%`n, fav.ini
return

old_add:
FileReadLine, v_checkfavline, fav.ini, 1
If v_checkfavline = No Entries Found
	FileDelete, fav.ini
MouseGetPos, , , v_winid
WinGetTitle, v_wintitle, ahk_id %v_winid%
WinActivate
ControlGetText, v_path, Edit1, %v_wintitle%
FileAppend, %v_wintitle%-=(OLD)=-|%v_path%`n, fav.ini
return

recent_add:
FileReadLine, v_checkfavline, fav.ini, 1
If v_checkfavline = No Entries Found
	FileDelete, fav.ini
MouseGetPos, , , v_winid
WinGetTitle, v_wintitle, ahk_id %v_winid%
WinActivate
ControlGetText, v_path, Edit1, %v_wintitle%
FileAppend, %v_wintitle%-=(RECENT)=-|%v_path%`n, fav.ini


volume:

HotKey, WheelUp, wheelup
HotKey, WheelDown, wheeldown
HotKey, WheelUp, On
HotKey, WheelDown, On
SetTimer, closesplash, 1000
return

volume2:
HotKey, WheelUp, Off
HotKey, WheelDown, Off
SetTimer, closesplash, Off
Progress, Off
return

wheelup:
SetTimer, closesplash, 1000
Soundget, v_sound
v_set := v_sound + 5
SoundSet, %v_set%
Transform, v_osd, Round, %v_set%

Progress, %v_osd%, , , ACLIGRUINTOS OSD Volume Control


return

wheeldown:
SetTimer, closesplash, 1000
Soundget, v_sound
v_set := v_sound - 5
SoundSet, %v_set%
Transform, v_osd, Round, %v_set%

Progress, %v_osd%, , , ACLIGRUINTOS OSD Volume Control


return



closesplash:
IfWinExist, ACLIGRUINTOS OSD Volume Control
	{
	Sleep, 2500
	Progress, Off
	}
SetTimer, closesplash, Off
return

media_play:
PostMessage, 0x111, 18808, 0, , ahk_class WMPlayerApp ; play/pause
return 

media_next:
PostMessage, 0x111, 18811, 0, , ahk_class WMPlayerApp ; next
return 

media_previous:
PostMessage, 0x111, 18810, 0, , ahk_class WMPlayerApp ; previous
return

media_stop:
PostMessage, 0x111, 18809, 0, , ahk_class WMPlayerApp ; stop
return

media_forward:
PostMessage, 0x111, 18813, 0, , ahk_class WMPlayerApp ; fast forward
return

media_shuffle:
PostMessage, 0x111, 18842, 0, , ahk_class WMPlayerApp ; shuffle toggle On/Off
return

media_repeat:
PostMessage, 0x111, 18843, 0, , ahk_class WMPlayerApp ; repeat toggle On/Off
return

brain_connect:
Run, %A_WinDir%\system32\rasphone.exe
WinWait, ahk_class #32770
Send, {AltDown}c{AltUp}
return

wol_connect:
Run, %A_WinDir%\system32\rasphone.exe
WinWait, ahk_class #32770
Send, {Down}{AltDown}c{AltUp}
return

ie_launch:
Run, %A_ProgramFiles%\Internet Explorer\IEXPLORE.exe
return

msnmessenger_launch:
Run, %A_ProgramFiles%\MSN Messenger\msnmsgr.exe
return

~LButton & WheelUp::
PostMessage, 0x111, 18810, 0, , ahk_class WMPlayerApp ; Previous
return

~LButton & WheelDown::
PostMessage, 0x111, 18811, 0, , ahk_class WMPlayerApp ; Next
return

~RButton & WheelUp::
SetTimer, closesplash, 1000
Soundget, v_sound
v_set := v_sound + 5
SoundSet, %v_set%
Transform, v_osd, Round, %v_set%

Progress, %v_osd%, , , ACLIGRUINTOS OSD Volume Control
return

~RButton & WheelDown::
SetTimer, closesplash, 1000
Soundget, v_sound
v_set := v_sound - 5
SoundSet, %v_set%
Transform, v_osd, Round, %v_set%

Progress, %v_osd%, , , ACLIGRUINTOS OSD Volume Control
return



Info:
MsgBox, 64, INFO, This is Pre-Beta Version of ACLIGRUINTOS Easy Access Menu (AESAM). Development is still in Progress.
return

inputbox:
Inputbox, v_input, ACLIGRUINTOS® Easy Access Menu (AESAM™) Input Mode, Type the command:
return

process_kill_active:
MouseGetPos, , , v_mouse_get_winid
WinClose, ahk_id %v_mouse_get_winid% 
return
/*
np_update:
IfWinExist, ahk_class WMPlayerApp
	{
	WinGetTitle, v_np_title, ahk_class WMPlayerApp
	StringTrimRight, v_np_track, v_np_title, 21
		TrayTip, ACLIGRUINTOS® Smart Media Control, The Now Playing Track is: %v_np_track%, , 1
		SetTimer, trayclose, 5000
		}
	}
return

trayclose:
TrayTip
SetTimer, trayclose, Off
return
*/

Exit:
ExitApp
return

nfsmw:
If v_lock = 1
	{
	TrayTip, AMT Game Zone, Checking AMT Gaming Zone Membership..., , 1
	Sleep, 4000
	TrayTip
	MsgBox, 64, AESAM Alpha 1.6, Your AMT Game Zone Membership has expired`nPlease Visit www.amt.tk OR www.acligruintos.tk for Membership.
	return
	}

SetTimer, close, Off
DriveGet, v_cdrom, List, CDROM
;MsgBox, %v_cdrom%
;StringLen, v_cdromlength, v_cdrom
Loop, Parse, v_cdrom
{
	DriveGet, v_nfsmwcdpath, Label, %A_LoopField%:
	If v_nfsmwcdpath = NFSMW_DISC1
		v_mounted = 1
	
}



Loop, Parse, v_cdrom
{
	DriveGet, v_nfsmwcdpath, Label, %A_LoopField%:
	MsgBox, %v_nfsmwcdpath%
	If v_nfsmwcdpath = NFS_MW
		Break
	Else If v_nfsmwcdpath <> NFS_MW
		{
		MsgBox, 64, Acligruintos Easy Access Menu, Need for speed Most Wanted DVD not found`, Try again after Inserting Disc "NFS_MW".
		Return
		}
}
Process, Exist, Anti-Blaxx.exe
If ErrorLevel = 0
	Run, U:\Program Files\Anti-Blaxx\Anti-Blaxx.exe
RunWait, %comspec% /c ""U:\Program Files\Alcohol Soft\Alcohol 120\AxCmd.exe" 1: /M:"T:\CD 1\st-nfsmw1.mds"",, hide
If v_mounted = 0
	{
	WinWait, Need for Speed ahk_class #32770, Technical Support
	ControlClick, Button8, Need for Speed ahk_class #32770, Technical Support, Left
	}
Run, E:\nfsmw\speed.exe, E:\nfsmw\
SetTimer, left, 5000
return

blc2005:
MsgBox, 64, Acligruintos Easy Access Menu, This function is under development.
return

smallville501:
If A_ThisMenuItem = Season 5 Episode 1-Arrival
	Run, P:\smallville\Smallville season 5 episode 1 - Arrival.avi
If A_ThisMenuItem = Season 5 Episode 2-Mortal
	Run, P:\smallville\Smallville Season 5 Episode 02 (Mortal).avi
If A_ThisMenuItem = Season 5 Episode 3-Hidden
	Run, P:\smallville\Smallville - 503 - Hidden.avi
If A_ThisMenuItem = Season 5 Episode 4-Aqua
	Run, P:\smallville\smallville.504.hdtv-lol.[VTV].avi
If A_ThisMenuItem = Season 5 Episode 5-Thirst
	Run, P:\smallville\Smallville_-_5x05_-_Thirst.(TV).english.LOL.HDTV.[www.tvunderground.org.ru].avi
If A_ThisMenuItem = Season 5 Episode 6-Exposed
	Run, P:\smallville\Smallville - 506 - Exposed.avi
If A_ThisMenuItem = Season 5 Episode 7-Splinter
	Run, J:\My Shared Folder\Smallville- 507- Splinter.avi
If A_ThisMenuItem = Season 5 Episode 8-Solitude
	Run, J:\My Shared Folder\smallville.508.hdtv-lol.[VTV].avi
If A_ThisMenuItem = Season 5 Episode 9-Lexmas
	Run, J:\My Shared Folder\smallville.509.hdtv-lol.[VTV].avi
If A_ThisMenuItem = Season 5 Episode 10-Fanatic
	Run, J:\My Shared Folder\Smallville - 510 - Fanatic.avi
If A_ThisMenuItem = Season 5 Episode 11-Lockdown
	Run, J:\My Shared Folder\Smallville - 511 - Lockdown.avi
If A_ThisMenuItem = Season 5 Episode 12-Reckoning
	Run, J:\My Shared Folder\Smallville - 512 - Reckoning.avi
If A_ThisMenuItem = Season 5 Episode 13-Vengeance
	Run, J:\My Shared Folder\smallville.513.hdtv-lol.[VTV].avi
If A_ThisMenuItem = Season 5 Episode 14-Tomb
	MsgBox, 64, AESAM Alpha 1.6, This Episode of Smallville (%A_ThisMenuItem%) is being downloaded (36/356Mb Done)`nTry again after 3 days.
If A_ThisMenuItem = Season 5 Episode 15-Cyborg
	MsgBox, 64, AESAM Alpha 1.6, This Episode of Smallville (%A_ThisMenuItem%) is being downloaded (40/358Mb Done)`nTry again after 6 days.
If A_ThisMenuItem = Season 5 Episode 16-Hypnotic
	MsgBox, 64, AESAM Alpha 1.6, This Episode of Smallville (%A_ThisMenuItem%) has not been Aired yet.`nTry again after 1st April 2005.
If A_ThisMenuItem = Season 5 Episode 17-Void
	MsgBox, 64, AESAM Alpha 1.6, This Episode of Smallville (%A_ThisMenuItem%) has not been Aired yet.`nTry again after 7th April 2005.
If A_ThisMenuItem = Season 5 Episode 18-Fragile
	MsgBox, 64, AESAM Alpha 1.6, This Episode of Smallville (%A_ThisMenuItem%) has not been Aired yet.`nTry again after 14th April 2005.
If A_ThisMenuItem = Season 5 Episode 19-Fade
	MsgBox, 64, AESAM Alpha 1.6, This Episode of Smallville (%A_ThisMenuItem%) has not been Aired yet.`nTry again after 21st April 2005.
return

return

EDIT:
MsgBox, 64, Acligruintos Easy Access Menu, This function is under development.
return


close:
IfWinExist, Alcohol
	WinClose, Alcohol
Process, Close, Anti-Blaxx.exe
return

left:
;IfWinNotExist, Most Wanted
	;{
	;SetTimer, left, Off
	;return
	;}


Random, v_random, 1, 6
If v_random = 1
	{
	HotKey, Left, On
	HotKey, Right, On
	
	}
If v_random = <> 1
	{
	HotKey, Left, Off
	HotKey, Right, Off
	
	}

return

L:
ControlSend, GameFrame, {Right}, Need for Speed™ Most Wanted
return

R:
ControlSend, GameFrame, {Left}, Need for Speed™ Most Wanted
return

alcohol:
Run, %A_ProgramFiles%\Alcohol Soft\Alcohol 120\Alcohol.exe, %A_ProgramFiles%\Alcohol Soft\Alcohol 120\
return

antiblaxx:
Run, %A_ProgramFiles%\Anti-Blaxx\Anti-Blaxx.exe
return

internetpal:
Run, %A_ProgramFiles%\BySoft InternetPal\InternetPal.exe, %A_ProgramFiles%\BySoft InternetPal\
return

surround:
Run, %A_ProgramFiles%\Creative\SBAudigy\SurMix2\SurMix2.exe, %A_ProgramFiles%\Creative\SBAudigy\SurMix2\
return

powerdvd:
Run, %A_ProgramFiles%\CyberLink\PowerDVD\PowerDVD.exe, %A_ProgramFiles%\CyberLink\PowerDVD\
return

daemontools:
Run, %A_ProgramFiles%\DAEMON Tools\daemon.exe, %A_ProgramFiles%\DAEMON Tools\
return

dap:
Run, %A_ProgramFiles%\DAP\DAP.exe, %A_ProgramFiles%\DAP\
return

emule:
Run, %A_ProgramFiles%\eMule\emule.exe, %A_ProgramFiles%\eMule\
return

ffp:
Run, %A_ProgramFiles%\File and Folder Protector\FFP.exe, %A_ProgramFiles%\File and Folder Protector\
return

fraps:
StringLeft, v_frapspartition, A_WinDir, 1
Run, %v_frapspartition%:\Fraps\fraps.exe, %v_frapspartition%:\Fraps\
return

lifeviewtvr:
Run, %A_ProgramFiles%\LifeView TVR\TVR.exe, %A_ProgramFiles%\LifeView TVR\
return

firefox:
Run, %A_ProgramFiles%\Mozilla Firefox\firefox.exe, %A_ProgramFiles%\Mozilla Firefox\
return

stopwatch:
Run, %A_ProgramFiles%\Multitrack Stopwatch\mwatch.exe, %A_ProgramFiles%\Multitrack Stopwatch\
return

objectdock:
Run, %A_ProgramFiles%\Stardock\ObjectDock\ObjectDock.exe, %A_ProgramFiles%\Stardock\ObjectDock\
return

offlineexplorer:
Run, %A_ProgramFiles%\Offline Explorer Enterprise\OE.exe, %A_ProgramFiles%\Offline Explorer Enterprise\
return

partitionmagic:
Run, %A_ProgramFiles%\PowerQuest\PartitionMagic 8.0\PMagic.exe, %A_ProgramFiles%\PowerQuest\PartitionMagic 8.0\
return

quicktime:
Run, %A_ProgramFiles%\QuickTime\QuickTimePlayer.exe, %A_ProgramFiles%\QuickTime\
return

realplayer:
Run, %A_ProgramFiles%\Real\RealOne Player\realplay.exe, %A_ProgramFiles%\Real\RealOne Player\
return

winamp:
Run, %A_ProgramFiles%\Winamp\winamp.exe, %A_ProgramFiles%\Winamp\
return

windowsmediaplayer:
Run, %A_ProgramFiles%\Windows Media Player\wmplayer.exe
return

msnmessenger:
Run, %A_ProgramFiles%\MSN Messenger\msnmsgr.exe
return

dvdripper:
Run, %A_ProgramFiles%\NO1 DVD Ripper\#1 DVD Ripper.exe
return

klite:
Run, %A_ProgramFiles%\K-Lite\khancer.exe
return

Mafia:
Run, Q:\Mafia\game.exe
return

mirascan:
Run, %A_ProgramFiles%\MiraScan\V4.03\MiraScan.exe
return

vlcmp:
Run, %A_ProgramFiles%\VideoLAN\VLC\vlc.exe, %A_ProgramFiles%\VideoLAN\VLC\
return


;"U:\Program Files\Alcohol Soft\Alcohol 120\AxCmd.exe" 1: /M:"T:\CD 1\st-nfsmw1.mds


; ============================= ASSIGN BITMAP TO MENU FUNCTION============================

/*   p_menu            = "MenuName" (e.g., Tray, etc.)
   p_item            = 1, ...
   p_bm_unchecked,
   p_bm_checked      = path to bitmap/false
   p_unchecked_face,
   p_checked_face      = true/false (i.e., true = pixels with same color as first pixel are transparent)
*/
Menu_AssignBitmap( p_menu, p_item, p_bm_unchecked, p_unchecked_face, p_bm_checked=false, p_checked_face=false )
{
   static   menu_list, h_menuDummy
   
   if h_menuDummy=
   {
      menu_list = |
   
      old_DetectHiddenWindows := A_DetectHiddenWindows
      DetectHiddenWindows, on
      
      Process, Exist
      pid_this := ErrorLevel
      
      Menu, menuDummy, Add
      Menu, menuDummy, DeleteAll
      
      Gui, 99:Menu, menuDummy
      
      h_menuDummy := DllCall( "GetMenu", "uint", WinExist( "ahk_class AutoHotkeyGUI ahk_pid " pid_this ) )

      Gui, 99:Menu
      
      DetectHiddenWindows, %old_DetectHiddenWindows%
   }
   
   if ( ! InStr( menu_list, "|" p_menu ",", false ) )
   {
      Menu, menuDummy, Add, :%p_menu%

      menu_ix := DllCall( "GetMenuItemCount", "uint", h_menuDummy )-1
   
      menu_list = %menu_list%%p_menu%,%menu_ix%|
   }
   else
   {
      menu_ix := InStr( menu_list, ",", false, InStr( menu_list, "|" p_menu ",", false ) )+1
      StringMid, menu_ix, menu_list, menu_ix, InStr( menu_list, "|", false, menu_ix )-menu_ix
   }
   
   h_menu := DllCall( "GetSubMenu", "uint", h_menuDummy, "int", menu_ix )
   
   if ( p_bm_unchecked )
   {
      hbm_unchecked := DllCall( "LoadImage"
                           , "uint", 0
                           , "str", p_bm_unchecked
                           , "uint", 0                           ; IMAGE_BITMAP
                           , "int", 0
                           , "int", 0
                           , "uint", 0x10|( 0x20*p_unchecked_face ) )   ; LR_LOADFROMFILE|LR_LOADTRANSPARENT
     
      if ( ErrorLevel or ! hbm_unchecked )
      {
         MsgBox, [Menu_AssignBitmap: LoadImage: unchecked] failed: EL = %ErrorLevel%
         return, false
      }
   }

   if ( p_bm_checked )
   {
      hbm_checked := DllCall( "LoadImage"
                           , "uint", 0
                           , "str", p_bm_checked
                           , "uint", 0                           ; IMAGE_BITMAP
                           , "int", 0
                           , "int", 0
                           , "uint", 0x10|( 0x20*p_checked_face ) )   ; LR_LOADFROMFILE|LR_LOADTRANSPARENT
	
      if ( ErrorLevel or ! hbm_checked )
      {
         MsgBox, [Menu_AssignBitmap: LoadImage: checked] failed: EL = %ErrorLevel%
         return, false
      }
   }

   success := DllCall( "SetMenuItemBitmaps"
                     , "uint", h_menu
                     , "uint", p_item-1
                     , "uint", 0x400                              ; MF_BYPOSITION
                     , "uint", hbm_unchecked
                     , "uint", hbm_checked )
   if ( ErrorLevel or ! success )
   {
      MsgBox, [Menu_AssignBitmap: SetMenuItemBitmaps] failed: EL = %ErrorLevel%
      return, false
   }
   
	
	hbm_checked =
	success =
	hbm_unchecked =
	p_bm_unchecked =
	h_menu =
	p_item =
	p_bm_checked =
	h_menuDummy =
	menu_ix =
	menu_list =
	p_menu =
	p_unchecked_face =
	p_bm_checked =
	p_checked_face =
	
   return, true
} 

