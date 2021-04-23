;  TypingAid
;  http://www.autohotkey.com/forum/viewtopic.php?t=53630
;
;  Press 1 to 0 keys to autocomplete the word upon suggestion 
;  Or use the Up/Down keys to select an item
;  (0 will match suggestion 10) 
;                              Credits:
;                               -Jordi S
;                               -Maniac
;                               -hugov
;                               -kakarukeys
;                               -Asaptrad
;___________________________________________ 

; Press 1 to 0 keys to autocomplete the word upon suggestion 
;___________________________________________

;    CONFIGURATIONS 

;disable hotkeys until setup is complete
Suspend, On
#NoEnv
ListLines Off

OnExit, SaveScript

;Change the setup performance speed
SetBatchLines, 20ms
;read in the preferences file
ReadPreferences()

SetTitleMatchMode, 2

;setup code
clearword=1
MouseX = 0 
MouseY = 0 
Helper_id = 
CoordMode, Mouse, Relative
CoordMode, ToolTip, Relative 
AutoTrim, Off 

BlockInput, Send

IfEqual, A_IsUnicode, 1
{
   ; MaxLengthInLearnMode = (253 (max len of var name) - zcount)/ 4 rounded down
   MaxLengthInLearnMode = 61
   ; Need 4 characters in Unicode mode
   AsciiPrefix = 000
   AsciiTrimLength = -3
} else {
         ; MaxLengthInLearnMode = (253 (max len of var name) - zcount)/ 2 rounded down
         MaxLengthInLearnMode = 123
         ; Need 2 characters in Ascii mode
         AsciiPrefix = 0
         AsciiTrimLength = -1
      }

SetTimer, Winchanged, 100

;mark the wordlist as not done
WordListDone = 0

;reads list of words from file 
FileRead, ParseWords, %A_ScriptDir%\Wordlist.txt
Loop, Parse, ParseWords, `n, `r
{
   AddWordToList(A_LoopField,0)
}
ParseWords =

;reverse the numbers of the word counts in memory
GoSub, ReverseWordNums

;mark the wordlist as completed
WordlistDone = 1

;enable Hotkeys since setup is done
Suspend, Off

;Change the Running performance speed
SetBatchLines, -1
Process, Priority,,High

Loop 
{ 
   ;Editor window check 
    WinGetActiveTitle, ATitle 
    WinGet, A_id, ID, %ATitle% 
    IfNotInString, ATitle, %ETitle% 
    { 
      ToolTip 
      Word=
      WinWaitActive, %ETitle%
      ATitle =
      Continue 
   }    
   ATitle =
    
   ;Get one key at a time 
   Input, chr, L1 V, %TerminatingCharacters%
   IfEqual, IgnoreSend, 1
   {
      IgnoreSend = 
      Continue
   }
   EndKey = %errorlevel% 
   ; If active window has different window ID from before the input, blank word 
   ; (well, assign the number pressed to the word)    
   WinGet, A_id2, ID, A
   IfNotEqual, A_id, %A_id2% 
   { 
      Gosub,clearallvars 
      Word = %chr%
      Continue 
   } 
   
   ifequal, OldCaretY,
        OldCaretY := HCaretY()
   if ( OldCaretY != HCaretY() )
   {
      ; add the word if switching lines
      AddWordToList(Word,0)
      Gosub,clearallvars
      Word = %chr%
      Continue         
   } 

   OldCaretY := HCaretY()
   
      ;Backspace clears last letter 
   ifequal, EndKey, Endkey:BackSpace
   {
      StringLen, len, Word
      IfNotEqual, len, 0
      { 
         ifequal, len, 1   
         { 
            Gosub,clearallvars
         } else {
                  StringTrimRight, Word, Word, 1
                }     
      }
   } else ifequal, EndKey, Max
         {
            if chr in %ForceNewWordCharacters%
            {
               AddWordToList(Word,0)
               Gosub, clearallvars
               Word = %chr%
               Continue
            } else { 
                  Word .= chr
                  }
         } else {
                  AddWordToList(Word,0)
                  Gosub, clearallvars     
                }
    
   ;Wait till minimum letters 
   IF ( StrLen(Word) < wlen )
   {
      ToolTip,
      Continue
   } 

   IfNotEqual, MatchPos, 
   {
      IfEqual, ArrowKeyMethod, LastWord
      {
         OldMatch := singlematch%MatchPos%
      } else {
               IfEqual, ArrowKeyMethod, LastPosition
               {
                  OldMatch = %MatchPos%
               } else {
                        OldMatch =
                     }
            }
   
   } else {
            OldMatch =
         }

   ;Match part-word with command 
   Num = 
   number = 0 
   StringLeft, baseword, Word, %wlen%
   baseword := ConvertWordToAscii(baseword,1)
   Loop
   {
      IfEqual, zword%baseword%%a_index%,, Break
      IfEqual, number, %MaxMatches%
         Break
      if ( SubStr(zword%baseword%%a_index%, 1, StrLen(Word)) = Word )
      {
         number ++
         singlematch := zword%baseword%%a_index%
         singlematch%number% = %singlematch%
            
         Continue            
      }
   }
   
   ;If no match then clear Tip 
   IfEqual, number, 0
   {
      clearword=0 
      Gosub,clearallvars 
      Continue 
   } 

   IfEqual, OldMatch, 
   {
      IfEqual, ArrowKeyMethod, Off
      {
         MatchPos = 
      } else {
               MatchPos = 1
            }
   } Else {
            IfEqual, ArrowKeyMethod, Off
            {
               MatchPos = 
            } else {
                     IfEqual, ArrowKeyMethod, LastPosition
                     {
                        IfGreater, OldMatch, %Number%
                        {
                           MatchPos = %Number%
                        } else {
                                 MatchPos = %OldMatch%
                              }
                     
                     } else {
                              IfEqual, ArrowKeyMethod, LastWord
                              {
                                 Pos =
                                 Loop, %Number%
                                 {
                                    if ( OldMatch == singlematch%A_Index% )
                                    {
                                    Pos = %A_Index%
                                    Break
                                    }
                                 }
                                 IfEqual, pos, 
                                 {
                                    MatchPos = 1
                                 } Else {
                                          MatchPos = %Pos%
                                       }
                              } else {
                                       MatchPos = 1
                                    }
                                 
                           }
                  }
         }    
   OldMatch = 
   RebuildMatchList()
   ShowToolTip()
}    

