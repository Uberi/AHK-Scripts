
Msgbox % "Beginning test: Look at current memory use"

Loop, 9000
{
	ScriptControlTest()
	Sleep, 100
}
	
Msgbox % "End of test: Memory use shouldn't be much larger than at the start"
Return

ScriptControlTest()
{
	; Initialize COM
	iErr := DllCall("ole32\CoInitialize", "UInt", 0, "Int")
	
	If (iErr <> 0)
		ExitWithError("Failed to initialize COM")
	
	; Convert ProgramID and InterfaceID to unicode 
	ProgId_ScriptControl := "MSScriptControl.ScriptControl"
	IID_ScriptControl    := "{0E59F1D3-1FBE-11D0-8FF2-00A0D10038BC}"
	
	VarSetCapacity(ProgId_ScriptControl_utf16, 255, 0) ; arbitrary length of 255
	VarSetCapacity(IID_ScriptControl_utf16, 255, 0) ; arbitrary length of 255
	
	iErr := DllCall("MultiByteToWideChar"
			, "UInt", 0  ; from CP_ACP (ANSI)
			, "UInt", 0  ; no flags
			, "UInt" , &ProgId_ScriptControl
			, "Int" , -1 ; until NULL
			, "UInt" , &ProgId_ScriptControl_utf16
			, "Int" , 128)
	
	If (iErr = 0)
		ExitWithError("Failed to convert ProgId_ScriptControl to unicode")
	
	iErr := DllCall("MultiByteToWideChar"
			, "UInt", 0  ; from CP_ACP (ANSI)
			, "UInt", 0  ; no flags
			, "UInt" , &IID_ScriptControl
			, "Int" , -1 ; until NULL
			, "UInt" , &IID_ScriptControl_utf16
			, "Int" , 128)
	
	If (iErr = 0)
		ExitWithError("Failed to convert IID_ScriptControl to unicode")
	
	; Convert ProgramID (to ClassID) and InterfaceID to binary
	VarSetCapacity(Clsid_ScriptControl_bin, 16) ; 16 = sizeof(CLSID)
	VarSetCapacity(IID_ScriptControl_bin, 16) ; 16 = sizeof(IID)
	
	iErr := DllCall("ole32\CLSIDFromString"
			, "Str", ProgId_ScriptControl_utf16
			, "Str", Clsid_ScriptControl_bin
			, "Int")
	
	If (iErr <> 0)
		ExitWithError("Failed to convert ProgId_ScriptControl to binary CLSID")
		
	iErr := DllCall("ole32\IIDFromString"
			, "Str", IID_ScriptControl_utf16
			, "Str", IID_ScriptControl_bin
			, "Int")
	
	If (iErr <> 0)
		ExitWithError("Failed to convert IID_ScriptControl to binary IID")
		
	; Create the Script Control object
	CLSCTX_INPROC_SERVER   := 1
	CLSCTX_INPROC_HANDLER  := 2
	CLSCTX_LOCAL_SERVER    := 4
	CLSCTX_INPROC_SERVER16 := 8
	CLSCTX_REMOTE_SERVER   := 16
	
	iErr := DllCall("ole32\CoCreateInstance"
			, "Str"  , Clsid_ScriptControl_bin
			, "UInt" , 0
			, "Int"  , CLSCTX_INPROC_SERVER | CLSCTX_LOCAL_SERVER
			, "Str"  , IID_ScriptControl_bin
			, "UInt*", ppvScriptControl
			, "Int")
	
	If (iErr <> 0)
		ExitWithError("Failed to create Script Control object")
	
	Language := "VBScript"
	
	; Convert 'VBScript' to unicode
	VarSetCapacity(Language_utf16, 255, 0) ; arbitrary length of 255
	
	iErr := DllCall("MultiByteToWideChar"
			, "UInt", 0  ; from CP_ACP (ANSI)
			, "UInt", 0  ; no flags
			, "UInt" , &Language
			, "Int" , -1 ; until NULL
			, "UInt" , &Language_utf16
			, "Int" , 128)
	
	If (iErr = 0)
		ExitWithError("Failed to convert 'VBScript' to unicode")
		
	; Convert 'VBScript' to BSTR
	Language_BSTR := DllCall("oleaut32\SysAllocString", "Str", Language_utf16, "UInt")
	
	If (Language_BSTR = 0)
		ExitWithError("Failed to create 'VBScript' BSTR")
	
	; Set the language to VBScript
	iErr := DllCall(NumGet(NumGet(ppvScriptControl+0) + 4*8), "UInt", ppvScriptControl
			, "UInt", Language_BSTR
			, "Int")
			
	If (iErr <> 0)
		ExitWithError("Failed to call MSScriptControl::Language put")
	
	; Free the BSTR
	DllCall("oleaut32\SysFreeString", "UInt", Language_BSTR)
	
	; Release Script Control object
	DllCall(NumGet(NumGet(ppvScriptControl+0) + 4*2), "UInt", ppvScriptControl, "Int")
	
	; Uninitialize COM
	DllCall("ole32\CoUninitialize")
}

ExitWithError(sErr)
{
	Msgbox % sErr
	ExitApp
}
