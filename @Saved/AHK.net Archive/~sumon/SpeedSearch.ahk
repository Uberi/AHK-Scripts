; ******* General ******* 
; < SPEEDSEARCH >
; Script version: 0.9
; (Added pictures, streamlined script)
; Script created using Autohotkey (http://www.autohotkey.com) 
; AUTHOR: sumon @ the Autohotkey forums, < simon.stralberg (@) gmail.com>
; Edited-by:
; Changes:
; LEGAL: Your may freely edit and use this code for personal use. However: Unless granted permission by the original author, you may ONLY redistribute it using the official Autohotkey forums, Autohotkey.net, or to friends. I retain authorship over the original code & idea. If you have any questions, please contact me at my above stated email. Regards, Simon.
;
; To-do-list: 
; * Add separate SpeedSearchSettings
; * Configurability (?), ability to add own searchpaths
; * For searchengines, specify f.ex. G1:milk to go to the first hit of milk.
; * Find an icon for Google-pictures
; * 
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance, Force
; ******* Auto-Execute ******* ------------------------------------------------------
IfNotExist, data\img
	FIleCreateDir, data\img
IfNotExist, data\speedsearchicon.ico
	UrlDownloadToFile, http://www.autohotkey.net/~sumon/Images/SpeedSearchIcon.ico, data\img\speedsearchicon.ico
IfExist, data\img\speedsearchicon.ico
	Menu, Tray, Icon, data\img\speedsearchicon.ico
; FileInstall, data\speedsearch_help.txt, data\speedsearch_help.txt

; ******* Autorun Labels ******* ------------------------------------------------------
Search:
Gui, Add, Text,, Enter site (or #: before a search phrase)
Gui, Add, Edit, x10 vSearchString w195,
IfNotExist, Legal.txt ; This also means it's "The first run", so download pictures :)
{
	Gosub, SetupIcons
	Text = You may freely edit and use this code for personal use. However: Unless granted permission by the original author, you may ONLY redistribute it using the official Autohotkey forums, Autohotkey.net, or to friends. I retain authorship over the original code. If you have any questions, please contact me at my above stated email. Regards, Simon.
	FileAppend, %Text%, Legal.txt
}
Gui, Add, Picture, x10 w16 h16 gInsertString vG, data\img\googleicon.ico
Gui, Add, Picture, x30 w16 h16 yp gInsertString vP, data\img\googleicon.ico ; Pictures
Gui, Add, Picture, x50 w16 h16 yp gInsertString vM, data\img\googleearthicon.ico
Gui, Add, Picture, x70 w16 h16 yp gInsertString vW, data\img\wikiicon.ico
Gui, Add, Picture, x90 w16 h16 yp gInsertString vY, data\img\youtubeicon.ico
Gui, Add, Picture, x110 w16 h16 yp gInsertString vF, data\img\facebookicon.ico
Gui, Add, Picture, x130 w16 h16 yp gInsertString vB, data\img\thepiratebayicon.ico
Gui, Add, Picture, x150 w16 h16 yp gInsertString vH, data\img\hittaicon.ico
Gui, Add, Picture, x170 w16 h16 yp gInsertString vL, data\img\flashbackicon.ico
Gui, Add, Picture, x190 w16 h16 yp gInsertString vA, data\img\autohotkeyicon.ico
; 
Gui, Add, Button, x10 gSubmit w195 Default, < GO! >
Gui, Show,, SpeedSearch
return

; ******* Called Labels ******* ------------------------------------------------------

InsertString: ; When a picture is clicked, insert equalivent string
GuiControl,, SearchString, %A_GuiControl%:
Send {End}
return

SetupIcons:
TrayTip, SpeedSearch:, Downloading icons, 3, 1
UrlDownloadtoFile, https://www.flashback.org/favicon.ico, data\img\flashbackicon.ico
UrlDownloadToFile, http://en.wikipedia.org/favicon.ico, data\img\wikiicon.ico
UrlDownloadToFile, http://www.google.com/favicon.ico, data\img\googleicon.ico
UrlDownloadToFile, http://www.hitta.se/favicon.ico, data\img\hittaicon.ico
UrlDownloadToFile, http://www.youtube.com/favicon.ico, data\img\youtubeicon.ico
UrlDownloadToFile, www.facebook.com/favicon.ico, data\img\facebookicon.ico
UrlDownloadToFile, http://www.thepiratebay.com/favicon.ico, data\img\thepiratebayicon.ico
UrlDownloadToFile, http://www.autohotkey.com/favicon.ico, data\img\autohotkeyicon.ico
TrayTip
;GoogleEarth.ico from http://www.mricons.com/ajax/download/ico/14332/128/google-earth-planet
return

Help:
MsgBox To perform a Google-search, just enter the search string and hit enter. To search using specific services, such as Wikipedia, Youtube, Google Maps, etc, hit #: and the search string (for example, "w:application").
return
Submit:
Gui, Submit
StringLeft, ColonFind, SearchString, 2
StringTrimLeft, ColonFind, Colonfind, 1
StringLeft, CommandFind, SearchString, 1 ; For the eventual 1-character command
Colon = :
if InStr(ColonFind, Colon)
	{
	StringTrimLeft, SearchString, SearchString, 2 ; Cleans up the SearchString
	if InStr(Commandfind, "g")
		Run, http://www.google.se/search?&q=%SearchString%
	if InStr(Commandfind, "y")
		Run, http://www.youtube.com/results?search_query=%SearchString%
	if InStr(Commandfind, "h")
		Run, http://www.hitta.se/SearchMixed.aspx?vad=%SearchString%
	if InStr(Commandfind, "f")
		Run, http://www.facebook.com/search.php?q=%SearchString%
	if InStr(Commandfind, "w")
		Run, http://en.wikipedia.org/wiki/Special:Search?search=%SearchString%
		; Run, http://sv.wikipedia.org/w/index.php?search=%SearchString%		
	if InStr(Commandfind, "p")
		Run, http://www.google.se/images?q=%SearchString%
	if InStr(Commandfind, "m")
		Run, http://maps.google.se/maps?q=%SearchString%
	if InStr(Commandfind, "b")
		Run, http://thepiratebay.org/search/%SearchString%/0/99/0
	if InStr(Commandfind, "l")
		Run, https://www.flashback.org/sok/%SearchString%
	if InStr(Commandfind, "a")
		Run, http://www.autohotkey.com/docs/commands/%SearchString%.htm
}else{
	Run, http://www.%SearchString%.com
	}
ExitApp