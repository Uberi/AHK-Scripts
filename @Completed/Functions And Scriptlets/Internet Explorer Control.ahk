#NoEnv

;/*
COM_AtlAxWinInit()
COM_CoInitialize()
Gui, +LastFound +Resize -Border
Gui, Show, w500 h500 Center, WebBrowser
hWnd := WinExist()
CLSID_WebBrowser := "{8856F961-340A-11D0-A96B-00C04FD705A2}"
IID_IWebBrowser2 := "{D30C1661-CDAF-11D0-8A3E-00C04FC9E26E}"
pwb := COM_CreateObject(CLSID_WebBrowser, IID_IWebBrowser2)
COM_AtlAxAttachControl(pwb, hWnd)
WinMove,,, 0, 0, A_ScreenWidth, A_ScreenHeight
Gui, -Resize +AlwaysOnTop
IE_LoadURL(pwb, "http://www.youtube.com/watch?v=oHg5SJYRHA0")
Return

Esc::
GuiClose:
Gui, Destroy
COM_Release(pwb)
COM_CoUninitialize()
COM_AtlAxWinTerm()
ExitApp
;*/

IE_Add(hWnd, x, y, w, h)
{
 COM_AtlAxWinInit()
}

IE_Move(pwb, x, y, w, h)
{
 WinMove, % "ahk_id " . GetHostWindow(pwb), , x, y, w, h
}

IE_LoadURL(pwb, u)
{
 pUrl := COM_SysAllocString(u)
 VarSetCapacity(var, 8 * 2, 0)
 DllCall(COM_VTable(pwb, 11), "Uint", pwb, "Uint", pUrl, "Uint", &var, "Uint", &var, "Uint", &var, "Uint", &var)
 COM_SysFreeString(pUrl)
}

IE_LoadHTML(pwb, h)
{
 pUrl := COM_SysAllocString("about:" . h)
 VarSetCapacity(var, 8 * 2, 0)
 DllCall(COM_VTable(pwb, 11), "Uint", pwb, "Uint", pUrl, "Uint", &var, "Uint", &var, "Uint", &var, "Uint", &var)
 COM_SysFreeString(pUrl)
}

IE_GoBack(pwb)
{
 DllCall(COM_VTable(pwb, 7), "Uint", pwb)
}

IE_GoForward(pwb)
{
 DllCall(COM_VTable(pwb, 8), "Uint", pwb)
}

IE_GoHome(pwb)
{
 DllCall(COM_VTable(pwb, 9), "Uint", pwb)
}

IE_GoSearch(pwb)
{
 DllCall(COM_VTable(pwb, 10), "Uint", pwb)
}

IE_Refresh(pwb)
{
 DllCall(COM_VTable(pwb, 12), "Uint", pwb)
}

IE_Stop(pwb)
{
 DllCall(COM_VTable(pwb, 14), "Uint", pwb)
}

IE_Document(pwb)
{
 DllCall(COM_VTable(pwb, 18), "Uint", pwb, "UintP", pdoc)
 Return, pdoc
}

IE_GetTitle(pwb)
{
 DllCall(COM_VTable(pwb, 29), "Uint", pwb, "UintP", pTitle)
 COM_Unicode2Ansi(pTitle, sTitle)
 COM_SysFreeString(pTitle)
 Return, sTitle
}

IE_GetUrl(pwb)
{
 DllCall(COM_VTable(pwb, 30), "Uint", pwb, "UintP", pUrl)
 COM_Unicode2Ansi(pUrl, sUrl)
 COM_SysFreeString(pUrl)
 Return, sUrl
}

IE_Busy(pwb)
{
 DllCall(COM_VTable(pwb, 31), "Uint", pwb, "shortP", bBusy)
 Return, -bBusy
}

IE_Quit(pwb)            ; iexplore.exe only
{
 DllCall(COM_VTable(pwb, 32), "Uint", pwb)
}

IE_hWnd(pwb)            ; iexplore.exe only
{
 DllCall(COM_VTable(pwb, 37), "Uint", pwb, "UintP", hIE)
 Return, hIE
}

IE_FullName(pwb)         ; iexplore.exe only
{
 DllCall(COM_VTable(pwb, 38), "Uint", pwb, "UintP", pFile)
 COM_Unicode2Ansi(pFile, sFile)
 COM_SysFreeString(pFile)
 Return, sFile
}

IE_GetStatusText(pwb)         ; iexplore.exe only
{
 DllCall(COM_VTable(pwb, 44), "Uint", pwb, "UintP", pText)
 COM_Unicode2Ansi(pText, sText)
 COM_SysFreeString(pText)
 Return, sText
}

