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
Gui, show, w640 h480, Tutorial 03 ;Zeige unser Gui
SetTimer, UpdateScene, 50 ;Setze den Timer für das Label UpdateScene auf 50 ms. (entspricht ~16 FPS)
return


InitOpenGL:
glClearColor(0, 0, 0, 0) ;Setze die Farbe, die beim Löschen des Buffers verwendet wird.
glShadeModel(GL_SMOOTH) ;Erlaube Smooth shading

glEnable(GL_DEPTH_TEST) ;Tiefentest einschalten
glDepthFunc(GL_LEQUAL) ;Tiefenfunktion wählen
glHint(GL_PERSPECTIVE_CORRECTION_HINT, GL_NICEST) ;Korrektion für die Tiefe

glEnable(GL_TEXTURE_2D) ;Aktiviere zweidimensionale Texturen *NEU*

Cube1 := LoadTexture("Cube1.png") ;Lade 1. Würfeltextur *NEU*
Cube2 := LoadTexture("Cube2.png") ;Lade 2. Würfeltextur *NEU*
Cube3 := LoadTexture("Cube3.png") ;Lade 3. Würfeltextur *NEU*
Cube4 := LoadTexture("Cube4.png") ;Lade 4. Würfeltextur *NEU*
Cube5 := LoadTexture("Cube5.png") ;Lade 5. Würfeltextur *NEU*
Cube6 := LoadTexture("Cube6.png") ;Lade 6. Würfeltextur *NEU*

Hotkey, IfWinActive, ahk_id %hGui% ;Setze einen Hotkey wenn unser Gui aktiv ist... *NEU*
Hotkey, f, ChangeFilter ;Setze die Taste "f" als Hotkey für das Label ChangeFilter *NEU*
return



ChangeFilter: ;Wenn die Taste "f" gedrückt wird...
if (Filter=GL_NEAREST) ;Ist der Filter GL_NEAREST
  Filter := GL_LINEAR ;Wenn ja, ist der Filter ab jetzt GL_LINEAR
else ;... ansonsten ...
  Filter := GL_NEAREST ;nutze GL_NEAREST als Filter
Loop, 6 ;Gehe unsere Würfeltexturen durch
{
  glBindTexture(GL_TEXTURE_2D, Cube%A_Index%) ;Binde die Würfeltexturen nacheinander
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, Filter) ;Wähle den Verkleinerungsfilter
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, Filter) ;Wähle den Vergrößerungsfilter
}
return

GuiClose:
ExitApp

UpdateScene: ;Unsere Zeichenroutine
glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT) ;Lösche den Farb- und Tiefenbuffer
glLoadIdentity() ;Stelle die Matrix wieder auf 0

glTranslatef(0, 0, -5) ;Verschiebe die Matrix 5 Einheiten in den Bildschirm hinein.

MouseGetPos, RotX, RotY
RotX -= ScreenW / 2, RotY -= ScreenH / 2
glRotatef(RotY / 3,1,0,0)
glRotatef(RotX / 3,0,1,0)

;Zeichne vordere Fläche
glBindTexture(GL_TEXTURE_2D, Cube1) ;Binde die 1. Würfeltextur
glBegin(GL_QUADS) ;Beginne Vierecke zu zeichnen
glTexCoord2f(0, 0)  glVertex3f(1, 1, 1)
glTexCoord2f(0, 1)  glVertex3f(-1, 1, 1)
glTexCoord2f(1, 1)  glVertex3f(-1, -1, 1)
glTexCoord2f(1, 0)  glVertex3f(1, -1, 1)
glEnd() ;Beende den Zeichenvorgang

;Zeichne hintere Fläche
glBindTexture(GL_TEXTURE_2D, Cube6) ;Binde die 6. Würfeltextur
glBegin(GL_QUADS) ;Beginne Vierecke zu zeichnen
glTexCoord2f(0, 0)  glVertex3f(1, 1, -1)
glTexCoord2f(0, 1)  glVertex3f(-1, 1, -1)
glTexCoord2f(1, 1)  glVertex3f(-1, -1, -1)
glTexCoord2f(1, 0)  glVertex3f(1, -1, -1)
glEnd() ;Beende den Zeichenvorgang

