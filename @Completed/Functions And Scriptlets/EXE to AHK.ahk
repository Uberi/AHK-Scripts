#NoEnv

;MsgBox % GetScriptCode("Sudoku.exe")

GetScriptCode(Filename)
{
    hModule := DllCall("LoadLibrary","Str",Filename,"UPtr")
    If !hModule
        throw Exception("Could not load module.")
    hResource := DllCall("FindResource","UPtr",hModule,"Str",">AUTOHOTKEY SCRIPT<","UPtr",10,"UPtr") ;RT_RCDATA
    If !hResource
    {
        hResource := DllCall("FindResource","UPtr",hModule,"Str",">AHK WITH ICON<","UPtr",10,"UPtr") ;RT_RCDATA
        If !hResource
            throw Exception("Could not find script resource.")
    }
    DataSize := DllCall("SizeofResource","UPtr",hModule,"UPtr",hResource,"UInt")
    If !DataSize
        throw Exception("Could not obtain resource size.")
    hResourceData := DllCall("LoadResource","UPtr",hModule,"UPtr",hResource,"UPtr")
    If !hResourceData
        throw Exception("Could not load resource.")
    pData := DllCall("LockResource","UPtr",hResourceData,"UPtr")
    If !hResourceData
        throw Exception("Could not obtain data pointer.")
    If !DllCall("FreeLibrary","UPtr",hModule)
        throw Exception("Could not unload module.")
    Return, StrGet(pData,DataSize,"UTF-8")
}
