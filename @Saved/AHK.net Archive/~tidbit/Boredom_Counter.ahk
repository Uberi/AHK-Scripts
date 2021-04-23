#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance force

Menu, tray, add
Menu, tray, add, Show, view
Menu, tray, add, log, log

Gui, +Owner
oo=1
s=0
m=0
h=0


OnExit, ExitSub

Gui, Add, Text, x6 y8 w100 h20 , Time Bored:
Gui, Add, Button, x6 y58 w100 h20 +Default vButton ginc, Start
Gui, Add, Edit, x6 y28 w100 h20 +ReadOnly +Number vdisp, %h%H%a_Space% %m%M%a_Space% %s%S
;Gui, Show, x6 y480, Boredom Counter
Gosub, start
Return

inc:
    oo+=1
    If oo>=2
        oo=0
    Gosub, start
Return


start:
    If oo=0
    {
        GuiControl, , Button, Start
        SetTimer, update, off
    }
    If oo=1
    {
        GuiControl, , Button, Pause
        SetTimer, update, on
        SetTimer, update, 1000
    }
Return


update:
    s+=1
    GuiControl, text, disp, %h%H%a_Space% %m%M%a_Space% %s%S
    If s>=60
    {
        m+=1
        s=0
    }
    If m>=60
    {
        h+=1
        m=0
    }
Return

view:
    Gui, Show,, Boredom Counter
Return

log:
    IfExist, %a_scriptdir%\Bored_log.txt
        Run, %a_scriptdir%\Bored_log.txt
Return

GuiClose:
    ExitApp
Return

GuiSize:
    If Errorlevel=1
        Gui, Cancel
Return



ExitSub:
    FormatTime, logdate,, dddd MMMM d, yyyy
    FileAppend, %logdate%: %a_tab% %h%H%a_Space% %m%M%a_Space% %s%S`n, %a_scriptdir%\Bored_log.txt
    ExitApp

