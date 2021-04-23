/*
		BASS Library - WMA Plugin
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
;file extension support
BASS_WMA_FILEFILTER := "Windows Media Audio (*.wma;*.wmv;*.wmp;*.asf;)"
BASS_WMA_EXT := RegExReplace(BASS_WMA_FILEFILTER, "(.*)\(|\)")

;additional error codes returned by BASS_ErrorGetCode
BASS_ERROR_WMA_LICENSE := 1000 ; the file is protected
BASS_ERROR_WMA := 1001 ; Windows Media (9 or above) is not installed
BASS_ERROR_WMA_WM9 := BASS_ERROR_WMA
BASS_ERROR_WMA_DENIED := 1002 ; access denied (user/pass is invalid)
BASS_ERROR_WMA_INDIVIDUAL := 1004 ; individualization is needed

;additional BASS_SetConfig options
BASS_CONFIG_WMA_PRECHECK := 0x10100
BASS_CONFIG_WMA_PREBUF := 0x10101
BASS_CONFIG_WMA_BASSFILE := 0x10103
BASS_CONFIG_WMA_NETSEEK := 0x10104

;additional WMA sync types
BASS_SYNC_WMA_CHANGE := 0x10100
BASS_SYNC_WMA_META := 0x10101

; additional BASS_StreamGetFilePosition WMA mode
BASS_FILEPOS_WMA_BUFFER := 1000	; internet buffering progress (0-100%)

;additional flags for use with BASS_WMA_EncodeOpen/File/Network/Publish
BASS_WMA_ENCODE_STANDARD := 0x2000	; standard WMA
BASS_WMA_ENCODE_PRO := 0x4000	; WMA Pro
BASS_WMA_ENCODE_24BIT := 0x8000	; 24-bit
BASS_WMA_ENCODE_SCRIPT := 0x20000	; set script (mid-stream tags) in the WMA encoding

;additional flag for use with BASS_WMA_EncodeGetRates
BASS_WMA_ENCODE_RATES_VBR := 0x10000	; get available VBR quality settings

;WMENCODEPROC "type" values
BASS_WMA_ENCODE_HEAD := 0
BASS_WMA_ENCODE_DATA := 1
BASS_WMA_ENCODE_DONE := 2

;BASS_WMA_EncodeSetTag "type" values
BASS_WMA_TAG_ANSI := 0
BASS_WMA_TAG_UNICODE := 1
BASS_WMA_TAG_UTF8 := 2

;BASS_CHANNELINFO type
BASS_CTYPE_STREAM_WMA := 0x10300
BASS_CTYPE_STREAM_WMA_MP3 := 0x10301

;additional BASS_ChannelGetTags types
BASS_TAG_WMA := 8 ; WMA header tags : series of null-terminated UTF-8 strings
BASS_TAG_WMA_META := 11 ; WMA mid-stream tag : UTF-8 string

BASS_WMA_Init(){
	global
	BASS_WMA_LOADED := 1
	BASS_WMA_HANDLE := BASS_PluginLoad(BASS_DLL_PLUGINPATH . BASS_DLL_WMA, 0)
	BASS_WMA_DLLCALL := DllCall("LoadLibrary", Str, BASS_DLL_PLUGINPATH . BASS_DLL_WMA)
}

BASS_WMA_Free(){
  global
  BASS_WMA_LOADED := 0
	BASS_PluginFree(BASS_WMA_HANDLE)
	DllCall("FreeLibrary", UInt, BASS_WMA_DLLCALL)
}

/*
HSTREAM BASS_WMA_StreamCreateFile(
    BOOL mem,
    void *file,
    QWORD offset,
    QWORD length,
    DWORD flags
);
*/
BASS_WMA_StreamCreateFile(mem,file,offset,length,flags){
	global
	Return DllCall(BASS_DLL_PLUGINPATH . BASS_DLL_WMA . "\BASS_WMA_StreamCreateFile", UInt, system, UInt, file, UInt64, offset, UInt64, length, UInt, flags)
}

