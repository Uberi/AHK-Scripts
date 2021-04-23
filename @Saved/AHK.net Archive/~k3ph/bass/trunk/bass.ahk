/*
		BASS Library
		  	by k3ph
			
      special thanks to: Skwire & Lexikos

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
;path (override this as needed)
BASS_DLLPATH := A_ScriptDir . "\"
BASS_DLL_PLUGINPATH := A_ScriptDir . "\"

;bass
BASS_DLL       := "bass.dll"
;effects & handlers
BASS_DLL_TAGS  := "tags.dll"
BASS_DLL_FX    := "bass_fx.dll"
BASS_DLL_VFX   := "bass_vsf.dll"
BASS_DLL_ENC   := "bassenc.dll"
BASS_DLL_MIX   := "bassmix.dll"
BASS_DLL_VIS   := "bass_vis.dll"
BASS_DLL_VST   := "bass_vst.dll"
BASS_DLL_WADSP := "bass_wadsp.dll"
BASS_DLL_VIDEO := "bassvideo.dll"
;format plugins
BASS_DLL_CD    := "basscd.dll"
BASS_DLL_MIDI  := "bassmidi.dll"
BASS_DLL_FLAC  := "bassflac.dll"
BASS_DLL_WMA   := "basswma.dll"
BASS_DLL_WV    := "basswv.dll"
BASS_DLL_AAC   := "bass_aac.dll"
BASS_DLL_APE   := "bass_ape.dll"
BASS_DLL_MPC   := "bass_mpc.dll"
BASS_DLL_AC3   := "bass_ac3.dll"
BASS_DLL_ALAC  := "bass_alac.dll"
BASS_DLL_SPX   := "bass_spx.dll"
BASS_DLL_TTA   := "bass_tta.dll"
BASS_DLL_OFR   := "bass_ofr.dll"

;include effects & handlers
#Include *i %A_ScriptDir%\basstags.ahk
#Include *i %A_ScriptDir%\bassfx.ahk
#Include *i %A_ScriptDir%\bassvfx.ahk
#Include *i %A_ScriptDir%\bassenc.ahk
#Include *i %A_ScriptDir%\bassmix.ahk
#Include *i %A_ScriptDir%\bassvis.ahk
#Include *i %A_ScriptDir%\bassvst.ahk
#Include *i %A_ScriptDir%\basswadsp.ahk
#Include *i %A_ScriptDir%\bassvideo.ahk

;include format plugins
#Include *i %A_ScriptDir%\basscd.ahk
#Include *i %A_ScriptDir%\bassmidi.ahk
#Include *i %A_ScriptDir%\bassflac.ahk
#Include *i %A_ScriptDir%\basswma.ahk
#Include *i %A_ScriptDir%\basswv.ahk
#Include *i %A_ScriptDir%\bassaac.ahk
#Include *i %A_ScriptDir%\bassape.ahk
#Include *i %A_ScriptDir%\bassmpc.ahk
#Include *i %A_ScriptDir%\bassac3.ahk
#Include *i %A_ScriptDir%\bassalac.ahk
#Include *i %A_ScriptDir%\bassspx.ahk
#Include *i %A_ScriptDir%\basstta.ahk
#Include *i %A_ScriptDir%\bassofr.ahk

;native file extension support
BASS_STREAM_FILEFILTER          := "BASS Streamable built-in (*.mp3;*.mp2;*.mp1;*.ogg;*.oga;*.wav;*.aif;*.aiff;*.aifc;)"
BASS_MODULE_FILEFILTER          := "BASS Modules built-in (*.mo3;*.xm;*.mod;*.s3m;*.it;*.mtm;*.umx;)"
BASS_STREAM_EXT                 := RegExReplace(BASS_STREAM_FILEFILTER, "(.*)\(|\)")
BASS_MODULE_EXT                 := RegExReplace(BASS_MODULE_FILEFILTER, "(.*)\(|\)")

;error codes returned by BASS_ErrorGetCode()
BASS_OK                         := 0 ; all is OK
BASS_ERROR_MEM                  := 1 ; memory error
BASS_ERROR_FILEOPEN             := 2 ; can't open the file
BASS_ERROR_DRIVER               := 3 ; can't find a free sound driver
BASS_ERROR_BUFLOST              := 4 ; the sample buffer was lost
BASS_ERROR_HANDLE               := 5 ; invalid handle
BASS_ERROR_FORMAT               := 6 ; unsupported sample format
BASS_ERROR_POSITION             := 7 ; invalid position
BASS_ERROR_INIT                 := 8 ; BASS_Init has not been successfully called
BASS_ERROR_START                := 9 ; BASS_Start has not been successfully called
BASS_ERROR_ALREADY              := 14 ; already initialized/paused/whatever
BASS_ERROR_NOCHAN               := 18 ; can't get a free channel
BASS_ERROR_ILLTYPE              := 19 ; an illegal type was specified
BASS_ERROR_ILLPARAM             := 20 ; an illegal parameter was specified
BASS_ERROR_NO3D                 := 21 ; no 3D support
BASS_ERROR_NOEAX                := 22 ; no EAX support
BASS_ERROR_DEVICE               := 23 ; illegal device number
BASS_ERROR_NOPLAY               := 24 ; not playing
BASS_ERROR_FREQ                 := 25 ; illegal sample rate
BASS_ERROR_NOTFILE              := 27 ; the stream is not a file stream
BASS_ERROR_NOHW                 := 29 ; no hardware voices available
BASS_ERROR_EMPTY                := 31 ; the MOD music has no sequence data
BASS_ERROR_NONET                := 32 ; no internet connection could be opened
BASS_ERROR_CREATE               := 33 ; couldn't create the file
BASS_ERROR_NOFX                 := 34 ; effects are not enabled
BASS_ERROR_NOTAVAIL             := 37 ; requested data is not available
BASS_ERROR_DECODE               := 38 ; the channel is a "decoding channel"
BASS_ERROR_DX                   := 39 ; a sufficient DirectX version is not installed
BASS_ERROR_TIMEOUT              := 40 ; connection timedout
BASS_ERROR_FILEFORM             := 41 ; unsupported file format
BASS_ERROR_SPEAKER              := 42 ; unavailable speaker
BASS_ERROR_VERSION              := 43 ; invalid BASS version (used by add-ons)
BASS_ERROR_CODEC                := 44 ; codec is not available/supported
BASS_ERROR_ENDED                := 45 ; the channel/file has ended
BASS_ERROR_UNKNOWN              := -1 ; some other mystery problem

;BASS_SetConfig options
BASS_CONFIG_BUFFER              := 0 ;
BASS_CONFIG_UPDATEPERIOD        := 1 ;
BASS_CONFIG_GVOL_SAMPLE         := 4 ;
BASS_CONFIG_GVOL_STREAM         := 5 ;
BASS_CONFIG_GVOL_MUSIC          := 6 ;
BASS_CONFIG_CURVE_VOL           := 7 ;
BASS_CONFIG_CURVE_PAN           := 8 ;
BASS_CONFIG_FLOATDSP            := 9 ;
BASS_CONFIG_3DALGORITHM         := 10 ;
BASS_CONFIG_NET_TIMEOUT         := 11 ;
BASS_CONFIG_NET_BUFFER          := 12 ;
BASS_CONFIG_PAUSE_NOPLAY        := 13 ;
BASS_CONFIG_NET_PREBUF          := 15 ;
BASS_CONFIG_NET_PASSIVE         := 18 ;
BASS_CONFIG_REC_BUFFER          := 19 ;
BASS_CONFIG_NET_PLAYLIST        := 21 ;
BASS_CONFIG_MUSIC_VIRTUAL       := 22 ;
BASS_CONFIG_VERIFY              := 23 ;
BASS_CONFIG_UPDATETHREADS       := 24 ;

;BASS_SetConfigPtr options
BASS_CONFIG_NET_AGENT           := 16 ;
BASS_CONFIG_NET_PROXY           := 17 ;

;init flags
BASS_DEVICE_8BITS               := 1 ; use 8 bit resolution, else 16 bit
BASS_DEVICE_MONO                := 2 ; use mono, else stereo
BASS_DEVICE_3D                  := 4 ; enable 3D functionality
BASS_DEVICE_LATENCY             := 256 ; calculate device latency (BASS_INFO struct)
BASS_DEVICE_CPSPEAKERS          := 1024 ; detect speakers via Windows control panel
BASS_DEVICE_SPEAKERS            := 2048 ; force enabling of speaker assignment
BASS_DEVICE_NOSPEAKER           := 4096 ; ignore speaker arrangement

;DirectSound interfaces (for use with BASS_GetDSoundObject)
BASS_OBJECT_DS                  := 1 ; IDirectSound
BASS_OBJECT_DS3DL               := 2 ; IDirectSound3DListener

;BASS_DEVICEINFO flags
BASS_DEVICE_ENABLED             := 1 ;
BASS_DEVICE_DEFAULT             := 2 ;
BASS_DEVICE_INIT                := 4 ;

;BASS_INFO flags (from DSOUND.H)
DSCAPS_CONTINUOUSRATE           := 0x00000010 ; supports all sample rates between min/maxrate
DSCAPS_EMULDRIVER               := 0x00000020 ; device does NOT have hardware DirectSound support
DSCAPS_CERTIFIED                := 0x00000040 ; device driver has been certified by Microsoft
DSCAPS_SECONDARYMONO            := 0x00000100 ; mono
DSCAPS_SECONDARYSTEREO          := 0x00000200 ; stereo
DSCAPS_SECONDARY8BIT            := 0x00000400 ; 8 bit
DSCAPS_SECONDARY16BIT           := 0x00000800 ; 16 bit

;BASS_RECORDINFO flags (from DSOUND.H)
DSCCAPS_EMULDRIVER              := DSCAPS_EMULDRIVER ; device does NOT have hardware DirectSound recording support
DSCCAPS_CERTIFIED               := DSCAPS_CERTIFIED ; device driver has been certified by Microsoft

;define formats field of BASS_RECORDINFO (from MMSYSTEM.H)
WAVE_FORMAT_1M08                := 0x00000001 ; 11.025 kHz, Mono,   8-bit
WAVE_FORMAT_1S08                := 0x00000002 ; 11.025 kHz, Stereo, 8-bit
WAVE_FORMAT_1M16                := 0x00000004 ; 11.025 kHz, Mono,   16-bit
WAVE_FORMAT_1S16                := 0x00000008 ; 11.025 kHz, Stereo, 16-bit
WAVE_FORMAT_2M08                := 0x00000010 ; 22.05  kHz, Mono,   8-bit
WAVE_FORMAT_2S08                := 0x00000020 ; 22.05  kHz, Stereo, 8-bit
WAVE_FORMAT_2M16                := 0x00000040 ; 22.05  kHz, Mono,   16-bit
WAVE_FORMAT_2S16                := 0x00000080 ; 22.05  kHz, Stereo, 16-bit
WAVE_FORMAT_4M08                := 0x00000100 ; 44.1   kHz, Mono,   8-bit
WAVE_FORMAT_4S08                := 0x00000200 ; 44.1   kHz, Stereo, 8-bit
WAVE_FORMAT_4M16                := 0x00000400 ; 44.1   kHz, Mono,   16-bit
WAVE_FORMAT_4S16                := 0x00000800 ; 44.1   kHz, Stereo, 16-bit
BASS_SAMPLE_8BITS               := 1 ; 8 bit
BASS_SAMPLE_FLOAT               := 256 ; 32-bit floating-point
BASS_SAMPLE_MONO                := 2 ; mono
BASS_SAMPLE_LOOP                := 4 ; looped
BASS_SAMPLE_3D                  := 8 ; 3D functionality
BASS_SAMPLE_SOFTWARE            := 16 ; not using hardware mixing
BASS_SAMPLE_MUTEMAX             := 32 ; mute at max distance (3D only)
BASS_SAMPLE_VAM                 := 64 ; DX7 voice allocation & management
BASS_SAMPLE_FX                  := 128 ; old implementation of DX8 effects
BASS_SAMPLE_OVER_VOL            := 0x10000 ; override lowest volume
BASS_SAMPLE_OVER_POS            := 0x20000 ; override longest playing
BASS_SAMPLE_OVER_DIST           := 0x30000 ; override furthest from listener (3D only)
BASS_STREAM_PRESCAN             := 0x20000 ; enable pin-point seeking/length (MP3/MP2/MP1)
BASS_MP3_SETPOS                 := BASS_STREAM_PRESCAN ;
BASS_STREAM_AUTOFREE            := 0x40000 ; automatically free the stream when it stop/ends
BASS_STREAM_RESTRATE            := 0x80000 ; restrict the download rate of internet file streams
BASS_STREAM_BLOCK               := 0x100000 ; download/play internet file stream in small blocks
BASS_STREAM_DECODE              := 0x200000 ; don't play the stream, only decode (BASS_ChannelGetData)
BASS_STREAM_STATUS              := 0x800000 ; give server status info (HTTP/ICY tags) in DOWNLOADPROC
BASS_MUSIC_FLOAT                := BASS_SAMPLE_FLOAT ;
BASS_MUSIC_MONO                 := BASS_SAMPLE_MONO ;
BASS_MUSIC_LOOP                 := BASS_SAMPLE_LOOP ;
BASS_MUSIC_3D                   := BASS_SAMPLE_3D ;
BASS_MUSIC_FX                   := BASS_SAMPLE_FX ;
BASS_MUSIC_AUTOFREE             := BASS_STREAM_AUTOFREE ;
BASS_MUSIC_DECODE               := BASS_STREAM_DECODE ;
BASS_MUSIC_PRESCAN              := BASS_STREAM_PRESCAN ; calculate playback length
BASS_MUSIC_CALCLEN              := BASS_MUSIC_PRESCAN ;
BASS_MUSIC_RAMP                 := 0x200 ; normal ramping
BASS_MUSIC_RAMPS                := 0x400 ; sensitive ramping
BASS_MUSIC_SURROUND             := 0x800 ; surround sound
BASS_MUSIC_SURROUND2            := 0x1000 ; surround sound (mode 2)
BASS_MUSIC_FT2MOD               := 0x2000 ; play .MOD as FastTracker 2 does
BASS_MUSIC_PT1MOD               := 0x4000 ; play .MOD as ProTracker 1 does
BASS_MUSIC_NONINTER             := 0x10000 ; non-interpolated sample mixing
BASS_MUSIC_SINCINTER            := 0x800000 ; sinc interpolated sample mixing
BASS_MUSIC_POSRESET             := 0x8000 ; stop all notes when moving position
BASS_MUSIC_POSRESETEX           := 0x400000 ; stop all notes and reset bmp/etc when moving position
BASS_MUSIC_STOPBACK             := 0x80000 ; stop the music on a backwards jump effect
BASS_MUSIC_NOSAMPLE             := 0x100000 ; don't load the samples
BASS_UNICODE                    := 0x80000000 ;
BASS_RECORD_PAUSE               := 0x8000 ; start recording paused

;speaker assignment flags
BASS_SPEAKER_FRONT              := 0x1000000 ; front speakers
BASS_SPEAKER_REAR               := 0x2000000 ; rear/side speakers
BASS_SPEAKER_CENLFE             := 0x3000000 ; center & LFE speakers (5.1)
BASS_SPEAKER_REAR2              := 0x4000000 ; rear center speakers (7.1)
BASS_SPEAKER_LEFT               := 0x10000000 ; modifier: left
BASS_SPEAKER_RIGHT              := 0x20000000 ; modifier: right
BASS_SPEAKER_FRONTLEFT          := BASS_SPEAKER_FRONT ; or BASS_SPEAKER_LEFT
BASS_SPEAKER_FRONTRIGHT         := BASS_SPEAKER_FRONT ; or BASS_SPEAKER_RIGHT
BASS_SPEAKER_REARLEFT           := BASS_SPEAKER_REAR ; or BASS_SPEAKER_LEFT
BASS_SPEAKER_REARRIGHT          := BASS_SPEAKER_REAR ; or BASS_SPEAKER_RIGHT
BASS_SPEAKER_CENTER             := BASS_SPEAKER_CENLFE ; or BASS_SPEAKER_LEFT
BASS_SPEAKER_LFE                := BASS_SPEAKER_CENLFE ; or BASS_SPEAKER_RIGHT
BASS_SPEAKER_REAR2LEFT          := BASS_SPEAKER_REAR2 ; or BASS_SPEAKER_LEFT
BASS_SPEAKER_REAR2RIGHT         := BASS_SPEAKER_REAR2 ; or BASS_SPEAKER_RIGHT

;DX7 voice allocation & management flags
BASS_VAM_HARDWARE               := 1 ;
BASS_VAM_SOFTWARE               := 2 ;
BASS_VAM_TERM_TIME              := 4 ;
BASS_VAM_TERM_DIST              := 8 ;
BASS_VAM_TERM_PRIO              := 16 ;

;BASS_CHANNELINFO types
BASS_CTYPE_SAMPLE               := 1 ;
BASS_CTYPE_RECORD               := 2 ;
BASS_CTYPE_STREAM               := 0x10000 ;
BASS_CTYPE_STREAM_OGG           := 0x10002 ;
BASS_CTYPE_STREAM_MP1           := 0x10003 ;
BASS_CTYPE_STREAM_MP2           := 0x10004 ;
BASS_CTYPE_STREAM_MP3           := 0x10005 ;
BASS_CTYPE_STREAM_AIFF          := 0x10006 ;
BASS_CTYPE_STREAM_WAV           := 0x40000 ; WAVE flag, LOWORD:=codec
BASS_CTYPE_STREAM_WAV_PCM       := 0x50001 ;
BASS_CTYPE_STREAM_WAV_FLOAT     := 0x50003 ;
BASS_CTYPE_MUSIC_MOD            := 0x20000 ;
BASS_CTYPE_MUSIC_MTM            := 0x20001 ;
BASS_CTYPE_MUSIC_S3M            := 0x20002 ;
BASS_CTYPE_MUSIC_XM             := 0x20003 ;
BASS_CTYPE_MUSIC_IT             := 0x20004 ;
BASS_CTYPE_MUSIC_MO3            := 0x00100 ; MO3 flag

;3D channel modes
BASS_3DMODE_NORMAL              := 0 ; normal 3D processing
BASS_3DMODE_RELATIVE            := 1 ; position is relative to the listener
BASS_3DMODE_OFF                 := 2 ; no 3D processing

;software 3D mixing algorithms (used with BASS_CONFIG_3DALGORITHM)
BASS_3DALG_DEFAULT              := 0 ;
BASS_3DALG_OFF                  := 1 ;
BASS_3DALG_FULL                 := 2 ;
BASS_3DALG_LIGHT                := 3 ;

;EAX environments, use with BASS_SetEAXParameters
EAX_ENVIRONMENT_GENERIC         := 0 ;
EAX_ENVIRONMENT_PADDEDCELL      := 1 ;
EAX_ENVIRONMENT_ROOM            := 2 ;
EAX_ENVIRONMENT_BATHROOM        := 3 ;
EAX_ENVIRONMENT_LIVINGROOM      := 4 ;
EAX_ENVIRONMENT_STONEROOM       := 5 ;
EAX_ENVIRONMENT_AUDITORIUM      := 6 ;
EAX_ENVIRONMENT_CONCERTHALL     := 7 ;
EAX_ENVIRONMENT_CAVE            := 8 ;
EAX_ENVIRONMENT_ARENA           := 9 ;
EAX_ENVIRONMENT_HANGAR          := 10 ;
EAX_ENVIRONMENT_CARPETEDHALLWAY := 11 ;
EAX_ENVIRONMENT_HALLWAY         := 12 ;
EAX_ENVIRONMENT_STONECORRIDOR   := 13 ;
EAX_ENVIRONMENT_ALLEY           := 14 ;
EAX_ENVIRONMENT_FOREST          := 15 ;
EAX_ENVIRONMENT_CITY            := 16 ;
EAX_ENVIRONMENT_MOUNTAINS       := 17 ;
EAX_ENVIRONMENT_QUARRY          := 18 ;
EAX_ENVIRONMENT_PLAIN           := 19 ;
EAX_ENVIRONMENT_PARKINGLOT      := 20 ;
EAX_ENVIRONMENT_SEWERPIPE       := 21 ;
EAX_ENVIRONMENT_UNDERWATER      := 22 ;
EAX_ENVIRONMENT_DRUGGED         := 23 ;
EAX_ENVIRONMENT_DIZZY           := 24 ;
EAX_ENVIRONMENT_PSYCHOTIC       := 25 ;

;total number of environments
EAX_ENVIRONMENT_COUNT           := 26 ;
BASS_STREAMPROC_END             := 0x80000000 ; end of user stream flag

;BASS_StreamCreateFileUser file systems
STREAMFILE_NOBUFFER             := 0 ;
STREAMFILE_BUFFER               := 1 ;
STREAMFILE_BUFFERPUSH           := 2 ;

;BASS_StreamPutFileData options
BASS_FILEDATA_END               := 0 ; end & close the file

;BASS_StreamGetFilePosition modes
BASS_FILEPOS_CURRENT            := 0 ;
BASS_FILEPOS_DECODE             := BASS_FILEPOS_CURRENT ;
BASS_FILEPOS_DOWNLOAD           := 1 ;
BASS_FILEPOS_END                := 2 ;
BASS_FILEPOS_START              := 3 ;
BASS_FILEPOS_CONNECTED          := 4 ;
BASS_FILEPOS_BUFFER             := 5 ;

;BASS_ChannelSetSync types
BASS_SYNC_POS                   := 0 ;
BASS_SYNC_END                   := 2 ;
BASS_SYNC_META                  := 4 ;
BASS_SYNC_SLIDE                 := 5 ;
BASS_SYNC_STALL                 := 6 ;
BASS_SYNC_DOWNLOAD              := 7 ;
BASS_SYNC_FREE                  := 8 ;
BASS_SYNC_SETPOS                := 11 ;
BASS_SYNC_MUSICPOS              := 10 ;
BASS_SYNC_MUSICINST             := 1 ;
BASS_SYNC_MUSICFX               := 3 ;
BASS_SYNC_OGG_CHANGE            := 12 ;
BASS_SYNC_MIXTIME               := 0x40000000 ; FLAG: sync at mixtime, else at playtime
BASS_SYNC_ONETIME               := 0x80000000 ; FLAG: sync only once, else continuously

;BASS_ChannelIsActive return values
BASS_ACTIVE_STOPPED             := 0 ;
BASS_ACTIVE_PLAYING             := 1 ;
BASS_ACTIVE_STALLED             := 2 ;
BASS_ACTIVE_PAUSED              := 3 ;

;channel attributes
BASS_ATTRIB_FREQ                := 1 ;
BASS_ATTRIB_VOL                 := 2 ;
BASS_ATTRIB_PAN                 := 3 ;
BASS_ATTRIB_EAXMIX              := 4 ;
BASS_ATTRIB_MUSIC_AMPLIFY       := 0x100 ;
BASS_ATTRIB_MUSIC_PANSEP        := 0x101 ;
BASS_ATTRIB_MUSIC_PSCALER       := 0x102 ;
BASS_ATTRIB_MUSIC_BPM           := 0x103 ;
BASS_ATTRIB_MUSIC_SPEED         := 0x104 ;
BASS_ATTRIB_MUSIC_VOL_GLOBAL    := 0x105 ;
BASS_ATTRIB_MUSIC_VOL_CHAN      := 0x200 ; + channel #
BASS_ATTRIB_MUSIC_VOL_INST      := 0x300 ; + instrument #

;BASS_ChannelGetData flags
BASS_DATA_AVAILABLE             := 0 ; query how much data is buffered
BASS_DATA_FLOAT                 := 0x40000000 ; flag: return floating-point sample data
BASS_DATA_FFT256                := 0x80000000 ; 256 sample FFT
BASS_DATA_FFT512                := 0x80000001 ; 512 FFT
BASS_DATA_FFT1024               := 0x80000002 ; 1024 FFT
BASS_DATA_FFT2048               := 0x80000003 ; 2048 FFT
BASS_DATA_FFT4096               := 0x80000004 ; 4096 FFT
BASS_DATA_FFT8192               := 0x80000005 ; 8192 FFT
BASS_DATA_FFT_INDIVIDUAL        := 0x10 ; FFT flag: FFT for each channel, else all combined
BASS_DATA_FFT_NOWINDOW          := 0x20 ; FFT flag: no Hanning window

;BASS_ChannelGetTags types : what's returned
BASS_TAG_ID3                    := 0 ; ID3v1 tags : TAG_ID3 structure
BASS_TAG_ID3V2                  := 1 ; ID3v2 tags : variable length block
BASS_TAG_OGG                    := 2 ; OGG comments : series of null-terminated UTF-8 strings
BASS_TAG_HTTP                   := 3 ; HTTP headers : series of null-terminated ANSI strings
BASS_TAG_ICY                    := 4 ; ICY headers : series of null-terminated ANSI strings
BASS_TAG_META                   := 5 ; ICY metadata : ANSI string
BASS_TAG_VENDOR                 := 9 ; OGG encoder : UTF-8 string
BASS_TAG_LYRICS3                := 10 ; Lyric3v2 tag : ASCII string
BASS_TAG_RIFF_INFO              := 0x100 ; RIFF "INFO" tags : series of null-terminated ANSI strings
BASS_TAG_RIFF_BEXT              := 0x101 ; RIFF/BWF Broadcast Audio Extension tags : TAG_BEXT structure
BASS_TAG_MUSIC_NAME             := 0x10000 ;	MOD music name : ANSI string
BASS_TAG_MUSIC_MESSAGE          := 0x10001 ; MOD message : ANSI string
BASS_TAG_MUSIC_INST             := 0x10100 ;	+ instrument #, MOD instrument name : ANSI string
BASS_TAG_MUSIC_SAMPLE           := 0x10300 ; + sample #, MOD sample name : ANSI string

;BASS_ChannelGetLength/GetPosition/SetPosition modes
BASS_POS_BYTE                   := 0 ; byte position
BASS_POS_MUSIC_ORDER            := 1 ; order.row position, MAKELONG(order,row)

;BASS_RecordSetInput flags
BASS_INPUT_OFF                  := 0x10000 ;
BASS_INPUT_ON                   := 0x20000 ;
BASS_INPUT_TYPE_MASK            := 0xFF000000 ;
BASS_INPUT_TYPE_UNDEF           := 0x00000000 ;
BASS_INPUT_TYPE_DIGITAL         := 0x01000000 ;
BASS_INPUT_TYPE_LINE            := 0x02000000 ;
BASS_INPUT_TYPE_MIC             := 0x03000000 ;
BASS_INPUT_TYPE_SYNTH           := 0x04000000 ;
BASS_INPUT_TYPE_CD              := 0x05000000 ;
BASS_INPUT_TYPE_PHONE           := 0x06000000 ;
BASS_INPUT_TYPE_SPEAKER         := 0x07000000 ;
BASS_INPUT_TYPE_WAVE            := 0x08000000 ;
BASS_INPUT_TYPE_AUX             := 0x09000000 ;
BASS_INPUT_TYPE_ANALOG          := 0x0A000000 ;
BASS_FX_DX8_CHORUS              := 0 ;
BASS_FX_DX8_COMPRESSOR          := 1 ;
BASS_FX_DX8_DISTORTION          := 2 ;
BASS_FX_DX8_ECHO                := 3 ;
BASS_FX_DX8_FLANGER             := 4 ;
BASS_FX_DX8_GARGLE              := 5 ;
BASS_FX_DX8_I3DL2REVERB         := 6 ;
BASS_FX_DX8_PARAMEQ             := 7 ;
BASS_FX_DX8_REVERB              := 8 ;
BASS_DX8_PHASE_NEG_180          := 0 ;
BASS_DX8_PHASE_NEG_90           := 1 ;
BASS_DX8_PHASE_ZERO             := 2 ;
BASS_DX8_PHASE_90               := 3 ;
BASS_DX8_PHASE_180              := 4 ;

BASS_Load(){
	global
	BASS_DLLCALL := DllCall("LoadLibrary", Str, BASS_DLLPATH . BASS_DLL)
}

/*
DWORD BASS_GetConfig(
    DWORD option
);
*/
BASS_GetConfig(option){
	global
	Return DllCall(BASS_DLLPATH . BASS_DLL . "\BASS_GetConfig", UInt, option)
}

