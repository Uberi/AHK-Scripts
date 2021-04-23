#NoEnv

TempPath := A_Temp
DestinationPath := "C:\Users\Anthony\Dropbox\AHK Scripts\@Completed\Resources\Scite4AutoHotkey\AutoHotkey"

FileCreateDir, %DestinationPath%

;download the portable versions
AttemptDownload("http://ahkscript.org/download/ahk-u32.zip",TempPath . "\ahk-u32.zip","AutoHotkey_L Unicode 32-bit")
UnzipInstall(TempPath . "\ahk-u32.zip",DestinationPath . "\AutoHotkeyU32.exe")
AttemptDownload("http://ahkscript.org/download/ahk-u64.zip",TempPath . "\ahk-u64.zip","AutoHotkey_L Unicode 64-bit")
UnzipInstall(TempPath . "\ahk-u64.zip",DestinationPath . "\AutoHotkeyU64.exe")
AttemptDownload("http://ahkscript.org/download/ahk-a32.zip",TempPath . "\ahk-a32.zip","AutoHotkey_L ANSI 32-bit")
UnzipInstall(TempPath . "\ahk-a32.zip",DestinationPath . "\AutoHotkeyA32.exe")
FileCopy, %DestinationPath%\AutoHotkeyU64.exe, %DestinationPath%\AutoHotkey.exe, 1 ;set unicode 64-bit as default

;download the help file
AttemptDownload("http://ahkscript.org/download/1.1/AutoHotkeyHelp.zip",TempPath . "\AutoHotkeyHelp.zip","AutoHotkey_L Help File")
UnzipInstall(TempPath . "\AutoHotkeyHelp.zip",DestinationPath . "\AutoHotkey.chm")

;clear the directory
FileRemoveDir, %A_Temp%\UnzipFolder, 1
FileCreateDir, %A_Temp%\UnzipFolder

;download the compiler
AttemptDownload("http://ahkscript.org/download/ahk2exe.zip",TempPath . "\ahk2exe.zip","AutoHotkey_L Compiler")
FileCreateDir, %DestinationPath%\Compiler
UnzipInstall(TempPath . "\ahk2exe.zip",DestinationPath . "\Compiler")
FileCopy, %DestinationPath%\Compiler\Unicode 64-bit.bin, %DestinationPath%\Compiler\AutoHotkeySC.bin, 1 ;set unicode 64-bit as default

;download the compiler source code
AttemptDownload("https://github.com/fincs/Ahk2Exe/zipball/master",TempPath . "\AutoHotkey_L_Compiler.zip","AutoHotkey_L Compiler Source")
ZipDecompress(TempPath . "\AutoHotkey_L_Compiler.zip",A_Temp . "\UnzipFolder")
Loop, %A_Temp%\UnzipFolder\*, 1
{
    FileRemoveDir, %DestinationPath%\Compiler\Ahk2Exe, 1
    FileDelete, %A_LoopFileLongPath%\.gitignore
    FileCopyDir, %A_LoopFileLongPath%, %DestinationPath%\Compiler\Ahk2Exe
    Break
}
FileDelete, %TempPath%\AutoHotkey_L_Compiler.zip
FileRemoveDir, %A_Temp%\UnzipFolder, 1

;install the latest AHK_L
AttemptDownload("http://ahkscript.org/download/ahk-install.exe",DestinationPath . "\..\..\ahk-install.exe","AutoHotkey_L Installer")
RunWait, "%DestinationPath%\..\..\ahk-install.exe" /S
Return

AttemptDownload(URL,Destination,Name)
{
    Loop
    {
        URLDownloadToFile, %URL%, %Destination%
        If ErrorLevel
        {
            MsgBox, 18, Error, Could not download %Name%.
            IfMsgBox, Abort
                ExitApp
            IfMsgBox, Retry
                Continue
        }
        Break
    }
}

UnzipInstall(Source,Destination)
{
    FileCreateDir, %A_Temp%\UnzipFolder
    FileDelete, %A_Temp%\UnzipFolder\*
    Loop
    {
        try ZipDecompress(Source,A_Temp . "\UnzipFolder")
        catch
        {
            MsgBox, 18, Error, Could not unzip %Course%.
            IfMsgBox, Abort
                ExitApp
            IfMsgBox, Retry
                Continue
        }
        FileDelete, %Source%
        If InStr(FileExist(Destination),"D") ;unzip to directory
            MoveFilesAndFolders(A_Temp . "\UnzipFolder\*",Destination,1)
        Else ;unzip to file
            FileMove, %A_Temp%\UnzipFolder\*, %Destination%, 1
        Break
    }
    FileRemoveDir, %A_Temp%\UnzipFolder, 1
}

ZipDecompress(Archive,Path)
{
    ;create path if it does not already exist
    If !InStr(FileExist(Path),"D")
        FileCreateDir, %Path%

    ;create a COM object representing the archive
    cShell := ComObjCreate("Shell.Application")
    cZip := cShell.Namespace(Archive)

    ;create a COM object representing the path
    cShell := ComObjCreate("Shell.Application")
    cPath := cShell.Namespace(Path)

    ;obtain the number of items already present in the archive
    OriginalItems := cPath.Items.Count

    ;copy files to path
    Options := 0x4 | 0x10 | 0x400 ;do not display a progress dialog box and respond with "Yes to All" for any dialog box that is displayed and do not display a user interface if an error occurs
    cPath.CopyHere(cZip.Items,Options)

    ;wait for the files to finish copying
    StartTime := A_TickCount
    While, (cPath.Items.Count - OriginalItems) < 1
    {
        Sleep, 1
        If A_TickCount - StartTime > 5000
            throw Exception("Copy timeout", -1)
    }
}

MoveFilesAndFolders(SourcePattern, DestinationFolder, DoOverwrite = false)
{
    FileMove, %SourcePattern%, %DestinationFolder%, %DoOverwrite%
    ErrorCount := ErrorLevel
    if DoOverwrite = 1
        DoOverwrite = 2
    Loop, %SourcePattern%, 2  ; 2 means "retrieve folders only".
    {
        FileMoveDir, %A_LoopFileFullPath%, %DestinationFolder%\%A_LoopFileName%, %DoOverwrite%
        ErrorCount += ErrorLevel
    }
    return ErrorCount
}