;AHK v1
#NoEnv

RunUnitTests(TestList)
{
 global ScriptName
 Init()
 Gui, Font, s12 Bold, Arial
 Gui, Add, Text, x2 y0 w510 h20 +Center, Unit Test Results:
 Gui, Font, s8 Norm
 Gui, Add, ListView, x2 y20 w510 h320, Index|Test Name|Result|Additional Info
 Gui, Font, s10
 Gui, Add, Text, x2 y350 w50 h20, Script:
 Gui, Font, s8 Norm
 Gui, Add, Edit, x52 y350 w460 h20 ReadOnly, %ScriptName%
 Gui, Font, s10
 Gui, Add, Button, x2 y380 w260 h30 gCopyReport Default, Copy To Clipboard
 Gui, Add, Button, x262 y380 w250 h30 gSaveReport, Save To File
 GuiControl, Focus, Button1
 Index := 0
 FailAmount := 0
 Loop, Parse, TestList, `n, `r
 {
  If (A_LoopField = "")
   Continue
  If !IsFunc(A_LoopField)
   Continue
  If (A_LoopField = "Wait")
  {
   Wait()
   Continue
  }
  Index ++
  ExtraInfo := %A_LoopField%()
  TestStatus := (SubStr(ExtraInfo,1,1) ? "Pass" : "Fail")
  ExtraInfo := SubStr(ExtraInfo,2)
  If (ExtraInfo = "")
   ExtraInfo := "None"
  LV_Add("",A_Index,A_LoopField,TestStatus,ExtraInfo)
 }
 CleanUp()
 Loop, 4
  LV_ModifyCol(A_Index,"AutoHdr")
 Gui, Show, w515 h410, Unit Test
 Return

 GuiClose:
 ExitApp

 CopyReport:
 GenerateReport(TestReport)
 Gui, Destroy
 Clipboard := TestReport
 MsgBox, 64, Copied, Report has been copied to the clipboard.
 ExitApp

 SaveReport:
 Gui, Hide
 GenerateReport(TestReport)
 FileSelectFile, FileName, S18, Report.txt, Please Select A Path To Save The Report To:, *.txt
 FileDelete, %FileName%
 FileAppend, %TestReport%, %FileName%
 MsgBox, 64, Saved, Report has been saved to the following file:`n`n"%FileName%"
 ExitApp
}

GenerateReport(ByRef TestReport)
{
 global ScriptName
 TestReport := "", PassAmount := 0, FailAmount := 0
 Index := LV_GetCount()
 Loop, %Index%
 {
  LV_GetText(Temp1,A_Index,2)
  LV_GetText(Temp2,A_Index,3)
  LV_GetText(Temp3,A_Index,4)
  If (Temp2 = "Pass")
   PassList .= "`r`n" . Temp1, PassAmount ++
  Else
   FailList .= "`r`n" . Temp1, FailAmount ++
  TestReport .= "`r`n" . Temp1 . A_Tab . A_Tab . A_Tab . Temp2 . ((Temp3 <> "None") ? " (" . Temp3 . ")" : "")
 }
 TestReport := "Tested """ . ScriptName . """ with " . Index . " test(s):`r`n" . TestReport . "`r`n`r`n" . FailAmount . " test(s) failed:`r`n" . FailList . "`r`n`r`n" . PassAmount . " test(s) passed:`r`n" . PassList
}