/*
void BASS_GetConfigPtr(
    DWORD option
);
*/
BASS_GetConfigPtr(option){
	global
	Return DllCall(BASS_DLLPATH . BASS_DLL . "\BASS_GetConfigPtr", UInt, option)
}

/*
BOOL BASS_SetConfig(
    DWORD option,
    DWORD value
);
*/
BASS_SetConfig(option,value){
	global
	Return DllCall(BASS_DLLPATH . BASS_DLL . "\BASS_SetConfig", UInt, option, UInt, value)
}

/*
BOOL BASS_SetConfigPtr(
    DWORD option,
    void *value
);
*/
BASS_SetConfigPtr(option,value){
	global
	Return DllCall(BASS_DLLPATH . BASS_DLL . "\BASS_SetConfigPtr", UInt, option, UInt, value)
}

/*
BOOL BASS_PluginFree(
    HPLUGIN handle
);
*/
BASS_PluginFree(handle){
	global
	Return DllCall(BASS_DLLPATH . BASS_DLL . "\BASS_PluginFree", UInt, handle)
}

/*
BASS_PLUGININFO *BASS_PluginGetInfo(
    HPLUGIN handle
);
*/
BASS_PluginGetInfo(handle){
	global
	Return DllCall(BASS_DLLPATH . BASS_DLL . "\BASS_PluginGetInfo", UInt, handle)
}

