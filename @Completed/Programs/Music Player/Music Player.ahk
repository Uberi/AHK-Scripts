#NoEnv

SongListPath = %A_ScriptDir%\SongList.txt

Critical
Alias = AudioFile
FolderList = All||Untagged
Menu, Tray, NoStandard
Menu, Tray, Add, Show Window, ShowWindow
Menu, Tray, Add
Menu, Tray, Add, Exit, GuiClose
Menu, Tray, Default, Show Window
Menu, Tray, Click, 1

Gui, Font, s16 Bold, Arial
Gui, Add, Text, x2 y0 w450 h30 Center, Music Player
Gui, Font, s12
Gui, Add, Text, x2 y30 w120 h25, Current Song:
Gui, Font, s13 Norm
Gui, Add, Edit, x122 y30 w330 h25 vCurrentSong ReadOnly, None
Gui, Font, Bold
Gui, Add, Button, x2 y60 w80 h30 vPlayPause gPlayPause Disabled Default, Play
Gui, Font, s12 Norm
Gui, Add, Button, x82 y60 w50 h30 vStop gStop Disabled, Stop
Gui, Font, s10 Bold
Gui, Add, Button, x142 y60 w180 h30 vToggleSongList gToggleSongList, Show Song List
Gui, Font, Norm
Gui, Add, Button, x332 y60 w60 h30 vPrevious gPrevious Disabled, Previous
Gui, Add, Button, x392 y60 w60 h30 vNext gNext Disabled, Next
Gui, Add, Slider, x2 y90 w450 h20 vProgress gSeek Range1-1000 Page20 Center AltSubmit NoTicks Disabled, 0
Gui, Font, s8
Gui, Add, Text, x2 y110 w80 h20 vStatus, Stopped
Gui, Add, Text, x92 y110 w90 h20 vTimes Right, 0:00 / 0:00
Gui, Font, Bold
Gui, Add, Text, x192 y110 w140 h20, Tags:
Gui, Font, Norm
Gui, Add, Edit, x232 y110 w110 h20 vTags ReadOnly
Gui, Font, Bold
Gui, Add, Button, x352 y110 w100 h20 vLoadMusic gLoadMusic, Load Music
Gui, Font, Norm
Gui, Add, Radio, x2 y130 w90 h20 vPlayMode Checked, Play one song
Gui, Add, Radio, x182 y130 w100 h20, Play from current
Gui, Add, Radio, x372 y130 w80 h20, Play random
Gui, Font, s10 Bold
Gui, Add, Text, x2 y160 w50 h20, Filter:
Gui, Font, Norm
Gui, Add, DropDownList, x52 y160 w100 h20 r10 vFilter gSearch Disabled, %FolderList%
Gui, Font, Bold
Gui, Add, Text, x162 y160 w50 h20, Search:
Gui, Font, Norm
Gui, Add, Edit, x222 y160 w230 h20 vSearch gStartSearch Disabled
Gui, Add, ListView, x2 y190 w450 h190 vSongList gSelectSong -Multi AltSubmit Disabled, Song|Tags|Path
Gui, Add, Text, x2 y380 w160 h20 vResultCount, 0 Result(s)
Gui, Font, Bold
Gui, Add, Button, x172 y380 w140 h20 vEditInfo gEditInfo Disabled, Edit Info
Gui, Add, Button, x312 y380 w140 h20 vRemove gRemove Disabled, Remove
GuiControl, Focus, LoadMusic
Gui, +AlwaysOnTop
hWinMM := DllCall("LoadLibrary","Str","winmm.dll")
Gosub, LoadSongList
Gui, Show, h155 w455, Music Player
OnExit, SaveSongList
Return

GuiClose:
ExitApp

^!Enter::Gosub, ShowWindow
^!Space::Gosub, PlayPause
^!Left::Gosub, Previous
^!Right::Gosub, Next

StartSearch:
SetTimer, Search, -200
Return