RebuildMatchList()
{
   global
   match = 
   Loop, %Number%
   {
      AddToMatchList(A_Index,singlematch%A_Index%)
   }
   StringTrimRight, match, match, 1        ; Get rid of the last linefeed 
   Return
}

AddToMatchList(position,value)
{
   global
   
   Local prefix
   IfGreater, position, 10
   {
      prefix =
   } else {   
            prefix := Mod(position,10) . ". "
         }

   IfEqual, ArrowKeyMethod, Off
   {
      match .= prefix . value . "`n"
   } else {
            IfEqual, MatchPos, %Position%
            {
               match .= ">" . prefix . value . "`n"
            } Else {
                     match .= "   " . prefix . value . "`n"
                  }
         }
}

;Show matched values
ShowToolTip()
{
   global ToolTipOffset
   global Word
   global Match
   global number
   global ToolTipLineHeight
   WinGetPos,,,, SizeY, A
   ; remove window border from size
   SizeY -= 8
   ToolTipSizeY := (number * ToolTipLineHeight) + 7
   ToolTipPosY := HCaretY()+ToolTipOffset
   ; + ToolTipOffset Move tooltip down a little so as not to hide the caret. 
   if ((ToolTipSizeY + ToolTipPosY) > SizeY)
       ToolTipPosY := (HCaretY() - (ToolTipOffset - ToolTipLineHeight) - ToolTipSizeY)
   IfNotEqual, Word,
      ToolTip, %match%, HCaretX(), %ToolTipPosY%
}
   

; Timed function to detect change of focus (and remove tooltip when changing active window) 
Winchanged: 
   ;make sure we are in decimal format in case ConvertWordToAscii was interrupted
   IfEqual, A_FormatInteger, H
   SetFormat,Integer,D
   WinGetActiveTitle, ATitle 
   WinGet, A_id3, ID, %ATitle% 
   IfNotEqual, A_id, %A_id3% 
   { 
      ToolTip ,
   } else {
            ; If we are in the correct window, and OldCaretY is set, clear the tooltip if not in the same line
            IfInString, ATitle, %ETitle%
            {
               IfNotEqual, OldCaretY,
               {
                  if ( OldCaretY != HCaretY() )
                  {
                     ToolTip,
                  }
               }
            }
         }
   ATitle = 
   A_Id3 = 
   Return


; Update last click position in case Caret is not detectable
~LButton:: 
;make sure we are in decimal format in case ConvertWordToAscii was interrupted
IfEqual, A_FormatInteger, H
   SetFormat,Integer,D
MouseGetPos, MouseX, MouseY 
Return 
    
; Key definitions for autocomplete (0 to 9) 
#MaxThreadsPerHotkey 1 
$1:: 
$2:: 
$3:: 
$4:: 
$5:: 
$6:: 
$7:: 
$8:: 
$9:: 
$0:: 
CheckWord(A_ThisHotkey)
Return

$^Enter::
$^Space::
$Tab::
$Up::
$Down::
$PgUp::
$PgDn::
$Right::
EvaluateUpDown(A_ThisHotKey)
Return

^+h:: 
CreateHelperWindow()
Return

^+c:: 
AddSelectedWordToList()
Return

