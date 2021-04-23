alutInit(argcp,argv) {
	Return DllCall("alut.dll\alutInit",UInt,argcp,UInt,argv, Cdecl)
}
alutInitWithoutContext(argcp,argv) {
	Return DllCall("alut.dll\alutInitWithoutContext",UInt,argcp,UInt,argv, Cdecl)
}
alutExit() {
	Return DllCall("alut.dll\alutExit", Cdecl)
}
alutGetError() {
	Return DllCall("alut.dll\alutGetError", Cdecl)
}
alutGetErrorString(error) {
	Return DllCall("alut.dll\alutGetErrorString",Int,error, Cdecl)
}
alutCreateBufferFromFile(fileName) {
	Return DllCall("alut.dll\alutCreateBufferFromFile",UInt,fileName, Cdecl)
}
alutCreateBufferFromFileImage(data,length) {
	Return DllCall("alut.dll\alutCreateBufferFromFileImage",UInt,data,Int,length, Cdecl)
}
alutCreateBufferHelloWorld() {
	Return DllCall("alut.dll\alutCreateBufferHelloWorld", Cdecl)
}
alutCreateBufferWaveform(waveshape,frequency,phase,duration) {
	Return DllCall("alut.dll\alutCreateBufferWaveform",Int,waveshape,Float,frequency,Float,phase,Float,duration, Cdecl)
}
alutLoadMemoryFromFile(fileName,format,size,frequency) {
	Return DllCall("alut.dll\alutLoadMemoryFromFile",UInt,fileName,UInt,format,UInt,size,UInt,frequency, Cdecl)
}
alutLoadMemoryFromFileImage(data,length,format,size,frequency) {
	Return DllCall("alut.dll\alutLoadMemoryFromFileImage",UInt,data,UInt,length,UInt,format,UInt,size,UInt,frequency, Cdecl)
}
alutLoadMemoryHelloWorld(format,size,frequency) {
	Return DllCall("alut.dll\alutLoadMemoryHelloWorld",UInt,data,UInt,size,UInt,frequency, Cdecl)
}
alutLoadMemoryWaveform(waveshape,frequency,phase,duration,format,size,freq) {
	Return DllCall("alut.dll\alutLoadMemoryWaveform",Int,waveshape,Float,frequency,Float,phase,Float,duration,UInt,format,UInt,size,UInt,freq, Cdecl)
}
alutGetMIMETypes(loader) {
	Return DllCall("alut.dll\alutGetMIMETypes",Int,loader, Cdecl)
}
alutGetMajorVersion() {
	Return DllCall("alut.dll\alutGetMajorVersion", Cdecl)
}
alutGetMinorVersion() {
	Return DllCall("alut.dll\alutGetMinorVersion", Cdecl)
}
alutSleep(duration) {
	Return DllCall("alut.dll\alutSleep",Float,duration, Cdecl)
}

; From the header:
; Nasty Compatibility stuff, WARNING: THESE FUNCTIONS ARE STRONGLY DEPRECATED
alutLoadWAVFile(fileName,format,data,size,frequency,loop) {
	Return DllCall("alut.dll\alutLoadWAVFile",UInt,fileName,UInt,format,UInt,data,UInt,size,UInt,frequency,UInt,loop, Cdecl)
}
alutLoadWAVMemory(buffer,format,data,size,frequency,loop) {
	Return DllCall("alut.dll\alutLoadWAVMemory",UInt,buffer,UInt,format,UInt,data,UInt,size,UInt,frequency,UInt,loop, Cdecl)
}
alutUnloadWAV(format,data,size,frequency) {
	Return DllCall("alut.dll\alutUnloadWAV",Int,format,UInt,data,Int,size,Int,frequency, Cdecl)
}
