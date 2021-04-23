/*
Title: MCI Library v1.1

Group: Overview

    This library gives the AutoHotkey developer access to the the Media Control
    Interface (MCI) which provides standard commands for playing/controlling
    multimedia devices.

Group: Notes

Devices Referenced Within The Documentation:

    (start code)
    Driver      Type            Description
    ------      ----            -----------
    MCIAVI      avivideo
    MCICDA      cdaudio         CD audio
                dat             Digital-audio tape player
                digitalvideo    Digital video in a window (not GDI-based)
                MPEGVideo       General-purpose media player
                other           Undefined MCI device
                overlay         Overlay device (analog video in a window)
                scanner         Image scanner
    MCISEQ      sequencer       MIDI sequencer
                vcr             Video-cassette recorder or player
    MCIPIONR    videodisc       Videodisc (Pioneer LaserDisc)
    MCIWAVE     waveaudio       Audio device that plays digitized waveform files
    (end)

MCI Installation:

    To see a list of MCI devices that have been registered for the computer, go
    to the following registry locations...

    (start code)
    Windows NT4/2000/XP/2003/Vista/7/etc.:

      16-bit:
        HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\MCI

      32-bit:
        HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\MCI32


    Windows 95/98/ME:

        HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\MediaResources\MCI
    (end)

    To see a list of registered file extensions and the MCI device that has been
    assigned to each extension, go the following locations...

        (start code)
        For Windows NT4/2000/XP/2003/Vista/7/etc., this information is stored in
        the following registry location:

            HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\MCI Extensions

        For Windows 95/98/ME, this information is stored in the %windir%\win.ini
        file in the "MCI Extensions" section.
        (end)

Performance:

    AutoHotkey automatically loads winmm.dll into memory.  There is no need or
    advantage to preload this library in order to use the MCI library.

Debugging:

    *OutputDebug* statements in the core of some of the functions that only
    execute on condition are permanent and are provided to help the developer
    find and eliminate errors.

Group: Links

    MCI Reference Guide
    - <http://msdn.microsoft.com/en-us/library/ms709461(VS.85).aspx>

Group: Credit

    The MCI library is an offshoot of the Sound_* and Media_* libraries provided
    by *Fincs*.

     -  <http://www.autohotkey.com/forum/viewtopic.php?t=20666>
     -  <http://www.autohotkey.com/forum/viewtopic.php?t=22662>

    Credit and thanks to *Fincs* for creating and enhancing  these libraries
    which are a conversion from the AutoIt "Sound.au3" standard library
    and to *RazerM* for providing the original "Sound.au3" library.

    Notify idea and code from *Sean*
        - <http://www.autohotkey.com/forum/viewtopic.php?p=132331#132331>

    mciGetErrorString call from *PhiLho*
        - <http://www.autohotkey.com/forum/viewtopic.php?p=116011#116011>

Group: Functions
*/


;-----------------------------
;
; Function: MCI_Close
;
; Description:
;
;   Closes the device and any associated resources.
;
; Parameters:
;
;   p_lpszDeviceID - Device name or alias.
;
; Returns:
;
;   The return code from the <MCI_SendString> function which is 0 if the command
;   completed successfully.
;
; Remarks:
;
;   For most MCI devices, closing a device usually stops playback but not
;   always.  If unsure of the device, consider stopping the device before
;   closing it.
;
;------------------------------------------------------------------------------
MCI_Close(p_lpszDeviceID)
    {
    Static MM_MCINOTIFY:=0x03B9

    ;-- Close device
    l_Return:=MCI_SendString("close " . p_lpszDeviceID . " wait")

    ;-- Turn off monitoring of MM_MCINOTIFY message?
    if OnMessage(MM_MCINOTIFY)="MCI_Notify"
        {
        ;-- Don't process unless all MCI devices are closed
        MCI_SendString("sysinfo all quantity open",l_OpenMCIDevices)
        if (l_OpenMCIDevices=0)
            ;-- Disable monitoring
            OnMessage(MM_MCINOTIFY,"")
        }

    Return l_Return
    }


;-----------------------------
;
; Function: MCI_CurrentTrack
;
; Description:
;
;   Identifies the current track.
;
; Parameters:
;
;   p_lpszDeviceID - Device name or alias.
;
; Returns:
;
;   The current track. Note: The MCISEQ sequencer returns 1.
;
;------------------------------------------------------------------------------
MCI_CurrentTrack(p_lpszDeviceID)
    {
    MCI_SendString("status " . p_lpszDeviceID . " current track",l_lpszReturnString)
    Return l_lpszReturnString
    }


;-----------------------------
;
; Function: MCI_DeviceType
;
; Description:
;
;   Identifies the device type name.
;
; Parameters:
;
;   p_lpszDeviceID - Device name or alias.
;
; Returns:
;
;   A device type name, which can be one of the following...
;
;       (start code)
;       cdaudio
;       dat
;       digitalvideo
;       other
;       overlay
;       scanner
;       sequencer
;       vcr
;       videodisc
;       waveaudio
;       (end)
;
;------------------------------------------------------------------------------
MCI_DeviceType(p_lpszDeviceID)
    {
    MCI_SendString("capability " . p_lpszDeviceID . " device type",l_lpszReturnString)
    Return l_lpszReturnString
    }


