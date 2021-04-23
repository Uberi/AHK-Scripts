; Last updated 8-21-09
/*
Trimmed some areas that could be reduced to lower the overall script size.
*/
Gui, Add, Text, x170 y25 w50 h20 , EasyAHK
Gui, Add, Button, x16 y55 w100 h30 , GUI
Gui, Add, Button, x146 y55 w100 h30 , IF
Gui, Add, Button, x276 y55 w100 h30 , Send
Gui, Add, Button, x16 y95 w100 h30 , URLDownToFile
Gui, Add, Button, x146 y95 w100 h30 , Else
Gui, Add, Button, x276 y95 w100 h30 , MsgBox
Gui, Add, Button, x16 y135 w100 h30 , Variable
Gui, Add, Button, x146 y135 w100 h30 , Return
Gui, Add, Button, x276 y135 w100 h30 , FileAppend
Gui, Add, Button, x16 y175 w100 h30 , FileRead
Gui, Add, Button, x146 y175 w100 h30 , TrayTip
Gui, Add, Button, x276 y175 w100 h30 , Sleep
Gui, Add, Button, x16 y215 w100 h30 , FileDelete
Gui, Add, Button, x146 y215 w100 h30 , InputBox
Gui, Add, Button, x276 y215 w100 h30 , FileCopy
Gui, Add, Button, x16 y255 w100 h30 , Button
Gui, Add, Button, x146 y255 w100 h30 , HotKey
Gui, Add, Button, x276 y255 w100 h30 , GUISubmit
Gui, Add, Button, x16 y295 w100 h30 , GUIDestroy
Gui, Add, Button, x146 y295 w100 h30 , Loop
Gui, Add, Button, x276 y295 w100 h30 , Comment
Gui, Add, Button, x10 y347 w150 h30, View/Edit
Gui, Add, Button, x160 y347 w72 h30, Test
Gui, Add, Button, x232 y347 w150 h30, Delete
;Off-Screen Controls
Gui, Add, Edit, vEdit x392 y0 w300 h347
Gui, Add, Text, x485 y357, Press Control+S to save..
Gui, Show, h377 w392, EasyAHK
varif = off
varelse = off
varloop = off
open = false
viewbutton = off
Progress, b w200,, Checking for Updates..., Updating
Update:
URLDownloadToFile, http://www.autohotkey.net/~Tchnclfl/EasyAHK/EasyAHK.ahk, update.txt
Progress, 20
FileReadLine, update, update.txt, 1
Progress, 40
if (update = "; Last updated 8-21-09") {
  FileDelete, update.txt
  Progress, 100
  sleep, 700
  Progress, Off
  GoTo ChooseName
} else {
  if (update = "") {
    Progress, 100
	sleep, 700
	Progress, Off
	msgbox, There may be a new version of EasyAHK available, but there was a problem connecting to the server.  Please diagnose your internet connection and try again.
    GoTo ChooseName
  } else {
  uptodate = false
  Progress, 60
  FileReadLine, reason, update.txt, 3
  Progress, 100
  Progress, Off
  msgbox, A new version of EasyAHK has been released!  Please press F6 to update to the latest version, or F4 to continue with this version.`n`nReson for update: %reason%
  F6::
  FileCopy, update.txt, EasyAHK.ahk, 1
  FileDelete, update.txt
  Progress, b w200,, Checking for Updates..., Updating
  Progress, 100
  sleep, 700
  Progress, Off
  msgbox, EasyAHK will now close.  Please restart it to apply the update!
  ExitApp
  return
  F4::
  Progress, b w200,, Checking for Updates..., Updating
  Progress, 100
  sleep, 700
  Progress, Off
  msgbox, EasyAHK will not be updated!  Please press Control+N to start a new project.
  FileDelete, update.txt
  return
  }
}
ChooseName:
InputBox, name, Name, Choose a name for your file (or press F2 and type the name of a saved AHK project.)`n`n`nFor help with this program`, please press F1!
if ErrorLevel {
  TrayTip, Error, You did not choose a name!, 5, 3
  GoTo ChooseName
} else {
  if (name = "") {
    TrayTip, Error, You must choose a name!, 5, 3
	GoTo ChooseName
  } else {
    if (open = "false") {
	  FileAppend,; This project was created using EasyAHK, %name%.ahk
      TrayTip, %name%.ahk, Project %name%.ahk started!, 5, 1
	  FileRead, view, %name%.ahk
	  GuiControl,, Edit, %view%
	} else {
	  open = false
	  TrayTip, Opened File, You opened the file %name%.ahk!
	  ;Begin "View" update
      FileRead, view, %name%.ahk
      GuiControl,, Edit, %view%
      ;End "View" Update
	}
  }
}
return
GuiClose:
msgbox, 4, Quit?, Are you sure you want to quit?
IfMsgBox Yes
  ExitApp
