/*
################################################################################################################
###                                  CloudStorage_SugarSync  V3.0  by [art]                                  ###
###                          http://www.autohotkey.com/forum/viewtopic.php?t=84324                           ###
################################################################################################################

About:
======
CloudStorage_SugarSync - A function to communicate with SugarSync.com Cloud Storage.
Tested compatible with AHK v1.0.48.05 and AHK_L v1.1.03.00 (x86 Unicode).


Requirements:
=============
- You have to #include Function "HTTPRequest" V2.47+ by [VxE] Special Thanks!   http://www.autohotkey.com/forum/viewtopic.php?t=73040
- You have to call CloudStorage_SugarSync "Init" prior to other function calls.


Setup:   (optional - Recommended)
=================================
F_ARRAY("ResponseFunction","MyResponseFunctionName")
	Tells CloudStorage_SugarSync to pass info about actions currently executed to "MyResponseFunctionName" function.
	- For "MyResponseFunctionName" to also receive the data transfer info, DO NOT set HTTPRequest option "Callback:".
	- CloudStorage_SugarSync is calling "MyResponseFunctionName" with only the parameters that are changed.
	  That is, if only a SubAction parameter received it belongs to the last received Action parameter
	  and if only a Progress parameter received it belongs to the last received SubAction parameter.
	SYNTAX: MyResponseFunctionName(Progress="", SubAction="", Action="", Error="").
	Action:		Indicates the ParentAction (Init, Upload, Download) currently executed.
	SubAction:	Indicates the SubAction of the ParentAction (Connecting, Going to file, Downloading,...) currently executed.
	Progress:	Indicates the progress of the SubAction (File Found, Uploading 10% of 200 bytes, File Uploaded,...) or an error.
	Error:		Indicates an error that stops the current Action.
			In this case, Progress receives the error info (Folder NOT Found, New File NOT Created!)
			and Error receives the HTTP response header.


Syntax:
=======
----- INIT  (call this prior to other function calls)
CloudStorage_SugarSync( "Init", UserName, PassWord, AccessKey, PrivateAccessKey, Options)
	* UserName and PassWord of your SugarSync account. (Create a free account at https://www.sugarsync.com/signup?startsub=5)
	* AccessKey and PrivateAccessKey can be found at https://www.sugarsync.com/developer/login
	* Options (optional) A newline delimited list of keywords that modify how HTTPRequest function works
	  (see func "HTTPRequest" syntax at http://www.autohotkey.com/forum/topic73040.html)


----- DOWNLOAD
CloudStorage_SugarSync("Download", ServerFilePath, LocalFilePath)
	* ServerFilePath is the path to the file on server. It is Relative to 'magic Briefcase' folder (path separator= /)
		ex: AHK/New Functions/SugarSync test.ahk	(folder "AHK" is under the 'magic Briefcase' folder)
	* LocalFilePath is the full path of a file in your hard disk to save the downloaded data.
		Warning: If LocalFilePath already exists, it will be replaced (overwrite).


----- UPLOAD
CloudStorage_SugarSync("Upload", LocalFilePath, ServerFilePath)
	LocalFilePath is the full path of a file in your hard disk you want to upload.
	ServerFilePath is the path to the file on server after uploaded. It is Relative to 'magic Briefcase' folder (path separator= /)
		ex: AHK/New Functions/SugarSync test.ahk	(folder "AHK" is under the 'magic Briefcase' folder)
		If ServerFilePath not exist on server it will be created (folders and file under 'magic Briefcase' folder).
		If a file with same name already exists on server, the new file will be saved as new version.
		(SugarSync maintains the last 5 versions of your files - access the old files by selecting 'Versions' menu item)


Notes:
======
- No Global VARs are created by the functions. Common Variables between functions been handled by F_ARRAY() function.
- Function returns '1' if there was a problem or '0' otherwise.


Example:
========
#Include CloudStorage_SugarSync.ahk
#Include HTTPRequest.ahk

SplitPath, A_ScriptFullPath,, Drive_Path_No_Backslash

UserName         = <your username@your email>	; < Create a free account at https://www.sugarsync.com/signup?startsub=5
PassWord         = <your password>		;   Web Login to your account at https://www.sugarsync.com/login
AccessKey	 = <your AccessKey>		; < Get it from: https://www.sugarsync.com/developer/login
PrivateAccessKey = <your PrivateAccessKey>	; < Get it from: https://www.sugarsync.com/developer/login
Options		 = AutoProxy			; < 'HTTPRequest' function options

U_LocalFilePath		:= Drive_Path_No_Backslash . "\Test.txt"
U_ServerFilePath	:= "AHK/NEW test/This is NEW/Test.txt"
D_ServerFilePath	:= U_ServerFilePath
D_LocalFilePath		:= Drive_Path_No_Backslash . "\Test_DOWNLOADED.txt"

F_ARRAY("ResponseFunction","CloudStorage_SugarSync#Response")	; see 'SETUP'

; INIT
i := CloudStorage_SugarSync("Init", UserName, PassWord, AccessKey, PrivateAccessKey, Options )
IfEqual, i, 1, MsgBox, 4112, Cloud Storage - SugarSync, ERROR Function Returns 1

; UPLOAD
i := CloudStorage_SugarSync("Upload", U_LocalFilePath, U_ServerFilePath)
IfEqual, i, 1, MsgBox, 4112, Cloud Storage - SugarSync, ERROR Function Returns 1

; DOWNLOAD
i := CloudStorage_SugarSync("Download", D_ServerFilePath, D_LocalFilePath)
IfEqual, i, 1, MsgBox, 4112, Cloud Storage - SugarSync, ERROR Function Returns 1

MsgBox, This is the END!`n`nFiles`t"%U_LocalFilePath%"`nand`t"%D_LocalFilePath%"`nmust be identical!`n`nPress OK to EXIT.
ExitApp

;================================================================================
CloudStorage_SugarSync#Response(Progress="", SubAction="", Action="", Error="") {
	STATIC GuiID, old, lastProgress
	IF (GuiID="")
		{
		Loop, 99 {	; Find 1st Free Gui Number after 1.
			Gui, %A_Index%:+LastFoundExist
			IfEqual, A_Index, % (GuiID := (!WinExist() && (A_Index!=1)) ? A_Index : ""), Break
		}
		old := "*****   Welcome  " F_ARRAY("#UserName") "   *****"
		Gui, %GuiID%:+Resize +LabelSugarSyncResponseGui_
		Gui, %GuiID%:Margin, 5, 5
		Gui, %GuiID%:Add, Edit, R15 W600 ReadOnly WantTab t10 t140 +HScroll +VScroll , %old%
		Gui, %GuiID%:Show, AUTOSIZE CENTER, Cloud Storage - SugarSync
		}
	old := (Action="") && (SubAction="") ? old : old lastProgress
	old := old (Action ? "`n`n" Action : "") (SubAction ? "`n`t- " SubAction : "")
	lastProgress := Progress ? "`t" Progress : ""
	GuiControl,%GuiID%:, Edit1, % old lastProgress (Error ? "`n`n------------------------------`n" Error "`n------------------------------" : "")
	If Error
		{
		MsgBox, Fatal Error! Application will Exit.
		ExitApp
		}
	;sleep,500	; Enable this to slowdown the proccess in order to see all info received.
}
*/
CloudStorage_SugarSync(Action, c1="", c2="", c3="", c4="", $Options="") {
	STATIC #Version:="3.0"
	STATIC quote, #magicBriefcase, #Header, #Options, #CloudStorage_SugarSync#Response

	IF (Action="Init")
		{
		quote:=Chr(34)
		; Checking options and initialize helper functions
		z:=F_ARRAY("ResponseFunction")
		If !ErrorLevel ; found
			#CloudStorage_SugarSync#Response := IsFunc(z) ? z : ""
		#Options := #CloudStorage_SugarSync#Response AND !InStr($Options,"Callback:") ? $Options "`nCallback: CloudStorage_SugarSync#Progress" : $Options
		StringReplace, #Options, #Options, `n`n, `n, ALL
		F_ARRAY("#Options",#Options) ; SETUP
		F_ARRAY("#UserName",c1) ; SETUP
		; GET Authorization ID and Create default Header
		$Post	= 
			( LTrim
			<?xml version="1.0" encoding="UTF-8" ?>
			<authRequest>
			 <username>%c1%</username>
			 <password>%c2%</password>
			 <accessKeyId>%c3%</accessKeyId>
			 <privateAccessKey>%c4%</privateAccessKey>
			</authRequest>
			)
		#Header	=
			( LTrim
			User-Agent: AHK CloudStorage_SugarSync [Art]/%#Version%
			Host: api.sugarsync.com
			Content-Type: application/xml; charset=UTF-8
			)
		%#CloudStorage_SugarSync#Response%("", "", "REGISTERING [" c1 "] to SugarSync.com Server:")
		%#CloudStorage_SugarSync#Response%("", "Connecting to the server...")
		HTTPRequest( "https://api.sugarsync.com/authorization", $Post, $Header:=#Header, "Method: POST`n" #Options )
		#User  := CloudStorage_SugarSync#StringMid($Post, "<user>https://api.sugarsync.com/user/", "</user>")
		#Auth  := CloudStorage_SugarSync#StringMid($Header, "Location: ", "`n")
		#Header:= "Authorization: " #Auth "`n" #Header
		F_ARRAY("#Header",#Header) ; SETUP
		z:=((#User="") OR (#Auth="") OR !InStr($Header, "201 Created")) ? %#CloudStorage_SugarSync#Response%("ERROR","","", $Header) ($Return:=1)
		: %#CloudStorage_SugarSync#Response%("User ID and Authorization received.")
		IfEqual, $Return, 1, Return 1
		; GET 'magicBriefcase' link id
		%#CloudStorage_SugarSync#Response%("", "Going to folder " quote "Magic Briefcase" quote "...")
		HTTPRequest( "https://api.sugarsync.com/user", $Post:="", $Header:=#Header, "Method: GET`n" #Options )
		#magicBriefcase := CloudStorage_SugarSync#StringMid($Post, "<magicBriefcase>", "</magicBriefcase>")
		F_ARRAY("#magicBriefcase",#magicBriefcase) ; SETUP
		z:=(#magicBriefcase="") ? %#CloudStorage_SugarSync#Response%("NOT Found!","","", $Header) ($Return:=1) : %#CloudStorage_SugarSync#Response%("Folder Found.")
		IfEqual, $Return, 1, Return 1
		}
	Else IF (Action="Download")
		{
		IF !#magicBriefcase
			{
			MsgBox, 4112, Cloud Storage - SugarSync, ERROR:`n1st you have to initiallize the function`nCloudStorage_SugarSync("Init")`n`nAction Canceled!
			Return 1
			}
		D_ServerFilePath:=c1 , D_LocalFilePath:=c2
		SplitPath, D_LocalFilePath, D_LocalFileName
		; Find file link id
		%#CloudStorage_SugarSync#Response%("","","DOWNLOADING file " quote SubStr("/" D_ServerFilePath, InStr("/" D_ServerFilePath, "/",0, 0)+1) quote " as " quote D_LocalFileName quote ":")
		%#CloudStorage_SugarSync#Response%("","Going to file...")
		url:=CloudStorage_SugarSync#Find(D_ServerFilePath, "File")
		IfEqual, url,, Return 1
		; Download the file
		%#CloudStorage_SugarSync#Response%("","Downloading file...")
		FileRecycle, %D_LocalFilePath%
		HTTPRequest( url, $Post:="", $Header:=#Header, "Method: GET`nSaveAs: " D_LocalFilePath "`n" #Options)
		z:= !InStr($Header, "200 OK") ? %#CloudStorage_SugarSync#Response%("ERROR","","", $Header) ($Return:=1) : %#CloudStorage_SugarSync#Response%("File Downloaded.")
		IfEqual, $Return, 1, Return 1
		}
	Else IF (Action="Upload")
		{
		IF !#magicBriefcase
			{
			MsgBox, 4112, Cloud Storage - SugarSync, ERROR:`n1st you have to initiallize the function`nCloudStorage_SugarSync("Init")`n`nAction Canceled!
			Return 1
			}
		U_LocalFilePath:=c1 , U_ServerFilePath:=c2
		IfNotExist, %U_LocalFilePath%
			{
			%#CloudStorage_SugarSync#Response%("Local File NOT FOUND: " quote U_LocalFilePath quote,"","", "Local File NOT FOUND: " quote U_LocalFilePath quote)
			Return 1
			}
		SplitPath, U_LocalFilePath, U_LocalFileName
		; Find or create file link
		%#CloudStorage_SugarSync#Response%("","","UPLOADING file " quote U_LocalFileName quote " as " quote SubStr("/" U_ServerFilePath, InStr("/" U_ServerFilePath, "/",0, 0)+1) quote ":")
		%#CloudStorage_SugarSync#Response%("","Going to file...")
		url:=CloudStorage_SugarSync#Find(U_ServerFilePath, "File", 1)
		IfEqual, url,, Return 1
		; Upload the file
		%#CloudStorage_SugarSync#Response%("","Uploading file...")
		i := HTTPRequest( url, $Post:="", $Header:=#Header, "Method: PUT`nUpload: " U_LocalFilePath "`n" #Options )
		z:= !InStr($Header, "204 No Content") ? %#CloudStorage_SugarSync#Response%("ERROR","","", $Header) ($Return:=1) : %#CloudStorage_SugarSync#Response%("File Uploaded.")
		IfEqual, $Return, 1, Return 1
		}
	Return 0
}
;================================================================================
CloudStorage_SugarSync#Find(ServerFilePath, FileOrFolder, Create=0) {
	STATIC #CloudStorage_SugarSync#Response, #Options, #magicBriefcase, #Header, i, quote
	If !i { ; SETUP
		i:=1 , quote:=Chr(34) , #CloudStorage_SugarSync#Response:=(z:=F_ARRAY("ResponseFunction"))&&(IsFunc(z))? z : ""
		#Options:=F_ARRAY("#Options") , #magicBriefcase:=F_ARRAY("#magicBriefcase") , #Header:=F_ARRAY("#Header")
	}
	url:=#magicBriefcase , quote:=Chr(34)
	; walking on the path to go to the file/folder
	StringSplit, i, ServerFilePath, /, %A_Space%
	Loop, %i0%
		{
		s := i%A_Index%
		s  = %s%
		IfEqual, s,, Continue
		t := t ? t "/" s : s
		last_url := url
		If (A_Index<>i0) OR (FileOrFolder="folder")	; folder
			{
			; List folder contents trying to find the subfolder
			HTTPRequest( url "/contents", $Post:="", $Header:=#Header, "Method: GET`n" #Options )
			url1 := CloudStorage_SugarSync#StringMid($Post, "<displayName>" s "</displayName>")
			url  := CloudStorage_SugarSync#StringMid(url1, "<ref>", "</ref>")
			;msgbox, Folder=[%s%]`n`nurl=[%url%]`n`n%$Post%
			IF InStr(url, "https://api.sugarsync.com/folder/")
				{
				%#CloudStorage_SugarSync#Response%("Folder Found: " quote s quote)
				Continue
				}
			; Maybe found a file item with same name as our subfolder's --> try again for a folder in the remaining list
			url1 := CloudStorage_SugarSync#StringMid(url1, "<displayName>" s "</displayName>")
			url  := CloudStorage_SugarSync#StringMid(url1, "<ref>", "</ref>")
			;msgbox, NEXT Folder=[%s%]`n`nurl=[%url%]`n`n%$Post%
			IF InStr(url, "https://api.sugarsync.com/folder/")
				{
				%#CloudStorage_SugarSync#Response%("Folder Found: " quote s quote)
				Continue
				}
			IF !Create
				{
				tt := t
				Break
				}
			; Create NEW Folder
			$Post	= 
				( LTrim
				<?xml version="1.0" encoding="UTF-8" ?>
				<folder>
				 <displayName>%s%</displayName>
				</folder>
				)
			HTTPRequest( last_url, $Post, $Header:=#Header, "Method: POST`n" #Options )
			url := CloudStorage_SugarSync#StringMid($Header, "Location: ", "`n") ; created folder's id
			z:=(url="") ? %#CloudStorage_SugarSync#Response%("New Folder NOT Created: " quote t quote,"","", $Header) : %#CloudStorage_SugarSync#Response%("New Folder Created: " quote t quote)
			}
		Else			; file
			{
			; List folder contents trying to find the file
			HTTPRequest( url "/contents", $Post:="", $Header:=#Header, "Method: GET`n" #Options )
			; If <presentOnServer>true</presentOnServer>
				url1 := CloudStorage_SugarSync#StringMid($Post, "<displayName>" s "</displayName>")
				url  := CloudStorage_SugarSync#StringMid(url1, "<fileData>", "</fileData>")
				;msgbox, File(present)=[%s%]`n`nurl=[%url%]`n`n%$Post%
				IF InStr(url, "https://api.sugarsync.com/file/")
					Continue
				; Maybe found a folder item with same name as our file's --> try again for a file in the remaining list
				url1 := CloudStorage_SugarSync#StringMid(url1, "<displayName>" s "</displayName>")
				url  := CloudStorage_SugarSync#StringMid(url1, "<fileData>", "</fileData>")
				;msgbox, NEXT File(present)=[%s%]`n`nurl=[%url%]`n`n%$Post%
				IF InStr(url, "https://api.sugarsync.com/file/")
					Continue
			; If <presentOnServer>false</presentOnServer>
				url1 := CloudStorage_SugarSync#StringMid($Post, "<displayName>" s "</displayName>")
				url  := CloudStorage_SugarSync#StringMid(url1, "<ref>", "</ref>") "/data"
				;msgbox, File(NOT present)=[%s%]`n`nurl=[%url%]`n`n%$Post%
				IF InStr(url, "https://api.sugarsync.com/file/")
					Continue
				; Maybe found a folder item with same name as our file's --> try again for a file in the remaining list
				url1 := CloudStorage_SugarSync#StringMid(url1, "<displayName>" s "</displayName>")
				url  := CloudStorage_SugarSync#StringMid(url1, "<ref>", "</ref>") "/data"
				;msgbox, NEXT File(NOT present)=[%s%]`n`nurl=[%url%]`n`n%$Post%
				IF InStr(url, "https://api.sugarsync.com/file/")
					Continue
			IF !Create
				Break
			; Create NEW File
			$Post	= 
				( LTrim
				<?xml version="1.0" encoding="UTF-8" ?>
				<file>
				 <displayName>%s%</displayName>
				</file>
				) ; although i miss the "media type" of the new file, my tests show me that it is created successfully!
			HTTPRequest( last_url, $Post, $Header:=#Header, "Method: POST`n" #Options )
			url := CloudStorage_SugarSync#StringMid($Header, "Location: ", "`n") "/data"
			z:=(url="") ? %#CloudStorage_SugarSync#Response%("New File NOT Created: " quote t quote,"","", $Header) : %#CloudStorage_SugarSync#Response%("New File Created: " quote t quote)
			}
		}
	IF InStr(url, "https://api.sugarsync.com/" . FileOrFolder . "/")
		{
		%#CloudStorage_SugarSync#Response%(FileOrFolder " Found.")
		ErrorLevel := 0
		Return url
		}
	%#CloudStorage_SugarSync#Response%((tt ? "Folder NOT Found: [" . tt . "]" : "File NOT Found: [" . ServerFilePath . "]"),"","", $Header)
	ErrorLevel := 1
	Return ""
}
;================================================================================
CloudStorage_SugarSync#Progress( pct, total ) {
	STATIC #CloudStorage_SugarSync#Response, i
	IF !i ; SETUP
		i:=1 , #CloudStorage_SugarSync#Response:=(z:=F_ARRAY("ResponseFunction"))&&(IsFunc(z))? z : ""
	Message := pct<0 ? "Uploading " Round( 100 * ( pct + 1 ), 1 ) "%. " Round( ( pct + 1 ) * total, 0 ) " of " total " bytes."
			 : "Downloading " Round( 100 * pct, 1 ) "%. " Round( pct * total, 0 ) " of " total " bytes."
	%#CloudStorage_SugarSync#Response%(Message)
}
;================================================================================
CloudStorage_SugarSync#StringMid(Str, BeforePattern, AfterPattern="") {	; By art 24-04-2011
 Return ((i1:=(k:=InStr(Str,BeforePattern))?(k+StrLen(BeforePattern)):0)=0)
 OR ((i2:=(m:=InStr(Str,AfterPattern,False,i1))?(m-i1):0)=0 AND AfterPattern<>"")
 ? "" : ((AfterPattern="") ? SubStr(Str,i1) : SubStr(Str,i1,i2))
} ;If Paterns NOT found, an empty string is returned, but If AfterPattern="" it returns All after BeforePattern.
;================================================================================
F_ARRAY(N, V=" ") { ;Simple Array element's function (2 STATIC - NO GLOBAL VARs)
  /* ;***************************************************************************
  |   1. F_ARRAY("N", "V")     SET/CHANGE     variable   "N" to value "V"
  |   2. F_ARRAY("N")          GET            variable's "N" value
  |   3. F_ARRAY("N", "-")     CLEAR          variable   "N"
  |   4. F_ARRAY("-", "-")     CLEAR          ALL ARRAY variables
  */ ;***************************************************************************
  STATIC Z, Y:=" "  ;ErrorLevel=0 on success,  ErrorLevel=1 if element not found
  Z:=(((s:=(((a:=(c:=InStr(Z,Y N Y))?(c+StrLen(Y N Y)):0)=0)||(b:=(d:=InStr(Z,Y,0,a))?(d-a):0)=0)
  ? ("") : SubStr(Z,a,b))<>"")&&V<>Y&&V<>"-") ? SubStr(Z,1,a-1)V SubStr(Z,d):(V<>Y&&V<>"-"&&s="")
  ? (Z Y N Y V Y) : (N="-" && V="-") ? ("") : (V="-") ? SubStr(Z,1, c - 1) SubStr(Z, d + 1) : (Z)
  ;MsgBox, [%N%] [%V%]
  Return (V=Y && s<>"")? s :(V<>Y)? N "=" V : "" , ErrorLevel:=((V=Y && s<>"")? 0 :(V<>Y)? 0 : 1)
} ; F_ARRAY 23-03-2012 by [art]  AHK/AHK_L  http://www.autohotkey.com/forum/viewtopic.php?t=84187
