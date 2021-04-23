#NoEnv

/*
Copyright 2011-2012 Anthony Zhang <azhang9@gmail.com>

This file is part of AutoHotkey.net Website Generator. Source code is available at <https://github.com/Uberi/AutoHotkey.net-Website-Generator>.

AutoHotkey.net Website Generator is free software: you can redistribute it and/or modify
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

CreateDirectory(Directory)
{
    FileCreateDir, %Directory%
    Return, ErrorLevel
}

;parses a given cache into a cache object
ReadCache(Cache)
{
    Cache := Trim(Cache," `t`n") ;remove leading and trailing whitespace and newlines
    Result := Object()
    Loop, Parse, Cache, `n, %A_Space%`t ;loop through each cache entry
    {
        Entry := Object()
        Position := InStr(A_LoopField,"`t"), URL := SubStr(A_LoopField,1,Position - 1), Field := SubStr(A_LoopField,Position + 1) ;extract the URL field
        Position := InStr(Field,"`t"), Entry.Image := SubStr(Field,1,Position - 1), Field := SubStr(Field,Position + 1) ;extract the image field
        Position := InStr(Field,"`t"), Entry.Source := SubStr(Field,1,Position - 1), Field := SubStr(Field,Position + 1) ;extract the source field
        Entry.Description := Field ;extract the description field
        Result[URL] := Entry ;add the entry to the cache object
    }
    Return, Result
}

;converts a cache object into the cache file format
SaveCache(Cache)
{
    Result := ""
    For URL, Entry In Cache
        Result .= URL . "`t" . Entry.Image . "`t" . Entry.Source . "`t" . Entry.Description . "`n"
    Return, SubStr(Result,1,-1)
}

;sorts an array of results by title
SortByTitle(InputObject)
{
    ;merge sort algorithm
    MaxIndex := ObjMaxIndex(InputObject), (MaxIndex = "") ? (MaxIndex := 0) : ""
    If MaxIndex < 2
        Return, InputObject
    Middle := MaxIndex >> 1, SortLeft := Object(), SortRight := Object()
    Loop, %Middle%
        ObjInsert(SortLeft,InputObject[A_Index]), ObjInsert(SortRight,InputObject[Middle + A_Index])
    If (MaxIndex & 1)
        ObjInsert(SortRight,InputObject[MaxIndex])
    SortLeft := SortByTitle(SortLeft), SortRight := SortByTitle(SortRight), MaxRight := MaxIndex - Middle, LeftIndex := 1, RightIndex := 1, Result := Object()
    Loop, %MaxIndex%
    {
        If (LeftIndex > Middle)
            ObjInsert(Result,SortRight[RightIndex]), RightIndex ++
        Else If ((RightIndex > MaxRight) || (SortLeft[LeftIndex].Title < SortRight[RightIndex].Title))
            ObjInsert(Result,SortLeft[LeftIndex]), LeftIndex ++
        Else
            ObjInsert(Result,SortRight[RightIndex]), RightIndex ++
    }
    Return, Result
}

;converts a path into an absolute path
ExpandPath(Path)
{
    Loop, %Path%, 2
        Return, A_LoopFileLongPath
}