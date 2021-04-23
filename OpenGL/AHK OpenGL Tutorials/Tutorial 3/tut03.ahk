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
Gui, show, w640 h480, Tutorial 03 ;Zeige unser Gui
SetTimer, UpdateScene, 50 ;Setze den Timer f�r das Label UpdateScene auf 50 ms. (entspricht ~16 FPS)
return


InitOpenGL:
glClearColor(0, 0, 0, 0) ;Setze die Farbe, die beim L�schen des Buffers verwendet wird.
glShadeModel(GL_SMOOTH) ;Erlaube Smooth shading

glEnable(GL_DEPTH_TEST) ;Tiefentest einschalten
glDepthFunc(GL_LEQUAL) ;Tiefenfunktion w�hlen
glHint(GL_PERSPECTIVE_CORRECTION_HINT, GL_NICEST) ;Korrektion f�r die Tiefe

glEnable(GL_TEXTURE_2D) ;Aktiviere zweidimensionale Texturen *NEU*

Cube1 := LoadTexture("Cube1.png") ;Lade 1. W�rfeltextur *NEU*
Cube2 := LoadTexture("Cube2.png") ;Lade 2. W�rfeltextur *NEU*
Cube3 := LoadTexture("Cube3.png") ;Lade 3. W�rfeltextur *NEU*
Cube4 := LoadTexture("Cube4.png") ;Lade 4. W�rfeltextur *NEU*
Cube5 := LoadTexture("Cube5.png") ;Lade 5. W�rfeltextur *NEU*
Cube6 := LoadTexture("Cube6.png") ;Lade 6. W�rfeltextur *NEU*

Hotkey, IfWinActive, ahk_id %hGui% ;Setze einen Hotkey wenn unser Gui aktiv ist... *NEU*
Hotkey, f, ChangeFilter ;Setze die Taste "f" als Hotkey f�r das Label ChangeFilter *NEU*
return



ChangeFilter: ;Wenn die Taste "f" gedr�ckt wird...
if (Filter=GL_NEAREST) ;Ist der Filter GL_NEAREST
  Filter := GL_LINEAR ;Wenn ja, ist der Filter ab jetzt GL_LINEAR
else ;... ansonsten ...
  Filter := GL_NEAREST ;nutze GL_NEAREST als Filter
Loop, 6 ;Gehe unsere W�rfeltexturen durch
{
  glBindTexture(GL_TEXTURE_2D, Cube%A_Index%) ;Binde die W�rfeltexturen nacheinander
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, Filter) ;W�hle den Verkleinerungsfilter
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, Filter) ;W�hle den Vergr��erungsfilter
}
return

GuiClose:
ExitApp

UpdateScene: ;Unsere Zeichenroutine
glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT) ;L�sche den Farb- und Tiefenbuffer
glLoadIdentity() ;Stelle die Matrix wieder auf 0

glTranslatef(0, 0, -5) ;Verschiebe die Matrix 5 Einheiten in den Bildschirm hinein.

MouseGetPos, RotX, RotY
RotX -= ScreenW / 2, RotY -= ScreenH / 2
glRotatef(RotY / 3,1,0,0)
glRotatef(RotX / 3,0,1,0)

;Zeichne vordere Fl�che
glBindTexture(GL_TEXTURE_2D, Cube1) ;Binde die 1. W�rfeltextur
glBegin(GL_QUADS) ;Beginne Vierecke zu zeichnen
glTexCoord2f(0, 0)  glVertex3f(1, 1, 1)
glTexCoord2f(0, 1)  glVertex3f(-1, 1, 1)
glTexCoord2f(1, 1)  glVertex3f(-1, -1, 1)
glTexCoord2f(1, 0)  glVertex3f(1, -1, 1)
glEnd() ;Beende den Zeichenvorgang

;Zeichne hintere Fl�che
glBindTexture(GL_TEXTURE_2D, Cube6) ;Binde die 6. W�rfeltextur
glBegin(GL_QUADS) ;Beginne Vierecke zu zeichnen
glTexCoord2f(0, 0)  glVertex3f(1, 1, -1)
glTexCoord2f(0, 1)  glVertex3f(-1, 1, -1)
glTexCoord2f(1, 1)  glVertex3f(-1, -1, -1)
glTexCoord2f(1, 0)  glVertex3f(1, -1, -1)
glEnd() ;Beende den Zeichenvorgang

