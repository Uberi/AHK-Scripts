#SingleInstance,Force
CoordMode,Mouse,Screen
set:=[]
settings:=new xml("settings")
http:=new auth()
global set,settings,http
load_settings()
if !settings.ssn("//nag").text{
	MsgBox,4,New Features,In the settings window you can now change the appearance of the GUI.`nShow next time?
	IfMsgBox No
	settings.Add("nag","",1)
}

;URLDownloadToFile,% "https://www.googleapis.com/calendar/v3/calendars/maestrith@gmail.com/events?access_token=" set.access_token,big list.txt
;URLDownloadToFile,% "https://www.google.com/calendar/feeds/maestrith@gmail.com/private/full/b8f1a2feb64gu9orog2jrj8jhs?access_token=" set.access_token,ee.xml

/*
	;this is how you get info from the xml
	events:=new xml("events")
	events.xml.setProperty("SelectionLanguage","XSLPattern")
	m(events.ssn("//name").text,events.ssn("//email").text)
	events.Transform()
	dir:=events.ssn("//entry/id").Text
	SplitPath,dir,File
	m(file*
	events.xml.setProperty("SelectionLanguage","XPath")
	thing:=events.ssn("//*[contains(text(),'b8f1a2feb64gu9orog2jrj8jhs')]")
	m(thing.xml)
	m(sn(thing,"../*").length,ssn(thing,"../title").Text)
	m(set.access_token)
	return
	
*/
;URLDownloadToFile,% "https://www.google.com/calendar/feeds/default/private/full?access_token=" set.access_token,events.xml
/*
	;download all calendar events and create an xml object 
	URLDownloadToFile,% "https://www.google.com/calendar/feeds/default/private/full?access_token=" set.access_token,events.xml
	t:=ComObjCreate("MSXML2.DOMDocument")
	FileRead,xml,events.xml
	t.loadxml(xml)
	m(ssn(t,"//id").xml)
	
*/



;URLDownloadToFile,https://www.googleapis.com/calendar/v3/users/me/settings?Content-Type=application/xml?access_token=%token%,cal.txt
;set info for authorization from google
;main GUI
/*
	
	edit1=
	(
	<entry xmlns='http://www.w3.org/2005/Atom'
	xmlns:gd='http://schemas.google.com/g/2005'>
	<category scheme='http://schemas.google.com/g/2005#kind'
	term='http://schemas.google.com/g/2005#event'></category>
	<title type='text'>Tennis with Beth</title>
	<content type='text'>Meet for a quick lesson.</content>
	<gd:transparency
	value='http://schemas.google.com/g/2005#event.opaque'>
	</gd:transparency>
	<gd:eventStatus
	value='http://schemas.google.com/g/2005#event.confirmed'>
	</gd:eventStatus>
	<gd:where valueString='Rolling Lawn Courts'></gd:where>
	<gd:when startTime='2006-04-17T15:00:00.000Z'
	endTime='2006-04-17T17:00:00.000Z'></gd:when>
	</entry>
	)
*/
Gui,+hwndhwnd -Caption
Gui,Add,ListView,w200 h500 ggo vupdate_listview -Multi AltSubmit,Calendar
Gui,Add,ListView,w1000 h500 x+10,Event|Start|End
Gui,Add,Button,ggo xm vcalendar_list,Update Calendar List
Gui,Add,Button,ggo vrefresh x+10,Refresh token
Gui,Add,Button,ggo vquick x+10,Quick add an Event
Gui,Add,Button,ggo vupdate x+10,Update
Gui,Add,Button,ggo vComplex x+10,Complex
Gui,Add,Button,gsend x+10,Get Calendar JSON
Gui,Add,Button,ggo vupdate_selected_calendar x+10,Update Selected Calendar
Gui,Add,Button,gdelete,Delete current event
Gui,Add,Button,gsettings x+10,Settings
Gui,Add,Edit,w800 h300 xm,%edit1%
Gui,Add,Button,ggo vj_update,Do The New Update
Gui,Color,0
pos:=settings.sn("//gui/*")
while,p:=pos.item[A_Index-1]{
	e:=sn(p,"@*")
	while,v:=e.item[A_Index-1]
	list.=v.nodename v.text " "
	GuiControl,move,% p.nodename,%list%
	if p.Text
	guicontrol,,% p.nodename,% p.text
	list=
}
window:=settings.ssn("//main")
window:=sn(window,"@*")
while,v:=window.item[A_Index-1]
position.=v.nodename v.text " "
editmode=0
color:=settings.ssn("//color").Text
color:=color?color:0
Gui,Color,% RGB(color)
position:=position?position:"AutoSize"
Gui,Show,%position%,AHK Google Calendar
Hotkey,IfWinActive,ahk_id%hwnd%
refresh_calendar()
if !set.refresh_token
auth.authgui()
auth.update_listview(1)
return
2GuiClose:
2GuiEscape:
editmode=0
Gui,2:Destroy
return
editmode:
editmode:=editmode?0:1
if editmode
WinActivate,ahk_id%hwnd%
#if WinActive("ahk_id" hwnd)&&editmode=0
~lbutton::
goto move
return
#if WinActive("ahk_id" hwnd)&&editmode
rbutton::
movea()
return
#if WinActive("ahk_id" hwnd)&&editmode
lbutton::
MouseGetPos,,,window,Control
WinGetTitle,win,ahk_id%window%
if (win="settings"){
	MouseClick,left
	return
}
movea()
edit:
Hotkey,IfWinActive,ahk_id%hwnd%
Hotkey,~LButton,move,Off
Hotkey,LButton,movea,On
return
movea:
m(A_ThisHotkey)
movea()
return
settings:
auth.authgui()
return
go:
if IsFunc(A_GuiControl)
%A_GuiControl%()
if (A_GuiControl="update"){
	d(1)
	Gui,ListView,SysListView321
	if !LV_GetNext(){
		m("Please select a calendar and an event")
		return
	}
	LV_GetText(calid,LV_GetNext())
	Gui,ListView,SysListView322
	if !LV_GetNext(){
		m("Please select a calendar and an event")
		return
	}
	LV_GetText(event,LV_GetNext())
	temp:=ComObjCreate("MSXML2.DOMDocument")
	temp.load("Calendars\" calid ".xml")
	entry:=ssn(temp,"//*[title='" event "']")
	InputBox,item,What item?,@startTime @endTime title
	event:=ssn(entry,"//" item)
	InputBox,new,Change item,Input new %item%,,,,,,,,% event.text
	event.text:=new
	body:=entry.xml
	ev:=ssn(body,"id").text
	SplitPath,ev,eventid
	http.update(calid,eventid,body)
}
if (A_GuiControl="quick"){
	Gui,3:Destroy
	Gui,3:Add,Edit,vname,Event name here
	Gui,3:Add,Text,,From
	Gui,3:Add,DateTime,x+10 vdatetime,MM/dd/yyyy HH:mm
	Gui,3:Add,Text,xm,To
	Gui,3:Add,DateTime,vtime x+10,HH:mm
	Gui,3:Add,Button,gezadd,Post it
	Gui,3:Show
	return
}
else
http[A_GuiControl]()
return
ezadd:
Gui,3:Submit
FormatTime,start,%datetime%,MM/dd/yyyy HH:mm
FormatTime,end,%time%,HH:mm
body:=name " " start "-" end
Gui,1:Default
Gui,ListView,SysListView321
LV_GetText(calid,LV_GetNext())
calid:=settings.ssn("//*[@name='" calid "']/@email").text
http.quicksend(calid,body)
return
GuiEscape:
GuiClose:
WinGet,clist,ControlList,ahk_id%hwnd%
Loop,Parse,clist,`n
{
	if InStr(A_LoopField,"sysheader")
	continue
	ControlGetPos,x,y,w,h,%A_LoopField%,ahk_id%hwnd%
	ControlGetText,text,%A_LoopField%,ahk_id%hwnd%
	settings.Add("gui/" A_LoopField,{x:x,y:y,w:w,h:h},text)
}
WinGetPos,x,y,w,h,ahk_id%hwnd%
settings.Add("main",{x:x,y:y,w:w,h:h})
settings.save()
ExitApp
return
update:



send:


lv:=getlv()
calid:=settings.ssn("//*[@name='" lv.calid "']/@email").text
temp:=ComObjCreate("MSXML2.DOMDocument")
FileRead,xml,% "calendars\" lv.calid ".xml"
temp.loadxml(xml)
find:=sn(temp,"//entry")
eventid:=find.item[lv.next-1].SelectSingleNode("id").Text
SplitPath,eventid,eventid
;m(lv.calid,lv.event,lv.next,calid,eventid)
url:="https://www.googleapis.com/calendar/v3/calendars/" calid "/events/" eventid "?access_token=" set.access_token
;url:="https://www.google.com/calendar/feeds/maestrith@gmail.com/private/full/" eventid "?access_token=" set.access_token


URLDownloadToFile,%url%,current event.xml


temp:=ComObjCreate("MSXML2.DOMDocument")
temp.load("current event.xml")
st:=ssn(temp,"//@startTime").text
InputBox,nst,New Start Time,,,,,,,,,% st
ssn(temp,"//@startTime").text:=nst





;FileRead,event,current event.xml
;m(event)
temp:=""
return



event:=RegExReplace(event,"\n","")

start=2
m(j(event,"etag"),event)
for a,b in ["start.dateTime","end.dateTime","summary","recurrence"]
j(event,b,"farts")
m(event)

return
start=now
end=later
for a,b in {start:start,end:end}{
	find=UiO)"%a%".*"(.*)".*"(.*)"
	RegExMatch(event,find,t)
	replace:=RegExReplace(t.0,t.2,b)
	event:=RegExReplace(event,t.0,replace)
}
summary=farts and candy
recurrence=RRULE:FREQ=WEEKLY
for a,b in {summary:summary,recurrence:recurrence}{
	find=UiO)"%a%".*"(.*)"
	RegExMatch(event,find,t)
	replace:=RegExReplace(t.0,t.1,b)
	StringReplace,event,event,% t.0,%replace%
}
m(event,"after")
Gui,1:Default
ControlSetText,Edit1,%event%
return






