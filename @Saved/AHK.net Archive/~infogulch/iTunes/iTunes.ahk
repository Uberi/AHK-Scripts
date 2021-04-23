#NoEnv
#SingleInstance, Force
SetBatchLines, -1
OnExit, ExitSub

#.::iTunes("NextTrack")
#,::iTunes("PreviousTrack")
#'::iTunes("SoundVolume", "+", 2)
#;::iTunes("SoundVolume", "+", -2)
#=::iTunes("FastForward"), WaitThisHotkey(), iTunes("Resume")
#-::iTunes("Rewind"), WaitThisHotkey(), iTunes("Resume")
#/::iTunes( "Mute", "!" )
#Space::iTunes("PlayPause")
#Backspace::iTunes("Stop")
#Up::iTunes("CurrentTrack.Rating", "+", 20)
#Down::iTunes("CurrentTrack.Rating", "+", -20)

#i::
~Up & ~Down::
~Down & ~Up::
	iTunes_Info()
return

;useage examples:
iTunes( "SoundVolume", "", 25 )		;set the sound directly to 25
iTunes( "SoundVolume", "+", 10 )	;add ten to the current soundvolume. you can "add" a negative too

iTunes( "Mute", "!" )				;toggles the mute state

iTunes( "PlayFirstTrack" )			;plays the first song in the current playlist
iTunes( "SongRepeat", "", 2 )		;song repeat mode: 0=Play playlist once, 1=Repeat song, 2=Repeat Playlist
iTunes( "PlayFile", "", "D:\Full\Path\To\FileToPlay.ext" ) ; cool, eh?
iTunes( "Quit" )					; uhm, do i really have to tell you this too?

; #Include iTunes.ahk

ExitSub:
	COM_Term()
	ExitApp

iTunes(pAction="", pRel=False, SetTo="vT_NoNe") {
; pAction:	the iTunes function to call, this returns it's return value
; pRel:		change the function relative to its current setting. either + or !. + to add (or subtract) and ! to toggle
; SetTo:	if pRel is +, the amount to change it by, (e.g. 10 would add ten.) otherwise a specific value to pass to the function 
	Global _iTunes_App
	If _iTunes_App_Disabled
		return "Error - COM Disabled"
	If !_iTunes_App
		COM_Init(), _iTunes_App := COM_CreateObject("iTunes.Application")  ;Create the object
	If (pAction="")
		return
	thisObj := _iTunes_App
	Loop, Parse, pAction, .
	{
		If lastObj
			thisObj := COM_Invoke(thisObj, lastObj)
		lastObj := A_LoopField
	}
	If pRel In +,!
	{
		R := COM_Invoke(thisObj, lastObj)
		SetTo := (pRel = "+" ? R + SetTo : !R)
	}
return COM_Invoke(thisObj, lastObj, SetTo)
}

