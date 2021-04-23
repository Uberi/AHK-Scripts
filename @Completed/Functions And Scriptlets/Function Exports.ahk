#NoEnv

;MsgBox % FunctionExports("shell32.dll")

FunctionExports(PEFile)
{
    ;load the image file
    VarSetCapacity(LoadedImage,21 + (A_PtrSize * 7),0)
    If !DllCall("ImageHlp\MapAndLoad","AStr",PEFile,"UPtr",0,"UPtr",&LoadedImage,"UInt",1,"UInt",1)
        throw Exception("Could not load image: " . PEFile)

    ;retrieve the export directory
    pBase := NumGet(LoadedImage,A_PtrSize << 1,"UPtr")
    pExportDirectory := DllCall("ImageHlp\ImageDirectoryEntryToData","UPtr",pBase,"UInt",0,"UShort",0,"UInt*",Length,"UPtr")
    If !pExportDirectory
    {
        DllCall("ImageHlp\UnMapAndLoad","UPtr",&LoadedImage)
        throw Exception("Could not retrieve export directory from image: " . PEFile)
    }

    ;retrieve virtual address from relative virtual address
    pFile := DllCall("ImageHlp\ImageRvaToVa","UPtr",NumGet(LoadedImage,A_PtrSize * 3,"UPtr"),"UPtr",pBase,"UInt",NumGet(pExportDirectory + 12),"UPtr",0,"UPtr")
    If !pFile
    {
        DllCall("ImageHlp\UnMapAndLoad","UPtr",&LoadedImage)
        throw Exception("Could not retrieve virtual address of image: " . PEFile)
    }

    ;retrieve exported names
    Result := ""
    Loop % NumGet(pExportDirectory + 24) + 1
    {
        Field := StrGet(pFile,"","CP0")
        Result .= Field . "`n"
        pFile += StrLen(Field) + 1
    }
    Result := SubStr(Result,1,-1)

    DllCall("ImageHlp\UnMapAndLoad","UPtr",&LoadedImage)

    Return, Result
}