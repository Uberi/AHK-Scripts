; Wrapper for bass.dll (2.4.5.0)
; www.autohotkey.com/forum/topic55454.html
; for AHK 1.0.48.05
; by toralf
; Version 0.1 (2010-02-20)
; based on BASS Library	by k3ph 

; NEEDS:  bass.dll      www.un4seen

; ################################
; ##  List of public functions  ##
; ################################
; BASS_Load([DLLPath, Device, PlugIns]) ;loads BASS wrapper, must be called before any other function
; BASS_Free()                           ;frees BASS wrapper, must be called at end of script
; BASS_IsPlaying(hStream)               ;returns playback status: 0=Stopped, 1=Playing, 2=Stalled, 3=Paused
; BASS_Play([File])                     ;plays a file or restarts it when paused and no file is specified
;                                         (returns hStream on success, otherwise -1)
; BASS_Stop()                           ;stop playback of file (returns hStream="" on success, otherwise -1)
; BASS_Pause()                          ;toogles pause of playback of file (returns hStream on success, otherwise -1)
; BASS_Volume([Volume])                 ;sets or gets master volume: 0 (silent) to 1 (max)
; BASS_GetDevice(hStream)               ;returns device number, otherwise -1
; BASS_Seconds2Bytes(hStream,SecPos)    ;converts a position from seconds to bytes,
;                                         returns on Error negative value
; BASS_Bytes2Seconds(hStream,BytePos)   ;converts a position from bytes to seconds,
;                                         returns on Error negative value
; BASS_GetLen(hStream)                  ;returns playback length in bytes, returns on Error -1
; BASS_GetPos(hStream)                  ;returns playback position in bytes, returns on Error -1
; BASS_SetPos(hStream,BytePos)          ;sets playback position in bytes, returns 1, otherwise 0
; BASS_GetLevel(hStream, ByRef LeftLevel, ByRef RightLevel) ;returns level (peak amplitude) of a stream, returns on Error -1
; BASS_GetLevel(hStream)                ;returns level (peak amplitude 0-32768) of a stream, returns on Error -1 or 0 when stream is stalled
; BASS_IsSliding(hStream,Attrib)        ;returns 1 if attribute is sliding, otherwise 0, 
;                                         Attributes: 1=Freq, 2=Vol, 3=Pan, 4=EAXMix
; BASS_SetSliding(hStream,Attrib,NewValue,TimeMS)   ;set attribute from its current value to slide to new value in time period
; BASS_GetCPU()                         ;returns CPU usage of BASS
; BASS_GetVersion()                     ;returns version of BASS that is loaded
; BASS_ProgressMeter_Add([x, y, Width, Height, Color, Bgcolor, ControlID, GuiID])  ;adds a progress meter to a gui
; BASS_ProgressMeter_Update(hStream [, ControlID, GuiID])   ;updates a progress meter for a stream
; BASS_PluginLoad(File)                 ;loads a plugin of BASS
; BASS_PluginFree([hPlugin])            ;frees a plugin of BASS ("" or 0 = All Plugins)
; BASS_ErrorGetCode()                   ;Return the error message as code and description
;
; #################################
; ##  List of private functions  ##
; #################################
; BASS_InitFree([Modus, DLLPath, Device, Plugins])
; BASS_StreamFileToChannel(Modus [, File])
; BASS_ProgressMeter(GuiID, ControlID, WidthOrhStream, Height [, Color, Bgcolor, X, Y])


;set Include directory for plugins
#Include %A_ScriptDir%\

;include effects & handlers
#Include *i basstags.ahk
#Include *i bassfx.ahk
#Include *i bassvfx.ahk
#Include *i bassenc.ahk
#Include *i bassmix.ahk
#Include *i bassvis.ahk
#Include *i bassvst.ahk
#Include *i basswadsp.ahk
#Include *i bassvideo.ahk

;include format plugins
#Include *i basscd.ahk
#Include *i bassmidi.ahk
#Include *i bassflac.ahk
#Include *i basswma.ahk
#Include *i basswv.ahk
#Include *i bassaac.ahk
#Include *i bassape.ahk
#Include *i bassmpc.ahk
#Include *i bassac3.ahk
#Include *i bassalac.ahk
#Include *i bassspx.ahk
#Include *i basstta.ahk
#Include *i bassofr.ahk

