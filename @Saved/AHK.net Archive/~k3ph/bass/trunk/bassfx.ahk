/*
		BASS Library - FX Plugin
		  	by k3ph
			
      special thanks to: Skwire

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
;error codes returned by BASS_ErrorGetCode()
BASS_ERROR_FX_NODECODE := 4000 ; Not a decoding channel
BASS_ERROR_FX_BPMINUSE := 4001 ; BPM/Beat detection is in use

;Tempo/Reverse/BPM/Beat flag
BASS_FX_FREESOURCE := 0x10000 ; Free the source handle as well?

;Multi-channel order of each channel is as follows:
; 3 channels       left-front, right-front, center.
; 4 channels       left-front, right-front, left-rear/side, right-rear/side.
; 6 channels (5.1) left-front, right-front, center, LFE, left-rear/side, right-rear/side.
; 8 channels (7.1) left-front, right-front, center, LFE, left-rear/side, right-rear/side, left-rear center, right-rear center.
;DSP channels flags
BASS_BFX_CHANALL := -1 ; all channels at once (as by default)
BASS_BFX_CHANNONE := 0 ; disable an effect for all channels
BASS_BFX_CHAN1 := 1 ; left-front channel
BASS_BFX_CHAN2 := 2 ; right-front channel
BASS_BFX_CHAN3 := 4
BASS_BFX_CHAN4 := 8
BASS_BFX_CHAN5 := 16
BASS_BFX_CHAN6 := 32
BASS_BFX_CHAN7 := 64
BASS_BFX_CHAN8 := 128
;more channels!
BASS_BFX_CHAN9  := 256
BASS_BFX_CHAN10 := 512
BASS_BFX_CHAN11 := 1024
BASS_BFX_CHAN12 := 2048
BASS_BFX_CHAN13 := 4096
BASS_BFX_CHAN14 := 8192
BASS_BFX_CHAN15 := 8192
;effects flags
BASS_FX_BFX_ROTATE      := 0x10000 ; A channels volume ping-pong  - stereo
BASS_FX_BFX_ECHO        := 0x10001 ; Echo                         - 2 channels max
BASS_FX_BFX_FLANGER     := 0x10002 ; Flanger                      - multi channel
BASS_FX_BFX_VOLUME      := 0x10003 ; Volume                       - multi channel
BASS_FX_BFX_PEAKEQ      := 0x10004 ; Peaking Equalizer            - multi channel
BASS_FX_BFX_REVERB      := 0x10005 ; Reverb                       - 2 channels max
BASS_FX_BFX_LPF         := 0x10006 ; Low Pass Filter              - multi channel
BASS_FX_BFX_MIX         := 0x10007 ; Swap, remap and mix channels - multi channel
BASS_FX_BFX_DAMP        := 0x10008 ; Dynamic Amplification        - multi channel
BASS_FX_BFX_AUTOWAH     := 0x10009 ; Auto WAH                     - multi channel
BASS_FX_BFX_ECHO2       := 0x1000A ; Echo 2                       - multi channel
BASS_FX_BFX_PHASER      := 0x1000B ; Phaser                       - multi channel
BASS_FX_BFX_ECHO3       := 0x1000C ; Echo 3                       - multi channel
BASS_FX_BFX_CHORUS      := 0x1000D ; Chorus                       - multi channel
BASS_FX_BFX_APF         := 0x1000E ; All Pass Filter              - multi channel
BASS_FX_BFX_COMPRESSOR  := 0x1000F ; Compressor                   - multi channel
BASS_FX_BFX_DISTORTION  := 0x10010 ; Distortion                   - multi channel
BASS_FX_BFX_COMPRESSOR2 := 0x10011 ; Compressor 2                 - multi channel
BASS_FX_BFX_VOLUME_ENV  := 0x10012 ; Volume envelope              - multi channel

;tempo attributes (BASS_ChannelSet/GetAttribute)
BASS_ATTRIB_TEMPO := 0x10000
BASS_ATTRIB_TEMPO_PITCH := 0x10001
BASS_ATTRIB_TEMPO_FREQ := 0x10002

;tempo attributes options
BASS_ATTRIB_TEMPO_OPTION_USE_AA_FILTER    := 0x10010 ; TRUE / FALSE
BASS_ATTRIB_TEMPO_OPTION_AA_FILTER_LENGTH := 0x10011 ; 32 default ([8,128] taps)
BASS_ATTRIB_TEMPO_OPTION_USE_QUICKALGO    := 0x10012 ; TRUE / FALSE
BASS_ATTRIB_TEMPO_OPTION_SEQUENCE_MS      := 0x10013 ; 82 default
BASS_ATTRIB_TEMPO_OPTION_SEEKWINDOW_MS    := 0x10014 ; 14 default
BASS_ATTRIB_TEMPO_OPTION_OVERLAP_MS       := 0x10015 ; 12 default

;reverse attribute (BASS_ChannelSet/GetAttribute)
;notes: 1. MODs won't load without BASS_MUSIC_PRESCAN flag.
;       2. Enable Reverse supported flags in BASS_FX_ReverseCreate and the others to source handle.
BASS_ATTRIB_REVERSE_DIR := 0x11000

;playback directions
BASS_FX_RVS_REVERSE := -1
BASS_FX_RVS_FORWARD := 1

;bpm flags
BASS_FX_BPM_BKGRND := 1 ; if in use, then you can do other processing while detection's in progress. Not available in MacOSX yet. (BPM/Beat)
BASS_FX_BPM_MULT2 := 2 ; if in use, then will auto multiply bpm by 2 (if BPM < minBPM*2)

;translation options
BASS_FX_BPM_TRAN_X2 := 0 ; multiply the original BPM value by 2 (may be called only once & will change the original BPM as well!)
BASS_FX_BPM_TRAN_2FREQ := 1 ; BPM value to Frequency
BASS_FX_BPM_TRAN_FREQ2 := 2 ; Frequency to BPM value
BASS_FX_BPM_TRAN_2PERCENT := 3 ; BPM value to Percents
BASS_FX_BPM_TRAN_PERCENT2 := 4 ; Percents to BPM value

BASS_FX_Init(){
	global
	BASS_FX_LOADED := 1
	BASS_FX_HANDLE := BASS_PluginLoad(BASS_DLL_PLUGINPATH . BASS_DLL_FX, 0)
	BASS_FX_DLLCALL := DllCall("LoadLibrary", Str, BASS_DLL_PLUGINPATH . BASS_DLL_FX)
}

BASS_FX_Free(){
	global
  BASS_FX_LOADED := 0
	BASS_PluginFree(BASS_FX_HANDLE)
	DllCall("FreeLibrary", UInt, BASS_FX_DLLCALL)
}

/*
HFX BASS_ChannelSetFX(
    DWORD handle,
    DWORD type,
    int priority
);
*/
/*
BASS_ChannelSetFX(handle,type,priority){
	global
	Return DllCall(BASS_DLL_PLUGINPATH . BASS_DLL_FX . "\BASS_ChannelSetFX", UInt, handle, UInt, type, Int, priority)
}
*/

