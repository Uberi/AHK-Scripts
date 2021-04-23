#NoEnv

SetBatchLines, -1
Process, Priority,, RealTime

;load Interception library
hModule := DllCall("LoadLibrary","Str","interception.dll","UPtr")
If !hModule
    throw Exception("Could not load Interception library.")

;create Interception context
pContext := DllCall("interception.dll\interception_create_context","UPtr")
If !pContext
    throw Exception("Could not obtain Interception context.")

;retrieve Interception filter handler
pFilterHandler := DllCall("GetProcAddress","UPtr",hModule,"AStr","interception_is_keyboard","UPtr")
If !pFilterHandler
    throw Exception("Could not obtain Interception filter handler.")

;set the Interception filter
DllCall("interception.dll\interception_set_filter","UPtr",pContext,"UPtr",pFilterHandler,"UShort",3) ;INTERCEPTION_FILTER_KEY_DOWN | INTERCEPTION_FILTER_KEY_UP

VarSetCapacity(Stroke,18) ;allocate memory for the InterceptionMouseStroke or InterceptionKeyStroke structure
Loop
{
    hDevice := DllCall("interception.dll\interception_wait","UPtr",pContext) ;wait for a device event
    If !hDevice
        throw Exception("Could not wait for Interception device event.")

    StrokeCount := DllCall("interception.dll\interception_receive","UPtr",pContext,"Int",hDevice,"UPtr",&Stroke,"UInt",1) ;receive a single event
    If !StrokeCount
        throw Exception("Could not receive Interception device event.")
}