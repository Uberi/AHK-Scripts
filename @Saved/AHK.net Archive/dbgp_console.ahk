#Persistent
#NoTrayIcon
; DebugBIF()
; Do not run this script from SciTE, or any other editor that redirects console output.
DllCall("AllocConsole")
; Get probable process name:
if A_IsCompiled
    A_ExeName := A_ScriptName
else
    SplitPath, A_AhkPath, A_ExeName
; Set up aliases:
alias=
(
r=run
in=step_into
ov=step_over
ou=step_out
fg=feature_get
fs=feature_set
bs=breakpoint_set
bg=breakpoint_get
br=breakpoint_remove
bl=breakpoint_list
sd=stack_depth
sg=stack_get
cn=context_names
cg=context_get
tg=typemap_get
pg=property_get
ps=property_set
pv=property_value
)
Loop, Parse, alias, `n
{
    StringSplit, alias, A_LoopField, =
    DllCall("AddConsoleAlias", "str", alias1, "str", alias2 " $*", "str", A_ExeName)
}
; Set up error code -> text map.
ErrorMap := Object(0,"OK"
    , 1,"Parse error"
    , 3,"Invalid options"
    , 4,"Unimplemented command"
    , 100,"Can not open file"
    , 201,"Breakpoint type not supported"
    , 202,"Breakpoint invalid"
    , 203,"No code on breakpoint line"
    , 204,"Invalid breakpoint state"
    , 205,"No such breakpoint"
    , 300,"Unknown property"
    , 301,"Invalid stack depth"
    , 302,"Invalid context")

; Open console output buffer:
Console := FileOpen("CONOUT$", "rw")

; Set event callback.
DBGP_OnBegin("DebuggerConnected")
Listen:
Console.WriteLine("*** Listening on port 9000 for a debugger connection.")
ListenSocket := DBGP_StartListening()
return

DebuggerConnected(new_session)
{
    global
    ; We can handle only one at a time, so stop listening for now.
    DBGP_StopListening(ListenSocket)
    ListenSocket := 0
    ; Start the interactive loop in a new thread.
    session := new_session
    SetTimer, Debug, -1
}

Debug:
Console.WriteLine("*** "
    . "Debugging " DBGP_GetSessionFile(session) "`n"      ; path of main script file
    . "ide_key: " DBGP_GetSessionIDEKey(session) "`n"     ; DBGP_IDEKEY env var
    . "session: " DBGP_GetSessionCookie(session) "`n"     ; DBGP_COOKIE env var
    . "thread id: " DBGP_GetSessionThread(session) "`n")  ; thread id of script
Loop
{
    ; Display prompt.
    Console.Write("> ")
    ; Wait for one line of input.
    FileReadLine, line, CONIN$, 1
    ; Support var=value
    if RegExMatch(line, "^(.+?)\s*=\s*(.*)$", m)
        line := "property_set -n " m1 " -- " DBGp_Base64UTF8Encode(m2)
    ; Support ?var
    else if SubStr(line,1,1)="?"
        line := "property_value -n " RegExReplace(line,"^\?\s*")
    ; Split the command and args.
    if delim := InStr(line," ")
        command := SubStr(line,1,delim-1), args := SubStr(line,delim+1)
    else
        command := line, args := ""
    ; Custom client-side commands: decode base64 data.
    if command = d64
    {
        Console.Write(DBGP_Base64Decode(args) "`n`n")
        continue
    }
    if command = d
    {
        Console.Write(DBGp_Base64UTF8Decode(args) "`n`n")
        continue
    }
    ; Send command to server.
    if DBGP_Send(session, command, args) != 0
    {
        gosub display_error
        break
    }
    Loop ; Loop to handle non-response packets.
    {
        ; Wait for response.
        if DBGP_Receive(session, response) != 0
        {
            gosub display_error
            continue 2
        }
        if InStr(response, "<response")
        {
            if stream !=
            {
                SetConsoleTextAttribute(15)
                stream =
            }
            break
        }
        ; else not a response packet, so output it and repeat.
        TidyPacket(response)
        if RegExMatch(response, "^<stream type=""(.*?)"">\K.*(?=</stream>)", stream)
        {
            SetConsoleTextAttribute(stream1="stdout" ? 7 : 14)
            response := RegExReplace(DBGp_Base64UTF8Decode(stream),"`n$")
        }
        Console.WriteLine(response)
    }
    ; Improve output formatting a little.
    TidyPacket(response)
    ; Display response with base64-encoded data converted back to text:
    b := 1
    p := 1
    while p := RegExMatch(response, "encoding=""base64""[^>]*?>\s*\K[^<]+?(?=\s*<)", base64, p)
    {
        Console.Write(SubStr(response, b, p-b))
        SetConsoleTextAttribute(9)
        Console.Write(DBGp_Base64UTF8Decode(base64))
        SetConsoleTextAttribute(15)
        b := p + StrLen(base64)
    }
    Console.Write(SubStr(response, b) "`n`n")
    ; If script has stopped, listen for the next connection.
    if InStr(response,"status=""stopped""")
        break
}
FileAppend, *** Stopped debugging.`n, CONOUT$
gosub Listen
return

display_error:
el := ErrorMap.HasKey(ErrorLevel) ? ErrorMap[ErrorLevel] : ErrorLevel
SetConsoleTextAttribute(12)
Console.Write("Error: " el "`n`n")
SetConsoleTextAttribute(15)
return

TidyPacket(ByRef xml) {
    xml := RegExReplace(xml, "^<\?.*?\?>")
    i := 1
    while i := RegExMatch(xml, "s)(.*?)(<[^>]*>)", s, i)
    {
        if (s1 != "" && out != "")
            out .= "`n" . indent
        out .= s1 . "`n"
        if is_end_tag := SubStr(s2,2,1)="/"
            indent := SubStr(indent, 3)
        out .= indent
        if StrLen(indent . s2) > 100 && RegExMatch(s2, "^<\w+ ", n)
            s2 := RegExReplace(s2, "\S+?=""[^""]*""\K\s(?!\s*>)"
                    , "`n" . indent . RegExReplace(n, "s).", " "))
        out .= s2
        if !is_end_tag && SubStr(s,-1,1) != "/"
            indent .= "  "
        i += StrLen(s)
    }
    xml := out
}

SetConsoleTextAttribute(attrib) {
    global Console
    return DllCall("SetConsoleTextAttribute", "ptr", Console.__Handle, "short", attrib)
}