/*
HPLUGIN BASS_PluginLoad(
    char *file,
    DWORD flags
);
*/
BASS_PluginLoad(file,flags){
	global
	Return DllCall(BASS_DLLPATH . BASS_DLL . "\BASS_PluginLoad", UInt, &file, UInt, flags)
}

;int BASS_ErrorGetCode();
BASS_ErrorGetCode(){
	global
	Return DllCall(BASS_DLLPATH . BASS_DLL . "\BASS_ErrorGetCode", Int)
}

;BOOL BASS_Free();
BASS_Free(){
	global
	return DllCall(BASS_DLLPATH . BASS_DLL . "\BASS_Free"), DllCall("FreeLibrary", UInt, BASS_DLLCALL)
}

;float WINAPI BASS_GetCPU();
BASS_GetCPU(){
	global
	Return DllCall(BASS_DLLPATH . BASS_DLL . "\BASS_GetCPU", Float)
}

;DWORD BASS_GetDevice(); 
BASS_GetDevice(){
	global
	Return DllCall(BASS_DLLPATH . BASS_DLL . "\BASS_GetDevice")
}

/*
BOOL BASS_GetDeviceInfo(
    DWORD device,
    BASS_DEVICEINFO *info
);
*/
BASS_GetDeviceInfo(device,ByRef info){
	global
	Return DllCall(BASS_DLLPATH . BASS_DLL . "\BASS_GetDeviceInfo", UInt, device, UInt, &info)
}