Search:
GuiControlGet, Search,, Search
TempLength := StrLen(Search)
Loop, Parse, SongList, `n
{
 StringSplit, Temp, A_LoopField, %A_Tab%
 % (SubStr(Temp1,1,TempLength) = Search) ? TempSongList := "`n" . A_LoopField . TempSongList : (InStr(Temp1,Search) ? TempSongList .= "`n" . A_LoopField)
}
StringTrimLeft, TempSongList, TempSongList, 1
GuiControl, +AltSubmit, Filter
GuiControlGet, Filter,, Filter
GuiControl, -AltSubmit, Filter
GuiControl, -Redraw, SongList
LV_Delete()
If Filter = 1
{
 Loop, Parse, TempSongList, `n
 {
  StringSplit, Temp, A_LoopField, %A_Tab%
  LV_Add("",Temp1,Temp2,Temp3)
 }
}
Else If  Filter = 2
{
 Loop, Parse, TempSongList, `n
 {
  StringSplit, Temp, A_LoopField, %A_Tab%
  % (Temp2 = "") ? LV_Add("",Temp1,Temp2,Temp3)
 }
}
Else
{
 GuiControlGet, Filter,, Filter
 Loop, Parse, TempSongList, `n
 {
  StringSplit, Temp, A_LoopField, %A_Tab%
  InStr("," . Temp2 . ",","," . Filter . ",") ? LV_Add("",Temp1,Temp2,Temp3)
 }
}
TempSongList := "", Temp1 := LV_GetCount()
UseButtons(!!Temp1)
LV_Modify(1,"Select Focus")
If Search = 
 LV_ModifyCol(1,"Sort"), LV_ModifyCol(2,"Sort")
GuiControl,, ResultCount, %Temp1% Result(s)
GuiControl, +Redraw, SongList
Return

SaveSongList:
DllCall("FreeLibrary","UInt",hWinMM)
If ListChanged
{
 FileDelete, %SongListPath%
 FileAppend, %SongList%, %SongListPath%
}
ExitApp

Previous:
Temp1 := LV_GetNext() - 1, !Temp1 ? Temp1 := LV_GetCount()
LV_Modify(Temp1,"Select Focus Vis")
Gosub, ShowInfo
Gosub, Stop
Gosub, PlayPause
Return

Next:
Temp1 := LV_GetNext(), Temp1 := (Temp1 = LV_GetCount()) ? 1 : Temp1 + 1, LV_Modify(Temp1,"Select Focus Vis")
Gosub, ShowInfo
Gosub, Stop
Gosub, PlayPause
Return

Seek:
If A_GuiEvent In Normal,4
{
 ToolTip
 SetTimer, UpdateInfo, On
 GuiControlGet, Temp1,, Progress
 Temp1 := Round((Temp1 / 1000) * SongLength), MediaSeek(Alias,Temp1), Playing ? MediaPlay(Alias)
 Seeking = 0
}
Else If Not Seeking
{
 SetTimer, UpdateInfo, Off
 MediaPause(Alias), Seeking := 1
}
Else If A_GuiEvent = 5
{
 GuiControlGet, Temp1,, Progress
 Temp1 := Round((Temp1 / 1000) * SongLength), Temp2 := "", MediaMillisecondsToTime(Temp1,SongHours,SongMinutes,SongSeconds), SongHours ? Temp2 := SongHours . ":" . SubStr("0" . SongMinutes,-1) : Temp2 := SongMinutes, Temp2 .= ":" . SubStr("0" . SongSeconds,-1)
 ToolTip, %Temp2%
}
Return

PlayPause:
If ListFocused
{
 LV_GetText(Temp1,LV_GetNext(),3)
 If Temp1 <> %CurrentSong%
 {
  Gosub, Stop
  Gosub, ShowInfo
 }
}
If Playing
{
 Playing = 0
 GuiControl,, PlayPause, Play
 GuiControl,, Status, Paused
 MediaPause(Alias)
 SetTimer, UpdateInfo, Off
}
Else
{
 Playing = 1
 GuiControl,, PlayPause, Pause
 GuiControl,, Status, Playing
 MediaPlay(Alias)
 SetTimer, UpdateInfo, 500
}
Return

Stop:
Playing = 0
GuiControl,, PlayPause, Play
MediaStop(Alias)
GuiControl,, Progress, 0
GuiControl,, Times, 0:00 / %SongLengthTime%
GuiControl,, Status, Stopped
SetTimer, UpdateInfo, Off
Return