;Zeichne linke Fl�che
glBindTexture(GL_TEXTURE_2D, Cube2) ;Binde die 2. W�rfeltextur
glBegin(GL_QUADS) ;Beginne Vierecke zu zeichnen
glTexCoord2f(0, 0)  glVertex3f(1, 1, 1)
glTexCoord2f(0, 1)  glVertex3f(1, 1, -1)
glTexCoord2f(1, 1)  glVertex3f(1, -1, -1)
glTexCoord2f(1, 0)  glVertex3f(1, -1, 1)
glEnd() ;Beende den Zeichenvorgang

;Zeichne rechte Fl�che
glBindTexture(GL_TEXTURE_2D, Cube5) ;Binde die 5. W�rfeltextur
glBegin(GL_QUADS) ;Beginne Vierecke zu zeichnen
glTexCoord2f(0, 0)  glVertex3f(-1, 1, 1)
glTexCoord2f(0, 1)  glVertex3f(-1, 1, -1)
glTexCoord2f(1, 1)  glVertex3f(-1, -1, -1)
glTexCoord2f(1, 0)  glVertex3f(-1, -1, 1)
glEnd() ;Beende den Zeichenvorgang

;Zeichne obere Fl�che
glBindTexture(GL_TEXTURE_2D, Cube3) ;Binde die 3. W�rfeltextur
glBegin(GL_QUADS) ;Beginne Vierecke zu zeichnen
glTexCoord2f(0, 0)  glVertex3f(1, 1, 1)
glTexCoord2f(0, 1)  glVertex3f(1, 1, -1)
glTexCoord2f(1, 1)  glVertex3f(-1, 1, -1)
glTexCoord2f(1, 0)  glVertex3f(-1, 1, 1)
glEnd() ;Beende den Zeichenvorgang

;Zeichne untere Fl�che
glBindTexture(GL_TEXTURE_2D, Cube4) ;Binde die 4. W�rfeltextur
glBegin(GL_QUADS) ;Beginne Vierecke zu zeichnen
glTexCoord2f(0, 0)  glVertex3f(1, -1, 1)
glTexCoord2f(0, 1)  glVertex3f(1, -1, -1)
glTexCoord2f(1, 1)  glVertex3f(-1, -1, -1)
glTexCoord2f(1, 0)  glVertex3f(-1, -1, 1)
glEnd() ;Beende den Zeichenvorgang

SwapBuffers(hDC) ;Bringe das Gezeichnete auf das Gui
return


GuiSize: ;Wenn sich die Gr��e des Gui ver�ndert...
ScreenW := (A_GuiWidth=0) ? 1 : A_GuiWidth
ScreenH := (A_GuiHeight=0) ? 1 : A_GuiHeight
glViewport(0, 0, ScreenW, ScreenH) ;Setze den Viewport auf die Gr��e des Guis

glMatrixMode(GL_PROJECTION) ;Wechsle zur Projektionsmatrix
glLoadIdentity() ;Stelle die Matrix wieder auf 0
gluPerspective(45, ScreenW/ScreenH, 1, 100) ;Perspektive w�hlen
glMatrixMode(GL_MODELVIEW) ;Wechsle zur Modelansichtmatrix
glLoadIdentity() ;Stelle die Matrix wieder auf 0
return


ExitSub: ;Bevor das Programm beendet wird...
VarSetCapacity(DelTextures, 4*6, 0) ;Speicherplatz f�r die Texturen die gel�scht werden sollten *NEU*
Loop, 6 ;Gehe unsere W�rfeltexturen durch *NEU*
  NumPut(Cube%A_Index%, (A_Index-1)*4) ;�bergebe die Texturnummer den Speicher *NEU*
glDeleteTextures(6, &DelTextures) ;L�sche unsere 6 W�rfeltexturen *NEU*

if (hRC) ;Haben wir einen g�ltigen Renderkontext?
{
  wglMakeCurrent(0, 0) ;Verwende keinen Renderkontext
  wglDeleteContext(hRC) ;L�sche den Renderkontext
}
FreeOpenGlLib() ;Gebe den speicher der OpenGL-Bibliothek frei.
ExitApp ;Beende das Programm entg�ltig.

