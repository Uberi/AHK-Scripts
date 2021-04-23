/*
                ***********************************************
                *   STDLIB Windows Scripting for Autohotkey   *
                *              v0.04 beta                     *
                ***********************************************

This script contains functions to embed VBScript or JScript into your AHK
program, and as such, provides simple access to COM though these langauges. 
This script also provides functions to create COM controls which can be 
controlled by VBScript or JScript.

Note that this script requires use of the "Microsoft Scripting Control" which
is usually installed on most machines. In the rare case it is not installed
on a system, it may be downloaded from Microsoft and installed.
http://www.microsoft.com/downloads/details.aspx?FamilyId=D7E31492-2595-49E6-8C02-1426FEC693AC
As an alternative, the Microsoft Scripting Control file "msscript.ocx" may
be used directly (e.g. placed in the same folder as the AHK script), so there 
is no need to actually install it.

******************************************************************************
Windows Scripting functions

	WS_Initialize([Language="VBScript" [, "Path to msscript.ocx"]])
	WS_Uninitialize()
	
Initializes/uninitializes the Windows Scripting environment. Language may be 
either "VBScript" or "JScript". Returns True on success, False on failure.

Normally the scripting environment is setup using the installed msscript.ocx
file on the system. Alternatively, you may specify the path to a msscript.ocx 
file (useful if msscript.ocx is not installed on the system).


	WS_Exec(ScriptCode, [, value1 [, value2 [,...]]])
	WS_Eval(ByRef ReturnValue, ScriptCode [, value1 [, value2 [,...]]])
	
Executes scripting code (VBScript or JScript).

ScriptCode contains the scripting code to execute. There are two special codes
that may be used within the ScriptCode. These codes will be replaced with
the value1, value2,... values.
  %v inserts the value
  %s inserts the value wrapped in quotes, with special characters escaped
Up to 10 values can be inserted into the ScriptCode

WS_Eval() will return the result of an evaluation. Most return types are
handled. Unhandled types are: Array, Currency, Date, VARIANT*, and the 
mysterious DECIMAL* type. You must convert these unhandled types to another 
type (usually string) before they can be returned. Note also that if WS_Eval() 
returns an object, the object should be released via the WS_ReleaseObject() 
function when it is no longer needed.

On success, these functions return True, on failure, they return False, and 
ErrorLevel will have the failed script's exception information.


	WS_AddObject(AnyInterfacePointer, ScriptObjectName [, GlobalMembers?=False])
	
Adds an object created in AHK to the scripting environment. Setting
GlobalMembers? to True will make all the members of the object global in
the script.


	VBStr()
	JStr()

Converts an Autohotkey string into a string usable in the scripting environment.
Specifically, it escapes disallowed characters (e.g. quotes, carriage return) 
and, wraps the string in quotes.

e.g.
	VBStr("this is a test") => """this is a test"""
	
	text = 
	(
		Multi
		Line
		Text
	)
	
	VBStr(text) => """Multi"" & vbCrLf & ""Line"" & vbCrLf & ""Text"""


******************************************************************************
COM functions

	WS_CreateObject(ProgId_or_ClassId [, InterfaceId=IDispatch])
	WS_GetObject(ProgId_or_ClassId [, InterfaceId=IDispatch])
	WS_CreateObjectFromDll(DllFile, ClassId [, IterfaceId=IDispatch])
	WS_ReleaseObject(ppvObjectPointer)

On failure, these functions will return nothing ("") and ErrorLevel will be 
set to the last error, either a DllCall() ErrorLevel or a COM HRESULT. 
ErrorLevel will also contain a description.

ErrorLevel format: "[error#] Function: Description"

******************************************************************************
COM Controls functions

These functions were small enough I figured they may as well just be included.
Windows Scripting does not have to be initialized before using these functions.


	WS_InitComControls()
	WS_UninitComControls()
	
Initializes/uninitializes use of COM Controls.
	
	WS_GetComControlInHWND(hWnd)
	
Retrieves the COM control associated with a hWnd (i.e. ahk_id).
	
	WS_GetHWNDofComControl(pwb)

Retrieves the hWnd (i.e. ahk_id) associated with a COM Control.

	WS_CreateComControlContainer(hWnd, x, y, w, h [, ProgId_or_ClassId])

Creates a control inside a window to host a COM control object. Optionally 
you may specify what COM object should be created inside the container.

	WS_AttachComControlToHWND(pwb, hWnd)

Attaches a COM control to an existing COM control container (created using
CreateComControlContainer() function).

******************************************************************************
Fun Links
	
VBScript Language Reference
http://msdn2.microsoft.com/en-us/library/d1wf56tt.aspx

JScript Language Reference
http://msdn2.microsoft.com/en-us/library/yek4tbz0.aspx

The MSDN guru on WSH
http://blogs.msdn.com/ericlippert/archive/2004/07/14/183241.aspx

*/

; ..............................................................................
/****f* /WS_Initialize()
 * NAME
 *	WS_Initialize -- Initializes the Windows Scripting environment.
 * USAGE
 *	WS_Initialize( [ Language = "VBScript" [, MSScriptOCX ] ] )
 * PARAMETERS
 *	* Language    - Either "VBScript" or "JScript".
 *	* MSScriptOCX - Path to msscript.ocx file.
 * RETURN VALUE
 *	True on success, False on failure.
 *	If False, ErrorLevel will contain an error description.
 * EXAMPLE
 *	
 * NOTES
 *	This function must be called before any other functions may be used.
 *	Normally the scripting environment is setup using the installed 
 *	msscript.ocx file on the system. Alternatively, you may specify the path to
 *	a msscript.ocx file (useful if msscript.ocx is not installed on the system).
 * SEE ALSO
 *	WS_Uninitialize()
 ***
 */
WS_Initialize(sLanguage = "VBScript", sMSScriptOCX="")
{
	global __iScriptControlObj__, __iScriptErrorObj__, __sScriptLanguage__
	
	static ProgId_ScriptControl := "MSScriptControl.ScriptControl"
	static CLSID_ScriptControl  := "{0E59F1D5-1FBE-11D0-8FF2-00A0D10038BC}"
	static IID_ScriptControl    := "{0E59F1D3-1FBE-11D0-8FF2-00A0D10038BC}"
	
	IfNotEqual, __iScriptControlObj__,
		Return True ; Windows Scripting has already been initialized
				   
	_CoInitialize()
	If (sMSScriptOCX="")
		__iScriptControlObj__ := WS_CreateObject(CLSID_ScriptControl, IID_ScriptControl)
	Else
		__iScriptControlObj__ := WS_CreateObjectFromDll(sMSScriptOCX, CLSID_ScriptControl, IID_ScriptControl)
		
	IfNotEqual, __iScriptControlObj__,
	{
		IScriptControl_Language(__iScriptControlObj__, sLanguage)
		__sScriptLanguage__ := sLanguage
		__iScriptErrorObj__ := IScriptControl_Error(__iScriptControlObj__)
		Return True
	}
	Return False
}



; ..............................................................................
/****f* /WS_Uninitialize()
 * NAME
 *	WS_Uninitialize -- Uninitializes the Windows Scripting environment 
 *	and releases the allocated resources.
 * USAGE
 *	WS_Uninitialize()
 * RETURN VALUE
 *	None.
 * NOTES
 *	Call this function to free the memory used by this library. It is not
 *	necessary to call this function before exiting your script (but it is 
 *	good practice).
 * SEE ALSO
 *	WS_Initialize()
 ***
 */
WS_Uninitialize()
{
	global __iScriptControlObj__, __iScriptErrorObj__   
	
	IfNotEqual __iScriptErrorObj__,
		IUnknown_Release(__iScriptErrorObj__)
	
	IfNotEqual __iScriptControlObj__,
		IUnknown_Release(__iScriptControlObj__)
	
	_CoUninitialize()
	
	__iScriptControlObj__ := ""
	__iScriptErrorObj__   := ""
	__sScriptLanguage__   := ""
}

; ..............................................................................
/****f* /WS_Exec()
 * NAME
 *	WS_Exec -- Executes scripting code.
 * USAGE
 *	WS_Exec(ScriptCode [, value1 [, value2 [,...]]])
 * PARAMETERS
 *	* ScriptCode           - Scripting code to execute.
 *	* value1, value2, etc. - (Optional) Values to insert into the ScriptCode.
 * RETURN VALUE
 *	True on success, False on failure.
 *	If False, ErrorLevel will contain an error description.
 * EXAMPLE
 *	
 * NOTES
 *	There are two special codes that may be used within the ScriptCode: 
 *	* %v - inserts the value
 *	* %s - inserts the value wrapped in quotes, with special characters escaped.
 *	These codes will be replaced with the value1, value2,... values.
 *	Up to 10 values can be inserted into the ScriptCode
 ***
 */