iTunes_Info( ) {
;	Static
	Global _iTg_TrackArt, _iTg_TrackRating, _iTg_TrackInfo, _iTg_TimePlayed, _iTg_TimeLeft, _iTg_Progress, _iTg_GuiTitle ;GUI
	Global _iTunes_App, _iTunes_Conn
	Static sArtworkFile, sInit, sArtworkDefault, sResFolder, sGuiNum
	Static sScr, sTrans, sGuiID, sFadeTimeout, sArtwork, siTState
	Static CT, CP, CP_Name, CT_Name, CT_Arts, CT_Alb, CT_Time, CT_Rat, CT_Duration, CT_PlayerPos, CT_Kind, CT_Genre, CT_Bit, CT_Size
	
	If !_iTunes_App
		If InStr(iTunes(), "Error")
			return "Error - COM Disabled"
	If !_iTunes_Conn
		_iTunes_Conn := COM_ConnectObject(_iTunes_App, "iTunes_")
	If !sInit
	{
		sFadeTimeout=5000 ;how many ms to display the info window
		sGuiNum=5	;The gui number used by this script - change as it suits you (1-99)	
		GoSub _iTunesInfo_Initiate
	}
	GoSub _iT_UpdateTrack
	GoSub _iT_UpdateTime
	sTrans := (sTrans<0 ? sTrans*=-1 : sTrans)
	GoSub _iT_Fade
return
	
	_iT_UpdateTime:
	{
		If !_iTunes_App || !CT:=COM_Invoke(_iTunes_App, "CurrentTrack")
			return 
		CT_PlayerPos := COM_Invoke(_iTunes_App, "PlayerPosition")
		CT_Duration	 := COM_Invoke(CT, "Duration")
		Gui, %sGuiNum%:Default
		GuiControl,, _iTg_Progress, % Round( (CT_PlayerPos/CT_Duration)*100 )
		GuiControl,, _iTg_TimePlayed, % SecToHHMMSS(CT_PlayerPos)
		GuiControl,, _iTg_TimeLeft, % "-" SecToHHMMSS(CT_Duration-CT_PlayerPos) "/" SecToHHMMSS(CT_Duration)
	}
	return
	
	_iT_UpdateTrack:
	{
		If !_iTunes_App
			return
		CT		:= COM_Invoke(_iTunes_App, "CurrentTrack")
		CP		:= COM_Invoke(_iTunes_App, "CurrentPlaylist")
		CP_Name	:= COM_Invoke(CP, "Name")
		CT_Name := COM_Invoke(CT, "Name")
		CT_Arts := COM_Invoke(CT, "Artist")
		CT_Alb  := COM_Invoke(CT, "Album")
		CT_Rat  := COM_Invoke(CT, "Rating")
		CT_Kind := COM_Invoke(CT, "KindAsString")
		CT_Genre:= COM_Invoke(CT, "Genre")
		CT_Bit  := COM_Invoke(CT, "BitRate") " kbps"
		CT_Size := Round(COM_Invoke(CT, "Size") / 1048576, 1) " MB"
		sArtwork := COM_Invoke( CT, "Artwork", 1)
		COM_Invoke(sArtwork, "SaveArtworkToFile", sArtworkFile)
		Gui, %sGuiNum%:Default
		GuiControl,, _iTg_GuiTitle, % COM_Invoke(_iTunes_App, "PlayerState") ? "iTunes - Playing" : "iTunes - Stopped"
		GuiControl,, _iTg_TrackRating, % sResFolder "\rating" CT_Rat//20 ".ico"
		GuiControl,, _iTg_TrackArt, % (sArtwork ? sArtworkFile : sArtworkDefault)
		GuiControl,, _iTg_TrackInfo, 
		( LTrim Join`n
		Track:	%CT_Name%
		Artist:	%CT_Arts%
		Album:	%CT_Alb%
		`	%CP_Name%, %CT_Genre%
		%CT_Bit% \ %CT_Size%, %CT_Kind%
		)
	}
	return
	
	_iT_Fade:
		SetWinDelay, -1
		sTrans := ((GetKeyState( "LWin", "P") OR GetKeyState( "RWin", "P" ) OR GetKeyState( "Ctrl", "P" )) && sTrans<0 
			? sTrans*=-1 : sTrans)
		WinSet, Trans, % Abs( sTrans<220 ? sTrans+=20 : sTrans*=-1 ), ahk_id %sGuiID%
		SetTimer, _iT_Fade, % (sTrans=0 ? "Off" : (sTrans<-200 ? -sFadeTimeout : -60))
	return
	
	_iTunes_Info:
		iTunes_Info()
	return
	
	_COM_Term:
		COM_Term()
	return
	
	_iTunesInfo_Initiate: 
	{
	; ###### Function Settings
		sTrans:=0
		sInit := True
		SysGet, sScr, MonitorWorkArea, 1
		sResFolder = %A_ScriptDir%\iTRes
		sArtworkFile = %sResFolder%\iTunesCurrentArtwork.jpg
		sArtworkDefault = %sResFolder%\Default.jpg
	; ###### Gui
		Gui, %sGuiNum%:Default
		Gui, +AlwaysOnTop +ToolWindow -Caption +E0x20
		Gui, Color, 0x999999, 0x999999
		Gui, +LastFoundExist
		sGuiID := WinExist()
		
		Gui, Add, Picture, x0 y0 h-1 w400, %sResFolder%\gradient.bmp
		Gui, Add, Picture, BackgroundTrans AltSubmit x7 y7 w120 h120 v_iTg_TrackArt	 , %sArtworkDefault%
		Gui, Add, Picture, BackgroundTrans AltSubmit x132 y110 w78 h15 v_iTg_TrackRating , %sResFolder%\rating0.ico
		Gui, Font, W800 C000000 s11, Lucida Grande
		Gui, Add, Text	, BackgroundTrans v_iTg_GuiTitle x132 y7 w266 h20, iTunes
		Gui, Font, W400 s8
		Gui, Add, Text	, BackgroundTrans x132 y30 w261 h80 -Wrap v_iTg_TrackInfo, Track:`tName`nArtist:`tName`nAlbum:`tName`n`tPlaylist
		Gui, Font, W700
		Gui, Add, Text	, AltSubit BackgroundTrans x7 Center y130 w40 h15 v_iTg_TimePlayed, 00:00
		Gui, Add, Progress, Background999999 cffffff v_iTg_Progress Range0-100 x50 y134 w256 h7
		Gui, Add, Text	, AltSubit BackgroundTrans Center x310 y130 w85 h15 v_iTg_TimeLeft, -00:00/00:00
		Gui, Show, W400 H150 X-1000 Y-1000 NA, iTunes Info and Control
		WinSet, Trans, 0, ahk_id %sGuiID%
		WinSet, Region, 0-0 W400 H150 R10-10, ahk_id %sGuiID%
		WinMove, ahk_id %sGuiID%, , sScrRight-405, sScrBottom-155
		SetTimer, _iT_UpdateTime, On
	}
	return
}

iTunes_OnPlayerPlayingTrackChangedEvent(track) {
	Global
	If !(_iTunes_App)
		return
	SetTimer, _iT_UpdateTime, 1000
	SetTimer, _iTunes_Info, -1
}

iTunes_OnPlayerPlayEvent(track) {
	Global
	If !(_iTunes_App)
		return
	SetTimer, _iT_UpdateTime, 1000
	SetTimer, _iTunes_Info, -1
}

iTunes_OnPlayerStopEvent() {
	Global
	If !(_iTunes_App)
		return
	SetTimer, _iT_UpdateTime, Off
	SetTimer, _iTunes_Info, -1
}

iTunes_OnAboutToPromptUserToQuitEvent() {
	Global
	If !(_iTunes_App)
		return
	_iTunes_App := False
	_iTunes_Conn := False
	_iTunes_App_Disabled := False
	SetTimer, _COM_Term, -1
}

iTunes_OnCOMCallsDisabledEvent(reason) {
	Global
	If (_iTunes_App && !_iTunes_App_Disabled)
	{
		_iTunes_App_Disabled := _iTunes_App
		_iTunes_App := False
	}
}

iTunes_OnCOMCallsEnabledEvent() {
	Global
	If (_iTunes_App_Disabled && !_iTunes_App)
	{
		_iTunes_App := _iTunes_App_Disabled
		_iTunes_App_Disabled := False
	}
}

SecToHHMMSS(Sec) {
	OldFormat := A_FormatFloat
	SetFormat, Float, 02.0
	Hrs  := Sec//3600/1
	Min := Mod(Sec//60, 60)/1
	Sec := Mod(Sec,60)/1
	SetFormat, Float, %OldFormat%
	Return (Hrs ? Hrs ":" : "") Min ":" Sec
}

WaitThisHotkey() {
; by Infogulch ~ http://www.autohotkey.com/forum/topic35999.html
	RegEx := RegExMatch( A_ThisHotkey, "i)(?:[~#!<>\*\+\^\$]*([^ ]+)( UP)?)$", Key)
	KeyWait, %Key1%, % (Key2 ? "D" : "U")
}

/*

Other iTunes Events:
	OnDatabaseChangedEvent ([in] VARIANT deletedObjectIDs,[in] VARIANT changedObjectIDs)
	OnPlayerPlayEvent ([in] VARIANT iTrack)
	OnPlayerStopEvent ([in] VARIANT iTrack)
	OnPlayerPlayingTrackChangedEvent ([in] VARIANT iTrack)
	OnCOMCallsDisabledEvent ([in] ITCOMDisabledReason reason)
	OnCOMCallsEnabledEvent ()
	OnAboutToPromptUserToQuitEvent ()
	OnQuittingEvent ()
	OnSoundVolumeChangedEvent ([in] long newVolume)

MiniPlayer = True

CurrentPlaylist.Name
CurrentTrack.Name
CurrentTrack.Album
CurrentTrack.Artist
CurrentTrack.BitRate
CurrentTrack.BPM
CurrentTrack.Duration
CurrentTrack.Rating
CurrentTrack.SampleRate
CurrentTrack.Size
CurrentTrack.Genre

CurrentTrack.Comment
CurrentTrack.Compilation
CurrentTrack.Composer
CurrentTrack.DateAdded
CurrentTrack.DiscCount
CurrentTrack.DiscNumber
CurrentTrack.Enabled
CurrentTrack.EQ
CurrentTrack.Finish
CurrentTrack.Grouping
CurrentTrack.KindAsString
CurrentTrack.ModificationDate
CurrentTrack.PlayedCount
CurrentTrack.PlayedDate
CurrentTrack.PlayOrderIndex
CurrentTrack.Star
CurrentTrack.Time
CurrentTrack.TrackCount
CurrentTrack.TrackNumber
CurrentTrack.VolumeAdjustment
CurrentTrack.Year