SelectSong:
If A_GuiEvent = A
{
 Gosub, Stop
 Gosub, ShowInfo
 Gosub, PlayPause
}
Else If A_GuiEvent = F
 ListFocused := (A_GuiEvent == "F")
Return

UpdateInfo:
PositionTime := "", MediaPosition(Alias,Position), MediaMillisecondsToTime(Position,SongHours,SongMinutes,SongSeconds), SongHours ? PositionTime := SongHours . ":" . SubStr("0" . SongMinutes,-1) : PositionTime := SongMinutes, PositionTime .= ":" . SubStr("0" . SongSeconds,-1)
If Position >= %SongLength%
{
 Gui, Submit, NoHide
 If PlayMode = 1
 {
  Gosub, Stop
  Gosub, PlayPause
 }
 Else If PlayMode = 2
  Gosub, Next
 Else
 {
  Random, Temp1, 1, LV_GetCount()
  LV_Modify(Temp1,"Select Focus Vis")
  Gosub, ShowInfo
  Gosub, Stop
  Gosub, PlayPause
 }
 Return
}
GuiControl,, Times, %PositionTime% / %SongLengthTime%
GuiControl,, Progress, % (Position / SongLength) * 1000
Return

ShowInfo:
Temp1 := LV_GetNext()
LV_GetText(Temp2,Temp1,1)
GuiControl,, CurrentSong, %Temp2%
LV_GetText(Temp2,Temp1,2)
GuiControl,, Tags, %Temp2%
LV_GetText(CurrentSong,Temp1,3)
MediaClose(Alias)
MediaOpen(CurrentSong,Alias)
SongLengthTime := "", MediaLength(Alias,SongLength), MediaMillisecondsToTime(SongLength,SongHours,SongMinutes,SongSeconds), SongHours ? SongLengthTime := SongHours . ":" . SubStr("0" . SongMinutes,-1) : SongLengthTime := SongMinutes, SongLengthTime .= ":" . SubStr("0" . SongSeconds,-1)
Return

LoadMusic:
Gui, +OwnDialogs
FileSelectFile, Files, M3,, Select one or more music files, *.mp3`; *.wav
If ErrorLevel
 Return
;SongTags := SubStr(RegExReplace("," . SongTags . ","," *, *",","),2,-1)
Temp1 := (SongList = ""), Temp2 := InStr(Files,"`n"), Path := SubStr(Files,1,Temp2 - 1), (SubStr(Path,0,1) <> "\") ? Path .= "\"
Files := SubStr(Files,Temp2 + 1)
GuiControl, -Redraw, SongList
Loop, Parse, Files, `n
{
 SplitPath, A_LoopField,,,, Temp2
 Temp3 := Path . A_LoopField, !InStr(SongList . "`n",A_Tab . Temp3 . "`n") ? (LV_Add("",Temp2,SongTags,Temp3), SongList .= "`n" . Temp2 . A_Tab . SongTags . A_Tab . Temp3, ListChanged := 1)
}
LV_Modify(LV_GetCount(),"Select Focus Vis")
LV_ModifyCol(1,"Sort")
LV_ModifyCol(2,"Sort")
GuiControl, +Redraw, SongList
If Temp1
{
 StringTrimLeft, SongList, SongList, 1
 UseButtons(1)
 LV_Modify(1,"Select Focus Vis")
}
Gosub, ShowInfo
Gosub, UpdateInfo
Loop, Parse, SongTags, CSV
{
 If InStr("|" . FolderList . "|","|" . A_LoopField . "|")
  Continue
 FolderList .= "|" . A_LoopField
 GuiControl,, Filter, %A_LoopField%
}
ListChanged = 1
GuiControl, Focus, PlayPause
Return

LoadSongList:
LV_ModifyCol(1,"130 Sort")
LV_ModifyCol(2,"80 Sort")
LV_ModifyCol(3,"AutoHdr")
IfNotExist, %SongListPath%
 Return
FileRead, SongList, %SongListPath%
If SongList = 
 Return
