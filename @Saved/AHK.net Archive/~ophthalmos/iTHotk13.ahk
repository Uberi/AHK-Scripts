/*
Bugs
  only in 64bit: ..LButton (ShowTrack), ..RButton (Playlists), LV_ColorChange
GUIs
  1  Trackinfo
  2  About
  3  Trackart
  4  Hotkeys
  5  Volume
  6  Options
  7  Splashscreen
  8  Playlists
  9  Lyrics
 10  GetTextSize
Icons
  1  Standard
  2  Standby (Hotkeys deaktivert)
  3  Mute
  4  Stopped (PlayPause:)
*/
ScriptName = Hotkeys
ScriptVersion = 1.3
ScriptBuild = 2.0
ScriptDate = 18.10.11
HomePage = www.bluesquartett.de
FileDeleteOnExit := True ; only if A_IsCompiled ?!
#SingleInstance, Force
#NoEnv
ListLines, Off ; "ListLines Off" may improve performance by a few percent
SetBatchLines, -1 ; maximum speed; default is 10ms; useful for OnAboutToPromptUserToQuitEvent?
DetectHiddenWindows, On ; otherwise the script exits if iTunes is minimized
SetWorkingDir, %A_Temp%
IfEqual, A_IsUnicode, 1, FileEncoding, UTF-8 ; AHK_L
SplitPath, A_ScriptFullPath,,,, ScriptNoExt
GUIColor = EEEEEE
SplashColor = EEEEEE
DarkColor = C0C0C0
BackColor = 727272
OnExit, ExitSub
;If (!A_IsAdmin and !A_IsCompiled) ; für compiled version it's better to use Compile_AHK
;{
;   DllCall("shell32\ShellExecute", uint, 0, str, "RunAs", str, A_AhkPath
;      , str, """" . A_ScriptFullPath . """", str, A_WorkingDir, int, 1)
;   ExitApp
;}
StartTime := A_TickCount
iLanguage := SubStr(A_Language, 3, 2) = 07 ? "german" : "english" ; 0407, 0807, 0c07, 1007, 1407
If iLanguage = english
  {
    lng_4iTunes = for iTunes
    lng_About = About...
    lng_AfterRating = What should happen if you change the rating?
    lng_JumpNext_TT = Jump to the next track after changing the rating of the current track.
    lng_FeedBack = Display the new rating
    lng_FeedBack_TT = The new rating is displayed for a short time.
    lng_AltKey_TT = Use Alt key as modifier key
    lng_Behaviour = What do you want to see on your desktop?
    lng_Cancel = &Cancel
    lng_CheckedTracks = Checked
    lng_CloseButton = Close ; *
    lng_CloseWindow = Close window
    lng_Ctrl = Ctrl
    lng_CtrlKey_TT = Use Ctrl key as modifier key
    lng_DelPLImpossible = This playlist can not be delete from here
    lng_DelPLQuestion = Would you like to delete the playlist
    lng_DelPlaylist = Delete this playlist
    lng_DeleteDeadTrack = Delete this track from library?
    lng_DeleteTrack = Delete this track from playlist?
    lng_DeletedTracks = Deleted
    lng_Disclaimer =  This software may be redistributed freely, provided`nit is not changed in any way. Use it free of charge,`nbut at your own risk`; we cannot assume any gua-`nrantees for the functionality of this software.`nAll Rights reserved.
    lng_Drive = Drive
    lng_Eject = is opened
    lng_EmptyPlaylist = No objects in this playlist.
    lng_End = End
    lng_Exit = Exit
    lng_HKDisabled = All hotkeys are disabled.`nRe-enable it by using the right mouse key.
    lng_HKEnabled = Hotkeys enabled
    lng_Help = Hotkeys... ; used in menu
    lng_HelpFile = Help file
    lng_HelpFileNotFound = Cannot find the helpfile «iTHotkey.chm»!`n`nThe files «iTHotkey.chm» and «iTHotkey.exe»`nhave to be in the same folder.`n
    lng_LyricsCopy = Pressing Ctrl-C will copy this lyrics to the clipboard
    lng_LyricsImport = Click «Yes» to set this lyrics into the iTunes library.
    lng_InfoHeading =  Control iTunes with keyboard shortcuts without leaving your current application
    lng_Minipl_TT = Show Miniplayer at start-up
    lng_Modifiers = Which modifier keys do you want to use?
    lng_NewRating = New rating
    lng_JumpNext = Go to the next track
    lng_NoObjects = has no objects
    lng_NoTrayIcon = Should the icon in the taskbar notification area not be displayed?`n`nIf you choose «yes» the program can only be controlled by keyboard`nshortcuts. Use this option only if you know all the hotkeys.
		lng_NoiTunes = It could not be connected to iTunes.`nIf necessary`, please quit iTunes and`nprograms that also access iTunes.`nThen launch «%ScriptNoExt%» again.
    lng_NotRated = no rating
    lng_NothingToShow = No current track.`nCannot execute command.
    lng_Objects = Objects
    lng_OldRating = Old rating
    lng_Options = Options
    lng_OptionsText = These keys must be pressed in combination with certain other keys.`nPlease click to the icon in the tray for information about the hotkeys.`nThe hotkeys are similar to the keyboard shortcuts used in iTunes itself.
    lng_PlayPlaylist = Play this playlist
    lng_Playlist = Playlist
    lng_Playlists = Playlists
;    lng_PleaseWait = Please wait
    lng_ProgStart = How should iTunes be launched at program start?
    lng_QuitInfo = Closing %ScriptNoExt%
    lng_Rating = Rating
    lng_Rating = Rating
    lng_RemoveDeadTracks = Searching not available (dead) tracks
    lng_Retract = is closed
    lng_SearchDeadTracks = Searching for tracks that lack the original file
    lng_Shift = Shift
    lng_Space = Space
    lng_ShiftKey_TT = Use Shift key as modifier key
    lng_ShowIcon = Show icon in system tray
    lng_ShowIcon_TT = The tray icon can be made to disappear
    lng_ShowInfo = Show info window
    lng_ShowInfo_TT = On each track change an info window appears for some seconds.`nIf you choose «Off» this track info will be turned off.
    lng_SmartTrackDelete = Deleting a track is not possible.
    lng_Standard_TT = Recommended settings
    lng_Submenu = Advanced
    lng_Suspend = Disable Hotkeys
    lng_SwitchStatusError = Please activate in iTunes Preferences`n"Minimize iTunes window to system tray"`n(Menu Edit | Preferences | Advanced).
    lng_WebSite = Website
    lng_WinKey_TT = Use Win key as modifier key
    lng_iTFolderError = The iTunes-Folder could not be opened!
    lng_iTFolderShow = Explore iTunes Folder
    lng_iTHotkeyInfo = © W. Happe ; Launching
    lng_iTMini = Minimized
    lng_iTMini_TT = Start iTunes minimized
    lng_iTNorm_TT = Show iTunes at start-up
    lng_PlayOnStart = Start playing
    lng_PlayOnStart_TT = Start playing on start-up. When no playlist is selected, the iTunes window appears.
;    lng_iTunesQuit = Closing iTunes
    lng_key = key
    lng_off = Off
  }
Else
  {
    lng_4iTunes = für iTunes
    lng_About = Info über...
    lng_AfterRating = Was soll geschehen`, wenn Sie die Wertung ändern?
    lng_JumpNext_TT = Wenn Sie die Wertung des aktuellen Titels ändern`,`nwird sofort zum nächsten Titel gesprungen.
    lng_FeedBack = Neue Wertung einblenden ;Neue Wertung kurzzeitig einblenden
    lng_FeedBack_TT = Es wird ein Fenster mit der neuen Wertung kurzzeitig eingeblendet.
    lng_AltKey_TT = Alt-Taste als Modifier-Key verwenden
    lng_Behaviour = Welche Anzeigen sollen auf dem Bildschirm erscheinen?
    lng_Cancel = &Abbrechen
    lng_CheckedTracks = Geprüft
    lng_CloseButton = Schließen
    lng_CloseWindow = Fenster schließen
    lng_Ctrl = Strg
    lng_CtrlKey_TT = Strg-Taste als Modifier-Key verwenden
    lng_DelPLImpossible = Playliste läßt sich nicht von hier aus löschen
    lng_DelPLQuestion = Möchten Sie die Wiedergabeliste löschen
    lng_DelPlaylist = Playliste löschen
    lng_DeleteDeadTrack = Möchten Sie den Titel aus der Mediathek entfernen?
    lng_DeleteTrack = Möchten Sie den Titel aus der Liste entfernen?
    lng_DeletedTracks = Entfernt
    lng_Disclaimer = Sie dürfen diese Software kostenlos nutzen und in`nunveränderter Form weitergeben.`nAlle Rechte vorbehalten.`nDer Autor übernimmt keine Haftung für Schäden,`ndie durch die Verwendung der Software oder de-`nren möglichen fehlerhaften Funktionen entstehen.
    lng_Drive = Laufwerk
    lng_Eject = wird geöffnet
    lng_EmptyPlaylist = Enthält keine Objekte.
    lng_End = Ende
    lng_Exit = Beenden
    lng_HKDisabled = Alle Hotkeys wurden deaktiviert.`nUm Sie zu reaktivieren`, klicken Sie bitte mit der rechten Maustaste auf das Symbol im Infobereich der Taskleiste und wählen den entsprechenden Menüpunkt.
    lng_HKEnabled = Hotkeys aktiviert
    lng_Help = Hotkeys... ; used in menu
    lng_HelpFile = Hilfedatei
    lng_HelpFileNotFound = Die Hilfedatei «iTHotkey.chm» wurde nicht gefunden!`n`nDie Dateien «iTHotkey.chm» und «iTHotkey.exe»`nmüssen sich im selben Ordner befinden.`n
    lng_LyricsCopy = Mit Strg-C können Sie in die Zwischenablage kopieren.
    lng_LyricsImport = Klicken Sie «Ja», um diesen Text in iTunes einzutragen.
    lng_InfoHeading = Steuern Sie iTunes über die Tastatur wäh-`nrend Sie mit anderen Programmen arbeiten
    lng_Minipl_TT = iTunes im Miniplayer-Modus starten
    lng_Modifiers = Welche Modifier-Keys möchten Sie verwenden?
    lng_NewRating = Neue Wertung
    lng_JumpNext = Zum nächsten Titel springen
    lng_NoObjects = enthält keine Objekte
    lng_NoTrayIcon = Soll das Symbol im Infobereich der Taskleiste nicht angezeigt werden?`n`nDas Programm kann dann nur noch über Tastaturkürzel gesteuert werden.`nBenutzten Sie diese Option nur`, wenn Sie alle Hotkeys auswendig kennen.
    lng_NoiTunes = Es konnte keine Verbindung zu iTunes hergestellt werden.`nGegebenenfalls beenden Sie bitte iTunes und Programme`,`ndie ebenfalls auf iTunes zugreifen.`nStarten Sie dann «%ScriptNoExt%» erneut.
    lng_NotRated = unbewertet
    lng_NothingToShow = Derzeit wird kein Titel gespielt.`nDer Befehl kann nicht ausgeführt werden.
    lng_Objects = Objekte
    lng_OldRating = Alte Wertung
    lng_Options = Einstellungen
    lng_OptionsText = Diese Tasten ergeben in Kombination mit bestimmten Tasten einen Hotkey.`nKlicken Sie auf das Symbol im Infobereich der Taskleiste für eine Übersicht.`nDie Tastenkombinationen orientieren sich an Apples Vorgaben in iTunes.
    lng_PlayPlaylist = Playliste abspielen
    lng_Playlist = Wiedergabeliste
    lng_Playlists = Wiedergabelisten
;    lng_PleaseWait = Bitte warten
    lng_ProgStart = Wie soll iTunes beim Programmstart gestartet werden?
    lng_QuitInfo = %ScriptNoExt% wird beendet.
    lng_Rating = Wertung
    lng_Rating = Wertung
    lng_RemoveDeadTracks = Nicht verfügbare (verwaiste) Titel suchen
    lng_Retract = wird geschlossen
    lng_SearchDeadTracks = Suche nach fehlenden Originaldateien
    lng_Shift = Umschalt
    lng_ShiftKey_TT = Umschalt-Taste als Modifier-Key verwenden
    lng_Space = Leertaste
    lng_ShowIcon = Symbol im Systemtray anzeigen
    lng_ShowIcon_TT = Wenn das Symbol im Infobereich der Taskleiste nicht angezeigt wird,`nkann das Programm nur noch  über Tastaturkürzel gesteuert werden.
    lng_ShowInfo = Infofenster zeigen
    lng_ShowInfo_TT = Bei jedem Titelwechsel wird ein Infofenster für ein paar Sekunden eingeblendet.`nWenn Sie «Aus» einstellen`, wird die Anzeige abgestellt.
    lng_SmartTrackDelete = Das Entfernen einzelner Titel ist nicht möglich.
    lng_Standard_TT = Empfohlene Einstellungen
    lng_Submenu = Erweitert
    lng_Suspend = Hotkeys deaktivieren
    lng_SwitchStatusError = Bitte aktivieren Sie in den iTunes-Einstellungen`n„iTunes-Fenster in die Taskleiste minmieren“`n(Menü Bearbeiten | Einstellungen | Erweitert).
;    lng_TrackInfo = Titel-Info anzeigen
    lng_WebSite = Webseite
    lng_WinKey_TT = Windows-Taste als Modifier-Key verwenden
    lng_iTFolderError = Der iTunes-Ordner konnte nicht geöffnet werden!
    lng_iTFolderShow = Musikordner anzeigen
    lng_iTHotkeyInfo = © W. Happe ;  wird gestartet...
    lng_iTMini = Minimiert
    lng_iTMini_TT = iTunes automatisch in den Infobereich der Taskleiste minimieren
    lng_iTNorm_TT = iTunes beim Start anzeigen
    lng_PlayOnStart = Wiedergabe starten
    lng_PlayOnStart_TT = Beim Programmstart wird die Wiedergabe des Titels automatisch gestartet.`nWenn keine Wiedergabeliste ausgewählt ist, wird das iTunes-Fenster angezeigt.
;    lng_iTunesQuit = iTunes wird beendet.
    lng_key = Taste
    lng_off = Aus
  }
IfNotExist, iHotkey1.jpg
    Gosub, defArtworkDefault
IfNotExist, iHotkey1.png
    Gosub, defPng01
IfNotExist, iHotkey2.png
    Gosub, defPng02
IfNotExist, iHotkey3.png
    Gosub, defPng03
IfNotExist, iHotkey4.png
    Gosub, defPng04
IfNotExist, iHotkey5.png
    Gosub, defPng05
IfNotExist, iHotkey6.png
    Gosub, defPng06
IfNotExist, iHotkey7.png
    Gosub, defPng07
IfNotExist, iHotkey8.png
    Gosub, defPng08
IfNotExist, iHotkey9.png
    Gosub, defPng09
IfNotExist, iHotkey1.ico
    Gosub, defIco01
IfNotExist, iHotkey2.ico
    Gosub, defIco02
IfNotExist, iHotkey3.ico
    Gosub, defIco03
IfNotExist, iHotkey4.ico
    Gosub, defIco04
ArtworkFile = %A_Temp%\iHotkey2.jpg
ArtworkDefault = %A_Temp%\iHotkey1.jpg

GoSub, ReadReg
Menu, Tray, Icon, iHotkey1.ico, 1, 1
Menu, Tray, % If ShowIcon = 0 ? "NoIcon" : "Icon"
GoSub, HotkeysOn
Gosub, ModifiersNamed
hCurs := DllCall("LoadCursor", "UInt", NULL, "Int", 32649, "UInt") ;IDC_HAND

OnMessage(0x404, "AHK_NOTIFYICON")

; Spashscreen
Gui, 7: +Lastfound +AlwaysOnTop -Caption +Owner ; +Owner avoids a taskbar button.
Splash_GuiID := WinExist()
Gui, 7: Color, %SplashColor%
Gui, 7: Add, Picture, x0 y0 w290 h155, iHotkey9.png
Gui, 7: font, s14 bold, MS Sans Serif
Gui, 7: Add, Text, BackgroundTrans x5 y35 w280 Center, %ScriptName% %lng_4iTunes% %ScriptVersion%
Gui, 7: Font, s9 norm, MS Sans Serif
Gui, 7: Add, Text, BackgroundTrans x5 yp+45 w280 Center, %lng_iTHotkeyInfo%`, Build %ScriptVersion%.%ScriptBuild% (%ScriptDate%)
Gui, 7: Add, Text, BackgroundTrans cBlue gHomepage x5 yp+30 w280 Center, %HomePage%
WinSet, Region, 0-0 w290 h155 R12-12, ahk_id %Splash_GuiID% ; Changes the shape of a window
Sleep, 10 ; damit Ecken auf jeden Fall rund werden
Gui, 7: Show, w290 h155 NA
AlphaSpl = 255
SetTimer, FadeoutSplashGUI, -100, 2147483647 ; maximal priority
ComObjError(False) ; ignore registration error
iTunesApp := ComObjCreate("iTunes.Application") ; create the object
If ! iTunesApp
  {
    MsgBox, 262160, %ScriptName% %lng_4iTunes% %ScriptVersion%, %lng_NoiTunes%
    GoSub, ExitSub
  }
If PlayOnStart
    iTunesApp.Play
Else
  {
    NoPlayStart = 1
    iTunesApp.Play
    iTunesApp.PlayPause
  }
iTunesApp.Mute := False
If MaxMinStart = 1
  {
    iTunesApp.BrowserWindow.MiniPlayer := False
    iTunesApp.BrowserWindow.Minimized := True
  }
Else If MaxMinStart = 2
  {
    iTunesApp.BrowserWindow.MiniPlayer := False
    iTunesApp.BrowserWindow.Minimized := False
    iTunesApp.BrowserWindow.Visible := True
  }
Else
  {
    iTunesApp.BrowserWindow.Minimized := False
    iTunesApp.BrowserWindow.MiniPlayer := True
  }
getVersion := iTunesApp.Version
StringSplit, itVersion, getVersion, . ; for use in function «AtLeastVersion»
ArtworkFile = %A_Temp%\iHotkey2.jpg
ArtworkDefault = %A_Temp%\iHotkey1.jpg
If AtLeastVersion("4.7") and iTunesApp.PlayerState = 1 and iTunesApp.CurrentTrack.Artwork(1)
  {
  iTunesApp.CurrentTrack.Artwork(1).SaveArtworkToFile(ArtworkFile)
  TrackArt := ArtworkFile
  }
Else
  TrackArt := ArtworkDefault
; First start playing, afterward connect. Otherwise OnPlayerPlayEvent fires at start-up.
iTunesConn := ComObjConnect(iTunesApp, "iTunes_")
Gui, +ToolWindow -Caption ; +E0x20 = Transparent for clicks, hier unbrauchbar
Gui, +LastFoundExist ; to detect the existence of a GUI window
GuiID := WinExist() ; belongs to the line before
GroupAdd, GroupGuiID, ahk_id %GuiID%
Gui, color, %GUIColor% :  EEF3FA ; D1D7E2 ; 999999
Gui, Font, norm s9, MS Sans Serif
Gui, Margin, 0, 0
Gui, Add, Picture, x0 y0 w400, iHotkey9.png
Gui, Add, Picture, x8 y5 w120 h120 v_iTg_TrackArt AltSubmit, %TrackArt% ; AltSubmit
Gui, Add, Picture, BackgroundTrans x138 y8, iHotkey1.png
Gui, Add, Text, BackgroundTrans x160 y8 w235 v_iTg_TrackName		, %getTrackName%
Gui, Add, Picture, BackgroundTrans x138 y28, iHotkey2.png
Gui, Add, Text, BackgroundTrans x160 y28 w235 v_iTg_TrackArtist		, %getTrackArtist%
Gui, Add, Picture, BackgroundTrans x138 y48, iHotkey3.png
Gui, Add, Text, BackgroundTrans x160 y48 w235 v_iTg_TrackAlbum		, %getTrackAlbum%
Gui, Add, Picture, BackgroundTrans x138 y68, iHotkey4.png
Gui, Add, Text, BackgroundTrans x160 y68 w235 v_iTg_Playlist		, %getPlaylist%
Gui, Add, Picture, BackgroundTrans x138 y88, iHotkey6.png
Gui, Add, Text, BackgroundTrans x160 y88 w235 v_iTg_TrackRating		, %iTRating%
Gui, Add, Picture, BackgroundTrans x138 y108, iHotkey5.png
Gui, Add, Text, BackgroundTrans x160 y108 w235 v_iTg_TrackKind		, %TrackKind%
Gui, Add, Text, BackgroundTrans x8 y130 w120 center, %ScriptName% %lng_4iTunes% %ScriptVersion%
Gui, Add, Text, BackgroundTrans x138 y130 w30 v_iTg_TrackLengthPlayed, 0:00
Gui, Add, Progress, Background%BackColor% c%DarkColor% v_iTg_TrackProgress x168 y133 w150 h8, %Progress%
Gui, Add, Text, BackgroundTrans x320  y130  w35 v_iTg_TrackLengthLeft	, -0:00
Gui, Add, Text, BackgroundTrans x355  y130 w35 v_iTg_TrackLength	, / 0:00
Gui, Show, NA w400 h150 x%A_ScreenWidth% y%A_ScreenHeight%
WinSet, Region, 0-0 w400 h150 R12-12, ahk_id %GuiID% ; Changes the shape of a window
Gosub, TrayMenu ; requires getVersion
GoSub, CheckTrack
SetTimer, CheckTime, 1000
NoPlayStart = 0
Return
;################## end of auto-execute section ###########################

TrayMenu:
  MenuAbout    = %lng_About%`t%ModifiersName%A
  MenuHelpFile = %lng_HelpFile%`t%ModifiersName%F1
  MenuOptions  = %lng_Options%`t%ModifiersName%F2
  MenuHelp     = %lng_Help%`t%ModifiersName%H
  MenuSuspend = %lng_Suspend%`t%ModifiersName%F3
  MenuExit = %lng_Exit%`t%ModifiersName%%lng_End%
  Menu, Submenu, Add, %lng_RemoveDeadTracks%, RemoveDeadTracks
  If AtLeastVersion("7.0")
    Menu, Submenu, Add, %lng_iTFolderShow%, iTFolder
  Menu, Tray, Tip, %ScriptName% %lng_4iTunes%
  Menu, Tray, NoStandard
  Menu, Tray, Add, %MenuAbout%, iTHotkeyInfo
  Menu, Tray, Add, %MenuHelpFile%, iTHotkeyChm
  Menu, Tray, Add, %MenuOptions%, Options
  Menu, Tray, Add, %MenuHelp%, iTHotkeyHelp
  Menu, Tray, Add
  Menu, Tray, Add, %lng_Submenu%, :Submenu
  Menu, Tray, Add
  Menu, Tray, add, %MenuSuspend%, HotkeysSuspend
  Menu, Tray, Add, %MenuExit%, ExitiTunes
  Menu, Tray, Default, %MenuHelp%
  Menu, Tray, Click, 1
Return

HotkeysSuspend:
  teDeaktivieren := !teDeaktivieren
  If (teDeaktivieren)
    {
      IfNotExist, iHotkey2.ico
          Gosub, defIco02
      Suspend, On
      Menu, Tray, Icon, iHotkey2.ico, 1, 1
      TrayTip, %ScriptName% %lng_4iTunes% %ScriptVersion%, %lng_HKDisabled%,, 17
;     Process, Exist
;     tThWnd1 := WinExist("ahk_class tooltips_class32 ahk_pid " ErrorLevel)
;     WinSet AlwaysOnTop, On, ahk_id %tThWnd1%
      Settimer, RemoveTrayTip, -8000
      Menu, Tray, Check, %MenuSuspend%
      If MenuAbout <> %lng_About%
          Menu, Tray, Rename, %MenuAbout%, %lng_About%
      MenuAbout = %lng_About%
      If MenuHelpFile <> %lng_HelpFile%
          Menu, Tray, Rename, %MenuHelpFile%, %lng_HelpFile%
      MenuHelpFile = %lng_HelpFile%
      If MenuOptions <> %lng_Options%
          Menu, Tray, Rename, %MenuOptions%, %lng_Options%
      MenuOptions = %lng_Options%
      If MenuHelp <> %lng_Help%
          Menu, Tray, Rename, %MenuHelp%, %lng_Help%
      MenuHelp = %lng_Help%
      ;      If MenuTrackInfo <> %lng_TrackInfo%
      ;          Menu, Tray, Rename, %MenuTrackInfo%, %lng_TrackInfo%
      ;      MenuTrackInfo = %lng_TrackInfo%
      If MenuSuspend <> %lng_Suspend%
          Menu, Tray, Rename, %MenuSuspend%, %lng_Suspend%
      MenuSuspend = %lng_Suspend%
      If MenuExit <> %lng_Exit%
          Menu, Tray, Rename, %MenuExit%, %lng_Exit%
      MenuExit = %lng_Exit%
    }
  Else
    {
      IfNotExist, iHotkey1.ico
          Gosub, defIco01
      Suspend, Off
      Menu, Tray, Icon, iHotkey1.ico, 1, 1
      TrayTip, %ScriptName% %lng_4iTunes% %ScriptVersion%, %lng_HKEnabled%,, 17
      Settimer, RemoveTrayTip, -2000
      Menu, Tray, UnCheck, %MenuSuspend%
      GoSub, ChangeModifiersName
    }
Return

ChangeModifiersName:
  If MenuAbout <> %lng_About%`t%ModifiersName%A
      Menu, Tray, Rename, %MenuAbout%, %lng_About%`t%ModifiersName%A
  MenuAbout = %lng_About%`t%ModifiersName%A
  If MenuHelpFile <> %lng_HelpFile%`t%ModifiersName%F1
      Menu, Tray, Rename, %MenuHelpFile%, %lng_HelpFile%`t%ModifiersName%F1
  MenuHelpFile = %lng_HelpFile%`t%ModifiersName%F1
  If MenuOptions <> %lng_Options%`t%ModifiersName%F2
      Menu, Tray, Rename, %MenuOptions%, %lng_Options%`t%ModifiersName%F2
  MenuOptions = %lng_Options%`t%ModifiersName%F2
  If MenuHelp <> %lng_Help%`t%ModifiersName%H
      Menu, Tray, Rename, %MenuHelp%, %lng_Help%`t%ModifiersName%H
  MenuHelp = %lng_Help%`t%ModifiersName%H
;  If MenuTrackInfo <> %lng_TrackInfo%`t%ModifiersName%I
;      Menu, Tray, Rename, %MenuTrackInfo%, %lng_TrackInfo%`t%ModifiersName%I
;  MenuTrackInfo = %lng_TrackInfo%`t%ModifiersName%I
  If MenuSuspend <> %lng_Suspend%`t%ModifiersName%F3
      Menu, Tray, Rename, %MenuSuspend%, %lng_Suspend%`t%ModifiersName%F3
  MenuSuspend = %lng_Suspend%`t%ModifiersName%F3
  If MenuExit <> %lng_Exit%`t%ModifiersName%%lng_End%
      Menu, Tray, Rename, %MenuExit%, %lng_Exit%`t%ModifiersName%%lng_End%
  MenuExit = %lng_Exit%`t%ModifiersName%%lng_End%
Return

RemoveTrayTip:
;  SetTimer, RemoveTrayTip, Off
  TrayTip
Return

FadeoutSplashGUI:
  Critical ; "Critical" is generally superior to "Thread Priority"
  If ((A_TickCount - StartTime) > 3000) ; milliseconds have elapsed
    GoSub, DestroySplashGUI
  WinSet, Transparent, %AlphaSpl%, ahk_id %Splash_GuiID%
  EnvSub, AlphaSpl, 5
  SetTimer, FadeoutSplashGUI, % (AlphaSpl<=0 ? "Off" : (AlphaSpl<100 ? 10 : (AlphaSpl<150 ? 20 : 30))), 2147483647
  SetTimer, DestroySplashGUI, % (AlphaSpl<=0 ? -1 : "Off"), 2147483647
Return

DestroySplashGUI:
  Gui, 7: Destroy
Return

ReadReg:
  RegRead, Modifiers, HKEY_LOCAL_MACHINE, SOFTWARE\OPHTHALMOSTAR\%ScriptNoExt%, Modifiers
  If ErrorLevel  ; if there was a problem (such as a nonexistent key or value)
    Modifiers = !#
  RegRead, MaxMinStart, HKEY_LOCAL_MACHINE, SOFTWARE\OPHTHALMOSTAR\%ScriptNoExt%, MaxMinStart
  If ErrorLevel  ; if there was a problem (such as a nonexistent key or value)
    MaxMinStart = 1
  RegRead, PlayOnStart, HKEY_LOCAL_MACHINE, SOFTWARE\OPHTHALMOSTAR\%ScriptNoExt%, PlayOnStart
  If ErrorLevel  ; if there was a problem (such as a nonexistent key or value)
    PlayOnStart = 1
  RegRead, JumpNext, HKEY_LOCAL_MACHINE, SOFTWARE\OPHTHALMOSTAR\%ScriptNoExt%, JumpNext
  If ErrorLevel  ; if there was a problem (such as a nonexistent key or value)
    JumpNext = 0
  RegRead, FeedBack, HKEY_LOCAL_MACHINE, SOFTWARE\OPHTHALMOSTAR\%ScriptNoExt%, FeedBack
  If ErrorLevel  ; if there was a problem (such as a nonexistent key or value)
    FeedBack = 1
  RegRead, ShowInfo, HKEY_LOCAL_MACHINE, SOFTWARE\OPHTHALMOSTAR\%ScriptNoExt%, ShowInfo
  If ErrorLevel  ; if there was a problem (such as a nonexistent key or value)
    ShowInfo = 3
  RegRead, ShowIcon, HKEY_LOCAL_MACHINE, SOFTWARE\OPHTHALMOSTAR\%ScriptNoExt%, ShowIcon
  If ErrorLevel  ; if there was a problem (such as a nonexistent key or value)
    ShowIcon = 1

  If ShowInfo in 0,1,2,3,4,5
    ShowInfo := ShowInfo
  Else
    ShowInfo = 3
  FadeTimeout := ShowInfo * 1000

  If ShowIcon != 0
    ShowIcon = 1
Return

HotkeysOn:
  Hotkey, %Modifiers%p,                Playlists,      On
  Hotkey, %Modifiers%RButton,          Playlists,      On
  Hotkey, %Modifiers%#,                SwitchStatus,   On ; #!Enter is reserved for MediaCenter!
  Hotkey, %Modifiers%Right,            NextTrack,      On
  Hotkey, %Modifiers%Left,             PreviousTrack,  On
  Hotkey, %Modifiers%NumpadAdd,        VolumeUp,       On
  Hotkey, %Modifiers%+,                VolumeUp,       On
  Hotkey, %Modifiers%NumpadSub,        VolumeDown,     On
  Hotkey, %Modifiers%-,                VolumeDown,     On
  Hotkey, %Modifiers%Space,            PlayPause,      On
  Hotkey, %Modifiers%g,                Artwork,        On
  Hotkey, %Modifiers%v,                Visuals,        On
  Hotkey, %Modifiers%Home,             Reposition,     On
  Hotkey, %Modifiers%End,              ExitiTunes,     On
  Hotkey, %Modifiers%Up,               SkipForward,    On
  Hotkey, %Modifiers%Down,             SkipBackward,   On
  BreakKey := InStr(Modifiers,"^") ? "CtrlBreak" : "Break"
  Hotkey, %Modifiers%%BreakKey%,       ToggleMute,     On
  Hotkey, %Modifiers%i,                ShowTrack,      On
  Hotkey, %Modifiers%LButton,          ShowTrack,      On
  Hotkey, %Modifiers%m,                MiniPlayer,     On
  Hotkey, %Modifiers%r,                ExploreTrack,   On
  Hotkey, %Modifiers%l,                ShowLyrics,     On
  Hotkey, %Modifiers%0,                Rating0,        On
  Hotkey, %Modifiers%Numpad0,          Rating0,        On
  Hotkey, %Modifiers%1,                Rating1,        On
  Hotkey, %Modifiers%Numpad1,          Rating1,        On
  Hotkey, %Modifiers%2,                Rating2,        On
  Hotkey, %Modifiers%Numpad2,          Rating2,        On
  Hotkey, %Modifiers%3,                Rating3,        On
  Hotkey, %Modifiers%Numpad3,          Rating3,        On
  Hotkey, %Modifiers%4,                Rating4,        On
  Hotkey, %Modifiers%Numpad4,          Rating4,        On
  Hotkey, %Modifiers%5,                Rating5,        On
  Hotkey, %Modifiers%Numpad5,          Rating5,        On
  Hotkey, %Modifiers%h,                iTHotkeyHelp,   On
  Hotkey, %Modifiers%a,                iTHotkeyInfo,   On
  Hotkey, %Modifiers%F1,               iTHotkeyChm,    On
  Hotkey, %Modifiers%F2,               Options,        On
  Hotkey, %Modifiers%F3,               HotkeysSuspend, On
  Hotkey, %Modifiers%e,                EjectDrive,     On
  Hotkey, %Modifiers%Del,              DeleteTrack,    On
Return

ModifiersNamed:
  ModifiersName := InStr(Modifiers, "!") ? "Alt+"                         : ""
  ModifiersName := InStr(Modifiers, "#") ? "Win+" .          ModifiersName  : ModifiersName
  ModifiersName := InStr(Modifiers, "^") ? lng_Ctrl . "+"  . ModifiersName  : ModifiersName
  ModifiersName := InStr(Modifiers, "+") ? lng_Shift . "+" . ModifiersName  : ModifiersName
Return

Playlists:
  If (A_PriorHotKey = A_ThisHotKey and A_TimeSincePriorHotkey < 100)
    Return ; if the key is not released
  IfWinExist, ahk_id %pl_GuiID% ;  and InStr(A_ThisHotkey,"RButton")
    {
      GoSub, 8GuiClose
	    Return
    }
  Gui, 8: +AlwaysOnTop -MinimizeBox -MaximizeBox +LastFound
  pl_GuiID := WinExist()
  GroupAdd, LV_GroupID, ahk_id %pl_GuiID%
  Gui, 8: Default ; StatusBar
  Gui, 8: Color, %GUIColor%
  Gui, 8: Font, norm s10, MS Sans Serif
  Gui, 8: Margin, 1, 1
;  Gui, 8: Add, Button, Hidden Default, OK ; detect when the user has pressed Enter
  pl_Rows =
  Loop, % iTunesApp.LibrarySource.Playlists.Count
    {
    If iTunesApp.LibrarySource.Playlists.Item(A_Index).Kind = 2
      pl_Rows ++
    }
pl_Height := (A_ScreenHeight - 100) // pl_Rows < 20 ? "h" . A_ScreenHeight - 100 : "r" . pl_Rows
Gui, 8: Add, ListView, xm ym w218 %pl_Height% gLV_Playlists vLV_Playlists HWNDhw_LV_ColorChange ReadOnly -Multi -Hdr AltSubmit -E0x200, Item|Playlist
  pl_Current := iTunesApp.CurrentPlaylist.Name
  Loop, % iTunesApp.LibrarySource.Playlists.Count
    {
    If iTunesApp.LibrarySource.Playlists.Item(A_Index).Kind = 2
      {
      pl_Name := iTunesApp.LibrarySource.Playlists.Item(A_Index).Name
      If (pl_Current = pl_Name) ; If Instr(pl_Current,pl_Name)
        LV_Add("Focus", A_Index, pl_Name)
      Else
        LV_Add("", A_Index, pl_Name)
      }
    }
  LV_ModifyCol(1, 0) ; hide Column 1
  LV_ModifyCol(2, 200)
  Gui, 8: font, s8 ;, MS Sans Serif
  Gui, 8: Add, StatusBar ;, 0x100
  SB_SetText(LV_GetCount() " " lng_Playlists)
  Gui, 8: Show, Autosize, %lng_Playlists%
  VarSetCapacity(LvItem, 36, 0)
  OnMessage(0x06, "WM_ACTIVATE") ; window lost focus > destroy
  OnMessage(0x4E, "WM_NOTIFY")
  If A_PtrSize = 4  ; bytes of a pointer. This is either 4 (32-bit) or 8 (64-bit).
	{
  	Loop, % LV_GetCount() ; Highlighting alternating lines in the listview.
	    {
    	If (Mod(A_Index, 2))
	      LV_ColorChange(A_Index, "0x000000", "0xFBF7F3")
    	}
	}
Return

WM_ACTIVATE(wParam) ; message is sent to both the window being activated and deactivated
  {
  If (wParam = 0 and A_Gui = 8) ; if(wParam>0) ; => window activated
    GoSub, 8GuiClose
  }

#IfWinActive, ahk_group LV_GroupID
Down::
*WheelDown::
  Gui, 8: Default
  pl_Number := LV_GetNext(0, "F")
  pl_Number := pl_Number = pl_Rows ? 1 : pl_Number + 1
  LV_Modify(pl_Number, "Focus Select Vis")
Return

Up::
*WheelUp::
  Gui, 8: Default
  pl_Number := LV_GetNext(0, "F")
  pl_Number := pl_Number = 1 ? pl_Rows : pl_Number - 1
  LV_Modify(pl_Number, "Focus Select Vis")
Return

Enter::
MButton::
  Gui, 8: Default
  LV_GetText(pl_Item, LV_GetNext(0, "Focused"), 1)
  GoSub, pl_MenuPlay
Return

Del::
  Gui, 8: Default
  Gui, 8: +OwnDialogs ; MsgBox, InputBox, FileSelectFile, FileSelectFolder  should be owned
  LV_GetText(pl_Item, LV_GetNext(0, "Focused"), 1)
      If ! iTunesApp.LibrarySource.Playlists.Item(pl_Item).Smart
          GoSub, pl_MenuDelete
  Else
    {
      OnMessage(0x06, "") ; necessary in WIN_7
      MsgBox, 262192, %ScriptName% %lng_4iTunes% %ScriptVersion%, %lng_DelPLImpossible%!
      OnMessage(0x06, "WM_ACTIVATE") ; window lost focus > destroy
    }
Return
#IfWinActive

8GuiContextMenu:
  If A_GuiControl <> LV_Playlists
    Return
  LV_GetText(pl_Item, LV_GetNext(0, "Focused"), 1)
  Menu, pl_Menu, Add  ; Clear any existing menu and add a null item.
  Menu, pl_Menu, Delete
  Menu, pl_Menu, Add, %lng_PlayPlaylist%, pl_MenuPlay
  If iTunesApp.LibrarySource.Playlists.Item(pl_Item).Kind = 2
    {
      If ! iTunesApp.LibrarySource.Playlists.Item(pl_Item).Smart
        Menu, pl_Menu, Add, %lng_DelPlaylist%..., pl_MenuDelete
    }
  Menu, pl_Menu, Add
  Menu, pl_Menu, Add, %lng_CloseWindow%, 8GuiClose
  Menu, pl_Menu, Show, %A_GuiX%, %A_GuiY%
Return

LV_Playlists:
  Critical ; ensures that all "I" notifications are received
  If (A_GuiEvent = "I" AND InStr(ErrorLevel, "SF", true))
    {
    LV_GetText(pl_Item, A_EventInfo, 1)
    pl_Objects := iTunesApp.LibrarySource.Playlists.Item(pl_Item).Tracks.Count
    pl_Objects := pl_Objects = 1 ? pl_Objects " " SubStr(lng_Objects,1,-1) : pl_Objects = 0 ? lng_EmptyPlaylist : pl_Objects " " lng_Objects
    SB_SetText(pl_Objects)
    }
  Else If A_GuiEvent = DoubleClick
    {
    LV_GetText(pl_Item, A_EventInfo, 1)
    GoSub, pl_MenuPlay
    }
Return

pl_MenuPlay:
  Gui, 8: +OwnDialogs ; MsgBox, InputBox, FileSelectFile, FileSelectFolder  should be owned
  If iTunesApp.LibrarySource.Playlists.Item(pl_Item).Tracks.Count
    {
    iTunesApp.LibrarySource.Playlists.Item(pl_Item).PlayFirstTrack
    If iTunesApp.CurrentPlaylist.Shuffle
      iTunesApp.NextTrack
;    If AtLeastVersion("7.4") and iTunesApp.BrowserWindow.Visible and not iTunesApp.BrowserWindow.MiniPlayer
;      iTunesApp.LibrarySource.Playlists.Item(pl_Item).Reveal ; available in iTunes 7.4 and later
    GoSub, 8GuiClose
    }
  Else
    {
    pl_Name := iTunesApp.LibrarySource.Playlists.Item(pl_Item).Name
    OnMessage(0x06, "") ; necessary in WIN_7
    MsgBox, 262192, %ScriptName% %lng_4iTunes% %ScriptVersion%, «%pl_Name%» %lng_NoObjects%.
    OnMessage(0x06, "WM_ACTIVATE") ; window lost focus > destroy
    }
Return

pl_MenuDelete:
  Gui, 8: +OwnDialogs ; MsgBox, InputBox, FileSelectFile, FileSelectFolder  should be owned
  pl_Name := iTunesApp.LibrarySource.Playlists.Item(pl_Item).Name
  OnMessage(0x06, "") ; necessary in WIN_7
  MsgBox, 262436, %ScriptName% %lng_4iTunes% %ScriptVersion%, %lng_DelPLQuestion% (%pl_Name%)?
  OnMessage(0x06, "WM_ACTIVATE") ; window lost focus > destroy
  IfMsgBox, Yes
    {
    pl_Current := iTunesApp.CurrentPlaylist.Name
    {
    If (pl_Current = pl_Name) ; If Instr(pl_Current,pl_Name) ; active playlist
      {
;      If AtLeastVersion("7.4") and iTunesApp.BrowserWindow.Visible and not iTunesApp.BrowserWindow.MiniPlayer
;        iTunesApp.LibraryPlaylist.Reveal ; available in iTunes 7.4 and later
      iTunesApp.LibraryPlaylist.PlayFirstTrack
      iTunesApp.Stop
      }
    }
    iTunesApp.LibrarySource.Playlists.Item(pl_Item).Delete
  GoSub, Playlists
  }
Return

8GuiClose:
8GuiEscape:
  OnMessage(0x06, "")
  OnMessage(0x4E, "")
	Gui, 8: Destroy
Return

;--------------------------------------------------------------------------------
; Listview colors for individual lines (e.g. highlighting)
; by evl
; http://www.autohotkey.com/forum/topic9266.html
;--------------------------------------------------------------------------------
LV_ColorChange(Index="", TextColor="", BackColor="") ; change specific line's color or reset all lines
  {
  global
  If Index =
    Loop, % LV_GetCount()
      LV_ColorChange(A_Index)
  Else
    {
    Line_Color_%Index%_Text := TextColor
    Line_Color_%Index%_Back := BackColor
    WinSet, Redraw,, ahk_id %hw_LV_ColorChange%
    }
  }

WM_NOTIFY( p_w, p_l, p_m )
  {
  local draw_stage, Current_Line, Index, IsSelected=0
  Critical
  If ( DecodeInteger( "uint4", p_l, 0 ) = hw_LV_ColorChange ) {      ; NMHDR->hwndFrom
    If ( DecodeInteger( "int4", p_l, 8 ) = -12 ) {                ; NMHDR->code ; NM_CUSTOMDRAW
      draw_stage := DecodeInteger( "uint4", p_l, 12 )                     ; NMCUSTOMDRAW->dwDrawStage
      Current_Line := DecodeInteger( "uint4", p_l, 36 )+1               ; NMCUSTOMDRAW->dwItemSpec
      If ( draw_stage = 1 )                                       ; CDDS_PREPAINT
        return, 0x20                                              ; CDRF_NOTIFYITEMDRAW
      Else If ( draw_stage = 0x10000|1 ) {                        ; CDDS_ITEMPREPAINT
        If ( DllCall("GetFocus") = hw_LV_ColorChange ) {                ; Control has Keyboard Focus?
          SendMessage, 4140, Current_Line-1, 2, , ahk_id %hw_LV_ColorChange% ; LVM_GETITEMSTATE
          IsSelected := ErrorLevel
          If ( IsSelected = 2 ) {                                                 ; LVIS_SELECTED
            EncodeInteger( "0xFFFFFF", 4, p_l, 48 )                      ; NMCUSTOMDRAW->clrText ; foreground
            EncodeInteger( "0xDF803D", 4, p_l, 52 )                      ; NMCUSTOMDRAW->clrTextBk ; background
            EncodeInteger(0x0, 4, &LvItem, 12)                            ; LVITEM->state
            EncodeInteger(0x2, 4, &LvItem, 16)                            ; LVITEM->stateMask ; LVIS_SELECTED
            SendMessage, 4139, Current_Line-1, &LvItem, , ahk_id %hw_LV_ColorChange% ; Disable Highlighting
            ; We want item post-paint notifications
            Return, 0x00000010                                                    ; CDRF_NOTIFYPOSTPAINT
            }
          If (Line_Color_%Current_Line%_Text != "") {
            EncodeInteger( Line_Color_%Current_Line%_Text, 4, p_l, 48 ) ; NMLVCUSTOMDRAW->clrText ; foreground
            EncodeInteger( Line_Color_%Current_Line%_Back, 4, p_l, 52 ) ; NMLVCUSTOMDRAW->clrTextBk ; background
            }
          }
        }
      Else If ( draw_stage = 0x10000|2 )                  ; CDDS_ITEMPOSTPAINT
        If ( IsSelected ) {
          EncodeInteger(0x02, 4, &LvItem, 12)            ; LVITEM->state
          EncodeInteger(0x02, 4, &LvItem, 16)            ; LVITEM->stateMask ; LVIS_SELECTED
          SendMessage, 4139, Current_Line-1, &LvItem, , ahk_id %hw_LV_ColorChange% ; LVM_SETITEMSTATE
          }
      }
    }
  }

DecodeInteger( p_type, p_address, p_offset, p_hex=true )
  {
  old_FormatInteger := A_FormatInteger
  IfEqual, p_hex, 1, SetFormat, Integer, hex
  Else, SetFormat, Integer, dec
  StringRight, size, p_type, 1
  Loop, %size%
    value += *( ( p_address+p_offset )+( A_Index-1 ) ) << ( 8*( A_Index-1 ) )
  If ( size <= 4 and InStr( p_type, "u" ) != 1 and *( p_address+p_offset+( size-1 ) ) & 0x80 )
    value := -( ( ~value+1 ) & ( ( 2**( 8*size ) )-1 ) )
  SetFormat, Integer, %old_FormatInteger%
  return, value
  }

EncodeInteger( p_value, p_size, p_address, p_offset )
  {
  Loop, %p_size%
    DllCall( "RtlFillMemory", "uint", p_address+p_offset+A_Index-1, "uint", 1, "uchar", p_value >> ( 8*( A_Index-1 ) ) )
  }


SwitchStatus:
  If (A_PriorHotKey = A_ThisHotKey and A_TimeSincePriorHotkey < 100)
    Return ; if the key is not released
  If iTunesApp.BrowserWindow.Visible
    {
    iTunesApp.BrowserWindow.Minimized := True
    If iTunesApp.BrowserWindow.Visible
      MsgBox, 262192, %ScriptName% %lng_4iTunes% %ScriptVersion%, %lng_SwitchStatusError%
    }
  Else
    {
    iTunesApp.BrowserWindow.Minimized := False
;	  If not iTunesApp.BrowserWindow.MiniPlayer and AtLeastVersion("7.4")
;    	iTunesApp.CurrentTrack.Reveal ; available in iTunes 7.4 and later
    iTunesApp.BrowserWindow.Visible := True
    }
Return

Media_Next::
NextTrack:
  If (A_PriorHotKey = A_ThisHotKey and A_TimeSincePriorHotkey < 100 and A_TimeSincePriorHotkey > 0)
    Return ; if the key is not released ; A_TimeSincePriorHotkey will be -1 if A_PriorHotkey is blank.
  If iTunesApp.Mute
    {
      Gosub, ToggleMute
    }
  iTunesApp.Play
  iTunesApp.NextTrack
  SetTimer, FadeOut, -%FadeTimeout%
;  If iTunesApp.CurrentPlaylist.Smart and iTunesApp.BrowserWindow.Visible and not iTunesApp.BrowserWindow.MiniPlayer and AtLeastVersion("7.4")
;		iTunesApp.CurrentTrack.Reveal ; available in iTunes 7.4 and later
Return

Media_Prev::
PreviousTrack:
  If (A_PriorHotKey = A_ThisHotKey and A_TimeSincePriorHotkey < 100 and A_TimeSincePriorHotkey > 0)
    Return ; if the key is not released ; A_TimeSincePriorHotkey will be -1 if A_PriorHotkey is blank.
  If iTunesApp.Mute
    {
      Gosub, ToggleMute
    }
  iTunesApp.Play
  iTunesApp.PreviousTrack
  SetTimer, FadeOut, -%FadeTimeout%
;  If iTunesApp.CurrentPlaylist.Smart and iTunesApp.BrowserWindow.Visible and not iTunesApp.BrowserWindow.MiniPlayer and AtLeastVersion("7.4")
;		iTunesApp.CurrentTrack.Reveal ; available in iTunes 7.4 and later
Return

SkipForward:
  If WindowShow = 0
      GoSub, FadeIn
  If iTunesApp.Mute
    {
      Gosub, ToggleMute
    }
  iTunesApp.PlayerPosition := iTunesApp.PlayerPosition + 5
  Duration	:= iTunesApp.CurrentTrack.Duration
  Position := iTunesApp.PlayerPosition
  TimePlayed := SecToMMSS(Position)
  TimeLeft := "-" . SecToMMSS(Duration-Position)
  RegexMatch((Position/Duration)*100, "[^\.]*",Progress)
  Gui, Default
  GuiControl,, _iTg_TrackProgress, %Progress%
  GuiControl,, _iTg_TrackLengthPlayed, %TimePlayed%
  GuiControl,, _iTg_TrackLengthLeft, %TimeLeft%
  SetTimer, FadeOut, -%FadeTimeout%
Return

SkipBackward:
  If WindowShow = 0
      GoSub, FadeIn
  If iTunesApp.Mute
    {
      Gosub, ToggleMute
    }
  iTunesApp.PlayerPosition := iTunesApp.PlayerPosition - 5
  Duration := iTunesApp.CurrentTrack.Duration
  Position := iTunesApp.PlayerPosition
  TimePlayed := SecToMMSS(Position)
  TimeLeft := "-" . SecToMMSS(Duration-Position)
  RegexMatch((Position/Duration)*100, "[^\.]*",Progress)
  Gui, Default
  GuiControl,, _iTg_TrackProgress, %Progress%
  GuiControl,, _iTg_TrackLengthPlayed, %TimePlayed%
  GuiControl,, _iTg_TrackLengthLeft, %TimeLeft%
  SetTimer, FadeOut, -%FadeTimeout%
Return

Media_Play_Pause::
PlayPause:
  iTunesApp.PlayPause
  If iTunesApp.PlayerState = 0 ; is not playing
    {
      IfNotExist, iHotkey4.ico
        Gosub, defIco04
      Menu, Tray, Icon, iHotkey4.ico, 1, 1
    }
  Else
    {
     IfNotExist, iHotkey1.ico
       Gosub, defIco01
     Menu, Tray, Icon, iHotkey1.ico, 1, 1
    }
  If iTunesApp.Mute
    {
      Gosub, ToggleMute
    }
Return

Media_Stop::
  iTunesApp.Stop
Return

DeleteTrack:
  If (A_PriorHotKey = A_ThisHotKey and A_TimeSincePriorHotkey < 100)
    Return ; if the key is not released
  getPlaylist	:= iTunesApp.CurrentPlaylist.Name
  getCurrentTrack	:= iTunesApp.CurrentTrack
  getArtist := iTunesApp.CurrentTrack.Artist
  getName := iTunesApp.CurrentTrack.Name
  If getArtist !=
      getArtist = %getArtist%:
  If iTunesApp.CurrentPlaylist.Smart
      MsgBox, 262192, %ScriptName% %lng_4iTunes% %ScriptVersion%, %lng_Playlist%: %getPlaylist%`n`n%lng_SmartTrackDelete%
  Else If getCurrentTrack
    {
      MsgBox, 262436, %ScriptName% %lng_4iTunes% %ScriptVersion%, %lng_Playlist%: %getPlaylist%`n`n%getArtist% %getName%`n`n%lng_DeleteTrack%
      IfMsgBox, Yes
        {
          iTunesApp.CurrentTrack.Delete
          Sleep, 400
          iTunesApp.Play
          getCurrentTrack	:= iTunesApp.CurrentTrack
          If getCurrentTrack = 0
            {
              iTunesApp.BrowserWindow.MiniPlayer := False
              iTunesApp.BrowserWindow.Minimized := False
              iTunesApp.BrowserWindow.Visible := True
;          SplashImage,, CW%SplashColor% b1 FS10 W300, %lng_NothingToShow%, %ScriptName% %lng_4iTunes% %ScriptVersion%
;          Settimer, SplashOffModKey, -4000
              MsgBox, 262192, %ScriptName% %lng_4iTunes% %ScriptVersion%, %lng_NothingToShow%
            }
        }
    }
  Else
    {
      iTunesApp.BrowserWindow.MiniPlayer := False
      iTunesApp.BrowserWindow.Minimized := False
      iTunesApp.BrowserWindow.Visible := True
      MsgBox, 262192, %ScriptName% %lng_4iTunes% %ScriptVersion%, %lng_NothingToShow%
    }
Return

Artwork:
  If (A_PriorHotKey = A_ThisHotKey and A_TimeSincePriorHotkey < 100)
    Return ; if the key is not released
  Gui, 3: +LastFoundExist
  IfWinExist
    {
      Gui, 3: Destroy
      Return
    }
  Gui, 3: Color, %GUIColor%
  Gui, 3: -MinimizeBox -MaximizeBox ; -SysMenu
  Gui, 3: Add, Picture, AltSubmit, %TrackArt% ; AltSubmit
  Gui, 3: Add, Button, Default g3ButtonClose, %lng_CloseButton%
  Gui, 3: Show, AutoSize, %ScriptName% %lng_4iTunes% %ScriptVersion%
Return

3ButtonClose:
3GuiClose:
3GuiEscape:
  Gui, 3: Destroy
Return

Visuals:
  If (A_PriorHotKey = A_ThisHotKey and A_TimeSincePriorHotkey < 100)
    Return ; if the key is not released
  iTunesApp.FullScreenVisuals := True
  If iTunesApp.VisualsEnabled
      iTunesApp.VisualsEnabled := False
  Else
      iTunesApp.VisualsEnabled := True
Return

Reposition:
  If WindowShow = 0
      GoSub, FadeIn
  If iTunesApp.Mute
    {
      Gosub, ToggleMute
    }
  iTunesApp.BackTrack
  Duration := iTunesApp.CurrentTrack.Duration
  Position := iTunesApp.PlayerPosition
  TimePlayed := SecToMMSS(Position)
  TimeLeft := "-" . SecToMMSS(Duration-Position)
  RegexMatch((Position/Duration)*100, "[^\.]*",Progress)
  Gui, Default
  GuiControl,, _iTg_TrackProgress, %Progress%
  GuiControl,, _iTg_TrackLengthPlayed, %TimePlayed%
  GuiControl,, _iTg_TrackLengthLeft, %TimeLeft%
  SetTimer, FadeOut, -%FadeTimeout%
Return

RemoveDeadTracks:
;  Gui, Show, Hide y%A_ScreenHeight%
  deadTracks = 0
  deletedTracks = 0
  numTracks := iTunesApp.LibraryPlaylist.Tracks.Count
  totalTracks := numTracks
  Progress, R0-%totalTracks% FM8 WM400 FS8 WS400 C10, 0, %lng_SearchDeadTracks%..., %ScriptName% %lng_4iTunes% %ScriptVersion%, MS Sans Serif
  While (numTracks != 0)
    {
    checkedTracks := A_Index
    Progress, %A_Index%, %A_Index%
    If iTunesApp.LibraryPlaylist.Tracks.Item(numTracks).Kind = 1 ; (1) Library playlist
      {
      If iTunesApp.LibraryPlaylist.Tracks.Item(numTracks).Location = ""
        {
        Progress, Off
        deadTracks ++
        tempVar1 := iTunesApp.LibraryPlaylist.Tracks.Item(numTracks).Artist
        tempVar2 := iTunesApp.LibraryPlaylist.Tracks.Item(numTracks).Name
        MsgBox, 262179, %ScriptName% %lng_4iTunes% %ScriptVersion%, %tempVar1% - %tempVar2%`n`n%lng_DeleteDeadTrack%
        IfMsgBox, Yes
          {
          iTunesApp.LibraryPlaylist.Tracks.Item(numTracks).Delete
          deletedTracks ++
          }
        IfMsgBox, Cancel
          Break
        Progress, R0-%totalTracks% FM8 WM400 FS8 WS400, %A_Index% C10, %lng_SearchDeadTracks%..., %ScriptName% %lng_4iTunes% %ScriptVersion%, MS Sans Serif
        }
      }
    numTracks --
    }
  Progress, Off
  MsgBox, 262208, %ScriptName% %lng_4iTunes% %ScriptVersion%, %lng_SearchDeadTracks%`n`n%lng_CheckedTracks%:`t`t%checkedTracks%/%totalTracks%`n%lng_DeletedTracks%:`t`t%deletedTracks%/%deadTracks%
Return

ExitiTunes:
  SetTimer, CheckTime, Off
  SetTimer, FadeOut, Off
;  If ShowIcon
;      TrayTip, %ScriptName% %lng_4iTunes% %ScriptVersion%, %lng_iTunesQuit%,, 17
;  Else
;      SplashImage,, CW%SplashColor% b1 FS10 W250, %lng_iTunesQuit%
  Gui, Destroy
  Gui, 2: Destroy
  Gui, 3: Destroy
  Gui, 4: Destroy
  Gui, 5: Destroy
  If iTunesApp.PlayerState = 1 and AtLeastVersion("7.4") ; is playing
    iTunesApp.CurrentTrack.Reveal ; remember last playlist; iTunes >=7.4
  iTunesApp.Quit

ExitSub:
;  IfWinExist, ahk_class iTunesCustomModalDialog
;    WinClose
;  IfWinExist, iTunes-Hilfe ahk_class HH Parent
;    WinClose
;  IfWinExist, Equalizer ahk_class iTunes
;    WinClose
  iTunesConn =
  iTunesApp =
/*
the object is disconnected automatically when the object wrapper is freed.
You can either call ComObjConnect(obj) or free the COM wrapper object
(by removing all references to it, such as by clearing variables).
*/
  If (FileDeleteOnExit and A_IsCompiled)
    {
      FileDelete, iHotkey1.jpg
      FileDelete, iHotkey2.jpg
      FileDelete, iHotkey1.png
      FileDelete, iHotkey2.png
      FileDelete, iHotkey3.png
      FileDelete, iHotkey4.png
      FileDelete, iHotkey5.png
      FileDelete, iHotkey6.png
      FileDelete, iHotkey7.png
      FileDelete, iHotkey8.png
      FileDelete, iHotkey9.png
      FileDelete, iHotkey1.ico
      FileDelete, iHotkey2.ico
      FileDelete, iHotkey3.ico
      FileDelete, iHotkey4.ico
    }
  ExitApp  ; The only way for an OnExit script to terminate itself is to use ExitApp in the OnExit subroutine.
Return

Volume_Up::
VolumeUp:
  If iTunesApp.Mute
    {
      Gui, 5: Destroy
      Gosub, ToggleMute
      Return
    }
  PlayerVol := iTunesApp.SoundVolume + 4
  GoSub, Volume_Show
Return

Volume_Down::
VolumeDown:
  If iTunesApp.Mute
    {
      Gui, 5: Destroy
      Gosub, ToggleMute
      Return
    }
  PlayerVol := iTunesApp.SoundVolume - 4
  GoSub, Volume_Show
Return

Volume_Show:
;  Thread, Priority, 2147483647
  AlphaVol = 255
  SetTimer, FadeOutVol, Off
  PlayerVol := PlayerVol < 0 ? 0 : PlayerVol
  PlayerVol := PlayerVol > 100 ? 100 : PlayerVol
  IfNotExist, iHotkey7.png
    Gosub, defPng07
  IfNotExist, iHotkey8.png
    Gosub, defPng08
  IfWinNotExist, ahk_id %Volume_GuiID%
    {
    ; +0x400000 Creates a window that has a border of a style typically used with dialog boxes.
    Gui, 5: +Lastfound +ToolWindow -Caption +AlwaysOnTop +0x400000
    Volume_GuiID := WinExist()
    Gui, 5: Color, %GUIColor%
    Gui, 5: font, norm s9, MS Sans Serif
;    Gui, 5: Add, Text, x70 w145 y3 Center, %ScriptName% %lng_4iTunes% %ScriptVersion%
    If A_IsMute ; iTunesApp.Mute
      {
      Gui, 5: Add, pic, x5 y1 vVolume_Pic, iHotkey8.png
      Gui, 5: Add, pic, x5 y1 Hidden, iHotkey8.png
      Gui, 5: Add, Progress, vPlayerVol x43 yp+5 w200 h20 cred Background%BackColor%, %PlayerVol%
      }
    Else
      {
      Gui, 5: Add, pic, x5 y1 vVolume_Pic, iHotkey7.png
      Gui, 5: Add, pic, x5 y1 Hidden, iHotkey7.png
;      Gui, 5: Add, Progress, vPlayerVol x43 yp+5 w200 h20 c%DarkColor% Background%BackColor%, %PlayerVol%
      Gui, 5: Add, Progress, vPlayerVol x43 yp+5 w200 h20 c%DarkColor% Background%BackColor%, %PlayerVol%
      }
     Gui, 5: Add, Text, x+ w30 yp+3 Right vVC_Text, %PlayerVol% `%
    Gui, 5: Show, NA h32 w280
    }
  Else
    {
    If (PlayerVol <> iTunesApp.SoundVolume)
      {
      GuiControl, 5:, PlayerVol, %PlayerVol%
      GuiControl, 5:, VC_Text, %PlayerVol% `%  ; this line causes flickering
      }
    }
  If not A_IsMute
    iTunesApp.SoundVolume := PlayerVol
  SetTimer, FadeOutVol, 128
Return

FadeOutVol:
  If GetKeyState("LWin", "P") or GetKeyState("RWin", "P") or GetKeyState("Ctrl", "P") or GetKeyState("Alt", "P") or GetKeyState("Shift", "P")
    WinSet, Transparent, Off, ahk_id %Volume_GuiID%
  Else If (AlphaVol = 0)
    {
    SetTimer, FadeOutVol, Off
    Gui, 5: Destroy
    }
  Else
    {
    EnvSub, AlphaVol, 5
    WinSet, Transparent, %AlphaVol%, ahk_id %Volume_GuiID%
    SetTimer, FadeOutVol, % (AlphaVol < 100 ? 8 : (AlphaVol < 150 ? 16 : 32)), 2147483647
    }
Return

Volume_Mute::
ToggleMute:
  If ! iTunesApp.Mute
    {
      PlayerVol := iTunesApp.SoundVolume
      iTunesApp.Mute := True
      A_IsMute := True
      IfNotExist, iHotkey3.ico
        Gosub, defIco03
      IfNotExist, iHotkey7.png
        Gosub, defPng07
      IfNotExist, iHotkey8.png
        Gosub, defPng08
      Menu, Tray, Icon, iHotkey3.ico, 1, 1
      IfWinExist, ahk_id %Volume_GuiID%
        {
          GuiControl, 5:, Volume_Pic, iHotkey8.png
          GuiControl, 5: +cred, PlayerVol
        }
    }
  Else
    {
      iTunesApp.Mute := False
      A_IsMute := False
      IfNotExist, iHotkey1.ico
        Gosub, defIco01
      Menu, Tray, Icon, iHotkey1.ico, 1, 1
      IfWinExist, ahk_id %Volume_GuiID%
        {
          GuiControl, 5:, Volume_Pic, iHotkey7.png
          GuiControl, 5: +c%DarkColor%, PlayerVol
        }
    }
;  Gosub, Volume_Show
Return

MiniPlayer:
  If (A_PriorHotKey = A_ThisHotKey and A_TimeSincePriorHotkey < 100)
    Return ; if the key is not released
  If iTunesApp.BrowserWindow.MiniPlayer
    {
    If iTunesApp.BrowserWindow.Visible
      {
;      If iTunesApp.PlayerState = 1 and AtLeastVersion("7.4") ; is playing
;        iTunesApp.CurrentTrack.Reveal ; available in iTunes 7.4 and later
      iTunesApp.BrowserWindow.MiniPlayer := False
      }
    Else
      iTunesApp.BrowserWindow.Minimized := False
    }
  Else
    {
    If ! iTunesApp.BrowserWindow.Visible
    	iTunesApp.BrowserWindow.Minimized := False
    iTunesApp.BrowserWindow.MiniPlayer := True
    }
Return

iTFolder:
  getPath	:= iTunesApp.LibraryXMLPath ; available in iTunes 7.0 and later
  SplitPath, getPath,, getPath
  Run %getPath%,, Max UseErrorLevel
  If ErrorLevel = Error
      MsgBox, 262192, %ScriptName% %lng_4iTunes% %ScriptVersion%, %lng_iTFolderError%
Return

ExploreTrack:
  If (A_PriorHotKey = A_ThisHotKey and A_TimeSincePriorHotkey < 100)
    Return ; if the key is not released
  getLocation := iTunesApp.CurrentTrack.Location
  Run, % "explorer.exe /e`, /n`, /select`," getLocation
  If ErrorLevel = Error
      MsgBox, 262192, %ScriptName% %lng_4iTunes% %ScriptVersion%, %lng_iTFolderError%
Return

;======================= iTunes Ratings ===========================
Rating0:
  SetRating(0,"-")
Return

Rating1:
  SetRating(20,"* (1)")
Return

Rating2:
  SetRating(40,"* * (2)")
Return

Rating3:
  SetRating(60,"* * * (3)")
Return

Rating4:
  SetRating(80,"* * * * (4)")
Return

Rating5:
  SetRating(100,"* * * * * (5)")
Return

SetRating(intRating,newRating)
  {
  Global
  getCurrentTrack	:= iTunesApp.CurrentTrack
  If getCurrentTrack
    {
    SetTimer, FadeOut, Off
    getRating =
    getName =
    getArtist =
    getArtist := iTunesApp.CurrentTrack.Artist
    getName := iTunesApp.CurrentTrack.Name
    getRating := iTunesApp.CurrentTrack.Rating
    If getRating = 0
      strRating = %lng_NotRated%
    Else If getRating = 20
      strRating = * (1)
    Else If getRating = 40
      strRating = * * (2)
    Else If getRating = 60
      strRating = * * * (3)
    Else If getRating = 80
      strRating = * * * * (4)
    Else If getRating = 100
      strRating = * * * * * (5)
    Else If getArtist !=
      getArtist = %getArtist%:
    Else If getRating =
      Return
    If getRating <> %intRating%
      {
      MsgBox, 8225, %ScriptName% %lng_4iTunes% %ScriptVersion%, %getArtist%: %getName%`n`n%lng_OldRating%: %strRating%`n`n%lng_NewRating%: %newRating%`n
      IfMsgBox, OK
        {
        getTrackID := iTunesApp.CurrentTrack.TrackID
        iTunesApp.CurrentTrack.Rating := intRating ; => iTunes_OnPlayerPlayingTrackChangedEvent
        SetTimer, GuiRating, -1
        If FeedBack
          {
          SplashWidth := GetTextSize(getArtist ": " getName, "10", "MS Sans Serif") + 30 ; wähle FontSize +1
          SplashWidth := SplashWidth < 150 ? 150 : SplashWidth
          SplashImage,, W130 CW%SplashColor% B1 FM10 FS24 WM400 WS700 W%SplashWidth%, % RegExReplace(newRating, "\s\(.*$"), % "`n" getArtist ": " getName, MS Sans Serif
          SetTimer, SplashOffModKey, -1000
          }
        If JumpNext
          {
          If FeedBack
            Sleep, 1000
          If iTunesApp.CurrentTrack.TrackID = getTrackID
            iTunesApp.NextTrack ; => iTunes_OnPlayerPlayEvent
          iTunesApp.Play ; erforderlich wenn z.B. Liste «unbewertet» abgespielt wird
          }
        }
      }
    Else ; If getRating = %intRating%
      {
      SplashImage,2:, W130 CW%SplashColor% B1 FM10 FS24 WM400 WS700, % RegExReplace(newRating, "\s\(.*$"), % "`n" lng_Rating ": " Ceil(intRating/20)
      SetTimer, SplashOff_2, -1000
      }
    If WindowShow
      SetTimer, FadeOut, -1
    }
  Else ; If not getCurrentTrack
    {
    SplashImage,, CW%SplashColor% b1 FS10 W300, %lng_NothingToShow%, %ScriptName% %lng_4iTunes% %ScriptVersion%
    Settimer, SplashOffModKey, -2000
    }
  }
