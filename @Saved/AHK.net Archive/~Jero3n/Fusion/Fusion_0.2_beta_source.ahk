
;#######################################################
;##                Fusion MediaCenter                 ##
;#######################################################
;
;<----------------------Features----------------------->
;
;- Play music and video's
;- Import 1 file or a whole map with a few clicks
;- Watch tv
;- Listen to the radio
;
;<----------------------Licensing---------------------->
;
; You are allowed to do everything with the sourcecode,
; except the following:
;
; 1. Commercial use
; 2. Any way of getting money
;
; If you still want to use the sourcecode for on of these,
; and you think you have a really good reason, contact me
; and explain exactly what you want to do.
; Only if i give you authorisation for it, you are allowed
; to do it. But I have the rights to stop it if I don't
; want it anymore for any reason.
;
;<---------------------Information--------------------->
;
; Author: J. Offerijns
; Version: 0.1.3 alpha
; Scripting language: AutoHotkey 1.0.47.05
;
;<-----------------------History----------------------->
;
; 0.2   - New gui
;	  Added play next
; 0.1.4 - Fixed anchoring bugs
;	  Added properties window 
; 0.1.3 - Added rating.
;	  Added delete function
;	  Added auto-sorting on rating
;	  Fixed LVMedia preparation bug.
;	  Finished TV streaming basics
;	  Adjusted LVMedia column sizes
; 0.1.2 - Added TV streaming beta
; 0.1.1 - Added mci functions, xpath & ie
; 0.1   - First version
;
;<-----------------------Contact----------------------->
;
; E-mail: Jero3n@xs4all.nl
; PM: PM Jero3n at the AHK forum
;
; Haarlem, The Netherlands
;
;#######################################################


Gui 1: Default
Gui, +Resize +LastFound +0x800000 +MinSize800x600
Gui, Margin, 0, 0

#SingleInstance, force
SetTitleMatchMode, 2
SetWinDelay, -1
SetBatchLines, -1

GUIName := "Fusion 0.2 Alpha"
GUIHeight := A_ScreenHeight - 84
GUIWidth := A_ScreenWidth - 8
LVHeight := GUIHeight - 112
LBHeight := LVHeight +15
LVWidth := GUIwidth - 210

;#######################################################
;##                       Menu's                      ##
;#######################################################

Menu, Tray, Icon, speaker.ico

Menu, ImportMenu, Add, File, ImportFile
Menu, ImportMenu, Add, Folder, ImportFolder
Menu, JumpMenu, Add, Official website, Blank
Menu, JumpMenu, Add, Forum, Blank
Menu, JumpMenu, Add, Chat, Blank
Menu, Filemenu, Add, Import, :ImportMenu
Menu, Filemenu, Add, Export, Blank
Menu, Filemenu, Add, Settings, Blank
Menu, FileMenu, Add, Exit, Exit
Menu, Edit, Add, Cut, Blank
Menu, Edit, Add, Copy, Blank
Menu, Edit, Add, Past, Blank
Menu, Edit, Add, Undo, Blank
Menu, Edit, Add
Menu, Edit, Add, Select all, Blank
Menu, Music, Add, Play/Pause, PlayPause
Menu, Music, Add, Stop, Stop
Menu, Music, Add, Next, Blank
Menu, Music, Add, Previous, Blank
Menu, Music, Add, Shuffle, ToggleCheckShuffle
Menu, Help, Add, Help, Blank
Menu, Help, Add, Support, Blank
Menu, Help, Add, FAQ, Blank
Menu, Help, Add, Hotkeys, Blank
Menu, Help, Add
Menu, Help, Add, Check updates, Blank
Menu, Help, Add, Jump to, :JumpMenu
Menu, Help, Add, About, Blank
Menu, MyMenu, Add, File, :FileMenu
Menu, MyMenu, Add, Edit, :Edit
Menu, MyMenu, Add, Music, :Music
Menu, MyMenu, Add, Help, :Help
Gui, Menu, MyMenu

Menu, LVMenu, Add, Play, PlayLVItem
Menu, LVMenu, Add, Play Next, Blank
Menu, LVMenu, Add, Copy, Blank
Menu, LVMenu, Add, Delete, DeleteTrack
Menu, LVMenu, Add
Menu, LVMenu, Add, Add to favorites, Blank
Menu, LVMenu, Add, Get matching tracks, Blank
Menu, LVMenu, Add
Menu, LVRateMenu, Add, 5, Rate5
Menu, LVRateMenu, Add, 4, Rate4
Menu, LVRateMenu, Add, 3, Rate3
Menu, LVRateMenu, Add, 2, Rate2
Menu, LVRateMenu, Add, 1, Rate1
Menu, LVMenu, Add, Rate, :LVRateMenu
Menu, LVMenu, Add
Menu, LVMenu, Add, Properties, ShowProperties

;#######################################################
;##                    Collection                     ##
;#######################################################

Gui, Add, Button,x10 y10 h50 w50 vButtonPlay gPlayPause, Play
Gui, Add, Button, x+5 y10 h50 w50 vButtonStop gStop, Stop
Gui, Add, Text, x+12 y33 vTextPlayed, 1:36
Gui, Add, Slider, x+5 y27 w150 h30 vLoc Range0-100 NoTicks Thick20, 30
Gui, Add, Text, x+0 y33 vTextToGo, -2:29
Gui, Add, Text, x+20 y33 vTextVolume gTest, Volume
Gui, Add, Slider, x+10 y10 w150 h60 vVolume gSetVolume Range0-100 NoTicks Thick20 Vertical Invert, 50

Gui, Add, ListBox, x10 y88 w180 h%LBHeight% vLBMenu gLBMenuActions, |  Collection|    Music|    Video|    Podcasts| |  Playlists|    Top played|    Last played|    Last added  |    Favorites| |  TV|  Radio
Gui, Add, ListView, x+10 y88 w%LVWidth% h%LVHeight% vLVMedia gLVMediaActions Grid +AltSubmit,  |Title|Artist|Album|Genre|Length|Rating

Gui, Add, Text, y+8 vStatus,

;Gui, Show, w%GUIWidth% h%GUIHeight% Center, %GUIName%
Gui, Show, Maximize Center, %GUIName%

;#######################################################
;##                        TV                         ##
;#######################################################

Gui, Add, Text, x260 y85 Hidden vTextCountry, Country:
Gui, Add, ComboBox, x320 y81 Hidden vLBCountry gAC,
Gui, Add, Text, x490 y85 Hidden vTextGenre, Genre:
Gui, Add, DropDownList, x550 y81 Hidden vLBGenre,

;#######################################################
;##                Auto-start Functions               ##
;#######################################################

LVX_Setup("LVMedia")

CurrentTab = Music

xpath_load(lib, "fusion_lib.xml")
xpath_load(streams, "fusion_streams.xml")

Gosub, PrepareLVMedia

;#######################################################
;##                Properties window                  ##
;#######################################################

Gui 2: Default

Gui, +Owner

Gui, Add, Text, x20 y20, Title
Gui, Add, Edit, x60 y16 vGUI2_Title
Gui, Add, Text, x20 y50, Artist
Gui, Add, Edit, x60 y46 vGUI2_Artist
Gui, Add, Text, x20 y80, Album
Gui, Add, Edit, x60 y76 vGUI2_Album
Gui, Add, Text, x20 y110, Year
Gui, Add, Edit, x60 y106 vGUI2_Year
Gui, Add, Text, x20 y140, Track
Gui, Add, Edit, x60 y136 vGUI2_Track
Gui, Add, Text, x20 y170, Genre
Gui, Add, Edit, x60 y166 vGUI2_Genre
Gui, Add, Text, x20 y200, Rating
Gui, Add, DropDownList, x60 y196 vGUI2_Rating, 5|4|3|2|1
Gui, Add, Text, x20 y230, Id
Gui, Add, Text, x60 y230 vGUI2_Id
Gui, Add, Button, x20 y260 w80, OK
Gui, Add, Button, x+10 y260 w80 gCloseProp, Cancel
;Gui 2: Show,h330 w210,Properties

;#######################################################
;##                     IE window                     ##
;#######################################################

Gui 3: Default

Gui 3: +Lastfound -Resize -Caption

hGui:= WinExist()
pwb := IE_Add(hGui, 10, 10, 400, 400)

Return

;#######################################################
;##                 Sound Functions                   ##
;#######################################################

ImportFile:
 If(SH) {
  Sound_Stop(SH)
  Sound_Close(SH)
 }
 FileSelectFile, file, 1,, Select Audio File, Audio (*.wpl; *.wav; *.mp2; *.mp3; *.wma; *.mpeg)
 SplitPath, File, FileName
 SetText := SetStatus("Importing track " FileName)
 track_tags := GetTrackTags(file)
 StringSplit, track_tags, track_tags, `€`,
 AddTrack(track_tags1,track_tags2,track_tags3,track_tags4,track_tags5,track_tags6,track_tags7,File)
 SH := Sound_Open(File)
 If(SH) {
  Sound_Stop(SH)
  Sound_Close(SH)
 }
 Gosub,PlayPause
 LastId := xpath(lib, "/xml/track/count()")
 LVX_SetColour(LastId, 0xffffff, 0xff0000)
 CurrentPlaying := LastId
 SetText := SetStatus("")
Return

ImportFolder:
 FileSelectFolder, SelFolder, 0, 0
 Loop, %SelFolder%\*.mp3, , 1
 {
  SplitPath, FullFileName, Name
  SetText := SetStatus("Importing track " A_LoopFileName)
  File := A_LoopFileFullPath
  Track_Tags := GetTrackTags(File)
  StringSplit, track_tags, track_tags, `€`,
  AddTrack(track_tags1,track_tags2,track_tags3,track_tags4,track_tags5,track_tags6,track_tags7,File)
 }
 SetText := SetStatus("")
Return

Close:
 Sound_close(SH)
Return

PlayPause:
 If CurrentPlaying
 {
  LVX_SetColour(CurrentPlaying, 0xffffff, 0x000000)
 }
 Status := Sound_Status(SH)
 If(Status = "stopped" OR Status = "paused")
 {
  Started := 1
  If (status = stopped) {
   Sound_Play(SH,"1")
   GuiControl,, Play, Pause
  }
  Else {
   Sound_Resume(SH)
  }
 }
  Else {
   If (SH) {
   Sound_Pause(SH)
   }
 }
Return

PlayLVItem:
 ControlGet, iteminfo, List, Focused, SysListView321, %GUIName%
 FoundPos := RegExMatch(iteminfo, "(\d+)", id)
 StringReplace, id, id1, %A_SPACE%,, All
 src := xpath(lib, "/xml/track[" . id . "]/src/text()")
 If(SH) {
  Sound_Stop(SH)
  Sound_Close(SH)
 }
 SH := Sound_Open(src)
 Gosub, PlayPause
 LVX_SetColour(id, 0xFFFFFF, 0xff0000)
 CurrentPlaying := id
 title := xpath(lib, "/xml/track[" . id . "]/title/text()")
 artist := xpath(lib, "/xml/track[" . id . "]/artist/text()")
 SB_SetText("Playing music",2)
Return

Stop:
 Sound_Stop(SH)
Return

SetVolume:
 SoundSet,%volume%,master
Return

Seek:
 Sound_Pause(SH)
 Sound_SeekSeconds(SH, %Location%)
 Sound_Play(SH)
Return

;#######################################################
;##                   Preparations                    ##
;#######################################################

PrepareSlider:
 totallength := Sound_Length(SH)
 min := Floor(totallength / (1000 * 60))
 SetFormat, Float, 0.0
 lengthseconds := totallength/1000
 NewRange = %lenghtseconds%
 GuiControl,, Location, %Min%
 GuiControl, +range1-%NewRange%, Location
Return

