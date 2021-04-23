#NoEnv

#Include C:\Users\anthony\My Dropbox\Scripts\@Completed\Functions And Scriptlets\Unit Test Framework.ahk
#Include %A_ScriptDir%\HTTPQuery.ahk

ScriptName = Basic WebServer
TestList = 
( LTrim Comments
RequestGETColdStart
Wait
RequestGETWarmStart
Wait
RequestPOST
Wait
PageGenerationColdStart
Wait
PageGenerationWarmStart
Wait
DirectScriptOutputColdStart
Wait
DirectScriptOutputWarmStart
Wait
URLDecoding
Wait
URLRewriting
)

MainPageString = Things to do today
ScriptPageString = You logged in with the following

RunUnitTests(TestList)

RequestGETColdStart()
{
 global MainPageString
 global httpQueryOps
 global httpQueryHeader
 httpQueryOps = storeHeader
 StartTimer()
 httpQuery(Result,"http://127.0.0.1/")
 TotalTime := Round(StopTimer(),1)
 If (InStr(httpQueryHeader,"200 OK") && InStr(Result,MainPageString))
  Return, "1Request took " . TotalTime . " milliseconds"
 Return, "0Request took " . TotalTime . " milliseconds"
}

RequestGETWarmStart()
{
 Return, RequestGETColdStart()
}

RequestPOST()
{
 global MainPageString
 global httpQueryOps
 global httpQueryHeader
 TestString = abc|def`nghi123
 httpQueryOps = storeHeader
 Start()
 httpQuery(Result,"http://127.0.0.1/",TestString)
 TotalTime := Round(StopTimer(),1)
 If (InStr(httpQueryHeader,"200 OK") && InStr(Result,MainPageString))
  Return, "1Request took " . TotalTime . " milliseconds"
 Return, "0Request took " . TotalTime . " milliseconds"
}

PageGenerationColdStart()
{
 global ScriptPageString
 global httpQueryOps
 global httpQueryHeader
 httpQueryOps = storeHeader
 StartTimer()
 httpQuery(Result,"http://127.0.0.1/test/submit.html")
 TotalTime := Round(StopTimer(),1)
 If (InStr(httpQueryHeader,"200 OK") && InStr(Result,ScriptPageString))
  Return, "1Request took " . TotalTime . " milliseconds"
 Return, "0Request took " . TotalTime . " milliseconds"
}

PageGenerationWarmStart()
{
 Return, PageGenerationColdStart()
}

DirectScriptOutputColdStart()
{
 global ScriptPageString
 global httpQueryOps
 global httpQueryHeader
 httpQueryOps = storeHeader
 StartTimer()
 httpQuery(Result,"http://127.0.0.1/scripts/script.ahk")
 TotalTime := Round(StopTimer(),1)
 If (InStr(httpQueryHeader,"200 OK") && InStr(Result,ScriptPageString))
  Return, "1Request took " . TotalTime . " milliseconds"
 Return, "0Request took " . TotalTime . " milliseconds"
}

DirectScriptOutputWarmStart()
{
 Return, DirectScriptOutputColdStart()
}

URLDecoding()
{
 global MainPageString
 global httpQueryOpsw
 global httpQueryHeader
 httpQueryOps = storeHeader
 httpQuery(Result,"http://127.0.0.1/i%6ed%65x.htm%6c") ;should decode to "index.html"
 If InStr(httpQueryHeader,"200 OK" && InStr(Result,MainPageString))
  Return, 1
}

URLRewriting()
{
 global ScriptPageString
 global httpQueryOpsw
 global httpQueryHeader
 httpQueryOps = storeHeader
 httpQuery(Result,"http://127.0.0.1/wiki/script.ahk")
 If InStr(httpQueryHeader,"200 OK" && InStr(Result,ScriptPageString) && InStr(Result,"#Include"))
  Return, 1
}

Init()
{
 DetectHiddenWindows, On
 SetTitleMatchMode, 2
 IfWinNotExist, Simple Server ahk_class AutoHotkey
 {
  Run, "%A_ScriptDir%\..\Simple Server.ahk"
  Sleep, 1000
 }
}

CleanUp()
{
 Send, !{Esc}
 WinWait, Confirm Exit ahk_class #32770,, 2
 ControlSend, Button1, {Enter}
}

Wait()
{
 Sleep, 100
}