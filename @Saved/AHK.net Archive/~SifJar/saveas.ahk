; -------------------------------------------------------------------
;      Save As Scipt
;      by SifJar
;      Control+Left Click link in Internet Explorer to download file   
;      Alt+Left Click link for Save As Dialog     
; --------------------------------------------------------------------
DownloadDir := "C:\Downloads" ;Edit this line to change download directory


#IfWinActive, ahk_class IEFrame
^LButton:: GoSub, Save
+LButton:: GoSub, SaveAs

Save:
IfNotExist, %DownloadDir%
	FileCreateDir, %DownloadDir%
StatusBarGetText, LinkURL, 1, ahk_class IEFrame
StringLeft, URLCheck, LinkURL, 4
If URLCheck != http
	Return
StringSplit, InputURL, LinkURL, /
FileName := InputUrl%InputURL0%
URLDownloadToFile, %LinkURL%, %DownloadDir%\%FileName%
MsgBox,,Done, Done! Download Completed
Return

SaveAs:
StatusBarGetText, LinkURL, 1, ahk_class IEFrame
StringLeft, URLCheck, LinkURL, 4
If URLCheck != http
	Return	
StringSplit, InputURL, LinkURL, /
FileName := InputUrl%InputURL0%
FileSelectFile, OutputFilename, s, %FileName%, Select Save Location
If !OutputFilename
	Return
URLDownloadToFile, %LinkURL%, %OutputFilename%
MsgBox,,Done, Done! Download Completed
Return