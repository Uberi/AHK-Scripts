#SingleInstance, Force
#Include, Rini.ahk

RIni_Read("Config", "Config.ini")
Secs := RIni_GetSections("Config", "|")
Gui, Add, Tab, vTabbing w300 h600, %Secs%
If InStr(Secs, "|")
{
   Loop, Parse, Secs, |
   {
      KeyNum := A_Index
      Section := A_LoopField
      Gui, Tab, %A_Index%
      Keys := RIni_GetSectionKeys("Config",Section)
      Loop, Parse, Keys, `,
      {
         IniRead, Val, Config.ini, %Section%, %A_LoopField%
         Gui, Add, Text,, %A_LoopField%
         If (!Val || Val = 1)
         {
            Gui, Add, CheckBox, v%Section%_%A_LoopField% Checked%Val%
            ConHeight%KeyNum% += 38
         }
         Else 
         {
            Gui, Add, Edit, v%Section%_%A_LoopField%, %Val%
            ConHeight%KeyNum% += 45
         }
      }
      ConHeight .= ConHeight%KeyNum% "`n"
   }
   Sort, ConHeight, N R
   ConHeight := SubStr(ConHeight, 1, InStr(ConHeight, "`n") - 1)
}
Else 
{
   Section := Secs
   Gui, Tab, 1
   Keys := RIni_GetSectionKeys("Config",Section)
   Loop, Parse, Keys, `,
   {
      IniRead, Val, Config.ini, %Section%, %A_LoopField%
      Gui, Add, Text,, %A_LoopField%
      If (!Val || Val = 1)
         Gui, Add, CheckBox, v%Section%_%A_LoopField% Checked%Val%
      Else 
         Gui, Add, Edit, v%Section%_%A_LoopField%, %Val%
   }
}
Gui, Tab
Gui, Add, Button, gSubmit y+50 xm, Save Changes
GuiControl, Move, Tabbing, % "H" ConHeight + 35
Gui, Show,, Ini Editor
Return

Submit:
Gui, Submit
If InStr(Secs, "|")
{
   Loop, Parse, Secs, |
   {
      Section := A_LoopField
      Keys := RIni_GetSectionKeys("Config",Section)
      Loop, Parse, Keys, `,
         IniWrite, % %Section%_%A_LoopField%, Config.ini, %Section%, %A_LoopField%
   }
}
Else 
{
   Section := Secs
   Gui, Tab, 1
   Keys := RIni_GetSectionKeys("Config",Section)
   Loop, Parse, Keys, `,
      IniWrite, % %Section%_%A_LoopField%, Config.ini, %Section%, %A_LoopField%
}
ExitApp