/*
hallo,
ich möchte hier heute mal mein script zum spiegeln 2er verzeichnisse vorstellen,ich nutze es zum regelmäßigen sichern von daten auf externe festplatten:

im scriptverzeichnis wird eine ini-datei mit den einstellungen der pfade erstellt,ihr wird settings_ vorrangestellt.
es werden nur dateien und ordner kopiert/überschrieben,die im ziel nicht vorhanden oder älter sind!
anschliessend werden datum (erstell-u. änderungsdatum) der originalen ordner u. dateien übernommen und im quellverzeichnis nicht vorhandene im ziel gelöscht um eine echte 1:1 kopie zu erreichen.
kopierte und gelöschte dateien und ordner werden auf wunsch in einer logdatei aufgelistet.

änderungen:
* fehler bei suche nach xcopy korrigiert 12.07.2008 13:22:13 V2.0.5


* tauschen-button hinzugefügt  04.07.2008 17:42:02 v2.0.4

* ToolTip für Dateien zählen entfernt,dadurch Zeit fürs lesen geviertelt 17.06.2008 13:38:50  V2.0.3
* Ordner werden nicht mehr gezählt
* Log in CSV-Datei
* xcopy nur noch bei Dateien > 10mB

11.06.2008 19:13:42
* log in cop()funktion ausgelagert
* fehlerkontrolle erweitert
* msgboxen an guis geheftet
* xcopy-indikator
* copy_it abfragen verkürzt

10.06.2008 01:42:35
* kopiervorgang in xcopy ausgelagert um script bei großen dateien ansprechbar zu halten,falls auf dem system vorhanden

09.06.2008
* calc_kb eingefügt

08.02.2008
* speicheranzeige verbessert
* goto's entfernt

06.02.2008
*  eigene gui für status
*  eigene gui für "Die Quelldatei ist älter als das Ziel!"-meldung
*  dynamische speicheranzeige(kB,mB,GB)
*  datum wird,falls gewählt, für bessere performance direkt nach dem kopieren gesetzt(außer ordner)
*  in der ini-datei wird der log-status gespeichert
*  quelle aus pfaden entfernt,traytip ergänzt
*  logdaten werden um speicher zu sparen sofort in log gespeichert,statt in einer var
*/

