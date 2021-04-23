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
HelperManual = 
CoordMode, Caret, Screen
CoordMode, Mouse, Screen
;CoordMode, Mouse, Relative
;CoordMode, ToolTip, Relative 
AutoTrim, Off 

;Gui Init Code
DropDownGui=1
HelperGui=2
MenuGui=3

;Gui, %DropDownGui%: -Caption -Resize +AlwaysOnTop +ToolWindow
Gui, %DropDownGui%: -Caption +AlwaysOnTop +ToolWindow
Gui %DropDownGui%:Font, s8, Courier

Loop, 10
{
   Gui, %DropDownGui%: Add, ListBox, vToolTip%A_Index% R%A_Index% X0 Y0
}

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

;Setup toggle-able hotkeys
IfNotEqual, DetectMouseClickMove, On
{
   HotKey, ~RButton, Off
}

IfEqual, NumKeyMethod, Off
{
   HotKey, $1, Off
   HotKey, $2, Off
   HotKey, $3, Off
   HotKey, $4, Off
   HotKey, $5, Off
   HotKey, $6, Off
   HotKey, $7, Off
   HotKey, $8, Off
   HotKey, $9, Off
   HotKey, $0, Off
}

IfEqual, ArrowKeyMethod, Off
{
   Hotkey, $^Enter, Off
   Hotkey, $^Space, Off
   Hotkey, $Tab, Off
   Hotkey, $Right, Off
   Hotkey, $Up, Off
   Hotkey, $Down, Off
   Hotkey, $PgUp, Off
   Hotkey, $PgDn, Off
} else {
         If DisabledAutoCompleteKeys contains E
            Hotkey, $^Enter, Off
         If DisabledAutoCompleteKeys contains S
            HotKey, $^Space, Off
         If DisabledAutoCompleteKeys contains T
            HotKey, $Tab, Off
         If DisabledAutoCompleteKeys contains R
            HotKey, $Right, Off
      }
   
;Find the ID of the window we are using
A_id := GetIncludedActiveWindow()  

; Set a timer to check for a changed window
SetTimer, Winchanged, 100

;Change the Running performance speed (Priority changed to High in GetIncludedActiveWindow)
SetBatchLines, -1

Loop 
{ 

   ;If the active window has changed, wait for a new one
   WinGet, Temp_id, ID, A
   IfNotEqual, A_id, %Temp_id%
      A_id := GetIncludedActiveWindow()
   
   Temp_id=
   
   ;Get one key at a time 
   Input, chr, L1 V, {BS}%TerminatingCharacters%
   
   IfEqual, IgnoreSend, 1
   {
      IgnoreSend = 
      Continue
   }
   EndKey = %errorlevel% 
   ;If we have no window activated for typing, we don't want to do anything with the typed character
   IfEqual, A_id,
   {
      A_id := GetIncludedActiveWindow()
      Continue
   }

   WinGet, Temp_id, ID, A
   IfNotEqual, A_id, %Temp_id%
   {
      Temp_Id=
      A_id = GetIncludedActiveWindow()
      Continue
   }
   Temp_Id=
   
   IfEqual, A_id, %Helper_id%
   {
      Continue
   }
   
   ;If we haven't typed anywhere, set this as the last window typed in
   IfEqual, LastInput_Id,
      LastInput_Id = %A_id%
   
   IfNotEqual, DetectMouseClickMove, On
   {
      ifequal, OldCaretY,
         OldCaretY := HCaretY()
         
      if ( OldCaretY != HCaretY() )
      {
         ;Don't do anything if we aren't in the original window and aren't starting a new word
         IfNotEqual, LastInput_Id, %A_id%
            Continue
            
         ; add the word if switching lines
         AddWordToList(Word,0)
         Gosub,clearallvars
         Word = %chr%
         Continue         
      } 
   }

   OldCaretY := HCaretY()
   OldCaretX := HCaretX()
   
   ;Backspace clears last letter 
   ifequal, EndKey, Endkey:BackSpace
   {
      ;Don't do anything if we aren't in the original window and aren't starting a new word
      IfNotEqual, LastInput_Id, %A_id%
         Continue
      
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
            ; If active window has different window ID from the last input,
            ;learn and blank word, then assign number pressed to the word
            IfNotEqual, LastInput_Id, %A_id%
            {
               AddWordToList(Word,0)
               Gosub, clearallvars
               word = %chr%
               LastInput_Id = %A_id%
               Continue
            }
         
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
                  ;Don't do anything if we aren't in the original window and aren't starting a new word
                  IfNotEqual, LastInput_Id, %A_id%
                     Continue
                     
                  AddWordToList(Word,0)
                  Gosub, clearallvars   
                  Continue
                }
    
   ;Wait till minimum letters 
   IF ( StrLen(Word) < wlen )
   {
      Gui, %DropDownGui%: Hide
      ;ToolTip,
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
;      IfEqual, number, %MaxMatches%
;         Break
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
   } Else IfEqual, ArrowKeyMethod, Off
         {
            MatchPos = 
         } else IfEqual, ArrowKeyMethod, LastPosition
               {
                  IfGreater, OldMatch, %Number%
                  {
                     MatchPos = %Number%
                  } else {
                           MatchPos = %OldMatch%
                        }
                     
               } else IfEqual, ArrowKeyMethod, LastWord
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
             
   OldMatch = 
   RebuildMatchList()
   ShowToolTip()
}