PrepareLVMedia:
 GuiControl, Disable, LBMenu
 Guicontrol, Disable, LVMedia
 GuiControl, -Redraw, LVmedia
 SetText := SetStatus("Loading tracks")
 LV_Delete()
 All := xpath(lib, "/xml/track/rawsrc()")
 Total := xpath(lib, "/xml/track/count()")
 Number := 1
 Loop, Parse, all, `,
 {
  SetText := SetStatus("Loading track" A_Index " of " total)
  current := A_LoopField
  LV_Add("", xpath(current, "/track/id/text()")
      , xpath(current, "/track/title/text()")
      , xpath(current, "/track/artist/text()")
      , xpath(current, "/track/album/text()")
      , xpath(current, "/track/genre/text()")
      , xpath(current, "/track/length/text()")
      , xpath(current, "/track/rating/text()"))
}
 All := current := ""
 SetText := SetStatus("")
 Gosub, AdjustLVMedia
 GuiControl, +Redraw, LVMedia
 Guicontrol, Enable, LVMedia
 GuiControl, Enable, LBMenu
Return

PrepareLVTV:
 GuiControl, Disable, LBMenu
 Guicontrol, Disable, LVMedia
 GuiControl, -Redraw, LVMedia
 SetText := SetStatus("Loading channels")
 LV_Delete()
 total := xpath(streams, "/xml/country/stream/count()")
 number := 1
 all_countries := xpath(streams, "/xml/country/@name/text()")
 Loop, Parse, all_countries, `,
 {
  Country = %A_LoopField%
  All := xpath(streams, e := "/xml/country[@name='" . country . "']/stream/rawsrc()")
  StreamCount := xpath(streams, "/xml/country[@name=" . country . "]/stream/count()")
  If Streamcount = 0
   continue

  ; you WILL NOT need the following lines in future versions of xpath because theres a bug:
  StringReplace, all, all, xml/country/, , All
  StringReplace, all, all, //stream, /stream, All

  Loop, Parse, all, `,
  {
   current := A_LoopField
   LV_Add("", xpath(current, "/stream/id/text()"), xpath(current, "/stream/name/text()"), country)
  }
 }
 SetText := SetStatus("")
 Gosub, AdjustLVMedia
 GuiControl, +Redraw, LVMedia
 Guicontrol, Enable, LVMedia
 GuiControl, Enable, LBMenu
Return


PrepareLBCountry:
 SetText := SetStatus("Loading country list")
 GuiControl, Disable, LBCountry
 totalcountries := xpath(streams, "/xml/country/count()")
 CountryArray := ""
 Loop, %totalcountries% {
  Country := xpath(streams, "/xml/country[" . A_Index . "]/@name/text()")
  CountryArray = %CountryArray%|%Country%
 }
 Guicontrol,, LBCountry, %CountryArray%
 GuiControl, Enable, LBCountry
 SetText := SetStatus("")
Return

;#######################################################
;##                      Actions                      ##
;#######################################################

LVMediaActions:
 If CurrentTab = Music
 {
  If A_GuiEvent = DoubleClick
  {
   LV_GetText(id, A_EventInfo, 1)
   src := xpath(lib, "/xml/track[" . id . "]/src/text()")
   If(SH) {
    Sound_Stop(SH)
    Sound_Close(SH)
   }
   SH := Sound_Open(src)
   Gosub, PlayPause
   LVX_SetColour(A_EventInfo, 0xFFFFFF, 0xff0000)
   CurrentPlaying := A_EventInfo
   title := xpath(lib, "/xml/track[" . id . "]/title/text()")
   artist := xpath(lib, "/xml/track[" . id . "]/artist/text()")
   Gosub, PrepareSlider
  }
  If A_GuiEvent = Rightclick
  {
   Menu, LVMenu, Show
  }
 }
 If CurrentTab = TV
 {
  If A_GuiEvent = DoubleClick
  {
   ControlGet, iteminfo, List, Focused, SysListView321, %GUIName%
   RegEx = ([a-zA-Z ]+) 
   RegExMatch(iteminfo, "i)" . RegEx, name_match)
   src := xpath(xml, "/xml/country/stream[name=" . name_match1 . "]/url/text()")
   FileDelete, tempfile.html
   HTML := "<embed name=mediaplayer1 pluginspage=http://www.microsoft.com/Windows/MediaPlayer/ src=temp type=application/x-mplayer2 loop=0 mute=0 volume=100 invokeurls=-1 currentmarker=0 playcount=1 currentposition=0.8491248 balance=0 autostart=true showstatusbar=1 style=width:400px; height:400px;>"
   StringReplace, HTML, HTML, src=temp, src=%src%
   FileAppend, %HTML%, tempfile.html
   IE_LoadHTML(pwb, %HTML%)
   Gui 3: Show, w400 h400 Center
  }
 }
Return

LBMenuActions:
 If A_GuiEvent = Normal
 {
  GuiControlGet, LBMenu
  StringReplace, LBMenuItem, LBMenu, %A_SPACE%,, All
  If (LBMenuItem = "Music" or LBMenuItem = "Collection")
  {
   SetText := SetStatus("Loading music collection")
   CurrentTab = Music
   OldLVHeight := LVHeight + 10
   GuiControl, Move, LVMedia, y78 h%OldLVHeight%
   GuiControl, Hide, TextCountry
   GuiControl, Hide, LBCountry
   GuiControl, Hide, TextGenre
   GuiControl, Hide, LBGenre
   Loop, 15 {
    LV_DeleteCol(1)
   }
   LV_InsertCol(1,"","Rating")
   LV_InsertCol(1,"","Length")
   LV_InsertCol(1,"","Genre")
   LV_InsertCol(1,"","Album")
   LV_InsertCol(1,"","Artist")
   LV_InsertCol(1,"","Title")
   LV_InsertCol(1,"","")
   Gosub, PrepareLVMedia
  }
  If (LBMenuItem = "TV")
  {
   SetText := SetStatus("Loading tv")
   CurrentTab = TV
   Loop, 15 {
    LV_DeleteCol(1)
   }
   LV_InsertCol(1,"","Time")
   LV_InsertCol(1,"","Description")
   LV_InsertCol(1,"","Size")
   LV_InsertCol(1,"","Genre")
   LV_InsertCol(1,"","Country")
   LV_InsertCol(1,100,"Name")
   LV_InsertCol(1,"","Id")
   NewLVHeight := LVHeight - 32
   GuiControl, Move, LVMedia, y+120 h%NewLVHeight%
   GuiControl, Show, TextCountry
   GuiControl, Show, LBCountry
   GuiControl, Show, TextGenre
   GuiControl, Show, LBGenre
   Gosub, PrepareLBCountry
   Gosub, PrepareLVTV
  }
 }
Return

ShowProperties:
 ControlGet, iteminfo, List, Focused, SysListView321, %GUIName%
 FoundPos := RegExMatch(iteminfo, "(\d+)", id)
 StringReplace, id, id1, %A_SPACE%,, All
 Prop_title := xpath(lib, "/xml/track[" . id . "]/title/text()")
 Prop_artist := xpath(lib, "/xml/track[" . id . "]/artist/text()")
 Prop_album := xpath(lib, "/xml/track[" . id . "]/album/text()")
 Prop_year := xpath(lib, "/xml/track[" . id . "]/year/text()")
 Prop_track := xpath(lib, "/xml/track[" . id . "]/track/text()")
 Prop_genre := xpath(lib, "/xml/track[" . id . "]/genre/text()")
 Prop_rating := xpath(lib, "/xml/track[" . id . "]/rating/text()")
 GuiControl,2:, GUI2_Title, %Prop_Title%
 GuiControl,2:, GUI2_Artist, %Prop_Artist%
 GuiControl,2:, GUI2_Album, %Prop_Album%
 GuiControl,2:, GUI2_Year, %Prop_Year%
 GuiControl,2:, GUI2_Track, %Prop_Track%
 GuiControl,2:, GUI2_Genre, %Prop_Genre%
 GuiControl,2: Choose, GUI2_Rating, %Prop_Rating%
 GuiControl,2:, GUI2_Id, %id%
 Gui 2: Show,, Properties
Return

;#######################################################
;##                  Track Functions                  ##
;#######################################################

AddTrack(title,artist,album="",year="",track="",genre="",comments="",src="output.mp3") {
 StringReplace, title, title, <, &#60;, All
 StringReplace, title, title, >, &#62;, All
 StringReplace, artist, artist, <, &#60;, All
 StringReplace, artist, artist, >, &#62;, All
 StringReplace, album, album, <, &#60;, All
 StringReplace, album, album, >, &#62;, All
 StringReplace, year, year, <, &#60;, All
 StringReplace, year, year, >, &#62;, All
 StringReplace, track, track, <, &#60;, All
 StringReplace, genre, genre, >, &#62;, All

 FileCopy, %src%, output.mp3
 totallength := Sound_Length("output.mp3")
 min := Floor(totallength / (1000 * 60))
 SetFormat, Float, 0.0
 lengthseconds := totallength/1000
 length := Tommss(totallength)
 FileDelete, output.mp3
 xpath_load(lib, "fusion_lib.xml")
 xpath(lib, "/xml/track[+1]")
 total := xpath(lib, "/xml/track/count()")
 id := xpath(lib, "/xml/track/id/count()")
 id++
 StringReplace, src, src, ",", `
 xpath(lib, "/xml/track[" . total . "]/id[+1]/text()", id )
 xpath(lib, "/xml/track[" . total . "]/title[+1]/text()", title)
 xpath(lib, "/xml/track[" . total . "]/artist[+1]/text()", artist)
 xpath(lib, "/xml/track[" . total . "]]/album[+1]/text()", album)
 xpath(lib, "/xml/track[" . total . "]/year[+1]/text()", year )
 xpath(lib, "/xml/track[" . total . "]/track[+1]/text()", track )
 xpath(lib, "/xml/track[" . total . "]/genre[+1]/text()", genre )
 xpath(lib, "/xml/track[" . total . "]/src[+1]/text()", src)
 xpath(lib, "/xml/track[" . total . "]/length[+1]/text()", length)
 xpath(lib, "/xml/track[" . total . "]/rating[+1]/text()", "")
 xpath_save(lib,"fusion_lib.xml")
 LV_Add("", id, title, artist,album,year,track,genre,length,"")
 Gosub, AdjustLVMedia
 Return
}

DeleteTracK:
 xpath_load(lib, "fusion_lib.xml")
 ControlGet, iteminfo, List, Focused, SysListView321, %GUIName%
 FoundPos := RegExMatch(iteminfo, "(\d+)", id)
 StringReplace, id, id1, %A_SPACE%,, All
 xpath(lib, "/xml/track[id=" . id . "]/remove()")
 xpath_save(lib,"fusion_lib.xml")
 LV_Delete()
 Gosub, PrepareLVMedia
 Gosub, AdjustLVMedia
 GuiControl, +Redraw, LVMedia
Return

GetTrackTags(FileToTag) {
 DetectHiddenWindows, On
 Filecopy, %FileToTag%, fus_currenttag.mp3
 RunWait, Cmd.exe /C Tag.exe fus_currenttag.mp3 --tofilen fus_tagoutput.txt,,hide
 FileRead, Output, fus_tagoutput.txt

 FileReadLine, title, fus_tagoutput.txt, 5
 RegExMatch(title, "Title:(.*)", Output)
 StringTrimLeft, track_title, Output1, 3

 FileReadLine, artist, fus_tagoutput.txt, 6
 RegExMatch(artist, "Artist:(.*)", Output)
 StringTrimLeft, track_artist, Output1, 2

 FileReadLine, album, fus_tagoutput.txt, 7
 RegExMatch(album, "Album:(.*)", Output)
 StringTrimLeft, track_album, Output1, 3

 FileReadLine, year, fus_tagoutput.txt, 8
 RegExMatch(year, "Year:(.*)", Output)
 StringTrimLeft, track_year, Output1, 4

 FileReadLine, track, fus_tagoutput.txt, 9
 RegExMatch(track, "Track:(.*)", Output)
 StringTrimLeft, track_track, Output1, 2

 FileReadLine, genre, fus_tagoutput.txt, 10
 RegExMatch(genre, "Genre:(.*)", Output)
 StringTrimLeft, track_genre, Output1, 3

 FileReadLine, comments, fus_tagoutput.txt, 11
 RegExMatch(comments, "Comment:(.*)", Output)
 StringTrimLeft, track_comments, Output1, 2

 FileDelete, fus_tagoutput.txt
 FileDelete, fus_currenttag.mp3

Return, track_title "`€`" . track_artist "`€`" . track_album "`€`" . track_year "`€`" . track_track "`€`" . track_genre "`€`" . track_comments
}

;#######################################################
;##                        Rate                       ##
;#######################################################

Rate1:
 xpath_load(lib, "fusion_lib.xml")
 ControlGet, iteminfo, List, Focused, SysListView321, %GUIName%
 FoundPos := RegExMatch(iteminfo, "(\d+)", id)
 StringReplace, id, id1, %A_SPACE%,, All
 xpath(lib, "/xml/track[" . id . "]/rating/text()", "1")
 xpath_save(lib,"fusion_lib.xml")
 Gosub, AdjustLVMedia
Return

