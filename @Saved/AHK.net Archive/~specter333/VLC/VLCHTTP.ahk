; VLC Media Player HTTP Functions Library.
; Developed by Richard Wells, AHK handle Specter333.
; 
; Most transport functions are one way, received by VLC.  They can be 
; Called using only the function name. 
; Example, VLCHTTP_Pause() will toggle between pause and play.
; 
; Some of the one way functions, such as VLCHTTP_VolumeChange(Val) or
; VLCHTTP_PlaylistAdd(path), require a parameter. 
; Example, VLCHTTP_VolumeUp(10) sets the volume 10% higher than it was.
;
; Functions that return data, such as VLCHTTP_CurrentVol() or 
; VLCHTTP_PlaylistTracks(), use the normal syntax. 
; Example, GetTrack:=VLCHTTP_NowPlaying() puts the name 
; of the currently playing track into the variable %GetTrack%.
;
; For demo scripts see the AHK forum post,
; http://www.autohotkey.com/forum/viewtopic.php?t=69150

; Last updated November 24, 2011.

VLCHTTP_Close() ; Closes VLC Media Player.
	{
	WinClose, ahk_class QWidget
	}
VLCHTTP_Pause() ; Toggles Play/Pause of currently playing media.
	{
	cmd = http://127.0.0.1:8080/?control=pause
	UrlDownloadToVar(cmd)
	}
VLCHTTP_Play() ; Play from currently select playlist item.
	{
	cmd = http://127.0.0.1:8080/?control=play
	UrlDownloadToVar(cmd)
	}
VLCHTTP_Stop() ; Stop media playback.
	{
	cmd = http://127.0.0.1:8080/?control=stop
	UrlDownloadToVar(cmd)
	}
VLCHTTP_FullScreen() ; Toggle Full Screen 
	{
	cmd = http://127.0.0.1:8080/?control=fullscreen
	UrlDownloadToVar(cmd)
	}
VLCHTTP_JumpForward(Val) ; Skip ahead in media the specified value.
	{
	cmd = http://127.0.0.1:8080/requests/status.xml?command=seek&val=`%2B%Val%  
	UrlDownloadToVar(cmd)
	}
VLCHTTP_JumpBackward(Val) ; Skip back in media the specified value.  
	{
	cmd = http://127.0.0.1:8080/requests/status.xml?command=seek&val=-%Val%  
	UrlDownloadToVar(cmd)
	}
VLCHTTP_VolumeUp(Val) ; Volume up relative, a value of 10 is typical
	{
	;depending or your settings range is either 1-512 or 1-1024
	cmd = http://127.0.0.1:8080/requests/status.xml?command=volume&val=`%2B%Val%
	UrlDownloadToVar(cmd)
	}
VLCHTTP_VolumeDown(Val) ; Volume down relative, a value of 10 is typical
	{
	;depending or your settings range is either 1-512 or 1-1024
	cmd = http://127.0.0.1:8080/requests/status.xml?command=volume&val=-%Val%
	UrlDownloadToVar(cmd)
	}
VLCHTTP_VolumeChange(Val) ; Sets volume to val, 
	{
	;depending or your settings range is either 0-512 or 0-1024
	cmd = http://127.0.0.1:8080/requests/status.xml?command=volume&val=%Val%
	UrlDownloadToVar(cmd)
	}
VLCHTTP_ToggleMute(resetvol) ; Call with - MuteStatus:=VLCHTTP_ToggleMute(MuteStatus)
; This does not invoke the mute button on VLC but remembers the current volume then set
; the volume to 0.  When called again it restores the previous volume. 
	{
	Status := VLCHTTP_Status()
	Loop, parse, Status, `n, `r  
		{
		IfInString, A_LoopField, <volume>
			Volume = %A_LoopField%
		}
	CurrentVolume := UnHTM(Volume)
		
	If CurrentVolume = 0
		{
		cmd = http://127.0.0.1:8080/requests/status.xml?command=volume&val=%resetvol%
		UrlDownloadToVar(cmd)
		Return
		}
	cmd =  http://127.0.0.1:8080/requests/status.xml?command=volume&val=0
	UrlDownloadToVar(cmd)
	Return, %CurrentVolume%
	}
VLCHTTP_CurrentVol() ; Retrieve current volume
	{
	Status := VLCHTTP_Status()
	Loop, parse, Status, `n, `r  
		{
		IfInString, A_LoopField, <volume>
			Volume = %A_LoopField%
		}
	CurrentVolume := UnHTM(Volume)
	Return, %CurrentVolume%
	}
