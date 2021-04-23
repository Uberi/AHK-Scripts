#include, gl.ahk ;OpenGL-Bibliothek für AutoHotkey einbinden
OnExit, ExitSub ;Springe vor dem Beenden des Programmes zum Label ExitSub
if (GL_WRAPPER_VERSION < 2.2) ;Überprüfe ob der OpenGL-Wrapper veraltet ist
{
  ;Wenn ja, gib den Benutzer bescheid und beende das Programm
  MsgBox, Die Version des OpenGL-Wrappers ist veraltet!`nDas Programm wird beendet!
  ExitApp
}

Gui, +LastFound +Resize ;Optionen für das Gui setzen
hGui := WinExist() ;Das Fensterhandle des Guis ermitteln

hDC := DllCall("GetDC", "uint", hGui, "uint") ;Ermittle den Devicekontext (Gerätekontext)
if (!hDC) ;Gab es Probleme?
{
  ;Wenn ja, lasse es den Benutzer wissen.
  MsgBox, Fehler beim erstellen des Devicekontextes!
  ExitApp ;Beende das Programm
}

PFD_Flags := PFD_DRAW_TO_WINDOW | PFD_SUPPORT_OPENGL | PFD_DOUBLEBUFFER ;Flags
PFD_Type := PFD_TYPE_RGBA ;Pixel Type
PFD_Bits := 24 ;Anzahl der Farbbits (24 bit = 16.777.216 Farben)
PFD_Depth := 16 ;Bits für den Tiefenbuffer (16 bit = 65.536 Einheiten)

VarSetCapacity(pfd, 40, 0) ;PIXELFORMATDESCRIPTOR-Struktur
NumPut(40, pfd, 0, "ushort") ;Größe der Struktur (muss 40 sein)
NumPut(1, pfd, 2, "ushort") ;Version der Struktur (muss 1 sein)
NumPut(PFD_Flags, pfd, 4, "uint") ;Flags
NumPut(PFD_Type, pfd, 8, "uchar") ;Pixel Type
NumPut(PFD_Bits, pfd, 9, "uchar") ;Anzahl der Farbbits
NumPut(PFD_Depth, pfd, 23, "uchar") ;Bits für den Tiefenbuffer

if (!SetPixelFormat(hDC, ChoosePixelFormat(hDC, &pfd), &pfd)) ;Wähle und benutze das Pixelformat
{
  ;Wenn das Pixelformat nicht benutzt werden kann, geht eine Message an den Benutzer.
  MsgBox, Das gewählte Pixelformat konnte nicht gesetzt werden!`nDas Programm wird beendet!
  ExitApp ;Beende das Programm
}

