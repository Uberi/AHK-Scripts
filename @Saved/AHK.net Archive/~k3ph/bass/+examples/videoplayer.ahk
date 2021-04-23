/*
		BASS Library - VIDEO Player Example
		  	by k3ph
			
      special thanks to: Skwire

    this is an experimental example
    build 00

    < License >
      BASS Library is licensed under BSD.
      http://www.autohotkey.net/~k3ph/license.txt

      BASS is free for non-commercial use.
        If you are a non-commercial entity (eg. an individual) and you are not
      charging for your product, and the	product has no other commercial
      purpose, then you can use BASS in it for free.
        If you wish to use BASS in commercial products, read more details at:
          http://www.un4seen.com
    	
      Usage of BASS and BASS Library indicates that you agree to the above conditions.
    	All trademarks and other registered names contained in the BASS package are the
      property of their respective owners.
*/

#SingleInstance Force
#Persistent
SetBatchLines,-1
Thread, NoTimers

onexit, exit

;debugBIF()
#Include bass.ahk


if !FileExist(BASS_DLLPATH . BASS_DLL)
	msgbox %BASS_DLL% wasn't found in: %BASS_DLLPATH%

if !FileExist(BASS_DLL_PLUGINPATH . BASS_DLL_VIDEO)
	msgbox %BASS_DLL_VIDEO% wasn't found in: %BASS_DLL_PLUGINPATH%
	
BASS_Load()
BASS_Init()

EXT_List:=BASS_VIDEO_EXT
EXT_Filter:=BASS_VIDEO_FILEFILTER
BASS_VIDEO_Init()

gosub video

Gui +LastFound
guid := WinExist()
GroupAdd, equalizer, ahk_id %guid%

#IfWinActive ahk_group videoplayer
	o::gosub open
	!F4::gosub exit
	^F4::reload
	
	i::gosub info
	
  ^c::loop:=false
	c::
    loop:=true
    loop {
      if (loop=1){
        traytip,,% "CPU: " Round( BASS_GetCPU(), 2 )
        sleep 1000
      }
      else {
        traytip
        break
      }
    }
  return
#IfWinActive

/*
VIDEOPROC(
  DWORD handle,
  Action, param1,
  DWORD param2,
  Pointer user,
); stdcall;
*/
videoproc(handle,param=1,param2=0,user=0){
  Critical 100000 ; Checking for messages could lock the thread.
  ; BASSVideo_SetVideoWindow(handle, videowindow, videorect, videonum)
  BASSVideo_SetVideoWindow(handle, 0, 0, 0)
}
return

video:
  Gui,1: Font, s6   , Webdings
  Gui,1: Add, Button,% "x" guiwidth - 120 " y2 w30 h22 0x8000 Center gPlayPause vPlayPause", `;
  Gui,1: Add, Button,% "x" guiwidth - 90 " y2 w30 h22 0x8000 0xC00 Center gStop", <
  Gui,1: Font,
  Gui,1: Add, Button,% "x" guiwidth - 60 " y2 w50 h22 0x8000 0xC00 Center gOpen ", Open
  
	Gui,1: Show,w150 h50
	Gui,1: Submit, NoHide
	goto open
return

PlayPause:
   play:=!play
   if play {
    	if (stream!=0)
        BASS_ChannelPause(stream)
      if (vstream!=0)
        BassVideo_Pause(vstream)
      GuiControl, Text, PlayPause, 4
      Gui,1: Submit, NoHide
   } else {
      if (stream!=0)
        BASS_ChannelPlay(stream,0)
      if (vstream!=0)
        BassVideo_Play(vstream,0)
      
      GuiControl, Text, PlayPause, `;
      Gui,1: Submit, NoHide
   }
return

open:
	gosub stop
	play:=false

  file := CmnDlg_Open( GUI_ID, "Select video file", EXT_Filter, 1, "", defaultExt="", "FILEMUSTEXIST" )
	if file =
	  gosub exit
	else {
	  SplitPath,file,,,ext,,drive

    IfInString, BASS_VIDEO_EXT, %ext%
    {
      videoproccallback := RegisterCallBack("videoproc", "",4)
  		vstream:=BassVideo_StreamCreateFile(&file,BASSVIDEO_AUTO_PAINT+BASSVIDEO_AUTO_RESIZE+BASSVIDEO_AUTO_MOVE+BASSVIDEO_VIDEOEFFECT,0,0,0) ; videoproccallback
    }
		if (vstream!=0)
		  BassVideo_Play(vstream,0)
 	}
return

stop:
  play:=true
	if (vstream!=0)
	 vstop:=BassVideo_Stop(vstream)
return

info:
  msgbox, % "BASS_GetInfo`n flags: " . BASS_INFO_flags . "`n hwsize: " . BASS_INFO_hwsize . "`n hwfree: " . BASS_INFO_hwfree . "`n freesam: " . BASS_INFO_freesam . "`n free3d: " . BASS_INFO_free3d . "`n minrate: " . BASS_INFO_minrate . "`n maxrate: " . BASS_INFO_maxrate . "`n eax: " . BASS_INFO_eax . "`n minbuf: " . BASS_INFO_minbuf . "`n dsver: " . BASS_INFO_dsver . "`n latency: " . BASS_INFO_latency . "`n initflags: " . BASS_INFO_initflags . "`n initflags: " . BASS_INFO_speakers . "`n freq: " . BASS_INFO_freq