;Zeichne linke Fläche
glBindTexture(GL_TEXTURE_2D, Cube2) ;Binde die 2. Würfeltextur
glBegin(GL_QUADS) ;Beginne Vierecke zu zeichnen
glTexCoord2f(0, 0)  glVertex3f(1, 1, 1)
glTexCoord2f(0, 1)  glVertex3f(1, 1, -1)
glTexCoord2f(1, 1)  glVertex3f(1, -1, -1)
glTexCoord2f(1, 0)  glVertex3f(1, -1, 1)
glEnd() ;Beende den Zeichenvorgang

;Zeichne rechte Fläche
glBindTexture(GL_TEXTURE_2D, Cube5) ;Binde die 5. Würfeltextur
glBegin(GL_QUADS) ;Beginne Vierecke zu zeichnen
glTexCoord2f(0, 0)  glVertex3f(-1, 1, 1)
glTexCoord2f(0, 1)  glVertex3f(-1, 1, -1)
glTexCoord2f(1, 1)  glVertex3f(-1, -1, -1)
glTexCoord2f(1, 0)  glVertex3f(-1, -1, 1)
glEnd() ;Beende den Zeichenvorgang

;Zeichne obere Fläche
glBindTexture(GL_TEXTURE_2D, Cube3) ;Binde die 3. Würfeltextur
glBegin(GL_QUADS) ;Beginne Vierecke zu zeichnen
glTexCoord2f(0, 0)  glVertex3f(1, 1, 1)
glTexCoord2f(0, 1)  glVertex3f(1, 1, -1)
glTexCoord2f(1, 1)  glVertex3f(-1, 1, -1)
glTexCoord2f(1, 0)  glVertex3f(-1, 1, 1)
glEnd() ;Beende den Zeichenvorgang

;Zeichne untere Fläche
glBindTexture(GL_TEXTURE_2D, Cube4) ;Binde die 4. Würfeltextur
glBegin(GL_QUADS) ;Beginne Vierecke zu zeichnen
glTexCoord2f(0, 0)  glVertex3f(1, -1, 1)
glTexCoord2f(0, 1)  glVertex3f(1, -1, -1)
glTexCoord2f(1, 1)  glVertex3f(-1, -1, -1)
glTexCoord2f(1, 0)  glVertex3f(-1, -1, 1)
glEnd() ;Beende den Zeichenvorgang

SwapBuffers(hDC) ;Bringe das Gezeichnete auf das Gui
return


GuiSize: ;Wenn sich die Größe des Gui verändert...
ScreenW := (A_GuiWidth=0) ? 1 : A_GuiWidth
ScreenH := (A_GuiHeight=0) ? 1 : A_GuiHeight
glViewport(0, 0, ScreenW, ScreenH) ;Setze den Viewport auf die Größe des Guis

glMatrixMode(GL_PROJECTION) ;Wechsle zur Projektionsmatrix
glLoadIdentity() ;Stelle die Matrix wieder auf 0
gluPerspective(45, ScreenW/ScreenH, 1, 100) ;Perspektive wählen
glMatrixMode(GL_MODELVIEW) ;Wechsle zur Modelansichtmatrix
glLoadIdentity() ;Stelle die Matrix wieder auf 0
return


ExitSub: ;Bevor das Programm beendet wird...
VarSetCapacity(DelTextures, 4*6, 0) ;Speicherplatz für die Texturen die gelöscht werden sollten *NEU*
Loop, 6 ;Gehe unsere Würfeltexturen durch *NEU*
  NumPut(Cube%A_Index%, (A_Index-1)*4) ;Übergebe die Texturnummer den Speicher *NEU*
glDeleteTextures(6, &DelTextures) ;Lösche unsere 6 Würfeltexturen *NEU*

if (hRC) ;Haben wir einen gültigen Renderkontext?
{
  wglMakeCurrent(0, 0) ;Verwende keinen Renderkontext
  wglDeleteContext(hRC) ;Lösche den Renderkontext
}
FreeOpenGlLib() ;Gebe den speicher der OpenGL-Bibliothek frei.
ExitApp ;Beende das Programm entgültig.

