/*
		BASS Library - ENC Plugin
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
;additional error codes returned by BASS_ErrorGetCode
BASS_ERROR_ACM_CANCEL  := 2000	; ACM codec selection cancelled
BASS_ERROR_CAST_DENIED := 2100	; access denied (invalid password)

;additional BASS_SetConfig options
BASS_CONFIG_ENCODE_PRIORITY     := 0x10300 ; encoder DSP priority
BASS_CONFIG_ENCODE_CAST_TIMEOUT := 0x10310 ; cast timeout

;BASS_Encode_Start flags
BASS_ENCODE_NOHEAD   := 1	; do NOT send a WAV header to the encoder
BASS_ENCODE_FP_8BIT  := 2	; convert floating-point sample data to 8-bit integer
BASS_ENCODE_FP_16BIT := 4	; convert floating-point sample data to 16-bit integer
BASS_ENCODE_FP_24BIT := 6	; convert floating-point sample data to 24-bit integer
BASS_ENCODE_FP_32BIT := 8	; convert floating-point sample data to 32-bit integer
BASS_ENCODE_BIGEND   := 16	; big-endian sample data
BASS_ENCODE_PAUSE    := 32	; start encording paused
BASS_ENCODE_PCM      := 64	; write PCM sample data (no encoder)
BASS_ENCODE_RF64     := 128	; send an RF64 header
BASS_ENCODE_AUTOFREE := 0x40000	; free the encoder when the channel is freed

;BASS_Encode_GetACMFormat flags
BASS_ACM_DEFAULT := 1	; use the format as default selection
BASS_ACM_RATE    := 2	; only list formats with same sample rate as the source channel
BASS_ACM_CHANS   := 4	; only list formats with same number of channels (eg. mono/stereo)
BASS_ACM_SUGGEST := 8	; suggest a format (HIWORD=format tag)

;BASS_Encode_GetCount counts
BASS_ENCODE_COUNT_IN   := 0	; sent to encoder
BASS_ENCODE_COUNT_OUT  := 1	; received from encoder
BASS_ENCODE_COUNT_CAST := 2	; sent to cast server

;BASS_Encode_CastGetStats types
BASS_ENCODE_STATS_SHOUT   := 0	; Shoutcast stats
BASS_ENCODE_STATS_ICE     := 1	; Icecast mount-point stats
BASS_ENCODE_STATS_ICESERV := 2	; Icecast server stats

;encoder notifications
BASS_ENCODE_NOTIFY_ENCODER      := 1	; encoder died
BASS_ENCODE_NOTIFY_CAST         := 2	; cast server connection died
BASS_ENCODE_NOTIFY_CAST_TIMEOUT := 0x10000 ; cast timeout

;BASS_Encode_CastInit content MIME types
BASS_ENCODE_TYPE_MP3 := "audio/mpeg"
BASS_ENCODE_TYPE_OGG := "application/ogg"
BASS_ENCODE_TYPE_AAC := "audio/aacp"

BASS_ENC_Init(){
	global
	BASS_ENC_LOADED := 1
	BASS_ENC_HANDLE := BASS_PluginLoad(BASS_DLL_PLUGINPATH . BASS_DLL_ENC, 0)
	BASS_ENC_DLLCALL := DllCall("LoadLibrary", Str, BASS_DLL_PLUGINPATH . BASS_DLL_ENC)
}

BASS_ENC_Free(){
	global
  BASS_ENC_LOADED := 0
	BASS_PluginFree(BASS_ENC_HANDLE)
	DllCall("FreeLibrary", UInt, BASS_ENC_DLLCALL)
}

;DWORD BASS_Encode_GetVersion(); 
BASS_Encode_GetVersion(){
	global
	Return DllCall(BASS_DLL_PLUGINPATH . BASS_DLL_ENC . "\BASS_Encode_GetVersion")
}

/*
BOOL BASS_Encode_AddChunk(
    DWORD handle,
    char *id,
    void *buffer,
    DWORD length
); 
*/
BASS_Encode_AddChunk(handle,id,buffer,length){
	global
	Return DllCall(BASS_DLL_PLUGINPATH . BASS_DLL_ENC . "\BASS_Encode_AddChunk", UInt, handle, UInt, id, UInt, buffer, UInt, length)
}

/*
DWORD BASS_Encode_GetACMFormat(
    DWORD handle,
    void *form,
    DWORD formlen,
    char *title,
    DWORD flags
); 
*/
BASS_Encode_GetACMFormat(handle,form,formlen,title,flags){
	global
	Return DllCall(BASS_DLL_PLUGINPATH . BASS_DLL_ENC . "\BASS_Encode_GetACMFormat", UInt, handle, UInt, form, UInt, formlen, UInt, title, UInt, flags)
}

/*
QWORD BASS_Encode_GetCount(
    HENCODE handle,
    DWORD count
); 
*/
BASS_Encode_GetCount(handle,count){
	global
	Return DllCall(BASS_DLL_PLUGINPATH . BASS_DLL_ENC . "\BASS_Encode_GetCount", UInt, handle, UInt, count, UInt64)
}

