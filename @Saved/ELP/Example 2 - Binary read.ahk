;Example 2 - Binary read.ahk

Ptr := A_PtrSize ? "Ptr" : "UInt"

;#Include %A_ScriptDir%\ELP.ahk
;Uncomment if you do not have ELP.ahk in your standard library


;This will open the file for read access and set FileSize to the size of the file.
;If the file doesn't exist and you open it with read access Handle will be -1
;and FileSize will be 0
;If the file is locked by another program and Read access is denied Handle will be -1
;and FileSize will be 0

Handle := ELP_OpenFileHandle(A_ScriptFullPath, "Read", FileSize)

;This sets the variable Data to the needed size to hold the contents of the file
VarSetCapacity(Data,FileSize,0)

;This will read the contents number of bytes specified by FileSize
;into the Data variable based of the file opened above by using the Handle variable
;The default read or write position of a file is always 0 (start of file) when
;first opened
;That means that when the funtion below is executed it will begin reading data
;at the begining of the file
;You do not have to read the entire file at once - you can specify any number of bytes
;to read. But, for this example it will read the entire file
ELP_ReadData(Handle, &Data, FileSize)

;The variable Data now contains an exact copy (byte for byte) of the contents of
;the file opened above
;Because of the read operation on the file the pointer on the file is now set to the end
;of the file: reading 5 bytes moves the pointer forward 5 bytes
;Because the function was just told to read the length of the file from byte 0 the
;pointer is now at the end of the file
;Any further read operations will try to read from the end of the file (no data)

;To move the pointer back to the beginning of the file the ELP_SetFilePointer function can
;be used

;This sets the pointer on the file to the desired location (0 in this case)
;This is not needed if you only want to read the file once but it is just here
;as an example of how to use it
;Every time a file is opened the default read or write position is set to 0
ELP_SetFilePointer(Handle, 0)

;This function will close the handle created above properly closing the file and releasing it
;for other programs to use

ELP_CloseFileHandle(Handle)

;Because of the way the Read handle is created other programs can also request read
;operations on the file as well as write operations
;Not all programs will allow files to be read while they are reading them
;Each program determines how other programs can access files when they open file handles on them