/*
void *BASS_GetDSoundObject(
    DWORD object
);
*/
BASS_GetDSoundObject(object){
	global
	Return DllCall(BASS_DLLPATH . BASS_DLL . "\BASS_GetDSoundObject", Uint, object)
}

/*
BOOL BASS_GetInfo(
    BASS_INFO *info
);
*/
BASS_GetInfo(ByRef info){
	global
	Return DllCall(BASS_DLLPATH . BASS_DLL . "\BASS_GetInfo", UInt, &info)
}

;DWORD WINAPI BASS_GetVersion(); 
BASS_GetVersion(){
	global
	Return DllCall(BASS_DLLPATH . BASS_DLL . "\BASS_GetVersion")
}

;float BASS_GetVolume();
BASS_GetVolume(){
	global
	Return DllCall(BASS_DLLPATH . BASS_DLL . "\BASS_GetVolume", Float)
}

/*
BOOL BASS_Init(
    int device,
    DWORD freq,
    DWORD flags,
    HWND win,
    GUID *clsid
); 
*/
BASS_Init(device=-1,freq=44100,flags=0,win=0,clsid=0){
	global
	Return DllCall(BASS_DLLPATH . BASS_DLL . "\BASS_Init", Int, device, Int, freq, Int, flags, UInt, win, UInt, clsid)
}

