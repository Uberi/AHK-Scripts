; Media Player Classic Home Cinema Function Library by Specter333
; A complete list of HTTP functins can be found at 
; http://www.autohotkey.com/forum/viewtopic.php?p=490310#490310
; Use HTTP functions to control Media Player Classic Home Cinema with out it being active.
; Home page, http://mpc-hc.sourceforge.net/
; To enable the HTTP interface, click View/Options, then in the Player menu chose Web Interface.
; Check "Listen on port:", port number is 13579.

MPCHTTP_Play(ip,port) ; localhost:13579
	{
	url = http://%ip%:%port%/command.html?wm_command=887 
	MPCUrlDownloadToVar(url)
	}
MPCHTTP_Pause(ip,port)
	{
	url = http://%ip%:%port%/command.html?wm_command=888
	MPCUrlDownloadToVar(url)
	}
MPCHTTP_PlayPause(ip,port)
	{
	url = http://%ip%:%port%/command.html?wm_command=889
	MPCUrlDownloadToVar(url)
	}
MPCHTTP_Stop(ip,port)
	{
	url = http://%ip%:%port%/command.html?wm_command=890
	MPCUrlDownloadToVar(url)
	}
MPCHTTP_FullScreen(ip,port)
	{
	url = http://%ip%:%port%/command.html?wm_command=830
	MPCUrlDownloadToVar(url)
	}
MPCHTTP_JumpForward(ip,port)
	{ 
   	url = http://%ip%:%port%/command.html?wm_command=902
	MPCUrlDownloadToVar(url)
	}
MPCHTTP_JumpBackward(ip,port)
	{     
	url = http://%ip%:%port%/command.html?wm_command=901
	MPCUrlDownloadToVar(url)
	}
MPCHTTP_PlayFaster(ip,port)
	{     
	url = http://%ip%:%port%/command.html?wm_command=895
	MPCUrlDownloadToVar(url)
	}
MPCHTTP_PlaySlower(ip,port)
	{     
	url = http://%ip%:%port%/command.html?wm_command=894
	MPCUrlDownloadToVar(url)
	}
MPCHTTP_VolumeUp(ip,port)
	{     
	url = http://%ip%:%port%/command.html?wm_command=907
	MPCUrlDownloadToVar(url)
	}
MPCHTTP_VolumeDown(ip,port)
	{     
	url = http://%ip%:%port%/command.html?wm_command=908
	MPCUrlDownloadToVar(url)
	}
MPCHTTP_Mute(ip,port)
	{     
	url = http://%ip%:%port%/command.html?wm_command=909
	MPCUrlDownloadToVar(url)
	}
MPCHTTP_RootMenu(ip,port)
	{     
	url = http://%ip%:%port%/command.html?wm_command=923
	MPCUrlDownloadToVar(url)
	}
MPCHTTP_Exit(ip,port)
	{     
	url = http://%ip%:%port%/command.html?wm_command=816
	MPCUrlDownloadToVar(url)
	}
MPCHTTP(ip,port,msg)
	{     
	url = http://%ip%:%port%/command.html?wm_command=%msg%
	MPCUrlDownloadToVar(url)
	}	



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;  UrlDownloadToVar by olfen 
; http://www.autohotkey.com/forum/viewtopic.php?p=64230#64230
MPCUrlDownloadToVar(URL, Proxy="", ProxyBypass="") {
AutoTrim, Off
hModule := DllCall("LoadLibrary", "str", "wininet.dll")

If (Proxy != "")
AccessType=3
Else
AccessType=1
;INTERNET_OPEN_TYPE_PRECONFIG                    0   // use registry configuration
;INTERNET_OPEN_TYPE_DIRECT                       1   // direct to net
;INTERNET_OPEN_TYPE_PROXY                        3   // via named proxy
;INTERNET_OPEN_TYPE_PRECONFIG_WITH_NO_AUTOPROXY  4   // prevent using java/script/INS

io_hInternet := DllCall("wininet\InternetOpenA"
, "str", "" ;lpszAgent
, "uint", AccessType
, "str", Proxy
, "str", ProxyBypass
, "uint", 0) ;dwFlags

iou := DllCall("wininet\InternetOpenUrlA"
, "uint", io_hInternet
, "str", url
, "str", "" ;lpszHeaders
, "uint", 0 ;dwHeadersLength
, "uint", 0x80000000 ;dwFlags: INTERNET_FLAG_RELOAD = 0x80000000 // retrieve the original item
, "uint", 0) ;dwContext

If (ErrorLevel != 0 or iou = 0) {
DllCall("FreeLibrary", "uint", hModule)
return 0
}

VarSetCapacity(buffer, 512, 0)
VarSetCapacity(NumberOfBytesRead, 4, 0)
Loop
{
  irf := DllCall("wininet\InternetReadFile", "uint", iou, "uint", &buffer, "uint", 512, "uint", &NumberOfBytesRead)
  NOBR = 0
  Loop 4  ; Build the integer by adding up its bytes. - ExtractInteger
    NOBR += *(&NumberOfBytesRead + A_Index-1) << 8*(A_Index-1)
  IfEqual, NOBR, 0, break
  ;BytesReadTotal += NOBR
  DllCall("lstrcpy", "str", buffer, "uint", &buffer)
  res = %res%%buffer%
}
StringTrimRight, res, res, 2

DllCall("wininet\InternetCloseHandle",  "uint", iou)
DllCall("wininet\InternetCloseHandle",  "uint", io_hInternet)
DllCall("FreeLibrary", "uint", hModule)
AutoTrim, on
return, res
} 