;------------------------------------------------------------------------

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

;------------------------------------------------------------------------

AddToMatchList(position,value)
{
   global
   
   Local prefix
   IfEqual, NumKeyMethod, Off
   {
      prefix =
   } else {
            IfGreater, position, 10
            {
               prefix =
            } else {   
                     prefix := Mod(position,10). " "
                  }
         }

   IfEqual, ArrowKeyMethod, Off
   {
;      match .= prefix . value . "`n"
      match .= prefix . value . "|"
   } else {
            IfEqual, MatchPos, %Position%
            {
               ;match .= ">" . prefix . value . "`n"
               match .= prefix . value . "||"
            } Else {
                     ;match .= "   " . prefix . value . "`n"
                     match .=  prefix . value . "|"
                  }
         }
}

;------------------------------------------------------------------------

;Show matched values
ShowToolTip()
{
   global
;   global ToolTipOffset
;   global Word
;   global Match
;   global number
;   global ToolTipLineHeight
;   global DropDownGui
    Local SizeY
    Local ToolTipSizeY
    Local ToolTipPosY
    Local ToolTipPosX
    Local Rows
   WinGetPos,,,, SizeY, A
   ; remove window border from size
   SizeY -= 8
   ToolTipSizeY := (number * ToolTipLineHeight) + 7
   ToolTipPosY := HCaretY()+ToolTipOffset
   ; + ToolTipOffset Move tooltip down a little so as not to hide the caret. 
;   if ((ToolTipSizeY + ToolTipPosY) > SizeY)
;       ToolTipPosY := (HCaretY() - (ToolTipOffset - ToolTipLineHeight) - ToolTipSizeY)
   
   IF (number > 10)
   {
      Rows = 10
   } else Rows := Number
   
   IfNotEqual, Word,
   {
      ToolTipPosX := HCaretX()
      
      Loop, 10
      { 
         IfEqual, A_Index, %Rows%
         {
            GuiControl, %DropDownGui%: ,ToolTip%A_Index%, |%match%
            GuiControl, %DropDownGui%: Show, ToolTip%A_Index%
            Continue
         }
      
         GuiControl, %DropDownGui%: Hide, ToolTip%A_Index%
         GuiControl, %DropDownGui%: , ToolTip%A_Index%, |
      }
      Gui, %DropDownGui%: Show, AutoSize NoActivate X%ToolTipPosX% Y%ToolTipPosY% 
   }
;      ToolTip, %match%, HCaretX(), %ToolTipPosY%
}

;------------------------------------------------------------------------   