IE_SetStatusText(pwb, sText = "")   ; iexplore.exe only
{
 pText := COM_SysAllocString(sText)
 DllCall(COM_VTable(pwb, 45), "Uint", pwb, "Uint", pText)
 COM_SysFreeString(pText)
}

IE_ReadyState(pwb)
{
 /*
 READYSTATE_UNINITIALIZED = 0      ; Default initialization state.
 READYSTATE_LOADING       = 1      ; Object is currently loading its properties.
 READYSTATE_LOADED        = 2      ; Object has been initialized.
 READYSTATE_INTERACTIVE   = 3      ; Object is interactive, but not all of its data is available.
 READYSTATE_COMPLETE      = 4      ; Object has received all of its data.
 */
 DllCall(COM_VTable(pwb, 56), "Uint", pwb, "intP", nReady)
 Return, nReady
}

IE_Open(pwb)
{
 DllCall(COM_VTable(pwb, 54), "Uint", pwb, "Uint", 1, "Uint", 0, "Uint", 0, "Uint", 0)
}

IE_New(pwb)
{
 DllCall(COM_VTable(pwb, 54), "Uint", pwb, "Uint", 2, "Uint", 0, "Uint", 0, "Uint", 0)
}

IE_Save(pwb)
{
 DllCall(COM_VTable(pwb, 54), "Uint", pwb, "Uint", 3, "Uint", 0, "Uint", 0, "Uint", 0)
}

IE_SaveAs(pwb)
{
 DllCall(COM_VTable(pwb, 54), "Uint", pwb, "Uint", 4, "Uint", 0, "Uint", 0, "Uint", 0)
}

IE_Print(pwb)
{
 DllCall(COM_VTable(pwb, 54), "Uint", pwb, "Uint", 6, "Uint", 0, "Uint", 0, "Uint", 0)
}

IE_PrintPreview(pwb)
{
 DllCall(COM_VTable(pwb, 54), "Uint", pwb, "Uint", 7, "Uint", 0, "Uint", 0, "Uint", 0)
}

IE_PageSetup(pwb)
{
 DllCall(COM_VTable(pwb, 54), "Uint", pwb, "Uint", 8, "Uint", 0, "Uint", 0, "Uint", 0)
}

IE_Properties(pwb)
{
 DllCall(COM_VTable(pwb, 54), "Uint", pwb, "Uint", 10, "Uint", 0, "Uint", 0, "Uint", 0)
}

IE_Cut(pwb)
{
 DllCall(COM_VTable(pwb, 54), "Uint", pwb, "Uint", 11, "Uint", 0, "Uint", 0, "Uint", 0)
}

IE_Copy(pwb)
{
 DllCall(COM_VTable(pwb, 54), "Uint", pwb, "Uint", 12, "Uint", 0, "Uint", 0, "Uint", 0)
}

IE_Paste(pwb)
{
 DllCall(COM_VTable(pwb, 54), "Uint", pwb, "Uint", 13, "Uint", 0, "Uint", 0, "Uint", 0)
}

IE_SelectAll(pwb)
{
 DllCall(COM_VTable(pwb, 54), "Uint", pwb, "Uint", 17, "Uint", 0, "Uint", 0, "Uint", 0)
}

IE_Find(pwb)
{
 DllCall(COM_VTable(pwb, 54), "Uint", pwb, "Uint", 32, "Uint", 0, "Uint", 0, "Uint", 0)
}

IE_DoFontSize(pwb, s)
{
 /*
 s = 4   ; Largest
 s = 3   ; Larger
 s = 2   ; Medium
 s = 1   ; Smaller
 s = 0   ; Smallest
 */
 VarSetCapacity(var, 8 * 2)
 EncodeInteger(&var + 0, 3)
 EncodeInteger(&var + 8, s)
 DllCall(COM_VTable(pwb, 54), "Uint", pwb, "Uint", 19, "Uint", 2, "Uint", &var, "Uint", &var)
}

IE_InternetOptions(pwb)
{
 CGID_MSHTML(pwb, 2135)
}

IE_ViewSource(pwb)
{
 CGID_MSHTML(pwb, 2139)
}

IE_AddToFavorites(pwb)
{
 CGID_MSHTML(pwb, 2261)
}

IE_MakeDesktopShortcut(pwb)
{
 CGID_MSHTML(pwb, 2266)
}

IE_SendEMail(pwb)
{
 CGID_MSHTML(pwb, 2288)
}

