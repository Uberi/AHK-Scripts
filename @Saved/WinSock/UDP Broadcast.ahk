#include, WS.ahk ;Wrapper einbinden
#Persistent ;Script nicht beenden nach der Auto-Execution-Section
WS_LOGTOCONSOLE := 1 ;Zeige den Log in einem Konsolenfenster
WS_Startup() ;Starte Winsock 2.0

sock_in := WS_Socket("UDP", "IPv4") ;Erstelle neue UDP verbindung für IPv4
WS_Bind(sock_in, "0.0.0.0", 54321) ;Binde den Socket an "INADDR_ANY"

sock_out := WS_Socket("UDP", "IPv4") ;Erstelle neue UDP verbindung für IPv4
WS_EnableBroadcast(sock_out) ;Erlaube Broadcast-messages
WS_Connect(sock_out, "255.255.255.255", 54321) ;Verbinde mit "INADDR_BROADCAST"

SetTimer, Recv, 200
Loop
{
  Inputbox, send_msg
  if (send_msg="")
    break
  WS_Send(sock_out, send_msg)
}
WS_CloseSocket(sock_in) ;Schließe die Verbindung
WS_CloseSocket(sock_out) ;Schließe die Verbindung
WS_Shutdown() ;Beende Winsock 2.0
return

Recv:
WS_NOLOG := 1
while (WS_MessageSize(sock_in)>0)
{
  WS_NOLOG := 0
  WS_RecvFrom(sock_in, recv_ip, recv_port, recv_msg, WS_MessageSize(sock_in))
  MsgBox, % "Message from " recv_ip ":" recv_port "`n`n" recv_msg
}
return