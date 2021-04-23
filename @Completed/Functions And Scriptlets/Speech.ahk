;AHK v1
#NoEnv

/*
Speak("Hello, World!")
Speak("This is a test...",1,1,1)
Speak("The word <emph>hello</emph> is spelled as <spell>hello</spell>",1,0,1,1)
ExitApp
*/

/*
;AHK_L version
;http://msdn.microsoft.com/en-us/library/ms723602(v=vs.85)
cSpeech := ComObjCreate("SAPI.SpVoice")
cSpeech.Rate := 0 ;rate of speech: -10 (slowest) to 10 (fastest)
cSpeech.Priority := 0 ;speech priority: 0 (normal), 1 (alert), 2 (over)
cSpeech.Status.RunningState ;current speaking status: 1 (done), 2 (speaking)

Voices := cSpeech.GetVoices() ;obtain a collection of voices
Voice.Count ;number of voices
Voice := Voices.Item(1) ;obtain the first voice
cSpeech.Voice := Voice ;speech voice: voice object

cSpeech.Pause() ;pause speech
cSpeech.Resume() ;resume speech

cSpeech.Volume := 50 ;speech volume: 0 (lowest) to 100 (highest)

cSpeech.Speak("forty four")

Flags := 0 ;speech flags: see Speech() code for possible values
cSpeech.Speak("fifty five",Flags)
*/

Speak(SpeechText,Wait = 1,SpeakPunctuation = 0,Queue = 1,UseXML = 0) ;The text to speak, Whether or not to wait for the speaking to complete before returning, Whether or not to say punctuation out loud as words, Whether or not to clear any other pending speak requests before speaking, Whether or not to interpret the input text as XML (0 to specify plain text, 1 to specify XML, and 2 to specify XML and persist any changes made across separate calls of the function)
{
 static pSpeak, ppVoice
 UPtr := A_PtrSize ? "UPtr" : "UInt"

 ;process options
 Flags := 0 ;SPF_DEFAULT
 If !Wait
  Flags |= 1 ;SPF_ASYNC
 If SpeakPunctuation
  Flags |= 64 ;SPF_NLP_SPEAK_PUNC
 If !Queue
  Flags |= 2 ;SPF_PURGEBEFORESPEAK
 If UseXML = 1
  Flags |= 8 ;SPF_IS_XML
 Else If UseXML = 2
  Flags |= 32 ;SPF_PERSIST_XML
 Else
  Flags |= 16 ;SPF_IS_NOT_XML

 If !A_IsUnicode ;convert the text to UTF-16 if it is not already in the required format
  Temp1 := SpeechText, Length := StrLen(SpeechText) + 1, VarSetCapacity(SpeechText,Length << 1,0), DllCall("MultiByteToWideChar","UInt",0,"UInt",0,UPtr,&Temp1,"Int",-1,UPtr,&SpeechText,"Int",Length) ;StrPut(Temp1,&SpeechText,Length,"UTF-16")

 ;initialize resources
 If !ppVoice
 {
  hOLE := DllCall("LoadLibrary","Str","ole32.dll")
  If (!hOLE || DllCall("ole32\CoInitialize","UInt",0) > 1)
   Return, 1
  CLSIDString := "{96749377-3391-11D2-9EE3-00C04F797396}", IIDString := "{269316D8-57BD-11D2-9EEE-00C04F797396}"
  If !A_IsUnicode
  {
   Length := StrLen(CLSIDString) + 1, Temp1 := CLSIDString, VarSetCapacity(CLSIDString,Length << 1), DllCall("MultiByteToWideChar","UInt",0,"UInt",0,UPtr,&Temp1,"Int",-1,UPtr,&CLSIDString,"Int",Length) ;StrPut(Temp1,&CLSIDString,Length,"UTF-16")
   Length := StrLen(IIDString) + 1, Temp1 := IIDString, VarSetCapacity(IIDString,Length << 1), DllCall("MultiByteToWideChar","UInt",0,"UInt",0,UPtr,&Temp1,"Int",-1,UPtr,&IIDString,"Int",Length) ;StrPut(Temp1,&IIDString,Length,"UTF-16")
  }
  VarSetCapacity(CLSIDVoice,16), VarSetCapacity(IIDVoice,16)
  If (DllCall("ole32\CLSIDFromString",UPtr,&CLSIDString,UPtr,&CLSIDVoice) || DllCall("ole32\IIDFromString",UPtr,&IIDString,UPtr,&IIDVoice) || DllCall("ole32\CoCreateInstance",UPtr,&CLSIDVoice,"UInt",0,"UInt",1,UPtr,&IIDVoice,UPtr . "*",ppVoice))
  {
   DllCall("ole32\CoUninitialize"), DllCall("FreeLibrary",UPtr,hOLE)
   Return, 1
  }
  pSpeak := NumGet(NumGet(ppVoice + 0) + 112)
  If DllCall(pSpeak,UPtr,ppVoice,UPtr,&SpeechText,"UInt",Flags,"UInt",0)
  {
   DllCall("ole32\CoUninitialize"), DllCall("FreeLibrary",UPtr,hOLE)
   Return, 1
  }
  DllCall("ole32\CoUninitialize"), DllCall("FreeLibrary",UPtr,hOLE)
  Return, 0
 }

 If DllCall(pSpeak,UPtr,ppVoice,UPtr,&SpeechText,"UInt",Flags,"UInt",0) ;speak the text
  Return, 1
 Return, 0
}