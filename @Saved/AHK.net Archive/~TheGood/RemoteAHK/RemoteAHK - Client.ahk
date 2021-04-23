/*! TheGood
    RemoteAHK - Client
    http://www.autohotkey.com/forum/viewtopic.php?t=58797
    
    Usage: Run the script. The parameter syntax is:
    (Mandatory parameters are in <>. Optional parameters are in [])
    
    <Server Address[:Port]> <Path to script[?]> [Parameter 1] [Parameter 2] ...
    
    If no port is specified, it defaults to 27015. The ? symbol can be added to the end of the path of the script to ask the
    Server to wait for the script to finish and to return the exit code. The client will then exit with the same exit code.
    The parameters following the script's path will be passed to the script as parameters upon execution.
*/
    ;Needed if AHKsock and File isn't in one of your lib folders
    ;#Include %A_ScriptDir%\AHKsock.ahk
    ;#Include %A_ScriptDir%\File.ahk
    
    #NoTrayIcon
    #SingleInstance, Off
    
    ;Extract the command-line parameters
    iParamCount = %0%
    
    If (iParamCount < 2) {
        MsgBox, 0x10, Invalid parameters!, % "Parameters syntax:`n<Server Address[:Port]> <Path to script[?]> <Parameter 1> <Parameter 2> ...`n`nRemoteAHK - Client will now exit..."
        ExitApp
    }
    
    ;Extract elements
    sServer = %1%
    sScriptPath = %2%
    If (iParamCount > 2) {
        iScriptParamCount := iParamCount - 2
        Loop % iScriptParamCount
            i := A_Index + 2, sParams .= (j := InStr(%i%, A_Space) ? """" : "") %i% (j ? """" : "") (A_Index = iScriptParamCount ? "" : "`n")
    }
    
    ;Check if we're gonna ask for Run or RunWait
    If (SubStr(sScriptPath, 0) = "?") {
        bRunWait := True
        StringTrimRight, sScriptPath, sScriptPath, 1
    } Else bRunWait := False
    
    ;Make sure the file exists
    If Not FileExist(sScriptPath) {
        MsgBox, 0x10, File not found!, % "The file " %A_Index% " cannot be found!`n`nRemoteAHK - Client will now exit..."
        ExitApp
    }
    
    ;Split address and port
    If Not (i := InStr(sServer, ":"))
        sServerAddr := sServer, iPort := 27015 ;Default port
    Else sServerAddr := SubStr(sServer, 1, i - 1), iPort := SubStr(sServer, i + 1)
    
    ;Set up an error handler (this is optional)
    AHKsock_ErrorHandler("AHKsockErrors")
    
    ;Try to connect to the server
    If (i := AHKsock_Connect(sServerAddr, iPort, "Server")) {
        MsgBox, 0x10, AHKsock_Connect() failed, % "AHKsock_Connect() failed!`nReturn value = " i "`nErrorLevel = " ErrorLevel
        ExitApp
    }
Return

Server(sEvent, iSocket = 0, sName = 0, sAddr = 0, sPort = 0, ByRef bNewData = 0, bNewDataLength = 0) {
    Static bPastData, bPastDataLength, iExitCode := 0
    Global sktServer, bRunWait, bSentCommands
    
    If (sEvent = "CONNECTED") {
        
        ;Check for success
        If (iSocket <> -1)
            sktServer := iSocket
        Else {
            MsgBox, 0x10, AHKsock_Connect() failed, % "AHKsock_Connect() failed!`nCheck OutputDebug's log for reason."
            ExitApp
        }
        
        ;We can start sending data to the client
        SetTimer, SendCommand, -1
        
    } Else If (sEvent = "DISCONNECTED") {
        
        ;Check if we weren't able to process
        If Not bSentCommands
            MsgBox, 0x10, Command send failure, % "Could not send the command.`nThe server is most likely pending on a previous command.`nPlease try again later..."
        Else OutputDebug, % "Client - ExitCode = " iExitCode ;We can leave
        ExitApp, iExitCode
        
    } Else If (sEvent = "RECEIVED") And bRunWait {
        
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
        
        ;Check if we have the 4 byte exit code
        If (bDataLength < 4) {
            
            ;Save what we have and leave
            VarSetCapacity(bPastData, bDataLength, 0)
            CopyBinData(bDataPointer + iOffset, &bPastData, bDataLength)
            Return
        }
        
        ;We're done
        iExitCode := NumGet(bDataPointer + 0, 0, "int")
    }
}

SendCommand:
    
    ;Prep the header
    VarSetCapacity(bHeader, 12, 0)
    FileGetSize, iFileSize, %sScriptPath%
    NumPut(iFileSize, bHeader, 0)
    NumPut(bRunWait, bHeader, 4)
    NumPut((i := StrLen(sParams)) ? (i += 1) : 0, bHeader, 8)
    
    FileRead, bFile, %sScriptPath%
    
    ;Send the header, the params, and the file
    AHKsock_ForceSend(sktServer, &bHeader, 12)
    AHKsock_ForceSend(sktServer, &sParams, i)
    AHKsock_ForceSend(sktServer, &bFile, iFileSize)
    bSentCommands := True
    
Return

AHKsockErrors(iError, iSocket) {
    OutputDebug, % "Client - Error " iError " with error code = " ErrorLevel ((iSocket <> -1) ? " on socket " iSocket : "") 
}

CopyBinData(ptrSource, ptrDestination, iLength) {
    If iLength ;Only do it if there's anything to copy
        DllCall("RtlMoveMemory", "uint", ptrDestination, "uint", ptrSource, "uint", iLength)
}
