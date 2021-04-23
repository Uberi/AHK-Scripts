/*! TheGood
    TaskDialog() Examples
    http://www.autohotkey.com/forum/viewtopic.php?t=58952
    Last updated: August 22nd, 2010
*/
    Gui, +LastFound -MinimizeBox
    hGui := WinExist()
    
    sCfg := "w200 +Left gbtnShow"
    Gui, Add, Button, Section %sCfg%1, % "   1: Simple TD"
    Gui, Add, Button,         %sCfg%2, % "   2: With more text"
    Gui, Add, Button,         %sCfg%3, % "   3: With all text fields filled in"
    Gui, Add, Button,         %sCfg%4, % "   4: Hyperlinks"
    Gui, Add, Button,         %sCfg%5, % "   5: Active hyperlinks"
    Gui, Add, Button,         %sCfg%6, % "   6: Icons"
    Gui, Add, Button,         %sCfg%7, % "   7: Custom icons"
    Gui, Add, Button,         %sCfg%8, % "   8: Common buttons"
    Gui, Add, Button,         %sCfg%9, % "   9: Custom buttons"
    Gui, Add, Button,        %sCfg%10, % "   10: Command links"
    Gui, Add, Button, ys     %sCfg%11, % "   11: Shield buttons"
    Gui, Add, Button,        %sCfg%12, % "   12: Using the checkbox"
    Gui, Add, Button,        %sCfg%13, % "   13: Radio buttons"
    Gui, Add, Button,        %sCfg%14, % "   14: Marquee progress bar"
    Gui, Add, Button,        %sCfg%15, % "   15: Updating the TD"
    Gui, Add, Button,        %sCfg%16, % "   16: Using the timer"
    Gui, Add, Button,        %sCfg%17, % "   17: Progress bar"
    Gui, Add, Button,        %sCfg%18, % "   18: Progress bar states"
    Gui, Add, Button,        %sCfg%19, % "   19: hNavigate"
    Gui, Add, Button,        %sCfg%20, % "   20: Return values"
    Gui, Show,, TaskDialog Examples
Return

GuiEscape:
GuiClose:
    ExitApp
Return

btnShow1:
    TaskDialog(hGui, "||This is a very simple Task Dialog. The window title was filled in automatically because we didn't specify any. "
             . "`n`nIt is made modal simply by filling in the hParent parameter.")
Return

btnShow2:
    TaskDialog(hGui, "TaskDialog() Examples|This is a Task Dialog with more text|The content goes here!||"
             . "The footer goes here!|The verification text goes here!")
Return

btnShow3:
    TaskDialog(hGui, "TaskDialog() Examples|This is a Task Dialog with all text fields filled in|The content goes here!|"
             . "Expanded information goes here! You can make it go under the footer instead with the TDF_EXPAND_FOOTER_AREA flag.|"
             . "And the footer goes here!|The verification text goes here!|"
             . "This is custom text for when collapsed.|This is custom text for when expanded.")
Return

btnShow4:
    TaskDialog(hGui, "TaskDialog() Examples|Hyperlinks can only appear in three places|"
             . "In the <a href=""example.com"">content</a>.|In the <a href=""example.com"">expanded information</a>.|"
             . "And in the <a href=""example.com"">footer</a>! Just remember to use the TDF_ENABLE_HYPERLINKS flag!`n`n"
             . "Notice that this Task Dialog starts up already expanded. This is done with the TDF_EXPANDED_BY_DEFAULT flag.", "", 0x81)
Return

btnShow5:
    TaskDialog(hGui, "TaskDialog() Examples|The Task Dialog doesn't open hyperlinks for you|"
             . "You have to do it yourself using a callback function.`nTry this <a href=""http://www.autohotkey.com"">link</a>!"
             , "", 0x1, "", "", "btnShow5Callback")
Return

btnShow5Callback(hwnd, uNotification, wParam, lParam, dwRefData) {
    
    ;You receive the TDN_HYPERLINK_CLICKED notification when a hyperlink is clicked
    If (uNotification = 3)
        ;lParam contains the address of the string
        Run, % StrGet(lParam)
}