;-----------------------------
;
; Function: MCI_Open
;
; Description:
;
;   Opens an MCI device and loads the specified file.
;
; Parameters:
;
;   p_MediaFile - A multimedia file.
;
;   p_Alias - Alias. A name such as media1. [Optional] If blank (the default),
;       an alias will automatically be generated.
;
;   p_Flags - Flags that determine how the device is opened. [Optional]
;
;   Flag Notes:
;   Some commonly used flags include...
;
;       (start code)
;       type {device_type}
;       sharable
;       (end)
;
;   If more than one flag is used, separate each flag/value with a space.
;   For example:
;
;       (start code)
;       type MPEGVideo sharable
;       (end)
;
;   Additional notes...
;
;     - The "wait" flag is automatically added to the end of the command string.
;       This flag directs the device to complete the "open" request before
;       returning.
;
;     - Use the "shareable" flag with care.  Per msdn, the "shareable" flag
;       "initializes the device or file as shareable. Subsequent attempts to
;       open the device or file fail unless you specify "shareable" in both the
;       original and subsequent open commands.  MCI returns an invalid device
;       error if the device is already open and not shareable.  The MCISEQ
;       sequencer and MCIWAVE devices do not support shared files."
;
;     - By default, the MCI device that is opened is determined by the file's
;       extension.  The "type" flag can be used to  1) override the default
;       device that is registered for the file extension or to  2) open a media
;       file with a file extension that is not registered as a MCI file
;       extension.  See the <Notes> section for more information.
;
;     - For a complete list of flags and descriptions for the "open" command
;       string, see the "MCI Reference Guide" in the <Links> section.
;
; Returns:
;
;   The multimedia handle (alias) or 0 (FALSE) to indicate failure.  Failure
;   will occur with any of the following conditions:
;
;    -  The media file does not exist.
;
;    -  The media file's extension is not a regisitered MCI extension.  Note:
;       This test is only performed if the "type" flag is not specified.
;
;    -  Non-zero return code from the <MCI_SendString> function.
;
; Remarks:
;
;   -   Use the <MCI_OpenCDAudio> function to open a CDAudio device.
;
;   -   After the device has been successfully opened, the time format is set to
;       milliseconds which it will remain in effect until it is manually set to
;       another value or until the device is closed.
;
;------------------------------------------------------------------------------
MCI_Open(p_MediaFile,p_Alias="",p_Flags="")
    {
    Static s_Seq:=0

    ;[==============]
    ;[  Parameters  ]
    ;[==============]
    ;-- p_MediaFile
    if (p_MediaFile<>"new")
        {
        ;-- Media file exist?
        IfNotExist %p_MediaFile%
            {
            outputdebug,
               (ltrim join`s
                End Func: %A_ThisFunc%: The media file can't be
                found.  Return=0
               )

            Return False
            }

        ;-- "Type" flag not defined?
        if InStr(A_Space . p_Flags . A_Space," type ")=0
            {
            ;-- Registered file extension?
            SplitPath p_MediaFile,,,l_Extension

            ;-- Which OS type?
            if (A_OSType="WIN32_NT")  ;-- Windows NT4/2000/XP/2003/Vista/7/etc.
                RegRead
                    ,l_Dummy
                    ,HKEY_LOCAL_MACHINE
                    ,SOFTWARE\Microsoft\Windows NT\CurrentVersion\MCI Extensions
                    ,%l_Extension%
             else
                {
                ;-- Windows 95/98/ME
                iniRead l_Value,%A_WinDir%\win.ini,MCI Extensions,%l_Extension%
                if (l_Value="ERROR")
                    ErrorLevel:=1
                }

            ;-- Not found?
            if ErrorLevel
                {
                outputdebug,
                   (ltrim join`s
                    End Func: %A_ThisFunc%: The file extension for this media
                    file is not registered as a valid MCI extension.  Return=0
                   )

                Return False
                }
            }

        ;-- Enclose in DQ
        p_MediaFile="%p_MediaFile%"
        }

    ;-- Alias
    if p_Alias is Space
       {
       s_Seq++
       p_Alias:="MCIFile" . s_Seq
       }

    ;[===============]
    ;[  Open device  ]
    ;[===============]
    l_CmdString:="open "
        . p_MediaFile
        . " alias "
        . p_Alias
        . A_Space
        . p_Flags
        . " wait"

    l_Return:=MCI_SendString(l_CmdString)
    if l_Return
        l_Return:=0
     else
        l_Return:=p_Alias

    ;-- Set time format to milliseconds
    if l_Return
        {
        l_CmdString:="set " . p_Alias . " time format milliseconds wait"
        MCI_SendString(l_CmdString)
        }

    ;-- Return to sender
    Return l_Return
    }


