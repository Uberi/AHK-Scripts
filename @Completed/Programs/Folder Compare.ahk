#NoEnv

FileSelectFolder, Folder1, ::{20d04fe0-3aea-1069-a2d8-08002b30309d}, 7, Please select the first folder to compare
If ErrorLevel
 ExitApp
FileSelectFolder, Folder2, *%Folder1%, 7, Please select the second folder to compare
If ErrorLevel
 ExitApp
MsgBox, 36, Recursion, Should recursion be used on folders?
IfMsgBox, Yes
 Recurse = 1
Loop, %Folder1%\*,, %Recurse%
 FileList1 = %FileList1%`n%A_LoopFileName%
Loop, %Folder2%\*,, %Recurse%
 FileList2 = %FileList2%`n%A_LoopFileName%
FileList1 = %FileList1%`n
FileList2 = %FileList2%`n
Loop, Parse, FileList1, `n
{
 IfNotInString, FileList2, `n%A_LoopField%`n
  DifferenceList = %DifferenceList%`n%A_LoopField%
}
Loop, Parse, FileList2, `n
{
 IfNotInString, FileList1, `n%A_LoopField%`n
  DifferenceList = %DifferenceList%`n%A_LoopField%
}
FileSelectFile, FileName, S50, %A_Desktop%\Difference Log.txt, Please select the path for the log file
IfExist, %FileName%
 FileDelete, %FileName%
FileAppend, %DifferenceList%, %FileName%