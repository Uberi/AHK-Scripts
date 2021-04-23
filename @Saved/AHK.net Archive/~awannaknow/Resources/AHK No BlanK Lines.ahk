/*
------------- AHK No BlanK Lines ---------------
			  By awannaknow
	http://www.autohotkey.net/~awannaknow/
AHK_L 32 UTF8
-is surely AHK Classic Compatible. Has to be tested Yet !
-----------------------------------------------------
*/
/*
------------- Friday 23rd of September 2011 ----------
I Passed by and liked what Nazzal had done : AHKCaser
http://www.autohotkey.com/forum/topic72146.html&highlight=ahkcaser
I used his idea to make this one.
			That's my first Software !
-----------------------;-) ----------------------------
Just drop file/folders and all blank lines in .ahk files will be removed. Close with Escape Keyboard Key.
Destination files in the same folder as source files.
Source Files unchanged.
New files named :
SourceFileName(No Blank Lines).ahk

Back up your files just in case. 
------------------------------------------------------
*/
/*
------------------- Examples of use ------------------
It's quite useful for removing comments by decompilation since that leaves a lot of blank lines.
From jpjazzy : http://www.autohotkey.com/forum/viewtopic.php?p=482661#482661
*/
/*
----------------------------- Credits -----------------------------
Special thanks to all knowledgeable Members which helped me, to say the least, or participated in any way or from which I borrowed code from their previous works, to get it done.
Truly, I only bring the idea and all the real work was done by  :
Nazzal for his AHKCaser which gave me this idea, Tuncay, Morpheus, closed,  emmanuel d
----- Feel free to contact me if I forgot to mention your name -----
/*
----------------------------- AutoHotKey -----------------------------
Of course nothing of this would have been possible without AutoHotKey aka AHK :
						http://www.autohotkey.com
						Created by  : Chris Mallet
						And all new Versions/Branch
							created by Lexicos
*/
#NoEnv  
#Persistent  
#SingleInstance Force  
SetWorkingDir %A_ScriptDir%  
Gui, +AlwaysOnTop -Border  
Gui, Font, s13  
Gui, Color, Purple 
Gui, Add, Pic, x10 y15 icon2, %A_AhkPath%  
Gui, Add, Text, x+0 y-10 cwhite w295 h45 gGuiMove +Center, `nAHK No Blank Lines 
Gui, Font, s10  
Gui, Add, Text, xp y+0 h30 Wp cWhite gGuiMove  vDrop +Center, Drop files and folders  
Gui, Show, y0 w355 h65 NoActivate, AHK No Blank Lines  
Return  
GuiMove:  
   PostMessage, 0xA1, 2,,, A  
   Return  
GuiDropfiles:  
   Gui, Color, EE82EE 
   Gui, -E0x10  
   GuiControl, ,Dropped, Please wait . . . 
Loop, Parse, A_GuiEvent, `n, `r 
      Loop, % (D:=InStr(FileExist(A_Loopfield), "D")) ? A_LoopField "\*.ahk" : A_LoopField ,% D ? 1 : 0, % D ? 1 : 0  
         {  
         IfNotEqual, A_LoopFileExt,ahk, Continue  
         FileRead, Contents, %A_LoopFileFullPath% 
		 if not ErrorLevel 
		 Filepathname=%A_LoopFileFullPath% 
Loop,parse,Contents, `r, %A_Tab% 
{ 
StringLen, linenumber, A_LoopField 
If linenumber=0 
Continue 
If linenumber=1 
Continue 
stringreplace, Contents, A_LoopField, `r`n`r`n, `r`n, A 
StringReplace, BlFilepathname, Filepathname, .ahk, (No Blank Lines).ahk 
	  FileAppend, %Contents%, %BlFilepathname% 
	 }	  
	}   
   Gui, Color, Purple  
   GuiControl, ,Drop, Drop files and folders  
   Gui, +E0x10  
   Return  
   Gui, Color, Purple  
   GuiControl, ,Drop, Drop files and folders  
   Gui, +E0x10  
   Return  
GuiEscape:  
   ExitApp 
