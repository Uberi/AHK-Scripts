#NoEnv

#Include %A_ScriptDir%\..\..\Resources\SupportLib.ahk

VarList = User,Pass
GetVars(VarList)
GetPostData(PostData)
WebPage = <p>you logged in with the following credentials:<br><br>Username: %User%<br>Password: %Pass%<br><br>the following data was received: <blockquote>&quot;%PostData%&quot;</blockquote>The remote address is: %IPAddress%</p>
;FileName = %A_ScriptDir%\Test.png
;FileRead, WebPage, %FileName%
;FileGetSize, PageLen, %FileName%
;Header = HTTP/1.0 200 OK`r`nContent-Type: text/html`r`nContent-Length: %PageLen%`r`n`r`n
Header = text/html
Return

StartUp()
{
 ToolTip, Started Script: %A_ScriptName%, 0, 0
}