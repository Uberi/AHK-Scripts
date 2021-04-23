;AHK v1
#NoEnv

/*
SetBatchLines, -1

FileList := SearchFilePattern("C:\Users\Anthony\DropBox\AHK Scripts\*","iS)VarSetCapacity\(.{0,50}A_IsUnicode")
MsgBox "%FileList%"
Clipboard := FileList
ExitApp

Esc::ExitApp
*/

SearchFilePattern(FilePattern,SearchPattern,Recurse = 1)
{
 Loop, %FilePattern%,, %Recurse%
 {
  FileRead, Contents, %A_LoopFileLongPath%
  If RegExMatch(Contents,SearchPattern)
   MatchList .= "`n" . A_LoopFileLongPath
 }
 Return, SubStr(MatchList,2)
}