;BOOL BASS_Pause(); 
BASS_Pause(){
	global
	Return DllCall(BASS_DLLPATH . BASS_DLL . "\BASS_Pause", UInt, true)
}

/*
BOOL BASS_SetDevice(
    DWORD device
);
*/
BASS_SetDevice(device){
	global
	Return DllCall(BASS_DLLPATH . BASS_DLL . "\BASS_SetDevice", UInt, device)
}

/*
BOOL BASS_SetVolume(
    float volume
);
volume The volume level... 0 (silent) to 1 (max). 
*/
BASS_SetVolume(volume){
	global
	Return DllCall(BASS_DLLPATH . BASS_DLL . "\BASS_SetVolume", Float, volume)
}

;BOOL BASS_Start();
BASS_Start(){
	global
	Return DllCall(BASS_DLLPATH . BASS_DLL . "\BASS_Start", UInt, true)
}

;BOOL BASS_Stop(); 
BASS_Stop(){
	global
	Return DllCall(BASS_DLLPATH . BASS_DLL . "\BASS_Stop", UInt, true)
}

/*
BOOL BASS_Update(
    DWORD length
);
*/
BASS_Update(length){
	global
	Return DllCall(BASS_DLLPATH . BASS_DLL . "\BASS_Update", UInt, length)
}

;void BASS_Apply3D();
BASS_Apply3D(){
	global
	Return DllCall(BASS_DLLPATH . BASS_DLL . "\BASS_Apply3D")
}

/*
BOOL BASS_Get3DFactors(
    float *distf,
    float *rollf,
    float *doppf
); 
*/
BASS_Get3DFactors(ByRef distf,ByRef rollf,ByRef doppf){
	global
	Return DllCall(BASS_DLLPATH . BASS_DLL . "\BASS_Get3DFactors", Float, &distf, Float, &rollf, Float, &doppf)
}

/*
BOOL BASS_Get3DPosition(
    BASS_3DVECTOR *pos,
    BASS_3DVECTOR *vel,
    BASS_3DVECTOR *front,
    BASS_3DVECTOR *top
);
*/
BASS_Get3DPosition(ByRef pos,ByRef vel,ByRef front,ByRef top){
	global
	Return DllCall(BASS_DLLPATH . BASS_DLL . "\BASS_SampleLoad", UInt, &pos, UInt, &vel, UInt, &front, UInt, &top)
}

/*
BOOL BASS_GetEAXParameters(
    DWORD *env,
    float *vol,
    float *decay
    float *damp
); 
*/
BASS_GetEAXParameters(ByRef env,ByRef vol,ByRef decay,ByRef damp){
	global
	Return DllCall(BASS_DLLPATH . BASS_DLL . "\BASS_GetEAXParameters", UInt, &env, Float, &vol, Float, &decay, Float, &damp)
}

/*
BOOL BASS_Set3DFactors(
    float distf,
    float rollf,
    float doppf
); 
*/
BASS_Set3DFactors(distf,rollf,doppf){
	global
	Return DllCall(BASS_DLLPATH . BASS_DLL . "\BASS_Set3DFactors", Float, distf, Float, rollf Float, doppf)
}

/*
BOOL BASS_SetEAXParameters(
    int env,
    float vol,
    float decay,
    float damp
); 
*/
BASS_SetEAXParameters(env,vol,decay,damp){
	global
	Return DllCall(BASS_DLLPATH . BASS_DLL . "\BASS_SetEAXParameters", Int, env, Float, vol, Float, decay, Float, damp)
}

/*
HSAMPLE BASS_SampleCreate(
    DWORD length,
    DWORD freq,
    DWORD chans,
    DWORD max,
    DWORD flags
);
*/
BASS_SampleCreate(length,fre,chans,max,flags){
	global
	Return DllCall(BASS_DLLPATH . BASS_DLL . "\BASS_SampleCreate", UInt, length, UInt, freq, UInt, chans, UInt, max, UInt, flags)
}

/*
BOOL BASS_SampleFree(
    HSAMPLE handle
);
*/
BASS_SampleFree(handle){
	global
	Return DllCall(BASS_DLLPATH . BASS_DLL . "\BASS_SampleFree", UInt, handle)
}

