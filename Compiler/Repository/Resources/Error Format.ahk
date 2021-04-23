#NoEnv

/*
Copyright 2011-2013 Anthony Zhang <azhang9@gmail.com>

This file is part of Autonomy. Source code is available at <https://github.com/Uberi/Autonomy>.

Autonomy is free software: you can redistribute it and/or modify
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
Error Array Format
------------------

[Index]:          index of the error                [Object]
    Level:        severity of the error             [String: "Error", "Warning", or "Notice"]
    Identifier:   name of the error                 [Identifier]
    Caret:        exact location of error           [Object or Number: 0]
        Position: position to place the caret       [Integer]
        Length:   length of the caret               [Integer]
    Highlight:    the optional area to highlight    [Object or Number: 0]
        Position: position of highlighted section   [Integer]
        Length:   length of the highlighted section [Integer]

Example
-------

    4:
        Level: Error
        Identifier: INVALID_SYNTAX
        Caret:
            Position: 17
            Length: 2
        Highlight:
            Position: 13
            Length: 3

Error Levels
------------

* Level 1: Notice: Information about unusual sections of code. Integrity of output will most likely not be affected.
* Level 2: Warning: Possible error in code. Integrity of output may be affected
* Level 3: Error: Invalid code detected. Integrity of output cannot be guaranteed.
*/

