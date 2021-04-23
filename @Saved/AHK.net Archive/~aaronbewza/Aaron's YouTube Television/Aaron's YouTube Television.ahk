/*
 * * * Compile_AHK SETTINGS BEGIN * * *

[AHK2EXE]
Exe_File=%In_Dir%\Aaron's YouTube Television.exe
No_UPX=1
Created_Date=1
Execution_Level=3
[VERSION]
Set_Version_Info=1
Company_Name=Aaron Bewza Music
File_Description=Plays and downloads YouTube videos
File_Version=2.2.2.7
Inc_File_Version=0
Internal_Name=Aaron's YouTube Television
Legal_Copyright=2011 Aaron Bewza
Original_Filename=Aaron's YouTube Television
Product_Name=Aaron's YouTube Television
Product_Version=2.2.2.7
[ICONS]
Icon_1=%In_Dir%\tv.ico

* * * Compile_AHK SETTINGS END * * *
*/

/*
Version History:

v1.0.0.0 - built gui and made some channels work
v1.1.0.0 - added channel up and down buttons, channels stored in .INI
v1.2.0.0 - added feature which programs television with YouTube videos of User's choice
v1.3.0.0 - optimized the YouTube player for the window with the best arrangement of embed tags
v1.4.0.0 - added "Remove" button for erasing channels, arranged and commented code for readability
v1.4.2.0 - Used nimda's idea to shorten and optimize button sections
v1.5.0.0 - made 9999 channels available instead of 999 (turns out to be very slow, must be changed back)
v2.0.0.0 - rebuilt tv to version 2, only 999 channels but this makes managing channels easier for now
v2.0.1.0 - repaired some faulty HTML code, removed extra 'object' tag (may cause problems displaying html)
v2.0.1.1 - renamed channel backup folder in Documents to "Aaron's YouTube Television"
v2.0.1.2 - blank screen image is now retrieved from URL instead of %A_Temp% folder, and displays properly
v2.0.1.3 - User can use either the URL from the browser's main address bar or from the 'Share' button
v2.0.2.0 - applied 'Loop' commands properly instead of incorrect 'GoSub' commands
v2.0.3.0 - when current channel is added or removed, it instantly refreshes to show the changes (usually)
v2.0.4.0 - replaced incorrect html code (which uses WMP) with proper flash 'object' and 'embed' code
v2.1.0.0 - "Fast INI Library" functions implemented by rseding91, speeds up creation of Channel List file
v2.1.1.0 - same functions extended into add/remove channels, to keep Channel List file always current
v2.1.2.0 - back to 9999 channels, made 'playlist URL maker' but it crashed flash player, working on it
v2.1.3.0 - added a UrlList.ini convertor, Users can use their existing channel list with its new layout
v2.1.4.0 - when channel list entries are clicked, User is now taken to video's host Youtube webpage
v2.1.5.0 - rseding91's function to delete any remaining empty keys in UrlList.ini is now active
v2.2.0.0 - User can now download videos at any time while on an active channel, thanks to Garry
v2.2.0.1 - implemented rseding91's function to numerically sort all the keys in the INI file
v2.2.0.2 - various optimizations, increased number of channels to 99999, added text fade function by ih57452
v2.2.0.3 - all fade text now fades at the same time. Buttons are now disabled if they have no current use.
v2.2.0.4 - added 'Please do not exit TV until completed!' underneath 'Downloading [video name]' for clarity
v2.2.0.5 - updated Garry's YouTube download code (YouTube changes their codes every once in a while)
v2.2.0.6 - removed COM.ahk function from inside script, as it was causing issues with x64 ahk users
v2.2.0.7 - added "Play All" button but have not yet figured out how to make it work
v2.2.0.8 - fixed glitch in "Jump To Channel" feature which was allowing letters to be accepted
v2.2.0.9 - channel title becomes default text in Download button's InputBox, I also validated all the HTML
v2.2.1.0 - video title is now retrieved from parent webpage, becomes default text in 'Add' button's InputBox
v2.2.1.1 - added buttons to skip down or up to the first available empty channel, add new videos easily
v2.2.1.2 - all input boxes now open up directly over the TV, even if it is not on the primary monitor
v2.2.1.3 - added more instructions to the 'About' message box and extended the height of the volume slider
v2.2.1.4 - added display text to the bottom of the volume slider, shows current volume level
v2.2.1.5 - volume level is now saved to the INI file when User exits, and restored next time TV is opened
v2.2.1.6 - added 'Always on top' checkbox which lets User toggle the window between always on top or not
v2.2.1.7 - "Always on top" setting is now saved to INI, all dependency on COM removed by nimda
v2.2.1.8 - fixed a bug that was causing TV to crash when x64 users closed the TV
v2.2.1.9 - added splash screens so User knows when channels are loading and unloading during opening and exit
v2.2.2.0 - added 'Searching, please wait' text while User is searching for the nearest empty channel
v2.2.2.1 - added loading/closing/button sounds to the TV, reverted back to 9999 channels for compatibility
v2.2.2.2 - changed the text shown while downloading, it is white and displays under the Channel Title
v2.2.2.3 - replaced the TV sounds with wav files (instead of Mp3) for more compatibility
  Oct 2011
v2.2.2.4 - exit button (x) is greyed out while video is downloading, ensures better chance of completion
v2.2.2.5 - fixed a small bug which keeps the 'X' button disabled after a video is downloaded
v2.2.2.6 - updated AHK_L to v1.1.05.01 and Compile AHK to v0.9.1 then I compiled the TV using them
  Feb 2012
v2.2.2.7 - updated Garry's YouTube download code (YouTube changes their codes every once in a while)

Future Plans:

 - Integrate function to detect when video is finished playing, to enable the "Play All" option, thanks to ih57452 for help so far
 - Provide "Always open TV on last channel viewed" option
 - Reference downloaded videos from channel list, which may require a permanent save location, probably in the Documents\Aaron's YouTube Television folder
*/

If not A_IsAdmin { ; Runs script as Administrator for UAC in Windows Vista and 7+
  Run *RunAs "%A_ScriptFullPath%"
  ExitApp
  }

; Aaron's YouTube Television
; Written in Autohotkey
; Aaron Bewza
;
; Modified by nimda to remove all dependency on COM.ahk
; Requires AHK 1.1.03.00 or higher (AHK_L)
; Does not work on AHKv2

#SingleInstance Ignore ; Only one instance of the TV can be run at any time, multiple attempts to open it will be ignored
#NoEnv ; No environment variables
#NoTrayIcon ; I will build a tray icon menu sometime, but until then there is no need for one
#LTrim ; Removes leading spaces from continuation sections such as message boxes
SetTitleMatchMode, 2 ; Window titles must partially match to be used
SetBatchLines -1 ; Should increase the overall speed of the script by removing the default delay between lines

VersionNumber = Version: 2.2.2.7 ; Displays correct version number in 'About' message box
BuildDate = Feb 08 2011 ; Displays correct build date in 'About' message box

TV = Aaron's YouTube Television ; Sends name of TV's window to 'TV' variable

SetWorkingDir, %A_ScriptDir% ; Sets working directory to this directory
UrlListLocation = %A_MyDocuments%\%TV% ; Sends this location to 'UrlListLocation' variable
FileCreateDir, %UrlListLocation% ; Creates this directory
FileCreateDir, %VideoSaveLocation% ; Creates this directory for saved videos from YouTube
IniFile = %UrlListLocation%\UrlList.ini ; Sends UrlList.ini location to 'IniFile' variable
CurrentChannelListing = %UrlListLocation%\CurrentChannelListing.html ; Sends CurrentChannelListing.html to 'CurrentChannelListing' variable

If Not FileExist(A_Temp "\v2top.jpg") ; Creates background images from these functions ---------->>
  Extract_v2top(A_Temp "\v2top.jpg")
If Not FileExist(A_Temp "\v2bottom.jpg")
  Extract_v2bottom(A_Temp "\v2bottom.jpg")
If Not FileExist(A_Temp "\v2left.jpg")
  Extract_v2left(A_Temp "\v2left.jpg")
If Not FileExist(A_Temp "\v2right.jpg")
  Extract_v2right(A_Temp "\v2right.jpg") ; ------------------------------------------------------<<

If Not FileExist(A_Temp "\TVloadingSound.wav") ; Creates sound files  from these functions ------>>
  Extract_TVloadingSound(A_Temp "\TVloadingSound.wav")
If Not FileExist(A_Temp "\TVpowerSound.wav")
  Extract_TVpowerSound(A_Temp "\TVpowerSound.wav")
If Not FileExist(A_Temp "\TVreadySound.wav")
  Extract_TVreadySound(A_Temp "\TVreadySound.wav") ; -------------------------------------------------<<

If Not FileExist(IniFile) ; If UrlList.ini does not exist in User's Documents\Aaron's YouTube Television folder...
  Extract_UrlList(IniFile) ; A new blank one is created there

LoadingSound = %A_Temp%\TVloadingSound.wav ; Sends this sound's location to 'LoadingSound' variable
PowerSound = %A_Temp%\TVpowerSound.wav ; Sends this sound's location to 'PowerSound' variable
ReadySound = %A_Temp%\TVreadySound.wav ; Sends this sound's location to 'ReadySound' variable

w = 745 ; Screen working area width (px)
h = 421 ; Screen working area height (px)

BlankScreenImage = <img src="http://i1207.photobucket.com/albums/bb474/aaronbewza/YouTubeTelevisionv2screen.jpg" width="%w%px" height="%h%px" />
BlankScreenUrl = %BlankScreenImage% ; Keeps the above Url in a shorter form, in 'BlankScreenUrl' variable
SnowScreenUrl = <img src="http://i1207.photobucket.com/albums/bb474/aaronbewza/snowV2.gif" style="width:%w%px; height:%h%px" />

GoSub, InitializeHTML ; Creates the HTML container and loads it up with the default 'screen off' image

 ; ------ Creates to options for fade function, red text and white text, called by using 'Fade1' or 'Fade2' to start the fade function commands ------>>
BackgroundColor := 0x000000 ; Sends 'black' to 'BackgroundColor' variable so channel list message text displays in black
TextColor := 0xFF0000 ; Sends 'Red' to 'Textcolor' variable, so text fades to and from this color
FadeRed := new TextFader(TextColor, BackgroundColor) ; Sets this fade function for the new color

BackgroundColor := 0x000000 ; Sends 'black' to 'BackgroundColor' variable so channel list message text displays in black
TextColor := 0xFFFFFF ; Sends 'White' to 'Textcolor' variable, so text fades to and from this color
FadeWhite := new TextFader(TextColor, BackgroundColor) ; Sets this fade function for the new color
 ; ---------------------------------------------------------------------------------------------------------------------------------------------------<<

Gui, Color, %BackgroundColor% ; Black background
Gui, Add, Picture, x0 y0 w847 h49, %A_Temp%\v2top.jpg ; Top background image
Gui, Add, Picture, x0 y467 w847 h103, %A_Temp%\v2bottom.jpg ; Bottom background image
Gui, Add, Picture, x0 y0 w52 h570, %A_Temp%\v2left.jpg ; Left background image
Gui, Add, Picture, x794 y0 w53 h570, %A_Temp%\v2right.jpg ; Right background image
Gui, Add, Button, x807 y70 w30 h20 -Theme vPowerOn, On ; Power On
Gui, Add, Button, x807 y92 w30 h20 -Theme vPowerOff, Off ; Power Off
Gui, Font, s16 Arial q5 ; Size 14 Arial font, regular color, quality 5

Gui, Add, Button, x621 y497 w36 h20 -Theme vChannelJump gSelectChannel, ! ; User can enter choice of channel
Gui, Add, Button, x660 y497 w36 h20 -Theme vFirstEmptyChannelDown gFirstEmptyChannelDown, << ; Open first available empty channel
Gui, Add, Button, x699 y492 w51 h27 -Theme vChannelDown gChannelDown, < ; Channel Down
Gui, Add, Button, x753 y492 w51 h27 -Theme vChannelUp gChannelUp, > ; Channel Up
Gui, Add, Button, x807 y497 w36 h20 -Theme vFirstEmptyChannelUp gFirstEmptyChannelUp, >> ; Open first available empty channel
Gui, Add, Button, x807 y532 w30 h30 -Theme vAbout gAbout, ? ; 'About' message box
Gui, Font, s8 cRed q5 ; Size 8 Arial font, red, quality 5
Gui, Add, Text, x807 y42 w40 h28 cWhite Backgroundtrans vPowerButtonText, `nPower ; Shows above Power buttons
Gui, Add, Text, x805 y135 w40 h20 c%TextColor% Backgroundtrans vVolumeText ; Default empty text above Volume slider, shows 'Volume' when active
Gui, Add, Button, x10 y495 w60 h22 -Theme vAdd, Add ; Add channels
Gui, Add, Button, x75 y495 w60 h22 -Theme vRemove, Remove ; Erase channels
Gui, Add, Button, x140 y495 w60 h22 -Theme vDownload, Download ; Download video to computer
Gui, Add, Button, x205 y495 w60 h22 -Theme vPlayAll, Play All ; Plays all channels on a playlist, starting on current channel
Gui, Add, Text, x226 y480 w400 h20 c%TextColor% Backgroundtrans center vChannelTitle ; Shows User's chosen channel title under video
Gui, Font, s12 cWhite q5 ; Size 12 Arial font, white, quality 5
Gui, Add, Text, x110 y526 w625 h44 Backgroundtrans center vDownloadText ; Starts blank, displays 'Downloading' text while video is downloading
Gui, Font, s12 cRed q5 ; Size 12 Arial font, red, quality 5
Gui, Add, Button, x10 y532 w125 h30 -Theme vChannelListingFile, Channel List ; Shows current list of channels
Gui, Add, Text, x679 y472 w145 h20 c%TextColor% Backgroundtrans center vChannel ; Default empty text when power is not on
Gui, Font, s8 cRed q5 ; Size 8 Arial font, red, quality 5

  IniRead, Volume, %IniFile%, VideoURL, 100000, %A_Space% ; Reads volume level from channel 100000 in [VideoURL] section ...contains only numbers (no decoding is necessary)
  If Volume = ; If the key does not exist, 0 was the last setting for the Volume slider
    {
      Iniwrite, 0, %IniFile%, VideoURL, 100000 ; Writes key 100000 (volume) and puts 0 in it ...contains only numbers (no decoding is necessary)
      Volume = 0 ; Sets Volume variable to 0
    }
  Gui, Add, Slider, x802 y147 w40 h300 vertical invert center Range0-100 tickinterval2 Page10 vVolume gWave AltSubmit, %Volume% ; Volume slider, starts at position retrieved from INI file

  IniRead, CheckboxSetting, %IniFile%, VideoURL, 100001, %A_Space% ; Reads 'Always on top' status from key 100001 in INI file ...contains only 1 or 0 (no decoding is necessary)
  If CheckboxSetting = ; If the key does not exist, 0 (unchecked) was the last setting for the Checkbox
    {
      Iniwrite, 0, %IniFile%, VideoURL, 100001 ; Writes key 100001 (Checkbox setting) and puts 0 in it (unchecked) ...contains only 1 or 0 (no encoding is necessary)
      CheckboxSetting = 0 ; Sets Checkbox variable to 0 (unchecked)
    }
  Gui, Add, Checkbox, x709 y550 cWhite Checked%CheckboxSetting% vCheckboxSetting gToggleAlwaysOnTop, Always on top ; Adds Checkbox, either checked or unchecked, determined by saved setting
  GoSub, ToggleAlwaysOnTop ; Sets the TV to be 'Always on top' or not, determined by the saved setting for the Checkbox

Gui, Font ; Resets font and size back to default
Gui, Add, Text, x802 y447 w40 h20 c%TextColor% Backgroundtrans center vVolumeDisplay ; Shows volume level underneath volume slider control

GoSub DisableButtons ; Disables all the buttons except 'Power On'
OnMessage(0x200,"MouseHover") ; Calls function for ToolTip hover text
Gui, Show, w847 h570, %TV% ; Shows main window and title
Winset, Trans, 200, %TV% ; Sets partial transparency

; -------- Decodes INI file if it is encoded, leaves it alone if it is normal ----------------------------->>
FileRead, IniContents, %IniFile% ; Reads UrlList.ini into 'IniContents' variable
  WinGetPos, guiX, guiY ; Retrieves screen coordinates for upper-left corner of TV
  SplashScreenX := guiX+170 ; Creates new relative coordinates for the splash screen to be displayed ---->>
  SplashScreenY := guiY+250 ; ---------------------------------------------------------------------------<<
IfNotInString, IniContents, `/ ; If there are no forward slashes, then INI is encoded (and must be decoded)
  {
    Gui, +Disabled ; Disables main window
    Gui, 2: +Owner1 ; Makes splash screen owned by main window
    Gui, 2: Font, s20 c999999 Arial q5 ; Size 24 font, light grey, Arial, quality 5
    Gui, 2: Add, Text, x0 w500 center vWaitText, Preparing your channels.`nPlease wait... ; Message shown on splash screen
    Gui, 2: -Caption -Resize +0x400000 ; Removes toolbar and adds a thick border around remaining window
    Gui, 2: Color, 000000 ; Black background on splash screen
      Gui, 2: +LastFound ; Sets the splash screen to be the last found window
      WinGet, GUI_ID, ID ; Retrieves the ID number of the splash screen and sends it to GUI_ID variable
      Gui, 2: Show, Hide w500 x%SplashScreenX% y%SplashScreenY%, Splash Screen ; Shows the splash screen
        SoundPlay, %LoadingSound% ; Plays loading sound while TV is loading
      DllCall("AnimateWindow",UInt,GUI_ID,UInt,800,UInt,0xa0000) ; Fades in splash screen
        GoSub, DecodeIniFile ; Uses StringReplace to Decode UrlList.ini into its regular format
    FileDelete %IniFile% ; Deletes encoded INI
    FileAppend %IniContents%, %IniFile% ; Adds decoded contents back into INI
    Sleep, 1000 ; Waits one second to let the User read 'Preparing your channels' message
    Winset, Trans, Off, %TV% ; Removes partial transparency
    GuiControl, 2:, WaitText, Ready`!
    SoundPlay, %ReadySound% ; Plays sound when TV is ready
    Gui, -Disabled ; Re-enables the main window
    Sleep 750 ; Waits 3/4 second
  }
Winset, Trans, Off, %TV% ; Removes partial transparency
  Gui, 2: +LastFound ; Sets the splash screen to be the last found window
  WinGet, GUI_ID, ID ; Retrieves the ID number of the splash screen and sends it to GUI_ID variable
  DllCall("AnimateWindow",UInt,GUI_ID,UInt,300,UInt,0x90000) ; Fades out splash screen
