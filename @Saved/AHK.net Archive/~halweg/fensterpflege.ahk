; Halwegs Fensterpflege 2.5 (November 2010)
; AutoHotkey Version: 1.0.48
; Language:       German
; Platform:       WinXP / Win 7
; Author:         halweg (halweg(at)gmx.de)
; Halwegs Fensterpflege ist eine Weiterentwicklung des Dialogboxkillers  

;***************************************************************************************************
;**************************** Initialisierung ******************************************************
;***************************************************************************************************

; Systemeinstellungen
COORDMODE, TOOLTIP, SCREEN                                                      ; Place ToolTips at absolute screen coordinates: 
COORDMODE, MOUSE, SCREEN                                                        ; Mouse Position at absolute screen coordinates: 
SETTITLEMATCHMODE, 2                                                            ; Erkennung von Teilstrings des Fenstertitels
SETTITLEMATCHMODE, SLOW                                                         ; Das bringt mehr Erkennungstext.
DETECTHIDDENTEXT, ON                                                            ; Auch versteckten Text finden!
VARSETCAPACITY(fnew_text,1000)                                                  ; Begrenzung der je gefundenem Fenster aufnehmbaren Textmenge

Inidir = %A_APPDATA%\AHK\                                                ; Die Inidatei mit den Pflegeanleitungen wird standardm��ig unter Anwendungsdaten\Autohotkey angelegt
Inifile := Inidir . "Fensterpflege.ini"                                         ; Name der Inidatei

; Inifile �berpr�fen und ggf. anlegen
IFNOTEXIST, %Inifile%
  {
  MSGBOX,,HALWEGS FENSTERPFLEGE,%helptext%
  MSGBOX, 36,Halwegs Fensterpflege, %  ""
  . "Auf Ihrem Rechner wurde noch keine Initiatiliserungsdatei f�r die Fensterpflege gefunden.`n"
  . "Diese wird ben�tigt, um die Einstellungen f�r die zu pflegenden Fenster zu speichern.`n"
  . "Soll die Datei " . Inifile . " jetzt angelegt werden?"
  IFMSGBOX, Yes
    {
    FILECREATEDIR, %Inidir%
    FILEAPPEND ,, %Inifile%
    IFEXIST, %Inifile%
      MSGBOX, Die Inidatei %Inifile% wurde erfolgreich neu angelegt.
    ELSE
      {
      MSGBOX, Es gab ein Problem beim Anlegen der Datei %Inifile%
      EXITAPP
      }
    }
  ELSE
    EXITAPP
  }

; Unver�nderbare Einstellungen setzen
Textbeep_leading_text = Halwegs Fensterpflege:
Textbeep_background_color = E1FFE1                                              ; Hintergrundfarbe, E1FFE1 = helles Gr�n

; Ver�nderbare Einstellungen vorbereiten
settingstext =
  (LTRIM
  *Allgemeine Einstellungen
  Look_for_new_window_time_intervall|200        |4                             |Analyseintervall (ms)                      |Aller wieviel ms schaut Halwegs Fensterpflege nach, ob ein neuer Fenstertitel existiert.
  min_textsearch_time               |150        |4                             |Zeit zum Auslesen des Fenstertexts (ms)    |Wie lange soll Fensterpflege mindestens warten, bis der Text eines gefundenen Fensters analysiert wird.
  consider_monitor_count            |0          |CHECK,0,1                     |Fensterverschiebung nur bei Zweitmonitor   |Die Fensterpositionierung wird ganz ausgeschaltet, wenn kein Zweitmonitor angeschlossen ist (erweiterter Desktop).
  no_change_proof1                  |.pdf]      |5                             |Nicht pr�fen: letzte 5 Zeichen (1)         |Wie muss ein Fenstertitel enden, damit seine �nderung nicht zu einer Pflege f�hrt.
  no_change_proof2                  |<leer>     |5                             |Nicht pr�fen: letzte 5 Zeichen (2)         |Wie muss ein Fenstertitel enden, damit seine �nderung nicht zu einer Pflege f�hrt.
  no_change_proof3                  |<leer>     |5                             |Nicht pr�fen: letzte 5 Zeichen (3)         |Wie muss ein Fenstertitel enden, damit seine �nderung nicht zu einer Pflege f�hrt.
  no_change_proof4                  |<leer>     |5                             |Nicht pr�fen: letzte 5 Zeichen (4)         |Wie muss ein Fenstertitel enden, damit seine �nderung nicht zu einer Pflege f�hrt.
  *Ansichtseinstellungen
  list_rows                         |40         |2                             |Anzahl der Zeilen bei der Pflegverwaltung  |Diese Angabe bestimmt, wie hoch das Fenster wird. Sollte nicht gr��er als 60 sein.
  list_width                        |1100       |4                             |Breite (in Pixel) der Pflegverwaltung      |Diese Angabe bestimmt, wie breit das Fenster wird. Die Standardspaltengr��e werden entsprechend angepasst. Sollte mindestens 1100 sein.
  *Ger�usche w�hrend der der Fensterpflege
  Proofsound                        |0          |CHECK,0,1                     |Analyseger�usch                            |Ein Rasseln ert�nt, w�hrend Halwegs Fensterpflege das aktuelle Fenster analysiert.  
  Keysound                          |autoaktiv  |CHECK,leise,autoaktiv         |Tastenger�usch                             |Ein Doppelpiepsen ert�nt, wenn Tasten an das aktive Fenster gesendet werden.
  Shiftsound                        |verschieben|CHECK,leise,verschieben       |Verschiebeger�usch                         |Ein Surren ert�nt, wenn Fenster verschoben werden.
  *Verbalisierung der Fensterpflege (gr�ne Textmeldungen)
  Textbeep_max_rows                 |40         |3                             |Anzahl Tooltippzeilen (0 = keine Tooltipps)|Wieviele untereinanderliegende Zeilen sollen gleichzeitig angezeigt werden.  
  Textbeep_default_showtime         |3000       |5                             |Anzeigedauer (ms)                          |Wie lange sollen die Texte jeweils angezeigt werden.
  Hotkey_to_freeze_the_tooltip      |F10        |KEY                           |Taste zum Einfrieren der Textmeldung       |Tippen Sie eine Tastenkombination, mit der die Texte innerhalb von 10s erneut aufgerufen werden k�nnen.
  *Profi-Einstellungen der Verbalisierung
  Textbeep_x                        |10         |4                             |Tooltipp X-Position                        |X-Position auf dem Monitor, wo die Tooltipps angezeigt werden sollen.
  Textbeep_y                        |300        |4                             |Tooltipp Y-Position                        |Y-Position auf dem Monitor, wo die Tooltipps angezeigt werden sollen.
  Textbeep_max_length               |120        |4                             |Maximale Zeichenzahl einer Textzeile       |Texte mit mehr Zeichen werden mit ... in der Mitte gek�rzt
  Textbeep_default_frequency        |1400       |4                             |Pieps-Frequenz-Basis                       |Basisfrequenz f�r das Pflegeger�usch.
  Textbeep_default_textcolor        |Black      |Black,Maroon,Purple,Green,Gray|Tooltipptextfarbe                          |Farbe, in der die Tooltipps im Vordergrund erscheinen
  )
; Einstellungen einlesen 
Settings_Read(settingstext,Inifile)


