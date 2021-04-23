#NoEnv

n := new NotePlayer
n.Instrument(9)

Loop, 4
{
    n.Note(57,500).Delay(500)
    n.Note(56,200).Delay(200)
    n.Note(57,200).Delay(200)
    n.Note(54,500).Delay(500)
}

Time := n.Offset
Loop, 9
{
    n.Note(57,500).Note(45,500,80).Delay(500)
    n.Note(56,200).Note(44,200,80).Delay(200)
    n.Note(57,200).Note(45,050,80).Delay(200)
    n.Note(54,500).Note(42,500,0).Delay(500)
}

n.Offset := Time
n.Note(42,1400,0).Delay(1400)
n.Note(40,1400,100).Delay(1400)
n.Note(38,1400,100).Delay(1400)
n.Note(36,1400,100).Delay(1400)
n.Note(38,1400,100).Delay(1400)
n.Note(36,1400,100).Delay(1400)
n.Note(34,1400,100).Delay(1400)
n.Note(30,1400,100).Delay(1400)

n.Start()
While, n.Playing
    Sleep, 1
ExitApp

#Include ..\Music.ahk