WS_Exec(sCode, arg1="`b`b", arg2="`b`b", arg3="`b`b", arg4="`b`b", arg5="`b`b"
             , arg6="`b`b", arg7="`b`b", arg8="`b`b", arg9="`b`b", arg10="`b`b"))
{
	global __iScriptControlObj__, __iScriptErrorObj__
	
	
	IfEqual __iScriptControlObj__,
	{
		Msgbox % "Windows Scripting has not been initialized!`nExiting application."
		ExitApp
	}
	
	; Merge the arguments into the code string
	iArg := 1
	iPos := 1
	Loop
	{
		val := arg%iArg%
		If (val = "`b`b")
			Break
		
		If (iPos := InStr(sCode, "%", True, iPos))
		{
			sNextChar := SubStr(sCode, iPos+1, 1)
			If (sNextChar == "v")
			{
				sCode := SubStr(sCode, 1, iPos-1) . val . SubStr(sCode, iPos+2)
				iArg++
				iPos += StrLen(val)
			}
			Else If (sNextChar == "s")
			{
				val := ScriptStr(val)
				sCode := SubStr(sCode, 1, iPos-1) . val . SubStr(sCode, iPos+2)
				iArg++
				iPos += StrLen(val)
			}
			Else
				iPos++
		}
		Else
			Break
	}
	; Run the code
	Critical, On ; For thread safty
	iErr := IScriptControl_ExecuteStatement(__iScriptControlObj__, sCode)
	If (iErr = 0)
	{
		Critical, Off
		Return True
	}
	Else
	{
		; Probably an exception. Get the deatils.
		sErrorDesc := IScriptError_Description(__iScriptErrorObj__)
		If (sErrorDesc = "")
			sErrorDesc := "Scripting error " IScriptError_Number(__iScriptErrorObj__)
		IScriptError_Clear(__iScriptErrorObj__)
		Critical, Off
		ErrorLevel := sErrorDesc
		Return False
	}
}

; ..............................................................................
/****f* /WS_Eval()
 * NAME
 *	WS_Eval -- Evaluates scripting code and returns the result.
 * USAGE
 *	WS_Eval(ByRef ReturnValue, ScriptCode [, value1 [, value2 [,...]]])
 * PARAMETERS
 *	* ReturnValue          - (ByRef) Variable to receive the return value.
 *	* ScriptCode           - Scripting code to execute.
 *	* value1, value2, etc. - (Optional) Values to insert into the ScriptCode.
 * RETURN VALUE
 *	True on success, False on failure.
 *	If False, ErrorLevel will contain an error description.
 * NOTES
 *	There are two special codes that may be used within the ScriptCode: 
 *	* %v - inserts the value
 *	* %s - inserts the value wrapped in quotes, with special characters escaped.
 *	These codes will be replaced with the value1, value2,... values.
 *	Up to 10 values can be inserted into the ScriptCode.
 *	
 *	ReturnValue will hold the result of an evaluation. Most return types are
 *	handled. Unhandled types are: Array, Currency, Date, VARIANT*, and the 
 *	mysterious DECIMAL* type. You must convert these unhandled types to another 
 *	type (usually string) before they can be returned. Note also that if 
 *	the expression returns an object, the object should be released via the 
 *	WS_ReleaseObject() function when it is no longer needed.
 * EXAMPLE
 *	
 * SEE ALSO
 *	WS_Exec()
 ***
 */
WS_Eval(ByRef xReturn, sCode, arg1="`b`b", arg2="`b`b", arg3="`b`b", arg4="`b`b", arg5="`b`b"
                            , arg6="`b`b", arg7="`b`b", arg8="`b`b", arg9="`b`b", arg10="`b`b")
{
	global __iScriptControlObj__, __iScriptErrorObj__
	
	IfEqual __iScriptControlObj__,
	{
		Msgbox % "Windows Scripting has not been initialized!`nExiting application."
		ExitApp
	}
	
	; Merge the arguments into the code string
	iArg := 1
	iPos := 1
	Loop
	{
		val := arg%iArg%
		If (val = "`b`b")
			Break
			
		If (iPos := InStr(sCode, "%", True, iPos))
		{
			sNextChar := SubStr(sCode, iPos+1, 1)
			If (sNextChar == "v")
			{
				sCode := SubStr(sCode, 1, iPos-1) . val . SubStr(sCode, iPos+2)
				iArg++
				iPos += StrLen(val)
			}
			Else If (sNextChar == "s")
			{
				val = ScriptStr(val)
				sCode := SubStr(sCode, 1, iPos-1) . val . SubStr(sCode, iPos+2)
				iArg++
				iPos += StrLen(val)
			}
			Else
				iPos++
		}
		Else
			Break
	}

	; Run the code
	Critical, On ; For thread safty
	iErr := IScriptControl_Eval(__iScriptControlObj__, sCode, varReturn)
	If (iErr = 0)
	{
		If (!__UnpackVARIANT(varReturn, xReturn))
			xReturn := "#Unhandled return type#"
		Critical, Off
		Return True
	}
	Else
	{
		; Probably an exception. Get the deatils.
		sErrorDesc := IScriptError_Description(__iScriptErrorObj__)
		If (sErrorDesc = "")
			sErrorDesc := "Scripting error " IScriptError_Number(__iScriptErrorObj__)
		IScriptError_Clear(__iScriptErrorObj__)
		Critical, Off
		ErrorLevel := sErrorDesc
		Return False
	}
}

; ..............................................................................

ScriptStr(s)
{
	global __sScriptLanguage__
	If (__sScriptLanguage__ == "VBScript")
		Return VBStr(s)
	Else If (__sScriptLanguage__ == "JScript")
		Return JStr(s)
	Else
		Return
}

; ..............................................................................

VBStr(s)
{
	StringReplace, s, s, ", "", All
	StringReplace, s, s, `r, " & vbCr & ", All
	StringReplace, s, s, `n, " & vbLf & ", All
	StringReplace, s, s, `f, " & vbFormFeed & ", All
	StringReplace, s, s, `b, " & vbBack & ", All
	Return """" s """"
}

; ..............................................................................

JStr(s)
{
	StringReplace, s, s, \, \\, All
	StringReplace, s, s, ", \", All
	StringReplace, s, s, `r, \r, All
	StringReplace, s, s, `n, \n, All
	StringReplace, s, s, `f, \f, All
	StringReplace, s, s, `b, \b, All
	Return """" s """"
}

; ..............................................................................
/****f* /WS_AddObject()
 * NAME
 *	WS_AddObject -- Adds an object created in AHK to the scripting environment.
 * USAGE
 *	WS_AddObject(Object, Name [, GlobalMembers] )
 * PARAMETERS
 *	* Object        - (Integer) Object to add
 *	* Name          - (String) The identifier that will be used in the  
 *	                  scripting environment to refer to this object.
 *	* GlobalMembers - (Optional) (Boolean) Setting GlobalMembers to True will 
 *	                  make all the members of the object global in the script.
 * RETURN VALUE
 *	
 * NOTES
 *	
 * EXAMPLE
 *	
 * SEE ALSO
 *	WS_ReleaseObject()
 ***
 */
WS_AddObject(ppvInterface, sName, blnGlobalMembers = False)
{
	global IID_IDispatch, __iScriptControlObj__
	
	IfEqual __iScriptControlObj__,
	{
		Msgbox % "Windows Scripting has not been initialized!`nExiting application."
		ExitApp
	}
	
	Return IScriptControl_AddObject(__iScriptControlObj__, sName, ppvInterface
	                                                     , -blnGlobalMembers)
}

; ..............................................................................

WS_ErrMsg(sFile, iLine)
{
	Msgbox, , Windows Scripting Error
			, % "Scripting error on line " iLine " in file " sFile
			. "`nError: " ErrorLevel
}


; ..............................................................................
/****f* /WS_CreateObject()
 * NAME
 *	WS_CreateObject -- 
 * USAGE
 *	WS_CreateObject(ProgID or ClassID [, InterfaceID = IDispatch ] )
 * PARAMETERS
 *	* ProgID or ClassID - (String) 
 *	* InterfaceID       - (Optional) (String)   
 * RETURN VALUE
 *	
 * NOTES
 *	
 * EXAMPLE
 *	
 * SEE ALSO
 *	WS_ReleaseObject()
 ***
 */
