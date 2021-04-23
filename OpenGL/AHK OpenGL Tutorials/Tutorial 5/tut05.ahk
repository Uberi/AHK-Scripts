#include, gl.ahk ;OpenGL-Bibliothek f�r AutoHotkey einbinden
OnExit, ExitSub ;Springe vor dem Beenden des Programmes zum Label ExitSub
if (GL_WRAPPER_VERSION < 2.2) ;�berpr�fe ob der OpenGL-Wrapper veraltet ist
{
  ;Wenn ja, gib den Benutzer bescheid und beende das Programm
  MsgBox, Die Version des OpenGL-Wrappers ist veraltet!`nDas Programm wird beendet!
  ExitApp
}

Gui, +LastFound +Resize ;Optionen f�r das Gui setzen
hGui := WinExist() ;Das Fensterhandle des Guis ermitteln

hDC := DllCall("GetDC", "uint", hGui, "uint") ;Ermittle den Devicekontext (Ger�tekontext)
if (!hDC) ;Gab es Probleme?
{
  ;Wenn ja, lasse es den Benutzer wissen.
  MsgBox, Fehler beim erstellen des Devicekontextes!
  ExitApp ;Beende das Programm
}

PFD_Flags := PFD_DRAW_TO_WINDOW | PFD_SUPPORT_OPENGL | PFD_DOUBLEBUFFER ;Flags
PFD_Type := PFD_TYPE_RGBA ;Pixel Type
PFD_Bits := 24 ;Anzahl der Farbbits (24 bit = 16.777.216 Farben)
PFD_Depth := 16 ;Bits f�r den Tiefenbuffer (16 bit = 65.536 Einheiten)

VarSetCapacity(pfd, 40, 0) ;PIXELFORMATDESCRIPTOR-Struktur
NumPut(40, pfd, 0, "ushort") ;Gr��e der Struktur (muss 40 sein)
NumPut(1, pfd, 2, "ushort") ;Version der Struktur (muss 1 sein)
NumPut(PFD_Flags, pfd, 4, "uint") ;Flags
NumPut(PFD_Type, pfd, 8, "uchar") ;Pixel Type
NumPut(PFD_Bits, pfd, 9, "uchar") ;Anzahl der Farbbits
NumPut(PFD_Depth, pfd, 23, "uchar") ;Bits f�r den Tiefenbuffer

if (!SetPixelFormat(hDC, ChoosePixelFormat(hDC, &pfd), &pfd)) ;W�hle und benutze das Pixelformat
{
  ;Wenn das Pixelformat nicht benutzt werden kann, geht eine Message an den Benutzer.
  MsgBox, Das gew�hlte Pixelformat konnte nicht gesetzt werden!`nDas Programm wird beendet!
  ExitApp ;Beende das Programm
}

