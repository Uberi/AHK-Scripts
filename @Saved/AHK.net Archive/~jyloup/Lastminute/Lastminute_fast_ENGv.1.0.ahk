;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;											;
;			"Lastminute Best Prices Finder"					;
;			Made by Jyloup 							;
;			with Autohotkey_L v.1.1.07.03					;
;			Many thanks to Janopn, Sinkfaze, Lexikos			;
;			and all members of the AHK community who			;
;			advised and helped me to make this program better.		;
;											;
;	Description : This programm is intended to find the best price plane 		;
;	tickets in "Lastminute" website  in a range of dates. Those pairs of dates	;
;	(or single dates for one-way trip)are between:					;
;	- a minimum date of departure and maximum date of return,			;
;	- a minimum stay and maximum stay (in days).					;
;	The four previous data are entered by the user, then the program generates	;	
;	all pairs of dates consistent with the data inputs and gives the minimum	; 
;	price and the airline for each pair in a corresponding list exportable in	;	
;	csv format. The search is made automatically in background without opening	;
;	webpages. However the user can see the search in real time by activating it.	;										;
;	He can also check a particular result by double-clicking a row in the list.	;
;											;
;	This is especially convenient for travelers with flexible travel dates, and	;
;	enables to save time and money for searching a good price. Sometimes prices	;
;	can vary by several hundreds units from a day to another.			;
;											;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


Fileinstall LastminuteLogo.jpg, %A_ScriptDir%\LastminuteLogo.jpg
Fileinstall LastminuteIcone.ico, %A_ScriptDir%\LastminuteIcone.ico
Fileinstall ListallcitiesBis.txt, %A_ScriptDir%\ListallcitiesBis.txt
;#NoTrayIcon
#Include CSV.ahk
#Include COM.ahk
Menu, Tray, Icon, %A_ScriptDir%\Lastminuteicone.ico
IsPaused := false
Gui, +AlwaysOntop +Border +Resize
Gui, Font, S12 CDefault Bold, Tahoma
Gui, Add, text, x390 y20 h45, Lastminute.com
; Lastminute logo
Gui, Add, Picture, x390 y5 w200 h45 , %A_ScriptDir%\LastminuteLogo.jpg
Gui, Add, Text, x90 y20 h20 , Find the best prices !
Gui, Font,s11 , 
Gui, Add, Text, x300 y20 h20 , with
Gui, Font, S9, 
Gui, Add, Text, x12 y120 w110 h40 , Minimal departure date
Gui, Add, Text, x12 y160 w110 h40 , Maximal return date
Gui, Add, DateTime, x122 y120 w100 h30 vDate1 gDate1 , 
Gui, Add, DateTime, x122 y160 w100 h30 vDate2, 
Gui, Add, Text, x12 y60 h20 , Departure
Gui, Add, Text, x12 y90 h20 , Destination
Gui, Font, ,
Gui, Add, ListView, x292 y115 w387 h345 vMyList gMyList, Dates|Best Fare|Airline|Duration
; adding icons to first column of listview, it's a buil-in feature of AH
ImageListID := IL_Create(1)
LV_SetImageList(ImageListID)
IL_Add(ImageListID, "shell32.dll", 23)
LV_SetImageList(ImageListID)
LV_ModifyCol(1, 150)
LV_ModifyCol(1, "Center")
LV_ModifyCol(2,62)
LV_ModifyCol(2, "Center")
LV_ModifyCol(3,100)
LV_ModifyCol(3, "Center")
LV_ModifyCol(4,70 Right)

