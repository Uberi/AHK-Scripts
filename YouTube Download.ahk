#NoEnv

LastURL := "http://www.youtube.com/watch?v=A6s49OKp6aE"

Gui, Color, White
Gui, Font, s32 cCCCCCC, Arial
Gui, Add, Text, x10 y10 w600 h50 vLabel Center, YouTube Downloader
Gui, Font, s24 cBlack
Gui, Add, Edit, x10 y60 w600 h50 vURL gProcessURL, %LastURL%
Gui, Font, s10 c888888
Gui, Add, Progress, x0 y110 w620 h40 vDownloaded Range0-100 BackgroundWhite CEEDDDD, 0
Gui, Add, Text, x10 y120 w600 h20 vStatus BackgroundTrans Center

Gui, Add, Progress, x0 y150 w620 h1 vAccentBar Background885555, 0
Gui, Font, s16 c777777
Gui, Add, Text, x10 y160 w600 h25 vTitle BackgroundTrans
Gui, Add, Picture, x10 y200 w200 h160 vPreview

Gui, Font, s10
Gui, Add, Text, x230 y200 w140 h25 vLength BackgroundTrans
Gui, Add, Text, x230 y230 w140 h25 vRating BackgroundTrans
Gui, Add, Text, x390 y200 w220 h25 vAuthor BackgroundTrans

Gui, Font, s16
Gui, Add, DropDownList, x390 y280 w220 r15 vFormats AltSubmit
Gui, Add, Button, x390 y320 w220 h40 vDownload gDownload Default, DOWNLOAD

Gui, Show, w620 h380, YouTube Download

Gosub, ProcessURL
Return

GuiEscape:
GuiClose:
ExitApp

ProcessURL:
Thread, Interrupt, -1

;only update if URL changed
OldURL := URL
GuiControlGet, URL,, URL
If (URL = OldURL)
    Return

SetTimer, ShowProgress, Off
GuiControl,, Downloaded, 0

If !RegExMatch(URL,"iS)^[^/]*/*[^/]*\byoutube.com[^\?]*\?.*v=\K\w+",VideoID)
{
    GuiControl,, Status, Invalid YouTube URL
    Return
}

;remove extraneous URL elements
URL := RegExReplace(Trim(URL),"iS)^(?:https?://)?(?:www\.)?")
GuiControl,, URL, %URL%

GuiControl,, Status, Retrieving video information

;obtain video information
InfoURL := "http://www.youtube.com/get_video_info?&video_id=" . VideoID . "&el=detailpage&ps=default&eurl=&gl=US&hl=en"
try
{
    WebRequest := ComObjCreate("WinHttp.WinHttpRequest.5.1")
    WebRequest.Open("GET",InfoURL)
    WebRequest.Send()
    Info := WebRequest.ResponseText
    WebRequest := ""
}
catch
{
    GuiControl,, Status, Could not retrieve video information...
    Return
}

GuiControl,, Status, Parsing video information

;display the video title
try GuiControl,, Title, % GetParameter(Info,"title")
catch
    GuiControl,, Title, <No title available>

;display video preview
try
{
    URLDownloadToFile, % GetParameter(Info,"thumbnail_url"), %A_Temp%\thumbnail_image
    GuiControl,, Preview, %A_Temp%\thumbnail_image
}
catch
    GuiControl,, Preview, *Icon50 shell32.dll ;blank placeholder image

;display length
try
{
    Seconds := GetParameter(Info,"length_seconds")
    Hours := Seconds // 3600, Seconds -= Hours * 3600
    Minutes := Seconds // 60, Seconds -= Minutes * 60
    If Hours > 0
        Length := Hours . ":" . SubStr("0" . Minutes,-1) . ":" . SubStr("0" . Seconds,-1)
    Else
        Length := Minutes . ":" . SubStr("0" . Seconds,-1)
    GuiControl,, Length, Length: %Length%
}
catch
    GuiControl,, Length, Unknown length

;display rating
try
{
    Rating := Round(GetParameter(Info,"avg_rating"),1)
    GuiControl,, Rating, Rating: %Rating%/5
}
catch
    GuiControl,, Rating, Unknown rating

;display author
try
{
    Author := GetParameter(Info,"author")
    GuiControl,, Author, Author: %Author%
}
catch
    GuiControl,, Author, Unknown author

;obtain video
try
{
    FormatList := GetParameter(Info,"url_encoded_fmt_stream_map")
    AvailableFormats := ""
    FormatLocations := []
    FormatTypes := []
    Loop, Parse, FormatList, `,
    {
        RegExMatch(GetParameter(A_LoopField,"type"),"S)/(?:x-)?\K[\w-]+",Type)
        AvailableFormats .= "|" . Type . " " . GetParameter(A_LoopField,"quality")
        FormatLocations.Insert(GetParameter(A_LoopField,"url") . "&signature=" . GetParameter(A_LoopField,"sig"))
        FormatTypes.Insert(Type)
    }
    GuiControl,, Formats, %AvailableFormats%
    GuiControl, Choose, Formats, 1
    GuiControl, Enable, Download
}
catch
{
    GuiControl,, Formats, |
    GuiControl, Disable, Download
}

GuiControl,, Status, Video retrieved
Return

Download:
GuiControlGet, Index,, Formats
VideoURL := FormatLocations[Index]
Type := FormatTypes[Index]

FileSelectFile, Path, S19,, Select the location to save to, *.%Type%
If ErrorLevel
    Return
SplitPath, Path,,, Extension
If (Extension != Type)
    Path .= "." . Type

;determine the size of the file
WebRequest := ComObjCreate("WinHttp.WinHttpRequest.5.1")
WebRequest.Open("HEAD",VideoURL)
WebRequest.Send()
TotalSize := WebRequest.GetResponseHeader("Content-Length")
WebRequest := ""

GuiControl,, Status, Downloading video (0`%)
SetTimer, ShowProgress, 1000
URLDownloadToFile, %VideoURL%, %Path%
If ErrorLevel
    GuiControl,, Status, Could not download video
Else
    GuiControl,, Status, Video downloaded
GuiControl,, Downloaded, 0
SetTimer, ShowProgress, Off
Return

ShowProgress:
try FileGetSize, Size, %Path%
catch
    Size := 0
Percentage := Round((Size / TotalSize) * 100)
GuiControl,, Status, Downloading video (%Percentage%`%)
GuiControl,, Downloaded, %Percentage%
Return

GetParameter(Data,Name)
{
    If !RegExMatch(Data,"S)(?:^|[,&\?])" . Name . "=\K[^&]*",Value)
        throw Exception("Nonexistant URL parameter: " . Name)
    Return, URLDecode(Value)
}

URLDecode(Encoded)
{
    StringReplace, Encoded, Encoded, +, %A_Space%, All
    FoundPos := 0
    While, FoundPos := InStr(Encoded,"%",False,FoundPos + 1)
    {
        If (Temp1 := SubStr(Encoded,FoundPos + 1,2)) != "25"
            StringReplace, Encoded, Encoded, `%%Temp1%, % Chr("0x" . Temp1), All
    }
    StringReplace, Encoded, Encoded, `%25, `%, All
    Return, Encoded
}