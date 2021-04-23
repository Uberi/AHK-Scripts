#NoEnv

/*
Copyright 2011-2012 Anthony Zhang <azhang9@gmail.com>

This file is part of ProgressPlatformer. Source code is available at <https://github.com/Uberi/ProgressPlatformer>.

ProgressPlatformer is free software: you can redistribute it and/or modify
it under the terms of the GNU Affero General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Affero General Public License for more details.

You should have received a copy of the GNU Affero General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

NoteData = 
(
0 C0
1 C0#
1 D0-
2 D0
3 D0#
3 E0-
4 E0
5 F0
6 F0#
6 G0-
7 G0
8 G0#
8 A0-
9 A0
10 A0#
10 B0-
11 B0
12 C1
13 C1#
13 D1-
14 D1
15 D1#
15 E1-
16 E1
17 F1
18 F1#
18 G1-
19 G1
20 G1#
20 A1-
21 A1
22 A1#
22 B1-
23 B1
24 C2
25 C2#
25 D2-
26 D2
27 D2#
27 E2-
28 E2
29 F2
30 F2#
30 G2-
31 G2
32 G2#
32 A2-
33 A2
34 A2#
34 B2-
35 B2
36 C3
37 C3#
37 D3-
38 D3
39 D3#
39 E3-
40 E3
41 F3
42 F3#
42 G3-
43 G3
44 G3#
44 A3-
45 A3
46 A3#
46 B3-
47 B3
48 C4
49 C4#
49 D4-
50 D4
51 D4#
51 E4-
52 E4
53 F4
54 F4#
54 G4-
55 G4
56 G4#
56 A4-
57 A4
58 A4#
58 B4-
59 B4
60 C5
61 C5#
61 D5-
62 D5
63 D5#
63 E5-
64 E5
65 F5
66 F5#
66 G5-
67 G5
68 G5#
68 A5-
69 A5
70 A5#
70 B5-
71 B5
72 C6
73 C6#
73 D6-
74 D6
75 D6#
75 E6-
76 E6
77 F6
78 F6#
78 G6-
79 G6
80 G6#
80 A6-
81 A6
82 A6#
82 B6-
83 B6
84 C7
85 C7#
85 D7-
86 D7
87 D7#
87 E7-
88 E7
89 F7
90 F7#
90 G7-
91 G7
92 G7#
92 A7-
93 A7
94 A7#
94 B7-
95 B7
96 C8
97 C8#
97 D8-
98 D8
99 D8#
99 E8-
100 E8
101 F8
102 F8#
102 G8-
103 G8
104 G8#
104 A8-
105 A8
106 A8#
106 B8-
107 B8
108 C9
109 C9#
109 D9-
110 D9
111 D9#
111 E9-
112 E9
113 F9
114 F9#
114 G9-
115 G9
116 G9#
116 A9-
117 A9
118 A9#
118 B9-
119 B9
120 C10
121 C10#
121 D10-
122 D10
123 D10#
123 E10-
124 E10
125 F10
126 F10#
126 G10-
127 G10
60 C
61 C#
61 D-
62 D
63 D#
63 E-
64 E
65 F
66 F#
66 G-
67 G
68 G#
68 A-
69 A
70 A#
70 B-
71 B
)

Instruments = 
(
Acoustic Grand Piano
Wet Acoustic Grand
Dry Acoustic Grand
Bright Acoustic Piano
Wet Bright Acoustic
Electric Grand Piano
Wet Electric Grand
Honky-tonk Piano
Wet Honky-tonk
Rhodes Piano
Detuned Electric Piano 1
Electric Piano 1 Variation
60's Electric Piano
Chorused Electric Piano
Detuned Electric Piano 2
Electric Piano 2 Variation
Electric Piano Legend
Electric Piano Phase
Harpsichord
Coupled Harpsichord
Wet Harpsichord
Open Harpsichord
Clavinet
Pulse Clavinet
Celesta
Glockenspiel
Music Box
Vibraphone
Wet Vibraphone
Marimba
Wet Marimba
Xylophone
Tubular-bell
Church Bell
Carillon
Santur
Hammond Organ
Detuned Organ 1
60's Organ 1
Organ 4
Percussive Organ
Detuned Organ 2
Organ 5
Rock Organ
Church Organ 1
Church Organ 2
Church Organ 3
Reed Organ
Puff Organ
French Accordion
Italian Accordion
Harmonica
Bandoneon
Nylon-String Guitar
Ukulele
Open Nylon Guitar
Nylon Guitar 2
Steel-String Guitar
12-String Guitar
Mandolin
Steel + Body
Jazz Guitar
Hawaiian Guitar
Clean Electric Guitar
Chorus Guitar
Mid Tone Guitar
Muted Electric Guitar
Funk Guitar
Funk Guitar 2
Jazz Man
Overdriven Guitar
Guitar Pinch
Distortion Guitar
Feedback Guitar
Distortion Rtm Guitar
Guitar Harmonics
Guitar Feedback
Acoustic Bass
Fingered Bass
Finger Slap
Picked Bass
Fretless Bass
Slap Bass 1
Slap Bass 2
Synth Bass 1
Synth Bass 101
Synth Bass 3
Clavi Bass
Hammer
Synth Bass 2
Synth Bass 4
Rubber Bass
Attack Pulse
Violin
Slow Violin
Viola
Cello
Contrabass
Tremolo Strings
Pizzicato Strings
Harp
Yang Qin
Timpani
String Ensemble
Orchestra Strings
60's Strings
Slow String Ensemble
Synth Strings 1
Synth Strings 3
Synth Strings 2
Choir Aahs
Choir Aahs 2
Voice Oohs
Humming
Synth Voice
Analog Voice
Orchestra Hit
Bass Hit
6th Hit
Euro Hit
Trumpet
Dark Trumpet
Trombone
Trombone 2
Bright Trombone
Tuba
Muted Trumpet
Muted Trumpet 2
)

NoteTable := Object()
NumberTable := Object()
Loop, Parse, NoteData, `n
{
    StringSplit, Field, A_LoopField, %A_Space%
    NoteTable[Field2] := Field1
    NumberTable[Field1] := Field2
}

Gui, Font, Bold s12, Arial
Gui, Add, Text, x10 y10 h30 vPromptText, Enter tune:
Gui, Font, Norm s10
Gui, Add, Edit, x10 y50 w480 h380 vTune

Gui, Font, Bold
Gui, Add, Text, x10 y440 w80 h20 vInstrumentLabel, Instrument:
Gui, Font, Norm
Gui, +Delimiter`n
Gui, Add, DropDownList, x90 y440 w400 h20 vInstrument R30 Choose1 AltSubmit, %Instruments%

Gui, Font, s12
Gui, Add, Button, x10 y470 w320 h30 vPlayButton gPlay Default, &Play
Gui, Add, Button, x340 y470 w150 h30 vConvertButton gConvert, &Convert

Gui, +Resize +MinSize350x200
Gui, Show, w500 h510, Note Editor
Return

GuiClose:
ExitApp

GuiSize:
GuiControl, Move, PromptText, % "w" . (A_GuiWidth - 20)
GuiControl, Move, Tune, % "w" . (A_GuiWidth - 20) . " h" . (A_GuiHeight - 130)
GuiControl, Move, InstrumentLabel, % "y" . (A_GuiHeight - 70)
GuiControl, Move, Instrument, % "y" . (A_GuiHeight - 70) . " w" . (A_GuiWidth - 100)
GuiControl, Move, PlayButton, % "y" . (A_GuiHeight - 40) . " w" . (A_GuiWidth - 180)
GuiControl, Move, ConvertButton, % "x" . (A_GuiWidth - 160) . " y" . (A_GuiHeight - 40)
Return

Play:
GuiControl, Disable, PlayButton
GuiControlGet, Tune,, Tune
If InStr(Tune,"NotePlayer") ;input is code
{
    ;set instrument if present
    If RegExMatch(Tune,"iS)\w\.Instrument(\s*(\d+)\s*)",Value)
        GuiControl, Choose, Instrument, % Value1 + 1

    Notes := new NotePlayer ;create a noteplayer with the correct instrument
    Notes.Instrument(Value1)

    Loop, Parse, Tune, `n, %A_Space%%A_Tab%
    {
        If RegExMatch(A_LoopField,"iS)^\s*\w+((?:\.Note\(\s*\d+\s*(?:,\s*\d+\s*){1,3}\))*)\.Delay\(\s*(-?\d+(?:\.\d+)?)\s*\)",Field)
        {
            Field1 := SubStr(Field1,2) ;remove first dot
            Loop, Parse, Field1, . ;process each note
            {
                Value2 := "", Value3 := "", Value4 := ""
                RegExMatch(A_LoopField,"iS)^Note\(\s*(\d+)\s*(?:,\s*(\d+)\s*(?:,\s*(\d+)\s*(?:,\s*(\d+)\s*)?)?)?",Value)
                If (Value2 = "")
                    Notes.Note(Value1)
                Else If (Value3 = "")
                    Notes.Note(Value1,Value2)
                Else If (Value4 = "")
                    Notes.Note(Value1,Value2,Value3)
                Else
                    Notes.Note(Value1,Value2,Value3,Value4)
            }
            Notes.Delay(Field2)
        }
    }
}
Else
{
    GuiControlGet, Instrument,, Instrument ;retrieve the instrument index

    Notes := new NotePlayer ;create a noteplayer with the correct instrument
    Notes.Instrument(Instrument - 1)

    Loop, Parse, Tune, `n, %A_Space%%A_Tab%
    {
        If RegExMatch(A_LoopField,"iS)^\s*(-?\d+(?:\.\d+)?)\s*(.*)$",Field)
        {
            ;process chord
            StringReplace, Field2, Field2, %A_Tab%, %A_Space%, All ;replace tabs with spaces
            Field2 := Trim(Field2," ") ;trim spaces
            While, InStr(Field2,"  ") ;collapse spaces
                StringReplace, Field2, Field2, %A_Space%%A_Space%, %A_Space%, All
            Loop, Parse, Field2, %A_Space% ;process each note
                Notes.Note(NoteTable[A_LoopField],Field1)
            Notes.Delay(Field1)
        }
    }
}
Notes.Start()
While, Notes.Playing
    Sleep, 10
Notes.Device.__Delete(), Notes := ""
GuiControl, Enable, PlayButton
Return

Convert:
GuiControlGet, Tune,, Tune
If InStr(Tune,"NotePlayer") ;input is code
{
    ;set instrument if present
    If RegExMatch(Tune,"iS)\w\.Instrument(\s*(\d+)\s*)",Value)
        GuiControl, Choose, Instrument, % Value1 + 1

    Result := ""
    Loop, Parse, Tune, `n, %A_Space%%A_Tab%
    {
        If RegExMatch(A_LoopField,"iS)^\s*\w+((?:\.Note\(\s*\d+\s*(?:,\s*\d+\s*){1,3}\))*)\.Delay\(\s*(-?\d+(?:\.\d+)?)\s*\)",Field)
        {
            Result .= Field2 ;insert the duration
            Field1 := SubStr(Field1,2) ;remove first dot
            Loop, Parse, Field1, . ;process each note
            {
                RegExMatch(A_LoopField,"iS)^Note\(\s*\K\d+",Value)
                Result .= " " . NumberTable[Value] ;insert the note
            }
            Result .= "`n"
        }
    }
    Result := SubStr(Result,1,-1)
}
Else
{
    GuiControlGet, Instrument,, Instrument ;retrieve the instrument index

    ;extract the instrument name
    Position := InStr("`n" . Instruments,"`n",1,1,Instrument)
    Name := SubStr(Instruments,Position,InStr(Instruments . "`n","`n",1,Position) - Position)
    StringLower, Name, Name

    ;generate the code
    Result := "Notes := new NotePlayer`nNotes.Instrument(" . (Instrument - 1) . ") `;" . Name . "`n"
    Loop, Parse, Tune, `n, %A_Space%%A_Tab%
    {
        If RegExMatch(A_LoopField,"iS)^\s*(#|-?\d+(?:\.\d+)?)\s*(.*)$",Field)
        {
            If (Field1 = "#") ;comment
                Result .= ";" . Field2 . "`n"
            Else ;note chord
            {
                ;process chord
                Result .= "Notes"
                StringReplace, Field2, Field2, %A_Tab%, %A_Space%, All ;replace tabs with spaces
                Field2 := Trim(Field2," ") ;trim spaces
                While, InStr(Field2,"  ") ;collapse spaces
                    StringReplace, Field2, Field2, %A_Space%%A_Space%, %A_Space%, All
                Loop, Parse, Field2, %A_Space% ;process each note
                    Result .= ".Note(" . NoteTable[A_LoopField] . "," . Field1 . ")"
                Result .= ".Delay(" . Field1 . ")`n"
            }
        }
    }
    Result .= "Notes.Start()"
}
GuiControl,, Tune, %Result%
Return

#Include ..\Music.ahk