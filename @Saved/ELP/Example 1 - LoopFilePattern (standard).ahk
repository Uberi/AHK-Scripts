;Example 1 - LoopFilePattern (standard).ahk

Ptr := A_PtrSize ? "Ptr" : "UInt"

;#Include %A_ScriptDir%\ELP.ahk
;Uncomment if you do not have ELP.ahk in your standard library



;The path and file pattern to search for
FileName := A_Desktop . "\*.*"

;Valid values for IncludeFolders are: 0, 1 or 2.
;0 being default - do not include folder names when searching files
;1 - include folder names when searching files
;2 - ONLY include folder names when searching files
IncludeFolders := 1

;Valid values for Recurse are: 0, 1 or 2.
;0 being default - do not recurse into sub folders
;1 - recurse into sub folders
;2 - recurse into subfolders that match the search pattern
Recurse := 1

Loop
{
	;The first time a particular file path is called it will search for the first matching file
	;Every call after that will find the next file in that search
	;When no more files are found a blank string is returned: ""
	FoundFile := ELP_LoopFilePattern(FileName, IncludeFolders, Recurse)
	
	;If the found file is a blank string: "" then the search is done
	;If the found file is blank that means that either there where no found files
	;Or the search is done
	;If you do not break out of the loop the next time around it will start the search again from the start
	If (FoundFile = "")
		Break
	
	;If the above "If ..." statement did not break out of the loop then FoundFile contains
	;the full path and name of the found file
	;For vista/7 users:
	;C:\Users\%Username%\Desktop\*Name of found file*.*Extension*
	
	MsgBox,4,Continue?,Found file: %FoundFile%`n`nContinue searching?
	
	;This will cancel the file search and cleanup everything it needs internally
	;If the search natrually ends (no more files found) then it will do this automatically
	;Else, if you do not call this when breaking out of a file loop
	;Any calls to the same file pattern will resume where this one left off
	IfMsgBox,No
	{
		ELP_LoopFilePattern(FileName, "Close")
		Break
	}
}