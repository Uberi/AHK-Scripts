#NoEnv

;wip: templating, a GUI, and move to GitHub

AutoHotkeyNetUsername := "Uberi" ;your username at AutoHotkey.net
AutoHotkeyNetPassword := "Password Goes Here" ;your password at AutoHotkey.net
UploadWebsite := 0 ;whether or not to upload the website to AutoHOtkey.net after creating it

ForumUsername := AutoHotkeyNetUsername ;your username at the AutoHotkey forums (defaults to your AutoHotkey.net username)

SearchEnglishForums := 1 ;search for posts in the English forums
SearchGermanForums := 1 ;search for posts in the German forums

ColorScheme := "Blue" ;the generated website's color scheme (can be Blue, Orange, or Green)
SortPages := 0 ;sort the pages alphabetically instead of by time updated

IncludeCSS := 0 ;whether or not to include the generated style sheet directly onto the page (including means less files, but the stylesheet cannot be cached)
RewriteLinks := 0 ;convert absolute links to relative links when  possible ("http://www.autohotkey.net/~Uberi/SomeFile.txt" becomes "SomeFile.txt")
DownloadImages := 1 ;download the needed images from the internets

CachePages := 1 ;store topic information in a file, so page info does not have to be downloaded every time
PageCachePath := A_ScriptDir . "\PageCache.txt"

Gosub, GeneratePage
Return