; Timed function to detect change of focus (and remove tooltip when changing active window) 
Winchanged: 
   ;make sure we are in decimal format in case ConvertWordToAscii was interrupted
   IfEqual, A_FormatInteger, H
      SetFormat,Integer,D
   
   WinGet, Temp_Id, ID, A
   IfEqual, A_id, %Temp_Id%
   {
      IfNotEqual, DetectMouseClickMove, On 
      {
         IfNotEqual, OldCaretY,
         {
            if ( OldCaretY != HCaretY() )
            {
               Gui, %DropDownGui%: Hide
               ;ToolTip,
            }
         }
      }
      
   } else {
            A_id := GetIncludedActiveWindow()
         }
   
   Temp_Id = 
   Return
   
;------------------------------------------------------------------------

GetIncludedActiveWindow()
{
   ;make sure we are in decimal format in case ConvertWordToAscii was interrupted
   IfEqual, A_FormatInteger, H
      SetFormat,Integer,D
   global Helper_id
   global A_id
   global LastActiveIdBeforeHelper
   Process, Priority,,Normal
   ;Wait for Included Active Window
   Suspend, On
   global DropDownGui
   Gui, %DropDownGui%: Hide
   ;ToolTip,
   Loop
   {
      WinGet, ActiveId, ID, A
      IfEqual, ActiveId, 
      {
         MaybeSaveHelperWindowPos()
         ;Wait for an active window, then check again
         ;Wait for any window to be active
         WinWaitActive, , , , ZZZYouWillNeverFindThisStringInAWindowTitleZZZ
         Continue
      }
      
      IfEqual, ActiveId, %Helper_id%
         Break
      WinGet, ActiveProcess, ProcessName, ahk_id %ActiveId%
      WinGetTitle, ActiveTitle, ahk_id %ActiveId%
      If CheckForActive(ActiveProcess,ActiveTitle)
         Break
      MaybeSaveHelperWindowPos()
      WinWaitNotActive, ahk_id %ActiveId%
      ActiveId =       
   }
   
   ;if we are in the Helper Window, we don't want to re-enable script functions
   IfNotEqual, ActiveId, %Helper_id%
   {
      ; Check to see if we need to reopen the helper window
      MaybeOpenOrCloseHelperWindow(ActiveProcess,ActiveTitle,ActiveId)
      Suspend, Off
      ;Set the process priority back to High
      Process, Priority,,High
      LastActiveIdBeforeHelper = %ActiveId%
      
   } else {
            IfNotEqual, A_id, %Helper_id%
               LastActiveIdBeforeHelper = %A_id%               
         }
   
   global LastInput_Id
   ;Show the ToolTip if the old window is the same as the new one
   IfEqual, ActiveId, %LastInput_Id%
   {
      ;Check Caret Position again
      MouseButtonClick=LButton
      Gosub, CheckForCaretMove
      ShowToolTip()      
   }
   Return, ActiveId
}

CheckForActive(ActiveProcess,ActiveTitle)
{
   ;Check to see if the Window passes include/exclude tests
   global ExcludeProgramExecutables
   global ExcludeProgramTitles
   global IncludeProgramExecutables
   global IncludeProgramTitles
   
   Loop, Parse, ExcludeProgramExecutables, |
   {
      IfEqual, ActiveProcess, %A_LoopField%
         Return,
   }
   
   Loop, Parse, ExcludeProgramTitles, |
   {
      IfInString, ActiveTitle, %A_LoopField%
         Return,
   }

   IfEqual, IncludeProgramExecutables,
   {
      IfEqual, IncludeProgramTitles,
         Return, 1
   }

   Loop, Parse, IncludeProgramExecutables, |
   {
      IfEqual, ActiveProcess, %A_LoopField%
         Return, 1
   }

   Loop, Parse, IncludeProgramTitles, |
   {
      IfInString, ActiveTitle, %A_LoopField%
         Return, 1
   }

   Return, 
}

;------------------------------------------------------------------------

~LButton:: 
;make sure we are in decimal format in case ConvertWordToAscii was interrupted
IfEqual, A_FormatInteger, H
   SetFormat,Integer,D
; Update last click position in case Caret is not detectable
MouseGetPos, MouseX, MouseY 
MouseButtonClick=LButton
; Using GoSub as A_CaretX in function call breaks doubleclick
Gosub, CheckForCaretMove
Return