Rate2:
 xpath_load(lib, "fusion_lib.xml")
 ControlGet, iteminfo, List, Focused, SysListView321, %GUIName%
 FoundPos := RegExMatch(iteminfo, "(\d+)", id)
 StringReplace, id, id1, %A_SPACE%,, All
 xpath(lib, "/xml/track[" . id . "]/rating/text()", "2")
 xpath_save(lib,"fusion_lib.xml")
 Gosub, AdjustLVMedia
Return

Rate3:
 xpath_load(lib, "fusion_lib.xml")
 ControlGet, iteminfo, List, Focused, SysListView321, %GUIName%
 FoundPos := RegExMatch(iteminfo, "(\d+)", id)
 StringReplace, id, id1, %A_SPACE%,, All
 xpath(lib, "/xml/track[" . id . "]/rating/text()", "3")
 xpath_save(lib,"fusion_lib.xml")
 Gosub, AdjustLVMedia
Return

Rate4:
 xpath_load(lib, "fusion_lib.xml")
 ControlGet, iteminfo, List, Focused, SysListView321, %GUIName%
 FoundPos := RegExMatch(iteminfo, "(\d+)", id)
 StringReplace, id, id1, %A_SPACE%,, All
 xpath(lib, "/xml/track[" . id . "]/rating/text()", "4")
 xpath_save(lib,"fusion_lib.xml")
 Gosub, AdjustLVMedia
Return

Rate5:
 xpath_load(lib, "fusion_lib.xml")
 ControlGet, iteminfo, List, Focused, SysListView321, %GUIName%
 FoundPos := RegExMatch(iteminfo, "(\d+)", id)
 StringReplace, id, id1, %A_SPACE%,, All
 xpath(lib, "/xml/track[" . id . "]/rating/text()", "5")
 xpath_save(lib,"fusion_lib.xml")
 Gosub, AdjustLVMedia
Return


;#######################################################
;##                       Convert                     ##
;#######################################################

Tommss(milli) {
 min  := Floor(milli / (1000 * 60))
 sec  := Floor(Floor(milli/1000) - (min * 60))
 If(sec<10) {
  sec := "0" . sec
 }
 Return min ":" sec
}

Tohhmmss(milli){
   min  := Floor(milli / (1000 * 60))
   hour := Floor(milli / (1000 * 3600))
   sec  := Floor(Floor(milli/1000) - (min * 60))
   Return hour ":" min ":" sec
}

;#######################################################
;##               Remaining Functions                 ##
;#######################################################

AC:
AutoComplete(A_GuiControl)
Return

AutoComplete(ctrl) {
   static lf = "`n"
   If GetKeyState("Delete") or GetKeyState("Backspace")
      Return
   SetControlDelay, -1
   SetWinDelay, -1
   GuiControlGet, h, Hwnd, %ctrl%
   ControlGet, haystack, List, , , ahk_id %h%
   GuiControlGet, needle, , %ctrl%
   StringMid, text, haystack, pos := InStr(lf . haystack, lf . needle)
      , InStr(haystack . lf, lf, false, pos) - pos
   If text !=
   {
      ControlSetText, , %text%, ahk_id %h%
      ControlSend, , % "{Right " . StrLen(needle) . "}+^{End}", ahk_id %h%
   }
}

ToggleCheckShuffle:
Menu, Music, ToggleCheck, Shuffle
Return

SetStatus(fText, fStyle="s9", fFont="Arial") {
 Gui, Font, %fStyle%, %fFont%
 width := GetTextSize(fText, fStyle "," fFont)
 halfwidth := width * 0.5
 screenloc := 0.5 * A_ScreenWidth - halfwidth
 GuiControl,, Status, %fText%
 GuiControl, Move, Status, x%screenloc% w%width%
Return
}

Test:
 Gui 3: Default
 Gui, Show, w500 h500
Return

AdjustLVMedia:
 Loop, 9 {
  LV_ModifyCol(A_Index,"AutoHdr")
 }
 LV_ModifyCol(9,"SortDesc")
Return

AdjustLVTV:
 Loop, 7 {
  LV_ModifyCol(A_Index,"AutoHdr")
 }
 LV_ModifyCol(2,"Sort")
Return

GuiOpen:
 IE_Init()
Return

GuiMove: ; This G-Label provides WinMove for the GUI with no titlebar
 PostMessage, 0xA1, 2,,, A
Return

GuiSize:
 Anchor("LVMedia","wh")
 Anchor("LBMenu","h")
Return

Exit:
 Exitapp

GuiClose:
 Gui 1: Default
 Gui, Destroy
 COM_Release(pwb)
 IE_Term()
 ExitApp
ExitApp

CloseProp:
 Winclose, Properties
Return

Blank:
Return

;#######################################################
;##                       MCI                         ##
;#######################################################

Sound_Open(File, Alias=""){
   IfNotExist, %File%
   {
      ErrorLevel = 2
      Return 0
   }
   If Alias =
   {
      Random, rand, 10, 10000000000000000000000000000000000000
      Alias = AutoHotkey%rand%
   }
   Loop, %File%
      File_Short = %A_LoopFileShortPath%
   r := Sound_SendString("open " File_Short " alias " Alias)
   If r
   {
      ErrorLevel = 1
      Return 0
   }Else{
      ErrorLevel = 0
      Return %Alias%
   }
}

Sound_Close(SoundHandle){
   r := Sound_SendString("close " SoundHandle)
   Return NOT r
}

Sound_Play(SoundHandle, Wait=0){
   If(Wait <> 0 AND Wait <> 1)
      Return 0
   If Wait
      r := Sound_SendString("play " SoundHandle " wait")
   Else
      r := Sound_SendString("play " SoundHandle)
   Return NOT r
}

Sound_Stop(SoundHandle){
   r := Sound_SendString("seek " SoundHandle " to start")
   r2 := Sound_SendString("stop " SoundHandle)
   If(r AND r2)
   {
      Return 0
   }Else{
      Return 1
   }
}

Sound_Pause(SoundHandle){
   r := Sound_SendString("pause " SoundHandle)
   Return NOT r
}

Sound_Resume(SoundHandle){
   r := Sound_SendString("resume " SoundHandle)
   Return NOT r
}

Sound_Length(SoundHandle){
   r := Sound_SendString("set time format miliseconds", 1)
   If r
      Return 0
   r := Sound_SendString("status " SoundHandle " length", 1, 1)
   Return %r%
}

Sound_Seek(SoundHandle, Hour, Min, Sec){
   milli := 0
   r := Sound_SendString("set time format milliseconds", 1)
   If r
      Return 0
   milli += Sec  * 1000
   milli += Min  * 1000 * 60
   milli += Hour * 1000 * 60 * 60
   r := Sound_SendString("seek " SoundHandle " to " milli)
   Return NOT r
}

Sound_Status(SoundHandle){
   Return Sound_SendString("status " SoundHandle " mode", 1, 1)
}

Sound_Pos(SoundHandle){
   r := Sound_SendString("set time format miliseconds", 1)
   If r
      Return 0
   r := Sound_SendString("status " SoundHandle " position", 1, 1)
   Return %r%
}

Sound_SeekSeconds(SoundHandle, Sec){
   r := Sound_SendString("seek " SoundHandle " to " Sec)
   Return NOT r
}

Sound_SetBass(SoundHandle){
   r := Sound_SendString("setaudio " SoundHandle " bass to 1000")
   Return
}

Sound_SendString(string, UseSend=0, ReturnTemp=0){
   If UseSend
   {
      VarSetCapacity(stat1, 32, 32)
      DllCall("winmm.dll\mciSendStringA", "UInt", &string, "UInt", &stat1, "Int", 32, "Int", 0)
   }Else{
      DllCall("winmm.dll\mciExecute", "str", string)
   }
   If(UseSend And ReturnTemp)
      Return stat1
   Else
      Return %ErrorLevel%
}

;#######################################################
;##                      Xpath                        ##
;#######################################################

/*
		Title: XPath Quick Reference
		
		License:
			- Version 3.12 by Titan <http://www.autohotkey.net/~Titan/#xpath>
			- GNU General Public License 3.0 or higher <http://www.gnu.org/licenses/gpl-3.0.txt>
*/