LoadTexture(Filename)
{
  Global ;damit wir die OpenGL-Konstanten verwenden können
  Local pGdiPlusToken, pGdiplusInput, SizeOfFilename, WideFilename ;Lokale Variablen
  Local GdiplusBitmap, hBitmap, ImgInfo, bmBits, w, h, textures ;Lokale Variablen

  DllCall("LoadLibrary", "str", "gdiplus") ;Lade die GDI+ Bibliothek
  VarSetCapacity(pGdiplusToken, 4, 0) ;Speicher für den GDI+ Token
  VarSetCapacity(pGdiplusInput, 16, 0) ;Speicher zum starten der GDI+ Bibliothek
  NumPut(1, pGdiplusInput) ;GDI+ Versionsnummer (muss 1 sein)
  DllCall("gdiplus\GdiplusStartup", "uint", &pGdiplusToken, "uint", &pGdiplusInput, "uint", 0) ;GDI+ starten

  if (!A_IsUnicode) ;Läuft das Script NICHT im Unicode-Build
  {
    SizeOfFilename := DllCall("MultiByteToWideChar", "uint", 0, "uint", 0, "uint", &Filename, "int", -1, "uint", 0, "int", 0) * 2 ;Ermittle die Länge des WideChar-Strings
    VarSetCapacity(WideFilename, SizeOfFilename, 0) ;Speicher für den WideChar-String
    DllCall("MultiByteToWideChar", "uInt", 0, "uint", 0, "uint", &Filename, "int", -1, "uint", &WideFilename, "uint", SizeOfFilename) ;Konventiere den String
    DllCall("gdiplus\GdipCreateBitmapFromFile", "uint", &WideFilename, "uint*", GdiplusBitmap) ;Lade die Bilddatei
  }
  else ;Läuft das Script im Unicode-Build
    DllCall("gdiplus\GdipCreateBitmapFromFile", "uint", &Filename, "uint*", GdiplusBitmap) ;Lade die Bilddatei

  DllCall("gdiplus\GdipCreateHBITMAPFromBitmap", "uint", GdiplusBitmap, "uint*", hBitmap, "uint", 0xFF000000) ;Konvertiere die Bilddatei zu einem HBITMAP

  DllCall("gdiplus\GdipDisposeImage", "uint", GdiplusBitmap) ;Lösche die Bilddatei
  DllCall("gdiplus\GdiplusShutdown", "uint", NumGet(pGdiplusToken)) ;Beende GDI+
  DllCall("FreeLibrary", "uint", DllCall("GetModuleHandle", "str", "gdiplus")) ;Entlade die GDI+ Bibliothek

  if (hBitmap=0) ;Haben wir KEIN gültiges HBITMAP
    return 0 ;Gebe 0 (Fehler) zurück

  VarSetCapacity(ImgInfo, 24, 0) ;Speicher für die Bildinformationen
  DllCall("GetObject", "uint", hBitmap, "uint", 24, "uint", &ImgInfo) ;Ermittle die Bildinformationen
  bmBits := NumGet(ImgInfo, 20) ;Anzahl der Bits
  w := NumGet(ImgInfo, 4) ;Breite des Bildes
  h := NumGet(ImgInfo, 8) ;Höhe des Bildes

  VarSetCapacity(textures, 4, 0) ;Speicher für eine Textur
  glGenTextures(1, &textures) ;Erstelle eine Textur
  glBindTexture(GL_TEXTURE_2D, NumGet(textures)) ;Binde diese Textur

  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR) ;Setze den Verkleinerungsfilter
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR) ;Setze den Vergrößerungsfilter

  glTexImage2D(GL_TEXTURE_2D, 0, 4, w, h, 0, GL_BGRA, GL_UNSIGNED_BYTE, bmBits) ;Importiere die Bilddaten
  DllCall("DeleteObject", "uint", hBitmap) ;Lösche das HBITMAP
  return NumGet(textures) ;Gebe die Texturnummer zurück
}