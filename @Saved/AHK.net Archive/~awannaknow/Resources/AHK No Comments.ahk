/*
------------- AHK No Comments ---------------
			  By awannaknow
	http://www.autohotkey.net/~awannaknow/
AHK_L 32 UTF8
-is surely AHK Classic Compatible. Has to be tested Yet !
-----------------------------------------------------
*/
/*
------------- Friday 14th of October 2011 ----------

I Passed by and liked what Nazzal had done : AHKCaser
http://www.autohotkey.com/forum/topic72146.html&highlight=ahkcaser
I used his idea to make this one.
			That's my second Software !
-----------------------;-) ----------------------------
Just drop file/folders and all comments in .ahk files will be removed. Close with Escape Keyboard Key.
Destination files in the same folder as source files.
Source Files not modified.
New files named :
SourceFileName(NoComments).ahk

Back up your files just in case.
------------------------------------------------------
*/ 
/*
----------------------------- Credits -----------------------------
Special thanks to all knowledgeable Members which helped me, to say the least, or participated in any way or from which I borrowed code from their previous works, to get it done.
Truly, I only bring the idea and all the real work was done by  :
Frankie, [VxE], Morpheus
A special thanks to rbrtryn which did most of the work and even find this app name.
----- Feel free to contact me if I forgot to mention your name -----
*/
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
SendMode Input  
Gui, +AlwaysOnTop -Border  
Gui, Font, s13  
Gui, Color, Olive  
Gui, Add, Pic, x10 y15 icon2, %A_AhkPath%  
Gui, Add, Text, x+0 y-10 cwhite w295 h45 gGuiMove +Center, `nAHK No Comments 
Gui, Font, s10  
Gui, Add, Text, xp y+0 h30 Wp cWhite gGuiMove  vDrop +Center, Drop files and folders  
Gui, Show, y0 w355 h65 NoActivate, AHK No Comments  
Return  
GuiMove:  
   PostMessage, 0xA1, 2,,, A  
   Return  
GuiDropfiles:  
   Gui, Color, 88B000 
   Gui, -E0x10  
   GuiControl, ,Dropped, Please wait . . .  
   Loop, Parse, A_GuiEvent, `n, `r 
   {  
        If (! InStr(FileExist(A_Loopfield), "D")) { 
           If (! RegExMatch(A_LoopField, ".ahk$")) 
               Continue 
           AHKFileNoComments := RegExReplace(A_LoopField, "(\\.*)\.", "$1(NoComments).") 
           Strip(A_LoopField, AHKFileNoComments) 
        }  
        Else {  
            Loop % A_LoopField "\*.ahk",0,1  
            {  
               If (! RegExMatch(A_LoopFileFullPath, ".ahk$"))  
                  Continue  
               AHKFileNoComments := RegExReplace(A_LoopFileFullPath, "(\\.*)\.", "$1(NoComments).")  
               Strip(A_LoopFileFullPath, AHKFileNoComments)  
            }  
         }  
   }  
   Gui, Color, Olive  
   GuiControl, ,Drop, Drop files and folders  
   Gui, +E0x10  
Return  
     
     
GuiEscape:  
   ExitApp  
   
   
Strip( in, out )  
    {  
        Loop Read, %in%, %out%  
        {  
            TwoChars := SubStr(LTrim(A_LoopReadline), 1, 2)  
            If (TwoChars = "/*") { 
                BlockComment := True  
                Continue  
            }  
            If (TwoChars = "*/") { 
                BlockComment := False  
                ReadLine := RegExReplace(A_LoopReadLine, "\*/\s*")  
                If (Trim(ReadLine) <> "") { 
                    FileAppend %ReadLine% `n  
                }  
                Continue  
            }  
            If (BlockComment) { 
                Continue  
            }  
            If (InStr(A_LoopReadline, ";")) { 
                ReadLine := RegExReplace(A_LoopReadline, "^;.*$|\s+;.*$")  
                If (Trim(ReadLine) <> "") {  
                    FileAppend %ReadLine% `n  
                }  
                Continue  
            }  
            FileAppend %A_LoopReadLine% `n  
        }  
    } 
