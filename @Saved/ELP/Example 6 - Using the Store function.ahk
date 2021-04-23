;Example 6 - Using the Store functions.ahk

Ptr := A_PtrSize ? "Ptr" : "UInt"

;#Include %A_ScriptDir%\ELP.ahk
;Uncomment if you do not have ELP.ahk in your standard library


;The StoreBytes function counts the number of bytes read or written
;by the WriteData and ReadData functions if the setting was enabled in the
;MasterSettings function

;The first paramater of the StoreBytes function is the command to execute
;AddRead
;AddWrite
;GetRead
;GetWrite
;ResetRead
;ResetWrite

;The second paramater of the StoreBytes function is the value to added when using
;the AddRead or AddWrite command

;This gets the total number of bytes written that the script has recorded
BytesWritten := ELP_StoreBytes("GetWrite")

;This gets the total number of bytes read that the script has recorded
BytesRead := ELP_StoreBytes("GetRead")

;This resets the bytes read counter
ELP_StoreBytes("ResetRead")

;This resets the bytes written counter
ELP_StoreBytes("ResetWrite")