;------------------------------------------------------------------------

~RButton:: 
MouseButtonClick=RButton
; Using GoSub as A_CaretX in function call breaks doubleclick
Gosub, CheckForCaretMove
Return

;------------------------------------------------------------------------

CheckForCaretMove:
   ;If we aren't using the DetectMouseClickMoveScheme, skip out
   IfNotEqual, DetectMouseClickMove, On
      Return
      
   ;make sure we are in decimal format in case ConvertWordToAscii was interrupted
   IfEqual, A_FormatInteger, H
      SetFormat,Integer,D
   
   WinGet, Temp_Id, ID, A
   ;Don't do anything if we aren't in the original window
   IfNotEqual, LastInput_Id, %Temp_Id%
   {
      Temp_ID =
      Return
   }
   Temp_ID =
   
   ; If we have a Word and an OldCaretX, check to see if the Caret moved
   IfNotEqual, OldCaretX, 
   {
      IfNotEqual, Word, 
      {
         IfEqual, MouseButtonClick, LButton
         {
            KeyWait, LButton, U    
         } else KeyWait, RButton, U
      
         if ( OldCaretY != HCaretY() )
         {
            ; add the word if switching lines
            AddWordToList(Word,0)
            Gosub,clearallvars
         } else if (OldCaretX != HCaretX() )
               {
                  AddWordToList(Word,0)
                  Gosub,clearallvars
               }
      }
   }

   MouseButtonClick=
   Return

;------------------------------------------------------------------------

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
MaybeOpenOrCloseHelperWindowManual()
Return

^+c:: 
AddSelectedWordToList()
Return

;------------------------------------------------------------------------

; If hotkey was pressed, check wether there's a match going on and send it, otherwise send the number(s) typed 
CheckWord(Key)
{
   global
   ;make sure we are in decimal format in case ConvertWordToAscii was interrupted
   IfEqual, A_FormatInteger, H
      SetFormat,Integer,D
   Local ATitle
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
      clearword=0
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

;------------------------------------------------------------------------

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
   Gosub, clearallvars
   Return
}  

;------------------------------------------------------------------------

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
      clearword=0
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

;------------------------------------------------------------------------
            
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

;------------------------------------------------------------------------
   
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
                              IfNotEqual, ActiveControl,
                                 ControlSend, %ActiveControl%, %sending%, ahk_id %A_id%
                           }
                  }
         }
         
   Clipboard := ClipboardSave
   Return
}

;------------------------------------------------------------------------

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

;------------------------------------------------------------------------
      
ReturnWinActive()
{
   global A_id
   WinGet, Temp_id, ID, A
   Return, ( A_id = Temp_id )
}

;------------------------------------------------------------------------

ReturnLineWrong()
{
   global
   ; Return false if we are using DetectMouseClickMove
   IfEqual, DetectMouseClickMove, On
      Return
      
   Return, ( OldCaretY != HCaretY() )
}

;------------------------------------------------------------------------

MaybeOpenOrCloseHelperWindow(ActiveProcess,ActiveTitle,ActiveId)
{
   ; This is called when switching the active window
   global HelperManual
   
   IfNotEqual, HelperManual,
   {
      MaybeCreateHelperWindow()
      Return
   }

   IF ( CheckHelperWindowAuto(ActiveProcess,ActiveTitle) )
   {
      global HelperClosedWindowIds
      ; Remove windows which were closed
      Loop, Parse, HelperClosedWindowIDs, |
      {
         IfEqual, A_LoopField,
            Continue
            
         IfWinExist, ahk_id %A_LoopField%
         {
            TempHelperClosedWindowIDs .= "|" . A_LoopField . "|"
         }
      }
      
      HelperClosedWindowIDs = %TempHelperClosedWindowIDs%
      TempHelperClosedWindowIDs =
      
      SearchText := "|" . ActiveId . "|"
      
      IfInString, HelperClosedWindowIDs, %SearchText%
      {
         MaybeSaveHelperWindowPos()
      } else MaybeCreateHelperWindow()
   
   } else MaybeSaveHelperWindowPos()

   Return
   
}

