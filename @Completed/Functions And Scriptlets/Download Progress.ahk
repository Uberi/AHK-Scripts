#Persistent

URL  := "http://ipv4.download.thinkbroadband.com/512MB.zip"

WebRequest := ComObjCreate("WinHttp.WinHttpRequest.5.1")

Events := [3 ;QueryInterface
          ,1 ;AddRef
          ,1 ;Release
          ,3 ;OnResponseStart
          ,2 ;OnResponseDataAvailable
          ,1 ;OnResponseFinished
          ,3] ;OnError
VarSetCapacity(CallbackTable,A_PtrSize * Events.MaxIndex())
Offset := 0
For Index, ParameterCount In Events
{
    NumPut(RegisterCallback("EventHandler","Fast",ParameterCount,Index),CallbackTable,Offset)
    Offset += A_PtrSize
}
pConnection := FindConnectionPoint(pWebRequest,"{F97F4E15-B787-4212-80D1-D380CBBF982E}") ;IWinHttpRequestEvents
pSink := DllCall("ole32\CoTaskMemAlloc","UPtr",A_PtrSize * 4)
pWebRequest := ComObjUnwrap(WebRequest)
NumPut(pWebRequest,NumPut(&CallbackTable,pSink + 0))
NumPut(Advise(pConnection,pSink),NumPut(pConnection,pSink + 8))

WebRequest.Open("GET",URL)
WebRequest.Send()
WebRequest := ""

EventHandler(pSelf,Status = "",pType = "")
{
    ExitApp
    If A_EventInfo = 1
        NumPut(pSelf,pType + 0)
    Return 0
}

; COM_L functions by Sean :: http://www.autohotkey.com/forum/viewtopic.php?t=22923
FindConnectionPoint(pdp, DIID) {
    DllCall(NumGet(NumGet(1*pdp)+ 0), "Uint", pdp, "Uint", GUID4String(IID_IConnectionPointContainer, "{B196B284-BAB4-101A-B69C-00AA00341D07}"), "UintP", pcc)
    DllCall(NumGet(NumGet(1*pcc)+16), "Uint", pcc, "Uint", GUID4String(DIID,DIID), "UintP", pcp)
    DllCall(NumGet(NumGet(1*pcc)+ 8), "Uint", pcc)
    Return pcp
}

GUID4String(ByRef CLSID, String) {
    VarSetCapacity(CLSID,16,0)
    DllCall("ole32\CLSIDFromString", "Uint", &String, "Uint", &CLSID)
    Return &CLSID
}

Advise(pcp, psink) {
    DllCall(NumGet(NumGet(1*pcp)+20), "Uint", pcp, "Uint", psink, "UintP", nCookie)
    Return nCookie
}

Unadvise(pcp, nCookie) {
    Return DllCall(NumGet(NumGet(1*pcp)+24), "Uint", pcp, "Uint", nCookie)
}