SetBatchLines, -1
version = V2.0.5 vom 3:22 Samstag, 12. Juli 2008
P1 = %Path%
; ######################## xcopy suchen
ToolTip, xcopy wird gesucht...
Loop, Parse, P1, `;,
  {
    Line := A_LoopField
    If daisse
        Break
    Loop, %Line%\*.exe, 0,
      {
        If A_LoopFileName = xcopy.exe
          {
            daisse = %A_LoopFileLongPath%
            Break
          }
      }
  }
; daisse =

ToolTip
; ############### Vorbereitungen
  StringTrimRight, ScriptName, A_ScriptName, 4 ;ErweiteRung entfernen
  logfile = %ScriptName%_Log.csv
  ini = settings_%ScriptName%.ini
  IfNotExist, %ini% ; einstellungen bereits vorhanden?
      Gosub, FirstRun
  Else
      Gosub, inir
  ; ############### Gui 1
;   Gui +Resize
  Gui, Color, F4F3FF
  Gui, Font, s8, Verdana
  Gui, Add, GroupBox, x6 y7 w470 h50 vQuellverzeichnis, Quellverzeichnis
  Gui, Add, GroupBox, x6 y+20 w470 h50 vZielverzeichnis, Zielverzeichnis
  Gui, Add, Edit, x16 y27 w420 h20 vqordner, %qordner%
  Gui, Add, Edit, x16  y97 w420 h20 vziel, %ziel%
  Gui, Add, Button, x215 y58 w80 h25 vrestore grestore, tauschen
  Gui, Add, Button, x436 y27 w30 h20 vbrowsequelle gbrowsequelle, ...
  Gui, Add, Button, x436 y97 w30 h20 vbrowseziel gbrowseziel, ...
  Gui, Add, Button, x6 y147 w65 h30 -Wrap gstart Default, Start
  Gui, Add, Button, x+5 y147 w65 h30 -Wrap gabbruch, Abbruch
  Gui, Add, Checkbox, x+5 y147 w90 h30 Checked%log% vlogdatei, Logdatei erstellen
  Gui, Add, Checkbox, x+5 y147 w90 h30 Checked vdatum, Datum mit übertragen
  Gui, Font, cRed, Arial italic
  Gui, Add, Checkbox, x+5 y147 w150 h30 Checked vloesch, Überflüssiges im Ziel löschen
  Gui, Font, cgray, Arial italic
  Gui, Add, text, x5 Right y+5 w470, % (daisse ? "xcopy gefunden           " : "") . version
  Gui, Show, , %ScriptName% - 2 Verzeichnisse abgleichen
  ;   ###################### Gui 2
  Gui 2:Color, F4F3FF
  Gui 2:Font, s8, Verdana
  Gui 2:add, text, w470 bold vadatei, akt.Datei
  Gui 2:add, text, w120 vspeicher, Speicher in kb
  Gui 2:add, text, x+5 w80 vCounterd,
  Gui 2:add, text, x+5 w80 vCountero,
  Gui 2:add, text, x5 w270 vCounter, Zähler
  Gui 2:add, Progress, x5 w470 cBlue -Smooth vprog,
  Gui 2:add, Button, gabbruch, Abbruch
  Gui 2:add, text, x+5 CGray, % (daisse ? "kopiert wird mit xcopy" : "")
Return
; ################################# ENDE der Auto-execute Section

start:
  ; ######################Start########################


  Gui, Submit, NoHide
  if !ch
  {
  IniWrite, %logdatei%, %ini%, Settings, log ;in ini schreiben
  IfExist, %qordner%
      IniWrite, %qordner%, %ini%, Settings, qordner ;in ini schreiben
  IniWrite, %ziel%, %ini%, Settings, ziel ;in ini schreiben
  }
  gui, +OwnDialogs
  MsgBox, 65, Ordner Spiegeln - %ScriptName%, Kopiervorgang wird nun gesstartet`,nur im Ziel vorhandene Ordner und Dateien werden ohne Rückfrage gelöscht!`n`nvon hier wird kopiert : %qordner%`nhierher wird kopiert   : %ziel%, 15
  IfMsgBox, Cancel
    {
      Gui, Show, , %ScriptName% - 2 Verzeichnisse abgleichen
      Return
    }
  Gui, show, hide, ,
  IfNotExist, %qordner%
    {
      MsgBox, 16, Fehler!, Quellordner Existiert nicht!
      Gui, Show, , %ScriptName% - 2 Verzeichnisse abgleichen
      Return
    }
  IfExist, %A_ScriptDir%\%logfile% ;alte Logdatei löschen
      FileDelete, %A_ScriptDir%\%logfile%
  ; #################### Variablen erstellen
  wieviel = 0
  wievielo = 0
  wievielob = 0
  wievielk = 0
  wievielkb = 0
  wievieldel = 0
  err = 0
  fehler_Status =
  If loesch = 1
    {
      TrayTip, Löschen, Überflüssige Dateien im Ziel Suchen und Löschen, 20,
      ;   ####################### LÖSCHEN ##############################
      Loop, %ziel%\*.*, 1, 1 ;Ziel durchsuchen
        {
          StringLen, laenge, ziel ;Länge des Quellpfads
          StringTrimLeft, zielufile, A_LoopFileFullPath, %laenge% ;Quellpfad von aktuellen Datei entfernen
          IfNotExist, %qordner%%zielufile% ;ist die Zieldatei im Quellordner vorhanden?
            {
              IfInString A_LoopFileAttrib, D ;ist Ordner?
                FileRemoveDir, %A_LoopFileFullPath%, 1
              Else
                FileDelete, %A_LoopFileFullPath%
              If ErrorLevel
                {
                  FileAppend, % ";" append() . A_LoopFileFullPath . ";" ((InStr(A_LoopFileAttrib, "D")) ? "##Ordner##" : "") "##konnte nicht gelöscht werden##`n", %logfile%
                  err++
                  Continue
                }
              wievieldel ++
              FileAppend, % ";" append() . A_LoopFileFullPath . ";" . ((InStr(A_LoopFileAttrib, "D") = 0) ? calc_kb(A_LoopFileSize) : "#Ordner#") . ";wurde gelöscht!`n", %logfile%
              TrayTip, Löschen, Überflüssige Dateien im Ziel Suchen und Löschen`n%wievieldel%, 20,
            }

        }
    }
  TrayTip
; ################## Zählen###############
  ToolTip, Dateien zählen ...
  Loop, %qordner%\*.*, 0, 1
      alle++ ;Dateien zählen
  ToolTip
  ; ###################### Kopieren ####################
  Gui 2:show ;2. Gui zeigen
  Loop, %qordner%\*.*, 0, 0 ;nur Dateien im Root-Verzeichnis
    {
      wievielk++
      Gosub, setgui ;Gui2 anpassen
      IfNotExist, %ziel% ;Ordner nicht vorhanden?
        {
          FileCreateDir, %ziel% ;Ordner erstellen
          if ErrorLevel
            {
              msgbox, 16, Fehler!, Der folgene Ordner konnte nicht im Ziel erstellt werden.`nAbbruch!`n%ziel%
              ExitApp
            }
          FileAppend, % ";" append() . ziel . ";#Ordner erstellt#`n", %logfile%
        }
      copy_it = n
      IfNotExist, %ziel%\%A_LoopFileName%  ; immer kopieren wenn im Ziel keine gleichnamige Datei ist
          copy_it = y
      Else
        {
          FileGetTime, time, %ziel%\%A_LoopFileName%
          EnvSub, time, %A_LoopFileTimeModified%, Seconds  ; Subtrahiert die ÄndeRungszeit der Quelle mit dem Ziel
          copy_it := (time < -1) ? "y" : (((allec = 1) and (time > 5)) ? "y" : "n")
          If (time > 5) and (allec != 1) and (nie != 1)
                {
                  ccc =
                  zdatei = %ziel%\%A_LoopFileName%
                  Gosub, createmsg ;Sicherheitsabfrage erstellen und zeigen
                }
        }
      If copy_it = y
        {
          cop(A_LoopFileFullPath, ziel . "\", ((FileExist(ziel . "\" . A_LoopFileName) ? "ü" : "n")))   ; Kopieren mit überschreiben
          If Datum = 1
              FileSetTime, %A_LoopFileTimeModified%, %ziel%\%A_LoopFileName%, C          
        }
    }
  ; ##################################
  Loop, %qordner%\*.*, 2, 1 ;nur Ordner und Unterordner
    {
      wievielo++
      StringLen, laenge, qordner
      StringTrimLeft, unterordner, A_LoopFileFullPath, %laenge%
      IfNotExist, %ziel%%unterordner%
        {
          FileCreateDir, %ziel%%unterordner%
          if ErrorLevel
            {
              msgbox, 16, Fehler!, Der folgene Ordner konnte nicht im Ziel erstellt werden.`nAbbruch!`n%ziel%%unterordner%`nDatenträger voll oder schreibgeschützt?
              ExitApp
            }
          wievielob ++
          FileAppend, % ";" append() . ziel . unterordner . ";#Ordner erstellt#`n", %logfile%
        }
      Loop, %qordner%%unterordner%\*.*, 0, 0 ;nur Dateien in Unterverzeichnissen
        {
          wievielk++
          Gosub, setgui
          copy_it = n
          IfNotExist, %ziel%%unterordner%\%A_LoopFileName%  ; immer kopieren wenn im Ziel keine gleichnamige Datei ist
              copy_it = y
          Else
            {
              FileGetTime, time, %ziel%%unterordner%\%A_LoopFileName%
              EnvSub, time, %A_LoopFileTimeModified%, Seconds  ; Subtrahiert die ÄndeRungszeit der Quelle mit dem Ziel
              copy_it := (time < -1) ? "y" : (((allec = 1) and (time > 5)) ? "y" : "n")
              If (time > 5) and (allec != 1) and (nie != 1)
                {
                  ccc =
                  zdatei = %ziel%%unterordner%\%A_LoopFileName%
                  Gosub, createmsg ;Sicherheitsabfrage erstellen und zeigen
                }
            }
          If copy_it = y
            {
              cop(A_LoopFileFullPath, ziel . unterordner . "\", ((FileExist(ziel . unterordner . "\" . A_LoopFileName) ? "ü" : "n")))
              If Datum = 1
                 FileSetTime, %A_LoopFileTimeModified%, %ziel%%unterordner%\%A_LoopFileName%, 
            }
        }
    }

  ; ##################### ENDE kopieren

  If datum = 1
    {
      TrayTip, Datum, Ordnerdatum anpassen..., 30,
      ;   ######################### DATUM
      Loop, %qordner%\*.*, 2, 1 ;Datum der Ordner anpassen
        {
          ww++
          StringLen, laenge, qordner ;Länge des Quellpfads
          StringTrimLeft, qordnerufile, A_LoopFileFullPath, %laenge% ;Quellpfad von aktuellen Datei entfernen 
          FileSetTime, %A_LoopFileTimeCreated%, %ziel%%qordnerufile%, C, 1, 0
          TrayTip, Datum, Ordnerdatum anpassen...`n%ww%, 30,
        }
    }
  TrayTip,

  ; ##################### FERTIG - Auswertung
  If ((wieviel + wievielob + wievieldel + err) = 0) ;wenn 0,nichts bearbeitet
    {
      gui 2: +OwnDialogs
      MsgBox, 64, Fertig! - %ScriptName%, Keine Dateien Bearbeitet!, 5
      ExitApp
    }
  speich := calc_kb(wievielkb)
  gelöscht := (wievieldel != 0) ? wievieldel . " Dateien oder Ordner im Ziel gelöscht!" : ""
  gui 2: +OwnDialogs
  MsgBox, % "Fertig!`n`n" . wieviel . " Dateien und " . wievielob . " Ordner kopiert(" . speich . " kopiert)`n" . gelöscht . "`n" . ((err = 0) ? "" : err . " Dateien oder Ordner konnten nicht korrekt verarbeitet werden!")
  FileAppend, % "`n`n------------------" . append() . "-------------------`nFertig!--Verarbeitet: " . wieviel . " Dateien und " . wievielob . " Ordner kopiert(" . speich . " kopiert)`n-----------------------------------------------------------------------------------------`n" . gelöscht . "`n" . ((err = 0) ? "" : err . " Dateien oder Ordner konnten nicht korrekt verarbeitet werden!") . "`n`n`n", %logfile%
  If Logdatei = 0
      FileDelete, %logfile%
  Else
      Run, notepad.exe %logfile%, , Max
  ExitApp


browsequelle:
  ch =
  FileSelectFolder, qordner, *%qordner%, , Von wo sollen die Dateien und Ordner kopiert werden? ;Ordner wählen
  If qordner =
    {
      MsgBox, Nichts gewählt!
      Return
    }
  GuiControl, , qordner, %qordner%
Return

browseziel:
  ch =
  FileSelectFolder, ziel, *%ziel%, 1, Wohin soll kopiert werden? ;Ordner wählen
  If ziel =
    {
      MsgBox, Nichts gewählt!
      Return
    }
  GuiControl, , ziel, %ziel%
Return
abbruch:
GuiClose3:
GuiClose:
  ExitApp

  ; ######################## Action-Gui anpassen
  ; statusfenster anpassen/aktualisieren
setgui:
  speich := calc_kb(wievielkb)
  GuiControl, 2:, adatei, % A_LoopFileName . "  " . calc_kb(A_LoopFileSize)
  GuiControl, 2:, speicher, %speich% kopiert
  GuiControl, 2:, Counter, % "Datei " wievielk " von " alle " in Arbeit(" (Round((100 / alle * wievielk), 1)) "%)"
  GuiControl, 2:, Countero, % (wievielob = 0) ? "" : wievielob " Ordner kopiert"
  GuiControl, 2:, Counterd, % (wieviel = 0) ? "" : wieviel " Dateien kopiert"
  GuiControl, 2:, prog, % (100 / alle) * wievielk
Return

; ######################## Ersetzen-Gui
; meldung:"Die Quelldatei ist älter als das Ziel!" erzeugen
createmsg:
  ccc =
  FileGetTime, time2, %zdatei%, M
  FormatTime, time2, %time2%,
  FileGetSize, kbmsg, %zdatei%,
  sizez := calc_kb(kbmsg)
  sizeq := calc_kb(A_LoopFileSize)
  FormatTime, timemsg, %A_LoopFileTimeModified%
  StringReplace, pp, A_LoopFileLongPath, %qordner%, , All
  txt =
    (
Die Quelldatei

%pp%  %sizeq%
%timemsg%

ist älter als das Ziel!

%pp%  %sizez%
%time2%

immer Ersetzen?
    )
  Gui 3:+AlwaysOnTop
  Gui 3:Color, F4F3FF
  Gui 3:Font, s8, Verdana
  IfExist, C:\WINDOWS\system32\shell32.dll
      Gui 3:Add, Picture, icon132 , C:\WINDOWS\system32\shell32.dll
  Gui 3:add, text, , %txt%
  Gui 3:add, Button, y+5 gersetzen, Ja,jedesmal Erstzen!
  Gui 3:add, Button, x+5 gersetzen, Ersetzen!
  Gui 3:add, Button, x+5 gersetzen Default, Nicht Ersetzen
  Gui 3:add, Button, x+5 gersetzen, Nie Ersetzen
  Gui 3:Show, Die Quelldatei ist älter als das Ziel!

WinWait, %A_ScriptName%, Ja`,jedesmal Erstzen!
WinWaitClose, %A_ScriptName%, Ja`,jedesmal Erstzen!
IfWinNotActive, %ScriptName% - 2 Verzeichnisse abgleichen
    WinActivate, %ScriptName% - 2 Verzeichnisse abgleichen
If ccc = Ja`,jedesmal erstzen!
  {
    allec = 1
    copy_it = y
  }
If ccc = Ersetzen!
    copy_it = y
If ccc = Nie Ersetzen
    nie = 1

Return

; ################ Welcher Button wurde geklickt
; welche option gewählt?
ersetzen:
  ccc = %A_GuiControl%
  Gui, Destroy
Return

firstrun: ;keine ini vorhanden
  FileSelectFolder, qordner, , , Von wo sollen die Dateien und Ordner kopiert werden? ;Ordner wählen
  If qordner =
    {
      MsgBox, Nichts gewählt!
      ExitApp
    }
  FileSelectFolder, ziel, , 1, Wohin soll kopiert werden? ;Ordner wählen
  If ziel =
    {
      MsgBox, Nichts gewählt!
      ExitApp
    }
  IniWrite, %qordner%, %ini%, Settings, qordner ;in ini schreiben
  IniWrite, %ziel%, %ini%, Settings, ziel ;in ini schreiben
  log = 1
Return

inir: ; ini lesen
  IniRead, log, %ini%, Settings, log, 1
  IniRead, qordner, %ini%, Settings, qordner,
  If qordner = Error
    {
      MsgBox, %ini% fehlerhaft`nggf. löschen!
      ExitApp
    }
  IniRead, ziel, %ini%, Settings, ziel,
  If ziel = Error
    {
      MsgBox, %ini% fehlerhaft`nggf. löschen!
      ExitApp
    }

Return

; ################ Funktion ##################
calc_kb(wievielb, nachkomma = 3) ; Übergabe von Bytes, Nachkommas- Rückgabe dynamisch(bytes,kB,mB,GB)
  {
    Return (wievielb > 1073741824) ? Round((wievielb / 1073741824), nachkomma) " GB" : ((wievielb > 1048576) ? Round((wievielb / 1048576), nachkomma) " MB" : ((wievielb > 1024) ? Round((wievielb / 1024),nachkomma) " kB" : wievielb . " bytes"))
  }

; ----------------------------------------------------------------------------
cop(d1, d2, par = "n")
  {
    global logfile, wieviel, wievielkb, daisse
    stats := (par = "n") ? "(neu kopiert)" : "(überschrieben)"
    if (!daisse or (A_LoopFileSizeMB < 10)) ; wenn xcopy nicht gefunden und datei kleiner 10mB
      FileCopy, %d1%, %d2%\%A_LoopFileName%, 1
    Else
      RunWait, xcopy.exe "%d1%" "%d2%" /F /H /K /Y /R, , hide
    If ErrorLevel
      {
        If ErrorLevel = 1
            fehler_Status := (daisse != "") ? "1  Es wurden keine zu kopierenden Dateien gefunden." : "Fehler beim kopieren"
        If ErrorLevel = 2
            fehler_Status = 2  Der Benutzer hat XCOPY durch Drücken von STRG+C beendet.
        If ErrorLevel = 4
            fehler_Status = ##!!FEHLER!!## 4 `n Datei konnte nicht kopiert werden!
        If ErrorLevel = 5
            fehler_Status = 5  Es ist ein Schreibfehler aufgetreten.
        MsgBox, 16, Fehler beim kopieren!, % A_LoopFileFullPath . "`n" . fehler_Status
        err++
      }
    Else
      {
        fehler_Status = 0  Die Dateie wurde fehlerfei kopiert.
        wieviel++
        wievielkb += %A_LoopFileSize%
      }
    set := wieviel ";" append() . d2 . A_LoopFileName . ";" . calc_kb(A_LoopFileSize) . ";" . fehler_Status . stats . ((!daisse or (A_LoopFileSizeMB < 10)) ? "" : "x")"`n"
    FileAppend, %set% , %logfile%
    Return
  }
/*
Die Beendigungscodes von XCOPY

In der folgenden Liste sind die möglichen Beendigungscodes aufgeführt und kurz erläutert:

0  Die Datei wurde fehlerfei kopiert.
1  Es wurden keine zu kopierenden Dateien gefunden.
2  Der Benutzer hat XCOPY durch Drücken von STRG+C beendet.
4  Es trat ein Initialisierungsfehler auf. Mögliche Ursachen: Es ist nicht genügend Arbeitsspeicher
vorhanden; die Kapazität des Datenträgers reicht nicht aus;
Sie haben einen unzulässigen Dateinamen eingegeben;
Sie haben in der Befehlszeile eine unzulässige Syntax verwendet.
5  Es ist ein Schreibfehler aufgetreten.
*/

append()
  { 
    Return A_DD "." A_MM "." A_YYYY " " A_Hour "." A_Min " Uhr " A_Sec "sec;"
  }


restore:
ch := (ch = 1) ? 0 : 1
GuiControl, , ziel, %qordner%
GuiControl, , qordner, %ziel%
Gui, Submit, NoHide
if ch
  {
  GuiControl, , restore, getauscht
  Gui, Font, Bold, Verdana ; So wird ein neuer Standardzeichensatz für das gesamte Fenster eingestellt.
  GuiControl, Font, restore ; So werden diese Einstellungen dem Control zugewiesen.
  }
Else
  {
  GuiControl, , restore, tauschen
  Gui, Font, norm, Verdana ; So wird ein neuer Standardzeichensatz für das gesamte Fenster eingestellt.
  GuiControl, Font, restore ; So werden diese Einstellungen dem Control zugewiesen. 
  }
Return