WS_CreateObject(sProgID_ClsId, sIId = "{00020400-0000-0000-C000-000000000046}")
{                                    ; ^ IDispatch                          
	global IID_IDispatch
	
	If (InStr(sProgID_ClsId, "{")) ; Is it a CLSID?
		ppv := __CreateObjectClsId(sProgID_ClsId, sIId)
	Else
		ppv := __CreateObjectProgId(sProgID_ClsId, sIId)
		
	If (sIId = IID_IDispatch)
	{
		If ppv
			Return __GetIDispatch(ppv)
		Else
			Return ppv
	}
	Else
		Return ppv
}

; ..............................................................................
/****f* /WS_GetObject()
 * NAME
 *	WS_GetObject -- 
 * USAGE
 *	WS_GetObject(ProgID or ClassID [, InterfaceID = IDispatch ] )
 * PARAMETERS
 *	* ProgID or ClassID - (String) 
 *	* InterfaceID       - (Optional) (String)   
 * RETURN VALUE
 *	
 * NOTES
 *	
 * EXAMPLE
 *	
 * SEE ALSO
 *	WS_ReleaseObject()
 ***
 */
WS_GetObject(sProgID_ClsId, sIId = "{00020400-0000-0000-C000-000000000046}")
{                                 ; ^ IDispatch
	global IID_IDispatch
	
	If (InStr(sProgID_ClsId, "{")) ; Is it a CLSID?
		ppv := __GetObjectClsId(sProgID_ClsId, sIId)
	Else
		ppv := __GetObjectProgId(sProgID_ClsId, sIId)
		
	If (sIId = IID_IDispatch)
	{
		If ppv
			Return __GetIDispatch(ppv)
		Else
			Return ppv
	}
	Else
		Return ppv
}

; ..............................................................................
/****f* /WS_CreateObjectFromDll()
 * NAME
 *	WS_CreateObjectFromDll -- 
 * USAGE
 *	WS_CreateObjectFromDll(DllPath, ClassID [, InterfaceID = IDispatch ] )
 * PARAMETERS
 *	* DllPath           - (String) 
 *	* ProgID or ClassID - (String) 
 *	* InterfaceID       - (Optional) (String)   
 * RETURN VALUE
 *	
 * NOTES
 *	
 * EXAMPLE
 *	
 * SEE ALSO
 *	WS_ReleaseObject()
 ***
 */
WS_CreateObjectFromDll(sDll, sClsId, sIId = "")
{                                        
	global IID_IDispatch
	
	If (sIId = "")
		sIId := IID_IDispatch
		
	If (__CLSIDFromString(sClsId, sbinClsId) And __IIDFromString(sIId, sbinIId))
		ppv := __CreateInstanceFromDll(sDll, sbinClsId, sbinIId)
	Else
		Return
		
	If (IID = "")
	{
		If ppv
			Return __GetIDispatch(ppv)
		Else
			Return
	}
	Else
		Return ppv
}

; ..............................................................................
/****f* /WS_ReleaseObject()
 * NAME
 *	WS_ReleaseObject -- 
 * USAGE
 *	WS_ReleaseObject(Object)
 * PARAMETERS
 *	* Object - (Integer) 
 * RETURN VALUE
 *	
 * NOTES
 *	Has the same behavior as simply calling IUnknown_Release()
 *	but has a more accessible name.
 *	
 * EXAMPLE
 *	
 * SEE ALSO
 ***
 */
WS_ReleaseObject(iObjPtr)
{
	Return IUnknown_Release(iObjPtr)
}


; ## COM Controls ##############################################################
;; These functions originally written by our resident COM guru Sean in
;; the Autohotkey forums. They have ben expanded, commented, and renamed
;; for easier reading. They have also been adjusted to use the WS4AHK COM
;; API functions, and error checking has been added (eventually).

