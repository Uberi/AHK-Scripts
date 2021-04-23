/* typedefs for OpenAL variable sizes

	typedef char ALboolean;
	typedef char ALchar;
	typedef char ALbyte;
	typedef unsigned char ALubyte;
	typedef short ALshort;
	typedef unsigned short ALushort;
	typedef int ALint;
	typedef unsigned int ALuint;
	typedef int ALsizei;
	typedef int ALenum;
	typedef float ALfloat;
	typedef double ALdouble;
	typedef void ALvoid;
*/




alEnable(capability) {
	Return DllCall("OpenAL32.dll\alEnable",Int,capability, Cdecl)
}
alDisable(capability) {
	Return DllCall("OpenAL32.dll\alDisable",Int,capability, Cdecl)
}
alIsEnabled(capability) {
	Return DllCall("OpenAL32.dll\alIsEnabled",Int,capability, Cdecl)
}
alGetString(param) {
	Return DllCall("OpenAL32.dll\alGetString",Int,param, Cdecl)
}
alGetBooleanv(param,data) {
	Return DllCall("OpenAL32.dll\alGetBooleanv",Int,param,UInt,data, Cdecl)
}
alGetIntegerv(param,data) {
	Return DllCall("OpenAL32.dll\alGetIntegerv",Int,param,UInt,data, Cdecl)
}
alGetFloatv(param,data) {
	Return DllCall("OpenAL32.dll\alGetFloatv",Int,param,UInt,data, Cdecl)
}
alGetDoublev(param,data) {
	Return DllCall("OpenAL32.dll\alGetDoublev",Int,param,UInt,data, Cdecl)
}
alGetBoolean(param) {
	Return DllCall("OpenAL32.dll\alGetBoolean",Int,param, Cdecl)
}
alGetInteger(param) {
	Return DllCall("OpenAL32.dll\alGetInteger",Int,param, Cdecl)
}
alGetFloat(param) {
	Return DllCall("OpenAL32.dll\alGetFloat",Int,param, Cdecl)
}
alGetDouble(param) {
	Return DllCall("OpenAL32.dll\alGetDouble",Int,param, Cdecl)
}
alGetError() {
	Return DllCall("OpenAL32.dll\alGetError", Cdecl)
}
alIsExtensionPresent(extname) {
	Return DllCall("OpenAL32.dll\alIsExtensionPresent",UInt,extname, Cdecl)
}
alGetProcAddress(fname) {
	Return DllCall("OpenAL32.dll\alGetProcAddress",UInt,fname, Cdecl)
}
alGetEnumValue(ename) {
	Return DllCall("OpenAL32.dll\alGetEnumValue",UInt,ename, Cdecl)
}
alListenerf(param,value) {
	Return DllCall("OpenAL32.dll\alListenerf",Int,param,Float,value, Cdecl)
}
alListener3f(param,value1,value2,value3) {
	Return DllCall("OpenAL32.dll\alListener3f",Int,param,Float,value1,Float,value2,Float,value3, Cdecl)
}
alListenerfv(param,values) {
	Return DllCall("OpenAL32.dll\alListenerfv",Int,param,UInt,values, Cdecl)
}
alListeneri(param,value) {
	Return DllCall("OpenAL32.dll\alListeneri",Int,param,Int,value, Cdecl)
}
alListener3i(param,value1,value2,value3) {
	Return DllCall("OpenAL32.dll\alListener3i",Int,param,Int,value1,Int,value2,Int,value3, Cdecl)
}
alListeneriv(param,values) {
	Return DllCall("OpenAL32.dll\alListeneriv",Int,param,UInt,values, Cdecl)
}
alGetListenerf(param,value) {
	Return DllCall("OpenAL32.dll\alGetListenerf",Int,param,UInt,value, Cdecl)
}
alGetListener3f(param,value1,value2,value3) {
	Return DllCall("OpenAL32.dll\alGetListener3f",Int,param,UInt,value1,UInt,value2,UInt,value3, Cdecl)
}
alGetListenerfv(param,values) {
	Return DllCall("OpenAL32.dll\alGetListenerfv",Int,param,UInt,values, Cdecl)
}
alGetListeneri(param,value) {
	Return DllCall("OpenAL32.dll\alGetListeneri",Int,param,UInt,value, Cdecl)
}
alGetListener3i(param,value1,value2,value3) {
	Return DllCall("OpenAL32.dll\alGetListener3i",Int,param,UInt,value1,UInt,value2,UInt,value3, Cdecl)
}
alGetListeneriv(param,values) {
	Return DllCall("OpenAL32.dll\alGetListeneriv",Int,param,UInt,values, Cdecl)
}
alGenSources(n,sources) {
	Return DllCall("OpenAL32.dll\alGenSources",Int,n,UInt,sources, Cdecl)
}
alDeleteSources(n,sources) {
	Return DllCall("OpenAL32.dll\alDeleteSources",Int,n,UInt,sources, Cdecl)
}
alIsSource(sid) {
  Return DllCall("OpenAL32.dll\alIsSource",UInt,sid, Cdecl)
  }