; If hotkey was pressed, check wether there's a match going on and send it, otherwise send the number(s) typed 
CheckWord(Key)
{
   global
   ;make sure we are in decimal format in case ConvertWordToAscii was interrupted
   IfEqual, A_FormatInteger, H
      SetFormat,Integer,D
   Local ATitle
   Local A_id2
   Local WordIndex
   Local KeyAgain
   
   StringRight, Key, Key, 1 ;Grab just the number pushed, trim off the "$"
   
   IfEqual, Key, 0
   {
      WordIndex = 10
   } else {
            WordIndex = %Key%
         }  
   
   clearword=1 
   IfEqual, NumPresses, 2
      Suspend, On

   ; If active window has different window ID from before the input, blank word 
   ; (well, assign the number pressed to the word) 
   if ( ReturnWinActive() = )
   { 
      SendCompatible(Key,0)
      Gosub,clearallvars 
      IfEqual, NumPresses, 2
         Suspend, Off
      Return 
   } 
   
   if ReturnLineWrong() ;Make sure we are still on the same line
   { 
      SendCompatible(Key,0)
      Gosub,clearallvars 
      IfEqual, NumPresses, 2
      Suspend, Off
      Return 
   } 

   ifequal, Word,        ; only continue if word is not empty 
   { 
      SendCompatible(Key,0)
      Word = %key%
      clearword=0 
      Gosub,clearallvars 
      IfEqual, NumPresses, 2
         Suspend, Off
      Return 
   } 
         
   ifequal, singlematch%WordIndex%,   ; only continue singlematch is not empty 
   { 
      SendCompatible(Key,0)
      Word .= key
      clearword=0 
      Gosub,clearallvars 
      IfEqual, NumPresses, 2
         Suspend, Off
      Return 
   } 

   IfEqual, NumPresses, 2
   {
      Input, keyagain, L1 I T0.5, 1234567890
      
      ; If there is a timeout, abort replacement, send key and return
      IfEqual, ErrorLevel, Timeout
      {
         SendCompatible(Key,0)
         Word .= key
         clearword=0
         Gosub,clearallvars
         Suspend, off
         Return
      }

      ; Make sure it's an EndKey, otherwise abort replacement, send key and return
      IfNotInString, ErrorLevel, EndKey:
      {
         SendCompatible(Key . KeyAgain,0)
         Word .= key . keyagain
         clearword=0
         Gosub, clearallvars
         Suspend, off
         Return
      }
   
      ; If the 2nd key is NOT the same 1st trigger key, abort replacement and send keys   
      IfNotInString, ErrorLevel, %key%
      {
         StringTrimLeft, keyagain, ErrorLevel, 7
         SendCompatible(Key . KeyAgain,0)
         Word .= key . keyagain
         clearword=0
         Gosub, clearallvars
         Suspend, Off
         Return
      }
   }

   SendWord(WordIndex)
   IfEqual, NumPresses, 2
      Suspend, Off
   Return 
}

SendWord(WordIndex)
{
   global
   Local sending
   ;Local ClipboardSave
   ;Send the word
   sending := singlematch%WordIndex%
   ; Update Typed Count
   UpdateWordCount(sending,0)
   SendFull(sending, StrLen(Word))
   Gosub clearallvars
   Return
}  

;If a hotkey related to the up/down arrows was pressed
EvaluateUpDown(Key)
{
   global 
   
   ;make sure we are in decimal format in case ConvertWordToAscii was interrupted
   IfEqual, A_FormatInteger, H
      SetFormat,Integer,D
   IfEqual, ArrowKeyMethod, Off
   {
      SendKey(Key)
      Return
   }
   
   IfEqual, Match,
   {
      SendKey(Key)
      Return
   }

   if ( ReturnWinActive() = )
   {
      SendKey(Key)
      Gosub, ClearAllVars
      Return
   }

   if ReturnLineWrong()
   {
      SendKey(Key)
      GoSub, ClearAllVars
      Return
   }   
   
   IfEqual, Word, ; only continue if word is not empty
   {
      SendKey(Key)
      ClearWord = 0
      GoSub, ClearAllVars
      Return
   }
   
   if ( ( Key = "$^Enter" ) || ( Key = "$Tab" ) || ( Key = "$^Space" ) || ( Key = "$Right") )
   {
      Local KeyTest
      IfEqual, Key, $^Enter
      {
         KeyTest = E
      } else {
               IfEqual, Key, $Tab
               {
                  KeyTest = T
               } else {
                        IfEqual, Key, $^Space
                        {   
                           KeyTest = S 
                        } else {
                                 IfEqual, Key, $Right
                                    KeyTest = R
                              }
                           
                     }
            }
      
      if DisabledAutoCompleteKeys contains %KeyTest%
      {
         SendKey(Key)
         Return     
      }
      
      IfEqual, singlematch%MatchPos%, ;only continue if singlematch is not empty
      {
         SendKey(Key)
         MatchPos = %Number%
         RebuildMatchList()
         ShowToolTip()
         Return
      }
      
      SendWord(MatchPos)
      Return
      
   }
   IfEqual, Key, $Up
   {   
      MatchPos--
   } else {
            IfEqual, Key, $Down
            {
               MatchPos++
            } else {
                     IfEqual, Key, $PgUp
                     {
                        MatchPos-=10
                        IfLess, MatchPos, 1
                           MatchPos = 1
                     } else {
                              IfEqual, Key, $PgDn
                              {
                                 MatchPos+=10
                                 IfGreater, MatchPos, %Number%
                                    MatchPos = %Number%
                              }
                           }
                  }
         }
   IfLess, MatchPos, 1
   {
      MatchPos = %Number%
   } else {
            IfGreater, MatchPos, %Number%
            {
               MatchPos = 1
            }
         }
   RebuildMatchList()
   ShowToolTip()
   Return
}
            
