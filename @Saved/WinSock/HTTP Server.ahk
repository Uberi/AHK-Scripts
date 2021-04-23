#include, WS.ahk ;Wrapper einbinden
#Persistent ;Script nicht beenden nach der Auto-Execution-Section
WS_LOGTOCONSOLE := 1 ;Zeige den Log in einem Konsolenfenster
WS_Startup() ;Starte Winsock 2.0

ErrorTemplate =
(Join`n
<html>
  <head>
    <title>404 - Page not Found!</title>
  </head>
  <body>
    <h1>404 - Page not Found!</h1>
  </body>
</html>
)

IndexTemplate =
(Join`n
<html>
  <head>
    <title>Hello World!</title>
  </head>
  <body>
    <h1>Hello World!</h1>
  </body>
</html>
)

server := WS_Socket("TCP", "IPv4") ;Erstelle neue TCP/IP verbindung für IPv4
WS_Bind(server, "0.0.0.0", 80) ;Binde die Verbindung an Port 80 (HTTP)
Loop
{
  WS_Listen(server) ;Erlaube den Client zu verbinden
  NewConnection := WS_Accept(server, client_ip, client_port) ;Warte auf verbindung

  WS_Recv(NewConnection, message) ;Warte auf eine Anfrage
  if (instr(message, "GET")=1)
  {
    requested_page := Substr(message, Instr(message, " ")+1)
    requested_page := Substr(requested_page, 1, Instr(requested_page, " ")-1)

    Answer := "HTTP/1.1 " ;HTTP-Version
    Answer .= "200 OK`r`n" ;Statuscode (200 = "OK", 404 = "Page not found", ...)
    Answer .= "Content-Type: text/html`r`n"
    Answer .= "Content-Length: "
    if (requested_page!="/index.html")
    {
      Answer .= Strlen(ErrorTemplate) "`r`n`r`n"
      Answer .= ErrorTemplate
    }
    else
    {
      Answer .= Strlen(IndexTemplate) "`r`n`r`n"
      Answer .= IndexTemplate
    }
    WS_Send(NewConnection, Answer) ;Sende die Antwort
  }
  WS_CloseSocket(NewConnection) ;Schließe die Verbindung
}

WS_CloseSocket(server) ;Schließe die Verbindung
WS_Shutdown() ;Beende Winsock 2.0
return