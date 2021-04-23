#NoEnv

FileSelectFolder, SortPath, *%A_ScriptDir%,, Please Select A Folder To Sort
If ErrorLevel
 ExitApp
FileSelectFolder, DestPath, *%A_ScriptDir%,, Please Select A Destination Folder
If ErrorLevel
 ExitApp
MsgBox, 35, Action, Should files be moved instead of copied?
IfMsgBox, Yes
 MoveOrCopy = 1
Else IfMsgBox, Cancel
 ExitApp
MsgBox, 35, Recursion, Should recursion be used on folders?
IfMsgBox, Yes
 Recurse = 1
Else IfMsgBox, Cancel
 ExitApp

Categories =
(
Documents = doc,pdf,rtf,txt,xls
Pictures = png,jpg,gif,bmp
Videos = avi,wmv,mpg
Music = mp3,wma,ogg
)

IfNotExist, %SortPath%
 ExitApp
Loop, Parse, Categories, `n
{
 StringLeft, FolderName, A_LoopField, InStr(A_LoopField, "=") - 1
 FolderName = %FolderName%
 StringTrimLeft, Temp1, A_LoopField, InStr(A_LoopField,"=")
 Temp1 = %Temp1%
 Loop, Parse, Temp1, CSV
 {
  Loop, %SortPath%\*.%A_LoopField%,, %Recurse%
  {
   IfNotExist, %DestPath%\%FolderName%
    FileCreateDir, %DestPath%\%FolderName%
   If MoveOrCopy
    FileMove, %A_LoopFileFullPath%, %DestPath%\%FolderName%
   Else
    FileCopy, %A_LoopFileFullPath%, %DestPath%\%FolderName%
  }
 }
}