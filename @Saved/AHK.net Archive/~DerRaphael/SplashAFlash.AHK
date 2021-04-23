#NoTrayIcon
#WinActivateForce

#Include COM.ahk
#Include IE.ahk

FileInstall flashslpash.swf,flashsplash.swf

Gui, Add, Button, gGuiExit, App/Exit Button


; Either Enter

filePathName 	:= A_ScriptDir . "\flashsplash.swf"

; or

URL 		:= "http://www.autohotkey.net/~DerRaphael/flashsplash.swf"

; SplashFlash Width & Height

flashWidth	:= 400
flashHeight	:= 250
flashVanishTime := 10		; This Value in Seconds
Gosub, SplashAFlash


Gui, Show
return

SplashAFlash:
Gui, 1:+Disabled
Gui, 99:+owner1
Gui, 99:+LastFound -Caption +AlwaysOnTop -SysMenu

hWnd := WinExist()
IE_Init()
splashPWB:=IE_Add(hWnd,"","",flashWidth,flashHeight)

filePathName := A_ScriptDir . "\flashsplash.swf"
If ( FileExist( filePathName ) ) {
	StringReplace, filePathName, filePathName, `\, /
	URL := "file:///" . filePathName
} else {
	HTML = "<!DOCTYPE HTML PUBLIC ""-//W3C//DTD HTML 4.01 Transitional//EN"">"
	HTML .= "<html><head></head><body style=""margin:0px;padding:0px;"">"
	HTML .= "<object data=""" . URL . """ type=""application/x-shockwave-flash""" 
	HTML .= " height=""" . flashHeight . """ width=""" . flashWidth . """>"
	HTML .= "<param name=""movie"" value=""" . URL . """>"
	HTML .= "<param name=""loop"" value=""true""></object></body></html>"


}
IE_LoadURL(splashPWB, URL)
Loop
{
	If (IE_ReadyState(splashPWB)=4) 
		break
}
Gui, 99:Show, Center h%flashHeight% w%flashWidth%
WinActivate, ahk_id %hWnd%
WinWaitActive, ahk_id %hWnd%
SetTimer, 99GuiClose, % flashVanishTime * 1000
Return

99GuiClose:
	Gui, 1:-Disabled
	Gui, 99:Destroy
return
GuiExit:
ExitApp
return
