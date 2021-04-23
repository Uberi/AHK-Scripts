GL_USE64BIT := 1 ;Soll versucht werden die 64-Bit DLLs zu laden (1=Ja, 0=Nein)
#include, gl.ahk ;OpenGL-Bibliothek für AutoHotkey einbinden
OnExit, ExitSub ;Springe vor dem Beenden des Programmes zum Label ExitSub
if (GL_WRAPPER_VERSION < 2.0) ;Überprüfe ob der OpenGL-Wrapper veraltet ist
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
Gui, show, w640 h480, Tutorial 02 ;Zeige unser Gui
SetTimer, UpdateScene, 50 ;Setze den Timer für das Label UpdateScene auf 50 ms. (entspricht ~16 FPS)
return


InitOpenGL:
glClearColor(0, 0, 0, 0) ;Setze die Farbe, die beim Löschen des Buffers verwendet wird.
glShadeModel(GL_SMOOTH) ;Erlaube Smooth shading

glLineWidth(5) ;Setze die Linienstärke auf 5 *NEU*

glEnable(GL_DEPTH_TEST) ;Tiefentest einschalten *NEU*
glDepthFunc(GL_LEQUAL) ;Tiefenfunktion wählen *NEU*
glHint(GL_PERSPECTIVE_CORRECTION_HINT, GL_NICEST) ;Korrektion für die Tiefe *NEU*
return



UpdateScene: ;Unsere Zeichenroutine
glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT) ;Lösche den Farb- und Tiefenbuffer
glLoadIdentity() ;Stelle die Matrix wieder auf 0

glMatrixMode(GL_PROJECTION) ;Wechsle zur Projektionsmatrix
glLoadIdentity() ;Stelle die Matrix wieder auf 0
gluPerspective(45, ScreenW/ScreenH, 1, 100) ;Perspektive wählen
glMatrixMode(GL_MODELVIEW) ;Wechsle zur Modelansichtmatrix
glLoadIdentity() ;Stelle die Matrix wieder auf 0

glTranslatef(-1.5, 0, -6) ;Verschiebe die Matrix 1.5 Enheiten nach Links und 6 Einheiten in den Bildschirm hinein.

;Zeichne vorderes Viereck
glBegin(GL_LINE_LOOP) ;Beginne Linien zu zeichnen
glColor3f(1, 0, 0)  glVertex3f(1, 1, 1)
glColor3f(0, 1, 0)  glVertex3f(-1, 1, 1)
glColor3f(0, 1, 0)  glVertex3f(-1, -1, 1)
glColor3f(1, 0, 0)  glVertex3f(1, -1, 1)
glEnd() ;Beende den Zeichenvorgang

;Zeichne hinteres Viereck
glBegin(GL_LINE_LOOP) ;Beginne Linien zu zeichnen
glColor3f(0, 0, 1)  glVertex3f(1, 1, -1)
glColor3f(1, 1, 0)  glVertex3f(-1, 1, -1)
glColor3f(1, 1, 0)  glVertex3f(-1, -1, -1)
glColor3f(0, 0, 1)  glVertex3f(1, -1, -1)
glEnd() ;Beende den Zeichenvorgang

;Zeichne Verbindungslinien zwischen den Vierecken
glBegin(GL_LINES) ;Beginne Linien zu zeichnen
glColor3f(1, 0, 0)  glVertex3f(1, 1, 1)
glColor3f(0, 0, 1)  glVertex3f(1, 1, -1)
glColor3f(0, 1, 0)  glVertex3f(-1, 1, 1)
glColor3f(1, 1, 0)  glVertex3f(-1, 1, -1)
glColor3f(0, 1, 0)  glVertex3f(-1, -1, 1)
glColor3f(1, 1, 0)  glVertex3f(-1, -1, -1)
glColor3f(1, 0, 0)  glVertex3f(1, -1, 1)
glColor3f(0, 0, 1)  glVertex3f(1, -1, -1)
glEnd() ;Beende den Zeichenvorgang

glMatrixMode(GL_PROJECTION) ;Wechsle zur Projektionsmatrix
glLoadIdentity() ;Stelle die Matrix wieder auf 0
glOrtho(-ScreenW*0.005, ScreenW*0.005, -ScreenH*0.005, ScreenH*0.005, 1, 100) ;Orthografisch Ansicht wählen
glMatrixMode(GL_MODELVIEW) ;Wechsle zur Modelansichtmatrix
glLoadIdentity() ;Stelle die Matrix wieder auf 0

glTranslatef(1.5, 0, -6) ;Verschiebe die Matrix 1.5 Enheiten nach Rechts und 6 Einheiten in den Bildschirm hinein.

;Zeichne vorderes Viereck
glBegin(GL_LINE_LOOP) ;Beginne Linien zu zeichnen
glColor3f(1, 0, 0)  glVertex3f(1, 1, 1)
glColor3f(0, 1, 0)  glVertex3f(-1, 1, 1)
glColor3f(0, 1, 0)  glVertex3f(-1, -1, 1)
glColor3f(1, 0, 0)  glVertex3f(1, -1, 1)
glEnd() ;Beende den Zeichenvorgang

;Zeichne hinteres Viereck
glBegin(GL_LINE_LOOP) ;Beginne Linien zu zeichnen
glColor3f(0, 0, 1)  glVertex3f(1, 1, -1)
glColor3f(1, 1, 0)  glVertex3f(-1, 1, -1)
glColor3f(1, 1, 0)  glVertex3f(-1, -1, -1)
glColor3f(0, 0, 1)  glVertex3f(1, -1, -1)
glEnd() ;Beende den Zeichenvorgang

;Zeichne Verbindungslinien zwischen den Vierecken
glBegin(GL_LINES) ;Beginne Linien zu zeichnen
glColor3f(1, 0, 0)  glVertex3f(1, 1, 1)
glColor3f(0, 0, 1)  glVertex3f(1, 1, -1)
glColor3f(0, 1, 0)  glVertex3f(-1, 1, 1)
glColor3f(1, 1, 0)  glVertex3f(-1, 1, -1)
glColor3f(0, 1, 0)  glVertex3f(-1, -1, 1)
glColor3f(1, 1, 0)  glVertex3f(-1, -1, -1)
glColor3f(1, 0, 0)  glVertex3f(1, -1, 1)
glColor3f(0, 0, 1)  glVertex3f(1, -1, -1)
glEnd() ;Beende den Zeichenvorgang

SwapBuffers(hDC) ;Bringe das Gezeichnete auf das Gui
return


GuiSize: ;Wenn sich die Größe des Gui verändert...
ScreenW := (A_GuiWidth=0) ? 1 : A_GuiWidth
ScreenH := (A_GuiHeight=0) ? 1 : A_GuiHeight
glViewport(0, 0, ScreenW, ScreenH) ;Setze den Viewport auf die Größe des Guis
return


ExitSub: ;Bevor das Programm beendet wird...
if (hRC) ;Haben wir einen gültigen Renderkontext?
{
  wglMakeCurrent(0, 0) ;Verwende keinen Renderkontext
  wglDeleteContext(hRC) ;Lösche den Renderkontext
}
FreeOpenGlLib() ;Gebe den speicher der gl.ahk frei.
ExitApp ;Beende das Programm entgültig.