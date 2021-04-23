#NoEnv

Period := 30
Level := 25

Delay := 80
Timeout := 800

Short := 150
Long := 300
Clear := 600

Mode := "Lowercase"

ModeSwitch := ".-.-"

Actions := Object()

Actions.Lowercase := Object()
Actions.Lowercase[".-"]   := "a"
Actions.Lowercase["-..."] := "b"
Actions.Lowercase["-.-."] := "c"
Actions.Lowercase["-.."]  := "d"
Actions.Lowercase["."]    := "e"
Actions.Lowercase["..-."] := "f"
Actions.Lowercase["--."]  := "g"
Actions.Lowercase["...."] := "h"
Actions.Lowercase[".."]   := "i"
Actions.Lowercase[".---"] := "j"
Actions.Lowercase["-.-"]  := "k"
Actions.Lowercase[".-.."] := "l"
Actions.Lowercase["--"]   := "m"
Actions.Lowercase["-."]   := "n"
Actions.Lowercase["---"]  := "o"
Actions.Lowercase[".--."] := "p"
Actions.Lowercase["--.-"] := "q"
Actions.Lowercase[".-."]  := "r"
Actions.Lowercase["..."]  := "s"
Actions.Lowercase["-"]    := "t"
Actions.Lowercase["..-"]  := "u"
Actions.Lowercase["...-"] := "v"
Actions.Lowercase[".--"]  := "w"
Actions.Lowercase["-..-"] := "x"
Actions.Lowercase["-.--"] := "y"
Actions.Lowercase["--.."] := "z"

Actions.Uppercase := Object()
Actions.Uppercase[".-"]   := "A"
Actions.Uppercase["-..."] := "B"
Actions.Uppercase["-.-."] := "C"
Actions.Uppercase["-.."]  := "D"
Actions.Uppercase["."]    := "E"
Actions.Uppercase["..-."] := "F"
Actions.Uppercase["--."]  := "G"
Actions.Uppercase["...."] := "H"
Actions.Uppercase[".."]   := "I"
Actions.Uppercase[".---"] := "J"
Actions.Uppercase["-.-"]  := "K"
Actions.Uppercase[".-.."] := "L"
Actions.Uppercase["--"]   := "M"
Actions.Uppercase["-."]   := "N"
Actions.Uppercase["---"]  := "O"
Actions.Uppercase[".--."] := "P"
Actions.Uppercase["--.-"] := "Q"
Actions.Uppercase[".-."]  := "R"
Actions.Uppercase["..."]  := "S"
Actions.Uppercase["-"]    := "T"
Actions.Uppercase["..-"]  := "U"
Actions.Uppercase["...-"] := "V"
Actions.Uppercase[".--"]  := "W"
Actions.Uppercase["-..-"] := "X"
Actions.Uppercase["-.--"] := "Y"
Actions.Uppercase["--.."] := "Z"

Actions.Numbers := Object()
Actions.Numbers[".-"]   := "1"
Actions.Numbers["-..."] := "2"
Actions.Numbers["-.-."] := "3"
Actions.Numbers["-.."]  := "4"
Actions.Numbers["."]    := "5"
Actions.Numbers["..-."] := "6"
Actions.Numbers["--."]  := "7"
Actions.Numbers["...."] := "8"
Actions.Numbers[".."]   := "9"
Actions.Numbers[".---"] := "0"

Actions.Other := Object()
Actions.Other[".-"]   := " "
Actions.Other["-..."] := "."
Actions.Other["-.-."] := "!"
Actions.Other["-.."]  := "?"
Actions.Other["."]    := ","
Actions.Other["..-."] := "("
Actions.Other["--."]  := ")"
Actions.Other["...."] := "+"
Actions.Other[".."]   := "-"
Actions.Other[".---"] := "*"
Actions.Other["-.-"]  := "/"
Actions.Other[".-.."] := "="
Actions.Other["--"]   := """"

;international Morse Code
;Actions := Object(".-","A","-...","B","-.-.","C","-..","D",".","E","..-.","F","--.","G","....","H","..","I",".---","J","-.-","K",".-..","L","--","M","-.","N","---","O",".--.","P","--.-","Q",".-.","R","...","S","-","T","..-","U","...-","V",".--","W","-..-","X","-.--","Y","--..","Z",".----","1","..---","2","...--","3","....-","4",".....","5","-....","6","--...","7","---..","8","----.","9","-----","0")

If MicrophoneOpen()
{
    MsgBox, Could not open microphone.
    ExitApp
}

Pattern := ""
Loop
{
    ;process the silence
    Time := A_TickCount
    While, MicrophoneLevel() < Level
    {
        If (A_TickCount - Time) > Timeout && Pattern != ""
        {
            Gosub, ProcessPattern
            Pattern := ""
        }
        Sleep, Period
    }

    Time := A_TickCount
    Loop
    {
        ;process the tone
        While, MicrophoneLevel() >= Level
            Sleep, Period

        ;ensure that the tone ends with a length of silence
        Temp1 := A_TickCount
        While, MicrophoneLevel() < Level
        {
            If (A_TickCount - Temp1) > Delay
                Break, 2
            Sleep, Period
        }
    }
    Time := Temp1 - Time

    If (Time >= Clear)
        Pattern := ""
    Else If (Time >= Long)
        Pattern  .= "-"
    Else If (Time >= Short)
        Pattern .= "."

    If (Pattern = "")
        ToolTip
    Else If (Pattern = ModeSwitch)
        ToolTip, Pattern: "%Pattern%"`nMode switch
    Else
    {
        Action := Actions[Mode].HasKey(Pattern) ? Actions[Mode][Pattern] : "Unknown"
        ToolTip, Pattern: "%Pattern%"`nResult: "%Action%"
    }
}
Return

ProcessPattern:
If (Pattern = ModeSwitch)
{
    PreviousMode := Mode
    If (Mode = "Lowercase")
        Mode := "Uppercase"
    Else If (Mode = "Uppercase")
        Mode := "Numbers"
    Else If (Mode = "Numbers")
        Mode := "Other"
    Else If (Mode = "Other")
        Mode := "Lowercase"
    Else
        throw Exception("Unknown mode: " . Mode)
    ToolTip, Mode switched from "%PreviousMode%" to "%Mode%".
    Return
}
ToolTip
If !Actions[Mode].HasKey(Pattern)
    Return
Action := Actions[Mode][Pattern]
SendInput, %Action%
Return

Esc::ExitApp

MicrophoneOpen()
{
    DllCall("LoadLibrary","Str","winmm")
    Return DllCall("winmm\mciSendString","Str","open new alias ScriptMicrophone type waveaudio wait","UPtr",0,"UInt",0,"UPtr",0)
}

MicrophoneLevel()
{
    VarSetCapacity(Value,16,0)
    If DllCall("winmm\mciSendString","Str","status ScriptMicrophone level","UPtr",&Value,"UInt",16,"UPtr",0)
        Return 0
    Return ((StrGet(&Value,16) - 1) / 127) * 100
}