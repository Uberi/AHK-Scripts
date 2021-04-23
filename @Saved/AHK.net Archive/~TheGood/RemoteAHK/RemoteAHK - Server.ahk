/*! TheGood
    RemoteAHK - Server
    http://www.autohotkey.com/forum/viewtopic.php?t=58797
    
    Usage: Run the script. You may specify a port number on which the server will listen by passing it as a parameter. If no
    port is specified, it defaults to 27015. To either reload or terminate the server, run a second instance of the script.
*/
    ;Needed if AHKsock and File isn't in one of your lib folders
    ;#Include %A_ScriptDir%\AHKsock.ahk
    ;#Include %A_ScriptDir%\File.ahk
    
    #NoTrayIcon
    #SingleInstance, Off
    
    ;Check if there is a previous instance running
    DetectHiddenWindows, On
    WinGet, hGui, ID, %A_ScriptName% ahk_class AutoHotkeyGUI
    If hGui {
        ;Notify the instance to show prompt
        PostMessage, 0x8001,,,, ahk_id %hGui%
        ExitApp
    }
    
    OnMessage(0x8001, "ShowPrompt")
    
    ;Register OnExit subroutine so that AHKsock_Close is called before exit
    OnExit, CloseAHKsock
    
    ;Set up an error handler (this is optional)
    AHKsock_ErrorHandler("AHKsockErrors")
    
    ;Check if a port was passed as a parameter
    iParamCount = %0%
    iPort := iParamCount ? %iParamCount% : 27015 ;Default port
    
    ;Set the temporary path of the scripts received
    sScriptPath := A_Temp "\RemoteAHKtmp.ahk"
    
    ;Set to -1 to indicate that there are no clients currently connected
    sktClient := -1
    
    ;Start listening
    If (i := AHKsock_Listen(iPort, "Clients")) {
        MsgBox, 0x10, AHKsock_Listen() failed, % "AHKsock_Listen() failed!`nReturn value = " i "`nErrorLevel = " ErrorLevel
        ExitApp
    }
Return

CloseAHKsock:
    AHKsock_Close()
    ExitApp
Return

ShowPrompt() {
    
    SetTimer, ChangeNames, 1
    MsgBox, 0x23, RemoteAHK - Server, What would you like to do?
    
    ;Check result
    IfMsgBox Yes
        Reload
    Else IfMsgBox No
        SetTimer, CloseAHKsock, -1
    
    Return
    
    ChangeNames:
        
        IfWinNotExist RemoteAHK - Server
            Return
        SetTimer, ChangeNames, Off
        ControlSetText, Button1, &Reload
        ControlSetText, Button2, &Terminate
        ControlSetText, Button3, &Cancel
        WinActivate
        
    Return
}