btnShow6:
    TaskDialog(hGui, "TaskDialog() Examples|There are two places for icons|The first one is right beside this text. It is called the main icon.|"
             . "These are standard Task Dialog icons. There are a few other standard icons you can use!|"
             . "The second place for an icon is beside the footer (called the footer icon)!", "", 0, "INFO|GREEN")
Return

btnShow7:
    hModule := DllCall("LoadLibrary", "str", "C:\Windows\system32\shell32.dll")
    hIcon := DllCall("LoadImage", "uint", hModule, "uint", 10, "uint", 1, "uint", 16, "uint", 16, "uint", 0)
    r := TaskDialog(hGui, "TaskDialog() Examples|You can also use custom icons|Here, we're using AHK's own icon from AutoHotkey.exe for the main "
                  . "icon.||But this footer icon uses an icon handle loaded from shell32 in combination with TDF_USE_HICON_FOOTER."
                  , "", 0x4, "\159|" hIcon "|" A_AhkPath)
    DllCall("DestroyIcon", "uint", hIcon), DllCall("FreeLibrary", "uint", hModule)
Return

btnShow8:
    TaskDialog(hGui, "TaskDialog() Examples|There are 6 common buttons available|They are all in use in this Task Dialog. "
             . "Simply put their name in sButtons. The button No was made the default one by putting two pipes (i.e. ""\|"") after it.||"
             . "Note that as soon as Cancel is added, the Task Dialog can be closed by means of Alt-F4, Escape, or the close button. You can "
             . "have this functionality without adding the Cancel button by using the TDF_ALLOW_DIALOG_CANCELLATION flag."
             , "OK|YES|NO||CANCEL|RETRY|CLOSE")
Return

btnShow9:
    TaskDialog(hGui, "TaskDialog() Examples||You can also have custom-named buttons mixed with common buttons.", "No Way!!!|Really!?|CLOSE")
Return

btnShow10:
    TaskDialog(hGui, "TaskDialog() Examples||You can make custom buttons look like this by using the TDF_USE_COMMAND_LINKS flag. "
             . "You can optionally also include common buttons, but they will not appear as command links."
             , "This is a command link|This is another command link`nCommand links can hold multiple lines|CANCEL", 0x10)
Return

btnShow11:
    TaskDialog(hGui, "TaskDialog() Examples|You can add a shield to specific buttons|This is useful to indicate to the user that clicking on the "
             . "button will require elevation.`n`nTo add the shield, use the callback function to send a TDM_SET_BUTTON_ELEVATION_REQUIRED_STATE "
             . "message upon receiving the TDN_CREATED notification.||Here, the shield is added to both a custom and a common button!"
             , "Custom button with shield|Custom button without shield|CANCEL", 0, "", "", "btnShow11Callback")
Return

btnShow11Callback(hwnd, uNotification, wParam, lParam, dwRefData) {
    
    ;Check for TDN_CREATED
    If (uNotification = 0) {
        
        ;We need to turn on DetectHiddenWindows because the Task Dialog is still hidden
        DetectHiddenWindows, On
        
        ;Send a TDM_SET_BUTTON_ELEVATION_REQUIRED_STATE message
        SendMessage, 0x400 + 115, 1001, 1,, ahk_id %hwnd% ;First custom button (ID = 1000 + <Position Index>)
        SendMessage, 0x400 + 115,    2, 1,, ahk_id %hwnd% ;CANCEL button (ID = 2)
    }
}

btnShow12:
    TaskDialog(hGui, "TaskDialog() Examples|You can easily use the checkbox|The checkbox is automatically added as soon as you fill in the "
             . "verification text field!`n`nYou can have the checkbox start up as checked by using the TDF_VERIFICATION_FLAG_CHECKED flag, like "
             . "here!|||This is my verification text", "", 0x100)
Return

btnShow13:
    TaskDialog(hGui, "TaskDialog() Examples|You can add radio buttons!|Radio buttons work in much the same way as custom buttons work. Option 2 was "
             . "made the default one by putting two pipes (i.e. ""\|"") after it.`n`nYou can use the TDF_NO_DEFAULT_RADIO_BUTTON flag to have none "
             . "of them pre-selected.", "", 0, "", "This is option 1|This is option 2||And this is option 3")
