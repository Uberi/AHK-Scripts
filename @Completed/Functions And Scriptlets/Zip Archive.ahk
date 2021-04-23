#NoEnv

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
        Sleep, 1
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

    ;obtain the number of items already present in the path
    OriginalItems := cPath.Items.Count

    ;copy files to path
    Options := 0x4 | 0x10 | 0x400 ;do not display a progress dialog box and respond with "Yes to All" for any dialog box that is displayed and do not display a user interface if an error occurs
    cPath.CopyHere(cZip.Items,Options)

    ;wait for the files to finish copying
    While, (cPath.Items.Count - OriginalItems) < 1
        Sleep, 1
}