VLCHTTP_NowPlaying() ; Retrieves the name of the current media in VLC status.
	{
	Status := VLCHTTP_Status()
	Loop, parse, Status, `n, `r  
		{
		IfInString, A_LoopField, <title>
			NowPlaying = %A_LoopField%
		}
	StringReplace, NowPlaying, NowPlaying, <![CDATA[, , A
	StringReplace, NowPlaying, NowPlaying, ]]>, , A
	NowPlaying := UnHTM(NowPlaying)
	Return, %NowPlaying%
	}
VLCHTTP_Status() ;Get information on current playing media.
	{
	VLCStatus = http://127.0.0.1:8080/requests/status.xml
	Status := UrlDownloadToVar(VLCStatus)
	Return, Status
	}
;;;;;;;;;;;;;;;;;;;;        Playlist Functions     ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
VLCHTTP_PlayList() ; Retrieve the playlist data.
	{
	VLCPlayList = http://127.0.0.1:8080/requests/playlist.xml
	OutFile := UrlDownloadToVar(VLCPlayList)
	Return, %OutFile%
	}
VLCHTTP_PlayListNext() ;Next item in the playlist
	{
	cmd = http://127.0.0.1:8080/requests/status.xml?command=pl_next
	UrlDownloadToVar(cmd)
	}
VLCHTTP_PlayListPrevious() ;Previous item in the playlist
	{
	cmd = http://127.0.0.1:8080/requests/status.xml?command=pl_previous
	UrlDownloadToVar(cmd)
	}
VLCHTTP_PlayListClear() ; Delete all items in the playlist
	{
	cmd = http://127.0.0.1:8080/requests/status.xml?command=pl_empty
	UrlDownloadToVar(cmd)
	}
VLCHTTP_PlayListRandom() ; Toggle (On, Off) random playback order
	{
	cmd = http://127.0.0.1:8080/requests/status.xml?command=pl_random
	UrlDownloadToVar(cmd)
	}
VLCHTTP_PlayListIsRandom() ; Returns 1 if random is on, 0 if not.
	{
	Status := VLCHTTP_Status()
	Loop, parse, Status, `n, `r  
		{
		IfInString, A_LoopField, <random>
			Random = %A_LoopField%
		}
	IsRandom := UnHTM(Random)
	Return, %IsRandom%
	}
VLCHTTP_PlayListLoop() ; Toggle loop playback
	{
	cmd = http://127.0.0.1:8080/requests/status.xml?command=pl_loop
	UrlDownloadToVar(cmd)
	}
VLCHTTP_PlayListIsLoop() ; Returns 1 is loop is on, 0 if not.
	{
	Status := VLCHTTP_Status()
	Loop, parse, Status, `n, `r  
		{
		IfInString, A_LoopField, <loop>
			Loop = %A_LoopField%
		}
	IsLoop := UnHTM(Loop)
	Return, %IsLoop%
	}
VLCHTTP_PlayListRepeat() ; Toggle between repeat 1 or repeat all when looping. 
	{
	cmd = http://127.0.0.1:8080/requests/status.xml?command=pl_repeat
	UrlDownloadToVar(cmd)
	}
VLCHTTP_PlayListIsRepeat() ; Returns 0 for repeat all or 1 for repeat current media.
	{
	Status := VLCHTTP_Status()
	Loop, parse, Status, `n, `r  
		{
		IfInString, A_LoopField, <repeat>
			Repeat = %A_LoopField%
		}
	IsRepeat := UnHTM(Repeat)
	Return, %IsRepeat%
	}
VLCHTTP_PlaylistPlayID(id) ; Play the entry coresponding the the Playlist id number.
	{
	cmd = http://127.0.0.1:8080/requests/status.xml?command=pl_play&id=%id%
	UrlDownloadToVar(cmd)
	}
VLCHTTP_PlaylistDeleteID(id)  ; Delete the entry coresponding the the Playlist id number.
	{
	cmd = http://127.0.0.1:8080/requests/status.xml?command=pl_delete&id=%id%
	UrlDownloadToVar(cmd)
	}