;-----------------------------
;
; Function: MCI_OpenCDAudio
;
; Description:
;
;   Opens a CDAudio device.
;
; Parameters:
;
;   p_Drive - CDROM drive letter. [Optional] If blank (the default), the first
;       CDROM drive found is used.
;
;   p_Alias - Alias.  A name such as media1. [Optional] If blank (the default),
;       an alias will automatically be generated.
;
;   p_CheckForMedia - Check for media. [Optional] The default is TRUE.
;
; Returns:
;
;   The multimedia handle (alias) or 0 to indicate failure.  Failure will occur
;   with any of the following conditions:
;    -  The computer does not have a CDROM drive.
;    -  The specified drive is not CDROM drive.
;    -  Non-zero return code from the <MCI_SendString> function.
;
;   If p_CheckForMedia is TRUE (the default), failure will also occur with
;   any of the following conditions:
;    -  No media was found in the device.
;    -  Media does not contain audio tracks.
;
; Remarks:
;
;   After the device has been successfully opened, the time format is set to
;   milliseconds which will remain in effect until it is manually set to another
;   value or until the device is closed.
;
;------------------------------------------------------------------------------
MCI_OpenCDAudio(p_Drive="",p_Alias="",p_CheckForMedia=True)
    {
    Static s_Seq:=0

    ;-- Parameters
    p_Drive=%p_Drive%  ;-- Autotrim
    p_Drive:=SubStr(p_Drive,1,1)
    if p_Drive is not Alpha
        p_Drive:=""

    ;-- Drive not specified
    if p_Drive is Space
        {
        ;-- Collect list of CDROM drives
        DriveGet l_ListOfCDROMDrives,List,CDROM
        if l_ListOfCDROMDrives is Space
            {
            outputdebug,
               (ltrim join`s
                End Func: %A_ThisFunc%: This PC does not have functioning CDROM
                drive.  Return=0
               )

            Return False
            }

        ;-- Assign the first CDROM drive
        p_Drive:=SubStr(l_ListOfCDROMDrives,1,1)
        }

    ;-- Is this a CDROM drive?
    DriveGet l_DriveType,Type,%p_Drive%:
    if (l_DriveType<>"CDROM")
        {
        outputdebug,
           (ltrim join`s
            End Func: %A_ThisFunc%: The specified drive (%p_Drive%:) is not
            a CDROM drive.  Return=0
           )

        Return False
        }

    ;-- Alias
    if p_Alias is Space
       {
       s_Seq++
       p_Alias:="MCICDAudio" . s_Seq
       }

    ;-- Open device
    l_CmdString:="open " . p_Drive . ": alias " . p_Alias . " type cdaudio shareable wait"
    l_Return:=MCI_SendString(l_CmdString)
    if l_Return
        l_Return:=0
     else
        l_Return:=p_Alias

    ;-- Device is open
    if l_Return
        {
        ;-- Set time format to milliseconds
        l_CmdString:="set " . p_Alias . " time format milliseconds wait"
        MCI_SendString(l_CmdString)

        ;-- Check for media?
        if p_CheckForMedia
            {
            if not MCI_MediaIsPresent(p_Alias)
                {
                MCI_Close(p_Alias)
                outputdebug,
                   (ltrim join`s
                    End Func: %A_ThisFunc%: Media is not present in the
                    specified drive (%p_Drive%:).  Return=0
                   )

                Return False
                }

            ;-- 1st track an audio track?
            if not MCI_TrackIsAudio(p_Alias,1)
                {
                MCI_Close(p_Alias)
                outputdebug,
                   (ltrim join`s
                    End Func: %A_ThisFunc%: Media in drive %p_Drive%: does not
                    contain CD Audio tracks.  Return=0
                   )

                Return False
                }
            }
        }

    Return l_Return
    }


;-----------------------------
;
; Function: MCI_Length
;
; Description:
;
;   Gets the total length of the media in the current time format.
;
; Parameters:
;
;   p_lpszDeviceID - Device name or alias.
;
;   p_Track - Track number. [Optional] The default is 0 (no track number).
;
; Returns:
;
;   If a track number is not specified (the default), the length of the entire
;   entire media is returned.  If a track number is specified, only the
;   the length of the specified track is returned.
;
;------------------------------------------------------------------------------
MCI_Length(p_lpszDeviceID,p_Track=0)
    {
    ;-- Build command string
    l_CmdString:="status " . p_lpszDeviceID . " length"
    if p_Track
        l_CmdString.=" track " . p_Track

    ;-- Send it!
    MCI_SendString(l_CmdString,l_lpszReturnString)
    Return l_lpszReturnString
    }


;-----------------------------
;
; Function: MCI_MediaIsPresent
;
; Description:
;
;   Checks to see if media is present in the device.
;
; Parameters:
;
;   p_lpszDeviceID - Device name or alias.
;
; Returns:
;
;   TRUE if the media is inserted in the device, otherwise FALSE.
;   msdn: Sequencer, video-overlay, digital-video, and waveform-audio devices
;   (always) return TRUE.
;
;------------------------------------------------------------------------------
MCI_MediaIsPresent(p_lpszDeviceID)
    {
    l_RC:=MCI_SendString("status " . p_lpszDeviceID . " media present",l_lpszReturnString)
    if l_RC  ;-- Probably invalid command for the device
        Return False
     else
        Return (l_lpszReturnString="true") ? True:False
    }


;-----------------------------
;
; Function: MCI_Notify
;
; Description:
;
;   (Internal function.  Do not call directly)
;
;   This function has 2 responsibilties...
;
;    1) If called by the <MCI_Play> function, wParam contains the name of the
;       developer-defined function.  This value is assigned to the s_Callback
;       static variable for future use.
;
;    2) When called as a result of MM_MCINOTIFY message, this function will call
;       the developer-defined function (name stored in the s_Callback static
;       variable) sending the MM_MCINOTIFY status flag as the first parameter.
;
; Parameters:
;
;   wParam - Function name or a MM_MCINOTIFY flag.
;
;   MM_MCINOTIFY flag values are as follows...
;
;       (start code)
;       MCI_NOTIFY_SUCCESSFUL:=0x1
;           The conditions initiating the callback function have been met.
;
;       MCI_NOTIFY_SUPERSEDED:=0x2
;           The device received another command with the "notify" flag set and
;           the current conditions for initiating the callback function have
;           been superseded.
;
;       MCI_NOTIFY_ABORTED:=0x4
;           The device received a command that prevented the current conditions
;           for initiating the callback function from being met. If a new
;           command interrupts the current command and  it also requests
;           notification, the device sends this message only and not
;           MCI_NOTIFY_SUPERSEDED.
;
;       MCI_NOTIFY_FAILURE:=0x8
;           A device error occurred while the device was executing the command.
;       (end)
;
;   lParam - lDevID.  This is the identifier of the device initiating the
;       callback function.  This information is only useful if operating more
;       than one MCI device at a time.
;
; Returns:
;
;   Per msdn, returns 0 to indicate a successful call.
;
; Remarks:
;
;   This function does not complete until the call to the developer-defined
;   function has completed.  If a MM_MCINOTIFY message is issued while this
;   function is running, the message will be treated as unmonitored.
;
;------------------------------------------------------------------------------
MCI_Notify(wParam,lParam,msg,hWnd)
    {
;;;;;    Critical
        ;-- This will cause MM_MCINOTIFY messages to be buffered rather than
        ;   discared if this function is still running when another MM_MCINOTIFY
        ;   message is sent.

    Static s_Callback

    ;-- Internal call?
    if lParam is Space
        {
        s_Callback:=wParam
        return
        }

    ;-- Call developer function
    if IsFunc(s_Callback)
        %s_Callback%(wParam)

    Return 0
    }


