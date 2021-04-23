/*
    BASSMOD Library
      by k3ph

    special thanks to: Titan

    < License >
      BASSMOD Library is licensed under BSD. 
      http://www.autohotkey.net/~k3ph/license.txt
    	
      BASSMOD is free for non-commercial use. If you are a non-commercial entity
    (eg. an individual) and you are not charging for your product, and the
    product has no other commercial purpose, then you can use BASS in it
    for free. If you wish to use BASS in commercial products, please go to
    http://www.un4seen.com and read more details.
      Usage of BASS indicates that you agree to the above conditions.
      All trademarks and other registered names contained in the BASSMOD
    package are the property of their respective owners.

    BASSMOD.dll can be downloaded @ http://www.un4seen.com/download.php?bassmod20
*/
BASSMOD_DLL := "BASSMOD.dll"
BASSMOD_DLLPATH := A_ScriptDir . "\"

BASSMOD_MODULE_FILEFILTER := "BASS Modules built-in (*.xm;*.it;*.s3m;*.mod;*.mtm;*.umx;)"
BASSMOD_MODULE_EXT := RegExReplace(BASS_MODULE_FILEFILTER, "(.*)\(|\)")

BASS_ERROR_NOTAVAIL := 37 ; requested data is not available
BASS_ERROR_DECODE   := 38 ; the channel is a "decoding channel"
BASS_ERROR_FILEFORM := 41; unsupported file format
BASS_ERROR_UNKNOWN  := -1 ; some other mystery error
; Device setup flags
BASS_DEVICE_8BITS    := 1     ; Use 8 bit resolution, else 16 bit.  
BASS_DEVICE_MONO     := 2     ; Use mono, else stereo.  
BASS_DEVICE_NOSYNC   := 4     ; Disable synchronizers. If you are not using any syncs, then you may as well use this flag to save a little CPU time. This is automatic when using the "decode only" device. 
BASS_MUSIC_RAMP      := 1     ; normal ramping
BASS_MUSIC_RAMPS     := 2     ; sensitive ramping
BASS_MUSIC_LOOP      := 4     ; loop music
BASS_MUSIC_FT2MOD    := 16    ; play .MOD as FastTracker 2 does
BASS_MUSIC_PT1MOD    := 32    ; play .MOD as ProTracker 1 does
BASS_MUSIC_POSRESET  := 256   ; stop all notes when moving position
BASS_MUSIC_SURROUND  := 512   ; surround sound
BASS_MUSIC_SURROUND2 := 1024  ; surround sound (mode 2)
BASS_MUSIC_STOPBACK  := 2048  ; stop the music on a backwards jump effect
BASS_MUSIC_CALCLEN	 := 8192  ; calculate playback length
BASS_MUSIC_NONINTER  := 16384 ; non-interpolated mixing
BASS_UNICODE         := 0x80000000

;Sync types (with BASSMOD_MusicSetSync() param and SYNCPROC data definitions) & flags.
BASS_SYNC_MUSICPOS   := 0
BASS_SYNC_POS        := 0

;Sync when the music reaches a position.
; param: LOWORD=order (0=first,-1=all) HIWORD=row (0=first,-1=all)
; data : LOWORD=order HIWORD=row
BASS_SYNC_MUSICINST  := 1

;Sync when an instrument (sample for the non-instrument based formats) is played (not including retrigs).
; param: LOWORD=instrument (1=first) HIWORD=note (0=c0...119=b9, -1=all)
; data : LOWORD=note HIWORD=volume (0-64)
BASS_SYNC_END        := 2

;Sync when the music reaches the end.
; param: not used
; data : 1 = the sync is triggered by a backward jump, otherwise not used
BASS_SYNC_MUSICFX    := 3

;Sync when the "sync" effect (XM/MTM/MOD: E8x/Wxx, IT/S3M: S2x) is used.
;param: 0:data=pos, 1:data="x" value
;data : param=0: LOWORD=order HIWORD=row, param=1: "x" value
BASS_SYNC_ONETIME    := 0x80000000 ; FLAG: sync only once, else continuously

;BASSMOD_MusicIsActive return values
BASS_ACTIVE_STOPPED  := 0
BASS_ACTIVE_PLAYING  := 1
BASS_ACTIVE_PAUSED   := 3

