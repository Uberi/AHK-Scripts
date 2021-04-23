Archive := A_ScriptDir . "\MeseconEdit v1.6 Stable.zip"
Compiler := A_ProgramFiles . "\AutoHotkey\Compiler\Ahk2Exe.exe"

FileDelete, %Archive%

SplitPath, Compiler,, WorkingDir
SetWorkingDir, %WorkingDir%
RunWait, "%Compiler%" /in "%A_ScriptDir%\MeseconEdit.ahk" /out "%A_Temp%\MeseconEdit.exe" /icon "%A_ScriptDir%\Icon.ico" /bin "Unicode 32-bit.bin" /mpress 0
ZipCompress(A_Temp . "\MeseconEdit.exe",Archive)
FileDelete, %A_Temp%\MeseconEdit.exe

ZipCompress(A_ScriptDir . "\README.md",Archive)
ZipCompress(A_ScriptDir . "\LICENSE.txt",Archive)
ExitApp

ZipCompress(Path,Archive)
{
    If !FileExist(Path)
        throw Exception("Invalid path.")

    ;create empty zip archive if not present
    If !FileExist(Archive)
    {
        f := FileOpen(Archive,"w")
        f.Length := 22
        Header1 := "PK" . Chr(5) . Chr(6)
        f.Write(Header1)
        VarSetCapacity(Header2,18,0)
        f.RawWrite(Header2,18)
        f.Close()
    }

    ;create a COM object representing the archive
    cShell := ComObjCreate("Shell.Application")
    cZip := cShell.Namespace(Archive)

    ;obtain the number of items already present in the archive
    OriginalItems := cZip.Items.Count

    ;copy files to archive
    Options := 0x4 | 0x10 | 0x400 ;do not display a progress dialog box and respond with "Yes to All" for any dialog box that is displayed and do not display a user interface if an error occurs
    cZip.CopyHere(Path,Options)

    ;wait for the files to finish copying
    While, cZip.Items.Count < 1
        Sleep, 100
    Sleep, 100
}