;------------------------------------------------------------------

ProgressOffWinKey:
  Loop
    {
      Sleep, 10
      If not GetKeyState("LWin", "P") and not GetKeyState("RWin", "P") and not GetKeyState("Ctrl", "P") and not GetKeyState("Alt", "P") and not GetKeyState("Shift", "P")
          Break
    }
  Progress, Off
Return

SplashOffModKey:
  Loop
    {
      Sleep, 10
      If not GetKeyState("LWin", "P") and not GetKeyState("RWin", "P") and not GetKeyState("Ctrl", "P") and not GetKeyState("Alt", "P") and not GetKeyState("Shift", "P")
          Break
    }
  SplashImage, Off
Return

SplashOff_2:
  Splashimage, 2: Off
Return


iTHotkeyHelp:
  Gui, 4: +LastFoundExist ; is recognized only when no other options appear on the same line
  IfWinExist
    {
      GoSub, 4GuiClose
      Return
    }
  If iLanguage = english
    {
      iTHotkeyHelp =
        (
%ModifiersName%...
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯%A_Space%%A_Space%%A_Space%%A_Space%%A_Space%%A_Space%%A_Space%
Space: %A_Tab% %A_Tab%Play/Stop
Pause: %A_Tab% %A_Tab% Set Sound Output Mute State

Right/Left: %A_Tab% Next/Previous Track
Up/Down: %A_Tab% Move Forward/Backward
Home: %A_Tab% %A_Tab% Repeat from the Beginning
Del:%A_Tab% %A_Tab% Delete from Playlist

±: %A_Tab% %A_Tab% Change iTunes Volume

0-5: %A_Tab% %A_Tab% Change Rating

E: %A_Tab% %A_Tab% Open/Close CD Drive
G: %A_Tab% %A_Tab% Show Album Artwork
H: %A_Tab% %A_Tab% This Window (Hotkeys...)
I: %A_Tab% %A_Tab% Show Track Info
L: %A_Tab% %A_Tab% Show/Get Lyrics
M: %A_Tab% %A_Tab% Mini Player Mode On/Off
P: %A_Tab% %A_Tab% Switch Current Playlist
R: %A_Tab% %A_Tab% Show File in Explorer
V: %A_Tab% %A_Tab% Show Visualizer

#: %A_Tab% Show/Hide iTunes
End: %A_Tab% %A_Tab% Quit iTunes/%ScriptNoExt%


Tips and Tricks
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
The track info is also displayed when you press
the modifier keys and the left mouse button. Use
the right mouse button to show the playlists.

There are three ways to prevent the information
window from disappearing:
- hold down a modifier-key
- or press Ctrl key while the window is showed
- or click anywhere on the window.
        )
    }
  Else
    {
      iTHotkeyHelp =
        (
%ModifiersName%...
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯%A_Space%%A_Space%%A_Space%%A_Space%%A_Space%%A_Space%%A_Space%
Leertaste:%A_Tab% Wiedergabe/Pause
Pause: %A_Tab% %A_Tab% stumme Wiedergabe

Pfeil re./li.:%A_Tab% nächster/voriger Titel
Pfeil auf/ab:%A_Tab% vor-/rückspulen
Pos1:%A_Tab% %A_Tab% ab Anfang wiederholen
Entf:%A_Tab% %A_Tab% aus Wiedergabeliste löschen

±: %A_Tab% %A_Tab% iTunes lauter/leiser

0-5: %A_Tab% %A_Tab% Wertung ändern

E: %A_Tab% %A_Tab% CD-Laufwerk öffnen/schließen
G: %A_Tab% %A_Tab% CD-Cover (Grafik) anzeigen
H: %A_Tab% %A_Tab% dieses Fenster (Hotkeys...)
I: %A_Tab% %A_Tab% Titel-Information anzeigen
L: %A_Tab% %A_Tab% Liedtext anzeigen/downloaden
M: %A_Tab% %A_Tab% Miniplayer an-/ausschalten
P: %A_Tab% %A_Tab% aktuelle Playliste wechseln
R: %A_Tab% %A_Tab% Datei im Explorer anzeigen
V: %A_Tab% %A_Tab% visuelle Effekte aktivieren

#: %A_Tab% %A_Tab% iTunes zeigen/verstecken
Ende: %A_Tab% %A_Tab% iTunes/%ScriptNoExt% beenden


Tipps und Tricks
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
Die Musiktitel-Informationen werden angezeigt,
wenn Sie %ModifiersName%li. Maustaste drücken.
%ModifiersName%re. Maustaste: Wiedergabelisten

Sie können das automatische Ausblenden des
Informationfensters auf drei Arten verhindern:
- halten Sie einen Modifier-Key gedrückt
- oder drücken Sie sie die Strg-Taste
- oder klicken Sie mit der Maus in das Fenster.
        )
    }
