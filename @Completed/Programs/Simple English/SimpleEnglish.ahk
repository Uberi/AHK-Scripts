#NoEnv
SendMode Input
SetWorkingDir %A_ScriptDir%

NounListPath = %A_ScriptDir%\Nouns.txt
VerbListPath = %A_ScriptDir%\Verbs.txt
AdjectiveListPath = %A_ScriptDir%\Adjectives.txt

InputBox, NormText, Input, Please Enter Normal English,, 400, 200
If ErrorLevel = 1
  ExitApp

FileRead, NounList, %NounListPath%
FileRead, VerbList, %VerbListPath%
FileRead, AdjectiveList, %AdjectiveListPath%
Loop, Parse, NormText, .
{
 Loop, Parse, NormText, %A_Space%
 {
  NotKnown = 0
  If RegExMatch(NounList, "im)^" . A_LoopField . "$", TempTextNouns)
  {
   TempTextVerbs = 
   TempTextAdjectives = 
  }
  Else If RegExMatch(VerbList, "im)^" . A_LoopField . "$", TempTextVerbs)
   TempTextAdjectives = 
  Else If Not RegExMatch(AdjectiveList, "im)^" . A_LoopField . "$", TempTextAdjectives)
   TextOther = %TextOther% %A_LoopField%

  TextNouns = %TextNouns% %TempTextNouns%
  TextVerbs = %TextVerbs% %TempTextVerbs%
  TextAdjectives = %TextAdjectives% %TempTextAdjectives%

  StringReplace, TextNouns, TextNouns, %A_Space%, `,, All
  StringReplace, TextVerbs, TextVerbs, %A_Space%, `,, All
  StringReplace, TextAdjectives, TextAdjectives, %A_Space%, `,, All
  StringReplace, TextOther, TextOther, %A_Space%, `,, All
 }
 TempEnglish = %TextNouns%`;%TextVerbs%`;%TextAdjectives%`;%TextOther%
}
SimpleEnglish = %SimpleEnglish%%TempEnglish%.
MsgBox % SimpleEnglish