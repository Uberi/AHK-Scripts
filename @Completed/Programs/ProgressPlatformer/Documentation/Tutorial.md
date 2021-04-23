ProgressEngine Tutorial
=======================
This tutorial will attempt to show, by example, the techniques and methods used in the construction of a simple ProgressEngine demonstration.

The first step, including the main engine, is easy:

    #Include ProgressEngine.ahk

Initializing the engine is simple as well; we simply pass the handle to the window to use as the viewport:

    Gui, +Resize +LastFound
    Engine := new ProgressEngine(WinExist())

    Gui, Show, w800 h600, My first game!

Now we create two layers to store our entities in, to keep things organized:

    Engine.Layers[1] := new ProgressEngine.Layer
    Engine.Layers[2] := new ProgressEngine.Layer

Layers at higher indices draw above layers at lower indices. Layers have the following usable properties: X, Y, W, H, and Visible, which affect the position along the X axis, the position along the Y axis, the width, the height, and the visibility of the layer, respectively. All coordinates follow the same coordinate system: orgin at the top left corner, and 10 units in width and height.

ProgressEngine works on the concept of entities - objects that implement stepping, drawing, and other functionality. Built-in entities can be found in the ProgressEntities class. A more detailed description can be found in the "Built-in Entities" section. We extend these entities to create specialized entities with custom behavior or appearances.

We'll usually want a background:

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

And now let's define a text in a big title style:

    class Title extends ProgressEntities.Text
    {
        __New(X,Y,Text)
        {
            base.__New()
            this.X := X
            this.Y := Y
            this.Align := "Center" ;center aligned
            this.H := 14 ;large font size
            this.Color := 0x444444 ;dark grey color
            this.Weight := 100 ;light weight
            this.Typeface := "Arial" ;typeface is Arial
            this.Text := Text
        }
    }

But having these classes defined isn't enough. We also need to add them to a layer so they are accessible to the engine. We'll add the background to layer 1:

    Engine.Layers[1].Entities.Insert(new Background)

And the title to layer 2:

    Engine.Layers[2].Entities.Insert(new Title(5,5,"Hello, world!"))

Now let's start the engine!

    Engine.Start()

You will get something like this:

![ProgressEngine Demo](ProgressEngine.png "Test game.")

Here's the code in its entirety:

    #Include ProgressEngine.ahk

    Gui, +Resize +LastFound
    Engine := new ProgressEngine(WinExist())

    Gui, Show, w800 h600, My first game!

    Engine.Layers[1] := new ProgressEngine.Layer
    Engine.Layers[2] := new ProgressEngine.Layer

    Engine.Layers[1].Entities.Insert(new Background)
    Engine.Layers[2].Entities.Insert(new Title(5,5,"Hello, world!"))

    Engine.Start()

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
            this.H := 14 ;large font size
            this.Color := 0x444444 ;dark grey color
            this.Weight := 100 ;light weight
            this.Typeface := "Arial" ;typeface is Arial
            this.Text := Text
        }
    }

Optionally also include the MIDI music API:

    #Include Music.ahk

The music API also requires initialization; we can optionally pass it the MIDI instrument to use:

    Notes := new NotePlayer(9)

Now we'll enable looping, so it plays over and over:

    Notes.Repeat := 1

The noteplayer is asynchronous; that means that when you call any of the above methods, it stores the action and _returns immediately_. Then, when you play the noteplayer, it occasionally does its own thing in the background, without disrupting the rest of the script.

Time for some music! The following is taken directly from ProgressPlatformer:

    Notes.Instrument(0)

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

And now we play it:

    Notes.Start()

All together now:

    #Include ProgressEngine.ahk
    #Include Music.ahk

    Notes := new NotePlayer(9)

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

    Engine.Start()

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
            this.H := 14 ;large font size
            this.Color := 0x444444 ;dark grey color
            this.Weight := 100 ;light weight
            this.Typeface := "Arial" ;typeface is Arial
            this.Text := Text
        }
    }

There we have it! ProgressEngine takes care of the rest.