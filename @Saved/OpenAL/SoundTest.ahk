#include al.ahk
#include al_functions.ahk
#include alc_functions.ahk
#include alut.ahk
#include alut_functions.ahk
#Persistent
#SingleInstance, Ignore

OnExit, Exit

hOpenAL32 := DllCall("LoadLibrary", Str, "OpenAL32.dll")
hAlut := DllCall("LoadLibrary", Str, "alut.dll")

NULL := 0

alutInitWithoutContext(NULL,0)
Device := alcOpenDevice("DirectSound3D")
Context := alcCreateContext(Device, NULL)
alcMakeContextCurrent(Context)
alGetError()

; The file must be a .wav file to load it this way. I've read that older
; versions of alut would only load 16-bit mono wav files, but the newest
; version handles 32-bit stereo (at least for me). For other file types
; you have to roll-your-own-loader.
file := "dust.wav"
buffer := alutCreateBufferFromFile(&file)

; Quote out the above and unquote this to play a simple built-in
; sample.
;buffer := alutCreateBufferHelloWorld()

If (buffer = AL_NONE)
{
	a := alutGetErrorString(alutGetError())
	DllCall("MessageBoxA", UInt, 0, UInt, a, UInt, 0, Int, 0)
	ExitApp
}

VarSetCapacity(source,4,0)
alGenSources(1, &source)
source := NumGet(source,0,"UInt")
alSourcei(source, AL_BUFFER, buffer)

; Quote out this line to prevent the sound from looping.
alSourcei(source,AL_LOOPING,1)

alSourcePlay(source)

Return

Esc::ExitApp


; Cleanup
Exit:
	alSourceStop(source)
	alDeleteSources(1, source)
	alDeleteBuffers(1, buffer)
	Context := alcGetCurrentContext()
	Device := alcGetContextsDevice(Context)
	alcMakeContextCurrent(0)
	alcDestroyContext(Context)
	alcCloseDevice(Device)
	alutExit()

	If hOpenAL32
		DllCall("FreeLibrary", UInt, hOpenAL32)
	If hAult
		DllCall("FreeLibrary", UInt, hAult)
ExitApp