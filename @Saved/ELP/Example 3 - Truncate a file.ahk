;Example 3 - Truncate a file.ahk

Ptr := A_PtrSize ? "Ptr" : "UInt"

;#Include %A_ScriptDir%\ELP.ahk
;Uncomment if you do not have ELP.ahk in your standard library


;First a temp file is created that can be diced up with the functions below
;The file will have 4 lines of text as follows:
;Line 1`r`n
;Line 2`r`n
;Line 3`r`n
;Line 4`r`n
;The "`r`n" are windows newlines and you would not see them in the text file
;except as a physical new line of text
;Make sure the file doesn't already exist
FileDelete,%A_ScriptDir%\Truncate example.txt
;Now create the file with the correct contents
FileAppend,Line 1`r`nLine 2`r`nLine 3`r`nLine 4`r`n,%A_ScriptDir%\Truncate example.txt


;Now, a file handle must be created on the file that you want to truncate
;The file handle has to have generic write access to the file so Write is required
Handle := ELP_OpenFileHandle(A_ScriptDir . "\Truncate example.txt", "Write", FileSize)

;If the function fails to get write access to the file Handle will be set to -1 and FileSize
;will be set to 0
;If the file does not exist it will be created with a file size of 0 bytes
;But, because it was created above with the fileappend command it will always exist

;Now all that has to be done is to call the truncate function with the desired new size
;In this case the new size will be half of the old size
ELP_SetEndOfFile(Handle, FileSize // 2)

;The function will internally set the file pointer to half of the file size and then
;call the SetEndOfFile command to truncate the file there
;After the SetEndOfFile command is finished the function will return the file pointer
;to it's original position

;That means that if you had previously set the file pointer to the very end of a file
;and then you call the truncate command to trim it back
;any further read/write operations on the file will be executed at the old "end of a file"
;position
;You must ensure that you are always setting the file pointer to the desired location
;before you do any read or write operations on a file

;Now that the truncate command has finished the handle on the file can be closed
ELP_CloseFileHandle(Handle)

;No further operations have to be done - the file has been truncated to half of its original
;file size and everything has been cleaned up
Run,%A_ScriptDir%\Truncate example.txt