BASS_Load(DLLPath="", Device=-1, PlugIns="ALL"){  ;loads BASS wrapper, must be called before any other function
  Return BASS_InitFree("Load", DLLPath, Device, Plugins)
}
BASS_Free(){                             ;frees BASS wrapper, must be called at end of script 
  Return BASS_InitFree("Free")
}
BASS_InitFree(Modus="", DLLPath="", Device="", Plugins=""){
  static
  DLLName = bass.dll
  If (Modus = "Load"){                             ;load dll to memory
    If (!hBassDll := DllCall("LoadLibrary", Str,DLLPath . DLLName)){
      MsgBox, 48, BASS error!, 
        (Ltrim
          Failed to start %DLLName%
          Please ensure you have %DLLName% in the correct path %DLLPath%
        )
    	Return 0
    }
    local Freq=44100,Flags=0,Win=0,Clsid=0         ;initialize output device 
    If !DllCall("BASS\BASS_Init", Int,Device, Int,Freq, Int,Flags, UInt,Win, UInt,Clsid){
      ErrorLevel := BASS_ErrorGetCode()
      MsgBox, 48, BASS error!,
        (Ltrim
          Failed to initialize BASS
          Error: %ErrorLevel%
        )
      Return 0 
    }
    ;Load plugins
    PlugIns := PlugIns = "All"
            ? "tags,fx,vfx,enc,mix,vis,vst,wadsp,video,cd,midi,flac,wma,wv,aac,ape,mpc,ac3,alac,spx,tta,ofr"
            : PlugIns
    Loop, Parse, PlugIns, `,
      If IsFunc("BASS_" A_LoopField "_Load")
        BASS_%A_LoopField%_Load(DLLPath)
  }Else If (Modus = "Free"){                       
    If !BASS_PluginFree()                          ;free all Plugins
      MsgBox, 48, BASS error!, Failed to free all plugins.`nError: %ErrorLevel%
    DllCall("BASS\BASS_Free")                      ;free all resources used by the output device
    DllCall("FreeLibrary", UInt,hBassDll)          ;free dll from memory
  }
  Return 1
}

BASS_IsPlaying(hStream){ ;returns playback status: 0=Stopped, 1=Playing, 2=Stalled, 3=Paused
;BASS_ChannelIsActive return values
; BASS_ACTIVE_STOPPED := 0 ;
; BASS_ACTIVE_PLAYING := 1 ;
; BASS_ACTIVE_STALLED := 2 ; Playback of the stream has been stalled due to a lack of sample data. The playback will automatically resume once there is sufficient data to do so.
; BASS_ACTIVE_PAUSED  := 3 ;
  Return DllCall("BASS\BASS_ChannelIsActive", UInt,hStream)
}

BASS_Play(File=""){  ;plays a file or restarts it when paused and no file is specified (returns hStream on success, otherwise -1)         
  Return BASS_StreamFileToChannel("Play",File)
}
BASS_Stop(){         ;stop playback of file (returns hStream="" on success, otherwise -1)               
  Return BASS_StreamFileToChannel("Stop")
}
BASS_Pause(){        ;toogles pause of playback of file (returns hStream on success, otherwise -1)
  Return BASS_StreamFileToChannel("Pause")
}
BASS_StreamFileToChannel(Modus,File=""){
  static
  If (File AND !FileExist(File)){     ;check if file exists when specified
    MsgBox, 48, BASS error!,
      (Ltrim
        File does not exist:
        %File%
      )
    Return -1    
  }
  If (Modus = "Play" And File){      ;play file from beginning
  	If !(hStream := DllCall("BASS\BASS_StreamCreateFile", UInt,FromMem:=0
                           , UInt,&File, UInt64,Offset:=0, UInt64,Length:=0
                           , UInt,BASS_STREAM_AUTOFREE := 0x40000)){
      ErrorLevel := BASS_ErrorGetCode()
      MsgBox, 48, BASS error!,
        (Ltrim
          Failed to create a stream from file:
          %File%
          Error: %ErrorLevel%
        )
      Return -1
    }
    If !DllCall("BASS\BASS_ChannelPlay", UInt,hStream, Int,Restart:=1){
      ErrorLevel := BASS_ErrorGetCode()
      MsgBox, 48, BASS error!,
        (Ltrim
          Failed to play stream from file:
          %File%
          Error: %ErrorLevel%
        )
      Return -1      
    }
  }Else If (Modus = "Play" And !File And hStream){   ;restart playback (when paused)
    If !DllCall("BASS\BASS_ChannelPlay", UInt,hStream, Int,Restart:=0){
      ErrorLevel := BASS_ErrorGetCode()
      MsgBox, 48, BASS error!,
        (Ltrim
          Failed to restart stream from file:
          %File%
          Error: %ErrorLevel%
        )
      Return -1      
    }
  }Else If (Modus = "Stop" And hStream){             ;stop playback
    If BASS_IsPlaying(hStream)
      If !DllCall("BASS\BASS_ChannelStop", UInt,hStream){
        ErrorLevel := BASS_ErrorGetCode()
        MsgBox, 48, BASS error!,
          (Ltrim
            Failed to stop stream from file:
            %File%
            Error: %ErrorLevel%
          )
        Return -1      
      }
    hStream =                                        ;clear hStream
  }Else If (Modus = "Pause" And hStream){            ;toogle pause of playback
    local IsPlaying
    IsPlaying := BASS_IsPlaying(hStream)               ;get status
    If (IsPlaying = 3)                                    ;stream is paused
      hStream := BASS_Play()                                 ;restart playback
    Else If (IsPlaying = 1){                              ;stream is playing
      If !DllCall("BASS\BASS_ChannelPause", UInt,hStream){   ;pause playback
        ErrorLevel := BASS_ErrorGetCode()
        MsgBox, 48, BASS error!,
          (Ltrim
            Failed to pause stream from file:
            %File%
            Error: %ErrorLevel%
          )
        Return -1
      }
    }
  }
  Return hStream
}

