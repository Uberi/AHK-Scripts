#NoEnv

#Include ..\Classifier.ahk

c := new Classifier

FileRead, Data, Features.txt
If !ErrorLevel
    c.Features := ParseObject(Data)
FileRead, Data, Items.txt
If !ErrorLevel
    c.Items := ParseObject(Data)

Item = 
(
[FUNCTION] Custom multi style Message Box

As i was working on a script, i realized i needed a more flexible message box than the built-in one. I searched the forum, found an existing function, realized i still wanted something more flexible, and started working on my own. It's now working properly (at least in all my tests) so i decided to share it.
I know there are already a couple of those but i tried to make this one as customizable as possible so other people might find it useful.

Features
Easy to use. Put in your library and use as any built-in functions. Only two parameters are required by default.
You can add any number of buttons, making any button the default one is as easy as putting * in front if it's name.
Non Closing Buttons : Define one or more non closing buttons by adding + in front of their name. When the use clicks those, the message bow won't automatically close so you can display a help box or something similar and still wait for their input.
Use one of 7 system message icon and associated system sound.
Choose between vertical and horizontal buttons.
Change font, font size and text area for tiny or huge message boxes.
Use any optional GUI style like +Toolwindow or -Sysmenu

Requirements
AutoHotKey_L is required.
)

Result := "Category`tProbability`n"
For Index, Entry In c.Classify(Item)
    Result .= Entry.Category . "`t" . Entry.Probability . "`n"
MsgBox, %Result%

ParseObject(ObjectDescription)
{
    ListLines, Off
    PreviousIndentLevel := 1, PreviousKey := "", Result := Object(), ObjectPath := [], PathIndex := 0, TempObject := Result ;initialize values
    Loop, Parse, ObjectDescription, `n, `r ;loop over each line of the object description
    {
        IndentLevel := 1
        While, (SubStr(A_LoopField,A_Index,1) = "`t") ;retrieve the indentation level
            IndentLevel ++
        Temp1 := InStr(A_LoopField,":",0,IndentLevel)
        If !Temp1 ;not a key-value pair, treat as a continuation of the value of the previous pair
        {
            TempObject[PreviousKey] .= "`n" . A_LoopField
            Continue
        }
        Key := SubStr(A_LoopField,IndentLevel,Temp1 - IndentLevel), Value := SubStr(A_LoopField,Temp1 + 2)
        If (IndentLevel = PreviousIndentLevel) ;sibling object
            TempObject[Key] := Value
        Else If (IndentLevel > PreviousIndentLevel) ;nested object
            TempObject[PreviousKey] := Object(Key,Value), TempObject := TempObject[PreviousKey], ObjInsert(ObjectPath,PreviousKey), PathIndex ++
        Else ;(IndentLevel < PreviousIndentLevel) ;parent object
        {
            Temp1 := PreviousIndentLevel - IndentLevel, ObjRemove(ObjectPath,PathIndex - Temp1,PathIndex), PathIndex -= Temp1 ;update object path

            ;get parent object
            TempObject := Result
            Loop, %PathIndex%
                TempObject := TempObject[ObjectPath[A_Index]]
            TempObject[Key] := Value
        }
        PreviousIndentLevel := IndentLevel, PreviousKey := Key
    }
    ListLines, On
    Return, Result
}