;;;;;;;;;;;;;;; search bar below the result list;;;;;;;;;;;;;;
Gui, Add, Groupbox, xp yp+350 w387,Search progress
Gui, Add, Progress, xp yp+20 w387 h40 cBlue vMyProgress
Gui, Add, Text,xp+140 yp+10 vSymbprcent, `%
Gui, Add, Text,xp-20 yp w20 vPercent , 0
;;;;;; setup the default departure and arrival Cities on start ;;;;;;;;;;;
Gui, Font, S10,
IniRead, From, Lastminute.ini, Default_cities, Default_from, %A_space%
IniRead, To, Lastminute.ini, Default_cities, Default_To, %A_space%
FileRead, ListAllCities, Allcitieslastminute.txt
Stringreplace, Listallcities_From, Listallcities, %From%, %From%|
Stringreplace, Listallcities_To, Listallcities, %To%, %To%|
;Listallcities:=Regexreplace(Listallcities,"\R")
;Fileappend, %Listallcities%, AllcitiesBis.txt
Gui, Add, dropdownlist, x90 y55 w550 R20 vFrom Sort,%ListAllcities_From%
/*
Instead of using external file ListallcitiesBis.txt, 
you can enter your own most used travel cities between pipes "|"
after "vFrom," (enter them in a new line), for example like below:
(
NOU|PAR||ADL|AMS|AKL|BKK|BCN|
BER|BOM|BOD|BNE|BRU|CNS|CBR|CHC|CMB|DRW|DEL|DXB|DUD|FRA|GVA|OOL|GUM|
HAN|HEL|HKG|HNL|JKT|JNB|KUL|CPT|LON|LAX|LYS|MAA|MAD|MNL|MRS|MEL|MIL|
)
*/
Gui, Add, Dropdownlist, x90 y85 w550 R20 vTo Sort, %ListAllcities_To%
/*
(
PAR|ADL|AMS|AKL|BKK|BCN
)
*/
Gui, Add, Text, x12 y210 w160 h20 , Minimal duration of trip
Gui, Add, Text, x12 y240 w160 h20 , Maximal duration of trip
Gui, Add, Edit, x172 y210 w60 h20 vDay1 +Center, 3
Gui, Add, Text, x242 y210 w40 h20 , day(s)
Gui, Add, Edit, x172 y240 w60 h20 vDay2 +Center, 5
Gui, Add, Text, x242 y240 w40 h20 , day(s)
Gui, Add, CheckBox, x12 y260 w160 h30 vOneway, One-way trip (put #dates in minimal duration box)
Gui, Font, , 
Gui, Add, Button, x232 y130 w50 h50 gDuration, Calculate gap `n ( days )
Gui, Add, Button, x12 y297 w62 h64 vPage gPage, Show live web search
Gui, Add, Button, x82 y297 w62 h64 vinvPage ginvPage, Hide live web search
Gui, Font, S8, 
Gui, Add, Button, x12 y530 w50 h30 gAbout, About
Gui, Add, Button, xp+60 y530 w50 h30 gHelp, Help
Gui, Add, Button, xp+60 y530 w60 h30 gOptions, Advanced Options
Gui, Add, Button, xp+70 y530 w60 h30 gDonate, Paypal Donate
Gui, Add, Button, x192 y270 w90 h30 vPauseButton, Pause
Gui, Font, S11 Bold, 
Gui, Add, Button, x192 y350 w90 h100 vFunc gFunc, Let's find prices !
Gui, Font, , 
Gui, Add, Button, y+10 w90 gClear, Erase list
Gui, Add, Button, x192 y+10 h25 gExport, Export List (.CSV)
Gui, Add, Button, x192 y310 w90 h30 gStopsearch, Stop
Gui, Add, Text, x12 y370 w179 , 
(
Double-click upon a list's row to see
Lastminute webpage filled in
automatically with matching dates.
Don't close directly the web page
opening, Wait for message box. 
INTERNET EXPLORER MUST NOT
BE IN PROTECTED MODE FOR
THE PROGRAM TO ACCESS
LASTMINUTE PAGES.
(uncheck it in Security options)
While searching, don't click
on list's head name column.
)
; Generated using SmartGUI Creator 4.0
Menu, MyContextMenu, Add, Remove from the list, ContextClearRows
GuiControl, Disable, invPage
EnvAdd, Date2, 7, days
GuiControl,, Date2, %Date2%
Gui, Show, x181 y133, Lastminute Best Price Finder  - Plane tickets at the best price !
Return
stopped:=false
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; FUNCTIONS ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; - diffdays returns number of days between 2 dates in YYYYMMDD... format
; - add_days  adds days to a given date
; - dshort converts a YYYYMMDDHH24MMSS date to DD/MM/YYYY format
; - generatedates generates list of matching dates.
; IMPORTANT : all those functions are for dates in YYYYMMDDHH24MMSS format : 14 digits numbers.

Diffdays(right,left) ; returns number of days between dates right and left
{
   EnvSub,right,%left%,days ; "days" otpions soustracts only days.
   return right
}

Add_days(d,j) ; add "j" days to date "d" and returns new date
{
   EnvAdd,d,%j%,days
   return d
}
dshort(d) ; write date in DD/MM/YYY format
{
   FormatTime, d,%d%, Shortdate
   return d
}
GeneredatesSimple(x,d1) ; genere les dates de x à  x+d1 
{
      left := x 
      Loop, %d1%
      {
      dategauche := dshort(left)
      LV_Add("Icon1",dategauche,"","" )
      left:=add_days(left,1)
      }
return list
}
	
