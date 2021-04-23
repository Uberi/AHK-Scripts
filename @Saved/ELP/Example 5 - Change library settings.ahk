;Example 5 - Change library settings.ahk

Ptr := A_PtrSize ? "Ptr" : "UInt"

;#Include %A_ScriptDir%\ELP.ahk
;Uncomment if you do not have ELP.ahk in your standard library

;The MasterSettings function controls if the binary read/write functions should
;attempt to verify read or write operations as well as if the number of bytes
;read or written should be counted
;The MasterSettings function also contains the version number of the library

;The first paramater of the MasterSettings function determines what you want to do
;Get
;Set

;The second patamater of the MasterSettings function determines what value you want to
;get or set
;Get/Set | Verify_Writes
;Get/Set | Verify_Reads
;Get/Set | Count_BytesWritten
;Get/Set | Count_BytesRead
;Get | Version

;The third paramater of the MasterSettings function is used only when setting a value


;This will get the version number of the library
Version := ELP_MasterSettings("Get", "Version")

;This will get the current state of the Verify_Writes value
State := ELP_MasterSettings("Get","Verify_Writes")

;This toggles the State variable from true to false or from false to true
State := !State

;This sets the new value in the MasterSettings function
ELP_MasterSettings("Set", "Verify_Writes", State)