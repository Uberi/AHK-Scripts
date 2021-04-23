#Persistent
#NoEnv
; Set callback functions.
DBGP_OnBegin("TDebuggerConnected")
DBGP_OnBreak("TDebuggerBreak")
DBGP_OnEnd("TDebuggerDisconnected")
; Start listening for connections.
DBGP_StartListening()
return

TDebuggerConnected(session)
{
    ; Output session information.
    StdOut("--CONNECTED")
    StdOut(DBGP_GetSessionIDEKey(session), "ide_key")
    StdOut(DBGP_GetSessionCookie(session), "session")
    StdOut(DBGP_GetSessionThread(session), "thread")
    StdOut(DBGP_GetSessionFile(session), "fileuri")
    
    ; Set a breakpoint
    DBGP(session, "breakpoint_set", "-t line -n 1", response)
    ; Run. After a continuation command is invoked via DBGP(), the script will be notified
    ; when a response is received. DBGP functions should not be used on this session until then.
    DBGP(session, "run")
    
    ; The following is essentially equivalent:
    ;DBGP(session, "step_into")
    
    ; Note that the following is NOT equivalent, as it "steps over" the auto-execute thread:
    ;DBGP(session, "step_over")
}

TDebuggerBreak(session, ByRef response)
{
    ; Requires xpath: http://www.autohotkey.com/forum/topic17549.html
    ; Any XML library (or even InStr/RegExMatch) may be used in its stead.
    xpath_load(response)
    status := xpath(response, "/response/@status/text()")
    reason := xpath(response, "/response/@reason/text()")
    StdOut("--status: " status ", reason: " reason)
    if status = break
    {
        ; Get the current context; i.e. file and line.
        DBGP(session, "stack_get", "-d 0", current_context)
        xpath_load(current_context)
        ; Display the stack element as is.
        StdOut(xpath(current_context, "/response/stack"))
        ; Run until the next line is reached at the same or shallower stack depth.
        ; Again, do not use any DBGP functions until TDebuggerBreak is called again.
        DBGP(session, "step_over")
    }
}

TDebuggerDisconnected(session)
{
    StdOut("--DISCONNECTED")
}

StdOut(text, tag="")
{
    if tag !=
        text = %tag%: %text%
    FileAppend, %text%`n, *
}