CheckHelperWindowAuto(ActiveProcess,ActiveTitle)
{
   global HelperWindowProgramExecutables
   global HelperWindowProgramTitles
   
   Loop, Parse, HelperWindowProgramExecutables, |
   {
      IfEqual, ActiveProcess, %A_LoopField%
         Return, true
   }

   Loop, Parse, HelperWindowProgramTitles, |
   {
      IfInString, ActiveTitle, %A_LoopField%
         Return, true
   }

   Return
}

MaybeOpenOrCloseHelperWindowManual()
{
   ;Called when we hit Ctrl-Shift-H
   
   ;make sure we are in decimal format in case ConvertWordToAscii was interrupted
   IfEqual, A_FormatInteger, H
      SetFormat,Integer,D
      
   global Helper_id
   global HelperManual
   
   ;If a helper window already exists 
   IfNotEqual, Helper_id,
   {
      ; If we've forced a manual helper open, close it. Else mark it as forced open manually
      IfNotEqual, HelperManual,
      {
         HelperWindowClosed()
      } else HelperManual=1
   } else {
            global A_id
            WinGetTitle, ActiveTitle, ahk_id %A_id%
            WinGet, ActiveProcess, ProcessName, ahk_id %A_id%
            ;Check for Auto Helper, and if Auto clear closed flag and open
            IF ( CheckHelperWindowAuto(ActiveProcess,ActiveTitle) )
            {
               global HelperClosedWindowIDs
               SearchText := "|" . A_id . "|"
               StringReplace, HelperClosedWindowIDs, HelperClosedWindowIDs, %SearchText%
               
            } else {
                     ; else Open a manually opened helper window
                     HelperManual=1
                  }
            MaybeCreateHelperWindow()
         }
      
   Return
}

;------------------------------------------------------------------------

;Create helper window for showing tooltip
MaybeCreateHelperWindow()
{
   Global Helper_id
   global HelperGui
   ;Don't open a new Helper Window if One is already open
   IfNotEqual, Helper_id,
      Return
      
   ;make sure we are in decimal format in case ConvertWordToAscii was interrupted
   IfEqual, A_FormatInteger, H
      SetFormat,Integer,D
   Global XY
   Gui, %HelperGui%:+Owner -MinimizeBox -MaximizeBox +AlwaysOnTop
   Gui, %HelperGui%:+LabelHelper_
   Gui, %HelperGui%:Add, Text,,Tooltip appears here 
   IfNotEqual, XY, 
   {
      StringSplit, Pos, XY, `, 
      Gui, %HelperGui%:Show, X%Pos1% Y%Pos2% NoActivate
   } else {
            Gui, %HelperGui%:Show
         }
   WinGet, Helper_id, ID,,Tooltip appears here 
   return 
}

;------------------------------------------------------------------------

Helper_Close:
HelperWindowClosed()
Return

HelperWindowClosed()
{
   ;make sure we are in decimal format in case ConvertWordToAscii was interrupted
   IfEqual, A_FormatInteger, H
      SetFormat,Integer,D
   global Helper_id
   global HelperManual
   IfNotEqual, Helper_id,
   {
      ;Check LastActiveIdBeforeHelper and not A_id in case we are on the Helper Window
      global LastActiveIdBeforeHelper
      WinGetTitle, ActiveTitle, ahk_id %LastActiveIdBeforeHelper%
      WinGet, ActiveProcess, ProcessName, ahk_id %LastActiveIdBeforeHelper%
      
      If ( CheckHelperWindowAuto(ActiveProcess,ActiveTitle) )
      {
         global HelperClosedWindowIDs
         
         SearchText := "|" . LastActiveIdBeforeHelper . "|"         
         IfNotInString HelperClosedWindowIDs, %SearchText%
            HelperClosedWindowIDs .= SearchText
      }
   
      HelperManual=   
   
      MaybeSaveHelperWindowPos()
   }
   Return
}

;------------------------------------------------------------------------

MaybeSaveHelperWindowPos()
{
   global Helper_id
   global HelperGui
   IfNotEqual, Helper_id, 
   {
      global XY
      global XYSaved
      WinGetPos, hX, hY, , , ahk_id %Helper_id%
      XY = %hX%`,%hY%
      XYSaved = 1
      Helper_id = 
      Gui, %HelperGui%:Hide
   }
}

