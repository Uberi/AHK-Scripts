; Word manipulation program written Peter Meares 2008-2009
; See end for instructions, ideas and history
;
; Load all the required functions
#Include C:\Program Files\AutoHotkey\Lib\My_Anagram_Function_Library.ahk

SetBatchLines, -1
#SingleInstance
Version := "6s"
; Dictionary strings
Dictionary :=         ; Stores all the words and Patterns
SDictionary :=        ; List to Store Words without pattern part
WDictionary :=        ; A temp Dictionary list
TDictionary :=        ; A temp Dictionary list
Collection :=         ; List for words that fit the criteria
SCollection :=        ; A temp Dictionary list
Dict_Word_Count := 0  ; Global number of words in main dictioanry
WSize := 0            ; Length of Word
Dict_Loaded := 0      ; Flag to show dictionary loading
Mob_Dict_Loaded := 0  ; Mobile Dictioanry not loaded
Stop_Sign := 0        ; Stop requested during long operation
Sorted := "Down"      ; default sort direction
Debug_Write_Flag := False ; true means write to debug file

Gosub, Initialise_Variables 

; Scrabble Score variables
Score_Array%1% = 0
Score_List := "1,3,3,2,1,4,2,4,1,8,5,1,3,1,1,3,10,1,1,1,1,4,4,8,4,10"
Load_Scrabble_scores()

; Define the GUI
Gui,Margin,0,0

gui, font,s9 Normal, Verdana
Gui,Add,Edit,x6 y6 r1 h15 w280 c0000FF UpperCase vUserWord ,
; Buttons
Gui,Add,Button,x300 y6 h25 gSearch Default,Work
Gui,Add,Button,x370 y6 h25 gOn_line,On_line
Gui,Add,Button,x300 yp+35 h25 gAnagram,Anagram
Gui,Add,Button,x300 yp+30 h25 gWildcard, Wildcard
Gui,Add,Button,x300 yp+30 w120 gSelected_Letter_Positions, Letter Positions
Gui,Add,Button,x300 yp+30 h25 gWord_from_Letters, All Words FROM these Letters
Gui,Add,Button,x300 yp+30 h25 gLetterInWordList, All Words WITH these Letters

; Word Length selection
Gui,Add,GroupBox,x300 yp+30 w200 h50, Word Length
Gui,Add,Edit,xp+5 yp+21 w40 vWSize +Center
Gui,Add,Button,xp+50 yp-2 w40 gWordSize_Greater, >= 
Gui,Add,Button,xp+50 yp h25 w40 gWordSize_Equal, =
Gui,Add,Button,xp+50 yp w40 gWordSize_Less, <=
;
; One letter different button
Gui, Add, Button, x550 y150 gOne_Letter_Different, One Diff
;
; Word List sorting
Gui,Add,GroupBox,x452 y6 w130 h115, Sorting
Gui,Add,Button,xp+11 yp+21 h25 gMy_Length_Sort, Sort by Length
Gui,Add,Button,xp yp+30 h25 gMy_Score_Sort, Sort by Score
Gui,Add,Button,xp yp+30 h25 gMy_Spell_Sort, Sort by Spelling
;
; Letter pattern box
Gui,Add,GroupBox,x300 y262 w225 h45, Letter Pattern
Gui,Add,Edit,xp+5 yp+17 w220 vCode +Center
; Scrabble Score box
Gui,Add,GroupBox,x300 y320 w110 h45,Scrabble Score
Gui,Add,Edit,xp+35 yp+17 w40 +Center vScore

; Games solvers
Gui,Add,GroupBox,x10 y480 w630 h100,Puzzle Solvers
; Polyword
Gui,Add,GroupBox,x20 y500 w110 h75 +Center,PolyWord
Gui,Add,Edit,xp+35 yp+17 w40 +Center UpperCase vPolyLetter
Gui,Add,Button,xp-15 yp+25 h25 gPolyWord, PolyWord
; Middle Word
Gui,Add,GroupBox,x140 y500 w250 h75 +Center,Middle Word
Gui,Add,Edit,xp+5 yp+17 w115 +Center UpperCase vMW_Left_Word
Gui,Add,Edit,xp+125 yp w115 +Center UpperCase vMW_Right_Word
Gui,Add,Button,xp-30 yp+25 h25 gMiddleWord, Solve
; Word Chain
Gui,Add,GroupBox,x420 y500 W177 h75 +Center,Word Chain
Gui,Add,Edit,xp+5 yp+17 w115 +Center UpperCase vWC_Top_Word
Gui,Add,Edit,xp+130 yp w25 +Center UpperCase vWC_Steps
Gui,Add,Edit,xp-130 yp+28 w115 +Center UpperCase vWC_Bottom_Word
Gui,Add,Button,xp+120 yp h25 gWordChain, Solve
; Menu Gui
Menu, DictMenu, Add, Change Dictionary, Change_Dict
Menu, DictMenu, Add, Add Word to Dictionary, Add_Dict_Word
Menu, DictMenu, Add, Check Word List against Dictionary, Check_Word_List
Menu, DictMenu, Add, Make New Dictionary, Make_New_Dictionary
Menu, DictMenu, Add, Change On_Line Dictionary, Change_OL_Dictionary
;
Menu, WordMenu, Add, Words with nr of Letters, Word_nr_Letters
Menu, WordMenu, Add, Count Letter Lengths, Word_Pattern_Count
Menu, WordMenu, Add, Scrabble Scores List, Scrabble_Scores_List
Menu, WordMenu, Add, Palindromes List, Palindrome_List
Menu, WordMenu, Add, Backwards Words, BackWords
Menu, WordMenu, Add, Permutations, Permutations
; Mobile phone menu
Menu, MobMenu, Add, Find the Number for a Word, Get_Number_from_Word
Menu, MobMenu, Add, Find words for a number, Get_Words_from_Number
Menu, MobMenu, Add, Find a Mobile Key Press list for a Word, Get_KeyPress_for_a_Word
Menu, MobMenu, Add, Find Words for Mobile KeyPress list, Get_Words_From_Keypress
Menu, MobMenu, Add, Create Mobile Score File, Create_Mobile_Dictionary
;
Menu, HelpMenu, Add, Help, Help
Menu, HelpMenu, Add, About, About
;
Menu, MyMenuBar, Add, &Dictionary, :DictMenu
Menu, MyMenuBar, Add, &Words, :WordMenu
Menu, MyMenuBar, Add, &Mobile, :MobMenu
Menu, MyMenuBar, Add, &Help, :HelpMenu
Gui, Menu, MyMenuBar
;
; Main ListBox and Messages
Gui,Add,ListBox,x6 y35 r16 w285 +0x1000 vResults gMy_ListBox,
;
; Message boxes
Gui,Add,Text,x6 y263,Messages
Gui,Add,Edit,x6 y280 w250 vMessage +Center, Enter word
;
; Information counts
Gui,Add,GroupBox,x5 y308 w200 h100, Word Counts
Gui,Add,Text,xp+5 yp+20 ,Dictionary
Gui,Add,Edit,xp+100 yp w75 +Center vDict_Count
; Number of Words Found box
Gui,Add,Text,xp-100 yp+25,Found
Gui,Add,Edit,xp+100 yp w75 +Center vSubW_Count
; Number of Words found Selected box
Gui,Add,Text,xp-100 yp+25,Selected
Gui,Add,Edit,xp+100 yp w75 +Center vFoundW_Count

; Dictionary File name box
Gui, Add, GroupBox, x5 y410 h50 w210,Dictionary File
Gui, Add, Edit, xp+5 yp+20 w200 +Center vWords_File
;
; Break, Clear and Save Words command
Gui,Add,GroupBox,x450 y320 h80 w125, Commands
Gui,Add,Button,xp+5 yp+20 gBreakout, Break
Gui,Add,Button,xp+70 yp gClear_Select, Clear
Gui,Add,Button,xp-60 yp+30 h25 gSave +Center, Save Words
;
; Close Box
Gui,Add,Button,x520 y435 gGuiClose, Close
;
gui,show,w650 h585,Word Manipulator

;Read Dictionary into Memory, only once
if not Dict_Loaded
  {
  Gosub, Read_Dict
  } 
Return

GuiEscape:
GuiClose:
EXITAPP
Return

