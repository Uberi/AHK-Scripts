/*
###############################################################################################################
###                                       HTTPRequest. Version: 2.41                                        ###
###############################################################################################################

Copyright © 2011-2012 [VxE]. All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that
the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this list of conditions and the
following disclaimer.

2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the
following disclaimer in the documentation and/or other materials provided with the distribution.

3. The name "[VxE]" may not be used to endorse or promote products derived from this software without specific
prior written permission.

THIS SOFTWARE IS PROVIDED BY [VxE] "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED
TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT
SHALL [VxE] BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR
TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF
THE POSSIBILITY OF SUCH DAMAGE.
*/

HTTPRequest( URL, byref In_POST__Out_Data="", byref In_Out_HEADERS="", Options="" ) { ; -----------------------
; Function by [VxE], compatible with AHK v1.0.48.05 (basic), v1.1.00.00 (AHK-L ANSI, Unicode, x64) and later.
; Special thanks to derRaphael and everyone who reported bugs and/or suggested improvements.
; Source is freely available at: http://www.autohotkey.com/forum/viewtopic.php?t=66290
; MUFL-Info: http://dl.dropbox.com/u/13873642/mufl_httprequest.txt
; Submits one request to the specified URL with optional POST data and custom headers. Upon success, returns
; the number of bytes downloaded OR the number of characters in the response. Otherwise, returns zero and a
; description of the error is placed in 'In_Out_HEADERS'. The response body and headers are placed into
; 'In_POST__Out_Data' and 'In_Out_HEADERS' respectively, and text data is converted from the codepage stated in
; the header to the script's ANSI codepage OR to UTF-16 for unicode versions of AHK.
; "ErrorLevel" is set to '0' if there is a problem, otherwise it is set to the HTTP response code.

	Static version := "2.41", Ptr, PtrSize, IsUnicode, MyACP, MyCharset, Default_Agent, WorA := ""
	, Default_Accept_Types := "text/xml, text/json; q=0.4, text/html; q=0.3, text/*; q=0.2, */*; q=0.1"
; This list of content subtypes is not official, I just globbed together a few MIME subtypes to use
; as a whitelist for converting downloaded text to the script's codepage. If the Content-Type
; response header IS "text/..." OR one of these subtypes follows the "/", then the data is treated
; as text. Otherwise, the data is treated as binary and the user must deal with it as binary.
	, Text_Content_Subtypes := "/atom/html/json/rss/soap/xhtml/xml/x-www-form-urlencoded"
; The list of internet flags and values has been condensed and obfuscated for version (09-10-2011).
; Flag values may be found here > http://msdn.microsoft.com/en-us/library/aa383661%28v=vs.85%29.aspx
	, internet_flags_list := "
( LTRIM JOIN|INTERNET_FLAG_
	....
	NEED_FILE
	MUST_CACHE_REQUEST|.
	FWD_BACK|.
	FORMS_SUBMIT|..
	PRAGMA_NOCACHE|.
	NO_UI|.
	HYPERLINK|.
	RESYNCHRONIZE|.
	IGNORE_CERT_CN_INVALID|.
	IGNORE_CERT_DATE_INVALID|.
	IGNORE_REDIRECT_TO_HTTPS|.
	IGNORE_REDIRECT_TO_HTTP|..
	RESTRICTED_ZONE|.
	NO_AUTH|.
	NO_COOKIES|.
	READ_PREFETCH|.
	NO_AUTO_REDIRECT|.
	KEEP_CONNECTION|.
	SECURE|.
	FROM_CACHE
	OFFLINE|.
	MAKE_PERSISTENT|.
	DONT_CACHE|...
	NO_CACHE_WRITE|.
	RAW_DATA|.
	RELOAD|
)"
; Update (12-10-2011): The list of security flags and values is condensed and obfuscated.
; Flag values may be found here > http://msdn.microsoft.com/en-us/library/aa385328%28v=VS.85%29.aspx
	, security_flags_list := "
( LTRIM JOIN|SECURITY_FLAG_
	SECURE|.
	SSL|.
	SSL3|.
	PCT|.
	PCT4|.
	IETFSSL4|..
	IGNORE_REVOCATION|.
	IGNORE_UNKNOWN_CA|.
	IGNORE_WRONG_USAGE|...
	IGNORE_CERT_CN_INVALID|.
	IGNORE_CERT_DATE_INVALID|.
	IGNORE_REDIRECT_TO_HTTPS|.
	IGNORE_REDIRECT_TO_HTTP|............
	FORTEZZA|.
	40BIT
	NORMALBITNESS
	STRENGTH_WEAK|.
	128BIT
	STRENGTH_STRONG|.
	56BIT
	STRENGTH_MEDIUM|.
	UNKNOWNBIT|
)"
	, Codepage_Charsets := "|
; Codepage list taken from here > http://msdn.microsoft.com/en-us/library/dd317756%28v=vs.85%29.aspx
( LTRIM JOIN|
	00037=IBM037|00437=IBM437|00500=IBM500|00708=ASMO-708|00720=DOS-720|00737=ibm737
	00775=ibm775|00850=ibm850|00852=ibm852|00855=IBM855|00857=ibm857|00858=IBM00858|00860=IBM860
	00861=ibm861|00862=DOS-862|00863=IBM863|00864=IBM864|00865=IBM865|00866=cp866|00869=ibm869
	00870=IBM870|00874=windows-874|00875=cp875|00932=shift_jis|00936=gb2312|00949=ks_c_5601-1987
	00950=big5|01026=IBM1026|01047=IBM01047|01140=IBM01140|01141=IBM01141|01142=IBM01142
	01143=IBM01143|01144=IBM01144|01145=IBM01145|01146=IBM01146|01147=IBM01147|01148=IBM01148
	01149=IBM01149|01200=utf-16|01201=unicodeFFFE|01250=windows-1250|01251=windows-1251
	01252=Windows-1252|01253=windows-1253|01254=windows-1254|01255=windows-1255
	01256=windows-1256|01257=windows-1257|01258=windows-1258|01361=Johab|10000=macintosh
	10001=x-mac-japanese|10002=x-mac-chinesetrad|10003=x-mac-korean|10004=x-mac-arabic
	10005=x-mac-hebrew|10006=x-mac-greek|10007=x-mac-cyrillic|10008=x-mac-chinesesimp
	10010=x-mac-romanian|10017=x-mac-ukrainian|10021=x-mac-thai|10029=x-mac-ce
	10079=x-mac-icelandic|10081=x-mac-turkish|10082=x-mac-croatian|12000=utf-32|12001=utf-32BE
	20000=x-Chinese-CNS|20001=x-cp20001|20002=x-Chinese-Eten|20003=x-cp20003|20004=x-cp20004
	20005=x-cp20005|20105=x-IA5|20106=x-IA5-German|20107=x-IA5-Swedish|20108=x-IA5-Norwegian
	20127=us-ascii|20261=x-cp20261|20269=x-cp20269|20273=IBM273|20277=IBM277|20278=IBM278
	20280=IBM280|20284=IBM284|20285=IBM285|20290=IBM290|20297=IBM297|20420=IBM420|20423=IBM423
	20424=IBM424|20833=x-EBCDIC-KoreanExtended|20838=IBM-Thai|20866=koi8-r|20871=IBM871
	20880=IBM880|20905=IBM905|20924=IBM00924|20932=EUC-JP|20936=x-cp20936|20949=x-cp20949
	21025=cp1025|21866=koi8-u|28591=iso-8859-1|28592=iso-8859-2|28593=iso-8859-3|28594=iso-8859-4
	28595=iso-8859-5|28596=iso-8859-6|28597=iso-8859-7|28598=iso-8859-8|28599=iso-8859-9
	28603=iso-8859-13|28605=iso-8859-15|29001=x-Europa|38598=iso-8859-8-i|50220=iso-2022-jp
	50221=csISO2022JP|50222=iso-2022-jp|50225=iso-2022-kr|50227=x-cp50227|51932=euc-jp
	51936=EUC-CN|51949=euc-kr|52936=hz-gb-2312|54936=GB18030|57002=x-iscii-de|57003=x-iscii-be
	57004=x-iscii-ta|57005=x-iscii-te|57006=x-iscii-as|57007=x-iscii-or|57008=x-iscii-ka
	57009=x-iscii-ma|57010=x-iscii-gu|57011=x-iscii-pa|65000=utf-7|65001=utf-8|
)"

; Step 1: Initialize internal variables, including the static variables for unknown constants.
	If ( WorA = "" )
	{
		If ( A_PtrSize = "" ) ; Check for 64 bit environment
			PtrSize := 4, Ptr := "UInt"
		Else PtrSize := A_PtrSize, Ptr := "Ptr"
		If !( IsUnicode := 1 = A_IsUnicode ) ; Check for unicode (wide char) environment
		; GetACP > http://msdn.microsoft.com/en-us/library/ms905215.aspx
			WorA := "A", MyACP := SubStr( 100000.0 + DllCall("GetACP"), 2, 5 )
		Else WorA := "W", MyACP := "01200" ; UTF-16
		; Detect the active codepage and look up the charset identifier for it (default = UTF-8)
		MyCharset := ( 7 = pos := 7 + InStr( Codepage_Charsets, "|" MyACP "=" ) ) ? "UTF-8"
		: SubStr( Codepage_Charsets, pos, InStr( Codepage_Charsets, "|", 0, pos ) - pos )
		SplitPath, A_ScriptName,,,, Default_Agent
		Default_Agent .= "/1.0 (Language=AutoHotkey/" A_AhkVersion "; Platform=" A_OSVersion ")"
	}

; Initialize local variables
	Internet_Open_Type := 1 ; INTERNET_OPEN_TYPE_DIRECT = 1 ; _PRECONFIG = 0 ; _PROXY = 3
	Security_Flags := Security_Flags_Add := Security_Flags_Nix := 0
	Response_Code := "0"
	Do_Callback := 0
	Do_NonBinary_Up := 0
	Do_Binary_Down := 0
	Do_Up_MD5_Hash := 0
	Do_Dn_MD5_Hash := 0
	Do_File_Upload := 0
	Do_Multipart := 0
	Do_Download_To_File := 0
	Do_Download_Resume := 0
	Do_Legacy_Dual_Output := 0
	Agent := Default_Agent
	Accept_Types := Default_Accept_Types
	Multipart_Boundary := ""
	proxy_bypass := ""
	Method_Verb := ""
	MyErrors := ""
	dbuffsz := 0
	port := 0
	dtsz := 0
	Convert_POST_To_Codepage := MyACP

; Initialize typical flags for a normal request. These can be modified with the 'Options' parameter.
	Internet_Flags := 0
	| 0x400000 ; INTERNET_FLAG_KEEP_CONNECTION
	| 0x80000000 ; INTERNET_FLAG_RELOAD
	| 0x20000000 ; INTERNET_FLAG_NO_CACHE_WRITE

	StringLen, Content_Length, In_POST__Out_Data ; predetermine the content-length.
	Content_Length <<= IsUnicode

; Step 2: Crack the url into its components. WinINet\InternetCrackURL limits the url to about 2060
; characters, which is unacceptable, especially for a function designed to service web APIs.

	hbuffer := "The provided url could not be parsed: """ URL """" ; pre-generate the bad-url error

; Crack the scheme (setting it to 'http' if omitted, allowing a url like "www.***.com")
	If ( pos := InStr( URL, "://" ) )
	{
		StringLeft, scheme, URL, pos - 1
		StringLower, scheme, scheme
		StringTrimLeft, URL, URL, pos + 2
		If ( scheme = "https" ) ; Connect using SSL. Add the following internet flags:
			Internet_Flags |= 0x1000 ; INTERNET_FLAG_IGNORE_CERT_CN_INVALID
						| 0x2000   ; INTERNET_FLAG_IGNORE_CERT_DATE_INVALID
						| 0x800000 ; INTERNET_FLAG_SECURE ; Technically, this is redundant for https
		Else If ( scheme != "http" )
			Return 0, ErrorLevel := 0, In_Out_HEADERS := "HTTPRequest does not support '" scheme "' type connections."
	}
	Else scheme := "http"

; Crack the path and query (leave them joined as one string because that's how HttpOpenRequest accepts them).
	StringLeft, host, URL, pos := InStr( URL "/", "/" ) - 1
	StringTrimLeft, URL, URL, pos

; Crack the username and password from the host (if present).
	If ( pos := InStr( host, "@" ) )
	{
		StringLeft, user, host, pos - 1
		StringTrimLeft, host, host, pos
		If ( pos := InStr( user, ":" ) )
		{
			StringTrimLeft, pass, user, pos
			StringLeft, user, user, pos - 1
		}
		Else pass := ""
	}
	Else user := pass := ""

; Crack the port from the host. If the host looks like a bracketed IP literal, look for the colon
; to the right of the close-bracket. Default port is 80 for HTTP and 443 for HTTPS
	If ( pos := InStr( host, ":", 0, InStr( host, "[" ) = 1 ? InStr( host, "]" ) + 1 : 1 ) )
	&& ( 0 < port := 0 | SubStr( host, pos + 1 ) ) && ( port < 65536 )
	{
		StringTrimLeft, port, host, pos
		StringLeft, host, host, pos - 1
	}
	Else port := scheme = "https" ? 443 : 80

; Return error if the host is blank (don't check for other format errors).
	If ( host = "" )
		Return 0, ErrorLevel := 0, In_Out_HEADERS := hbuffer

; Step 3: Parse the request headers so we can copy them to an internal buffer, make them pretty, and
; handle special headers (like acceptable mime types, user agent and content specs).
	StringLen, pos, In_Out_HEADERS
	VarSetCapacity( hbuffer, 1 + pos << IsUnicode )
	hbuffer := "`r`n"
	Loop, Parse, In_Out_HEADERS, `n
	{
		StringReplace, rbuffer, A_LoopField, :, `n
		Loop, Parse, rbuffer, `n, % "`t`r "
			If ( A_Index = 1 )
				rbuffer := A_LoopField
			Else If ( A_LoopField = "" )
				If ( rbuffer = "Content-MD5" )
					Do_Up_MD5_Hash := 1
				Else Continue
			Else If ( rbuffer = "Accept" )
				Accept_Types := A_LoopField
			Else If ( rbuffer = "Content-Length" ) && ( 0 < 1 | A_LoopField )
				Content_Length := A_LoopField
			Else If ( rbuffer = "Content-Type" )
			{
				hbuffer .= "Content-Type: " A_LoopField "`r`n"
				StringReplace, Multipart_Boundary, A_LoopField, % ",", % ";", A
				If ( 7 != pos := 7 + InStr( Multipart_Boundary, "charset=" ) )
				&& ( pos := InStr( Codepage_Charsets, SubStr( Multipart_Boundary, pos
					, InStr( Multipart_Boundary ";" , ";", 0, pos ) - pos ) "|" ) )
					StringMid, Convert_POST_To_Codepage, Codepage_Charsets, pos - 5, 5

				; NOT YET IMPLEMENTED: detect multipart content and determine the boundary
				Multipart_Boundary := ( InStr( A_LoopField, "Multipart/" ) != 1
					|| 9 = pos := 9 + InStr( Multipart_Boundary, "boundary=" ) ) ? ""
				: SubStr( Multipart_Boundary, pos, InStr( Multipart_Boundary ";", ";" ) - pos )
			}
			Else If ( rbuffer = "Referrer" )
				hbuffer .= "Referer: " A_LoopField "`r`n"
			Else If ( rbuffer = "User-Agent" )
				Agent := A_LoopField
			Else hbuffer .= rbuffer ": " A_LoopField "`r`n"
	}
; Automatically add the 'no cookies' flag if the user specified a custom cookie. The flag actually tells
; wininet not to automatically handle cookies (which 'automatically' ignores custom cookie headers).
	IfInString, hbuffer, % "`r`nCookie: "
		options .= "`n+NO_COOKIES"

; Step 4: Extract the multipart envelope from the options parameter, then parse the options normally.
	If ( Multipart_Boundary != "" ) && ( pos := InStr( options, "--" Multipart_Boundary ) )
	&& ( ( 4 + StrLen( Multipart_Boundary ) ) != ( Multipart_Boundary := 4
	+ StrLen( Multipart_Boundary ) + InStr( options, "--" Multipart_Boundary "--", 0, 0 ) ) )
	{
		StringMid, Multipart_Envelope, options, pos, Multipart_Boundary - pos
		options := SubStr( options, 1, pos - 1 ) SubStr( options, Multipart_Boundary )
;		Do_Multipart := 1 ; NOT YET IMPLEMENTED
	}
	Loop, Parse, options, `n
	{
		If InStr( A_LoopField, ">" ) + 3 >> 2 = 1
		{
		; Handle the legacy output-file syntax
			Loop, Parse, A_LoopField, >, % "`t`n`r "
				If ( A_Index = 1 )
					options := ( InStr( A_LoopField, "R" ) ? "RESUME`n" : "SAVEAS`n" )
					, Do_Legacy_Dual_Output := !!InStr( A_LoopField, "N" )
				Else options .= A_LoopField
		}	
		Else IfInString, A_LoopField, :
			StringReplace, options, A_LoopField, :, `n
		Else options := A_LoopField "`n"
		Loop, Parse, options, `n, % "`t`r "
			If ( A_Index = 1 )
				StringUpper, options, A_LoopField
		; AutoProxy option: use IE's proxy configuration
			Else If ( options = "AUTOPROXY" )
				Internet_Open_Type := !!A_LoopField || A_LoopField = "" ? 0 : 1
		; Binary option: do not attempt to convert downloaded data to the script's codepage.
			Else If ( options = "BINARY" )
				Do_Binary_Down := !!A_LoopField || A_LoopField = ""
		; Callback option: inform a function in the script about the transaction progress
			Else If ( options = "CALLBACK" )
			{
				If ( pos := InStr( A_LoopField, "," ) ) || ( pos := InStr( A_LoopField, ";" ) )
				|| ( pos := InStr( A_LoopField, "`t" ) ) || ( pos := InStr( A_LoopField, " " ) )
				{
					StringLeft, Do_Callback_Func, A_LoopField, pos - 1
					StringTrimLeft, Do_Callback_3rdParam, A_LoopField, pos
					Loop, Parse, Do_Callback_3rdParam, `n, % "`t`r " ; explicit trim
						Do_Callback_3rdParam := A_LoopField
				}
				Else Do_Callback_Func := A_LoopField

				Do_Callback := IsFunc( Do_Callback_Func ) + 3 >> 2 = 1
			}
		; Charset option: convert POST text's codepage before uploading it
			Else If ( options = "CHARSET" )
				Do_NonBinary_Up := !( pos := InStr( Codepage_Charsets, "=" A_LoopField "|" ) ) ? Convert_POST_To_Codepage
				: SubStr( Codepage_Charsets, pos - 5, 5 )
		; CheckMD5 option: use the indicated URL as the proxy server for this request.
			Else If ( options = "CHECKMD5" ) || ( options = "CHECK MD5" )
				Do_Dn_MD5_Hash := 1
		; Codepage option: convert POST text's codepage before uploading it
			Else If ( options = "CODEPAGE" )
				Do_NonBinary_Up := ( A_LoopField | 0 < 1 || A_LoopField >> 16 ) ? Convert_POST_To_Codepage
				: ( Convert_POST_To_Codepage := SubStr( A_LoopField + 100000.0, 2, 5 ) )
		; Flags option: add or remove flags
			Else If InStr( options, "+" ) = 1 || InStr( options, "-" ) = 1
			{
			; When handling flag options, first determine whether the flag is being added or removed.
				StringLeft, flag_plus_or_minus, options, 1
				Loop, Parse, options, +-, % "`t`n`r _" ; explicit trim
					options := A_LoopField

			; For backwards compatibility, support the "+FLAG: <flag id>" syntax.
				If ( options = "FLAG" )
					StringUpper, options, A_LoopField

			; Determine whether the flag is a security flag or a regular flag and get its value
				If ( pos := InStr( internet_flags_list, "|" options "|" ) )
				|| ( pos := InStr( internet_flags_list, "|INTERNET_FLAG_" options "|" ) )
				{
					StringLeft, options, internet_flags_list, pos
					StringReplace, options, options, ., ., UseErrorLevel
					If ( flag_plus_or_minus = "+" )
						Internet_Flags |= 1 << ErrorLevel
					Else Internet_Flags &= ~( 1 << ErrorLevel )
				}
			; Look in the security flags for one with this name (or this short name)
				Else If ( pos := InStr( security_flags_list, "|" options "|" ) )
					|| ( pos := InStr( security_flags_list, "|SECURITY_FLAG_" options "|" ) )
				{
					StringLeft, options, security_flags_list, pos
					StringReplace, options, options, ., ., UseErrorLevel
					If ( flag_plus_or_minus = "+" )
						Security_Flags_Add |= 1 << ErrorLevel
					Else Security_Flags_Nix |= 1 << ErrorLevel
				}
			; If the first letter is an 'S', and the rest is an INT power of 2, it's a security flag
				Else If ( InStr( options, "S" ) = 1 ) && ( 0 < pos := Abs( SubStr( options, 2 ) ) )
					&& ( pos = 1 << Round( Ln( pos ) / Ln(2) ) )
				{
					If ( flag_plus_or_minus = "+" )
						Security_Flags_Add |= pos
					Else Security_Flags_Nix |= pos
				}
			; If it is an INT power of 2, treat it as an internet flag
				Else If ( 0 < pos := Abs( options ) ) && ( pos = 1 << Round( Ln( pos ) / Ln(2) ) )
					If ( flag_plus_or_minus = "+" )
						Internet_Flags |= pos
					Else Internet_Flags &= ~pos
			}
		; Method option: use a different verb when creating the request
			Else If ( options = "METHOD" ) && InStr( "|GET|HEAD|POST|PUT|DELETE|OPTIONS|TRACE|", "|" A_LoopField "|" )
				StringUpper, Method_Verb, A_LoopField
		; Proxy option: use the indicated URL as the proxy server for this request.
			Else If ( options = "PROXY" )
				Internet_Open_Type := 3, proxy_url := A_LoopField
		; Proxy Bypass option: the URL should not beaccessed through the proxy.
			Else If ( options = "PROXY BYPASS" )
				proxy_bypass .= A_LoopField "`r`n"
		; Resume OR SaveAs options: download the data to the hard drive and NOT to memory
			Else If ( options = "RESUME" ) || ( options = "SAVEAS" ) || ( options = "SAVE AS" )
			{
				file_ext := FileExist( output_file_path := A_LoopField )
				If ( file_ext = "" )
				{
				; The file does not exist, so make sure the folder it belong to DOES exist
					If !( pos := InStr( output_file_path, "\", 0, 0 ) )
					|| FileExist( SubStr( output_file_path, 1, pos - 1 ) )
						Do_Download_To_File := 1
					Else MyErrors .= "`nThe file path """ output_file_path """ is not valid. The folder can't be found."
				}
				Else If InStr( file_ext, "D" )
				{
				; The user only gave us a path to a folder. We'll have to figure out the filename from the url
					file_ext := "V://x/E/" url
					SplitPath, file_ext, file_ext
					StringLeft, file_ext, file_ext, InStr( file_ext "?", "?" ) - 1
					output_file_path .= ( SubStr( output_file_path, 0 ) = "\" ? "" : "\" )
					. ( file_ext = "" ? "HTTPRequest " A_Year "-" A_MM "-" A_DD "_" SubStr( A_Now A_MSec, 9 ) ".txt" : file_ext )
				}
				Else
				; The file exists, so the path is OK. Check if the user wants to resume a download.
					If ( options = "RESUME" )
						FileGetSize, Do_Download_Resume, % output_file_path
			}
		; Upload option: use a file on the disk as the data source for the file upload.
			Else If ( options = "UPLOAD" )
			{
				If ( pos := InStr( A_LoopField, "*", 0, 0 ) )
				{
					Upload_File_Path := SubStr( A_LoopField, 1, pos - 1 ) "`n" SubStr( A_LoopField, pos + 1 )
					Loop, Parse, Upload_File_Path, `n, % "`t`r " ; explicit trim
						If ( A_Index = 1 )
							Upload_File_Path := A_LoopField
						Else If ( 0 < 0 | A_LoopField )
							Do_File_Upload := !FileExist( Upload_File_Path ) ? 0 : 0 | 1 + A_LoopField
				}
				Else Do_File_Upload := !FileExist( Upload_File_Path := A_LoopField ) ? 0 : 1

				If ( Do_File_Upload )
				{
					FileGetsize, Content_Length, % Upload_File_Path
;					If ( Content_Length < Do_File_Upload )
;						MyErrors .= "`nThe range specified for the partial file upload is invalid: file size (" Content_Length ") is less than " Do_File_Upload - 1 "."
;					Else If ( 1 < Do_File_Upload )
				 ; NYI: append a '*' then a number to the upload file path to SKIP the first N bytes when uploading.
;						hbuffer .= "Content-Range: bytes " Do_File_Upload - 1 "-" Content_Length - 1 "/" Content_Length "`r`n"
				}
				Else MyErrors .= "`nFile upload failed: the file """ Upload_File_Path """ could not be found."
			}
	}
	StringTrimRight, proxy_bypass, proxy_bypass, 2

; Step 5: copy the POST data from the input variable to a local buffer. This is to protect the data
; from being altered or released during the upload (which may take a while). Also check whether
; the user wants to change the character encoding of text-type data (e.g: from UTF-16 to UTF-8).
; Also, even if we're uploading from a file, 'dbuffsz' must be the number of bytes in the data.
	If ( 0 < Content_Length )
	{
		If ( Do_File_Upload )
		{
		; If we're doing a file upload, do NOT copy the files contents to a buffer yet. DO make
		; sure the content-type header is present.
			VarSetCapacity( dbuffer, 4096, 0 )
			dbuffsz := Content_Length := SubStr( Content_Length + 0.0, 1, 1 + FLOOR( LOG( Content_Length )))
			hbuffer .= "Content-Length: " Content_Length "`r`n"
			IfNotInString, hbuffer, % "`r`nContent-Type: "
			{
				SplitPath, Upload_File_Path,,, file_ext
				hbuffer .= "Content-Type: " ( file_ext = "xml" ? "text/xml"
					: file_ext = "txt" ? "application/x-www-form-urlencoded"
					: "application/octet-stream" ) "`r`n"
			}
		; Add an MD5 hash to the headers if that option is used
			If ( Do_Up_MD5_Hash )
				hbuffer .= "Content-MD5: " HTTPRequest_MD5( hbuffer, Upload_File_Path ) "`r`n"
		}
		Else If !( Do_NonBinary_Up ) || ( Do_NonBinary_Up = MyACP ) || ( Do_Multipart )
		{
		; Either the POST is binary data or is already in the desired encoding, so just copy it.
			VarSetCapacity( dbuffer, dbuffsz := Content_Length, 0 )
			DllCall( "RtlMoveMemory", Ptr, &dbuffer, Ptr, &In_POST__Out_Data, "Int", Content_Length )
			Content_Length := SubStr( Content_Length + 0.0, 1, 1 + FLOOR( LOG( Content_Length )))
			hbuffer .= "Content-Length: " Content_Length "`r`n"
			IfNotInString, hbuffer, % "`r`nContent-Type: "
				hbuffer .= "Content-Type: " ( InStr( dbuffer, "<?xml" ) + 3 >> 2 = 1 ? "text/xml"
					: "application/x-www-form-urlencoded" ) "; charset=" MyCharset
		}
		Else
		{
		; Change the character encoding while copying the POST data into the local buffer.
			IfNotInString, hbuffer, % "`r`nContent-Type: "
			{
				hbuffer .= "Content-Type: " ( InStr( dbuffer, "<?xml" ) + 3 >> 2 = 1 ? "text/xml"
					: "application/x-www-form-urlencoded" )
				If ( 7 != pos := 7 + InStr( Codepage_Charsets, "|" Do_NonBinary_Up "=" ) )
					hbuffer .= "; charset=" SubStr( Codepage_Charsets, pos, InStr( Codepage_Charsets, "|", 0, pos ) - pos )
				hbuffer .= "`r`n"
			}
			If ( IsUnicode )
				pos := &In_POST__Out_Data, rbuffsz := Content_Length >> 1
			Else
			{
			; If this isn't a UTF-16 environment, convert the POST data to UTF-16. rbuffsz = bytes
				If ( 0 < rbuffsz := DllCall( "MultiByteToWideChar", "UInt", MyACP, "UInt", 0, Ptr, &In_POST__Out_Data, "Int", Content_Length, Ptr, 0, "Int", 0 ) )
				{
					VarSetCapacity( rbuffer, rbuffsz + 1 << 1, 0 )
				; MultiByteToWideChar > http://msdn.microsoft.com/en-us/library/dd319072%28v=vs.85%29.aspx
					DllCall( "MultiByteToWideChar", "UInt", MyACP, "UInt", 0, Ptr, &In_POST__Out_Data, "Int", Content_Length, Ptr, pos := &rbuffer, "Int", rbuffsz )
				}
				Else MyErrors .= "`nThere was a problem converting codepage " MyACP " to " Convert_POST_To_Codepage ". 'MultiByteToWideChar' failed: Return value = " rbuffsz ", ErrorLevel = " ErrorLevel ", A_LastError = " A_LastError
			}
		; Convert the UTF-16 string to a multi-byte string in the chosen codepage
			If ( 0 < rbuffsz ) ; a zero or negative length here indicates a prior error
				If ( 0 < dbuffsz := DllCall( "WideCharToMultiByte", "UInt", Do_NonBinary_Up, "UInt", 0, Ptr, pos, "Int", rbuffsz, Ptr, 0, "Int", 0, Ptr, 0, Ptr, 0 ) )
				{
					VarSetCapacity( dbuffer, dbuffsz + 1, 0 )
				; WideCharToMultiByte > http://msdn.microsoft.com/en-us/library/dd374130%28v=vs.85%29.aspx
					DllCall( "WideCharToMultiByte", "UInt", Do_NonBinary_Up, "UInt", 0, Ptr, pos, "Int", rbuffsz, Ptr, &dbuffer, "Int", dbuffsz, Ptr, 0, Ptr, 0 )
					Content_Length := SubStr( dbuffsz + 0.0, 1, 1 + FLOOR( LOG( dbuffsz )))
					hbuffer .= "Content-Length: " Content_Length "`r`n"
				}
				Else MyErrors .= "`nThere was a problem converting codepage " MyACP " to " Convert_POST_To_Codepage ". 'WideCharToMultiByte' failed: Return value = " dbuffsz ", ErrorLevel = " ErrorLevel ", A_LastError = " A_LastError
			VarSetCapacity( rbuffer, 0 ) ; free this temporary buffer
		; Add an MD5 hash to the headers if that option is used
			If ( Do_Up_MD5_Hash )
				hbuffer .= "Content-MD5: " HTTPRequest_MD5( dbuffer, dbuffsz ) "`r`n"
		}
	; Set up an INTERNET_BUFFERS structure in preparation for calling HttpSendRequestEx
		VarSetCapacity( INTERNET_BUFFERS, 28 + PtrSize * 3, 0 )
		NumPut( 28 + PtrSize * 3, INTERNET_BUFFERS, 0, "Int" )
		NumPut( Content_Length, INTERNET_BUFFERS, 16 + PtrSize * 3, "Int" )
	}

; Update (future): assemble multipart/form-data here by combining the text from 'options' with
; the data the user wants to upload. How it works: the text portion of the multipart data is split
; at the first instance of "<MY DATA GOES HERE>", and the data buffer is expanded to account for the
; length of the data plus the (codepage converted) lengths of the two portions. The, the first
; portion is copied or converted and placed into the front of the data buffer. The data is copied
; to the right of that, and finally, the second portion is copied or converted to the right of that.
/*
	If ( Do_Multipart )
	{
	; The multipart envelope is baked here. The text is split at "<MY DATA GOES HERE>" and the two
	; parts are converted to the desired codepage. When the upload begins, the first chunk(s) begin
	; with the first part of the envelope, and the last chunk(s) end with the second. Doing it
	; piecemeal like this is the simplest way to support disk and memory sources for the data.
	; NOTE: when doing file-uploads WITH multipart/form-data, do NOT cache the file's data, instead
	; modify the first and last chunk to begin and end with the respective parts of the envelope.
	; Store the length of the first part of the envelope in "Do_Multipart"
	; Don't forget to change the Content-Length to the real size of the eventual data.

		StringGetPos, Do_Multipart, Multipart_Envelope, <MY DATA GOES HERE>
	}
*/

; Step  6: Build the pointer array for the accept types string
; The trick to this step is actually leaving all of the accept types in one string, then building
; the pointer array using the address + position of each member, then inserting nulls to make it
; look like a collection of independent null-terminated strings.
; First thing is to replace delimiting commas with newlines (but not quoted literal commas).
	Loop, Parse, Accept_Types, "
		If ( A_Index = 1 )
			StringReplace, Accept_Types, A_LoopField, `,, `n, A
		Else If ( A_Index & 1 )
		{
			StringReplace, Accept_PtrArray, A_LoopField, `,, `n, A
			Accept_Types .= Accept_PtrArray
		}
		Else Accept_Types .= """" A_LoopField """"

; Then trim whitespace around the delimiters and count how many accept-types there are
	Loop, Parse, Accept_Types, `n, % "`t`r "
		If ( 1 = pos := A_Index )
			Accept_Types := A_LoopField
		Else Accept_Types .= "`n" A_LoopField

; Wipe the variable we'll use as the pointer array. The array itself should be null-terminated, so add an extra member.
	VarSetCapacity( Accept_PtrArray, pos * PtrSize + PtrSize, 0 )
	pos := 0
; For each member, put the address + offset into the pointer array, then end it with a null.
	Loop, Parse, Accept_Types, `n
	{
		NumPut( &Accept_Types + pos, Accept_PtrArray, A_Index * PtrSize - PtrSize, Ptr )
		pos += 1 + StrLen( A_LoopField ) << IsUnicode
		NumPut( 0, Accept_Types, pos - 1 - IsUnicode, IsUnicode ? "UShort" : "UChar" )
	}

; Set the default HTTP verb to 'POST' if there is data to upload, 'GET' otherwise.
	Method_Verb := Method_Verb != "" ? Method_Verb : 0 < Content_Length ? "POST" : "GET"
; Trim the leading CRLF from the headers buffer.
	StringTrimLeft, hbuffer, hbuffer, 2

; Do an error check before we load WinINet. If we have errors, don't continue.
; Afterwards, if we encounter errors, don't simply return but continue to the cleanup step.
	If InStr( MyErrors, "`n" )
		Return 0, In_Out_HEADERS := SubStr( MyErrors, 2 ), ErrorLevel := oel
	
; Step 7: Load WinINet.dll and initialize the internet connection and request.
; Kernel32.dll\LoadLibrary > http://msdn.microsoft.com/en-us/library/ms684175%28v=VS.85%29.aspx
	If !( hModule := DllCall( "LoadLibrary" WorA, "Str", "WinINet.dll" ) )
		MyErrors .= "`nThere was a problem loading WinINet.dll. 'LoadLibrary" WorA "' failed: Return value = " hModule ", ErrorLevel = " ErrorLevel ", A_LastError = " A_LastError

; Initialize WinINet. InternetOpen > http://msdn.microsoft.com/en-us/library/aa385096%28v=VS.85%29.aspx
	Else	If !( hInternet := Internet_Open_Type != 3 ? DllCall( "WinINet\InternetOpen" WorA, Ptr, &Agent, "UInt", Internet_Open_Type, Ptr, 0, Ptr, 0, "UInt", 0 )
	: DllCall( "WinINet\InternetOpen" WorA, Ptr, &Agent, "UInt", 3, ptr, &proxy_url, Ptr, proxy_bypass = "" ? 0 : &proxy_bypass, "UInt", 0 ) )
		MyErrors .= "`nThere was a problem initializing WinINet. 'WinINet\InternetOpen" WorA "' failed: Return value = " hInternet ", ErrorLevel = " ErrorLevel ", A_LastError = " A_LastError

; Open a HTTP session. InternetConnect > http://msdn.microsoft.com/en-us/library/aa384363%28v=VS.85%29.aspx
; dwService -> INTERNET_SERVICE_HTTP = 3
	Else If !( hConnection := DllCall( "WinINet\InternetConnect" WorA, Ptr, hInternet, Ptr, &Host, "UInt", Port, Ptr, &User, Ptr, &Pass, "UInt", 3, "UInt", Internet_Flags, "UInt", 0 ) )
		MyErrors .= "`nThere was a problem opening a HTTP session. 'WinINet\InternetConnect" WorA "' failed: Return value = " hConnection ", ErrorLevel = " ErrorLevel ", A_LastError = " A_LastError

; Create a HTTP request. HttpOpenRequest > http://msdn.microsoft.com/en-us/library/aa384233%28v=VS.85%29.aspx
	Else If !( hRequest := DllCall( "WinINet\HttpOpenRequest" WorA, Ptr, hConnection, Ptr, &Method_Verb, Ptr, &URL, "Str", "HTTP/1.1", Ptr, 0, Ptr, &Accept_PtrArray, "UInt", Internet_Flags ) )
		MyErrors .= "`nThere was a problem creating a HTTP request. 'WinINet\HttpOpenRequest" WorA "' failed: Return value = " hRequest ", ErrorLevel = " ErrorLevel ", A_LastError = " A_LastError

; Add headers. HttpAddRequestHeaders > http://msdn.microsoft.com/en-us/library/aa384227%28v=VS.85%29.aspx
; dwModifiers = (HTTP_ADDREQ_FLAG_ADD = 0x20000000) + (HTTP_ADDREQ_FLAG_REPLACE = 0x80000000)
	Else If ( hbuffer != "" ) && !DllCall( "WinINet\HttpAddRequestHeaders" WorA, Ptr, hRequest, Ptr, &hbuffer, "UInt", StrLen( hbuffer ), "UInt", 0xA0000000 )
		MyErrors .= "`nThere was a problem adding one or more headers to the request. 'WinINet\HttpAddRequestHeaders" WorA "' failed: ErrorLevel = " ErrorLevel ", A_LastError = " A_LastError "`nHeaders: `n" hbuffer

; Update (12-28-2011): Added security flags support. Security flags may be added/removed like normal flags
; InternetQueryOption > http://msdn.microsoft.com/en-us/library/aa385101%28v=VS.85%29.aspx
	Else If ( Security_Flags_Add || Security_Flags_Nix ) && !DllCall( "WinINet\InternetQueryOption" WorA, Ptr, hRequest, "UInt", 31, "UInt*", Security_Flags, "UInt*", 4 )
		MyErrors .= "`nThere was a problem retrieving the security flags. 'WinINet\InternetQueryOption" WorA "' failed: ErrorLevel = " ErrorLevel ", A_LastError = " A_LastError

; InternetSetOption > http://msdn.microsoft.com/en-us/library/aa385114%28v=VS.85%29.aspx
	Else If ( Security_Flags_Add || Security_Flags_Nix ) && !DllCall( "WinINet\InternetSetOption" WorA, Ptr, hRequest, "UInt", 31, "UInt*", pos := ( ~Security_Flags_Nix & Security_Flags ) | Security_Flags_Add, "UInt*", 4 )
		MyErrors .= "`nThere was a problem setting the security flags. 'WinINet\InternetSetOption" WorA "' failed: Flags value = " pos ", ErrorLevel = " ErrorLevel ", A_LastError = " A_LastError

; Step 8a: If there is no data to upload, submit the request via HttpSendRequest.
; HttpSendRequest > http://msdn.microsoft.com/en-us/library/aa384247%28v=VS.85%29.aspx
	Else If !( 0 < Content_Length ) && !DllCall( "WinINet\HttpSendRequest" WorA, Ptr, hRequest, Ptr, 0, "UInt", 0, Ptr, 0, "UInt", 0 )
		MyErrors .= "`nThere was a problem sending the " Method_Verb " request. 'WinINet\HttpSendRequest" WorA "' failed: ErrorLevel = " ErrorLevel ", A_LastError = " A_LastError

; Step 8b: If there is data to upload, begin submitting the request via HttpSendRequestEx, upload the data
; using InternetWriteFile, then end the request with HttpEndRequest.
; HttpSendRequestEx > http://msdn.microsoft.com/en-us/library/aa384318%28v=VS.85%29.aspx
	Else If ( 0 < Content_Length ) && !DllCall( "WinINet\HttpSendRequestEx" WorA, Ptr, hRequest, Ptr, &INTERNET_BUFFERS, "UInt", 0, Ptr, 0, "UInt", 0 )
		MyErrors .= "`nThere was a problem sending the " Method_Verb " request. 'WinINet\HttpSendRequestEx" WorA "' failed: ErrorLevel = " ErrorLevel ", A_LastError = " A_LastError
	Else If ( 0 < Content_Length )
	{
	; Here, we have a connection open to a remote resource and we should write data to it.
	; But first, notfy the callback function that we are about to upload data by passing '-1' to it.
		If ( Do_Callback ) && ( "CANCEL" = %Do_Callback_Func%( -1, Content_Length, Do_Callback_3rdParam ) )
			MyErrors .= "`nThe callback function: """ Do_Callback_Func """ returned 'CANCEL' to cancel the transaction. Zero bytes were uploaded."
	; Then, if we're uploading from a file, open the file with GENERIC_READ permission (0x80000000)
		Else	If ( Do_File_Upload ) && !( Do_File_Upload := DllCall( "CreateFile" WorA, Ptr, &Upload_File_Path, "UInt", 0x80000000, "UInt", 0, Ptr, 0, "UInt", 4, "UInt", 0, Ptr, 0 ) )
			MyErrors .= "`nThere was a problem opening the file to upload """ Upload_File_Path """. 'CreateFile" WorA "' failed: ErrorLevel = " ErrorLevel ", A_LastError = " A_LastError
		Else
		{
		; Loop until the size of the data uploaded is equal or greater than the Content-Length.
		; Actually, 'equal to' is the end condition, the 'greater than' is just good programming.
			size := 0 ; 'size' tracks the number of bytes actually uploaded so far.
			Loop
				If ( Content_Length <= size )
					Break
				Else IfInString, MyErrors, `n
					Break
				Else
				{
				; Define the first data chunk of up to 4096 bytes (put the address into 'pos')
				; NOTE: except with multipart data, 'dbuffsz' and 'Content-Length' are equal.
					If ( size < Do_Multipart )
					{
						; Upload the first part of the multipart envelope.
						pos := &rbuffer
						dtsz := Do_Multipart - size < 4096 ? Do_Multipart - size : 4096
					}
					Else If ( Do_Multipart + dbuffsz <= size )
					{
						; Upload the second part of the multipart envelope.
						pos := &rbuffer + Do_Multipart
						dtsz := Content_Length - size < 4096 ? Content_Length - size : 4096
					}
					; ReadFile > http://msdn.microsoft.com/en-us/library/aa365467%28v=VS.85%29.aspx
					Else If ( Do_File_Upload ) && !DllCall( "ReadFile", Ptr, Do_File_Upload, Ptr, pos := &dbuffer, "UInt", dbuffsz - size < 4096 ? dbuffsz - size : 4096, "Int*", dtsz, Ptr, 0 )
					{
						; Upload from a file AND we couldn't read from the file
						MyErrors .= "`nThere was a problem reading from the file """ Upload_File_Path """. 'ReadFile' failed: ErrorLevel = " ErrorLevel ", A_LastError = " A_LastError
						Break
					}
					Else
					{
						; Upload from memory
						pos := &dbuffer + size
						dtsz := dbuffsz - size < 4096 ? dbuffsz - size : 4096
					}

				; Upload the chunk, and then increment 'size' by how many bytes were uploaded.
				; InternetWriteFile > http://msdn.microsoft.com/en-us/library/aa385128%28v=VS.85%29.aspx
					If !DllCall( "WinINet\InternetWriteFile", Ptr, hRequest, Ptr, pos, "UInt", dtsz + 0, "Int*", dtsz )
						MyErrors .= "`nThere was a problem uploading the POST data. 'WinINet\InternetWriteFile' failed: ErrorLevel = " ErrorLevel ", A_LastError = " A_LastError
					Else
					{
						size += dtsz
	
					; If we have a callback function, tell it what percent has been uploaded
						If ( Do_Callback ) && ( "CANCEL" = %Do_Callback_Func%( size / Content_Length - 1, Content_Length, Do_Callback_3rdParam ) )
							MyErrors .= "`nThe callback function: """ Do_Callback_Func """ returned 'CANCEL' to cancel the transaction. " size " bytes were uploaded."
					}
				}
		; Close the file handle (if the data was uploaded from a file).
		; CloseHandle > http://msdn.microsoft.com/en-us/library/ms724211%28v=vs.85%29.aspx
			If ( Do_File_Upload ) && !DllCall( "CloseHandle", Ptr, Do_File_Upload )
				MyErrors .= "`nThere was a problem closing the file """ Upload_File_Path """. 'CloseHandle' failed: ErrorLevel = " ErrorLevel ", A_LastError = " A_LastError
		}
		; We're done uploading data, so end the request.
		; HttpEndRequest > http://msdn.microsoft.com/en-us/library/aa384230%28v=VS.85%29.aspx
		DllCall( "WinINet\HttpEndRequest" WorA, Ptr, hRequest, Ptr, 0, "UInt", 0, Ptr, 0 )
	}

; Step 9: Wait until data is available, then get the response headers.
	Content_Length := size := rbuffsz := 0
	If InStr( MyErrors, "`n" )
		hbuffer := ""
	Else
	{
		; InternetQueryDataAvailable > http://msdn.microsoft.com/en-us/library/aa385100%28v=VS.85%29.aspx
		DllCall( "WinINet\InternetQueryDataAvailable", Ptr, hRequest, "Int*", Content_Length, "UInt", 0, Ptr, 0 )

		; Get the response headers separated by CRLF. The first line has the HTTP response code
		; HttpQueryInfo > http://msdn.microsoft.com/en-us/library/aa384238%28v=VS.85%29.aspx
		; HTTP_QUERY_RAW_HEADERS_CRLF = 22. First-try buffer size = 4K
		If VarSetCapacity( hbuffer, hbuffsz := 4096, 0 )
		&& !DllCall( "WinINet\HttpQueryInfo" WorA, Ptr, hRequest, "UInt", 22, Ptr, &hbuffer, "Int*", hbuffsz, Ptr, 0 )
		&& VarSetCapacity( hbuffer, hbuffsz, 0 )
		&& !DllCall( "WinINet\HttpQueryInfo" WorA, Ptr, hRequest, "UInt", 22, Ptr, &hbuffer, "Int*", hbuffsz, Ptr, 0 )
			MyErrors .= "`nThere was a problem reading the response headers. 'WinINet\HttpQueryInfo" WorA "' failed: ErrorLevel = " ErrorLevel ", A_LastError = " A_LastError
		Else
		{
			; We've got the response headers, but don't copy them to the output var yet.
			; Replace CRLF with LF, get the response code, and see if there's a Content-Length.
			VarSetCapacity( hbuffer, -1 )
			StringReplace, hbuffer, hbuffer, `r`n, `n, A
			StringMid, Response_Code, hbuffer, InStr( hbuffer, " " ) + 1, 3
			If ( 17 != pos := 17 + InStr( hbuffer, "`nContent-Length: " ) )
				StringMid, Content_Length, hbuffer, pos, InStr( hbuffer, "`n", 0, pos ) - pos
		}
	}

; Step 10: Download the response data
	If ( Content_Length ) && !InStr( MyErrors, "`n" )
	{
	; If we're downloading to a file, try to open the target file with GENERIC_WRITE (0x40000000) permission.
	; CreateFile > http://msdn.microsoft.com/en-us/library/aa363858%28v=vs.85%29.aspx
		If ( Do_Download_To_File ) && !( Do_Download_To_File := DllCall( "CreateFile" WorA, Ptr, &output_file_path, "UInt", 0x40000000, "UInt", 0, Ptr, 0, "UInt", 4, "UInt", 0, Ptr, 0 ) )
			MyErrors .= "`nThere was a problem opening/creating the output file for writing data: """ output_file_path """. 'CreateFile" WorA "' failed: ErrorLevel = " ErrorLevel ", A_LastError = " A_LastError
	; Then, if we're resuming a download, move the write-pointer to the end of the file.
	; SetFilePointerEx > http://msdn.microsoft.com/en-us/library/aa365542%28v=VS.85%29.aspx
		Else If ( Do_Download_Resume ) && !DllCall( "SetFilePointerEx", Ptr, Do_Download_To_File, "Int64", Do_Download_Resume, Ptr, 0, "UInt", 0 )
			MyErrors .= "`nThere was a problem seeking to the end of the output file for resuming the download. 'SetFilePointerEx' failed: ErrorLevel = " ErrorLevel ", A_LastError = " A_LastError
	; If we have a callback function, inform it that we're about to begin downloading data.
		Else If ( Do_Callback ) && ( "CANCEL" = %Do_Callback_Func%( Do_Download_Resume, Content_Length + Do_Download_Resume, Do_Callback_3rdParam ) )
			MyErrors .= "`nThe callback function: """ Do_Callback_Func """ returned 'CANCEL' to cancel the transaction. Zero bytes were downloaded."
		Else
		{
		; Download the response data. Initialize the d-buffer to hold the reported content length plus 4K
			VarSetCapacity( dbuffer, dbuffsz := Do_Download_To_File ? 4096 : 4096 + Content_Length, 0 )
			Loop
				IfInString, MyErrors, `n
					Break
				Else
				{
; Update (1-8-2012): the data downloading loop no longer uses dynamic variables. Instead, if the d-buffer is
; too small, make space in the r-buffer to hold 4K plus the data in the d-buffer and download to the end of the
; r-buffer. If data was downloaded, copy the data from the d-buffer to the r-buffer, expand the d-buffer, and
; copy all of the data (old + new) back to the d-buffer. If ever InternetReadFile fails, or downloads zero
; bytes, that means we're done.

					If ( Do_Download_To_File )
						pos := &dbuffer
					Else If ( size + 4096 < Content_Length )
						pos := &dbuffer + size
					Else
					{
						VarSetCapacity( rbuffer, rbuffsz := size + 4096 + 1, 0 )
						pos := &rbuffer + size
					}

				; Now that the target buffer has been determined, download the next chunk.
				; InternetReadFile > http://msdn.microsoft.com/en-us/library/aa385103%28v=VS.85%29.aspx
					If !DllCall( "WinINet\InternetReadFile", Ptr, hRequest, Ptr, pos, "UInt", 4096, "Int*", dtsz )
						MyErrors .= "`nThere was a problem downoading data. 'WinINet\InternetReadFile' failed: ErrorLevel = " ErrorLevel ", A_LastError = " A_LastError
					Else If !dtsz
					{
						If ( Do_Callback )
							%Do_Callback_Func%( 1, Content_Length + Do_Download_Resume, Do_Callback_3rdParam )
						Break
					}
				; WriteFile > http://msdn.microsoft.com/en-us/library/aa365747%28v=vs.85%29.aspx
					Else If ( Do_Download_To_File ) && !DllCall( "WriteFile", Ptr, Do_Download_To_File, Ptr, pos, "UInt", dtsz, "Int*", 0, Ptr, 0 )
						MyErrors .= "`nThere was a problem writing data to the disk. 'WriteFile' failed: ErrorLevel = " ErrorLevel ", A_LastError = " A_LastError
					Else If !( Do_Download_To_File ) && ( size < rbuffsz )
					{
						DllCall( "RtlMoveMemory", Ptr, &rbuffer, Ptr, &dbuffer, "Int", size )
						VarSetCapacity( dbuffer, Content_Length := 4096 + ( size += dtsz ), 0 )
						DllCall( "RtlMoveMemory", Ptr, &dbuffer, Ptr, &rbuffer, "Int", size )
						rbuffsz := 0
					}
					Else size += dtsz

					If ( Do_Callback ) && ( "CANCEL" = %Do_Callback_Func%( ( size + Do_Download_Resume ) / ( Content_Length + Do_Download_Resume ), Content_Length + Do_Download_Resume, Do_Callback_3rdParam ) )
						MyErrors .= "`nThe callback function: """ Do_Callback_Func """ returned 'CANCEL' to cancel the transaction. " size " bytes were uploaded."
				}
			If ( Do_Download_To_File )
			{
				If ( Do_Legacy_Dual_Output )
				{
					VarSetCapacity( dbuffer, size + 1, 0 )
					If !DllCall( "ReadFile", Ptr, Do_Download_To_File, Ptr, &dbuffer, "UInt", size, Ptr, 0, Ptr, 0 )
						MyErrors .= "`nThere was a problem reading the file """ output_file_path """. 'ReadFile' failed: ErrorLevel = " ErrorLevel ", A_LastError = " A_LastError

				}
				If !DllCall( "CloseHandle", Ptr, Do_Download_To_File )
					MyErrors .= "`nThere was a problem closing the file """ output_file_path """. 'CloseHandle' failed: ErrorLevel = " ErrorLevel ", A_LastError = " A_LastError
			}
		}
	}

; Step 11: Close handles, free the dll, and add the MD5 hash check if called for.
; InternetCloseHandle > http://msdn.microsoft.com/en-us/library/aa384350%28v=VS.85%29.aspx
	DllCall( "WinINet\InternetCloseHandle", Ptr, hRequest )
	DllCall( "WinINet\InternetCloseHandle", Ptr, hConnection )
	DllCall( "WinINet\InternetCloseHandle", Ptr, hInternet )
	DllCall( "FreeLibrary", Ptr, hModule )

	If ( Do_Dn_MD5_Hash ) && InStr( hbuffer, "`nContent-MD5: " )
		If ( Do_Download_To_File )
			hbuffer .= "`nComputed-MD5: " HTTPRequest_MD5( rbuffer, output_file_path )
		Else hbuffer .= "`nComputed-MD5: " HTTPRequest_MD5( dbuffer, size )

; Step 12: Copy the response data and headers into the output buffers, respecting the pertinent options.
	If ( size ) && ( !( Do_Download_To_File ) || ( Do_Legacy_Dual_Output ) )
	{
	; First, detect the content type to see whether we CAN treat it like text.
		If ( 15 != pos := 15 + InStr( hbuffer, "`nContent-Type: " ) )
			StringMid, Content_Type, hbuffer, pos, InStr( hbuffer "`n", "`n", 0, pos ) - pos
		Else Content_Type := "text/plain; charset=" MyCharset

	; Extract the charset information, if it's present
		If ( 7 != pos := 7 + InStr( Content_Type, "charset=" ) )
		&& ( pos := InStr( Codepage_Charsets, SubStr( Content_Type, pos
			, InStr( Content_Type ";" , ";", 0, pos ) - pos ) "|" ) )
			StringMid, Convert_POST_To_Codepage, Codepage_Charsets, pos - 5, 5
		Else Convert_POST_To_Codepage := IsUnicode ? "65001" : MyACP

	; Then, determine whether we should convert the data to a different codepage or not.
		StringLeft, Content_Type, Content_Type, InStr( Content_Type ";", ";" ) - 1
		If !( pos := InStr( Content_Type, "text/" ) = 1 )
			Loop, Parse, Text_Content_Subtypes, /
				If ( pos |= 0 < InStr( Content_Type, "/" A_LoopField ) )
					Break

	; So, now we know whether or not to treat the data as text, or as binary
		If ( Do_Binary_Down ) || !( pos ) || ( Convert_POST_To_Codepage = MyACP )
		{
			VarSetCapacity( In_POST__Out_Data, size + 2, 0 )
			DllCall( "RtlMoveMemory", Ptr, &In_POST__Out_Data, Ptr, &dbuffer, "Int", size )
			If ( pos )
				VarSetCapacity( In_POST__Out_Data, -1 )
		}
		Else
		{
		; convert the text data's codepage to whatever codepage the script is using.
			If ( Convert_POST_To_Codepage = "01200" )
			{
			; the downloaded data is in UTF-16 already (I don't know if this ever happens IRL).
				pos := &dbuffer
				rbuffsz := size >> 1
			}
			Else If ( 0 < rbuffsz := DllCall( "MultiByteToWideChar", "UInt", Convert_POST_To_Codepage, "UInt", 0, Ptr, &dbuffer, "Int", size, Ptr, 0, "Int", 0 ) )
			{
				VarSetCapacity( rbuffer, rbuffsz + 1 << 1 )
				DllCall( "MultiByteToWideChar", "UInt", Convert_POST_To_Codepage, "UInt", 0, Ptr, &dbuffer, "Int", size, Ptr, pos := &rbuffer, "Int", rbuffsz )
			}
			Else MyErrors .= "`nThere was a problem converting codepage " Convert_POST_To_Codepage " to " MyACP ". 'MultiByteToWideChar' failed: Return value = " rbuffsz ", ErrorLevel = " ErrorLevel ", A_LastError = " A_LastError

			If ( IsUnicode )
			{
				VarSetCapacity( In_POST__Out_Data, rbuffsz + 1 << 1, 0 )
				DllCall( "RtlMoveMemory", Ptr, &In_POST__Out_Data, Ptr, &rbuffer, "Int", rbuffsz << 1 )
				VarSetCapacity( In_POST__Out_Data, -1 )
			}
			Else If ( 0 < rbuffsz ) && ( 0 < dbuffsz := DllCall( "WideCharToMultiByte", "UInt", MyACP, "UInt", 0, Ptr, pos, "Int", rbuffsz, Ptr, 0, "Int", 0, Ptr, 0, Ptr, 0 ) )
			{
				VarSetCapacity( In_POST__Out_Data, dbuffsz + 1, 0 )
				DllCall( "WideCharToMultiByte", "UInt", MyACP, "UInt", 0, Ptr, pos, "Int", rbuffsz, Ptr, &In_POST__Out_Data, "Int", dbuffsz, Ptr, 0, Ptr, 0 )
				size := dbuffsz
				VarSetCapacity( In_POST__Out_Data, -1 )
			}
			Else MyErrors .= "`nThere was a problem converting codepage " Convert_POST_To_Codepage " to " MyACP ". 'WideCharToMultiByte' failed: Return value = " dbuffsz ", ErrorLevel = " ErrorLevel ", A_LastError = " A_LastError
		}
	}
	; If there was no data downloaded, AND there were no errors so far, clear the data output var.
	Else
		In_POST__Out_Data := ""

	In_Out_HEADERS := SubStr( hbuffer, 1, -1 ) . SubStr( MyErrors, 1 + ( hbuffer = "" ) )
	Return size, dbuffer := "", hbuffer := "", rbuffer := "", ErrorLevel := Response_Code
} ; HTTPRequest( URL, byref In_POST__Out_Data="", byref In_Out_HEADERS="", Options="" ) -----------------------


HTTPRequest_MD5( byref data, length=-1 ) { ; ------------------------------------------------------------------
; Computes the MD5 hash of a data blob of length 'length'. If 'length' is less than zero, this function assumes
; that 'data' is a null-terminated string and determines the length automatically. If length is the path to a
; file, this function returns the  Static variables and constants r[0~63], encoded here as bytes with an offset
; of 64 ( that means the real value is the byte value minus 64, e.g: r[0] = 7, so 7 + 64 = 71 = 'G' )
	Static s, k, pty, u, p:=0, r := "GLQVGLQVGLQVGLQVEINTEINTEINTEINTDKPWDKPWDKPWDKPWFJOUFJOUFJOUFJOU"
	; Initialize the block buffer S and constants p and k[0~63]
	If !( p )
	{
		VarSetCapacity( k, 256 )
		VarSetCapacity( S, 64, 0 )
		u := !!A_IsUnicode
		pty := A_PtrSize = "" ? "UInt" : "Ptr"
		Loop, 64
			NumPut( i := Floor(Abs(Sin(A_Index)) * 0x100000000 ), k, A_Index - 1 << 2, "UInt" )
	}

	If length IS NOT NUMBER
		IfExist, % length ; use file-MD5 mode.
		{
			hFile := DllCall( "CreateFile" ( u ? "W" : "A" ), "Str", length
				, "UInt", 0x80000000 ; GENERIC_READ = 0x80000000
 				, "UInt", 0, pty, 0
				, "UInt", 4 ; OPEN_ALWAYS = 4
				, "UInt", 0, pty, 0 )
			VarSetCapacity( l, 8 )
			DllCall( "GetFileSizeEx", pty, hFile, pty, &l )
			length := NumGet( l, 0, "Int64" )
		}

	; autodetect message length if it's not specified (or is not positive)
	If Round( length ) < 1
		length := StrLen( dat ) << u

	; initialize running accumulators
	ha := 0x67452301, hb := 0xEFCDAB89, hc := 0x98BADCFE, hd := 0x10325476

	; Begin rolling the message. This loop does 1 iteration for each 64 byte block such that the
	; last block has fewer than 55 bytes in it ( to leave room for the terminator and data length )
	Loop % length + 72 >> 6
	{
		If ( f := length - 64 > ( e := A_Index - 1 << 6 ) ? 64 : length > e ? length - e : 0 )
			If ( hFile )
				DllCall( "ReadFile", pty, hFile, pty, &s, "UInt", f, pty, &l, pty, 0 )
			Else DllCall( "RtlMoveMemory", pty, &s, pty, &data + e, "UInt", f ) ; copy the block
		If ( f != 64 && e <= length ) ; append the terminator to the message
			NumPut( 128, s, f, "UChar" )
		If ( f < 56 )
			Loop 8 ; if this is the real last block, insert the data length in BITS
				NumPut( ( ( length << 3 ) >> ( A_Index - 1 << 3 ) ) & 255, s, 55 + A_Index, "UChar" )

		a := ha, b := hb, c := hc, d := hd ; copy running accumulators to intermediate variables

		Loop 64 ; begin rolling the block. These operations have been condensed and obfuscated.
		{
			e := NumGet( r, ( i := A_Index - 1 ) << u, "UChar" ) & 31
			f := 0 = ( j := i >> 4 ) ? (b&c)|(~b&d) : j=1 ? (d&b)|(~d&c) : j=2 ? b^c^d : c^(~d|b)
			g := &s + (( i * ( 3817 >> j * 3 & 7 ) + ( 328 >> j * 3 & 7 ) & 15 ) << 2 )
			w := (*(g+3) << 24 | *(g+2) << 16 | *(g+1) << 8 | *g) + a + f + NumGet(k,i<<2,"UInt")
			a := d, d := c, c := b, b += w << e | (( w & 0xFFFFFFFF ) >> ( 32 - e ))

		}
		; add the intermediate variables to the running accumlators (making sure to mod by 2**32)
		ha := ha+a&0xFFFFFFFF, hb := hb+b&0xFFFFFFFF, hc := hc+c&0xFFFFFFFF, hd := hd+d&0xFFFFFFFF
		VarSetCapacity( S, 64, 0 ) ; zero the block
	}
	If ( hFile )
		DllCall( "CloseHandle", pty, hFile )
	Loop 32 ; convert the running accumulators into 32 hex digits
		g:=1&(i:=A_Index-1), e:=Chr(97+(i>>3))
		, f:=15&(h%e%>>((!g-g+i&7)<<2)), s.=Chr(48+f+39*(9<f))
	s .= "0000"
	Loop 6
		Loop, % 4+0*(g := Abs("0x" SubStr( s,A_Index*6-5,6)))
			i:=(g>>6*(4-A_Index))&63, s.=i=63 ? "/" : i=62 ? "+" : Chr(i<26 ? i+65 : i<52 ? i+71 : i-4)
	Return SubStr( s, 37, 22 ) "==" ; return the base 64 encoded MD5 hash.
} ; HTTPRequest_MD5( byref data, length=-1 ) ------------------------------------------------------------------