;creates a formatted summary of errors
CodeErrorFormat(ByRef Code,ByRef Errors,ByRef Files)
{
    static CodeErrorMessages := Object("UNMATCHED_QUOTE",          "Missing closing quotation mark."
                                      ,"INVALID_CHARACTER",        "Character is invalid."
                                      ,"INVALID_IDENTIFIER",       "Identifier contains invalid characters."
                                      ,"INVALID_OBJECT_ACCESS",    "Invalid identifier given for object access." ;wip: not sure if still necessary
                                      ,"INVALID_CONCATENATION",    "Concatenation operator must have whitespace on both sides."
                                      ,"FILE_ERROR",               "Could not load file."
                                      ,"DUPLICATE_INCLUSION",      "File has already been referenced by an inclusion directive."
                                      ,"UNDEFINED_MACRO",          "Undefined macro referenced."
                                      ,"INVALID_DIRECTIVE_SYNTAX", "Incorrect directive syntax."
                                      ,"PARENTHESIS_MISMATCH",     "Unmatched parenthesis."
                                      ,"DUPLICATE_DEFINITION",     "Duplicate definition.")

    TextPadding := 15 ;number of characters to display on either side of the error
    CaretChar := "^" ;character representing the caret
    HighlightChar := "-" ;character representing the highlights

    ErrorLevels := ["Notice","Warning","Error"]

    ErrorReport := ""
    For ErrorIndex, CurrentError In Errors
    {
        CodeGetErrorBounds(CurrentError,ErrorStart,ErrorEnd)

        ;move back one character if there is a newline at the end
        Temp1 := SubStr(Code,ErrorEnd - 1,1)
        If (Temp1 = "`r" || Temp1 = "`n") ;newline found at the end of the error
            ErrorEnd --

        ;ensure there is enough padding for the highlights and caret
        ErrorDisplay := ""
        Loop, % ErrorEnd - ErrorStart
            ErrorDisplay .= " "

        ;iterate over the error highlights to highlight the incorrect code
        CurrentHighlight := CurrentError.Highlight
        If IsObject(CurrentHighlight) ;wip: maybe CurrentHighlight is always an object?
        {
            For Index, Highlight In CurrentHighlight
            {
                Position := (Highlight.Position - ErrorStart) + 1, Length := Highlight.Length
                If (Position < 1)
                    Position := 1
                Temp1 := SubStr(ErrorDisplay,1,Position - 1)
                Loop, %Length%
                    Temp1 .= HighlightChar
                ErrorDisplay := Temp1 . SubStr(ErrorDisplay,Position + Length)
            }
        }

        ;insert the caret to show the exact location of the error
        Caret := CurrentError.Caret
        If IsObject(Caret)
        {
            CaretPosition := Caret.Position, Length := Caret.Length
            Position := (CaretPosition - ErrorStart) + 1
            If (Position < 1)
                Position := 1
            Temp1 := SubStr(ErrorDisplay,1,Position - 1)
            Loop, %Length%
                Temp1 .= CaretChar
            ErrorDisplay :=  Temp1 . SubStr(ErrorDisplay,Position + Length)
        }
        Else
            CaretPosition := ErrorStart

        CodeGetErrorShowBefore(Code,ErrorSection,ErrorDisplay,ErrorStart,TextPadding)
        ErrorSection .= SubStr(Code,ErrorStart,ErrorEnd - ErrorStart) ;show the code that is causing the error
        CodeGetErrorShowAfter(Code,ErrorSection,ErrorEnd,TextPadding)
        CodeGetErrorPosition(Code,Caret,Line,Column)
        CodeGetErrorPosition(Code,CaretPosition,Line,Column)
        Temp1 := CurrentError.Identifier
        If CodeErrorMessages.HasKey(Temp1)
            Message := CodeErrorMessages[Temp1] ;get the error message
        Else
            Message := "Unknown error."

        ErrorReport .= ErrorLevels[CurrentError.Level] . " in """ . Files[CurrentError.File] . """ (Line " . Line . ", Column " . Column . "): " . Message
                    . "`nSpecifically: " . ErrorSection . "`n              " . ErrorDisplay . "`n`n"
    }
    Return, ErrorReport
}

;retrieves the boundaries of the error
CodeGetErrorBounds(CurrentError,ByRef ErrorStart,ByRef ErrorEnd)
{
    ErrorStart := 0, ErrorEnd := 0
    For Index, Highlight In CurrentError.Highlight
    {
        Temp1 := Highlight.Position, Temp2 := Temp1 + Highlight.Length
        If (A_Index = 1)
            ErrorStart := Temp1, ErrorEnd := Temp2
        Else
        {
            If (Temp1 < ErrorStart)
                ErrorStart := Temp1
            If (Temp2 > ErrorEnd)
                ErrorEnd := Temp2
        }
    }
    Caret := CurrentError.Caret
    If IsObject(Caret)
    {
        Temp1 := Caret.Position, Temp2 := Temp1 + Caret.Length
        If (Temp1 < ErrorStart || ErrorStart = 0)
            ErrorStart := Temp1
        If (Temp2 > ErrorEnd || ErrorEnd = 0)
            ErrorEnd := Temp2
    }
}

;show some of the code in the current line, before the error, and pad the error display accordingly
CodeGetErrorShowBefore(ByRef Code,ByRef ErrorSection,ByRef ErrorDisplay,ErrorStart,TextPadding)
{
    ;get the beginning of the line containing the error
    Temp2 := (ErrorStart - 1) - StrLen(Code)
    Temp1 := InStr(Code,"`r",1,Temp2), Temp2 := InStr(Code,"`n",1,Temp2)
    Temp2 := ((Temp1 > Temp2) ? Temp1 : Temp2) + 1

    ;retrieve the code and pad the error display
    Temp1 := ErrorStart - TextPadding
    Temp2 := (Temp1 < Temp2) ? Temp2 : Temp1 ;get start of the section to display
    Temp1 := ErrorStart - Temp2
    ErrorSection := SubStr(Code,Temp2,Temp1), Pad := ""
    Loop, %Temp1%
        Pad .= " "
    ErrorDisplay := Pad . ErrorDisplay
}

;show some of the code in the current line, after the error
CodeGetErrorShowAfter(ByRef Code,ByRef ErrorSection,ErrorEnd,TextPadding)
{
    ;get the end of the line containing the error
    Temp1 := InStr(Code,"`r",1,ErrorEnd), Temp2 := InStr(Code,"`n",1,ErrorEnd)
    If (Temp2 = 0)
        Temp2 := Temp1
    Else If (Temp1 > 0)
        Temp2 := (Temp1 < Temp2) ? Temp1 : Temp2

    ;retrieve the code
    TextPadding += ErrorEnd
    If (TextPadding > Temp2)
        TextPadding := Temp2
    ErrorSection .= SubStr(Code,ErrorEnd,TextPadding - ErrorEnd)
}

;finds the line and column the error occurred on
CodeGetErrorPosition(ByRef Code,Position,ByRef Line,ByRef Column)
{
    Temp1 := "`n" . SubStr(Code,1,Position - 1)
    StringReplace, Temp1, Temp1, `r`n, `n, All
    StringReplace, Temp1, Temp1, `r, `n, All
    StringReplace, Temp1, Temp1, `n, `n, UseErrorLevel
    Line := ErrorLevel, Column := StrLen(SubStr(Temp1,InStr(Temp1,"`n",1,0) + 1)) + 1
}