Return

btnShow14:
    TaskDialog(hGui, "TaskDialog() Examples||You can use marquee progress bars with the TDF_SHOW_MARQUEE_PROGRESS_BAR flag.`n`n"
             . "You will also have to use the callback function to start the marquee display with the TDM_SET_PROGRESS_BAR_MARQUEE message on "
             . "receipt of the TDN_CREATED notification." , "", 0x400, "", "", "btnShow14Callback")
Return

btnShow14Callback(hwnd, uNotification, wParam, lParam, dwRefData) {
    
    ;Check for TDN_CREATED
    If (uNotification = 0) {
        
        ;We need to turn on DetectHiddenWindows because the Task Dialog is still hidden
        DetectHiddenWindows, On
        
        ;Send a TDM_SET_PROGRESS_BAR_MARQUEE message
        SendMessage, 0x400 + 107, True, 0,, ahk_id %hwnd%
    }
}

btnShow15:
    TaskDialog(hGui, "TaskDialog() Examples||This example mainly demonstrates two features:`n`n"
             . "    o  Updating Task Dialog text while it is shown using the TDM_UPDATE_ELEMENT_TEXT and TDM_UPDATE_ICON messages.`n`n"
             . "    o  Using buttons for other things than closing the Task Dialog by intercepting the TDN_BUTTON_CLICKED notification.||"
             . "Chick <a href=""Change Footer"">here</a> for a random number!"
             , "Change Icon|Change Footer|Close||", 0x9, "INFO", "", "btnShow15Callback")
Return

btnShow15Callback(hwnd, uNotification, wParam, lParam, dwRefData) {
    Static iCurrentIcon
    
    ;Check for TDN_CREATED
    If (uNotification = 0)
        iCurrentIcon := 0xFFFD ;TD_INFORMATION_ICON, which is the "INFO" name used in sIcon
        
    ;Check for TDN_BUTTON_CLICKED
    Else If (uNotification = 2) {
        
        ;Check for the button clicked
        If (wParam = 1001) { ;Change Icon
            
            ;Calculate the next icon
            If (iCurrentIcon = 0xFFFC)
                iCurrentIcon := 0xFFFF
            Else iCurrentIcon -= 1
            
            ;Change the icon using TDM_UPDATE_ICON
            SendMessage, 0x400 + 116, 0, iCurrentIcon,, ahk_id %hwnd%
            
            ;Returning True to the TDN_BUTTON_CLICKED notification prevents the task dialog from closing
            Return True
            
        } Else If (wParam = 1002) { ;Change Footer
            
            ;Translate new footer text to Unicode
            Random, i
            s := "<a href=""Change Footer"">" i "</a>"
            
            ;Update footer using a TDM_UPDATE_ELEMENT_TEXT message
            SendMessage, 0x400 + 114, 2, &s,, ahk_id %hwnd%
            
            ;Prevent Task Dialog from closing
            Return True
        }
        
    ;Check for TDN_HYPERLINK_CLICKED
    } Else If (uNotification = 3) {
        
        ;Retrieve the address clicked
        sLink := StrGet(lParam)
        
        ;Check for "Change Footer"
        If (sLink = "Change Footer")
            SendMessage, 0x400 + 102, 1002, 0,, ahk_id %hwnd% ;Simulate a button click using TDM_CLICK_BUTTON
    }
}

btnShow16:
    TaskDialog(hGui, "TaskDialog() Examples||Using the TDF_CALLBACK_TIMER flag, you can have the Task Dialog call your callback function every "
             . "200 ms with the TDN_TIMER notification. This can give you the chance to update things.||Time elapsed since last reset: 0.00 seconds"
             , "&Reset Timer", 0x808, "", "", "btnShow16Callback")
Return