/*
BOOL BASS_ChannelRemoveFX(
    DWORD handle,
    HFX fx
);
*/
/*
BASS_ChannelRemoveFX(handle,fx){
	global
	Return DllCall(BASS_DLL_PLUGINPATH . BASS_DLL_FX . "\BASS_ChannelRemoveFX", UInt, handle, UInt, fx)
}
*/


/*
BOOL BASS_FXGetParameters(
    HFX handle,
    void *params
);
*/
/*
BASS_FXGetParameters(handle,params){
	global
	Return DllCall(BASS_DLL_PLUGINPATH . BASS_DLL_FX . "\BASS_FXGetParameters", UInt, handle, UInt, params)
}
*/

/*
BOOL BASS_FXReset(
    DWORD handle
);
*/
/*
BASS_FXReset(handle){
	global
	Return DllCall(BASS_DLL_PLUGINPATH . BASS_DLL_FX . "\BASS_FXReset", UInt, handle)
}
*/

/*
HSTREAM BASS_FX_TempoCreate(
    DWORD chan,
    DWORD flags
);
*/
BASS_FX_TempoCreate(chan,flags){
	global
	Return DllCall(BASS_DLL_PLUGINPATH . BASS_DLL_FX . "\BASS_FX_TempoCreate", UInt, chan, UInt, flags)
}

/*
DWORD BASS_FX_TempoGetSource(
    DWORD chan
);
*/
BASS_FX_TempoGetSource(chan){
	global
	Return DllCall(BASS_DLL_PLUGINPATH . BASS_DLL_FX . "\BASS_FX_TempoGetSource", UInt, chan)
}

/*
float BASS_FX_TempoGetRateRatio(
    DWORD chan
);
*/
BASS_FX_TempoGetRateRatio(chan){
	global
	Return DllCall(BASS_DLL_PLUGINPATH . BASS_DLL_FX . "\BASS_FX_TempoGetRateRatio", UInt, chan, Float)
}

/*
HSTREAM BASS_FX_ReverseCreate(
    DWORD chan,
    float dec_block,
    DWORD flags
);
*/
BASS_FX_ReverseCreate(chan,dec_block,flags){
	global
	Return DllCall(BASS_DLL_PLUGINPATH . BASS_DLL_FX . "\BASS_FX_ReverseCreate", UInt, chan, Float, dec_block, UInt, flags)
}

/*
DWORD BASS_FX_ReverseGetSource(
    DWORD chan
);
*/
BASS_FX_ReverseGetSource(chan){
	global
	Return DllCall(BASS_DLL_PLUGINPATH . BASS_DLL_FX . "\BASS_FX_ReverseGetSource", UInt, chan)
}