/*
HSTREAM BASS_WMA_StreamCreateFileAuth(
    BOOL mem,
    void *file,
    QWORD offset,
    QWORD length,
    DWORD flags,
    char *user,
    char *pass
);
*/
BASS_WMA_StreamCreateFileAuth(mem,file,offset,length,flags,user,pass){
	global
	Return DllCall(BASS_DLL_PLUGINPATH . BASS_DLL_WMA . "\BASS_WMA_StreamCreateFileAuth", UInt, system, UInt, file, UInt64, offset, UInt64, length, UInt, flags, Str, user, Str, pass)
}

/*
HSTREAM BASS_WMA_StreamCreateFileUser(
    DWORD system,
    DWORD flags,
    BASS_FILEPROCS *procs,
    void *user
);
*/
BASS_WMA_StreamCreateFileUser(system,flags,procs,user){
	global
	Return DllCall(BASS_DLL_PLUGINPATH . BASS_DLL_WMA . "\BASS_WMA_StreamCreateFileUser", UInt, system, UInt, flags, UInt, procs, UInt, user)
}

/*
BOOL BASS_WMA_EncodeClose(
    HWMENCODE handle
);
*/
BASS_WMA_EncodeClose(handle){
	global
	Return DllCall(BASS_DLL_PLUGINPATH . BASS_DLL_WMA . "\BASS_WMA_EncodeClose", UInt, handle)
}

/*
DWORD BASS_WMA_EncodeGetClients(
    HWMENCODE handle
);
*/
BASS_WMA_EncodeGetClients(handle){
	global
	Return DllCall(BASS_DLL_PLUGINPATH . BASS_DLL_WMA . "\BASS_WMA_EncodeGetClients", UInt, handle)
}

/*
DWORD BASS_WMA_EncodeGetPort(
    HWMENCODE handle
);
*/
BASS_WMA_EncodeGetPort(handle){
	global
	Return DllCall(BASS_DLL_PLUGINPATH . BASS_DLL_WMA . "\BASS_WMA_EncodeGetPort", UInt, handle)
}

/*
DWORD *BASS_WMA_EncodeGetRates(
    DWORD freq,
    DWORD chans,
    DWORD flags
);
*/
BASS_WMA_EncodeGetRates(freq,chans,flags){
	global
	Return DllCall(BASS_DLL_PLUGINPATH . BASS_DLL_WMA . "\BASS_WMA_EncodeGetRates", UInt, freq, UInt, chans, UInt, flags)
}

/*
HWMENCODE BASS_WMA_EncodeOpen(
    DWORD freq,
    DWORD chans,
    DWORD flags,
    DWORD bitrate,
    WMENCODEPROC *proc,
    void *user
);
*/
BASS_WMA_EncodeOpen(freq,chans,flags,bitrate,proc,user){
	global
	Return DllCall(BASS_DLL_PLUGINPATH . BASS_DLL_WMA . "\BASS_WMA_EncodeOpen", UInt, freq, UInt, chans, UInt, flags, UInt, bitrate, UInt, proc, UInt, user)
}

/*
HWMENCODE BASS_WMA_EncodeOpenFile(
    DWORD freq,
    DWORD chans,
    DWORD flags,
    DWORD bitrate,
    char *file
);
*/
BASS_WMA_EncodeOpenFile(freq,chans,flags,bitrate,file){
	global
	Return DllCall(BASS_DLL_PLUGINPATH . BASS_DLL_WMA . "\BASS_WMA_EncodeOpenFile", UInt, freq, UInt, chans, UInt, flags, UInt, bitrate, UInt, file)
}