BASS_Volume(Volume=""){ ;sets or gets master volume: 0 (silent) to 1 (max)  
	If Volume is float
    Return DllCall("BASS\BASS_SetVolume", Float,Volume)
  Else
	  Return DllCall("BASS\BASS_GetVolume", Float)
}
BASS_GetDevice(hStream){  ;returns device number, otherwise -1
	Return DllCall("BASS\BASS_ChannelGetDevice", UInt,hStream)
}

BASS_Seconds2Bytes(hStream,SecPos){  ;converts a position from seconds to bytes, returns on Error negative value
	Return DllCall("BASS\BASS_ChannelSeconds2Bytes", UInt,hStream, Double,SecPos, UInt64)
}
BASS_Bytes2Seconds(hStream,BytePos){ ;converts a position from bytes to seconds, returns on Error negative value
	Return DllCall("BASS\BASS_ChannelBytes2Seconds", UInt,hStream, UInt64,BytePos, Double)
}
BASS_GetLen(hStream){        ;returns playback length in bytes, returns on Error -1
	Return DllCall("BASS\BASS_ChannelGetLength", UInt,hStream, UInt,BASS_POS_BYTE := 0, UInt64)
}             
BASS_GetPos(hStream){      ;returns playback position in bytes, returns on Error -1
	Return DllCall("BASS\BASS_ChannelGetPosition", UInt,hStream, UInt,BASS_POS_BYTE := 0, UInt64)
}
BASS_SetPos(hStream,BytePos){   ;sets playback position in bytes, returns 1, otherwise 0
	Return DllCall("BASS\BASS_ChannelSetPosition", UInt,hStream, UInt64,Bytepos, UInt,BASS_POS_BYTE := 0)
}

BASS_GetLevel(hStream, ByRef LeftLevel, ByRef RightLevel){ ;returns level (peak amplitude 0-32768) of a stream, returns on Error -1 or 0 when stream is stalled
	If ((LevelDWord := DllCall("BASS\BASS_ChannelGetLevel", UInt,hStream)) = -1)
    ErrorLevel := BASS_ErrorGetCode()
  If (LevelDWord > 0) {                       ;the level of the ...
    LeftLevel := LevelDWord & 0xffff            ;left channel is returned in the low word (low 16-bits)
    RightLevel := (LevelDWord>>16) & 0xffff     ;right channel is returned in the high word (high 16-bits)
  }Else{
    LeftLevel = 0
    RightLevel = 0
  }
  Return LevelDWord
}

