;Weather tool from google api v1.0
;By bekihito
SetBatchLines, -1
#SingleInstance, Force
#NoEnv
#Include %A_ScriptDir%\lib\Xpath.ahk
SetWorkingDir %A_ScriptDir%
;reading the start location from ini file or taking defaults
IniRead ,place, location.ini, locat, place,Zagreb   
IniRead ,cntr, location.ini, locat, cntr, Hr
IniRead, Xwin, location.ini, position,Xwin
IniRead, Ywin, location.ini, position,Ywin
IniRead, trans, location.ini, position,trans,255
;tray menu
Menu,Tray, nostandard
Menu,Tray, Add, Change Location, Location
Menu,Tray, Add, Update weather, Update
Menu,Tray, Add, About,  About
Menu,Tray, Add
Menu,Tray, Add, Exit, GuiClose
;window menu
Menu,Bar, Add, Change Location, Location
Menu,Bar, Add, Update weather, Update
Menu,Bar, Add, About,  About
Menu,Bar, Add, Exit, GuiClose
Menu,Bar, Color, Gray
Gosub ,download
;changing the transparency, always on top, clickthrough
!1::
IfWinExist,Weather
{
trans :=255
Gui, Submit,Nohide
WinSet ,Transparent ,%trans%, Weathertool
}
Return
!2::
IfWinExist,Weather
{
trans :=180
Gui, Submit,Nohide
WinSet ,Transparent ,%trans%, Weathertool
}
Return
!3::
IfWinExist,Weather
{
trans :=90
Gui, Submit,Nohide
WinSet ,Transparent ,%trans%, Weathertool
}
Return
!4::
IfWinExist,Weather
{
  WinGet, ExStyle, ExStyle, Weathertool
  if (ExStyle & 0x8)  ; 0x8 is WS_EX_TOPMOST.
    {
      Winset, AlwaysOnTop, off, Weathertool
    }
    else
    {
      WinSet, AlwaysOnTop, on, Weathertool
    }
}
Return
!5::
IfWinExist,Weather
{
  WinGet, ExStyle, ExStyle, Weathertool
  if (ExStyle & 0x80020)  
    {
      WinSet, ExStyle, -0x80020,Weathertool
    }
    else
    {
      WinSet, ExStyle, +0x80020,Weathertool
    }
}
Return

;gui, showing the data
GuiShow:
Gui,  1: -Caption +Owner +Owndialogs +ToolWindow
Gui, 1:Font, S10 CDefault, Arial bold italic
Gui, 1:Add, Text, x5 y5 h20 w295 , %City%
Gui 1:Add , Pic , x5 y25 h70 w70, visual.gif
Gui, 1:Font, S8 CDefault, Arial bold
Gui 1:Add , Text , x85 y22 h14 w150, Date:%Forecastdate%
Gui 1:Add , Text , x85 y37 h14 w150, %Condition%
Gui 1:Add , Text , x85 y52 h14 w150, Temperature: %tempf%°F/%tempc%°C
Gui 1:Add , Text , x85 y67 h14 w150, %humidity%
Gui 1:Add , Text , x85 y82 h14 w150, %windcondition%
;Today
Gui, 1:Font, S8 CDefault, Arial bold
Gui 1:Add , Text, x5 y100 h12 w40 center, %day_of_week1%
Gui 1:Add , Pic , x5 y115 h40 w40, visual1.gif
Gui, 1:Font, S6 CDefault, Arial
Gui 1:Add , Text , x5 y160 r2 w65, %condition1%
Gui 1:Add , Text , x5 y180 h10 w60, High:%High1%°F/%temphigh1%°C
Gui 1:Add , Text , x5 y190 h14 w60, Low:%low1%°F/%templow1%°C
;Tomorrow
Gui, 1:Font, S8 CDefault, Arial bold
Gui 1:Add , Text, x80 y100 h12 w40 center, %day_of_week2%
Gui 1:Add , Pic , x80 y115 h40 w40, visual2.gif
Gui, 1:Font, S6 CDefault, Arial
Gui 1:Add , Text , x80 y160 r2 w65, %condition2%
Gui 1:Add , Text , x80 y180 h10 w60, High:%High2%°F/%temphigh2%°C
Gui 1:Add , Text , x80 y190 h14 w60, Low:%low2%°F/%templow2%°C
;Day after Tomorrow
Gui, 1:Font, S8 CDefault, Arial bold
Gui 1:Add , Text, x155 y100 h12 w40 center, %day_of_week3%
Gui 1:Add , Pic , x155 y115 h40 w40, visual3.gif
Gui, 1:Font, S6 CDefault, Arial
Gui 1:Add , Text , x155 y160 r2 w65, %condition3%
Gui 1:Add , Text , x155 y180 h10 w60, High:%High3%°F/%temphigh3%°C
Gui 1:Add , Text , x155 y190 h14 w60 , Low:%low3%°F/%templow3%°C
;Two days from now
Gui, 1:Font, S8 CDefault, Arial bold
Gui 1:Add , Text, x230 y100 h12 w40 center, %day_of_week4%
Gui 1:Add , Pic , x230 y115 h40 w40, visual4.gif
Gui, 1:Font, S6 CDefault, Arial
Gui 1:Add , Text , x230 y160 r2 w65, %condition4%
Gui 1:Add , Text , x230 y180 h10 w60, High:%High4%°F/%temphigh4%°C
Gui 1:Add , Text , x230 y190 h14 w60, Low:%low4%°F/%templow4%°C
Gui, 1:Menu, Bar
Gui 1:Color, Silver
Gui, 1:Show, w300 h205 x%Xwin% y%Ywin%, Weathertool
WinSet ,Transparent ,%trans%, Weathertool
OnMessage(0x201, "WM_LBUTTONDOWN")
Return