; Should be called before creating COM controls.
; Returns nonzero if the initialization was successful; otherwise 0.
WS_InitComControls()
{
	; Check if atl dll has already been loaded.
	If !DllCall("GetModuleHandle", "Str", "atl")
		DllCall("LoadLibrary"    , "Str", "atl")
	; Initialize atl (it's ok to call this function more than once)
	Return DllCall("atl\AtlAxWinInit")
}

; Unloads the atl library
WS_UninitComControls()
{
	; MSDN warns about a race condition that could occur if two threads
	; call this function at the same time.
	If hModule := DllCall("GetModuleHandle", "Str", "atl")
		DllCall("FreeLibrary", "UInt", hModule)
}

; Returns the HWND (i.e. ahk_id) of the control that hosts the COM object
; Or returns "" on COM related error (ErrorLevel is set), 
; or 0 (NULL) on window related error.
WS_GetHWNDofComControl(pComObject)
{ 
	static IID_IOleWindow := "{00000114-0000-0000-C000-000000000046}"
	pOleWin := IUnknown_QueryInterface(pComObject, IID_IOleWindow)
	
	IfEqual pOleWin,
		Return False
	
	; IOleWindow::GetWindow()
	iErr := DllCall(__VTable(pOleWin, 3), "UInt", pOleWin, "UInt*", hWnd) 

	If (ErrorLevel <> 0)  ; #BeginErrorChecking
	{
		__ComError(ErrorLevel, "IOleWindow::GetWindow: Error calling dll function: " ErrorLevel)
		Return
	}
	If (iErr = 0) ; S_OK
	{
		__ComErrorClear()
	}
	Else
	{
		__ComError(iErr, "IOleWindow::GetWindow: error " iErr)
		Return
	}                     ; #EndErrorChecking
	
	IUnknown_Release(pOleWin)
	
	Return DllCall("GetParent", "UInt", hWnd)
}

; Returns the COM object in the HWND (i.e. ahk_id)
; or "" on error. Sets ErrorLevel.
WS_GetComControlInHWND(hWnd)
{
	global IID_IDispatch
	
	iErr := DllCall("atl\AtlAxGetControl"
						, "UInt", hWnd
						, "UInt*", pUnknown
						, "UInt")

	If (ErrorLevel <> 0)  ; #BeginErrorChecking
	{
		__ComError(ErrorLevel, "AtlAxGetControl: Error calling dll function: " ErrorLevel)
		Return
	}
	If (iErr = 0) ; S_OK
	{
		__ComErrorClear()
	}
	Else
	{
		__ComError(iErr, "AtlAxGetControl: error " iErr)
		Return
	}                     ; #EndErrorChecking

	pDispatch := IUnknown_QueryInterface(pUnknown, IID_IDispatch)
	IUnknown_Release(pUnknown)
	Return pDispatch
}

; Attaches a previously created control to the specified window.
; Returns True on success, False on failure
WS_AttachComControlToHWND(pdsp, hWnd)
{
	global IID_IUnknown
	pUnknown := IUnknown_QueryInterface(pdsp, IID_IUnknown)
	
	IfEqual pUnknown,
		Return False
		
	iErr := DllCall("atl\AtlAxAttachControl", "UInt", pUnknown, "UInt", hWnd, "UInt", 0)
	
	If (ErrorLevel <> 0)  ; #BeginErrorChecking
	{
		__ComError(ErrorLevel, "AtlAxAttachControl: Error calling dll function: " ErrorLevel)
		Return False
	}
	If (iErr = 0) ; S_OK
	{
		__ComErrorClear()
	}
	Else
	{
		__ComError(iErr, "AtlAxAttachControl: error " iErr)
		Return False
	}                     ; #EndErrorChecking
	
	IUnknown_Release(pUnknown)
	Return True
}

; On success, returns handle to the new window, or NULL on error.
WS_CreateComControlContainer(hWnd, x, y, w, h, sName = "")
{
	static AtlAxWin := "AtlAxWin"
	pName := sName ? &sName : 0
	Return DllCall("CreateWindowEx"
					, "UInt", 0x200
					, "UInt", &AtlAxWin
					, "UInt", pName
					, "UInt", 0x10000000|0x40000000|0x04000000
					, "Int" , x
					, "Int" , y
					, "Int" , w
					, "Int" , h
					, "UInt", hWnd
					, "UInt", 0
					, "UInt", 0
					, "UInt", 0)
	; 0x10000000|  0x40000000  |  0x04000000 
	; WS_VISIBLE|WS_CHILDWINDOW|WS_CLIPSIBLINGS
}

;###############################################################################
; You shouldn't need to worry about functions beyond this point unless
; you know what they're for.

; == Tier 1 COM Internals ======================================================
/*
These functions will set ErrorLevel with errors.

_CoInitialize()
_CoUninitialize()
*/

IID_IDispatch := "{00020400-0000-0000-C000-000000000046}"
IID_IUnknown  := "{00000000-0000-0000-C000-000000000046}"

; Initializes COM
_CoInitialize()
{
	iErr := DllCall("ole32\CoInitialize", "UInt", 0, "UInt")
	
	If (ErrorLevel <> 0)  ; #BeginErrorChecking
	{
		__ComError(ErrorLevel, "CoInitialize: Error calling dll function: " ErrorLevel)
		Return
	}
	If (iErr = 0) ; S_OK
	{
		__ComErrorClear()
	}
	Else If (iErr = 0x80070057) ; E_INVALIDARG
	{
		__ComError(iErr, "CoInitialize: returned E_INVALIDARG")
		Return
	}
	Else If (iErr = 0x8007000E) ; E_OUTOFMEMORY
	{
		__ComError(iErr, "CoInitialize: returned E_OUTOFMEMORY")
		Return
	}
	Else If (iErr = 0x8001FFFF) ; E_UNEXPECTED
	{
		__ComError(iErr, "CoInitialize: returned E_UNEXPECTED")
		Return
	}
	Else If (iErr = 0x00000001) ; S_FALSE
	{
		__ComError(iErr, "CoInitialize: The COM library is already initialized on this thread.")
		Return True
	}
	Else If (iErr = 0x80010106) ; RPC_E_CHANGED_MODE
	{
		__ComError(iErr, "CoInitialize: A previous call to CoInitializeEx specified the concurrency model for this thread as multithread apartment (MTA). If running Windows 2000, this could also mean that a change from neutral-threaded apartment to single-threaded apartment occurred.")
	}
	Else
	{
		__ComError(iErr, "CoInitialize: error " iErr)
		Return
	}                     ; #EndErrorChecking
	
	Return True
}

; ..............................................................................

; Uninitializes COM
_CoUninitialize()
{
	DllCall("ole32\CoUninitialize")
}

; == Tier 2 COM Internals ======================================================
/*
__CreateObjectProgId
__CreateObjectClsId
__GetObjectProgId
__GetObjectClsId
__CreateInstanceFromDll
__ComError
__ComErrorClear
*/

; Creates an object from a Program ID (e.g. "Excel.Application")
__CreateObjectProgId(sProgId, sIId)
{
	If (__CLSIDFromProgID(sProgId, sbinClsId) And __IIDFromString(sIId, sbinIId))
		Return __CreateInstance(sbinClsId, sbinIId)
}

; ..............................................................................

; Creates an object from a Class ID 
; (e.g. "{00000000-0000-0000-C000-000000000046}")
__CreateObjectClsId(sClsId, sIId)
{
	If (__CLSIDFromString(sClsId, sbinClsId) And __IIDFromString(sIId, sbinIId))
		Return __CreateInstance(sbinClsId, sbinIId)
}

; ..............................................................................

; Gets a running instance of an object via Program ID
__GetObjectProgId(sProgId, sIId)
{
	If (__CLSIDFromProgID(sProgId, sbinClsId))
		Return __GetActiveObject(sbinClsId, sIId)
}

; ..............................................................................

; Gets a running instance of an object via Class ID
__GetObjectClsId(sClsId, sIId)
{
	If (__CLSIDFromString(sClsId, sbinClsId))
		Return __GetActiveObject(sbinClsId, sIId)
}

; ..............................................................................

; Manually creates an object by directly accessing the DLL/OCX file.
; (this involves a bit of hackery, but it usually seems to work)
; This code is based on the amazing work by Elias on CodeProject.
; http://www.codeproject.com/com/Emul_CoCreateInstance.asp
;  
; Note that there is no need to free the library explicitly.
; It should be automatically freed when CoUninitialize is called.
__CreateInstanceFromDll(sDll, ByRef sbinClassId, ByRef sbinIId)
{
	static IID_IClassFactory := "{00000001-0000-0000-C000-000000000046}"
	__IIDFromString(IID_IClassFactory, sbinIID_IClassFactory)
	
	__ANSI2Unicode(sDll, wsDll)
	hDll := DllCall("ole32\CoLoadLibrary", "Str", wsDll, "Int", 1, "UInt")
	
	If (ErrorLevel <> 0)
	{
		__ComError(ErrorLevel, "CoLoadLibrary: Error calling dll function: " ErrorLevel)
		Return
	}
	
	If (hDll = 0)
	{
		__ComError("", "CoLoadLibrary: Library could not be loaded.")
		Return
	}

	iErr := DllCall(sDll . "\DllGetClassObject"
					,"Str" , sbinClassId
					,"Str" , sbinIID_IClassFactory
					,"UInt*", pIFactory
					,"UInt")

	If (ErrorLevel <> 0) ; #BeginErrorChecking
	{
		__ComError(ErrorLevel, "DllGetClassObject: Error calling dll function: " ErrorLevel)
		Return
	}
	If (iErr = 0) ; S_OK
	{
		__ComErrorClear()
	}
	Else
	{
		__ComError(iErr, "DllGetClassObject: error " iErr)
		Return
	}                    ; #EndErrorChecking
	
	iErr := IClassFactory_CreateInstance(pIFactory, 0, sbinIId, iObjPtr)
	iErrorLevel := ErrorLevel ; save the ErrorLevel
	
	IUnknown_Release(pIFactory)
	
	If (iErrorLevel <> 0)  ; #BeginErrorChecking
	{
		__ComError(iErrorLevel, "IClassFactory::CreateInstance: Error calling dll function: " ErrorLevel)
		Return
	}
	If (iErr = 0) ; S_OK
	{
		__ComErrorClear()
	}
	Else If (iErr = 0x8001FFFF) ; E_UNEXPECTED
	{
		__ComError(iErr, "IClassFactory::CreateInstance: E_UNEXPECTED")
		Return
	}
	Else If (iErr = 0x80000002) ; E_OUTOFMEMORY
	{
		__ComError(iErr, "IClassFactory::CreateInstance: E_OUTOFMEMORY")
		Return
	}
	Else If (iErr = 0x80070057) ; E_INVALIDARG
	{
		__ComError(iErr, "IClassFactory::CreateInstance: E_INVALIDARG")
		Return
	}
	Else If (iErr = 0x80040110) ; CLASS_E_NOAGGREGATION
	{
		__ComError(iErr, "IClassFactory::CreateInstance: The pUnkOuter parameter was non-NULL and the object does not support aggregation.")
		Return
	}
	Else If (iErr = 0x80004002) ; E_NOINTERFACE
	{
		__ComError(iErr, "IClassFactory::CreateInstance: The object does not support the interface.")
		Return
	}
	Else
	{
		__ComError(iErr, "IClassFactory::CreateInstance: error " iErr)
		Return
	}                    ; #EndErrorChecking
		
	Return iObjPtr
}

; ..............................................................................

; Try to QueryInterface a COM pointer to the 'most useful' interface.
; Note: I still don't quite understand the purpose of doing this,
; but Sean was doing it, and the code found here
; http://svn.python.org/projects/ctypes/trunk/comtypes/comtypes/client/__init__.py
; was doing it, so I guess this can do it too.
__GetIDispatch(ppObj, LCID = 0)
{
	iTypeInfoCount := IDispatch_GetTypeInfoCount(ppObj)
	If (iTypeInfoCount = 0 Or iTypeInfoCount = "")
		Return ppObj

	ppTypeInfo := IDispatch_GetTypeInfo(ppObj, LCID)
	IfEqual, ppTypeInfo,
		Return ppObj
	
	; find the interface marked as default
	pattr := ITypeInfo_GetTypeAttr(ppTypeInfo)
	IfEqual, pattr,
	{
		IUnknown_Release(ppTypeInfo)                                    
		Return ppObj
	}
	
	pdisp := IUnknown_QueryInterface(ppObj, pattr)
	
	ITypeInfo_ReleaseTypeAttr(ppTypeInfo, pattr)
	IUnknown_Release(ppTypeInfo)
	
	IfEqual, pdisp,
	{
		Return ppObj
	}
	Else
	{
		IUnknown_Release(ppObj)
		Return pdisp
	}	
}

; #BeginErrorChecking
; ..............................................................................

; Sets ErrorLevel with an error.
__ComError(iErr, sErrDesc) 
{
	If (iErr = "")
		ErrorLevel := sErrDesc
	Else
		ErrorLevel := "[" iErr "] " sErrDesc
}

__ComErrorClear()
{
	ErrorLevel := 0
}
; #EndErrorChecking

; == Tier 3 COM Internals ======================================================
/*
__CreateInstance
__GetActiveObject
__CLSIDFromProgID
__CLSIDFromString
__IIDFromString
*/

; Creates an object from the binary form of its Class ID and Interface ID 
__CreateInstance(ByRef sbinClassId, ByRef sbinIId)
{
	static CLSCTX_INPROC_SERVER   := 1
	static CLSCTX_INPROC_HANDLER  := 2
	static CLSCTX_LOCAL_SERVER    := 4
	static CLSCTX_INPROC_SERVER16 := 8
	static CLSCTX_REMOTE_SERVER   := 16
	
	iErr := DllCall("ole32\CoCreateInstance"
					, "Str" , sbinClassId
					, "UInt", 0
					, "Int" , CLSCTX_INPROC_SERVER | CLSCTX_LOCAL_SERVER
					, "Str" , sbinIId
					, "UInt*", iObjPtr
					, "UInt")
					
	If (ErrorLevel <> 0) ; #BeginErrorChecking
	{
		__ComError(ErrorLevel, "CoCreateInstance: Error calling dll function: " ErrorLevel)
		Return
	}
	If (iErr = 0) ; S_OK
	{
		__ComErrorClear()
	}
	Else If (iErr = 0x80040154) ; REGDB_E_CLASSNOTREG
	{
		__ComError(iErr, "CoCreateInstance: A specified class is not registered in the registration database. Also can indicate that the type of server you requested in the CLSCTX enumeration is not registered or the values for the server types in the registry are corrupt.")
		Return
	}
	Else If (iErr = 0x80040110) ; CLASS_E_NOAGGREGATION
	{
		__ComError(iErr, "CoCreateInstance: This class cannot be created as part of an aggregate.")
		Return
	}
	Else If (iErr = 0x80004002) ; E_NOINTERFACE
	{
		__ComError(iErr, "CoCreateInstance: The specified class does not implement the requested interface, or the controlling IUnknown does not expose the requested interface.")
		Return
	}
	Else
	{
		__ComError(iErr, "CoCreateInstance: error " iErr)
		Return
	}                    ; #EndErrorChecking
	
	Return iObjPtr
}

; ..............................................................................

; Gets a running instance of an object via the binary form of its Class ID
; and the string form of its Interface ID
__GetActiveObject(ByRef sbinClassId, sIId)
{
	iErr = DllCall("oleaut32\GetActiveObject"
				, "Str", sbinClassId
				, "UInt", 0
				, "UInt*", oUnkwn)
				
	If (ErrorLevel <> 0) ; #BeginErrorChecking
	{
		__ComError(ErrorLevel, "GetActiveObject: Error calling dll function: " ErrorLevel)
		Return
	}
	If (iErr = 0) ; S_OK
	{
		__ComErrorClear()
	}
	Else
	{
		__ComError(iErr, "GetActiveObject: Failure (" iErr ")")
		Return
	}                    ; #EndErrorChecking
	
	oDisp := IUnknown_QueryInterface(oUnkwn, sIId)
	IUnknown_Release(oUnkwn)
	Return oDisp	
}

; ..............................................................................

; Looks up the binary Class ID of a Program ID
__CLSIDFromProgID(sProgId, ByRef sbinClassId)
{
	__ANSI2Unicode(sProgId, wsProgId)
	VarSetCapacity(sbinClassId, 16) ; 16 = sizeof(CLSID) 
	iErr := DllCall("ole32\CLSIDFromProgID"
					, "Str", wsProgId
					, "Str", sbinClassId
					, "UInt")
					
	If (ErrorLevel <> 0) ; #BeginErrorChecking
	{
		__ComError(ErrorLevel, "CLSIDFromProgID: Error calling dll function: " ErrorLevel)
		Return False
	}
	If (iErr = 0) ; S_OK
	{
		__ComErrorClear()
	}
	Else If (iErr = 0x800401F3) ; CO_E_CLASSSTRING
	{
		__ComError(iErr, "CLSIDFromProgID: The registered CLSID for the ProgID is invalid.")
		Return False
	}
	Else If (iErr = 0x80040151) ; REGDB_E_WRITEREGDB
	{
		__ComError(iErr, "CLSIDFromProgID: An error occurred writing the CLSID to the registry.")
		Return False
	}
	Else
	{
		__ComError(iErr, "CLSIDFromProgID: error " iErr)
		Return False
	}                    ; #EndErrorChecking
	
	Return True
}

; ..............................................................................

; Converts a string Class ID to a binary Class ID
__CLSIDFromString(sClassId, ByRef sbinClassId)
{
	__ANSI2Unicode(sClassId, wsClassId)
	VarSetCapacity(sbinClassId, 16) ; 16 = sizeof(CLSID) 
	iErr := DllCall("ole32\CLSIDFromString"
					, "Str", wsClassId
					, "Str", sbinClassId
					, "UInt")

	If (ErrorLevel <> 0) ; #BeginErrorChecking
	{
		__ComError(ErrorLevel, "CLSIDFromString: Error calling dll function: " ErrorLevel)
		Return False
	}
	If (iErr = 0) ; S_OK
	{
		__ComErrorClear()
	}
	Else If (iErr = 0x800401F3) ; CO_E_CLASSSTRING
	{
		__ComError(iErr, "CLSIDFromString: The class string was improperly formatted.")
		Return False
	}
	Else If (iErr = 0x80040151) ; REGDB_E_WRITEREGDB
	{
		__ComError(iErr, "CLSIDFromString: The class identifier corresponding to the class string was not found in the registry.")
		Return False
	}
	Else 
	{
		__ComError(iErr, "CLSIDFromString: error " iErr)
		Return False
	}                    ; #EndErrorChecking
	
	Return True
}

; ..............................................................................

; Converts a string Interface ID to a binary Interface ID
; (I really don't see why Win API has a separate function to do this)
__IIDFromString(sIId, ByRef sbinIId)
{
	__ANSI2Unicode(sIId, wsIId)
	VarSetCapacity(sbinIId, 16) ; 16 = sizeof(IID) 
	iErr := DllCall("ole32\IIDFromString"
					, "Str", wsIId
					, "Str", sbinIId
					, "UInt")

	If (ErrorLevel <> 0) ; #BeginErrorChecking
	{
		__ComError(ErrorLevel, "IIDFromString: Error calling dll function: " ErrorLevel)
		Return False
	}
	If (iErr = 0) ; S_OK
	{
		__ComErrorClear()
	}
	Else If (iErr = 0x80070057) ; E_INVALIDARG
	{
		__ComError(iErr, "CLSIDFromString: E_INVALIDARG")
		Return False
	}
	Else If (iErr = 0x8007000E) ; E_OUTOFMEMORY
	{
		__ComError(iErr, "CLSIDFromString: E_OUTOFMEMORY")
		Return False
	}
	Else 
	{
		__ComError(iErr, "CLSIDFromString: error " iErr)
		Return False
	}                    ; #EndErrorChecking
	
	Return True
}

; ## IScriptControl ############################################################
/*
The entire IScriptControl Vtable (only the * members are implemented)
 0   call_QueryInterface    Returns a pointer to a specified interface on an object to which a client currently holds an interface pointer
 1   call_AddRef            Increments the reference count for an interface on an object
 2   call_Release           Decrements the reference count for the calling interface on a object
 3   call_GetTypeInfoCount  Retrieves the number of type information interfaces that an object provides (either 0 or 1)
 4   call_GetTypeInfo       Retrieves the type information for an object
 5   call_GetIDsOfNames     Maps a single member and an optional set of argument names to a corresponding set of integer DISPIDs
 6   call_Invoke            Provides access to properties and methods exposed by an object.
 7 * get_Language           Language engine to use
 8 * put_Language           Language engine to use
 9   get_State              State of the control
10   put_State              State of the control
11 * put_SitehWnd           hWnd used as a parent for displaying UI
12 * get_SitehWnd           hWnd used as a parent for displaying UI
13   get_Timeout            Length of time in milliseconds that a script can execute before being considered hung
14   put_Timeout            Length of time in milliseconds that a script can execute before being considered hung
15 * get_AllowUI            Enable or disable display of the UI
16 * put_AllowUI            Enable or disable display of the UI
17   get_UseSafeSubset      Force script to execute in safe mode and disallow potentially harmful actions
18   put_UseSafeSubset      Force script to execute in safe mode and disallow potentially harmful actions
19   get_Modules            Collection of modules for the ScriptControl
20 * get_Error              The last error reported by the scripting engine
21   get_CodeObject         Object exposed by the scripting engine that contains methods and properties defined in the code added to the global module
22   get_Procedures         Collection of procedures that are defined in the global module
23   call__AboutBox        
24 * call_AddObject         Add an object to the global namespace of the scripting engine
25   call_Reset             Reset the scripting engine to a newly created state
26   call_AddCode           Add code to the global module
27 * call_Eval              Evaluate an expression within the context of the global module
28 * call_ExecuteStatement  Execute a statement within the context of the global module
29   call_Run               Call a procedure defined in the global module
*/

; Note: Changing the scripting language seems to reset the environment
IScriptControl_Language(ppvScriptControl, sLanguage="`b")
{
	If (sLanguage = "`b")
	{	; Get Language
		iErr := DllCall(__VTable(ppvScriptControl, 7), "UInt", ppvScriptControl
					, "Uint*", ibstrLang
					, "UInt")
		__Unicode2ANSI(ibstrLang, sLanguage) 
		__SysFreeString(ibstrLang)
		If (iErr <> 0 Or ErrorLevel <> 0)
			Msgbox % "Error in IScriptControl::Language get: ErrorLevel=" ErrorLevel "  iErr=" iErr
		Return sLanguage
	}
	Else
	{	; Put Language
		bstrLang := __SysAllocStringA(sLanguage)
		iErr := DllCall(__VTable(ppvScriptControl, 8), "UInt", ppvScriptControl
					, "UInt", bstrLang
					, "UInt")
		__SysFreeString(bstrLang)
		If (iErr <> 0 Or ErrorLevel <> 0)
			Msgbox % "Error in IScriptControl::Language put: ErrorLevel=" ErrorLevel "  iErr=" iErr
	}
}

; ..............................................................................

IScriptControl_SitehWnd(ppvScriptControl, iWindowHandle)
{
	If (iAllow = "`b")
	{	; Get SitehWnd
		iErr := DllCall(__VTable(ppvScriptControl, 11), "UInt", ppvScriptControl
						, "UInt*", iWindowHandle
						, "UInt")
		If (iErr <> 0 Or ErrorLevel <> 0)
			Msgbox % "Error in IScriptControl::SitehWnd: ErrorLevel=" ErrorLevel "  iErr=" iErr
		Return iAllow
	}
	Else
	{	; Put SitehWnd
		iErr := DllCall(__VTable(ppvScriptControl, 12), "UInt", ppvScriptControl
						, "UInt", iWindowHandle
						, "UInt")
		If (iErr <> 0 Or ErrorLevel <> 0)
			Msgbox % "Error in IScriptControl::SitehWnd: ErrorLevel=" ErrorLevel "  iErr=" iErr
	}
}

; ..............................................................................

IScriptControl_AllowUI(ppvScriptControl, iAllow="`b")
{
	If (iAllow = "`b")
	{	; Get AllowUI
		iErr := DllCall(__VTable(ppvScriptControl, 15), "UInt", ppvScriptControl
						, "Short*", iAllow
						, "UInt")
		If (iErr <> 0 Or ErrorLevel <> 0)
			Msgbox % "Error in IScriptControl::AllowUI: ErrorLevel=" ErrorLevel "  iErr=" iErr
		Return iAllow
	}
	Else
	{   ; Put AllowUI
		iErr := DllCall(__VTable(ppvScriptControl, 16), "UInt", ppvScriptControl
						, "Short", iAllow
						, "UInt")
		If (iErr <> 0 Or ErrorLevel <> 0)
			Msgbox % "Error in IScriptControl::AllowUI: ErrorLevel=" ErrorLevel "  iErr=" iErr
	}
}

; ..............................................................................

IScriptControl_Error(ppvScriptControl)
{
	iErr := DllCall(__VTable(ppvScriptControl, 20), "UInt", ppvScriptControl
					, "UInt*", ppvScriptError
					, "UInt")
	If (iErr <> 0 Or ErrorLevel <> 0)
		Msgbox % "Error in IScriptControl::Error: ErrorLevel=" ErrorLevel "  iErr=" iErr
	Return ppvScriptError
}

; ..............................................................................

IScriptControl_AddObject(ppvScriptControl, sName, pObjectDispatch, blnAddMembers)
{
	bstrName := __SysAllocStringA(sName)
	iErr := DllCall(__VTable(ppvScriptControl, 24), "UInt", ppvScriptControl
				, "UInt", bstrName
				, "UInt", pObjectDispatch
				, "Short", blnAddMembers
				, "UInt")
	__SysFreeString(bstrName)
	If (iErr <> 0 Or ErrorLevel <> 0)
		Return "Error in IScriptControl::AddObject: ErrorLevel=" ErrorLevel "  iErr=" iErr
}

; ..............................................................................

IScriptControl_Eval(ppvScriptControl, sExpression, ByRef VarRet)
{
	bstrExpression := __SysAllocStringA(sExpression)
	VarSetCapacity(VarRet, 16) ; sizeof(VARIANT) = 16
	__VariantInit(VarRet)
	iErr := DllCall(__VTable(ppvScriptControl, 27), "UInt", ppvScriptControl
				, "UInt", bstrExpression
				, "Str", VarRet
				, "UInt")
	__SysFreeString(bstrExpression)
	If (ErrorLevel <> 0)
		Msgbox % "Error calling IScriptError::Eval: ErrorLevel=" ErrorLevel
	; Return the error code to check for exceptions
	Return iErr
}

; ..............................................................................

IScriptControl_ExecuteStatement(ppvScriptControl, sStatement)
{
	bstrStatement := __SysAllocStringA(sStatement)
	iErr := DllCall(__VTable(ppvScriptControl, 28), "UInt", ppvScriptControl
				, "UInt", bstrStatement
				, "UInt")
	__SysFreeString(bstrStatement)
	If (ErrorLevel <> 0)
		Msgbox % "Error calling IScriptError::ExecuteStatement: ErrorLevel=" ErrorLevel
	; Return the error code to check for exceptions
	Return iErr
}

; ## IScriptError ##############################################################
/*
The entire IScriptError Vtable (only the * members are implemented)
0    call_QueryInterface    Returns a pointer to a specified interface on an object to which a client currently holds an interface pointer
1    call_AddRef            Increments the reference count for an interface on an object
2    call_Release           Decrements the reference count for the calling interface on a object
3    call_GetTypeInfoCount  Retrieves the number of type information interfaces that an object provides (either 0 or 1)
4    call_GetTypeInfo       Retrieves the type information for an object
5    call_GetIDsOfNames     Maps a single member and an optional set of argument names to a corresponding set of integer DISPIDs
6    call_Invoke            Provides access to properties and methods exposed by an object.
7  * get_Number             Error number
8    get_Source             Source of the error
9  * get_Description        Friendly description of error
10   get_HelpFile           File in which help for the error can be found
11   get_HelpContext        Context ID for the topic with information on the error
12   get_Text               Line of source code on which the error occurred
13   get_Line               Source code line number where the error occurred
14   get_Column             Source code column position where the error occurred
15 * call_Clear             Clear the script error
*/

IScriptError_Number(ppvScriptError)
{
	iErr := DllCall(__VTable(ppvScriptError, 7), "UInt", ppvScriptError
				, "Int*", iNumber
				, "UInt")
	If (iErr <> 0 Or ErrorLevel <> 0) ; #BeginErrorChecking
	{
		Msgbox % "IScriptError::Number error: ErrorLevel=" ErrorLevel "  iErr=" iErr
		Return
	}                                 ; #EndErrorChecking
	
	Return iNumber
}

; ..............................................................................

IScriptError_Description(ppvScriptError)
{
	iErr := DllCall(__VTable(ppvScriptError, 9), "UInt", ppvScriptError
				, "UInt*", bstrDescription
				, "UInt")
	If (iErr <> 0 Or ErrorLevel <> 0) ; #BeginErrorChecking
	{
		Msgbox % "IScriptError::Description error: ErrorLevel=" ErrorLevel "  iErr=" iErr
		Return
	}                                 ; #EndErrorChecking

	__Unicode2ANSI(bstrDescription, sAnsi)
	__SysFreeString(bstrDescription)
	Return sAnsi
}
; ..............................................................................

IScriptError_Clear(ppvScriptError)
{
	iErr := DllCall(__VTable(ppvScriptError, 15), "UInt", ppvScriptError
				, "UInt")
	If (iErr <> 0 Or ErrorLevel <> 0) ; #BeginErrorChecking
	{
		Msgbox % "Error in IScriptError_Clear: ErrorLevel=" ErrorLevel "  iErr=" iErr
		Return
	}                                 ; #EndErrorChecking
	Return iErr
}

; ## IClassFactory #############################################################

; Used in __CreateInstanceFromDll() function
IClassFactory_CreateInstance(ppvIClassFactory, pUnkOuter, ByRef riid, ByRef ppvObject)
{
	Return DllCall(__VTable(ppvIClassFactory, 3), "UInt", ppvIClassFactory
					, "UInt",  pUnkOuter
					, "Str",   riid
					, "Uint*", ppvObject
					, "UInt")
	
}

; ## ITypeInfo #################################################################
/*
The entire ITypeInfo Vtable (only the * members are implemented)
 0   call_QueryInterface        Returns pointers to supported interfaces.
 1   call_AddRef                Increments reference count.
 2   call_Release               Decrements reference count.
 3 * call_GetTypeAttr           Retrieves a TYPEATTR structure that contains the attributes of the type description.
 4   call_GetTypeComp           Retrieves the ITypeComp interface for the type description, which enables a client compiler to bind to the type description's members.
 5   call_GetFuncDesc           Retrieves the FUNCDESC structure that contains information about a specified function.
 6   call_GetVarDesc            Retrieves a VARDESC structure that describes the specified variable.
 7   call_GetNames              Retrieves the variable with the specified member ID (or the name of the property or method and its parameters) that correspond to the specified function ID.
 8   call_GetRefTypeOfImplType  If a type description describes a COM class, it retrieves the type description of the implemented interface types. For an interface, GetRefTypeOfImplType returns the type information for inherited interfaces, if any exist.
 9   call_GetImplTypeFlags      Retrieves the IMPLTYPEFLAGS enumeration for one implemented interface or base interface in a type description.
10   call_GetIDsOfNames         Maps between member names and member IDs, and parameter names and parameter IDs.
11   call_Invoke                Invokes a method, or accesses a property of an object, that implements the interface described by the type description.
12   call_GetDocumentation      Retrieves the documentation string, the complete Help file name and path, and the context ID for the Help topic for a specified type description.
13   call_GetDllEntry           Retrieves a description or specification of an entry point for a function in a DLL.
14   call_GetRefTypeInfo        If a type description references other type descriptions, it retrieves the referenced type descriptions.
15   call_AddressOfMember       Retrieves the addresses of static functions or variables, such as those defined in a DLL.
16   call_CreateInstance        Creates a new instance of a type that describes a component object class (coclass).
17   call_GetMops               Retrieves marshaling information.
18   call_GetContainingTypeLib  Retrieves the containing type library and the index of the type description within that type library.
19 * call_ReleaseTypeAttr       Releases a TYPEATTR previously returned by GetTypeAttr.
20   call_ReleaseFuncDesc       Releases a FUNCDESC previously returned by GetFuncDesc.
21   call_ReleaseVarDesc        Releases a VARDESC previously returned by GetVarDesc.
*/

; Returns pointer to a TYPEATTR structure on success, "" on failure.
; Sets ErrorLevel.
ITypeInfo_GetTypeAttr(ppTypeInfo) 
{
	iErr := DllCall(__VTable(ppTypeInfo, 3), "UInt", ppTypeInfo
					, "UInt*", pTypeAttr)
			
	If (ErrorLevel <> 0) ; #BeginErrorChecking
	{
		__ComError(ErrorLevel, "ITypeInfo::GetTypeAttr: Error calling dll function: " ErrorLevel)
		Return
	}
	If (iErr = 0) ; S_OK
	{
		__ComErrorClear()
	}
	Else If (iErr = 0x8007000E) ; E_OUTOFMEMORY
	{
		__ComError(iErr, "ITypeInfo::GetTypeAttr: Out of memory.")
		Return
	}
	Else If (iErr = 0x80070057) ; E_INVALIDARG
	{
		__ComError(iErr, "ITypeInfo::GetTypeAttr: One or more of the parameters is invalid.")
		Return
	}
	Else If (iErr = 0x80028CA2) ; TYPE_E_IOERROR
	{
		__ComError(iErr, "ITypeInfo::GetTypeAttr: The function could not write to the file.")
		Return
	}
	Else If (iErr = 0x80028018) ; TYPE_E_INVDATAREAD
	{
		__ComError(iErr, "ITypeInfo::GetTypeAttr: The function could not read from the file.")
		Return
	}
	Else If (iErr = 0x80028019) ; TYPE_E_UNSUPFORMAT
	{
		__ComError(iErr, "ITypeInfo::GetTypeAttr: The type library has an older format.")
		Return
	}
	Else If (iErr = 0x80028029) ; TYPE_E_INVALIDSTATE
	{
		__ComError(iErr, "ITypeInfo::GetTypeAttr: The type library could not be opened.")
		Return
	}
	Else
	{
		__ComError(iErr, "ITypeInfo::GetTypeAttr: error " iErr)
		Return
	}                    ; #EndErrorChecking
			
	Return pTypeAttr
	
}


ITypeInfo_ReleaseTypeAttr(ppTypeInfo, pTypeAttr)
{
	DllCall(__VTable(ppTypeInfo, 19), "UInt", ppTypeInfo
			, "UInt" , pTypeAttr)                        
}

; ## IDispatch #################################################################
/*
The entire IDispatch Vtable (only the * members are implemented)
 0   call_QueryInterface    Returns pointers to supported interfaces.
 1   call_AddRef            Increments reference count.
 2   call_Release           Decrements reference count.
 3 * call_GetTypeInfoCount  Retrieves the number of type information interfaces that an object provides (either 0 or 1).
 4 * call_GetTypeInfo       Gets the type information for an object.
 5   call_GetIDsOfNames     Maps a single member and an optional set of argument names to a corresponding set of integer DISPIDs.
 6   call_Invoke            Provides access to properties and methods exposed by an object.
*/


IDispatch_GetTypeInfoCount(ppDispatch)
{
	iErr := DllCall(__VTable(ppDispatch, 3), "UInt", ppDispatch
					, "UInt*", iTypeInfoCount)
	
	If (ErrorLevel <> 0) ; #BeginErrorChecking
	{
		__ComError(ErrorLevel, "IDispatch::GetTypeInfoCount: Error calling dll function: " ErrorLevel)
		Return
	}
	If (iErr = 0) ; S_OK
	{
		__ComErrorClear()
	}
	Else If (iErr = 0x80004001) ; E_NOTIMPL
	{
		__ComError(iErr, "IDispatch::GetTypeInfoCount: Failure.")
		Return
	}
	Else
	{
		__ComError(iErr, "IDispatch::GetTypeInfoCount: error " iErr)
		Return
	}                    ; #EndErrorChecking
	
	Return iTypeInfoCount
}

IDispatch_GetTypeInfo(ppDispatch, LCID = 0)
{
	iErr := DllCall(__VTable(ppDispatch, 4), "UInt", ppDispatch
					, "UInt", 0   ; iTInfo
					, "UInt", LCID
					, "UInt*", ppTypeInfo)
					
	If (ErrorLevel <> 0) ; #BeginErrorChecking
	{
		__ComError(ErrorLevel, "IDispatch::GetTypeInfo: Error calling dll function: " ErrorLevel)
		Return
	}
	If (iErr = 0) ; S_OK
	{
		__ComErrorClear()
	}
	Else If (iErr = 0x8002000B) ; DISP_E_BADINDEX
	{
		__ComError(iErr, "IDispatch::GetTypeInfo: Failure; iTInfo argument was not 0.")
		Return
	}
	Else
	{
		__ComError(iErr, "IDispatch::GetTypeInfo: error " iErr)
		Return
	}                    ; #EndErrorChecking
	
	Return ppTypeInfo
}

; ## IUnknown ##################################################################
/*
The entire IDispatch Vtable (only the * members are implemented)
 0 * call_QueryInterface    Returns pointers to supported interfaces.
 1 * call_AddRef            Increments reference count.
 2 * call_Release           Decrements reference count.
*/

; iid can be a string IID (e.g. "{00000000-0000-0000-C000-000000000046}")
; or a pointer to the binary version of that string.
IUnknown_QueryInterface(ppv, iid)
{
	; Is it a pointer to a binary IID? (check if it's a number)
	If iid is Integer
	{
		iErr := DllCall(__VTable(ppv,0), "UInt", ppv
					, "UInt" , iid
					, "UInt*", ppvNewInterface
					, "UInt")
	}
	Else
	{
		If (!__IIDFromString(iid, biniid))
			Return 
	
		iErr := DllCall(__VTable(ppv,0), "UInt", ppv
					, "Str"  , biniid
					, "UInt*", ppvNewInterface
					, "UInt")
	}

	If (ErrorLevel <> 0) ; #BeginErrorChecking
	{
		__ComError(ErrorLevel, "IUnknown::QueryInterface: Error calling dll function: " ErrorLevel)
		Return
	}
	If (iErr = 0) ; S_OK
	{
		__ComErrorClear()
	}
	Else If (iErr = 0x80004002) ; E_NOINTERFACE
	{
		__ComError(iErr, "IUnknown::QueryInterface: the interface is not supported")
		Return
	}
	Else
	{
		__ComError(iErr, "IUnknown::QueryInterface: error " iErr)
		Return
	}                    ; #EndErrorChecking
	Return ppvNewInterface
}

; ..............................................................................

IUnknown_AddRef(ppv)
{
	iCount := DllCall(__VTable(ppv,1), "UInt", ppv, "UInt")
	If (ErrorLevel <> 0) ; #BeginErrorChecking
	{
		__ComError(ErrorLevel, "IUnknown::AddRef: Error calling dll function: " ErrorLevel)
		Return
	}                    ; #EndErrorChecking
	Return iCount
}

; ..............................................................................

IUnknown_Release(ppv)
{
	iCount := DllCall(__VTable(ppv,2), "UInt", ppv, "UInt")
	; Not sure if this should be 1 or 0
	If (iCount <> 1) ; #BeginErrorChecking
	{
		__ComError(iCount, "IUnknown::Release: Object was not deallocated because there are additional references to it")
		; Not really an error since the call was successful
	}                ; #EndErrorChecking
	Return iCount
}

; ## Helper functions ##########################################################

__ANSI2Unicode(sAnsi, ByRef sUtf16)
{
	iSize := DllCall("MultiByteToWideChar"
   					, "UInt", 0  ; from CP_ACP (ANSI)
					, "UInt", 0  ; no flags
					, "UInt" , &sAnsi
					, "int" , -1 ; until NULL
					, "UInt", 0  ; NULL
					, "int" , 0)
	If (iSize < 1)
	{
		sUtf16 := Chr(0)
		Return False
	}
	
	VarSetCapacity(sUtf16, (iSize+1) * 2)
   
	iSize := DllCall("MultiByteToWideChar"
   					, "UInt", 0  ; from CP_ACP (ANSI)
					, "UInt", 0  ; no flags
					, "UInt" , &sAnsi
					, "int" , -1 ; until NULL
					, "UInt" , &sUtf16
					, "int" , iSize)
	If (iSize < 1)
	{
		sUtf16 := Chr(0)
		Return False
	}
	Else
		Return True
}

; ..............................................................................

; psUtf16 : The address of the Unicode string to convert
__Unicode2ANSI(psUtf16, ByRef sAnsi)
{
	If (psUtf16 = 0)
	{
		sAnsi := ""
		Return True
	}
	
	iSize := DllCall("WideCharToMultiByte"
					, "UInt", 0  ; to CP_API (ANSI)
					, "UInt", 0  ; no flags
					, "UInt", psUtf16
					, "int", -1  ; until NULL
					, "UInt", 0  ; NULL
					, "int",  0  ; Just find length
					, "UInt", 0  ; NULL
					, "UInt", 0) ; NULL
					
	If (iSize < 1)
		Return False
		
	VarSetCapacity(sAnsi, iSize+1)
	iSize := DllCall("WideCharToMultiByte"
					, "UInt", 0  ; to CP_API (ANSI)
					, "UInt", 0  ; no flags
					, "UInt", psUtf16
					, "int", -1  ; until NULL
					, "Str", sAnsi
					, "int", iSize
					, "UInt", 0  ; NULL
					, "UInt", 0) ; NULL
	If (iSize < 1)
		Return False
	Else
		Return True
}

; ..............................................................................

__VTable(ppv, idx)
{
	Return NumGet(NumGet(ppv+0) + 4*idx)
}

; ..............................................................................

; Converts a normal ANSI string to Unicode, then creates a BSTR with it
__SysAllocStringA(sAnsi)
{
	__ANSI2Unicode(sAnsi, sUnicode)
	Return DllCall("oleaut32\SysAllocString", "Str", sUnicode, "UInt")
}

; ..............................................................................

__SysFreeString(iBstrPtr)
{
	Return DllCall("oleaut32\SysFreeString", "UInt", iBstrPtr, "UInt")
}

; ..............................................................................

__VariantClear(ByRef VAR)
{
	Return DllCall("oleaut32\VariantClear", "Str", VAR, "UInt")
}

; ..............................................................................

__VariantInit(ByRef VAR)
{
	Return DllCall("oleaut32\VariantInit", "Str", VAR, "UInt")
}

; ..............................................................................

; Converts a VARIANT structure to a normal AHK variable.
; Not all VARIANT types are handled.
__UnpackVARIANT(ByRef VARIANT, ByRef xReturn)
{
	static VT_BYREF := 0x4000
	vt := NumGet(VARIANT, 0, "UShort")
	pdata := &VARIANT + 8
	
	; VT_BSTR
	If (vt = 8)
	{
		__Unicode2ANSI(NumGet(pdata+0), xReturn)
		__VariantClear(VARIANT)
		Return True
	}
	Else If (vt = 8|VT_BYREF)
	{
		__Unicode2ANSI(NumGet(NumGet(pdata+0)), xReturn)
		__VariantClear(VARIANT)
		Return True
	}
	; VT_EMPTY
	Else If (vt = 0)
	{
		xReturn := ""
		Return True
	}
	; VT_UI1
	Else If (vt = 17)
	{
		xReturn := NumGet(pdata+0, 0,"UChar")
		Return True
	}
	Else If (vt = 17|VT_BYREF)
	{
		xReturn := NumGet(NumGet(pdata+0), 0,"UChar")
		Return True
	}
	; VT_I2
	Else If (vt = 2)
	{
		xReturn := NumGet(pdata+0, 0, "Short")
		Return True
	}
	Else If (vt = 2|VT_BYREF)
	{
		xReturn := NumGet(NumGet(pdata+0), 0,"Short")
		Return True
	}
	; VT_I4
	Else If (vt = 3)
	{
		xReturn := NumGet(pdata+0, 0,"Int")
		Return True
	}
	Else If (vt = 3|VT_BYREF)
	{
		xReturn := NumGet(NumGet(pdata+0), 0,"Int")
		Return True
	}
	; VT_R4
	Else If (vt = 4)
	{
		xReturn := NumGet(pdata+0, 0,"Float")
		Return True
	}
	Else If (vt = 4|VT_BYREF)
	{
		xReturn := NumGet(NumGet(pdata+0), 0,"Float")
		Return True
	}
	; VT_R8
	Else If (vt = 5)
	{
		xReturn := NumGet(pdata+0, 0,"Double")
		Return True
	}
	Else If (vt = 5|VT_BYREF)
	{
		xReturn := NumGet(NumGet(pdata+0), 0,"Double")
		Return True
	}
	; VT_BOOL
	Else If (vt = 11)
	{
		xVal := NumGet(pdata+0, 0,"Short")
		xReturn := -xVal ; fix -1 = true
		Return True
	}
	Else If (vt = 11|VT_BYREF)
	{
		xVal := NumGet(NumGet(pdata+0), 0,"Short")
		xReturn := -xVal ; fix -1 = true
		Return True
	}
	; VT_ERROR
	Else If (vt = 10)
	{
		xReturn := NumGet(pdata+0, 0,"UInt")
		Return True
	}
	Else If (vt = 10|VT_BYREF)
	{
		xReturn := NumGet(NumGet(pdata+0), 0,"UInt")
		Return True
	}
	; VT_DISPATCH or VT_UNKNOWN
	Else If ((vt = 9) Or (vt = 13))
	{
		xVal := NumGet(pdata+0, 0,"UInt")
		If (xVal = 0)
			xReturn := ""
		Else
			xReturn := xVal
		Return True
	}
	Else If ((vt = 9|VT_BYREF) Or (vt = 13|VT_BYREF))
	{
		xVal := NumGet(NumGet(pdata+0), 0,"UInt")
		If (xVal = 0)
			xReturn := ""
		Else
			xReturn := xVal
		Return True
	}
/*
	Unhandled VARIANT types:
	Array, Currency, Date, VARIANT*, and DECIMAL*
*/ 	
	Return False
}