VLCHTTP_PlaylistTracks() ; Retrieve the title of all media in the playlist seperated with ¥.
	{
	AllTitles = 
	cmd := VLCHTTP_PlayList()
	StringReplace, cmd, cmd, <leaf, ¥, A
	StringReplace, cmd, cmd, ]]>, , A
	StringReplace, cmd, cmd, <![CDATA[, , A
	StringSplit, Section, cmd, ¥
	Loop, %Section0%
		{
		Sect := % Section%A_Index%
		Loop, parse, Sect, `n, `r
			{
			IfInString, A_LoopField, <title>
				title = %A_LoopField%
			StringReplace, title, title, <![CDATA[, , A
			StringReplace, title, title, ]]>, , A
			title := UnHTM(title)
			If AllTitles = 
				ReturnTitle = %title%
			Else, ReturnTitle = ¥%title%	
			
			}

		AllTitles = %AllTitles%%ReturnTitle%
		}
	Return, %AllTitles%
	}
VLCHTTP_PlaylistArtist() ; Retrieve the artist of all media in the playlist seperated with ¥.
	{
	AllArtist= 
	cmd := VLCHTTP_PlayList()
	StringReplace, cmd, cmd, <leaf, ¥, A
	StringReplace, cmd, cmd, ]]>, , A
	StringReplace, cmd, cmd, <![CDATA[, , A
	StringSplit, Section, cmd, ¥
	Loop, %Section0%
		{
		Sect := % Section%A_Index%
		Loop, parse, Sect, `n, 
			{
			IfInString, A_LoopField, <Artist>
				Artist = %A_LoopField%
			Artist := UnHTM(Artist)
			If AllArtist = 
				ReturnArtist = %Artist%
			Else, ReturnArtist = ¥%Artist%
			}
		AllArtist = %AllArtist%%ReturnArtist%
		}
	Return, %AllArtist%
	}	
VLCHTTP_PlayListAlbum() ; Retrieve the album of all media in the playlist seperated with ¥.
	{
	AllAlbums = 
	cmd := VLCHTTP_PlayList()
		StringReplace, cmd, cmd, <leaf, ¥, A
	StringReplace, cmd, cmd, ]]>, , A
	StringReplace, cmd, cmd, <![CDATA[, , A
	StringSplit, Section, cmd, ¥
	Loop, %Section0%
		{
		Sect := % Section%A_Index%
		Loop, parse, Sect, `n, `r
			{
			IfInString, A_LoopField, <album>
				Album = %A_LoopField%
			Album := UnHTM(Album)
			If AllAlbums = 
				ReturnAlbum = %Album%
			Else, ReturnAlbum = ¥%Album%
			}
		AllAlbums = %AllAlbums%%ReturnAlbum%
		
		}
	Return, %AllAlbums%
	}
VLCHTTP_PlayListID() ; Retrieve the playlist ID of all media in the playlist seperated with ¥.
; Use this ID to play or delete a playist item.
	{
	AllIDs = 
	cmd := VLCHTTP_PlayList()
		StringReplace, cmd, cmd, <leaf, ¥ µ, A
	StringReplace, cmd, cmd, ]]>, , A
	StringReplace, cmd, cmd, <![CDATA[, , A
	StringSplit, Section, cmd, ¥
	Loop, %Section0%
		{
		Sect := % Section%A_Index%
		Loop, parse, Sect, `n, `r
			{
			IfInString, A_LoopField,  µ id=
				ID = %A_LoopField%
			StringSplit, ID, ID, "
			ID := UnHTM(ID2)
			If AllIDs = 
				ReturnID = %ID%
			Else, ReturnID = ¥%ID%
			}
		AllIDs = %AllIDs%%ReturnID%
		
		}
	Return, %AllIDs%
	}
VLCHTTP_PlaylistAdd(path) ; Add media to playlist.
	{
	StringReplace, path, path, \, /, All
	cmd = http://127.0.0.1:8080/requests/status.xml?command=in_enqueue&input=%path%
	UrlDownloadToVar(cmd)
	Return, %path%
	}
VLCHTTP_PlaylistAddPlay(path) ; Add media to playlist and play it.
	{
	StringReplace, path, path, \, /, All
	cmd = http://127.0.0.1:8080/requests/status.xml?command=in_play&input=%path%
	UrlDownloadToVar(cmd)
	Return, %path%
	}

;;; Sort functions seem to be disabled in latest version.  They are broken in VLC's HTML interface too.  	
VLCHTTP_PlaylistSortID(order=0) ; Sort playlist by ID or how added, order = normal, order 1 = reverse.
	{
	cmd = http://127.0.0.1:8080/requests/status.xml?command=pl_sort&id=%order%&val=0
	UrlDownloadToVar(cmd)
	}
VLCHTTP_PlaylistSortName(order=0) ; Sort playlist by name, order = normal, order 1 = reverse.
	{
	cmd = http://127.0.0.1:8080/requests/status.xml?command=pl_sort&id=%order%&val=1
	UrlDownloadToVar(cmd)
	}
VLCHTTP_PlaylistSortAuthor(order=0) ; Sort playlist by author, order = normal, order 1 = reverse.
	{
	cmd = http://127.0.0.1:8080/requests/status.xml?command=pl_sort&id=%order%&val=3
	UrlDownloadToVar(cmd)
	}	
VLCHTTP_PlaylistSortRandom() ; Sort playlist random, order = normal, order 1 = reverse.
	{
	cmd = http://127.0.0.1:8080/requests/status.xml?command=pl_sort&id=%order%&val=5
	UrlDownloadToVar(cmd)
	}	
VLCHTTP_PlaylistSortTrackNum(order=0) ; Sort playlist by track number, order = normal, order 1 = reverse.
	{
	cmd = http://127.0.0.1:8080/requests/status.xml?command=pl_sort&id=%order%&val=7
	UrlDownloadToVar(cmd)
	}

;;;;;; Service discovery modules, untested.
VLCHTTP_Sap() ; Toggles sap service discovery module On/Off.
	{
	cmd = http://127.0.0.1:8080/requests/status.xml?command=pl_sd&val=sap
	UrlDownloadToVar(cmd)
	}
VLCHTTP_Shoutcast() ; Toggles shoutcast service discovery module On/Off.
	{
	cmd = http://127.0.0.1:8080/requests/status.xml?command=pl_sd&val=shoutcast
	UrlDownloadToVar(cmd)
	}
VLCHTTP_Podcast() ; Toggles podcast service discovery module On/Off.
	{
	cmd = http://127.0.0.1:8080/requests/status.xml?command=pl_sd&val=podcast
	UrlDownloadToVar(cmd)
	}
VLCHTTP_Hal() ; Toggles hal service discovery module On/Off.
	{
	cmd = http://127.0.0.1:8080/requests/status.xml?command=pl_sd&val=hal
	UrlDownloadToVar(cmd)
	}
VLCHTTP_ServMod(Mod) ; Toggles a custom service discovery module On/Off.	
	{
	cmd = http://127.0.0.1:8080/requests/status.xml?command=pl_sd&val=%Mod%
	UrlDownloadToVar(cmd)
	}

;;;;;;;;;;;;;;;;;;;;;;      Time Functions ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
VLCHTTP_Time() ;   Returns the elapsed time of the currently playing item.
	{
	Status := VLCHTTP_Status()
	Loop, parse, Status, `n, `r  
		{
		IfInString, A_LoopField, <time>
			time = %A_LoopField%
		}
	NowTime := UnHTM(time)
	NowTime := FormatSeconds(NowTime)
	Return, %NowTime%	
	}
VLCHTTP_Length() ;   Returns the total length of the currently playing item.
	{
	Status := VLCHTTP_Status()
	Loop, parse, Status, `n, `r  
		{
		IfInString, A_LoopField, <length>
			length = %A_LoopField%
		}
	Duration := UnHTM(length)
	Duration := FormatSeconds(Duration)
	Return, %Duration%
	}
VLCHTTP_Remaining() ;   Returns the difference between "Time" and "Length" of the currently playing item.
	{
	Status := VLCHTTP_Status()
	Loop, parse, Status, `n, `r  
		{
		IfInString, A_LoopField, <length>
			length = %A_LoopField%
		}
	Duration := UnHTM(length)
	Loop, parse, Status, `n, `r  
		{
		IfInString, A_LoopField, <time>
			time = %A_LoopField%
		}
	NowTime := UnHTM(time)
	Remaining := Duration-NowTime
	Remaining := FormatSeconds(Remaining)
	Return, %Remaining%
	}
VLCHTTP_Position() ;Returns the percent played of the currently playing item.
	{
	Status := VLCHTTP_Status()
	Loop, parse, Status, `n, `r  
		{
		IfInString, A_LoopField, <position>
			cmd = %A_LoopField%
		}
	StringReplace, cmd, cmd, <![CDATA[, , A
	StringReplace, cmd, cmd, ]]>, , A
	cmd := UnHTM(cmd)
	Return, %cmd%
	}	

	
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Format time from example in manual.
FormatSeconds(NumberOfSeconds)
   {
    time = 19990101 
    time += %NumberOfSeconds%, seconds
    FormatTime, mmss, %time%, mm:ss
    return NumberOfSeconds//3600 ":" mmss
   }

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;  UrlDownloadToVar by olfen 
; http://www.autohotkey.com/forum/viewtopic.php?p=64230#64230
UrlDownloadToVar(URL, Proxy="", ProxyBypass="") {
AutoTrim, Off
hModule := DllCall("LoadLibrary", "str", "wininet.dll")

If (Proxy != "")
AccessType=3
Else
AccessType=1
;INTERNET_OPEN_TYPE_PRECONFIG                    0   // use registry configuration
;INTERNET_OPEN_TYPE_DIRECT                       1   // direct to net
;INTERNET_OPEN_TYPE_PROXY                        3   // via named proxy
;INTERNET_OPEN_TYPE_PRECONFIG_WITH_NO_AUTOPROXY  4   // prevent using java/script/INS

io_hInternet := DllCall("wininet\InternetOpenA"
, "str", "" ;lpszAgent
, "uint", AccessType
, "str", Proxy
, "str", ProxyBypass
, "uint", 0) ;dwFlags

iou := DllCall("wininet\InternetOpenUrlA"
, "uint", io_hInternet
, "str", url
, "str", "" ;lpszHeaders
, "uint", 0 ;dwHeadersLength
, "uint", 0x80000000 ;dwFlags: INTERNET_FLAG_RELOAD = 0x80000000 // retrieve the original item
, "uint", 0) ;dwContext

If (ErrorLevel != 0 or iou = 0) {
DllCall("FreeLibrary", "uint", hModule)
return 0
}

VarSetCapacity(buffer, 512, 0)
VarSetCapacity(NumberOfBytesRead, 4, 0)
Loop
{
  irf := DllCall("wininet\InternetReadFile", "uint", iou, "uint", &buffer, "uint", 512, "uint", &NumberOfBytesRead)
  NOBR = 0
  Loop 4  ; Build the integer by adding up its bytes. - ExtractInteger
    NOBR += *(&NumberOfBytesRead + A_Index-1) << 8*(A_Index-1)
  IfEqual, NOBR, 0, break
  ;BytesReadTotal += NOBR
  DllCall("lstrcpy", "str", buffer, "uint", &buffer)
  res = %res%%buffer%
}
StringTrimRight, res, res, 2

DllCall("wininet\InternetCloseHandle",  "uint", iou)
DllCall("wininet\InternetCloseHandle",  "uint", io_hInternet)
DllCall("FreeLibrary", "uint", hModule)
AutoTrim, on
return, res
} 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; UnHTM by SKAN
; http://www.autohotkey.com/forum/viewtopic.php?p=312001#312001

 UnHTM( HTM ) {   ; Remove HTML formatting / Convert to ordinary text   by SKAN 19-Nov-2009
 Static HT,C=";" ; Forum Topic: www.autohotkey.com/forum/topic51342.html  Mod: 16-Sep-2010
 IfEqual,HT,,   SetEnv,HT, % "&aacuteá&acircâ&acute´&aeligæ&agraveà&amp&aringå&atildeã&au"
 . "mlä&bdquo„&brvbar¦&bull•&ccedilç&cedil¸&cent¢&circˆ&copy©&curren¤&dagger†&dagger‡&deg"
 . "°&divide÷&eacuteé&ecircê&egraveè&ethð&eumlë&euro€&fnofƒ&frac12½&frac14¼&frac34¾&gt>&h"
 . "ellip…&iacuteí&icircî&iexcl¡&igraveì&iquest¿&iumlï&laquo«&ldquo“&lsaquo‹&lsquo‘&lt<&m"
 . "acr¯&mdash—&microµ&middot·&nbsp &ndash–&not¬&ntildeñ&oacuteó&ocircô&oeligœ&ograveò&or"
 . "dfª&ordmº&oslashø&otildeõ&oumlö&para¶&permil‰&plusmn±&pound£&quot""&raquo»&rdquo”&reg"
 . "®&rsaquo›&rsquo’&sbquo‚&scaronš&sect§&shy &sup1¹&sup2²&sup3³&szligß&thornþ&tilde˜&tim"
 . "es×&trade™&uacuteú&ucircû&ugraveù&uml¨&uumlü&yacuteý&yen¥&yumlÿ"
 $ := RegExReplace( HTM,"<[^>]+>" )               ; Remove all tags between  "<" and ">"
 Loop, Parse, $, &`;                              ; Create a list of special characters
   L := "&" A_LoopField C, R .= (!(A_Index&1)) ? ( (!InStr(R,L,1)) ? L:"" ) : ""
 StringTrimRight, R, R, 1
 Loop, Parse, R , %C%                               ; Parse Special Characters
  If F := InStr( HT, L := A_LoopField )             ; Lookup HT Data
    StringReplace, $,$, %L%%C%, % SubStr( HT,F+StrLen(L), 1 ), All
  Else If ( SubStr( L,2,1)="#" )
    StringReplace, $, $, %L%%C%, % Chr(((SubStr(L,3,1)="x") ? "0" : "" ) SubStr(L,3)), All
Return RegExReplace( $, "(^\s*|\s*$)")            ; Remove leading/trailing white spaces
}