else
  return
Esc::
msgbox, 4, Quit?, Are you sure you want to quit?
IfMsgBox Yes
  ExitApp
else
  return
^N::
GoTo ChooseName
return
F2::
open = true
TrayTip, Open File, Type the name of your file into the field to open a previously saved file.., 5, 1
return
F1::
msgbox, This script was created to make it simpler and more intuitive to create basic AutoHotKey scripts.  Although it was primarily designed for beginners who are just getting used to AutoHotKey`, it can prove useful to people who are more veteran to AHK.  To add one of the basic commands listed`, click the button labeled what you need.  You will most likely be led through a few InputBoxes that will ask for information about the command you are attempting to insert, and then insert it for you`n`nTo view your current script`, as it is`, press the "View/Edit" button at any time.  You may leave this window open while adding commands and it will automatically update.  `nTo edit the script manually`, press the "View/Edit" button at any time.  Don't forget to Press Control+S after you are done manually editing`, or your work will not be saved!  `nIf you do not see the command you would like to use`, you can simply use the View/Edit function to add it yourself.`nTo completely delete your script`, press the Delete button.`nTo Run your script`, press the "Run" Button.`n`nThanks for trying it out`, and if you have any questions`, please post/contact me!
return
^S::
Gui, Submit, NoHide
FileDelete, %name%.ahk
FileAppend, %Edit%, %name%.ahk
TrayTip, Manual Edit, Your script has been manually edited., 5, 1
return
;
;-------------
;Buttons
;-------------
;
ButtonGUI:
IfExist, SmartGUI.exe
  run, SmartGUI.exe
IfNotExist, SmartGUI.exe
  msgbox, SmartGUI either not installed or not in this directory.  Please download or move!
 return
 ;
 ;
 ;
 ButtonIF:
if (varif = "off") {
    InputBox, statement, IF Scenario, Type the scenario here without parenthesis; EXAMPLE:   variable = off
    if ErrorLevel
	  return
	else
	FileAppend, `nif (%statement%) {, %name%.ahk
	varif = on
	;Begin "View" update
    FileRead, view, %name%.ahk
    GuiControl,, Edit, %view%
    ;End "View" Update
	TrayTip, IF, "if (%statement%)" was added to your script!  Press the IF button again to close the tag., 5, 1
} else {
  if (varif = "on") {
    FileAppend, `n}, %name%.ahk
	varif = off
	;Begin "View" update
    FileRead, view, %name%.ahk
    GuiControl,, Edit, %view%
    ;End "View" Update
    TrayTip, IF, IF statement has been closed., 5, 1
  }
}
return
;
;
;
ButtonElse:
if (varelse = "off") {
  if ErrorLevel
	return
  else
  FileAppend, ` else {, %name%.ahk
  varelse = on
  ;Begin "View" update
  FileRead, view, %name%.ahk
  GuiControl,, Edit, %view%
  ;End "View" Update
  TrayTip, Else, Else has been added to the end of the last line.  Press Else again to close the tag., 5, 1
} else {
  if (varelse = "on") {
    FileAppend, `n}, %name%.ahk
	varelse = off
	;Begin "View" update
    FileRead, view, %name%.ahk
    GuiControl,, Edit, %view%
    ;End "View" Update
	TrayTip, Else, Your Else tag has been closed., 5, 1
  }
}
return
;
;
;
ButtonMsgBox:
InputBox, msg, MsgBox, Type the text to be displayed in the message box here, including options.
if ErrorLevel
  return
else
FileAppend, `nMsgBox`, %msg%, %name%.ahk
;Begin "View" update
FileRead, view, %name%.ahk
GuiControl,, Edit, %view%
;End "View" Update
TrayTip, MsgBox, Your message box has been addedl., 5, 1
return
;
;
;
ButtonVariable:
InputBox, var, Variable, Enter the name for your variable
if ErrorLevel
  return
else
InputBox, value, Value, Enter the value or contents of your variable
if ErrorLevel
  return