; BackWords ---------------------------
; VERY SLOW
; Look for words that are also a word backwards
; Goes through whole dictionary looking to see
; is the reverse of each word is a word
;
Backwords:
WDictionary := ""
WCount := 0
PCount := 0
Critical, On
Loop, Parse, SDictionary,`n
  {
  if(Stop_Sign = 1)
    {
    GuiControl,, Message, User stopped operation
    Critical, Off
    Return
    }
  Test_Word := A_LoopField
  Rev_Test_Word := StringReverse(Test_Word)

  Found := Check_Word_in_SDictionary(Rev_Test_Word)
  if (Found = 1)
    {
    if(strlen(WDictionary) = 0)
      WDictionary = %Test_Word%
    else
      WDictionary = %WDictionary%`n%Test_Word%

    GuiControl,, Message, %Rev_Test_Word%
    WCount++ 
    GuiControl,, FoundW_Count, %WCount%
    }
  PCount++
  GuiControl,, SubW_Count, %PCount%
  }

Critical, Off
; Change | to `n so Listbox works
  StringReplace,Collection,WDictionary,`n,|,All
  Gosub, List_Results   
Return

; Word is also word when backwards ------------------------
;
Palindrome_List:
; Takes all words in Dictionary and checks to see if it is a palindrome
; Reverse each dictionary word and compare
; Add palindromes to collection for display
WDictionary := ""
WCount := 0

Loop, Parse, SDictionary,`n
  {
  if(Stop_Sign = 1)
    {
    GuiControl,, Message, User stopped operation
    Critical, off
    Return
    }
  Test_Word := A_LoopField
  Rev_Test_Word := StringReverse(Test_Word)

  if (Test_Word = Rev_Test_Word) 
    {
    if(strlen(WDictionary) = 0)
      WDictionary = %Test_Word%
    else
      WDictionary = %WDictionary%`n%Test_Word%
  
    WCount++
    GuiControl,, FoundW_Count, %WCount%
    }
  }

; Change | to `n so Listbox works
  StringReplace,Collection,WDictionary,`n,|,All
  Gosub, List_Results   


Return

; One_Letter_Different -------------------------------------------
;
One_Letter_Different:
Gui,Submit,NoHide
WSize := strlen(UserWord)
GuiControl,,WSize, %WSize%
SWCount := Create_WDictionary(WSize, "EQ")
GuiControl,,SWCount, %SWCount%
; WDictionary has all words with 'n delimiter
StringReplace, Collection, WDictionary,`n,|,All
;WCount := Count_Words_in_Dictionary(WDictionary, "|")
Gosub, List_Results 
; Now find words of one letter different.
; Replace each letter in turn with ?
One_Letter_Different(TDictionary, UserWord)
; TDictionary has | delimied words
Collection := TDictionary
WCount := Count_Words_in_Dictionary(TDictionary, "|")
Gosub, List_Results 

Return

; ----------------------------------------------------------------
; Word Chain
; First Word ---- LAst Word
WordChain:
Gui,Submit,NoHide

; Debug file
Debug_File := "Debug_Log.txt"
ifExist,%Debug_File%
  FileDelete, %Debug_File%
  
; Get word length
; Check length is > 0 and two are the same
if (strlen(WC_Top_Word) = 0 or strlen(WC_Bottom_Word) = 0)
    {
    GuiControl,,Message, Need two words
    Return
    }
if (strlen(WC_Top_Word) <> strlen(WC_Bottom_Word))
    {
    GuiControl,,Message, Must be the same size
    Return
    }
if (WC_Steps < 1)
    {
    GuiControl,,Message, Need at least one step
    Return
    }
GuiControl,,Message, Sorting out Dictionaries

WSize := strlen(WC_Top_Word)
GuiControl,,WSize, %WSize%
SWCount := Create_WDictionary(WSize, "EQ")
GuiControl,,SWCount, %SWCount%
; WDictionary has all words with 'n delimiter
StringReplace, Collection, WDictionary,`n,|,All

Gosub, List_Results 
 
; Bottom_Word_One_Step_Dictionary
; WC_Top_Word
; WC_Bottom_Word

One_Letter_Different(Bottom_Word_One_Step_Dictionary, WC_Bottom_Word)

GuiControl,,Message, Looking for Solutions

; Clear variables
Sol_Count := 0
WC_Solution := ""
WC_Count := 0
Time_to_end = 0

Loop,% WC_Steps + 2
  {
  tDict%WC_Count% := ""
  WC_List%WC_Count% := ""
  WC_Count++
  }
WC_List0 = %WC_Top_Word%
WC_End := WC_Steps + 1
WC_List%WC_End% = %WC_Bottom_Word%

; Level 1
WC_Count := 0

Debug_Write("Top Word "WC_Top_Word, Debug_Write_Flag)
Debug_Write("Bottom Word "WC_Bottom_Word, Debug_Write_Flag)
Debug_Write("Bottom_Word_One_Step_Dictionary "Bottom_Word_One_Step_Dictionary, Debug_Write_Flag)
Debug_Write("Enter Get Word List", Debug_Write_Flag)

Get_Word_List(WC_List0, 1)

if strlen(WC_Solution) = 0
  GuiControl,,Message, No Solutions found
else
  {
  GuiControl,,SWCount, %Sol_Count%
  StringReplace, Collection, WC_Solution,`n,|,All
  Gosub, List_Results
  GuiControl,,Message, Finished %Sol_Count% Solutions
  }

Return

; Debug_Write-------------------------------------------
; Example
; Debug_Write("Level "Variable, True)
; No % needed
Debug_Write(tmpstr, Flag = True)
{
global Debug_File
if (Flag = True)
  FileAppend,%tmpstr%`n,%Debug_File% 
}

; ----------------------------------------
; tmp_Word is the Word to get sort a dict for
; Level is the word level
; 
Get_Word_List(tmp_Word, Level)
{
global WC_Steps
global tDict
global WC_List
global Bottom_Word_One_Step_Dictionary
global Sol_Count
global WC_Solution
global Debug_Write_Flag
global SWCount

Debug_Write("Word "tmp_Word, Debug_Write_Flag)

if(Level = WC_Steps)
  {
  Time_to_end = 1
  }

; Get Dictionary space of words
ttDict := tDict%Level%
One_Letter_Different(ttDict, tmp_Word)

Loop, Parse, ttDict,|
  {
Debug_Write("Look up Word "A_LoopField, Debug_Write_Flag)
Debug_Write("From Level " Level, Debug_Write_Flag)

  if (Time_to_end = 1)
    {
Debug_Write("Look up in Bottom Dictionary", Debug_Write_Flag)
Debug_Write("Bottom_Dict " Bottom_Word_One_Step_Dictionary, Debug_Write_Flag)

    IfInString, Bottom_Word_One_Step_Dictionary, %A_LoopField%
      {
      WC_List%Level% = %A_LoopField%
Debug_Write("Level " Level, Debug_Write_Flag)
      ttt = WC_List%Level%
Debug_Write(ttt, Debug_Write_Flag)  
      Build_WC_Solution()
Debug_Write("Solution`n" WC_Solution, Debug_Write_Flag)
      SWCount := Sol_Count   
      Sol_Count++
      }
    else
      {
Debug_Write("Look up Word " A_LoopField, Debug_Write_Flag)
      Debug_Write("Not in Bottom Word List ", Debug_Write_Flag)
      }
    }
  else
    {
Debug_Write("Go to next level", Debug_Write_Flag)
    WC_List%Level% = %A_LoopField%
    Level++
    Get_Word_List(A_LoopField, Level)   
    Level--    
Debug_Write("Back from Word List", Debug_Write_Flag)
    if (Time_to_end = 1)
      {
      Time_to_end := 0
      }
    }     
  }
Level--
Debug_Write("Back from level " Level, Debug_Write_Flag)
Debug_Write("To Level " Level, Debug_Write_Flag)

if (Time_to_end = 1)
  {
  Time_to_end := 0
  }

Return Level
}