StringReplace, SongList, SongList, `r,, All
GuiControl, -Redraw, SongList
Loop, Parse, SongList, `n
{
 StringSplit, Temp, A_LoopField, %A_Tab%
 LV_Add("",Temp1,Temp2,Temp3)
 If Not InStr("|" . FolderList . "|","|" . Temp2 . "|")
 {
  FolderList .= "|" . Temp2
  GuiControl,, Filter, %Temp2%
 }
}
LV_ModifyCol(3,"AutoHdr")
GuiControl, +Redraw, SongList
GuiControl,, ResultCount, % LV_GetCount() . " Result(s)"
UseButtons(1)
LV_Modify(1,"Select Focus")
Gosub, ShowInfo
GuiControl, Focus, PlayPause
Return

ToggleSongList:
If SongListShown
{
 SongListShown = 0
 GuiControl,, ToggleSongList, Show Song List
 GuiControl, Disable, Filter
 GuiControl, Disable, Search
 GuiControl, Disable, SongList
 Gui, Show, h155 w455, Music Player
}
Else
{
 SongListShown = 1
 GuiControl,, ToggleSongList, Hide Song List
 GuiControl, Enable, Filter
 GuiControl, Enable, Search
 GuiControl, Enable, SongList
 GuiControl, Focus, SongList
 Gui, Show, h400 w455, Music Player
}
Return

EditInfo:
Temp3 := LV_GetNext(), LV_GetText(Temp1,Temp3,1), LV_GetText(Temp2,Temp3,2)
Gui, 2:+Owner1
Gui, 1:+Disabled
Gui, 2:Default
Gui, 2:Font, s12 Bold, Arial
Gui, 2:Add, Text, x2 y5 w60 h25, Name:
Gui, 2:Add, Edit, x62 y5 w140 h25 vNewName gCheckInfo, %Temp1%
Gui, 2:Add, Text, x212 y5 w50 h25, Tags:
Gui, 2:Add, Edit, x262 y5 w140 h25 vNewTags gCheckInfo, %Temp2%
Gui, 2:Add, Button, x412 y5 w60 h25 vSaveInfo gSaveInfo Default Disabled, Save
Gui, +ToolWindow +AlwaysOnTop
Gosub, CheckInfo
Gui, 2:Show, w475 h35, Settings
Return

CheckInfo:
Gui, 2:Submit, NoHide
Temp4 := (NewName = "" || (NewName = Temp1 && NewTags = Temp2))
GuiControl, 2:Disable%Temp4%, SaveInfo
Return

2GuiEscape:
2GuiClose:
Gui, 2:Destroy
Gui, 1:-Disabled
Gui, 1:Show
Return

SaveInfo:
Gui, 2:Submit
Gui, 2:Destroy
Gui, 1:Default
ListChanged := 1, LV_Modify(Temp3,"",NewName,NewTags)
Temp2 := "`n" . SongList . "`n"
StringGetPos, Temp3, Temp2, `n, L%Temp3%
StringGetPos, Temp4, Temp2, %A_Tab%, L2, Temp3 + 2
SongList := SubStr(SubStr(Temp2,1,Temp3) . "`n" . NewName . A_Tab . NewTags . SubStr(Temp2,Temp4 + 1),2,-1)
Gosub, Search
Gui, -Disabled
Gui, Show
Return

Remove:
ListChanged := 1, Temp1 := LV_GetNext(), Temp2 := "`n" . SongList . "`n"
LV_Delete(Temp1), TempLength := LV_GetCount(), LV_Modify((TempLength <> 1) ? Temp1 - (Temp1 = (TempLength + 1)) : 1,"Select Focus")
StringGetPos, Temp3, Temp2, `n, L%Temp1%
SongList := SubStr(SubStr(Temp2,1,Temp3) . SubStr(Temp2,InStr(Temp2,"`n",False,Temp3 + 2)),2,-1)
UseButtons(!!TempLength)
Return

ShowWindow:
Gui, Show
Return

GuiSize:
If A_EventInfo <> 1
 Return
GuiEscape:
Gui, Hide
Return

UseButtons(Use)
{
 GuiControl, Enable%Use%, PlayPause
 GuiControl, Enable%Use%, Stop
 GuiControl, Enable%Use%, Progress
 GuiControl, Enable%Use%, EditInfo
 GuiControl, Enable%Use%, Remove
 Use ? Use := (LV_GetCount() <> 1)
 GuiControl, Enable%Use%, Previous
 GuiControl, Enable%Use%, Next
}

;All functions return 0 on success, 1 on failure