; Hilfetext
helptext =
  (LTRIM
  Informationen zu HALWEGS FENSTERPFLEGE 2.5(Stand November 2010)
  
  Wozu dient das Programm?
  Pflegeanleitungen sind Automatismen, die auf ein neu unter Windows erscheinendes Fenster angewendet werden.
  Das k�nnen im einzelnen sein:
  - Tasten, die an das Fenster gesendet werden
  - Text, der in Formularfelder (z. B. Login-Masken) eingetragen wird,
  - Aufsuchen und Klicken bestimmter Links (derzeit nur f�r Internet Explorer implementiert) 
  - Positionen und Gr��en von Fenstern, die als optimal f�r das jeweilige Fenster gespeichert sind.
  Mit HALWEGS FENSTERPFLEGE kann man sich also jede Menge l�stiger Klick- und Tipparbeit sparen.
  
  Wann wird eine "Pfleganleitung" aktiviert?
  HALWEGS FENSTERPFLEGE �berwacht im Hintergrund die unter Windows erscheinenden Fenster. Der Titel und der textliche Inhalt des aktuellen 
  Fensters wird laufend mit den gespeicherten Mustern verglichen. Gibt es dabei eine �bereinstimmung, so wird die entsprechende 
  Pflegeanleitung aktiviert. Zu beachten ist, dass die gespeicherten Muster von oben nach unten durchlaufen werden. Ein Fenstertitel 
  "Adobe Reader - [Mein Dokument" sollte also vor dem allgemeineren Fenstertitel "Adobe Reader - " angeordnet sein, um erkannt und 
  priorisiert gepflegt zu werden. 
  Die Erkennung des Fenstertextes dauert etwas l�nger, als wenn nur ein Titel gespeichert ist, insgesamt ist die Prozessorbelastung aber 
  minimal und sollte praktisch nicht sp�rbar sein.     
  
  Was tut eine "Pflegeanleitung"?
  Eine Pflegeanleitung besteht aus einem oder mehreren Pflegeschritten, die in folgender Reihenfolge durchlaufen werden:
  Schritt 1: Wenn eine Wartezeit eingetragen ist, wird nach der Erkennung des Fensters solange mit der Pflege gewartet, bis diese 
  abgelaufen ist. Wenn hier 9999 ms angegeben sind, muss die Pflege per Rollen-Taste manuell ausgel�st werden ("Pflegestufe").   
  Schritt 2: Es werden die angegebenen Tasten gesendet, z.B. j{TAB}{ENTER} 
  (Tasten nach AHK-Syntax, s. http://de.autohotkey.com/docs/Hotkeys.htm)
  Wenn zwischen den Tasten ein Begriff in <...> auftaucht, wird dieser im Browser (derzeit nur IE 8.0) vorher gesucht, so dass z.B. 
  ein bestimmtes Formularfeld angesprungen werden kann. Weiterhin k�nnen Datumsvariablen in die Pflegeanleitung integriert werden 
  (z. B. `%A_YEAR`% (akt. Jahr), `%B_MM`% (Nr. Vormonat) usw. (Liste siehe Dialogbox)
  Schritt 3: Falls eine Fensterposition gespeichert ist, wird das Fenster auf diese Position und Gr��e verschoben. 
  
  Was ist eine "Pflegestufe"?
  Bei manchen Fenstern (z. B. zur Passworteingabe) soll die Behandlung manuell ausgel�st werden. Dazu wird bei der Wartezeit 9999 
  eingetragen. Taucht so ein Fenster auf, meldet sich HALWEGS FENSTERPFLEGE mit einem Tooltip ("Eingabebereitschaft hergestellt")
  und einem Signalton. Nun kann per Rollen-Taste die Fensterpflege (Tasten usw.) manuell ausgel�st werden.
  
  Wo werden die "Pflegeanleitungen" gespeichert?
  F�r Halwegs Fensterpflege m�ssen "Pflegeanleitungen" auf Ihrem Computer gespeichert werden. Dies geschieht standardm��ig im 
  nutzerbezogenen Verzeichnis f�r Anwendungsdaten (%A_APPDATA%\Autohotkey\).
    
  Wie kann ich die "Pflege" der Fenster verfolgen?
  HALWEGS FENSTERPFLEGE enth�lt ein Verbalisierungsmodul (IC_Textbeep.ahk), welches daf�r sorgt, dass Pflegeprozesse in Tooltipps am 
  linken Bildschirmrand angezeigt werden sowie ein kurzes Doppelpiepsen auf die laufende Pflege hinweist. Diese Verbalisierung kann 
  ausgeschaltet und modifiziert werden (s. Dialog Einstellungen).  
  
  Wie wird HALWEGS FENSTERPFLEGE bedient?
  Rollen-Taste`t`t`t`t`t- Erstellen einer neuen Pfleganleitung f�r das gerade aktuelle Fenster
  Rollen-Taste (bei Pflegestufe)`t`t`t`t- manuelles Ausl�sen der Pflege.
  UMSCH-Rollen-Taste `t`t`t`t- R�cksetzen des Pflegespeichers, alle Fenster werden als ungepflegt betrachtet.
  Win-Rollen-Taste`t`t`t`t`t- Aufruf der Verwaltung der Pflegeanleitungen
  %Hotkey_to_freeze_the_tooltip% (innerhalb von 10s - nach Erl�schen eines Tooltipps)`t- Erneute Anzeige der letzten Pflegemeldung (mit %Hotkey_to_freeze_the_tooltip% wieder weg)

  Alles andere ist, hoffentlich, selbsterkl�rend. Fragen an halweg|at|gmx.de 
  (Diese Hinweise k�nnen in der Verwaltung der Pflegeanleitungen (Taste Win-Rollen) �ber F1 aufgerufen werden.)
  )

; Tray-Icons
IF A_ISCOMPILED                                                                 ; Wenn ein kompiliertes Skript gestartet wurde, wird ...
  iconfile = %A_SCRIPTFULLPATH%                                                 ; ... das Bitmap f�r das Tray-Icon direkt aus der Exe genommen (und m�sste, falls gew�nscht, dort mit reingebaut werden)
ELSE                                                                            ; Andernfalls wird ... 
  {
  IFEXIST, %A_SCRIPTDIR%\Images\Fensterpflege.exe                               ; ... in einem Unterverzeichnis "Images" des Skriptes nach einer vERSION DER FENSTERPFLEGE.EXE gesucht ... 
    iconfile = %A_SCRIPTDIR%\Images\Fensterpflege.exe                           ; ... und die Bitmaps in dieser Datei verwendet.                               
  ELSE                                                                          ; Wenn es diese Datei nicht gibt, werd ...
    iconfile = %A_AHKPATH%                                                      ; ... werden die AHK-Standardsymbole verwendet
  }
  Textbeep("iconfile=""" . iconfile . """")  ;### Nur zum Testen


; Namen, Erkl�rungstexte und Editierl�ngen der Pflegeparameter vorbereiten
parameter = category|title|txt|sleepms|keys|x|y|w|h                                      ; Namen der Einzelparameter f�r die Fensterpflege 
parameterlong = nr|%parameter%                                                           ; Lamge Liste der Parameter enth�lt auch die Nr. des Fensters
alltext_nr       := "Pflegenummer|"   .  "40|" . "Dies ist die Nummer der Pflegeanleitung."
alltext_category := "Kategorie|"      . "200|" . "Kategorie, zu der die Pflegeanleitung geh�rt (optional)" 
alltext_title    := "Fenstertitel|"   . "700|" . "Teil des Fenstertitels zur Wiedererkennung des zu pflegenden Fensters."
alltext_txt      := "Fenstertext|"    . "700|" . "Dies ist ein St�ck Text der irgendwo im Fenster steht. Wenn der Fenstertitel nicht eindeutig ist, dient dieser Text`n"
                                               . "der sichereren Identifikation des richtigen Fensters. Der Text ist optional, darf aber nur eine Zeile hoch sein."
alltext_sleepms  := "Wartezeit (ms)|" .  "40|" . "Zeit, die gewartet wird, bevor die Fensterpflege beginnt.`n"
                                               . "Wenn hier 9999 steht, muss die Pflege manuell per ""ROLLEN-Taste""`n"
                                               . "ausgel�st werden. (n�tzlich bei Passworteingaben)"
alltext_keys     := "Tastenfolge|"    . "400|" . "Die Tasten, die an das Fenster gesendet werden sollen.`n"
                                               . "Sondertasten: {ENTER}{RIGHT}{LEFT}{DOWN}{UP}{TAB}{ESC}{F1} usw.`n"
                                               . "Variablen: %A_MMMM%, %A_YEAR%, %B_MM% (Vormonat),`n"
                                               . "%BBB_MM% (Vormonat-2), %B_YEAR% (Jahr des Vormonats).`n"
                                               . "Beispiel: ""%B_YEAR% %BBB_MM%-%B_MM%"" erzeugt ""2008 10-12"".`n"
                                               . "F�r den Browser kann ein Suchbegriff in <...> eingef�gt werden,`n"
                                               . "der angesprungen werden soll. (nur mit IE 8.0 getestet)`n"
                                               . "Beispiel: ""<Benutzername>{TAB}mein_name"" springt zum Text`n"
                                               . """Benutzername"", geht mit TAB weiter und gibt mein_name ein."
alltext_x        := "x-Position|"      . "40|" . "Gew�nschte horizontale Fensterposition`n"
                                               . "(in Pixel, Wert l�schen, wenn keine Positionierung gew�nscht)."
alltext_y        := "y-Position|"      . "40|" . "Gew�nschte vertikale Fensterposition`n"
                                               . "(in Pixel, Wert l�schen, wenn keine Positionierung gew�nscht)."
alltext_w        := "Fensterbreite|"   . "40|" . "Gew�nschte Fensterbreite (in Pixel, Wert l�schen, wenn keine Breitenanpassung gew�nscht)."
alltext_h        := "Fensterh�he|"     . "40|" . "Gew�nschte Fensterh�he (in Pixel, Wert l�schen, wenn keine H�henanpassung gew�nscht)."
LOOP, PARSE, parameterlong, |                                                   ; �ber alle Parameternamen ...
  {
  STRINGSPLIT, outparts, alltext_%A_LOOPFIELD%, |                               ; ... die jeweilige Variable alltext<parametername> auseinandernehmen ... 
  name_%A_LOOPFIELD%    := outparts1 . ":"                                      ; ... und die einzelnen Textteile jeweils f�r Parametername ...
  width_%A_LOOPFIELD%   := outparts2                                            ; ... Breite des Erfassungsfeldes und ...
  comment_%A_LOOPFIELD% := outparts3 . "`n"                                     ; ... Parameterkommentar erfassen.
  }

; Zweitmonitor ermitteln (falls Fensterverschiebung nur, wenn Zweitmonitor da) 
SYSGET, monitors, MONITORCOUNT
Textbeep(monitors . " Monitore erkannt")

; Sequenzen einlesen und Fenster�berwachung vorbereiten 
Read_sequences()                                                                ; Pflegeanleitugen einlesen
WINGET, winlist, LIST                                                           ; Alle zu Programmstart existierenden Fenster als gepflegt betrachten
proofed_ids =
LOOP, %winlist%
  proofed_ids .= "|" . winlist%A_INDEX%
STRINGREPLACE, proofed_ids, proofed_ids,|                                       ; F�hrendes | entfernen
; Textbeep("Neue Liste der gepflegten Fenster: " . proofed_ids, "")     ;###
WINGETACTIVETITLE, last_window_title                                            ; Den aktiven Fenstertitel und die ID als letztes Fenster setzen 
WINGET, last_window_id, ID, A
insready =		                                                                  ; Pflegestufe am Anfang aus 
Textbeep(number_of_handlers . " Dialog-Routinen eingelesen, Bereitschaft hergestellt","start_fensterpflege")
GOSUB, refresh_vars                                                             ; Hilfsvariablen erstmalig einstellen und ...
SETTIMER, refresh_vars, 60000                                                   ; ... danach jede Minute aktualisieren
SETTIMER, refresh_id_list, 1000                                                 ; Liste der gepflegten Fenster rtegelm��ig s�ubern (Standardintervall: 1000ms)

; Fenster�berwachung starten
Resume_window_watching()
RETURN

;***************************************************************************************************
;***************************** Fenster�berwachung Kernmodul ****************************************
;***************************************************************************************************

; 1. Regelm��ig das aktuelle Fenster untersuchen
look_for_new_window:
  time_look_for_new_window := A_TICKCOUNT                                                  ; Zeit nehmen zur Ermittlung der "Pflegezeit"
  WINGETTITLE, current_window_title, A                                          ; Pr�fung des Titels, um auch ge�nderte Fenstertitel bei gleichem Fenster-id zu finden.
  WINGET, current_window_id, ID, A                                              ; ID ermitteln, um nachzuschauen, ob das Fenster schon da war.
  
  ; 2. Bedingungen f�r Fensternbehandlung pr�fen
  to_proof =                                                                    ; Grunds�tzlich wird erst mal nicht analysiert. 
  IF (current_window_id AND current_window_title)                               ; Weitere Betrachtung nur wenn es g�ltige Fenster-Information gibt (ID und Titel). 
    {
    IF (current_window_id = last_window_id)                                     ; Wenn das Fenster nicht gewechselt wurde ...
      IF (current_window_title <> last_window_title)                            ; ... aber der Fenstertitel sich ge�ndert hat ...
        {
        STRINGRIGHT, end_of_window_title, current_window_title,5                ; Pr�fen der Ausnahme (keine neue Untersuchung wennn ...
        ;Textbeep("end_of_window_title=""" . end_of_window_title . """")  ;### Nur zum Testen 
        IF end_of_window_title NOT IN %no_change_proof1%,%no_change_proof2%,%no_change_proof3%,%no_change_proof4%         ; ... es werden bestimmte Fenster genannt, bei denen ein Wechsel des Fenstertitels nicht zu einer Pflege f�hren sollen
          to_proof = 1                                                          ; ... wird das Fenster zur Untersuchung vorgemerkt.
        }
    ELSE                                                                        ; Wenn wir ein neues Fenster haben ...
      IF proofed_ids NOT CONTAINS %current_window_id%                           ; ... dass noch nicht untersucht wurde, ...
        to_proof = 1                                                            ; ... ist ebenfalls eine neue Untersuchung vonn�ten.
    }
  
  ; 3. Fenster untersuchen
  IF to_proof                                                                   ; Wenn wir festgestellt haben, dass eine Untersuchung vonn�ten ist ...
    {
    Pause_window_watching()                                                     ; ... Timer zur Fensterbeobachtung vor�bergehend ausschalten ...
    IF Proofsound                                                               ; ... und ggf. Untersuchungssound anmachen, ...
      SETTIMER, searchsound, 10
    IF proofed_ids NOT CONTAINS %current_window_id%                             ; Wenn das aktuelle Fenster noch nicht gepr�ft wurde...
       proofed_ids .= "|" current_window_id                                     ; ... Fenster id in die Liste der untersuchten Fenster aufnehmen
    found_nr := Window_found(current_window_id)                                 ; ... und schlie�lich untersuchen, ob es eine Pflegeanleitung daf�r gibt ...
    SETTIMER, searchsound, OFF                                                  ; ... und danach den Untesuchungssaound ausschalten.
    
  ; 4. Fenster pflegen
    IF found_nr                                                                 ; Wenn es eine Pflegeanleitung f�r das betrachtete Fenster gibt ...
      {
      IF (wsleepms%found_nr% = "9999")                                          ; ... je nachdem, ob eine "Pflegestufe" hinterlegt wurde ...
        make_insready()                                                         ; ... die Pflegestufe herstellen ...
      ELSE                                                                      ; ... oder das Fenster normal pflegen
        handle_window(found_nr,current_window_id)
      }
    IF NOT INSREADY
      Resume_window_watching()                                                    ; ... Timer zur Fensterbeobachtung wieder einschalten ...
    }
  
  ; 5. Letzte Fensterdaten merken 
  last_window_title := current_window_title                                     ; Fenstertitel merken, damit k�nftige �nderungen erkannt werden k�nnen.
  last_window_id := current_window_id
RETURN


;***************************************************************************************************
;*************************** Fenster�berwachs-Hilfsprogramme ***************************************
;***************************************************************************************************

;********************************* Fenster�berwachung tempor�r ausschalten **********************
Pause_window_watching()
  {
  GLOBAL
  Make_not_insready()                                                           ; Pflegestufe ausschalten (falls an)
  SETTIMER, look_for_new_window, OFF                                            ; �berwachungstimer ausschalten
  MENU, TRAY, ICON,%iconfile%,5                                                 ; Taskleistensymbol auf Rot setzen
  ;Textbeep("Fensterbeobachtung wurde unterbrochen.","leise")
  }


;********************************* Fenster�berwachung wieder einschalten **********************
Resume_window_watching()
  {
  GLOBAL
  SETTIMER, look_for_new_window, %Look_for_new_window_time_intervall%           ; Fenster wurde erfasst und behandelt - �berwachung neustarten
  MENU, TRAY, ICON,%iconfile%,1                                                 ; Taskleistensymbol wieder auf gr�n
  ;Textbeep("Fensterbeobachtung wurde aufgenommen.","leise")
  }

;********************************* Fenster�berwachung tempor�r ausschalten **********************
searchsound:
  SOUNDBEEP,100,5
RETURN


;******************* Pflegestufe einschalten ***************************************************
Make_insready()
  {
  GLOBAL
  insready := found_nr
  SETTIMER, look_for_new_text, 400                                              ; Regelm��ig nachschauen, ob das Fenster noch den gleichen Text enth�lt
  MENU, TRAY, ICON,%iconfile%,3                                                 ; Taskleistensymbol auf gelb
  Textbeep("Eingabebereitschaft hergestellt!","pflegestufe_an")
  }


;******************* Pflegestufe ausschalten ****************************************************
Make_not_insready()
  {
  GLOBAL
  IF insready
    Textbeep("Eingabebereitschaft beendet!","pflegestufe_aus")
  insready =
  SETTIMER, look_for_new_text, OFF                                              ; Text�berwachung ausschalten
  SETTIMER, look_for_new_window, %Look_for_new_window_time_intervall%           ; Fenster wurde erfasst und behandelt - �berwachung neustarten
  MENU, TRAY, ICON,%iconfile%,1                                                 ; Taskleistensymbol wieder auf gr�n
  }

; Externen Programmen erm�glichen, per Taste auf den Abschluss einer Fensterpflege zu warten
;^#+SCROLLLOCK::
;  WHILE NOT insready
;    SLEEP, 200 
;RETURN


; Bei "Pflegestufe" muss auch bei identischem Fenster �berwacht werden, ob sich der Text �ndert (Verlassen Loginseite o.�.)   
look_for_new_text:
  IFWINNOTACTIVE, AHK_ID %current_window_id%, % wtxt%found_nr%                  ; Pr�fen, ob das eingabebereite Fenster noch den gleichen Text enth�lt
    IF insready
      {
      Textbeep("Fenster nicht mehr aktiv.")
      Make_not_insready()
      }
RETURN


; Hier wird die Liste der gepr�ften Fenster aktualisiert und um die Fenster vermindert, die zwischenzeitlich geschlossen wurden
; Diese Aktualisierung kostet nach Messungen unter 1 ms Zeit
refresh_id_list:
  ; Textbeep("Alte Liste der gepflegten Fenster: """ . proofed_ids . """")
  new_proofed_ids=
  WINGET, winlist, LIST                                                         ; Liste der exisitierenden Fenster abrufen ...
  LOOP, %winlist%                                                               ; ... jeden existierenden Fenstertitel ...
    {
    i := A_INDEX
    LOOP, PARSE, proofed_ids, |                                                 ; ... mit den einzelnen gepr�ften Fenstern vergleichen ... 
      IF (A_LOOPFIELD  = winlist%i%)                                            ; ... und nur wenn das gepflegte Fenster in der Liste noch existiert ...
         new_proofed_ids .= "|" . A_LOOPFIELD                                   ; ... wird dessen id in die neue Liste �bernehmen.
    }
  STRINGREPLACE, new_proofed_ids, new_proofed_ids,|                             ; Das erste (f�hrende) | wird aus der Liste entfernt.  
  proofed_ids := new_proofed_ids
RETURN

; Liste der gepflegten Fenster l�schen (Neuinitialisierung der Pflege)
#+F24::
#+SC046::
  Textbeep("`n***************Pflege manuell aktivieren (Statusinfo) *************")
  Textbeep("Zuletzt behandeltes Fenster: """ . last_window_title . """")
  Textbeep("Aktuelles Fenster hat ID """ . WINACTIVE("A") . """")
  Textbeep("Liste der behandelten Fenster """ . proofed_ids . """ wird zur�ckgesetzt.")
  Textbeep("*************Pflege manuell aktivieren (starten) *************")
  proofed_ids =
  last_window_title =
RETURN

; Variablen, die regelm���ig neu belegt werden sollen
refresh_vars:
  akt_monat := A_MM
  B_MM    := akt_monat<2 ? 12+akt_monat-1 : akt_monat-1                         ; vorherige Monatsnummer im Format 05
  BBB_MM  := akt_monat<4 ? 12+akt_monat-3 : akt_monat-3                         ; vorvorvorherige Monatsnummer
  IF STRLEN(B_MM) < 2                                                           
    B_MM=0%B_MM%                                                                ; f�hrende Null bei Monatsnummer sicherstellen
  IF STRLEN(BBB_MM) < 2
    BBB_MM=0%BBB_MM%                                                            ; f�hrende Null bei Monatsnummer sicherstellen
  B_YEAR    := akt_monat<2 ? A_YEAR-1 : A_YEAR                                  ; Jahr des Vormonats
RETURN

;***************************************************************************************************
;************************* Registierung eines neuen Pflegefensters *********************************
;***************************************************************************************************
SC046::                                                                         ; SCROLLLOCK                    
  IFWINEXIST, Halwegs Fensterpflege: Pflegeanleitungen verwalten                  ; Wenn gerade die Tabelle offen ist, w�rden wir durcheinander kommen 
    MSGBOX, 0, Halwegs Fensterpflege, Sie bearbeiten gerade Ihre Pflegeanleitungen, Neuerfassung nicht m�glich!
  ELSE IF insready			                                                          ; Es besteht eine Pflegestufe, also nur pflegen und keine neue Pflegeanleitung aufnehmen
    {
    Pause_window_watching()
    handle_window(found_nr, current_window_id)
    Resume_window_watching()
    }
  ELSE                                                                            ; Keine Pflegestufe, also tats�chlich neues Pflegefenster registrieren  
    {
    Pause_window_watching()
    new_nr := number_of_handlers + 1                                              ; Ab hier werden der Daten des neuen Fensters voreingetragen 
    WINGET, new_id, ID , A                                                        ; Erst mal kl�ren, welches Fenster wir hier bearbeiten wollen
    WINGETTITLE, wtitle%new_nr%, AHK_ID %new_id%
    MSGBOX, 1, Halwegs Fensterpflege, % "Wollen Sie eine ""Pflegeanleitung"" f�r das Fenster mit dem Titel """ . wtitle%new_nr% . """ erfassen?", 5
    IFMSGBOX, OK                                                                  ; Benutzer best�tigt die Registrierung einer neuen Pflegeanleitung
      {
      SLEEP, 500
      ; Daten zum Fenster sammeln
      WINGETTEXT, all_window_text, AHK_ID %new_id%
      STRINGLEFT, wtxt%new_nr%, all_window_text, 1000                             ; Nur die 1000 ersten Zeichen f�r den Fenstertext verwerten
      WINGETPOS, wx%new_nr%,wy%new_nr%,ww%new_nr%,wh%new_nr%,AHK_ID %new_id%
      IF Edit_window_handler(new_nr)                                              ;** Editor starten, weiter wenn Fenster erfolgreich editiert
        {
        number_of_handlers := new_nr
        MSGBOX, 1, Halwegs Fensterpflege, % "Soll die neue Pflegeanleitung jetzt auf das Fenster """ . wtitle%new_nr% . """ angewendet werden?"
        IFMSGBOX, OK
          handle_window(new_nr,new_id)
        }  
      }        
      Resume_window_watching()
    }
RETURN

;***************************************************************************************************
;****************************************** Verwalten der Pflegeanleitungen ************************
;***************************************************************************************************

#SC046::   ;WIN-Scrollock
; Erst mal den Bereitschaftsmodus auschalten
Pause_window_watching()

; Nun die GUI aufbauen
; Listview-Titelzeile
GUI, ADD, LISTVIEW,GListviewlabel GRID X5 W%list_width% R%list_rows% -MULTI  NOSORTHDR -LV0x10,Nr|Kategorie|Fenstertitel|Fenstertext|ms|Tasten|X|Y|Breite|H�he|  
; Listview Zeilen
LOOP, %number_of_handlers%                                                                                                                     
  LV_ADD("",A_INDEX,wcategory%A_INDEX%,wtitle%A_INDEX%,wtxt%A_INDEX%,wsleepms%A_INDEX%,wkeys%A_INDEX%,wx%A_INDEX%,wy%A_INDEX%,ww%A_INDEX%,wh%A_INDEX%)
; Gr��e der Spalten einstellen
LV_MODIFYCOL(1,"23 INTEGER")		; Nr.
LV_MODIFYCOL(2,100*list_width/1100)			        ; Kategorie
LV_MODIFYCOL(3,230*list_width/1100)			        ; Title
LV_MODIFYCOL(4,320*list_width/1100)		         	; Text
LV_MODIFYCOL(5, 40*list_width/1100)			        ; Sleep (ms)
LV_MODIFYCOL(6,230*list_width/1100)		       	  ; Keys
LV_MODIFYCOL(7, 40*list_width/1100)			        ; X
LV_MODIFYCOL(8, 40*list_width/1100)			        ; Y
LV_MODIFYCOL(9, 40*list_width/1100)		       	  ; Width
LV_MODIFYCOL(10,40*list_width/1100)		        	; Hight
LV_MODIFY(1,"FOCUS SELECT VIS")
; Buttons hinzuf�gen
GUI, ADD, BUTTON,X5   W130 DEFAULT        , Eintrag &editieren
GUI, ADD, BUTTON,X+15 W130                , Eintrag &duplizieren
GUI, ADD, BUTTON,X+15 W130                , Eintrag &l�schen
GUI, ADD, BUTTON,X+15 W130                , Eintrag nach &oben
GUI, ADD, BUTTON,X+15 W130                , Eintrag nach &unten
GUI, ADD, BUTTON,X+75 W130                , E&instellungen
GUI, ADD, BUTTON,X+15 W25                 , ?
GUI, ADD, BUTTON,X+15 W130                , &Schlie�en
; GUI anzeigen
GUI, SHOW,,Halwegs Fensterpflege: Pflegeanleitungen verwalten
RETURN

; Tasten f�r GUI definieren
#IFWINACTIVE, Pflegeanleitungen verwalten
!DOWN::GOSUB,BUTTONEintragNachUnten
!UP::GOSUB, BUTTONEintragNachOben
DEL::GOSUB, BUTTONEintragL�schen
ESC::GOSUB, BUTTONSchlie�en
F1::GOSUB,BUTTON?
#IFWINACTIVE

GUICLOSE:
BUTTONSchlie�en:
GUI, DESTROY
Resume_window_watching()
RETURN

BUTTONEintragL�schen:			                                                      ; L�schen einer einzelnen Pflegeanleitung
delete_nr := LV_GETNEXT()
GUI, +DISABLED
IF delete_window_handler(delete_nr)                                             ; Wenn gel�scht wurde, dann ... 
  {
  LOOP, %number_of_handlers%                                                    ; ... Listview neu zeichen ...
    LV_MODIFY(A_INDEX,"",A_INDEX,wcategory%A_INDEX%,wtitle%A_INDEX%,wtxt%A_INDEX%,wsleepms%A_INDEX%,wkeys%A_INDEX%,wx%A_INDEX%,wy%A_INDEX%,ww%A_INDEX%,wh%A_INDEX%)
  LV_DELETE(number_of_handlers+1)                                                                ; ... und die letzte Zeile l�schen ...
  LV_MODIFY(delete_nr <= number_of_handlers ? delete_nr : number_of_handlers,"FOCUS SELECT VIS") ; ... und die Markierung auf die n�chste Zeile setzen, wenn m�glich
  }                                                                 
GUI, -DISABLED
GUI, SHOW
RETURN


BUTTONEintragEditieren:                                                         ; Button "Editieren" bet�tigt oder ...
Listviewlabel:                                                                  ; ... Doppelklick auf eine Zeile im Listview
edit_nr := LV_GETNEXT()
GUI, +DISABLED                                                                  ; Pflegeliste vor�bergehend deaktivieren
IF Edit_window_handler(edit_nr)                                                 ; Falls ge�ndert wurde, Listview aktualisieren
  LV_MODIFY(edit_nr,"",edit_nr,wcategory%edit_nr%,wtitle%edit_nr%,wtxt%edit_nr%,wsleepms%edit_nr%,wkeys%edit_nr%,wx%edit_nr%,wy%edit_nr%,ww%edit_nr%,wh%edit_nr%)
GUI, -DISABLED                                                                  ; Pflegeliste wieder aktivieren
WINACTIVATE, Halwegs Fensterpflege: Pflegeanleitungen verwalten
RETURN

BUTTONEintragDuplizieren:		                                                    ; Einzelnen Eintrag duplizieren (als letztes in die Liste stellen)
duplicate_nr := LV_GETNEXT()
new_nr := number_of_handlers + 1
LOOP, PARSE, parameter,|
  w%A_LOOPFIELD%%new_nr% := w%A_LOOPFIELD%%duplicate_nr%
IF NOT Write_new_sequence(new_nr)
  MSGBOX, Konnte neue Pflegeanleitung nicht speichern
ELSE                                                                            ; Listview aktualisieren
  {
  LV_ADD()
  LV_MODIFY(new_nr,"FOCUS SELECT VIS",new_nr,wcategory%new_nr%,wtitle%new_nr%,wtxt%new_nr%,wsleepms%new_nr%,wkeys%new_nr%,wx%new_nr%,wy%new_nr%,ww%new_nr%,wh%new_nr%)
  number_of_handlers += 1
  }
WINACTIVATE, Halwegs Fensterpflege: Pflegeanleitungen verwalten
RETURN

BUTTONEintragNachUnten:
Swap_rows(LV_GETNEXT(),LV_GETNEXT()+1)
RETURN

BUTTONEintragNachoben:
Swap_rows(LV_GETNEXT(),LV_GETNEXT()-1)
RETURN

BUTTONEinstellungen:
GUI, +DISABLED
Settings_Dialog(settingstext,Inifile)
GUI, -DISABLED
WINACTIVATE, Halwegs Fensterpflege: Pflegeanleitungen verwalten
RETURN

BUTTON?:
MSGBOX,,HALWEGS FENSTERPFLEGE,%helptext%
RETURN


;***************************************************************************************************
;******************************* Funktionen ********************************************************
;***************************************************************************************************
   
;******************* Einzelne Pfleganleitung bearbeiten *****************************************
Edit_window_handler(fedit_nr)   
{
GLOBAL
fchanged = 0
IFWINEXIST, Halwegs Fensterpflege: Pflegeanleitungen verwalten
  {
  LOOP, PARSE, parameter, |                                                     ; Werte vor dem Editieren speichern, da wir f�r die Plausi die Variablen �ndern m�ssen 
    save%A_LOOPFIELD% := w%A_LOOPFIELD%%fedit_nr%
  }

GUI, 2: ADD, TEXT,     X15   Y25   SECTION                   , % name_category
GUI, 2: ADD, EDIT,     X90   YS    W200 Vwcategory%fedit_nr% , % wcategory%fedit_nr%
GUI, 2: ADD, TEXT,     X90   YS+25                           , % comment_category                                                
GUI, 2: ADD, TEXT,     X310  YS                              , % name_title
GUI, 2: ADD, EDIT,     X375  YS    W415 Vwtitle%fedit_nr%    , % wtitle%fedit_nr%
GUI, 2: ADD, TEXT,     X375  YS+25                           , % comment_title                                                
GUI, 2: ADD, TEXT,     XS                                    , % name_txt
GUI, 2: ADD, EDIT,     X90   YP    W700 R10 Vwtxt%fedit_nr%  , % wtxt%fedit_nr%
GUI, 2: ADD, TEXT,     X90                                   , % comment_txt 
GUI, 2: ADD, GROUPBOX, XS-10 YS-20 W800 H260                 , Identifikationsdaten f�r Pfleganleitung Nr. %fedit_nr%
                                                      
GUI, 2: ADD, TEXT,     X15   Y290  SECTION                   , % name_sleepms
GUI, 2: ADD, EDIT,     X90   YP    W40  Vwsleepms%fedit_nr%  , % wsleepms%fedit_nr%
GUI, 2: ADD, TEXT,     X90                                   , % comment_sleepms
GUI, 2: ADD, TEXT,     X15                                   , % name_keys
GUI, 2: ADD, EDIT,     X90   YP    W350 Vwkeys%fedit_nr%     , % wkeys%fedit_nr%
GUI, 2: ADD, TEXT,     X90                                   , % comment_keys
GUI, 2: ADD, GROUPBOX, XS-10 YS-20 W450 H255                 , Wartezeit und zu sendende Tastenfolge
                                                      
GUI, 2: ADD, TEXT,     X480  YS                              , % name_x
GUI, 2: ADD, EDIT,     X550  YP    W40  Vwx%fedit_nr%        , % wx%fedit_nr%
GUI, 2: ADD, TEXT,     X630  YP                              , % name_w
GUI, 2: ADD, EDIT,     X700  YP    W40  Vww%fedit_nr%        , % ww%fedit_nr%
GUI, 2: ADD, TEXT,     X480  YS+25                           , % name_y
GUI, 2: ADD, EDIT,     X550  YP    W40  Vwy%fedit_nr%        , % wy%fedit_nr%
GUI, 2: ADD, TEXT,     X630  YP                              , % name_h
GUI, 2: ADD, EDIT,     X700  YP    W40  Vwh%fedit_nr%        , % wh%fedit_nr%
GUI, 2: ADD, BUTTON,   X480  YS+55                           , &Keine Fensterverschiebung                ;### DEFAULT eins tiefer!
GUI, 2: ADD, BUTTON,   X630  YP                              , &Fenstergr��e und Position testen
GUI, 2: ADD, GROUPBOX, X470  YS-20 W335 H110                 , Fensterpostion und -gr��e 

GUI, 2: ADD, BUTTON,   X675 Y500                             , &Abbrechen
GUI, 2: ADD, BUTTON,   X+5  YP                               , &Speichern
IFWINACTIVE, Halwegs Fensterpflege: Pflegeanleitungen verwalten
  {
  GUI, 2:+OWNER1
  GUI, 2: Show,,Halwegs Fensterpflege: Pflegeanleitung editieren
  }
ELSE
  GUI, 2: Show,,Neue Pflegeanleitung erfassen
GUI, 2: +LASTFOUND
WINWAITACTIVE
WINWAITCLOSE
GUI, 1: DEFAULT                                                                                     ; F�r die List-Funktionen muss die Tabelle als Standard-Dialog deklariert werden
RETURN, fchanged

2GUIESCAPE:
2GUICLOSE:
2BUTTONAbbrechen:
LOOP, PARSE, parameter, |                                                                           ; Werte vor dem Editieren wieder herstellen   
  w%A_LOOPFIELD%%fedit_nr% := save%A_LOOPFIELD%
GUI, 2: DESTROY
RETURN

2BUTTONSpeichern:                                                                                   ; Der Benutzer will die neue Pflegeanleitung Speichern
; Plausipr�fungen
GUI, 2: SUBMIT, NOHIDE                                                                              ; Erst mal speichern, um zu sehen, was in den Variablen ist
IF NOT wtitle%fedit_nr%  
  MSGBOX, 16, Halwegs Fensterpflege, Eine Pflegeanleitung ohne Fenstertitel kann nicht gespeichert werden!
ELSE IF NOT (wkeys%fedit_nr% OR wx%fedit_nr% OR wy%fedit_nr% OR ww%fedit_nr% OR wh%fedit_nr%)       ; Wurde wenigstens eine Pflege erfasst?
  MSGBOX, 16, Halweg's Fensterpflege, Es muss mindestens eine Pflegeanweisung enthalten sein`n(z. B. eine Tastenfolge) 
ELSE IF wtxt%fedit_nr% CONTAINS `n,`r 
    MSGBOX, 16, Halweg's Fensterpflege, Der Erkennungstext f�r das Fenster darf keine Zeilenumbr�che enthalten 
ELSE                                                                                                ; Die Pflegeanleitung ist brauchbar und kann verwendet werden
  {
  IF NOT Write_new_sequence(fedit_nr)
    MSGBOX, Konnte neue Pflegeanleitung nicht speichern
  ELSE
    {
    fchanged := fedit_nr
    GUI, 2: DESTROY
    }
  }
RETURN

2BUTTONFenstergr��eundPositiontesten:
GUI, 2: +DISABLED
GUI, 3: ADD, TEXT,          , Ziehen Sie dieses Fenster auf die gew�nschte Gr��e und Position
GUI, 3: ADD, BUTTON, DEFAULT, &Position speichern und schlie�en
GUI, 3: ADD, BUTTON, x+5 YP, &Abbrechen
GUI, 3: Color, aqua
GUI, 3: Font, CFFFFFF W700
GUI, 3: MARGIN, X0, Y0
GUI, 3: +RESIZE +OWNER2
x_set := wx%fedit_nr%>=0    ?  wx%fedit_nr% : 400                               ; Wenn es eine x-Position gibt -  diese nehmen, ansonsten 400 als Standardwert
y_set := wy%fedit_nr%>=0    ?  wy%fedit_nr% : 400                               ; Wenn es eine y-Position gibt -  diese nehmen, ansonsten 400 als Standardwert
w_set := ww%fedit_nr% < 358 ? 350           : ww%fedit_nr% - 8                  ; vorgeschlagene Breite mindestens 358 (Fensterrand verbreitert um 8 Pixel)  
h_set := wh%fedit_nr% < 75  ? 48            : wh%fedit_nr% - 27                 ; vorgeschlagene H�he mindestens 75 (Fenstertitel und -rand erh�ht um 27 Pixel)   
GUI, 3: Show, X%x_set% Y%y_set% W%w_set% H%h_set%, Halwegs Fensterpflege: Testfenster
RETURN

2BUTTONKeineFensterverschiebung:
GUICONTROL, 2:, wx%fedit_nr%
GUICONTROL, 2:, wy%fedit_nr%
GUICONTROL, 2:, ww%fedit_nr% 
GUICONTROL, 2:, wh%fedit_nr% 


3BUTTONAbbrechen:
3GUICLOSE:
3GUIESCAPE:
GUI, 3:DESTROY
GUI, 2:-DISABLED
GUI, 2: Show
RETURN

3BUTTONPositionspeichernundschlie�en:
WinGetPos, wx%fedit_nr%, wy%fedit_nr%, ww%fedit_nr%, wh%fedit_nr%, A
GUI, 3:DESTROY
GUI, 2:-DISABLED
GUI, 2:Show
GUICONTROL, 2:, wx%fedit_nr%, % wx%fedit_nr%
GUICONTROL, 2:, wy%fedit_nr%, % wy%fedit_nr%
GUICONTROL, 2:, ww%fedit_nr%, % ww%fedit_nr% 
GUICONTROL, 2:, wh%fedit_nr%, % wh%fedit_nr% 
RETURN
}


;******************* Alle Pflegeanleitungen neu einlesen ****************************************
Read_sequences()
  {
  GLOBAL
  LOOP                                                                          ; �ber alle Pfleganleitungen ...
    {
    i := A_INDEX                                                                 
    LOOP, PARSE, parameter,|                                                    ; ... und pro Pflegeanleitung i �ber alle Einzelparameter ...
      {  
      STRINGUPPER, current_key,A_LOOPFIELD,T                                    ; ... den aktuellen Parameter in "Titlecase" umwandeln (title ==> Title, text ===> Text, ...)
      INIREAD, w%A_LOOPFIELD%%i%, %Inifile%, %i%, %current_key%, %A_SPACE%      ; ... und dann den jeweiligen Parameterwert auslesen. 
      }
    IF wtitle%i% =                                                              ; Wenn keine Section i gefunden werden kann ...
      {
      number_of_handlers := i - 1                                               ; ... bedeutet das, dass wir am Ende der Pflegeanleitungen angelangt sind.
      BREAK
      }
    } 
  }


;******************* Einzelne Pfleganleitung l�schen ****0***************************************
delete_window_handler(fdelete_nr)
{
GLOBAL
fdeleted =
IF NOT wtitle%fdelete_nr%
  MSGBOX, Keine Zeile markiert
ELSE
  {
  MSGBOX, 36, Halwegs Fensterpflege, % "Pflegeanleitung f�r Fenster """ . wtitle%fdelete_nr% . """ l�schen?"
  IFMSGBOX YES                                                                  ; Einzelne Pflegeanleitung l�schen
    {
    LOOP, %number_of_handlers%                                                  ; Loop �ber alle Pflegeanleitungen
      {
      current_nr := A_INDEX
      next_nr := current_nr + 1
      IF (current_nr >= fdelete_nr)                                             ; Ab der zu l�schenden Pflegeanleitung ...
        {
        INIDELETE, %Inifile%, %current_nr%                                      ; ... diese zun�chst l�schen ...
        IF (current_nr < number_of_handlers)                                    ; ... und bis auf die letzte neu schreiben, aber jeweils die Parameter der nachfolgenden benutzen
          {
          LOOP, PARSE, parameter, |                                             ; Werte der jeweils folgenden Pflegeanleitung �bernehmen    
            w%A_LOOPFIELD%%current_nr% := w%A_LOOPFIELD%%next_nr%
          Write_new_sequence(current_nr) 
          }
        ELSE                                                                    ; bei der letzten (zu l�schenden) Pflegeanleitung die Variablen l�schen
          {
          LOOP, PARSE, parameter, |                                             ; Werte der jeweils folgenden Pflegeanleitung �bernehmen    
            w%A_LOOPFIELD%%current_nr% := 
          }
        }
      }
    number_of_handlers -=1                                                      ; Sequenzen wurden aktualisiert, nun noch den Z�hler zur�cksetzen 
    fdeleted = 1
    }
  }
RETURN, fdeleted
}


;******************* Einzelne Pfleganleitung speichern ******************************************
Write_new_sequence(save_nr)
{
GLOBAL
IF (wtitle%save_nr% AND save_nr)                                                ; Gibt es �berhaupt eine entsprechende Pflegeanleitung?
  {
  LOOP, PARSE, parameter,|                                                      ; �ber alle Parameter ...
    {  
    STRINGUPPER, current_key,A_LOOPFIELD,T                                      ; ... den jeweiligen Parameternamen in Titlecase umwandeln ... 
    IF w%A_LOOPFIELD%%save_nr%<>                                                  ; Und wenn es einen Wert dazu gibt
      INIWRITE, % w%A_LOOPFIELD%%save_nr%, %Inifile%, %save_nr%, %current_key%  ; ... diesen in die Inidatei schreiben.
    ELSE                                                                        ; Wenn es keinen Wert dazu gibt ...
      INIDELETE,                           %Inifile%, %save_nr%, %current_key%  ; ... den betreffenden Schl�ssel l�schen
    }
  RETURN, 1
  }
}


;******************* tauschen von zwei Pflegeanleitungen in der Position ************************
Swap_rows(move_nr, next_nr)
{
GLOBAL
IF (next_nr > number_of_handlers OR next_nr < 1)
  SOUNDPLAY, *16
ELSE
  {
  LOOP, PARSE, parameter, |
    {
    save%A_LOOPFIELD% := w%A_LOOPFIELD%%move_nr%
    w%A_LOOPFIELD%%move_nr% := w%A_LOOPFIELD%%next_nr%
    w%A_LOOPFIELD%%next_nr% := save%A_LOOPFIELD%
    }
  Write_new_sequence(move_nr)
  Write_new_sequence(next_nr)
  LV_MODIFY(move_nr,"",move_nr,wcategory%move_nr%,wtitle%move_nr%,wtxt%move_nr%,wsleepms%move_nr%,wkeys%move_nr%,wx%move_nr%,wy%move_nr%,ww%move_nr%,wh%move_nr%)
  LV_MODIFY(next_nr,"FOCUS SELECT VIS",next_nr,wcategory%next_nr%,wtitle%next_nr%,wtxt%next_nr%,wsleepms%next_nr%,wkeys%next_nr%,wx%next_nr%,wy%next_nr%,ww%next_nr%,wh%next_nr%)
  }
}


;******************* Aktives Fenster in Lister der Fenster suchen *******************************
Window_found(fnew_window_id)
  {
  GLOBAL
  ;Textbeep("Analyse beginnt.")                                                  ;### test
  ffound_nr := 0                                                                ; Interne Nr. der gfundenen Behandlungsroutine
  title_found_text = 
  text_found_text =
  time_analys_starts := A_TICKCOUNT - time_look_for_new_window
  
  WHILE (current_window_title = "Windows Internet Explorer" OR SUBSTR(current_window_title,1,5) = "http:")                      ; Falls ein IE-Fenster, m�ssen wir warten, bis die Titelzeile richtig lautet
    {
    SLEEP, 100
    WINGETTITLE, current_window_title, AHK_ID %fnew_window_id%
    }
  time_title_is_ready_for_analysis := A_TICKCOUNT - time_look_for_new_window

  time_first_title_found = 0
  fnew_text =
  number_of_textsearches = 0
  LOOP, %number_of_handlers%                                                    ; �ber alle Pflegeanleitungen ...
    {
    IF current_window_title CONTAINS % wtitle%A_INDEX%                          ; Wenn Fenstertitel in Pflegeliste steht, dann ...
      {
      IF NOT time_first_title_found                                             ; ... wenn es der erste gefundene Titel ist ...
        {
        time_first_title_found := A_TICKCOUNT - time_look_for_new_window  ; ... die Suchzeit ermitteln und ... 
        title_found_text := "Fenster """ . wtitle%A_INDEX% . """ gefunden. (nach "  
                           . time_analys_starts . " ms Start Fensteranalyse, nach " 
                           . time_title_is_ready_for_analysis . " ms titel kann analysiert werden, nach "
                           . time_first_title_found . " ms Titel gefunden.)"         ; ... und dem Nutzer mitteilen
        }
      IF wtxt%A_INDEX%                                                          ; Nun den Fenstertext �berpr�fen, falls zur Pflegeanleitung ein Text hinterlegt wurde.
        {
        number_of_textsearches += 1
        IF NOT fnew_text                                                        
          {
          ; Es wurde zu diesem Fenster noch kein Text ermittelt
          IF current_window_title CONTAINS Windows Internet Explorer            ; Bei einem Browserfenster ...
            {
            IF NOT wait_for_IE_ready_state(fnew_window_id)                      ; ... warten wir auf den Fertig-Status und ...
              BREAK                                                             ; ... falls der Fertig Status nicht hergestellt wurde, beenden wir die Fensteranalyse.
            }
          ELSE
            SLEEP, % A_TICKCOUNT - time_look_for_new_window < min_textsearch_time ? min_textsearch_time-(A_TICKCOUNT - time_look_for_new_window):0  ; ... bzw. lassen mindestens min_textsearch_time ms vergehen ...
          WinGetText, fnew_text, AHK_ID %fnew_window_id%                        ; ... und extrahieren dann den Fenstertext
          time_text_extracted := A_TICKCOUNT - time_look_for_new_window
          }
        IF fnew_text CONTAINS % wtxt%A_INDEX%                                   ; Nachschauen, ob der Text in der Pflegeanleitung im aktuellen Fenstertext gefunden wird
          {
          ffound_nr := A_INDEX                                                  ; Wenn der Text gefunden wurde, hei�t das, wir haben eine g�ltige Pflegeanleitung Nr. ffound_nr
          time_textmatch_found := A_TICKCOUNT - time_look_for_new_window        ; Kurz auf die Uhr sehen ...
          text_found_text :="Gefunden: Fenstertext """ . wtxt%A_INDEX% . """ (nach " 
                            . time_text_extracted . " ms Text extrahiert, nach "
                            . time_textmatch_found . " ms richtigen Text gefunden, "
                            . number_of_textsearches . " Fenstertexte gepr�ft)" ; ... und den Nutzer informieren.
          BREAK
          }
        }
      ELSE                                                                      ; Falls kein Text bei der gefundenen Pflegeanleitung gespeichert ist ...
        {
        ffound_nr := A_INDEX                                                    ; ... haben wir eine g�ltige Pflegeanleitung gefunden.
        BREAK
        }
      }
    }
  IF ffound_nr
    {
    Textbeep(title_found_text,"leise")
    Textbeep(text_found_text,"leise")
    }
  ;Textbeep("Analyse beendet.")                                                  ;### test
  RETURN, ffound_nr
  }

wait_for_IE_ready_state(wait_id)
  {
  ;Textbeep("Auf IE-Fertig warten ... ")                                  ;###test
  SLEEP, 500                                                                    ; noch mal kurz warten, ob nicht ein neues Fenster ge�ffnet wird
  returncode := 0
  WINGETTITLE, wintitle, AHK_ID %wait_id%
  IFWINACTIVE, AHK_ID %wait_id%
    {
    readystate_start := A_TICKCOUNT
    Textbeep("Warte auf Fertig-Status im Explorer-Fenster """ . wintitle . """ ...","leise",5000)
    ; Maus an den oberen linken Rand des Fenster verschieben
    ; W�rde sie irgendwo im Fenster stehen, k�nnte es sein, dass in der
    ; Statuszeile statt dem Wort "Fertig" ein Linktext erscheinen w�rde.
;     MOUSEGETPOS, x_altpos, y_altpos
;     WINGETPOS, x_left,y_left,,,A
;     MOUSEMOVE, x_left+10,y_left+5
    SETTITLEMATCHMODE, REGEX
    LOOP, 5
      {
      STATUSBARWAIT, Fertig|^$,10,,AHK_ID %wait_id%                             ; Wartet auf "Fertig" oder eine leere Statuszeile
      IF ERRORLEVEL                                                             ; Fenster wurde vorzeitig geschlossen
        BREAK
      IFWINNOTACTIVE, AHK_ID %wait_id%                                          ; Falls das Fenster nicht mehr aktiv ist - auch beenden
        BREAK
      SLEEP, 200
      }
    IF ERRORLEVEL=1
      Textbeep("  ... nach 20s kein ""Fertig"" im Statustext.","leise")
    ELSE IF ERRORLEVEL=2
      Textbeep("  ... Fenster wurde vor ""Fertig""-Status geschlossen.","leise")
    ELSE IFWINNOTACTIVE, AHK_ID %wait_id%                                       ; Falls das Fenster nicht mehr aktiv ist - auch beenden
      Textbeep("  ... Fenster nicht mehr aktiv.","leise")
    ELSE
      {
      Textbeep("  ... hergestellt nach" . A_TICKCOUNT - readystate_start . " ms.","leise")
      returncode := 1
      }
    ; alte Mausposition wieder herstellen
    ;MOUSEMOVE, x_altpos,y_altpos
    SETTITLEMATCHMODE, 2
    ;Textbeep("Auf IE-Fertig warten ... beendet.")                                  ;###test
    RETURN, returncode
    }
  }


;******************* einzelnes Fenster "pflegen" ************************************************
handle_window(fhandle_nr, fwindow_id)
  {
  GLOBAL
  window_handled = 0
  title_long := current_window_title
  Textbeep("Fenster wird gepflegt:","leise")
  
  ; 1. Ggf. bis zur Fensterpflege einen Moment warten
  IF (wsleepms%fhandle_nr%  AND  wsleepms%fhandle_nr% <> 9999)
    {
    remaining_sleeptime :=  wsleepms%fhandle_nr% - (A_TICKCOUNT - time_look_for_new_window)
    IF (remaining_sleeptime > 0)
      {
      Textbeep(" - " . wsleepms%fhandle_nr% . "ms warten (davon noch " . remaining_sleeptime . "ms �brig).","leise",remaining_sleeptime)
      SLEEP, % remaining_sleeptime
      }
    ELSE
      Textbeep(" - vorgesehene Wartezeit von " . wsleepms%fhandle_nr% . "ms ist bereits bei der Fenstererkennung vergangen.","leise")
    }
  
  ; 2. Danach noch mal pr�fen, ob das zu pflegende Fenster noch existiert
  IFWINNOTACTIVE, AHK_ID %fwindow_id%                                           ; Wenn das Fenster nicht mehr aktiv ist, dann
    Textbeep(" - Fenster """ . title_long . """ ist nicht mehr aktiv.","leise",500)
  ELSE                                                                            ; Fenster konnte aktiviert werden, jetzt pflegen!
    { 
    
    ; 3. Nun das Fenster ggf. an die richtige Position schieben
    IF wx%fhandle_nr% OR wy%fhandle_nr% OR  ww%fhandle_nr% OR  wh%fhandle_nr%   ; M�ssen wir �berhaupt verschieben?
      {
      ; 3.1 vorher pr�fen, ob im 1-Monitorbetrieb zu wenig Platz ist oder die Verschiebung nicht erw�nscht ist.
      IF    (monitors <= 1 AND ((wx%fhandle_nr% > A_SCREENWIDTH OR wy%fhandle_nr% > A_SCREENHEIGHT) OR  consider_monitor_count))
        Textbeep(" - Fenster kann nicht verschoben werden (Zweitmonitor fehlt?)","leise")
      ELSE
        {
        ; Nur die Koordinaten �ndern, die auch gesetzt sind 
        WINGETPOS x_act, y_act, w_act, h_act, AHK_ID %fwindow_id%
        x_set := wx%fhandle_nr%<>"" ? wx%fhandle_nr% : x_act                          ; Wenn kein x angegeben, dann aktuellen Wert verwenden 
        y_set := wy%fhandle_nr%<>"" ? wy%fhandle_nr% : y_act                          ; Wenn kein y angegeben, dann aktuellen Wert verwenden
        w_set := ww%fhandle_nr%
        h_set := wh%fhandle_nr%
        
        ; Nur verschieben, wenn das Fenster nicht schon an derrichtigen Position ist 
        IF (x_set = x_act AND y_set = y_act AND w_set = w_act AND h_set = h_act)
          Textbeep(" - Fenster an richtiger Position - Verschiebung nicht erforderlich","leise")
        ELSE
          {
          Textbeep(" - Fenster wird verschoben: X: " . x_set . ", Y: " . y_set . ", Breite: " . w_set . ", H�he: " . h_set,Shiftsound)
          WINRESTORE, AHK_ID %fwindow_id%                                       ; Fenstermaximierung entfernen
          WINMOVE, AHK_ID %fwindow_id%,,x_set, y_set, w_set, h_set              ; Fenster positionieren
          }
        }
      }
  
    ; 4. Nun Tasten senden, falls vorgegeben
    IF  wkeys%fhandle_nr%                                                       ; Sollen Tasten gesendet werden?
      {
      TRANSFORM, keys_to_send, DEREF, % wkeys%fhandle_nr%                       ; Durch TRANSFORM werden auch %var% - Einschl�sse (z.B. Systemvariablen) aufgel�st. 
      STRINGSPLIT, send_parts,keys_to_send,<>                                   ; Durchsuchen, ob ein <...> Bereich vorliegt (Suchen im Browser) 
      IF send_parts0 = 3
        {
        ; 4.1 Es soll zwischendurch eine Stelle im IE angesprungen werden
        Textbeep(" - Tasten """ . send_parts1 . """ werden gesendet.",Keysound)
        SEND, %send_parts1%
        Textbeep(" - Text """ . send_parts2 . """ wird gesucht.")

;       Suche f�r IE6
;       SEND, !bs                                                               ; alt f�r IE6
;       SLEEP, 200
;       SEND, %send_parts2%{ENTER}{ESC}                                         ; alt f�r IE6
;       SLEEP, 300

; Sucher f�r IE8
        Textbeep(" - Suche Text """ . send_parts2 . """ auf Internetseite.",Keysound)
        SEND, ^f                                                                ; Aufruf / Fokus Suchleiste
        SLEEP, 100
        SEND, %send_parts2%
        SLEEP, 300
        SEND, {F6}                                                              ; neu f�r IE8, ist noch im Test
        ; SLEEP, 5000
        Textbeep(" - Tasten """ . send_parts3 . """ werden gesendet.",Keysound)
        SEND, %send_parts3%
        }
      ELSE
        {
        ; 4.2 Nur Tasten senden
        Textbeep(" - Tasten """ . keys_to_send . """ werden gesendet.",Keysound)
        SEND, % keys_to_send
        }
      }
    window_handled = 1
    }
    
  RETURN, window_handled
  }


#INCLUDE IC_Settings.ahk
#INCLUDE IC_Textbeep.ahk