; ---------------------------------------------
;
Build_WC_Solution()
{
global
static tmpCount := 0
AI_C := 0
Loop, % WC_Steps + 2
  {
  ttt := WC_List%AI_C%

  if (StrLen(WC_Solution) = 0)
    {
    WC_Solution = %ttt%
    tmpCount := Sol_Count
    }
  else
    if(tmpCount <> Sol_Count)
      {
      WC_Solution = %WC_Solution%%ttt%
      tmpCount := Sol_Count
      }
    else
      WC_Solution = %WC_Solution%,%ttt%
    
  AI_C++
  }
WC_Solution = %WC_Solution%`n

Return
}


; One letter different List-----------------------------
; Now find words of one letter different.
; 
One_Letter_Different(ByRef TDictionary, tWord)
  {
  ; Clear temp dictionary
  TDictionary := ""

;msgbox %tWord%
  ; Replace each letter in turn with ?
  loop, parse, tWord
    {  
    Letter_Selection := tWord
    StringReplaceChar(Letter_Selection, A_Index, "?")

;msgbox %Letter_Selection%

    ; replace ? with letter and cehck in Dictionary
    Loop, 26
      {  
      ; convert to ASCII code
      tmp_chcr := A_Index + 64
      Chrr := Chr(tmp_chcr)
      tmp_Word := Letter_Selection
      StringReplace, tmp_Word, tmp_Word ,?, %Chrr%       
    ; Now find words   
      Wfound := Check_Word_in_WDictionary(tmp_Word)
      if Wfound = 1
        {
        ; store word for next round
        if(strlen(TDictionary) = 0)
          TDictionary = %tmp_Word%
        else  
          TDictionary = %TDictionary%|%tmp_Word%
        }
      }    
    }
;msgbox %TDictionary%  
  ; Remove the original word
  tmpStr = %tWord%|
  StringReplace,TDictionary,TDictionary,%tmpStr% ,,All
  ; Need to delete duplicates
  Sort, TDictionary, U D|
  }
Return


;StringReplaceChar ------------------------------------------------------
;**** StringReplaceChar(ByRef In_String,In_Posi,New_Char) 
;**** Replaces an character at position In_Posi within 
;**** In_String with New_Char. If New_Char is a String 
;**** ONLY the first character in New_Char is used 
;**** If New_Char is empty the character at In_Posi 
;**** is deleted from In_String 
StringReplaceChar(ByRef In_String,In_Posi,New_Char) 
{ 
  local Length, Before, After, Rep_Char 
  StringLen, Length, In_String 
  if (In_Posi>Length)or(length=0)or(In_Posi<0) 
     return ;//nothing is done 
  StringLeft, Rep_Char, New_Char, 1 
  StringLeft, Before, In_String, In_Posi-1 
  StringRight, After, In_String, Length-In_Posi 
  In_String=%Before%%Rep_Char%%After%    
}

; ----------------------------------------------------------------
; Work out Permutations
Permutations:
Gui,Submit,NoHide
Not_Implemented()

Return

; ----------------------------------------------------------------
; Change the online dictionary

Change_OL_Dictionary:

InputBox, OLD_temp, On_Line dictionary name, Enter Website URL,,300,100
if ErrorLevel = 1
  {
  GuiControl,,Message, Address not saved
  Return
  }
; check correct address

; Ask to save it in ini file
MsgBox,4,,Do you want to Save the new web address?
IfMsgBox No
  {
  GuiControl,,Message, Address not saved
  Return
  }
else IfMsgbox Yes 
  IniWrite,%OLD_temp%,Word_Manipulator.ini,Dictionary,On_Line_Dictionary

Return

; ----------------------------------------------------------------
; Looks up the word on line with your selected Dictionary
;
On_line:
Gui,Submit,NoHide
if (strlen(UserWord) = 0)
  {
  GuiControl,,Message, No Word Entered
  Return
  }
else IfInString, UserWord, ?   ; Check if there is a ? in line
  GuiControl,,Message, ? mark not allowed
else IfInString, UserWord, *   ; check if there is a * in line
  GuiControl,,Message, * not allowed
else
  {
  OLD = %On_Line_Dictionary%/%UserWord%
;  msgbox %OLD%
  Run, %OLD%
  }

Return

; ----------------------------------------------------------------
; Solves the number of words from a set of letters with one letter
; that must be in each word.
; (Called PolyWord in Telegraph Newspaper)
;
PolyWord:
Gui,Submit,NoHide
; Clear temp Dictionary
WDictionary :=
; Check to see if the ListBox has some words to work with
if(Collection = "")
  {
  Gosub Word_from_Letters
  if(Collection = "")
    {
    GuiControl,,Message, No Words Found
    Return
    }  
  }  
WCount := 0
; Select words from Collection that meet the criteria
Loop, Parse,Collection,|
  {
  ; Need to check that the Polyletter is in word
  Pattern_Word := pattern(A_LoopField)    
  plpatt := substr(Pattern(PolyLetter),1,1)

  ifInString,Pattern_Word,%plpatt% ; equal to
    {
    if(strlen(WDictionary) = 0)
      WDictionary = %A_LoopField%
    else
      WDictionary = %WDictionary%`n%A_LoopField% 
    WCount++
    GuiControl,, Found_Count,%WCount%
    }
  }
; Change | to `n so Listbox works
StringReplace,Collection,WDictionary,`n,|,All  
; Print reuslts
Gosub, List_Results 

Return

;Middle Word----------------------------
MiddleWord:
; grab words from Gui
Gui, Submit, NoHide
; get word lengths
MWLW_Len := strlen( MW_Left_Word)
MWRW_Len := strlen( MW_Right_Word)
; Add a str to correct end
UserWord = %MW_Left_Word%*
; put word into Gui for WildCard routine
GuiControl,, UserWord, %UserWord%
; go find words
Gosub, WildCard
; save Collection from WildCard routine
Left_List := Collection
; go do the other word
; Add a star to correct end
UserWord = *%MW_Right_Word%
; put word into Gui for WildCard routine
GuiControl,, UserWord, %UserWord%
; go find words
Gosub, WildCard
; save Collection from WildCard routine
Right_List := Collection

