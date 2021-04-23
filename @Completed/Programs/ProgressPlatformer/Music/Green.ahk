#NoEnv

/*
Copyright 2011-2012 Anthony Zhang <azhang9@gmail.com>, Henry Lu <redacted@redacted.com>

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

/*
Song: ???
Location: ???
Composer: Henry Lu
*/

Notes := new NotePlayer
Notes.Instrument(28)

Notes.Repeat := 1

Loop, 2
{
    Notes.Note(49,250,75).Note(52,250,75).Delay(250)
    Notes.Note(52,250,75).Note(56,250,75).Delay(250)
    Notes.Note(47,250,75).Note(51,250,75).Delay(250)
    Notes.Note(45,250,55).Note(49,250,55).Delay(500)
    Notes.Note(47,250,65).Note(51,250,65).Delay(500)
}

Notes.Note(49,500,70).Note(52,500,70).Delay(500)
Notes.Note(52,125,70).Note(56,125,70).Delay(125)
Notes.Note(56,125,70).Note(59,125,70).Delay(125)
Notes.Note(51,125,70).Note(57,125,70).Delay(125)
Notes.Note(49,125,70).Note(52,125,70).Delay(125)

Notes.Note(52,125,70).Note(56,125,70).Delay(125)
Notes.Note(47,125,70).Note(51,125,70).Delay(125)
Notes.Note(54,125,70).Note(57,125,70).Delay(125)
Notes.Note(49,125,70).Note(52,125,70).Delay(125)
Notes.Note(52,500,55).Note(56,500,55).Delay(500)

Notes.Note(47,250,65).Note(51,250,65).Delay(500)

Notes.Start()