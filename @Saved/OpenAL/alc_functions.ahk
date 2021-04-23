alcCreateContext(device,attrlist) {
	Return DllCall("OpenAL32.dll\alcCreateContext",UInt,device,UInt,attrlist, Cdecl, Cdecl)
}
alcMakeContextCurrent(context) {
	Return DllCall("OpenAL32.dll\alcMakeContextCurrent",UInt,context, Cdecl, Cdecl)
}
alcProcessContext(context) {
	Return DllCall("OpenAL32.dll\alcProcessContext",UInt,context, Cdecl)
}
alcSuspendContext(context) {
	Return DllCall("OpenAL32.dll\alcSuspendContext",UInt,context, Cdecl)
}
alcDestroyContext(context) {
	Return DllCall("OpenAL32.dll\alcDestroyContext",UInt,context, Cdecl)
}
alcGetCurrentContext() {
	Return DllCall("OpenAL32.dll\alcGetCurrentContext", Cdecl)
}
alcGetContextsDevice(context) {
	Return DllCall("OpenAL32.dll\alcGetContextsDevice",UInt,context, Cdecl)
}
alcOpenDevice(devicename) {
	Return DllCall("OpenAL32.dll\alcOpenDevice",UInt,devicename, Cdecl)
}
alcCloseDevice(device) {
	Return DllCall("OpenAL32.dll\alcCloseDevice",UInt,device, Cdecl)
}
alcGetError(device) {
	Return DllCall("OpenAL32.dll\alcGetError",UInt,device, Cdecl)
}
alcIsExtensionPresent(device,extname) {
	Return DllCall("OpenAL32.dll\alcIsExtensionPresent",UInt,device,UInt,extname, Cdecl)
}
alcGetProcAddress(device,funcname) {
	Return DllCall("OpenAL32.dll\alcGetProcAddress",UInt,device,UInt,funcname, Cdecl)
}
alcGetEnumValue(device,enumname) {
	Return DllCall("OpenAL32.dll\alcGetEnumValue",UInt,device,UInt,enumname, Cdecl)
}
alcGetString(device,param) {
	Return DllCall("OpenAL32.dll\alcGetString",UInt,device,Int,param, Cdecl)
}
alcGetIntegerv(device,param,size,data) {
	Return DllCall("OpenAL32.dll\alcGetIntegerv",UInt,device,Int,param,Int,size,UInt,data, Cdecl)
}
alcCaptureOpenDevice(devicename,frequency,format,buffersize) {
	Return DllCall("OpenAL32.dll\alcCaptureOpenDevice",UInt,devicename,UInt,frequency,Int,format,Int,buffersize, Cdecl)
}
alcCaptureCloseDevice(device) {
	Return DllCall("OpenAL32.dll\alcCaptureCloseDevice",UInt,device, Cdecl)
}
alcCaptureStart(device) {
	Return DllCall("OpenAL32.dll\alcCaptureStart",UInt,device, Cdecl)
}
alcCaptureStop(device) {
	Return DllCall("OpenAL32.dll\alcCaptureStop",UInt,device, Cdecl)
}
alcCaptureSamples(device,buffer,samples) {
	Return DllCall("OpenAL32.dll\alcCaptureSamples",UInt,device,UInt,buffer,Int,samples, Cdecl)
}