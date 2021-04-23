;Example 7 - LoopFilePattern (advanced).ahk

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

;A byref variable that will contain the current found file's file information
;FileInfo
;This value will contain binary information that can only be accessed through alternative
;methods

;A custom ID used to ensure that the file pattern loop does not collide with anything
;other loop file pattern in the script
;This does not need to be set and is only provided for other internal functions
;as well as those who may want to use it
;This value must be word-characters only (A-Za-z0-9_) as it will be used internally
;for a static variable
My_ID := "UniqueValue"

Loop
{
	;The first time a particular file path is called it will search for the first matching file
	;Every call after that will find the next file in that search
	;When no more files are found a blank string is returned: ""
	FoundFile := ELP_LoopFilePattern(FileName, IncludeFolders, Recurse, FileInfo, My_ID)
	
	;If any additional information about the found file is wanted the FileInfo variable
	;can be used
	
	;Gets the attributes of the current file
	Attributes := ELP_FileGetAttributesFromFI(FileInfo)
	
	;Gets the size (in bytes) of the current file
	SizeB := ELP_GetFileSizeFromFI(FileInfo, "B")
	
	;Gets the size (in kilobytes) of the current file
	SizeK := ELP_GetFileSizeFromFI(FileInfo, "K")
	
	;Gets the size (in megabytes) of the current file
	SizeM := ELP_GetFileSizeFromFI(FileInfo, "M")
	
	;Gets the size (in gigabytes) of the current file
	SizeG := ELP_GetFileSizeFromFI(FileInfo, "G")
	
	;Gets the modififed time of the current file
	ModifiedDate := ELP_FileGetTimeFromFI(FileInfo, "M") ;"M" is the default option and can be omitted
	
	;Gets the creation time of the current file
	CreationDate := ELP_FileGetTimeFromFI(FileInfo, "C")
	
	;Gets the accessed time of the current file
	AccessedDate := ELP_FileGetTimeFromFI(FileInfo, "A")
	
	;Gets just the name and extension of the current file
	NameOnly := ELP_GetNameFromFI(FileInfo)
	
	;Returns 16 (AKA true) if the current file is a directory else 0
	IsDirectory := ELP_IsDirectoryFromFI(FileInfo)
	
	
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
	
	MsgBoxContents =
	(LTrim Join`r`n
		Found file: %FoundFile%
		
		File attributes: %Attributes%
		Size in bytes: %SizeB%
		Size in kilobytes: %SizeK%
		Size in megabytes: %SizeM%
		Size in gigabytes: %SizeG%
		Modified date: %ModifiedDate%
		Creation date: %CreationDate%
		Accessed date: %AccessedDate%
		Just file name: %NameOnly%
		Is directory: %IsDirectory%
		
		Continue searching?
	)
	
	MsgBox,4,Continue?,%MsgBoxContents%
	
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