/*
HCHANNEL BASS_SampleGetChannel(
    HSAMPLE handle,
    BOOL onlynew
); 
*/
BASS_SampleGetChannel(handle,onlynew){
	global
	Return DllCall(BASS_DLLPATH . BASS_DLL . "\BASS_SampleGetChannels", UInt, handle, Int, onlynew)
}

/*
DWORD BASS_SampleGetChannels(
    HSAMPLE handle,
    HCHANNEL *channels
);
*/
BASS_SampleGetChannels(handle,ByRef channels){
	global
	Return DllCall(BASS_DLLPATH . BASS_DLL . "\BASS_SampleGetChannels", UInt, handle, UInt, &channels)
}

/*
BOOL BASS_SampleGetData(
    HSAMPLE handle,
    void *buffer
);
*/
BASS_SampleGetData(handle,ByRef buffer){
	global
	Return DllCall(BASS_DLLPATH . BASS_DLL . "\BASS_SampleGetData", UInt, handle, UInt, buffer)
}

/*
BOOL BASS_SampleGetInfo(
    HSAMPLE handle,
    BASS_SAMPLE *info
);
*/
BASS_SampleGetInfo(handle,ByRef info){
	global
	Return DllCall(BASS_DLLPATH . BASS_DLL . "\BASS_SampleGetInfo", UInt, handle, UInt, &info)
}

/*
HSAMPLE BASS_SampleLoad(
    BOOL mem,
    void *file,
    QWORD offset,
    DWORD length,
    DWORD max,
    DWORD flags
);
*/
BASS_SampleLoad(mem,file,offset,length,max,flags){
	global
	Return DllCall(BASS_DLLPATH . BASS_DLL . "\BASS_SampleLoad", UInt, mem, UInt, file, UInt64, offset, Int, length, UInt, max, UInt, flags)
}

/*
BOOL BASS_SampleSetData(
    HSAMPLE handle,
    void *buffer
); 
*/
BASS_SampleSetData(handle,buffer){
	global
	Return DllCall(BASS_DLLPATH . BASS_DLL . "\BASS_SampleSetData", UInt, handle, UInt, buffer)
}

/*
BOOL BASS_SampleSetInfo(
    HSAMPLE handle,
    BASS_SAMPLE *info
); 
*/
BASS_SampleSetInfo(handle,info){
	global
	Return DllCall(BASS_DLLPATH . BASS_DLL . "\BASS_SampleSetInfo", UInt, handle, UInt, info)
}

/*
BOOL BASS_SampleStop(
    HSAMPLE handle
);
*/
BASS_SampleStop(handle){
	global
	Return DllCall(BASS_DLLPATH . BASS_DLL . "\BASS_SampleStop", UInt, handle)
}

/*
HSTREAM BASS_StreamCreate(
    DWORD freq,
    DWORD chans,
    DWORD flags,
    STREAMPROC *proc,
    void *user
); 
*/
BASS_StreamCreate(freq,chans,flags,proc,user){
	global
	Return DllCall(BASS_DLLPATH . BASS_DLL . "\BASS_StreamCreate", UInt, freq, UInt, chans, UInt, flags, UInt, proc, UInt, user)
}

/*
HSTREAM BASS_StreamCreateFile(
    BOOL mem,
    void *file,
    QWORD offset,
    QWORD length,
    DWORD flags
);
*/
BASS_StreamCreateFile(mem,file,offset,length,flags){
	global
	Return DllCall(BASS_DLLPATH . BASS_DLL . "\BASS_StreamCreateFile", UInt, mem, UInt, file, UInt64, offset, UInt64, length, UInt, flags)
}

/*
HSTREAM BASS_StreamCreateFileUser(
    DWORD system,
    DWORD flags,
    BASS_FILEPROCS *procs,
    void *user
);
*/
BASS_StreamCreateFileUser(system,flags,procs,user){
	global
	Return DllCall(BASS_DLLPATH . BASS_DLL . "\BASS_StreamCreateFileUser", UInt, system, UInt, flags, UInt, procs, UInt, user)
}

/*
HSTREAM BASS_StreamCreateURL(
    char *url,
    DWORD offset,
    DWORD flags,
    DOWNLOADPROC *proc,
    void *user
);
*/
BASS_StreamCreateURL(url,offset,flags,proc,user){
	global
	Return DllCall(BASS_DLLPATH . BASS_DLL . "\BASS_StreamCreateURL", UInt, url, UInt, offset, UInt, flags, UInt, proc, UInt, user)
}

/*
BOOL BASS_StreamFree(
    HSTREAM handle
);
*/
BASS_StreamFree(handle){
	global
	Return DllCall(BASS_DLLPATH . BASS_DLL . "\BASS_StreamFree", UInt, handle)
}

/*
QWORD BASS_StreamGetFilePosition(
    HSTREAM handle,
    DWORD mode
);
*/
BASS_StreamGetFilePosition(handle,mode){
	global
	Return DllCall(BASS_DLLPATH . BASS_DLL . "\BASS_StreamGetFilePosition", UInt, handle, UInt, mode, UInt64)
}

/*
DWORD BASS_StreamPutData(
    HSTREAM handle,
    void *buffer,
    DWORD length
);
*/
BASS_StreamPutData(handle,buffer,length){
	global
	Return DllCall(BASS_DLLPATH . BASS_DLL . "\BASS_StreamPutData", UInt, handle, UInt, buffer, UInt, length)
}

/*
DWORD BASS_StreamPutFileData(
    HSTREAM handle,
    void *buffer,
    DWORD length
);
*/
BASS_StreamPutFileData(handle,buffer,length){
	global
	Return DllCall(BASS_DLLPATH . BASS_DLL . "\BASS_StreamPutFileData", UInt, handle, UInt, buffer, UInt, length)
}

;BOOL BASS_RecordFree();
BASS_RecordFree(){
	global
	Return DllCall(BASS_DLLPATH . BASS_DLL . "\BASS_RecordFree")
}

;DWORD BASS_RecordGetDevice();
BASS_RecordGetDevice(){
	global
	Return DllCall(BASS_DLLPATH . BASS_DLL . "\BASS_RecordGetDevice")
}

/*
BOOL BASS_RecordGetDeviceInfo(
    DWORD device,
    BASS_DEVICEINFO *info
);
*/
BASS_RecordGetDeviceInfo(device,ByRef info){
	global
	Return DllCall(BASS_DLLPATH . BASS_DLL . "\BASS_RecordGetDeviceInfo", UInt, device, UInt, &info)
}

/*
BOOL BASS_RecordGetInfo(
    BASS_RECORDINFO *info
); 
*/
BASS_RecordGetInfo(ByRef info){
	global
	Return DllCall(BASS_DLLPATH . BASS_DLL . "\BASS_RecordGetInfo", UInt, &info)
}

/*
DWORD BASS_RecordGetInput(
    int input,
    float *volume
);
*/
BASS_RecordGetInput(input,ByRef volume){
	global
	Return DllCall(BASS_DLLPATH . BASS_DLL . "\BASS_RecordGetInput", Int, input, Float, &volume)
}

/*
char *BASS_RecordGetInputName(
    int input
);
*/
BASS_RecordGetInputName(input){
	global
	Return DllCall(BASS_DLLPATH . BASS_DLL . "\BASS_RecordGetInputName", Int, input, Str)
}

/*
BOOL BASS_RecordInit(
    int device
);
*/
BASS_RecordInit(device){
	global
	Return DllCall(BASS_DLLPATH . BASS_DLL . "\BASS_RecordInit", Int, device)
}

