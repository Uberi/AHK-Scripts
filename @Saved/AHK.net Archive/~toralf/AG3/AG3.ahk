; Wrapper for AudioGenie3.dll (Beta 2.0.0.2) by Stefan Töngi (www.audiogenie.de)
; www.autohotkey.com/forum/topic55452.html
; for AHK 1.0.48.05
; by toralf
; Version 0.1 (2010-02-21)

; NEEDS:  AudioGenie3.dll  (beta 2.0.0.2)  www.audiogenie.net/de/download.htm

; all GDI+ code is based on the GDIplus lib by tic (www.autohotkey.com/forum/topic32238.html)       

; ##################
; ##  Data types  ##
; ##################
; File        = a file name
; FrameID     = 4 characters describing a frame in a ID3v2 tag, e.g. TALB,APIC,TIT1,COMM...
;               more info at www.id3.org/id3v2.4.0-frames
; String      = a text sting (NO new line allowed)
; Text        = a text sting (new line allowed)
; Index       = index of a frame when multiple are allowed, e.g. for COMM,APIC...
; Language    = 3 characters describing a language in a ID3v2 frame, e.g. ENG,DEU,...
;               more info at http://en.wikipedia.org/wiki/ISO_639-3
; Email       = Email for ID3v2 frame for identification
; Description = short description of text
; PictureType = picture type described with a number between 1 and 20
;               more info at www.id3.org/id3v2.4.0-frames
; hPctControl = handle to a picture control
; 
; ################################
; ##  List of public functions  ##
; ################################
; AG3_Init(Modus="")                            ;starts AudioGenie3 and GDI+
; AG3_Stop()                                    ;stops AudioGenie3 and GDI+
; AG3_Open(File)                                ;opens a media file for analysis; ErrorLevel holds info on any Error
; AG3_LogFile(File)                             ;specifies file to log actions
; AG3_FoundTags()                               ;returns comma separated list of found tags in file (ID3v2,ID3v1,APE,LYRICS)
; AG3_AllID3Tags()                              ;returns comma separated list of all ID3v2 frame IDs in file (TALB,APIC,TIT1,COMM...) 
; AG3_FrameCount(FrameID)                       ;returns number of frames for specified frame ID in ID3v2 tag
; 
; AG3_ID3TFrame(FrameID [, String])             ;sets or returns text and URL frame contents for ID3v2 tags 
; AG3_Artist([String])                          ;sets or returns artist, regardless of tag type (WMA,OGG,APE,ID3,LYRICS)
; AG3_Album([String])                           ;sets or returns Album, regardless of tag type (WMA,OGG,APE,ID3,LYRICS)
; AG3_Title([String])                           ;sets or returns Title, regardless of tag type (WMA,OGG,APE,ID3,LYRICS)
; AG3_Track([String])                           ;sets or returns Track (e.g. 4 or 4/20), regardless of tag type (WMA,OGG,APE,ID3,LYRICS)
; AG3_Year([String])                            ;sets or returns Year (4 digits), regardless of tag type (WMA,OGG,APE,ID3,LYRICS)
; AG3_Genre([String])                           ;sets or returns Genre, regardless of tag type (WMA,OGG,APE,ID3,LYRICS)
; AG3_Comment([String])                         ;sets or returns a comment, regardless of tag type (WMA,OGG,APE,ID3,LYRICS)
; AG3_CommentEx(LanguageOrIndex [, Description, Text])  ;sets or returns one comment of ID3v2 tag; returns formated string [Lang.`nDesc.`nText]
; AG3_PlayCounter([Counter])                            ;sets or returns play counter of ID3v2 tag
; AG3_Popularimeter(EmailOrIndex [, Rating, Counter])   ;sets or returns one Popularimeter of ID3v2 tag; returns formated string [Email`nRating`nCounter]
; AG3_Lyric(LanguageOrIndex [, Description, Text])      ;sets or returns one Lyric of ID3v2 tag; returns formated string [Lang.`nDesc.`nText] 
; 
; AG3_GetID3PictureCount()                          ;returns number of pictures in ID3v2 tag
; AG3_GetWMAPictureCount()                          ;returns number of pictures in WMA tag
; AG3_GetMP4PictureCount()                          ;returns number of pictures in MP4 tag
; AG3_GetID3PictureMime(Index)                      ;returns MIME type of one picture in ID3v2 tag
; AG3_GetID3PictureType(Index)                      ;returns picture type of one picture in ID3v2 tag
; AG3_GetID3PictureDescription(Index)               ;returns describtion of one picture in ID3v2 tag
; AG3_GetWMAPictureMime(Index)                      ;returns MIME type of one picture in WMA tag    
; AG3_GetWMAPictureType(Index)                      ;returns picture type of one picture in WMA tag 
; AG3_GetWMAPictureDescription(Index)               ;returns describtion of one picture in WMA tag
; AG3_ShowID3Picture(hPctControl [, Index])         ;shows/removes picture of one APIC ID3 frame in/from a picture control
; AG3_ShowWMAPicture(hPctControl [, Index])         ;shows/removes one picture of an WMA tag in/from a picture control
; AG3_ShowMP4Picture(hPctControl [, Index])         ;shows/removes one picture of an MP4 tag in/from a picture control
; AG3_ShowID3CommercialLogo(hPctControl [, Index])  ;shows/removes picture of one COMR ID3 frame in/from a picture control
; 
; AG3_GetID3Picture(File, Index)                    ;saves picture of one APIC ID3 frame to file
; AG3_GetWMAPicture(File, Index)                    ;saves one picture of WMA tag to file
; AG3_GetMP4Picture(File, Index)                    ;saves one picture of MP4 tag to file
; AG3_AddID3Picture(File, Description, PictureType)         ;adds picture from file to new APIC ID3 frame
; AG3_AddWMAPicture(File, Description, PictureType, Index)  ;adds picture from file to WMA tag
; AG3_AddMP4Picture(File)                                   ;adds picture from file to MP4 tag
; 
; AG3_DeleteFrame(FrameID [, Index])    ;deletes all ID3 frames with same FrameID or one specific of several  
;
; AG3_RemoveID3v2Tag([File])            ;removes ID3v2 tag from currently opened file or from file
; AG3_RemoveID3v1Tag([File])            ;removes ID3v1 tag from currently opened file or from file
; AG3_RemoveAPETag([File])              ;removes APE tag from currently opened file or from file
; AG3_RemoveLYRICSTag([File])           ;removes LYRICS tag from currently opened file or from file
; AG3_RemoveOGGTag([File])              ;removes OGG tag from currently opened file or from file
; 
; AG3_Save([File])           ;saves all changes of currently opened file or to file, regardless of tag type (WMA,OGG,APE,ID3,LYRICS)
; AG3_SaveID3V2([File])      ;saves all ID3v2 tag changes of currently opened file or to file
; AG3_SaveID3V1([File])      ;saves all ID3v1 tag changes of currently opened file or to file
; AG3_SaveWMA([File])        ;saves all WMA tag changes of currently opened file or to file
; AG3_SaveMP4([File])        ;saves all MP4 tag changes of currently opened file or to file
; AG3_SaveAPE([File])        ;saves all APE tag changes of currently opened file or to file
; AG3_SaveLYRICS([File])     ;saves all LYRICS tag changes of currently opened file or to file
; AG3_SaveOGG([File])        ;saves all OGG tag changes of currently opened file or to file
; AG3_SaveFLAC([File])       ;saves all FLAC tag changes of currently opened file or to file
; 
; AG3_PictureTypeName(PicType [, Language])  ;returns picture type description in specified language (default: ENG)
;                                            ;valid for WMA and ID3 V2.4.0, V2.3.0 and V2.2.0
; AG3_FrameIDName(FrameID [, Language])      ;returns FrameID description in specified language (default: ENG)
;                                            ;valid for ID3 V2.4.0, V2.3.0 (4 characters) and V2.2.0 (3 characters)
; 
; AG3(Func [, FrameIDOrStringOrIndex, StringOrIndex])  ;execution of 356 AudioGenie3 functions 
;                                                      ;more info on functions in AudioGenie3 documentation
; 
; 72 functions of AudioGenie3 are not yet wrapped.
; 
; #################################
; ##  List of private functions  ##
; #################################
; AG3_OpenReturnValue(ReturnValue)
; AG3_ShowPicture(Type, hPctControl, Index)
; AG3_AddGetPicture(Func, File [, DescOrIndex, PictureType])
; AG3_RemoveTag(Func [, File])
; AG3_SaveChanges(Func [, File])
;
; #################################
; ##  List of general functions  ##
; #################################
; ATOU( ByRef Unicode, Ansi ) ; converts Ansi to Unicode (by SKAN)
; UTOA( pUnicode )            ; converts Unicode to Ansi (by SKAN)
; AscToHex(S){                ; converts ASCII to Hex (by Laszlo)

AG3_Init(Modus=""){
  static hAudioGenie3,pGDIPToken,savedModus    ;remember handles for stop
  savedModus := Modus
  If (Modus = "Stop"){
    DllCall("FreeLibrary", UInt, hAudioGenie3)       ;free AudioGenie
    DllCall("gdiplus\GdiplusShutdown", "UInt", pGDIPToken)    ;stop GDI+  ;  = Gdip_Shutdown(pGDIPToken) 
    If hModule := DllCall("GetModuleHandle", "Str", "gdiplus")            ;    - " -
      DllCall("FreeLibrary", "UInt", hModule)                             ;    - " -
  }Else{
    hAudioGenie3 := DllCall( "LoadLibrary", Str,"AudioGenie3.dll" )  ;load AudioGenie
    SetTimer, ForceNag, -1                                           ;force Nag
    If !DllCall("GetModuleHandle", "Str", "gdiplus")                 ;start GDI+     ;  = If (!pGDIPToken := Gdip_Startup()){
      DllCall("LoadLibrary", "Str", "gdiplus")                                       ;    - " -
    VarSetCapacity(si, 16, 0), si := Chr(1)                                          ;    - " -
    DllCall("gdiplus\GdiplusStartup", "UInt*", pGDIPToken, "UInt", &si, "UInt", 0)   ;    - " -
    If !pGDIPToken{                                                                  ;    - " -
    	MsgBox, 48, gdiplus error!, Gdiplus failed to start. Please ensure you have gdiplus on your system
    	Return 
    }
  }
  Return 
  
  ForceNag:                                               ;force Nag
    If InStr(savedModus,"HideNag")                        ;use AG3_Init("HideNag") to hide Nag
      SetTimer, HideNag, -1
    DllCall( "AudioGenie3\AUDIOAnalyzeFileW", Str,Dummy ) ;Dummy Call for SplashText
  Return
  
  HideNag:
   SetWinDelay, -1                                         ;hide Nag
   WinWait, ahk_class #32770, This Project uses the Freeware AudioGenie, 1
;    WinHide, ahk_class #32770, This Project uses the Freeware AudioGenie    ;but sets GUI to background and disables it for 3 seconds
;    WinMove, ahk_class #32770, This Project uses the Freeware AudioGenie, -230, -120   ;but disables GUI for 3 seconds
   WinSet, Transparent, 0, ahk_class #32770, This Project uses the Freeware AudioGenie   ;but disables GUI for 3 seconds
  Return
}
AG3_Stop(){
  AG3_Init("Stop")
}

AG3_Open(File){
  ATOU(FileU,File)
  Return Ret := DllCall( "AudioGenie3\AUDIOAnalyzeFileW", Str,FileU ), ErrorLevel := AG3_OpenReturnValue(Ret)            
}
AG3_OpenReturnValue(ReturnValue){
  static ReturnValues := 
          (LTrim
            "0 unknown Format
            1 MP3
            2 WMA
            3 MONKEY
            4 FLAC
            5 WAV
            6 OGG VORBIS
            7 MPP
            8 AAC
            9 MP4/M4A
            10 TTA"
          )
  Needle := "m`n)^" i " (?<Translation>.*)$"
  RegExMatch(ReturnValues, Needle, Return)
  Return ReturnTranslation
}

AG3_LogFile(File){
  ATOU(FileU,File)
  Return DllCall("AudioGenie3\SetLogFileW", Str,FileU)
}
; SetLogFileW (LPCWSTR fileName)

AG3_FoundTags(){
   Tags := Abs(DllCall("AudioGenie3\ID3V2ExistsW")) ? "ID3v2," : ""
         . Abs(DllCall("AudioGenie3\ID3V1ExistsW")) ? "ID3v1," : ""
         . Abs(DllCall("AudioGenie3\APEExistsW"))   ? "APE," : ""
         . Abs(DllCall("AudioGenie3\LYRICSExistsW")) ? "LYRICS," : ""
   Return SubStr(Tags,1,-1)
}
; LYRICSExistsW ()
; ID3V2ExistsW  ()
; APEExistsW    ()
; ID3V1ExistsW  ()

AG3_AllID3Tags(){
  Return UTOA(DllCall("AudioGenie3\ID3V2GetAllFrameIDsW"))
}
; ID3V2GetAllFrameIDsW ()

AG3_FrameCount(FrameID){
  Return DllCall( "AudioGenie3\ID3V2GetFrameCountW", Int,"0x" . AscToHex(FrameID))
}
; ID3V2GetAllFrameIDsW (u32 FrameID)

AG3_ID3TFrame(FrameID, String="EIIK§ÐŠTUik"){
  Func := (SubStr(FrameID,1,1) = "T" ? "TextFrameW"
        : (SubStr(FrameID,1,1) = "W" ? "URLFrameW" : ""))
  If !Func OR StrLen(FrameID) <> 4
    Return
  FrameIDH := "0x" . AscToHex(FrameID)
  If (String <> "EIIK§ÐŠTUik"){
    ATOU(StringU,String)
    Return DllCall("AudioGenie3\ID3V2Set" Func, Int,FrameIDH, Str,StringU)
  }Else
    Return UTOA(DllCall("AudioGenie3\ID3V2Get" Func, Int,FrameIDH))
}
; ID3V2SetURLFrameW         (u32 FrameID, LPCWSTR textString)
; ID3V2SetTextFrameW        (u32 FrameID, LPCWSTR textString)
; ID3V2GetURLFrameW         (u32 FrameID)
; ID3V2GetTextFrameW        (u32 FrameID)


AG3_Artist(String="EIIK§ÐŠTUik"){
  If (String <> "EIIK§ÐŠTUik"){
    ATOU(StringU,String)
    Return DllCall("AudioGenie3\AUDIOSetArtistW", Str,StringU)
  }Else
    Return UTOA(DllCall("AudioGenie3\AUDIOGetArtistW"))
}
; AUDIOGetArtistW          ()
; AUDIOSetArtistW          (LPCWSTR textString)

AG3_Album(String="EIIK§ÐŠTUik"){
  If (String <> "EIIK§ÐŠTUik"){
    ATOU(StringU,String)
    Return DllCall("AudioGenie3\AUDIOSetAlbumW", Str,StringU)
  }Else
    Return UTOA(DllCall("AudioGenie3\AUDIOGetAlbumW"))
}
; AUDIOGetAlbumW           ()
; AUDIOSetAlbumW           (LPCWSTR textString)

AG3_Title(String="EIIK§ÐŠTUik"){
  If (String <> "EIIK§ÐŠTUik"){
    ATOU(StringU,String)
    Return DllCall("AudioGenie3\AUDIOSetTitleW", Str,StringU)
  }Else
    Return UTOA(DllCall("AudioGenie3\AUDIOGetTitleW"))
}
; AUDIOGetTitleW           ()
; AUDIOSetTitleW           (LPCWSTR textString)

AG3_Track(String="EIIK§ÐŠTUik"){
  If (String <> "EIIK§ÐŠTUik"){
    ATOU(StringU,String)
    Return DllCall("AudioGenie3\AUDIOSetArtistW", Str,StringU)
  }Else
    Return UTOA(DllCall("AudioGenie3\AUDIOGetTrackW"))
}
; AUDIOGetTrackW           ()
; AUDIOSetTrackW           (LPCWSTR textString)

AG3_Year(String="EIIK§ÐŠTUik"){
  If (String <> "EIIK§ÐŠTUik"){
    ATOU(StringU,String)
    Return DllCall("AudioGenie3\AUDIOSetYearW", Str,StringU)
  }Else
    Return UTOA(DllCall("AudioGenie3\AUDIOGetYearW"))
}
; AUDIOGetYearW            ()
; AUDIOSetYearW            (LPCWSTR textString)

AG3_Genre(String="EIIK§ÐŠTUik"){
  If (String <> "EIIK§ÐŠTUik"){
    ATOU(StringU,String)
    Return DllCall("AudioGenie3\AUDIOSetGenreW", Str,StringU)
  }Else
    Return UTOA(DllCall("AudioGenie3\AUDIOGetGenreW"))
}
; AUDIOGetGenreW           ()
; AUDIOSetGenreW           (LPCWSTR textString)

AG3_Comment(String="EIIK§ÐŠTUik"){
  If (String <> "EIIK§ÐŠTUik"){
    ATOU(StringU,String)
    Return DllCall("AudioGenie3\AUDIOSetCommentW", Str,StringU)
  }Else
    Return UTOA(DllCall("AudioGenie3\AUDIOGetCommentW"))
}
; AUDIOGetCommentW         ()
; AUDIOSetCommentW         (LPCWSTR textString)

AG3_CommentEx(LanguageOrIndex, Description="", Text=""){
  If (RegExMatch(LanguageOrIndex,"[a-zA-Z]{3}")){
    ATOU(LanguageU,LanguageOrIndex)
    ATOU(DescriptionU,Description)
    ATOU(TextU,Text)
    Return DllCall("AudioGenie3\ID3V2AddCommentW", Str,LanguageU, Str,DescriptionU, Str,TextU)
  }Else If LanguageOrIndex is number
    If LanguageOrIndex > 0
      Return UTOA(DllCall("AudioGenie3\ID3V2GetCommentLanguageW", Short,LanguageOrIndex))
      . "`n" UTOA(DllCall("AudioGenie3\ID3V2GetCommentDescriptionW", Short,LanguageOrIndex))
      . "`n" UTOA(DllCall("AudioGenie3\ID3V2GetCommentW", Short,LanguageOrIndex))
}
; ID3V2AddCommentW              (LPCWSTR Language, LPCWSTR Description, LPCWSTR Text)
; ID3V2GetCommentW              (short Index)
; ID3V2GetCommentLanguageW      (short Index)
; ID3V2GetCommentDescriptionW   (short Index)

AG3_PlayCounter(Counter=""){
  If (Counter = "")
    Return DllCall("AudioGenie3\ID3V2GetPlayCounterW")
  Else If Counter is number
    Return DllCall("AudioGenie3\ID3V2SetPlayCounterW", Int,Counter)
}
; ID3V2SetPlayCounterW          (long counter)
; ID3V2GetPlayCounterW          ()

AG3_Popularimeter(EmailOrIndex, Rating="", Counter=""){
  If EmailOrIndex is number
    Return UTOA(DllCall("AudioGenie3\ID3V2GetPopularimeterEmailW", Int,EmailOrIndex))
    . "`n" UTOA(DllCall("AudioGenie3\ID3V2GetPopularimeterRatingW", Int,EmailOrIndex))
    . "`n" UTOA(DllCall("AudioGenie3\ID3V2GetPopularimeterCounterW", Int,EmailOrIndex))
  Else If EmailOrIndex{
    ATOU(EmailU,EmailOrIndex)
    Return DllCall("AudioGenie3\ID3V2AddCommentW", Str,EmailU, Short,Rating, Int,Counter)
  }
}
; ID3V2GetPopularimeterRatingW  (short Index)
; ID3V2GetPopularimeterCounterW (short Index)
; ID3V2GetPopularimeterEmailW   (short Index)
; ID3V2AddPopularimeterW        (LPCWSTR Email, short Rating, long Counter)

AG3_Lyric(LanguageOrIndex, Description="", Text=""){
  If (RegExMatch(LanguageOrIndex,"[a-zA-Z]{3}")){
    ATOU(LanguageU,LanguageOrIndex)
    ATOU(DescriptionU,Description)
    ATOU(TextU,Text)
    Return DllCall("AudioGenie3\ID3V2AddLyricW", Str,LanguageU, Str,DescriptionU, Str,TextU)
  }Else If LanguageOrIndex is number
    If LanguageOrIndex > 0
      Return UTOA(DllCall("AudioGenie3\ID3V2GetLyricLanguageW", Short,LanguageOrIndex))
      . "`n" UTOA(DllCall("AudioGenie3\ID3V2GetLyricDescriptionW", Short,LanguageOrIndex))
      . "`n" UTOA(DllCall("AudioGenie3\ID3V2GetLyricW", Short,LanguageOrIndex))
}
; ID3V2AddLyricW            (LPCWSTR Language, LPCWSTR Description, LPCWSTR Text)
; ID3V2GetLyricW            (short Index)
; ID3V2GetLyricDescriptionW (short Index)
; ID3V2GetLyricLanguageW    (short Index)

AG3_GetID3PictureCount(){
  Return AG3_FrameCount("APIC")
}
AG3_GetWMAPictureCount(){
  Return DllCall( "AudioGenie3\WMAGetPictureCountW")
}
AG3_GetMP4PictureCount(){
  Return DllCall( "AudioGenie3\MP4GetPictureCountW")
}
; WMAGetPictureCountW ()
; MP4GetPictureCountW ()

AG3_GetID3PictureMime(Index){
  Return UTOA(DllCall( "AudioGenie3\ID3V2GetPictureMimeW", Short,Index))
}
AG3_GetID3PictureType(Index){
  Return Ret := DllCall( "AudioGenie3\ID3V2GetPictureTypeW", Short,Index), ErrorLevel := AG3_PictureTypeName(Ret)
}
AG3_GetID3PictureDescription(Index){
  Return UTOA(DllCall( "AudioGenie3\ID3V2GetPictureDescriptionW", Short,Index))
}
AG3_GetWMAPictureMime(Index){
  Return UTOA(DllCall( "AudioGenie3\WMAGetPictureMimeW", Short,Index))
}
AG3_GetWMAPictureType(Index){
  Return Ret := DllCall( "AudioGenie3\WMAGetPictureTypeW", Short,Index), ErrorLevel := AG3_PictureTypeName(Ret) 
}
AG3_GetWMAPictureDescription(Index){
  Return UTOA(DllCall( "AudioGenie3\WMAGetPictureDescriptionW", Short,Index))
}
; ID3V2GetPictureMimeW        (short Index)
; ID3V2GetPictureTypeW        (short Index)
; ID3V2GetPictureDescriptionW (short Index)
; WMAGetPictureMimeW          (short Index)
; WMAGetPictureTypeW          (short Index)
; WMAGetPictureDescriptionW   (short Index)

AG3_ShowID3Picture(hPctControl, Index=""){
  Return AG3_ShowPicture("ID3V2", hPctControl, Index)
}
AG3_ShowMP4Picture(hPctControl, Index=""){
  Return AG3_ShowPicture("MP4", hPctControl, Index)
}
AG3_ShowWMAPicture(hPctControl, Index=""){
  Return AG3_ShowPicture("WMA", hPctControl, Index)
}
AG3_ShowID3CommercialLogo(hPctControl, Index=""){
  Return AG3_ShowPicture("Logo", hPctControl, Index)
}
; MP4GetPictureArrayW              (BYTE *arr, u32 maxLen, short Index)
; WMAGetPictureArrayW              (BYTE *arr, u32 maxLen, short Index)
; ID3V2GetPictureArrayW            (BYTE *arr, u32 maxLen, short Index)
; ID3V2GetCommercialFramePictureW  (BYTE *arr, u32 maxLen, short Index)
AG3_ShowPicture(Type, hPctControl, Index){
  ControlGetPos , CX, CY, CWidth, CHeight, ,ahk_id %hPctControl%
  If !Index {           ;remove picture
    bc := DllCall("GetSysColor", "Int", COLOR_3DFACE:=15)  
    DllCall("gdiplus\GdipCreateSolidFill", "Int"        ;  = pBrushClear := Gdip_BrushCreateSolid(0xff000000 | (bc >> 16 | bc & 0xff00 | (bc & 0xff) << 16))
      , ARGB := 0xff000000 | (bc >> 16 | bc & 0xff00 | (bc & 0xff) << 16), "UInt*", pBrushClear)
  }Else{                ;show picture
    Func := Type . "GetPictureArrayW"
    Func := Type = "Logo" ? "ID3V2GetCommercialFramePictureW" : Func
    
    MaxLen = 5000000                             ;size of array in bytes; assume large picture
    VarSetCapacity(PicAsBin, MaxLen, 0)
    nSize := DllCall("AudioGenie3\" Func, UInt,&PicAsBin, Int,MaxLen, Int,Index)
    If nSize < 0                                 ;when something goes wrong, set ErrorLevel
      Return 0, ErrorLevel := UTOA( DllCall("AudioGenie3\AUDIOGetLastErrorTextW") )
    VarSetCapacity(PicAsBin, -1)                 ;adjust size
    
    ;create Bitmap from binary array
    hData := DllCall("GlobalAlloc", UInt,2, UInt,nSize)              
    pData := DllCall("GlobalLock", UInt,hData)
    DllCall("RtlMoveMemory", UInt,pData, UInt,&PicAsBin, UInt,nSize)
    DllCall("GlobalUnlock", UInt,hData)
    DllCall("ole32\CreateStreamOnHGlobal", UInt,hData, Int,1, UIntP,pStream)  ;Use COM
    DllCall( "gdiplus\GdipCreateBitmapFromStream", UInt,pStream, UIntP,pBitmap )
    DllCall( NumGet(NumGet(1*pStream)+8 ), UInt,pStream )                     ;Release COM
  
    ;calculate new hight and width by keeping aspect ratio
    DllCall("gdiplus\GdipGetImageWidth", "UInt", pBitmap, "UInt*", OriginalWidth)    ;  = OriginalWidth := Gdip_GetImageWidth(pBitmap)
    DllCall("gdiplus\GdipGetImageHeight", "UInt", pBitmap, "UInt*", OriginalHeight)  ;  = OriginalHeight := Gdip_GetImageHeight(pBitmap)
    RatioWidth := CWidth/OriginalWidth, RatioHeight := CHeight/OriginalHeight
    Ration := RatioWidth < RatioHeight ? RatioWidth : RatioHeight
    NewWidth := OriginalWidth * Ration
    NewHeight := OriginalHeight * Ration
  }  

  DllCall("gdiplus\GdipCreateBitmapFromScan0", "Int",CWidth, "Int",CHeight                 ;  = NewpBitmap := Gdip_CreateBitmap(CWidth, CHeight)
        , "Int",0, "Int",Format:=0x26200A, "UInt",0, "UInt*", NewpBitmap)
  DllCall("gdiplus\GdipGetImageGraphicsContext", "UInt", NewpBitmap, "UInt*", NewG)        ;  = NewG := Gdip_GraphicsFromImage(NewpBitmap)

  If !Index {           ;remove picture
    DllCall("gdiplus\GdipFillRectangle", "UInt", NewG, "Int", pBrushClear                  ;  = Gdip_FillRectangle(NewG, pBrushClear, 0, 0, CWidth, CHeight)
          , "Float", x:=0, "Float", y:=0, "Float", CWidth, "Float", CHeight)
  }Else{                ;show picture
    ;scale bitmap
    DllCall("gdiplus\GdipSetInterpolationMode", "UInt", NewG, "Int", InterpolationMode:=7)   ;  = Gdip_SetInterpolationMode(NewG, 7)
    DllCall("gdiplus\GdipDrawImageRectRect", "UInt", NewG, "UInt", pBitmap                   ;  = Gdip_DrawImage(NewG, pBitmap, 0, 0, NewWidth, NewHeight, 0, 0, OriginalWidth, OriginalHeight)
        	, "Float", dx:=0, "Float", dy:=0, "Float", NewWidth, "Float", NewHeight
        	, "Float", sx:=0, "Float", sy:=0, "Float", OriginalWidth, "Float", OriginalHeight
        	, "Int", 2, "UInt", ImageAttr:=0, "UInt", 0, "UInt", 0)
  }  

  ;set image to control
  DllCall("gdiplus\GdipCreateHBITMAPFromBitmap", "UInt", NewpBitmap            ;  = hBitmap := Gdip_CreateHBITMAPFromBitmap(NewpBitmap)
                  , "UInt*", hBitmap, "Int", Background:=0xffffffff)

	SendMessage, (STM_SETIMAGE:=0x172), (IMAGE_BITMAP:=0x0), hBitmap,, ahk_id %hPctControl%    ;  = SetImage(hPctControl, hBitmap)
  DllCall("DeleteObject", "UInt", ErrorLevel)                                                ;    - " -
  
  ; The bitmaps from the image may be deleted
  If !Index {           ;remove picture
    DllCall("gdiplus\GdipDeleteBrush", "UInt", pBrush)     ; =  Gdip_DeleteBrush(pBrushClear)
  }Else{                ;show picture
    DllCall("gdiplus\GdipDisposeImage", "UInt", pBitmap)   ; =  Gdip_DisposeImage(pBitmap)
  }
  DllCall("gdiplus\GdipDeleteGraphics", "UInt", NewG)      ; =  Gdip_DeleteGraphics(NewG)
  DllCall("gdiplus\GdipDisposeImage", "UInt", NewpBitmap)  ; =  Gdip_DisposeImage(NewpBitmap)
  DllCall("DeleteObject", "UInt", hBitmap)                 ; =  DeleteObject(hBitmap)
  Return 1
}

AG3_GetID3Picture(File, Index){
  Return AG3_AddGetPicture("ID3V2Get", File, Index)
}
AG3_GetWMAPicture(File, Index){
  Return AG3_AddGetPicture("WMAGet", File, Index)
}
AG3_GetMP4Picture(File, Index){
  Return AG3_AddGetPicture("MP4Get", File, Index)
}
AG3_AddID3Picture(File, Description, PictureType){
  Return AG3_AddGetPicture("ID3V2Add", File, Description, PictureType)
}
AG3_AddWMAPicture(File, Description, PictureType){
  Return AG3_AddGetPicture("WMAAdd", File, Description, PictureType)
}
AG3_AddMP4Picture(File){
  Return AG3_AddGetPicture("MP4Add", File)
}
AG3_AddGetPicture(Func, File, DescOrIndex="", PictureType=""){
  Func .= "PictureFileW"
  ATOU(FileU,File)
  If InStr(Func,"Get") {
    Return DllCall( "AudioGenie3\" Func, Str,FileU, Short,DescOrIndex )
  }Else {
    ATOU(DescriptionU,DescOrIndex)    
    If InStr(Func,"MP4")
      Return DllCall( "AudioGenie3\" Func, Str,FileU)
    Else If InStr(Func,"ID3") ;add as file not as link
      Return DllCall( "AudioGenie3\" Func, Str,FileU, Str,Description, Short,PictureType, Short,0 )
    Else  ;add at the end; do not overwrite
      Return DllCall( "AudioGenie3\" Func, Str,FileU, Str,Description, Short,PictureType, Short,1+AG3_GetWMAPictureCount() )
  }
}
; WMAGetPictureFileW   (LPCWSTR FileName, short Index)
; ID3V2GetPictureFileW (LPCWSTR FileName, short Index)
; MP4GetPictureFileW   (LPCWSTR FileName, short Index)
; WMAAddPictureFileW   (LPCWSTR FileName, LPCWSTR Description, short PictureType, short Index)
; ID3V2AddPictureFileW (LPCWSTR FileName, LPCWSTR Description, short PictureType, short asLink)
; MP4AddPictureFileW   (LPCWSTR FileName)

AG3_DeleteFrame(FrameID, Index=0){
  FrameIDH := "0x" . AscToHex(FrameID)
  If Index=0
    Return DllCall("AudioGenie3\ID3V2DeleteAllFramesW", Int,FrameIDH)
  Else If Index is number
    If Index > 0
      Return DllCall("AudioGenie3\ID3V2DeleteSelectedFrameW", Int,FrameIDH , Short,Index )
}
; ID3V2DeleteSelectedFrameW (u32 FrameID, short Index)
; ID3V2DeleteAllFramesW     (u32 FrameID)

AG3_RemoveID3v2Tag(File=""){
  Return AG3_RemoveTag("ID3v2", File)  
}
AG3_RemoveID3v1Tag(File=""){
  Return AG3_RemoveTag("ID3v1", File)  
}
AG3_RemoveAPETag(File=""){
  Return AG3_RemoveTag("APE", File)  
}
AG3_RemoveLYRICSTag(File=""){
  Return AG3_RemoveTag("LYRICS", File)  
}
AG3_RemoveOGGTag(File=""){
  Return AG3_RemoveTag("OGG", File)  
}
AG3_RemoveTag(Func, File=""){
  Func .= "RemoveTag"
  If File {
    ATOU(FileU,File)
    Return DllCall( "AudioGenie3\" Func "FromFileW", Str,FileU )
  }Else {
    Return DllCall( "AudioGenie3\" Func "W" )
  }
}
; ID3V2RemoveTagW          ()
; ID3V2RemoveTagFromFileW  (LPCWSTR FileName)
; ID3V1RemoveTagW          ()
; ID3V1RemoveTagFromFileW  (LPCWSTR FileName)
; APERemoveTagW            ()
; APERemoveTagFromFileW    (LPCWSTR FileName)
; LYRICSRemoveTagW         ()
; LYRICSRemoveTagFromFileW (LPCWSTR FileName)
; OGGRemoveTagW            ()
; OGGRemoveTagFromFileW    (LPCWSTR FileName)

AG3_Save(File=""){
  Return AG3_SaveChanges("AUDIO", File)
}
AG3_SaveID3V2(File=""){
  Return AG3_SaveChanges("ID3V2", File)
}
AG3_SaveID3V1(File=""){
  Return AG3_SaveChanges("ID3V1", File)
}
AG3_SaveWMA(File=""){
  Return AG3_SaveChanges("WMA", File)
}
AG3_SaveMP4(File=""){
  Return AG3_SaveChanges("MP4", File)
}
AG3_SaveAPE(File=""){
  Return AG3_SaveChanges("APE", File)
}
AG3_SaveLYRICS(File=""){
  Return AG3_SaveChanges("LYRICS", File)
}
AG3_SaveOGG(File=""){
  Return AG3_SaveChanges("OGG", File)
}
AG3_SaveFLAC(File=""){
  Return AG3_SaveChanges("FLAC", File)
}
AG3_SaveChanges(Func, File=""){
  Func .= "SaveChanges"
  If File {
    ATOU(FileU,File)
    Return DllCall( "AudioGenie3\" Func "ToFileW", Str,FileU )
  }Else {
    Return DllCall( "AudioGenie3\" Func "W" )
  }
}
; ID3V2SaveChangesW        ()
; ID3V2SaveChangesToFileW  (LPCWSTR FileName)
; WMASaveChangesW          ()
; WMASaveChangesToFileW    (LPCWSTR FileName)
; OGGSaveChangesW          ()
; OGGSaveChangesToFileW    (LPCWSTR FileName)
; MP4SaveChangesW          ()
; MP4SaveChangesToFileW    (LPCWSTR FileName)
; LYRICSSaveChangesW       ()
; LYRICSSaveChangesToFileW (LPCWSTR FileName)
; APESaveChangesW          ()
; APESaveChangesToFileW    (LPCWSTR FileName)
; ID3V1SaveChangesW        ()
; ID3V1SaveChangesToFileW  (LPCWSTR FileName)
; AUDIOSaveChangesW        ()
; AUDIOSaveChangesToFileW  (LPCWSTR FileName)
; FLACSaveChangesW         ()
; FLACSaveChangesToFileW   (LPCWSTR FileName)

AG3_PictureTypeName(PicType, Language="ENG"){    ;for WMA and ID3 V2.4.0, V2.3.0 and V2.2.0
  static KnownTypesENG :=
          (LTrim
           "0 Other                                          
            1 32x32 pixels 'file icon' (PNG only)            
            2 Other file icon                                
            3 Cover (front)                                  
            4 Cover (back)                                   
            5 Leaflet page                                   
            6 Media (e.g. lable side of CD)                  
            7 Lead artist/lead performer/soloist             
            8 Artist/performer                               
            9 Conductor                                      
            10 Band/Orchestra                                 
            11 Composer                                       
            12 Lyricist/text writer                           
            13 Recording Location                             
            14 During recording                               
            15 During performance                             
            16 Movie/video screen capture                     
            17 A bright coloured fish                         
            18 Illustration                                   
            19 Band/artist logotype                           
            20 Publisher/Studio logotype"                     
          )
  static KnownTypesDEU :=
          (LTrim
           "0 Anders                                          
            1 32x32 pixel 'Dateisymbol' (nur PNG)            
            2 Anderes Dateisymbol                                
            3 Hülle (Front)                                  
            4 Hülle (Rückseite)                                   
            5 Broschürenseite                                   
            6 Medie (z.B. bedruckte Seite der CD)                  
            7 Hauptkünstler/Hauptdarsteller/Soloist             
            8 Artist/Darsteller                               
            9 Dirigent                                      
            10 Band/Orchester                                 
            11 Komponist                                       
            12 Liedtextschreiber                           
            13 Aufnahmeort                             
            14 Während der Aufnahme                               
            15 Während der Aufführung                             
            16 Film/Video Schnappschuß                     
            17 Ein hell leuchtender Fisch                         
            18 Illustration                                   
            19 Band/Künstler Logo                           
            20 Verlag/Studio Logo"                     
          )
  Needle := "m`n)" PicType " (?P<Value>.*)$"
  RegExMatch(KnownTypes%Language%,Needle,Return)
  Return ReturnValue                                                                                                             
}

;Returns Description of Frame ID or Translates between FrameIDs                                                                                                                        
AG3_FrameIDName(FrameID, Language="ENG"){    ;for ID3 V2.2.0, V2.3.0 and V2.4.0                                                                                            
  static KnownTagsENG :=                                                                                                    
          (LTrim
           ";V2.3 V2.2 Description
             AENC CRA Audio encryption                                 
             APIC PIC Attached picture                                   
             COMM COM Comments                                         
             COMR     Commercial frame                                                      
             ENCR CRM Encryption method registration    ????  ;ToDo: is this identical between 2.2 and 2.3?                       
             EQUA EQU Equalization                                                   
             ETCO ETC Event timing codes                                                                      
             GEOB GEO General encapsulated object                         
             GRID     Group identification registration                   
             IPLS IPL Involved people list                             
             LINK LNK Linked information                                                      
             MCDI MCI Music CD identifier                              
             MLLT MLL MPEG location lookup table                         
             OWNE     Ownership frame                                                      
             PRIV     Private frame                                                
             PCNT CNT Play counter                                                                        
             POPM POP Popularimeter                                        
             POSS     Position synchronisation frame                       
             RBUF BUF Recommended buffer size                                                             
             RVAD RVA Relative volume adjustment                                       
             RVRB REV Reverb                                                                               
             SYLT SLT Synchronized lyric/text                          
             SYTC STC Synchronized tempo codes                         
             TALB TAL Album/Movie/Show title                           
             TBPM TBP BPM (beats per minute)                           
             TCOM TCM Composer                                                                     
             TCON TCO Content type                                          
             TCOP TCR Copyright message                                     
             TDAT TDA Date                                             
             TDLY TDY Playlist delay                                                                 
             TENC TEN Encoded by                                                       
             TEXT TXT Lyricist/Text writer                                          
             TFLT TFT File type                                        
             TIME TIM Time                                             
             TIT1 TT1 Content group description                                                                  
             TIT2 TT2 Title/songname/content description                             
             TIT3 TT3 Subtitle/Description refinement                                  
             TKEY TKE Initial key                                                    
             TLAN TLA Language(s)                                                 
             TLEN TLE Length                                                      
             TMED TMT Media type                                       
             TOAL TOT Original album/movie/show title                                              
             TOFN TOF Original filename                                                                
             TOLY TOL Original lyricist(s)/text writer(s)                          
             TOPE TOA Original artist(s)/performer(s)                                                          
             TORY TOR Original release year                            
             TOWN     File owner/licensee                              
             TPE1 TP1 Lead performer(s)/Soloist(s)                                                       
             TPE2 TP2 Band/orchestra/accompaniment                                                                     
             TPE3 TP3 Conductor/performer refinement                                                                   
             TPE4 TP4 Interpreted, remixed, or otherwise modified by                                        
             TPOS TPA Part of a set                                                 
             TPUB TPB Publisher                                                                  
             TRCK TRK Track number/Position in set                                                        
             TRDA TRD Recording dates                                  
             TRSN     Internet radio station name                      
             TRSO     Internet radio station owner                            
             TSIZ TSI Size                                             
             TSRC TRC ISRC (international standard recording code)                                                          
             TSSE TSS Software/Hardware and settings used for encoding                           
             TYER TYE Year                                             
             TXXX TXX User defined text information frame              
             UFID UFI Unique file identifier                                       
             USER     Terms of use                                         
             USLT ULT Unsychronized lyric/text transcription           
             WCOM WCM Commercial information                           
             WCOP WCP Copyright/Legal information                      
             WOAF WAF Official audio file webpage                      
             WOAR WAR Official artist/performer webpage                
             WOAS WAS Official audio source webpage                    
             WORS     Official internet radio station homepage         
             WPAY     Payment                                          
             WPUB WPB Publishers official webpage                                  
             WXXX WXX User defined URL link frame
             ;new in 2.4.0              
             TSOA     Album sort order      
             TSOP     Performer sort order  
             TSOT     Title sort order      
             TSST     Set subtitle          
             TDEN     Encoding time         
             TDOR     Original release time 
             TDRC     Recording time        
             TDRL     Release time          
             TDTG     Tagging time          
             TIPL     Involved people list  
             TMCL     Musician credits list 
             TMOO     Mood                  
             SEEK     Seek frame            
             SIGN     Signature frame       
             TPRO     Produced notice       
             ASPI     Audio seek point index"                                 
          )                                                                                                                                       
  static KnownTagsDEU :=                                                                                                    
          (LTrim
           ";V2.3 V2.2 Description
             AENC CRA Audio Verschlüsselung                                 
             APIC PIC Angefügtes Bild                                   
             COMM COM Kommentare                                         
             COMR     Kommerzieller Frame                                                      
             ENCR CRM Verschlüsselungs Method                      
             EQUA EQU Equalization                                                   
             ETCO ETC Event timing codes                                                                      
             GEOB GEO General encapsulated object                         
             GRID     Group identification registration                   
             IPLS IPL Liste involvierter Menschen                             
             LINK LNK Verknüpfte Information                                                      
             MCDI MCI Musik CD Identifikator                              
             MLLT MLL MPEG location lookup table                         
             OWNE     Eigentumsframe                                                      
             PRIV     Privater Frame                                                
             PCNT CNT Abspielzähler                                                                        
             POPM POP Beliebtheitsmeter                                        
             POSS     Position synchronisation frame                       
             RBUF BUF Empfohlene Buffergröße                                                             
             RVAD RVA Relative Lautstärkenanpassung                                       
             RVRB REV Hall                                                                               
             SYLT SLT Synchronisierter Liedtext                          
             SYTC STC Synchronized tempo codes                         
             TALB TAL Album-/Film-/Showtitel                           
             TBPM TBP BPM (Schläge pro Minute)                           
             TCOM TCM Komponist                                                                     
             TCON TCO Inhaltstyp                                          
             TCOP TCR Urheberrechtsnachricht                                     
             TDAT TDA Datum                                             
             TDLY TDY Abspiellistenverzögerung                                                                 
             TENC TEN Encoded von                                                       
             TEXT TXT Liedtextschreiber                                          
             TFLT TFT Dateityp                                        
             TIME TIM Zeit                                             
             TIT1 TT1 Gruppeninhaltsbeschreibung                                                                  
             TIT2 TT2 Titel/Liedname/Inhaltsbeschreibung                             
             TIT3 TT3 Untertitel/Verfeinerte Beschreibung                                  
             TKEY TKE Initialer Notenschlüssel                                                    
             TLAN TLA Sprache(n)                                                 
             TLEN TLE Länge                                                      
             TMED TMT Medientyp                                       
             TOAL TOT Originaler Album-/Film-/Showtitel                                              
             TOFN TOF Originaler Dateiname                                                                
             TOLY TOL Originale(r) Liedtextschreiber                          
             TOPE TOA Originale(r) Künstler/Darsteller                                                          
             TORY TOR Originales Veröffentlichungsjahr                            
             TOWN     Dateibesitzer/Lizenz                              
             TPE1 TP1 Hauptdarsteller/Soloist(en)                                                       
             TPE2 TP2 Band/Orchester/Begleitung                                                                     
             TPE3 TP3 Dirigent/Verfeinerte Darsteller                                                                   
             TPE4 TP4 Interpretiert, remixed, oder anderart modifiziert von                                        
             TPOS TPA Teil eines Sets                                                 
             TPUB TPB Verlag                                                                  
             TRCK TRK Titelnumber/Position im Set                                                        
             TRDA TRD Aufnahmedatum                                  
             TRSN     Internetradiostationsname                      
             TRSO     Internetradiostationsbesitzer                            
             TSIZ TSI Größe                                             
             TSRC TRC ISRC (international standard recording code)                                                          
             TSSE TSS Software/Hardware und benutzte Einstellungen für das Encoding                           
             TYER TYE Jahr                                             
             TXXX TXX Benutzer definierter Textinformationsframe              
             UFID UFI Einzigartiger Dateiidentifikator                                       
             USER     Nutzungsbedingungen                                         
             USLT ULT Unsychronisierte Liedtextübersetzung           
             WCOM WCM Kommerzielle Information                           
             WCOP WCP Urheberrecht/Impressum                     
             WOAF WAF Offizielle Audiodatei Webpage                      
             WOAR WAR Offizielle Künstler/Darsteller Webpage                
             WOAS WAS Offizielle Audioquellen Webpage                    
             WORS     Offizielle Internetradiostationshomepage         
             WPAY     Bezahlung                                          
             WPUB WPB Offizielle Verlagswebpage                                  
             WXXX WXX Benutzerdefinierter URL Frame
             ;new in 2.4.0              
             TSOA     Album Sortierreihenfolge      
             TSOP     Darsteller Sortierreihenfolge  
             TSOT     Titel Sortierreihenfolge      
             TSST     Setuntertitel          
             TDEN     Encodingdatum         
             TDOR     Originale Veröffentlichung 
             TDRC     Aufnahmedatum        
             TDRL     Veröffentlichungsdatum          
             TDTG     Tagging Datum          
             TIPL     Liste involvierter Menschen  
             TMCL     Liste mitwirkender Musiker 
             TMOO     Stimmung                  
             SEEK     Seek frame            
             SIGN     Signaturenframe       
             TPRO     Produktionsnotiz       
             ASPI     Audio seek point index"                                 
          )                                                                                                                                       
  If (StrLen(FrameID) = 4)
    Needle := "mS`n)^" FrameID " .{3} (?P<Value>.*)$"
  Else
    Needle := "mS`n)^.{4} " FrameID " (?P<Value>.*)$"
  RegExMatch(KnownTags%Language%,Needle,Return)                                                                                 
  Return ReturnValue                                                                                                             
}                                                                                                                         

AG3(Func, FrameIDOrStringOrIndex="", StringOrIndex=""){
  static WithFrame := "MP4SetTextFrameW,WAVSetTextFrameW,MP4GetTextFrameW,WAVGetTextFrameW"
  static WithIndex :=
    (Ltrim Join,
      "ID3V1GetGenreItemW,ID3V1SetGenreIDW,ID3V2GetUserTextDescriptionW
      ID3V2GetLinkedInformationFrameIdentifierW,ID3V2GetUserFrameLanguageW
      ID3V2GetUserTextW,ID3V2GetPrivateFrameURLW,ID3V2GetRelativeVolumeAdjustmentIdentifierW
      ID3V2GetUserFrameW,ID3V2GetUserURLDescriptionW,ID3V2GetUserURLW
      ID3V2GetEqualisationIdentificationW,ID3V2GetAudioEncryptionPreviewStartW
      ID3V2GetGroupIdentificationURLW,ID3V2GetLinkedInformationAdditionalDataW
      ID3V2GetLinkedInformationURLW,ID3V2GetGeneralObjectMimeW,ID3V2GetCommercialFrameSellerNameW
      ID3V2GetGeneralObjectDescriptionW,ID3V2GetGeneralObjectFilenameW
      ID3V2GetCommercialFramePriceW,ID3V2GetCommercialFrameValidUntilW
      ID3V2GetEncryptionURLW,ID3V2GetSyncLyricContentTypeW,ID3V2GetAudioEncryptionPreviewLengthW
      ID3V2GetSignatureFrameGroupSymbolW,ID3V2GetSyncLyricTimeFormatW,ID3V2GetCommercialFramePictureMimeW
      ID3V2GetCommercialFrameContactURLW,ID3V2GetAudioEncryptionURLW
      ID3V2GetCommercialFrameDescriptionW,ID3V2GetSyncLyricDescriptionW
      ID3V2GetSyncLyricLanguageW,ID3V2GetGroupIdentificationSymbolW,WMADeletePictureW
      ID3V2GetSyncLyricW,ID3V2GetUniqueFileIdentifierOwnerW,ID3V2GetEqualisationInterpolationW
      ID3V2GetEqualisationAdjustmentBitsW,ID3V2GetEncryptionSymbolW
      ID3V2GetCommercialFrameReceivedAsW"
    ) 
  static WithString :=
    (Ltrim Join,
      "APESetAlbumW,APESetArtistW,APESetTrackW,APESetYearW,ID3V1SetYearW,APESetCopyrightW
      APESetCommentW,ID3V1SetArtistW,FLACSetOrganizationW,FLACSetVendorW,FLACSetLocationW
      APESetTitleW,APESetGenreW,ID3V1SetAlbumW,FLACSetPerformerW,ID3V1SetGenreW
      WMASetBeatsPerMinuteW,WMASetAlbumW,WMASetAuthorURLW,WMASetArtistW,OGGSetISRCW
      WMASetCategoryW,WMASetAlbumArtistW,WMASetCommentW,ID3V1SetTrackW,ID3V1SetTitleW
      WMASetPartOfSetW,WMASetParentalRatingW,LYRICSSetAuthorW,WMASetPeriodW
      WMASetPublisherW,WMASetTitleW,WMASetProducerW,WMASetRatingW,WMASetToolVersionW
      WMASetYearW,WMASetTrackNumberW,ID3V2SetGenreW,WMASetWriterW,LYRICSSetArtistW
      LYRICSSetAlbumW,WMASetUserWebURLW,WMASetToolNameW,FLACSetCopyrightW,FLACSetContactW
      FLACSetAlbumW,FLACSetCommentW,FLACSetTitleW,FLACSetVersionW,FLACSetLicenseW
      FLACSetTrackW,FLACSetDateW,ID3V1SetCommentW,WMASetProviderW,WMASetPromotionURLW
      FLACSetGenreW,FLACSetArtistW,FLACSetDescriptionW,FLACSetISRCW,OGGSetGenreW
      OGGSetCommentW,OGGSetArtistW,OGGSetDateW,WMASetLanguageW,LYRICSSetIndicationW
      LYRICSSetInformationW,WMASetContentGroupDescriptionW,OGGSetVendorW,OGGSetTrackW
      WMASetConductorW,OGGSetVersionW,WMASetMoodW,OGGSetCopyrightW,WMASetLyricsW
      LYRICSSetGenreW,LYRICSSetImageLinkW,WMASetEncodedByW,WMASetEncodingSettingsW
      WMASetEncodingTimeW,WMASetComposerW,WMASetInitialKeyW,WMASetISRCW,WMASetGenreW
      OGGSetTitleW,OGGSetAlbumW,WMASetCopyrightW,MP4SetGenreW,MP4SetTrackW
      OGGSetPerformerW,OGGSetOrganizationW,OGGSetDescriptionW,OGGSetLocationW
      OGGSetLicenseW,OggSetContactW,WMASetDistributorW,LYRICSSetTitleW,LYRICSSetLyricsW
      OGGGetUserItemW,FLACGetUserItemW,WMAGetUserItemW,SetPopupKeyW,APEGetUserItemW
      ID3V2GetChapterEndTimeW,ID3V2GetAddendumTypeW,ID3V2GetTOCIsOrderedW
      ID3V2GetChapterStartTimeW,ID3V2GetAddendumTitleW,ID3V2GetSubFramesW
      ID3V2GetAddendumDescriptionW,ID3V2GetChildElementsW,GetMD5ValueFromFileW,ID3V2ImportCueFileW"    
    )
  static WithoutParam :=
    (Ltrim Join,
      "ID3V2GetSynchronizedTempoFormatW,ID3V2GetReverbFeedbackRightToRightW
      ID3V2GetReverbLeftW,ID3V2GetReverbPremixLeftToRightW,ID3V2GetReverbFeedbackLeftToRightW
      ID3V2GetReverbFeedbackRightToLeftW,ID3V2GetReverbBouncesRightW
      ID3V2GetPositionSynchronisationTimestampFormatW,ID3V2GetRecommendedBufferSizeFlagW
      ID3V2GetReverbBouncesLeftW,ID3V2GetEventTimingCodesTimestampFormatW,WMAGetDistributorW
      WMAGetEncodedByW,WMAGetContentGroupDescriptionW,WMAGetISRCW,WMAGetProducerW
      WMAGetParentalRatingW,WMAGetPartOfSetW,WMAGetEncodingTimeW,ID3V2GetReverbPremixRightToLeftW
      ID3V2GetReverbRightW,WMAGetEncodingSettingsW,WMAGetCopyrightW,WMAGetGenreW
      WMAGetInitialKeyW,MONKEYGetSamplesW,MPEGIsOriginalW,MPEGIsPaddingW,MPEGIsPrivateW
      MPEGIsCopyrightedW,MPEGGetFramePositionW,MPEGGetFrameSizeW,LYRICSGetStartPositionW
      MPPGetFramesW,MONKEYGetFramesW,MONKEYGetSamplesPerFrameW,MPEGGetFramesW
      MPPGetStreamVersionW,MPEGIsVBRW,ID3V2GetReverbFeedbackLeftToLeftW,MONKEYGetBitsW
      WAVGetFormatIDW,MPEGIsProtectedW,WMAGetPeriodW,ID3V2GetAudioSeekPointNumberW
      FLACGetSamplesW,ID3V2GetAudioSeekPointBitsPerIndexpointW,ID3V2GetAudioSeekPointLengthW
      WMAGetUserWebURLW,WMAGetToolNameW,WMAGetToolVersionW,FLACGetMinFrameSizeW
      ID3V2GetMpegLocationLookupTableBytesDeviationW,ID3V2GetMpegLocationLookupTableBytesW
      ID3V2GetMpegLocationLookupTableFramesW,ID3V2GetAudioSeekPointStartW,MONKEYGetPeakW
      FLACGetCompressionRatioW,MONKEYGetCompressionRatioW,WMAGetYearW,WMAGetProviderW
      WMAGetPublisherW,WMAGetTrackNumberW,WMAGetTitleW,APEGetSizeW,WMAGetWriterW
      WMAGetRatingW,OGGGetLocationW,OGGGetOrganizationW,OGGGetVersionW,OGGGetTitleW
      WMAGetCommentW,WMAGetAlbumArtistW,OGGGetPerformerW,WMAGetMoodW,WMAGetItemKeysW
      WMAGetLanguageW,WMAGetLyricsW,WAVGetFormatW,OGGGetTrackW,OGGGetVendorW
      FLACGetBitsPerSampleW,FLACGetMaxBlockSizeW,WMAGetPromotionURLW,FLACGetMinBlockSizeW
      FLACGetMaxFrameSizeW,WMAGetComposerW,WMAGetConductorW,WMAGetCategoryW,WMAGetArtistW
      WMAGetAuthorURLW,WMAGetBeatsPerMinuteW,WMAGetAlbumW,ID3V2GetPositionSynchronisationValueW
      LYRICSGetTitleW,LYRICSGetLyricsW,LYRICSGetVersionW,OGGGetCopyrightW,OGGGetGenreW
      OGGGetDateW,OggGetContactW,MP4GetGenreW,MPEGGetEmphasisW,MP4GetTrackW,MPEGGetEncoderW
      OGGGetISRCW,MONKEYGetCompressionW,AACGetHeaderTypeW,FLACGetGenreW,FLACGetISRCW
      FLACGetLocationW,AACGetBitRateTypeW,FLACGetItemKeysW,FLACGetLicenseW,FLACGetPerformerW
      OGGGetDescriptionW,FLACGetOrganizationW,FLACGetTrackW,FLACGetVendorW,FLACGetTitleW
      LYRICSGetAuthorW,LYRICSGetArtistW,LYRICSGetGenreW,APEGetCommentW,APEGetYearW
      APEGetTrackW,APEGetVersionW,LYRICSGetAlbumW,ID3V2GetVersionW,APEGetArtistW
      LYRICSGetIndicationW,LYRICSGetImageLinkW,APEGetAlbumW,MPEGGetLayerW,MPEGGetVersionW
      LYRICSGetInformationW,OGGGetAlbumW,AACGetProfileW,OGGGetArtistW,OGGGetCommentW
      APEGetCopyrightW,ID3V2GetTOCRootIDW,OGGGetItemKeysW,OGGGetLicenseW,APEGetItemKeysW
      APEGetTitleW,APEGetGenreW,ID3V1GetTitleW,OGGGetBitRateNominalW,WAVGetBitsPerSampleW
      WAVGetBytesPerSecondW,ID3V1GetGenresW,WAVGetBlockAlignW,FLACGetAlbumW
      ID3V2GetOwnershipDateW,ID3V2GetOwnershipSellerW,WAVGetChannelsW,WAVGetHeaderSizeW
      LYRICSGetSizeW,ID3V2GetRecommendedBufferSizeValueW,ID3V2GetSeekOffsetW,ID3V2GetSizeW
      ID3V2GetRecommendedBufferSizeOffsetW,ID3V2GetMpegLocationLookupTableMillisecondsW
      ID3V1GetGenreIDW,ID3V2GetGenreW,ID3V1GetArtistW,ID3V1GetCommentW,WMADeletePicturesW
      ID3V2GetPossibleCHAPIDW,ID3V1GetVersionW,ID3V1GetYearW,ID3V1GetTrackW,ID3V1GetGenreW
      ID3V1GetAlbumW,FLACGetVersionW,GetAudioGenieVersionW,FLACGetCopyrightW,FLACGetCommentW
      FLACGetContactW,FLACGetDescriptionW,ID3V2GetOwnershipPriceW,FLACGetArtistW
      FLACGetDateW,ID3V2GetPossibleTOCIDW,AUDIOGetLastErrorNumberW,AUDIOGetSampleRateW
      AUDIOGetBitrateW,AUDIOGetChannelsW,AUDIOGetDurationW,AUDIOGetDurationMillisW
      AUDIOGetFileSizeW,AUDIOIsValidFormatW,AUDIOGetMD5ValueW,AUDIOGetVersionW
      AUDIOGetChannelModeW,AUDIOGetLastErrorTextW,AUDIOGetLastFileW
      ID3V2GetMpegLocationLookupTableMillisecondsDeviationW"
    )
  If Func in WithoutParam
    Return UTOA(DllCall("AudioGenie3\" Func))
  Else If Func in WithIndex
    Return UTOA(DllCall("AudioGenie3\" Func, Short,FrameIDOrStringOrIndex))           
  Else If Func in WithString
  {
    ATOU(StringU,FrameIDOrStringOrIndex)
    Return UTOA(DllCall("AudioGenie3\" Func, Str,StringU))
  }
  Else If Func in WithFrame
  {
    FrameIDH := "0x" . AscToHex(FrameIDOrStringOrIndex)
    If InStr(Func, "Set"){
      ATOU(StringU,StringOrIndex)
      Return DllCall("AudioGenie3\" Func, Int,FrameIDH , Str,StringU)
    }Else If InStr(Func, "Sel") 
      Return DllCall("AudioGenie3\" Func, Int,FrameIDH , Short,StringOrIndex)
    Else
      Return UTOA(DllCall("AudioGenie3\" Func, Int,FrameIDH ))
  }Else
    Return -1, ErrorLevel := "Not yet supported AudioGenie Function"
}

;WithFrame
; MP4SetTextFrameW          (u32 FrameID, LPCWSTR textString)
; WAVSetTextFrameW          (u32 FrameID, LPCWSTR textString)
; MP4GetTextFrameW          (u32 FrameID)
; WAVGetTextFrameW          (u32 FrameID)

;WithIndex
; ID3V1GetGenreItemW                          (short number)
; ID3V1SetGenreIDW                            (short nNewValue)
; ID3V2GetUserTextDescriptionW                (short Index)
; ID3V2GetLinkedInformationFrameIdentifierW   (short Index)
; ID3V2GetUserFrameLanguageW                  (short Index)
; ID3V2GetUserTextW                           (short Index)
; ID3V2GetPrivateFrameURLW                    (short Index)
; ID3V2GetRelativeVolumeAdjustmentIdentifierW (short Index)
; ID3V2GetUserFrameW                          (short Index)
; ID3V2GetUserURLDescriptionW                 (short Index)
; ID3V2GetUserURLW                            (short Index)
; ID3V2GetEqualisationIdentificationW         (short Index)
; ID3V2GetGroupIdentificationURLW             (short Index)
; ID3V2GetLinkedInformationAdditionalDataW    (short Index)
; ID3V2GetLinkedInformationURLW               (short Index)
; ID3V2GetGeneralObjectMimeW                  (short Index)
; ID3V2GetCommercialFrameSellerNameW          (short Index)
; ID3V2GetGeneralObjectDescriptionW           (short Index)
; ID3V2GetGeneralObjectFilenameW              (short Index)
; ID3V2GetCommercialFramePriceW               (short Index)
; ID3V2GetCommercialFrameValidUntilW          (short Index)
; ID3V2GetEncryptionURLW                      (short Index)
; ID3V2GetSyncLyricContentTypeW               (short Index)
; ID3V2GetAudioEncryptionPreviewLengthW       (short Index)
; ID3V2GetSignatureFrameGroupSymbolW          (short Index)
; ID3V2GetSyncLyricTimeFormatW                (short Index)
; ID3V2GetCommercialFramePictureMimeW         (short Index)
; ID3V2GetCommercialFrameContactURLW          (short Index)
; ID3V2GetAudioEncryptionURLW                 (short Index)
; ID3V2GetCommercialFrameDescriptionW         (short Index)
; ID3V2GetSyncLyricDescriptionW               (short Index)
; ID3V2GetSyncLyricLanguageW                  (short Index)
; ID3V2GetGroupIdentificationSymbolW          (short Index)
; ID3V2GetSyncLyricW                          (short Index)
; ID3V2GetUniqueFileIdentifierOwnerW          (short Index)
; ID3V2GetEqualisationInterpolationW          (short Index)
; ID3V2GetEqualisationAdjustmentBitsW         (short Index)
; ID3V2GetEncryptionSymbolW                   (short Index)
; ID3V2GetCommercialFrameReceivedAsW          (short Index)
; ID3V2GetAudioEncryptionPreviewStartW        (short Index)
; WMADeletePictureW                           (short Index)

;WithString
; APESetAlbumW                   (LPCWSTR textString)
; APESetArtistW                  (LPCWSTR textString)
; APESetTrackW                   (LPCWSTR textString)
; APESetYearW                    (LPCWSTR textString)
; ID3V1SetYearW                  (LPCWSTR textString)
; APESetCopyrightW               (LPCWSTR textString)
; APESetCommentW                 (LPCWSTR textString)
; ID3V1SetArtistW                (LPCWSTR textString)
; FLACSetOrganizationW           (LPCWSTR textString)
; FLACSetVendorW                 (LPCWSTR textString)
; FLACSetLocationW               (LPCWSTR textString)
; APESetTitleW                   (LPCWSTR textString)
; APESetGenreW                   (LPCWSTR textString)
; ID3V1SetAlbumW                 (LPCWSTR textString)
; FLACSetPerformerW              (LPCWSTR textString)
; ID3V1SetGenreW                 (LPCWSTR textString)
; WMASetBeatsPerMinuteW          (LPCWSTR textString)
; WMASetAlbumW                   (LPCWSTR textString)
; WMASetAuthorURLW               (LPCWSTR textString)
; WMASetArtistW                  (LPCWSTR textString)
; OGGSetISRCW                    (LPCWSTR textString)
; WMASetCategoryW                (LPCWSTR textString)
; WMASetAlbumArtistW             (LPCWSTR textString)
; WMASetCommentW                 (LPCWSTR textString)
; ID3V1SetTrackW                 (LPCWSTR textString)
; ID3V1SetTitleW                 (LPCWSTR textString)
; WMASetPartOfSetW               (LPCWSTR textString)
; WMASetParentalRatingW          (LPCWSTR textString)
; LYRICSSetAuthorW               (LPCWSTR textString)
; WMASetPeriodW                  (LPCWSTR textString)
; WMASetPublisherW               (LPCWSTR textString)
; WMASetTitleW                   (LPCWSTR textString)
; WMASetProducerW                (LPCWSTR textString)
; WMASetRatingW                  (LPCWSTR textString)
; WMASetToolVersionW             (LPCWSTR textString)
; WMASetYearW                    (LPCWSTR textString)
; WMASetTrackNumberW             (LPCWSTR textString)
; ID3V2SetGenreW                 (LPCWSTR textString)
; WMASetWriterW                  (LPCWSTR textString)
; LYRICSSetArtistW               (LPCWSTR textString)
; LYRICSSetAlbumW                (LPCWSTR textString)
; WMASetUserWebURLW              (LPCWSTR textString)
; WMASetToolNameW                (LPCWSTR textString)
; FLACSetCopyrightW              (LPCWSTR textString)
; FLACSetContactW                (LPCWSTR textString)
; FLACSetAlbumW                  (LPCWSTR textString)
; FLACSetCommentW                (LPCWSTR textString)
; FLACSetTitleW                  (LPCWSTR textString)
; FLACSetVersionW                (LPCWSTR textString)
; FLACSetLicenseW                (LPCWSTR textString)
; FLACSetTrackW                  (LPCWSTR textString)
; FLACSetDateW                   (LPCWSTR textString)
; ID3V1SetCommentW               (LPCWSTR textString)
; WMASetProviderW                (LPCWSTR textString)
; WMASetPromotionURLW            (LPCWSTR textString)
; FLACSetGenreW                  (LPCWSTR textString)
; FLACSetArtistW                 (LPCWSTR textString)
; FLACSetDescriptionW            (LPCWSTR textString)
; FLACSetISRCW                   (LPCWSTR textString)
; OGGSetGenreW                   (LPCWSTR textString)
; OGGSetCommentW                 (LPCWSTR textString)
; OGGSetArtistW                  (LPCWSTR textString)
; OGGSetDateW                    (LPCWSTR textString)
; WMASetLanguageW                (LPCWSTR textString)
; LYRICSSetIndicationW           (LPCWSTR textString)
; LYRICSSetInformationW          (LPCWSTR textString)
; WMASetContentGroupDescriptionW (LPCWSTR textString)
; OGGSetVendorW                  (LPCWSTR textString)
; OGGSetTrackW                   (LPCWSTR textString)
; WMASetConductorW               (LPCWSTR textString)
; OGGSetVersionW                 (LPCWSTR textString)
; WMASetMoodW                    (LPCWSTR textString)
; OGGSetCopyrightW               (LPCWSTR textString)
; WMASetLyricsW                  (LPCWSTR textString)
; LYRICSSetGenreW                (LPCWSTR textString)
; LYRICSSetImageLinkW            (LPCWSTR textString)
; WMASetEncodedByW               (LPCWSTR textString)
; WMASetEncodingSettingsW        (LPCWSTR textString)
; WMASetEncodingTimeW            (LPCWSTR textString)
; WMASetComposerW                (LPCWSTR textString)
; WMASetInitialKeyW              (LPCWSTR textString)
; WMASetISRCW                    (LPCWSTR textString)
; WMASetGenreW                   (LPCWSTR textString)
; OGGSetTitleW                   (LPCWSTR textString)
; OGGSetAlbumW                   (LPCWSTR textString)
; WMASetCopyrightW               (LPCWSTR textString)
; MP4SetGenreW                   (LPCWSTR textString)
; MP4SetTrackW                   (LPCWSTR textString)
; OGGSetPerformerW               (LPCWSTR textString)
; OGGSetOrganizationW            (LPCWSTR textString)
; OGGSetDescriptionW             (LPCWSTR textString)
; OGGSetLocationW                (LPCWSTR textString)
; OGGSetLicenseW                 (LPCWSTR textString)
; OggSetContactW                 (LPCWSTR textString)
; WMASetDistributorW             (LPCWSTR textString)
; LYRICSSetTitleW                (LPCWSTR textString)
; LYRICSSetLyricsW               (LPCWSTR textString)
; OGGGetUserItemW                (LPCWSTR ItemKey)
; FLACGetUserItemW               (LPCWSTR ItemKey)
; WMAGetUserItemW                (LPCWSTR ItemKey)
; SetPopupKeyW                   (LPCWSTR keyValue)
; APEGetUserItemW                (LPCWSTR Key)
; ID3V2GetChapterEndTimeW        (LPCWSTR ID)
; ID3V2GetAddendumTypeW          (LPCWSTR ID)
; ID3V2GetTOCIsOrderedW          (LPCWSTR ID)
; ID3V2GetChapterStartTimeW      (LPCWSTR ID)
; ID3V2GetAddendumTitleW         (LPCWSTR ID)
; ID3V2DeleteAddendumW           (LPCWSTR ID)
; ID3V2GetSubFramesW             (LPCWSTR ID)
; ID3V2GetAddendumDescriptionW   (LPCWSTR ID)
; ID3V2GetChildElementsW         (LPCWSTR ID)
; GetMD5ValueFromFileW           (LPCWSTR FileName)
; ID3V2ImportCueFileW            (LPCWSTR FileName)
                              
;WithoutParam                              
; ID3V2GetSynchronizedTempoFormatW                ()
; ID3V2GetReverbFeedbackRightToRightW             ()
; ID3V2GetReverbLeftW                             ()
; ID3V2GetReverbPremixLeftToRightW                ()
; ID3V2GetReverbFeedbackLeftToRightW              ()
; ID3V2GetReverbFeedbackRightToLeftW              ()
; ID3V2GetReverbBouncesRightW                     ()
; ID3V2GetPositionSynchronisationTimestampFormatW ()
; ID3V2GetRecommendedBufferSizeFlagW              ()
; ID3V2GetReverbBouncesLeftW                      ()
; ID3V2GetEventTimingCodesTimestampFormatW        ()
; WMAGetDistributorW                              ()
; WMAGetEncodedByW                                ()
; WMAGetContentGroupDescriptionW                  ()
; WMAGetISRCW                                     ()
; WMAGetProducerW                                 ()
; WMAGetParentalRatingW                           ()
; WMAGetPartOfSetW                                ()
; WMAGetEncodingTimeW                             ()
; ID3V2GetReverbPremixRightToLeftW                ()
; ID3V2GetReverbRightW                            ()
; WMAGetEncodingSettingsW                         ()
; WMAGetCopyrightW                                ()
; WMAGetGenreW                                    ()
; WMAGetInitialKeyW                               ()
; MONKEYGetSamplesW                               ()
; MPEGIsOriginalW                                 ()
; MPEGIsPaddingW                                  ()
; MPEGIsPrivateW                                  ()
; MPEGIsCopyrightedW                              ()
; MPEGGetFramePositionW                           ()
; MPEGGetFrameSizeW                               ()
; LYRICSGetStartPositionW                         ()
; MPPGetFramesW                                   ()
; MONKEYGetFramesW                                ()
; MONKEYGetSamplesPerFrameW                       ()
; MPEGGetFramesW                                  ()
; MPPGetStreamVersionW                            ()
; MPEGIsVBRW                                      ()
; ID3V2GetReverbFeedbackLeftToLeftW               ()
; MONKEYGetBitsW                                  ()
; WAVGetFormatIDW                                 ()
; MPEGIsProtectedW                                ()
; WMAGetPeriodW                                   ()
; ID3V2GetAudioSeekPointNumberW                   ()
; FLACGetSamplesW                                 ()
; ID3V2GetAudioSeekPointBitsPerIndexpointW        ()
; ID3V2GetAudioSeekPointLengthW                   ()
; WMAGetUserWebURLW                               ()
; WMAGetToolNameW                                 ()
; WMAGetToolVersionW                              ()
; FLACGetMinFrameSizeW                            ()
; ID3V2GetMpegLocationLookupTableBytesDeviationW  ()
; ID3V2GetMpegLocationLookupTableBytesW           ()
; ID3V2GetMpegLocationLookupTableFramesW          ()
; ID3V2GetAudioSeekPointStartW                    ()
; MONKEYGetPeakW                                  ()
; FLACGetCompressionRatioW                        ()
; MONKEYGetCompressionRatioW                      ()
; WMAGetYearW                                     ()
; WMAGetProviderW                                 ()
; WMAGetPublisherW                                ()
; WMAGetTrackNumberW                              ()
; WMAGetTitleW                                    ()
; APEGetSizeW                                     ()
; WMAGetWriterW                                   ()
; WMAGetRatingW                                   ()
; OGGGetLocationW                                 ()
; OGGGetOrganizationW                             ()
; OGGGetVersionW                                  ()
; OGGGetTitleW                                    ()
; WMAGetCommentW                                  ()
; WMAGetAlbumArtistW                              ()
; OGGGetPerformerW                                ()
; WMAGetMoodW                                     ()
; WMAGetItemKeysW                                 ()
; WMAGetLanguageW                                 ()
; WMAGetLyricsW                                   ()
; WAVGetFormatW                                   ()
; OGGGetTrackW                                    ()
; OGGGetVendorW                                   ()
; FLACGetBitsPerSampleW                           ()
; FLACGetMaxBlockSizeW                            ()
; WMAGetPromotionURLW                             ()
; FLACGetMinBlockSizeW                            ()
; FLACGetMaxFrameSizeW                            ()
; WMAGetComposerW                                 ()
; WMAGetConductorW                                ()
; WMAGetCategoryW                                 ()
; WMAGetArtistW                                   ()
; WMAGetAuthorURLW                                ()
; WMAGetBeatsPerMinuteW                           ()
; WMAGetAlbumW                                    ()
; ID3V2GetPositionSynchronisationValueW           ()
; LYRICSGetTitleW                                 ()
; LYRICSGetLyricsW                                ()
; LYRICSGetVersionW                               ()
; OGGGetCopyrightW                                ()
; OGGGetGenreW                                    ()
; OGGGetDateW                                     ()
; OggGetContactW                                  ()
; MP4GetGenreW                                    ()
; MPEGGetEmphasisW                                ()
; MP4GetTrackW                                    ()
; MPEGGetEncoderW                                 ()
; OGGGetISRCW                                     ()
; MONKEYGetCompressionW                           ()
; AACGetHeaderTypeW                               ()
; FLACGetGenreW                                   ()
; FLACGetISRCW                                    ()
; FLACGetLocationW                                ()
; AACGetBitRateTypeW                              ()
; FLACGetItemKeysW                                ()
; FLACGetLicenseW                                 ()
; FLACGetPerformerW                               ()
; OGGGetDescriptionW                              ()
; FLACGetOrganizationW                            ()
; FLACGetTrackW                                   ()
; FLACGetVendorW                                  ()
; FLACGetTitleW                                   ()
; LYRICSGetAuthorW                                ()
; LYRICSGetArtistW                                ()
; LYRICSGetGenreW                                 ()
; APEGetCommentW                                  ()
; APEGetYearW                                     ()
; APEGetTrackW                                    ()
; APEGetVersionW                                  ()
; LYRICSGetAlbumW                                 ()
; ID3V2GetVersionW                                ()
; APEGetArtistW                                   ()
; LYRICSGetIndicationW                            ()
; LYRICSGetImageLinkW                             ()
; APEGetAlbumW                                    ()
; MPEGGetLayerW                                   ()
; MPEGGetVersionW                                 ()
; LYRICSGetInformationW                           ()
; OGGGetAlbumW                                    ()
; AACGetProfileW                                  ()
; OGGGetArtistW                                   ()
; OGGGetCommentW                                  ()
; APEGetCopyrightW                                ()
; ID3V2GetTOCRootIDW                              ()
; OGGGetItemKeysW                                 ()
; OGGGetLicenseW                                  ()
; APEGetItemKeysW                                 ()
; APEGetTitleW                                    ()
; APEGetGenreW                                    ()
; ID3V1GetTitleW                                  ()
; OGGGetBitRateNominalW                           ()
; WAVGetBitsPerSampleW                            ()
; WAVGetBytesPerSecondW                           ()
; ID3V1GetGenresW                                 ()
; WAVGetBlockAlignW                               ()
; FLACGetAlbumW                                   ()
; ID3V2GetOwnershipDateW                          ()
; ID3V2GetOwnershipSellerW                        ()
; WAVGetChannelsW                                 ()
; WAVGetHeaderSizeW                               ()
; LYRICSGetSizeW                                  ()
; ID3V2GetRecommendedBufferSizeValueW             ()
; ID3V2GetSeekOffsetW                             ()
; ID3V2GetSizeW                                   ()
; ID3V2GetRecommendedBufferSizeOffsetW            ()
; ID3V2GetMpegLocationLookupTableMillisecondsW    ()
; ID3V1GetGenreIDW                                ()
; ID3V2GetGenreW                                  ()
; ID3V1GetArtistW                                 ()
; ID3V1GetCommentW                                ()
; ID3V2GetPossibleCHAPIDW                         ()
; ID3V1GetVersionW                                ()
; ID3V1GetYearW                                   ()
; ID3V1GetTrackW                                  ()
; ID3V1GetGenreW                                  ()
; ID3V1GetAlbumW                                  ()
; FLACGetVersionW                                 ()
; GetAudioGenieVersionW                           ()
; FLACGetCopyrightW                               ()
; FLACGetCommentW                                 ()
; FLACGetContactW                                 ()
; FLACGetDescriptionW                             ()
; ID3V2GetOwnershipPriceW                         ()
; FLACGetArtistW                                  ()
; FLACGetDateW                                    ()
; ID3V2GetPossibleTOCIDW                          ()
; AUDIOGetLastErrorNumberW                        ()
; AUDIOGetSampleRateW                             ()
; AUDIOGetBitrateW                                ()
; AUDIOGetChannelsW                               ()
; AUDIOGetDurationW                               ()
; AUDIOGetDurationMillisW                         ()
; AUDIOGetFileSizeW                               ()
; AUDIOIsValidFormatW                             ()
; AUDIOGetMD5ValueW                               ()
; AUDIOGetVersionW                                ()
; AUDIOGetChannelModeW                            ()
; AUDIOGetLastErrorTextW                          ()
; AUDIOGetLastFileW                               ()
; WMADeletePicturesW                              ()


;###############################################################################
;###    General functions
;###############################################################################

; Ansi to Unicode
; www.autohotkey.com/forum/topic38346.html
; by SKAN
ATOU( ByRef Unicode, Ansi ) { 
  VarSetCapacity( Unicode, (Len:=StrLen(Ansi))*2+1, 0 )
  Return DllCall( "MultiByteToWideChar", Int,0,Int,0,Str,Ansi,UInt,Len, Str,Unicode, UInt,Len )
}

; Unicode to Ansi
; www.autohotkey.com/forum/topic38346.html
; by SKAN
UTOA( pUnicode )  {           
  VarSetCapacity( Ansi,(nSz:=DllCall( "lstrlenW", UInt,pUnicode )+1) )
  DllCall( "WideCharToMultiByte", Int,0, Int,0, UInt,pUnicode, UInt,nSz
                                , Str,Ansi, UInt,nSz+1, Int,0, Int,0 )
  Return Ansi
}

; ASCII to Hex
; www.autohotkey.com/forum/viewtopic.php?p=199220#199220
; by Laszlo
AscToHex(S){
  Return S="" ? "":Chr((*&S>>4)+48) Chr((x:=*&S&15)+48+(x>9)*7) AscToHex(SubStr(S,2))
}
