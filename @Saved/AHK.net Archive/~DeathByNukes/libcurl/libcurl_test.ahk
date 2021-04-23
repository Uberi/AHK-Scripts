#SingleInstance, force
#NoEnv
#include FileHelper.ahk ; http://www.autohotkey.com/forum/topic19608.html
#include libcurl.ahk

if ( CurlGlobalInit( "libcurl" ) != 0 )
	ExitApp
hCurlEasy := CurlEasyInit()
CurlEasyDefineOptions()
CurlGetInfoDefine()

CurlShowErrors()


Url = http://dl.google.com/earth/client/branded/redirect/Google_Earth_BZXV.exe
hFile := CreateFile( A_ScriptDir . "\Google_Earth_BZXV.exe", 2 )

MsgBox % CurlVersion() ;%


CurlEasySetOption( hCurlEasy, CURLOPT_URL, &URL )

VarSetCapacity(CURL_ERROR, CURL_ERROR_SIZE + 1)
CurlEasySetOption( hCurlEasy, CURLOPT_ERRORBUFFER, &CURL_ERROR )

CurlEasySetOption( hCurlEasy, CURLOPT_NOPROGRESS, 0 )
pCurlProgressFunction := RegisterCallback("CurlProgressFunction", "C F") 
CurlEasySetOption( hCurlEasy, CURLOPT_PROGRESSFUNCTION, pCurlProgressFunction )

pCurlWriteFunction := RegisterCallback("CurlWriteFunction", "C F")
CurlEasySetOption( hCurlEasy, CURLOPT_WRITEFUNCTION, pCurlWriteFunction )


If ( CurlEasyPerform( hCurlEasy ) )
  MsgBox % CURL_ERROR ;%


Progress, Off
CloseHandle(hFile)

MsgBox % "Average download speed: " . Round( CurlEasyGetinfo( hCurlEasy, CURLINFO_SPEED_DOWNLOAD ) ) . " bytes\s`nTransfer time: " . Round( CurlEasyGetinfo( hCurlEasy, CURLINFO_TOTAL_TIME ) ) . " seconds" ;%


CurlEasyCleanup( hCurlEasy )
CurlFreeLibrary()
return


CurlProgressFunction(clientp, dltotal_l, dltotal_h, dlnow_l, dlnow_h, ultotal_l, ultotal_h, ulnow_l, ulnow_h)
{
	dltotal := MergeDouble( dltotal_l, dltotal_h )
	dlnow := MergeDouble( dlnow_l, dlnow_h )

	KBTotal := Round( dltotal / 1024, 2 )
	KBNow := Round( dlnow / 1024, 2 )
	Percent := Round( dlnow / dltotal * 100, 2 )
	Progress, %Percent%, %KBNow% of %KBTotal% KB (%Percent% `%)

	Return 0
}


CurlWriteFunction(pBuffer, size, nitems, pOutStream)
{
	global hFile
	WriteFile(hFile, pBuffer, size*nitems)
	return size*nitems
}