Gui, -Disabled ; Re-enables the main window (this second instance is in case UrlList.ini was not decoded and the above 'IfNotInString' was not triggered
; ---------------------------------------------------------------------------------------------------------<<

FileInstall, URLlist.ini, %IniFile%, 0 ; Installs UrlList.ini if it does not exist yet or has been deleted
Return

ButtonOn:
  SoundPlay, %PowerSound% ; Plays sound when 'power on' button is pressed
  BlankScreenUrl = ; Clears blank screen image variable
  GoSub, EnableButtons ; Disables "On" button and enables the rest of the buttons
  OnOffImageLocation = %SnowScreenUrl% ; Replaces blank screen with snow
  GoSub, OnOffSwitch ; Adds the variable above to the html code, allowing snowV2.gif to show when 'Power On' is pressed
    GuiControlGet, VolumeDisplayControl,, Volume ; Gets current position of volume slider
    FadeRed.in("Channel", "Power On", "ChannelTitle", "Welcome to " TV, "VolumeText", "Volume", "VolumeDisplay", Volume `%) ; Calls function to fade in variables' text
  SelectedChannel = 1 ; Starts on channel 1 so "Channel Up" button always starts on channel 2 if it is the first one pressed
Return

ButtonOff:
  SoundPlay, %PowerSound% ; Plays sound when 'power off' button is pressed
  Hotkey, PGDN, Off ; Disables the 'Channel Down' hotkey
  Hotkey, PGUP, Off ; Disables the 'Channel Up' hotkey
  Hotkey, Home, Off  ; Disables the 'Select Channel' hotkey
  BlankScreenUrl = %BlankScreenImage% ; Displays blank screen
  GoSub, DisableButtons ; Disables all buttons except "On"
  OnOffImageLocation = %BlankScreenUrl% ; Replaces snow with blank screen
  GoSub, OnOffSwitch ; Adds the variable above to the html code, allowing blank screen image to show when 'Power Off' is pressed
    FadeRed.out("ChannelTitle", "Channel", "VolumeText", "VolumeDisplay") ; Fades out variables' text
  GuiControl, Text, ChannelTitle ; Clears the 'Channel Title Display' text
  GuiControl, Text, Channel ; Clears the 'Channel *' text
  GuiControl, Text, VolumeText ; Clears the 'Volume' text
  GuiControl, Text, VolumeDisplay ; Clears the 'Volume Level' text
Return

FirstEmptyChannelDown:
  Gui, +Disabled ; Disables main window while searching
  SavedLastChannel = %SelectedChannel% ; Sends current channel to 'SavedLastChannel' variable, if user cancels search then this channel is restored
  GoSub, SearchingChannelsSplashScreen ; Creates a message GUI while TV searches for channels
  Loop
    {
      If BreakCommand = 1 ; 'Cancel' button has been pressed to send '1' to this variable, this breaks the loop and User remains on the channel they were on
        {
          If SavedLastChannel = 1 ; If User started the channel search from default 'Power On' state (before any channel is initially selected)...
            SavedLastChannel = 2 ; ... Channel is set to '2'
          SelectedChannel = %SavedLastChannel% ; Restores the last channel number into the 'SelectedChannel' variable
          Break
        }
      --SelectedChannel ; Minus one from the current channel
      If (SelectedChannel < 2) ; If User goes lower than channel 2...
        {
          url = 9999
          SelectedChannel = 9999 ; ...Channel changes to 9999
        }
      IniRead, url, %IniFile%, VideoURL, %SelectedChannel%, %A_Space% ; Reads information from selected channel's key in [VideoURL] section
      If url =  ; If nothing exists in this key, it is an empty channel and the TV changes to this channel
        Break
    }
  IniRead, url, %IniFile%, VideoURL, %SelectedChannel%, %A_Space% ; Reads information from selected channel from [VideoURL] section
    url = %url% ; Trims leading and trailing spaces
  IniRead, ChannelTitleDisplay, %IniFile%, Channels, %SelectedChannel%, %A_Space% ; Reads information from selected channel from [Channels] section
    ChannelTitleDisplay = %ChannelTitleDisplay% ; Trims leading and trailing spaces
  NewChannelDisplay = Channel %SelectedChannel% ; Adds 'Channel ' to the 'SelectedChannel' variable and sends the results to 'NewChannelDisplay' variable
    DllCall("AnimateWindow",UInt,GUI_ID,UInt,200,UInt,0x90000) ; Fades out splash screen, belongs to the 'SearchingChannelsSplashScreen' subroutine
  FadeRed.to("ChannelTitle", ChannelTitleDisplay, "Channel", NewChannelDisplay) ; Calls function to fade variables' text out and in
  GoSub, CodeVariableChange ; Changes contents of window to new channel's contents
  GuiControl, Enable, Add ; Enables the 'Add' button
  Gui, -Disabled ; Enables main window
  BreakCommand = ; Clears this variable so it does not stay active and mess up the next search for empty channels
Return

FirstEmptyChannelUp:
  Gui, +Disabled ; Disables main window while searching
  SavedLastChannel = %SelectedChannel% ; Sends current channel to 'SavedLastChannel' variable, if user cancels search then channel is restored
  GoSub, SearchingChannelsSplashScreen ; Creates a message GUI while TV searches for channels
  Loop
    {
      If BreakCommand = 1 ; 'Cancel' button has been pressed to send '1' to this variable, this breaks the loop and User remains on the channel they were on
        {
          If SavedLastChannel = 1 ; If User started the channel search from default 'Power On' state (before any channel is initially selected)...
            SavedLastChannel = 2 ; ... Channel is set to '2'
          SelectedChannel = %SavedLastChannel% ; Restores the last channel number into the 'SelectedChannel' variable
          Break
        }
      ++SelectedChannel ; Plus one from the current channel
      If (SelectedChannel > 9999) ; If User goes higher than channel 9999...
        {
          url = 2
          SelectedChannel = 2 ; ...Channel changes to 2
        }
      IniRead, url, %IniFile%, VideoURL, %SelectedChannel%, %A_Space% ; Reads information from selected channel's key in [VideoURL] section
      If url =  ; If nothing exists in this key, it is an empty channel and the TV changes to this channel
        Break
    }
  IniRead, url, %IniFile%, VideoURL, %SelectedChannel%, %A_Space% ; Reads information from selected channel from [VideoURL] section
    url = %url% ; Trims leading and trailing spaces
  IniRead, ChannelTitleDisplay, %IniFile%, Channels, %SelectedChannel%, %A_Space% ; Reads information from selected channel from [Channels] section
    ChannelTitleDisplay = %ChannelTitleDisplay% ; Trims leading and trailing spaces
  NewChannelDisplay = Channel %SelectedChannel% ; Adds 'Channel ' to the 'SelectedChannel' variable and sends the results to 'NewChannelDisplay' variable
    DllCall("AnimateWindow",UInt,GUI_ID,UInt,200,UInt,0x90000) ; Fades out splash screen, belongs to the 'SearchingChannelsSplashScreen' subroutine
  FadeRed.to("ChannelTitle", ChannelTitleDisplay, "Channel", NewChannelDisplay) ; Calls function to fade variables' text out and in
  GoSub, CodeVariableChange ; Changes contents of window to new channel's contents
  GuiControl, Enable, Add ; Enables the 'Add' button
  Gui, -Disabled ; Enables main window
  BreakCommand = ; Clears this variable so it does not stay active
Return

PGDN:: ; Maps 'PageDown' to "Channel Down" button
ChannelDown:
  --SelectedChannel ; Minus one from the current channel
  If (SelectedChannel < 2) ; If User goes lower than channel 2...
    {
      url = 9999
      SelectedChannel = 9999 ; ...Channel changes to 9999
      Guicontrol,, Channel, Channel %SelectedChannel% ; Displays selected channel
    }
  IniRead, url, %IniFile%, VideoURL, %SelectedChannel%, %A_Space% ; Reads information from selected channel from [VideoURL] section
    url = %url% ; Trims leading and trailing spaces
  IniRead, ChannelTitleDisplay, %IniFile%, Channels, %SelectedChannel%, %A_Space% ; Reads information from selected channel from [Channels] section
    ChannelTitleDisplay = %ChannelTitleDisplay% ; Trims leading and trailing spaces
  NewChannelDisplay = Channel %SelectedChannel% ; Adds 'Channel ' to the 'SelectedChannel' variable and sends the results to 'NewChannelDisplay' variable
  FadeRed.to("ChannelTitle", ChannelTitleDisplay, "Channel", NewChannelDisplay) ; Calls function to fade variables' text out and in
  GoSub, CodeVariableChange ; Changes contents of window to new channel's contents
  GuiControl, Enable, Add ; Enables the 'Add' button
Return

PGUP:: ; Maps 'PageUp' to "Channel Up" button
ChannelUp:
  ++SelectedChannel ; Plus one from the current channel
  If (SelectedChannel > 9999) ; If User goes higher than channel 9999...
    {
      url = 2
      SelectedChannel = 2 ; ...Channel changes to 2
      Guicontrol,, Channel, Channel %SelectedChannel% ; Displays selected channel
    }
  IniRead, url, %IniFile%, VideoURL, %SelectedChannel%, %A_Space% ; Reads information from selected channel from [VideoURL] section
    url = %url% ; Trims leading and trailing spaces
  IniRead, ChannelTitleDisplay, %IniFile%, Channels, %SelectedChannel%, %A_Space% ; Reads information from selected channel from [Channels] section
    ChannelTitleDisplay = %ChannelTitleDisplay% ; Trims leading and trailing spaces
  NewChannelDisplay = Channel %SelectedChannel% ; Adds 'Channel ' to the 'SelectedChannel' variable and sends the results to 'NewChannelDisplay' variable
  FadeRed.to("ChannelTitle", ChannelTitleDisplay, "Channel", NewChannelDisplay) ; Calls function to fade variables' text out and in
  GoSub, CodeVariableChange ; Changes contents of window to new channel's contents
  GuiControl, Enable, Add ; Enables the 'Add' button
Return

HOME:: ; Maps 'Home' key to 'Select Channel' feature
SelectChannel:
  Gui, +OwnDialogs +LastFound
  WinGetPos, guiX, guiY ; Retrieves screen coordinates for upper-left corner of TV
    InputBoxX := guiX+180 ; Creates new relative coordinates for the InputBox to be displayed ---->>
    InputBoxY := guiY+180 ; ----------------------------------------------------------------------<<
  InputBox, JumpToChannel, Jump To Channel, Please enter the channel number you want`, from 2 to 9999:,, 500, 200, %InputBoxX%, %InputBoxY% ; Asks User to type in requested channel
  If ErrorLevel = 1
    Return
  JumpTochannel = %JumpTochannel% ; Removes leading and trailing spaces
  If JumpToChannel = ; If User enters nothing
    Return
  If JumpToChannel is not number ; If User enters anything but numbers
    {
      MsgBox, You entered an invalid channel number.`n`nPlease choose a channel between 2 and 9999
      Return
    }
  If JumpToChannel > 9999 ; If User enters number higher than 9999
    {
      MsgBox, You cannot choose a channel higher than 9999.`n`nPlease choose a channel between 2 and 9999
      Return
    }
  If JumpToChannel < 2 ; If User enters number lower than 2
    {
      MsgBox, You cannot choose a channel lower than 2.`n`nPlease choose a channel between 2 and 9999
      Return
    }
  If Jumptochannel between 2 and 9999 ; If everything is within parameters...
    {
      SelectedChannel = %JumpToChannel% ; Creates new SelectedChannel variable to display in window
      IniRead, url, %IniFile%, VideoURL, %JumpToChannel%, %A_Space% ; Reads information from selected channel from [VideoURL] section
        url = %url% ; Trims leading and trailing spaces
      IniRead, ChannelTitleDisplay, %IniFile%, Channels, %JumpToChannel%, %A_Space% ; Reads information from selected channel from [Channels] section
        ChannelTitleDisplay = %ChannelTitleDisplay% ; Trims leading and trailing spaces
      NewChannelDisplay = Channel %SelectedChannel% ; Adds 'Channel ' to the 'SelectedChannel' variable and sends the results to 'NewChannelDisplay' variable
      FadeRed.to("ChannelTitle", ChannelTitleDisplay, "Channel", NewChannelDisplay) ; Calls function to fade variables' text out and in
      GoSub, CodeVariableChange ; Changes contents of window to new channel's contents
      GuiControl, Enable, Add ; Enables the 'Add' button
    }
Return

About: ; About message window, shows version information and instructions
  SoundPlay, %ReadySound% ; Plays this sound when 'About' button is pressed
  Gui, +OwnDialogs
  MsgBox,
    (
      Instructions:`n
      - Click 'On' to activate YouTube Television.
      - Click '<' and '>' buttons change the channels up and down
      - Click '!' button to enter the channel number you wish to view
      %A_Space%%A_Space%%A_Space%(or use 'PageDown' and 'PageUp' buttons)
      - Click '<<' and '>>' buttons to take you to the nearest empty channel
      - Click 'Add' to assign video to current channel.
      - Click 'Remove' to erase video from current channel.
      - Click 'Channel List' to see a list of your programmed channels.
      - Click 'Download' to save current channel's video to your computer.
      - Click 'Always on top' to toggle the TV as the topmost window.`n
      Information:`n
      %TV%
      Written by Aaron Bewza
     %VersionNumber%`nBuild Date: %BuildDate%`n
     Many thanks to the AutoHotkey community!
 
    )
Return

ButtonChannelList: ; Opens a list of currently assigned channels in User's default web browser
  SoundPlay, %LoadingSound% ; Plays this sound
  FadeWhite.in("DownloadText", "Creating channel list`nPlease wait...") ; Fades variable's text out and in

  FileDelete, %CurrentChannelListing% ; If a channel list already exists, it is deleted
  ChannelListHTMLbegincontent = ; The beginning of the displayed HTML document, to where the "body" tag opens
    (
      <!DOCTYPE html>`n<html>`n<head>`n<title>YouTube Television Channel List</title>`n<meta http-equiv="Content-Type" content="text/html;charset=utf-8" />
      <style type="text/css">`nbody {background-color:#222222; font-size:100`%; color:#999999; font-family:"Arial"; margin-left:20`%; min-width:600px}
      h1 {font-size:200`%; font-weight:bold}`nh2 {font-size:12px; font-style:italic}`np {font-size:100`%}`na {color: #999}
      a:link {text-decoration: none}`na:visited {text-decoration: none; color: #FFF}
      a:hover {font-size: 120`%; text-decoration: none; color: #F00}`na:active {text-decoration: none; color: #0F0}`n</style>`n</head>`n<body>`n<p>`n
    )
  ChannelListHTMLendcontent = </body>`n</html>`n ; The end of the displayed HTML document, from where the "body" tag ends
  
  VarSetCapacity(CurrentchannelListings_ToWrite,1*1024) ; Sets the capacity of 'CurrentchannelListings_ToWrite' variable to 1gb
  CurrentchannelListings_ToWrite .= ChannelListHTMLbegincontent ; Creates new Current Channel List
  FormatTime, CorrectTime,, LongDate ; Changes layout of system time to regular 12-hour format and sends it to CorrectTime variable
  CurrentchannelListings_ToWrite .= "<h1>Current Channel List:</h1>`n<h2>Created on: " CorrectTime "</h2><br />`n" ; Adds to new Current Channel List

  ChannelToList = 2 ; Starts the list-reading on channel 2
  RIni_Read(1,IniFile,1,0,0,0,1,1,1,1,1) ; Calls rseding91's FastINI function
  RIni_DeleteBlankKeys(1) ; Deletes any blank keys entirely
  RIni_SortKeys(1,"Channels","N") ; Sorts the keys in the 'Channels' section
  Loop 9998 ; Reads (potentially) channels 2 to 9999
    {
      If BreakCommand = 1
        {
            FadeWhite.to("DownloadText", "Operation cancelled.") ; Fades variable's text out and in
              SoundPlay, %ReadySound% ; Plays this sound when User presses 'Cancel' button
            Sleep, 500 ; Waits half a second so User can read the changed text
            FadeWhite.out("DownloadText") ; Fades out message text
            GuiControl, Text, DownloadText ; Removes faded message text
          BreakCommand = ; Clears this variable so it does not stay active
          FileDelete, %CurrentChannelListing% ; ...Deletes partial Current Channel List
          RIni_Shutdown(1) ; Unloads UrlList.ini from memory
          Return
        }
      ChannelUrlInfo := RIni_GetKeyValue(1,"VideoURL",ChannelToList,A_Space) ; Reads associated line in [VideoURL] section to get channel info.
      ChannelListingInfo := RIni_GetKeyValue(1,"Channels",ChannelToList,A_Space) ; Reads associated line in [Channels] section to get channel info.
      StringReplace, ChannelUrlInfo, ChannelUrlInfo, http://www.youtube.com/v/, http://www.youtube.com/watch`?v`=, All ; To make the video open on its host page from channel list links
      StringLeft, ChannelUrlInfo, ChannelUrlInfo, 42 ; Trims URL 42 characters from the left, to shorten the amount of code written into the HTML
      If (ChannelListingInfo <> A_Space) ; If channel is not empty
        CurrentchannelListings_ToWrite .= ChannelToList ": <a href='" ChannelUrlInfo "' target='blank' title='Click to open on YouTube'>" ChannelListingInfo "</a><br />`n" ; Appends file with a line of channel information
      ChannelToList++ ; Adds '1' to the 'ChannelToList' variable
    }
  CurrentchannelListings_ToWrite .= "<p>&nbsp;</p>`n<p>&nbsp;</p>`n<p>&nbsp;</p>`n<p>&nbsp;</p>`n<p>&nbsp;</p>`n" ChannelListHTMLendcontent "`n" ; Adds the end of the HTML to the variable
  FileAppend, %CurrentchannelListings_ToWrite%, %CurrentChannelListing% ; Writes it all to the HTML file
    FadeWhite.to("DownloadText", "Ready!")
    SoundPlay, %ReadySound% ; Plays this sound when channel list is completed
    Sleep, 750
    FadeWhite.out("DownloadText", "Ready!") ; Fades out message text
    GuiControl, Text, DownloadText ; Removes faded message text
  Run, %CurrentChannelListing% ; Opens the newly created HTML file
  BreakCommand = ; Clears this variable so it does not stay active
  RIni_Shutdown(1) ; Unloads UrlList.ini from memory
Return

ButtonAdd: ; Allows User to add YouTube videos to channels of choice, from 2 to 9999
  Gui, +OwnDialogs
  If (SelectedChannel = 1) ; If User has not selected any channel after pressing TV power button
    {
      MsgBox, Please select a channel you wish to program. ; User is prompted to browse to a valid channel
      Return
    }
  IniRead, CurrentChannelContents, %IniFile%, VideoURL, %SelectedChannel% ; Reads requested line of .ini and checks if it is empty
    CurrentChannelContents = %CurrentChannelContents% ; Trims leading and trailing spaces
    If (CurrentChannelContents = "ERROR") ; If selected channel is empty
      {
        GoSub, WriteToChannel ; Writes the channel information to selected channel
        IniRead, url, %IniFile%, VideoURL, %SelectedChannel%, %A_Space%
          url = %url% ; Trims leading and trailing spaces
        IniRead, ChannelTitleDisplay, %IniFile%, Channels, %SelectedChannel%, %A_Space%
          ChannelTitleDisplay = %ChannelTitleDisplay% ; Trims leading and trailing spaces
        GuiControl,, ChannelTitle, %ChannelTitleDisplay%
        GoSub, CodeVariableChange ; Changes contents of window to new channel's contents
      }
    If (CurrentChannelContents <> "ERROR") ; If selected channel has anything in it
      {
        IniRead, ExistingChannelInfo, %IniFile%, Channels, %SelectedChannel% ; Reads requested line, prompts User if line contains information
          ExistingChannelInfo = %ExistingChannelInfo% ; Trims leading and trailing spaces
        Gui, +OwnDialogs
        MsgBox,4,, Channel %SelectedChannel% is already in use with:`n`n"%ExistingChannelInfo%"`n`nDo you wish to overwrite it?
          IfMsgBox Yes
            {
              GoSub, WriteToChannel ; Overwrites channel with new information
              IniRead, url, %IniFile%, VideoURL, %SelectedChannel%, %A_Space% ; Reads information from selected channel from [VideoURL] section
                url = %url% ; Trims leading and trailing spaces
              IniRead, ChannelTitleDisplay, %IniFile%, Channels, %SelectedChannel%, %A_Space% ; Reads information from selected channel from [Channels] section
                ChannelTitleDisplay = %ChannelTitleDisplay% ; Trims leading and trailing spaces
              GuiControl,, ChannelTitle, %ChannelTitleDisplay% ; Sends information from [Channels] section to channel title display under video
              GoSub, CodeVariableChange ; Changes contents of window to new channel's contents
              Return
            }
          IfMsgbox No ; Cancels operation
            {
              MsgBox, Operation cancelled. Video was not assigned.
              Return
            }
      }
Return

WriteToChannel:
  Gui, +OwnDialogs +LastFound
  WinGetPos, guiX, guiY ; Retrieves screen coordinates for upper-left corner of TV
    InputBoxX := guiX+180 ; Creates new relative coordinates for the InputBox to be displayed ---->>
    InputBoxY := guiY+180 ; ----------------------------------------------------------------------<<
  Loop
  {
    Loop
      {
        InputBox, ShareURL, Add Video from YouTube, Copy/paste the URL (from the 'Share' button or the address bar),, 500, 200, %InputBoxX%, %InputBoxY% ; Prompts User for URL
        If ErrorLevel = 1 ; If nothing is entered into the InputBox, nothing happens
          Return
        IfNotInString, ShareURL, http://
          MsgBox, You have entered an invalid URL. Please try again.
        Else Break
      }
; ------ Extracts the video's ID number and properly places it into an embed-compatible format ------------------------------------------------------------->>
    IfInString, ShareURL, http://www.youtube.com/watch? ; From URL in browser's main address bar
      {
        RegExMatch(ShareURL, "v=(.*)", VideoID) ; Everything after 'v=' is sent to 'VideoID' variable
        StringReplace, VideoID, VideoID, v=,, All ; Removes 'v=' from 'VideoID' variable
        StringLeft, VideoID, VideoID, 11 ; Uses only the first 11 characters, which is the pure video ID number
        CorrectedURL = http://www.youtube.com/v/%VideoID% ; Creates a standard URL with the video ID and is now embed-compatible
      }
    IfInString, ShareURL, http://youtu.be ; URL from 'Share' button (video ID number does not need to be searched as it is the only data in this URL)
      StringReplace, CorrectedURL, ShareURL, http://youtu.be, http://www.youtube.com/v, All ; URL is now embed-compatible
    IfNotInString, CorrectedURL, http://www.youtube.com/v ; If nothing good resulted from the above commands then there has been some type of problem
        MsgBox, The chosen URL appears to be incorrect. Please try again.`nTry the URL from either the`naddress bar or the 'Share' button. ; ...Message shown
; -----------------------------------------------------------------------------------------------------------------------------------------------------------<<
    Else Break
  }
; ---------------- Downloads HTML file from chosen video URL and processes it for the title -------------------->>
  HTMLforTitle = %A_Temp%\GetTitleTemp.html ; Designates a location and name for temporary html download, to extract video's title from it
  FileDelete, %HTMLforTitle% ; Deletes any existing temporary file if it exists
  URLDownloadToFile, %ShareURL%, %HTMLforTitle% ; Downloads the video's HTML file from its website
    FileRead, CheckforTitle, %HTMLforTitle% ; Reads the contents of HTML file into 'CheckforTitle' variable
    FileDelete, %HTMLforTitle% ; Deletes HTML file so new one is made next time
    RegExMatch(CheckforTitle, "im)<title>(.*)</title>", FoundTitle) ; Sends anything between 'title' tags to 'FoundTitle' variable
    StringReplace, FoundTitle, FoundTitle, - Youtube,, All ; Removes '- Youtube' from 'FoundTitle' variable
    StringReplace, FoundTitle, FoundTitle, <title>,, All ; Removes leading 'title' tag
    StringReplace, FoundTitle, FoundTitle, </title>,, All ; Removes trailing 'title' tag
    StringReplace, FoundTitle, FoundTitle, `r,, All ; Removes any carriage returns
    StringReplace, FoundTitle, FoundTitle, `n,, All ; Removes any line breaks
  FoundTitle = %FoundTitle% ; Removes any leading or trailing spaces
; --------------------------------------------------------------------------------------------------------------<<

  CorrectedURL = %CorrectedURL%&version=3&border=0&controls=1&modestbranding=1&iv_load_policy=3&showsearch=0&autoplay=0&autohide=1&showinfo=1&rel=0 ; Adds URL tags to optimize video

  InputBox, ChannelListEntry, Enter Channel Display Name, Enter the display name of this channel:,, 500, 200, %InputBoxX%, %InputBoxY%,,,%FoundTitle% ; Prompts for channel display name, uses contents of 'FoundTitle' as default text
    If ErrorLevel = 1
      {
        MsgBox, Operation cancelled.
        Return
      }
  StringReplace, ChannelListEntry, ChannelListEntry, `&, and, All ; Replaces any ampersands with 'and' in the channel display name
  ChannelListEntry = %ChannelListEntry% ; Removes leading and trailing spaces
  SoundPlay, %ReadySound% ; Plays sound when channel is assigned
  MsgBox, Your video has been successfully assigned to:`nChannel %SelectedChannel%.`n`nIts display name will be:`n%ChannelListEntry%
  GuiControl,, ChannelTitle, %ChannelTitleDisplay% ; Sends information from [Channels] section to channel title display under video
  
  IniWrite, %CorrectedURL%, %IniFile%, VideoURL, %SelectedChannel% ; Writes information into [VideoURL] section
  IniWrite, %ChannelListEntry%, %IniFile%, Channels, %SelectedChannel% ; Writes information into [Channels] section
  GoSub, CodeVariableChange ; Changes contents of window to new channel's contents
Return

ButtonRemove: ; Allows User to erase channels
  Gui, +OwnDialogs
  If (SelectedChannel = 1) ; If User has not selected any channel after pressing TV power button
    {
      MsgBox, Please select a channel you wish to remove. ; User is prompted to browse to a valid channel
      Return
    }
  IniRead, ChannelText, %IniFile%, Channels, %SelectedChannel%, %A_Space% ; Reads information from selected channel from [Channels] section
    ChannelText = %ChannelText% ; Trims leading and trailing spaces
  If ChannelText = ; If channel is empty
    {
      MsgBox, Channel is already empty.
      Return
    }
  MsgBox,4, Please Confirm, Are you sure you want to erase this channel?`n`n%SelectedChannel%: %ChannelText% ; Confirms with User
    IfMsgBox Yes
      {
        IniDelete, %IniFile%, VideoURL, %SelectedChannel% ; Removes URL entry in .INI file
        IniDelete, %IniFile%, Channels, %SelectedChannel% ; Removes Channel entry in .INI file
        ChannelTitleDisplay = ; Clears channel title display
        GuiControl,, ChannelTitle, %ChannelTitleDisplay% ; Shows empty channel display (nothing)
        url = ; Clears 'url' variable
        GoSub, CodeVariableChange ; Changes contents of window to new channel's contents
        MsgBox, Channel %SelectedChannel% has been successfully erased.
        Return
      }
    IfMsgBox No
      Return
    Else
Return

ButtonDownload: ; Adapted from Garry's 'YouTube MP4 download & convert video to MP3' script
  Gui, +OwnDialogs +LastFound
  WinGetPos, guiX, guiY ; Retrieves screen coordinates for upper-left corner of TV
    InputBoxX := guiX+240 ; Creates new relative coordinates for the InputBox to be displayed ---->>
    InputBoxY := guiY+180 ; ----------------------------------------------------------------------<<
  If (SelectedChannel = 1) ; If User has not selected any channel after pressing TV power button
    {
      MsgBox, Please select a channel you wish `nto download the video from. ; User is prompted to browse to a valid channel
      Return
    }
  IniRead, CurrentChannelContents, %IniFile%, VideoURL, %SelectedChannel%, %A_Space% ; Reads information from selected channel from [Channels] section
  If (CurrentChannelContents = "") ; If selected channel is empty
    {
      MsgBox, There is no video on this channel.
      Return
    }
  IniRead, ShareUrl, %IniFile%, VideoURL, %SelectedChannel%, %A_Space% ; Reads requested line of .ini and checks if it is empty
    ShareUrl = %ShareUrl% ; Trims leading and trailing spaces
    StringLeft, ShareUrl, ShareUrl, 36 ; Chops the extra embed tags trailing the Video ID number, 36 characters into the new URL
  StringReplace, ShareURL, ShareURL, http://www.youtube.com/v/, http://www.youtube.com/watch?v=, All ; Becomes download-compatible with original URL prefix
  DownloadDestination = ; Clears 'DownloadDestination' variable
      title = ; Clears 'title' variable
      LR = ; Clears 'LR' variable
      RawUrl = ; Clears 'RawUrl' variable
      hss = ; Clears 'hss' variable
      G2 = ; Clears 'G2' variable                             ; ------------------------------------------------------------------------------------------------ <<<<< This variable changes <<<<<
      G21 = ; Clears 'G21' variable                           ; ------------------------------------------------------------------------------------------------ <<<<< This variable changes <<<<<
  TempFile = %A_Temp%\TempUrlFile.txt ; Creates location for temporary text file to contain the URL information
  URLDownloadToFile, %ShareUrl%, %TempFile% ; Downloads contents of 'ShareUrl' variable into temporary text file
  FileRead, RawUrl, %TempFile% ; Reads contents of temporary text file into 'RawUrl' variable
  xx4 = <meta name="title" content= ; Sends the beginning of the target file's embed code into 'xx4' variable
  Loop, Parse, RawUrl, `n, `r ; Extracts the target file's embed code from the 'RawUrl' variable -------!!>>
    {
      LR = %A_loopfield%
      htmlcontent = var swf
      searchfor = url_encoded_fmt_stream_map                  ; ------------------------------------------------------------------------------------------------ <<<<< This variable changes <<<<<
      IfInString, LR, %htmlcontent% ; Looks for the above embed code prefix
        {
          Loop, Parse, LR ,`; ,
            {
              If A_LoopField contains %searchfor%
                HSS = %A_LoopField%
            }
        }
    }
  RawUrl = ; Clears 'RawUrl' variable
      StringReplace, hss, hss, http, |http, All
      StringReplace, hss, hss, `%253A,`:, All                ; ------------------------------------------------------------------------------------------------ <<<<< This variable changes <<<<<
      StringReplace, hss, hss, `%252F,`/, All                ; ------------------------------------------------------------------------------------------------ <<<<< This variable changes <<<<<
      StringReplace, hss, hss, `%26,`&, All                  ; ------------------------------------------------------------------------------------------------ <<<<< This variable changes <<<<<
  loop, Parse, hss, `|
     G%A_Index% := A_LoopField
      StringSplit, G2, G2, &                                 ; ------------------------------------------------------------------------------------------------ <<<<< This variable changes <<<<<
      StringReplace, G21, G21, 2525,, All                    ; ------------------------------------------------------------------------------------------------ <<<<< This variable changes <<<<<
      StringReplace, G21, G21, `%253D, `=, All               ; ------------------------------------------------------------------------------------------------ <<<<< This variable changes <<<<<
      StringReplace, G21, G21, `%2526, `&, All               ; ------------------------------------------------------------------------------------------------ <<<<< This variable changes <<<<<
      StringReplace, G21, G21, `%253F, `?, All               ; ------------------------------------------------------------------------------------------------ <<<<< This variable changes <<<<<
  If G21 = ; If no download information is present           ; -------------------------------(one more about 50 lines down)----------------------------------- <<<<< This variable changes <<<<<
    {
      MsgBox, There is no download information for this video.`nSorry... please try another video.
      Return
    }
  FileSelectFolder, VideoSaveLocation, *A_MyDocuments, 3, Please select a location to save the video ; Starts in Documents folder
    If Errorlevel = 1
      {
        MsgBox, Operation cancelled. Video was not saved. ; If User presses cancel or closes the InputBox
        Return
      }
Loop
  {
    IniRead, ChannelTitleDisplay, %IniFile%, Channels, %SelectedChannel%, %A_Space% ; Reads information from selected channel from [Channels] section
    StringReplace, ChannelTitleDisplay, ChannelTitleDisplay, `%, %A_Space%percent, All ; Replaces literal percent signs... "(space)percent"
    StringReplace, ChannelTitleDisplay, ChannelTitleDisplay, `:, %A_Space%`-, All ; Replaces semicolons with dashes... "(space)-"
    ChannelTitleDisplay = %ChannelTitleDisplay% ; Trims leading and trailing spaces
    InputBox, title, Enter Name, Type the name you want for your video:,,,, %InputBoxX%, %InputBoxY%,,, %ChannelTitleDisplay%  ; Sends User's chosen name to "title" variable
    If ErrorLevel = 1 ; If nothing is typed in the Input Box
      {
        MsgBox, Operation cancelled. Video was not saved.
        Return
      }
  ; ------ Removes invalid filename characters ------->>
    InvalidChars = [\\/*?"<>|]
    title := RegExReplace(title, InvalidChars)
    title = %title% ; Removes leading and trailing spaces
  ; --------------------------------------------------<<
    DownloadDestination = %VideoSaveLocation%\%title%.mp4 ; Sets download destination to User's choice
    If FileExist(DownloadDestination)
      {
        MsgBox,4,, A video named "%title%"`nalready exists in this location:`n%VideoSaveLocation%`n`nDo you want to overwrite it? ; If file already exists
          IfMsgBox Yes
            Break
          IfMsgBox No
            MsgBox, Please select another location and/or name.
      }
    Else Break
  }

  GuiControl, Disable, Add ; Disables these three buttons while video is downloading --->>
  GuiControl, Disable, Remove
  GuiControl, Disable, Download ; ------------------------------------------------------<<

    FadeWhite.in("DownloadText", "Downloading " title ".mp4`n`(The TV cannot be closed while video is downloading`)") ; Fades in white text
    DisableCloseButton() ; Disables the 'X' button (GuiClose) because if User exits TV while the video is downloading, an imcomplete video file will exist

  URLDownloadToFile, %g21%, %DownloadDestination%  ; ------------------------------------------------------------------------------------------------ <<<<< This variable changes <<<<<
    If ErrorLevel = 1 ; If something goes wrong
      {
        Gui, +OwnDialogs
        MsgBox, There has been an error...,`nDownload has been cancelled. ; Information shown
                
        GuiControl, Text, DownloadText ; Removes newly faded text
        GuiControl, Enable, Add ; Enables these three buttons --->>
        GuiControl, Enable, Remove
        GuiControl, Enable, Download ; --------------------------<<
        
        FadeWhite.out("DownloadText") ; Fades out white downloading message text
        EnableCloseButton() ; Enables the 'X' button (GuiClose)
        
        Return
      }

  SoundPlay, %ReadySound% ; Plays sound when video is finished downloading
  MsgBox,4,, ; Information shown
    (
      %title%.mp4
      is finished downloading to:`n
      %VideoSaveLocation%.`n`
      Your media player must be able to play .Mp4 files.`n
      Press 'Yes' to play the downloaded video
      Press 'No' to continue without playing video
    )
  IfMsgBox Yes
    {
      If FileExist(DownloadDestination)
        {
          EnableCloseButton() ; Enables the 'X' button (GuiClose) when the video is finished downloading
          FadeWhite.out("DownloadText") ; Fades out white downloading message text
          Run, %DownloadDestination% ; If it exists, plays downloaded video on User's default media player (must be able to play .Mp4)
        }
      If not FileExist(DownloadDestination)
        {
          MsgBox, There has been an error, the file does not exist.
          EnableCloseButton() ; Enables the 'X' button (GuiClose) when the video is finished downloading
          FadeWhite.out("DownloadText") ; Fades out white downloading message text
        }
    }
  IfMsgBox No
    {
      EnableCloseButton() ; Enables the 'X' button (GuiClose) when the video is finished downloading
      FadeWhite.out("DownloadText") ; Fades out white downloading message text
    }
  GuiControl, Enable, Add ; Enables these three buttons after video is downloaded --->>
  GuiControl, Enable, Remove
  GuiControl, Enable, Download ; ----------------------------------------------------<<
  GuiControl, Text, DownloadText ; Removes newly faded text
Return 

ButtonPlayAll:
  Gui, +OwnDialogs
  MsgBox, This feature is not yet available.
Return

GuiClose:
  WinGetPos, guiX, guiY ; Retrieves screen coordinates for upper-left corner of TV
    SplashScreenX := guiX+170 ; Creates new relative coordinates for the Searching Channels splash screen to be displayed ---->>
    SplashScreenY := guiY+250 ; ----------------------------------------------------------------------------------------------<<
  Gui, Destroy ; Closes the TV's window
  IniWrite, %Volume%, %IniFile%, VideoURL, 100000 ; Writes current volume level onto key 100000 in [VideoURL] section for easy reference
  IniWrite, %CheckboxSetting%, %IniFile%, VideoURL, 100001 ; Writes 'CheckboxSetting' status onto key 100001 in [VideoURL] section for easy reference
  
  Gui, Font, s20 c999999 Arial q5 ; Size 24 font, light grey, Arial, quality 5
  Gui, Add, Text, x0 w500 center vSplashTextExit, Saving your channels... ; Message shown on splash screen
  Gui, -Caption -Resize +ToolWindow +0x400000 ; Removes toolbar and adds a border around remaining window, taskbar button is not shown
  Gui, Color, 000000 ; Black background on splash screen
    Gui, +LastFound ; Sets the window to be the last found window, to apply fade function
    WinGet, GUI_ID, ID ; Retrieves the ID number of splash screen and sends it to GUI_ID variable
    Gui, Show, Hide w500 x%SplashScreenX% y%SplashScreenY% ; Shows the splash screen
    DllCall("AnimateWindow",UInt,GUI_ID,UInt,300,UInt,0xa0000) ; Fades in splash screen
  SoundPlay, %LoadingSound% ; Plays this sound when User closes TV

; -------- Encodes INI file, leaves it alone if it already is for whatever reason ------------------------->>
  FileRead, IniContents, %IniFile% ; Reads UrlList.ini into 'IniContents' variable
  IfInString, IniContents, `/ ; Looks for forward-slashes and if any exist, file is then encoded
    GoSub, EncodeIniFile ; Encodes UrlList.ini to make it compatible with Fast INI Library on x64 systems
; ---------------------------------------------------------------------------------------------------------<<

  RIni_Read(1,IniFile) ; Loads the INI into memory
  RIni_DeleteBlankKeys(1) ; Deletes any blank keys entirely
  RIni_SortKeys(1,"VideoURL","N") ; Sorts out INI's contents into numerical order --->>
  RIni_SortKeys(1,"Channels","N") ; -------------------------------------------------<<  
  RIni_Write(1,IniFile) ; Writes the new INI without blank keys in it and in order
  RIni_Shutdown(1) ; Unloads UrlList.ini from memory
  Sleep, 500 ; Waits half a second to let the User read 'Saving your channels' message
  GuiControl,, SplashTextExit, Finished`! ; Changes the text on the splash screen to 'Finished!'
  SoundPlay, %ReadySound% ; Plays this sound when channel list is finished encoding
  Sleep 750 ; Waits 3/4 second before fading out splash screen
  DllCall("AnimateWindow",UInt,GUI_ID,UInt,300,UInt,0x90000) ; Fades out splash screen
ExitApp

;------------------------------ Subroutines ------------------------------------------------------------------------------------------------------------------------------->>

DecodeIniFile: ; Decodes UrlList.ini to a normal state for the TV to use
  StringReplace, IniContents, IniContents, _x1z_, `~, All ; Replaces '_x1z_' with '~'
  StringReplace, IniContents, IniContents, _x2z_, ``, All ; Replaces '_x2z_' with '`'
  StringReplace, IniContents, IniContents, _x3z_, `!, All ; Replaces '_x3z_' with '!'
  StringReplace, IniContents, IniContents, _x4z_, `@, All ; Replaces '_x4z_' with '@'
  StringReplace, IniContents, IniContents, _x5z_, `#, All ; Replaces '_x5z_' with '#'
  StringReplace, IniContents, IniContents, _x6z_, `$, All ; Replaces '_x6z_' with '$'
  StringReplace, IniContents, IniContents, _x7z_, `^, All ; Replaces '_x7z_' with '^'
  StringReplace, IniContents, IniContents, _x8z_, `&, All ; Replaces '_x8z_' with '&'
  StringReplace, IniContents, IniContents, _x9z_, `*, All ; Replaces '_x9z_' with '*'
  StringReplace, IniContents, IniContents, _x10z_, `(, All ; Replaces '_x10z_' with '('
  StringReplace, IniContents, IniContents, _x11z_, `), All ; Replaces '_x11z_' with ')'
  StringReplace, IniContents, IniContents, _x12z_, `-, All ; Replaces '_x12z_' with '-'
  StringReplace, IniContents, IniContents, _x13z_, `+, All ; Replaces '_x13z_' with '+'
  StringReplace, IniContents, IniContents, _x14z_, `{, All ; Replaces '_x14z_' with '{'
  StringReplace, IniContents, IniContents, _x15z_, `}, All ; Replaces '_x15z_' with '}'
  StringReplace, IniContents, IniContents, _x16z_, `|, All ; Replaces '_x16z_' with '|'
  StringReplace, IniContents, IniContents, _x17z_, `\, All ; Replaces '_x17z_' with '\'
  StringReplace, IniContents, IniContents, _x18z_, `:, All ; Replaces '_x18z_' with ':'
  StringReplace, IniContents, IniContents, _x19z_, `;, All ; Replaces '_x19z_' with ';'
  StringReplace, IniContents, IniContents, _x20z_, `", All ; Replaces '_x20z_' with '"'
  StringReplace, IniContents, IniContents, _x21z_, `', All ; Replaces '_x21z_' with '''
  StringReplace, IniContents, IniContents, _x22z_, `<, All ; Replaces '_x22z_' with '<'
  StringReplace, IniContents, IniContents, _x23z_, `,, All ; Replaces '_x23z_' with ','
  StringReplace, IniContents, IniContents, _x24z_, `>, All ; Replaces '_x24z_' with '>'
  StringReplace, IniContents, IniContents, _x25z_, `., All ; Replaces '_x25z_' with '.'
  StringReplace, IniContents, IniContents, _x26z_, `?, All ; Replaces '_x26z_' with '?'
  StringReplace, IniContents, IniContents, _x27z_, `/, All ; Replaces '_x27z_' with '/'
  FileDelete, %IniFile% ; Deletes existing UrlList.ini
  FileAppend, %IniContents%, %IniFile% ; New contents are written to UrlList.ini
Return

EncodeIniFile: ; Encodes UrlList.ini for Fast INI Library to be compatible with x64 systems
  StringReplace, IniContents, IniContents, `~, _x1z_, All ; Replaces '~' with '_x1z_'
  StringReplace, IniContents, IniContents, ``, _x2z_, All ; Replaces '`' with '_x2z_'
  StringReplace, IniContents, IniContents, `!, _x3z_, All ; Replaces '!' with '_x3z_'
  StringReplace, IniContents, IniContents, `@, _x4z_, All ; Replaces '@' with '_x4z_'
  StringReplace, IniContents, IniContents, `#, _x5z_, All ; Replaces '#' with '_x5z_'
  StringReplace, IniContents, IniContents, `$, _x6z_, All ; Replaces '$' with '_x6z_'
  StringReplace, IniContents, IniContents, `^, _x7z_, All ; Replaces '^' with '_x7z_'
  StringReplace, IniContents, IniContents, `&, _x8z_, All ; Replaces '&' with '_x8z_'
  StringReplace, IniContents, IniContents, `*, _x9z_, All ; Replaces '*' with '_x9z_'
  StringReplace, IniContents, IniContents, `(, _x10z_, All ; Replaces '(' with '_x10z_'
  StringReplace, IniContents, IniContents, `), _x11z_, All ; Replaces ')' with '_x11z_'
  StringReplace, IniContents, IniContents, `-, _x12z_, All ; Replaces '-' with '_x12z_'
  StringReplace, IniContents, IniContents, `+, _x13z_, All ; Replaces '+' with '_x13z_'
  StringReplace, IniContents, IniContents, `{, _x14z_, All ; Replaces '{' with '_x14z_'
  StringReplace, IniContents, IniContents, `}, _x15z_, All ; Replaces '}' with '_x15z_'
  StringReplace, IniContents, IniContents, `|, _x16z_, All ; Replaces '|' with '_x16z_'
  StringReplace, IniContents, IniContents, `\, _x17z_, All ; Replaces '\' with '_x17z_'
  StringReplace, IniContents, IniContents, `:, _x18z_, All ; Replaces ':' with '_x18z_'
  StringReplace, IniContents, IniContents, `;, _x19z_, All ; Replaces ';' with '_x19z_'
  StringReplace, IniContents, IniContents, `", _x20z_, All ; Replaces '"' with '_x20z_'
  StringReplace, IniContents, IniContents, `', _x21z_, All ; Replaces ''' with '_x21z_'
  StringReplace, IniContents, IniContents, `<, _x22z_, All ; Replaces '<' with '_x22z_'
  StringReplace, IniContents, IniContents, `,, _x23z_, All ; Replaces ',' with '_x23z_'
  StringReplace, IniContents, IniContents, `>, _x24z_, All ; Replaces '>' with '_x24z_'
  StringReplace, IniContents, IniContents, `., _x25z_, All ; Replaces '.' with '_x25z_'
  StringReplace, IniContents, IniContents, `?, _x26z_, All ; Replaces '?' with '_x26z_'
  StringReplace, IniContents, IniContents, `/, _x27z_, All ; Replaces '/' with '_x27z_'
  FileDelete, %IniFile% ; Deletes existing UrlList.ini
  FileAppend, %IniContents%, %IniFile% ; New contents are written to UrlList.ini
Return

 ; ---------- 'Searching Channels' splash screen and 'Cancel' button ------------------------------------------>>
SearchingChannelsSplashScreen:
  WinGetPos, guiX, guiY ; Retrieves screen coordinates for upper-left corner of TV
    SplashScreenX := guiX+76 ; Creates new relative coordinates for the Searching Channels splash screen to be displayed ---->>
    SplashScreenY := guiY+250 ; ----------------------------------------------------------------------------------------------<<
  Gui, 3: +Owner1 ; Makes splash screen owned by main window
  Gui, 3: Font, s20 c999999 Arial q5 ; Size 24 font, light grey, Arial, quality 5
  Gui, 3: Add, Text, x0 w700 center, Searching for nearest empty channel`, please wait... ; Message shown on splash screen
  Gui, 3: Font, s12 c999999 Arial q5 ; Size 24 font, light grey, Arial, quality 5
  Gui, 3: Add, Button, x300 w100 -Theme gCancelChannelList, Cancel ; Button to cancel empty channel search
  Gui, 3: -Caption -Resize +0x400000 ; Removes toolbar and adds a thick border around remaining window
  Gui, 3: Color, 000000 ; Black background on splash screen
    Gui, 3: +LastFound ; Sets the splash screen to be the last found window
    WinGet, GUI_ID, ID ; Retrieves the ID number of the splash screen and sends it to GUI_ID variable
    Gui, 3: Show, Hide x%SplashScreenX% y%SplashScreenY% w700 h100, Splash Screen ; Shows the splash screen
    DllCall("AnimateWindow",UInt,GUI_ID,UInt,200,UInt,0xa0000) ; Calls function to fade in splash screen
  Sleep, 200 ; Waits half a second so User can read splash screen if nearest empty channel is close by
Return

ChannelListSplashScreen:
  WinGetPos, guiX, guiY ; Retrieves screen coordinates for upper-left corner of TV
    SplashScreenX := guiX+52 ; Creates new relative coordinates for the Channel List splash screen to be displayed ---->>
    SplashScreenY := guiY+388 ; ----------------------------------------------------------------------------------------<<
  Gui, 4: +Owner1 ; Makes splash screen owned by main window
  Gui, 4: Font, s20 c999999 Arial q5 ; Size 24 font, light grey, Arial, quality 5
  Gui, 4: Add, Text, x0 w700 center, Creating channel list`, please wait... ; Message shown on splash screen
  Gui, 4: Font, s12 c999999 Arial q5 ; Size 24 font, light grey, Arial, quality 5
  Gui, 4: Add, Button, x332 w100 -Theme gCancelChannelList, Cancel ; Button to cancel empty channel search
  Gui, 4: -Caption -Resize +0x400000 ; Removes toolbar and adds a thick border around remaining window
  Gui, 4: Color, 000000 ; Black background on splash screen
    Gui, 4: +LastFound ; Sets the splash screen to be the last found window
    WinGet, GUI_ID, ID ; Retrieves the ID number of the splash screen and sends it to GUI_ID variable
    Gui, 4: Show, Hide x%SplashScreenX% y%SplashScreenY% w742 h100, Splash Screen ; Shows the splash screen
    DllCall("AnimateWindow",UInt,GUI_ID,UInt,200,UInt,0xa0000) ; Calls function to fade in splash screen
  Sleep, 200 ; Waits a little bit so User can read splash screen if nearest empty channel is close by
Return

CancelChannelList: ; If User presses 'Cancel' while searching for a channel
  BreakCommand = 1 ; Sends 1 to the 'BreakCommand' variable, to break the channel list search loop
Return

 ; -----------------------------------------------------------------------------------------------------------<<

ToggleAlwaysOnTop:
  Gui, +LastFound ; Makes the main window the last found window
  Gui, Submit, NoHide ; Clicking 'Always on top' checkbox triggers it on or off
  If CheckboxSetting = 1 ; Checkbox is checked
    WinSet, AlwaysOnTop, On ; TV is set as top-most window
  If CheckboxSetting = 0 ; Checkbox is not checked
    WinSet, AlwaysOnTop, Off ; TV is not set as top-most window
Return

CodeVariableChange:
  Guicontrol,, Channel, Channel %SelectedChannel% ; Shows new channel number above << and >> buttons
  If ChannelTitleDisplay != ; If channel is not empty
    {
      OnOffImageLocation = ; Clears the snow image from the html code
      Hotkey, PGDN, On ; Activates the 'Channel Down' hotkey
      Hotkey, PGUP, On ; Activates the 'Channel Up' hotkey
      Hotkey, Home, On ; Activates the 'Select Channel' hotkey
      GuiControl, Enable, Remove ; Enables 'Remove' button
      GuiControl, Enable, Download ; Enables 'Download' button
      GuiControl, Enable, PlayAll ; Enables 'PlayAll' button
    }
  If ChannelTitleDisplay = ; If channel is empty
    {
      OnOffImageLocation = %SnowScreenUrl% ; Adds snow.gif
      GuiControl, Disable, Remove ; Disables 'Remove' button
      GuiControl, Disable, Download ; Disables 'Download' button
      GuiControl, Disable, PlayAll ; Disables 'PlayAll' button
    }
  code =
    (
      %HTMLbegincontent%`n<span class="fixed">%OnOffImageLocation%</span>`n<%ObjDetails% src="%url%">`n%RemainingParamNames%
      <embed src="%url%" type="application/x-shockwave-flash" allowfullscreen="true" allowScriptAccess="never" width="%w%" height="%h%"></embed></object>
      %HTMLendcontent%
    )
  pwb.document.write(code) ; Writes the contents of the "code" variable to the html page
  pwb.document.location.reload() ; Reloads the html page to use the new code
Return

OnOffSwitch: ; Replaces "code" variable with new url in the html
  code = %HTMLbegincontent%`n%OnOffImageLocation%`n%HTMLendcontent% ; Displays snow or black, depending if On or Off is pressed
  pwb.document.write(code) ; Writes the contents of the "code" variable to the html page
  pwb.document.location.reload() ; Reloads the html page to use the new code
Return

Wave: ; Sets volume, controlled by slider
  Gui, Submit, NoHide
  SoundSet, %Volume%, Wave
  GuiControl,, VolumeDisplay, %Volume%`%
Return

EnableButtons:
  Hotkey, PGDN, On ; Activates the 'Channel Down' hotkey
  Hotkey, PGUP, On ; Activates the 'Channel Up' hotkey
  Hotkey, Home, On ; Activates the 'Select Channel' hotkey
  GuiControl, Disable, PowerOn ; Disables "Power On" button after it is pressed
  GuiControl, Enable, PowerOff ; Enables the rest of these buttons ----------->>
  GuiControl, Enable, Volume
  GuiControl, Enable, ChannelJump
  GuiControl, Enable, FirstEmptyChannelDown
  GuiControl, Enable, FirstEmptyChannelUp
  GuiControl, Enable, ChannelDown
  GuiControl, Enable, ChannelUp
  GuiControl, Enable, List
  GuiControl, Enable, ChannelListingFile ; --------------------------------------<<
Return

DisableButtons:
  Hotkey, PGDN, Off ; Disables the 'Channel Down' hotkey
  Hotkey, PGUP, Off ; Disables the 'Channel Up' hotkey
  Hotkey, Home, Off ; Disables the 'Select Channel' hotkey
  GuiControl, Enable, PowerOn ; Enables "Power On" button when "Power Off" button is pressed
  GuiControl, Disable, PowerOff ; Disables the rest of these buttons --------->>
  GuiControl, Disable, Volume
  GuiControl, Disable, ChannelJump
  GuiControl, Disable, FirstEmptyChannelDown
  GuiControl, Disable, FirstEmptyChannelUp
  GuiControl, Disable, ChannelDown
  GuiControl, Disable, ChannelUp
  GuiControl, Disable, Add
  GuiControl, Disable, Remove
  GuiControl, Disable, Download
  GuiControl, Disable, PlayAll
  GuiControl, Disable, List
  GuiControl, Disable, ChannelListingFile ; -------------------------------------<<
Return

InitializeHTML:
  HTMLbegincontent = ; The beginning of the displayed HTML document, to where the "body" tag opens
    (
      <!DOCTYPE html>`n<html>`n<head>`n<title>%TV%</title>`n<meta http-equiv="Content-Type" content="text/html;charset=utf-8" />
      <style type="text/css"> html {background-color:#000000; overflow:hidden} body {margin:0px; background-color:#000000} .fixed {position:fixed}`n</style>
      </head>`n<body>
    )
  ObjDetails = object width="%w%" height="%h%"
  RemainingParamNames =
    (
      <param name="movie" value="%url%" />
      <param name="allowFullScreen" value="true" />
      <param name="allowScriptAccess" value="never" />
    )
  HTMLendcontent = </body>`n</html> ; The end of the displayed HTML document, from where the "body" tag ends
  OnOffImageLocation = %BlankScreenUrl% ; Inserts image of blank screen from URL
  code = %HTMLbegincontent%`n%OnOffImageLocation%`n%HTMLendcontent% ; puts it all together into the "code" variable
    Gui, +LastFound
	ActiveXW := w+1, ActiveXH := h+1
	Gui Add, ActiveX, x50 y47 h%ActiveXH% w%ActiveXW% vpwb, Shell.Explorer
  pwb.Navigate("about:blank") ; Opens a blank HTML page, ready to show some contents
  pwb.document.write(code) ; Writes the code with all its variables in it
  pwb.document.location.reload() ; Reloads the page with the new HTML code in it
Return

 ; --------------- Mouse hover text --------------------------------------------------------->>
  
 MouseHover() {
  TT_1_PowerOn = Power ON
  TT_1_PowerOff = Power OFF
  TT_1_Volume = Adjust volume
  TT_1_About = Instructions and information
  TT_1_Add = Assign a video`nto current channel
  TT_1_Remove = Erase video from`ncurrent channel
  TT_1_Download = Download current video to`na location of your choice`non your computer
  TT_1_ChannelListingFile = Shows current channel list`nin your web browser
  TT_1_PlayAll = Play all channels as playlist`nstarting from current channel`n(not yet active as of this build)
  TT_1_ChannelJump = Enter channel number`nto open directly`n(from 2 to 9999)
  TT_1_FirstEmptyChannelDown = Skip DOWN to the first`navailable empty channel
  TT_1_ChannelDown = DOWN one channel`n(or 'PageDown' key)
  TT_1_ChannelUp = UP one channel`n(or 'PageUp' key)
  TT_1_OnTopCheckboxSetting = Toggle TV to be the`ntopmost window
  TT_1_FirstEmptyChannelUp = Skip UP to the first`navailable empty channel

  Cntrl = %A_GuiControl% ; Detects which control mouse is over, results sent to "cntrl" variable
  While RegExMatch(Cntrl, "[-;\\. `n]") ; Looks for these characters from inside [] brackets
    Cntrl := RegExReplace(Cntrl, "[-;\\. `n]") ; Removes these characters from inside [] brackets and sends results to "cntrl" variable
  tt := TT_%A_Gui%_%Cntrl% ; Creates "tt" variable from results put together from these variables
  ToolTipSmooth(tt) ; Calls function (below) for mouse hover text using "tt" variable...
}
ToolTipSmooth(Text="", WhichToolTip=16, xOffset=16, yOffset=16) { ; Smooth tooltip, follows mouse
  Static LastText, hwnd, VirtualScreenWidth, VirtualScreenHeight ; Gets this information
  If (VirtualScreenWidth = "" or VirtualScreenHeight = "") { ; If virtual screen width or height is nothing
      SysGet, VirtualScreenWidth, 78 ; Gets virtual screen width this way
      SysGet, VirtualScreenHeight, 79 ; Gets virtual screen height this way
    }
  If (Text = "") { ; If there is no text, nothing is displayed
      ToolTip,,,, % WhichToolTip ; Destroys tooltip
      LastText := "", hwnd := "" ; Displays nothing
      Return
    }
  Else { ; Moves or recreates tooltip
      CoordMode, Mouse, Screen ; Retrieves absolute screen coordinates for mouse
      MouseGetPos, x,y ; Finds out which window or control mouse is hovering over
      x += xOffset, y += yOffset ; I'm not sure how this adds up yet
      WinGetPos,,,w,h, ahk_id %hwnd% ; Retrieves the position and size of the window
      If ((x+w) > VirtualScreenWidth) ; Adjusts Tooltip position--------------------------------------->>>
        AdjustX := 1 ; Moves tooltip in increments of 1px horizontally?
      If ((y+h) > VirtualScreenHeight)
        AdjustY := 1 ; Moves tooltip in increments of 1px vertically?
      If (AdjustX and AdjustY)
        x := x - xOffset*2 - w, y := y - yOffset*2 - h ; Adjusts tooltip position diagonally?
      Else If AdjustX ; If mouse moves horizontally?...
        x := VirtualScreenWidth - w ; ...Adjusts tooltip position horizontally?
      Else If AdjustY ; If mouse moves vertically?...
        y := VirtualScreenHeight - h ; ...Adjusts tooltip position vertically?-------------------------<<<
      If (Text = LastText) ; Moves tooltip
        DllCall("MoveWindow", A_PtrSize ? "UPTR" : "UInt",hwnd,"Int",x,"Int",y,"Int",w,"Int",h,"Int",0) ; Moves tooltip instead of redrawing?
      Else ; Recreates tooltip
        {
          CoordMode, ToolTip, Screen ; Retrieves absolute screen coordinates for tooltip
          ToolTip,,,, % WhichToolTip ; Destroys tooltip
          ToolTip, % Text, x, y, % WhichToolTip ; Shows new tooltip
          hwnd := WinExist("ahk_class tooltips_class32 ahk_pid " DllCall("GetCurrentProcessId")), LastText := Text ; Sends this info to "hwnd" variable
          %A_ThisFunc%(Text, WhichToolTip, xOffset, yOffset) ; Moves new tooltip
        }
      WinSet, AlwaysOnTop, On, ahk_id %hwnd% ; Sets tooltip to be always on top
    }
}
Return

 ; ------ Function to fade text in text controls, by ih57452 --------------------------------------------->>

class TextFader {
  __New(text_color = 0x000000, background_color = 0xf0f0f0, step = 15) {
    global Color
    this.text_color := new Color(text_color)
    this.background_color := new Color(background_color)
    this.step := step
    this.fade_color := new Color
  }

  to(params*) {
    controls := []
    for k, v in params
    {
      if (Mod(k, 2) != 0)
        controls.Insert(v)
    }
    this.out(controls*)
    this.in(params*)
  }

  out(controls*) {
    percent = 100
    while percent > 0
    {
      percent -= this.step
      for k, v in ["R", "G", "B"]
        this.fade_color[v] := Round(this.background_color[v] + ((this.text_color[v] - this.background_color[v]) * (percent / 100)))
      for k, control in controls
      {
        GuiControl, % "+C" . (percent <= 0 ? this.background_color.hex : this.fade_color.hex), %control%
        GuiControl, MoveDraw, %control%
      }
      Sleep, 1
    }
  }

  in(params*) {
    controls := {}
    for k, v in params
    {
      if (Mod(k, 2) != 0)
        control := v
      else
        controls[control] := v
    }
    percent = 0
    while percent < 100
    {
      percent += this.step
      for k, v in ["R", "G", "B"]
        this.fade_color[v] := Round(this.background_color[v] + ((this.text_color[v] - this.background_color[v]) * (percent / 100)))
      for control, text in controls
      {
        GuiControl, % "+C" . (percent >= 100 ? this.text_color.hex : this.fade_color.hex), %control%
        GuiControl,, %control%, %text%
      }
      Sleep, 1
    }
  }
}

class Color ; ---- Modified color class from the AHK_L help file -------------------!!
{
  __New(aRGB = 0x000000) {
    this.RGB := aRGB
  }

  __Get(aName) {
    if (aName = "R")
      return (this.RGB >> 16) & 255
    if (aName = "G")
      return (this.RGB >> 8) & 255
    if (aName = "B")
      return this.RGB & 255
    if (aName = "hex")
    {
      format_setting := A_FormatInteger
      SetFormat, IntegerFast, h
      hex := SubStr(this.RGB + 0, 3)
      SetFormat, IntegerFast, %format_setting%
      while StrLen(hex) < 6
        hex := "0" . hex
      return, "0x" . hex
    }
  }

  __Set(aName, aValue) {
    if aName in R,G,B
    {
      aValue &= 255
      if      (aName = "R")
        this.RGB := (aValue << 16) | (this.RGB & ~0xff0000)
      else if (aName = "G")
        this.RGB := (aValue << 8)  | (this.RGB & ~0x00ff00)
      else  ; (aName = "B")
        this.RGB :=  aValue        | (this.RGB & ~0x0000ff)
      return aValue
    }
  }
}

 ; ----------------- Functions to create background images, opening/closing sound and button sound (by rseding91, v2.2) ----------------------->>
 
Extract_v2top(Filename,DumpData = 0)
{
	Static HasData = 1, Base64Decode, Out_Data, Hex_Mcode="558bec518365fc00568b75088a1684d20f86ac000000578b7d0c5333db33c084d2764d32c984c975318aca80e92b4680f94f770c0fb6ca8b55108a4c11d5eb02b1240fb6d180ea3d80f9240f94c1fec923ca8a1684d277cd84c9760943fec9884c0508eb05c6440508004083f8047caf83fb027c4b8a45098a4d08c0e102c0e8040ac18a4d0a88074783fb027e108a55098ac1c0e802c0e2040ac288074783fb037e09c0e1060a4d0b880f478b45fc8a1684d28d4418ff8945fc0f875bffffff5b5f8b45fc5ec9c3"
	Static CD = "|$$$}rstuvwxyz{$$$$$$$>?@ABCDEFGHIJKLMNOPQRSTUVW$$$$$$XYZ[\]^_``abcdefghijklmnopq"
	Static 1="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"
	Static 2="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"
	
	If (!HasData)
		Return -1
	
	If (CD){
		VarSetCapacity(TD,51212)
		
		Loop,% 2
			TD .= %A_Index%, %A_Index% := ""
		
		VarSetCapacity(Base64Decode,StrLen(Hex_Mcode)//2)
		Loop % StrLen(Hex_Mcode)//2
			NumPut("0x" . SubStr(Hex_Mcode,2*A_Index-1,2),Base64Decode,A_Index-1,"Char")
		
		VarSetCapacity(Out_Data,18690,0)
		, DllCall(&Base64Decode,A_IsUnicode ? "AStr" : "Str",TD,"UInt",&Out_Data,A_IsUnicode ? "AStr" : "Str",CD,"CDECL UINT")
		, Base64Decode := ""
		, TD := ""
		, CD := ""
	}
	
	IfExist,%Filename%
		FileDelete,%Filename%
	
	h := DllCall("CreateFile","str",Filename,"Uint",0x40000000,"Uint",0,"UInt",0,"UInt",4,"Uint",0,"UInt",0)
	DllCall("SetFilePointerEx","Uint",h,"Int64",0,"UInt *",p,"Int",0)
	DllCall("WriteFile","UInt",h,"UInt",&Out_Data,"UInt",18690,"UInt",0,"UInt",0)
	DllCall("CloseHandle", "Uint", h)
	
	If (DumpData)
		VarSetCapacity(Out_Data,18690,0)
		, VarSetCapacity(Out_Data,0)
		, HasData := 0
}

Extract_v2bottom(Filename,DumpData = 0)
{
	Static HasData = 1, Base64Decode, Out_Data, Hex_Mcode="558bec518365fc00568b75088a1684d20f86ac000000578b7d0c5333db33c084d2764d32c984c975318aca80e92b4680f94f770c0fb6ca8b55108a4c11d5eb02b1240fb6d180ea3d80f9240f94c1fec923ca8a1684d277cd84c9760943fec9884c0508eb05c6440508004083f8047caf83fb027c4b8a45098a4d08c0e102c0e8040ac18a4d0a88074783fb027e108a55098ac1c0e802c0e2040ac288074783fb037e09c0e1060a4d0b880f478b45fc8a1684d28d4418ff8945fc0f875bffffff5b5f8b45fc5ec9c3"
	Static CD = "|$$$}rstuvwxyz{$$$$$$$>?@ABCDEFGHIJKLMNOPQRSTUVW$$$$$$XYZ[\]^_``abcdefghijklmnopq"
	Static 1="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"
	
	If (!HasData)
		Return -1
	
	If (CD){
		VarSetCapacity(TD,28228)
		
		Loop,% 1
			TD .= %A_Index%, %A_Index% := ""
		
		VarSetCapacity(Base64Decode,StrLen(Hex_Mcode)//2)
		Loop % StrLen(Hex_Mcode)//2
			NumPut("0x" . SubStr(Hex_Mcode,2*A_Index-1,2),Base64Decode,A_Index-1,"Char")
		
		VarSetCapacity(Out_Data,10302,0)
		, DllCall(&Base64Decode,A_IsUnicode ? "AStr" : "Str",TD,"UInt",&Out_Data,A_IsUnicode ? "AStr" : "Str",CD,"CDECL UINT")
		, Base64Decode := ""
		, TD := ""
		, CD := ""
	}
	
	IfExist,%Filename%
		FileDelete,%Filename%
	
	h := DllCall("CreateFile","str",Filename,"Uint",0x40000000,"Uint",0,"UInt",0,"UInt",4,"Uint",0,"UInt",0)
	DllCall("SetFilePointerEx","Uint",h,"Int64",0,"UInt *",p,"Int",0)
	DllCall("WriteFile","UInt",h,"UInt",&Out_Data,"UInt",10302,"UInt",0,"UInt",0)
	DllCall("CloseHandle", "Uint", h)
	
	If (DumpData)
		VarSetCapacity(Out_Data,10302,0)
		, VarSetCapacity(Out_Data,0)
		, HasData := 0
}

Extract_v2left(Filename,DumpData = 0)
{
	Static HasData = 1, Base64Decode, Out_Data, Hex_Mcode="558bec518365fc00568b75088a1684d20f86ac000000578b7d0c5333db33c084d2764d32c984c975318aca80e92b4680f94f770c0fb6ca8b55108a4c11d5eb02b1240fb6d180ea3d80f9240f94c1fec923ca8a1684d277cd84c9760943fec9884c0508eb05c6440508004083f8047caf83fb027c4b8a45098a4d08c0e102c0e8040ac18a4d0a88074783fb027e108a55098ac1c0e802c0e2040ac288074783fb037e09c0e1060a4d0b880f478b45fc8a1684d28d4418ff8945fc0f875bffffff5b5f8b45fc5ec9c3"
	Static CD = "|$$$}rstuvwxyz{$$$$$$$>?@ABCDEFGHIJKLMNOPQRSTUVW$$$$$$XYZ[\]^_``abcdefghijklmnopq"
	Static 1="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"
	Static 2="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"
	
	If (!HasData)
		Return -1
	
	If (CD){
		VarSetCapacity(TD,48760)
		
		Loop,% 2
			TD .= %A_Index%, %A_Index% := ""
		
		VarSetCapacity(Base64Decode,StrLen(Hex_Mcode)//2)
		Loop % StrLen(Hex_Mcode)//2
			NumPut("0x" . SubStr(Hex_Mcode,2*A_Index-1,2),Base64Decode,A_Index-1,"Char")
		
		VarSetCapacity(Out_Data,17795,0)
		, DllCall(&Base64Decode,A_IsUnicode ? "AStr" : "Str",TD,"UInt",&Out_Data,A_IsUnicode ? "AStr" : "Str",CD,"CDECL UINT")
		, Base64Decode := ""
		, TD := ""
		, CD := ""
	}
	
	IfExist,%Filename%
		FileDelete,%Filename%
	
	h := DllCall("CreateFile","str",Filename,"Uint",0x40000000,"Uint",0,"UInt",0,"UInt",4,"Uint",0,"UInt",0)
	DllCall("SetFilePointerEx","Uint",h,"Int64",0,"UInt *",p,"Int",0)
	DllCall("WriteFile","UInt",h,"UInt",&Out_Data,"UInt",17795,"UInt",0,"UInt",0)
	DllCall("CloseHandle", "Uint", h)
	
	If (DumpData)
		VarSetCapacity(Out_Data,17795,0)
		, VarSetCapacity(Out_Data,0)
		, HasData := 0
}

Extract_v2right(Filename,DumpData = 0)
{
	Static HasData = 1, Base64Decode, Out_Data, Hex_Mcode="558bec518365fc00568b75088a1684d20f86ac000000578b7d0c5333db33c084d2764d32c984c975318aca80e92b4680f94f770c0fb6ca8b55108a4c11d5eb02b1240fb6d180ea3d80f9240f94c1fec923ca8a1684d277cd84c9760943fec9884c0508eb05c6440508004083f8047caf83fb027c4b8a45098a4d08c0e102c0e8040ac18a4d0a88074783fb027e108a55098ac1c0e802c0e2040ac288074783fb037e09c0e1060a4d0b880f478b45fc8a1684d28d4418ff8945fc0f875bffffff5b5f8b45fc5ec9c3"
	Static CD = "|$$$}rstuvwxyz{$$$$$$$>?@ABCDEFGHIJKLMNOPQRSTUVW$$$$$$XYZ[\]^_``abcdefghijklmnopq"
	Static 1="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"
	Static 2="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"
	
	If (!HasData)
		Return -1
	
	If (CD){
		VarSetCapacity(TD,37520)
		
		Loop,% 2
			TD .= %A_Index%, %A_Index% := ""
		
		VarSetCapacity(Base64Decode,StrLen(Hex_Mcode)//2)
		Loop % StrLen(Hex_Mcode)//2
			NumPut("0x" . SubStr(Hex_Mcode,2*A_Index-1,2),Base64Decode,A_Index-1,"Char")
		
		VarSetCapacity(Out_Data,13693,0)
		, DllCall(&Base64Decode,A_IsUnicode ? "AStr" : "Str",TD,"UInt",&Out_Data,A_IsUnicode ? "AStr" : "Str",CD,"CDECL UINT")
		, Base64Decode := ""
		, TD := ""
		, CD := ""
	}
	
	IfExist,%Filename%
		FileDelete,%Filename%
	
	h := DllCall("CreateFile","str",Filename,"Uint",0x40000000,"Uint",0,"UInt",0,"UInt",4,"Uint",0,"UInt",0)
	DllCall("SetFilePointerEx","Uint",h,"Int64",0,"UInt *",p,"Int",0)
	DllCall("WriteFile","UInt",h,"UInt",&Out_Data,"UInt",13693,"UInt",0,"UInt",0)
	DllCall("CloseHandle", "Uint", h)
	
	If (DumpData)
		VarSetCapacity(Out_Data,13693,0)
		, VarSetCapacity(Out_Data,0)
		, HasData := 0
}

Extract_UrlList(Filename,DumpData = 0)
{
	Static HasData = 1, Base64Decode, Out_Data, Hex_Mcode="558bec518365fc00568b75088a1684d20f86ac000000578b7d0c5333db33c084d2764d32c984c975318aca80e92b4680f94f770c0fb6ca8b55108a4c11d5eb02b1240fb6d180ea3d80f9240f94c1fec923ca8a1684d277cd84c9760943fec9884c0508eb05c6440508004083f8047caf83fb027c4b8a45098a4d08c0e102c0e8040ac18a4d0a88074783fb027e108a55098ac1c0e802c0e2040ac288074783fb037e09c0e1060a4d0b880f478b45fc8a1684d28d4418ff8945fc0f875bffffff5b5f8b45fc5ec9c3"
	Static CD = "|$$$}rstuvwxyz{$$$$$$$>?@ABCDEFGHIJKLMNOPQRSTUVW$$$$$$XYZ[\]^_``abcdefghijklmnopq"
	Static 1="W1ZpZGVvVVJMXQ0KDQoNCltDaGFubmVsc10NCg0K"
	
	If (!HasData)
		Return -1
	
	If (CD){
		VarSetCapacity(TD,84)
		
		Loop,% 1
			TD .= %A_Index%, %A_Index% := ""
  
		VarSetCapacity(Base64Decode,StrLen(Hex_Mcode)//2)
		Loop % StrLen(Hex_Mcode)//2
			NumPut("0x" . SubStr(Hex_Mcode,2*A_Index-1,2),Base64Decode,A_Index-1,"Char")
		
		VarSetCapacity(Out_Data,30,0)
		, DllCall(&Base64Decode,A_IsUnicode ? "AStr" : "Str",TD,"UInt",&Out_Data,A_IsUnicode ? "AStr" : "Str",CD,"CDECL UINT")
		, Base64Decode := ""
		, TD := ""
		, CD := ""
	}
	
	IfExist,%Filename%
		FileDelete,%Filename%
	
	h := DllCall("CreateFile","str",Filename,"Uint",0x40000000,"Uint",0,"UInt",0,"UInt",4,"Uint",0,"UInt",0)
	DllCall("SetFilePointerEx","Uint",h,"Int64",0,"UInt *",p,"Int",0)
	DllCall("WriteFile","UInt",h,"UInt",&Out_Data,"UInt",30,"UInt",0,"UInt",0)
	DllCall("CloseHandle", "Uint", h)
	
	If (DumpData)
		VarSetCapacity(Out_Data,30,0)
		, VarSetCapacity(Out_Data,0)
		, HasData := 0
}

Extract_TVloadingSound(Filename,DumpData = 0)
{
	Static HasData = 1, Base64Decode, Out_Data, Hex_Mcode="558bec518365fc00568b75088a1684d20f86ac000000578b7d0c5333db33c084d2764d32c984c975318aca80e92b4680f94f770c0fb6ca8b55108a4c11d5eb02b1240fb6d180ea3d80f9240f94c1fec923ca8a1684d277cd84c9760943fec9884c0508eb05c6440508004083f8047caf83fb027c4b8a45098a4d08c0e102c0e8040ac18a4d0a88074783fb027e108a55098ac1c0e802c0e2040ac288074783fb037e09c0e1060a4d0b880f478b45fc8a1684d28d4418ff8945fc0f875bffffff5b5f8b45fc5ec9c3"
	Static CD = "|$$$}rstuvwxyz{$$$$$$$>?@ABCDEFGHIJKLMNOPQRSTUVW$$$$$$XYZ[\]^_``abcdefghijklmnopq"
	Static 1="UklGRgyJAABXQVZFYmV4dFoDAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAQWFyb24gQmV3emEAAAAAAAAAAAAAAAAAAAAAAAAAAABVUyAgIDE4LjAuMi4yNDIAADEwNTgyNC0xODI1ODY4ADIwMTEtMDktMTMxMDo1ODoyNAUDAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAEE9UENNLEY9NDQxMDAsVz0xNixNPXN0ZXJlbyxUPVNPTkFSIFgxIFByb2R1Y2VyIFgxYgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABmbXQgEgAAAAEAAgBErAAAELECAAQAEAAAAEpVTktoDAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA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"
	Static 2="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3f/d/+n/6f8UABQAAAAAAPL/8v8EAAQABQAFAAAAAAAQABAA+f/5//D/8P8AAAAA7v/u//n/+f/T/9P/5f/l/wcABwDx//H/9//3/+X/5f/z//P/4//j/9n/2f/w//D/8P/w/wUABQD9//3/+P/4/+7/7v/s/+z/6v/q//b/9v/3//f/7P/s/xAAEADo/+j/7//v/wgACAD//////v/+/9//3//9//3/7P/s/+7/7v8BAAEA/f/9/wAAAADO/87/6P/o/woACgD5//n/7v/u/+v/6//4//j/BgAGAPv/+//3//f/DAAMAOn/6f8DAAMA/f/9/9r/2v8FAAUA7P/s/wYABgALAAsA9v/2//3//f/Q/9D/7P/s//D/8P/5//n/HwAfAOf/5//X/9f/AgACAAMAAwABAAEABwAHANn/2f/g/+D/DQANAOr/6v/z//P/EwATAP3//f/4//j/+f/5//b/9v/6//r/6//r/+P/4//s/+z/+//7//D/8P/p/+n//f/9//r/+v8AAAAA5//n/+D/4P/w//D/6//r//j/+P/z//P//f/9//X/9f/3//f/6P/o/97/3v/+//7/6P/o//r/+v8RABEAAAAAAPr/+v/4//j/7P/s/+j/6P/u/+7/0v/S/9T/1P/y//L/DwAPABAAEADk/+T/5f/l/73/vf+y/7L/DQANAPv/+//v/+//5P/k/+H/4f8UABQA8v/y//T/9P8CAAIA/f/9/+7/7v/l/+X/1v/W/8H/wf/i/+L/AwADAAMAAwD8//z/BwAHAN//3//4//j/GQAZAO//7//Z/9n/2v/a//L/8v/s/+z/AgACAO3/7f/5//n/AwADAOX/5f/9//3/8//z/+P/4//b/9v/BQAFAPD/8P/w//D/8P/w/8T/xP/6//r/7//v//////8AAAAA4v/i//j/+P/r/+v/CAAIAO//7/+x/7H/6P/o/wMAAwDl/+X/5v/m/wIAAgAKAAoA8//z//3//f/8//z/9//3//L/8v/3//f/9//3//v/+//3//f/6P/o/wAAAAD0//T/DAAMAOH/4f/g/+D/DwAPAPP/8/8NAA0A+P/4/w4ADgD+//7/2//b//n/+f/9//3/7f/t/+n/6f8HAAcA6P/o//X/9f8IAAgA+//7//P/8/8CAAIAFQAVAN//3//l/+X/AwADAAAAAAAGAAYA/////wIAAgAFAAUA9v/2/wUABQACAAIA8f/x//7//v/1//X/0P/Q/+3/7f8OAA4A8//z///////2//b/DQANAAEAAQDp/+n///////f/9/8MAAwABwAHAA0ADQD8//z/BgAGABEAEQAMAAwAAgACAOX/5f8NAA0A4//j//j/+P8sACwA9f/1/+//7//+//7/9v/2/wQABAAbABsA9P/0/wEAAQAaABoA+P/4/wgACAD/////AQABABkAGQAQABAAFgAWAPn/+f8JAAkA9v/2/+z/7P8vAC8ACAAIAAYABgAHAAcA+v/6/wQABAASABIAHgAeAP////8XABcACAAIAAIAAgANAA0A+P/4/wsACwAPAA8ADgAOAAEAAQABAAEADAAMABoAGgAsACwAGwAbAAAAAAANAA0ACQAJAP3//f8iACIAGAAYAA4ADgAYABgACAAIAAUABQAKAAoAHwAfAAkACQADAAMACwALAPv/+/8HAAcA+v/6/xAAEAASABIAEQARAAYABgD3//f/JAAkAAoACgAjACMAFwAXAAwADAA3ADcADgAOAPn/+f8NAA0AJwAnAP3//f8FAAUAGAAYAA8ADwARABEADQANAB8AHwD9//3/BgAGAAwADAAEAAQAEAAQABcAFwAfAB8ACgAKAAoACgAeAB4AGQAZAP////8HAAcADAAMAAwADAAJAAkAGQAZAC4ALgARABEABQAFAA4ADgD5//n//////w8ADwD/////IAAgABgAGAAhACEAHgAeAPf/9/8dAB0AAwADAAcABwAZABkABQAFABMAEwAPAA8ADAAMABMAEwAIAAgAAwADAAMAAwADAAMAGgAaABIAEgAUABQADAAMAAQABAAmACYAFAAUAAAAAAAHAAcAAwADAA4ADgAYABgAAgACABUAFQASABIAAwADABsAGwAOAA4ADAAMAAAAAAAGAAYAGAAYABMAEwAGAAYAAAAAAAsACwD8//z/CwALABgAGAABAAEA+f/5/xIAEgAJAAkA/P/8/xoAGgAJAAkAFAAUAA4ADgD8//z//v/+//P/8/8JAAkA/f/9/wUABQADAAMA/f/9/wUABQD7//v/DgAOAA0ADQAFAAUA9v/2/w4ADgASABIA+v/6/xoAGgAMAAwA/P/8/wQABAD8//z/CQAJACUAJQAXABcAAgACAAgACAD8//z/AQABAAoACgAKAAoA/////wAAAAAKAAoA+P/4/wAAAAAAAAAA/////wUABQAAAAAAAQABAP7//v8CAAIA+P/4/xMAEwAKAAoA5//n/wEAAQAAAAAABwAHAAcABwAGAAYACwALAP3//f8EAAQA/v/+/wMAAwAFAAUA+f/5/wAAAAAOAA4AEgASAPz//P/t/+3/8//z/wMAAwANAA0AAwADAPf/9/8BAAEABQAFAPv/+/8FAAUAAgACAAEAAQAEAAQAAQABABAAEAD7//v/AAAAAPj/+P/r/+v/EgASAPv/+//7//v///////z//P8JAAkA9P/0//v/+//6//r/9v/2//f/9/8DAAMACQAJAP////8DAAMA/v/+/wsACwABAAEA9v/2/wIAAgD6//r/DgAOABAAEAD9//3/AAAAAP////8BAAEA9P/0//H/8f/2//b/7v/u//X/9f/6//r/+//7/wIAAgAGAAYA/f/9//////8AAAAA+v/6//P/8//2//b/AAAAAPf/9/8AAAAA+P/4/wIAAgAFAAUAAwADAAkACQDj/+P//f/9/wEAAQDx//H/CwALAAIAAgDy//L//v/+/wQABADz//P/9//3/+3/7f/1//X/AAAAAPT/9P/8//z/8//z//v/+/8KAAoACQAJAAoACgDv/+//+P/4/wQABAD3//f/IAAgABIAEgDv/+//AwADAAIAAgD7//v//f/9///////+//7/AwADAAAAAAD7//v/9v/2//r/+v8MAAwABQAFAAIAAgD7//v//f/9/wAAAAD7//v/CwALAAQABAD8//z/+f/5//j/+P8GAAYAAgACAAMAAwAEAAQA/P/8/wIAAgD9//3//P/8/wIAAgD0//T//////wkACQD6//r/BgAGAO7/7v/t/+3/CgAKAPX/9f/7//v//f/9//r/+v8EAAQABwAHAA4ADgAEAAQACQAJAAsACwD7//v/AgACAA0ADQDw//D/9//3/wUABQD5//n/AAAAAP7//v8GAAYAAAAAAP////8AAAAA+P/4//n/+f/5//n/DAAMAAEAAQABAAEAAAAAAPn/+f8AAAAA9v/2//b/9v//////+f/5//r/+v8AAAAA6v/q//j/+P8HAAcA+//7/wMAAwD+//7/9f/1//H/8f/0//T/9//3//r/+v/3//f/AgACAPT/9P/1//X/9f/1/9f/1//3//f/+f/5//b/9v/9//3/8//z//v/+/8CAAIA//////////8BAAEA9f/1//r/+v/w//D/+f/5/+//7//1//X/BwAHAPj/+P8IAAgA6//r//b/9v/6//r//v/+/wkACQDs/+z/9f/1/+3/7f/6//r///////b/9v/3//f/BQAFAO//7//w//D/CQAJAOL/4v/5//n/BAAEAP3//f8HAAcA/f/9//////8BAAEAAAAAAP//////////5f/l/9H/0f/c/9z/9f/1//b/9v/7//v/BQAFAP////8LAAsACQAJAPT/9P/l/+X/+v/6//3//f/e/97/3P/c/wAAAAABAAEA+//7/wcABwDp/+n/8//z//////8IAAgACAAIAN7/3v/5//n/BgAGAP7//v8EAAQA9//3/wIAAgADAAMA/f/9/wAAAAD7//v/9//3//z//P8AAAAA/P/8/wQABAAEAAQA/////wAAAAABAAEA8//z//X/9f8IAAgA9v/2///////8//z/AwADAAYABgDi/+L/3//f/9f/1//4//j/9//3/97/3v/0//T/BQAFAP7//v8BAAEA+P/4/9P/0//0//T/5//n//L/8v/9//3/4f/h/wgACAD5//n/BgAGAPv/+//2//b/CAAIAPL/8v8CAAIA/////wIAAgD//////////wkACQD7//v/6f/p/wYABgAKAAoA9//3/xIAEgD3//f/7P/s/+f/5//6//r/CgAKAPD/8P8FAAUABgAGAAMAAwAEAAQAAAAAAPf/9//9//3/CgAKAAgACAD+//7/8v/y/wEAAQD5//n/BQAFAPz//P/x//H/8f/x//P/8/8GAAYA2v/a//////8kACQAAwADAP7//v/p/+n//f/9/woACgD3//f/9//3//b/9v8GAAYAFQAVAAIAAgD/////CAAIAP3//f8EAAQACAAIAPX/9f/1//X/DAAMAA0ADQAGAAYACwALAPX/9f8CAAIAGwAbAPv/+//4//j//f/9//X/9f8PAA8A/v/+//v/+/8KAAoA9v/2/wYABgAHAAcABgAGAAwADAD2//b/AQABAAQABAD1//X//P/8//7//v8CAAIABgAGAAQABAABAAEA+v/6//v/+/8AAAAA/////wEAAQADAAMAAQABAP////8PAA8AEAAQAPz//P8BAAEADgAOAP7//v/1//X/FgAWAA8ADwAFAAUABQAFAAAAAAANAA0AAQABAA8ADwAJAAkACAAIABUAFQD+//7/AwADAA0ADQAaABoABAAEAPz//P8FAAUA/P/8/wIAAgD8//z/CAAIAAYABgAAAAAACQAJAA4ADgAYABgADgAOAP/////7//v/CwALAA8ADwAAAAAABAAEAAIAAgAAAAAAAgACAP7//v8GAAYABAAEAA0ADQAOAA4A/////wkACQASABIAFgAWAA0ADQAJAAkAAwADAP////8NAA0AAAAAAAEAAQAEAAQA/////wIAAgD8//z/CQAJAA4ADgADAAMA/v/+/woACgAWABYADgAOAAUABQD5//n/+v/6/woACgAGAAYA9v/2//////8OAA4ABAAEAP3//f8BAAEABAAEAAAAAAADAAMADgAOAAIAAgD+//7/AwADAAEAAQD//////////wIAAgAAAAAA//////7//v8CAAIACQAJAAIAAgAHAAcABwAHAP7//v8IAAgABwAHAAAAAAD8//z//P/8/wAAAAAGAAYACwALAAIAAgALAAsACQAJAAUABQAJAAkAAgACAAUABQAGAAYAEgASAAMAAwD7//v/CAAIAAMAAwAJAAkABwAHAAEAAQABAAEA/f/9/wAAAAD//////f/9//7//v8IAAgABgAGAP7//v8FAAUABQAFAAEAAQD7//v/BQAFAAUABQD9//3/EQARAAoACgAFAAUABwAHAAQABAAFAAUAAgACAAUABQADAAMAAgACAAIAAgAGAAYABQAFAAcABwAJAAkABQAFAAQABAD+//7/BAAEAAEAAQAAAAAABgAGAAYABgD+//7/AQABAA8ADwABAAEADQANAA0ADQD9//3/CgAKAAIAAgAIAAgACQAJAPz//P8HAAcAAgACAAYABgADAAMA/f/9/wYABgABAAEABQAFAAQABAAIAAgABQAFAAQABAAJAAkAAgACAAgACAACAAIACgAKAA4ADgACAAIAAgACAAIAAgAAAAAA/v/+/wwADAAFAAUA/////wAAAAD/////CwALAAMAAwD+//7/+//7//////8DAAMA+f/5/wUABQANAA0AAwADAP7//v8FAAUABQAFAAAAAAD7//v/BAAEAAEAAQD8//z/FwAXAAAAAADz//P/AwADAPv/+//+//7/+v/6/wAAAAAAAAAA/v/+/wQABAACAAIAAgACAPj/+P8DAAMA/v/+//r/+v/7//v/7P/s/xIAEgAeAB4A/v/+//7//v/+//7/AAAAABMAEwABAAEA9v/2///////1//X/CwALAAMAAwDr/+v/AQABAP////8AAAAAAgACAPf/9/8DAAMA/P/8/wAAAAAGAAYA+P/4//////8AAAAAAAAAAP3//f//////+//7/+3/7f/6//r/AQABAP7//v/+//7/AAAAAPP/8//y//L/BgAGAAwADAACAAIA+f/5/wgACAD8//z/9v/2//3//f/5//n/AQABAP7//v8CAAIA+P/4//r/+v8GAAYA/f/9///////8//z//P/8///////7//v//f/9//3//f/+//7////////////9//3///////3//f/8//z/AAAAAPr/+v//////BQAFAAQABAAEAAQA///////////9//3//v/+//f/9//7//v/BwAHAAUABQAIAAgABwAHAAIAAgD3//f/AAAAAPz//P/1//X/AgACAPr/+v/+//7//v/+//n/+f8CAAIABgAGAAsACwALAAsAAAAAAAAAAAACAAIA/P/8/wcABwAKAAoAAQABAP////8BAAEA/////wIAAgAJAAkA/v/+/wEAAQAJAAkAAgACAAAAAAABAAEACAAIAAMAAwD3//f///////3//f/5//n/AAAAAP3//f/8//z/+f/5/wEAAQD3//f/4//j//b/9v/7//v/8P/w//f/9/8AAAAA/v/+///////1//X/9v/2///////p/+n/+//7//3//f/s/+z//f/9//f/9/8CAAIABAAEAPz//P8CAAIA/f/9//3//f8DAAMABAAEAPv/+///////BAAEAAAAAAD+//7/+v/6//v/+/8BAAEA/v/+//X/9f/3//f/7//v//v/+//+//7/7v/u/wIAAgAFAAUAAwADAAUABQDy//L/6v/q//T/9P///////P/8//X/9f/7//v/AwADAP/////7//v/+f/5//////8DAAMA9P/0//r/+v/6//r/9f/1//r/+v/4//j/AAAAAPr/+v/+//7/CQAJAP3//f/3//f/9P/0//3//f8IAAgAAgACAAwADAD9//3/9P/0/wQABADy//L/8f/x//L/8v/6//r/CQAJAP////8NAA0A/v/+//r/+v8IAAgAAQABAAEAAQAAAAAAAwADAAcABwACAAIA/f/9/wEAAQD9//3/AQABAPz//P/6//r//f/9//b/9v//////9//3//n/+f/y//L/9f/1/wIAAgD6//r/BAAEAPb/9v/n/+f/9v/2/wIAAgDz//P/8f/x/+7/7v/p/+n/+v/6//v/+/8DAAMAAAAAAPz//P/4//j/6//r//T/9P/9//3/+//7//z//P8AAAAA/v/+//X/9f/0//T/BQAFAPb/9v/y//L/AgACAP////8AAAAAAgACAAgACAD6//r//f/9/wQABAD7//v//v/+//3//f8CAAIA/////wAAAAAAAAAA/////wIAAgD6//r/9v/2//v/+/8CAAIABAAEAPv/+//x//H/+v/6/wMAAwADAAMAAgACAPz//P/u/+7/9//3/wQABAD3//f/+v/6/wIAAgAAAAAA/////wAAAADy//L/7v/u/wQABAD//////v/+/wEAAQD7//v//P/8/wAAAAAEAAQAAwADAP3//f8CAAIAAgACAP3//f8DAAMAAgACAAEAAQD1//X/+f/5/wkACQD6//r/+f/5/wAAAAD5//n/9//3//v/+//x//H/8f/x//z//P/8//z/9//3//j/+P//////9v/2/+//7//w//D/+P/4///////4//j/9v/2//L/8v/u/+7/+f/5//3//f/5//n///////3//f/0//T/9f/1//f/9//7//v/+//7//3//f/6//r//P/8//7//v/5//n/AAAAAPv/+//0//T/+//7//v/+///////AQABAPv/+//8//z//P/8//r/+v/8//z/AAAAAPT/9P/z//P//v/+//3//f/2//b/+v/6//n/+f/v/+//9v/2//j/+P/4//j///////v/+//0//T/8P/w//L/8v/7//v/AAAAAPn/+f/6//r//v/+//j/+P/1//X/+//7//v/+//2//b//P/8//z//P/7//v/AQABAAAAAAD4//j//////wEAAQD+//7//v/+/wEAAQAAAAAA+P/4/wMAAwAAAAAAAQABAPr/+v/8//z/BAAEAPf/9//9//3//f/9//z//P/4//j/+f/5//7//v/6//r/+//7/wAAAAD2//b/9f/1//z//P/x//H/+//7//3//f/8//z/AwADAPz//P/0//T/+P/4//////8CAAIA/f/9//r/+v///////////woACgAAAAAABAAEAP3//f/5//n/CAAIAPv/+//9//3//f/9/wQABAACAAIA/f/9//3//f8DAAMACgAKAAcABwAKAAoABQAFAAYABgD7//v/+f/5//7//v/9//3//////wMAAwACAAIAAwADAAAAAAAAAAAABwAHAPX/9f/+//7/AQABAPz//P8DAAMAAQABAAoACgAMAAwA/f/9/wMAAwAOAA4A+f/5/wAAAAD+//7/+v/6/wYABgAGAAYADwAPABUAFQAEAAQA+//7/w4ADgD+//7/AgACAP////8FAAUADgAOAP////8IAAgAAgACABMAEwANAA0AAwADAA0ADQD7//v//v/+/wUABQAAAAAAEgASAAwADAAEAAQADAAMAAEAAQAOAA4AAwADAAQABAAEAAQA9//3/wkACQAQABAAAgACAAsACwAWABYAAQABAAgACAD6//r/CQAJAAIAAgD7//v/EQARAPz//P8IAAgA9//3/wgACAAQABAA/////w4ADgACAAIAAgACAAwADAAIAAgA/v/+/wkACQAPAA8ACAAIAAIAAgAKAAoA/////wMAAwANAA0ABwAHABUAFQD8//z/+v/6/wkACQAIAAgACgAKAAgACAD+//7/CQAJAAMAAwD7//v/BwAHAPr/+v8RABEACQAJAAkACQD+//7/8v/y/wgACAADAAMA/v/+//T/9P8UABQACwALAA8ADwALAAsA8//z/wkACQD5//n/DgAOABEAEQAQABAAEwATAA0ADQALAAsA+f/5/wsACwADAAMAAgACABAAEAAAAAAAAAAAAAoACgADAAMA8f/x/wgACAASABIAAgACAAsACwAHAAcAEAAQAA8ADwAKAAoAEQARAPr/+v/+//7/CQAJAAYABgABAAEAAAAAAAkACQAHAAcACgAKABAAEAACAAIABgAGABkAGQAIAAgACQAJAB4AHgAXABcA//////b/9v8IAAgADwAPAA0ADQAQABAAEQARAP3//f8MAAwAHQAdAAAAAAASABIADAAMAAcABwANAA0A8//z/wwADAAJAAkACgAKABAAEAAAAAAAEAAQABAAEAAOAA4AAgACAPf/9/8CAAIAEQARABAAEAALAAsA8f/x//7//v8XABcAEwATABQAFAANAA0AGgAaAPH/8f8EAAQADgAOAP////8JAAkACAAIABcAFwAJAAkAl/+X/6z/rP9wAHAAq/+r/4n/if/2//b/EwATAC4ALgBr/2v/gP+A/6L/ov+4/7j/Rf9F/6f/p/9KAEoA9v/2/wUABQArACsACwALAHH/cf+pAKkAWwBbAMj/yP/w//D/+f75/kkASQAyATIB2wDbAHcAdwADAAMAdf91/9//3//0//T/kP+Q/ywALACy/7L/0v/S/w0BDQFaAFoA4/7j/qr/qv9CAEIAWABYANb/1v+e/57/EQARAGf/Z//P/8//SgBKAA0ADQDP/8//lwCXABMAEwD/////EQARAGH/Yf9WAFYAqv+q/9v/2/9P/0//rf+t/zcANwACAAIAAAEAAWD/YP+B/4H/zv/O/0IAQgDN/83/Cf8J//3//f/Z/9n/8gHyAVwBXAF+/37/4//j/+8A7wCVAZUBPf49/sf+x/7GAMYAUwBTAAwCDAL5//n/nwCfAFYBVgHfAN8ACgMKA8/9z/2U/5T/7AHsAcT/xP9yAXIBIf8h/0QCRAITAhMCq/+r/xoBGgF+/n7+o/6j/qD/oP/d/93/Y/9j/1AAUABXAFcAmwCbALcCtwK0/rT+iPyI/Or/6v/o/+j/jP+M/8oBygEE/QT96v7q/qgEqATgAOAAegJ6Ai4ALgDe/97/PgM+A/v/+/9nAWcBsACwAJ7/nv87ADsAUf9R/40CjQJBAkECx/3H/aABoAHvA+8DDQANACkCKQJDAUMBO/47/qD+oP5DAEMAAQABADz9PP3HAccB2QLZAmn/af9TAFMACAAIAND/0P9G/kb+8AHwASsFKwUP/g/+sP6w/m0AbQB2/Xb9PP88/2//b/8H/gf+ZPpk+p79nv0kASQBuP64/l8AXwAY/xj/CQAJANP90/2e/J78CgAKANX+1f4MAAwAw/zD/KH8ofwBAQEB2wHbAfX/9f9t/W390/7T/moBagHjAuMCYPxg/Jj8mPwe/h7+p/un+5UElQTIAsgCaPxo/AYCBgKIAogCzv3O/e/+7/5D/kP+/Pz8/EoBSgEZBRkFUgFSAQX7Bfs5/zn/aQBpAAz/DP8Q/hD+jv2O/db/1v9R/lH+0wHTAWX9Zf26+7r7eP94/3f+d/53AXcBo/6j/vMB8wGq/6r/8vfy9xb9Fv0bABsAX/9f/zP+M/41ADUAMP4w/tT91P3IBMgEIQIhAqL+ov7X/9f/eAF4AawArABR/lH+0wTTBL8DvwN6/nr+pgGmAU0ATQC9/73/5ADkACMFIwVOAk4CqP+o/3gHeAcaAxoDSf9J/xkAGQAgAyADeQJ5AuP/4/9vA28Dq/6r/qz9rP1VAFUApwGnAX/+f/5a/1r/SwRLBEMBQwGKBIoEpv+m/2v5a/l+/37/yf/J/8j/yP8xATEB+Pr4+mH9Yf1oBGgEPQE9AW4BbgGXAJcAof+h/wcBBwFQ/1D/qv2q/af9p/1mAWYBxgHGAUEBQQHJA8kDKQMpA/T/9P/W/9b/LAMsAyn/Kf8X/Rf95AbkBiYDJgMg/iD+sAGwAS7/Lv/bANsAVQJVAukE6QTI/sj+"
	Static 3="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wP/A/wkACQDJ/8n/aQNpA4r+iv5n/mf+4QDhAAECAQLQANAAMf8x/2kAaQCm/6b/M/8z/6/+r/7FAMUA7v7u/lcAVwDoAegBmACYAD7/Pv9v/2//K/4r/pP7k/u6AboBtgG2AX//f//k/+T//////xQAFADk/+T/CQAJANQA1AB7AHsA+v76/osBiwHV/dX98f3x/ez97P13/Xf9pQKlAmsAawBOAE4AQgBCAIQAhAChAaEBCwALAB0AHQCe/57/qf+p/+wA7AAZABkAM/8z/ykAKQB0AHQAEgESAe3/7f9f/1//uf+5/1f/V//9//3/7//v/6r/qv+d/53/FQAVAOD/4P/f/9//v/+//6b/pv/f/9//p/+n/6X/pf8c/xz/ov+i/yMAIwCHAIcAwf/B/7D+sP7p/+n/7f/t/xT/FP8y/zL/0v/S/0wATABCAEIAIQAhAAoACgDb/9v/9//3//T/9P/Y/9j/7//v/7P/s//9//3/lACUALUAtQABAAEAt/+3/1YAVgBPAE8At/+3/9j/2P/g/+D/YgBiANoA2gCT/5P/NQA1AP7//v+e/57/fAB8AM//z/8hACEA1f/V/8L/wv8LAAsABAAEAPX/9f+7/7v//////+3/7f8EAAQADQANAP7//v/6//r/PQA9AML/wv/T/9P/w//D/6f/p/80ADQA0v/S/08ATwD/////p/+n/wUABQAYABgAHAAcAP3//f+y/7L/zv/O/34AfgAFAAUA8v/y//P/8/8MAAwALAAsAOf/5/8HAAcA8//z/xkAGQACAAIAAQABAC4ALgATABMAMAAwAAwADAC7/7v/SABIAFEAUQDh/+H/xP/E/73/vf8NAA0A7//v//////8EAAQA7P/s//P/8//m/+b/1P/U/+r/6v9EAEQAGgAaAC4ALgA5ADkArf+t/83/zf8LAAsA0//T/wgACAAjACMABwAHAPz//P8EAAQA+f/5//r/+v8NAA0AAgACABQAFADg/+D/CwALAOL/4v+w/7D/0//T/8z/zP8gACAACgAKAPr/+v8LAAsAAQABAPH/8f8lACUADQANAM//z/8LAAsA9f/1//P/8//p/+n/GwAbABkAGQC9/73/2P/Y//L/8v8DAAMAAAAAAPb/9v8CAAIA+v/6/wEAAQAIAAgA9v/2/wcABwAEAAQA3P/c/9T/1P/y//L///////v/+/8AAAAA7f/t/+X/5f/Y/9j/0v/S/9r/2v/t/+3/9P/0//z//P/9//3/9f/1/wkACQDo/+j/2//b/+//7//5//n/8P/w/+j/6P/2//b/9P/0/wIAAgD5//n/AgACAAkACQABAAEACAAIAPj/+P/0//T/8P/w//r/+v//////9f/1/+n/6f/x//H/+f/5//D/8P/l/+X/tP+0/8r/yv/U/9T/3f/d//n/+f/W/9b/9v/2/wUABQDv/+//4P/g/+f/5//6//r/9//3/+X/5f/c/9z//v/+/+X/5f/M/8z/CgAKAPr/+v/o/+j/BgAGANP/0//k/+T/9//3//H/8f/6//r/5f/l/xoAGgDw//D/0v/S/wAAAAAAAAAA/P/8//j/+P8MAAwAAQABAAIAAgD/////AQABAP3//f/7//v/BAAEAO7/7v/6//r/6f/p/+3/7f/+//7/9//3/+z/7P/c/9z/+v/6/wMAAwD5//n/AQABAPz//P/x//H/7f/t//P/8//9//3/8f/x/+7/7v/9//3/+f/5//X/9f/2//b//P/8//P/8//x//H/AgACAPD/8P/k/+T/AQABAAQABAAAAAAA/f/9//n/+f8HAAcA9//3//D/8P/w//D/9P/0///////5//n/+f/5//////8KAAoA/v/+/wMAAwAEAAQABAAEAAMAAwD//////f/9//T/9P8GAAYA9f/1//f/9//7//v/+f/5//f/9//r/+v/CQAJAPH/8f/1//X//////wEAAQD5//n/1v/W//3//f8KAAoA8v/y//D/8P8GAAYA+//7//P/8//9//3/8//z//3//f/9//3/AAAAAAAAAAD/////BAAEAP3//f///////f/9//////8AAAAA7v/u//D/8P8CAAIA/v/+/wIAAgD+//7/8P/w//L/8v/y//L/+P/4//7//v/7//v//f/9/wMAAwAAAAAA/P/8//f/9//7//v/BAAEAPr/+v/2//b//f/9//f/9//1//X/BQAFAPj/+P/z//P/+v/6//X/9f8BAAEA+//7//3//f/9//3/+P/4/wIAAgDz//P/8f/x//r/+v8EAAQA/P/8//X/9f8EAAQAAAAAAAAAAAD/////+v/6//v/+/8FAAUAAQABAPf/9////////f/9/wgACAABAAEA/P/8/wIAAgD0//T//////wMAAwD+//7/AQABAP7//v8BAAEAAgACAAEAAQD+//7//f/9/wEAAQACAAIAAAAAAP/////+//7/AgACAPz//P/5//n/AQABAPr/+v/5//n/AQABAAMAAwAEAAQA/P/8//z//P8EAAQAAAAAAP7//v///////v/+/wQABAD/////AQABAAMAAwD/////AAAAAP7//v8BAAEAAwADAAAAAAABAAEAAQABAAIAAgAAAAAAAAAAAAMAAwADAAMAAgACAAAAAAACAAIABAAEAAMAAwAAAAAAAQABAAMAAwABAAEAAAAAAAAAAAAAAAAAAQABAAEAAQAAAAAAAAAAAAEAAQABAAEAAQABAAEAAQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=="
	
	If (!HasData)
		Return -1
	
	If (CD){
		VarSetCapacity(TD,96154)
		
		Loop,% 3
			TD .= %A_Index%, %A_Index% := ""
		
		VarSetCapacity(Base64Decode,StrLen(Hex_Mcode)//2)
		Loop % StrLen(Hex_Mcode)//2
			NumPut("0x" . SubStr(Hex_Mcode,2*A_Index-1,2),Base64Decode,A_Index-1,"Char")
		
		VarSetCapacity(Out_Data,35092,0)
		, DllCall(&Base64Decode,A_IsUnicode ? "AStr" : "Str",TD,"UInt",&Out_Data,A_IsUnicode ? "AStr" : "Str",CD,"CDECL UINT")
		, Base64Decode := ""
		, TD := ""
		, CD := ""
	}
	
	IfExist,%Filename%
		FileDelete,%Filename%
	
	h := DllCall("CreateFile","str",Filename,"Uint",0x40000000,"Uint",0,"UInt",0,"UInt",4,"Uint",0,"UInt",0)
	DllCall("SetFilePointerEx","Uint",h,"Int64",0,"UInt *",p,"Int",0)
	DllCall("WriteFile","UInt",h,"UInt",&Out_Data,"UInt",35092,"UInt",0,"UInt",0)
	DllCall("CloseHandle", "Uint", h)
	
	If (DumpData)
		VarSetCapacity(Out_Data,35092,0)
		, VarSetCapacity(Out_Data,0)
		, HasData := 0
}

Extract_TVpowerSound(Filename,DumpData = 0)
{
	Static HasData = 1, Base64Decode, Out_Data, Hex_Mcode="558bec518365fc00568b75088a1684d20f86ac000000578b7d0c5333db33c084d2764d32c984c975318aca80e92b4680f94f770c0fb6ca8b55108a4c11d5eb02b1240fb6d180ea3d80f9240f94c1fec923ca8a1684d277cd84c9760943fec9884c0508eb05c6440508004083f8047caf83fb027c4b8a45098a4d08c0e102c0e8040ac18a4d0a88074783fb027e108a55098ac1c0e802c0e2040ac288074783fb037e09c0e1060a4d0b880f478b45fc8a1684d28d4418ff8945fc0f875bffffff5b5f8b45fc5ec9c3"
	Static CD = "|$$$}rstuvwxyz{$$$$$$$>?@ABCDEFGHIJKLMNOPQRSTUVW$$$$$$XYZ[\]^_``abcdefghijklmnopq"
	Static 1="UklGRsxjAABXQVZFYmV4dFoDAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAQWFyb24gQmV3emEAAAAAAAAAAAAAAAAAAAAAAAAAAABVUyAgIDE4LjAuMi4yNDIAADEwNTY1MS0yMTQwMDE4ADIwMTEtMDktMTMxMDo1Njo1MRssAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAEE9UENNLEY9NDQxMDAsVz0xNixNPXN0ZXJlbyxUPVNPTkFSIFgxIFByb2R1Y2VyIFgxYgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABmbXQgEgAAAAEAAgBErAAAELECAAQAEAAAAEpVTktoDAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABkYXRh1FMAAAAAAAD///3//f8AAPv/8f/s/+//5//0//f/4f/4//v/EwAUADAAJgAyAE4AOQAqAP3/VwAEAGEAzf8E/57+2P5C/98AegF3AZMBAwDA/z/+R/45/kn/gQEZAnIDPwOoALwAwvwY/GP66vnq+5f7Uf8v/uD+XP+mAHMCwwdqCJQQHBINIJAk7iW9JncJdANC5NDebNg51WHcJ9iJ4cfddOO45Jvh/ube6qLupwPdB8kb1CSKK1M1mzO0N640eS+QLKMeeRaFCs7+Jv9G8/f33OlP6sjgsOGT4HXgfd7D2LHXbdOY3Azdxey86/H51vdbAsYF4w43GSMgZit8KqMyCiuiLoknjCJvHE0S5Aq/BWf8Pf/77wvxr+Px2WPZGM+J0frSWNd03Tbuse/SAeMEqgs7E5kW4hfCHycc5CMxJTYnmSiYI5UfBxQREHj/4v1a7ILp/tx+2G3Rds6my6TNjNJn2NrkSuwn+V0EUA0qGBQgDCFCK3Mjbi4fJcQsjiNQJgQcAxmWDzYDHwAs7H7yvd7I6G/XNNycziTOcskgzq7Qh90n5zn0dQgMEp8pXy1oQY08/kppQJdFHDp0NtonVh4zCHf4SuAhzFK8WKkPp3+YSqRXnKqzPrdO1FjmUgBsHa0usUxsVaVqxGtgc9Fv2WVDYHBGqztdGi8IQeaT0ia0E55Pj3OBAIB4gLSKNI/8rjW9DuRC+1sgPD0HV2twfHn6f/9/hn0lcJlmt0lWM3YQ0fPa0sW7hadel6+XpIzjn46dV7xpwZ/ike0ZBfgZ5h/2On8vVkSgLOU1ShscHOgHBgQ/+kv1LPeB82EBGP9CFIwQwCWKGSEs4RYJIyEMNQwH9Vjqy9P8wlK3rqQxrruffsBpulPtGO4uJykpQ1rcV4h0YW5tbVNnpENbQmMElAnKvznPlY1OpQCAcJi3lPerKctd13UO0wmKSJ4zYm6SSpV0J0iFVpgukCBbDK3q8O9Ex3XfPryx3CHF3uXf22r0H/UrAOgBawQSBLwCxQOa/qH+HPps+5344QAd/M0M8AJRG08LRCWREf8jXxH9FhoNNAQhCcbyaATV6Lf95ufq9m3txPDZ9vHr+Pxw60T5FO8Q7xLysuOQ9YjecgBF6qUQDwU9HR8krSOqQPYkQVBhHzhJEhFIKd76wPeV4oTIq9AJrMnKAqne1I+/hu1+5YgIGw3KGp8pXyPkMh8iQyqCFeUTMQFi+qvtEuxd5nLuyvKiASkMAhv7IkkqZSttKFkfJhETATfsxNydyyXASbdGtWy4b8Ov1tXp+gVBG+kyYUWLTGBavUhmU5AtTDHVBv/+A+ApzhbHwq4/xFqrVNg6xoj8yPOCHyAfcy8lOLInZDnjD1MlYfQyBQvjhOfm4NvZGez34XYEPPpGHJYUFSFZJAMSVSS29vcSZtyg87XQYtV813zJSfOY04Icwe1LPpIQ1krnLsU7/zk/FNgun+RnFFq93/ParAza67n40UTbL9uRAg3vryRdBhk4yxZINvMZ/yNvE9QPQggsAQ/8/vgS9az4X/YW+/v7FvlDAY/wVQRL5WQEEeCsAXjjzP1e7Hf7tPl+/RcKVwONHHEHfislBUgsaf69HrD3ow3y8o8AAfJt9Y/3n+nwAtLhgQ+y4ZIY8+iOGhj0fRL/+5UBLf8p754AxeKgApHfcQgp5hgRRfXcGbcHbR+SFe4b7RjhEEkSvwCYBzXsbP4M3ZX5hNfN+t7YZADg5NEDHvm2AeAM5f0SHf/6MCfj+OonqvmEHtf8/Q3L/lr7PAA76g4Cyd5mATbdT//a5rf/V/jiArIJvQfbFHQMfRaLDCgPEQYlBgD9vP4+9cf3je5R89rpLPKJ6/zzVPTT9wAAL/0sDEcGMheaD9YboBOIFigSogpDCiv+gP949cL4L/Ne9Wv2qfSs+iD4H/1M/G39W/0h+3/8Hfj8/PX3T/77+hT/wf84AWUFDwXsCaIJvAuKDHcLjwglCYr/xgOT+b796/kB/Er+mf4yAvv/0ANm/KkD1/WW/17ymffm9APwZPjW64r5W+2l/bj3hQfNCd4RRRsyGKkk2xmtJPEUyBrKB6IHe/ex75jr7dms5M/PluEr1mnmyujM88P/tAIgEkQMsBv4Dtod5A0QGHgLGg3qByIEZAbY/voJS/12D07/BBIY/1IOVfklASDxsetc6prWuukpzVjxaNWb/fLroQpYCOgTyyH/FA8wkxDAL7wKgiNGA0UPqvuG+A/26eY+9CHfkvlG4sACIe/vB6f+qAfrB3kChQnb+MIGXe8uAffpQvu46x/5FveN/NAHLQRZFxUM/iB5D3geyAv/D2UCdf6c+HXuI/Mc4nLyp+C39o7tn/8WAq4IghNxDZ0aHAzmFlwEZAvF+SL70vFH6wrviOJc8UjkvPfY8IgBNwZTDRIcWhZhJ5gYNiSwE2MVIgkxAPP8Feyz8uDe7+ru2t/nzeGf6xrxoPPFAbH8sA4pBTkVwguvEwoQQw3WEGsHHw0eA34Gbf+Q/679cPqD/p/3XP/j9VD+wfVm/Rb5Kf6B/+X+YAdr/ywOEgDiD//95gpU+I8BWvIm9uLukep88Dnkv/lk6VoJovm7GUINRSRnG0okGR9OGF8ZFwPODQntFP543ovs+dj03jzcBdse6Y3jUvxN924P5g7jG84fChw4JPcRph1GBqIQ7/3fAGH7U/GmANvm2gi75iYM7+/RCID8xv8sCPLx6A6v5DoN4N67BL3iDfl/7sXuTP6t6wgNffCQF3D7jB3pC3ceCRuzGfcgtRD8HQEGwhJo+xAAtPHs7Pfoht924hjZW+EB2j3n1OOJ8q/3kwBYDxQOACD8FyAoER5SK2EgiCavGzEXOA6+AfL7ZevL6lXY+994zrTe7dKw5cvjBPIn+BUBbgk8Ds0WxxWvHTgXeRqlEoARsArGCmkDgAe//D0FGfacA33xQwE58O/7YvPi8576meurAlTn2gmp6VUOf/B2DD76YQVABtb8xA+59EkTVvESE231ExEM/UANXASNCOAJvAP1C4P+dAo1+BEGSvAAAGPoZ/py5CP2TOd69FnxBvcNAQP7nxGg/Q0dAgFjIO4FVBsNCdkPNAnAAu8IM/hmCaXyowhI8xIFD/ee/mX50fYF+Q3ytfUl8nHwbvOp7Un0S/H49Rb7xPdHB2n6axI7AK8aYQhZHBcRdRU/GWIKbB78/kYdpvWrE7ny1gMY9aHy2fbd4pn2pNiq9drYr/UQ4iL57PCI/4oE+galF3MOjiFMEh0flQ6KFCkEgwdD9yn6zuy172joRu586zn1wPZV/jwIowa/GGMLtyGgCvkhxgaSGO3/OwVU9gbwXfCn4svwh90T9PHeIPnw6EsAlvkzCKoJBg9WE0ASDRXsDwIR5wdKClX8pwKY8sb7/e6/9z7xzPdg9637gv/8AYYIiQiHEAcM1xI9CsoNoQQBBdD94vqN97vx1/N+7e7y7u04813xBfad+T39mwWjBOgOTweWEdIHkw86CYkL0ghEBRwFFvxuAK7x8/z76sj7lO3O+zj4k/vHA6/8DA3z/w4TXQSJEvwIpgtNCh8CrAV3+IH9K/HT9HXusu5F8TXuTvlc83ICKP3/B7QIFQlpEPwF+BJKALwRgvuvC775BgKk/M33IAQ47xYLWuxfDdfxqAsK/R4HYwgeAHwNs/cnCozwXAPU7Y/9l++F+En0nPSl+yX1lgTB/NYNGgr6FTwXvRiNG/4SGRJCBnD/R/Y47cboreFb4xLf9uba5cLwD/TE/J8FJQjtFFgSaRziGK8a9RcBEyMRQgmCCCoAw/71+Jn0LPM07Y/vmOsL8IrwHPP2+Bj2QQBa+vIEYAEeB1gJqwbUDxYGRRNZBwsTZwdODaADqv/5/UTuV/ge4obznuBr8mLrgvca/4IAkxLwCDIfAA8hIx8SphzRDy4MIwfA9lL84uQS9KXeH+9H5YftKfOb8MAA8/fhCKcB8gvUC8wLzhJLCPsS9QM6DYcCbQR6A1P60QMO8TMB1erw+z3pXPax7e3xq/c58d0ECfcEE8cBlR4ZDssiixd/HCoY6Az1D4z6LgS868j3L+Ke7ZLfNenM5aPqDPIT8Iz/mPcBC3v/ahHFB1ESHRBMEBYWqwyyF6AHYBShAioML/4EAA35LfI69CXmVPJ534Py79+u8lzoHfUJ+WX9PQ7yCd8fOBQwJ7QWeSLAEcsUAAkVBE//WvVw93jrrPNJ6C/0R+sf+LbxY/3h+MIAiP7PAGMCi/4MBir8iQmZ+2ULgvzxCqT9LwgV//ACvgEd+xIGMvNUCp3vIQyr8jQM4fyhCwEMMwmeGI0Esxyn/SIXUfQUCIfrw/MZ57fhrOfP1jXsUNeK85bliv0m/F8KYxIRF4Mi3B8GKXIjvCQ3IB0XXxXBBFIFM/QS8pTpR99d5gfV+uoJ15P0KuLZ/Vz0egOHCmoFHh0XBfMmHQNQJqf/txkF/W0E9f3R73AB4+PHBODiuQcs65QJZ/nUB/AHCwObEPf9bhGj+Q4MTfdSAmL3uvfK+Prx9Pyt9MoDvf1ZCNQGKAjvCvkDJQm2/EsDUPZ3/Vr05voO9t36FPs6/DkD2v5UC8EBGBFcBKkTEwXgEK0Bdgi0/LX9PPpo8/j5Vetm+nfopfs77MH+qfQhBCX/XAmtCOsLZQ5ECzkQhgaSDrb+GwmW994BmvKx+8DvMPgJ8ef4j/hP/e8FcwJkFN8FXBzVBV4Z/QFEDB788Pnv9f3omvEq3mTys9wE+QHnggK/+j8L9RApEfghBxMWJyQPLh4pBTMMhfj5+HLuEesk61DmTvCb6m37GvVpB54BeRBYC/4TQQ8OEKIM5gUfBCr5ZfnS7W7ygeg08mrr0fYs9O78CAC1AtkLOAecEr0J9BKpCmsPhQp4CR8JPwNAByL/fAUj/EACu/mW/DL5MvUf+XLtUfeW6M/0wun88yfxW/bq/E78nQmSBOUTHwwmGokPihrRDX0UewmHCooFP/9qAkL1Zf/F7i39Q+s3/IDrfvtj8Sf69vlE98MA5PLeBIzwEgc282YIMPpCCUIEdwkLD18JnBaeCNAZYAaFGIACjhDt/D4C6PZA8jfy1eW+797gxvGn5F35Cu97A0L8Aw1YCVATLRReExEafAy8GGgAoRAM84IEu+k/+NjnIPA17uTtnPqt728IkPNqFCv5txqr/28X9AU1DbcLZAGHD9n2PA/v8J0LFPGqBt70FwDF+Y74sPz38uH7PvAx+kPwcvov9AH9mPsQAgMEUglmCxUR/Q+nFTwQYRMDDL4KUwRC/zT7ZfTk8xLtXvEJ61r0ku4K+9/1JgKj/a0GEgTgBzsIvAYMCY4D+wc//58H2/x3CL39VQkHAOYHLwJ5AvMCi/qYAG3z4fvu7yr4XPF9+Df3KP27/7UCIwjFBZwNhAYBDoQFPAiYAn7+Cf+c9S/8F/Gv+tvygvtt+1b+yQeqAcoSwATTF7kGARSCBvgHCQRM+Mz/FOtM+6Hkf/hH5mf3MO9b90X8d/lfCXb+mhPIBEMYKQqqFbIM7g3pCjQEOQVk+qf+HvPp+U3wA/cw8V31NPSl9ZT4zfjn/en+hQMRBvYIDwsyDXgMow1zCsUJcwW8BML/CQCK+/H6b/i29v32L/WI+Ez2zPvF+fL+Dv8BAWsDWwFHBE4BkgITAjwArQJR/iID+/5MBLACCwXyBukD/QqPAHgN7fuECtv4VAJn+ZP4nvws8I8AuOy9A6/vAgVE9gkEAf7VAVIFsf8jCqX9awun+3EJ+/rNBTr8hAKJ/nUAIgHm/2QDNwDEBGQAFQVzABQEjf/DAdb87f71+ar8NvjO+xT4s/z4+gv/PwBXAegEyAHwBnQA4gVs/v8CKfyiACP7LADz/NgB5gCFBGgFfQXlCCsDfwmI/rsG3vh0AUnz6vqV8OL1r/NL9WD8FfnyB7H+YBLuA9EWlQeGEg4IhwaHBC/34P4h64T5j+fh9d/t9vXo+wP7owtJA0oWbwsmGNQPQhBdDsMBnwhK80sBvele+cbnTvI57rLuE/rn7+MGz/XhEKj+ARX9BvoSUgzcDEAO+ARUDWn9ugoW968GavJNAHDwdvhv8fLx2vRS7675tPEV/4f3BQZ5/hQOwQX2EtMLuhFUDpYLwAzeArYHEfoXATz0OvwL85n6PfUj+6L4YPw1/E39Mf/P/UIBef2+ApP7VwPD+VYEzPrvB07/jwviBfoKhQtZBj0Nf/+vCkD4BgVU81r9zPGy9ffyQvGP9q7yV/wp+d0CnQBQB/kFAwh3CFYGtQflBFgEsQXIALwIh/+GCyEBrAvYA+4HcgUrADUErfZd//Pt1vhV59fz1OW08QjsFPM4+Nz4PAbxARkS+wq/GBMQ8hgID7gTagkoC40C/wCk/AT4ivna81r6avR2/db2cADB+eoBkvvSAFH7dP3c+yr69v4T+VwCzfp3BJ3+YwWyAjIFwAUxBBIHbQJEBdz/WACg/YX7iv0M+jAAlvx0AykCSgR7CEwCrQsF//UIe/txAfX4qPjn+NTxz/qS70r9IPN4AEf7zgQNBfEIjQw6CpsOowdbCzQDbwXa/hv/HPoA+iv1p/eT8rP4rPRl/O37QQEmBpYF4A6fB6gSzAZjEIMEWAiJAQL98vyM8hb3Dew68gLrUvA18HvyCfsO+R0I0gLnESMNQhRrFYYPgBlhBxUXVv9xDVr5Lf/q9oDwevgj5tr7CeRH/h/q8P499RL+QwIo/HINhPrpEkT7fBH3/9QKBgePAo4MrvxiDuL6Agxi/CQFRP9Y+2kBNfJgAZntn/7O70n6jvdh90cB4/fQCZf7Vg7wAVgNTQmLCOUN5AJIDLr9ggRs+Wf6Vvfe8mv41vDq+o30HP1Z/J7/4wVnAjEOoAR2EZEGHQ54BzUGngU//D0B8PLF+23uOve98Pn16/ct+IIAkvw7B2wCHwp4Bx4JBQmGBaMHoAHTBC//4AB//jz9vP+v+/sBDfzQAo79hQEY//L+x/6++3j8afmE+sn4J/st+Un/TfsGBov/RQzRA8QOSwdSDPYJNQXCCfr6NwZo8coBeOy7/YbtdPoS9Bz5mv5S+XcJ5/kJECL7zQ/u/LsJZP6FASsAP/v3Ajf5mgVy+5wHIQBaCdIErQltB4IHhgbvAicCaPx7+w/2V/Ss8p3w4/KL8zH2/Ppy+2MC0gC4B6oFmwpBCRUL/QlXCT8I/gRqBaT+rAE6+eD92vdl+5/6X/qQ/rH63wAz/A8BeP4qAOUAUP9dAqf+ZwIj/oIBGv/p/yYCsf6zBWL/EwhKAYAHaALhAtQBZPz3/wr3Pf419Av+QPWc/zL6yQGjAMQCtwbjATQLoP+/Czr8Zgcv+cUAPfkU+538SvfdAPz11AO9+C8FN/9aBisGuwdfCjQHaQqBA2QG5f1O/4L4Lfeg9cHxcPZr8ur52vgk/sMB2QHXCdgEkg4hByEOcwdlCIAE1/8b/wP4APqp80D4cvT9+gT6jABnAZcG5gYjCxwI/wsRBT0IggBLAVv9bPkh/FHyLvzB7br9Ne7IAI/0OgNE/vcC8QeuAEwPO/6REiX9CxE7/iIL+/8QArAAHPlUAR/0TwJx9GACzPi+AQ3+8wAUAYD/jAEH/qQAjP14/mj9bPvh/ML53fxc/Hv+fgOOAQ8LHgVcDncHGAy5Bn8FJAP+/Jz+6PVJ+q3yfvfK87v3lPji+rr/sf/+Bi4EUguRBo8K6QY/BT8Fof51AXP6sv29+Qn8Dvuv/LT9cP84AYYCjQNsAx8D7AH//93+gPse+3L4mfgg+e/4jf1B/HkEGAFDCw0Fvg4cB5QNVAfMBzcFmP5AASr1c/1v7n/7POzq+2XwYP4j+lMCEQUnBioNzwYDERwDmRBH/TUMy/fLBCj04fy88xn3OfdY9BL+yfQfBhX4iwyR/JEPaABFDrUCoghRA78AzwJW+Q8CEfTQAU/yVgK/9NACWfqMAgIBCgKJBmcBKQn4/yQI6/1wBCf8DQBe+0T82Psh+mb9CftK/5H+gACOAtYAZQVCAeIFYAKtA9MD3P+EBI/7VAOf+CcBfvnk/7X9PP+wAhX+uga0/O4HTfu1BFL6cf44+4z4LP4e9okBK/j1A0/9VAXCAxUGXQn1BT4LYwS7CM0BngP7/pL9ePzb+Pv6y/eO+uL5avr8/Iz61v+c+1wB2P28AOQAtP7GAyn9PgWw/QwFfQBRBDsE1gMpByUDVwguAooHfgHeBOAA3QAJAHT8CP/u+DH9Z/ce+mr39vb490T11/k29tP9dPqjAkUB9AaaCAYK/w1LCowPUweqDB4DZwZG/2//ePuR+ub3hPiH9iz4vPh++Ib94/iCAjP5eQXq+dkFx/spBSn/jgSnA3cDtQiOAcANGP9xEDz8mA3j+WkF4fis+7X4JfRf+ezw6fsg8noAbfbaBUj8IArIAacLEwU0Cr0FCwYUBI7/4gDI+IL+h/Q5/zX07wII+HsHvP71CVoF2whwCc4EFwry/mkHq/iBAg705PxJ8vf3kPOf9UP4U/eF/zD8NwZ8AXMJSwUdCW4H4ga7B/YD1AU7AaICHAA3/+wAkfunAWn4RwB29yr9Zvka+l/9S/gZAkD4pgYs+r0JsP1lCTgCMAX8Bij/NArM+e0J7/bpBYb3MABc++T7KAGW+o0GMftACR38UAj8/LwDJv7s/Kr/KPefAGf1cQCN+DsAzP7vAFgELALRBnwDhwZXBC0EJQSPAPYCc/3fALL8NP6w/g38nAHy+jkDpfrfAkT7jACi/Jf84f2t+Lz+//be/xr55gHR/ocEhAX3Bk0KugjtC0QJLAqpB5cFmAOW/wn+FPqY+Pn2jPTW9sDyvfjg83r7fvfq/Tz8Nf9VAZz/QwZMAAMKNwIEDPAE+wtQB6UJ9wjOBXwJegG+Bx39LgOR+ab8Z/eT9kv2kfNS9sTzvPdU9gn6i/v7/DsC9QBbB+0FhAnICv4I4Q1MBgkOtgLYCpf/8ARS/S7+Avwc+Kb7D/Ph+7XvsPxt70n+JPNIAL36FwIHBCwDpQveAu0PdAGhENn/lA0O/s4HuPwfAdX9jPpwAVf1NgU280AHf/SOBkb45wJw/WL9eAIH+PMFWfVeB+z2yAbP+80E+wGNAr8HegDhCmz+IQnS/JECMvxI+nH8lvRK/Sr0Yv7I+KH/jgBhARQJLQM4D9QD9w8UA7AKkgF6Af3/gveO/mLwN/3n7rz8PvMG/l37OwAxBNABbwpNAlQM6QHaCQ0B4gPk/wv9Xv7A+PT8efgF/Jb7xft9AGv9PQVoASIIfQXxB1kHsQT9BhQAXwXm++8CXvnO/xT5f/wG+tT56Ppf+AT8SPjX/U75TQBg+2wDHP+oBk0EFAlFCTIKpgxNCUoNyQWlCXEACwLZ+nP5UPby8gL0N/DA9NbxV/h19zD9l/8uAWwHcAMUDHIEdAzHBEEJ9AQiBJ8FFf/UBp37iwec+hsGQfz+AS7/BP0ZAQX56gAL9mv/8/T9/VX3M/3v+/r8SgCm/QoElf89BzMC6ghlBDQISQU1BYMEWwGCAgP+BQAz+9f9Qvno/C35I/3d+iz9qv2j/OUA5vyGA+P+AwW4AQgFwwN5AwoEegGrAub/uQBc/lT/bf3F/jL+6v74/8b/WgEuAeYBlwKiATsDZgBGAkX+g/9H/PD7zfth+Sn9lfmM/8L86AE6AZQDDgVpBDUHIAQpBzUCvgTS/pQAUvvM+4X5jfeq+s71rP6V+IoD3P54BjQFfgZCCYEEsAkQATUGP/0uAVT7Z/0R/Ar8Tv42/QgBZP8rA3sAZwMuAHUB6P5A/jD9bfsr/Hr6KvzQ+zz91f71/wgCZAMLBJcFwATFBU4EGQTBArAB3wCx/07/Bv40/vP87/01/S7+Ff4s/pL+Av7a/tH9Yf/e/U8Ab/+EAeMCwAKYBsUDTAjEA44G8wElAsH+Vf1f+yb5Tfn69ez5XfUk/Vz4hAFG/s8FJwUFCSUKwgklCxEHXAiQAUYDBvt3/Xr1v/jk8sb2lPRU+Pb5E/3QAH8DEAfaCEwLgwpEDB8IfgkkA1QERP0f/1j4ifut9cL5afUp+cP3dvmT/O36JAJL/aoGoP8qCWMBPQmKAlcHKgMpBMcDUADsBA/96gVj+1IFF/vIAq37Zv/l/F78lv4u+jQAOPkXAfz5sQFu/JIC1P/9Au4CYgIrBBoBPQNG/5UBPf1NAOz7ov/h+93/Dv2sAPT+QgENATIBTQMCAFgFv/35BcH7TwSZ+/8AD/6//VMCAfwVBi78swet/QIHd/8yBKgAy/+XANf6Z///9kv+LfYU/nv4d/5d/IP/xwCYAZIE7gMvBgQFigVBBM4DXwI0AicAkgEO/rYBEP3wAcX90wEB/60AQf8V/mL++vpR/d747/y4+Db9tfr3/XD+qv/EAjgCywWRBGgG1AUqBZwFAQMoBKwAWAIo/6MA9v4H/4z/mP3Z/z78Lv/P+uD9qPni/MT53fwH/Pb95v/2/4oDSALMBQkEtQZtBE8GPwNWBKUAKQE4/en9d/pM++H5sfnd+xD6pf/Y/GoD"
	Static 2="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"
	Static 3="VwB5ABAAcwC8/0YAcf/5/0H/sf9F/4z/hv+S//D/vv9eAPj/sQAzANEAWwCyAFYAWAAnAOb/5/99/63/Qf+X/0r/qf+M/83/4/8BADIAOgBmAFoAdgBaAGIAQwAwACIA9f8CAMD/4P+i/8P/o/+5/7n/v//h/8T/GwDM/00A3v9jAPr/VgAUACcANgDr/10At/9kAI//RgCE/xkAl//h/8T/tP8SAK3/YAC9/4UAzP97ANj/SgDo/wkAAQDU/xkAr/81AKD/UwCz/2YA3f9nAAYATwAZABAAFwC1/wwAYP/y/zL/2v9B/+X/hf8CAO7/GABfACYArAAeAL0AAQCYAOX/UwDR////yv+r/9j/fP/4/4//HADE/y8A+P8uAB0AGAAvAOr/KgC7/wkArf/R/7n/q//U/6r/+//A/yUA9P9HADQAWABYAEkAbgAiAGoA+v8+ANH/DQCy/97/qf+w/7j/pv/X/7T////B/yUA1v88AO3/PAAAAB4ACgD2/wYA2f8DAMf/CwDD/xIA1f8WAPn/HAAeAB4AMgARADEA+v8iAOb/DgDO//T/tv/T/77/uv/f/7b/+P/K/xQA7/8zABoAPAA+ADUARwAiACsA9P/1/77/yf+d/7X/nf+x/7f/wv/g/+X/EgATAEMARwBgAF4AXgBLAD4AMAAOABkA4v/0/8H/0v+z/8L/xf+1/9z/sf/q/7//AADY/xUA9f8WABQAEAAmAAAAIQDj/xIAz/8GANT//v/p//P/BgDs/yAA8f8xAP3/NgAIACcAFAAJACEA8v8aAOX//P/d/9n/4P+//9//tf/W/8D/1v/Q/9v/7f/c/xoA7P86AAoATAApAFQARwA/AFgAEwBJAOz/HADO/+b/tv+2/6z/m/+3/6D/0//C//P/8f8OABYAIwAoADIAJAA1ABIAKQD7/xEA6v/y/+L/2f/u/8//CgDW/x4A4P8jAPD/HgACAAcAEQDm/xoAz/8ZAMb/DADK//j/2//m/+3/3v8DAOT/HAD2/x4ACgANABYACgAYAA4AFwASABQAFwAFABQA8P8MAN3/+v/T/9j/1v+7/93/sf/s/7P/CgDG/ygA7/84ACAANwBGACsAVQAXAEsA9/8wAND/BgC6/97/tf/F/8D/u//f/8b/AQDe/xoA8/8tAAgAMwAbADAAHQAnABQAEgAHAPz/+//v//b/6P/x/+f/6f/i/+3/1//5/8///v/N/wAA1v8CAO3//v8KAPn/JgD6/0IA//9NAAgARAAWACsAHwAFAB4A4v8TAMn/AQC7/+v/vv/T/9L/xP/p/8f/AADY/xUA8v8hAA0AJQAlACEANAAVADkACwAxAAYAGQABAPX/+v/Y/+//zP/m/8//5f/Z/+b/5f/o//P/7f8BAPj/CwAIAA8AFgAPAB8ADgAjAA0AHwAOABAACAACAAUA9f8GAOX//v/f//T/4f/s/+T/5f/w/+X/AgDs/wwA9P8SAAMAFgAYABQAIgAQABsACwANAAQA///8//L/9P/o/+//4//t/+j/6v/w/+7/+//4/wUA//8LAAQADgALAA8AEAAOABEACwAOAAUACAD7//7/8v/0/+7/7//s/+//7P/z//D//P/9/wUADAAIABIADAATAA4AEgAKAAkAAwD+//z/9P/2/+7/9f/u//X/8v/3//r//f8DAAMACAAGAAYACAADAAkAAgAIAAIABwAFAAMACQD+/wgA+f8EAPP//P/v/+//7//k//P/5P/4/+v/AgD1/w4ABAAWABYAGQAfABUAHwAMABYAAAAHAPX/+f/u/+//6//q/+3/7P/y//H/+//5/wQAAQALAAYADwAIAA0ABgAHAAQAAAABAPz//v/8//3//////wIAAgAGAAQACAAFAAYABQABAAMA+v8AAPT//P/x//f/8//0//n/9f8AAPn/BgD+/woAAgAMAAYACwAIAAcACAACAAcA/v8FAPz/AQD7//7/+//8//z/+//9//z////9/wAA/v8CAP//AwABAAMAAgADAAIAAwABAAEA//8AAP7//v/+//7////+//////8AAAAAAQABAAIAAQACAAEAAQAAAAAAAAAAAAAAAAA="
	
	If (!HasData)
		Return -1
	
	If (CD){
		VarSetCapacity(TD,70024)
		
		Loop,% 3
			TD .= %A_Index%, %A_Index% := ""
		
		VarSetCapacity(Base64Decode,StrLen(Hex_Mcode)//2)
		Loop % StrLen(Hex_Mcode)//2
			NumPut("0x" . SubStr(Hex_Mcode,2*A_Index-1,2),Base64Decode,A_Index-1,"Char")
		
		VarSetCapacity(Out_Data,25556,0)
		, DllCall(&Base64Decode,A_IsUnicode ? "AStr" : "Str",TD,"UInt",&Out_Data,A_IsUnicode ? "AStr" : "Str",CD,"CDECL UINT")
		, Base64Decode := ""
		, TD := ""
		, CD := ""
	}
	
	IfExist,%Filename%
		FileDelete,%Filename%
	
	h := DllCall("CreateFile","str",Filename,"Uint",0x40000000,"Uint",0,"UInt",0,"UInt",4,"Uint",0,"UInt",0)
	DllCall("SetFilePointerEx","Uint",h,"Int64",0,"UInt *",p,"Int",0)
	DllCall("WriteFile","UInt",h,"UInt",&Out_Data,"UInt",25556,"UInt",0,"UInt",0)
	DllCall("CloseHandle", "Uint", h)
	
	If (DumpData)
		VarSetCapacity(Out_Data,25556,0)
		, VarSetCapacity(Out_Data,0)
		, HasData := 0
}

Extract_TVreadySound(Filename,DumpData = 0)
{
	Static HasData = 1, Base64Decode, Out_Data, Hex_Mcode="558bec518365fc00568b75088a1684d20f86ac000000578b7d0c5333db33c084d2764d32c984c975318aca80e92b4680f94f770c0fb6ca8b55108a4c11d5eb02b1240fb6d180ea3d80f9240f94c1fec923ca8a1684d277cd84c9760943fec9884c0508eb05c6440508004083f8047caf83fb027c4b8a45098a4d08c0e102c0e8040ac18a4d0a88074783fb027e108a55098ac1c0e802c0e2040ac288074783fb037e09c0e1060a4d0b880f478b45fc8a1684d28d4418ff8945fc0f875bffffff5b5f8b45fc5ec9c3"
	Static CD = "|$$$}rstuvwxyz{$$$$$$$>?@ABCDEFGHIJKLMNOPQRSTUVW$$$$$$XYZ[\]^_``abcdefghijklmnopq"
	Static 1="UklGRuTVAABXQVZFYmV4dFoDAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAQWFyb24gQmV3emEAAAAAAAAAAAAAAAAAAAAAAAAAAABVUyAgIDE4LjAuMi4yNDIAADEwNTc0NjgzMzcyNDMwADIwMTEtMDktMTMxMDo1Nzo0NjdWAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAEE9UENNLEY9NDQxMDAsVz0xNixNPXN0ZXJlbyxUPVNPTkFSIFgxIFByb2R1Y2VyIFgxYgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABmbXQgEgAAAAEAAgBErAAAELECAAQAEAAAAEpVTktoDAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA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