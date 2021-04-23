; Kontextabhängige Hilfe in einem beliebigen Editor - von Rajat
; http://www.autohotkey.com
; Damit kann mit Strg+2 (oder ein anderer Hotkey) die Hilfe-Dateiseite
; für den markierten AutoHotkey-Befehl oder Schlüsselwort angezeigt werden. 
; Wenn nichts markiert ist, dann wird der Befehlsname vom Anfang der aktuellen 
; Zeile extrahiert.

; Der unten genannte Hotkey nutzt die Zwischenablage, um die Kompatibilität mit
; den meisten Editoren zu gewährleisten (da ControlGet nicht immer 
; funktioniert). Danach wird der originale Inhalt der Zwischenablage wieder-
; hergestellt, jedoch als Klartext, was immer noch besser als gar nichts ist.

$^2::
; Die folgenden Werte sind nur während des Hotkey-Threads wirksam.
; Deshalb ist es nicht notwendig, deren ursprüngliche Werte wiederherzustellen,
; weil das automatisch geschieht, sobald der Thread endet:
SetWinDelay 10
SetKeyDelay 0
AutoTrim, On

if A_OSType = WIN32_WINDOWS  ; Windows 9x
	Sleep, 500  ; Damit der Benutzer Zeit hat, die Taste loszulassen.

C_ClipboardPrev = %clipboard%
clipboard =
; Verwendet das hervorgehobene Wort, falls vorhanden (da der Benutzer
; manchmal etwas absichtlich hervorhebt, das kein Befehl ist):
Send, ^c
ClipWait, 0.1
if ErrorLevel <> 0
{
	; Die gesamte Zeile abrufen, weil Editoren die Cursor-Navigationstasten 
	; unterschiedlich behandeln:
	Send, {home}+{end}^c
	ClipWait, 0.2
	if ErrorLevel <> 0  ; Selten, daher kein Fehler melden.
	{
		clipboard = %C_ClipboardPrev%
		Return
	}
}
C_Cmd = %clipboard%  ; Tabulator- & Leerzeichen davor oder danach entfernen.
clipboard = %C_ClipboardPrev%  ; Die vorherige Zwischenablage wiederherstellen.
Loop, parse, C_Cmd, %A_Space%`,  ; Das erste Leerzeichen oder Komma kennzeichnet das Ende des Befehls.
{
	C_Cmd = %A_LoopField%
	break ; d.h. wir benötigen nur einen Durchlauf.
}
IfWinNotExist, AutoHotkey Help
{
	; Standort von AutoHotkey ermitteln:
	RegRead, ahk_dir, HKEY_LOCAL_MACHINE, SOFTWARE\AutoHotkey, InstallDir
	if ErrorLevel  ; Nichts gefunden, so in anderen häufigen Standorten nachschauen.
	{
		if A_AhkPath
			SplitPath, A_AhkPath,, ahk_dir
		else IfExist ..\..\AutoHotkey.chm
			ahk_dir = ..\..
		else IfExist %A_ProgramFiles%\AutoHotkey\AutoHotkey.chm
			ahk_dir = %A_ProgramFiles%\AutoHotkey
		Else
		{
			MsgBox AutoHotkey-Ordner konnte nicht gefunden werden.
			Return
		}
	}
	Run %ahk_dir%\AutoHotkey.chm
	WinWait AutoHotkey Help
}
; Der obere Befehl bestimmt das "zuletzt gefundene" Fenster, das unten verwendet wird:
WinActivate
WinWaitActive
StringReplace, C_Cmd, C_Cmd, #, {#}
send, !n{home}+{end}%C_Cmd%{enter}
Return