/*
DWORD BASS_Encode_IsActive(
    DWORD handle
); 
*/
BASS_Encode_IsActive(handle){
	global
	Return DllCall(BASS_DLL_PLUGINPATH . BASS_DLL_ENC . "\BASS_Encode_IsActive", UInt, handle)
}

/*
BOOL BASS_Encode_SetChannel(
    DWORD handle,
    DWORD channel
);
*/
BASS_Encode_SetChannel(handle,channel){
	global
	Return DllCall(BASS_DLL_PLUGINPATH . BASS_DLL_ENC . "\BASS_Encode_SetChannel", UInt, handle, UInt, channel)
}

/*
BOOL BASS_Encode_SetNotify(
    DWORD handle,
    ENCODENOTIFYPROC *proc,
    void *user
);
*/
BASS_Encode_SetNotify(handle,proc,user){
	global
	Return DllCall(BASS_DLL_PLUGINPATH . BASS_DLL_ENC . "\BASS_Encode_SetNotify", UInt, handle, UInt, proc, UInt, user)
}

/*
BOOL BASS_Encode_SetPaused(
    DWORD handle,
    BOOL paused
); 
*/
BASS_Encode_SetPaused(paused){
	global
	Return DllCall(BASS_DLL_PLUGINPATH . BASS_DLL_ENC . "\BASS_Encode_SetPaused", UInt, handle, UInt, paused)
}

/*
HENCODE BASS_Encode_Start(
    DWORD handle,
    char *cmdline,
    DWORD flags,
    ENCODEPROC *proc,
    void *user
); 
*/
BASS_Encode_Start(handle,cmdline,flags,proc,user){
	global
	Return DllCall(BASS_DLL_PLUGINPATH . BASS_DLL_ENC . "\BASS_Encode_Start", UInt, handle, UInt, cmdline, UInt, flags, UInt, proc, UInt, user)
}

/*
HENCODE BASS_Encode_StartACM(
    DWORD handle,
    void *form,
    DWORD flags,
    ENCODEPROC *proc,
    void *user
); 
*/
BASS_Encode_StartACM(handle,form,flags,proc,user){
	global
	Return DllCall(BASS_DLL_PLUGINPATH . BASS_DLL_ENC . "\BASS_Encode_StartACM", UInt, handle, UInt, form, UInt, flags, UInt, proc, UInt, user)
}

/*
HENCODE BASS_Encode_StartACMFile(
    DWORD handle,
    void *form,
    DWORD flags,
    char *file
); 
*/
BASS_Encode_StartACMFile(handle,form,flags,file){
	global
	Return DllCall(BASS_DLL_PLUGINPATH . BASS_DLL_ENC . "\BASS_Encode_StartACMFile", UInt, handle, UInt, form, UInt, flags, UInt, file)
}

/*
BOOL BASS_Encode_Stop(
    DWORD handle
);
*/
BASS_Encode_Stop(handle){
	global
	Return DllCall(BASS_DLL_PLUGINPATH . BASS_DLL_ENC . "\BASS_Encode_Stop", UInt, handle)
}

/*
BOOL BASS_Encode_Write(
    DWORD handle,
    void *buffer,
    DWORD length
); 
*/
BASS_Encode_Write(handle,buffer,length){
	global
	Return DllCall(BASS_DLL_PLUGINPATH . BASS_DLL_ENC . "\BASS_Encode_Write", UInt, handle, UInt, buffer, UInt, length)
}

/*
char *BASS_Encode_CastGetStats(
    HENCODE handle
    DWORD type,
    char *pass
); 
*/
BASS_Encode_CastGetStats(handle,type,ByRef pass){
	global
	Return DllCall(BASS_DLL_PLUGINPATH . BASS_DLL_ENC . "\BASS_Encode_CastGetStats", UInt, handle UInt, type, UInt, &pass, Str)
}

/*
BOOL BASS_Encode_CastInit(
    HENCODE handle,
    char *server,
    char *pass,
    char *content,
    char *name,
    char *url,
    char *genre,
    char *desc,
    char *headers,
    DWORD bitrate,
    BOOL pub
);
*/
BASS_Encode_CastInit(handle,server,pass,content,name,url,genre,desc,headers,bitrate,pub){
	global
	Return DllCall(BASS_DLL_PLUGINPATH . BASS_DLL_ENC . "\BASS_Encode_CastInit", UInt, handle, UInt, server, UInt, pass, UInt, content, UInt, name, UInt, url, UInt, genre, UInt, desc, UInt, headers, UInt, bitrate, UInt, pub)
}

/*
BOOL BASS_Encode_CastSetTitle(
    HENCODE handle,
    char *title,
    char *url
);
*/
BASS_Encode_CastSetTitle(handle,title,url){
	global
	Return DllCall(BASS_DLL_PLUGINPATH . BASS_DLL_ENC . "\BASS_Encode_CastSetTitle", UInt, handle, UInt, title, UInt, url)
}