#include, WS.ahk ;Wrapper einbinden
#Persistent ;Script nicht beenden nach der Auto-Execution-Section
WS_LOGTOCONSOLE := 1 ;Zeige den Log in einem Konsolenfenster
WS_Startup() ;Starte Winsock 2.0

server := WS_Socket("TCP", "IPv4") ;Erstelle neue TCP/IP verbindung für IPv4
WS_Bind(server, "0.0.0.0", "12345") ;Binde die Verbindung an Port 12345
WS_Listen(server) ;Erlaube den Client zu verbinden
NewConnection := WS_Accept(server, client_ip, client_port) ;Warte auf verbindung

WS_Send(NewConnection, "Hello World!") ;Sende "Hello World!"
WS_Recv(NewConnection, message) ;Warte auf eine Antwort
MsgBox, %A_ScriptName%:`n%message%

WS_CloseSocket(NewConnection) ;Schließe die Verbindung
WS_CloseSocket(server) ;Schließe die Verbindung
WS_Shutdown() ;Beende Winsock 2.0
return