; clear WDicitonary for temp use
WDictionary :=
; Remove left_bit word to leave LB
; Remove Right_bit word to leave RB
; Add MB = LB and RB
; Check if MB is a word
WCount := 0
loop, parse, Left_List,|
  {
  ; get length of Left Bit
  tmp_len := strlen(A_LoopField) - MWLW_Len
  if (tmp_len = 0)
    continue
  stringRight, tmp_LW_end, A_LoopField, tmp_len 

  ; now check if word when combined is a good word
  Reply := 0
  Loop, parse, Right_List,|
    {
    ; combine two halves
    Middle_Word = %tmp_LW_end%%MW_Right_Word%
    if(Middle_Word = A_LoopField)
      {
      if(strlen(WDictionary) = 0)
        WDictionary = %A_LoopField%
      else
        WDictionary = %WDictionary%`n%A_LoopField% 
      WCount++
      Continue
      }      
    }
  }
; Change | to `n so Listbox works
StringReplace,Collection,WDictionary,`n,|,All

Gosub, List_Results

Return

; --------------------------------
; This runs when enter is typed whilst editing the main Edit
Search:
Gui,Submit,NoHide
; If this is pressed then assume it is cleared first
; use the individual key for other functions on the second time round

; Check if blank
if (strlen(UserWord) = 0)
  {
  GuiControl,,Message, No Word Entered
  Return
  }
else IfInString, UserWord, ?   ; Check if there is a ? in line
  goto Selected_Letter_Positions
else IfInString, UserWord, *   ; check if there is a * in line
  goto WildCard
else
  goto Anagram ; Otherwise do an anagram

Return

; --------------------------------
; Works out all the scrabble scores for the Listbox Words
; or the complete Dictionary
; Prints the word and score to file "Scrabble_Scores.txt"
;
Scrabble_Scores_List:
WCount := 0
Stop_Sign := 0
GuiControl,, SubW_Count, %WCount%

; Delete it if it exists
Ifexist, %Scrabble_Score_File%
  FileDelete, %Scrabble_Score_File%

; copy the Sdict to Colleciton and replace `n with | to make the Listbox work
if (Collection = "")
  StringReplace,Collection,SDictionary,`n,|,All
 
GuiControl,,Message, Writing Scrabble Scores to file

Loop, Parse, Collection,|
  {
  if (Stop_Sign = 1)
    break

  Word_Score := Calc_Score(A_LoopField)
  t_Str = %A_LoopField%%A_Tab%%Word_Score%`n
  FileAppend,%t_Str%,%Scrabble_Score_File% 
  WCount++
  GuiControl,, SubW_Count, %WCount%
  }
GuiControl,,Message, Finished
Return

; -----------------------------------
;Make a New Dictionary from a Word List
;Take a word list and add the pattern on the front to make a Dictionary
;
; Does not check if the word is in Dictionary already
;
Make_New_Dictionary:
Stop_Sign := 0

GuiControl,,Message, Creating Dictionary
; Delete it if it exists
Ifexist, %New_Dictionary_File%
  FileDelete, %New_Dictionary_File%
  
; Ask for the Word List file  
FileSelectFile, Word_List_File,, %A_WorkingDir%, Open a List of Words, *.txt
if Word_List_File =
  {
  MsgBox, The user pressed cancel.
  Return
  }

Word_Count := 0
; Read Word file and convert to dictionary  
Loop, Read, %Word_List_File%, %New_Dictionary_File%
  {
  if (Stop_Sign = 1)
    break

; skip any blank lines
  if (strlen(A_LoopReadLine) = 0)
    continue
; Capitalise
  StringUpper, A_Word, A_LoopReadLine

; Check if the word is in the dictionary
; Check_Word_in_SDictionary(UWord)
  Pattern_Word := pattern(A_Word)
  Dict_Word = [%Pattern_Word%]=%A_Word%
  FileAppend, %Dict_Word%`n  
  Word_Count++
  GuiControl,, SubW_Count,%Word_Count%
; GuiControl,,Message, %A_Word% Added
  }

GuiControl,,Message, %Word_Count% Words added to New_Dictionary
Return

;----------------------------------------
; Counts the number of occurances of A1, A2,...
; Writes the results to Word_Count.txt
;
Word_Pattern_Count:
Answer :=
Stop_Sign := 0

GuiControl,,Message, Counting Letters

IfExist, %WC_OutFile%
  FileDelete, %WC_OutFile%
; A to Z letters
Loop, 26
  {
  t_letter := Chr(64 + A_Index)
; add the number 1 to 7
; No more than 7 letters of one type
  Loop, 7
    {
    t_number = %A_Index%
    t_pattern = %t_letter%%t_number%
    GuiControl,,Code, %t_pattern%
    New_Word_Count := 0

    Loop, Parse, Dictionary,`n
      {
; Check if the A1 pattern is in the word
      Foundpos := RegExMatch(A_LoopField, t_pattern)
      if (Foundpos > 0 )
        New_Word_Count++
      if (Stop_Sign = 1)
        Return
      }
; if the last run through did not find a pattern match then go to next letter      
    if (New_Word_Count = 0)
      break  
    Answer = %t_letter%,%t_number%,%New_Word_Count%`n
;    Answer = %t_pattern%%New_Word_Count%`n

    FileAppend, %Answer%, %WC_OutFile%
    GuiControl,, SubW_Count, %New_Word_Count%
    }
  }
FileAppend, %Dict_Word_Count%, %WC_OutFile%  
GuiControl,,Message, Finished
Return

;Word_nr_Letters -----------------------------------
;Looks for words with set number of letters e.g A6 or B2
;
Word_nr_Letters:

InputBox, t_letter, Letter Required, Enter letter A to Z,,200,100
StringUpper, t_letter, t_letter
Foundpos := RegExMatch( t_letter, "[A-Z]")
if (Foundpos <> 1)
  {
  Msgbox Error - Must be between A to Z
  Return
  }
InputBox, t_number, Number of Letters, Enter number between 1 to 10,,200,100
;
if t_number not between 1 and 10
  {
  Msgbox Error - Must be between 1 and 10
  Return
  }
t_pattern = %t_letter%%t_number%
GuiControl,,Code, [%t_pattern%]

; Look for the Pattern in the Dictionary
Results =
Collection =
GuiControl,,Results, |
GuiControl,,Message, Checking for Words

New_Word_Count := 0
Loop, Parse, Dictionary,`n
  {
  Foundpos := RegExMatch(A_LoopField, t_pattern)
  if (Foundpos > 0 )
    {
  ; get word from line and add to Collection
  ; Find ]  
    Bracket_Posn := InStr(A_LoopField,"]") 
  ; Start of word 
    BP := Bracket_Posn + 2
  ; Get word  
    StringMid, New_Word, A_LoopField, %BP%
  
    if (Collection =)
      Collection = %New_Word%|
    else
      Collection = %Collection%%New_Word%|
    New_Word_Count++
    }
  }
GuiControl,, SubW_Count,%New_Word_Count%
GuiControl,,Results, %Collection%
GuiControl,,Message, %New_Word_Count% - Words Found with %t_number% %t_letter%s
Return

;Check Word List -----------------------------------
;Checks a list of words to see if they are in the Dictionary
;Word List should be a linear list with a newline at the end of each line
;If there are phrases then the spaces should be _ or not there
;
Check_Word_List:
; Clear all the fields
Stop_Sign := 0
Results =
Collection =
GuiControl,,Results, |
GuiControl,,Message, Checking Word List
GuiControl,, FoundW_Count,
GuiControl,, SubW_Count,
; Set up a file for saving the New Words
ifexist, %New_Words%
  FileDelete, %New_Words%

FileSelectFile, Word_List_File,, %A_WorkingDir%, Open a List of Words, *.txt
if Word_List_File =
  {
  MsgBox, The user pressed cancel.
  return
  }

New_Word_Count := 0
Existing_Word_Count := 0
; Read each line and check it is SDictionary array
Loop, Read, %Word_List_File%
  {
  StringUpper, Check_Word, A_LoopReadLine

  WFound_Flag := 0

  Existing_Word_Count++
  GuiControl,, SubW_Count,%Existing_Word_Count%  
; Check the dictionary

  if (Stop_Sign = 1)
    break

  WFound_Flag := Check_Word_in_SDictionary(Check_Word)

; Collect the words that are not in the dictionary
  if (WFound_Flag = 0)
    {
    New_Word_Count++
    GuiControl,, FoundW_Count,%New_Word_Count%

    FileAppend,%Check_Word%`n,%New_Words%
      
    if (Collection =)
      Collection = %Check_Word%|
    else
      Collection = %Collection%%Check_Word%|
    }
  }
GuiControl,,Results, |
GuiControl,,Results, %Collection%
GuiControl,,Message, Finished

Return

;Add Word to dictionary -----------------------------------
; 
Add_Dict_Word:
Gui,Submit,NoHide

; Need to sort out Dictionary name so we can append to it.
Out_File = %Words_File%
if (strlen(UserWord) = 0)
  {
  GuiControl,,Message, No word to add
  Return
  }  
Add_Word := UserWord

Upatt := Pattern(Add_Word)

GuiControl,, Code,%Upatt%

New_Word = [%Upatt%]=%Add_Word%

; Check word is in the SDictionary
WFound_Flag := Check_Word_in_SDictionary(Add_Word)