/*
BOOL BASS_RecordSetDevice(
    DWORD device
);
*/
BASS_RecordSetDevice(device){
	global
	Return DllCall(BASS_DLLPATH . BASS_DLL . "\BASS_RecordSetDevice", UInt, device)
}

/*
BOOL BASS_RecordSetInput(
    int input,
    DWORD flags,
    float volume
);
*/
BASS_RecordSetInput(input,flags,volume){
	global
	Return DllCall(BASS_DLLPATH . BASS_DLL . "\BASS_RecordSetInput", Int, input, UInt, flags, Float, volume)
}

/*
HRECORD BASS_RecordStart(
    DWORD freq,
    DWORD chans,
    DWORD flags,
    RECORDPROC *proc
    void *user
); 
*/
BASS_RecordStart(freq,chans,flags,proc,user){
	global
	Return DllCall(BASS_DLLPATH . BASS_DLL . "\BASS_RecordStart", UInt, freq, UInt, chans, UInt, flags, UInt, proc, UInt, user)
}

/*
BOOL BASS_MusicFree(
    HMUSIC handle
); 
*/
BASS_MusicFree(handle){
	global
	Return DllCall(BASS_DLLPATH . BASS_DLL . "\BASS_MusicFree", UInt, handle)
}

/*
HMUSIC BASS_MusicLoad(
    BOOL mem,
    void *file,
    QWORD offset,
    DWORD length,
    DWORD flags,
    DWORD freq
); 
*/
BASS_MusicLoad(mem,file,offset,length,flags,freq){
	global
	Return DllCall(BASS_DLLPATH . BASS_DLL . "\BASS_MusicLoad", UInt, mem, UInt, file, UInt64, offset, UInt, length, UInt, flags, UInt, freq)
}

/*
double BASS_ChannelBytes2Seconds(
    DWORD handle,
    QWORD pos
);
*/
BASS_ChannelBytes2Seconds(handle,pos){
	global
	Return DllCall(BASS_DLLPATH . BASS_DLL . "\BASS_ChannelBytes2Seconds", UInt, handle, UInt64, pos, Double)
}

/*
BOOL BASS_ChannelGet3DAttributes(
    DWORD handle,
    DWORD *mode,
    float *min,
    float *max,
    DWORD *iangle,
    DWORD *oangle,
    float *outvol
); 
*/
BASS_ChannelGet3DAttributes(handle,ByRef mode,ByRef min,ByRef max,ByRef iangle,ByRef oangle,ByRef outvol){
	global
	Return DllCall(BASS_DLLPATH . BASS_DLL . "\BASS_ChannelGet3DAttributes", UInt, handle, UInt, &mode, Float, &min, Float, &max, UInt, &iangle, UInt, &oangle, UInt, &outvol)
}

/*
BOOL BASS_ChannelGet3DPosition(
    DWORD handle,
    BASS_3DVECTOR *pos,
    BASS_3DVECTOR *orient,
    BASS_3DVECTOR *vel
);
*/
BASS_ChannelGet3DPosition(handle,ByRef pos,ByRef orient,ByRef vel){
	global
	Return DllCall(BASS_DLLPATH . BASS_DLL . "\BASS_ChannelGet3DPosition", UInt, handle, UInt, &pos, UInt, &orient, Uint, &vel)
}

/*
BOOL BASS_ChannelGetAttribute(
    DWORD handle,
    DWORD attrib,
    float *value
); 
*/
BASS_ChannelGetAttribute(handle,attrib,ByRef value){
	global
	Return DllCall(BASS_DLLPATH . BASS_DLL . "\BASS_ChannelGetAttribute", UInt, handle, UInt, attrib, Float, &value)
}

/*
DWORD BASS_ChannelGetData(
    DWORD handle,
    void *buffer,
    DWORD length
); 
*/
BASS_ChannelGetData(handle,ByRef buffer,length){
	global
	Return DllCall(BASS_DLLPATH . BASS_DLL . "\BASS_ChannelGetData", UInt, handle, UInt, &buffer, Uint, length)
}

/*
DWORD BASS_ChannelGetDevice(
    DWORD handle
);
*/
BASS_ChannelGetDevice(handle){
	global
	Return DllCall(BASS_DLLPATH . BASS_DLL . "\BASS_ChannelGetDevice", UInt, handle)
}

/*
BOOL BASS_ChannelGetInfo(
    DWORD handle,
    BASS_CHANNELINFO *info
); 
*/
BASS_ChannelGetInfo(handle,ByRef info){
	global
	Return DllCall(BASS_DLLPATH . BASS_DLL . "\BASS_ChannelGetInfo", UInt, handle, Uint, &info)
}

/*
QWORD BASS_ChannelGetLength(
    DWORD handle,
    DWORD mode
);
*/
BASS_ChannelGetLength(handle,mode){
	global
	Return DllCall(BASS_DLLPATH . BASS_DLL . "\BASS_ChannelGetLength", UInt, handle, UInt, mode, UInt64)
}

/*
DWORD BASS_ChannelGetLevel(
    DWORD handle
);
*/
BASS_ChannelGetLevel(handle){
	global
	Return DllCall(BASS_DLLPATH . BASS_DLL . "\BASS_ChannelGetLevel", UInt, handle)
}

/*
QWORD BASS_ChannelGetPosition(
    DWORD handle,
    DWORD mode
); 
*/
BASS_ChannelGetPosition(handle,mode){
	global
	Return DllCall(BASS_DLLPATH . BASS_DLL . "\BASS_ChannelGetPosition", UInt, handle, UInt, mode, UInt64)
}

/*
char *BASS_ChannelGetTags(
    DWORD handle,
    DWORD tags
);
*/
BASS_ChannelGetTags(handle,tags,return_type="Str"){
	global
	Return DllCall(BASS_DLLPATH . BASS_DLL . "\BASS_ChannelGetTags", UInt, handle, UInt, tags, return_type)
}

BASS_ChannelGetTagsList(handle,tags,delim="`n"){
	ptr := BASS_ChannelGetTags(handle,tags,"Int")
	Loop {
		item := DllCall("MulDiv", Int, ptr, Int, 1, Int, 1, Str)
		if item =
			break
		list .= item delim
		ptr += StrLen(item) + 1
	}
	return SubStr(list,1,-StrLen(delim))
}

/*
DWORD BASS_ChannelIsActive(
    DWORD handle
); 
*/
BASS_ChannelIsActive(handle){
	global
	Return DllCall(BASS_DLLPATH . BASS_DLL . "\BASS_ChannelIsActive", UInt, handle)
}

/*
BOOL BASS_ChannelIsSliding(
    DWORD handle,
    DWORD attrib
);
*/
BASS_ChannelIsSliding(handle,attrib){
	global
	Return DllCall(BASS_DLLPATH . BASS_DLL . "\BASS_ChannelIsSliding", UInt, handle, UInt, attrib)
}

/*
BOOL BASS_ChannelLock(
    DWORD handle,
    BOOL lock
); 
*/
BASS_ChannelLock(handle,lock){
	global
	Return DllCall(BASS_DLLPATH . BASS_DLL . "\BASS_ChannelLock", UInt, handle, UInt, lock)
}

/*
BOOL BASS_ChannelPause(
    DWORD handle
);
*/
BASS_ChannelPause(handle){
	global
	Return DllCall(BASS_DLLPATH . BASS_DLL . "\BASS_ChannelPause", UInt, handle)
}

