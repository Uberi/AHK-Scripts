#SingleInstance Force
SetBatchLines, -1 
initialstoryid = 
Chapters = 
Alternate = Not Specified


Initialize:
Gui, Add, Text, CGreen, Fanfiction.net Downloader By Chrononyx
Gui, Add, Text,,Enter the URL of the story below. It should begin with http:// and end with the story name.
Gui, Add, Edit, w560 h20 vinitialstoryid,
Gui, Add, Text,,Enter the total number of chapters you wish to download below.
Gui, Add, Edit, vChapters Number,
Gui, Add, Button, Default gStart, Download  
Gui, Add, Checkbox,Left gAdvanced,Advanced Options [Data entered will be ERASED!] 
Gui, Show, Autosize, Fanfiction Downloader by Chrononyx - V1.0
Pause, On

Advanced:
Gui, Destroy
Gui, Add, Text, x26 y10 w570 h20 CGreen, Fanfiction Downloader - Advanced Options - By Chrononyx
Gui, Add, Text, x26 y40 w570 h20 , Enter URL of first chapter of story below.
Gui, Add, Edit, x26 y60 w570 h20 vinitialstoryid , 
Gui, Add, Edit, x26 y120 w80 h20 Number vChapters Limit3, 
Gui, Add, Text, x26 y100 w570 h20 , Enter the number of chapters you wish to download below
Gui, Add, GroupBox, x26 y160 w570 h210 , Advanced Options [Optional]
Gui, Add, Combobox, x36 y200 w550 vDownlocation,%A_Desktop%||%A_Desktop%\Fanfiction|%A_ProgramFiles%\Fanfiction 
Gui, Add, Text, x36 y180 w550 h20 , Choose from the download locations listed below or enter your own filepath.
Gui, Add, Edit, x36 y320 w550 h20 vAlternate , 
Gui, Add, Text, x36 y300 w550 h20 , Enter an alternate name for the story below (Optional)
Gui, Add, Button, x26 y380 w570 h30 Default gAdvanceddownload,Proceed to Advanced Download
Gui, Add, Button, x496 y420 w100 h20 gExiter , Exit
Gui, Show, Autosize, Fanfiction Downloader - Advanced Options v1.0
Pause, On

Start:
Gui, Submit, NoHide
Sleep 20
say = %Chapters%
Gui, Destroy
If initialstoryid = 
{
Msgbox, 262160, Error 01, You did not enter the URL for the story you want to download.
Reload
}
IfNotInString, initialstoryid, fanfiction
{
Msgbox, 262160, Error 02, You did not enter a valid fanfiction.net story URL.
Reload
}
If Chapters = 
{
Msgbox, 262160, Error 03, You did not enter the number of chapters you wish to download.
Reload
}
StringRight, LastChar, initialstoryid, 1
If LastChar = /
{
Msgbox, 262160, Error 04, The URL you entered does not end with the story name.`nExample - http://www.fanfiction.net/s/4338060/1/This_is_the_title
Reload
}


Getstoryid:
StringMid, checknumber, initialstoryid, 29, 7
StringGetPos, foundnumber, checknumber, /
If ErrorLevel = 1
{
Digits = seven
}
else
{
Digits = six
}


If Digits = seven
{
addressbar = %initialstoryid%
next=2
StringTrimLeft, storyname, addressbar, 38
Sleep 200
FileCreateDir, %A_Desktop%\%storyname%
Sleep 200
UrlDownloadToFile, %addressbar%, %A_Desktop%\%storyname%\%storyname%_Ch1.html
actualrep = %Chapters%
outofthis = %actualrep%
outofthis++ 
Loop, %actualrep%
{
SplashTextOn, 600,200,Progress, Now Copying Chapter %next% out of %outofthis% From http://www.fanfiction.net/s/%storyid%/%newchapterno%
StringTrimLeft, chapterno, addressbar, 36
StringReplace, newchapterno, chapterno, 1, %next%
StringMid, storyid, addressbar, 29, 7
Sleep 200 
UrlDownloadToFile, http://www.fanfiction.net/s/%storyid%/%newchapterno%, %A_Desktop%\%storyname%\%storyname%_Ch%next%.html
Sleep 300
EnvAdd, next, 1
SplashTextOff
}
SplashTextOff
Chapters++
Sleep 2000
Gui, Destroy
Msgbox, Download of all %say% chapters of %storyname% is now complete.
FileAppend,
(
%storyname%
%next%
%addressbar%
%storyid%

Download for %A_Username% on %A_ComputerName% of %say% chapters of %storyname% has successfully completed.
Thank you for using the Fanfiction Download program.
More useful information and/or programs can be found at
http://www.professory91.co.nr

Please do not delete or this file as programs will look 
at the first four lines of this file to identify the story
and manipulate the files needed. Thank you.

Sincerely,

Chrononyx (Program Creator) 
), %A_Desktop%\%storyname%\readme.txt
Gosub, End
}

If Digits = six
{
addressbar = %initialstoryid%
next=2
Sleep 200
StringTrimLeft, storyname, addressbar, 37
Sleep 200
FileCreateDir, %A_Desktop%\%storyname%
Sleep 200
UrlDownloadToFile, %addressbar%, %A_Desktop%\%storyname%\%storyname%_Ch1.html
Chapters--
actualrep = %Chapters%
outofthis = %actualrep%
outofthis++ 
Loop, %actualrep%
{
SplashTextOn, 600,200,Progress, Now Copying Chapter %next% out of %outofthis% From http://www.fanfiction.net/s/%storyid%/%newchapterno%
StringTrimLeft, chapterno, addressbar, 35
StringReplace, newchapterno, chapterno, 1, %next%
StringMid, storyid, addressbar, 29, 6
Sleep 200 
UrlDownloadToFile, http://www.fanfiction.net/s/%storyid%/%newchapterno%, %A_Desktop%\%storyname%\%storyname%_Ch%next%.html
Sleep 300
EnvAdd, next, 1
SplashTextOff
}
Chapters++
SplashTextOff
Gui, Destroy
Msgbox, Download of all %say% chapters of %storyname% is now complete.
FileAppend,
(
%storyname%
%Chapters%
%addressbar%
%storyid%

Download for %A_Username% on %A_ComputerName% of %say% chapters of %storyname% has successfully completed.
Thank you for using the Fanfiction Download program.
More useful information and/or programs can be found at
http://www.professory91.co.nr

Please do not delete or this file as programs will look 
at the first four lines of this file to identify the story
and manipulate the files needed. Thank you.

Sincerely,

Yasin (Program Creator) 
),%A_Desktop%\%storyname%\readme.txt
Gosub, End
}


End:
Sleep 100
SetBatchLines, -1  
FolderSize = 0
Loop, %A_Desktop%\%storyname%\*.*, , 1
    FolderSize += %A_LoopFileSize%
Sleep 100
Gui, Destroy
Gui, Color, Black
Gui -Resize -MaximizeBox
Gui, Add, Text, CRed, URL:%addressbar%`nStory: %storyname%`nStory ID: %storyid%`nNumber of Chapters Downloaded: %say%`nAlternate Name: %Alternate%
Gui, Add, Text, CLime, Story has been successfully downloaded to:`n%A_Desktop%\%storyname% [Your Desktop].
Gui, Add, Text, CAqua, Story Size - %FolderSize% Bytes
Gui, Add, Button, Default gExiter, Close Program
Gui, Add, Button, gReloader, Download Another Story
Gui, Show, Autosize, Download Complete
Pause, On

Exiter:
ExitApp

Reloader:
Reload

Advanceddownload:
Msgbox, 262160, This feature is not yet available. 
Gosub, Reloader



