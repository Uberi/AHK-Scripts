#SingleInstance force
#NoEnv
SetBatchLines, -1

Gui, Add, Text,,Search:
Gui, Add, Edit, w400 vA_SearchTerm gSearch
Gui, Add, ListView, grid r20 w400 vLV1 Hidden, FileName
Gui, Add, ListView, grid r20 w400 vLV2 xp yp, FileName
Loop, %A_WinDir%\*.*
  LV_Add("",A_LoopFileName)
LV_ModifyCol()

Gui, Show
return
GuiClose:
ExitApp

Search:
Gui, Submit, NoHide
If (A_SearchTerm != "")
{
 Gui, ListView, LV1
 LV_Delete()
 Gui, ListView, LV2
 Loop,% LV_GetCount()
 {
  LV_GetText(RetrievedText, A_Index)
  If InStr(RetrievedText, A_SearchTerm)
  {
   Gui, ListView, LV1
   LV_Add("",RetrievedText)
   Gui, ListView, LV2
  }
 }
 GuiControl, Hide, LV2
 GuiControl, Show, LV1
}
Else
{
 GuiControl, Hide, LV1
 GuiControl, Show, LV2
}
return