;Die Musiktitel-Informationen werden auch an-
;gezeigt, wenn Sie die linke Maustaste bei ge-
;drückten Modifier-Tasten betätigen. Mit der
;rechten Taste rufen Sie die Playlisten auf.

  Gui, 4: -MinimizeBox -MaximizeBox
  Gui, 4: Color, %GUIColor%
  Gui, 4: font, norm s9, MS Sans Serif
  Gui, 4: Add, Text, x25, %iTHotkeyHelp%
  Gui, 4: Show,, %ScriptName% %lng_4iTunes% %ScriptVersion%
  OnMessage(0x201, "WM_LBUTTONDOWN")
  HelpShow := True
Return

HelpTextOK:
4GuiClose:
4GuiEscape:
  Gui, 4: Destroy
  If ! WindowShow
      OnMessage(0x201, "")
  HelpShow := False
Return

;====================== InfoGUI =========================
iTHotkeyInfo:
 If (A_PriorHotKey = A_ThisHotKey and A_TimeSincePriorHotkey < 100 and A_TimeSincePriorHotkey > 0)
   Return ; if the key is not released ; A_TimeSincePriorHotkey will be -1 if A_PriorHotkey is blank.
  Gui, 2: +LastFoundExist ; is recognized only when no other options appear on the same line
  IfWinExist
    {
      GoSub, 2GuiClose
      Return
    }
  GuiWidth = 245
  Gui, 2: Destroy