else
FileAppend, `n%var% = %value%, %name%.ahk
;Begin "View" update
FileRead, view, %name%.ahk
GuiControl,, Edit, %view%
;End "View" Update
TrayTip, %var%, Your variable`, %var%`, has been set to equal %value%., 5, 1
return
;
;
;
ButtonReturn:
FileAppend, `nreturn, %name%.ahk
;Begin "View" update
FileRead, view, %name%.ahk
GuiControl,, Edit, %view%
;End "View" Update
TrayTip, Return, A return command has been added to your script., 5, 1
Return
;
;
;
ButtonSend:
InputBox, send, Send, Please type what you would like the script to send.
if ErrorLevel
  return
else
FileAppend, `nsend`, %send%, %name%.ahk
;Begin "View" update
FileRead, view, %name%.ahk
GuiControl,, Edit, %view%
;End "View" Update
TrayTip, Send, A command to send %send% has been added to your script., 5, 1
return
;
;
;
ButtonURLDownToFile:
InputBox, URL, URL, Please type the URL to download
if ErrorLevel
  return
else
InputBox, filename, File Name, Please type the name to save the file as
if ErrorLevel
  return
else
FileAppend, `nURLDownloadToFile`, %URL%`, %filename%, %name%.ahk
;Begin "View" update
FileRead, view, %name%.ahk
GuiControl,, Edit, %view%
;End "View" Update
TrayTip, URLDownloadToFile, A command to download %URL% to the file %filename% has been added to your script., 5, 1
return
;
;
;
ButtonFileAppend:
InputBox, text, Text, Type the text to be added to the file
if ErrorLevel
  return
else
InputBox, appendedfile, Append To, Type the file to append the text to
if ErrorLevel
  return
else
FileAppend, `nFileAppend`, %text%`, %appendedfile%, %name%.ahk
;Begin "View" update
FileRead, view, %name%.ahk
GuiControl,, Edit, %view%
;End "View" Update
TrayTip, FileAppend, A command to append your text to %appendedfile% has been added to your script., 5, 1
return
;
;
;
ButtonFileRead:
InputBox, readvar, Variable Select, Please type a variable to read the file to
if ErrorLevel
  return
else
InputBox, readfile, File Select, Please choose a file to read from
if ErrorLevel
  return
else
FileAppend, `nFileRead`, %readvar%`, %readfile%, %name%.ahk
;Begin "View" update
FileRead, view, %name%.ahk
GuiControl,, Edit, %view%
;End "View" Update
TrayTip, FileRead, A command to FileRead %readfile% to %readvar% has been added to your script., 5, 1
return
;
;
;
ButtonTrayTip:
InputBox, traytiptitle, Title, Please choose a title for your TrayTip
if ErrorLevel
  return
else
InputBox, traytipcontents, Contents, Please type the contents of your tray tip, including any options
if ErrorLevel
  return
else
FileAppend, `nTrayTip`, %traytiptitle%`, %traytipcontents%, %name%.ahk
;Begin "View" update
FileRead, view, %name%.ahk
GuiControl,, Edit, %view%
;End "View" Update
TrayTip, TrayTip, A command to use a TrayTip titled %traytiptitle% has been added to your script., 5, 1
return
;
;
;
ButtonSleep:
InputBox, sleeptime, Sleep Time, Please enter the time to sleep in seconds.`n`nExample: 15
if ErrorLevel
  return
else
sleepthousands:= sleeptime * 1000
FileAppend, `nSleep`, %sleepthousands%, %name%.ahk
;Begin "View" update
FileRead, view, %name%.ahk
GuiControl,, Edit, %view%
;End "View" Update
TrayTip, Sleep, A command to sleep %sleeptime% seconds has been added to your script., 5, 1
return
;
;
;
ButtonComment:
InputBox, comment, Comment, Type the comment to be added to your script.
if ErrorLevel
  return
else
FileAppend, `n`; %comment%, %name%.ahk
;Begin "View" update
FileRead, view, %name%.ahk
GuiControl,, Edit, %view%
;End "View" Update
TrayTip, Comment, Your comment has been added to the end of your script.
return
;
;
;
ButtonFileDelete:
InputBox, deletedfile, File, Please type which file to delete.
if ErrorLevel
  return
else
FileAppend, `nFileDelete`, %deletedfile%, %name%.ahk
;Begin "View" update
FileRead, view, %name%.ahk
GuiControl,, Edit, %view%
;End "View" Update
TrayTip, FileDelete, A command to FileDelete %deletedfile% has been added to your script., 5, 1
return
;
;
;
ButtonInputBox:
InputBox, inputvariable, Variable, Please type a variable to store the user input in.
if ErrorLevel
  return
else
InputBox, inputtitle, Title, Please type a title for the InputBox.
if ErrorLevel
  return
else
InputBox, inputcontent, Content, Please type the content of the InputBox.
if ErrorLevel
  return