/*

		Function: xpath
			Selects nodes and attributes from a standard xpath expression.
		
		Parameters:
			doc - an xml object returned by xpath_load()
			step - a valid XPath 2.0 expression
			set - (optional) text content to replace the current selection
		
		Returns:
			The XML source of the selection.
			If the content was set to be modified the previous value will be returned.
		
		Remarks:
			Since multiple return values are seperated with a comma,
			any found within the text content will be entity escaped as &#44;.
			To get or set the text content of a node use the text function,
			e.g. /root/node/text(); this behaviour is always assumed within predicates.
			For performance reasons count() and last() do not update with the creation of new nodes
			so you may need to alter the results accordingly.

*/
xpath(ByRef doc, step, set = "") {
	static sc, scb = " " ; use EOT (\x04) as delimiter
	
	If step contains %scb% ; i.e. illegal character
		Return
	sid := scb . &doc . ":" ; should be unique identifier for current XML object
	If (InStr(step, "select:") == 1) { ; for quick selection
		stsl = 1
		StringTrimLeft, step, step, 7
	}
	If (InStr(step, "/") == 1)
		str = 1 ; root selected
	Else {
		StringGetPos, p, sc, %sid% ; retrieve previous path
		If ErrorLevel = 1
			t = /
		Else StringMid, t, sc, p += StrLen(sid) + 1, InStr(sc, scb, "", p + 2) - p
		step = %t%/%step%
	}
	
	; normalize path e.g. /root/node/../child/. becomes /root/child:
	step := RegExReplace(step, "(?<=^|/)(?:[^\[/@]+/\.{2}|\.)(?:/|$)|^.+(?=//)")
	
	If (str == 1 or stsl == 1) { ; if not relative path and no select:
		; remove last node and trailing attributes and functions:
		xpr := RegExReplace(step, (str == 1 and stsl != 1 ? "/(?:\w+:)?\w+(?:\[[^\]]*])?" : "")
			. "(?:/@.*?|/\w+\(\))*$")
		StringReplace, xpr, xpr, [-1], [1], All ; -1 become just 1
		StringReplace, xpr, xpr, [+1], [last()], All ; +1 becomes last()
		StringGetPos, p, sc, %sid%
		If ErrorLevel = 1
			sc = %sc%%sid%%xpr%%scb% ; add record or update as necessary:
		Else sc := SubStr(sc, 1, p += StrLen(sid)) . xpr . SubStr(sc, InStr(sc, scb, "", p))
	}
	
	NumPut(160, doc, 0, "UChar") ; unmask variable
	
	; for unions call each operand seperately and join results:
	If (InStr(step, "|")) {
		StringSplit, s, step, |, `n`t  `r
		Loop, %s0%
			res .= xpath(doc, s%A_Index%, set) . ","
		Return, SubStr(res, 1, -1)
	}
	Else If (InStr(step, "//") == 1) { ; for wildcard selectors use regex searching mode:
		StringTrimLeft, step, step, 2
		re = 1
		rew = 1
		xp = /(?:(?:\w+:)?\w+)*/
	}
	
	; resolve xpath components to: absolute node path, attributes and predicates (if any)
	Loop, Parse, step, /
	{
		s = %A_LoopField%
		If (InStr(s, "*") == 1) ; regex mode for wildcards
		{
			re = 1
			s := "(?:\w+:)?\w+" . SubStr(s, 2)
		}
		Else If (InStr(s, "@") == 1) { ; if current step is attribute:
			StringTrimLeft, atr, s, 1
			Continue
		}
		StringGetPos, p, s, [ ; look for predicate opening [...]
		If ErrorLevel = 0
		{
			If s contains [+1],[-1] ; for child nodes record creation instructions in a list
			{
				If A_Index = 2 ; root node creation
				{
					StringLeft, t, s, p
					t = <%t%/:: ></%t%/>
					If (InStr(s, "+1")) {
						If doc =
							doc = .
						doc = %doc%%t%
					}
					Else doc = .%t%%doc%
					StringLeft, s, s, InStr(s, "[") - 1
				}
				Else {
					nw = %nw%%s%
					Continue
				}
			}
			Else { ; i.e. for conditional predicates
				
				If (InStr(s, "last()")) { ; finding last node
					StringLeft, t, s, p
					t := "<" . SubStr(xp, 2) . t . "/:: "
					If re ; with regex:
					{
						os = 0
						Loop
							If (!os := RegExMatch(doc, t, "", 1 + os)) {
								t = %A_Index%
								Break
							}
						t--
					}
					Else { ; otherwise using StringReplace
						StringReplace, doc, doc, %t%, %t%, UseErrorLevel
						t = %ErrorLevel%
					}
					If (RegExMatch(s, "i)last\(\)\s*\-\s*(\d+)", a)) ; i.e. [last() - 2]
						StringReplace, s, s, %a%, % t - a1
					Else StringReplace, s, s, last(), %t%
				}
				
				; concat. the predicate to the list against the current absolute path:
				ax = %ax%%xp%%s%
				StringLeft, s, s, p
			}
		}
		Else If (InStr(s, "()")) { ; if step is function, add to list
			fn = %fn%+%s% ; use + prefix to prevent overlapping naming conflicts
			Continue
		}
		; finally, if step is not any of the above, assume it's the name of a child node
		xp = %xp%%s%/ ; ... and add to list, forming the absolute path
	}
	
	If (xp == "" or xp == "/") ; i.e. error cases
		Return
	
	; remove initial root selector (/) as this is how the parser works by default:
	StringTrimLeft, xp, xp, 1
	StringTrimRight, ax, ax, 1
	
	StringTrimRight, nw, nw, 1
	
	ct = 0 ; counter
	os = 0 ; offset for main loop starts at zero
	Loop {
		; find offset of next element, and its closing tag offset:
		If re
			os := RegExMatch(doc, "<" . xp . ":: ", "", 1 + os)
				, osx := RegExMatch(doc, "</" . xp . ">", rem, os) + StrLen(rem)
		Else {
			StringGetPos, osx, doc, </%xp%>, , os := InStr(doc, "<" . xp . ":: ", true, 1 + os)
			osx += 4 + StrLen(xp)
		}
		If os = 0 ; stop looping when no more tags are found
			Break
		
		; predicate parser:
		If ax !=
		{
			sk = 0
			Loop, Parse, ax, ] ; for each predicate
			{
				; split components to: (1) path, (2) selector, (3) operator, (4) quotation char, (5) operand
				If (!RegExMatch(A_LoopField, "/?(.*?)\[(.+?)(?:\s*([<>!=]{1,2})\s*(['""])?(.+)(?(4)\4))?\s*$", a))
					Continue
				a1 = %a1%/
				If re
					RegExMatch(rem, "(?<=^</)" . a1, a1)
				
				If a2 is integer ; i.e. match only certain index
				{
					StringGetPos, t, a1, /, R2
					StringMid, t, a1, 1, t + 1
					t := InStr(SubStr(doc, 1, os), "<" . t . ":: ", true, 0)
					; extract parent node:
					StringMid, sub, doc, t, InStr(doc, ">", "", os) - t
					xpf := "<" . a1 . ":: "
					; get index of current element within parent node:
					StringReplace, sub, sub, %xpf%, %xpf%, UseErrorLevel
					If a2 != %ErrorLevel%
						sk = 1
					Continue
				}
				
				StringReplace, xp, xp, /, /, UseErrorLevel
				t = %ErrorLevel%
				StringReplace, a1, a1, /, /, UseErrorLevel
				
				 ; extract result for deep analysis
				If t = %ErrorLevel% ; i.e. /root/node[child='test']
					StringMid, sub, doc, os, osx - os
				Else StringMid, sub, doc
					 	, t := InStr(SubStr(doc, 1, os), "<" . a1 . ":: ", true, 0)
					 	, InStr(doc, "</" . a1 . ">", true, t) + 1
				
				If a2 = position()
					sub = %i%
				Else If (InStr(a2, "@") == 1) ; when selector is an attribute:
				 RegExMatch(SubStr(sub, 1, InStr(sub, ">"))
						, a3 == "" ? "\b" . SubStr(a2, 2) . "=([""'])[^\1]*?\1"
						: "\b(?<=" . SubStr(a2, 2) . "=([""']))[^\1]+?(?=\1)", sub)
				Else ; otherwise child node:
				{
					If a2 = . ; if selector is current node don't append to path:
						a2 = /
					Else a2 = %a2%/
					StringMid, sub, sub
						, t := InStr(sub, ">", "", InStr(sub, "<" . a1 . a2 . ":: ", true) + 1) + 1
						, InStr(sub, "</" . a1 . a2 . ">", true) - t
				}
				
				; dynamic mini expression evaluator:
				sk += !(a3 == "" ? (sub != "")
					: a3 == "=" ? sub == a5
					: a3 == "!=" ? sub != a5
					: a3 == ">" ? sub > a5
					: a3 == ">=" ? sub >= a5
					: a3 == "<" ? sub < a5
					: a3 == "<=" ? sub <= a5)
			}
			If sk != 0 ; if conditions were not met for this result, skip it
				Continue
		}
		
		If nw != ; for node creation
		{
			If re
				nwp := SubStr(rem, 3, -1)
			Else nwp = %xp%
			Loop, Parse, nw, ]
			{
				StringLeft, nwn, A_LoopField, InStr(A_LoopField, "[") - 1
				nwn = %nwn%/
				nwt = <%nwp%%nwn%:: ></%nwp%%nwn%>
				If (t := InStr(A_LoopField, "-1")
					? InStr(doc, ">", "", InStr(doc, "<" . nwp . ":: ", true, os) + 1) + 1
					: InStr(doc, "</" . nwp . ">", true, os))
					os := t
				StringLen, osx, nwt
				osx += os
				doc := SubStr(doc, 1, os - 1) . nwt . SubStr(doc, os)
				nwp = %nwp%%nwn%
			}
			StringLen, t, nwp
			If (InStr(fn, "+text()") and atr == "")
				os += t + 5, osx -= t + 3
		}
		
		If atr !=
		{
			; extract attribute offsets, with surrounding declaration if text() is not used:
			If (t := RegExMatch(SubStr(doc, os, InStr(doc, ">", "", os) - os), InStr(fn, "+text()")
				? "(?<=\b" . atr . "=([""']))[^\1]*?(?=\1)"
				: "\b" . atr . "=([""'])[^\1]*?\1", rem))
				os += t - 1, osx := os + StrLen(rem)
			Else { ; create attribute
				os := InStr(doc, ">", "", os + 1)
					, doc := SubStr(doc, 1, os - 1) . " " . atr . "=""""" . SubStr(doc, os)
					, osx := ++os + StrLen(atr) + 3
				If (InStr(fn, "+text()"))
					osx := os += StrLen(atr) + 2
			}
		}
		Else If (InStr(fn, "+text()") and nw == "") ; for text content:
			os := InStr(doc, ">", "", os) + 1, osx := InStr(doc, re ? rem : "</" . xp . ">", true, os)
		
		If InStr(fn, "+index-of()") ; get index rather than content
			sub = %A_Index% 
		Else StringMid, sub, doc, os, osx - os ; extract result
		
		If (InStr(fn, "+count()")) ; increment counter if count() function is used
			ct++
		Else res = %res%%sub%, ; ... and concat to list
		
		If (set != "" or InStr(fn, "+remove()")) ; modify or remove...
			setb = %setb%%os%.%osx%| ; mark for modification
	}
	
	If setb !=
	{
		StringTrimRight, setb, setb, 1
		Loop, Parse, setb, |
		{
			StringSplit, setp, A_LoopField, .
			doc := SubStr(doc, 1, setp1 - 1) . set . SubStr(doc, setp2) ; dissect then insert new value
		}
	}
	
	If (InStr(fn, "+count()"))
		res = %ct%, ; trailing char since SubStr is used below
	
	nsid := scb . &doc . ":" ; update sid as necessary
	If nsid != %sid%
		StringReplace, sc, sc, %sid%, %nsid%
	
	NumPut(0, doc, 0, "UChar") ; remask variable to prevent external editing
	StringTrimRight, res, res, 1
	If (InStr(fn, "+rawsrc()")) {
		StringTrimLeft, t, xpr, 1
		StringReplace, res, res, <%t%/, <, All
		StringReplace, res, res, </%t%, <, All
		res =  %res%
		Return, res
	}
	; remove trailing comma and absolute paths from result before returning:
	Return, RegExReplace(res, "S)(?<=<)(\/)?(?:(\w+)\/)+(?(1)|:: )", "$1$2")
}

/*

		Function: xpath_save
			Saves an XML document to file or returns the source.
		
		Parameters:
			doc - an xml object returned by xpath_load()
			src - (optional) a path to a file where the XML document should be saved;
				if the file already exists it will be replaced
		
		Returns:
			False if there was an error in saving the document, true otherwise.
			If the src parameter is left blank the source code of the document is returned instead.

*/
xpath_save(ByRef doc, src = "") {
	xml := RegExReplace(SubStr(doc, 2), "S)(?<=<)(\/)?(?:(\w+)\/)+(?(1)|:: )", "$1$2") ; remove metadata
	xml := RegExReplace(xml, "<([\w:]+)([^>]*)><\/\1>", "<$1$2 />") ; fuse empty nodes
	;xml := RegExReplace(xml, " (?=(?:\w+:)?\w+=['""])") ; remove prepending whitespace on attributes
	xml := RegExReplace(xml, "^\s+|\s+$") ; remove start and leading whitespace
	If InStr(xml, "<?xml") != 1 ; add processor instruction if there isn't any:
		xml = <?xml version="1.0" encoding="iso-8859-1"?>`n%xml%
	StringReplace, xml, xml, `r, , All ; normalize linefeeds:
	StringReplace, xml, xml, `n, `r`n, All
	sp := "  "
	StringLen, sl, sp
	s =
	VarSetCapacity(sxml, StrLen(xml) * 1.1)
	Loop, Parse, xml, <, `n`t 	 `r
	{
		If A_LoopField =
			Continue
		If (sb := InStr(A_LoopField, "/") == 1)
			StringTrimRight, s, s, sl
		sxml = %sxml%`n%s%<%A_LoopField%
		If sb
			StringTrimRight, s, s, sl
		If (InStr(A_LoopField, "?") != 1 and InStr(A_LoopField, "!") != 1
			and !InStr(A_LoopField, "/>"))
			s .= sp
	}
	StringTrimLeft, sxml, sxml, 1
	sxml := RegExReplace(sxml, "(\n(?:" . sp . ")*<((?:\w+:)?\w+\b)[^<]+?)\n(?:"
		. sp . ")*</\2>", "$1</$2>")
	If src = ; if save path not specified return the XML document:
		Return, sxml
	FileDelete, %src% ; delete existing file
	FileAppend, %sxml%, %src% ; create new one
	Return, ErrorLevel ; return errors, if any
}

