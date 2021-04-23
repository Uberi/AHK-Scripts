NotePlayer
==========
The NotePlayer API is a library that allows the creation and playing of note sequences - a number of notes played sequentially.

This library can be used to play music, sound effects, and more. As a part of ProgressEngine, it emphasizes a simple interface, with the complexity behind MIDI output taken away from the user.

MIDI Number Converter
---------------------
The "MIDI Number Converter" utility provides a simpler way to input music, without writing code. It can be found in the "MIDI" subfolder of the main ProgressEngine distribution. See the utility's README for usage information.

Examples
--------

### Single note played immediately

    n := new NotePlayer
    n.Play(48,1000,9) ;play note 48 (C4) for 1000 milliseconds with instrument 9 (Rhodes Piano)

The note will begin playing immediately upon calling, and the script will continue executing. The note will stop asynchronously after it is complete.

### Two simultaneous notes played immediately

    n := new NotePlayer
    n.Play(48,1000,9) ;play note 48 (C4) for 1000 milliseconds with instrument 9 (Rhodes Piano)
    n.Play(45,1000,1) ;play note 45 (A3) for 1000 milliseconds with instrument 1 (Acoustic Grand Piano)

Both notes will begin playing at nearly the exact same time, and will both stop at nearly the exact same time.

### Two chords

    n := new NotePlayer
    n.Instrument(9) ;set the current instrument to instrument 9 (Rhodes Piano)
    n.Note(48,500).Note(36,500).Delay(500) ;play note 48 (C4) and 36 (C3) for 500 milliseconds and delay for 500 milliseconds
    n.Note(45,500,80).Note(41,500,80).Delay(500) ;play note 45 (A3) and 41 (F3) for 500 milliseconds both with down velocity 80 and delay for 500 milliseconds
    n.Start() ;begin playing notes

Adding notes using NotePlayer.Note does not play them; they are added to a timeline internally and begin playing only when NotePlayer.Start is invoked.

### Two overlapped sets of chords

    n := new NotePlayer
    n.Instrument(9) ;set the current instrument to instrument 9 (Rhodes Piano)
    
    ;add the first set of chords
    StartingOffset := n.Offset ;store the current offset
    n.Note(36,500).Delay(500) ;play note 36 (C3) for 500 milliseconds and delay for 500 milliseconds
    n.Note(47,500).Note(35,500).Delay(500) ;play note 47 (B3) for 500 milliseconds and delay for 500 milliseconds
    
    ;add the second set of chords
    n.Offset := StartingOffset ;restore the offset to the starting position
    n.Note(48,500).Delay(500) ;play note 48 (C4) for 500 milliseconds and delay for 500 milliseconds
    n.Note(45,500).Note(41,500).Delay(500) ;play note 45 (A3) and 41 (F3) for 500 milliseconds and delay for 500 milliseconds

The two sets of chords will play simultaneously.

### Repeating note sequence

    n := new NotePlayer
    n.Repeat := True
    n.Instrument(9) ;set the current instrument to instrument 9 (Rhodes Piano)
    n.Note(48,500).Note(36,500).Delay(500) ;play note 48 (C4) and 36 (C3) for 500 milliseconds and delay for 500 milliseconds
    n.Note(45,500,80).Note(41,500,80).Delay(500) ;play note 45 (A3) and 41 (F3) for 500 milliseconds both with down velocity 80 and delay for 500 milliseconds
    n.Start() ;begin playing notes

The NotePlayer.Repeat property allows a sequence of notes to be repeated until stopped.

Reference
---------

### NotePlayer.Offset

The current offset from the beginning of the note sequence, in milliseconds. This is increased by NotePlayer.Delay and used as the starting time for NotePlayer.Instrument and NotePlayer.Note.

This value can be modified at will, and doing so is a good way to play two different sequences at the same time. Saving the offset, adding a note sequence, restoring the offset, and adding another note sequence results in both playing at the same time.

### NotePlayer.Playing

Flag indicating whether the NotePlayer instance is currently playing stored notes.

Useful for determining when the note sequence has ended.

### NotePlayer.Note(Index,Length,DownVelocity = 60,UpVelocity = 60)

Adds a single note, determined by MIDI note number _Index_ (integer between 0 and 127 inclusive), to the NotePlayer instance, which plays for _Length_ milliseconds (positive integer or decimal), is pressed with a velocity of _DownVelocity_ (integer or decimal between 0 and 100 inclusive), and is released with a velocity of _UpVelocity_ (integer or decimal between 0 and 100 inclusive). Returns the noteplayer instance.

Useful for creating sequences of notes that are to be played together.

### NotePlayer.Instrument(Sound)

Sets the instrument of the noteplayer to _Sound_ (integer between 0 and 127 inclusive), which is also known as a "program" or a "patch" in MIDI terminology.

Does not affect NotePlayer.Play, which must have its instrument explicitly specified.

Useful for playing multiple notes using different instruments. Returns the noteplayer instance.

### NotePlayer.Delay(Length)

Delays playing of the next note for _Length_ milliseconds (integer or decimal) while the NotePlayer instance is playing. Returns the noteplayer instance.

Useful for adding a pause or delaying the playing of following notes. Additionally, using negative delays moves the offset backwards, which allows a note sequence to be played simultaneously with another.

### NotePlayer.Play(Index,Length,Sound,DownVelocity = 60,UpVelocity = 60)

Immediately begins playing a single note, determined by MIDI note number _Index_ (integer between 0 and 127 inclusive), which plays for _Length_ milliseconds (positive integer or decimal), with the instrument _Sound_ (also known as a "program" or "patch" in MIDI terminology), is pressed with a velocity of _DownVelocity_ (integer or decimal between 0 and 100 inclusive), and is released with a velocity of _UpVelocity_ (integer or decimal between 0 and 100 inclusive). Returns the noteplayer instance.

Useful for sound effects and other notes that must be played at specific times.

### NotePlayer.Start()

Begins playing the notes and delays in the order they were added. Returns the noteplayer instance. Returns the noteplayer instance.

Useful for playing the notes stored in the NotePlayer instance.

### NotePlayer.Stop()

Stops a currently playing noteplayer, cutting off notes if any are active at the time it is called. Returns the noteplayer instance.

Useful for abruptly ending a sequence of notes.

### NotePlayer.Reset()

Resets a noteplayer to its initial state; that is, it stops the noteplayer and deletes the notes in it. Returns the noteplayer instance.

Useful for removing all notes stored in a NotePlayer instrument in order to add another sequence of notes to it.