else
FileAppend, `nInputBox`, %inputvariable%`, %inputtitle%`, %inputcontent%, %name%.ahk
;Begin "View" update
FileRead, view, %name%.ahk
GuiControl,, Edit, %view%
;End "View" Update
TrayTip, InputBox, Your InputBox titled "%inputtitle%" has been added to your script., 5, 1
return
;
;
;
ButtonFileCopy:
InputBox, copysource, Source, Please type the path of the source file you wish to copy.
if ErrorLevel
  return
else
InputBox, copylocation, Location, Please type the file and path where you want the file to be copied to.
if ErrorLevel
  return
else
FileAppend, `nFileCopy`, %copysource%`, %copylocation%, %name%.ahk
;Begin "View" update
FileRead, view, %name%.ahk
GuiControl,, Edit, %view%
;End "View" Update
TrayTip, FileCopy, A command to copy %copysource% to %copylocation% has been added to your script., 5, 1
return
;
;
;
ButtonButton:
InputBox, buttonname, Button Name, Type the name of the button you wish to state commands for when pushed.`n`nAlways remember to add a "return" when done stating a button's commands!
if ErrorLevel
  return
else
FileAppend, `nButton%buttonname%:, %name%.ahk
;Begin "View" update
FileRead, view, %name%.ahk
GuiControl,, Edit, %view%
;End "View" Update
TrayTip, Button, You have started the commands for Button "%buttonname%"., 5, 1
return
;
;
;
ButtonHotKey:
InputBox, combo, Hot Key, Type the hotkey you would like to add a command to.`nRemember to use ^ for Control`, ! for Alt`, and # for the "Windows" Key.
if ErrorLevel
  return
else
FileAppend, `n%combo%::, %name%.ahk
;Begin "View" update
FileRead, view, %name%.ahk
GuiControl,, Edit, %view%
;End "View" Update
TrayTip, Hot Key, You have started the commands for Hot Key "%combo%"., 5, 1
return
;
;
;
ButtonGUISubmit:
FileAppend, `nGui`, Submit`, NoHide, %name%.ahk
;Begin "View" update
FileRead, view, %name%.ahk
GuiControl,, Edit, %view%
;End "View" Update
TrayTip, GUI Submit, A command to "Gui`, Submit`, NoHide" has been added to your script., 5, 1
return
;
;
;
ButtonGUIDestroy:
FileAppend, `nGui`, Destroy, %name%.ahk
;Begin "View" update
FileRead, view, %name%.ahk
GuiControl,, Edit, %view%
;End "View" Update
TrayTip, GUI Destroy, A command to "Gui`, Destroy" has been added to your script., 5, 1
return
;
;
;
ButtonLoop:
if (varloop = "off") {
  InputBox, iterations, Iterations, How many times would you like this to loop for?`n`nLeave blank for infinite.
  if ErrorLevel
    return
  else
  FileAppend, `nLoop`, %iterations%`n{, %name%.ahk
  varloop = on
  ;Begin "View" update
  FileRead, view, %name%.ahk
  GuiControl,, Edit, %view%
  ;End "View" Update
  TrayTip, Loop, A command to loop has been added to your script.  Press Loop again to close the loop., 5, 1
} else {
  FileAppend, `n}, %name%.ahk
  varloop = off
  ;Begin "View" update
  FileRead, view, %name%.ahk
  GuiControl,, Edit, %view%
  ;End "View" Update
  TrayTip, Loop, The open loop has been closed., 5, 1
}
  return
;
;-------------------------
;View/Delete/Test Buttons
;-------------------------
;
ButtonView/Edit:
if (viewbutton = "off") {
  viewbutton = on
  Gui, Show, h377 w692, EasyAHK
  ;Begin "View" update
  FileRead, view, %name%.ahk
  GuiControl,, Edit, %view%
  ;End "View" Update
  TrayTip, You have opened View/Edit, You can view your script as it progresses along.  If you want to manually add something`, just type it where ever you need it and press Control+S to save it., 5, 1
} else {
  Gui, Show, h377 w392, EasyAHK
  viewbutton = off
  return
}
return
;
ButtonTest:
Run, %name%.ahk
return
;
ButtonDelete:
msgbox, 4, Delete %name%.ahk?, Are you you want to completely delete %name%.ahk?
ifMsgBox Yes
{
FileDelete, %name%.ahk
TrayTip, %name%.ahk, %name%.ahk was successfully deleted!, 5, 1
Gui, Show, h377 w392, EasyAHK
viewbutton = off
GoTo ChooseName
} else {
return
}

return
;