/*
HWMENCODE BASS_WMA_EncodeOpenNetwork(
    DWORD freq,
    DWORD chans,
    DWORD flags,
    DWORD bitrate,
    DWORD port,
    DWORD clients
);
*/
BASS_WMA_EncodeOpenNetwork(freq,chans,flags,bitrate,port,clients){
	global
	Return DllCall(BASS_DLL_PLUGINPATH . BASS_DLL_WMA . "\BASS_WMA_EncodeOpenNetwork", UInt, freq, UInt, chans, UInt, flags, UInt, bitrate, UInt, port, UInt, clients)
}

/*
HWMENCODE BASS_WMA_EncodeOpenNetworkMulti(
    DWORD freq,
    DWORD chans,
    DWORD flags,
    DWORD *bitrates,
    DWORD port,
    DWORD clients
);
*/
BASS_WMA_EncodeOpenNetworkMulti(freq,chans,flags,bitrates,port,clients){
	global
	Return DllCall(BASS_DLL_PLUGINPATH . BASS_DLL_WMA . "\BASS_WMA_EncodeOpenNetworkMulti", UInt, freq, UInt, chans, UInt, flags, UInt, bitrates, UInt, port, UInt, clients)
}

/*
HWMENCODE BASS_WMA_EncodeOpenPublish(
    DWORD freq,
    DWORD chans,
    DWORD flags,
    DWORD bitrate,
    char *url,
    char *user,
    char *pass
);
*/
BASS_WMA_EncodeOpenPublish(freq,chans,flags,bitrate,url,user,pass){
	global
	Return DllCall(BASS_DLL_PLUGINPATH . BASS_DLL_WMA . "\BASS_WMA_EncodeOpenPublish", UInt, freq, UInt, chans, UInt, flags, UInt, bitrate, UInt, url, Str, user, Str, pass)
}

/*
HWMENCODE BASS_WMA_EncodeOpenPublishMulti(
    DWORD freq,
    DWORD chans,
    DWORD flags,
    DWORD *bitrates,
    char *url,
    char *user,
    char *pass
);
*/
BASS_WMA_EncodeOpenPublishMulti(freq,chans,flags,bitrates,url,user,pass){
	global
	Return DllCall(BASS_DLL_PLUGINPATH . BASS_DLL_WMA . "\BASS_WMA_EncodeOpenPublishMulti", UInt, freq, UInt, chans, UInt, flags, UInt, bitrates, UInt, url, Str, user, Str, pass)
}

/*
BOOL BASS_WMA_EncodeSetNotify(
    HWMENCODE handle,
    CLIENTCONNECTPROC *proc,
    void *user
);
*/
BASS_WMA_EncodeSetNotify(handle,proc,user){
	global
	Return DllCall(BASS_DLL_PLUGINPATH . BASS_DLL_WMA . "\BASS_WMA_EncodeSetNotify", UInt, handle, UInt, proc, UInt, user)
}

/*
BOOL BASS_WMA_EncodeSetTag(
    HWMENCODE handle,
    char *tag,
    char *value,
    DWORD type
);
*/
BASS_WMA_EncodeSetTag(handle,tag,value,type){
	global
	Return DllCall(BASS_DLL_PLUGINPATH . BASS_DLL_WMA . "\BASS_WMA_EncodeSetTag", UInt, handle, Str, tag, Str, value, UInt, type)
}

/*
BOOL BASS_WMA_EncodeWrite(
    HWMENCODE handle,
    void *buffer,
    DWORD length
);
*/
BASS_WMA_EncodeWrite(handle,buffer,length){
	global
	Return DllCall(BASS_DLL_PLUGINPATH . BASS_DLL_WMA . "\BASS_WMA_EncodeWrite", UInt, handle, UInt, buffer, UInt, length)
}

/*
void *BASS_WMA_GetWMObject(
    DWORD handle
);
*/
BASS_WMA_GetWMObject(handle){
	global
	Return DllCall(BASS_DLL_PLUGINPATH . BASS_DLL_WMA . "\BASS_WMA_GetWMObject", UInt, handle)
}