GeneratePage:
If FileExist(PageCachePath)
{
 FileRead, PageCache, %PageCachePath%
 StringReplace, PageCache, PageCache, `r,, All
 PageCache := "`n" . RegExReplace(PageCache,"S)^\n+|\n+$") . "`n"
}
WebPage := GeneratePage(AutoHotkeyNetUsername,ForumUsername,PageCache)
If CachePages
{
 FileDelete, %PageCachePath%
 FileAppend, %PageCache%, %PageCachePath%
}
FileSelectFolder, Folder, *%A_ScriptDir%, 6, Select a folder to save the webpage to.
If ErrorLevel
 ExitApp
If (SubStr(Folder,0) <> "\")
 Folder .= "\"
Folder .= "WebPage"
FileCreateDir, %Folder%\Images
If DownloadImages
 URLDownloadToFile, *0 http://www.autohotkey.net/~Uberi/Images/Background_%ColorScheme%.jpg, %Folder%\Images\Background.jpg
FileDelete, %Folder%\index.html
FileAppend, %WebPage%, %Folder%\index.html
If Not IncludeCSS
{
 FileDelete, %Folder%\Style.css
 FileAppend, %StyleSheet%, %Folder%\Style.css
}
If DownloadImages
 URLDownloadToFile, http://www.autohotkey.net/~Uberi/Images/NoImage.jpg, %Folder%\Images\NoImage.jpg
MsgBox, 36, Complete, Website generated. Upload to AutoHotkey.net?
IfMsgBox, Yes
 Gosub, UploadWebsite
ExitApp

GuiClose:
ExitApp

UploadWebsite:
UPtr := A_PtrSize ? "UPtr" : "UInt", Suffix := A_IsUnicode ? "W" : "A"
hModule := DllCall("LoadLibrary" . Suffix,"Str","wininet.dll")
hInternet := DllCall("wininet\InternetOpen" . Suffix,"Str","AutoHotkey","UInt",0,"UInt",0,"UInt",0,"UInt",0)
hConnection := DllCall("wininet\InternetConnect" . Suffix,"UInt",hInternet,"Str","autohotkey.net","UInt",21,"Str",AutoHotkeyNetUsername,"Str",AutoHotkeyNetPassword,"UInt",1,"UInt",0,"UInt",0)
Temp1 := DllCall("wininet\FtpPutFile" . Suffix,"UInt",hConnection,"Str",Folder . "\index.html","Str","index.html","UInt",0,"UInt",0)
If Not IncludeCSS
 Temp1 := Temp1 && DllCall("wininet\FtpPutFile" . Suffix,"UInt",hConnection,"Str",Folder . "\Style.css","Str","Style.css","UInt",0,"UInt",0)
Temp1 := Temp1 && DllCall("wininet\FtpCreateDirectory" . Suffix,"UInt",hConnection,"Str","Images")
Temp1 := Temp1 && DllCall("wininet\FtpPutFile" . Suffix,"UInt",hConnection,"Str",Folder . "\Images\NoImage.jpg","Str","Images/NoImage.jpg","UInt",0,"UInt",0)
DllCall("wininet\InternetCloseHandle","UInt",hConnection)
DllCall("wininet\InternetCloseHandle","UInt",hInternet)
DllCall("FreeLibrary",UPtr,hModule)
If Not Temp1
 MsgBox, 16, Error, Could not upload website. Please use the File Manager at AutoHotkey.net to update the site manually.
Else
 MsgBox, 64, Success, Upload completed.
Return

GeneratePage(AutoHotkeyNetUsername,ForumUsername,ByRef PageCache)
{
 global RewriteLinks, SortPages, SearchEnglishForums, SearchGermanForums, IncludeCSS, ColorScheme, StyleSheet, CachePages
 If SearchEnglishForums
  Pages := SearchForPages(ForumUsername,"www")
 If SearchGermanForums
  Pages .= (SearchEnglishForums ? "`n" : "") . SearchForPages(ForumUsername,"de")
 If SortPages
  Sort, Pages
 Pages := RegExReplace(Pages,"S)^\n+|\n+$") ;remove surrounding newlines
 Loop, Parse, Pages, `n
 {
  StringSplit, Temp, A_LoopField, %A_Tab%
  Title := Temp1, URL := Temp2, ImageAlt := Title
  TempPos := InStr(PageCache,"`n" . URL . A_Tab)
  If TempPos ;retrieve page from cache
  {
   TempPos ++, Line := SubStr(PageCache,TempPos,InStr(PageCache,"`n",0,TempPos) - TempPos)
   StringSplit, Line, Line, %A_Tab%
   ScriptType := Line3, Description := Line4, Image := Line5, ScriptFile := Line6
  }
  Else ;retrieve page from web, and add to cache
  {
   GetPageInfo(URL,Title,ScriptType,Description,Image,ScriptFile)
   PageCache .= URL . A_Tab . Title . A_Tab . ScriptType . A_Tab . Description . A_Tab . Image . A_Tab . ScriptFile . "`n"
   TrayTip, Downloading..., Retrieving topic data (%A_Index% topics processed)
   Sleep, 3000
  }
  If Not Image
   Image := "http://www.autohotkey.net/~" . AutoHotkeyNetUsername . "/Images/NoImage.jpg"
  SplitPath, Image,, ImageDirectory,,, ImageDrive
  If RewriteLinks
  {
   If RegExMatch(ImageDirectory,"iS)^http://www\.autohotkey\.net/~" . AutoHotkeyNetUsername,Match)
    Image := SubStr(Image,StrLen(Match) + 2)
   SplitPath, ScriptFile,, ScriptDirectory,,, ScriptDrive
   If RegExMatch(ScriptDirectory,"iS)^http://www\.autohotkey\.net/~" . AutoHotkeyNetUsername,Match)
    ScriptFile := SubStr(ScriptFile,StrLen(Match) + 2)
  }
  Prefix := InStr(URL,"de.autohotkey") ? "_" : ""
  EntryID := RegExReplace(Prefix . Title,"S)\W")
  %ScriptType%List .= "<li id=""" . EntryID . """ class=""entry"">`r`n`t<a href=""#" . EntryID . """ class=""main"">" . Title . "</a>`r`n`t<div class=""info"">`r`n`t`t<img src=""" . Image . """ alt=""" . ImageAlt . """>`r`n`t`t" . Description . "`r`n`t`t<div class=""actions"">`r`n`t`t`t<a href=""" . URL . """ class=""action"">More Info</a>`r`n`t`t`t<a href=""" . ScriptFile . """ class=""action"">Download</a>`r`n`t`t</div>`r`n`t</div>`r`n</li>`r`n"
 }
 StyleSheet := GetStyle(ColorScheme)
 If IncludeCSS
  TempStyle := "<style>" . StyleSheet . "</style>"
 Else
  TempStyle := "<link rel=""StyleSheet"" href=""Style.css"" type=""text/css"">"
 WebPage = <!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">`r`n<html>`r`n<head>`r`n<meta http-equiv="Content-Type" content="text/html;charset=UTF-8">`r`n%TempStyle%`r`n<title>AutoHotkey.net - Scripts</title>`r`n</head>`r`n`r`n<body>`r`n<p id="title">AutoHotkey</p>`r`n<p id="subtitle">Scripts and libraries by %ForumUsername%</p>`r`n<div id="content">`r`n<div class="list">`r`n<p class="section" id="Scripts">Scripts</p>`r`n<ul>`r`n%ScriptsList%</ul></div>`r`n<div class="list">`r`n<p class="section" id="Libraries">Libraries</p>`r`n<ul>`r`n%LibrariesList%</ul>`r`n</div>`r`n</div>`r`n</body>`r`n</html>
 Return, WebPage
}

