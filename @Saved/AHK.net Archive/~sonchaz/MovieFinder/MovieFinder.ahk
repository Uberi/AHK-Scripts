AUTOUPDATE=1 ; 1 IS ON ; 0 IS OFF
#NoEnv
#SingleInstance Force
SetBatchLines -1
SetWinDelay -1
SetControlDelay -1
SetKeyDelay, 0
SetTitleMatchMode,1
SetWorkingDir, %A_ScriptDir%
;________________________________________________________________
;______________________________set var___________________________|
version     := "0.3.0.3"
settings    := A_ScriptDir "\settings\settings.ini"
IMG         := A_ScriptDir "\img\"
exe         = ahk
MovieFinder = MovieFinder.%exe%
info        = %FileDir%\%movie%\info.ini
Menu, Tray, Icon,%img%moviefinder.ico

Title= Wellcome to
Message= MovieFinder
Duration=1
Options:="GC=ffffff TC=black MC=black"
Image=%img%moviefinder.ico
Notify(Title,Message,Duration,Options,Image)

IfNotExist,%A_ScriptDir%\settings\settings.ini
 {
  Notify("Welcome to MovieFinder","Click this notification to Run setup",0,"AC=setup")
 }

Gui + Resize
Gui + LastFound
Gui, font,  s12 ,Times New Roman
Gui, 1:Add,Text,x320 y4   w320 h40 vtagline
Gui, font,  s9, Times New Roman
Gui, 1:Add,Text,x600 y565 w100 h12 vversion,%version%
Gui, 1:Add,Text,x510 y50 w33 h20,Score:
Gui, 1:Add,Text,x510 y75 w42 h20,Genre:
Gui, 1:Add,Text,x510 y100 w42 h20,Runtime:
Gui, 1:Add,Text,x510 y125 w50 h20,Released:
Gui, 1:Add,Text,x640 y5 w70 h12,Slect Genre
Gui, 1:Add,Text,x560 y50 w65 h20 vscore
Gui, 1:Add,Text,x560 y75 w80 h20 vGenre
Gui, 1:Add,Text,x560 y100 w65 h20 vRuntime
Gui, 1:Add,text,x560 y125 w70 h20 vReleased
Gui, 1:Add,Edit,x320 y318 w310 h90 vplot
Gui, 1:Add,Edit,    xm   y10  w160 h20 vsearch gLiveSearch ,(%A_MM%.%A_DD%.%A_YYYY%) Live search
Gui, 1:Add,Button,  x510 y200 w80  h20 vwatch Hidden , Watch Movie
Gui, 1:Add,Button,  x510 y180 w80  h20 vTraler , Watch Traler
Gui, 1:Add,Button,  x510 y180 w80  h20 vTraler2  Hidden gWatchTraler ,Watch Traler
Gui, 1:Add,Progress,x476 y565 w120sc h12 vMyProgress   Border
Gui, 1:Add,Picture, x320 y40 h278 w185 vposter, ;poster
Gui, 1:Add, DropDownList, x640 y20 w100 ggenres vgenres  ,% "action|adventure|animation|biography|comedy|crime|"
. "drama|family|fantasy|history|horror|music|musical|mystery|news|romance|sci"
. "_fi|sport|thriller|war|western"
Gui, 1:Add, ListView,xm y40 w300 +Grid Border Checked AltSubmit vListView1 gListview1,Title
Gui, 1:Add, ListView,x320 y415 w310  LV0x10 Border vListView2 gListview2 , Download links
Gui, 1:Add, ListView,x640 y415 w310 r10 Border AltSubmit vListView3 gListview3 , IMDb Charts: Top Movies|Weekend|Gross
LV_ModifyCol( 1, "200" ), LV_ModifyCol( 2, "50 Right" ), LV_ModifyCol( 3, "55 Right" )
Gui, 1:Add, ListView,   x640 y50  w310 h358 r10 +Grid Border  AltSubmit vListView4 gListview4 ,Live Search
Gui  1: Add, StatusBar,
MovieCount(), SB_SetParts(67,40,70)
Menu, Sites, Add, oneclickmoviez.com , oneclickmoviez
Menu, Sites, Add,
Menu, Sites, Add, Katz.cd , Katz
Menu, MyContextMenu, add, Movie Sites , :Sites
Menu, MyContextMenu, Add,
Menu, Tools, add, Re-scrap movie , Rescrapmovie
Menu, Tools, Add,
Menu, Tools, add, Scrape &links , scrapalllinks
Menu, Tools, Add,
Menu, Tools, add, Add &trailer , Addtrailer
Menu, Tools, Add,
Menu, Tools, add, Add &Movie , Addmovie
Menu, Tools, Add,
Menu, Tools, Add, &Mark as Downloading , markdloading
Menu, MyContextMenu, add, Tools , :Tools
Menu, MyContextMenu, Add,
Menu, MyContextMenu, Add, imdb.com , imdb
Menu, MyContextMenu, Add,
Menu, MyContextMenu, Add, Delete , Delete
Menu, MyContextMenu2, Add, Add link to jdownloader, jdownloader
Menu, MyContextMenu4, Add, imdb.com,imdb
Menu, MyContextMenu4, Add, themoviedb.org,themoviedb
Menu, MyContextMenu4, Add,  Youtube.com , Youtube
Menu, MyContextMenu4, Add, Add movie  , IMDBLOOKUP
IniRead, FileDir, %settings%, settings, comingsoon
Menu, LOADLIB, Add, %FileDir% ,LCS
Menu, LOADLIB, Add,
IniRead, Moviefolder1, %settings%, settings, moviefolders1
Menu, LOADLIB, Add, %Moviefolder1%,LMF1
Menu, LOADLIB, Add,
IniRead,Moviefolder2, %settings%, settings, moviefolders2
Menu, LOADLIB, Add, %Moviefolder2%,LMF2
Menu, LOADLIB, Add,
IniRead, Moviefolder3, %settings%, settings, moviefolders3
Menu, LOADLIB, Add, %Moviefolder3%,LMF3
Menu, FileMenu, Add,  load movie folder, :LOADLIB
Menu, FileMenu, Add,  &Settings, setup
Menu, FileMenu, Add, &Exit,GuiClose
Menu, searchMenu, Add, &oneclickmoviez, oneclickmoviez
Menu, searchMenu, Add, &Katz.cd, Katz
Menu, searchMenu, Add, &imdb.com,imdb
Menu, MyMenuBar, Add, &File,  :FileMenu
Menu, MyMenuBar, Add, &Search,:SearchMenu
Menu  MyMenuBar, Add, Update,Update
;Menu  MyMenuBar, Add, Reload,Reload ; for me when i edit :)
Menu, MyMenuBar, Add, Help,Help
Gui, Menu, MyMenuBar
Menu, tray, NoStandard
Menu, tray, add, Settings, setup
Menu  tray, Add, Update,Update
Menu  tray, Add, Reload,Reload
Menu, tray, add, Exit, GuiClose
   If (AUTOUPDATE=1)
   Gosub,Update
   Gosub,IMDbCharts
