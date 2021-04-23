SourceFolder = %A_ScriptDir%\tcclib\*
DestFolder = %A_ScriptDir% ;Where to create the folders of 200 mb
MaxSize = 20 ;mb
Recurse = 1
FolderName = FolderNumber

CurrentSize = 0
Index = 1
MaxSize *= 1000
TempSourceFolder := StrLen(SubStr(SourceFolder,1,InStr(SourceFolder,"\",False,0))) + 1
Loop, %SourceFolder%,, %Recurse%
{
 Temp1 := SubStr(A_LoopFileLongPath,TempSourceFolder)
 CurrentSize += A_LoopFileSize
 If (CurrentSize >= MaxSize)
 {
  Index ++
  CurrentSize = 0
 }
 SplitPath, Temp1,, Temp2
 IfNotExist, %DestFolder%\%FolderName%%Index%\%Temp2%
  FileCreateDir, %DestFolder%\%FolderName%%Index%\%Temp2%
 FileCopy, %A_LoopFileLongPath%, %DestFolder%\%FolderName%%Index%\%Temp1%
}