/*
BOOL BASS_ChannelPlay(
    DWORD handle,
    BOOL restart
); 
*/
BASS_ChannelPlay(handle,restart=0){
	global
	Return DllCall(BASS_DLLPATH . BASS_DLL . "\BASS_ChannelPlay", UInt, handle, Int, restart)
}

/*
BOOL BASS_ChannelRemoveDSP(
    DWORD handle,
    HDSP dsp
);
*/
BASS_ChannelRemoveDSP(handle,dsp){
	global
	Return DllCall(BASS_DLLPATH . BASS_DLL . "\BASS_ChannelRemoveDSP", UInt, handle, UInt, dsp)
}

/*
BOOL BASS_ChannelRemoveFX(
    DWORD handle,
    HFX fx
);
*/
BASS_ChannelRemoveFX(handle,fx){
	global
	Return DllCall(BASS_DLLPATH . BASS_DLL . "\BASS_ChannelRemoveFX", UInt, handle, UInt, fx)
}

/*
BOOL BASS_ChannelRemoveLink(
    DWORD handle,
    DWORD chan
); 
*/
BASS_ChannelRemoveLink(handle,chan){
	global
	Return DllCall(BASS_DLLPATH . BASS_DLL . "\BASS_ChannelRemoveLink", UInt, handle, UInt, chan)
}

/*
BOOL BASS_ChannelRemoveSync(
    DWORD handle,
    HSYNC sync
); 
*/
BASS_ChannelRemoveSync(handle,sync){
	global
	Return DllCall(BASS_DLLPATH . BASS_DLL . "\BASS_ChannelRemoveSync", UInt, handle, UInt, sync)
}

/*
QWORD BASS_ChannelSeconds2Bytes(
    DWORD handle,
    double pos
);
*/
BASS_ChannelSeconds2Bytes(handle,pos){
	global
	Return DllCall(BASS_DLLPATH . BASS_DLL . "\BASS_ChannelSeconds2Bytes", UInt, handle, Double, pos, UInt64)
}

/*
BOOL BASS_ChannelSet3DAttributes(
    DWORD handle,
    int mode,
    float min,
    float max,
    int iangle,
    int oangle,
    float outvol
);
*/
BASS_ChannelSet3DAttributes(handle,mode,min,max,iangle,oangle,outvol){
	global
	Return DllCall(BASS_DLLPATH . BASS_DLL . "\BASS_ChannelSet3DAttributes", UInt, handle, Int, mode, Float, min, Float, max, Int, iangle, Int, oangle, Float, outvol)
}

/*
BOOL BASS_ChannelSet3DPosition(
    DWORD handle,
    BASS_3DVECTOR *pos,
    BASS_3DVECTOR *orient,
    BASS_3DVECTOR *vel
); 
*/
BASS_ChannelSet3DPosition(handle,ByRef pos,ByRef orient,ByRef vel){
	global
	Return DllCall(BASS_DLLPATH . BASS_DLL . "\BASS_ChannelSet3DPosition", UInt, handle, UInt, pos, UInt, orient, UInt, vel)
}

/*
BOOL BASS_ChannelSetAttribute(
    DWORD handle,
    DWORD attrib,
    float value
);
*/
BASS_ChannelSetAttribute(handle,attrib,value){
	global
	Return DllCall(BASS_DLLPATH . BASS_DLL . "\BASS_ChannelSetAttribute", UInt, handle, UInt, attrib, Float, value)
}

/*
BOOL BASS_ChannelSetDevice(
    DWORD handle,
    DWORD device
);
*/
BASS_ChannelSetDevice(handle,device){
	global
	Return DllCall(BASS_DLLPATH . BASS_DLL . "\BASS_ChannelSetDevice", UInt, handle, UInt, device)
}

/*
HDSP BASS_ChannelSetDSP(
    DWORD handle,
    DSPPROC *proc,
    void *user,
    int priority
); 
*/
BASS_ChannelSetDSP(handle,proc,user,priority){
	global
	Return DllCall(BASS_DLLPATH . BASS_DLL . "\BASS_ChannelSetDSP", UInt, handle, UInt, proc, UInt, user, Int, priority)
}

/*
HFX BASS_ChannelSetFX(
    DWORD handle,
    DWORD type,
    int priority
);
*/
BASS_ChannelSetFX(handle,type,priority){
	global
	Return DllCall(BASS_DLLPATH . BASS_DLL . "\BASS_ChannelSetFX", UInt, handle, UInt, type, Int, priority)
}

/*
BOOL BASS_ChannelSetLink(
    DWORD handle,
    DWORD chan
);
*/
BASS_ChannelSetLink(handle,chan){
	global
	Return DllCall(BASS_DLLPATH . BASS_DLL . "\BASS_ChannelSetLink", UInt, handle, UInt, chan)
}

/*
BOOL BASS_ChannelSetPosition(
    DWORD handle,
    QWORD pos,
    DWORD mode
); 
*/
BASS_ChannelSetPosition(handle,pos,mode){
	global
	Return DllCall(BASS_DLLPATH . BASS_DLL . "\BASS_ChannelSetPosition", UInt, handle, UInt64, pos, UInt, mode)
}

/*
HSYNC BASS_ChannelSetSync(
    DWORD handle,
    DWORD type,
    QWORD param,
    SYNCPROC *proc,
    void *user
);
*/
BASS_ChannelSetSync(handle,type,param,proc,user){
	global
	Return DllCall(BASS_DLLPATH . BASS_DLL . "\BASS_ChannelSetSync", UInt, handle, UInt, type, UInt64, param, UInt, proc, UInt, user)
}

/*
BOOL BASS_ChannelSlideAttribute(
    DWORD handle,
    DWORD attrib,
    float value,
    DWORD time
); 
*/
BASS_ChannelSlideAttribute(handle,attrib,value,time){
	global
	Return DllCall(BASS_DLLPATH . BASS_DLL . "\BASS_ChannelSlideAttribute", UInt, handle, UInt, attrib, Float, value, UInt, time)
}

/*
BOOL BASS_ChannelStop(
    DWORD handle
);
*/
BASS_ChannelStop(handle){
	global
	Return DllCall(BASS_DLLPATH . BASS_DLL . "\BASS_ChannelStop", UInt, handle)
}

/*
BOOL BASS_ChannelUpdate(
    DWORD handle,
    DWORD length
);
*/
BASS_ChannelUpdate(handle,length){
	global
	Return DllCall(BASS_DLLPATH . BASS_DLL . "\BASS_ChannelStop", UInt, handle, UInt, length)
}

/*
BOOL BASS_FXGetParameters(
    HFX handle,
    void *params
);
*/
BASS_FXGetParameters(handle,ByRef params){
	global
	Return DllCall(BASS_DLLPATH . BASS_DLL . "\BASS_FXGetParameters", UInt, handle, UInt, &params)
}

/*
BOOL BASS_FXReset(
    DWORD handle
);
*/
BASS_FXReset(handle){
	global
	Return DllCall(BASS_DLLPATH . BASS_DLL . "\BASS_FXReset", UInt, handle)
}

/*
BOOL BASS_FXSetParameters(
    HFX handle,
    void *params
);
*/
BASS_FXSetParameters(handle,ByRef params){
	global
	Return DllCall(BASS_DLLPATH . BASS_DLL . "\BASS_FXSetParameters", UInt, handle, UInt, params)
}