populatelistview:
Gui, ListView, ListView1
LV_Delete()
 Loop %FileDir%\*.*,1,0
  {
   Gui, ListView, ListView1
   txtExist:=""
   Loop %A_LoopFileFullPath%\*,0,1
     txtExist:=(txtExist || A_LoopFileExt="ini")
   LV_Add( "", A_LoopFileName)
   If txtExist
     LV_Modify(A_Index,"Check")
   LV_ModifyCol(1, "Sort")
   LV_Modify(1,"select")
   MovieCount()
  }

 Gui, 1:Show, h700 ,%MovieFinder%  ;w986

Return

;---------------------------------------------START--------------------------------------------------------

Listview1:
 Gui, ListView, ListView1
 If A_GuiEvent=Normal
  {
   Gosub LOADINFO
  }
 Else
   Gui, ListView, ListView1
 If A_GuiEvent=DoubleClick
  {
   LV_GetText(movie, A_EventInfo, 1)
   Run %FileDir%\%movie%,, UseErrorLevel
   If ErrorLevel
     MsgBox Could not open "%FileDir%\%movie%".
  }
Return

Listview2:
 Gui, ListView, ListView2
 If A_GuiEvent=DoubleClick
  {
   LV_GetText(movie, A_EventInfo, 1)
   Run %movie%,, UseErrorLevel
   If ErrorLevel
     MsgBox Could not open "%movie%".
  }
Return
Listview3:
 Gui, ListView, ListView3
 If A_GuiEvent=Normal
  {
   ;LV_GetText(movie, A_EventInfo, 1)
   Goto,Moviepreview
  }

 Gui, ListView, ListView3
 If A_GuiEvent=DoubleClick
  {
   LV_GetText(movie, A_EventInfo, 1)
   Goto,IMDBLOOKUP
  }
Return
Listview4:
 Gui, ListView, ListView4
 If A_GuiEvent=Normal
  {
   Gosub Moviepreview
  }

 Gui, ListView, ListView4
 If A_GuiEvent=DoubleClick
  {
   LV_GetText(movie, A_EventInfo, 1)
   Goto,IMDBLOOKUP
  }
Return


;____________________________________________________________________
;_______________________GuiContextMenu LV_1_2_&_4____________________|

GuiContextMenu:
 Gui, ListView, ListView1
 If  A_GuiControl = ListView1
  {
   LV_GetText(movie, A_EventInfo, 1)
   Menu, MyContextMenu, Show, %A_GuiX%, %A_GuiY%
  }
 Gui, ListView, ListView2
 If  A_GuiControl = ListView2
  {
   LV_GetText(movie, A_EventInfo, 1)
   Menu, MyContextMenu2, Show, %A_GuiX%, %A_GuiY%
  }
 Gui, ListView, ListView4
 If  A_GuiControl = ListView4
  {
   LV_GetText(movie, A_EventInfo, 1)
   Menu, MyContextMenu4, Show, %A_GuiX%, %A_GuiY%
  }