Generedates(x,y,d1,d2) 
{
   ; dates are supposed to be in complete YYYYMMDDHH24MMSS 14-digits format.
   ; Generates all dates pairs between dates x and y, 
   ; separated with intervals between d1 days and d2 days
   ; explanation of algorithm : we create intermediate dates Left and Right,
   ; Left & Right dates can "move" between x and y.
   ; check if x<=left, d1<= right - left <= d2, and right <= y : if yes take current date.
   ; (in fact we put always right:=left + d1, so forcely d1<= right - left 
   ; So finally, for each Left date fixed, we just check if right - left <= d2 and right <= y.
   ; Then increase right by +1 day, until it reaches y, for a fixed left date.
   ; Now, left date can increase until left + d1 =y AND right=y, so left+d1 must be <= y
   ; we first initialize right := left + d1 for each step left date value.
   ; Look at this scheme below to understand the algorithm:
   ; x ----------left ---------------------------- right -----------------y
   ;               <----------(<=d2) and (>=d1)------>
   
   left:=x
   right:=Add_days(left,d1)
   datepair=
   
   ; we can compare directly 2 dates in autohotkey with <= symbol
   
   while (right <= y) ;and (diffdays(y,left)>=d1) ;in fact this second condition is equivalent to right<=y !!!)
   ; this second condition is because the maximum possible left date is when right=y 
   ; i.e. (left + d1 =y), i.e. y-left = d1.
   ; So left + d1 (= right) must be always <= y i.e. diffdays(y,left) >=d1
   ; But right:=left + d1, so (right <= y) is the same as (diffdays(y,left) >=d1) !!
   {      
   while (right <= y) and (diffdays(right,left)<= d2) ; and diffdays(right,left)>=d1 
   ; for same reasons, : useless condition cause we do right:=left+d1
   ; so necessarily : diffdays(right, left) >= d1
   {
      datepair := dshort(left) "-" dshort(right)
      LV_Add("Icon1",datepair,"","" )
      right:=add_days(right,1)
   } ; increases right date for a fixed left date.
   
   ; Now, increase left date and setup right:= left + d1 in first "while loop"
   left:=add_days(left,1)
   right:=add_days(left,d1)   
   }   
   return list   
} ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; END OF FUNCTIONS ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Date1:
guicontrol,, date2, %date1%
return
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;; MAIN ROUTINES ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Func:
Gui, submit, NoHide  ; this command stores entered dates and days in variables.
IniWrite, %From%, Lastminute.ini, Default_cities, Default_from
IniWrite, %To%, Lastminute.ini, Default_cities, Default_To
From:=Substr(From,-3,3)
To:=Substr(To,-3,3)
If (From = "" ) or (To = "")
{
MsgBox, 262144,Lastminute Best Price Finder, Please choose a city in departure/destination list.
return
}
If LV_GetCount()!=0
{
MsgBox, 262144,Lastminute Best Price Finder, Empty the list before `n doing another search !
Exit
}
Global stopped
stopped := false
GuiControl, Disable, Func
Guicontrol, Enable, PauseSearch
;GuiControl, Disable, Resume
;GuiControl, Disable, invPage

If Oneway = 1 
	generedatesSimple(date1,day1)
	Else
	generedates(date1,date2,day1,day2)
nblignes:=% LV_GetCount()
Pwb := ComObjCreate("InternetExplorer.Application")
Pwb.Navigate("http://www.travelagency.travel/vol/open-jaw.cfm?idpart=944547")
Pwb.Visible:=False
while pwb.readystate < 4
sleep, 200
while !inStr(pwb.document.documentElement.innertext, "Aller/retour")
Sleep, 200
limitdate:=Pwb.document.aspnetForm["ctl00_m_cphMain_m_ctrlFlightSearchMini_m_txtDateDep"].value
limitdate:=Getdate2(limitdate)
If limitdate > 20120906
{
Msgbox,262144,Lastminute Notification,
(
Trial expired.
Please modify the code from AHK forum.
)
Pwb.quit()
Exitapp
}
LV_GetText(datepair, 1, 1) ; Récupère les dates de la premiere ligne
;;;;;;;;;; aller simple à  cocher si Simple désiré  sinon cocher Aller-retour;;;;;;;;;;
If Oneway = 1 ;;;; aller simple coché
Pwb.document.aspnetForm["ctl00$m_cphMain$m_ctrlFlightSearchMini_openjaw$rbtTrip"][1].fireEvent("onclick")
Else Pwb.document.aspnetForm["ctl00$m_cphMain$m_ctrlFlightSearchMini_openjaw$rbtTrip"][0].fireEvent("onclick")

Pwb.document.aspnetForm["ctl00$m_cphMain$m_ctrlFlightSearchMini$m_txtDepart"].value := From
Pwb.document.aspnetForm["ctl00_m_cphMain_m_ctrlFlightSearchMini_m_txtDest"].value := To
date1:=Substr(datepair,1,10)
Sleep, 200
Pwb.document.aspnetForm["ctl00_m_cphMain_m_ctrlFlightSearchMini_m_txtDateDep"].value := date1
If Oneway = 0  ; aller-retour choisi
{
date2:=Substr(datepair,12,10)
Sleep, 200
Pwb.document.aspnetForm["ctl00_m_cphMain_m_ctrlFlightSearchMini_m_txtDateRet"].value := date2
}
;;;;;;;;;;;;;;;;;;;;;;;;;;;;; submit ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
pwb.document.aspnetForm["ctl00$m_cphMain$m_ctrlFlightSearchMini$m_btnSearch"].click()

; for slow connections, as next page after submit doesn't open directly, 
; program must wait than current text or tab title disappears.
; For normal connection (Wifi, Wire) you should write shorter times below.
IniRead, time1, Lastminute.ini, Loading_times(ms), time1, 200
while inStr(pwb.document.documentElement.innertext, "Aller/retour")
Sleep, time1 ; loading_time_1 (waiting form page disappears, default : 200ms)
while (pwb.locationName = "Vol multi-destinations")
Sleep, time1 ; loading_time_1 (waiting form page disappears, default : 200ms)
IniRead, time2, Lastminute.ini, Loading_times(ms), time2, 1500
Sleep, time2 ; loading_time_2 (waiting for next page, default : 1500 ms)
IniRead, time3, Lastminute.ini, Loading_times(ms), time3, 1000
while instr(pwb.document.documentElement.innertext, "Merci de patienter")
;while (pwb.locationName = "Recherche en cours")
Sleep, time3 ; loading_time3 (searching, default : 1000 ms)
; With slow connections such as 3G or bad signal, if we dont' wait enough
; the program won't find the innertext on next page and asks if the script should
; continue or not. So it waits by default 2 seconds to  be sure, but this time
; must be shorter for "normal" connections (Wifi, wire) to run quicker
; or longer for slow connections. (sometimes 7 seconds are necessary)
IniRead, time4, Lastminute.ini, Loading_times(ms), time4, 2000
Sleep, time4 ; loading_time4(waiting for result page loading, default : 2000)
;If (pwb.locationName = "Erreur")
If instr(pwb.document.documentElement.innerText, "Votre demande ne peut pas aboutir") OR (pwb.locationName = "Erreur")
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;No flights for this date ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
{
Pourcent:=Floor(1/nblignes*100)
GuiControl,, MyProgress, %Pourcent%*387
GuiControl,, Percent, %Pourcent%
Guicontrol,, Symbprcent, `%
Sleep, 200
LV_Modify(1,"Col2","No Flight")
}
Else
{
while !inStr(pwb.document.documentElement.innertext, "trier les")
Sleep, time1 ; loading_time1

Loop %   (images :=   Pwb.document.images).length
{}   Until   (images[(i :=   A_Index-1)].className="img_Company")
airline:= RegExReplace(images[i].alt,"\W+$")
; the Loop method to grab the airline (row[0], cells[0])
; is slightly quicker than a direct access to the table
; because of the 2 Regexreplace used:
; the direct access code is :
;airline:= pwb.document.all.tags("table")[1].rows[0].cells[0].innerhtml
;airline:=Regexreplace(airline,"ms).*alt=.") ; removes all text before img company name
;airline:=Regexreplace(airline,"ms)...onerror.*") ; removes all text after img company name

; direct access to the price on 7th column
; maybe there is also a Loop methode to access it quicker ?
price:= pwb.document.all.tags("table")[1].rows[0].cells[6].innertext
price:=Regexreplace(price,"ms)\*.*") ; removes all text after price text.

Pourcent:=Floor(1/nblignes*100)

;;;;;;;;;;;;Inserts price inside the list (adds a row);;;;;;;;;;;;;
LV_Modify(1,"Col2",price)
LV_Modify(1,"Col3",airline)
If Oneway = 0  ;;;;; duration is only for Round-trip
{
durat:=Differ(date2,date1)
LV_Modify(1,"Col4",durat . " days")
}
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;GuiControl, , MyList,%MyList%
GuiControl,, MyProgress, %Pourcent%*387
GuiControl,, Percent, %Pourcent%
Guicontrol,, Symbprcent, `%
}
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;End of the first search ;;;;;;;;;;;;

Gosub, searchloop 
;;; Loop, 0 does nothing
If Pourcent = 100
{
Guicontrol,,Percent,
Guicontrol, Move, Symbprcent, W120
Guicontrol, , Symbprcent, Finished 
MsgBox, 262144, Lastminute Search, All prices found ! 
}
GuiControl, Enable, Func
return
;;;;;;;;;;;;;;;;;;;;;;;;;;;; END OF THE MAIN FUNCTION ;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

searchloop:
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; search loop ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Loop, % nblignes -1 ; runs all list's rows
{
Settitlematchmode, 2
;;;;;;;;;;;;;;;;;;;;;;;;;;;; populating form ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
LV_GetText(price, A_Index+1, 2) ; grabs data, normally should be empty
; skips search if Price is already found in the list (found by a previous double-click on the row)
If Regexmatch(price,"[0-9]")
Continue

LV_GetText(datepair, A_Index+1, 1) ; Grabs the following dates in the list
Pwb.Navigate("http://www.travelagency.travel/vol/open-jaw.cfm?idpart=944547")
while pwb.readystate < 4
sleep, 200
IniRead, time1, Lastminute.ini, Loading_times(ms), time1, 200
while !inStr(pwb.document.documentElement.innertext, "Aller/retour")
Sleep, time1 ;loading_time_1 (waiting form page disappears, default : 200ms)

If Oneway = 1 ;;;; One-way checked
{                         
;Pwb.document.aspnetForm["ctl00$m_cphMain$m_ctrlFlightResults$m_ctrlFlightSearchMini$rbtTrip"][1].fireEvent("onclick")
;;; on a previous version, i wanted to work directly on the second form displayed on the left of the result page,
;;; but finally it is quicker to load everytime the first form at above url
Pwb.document.aspnetForm["ctl00$m_cphMain$m_ctrlFlightSearchMini_openjaw$rbtTrip"][1].fireEvent("onclick")
}
Else
{
;Pwb.document.aspnetForm["ctl00$m_cphMain$m_ctrlFlightResults$m_ctrlFlightSearchMini$rbtTrip"][0].fireEvent("onclick")
Pwb.document.aspnetForm["ctl00$m_cphMain$m_ctrlFlightSearchMini_openjaw$rbtTrip"][0].fireEvent("onclick")
}
Sleep, 200
;Pwb.document.aspnetForm["ctl00_m_cphMain_m_ctrlFlightResults_m_ctrlFlightSearchMini_m_txtDepart"].value := From
Pwb.document.aspnetForm["ctl00$m_cphMain$m_ctrlFlightSearchMini$m_txtDepart"].value := From
Pwb.document.aspnetForm["ctl00_m_cphMain_m_ctrlFlightSearchMini_m_txtDest"].value := To
date1:=Substr(datepair,1,10)
Sleep, 500
;Pwb.document.aspnetForm["ctl00_m_cphMain_m_ctrlFlightResults_m_ctrlFlightSearchMini_m_txtDateDep"].value := date1
Pwb.document.aspnetForm["ctl00_m_cphMain_m_ctrlFlightSearchMini_m_txtDateDep"].value := date1
Sleep, 200
If Oneway = 0  ; aller-retour choisi
{
date2:=Substr(datepair,12,10)
Sleep, 500
Pwb.document.aspnetForm["ctl00_m_cphMain_m_ctrlFlightSearchMini_m_txtDateRet"].value := date2
Sleep, 200
}
;;;;;;;;;;;;;;;;;; soumettre boucle;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;pwb.document.aspnetForm["ctl00_m_cphMain_m_ctrlFlightResults_m_ctrlFlightSearchMini_m_btnSearch"].click()
pwb.document.aspnetForm["ctl00$m_cphMain$m_ctrlFlightSearchMini$m_btnSearch"].click()

; for slow Internet connections, the page is not loading right after the previous click
; so we must wait that a text of the current page ("Aller/retour") goes out
; or that tab title ("vol multi-destinations") disappears
IniRead, time1, Lastminute.ini, Loading_times(ms), time1, 200
while inStr(pwb.document.documentElement.innertext, "Aller/retour")
Sleep, time1 ; loading_time_1 (waiting form page disappears, default : 200ms)
while pwb.locationName = "Vol multi-destinations"
Sleep, time1 ; loading_time_1 (waiting form page disappears, default : 200ms)
IniRead, time2, Lastminute.ini, Loading_times(ms), time2, 1500
Sleep, time2 ; loading_time_2 (waiting for next page, default : 1500 ms)
; then we wait that the Searching page goes out
IniRead, time3, Lastminute.ini, Loading_times(ms), time3, 1000
while instr(pwb.document.documentElement.innertext, "Merci de patienter")
; for slow internet connections, i noticed it is more reliable to use a page element (text)
; instead of the tab name because tab name is taken into account by Autohotkey about 
; some seconds after it's really displayed in IE
;while pwb.locationName = "Recherche en cours"
Sleep, time3 ; loading_time3 (searching, default : 1000 ms)
IniRead, time4, Lastminute.ini, Loading_times(ms), time4, 2000
Sleep, time4   ;loading_time4(waiting for result page loading, default : 2000)

;;;;;;;;;;;;;;;;;;;;;;;;;; ERROR CASE IN THE SEARCH (no flights);;;;;;;;;;;;;;;;;;;;;;
If instr(pwb.document.documentElement.innerText, "Votre demande ne peut pas aboutir")
;If (pwb.locationName = "Erreur")
;;;;;;;;;;;;;;;;;;;;;;;;;; No flights for this date ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
{
Pourcent:=Floor((A_index +1)/nblignes*100)
GuiControl,, MyProgress, %Pourcent%*387
GuiControl,, Percent, %Pourcent%
Guicontrol,, Symbprcent, `%
LV_Modify(A_index+1,"Col2","No flight")
Continue
}
; the text "trier les" is unique and only in the results page
while !inStr(pwb.document.documentElement.innertext, "trier les")
Sleep, 200 ; loading_time_1 (waiting form page loads, default : 200ms)