SendKey(Key)
{
   IfEqual, Key, $^Enter
   {
      Key = ^{Enter}
   } else {
            IfEqual, Key, $^Space
            { 
               Key = ^{Space}
            } else {
                     Key := "{" . SubStr(Key, 2) . "}"
                  }
         }
   SendCompatible(Key,1)
   Return
}
   
SendFull(SendValue,BackSpaceLen)
{
   global SendMethod
   global A_id
   IfEqual, SendMethod, 1
   {
      ; Shift key hits are here to account for an occassional bug which misses the first keys in SendPlay
      sending = {Shift Up}{Shift Down}{Shift Up}{BS %BackSpaceLen%}{Raw}%SendValue%
      SendPlay, %sending% ; First do the backspaces, Then send word (Raw because we want the string exactly as in wordlist.txt) 
      Return
   }
   sending = {BS %BackSpaceLen%}{Raw}%SendValue%
   
   IfEqual, SendMethod, 2
   {
      SendInput, %sending% ; First do the backspaces, Then send word (Raw because we want the string exactly as in wordlist.txt)      
      Return
   }

   IfEqual, SendMethod, 3
   {
      SendEvent, %sending% ; First do the backspaces, Then send word (Raw because we want the string exactly as in wordlist.txt) 
      Return
   }
   
   ClipboardSave := ClipboardAll
   Clipboard = 
   Clipboard := SendValue
   ClipWait, 0
   
   sending = {BS %BackSpaceLen%}^v
   
   IfEqual, SendMethod, 1C
   {
      sending := "{Shift Up}{Shift Down}{Shift Up}" . sending
      SendPlay, %sending% ; First do the backspaces, Then send word via clipboard
   } else {
            IfEqual, SendMethod, 2C
            {
               SendInput, %sending% ; First do the backspaces, Then send word via clipboard
            } else {
                     IfEqual, SendMethod, 3C
                     {
                        SendEvent, %sending% ; First do the backspaces, Then send word via clipboard
                     } Else {                      
                              sending = {BS %BackSpaceLen%}{Ctrl Down}v{Ctrl Up}
                              ControlGetFocus, ActiveControl, ahk_id %A_id%
                              ControlSend, %ActiveControl%, %sending%, ahk_id %A_id%
                           }
                  }
         }
         
   Clipboard := ClipboardSave
   Return
}

SendCompatible(SendValue,ForceSendForInput)
{
   global SendMethod
   global IgnoreSend
   IfEqual, ForceSendForInput, 1
   {
      IgnoreSend = 
      SendEvent, %SendValue%
      Return
   }
   
   SendMethodLocal := SubStr(SendMethod, 1, 1)
   IF ( ( SendMethodLocal = 1 ) || ( SendMethodLocal = 2 ) )
   {
      SendInput, %SendValue%
      Return
   }

   IF ( ( SendMethodLocal = 3 ) || ( SendMethodLocal = 4 ) )
   {
      IgnoreSend = 1
      SendEvent, %SendValue%
      Return
   }
   
   SendInput, %SendValue%   
   Return
}
      
ReturnWinActive()
{
   global A_id
   WinGet, A_id2, ID, A
   Return, ( A_id = A_id2 )
}

ReturnLineWrong()
{
   global OldCaretY
   Return, ( OldCaretY != HCaretY() )
}