Return
;__________________________________________________________________
;___________________________LOADINFO_______________________________|
LOADINFO:
 Gui,ListView,ListView1
 RowNumber = 0
 Loop
  {
   RowNumber := LV_GetNext(RowNumber)
   If not RowNumber
     Break
   LV_GetText(movie, RowNumber)

  }
 IfEqual, Lastmovie,%movie% ; don't Process no changes
   Return
   IfNotExist,%FileDir%\%movie%\info.ini
    Gosub,Rescrapmovie
    else
 FileCount = 0
 TotalSize = 0
 Loop, %FileDir%\%movie%\*.*, 1,1
  {
   GuiControl,,poster,%FileDir%\%movie%\folder.jpg ;updates folder.jpg
   FileCount += 1
   TotalSize += A_LoopFileSize
  }
 SelectedFullPath = %FileDir%\%movie%
 SB_SetText(FileCount . " files", 2)
 SB_SetText(Round(TotalSize / 1024, 1) . " KB", 3)
 SB_SetText(SelectedFullPath, 4)
 IniRead, plot ,%FileDir%\%movie%\info.ini,plot,plot,Nodata
 GuiControl,, plot, %plot%
 IniRead, released ,%FileDir%\%movie%\info.ini,released,released,Nodata
 GuiControl,, released, %released%
 IniRead, score   ,%FileDir%\%movie%\info.ini,score,score,Nodata
 GuiControl,, score, %score%
 IniRead, Runtime   ,%FileDir%\%movie%\info.ini,Runtime,Runtime,Nodata
 GuiControl,, Runtime, %Runtime%
 IniRead, Genre   ,%FileDir%\%movie%\info.ini,genres,genres,Nodata
 GuiControl,, Genre, %Genre%
 IniRead, tagline   ,%FileDir%\%movie%\info.ini,tagline,tagline,%movie%
 GuiControl,, tagline, %tagline%
 GuiControl, Hide, Traler2
 GuiControl, Show, Traler
 Gui, ListView,ListView2
 LV_Delete()
 Loop ,Read,%FileDir%\%movie%\links.txt
   LV_Add("", A_LoopReadLine)
 ; LV_ModifyCol(1, "SortDesc")
 Lastmovie:= movie
 IfExist,%FileDir%\%movie%\%movie%.*
   GuiControl, show, watch
 Else
  GuiControl, Hide, watch
Return