GetPageInfo(URL,ByRef Title,ByRef ScriptType,ByRef Description,ByRef Image,ByRef ScriptFile)
{
 global DefaultImage, AutoHotkeyNetUsername
 httpQuery(Temp1,URL)
 Page := RegExReplace(RegExReplace(Temp1,"S)[^\w \t\n[[:punct:]]]"),"`nmS)^[ \t]+|[ \t]+$","")
 Temp1 := InStr(Page,"<span class=""postbody"">",False,InStr(Page,"<td width=""100%"">")) + 23
 Page := SubStr(Page,Temp1,InStr(Page,"<td valign=""middle""",False,Temp1) - Temp1)
 StringTrimRight, Page, Page, (StrLen(Page) - InStr(Page,"</table>",False,0)) + 1
 IfInString, Page, _________________
  StringTrimRight, Page, Page, (StrLen(Page) - InStr(Page,"_________________",False,0)) + 1
 StringReplace, Page, Page, &quot;, ", All
 StringReplace, Page, Page, &amp;, &, All
 Description := RegExReplace(SubStr(Page,1,InStr(Page,"<br") - 1),"S)^[ \t]+|[ \t]+$")
 StringReplace, Description, Description, `r,, All
 StringReplace, Description, Description, `n,, All
 Description := RegExReplace(RegExReplace(RegExReplace(Description,"S)<a[^>]*>([^>]+)</a>","$1"),"S)\.[^\.]+:$","."),"S)<[^>]+>")
 If RegExMatch(Description,"S)^[^\.]+:$")
  StringTrimRight, Description, Description, 1
 If (SubStr(Description,0) <> ".")
  Description .= "."
 Temp1 := Title . "`n" . Description
 If Temp1 Contains Library,Function,Lib,Funktionen
  ScriptType = Libraries
 Else
  ScriptType = Scripts
 Transform, Title, HTML, %Title%
 Transform, Description, HTML, %Description%
 RegExMatch(Page,"<img src=""(http://[^""]+)""",Image), Image := Image1
 RegExMatch(Page,"<a href=""(http://www\.autohotkey\.net/~" . AutoHotkeyNetUsername . "/[^\.]+\.(?:ahk|exe))""",ScriptFile), ScriptFile := ScriptFile1 ? ScriptFile1 : URL
}