;Create helper window for showing tooltip
CreateHelperWindow()
{
   ;make sure we are in decimal format in case ConvertWordToAscii was interrupted
   IfEqual, A_FormatInteger, H
      SetFormat,Integer,D
   Global Helper_id
   Global XY
   Gui, +Toolwindow
   Gui, Add, Text,,Tooltip appears here 
   IfNotEqual, XY, 
   {
      StringSplit, Pos, XY, `, 
      Gui, Show, X%Pos1% Y%Pos2%
   } else {
            Gui, Show
         }
   WinGet, Helper_id, ID,,Tooltip appears here 
   WinSet, AlwaysOnTop, On, ahk_id %Helper_id% 
   return 
}

GuiClose:
IfNotEqual, Helper_id, 
   SaveHelperWindowPos()
Return

SaveHelperWindowPos()
{
   global XY
   global XYSaved
   global Helper_id
   WinGetPos, hX, hY, , , ahk_id %Helper_id%
   XY = %hX%`,%hY%
   XYSaved = 1
   Helper_id = 
   Gui, Hide
}

; function to grab the X position of the caret for the tooltip
HCaretX() 
{ 
    global MouseX
    global Helper_id
    
    WinGetPos, HelperX,,,, ahk_id %Helper_id% 
    WinGetPos, X,,,, A
    
    if HelperX !=
    { 
        if X != 
        { 
            return HelperX - X 
        } 
    } 
    if A_CaretX < 14
    { 
        if MouseX != 0 
        { 
            return MouseX 
        } 
    } 
    return A_CaretX 
} 

; function to grab the Y position of the caret for the tooltip
HCaretY() 
{ 
    global MouseY
    global Helper_id
    
    WinGetPos,,HelperY,,, ahk_id %Helper_id% 
    WinGetPos,, Y,,, A
    if HelperY != 
    { 
        if Y != 
        { 
            return HelperY - Y 
        } 
    } 
    if A_CaretX < 14 
    { 
        if MouseY != 0 
        { 
            return MouseY + 20 
        } 
    } 
    return A_CaretY 
}

AddSelectedWordToList()
{
   ;make sure we are in decimal format in case ConvertWordToAscii was interrupted
   IfEqual, A_FormatInteger, H
      SetFormat,Integer,D
      
   ClipboardSave := ClipboardAll
   Clipboard =
   Sleep, 100
   SendCompatible("^c",0)
   ClipWait, 0
   IfNotEqual, Clipboard, 
   {
      AddWordToList(Clipboard,1)
   }
   Clipboard = %ClipboardSave%
}

AddWordToList(AddWord,ForceCountNewOnly)
{
   ;AddWord = Word to add to the list
   ;ForceCountNewOnly = force this word to be permanently learned even if learnmode is off
   global
   Local CharTerminateList
   Local Base
   Local AddWordInList
   Local CountWord
   Local pos
   Local LearnModeTemp
   
   IfEqual, LearnMode, On
   {
      LearnModeTemp = 1
      ;force words to max of MaxLengthInLearnMode characters
      StringLeft, AddWord, AddWord, %MaxLengthInLearnMode%
   } else {
            IfEqual, ForceCountNewOnly, 1
               LearnModeTemp = 1
         }

   Ifequal, Addword,  ;If we have no word to add, skip out.
      Return
   if ( Substr(addword,1,1) = ";" ) ;If first char is ";", clear word and skip out.
   {
      IfEqual, LearnMode, On ;Check LearnMode here as we only do this if the wordlist is not done
      {
         IfEqual, wordlistdone, 0 ;If we are still reading the wordlist file and we come across ;LEARNEDWORDS; set the LearnedWordsCount flag
         {
            IfEqual, AddWord, `;LEARNEDWORDS`;
               LearnedWordsCount=0
         }
      }
      Return
   }
   
   IF ( StrLen(addword) <= wlen ) ; don't add the word if it's not longer than the minimum length
   {
      Return
   }
   
   ifequal, wordlistdone, 1
   {
      IfNotEqual, LearnModeTemp, 1
      {
         Return    
      } else {
               IfNotEqual, ForceCountNewOnly, 1
               {
                  if addword contains 1,2,3,4,5,6,7,8,9,0,%ForceNewWordCharacters%
                     Return
               }
            }
   }

   Base := ConvertWordToAscii(SubStr(addword,1,wlen),1)
   IfEqual, WordListDone, 0 ;if this is read from the wordlist
   {
      IfNotEqual,LearnedWordsCount,  ;if this is a stored learned word, this will only have a value when LearnedWords are read in from the wordlist
      {
         CountWord := ConvertWordToAscii(addword,0)
         IfEqual, LearnedWords,     ;if we haven't learned any words yet, set the LearnedWords list to the new word
         {
            LearnedWords = %addword%  
         } else {   ;otherwise append the learned word to the list
                  LearnedWords .= " " . addword
               }
         zCount%CountWord% := LearnedWordsCount++    ;increment the count and store the Weight of the LearnedWord in reverse order (will be inverted later)
      }
      IncrementCounterAndAddWord(Base,AddWord)
      
   } else { ; If this is an on-the-fly learned word
            AddWordInList =
            Loop ;Check to see if the word is already in the list, case sensitive
            {
               IfEqual, zword%base%%a_index%,, Break
               if ( zword%base%%a_index% == AddWord )
               {
                  AddWordInList = 1
                  Break
               }            
               Continue            
            }
            
            IfEqual, AddWordInList, ; if the word is not in the list
            {
               IfNotEqual, ForceCountNewOnly, 1
               {
                  IF ( StrLen(addword) < LearnLength ) ; don't add the word if it's not longer than the minimum length for learning if we aren't force learning it
                     Return
               }
            
               IfEqual, LearnMode, On
               {
                  CountWord := ConvertWordToAscii(addWord,0)
                  IfEqual, ForceCountNewOnly, 1
                  {
                     zCount%CountWord% = %LearnCount% ;set the count to LearnCount so it gets written to the file
                  } else {
                           zCount%CountWord% = 1   ;set the count to one as it's the first time we typed it
                        }
               }
               IfEqual, LearnedWords,    ;if we haven't learned any words yet, set the LearnedWords list to the new word
               {
                  LearnedWords = %addword%  
               } else {   ;otherwise append the learned word to the list
                        LearnedWords .= " " . addword
                     }
               IncrementCounterAndAddWord(Base,AddWord)
               
               IfEqual, LearnMode, On
               {
                  IfEqual, ForceCountNewOnly, 1
                     UpdateWordCount(addword,1) ;resort the necessary words if it's a forced added word
               }
            } else {
                     IfEqual, LearnMode, On
                     {                  
                        IfEqual, ForceCountNewOnly, 1                     
                        {
                           CountWord := ConvertWordToAscii(addWord,0)
                           IF ( zCount%CountWord% < LearnCount )
                              zCount%CountWord% = %LearnCount%
                           UpdateWordCount(addWord,1)
                        } else {
                                 UpdateWordCount(addword,0) ;Increment the word count if it's already in the list and we aren't forcing it on
                              }
                     }
                  }
         }
   
   Return
}

IncrementCounterAndAddWord(Base,AddWord)
{
   global
   local pos
   ; Increment the counter for each hash
   zbasenum%Base%++        
   pos := zbasenum%Base%
   ; Set the hashed value to the word
   zword%Base%%pos% = %addword%
}
   
; This sub will reverse the read numbers since now we know the total number of words
ReverseWordNums:

;We don't need to deal with any counters if LearnMode is off
IfEqual, LearnMode, Off,
   Return
   
LearnedWordsCount+=4
Loop,parse,LearnedWords,  
{
   AsciiWord := ConvertWordToAscii(A_LoopField,0)
   zCount%AsciiWord% := LearnedWordsCount - zCount%AsciiWord%
}

AsciiWord = 
LearnedWordsCount = 

Return

UpdateWordCount(word,SortOnly)
{
   global
   ;Word = Word to increment count for
   ;SortOnly = Only sort the words, don't increment the count
   
   ;Should only be called when LearnMode is on  
   IfEqual, LearnMode, Off
      Return
   
   ;force words to max of MaxLengthInLearnMode characters
   StringLeft, Word, Word, %MaxLengthInLearnMode%
   
   ; If the Count for the word already exists - ie if it's a learned word, increment it, else don't.
   local CountWord := ConvertWordToAscii(word,0)
   IfNotEqual, zCount%CountWord%,
   {
      IfNotEqual, SortOnly, 1 ;don't increment the count if we only want to sort the words
         zCount%CountWord%++  
      local WordBase
      StringLeft, WordBase, word, %wlen% ;find the pseudohash for the word
      WordBase := ConvertWordToAscii(WordBase,1)
      Local ConvertWord = 
      Local LowIndex = 
      Local WordList = 
      Loop
      {
         ifequal, zword%WordBase%%A_Index%, ;Break the loop if no more words to read for the hash
            Break
         CountWord := zword%WordBase%%A_Index% ;Set CountWord to the current Word position
         ConvertWord := ConvertWordToAscii(CountWord,0) ; Find the Ascii equivalent of the word
         IfNotEqual, zCount%ConvertWord%,  ;If there's no count for this word do nothing
         {
            IfEqual, LowIndex,
               LowIndex = %A_Index% ;If this is the first word we've found with a count set this as our starting position
               
            WordList .= " " . zCount%ConvertWord% . "z" . CountWord ;prefix all words with (zCount"z")
         }
      }
      
      ifnotequal, Wordlist, ;If we have no words to process, don't
      {
         StringTrimLeft, WordList, WordList, 1
         Sort, WordList, N R D, ;Sort the wordlist by order of 
         
         LowIndex-- ;A_Index starts at 1 so this value needs to be decremented
         Local IndexPos = 
         Loop, Parse, WordList,  
         {
            IndexPos := LowIndex + A_Index ;Set the current word we are processing to the starting pos plus word position
            StringTrimLeft, CountWord, A_LoopField, InStr(A_LoopField,"z") ;Strip (Number,"z") from beginning
            zword%WordBase%%IndexPos% = %CountWord% ; update the word in the list
            
         }
      }
   }
   Return
}
      
ConvertWordToAscii(Base,Caps)
{
; Return the word in Hex Ascii or Unicode numbers padded to length 2 (ascii mode) or 4 (unicode mode) per character
; Capitalize the string if NoCaps is not set
   global AsciiPrefix
   global AsciiTrimLength
   IfEqual, Caps, 1
      StringUpper, Base, Base
   Critical, On
   SetFormat,Integer, H
   Loop, Parse, Base
   {
      IfEqual, A_FormatInteger, D
         SetFormat, Integer, H
      New .= SubStr( AsciiPrefix . SubStr(Asc(A_LoopField),3), AsciiTrimLength)
   }
   SetFormat,Integer,D
   Critical, Off
Return New
}

; This is to blank all vars related to matches, tooltip and (optionally) word 
clearallvars: 
      Ifequal,clearword,1
      {
         word =
         OldCaretY=
      }
      ToolTip 
      ; Clear all singlematches 
      Loop, 10 
      { 
         singlematch%a_index% = 
      } 
      sending = 
      key= 
      match= 
      MatchPos=
      clearword=1 
      Return

ReadPreferences()
{
   global
   Local Prefs
   Local INI
   
   Prefs = %A_ScriptDir%\Preferences.ini
   DftTerminatingCharacters = {enter}{space}{bs}{esc}{tab}{Home}{End}{PgUp}{PgDn}{Up}{Down}{Left}{Right}.;`,z?A!'"()[]{}{}}{{}``~`%$&*-+=\/><^|@#:
   If FileExist(Prefs)
   {
      ;Settings
      IniRead, ETitle, %Prefs%, Settings, Title, %A_Space%
      IniRead, Wlen, %Prefs%, Settings, Length, 3
      IniRead, NumPresses, %Prefs%, Settings, NumPresses, 1
      IniRead, ToolTipOffset, %Prefs%, Settings, ToolTipOffset, 14
      IniRead, ToolTipLineHeight, %Prefs%, Settings, ToolTipLineHeight, 13
      IniRead, LearnMode, %Prefs%, Settings, LearnMode, On
      IniRead, LearnCount, %Prefs%, Settings, LearnCount, 5
      LearnLength := Wlen + 2
      IniRead, LearnLength, %Prefs%, Settings, LearnLength, %LearnLength%
      IniRead, ArrowKeyMethod, %Prefs%, Settings, ArrowKeyMethod, First
      IniRead, DisabledAutoCompleteKeys, %Prefs%, Settings, DisabledAutoCompleteKeys, %A_Space%
      IniRead, SendMethod, %Prefs%, Settings, SendMethod, 1
      IniRead, MaxMatches, %Prefs%, Settings, MaxMatches, 10
      IniRead, TerminatingCharacters, %Prefs%, Settings, TerminatingCharacters, %DftTerminatingCharacters%
      IniRead, ForceNewWordCharacters, %Prefs%, Settings, ForceNewWordCharacters, %A_Space%
      ;HelperWindow
      IniRead, XY, %Prefs%, HelperWindow, XY, %A_Space%
   } else {
            INI= 
               ( 
[Settings]
;
;Title is a string of text to find in the title of the window you want TypingAid enabled for. If you leave it blank it will
;work in all windows.
Title=
;
;Length is the minimum number of characters required to show the list of words. The higher this number the better performance will be.
Length=3
;
;NumPresses is the number of times the hotkey must be pushed for the word to be selected, either 1 or 2.
NumPresses=1
;
;ToolTipOffset is the number of pixels below the top of the Caret (Cursor) to display the tooltip.
ToolTipOffset=14
;
;ToolTipLineHeight is the number of pixels for the height of each line in the tooltip (used to display the tooltip above the cursor
;when at the bottom of the screen). This number should only need to be changed if you have changed the tooltip size or font DPI in windows.
ToolTipLineHeight=13
;
;LearnMode defines whether or not the script should learn new words as you type them, either On or Off.
;Entries in the wordlist are limited to a length of 123 characters in Ascii Mode or 61 characters in Unicode Mode
;(determined based on if you are running unicode executable or not) if LearnMode is On.
LearnMode=On
;
;LearnCount defines the number of times you have to type a word within a single session for it to be learned permanently.
LearnCount=5
;
;LearnLength is the minimum number of characters needed to be typed to learn a word. This must be at least Length+1.
LearnLength=5
;
;ArrowKeyMethod is the way the arrow keys are handled in the drop down.
;Options are:
;  Off - you can only use the number keys
;  First - resets the selected word to the beginning whenever you type a new character
;  LastWord - keeps the last word selected if still in the last, else resets to the beginning
;  LastPosition - keeps the last cursor position
ArrowKeyMethod=First
;
;DisabledAutoCompleteKeys is used to disable certain keys from autocompleting the selected item in the dropdown.
;Place the character listed for each key you want to disable in the list. IE
;DisabledAutoCompleteKeys=ST
;would disable Ctrl+Space and Tab.
;  E = Ctrl + Enter
;  S = Ctrl + Space
;  T = Tab
;  R = Right Arrow
DisabledAutoCompleteKeys=
;
;SendMethod is used to change the way the script sends the keys to the screen, this is included for compatibility reasons.
;  1 = Fast method that reliably buffers key hits while sending (default). Has been known to not function on some machines.
;      Only works with characters in the current keyboard layout.
;  2 = Fastest method with unreliable keyboard buffering while sending. Has been known to not function on some machines.
;  3 = Slowest method, will not buffer or accept keyboard input while sending. Most compatible method.
; The options below use the clipboard to copy and paste the data to improve speed, but will make an entry in any clipboard history
; routines you may be running. Data on the clipboard *will* be preserved.
;  1C = Same as 1 above.
;  2C = Same as 2 above, doesn't work on some machines.
;  3C = Same as 3 above.
;  4C = Alternate method.
SendMethod=1
;
;MaxMatches is the number of words to show in the dropdown. Valid range is from 10 to 20.
;If ArrowKeyMethod=Off this will be forced to 10
MaxMatches=10
;
;TerminatingCharacters is a list of EndKey characters which will signal the script that you are done typing a word. 
;A list of keys may be found here: 
; http://www.autohotkey.com/docs/KeyList.htm 
;For more detail on how to format the list of characters please see the EndKeys section (paragraphs 2,3,4) of: 
; http://www.autohotkey.com/docs/commands/Input.htm 
TerminatingCharacters=%DftTerminatingCharacters%
;
;ForceNewWordCharacters is a comma separated list of characters which force the script to start a new word whenever
;one of those characters is typed. Any words which begin with one of these characters will never be learned (even
;if learning is enabled). If you were typing a word when you hit one of these characters that word will be learned
;if learning is enabled.
ForceNewWordCharacters=
;
[HelperWindow]
; XY specifies the position the HelperWindow opens at. This will be updated automatically when the HelperWindow is
; next opened and closed
XY=200,277
               )
               FileAppendDispatch(INI, Prefs)
         }
   
   if Wlen is not integer
   {
      Wlen = 3
   }
   
   if NumPresses not in 1,2
      NumPresses = 1
   
   if ToolTipOffset is not Integer
      ToolTipOffset = 14
   
   if ToolTipLineHeight is not Integer
      ToolTipLineHeight = 13
   
   If LearnMode not in On,Off
      LearnMode = On
   
   If LearnCount is not Integer
      LearnCount = 5
      
   If LearnLength is not Integer
   {
      LearnLength := Wlen + 2
   } else {
            If ( LearnLength < ( Wlen + 1 ) )
               LearnLength := Wlen + 1
         }
   
   If ArrowKeyMethod not in First,Off,LastWord,LastPosition
   {
      ArrowKeyMethod = First       
   } else {
            IfEqual, ArrowKeyMethod, Off ;force MaxMatches to 10 if we aren't using arrow keys
               MaxMatches=10
         }
   
   if SendMethod not in 1,2,3,1C,2C,3C,4C
      SendMethod = 1
   
   If MaxMatches is not Integer
   {
      MaxMatches = 10
   } else { 
            IfLess, MaxMatches, 10
            {
               MaxMatches = 10
            } else {
                     IfGreater, MaxMatches, 20
                        MaxMatches = 20
                  }
         }
      
   IfEqual, TerminatingCharacters,
      TerminatingCharacters = %DftTerminatingCharacters%
      
   Return
}

FileAppendDispatch(Text,FileName)
{
   IfEqual, A_IsUnicode, 1
   {
      FileAppend, %Text%, %FileName%, UTF-8
   } else {
            FileAppend, %Text%, %FileName%
         }
   Return
}
   
SaveScript:
;make sure we are in decimal format in case ConvertWordToAscii was interrupted
IfEqual, A_FormatInteger, H
   SetFormat,Integer,D

; Close the tooltip if it's open
ToolTip,

Suspend, On

;Change the cleanup performance speed
SetBatchLines, 20ms
Process, Priority,,Normal

IfNotEqual, Helper_id,
   SaveHelperWindowPos()

;Update the Helper Window Position
IfEqual, XYSaved, 1
{
   IfNotEqual, XY, 
      IniWrite, %XY%, %A_ScriptDir%\Preferences.ini, HelperWindow, XY
}

; Update the Learned Words
IfNotEqual, LearnedWords, 
{
   IfEqual, WordlistDone, 1
   {
      ; Add all the standard words to the tempwordlist
      FileRead, ParseWords, %A_ScriptDir%\Wordlist.txt
      IfEqual, LearnMode, On
      {
         LearnedwordsPos := InStr(ParseWords, "`;LEARNEDWORDS`;",true,1) ;Check for Learned Words
      } else {
               LearnedwordsPos = 0 ;force all words to be re-written if we aren't learning
            }
      IfNotEqual, LearnedwordsPos, 0
      {
         TempWordList := SubStr(ParseWords, 1, LearnedwordsPos - 1) ;Grab all non-learned words out of list
      } else {
               TempWordList := ParseWords
            }
      ParseWords = 
      ; Parse the learned words and store them in a new list by count if their total count is greater than LearnCount.
      ; Prefix the word with the count and "z" for sorting
      
      IfEqual, LearnMode, Off
      {
         SortWordList := LearnedWords
      } else {
   
               Loop, Parse, LearnedWords,  
               { 
                  SortWord := ConvertWordToAscii(A_LoopField,0)
         
                  IfGreaterOrEqual, zCount%SortWord%, %LearnCount%
                  {
                     SortWordList .= " " . zCount%SortWord% . "z" . A_LoopField
                  }
               }
      
               StringTrimLeft, SortWordList, SortWordList, 1 ;remove extra starting ASCII 2
   
               Sort, SortWordList, N R D, ; Sort numerically, comma delimiter
            }
   
      IfNotEqual, SortWordList, ; If SortWordList exists write to the file, otherwise don't.
      {
         Loop
         {
            StringRight, LastChar, TempWordList, 1
            IF ( ( LastChar = "`r") || ( LastChar = "`n" ) )
            {
               StringTrimRight, TempWordList, TempWordList, 1
            } else {
                     Break
                  }
         }
         
         IfEqual, LearnMode, On
            TempWordList .= "`r`n`;LEARNEDWORDS`;" ;only append ;LEARNEDWORDS; if we are in learning mode
         Loop, Parse, SortWordList,  
         {
            IfEqual, LearnMode, On
            {
               StringTrimLeft, AppendWord, A_LoopField, InStr(A_LoopField,"z") ;Strip (Number,"z") from beginning
            } else {
                     AppendWord := A_LoopField
                  }
               
            TempWordList .= "`r`n" . AppendWord
         }
   
         FileDelete, %A_ScriptDir%\Temp_Wordlist.txt
         FileAppendDispatch(TempWordList, A_ScriptDir . "\Temp_Wordlist.txt")
         FileCopy, %A_ScriptDir%\Temp_Wordlist.txt, %A_ScriptDir%\Wordlist.txt, 1
         FileDelete, %A_ScriptDir%\Temp_Wordlist.txt
      }
   }
}

ExitApp