download:
;downloading the xml file from google weather api
locat=%place%,%cntr%
URLDownloadToFile,http://www.google.com/ig/api?weather=%locat%, %A_ScriptDir%\weather.xml
/*
parsing the data from google api xml file
unfortunatelly the data is set to attributes value rather then text value so some additional triming is needed
*/
xpath_load(XML, "weather.xml")
City:= Xpath(XML, "/xml_api_reply/weather/forecast_information/city")
blah=&#44
StringTrimLeft , City , City, 12
StringTrimRight , City, City,9
StringReplace ,City, City, %blah%
Postal:= Xpath(XML, "/xml_api_reply/weather/forecast_information/postal_code")
bla=#44
StringTrimLeft , Postal , Postal, 19
StringTrimRight , Postal, Postal,16
StringReplace ,Postal, Postal, %bla%
;weather at the moment
Forecastdate:= Xpath(XML, "/xml_api_reply/weather/forecast_information/forecast_date")
StringTrimLeft , Forecastdate , Forecastdate, 21
StringTrimRight , Forecastdate,Forecastdate,18
Condition:= Xpath(XML, "/xml_api_reply/weather/current_conditions/condition")
StringTrimLeft , Condition , Condition, 17
StringTrimRight , Condition,Condition,14
tempf:= Xpath(XML, "/xml_api_reply/weather/current_conditions/temp_f")
StringTrimLeft , tempf , tempf, 14
StringTrimRight , tempf,tempf,11
tempc:= Xpath(XML, "/xml_api_reply/weather/current_conditions/temp_c")
StringTrimLeft , tempc , tempc, 14
StringTrimRight , tempc,tempc,11
humidity:= Xpath(XML, "/xml_api_reply/weather/current_conditions/humidity")
StringTrimLeft , humidity , humidity, 16
StringTrimRight , humidity,humidity,13
visual:= Xpath(XML, "/xml_api_reply/weather/current_conditions/icon")
StringTrimLeft , visual ,visual, 12
StringTrimRight , visual , visual,9
windcondition:= Xpath(XML, "/xml_api_reply/weather/current_conditions/wind_condition")
StringTrimLeft , windcondition ,windcondition, 22
StringTrimRight , windcondition , windcondition, 19

