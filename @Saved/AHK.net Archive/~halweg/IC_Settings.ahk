COORDMODE, MENU, RELATIVE
COORDMODE, PIXEL, RELATIVE
COORDMODE, TOOLTIP, RELATIVE
COORDMODE, MOUSE, RELATIVE
COORDMODE, CARET, SCREEN
DETECTHIDDENTEXT, ON
SETTITLEMATCHMODE, 2                                                            ; A window's title can contain WinTitle anywhere inside it to be a match. 

; AutoHotkey Version 1.0.48.03
; Language:           German Comments
; Platform:           Win XP, läuft auch unter Vista (und hoffentlich auch unter W7)
; Author:             Halweg (halweg|at|gmx.de)

/*
Verwendung
Die Variable "settingstext" enthält eine Sammlung von Einstellungswerten sowie deren Optionen. 
Mit Settings_Read() werden die entsprechenden Variablen befüllt. Werte, die in 
Inifile stehen werden übernommen, für andere Werte werden die Standardwerte (s.u.) genommen. 
Mit Settings_Dialog() wird ein Dialog zur Änderung der Werte angezeigt. Geänderte Werte, 
die vom Standardwert abweichen, werden in Inifile geschrieben.

Untentstehend ein (auskommentierter) Beispielaufruf der Settingsroutine. Er macht die Verwendung deutlich. 
settingstext besteht aus mehreren Textzeilen, die in dieser Reihenfolge dann auch im Dialogfenster erscheinen.
Eine Zeile, die mit einem * beginnt, definiert, dass die nachfolgenden Zeilen zu einer Gruppenbox zusammengefasst werden.
Ansonsten enthält jede Zeile fünf durch ein | getrennte Bereiche mit folgendem Inhalt:
Bereich1: Name der Variable
Bereich2: Standardwert der Variable (wird beim ersten mal verwendet bzw. wenn in der Inidatei kein anderer Wert enthalten ist)
Bereich3: Art der Varibale und ihrers Dialoges. Unterstützt wird:
          - Text oder Zahl (Bereich3 definiert die Anzahl Stellen)
          - Checkbox (Bereich3 enthält "CHECK,<Wert für nicht gecheckt>,<Wert für gecheckt>")
          - Dropdown (Bereich3 enthält "Wert1,Wert2,Wert3,...")
          - Tastenfolge (Bereich3 enthält "KEY")
Bereich4: Prompt der Variable, wie er im Dialog erscheinen soll
Bereich5: Hilfetext zur Variable, der in einem gelben Tooltip erscheint, wenn man den Mauszeiger auf das Feld hält.

Untenstehend ein Beispielaufruf. Diese Settingsroutinen werden in HALWEGS FENSTERPFLEGE verwendet.
Zur Verbalisierung der geänderten Einstellungen mit der Funktion Textbeep(Text) 
wird das Modul IC_Textbeep.ahk (http://de.autohotkey.com/forum/viewtopic.php?p=26592) benötigt. (im Standard auskommentiert).    
*/
 