BASS_IsSliding(hStream,Attrib){ ;returns 1 if attribute is sliding, otherwise 0, Attributes: 1=Freq, 2=Vol, 3=Pan, 4=EAXMix
;   BASS_ATTRIB_FREQ                := 1 ; 100 (min) to 100000 (max), 0 = original rate 
;   BASS_ATTRIB_VOL                 := 2 ; 0 (silent) to 1 (full).
;   BASS_ATTRIB_PAN                 := 3 ; -1 (full left) to +1 (full right), 0 = centre
;   BASS_ATTRIB_EAXMIX              := 4 ; 0 (full dry) to 1 (full wet), -1 = automatically calculate the mix based on the distance (the default).
  If Attrib is not number
  {
    If InStr(Attrib,"Freq")
      Attrib = 1
    Else If InStr(Attrib,"Vol")
      Attrib = 2
    Else If InStr(Attrib,"Pan")
      Attrib = 3
    Else If InStr(Attrib,"EAX")
      Attrib = 4
  }
  If Attrib not between 1 and 4
    Return 0
	Return DllCall("BASS\BASS_ChannelIsSliding", UInt,hStream, UInt,Attrib)
}
BASS_SetSliding(hStream,Attrib,NewValue,TimeMS){ ;set attribute from its current value to slide to new value in time period
;   BASS_ATTRIB_FREQ                := 1 ; 100 (min) to 100000 (max), 0 = original rate 
;   BASS_ATTRIB_VOL                 := 2 ; 0 (silent) to 1 (full).
;   BASS_ATTRIB_PAN                 := 3 ; -1 (full left) to +1 (full right), 0 = centre
;   BASS_ATTRIB_EAXMIX              := 4 ; 0 (full dry) to 1 (full wet), -1 = automatically calculate the mix based on the distance (the default).
  If Attrib is not number
  {
    If InStr(Attrib,"Freq")
      Attrib = 1
    Else If InStr(Attrib,"Vol")
      Attrib = 2
    Else If InStr(Attrib,"Pan")
      Attrib = 3
    Else If InStr(Attrib,"EAX")
      Attrib = 4
  }
  If Attrib not between 1 and 4
    Return 0
  If NewValue is not float
    Return 0
  If TimeMS is not number
    Return 0
	Return DllCall("BASS\BASS_ChannelSlideAttribute", UInt,hStream, UInt,Attrib, Float,NewValue, UInt,TimeMS)
}

BASS_GetCPU(){      ;returns CPU usage of BASS
	Return DllCall("BASS\BASS_GetCPU", Float)
}
BASS_GetVersion(){  ;returns version of BASS that is loaded
	Return DllCall("BASS\BASS_GetVersion")
}