btnShow16Callback(hwnd, uNotification, wParam, lParam, dwRefData) {
    Static bReset
    
    ;Check for TDN_TIMER
    If (uNotification = 4) {
        
        If bReset {
            bReset := False
            Return True ;Returning True to the TDN_TIMER notification causes the tickcount to reset
        }
        
        ;Translate time elapsed to UTF-16
        sElapsed := "Time elapsed since last reset: " Round(wParam / 1000, 2) " seconds"
        
        ;Send a TDM_UPDATE_ELEMENT_TEXT message
        SendMessage, 0x400 + 114, 2, &sElapsed,, ahk_id %hwnd%
        
    ;Check for TDN_BUTTON_CLICKED
    } Else If (uNotification = 2) {
        
        ;Check if it was the Reset button
        If (wParam = 1001) {
            
            ;Translate time elapsed to UTF-16
            sElapsed := "Time elapsed since last reset: 0.00 seconds"
            
            ;Send a TDM_UPDATE_ELEMENT_TEXT message
            SendMessage, 0x400 + 114, 2, &sElapsed,, ahk_id %hwnd%
            
            ;Set to True so that on the next TDN_TIMER notification, the tickcount will be reset
            bReset := True
            
            ;Prevent Task Dialog from closing
            Return True
        }
    }
}

btnShow17:
    TaskDialog(hGui, "TaskDialog() Examples|Normal progress bars require a bit more work than marquee progress bars|This is because you need to "
             . "continually update their position. You first need to use the TDF_SHOW_PROGRESS_BAR flag to display it. Updating its position is "
             . "done through the TDM_SET_PROGRESS_BAR_POS message.`n`nTo ease the updating process, you can also use the TDF_CALLBACK_TIMER flag."
             , "", 0xA00, "", "", "btnShow17Callback")
Return

btnShow17Callback(hwnd, uNotification, wParam, lParam, dwRefData) {
    Static iProgPos
    
    ;Check for TDN_CREATED
    If (uNotification = 0)
        iProgPos := 0
        
    ;Check for TDN_TIMER
    Else If (uNotification = 4) {
        
        ;We're not actually tracking the progress of something here.
        ;This is just a simple animation that will make the progress bar go up to 100% and then restart.
        
        ;Send a TDM_SET_PROGRESS_BAR_POS message
        SendMessage, 0x400 + 106, iProgPos, 0,, ahk_id %hwnd%
        
        iProgPos += 10
        
        If (iProgPos = 110)
            Return True ;Reset the tickcount
        
        ;Cause the progress bar to pause at 100% for one second
        If (iProgPos > 100) And (wParam > 1000)
            iProgPos := 0
    }
}


btnShow18:
    TaskDialog(hGui, "TaskDialog() Examples||You can change a progress bar's state using the TDM_SET_PROGRESS_BAR_STATE message."
             , "Normal State|Pause State|Error State|CANCEL||", 0xA00, "", "", "btnShow18Callback")
Return

btnShow18Callback(hwnd, uNotification, wParam, lParam, dwRefData) {
    Static iProgPos, iCurrentState, iNewState
    
    ;Check for TDN_CREATED
    If (uNotification = 0)
        iProgPos := 0, iCurrentState := 1, iNewState := 0 ;Reset values
        
    ;Check for TDN_BUTTON_CLICKED
    Else If (uNotification = 2) {
        
        ;Check if it was a custom button
        If (wParam < 1000)
            Return
        
        ;Check which button was pressed and prep the according progress bar state
        If (wParam = 1001) ;Normal
            iNewState := 1 ;PBST_NORMAL
        Else If (wParam = 1002) ;Pause
            iNewState := 3 ;PBST_PAUSED
        Else If (wParam = 1003) ;Error
            iNewState := 2 ;PBST_ERROR
        
        ;Prevent Task Dialog from closing
        Return True
        
    ;Check for TDN_TIMER
    } Else If (uNotification = 4) {
        
        If iNewState {  ;TDM_SET_PROGRESS_BAR_STATE message
            SendMessage, 0x400 + 104, iNewState, 0,, ahk_id %hwnd%
            iCurrentState := iNewState, iNewState := 0
        }
        
        ;Only animate if the state is PBST_NORMAL
        If (iCurrentState <> 1)
            Return
        
        ;We're not actually tracking the progress of something here.
        ;This is just a simple animation that will make the progress bar go up to 100% and then restart.
        
        ;TDM_SET_PROGRESS_BAR_POS
        SendMessage, 0x400 + 106, iProgPos, 0,, ahk_id %hwnd%
        
        iProgPos += 10
        
        If (iProgPos = 110)
            Return True ;Reset the tickcount
        
        ;Cause the progress bar to pause at 100% for one second
        If (iProgPos > 100) And (wParam > 1000)
            iProgPos := 0
    }
}