/*
; Beispiel-Testdaten (Auszug aus HALWEGS FENSTERPFLEGE)
;#t::
********* Testdaten ***********
Inidir = %A_APPDATA%\AutoHotkey\                                                ; Die Inidatei mit den Pflegeanleitungen wird standardmäßig unter Anwendungsdaten\Autohotkey angelegt
Inifile := Inidir . "test.ini"  

settingstext =
  (LTRIM
  *Allgemeine Einstellungen
  Look_for_new_window_time_intervall|200        |4                             |Analyseintervall in ms                     |Aller wieviel ms schaut Halwegs Fensterpflege nach, ob ein neues Fenster existiert.
  *Geräusche während der der Fensterpflege
  Proofsound                        |0          |CHECK,0,1                     |Analysegeräusch                            |Ein Rasseln, das ertönt, während Halwegs Fensterpflege das aktuelle Fenster analysiert.  
  Keysound                          |autoaktiv  |CHECK,leise,autoaktiv         |Tastengeräusch                             |Doppelpiepsen, das ertönt, wenn Tasten an das aktive Fenster gesendet werden.
  Shiftsound                        |verschieben|CHECK,leise,verschieben       |Verschiebegeräusch                         |Ein Surren, das ertönt, wenn Fenster verschoben werden.
  *Verbalisierung der Fensterpflege (grüne Textmeldungen)  
  Textbeep_default_showtime         |3000       |5                             |Anzeigedauer (ms)                          |Wie lange sollen die Texte jeweils angezeigt werden.
  Hotkey_to_freeze_the_tooltip      |+ß         |KEY                           |Taste zum Einfrieren der Textmeldung       |Tippen Sie eine Tastenkombination, mit der die Texte erneut aufgerufen werden können. 
  *Profi-Einstellungen
  Textbeep_max_rows                 |40         |3                             |Anzahl Tooltippzeilen (0 = keine Tooltipps)|Wieviele untereinanderliegende Zeilen sollen gleichzeitig angezeigt werden.  
  Textbeep_x                        |10         |4                             |Tooltipp X-Position                        |X-Position auf dem Monitor, wo die Tooltipps angezeigt werden sollen.
  Textbeep_y                        |300        |4                             |Tooltipp Y-Position                        |Y-Position auf dem Monitor, wo die Tooltipps angezeigt werden sollen.
  Textbeep_default_frequency        |1400       |4                             |Pieps-Frequenz-Basis                       |Standard-Frequenz für das Pflegegeräusch.
  Textbeep_default_textcolor        |Black      |Black,Maroon,Purple,Green,Gray|Tooltipptextfarbe                          |Farbe, in der die Tooltipps im Vordergrund erscheinen
  )
Settings_Read(settingstext,Inifile)
Settings_Dialog(settingstext,Inifile)
  
; Kontrollausgabe der Variablen (erfordert IC_Textbeep.ahk)
Textbeep("`n************Ergebnisse************")
LOOP,PARSE,settingstext,`n
  {
  STRINGSPLIT,parts,A_LOOPFIELD,|,%A_SPACE%
  IF (SUBSTR(parts1,1,1) <> "*")
    {
    var_content:=%parts1%
    Textbeep(parts1 . "=" . var_content)
    }
  }
RETURN
*/