SearchForPages(ForumUsername,SubDomain = "www",Start = "")
{
 Temp1 := Start ? Start : 0
 TrayTip, Downloading..., Searching pages from the AutoHotkey forum (%Temp1% topics processed)
 HTTPQuery(Temp1,"http://" . SubDomain . ".autohotkey.com/forum/search.php?mode=results&start=" . Temp1,"search_keywords=&search_terms=all&search_author=" . ForumUsername . "&search_forum=2&search_time=0&search_fields=all&show_results=topics&return_chars=500&sort_by=0&sort_dir=DESC")
 SearchPage := RegExReplace(RegExReplace(Temp1,"S)[^\w \t\n[[:punct:]]]"),"`nmS)^[ \t]+|[ \t]+$")
 StringTrimLeft, SearchPage, SearchPage, InStr(SearchPage,"class=""forumline"" align=""center"">") + 32
 Temp1 := (StrLen(SearchPage) - InStr(SearchPage,"</table>")) + 1
 StringRight, Navigation, SearchPage, Temp1 - 8
 Navigation := SubStr(Navigation,1,InStr(Navigation,"</table>") - 1)
 If Navigation Contains >Next<,>Weiter<
 {
  RegExMatch(Navigation,"iS)start=(\d+)[^""]*"">(?:Next|Weiter)",Next)
  Sleep, 4000
 }
 StringTrimRight, SearchPage, SearchPage, Temp1
 StringReplace, SearchPage, SearchPage, %A_Tab%, %A_Space%, All
 StringReplace, SearchPage, SearchPage, </tr>,, All
 StringReplace, SearchPage, SearchPage, <tr> ;remove first <tr>
 StringTrimRight, SearchPage, SearchPage, (StrLen(SearchPage) - InStr(SearchPage,"<tr>",False,0)) + 1
 StringTrimLeft, SearchPage, SearchPage, InStr(SearchPage,"<tr>") + 3
 StringReplace, SearchPage, SearchPage, <tr>, % Chr(1), All
 Loop, Parse, SearchPage, % Chr(1), `n
 {
  StringTrimLeft, Field, A_LoopField, InStr(A_LoopField,"</td>") + 4
  StringTrimLeft, Field, A_LoopField, InStr(A_LoopField,"<td class=""row1"">") + 16
  StringReplace, Field, Field, </td>,, All
  StringReplace, Field, Field, `n,, All
  Field := RegExReplace(Field,"S)<td class=""row\d""(?: align=""center"" valign=""middle"")?(?: nowrap=""nowrap"")?>","`n")
  StringSplit, Field, Field, `n
  RegExMatch(Field3,"S)>([^<]+)</a>",Temp)
  If (Temp1 <> ForumUsername)
   Continue
  RegExMatch(Field2,"S)<a href=""topic([^\.]+)\.[^""]+"".*topictitle"">([^<]+)<",Temp)
  Temp1 := "http://" . SubDomain . ".autohotkey.com/forum/topic" . Temp1 . ".html"
  StringReplace, Temp2, Temp2, &amp;, &, All
  Pages .= Temp2 . A_Tab . Temp1 . "`n"
 }
 If Not Start
  TrayTip
 Return, SubStr(Pages,1,-1) . (Next1 ? ("`n" . SearchForPages(ForumUsername,SubDomain,Next1)) : "")
}