MediaOpen(ByRef FileName,ByRef Alias)
{
 Return, !!DllCall("winmm\mciSendString","Str","open """ . FileName . """ alias " . Alias,"UInt",0,"Int",0,"UInt",0,"Cdecl")
}

MediaClose(ByRef hMedia)
{
 Return, !!DllCall("winmm\mciSendString","Str","close " . hMedia,"UInt",0,"Int",0,"UInt",0,"Cdecl")
}

MediaPlay(ByRef hMedia,Wait = 0)
{
 Return, !!DllCall("winmm\mciSendString","Str","play " . hMedia . (Wait ? " wait" : ""),"UInt",0,"Int",0,"UInt",0,"Cdecl")
}

MediaStop(ByRef hMedia)
{
 Return, (DllCall("winmm\mciSendString","Str","seek " . hMedia . " to start","UInt",0,"Int",0,"UInt",0,"Cdecl") && DllCall("winmm\mciSendString","Str","stop " . hMedia,"UInt",0,"Int",0,"UInt",0,"Cdecl"))
}

MediaPause(ByRef hMedia)
{
 Return, !!DllCall("winmm\mciSendString","Str","pause " . hMedia,"UInt",0,"Int",0,"UInt",0,"Cdecl")
}

MediaResume(ByRef hMedia)
{
 Return, !!DllCall("winmm\mciSendString","Str","resume " . hMedia,"UInt",0,"Int",0,"UInt",0,"Cdecl")
}

MediaLength(ByRef hMedia,ByRef Length)
{
 If (DllCall("winmm\mciSendString","Str","set time format milliseconds","UInt",0,"Int",0,"UInt",0,"Cdecl") <> 263)
  Return, 1
 VarSetCapacity(Length,36,0), DllCall("winmm\mciSendString","Str","status " . hMedia . " length","UInt",&Length,"UInt",36,"UInt",0,"Cdecl")
 Return, 0
}

MediaSeek(ByRef hMedia,ByRef Position)
{
 If (DllCall("winmm\mciSendString","Str","set time format milliseconds","UInt",0,"Int",0,"UInt",0,"Cdecl") <> 263)
  Return, 1
 VarSetCapacity(MediaStatus,36,0), DllCall("winmm\mciSendString","Str","status " . hMedia . " mode","UInt",&MediaStatus,"UInt",36,"UInt",0,"Cdecl")
 Return, (DllCall("winmm\mciSendString","Str","seek " . hMedia . " to " . Position,"UInt",0,"Int",0,"UInt",0,"Cdecl") || ((MediaStatus = "playing") ? DllCall("winmm\mciSendString","Str","play " . hMedia,"UInt",0,"Int",0,"UInt",0,"Cdecl")))
}

MediaStatus(ByRef hMedia,ByRef MediaStatus)
{
 VarSetCapacity(MediaStatus,36,0), DllCall("winmm\mciSendString","Str","status " . hMedia . " mode","UInt",&MediaStatus,"UInt",36,"UInt",0,"Cdecl")
 Return, 0
}

MediaPosition(ByRef hMedia,ByRef CurrentPos)
{
 If (DllCall("winmm\mciSendString","Str","set time format milliseconds","UInt",0,"Int",0,"UInt",0,"Cdecl") <> 263)
  Return, 1
 VarSetCapacity(CurrentPos,36,0), DllCall("winmm\mciSendString","Str","status " . hMedia . " position","UInt",&CurrentPos,"UInt",36,"UInt",0,"Cdecl")
 Return, 0
}

MediaTimeToMilliseconds(ByRef Milliseconds,ByRef TimeHours,ByRef TimeMinutes,ByRef TimeSeconds)
{
 Milliseconds := (TimeSeconds * 1000) + (TimeMinutes * 60000) + (TimeHours * 3600000)
 Return, 0
}

MediaMillisecondsToTime(ByRef Milliseconds,ByRef TimeHours,ByRef TimeMinutes,ByRef TimeSeconds)
{
 Temp1 := Milliseconds // 1000, TimeSeconds := Mod(Temp1,60), Temp1 //= 60, TimeMinutes := Mod(Temp1,60), Temp1 //= 60, TimeHours := Mod(Temp1,60)
 Return, 0
}