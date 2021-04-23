#include, WS.ahk ;Wrapper einbinden
#Persistent ;Script nicht beenden nach der Auto-Execution-Section
WS_LOGTOCONSOLE := 1 ;Zeige den Log in einem Konsolenfenster
WS_Startup() ;Starte Winsock 2.0

;=========================

Pop3Host := ;Pop3-Servername
Pop3Port := ;Pop3-Port (standard: "110")
UserName := ;Benutzername oder Emailadresse (je nach Anbieter)
UserPass := ;Das Passwort

;Beispiele:
;=========================
/*
;Für GMX:
Pop3Host := "pop.gmx.net"
Pop3Port := "110"
UserName := "someuser@gmx.net"
UserPass := "****"
*/

/*
;Für Yahoo:
Pop3Host := "pop.mail.yahoo.de"
Pop3Port := "110"
UserName := "someuser@yahoo.de"
UserPass := "****"
*/
;=========================

client := WS_Socket("TCP", "IPv4") ;Erstelle neue TCP/IP verbindung für IPv4
if (WS_Connect(client, Pop3Host, Pop3Port)) ;Verbinde mit dem E-Mail server
{
  WS_Recv(client, message) ;Warte auf eingehende Nachricht
  if (instr(message, "+OK")=1)
  {
    WS_Send(client, "user " UserName "`r`n") ;Sende Benutzername
    WS_Recv(client, message) ;Warte auf eingehende Nachricht
    if (instr(message, "+OK")=1)
    {
      WS_Send(client, "pass " UserPass "`r`n") ;Sende Passwort
      WS_Recv(client, message) ;Warte auf eingehende Nachricht
      if (instr(message, "+OK")=1)
        login_success := 1
    }
  }
}
if (login_success)
{
  WS_Send(client, "stat`r`n") ;Status ermitteln
  WS_Recv(client, message) ;Warte auf eingehende Nachricht
  num_mails := Substr(message, Instr(message, " ")+1)
  num_mails := Substr(num_mails, 1, Instr(num_mails, " ")-1)
  MsgBox, Es befinden sich %num_mails% Emails in deinem Posteingang!
}
WS_CloseSocket(client) ;Schließe die Verbindung
WS_Shutdown() ;Beende Winsock 2.0
return