GetStyle(ColorScheme)
{
 Orange := "FFA046|F89500|EE7800|FFB41E|FFA410|FDB520|FDB520|FF9005"
 Blue := "46A0FF|00A4F0|0078EE|1EB4FF|10A4FF|2098E5|20B5FD|0580F5"
 Green := "72D254|20D010|15B510|18D500|10C600|22E018|13B500|10B600"

 StringSplit, StyleColor, %ColorScheme%, |
 StyleColor1RGBA := "0x" . StyleColor1, StyleColor1RGBA := "rgba(" . ((StyleColor1RGBA & 0xFF0000) >> 16) . "," . ((StyleColor1RGBA & 0xFF00) >> 8) . "," . (StyleColor1RGBA & 0xFF) . ",0.8)"
 PageStyle := "body`r`n{`r`n`theight:100%;`r`n`tfont-size:100%;`r`n`tmargin:0;`r`n`tpadding:0;`r`n`tbackground-color:black;`r`n`tbackground-image:url('Images/Background.jpg');`r`n`tbackground-repeat:no-repeat;`r`n`tbackground-attachment:fixed;`r`n`tbackground-size:120%;`r`n`t-moz-background-size:120%;`r`n`tfont-family:'Segoe UI Light',Helvetica,Arial,sans-serif;`r`n`tfont-size:1em;`r`n}`r`n`r`n@font-face`r`n{`r`n `tfont-family:'Segoe UI Light';`r`n `tsrc:url('Segoe UI Light.ttf') format('truetype');`r`n}`r`n`r`np { margin:0; }`r`n`r`ndiv#content`r`n{`r`n`twidth:40%;`r`n`tposition:relative;`r`n`tleft:5%;`r`n}`r`n`r`ndiv.list`r`n{`r`n `tfont-size:1em;`r`n `tcolor:#EEEEEE;`r`n}`r`n`r`np#title`r`n{`r`n`tposition:relative;`r`n`ttext-align:right;`r`n`tfont-size:5em;`r`n`ttop:-0.25em;`r`n`tright:0.1em;`r`n`tpadding:0;`r`n`tcolor:white;`r`n}`r`n`r`np#subtitle`r`n{`r`n`tposition:relative;`r`n`ttext-align:right;`r`n`tfont-size:1.5em;`r`n`ttop:-1em;`r`n`tright:4em;`r`n`tpadding:0;`r`n`tcolor:#EEEEEE;`r`n}`r`n`r`np.section`r`n{`r`n `tfont-size:3em;`r`n}`r`n`r`nul`r`n{`r`n`tmargin:0;`r`n`tpadding:0;`r`n`twidth:100%;`r`n}`r`n`r`nli.entry`r`n{`r`n`tlist-style-type:none;`r`n`twidth:100%;`r`n`tfont-size:1.5em;`r`n`tcolor:white;`r`n`tmargin:0.2em;`r`n}`r`n`r`nli.entry div { visibility:hidden; }`r`n`r`nli.entry:target div { visibility:visible; }`r`n`r`nli.entry:target a.main { background-color:#" . StyleColor6 . "; }`r`n`r`na.main`r`n{`r`n`tdisplay:block;`r`n`tleft:0;`r`n`ttop:0;`r`n`twidth:100%;`r`n`tright:100%;`r`n`tbackground-color:#" . StyleColor1 . ";`r`n`tbackground-color:" . StyleColor1RGBA . ";`r`n`ttext-align:center;`r`n`tcolor:white;`r`n`tpadding:0.3em;`r`n`ttext-decoration:none;`r`n}`r`n`r`na.main:hover, a.main:focus { background-color:#" . StyleColor2 . "; }`r`n`r`na.main:active { background-color:#" . StyleColor3 . "; }`r`n`r`ndiv.actions`r`n{`r`n`tright:0;`r`n`tmargin-top:1em;`r`n`ttext-align:right;`r`n`tfont-size:1.2em;`r`n}`r`n`r`na.action`r`n{`r`n`tcolor:white;`r`n`tbackground-color:#" . StyleColor4 . ";`r`n`ttext-align:center;`r`n`tpadding:0.3em;`r`n`ttext-decoration:none;`r`n}`r`n`r`na.action:hover, a.action:focus { background-color:#" . StyleColor5 . "; }`r`n`r`na.action:active { background-color:#" . StyleColor8 . "; }`r`n`r`ndiv.info`r`n{`r`n`tfont-size:0.8em;`r`n`tposition:fixed;`r`n`tfloat:right;`r`n`ttop:25%;`r`n`tright:5%;`r`n`twidth:40%;`r`n`tmargin:1em;`r`n`ttext-align:left;`r`n`tbackground-color:#" . StyleColor1 . ";`r`n`tbackground-color:" . StyleColor1RGBA . ";`r`n`tpadding:1em;`r`n`tmargin:0px;`r`n}`r`n`r`nimg`r`n{`r`n`tborder-style:none;`r`n`tdisplay:block;`r`n`tmax-width:100%;`r`n`tmax-height:15em;`r`n`tmargin:auto;`r`n`tmargin-bottom:1em;`r`n}"
 Return, PageStyle
}

HTTPQuery(ByRef Result,URL,POSTData = "",Headers = "",PostDataLength = "")
{
 WebRequest := ComObjCreate("WinHttp.WinHttpRequest.5.1")
 HTTPVerb := (PostData = "") ? "GET" : "POST"
 ;WebRequest.SetProxy(2,"127.0.0.1:8888") ;wip: debug - allow Fiddler to detect requests
 WebRequest.Open(HTTPVerb,URL)
 If (HTTPVerb = "POST" && Headers = "")
  Headers := "Content-Type: application/x-www-form-urlencoded"
 Loop, Parse, Headers, `n
 {
  StringSplit, Temp, A_LoopField, :, %A_Space%
  WebRequest.SetRequestHeader(Temp1,Temp2)
 }
 WebRequest.Send(POSTData)
 Result := WebRequest.ResponseText
 Return, StrLen(Result)
}