; If not in Ditionary we can write to file
if (WFound_Flag = 0)
  {
  MsgBox, 3,Add word?,Do you want to Add %Add_Word%?
  ifMsgBox, Yes
    {
    FileAppend,%New_Word%`n, %Out_File%
    GuiControl,,Message, Word written to Dictionary
    }
  else
    GuiControl,,Message, Word not written to Dictionary    
  }
else
  GuiControl,,Message, Word already in Dictionary

Return

;Change-Dict -----------------------------------
; Change to a different dictionary
;
Change_Dict:

FileSelectFile, Words_File,,%A_WorkingDir% ,Select a new Dictionary

Dict_Loaded = 0
; Words_file has the full address

Gosub, Read_Dict

; Extract the filename to display
;Splitpath, Words_File, Words_Filename
;GuiControl,, Words_File, %Words_Filename%

IniWrite,%Words_File%,Word_Manipulator.ini,Dictionary,Main_File_Name

Return

;My-Sort -----------------------------------
; Sort the Collection arrya and redisplay

My_Length_Sort:

GuiControl,,Message, Sorting Word List

;Sort, Collection, F Length_Sort D|,
if (Sorted = "Down")
  {
  Sorted := "Up"
  Sort, Collection, F Down_Sort D|,
  }
else
  {
  Sorted := "Down"
  Sort, Collection, F Up_Sort D|,    
  }

GuiControl,,Results, |
GuiControl,,Results, %Collection%

GuiControl,,Message, List Sorted

return

;Down_Sort ----------------

Down_Sort(a1, a2)
{
aa1 := strlen(a1)
aa2 := strlen(a2)
return aa1 > aa2 ? 1 : aa1 < aa2 ? -1 : 0
}

;Up_Sort ----------------

Up_Sort(a1, a2)
{
aa1 := strlen(a1)
aa2 := strlen(a2)
return aa1 > aa2 ? -1 : aa1 < aa2 ? 1 : 0
}

;My_Score_Sort -----------------------------------
; Sort the Collection array and redisplay by Scrabble Score

My_Score_Sort:
GuiControl,,Message, Sorting Word List

;Sort, Collection, F Length_Sort D|,
if (Sorted = "Down")
  {
  Sorted := "Up"
  Sort, Collection, F Scrabble_Down_Sort D|,
  }
else
  {
  Sorted := "Down"
  Sort, Collection, F Scrabble_Up_Sort D|,    
  }

GuiControl,,Results, |
GuiControl,,Results, %Collection%

GuiControl,,Message, List Sorted

return


;Scrabble_Up_Sort ----------------

Scrabble_Up_Sort(a1, a2)
{
aa1 := Calc_Score(a1)
aa2 := Calc_Score(a2)
return aa1 > aa2 ? -1 : aa1 < aa2 ? 1 : 0
}

;Scrabble_Down_Sort ----------------

Scrabble_Down_Sort(a1, a2)
{
aa1 := Calc_Score(a1)
aa2 := Calc_Score(a2)
return aa1 > aa2 ? 1 : aa1 < aa2 ? -1 : 0
}

;My_Spell_Sort -----------------------------------

My_Spell_Sort:
GuiControl,,Message, Sorting Word List

if (Sorted = "Down")
  {
  Sorted := "Up"
  Sort, Collection, D|,
  }
else
  {
  Sorted := "Down"
  Sort, Collection, R D|,    
  }

GuiControl,,Results, |
GuiControl,,Results, %Collection%

GuiControl,,Message, List Sorted

return



;Clear_Select -----------------------------------

Clear_Select:
Gui,Submit,NoHide
Selected_Letters := ""
;Letter_Selection := ""
;UserWord := ""
GuiControl,, UserWord, %UserWord%
Collection := ""
WCount := 0
SWCount := 0
WSize := 0

GuiControl,, Code,%Selected_Letters%
;GuiControl,, Letter_Selection,
GuiControl,, WSize,
GuiControl,, Score,
GuiControl,, PolyLetter,

Gosub, List_Results
Return

;Select -----------------------------------
; Letter selectionn can like A?B
; If Collection is empty then use the word length to generate a list to work on
; otherwise use the Collection already chosen
; The * is not allowed at the moment

Selected_Letter_Positions:
Gui,Submit,NoHide
; No word then return
if (strlen(UserWord) = 0)
  {
  GuiControl,,Message, No Word Entered
  Return
  }
;GuiControl,, Code,%Letter_Selection%
WCount := 0
; load word so we can find out what the instructions are
Letter_Selection := UserWord

; Forget any * entry
ifInString, Letter_Selection, *
  {
  GuiControl,, Message,* is not implemented
  ; Move the collection into WDictionary
 ; if(Collection != "")
 ;   WDictionary := Collection

 ; StarWord := Letter_Selection

  ; need to sort a length SWCount out

;  Gosub, From_Select
  Return
  }

; if there are no words already selected
; then use the length of the instruction to create a word list
; 
if (Collection = "")
  {
  WSize := strlen(Letter_Selection)
  GuiControl,, WSIze, %WSize%
  GuiControl,, Message,Using %UWL% letter words

; Reads Words of set size from Sdict into WDict
  SWCount := Create_WDictionary(WSize, "EQ")
  WCount := SWCount 
  ; copy the Wdict to Colleciton and replace `n with | to make the Listbox work
  StringReplace,Collection,WDictionary,`n,|,All
;  Gosub, List_Results
  }
;

Gosub Find_all_Words_with_Q_Mark

; count words in collection
TChar := "|"
WCount := Count_Words_in_Dictionary(Collection, TChar)

Gosub, List_Results

Return

;Find_all_Words_with_Q_Mark -----------------------------------
;

Find_all_Words_with_Q_Mark:

msgbox %Letter_Selection%

Loop, Parse, Letter_Selection
  {
; get the first letter
  Tmp_Chr := A_LoopField
; convert to ASCII code
  Chrr := Asc(Tmp_Chr)
; Check it is valid, remove the junk  
  if(Chrr < 65 or Chrr > 90)
    Continue
; save the letter position
  Posn := A_Index

  TDictionary :=  ; clear TDict
  Found := 0
; Now check the List of words
; Any letter position that is correct is kept
  Loop,Parse, Collection, |
    {
; get letter from selected position
    AAA := SubStr(A_LoopField, Posn, 1)

    if(AAA = Tmp_Chr)
      {
      ; store word for next round
      if(strlen(TDictionary) = 0)
        TDictionary = %A_LoopField%
      else  
        TDictionary = %TDictionary%|%A_LoopField%
      }
    }
  Collection := TDictionary    
  }


Return


;WordSize Equal -----------------------------------
;
WordSize_Equal:
GTLT_Flag := "EQ"
Goto WordSize

Return

;GTLT_Flag Greater than -----------------------------------
;
WordSize_Greater:
GTLT_Flag := "GT"
Goto WordSize

Return

;GTLT_Flag Less than -----------------------------------
;
WordSize_Less:
GTLT_Flag_flag := "LT"
Goto WordSize

Return

;WordSize -----------------------------------
; Creates a list of words of set length
; Either from the WSize box
; Or from the length of the current word 

WordSize:
GuiControl,, Results,|
Gui,Submit,NoHide

WDictionary :=
Stop_Sign := 0
WCount := 0

; If no WSize given then send message and crash out
if (WSize = 0 or strlen(Wsize) = 0)
    {
    GuiControl,, Message, Word length not given
    Return
    }

; If Collection is empty then collect all words of required length
if(Collection = "") ; No words stored
  {
; Reads Words of set size from Sdict into WDict
  SWCount := Create_WDictionary(WSize, GTLT_Flag)
  WCount := SWCount
  }
else ; Collection must have some words to be shortened
  {
  ; Takes the words already selected in Collection and selects them by size

  ; Print message
  if (GTLT_Flag = "EQ")
    GuiControl,, Message,Selecting %WLength% letter words
  else if (GTLT_Flag = "LT")
    GuiControl,, Message,Selecting %WLength% or less letter words
  else if (GTLT_Flag = "GT")
    GuiControl,, Message,Selecting %WLength% or more letter words

; The selection loop
  Loop, Parse,Collection,|
    {
    if(GTLT_Flag = "EQ") ; equal to
      {
;      msgbox Equal
      if(strlen(A_LoopField) = WSize)
        {
        if(strlen(WDictionary) = 0)
          WDictionary = %A_LoopField%
        else
          WDictionary = %WDictionary%`n%A_LoopField% 
        WCount++
        }
      }
    else if(GTLT_Flag = "LT") ; less than or equal
      {
      if(strlen(A_LoopField) <= WSize)
        {
        if(strlen(WDictionary) = 0)
          WDictionary = %A_LoopField%
        else
          WDictionary = %WDictionary%`n%A_LoopField% 
        WCount++
        }
      }  
    else if(GTLT_Flag = "GT") ; greater than or equal
      {
      if(strlen(A_LoopField) >= WSize)
        {
        if(strlen(WDictionary) = 0)
          WDictionary = %A_LoopField%
        else
          WDictionary = %WDictionary%`n%A_LoopField% 
        WCount++
        }
      }
    }
  }
; Change | to `n so Listbox works
StringReplace,Collection,WDictionary,`n,|,All

Gosub, List_Results

Return

;Scrabble -----------------------------------
; Make list of words of all lengths from letters provided 

Word_from_Letters:
GuiControl,, Message,Words from these Letters
GuiControl,, Results,|
Gui,Submit,NoHide

Collection :=
WCount := 0
Stop_Sign := 0
SL_UW := strlen(UserWord)
if (SL_UW = 0)
  {
  MsgBox No Word Entered
  GuiControl,, Message,No word entered
  Return
  }

StringReplace, User_Word, UserWord,*,,All
; Get the length of Dummy Word
UW_length := strlen(User_Word)

Upatt := Pattern(User_Word)

GuiControl,, Code,%Upatt%
GuiControl,, Message,Searching for words

; Look for the pattern in the dictionary
Loop,Parse,Dictionary,`n
{
DLine := A_LoopField
; Sort out the Word from the code
ifNotInString, DLine, ]
  Continue

Bracket_Posn := InStr(DLine,"]") 
DW_BP := Bracket_Posn - 2
; Dpatt is the Pattern from Dictionary Word
StringMid, Dpatt, DLine, 2, %DW_BP%

DW_BP := Bracket_Posn + 2

; Get the Dictionary Word
StringMid, D_Word, DLine, %DW_BP%

DW_Length := strlen(D_Word)
; Check length of Dictionary Word > UserWord length
; If it is then skip word as too long
if(DW_length > UW_Length)
  Continue

; Dictionary Pattern length for loop
DPL := strlen(Dpatt)//2
Found := 0
Posn := 1

; Go round this loop checking that the code in Front_Word is in our word
loop, %DPL%
  {
  ; getthe first letter and number
  StringMid, tletter, Dpatt, %Posn%, 2 

    ; get the letter
    tl := Substr(tletter, 1, 1)
    ; get the number
    tn := 1*Substr(tletter, 2, 1)
    ; find posn of the letter in other word
    tp := 1*InStr(Upatt, tl)

; see if letter is in Uword
   if (tp > 0) 
    {
    tp++
    ;  get the Upatt number
    ttn := Substr(Upatt, tp, 1)
    ; check the number is <= found number
    ; extract letter and number
    ; check the number of instances of letter
    if (tn <= ttn) 
      Found := 1
    else  
      {
      Found := 0
      break
      }
    }
  else
    {
    Found := 0  
    break
    }
  posn+=2
  }

 if (Found = 1)
  {
  if(strlen(Collection) = 0)
    Collection = %D_Word%  
  else
    Collection = %Collection%|%D_Word%
    
  WCount++
  GuiControl,, SW_Count,%WCount%
  }
}
SWCount := WCount
Gosub, List_Results

Return

;LetterInWordList -----------------------------------
; Make a list of words using all the letters in the word
; Problem Some searches do not return all words
; because P = [P1] and PP = [P2]

LetterInWordList:
GuiControl,, Message,Word
GuiControl,, Results,|
Gui,Submit,NoHide

; Clear the temp dictionary 
WDictionary :=
Star :=
Stop_Sign := 0

if (strlen(UserWord) = 0)
  {
  GuiControl,, Message,No Letters to use
  Return
  }
StringReplace, Dummy_Word, UserWord,*,,All

; Get the length of Dummy Word
DW_length := strlen(Dummy_Word)

tpatt:=Pattern(Dummy_Word)

GuiControl,, Code,%tpatt%

GuiControl,, Message,Searching for words
; look for the pattern in the dictionary
SWCount := 0

Loop,Parse,Dictionary,`n
  {
  Line := A_LoopField
  
  ifNotInString, Line, ]
    Continue
  
  Bracket_Posn := InStr(Line,"]") 
  StringMid, Front_Word, Line, 1, Bracket_Posn
  
  SL := strlen(tpatt)//2
