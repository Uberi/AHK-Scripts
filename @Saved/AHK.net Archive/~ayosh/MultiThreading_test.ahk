#Include AhkDllObject.ahk
#NoEnv
SetBatchLines, -1

;~ ?????????? ?? ????????? ??? ????? COM
gosub, s

;~ ?????????? ???????
Threads = 50 
;~ ????????? ??????????...
Gosub, LauchThreads

;~ ????????? ???????? ??????
Loop % Threads
    dll%A_Index%.ahktextdll("#NoTrayIcon`nSetBatchLines,-1`nLoop 10`n{`nx++`nSleep 1000`n}")


;~ ??? ???? ???? )
wh := 13*Threads
gui +alwaysontop
gui, add, text, vr w200 h%wh%
gui, add, button, gGuiClose vbtn y20 hidden, Exit
gui, show, ,Threads test

;~ ??????? ???? ??? ?????? ??????????, ??????????? ??????????? ??????????, ????????? ????
While ThreadsReady(Threads) != 0
{   statestr :=
    Loop % Threads  
        statestr .= (dll%A_Index%.ahkgetvar("x") ? "Thread " A_Index "; x = " dll%A_Index%.ahkgetvar("x") : "no var") "`n"
    GuiControl,, r, % statestr
    Sleep 250
}


;~ ???? ? COM ?????????, ????????? ?????? ?? ????????? COM
Loop 3
    dll%A_Index%.ahktextdll(script%a_index%)

;~ ????, ?????????..
While ThreadsReady(3) != 0
{   
    statestr :=
    Loop 3
        statestr .=  (dll%A_Index%.ahkReady() ? "COM thread running" : "COM thread closed") "`n"
    GuiControl,, r, % statestr
    Sleep 250
}
GuiControl,, r, COM threads finished
GuiControl, show, btn
;~ ????????? ??????? ????????? ?????? )
Run % A_ScriptDir
Return

ThreadsReady(Threads) {
    Loop % Threads
        sum += dll%A_Index%.ahkReady()
    Return sum
}

GuiClose:
ExitApp
Return

LauchThreads:
Loop % Threads
{
;~  ...??? ??????? ???????
    FileMove, % ahkdll := A_Index = 1 ? "AutoHotkey.dll" : "AutoHotkey" A_Index-1 ".dll", AutoHotkey%A_Index%.dll
    dll%A_Index%:=AhkdllObject("AutoHotkey" A_Index ".dll")
}
FileMove, AutoHotkey%Threads%.dll, AutoHotkey.dll
Return

s:
script1 =
(
#Include COM.ahk
sURL :=   "http://www.autohotkey.com/download/AutoHotkeyInstall.exe"
sFile:=   A_WorkingDir "\AutoHotkeyInstall1.exe"
bOverWrite := True 

COM_Init() 
pwhr :=   COM_CreateObject("WinHttp.WinHttpRequest.5.1") 
COM_Invoke(pwhr, "Open", "GET", sURL) 
COM_Invoke(pwhr, "Send") 

If   psfa :=   COM_Invoke(pwhr, "ResponseBody") 
{ 
pstm :=   COM_CreateObject("ADODB.Stream") 
COM_Invoke(pstm, "Type", 1)   ; adTypeBinary:=1, adTypeText:=2 
COM_Invoke(pstm, "Open") 
COM_Invoke_(pstm, "Write", 0x2011, psfa) ; VT_ARRAY | VT_UI1 
COM_Invoke(pstm, "SaveToFile", sFile, bOverWrite ? 2:1) 
COM_Invoke(pstm, "Close") 
COM_Release(pstm) 
COM_SafeArrayDestroy(psfa) 
} 

COM_Release(pwhr)  
COM_Term()
)
script2 =
(
#Include COM.ahk
sURL :=   "http://www.autohotkey.com/download/AutoHotkeyInstall.exe"
sFile:=   A_WorkingDir "\AutoHotkeyInstall2.exe"
bOverWrite := True 

COM_Init() 
pwhr :=   COM_CreateObject("WinHttp.WinHttpRequest.5.1") 
COM_Invoke(pwhr, "Open", "GET", sURL) 
COM_Invoke(pwhr, "Send") 

If   psfa :=   COM_Invoke(pwhr, "ResponseBody") 
{ 
pstm :=   COM_CreateObject("ADODB.Stream") 
COM_Invoke(pstm, "Type", 1)   ; adTypeBinary:=1, adTypeText:=2 
COM_Invoke(pstm, "Open") 
COM_Invoke_(pstm, "Write", 0x2011, psfa) ; VT_ARRAY | VT_UI1 
COM_Invoke(pstm, "SaveToFile", sFile, bOverWrite ? 2:1) 
COM_Invoke(pstm, "Close") 
COM_Release(pstm) 
COM_SafeArrayDestroy(psfa) 
} 

COM_Release(pwhr)  
COM_Term()
)
script3 =
(
#Include COM.ahk
sURL :=   "http://www.autohotkey.com/download/AutoHotkeyInstall.exe"
sFile:=   A_WorkingDir "\AutoHotkeyInstall3.exe"
bOverWrite := True 

COM_Init() 
pwhr :=   COM_CreateObject("WinHttp.WinHttpRequest.5.1") 
COM_Invoke(pwhr, "Open", "GET", sURL) 
COM_Invoke(pwhr, "Send") 

If   psfa :=   COM_Invoke(pwhr, "ResponseBody") 
{ 
pstm :=   COM_CreateObject("ADODB.Stream") 
COM_Invoke(pstm, "Type", 1)   ; adTypeBinary:=1, adTypeText:=2 
COM_Invoke(pstm, "Open") 
COM_Invoke_(pstm, "Write", 0x2011, psfa) ; VT_ARRAY | VT_UI1 
COM_Invoke(pstm, "SaveToFile", sFile, bOverWrite ? 2:1) 
COM_Invoke(pstm, "Close") 
COM_Release(pstm) 
COM_SafeArrayDestroy(psfa) 
} 

COM_Release(pwhr)  
COM_Term()
)
Return