;__________________________________________
;________________Live_Search_______________|
LiveSearch:
 Gui,ListView,ListView4
 LV_Delete() , LV_ModifyCol,(1,100)
 FileDelete,%A_ScriptDir%\Temp\LiveSearch.txt
 Gui,Submit,NoHide
 IfEqual, Lastsearch,%search%
   Return
 URLDownloadToFile, http://api.themoviedb.org/2.1/Movie.search/en/xml/02a04e46297ed5ab2c9b2f3182224449/%search%,%A_ScriptDir%\Temp\search.xml
 FileRead, xml,%A_ScriptDir%\Temp\search.xml
 n:=""
 {
  While     lv       := StrX( xml,"<movie>" ,N,0,  "</movie>" ,1,0,  N )
  , msearch  := UnHTM( StrX( LV, "<name>",1,6, "</name>",1,7 ) )
  , ysearch  := UnHTM( StrX( LV, "<released>",1,10, "</released>",1,17 ) )
  IfInString,ysearch,:
    StringTrimRight,ysearch,ysearch,1
  Else
    FileAppend,%msearch%%A_Space%(%ysearch%)`n,%A_ScriptDir%\Temp\LiveSearch.txt
 }
Loop ,Read,%A_ScriptDir%\Temp\LiveSearch.txt
  LV_Add("", A_LoopReadLine)
;LV_ModifyCol(1, "sort")
Lastsearch:= search
Return

;__________________________________________
;________________Button Control____________|

ButtonwatchMovie:
 Run,%FileDir%\%movie%\%movie%.avi,,UseErrorLevel
 If ErrorLevel
   Run,%FileDir%\%movie%\%movie%.mov,,UseErrorLevel
 If ErrorLevel
   Run,%FileDir%\%movie%\%movie%.mp4,,UseErrorLevel
 If ErrorLevel
   Run,%FileDir%\%movie%\%movie%.flv,,UseErrorLevel
 If ErrorLevel
   Run,%FileDir%\%movie%\%movie%.mkv,,UseErrorLevel
 If ErrorLevel
   Return
  else
Title= Now watching
Message= %movie%
Duration=3
Options:="GC=ffffff TC=black MC=black"
Image=%FileDir%\%movie%\folder.jpg
Notify(Title,Message,Duration,Options,Image)
sleep,3001
WinMinimize,MovieFinder.ahk
Return
Buttonwatchtraler:
 IniRead,trailer,%FileDir%\%movie%\info.ini,trailer,trailer,%A_Space%
 If trailer =
  {
   Run,http://www.google.ca/search?hl=en&safe=off&q=%movie%+HQ+trailer+site:youtube.com&btnI=I27m+Feeling+Lucky
   Return
  }
 Else
WatchTraler:
 URLDownloadToFile,%trailer%,%A_ScriptDir%\temp\youtube.htm
 FileRead, htm, %A_ScriptDir%\temp\youtube.htm
 name	:= UnHTM( StrX( htm, "<title>",1,29, "</title>",1,8 ) )
 youtube := UnHTM( StrX( htm, "<link rel=""canonical""",1,37, ">",1,2 ) )
 temp= %name%`n<embed src="http://www.youtube.com/v/%youtube%?fs=1&autoplay=1" type="application/x-shockwave-Flash" allowscriptaccess="always" allowfullScreen="true" width="920" height="450"></embed>
 FileDelete,%A_ScriptDir%\temp\trailer.htm
 FileAppend,%temp%,%A_ScriptDir%\temp\trailer.htm
 If name = roadcast Yourself.
  {
   StringReplace, Youtube, movie, %A_Space%,+, All
   Run,http://www.google.ca/search?hl=en&safe=off&q=%Youtube%+HQ+trailer+site:youtube.com&btnI=I27m+Feeling+Lucky
   Return
  }
 Run,%A_ScriptDir%\temp\trailer.htm
Return
Reload:
 ;FileRemoveDir,Temp,1
 ;FileCreateDir,Temp
 Reload
Return
Help:
 Run,%A_ScriptDir%\settings\help.txt
Return
Update:
 Run,%A_ScriptDir%\Data\updater.ahk
Return
;_________________________________________________
;_____________RIGHT-CLICK-MENU__LV1_______________|

imdb:
 Run, http://www.imdb.com/find?s=all&q=%movie%,, UseErrorLevel
 If ErrorLevel
   MsgBox Could not open %movie%.
Return
themoviedb:
 Run,http://www.themoviedb.org/search/%movie%,, UseErrorLevel
 If ErrorLevel
   MsgBox Could not open %FileName%.
Return
HdTrailers:
 IniWrite,%movie%,%settings%, trailer,hdtrailers
 Run, %hdtrailers%
Return
Youtube:     ;youtube
 StringReplace, Youtube, movie, %A_Space%,+, All
 Run,http://www.google.ca/search?hl=en&safe=off&q=%Youtube%+HQ+trailer+site:youtube.com&btnI=I27m+Feeling+Lucky
Return
traileraddict:
 StringReplace, traileraddict, movie, %A_Space%,+, All
 Run,http://www.google.ca/search?hl=en&safe=off&q=%traileraddict%+site:traileraddict.com&btnI=I27m+Feeling+Lucky
Return
Katz:
 StringReplace, katz, movie, %A_Space%, + , All
 Run, http://katz.cd/search?q=%katz%&type=movies
Return
oneclickmoviez:
 StringReplace, oneClick, movie, %A_Space%, + , All
 StringReplace, oneClick, oneClick, -, +, All
 StringTrimRight, oneClick, oneClick, 7
 Run , http://oneClickmoviez.com/?s=%oneClick%
Return
markdloading:
 FileDelete,%FileDir%\%movie%\links.txt
 FileAppend,Downloading................ , %FileDir%\%movie%\links.txt
Return
Addtrailer:
 InputBox, userInput , YouTube,http://www.youtube.com/watch?v=LVK2GIN84LE,, 300,150
 If ErrorLevel
   MsgBox, Cancel was pressed.
 Else
   IniDelete,%FileDir%\%movie%\info.ini,trailer
 IniWrite,%userInput%,%FileDir%\%movie%\info.ini,trailer,trailer
 ;FileSelectFile,Trailer,,,,*.avi;*.mp4;*.mkv;*.flv;*.mov
 ;FileMove, %Trailer%, %FileDir%\%movie%\%movie%-Trailer.*
Return
Addmovie:
 FileSelectFile,Trailer,,,,*.avi;*.mp4;*.mkv;*.flv;*.mov
 FileMove, %Trailer%, %FileDir%\%movie%\%movie%.*
Return
Delete:
 MsgBox, 262180, Delete, Do you want to Delete %movie% ?
 IfMsgBox,Yes
  {
   FileRecycle,%FileDir%\%movie%
   Goto,ContextClearRows
   Return
  }
 Else
   Return
ContextClearRows:
 RowNumber = 0
 Loop
  {
   RowNumber := LV_GetNext(RowNumber - 1)
   If not RowNumber
     Break
   LV_Delete(RowNumber)
  }
 Title= File Recycled
 Message= %movie%
 Duration=1
 Options:="GC=ffffff TC=black MC=black"
 Image=32
 Notify(Title,Message,Duration,Options,Image)
 MovieCount()
Return
;_________________________________________________
;_____________RIGHT-CLICK-MENU__Lv2_______________|
jdownloader:
 Gui, ListView, ListView2
 clipboard = %movie%
 ClipWait, 2
 If ErrorLevel = 0
   Return

 ;_________________________________________________
 ;_____________RIGHT-CLICK-MENU__Lv3_______________|
rightclicklv2:
Return
;_________________________________________________
;__________________NEW_MOVIE______________________|

Rescrapmovie:
 Gosub,ContextClearRows
 FileDelete,%FileDir%\%movie%\links.txt
 FileDelete,%FileDir%\%movie%\plot.doc
 FileDelete,%FileDir%\%movie%\folder.jpg
 Goto,IMDBLOOKUP
IMDBLOOKUP:
 GuiControl,, MyProgress, 5
 URLDownloadToFile ,http://api.themoviedb.org/2.1/Movie.search/en/xml/02a04e46297ed5ab2c9b2f3182224449/%movie%, %A_ScriptDir%\temp\movie.xml
 FileRead, LV, %A_ScriptDir%\temp\movie.xml
 ID       :=        StrX( LV, "<id>",1,4, "</id>",1,5 )
 GuiControl,, MyProgress, 10
 URLDownloadToFile,http://api.themoviedb.org/2.1/Movie.getImages/en/xml/02a04e46297ed5ab2c9b2f3182224449/%ID%, %A_ScriptDir%\temp\poster.xml
 FileRead, LV, %A_ScriptDir%\temp\poster.xml
 {
     pdata     := UnHTM ( StrX( LV, "<poster id=",1,300, "cover.jpg",1,0) )
  ,  posterid  := StrX( pdata, "http://hwcdn.themoviedb.org/posters/",1,0, "cover.jpg",1,0 )

 }

URLDownloadToFile,%posterid%,%A_ScriptDir%\temp\folder.jpg
URLDownloadToFile,http://api.themoviedb.org/2.1/Movie.getInfo/en/xml/02a04e46297ed5ab2c9b2f3182224449/%ID%, %A_ScriptDir%\temp\info.xml
FileRead, LV,%A_ScriptDir%\temp\info.xml
{
 tagline  :=        StrX( LV, "<tagline>",1,9, "</tagline>",0,10 )
 Runtime  :=        StrX( LV, "<Runtime>",1,9, "</Runtime>",0,10 )
 trailer  :=        StrX( LV, "<trailer>",1,9, "</trailer>",0,10 )
 plot     := UnHTM( StrX( LV, "<overview>",1,10, "</overview>",0,11 ) )
 released :=        StrX( LV, "<released>",1,10, "</released>",0,11 )
 score    :=        StrX( LV, "<rating>",1,8, "</rating>",0,9 )
 g        :=        StrX( LV, "<categories>",1,10, "</categories>",0,11 )
 genre    :=        StrX( g, "name=",1,6, "url=",1,6 )
}
 /*
{
 GuiControl,, MyProgress, 20

 GuiControl,, MyProgress, 45

 IniRead, moviefolders1,%settings%, settings, moviefolders1
 IfExist,%moviefolders1%\%movie%
  {
   MsgBox, 36, %movie%,%moviefolders1%\%movie% all Ready created`n Do you want to update it
   IfMsgBox,no
    {
     GuiControl,, MyProgress, 0
     Return
    }
  }
 Else
   GuiControl,, MyProgress, 50
 IniRead, moviefolders2,%settings%, settings, moviefolders2
 IfExist,%moviefolders2%\%movie%

  {
   MsgBox, 36, %movie%, %moviefolders2%\%movie% all Ready created`n Do you want to update it
   IfMsgBox,no
    {
     GuiControl,, MyProgress, 0
     Return
    }
  }
 Else
   GuiControl,, MyProgress, 60
 IniRead, moviefolders3,%settings%,settings, moviefolders3
 IfExist,%moviefolders3%\%movie%
  {
   MsgBox, 36, %movie%, %moviefolders3%\%movie% all Ready created`n Do you want to update it
   IfMsgBox,no
    {
     GuiControl,, MyProgress, 0
     Return
    }
  }
 Else
   GuiControl,, MyProgress, 65
 IfExist,%FileDir%\%movie%
  {
   MsgBox, 36, %movie%, %FileDir%\%movie% all Ready created`n Do you want to update it
   IfMsgBox,no
    {
     GuiControl,, MyProgress, 0
     Return
    }
  }
 Else
 */
   GuiControl,, MyProgress, 75
 Title= MovieFinder
 Message= New Movie %movie% was added.
 Duration=5
 Options:="GC=ffffff TC=black MC=black AC=scrapers"
 Image=%img%moviefinder.ico
 Notify(Title,Message,Duration,Options,Image)
 StringReplace,movie,movie,:,,all
 FileCreateDir,%FileDir%\%movie%
 GuiControl,, MyProgress, 80
 IniWrite, %tagline%  ,%FileDir%\%movie%\info.ini,tagline,tagline
 IniWrite, %movie%    ,%FileDir%\%movie%\info.ini,movie name,moviename
 IniWrite, %ID%       ,%FileDir%\%movie%\info.ini,ID,ID
 IniWrite, %plot%     ,%FileDir%\%movie%\info.ini,plot,plot
 IniWrite, %released% ,%FileDir%\%movie%\info.ini,released,released
 IniWrite, %score%    ,%FileDir%\%movie%\info.ini,score,score
 IniWrite, %trailer%  ,%FileDir%\%movie%\info.ini,trailer,trailer
 IniWrite, %Runtime%  ,%FileDir%\%movie%\info.ini,Runtime,Runtime
 IniWrite, %genre%    ,%FileDir%\%movie%\info.ini,genres,genres
 GuiControl,, MyProgress, 90
 URLDownloadToFile,http://api.themoviedb.org/2.1/Movie.getImages/en/xml/02a04e46297ed5ab2c9b2f3182224449/%ID%, %A_ScriptDir%\temp\poster.xml
 FileRead, LV, %A_ScriptDir%\temp\poster.xml
 {
  pdata     := UnHTM ( StrX( LV, "<poster id=",1,300, "cover.jpg",1,0) )
  								,   posterid  :=         StrX( pdata, "http://hwcdn.themoviedb.org/posters/",1,0, "cover.jpg",1,0 )

 }

URLDownloadToFile,%posterid%,%FileDir%\%movie%\folder.jpg
Gui, ListView, ListView1
LV_Add("Check",movie)
LV_ModifyCol(1, "sort")
GuiControl,, MyProgress, 100
IniWrite, %movie%,%settings%, scrapers,FileName
GuiControl,, MyProgress, 0
IfNotExist,%FileDir%\%movie%\%movie%.*
{
Goto,scrapers1
Return
}
else
return


IMDbCharts:
 If NOT ConnectedToInternet() {
   Notify("Internet Connection - Error", "You are not connected to the internet!", "5", "GC=White TC=Black MC=Black IN=13", $ResDLL)
   Return
  }
 URLDownloadToFile,http://www.imdb.com/chart/, %A_ScriptDir%\temp\TopMovies.htm
 FileRead ChartsV, %A_ScriptDir%\temp\TopMovies.htm
 Gui, ListView, ListView3
 Table := StrX( ChartsV, "<table cellpadding=",1,0, "</table>",1,0 ) ; Extract First table
 StrX( Table, "<tr>",1,0, "</tr>",1,0, N )          ; Skip First row which is column header
 While  Row := StrX( Table, "<tr>",N,0, "</tr>",1,0, N )
 Title   := UnHTM( Strx( Row, "<a href=",1,0, ")",1,0, T ) )
 								, Weekend := UnHTM( Strx( Row, "<td",T,0, "</td>",1,0, T ) )
 								, Gross   := UnHTM( Strx( Row, "<td",T,0, "</td>",1,0, T ) )
 								, LV_Add( "", Title, Weekend, Gross )
 LV_ModifyCol(1, "Sort")
Return

Moviepreview:
 GuiControl, Hide, watch
 LV_GetText(movie, A_EventInfo, 1)
 IfEqual, Lastmovie,%movie% ; don't Process no changes
   Return
 Lastmovie := movie
 URLDownloadToFile ,http://api.themoviedb.org/2.1/Movie.search/en/xml/02a04e46297ed5ab2c9b2f3182224449/%movie%, %A_ScriptDir%\temp\movie.xml
 FileRead, LV, %A_ScriptDir%\temp\movie.xml
 {
  ID       :=        StrX( LV, "<id>",1,4, "</id>",1,5 )
  year     :=        StrX( LV, "<released>",1,10, "</released>",1,17 )

 }
URLDownloadToFile,http://api.themoviedb.org/2.1/Movie.getImages/en/xml/02a04e46297ed5ab2c9b2f3182224449/%ID%, %A_ScriptDir%\temp\poster.xml
FileRead, LV, %A_ScriptDir%\temp\poster.xml
{
 pdata := UnHTM ( StrX( LV, "<poster id=",1,300, "cover.jpg",1,0) )
 								,  posterid  :=  StrX( pdata, "http://hwcdn.themoviedb.org/posters/",1,0, "cover.jpg",1,0 )
}
URLDownloadToFile,%posterid%,%A_ScriptDir%\temp\folder.jpg
URLDownloadToFile,http://api.themoviedb.org/2.1/Movie.getInfo/en/xml/02a04e46297ed5ab2c9b2f3182224449/%ID%, %A_ScriptDir%\temp\info.xml
FileRead, LV,%A_ScriptDir%\temp\info.xml
{
 tagline  :=        StrX( LV, "<tagline>",1,9, "</tagline>",0,10 )
 Runtime  :=        StrX( LV, "<Runtime>",1,9, "</Runtime>",0,10 )
 trailer  :=        StrX( LV, "<trailer>",1,9, "</trailer>",0,10 )
 plot     := UnHTM( StrX( LV, "<overview>",1,10, "</overview>",1,11 ) )
 released :=        StrX( LV, "<released>",1,10, "</released>",1,11 )
 score    :=        StrX( LV, "<rating>",1,8, "</rating>",1,9 )
 g        :=        StrX( LV, "<categories>",1,10, "</categories>",1,11 )
 genre    :=        StrX( g, "name=",1,6, "url=",1,6 )
}
GuiControl,  Hide, Traler
GuiControl,  Show, Traler2
GuiControl,, tagline, %tagline%
GuiControl,, Runtime, %Runtime%
GuiControl,, trailer2, %trailer%
GuiControl,, score, %score%
GuiControl,, released, %released%
GuiControl,, plot, %plot%
GuiControl,, Genre, %genre%
GuiControl,, poster,%A_ScriptDir%\temp\folder.jpg
Gui, ListView,ListView2
LV_Delete()
Return
genres:
 Gui,Submit,NoHide
 IfEqual, Lastmovie,%genres%
   Return
 Title= MovieFinder
 Message= Loding %genres% Genre List.
 Duration=8
 Options:="GC=ffffff TC=black MC=black"
 Image=%img%moviefinder.ico
 Notify(Title,Message,Duration,Options,Image)
 GuiControl,,poster,%A_ScriptDir%\img\loading_img.gif
 Gui, ListView,ListView4
 URL = http://www.imdb.com/search/title?genres=%genres%&title_type=feature&Sort=moviemeter
 FileRead, olddata, %A_ScriptDir%\temp\%genres%old.txt
 Goto,CheckChange
Return

CheckChange:
 LV_Delete( )
 URLDownloadToFile, %URL%,%A_ScriptDir%\temp\%genres%.htm
 FileRead, newdata,%A_ScriptDir%\temp\%genres%.htm
 UnHTM ( tdata := StrX( newdata, "<tr class=",1,0, "</tr>",1,0) )
 								, movie := UnHTM( StrX( tdata, "title=",1,7, "><img",1,6 ) )
 ;FileAppend,%movie%,%A_ScriptDir%\%genres%new.txt
 If (movie != olddata)
  {
   FileDelete,%A_ScriptDir%\temp\%genres%old.txt
   FileAppend,%movie%,%A_ScriptDir%\temp\%genres%old.txt
   Goto,downloadgenres

   Return
  }
 Else
   Goto,loadgenres
Return
downloadgenres:
 GuiControl,, MyProgress, 5
 ; URLDownloadToFile, http://www.imdb.com/search/title?genres=%genres%&title_type=feature&sort=moviemeter, %A_ScriptDir%\temp\%genres%.htm
 GuiControl,, MyProgress, 10
 URLDownloadToFile, http://www.imdb.com/search/title?genres=%genres%&Sort=&start=51&title_type=feature, %A_ScriptDir%\temp\%genres%2.htm
 GuiControl,, MyProgress, 15
 URLDownloadToFile, http://www.imdb.com/search/title?genres=%genres%&Sort=&start=101&title_type=feature, %A_ScriptDir%\temp\%genres%3.htm
 GuiControl,, MyProgress, 20
 URLDownloadToFile, http://www.imdb.com/search/title?genres=%genres%&Sort=&start=151&title_type=feature, %A_ScriptDir%\temp\%genres%4.htm
 GuiControl,, MyProgress, 25
loadgenres:
 LV_Delete( )
 FileRead, chart, %A_ScriptDir%\temp\%genres%.htm
 GuiControl,, MyProgress, 50
 Loop,2   {
   n:=""
   While UnHTM ( tdata := StrX( chart, "<tr class=",n,0, "</tr>",1,0, n ) )
   								, movie := UnHTM( StrX( tdata, "title=",1,7, "><img",1,6 ) )
   LV_Add( "", Movie )
   Gui, ListView, ListView4
   FileRead, chart, %A_ScriptDir%\temp\%genres%2.htm
  }
 Gui, ListView, ListView4
 FileRead, chart, %A_ScriptDir%\temp\%genres3%.htm
 GuiControl,, MyProgress, 100
 Loop,2   {
   n:=""
   While UnHTM ( tdata := StrX( chart, "<tr class=",n,0, "</tr>",1,0, n ) )
   								, movie := UnHTM( StrX( tdata, "title=",1,7, "><img",1,6 ) )
   LV_Add( "", Movie )
   Gui, ListView, ListView4
   FileRead, chart, %A_ScriptDir%\temp\%genres%4.htm
  }
 ;LV_ModifyCol(1, "sort")
 GuiControl,, MyProgress, 0
 Lastmovie:= genres
Return
scrapalllinks:
 IniWrite, %movie%,%settings%,scrapers,FileName
 FileDelete,%FileDir%\%movie%\links.txt
scrapers1:
 Run,%A_ScriptDir%\Data\linkScraper.ahk
Return
setup:

 Gui, 2:Add, Button, x392 y10 w70 h20 , change
 Gui, 2:Add, Button, x392 y80 w70 h20 , change 1
 Gui, 2:Add, Button, x392 y150 w70 h20 , change 2
 Gui, 2:Add, Button, x392 y220 w70 h20 , change 3
 Gui, 2:Add, Button, x362 y360 w100 h30 , set up done
 Gui, 2:Add, Button, x200 y360 w100 h30 , Desktop shortcut?

 Gui, 2:Add, Text, x12 y10 w110 h30 , Working folder
 Gui, 2:Add, Text, x12 y80 w110 h30 , Movie folder 1
 Gui, 2:Add, Text, x12 y150 w110 h30 , Movie folder 2
 Gui, 2:Add, Text, x12 y220 w110 h30 , Movie folder 3
 IniRead, comingsoon,%settings%, settings, comingsoon
 Gui, 2:Add, Text, x12 y40 w450 h30 vcomingsoon , %comingsoon%
 IniRead, moviefolders1,%settings%, settings, moviefolders1
 Gui, 2:Add, Text, x12 y110 w450 h30 vmoviefolders1, %moviefolders1%
 IniRead, moviefolders2,%settings%, settings, moviefolders2
 Gui, 2:Add, Text, x12 y180 w450 h30 vmoviefolders2, %moviefolders2%
 IniRead, moviefolders3,%settings%, settings, moviefolders3
 Gui, 2:Add, Text, x12 y250 w450 h30 vmoviefolders3, %moviefolders3%
 Gui, 2:Show, w479 h406, %MovieFinder% Setup
Return

2Buttonchange:
 MsgBox,,,select working folder
 FileSelectFolder, OutputVar, , 3
 If OutputVar =
   MsgBox,You didn't select a folder.
 Else
   IniWrite, %OutputVar%,%settings%, settings,comingsoon
 GuiControl,, comingsoon , %OutputVar%
Return
2Buttonchange1:
 FileSelectFolder, OutputVar2, , 3
 If OutputVar2 =
   MsgBox,You didn't select a folder.
 Else
   IniWrite, %OutputVar2%,%settings%, settings,moviefolders1
 GuiControl,, moviefolders1 , %OutputVar2%
Return
2Buttonchange2:
 FileSelectFolder, OutputVar3, , 3
 If OutputVar3 =
   MsgBox,You didn't select a folder.
 Else
   IniWrite, %OutputVar3%,%settings%, settings,moviefolders2
 GuiControl,, moviefolders2 , %OutputVar3%
Return
2Buttonchange3:
 FileSelectFolder, OutputVar4, , 3
 If OutputVar4 =
   MsgBox,You didn't select a folder.
 Else
   IniWrite, %OutputVar4%,%settings%, settings,moviefolders3
 GuiControl,, moviefolders3 , %OutputVar4%
Return
2Buttondesktopshortcut?:
 IfExist,%A_Desktop%\%MovieFinder%.lnk
  {
   MsgBox,,, Shortcut alReady Exist
   Return
  }
 Else
   FileCreateShortcut, %A_ScriptDir%\%moviefinder%, %A_Desktop%\MovieFinder.lnk, C:\, "%A_ScriptFullPath%", My Description, %img%MovieFinder.ico,
 MsgBox,,,Shortcut was Created
Return


GuiSize:
 If A_EventInfo = 1
   Return
 GuiControl, Move, ListView1,  % " H" . (A_GuiHeight - 75)
 GuiControl, Move, ListView2,  % " h" . (A_GuiHeight - 480)
 GuiControl, Move, ListView3,  % " H" . (A_GuiHeight - 490)
 GuiControl, Move, MyProgress, % " y" . (A_GuiHeight - 40) . "x" . (A_GuiWidth - 165)
 GuiControl, Move, version,    % " y" . (A_GuiHeight - 40) . "x" . (A_GuiWidth - 40)
return
;_________________________________________________
;__________________Load_lib_______________________|
LCS:
IniRead, FileDir, %settings%, settings, comingsoon
Title= Loding....
Message= %FileDir%
Duration=2
Options:="GC=ffffff TC=black MC=black"
Image=%img%moviefinder.ico
Notify(Title,Message,Duration,Options,Image)
Gosub,populatelistview
return
LMF1:
IniRead, FileDir, %settings%, settings, moviefolders1
GuiControl,, ListView1, %FileDir%
Title= Loding....
Message= %FileDir%
Duration=2
Options:="GC=ffffff TC=black MC=black"
Image=%img%moviefinder.ico
Notify(Title,Message,Duration,Options,Image)
Gosub,populatelistview
return
LMF2:
IniRead, FileDir, %settings%, settings, moviefolders2
Title= Loding....
Message= %FileDir%
Duration=2
Options:="GC=ffffff TC=black MC=black"
Image=%img%moviefinder.ico
Notify(Title,Message,Duration,Options,Image)
Gosub,populatelistview
return
LMF3:
IniRead, FileDir, %settings%, settings, moviefolders3
Title= Loding....
Message= %FileDir%
Duration=2
Options:="GC=ffffff TC=black MC=black"
Image=%img%moviefinder.ico
Notify(Title,Message,Duration,Options,Image)
Gosub,populatelistview
return
 ;_______________________________________________
 ;________________HOT_KEYS_______________________|
#IfWinActive,MovieFinder
^i::Goto,imdb
^o::Goto,oneclickmoviez
^k::Goto,Katz
~del::Goto,Delete
^l::Goto,scrapalllinks
^R::Gosub,Rescrapmovie
^1::Gosub,LCS
^2::Gosub,LMF1 
^3::Gosub,LMF2
^4::Gosub,LMF3
 Esc::Goto,GuiClose
 ;~Up::Gosub,Moviepreview
 ;~down::Gosub,Moviepreview
#IfWinActive,MovieFinder
Return
;______________________________________________________
;________INCLUDES______________________________________|
;#Include,%A_ScriptDir%\Data\live.genres.search.ahk
;#Include,%A_ScriptDir%\Data\IMDb.Charts.Top.Movies.ahk
;#Include,%A_ScriptDir%\Data\linkScraper.ahk
#Include,%A_ScriptDir%\Data\Function's.ahk
;#Include,%A_ScriptDir%\Data\settings.ahk
;#Include,%A_ScriptDir%\Data\newmovie.ahk
;#Include,%A_ScriptDir%\Data\ToolTip().ahk
Return
Exit:
2Buttonsetupdone:
 Reload
Return

GuiClose:
 ;FileRemoveDir,Temp,1
 ;FileCreateDir,Temp
 ExitApp
Return

/*
 * * * Compile_AHK SETTINGS BEGIN * * *

[AHK2EXE]
Exe_File=%In_Dir%\MovieFinder.exe
[VERSION]
Set_Version_Info=1
File_Description=Scrape movie links,Trailer's & poster info data from the net
File_Version=0.0.0.3
Inc_File_Version=1
Internal_Name=MovieFinder
Legal_Copyright=SonchazMedia 2010
Original_Filename=MovieFinder.ahk
Product_Name=MovieFinder
Product_Version=0.0.0.3
Inc_Product_Version=1
[ICONS]
Icon_1=%In_Dir%\img\MovieFinder.ico

* * * Compile_AHK SETTINGS END * * *
*/