/*

		Function: xpath_load
			Loads an XML document.
		
		Parameters:
			doc - a reference to the loaded XML file as a variable, to be used in other functions
			src - (optional) the document to load, this can be a file name or a string,
				if omitted the first paramter is used as the source
		
		Returns:
			False if there was an error in loading the document, true otherwise.

*/
xpath_load(ByRef doc, src = "") {
	If src = ; if source is empty assume the out variable is the one to be loaded
		src = %doc%
	Else If FileExist(src) ; otherwise read from file (if it exists)
		FileRead, src, %src%
	If src not contains <,>
		Return, false
	; combined expressions slightly improve performance:
	src := RegExReplace(src, "<((?:\w+:)?\w+\b)([^>]*)\/\s*>", "<$1$2></$1>") ; defuse nodes
		, VarSetCapacity(doc, VarSetCapacity(xml, StrLen(src) * 1.5) * 1.1) ; pre-allocate enough space
	Loop, Parse, src, < ; for each opening tag:
	{
		If (A_Index == 2 and InStr(A_LoopField, "?xml") == 1)
			Continue
		Else If (InStr(A_LoopField, "?") == 1) ; ignore all other processor instructions
			xml = %xml%<%A_LoopField%
		Else If (InStr(A_LoopField, "![CDATA[") == 1) { ; escape entities in CDATA sections
			cdata := SubStr(A_LoopField, 9, -3)
			StringReplace, cdata, cdata, ", &quot;, All
			StringReplace, cdata, cdata, &, &amp;, All
			StringReplace, cdata, cdata, ', &apos;, All
			StringReplace, cdata, cdata, <, &lt;, All
			StringReplace, cdata, cdata, >, &gt;, All
			xml = %xml%%cdata% 
		}
		Else If (!pos := RegExMatch(A_LoopField, "^\/?(?:\w+:)?\w+", tag)) ; if this isn't a valid tag:
		{
			If A_LoopField is not space
				xml = %xml%&lt;%A_LoopField% ; convert to escaped entity value
		}
		Else {
			StringMid, ex, A_LoopField, pos + StrLen(tag) ; get tag name
			If InStr(tag, "/") = 1 { ; if this is a closing tag:
				xml = %xml%</%pre%%ex% ; close tag
				StringGetPos, pos, pre, /, R2
				StringLeft, pre, pre, pos + 1
			}
			Else {
				pre = %pre%%tag%/
				xml = %xml%<%pre%:: %ex%
			}
		}
	}
	StringReplace, doc, xml, `,, &#44;, All ; entity escape commas (which are used as array delimiters)
	NumPut(0, doc := " " . doc, 0, "UChar") ; mask variable from text display with nullbyte
	Return, true ; assume sucessful load by this point
}


;#######################################################
;##                       LVX                         ##
;#######################################################

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
		Gui, Add, Edit, Hwndh ve Hide r1
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

;#######################################################
;##                        IE                         ##
;#######################################################

IE_Init()
{
	COM_AtlAxWinInit()
}

IE_Term()
{
	COM_AtlAxWinTerm()
}

IE_Add(hWnd, x, y, w, h)
{
	Return	COM_AtlAxGetControl(COM_AtlAxCreateContainer(hWnd, x, y, w, h, "Shell.Explorer"))
}

IE_Move(pwb, l, t, w, h)
{
	WinMove, % "ahk_id " . COM_AtlAxGetContainer(pwb), , l, t, w, h
}

IE_LoadURL(pwb, u)
{
	pUrl := COM_SysAllocString(u)
	VarSetCapacity(var, 8 * 2, 0)
	DllCall(NumGet(NumGet(1*pwb)+44), "Uint", pwb, "Uint", pUrl, "Uint", &var, "Uint", &var, "Uint", &var, "Uint", &var)
	COM_SysFreeString(pUrl)
}

IE_LoadHTML(pwb, h)
{
	pUrl := COM_SysAllocString("about:" . h)
	VarSetCapacity(var, 8 * 2, 0)
	DllCall(NumGet(NumGet(1*pwb)+44), "Uint", pwb, "Uint", pUrl, "Uint", &var, "Uint", &var, "Uint", &var, "Uint", &var)
	COM_SysFreeString(pUrl)
}

IE_GoBack(pwb)
{
	DllCall(NumGet(NumGet(1*pwb)+28), "Uint", pwb)
}

IE_GoForward(pwb)
{
	DllCall(NumGet(NumGet(1*pwb)+32), "Uint", pwb)
}

IE_GoHome(pwb)
{
	DllCall(NumGet(NumGet(1*pwb)+36), "Uint", pwb)
}

IE_GoSearch(pwb)
{
	DllCall(NumGet(NumGet(1*pwb)+40), "Uint", pwb)
}

IE_Refresh(pwb)
{
	DllCall(NumGet(NumGet(1*pwb)+48), "Uint", pwb)
}

IE_Stop(pwb)
{
	DllCall(NumGet(NumGet(1*pwb)+56), "Uint", pwb)
}

IE_Document(pwb)
{
	DllCall(NumGet(NumGet(1*pwb)+72), "Uint", pwb, "UintP", pdoc)
	Return	pdoc
}

IE_GetTitle(pwb)
{
	DllCall(NumGet(NumGet(1*pwb)+116), "Uint", pwb, "UintP", pTitle)
	COM_Unicode2Ansi(pTitle, sTitle)
	COM_SysFreeString(pTitle)
	Return	sTitle
}

IE_GetUrl(pwb)
{
	DllCall(NumGet(NumGet(1*pwb)+120), "Uint", pwb, "UintP", pUrl)
	COM_Unicode2Ansi(pUrl, sUrl)
	COM_SysFreeString(pUrl)
	Return	sUrl
}

IE_Busy(pwb)
{
	DllCall(NumGet(NumGet(1*pwb)+124), "Uint", pwb, "shortP", bBusy)
	Return	-bBusy
}

IE_Quit(pwb)				; iexplore.exe only
{
	DllCall(NumGet(NumGet(1*pwb)+128), "Uint", pwb)
}

IE_hWnd(pwb)				; iexplore.exe only
{
	DllCall(NumGet(NumGet(1*pwb)+148), "Uint", pwb, "UintP", hIE)
	Return	hIE
}

IE_FullName(pwb)			; iexplore.exe only
{
	DllCall(NumGet(NumGet(1*pwb)+152), "Uint", pwb, "UintP", pFile)
	COM_Unicode2Ansi(pFile, sFile)
	COM_SysFreeString(pFile)
	Return	sFile
}

IE_GetStatusText(pwb)			; iexplore.exe only
{
	DllCall(NumGet(NumGet(1*pwb)+176), "Uint", pwb, "UintP", pText)
	COM_Unicode2Ansi(pText, sText)
	COM_SysFreeString(pText)
	Return	sText
}

IE_SetStatusText(pwb, sText = "")	; iexplore.exe only
{
	pText := COM_SysAllocString(sText)
	DllCall(NumGet(NumGet(1*pwb)+180), "Uint", pwb, "Uint", pText)
	COM_SysFreeString(pText)
}

IE_ReadyState(pwb)
{
/*
	READYSTATE_UNINITIALIZED = 0      ; Default initialization state.
	READYSTATE_LOADING       = 1      ; Object is currently loading its properties.
	READYSTATE_LOADED        = 2      ; Object has been initialized.
	READYSTATE_INTERACTIVE   = 3      ; Object is interactive, but not all of its data is available.
	READYSTATE_COMPLETE      = 4      ; Object has received all of its data.
*/
	DllCall(NumGet(NumGet(1*pwb)+224), "Uint", pwb, "intP", nReady)
	Return	nReady
}

IE_Open(pwb)
{
	DllCall(NumGet(NumGet(1*pwb)+216), "Uint", pwb, "Uint", 1, "Uint", 0, "Uint", 0, "Uint", 0)
}

IE_New(pwb)
{
	DllCall(NumGet(NumGet(1*pwb)+216), "Uint", pwb, "Uint", 2, "Uint", 0, "Uint", 0, "Uint", 0)
}

IE_Save(pwb)
{
	DllCall(NumGet(NumGet(1*pwb)+216), "Uint", pwb, "Uint", 3, "Uint", 0, "Uint", 0, "Uint", 0)
}

IE_SaveAs(pwb)
{
	DllCall(NumGet(NumGet(1*pwb)+216), "Uint", pwb, "Uint", 4, "Uint", 0, "Uint", 0, "Uint", 0)
}

IE_Print(pwb)
{
	DllCall(NumGet(NumGet(1*pwb)+216), "Uint", pwb, "Uint", 6, "Uint", 0, "Uint", 0, "Uint", 0)
}

IE_PrintPreview(pwb)
{
	DllCall(NumGet(NumGet(1*pwb)+216), "Uint", pwb, "Uint", 7, "Uint", 0, "Uint", 0, "Uint", 0)
}

IE_PageSetup(pwb)
{
	DllCall(NumGet(NumGet(1*pwb)+216), "Uint", pwb, "Uint", 8, "Uint", 0, "Uint", 0, "Uint", 0)
}

IE_Properties(pwb)
{
	DllCall(NumGet(NumGet(1*pwb)+216), "Uint", pwb, "Uint", 10, "Uint", 0, "Uint", 0, "Uint", 0)
}

IE_Cut(pwb)
{
	DllCall(NumGet(NumGet(1*pwb)+216), "Uint", pwb, "Uint", 11, "Uint", 0, "Uint", 0, "Uint", 0)
}

IE_Copy(pwb)
{
	DllCall(NumGet(NumGet(1*pwb)+216), "Uint", pwb, "Uint", 12, "Uint", 0, "Uint", 0, "Uint", 0)
}

IE_Paste(pwb)
{
	DllCall(NumGet(NumGet(1*pwb)+216), "Uint", pwb, "Uint", 13, "Uint", 0, "Uint", 0, "Uint", 0)
}

IE_SelectAll(pwb)
{
	DllCall(NumGet(NumGet(1*pwb)+216), "Uint", pwb, "Uint", 17, "Uint", 0, "Uint", 0, "Uint", 0)
}

IE_Find(pwb)
{
	DllCall(NumGet(NumGet(1*pwb)+216), "Uint", pwb, "Uint", 32, "Uint", 0, "Uint", 0, "Uint", 0)
}

IE_DoFontSize(pwb, s)
{
/*
	s = 4	; Largest
	s = 3	; Larger
	s = 2	; Medium
	s = 1	; Smaller
	s = 0	; Smallest
*/
	VarSetCapacity(var, 8 * 2, 0)
	NumPut(3, var, 0)
	NumPut(s, var, 8)
	DllCall(NumGet(NumGet(1*pwb)+216), "Uint", pwb, "Uint", 19, "Uint", 2, "Uint", &var, "Uint", &var)
}

IE_InternetOptions(pwb)
{
	CGID_MSHTML(pwb, 2135)
}

IE_ViewSource(pwb)
{
	CGID_MSHTML(pwb, 2139)
}

IE_AddToFavorites(pwb)
{
	CGID_MSHTML(pwb, 2261)
}

IE_MakeDesktopShortcut(pwb)
{
	CGID_MSHTML(pwb, 2266)
}

IE_SendEMail(pwb)
{
	CGID_MSHTML(pwb, 2288)
}

CGID_MSHTML(pwb, nCmd, nOpt = 0)
{
	pct := COM_QueryInterface(pwb, IID_IOleCommandTarget:="{B722BCCB-4E68-101B-A2BC-00AA00404770}")
	DllCall(NumGet(NumGet(1*pct)+16), "Uint", pct, "Uint", COM_GUID4String(CGID_MSHTML,"{DE4BA900-59CA-11CF-9592-444553540000}"), "Uint", nCmd, "Uint", nOpt, "Uint", 0, "Uint", 0)
	COM_Release(pct)
}

;#######################################################
;##                       COM                         ##
;#######################################################

COM_Init(bOLE = False)
{
	Return	bOLE ? COM_OleInitialize() : COM_CoInitialize()
}

COM_Term(bOLE = False)
{
	Return	bOLE ? COM_OleUninitialize() : COM_CoUninitialize()
}

COM_VTable(ppv, idx)
{
	Return	NumGet(NumGet(1*ppv)+4*idx)
}

COM_QueryInterface(ppv, IID)
{
	DllCall(NumGet(NumGet(1*ppv)), "Uint", ppv, "Uint", COM_GUID4String(IID,IID), "UintP", ppv)
	Return	ppv
}

COM_AddRef(ppv)
{
	Return	DllCall(NumGet(NumGet(1*ppv)+4), "Uint", ppv)
}

COM_Release(ppv)
{
	Return	DllCall(NumGet(NumGet(1*ppv)+8), "Uint", ppv)
}

COM_QueryService(ppv, SID, IID = "")
{
	DllCall(NumGet(NumGet(1*ppv)+4*0), "Uint", ppv, "Uint", COM_GUID4String(IID_IServiceProvider,"{6D5140C1-7436-11CE-8034-00AA006009FA}"), "UintP", psp)
	DllCall(NumGet(NumGet(1*psp)+4*3), "Uint", psp, "Uint", COM_GUID4String(SID,SID), "Uint", IID ? COM_GUID4String(IID,IID) : &SID, "UintP", ppv)
	DllCall(NumGet(NumGet(1*psp)+4*2), "Uint", psp)
	Return	ppv
}

COM_FindConnectionPoint(pdp, DIID)
{
	DllCall(NumGet(NumGet(1*pdp)+ 0), "Uint", pdp, "Uint", COM_GUID4String(IID_IConnectionPointContainer, "{B196B284-BAB4-101A-B69C-00AA00341D07}"), "UintP", pcc)
	DllCall(NumGet(NumGet(1*pcc)+16), "Uint", pcc, "Uint", COM_GUID4String(DIID,DIID), "UintP", pcp)
	DllCall(NumGet(NumGet(1*pcc)+ 8), "Uint", pcc)
	Return	pcp
}

COM_GetConnectionInterface(pcp)
{
	VarSetCapacity(DIID, 16, 0)
	DllCall(NumGet(NumGet(1*pcp)+12), "Uint", pcp, "Uint", &DIID)
	Return	COM_String4GUID(&DIID)
}

COM_Advise(pcp, psink)
{
	DllCall(NumGet(NumGet(1*pcp)+20), "Uint", pcp, "Uint", psink, "UintP", nCookie)
	Return	nCookie
}

COM_Unadvise(pcp, nCookie)
{
	Return	DllCall(NumGet(NumGet(1*pcp)+24), "Uint", pcp, "Uint", nCookie)
}

COM_Enumerate(penum, ByRef Result)
{
	VarSetCapacity(varResult,16,0)
	If (0 =	_hResult_:=DllCall(NumGet(NumGet(1*penum)+12), "Uint", penum, "Uint", 1, "Uint", &varResult, "UintP", 0))
		Result:=(vt:=NumGet(varResult,0,"Ushort"))=8||vt<0x1000&&DllCall("oleaut32\VariantChangeTypeEx","Uint",&varResult,"Uint",&varResult,"Uint",LCID,"Ushort",1,"Ushort",8)=0 ? COM_Ansi4Unicode(bstr:=NumGet(varResult,8)) . SubStr(COM_SysFreeString(bstr),1,0) : NumGet(varResult,8)
	Return	_hResult_
}

COM_Invoke(pdisp, sName, arg1="vT_NoNe",arg2="vT_NoNe",arg3="vT_NoNe",arg4="vT_NoNe",arg5="vT_NoNe",arg6="vT_NoNe",arg7="vT_NoNe",arg8="vT_NoNe",arg9="vT_NoNe")
{
	Global	_hResult_
	nParams:=0
	Loop,	9
		If	(arg%A_Index% == "vT_NoNe")
			Break
		Else	++nParams
	VarSetCapacity(DispParams,16,0), VarSetCapacity(varResult,16,0), VarSetCapacity(IID_NULL,16,0), VarSetCapacity(varg,nParams*16,0)
		NumPut(&varg,DispParams,0), NumPut(nParams,DispParams,8)
	If	(nFlags := SubStr(sName,0) <> "=" ? 3 : 12) = 12
		NumPut(&varResult,DispParams,4), NumPut(1,DispParams,12), NumPut(-3,varResult), sName:=SubStr(sName,1,-1)
	Loop, %	nParams
		If	arg%A_Index% Is Not Integer
         		NumPut(8,varg,(nParams-A_Index)*16,"Ushort"), NumPut(COM_SysAllocString(arg%A_Index%),varg,(nParams-A_Index)*16+8)
		Else	NumPut(SubStr(arg%A_Index%,1,1)="+" ? 9 : 3,varg,(nParams-A_Index)*16,"Ushort"), NumPut(arg%A_Index%,varg,(nParams-A_Index)*16+8)
	If (0 =	_hResult_:=DllCall(NumGet(NumGet(1*pdisp)+20), "Uint", pdisp, "Uint", &IID_NULL, "UintP", COM_Unicode4Ansi(wName, sName), "Uint", 1, "Uint", LCID, "intP", dispID))
	&& (0 =	_hResult_:=DllCall(NumGet(NumGet(1*pdisp)+24), "Uint", pdisp, "int", dispID, "Uint", &IID_NULL, "Uint", LCID, "Ushort", nFlags, "Uint", &dispParams, "Uint", &varResult, "Uint", 0, "Uint", 0))
	&& (3 =	nFlags)
		Result:=(vt:=NumGet(varResult,0,"Ushort"))=8||vt<0x1000&&DllCall("oleaut32\VariantChangeTypeEx","Uint",&varResult,"Uint",&varResult,"Uint",LCID,"Ushort",1,"Ushort",8)=0 ? COM_Ansi4Unicode(bstr:=NumGet(varResult,8)) . SubStr(COM_SysFreeString(bstr),1,0) : NumGet(varResult,8)
	Loop, %	nParams
		NumGet(varg,(A_Index-1)*16,"Ushort")=8 ? COM_SysFreeString(NumGet(varg,(A_Index-1)*16+8)) : ""
	Return	Result
}

COM_Invoke_(pdisp, sName, type1="",arg1="",type2="",arg2="",type3="",arg3="",type4="",arg4="",type5="",arg5="",type6="",arg6="",type7="",arg7="",type8="",arg8="",type9="",arg9="")
{
	Global	_hResult_
	nParams:=0
	Loop,	9
		If	(type%A_Index% = "")
			Break
		Else	++nParams
	VarSetCapacity(dispParams,16,0), VarSetCapacity(varResult,16,0), VarSetCapacity(IID_NULL,16,0), VarSetCapacity(varg,nParams*16,0)
		NumPut(&varg,dispParams,0), NumPut(nParams,dispParams,8)
	If	(nFlags := SubStr(sName,0) <> "=" ? 1|2 : 4|8) & 12
		NumPut(&varResult,dispParams,4), NumPut(1,dispParams,12), NumPut(-3,varResult), sName:=SubStr(sName,1,-1)
	Loop, %	nParams
		NumPut(type%A_Index%,varg,(nParams-A_Index)*16,"Ushort"), type%A_Index%&0x4000=0 ? NumPut(type%A_Index%=8 ? COM_SysAllocString(arg%A_Index%) : arg%A_Index%,varg,(nParams-A_Index)*16+8,type%A_Index%=5||type%A_Index%=7 ? "double" : type%A_Index%=4 ? "float" : "int64") : type%A_Index%=0x400C||type%A_Index%=0x400E ? NumPut(arg%A_Index%,varg,(nParams-A_Index)*16+8) : VarSetCapacity(ref%A_Index%,8,0) . NumPut(&ref%A_Index%,varg,(nParams-A_Index)*16+8) . NumPut(type%A_Index%=0x4008 ? COM_SysAllocString(arg%A_Index%) : arg%A_Index%,ref%A_Index%,0,type%A_Index%=0x4005||type%A_Index%=0x4007 ? "double" : type%A_Index%=0x4004 ? "float" : "int64")
	If (0 =	_hResult_:=DllCall(NumGet(NumGet(1*pdisp)+20), "Uint", pdisp, "Uint", &IID_NULL, "UintP", COM_Unicode4Ansi(wName, sName), "Uint", 1, "Uint", LCID, "intP", dispID))
	&& (0 =	_hResult_:=DllCall(NumGet(NumGet(1*pdisp)+24), "Uint", pdisp, "int", dispID, "Uint", &IID_NULL, "Uint", LCID, "Ushort", nFlags, "Uint", &dispParams, "Uint", &varResult, "Uint", 0, "Uint", 0))
	&& (3 =	nFlags)
		Result:=(vt:=NumGet(varResult,0,"Ushort"))=8||vt<0x1000&&DllCall("oleaut32\VariantChangeTypeEx","Uint",&varResult,"Uint",&varResult,"Uint",LCID,"Ushort",1,"Ushort",8)=0 ? COM_Ansi4Unicode(bstr:=NumGet(varResult,8)) . SubStr(COM_SysFreeString(bstr),1,0) : NumGet(varResult,8)
	Loop, %	nParams
		type%A_Index%&0x4000=0 ? (type%A_Index%=8 ? COM_SysFreeString(NumGet(varg,(nParams-A_Index)*16+8)) : "") : type%A_Index%=0x400C||type%A_Index%=0x400E ? "" : type%A_Index%=0x4008 ? (_TEMP_VT_BYREF_%A_Index%:=COM_Ansi4Unicode(NumGet(ref%A_Index%))) . COM_SysFreeString(NumGet(ref%A_Index%)) : (_TEMP_VT_BYREF_%A_Index%:=NumGet(ref%A_Index%,0,type%A_Index%=0x4005||type%A_Index%=0x4007 ? "double" : type%A_Index%=0x4004 ? "float" : "int64"))
	Return	Result
}

COM_DispInterface(this, prm1="", prm2="", prm3="", prm4="", prm5="", prm6="", prm7="", prm8="")
{
	Critical
	If	A_EventInfo = 6
		DllCall(NumGet(NumGet(NumGet(this+8))+28),"Uint",NumGet(this+8),"Uint",prm1,"UintP",pname,"Uint",1,"UintP",0), VarSetCapacity(sfn,63), DllCall("user32\wsprintfA","str",sfn,"str","%s%S","Uint",this+40,"Uint",pname,"Cdecl"), COM_SysFreeString(pname), (pfn:=RegisterCallback(sfn,"C F")) ? (hResult:=DllCall(pfn, "Uint", prm5, "Uint", this, "Cdecl")) . DllCall("kernel32\GlobalFree", "Uint", pfn) : (hResult:=0x80020003)
	Else If	A_EventInfo = 5
		hResult:=DllCall(NumGet(NumGet(NumGet(this+8))+40),"Uint",NumGet(this+8),"Uint",prm2,"Uint",prm3,"Uint",prm5)
	Else If	A_EventInfo = 4
		NumPut(0,prm3+0), hResult:=0x80004001
	Else If	A_EventInfo = 3
		NumPut(0,prm1+0), hResult:=0
	Else If	A_EventInfo = 2
		NumPut(hResult:=NumGet(this+4)-1,this+4), hResult ? "" : COM_Unadvise(NumGet(this+16),NumGet(this+20)) . COM_Release(NumGet(this+16)) . COM_Release(NumGet(this+8)) . COM_CoTaskMemFree(this)
	Else If	A_EventInfo = 1
		NumPut(hResult:=NumGet(this+4)+1,this+4)
	Else If	A_EventInfo = 0
		COM_IsEqualGUID(this+24,prm1)||InStr("{00020400-0000-0000-C000-000000000046}{00000000-0000-0000-C000-000000000046}",COM_String4GUID(prm1)) ? NumPut(this,prm2+0) . NumPut(NumGet(this+4)+1,this+4) . (hResult:=0) : NumPut(0,prm2+0) . (hResult:=0x80004002)
	Return	hResult
}

COM_DispGetParam(pDispParams, Position = 0, vtType = 8)
{
	VarSetCapacity(varResult,16,0)
	DllCall("oleaut32\DispGetParam", "Uint", pDispParams, "Uint", Position, "Ushort", vtType, "Uint", &varResult, "UintP", nArgErr)
	Return	NumGet(varResult,0,"Ushort")=8 ? COM_Ansi4Unicode(NumGet(varResult,8)) . SubStr(COM_SysFreeString(NumGet(varResult,8)),1,0) : NumGet(varResult,8)
}

COM_CreateIDispatch()
{
	Static	IDispatch
	If Not	VarSetCapacity(IDispatch)
	{
		VarSetCapacity(IDispatch,28,0),   nParams=3112469
		Loop,   Parse,   nParams
		NumPut(RegisterCallback("COM_DispInterface","",A_LoopField,A_Index-1),IDispatch,4*(A_Index-1))
	}
	Return &IDispatch
}

COM_GetDefaultInterface(pdisp, LCID = 0)
{
	DllCall(NumGet(NumGet(1*pdisp) +12), "Uint", pdisp , "UintP", ctinf)
	If	ctinf
	{
	DllCall(NumGet(NumGet(1*pdisp)+16), "Uint", pdisp, "Uint" , 0, "Uint", LCID, "UintP", ptinf)
	DllCall(NumGet(NumGet(1*ptinf)+12), "Uint", ptinf, "UintP", pattr)
	DllCall(NumGet(NumGet(1*pdisp)+ 0), "Uint", pdisp, "Uint" , pattr, "UintP", ppv)
	DllCall(NumGet(NumGet(1*ptinf)+76), "Uint", ptinf, "Uint" , pattr)
	DllCall(NumGet(NumGet(1*ptinf)+ 8), "Uint", ptinf)
	If	ppv
	DllCall(NumGet(NumGet(1*pdisp)+ 8), "Uint", pdisp),	pdisp := ppv
	}
	Return	pdisp
}

COM_GetDefaultEvents(pdisp, LCID = 0)
{
	DllCall(NumGet(NumGet(1*pdisp)+16), "Uint", pdisp, "Uint" , 0, "Uint", LCID, "UintP", ptinf)
	DllCall(NumGet(NumGet(1*ptinf)+12), "Uint", ptinf, "UintP", pattr)
	VarSetCapacity(IID,16), DllCall("RtlMoveMemory", "Uint", &IID, "Uint", pattr, "Uint", 16)
	DllCall(NumGet(NumGet(1*ptinf)+76), "Uint", ptinf, "Uint" , pattr)
	DllCall(NumGet(NumGet(1*ptinf)+72), "Uint", ptinf, "UintP", ptlib, "UintP", idx)
	DllCall(NumGet(NumGet(1*ptinf)+ 8), "Uint", ptinf)
	Loop, %	DllCall(NumGet(NumGet(1*ptlib)+12), "Uint", ptlib)
	{
		DllCall(NumGet(NumGet(1*ptlib)+20), "Uint", ptlib, "Uint", A_Index-1, "UintP", TKind)
		If	TKind <> 5
			Continue
		DllCall(NumGet(NumGet(1*ptlib)+16), "Uint", ptlib, "Uint", A_Index-1, "UintP", ptinf)
		DllCall(NumGet(NumGet(1*ptinf)+12), "Uint", ptinf, "UintP", pattr)
		nCount:=NumGet(pattr+48,0,"Ushort")
		DllCall(NumGet(NumGet(1*ptinf)+76), "Uint", ptinf, "Uint" , pattr)
		Loop, %	nCount
		{
			DllCall(NumGet(NumGet(1*ptinf)+36), "Uint", ptinf, "Uint", A_Index-1, "UintP", nFlags)
			If	!(nFlags & 1)
				Continue
			DllCall(NumGet(NumGet(1*ptinf)+32), "Uint", ptinf, "Uint", A_Index-1, "UintP", hRefType)
			DllCall(NumGet(NumGet(1*ptinf)+56), "Uint", ptinf, "Uint", hRefType , "UintP", prinf)
			DllCall(NumGet(NumGet(1*prinf)+12), "Uint", prinf, "UintP", pattr)
			nFlags & 2 ? DIID:=COM_String4GUID(pattr) : bFind:=COM_IsEqualGUID(pattr,&IID)
			DllCall(NumGet(NumGet(1*prinf)+76), "Uint", prinf, "Uint" , pattr)
			DllCall(NumGet(NumGet(1*prinf)+ 8), "Uint", prinf)
		}
		DllCall(NumGet(NumGet(1*ptinf)+ 8), "Uint", ptinf)
		If	bFind
			Break
	}
	DllCall(NumGet(NumGet(1*ptlib)+ 8), "Uint", ptlib)
	Return	bFind ? DIID : "{00000000-0000-0000-0000-000000000000}"
}

COM_GetGuidOfName(pdisp, Name, LCID = 0)
{
	DllCall(NumGet(NumGet(1*pdisp)+16), "Uint", pdisp, "Uint", 0, "Uint", LCID, "UintP", ptinf)
	DllCall(NumGet(NumGet(1*ptinf)+72), "Uint", ptinf, "UintP", ptlib, "UintP", idx)
	DllCall(NumGet(NumGet(1*ptinf)+ 8), "Uint", ptinf), ptinf:=0
	DllCall(NumGet(NumGet(1*ptlib)+44), "Uint", ptlib, "Uint", COM_Unicode4Ansi(Name,Name), "Uint", 0, "UintP", ptinf, "UintP", memID, "UshortP", 1)
	DllCall(NumGet(NumGet(1*ptlib)+ 8), "Uint", ptlib)
	DllCall(NumGet(NumGet(1*ptinf)+12), "Uint", ptinf, "UintP", pattr)
	GUID := COM_String4GUID(pattr)
	DllCall(NumGet(NumGet(1*ptinf)+76), "Uint", ptinf, "Uint" , pattr)
	DllCall(NumGet(NumGet(1*ptinf)+ 8), "Uint", ptinf)
	Return	GUID
}

COM_GetTypeInfoOfGuid(pdisp, GUID, LCID = 0)
{
	DllCall(NumGet(NumGet(1*pdisp)+16), "Uint", pdisp, "Uint", 0, "Uint", LCID, "UintP", ptinf)
	DllCall(NumGet(NumGet(1*ptinf)+72), "Uint", ptinf, "UintP", ptlib, "UintP", idx)
	DllCall(NumGet(NumGet(1*ptinf)+ 8), "Uint", ptinf), ptinf := 0
	DllCall(NumGet(NumGet(1*ptlib)+24), "Uint", ptlib, "Uint", COM_GUID4String(GUID,GUID), "UintP", ptinf)
	DllCall(NumGet(NumGet(1*ptlib)+ 8), "Uint", ptlib)
	Return	ptinf
}

; A Function Name including Prefix is limited to 63 bytes!
COM_ConnectObject(psource, prefix = "", DIID = "{00020400-0000-0000-C000-000000000046}")
{
	If	(DIID = "{00020400-0000-0000-C000-000000000046}")
		0+(pconn:=COM_FindConnectionPoint(psource,DIID)) ? (DIID:=COM_GetConnectionInterface(pconn))="{00020400-0000-0000-C000-000000000046}" ? DIID:=COM_GetDefaultEvents(psource) : "" : pconn:=COM_FindConnectionPoint(psource,DIID:=COM_GetDefaultEvents(psource))
	Else	pconn:=COM_FindConnectionPoint(psource,SubStr(DIID,1,1)="{" ? DIID : DIID:=COM_GetGuidOfName(psource,DIID))
	If	!pconn || !(ptinf:=COM_GetTypeInfoOfGuid(psource,DIID))
	{
		MsgBox, No Event Interface Exists! Now exit the application.
		ExitApp
	}
	psink:=COM_CoTaskMemAlloc(40+StrLen(prefix)+1), NumPut(1,NumPut(COM_CreateIDispatch(),psink+0)), NumPut(psource,NumPut(ptinf,psink+8))
	DllCall("RtlMoveMemory", "Uint", psink+24, "Uint", COM_GUID4String(DIID,DIID), "Uint", 16)
	DllCall("RtlMoveMemory", "Uint", psink+40, "Uint", &prefix, "Uint", StrLen(prefix)+1)
	NumPut(COM_Advise(pconn,psink),NumPut(pconn,psink+16))
	Return	psink
}

COM_CreateObject(CLSID, IID = "{00020400-0000-0000-C000-000000000046}", CLSCTX = 5)
{
	DllCall("ole32\CoCreateInstance", "Uint", SubStr(CLSID,1,1)="{" ? COM_GUID4String(CLSID,CLSID) : COM_CLSID4ProgID(CLSID,CLSID), "Uint", 0, "Uint", CLSCTX, "Uint", COM_GUID4String(IID,IID), "UintP", ppv)
	Return	ppv
}

COM_ActiveXObject(ProgID)
{
	DllCall("ole32\CoCreateInstance", "Uint", SubStr(ProgID,1,1)="{" ? COM_GUID4String(ProgID,ProgID) : COM_CLSID4ProgID(ProgID,ProgID), "Uint", 0, "Uint", 5, "Uint", COM_GUID4String(IID_IDispatch,"{00020400-0000-0000-C000-000000000046}"), "UintP", pdisp)
	Return	COM_GetDefaultInterface(pdisp)
}

COM_GetObject(Moniker)
{
	DllCall("ole32\CoGetObject", "Uint", COM_Unicode4Ansi(Moniker,Moniker), "Uint", 0, "Uint", COM_GUID4String(IID_IDispatch,"{00020400-0000-0000-C000-000000000046}"), "UintP", pdisp)
	Return	COM_GetDefaultInterface(pdisp)
}

COM_GetActiveObject(ProgID)
{
	DllCall("oleaut32\GetActiveObject", "Uint", SubStr(ProgID,1,1)="{" ? COM_GUID4String(ProgID,ProgID) : COM_CLSID4ProgID(ProgID,ProgID), "Uint", 0, "UintP", punk)
	DllCall(NumGet(NumGet(1*punk)+0), "Uint", punk, "Uint", COM_GUID4String(IID_IDispatch,"{00020400-0000-0000-C000-000000000046}"), "UintP", pdisp)
	DllCall(NumGet(NumGet(1*punk)+8), "Uint", punk)
	Return	COM_GetDefaultInterface(pdisp)
}

COM_CLSID4ProgID(ByRef CLSID, ProgID)
{
	VarSetCapacity(CLSID, 16)
	DllCall("ole32\CLSIDFromProgID", "Uint", COM_Unicode4Ansi(ProgID,ProgID), "Uint", &CLSID)
	Return	&CLSID
}

COM_GUID4String(ByRef CLSID, String)
{
	VarSetCapacity(CLSID, 16)
	DllCall("ole32\CLSIDFromString", "Uint", COM_Unicode4Ansi(String,String,38), "Uint", &CLSID)
	Return	&CLSID
}

COM_ProgID4CLSID(pCLSID)
{
	DllCall("ole32\ProgIDFromCLSID", "Uint", pCLSID, "UintP", pProgID)
	Return	COM_Ansi4Unicode(pProgID) . SubStr(COM_CoTaskMemFree(pProgID),1,0)
}

COM_String4GUID(pGUID)
{
	VarSetCapacity(String, 38 * 2 + 1)
	DllCall("ole32\StringFromGUID2", "Uint", pGUID, "Uint", &String, "int", 39)
	Return	COM_Ansi4Unicode(&String, 38)
}

COM_IsEqualGUID(pGUID1, pGUID2)
{
	Return	DllCall("ole32\IsEqualGUID", "Uint", pGUID1, "Uint", pGUID2)
}

COM_CoCreateGuid()
{
	VarSetCapacity(GUID, 16, 0)
	DllCall("ole32\CoCreateGuid", "Uint", &GUID)
	Return	COM_String4GUID(&GUID)
}

COM_CoTaskMemAlloc(cb)
{
	Return	DllCall("ole32\CoTaskMemAlloc", "Uint", cb)
}

COM_CoTaskMemFree(pv)
{
	Return	DllCall("ole32\CoTaskMemFree", "Uint", pv)
}

COM_CoInitialize()
{
	Return	DllCall("ole32\CoInitialize", "Uint", 0)
}

COM_CoUninitialize()
{
	Return	DllCall("ole32\CoUninitialize")
}

COM_OleInitialize()
{
	Return	DllCall("ole32\OleInitialize", "Uint", 0)
}

COM_OleUninitialize()
{
	Return	DllCall("ole32\OleUninitialize")
}

COM_SysAllocString(sString)
{
	Return	DllCall("oleaut32\SysAllocString", "Uint", COM_Ansi2Unicode(sString,wString))
}

COM_SysFreeString(bstr)
{
	Return	DllCall("oleaut32\SysFreeString", "Uint", bstr)
}

COM_SysStringLen(bstr)
{
	Return	DllCall("oleaut32\SysStringLen", "Uint", bstr)
}

COM_SafeArrayDestroy(psa)
{
	Return	DllCall("oleaut32\SafeArrayDestroy", "Uint", psa)
}

COM_VariantClear(pvarg)
{
	Return	DllCall("oleaut32\VariantClear", "Uint", pvarg)
}

COM_AtlAxWinInit(Version = "")
{
	COM_CoInitialize()
	If !DllCall("GetModuleHandle", "str", "atl" . Version)
	    DllCall("LoadLibrary"    , "str", "atl" . Version)
	Return	DllCall("atl" . Version . "\AtlAxWinInit")
}

COM_AtlAxWinTerm(Version = "")
{
	COM_CoUninitialize()
	If hModule:=DllCall("GetModuleHandle", "str", "atl" . Version)
	Return	DllCall("FreeLibrary"    , "Uint", hModule)
}

COM_AtlAxGetControl(hWnd, Version = "")
{
	DllCall("atl" . Version . "\AtlAxGetControl", "Uint", hWnd, "UintP", punk)
	pdsp:=COM_QueryInterface(punk,IID_IDispatch:="{00020400-0000-0000-C000-000000000046}")
	COM_Release(punk)
	Return	pdsp
}

COM_AtlAxAttachControl(pdsp, hWnd, Version = "")
{
	punk:=COM_QueryInterface(pdsp,IID_IUnknown:="{00000000-0000-0000-C000-000000000046}")
	DllCall("atl" . Version . "\AtlAxAttachControl", "Uint", punk, "Uint", hWnd, "Uint", 0)
	COM_Release(punk)
}

COM_AtlAxCreateControl(hWnd, Name, Version = "")
{
	VarSetCapacity(IID_NULL, 16, 0)
	DllCall("atl" . Version . "\AtlAxCreateControlEx", "Uint", COM_Unicode4Ansi(Name,Name), "Uint", hWnd, "Uint", 0, "Uint", 0, "UintP", punk, "Uint", &IID_NULL, "Uint", 0)
	pdsp:=COM_QueryInterface(punk,IID_IDispatch:="{00020400-0000-0000-C000-000000000046}")
	COM_Release(punk)
	Return	pdsp
}

COM_AtlAxCreateContainer(hWnd, l, t, w, h, Name = "", Version = "")
{
	Return	DllCall("CreateWindowEx", "Uint",0, "str", "AtlAxWin" . Version, "Uint", Name ? &Name : 0, "Uint", 0x54000000, "int", l, "int", t, "int", w, "int", h, "Uint", hWnd, "Uint", 0, "Uint", 0, "Uint", 0)
}

COM_AtlAxGetContainer(pdsp)
{
	DllCall(NumGet(NumGet(1*pdsp)+ 0), "Uint", pdsp, "Uint", COM_GUID4String(IID_IOleWindow,"{00000114-0000-0000-C000-000000000046}"), "UintP", pwin)
	DllCall(NumGet(NumGet(1*pwin)+12), "Uint", pwin, "UintP", hCtrl)
	DllCall(NumGet(NumGet(1*pwin)+ 8), "Uint", pwin)
	Return	DllCall("GetParent", "Uint", hCtrl)
}

COM_Ansi4Unicode(pString, nSize = "")
{
	If (nSize = "")
	    nSize:=DllCall("kernel32\WideCharToMultiByte", "Uint", 0, "Uint", 0, "Uint", pString, "int", -1, "Uint", 0, "int",  0, "Uint", 0, "Uint", 0)
	VarSetCapacity(sString, nSize)
	DllCall("kernel32\WideCharToMultiByte", "Uint", 0, "Uint", 0, "Uint", pString, "int", -1, "str", sString, "int", nSize + 1, "Uint", 0, "Uint", 0)
	Return	sString
}

COM_Unicode4Ansi(ByRef wString, sString, nSize = "")
{
	If (nSize = "")
	    nSize:=DllCall("kernel32\MultiByteToWideChar", "Uint", 0, "Uint", 0, "Uint", &sString, "int", -1, "Uint", 0, "int", 0)
	VarSetCapacity(wString, nSize * 2 + 1)
	DllCall("kernel32\MultiByteToWideChar", "Uint", 0, "Uint", 0, "Uint", &sString, "int", -1, "Uint", &wString, "int", nSize + 1)
	Return	&wString
}

COM_Ansi2Unicode(ByRef sString, ByRef wString, nSize = "")
{
	If (nSize = "")
	    nSize:=DllCall("kernel32\MultiByteToWideChar", "Uint", 0, "Uint", 0, "Uint", &sString, "int", -1, "Uint", 0, "int", 0)
	VarSetCapacity(wString, nSize * 2 + 1)
	DllCall("kernel32\MultiByteToWideChar", "Uint", 0, "Uint", 0, "Uint", &sString, "int", -1, "Uint", &wString, "int", nSize + 1)
	Return	&wString
}

COM_Unicode2Ansi(ByRef wString, ByRef sString, nSize = "")
{
	pString := wString + 0 > 65535 ? wString : &wString
	If (nSize = "")
	    nSize:=DllCall("kernel32\WideCharToMultiByte", "Uint", 0, "Uint", 0, "Uint", pString, "int", -1, "Uint", 0, "int",  0, "Uint", 0, "Uint", 0)
	VarSetCapacity(sString, nSize)
	DllCall("kernel32\WideCharToMultiByte", "Uint", 0, "Uint", 0, "Uint", pString, "int", -1, "str", sString, "int", nSize + 1, "Uint", 0, "Uint", 0)
	Return	&sString
}

COM_ScriptControl(sCode, sLanguage = "", bEval = False)
{
	COM_CoInitialize()
	psc :=	COM_CreateObject("MSScriptControl.ScriptControl")
	If	sLanguage
		COM_Invoke(psc, "Language=", sLanguage)
	Ret :=	COM_Invoke(psc, bEval ? "Eval" : "ExecuteStatement", sCode)
	COM_Release(psc)
	COM_CoUninitialize()
	Return	Ret
}

;#######################################################
;##                 Show HTML Dialog                  ##
;#######################################################

/* Flags: Search MSDN for ShowHTMLDialogEx.
#define HTMLDLG_NOUI                     0x0010 // invisible
#define HTMLDLG_MODAL                    0x0020 // normal behaviour
#define HTMLDLG_MODELESS                 0x0040 // returns immediately
#define HTMLDLG_PRINT_TEMPLATE           0x0080
#define HTMLDLG_VERIFY                   0x0100 // force into viewable portion of desktop
#define HTMLDLG_ALLOW_UNKNOWN_THREAD     0x0200 // IE7+
*/

/*  Options: one or more of the following semicolon-delimited values:
dialogHeight:sHeight
    Sets the height of the dialog window.
    Valid unit-of-measure prefixes: cm, mm, in, pt, pc, em, ex, px
dialogLeft:sXPos
    Sets the left position of the dialog window relative to the upper-left
    corner of the desktop.
dialogTop:sYPos
    Sets the top position of the dialog window relative to the upper-left
    corner of the desktop.
dialogWidth:sWidth
    Sets the width of the dialog window.
    Valid unit-of-measure prefixes: cm, mm, in, pt, pc, em, ex, px
center:{ yes | no | 1 | 0 | on | off }
    Specifies whether to center the dialog window within the desktop. Default: yes
dialogHide:{ yes | no | 1 | 0 | on | off }
    Specifies whether the dialog window is hidden when printing or using print
    preview. Default: no
edge:{ sunken | raised }
    Specifies the edge style of the dialog window. Default: raised
resizable:{ yes | no | 1 | 0 | on | off }
    Specifies whether the dialog window has fixed dimensions. Default: no
scroll:{ yes | no | 1 | 0 | on | off }
    Specifies whether the dialog window displays scrollbars. Default: yes
status:{ yes | no | 1 | 0 | on | off }
    Specifies whether the dialog window displays a status bar. Default: no
unadorned:{ yes | no | 1 | 0 | on | off }
    Specifies whether the dialog window displays the window border.
*/
ShowHTMLDialog(URL, dialogArguments="", Options="", hwndParent=0, Flags=0)
{
    ; "Typically, the COM library is initialized on a thread only once. Subsequent
    ;  calls to CoInitialize or CoInitializeEx on the same thread will succeed,..."
    COM_CoInitialize()
   
    hinstMSHTML := DllCall("LoadLibrary","str","MSHTML.DLL")
    hinstUrlMon := DllCall("LoadLibrary","str","urlmon.dll") ; necessary to keep the URL moniker in memory.
   
    if !hinstMSHTML or !hinstUrlMon
        goto ShowHTMLDialog_Exit
   
    pUrl := COM_SysAllocString(URL)
   
    hr := DllCall("urlmon\CreateURLMonikerEx","uint",0,"uint",pUrl,"uint*",pUrlMoniker,"uint",1)
    if (ErrorLevel) {
        Error = DllCall(CreateURLMoniker)--%ErrorLevel%
        goto ShowHTMLDialog_Exit
    }
    if (hr or !pUrlMoniker) {
        Error = CreateURLMoniker--%hr%
        goto ShowHTMLDialog_Exit
    }

    pOptions := Options!="" ? COM_SysAllocString(Options) : 0
   
    VarSetCapacity(varArgIn,16,0), VarSetCapacity(varResult,16,0)

    if dialogArguments is integer
    {   ; int64 or +object (IDispatch)
        NumPut(SubStr(dialogArguments,1,1)="+" ? 9:20,varArgIn,0)
        NumPut(dialogArguments,varArgIn,8,"int64")
    } else {    ; string
        NumPut(8,varArgIn,0)
        NumPut(pArgIn:=COM_SysAllocString(dialogArguments),varArgIn,8)
    }

    if Flags
        hr := DllCall("mshtml\ShowHTMLDialogEx","uint",hwndParent,"uint",pUrlMoniker,"uint",Flags,"uint",&varArgIn,"uint",pOptions,"uint",&varResult)
    else
        hr := DllCall("mshtml\ShowHTMLDialog","uint",hwndParent,"uint",pUrlMoniker,"uint",&varArgIn,"uint",pOptions,"uint",&varResult)
    if (ErrorLevel) {
        Error = DllCall(ShowHTMLDialog)--%ErrorLevel%
        goto ShowHTMLDialog_Exit
    }
    if (hr) {
        Error = ShowHTMLDialog--%hr%
        goto ShowHTMLDialog_Exit
    }
    ; based on a line from COM_Invoke(). returnValue = varResult as string;
    InStr(" 0 4 5 6 7 14 "," " . NumGet(varResult,0,"Ushort") . " ") ? DllCall("oleaut32\VariantChangeTypeEx","Uint",&varResult,"Uint",&varResult,"Uint",0,"Ushort",0,"Ushort",8) : "", NumGet(varResult,0,"Ushort")=8 ? (returnValue:=COM_Ansi4Unicode(NumGet(varResult,8))) . COM_SysFreeString(NumGet(varResult,8)) : returnValue:=NumGet(varResult,8)
   
ShowHTMLDialog_Exit:
    if pArgIn
        COM_SysFreeString(pArgIn)
    if pOptions
        COM_SysFreeString(pOptions)
    if pUrlMoniker
        COM_Release(pUrlMoniker)
    if pUrl
        COM_SysFreeString(pUrl)
   
    ; "Each process maintains a reference count for each loaded library module.
    ;  This reference count is incremented each time LoadLibrary is called and
    ;  is decremented each time FreeLibrary is called."
    ; -- So FreeLibrary() will not unload these DLLs if they were loaded before
    ;    the function was called. :)
    if hinstMSHTML
        DllCall("FreeLibrary","uint",hinstMSHTML)
    if hinstUrlMon
        DllCall("FreeLibrary","uint",hinstUrlMon)
   
    ; "To close the COM library gracefully, each successful call to CoInitialize
    ;  or CoInitializeEx, including those that return S_FALSE, must be balanced
    ;  by a corresponding call to CoUninitialize."
    COM_CoUninitialize()
   
    ErrorLevel := Error
    return returnValue
}


;#######################################################
;##                     GetTextSize                   ##
;#######################################################


GetTextSize(pStr, pFont="", pHeight=false, pAdd=0) {
   local height, weight, italic, underline, strikeout , nCharSet
   local hdc := DllCall("GetDC", "Uint", 0)
   local hFont, hOldFont
   local resW, resH, SIZE

 ;parse font
   italic      := InStr(pFont, "italic")    ?  1   :  0
   underline   := InStr(pFont, "underline") ?  1   :  0
   strikeout   := InStr(pFont, "strikeout") ?  1   :  0
   weight      := InStr(pFont, "bold")       ? 700   : 400

   ;height
   RegExMatch(pFont, "(?<=[S|s])(\d{1,2})(?=[ ,])", height)
   if (height = "")
      height := 10


   RegRead, LogPixels, HKEY_LOCAL_MACHINE, SOFTWARE\Microsoft\Windows NT\CurrentVersion\FontDPI, LogPixels
   Height := -DllCall("MulDiv", "int", Height, "int", LogPixels, "int", 72)
   ;face
   RegExMatch(pFont, "(?<=,).+", fontFace)   
   if (fontFace != "")
       fontFace := RegExReplace( fontFace, "(^\s*)|(\s*$)")      ;trim
   else fontFace := "MS Sans Serif"

 ;create font
   hFont   := DllCall("CreateFont", "int",  height,   "int",  0,        "int",  0, "int", 0
                           ,"int",  weight,   "Uint", italic,   "Uint", underline
                           ,"uint", strikeOut, "Uint", nCharSet, "Uint", 0, "Uint", 0, "Uint", 0, "Uint", 0, "str", fontFace)
   hOldFont := DllCall("SelectObject", "Uint", hDC, "Uint", hFont)                               

   VarSetCapacity(SIZE, 16)
   curW=0
   Loop,  parse, pStr, `n
   {
      DllCall("DrawTextA", "Uint", hDC, "str", A_LoopField, "int", StrLen(pStr), "uint", &SIZE, "uint", 0x400)
      resW := ExtractInteger(SIZE, 8)
      curW := resW > curW ? resW : curW
   }
   DllCall("DrawTextA", "Uint", hDC, "str", pStr, "int", StrLen(pStr), "uint", &SIZE, "uint", 0x400)
 ;clean   
   
   DllCall("SelectObject", "Uint", hDC, "Uint", hOldFont)
   DllCall("DeleteObject", "Uint", hFont)
   DllCall("ReleaseDC", "Uint", 0, "Uint", hDC)

   resW := ExtractInteger(SIZE, 8) + pAdd
     resH := ExtractInteger(SIZE, 12) + pAdd


   if (pHeight)
      resW = W%resW% H%resH%

   return   %resW%
}

ExtractInteger(ByRef pSource, pOffset = 0, pIsSigned = false, pSize = 4)
{
    Loop %pSize%
        result += *(&pSource + pOffset + A_Index-1) << 8*(A_Index-1)
    if (!pIsSigned OR pSize > 4 OR result < 0x80000000)
        return result
    return -(0xFFFFFFFF - result + 1)
}


;#######################################################
;##                       Anchor                      ##
;#######################################################

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