Clients(sEvent, iSocket = 0, sName = 0, sAddr = 0, sPort = 0, ByRef bNewData = 0, bNewDataLength = 0) {
    Static bPastData, bPastDataLength, cHeaderSize := 12
    Static hFile := -1, iFileSize, iParamLength
    Global sktClient, iRunMode, sParams, sScriptPath
    
    ;Check the event
    If (sEvent = "ACCEPTED") {
        OutputDebug, % "Server - A client has been accepted"
        
        ;Check if we're already serving another client
        If (sktClient <> -1)
            AHKsock_Close(iSocket)
        Else {
            
            ;We need to prepare to serve this client
            FileDelete, %A_Temp%\RemoteAHKtmp.ahk
            hFile := File_Open("Write", sScriptPath)
            If (hFile = -1) {
                MsgBox, 0x10, File_Open() Error, % "Could not open file for writing!`nErrorLevel = " ErrorLevel
                ExitApp
            }
            
            ;Remember our client's socket
            sktClient := iSocket
            iFileSize := 0 ;To indicate that we haven't received the header for this client yet
        }
        
    } Else If (sEvent = "DISCONNECTED") {
        OutputDebug, % "Server - A client has disconnected"
        
        ;Check if it's our client
        If (iSocket = sktClient)
            sktClient := -1 ;Reset the value
        
    } Else If (sEvent = "RECEIVED") {
        OutputDebug, % "Server - Received " bNewDataLength " bytes"
        
        ;Check if we have any data to prepend
        If bPastDataLength {
            
            bDataLength := bNewDataLength + bPastDataLength
            
            ;Prep the variable which will hold past and new data
            VarSetCapacity(bData, bDataLength, 0)
            
            ;Copy old data and then new data
            CopyBinData(&bPastData, &bData, bPastDataLength)
            CopyBinData(&bNewData, &bData + bPastDataLength, bNewDataLength)
            
            ;We can now delete the old data
            VarSetCapacity(bPastData, 0) ;Clear the variable to free some memory since it won't be used
            bPastDataLength := 0 ;Reset the value
            
            ;Set the data pointer to the new data we just created
            bDataPointer := &bData
            
        ;Set the data pointer to the newly arrived data
        } Else bDataPointer := &bNewData, bDataLength := bNewDataLength
        
        ;We now have all the data in bDataPointer
        
        ;Set the offset to 0
        iOffset := 0
        
        ;Let's first check if the header has already been fully received
        If Not iFileSize {
            
            ;Check if we received the whole header
            If (bDataLength - iOffset < cHeaderSize) {
                
                ;Save what we have and leave
                VarSetCapacity(bPastData, bDataLength - iOffset, 0)
                CopyBinData(bDataPointer + iOffset, &bPastData, bDataLength - iOffset)
                Return
            }
            
            ;Extract the header elements
            iFileSize    := NumGet(bDataPointer + iOffset + 0)
            iRunMode     := NumGet(bDataPointer + iOffset + 4)
            iParamLength := NumGet(bDataPointer + iOffset + 8)
            
            OutputDebug, % "Server - Script size is " iFileSize " bytes!"
            
            ;Move up the offset
            iOffset += cHeaderSize
        }
        
        ;Check if we still need to extract the parameters
        If iParamLength {
            
            ;Check if we received the whole param string
            If (bDataLength - iOffset < iParamLength) {
                
                ;Save what we have and leave
                VarSetCapacity(bPastData, bDataLength - iOffset, 0)
                CopyBinData(bDataPointer + iOffset, &bPastData, bDataLength - iOffset)
                Return
            }
            
            ;Extract the parameters string
            sParams := DllCall("MulDiv", "int", bDataPointer + iOffset, "int", 1, "int", 1, "str")
            
            ;Move up the offset
            iOffset += iParamLength
            
            ;Set the static var to 0 to indicate that we extracted the parameters
            iParamLength := 0
        }
        
        ;Check if there's anything to write to the file
        If (bDataLength - iOffset > 0)
            File_Write(hFile, bDataPointer + iOffset, bDataLength - iOffset)
        
        ;Get the current file pointer (i.e. the number of bytes written to file so far)
        iPointer := File_Pointer(hFile)
        If (iPointer >= iFileSize) { ;Check if we have received the whole file
            
            ;Close the file
            File_Close(hFile), hFile := -1
            
            ;We can execute the script!
            SetTimer, RunAHKScript, -1
        }
    }
}

RunAHKScript:
    
    ;Prepare script parameters
    StringReplace, sParams, sParams, `n, %A_Space%, All
    
    ;Check if we're doing Run or RunWait
    If (iRunMode = 0x0)
        Run, "%A_AhkPath%" "%sScriptPath%" %sParams%
    Else If (iRunMode = 0x1) {
        RunWait, "%A_AhkPath%" "%sScriptPath%" %sParams%
        VarSetCapacity(iExitCode, 4, 0), NumPut(ErrorLevel, iExitCode, "int")
        AHKsock_ForceSend(sktClient, &iExitCode, 4)
    }
    
    ;We can now close the client connection
    AHKsock_Close(sktClient)
    
Return

AHKsockErrors(iError, iSocket) {
    OutputDebug, % "Client - Error " iError " with error code = " ErrorLevel ((iSocket <> -1) ? " on socket " iSocket : "") 
}

CopyBinData(ptrSource, ptrDestination, iLength) {
    If iLength ;Only do it if there's anything to copy
        DllCall("RtlMoveMemory", "uint", ptrDestination, "uint", ptrSource, "uint", iLength)
}