btnShow19:
    TaskDialog("btnShow19Callback")
Return

btnShow19Callback(hwnd, uNotification, wParam, lParam, dwRefData) {
    Static iCurrentPage
    Global hGui
    
    ;Check for TDN_CREATED
    If (uNotification = 0) {
        iCurrentPage := 1 ;We're at the first page
        Gosub, btnShow19_1 ;Go to the first page
        
    ;Check for TDN_BUTTON_CLICKED
    } Else If (uNotification = 2) {
        
        ;Make sure it's not Cancel
        If (wParam < 1000)
            Return
        
        ;Check if it's Next or Back
        If (iCurrentPage = 1) Or (iCurrentPage > 1 And wParam = 1002)
            iCurrentPage += 1 ;Next
        Else iCurrentPage -= 1 ;Back
        
        ;Update Task Dialog
        Gosub, btnShow19_%iCurrentPage%

        ;Prevent Task Dialog from closing
        Return True
        
    ;Check for TDN_HYPERLINK_CLICKED
    } Else If (uNotification = 3)
        Run, % StrGet(lParam)
    
    Return
    
    btnShow19_1:
        TaskDialog(hGui, "TaskDialog() Examples|You can use the hNavigate parameter to recreate a Task Dialog|This can allow you to simulate "
                  . "wizards with multiple pages. This functionality uses the <a href=""http://msdn.microsoft.com/en-us/library/bb787509"">"
                  . "TDM_NAVIGATE_PAGE</a> message. Try it here!", "Next >", 0x9, "INFO", "", "btnShow19Callback", 0, hwnd)
    Return
    
    btnShow19_2:
        TaskDialog(hGui, "TaskDialog() Examples|Using the hNavigate parameter to recreate a Task Dialog|This is the second page of this "
                       . "wizard. As you can see, it's a new layout with a new button, new icons, and new text!|||Checkbox text"
                       , "< Back|Next >", 0x8, "\159|INFO|" A_AhkPath, "", "btnShow19Callback", 0, hwnd)
    Return

    btnShow19_3:
        TaskDialog(hGui, "TaskDialog() Examples|Using the hNavigate parameter to recreate a Task Dialog|This is the third page of this "
                       . "wizard. Here, we added even more text, as well as changed the icons again! The possibilities are endless!||"
                       . "This is my footer|Checkbox text"
                       , "< Back|Next >", 0xC8, "\16|\15|C:\Windows\system32\shell32.dll", "", "btnShow19Callback", 0, hwnd)
    Return

    btnShow19_4:
        TaskDialog(hGui, "TaskDialog() Examples|Using the hNavigate parameter to recreate a Task Dialog|This is the fourth and last page of "
                       . "this wizard. No matter the number of pages, the return values of the first TaskDialog() call relate to the last page's "
                       . "state.", "< Back|CLOSE", 0x8, "INFO", "", "btnShow19Callback", 0, hwnd)
    Return
}

btnShow20:
    
    iButtonID := TaskDialog(hGui, "TaskDialog() Examples|You can easily read TaskDialog() return values.||||My checkbox"
                          , "Custom 1|Custom 2|Yes|No", 0, "INFO", "Option 1|Option 2|Option 3")
    
    ;Extract the radio button selected and the checkbox state
    iRadioID := ErrorLevel >> 16, bChecked := ErrorLevel & 0xFFFF
    
    ;Build a string
    s :=   "    o  Option selected: Option " iRadioID - 2000
    s .= "`n    o  Checkbox state: " (bChecked ? "Checked" : "Unchecked")
    s .= "`n    o  Button pressed: " (iButtonID > 1000 ? "Custom " iButtonID - 1000 : iButtonID = 6 ? "Yes" : "No")
    
    ;Show the return values
    TaskDialog(hGui, "TaskDialog() Examples|Return values|" s, "", 0, "INFO")
    
Return