;weather forecast for today and 3 days ahead
loop, {
  day_of_week%A_Index% := xpath(XML, "/xml_api_reply/weather/forecast_conditions[" . A_Index . "]/day_of_week")
  StringTrimLeft , day_of_week%A_Index% ,day_of_week%A_Index%, 19
  StringTrimRight , day_of_week%A_Index% , day_of_week%A_Index%, 16
  low%A_Index% := xpath(XML, "/xml_api_reply/weather/forecast_conditions[" . A_Index . "]/low")
  StringTrimLeft , low%A_Index% ,low%A_Index%, 11
  StringTrimRight , low%A_Index% , low%A_Index%, 8
  high%A_Index% := xpath(XML, "/xml_api_reply/weather/forecast_conditions[" . A_Index . "]/high")
  StringTrimLeft ,  high%A_Index% , high%A_Index%, 12
  StringTrimRight ,  high%A_Index% ,  high%A_Index%, 9
  visual%A_Index% := xpath(XML, "/xml_api_reply/weather/forecast_conditions[" . A_Index . "]/icon")
  StringTrimLeft , visual%A_Index% ,visual%A_Index%, 12
  StringTrimRight , visual%A_Index% , visual%A_Index%, 9
  condition%A_Index% := xpath(XML, "/xml_api_reply/weather/forecast_conditions[" . A_Index . "]/condition")
  StringTrimLeft , condition%A_Index% ,condition%A_Index%, 17
  StringTrimRight , condition%A_Index% , condition%A_Index%, 14
  ;calculation of Farenheit to Celsius
  SetFormat ,float, 2.1
  templow%A_Index% :=(low%A_Index%-32)*5/9
  temphigh%A_Index%:=(high%A_Index%-32)*5/9
  if !day_of_week%A_Index%
	Break
}
;weather represented in a visual manner
Urldownloadtofile , http://www.google.com/%visual%, visual.gif
Urldownloadtofile , http://www.google.com/%visual1%, visual1.gif
Urldownloadtofile , http://www.google.com/%visual2%, visual2.gif
Urldownloadtofile , http://www.google.com/%visual3%, visual3.gif
Urldownloadtofile , http://www.google.com/%visual4%, visual4.gif
Gui, Submit, NoHide
Gosub GuiShow
return
;change location
Location:
Gui,  +Owner +Owndialogs +ToolWindow
WinGetPos,Xwin,Ywin,,,Weathertool
InputBox ,place,New town, , , 100,100,Xwin+90,Ywin+50
InputBox ,cntr,New country, , , 100, 100,Xwin+90,Ywin+50
Gui, Submit,No Hide
If (place=""){
  IniRead ,place, Location.ini, Locat, place
  }
Gui, Submit,No Hide
IniWrite ,%place%, Location.ini, Locat, place
IniWrite ,%cntr%, Location.ini, Locat, cntr
Gosub , download
Return
;update current weather
Update:
IniRead ,place, Location.ini, Locat, place
IniRead ,cntr, Location.ini, Locat, cntr
Gosub, download
Return
About:
Gui ,  +Owner +Owndialogs +ToolWindow
Gui 2: +Toolwindow
WinGetPos,Xwin,Ywin,,,Weathertool
Gui, Submit, Nohide
x1 :=Xwin+50
y1 :=Ywin+40
cop :=chr(169)
Gui 2:add ,Text, x5 y5 w195 h15 center, Weathertool v1.0 
Gui 2:add ,Text, x5 y20 w195 h15 center, Bekihito%cop%,May 2010
Gui 2:add ,Text, x5 y40 w195 h15 , Change location: doh!
Gui 2:add ,Text, x5 y55 w195 h15 , Update weather: Update current weather
Gui 2:add ,Text, x5 y70 w195 h15 , Alt+1,2,3: Change transparency
Gui 2:add ,Text, x5 y85 w195 h15 , Alt+4: Toggle Always On Top
Gui 2:add, Text, x5 y100 w195 h15 ,Alt+5: Toggle Clickthrough
Gui 2:Show , x%x1% y%y1% w205 h120,About
Return

WM_LBUTTONDOWN() 
{ 
   PostMessage, 0xA1, 2 
}

GuiClose:
WinGetPos,Xwin,Ywin,,,Weathertool
Gui, Submit, NoHide
IniWrite, %Xwin%, location.ini, position,Xwin
IniWrite, %Ywin%, location.ini, position,Ywin
IniWrite, %trans%, location.ini, position,trans
ExitApp
