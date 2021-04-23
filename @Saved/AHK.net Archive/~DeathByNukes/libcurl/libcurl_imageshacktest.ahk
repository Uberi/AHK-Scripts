#SingleInstance, force
#NoEnv
#include FileHelper.ahk ; http://www.autohotkey.com/forum/topic19608.html
#include libcurl.ahk

Debug := true

if ( Debug )
	CurlShowErrors()

if ( CurlGlobalInit( "libcurl" ) != 0 )
	ExitApp
hCurlEasy := CurlEasyInit()
CurlEasyDefineOptions()
CurlGetInfoDefine()


hFile := CreateFile( A_ScriptDir . "\imageshack_upload.txt", 2 )
UploadImage = %A_WinDir%\Web\Wallpaper\Vortec space.jpg
UploadImageContentType = image/jpeg

MsgBox % CurlVersion() ;%


if ( Debug )
{
	;CurlEasySetOption( hCurlEasy, CURLOPT_HEADER, 1 )
	CurlEasySetOption( hCurlEasy, CURLOPT_VERBOSE, 1 )

	hDebugFile := CreateFile( A_ScriptDir . "\libcurl_debug.log", 2 )
	; CurlEasySetOption( hCurlEasy, CURLOPT_STDERR, hDebugFile ) ; Breaks libcurl for some reason.
	pCurlDebugFunction := RegisterCallback("CurlDebugFunction", "C F")
	CurlEasySetOption( hCurlEasy, CURLOPT_DEBUGFUNCTION, pCurlDebugFunction )
}


CurlEasySetOption( hCurlEasy, CURLOPT_URL, "http://imageshack.us/" )

pPostListFirst = 0
pPostListLast = 0
fileupload_str = fileupload
CurlFormAdd( pPostListFirst, pPostListLast
	, CURLFORM_COPYNAME, &fileupload_str
	, CURLFORM_FILE, &UploadImage
	, CURLFORM_CONTENTTYPE, &UploadImageContentType
	, CURLFORM_END )
CurlEasySetOption( hCurlEasy, CURLOPT_HTTPPOST, pPostListFirst )
; Don't use CurlFormFree 'til after CurlEasyCleanup.

; HTTPPOST automatically enables this. We do want the body so we can parse the image location so re-disable it.
CurlEasySetOption( hCurlEasy, CURLOPT_NOBODY, 0 )

; Override the "Expect: 100-continue" header automatically added with HTTPPOST.
pHeaderList = 0
CurlSlistAppend( pHeaderList, "Expect:" )
CurlEasySetOption( hCurlEasy, CURLOPT_HTTPHEADER, pHeaderList )
; Don't use CurlSlistFreeAll 'til after CurlEasyCleanup.


VarSetCapacity(CURL_ERROR, CURL_ERROR_SIZE + 1)
CurlEasySetOption( hCurlEasy, CURLOPT_ERRORBUFFER, &CURL_ERROR )

CurlEasySetOption( hCurlEasy, CURLOPT_NOPROGRESS, 0 )
pCurlProgressFunction := RegisterCallback("CurlProgressFunction", "C F") 
CurlEasySetOption( hCurlEasy, CURLOPT_PROGRESSFUNCTION, pCurlProgressFunction )

pCurlWriteFunction := RegisterCallback("CurlWriteFunction", "C F")
CurlEasySetOption( hCurlEasy, CURLOPT_WRITEFUNCTION, pCurlWriteFunction )


Progress, 1:Y400, Upload
Progress, 2:Y500, Download

ErrorCode := CurlEasyPerform( hCurlEasy )

Progress, 1:Off
Progress, 2:Off

If ( ErrorCode )
{
	VarSetCapacity( CURL_ERROR, -1 )
	MsgBox, 16, Error, % "Curl error #" . ErrorCode . ": " . CurlEasyStrError( ErrorCode ) . "`n" . CURL_ERROR ;%
}


CloseHandle( hFile )

if ( Debug )
	CloseHandle( hDebugFile )

if ( !ErrorCode )
MsgBox % "Average download speed: " . Round( CurlEasyGetinfo( hCurlEasy, CURLINFO_SPEED_DOWNLOAD ) ) . " bytes/s`n"
 . "Transfer time: " . Round( CurlEasyGetinfo( hCurlEasy, CURLINFO_TOTAL_TIME ) ) . " seconds`n"
 . "Uploaded: " .  Round( CurlEasyGetinfo( hCurlEasy, CURLINFO_SIZE_UPLOAD ) ) . " bytes`n"
 . "Average upload speed: " .  Round( CurlEasyGetinfo( hCurlEasy, CURLINFO_SPEED_UPLOAD  ) ) . " bytes/s`n"
 . "Upload specified: " .  Round( CurlEasyGetinfo( hCurlEasy, CURLINFO_CONTENT_LENGTH_UPLOAD ) ) . " bytes`n"
 ;%

CurlEasyCleanup( hCurlEasy )
CurlSlistFreeAll( pHeaderList )
CurlFormFree( pPostListFirst )
CurlFreeLibrary()
return


; int curl_debug_callback (CURL *, curl_infotype, char *, size_t, void *);
CurlDebugFunction( curlp, infotype, string, stringsize, pointer )
{
/*
	if ( infotype = 0 )
		type = CURLINFO_TEXT
	else
	{
		if ( infotype = 1 )
			type = CURLINFO_HEADER_IN
		else
		{
			if ( infotype = 2 )
				type = CURLINFO_HEADER_OUT
			else
			{
				if ( infotype = 3 )
					type = CURLINFO_DATA_IN
				else
				{
					if ( infotype = 4 )
						type = CURLINFO_DATA_OUT
					else
					{
						type = CURLINFO_unrecognized_type
					}
				}
			}
		}
	}
	
	type = `n`n%type%`n
*/
	global hDebugFile
;	WriteFile( hDebugFile, type, strlen(type) ) ; Doesn't work?
	WriteFile( hDebugFile, string, stringsize )
	return 0
}


CurlProgressFunction(clientp, dltotal_l, dltotal_h, dlnow_l, dlnow_h, ultotal_l, ultotal_h, ulnow_l, ulnow_h)
{
	dltotal := MergeDouble( dltotal_l, dltotal_h )
	dlnow := MergeDouble( dlnow_l, dlnow_h )
	ultotal := MergeDouble( ultotal_l, ultotal_h )
	ulnow := MergeDouble( ulnow_l, ulnow_h )

	KBTotal := Round( ultotal / 1024, 2 )
	KBNow := Round( ulnow / 1024, 2 )
	Percent := Round( ulnow / ultotal * 100, 2 )
	Progress, 1:%Percent%, %KBNow% of %KBTotal% KB Uploaded (%Percent% `%)
	
	KBTotal := Round( dltotal / 1024, 2 )
	KBNow := Round( dlnow / 1024, 2 )
	Percent := Round( dlnow / dltotal * 100, 2 )
	Progress, 2:%Percent%, %KBNow% of %KBTotal% KB Downloaded (%Percent% `%)

	Return 0
}


CurlWriteFunction(pBuffer, size, nitems, pOutStream)
{
	global hFile
	WriteFile( hFile, pBuffer, size*nitems )
	return size*nitems
}