alSourcef(sid,param,value) {
	Return DllCall("OpenAL32.dll\alSourcef",UInt,sid,Int,param,Float,value, Cdecl)
}
alSource3f(sid,param,value1,value2,value3) {
	Return DllCall("OpenAL32.dll\alSource3f",UInt,sid,Int,param,Float,value1,Float,value2,Float,value3, Cdecl)
}
alSourcefv(sid,param,values) {
	Return DllCall("OpenAL32.dll\alSourcefv",UInt,sid,Int,param,UInt,values, Cdecl)
}
alSourcei(sid,param,value) {
	Return DllCall("OpenAL32.dll\alSourcei",UInt,sid,Int,param,Int,value, Cdecl)
}
alSource3i(sid,param,value1,value2,value3) {
	Return DllCall("OpenAL32.dll\alSource3i",UInt,sid,Int,param,Int,value1,Int,value2,Int,value3, Cdecl)
}
alSourceiv(sid,param,values) {
	Return DllCall("OpenAL32.dll\alSourceiv",UInt,sid,Int,param,UInt,values, Cdecl)
}
alGetSourcef(sid,param,value) {
	Return DllCall("OpenAL32.dll\alGetSourcef",UInt,sid,Int,param,UInt,value, Cdecl)
}
alGetSource3f(sid,param,value1,value2,value3) {
	Return DllCall("OpenAL32.dll\alGetSource3f",UInt,sid,Int,param,UInt,value1,UInt,value2,UInt,value3, Cdecl)
}
alGetSourcefv(sid,param,values) {
	Return DllCall("OpenAL32.dll\alGetSourcefv",UInt,sid,Int,param,UInt,values, Cdecl)
}
alGetSourcei(sid,param,value) {
	Return DllCall("OpenAL32.dll\alGetSourcei",UInt,sid,Int,param,UInt,value, Cdecl)
}
alGetSource3i(sid,param,value1,value2,value3) {
	Return DllCall("OpenAL32.dll\alGetSource3i",UInt,sid,Int,param,UInt,value1,UInt,value2,UInt,value3, Cdecl)
}
alGetSourceiv(sid,param,values) {
	Return DllCall("OpenAL32.dll\alGetSourceiv",UInt,sid,Int,param,UInt,values, Cdecl)
}
alSourcePlayv(ns,sids) {
	Return DllCall("OpenAL32.dll\alSourcePlayv",Int,ns,UInt,sids, Cdecl)
}
alSourceStopv(ns,sids) {
	Return DllCall("OpenAL32.dll\alSourceStopv",Int,ns,UInt,sids, Cdecl)
}
alSourceRewindv(ns,sids) {
	Return DllCall("OpenAL32.dll\alSourceRewindv",Int,ns,UInt,sids, Cdecl)
}
alSourcePausev(ns,sids) {
	Return DllCall("OpenAL32.dll\alSourcePausev",Int,ns,UInt,sids, Cdecl)
}
alSourcePlay(sid) {
	Return DllCall("OpenAL32.dll\alSourcePlay",UInt,sid, Cdecl)
}
alSourceStop(sid) {
	Return DllCall("OpenAL32.dll\alSourceStop",UInt,sid, Cdecl)
}
alSourceRewind(sid) {
	Return DllCall("OpenAL32.dll\alSourceRewind",UInt,sid, Cdecl)
}
alSourcePause(sid) {
	Return DllCall("OpenAL32.dll\alSourcePause",UInt,sid, Cdecl)
}
alSourceQueueBuffers(sid,numEntries,bids) {
	Return DllCall("OpenAL32.dll\alSourceQueueBuffers",UInt,sid,Int,numEntries,UInt,bids, Cdecl)
}
alSourceUnqueueBuffers(sid,numEntries,bids) {
	Return DllCall("OpenAL32.dll\alSourceUnqueueBuffers",UInt,sid,Int,numEntries,UInt,bids, Cdecl)
}
alGenBuffers(n,buffers) {
	Return DllCall("OpenAL32.dll\alGenBuffers",Int,n,UInt,buffers, Cdecl)
}
alDeleteBuffers(n,buffers) {
	Return DllCall("OpenAL32.dll\alDeleteBuffers",Int,n,UInt,buffers, Cdecl)
}
alIsBuffer(bid) {
	Return DllCall("OpenAL32.dll\alIsBuffer",UInt,bid, Cdecl)
}
alBufferData(bid,format,data,size,freq) {
	Return DllCall("OpenAL32.dll\alBufferData",UInt,bid,Int,format,UInt,data,Int,size,Int,freq, Cdecl)
}
alBufferf(bid,param,value) {
	Return DllCall("OpenAL32.dll\alBufferf",UInt,bid,Int,param,Float,value, Cdecl)
}
alBuffer3f(bid,param,value1,value2,value3) {
	Return DllCall("OpenAL32.dll\alBuffer3f",UInt,bid,Int,param,Float,value1,Float,value2,Float,value3, Cdecl)
}
alBufferfv(bid,param,values) {
	Return DllCall("OpenAL32.dll\alBufferfv",UInt,bid,Int,param,UInt,values, Cdecl)
}
alBufferi(bid,param,value) {
	Return DllCall("OpenAL32.dll\alBufferi",UInt,bid,Int,param,Int,value, Cdecl)
}
alBuffer3i(bid,param,value1,value2,value3) {
	Return DllCall("OpenAL32.dll\alBuffer3i",UInt,bid,Int,param,Int,value1,Int,value2,Int,value3, Cdecl)
}
alBufferiv(bid,param,values) {
	Return DllCall("OpenAL32.dll\alBufferiv",UInt,bid,Int,param,UInt,values, Cdecl)
}
alGetBufferf(bid,param,value) {
	Return DllCall("OpenAL32.dll\alGetBufferf",UInt,bid,Int,param,UInt,value, Cdecl)
}
alGetBuffer3f(bid,param,value1,value2,value3) {
	Return DllCall("OpenAL32.dll\alGetBuffer3f",UInt,bid,Int,param,UInt,value1,UInt,value2,UInt,value3, Cdecl)
}
alGetBufferfv(bid,param,values) {
	Return DllCall("OpenAL32.dll\alGetBufferfv",UInt,bid,Int,param,UInt,values, Cdecl)
}
alGetBufferi(bid,param,value) {
	Return DllCall("OpenAL32.dll\alGetBufferi",UInt,bid,Int,param,UInt,value, Cdecl)
}
alGetBuffer3i(bid,param,value1,value2,value3) {
	Return DllCall("OpenAL32.dll\alGetBuffer3i",UInt,bid,Int,param,UInt,value1,UInt,value2,UInt,value3, Cdecl)
}
alGetBufferiv(bid,param,values) {
	Return DllCall("OpenAL32.dll\alGetBufferiv",UInt,bid,Int,param,UInt,values, Cdecl)
}
alDopplerFactor(value) {
	Return DllCall("OpenAL32.dll\alDopplerFactor",Float,value, Cdecl)
}
alDopplerVelocity(value) {
	Return DllCall("OpenAL32.dll\alDopplerVelocity",Float,value, Cdecl)
}
alSpeedOfSound(value) {
	Return DllCall("OpenAL32.dll\alSpeedOfSound",Float,value, Cdecl)
}
alDistanceModel(distanceModel) {
	Return DllCall("OpenAL32.dll\alSpeedOfSound",Int,distanceModel, Cdecl)
}
