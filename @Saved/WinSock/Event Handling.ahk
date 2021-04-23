#include, WS.ahk ;Wrapper einbinden
#Persistent ;Script nicht beenden nach der Auto-Execution-Section
WS_LOGTOCONSOLE := 1 ;Zeige den Log in einem Konsolenfenster
WS_Startup() ;Starte Winsock 2.0
server := WS_Socket("TCP", "IPv4") ;Erstelle neue TCP/IP verbindung für IPv4
WS_Bind(server, "0.0.0.0", 56789) ;Binde die Verbindung an Port 56789
WS_Listen(server) ;Erlaube den Client zu verbinden
WS_HandleEvents(server) ;Führe die Callbacks aus (wenn diese existieren)
return

WS_OnRead(socket)
{
;  if (condition)
;  {
;    WS_Recv(socket, msg)
;    if (msg="I need an answer")
;      WS_Send(socket, "Here is your answer. No!")
;    return 1 ;Event wurde bearbeited
;  }
  return 0 ;Event wurde NICHT bearbeited
}

WS_OnAccept(socket)
{
;  if (condition)
;  {
;    new_socket := WS_Accept(socket, new_ip, new_port)
;    return 1 ;Event wurde bearbeited
;  }
  return 0 ;Event wurde NICHT bearbeited
}

WS_OnConnect(socket)
{
;  if (condition)
;  {
;    ;WS_Connect() ist hier unnötig, die Verbindung steht bereits
;    return 1 ;Event wurde bearbeited
;  }
  return 0 ;Event wurde NICHT bearbeited
}

WS_OnClose(socket)
{
;  if (condition)
;  {
;    WS_CloseSocket(socket)
;    return 1 ;Event wurde bearbeited
;  }
  return 0 ;Event wurde NICHT bearbeited
}