;-----------------------------
;
; Function: MCI_NumberOfTracks
;
; Description:
;
;   Identifies the number of tracks on the media.
;
; Parameters:
;
;   p_lpszDeviceID - Device name or alias.
;
; Returns:
;
;   The number of tracks on the media.
;
; Remarks:
;
;   msdn: The MCISEQ and MCIWAVE devices return 1, as do most VCR devices.  The
;   MCIPIONR device does not support this flag.
;
;------------------------------------------------------------------------------
MCI_NumberOfTracks(p_lpszDeviceID)
    {
    MCI_SendString("status " . p_lpszDeviceID . " number of tracks",l_lpszReturnString)
    Return l_lpszReturnString
    }


;----------
;
; Function: MCI_Pause
;
; Description:
;
;   Pauses playback or recording.
;
; Parameters:
;
;   p_lpszDeviceID - Device name or alias.
;
; Returns:
;
;   The return code from the <MCI_SendString> function which is 0 if the command
;   completed successfully.
;
; Remarks:
;
;   msdn: With the MCICDA, MCISEQ, and MCIPIONR drivers, the pause command works
;   the same as the stop command.
;
;   Observation: For MCISEQ devices, pause works OK for me.
;
;------------------------------------------------------------------------------
MCI_Pause(p_lpszDeviceID)
    {
    Return MCI_SendString("pause " . p_lpszDeviceID . " wait")
    }