;url:="https://www.googleapis.com/calendar/v3/calendars/" id "/events?access_token=" set.access_token
;url:="https://www.googleapis.com/calendar/v3/calendars/maestrith%40gmail.com/events?access_token=" set.access_token
;co:=ComObjCreate("WinHttp.WinHttpRequest.5.1")
;co.Open("get",url)
;co.SetRequestHeader("max-results","40")
;co.Send()
;FileDelete,Calendars\%id%.xml
;fileappend,% co.ResponseText,Calendars\%id%.xml
class xml{
	__New(param*){
		ref:=param.1,root:=param.2,file:=param.3
		file:=file?file:ref ".xml",root:=!root?ref:root
		temp:=ComObjCreate("MSXML2.DOMDocument"),temp.setProperty("SelectionLanguage","XPath")
		ifexist %file%
		temp.load(file),this.xml:=temp
		else
		this.xml:=xml.CreateElement(temp,root)
		this.file:=file
		xml.xk({ref:ref,obj:this})
	}
	xk(xml=""){
		static list:=[]
		if IsObject(xml)
		return list[xml.ref]:=xml.obj
		if !xml
		return list
		if list[xml]
		return list[xml]
	}
	__Get(x=""){
		return this.xml.xml
	}
	CreateElement(doc,root){
		x:=doc.CreateElement(root),doc.AppendChild(x)
		return doc
	}
	add(path="",att="",text="",dup="",find="",under=""){
		main:=this.xml.SelectSingleNode("*")
		for a,b in find
		if found:=main.SelectSingleNode("//" path "[@" a "='" b "']"){
			for a,b in att
			found.setattribute(a,b)
			found.text:=text
			return found
		}
		if under
		{
			p:=under
			new:=this.xml.CreateElement(path),p.AppendChild(new)
			for a,b in att
			new.SetAttribute(a,b)
			if !(text="")
			new.text:=text
			return new
		}
		if p:=this.xml.SelectSingleNode(path)
		for a,b in att
		p.SetAttribute(a,b)
		else
		{
			p:=main
			Loop,Parse,path,/
			{
				total.=A_LoopField "/"
				if dup
				new:=this.xml.CreateElement(A_LoopField),p.AppendChild(new)
				else if !new:=p.SelectSingleNode("//" Trim(total,"/"))
				new:=this.xml.CreateElement(A_LoopField),p.AppendChild(new)
				p:=new
			}
			for a,b in att
			p.SetAttribute(a,b)
			if Text!=""
			p.text:=text
		}
		return p
	}
	remove(){
		this.xml:=""
	}
	save(){
		this.xml.transformNodeToObject(xml.style(),this.xml)
		this.xml.save(this.file)
	}
	transform(){
		this.xml.transformNodeToObject(xml.style(),this.xml)
	}
	ssn(node){
		return this.xml.SelectSingleNode(node)
	}
	sn(node){
		return this.xml.SelectNodes(node)
	}
	style(){
		static
		if !IsObject(xsl){
			xsl:=ComObjCreate("MSXML2.DOMDocument")
			style=
			(
			<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
			<xsl:output method="xml" indent="yes" encoding="UTF-8"/>
			<xsl:template match="@*|node()">
			<xsl:copy>
			<xsl:apply-templates select="@*|node()"/>
			<xsl:for-each select="@*">
			<xsl:text></xsl:text>
			</xsl:for-each>
			</xsl:copy>
			</xsl:template>
			</xsl:stylesheet>
			)
			xsl.loadXML(style), style:=null
		}
		return xsl
	}
	easyatt(node,notext=""){
		list:=[],nodes:=sn(node,"@*")
		while,n:=nodes.item[A_Index-1]
		list[n.nodename]:=n.text
		if !notext
		list[1]:=node.text
		return list
	}
}
ssn(node,path){
	return node.SelectSingleNode(path)
}
sn(node,path){
	return node.SelectNodes(path)
}
calendar_list(){
	upcal:
	Gui,1:Default
	Gui,1:ListView,SysListView321
	LV_GetText(current,LV_GetNext())
	url:="https://www.google.com/calendar/feeds/default/owncalendars/full?access_token=" set.access_token
	list:=URLDownloadToVar(url)
	temp:=ComObjCreate("MSXML2.DOMDocument"),temp.loadxml(list)
	list:=sn(temp,"//entry")
	LV_Delete()
	while,entry:=list.item[A_Index-1]{
		name:=ssn(entry,"title").text,email:=ssn(entry,"id").text
		timezone:=ssn(entry,"gCal:timezone/@value").Text
		splitpath,email,email
		email:=UriDecode(email)
		if !cal:=settings.ssn("//calendar[@name='" name "']")
		settings.Add("calendar",{name:name,email:email,timeZone:timezone},"",1)
	}
	settings.Transform()
	settings.save()
	refresh_calendar()
	Loop,% LV_GetCount()
	{
		LV_GetText(item,A_Index)
		if (current=item){
			LV_Modify(A_Index,"Select Vis Focus")
			break
		}
	}
	return
	;json version
	list:=settings.sn("//calendar")
	LV_GetText(current,LV_GetNext())
	LV_Delete()
	while,remove:=list.item[A_Index-1]
	remove.parentnode.removechild(remove)
	url:="https://www.googleapis.com/calendar/v3/users/me/calendarList?access_token=" set.access_token
	test:=URLDownloadToVar(url)
	FileAppend,%test%,cal list.txt
	find=UO)"(.*)".*"(.*)"
	Loop,Parse,test,`n
	{
		if RegExMatch(A_LoopField,find,t){
			if RegExMatch(t.1,"(kind|etag)")
			continue
			if (t.1="id")
			root:=settings.Add("calendar",{id:t.2},"",1),LV_Add("",t.2)
			else
			settings.Add(t.1,"",t.2,"","",root)
		}
	}
	settings.Transform()
	settings.save()
	return
}
UriDecode(Uri){
	js:=ComObjCreate("ScriptControl"),js.Language:="JScript"
	js.ExecuteStatement("var Decoded=decodeURIComponent(""" . Uri . """)")
	return js.Eval("Decoded")
}
load_settings(){
	list:={client_id:"373315280759.apps.googleusercontent.com",client_secret:"efYptUKVzK9ikufwlB3qyX_5",redirect_uri:"urn:ietf:wg:oauth:2.0:oob",grant_type:"authorization_code",client_id:"373315280759.apps.googleusercontent.com"}
	info:=["refresh_token","access_token","client_id","client_secret","redirect_uri","grant_type","client_id"]
	for a,b in info
	{
		if setting:=settings.ssn("//login/" b).text
		set[b]:=setting,%b%:=setting
		else
		set[b]:=list[b],%b%:=list[b]
	}
}
class auth{
	__New(){
		this.http:=ComObjCreate("WinHttp.WinHttpRequest.5.1")
	}
	authgui(){
		static
		Gui,2:Destroy
		Gui,2:+Owner1 +hwndsett
		Gui,2:Font,s10,Tahoma
		Gui,2:Add,Text,,1.Click "Get Authorization"`n2.Login to your Google account click on "Allow access" on the website that appears`n3.Paste the code that appears on the webpage in the box below`n4.Click "Authorize".
		Gui,2:Add,Edit,vAuthCode w450
		Gui,2:Add,Button,gGetAuth, Get Authorization
		Gui,2:Add,Button,Default ggo vAuth x+10,Authorize
		Gui,2:Add,Checkbox,geditmode veditmode xm,Edit the Gui
		Gui,2:Add,Button,gcolor,Change GUI Background Color
		Gui,2:Add,Text,,While in edit move you can left click on a control to move it, and right click on a control to resize it.`nRight click and drag anywhere in the window that is not a control to resize the window
		Gui,2:Show,,Settings
		return
		getauth:
		run % "https://accounts.google.com/o/oauth2/auth?scope=https%3A%2F%2Fwww.google.com%2Fcalendar%2Ffeeds&redirect_uri=urn:ietf:wg:oauth:2.0:oob&response_type=code&client_id=" set.client_id
		return
		color:
		newcolor:=dlg_color(settings.ssn("//color").text,sett)
		if !newcolor
		return
		Gui,1:Color,% RGB(newcolor)
		settings.Add("color","",newcolor)
		return
	}
	auth(){
		auth: ;get tokens from google
		ControlGetText,authcode,Edit1
		this.http.Open("POST","https://accounts.google.com/o/oauth2/token")
		this.http.SetRequestHeader("Content-Type", "application/x-www-form-urlencoded")
		body:="code=" AuthCode "&client_id=" set.client_id "&client_secret=" 
		. set.client_secret "&redirect_uri=" set.redirect_uri
		. "&grant_type=" set.grant_type
		this.http.Send(body)
		codes:=this.http.ResponseText
		find=UO)"(.*)".*"(.*)"
		Loop,Parse,codes,`n
		if RegExMatch(A_LoopField,find,t){
			settings.Add("login/" t.1,"",t.2)
		}
		settings.Transform()
		settings.save()
		ControlSetText,Edit2,%codes%
		load_settings()
		Gui,2:Destroy
		calendar_list()
		refresh_calendar()
		return
	}
	refresh(){
		Gui,Submit,Nohide
		url:="https://accounts.google.com/o/oauth2/token"
		this.http.Open("POST", url)
		body:="client_id=" set.client_id "&client_secret=" 
		. set.client_secret "&refresh_token=" set.refresh_token
		. "&grant_type=refresh_token"
		this.http.SetRequestHeader("Content-Type", "application/x-www-form-urlencoded")
		this.http.Send(body)
		codes:=this.http.ResponseText
		find=UO)"(.*)".*"(.*)"
		Loop,Parse,codes,`n
		if RegExMatch(A_LoopField,find,t)
		settings.Add("login/" t.1,"",t.2)
		settings.Transform()
		settings.save()
		load_settings()
		ControlSetText,Edit2,%codes%
	}
	update_selected_calendar(){
		Gui,1:Default
		Gui,ListView,SysListView321
		LV_GetText(id,LV_GetNext())
		email:=settings.ssn("//*[@name='" id "']/@email").text
		IfNotExist,Calendars
		FileCreateDir,Calendars
		url:="https://www.google.com/calendar/feeds/" email "/private/full?max-results=100&access_token=" set.access_token
		l:=0
		usc:
		URLDownloadToFile,%url%,Calendars\%id%.xml
		FileRead,read,Calendars\%id%.xml
		if InStr(read,"token expired"){
			l++
			this.refresh()
			if l<2
			goto usc
		}
		this.update_listview()
	}
	complex(){
		Gui,1:Default
		Gui,ListView,SysListView321
		LV_GetText(calid,LV_GetNext())
		calid:=settings.ssn("//*[@name='" calid "']/@email").text
		this.http.Open("POST","https://www.googleapis.com/calendar/v3/calendars/" calid "/events?access_token=" set.access_token)
		;this.http.open("POST",url)
		body:=json()
		;ControlGetText,xml,Edit1
		;FileRead,body,atomexample.xml
		this.http.SetRequestHeader("Content-Type","application/json")
		this.send_info(body)
	}
	quicksend(calid,body){
		body:=RegExReplace(body," ","+")
		url:="https://www.googleapis.com/calendar/v3/calendars/" calid "/events/quickAdd?text=" body "&access_token=" set.access_token
		this.http.Open("POST",url)
		this.send_info(body)
	}
	update(calid,eventid,temp){
		calid:=settings.ssn("//*[@name='" calid "']/@email").text
		url:="https://www.google.com/calendar/feeds/" calid "/private/full/" eventid "?access_token=" set.access_token
		this.http.Open("PUT",url)
		InputBox,title,New Title,Enter one,,,,,,,,% ssn(temp,"title").text
		if ErrorLevel
		return
		ssn(temp,"title").Text:=title
		body:=temp.xml
		this.http.SetRequestHeader("If-Match","*")
		this.http.SetRequestHeader("Content-Type","application/atom+xml")
		this.send_info(body)
	}
	send_info(body){
		this.http.Send(body)
		codes:=this.http.ResponseText
		if this.http.status!=200
		m("Something went wrong",codes)
		Gui,1:Default
		ControlSetText,Edit1,%codes%
	}
	update_listview(x=0){
		if (A_GuiEvent!="Normal"&&x=0)
		return
		Gui,1:Default
		Gui,ListView,SysListView321
		LV_GetText(id,LV_GetNext())
		Gui,ListView,SysListView322
		LV_Delete()
		temp:=ComObjCreate("MSXML2.DOMDocument")
		temp.load("Calendars\" id ".xml")
		ent:=sn(temp,"//entry")
		while,title:=ent.item[A_Index-1]{
			if re:=ssn(title,"gd:recurrence"){
				date:=ical(re.text)
				LV_Add("",ssn(title,"title").text,date,"Recurring")
				continue
			}
			LV_Add("",ssn(title,"title").text,ssn(title,"gd:when/@startTime").text,ssn(title,"gd:when/@endTime").text)
		}
		loop,3
		LV_ModifyCol(A_Index,"AutoHDR")
		ControlSetText,Edit1,%xml%
		return
	}
	j_update(){
		fileread,body,fixed c xml.xml
		pos:=RegExMatch(body,Chr(34) "start" Chr(34))
		regex(pos,body,y)
		RegExMatch(y,"i)datetime" Chr(34) "(.*)",found)
		url:="https://www.googleapis.com/calendar/v3/calendars/maestrith@gmail.com/events/b51qo7vlmku3t8a8abbniisj0s?access_token=" set.access_token
		this.http.Open("PUT",url)
		this.http.SetRequestHeader("Content-Type","application/json")
		http.send_info(body)
	}
}
json(id=""){
	Gui,ListView,SysListView321
	LV_GetText(id,LV_GetNext())
	startdate:=a_yyyy "-" A_MM "-" A_DD "T" A_Hour ":" A_Min ":" A_Sec "-05:00"
	enddate:=a_yyyy "-" A_MM "-" A_DD "T" A_Hour+1 ":" A_Min ":" A_Sec "-05:00"
	summary=Placed with my program
	s:=settings.sn("//calendar[@name='" id "']/@*")
	while,list:=s.item[A_Index-1]
	nn:=list.nodename,%nn%:=list.text
	minutes:=60
	json=
	(
	{
		"kind": "calendar#event",
		"status": "confirmed",
		"summary": "%summary%",
		"creator": {
			"email": "%email%",
			"displayName": "%summary%",
			"self": true
		},
		"start": {
			"dateTime": "%startdate%",
			"timeZone": "%timezone%"
		},
		"end": {
			"dateTime": "%enddate%",
			"timeZone": "%timezone%"
		},
		"sequence": 0,
		"reminders": {
			"useDefault": false,
			"overrides": [
			{
				"method": "popup",
				"minutes": "%minutes%"
			}
			]
		}
	}
	)
	return json
}
refresh_calendar(){
	Gui,1:Default
	Gui,ListView,SysListView321
	LV_Delete()
	list:=settings.sn("//calendar")
	while,item:=list.item[A_Index-1]
	LV_Add("",ssn(item,"@name").text)
	LV_Modify(1,"select focus")
}
d(x){
	Gui,%x%:Default
}
ical(ical){
	RegExMatch(ical,"iU)dtstart(.*)\n",found)
	return RegExReplace(found,"[^0-9]")
}
getlv(){
	Gui,ListView,SysListView321
	LV_GetText(calid,LV_GetNext())
	Gui,ListView,SysListView322
	LV_GetText(event,LV_GetNext())
	return id:={calid:calid,event:event,next:LV_GetNext()}
}
j(ByRef js, s, v = "") {
	j = %js%
	Loop, Parse, s, .
	{
		p = 2
		RegExMatch(A_LoopField, "([+\-]?)([^[]+)((?:\[\d+\])*)", q)
		Loop {
			If (!p := RegExMatch(j, "(?<!\\)(""|')([^\1]+?)(?<!\\)(?-1)\s*:\s*((\{(?:[^{}]++|(?-1))*\})|(\[(?:[^[\]]++|(?-1))*\])|"
			. "(?<!\\)(""|')[^\7]*?(?<!\\)(?-1)|[+\-]?\d+(?:\.\d*)?|true|false|null?)\s*(?:,|$|\})", x, p))
			Return
			Else If (x2 == q2 or q2 == "*") {
				j = %x3%
				z += p + StrLen(x2) - 2
				If (q3 != "" and InStr(j, "[") == 1) {
					StringTrimRight, q3, q3, 1
					Loop, Parse, q3, ], [
					{
						z += 1 + RegExMatch(SubStr(j, 2, -1), "^(?:\s*((\[(?:[^[\]]++|(?-1))*\])|(\{(?:[^{\}]++|(?-1))*\})|[^,]*?)\s*(?:,|$)){" . SubStr(A_LoopField, 1) + 1 . "}", x)
						j = %x1%
					}
				}
				Break
			}
			Else p += StrLen(x)
		}
	}
	If v !=
	{
		vs = "
		If (RegExMatch(v, "^\s*(?:""|')*\s*([+\-]?\d+(?:\.\d*)?|true|false|null?)\s*(?:""|')*\s*$", vx)
		and (vx1 + 0 or vx1 == 0 or vx1 == "true" or vx1 == "false" or vx1 == "null" or vx1 == "nul"))
		vs := "", v := vx1
		StringReplace, v, v, ", \", All
		js := SubStr(js, 1, z := RegExMatch(js, ":\s*", zx, z) + StrLen(zx) - 1) . vs . v . vs . SubStr(js, z + StrLen(x3) + 1)
	}
	Return, j == "false" ? 0 : j == "true" ? 1 : j == "null" or j == "nul"
	? "" : SubStr(j, 1, 1) == """" ? SubStr(j, 2, -1) : j
}
regex(ByRef p,ByRef j,ByRef x){
	If (!p := RegExMatch(j, "(?<!\\)(""|')([^\1]+?)(?<!\\)(?-1)\s*:\s*((\{(?:[^{}]++|(?-1))*\})|(\[(?:[^[\]]++|(?-1))*\])|"
	. "(?<!\\)(""|')[^\7]*?(?<!\\)(?-1)|[+\-]?\d+(?:\.\d*)?|true|false|null?)\s*(?:,|$|\})", x, p))
	return 0
	return p
}
rename:
MouseGetPos,,,,Control
if InStr(control,"button"){
	InputBox,new,Rename Button,New name?
	GuiControl,,%control%,%new%
}
return
move:
CoordMode,pixel,Screen
MouseGetPos,x,y,window,control
WinGetPos,xx,yy,w,h,ahk_id%window%
offset:={x:xx-x,y:yy-y}
CoordMode,Mouse,Screen
if InStr(control,"msctls_progress32"){
	loop,12
	GuiControl,-Background,msctls_progress32%A_Index%
	GuiControl,+Backgroundffffff,%control%
	PixelGetColor,color,%x%,%y%,RGB
	settings.Add("color","",color)
	Gui,Color,%color%
}
else if !control
while,GetKeyState("LButton","P"){
	MouseGetPos,x,y
	WinMove,ahk_id%window%,,% offset.x+x,% offset.y+y
}
return
movea(){
	static editmode
	global hwnd
	MouseGetPos,x,y,window,control
	if InStr(Control,"sysheader")||InStr(Control,"progress")
	return
	if (window!=hwnd){
		MouseClick,Left
		return
	}
	if (control=""&&InStr(A_ThisHotkey,"RButton")){
		CoordMode,Mouse,Screen
		WinGetPos,x,y,,,ahk_id%hwnd%
		while,GetKeyState("RButton","P"){
			MouseGetPos,xx,yy
			WinMove,ahk_id%hwnd%,,,,% xx-x,% yy-y
		}
	}
	if InStr(A_ThisHotkey,"LButton"){
		if (control){
			CoordMode,Mouse,Relative
			MouseGetPos,x,y
			ControlGetPos,xx,yy,,,%control%,ahk_id%hwnd%
			offsetx:=xx-x,offsety:=yy-y
			while,GetKeyState("LButton","P"){
				MouseGetPos,x,y
				ControlMove,%control%,% offsetx+x,% offsety+y,"","",ahk_id%window%
			}
			CoordMode,Mouse,Screen
		}
	}
	if InStr(A_ThisHotkey,"RButton"){
		CoordMode,Mouse,Relative
		MouseGetPos,,,win,control
		if Control
		{
			ControlGetPos,xx,yy,,,%control%,ahk_id%win%
			while,GetKeyState("RButton","P"){
				MouseGetPos,x,y
				ControlMove,%control%,,,% x-xx,% y-yy,ahk_id%win%
			}
			CoordMode,Mouse,Screen
		}
	}
	WinSet,Redraw
}
t(x*){
	for a,b in x
	list.=b "`n"
	ToolTip,%list%
}
m(x*){
	for a,b in x
	list.=b "`n"
	MsgBox,% list
}
URLDownloadToVar(url){
	co:=ComObjCreate("WinHttp.WinHttpRequest.5.1")
	co.Open("get",url)
	co.Send()
	return co.ResponseText
}
delete:
Gui,ListView,SysListView321
if !LV_GetNext(){
	m("Please select a calendar and an event")
	return
}
LV_GetText(calid,LV_GetNext())
Gui,ListView,SysListView322
if !LV_GetNext(){
	m("Please select a calendar and an event")
	return
}
LV_GetText(event,LV_GetNext())
temp:=ComObjCreate("MSXML2.DOMDocument")
temp.load("Calendars\" calid ".xml")
entry:=ssn(temp,"//*[title='" event "']")
calendarid:=settings.ssn("//*[@name='" calid "']/@email").text
eid:=ssn(entry,"id").text
SplitPath,eid,eventid
SplashTextOn,200,50,Removing entry,Please Wait
url:="https://www.googleapis.com/calendar/v3/calendars/" calendarId "/events/" eventId "?access_token=" set.access_token
h:=ComObjCreate("WinHttp.WinHttpRequest.5.1")
h.Open("DELETE", url)
h.Send()
SplashTextOff
http.update_selected_calendar()
return
Dlg_Color(Color=0,hwnd=""){
	VarSetCapacity(CHOOSECOLOR,0x24,0),VarSetCapacity(CUSTOM,64,0)
	for a,b in {0:0x24,4:hwnd,12:color,16:&custom,20:0x00000103}
	NumPut(b,choosecolor,a)
	nRC:=DllCall("comdlg32\ChooseColorA",str,CHOOSECOLOR)
	if !nRC
	return "cancelled"
	setformat,integer,H
	clr:=NumGet(CHOOSECOLOR,12)
	setformat,integer,D
	return %clr%
}
rgb(c){
	setformat,IntegerFast,H
	c:=(c&255)<<16|(c&65280)|(c>>16)
	SetFormat, integerfast,D
	return c
}