;------------------------------------------------------------------------

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

;------------------------------------------------------------------------

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

;------------------------------------------------------------------------

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

;------------------------------------------------------------------------

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
         Return    
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
                     
                  Local ContainList 
                  If DisabledAutoCompleteKeys contains N
                  {
                     ContainList = %ForceNewWordCharacters%
                  } else {
                           ContainList = 1,2,3,4,5,6,7,8,9,0,%ForceNewWordCharacters%
                        }
               
                  if addword contains %ContainList%
                     Return
                  
                  ContainList = 
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

;------------------------------------------------------------------------

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

;------------------------------------------------------------------------
   
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

;------------------------------------------------------------------------

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
         Sort, WordList, N R D  ;Sort the wordlist by order of 
         
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

;------------------------------------------------------------------------
      
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

;------------------------------------------------------------------------

; This is to blank all vars related to matches, tooltip and (optionally) word 
clearallvars: 
   ;make sure we are in decimal format in case ConvertWordToAscii was interrupted
   IfEqual, A_FormatInteger, H
      SetFormat,Integer,D
   Ifequal,clearword,1
   {
      word =
      OldCaretY=
      OldCaretX=
      LastInput_id=
   }

   Gui, %DropDownGui%: Hide
   ;ToolTip 
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

;------------------------------------------------------------------------