; Gui, 2: Default
  Gui, 2: +AlwaysOnTop -SysMenu
  Gui, 2: Color, %GUIColor%
  Gui, 2: Font, s14 bold, MS Sans Serif
  Gui, 2: Add, Text, x18 y20 w%GuiWidth% Center, %ScriptName% %lng_4iTunes% %ScriptVersion%
  Gui, 2: font, s9, MS Sans Serif
  Gui, 2: Add, Text, x20 y+20 w%GuiWidth%, %lng_InfoHeading%
  Gui, 2: Font, norm, MS Sans Serif
  Gui, 2: Add, Text, 0x1000 x20 y+20 w%GuiWidth% h2
  Gui, 2: Add, Text, x20 y+, © 2007-2011, Wilhelm Happe, Kiel
  Gui, 2: Add, Text, 0x1000 x20 y+ w%GuiWidth% h2
  Gui, 2: Add, Text, x20 y+5, %lng_Disclaimer%
  Gui, 2: Add, Text, 0x1000 x20 y+5 w%GuiWidth% h2
  Gui, 2: Add, Text, x20 y+, %lng_WebSite%: %A_Space%
  Gui, 2: Add, Text, cBlue gHomepage x+ yp, %HomePage%
  Gui, 2: Add, Text, 0x1000 x20 y+ w%GuiWidth% h2
  Gui, 2: Add, Text, x20 y+9 w%GuiWidth% Right, iTunes %getVersion% %A_Space%
  Gui, 2: Add, Text, x20 yp, Build %ScriptVersion%.%ScriptBuild% (%ScriptDate%)
  Gui, 2: Add, Button, x90 y+15 w95 gInfoTextOK Default, &%lng_CloseButton%
  Gui, 2: Show,, %lng_About%
  OnMessage(0x200, "WM_MouseMove2")
Return
;------------------------------------------------------------------

Homepage:
  Run http://%HomePage%/
  If ErrorLevel = Error
      MsgBox, 262192, %ScriptName% %lng_4iTunes% %ScriptVersion%, %ErrorLevel%
Return

;------------------------------------------------------------------

InfoTextOK:
2GuiClose:
2GuiEscape:
  Gui, 2: Destroy
  OnMessage(0x200, "")
Return

WM_MouseMove2(wParam, lParam)
  {
    global hCurs
    IfNotEqual, A_Gui, 2, Return
    MouseGetPos,,,, ctrl
    If ctrl in static9 ; Avoid spaces in list
        DllCall("SetCursor", "UInt", hCurs)
    Return
  }