CGID_MSHTML(pwb, nCmd, nOpt = 0)
{
 COM_GUID4String(CGID_MSHTML          , "{DE4BA900-59CA-11CF-9592-444553540000}")
 COM_GUID4String(IID_IOleCommandTarget, "{B722BCCB-4E68-101B-A2BC-00AA00404770}")
 pct := COM_QueryInterface(pwb, IID_IOleCommandTarget)
 DllCall(COM_VTable(pct, 4), "Uint", pct, "str", CGID_MSHTML, "Uint", nCmd, "Uint", nOpt, "Uint", 0, "Uint", 0)
 COM_Release(pct)
}

GetHostWindow(pwb)
{
 COM_GUID4String(IID_IOleWindow, "{00000114-0000-0000-C000-000000000046}")
 DllCall(COM_VTable(pwb, 0), "Uint", pwb, "str", IID_IOleWindow, "UintP", pow)
 DllCall(COM_VTable(pow, 3), "Uint", pow, "UintP", hWnd)
 DllCall(COM_VTable(pow, 2), "Uint", pow)
 Return, DllCall("GetParent", "Uint", hWnd)
}

GetWebControl()
{
 ;ControlGet, hIESvr, hWnd, , Internet Explorer_Server1, A
 MouseGetPos,,,, hIESvr, 2

 COM_GUID4String(IID_IHTMLDocument2, "{332C4425-26CB-11D0-B483-00C04FD90119}")
 COM_GUID4String(IID_IWebBrowser2  , "{D30C1661-CDAF-11D0-8A3E-00C04FC9E26E}")
 COM_GUID4String(SID_SWebBrowserApp, "{0002DF05-0000-0000-C000-000000000046}")
 DllCall("SendMessageTimeout", "Uint", hIESvr
  , "Uint", DllCall("RegisterWindowMessage", "str", "WM_HTML_GETOBJECT")
  , "int", 0, "int", 0, "Uint", 2, "Uint", 1000, "UintP", lResult)
 DllCall("oleacc\ObjectFromLresult", "Uint", lResult, "str", IID_IHTMLDocument2, "int", 0, "UintP", phd)
 pwb := COM_QueryService(phd, SID_SWebBrowserApp, IID_IWebBrowser2)
 COM_Release(phd)
 Return,  pwb
}

UrlHistoryEnum()
{
 COM_GUID4String( CLSID_CUrlHistory, "{3C374A40-BAE4-11CF-BF7D-00AA006946EE}")
 COM_GUID4String(IID_IUrlHistoryStg, "{3C374A41-BAE4-11CF-BF7D-00AA006946EE}")
 puh := COM_CreateObject(CLSID_CUrlHistory, IID_IUrlHistoryStg)
 DllCall(COM_VTable(puh, 7), "Uint", puh, "UintP", peu)
 VarSetCapacity(var, 40)
 EncodeInteger(&var, VarSetCapacity(var))

 Loop
 {
  If DllCall(COM_VTable(peu, 3), "Uint", peu, "Uint", 1, "Uint", &var, "Uint", 0)
   Break
  pUrl := DecodeInteger(&var + 4)
  pTitle := DecodeInteger(&var + 8)
  COM_Unicode2Ansi(pUrl, sUrl)
  COM_Unicode2Ansi(pTitle, sTitle)
  sHistory .= sUrl . "|" . sTitle . "`n"
  COM_SysFreeString(pUrl)
  COM_SysFreeString(pTitle)
 }

 DllCall(COM_VTable(peu, 2), "Uint", peu)
 DllCall(COM_VTable(puh, 2), "Uint", puh)
 Return, sHistory
}

UrlHistoryClear()
{
 COM_GUID4String( CLSID_CUrlHistory, "{3C374A40-BAE4-11CF-BF7D-00AA006946EE}")
 COM_GUID4String(IID_IUrlHistoryStg, "{3C374A41-BAE4-11CF-BF7D-00AA006946EE}")
 puh := COM_CreateObject(CLSID_CUrlHistory, IID_IUrlHistoryStg)
 DllCall(COM_VTable(puh, 9), "Uint", puh)
 DllCall(COM_VTable(puh, 2), "Uint", puh)
}

DecodeInteger(ptr) 
{ 
 Return, *ptr | *++ptr << 8 | *++ptr << 16 | *++ptr << 24 
} 

EncodeInteger(ref, val) 
{ 
 DllCall("ntdll\RtlFillMemoryUlong", "Uint", ref, "Uint", 4, "Uint", val) 
}

COM_AtlAxWinInit(Version = "")
{
 COM_Init()
 If Not DllCall("GetModuleHandle", "str", "atl" . Version)
  DllCall("LoadLibrary", "str", "atl" . Version)
 Return, DllCall("atl" . Version . "\AtlAxWinInit")
}

