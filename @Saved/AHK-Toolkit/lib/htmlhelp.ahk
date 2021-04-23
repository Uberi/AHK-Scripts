htmlhelp(hwndCaller=0, pszFile="", dwData=""){
     
     static HH_KEYWORD_LOOKUP:=0xD

    VarSetCapacity(HH_AKLINK, HH_AKLINK_size := 8+5*A_PtrSize+4, 0) ; HH_AKLINK struct
    NumPut(HH_AKLINK_size, HH_AKLINK, 0, "UInt"),NumPut(&dwData, HH_AKLINK, 8)
    
    if (hwndCaller = "ForumHelper")
    {
        Loop, Parse, Clipboard,`n,`r
            if a_index > 1
                return
        ToolTip, % Clipboard

        if RegexMatch(Clipboard, "i)a_\w+")
            Match := matchclip("Variables")
        else if RegexMatch(Clipboard, "i)\s?(\w+)\(.*", fnct_name)
            Match := matchclip("Functions", fnct_name1)
        else
            Match := matchclip("Commands")
        
        ; httpRequest(Match, htm)
        if (InStr(htm, "403") || InStr(htm, "404") || !Match)
        {
            ToolTip, % "Not found. `nTrying a manual search, results may be inaccurate"
            Sleep 3*sec
            Match := matchclip("manual")
            if !Match
                ToolTip, % "Not found in the documentation files"
        }

        if WinActive("AutoHotkey Community")
            Send, {Raw}[url=%Match%]%Clipboard%[/url]
        else
            Run, % Match
        Sleep, 2*sec
        ToolTip
        return 0
    }
    
    if !DllCall("hhctrl.ocx\HtmlHelp", "Ptr", hwndCaller, "Str", pszFile, "Uint", HH_KEYWORD_LOOKUP, "Ptr", &HH_AKLINK)
    {
        Run, % pszFile
        Sleep 1000
        Send, !n%clipboard%{Enter}
    }
    return 0
}