hRC := wglCreateContext(hDC) ;Erstelle einen Renderkontext
if (hRC=0) ;Konnte der Renderkontext erstellt werden?
{
  ;Wenn nicht, bekommt auch der Benutzer die Information.
  MsgBox, Fehler beim Erstellen des Renderkontextes!`nDas Programm wird beendet!
  ExitApp ;Beende das Programm
}
wglMakeCurrent(hDC, hRC) ;Nutze den Renderkontext f�r den Devicekontext

Gosub, InitOpenGL ;Springe zur Initialsierung von OpenGL
Gui, show, w640 h480, Tutorial 05 ;Zeige unser Gui

SetTimer, UpdateScene, 50 ;Setze den Timer f�r das Label UpdateScene auf 50 ms. (entspricht ~16 FPS)
return



InitOpenGL:
glClearColor(0, 0, 0, 0) ;Setze die Farbe, die beim L�schen des Buffers verwendet wird.
glShadeModel(GL_SMOOTH) ;Erlaube Smooth shading

FontList := glGenLists(256) ;Erstelle Displaylist f�r 256 Buchstaben
hFont := DllCall("CreateFont", "int", -16 ;Schriftgr��e (0 = Standardgr��e, <0 = Suche n�chst beste Schriftgr��e)
                             , "int", 0 ;Breite der Zeichen (0 = Verwende Standard)
                             , "int", 0 ;Vorschubswinkel (0 = Standard)
                             , "int", 0 ;Orientationswinkel (0 = Standard)
                             , "int", 100 ;Fett (100-1000, 0=Standard, 400=Normal, 800=Fett)
                             , "uint", 0 ;Kursiv (1=Ja, 0=Nein)
                             , "uint", 0 ;Unterstrichen (1=Ja, 0=Nein)
                             , "uint", 0 ;Durchgestrichen (1=Ja, 0=Nein)
                             , "uint", 0 ;Zeichensatz (0=ANSI-Zeichensatz)
                             , "uint", 4 ;Ausgabe-Pr�zision (4=Verwende TrueType wenn m�glich)
                             , "uint", 0 ;Beschneidungs-Pr�zision (0=Standard)
                             , "uint", 4 ;Qualit�t (4=Antialiaste Qualit�t)
                             , "uint", 0 ;Schrift-Type (0=Standard)
                             , "str", "Segoe UI Light") ;Schriftart (Arial, Verdana, Lucida Console, ...)
DllCall("SelectObject", uint, hDC, uint, hFont) ;Die Schriftart f�r den Device-Context w�hlen

VarSetCapacity(gmf, 256*24, 0)
wglUseFontOutlines(hDC, 0, 256, FontList, 0, 0.1, WGL_FONT_POLYGONS, &gmf) ;Erstelle die Zeichen 0-255 (ANSI) f�r OpenGL

DllCall("SelectObject", "uint", hDC, "uint", hOldFont) ;W�hle alte Schriftart
DllCall("DeleteObject", "uint", hFont) ;L�sche neue Schriftart

glEnable(GL_DEPTH_TEST) ;Tiefentest einschalten
glDepthFunc(GL_LEQUAL) ;Tiefenfunktion w�hlen
glHint(GL_PERSPECTIVE_CORRECTION_HINT, GL_NICEST) ;Korrektion f�r die Tiefe

VarSetCapacity(light, 16, 0) ;Speicher f�r die Lichteinstellungen

;Ambiente Lichtwerte
NumPut(0.5, light, 0, "float") ;Rot
NumPut(0.5, light, 4, "float") ;Gr�n
NumPut(0.5, light, 8, "float") ;Blau
NumPut(1.0, light, 12, "float") ;Intensit�t (Alpha)
glLightfv(GL_LIGHT1, GL_AMBIENT, &light)

;Diffuse Lichtwerte
NumPut(1.0, light, 0, "float") ;Rot
NumPut(1.0, light, 4, "float") ;Gr�n
NumPut(1.0, light, 8, "float") ;Blau
NumPut(1.0, light, 12, "float") ;Intensit�t (Alpha)
glLightfv(GL_LIGHT1, GL_DIFFUSE, &light)

;Speculare Lichtwerte
NumPut(1.0, light, 0, "float") ;Rot
NumPut(1.0, light, 4, "float") ;Gr�n
NumPut(1.0, light, 8, "float") ;Blau
NumPut(1.0, light, 12, "float") ;Intensit�t (Alpha)
glLightfv(GL_LIGHT1, GL_SPECULAR, &light)

;Lichtposition
NumPut(0.0, light, 0, "float") ;X-Position
NumPut(0.0, light, 4, "float") ;Y-Position
NumPut(0.0, light, 8, "float") ;Z-Position
NumPut(1.0, light, 12, "float") ;Position/Richtung
glLightfv(GL_LIGHT1, GL_POSITION, &light)

glEnable(GL_LIGHT1) ;Licht 1 einschalten
glEnable(GL_LIGHTING) ;Beleuchtung aktivieren
return



UpdateScene: ;Unsere Zeichenroutine
glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT) ;L�sche den Farb- und Tiefenbuffer
glLoadIdentity() ;Stelle die Matrix wieder auf 0

Text := "3D Text und Licht"

R := (R="") ? 1 : (B>=0.95 && G<=0.05 && R<0.95) ? R+0.1 : (B<=0.05 && G>=0.95 && R>=0.05) ? R-0.1 : R
G := (G="") ? 0 : (R>=0.95 && B<=0.05 && G<0.95) ? G+0.1 : (R<=0.05 && B>=0.95 && G>=0.05) ? G-0.1 : G
B := (B="") ? 0 : (G>=0.95 && R<=0.05 && B<0.95) ? B+0.1 : (G<=0.05 && R>=0.95 && B>=0.05) ? B-0.1 : B

;Ambiente Lichtwerte
NumPut(R, light, 0, "float") ;Rot
NumPut(G, light, 4, "float") ;Gr�n
NumPut(B, light, 8, "float") ;Blau
NumPut(1.0, light, 12, "float") ;Intensit�t (Alpha)
glLightfv(GL_LIGHT1, GL_AMBIENT, &light)

glTranslatef(0, 0, -10) ;Gehe 10 Einheiten in den Bildschirm hinein
glScalef(1.6, 1.6, 1.6)

X := (X="") ? 0 : (GetKeyState("Left")) ? X+4 : (GetKeyState("Right")) ? X-4 : X
Y := (Y="") ? 0 : (GetKeyState("Up")) ? Y+4 : (GetKeyState("Down")) ? Y-4 : Y
Z := (Z="") ? 0 : (GetKeyState("PgUp")) ? Z+4 : (GetKeyState("PgDn")) ? Z-4 : Z

glRotatef(X, 0, 1, 0) ;Rotiere X auf der Y-Achse
glRotatef(Y, 1, 0, 0) ;Rotiere Y auf der X-Achse
glRotatef(Z, 0, 0, 1) ;Rotiere Z auf der Z-Achse

TextWidth := 0
Loop, parse, Text
  TextWidth += NumGet(gmf, Asc(A_LoopField)*24+16, "float")
glTranslatef(-TextWidth/2, 0, 0) ;Zentriere Text

glListBase(FontList) ;W�hle die OpenGL-Schriftart
glCallLists(StrLen(Text), (A_IsUnicode) ? GL_UNSIGNED_SHORT : GL_UNSIGNED_BYTE, &Text) ;Schreibe den Text in OpenGL

SwapBuffers(hDC) ;Bringe das Gezeichnete auf das Gui
return



GuiSize: ;Wenn sich die Gr��e des Gui ver�ndert...
ScreenW := (A_GuiWidth=0) ? 1 : A_GuiWidth
ScreenH := (A_GuiHeight=0) ? 1 : A_GuiHeight
glViewport(0, 0, ScreenW, ScreenH) ;Setze den Viewport (der Bereich in dem Gezeichnet wird) auf die Gr��e des Guis

glMatrixMode(GL_PROJECTION) ;Wechsle zur Projektionsmatrix
glLoadIdentity() ;Stelle die Matrix wieder auf 0
gluPerspective(45, ScreenW/ScreenH, 1, 100) ;Perspektive w�hlen
glMatrixMode(GL_MODELVIEW) ;Wechsle zur Modelansichtmatrix
glLoadIdentity() ;Stelle die Matrix wieder auf 0
return



ExitSub: ;Bevor das Programm beendet wird...
glDeleteLists(FontList, 256) ;L�sche die Schriftart
if (hRC) ;Haben wir einen g�ltigen Renderkontext?
{
  wglMakeCurrent(0, 0) ;Verwende keinen Renderkontext
  wglDeleteContext(hRC) ;L�sche den Renderkontext
}
FreeOpenGlLib() ;Gebe den speicher der OpenGL-Bibliothek frei.
ExitApp ;Beende das Programm entg�ltig.