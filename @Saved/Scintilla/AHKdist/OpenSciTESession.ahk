; Run SciTE with the loadsession option, with path correctly quoted
StringReplace path, 1, \, \\, All
Run %A_ScriptDir%\SciTE.exe "-loadsession:%path%"