COM_CoInitialize()
{
 Return, DllCall("ole32\CoInitialize", "Uint", 0)
}

COM_CreateObject(CLSID, IID = "", CLSCTX = 5)
{
 DllCall("ole32\CoCreateInstance", "Uint", SubStr(CLSID,1,1)="{" ? COM_GUID4String(CLSID,CLSID) : COM_CLSID4ProgID(CLSID,CLSID), "Uint", 0, "Uint", CLSCTX, "Uint", COM_GUID4String(IID,IID ? IID : IID=0 ? "{00000000-0000-0000-C000-000000000046}" : "{00020400-0000-0000-C000-000000000046}"), "UintP", ppv)
 Return, ppv
}

COM_AtlAxAttachControl(pdsp, hWnd, Version = "")
{
 Return, DllCall("atl" . Version . "\AtlAxAttachControl", "Uint", punk:=COM_QueryInterface(pdsp,0), "Uint", hWnd, "Uint", 0), COM_Release(punk)
}

COM_Release(ppv)
{
 Return, DllCall(NumGet(NumGet(1*ppv)+8), "Uint", ppv)
}

COM_CoUninitialize()
{
 DllCall("ole32\CoUninitialize")
}

COM_AtlAxWinTerm(Version = "")
{
 COM_Term()
 If (h := DllCall("GetModuleHandle", "str", "atl" . Version))
  Return, DllCall("FreeLibrary", "Uint", h)
}

COM_SysAllocString(astr)
{
 Return, DllCall("oleaut32\SysAllocString", "Uint", COM_SysString(astr,astr))
}

COM_VTable(ppv, idx)
{
 Return, NumGet(NumGet(1*ppv)+4*idx)
}

COM_SysFreeString(bstr)
{
 DllCall("oleaut32\SysFreeString", "Uint", bstr)
}

COM_Unicode2Ansi(ByRef wString, ByRef sString, nSize = "")
{
 pString := wString + 0 > 65535 ? wString : &wString
 If (nSize = "")
  nSize:=DllCall("kernel32\WideCharToMultiByte", "Uint", 0, "Uint", 0, "Uint", pString, "int", -1, "Uint", 0, "int",  0, "Uint", 0, "Uint", 0)
 VarSetCapacity(sString, nSize)
 DllCall("kernel32\WideCharToMultiByte", "Uint", 0, "Uint", 0, "Uint", pString, "int", -1, "str", sString, "int", nSize + 1, "Uint", 0, "Uint", 0)
 Return, &sString
}

COM_GUID4String(ByRef CLSID, String)
{
 VarSetCapacity(CLSID, 16)
 DllCall("ole32\CLSIDFromString", "Uint", COM_SysString(String,String), "Uint", &CLSID)
 Return, &CLSID
}

COM_QueryInterface(ppv, IID = "")
{
 If DllCall(NumGet(NumGet(1*ppv)+0), "Uint", ppv, "Uint", COM_GUID4String(IID,IID ? IID : IID=0 ? "{00000000-0000-0000-C000-000000000046}" : "{00020400-0000-0000-C000-000000000046}"), "UintP", ppv)=0
 Return, ppv
}

COM_QueryService(ppv, SID, IID = "")
{
 DllCall(NumGet(NumGet(1*ppv)+4*0), "Uint", ppv, "Uint", COM_GUID4String(IID_IServiceProvider,"{6D5140C1-7436-11CE-8034-00AA006009FA}"), "UintP", psp)
 DllCall(NumGet(NumGet(1*psp)+4*3), "Uint", psp, "Uint", COM_GUID4String(SID,SID), "Uint", IID ? COM_GUID4String(IID,IID) : &SID, "UintP", ppv:=0)
 DllCall(NumGet(NumGet(1*psp)+4*2), "Uint", psp)
 Return, ppv
}

COM_Init()
{
 Return, DllCall("ole32\OleInitialize", "Uint", 0)
}

COM_CLSID4ProgID(ByRef CLSID, ProgID)
{
 VarSetCapacity(CLSID, 16)
 DllCall("ole32\CLSIDFromProgID", "Uint", COM_SysString(ProgID,ProgID), "Uint", &CLSID)
 Return, &CLSID
}

COM_Term()
{
 Return, DllCall("ole32\OleUninitialize")
}

COM_SysString(ByRef wString, sString)
{
 VarSetCapacity(wString,3+2*nLen:=1+StrLen(sString))
 Return, NumPut(DllCall("kernel32\MultiByteToWideChar","Uint",0,"Uint",0,"Uint",&sString,"int",nLen,"Uint",&wString+4,"int",nLen,"Uint")*2-2,wString)
}