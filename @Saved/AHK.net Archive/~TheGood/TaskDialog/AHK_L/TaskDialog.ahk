/*! TheGood
    TaskDialog() - Launches a Task Dialog (Windows Vista and later only)
    http://www.autohotkey.com/forum/viewtopic.php?t=58952
    Last updated: August 22nd, 2010
    ________________________________________________________________________________________________________________________
    Parameter:      Description:
    
    hParent         Handle to the parent window. This will cause the Task Dialog to become modal. Leave 0 if that is
                    undesirable.
                    
                    hParent could also be used as the sCallback parameter when it is the only parameter you wish to provide.
                    For example, using TaskDialog("CallbackFunc") is the same as 
                    TaskDialog(0, "", "", 0, "", "", "CallbackFunc"). This is useful when you intend to build a multi-page
                    wizard using the hNavigate parameter, and you want to create your first page in your callback function
                    (so that it's easier to implement a Back button).
    
    sText           Text displayed inside the Task Dialog. It is a pipe-delimited list of the following components:
                        o sWindowTitle
                        o sMainInstruction
                        o sContent
                        o sExpandedInformation
                        o sFooter
                        o sVerificationText
                        o sCollapsedControlText
                        o sExpandedControlText
                    All components are optional. For example, to only fill in sWindowTitle and sMainInstruction, set sText
                    to "This is my window title|This is my main instruction." To only fill in sWindowTitle and sFooter, set
                    sText to "This is my window title||||This is my footer." To use the characters | and \ as part of the
                    text, escape them with a backslash (i.e. "\"). For example,
                    sText := "Window Title|A backslash in the instruction: \\|A pipe in the content: \||Expanded info."
                    
                    To use a resource string, prefix the string ID by a backslash. You must specify the module handle or
                    path in the third parameter of sIcons. For example: sText := "\65430|The window title uses a res. ID"
    
    sButtons        Buttons to display in the Task Dialog. It is a pipe-delimited list of their caption text. It may be a
                    combination of custom buttons and common buttons. The following button texts are recognized as common
                    buttons: OK, YES, NO, CANCEL, RETRY, CLOSE. If this parameter is absent, an OK button will appear. Put
                    two pipes at the end of a button's caption text to make it the default button. To use the characters |
                    and \ as part of the text, escape them with a backslash (i.e. "\").
                    
                    To use a resource string, prefix the string ID by a backslash. You must specify the module handle or
                    path in the third parameter of sIcons.
    
    iFlags          Combination of flags used to specify the behaviour of the Task Dialog. See MSDN for available flags and
                    their meaning (look at the dwFlags member): http://msdn.microsoft.com/en-us/library/bb787473
                    Their values are:
                        o TDF_ENABLE_HYPERLINKS             0x0001
                        o TDF_USE_HICON_MAIN                0x0002
                        o TDF_USE_HICON_FOOTER              0x0004
                        o TDF_ALLOW_DIALOG_CANCELLATION     0x0008
                        o TDF_USE_COMMAND_LINKS             0x0010
                        o TDF_USE_COMMAND_LINKS_NO_ICON     0x0020
                        o TDF_EXPAND_FOOTER_AREA            0x0040
                        o TDF_EXPANDED_BY_DEFAULT           0x0080
                        o TDF_VERIFICATION_FLAG_CHECKED     0x0100
                        o TDF_SHOW_PROGRESS_BAR             0x0200
                        o TDF_SHOW_MARQUEE_PROGRESS_BAR     0x0400
                        o TDF_CALLBACK_TIMER                0x0800
                        o TDF_POSITION_RELATIVE_TO_WINDOW   0x1000
                        o TDF_RTL_LAYOUT                    0x2000
                        o TDF_NO_DEFAULT_RADIO_BUTTON       0x4000
                        o TDF_CAN_BE_MINIMIZED              0x8000
    
    sIcons          Pipe-delimited list of parameters that defines the icons used for the main icon and the footer icon. The
                    syntax is as follow (all parameters are optional - use 0 or keep blank if not needed):
                    <Main Icon Name/Handle/Resource ID>|<Footer Icon Name/Handle/Resourse ID>|<DLL/EXE path or module handle>
                    
                    The following Icon Name is recognized: WARNING, ERROR, INFO, SHIELD, BLUE, YELLOW, RED, GREEN, GREY.
                    
                    To use an icon handle, you can load it first using the API function LoadImage. Just make sure to use the
                    right icon size (the main icon is 32x32 and the footer is 16x16). You will also have to use the
                    appropriate flags (TDF_USE_HICON_MAIN and/or TDF_USE_HICON_FOOTER).  
                    
                    To use a resource icon, prefix its resource ID by a backslash. The icon resource ID is either a 16-bit
                    integer or a name. You must then specify the module handle or path in the third parameter. For example,
                    to use AutoHotkey's icon, use: 
                    sIcons := "\159|\159|" . A_AhkPath (159 is the resource ID of the icon inside AutoHotkey.exe)
                    To use the characters | and \ as part of the icon name, escape them with a backslash (i.e. "\").
    
    sRadios         Radio buttons to display in the Task Dialog. It is a pipe-delimited list of their caption text. Put two
                    pipes at the end of a radio button's caption text to make it the default radio button. Otherwise, the
                    first radio button will be made the default one. Use the TDF_NO_DEFAULT_RADIO_BUTTON flag to counter
                    this. To use the characters | and \ as part of the text, escape them with a backslash (i.e. "\").
                    
                    To use a resource string, prefix the string ID by a backslash. You must specify the module handle or
                    path in the third parameter of sIcons.
    
    sCallback       Specify a callback function. You may attach a specific reference data (a 32-bit int) by adding a pipe
                    and the int after. This int will be sent to the callback function when called (see dwRefData). For
                    example, sCallback := "MyFunction|4294967295". See MSDN for more information on the function's signature
                    and possible notifications: http://msdn.microsoft.com/en-us/library/bb760542
                    Notification and message values are:                                                   (WM_USER = 0x400)
                        o TDN_CREATED                   0       o TDM_NAVIGATE_PAGE                           WM_USER+101
                        o TDN_NAVIGATED                 1       o TDM_CLICK_BUTTON                            WM_USER+102
                        o TDN_BUTTON_CLICKED            2       o TDM_SET_MARQUEE_PROGRESS_BAR                WM_USER+103
                        o TDN_HYPERLINK_CLICKED         3       o TDM_SET_PROGRESS_BAR_STATE                  WM_USER+104
                        o TDN_TIMER                     4       o TDM_SET_PROGRESS_BAR_RANGE                  WM_USER+105
                        o TDN_DESTROYED                 5       o TDM_SET_PROGRESS_BAR_POS                    WM_USER+106
                        o TDN_RADIO_BUTTON_CLICKED      6       o TDM_SET_PROGRESS_BAR_MARQUEE                WM_USER+107
                        o TDN_DIALOG_CONSTRUCTED        7       o TDM_SET_ELEMENT_TEXT                        WM_USER+108
                        o TDN_VERIFICATION_CLICKED      8       o TDM_CLICK_RADIO_BUTTON                      WM_USER+110
                        o TDN_HELP                      9       o TDM_ENABLE_BUTTON                           WM_USER+111
                        o TDN_EXPANDO_BUTTON_CLICKED    10      o TDM_ENABLE_RADIO_BUTTON                     WM_USER+112
                                                                o TDM_CLICK_VERIFICATION                      WM_USER+113
                                                                o TDM_UPDATE_ELEMENT_TEXT                     WM_USER+114
                                                                o TDM_SET_BUTTON_ELEVATION_REQUIRED_STATE     WM_USER+115
                                                                o TDM_UPDATE_ICON                             WM_USER+116
    
    iWidth          The width of the task dialog's client area. Leave 0 for the ideal width to be automatically calculated.
    
    hNavigate       Handle to an existing Task Dialog. This allows you to recreate the task dialog with new contents,
                    simulating the functionality of a multi-page wizard. It uses the TDM_NAVIGATE_PAGE message. See MSDN for
                    more details: http://msdn.microsoft.com/en-us/library/bb787509
    
    Return value    If the function succeeds, the return value is the ID of the button clicked. Common button IDs are:
                            o OK      1
                            o YES     6
                            o NO      7
                            o CANCEL  2
                            o RETRY   4
                            o CLOSE   8
                        If the button clicked is a custom button, the button ID is 1000 + <Button position in sButtons>.
                        Common buttons do not count. For example, if sButtons = "CUSTOM1|CUSTOM2|YES|NO|CUSTOM3" and the
                        user clicks on CUSTOM3, the return value will be 1003.
                        
                        ErrorLevel additionally contains the radio button ID of the radio button selected in its highword,
                        and the value of the checkbox in its lowword. The radio button ID is 2000 + <Radio button position
                        in sRadios>. The checkbox value is either True or False. To extract them individually, you can use:
                        iSelectedRadioID := ErrorLevel >> 16, bChecked := ErrorLevel & 0xFFFF
                    
                    If the function fails, the return value is 0 with ErrorLevel containing either the reason the
                        DllCall failed (like -1, -2, An, etc...) or TaskDialogIndirect's return value (see MSDN for values).
*/
TaskDialog(hParent = 0, sText = "", sButtons = "", iFlags = 0, sIcons = "", sRadios = "", sCallback = "", iWidth = 0, hNavigate = 0) {
    
    ;Check if Windows version is appropriate (i.e. at least Windows Vista/Server 2008)
    If (DllCall("GetVersion") & 0xFF < 6) {
        ErrorLevel := "You need at least Windows Vista or Windows Server 2008 to use TaskDialog()."
        Return 0
    }
    
    ;Check if hParent actually holds the callback function
    If hParent is not integer
        sCallback := hParent, hParent := 0
    
    ;Split text, if any
    If sText {
        _TaskDialog_PrepSplitString(sText)
        StringSplit, sText, sText, % Chr(3)
    }
    
    ;Check for resource numbers
    Loop % sText0 {
        If (SubStr(sText%A_Index%, 1, 1) = Chr(4)) {
            s := SubStr(sText%A_Index%, 2)
            If s is integer
                sText%A_Index%_IsRes := True, sText%A_Index% := s
        }
    }
    
    ;Check if user wants custom buttons
    If sButtons {
        
        ;Split buttons
        _TaskDialog_PrepSplitString(sButtons)
        StringSplit, sButtons, sButtons, % Chr(3)
        
        ;Extract common buttons and default button
        Loop % sButtons0 {
            
            If (sButtons%A_Index% = "OK") And (sLast := "OK")
                iCommonButtons += (iCommonButtons & 0x0001 ? 0 : 0x0001)
            Else If (sButtons%A_Index% = "YES") And (sLast := "YES")
                iCommonButtons += (iCommonButtons & 0x0002 ? 0 : 0x0002)
            Else If (sButtons%A_Index% = "NO") And (sLast := "NO")
                iCommonButtons += (iCommonButtons & 0x0004 ? 0 : 0x0004)
            Else If (sButtons%A_Index% = "CANCEL") And (sLast := "CANCEL")
                iCommonButtons += (iCommonButtons & 0x0008 ? 0 : 0x0008)
            Else If (sButtons%A_Index% = "RETRY") And (sLast := "RETRY")
                iCommonButtons += (iCommonButtons & 0x0010 ? 0 : 0x0010)
            Else If (sButtons%A_Index% = "CLOSE") And (sLast := "CLOSE")
                iCommonButtons += (iCommonButtons & 0x0020 ? 0 : 0x0020)
            Else If (sButtons%A_Index% = "") And Not iDefaultButtonID And sLast {
                If (sLast = "OK")
                    iDefaultButtonID := 1
                Else If (sLast = "YES")
                    iDefaultButtonID := 6
                Else If (sLast = "NO")
                    iDefaultButtonID := 7
                Else If (sLast = "CANCEL")
                    iDefaultButtonID := 2
                Else If (sLast = "RETRY")
                    iDefaultButtonID := 4
                Else If (sLast = "CLOSE")
                    iDefaultButtonID := 8
            } Else {
                sLast := ""
                Continue
            }
            
            ;Nuke it from the array
            If (A_Index <> sButtons0) {
                StringReplace, sButtons, sButtons, % sLast Chr(3)
                
            ;We're at the last one. Check if it's the only item left
            } Else If Not InStr(sButtons, Chr(3)) {
                sButtons := ""
                Break
                
            ;Only nuke it
            } Else StringReplace, sButtons, sButtons, % sLast
        }
        
        ;Cure the array (also check for a default if we didn't find one yet in the common buttons) and re-split
        i := _TaskDialog_CureStringArray(sButtons)
        If Not iDefaultButtonID And i
            iDefaultButtonID := i + 1000
        StringSplit, sButtons, sButtons, % Chr(3)
        
        ;Check for resource numbers
        Loop % sButtons0 {
            If (SubStr(sButtons%A_Index%, 1, 1) = Chr(4)) {
                s := SubStr(sButtons%A_Index%, 2)
                If s is integer
                    sButtons%A_Index%_IsRes := True, sButtons%A_Index% := s
            }
        }
    }
    
    ;Check if user wants radio buttons
    If sRadios {
        
        ;Split radio buttons
        _TaskDialog_PrepSplitString(sRadios)
        StringSplit, sRadios, sRadios, % Chr(3)
        
        ;Cure the array and resplit
        iDefaultRadioID := (i := _TaskDialog_CureStringArray(sRadios)) ? i + 2000 : 0
        StringSplit, sRadios, sRadios, % Chr(3)
        
        ;Check for resource numbers
        Loop % sRadios0 {
            If (SubStr(sRadios%A_Index%, 1, 1) = Chr(4)) {
                s := SubStr(sRadios%A_Index%, 2)
                If s is integer
                    sRadios%A_Index%_IsRes := True, sRadios%A_Index% := s
            }
        }
    }
    
    ;Translate the strings to UTF-16
    Loop % sText0 {
        If Not sText%A_Index%_IsRes
            iText%A_Index% := &sText%A_Index%
        Else iText%A_Index% := sText%A_Index%
    }
    
    Loop % sButtons0 {
        If Not sButtons%A_Index%_IsRes
            iButtons%A_Index% := &sButtons%A_Index%
        Else iButtons%A_Index% := sButtons%A_Index%
    }
    
    Loop % sRadios0 {
        If Not sRadios%A_Index%_IsRes
            iRadios%A_Index% := &sRadios%A_Index%
        Else iRadios%A_Index% := sRadios%A_Index%
    }
    
    ;Prep the custom buttons, if any
    If sButtons0 {
        
        ;Prep the TASKDIALOG_BUTTON struct
        VarSetCapacity(tdbButtons, (4 + A_PtrSize) * sButtons0, 0)
        Loop % sButtons0 {
            NumPut(   A_Index + 1000, tdbButtons, (4 + A_PtrSize) * (A_Index - 1) + 0, "UInt")
            NumPut(iButtons%A_Index%, tdbButtons, (4 + A_PtrSize) * (A_Index - 1) + 4, "UPtr")
        }
    }
    
    ;Prep the radio buttons, if any
    If sRadios0 {
        
        ;Prep the TASKDIALOG_BUTTON struct
        VarSetCapacity(tdbRadios, (4 + A_PtrSize) * sRadios0, 0)
        Loop % sRadios0 {
            NumPut(  A_Index + 2000, tdbRadios, (4 + A_PtrSize) * (A_Index - 1) + 0, "UInt")
            NumPut(iRadios%A_Index%, tdbRadios, (4 + A_PtrSize) * (A_Index - 1) + 4, "UPtr")
        }
    }
    
    ;Split the icons
    _TaskDialog_PrepSplitString(sIcons)
    StringSplit, sIcons, sIcons, % Chr(3)
    
    ;Check what we were given
    If sIcons0 And (sIcons0 < 3) {
        ;Icon can only be a handle or a common icon
        iMainIcon   := _TaskDialog_ResolveIcon(sIcons1)
        iFooterIcon := _TaskDialog_ResolveIcon(sIcons2)
    } Else If (sIcons0 = 3) {
        
        ;Check for resource IDs
        If (SubStr(sIcons1, 1, 1) = Chr(4)) {
            s := SubStr(sIcons1, 2)
            If s is integer ;Check if resource ID is a number
                iMainIcon := s
            Else { ;Resource ID is a name
                sMainIcon := s
                iMainIcon := &sMainIcon
            } ;Not resource ID -> Either a common icon or an icon handle
        } Else iMainIcon := _TaskDialog_ResolveIcon(sIcons1)
        
        ;Check for resource IDs
        If (SubStr(sIcons2, 1, 1) = Chr(4)) {
            s := SubStr(sIcons2, 2)
            If s is integer ;Check if resource ID is a number
                iFooterIcon := s
            Else { ;Resource ID is a name
                sFooterIcon := s
                iFooterIcon := &sFooterIcon
            } ;Not resource ID -> Either a common icon or an icon handle
        } Else iFooterIcon := _TaskDialog_ResolveIcon(sIcons2)
        
        StringReplace, sIcons3, sIcons3, % Chr(4), \, All
        
        ;Check if it's a path (otherwise assume it's already a handle)
        If (FileExist(sIcons3))
            hModule := DllCall("LoadLibrary", "Str", sIcons3, "Ptr"), bUnload := True
        Else hModule := sIcons3
    }
    
    ;Split the callback string
    StringSplit, sCallback, sCallback, |
    
    ;Check what we got
    If (sCallback0 = 1)
        sCBFunc := sCallback1
    Else If (sCallback0 = 2) {
        sCBFunc := sCallback1
        sCBData := sCallback2
    }
    
    ;Prep the TASKDIALOGCONFIG struct
    VarSetCapacity(TDC, 160, 0), ptr := 0, z := A_PtrSize
    
    NumPut(            4 * 8 + z * 16, TDC, ptr += 0, "UInt") ;cbSize
    NumPut(                   hParent, TDC, ptr += 4, "UPtr") ;hwndParent
    NumPut(                   hModule, TDC, ptr += z, "UPtr") ;hInstance
    NumPut(                    iFlags, TDC, ptr += z, "UInt") ;dwFlags
    NumPut(            iCommonButtons, TDC, ptr += 4, "UInt") ;dwCommonButtons
    NumPut(                    iText1, TDC, ptr += 4, "UPtr") ;pszWindowTitle
    NumPut(                 iMainIcon, TDC, ptr += z, "UPtr") ;pszMainIcon
    NumPut(                    iText2, TDC, ptr += z, "UPtr") ;pszMainInstruction
    NumPut(                    iText3, TDC, ptr += z, "UPtr") ;pszContent
    NumPut(                 sButtons0, TDC, ptr += z, "UInt") ;cButtons
    NumPut(               &tdbButtons, TDC, ptr += 4, "UPtr") ;pButtons
    NumPut(          iDefaultButtonID, TDC, ptr += z, "UInt") ;nDefaultButton
    NumPut(                  sRadios0, TDC, ptr += 4, "UInt") ;cRadioButtons
    NumPut(                &tdbRadios, TDC, ptr += 4, "UPtr") ;pRadioButtons
    NumPut(           iDefaultRadioID, TDC, ptr += z, "UInt") ;nDefaultRadioButton
    NumPut(                    iText6, TDC, ptr += 4, "UPtr") ;pszVerificationText
    NumPut(                    iText4, TDC, ptr += z, "UPtr") ;pszExpandedInformation
    NumPut(                    iText8, TDC, ptr += z, "UPtr") ;pszExpandedControlText
    NumPut(                    iText7, TDC, ptr += z, "UPtr") ;pszCollapsedControlText
    NumPut(               iFooterIcon, TDC, ptr += z, "UPtr") ;pszFooterIcon
    NumPut(                    iText5, TDC, ptr += z, "UPtr") ;pszFooter
    NumPut( RegisterCallback(sCBFunc), TDC, ptr += z, "UPtr") ;pfCallback
    NumPut(                   sCBData, TDC, ptr += z, "UPtr") ;lpCallbackData
    NumPut(                    iWidth, TDC, ptr += z, "UInt") ;cxWidth
    
    ;Check if we're doing a TDM_NAVIGATE_PAGE
    If hNavigate {
        DetectHiddenWindows, On ;Just in case the Task Dialog is hidden
        SendMessage, 0x400 + 101, 0, &TDC,, ahk_id %hNavigate%
        If bUnload
            DllCall("FreeLibrary", "Ptr", hModule)
    } Else {
        
        r := DllCall("TaskDialogIndirect", "Ptr", &TDC, "UInt*", iButtonClicked, "UInt*", iRadioChecked, "UInt*", bCheckboxChecked, "UInt")
        sErrorLevel := ErrorLevel ;Remember error, if any
        If bUnload
            DllCall("FreeLibrary", "Ptr", hModule)
        
        ;Check for error
        If Not r
            r := ErrorLevel := iRadioChecked << 16 | bCheckboxChecked
        Else ErrorLevel := sErrorLevel ? sErrorLevel : r ;Restore the error we had, if any
        
        Return iButtonClicked
    }
}