;  msgbox %SL%
  Found := 0
  Posn := 1
  
  loop, %SL%
    {
    ; get the code pattern e.g. C = C1
    StringMid, tletter, tpatt, Posn, 1
    StringMid, tnumber, tpatt, Posn+1, 1
    ; is the letter there
    IfInString, Front_Word, %tletter%
      {
      ; get the Front_Word number for comparison
      fwposn := Instr(Front_Word, tletter)
      StringMid, fwnumber, Front_Word, fwposn+1, 1
      
;      msgbox fwnr = %fwnumber%
      
      if (tnumber <= fwnumber)
        Found++
      }
    Posn+=2
    }
  
  if (Found = SL)
    {
  ; Get the length of the front word
    Patlen := StrLen(Front_Word) + 2  
  ; As it has found one match extract the anagrams
    StringMid,Anag,Line,%Patlen%,255
    StringReplace,Anag,Anag,`,,|,All
    if(strlen(Collection) = 0)
      Collection = %Anag%  
    else
      Collection = %Collection%|%Anag%
    SWCount++
    GuiControl,, SubW_Count,%SWCount%
    }
  }

WCount := SWCount
Gosub, List_Results

Return

;Wildcard -----------------------------------

; e.g *NAY or NAY* could be any word with [A1N1Y1]
; 
; Would be nice to have *N*AY* or similar
;
Wildcard:
GuiControl,, Message,Wildcard Search
GuiControl,, Results,|
Gui,Submit,NoHide
;
GuiControl,, UserWord, %UserWord%
Collection :=
WDictionary :=
Stop_Sign := 0

; No word entered
if (UserWord = "")
  {
  GuiControl,, Message, No Word Entered
  Return
  }
StarWord := UserWord

From_Select:

TDictionary :=
Star :=
SWCount := 0
WCount := 0
Temp_Str:= 0
Star_Posn := 0

; If only * will give all words
if(StarWord = "*")
  {
;  Collection := SDictionary
  StringReplace, Collection, SDictionary,`n,|,All
  Gosub, List_Results
  Return
  }  
; Sort out how many and where the *s are
;
Len_Word := strlen(StarWord)
; Count the *s
Star_count := 0
Loop, Parse, StarWord
  {
  if A_LoopField = *
    Star_count++
  }
  
; No star
if(Star_count = 0)
  {
  GuiControl,, Message, No * in the Word
  Return
  }  

; one star
if (Star_count = 1)
  {
  Star_Posn := InStr(StarWord,"*",false,1)
  if(Star_Posn = 1)
    Star := "Left"
  else if(Star_Posn = Len_Word)
    Star := "Right"
  else if(Star_Posn > 1 and Star_Posn < Len_Word)
    {
    Left_bit := Substr(StarWord,1 ,Star_Posn-1) 
    Right_bit := Substr(StarWord, Star_Posn+1,Len_Word-Star_Posn) 
    Star := "Middle"
    }
  }
else if Star_count = 2 ; Two stars
  {
  Star_Posn := InStr(StarWord,"*",false,1)
  if(Star_Posn = 1)
    {
    Star_Posn := InStr(StarWord,"*",false,2)
    if(Star_Posn = Len_Word)
      {
      Mid_bit := Substr(StarWord, 2, Len_Word-2)
      Star := "Ends"
      }
    else
      {
      GuiControl,, Message, Two stars should be at the ends
      Return
      }  
    }
  }
else ; More than two
  {
  GuiControl,, Message, No more than two * allowed
  Return
  }

;Msgbox %StarWord%`n%Star_count%`n%Star_Posn%`n%Star%
;Msgbox %Left_bit%`n%Right_bit%
;Msgbox Mid_bit-%Mid_bit%

; remove *s from word
StringReplace, Dummy_Word, StarWord,*,,All
; Get the length of Dummy Word
DW_length := strlen(Dummy_Word)
;msgbox 1-%Star%-%Dummy_Word%
tpatt:=Pattern(Dummy_Word)

GuiControl,, Code,%tpatt%

GuiControl,, Message, Collecting likely words

; If WDictionary is empty then fill it up
if(WDictionary = "")
  {
  ; look for the pattern in the Dictionary
  ; Get all words with the pattern into SDictionary
  Loop,Parse,Dictionary,`n
    {
    Line := A_LoopField
    ; Clear any junk lines
;    ifNotInString, Line, ]
;      Continue
    ; Extract word
    Bracket_Posn := InStr(Line,"]") 
    StringMid, Front_Word, Line, 1, Bracket_Posn
    
    SL := strlen(tpatt)//2
    Found := 0
    Posn := 1
    
    loop, %SL%
      {
      StringMid, tletter, tpatt, Posn, 1
    
      IfInString, Front_Word, %tletter%
        Found++
      Posn+=2
      }
    
    if (Found = SL)
      {
    ; Get the length of the front word
        Patlen := StrLen(Front_Word) + 2  
    ; As it has found one match extract the anagrams
    
        StringMid,Anag,Line,%Patlen%,255
    ; Change , to | as ther coulD be more than one Anagram on a line
        StringReplace,Anag,Anag,`,,|,All
    ; Avoid a leading | add them into WDictionary
    
      if(strlen(WDictionary) = 0)
        WDictionary = %Anag%  
      else
        WDictionary = %WDictionary%|%Anag%
    
      if(Stop_Sign = 1)
        {
        GuiControl,, Message, User stopped operation
        Return
        }
    
      SWCount++
      GuiControl,, SubW_Count,%SWCount%
      }
    }
  }

; MsgBox %WDictionary%

; Sort out the Word length if required
if(WSize > 0)
  {
  WCount := 0
  Loop, Parse, WDictionary,|
    {
    if(strlen(A_LoopField) = Wsize)
      {
      WCount++
; If Tdict is empty don't put the | in
      if(strlen(TDictionary) = 0)
        TDictionary = %A_LoopField%
      else
        TDictionary = %TDictionary%|%A_LoopField%
      GuiControl,, FoundW_Count,%WCount%      
      }
    }
  }  
else ; Stuff the whole of WDict into TDict
  {
  WCount := SWCount
  TDictionary := WDictionary
  }

; MsgBox %TDictionary%

GuiControl,, Message, Selecting words
Gui,Submit,NoHide

Sort,TDictionary,D|
; Post TDict as a starter list
GuiControl,, Results,%TDictionary%

; Loop through TDictionary to see what matches
; remove any blanks and put them into Collection
; Dummy_Word is what we need

WCount := 0

Collection :=

L_Len := strlen(Left_bit)
R_len := strlen(Right_bit)

;msgbox %Star%-%Dummy_Word%

Loop, Parse,TDictionary,|
{
Found := 0
; Too short so move on
if (A_LoopField < DW_Length)
  Continue

if(Stop_Sign = 1)
  {
  GuiControl,, Message, User stopped operation
  Return
  }

if(Star = "Middle")
  {
  StringLeft, Temp_Str, A_LoopField, L_Len
  if (Temp_str = Left_bit)
    {
    StringRight, Temp_Str, A_LoopField, R_Len
    if(Temp_str = Right_bit)
      Found := 1
    }
  }
else if(Star = "Right") ; * at the end
  {
  ; Get the left letters to check against the dummy_word
  StringLeft, Temp_Str, A_LoopField, DW_length
  if(Temp_Str = Dummy_Word)
    Found := 1
  }  
else if (Star = "Left") ; * at the start
  {
  StringRight, Temp_Str, A_LoopField, DW_length ; last position
  if(Temp_Str = Dummy_Word)
  Found := 1
  }
else if (Star = "Ends")
  {
  if(InStr(A_LoopField, Dummy_Word,false,1) <> 0)
    Found := 1
  }

else
  Found := 0

if Found
  {
  if (strlen(Collection) = 0)
    Collection = %A_LoopField%
  else
    Collection = %Collection%|%A_LoopField%
  WCount++
  GuiControl,,FoundW_Count,%WCount%
  }
}
Gosub, List_Results
Return