return

RemoveTip:
	ToolTip
	TrayTip
Return

; CmnDlg_Open http://www.autohotkey.com/forum/topic26196.html
CmnDlg_Open( hGui=0, Title="Select a Video", Filter="", defaultFilter="", Root="", defaultExt="", flags="FILEMUSTEXIST HIDEREADONLY" ) {
	static OFN_ALLOWMULTISELECT:=0x200, OFN_CREATEPROMPT:=0x2000, OFN_DONTADDTORECENT:=0x2000000, OFN_EXTENSIONDIFFERENT:=0x400, OFN_FILEMUSTEXIST:=0x1000, OFN_FORCESHOWHIDDEN:=0x10000000, OFN_HIDEREADONLY:=0x4, OFN_NOCHANGEDIR:=0x8, OFN_NODEREFERENCELINKS:=0x100000, OFN_NOVALIDATE:=0x100, OFN_OVERWRITEPROMPT:=0x2, OFN_PATHMUSTEXIST:=0x800, OFN_READONLY:=0x1, OFN_SHOWHELP:=0x10, OFN_NOREADONLYRETURN:=0x8000, OFN_NOTESTFILECREATE:=0x10000

	IfEqual, Filter, ,SetEnv, Filter, All Files (*.*)
	SplitPath, Root, RootFile, RootDir

	hFlags := 0x80000								;OFN_ENABLEXPLORER always set
	loop, parse, flags,%A_TAB%%A_SPACE%,%A_TAB%%A_SPACE%
		if A_LoopField !=
			hFlags |= OFN_%A_LoopField%

	VarSetCapacity( FN, 0xffff )
	VarSetCapacity( lpstrFilter, 2*StrLen(filter))
	VarSetCapacity( OFN ,90, 0)

	if RootFile !=
		  DllCall("lstrcpyn", "uint", &FN, "uint", &RootFile, "int", StrLen(RootFile)+1)

	; Contruct FilterText seperate by \0
	delta := 0										;Used by Loop as Offset
	loop, Parse, Filter, |
	{
		desc := A_LoopField,			ext := SubStr(A_LoopField, InStr( A_LoopField,"(" )+1, -1)
		lenD := StrLen(A_LoopField)+1,	lenE := StrLen(ext)+1				;including /0

		DllCall("lstrcpyn", "uint", &lpstrFilter + delta, "uint", &desc, "int", lenD)
		DllCall("lstrcpyn", "uint", &lpstrFilter + delta + lenD, "uint", &ext, "int", lenE)
		delta += lenD + lenE
	}
	NumPut(0, lpstrFilter, delta, "UChar" )  ; Double Zero Termination

	; Contruct OPENFILENAME Structure
	NumPut( 76,				 OFN, 0,  "UInt" )    ; Length of Structure
	NumPut( hGui,			 OFN, 4,  "UInt" )    ; HWND
	NumPut( &lpstrFilter,	 OFN, 12, "UInt" )    ; Pointer to FilterStruc
	NumPut( 0,				 OFN, 16, "UInt" )    ; Pointer to CustomFilter
	NumPut( 0,				 OFN, 20, "UInt" )	  ; MaxChars for CustomFilter
	NumPut( defaultFilter,	 OFN, 24, "UInt" )    ; DefaultFilter Pair
	NumPut( &FN,			 OFN, 28, "UInt" )    ; lpstrFile / InitialisationFileName
	NumPut( 0xffff,			 OFN, 32, "UInt" )    ; MaxFile / lpstrFile length
	NumPut( 0,				 OFN, 36, "UInt" )	  ; lpstrFileTitle
	NumPut( 0,				 OFN, 40, "UInt" )	  ; maxFileTitle
	NumPut( &RootDir,		 OFN, 44, "UInt" )    ; StartDir
	NumPut( &Title,			 OFN, 48, "UInt" )	  ; DlgTitle
	NumPut( hFlags,			 OFN, 52, "UInt" )    ; Flags
	NumPut( &defaultExt,	 OFN, 60, "UInt" )    ; DefaultExt


	res := (*&hGui = 45) ? DllCall("comdlg32\GetSaveFileNameA", "Uint", &OFN ) : DllCall("comdlg32\GetOpenFileNameA", "Uint", &OFN )
	IfEqual, res, 0, return

	adr := &FN,  f := d := DllCall("MulDiv", "Int", adr, "Int",1, "Int",1, "str"), res := ""
	if StrLen(d) != 3			;windows adds \ when in root of the drive and doesn't do that otherwise
		d.="\"
	if ms := InStr(flags, "ALLOWMULTISELECT")
		loop
			if f := DllCall("MulDiv", "Int", adr += StrLen(f)+1, "Int",1, "Int",1, "str")
				res .= d f "`n"
			else {
				 IfEqual, A_Index, 1, SetEnv, res, %d%`n		;if user selects only 1 file with multiselect flag, windows ignores this flag....
				 break
			}

	return ms ? SubStr(res, 1, -1) : SubStr(d, 1, -1)
}
return

guiclose1:
guiescape:
guiclose:
exit:
	if (vstream!=0)
	 vstop:=BassVideo_Stop(vstream)

	BassVideo_Free()
  BASS_Free() ; flush bass
	ExitApp