;====================== Lyrics =========================
ShowLyrics:
  lrcTrcName := iTunesApp.CurrentTrack.Name
  lrcTrcArtist := iTunesApp.CurrentTrack.Artist
  If AtLeastVersion("5.0") ; available in iTunes 5.0
    lrcTrcLyrics := iTunesApp.CurrentTrack.Lyrics
  If not lrcTrcLyrics
    {
    lrcTrcID := iTunesApp.CurrentTrack.TrackID
    If ! (lrcTrcID || lrcTrcArtist || lrcTrcArtist)
      Return
    SplashImage,, CW%SplashColor% b1 FS10 W200, Searching on LYRDB.com...
    Sleep, 0
    sURL := "http://webservices.lyrdb.com/lookup.php?q=" . lrcTrcArtist . "|" . lrcTrcName . "&for=match&agent=AHK"
;   sURL := "http://webservices.lyrdb.com/lookup.php?q=The Beatles|You've got to hide your love away&for=match"
    trckLyrics := UrlDownloadToVar(sURL)
    If InStr(trckLyrics, "\")
      {
      Loop, parse, trckLyrics, `n, `r  ; Specifying `n prior to `r allows both Windows and Unix files to be parsed.
        LineNumber = %A_Index%
;      If LineNumber > 1
;        MsgBox, 4160, %lrcTrcArtist%: %lrcTrcName%, %LineNumber% lyrics versions were found.`nThese are now displayed in succession.
      Loop, parse, trckLyrics, `n, `r  ; Specifying `n prior to `r allows both Windows and Unix files to be parsed.
        {
        sURL := "http://webservices.lyrdb.com/getlyr.php?q=" . SubStr(A_LoopField, 1, InStr(A_LoopField, "\") -1)
        lrcText := UrlDownloadToVar(sURL)
        MsgBox, 4356, %lrcTrcArtist%: %lrcTrcName% (%A_Index%/%LineNumber%), %lrcText%`n___________________________________________`n¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯`n%lng_LyricsImport%`n%lng_LyricsCopy%
        IfMsgBox, Yes
          {
        If iTunesApp.CurrentTrack.TrackID = lrcTrcID
          {
          If AtLeastVersion("5.0")
            iTunesApp.CurrentTrack.Lyrics := lrcText
          }
          Else ; current track has changed
            MsgBox, 4112, %ScriptName% %lng_4iTunes% %ScriptVersion%, Current track has changed.
          }
        }
				trckLyrics =
				lrcText =
      }
    Else ; ! trckLyrics
      MsgBox, 4160, %lrcTrcArtist%: %lrcTrcName%, Lyrics not found.
    }
  Else ; Lyrics are already saved in the iTunes library
    MsgBox, 4096, %lrcTrcArtist%: %lrcTrcName%, %lrcTrcLyrics%
Return

UrlDownloadToVar(sURL) {
  resVar =
  sURL := RegExReplace(sURL, "'", "") ;"  StringReplace, sURL, sURL, "'",, All
; StringReplace, sURL, sURL, %A_SPACE%, `%20, All
  UrlDownloadToFile, %sURL%, %A_Temp%\resVar.tmp
  If ErrorLevel ; is set to 1 if there was a problem or 0 otherwise
    {
    SplashImage, Off
    MsgBox,, Lyrics, Error on download.
    Return
    }
  SplashImage, Off
  FileRead, resVar, *t %A_Temp%\resVar.tmp
  If not ErrorLevel ; Successfully loaded
    FileDelete, %A_Temp%\resVar.tmp
  resVar := RegExReplace(resVar, "^\s*|\s*$") ; remove whitespace at beginning and end
  return, resVar
  }


/*
ShowLyrics:
  If AtLeastVersion("5.0") ; available in iTunes 5.0
    lrcTrcLyrics := iTunesApp.CurrentTrack.Lyrics
  If not lrcTrcLyrics
    {
    lrcTrcID := iTunesApp.CurrentTrack.TrackID
    lrcTrcName := iTunesApp.CurrentTrack.Name
    lrcTrcArtist := iTunesApp.CurrentTrack.Artist
    If ! (lrcTrcID || lrcTrcArtist || lrcTrcArtist)
      Return
    SplashImage,, CW%SplashColor% b1 FS10 W200, Searching on chartlyrics.com...
    Sleep, 0
    ;   sURL := "http://lyricwiki.org/" . lrcTrcArtist . ":" . lrcTrcName
    sURL := "http://api.chartlyrics.com/apiv1.asmx/SearchLyricDirect?artist=" . lrcTrcArtist . "&song=" . lrcTrcName
    sURL := RegExReplace(sURL,"[\(\)\[]'!\.:;,|~!].")
    StringReplace, sURL, sURL, %A_SPACE%, `%20, All
    UrlDownloadToFile, %sURL%, %A_Temp%\lyrics.xml
    If ErrorLevel ; is set to 1 if there was a problem or 0 otherwise
      {
      SplashImage, Off
      Return
      }
    SplashImage, Off
    FileRead, trckLyrics, %A_Temp%\lyrics.xml
    If not ErrorLevel ; Successfully loaded
      {
      If A_IsUnicode ; fileencoding in autexecute section
        trckLyrics := UnHTM(trckLyrics)
      Else
        trckLyrics := UnHTM(UTFDecode(trckLyrics))
      ServerError := XMLGet(trckLyrics, "title")
      If InStr(ServerError, "404")
        {
        MsgBox,, %lrcTrcArtist%: %lrcTrcName%, api.chartlyrics.com: Error %ServerError%`nThe resource you are looking for might have been removed, had its name changed, or is temporarily unavailable.
        Return
        }
      LyricArtist := XMLGet(trckLyrics, "LyricArtist")
      LyricSong   := XMLGet(trckLyrics, "LyricSong")
      lrcText   := XMLGet(trckLyrics, "Lyric")
;     lrcText   := lrcText > 0 ? lrcText : "Lyrics not found"
      If ! lrcText
        MsgBox,, %lrcTrcArtist%: %lrcTrcName%, Lyrics not found
      Else
        MsgBox, 257, %lrcTrcArtist%: %lrcTrcName%, %LyricArtist%: %LyricSong%`n¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯`n%lrcText%`n___________________________________________`n¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯`n%lng_LyricsImport%`n%lng_LyricsCopy%
      IfMsgBox, OK
        {
        If iTunesApp.CurrentTrack.TrackID = lrcTrcID
          {
          If AtLeastVersion("5.0")
            iTunesApp.CurrentTrack.Lyrics := lrcText
          }
        Else ; current track has changed
          MsgBox, 16, %ScriptName% %lng_4iTunes% %ScriptVersion%, Current track has changed.
        }
      FileDelete, %A_Temp%\lyrics.xml
      }
    }
  Else ; Lyrics are already saved in the iTunes library
    MsgBox,, %lrcTrcArtist%: %lrcTrcName%, %lrcTrcLyrics%
Return
*/

;====================== HelpFile =========================
iTHotkeyChm:
  IfWinExist, %ScriptNoExt% Hilfe ahk_class HH Parent
    {
      IfWinActive
          WinClose
      Else
          WinActivate
    }
  Else
    {
      Run, %A_ScriptDir%\%ScriptNoExt%.chm,, UseErrorLevel
      If ErrorLevel = Error
          MsgBox, 8240, %ScriptName% %lng_4iTunes% %ScriptVersion%, %lng_HelpFileNotFound%
    }
Return

;------------------------------------------------------------------

EjectDrive:
  If (A_PriorHotKey = A_ThisHotKey and A_TimeSincePriorHotkey < 100)
    Return ; if the key is not released
  DriveGet, ej_Drive, List, CDROM
  If ej_Drive =
      Return
  SplashImage,, CW%SplashColor% b1 FS10 W170, %lng_Drive% %ej_Drive% %lng_Eject%.
  Sleep, 10
  Drive, Eject, %ej_Drive%                        ; Medium auswerden
  If ErrorLevel = 0 ;just in case
      SplashImage, off
  If A_TimeSinceThisHotkey < 1000
    {
      SplashImage,, CW%SplashColor% b1 FS10 W200, %lng_Drive% %ej_Drive% %lng_Retract%.
      Sleep, 10
      Drive, Eject, %ej_Drive%, 1
    }
  SplashImage, off
Return

GuiRating:
  getRating	:= iTunesApp.CurrentTrack.Rating
  iTRating := getRating//20
  iTRating := (!iTRating ? 0 : iTRating)
  If iTRating = 0
      iTRating = %lng_NotRated%
  If iTRating = 1
      iTRating = * (1)
  If iTRating = 2
      iTRating = * * (2)
  If iTRating = 3
      iTRating = * * * (3)
  If iTRating = 4
      iTRating = * * * * (4)
  If iTRating = 5
      iTRating = * * * * * (5)
  Gui, Default
  GuiControl,, _iTg_TrackRating, %iTRating%
  iTRating =
Return

ShowTrack:
  If (A_PriorHotKey = A_ThisHotKey and A_TimeSincePriorHotkey < 100)
    Return ; if the key is not released
  If WinExist("ahk_id " pl_GuiID) And InStr(A_ThisHotkey,"LButton")
      GoSub, 8GuiClose
  If WindowShow
    {
    SetTimer, FadeOut, Off
    Gui, Show, Hide y%A_ScreenHeight%
;    WinHide, ahk_id %GuiID%
;    WinMove, ahk_id %GuiID%,,, %A_ScreenHeight%
    WindowShow := False
    }
  Else
    GoSub, CheckTrack
Return

;######################  Check  ########################
CheckTrack: ; is called by «iTunes_OnPlayerPlayEvent»
  If ShowInfo = 0 ; user has selected «No Info» in Options
      Return
  GoSub, CheckTime
  GoSub, GuiRating
  getTrackName	:= iTunesApp.CurrentTrack.Name
  getTrackArtist	:= iTunesApp.CurrentTrack.Artist
  getTrackAlbum	:= iTunesApp.CurrentTrack.Album
  getPlaylist	:= iTunesApp.CurrentPlaylist.Name
  getKind	:= iTunesApp.CurrentTrack.KindAsString
  getSize	:= iTunesApp.CurrentTrack.Size
  getBitRate	:= iTunesApp.CurrentTrack.BitRate
  getSampleRate	:= iTunesApp.CurrentTrack.SampleRate
  getTrackTime	:= iTunesApp.CurrentTrack.Time ; in MM:SS format
  If AtLeastVersion("4.7") and iTunesApp.CurrentTrack.Artwork(1) ; track has its own artwork
    {
      iTunesApp.CurrentTrack.Artwork(1).SaveArtworkToFile(ArtworkFile)
      TrackArt := ArtworkFile
    }
  Else ; track has no own artwork
    {
      IfNotExist, %ArtworkDefault%
        {
        Gosub, defArtworkDefault
        ArtworkDefault = %A_Temp%\iHotkey1.jpg
        }
      TrackArt := ArtworkDefault
    }
  Loop, 9
    {
    If GetTextSize(getTrackName, "9", "MS Sans Serif") < 235
      Break
    Else
      getTrackName := RegExReplace(getTrackName, "\s[^\s]+$", "...")
    }
  Loop, 9
    {
    If GetTextSize(getTrackArtist, "9", "MS Sans Serif") < 235
      Break
    Else
      getTrackArtist := RegExReplace(getTrackArtist, "\s[^\s]+$", "...")
    }
  Loop, 9
    {
    If GetTextSize(getTrackAlbum, "9", "MS Sans Serif") < 235
      Break
    Else
      getTrackAlbum := RegExReplace(getTrackAlbum, "\s[^\s]+$", "...")
    }
  getSize := getSize/1048576
  SetFormat, float, 0.1
  getSize := getSize/1
  getSampleRate := getSampleRate/1000
  StringReplace, getSampleRate, getSampleRate, `. , `,
  StringReplace, getSize, getSize, `. , `,
  If getKind <>
    {
      StringReplace, getKind, getKind, Geschützte%A_Space% , ®-
      StringReplace, getKind, getKind, Protected , ®
      StringReplace, getKind, getKind, Gekaufte%A_Space% , $-
      StringReplace, getKind, getKind, Purchased , $
      TrackKind = %getKind%`, %getSize% MB`, %getBitRate% kBit/s`, %getSampleRate% kHz
    }
  Gui, Default
  GuiControl,, _iTg_TrackArt, *w120 *h120 %TrackArt%
  GuiControl,, _iTg_TrackName, %getTrackName%
  GuiControl,, _iTg_TrackArtist, %getTrackArtist%
  GuiControl,, _iTg_TrackAlbum, %getTrackAlbum%
  GuiControl,, _iTg_Playlist, %getPlaylist%
  GuiControl,, _iTg_TrackKind, %TrackKind%
  GuiControl,, _iTg_TrackLength, / %getTrackTime%
  TrackKind =
  If iTunesApp.Mute
      Return ; no FadeIn when MUTE
  IfNotEqual, NoPlayStart, 1, GoSub, FadeIn
Return

CheckTime: ; is executed every 1000 ms (SetTimer)
  If ! iTunesApp
    {
      MsgBox, 262160, %ScriptName% %lng_4iTunes% %ScriptVersion%, %lng_NoiTunes%
      GoSub, ExitSub
    }
  Duration := iTunesApp.CurrentTrack.Duration
  Position := iTunesApp.PlayerPosition
  TimePlayed := SecToMMSS(Position)
  TimeLeft := "-" . SecToMMSS(Duration-Position)
  RegexMatch((Position/Duration)*100, "[^\.]*",Progress)
  Gui, Default
  GuiControl,, _iTg_TrackProgress, %Progress%
  GuiControl,, _iTg_TrackLengthPlayed, %TimePlayed%
  GuiControl,, _iTg_TrackLengthLeft, %TimeLeft%
Return

FadeIn:
  If WindowShow
    Return
  If (getTrackName = "") AND (getTrackArtist = "") AND (getTrackAlbum = "")
    {
    If (getTrackName != "") OR (getTrackArtist != "") OR (getTrackAlbum != "")
      SetTimer, FadeOut, -%FadeTimeout% ; start the timer new
    Else
      {
      SplashImage,, CW%SplashColor% b1 FS10 W300, %lng_NothingToShow%, %ScriptName% %lng_4iTunes% %ScriptVersion%
      Settimer, SplashOffModKey, -4000
      iTunesApp.BrowserWindow.MiniPlayer := False
      iTunesApp.BrowserWindow.Minimized := False
      iTunesApp.BrowserWindow.Visible := True
      }
    Return ; do nothing else
    }
  WindowShow := True
  SysGet, MonitorWorkArea, MonitorWorkArea
  GuiTop := MonitorWorkAreaBottom - 150
  GuiLeft := MonitorWorkAreaRight - 400
  Gui, Show, NoActivate x%GuiLeft% y%GuiTop%
  Gui, +AlwaysOnTop
  Gui, -AlwaysOnTop
  OnMessage(0x201, "WM_LBUTTONDOWN")
  SetTimer, FadeOut, -%FadeTimeout%
Return

FadeOut:
  If (ShowInfo = 0 or WindowShow = 0)
    Return
  Loop
    {
    If not GetKeyState("LWin", "P") and not GetKeyState("RWin", "P") and not GetKeyState("Ctrl", "P") and not GetKeyState("Alt", "P") and not GetKeyState("Shift", "P")
      Break  ; exit loop and allow FadeOut-Loop
    Sleep, 10
    }
  If ! HelpShow
    OnMessage(0x201, "")
  WinSet, Top,, ahk_class Shell_TrayWnd ; bring the task bar in front of the GUI
  WindowShow := False
  SetTimer, FadeOut, Off
  SetWinDelay, 3 ; the delay that will occur after each windowing command (WinMove)
  Loop, % Ceil((A_ScreenHeight - GuiTop) / 2)  ; 76
    {
    If WindowShow
      Return
    GuiTop += 2
    WinMove, ahk_id %GuiID%,,, %GuiTop%
    }
  Gui, Show, Hide y%A_ScreenHeight%
;  WinGet, ExStyle, ExStyle, ahk_class Shell_TrayWnd
;  If (ExStyle & 0x8)  ; 0x8 is WS_EX_TOPMOST.
;    WinSet, AlwaysOnTop, Off, ahk_class Shell_TrayWnd  ; WIN_VISTA
Return

/*
;WinActivate, ahk_id %hwnd%  ; -- best to use SetWinDelay,-1 if using WinActivate.
    DllCall("SetForegroundWindow", "uint", hwnd)
    DllCall("SetWindowPos", "uint", hwnd, "uint", hwnd_prev
        , "int", 0, "int", 0, "int", 0, "int", 0
        , "uint", 0x13)  ; NOSIZE|NOMOVE|NOACTIVATE (0x1|0x2|0x10)

    ; Note NOACTIVATE above: if this is not specified, SetWindowPos activates
    ; the window, bringing it forward (effectively ignoring hwnd_prev...)

    ; Check if AlwaysOnTop status changed.
    WinGet, ExStyle, ExStyle, ahk_id %hwnd%
    if (OldExStyle ^ ExStyle) & 0x8
        WinSet, AlwaysOnTop, Toggle
}
*/

;------------------------------------------------------------------------------

#IfWinActive, ahk_group GroupGuiID
Esc::SetTimer, FadeOut, -1
#IfWinActive

;EscInfoGui:
;  SetTimer, FadeOut, -1
;Return
;------------------------------------------------------------------------------

Options:
  Suspend, On
  IfNotExist, iHotkey2.ico
    Gosub, defIco02
  Menu, Tray, Icon, iHotkey2.ico, 1, 1
  Thread, NoTimers
  Hotkey, %Modifiers%p,                Off
  Hotkey, %Modifiers%RButton,          Off
  Hotkey, %Modifiers%#,                Off ; #!Enter is reserved for MediaCenter!
;  Hotkey, %Modifiers%NumpadEnter,      Off
;  Hotkey, %Modifiers%s,                Off
  Hotkey, %Modifiers%Right,            Off
; Hotkey, %Modifiers%Media_Next,       Off
  Hotkey, %Modifiers%Left,             Off
; Hotkey, %Modifiers%Media_Prev,       Off
  Hotkey, %Modifiers%NumpadAdd,        Off
  Hotkey, %Modifiers%+,                Off
  Hotkey, %Modifiers%NumpadSub,        Off
  Hotkey, %Modifiers%-,                Off
  Hotkey, %Modifiers%Space,            Off
; Hotkey, %Modifiers%Media_Play_Pause, Off
; Hotkey, %Modifiers%Media_Stop,       Off
  Hotkey, %Modifiers%g,                Off
  Hotkey, %Modifiers%v,                Off
  Hotkey, %Modifiers%Home,             Off
  Hotkey, %Modifiers%End,              Off
  Hotkey, %Modifiers%Up,               Off
; Hotkey, %Modifiers%Volume_Up,        Off
  Hotkey, %Modifiers%Down,             Off
; Hotkey, %Modifiers%Volume_Down,      Off
  BreakKey := InStr(Modifiers,"^") ? "CtrlBreak" : "Break"
  Hotkey, %Modifiers%%BreakKey%,       Off
; Hotkey, %Modifiers%Volume_Mute,      Off
  Hotkey, %Modifiers%i,                Off
  Hotkey, %Modifiers%LButton,          Off
  Hotkey, %Modifiers%m,                Off
  Hotkey, %Modifiers%r,                Off
  Hotkey, %Modifiers%l,                Off
  Hotkey, %Modifiers%0,                Off
  Hotkey, %Modifiers%Numpad0,          Off
  Hotkey, %Modifiers%1,                Off
  Hotkey, %Modifiers%Numpad1,          Off
  Hotkey, %Modifiers%2,                Off
  Hotkey, %Modifiers%Numpad2,          Off
  Hotkey, %Modifiers%3,                Off
  Hotkey, %Modifiers%Numpad3,          Off
  Hotkey, %Modifiers%4,                Off
  Hotkey, %Modifiers%Numpad4,          Off
  Hotkey, %Modifiers%5,                Off
  Hotkey, %Modifiers%Numpad5,          Off
  Hotkey, %Modifiers%h,                Off
  Hotkey, %Modifiers%a,                Off
  Hotkey, %Modifiers%F1,               Off
  Hotkey, %Modifiers%F2,               Off
  Hotkey, %Modifiers%F3,               Off
  Hotkey, %Modifiers%e,                Off
;  Hotkey, %Modifiers%Esc,              Off
;  Hotkey, %Modifiers%RButton,          Off
  Hotkey, %Modifiers%Del,              Off
  ;  Hotkey, %Modifiers%Backspace,        Off
  ShiftKey_TT :=    lng_ShiftKey_TT
  CtrlKey_TT :=     lng_CtrlKey_TT
  WinKey_TT :=      lng_WinKey_TT
  AltKey_TT :=      lng_AltKey_TT
  PlayOnStart_TT := lng_PlayOnStart_TT
  JumpNext_TT :=    lng_JumpNext_TT
  FeedBack_TT :=    lng_FeedBack_TT
  MaxMinStart_TT := lng_iTMini_TT
  Norm_TT :=        lng_iTNorm_TT
  Miniplayer_TT :=  lng_Minipl_TT
  ShowInfo_TT :=    lng_ShowInfo_TT
  Static2_TT :=     lng_ShowInfo_TT
  ShowIcon_TT :=    lng_ShowIcon_TT
  Standard_TT :=    lng_Standard_TT
  ShiftKey := (InStr(Modifiers, "+")) ? 1 : 0
  CtrlKey := (InStr(Modifiers, "^")) ? 1 : 0
  AltKey := (InStr(Modifiers, "!")) ? 1 : 0
  WinKey := (InStr(Modifiers, "#")) ? 1 : 0
  Gui, 6: Destroy
  Gui, 6: -MinimizeBox -MaximizeBox +AlwaysOnTop
  Gui, 6: Margin, 10, 10
  Gui, 6: font, s9 norm, MS Sans Serif

  Gui, 6: Add, GroupBox, w375 h95, %lng_Modifiers% ; (%ScriptName%)
  Gui, 6: Add, Text, x20 yp+20, %lng_OptionsText%
  Gui, 6: Add, Checkbox, vShiftKey Checked%ShiftKey% gStdKeysReset, %lng_Shift%-
  Gui, 6: Add, Checkbox, yp x110 vCtrlKey Checked%CtrlKey% gStdKeysReset, %lng_Ctrl%-
  Gui, 6: Add, Checkbox, yp x195 vWinKey Checked%WinKey% gStdKeysReset, Windows-
  Gui, 6: Add, Checkbox, yp x290 vAltKey Checked%AltKey% gStdKeysReset, Alt-%lng_key%

;  Gui, 6: Add, GroupBox, x180 yp+40 w205 h51
  Gui, 6: Add, GroupBox, x10 yp+40 w375 h51, %lng_ProgStart% ; (iTunes)
  Gui, 6: Add, Checkbox, x20 yp+25 vPlayOnStart Checked%PlayOnStart% gStdKeysReset, %lng_PlayOnStart%
  OnOff := MaxMinStart = 1 ? 1 : 0
  Gui, 6: Add, Radio, x150 yp vMaxMinStart Checked%OnOff% gStdKeysReset, %lng_iTMini%
  OnOff := MaxMinStart = 2 ? 1 : 0
  Gui, 6: Add, Radio, x232 yp Checked%OnOff% gStdKeysReset, Normal ; %lng_MaxMinStart%
  OnOff := MaxMinStart = 3 ? 1 : 0
  Gui, 6: Add, Radio, x305 yp Checked%OnOff% gStdKeysReset, Miniplayer

;  Gui, 6: Add, GroupBox, x180 yp+40 w205 h51
  Gui, 6: Add, GroupBox, x10 yp+40 w375 h51, %lng_Behaviour%
  Gui, 6: Add, Text, x20 yp+25, %lng_ShowInfo%
  ShowInfo++ ; see at 6GUIClose
  Gui, 6: Add, DropDownList, x120 yp-3 w50 vShowInfo AltSubmit Choose%ShowInfo% gStdKeysReset, %lng_off%|1 s|2 s|3 s|4 s|5 s
  Gui, 6: Add, Checkbox, x195 yp+3 vShowIcon gTrayIcon Checked%ShowIcon% gStdKeysReset, %lng_ShowIcon%
;  Gui, 6: Add, GroupBox, x180 yp+40 w205 h51
  Gui, 6: Add, GroupBox, x10 yp+40 w375 h51, %lng_AfterRating%
  Gui, 6: Add, Checkbox, x20 yp+25 vFeedBack Checked%FeedBack% gStdKeysReset, %lng_FeedBack%
  Gui, 6: Add, Checkbox, x195 yp vJumpNext Checked%JumpNext% gStdKeysReset, %lng_JumpNext%

  Gui, 6: Add, Button, x10 w92 gPreferences, &Standard
  Gui, 6: Add, Button, x195 yp w90 Default, &OK
  Gui, 6: Add, Button, xp+100 yp w90 g6ButtonEscape, %lng_Cancel%
  Gui, 6: Show,, %ScriptName% %lng_4iTunes% - %lng_Options%
  GoSub, StdKeysReset
  OnMessage(0x200, "WM_MOUSEMOVE_TT")
Return

; --------------------------------------------------------------------------------
; Create a ToolTip on Mouseover
; --------------------------------------------------------------------------------
WM_MOUSEMOVE_TT()
  {
    static CurrControl, PrevControl, _TT ; _TT is kept blank for use by the ToolTip command below.
    IfNotEqual, A_Gui, 6, Return ; following actions only in this GUI
    CurrControl := A_GuiControl ; make A_GuiControl a modifyable variable
    StringReplace,CurrControl,CurrControl,%A_Space%,,all ;remove the spaces so it can find the tooltip
    StringReplace, CurrControl, CurrControl, &,, all ;remove &
    StringReplace, CurrControl, CurrControl, .,, all ;remove .
    StringReplace, CurrControl, CurrControl, -,, all ;remove -
    ;   StringReplace, CurrControl, CurrControl, :,, all ;remove :
    ;   StringReplace, CurrControl, CurrControl, \,, all ;remove \
    ;   StringReplace, CurrControl, CurrControl, `n,, all ;remove any line returns
    If (CurrControl <> PrevControl and not InStr(CurrControl, " "))
      {
        ToolTip ; Turn off any previous tooltip.
        SetTimer, Display_TT, -500
        PrevControl := CurrControl
;        TrayTip,, % CurrControl
      }
    Return

Display_TT:
  ;		If (%CurrControl%_TT = "")
  ;			ToolTip , %CurrControl%
  ;		Else
  ToolTip, % %CurrControl%_TT
  SetTimer, Remove_TT, -5000
Return

Remove_TT:
  ToolTip
Return
}
; ------------------------------------------------------------------------------
TrayIcon:
  Gui, 6: +OwnDialogs ; MsgBox, InputBox, FileSelectFile, FileSelectFolder  should be owned
  Gui, 6: Submit, NoHide
  If (!ShowIcon)
      MsgBox, 308, %ScriptName% %lng_4iTunes% %ScriptVersion%, %lng_NoTrayIcon%
  IfMsgBox, No
      GuiControl, 6:, ShowIcon, 1
Return

6ButtonOK:
  Gui, 6: Submit, NoHide
  Modifiers := If WinKey   ? "#"           : ""
  Modifiers := If CtrlKey  ? "^" . Modifiers : Modifiers
  Modifiers := If AltKey   ? "!" . Modifiers : Modifiers
  Modifiers := If ShiftKey ? "+" . Modifiers : Modifiers
  ShowInfo--
  RegWrite, REG_SZ, HKEY_LOCAL_MACHINE, SOFTWARE\OPHTHALMOSTAR\%ScriptNoExt%, Modifiers, %Modifiers%
  RegWrite, REG_SZ, HKEY_LOCAL_MACHINE, SOFTWARE\OPHTHALMOSTAR\%ScriptNoExt%, MaxMinStart, %MaxMinStart%
  RegWrite, REG_SZ, HKEY_LOCAL_MACHINE, SOFTWARE\OPHTHALMOSTAR\%ScriptNoExt%, PlayOnStart, %PlayOnStart%
  RegWrite, REG_SZ, HKEY_LOCAL_MACHINE, SOFTWARE\OPHTHALMOSTAR\%ScriptNoExt%, JumpNext, %JumpNext%
  RegWrite, REG_SZ, HKEY_LOCAL_MACHINE, SOFTWARE\OPHTHALMOSTAR\%ScriptNoExt%, ShowInfo, %ShowInfo%
  RegWrite, REG_SZ, HKEY_LOCAL_MACHINE, SOFTWARE\OPHTHALMOSTAR\%ScriptNoExt%, ShowIcon, %ShowIcon%
  RegWrite, REG_SZ, HKEY_LOCAL_MACHINE, SOFTWARE\OPHTHALMOSTAR\%ScriptNoExt%, FeedBack, %FeedBack%

  If ShowInfo in 0,1,2,3,4,5
      ShowInfo := ShowInfo
  Else
      ShowInfo = 3
  FadeTimeout := ShowInfo * 1000
  ShowInfo++ ; see 6GUIClose
  GoSub, ModifiersNamed
  GoSub, ChangeModifiersName
  Gui, 4: +LastFoundExist ; is recognized only when no other options appear on the same line
  IfWinExist
      GoSub, 4GuiClose
  GoSub, 6GuiClose
Return
; ------------------------------------------------------------------------------

6ButtonEscape:
6GuiEscape:
6GuiClose:
  Gui, 6: Destroy
  OnMessage(0x200, "")
  ShowInfo--
  GoSub, HotkeysOn
  IfNotExist, iHotkey1.ico
    Gosub, defIco01
  Suspend, Off
  Menu, Tray, Icon, iHotkey1.ico, 1, 1
  Menu, Tray, % If ShowIcon = 1 ? "Icon" : "NoIcon"
  Thread, NoTimers, false
Return
; ------------------------------------------------------------------------------
StdKeysReset:
  GuiControlGet, ShiftKey, 6:
  GuiControlGet, CtrlKey, 6:
  GuiControlGet, WinKey, 6:
  GuiControlGet, AltKey, 6:
  GuiControlGet, ShowInfo, 6:
  GuiControlGet, ShowIcon, 6:
  GuiControlGet, PlayOnStart, 6:
  GuiControlGet, MaxMinStart, 6:
  GuiControlGet, FeedBack, 6:
  GuiControlGet, JumpNext, 6:
  If (ShiftKey <> 0 || CtrlKey <> 0 || WinKey <> 1 || AltKey <> 1 || ShowInfo <> 4 || ShowIcon <> 1 || PlayOnStart <> 1 || MaxMinStart <> 1 || FeedBack <> 1 || JumpNext <> 0)
  GuiControl, 6: Enable, &Standard
Else
  GuiControl, 6: Disable, &Standard
Return

Preferences:
  GuiControl, 6:, ShiftKey, 0
  GuiControl, 6:, CtrlKey, 0 ;% QuickKey ? 0 : 1
  GuiControl, 6:, WinKey, 1
  GuiControl, 6:, AltKey, 1 ;% QuickKey ? 1 : 0
  GuiControl, 6:, PlayOnStart, 1
  GuiControl, 6:, MaxMinStart, 1
  GuiControl, 6: Choose, ShowInfo, 4 ; item's position number
  GuiControl, 6:, ShowIcon, 1
  GuiControl, 6:, FeedBack, 1
  GuiControl, 6:, JumpNext, 0
  GuiControl, 6: Disable, &Standard
  GuiControl, 6: Focus, &OK
Return
; ------------------------------------------------------------------------------

AtLeastVersion(alVersion) {
  Global itVersion1, itVersion2, itVersion3
  StringSplit, alVersion, alVersion, .
  If alVersion3
    {
    If (itVersion1 > alVersion1 or (itVersion1 = alVersion1 and itVersion2 >= alVersion2) or (itVersion1 = alVersion1 and itVersion2 = alVersion2 and itVersion3 >= alVersion3))
      Return True
    Else
      Return False
    }
  Else If alVersion2
    {
    If (itVersion1 > alVersion1 or (itVersion1 = itVersion1 and itVersion2 >= alVersion2))
      Return True
    Else
      Return False
    }
  Else ; nur alVersion1
    {
    If (itVersion1 >= alVersion1)
      Return True
    Else
      Return False
    }
  }

; posted by Laszlo  - http://www.autohotkey.com/forum/viewtopic.php?p=114751#114751
GetTextSize(pStr, pSize, pFont, pHeight=false) {
    ; MsgBox % "pStr: " . pStr . "`npSize: " . pSize . "`npFont: " . pFont
    Gui, 10: Font, s%pSize%, %pFont%
    Gui, 10: Add, Text, R1, %pStr%
    GuiControlGet T, 10: Pos, Static1
    Gui, 10: Destroy
    Return pHeight ? TW "," TH : TW
  }

SecToMMSS(Sec, HZero = 0)
  { ;Sec: integer-seconds, HZero: 1/0 include a leading hour zero. e.g. 04:08 vs. 4:08
    Rem := Mod(Sec,60)
    Int := Sec//60
    If HZero
        Return (StrLen(Int) < 2 ? "0" . Int : Int) . ":" . (StrLen(Rem) < 2 ? "0" . Rem : Rem)
    Return Int . ":" . (StrLen(Rem) < 2 ? "0" . Rem : Rem)
  }

WM_LBUTTONDOWN(wParam, lParam)
  {
  Global
  IfEqual, A_Gui, 4
    GoSub, 4GuiClose
  Else IfEqual, A_Gui, 1
    {
    If WindowShow
      {
      SetTimer, FadeOut, Off ; MouseClick inside GUI stops FadeOut
      WinWaitNotActive, ahk_group GroupGuiID
      SetTimer, FadeOut, -1
      }
    }
  }

AHK_NOTIFYICON(wParam, lParam)
  {
  If (lParam = 0x204) ; RBUTTONDOWN  = 0x204; WM_RBUTTONUP = 0x205; WM_MOUSEMOVE = 0x200
    {
    Gui, Show, Hide y%A_ScreenHeight% ; fadeout stops when right-click
    }
  }

; event is fired when a track begins playing
iTunes_OnPlayerPlayEvent(track)
  {
  SetTimer, CheckTrack, -1
  }

; event is fired when iTunes is about prompt the user to quit
; available in iTunes 4.7 and later
iTunes_OnAboutToPromptUserToQuitEvent()
  {
  SetTimer, ExitiTunes, -1
  }

;------------------------------------------------------------------------------
WriteFile(file,data)
  {
    Handle := DllCall("CreateFile","str",file,"Uint",0x40000000,"Uint",0,"UInt",0,"UInt",4,"Uint",0,"UInt",0)
    Loop
      {
        If strlen(data) = 0
            Break
        StringLeft, Hex, data, 2
        StringTrimLeft, data, data, 2
        Hex = 0x%Hex%
        DllCall("WriteFile","UInt",Handle,"UChar *", Hex,"UInt",1,"UInt *",UnusedVariable,"UInt",0)
      }
    DllCall("CloseHandle", "Uint", Handle)
    Return
  }

;------------------------------------------------------------------
defArtworkDefault:
  ArtworkDefault =
    (Join
FFD8FFE000104A46494600010200006400640000FFEC00114475636B79000100040000001E0000F
FEE000E41646F62650064C000000001FFDB008400100B0B0B0C0B100C0C10170F0D0F171B141010
141B1F17171717171F1E171A1A1A1A171E1E23252725231E2F2F33332F2F4040404040404040404
0404040404001110F0F1113111512121514111411141A141616141A261A1A1C1A1A2630231E1E1E
1E23302B2E2727272E2B35353030353540403F404040404040404040404040FFC00011080078007
803012200021101031101FFC4007A00000203010100000000000000000000000002010304050601
0100000000000000000000000000000000100002020101040605090705010000000001020003110
4213112054151617113068191B12232A1C1425272B2233314D1E1A2C2435363628292D273151101
00000000000000000000000000000000FFDA000C03010002110311003F00F580460200490200046
C400920403127127123890748806218871AF6FA8FEC88DA9D327C76AA9EA270603E21894B6BF48A
33C658758538F5E31325BCFB415ECE219ED65F62F1181D0C48C4E2D9E67D38F8071772B1FBDC132
5BE67B8FE5D6DE92ABEC56F6C0F484482271391735D56BB5B75576022561C28C9DBC58DEC677088
08442491081223012046100112CB92B5E2621577711E9FB23798C4AE32DF0F40EBFDD32EA6BF14F
1EF3B876080ADAE2E7089B3EB59BFFE2BB3E5922DB49DB61C752E147F0E26420A9C196D6D98197C
C7A8BE9D1D06972A5AE01B2721870B1C1077CE08BF5AFF00D56507A1309F7009DBE7C3C4D3E957A
EF1F71E73DABAA903C4382770DE7D50319A0B9CB92E7AD893ED8C2903A25E6C5FA084F69D910973
BC85EEFDF02A6400677095337428CF6CB98D00FBEF93DA64B2B142E94B940325B84F0803A73881B
3CA408E65A9CFF647DF13D6113CB79501FF00E9EA41183E08D9FEF13D518086124C2002485E23C3
D1BDBBBF7C810F13831FEAC93DC3608096D6E4E655923619A85A8DBF641AB471B2061BAA0E3237C
C9C451B06746CA59376D1316A9542963B08819398B07FD20E8F1FF91E61E5FCBAFE6A2CD50BD6A5
F119082A59B663B874CBF51E313A5B0AE2A376149E93C0DBA4F9612E6D0DAD5D9C1F8EFB0838DCB
D3037E9FCADA6619BF536BF62F0A0FE69BE9F2DF274DF47887AEC666F93388F46A6DACAD77AEC6D
D62EE9BF8D42820E41DD02BA743A3A3F268AEBC7D5403D8266E7AAADCA75591922B247619A5AF1D
130737B78B966A87F8DA071390009CFB5A9FE2007AD67A533CB72BC9E7DAE65DEB502075FBCB99E
A1583A861D3020C206102049C02173F547ED90242B6C1D807C90035AC42846E318B18858C038ED5
ED1335EA2FB92B2300EFF009E5C4B4A2C2F5DA96F40233E881473C5554D191B3F1C0006E0023EC8
9E4FA19F965CCAC41FD43ECF42C6E7EC3C2D211BBC7C83D851E1E4DD4555F2BB95CE0FEA1CEE27A
17AA075594A96461DE3AFF7CC755F651A97D239257E2ACF61DB373D8B6B975DD399A86E2E695AA6
D64401BF88FB0C0DBE2199799B13CB753FF9997F1E37899F99BA9E5BAAEBF0DA072F921CF3DD711
D350FBCB3D1507194E8DE279BF2F9CF3AD61EBA87DE59E917638EFC7AC40B4C206101445DCF83D3
BA308B6FC208DE0ECEF8124452B2CAF162861B8CB16A8140A8996AE9159487F861AAD455A2AD598
1B2DB0F0D352FC4EDBF1B7701BC9E89CDBF57CC1F6BEA5691FDBA54363BDEC073EA1031F9883569
A7403F085C384F6F034C5E5CD669A8D05A2E600F8EE76A16D985FAB239B6A752E95ADB68BAB47E2
1950AE0E08DEB8046DEA8BC869AACE5F6F1A863E33ED3DCB0376A3CC14A8E0D2AB5D67D1661C28B
DBC3BCC3971B14B6A2D6E2B6CDA49E8CED39995E844621542F70946A2F152D55B9FC2B6C0B6FD81
B587A60775798596AE74DA73727F75D85759FB2482CDE81898F996B6EFD25D5DBA6501D0AF1D767
170E7A4AB2AEC83F31565D8C31D18DD8EC983557BDCA5101C36C27B20379754D9CD75454FF00441
FE259E92B0C1FDEFAC31EA33CEF967F0798EA18EEF0957D25B3F34F4CA78DC374019F5EC80E6103
080A22DDB6B32419246411D7033E8F56AB61473F6C7F38F9E75C63191BA799D6D3656FE2564AB29
CAB09AB97738E2C5366C7FEDF5F6D7FF58183CC3AEB34FCF2BE207C31A7C263A0BB1E223FE204C8
758D66E04CECF38D053CCEA570DC36D59F0ECC6ECEF561D5382D4731D31E0F083E3E92918F97102
BD42BB8E27D806E9B390A1AF4073FD4B19D4766C51EC993F4DAAD437E3FBA9F517693DE67534D53
22807601B008097AEDCCC9ABD28D453C236303C4A7B44E8DAB2A5037181C8A6C5D3FBB7D6411D38
C8F58969D5B5DEE69AA249FA44600F499D16A964D14067E1519C6D24EE03ACC04E57A3746393B0F
BD6BF7757CD3D020C2ED18276E3ABA84C7A70AEC12BFCA4DA5BEB11F34DA4C00C2293080A0C6062
03241813656B60C34E66AF95E76A8EE22750193981C6AB55ABD31E1BC1B546C0E3638FF00B7A66C
AF51A6D40C2F0B37D53EEB7A8CD6D556FF00128943F2DD3BF440A992B5FA3C3DE22E53A187AC4BD
742E9F977328EACE47CB98DE06A3A6C56EF5103158531F10F5CA02BB1FC3467FB20E3D7BA753C0D
474588BDCA22B68EC7FCCBD88EA1B3D903035617F3DC27F8D3DE73F30F965B55565E38117C2A379
5E96ED63D33657A1D3D7B42E4F59978000C0181016BAD6A40AB189904C826004C2293080A0C6061
08120C9CC2102732730840332730840332330840332330840826293084082610840FFFD9
    )
  WriteFile("iHotkey1.jpg",ArtworkDefault)
  VarSetCapacity(ArtworkDefault,0)
  ArtworkDefault =
Return

defPng01:
  Png01 =
    (Join
89504E470D0A1A0A0000000D494844520000000E0000000D0803000000AE02AF4D0000000467414
D410000AFC837058AE90000001974455874536F6674776172650041646F626520496D6167655265
61647971C9653C00000075504C5445909090747474727272B2B2B28989898686868D8D8D9C9C9CF
2F2F2AEAEAE7F7F7F7E7E7EBABABA9D9D9DAFAFAFD1D1D1ADADAD8F8F8F858585797979CECECE8B
8B8B8080808282828A8A8A969696E3E3E37C7C7C8484846F6F6FC9C9C9919191979797A7A7A7818
181CDCDCDA9A9A9999999FFFFFF89414BE20000002774524E53FFFFFFFFFFFFFFFFFFFFFFFFFFFF
FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00835697D9000000974944415478DA6
250830076080510400C50AE240F98020820189741144C0104108CCBA62804A2000208C6955013E4
0252000104E3B2AAA9B1A8AAA90104108C2BA3A626079406082018570C8899D4D4000208C455619
3661106D2B26A6A000104E4B20B70483133AAA9F173ABA901041090CBCD21A20CE22A005D021040
40AE122F271F03D05471A07A800002E9956762E5849A081060000757167F87F78EC500000000494
54E44AE426082
    )
  WriteFile("iHotkey1.png",Png01)
  VarSetCapacity(Png01,0)
  Png01 =
Return

defPng02:
  Png02 =
    (Join
89504E470D0A1A0A0000000D494844520000000E0000000D0803000000AE02AF4D0000000467414
D410000AFC837058AE90000001974455874536F6674776172650041646F626520496D6167655265
61647971C9653C00000102504C54458D8D8DF1F1F1F2F2F2F7F7F7D8D8D8D7D7D7898989C2C2C2E
7E7E77A7A7ADBDBDBF8F8F8848484ABABABFCFCFC868686696969F6F6F6A6A6A6C8C8C8E0E0E0E3
E3E3D6D6D65D5D5DF4F4F4888888FAFAFAA7A7A7C6C6C69393938383835959598C8C8CA9A9A9828
2829C9C9CEAEAEA959595EEEEEEA5A5A5E9E9E9CACACAE4E4E4636363B9B9B9626262B2B2B2E1E1
E1DDDDDDE5E5E57F7F7F6D6D6D8B8B8BB3B3B3E2E2E2B6B6B6A2A2A29E9E9EBCBCBC91919165656
5CFCFCFE8E8E8797979DEDEDE7E7E7EAAAAAAA1A1A1F5F5F57B7B7B9F9F9FD2D2D2EBEBEBD9D9D9
B0B0B0858585B8B8B8D0D0D0A3A3A3EFEFEFC1C1C1CECECEFDFDFDDADADAFFFFFFFFFFFF3984B77
D0000005674524E53FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
FFFFFFFFFFFFFFFFFFFFFFFFFFFFF004A4D6CD9000000D94944415478DA62080503564B06056920
0D10400C406CEEAC281B1C1C2CAC1E1A0A10400CA10142A2CC8CFC224C1C326CA1A10001C410EA2
6CA1814C4A612A2612A171A0A10400C3E2C5C1C2E8C3CCC21767A4AA1A10001C46011CC62E8EA6E
AD16642664121A0A10400CBCBE5C06FA129EFC9A56DEBCA1A10001C4C0CAC01ACC14222529ADEA2
5191A0A10400CA14E6C62120EF68222B682FE8EA1000104B4979D475B20508A3924842F98132080
18C08E3262F7E00E09E1D6D205082008975359588C2F8889451C208020DC501D0601711B79633F8
0000300E6A123FF3C4DD1FB0000000049454E44AE426082
    )
  WriteFile("iHotkey2.png",Png02)
  VarSetCapacity(Png02,0)
  Png02 =
Return

defPng03:
  Png03 =
    (Join
89504E470D0A1A0A0000000D494844520000000E0000000D0803000000AE02AF4D0000000467414
D410000AFC837058AE90000001974455874536F6674776172650041646F626520496D6167655265
61647971C9653C000000FF504C5445E0E0E0CFCFCFD9D9D9F6F6F6E8E8E8BFBFBF9A9A9AA8A8A8B
1B1B1D0D0D08C8C8C8D8D8D969696D3D3D3959595A1A1A1787878E2E2E2D8D8D8FCFCFCEFEFEFFE
FEFE7F7F7FB4B4B4FAFAFACECECEBCBCBCD4D4D4B0B0B0999999E4E4E4F0F0F0A3A3A3EDEDEDD1D
1D1CDCDCDEAEAEAE5E5E5919191F4F4F4646464C9C9C9C7C7C7F5F5F5F3F3F3E7E7E7F2F2F2E6E6
E6F1F1F1BBBBBBC3C3C3ADADAD8B8B8BD6D6D6A4A4A4C6C6C6DFDFDFB3B3B3B8B8B8DADADAABABA
BD2D2D2E9E9E96E6E6E5F5F5FC0C0C0C5C5C5797979878787EEEEEEA9A9A9909090A0A0A05E5E5E
939393E3E3E39292929F9F9FF7F7F7FBFBFBDBDBDBD7D7D7DCDCDCFFFFFFFFFFFF8B4F8D8300000
05574524E53FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
FFFFFFFFFFFFFFFFFFFFF00B0A107CF000000DF4944415478DA620801020E596E3E9B00100B2080
184242A4F839D585459C782C815C800062083197F166160D0EF6D737330C0901082086103553061
057C782D7392404208018C459830259FCB45D19789538F843000288812D802130C0D1CD8A899153
522C04208018B88402858214547982182595ED43000288C1CB36302848C69DDD8E454E5A2004208
0188CA50499A4E50C24FCE5F5C4D942000288C19A8B893140C51F6893AE40480840003184B07B04
092A0A07078BF0C98684000410D055BE26AC2C12CC46623E4057010410901BA2C9ADE1E9E0A2057
233408001007A7A239D66AE6BCF0000000049454E44AE426082
    )
  WriteFile("iHotkey3.png",Png03)
  VarSetCapacity(Png03,0)
  Png03 =
Return

defPng04:
  Png04 =
    (Join
89504E470D0A1A0A0000000D494844520000000E0000000D0803000000AE02AF4D0000000467414D
410000AFC837058AE90000001974455874536F6674776172650041646F626520496D616765526561
647971C9653C000000CF504C5445949494F1F1F1DBDBDBD7D7D7A7A7A79E9E9EF6F6F68282827878
78DFDFDFA3A3A3DEDEDE7F7F7F818181C2C2C28888886D6D6DC1C1C1F5F5F59393938D8D8D777777
A9A9A9AFAFAFFEFEFEA6A6A6F2F2F27C7C7CE1E1E1E6E6E69A9A9A7A7A7A858585727272A2A2A297
9797A1A1A18F8F8F6F6F6F878787BDBDBDB1B1B1BFBFBFA0A0A0747474EAEAEAE0E0E0717171EEEE
EEEFEFEF969696A8A8A8ABABABACACAC646464989898A4A4A48383838E8E8ED0D0D09F9F9FAEAEAE
F9F9F9AAAAAAFAFAFADDDDDDDCDCDCFFFFFFFFFFFFA2AFE2D40000004574524E53FFFFFFFFFFFFFF
FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00B2EEB138000000CB4944415478DA6270D1B4
8700316353171780006270B17570860007491717800042E2DA71B9B8000410886B276808E6B2BAB8
00041098ABADC427E52CC166EEE202104060AEB0B80A83162323838B0B400031B89838B0F1B318B1
8BAA3259B9B8000410830B8B10A33CAF9AA2852327BF8B0B400031B87019E80A988958CB70325BBA
B8000410838B8DAC1E8706B793A323338F8B0B400031B8C83971333902797CACEA2E2E0001C4E0C2
C0ECE4E4E8E4E464C364E3E20210400C2ECA0AEC3CD21C3AFABC409E0B40800100BFA121A9EB73A2
8C0000000049454E44AE426082
    )
  WriteFile("iHotkey4.png",Png04)
  VarSetCapacity(Png04,0)
  Png04 =
Return

defPng05:
  Png05 =
    (Join
89504E470D0A1A0A0000000D494844520000000E0000000D0803000000AE02AF4D0000000467414
D410000AFC837058AE90000001974455874536F6674776172650041646F626520496D6167655265
61647971C9653C000000FC504C5445ADADADBBBBBBB4B4B4A6A6A6CFCFCF9090908E8E8ED9D9D95
D5D5D666666F6F6F6868686818181CACACAC5C5C5E7E7E7AFAFAF989898C3C3C3969696C8C8C8BF
BFBF9A9A9A5353537D7D7DD6D6D66B6B6B585858CBCBCBB1B1B16F6F6FA0A0A0747474A1A1A1C9C
9C99292927A7A7AC0C0C0959595A8A8A86262625656567676765B5B5BCCCCCCBDBDBD5252528989
89838383AEAEAE9797978F8F8F696969AAAAAAB3B3B3B7B7B7BCBCBC93939394949499999977777
7888888B6B6B6787878606060B8B8B8D5D5D5575757ECECEC6363639B9B9B5454548B8B8BC6C6C6
B9B9B9C2C2C25A5A5AF5F5F5EBEBEBF8F8F8F1F1F1F9F9F9E8E8E8FFFFFF5D686BCC00000054745
24E53FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
FFFFFFFFFFFFF0053F772D1000000C84944415478DA6208B63612B6526665F3B0E536E031040820
06317627165E6F462606664531411580006210669764E115623463609677135400082006CBC0407
F10F2079281720001C4C00A24410260212980006260F30FD4910914E10B54D5F50FE4040820067D
2E5F254F2E21515F46475F5F0D800062E00E40021C0001C4C0E3E7276AE162C7E427C0E0E7E7031
0400C1241415EE641B20241A6EA4141CE0001C4601F8404C4010288414D04C2E207223E1B800062
083636E17475E0D096D674D7D30A06083000123F25A0DACC70F30000000049454E44AE426082
    )
  WriteFile("iHotkey5.png",Png05)
  VarSetCapacity(Png05,0)
  Png05 =
Return

defPng06:
  Png06 =
    (Join
89504E470D0A1A0A0000000D494844520000000E0000000D0803000000AE02AF4D0000000467414
D410000AFC837058AE90000001974455874536F6674776172650041646F626520496D6167655265
61647971C9653C000000D2504C5445F9F9F9F8F8F8F7F7F78D8D8DD0D0D09A9A9A747474ABABABA
8A8A8797979929292767676D1D1D1EEEEEEAAAAAA9D9D9DA0A0A0C6C6C6C8C8C8A9A9A9C5C5C580
8080A2A2A28F8F8FE5E5E56F6F6F717171989898939393ECECECB3B3B3D3D3D3A5A5A5BDBDBDD9D
9D9ADADADDCDCDCD5D5D5C7C7C7CFCFCF8A8A8ABFBFBFDBDBDB919191B4B4B48585858C8C8CD4D4
D4969696818181D8D8D8D7D7D7979797CACACAA4A4A4AEAEAE9494945C5C5CB2B2B29F9F9FB0B0B
0B7B7B7CECECE6A6A6AEFEFEFE6E6E6E0E0E0F6F6F6FFFFFFFFFFFF7668AE4D0000004674524E53
FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00699644D0000000BF49
44415478DA62700503533135300D10400C10AE890B179806082008579EC5C55C1DC40008200897D
D8541C91AC40008200657117E6D66031746670D4E6E512B8000629065E575717161646460005292
0001C4E0AA29A3EFCCC4C4E4ECEC6CC7A60C104040BDAA0A7C0E0E0EBC0EECE242AE000104328A8
5D51108242C145D5D010208C4E5B07572127472D2015A0D1040202EB7918AB4AE9E96B1A5AB2B40
0081B8CC3C8666AE026C3C52AEAE000104E2CA71DA0049617B0E575780000300ECE12334BA5D2C7
70000000049454E44AE426082
    )
  WriteFile("iHotkey6.png",Png06)
  VarSetCapacity(Png06,0)
  Png06 =
Return

defPng07:
  Png07 =
    (Join
4749463839611E001E00D53F00C9C9C9A4A4A48A8A8AF4F4F48A8AA7C5C5F8B8B8D2D7D7D99C9C9C
ABABAB7272739898C7393939797979434343EDEDEDFCFCFD5A5A5B6464654E4E729898B278789A52
5252EEEEF19B9BA5C2C2C3818182D6D6EA6A6A6BF9F9F9D1D1F96B6B744A4A4BCCCCD6C3C3E68A8A
C28181B38B8BD19999E6BDBDBDB6B6F4B1B1B1979797909090616181B6B6B68A8A91B9B9B96D6D95
3A3A5D9494D3A6A6EBA0A0ADEFEFF9E6E6E9AEAEBF4646548080A575758B43434A8F8FA2FFFFFFCC
CCCCFFFFFF21F9040100003F002C000000001E001E000006FFC09F7048FCF54EAB64CAD62B3A9FC2
A382E170801C8C56A709250E06CDC7946AB544241610B8FBBBE40813182DC2A082CC913C47E2B870
9D360434290963557779128A1C1A12115B4E1039193E0001756455168B0D0A1A2A0E2B104E063436
360774870D0D1C0E161C0D1A020D011A116B44307E1D1975AF2F2D01020A0E121A2B2A1A09090C01
7F42141B363553563E3E2FC30D1220C9012A09002002A3442C0622229802191929C30A1F0E2A0129
08293E110D1D45130B0B0830B8128019380D1C74E0B0A72D813E05FD74BD61C120CD0A04085620FC
5001448A1700129C7818718881093A223850294B432B8E15229C00E003012507108B40601123C64A
FF067B247C505081C48415D80020C8C64003983F3D3A60000142258B0A5849908011015BB67C021C
603071A007841A4DCCBEA82A61470EAD2360ECA0540901CDAA06642438E06141862136AAB6DAC182
050E0E747D2468E1E392820223101C404120C1100840155C1410CEAB628719EED098C123C006132B
5A0CE951488180002D462665868D0303052264AC38E161C48A015E4209D010806686040818FB58C1
40C28D1904106C808EC05C147D09E0A9A8D782A68F060C22D080BCDB4389150FA0FD80A0018443CF
8D2D84C750E0BC69133C10945C0D21AC84D70868201F080ADC509F0B2A8480C20802A4F784590FDC
42D5260A6020020A0B2018427DAF59F756200403C073830805CC20030F2B04B061090842C2861166
75B00005182010C0091BA0C0A20AB9BCB85A07278CB48107333088408F3E5E36648923A098808B49
12018101332250CF0010A817A511079C10DB014C401104003B
    )
  WriteFile("iHotkey7.png",Png07)
  VarSetCapacity(Png07,0)
  Png07 =
Return

defPng08:
  Png08 =
    (Join
4749463839611E001E00D53F00999999FCFCFC98291B5A595A444444FBD4CE666666E6E6E9F7F6F6
9D554B8D8D8DEC7A6CCA2913A4A4A4C8C8C8B2B2B2E74732F2897C7B7878717173AE3D2E9393C14E
4E728686A4E32B1378789ABBBBBB3A3A3AABABAB8181816B6B6EB9B9D0C2C2C3ECECECE1AEA7C890
88C97064F25641616181F2E6E4F43B236D6D953A3A5D8282B8FBF1F09C9CBDF2A197694B46A2A2AB
4C4C4DDCDCE07E7EAD75758BD0BFBDF0F0F2833025C2C2DDF36F5ED83F2AB98781F52F15CCCCCCFF
FFFFFFFFFF21F9040100003F002C000000001E001E000006FFC09F7048FCF9348AE4E3E02B3A9FC2
E3644320C4081B4DA00925226CCDD0946A8D0D0C5770F767BB5C2C29D860438D9907788381A07E1E
2E300F1C635576797A1E1D0603085C440117203D0E0D746455677A12131D00040A014E1F2D070732
73550412121E0467121D0A1D0D1D037D4329213E012074561A0FB4130406B1001D1C1C1B0D8E422D
32073653553D3D1A0D0A12680A000D001C0E9FA144261F3838960A2020C10A13C3DD0F000F3D0312
084516152D171B570DC9BC75F04023468307D738D49B808F480A3726FC7D02004096070F19622074
C041C3C286433E58A031C095AA0E1D5861CC304083831E0D24116058248009152A5C6DF080684286
FF191614F4A8B140070A1E0C129C68B60B8021022632489DB122C50007118EF2C0808187D7025B86
ECD260660FD51555098058E095010512234830F04A22EC90036658413511C30308115EBFFA18ECC3
85D71DE38404D839811B37853D4A20D5C1034501C28591EA123B88D3418F43B7926021D932660828
1280FC81E093AC062F418C402AC2078B1C952F0F664B4103111FF53804A3D8603603CC6C4DFB88C0
4300809A1D6240AE5663EB52C2C92F4B16A0A0C82E05C41408EC5A1B7965C3186E74F71E2044AD2B
3112F080C002B30FB66D5F3480B2CB46308010F050826E831570547A1ED8B0C6605BF88000650246
1081645B0930000089AD11850D1474152A18060C58A840231A7A8780043708A0E20D2F1830623325
46D15E45490010825D313AE183293240D34C10003B
    )
  WriteFile("iHotkey8.png",Png08)
  VarSetCapacity(Png08,0)
  Png08 =
Return

defPng09:
  Png09 =
    (Join
89504E470D0A1A0A0000000D494844520000000100000096080300000028A812400000000467414D
410000AFC837058AE90000001974455874536F6674776172650041646F626520496D616765526561
647971C9653C00000069504C5445D9D9D9E3E3E3D6D6D6DBDBDBE6E6E6E0E0E0D2D2D2D7D7D7E8E8
E8D5D5D5DCDCDCE9E9E9D3D3D3D8D8D8DFDFDFDDDDDDE2E2E2DADADAE5E5E5E4E4E4D4D4D4E1E1E1
EEEEEEDEDEDED1D1D1ECECECCFCFCFD0D0D0EAEAEAE7E7E7EBEBEBCECECECDCDCDEDEDEDCCCCCC99
D2706C000002AB4944415478DA621003082006318000621003082006318000625004082006458000
62500408200645800062500408200645800062500408200649800062900408200649800062900408
20064980006290030820063980006290030820063980006290030820063980006290010820061980
006290010820061980006290010820066E800062E0060820066E800062E0060820060E800062E000
0820060E800062E00008200659800062900508200659800062900508200659800062600108200616
80006260010820061680006210020820062180006210020820066180006210060820066180006210
06082006468000626004082006468000626004082006018000621000082006018000621005082006
51800062100508200651800062600508200656800062600508200656800062E0030820063E800062
E0030820067180006210070820067180006210070820067E800062E0070820067E800062E0020820
062E800062E0020820062E8000626006082006668000626006082006668000621004082006418000
6210040820060680006260000820060680006260000820065E800062E0050820065E800062600708
200676800062600708200676800062600208200626800062600208200626800062E0040820064E80
0062E0040820064E800062100108200611800062100108200611800062E0010820061E800062E001
0820061E800062600308200636800062600308200636800062900008200609800062900008200609
80006290000820066980006290060820066980006290060820066980006290020820062980006290
02082006298000629002082006798000629007082006798000629007082006798000629007082006
05800062500008200605800062500008200605800062500008200625800062500208200625800062
5002082006258000030047DD0ACEFD4876750000000049454E44AE426082
    )
  WriteFile("iHotkey9.png",Png09)
  VarSetCapacity(Png09,0)
  Png09 =
Return

defIco01:
  Ico01 =
    (Join
00000100010010100000010008006805000016000000280000001000000020000000010008000000
00004001000000000000000000000000000000000000000000000000800000800000008080008000
00008000800080800000C0C0C000C0DCC000F0CAA600D4F0FF00B1E2FF008ED4FF006BC6FF0048B8
FF0025AAFF0000AAFF000092DC00007AB90000629600004A730000325000D4E3FF00B1C7FF008EAB
FF006B8FFF004873FF002557FF000055FF000049DC00003DB900003196000025730000195000D4D4
FF00B1B1FF008E8EFF006B6BFF004848FF002525FF000000FE000000DC000000B900000096000000
730000005000E3D4FF00C7B1FF00AB8EFF008F6BFF007348FF005725FF005500FF004900DC003D00
B900310096002500730019005000F0D4FF00E2B1FF00D48EFF00C66BFF00B848FF00AA25FF00AA00
FF009200DC007A00B900620096004A00730032005000FFD4FF00FFB1FF00FF8EFF00FF6BFF00FF48
FF00FF25FF00FE00FE00DC00DC00B900B900960096007300730050005000FFD4F000FFB1E200FF8E
D400FF6BC600FF48B800FF25AA00FF00AA00DC009200B9007A009600620073004A0050003200FFD4
E300FFB1C700FF8EAB00FF6B8F00FF487300FF255700FF005500DC004900B9003D00960031007300
250050001900FFD4D400FFB1B100FF8E8E00FF6B6B00FF484800FF252500FE000000DC000000B900
0000960000007300000050000000FFE3D400FFC7B100FFAB8E00FF8F6B00FF734800FF572500FF55
0000DC490000B93D0000963100007325000050190000FFF0D400FFE2B100FFD48E00FFC66B00FFB8
4800FFAA2500FFAA0000DC920000B97A000096620000734A000050320000FFFFD400FFFFB100FFFF
8E00FFFF6B00FFFF4800FFFF2500FEFE0000DCDC0000B9B90000969600007373000050500000F0FF
D400E2FFB100D4FF8E00C6FF6B00B8FF4800AAFF2500AAFF000092DC00007AB90000629600004A73
000032500000E3FFD400C7FFB100ABFF8E008FFF6B0073FF480057FF250055FF000049DC00003DB9
0000319600002573000019500000D4FFD400B1FFB1008EFF8E006BFF6B0048FF480025FF250000FE
000000DC000000B90000009600000073000000500000D4FFE300B1FFC7008EFFAB006BFF8F0048FF
730025FF570000FF550000DC490000B93D00009631000073250000501900D4FFF000B1FFE2008EFF
D4006BFFC60048FFB80025FFAA0000FFAA0000DC920000B97A000096620000734A0000503200D4FF
FF00B1FFFF008EFFFF006BFFFF0048FFFF0025FFFF0000FEFE0000DCDC0000B9B900009696000073
730000505000F2F2F200E6E6E600DADADA00CECECE00C2C2C200B6B6B600AAAAAA009E9E9E009292
9200868686007A7A7A006E6E6E0062626200565656004A4A4A003E3E3E0032323200262626001A1A
1A000E0E0E00F0FBFF00A4A0A000808080000000FF0000FF000000FFFF00FF000000FF00FF00FFFF
0000FFFFFF000000000000000000EDED000000000000000000000000EFE507EBEE00000000000000
0000EFEEE3E2E5E5EAEE00000000000000EFE9E3E2E2E307E5F7EE0000000000EFE7E30979E207E7
E707E7EE000000EE0779790979E2EAF0EAEDF707EE0000EEE47879E209E207EFE9F7EB07EE0000EE
E3E378097AE2E307EDEDEA07EE0000EEE2E37A8979E3E4E3E7F7EDE5EE0000EEE2E30909E3E4E3E4
E307EDE5EE0000EEE2E3E3E3E5E4E5E4E4E2E5E5EE0000EEE3E4E3E3E3E3E2E3E3E3E3E3EE0000EE
EDE4E3E3E2E2E2E2E3E3E3E8EE00000000EFEEE9E4E2E3E3E9EDEFEE0000000000000000EFEBEAEE
00000000000000000000000000000000000000000000FF3F0000FC1F0000F00F0000E0070000C003
00008001000080010000800100008001000080010000800100008001000080010000E0030000FC3F
0000FFFF0000
    )
  WriteFile("iHotkey1.ico",Ico01)
  VarSetCapacity(Ico01,0)
  Ico01 =
Return


defIco02:
  Ico02 =
    (Join
00000100010010100000010008006805000016000000280000001000000020000000010008000000
00004001000000000000000000000000000000000000000000000000800000800000008080008000
00008000800080800000C0C0C000C0DCC000F0CAA600D4F0FF00B1E2FF008ED4FF006BC6FF0048B8
FF0025AAFF0000AAFF000092DC00007AB90000629600004A730000325000D4E3FF00B1C7FF008EAB
FF006B8FFF004873FF002557FF000055FF000049DC00003DB900003196000025730000195000D4D4
FF00B1B1FF008E8EFF006B6BFF004848FF002525FF000000FE000000DC000000B900000096000000
730000005000E3D4FF00C7B1FF00AB8EFF008F6BFF007348FF005725FF005500FF004900DC003D00
B900310096002500730019005000F0D4FF00E2B1FF00D48EFF00C66BFF00B848FF00AA25FF00AA00
FF009200DC007A00B900620096004A00730032005000FFD4FF00FFB1FF00FF8EFF00FF6BFF00FF48
FF00FF25FF00FE00FE00DC00DC00B900B900960096007300730050005000FFD4F000FFB1E200FF8E
D400FF6BC600FF48B800FF25AA00FF00AA00DC009200B9007A009600620073004A0050003200FFD4
E300FFB1C700FF8EAB00FF6B8F00FF487300FF255700FF005500DC004900B9003D00960031007300
250050001900FFD4D400FFB1B100FF8E8E00FF6B6B00FF484800FF252500FE000000DC000000B900
0000960000007300000050000000FFE3D400FFC7B100FFAB8E00FF8F6B00FF734800FF572500FF55
0000DC490000B93D0000963100007325000050190000FFF0D400FFE2B100FFD48E00FFC66B00FFB8
4800FFAA2500FFAA0000DC920000B97A000096620000734A000050320000FFFFD400FFFFB100FFFF
8E00FFFF6B00FFFF4800FFFF2500FEFE0000DCDC0000B9B90000969600007373000050500000F0FF
D400E2FFB100D4FF8E00C6FF6B00B8FF4800AAFF2500AAFF000092DC00007AB90000629600004A73
000032500000E3FFD400C7FFB100ABFF8E008FFF6B0073FF480057FF250055FF000049DC00003DB9
0000319600002573000019500000D4FFD400B1FFB1008EFF8E006BFF6B0048FF480025FF250000FE
000000DC000000B90000009600000073000000500000D4FFE300B1FFC7008EFFAB006BFF8F0048FF
730025FF570000FF550000DC490000B93D00009631000073250000501900D4FFF000B1FFE2008EFF
D4006BFFC60048FFB80025FFAA0000FFAA0000DC920000B97A000096620000734A0000503200D4FF
FF00B1FFFF008EFFFF006BFFFF0048FFFF0025FFFF0000FEFE0000DCDC0000B9B900009696000073
730000505000F2F2F200E6E6E600DADADA00CECECE00C2C2C200B6B6B600AAAAAA009E9E9E009292
9200868686007A7A7A006E6E6E0062626200565656004A4A4A003E3E3E0032323200262626001A1A
1A000E0E0E00F0FBFF00A4A0A000808080000000FF0000FF000000FFFF00FF000000FF00FF00FFFF
0000FFFFFF002B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B0000000000EFE507EBEE000000002B2B00
000000EEE3E2E5E5EAEE0000002B2B0000EFE9E3E2E2E307E5F7EE00002B2B00EFE7E30979E207E7
E707E7EE002B2BEE0779790979E2EAF0EAEDF707EE2B2BEEE47879E209E207EFE9F7EB07EE2B2BEE
E3E378097AE2E307EDEDEA07EE2B2BEEE2E37A8979E3E4E3E7F7EDE5EE2B2BEEE2E30909E3E4E3E4
E307EDE5EE2B2BEEE2E3E3E3E5E4E5E4E4E2E5E5EE2B2BEEE3E4E3E3E3E3E2E3E3E3E3E3EE2B2BEE
EDE4E3E3E2E2E2E2E3E3E3E8EE2B2B0000EFEEE9E4E2E3E3E9EDEFEE002B2B0000000000EFEBEAEE
00000000002B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B000000007C1E0000780E0000600600004002
00000000000000000000000000000000000000000000000000000000000000000000600200007C3E
000000000000
    )
  WriteFile("iHotkey2.ico",Ico02)
  VarSetCapacity(Ico02,0)
  Ico02 =
Return

defIco03:
  Ico03 =
    (Join
00000100010010100000010008006805000016000000280000001000000020000000010008000000
00004001000000000000000000000000000000000000000000000000800000800000008080008000
00008000800080800000C0C0C000C0DCC000F0CAA600D4F0FF00B1E2FF008ED4FF006BC6FF0048B8
FF0025AAFF0000AAFF000092DC00007AB90000629600004A730000325000D4E3FF00B1C7FF008EAB
FF006B8FFF004873FF002557FF000055FF000049DC00003DB900003196000025730000195000D4D4
FF00B1B1FF008E8EFF006B6BFF004848FF002525FF000000FE000000DC000000B900000096000000
730000005000E3D4FF00C7B1FF00AB8EFF008F6BFF007348FF005725FF005500FF004900DC003D00
B900310096002500730019005000F0D4FF00E2B1FF00D48EFF00C66BFF00B848FF00AA25FF00AA00
FF009200DC007A00B900620096004A00730032005000FFD4FF00FFB1FF00FF8EFF00FF6BFF00FF48
FF00FF25FF00FE00FE00DC00DC00B900B900960096007300730050005000FFD4F000FFB1E200FF8E
D400FF6BC600FF48B800FF25AA00FF00AA00DC009200B9007A009600620073004A0050003200FFD4
E300FFB1C700FF8EAB00FF6B8F00FF487300FF255700FF005500DC004900B9003D00960031007300
250050001900FFD4D400FFB1B100FF8E8E00FF6B6B00FF484800FF252500FE000000DC000000B900
0000960000007300000050000000FFE3D400FFC7B100FFAB8E00FF8F6B00FF734800FF572500FF55
0000DC490000B93D0000963100007325000050190000FFF0D400FFE2B100FFD48E00FFC66B00FFB8
4800FFAA2500FFAA0000DC920000B97A000096620000734A000050320000FFFFD400FFFFB100FFFF
8E00FFFF6B00FFFF4800FFFF2500FEFE0000DCDC0000B9B90000969600007373000050500000F0FF
D400E2FFB100D4FF8E00C6FF6B00B8FF4800AAFF2500AAFF000092DC00007AB90000629600004A73
000032500000E3FFD400C7FFB100ABFF8E008FFF6B0073FF480057FF250055FF000049DC00003DB9
0000319600002573000019500000D4FFD400B1FFB1008EFF8E006BFF6B0048FF480025FF250000FE
000000DC000000B90000009600000073000000500000D4FFE300B1FFC7008EFFAB006BFF8F0048FF
730025FF570000FF550000DC490000B93D00009631000073250000501900D4FFF000B1FFE2008EFF
D4006BFFC60048FFB80025FFAA0000FFAA0000DC920000B97A000096620000734A0000503200D4FF
FF00B1FFFF008EFFFF006BFFFF0048FFFF0025FFFF0000FEFE0000DCDC0000B9B900009696000073
730000505000F2F2F200E6E6E600DADADA00CECECE00C2C2C200B6B6B600AAAAAA009E9E9E009292
9200868686007A7A7A006E6E6E0062626200565656004A4A4A003E3E3E0032323200262626001A1A
1A000E0E0E00F0FBFF00A4A0A000808080000000FF0000FF000000FFFF00FF000000FF00FF00FFFF
0000FFFFFF000000000000000000EDED000000000000000000000000EFEEFFE21F1F1FEE00000000
0000EFEEE3FFF92726192727EF00000000EFE9E3E2ED27E2FFFF25271E000000EFE7E309792727FF
FF2527FF270000EE0779790979271EFF2527FFFF270000EEE47879E20926271D27FFFF181E0000EE
E3E378097AE625271EE91E27EE0000EEE2E37A8979EFE52727272722EE0000EEE2E30909E3E4E3E4
E307EDE5EE0000EEE2E3E3E3E5E4E5E4E4E2E5E5EE0000EEE3E4E3E3E3E3E2E3E3E3E3E3EE0000EE
EDE4E3E3E2E2E2E2E3E3E3E8EE00000000EFEEE9E4E2E3E3E9EDEFEE0000000000000000EFEBEAEE
00000000000000000000000000000000000000000000FF3F0000FC030000F0010000E0010000C001
00008001000080010000800100008001000080010000800100008001000080010000E0030000FC3F
0000FFFF0000
    )
  WriteFile("iHotkey3.ico",Ico03)
  VarSetCapacity(Ico03,0)
  Ico03 =
Return

defIco04:
  Ico04 =
    (Join
00000100010010100000010008006805000016000000280000001000000020000000010008000000
00004001000000000000000000000000000000000000000000000000800000800000008080008000
00008000800080800000C0C0C000C0DCC000F0CAA600D4F0FF00B1E2FF008ED4FF006BC6FF0048B8
FF0025AAFF0000AAFF000092DC00007AB90000629600004A730000325000D4E3FF00B1C7FF008EAB
FF006B8FFF004873FF002557FF000055FF000049DC00003DB900003196000025730000195000D4D4
FF00B1B1FF008E8EFF006B6BFF004848FF002525FF000000FE000000DC000000B900000096000000
730000005000E3D4FF00C7B1FF00AB8EFF008F6BFF007348FF005725FF005500FF004900DC003D00
B900310096002500730019005000F0D4FF00E2B1FF00D48EFF00C66BFF00B848FF00AA25FF00AA00
FF009200DC007A00B900620096004A00730032005000FFD4FF00FFB1FF00FF8EFF00FF6BFF00FF48
FF00FF25FF00FE00FE00DC00DC00B900B900960096007300730050005000FFD4F000FFB1E200FF8E
D400FF6BC600FF48B800FF25AA00FF00AA00DC009200B9007A009600620073004A0050003200FFD4
E300FFB1C700FF8EAB00FF6B8F00FF487300FF255700FF005500DC004900B9003D00960031007300
250050001900FFD4D400FFB1B100FF8E8E00FF6B6B00FF484800FF252500FE000000DC000000B900
0000960000007300000050000000FFE3D400FFC7B100FFAB8E00FF8F6B00FF734800FF572500FF55
0000DC490000B93D0000963100007325000050190000FFF0D400FFE2B100FFD48E00FFC66B00FFB8
4800FFAA2500FFAA0000DC920000B97A000096620000734A000050320000FFFFD400FFFFB100FFFF
8E00FFFF6B00FFFF4800FFFF2500FEFE0000DCDC0000B9B90000969600007373000050500000F0FF
D400E2FFB100D4FF8E00C6FF6B00B8FF4800AAFF2500AAFF000092DC00007AB90000629600004A73
000032500000E3FFD400C7FFB100ABFF8E008FFF6B0073FF480057FF250055FF000049DC00003DB9
0000319600002573000019500000D4FFD400B1FFB1008EFF8E006BFF6B0048FF480025FF250000FE
000000DC000000B90000009600000073000000500000D4FFE300B1FFC7008EFFAB006BFF8F0048FF
730025FF570000FF550000DC490000B93D00009631000073250000501900D4FFF000B1FFE2008EFF
D4006BFFC60048FFB80025FFAA0000FFAA0000DC920000B97A000096620000734A0000503200D4FF
FF00B1FFFF008EFFFF006BFFFF0048FFFF0025FFFF0000FEFE0000DCDC0000B9B900009696000073
730000505000F2F2F200E6E6E600DADADA00CECECE00C2C2C200B6B6B600AAAAAA009E9E9E009292
9200868686007A7A7A006E6E6E0062626200565656004A4A4A003E3E3E0032323200262626001A1A
1A000E0E0E00F0FBFF00A4A0A000808080000000FF0000FF000000FFFF00FF000000FF00FF00FFFF
0000FFFFFF000000000000000000F9F9F90000F9F9F9000000000000EFE5F9F9F90000F9F9F90000
0000EFEEE3E2F9F9F9F700F9F9F9000000EFE9E3E2E2F9F9F9F7F7F9F9F90000EFE7E30979E2F9F9
F907E7F9F9F900EE0779790979E2F9F9F9F7F7F9F9F900EEE47879E209E2F9F9F9F7F7F9F9F900EE
E3E378097AE2F9F9F9EDEAF9F9F900EEE2E37A8979E3E4E3E7F7EDE5EE0000EEE2E30909E3E4E3E4
E307EDE5EE0000EEE2E3E3E3E5E4E5E4E4E2E5E5EE0000EEE3E4E3E3E3E3E2E3E3E3E3E3EE0000EE
EDE4E3E3E2E2E2E2E3E3E3E8EE00000000EFEEE9E4E2E3E3E9EDEFEE0000000000000000EFEBEAEE
00000000000000000000000000000000000000000000FF180000FC180000F0080000E0000000C000
00008000000080000000800000008001000080010000800100008001000080010000E0030000FC3F
0000FFFF0000
    )
  WriteFile("iHotkey4.ico",Ico04)
  VarSetCapacity(Ico04,0)
  Ico04 =
Return

;--------------------------------------------------------------------------------
/*
XMLGet(xml, node, attr = "") ; Simple XML Get - by infogulch
  {                          ; Forum Topic: www.autohotkey.com/forum/topic42682.html
  RegExMatch(xml, (attr ? ("<" node "\b[^>]*\b" attr "=""(?<match>[^""]*)""[^>]*>") : ("<" node "\b[^>/]*>(?<match>(?<tag>(?:[^<]*(?:<(\w+)\b[^>]*>(?&tag)</\3>)*)*))</" node ">")), retval)
  return retvalMatch
  }

UTFDecode(str) ; Forum Topic: www.autohotkey.com/forum/topic47400.html - by YMP
  {            ; Forum Topic: www.autohotkey.com/forum/topic47777.html - by Icarus
  RawLen := StrLen(str)
  Charset := 0 ; 1252 or 0
  BufSize := (RawLen + 1) * 2
  VarSetCapacity(Buf, BufSize, 0)
  DllCall("MultiByteToWideChar", "uint", 65001, "int", 0, "str", str, "int", -1, "uint", &Buf, "uint", RawLen + 1)
  DllCall("WideCharToMultiByte", "uint", Charset, "int", 0, "uint", &Buf, "int", -1, "str", str, "uint", RawLen + 1, "int", 0, "int", 0)
  Return str
  }

UnHTM(TXT) { ; Convert to ordinary text - by SKAN (modified)
 Static HT   ; Forum Topic: www.autohotkey.com/forum/topic51342.html
 IfEqual,HT,,   SetEnv,HT, % "&aacuteá&acircâ&acute´&aeligæ&agraveà&amp&aringå&atildeã&au"
 . "mlä&bdquo„&brvbar¦&bull•&ccedilç&cedil¸&cent¢&circˆ&copy©&curren¤&dagger†&dagger‡&deg"
 . "°&divide÷&eacuteé&ecircê&egraveè&ethð&eumlë&euro€&fnofƒ&frac12½&frac14¼&frac34¾&gt>&h"
 . "ellip…&iacuteí&icircî&iexcl¡&igraveì&iquest¿&iumlï&laquo«&ldquo“&lsaquo‹&lsquo‘&lt<&m"
 . "acr¯&mdash—&microµ&middot·&nbsp &ndash–&not¬&ntildeñ&oacuteó&ocircô&oeligœ&ograveò&or"
 . "dfª&ordmº&oslashø&otildeõ&oumlö&para¶&permil‰&plusmn±&pound£&quot""&raquo»&rdquo”&reg"
 . "®&rsaquo›&rsquo’&sbquo‚&scaronš&sect§&shy&sup1¹&sup2²&sup3³&szligß&thornþ&tilde˜&tim"
 . "es×&trade™&uacuteú&ucircû&ugraveù&uml¨&uumlü&yacuteý&yen¥&yumlÿ"
 Loop, Parse, TXT, &`;                              ; Create a list of special characters
   L := "&" A_LoopField ";", R .= (!(A_Index&1)) ? ( (!InStr(R,L,1)) ? L:"" ) : ""
 StringTrimRight, R, R, 1
 Loop, Parse, R , `;                                ; Parse Special Characters
  If F := InStr( HT, A_LoopField )                  ; Lookup HT Data
    StringReplace, TXT,TXT, %A_LoopField%`;, % SubStr( HT,F+StrLen(A_LoopField), 1 ), All
  Else If ( SubStr( A_LoopField,2,1)="#" )
    StringReplace, TXT, TXT, %A_LoopField%`;, % Chr(SubStr(A_LoopField,3)), All
Return TXT
}
*/