;-----------------------------
;
; Function: MCI_Play
;
; Description:
;
;       Starts playing a device.
;
; Parameters:
;
;   p_lpszDeviceID - Device name or alias.
;
;   p_Flags - Flags that determine how the device is played. [Optional] If
;       blank, no flags are used.
;
;       Flag Notes:
;
;       Some commonly used flags include...
;
;           (start code)
;           from {position}
;           to {position}
;           (end)
;
;       If more than one flag is used, separate each flag/value with a space.
;       For example:
;
;           (start code)
;           from 10144 to 95455
;           (end)
;
;       Additional notes...
;
;        -  With the exception of very short sound files (<300 ms), the "wait"
;           flag is not recommended.  The entire application will be
;           non-responsive while the media is being played.
;
;        - Do not add the "notify" flag unless you plan to have your script trap
;           the MM_MCINOTIFY message outside of this function.  The "notify"
;           flag is automatically added if the p_Callback parameter contains a
;           value.
;
;        -  For a complete list of flags and descriptions for the "play" command
;           string, see the "MCI Reference Guide" in the <Links> section.
;
;   p_Callback - Function name that is called when the MM_MCINOTIFY message is
;       sent. [Optional] If defined, the "notify" flag is automatically added.
;
;       Important:  The syntax of this parameter and the associated function is
;       critical.  If not defined correctly, the script may crash.
;
;       The function must have at least one parameter.  For example...
;
;           (start code)
;           MyNotifyFunction(NotifyFlag)
;           (end)
;
;       Additional parameters are allowed but they must be optional (contain a
;       default value).  For example:
;
;           (start code)
;           MyNotifyFunction(NotifyFlag,FirstCall=False,Parm3="ABC")
;           (end)
;
;       When a notify message is sent, the approriate MM_MCINOTIFY flag is sent
;       to the developer-defined function as the first parameter.  See the
;       <MCI_Notify> function for a description and a list of MM_MCINOTIFY flag
;       values.
;
;   p_hWndCallback - Handle to a callback window if the p_Callback parameter
;       contains a value and/or if the "notify" flag is defined. [Optional]  If
;       undefined but needed, the handle to default Autohotkey window is used.
;
; Returns:
;
;   The return code from the <MCI_SendString> function which is 0 if the command
;   completed successfully.
;
;------------------------------------------------------------------------------
MCI_Play(p_lpszDeviceID,p_Flags="",p_Callback="",p_hwndCallback=0)
    {
    Static MM_MCINOTIFY:=0x03B9

    ;-- Build command string
    l_CmdString:="play " . p_lpszDeviceID
    if p_Flags
        l_CmdString.=A_Space . p_Flags

    ;-- Notify
    p_Callback=%p_Callback%  ;-- AutoTrim
    if StrLen(p_Callback)
        {
        l_CmdString.=" notify"

        ;-- Attach p_Callback to MCI_Notify function
        MCI_Notify(p_Callback,"","","")

        ;-- Monitor for MM_MCINOTIFY message
        OnMessage(MM_MCINOTIFY,"MCI_Notify")
            ;-- Note:  If the MM_MCINOTIFY message was monitored elsewhere,
            ;   this statement will override it.
        }

    ;-- Callback handle
    if not p_hwndCallback
        {
        if InStr(A_Space . l_CmdString . A_Space," notify ")
        or StrLen(p_Callback)
            {
            l_DetectHiddenWindows:=A_DetectHiddenWindows
            DetectHiddenWindows On
            Process Exist
            p_hwndCallback:=WinExist("ahk_pid " . ErrorLevel . " ahk_class AutoHotkey")
            DetectHiddenWindows %l_DetectHiddenWindows%
            }
        }

    ;-- Send it!
    Return MCI_SendString(l_CmdString,Dummy,p_hwndCallback)
    }


;-----------------------------
;
; Function: MCI_Position
;
; Description:
;
;   Identifies the current playback or recording position.
;
; Parameters:
;
;   p_lpszDeviceID - Device name or alias.
;
;   p_Track - Track number. [Optional] The default is 0 (no track number).
;
; Returns:
;
;   The current playback or recording position in the current time format.  If
;   the p_Track parameter contains a non-zero value, the start position of the
;   track relative to entire media is returned.
;
;------------------------------------------------------------------------------
MCI_Position(p_lpszDeviceID,p_Track=0)
    {
    l_CmdString:="status " . p_lpszDeviceID . " position"
    if p_Track
        l_CmdString.=" track " . p_Track

    MCI_SendString(l_CmdString,l_lpszReturnString)
    Return l_lpszReturnString
    }


;-----------------------------
;
; Function: MCI_Record
;
; Description:
;
;   Starts recording.
;
; Parameters:
;
;   p_lpszDeviceID - Device name or alias.
;
;   p_Flags - Flags that determine how the device operates for recording.
;       [Optional] If blank, no flags are used.
;
;       Flag Notes:
;
;       Some commonly used flags include...
;
;           (start code)
;           from {position}
;           to {position}
;           insert
;           overwrite
;           (end)
;
;       If more than one flag is used, separate each flag/value with a space.
;       For example:
;
;           (start code)
;           overwrite from 18122 to 26427
;           (end)
;
;
;       Additional notes...
;
;        -  The "wait" flag is not recommended.  The entire application will be
;           non-responsive until recording is stopped with a Stop or Pause
;           command.
;
;        -  For a complete list of flags and descriptions for the "record"
;           command string, see the "MCI Reference Guide" in the <Links>
;           section.
;
; Returns:
;
;   The return code from the <MCI_SendString> function which is 0 if the command
;   completed successfully.
;
; Remarks:
;
;   msdn: Recording stops when a Stop or Pause command is issued.  For the
;   MCIWAVE driver, all data recorded after a file is opened is discarded if the
;   file is closed without saving it.
;
; Credit:
;
;   Original function and examples by heresy.
;
;------------------------------------------------------------------------------
MCI_Record(p_lpszDeviceID,p_Flags="")
    {
    Return MCI_SendString("record " . p_lpszDeviceID . A_Space . p_Flags)
    }