;-----------------------------------

Anagram:
GuiControl,, Message,Searching
GuiControl,, Results,|
Gui,Submit,NoHide
Collection :=
SWCount := 0
Stop_Sign := 0

if (strlen(UserWord) = 0)
  {
  GuiControl,, Message, No Word Entered
  Return
  }
tpatt:=Pattern(UserWord)

GuiControl,, Code,%tpatt%

tpatt=[%Tpatt%]

patlen:= StrLen(Tpatt)
Found = 0

; search  for the letter pattern in the first part of line
; then if there is a match load the word that matches
; 
Loop, Parse, Dictionary,`n
  {
  Line := A_LoopField
  
  StringMid,Patt,Line,1,Patlen
  
  if (Patt = tpatt)
    Found = 1
  else
    {
    if (Found = 1)
      break
    else
      Continue  
    }
  
  if (Found = 1)
    {
    PL := Patlen + 2
    StringMid,Anag,Line,%PL%,255
  
    StringReplace,Anag,Anag,`,,|,All
  
    if(strlen(Collection) = 0)
      Collection = %Anag%  
    else
      Collection = %Collection%|%Anag%
    SWCount++
    GuiControl,, FoundW_Count,%SWCount%
    }
  }
WCount := SWCount

Gosub, List_Results

GuiControl,, Code,
GuiControl,, Message, Finished
Gui,Submit,NoHide
Return

;My_ListBox -----------------------------------
; puts the word clicked into the top box

My_ListBox:
Stop_Sign := 0

If A_GuiControlEvent = DoubleClick
  {
  GuiControlGet, Results  ; Retrieve the ListBox's current selection.
  t_pattern := pattern(Results)
  GuiControl,,Code, %t_pattern%
  S_Total := Calc_Score(Results)
  GuiControl,, UserWord, %Results%
  }
If A_GuiControlEvent = Normal
  {
  GuiControlGet, Results  ; Retrieve the ListBox's current selection.
  t_pattern := pattern(Results)
  GuiControl,,Code, %t_pattern%
  S_Total := Calc_Score(Results)
  GuiControl,, Score, %S_Total%
  }

Return


;-----------------------------------
; Make list of words replacing the ? as required
;
QMark:
GuiControl,, Message,Word Lister
; Clear Results window
GuiControl,, Results,|
Gui,Submit,NoHide

Collection :=
WCount := 0
SWCount := 0
QCount := 0
Stop_Sign := 0
;xTimer := A_Now

if (WSize > 0)
  UWL := WSize
else   
  UWL := strlen(UserWord)

if (UWL = 0)
  {
  GuiControl,, Message,No word entered
  Return
  }

if(InStr(UserWord, "?") = 0)
  {
  GuiControl,, Message,No ? Mark in word
  Return
  }

; Count the number of ? marks
; It is very slow if more than 3
Loop, Parse, UserWord
  {
  if(A_LoopField = "?")
    QCount++  
  }

; Method
; Count ? marks to decide what to do
; Select words of correct length
; Is there a first character
; if so go that way
; if ? initially then go a different way


; Clear messages
GuiControl,, FoundW_Count,%FCount% 
GuiControl,, SubW_Count,%FCount%

; Read all words that are UWL long into WDictionary
SWCount := Create_WDictionary(UWL, "EQ")

GuiControl,, SubW_Count,%SWCount%

GuiControl,, Message, Replacing the ? marks

; Replace all ? marks
Replace_Q_mark(Collection, UserWord)

if(Stop_Sign = 1)
  {
  GuiControl,, Message, User stopped operation
  Return
  }
  
Char := "|"
WCount := Count_Words_in_Dictionary(Collection, Char)

Gosub, List_Results

Return

;-----------------------------------
; Save the list of words to Saved_Words.txt
Save:

if (strlen(Collection) = 0)
  {
  GuiControl,,Message, No Words to Save
  Return
  }

IfExist, %Save_File%
  FileDelete, %Save_File%

StringReplace, SCollection, Collection,|,`n,All
FileAppend, %SCollection%, %Save_File%

Return

;Read_Dict -----------------------------------
; Reads all Words.db into Dictionary
; Reads the words from Dictionary into SDictionary
; Should check that Dictionary is correct format

Read_Dict:
Critical ; Stops anything else happening whilst loading
GuiControl,, Message, Loading Dictionary

Read_Dictionary(Words_File)
; Now extract the words - speeds up searches 
Create_SDictionary()

; indicates the Dictionary is loaded.
Dict_Loaded := 1
Critical, Off

; Extract the filename to display
Splitpath, Words_File, Words_Filename
GuiControl,, Words_File, %Words_Filename%

Return


;Breakout -----------------------------------
; Used to set a flag to stop processing current command

Breakout:
GuiControl,, Message,Break Requested
Stop_Sign := 1

Gui,Submit,NoHide
Return

;List_Results -----------------------------------
; Puts the found results into the Listview

List_Results:
{

Stop_Sign := 0
GuiControl,, Results,|
GuiControl,, SubW_Count,%SWCount%
GuiControl,, FoundW_Count,%WCount%

GuiControl,, Message, Words Found - sorting
Gui,Submit,NoHide

Sort, Collection, D|
GuiControl,, Results, %Collection%

if (WCount = 0)
  GuiControl,, Message, No words Found
else
  GuiControl,, Message, Finished

;GuiControl,, Code,
Gui,Submit,NoHide

Return
}

; Permutate -------------------------------
; creates a list of permutations from word

Permutate(set,delimeter="",trim="", presc="")
{ ; function by [VxE]
  ; returns a newline-seperated list of all
  ; unique permutations of the input set.
  ; set = word to be worked on
  ; delimiter can be used to provide a list of words
  ; trim is for trimming characters out of the word
  ; presc = use unknown
  ; Note that the length of the list will be (N!)
   d := SubStr(delimeter,1,1)
   StringSplit, m, set, %d%, %trim%
   IfEqual, m0, 1, return m1 d presc
   Loop %m0%
   {
      remains := m1
      Loop % m0-2
         x := A_Index + 1, remains .= d m%x%
      list .= Permutate(remains, d, trim, m%m0% d presc)"`n"
      mx := m1
      Loop % m0-1
         x := A_Index + 1, m%A_Index% := m%x%
      m%m0% := mx
   }
   return substr(list, 1, -1)
}

;============MOBILE PHONE FUNCTIONS=====================================

; Mobile phone Gosubs from Menu selection

; Get_Number_from_Word
; - Shows the number typed for the word
; Get_Words_from_Number
; - Shows a list of numbers from a number
; Get_KeyPress_for_a_Word
; - Shows the key presses required for word
; Get_Words_From_Keypress
; - Shows the words that meet the keypresses

; Mobile phone functions
;
; Convert_Number_to_Word
; - Looks up number and finds words
;
; Load_Mobile_Dictionary_into_Array
; - As title and calls
;
; Load_Mobile_Word_From_File
; - Loads file into array
;
; Get_Mobile_Number_for_Word
; -
;
; Make_Mobile_Word_File
; -
;
; Mobile_Word_Score
; - 

; --------------------------------
; This Gosub returns the number typed for a word
; on a mobile e.g. PETER = 73837
; 
Get_Number_from_Word:
Gui,Submit,NoHide
; Check if word is blank
if (strlen(UserWord) = 0)
  {
  GuiControl,,Message, No Word Entered
  Return
  }

M_Word := Get_Mobile_Number_for_Word(UserWord)

GuiControl,,Code, %M_Word%

Return

; --------------------------------------------------------------------------
; Converts a number into words
; 26533223 should give 
Get_Words_from_Number:

Gui,Submit,NoHide
GuiControl,, Results,|
str_explanation =
(
Enter number, digits should be between 2 and 9
)
Inputbox, Our_Mobile_Number, Mobile Number, %str_explanation%,,,100
; Look up numbers in Dictionary
; Put word into Collection
; Display Word

MN_Len = strlen(Our_Mobile_Number)
if (MN_Len = 0)
  {
  GuiControl,,Message, No Word Entered
  Return
  }