Loop %   (images :=   Pwb.document.images).length
{}   Until   (images[(i :=   A_Index-1)].className="img_Company")
airline:= RegExReplace(images[i].alt,"\W+$")
price:= pwb.document.all.tags("table")[1].rows[0].cells[6].innertext
price:=Regexreplace(price,"ms)\*.*")o

If stopped
break

Pourcent:=Floor((A_index + 1)/nblignes*100)
If stopped
break
;;;;;;;;;;;;;;;;;Inserts price & airline in the list (adds a row);;;;;;;;;;;;;
LV_Modify((A_index + 1),"Col2",price)
LV_Modify((A_index + 1),"Col3",airline)
If Oneway = 0  ;;;;; One-way unchecked
{
durat:=Differ(date2, date1)
LV_Modify((A_index + 1),"Col4",durat . " days")
}
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;GuiControl, , MyList,%MyList%
GuiControl,, MyProgress, %Pourcent%*387
GuiControl,, Percent, %Pourcent%
Guicontrol,, Symbprcent, `%
Sleep, 200
}  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;END OF THE SEARCH LOOP HERE ;;;;;;;;;;;;;;;

; converts DD/MM/YYYY into YYYYMMDD format
Getdate2(date1)
{
Loop, Parse, date1, /
  rdate1=%A_LoopField%%rdate1%
  Return %rdate1%
}

Differ(d2,d1) ; gives the difference (days) between dates d2 et d1 d2>=d1
{
; d1 et d2 initially in dd/MM/yyyy must be in YYYYMMDD format
; to use Envsub
Loop, Parse, d1, /
  rd1=%A_LoopField%%rd1% ; writes YYYYMMdd
Loop, Parse, d2, /
  rd2=%A_LoopField%%rd2%
EnvSub, rd2, %rd1%, days
return rd2
}
	
; following function was initially written for a previous version
; in the main lastminute page
Getdate(date1)
{
mois := ["Jan","Fév","Ma","Avr","Mai","Juin","Juil","Aoà»t","Sep","Oct","Nov","Déc"]
StringSplit, mois, mois, %A_Space%
StringSplit, Newdate, date1, /
If Newdate1<10  ;09 should be 9
StringReplace, Newdate1, Newdate1, 0
m = % mois[Newdate2]
date1 = %Newdate1%%A_Space%%m%%A_Space%%Newdate3%
return date1
}

; the original function IELoad causes sometimes a stop in the program
; since webpage cannot completely load and pwb.busy always true.
IELoad(Pwb)   ;You need to send the IE handle to the function unless you define it as global.
{
   If !Pwb   ;If Pwb is not a valid pointer then quit
      Return False
   ;Loop   ;Otherwise sleep for .1 seconds untill the page starts loading
      Sleep,100
   While Pwb.readystate < 4
   	Sleep, 100
   Loop   ;Once it starts loading wait until completes
      Sleep,100
   Until (!Pwb.busy)
   Loop   ;optional check to wait for the page to completely load
   Sleep,200
   Until (Pwb.Document.Readystate = "Complete")
Return True
}

IEGet( Name="") ; return pwb with the exact tab title
{ 
   IfEqual, Name,, WinGetTitle, Name, ahk_class IEFrame ; Get active window if no parameter 
   Name := ( Name="New Tab - Windows Internet Explorer" ) ? "about:Tabs" : RegExReplace( Name, " - (Windows|Microsoft) Internet Explorer" ) 
   For pwb in ComObjCreate( "Shell.Application" ).Windows 
      If ( pwb.LocationName = Name ) && InStr( pwb.FullName, "iexplore.exe" ) 
         Return pwb 
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;double click on a row ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;; to automatically open, fill in webpage and check price ;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
MyList:
Gui, submit, NoHide
From:=Substr(From,-3,3)
To:=Substr(To,-3,3)
; double click on a row : opens webpage to check the price of matching dates
if A_GuiEvent = DoubleClick  
{
If LV_GetCount()=0
{
Msgbox,262144, Lastminute Best Price, Empty list !
;pwb.refresh() ; refresh pwb ? because a message box suspends current thread 
return
}
    LV_GetText(Datepair, A_EventInfo, 1) ; grabs the dates pair of the first column
    					 ; A_EventInfo contains Row number
   ; LV_GetText(price, A_EventInfo, 2)
    
    
if !Regexmatch(Datepair,"[0-9/]") ; if no dates in the row, warns user
{
	Msgbox, 262144,Lastminute Best Price, No date on this row ! 
	;pwb.refresh()
	return
}

; warns user if a webpage is already opened to check a price
; but THIS CONDITION STILL DOESN'T WORK
; any help would be appreciated....
If Pwb2
{
Msgbox,262144,Lastminute Best Price,
(
Please wait the previous search is ended.
)
return
}
MsgBox,262145,Lastminute Best Price,
(
Thank you to NOT close directly the opening
webpage for this price search, but wait for
the next messagebox instead, then click "OK".

(INTERNET EXPLORER MUST NOT BE IN
PROTECTED MODE. Change it in Security
options of Internet Explorer.
)
IfMsgbox Cancel
;pwb.refresh()
return
doubleclic(Oneway, from, to, datepair)
} ; end of if
return

; after double-clicking a row, the following function opens lastminute webpage to display
; prices matching to the this row's dates.
doubleclic(Oneway, from, to, datepair){
Gui, Minimize
Pwb2 := ComObjCreate("InternetExplorer.Application")
Pwb2.Navigate("http://www.travelagency.travel/vol/open-jaw.cfm?idpart=944547")
Pwb2.Visible := True
while pwb2.readystate < 4
sleep, 200
while !inStr(pwb2.document.documentElement.innertext, "Aller/retour")
Sleep, 200
Sleep 1500
If Oneway = 1 ;;;; One-way checked
{                         
;Pwb2.document.aspnetForm["ctl00$m_cphMain$m_ctrlFlightResults$m_ctrlFlightSearchMini$rbtTrip"][1].fireEvent("onclick")
Pwb2.document.aspnetForm["ctl00$m_cphMain$m_ctrlFlightSearchMini_openjaw$rbtTrip"][1].fireEvent("onclick")
}
Else
{
;Pwb2.document.aspnetForm["ctl00$m_cphMain$m_ctrlFlightResults$m_ctrlFlightSearchMini$rbtTrip"][0].fireEvent("onclick")
Pwb2.document.aspnetForm["ctl00$m_cphMain$m_ctrlFlightSearchMini_openjaw$rbtTrip"][0].fireEvent("onclick")
}
Pwb2.document.aspnetForm["ctl00$m_cphMain$m_ctrlFlightSearchMini$m_txtDepart"].value := From
Pwb2.document.aspnetForm["ctl00_m_cphMain_m_ctrlFlightSearchMini_m_txtDest"].value := To
date1:=Substr(datepair,1,10)
Pwb2.document.aspnetForm["ctl00_m_cphMain_m_ctrlFlightSearchMini_m_txtDateDep"].value := date1
If Oneway = 0  ; Round-trip : return date needed
{
date2:=Substr(datepair,12,10)
Pwb2.document.aspnetForm["ctl00_m_cphMain_m_ctrlFlightSearchMini_m_txtDateRet"].value := date2
}
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; submit ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
pwb2.document.aspnetForm["ctl00$m_cphMain$m_ctrlFlightSearchMini$m_btnSearch"].click()
while instr(pwb2.document.documentElement.innertext, "Aller/retour")
Sleep, 500
Sleep, 1500
while instr(pwb2.document.documentElement.innertext, "Merci de patienter")
;while pwb.locationName = "Recherche en cours"
Sleep, 1000
Sleep, 5000
If Pwb2.LocationName="Erreur" ;No flights for this date
{
LV_Modify(A_Eventinfo,"Col2","No Flight")
MsgBox, 262144, Lastminute Best Price, 
(
No flight for the seleced date(s)
Please close the webpage by selecting
"OK" on this messagebox (don't close
the webpage directly)
)
ComObjError(false)
pwb2.Quit()
pwb2 =
pwb.refresh()
Sleep, 200
pwb.refresh()
Exit
}

while !inStr(pwb2.document.documentElement.innertext, "trier les")
Sleep, 200
Loop %   (images :=   Pwb2.document.images).length
{}   Until   (images[(i :=   A_Index-1)].className="img_Company")
airlineclick:= RegExReplace(images[i].alt,"\W+$")
priceclick:= pwb2.document.all.tags("table")[1].rows[0].cells[6].innertext
priceclick:=Regexreplace(priceclick,"ms)\*.*")
LV_Modify(A_Eventinfo,"Col2",priceclick)
LV_Modify(A_Eventinfo,"Col3",airlineclick)
If Oneway = 0  ;;;;; One-way unchecked
{
durat:=Differ(date2, date1)
LV_Modify(A_Eventinfo,"Col4",durat . " days")
}
pwb.refresh()
MsgBox,262144,Lastminute Best Price,
(
The minimal fare for %From% - %To% 
on %datepair%
is %priceclick% with %airlineclick%
Click OK to quit the webpage.
(Please don't close it direclty)    
)
ComObjError(false)
pwb2.Quit()
pwb2 = 
Sleep, 100
pwb.refresh()
Sleep, 200
pwb.refresh()
Gui, Restore
Exit 
}
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;END OF DOUBLE-CLICK FUNCTION ;;;;;;;;;;;;;;;;;;;;;;
return


Clear:
MsgBox,262196,Lastminute Best Price,
(
Are you sure to erase the list?
Window will be reloaded.
(can take some seconds)
)
IfMsgbox Yes
{
LV_Delete()  ; Clear the ListView, but keep icon cache intact for simplicity.
GuiControl,, MyProgress, 0
GuiControl, , Percent, 0`%
Guicontrol, enable, Func
stopped := true
ComObjError(false)
pwb.Quit()
pwb = 
Reload
}
return

