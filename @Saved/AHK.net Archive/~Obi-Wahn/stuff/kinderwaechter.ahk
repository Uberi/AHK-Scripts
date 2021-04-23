#NoEnv
#NoTrayIcon
OnExit, WriteTime

log := "C:\WINDOWS\TimeLog.txt"		; Temporäre Datei (zeitüberwachung)
FileReadLine, time, %log%, 1		; Liest die bereits vergangene Zeit ein
choosenPass := "MeineLiebeKleine"	; Passwort zum beenden. (Hier ist das Passwort: MeineLiebeKleine)
maxtime := 3						; Maximale Zeit (Stunden)
et := 0								; Was tun wenn die Zeit um ist?
									; 0 = Abmelden
									; 9 = Herunterfahren + Ausschalten
									; 13 = Erzwungenes Herunterfahren + Ausschalten

maxtime *= 3600				; Berechnung der Anzahl der Sekunden
newboot := 1				; Wird durch den neustart des Programms auf 1 gesetzt
SetTimer, endcheck, 1000	; Ruft eine jede Sekunden das Label "endcheck" auf.

endcheck:
If InStr(time, "EOD") {	; Wenn in der Datei "EOD" (End of Day) steht 
	StringSplit, dd, time, %A_Space%
	If (dd1 = A_YDay) {		; Wenn der Tag heute ist
		SoundPlay, %A_WinDir%\Media\Windows XP-Sprechblase.wav, 1
		Msgbox, 4144, Nicht trixen Baby, Schluss für heute ! ... Finito - ENDE !, 10
		ShutDown, %et%
		time := A_YDay " - EOD"
		ExitApp
	} Else {	; Ansonst wird angenommen, dass das gestern war.
		FileDelete, %log%
		time := 1
	}
} Else {	; Wenn nicht dann
	time += 1	; füge 1 zur Zeit hinzu
	If (newboot = 1) {	; wenn ein neustart erfolgt ist
		SoundPlay, %A_Windir%\Media\Windows XP-Sprechblase.wav, 1
		cal := (maxtime - time) / 3600	; restzeitberechnung in stunden
		SetFormat, float, 0.1	; Nur zur Optik, dass nur eine Kommastelle vorhanden ist.
		cal += 0
		Msgbox, 4144, Mama sagt:, % "Laura - du hast noch " cal " Stunde" (cal<>1 ? "n" : "") " für PC und Internet", 10
	}
	newboot := 0	; Newboot wird auf 0 gesetzt, damit nicht jede sekunde diese Nachricht erscheint.
}
If (time >= maxtime) {		; Wenn die Zeit verbraucht oder überschritten wurde (steigert die verlässlichkeit)
	time := A_YDay " - EOD"	; setze die zeit auf den Tag und EOD
	SoundPlay, %A_WinDir%\Media\Windows XP-Hardwarefehler.wav, 1
	Msgbox, 4144, Anweisung deiner Mutter:, % maxtime " Stunde" (maxtime>1 ? "n" : "") " sind jetzt um.`nLaura - du solltest den PC jetzt ausschalten!`nDer Countdown läuft!!!", 10
	Sleep, 180000
	SoundPlay, %A_WinDir%\Media\Windows XP-Hardwarefehler.wav, 1
	SoundPlay, %A_WinDir%\Media\Windows XP-Hardwarefehler.wav, 1
	Msgbox, 4144, Jetzt werd' ich aber böse!, !!!   Letzte W A R N U N G   !!!`nSchalte den PC aus!,10
	Sleep, 60000
	ShutDown, %et%
	ExitApp
}
Return

WriteTime:
FileDelete, %log%
FileAppend, %time%, %log%
ExitApp
Return

#q::
Inputbox, ePass, Passwort, Bitte Passwort eingeben, HIDE, 250, 120
If (ePass = choosenPass)
	ExitApp
Return