; Load Dictionary if not loaded
If(Mob_Dict_Loaded = 0)
  {
  Load_Mobile_Dictionary_into_Array()
  }

WCount := Convert_Number_to_Word(Our_Mobile_Number)

Gosub, List_Results

Return

; --------------------------------
; This function returns the number of times each
; key 2 to 9 is pressed for a word
; e.g. PETER would return 02000210
; i.e 0 key 2, 2 key 3 ....
Get_KeyPress_for_a_Word:

Gui,Submit,NoHide

; Check if word is blank
if (strlen(UserWord) = 0)
  {
  GuiControl,,Message, No Word Entered
  Return
  }

M_Word := Mobile_Word_Score(UserWord)

GuiControl,,Code, %M_Word%

Return

; --------------------------------
; This should convert a mobile phone entry of
; keypresses to words.
; so 00121001 keypresses for keys 2,3,4,5,6,7,8,9
;
Get_Words_From_Keypress:

Gui,Submit,NoHide
GuiControl,, Results,|
Collection :=
str_Instructions =
(
Enter 8 digit number with Zeros
e.g. Hello would be 01121000
abc = 0, def = 1, ghi = 1
jkl = 2, mno = 0, pqrs = 0
tuv = 0, wxyz = 0
)
;InputBox, OutputVar [, Title, Prompt, HIDE, Width, Height, X, Y, Font, Timeout, Default]
Inputbox, Our_Mobile_Number, Enter Mobile Number, %str_Instructions%,,,180

if (strlen(Our_Mobile_Number) <> 8)
  {
  GuiControl,,Message, Eight Characters required
  Return
  }

GuiControl,,Code, %Our_Mobile_Number%
GuiControl,,Message, Finding Words

If(Mob_Dict_Loaded = 0)
  {
  Load_Mobile_Dictionary_into_Array()
  }
  
GuiControl,,Message, Searching for match

WCount := 0

Loop, %MWord_max%
  {
  M_tmp := MScore%A_Index%
;msgbox %M_tmp%
;GuiControl,, FoundW_Count, %A_index%

  if(M_tmp = Our_Mobile_Number)
    {
    MW_tmp := MWord%A_Index%
    GuiControl,, Code, %MW_tmp%
    if WCount = 0
      Collection = %MW_tmp%
    else
      Collection = %Collection%|%MW_tmp%    
    WCount++
    }
  }
if (WCount = 0)
  GuiControl,, Message, No Words Found
else
  GuiControl,, Message, Words Found

Gosub, List_Results 
  
Return

; --------------------------------
; Makes a new dictionary from the currently loaded SDictionary
;
Create_Mobile_Dictionary:

Make_Mobile_Word_File(Mobile_Dict_File)

Mob_Dict_Loaded := 0

Return

; ---------------------------------------
; Initialise variables from ini files
Initialise_Variables:

; Main Dictionary
IniRead,Words_File,Word_Manipulator.ini,Dictionary,Main_File_Name
; Check if the main Dictionary exists
IfNotExist, %Words_File%
  {
  FileSelectFile, Words_File,,,Select Dictionary File 
  IfNotExist, %Words_File%
    {
    GuiControl,,Message, No Dictionary file
    Exitapp
    }
; save it to the ini file
  IniWrite,%Words_File%,Word_Manipulator.ini,Dictionary,Main_File_Name
;IniWrite,"Words.db",Word_Manipulator.ini,Dictionary,Main_File_Name
  }

; On Line Dictionary URL
IniRead,On_Line_Dictionary,Word_Manipulator.ini,Dictionary,On_Line_Dictionary_Name, %A_Space%
; Set Default On Line Dictionary, if none is in the ini file
if strlen(On_Line_Dictionary) = 0
  {
  On_Line_Dictionary := "http://www.yourdictionary.com"
  IniWrite,%On_Line_Dictionary%,Word_Manipulator.ini,Dictionary,On_Line_Dictionary_Name
  }

; File for Scrabble Scores List
IniRead,Scrabble_Scores_File,Word_Manipulator.ini,Dictionary,Scrabble_Scores_File_Name, %A_Space%
; Set Default On Scrabble Scores List File, if none is in the ini file
if strlen(Scrabble_Score_File) = 0
  {
  Scrabble_Score_File := "Scrabble_Scores.txt"
  IniWrite,%Scrabble_Score_File%,Word_Manipulator.ini,Dictionary,Scrabble_Scores_File_Name
  }

; New Dictionary File
IniRead,New_Dictionary_File,Word_Manipulator.ini,Dictionary,New_Dictionary_File_Name, %A_Space%
; Set Default On Line Dictionary, if none is in the ini file
if strlen(New_Dictionary_File) = 0
  {
  New_Dictionary_File := "New_Dictionary.txt"
  IniWrite,%New_Dictionary_File%,Word_Manipulator.ini,Dictionary,New_Dictionary_File_Name
  }

; Word Count File
IniRead,WC_OutFile,Word_Manipulator.ini,Dictionary,Word_Count_File_Name, %A_Space%
; Set Default On Line Dictionary, if none is in the ini file
if strlen(WC_OutFile) = 0
  {
  WC_OutFile := "Word_Count.txt"
  IniWrite,%WC_OutFile%,Word_Manipulator.ini,Dictionary,Word_Count_File_Name
  }

; Mobile Phone File
IniRead,Mobile_Dict_File,Word_Manipulator.ini,Dictionary,Mobile_Phone_Words_List_File, %A_Space%
; Set Default On Line Dictionary, if none is in the ini file
if strlen(Save_File) = 0
  {
  Mobile_Dict_File := "Mobile_Phone_Word_List.txt"
  IniWrite,%Mobile_Dict_File%,Word_Manipulator.ini,Dictionary,Mobile_Phone_Words_List_File
  }

; Saved Words File
IniRead,Save_File,Word_Manipulator.ini,Dictionary,Save_Words_File_Name, %A_Space%
; Set Default On Line Dictionary, if none is in the ini file
if strlen(Save_File) = 0
  {
  Save_File := "Saved_Words.txt"
  IniWrite,%Save_File%,Word_Manipulator.ini,Dictionary,Save_Words_File_Name
  }

; New Words File
IniRead,New_Words,Word_Manipulator.ini,Dictionary,New_Words_File_Name, %A_Space%
; Set Default On Line Dictionary, if none is in the ini file
if strlen(New_Words) = 0
  {
  New_Words := "New_Words_not_in_Dictionary.txt"
  IniWrite,%New_Words%,Word_Manipulator.ini,Dictionary,New_Words_File_Name
  }

Return


;Help -----------------------------------
; Simple Help function

Help:
Hlp_str =
(
Find Word - finds words to match, uses * or ?
Anagram - Finds all Anagrams from the letters entered
Wildcard - Put a * at start or end of word and find all words that match
Letter Positions - Put a ? in place of unknown letter
FROM these letters - Finds all words using these letters
WITH these letters - Finds all words that include these letters in
Word Length - Set the word length
  = - Words equal to length entered
 >= - Words greater than or equal to length entered
 <= - Words less than or equal length
SORT by Length - Sorts by word length, click again to invert the sort order
SORT by Score - Sorts by Scrabble score, click again to invert the sort order
BREAK - flags a break in the current command. Will eventually safely stop
CLEAR - clears the entry fields
SAVE - saves the answers in Saved_work.txt
PolyWord - Enter all letters in main edit box, and the centre letter in this box
MiddleWord - e.g. PAPER - BACK - PACK
Word Chain - Makes a chain between words 
)

MsgBox,,Word Manipulator ,%Hlp_Str%

Return

;About----------------------------

About:

About_str = Version - %Version%
MsgBox,,About Anagram Program,%About_Str%

Return

;-----------------------------------
; Improvements
; Phrases of set letters e.g. Alice in wonderland would be 5,2,10
; Add - Permutation list 
;
; Program information
; Dictionary is taken from Words.db from Internet
; Dictioanry Format
; [A1B1C1]=CAB,ABC
; Various strings used in program
; Dictionary has the Pattern and Words as a lump
; SDictionary has the words extracted from Dictionary as working array, `n delimited
; WDictionary is array of words found that meet first part of criteria
; TDictionary is a working list
; Collection is the store for words that fit the full criteria
; 
;------VERSIONS------------------------------------
; Version 6f - addedd dictionary addition
; Version 6g - Add Menu commands
; Verison 6h - Correct errors and added some messages during commands, reviewed the front end
; Version 6m - Added mobile phone count system for fun
; Version 6n - More mobile phone functions
; Version 6p - Solve the PolyWord type of puzzle
; Version 6q - Solves middle word puzzle and revamp of mobile code
; Version 6r - Added on line look up for word 
; Version 6s - Added Palindromes, Backwords 