;DWORD WINAPI BASSMOD_ErrorGetCode(); 
BASSMOD_ErrorGetCode(){
  global  
	Return DllCall(BASSMOD_DLLPATH . BASSMOD_DLL . "\BASSMOD_ErrorGetCode")
}
;void WINAPI BASSMOD_Free();
BASSMOD_Free(){
	global
	Return DllCall(BASSMOD_DLLPATH . BASSMOD_DLL . "\BASSMOD_Free", UInt, true),
         DllCall("FreeLibrary", UInt, BassModDll)
}
;float WINAPI BASSMOD_GetCPU();
BASSMOD_GetCPU(){
  global  
	Return DllCall(BASSMOD_DLLPATH . BASSMOD_DLL . "\BASSMOD_GetCPU", Float)
}
/*
char *WINAPI BASSMOD_GetDeviceDescription(
    int devnum
); 
*/
BASSMOD_GetDeviceDescription(){
  global
	Return DllCall(BASSMOD_DLLPATH . BASSMOD_DLL . "\BASSMOD_GetDeviceDescription", Str)
}
;DWORD WINAPI BASSMOD_GetVersion(); 
BASSMOD_GetVersion(){
  global
	Return DllCall(BASSMOD_DLLPATH . BASSMOD_DLL . "\BASSMOD_GetVersion")
}
;int WINAPI BASSMOD_GetVolume();
BASSMOD_GetVolume(){
  global
	Return DllCall(BASSMOD_DLLPATH . BASSMOD_DLL . "\BASSMOD_GetVolume", Int)
}
/*
BOOL WINAPI BASSMOD_Init(
    int device,
    DWORD freq,
    DWORD flags
);
*/
BASSMOD_Init(device=-1,freq=44100,flags=0){
	global
	BassModDll:=DllCall("LoadLibrary", "str", BASSMOD_DLLPATH . BASSMOD_DLL)
	Return DllCall(BASSMOD_DLLPATH . BASSMOD_DLL . "\BASSMOD_Init", Int, device, Int, freq, Int, flags)
}
/*
BOOL WINAPI BASSMOD_SetVolume(
    DWORD volume
); 
range: 0 (min) - 100 (max)
*/
BASSMOD_SetVolume(volume){
  global
	Return DllCall(BASSMOD_DLLPATH . BASSMOD_DLL . "\BASSMOD_SetVolume", Int, volume)
}
/*
DWORD WINAPI BASSMOD_MusicDecode(
    void *buffer,
    DWORD length
); 
*/
BASSMOD_MusicDecode(buffer,length){
  global
	Return DllCall(BASSMOD_DLLPATH . BASSMOD_DLL . "\BASSMOD_MusicDecode", Int, &buffer, Int, length)
}
;void WINAPI BASSMOD_MusicFree();
BASSMOD_MusicFree(){
  global
	Return DllCall(BASSMOD_DLLPATH . BASSMOD_DLL . "\BASSMOD_MusicFree")
}
/*
DWORD WINAPI BASSMOD_MusicGetLength(
    BOOL playlen
);
*/
BASSMOD_MusicGetLength(playlen){
  global
	Return DllCall(BASSMOD_DLLPATH . BASSMOD_DLL . "\BASSMOD_MusicGetLength", UInt, playlen)
}
;char *WINAPI BASSMOD_MusicGetName();
BASSMOD_MusicGetName(){
  global
	Return DllCall(BASSMOD_DLLPATH . BASSMOD_DLL . "\BASSMOD_MusicGetName", Str)
}
;DWORD WINAPI BASSMOD_MusicGetPosition();
BASSMOD_MusicGetPosition(){
  global
	Return DllCall(BASSMOD_DLLPATH . BASSMOD_DLL . "\BASSMOD_MusicGetPosition")
}
/*
DWORD WINAPI BASSMOD_MusicGetVolume(
    DWORD chanins
); 
*/
BASSMOD_MusicGetVolume(){
  global
	Return DllCall(BASSMOD_DLLPATH . BASSMOD_DLL . "\BASSMOD_MusicGetVolume")
}
;DWORD WINAPI BASSMOD_MusicIsActive();
BASSMOD_MusicIsActive(){
  global
	Return DllCall(BASSMOD_DLLPATH . BASSMOD_DLL . "\BASSMOD_MusicIsActive")
}
/*
BOOL WINAPI BASSMOD_MusicLoad(
    BOOL mem,
    void *file,
    DWORD offset,
    DWORD length,
    DWORD flags
); 
*/
BASSMOD_MusicLoad(mem,file,offset,length,flags) {
  global
	Return DllCall(BASSMOD_DLLPATH . BASSMOD_DLL . "\BASSMOD_MusicLoad", UInt, mem, UInt, &file, Int, offset, Int, length, UInt, flags)
}
;BOOL WINAPI BASSMOD_MusicPause(); 
BASSMOD_MusicPause() {
  global
	Return DllCall(BASSMOD_DLLPATH . BASSMOD_DLL . "\BASSMOD_MusicPause")
}
;BOOL WINAPI BASSMOD_MusicPlay();
BASSMOD_MusicPlay() {
  global
	Return DllCall(BASSMOD_DLLPATH . BASSMOD_DLL . "\BASSMOD_MusicPlay")
}
/*
BOOL WINAPI BASSMOD_MusicPlayEx(
    DWORD pos,
    int flags,
    BOOL reset
);
*/
BASSMOD_MusicPlayEx(pos,flags,reset) {
  global
	Return DllCall(BASSMOD_DLLPATH . BASSMOD_DLL . "\BASSMOD_MusicPlayEx", UInt, pos, Int, flags, UInt, reset)
}
/*
BOOL WINAPI BASSMOD_MusicRemoveSync(
    HSYNC sync
);
*/
BASSMOD_MusicRemoveSync() {
  global
	Return DllCall(BASSMOD_DLLPATH . BASSMOD_DLL . "\BASSMOD_MusicRemoveSync")
}
/*
BOOL WINAPI BASSMOD_MusicSetAmplify(
    DWORD amp
);
range: 0 (min) - 100 (max), the default is 50.
*/
BASSMOD_MusicSetAmplify(volume){
  global
	Return DllCall(BASSMOD_DLLPATH . BASSMOD_DLL . "\BASSMOD_MusicSetAmplify", Int, volume)
}
/*
BOOL WINAPI BASSMOD_MusicSetPanSep(
    DWORD pan
);
range: 0 (min) - 100 (max), the default is 50.
*/
BASSMOD_MusicSetPanSep(pan){
  global
	Return DllCall(BASSMOD_DLLPATH . BASSMOD_DLL . "\BASSMOD_MusicSetPanSep", Int, pan)
}
/*
BOOL WINAPI BASSMOD_MusicSetPosition(
    DWORD pos
); 
LOWORD = order
HIWORD = row
If HIWORD = 0xFFFF, then LOWORD = position in seconds.
Setting the position in seconds requires that the BASS_MUSIC_CALCLEN flag was used when the MOD music was loaded.
*/
BASSMOD_MusicSetPosition(pos){
  global
	Return DllCall(BASSMOD_DLLPATH . BASSMOD_DLL . "\BASSMOD_MusicSetPosition", UInt, pos)
}
/*
BOOL WINAPI BASSMOD_MusicSetPositionScaler(
    DWORD scale
); 
*/
BASSMOD_MusicSetPositionScaler(scale){
  global
	Return DllCall(BASSMOD_DLLPATH . BASSMOD_DLL . "\BASSMOD_MusicSetPositionScaler", UInt, scale)
}
/*
HSYNC WINAPI BASSMOD_MusicSetSync(
    DWORD type,
    DWORD param,
    SYNCPROC *proc,
    DWORD user
);
BASS_SYNC_POS Sync when the music reaches a position.
param : LOWORD = order (0=first, -1=all), HIWORD = row (0=first, -1=all). data : LOWORD = order, HIWORD = row.  
BASS_SYNC_END Sync when the music reaches the end. Note that some MOD musics never reach the end, they may jump to another position first. If the BASS_MUSIC_STOPBACK flag is used with a MOD music (through BASSMOD_MusicLoad or BASSMOD_MusicPlayEx), then this sync will also be called when a backward jump effect is played.
param : not used. data : 1 = the sync is triggered by a backward jump in a MOD music, otherwise not used.  
BASS_SYNC_MUSICINST Sync when an instrument (sample for the MOD/S3M/MTM formats) is played (not including retrigs).
param : LOWORD = instrument (1=first), HIWORD = note (0=c0...119=b9, -1=all). data : LOWORD = note, HIWORD = volume (0-64).  
BASS_SYNC_MUSICFX Sync when the sync effect is used. The sync effect is E8x or Wxx for the XM/MTM/MOD formats, and S2x for the IT/S3M formats (where x = any value).
param : 0 = the position is passed to the callback (data : LOWORD = order, HIWORD = row), 1 = the value of x is passed to the callback (data : x value).  
*/
BASSMOD_MusicSetSync(type,param,proc,user){
  global
	Return DllCall(BASSMOD_DLLPATH . BASSMOD_DLL . "\BASSMOD_MusicSetSync", UInt, type, UInt, param, UInt, proc, UInt, user)
}
/*
BOOL WINAPI BASSMOD_MusicSetVolume(
    DWORD chanins,
    DWORD volume
); 
chanins The channel or instrument to set the volume of... 
	if the HIWORD is 0, then the LOWORD is a channel number (0 = 1st channel), else the LOWORD is an instrument number (0 = 1st instument). 
volume The volume level... 0 (min) - 100 (max). 
*/
BASSMOD_MusicSetVolume(chanins,volume) {
  global
	Return DllCall(BASSMOD_DLLPATH . BASSMOD_DLL . "\BASSMOD_MusicSetVolume", UInt, chanins, Int, volume)
}
;BOOL WINAPI BASSMOD_MusicStop();
BASSMOD_MusicStop() {
  global
	Return DllCall(BASSMOD_DLLPATH . BASSMOD_DLL . "\BASSMOD_MusicStop")
}