Settings_Read(settings,settings_file)
; Liest die Standardwerte aus settings_file bzw. direkt aus settings und weist sie den Variablen zu 
; Gleichzeitig wird weitestgehend der korrekte Syntax dieser Variablen überprüft 
  {
  GLOBAL
  LOOP,PARSE,settings,`n                                                        ; Auswerten der Settings-Vorgaben nach Zeilen
    {
    STRINGSPLIT,parts,A_LOOPFIELD,|,%A_SPACE%                                   ; Analysieren der Teile gh´jeder Zeile 
    IF (SUBSTR(parts1,1,1) <> "*")                                              ; Variablenanalyse nur, wenn die aktuelle Zeile kein Gruppentitel ist
      {
      IF (parts0 <> 5)                                                          ; Enthält die aktuelle Zeile alle 5 Teile   
        Settings_Error("Einstellungstext Zeile`n""" . A_LOOPFIELD . """`nenthält " . parts0 . " statt 5 Werte")
      INIREAD,%parts1%,%settings_file%,Einstellungen,%parts1%,%parts2%          ; Versuch, die Variable aus dem Settings-File auszulesen 
      STRINGSPLIT, parts3parts,parts3,`,                                        ; Ermittlung der Einzelwerte des Bereichs3 
      ; Prüfung der  Werte 
      IF (parts3parts1="CHECK")                                                 ; Prüfen Checklistenvariable 
        {
        IF (parts3parts0 <> 3)                                                  ; Gibt es überhaupt 2 Vorgabewerte?                                                  
          Settings_Error("Variable`n" . parts1 . "`nin Settings enthält " . parts3parts0 - 1 . " statt 2 Vorgabewerten.")
        ELSE IF %parts1% NOT IN %parts3parts2%,%parts3parts3%                   ; Und ist der aktuelle Variablenwert darin enthalten? 
          Settings_error("Variable`n" . parts1 . "`nhat den Wert`n""" . %parts1% 
                       . """`nund entspricht damit keinem der Vorgabewerte`n""" . parts3parts2 . """ oder """ . parts3parts3 . """")      
        }
      ELSE IF (parts3parts0 > 1 AND NOT INSTR(parts3,%parts1%))                 ; Prüfen Liste von Vorgabeweten (Dropdown)
        Settings_error("Variable`n" . parts1 . "`nhat den Wert`n""" . %parts1% . """`nund entspricht damit keinem der Vorgabewerte`n""" . parts3 . """")
      ELSE IF (parts3="KEY")                                                    ; Prüfen Tastenkombination (aber nur auf Länge)
        {
        IF (STRLEN(%parts1%) > 10)
          Settings_error("Die vorbelegte Tastenfolge für`n" . parts1 . "`nist`n""" . %parts1% . """`nund damit keine gültige Tastenkombination.")  
        }
      ELSE IF (parts3parts0 = 1 AND parts3 > 10)                                ; Prüfen, on das Eingabefeld nicht zu groß definiert wurde 
        Settings_Error("Das Feldbreite für Variable`n" . parts1 . "`nist`n""" . parts3 . """`nstatt maximal 10.")
      ; Textbeep("Auslesen: Variable " . parts1 . "  Standardwert=""" parts2 """  Gelesen: """ . %parts1% . """")
      }
    }
  RETURN
  }


Settings_Dialog(settings,settings_file)
; Änderung der Settings per Dialo und schreiben der Änderungen in settings_file
  {
  GLOBAL
  group_text =
  LOOP,PARSE,settings,`n
    {
    STRINGSPLIT,parts,A_LOOPFIELD,|,%A_SPACE%                                   ; die Beschreibungszeile wird auseinandergenommen
    IF (SUBSTR(parts1,1,1) = "*")                                               ; Neuer Gruppentitel
      {
      ; 1. Dialoggruppe
      IF group_text                                                             ; Wenn schon eine Gruppierung aktiv ist, diese beenden
        {
        group_hight := group_lines * 30
        GUI, 4: ADD, GROUPBOX, X10  YS W400 H%group_hight% , % group_text       ; ... den dazugehörigen Rahmen der vorherigen Gruppe zeichen
        group_text = 
        }
      STRINGREPLACE, group_text,parts1,*                                        ; den neuen Grupentext erkennen
      IF group_text                                                             ; Wenn es einen neuen group_text gibt, dann neue Gruppe vorbereiten
        {
        IF A_INDEX = 1
          y_relative_position = 0
        ELSE
          y_relative_position = 15
        GUI 4: ADD, TEXT, X15 Y+%y_relative_position% SECTION,%A_SPACE%         ; mit einem Leertexteintrag den Beginn einer neuen Sektion markieren
        group_lines := 1
        }
      }
    ELSE                                                                        ; normaler Variableneintrag
      {
      hilfetext_%parts1% := parts5
      group_lines += 1
      GUI, 4: ADD, TEXT, X15  YP+30 RIGHT W210, %parts4%:                       ; Prompt zum Eingabefeld
      STRINGSPLIT, parts3parts,parts3,`,                                        ; Die Vorgabewerte analysieren, um zu ermitteln, welche Art von Wert dargestellt werden soll 
      IF (parts3parts1="CHECK")                                                 ; Checkbutton darstellen, vorher die Werte ermitteln und die Einstellung setzen
        {
        ; 2. Checkbox 
        IF (%parts1% = parts3parts2)                                            ; Wenn der aktuelle Wert der erste Vorgabewert ist ...
          GUI, 4: ADD, CHECKBOX, X230 YP V%parts1%                              ; ... eine Unchecked Checkbox darstellen
        ELSE IF (%parts1% = parts3parts3)
          GUI, 4: ADD, CHECKBOX, X230 YP V%parts1% CHECKED                      ; Wenn der aktuelle Wert ein
        ELSE
          Settings_Error("Checkbox-Variable " . parts1 . " hat falsche Vorbelegung (" . %parts1% . " statt """ . parts3parts2 . """ oder """ . parts3parts3 . """).")
        }
      ELSE IF (parts3parts0 >1)                                                  ; Gibt es eine Vorgabeliste
        {
        ; 3. Dropdown
        width = 0
        selected = 0
        LOOP, %parts3parts0%
          {
          width_i := STRLEN(parts3parts%A_INDEX%)*9
          width := width_i > width ? width_i : width
          selected := parts3parts%A_INDEX% = %parts1% ? A_INDEX : selected
          }
        IF NOT selected
          Settings_Error("Drop-Down-Variable " . parts1 . " hat falsche Vorbelegung (" . %parts1% . ").")
        GUI, 4: +DELIMITER`,
        GUI, 4: ADD,DROPDOWNLIST,X230 YP W20 W%width% CHOOSE%selected% V%parts1%,%parts3%
        }
      ELSE IF (parts3="KEY")                                                    ; Feld für eine Tastenkombination
        {
        ; 4. Hotkey
        GUI, 4: ADD, HOTKEY, X230 YP W170 V%parts1%,% %parts1%
        }
      ELSE                                                                      ; normales Eingabefeld
        {
        ; 5. normales Eingabefeld
        width := parts3*11
        GUI, 4: ADD, EDIT,      X230 YP  W%width% V%parts1% , % %parts1%  
        }
      }
    }
    IF group_text                                                               ; Wenn noch eine Gruppierung aktiv ist, diese beenden
      {
      group_hight := group_lines * 30
      GUI, 4: ADD, GROUPBOX, X10  YS W400 H%group_hight% , % group_text         ; ... den dazugehörigen Rahmen der vorherigen Gruppe zeichen
      group_text = 
      }

  GUI, 4: ADD,BUTTON,X15  Y+30, Abbrechen
  GUI, 4: ADD,BUTTON,X+30 YP,   Standardwerte
  GUI, 4: ADD,BUTTON,X+30 YP,   Speichern
  GUI, 4: Show,,Einstellungen bearbeiten 
  ONMESSAGE(0x200, "Mousemove_in_GUI4")
  GUI, 4: +LASTFOUND
  WINWAITACTIVE
  WINWAITCLOSE
  RETURN

  4BUTTONStandardwerte:
  LOOP,PARSE,settings,`n
    {
    STRINGSPLIT,parts,A_LOOPFIELD,|,%A_SPACE%
    IF parts3 CONTAINS CHECK
      {
      STRINGSPLIT, parts3parts,parts3,`,                                    ; Extrahieren der Einzelwerte aus dem dritten Parameter:
      GUICONTROL, 4:,%parts1%,% parts2 = parts3parts3 ? 1 : 0
      }
    ELSE
      GUICONTROL, 4:,%parts1%,%parts2%
    }
  RETURN

  4BUTTONSpeichern:
  GUI, 4: SUBMIT
  ; Geänderte Einstellungen speichern
  LOOP,PARSE,settings,`n
    {
    STRINGSPLIT,parts,A_LOOPFIELD,|,%A_SPACE%
    IF (SUBSTR(parts1,1,1) <> "*")                                            ; Nicht bei Gruppentitel
      {
      IF parts3 CONTAINS CHECK                                                ; Bei einer Check-Button werden die 1/0 Werte durch die Textwerte in der Liste ausgetauscht
        {
        STRINGSPLIT, parts3parts,parts3,`,                                    ; Extrahieren der Einzelwerte aus dem dritten Parameter:
        ; parts3parts0 muss 3 sein (wurde schon überprüft)
        ; parts3parts1 ist das Wort CHECK
        ; parts3parts2 ist der erste Vorgabewert (Unchecked)
        ; parts3parts3 ist der zweite Vorgabewert (Checked)
        %parts1% := %parts1% ?  parts3parts3 : parts3parts2                   ; Je nachdem, ob 1 oder 0 in der Variable steht, wird der 2. oder 1. Vorgabewert genommen
        }
      INIREAD,oldvar,%settings_file%,Einstellungen,%parts1%,%parts2%          ; Alten Wert auslesen und ...
      IF (oldvar<>%parts1%)                                                   ; ... wenn der neue Wert vom alten abweicht, ...
        {
        IF (%parts1%=parts2)                                                  ; ... und der neue Wert der Standard ist, den Schlüssel löschen
          {
          ;Textbeep(parts1 . ": alter Wert: """ . oldvar . """      Neuer Wert: """  . %parts1% . """ entspricht dem Standard, Schlüssel wird gelöscht.")
          INIDELETE,%settings_file%,Einstellungen,%parts1%
          }
        ELSE                                                                  ; Ansonsten den Schlüssel neu schreiben
          {
          ;Textbeep(parts1 . ": alter Wert: """ . oldvar . """      Neuer Wert: """  . %parts1% . """ wird gespeichert.")
          INIWRITE,% %parts1%,%settings_file%,Einstellungen,%parts1%
          }
        }
      }
    }
  GUI, 4: DESTROY
  ONMESSAGE(0x200,"")
  RETURN
  

  4BUTTONAbbrechen:
  ; Rücksetzen der gespeicherten Werte
  Settings_read(settings,settings_file)
  4GUIESCAPE:
  4GUICLOSE:
  GUI, 4: DESTROY
  ONMESSAGE(0x200,"")
  RETURN

  }

Mousemove_in_GUI4()
  {
  STATIC CurrControl,PrevControl
  CurrControl := A_GUICONTROL
  IF (CurrControl <> PrevControl AND NOT INSTR(CurrControl," "))
    {
    TOOLTIP       ; Alte Tooltipps aus
    SETTIMER, ZeigeTooltiphilfe,-1000
    PrevControl := CurrControl
    }
  RETURN

  ZeigeTooltiphilfe:
    TOOLTIP, % hilfetext_%CurrControl%
    SETTIMER,EntferneTooltip,-20000
    RETURN

    EntferneTooltip:
    TOOLTIP
    RETURN
  } 
 
Settings_Error(errortext)
  {
  MSGBOX, %errortext%
  EXITAPP
  }