; BASS_ProgressMeter
; based on idea by zed gecko  (StreamGUI, which comes with bass lib)
; adds a progress meter to a gui
BASS_ProgressMeter_Add(x = "", y = "", Width=300, Height=100, Color="green", Bgcolor="gray", ControlID="", GuiID=1){
  Return BASS_ProgressMeter(GuiID, ControlID, Width, Height//2, Color, Bgcolor, X, Y)
}
; updates a progress meter for a stream
BASS_ProgressMeter_Update(hStream, ControlID="", GuiID=1){
  Return BASS_ProgressMeter(GuiID, ControlID, hStream, "???????????")
}
BASS_ProgressMeter(GuiID, ControlID, WidthOrhStream, Height, Color="", Bgcolor="", X="", Y=""){
  global 
  local  SegmentSpace,SegmentSize,TransferVar,PrevSegment,NOS,LeftLevel,RightLevel
  If (Height = "???????????"){
    SetControlDelay, -1
    Loop, % NOS := NumberOfProgressMeterSegments%ControlID% {
      PrevSegment := A_Index - 1
      GuiControlGet, TransferVar, %GuiID%:, ProgressMeterL%ControlID%%A_Index%
      GuiControl,%GuiID%:, ProgressMeterL%ControlID%%PrevSegment%, %TransferVar%
      GuiControlGet, TransferVar, %GuiID%:, ProgressMeterR%ControlID%%A_Index%
      GuiControl,%GuiID%:, ProgressMeterR%ControlID%%PrevSegment%, %TransferVar%
    }
    BASS_GetLevel(WidthOrhStream, LeftLevel, RightLevel)
    GuiControl,%GuiID%:, ProgressMeterL%ControlID%%NOS%, %LeftLevel%
    GuiControl,%GuiID%:, ProgressMeterR%ControlID%%NOS%, % 32768 - RightLevel 
  }Else{
    SegmentSpace = 2                    ;visible size of one segment in pixel
    SegmentSize := SegmentSpace + 1
    NumberOfProgressMeterSegments%ControlID% := (WidthOrhStream // SegmentSize) - 1
    Gui, %GuiID%:Add, Progress, Range0-32768 vProgressMeterL%ControlID%0 w%SegmentSize% h%Height% %X% %Y% c%Color% Background%Bgcolor% Vertical,
    Gui, %GuiID%:Add, Progress, Range0-32768 vProgressMeterR%ControlID%0 w%SegmentSize% h%Height% y+0 c%Bgcolor% Background%Color% Vertical, 32769
    Loop, % NumberOfProgressMeterSegments%ControlID%{
      Gui, %GuiID%:Add, Progress, Range0-32768 vProgressMeterL%ControlID%%A_Index% w%SegmentSize% h%Height% xp+%SegmentSpace% yp-%Height% c%Color% Background%Bgcolor% Vertical,
      Gui, %GuiID%:Add, Progress, Range0-32768 vProgressMeterR%ControlID%%A_Index% w%SegmentSize% h%Height% y+0 c%Bgcolor% Background%Color% Vertical, 32769 
    }
  }
  Return 1
}

BASS_PluginLoad(File){   ;loads a plugin of BASS
;With any combination of these flags
;   BASS_UNICODE = 0x80000000 ;file is unicode
  Flags = 0
  If !hPlugin := DllCall("BASS\BASS_PluginLoad", UInt,&File, UInt,Flags)
    ErrorLevel := BASS_ErrorGetCode()
  Return hPlugin
}
BASS_PluginFree(hPlugin=0){  ;frees a plugin of BASS (0 = All Plugins)
	If !(Ret := DllCall("BASS\BASS_PluginFree", UInt,hPlugin))
    ErrorLevel := BASS_ErrorGetCode()
  Return Ret 
}

BASS_ErrorGetCode(){ ;Return the error message as code and description 
  static ErrorCodes :=
    (LTrim
      ";error codes returned by BASS_ErrorGetCode
      0  BASS_OK             all is OK
      1  BASS_ERROR_MEM      memory error
      2  BASS_ERROR_FILEOPEN can't open the file
      3  BASS_ERROR_DRIVER   can't find a free sound driver
      4  BASS_ERROR_BUFLOST  the sample buffer was lost
      5  BASS_ERROR_HANDLE   invalid handle
      6  BASS_ERROR_FORMAT   unsupported sample format
      7  BASS_ERROR_POSITION invalid position
      8  BASS_ERROR_INIT     BASS_Init has not been successfully called
      9  BASS_ERROR_START    BASS_Start has not been successfully called
      14 BASS_ERROR_ALREADY  already initialized/paused/whatever
      18 BASS_ERROR_NOCHAN   can't get a free channel
      19 BASS_ERROR_ILLTYPE  an illegal type was specified
      20 BASS_ERROR_ILLPARAM an illegal parameter was specified
      21 BASS_ERROR_NO3D     no 3D support
      22 BASS_ERROR_NOEAX    no EAX support
      23 BASS_ERROR_DEVICE   illegal device number
      24 BASS_ERROR_NOPLAY   not playing
      25 BASS_ERROR_FREQ     illegal sample rate
      27 BASS_ERROR_NOTFILE  the stream is not a file stream
      29 BASS_ERROR_NOHW     no hardware voices available
      31 BASS_ERROR_EMPTY    the MOD music has no sequence data
      32 BASS_ERROR_NONET    no internet connection could be opened
      33 BASS_ERROR_CREATE   couldn't create the file
      34 BASS_ERROR_NOFX     effects are not enabled
      37 BASS_ERROR_NOTAVAIL requested data is not available
      38 BASS_ERROR_DECODE   the channel is a "decoding channel"
      39 BASS_ERROR_DX       a sufficient DirectX version is not installed
      40 BASS_ERROR_TIMEOUT  connection timedout
      41 BASS_ERROR_FILEFORM unsupported file format
      42 BASS_ERROR_SPEAKER  unavailable speaker
      43 BASS_ERROR_VERSION  invalid BASS version (used by add-ons)
      44 BASS_ERROR_CODEC    codec is not available/supported
      45 BASS_ERROR_ENDED    the channel/file has ended
      -1 BASS_ERROR_UNKNOWN  some other mystery problem"
    )  
  Error := DllCall("BASS\BASS_ErrorGetCode", Int)
  Needle := "m`n)^" Error " +\w*\s*(?P<Value>.*)$"
  RegExMatch(ErrorCodes, Needle, Return)
  Return Error " = " ReturnValue
}
