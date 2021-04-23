#Include ../ProgressEngine.ahk
#Include ../Music.ahk

Notes := new NotePlayer

Notes.Instrument(9)

Notes.Repeat := 1

Notes.Note(40,1000,70).Note(48,1000,70).Delay(1800)
Notes.Note(41,1000,70).Note(47,1000,70).Delay(1800)
Notes.Note(40,1000,70).Note(48,1000,70).Delay(2000)
Notes.Note(40,1000,70).Note(45,1000,70).Delay(1800)

Notes.Delay(300)

Notes.Note(41,1000,70).Note(48,1000,70).Delay(1800)
Notes.Note(41,1000,70).Note(47,1000,70).Delay(1800)
Notes.Note(41,1000,70).Note(48,1000,70).Delay(2000)
Notes.Note(41,1000,70).Note(45,1000,70).Delay(1800)

Notes.Delay(500)

Notes.Start()

Gui, +Resize +LastFound
Engine := new ProgressEngine(WinExist())

Gui, Show, w800 h600, My first game!

Engine.Layers[1] := new ProgressEngine.Layer
Engine.Layers[2] := new ProgressEngine.Layer

Engine.Layers[1].Entities.Insert(new Background)
Engine.Layers[2].Entities.Insert(new Title(5,5,"Hello, world!"))
Engine.Layers[2].Entities.Insert(new Logo(3,6,3,3))

Engine.Start()
ExitApp

GuiClose:
ExitApp

class Background extends ProgressEntities.Rectangle
{
    __New()
    {
        base.__New()
        this.X := 0 ;start at left
        this.Y := 0 ;start at top
        this.W := 10 ;cover the entire width of the viewport
        this.H := 10 ;cover the entire height of the viewport
        this.Color := 0xCCCCCC ;light grey color
    }
}

class Title extends ProgressEntities.Text
{
    __New(X,Y,Text)
    {
        base.__New()
        this.X := X
        this.Y := Y
        this.Align := "Center" ;center aligned
        this.H := 1 ;large font size
        this.Color := 0x444444 ;dark grey color
        this.Weight := 100 ;light weight
        this.Typeface := "Arial" ;typeface is Arial
        this.Text := Text
    }
}

class Logo extends ProgressEntities.Image
{
    __New(X,Y,W,H)
    {
        base.__New()
        this.X := X
        this.Y := Y
        this.W := W
        this.H := H
        this.Image := A_ScriptDir . "\Logo.bmp"
    }
}