Export:
Gui 1:+OwnDialogs
FormatTime, date, YYYYMMDDHH24MISS, yyyy.MM.dd.HH.mm.ss
FileSelectFile, SelectedFileName, S16, Fares_Lastminute_%date%, Save CSV, CSV Files (*.csv)
If SelectedFileName = 
   return
SplitPath, SelectedFileName, name, dir, ext, name_no_ext, drive
If (ext <> "csv")
   SelectedFileName = %SelectedFileName%.csv
CurrentFileName = %SelectedFileName%
GoSub SaveFile
return

SaveFile:
IfExist %CurrentFileName%
{
    FileDelete %CurrentFileName%
    If ErrorLevel
    {
        MsgBox Failed to overwrite "%CurrentFileName%".
        return
    }
}
CSV_LVSave(CurrentFileName, MyList, ";", 0, 1)
return

Page:
GuiControl, Disable, Page
GuiControl, Enable, invPage
MsgBox, 262144,Lastminute Best Price, 
(
Thank you to NOT close directly the opening
webpage, but click on "Hide live web search"
in the program Lastminute Best Price Finder
to hide again this webpage. Unless, search
will be stopped.

(INTERNET EXPLORER MUST NOT BE IN
PROTECTED MODE. Change it in Security
options of Internet Explorer.
)
Pwb.Visible := True
return

invPage:
GuiControl, Disable, invPage
GuiControl, Enable, Page
Pwb.Visible := False
return

Duration:
Gui, submit, NoHide
durat:=Date2
EnvSub, durat, %Date1%, Days
Guicontrol,,Day1, %durat%
Guicontrol,,Day2, %durat%
return

;;;;;;;;;;;;;; PAUSE BUTTON;;;;;;;;;;;;
ButtonPause:
if IsPaused
{
   Pause off
   IsPaused := false
   GuiControl,, PauseButton, Pause
}
else
   SetTimer, Pause, 10
return

Pause:
SetTimer, Pause, off
IsPaused := true
GuiControl,, PauseButton, Resume
Pause, on
return


StopSearch:
MsgBox,262148,Lastminute Best Price,
(
Are you sure you want to stop the search?
You'll have to erase the list to begin
a new search. You can save the current list.
)
IfMsgBox Yes
{
stopped := true
ComObjError(false)
pwb.Quit()
pwb = 
}
return

About:
Progress, zh0 B, 
(
Lastminute Best Price Finder v1.0
July 2012
Developed by Jyloup
with Autohotkey_L
)
Sleep, 3400
Progress, Off
return

Help:
MsgBox,262144,Help Lastminute Best Price Finder,
(
This utility enables to find quickly the minimal plane
fares displayed on Lastminute website, in a range of
dates given by a minimal departure/maximal return dates,
and minimal/maximal durations of stay.
IMPORTANT : Internet explorer must NOT be in protected
mode for the program to access lastminute pages.
(change it in Internet Options/Security)

- For a Round-trip : Enter minimal departure date, maximal
  return date, minimal duration of stay, maximal duration of stay
  All combinations will be calculated in the list.

- For a One-way trip, just enter the minimal departure date, and
  the number of possible departure days following this departure date
  (to be entered in "Minimal duration"). Other values will be ignored.

- "Calculate gap (days)" gives the number of days between the 2 dates
  and is displayed in "minimal duration" and "maximal duration".
  This enables to quickly adjust those durations for long trips
  
- Once dates are entered, click on "Let's find Prices !" and let
  the program run... Prices will be displayed in the list date after date.

- "Show live web search" enables to view a live prices search.
  A webpage will be opened automatically. Click on "Hide live web search"
  to hide this webpage. DON'T CLOSE IT DIRECTLY !
  
- In "Advanced Options", you can adjust loop times to make search
  quicker or longer, depending on your internet connection speed.
  
- If you are interested in this program, and/or would like me
  to develop similar programs for other websites, you can support
  me by clicking "Paypal donate" and give an amount of your choice.
  You can also email me at jyloup [at] hotmail.fr

- You can double-click a list's row to check a price matching to
  the row's date(s). Don't close direclty the opening webpage,
  but wait for the messagebox displaying price/airline instead.
  
- Finally, you can also save the results list in CSV format
  (readable by Notepad and Excel).
)
return

ContextClearRows:  ; The user selected "Clear" in the context menu.
RowNumber = 0  ; This causes the first iteration to start the search at the top.
Loop
{
    ; Since deleting a row reduces the RowNumber of all other rows beneath it,
    ; subtract 1 so that the search includes the same row number that was previously
    ; found (in case adjacent rows are selected):
    RowNumber := LV_GetNext(RowNumber - 1)
    if not RowNumber  ; The above returned zero, so there are no more selected rows.
        break
    LV_Delete(RowNumber)  ; Clear the row from the ListView.
}
return
GuiContextMenu:  ; Launched in response to a right-click or press of the Apps key.
if A_GuiControl <> MyList  ; Display the menu only for clicks inside the ListView.
    return
; Show the menu at the provided coordinates, A_GuiX and A_GuiY.  These should be used
; because they provide correct coordinates even if the user pressed the Apps key:
Menu, MyContextMenu, Show, %A_GuiX%, %A_GuiY%
return

Options:
IniRead, time1, Lastminute.ini, Loading_times(ms), time1, 200
IniRead, time2, Lastminute.ini, Loading_times(ms), time2, 1500
IniRead, time3, Lastminute.ini, Loading_times(ms), time3, 1000
IniRead, time4, Lastminute.ini, Loading_times(ms), time4, 2000
Gui, 2:New
Gui, 2:+Alwaysontop
Gui, 2:add, text, center,
(
You can adjust finely those 4 loop times to have an optimal search and make it quicker.
But don't setup times too short because sometimes searched words might not be found
since next page is not yet loaded, and script could be interrupted.
Modifications will be considered in live, if the search is already launched.
)
Gui, 2:add, text, w650, Faster connection		Time waiting "Aller/retour" text disappears (default: 200 ms) :               ms		Slower connection
Gui, 2:add, text, vTexte1 xp+455 w30, 200
Gui, 2:add, slider, x10 w650 Range50-20000 Tickinterval1000 Page200 center vSlide1 gSlide1 altsubmit, %time1%

Gui, 2:add, text, w650, Faster connection		Waiting Time for the Searching page (default: 1500 ms) :               ms		Slower connection
Gui, 2:add, text, vTexte2 xp+430 w30, 1500
Gui, 2:add, slider, x10 w650 Range50-20000 Tickinterval1000 Page200 center vSlide2 gSlide2 altsubmit, %time2%

Gui, 2:add, text, w650, Faster connection		Waiting Time Searching page disappears (default: 1000 ms) :               ms		Slower connection
Gui, 2:add, text, vTexte3 xp+455 w30, 1000
Gui, 2:add, slider, x10 w650 Range50-20000 Tickinterval1000 Page200 center vSlide3 gSlide3 altsubmit, %time3%

Gui, 2:add, text, w650, Faster connection		Waiting Time for the result fares page (default: 2000 ms) :               ms		Slower connection
Gui, 2:add, text, vTexte4 xp+435 w30, 2000
Gui, 2:add, slider, x10 w650 Range50-20000 Tickinterval1000 Page200 center vSlide4 gSlide4 altsubmit, %time4%
Gui, 2:add, button, gOK ,OK
Gui, 2:add, button, xp+60 gReset, Reset to default values
gui, 2:show
return

Slide1:
gui, 2:submit, nohide
guicontrol, 2:,Texte1, %Slide1%
time1:=Slide1
IniWrite, %time1%, Lastminute.ini, Loading_times(ms), time1
return
Slide2:
gui, 2:submit, nohide
guicontrol, 2:,Texte2, %Slide2%
time2:=Slide2
IniWrite, %time2%, Lastminute.ini, Loading_times(ms), time2
return
Slide3:
gui, 2:submit, nohide
guicontrol, 2:,Texte3, %Slide3%
time3:=Slide3
IniWrite, %time3%, Lastminute.ini, Loading_times(ms), time3
return
Slide4:
gui, 2:submit, nohide
guicontrol, 2:,Texte4, %Slide4%
time4:=Slide4
IniWrite, %time4%, Lastminute.ini, Loading_times(ms), time4
return

OK:
Gui, 2:destroy
return

reset:
msgbox, 262148,Best Price Finder options, Are you sure you want to reset to default values?
Ifmsgbox, yes
{
Guicontrol, 2:,Texte1,200
Guicontrol, 2:,Texte2,1500
Guicontrol, 2:,Texte3,1000
Guicontrol, 2:,Texte4,2000
Guicontrol, 2:,Slide1,200
Guicontrol, 2:,Slide2,1500
Guicontrol, 2:,Slide3,1000
Guicontrol, 2:,Slide4,2000
IniWrite, 200, Lastminute.ini, Loading_times(ms), time1
IniWrite, 1500, Lastminute.ini, Loading_times(ms), time2
IniWrite, 1000, Lastminute.ini, Loading_times(ms), time3
IniWrite, 2000, Lastminute.ini, Loading_times(ms), time4
}
return

Donate:
MsgBox,262144,Lastminute Best Price Finder,
(
For future developments and the time past to
improve this free app and next programs for
other airline websites, you can give me an
amount of your choice, and also email me each
airline website you would like to be developed
for your own needs. You will be redirected to
a Paypal page. Thank you ! Jyloup.
)
run https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=8WB5BYCG5948Q
return

GuiClose:
ExitApp