/*
float BASS_FX_BPM_DecodeGet(
    DWORD chan,
    double startSec,
    double endSec,
    DWORD minMaxBPM,
    DWORD flags,
    BPMPROCESSPROC *proc
);
*/
BASS_FX_BPM_DecodeGet(chan,startSec,endSec,minMaxBPM,flags,proc){
	global
	Return DllCall(BASS_DLL_PLUGINPATH . BASS_DLL_FX . "\BASS_FX_BPM_DecodeGet", UInt, chan, Double, startSec, Double, endSec, UInt, minMaxBPM, UInt, flags, UInt, proc, Float)
}

/*
BOOL BASS_FX_BPM_CallbackSet(
    DWORD handle,
    BPMPROC *proc,
    double period,
    DWORD minMaxBPM,
    DWORD flags,
    DWORD user
);
*/
BASS_FX_BPM_CallbackSet(handle,proc,period,minMaxBPM,flags,user){
	global
	Return DllCall(BASS_DLL_PLUGINPATH . BASS_DLL_FX . "\BASS_FX_BPM_CallbackSet", UInt, handle, UInt, proc, Double, period, UInt, minMaxBPM, UInt, flags, UInt, user)
}

/*
BOOL BASS_FX_BPM_CallbackReset(
    DWORD handle
);
*/
BASS_FX_BPM_CallbackReset(handle){
	global
	Return DllCall(BASS_DLL_PLUGINPATH . BASS_DLL_FX . "\BASS_FX_BPM_CallbackReset", UInt, handle)
}

/*
float BASS_FX_BPM_Translate(
    DWORD handle,
    float val2tran,
    DWORD trans
);
*/
BASS_FX_BPM_Translate(handle,val2tran,trans){
	global
	Return DllCall(BASS_DLL_PLUGINPATH . BASS_DLL_FX . "\BASS_FX_BPM_Translate", UInt, handle, FLoat, val2tran, UInt, trans)
}

/*
BOOL BASS_FX_BPM_Free(
    DWORD handle
);
*/
BASS_FX_BPM_Free(handle){
	global
	Return DllCall(BASS_DLL_PLUGINPATH . BASS_DLL_FX . "\BASS_FX_BPM_Free", UInt, handle)
}

/*
BOOL BASS_FX_BPM_BeatDecodeGet(
    DWORD chan,
    double startSec,
    double endSec,
    DWORD flags,
    BPMBEATPROC *proc,
    void *user
);
*/
BASS_FX_BPM_BeatDecodeGet(chan,startSec,endSec,flags,proc,user){
	global
	Return DllCall(BASS_DLL_PLUGINPATH . BASS_DLL_FX . "\BASS_FX_BPM_BeatDecodeGet", UInt, chan, Double, startSec, Double, endSec, UInt, flags, UInt, proc, UInt, user)
}

/*
BOOL BASS_FX_BPM_BeatCallbackSet(
    DWORD handle,
    BPMBEATPROC *proc,
    void *user
);
*/
BASS_FX_BPM_BeatCallbackSet(handle,proc,user){
	global
	Return DllCall(BASS_DLL_PLUGINPATH . BASS_DLL_FX . "\BASS_FX_BPM_BeatCallbackSet", UInt, handle, UInt, proc, UInt, user)
}

/*
BOOL BASS_FX_BPM_BeatCallbackReset(
    DWORD handle
);
*/
BASS_FX_BPM_BeatCallbackReset(handle){
	global
	Return DllCall(BASS_DLL_PLUGINPATH . BASS_DLL_FX . "\BASS_FX_BPM_BeatCallbackReset", UInt, handle)
}

/*
BOOL BASS_FX_BPM_BeatSetParameters(
    DWORD handle,
    float bandwidth,
    float centerfreq,
    float beat_rtime
);
*/
BASS_FX_BPM_BeatSetParameters(handle,bandwidth,centerfreq,beat_rtime){
	global
	Return DllCall(BASS_DLL_PLUGINPATH . BASS_DLL_FX . "\BASS_FX_BPM_BeatSetParameters", UInt, handle, Float, bandwidth, Float, centerfreq, Float, beat_rtime)
}

/*
BOOL BASS_FX_BPM_BeatGetParameters(
    DWORD handle,
    float *bandwidth,
    float *centerfreq,
    float *beat_rtime
);
*/
FX_BPM_BeatGetParameters(handle,ByRef bandwidth,ByRef centerfreq,ByRef beat_rtime){
	global
	Return DllCall(BASS_DLL_PLUGINPATH . BASS_DLL_FX . "\FX_BPM_BeatGetParameters", UInt, handle, Float, &bandwidth, Float, &centerfreq, Float, &beat_rtime)
}

/*
BOOL BASS_FX_BPM_BeatFree(
    DWORD handle
);
*/
BASS_FX_BPM_BeatFree(handle){
	global
	Return DllCall(BASS_DLL_PLUGINPATH . BASS_DLL_FX . "\BASS_FX_BPM_BeatFree", UInt, handle)
}