LoadTexture(Filename)
{
  Global ;damit wir die OpenGL-Konstanten verwenden k�nnen
  Local pGdiPlusToken, pGdiplusInput, SizeOfFilename, WideFilename ;Lokale Variablen
  Local GdiplusBitmap, hBitmap, ImgInfo, bmBits, w, h, textures ;Lokale Variablen

  DllCall("LoadLibrary", "str", "gdiplus") ;Lade die GDI+ Bibliothek
  VarSetCapacity(pGdiplusToken, 4, 0) ;Speicher f�r den GDI+ Token
  VarSetCapacity(pGdiplusInput, 16, 0) ;Speicher zum starten der GDI+ Bibliothek
  NumPut(1, pGdiplusInput) ;GDI+ Versionsnummer (muss 1 sein)
  DllCall("gdiplus\GdiplusStartup", "uint", &pGdiplusToken, "uint", &pGdiplusInput, "uint", 0) ;GDI+ starten

  if (!A_IsUnicode) ;L�uft das Script NICHT im Unicode-Build
  {
    SizeOfFilename := DllCall("MultiByteToWideChar", "uint", 0, "uint", 0, "uint", &Filename, "int", -1, "uint", 0, "int", 0) * 2 ;Ermittle die L�nge des WideChar-Strings
    VarSetCapacity(WideFilename, SizeOfFilename, 0) ;Speicher f�r den WideChar-String
    DllCall("MultiByteToWideChar", "uInt", 0, "uint", 0, "uint", &Filename, "int", -1, "uint", &WideFilename, "uint", SizeOfFilename) ;Konventiere den String
    DllCall("gdiplus\GdipCreateBitmapFromFile", "uint", &WideFilename, "uint*", GdiplusBitmap) ;Lade die Bilddatei
  }
  else ;L�uft das Script im Unicode-Build
    DllCall("gdiplus\GdipCreateBitmapFromFile", "uint", &Filename, "uint*", GdiplusBitmap) ;Lade die Bilddatei

  DllCall("gdiplus\GdipCreateHBITMAPFromBitmap", "uint", GdiplusBitmap, "uint*", hBitmap, "uint", 0xFF000000) ;Konvertiere die Bilddatei zu einem HBITMAP

  DllCall("gdiplus\GdipDisposeImage", "uint", GdiplusBitmap) ;L�sche die Bilddatei
  DllCall("gdiplus\GdiplusShutdown", "uint", NumGet(pGdiplusToken)) ;Beende GDI+
  DllCall("FreeLibrary", "uint", DllCall("GetModuleHandle", "str", "gdiplus")) ;Entlade die GDI+ Bibliothek

  if (hBitmap=0) ;Haben wir KEIN g�ltiges HBITMAP
    return 0 ;Gebe 0 (Fehler) zur�ck

  VarSetCapacity(ImgInfo, 24, 0) ;Speicher f�r die Bildinformationen
  DllCall("GetObject", "uint", hBitmap, "uint", 24, "uint", &ImgInfo) ;Ermittle die Bildinformationen
  bmBits := NumGet(ImgInfo, 20) ;Anzahl der Bits
  w := NumGet(ImgInfo, 4) ;Breite des Bildes
  h := NumGet(ImgInfo, 8) ;H�he des Bildes

  VarSetCapacity(textures, 4, 0) ;Speicher f�r eine Textur
  glGenTextures(1, &textures) ;Erstelle eine Textur
  glBindTexture(GL_TEXTURE_2D, NumGet(textures)) ;Binde diese Textur

  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR) ;Setze den Verkleinerungsfilter
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR) ;Setze den Vergr��erungsfilter

  glTexImage2D(GL_TEXTURE_2D, 0, 4, w, h, 0, GL_BGRA, GL_UNSIGNED_BYTE, bmBits) ;Importiere die Bilddaten
  DllCall("DeleteObject", "uint", hBitmap) ;L�sche das HBITMAP
  return NumGet(textures) ;Gebe die Texturnummer zur�ck
}