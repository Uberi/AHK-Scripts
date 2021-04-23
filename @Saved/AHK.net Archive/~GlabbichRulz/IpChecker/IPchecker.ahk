#SingleInstance force
IPWebsite := "http://blockspot.comeze.com/EigeneIP.php"
IPDokument := A_Desktop "\EigeneIP.txt"
IPDokumentClear := A_Desktop "\EigeneIPclear.txt"
Tooltip, Daten werden aktualisiert
URLDownloadToFile, %IPWebsite%, %IPDokument%
FileReadLine, IPGelesen, %IPDokument%, 1
FileDelete, %IPDokument%
Tooltip
;MsgBox,,Deine IPs,Lokale IPs:`n`t%A_IPAddress1%`n`t%A_IPAddress2%`n`t%A_IPAddress3%`n`t%A_IPAddress4%`nGlobale IP:`n`t%IPGelesen%
Gui, Add, Edit, x22 y60 w240 h30 , %A_IPAddress1%
Gui, Add, Edit, x22 y90 w240 h30 , %A_IPAddress2%
Gui, Add, Edit, x22 y120 w240 h30 , %A_IPAddress3%
Gui, Add, Edit, x22 y150 w240 h30 , %A_IPAddress4%
Gui, Add, Edit, x22 y210 w240 h30 , %IPGelesen%
Gui, Add, Text, x2 y40 w190 h20 +BackgroundTrans, Lokale IP-Adressen:
Gui, Add, Text, x2 y190 w190 h20 +BackgroundTrans, Globale IP-Adresse:
Gui, Font, S14 CDefault Bold, Verdana
Gui, Add, Text, x2 y0 w120 h30 +BackgroundTrans, IP Checker
Gui, Font, S12 CDefault Bold, Verdana
Gui, Add, Text, x129 y16 w160 h20 +BackgroundTrans, by GlabbichRulz
Gui, Font, S12 CGreen Bold, Verdana
Gui, Add, Text, x2 y20 w380 h20 +BackgroundTrans, ____________________________________
Gui, Add, Button, x57 y241 w140 h30 gRefresh, Neuladen (F5)
Gui, Show, h283 w274, IP Checker v.1.0
Return


F5::
GoSub, Refresh
Return

Refresh:
Reload
Sleep 1000
MsgBox Das Programm konnte nicht Aktualisiert werden.`nBitte starte es manuell neu.
ExitApp
return

GuiClose:
ExitApp