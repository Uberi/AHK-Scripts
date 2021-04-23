;****************
;*              *
;*    Winamp    *
;*              *
;****************
Winamp(p_Command,p_Option=0)
    {
;-------------------------------------------------------------------------------
;
; Parameters        Description
; ==========        -----------
; p_Command         Winamp command/message.  This is a Winamp window command or
;                   a message to the Winamp program.  See the "Commands" section
;                   for more  information.  [Required]
;
; p_Option          Message option.  This parameter is only used if p_Command is
;                   idenfied as a WM_USER or WM_COPYDATA message.  The default
;                   value is 0.  [Optional]
;
;
;
; Commands
; ========
; There are 2 types commands:
;
;   1)  Window commands.  These commands allow you to determine the status of
;       the Winamp window(s) and to perform actions on these windows.  The
;       following commands are currently supported:
;
;           Command     Description/Return Code
;           -------     -----------------------
;           Active      Returns true if Winamp is active, false if it is not.
;
;           Activate    Activates the Winamp window.  Returns false if Winamp
;                       does not exist.
;
;           Exist       Returns true if the Winamp windows exist, false if they
;                       do not.
;
;           Minimize    If active, will minimize Winamp.  Returns false if
;                       Winamp does not exist.
;
;           Title       Returns the Winamp window title.  Depending on the
;                       configuration of Winamp, the title includes the artist
;                       and the song title of the current song.  This
;                       information can be extracted from the window title for
;                       other uses.
;
;
;   2)  Winamp message.  Winamp has been programmed to receive and respond to
;       a large number of messages sent to the primary Winamp window.  These
;       messages allow you to manipulate the Winamp and allow you to get the
;       current status of Winamp conditions.
;
;       Instead of using the raw Windows message components, this function uses
;       message "names" which are then converted into the standard message
;       components.  Once a message has been coded in this function, you only
;       have to remember (or look for) the appropriate message "name" in order
;       to use it.
;
;       Unfortunately, there are too many messages to document in this section.
;       Here's how to find/use the message names in the AHK code:
;
;       The message "names" can be extracted from the variables that begin with
;       "WA_WM_COMMAND_", "WA_WM_USER_" and "WA_WM_COPYDATA_".  For example, the
;       "WA_WM_COMMAND_NextTrack" variable is assigned the message that
;       instructs Winamp to skip to the next track in the playlist.  To send
;       this message to Winamp, simply call this function using "NextTrack" as
;       the command parameter, i.e. Winamp("NextTrack")
;
;
;   Notes
;   =====
;
;       Parameters
;       ----------
;       All spaces are removed from the p_Command parameter before the parameter
;       is processed.  This modification allows the function to use more
;       user-friendly (readable?) commands.  For example, the following all
;       execute the the same command:
;
;           Winamp("SetPlaylistPosition",273)
;           Winamp("Set PlaylistPosition",273)
;           Winamp("Set Playlist Position",273)
;
;
;       Winamp Versions
;       ---------------
;       Not all of the messages will work on all versions of Winamp.  Most
;       require version 2.0 or greater, many require version 2.05 or greater,
;       and a few require version 5.00 or greater.  Unfortunately, you have to
;       either do a "try it and see" or you have to download the SDK to
;       determine if the message will work with your version.  If you have a
;       fairly recent version of Winamp, it is likely that everything will work.
;       See the "References and Credit" section for more information.
;
;
;       Return Codes
;       ------------
;       The return codes for the Window commands are documented in the
;       "Commands" section above.
;
;       The return codes for the Winamp messages, if applicable, are documented
;       within the code.  If Winamp is not running or if the message "name" is
;       not is not found, return code 999 is returned.
;
;
;
;   References and Credit
;   =====================
;   Only a small fraction of the total number of Winamp messages have been
;   included in this function.  See the following posts for more complete list
;   of messages:
;
;       http://forums.winamp.com/showthread.php?threadid=180297
;       http://autohotkey.com/forum/viewtopic.php?t=126
;
;   Much of the Winamp message documentation included in this function was 
;   extracted from these posts and from the Winamp SDK.
;
;   Although these posts are stll contain accurate information (for the most
;   part), the latest versions of Winamp SDK include new messages and updated
;   documentation.  At this writing, the following include links to the latest
;   versions of the Winamp SDK:
;
;        http://www.winamp.com/nsdn/winamp/sdk/
;        http://forums.winamp.com/showthread.php?s=&threadid=168643
;
;   Most of the code to process WM_COPYDATA messages was extracted from the AHK
;   help file and from posts on the AHK forum.
;
;   Thank you to everyone who contributed.
;
;
;
;   Examples Of Use
;   ===============
;   Here are a few examples of how this function can be used in a script:
;
;   ;----- Start of examples -----
;   ^#!Up::Winamp("Play")  ;-- Nothing will happen if Winamp is not running.
;
;   ^#!Down::
;   if Winamp("Exist")  ;-- winamp running?
;       if Winamp("Is Playing")=1  ;-- Playing? (Check to avoid Pause toggle)
;           Winamp("Pause")
;   return
;   
;   ^#!Left::Winamp("Previous Track")  ;-- Go back 1 track
;   
;   ^#!Right::Winamp("Next Track")  ;-- Skip to the next track
;   ;----- End of examples -----
;
;-------------------------------------------------------------------------------

    ;[===================]
    ;[  AHK Environment  ]
    ;[===================]
    l_SavedDetectHiddenWindows:=A_DetectHiddenWindows
    DetectHiddenWindows On


    ;[=====================]
    ;[  Format parameters  ]
    ;[=====================]
    ;-- "Command"
    p_Command=%p_Command%  ;-- AutoTrim
    StringReplace p_Command,p_Command,%A_Space%,,All

    ;-- "Option"
    p_Option=%p_Option%    ;-- AutoTrim


    ;[==============]
    ;[  Initialize  ]
    ;[==============]
    GroupAdd l_WinampGroup,ahk_class BaseWindow_RootWnd
    GroupAdd l_WinampGroup,ahk_class Winamp EQ
    GroupAdd l_WinampGroup,ahk_class Winamp Gen
    GroupAdd l_WinampGroup,ahk_class Winamp PE
    GroupAdd l_WinampGroup,ahk_class Winamp Video
    GroupAdd l_WinampGroup,ahk_class Winamp v1.x
    l_WinampWindowTitle=ahk_class Winamp v1.x
    l_ReturnCode:=""


    ;[===================]
    ;[  Process command  ]
    ;[===================]
    gosub ProcessCommand


    ;[=====================]
    ;[  Reset environment  ]
    ;[=====================]
    DetectHiddenWindows %l_SavedDetectHiddenWindows%


    ;[====================]
    ;[  Return to sender  ]
    ;[====================]
    return %l_ReturnCode%




    ;*********************************
    ;*                               *
    ;*                               *
    ;*        Process Command        *
    ;*                               *
    ;*                               *
    ;*********************************
    ProcessCommand:
    ;-- Rule of thumb: Look for the "group" but act on the "window".

    ;*************************
    ;*                       *
    ;*    Window commands    *
    ;*                       *
    ;*************************
    ;[==========]
    ;[  Active  ]
    ;[==========]
    if p_Command in active,ifactive,ifwinactive
        {
        IfWinActive ahk_group l_WinampGroup
            l_ReturnCode:=true
         else
            l_ReturnCode:=false
        return
        }

    ;[============]
    ;[  Activate  ]
    ;[============]
    if p_Command in activate,winactivate
        {
        IfWinExist ahk_group l_WinampGroup
            {
            l_ReturnCode:=true
            IfWinNotActive ahk_group l_WinampGroup
                WinActivate %l_WinampWindowTitle%
            }
         else
            l_ReturnCode:=false
        return
        }


    ;[=========]
    ;[  Exist  ]
    ;[=========]
    if p_Command in exist,ifexist,ifwinexist
        {
        IfWinExist ahk_group l_WinampGroup
            l_ReturnCode:=true
         else
            l_ReturnCode:=false
        return
        }


    ;[============]
    ;[  Minimize  ]
    ;[============]
    if p_Command in min,minimize
        {
        IfWinExist ahk_group l_WinampGroup
            {
            l_ReturnCode:=true
            IfWinActive ahk_group l_WinampGroup
                WinMinimize %l_WinampWindowTitle%
            }
         else
            l_ReturnCode:=false
        return
        }

    ;[=========]
    ;[  Title  ]
    ;[=========]
    if p_Command=title
        {
        IfWinExist ahk_group l_WinampGroup
            {
            WinGetTitle l_TrackTitle,%l_WinampWindowTitle%
            l_ReturnCode:=l_TrackTitle
            }
         else
            l_ReturnCode:=false
        return
        }
    ;---------------------------------------------------------------------------
    ;
    ;  Include other Winamp window commands here
    ;
    ;---------------------------------------------------------------------------


    ;*************************
    ;*                       *
    ;*    Winamp Messages    *
    ;*                       *
    ;*************************
    ;-------------------
    ;-- Winamp running? 
    ;-------------------
    IfWinNotExist ahk_group l_WinampGroup
        {
        l_ReturnCode=999
        return
        }

    ;[=======================]
    ;[                       ]
    ;[  WM_COMMAND Messages  ]
    ;[                       ]
    ;[=======================]
    ;------------------------------
    ;-- Define WM_COMMAND messages 
    ;------------------------------
    WA_WM_COMMAND_Exit         =40001   ;-- Exit Winamp
    WA_WM_COMMAND_PreviousTrack=40044   ;-- Go to the previous track
    WA_WM_COMMAND_Play         =40045   ;-- Play/Restart
    WA_WM_COMMAND_Pause        =40046   ;-- Pause (toggle)
    WA_WM_COMMAND_Stop         =40047   ;-- Stop
    WA_WM_COMMAND_NextTrack    =40048   ;-- Skip to the next track
    WA_WM_COMMAND_VolumeUp     =40058   ;-- Increase volume a little (~1.5%)
    WA_WM_COMMAND_VolumeDown   =40059   ;-- Reduce volume a litte (~1.5%)  
    WA_WM_COMMAND_FastRewind   =40144   ;-- Fast-rewind 5 seconds
    WA_WM_COMMAND_FadeoutStop  =40147   ;-- Fadeout and stop
    WA_WM_COMMAND_FastForward  =40148   ;-- Fast-forward 5 seconds

    ;---------------------------------------------------------------------------
    ;
    ;  Include other WM_COMMAND messages here
    ;
    ;---------------------------------------------------------------------------

    ;-----------
    ;-- Aliases 
    ;-----------
    WA_WM_COMMAND_Close   :=WA_WM_COMMAND_Exit
    WA_WM_COMMAND_Quit    :=WA_WM_COMMAND_Exit
    WA_WM_COMMAND_Previous:=WA_WM_COMMAND_PreviousTrack
    WA_WM_COMMAND_Next    :=WA_WM_COMMAND_NextTrack
    WA_WM_COMMAND_Rewind  :=WA_WM_COMMAND_FastRewind
    WA_WM_COMMAND_Fadeout :=WA_WM_COMMAND_FadeoutStop
    WA_WM_COMMAND_Forward :=WA_WM_COMMAND_FastForward

    ;------------------------------
    ;-- Attempt to match p_Command 
    ;-- to known message     
    ;------------------------------
    l_WM_COMMAND_Message:=WA_WM_COMMAND_%p_Command%

    ;-----------------------------
    ;-- Valid WM_COMMAND message? 
    ;-----------------------------
    if strlen(l_WM_COMMAND_Message)
        {
        ;-- Send message to Winamp.  Wait for a response.
        SendMessage 0x0111,l_WM_COMMAND_Message,,,%l_WinampWindowTitle%
        l_ReturnCode:=ErrorLevel
        return
        }

    ;[====================]
    ;[                    ]
    ;[  WM_USER Messages  ]
    ;[                    ]
    ;[====================]
    ;---------------------------
    ;-- Define WM_USER messages 
    ;---------------------------
    WA_WM_USER_GetVersion=0         ;-- Version will be 0x20yx for winamp 2.yx.
                                    ;   Versions previous to Winamp 2.0
                                    ;   typically (but not always) use 0x1zyx
                                    ;   for 1.zx versions.  For Winamp 5.x, it
                                    ;   uses 0x50yx for Winamp 5.yx e.g. 5.01 ->
                                    ;   0x5001.
                                    ;
                                    ;   Note: Returned version may not match the
                                    ;   exact value of current version.  i.e.
                                    ;   Version 5.02 may return the same value
                                    ;   as for 5.01.


    WA_WM_USER_StartPlay=102        ;-- Starts/Restarts playback at the
                                    ;   beginning of the current track in the
                                    ;   playlist.
 
    WA_WM_USER_IsPlaying=104        ;-- Returns 1 if WA is playing, returns 3 if
                                    ;   WA is paused, and returns 0 if WA is NOT
                                    ;   playing.

    WA_WM_USER_GetOutputTime=105    ;-- If p_Option=0, returns the current
                                    ;   playback position in milliseconds.  If
                                    ;   p_Option=1, returns current track length
                                    ;   in seconds.  Returns -1 if WA is not
                                    ;   playing or if an error occurs.
                                    ;
                                    ;   Observations
                                    ;   ------------
                                    ;
                                    ;     p_Option=0
                                    ;     ----------
                                    ;     If Winamp is stopped, returns
                                    ;     4294967295.
                                    ;
                                    ;     If playing streaming data, returns the
                                    ;     amount of time the stream has been
                                    ;     playing, in milliseconds.
                                    ;
                                    ;   
                                    ;     p_Option=1
                                    ;     ----------
                                    ;     If playing streaming data, returns
                                    ;     4294967295.
                                    ;
                                    ;     If playing non-streaming data, will
                                    ;     sometimes return 4294967295 if the
                                    ;     message is sent while WA is in-between
                                    ;     tracks.  If you're planning to send WA
                                    ;     this message/option immediately after
                                    ;     after forcing a track change
                                    ;     (PreviousTrack or NextTrack), insert a
                                    ;     minor delay (sleep 1) in-between the
                                    ;     track change and this message/option
                                    ;     to avoid getting the 4294967295 value.
                                    ;
                                    ;     If playing non-streaming data, will
                                    ;     sometimes return 4294967295 if the
                                    ;     message is sent immediately after a
                                    ;     "Play" message.  Insert a significant
                                    ;     delay (sleep 50 should do it) after
                                    ;     the "Play" message to avoid getting
                                    ;     the 4294967295 value.


    WA_WM_USER_JumpToTime=106       ;-- Sets the position of the current track
                                    ;   to the offset specified in p_Option (in
                                    ;   milliseconds).

    WA_WM_USER_WritePlayList=120    ;-- Writes the current playlist to
                                    ;   <winampdir>\\Winamp.m3u, and returns the
                                    ;   current playlist position (relative to
                                    ;   0).

    WA_WM_USER_SetPlaylistPos=121   ;-- Sets the playlist position to the track
                                    ;   number (relative to 0) specified by the
                                    ;   value of p_Option.

    WA_WM_USER_SetVolume=122        ;-- Sets the volume to the value of p_Option
                                    ;   which can be between 0 (silent) and 255
                                    ;   (maximum).  If p_Option is set to -666
                                    ;   (I know, it's evil), will return the
                                    ;   current volume (0 - 255).

    WA_WM_USER_SetPanning=123       ;-- Sets the panning (balance) to the value
                                    ;   of p_Option, which can be between -127
                                    ;   (all left) and 127 (all right).

    WA_WM_USER_GetListLength=124    ;-- Returns the length of the current
                                    ;   playlist, in tracks.

    WA_WM_USER_GetListPos=125       ;-- Returns the position in tracks (relative
                                    ;   to 0) in the current playlist.    

    WA_WM_USER_GetInfo=126          ;-- Returns information about the currently
                                    ;   playing track.  If p_Option=0, returns
                                    ;   sample rate (i.e. 44100). If p_Option=1,
                                    ;   returns the bitrate (Note: If VBR, will
                                    ;   return the "current" bitrate).  If
                                    ;   p_Option=2, returns the number of
                                    ;   channels. 

    WA_WM_USER_RestartWinamp=135    ;-- Restarts Winamp.
    ;---------------------------------------------------------------------------
    ;
    ;  Include other WM_USER messages here
    ;
    ;---------------------------------------------------------------------------

    ;-----------
    ;-- Aliases 
    ;-----------
    WA_WM_USER_Version            :=WA_WM_USER_GetVersion

    WA_WM_USER_GetPlaybackPosition:=WA_WM_USER_GetOutputTime
    WA_WM_USER_PlaybackPosition   :=WA_WM_USER_GetOutputTime

    WA_WM_USER_SetTrackPosition   :=WA_WM_USER_JumpToTime

    WA_WM_USER_SetPlaylistPosition:=WA_WM_USER_SetPlaylistPos

    WA_WM_USER_SetBalance         :=WA_WM_USER_SetPanning

    WA_WM_USER_GetPlaylistPosition:=WA_WM_USER_GetListPos
    WA_WM_USER_PlaylistPosition   :=WA_WM_USER_GetListPos

    WA_WM_USER_GetTrackInformation:=WA_WM_USER_GetInfo
    WA_WM_USER_TrackInformation   :=WA_WM_USER_GetInfo

    WA_WM_USER_Restart            :=WA_WM_USER_RestartWinamp 

    ;------------------------------
    ;-- Attempt to match p_Command 
    ;-- to known message     
    ;------------------------------
    l_WM_USER_Message:=WA_WM_USER_%p_Command%

    ;--------------------------
    ;-- Valid WM_USER message? 
    ;--------------------------
    if strlen(l_WM_USER_Message)
        {
        ;-- Send message to Winamp.  Wait for a response.
        SendMessage 0x400,p_Option,l_WM_USER_Message,,%l_WinampWindowTitle%
        l_ReturnCode:=ErrorLevel
        return
        }


    ;[========================]
    ;[                        ]
    ;[  WM_COPYDATA Messages  ]
    ;[                        ]
    ;[========================]
    ;-------------------------------
    ;-- Define WM_COPYDATA messages 
    ;------------------------------
    WA_WM_COPYDATA_EnqueueFile=100      ;-- Adds the file/address found in
                                        ;   p_Option to the end of the playlist.

    ;---------------------------------------------------------------------------
    ;
    ;  Include other WM_COPYDATA messages here
    ;
    ;---------------------------------------------------------------------------

    ;-----------
    ;-- Aliases 
    ;-----------
    WA_WM_COPYDATA_Enqueue :=WA_WM_COPYDATA_EnqueueFile
    WA_WM_COPYDATA_AddFile :=WA_WM_COPYDATA_EnqueueFile
    WA_WM_COPYDATA_AddTrack:=WA_WM_COPYDATA_EnqueueFile

    ;------------------------------
    ;-- Attempt to match p_Command 
    ;-- to known message     
    ;------------------------------
    l_WM_COPYDATA_Message:=WA_WM_COPYDATA_%p_Command%

    ;------------------------------
    ;-- Valid WM_COPYDATA message? 
    ;------------------------------
    if strlen(l_WM_COPYDATA_Message)
        {
        VarSetCapacity(l_cds,12) 
        InsertInteger(l_WM_COPYDATA_Message,l_cds) 
        InsertInteger(StrLen(p_Option)+1,l_cds,4) 
        InsertInteger(&p_Option,l_cds,8)

        ;-- Send message to Winamp.  Wait for a response.
        SendMessage,0x4A,0,&l_cds,,%l_WinampWindowTitle% 
        l_ReturnCode:=ErrorLevel
        return
        }


    ;[===========================]
    ;[  No valid messages found  ]
    ;[===========================]
    l_ReturnCode=999

    ;-- Return to sender
    return
    }



;************************
;*                      *
;*    Insert Integer    *
;*                      *
;************************
;-- This function was extracted from the AHK help file - Keyword: OnMessage
InsertInteger(pInteger,ByRef pDest,pOffset=0,pSize=4)
    {
	loop %pSize%  ; Copy each byte in the integer into the structure as raw binary data.
		DllCall("RtlFillMemory",UInt,&pDest+pOffset+A_Index-1,UInt,1,UChar,pInteger>>8*(A_Index-1) & 0xFF)
    }