hRC := wglCreateContext(hDC) ;Erstelle einen Renderkontext
if (hRC=0) ;Konnte der Renderkontext erstellt werden?
{
  ;Wenn nicht, bekommt auch der Benutzer die Information.
  MsgBox, Fehler beim Erstellen des Renderkontextes!`nDas Programm wird beendet!
  ExitApp ;Beende das Programm
}
wglMakeCurrent(hDC, hRC) ;Nutze den Renderkontext für den Devicekontext

Gosub, InitOpenGL ;Springe zur Initialsierung von OpenGL
Gui, show, w640 h480, Tutorial 04 ;Zeige unser Gui

SetTimer, UpdateScene, 50 ;Setze den Timer für das Label UpdateScene auf 50 ms. (entspricht ~16 FPS)
return



InitOpenGL:
glClearColor(0, 0, 0, 0) ;Setze die Farbe, die beim Löschen des Buffers verwendet wird.
glShadeModel(GL_SMOOTH) ;Erlaube Smooth shading

FontList := glGenLists(256) ;Erstelle Displaylist für 256 Buchstaben
hFont := DllCall("CreateFont", "int", -16 ;Schriftgröße (0 = Standardgröße, <0 = Suche nächst beste Schriftgröße)
                             , "int", 0 ;Breite der Zeichen (0 = Verwende Standard)
                             , "int", 0 ;Vorschubswinkel (0 = Standard)
                             , "int", 0 ;Orientationswinkel (0 = Standard)
                             , "int", 700 ;Fett (100-1000, 0=Standard, 400=Normal, 800=Fett)
                             , "uint", 0 ;Kursiv (1=Ja, 0=Nein)
                             , "uint", 0 ;Unterstrichen (1=Ja, 0=Nein)
                             , "uint", 0 ;Durchgestrichen (1=Ja, 0=Nein)
                             , "uint", 0 ;Zeichensatz (0=ANSI-Zeichensatz)
                             , "uint", 4 ;Ausgabe-Präzision (4=Verwende TrueType wenn möglich)
                             , "uint", 0 ;Beschneidungs-Präzision (0=Standard)
                             , "uint", 4 ;Qualität (4=Antialiaste Qualität)
                             , "uint", 0 ;Schrift-Type (0=Standard)
                             , "str", "Arial") ;Schriftart (Arial, Verdana, Lucida Console, ...)
hOldFont := DllCall("SelectObject", uint, hDC, uint, hFont) ;Die Schriftart für den Device-Context wählen
wglUseFontBitmaps(hDC, 0, 256, FontList) ;Erstelle die Zeichen 0-255 (ANSI) für OpenGL

DllCall("SelectObject", "uint", hDC, "uint", hOldFont) ;Wähle alte Schriftart
DllCall("DeleteObject", "uint", hFont) ;Lösche neue Schriftart

CoordMode, Mouse, Screen ;Cursorkoordinaten ausgehend vom Bildschirm
return



UpdateScene: ;Unsere Zeichenroutine
glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT) ;Lösche den Farb- und Tiefenbuffer
glLoadIdentity() ;Stelle die Matrix wieder auf 0

MouseGetPos, CursorX, CursorY ;Ermittle Cursorposition
VarSetCapacity(point, 8, 0) ;Speicher für die Klientkoordinaten des Guis
DllCall("ClientToScreen", "uint", hGui, "uint", &point) ;Ermittle die Klientkoordinaten
TooltipX := CursorX - NumGet(point, 0, "int") + 15 ;Errechne Horizontale Position des OpenGL-Tooltips
TooltipY := ScreenH - (CursorY - NumGet(point, 4, "int") + 35) ;Errechne Vertikale Position des OpenGL-Tooltips

Text = ;Der Text des OpenGL-Tooltips
(Join`n
Text in OpenGL (Bitmap Fonts)
-----------------------------------------------
TooltipX = %TooltipX%
TooltipY = %TooltipY%
ScreenW = %ScreenW%
ScreenH = %ScreenH%
)

glListBase(FontList) ;Wähle die OpenGL-Schriftart
Loop, parse, Text, `n ;Lese jede Zeile des Textes
{
  CurrentLine := A_Loopfield ;Speichere aktuelle Zeile
  glRasterPos2f(TooltipX, TooltipY-((A_Index-1)*25)) ;Setze die Position der Textzeile
  glCallLists(StrLen(CurrentLine), (A_IsUnicode) ? GL_UNSIGNED_SHORT : GL_UNSIGNED_BYTE, &CurrentLine) ;Schreibe die Textzeile in OpenGL
}

SwapBuffers(hDC) ;Bringe das Gezeichnete auf das Gui
return



GuiSize: ;Wenn sich die Größe des Gui verändert...
ScreenW := A_GuiWidth ;Speichere Fensterbreite
ScreenH := A_GuiHeight ;Speichere Fensterhöhe
glViewport(0, 0, A_GuiWidth, A_GuiHeight) ;Setze den Viewport (der Bereich in dem Gezeichnet wird) auf die Größe des Guis

glMatrixMode(GL_PROJECTION) ;Wechsle zur Projektionsmatrix
glLoadIdentity() ;Stelle die Matrix wieder auf 0
glOrtho(0, ScreenW, 0, ScreenH, -1, 1) ;Wähle orthografische Ansicht (in Pixel)
glMatrixMode(GL_MODELVIEW) ;Wechsle zur Modelansichtmatrix
glLoadIdentity() ;Stelle die Matrix wieder auf 0
return



ExitSub: ;Bevor das Programm beendet wird...
glDeleteLists(FontList, 256) ;Lösche die Schriftart *NEU*
if (hRC) ;Haben wir einen gültigen Renderkontext?
{
  wglMakeCurrent(0, 0) ;Verwende keinen Renderkontext
  wglDeleteContext(hRC) ;Lösche den Renderkontext
}
FreeOpenGlLib() ;Gebe den speicher der OpenGL-Bibliothek frei.
ExitApp ;Beende das Programm entgültig.