ReadPreferences()
{
   global
   Local Prefs
   Local INI
   
   Prefs = %A_ScriptDir%\Preferences.ini
   DftTerminatingCharacters = {enter}{space}{esc}{tab}{Home}{End}{PgUp}{PgDn}{Up}{Down}{Left}{Right}.;`,???!'"()[]{}{}}{{}``~`%$&*-+=\/><^|@#:
   If FileExist(Prefs)
   {
      ;IncludePrograms
      IniRead, IncludeProgramExecutables, %Prefs%, IncludePrograms, IncludeProgramExecutables, %A_Space%
      IniRead, IncludeProgramTitles, %Prefs%, IncludePrograms, IncludeProgramTitles, %A_Space%
      ;ExcludePrograms
      IniRead, ExcludeProgramExecutables, %Prefs%, ExcludePrograms, ExcludeProgramExecutables, %A_Space%
      IniRead, ExcludeProgramTitles, %Prefs%, ExcludePrograms, ExcludeProgramTitles, %A_Space%
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
      IniRead, DetectMouseClickMove, %Prefs%, Settings, DetectMouseClickMove, On
      IniRead, SendMethod, %Prefs%, Settings, SendMethod, 1
      IniRead, MaxMatches, %Prefs%, Settings, MaxMatches, 10
      IniRead, TerminatingCharacters, %Prefs%, Settings, TerminatingCharacters, %DftTerminatingCharacters%
      IniRead, ForceNewWordCharacters, %Prefs%, Settings, ForceNewWordCharacters, %A_Space%
      ;HelperWindow
      IniRead, HelperWindowProgramExecutables, %Prefs%, HelperWindow, HelperWindowProgramExecutables, %A_Space%
      IniRead, HelperWindowProgramTitles, %Prefs%, HelperWindow, HelperWindowProgramTitles, %A_Space%
      IniRead, XY, %Prefs%, HelperWindow, XY, %A_Space%
   } else {
            INI= 
               ( 
[IncludePrograms]
;
;IncludeProgramExecutables is a list of executable (.exe) files that TypingAid should be enabled for.
;If one the executables matches the current program, TypingAid is enabled for that program.
IncludeProgramExecutables=
;
;
;IncludeProgramTitles is a list of strings (separated by | ) to find in the title of the window you want TypingAid enabled for.
;If one of the strings is found in the title, TypingAid is enabled for that window.
IncludeProgramTitles=
;
;
[ExcludePrograms]
;
;ExcludeProgramExecutables is a list of executable (.exe) files that TypingAid should be disabled for.
;If one the executables matches the current program, TypingAid is disabled for that program.
ExcludeProgramExecutables=
;
;ExcludeProgramTitles is a list of strings (separated by | ) to find in the title of the window you want TypingAid disabled for.
;If one of the strings is found in the title, TypingAid is disabled for that window.
ExcludeProgramTitles=
;
[Settings]
;
;Length is the minimum number of characters that need to be typed before the program shows a tooltip.
;Generally, the higher this number the better the performance will be.
;For example, if you need to autocomplete "as soon as possible" in the word list, set this to 2, type 'as' and a tooltip will appear.
Length=3
;
;
;NumPresses is the number of times the number hotkey must be tapped for the word to be selected, either 1 or 2.
NumPresses=1
;
;
;ToolTipOffset is the number of pixels below the top of the caret (vertical blinking line) to display the tooltip.
ToolTipOffset=14
;
;
;ToolTipLineHeight is the height (in pixels) of one line in the tooltip.
;This number should only need to be changed if the tooltip is blocking the typing at the bottom of the 
;window. This is only likely to happen if you have changed the tooltip font size or font DPI in windows.
;(Used for calculation when displaying the tooltip above the caret when at the bottom of the window).
ToolTipLineHeight=13
;
;
;LearnMode defines whether or not the script should learn new words as you type them, either On or Off.
;Entries in the wordlist are limited to a length of 123 characters in ANSI version
;or 61 characters in Unicode version if LearnMode is On.
LearnMode=On
;
;
;LearnCount defines the number of times you have to type a word within a single session for it to be learned permanently.
LearnCount=5
;
;
;LearnLength is the minimum number of characters in a word for it to be learned. This must be at least Length+1.
LearnLength=5
;
;
;ArrowKeyMethod is the way the arrow keys are handled when a tooltip is shown.
;Options are:
;  Off - you can only use the number keys
;  First - resets the selection cursor to the beginning whenever you type a new character
;  LastWord - keeps the selection cursor on the prior selected word if it's still in the list, else resets to the beginning
;  LastPosition - maintains the selection cursor's position
ArrowKeyMethod=First
;
;
;DisabledAutoCompleteKeys is used to disable certain hotkeys from autocompleting the selected item in the tooltip.
;Place the character listed for each key you want to disable in the list. IE
;DisabledAutoCompleteKeys=ST
;will disable Ctrl+Space and Tab.
;  E = Ctrl + Enter
;  S = Ctrl + Space
;  T = Tab
;  R = Right Arrow
;  N = Number Keys
DisabledAutoCompleteKeys=
;
;
;DetectMouseClickMove is used to detect when the cursor is moved with the mouse.
; On - TypingAid will not work when used with an On-Screen keyboard.
; Off - TypingAid will not detect when the cursor is moved within the same line using the mouse, and scrolling the text will clear the tooltip.
DetectMouseClickMove=On
;
;
;SendMethod is used to change the way the program sends the keys to the screen, this is included for compatibility reasons.
;Try changing this only when you encounter a problem with key sending during autocompletion.
;  1 = Fast method that reliably buffers key hits while sending. HAS BEEN KNOWN TO NOT FUNCTION ON SOME MACHINES.
;      (Might not work with characters that cannot be typed using the current keyboard layout.)
;  2 = Fastest method with unreliable keyboard buffering while sending. Has been known to not function on some machines.
;  3 = Slowest method, will not buffer or accept keyboard input while sending. Most compatible method.
;The options below use the clipboard to copy and paste the data to improve speed, but will leave an entry in any clipboard 
;history tracking routines you may be running. Data on the clipboard *will* be preserved prior to autocompletion.
;  1C = Same as 1 above.
;  2C = Same as 2 above, doesn't work on some machines.
;  3C = Same as 3 above.
;  4C = Alternate method.
SendMethod=1
;
;
;MaxMatches is the maximum number of words or phrases to show in a tooltip. Valid range is from 10 to 20.
;If ArrowKeyMethod=Off this will be forced to 10
MaxMatches=10
;
;
;TerminatingCharacters is a list of characters (EndKey) which will signal the program that you are done typing a word.
;You probably need to change this only when you want to recognize and type accented (diacritic) or Unicode characters
;or if you are using this with certain programming languages.
;
;For support of special characters, remove the key that is used to type the diacritic symbol (or the character) from the right hand side. 
;For example, if on your keyboard layout, " is used before typing ë, ; is used to type ?, remove them from the right hand side.
;
;After this, TypingAid can recognize the special character. The side-effect is that, it cannot complete words typed after 
;the symbol, (e.g. "word... ) If you need to complete a word after a quotation mark, first type two quotation marks "" then 
;press left and type the word in the middle.
;
;If unsure, below is a setting for you to copy and use directly:
;
;Universal setting that work for many languages with accented or Unicode characters:
;{enter}{space}{bs}{esc}{tab}{Home}{End}{PgUp}{PdDn}{Up}{Dn}{Left}{Right}???!()$
;
;Default setting:
;%DftTerminatingCharacters%
;
; More information on how to configure TerminatingCharacters:
;A list of keys may be found here:
; http://www.autohotkey.com/docs/KeyList.htm
;For more details on how to format the list of characters please see the EndKeys section (paragraphs 2,3,4) of:
; http://www.autohotkey.com/docs/commands/Input.htm
TerminatingCharacters=%DftTerminatingCharacters%
;
;
;ForceNewWordCharacters is a comma separated list of characters which forces the program to start a new word whenever
;one of those characters is typed. Any words which begin with one of these characters will never be learned (even
;if learning is enabled). If you were typing a word when you hit one of these characters that word will be learned
;if learning is enabled.
;Change this only if you know what you are doing, it is probably only useful for certain programming languages.
ForceNewWordCharacters=
;
;
[HelperWindow]
;
;HelperWindowProgramExecutables is a list of executable (.exe) files that the HelperWindow should be automatically enabled for.
;If one the executables matches the current program, the HelperWindow will pop up automatically for that program.
HelperWindowProgramExecutables=
;
;
;HelperWindowProgramTitles is a list of strings (separated by | ) to find in the title of the window that the HelperWindow should be automatically enabled for.
;If one of the strings is found in the title, the HelperWindow will pop up automatically for that program.
HelperWindowProgramTitles=
;
;
; XY specifies the position the HelperWindow opens at. This will be updated automatically when the HelperWindow is
; next opened and closed
XY=200,277
               )
               FileAppendDispatch(INI, Prefs)
         }
   
   ; Legacy support for old Preferences File
   IfNotEqual, Etitle,
   {
      IfEqual, IncludeProgramTitles,
      {
         IncludeProgramTitles = %Etitle%
      } else {
               IncludeProgramTitles .= "|" . Etitle
            }
      
      Etitle=      
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
   
   if DisabledAutoCompleteKeys contains N
      NumKeyMethod = Off
   
   IfNotEqual, ArrowKeyMethod, Off
      If DisabledAutoCompleteKeys contains E
         If DisabledAutoCompleteKeys contains S
            If DisabledAutoCompleteKeys contains T
               If DisabledAutoCompleteKeys contains R
                  ArrowKeyMethod = Off
   
   If ArrowKeyMethod not in First,Off,LastWord,LastPosition
   {
      ArrowKeyMethod = First       
   } else {
            IfEqual, ArrowKeyMethod, Off ;force MaxMatches to 10 if we aren't using arrow keys
               MaxMatches=10
         }
   
   If DetectMouseClickMove not in On,Off
      DetectMouseClickMove = On
   
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

;------------------------------------------------------------------------

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

;------------------------------------------------------------------------
   
SaveScript:
;make sure we are in decimal format in case ConvertWordToAscii was interrupted
IfEqual, A_FormatInteger, H
   SetFormat,Integer,D

; Close the tooltip if it's open
Gui, %DropDownGui%: Hide
;ToolTip,

Suspend, On

;Change the cleanup performance speed
SetBatchLines, 20ms
Process, Priority,,Normal

MaybeSaveHelperWindowPos()

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
   
               Sort, SortWordList, N R D  ; Sort numerically, comma delimiter
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