;INTERNAL FUNCTIONS

_TaskDialog_PrepSplitString(ByRef sString) {
    Static flip
     
    ;Based on Lazslo's rev_bytes
    ;http://www.autohotkey.com/forum/viewtopic.php?p=189469#189469
    If (flip = "") {
        If (A_PtrSize = 4)
            hex=8B4C24048B4424088D04413BC17619560FB750FE668B3183E80266893066891183C1023BC177E95EC3
        Else hex=4863C24C8D04414C3BC176200F1F40000FB701410FB750FE4983E802664189006689114883C1024C3BC177E4F3C3
        VarSetCapacity(flip, StrLen(hex) // 2)
        Loop % StrLen(hex)//2
            NumPut("0x" . SubStr(hex,2*A_Index-1,2), flip, A_Index-1, "Char")
        DllCall("VirtualProtect", "Ptr", &flip, "Ptr", VarSetCapacity(flip), "UInt", 0x40, "UInt*", 0)
    }
    
    ;We need to replace in reverse to keep the odd ones at the beginning
    DllCall(&flip, "Ptr", &sString, "UInt", StrLen(sString), "CDecl")
    StringReplace, sString, sString, \\, % Chr(1), All
    DllCall(&flip, "Ptr", &sString, "UInt", StrLen(sString), "CDecl")
    
    StringReplace, sString, sString, \|, % Chr(2), All
    StringReplace, sString, sString,  |, % Chr(3), All
    StringReplace, sString, sString,  \, % Chr(4), All
    StringReplace, sString, sString,  % Chr(2), |, All
    StringReplace, sString, sString,  % Chr(1), \, All
}

_TaskDialog_CureStringArray(ByRef sString) {
    
    While (SubStr(sString, 1, 1) = Chr(3))
        StringTrimLeft, sString, sString, 1
    
    ;Check for a default
    If (i := InStr(sString, Chr(3) Chr(3))) {
        
        ;Check index by counting delimiters
        j := 1, n := 1
        While ((j := InStr(sString, Chr(3), False, j)) < i)
            n += 1, j += 1
    }
    
    While (SubStr(sString, 0) = Chr(3))
        StringTrimRight, sString, sString, 1
    
    ErrorLevel := True
    While ErrorLevel
        StringReplace, sString, sString, % Chr(3) Chr(3), % Chr(3), UseErrorLevel
    
    Return n
}

_TaskDialog_ResolveIcon(sIcon) {
    Static sCommonIcons := "WARNING|ERROR|INFO|SHIELD|BLUE|YELLOW|RED|GREEN|GREY"
    Loop, Parse, sCommonIcons, |
        If (sIcon = A_LoopField)
            Return 0x10000 - A_Index
    Return sIcon
}