;-----------------------------
;
; Function: MCI_Resume
;
; Description:
;
;   Resumes playback or recording after the device has been paused.  See the
;   <MCI_Pause> function for more information.
;
; Parameters:
;
;   p_lpszDeviceID - Device name or alias.
;
; Returns:
;
;   The return code from the <MCI_SendString> function which is 0 if the command
;   completed successfully.
;
; Remarks:
;
;   msdn: Digital-video, VCR, and waveform-audio devices recognize this command.
;   Although CD audio, MIDI sequencer, and videodisc devices also recognize this
;   command, the MCICDA, MCISEQ, and MCIPIONR device drivers do not support it.
;
; Programming Notes:
;
;   The <MCI_Play> function can sometimes be an alternative to this function.
;   Many devices will begin to play where they were last paused. If the device
;   does not begin playback correctly, try specifying an appropriate "From" and
;   "To" value (if needed) in the p_Flags parameter.
;
;------------------------------------------------------------------------------
MCI_Resume(p_lpszDeviceID)
    {
    Return MCI_SendString("resume " . p_lpszDeviceID . " wait")
    }


;-----------------------------
;
; Function: MCI_Save
;
; Description:
;
;   Saves an MCI file.
;
; Parameters:
;
;   p_lpszDeviceID - Device name or alias.
;
;   p_FileName - File name to store a MCI file.  If the file does not exist, a
;       new file will be created.  If the file exists, it will be overwritten.
;
; Returns:
;
;   The return code from the <MCI_SendString> function which is 0 if the command
;   completed successfully.
;
; Remarks:
;
;   This command can overwrite existing files.  Use with care.
;
; Credit:
;
;   Original function and examples by heresy.
;
;------------------------------------------------------------------------------
MCI_Save(p_lpszDeviceID,p_FileName)
    {
    Return MCI_SendString("save " . p_lpszDeviceID . " """ . p_FileName . """")
    }


;-----------------------------
;
; Function: MCI_Seek
;
; Description:
;
;   Move to a specified position.
;
; Parameters:
;
;   p_lpszDeviceID - Device name or alias.
;
;   p_Position - Position to stop the seek.  Value must be "start", "end",
;           or an integer.
;
; Returns:
;
;   The return code from the <MCI_SendString> function which is 0 if the command
;   completed successfully.
;
;------------------------------------------------------------------------------

/*
Usage and Programming notes:

MCI Bug?: For some reason, seek for cdaudio doesn't work correctly on the
first attempt.  Second and susequent attempts work fine.

*/

MCI_Seek(p_lpszDeviceID,p_Position)
    {
    ;-- Get current status
    l_Status:=MCI_Status(p_lpszDeviceID)

    ;-- Adjust p_Position if necessary
    if p_Position not in start,end
        {
        if p_Position is not Number
            p_Position:=0

        p_Position:=Round(p_Position)  ;-- Integer values only

        if (p_Position>MCI_Length(p_lpszDeviceID))
            p_Position:="end"
         else
            if (p_Position<1)
                p_Position:="start"
                    ;-- This is necessary because some devices don't like a "0"
                    ;   position.
        }

    ;-- Seek
    l_CmdString:="seek " . p_lpszDeviceID . " to " . p_Position . " wait"
    l_Return:=MCI_SendString(l_CmdString)

    ;-- Return to mode before seek
    if l_Status in paused,playing
        {
        MCI_Play(p_lpszDeviceID)

        ;-- Re-pause
        if (l_Status="paused")
            MCI_Pause(p_lpszDeviceID)
        }

;;;;;    l_CurrentPos:=MCI_Position(p_lpszDeviceID)
;;;;;    outputdebug After: l_CurrentPos=%l_CurrentPos%

    Return l_Return
    }


;-----------------------------
;
; Function: MCI_SetBass
;
; Description:
;
;   Sets the audio low frequency level.
;
; Parameters:
;
;   p_lpszDeviceID - Device name or alias.
;
;   p_Factor - Bass factor.
;
; Returns:
;
;   The return code from the <MCI_SendString> function which is 0 if the command
;   completed successfully.
;
; Observations:
;
;   - Factor range appears to be from 0 to ?????.
;   - Most MCI devices do not support this command.
;
;------------------------------------------------------------------------------
MCI_SetBass(p_lpszDeviceID,p_Factor)
    {
    Return MCI_SendString("setaudio " . p_lpszDeviceID . " bass to " . p_Factor)
    }


;----------
;
; Function: MCI_SetTreble
;
; Description:
;
;   Sets the audio high-frequency level.
;
; Parameters:
;
;   p_lpszDeviceID - Device name or alias.
;
;   p_Factor - Treble factor.
;
; Returns:
;
;   The return code from the <MCI_SendString> function which is 0 if the command
;   completed successfully.
;
; Observations:
;
;   - Factor range appears to be from 0 to ?????.
;   - Most MCI devices do not support this command.
;
;------------------------------------------------------------------------------
MCI_SetTreble(p_lpszDeviceID,p_Factor)
    {
    Return MCI_SendString("setaudio " . p_lpszDeviceID . " treble to " . p_Factor)
    }


;-----------------------------
;
; Function: MCI_SetVolume
;
; Description:
;
;   Sets the average audio volume for both audio channels. If the left and right
;   volumes have been set to different values, then the ratio of left-to-right
;   volume is approximately unchanged.
;
;   Parameters:
;
;   p_lpszDeviceID - Device name or alias.
;
;   p_Factor - Volume factor.
;
; Returns:
;
;   The return code from the <MCI_SendString> function which is 0 if the command
;   completed successfully.
;
; Observations:
;
;   - Factor range appears to be from 0 to 1000.
;   - Most MCI devices do not support this command.
;
;------------------------------------------------------------------------------
MCI_SetVolume(p_lpszDeviceID,p_Factor)
    {
    Return MCI_SendString("setaudio " . p_lpszDeviceID . " volume to " . p_Factor)
    }


;-----------------------------
;
; Function: MCI_Status
;
; Description:
;
;   Identifies the current mode of the device.
;
; Parameters:
;
;   p_lpszDeviceID - Device name or alias.
;
; Returns:
;
;   The current mode of the device.
;
;   msdn: All devices can return the "not ready", "paused", "playing", and
;   "stopped" values. Some devices can return the additional "open", "parked",
;   "recording", and "seeking" values.
;
;------------------------------------------------------------------------------
MCI_Status(p_lpszDeviceID)
    {
    MCI_SendString("status " . p_lpszDeviceID . " mode",l_lpszReturnString)
    Return l_lpszReturnString
    }


;-----------------------------
;
; Function: MCI_Stop
;
; Description:
;
;   Stops playback or recording.
;
; Parameters:
;
;   p_lpszDeviceID - Device name or alias.
;
; Returns:
;
;   The return code from the <MCI_SendString> function which is 0 if the command
;   completed successfully.
;
; Remarks:
;
; - After close, a "seek to start" is not done because  1) it slows down the
;   stop request and  2) it may be unwanted.  If you need to set the media
;   position back to the beginning after a stop, call the <MCI_Seek> function
;   and set the p_Position parameter to 0.
;
; - For some CD audio devices, the stop command stops playback and resets the
;   current track position to zero.
;
;------------------------------------------------------------------------------
MCI_Stop(p_lpszDeviceID)
    {
    Return MCI_SendString("stop " . p_lpszDeviceID . " wait")
    }


;-----------------------------
;
; Function: MCI_TrackIsAudio
;
; Description:
;
;   Determines if the specified track is an audio track.
;
; Parameters:
;
;   p_lpszDeviceID - Device name or alias.
;
;   p_Track - Track number. [Optional] The default is 1.
;
; Returns:
;
;   TRUE if the specified track is an audio track, otherwise FALSE.
;
; Remarks:
;
;   This command will only work on a device that supports multiple tracks.
;
;------------------------------------------------------------------------------
MCI_TrackIsAudio(p_lpszDeviceID,p_Track=1)
    {
    if p_Track is not Integer
        p_Track:=1

    l_RC:=MCI_SendString("status " . p_lpszDeviceID . " type track " . p_Track,l_lpszReturnString)
    if l_RC  ;-- Probably invalid command for the device
        Return False
     else
        Return (l_lpszReturnString="audio") ? True:False
    }


;-----------------------------
;
; Function: MCI_ToHHMMSS
;
; Description:
;
;   Converts the specified number of milliseconds to hh:mm:ss format.
;
; Parameters:
;
;   p_ms - Number of milliseconds.
;
;   p_MinimumSize - Minimum size.  [Optional] The default is 4.  This is the
;       minimum size in characters (not significant digits) that is returned.
;       Unless you want a ":" character to show as the leading character, don't
;       set this value to 3 or 6.
;
; Returns:
;
;   The amount of time in hh:mm:ss format with leading zero and ":" characters
;   suppressed unless the length is less than p_MinimumSize. Note:  If the
;   number of hours is greater than 99, the size of hour ("hh") will increase as
;   needed.
;
; Usage Notes:
;
;   To use this function to create separate variables for the number of hours,
;   minutes, and seconds, set the p_MinimumSize parameter to 8 and use simple
;   *SubStr* commands to create these variables.  For example:
;
;       (start code)
;       x:=MCI_ToHHMMSS(NumberOfMilliseconds,8)
;       HH:=SubStr(x,1,2)
;       MM:=SubStr(x,4,2)
;       SS:=SubStr(x,6,2)
;       (end)
;
;   To remove leading zeros from these variables, simply add 0 to the extracted
;   value.  For example:
;
;       (start code)
;       MM:=SubStr(x,4,2)+0
;       (end)
;
; Credit:
;
;   This function is a customized version of an example that was extracted from
;   the AutoHotkey documenation.
;
;------------------------------------------------------------------------------
MCI_ToHHMMSS(p_ms,p_MinimumSize=4)
    {
    ;-- Convert p_ms to whole seconds
    if p_ms is not Number
        l_Seconds:=0
     else
        if (p_ms<0)
            l_Seconds:=0
         else
            l_Seconds:=Floor(p_ms/1000)

    ;-- Initialize and format
    l_Time:=20121212  ;-- Midnight of an arbitrary date
    EnvAdd l_Time,l_Seconds,Seconds
    FormatTime l_mmss,%l_Time%,mm:ss
    l_FormattedTime:="0" . l_Seconds//3600 . ":" . l_mmss
        ;-- Allows support for more than 24 hours.

    ;-- Trim insignificant leading characters
    Loop
        if StrLen(l_FormattedTime)<=p_MinimumSize
            Break
         else
            if SubStr(l_FormattedTime,1,1)="0"
                StringTrimLeft l_FormattedTime,l_FormattedTime,1
             else
                if SubStr(l_FormattedTime,1,1)=":"
                    StringTrimLeft l_FormattedTime,l_FormattedTime,1
                 else
                    Break

    ;-- Return to sender
    Return l_FormattedTime
    }


;-----------------------------
;
; Function: MCI_ToMilliseconds
;
; Description:
;
;   Converts the specified hour, minute and second into a valid milliseconds
;   timestamp.
;
; Parameters:
;
;   Hour, Min, Sec - Position to convert to milliseconds
;
; Returns:
;
;   The specified position converted to milliseconds.
;
;------------------------------------------------------------------------------
MCI_ToMilliseconds(Hour,Min,Sec)
    {
    milli:=Sec*1000
    milli+=(Min*60)*1000
    milli+=(Hour*3600)*1000
    Return milli
    }


;-----------------------------
;
; Function: MCI_SendString
;
; Description:
;
;   This is the primary function that controls MCI operations.  With the
;   exception of formatting functions, all of the functions in this library call
;   this function.
;
; Parameters:
;
;   p_lpszCommand - MCI command string.
;
;   r_lpszReturnString - Variable name that receives return information.
;       [Optional]
;
;   p_hwndCallback - Handle to a callback window if the "notify" flag was
;       specified in the command string.  [Optional] The default is 0 (No
;       callback window).
;
; Returns:
;
;   Two values are returned.
;
;    1) The function returns 0 if successful or an error number otherwise.
;
;    2) If the MCI command string was a request for information, the variable
;       named in the r_lpszReturnString parameter will contain the requested
;       information.
;
; Debugging:
;
;   If a non-zero value is returned from the call to the mciSendString API
;   function, a call to the mciGetErrorString API function is made to convert
;   the error number into a developer-friendly error message.  All of this
;   information is sent to the debugger in an easy-to-read format.
;
;------------------------------------------------------------------------------
MCI_SendString(p_lpszCommand,ByRef r_lpszReturnString="",p_hwndCallback=0)
    {
    ;-- Workaround for AutoHotkey Basic
    PtrType:=A_PtrSize ? "Ptr":"UInt"

    ;-- Send command
    VarSetCapacity(r_lpszReturnString,512,0)
    l_Return:=DllCall("winmm.dll\mciSendString" . (A_IsUnicode ? "W":"A")
                     ,"Str",p_lpszCommand                   ;-- lpszCommand
                     ,"Str",r_lpszReturnString              ;-- lpszReturnString
                     ,"UInt",512                            ;-- cchReturn
                     ,PtrType,p_hwndCallback                ;-- hwndCallback
                     ,"Cdecl Int")                          ;-- Return type

    if ErrorLevel
        MsgBox
            ,262160  ;-- 262160=0 (OK button) + 16 (Error icon) + 262144 (AOT)
            ,%A_ThisFunc% Function Error,
               (ltrim join`s
                Unexpected ErrorLevel from DllCall to the
                "winmm.dll\mciSendString"
                function.  ErrorLevel=%ErrorLevel%  %A_Space%
                `nSee the AutoHotkey documentation (Keyword: DLLCall) for more
                information.  %A_Space%
               )

    ;-- Return code?
    if l_Return
        {
        VarSetCapacity(l_MCIErrorString,2048)
        DllCall("winmm.dll\mciGetErrorString" . (A_IsUnicode ? "W":"A")
               ,"UInt",l_Return                             ;-- MCI error number
               ,"Str",l_MCIErrorString                      ;-- MCI error text
               ,"UInt",2048)

        ;-- This is provided to help debug MCI calls
        outputdebug,
           (ltrim join`s
            End Func: %A_ThisFunc%: Unexpected return code from command string:
            "%p_lpszCommand%"
            `n--------- Return code=%l_Return% - %l_MCIErrorString%
           )
        }

    Return l_Return
    }
