#include, WS.ahk ;Wrapper einbinden
#Persistent ;Script nicht beenden nach der Auto-Execution-Section
WS_LOGTOCONSOLE := 1 ;Zeige den Log in einem Konsolenfenster
WS_Startup() ;Starte Winsock 2.0

client := WS_Socket("TCP", "IPv4") ;Erstelle neue TCP/IP verbindung für IPv4
WS_Connect(client, "127.0.0.1", "12345") ;Verbinde zum Server (lokale IP 127.0.0.1) mit Port 12345
WS_Recv(client, message) ;Warte auf eingehende Nachricht

MsgBox, %A_ScriptName%:`n%message% ;Zeige die Nachricht in einer MsgBox
WS_Send(client, "This is the answer of the client!") ;Sende eine Antwort

WS_CloseSocket(client) ;Schließe die Verbindung
WS_Shutdown() ;Beende Winsock 2.0
return