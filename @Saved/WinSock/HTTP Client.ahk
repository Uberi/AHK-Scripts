#include, WS.ahk ;Wrapper einbinden
#Persistent ;Script nicht beenden nach der Auto-Execution-Section
WS_LOGTOCONSOLE := 1 ;Zeige den Log in einem Konsolenfenster
WS_Startup() ;Starte Winsock 2.0


request =
(Join`n
GET / HTTP/1.1
Accept: text/html
User-Agent: MyAutohotkeyApplication


) ;ACHTUNG: Am Ende einer HTTP anfrage müssen 2 leere Zeilen folgen (`r`n`r`n)
StringReplace, request, request, `r`n, `n, 1 ;Konvertiere neue Zeilen in das AutoHotkey-format (sollte es anders sein.)
StringReplace, request, request, `n, `r`n, 1 ;Konvertiere neue Zeilen so dass der Host es lesen kann.

client := WS_Socket("TCP", "IPv4") ;Erstelle neue TCP/IP verbindung für IPv4
if (WS_Connect(client, "www.whatismyip.org", 80)) ;Verbinde mit "www.whatismyip.org"
{
  WS_Send(client, request) ;Sende HTTP anfrage
  WS_Recv(client, message) ;Warte auf eingehende Nachricht
}
WS_CloseSocket(client) ;Schließe die Verbindung
WS_Shutdown() ;Beende Winsock 2.0

StringReplace, message, message, `r`n, `n, 1 ;Konvertiere die Antwort in das AutoHotkey-format
MsgBox, % "Antwort von www.whatismyip.com`n`n" message
return