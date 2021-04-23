#SingleInstance,Force
v:=[],OnMessage(0x4E,"notify"),OnMessage(0x5,"arrange"),vversion:=new xml("version","lib\version.xml"),v.startup:=1
startup(),filecheck(),v.lastlist:=[],misc:=new xml("misc")
settings:=new xml("settings","lib\settings.xml"),keywords(),files:=new xml("files"),positions:=new xml("positions","lib\positions.xml"),access_token:=settings.ssn("//access_token").text
idea:=new xml("idea","lib\ideas.xml")
global v,sci,settings,commands,files,positions,vversion,access_token,misc,idea
menu(),defaults(),gui(),hotkeys(),titlechange()
ControlFocus,Scintilla1,% aid()
if settings.ssn("//ideas").text{
	ideas()
	WinActivate,% aid()
}
v.startup:=0
;setup(22) <---next available
OnExit,exit
return
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
Msgbox_Creator(){
	static
	msgbox:=setup(17)
	Gui,Add,Text,Section hwndheight,Title:
	h:=cgp(height).h*1.25
	Gui,Add,Edit,w320
	Gui,Add,Text,,Text:
	Gui,Add,Edit,w320 hwndedit
	pos:=cgp(edit)
	Gui,Add,GroupBox,% "x" pos.x " y" pos.y+pos.h+10 " w320 R8 hwndgb Section",Buttons and Icons
	Gui,Add,Radio,xs+10 ys+%h% Checked,OK
	list=OK/Cancel,Abort/Retry/Ignore,Yes/No/Cancel,Yes/No,Retry/Cancel,Cancel/Try Again/Continue
	Loop,Parse,list,`,
	Gui,Add,Radio,hwndlast,%A_LoopField%
	Gui,Add,Checkbox,,Help
	pos:=cgp(last),nx:=pos.x+pos.w+20
	for a,b in [4,3,2,5]
	if A_Index=1
	Gui,Add,Picture,x%nx% ys+%h% Icon4 Section,%A_WinDir%\system32\user32.dll
	else
	Gui,Add,Picture,Icon%b% ,%A_WinDir%\system32\user32.dll
	color:=RGB(settings.ssn("//font[@style='5']/@background").text)
	Gui,Color,%color%,%color%
	Gui,Add,Radio,y+10 Checked vicon1,No Icon
	Gui,Add,Radio,ys+8 xs+40 section vicon2
	Gui,Add,Radio,ys+40 section xs vicon3
	Gui,Add,Radio,ys+40 section xs vicon4
	Gui,Add,Radio,ys+40 xs vicon5
	Gui,Add,GroupBox,ym x340 R4 Section hwndgb1,Modal
	Gui,Add,Radio,xs+10 ys+%h% Checked,Normal
	Gui,Add,Radio,,Task Modal
	Gui,Add,Radio,,Always On Top
	Gui,Add,Radio,,System Modal
	pos:=cgp(gb1)
	Gui,Add,GroupBox,% "x" pos.x " y" pos.y+pos.h " R1 hwndgb2 Section",Default Button
	Gui,Add,Radio,xs+10 ys+%h% Checked,1st
	Gui,Add,Radio,x+10,2nd
	Gui,Add,Radio,x+10,3rd
	pos:=cgp(gb2)
	Gui,Add,GroupBox,% "x" pos.x " y" pos.y+pos.h " R1 hwndgb3 Section",Alignment
	Gui,Add,Checkbox,xs+10 ys+%h%,Right
	Gui,Add,Checkbox,x+10,Reverse
	pos:=cgp(gb3)
	Gui,Add,GroupBox,% "x" pos.x " y" pos.y+pos.h " R3 hwndgb4 Section",Timeout and Insert
	Gui,Add,Text,xs+10 ys+%h% Section,Timeout:
	Gui,Add,Edit,w50 x+5 number
	Gui,Add,Button,x+5 hwndthird gmbcopy,Copy
	Gui,Add,Button,xs gmbtest Default,Test
	Gui,Add,Button,x+5 gmbinsert,Insert
	Gui,Add,Button,x+5 gmbreset,Reset
	pos:=cgp(third),pos1:=cgp(gb1),w:=pos.x+pos.w+10-pos1.x
	Loop,4
	{
		con:=gb%A_Index%
		ControlMove,,,,%w%,,ahk_id%con%
	}
	Gui,Show,AutoSize,Msgbox Creator
	return
	mbcopy:
	Clipboard:=compilebox(msgbox)
	MsgBox,0,Complete,Text coppied to the clipboard,.5
	return
	mbreset:
	Loop,3
	ControlSetText,Edit%A_Index%,,% aid(msgbox)
	for a,b in {2:1,10:1,16:1,21:1,9:0,25:0,26:0}
	GuiControl,17:,Button%a%,%b%
	return
	mbinsert:
	v.sc.2003(v.sc.2008,compilebox(msgbox))
	return
	17GuiEscape:
	17GuiClose:
	Destroy(17)
	return
	mbtest:
	dynarun(compilebox(msgbox))
	return
}
compilebox(win){
	static list:={2:0,3:1,4:2,5:3,6:4,7:5,8:6,9:16384,11:16,12:32,13:48
	,14:64,17:8192,18:262144,19:4096,22:256,23:512,25:524288,26:1048576}
	total=0
	for a,b in ["Edit1","Edit2","Edit3"]
	ControlGetText,edit%a%,Edit%a%,% aid(win)
	for a,b in list{
		ControlGet,value,Checked,,Button%a%
		if value
		total+=b
	}
	edit1:=edit1?edit1:"Testing"
	msg=MsgBox,%total%,%edit1%,%edit2%
	msg.=edit3?"," edit3:""
	return msg
}
cgp(Control){
	SysGet,Border,7
	SysGet,Caption,4
	pos:=[]
	ControlGetPos,x,y,w,h,,ahk_id%control%
	return pos:={x:x-border,y:y-Border-Caption,w:w,h:h}
}
notify(wp,info,c,d){
	Critical
	foo:=NumGet(info,8,UInt)
	if v.fix
	return
	sc:=v.sc
	if sc.sc!=NumGet(info+0)
	return
	static last
	fn:=[]

	;,2:"id",4:"position",5:"ch",6:"modifiers",7:"modType",8:"text",9:"length",10:"linesAdded",11:"macMessage",12:"macwParam",13:"maclParam",14:"line",15:"foldLevelNow",16:"foldLevelPrev",17:"margin",18:"listType",19:"x",20:"y",21:"token",22:"annotLinesAdded",23:"updated"}
	for a,b in {0:"Obj",2:"Code",4:"ch",7:"text",6:"modType",9:"linesadded",3:"position"}
	fn[b]:=NumGet(Info+(A_PtrSize*a))
	cp:=sc.2008
	if (fn.code=2019){
		v.lastmod:=NumGet(info+20)
	}
	if (fn.code=2008){
		if fn.modtype&0x20
		return
		if fn.modtype&0x02&&fn.linesadded
		SetTimer,fix_indent,1
		if ((fn.modtype&0x01)||(fn.modtype&0x02))
		update({file:ssn(current(),"@file").text,sc:sc})
	}
	if (fn.code=2022){
		v.word:=StrGet(fn.text,cp0)
		settimer,automenu,20
		return
	}
	if (fn.code=2027){
		font()
		return
	}
	if (fn.code=2001){
		c:=fn.ch
		if c=13
		return
		sc.2078
		if c in 10,123,125
		fix_indent(sc,1)
		if (v.options.auto_indent!=1&&c=10){
			line:=sc.2166(cp)-1
			indent:=sc.2127(line)
			sc.2126(line+1,indent)
		}
		if (c=10){
			start:=sc.2128(sc.2166(sc.2008))
			sc.2160(start,start)
		}
		word:=sc.textrange(sc.2266(cp-1,1),sc.2267(cp-1,1))
		li:=""
		if (StrLen(word)>1&&sc.2102=0){
			ll:=v.keywords[SubStr(word,1,1)]
			Loop,Parse,ll,%a_space%
			if RegExMatch(A_LoopField,"Ai)" word)
			li.=A_LoopField " "
			if li
			sc.2100(StrLen(word),Trim(li))
		}
		;here add an option to add more than just a "," to the list "(" is automatic
		lll=44,32
		if c in %lll%
		replace()
		sc.2079
		SetTimer,ss,1
	}
	if (fn.code=2007){
		
		if (v.options.show_selected_duplicates){
			if (cp!=sc.2009)
			highlt(sc.getseltext())
			else
			sc.2505(0,sc.2006)
		}
		text:="Line:" sc.2166(sc.2008)+1 " Column:" sc.2129(sc.2008)
		width:=sc.2276(32,"a")
		SB_SetText(text)
		SB_SetParts(width*StrLen(text "1"),last)
		first:=width*StrLen(text "1")
	}
	if (fn.code=2001){
		width:=sc.2276(32,"a")
		text1:="Last Entered Character: " Chr(fn.ch) " Code:" fn.ch
		SB_SetText(text1,2),SB_SetParts(first,width*StrLen(text1 1),40)
		last:=width*StrLen(text1 1)
	}
	if (fn.code=2010){
		margin:=NumGet(info+64)
		scpos:=NumGet(info+12)
		modifier:=NumGet(info+20)
		if margin=2
		sc.2231(sc.2166(scpos))
		if (margin=0)
		margincolor(modifier)
	}
	marginwidth()
	return
	fix_indent:
	SetTimer,fix_indent,Off
	if v.fix
	return
	fix_indent(v.sc)
	return
}
automenu(){
	automenu:
	SetTimer,automenu,Off
	if v.word
	if (l:=commands.ssn("//Context/*/*[text()='" RegExReplace(v.word,"#") "']/@list").text){
		sc:=v.sc,cp:=sc.2008
		if sc.2007(cp-1)!=44
		sc.2003(cp,","),add=1
		sc.2160(cp+add,cp+add)
		sc.2100(0,l)
		v.word:=""
	}
	return
}
highlt(find){
	sc:=v.sc
	sc.2500(1),sc.2504(1,1),sc.2505(0,sc.2006)
	sc.2080(1,8)
	create:=1
	sc.2523(1,110)
	sc.2500(1),out:=sc.gettext(),found:=1,findreg:="\Q" find "\E"
	case:="i"
	while found:=RegExMatch(out,"O" case ")" findreg,fo,found){
		if sel.sel
		if (found+fo.len()-1>sel.oe)
		break
		sc.2504(fo.pos()-1,strlen(find)),found+=fo.len()
		if !fo.len()
		break
		count:=A_Index
	}
	if count=1
	sc.2500(1),sc.2504(1,0),sc.2505(0,sc.2006),dupsel:=0
}
Dlg_Color(Color,hwnd){
	static
	if !cc{
		VarSetCapacity(cccc,16*A_PtrSize,0),cc:=1,size:=VarSetCapacity(CHOOSECOLOR,9*A_PtrSize,0)
		Loop,16{
			IniRead,col,color.ini,color,%A_Index%,0
			NumPut(col,cccc,(A_Index-1)*4,"UInt")
		}
	}
	NumPut(size,CHOOSECOLOR,0,"UInt"),NumPut(hwnd,CHOOSECOLOR,A_PtrSize,"UPtr")
	,NumPut(Color,CHOOSECOLOR,3*A_PtrSize,"UInt"),NumPut(3,CHOOSECOLOR,5*A_PtrSize,"UInt")
	,NumPut(&cccc,CHOOSECOLOR,4*A_PtrSize,"UPtr")
	ret:=DllCall("comdlg32\ChooseColorW","UPtr",&CHOOSECOLOR,"UInt")
	if !ret
	exit
	Loop,16
	IniWrite,% NumGet(cccc,(A_Index-1)*4,"UInt"),color.ini,color,%A_Index%
	IniWrite,% Color:=NumGet(CHOOSECOLOR,3*A_PtrSize,"UInt"),color.ini,default,color
	return Color
}
rgb(c){
	setformat,IntegerFast,H
	c:=(c&255)<<16 | (c&65280) | (c>>16),c:=SubStr(c,1)
	SetFormat, integerfast,D
	return c
}
color(con){
	list:={Font:2056,Size:2055,Color:2051,Background:2052,Bold:2053,Italic:2054,Underline:2059}
	nodes:=settings.sn("//fonts/*")
	while,n:=nodes.item(A_Index-1){
		ea:=settings.easyatt(n)
		if (ea.style=33)
		for a,b in [2290,2291]
		con[b](1,ea.Background)
		ea.style:=ea.style=5?32:ea.style
		for a,b in ea{
			if list[a]
			con[list[a]](ea.style,b)
			else if ea.code&&ea.bool!=1
			con[ea.code](ea.color,0)
			else if ea.code&&ea.bool
			con[ea.code](ea.bool,ea.color)
			if ea.style=32
			con.2050
		}
	}
	for a,b in [[2040,25,13],[2040,26,15],[2040,27,11],[2040,28,10],[2040,29,9],[2040,30,12],[2040,31,14],[2244,2,0xFE000000],[2242,0,0],[2242,2,13],[2460,3],[2462,1],[2134,1],[2260,1],[2246,2,1],[2115,1],[2242,1,0]]
	con[b.1](b.2,b.3)
	if !settings.ssn("//*[@style='37']")
	con.2051(37,0xff00ff)
	con.2132(1)
	con.2242(2,13),con.2077(0,"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ#_")
	con.2115(1),con.2036(5)
	con.2056(38,"Tahoma"),con.2212,con.2371,con.4006(0,"asm")
	Loop,3
	con.4005(A_Index,RegExReplace(v.keywords[A_Index],"#"))
	ll:=settings.sn("//fonts/highlight/*")
	while,l:=ll.item(A_Index-1)
	con.4005(ssn(l,"@list").text+3,l.text)
	con.2470(80)
	if !settings.ssn("//*[@style='0']")
	con.2051(0,0xffffff)
	;if !settings.ssn("//*[@code='2098']")
}
arrange(a="",b="",c="",d=""){
	win:=A_Gui||a=1?v.main:d
	win:=d?d:win
	VarSetCapacity(size,16,0),DllCall("user32\GetClientRect","uint",win,"uint",&size),w:=NumGet(size,8),h:=NumGet(size,12)
	if (A_Gui=1||a=1){
		count:=v.control.maxindex(),cew:=settings.ssn("//code_explorer").text,cew:=cew?cew:100
		few:=settings.ssn("//file_explorer").text,few:=few?few:220
		each:=(w-few-cew)/count
		GuiControl,1:move,SysTreeView321,% "h" h-40 " w" few
		few+=20
		for a,b in v.control
		GuiControl,1:move,Scintilla%a%,% "w" each " x" ((A_Index-1)*each)+few " h" h-40
		GuiControl,1:Move,SysTreeView322,% "h" h-40 " x" (count*each)+few+10 " w" cew-40
	}
	else if v.window[A_Gui]
	for a,b in v.window[A_Gui]{
		list:=""
		for c,d in b{
			if c=w
			list.=c w-d " "
			if c=h
			list.=c h-d " "
			if c=x
			list.=c w-d " "
			if c=y
			list.=c h-d " "
		}
		Gui,%a_gui%:show
		GuiControl,%A_Gui%:movedraw,%a%,% list
	}
}
exit(){
	exit:
	GuiClose:
	savegui(),getpos()
	t("Saving Settings")
	for a,b in xml.keep{
		if a in files,commands,scintilla,misc,foundinfo,explore
		continue
		b.Transform(),b.save()
	}
	ToolTip
	ExitApp
	return
}
savegui(){
	rem:=settings.remove("//last")
	for a,b in v.lastlist
	settings.add({path:"last/file",text:b,dup:1})
	open:=files.sn("//main/@file")
	while,filename:=open.item(A_Index-1).text
	settings.unique({path:"open/file",text:filename})
	WinGet,max,MinMax,% aid()
	if max
	settings.add({path:"gui/position",att:{window:1,number:v.control.MaxIndex(),max:max}})
	else
	settings.add({path:"gui/position",att:{window:1,number:v.control.MaxIndex(),max:max},text:winpos(v.main)})
}
Add:
sc:=new s
arrange(1),marginwidth(sc)
return

class xml{
	keep:=[]
	__New(param*){
		root:=param.1,file:=param.2
		file:=file?file:root ".xml"
		temp:=ComObjCreate("MSXML2.DOMDocument"),temp.setProperty("SelectionLanguage","XPath")
		this.xml:=temp
		ifexist %file%
		temp.load(file),this.xml:=temp
		else
		this.xml:=this.CreateElement(temp,root)
		this.file:=file
		xml.keep[root]:=this
	}
	CreateElement(doc,root){
		return doc.AppendChild(this.xml.CreateElement(root)).parentnode
	}
	lang(info){
		info:=info=""?"XPath":"XSLPattern"
		this.xml.temp.setProperty("SelectionLanguage",info)
	}
	unique(info){
		if (info.check&&info.text)
		return
		if info.under{
			if info.check
			find:=ssn(info.under,"*[@" info.check "='" info.att[info.check] "']")
			if info.Text
			find:=ssn(info.under,"*[text()='" info.text "']")
			if !find
			find:=this.under({under:info.under,att:info.att,node:info.path})
			for a,b in info.att
			find.SetAttribute(a,b)
		}
		else
		{
			if info.check
			find:=this.ssn("//" info.path "[@" info.check "='" info.att[info.check] "']")
			else if info.text
			find:=this.ssn("//" info.path "[text()='" info.text "']")
			if !find
			find:=this.add({path:info.path,att:info.att,dup:1})
			for a,b in info.att
			find.SetAttribute(a,b)
		}
		if info.text
		find.text:=info.text
		return find
		;can have EITHER info.check or info.text, not both
	}
	add(info){
		path:=info.path,p:="/",dup:=this.ssn("//" path)?1:0
		if next:=this.ssn("//" path)?this.ssn("//" path):this.ssn("//*")
		Loop,Parse,path,/
		last:=A_LoopField,p.="/" last,next:=this.ssn(p)?this.ssn(p):next.appendchild(this.xml.CreateElement(last))
		if (info.dup&&dup)
		next:=next.parentnode.appendchild(this.xml.CreateElement(last))
		for a,b in info.att
		next.SetAttribute(a,b)
		if info.text!=""
		next.text:=info.text
		return next
	}
	find(info){
		if info.att.1&&info.text
		return m("You can only search by either the attribut or the text, not both")
		search:=info.path?"//" info.path:"//*"
		for a,b in info.att
		search.="[@" a "='" b "']"
		if info.text
		search.="[text()='" info.text "']"
		current:=this.ssn(search)
		return current
	}
	under(info){
		new:=info.under.appendchild(this.xml.createelement(info.node))
		for a,b in info.att
		new.SetAttribute(a,b)
		new.text:=info.text
		return new
	}
	ssn(node){
		return this.xml.SelectSingleNode(node)
	}
	sn(node){
		return this.xml.SelectNodes(node)
	}
	__Get(x=""){
		return this.xml.xml
	}
	transform(){
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
			xsl.loadXML(style),style:=null
		}
		this.xml.transformNodeToObject(xsl,this.xml)
	}
	save(x*){
		if x.1=1
		this.Transform()
		filename:=this.file?this.file:x.1.1
		file:=fileopen(filename,"rw")
		file.seek(0)
		file.write(this.xml.xml)
		file.length(file.position)
	}
	remove(rem){
		if !IsObject(rem)
		rem:=this.ssn(rem)
		rem.ParentNode.RemoveChild(rem)
	}
	ea(path){
		list:=[]
		nodes:=this.sn(path "/@*")
		while,n:=nodes.item(A_Index-1)
		list[n.nodename]:=n.text
		return list
	}
	easyatt(path){
		list:=[]
		if nodes:=path.nodename
		nodes:=path.SelectNodes("@*")
		else if path.text
		nodes:=this.sn("//*[text()='" path.text "']/@*")
		else
		for a,b in path
		nodes:=this.sn("//*[@" a "='" b "']/@*")
		while,n:=nodes.item(A_Index-1)
		list[n.nodename]:=n.text
		return list
	}
}
ssn(node,path){
	return node.SelectSingleNode(path)
}
sn(node,path){
	return node.SelectNodes(path)
}
aid(hwnd=""){
	hwnd:=hwnd?hwnd:v.main
	return "ahk_id" hwnd
}
menu(){
	SplitPath,A_AhkPath,,apdir
	x64:=FileExist(apdir "\AutoHotkeyU64.exe")?{"Run x6&4":"!4"}:""
	menu:=["File","Edit","Window","Options","Tools","Special_Functions","About"]
	File:=[{"&New Project":"^N"},{"N&ew Segment":"^G"},{"Remove Curren&t Segment":""}
	,{sep:1},{"Co&mpile":"!M"},{"&Upload":"!^U"},{"Check For New &Version":"!^V"}
	,{sep:1},{"&Open":"^O"},{"Open In New &Window":"!^O"},{"&Close":"!^C"},{"&Save":"^S"},{"Open Fol&der":"^D"},{"S&how File":""},{"&Run":"^R"},{"Run Se&lected Text":""},{Export:""},x64
	,{sep:1},{"Full Backup":"^F1"},{"Clean Position Data":"!P"}
	,{sep:1},{"&Publish":"!^P"}
	,{"E&xit":"!^X"}]
	Edit:=[{"The&me":"^M"},{"&Settings":"F8"},{"Edit Version Info":""}
	,{sep:1},{"Und&o":"^Z"},{"&Copy":"^C"},{"Cu&t":"^X"},{"Past&e":"^V"},{"&Restore Current File":""}
	,{sep:1},{"&Find":"^F"},{"&Quick Find":"!Q"}
	,{sep:1},{"Insert F&unction":"!U"},{"Fi&x Indent":"!X"}
	,{sep:1},{"Jump to Segment":"!J"},{"Jump to Script":"!S"}
	,{sep:1},{"Ed&it Replacements":"!^I"},{"&Google Search Selected":"!G"},{"Custom &Highlight Text":"!^H"},{"&Auto Insert":"!+A"}]
	Window:=[{"Personal Variable List":"F4"},{"Refresh Code Explorer":""},{Ideas:""},{Widths:""},{"Clipboard Viewer":""}]
	Options:=[{"Auto Indent":""},{"Virtual Space":""},{"Line Highlight":""},{"Show End Of Line":""}
	,{"Show Selected Duplicates":""},{"Word Wrap":""}]
	Tools:=[{"Post All In One Gist":"^H","Post Multiple Segment Gist":"!^M"},{"Gist Post Version":""},{"Msgbox Creator":""}]
	about:=[{About:""},{Help:""}]
	special_functions:=[{"Linked Scroll Down":"^Down"},{"Linked Scroll Up":"^Up"}
	,{sep:1},{"Move Selected Lines Down":"+^Down"},{"Move Selected Lines Up":"+^Up"},{"Duplicate Line":"F3"}
	,{sep:1},{"Toggle Comment Line":"^J"},{"Create Comment Block":"+F1"},{"Ch&aracter Count":"!+C"}
	,{sep:1},{"&Remove Spaces From Selected":"!^R"}
	,{sep:1},{"Scintilla Code Lookup":"F6"},{"Show Scintilla Code in Line":"F5"}]
	v.menu:=menu
	for a,b in ["File","Edit","Window","Options","Tools","Special_Functions","About"]
	v.menu[b]:=%b%
	;^N,^S,^D,^R,^X,^Z,^U,^O,^M,^J,^G,^F,^C,^H
	;!S,!X,!U,!J,!Q,!P,!M,!G,
	;!^U,!^X,!^O,!^I,!^V,!^M,!^H
	;!^P,!^C,!+C,!^R
	;F6,F5,+F1,F8,^F1,F3,F4
	;^+A,^Up/Down
	Gui,1:Default
	for a,b in menu{
		for c,d in %b%
		for e,f in d{
			if (e="sep"){
				menu,%b%,Add
				continue
			}
			f:=settings.ssn("//hotkeys/" clean(e)).text?settings.ssn("//hotkeys/" clean(e)).text:f
			item:=f="null"?e:e "`t" change(f)
			b:=RegExReplace(b,"_"," ")
			Menu,%b%,Add,%item%,total
			if (b="options"&&option:=settings.ssn("//options/" clean(e)).text)
			Menu,%b%,ToggleCheck,%item%
		}
		if !IsObject(b)
		Menu,Main,Add,%b%,:%b%
	}
	code_vault(1)
	Gui,Menu,main
	return
	total:
	r:=clean(A_ThisMenuItem)
	if !(A_ThisMenu="options")
	return %r%()
	options(r)
	return
}
change(key){
	for a,b in [{Shift:"+"},{Ctrl:"^"},{Alt:"!"}]
	for c,d in b
	key:=RegExReplace(key,"\" d,c "+")
	return key
}
run(){
	sc:=v.sc
	getpos(),save()
	file:=ssn(current(1),"@file").text
	SplitPath,file,filename,dir
	run,%filename%,%dir%
}
save(){
	sc:=v.sc,udf:=update({get:1})
	t("Saving Files")
	for Filename in update:=update({up:1}){
		text:=udf[filename]
		main:=files.ssn("//file[@file='" filename "']../@file").text
		SplitPath,main,,dir
		splitpath,filename,file
		backup:=dir "\backup\" A_Now
		FileCreateDir,%backup%
		if files.ssn("//main[@file='" filename "']")
		text.=compile_main(filename)
		IfExist,%filename%
		FileMove,%filename%,%backup%\%file%
		file:=fileopen(filename,"rw")
		file.seek(0)
		file.write(text)
		file.length(file.position)
	}
	t()
	update({clear:1})
}
compile_main(filename){
	fn:=files.sn("//*[@file='" filename "']/*")
	while,f:=fn.item(A_Index-1)
	text.="`r`n" ssn(f,"@code").text
	return text
}
clean(x,y=""){
	if !y
	rep:=RegExReplace(RegExReplace(RegExReplace(x,"&")," ","_"),"\t.*")
	else
	rep:=RegExReplace(RegExReplace(RegExReplace(x,"&"),"_"," "),"\t.*")
	return rep
}
hotkeys(){
	Hotkey,IfWinActive,% aid()
	Hotkey,^c,copy,On
	for a,b in v.menu
	for c,d in b
	for e,f in d{
		if e=sep
		continue
		if !key:=settings.ssn("//hotkeys/" clean(e)).text
		key:=f,settings.Add({path:"hotkeys/" clean(e),text:f})
		key:=key?key:"null"
		if key!=null
		Hotkey,%key%,hotkey,On
	}
	brace:=[]
	autoadd:=settings.sn("//autoadd/*")
	while,aa:=autoadd.item(a_index-1)
	ea:=xml.easyatt(aa),brace.insert(Chr(ea.trigger))
	for a,b in brace
	Hotkey,%b%,brace,On
	Hotkey,^v,paste,On
	v.brace:=[]
	autoadd:=settings.sn("//autoadd/*")
	while,aa:=autoadd.item(a_index-1)
	ea:=xml.easyatt(aa),v.brace[Chr(ea.trigger)]:=Chr(ea.add)
	return
	hotkey:
	key:=settings.ssn("//hotkeys/*[text()='" A_ThisHotkey "']").nodename,%key%()
	return
	brace:
	sc:=v.sc,cp:=sc.2008,line:=sc.2166(cp),min:=mm(sc)
	if (A_ThisHotkey="{"&&sc.2128(line)=cp&&cp=sc.2136(line)){
		sc.2003(cp,"{`r`n`r`n}")
		fix_indent(sc,1)
		Send,{Down}
		sc.2314
	}
	else
	sc.2003(min.min,A_ThisHotkey),sc.2003(min.max+1,v.brace[A_ThisHotkey]),sc.2160(min.min+1,min.min+1)
	width:=sc.2276(32,"a")
	text1:="Last Entered Character: " A_ThisHotkey " Code:" Asc(A_ThisHotkey)
	SB_SetText(text1,2),SB_SetParts(first,width*StrLen(text1 1),40)
	last:=width*StrLen(text1 1)
	replace()
	return
}
mm(sc){
	min:=[]
	min[sc.2008]:=1,min[sc.2009]:=1
	min.min:=min.MinIndex(),min.max:=min.MaxIndex()
	return min
}
class s{
	static ctrl:=[],lc:=""
	__New(window="",pos=""){
		win:=window?window:1
		static count=1
		pos:=count=1?"x+0":"x+0"
		pos:=window?"x0 y0":pos
		Gui,%win%:Add,custom,classScintilla hwndsc w500 h400 %pos% +1387331584
		this.sc:=sc,s.ctrl[sc]:=this,t:=[]
		for a,b in {fn:2184,ptr:2185}
		this[a]:=DllCall("SendMessageA","UInt",sc,"int",b,int,0,int,0)
		controllist(),arrange(),color(this)
		v.focus:=sc
		for a,b in [[2563,1],[2565,1],[2614,1],[2402,0x15,75]]{
			b.2:=b.2?b.2:0,b.3:=b.3?b.3:0
			this[b.1](b.2,b.3)
		}
		return this
	}
	__Delete(){
		m("should not happen")
	}
	__Get(x*){
		return DllCall(this.fn,"Ptr",this.ptr,"UInt",x.1,int,0,int,0,"Cdecl")
	}
	__Call(code,lparam=0,wparam=0){
		if (code="getseltext"){
			VarSetCapacity(text,this.2161),length:=this.2161(0,&text)
			return StrGet(&text,length,"cp0")
		}
		if (code="textrange"){
			VarSetCapacity(text,abs(lparam-wparam)),VarSetCapacity(textrange,12,0),NumPut(lparam,textrange,0),NumPut(wparam,textrange,4),NumPut(&text,textrange,8)
			this.2162(0,&textrange)
			return strget(&text,"","cp0")
		}
		if (code="gettext"){
			cap:=VarSetCapacity(text,vv:=this.2182),this.2182(vv,&text),t:=strget(&text,vv,"cp0")
			return t
		}
		wp:=(wparam+0)!=""?"Int":"AStr"
		if wparam.1
		wp:="AStr"
		if wparam=0
		wp:="int"
		return DllCall(this.fn,"Ptr",this.ptr,"UInt",code,int,lparam,wp,wparam,"Cdecl")
	}
}
~LButton::
MouseGetPos,,,win,Con
if (win!=v.main)
return
if InStr(con,"Scintilla"){
	cf(con)
	titlechange()
}
return
kill(){
	kill:
	if v.control.maxindex()=1
	return
	DllCall("DestroyWindow",uptr,v.focus)
	sc:=cf("Scintilla1"),sc.2400
	controllist(),arrange(1),titlechange()
	return
}
settings(){
	static
	sett:=setup(3),mmenu:=[]
	Gui,Add,ListView,w500 h500 AltSubmit gselhk NoSort,Key Action|Key
	Gui,Add,Hotkey,gchangekey vchk limit3
	for a,b in v.menu{
		if b=options
		continue
		if !IsObject(b)
		LV_Add("",b,"--------------")
		for c,d in v.menu[b]
		for e,f in d
		if e!=sep
		{
			LV_Add("",clean(e,1),change(settings.ssn("//hotkeys/" clean(e)).text))
			mmenu[clean(e)]:={orig:e,menu:b}
		}
	}
	Loop,2
	LV_ModifyCol(A_Index,"AutoHDR")
	ControlGetPos,,,,h,msctls_hotkey321,% aid(sett)
	height:=h*6,ea:=settings.ea("//ftp")
	Gui,Add,GroupBox,w500 h%height% Section,FTP Settings
	for a,b in info:=["Server","Port","Username","Password"]{
		pass:=A_Index=4?"password":""
		if A_Index=1
		Gui,Add,Text,xs+10 ys+%h% section,%b%:
		else
		Gui,Add,Text,xs section,%b%:
		Gui,Add,Edit,x+10 ys w300 v%b% %pass%,% ea[b]
	}
	Gui,Show,,Settings
	return
	selhk:
	if (A_GuiEvent="Normal"){
		LV_GetText(item,LV_GetNext()),key:=settings.ssn("//hotkeys/" clean(item)).text
		GuiControl,3:,msctls_hotkey321,%key%
		ControlFocus,msctls_hotkey321
	}
	return
	changekey:
	if ! LV_GetNext()
	return
	LV_GetText(item,LV_GetNext()),LV_GetText(key,LV_GetNext(),2)
	Gui,3:Submit,Nohide
	if key=--------------
	return
	set:=settings.add({path:"hotkeys/" clean(item)})
	chk:=chk?chk:"null"
	LV_Modify(LV_GetNext(),"Col2",change(chk))
	Menu,% mmenu[clean(item)].menu,Rename,% mmenu[clean(item)].orig "`t" change(set.text),% mmenu[clean(item)].orig "`t" change(chk)
	settings.add({path:"hotkeys/" clean(item),text:chk})
	number:=settings.sn("//hotkeys/*[text()='" chk "']"),list:=""
	if (number.length>1){
		while,n:=number.item(A_Index-1)
		list.=clean(n.nodename,1) "`n"
		MsgBox,64,AHK Studio,The Key Actions:`n`n%list%`nare using the same hotkey.  This will not work properly
	}
	return
	3GuiEscape:
	3GuiClose:
	Gui,3:Submit,NoHide
	settings.add({path:"ftp",att:{server:server,port:port,username:username,password:password}})
	cf("Scintilla1")
	destroy(3),v.sc.2400
	return
}
13GuiEscape:
13GuiClose:
7GuiEscape:
7GuiClose:
destroy(A_Gui)
return
contextmenu(){
	GuiContextMenu:
	MouseGetPos,,,win,Control
	if !InStr(control,"Scintilla")
	return
	ControlGet,hwnd,hwnd,,%control%,% aid()
	v.focus:=hwnd+0
	menu:=["Copy","Paste","Cut","Undo"]
	sc:=v.sc
	if sc.2008-sc.2009!=0
	menu.insert("Google Search Selected")
	for a,b in menu
	Menu,rcm,Add,%b%,rcmadd
	Menu,rcm,Add
	Menu,rcm,Add,Add Another Scintilla Control,add
	if v.control.MaxIndex()>1
	Menu,rcm,Add,Remove This Scintilla Control,kill
	Menu,rcm,Show
	Menu,rcm,DeleteAll
	return
	rcmadd:
	if item=undo
	item:=clean(A_ThisMenuItem),%item%()
	return	
}
open_folder(){
	file:=ssn(current(1),"@file").text
	SplitPath,file,,dir
	run,%dir%
}
open(filelist=""){
	if filelist.list{
		GuiControl,-Redraw,SysTreeView321
		type:=filelist.list.FirstChild.nodetype,fq:={1:[filelist.list,"file"],3:[filelist.list.parentnode,"file[text()='" filelist.list.text "']"]}
		fl:=sn(fq[type].1,fq[type].2)
		while,ff:=fl.item(A_Index-1){
			if !FileExist(ff.text){
				xml.remove(ff)
				continue
			}
			fi:=ff.text
			SplitPath,fi,name,dir
			top:=TV_Add(name)
			root:=files.add({path:"main",att:{file:ff.text},dup:1}),rest:="",fi:=ff.text
			files.under({node:"file",att:{file:ff.text,tv:top},under:root})
			FileRead,text,% ff.text
			Loop,Parse,text,`n,`r`n
			if InStr(A_LoopField,"#Include"){
				file:=RegExReplace(A_LoopField,"i).*include."),RegExReplace(file,"\*i")
				if InStr(file,";")
				file:=Trim(SubStr(file,1,InStr(file,";")-1))
				fname:=FileExist(dir "\" file)?dir "\" file:file
				if FileExist(fname){
					SplitPath,file,name
					child:=TV_Add(name,top)
					files.under({node:"file",att:{file:fname,code:A_LoopField,tv:child},under:root})
					FileRead,ft,% fname
					update({file:fname,text:ft})
				}
				else
				rest.=A_LoopField "`r`n"
			}
			else
			rest.=A_LoopField "`r`n"
			update({file:ff.text,text:Trim(rest,"`r`n")})
		}
		GuiControl,+Redraw,SysTreeView321
	}
	else
	{
		FileSelectFile,fn,,,,*.ahk
		if ErrorLevel
		Exit
		if !FileExist(fn)
		return m("Somehow it does not exist")
		if files.ssn("//*[@file='" fn "']")
		return m("aldready open")
		newfile:=settings.add({path:"open/file",text:fn,dup:1})
		open({list:newfile})
		sleep,50
		if (filelist=1){
			sc:=new s
			tv({sc:sc,filename:files.ssn("//file[@file='" fn "']")})
			cf(sc)
			ControlFocus,,% aid(sc.sc)
		}
		else
		tv({sc:v.sc,filename:files.ssn("//file[@file='" fn "']")})
		return
	}
	files.Transform()
	update({clear:1})
}
theme(){
	static
	hwnd:=setup(11),v.theme:=hwnd,preset:=new xml("preset","lib\preset.xml")
	Gui,Margin,0,0
	Gui,Add,TreeView,w200 h500 gthemetv AltSubmit
	theme:=new s(11),v.themesc:=theme
	theme.2096(1)
	ControlMove,Scintilla1,201,,,500,ahk_id%hwnd%
	Gui,+Resize
	theme.2181(0,themetext())
	snapshot(hwnd,11,{Scintilla1:["w","h"],SysTreeView321:["h"]})
	pos:=settings.ssn("//gui/position[@window='11']").text
	pos:=pos?pos:"w" A_ScreenWidth-200 " h" A_ScreenHeight-200 "Center"
	Gui,Show,%pos%,Theme
	theme.2160
	Loop,2
	fix_indent(theme)
	cf(theme)
	Loop,36
	theme.2409(A_Index,1),theme.2246(0,1)
	list:={Background:{style:5,value:"background"},Caret:{code:2069,value:"color"}
	,"Default Background":{style:5,value:"background"},"Current Line Background":{code:2098,value:"color"}
	,"Default Font Style":{font:1,style:5},"Custom Highlight Text":"","Personal Variable List":"","Multi Selection Background":{code:2601,value:"color"}
	,"Selection Foreground":{code:2067,value:"color",bool:1},"Selection Background":{code:2068,value:"color",bool:1}
	,"Selected Duplicates":{code:2082,value:"color",bool:1},"Indent Guides":{style:37,color:1}
	,"End Of Line Color":{style:0,color:1}}
	root:=TV_Add("Color",0,"Expand")
	for a in list
	TV_Add(a,root)
	io:=TV_Add("Theme Options",0,"Expand")
	for a,b in ["Save Current Theme","Save Theme As","Import Theme","Export Theme","Remove Theme","Download Themes"]
	TV_Add(b,io)
	themes:=TV_Add("Themes",0,"Expand")
	tlist:=preset.sn("//preset/*")
	while,n:=tlist.item(A_Index-1)
	TV_Add(n.nodename,themes)
	theme.2400
	return
	11GuiClose:
	destroy(11),cf("Scintilla1")
	WinActivate,% aid(v.main)
	ControlFocus,Scintilla1,% aid()
	return
	themetv:
	if A_GuiEvent!=Normal
	return
	TV_GetText(name,TV_GetSelection()),info:=list[name],parent:=TV_GetParent(TV_GetSelection())
	if !parent
	return
	downloadtheme:
	TV_GetText(pn,parent)
	if (pn="download themes"){
		if !FileExist("Exported Themes")
		FileCreateDir,Exported Themes
		TV_GetText(file,TV_GetSelection())
		SplashTextOn,200,40,Downloading Theme,Please Wait...
		URLDownloadToFile,http://www.maestrith.com/files/AHKStudio/themes/%file%,Exported Themes\%file%
		SplashTextOff
		file:="exported themes\" file
		parent:=io
		name=import theme
		addname=1
	}
	if (A_ThisLabel="downloadtheme"){
		if !LV_GetNext()
		return
		LV_GetText(file,LV_GetNext())
		URLDownloadToFile,http://www.maestrith.com/files/AHKStudio/themes/%file%,Exported Themes\%file%
		file:="exported themes\" file
		parent:=io
		name=import theme
		addname=1
	}
	if (parent=themes){
		new:=preset.ssn("//" name "/fonts"),settings.remove("//fonts")
		clone:=new.CloneNode(1)
		ssn(settings.xml,"//settings").AppendChild(clone)
		theme.2181(0,themetext(preset.sn("//" name "/fonts/highlight/*")))
		ll:=settings.sn("//fonts/highlight/*")
		while,l:=ll.item(A_Index-1){
			theme.4005(ssn(l,"@list").text+3,l.text)
			sleep,10 ;not sure why, but it is needed
		}
	}
	if (parent=io){
		if (name="Import Theme"){
			if !file
			FileSelectFile,file,,,Select an XML theme,*.xml
			if ErrorLevel
			return
			temp:=ComObjCreate("MSXML2.DOMDocument"),temp.setProperty("SelectionLanguage","XPath")
			temp.load(file)
			font:=ssn(temp,"//fonts")
			name:=ssn(temp,"//name").text
			if (font.xml=""&&name="")
			return m("Incompatible Theme"),file:=name:=""
			settings.remove("//fonts")
			if addname{
				if !preset.ssn("//*[name='" name "']"){
					Gui,11:Default
					TV_Add(name,themes),addname:=0
					Gui,34:Default
				}
			}
			else
			if !preset.ssn("//preset/" name)
			TV_Add(name,themes)
			ssn(settings.xml,"//settings").AppendChild(font)
			temp:=""
			saveit=1
		}
		if (name="save theme as"){
			InputBox,name,Input a name for your new style,No numbers please`nNames are case sensitive
			if !name
			return
			name:=regexreplace(regexreplace(name," ","_"),"i)(?:[^a-z_])","")
			if preset.ssn("//preset/" name){
				MsgBox,4,Preset already exists,Overwrite?
				IfMsgBox,No
				return
			}
			else
			TV_Add(name,themes)
			settings.add({path:"fonts/name",text:name})
			saveit=1
		}
		if (name="Save current theme"||saveit){
			saveit=0
			if !name:=settings.ssn("//fonts/name").text{
				InputBox,name,Input a name for your new style,No numbers please`nNames are case sensitive
				if !name
				return
				settings.add({path:"fonts/name",text:name})
				TV_Add(name,themes)
			}
			name:=regexreplace(regexreplace(name," ","_"),"i)(?:[^a-z_])","")
			cur:=settings.ssn("//fonts")
			if main:=preset.ssn("//preset/" name)
			main.ParentNode.RemoveChild(main)
			main:=preset.add({path:"preset/" name})
			dup:=cur.clonenode(1)
			main.appendchild(dup)
			preset.Transform(),preset.save(),file:="",name:=""
		}
		else if (name="export theme"){
			dir:="Exported Themes"
			if !FileExist(dir)
			FileCreateDir,%dir%
			theme:=settings.ssn("//fonts/name").Text
			FileDelete,%dir%\%theme%.xml
			FileAppend,% settings.ssn("//fonts").xml,%dir%\%theme%.xml
			m("Theme exported to " A_ScriptDir "\" dir "\" theme ".xml")
		}
		else if InStr(name,"remove theme"){
			ll:=[]
			child:=TV_GetChild(themes),TV_GetText(first,child),ll[first]:=child
			while,TV_GetText(next,child:=TV_GetNext(child))
			ll[next]:=child
			setup(33)
			Gui,Add,Text,,Warning! Can not be undone.
			Gui,Add,ListView,h300 vlistbox,Theme
			Gui,Add,Button,gremovetheme,Remove Theme
			for a,b in ll
			LV_Add("",a)
			LV_Modify(1,"Select Focus Vis")
			Gui,show,,Remove
			return
		}
		if (name="download themes"){
			parent:=TV_GetSelection()
			if child:=TV_GetChild(parent){
				list:=[]
				list[child]:=1
				while,child:=TV_GetNext(child)
				list[child]:=1
				for a,b in List
				TV_Delete(a)
			}
			SplashTextOn,200,50,Downloading Themes,Please Wait...
			info:=URLDownloadToVar("http://www.maestrith.com/files/AHKStudio/themes")
			SplashTextOff
			pos:=1
			search="(\w+)\.xml"
			while,pos:=RegExMatch(info,search,found,pos){
				RegExMatch(found,"(\w+)",name)
				TV_Add(name,parent)
				pos+=StrLen(found)
			}
			TV_Modify(parent,"Expand")
		}
	}
	if (parent=root){
		if (name="custom highlight text")
		return custom_highlight_text()
		if (name="Personal Variable List")
		return Personal_Variable_List()
		if info.font{
			orig:=settings.ssn("//fonts/font[@style='5']")
			att:=settings.easyatt(orig)
			del:=settings.sn("//fonts/font[@style!='5']")
			while,d:=del.item(A_Index-1)
			if ssn(d,"@style").text!=33
			d.ParentNode.RemoveChild(d)
			if !Dlg_Font(att)
			return
			for a,b in att
			orig.SetAttribute(a,b)
			goto styleend
		}
		if InStr(name,"Default Background"){
			value:=settings.ssn("//fonts/*[@style='5']/@background").text
			color:=dlg_color(value,hwnd)
			allback:=settings.sn("//fonts/*/@background")
			while,b:=allback.item(A_Index-1)
			if ssn(b,"../@style").text<32
			b.text:=color
			goto styleend
		}
		else if info.style&&info.value{
			value:=settings.ssn("//fonts/*[@style='" info.style "']/@" info.value)
			color:=dlg_color(value.text,hwnd)
			value.text:=color
		}
		else if info.code{
			;here
			vv:=info.value,in:=info.clone()
			value:=settings.ssn("//fonts/font[@code='" in.code "']/@" vv).text
			in.remove("value"),in[vv]:=value
			uni:=settings.unique({path:"fonts/font",att:in,check:"code"})
			value:=ssn(uni,"@" vv)
			color:=dlg_color(value.text,hwnd)
			value.text:=color
		}
		else if (info.style!=""&&info.color){
			if !color:=settings.ssn("//*[@style='" info.style "']")
			color:=settings.add({path:"fonts/font",att:{style:info.style,color:0},dup:1})
			value:=ssn(color,"@color")
			value.text:=dlg_color(value.text,hwnd)
		}
		else
		return m("Not implimented yet.  Sorry.")
	}
	styleend:
	active:=aid(WinActive()),ea:=settings.ea("//fonts/font[@style='5']")
	for a,b in [active,aid()]{
		winget,controllist,ControlList,%b%
		win:=a=1?A_Gui ":":"1:"
		face:=settings.ssn("//fonts/font[@style='5']/@font").text
		Gui,%win%font,% "c" RGB(ea.color),%face%
		loop,Parse,ControlList,`n
		{
			GuiControl,% win "+background" RGB(ea.Background) " c" rgb(ea.color),%A_LoopField%
			GuiControl,% win "font",%A_LoopField%
		}
		Gui,%win%color,% RGB(ea.Background)
	}
	for a,b in s.ctrl
	color(b),marginwidth(b)
	return
	removetheme:
	Gui,33:Default
	while,LV_GetNext(){
		LV_GetText(t,LV_GetNext()),LV_Delete(LV_GetNext())
		preset.remove("//" t)
		Gui,11:Default
		TV_Delete(ll[t])
		Gui,33:Default
	}
	preset.save()
	return
}
themetext(theme=1){
	out=/*`nMulti-Line`ncomments`n*/`nSelect the text to change the colors`nThis is a sample of normal text`n`"incomplete quote`n"complete quote"`n`;comment`n0123456789`n()[]^&*()+~#\/,{`}``b``a``c``k``t``i``c``k`n
	p:=["Commands = ","Items = ","Personal = "]
	Loop,3
	out.=p[A_Index] v.keywords[A_Index] "`n"
	th:=theme=1?settings.sn("//fonts/highlight/*"):theme
	while,tt:=th.item(A_Index-1)
	out.="Custom List " ssn(tt,"@list").text " = " tt.text "`n"
	out.="`nLeft Click to edit the fonts color`nControl+Click to edit the font style, size, italic...etc`nAlt+Click to change the Background color`nThis works for the Line Numbers as well"
	return out
}
margincolor(x){
	ea:=combine(5,33)
	if !numbar:=settings.ssn("//fonts/font[@style='33']")
	numbar:=settings.add({path:"fonts/font",att:{style:33},dup:1})
	sleep,100
	if (x!=4){
		color:=dlg_color(ea.color,v.theme)
		numbar.SetAttribute("color",color)
	}
	else
	{
		color:=dlg_color(ea.background,v.theme)
		numbar.SetAttribute("background",color)
	}
	for a,b in v.Control
	color(s.ctrl[b]),marginwidth(s.ctrl[b])
	color(v.themesc)
}
combine(style,style1){
	ea:=settings.ea("//fonts/font[@style='" style "']"),def:=xml.easyatt(settings.ssn("//fonts/font[@style='" style1 "']"))
	for a,b in def
	ea[a]:=b
	return ea
}
font(){
	sc:=v.sc
	st:=sc.2010(sc.2008)
	if (v.lastmod=4){
		def:=combine(5,st)
		color:=dlg_color(def.background,v.theme)
		settings.ssn("//fonts/font[@style='" st "']").SetAttribute("background",color)
		for a,b in v.Control
		color(s.ctrl[b])
		color(v.themesc)
		return
	}
	if (v.lastmod=2){
		def:=combine(5,st)
		dlg_font(def,1,v.theme)
		def.style:=st
		uni:=settings.unique({path:"fonts/font",att:def,check:"style"})
		for a,b in v.Control
		color(s.ctrl[b])
		color(v.themesc)
		if st=5
		for a,b in [1,A_Gui]{
			Gui,%b%:Font,% "c" RGB(def.color),% def.font
			GuiControl,%b%:font,SysTreeView321
		}
		return
	}
	if !set:=settings.ssn("//*[@style='" st "']")
	set:=settings.add({path:"fonts/font",att:{style:st},dup:1})
	color:=ssn(set,"@color").Text
	color:=color?color:0
	color:=dlg_color(color,v.theme)
	set.SetAttribute("color",color)
	for a,b in s.ctrl
	color(b),marginwidth(b)
	if st=5
	for a,b in [1,A_Gui]{
		Gui,%b%:Font,% "c" RGB(color),% def.font
		GuiControl,%b%:font,SysTreeView321
	}
	WinActivate,Theme
}
fix_indent(sc="",noundo=""){
	v.fix:=1
	if !sc
	sc:=v.sc
	if !noundo
	sc.2078()
	out:=sc.gettext(),indent:=0
	fix:=v.options.auto_indent
	sc.2029(0),sc.2124(1)
	ind=5
	loop,parse,out,`r,`r`n
	{
		cline:=A_Index-1,text:=trim(a_loopfield)
		if InStr(text,";"){
			while,pos:=InStr(text,chr(59),0,1,A_Index){ 
				in:=sc.2127(cline)
				if sc.2010(sc.2128(cline)+pos)=1
				text:=trim(substr(a_loopfield,1,pos))
			}
		}
		if (text="*/"){
			indent-=ind
			if indent < 0
			indent:=0
			if (fix || x=1)
			sc.2126(A_Index-1,indent)
		}
		if (SubStr(text,1,1)="}"){
			indent-=ind
			if indent < 0
			indent:=0
			if (fix || x=1)
			sc.2126(A_Index-1,indent)
		}
		if (text="/*"){
			indent+=ind
			if (fix || x=1){
				sc.2126(A_Index-1,indent-ind)
				sc.2126(A_Index,indent)
			}
			sc.2222(A_Index-1,0x2000|1024+indent-ind)
		}
		else if (SubStr(text,0)="{"){
			indent+=ind
			if (fix || x=1){
				sc.2126(A_Index-1,indent-ind)
				sc.2126(A_Index,indent)
			}
			sc.2222(A_Index-1,0x2000|1024+indent-ind)
		}
		else if (fix || x=1)
		sc.2126(A_Index-1,indent)
		sc.2222(A_Index,1024+indent)
		list.=A_Index " " indent "`n"
		if indent < 0
		indent:=0
	}
	if indent>0
	tooltip,Segment is open,0,0,10
	else
	ToolTip,,,,10
	v.fix:=0
	marginwidth()
	if !noundo
	sc.2079()
	}
undo(){
	v.sc.2176
}
insert_function(){
	InputBox,func,Function Name,Please insert a function name
	if !func
	return
	InputBox,var,Function Variables,Insert the variables
	MsgBox,260,Create a new segment?,Would you like to create a new segment?
	IfMsgBox,Yes
	{
		cur:=ssn(current(1),"@file").Text
		SplitPath,cur,,dir
		if FileExist(dir "\" func)
		return m("Segment already exists.  Please choose another name")
		new_segment(dir "\" func)
		sleep,100
	}
	sc:=v.sc
	if (sc.2136(line:=sc.2166(sc.2008))!=sc.2008)
	end:="`r`n",pos:=sc.2128(line+1),sc.2160(pos,pos)
	sc.2003(sc.2008,clean(func) "(" var "){`r`n`r`n}" end)
	fix_indent(sc)
	Send,{down}
	sc.2314
}
move_selected_lines_down(){
v.sc.2621
	fix_indent(v.sc)
}
move_selected_lines_up(){
	v.sc.2620
	fix_indent(v.sc)
}
context(){
	sc:=v.sc
	if sc.2102
	return
	cp:=sc.2008,kw:=v.kw,add:=0,pos:=cp-1,start:=sc.2128(sc.2166(cp))
	content:=sc.textrange(start,cp)
	RegExMatch(content,"(\w+)",word)
	search=U)"(.*)"
	cb:=RegExReplace(content,search),RegExReplace(cb,"\)","",Count)
	cou:=[],cbb:=cb
	for a,b in ["(",")"]
	while,pos:=InStr(cb,b,0,1,A_Index)
	cou[pos]:=b
	for a,b in cou{
		if (b="(")
		ccc++
		else if (b=")")
		ccc--
		if ccc=0
		cbb:=SubStr(cb,a+1)
	}
	cbb:=SubStr(cbb,1,InStr(cbb,"(",0,1,ccc))
	RegExMatch(cbb,"(\w+)\($",command)
	found:=kw[command1]?kw[command1]:kw[word1]
	if !found
	return
	if syn:=commands.ssn("//Commands/*[text()='" found "']/@syntax").text
	info:=found " " syn
	else
	{
		root:=commands.sn("//Context/" found "/syntax")
		while,r:=root.item(A_Index-1)
		if cc:=RegExMatch(cb,"i)\b(" RegExReplace(r.text," ","|") ")\b",ff){
			info:=ssn(r,"@syntax").text
			break
		}
		if !cc
		return
		info:=SubStr(cb,1,cc+StrLen(ff)-1) " " info
	}
	RegExReplace(info,",","",count)
	if !count
	return sc.2207(0),sc.2200(start,info),sc.2204(0,StrLen(info))
	newstr:=RegExReplace(SubStr(cb,InStr(cb,found,0,0)+StrLen(found)),"U)\((.*)\)")
	newstr:=Trim(newstr,"(")
	RegExReplace(newstr,",","",count)
	ss:=InStr(info,",",0,1,count),ee:=InStr(info,",",0,1,count+1)
	sc.2200(start,info),sc.2207(0xFF0000)
	if (ss&&ee)
	sc.2204(ss,ee)
	else if (ss&&ee=0)
	sc.2204(ss,StrLen(info))
	else if (ss=0&&ee)
	sc.2204(ss,ee)
	else
	sc.2207(0x0000FF),sc.2204(0,StrLen(info))
	return
	ss:
	SetTimer,ss,Off
	context()
	return
}
replace(){
	sc:=v.sc,cp:=sc.2008
	word:=sc.textrange(start:=sc.2266(cp-1,1),end:=sc.2267(cp-1,1))
	if w:=settings.ssn("//replacements/*[@replace='" word "']").text
	sc.2190(start),sc.2192(end),sc.2194(StrLen(w),w)
	l:=commands.ssn("//Context/*/*[text()='" w "']/@list").text
	if l{
		Sort,l,D%A_Space%
		sc.2100(0,l)
	}
}
defaults(){
	exclude:={"word wrap":1,"end of line":1,"virtual space":1}
	if commands.ssn("//Version/Date").text!=20130610063815
	m("Some context may not work properly.`nDelete the Commands.xml file and try to restart the program.")
	if !settings.ssn("//autoadd")
	for a,b in {60:62,123:125,34:34,39:39,91:93,40:41}
	settings.add({path:"autoadd/key",att:{trigger:a,add:b},dup:1})
	if !settings.ssn("//fonts"){
		settings.Add({path:"fonts/font",att:{style:5,background:0,color:0xFFFFFF,size:10,font:"Tahoma",bold:1},dup:1})
		settings.Add({path:"fonts/font",att:{style:33,background:0xFF0000},dup:1})
		settings.Add({path:"fonts/font",att:{color:0xFFFFFF,code:2069},dup:1})
		for a,b in {11:0xFF,12:0xFF8080,3:0xFF0000,7:0x00FFFF,1:0xAAAAAA,2:0x00FF00,4:0xFF8000,9:0x800080,10:0x8080C0}
		settings.Add({path:"fonts/font",att:{style:a,color:b},dup:1})
		for a,b in v.menu.options{
			for c,d in b
			if !exclude[c]{
				settings.add({path:"options/" clean(c),text:1})
				Menu,options,ToggleCheck,% c "`t" change(d)
			}
		}
	}
}
update(return=""){
	static update:=[],updated:=[]
	if return.remove
	return updated.remove(return.remove)
	if return.Text
	return update[return.file]:=return.text
	if return.get
	return update
	if return.Up
	return updated
	if return.clear
	return updated:=[]
	sc:=return.sc,file:=return.file
	if text:=sc.gettext(),updated[file]:=1
	update[file]:=text
}
current(parent=""){
	node:=files.ssn("//*[@doc='" v.sc.2357 "']")
	if (parent=1&&node.nodename="main")
	return node
	if (parent=1&&node.nodename!="main")
	return node.parentnode
	return node
}
tv(info=""){
     sc:=info.sc,filename:=info.filename
     goto next
     tv:
	if (A_GuiEvent="Rightclick"){
		selection:=TV_GetSelection()
		MouseClick,Left
		v.tvid:=TV_GetSelection()
		TV_Modify(selection,"Select Focus Vis")
		Menu,open,Add,Open in new control,oic
		Menu,open,Show
		Menu,open,Delete
	}
	if (A_GuiEvent!="Normal")
	return
	filename:=files.ssn("//file[@tv='" TV_GetSelection() "']")
	next:
	Gui,1:TreeView,SysTreeView321
	sc:=!sc?v.sc:sc
	main:=filename.nodename="main"?filename:filename.parentnode
	if ssn(main,"@file").text
	last:=positions.unique({path:"main",att:{file:ssn(main,"@file").text},check:"file"})
	getpos(),test:=0
	if !ssn(filename,"@file").text
	return
	number:=misc.ssn("//scintilla/control[@sc='" sc.sc "']/@number").text
	v.lastlist[number]:=ssn(filename,"@file").text
	sc.2078
	if !doc:=ssn(filename,"@doc").text
	doc:=sc.2375,sc.2358(0,doc),filename.SetAttribute("doc",doc),sc.2181(0,update({get:1})[ssn(filename,"@file").text]),update({remove:ssn(filename,"@file").text}),color(sc),fix_indent(sc,1)
	else
	sc.2358(0,doc)
	setpos(sc)
	Gui,1:Default
	files.Transform()
	tv:=filename.firstchild?ssn(filename.firstchild,"@tv").text:ssn(filename,"@tv").text
	tv:=tv?tv:ssn(filename,"@tv").text
	TV_Modify(tv,"Focus Vis Select")
	file:=ssn(filename,"@file").text
	last.SetAttribute("last",file),fix_indent(sc,1),marginwidth(sc)
	sc:=""
	WinGetTitle,title,% aid()
	if ssn(current(1),"@file").text!=v.lastfile
	Refresh_Code_Explorer()
	titlechange()
	v.lastfile:=ssn(current(1),"@file").text
	id:=idea.ssn("//*[@file='" ssn(current(1),"@file").text "']").text
	ControlGetText,eas,Edit1,% "ahk_id" v.ideas
	eas:=RegExReplace(eas,"\r\n","`n")
	sc.2079()
	if !WinExist("ahk_id" v.ideas)
	return
	if (id!=eas)
	ControlSetText,Edit1,% RegExReplace(id,"\n","`r`n"),% "ahk_id" v.ideas
	return
	oic:
	sc:=new s,cf(sc)
	arrange(1)
	tv({filename:files.ssn("//*[@tv='" v.tvid "']")})
	titlechange()
	ControlFocus,,% aid(sc.sc)
	return
}
jump_to_segment(){
	static segments:=[]
	static sort
	jump:=sn(current(1),"*/@file"),segments:=[]
	jts:=setup(7)
	Gui,Add,Edit,gsort vsort w200
	Gui,Add,ListView,w200 h400 AltSubmit -Multi,Segments
	Gui,Add,Button,gjump Default,Jump
	while,j:=jump.item(A_Index-1).text{
		splitpath,j,name,dir
		LV_Add("",name)
		segments[name]:=j
	}
	snapshot(jts,7,{Edit1:["w"],SysListView321:["w","h"],Button1:["y"]})
	Gui,+Resize
	Gui,-0x30000
	LV_Modify(1,"Select Vis Focus"),hotkey({win:jts,list:{up:"ud",down:"ud"}})
	Gui,Show,% show(7),Jump to Segment
	return
	jump:
	Gui,7:Default
	LV_GetText(segment,LV_GetNext())
	node:=current(1)
	js:=ssn(node,"*[@file='" segments[segment] "']")
	if js
	tv({sc:v.sc,filename:js})
	Destroy(7)
	return
	sort:
	Gui,7:Submit,Nohide
	LV_Delete()
	jump:=sn(current(1),"*/@file")
	while,j:=jump.item(A_Index-1).text{
		splitpath,j,name,dir
		if InStr(name,sort)
		LV_Add("",name)
	}
	LV_ModifyCol(1,"Sort"),LV_Modify(1,"Select Focus Vis")
	return
	ud:
	Gui,7:Default
	count:=A_ThisHotkey="up"?-1:+1,pos:=LV_GetNext()+count<1?1:LV_GetNext()+count,LV_Modify(pos,"Select Focus Vis")
	return
}
Jump_to_Script(){
	static scripts:=[]
	static sort
	list:=files.sn("//main"),scripts:=[]
	jts:=setup(13)
	Gui,+Resize
	Gui,-0x30000
	Gui,Add,Edit,w500 gjtsort vsort
	Gui,Add,ListView,w500 h500 -Multi,Scripts
	Gui,Add,Button,gjts Default,Jump To Script
	Gui,Default
	snapshot(jts,13,{Edit1:["w"],SysListView321:["w","h"],Button1:["y"]})
	Gui,Show,% show(13),Jump to Script
	while,l:=list.item(A_Index-1)
	LV_Add("",ssn(l,"@file").text),scripts[ssn(l,"@file").text]:=1
	LV_Modify(1,"Select Vis Focus"),hotkey({win:jts,list:{up:"jtsupdown",down:"jtsupdown"}})
	return
	jtsort:
	Gui,13:Default
	Gui,Submit,Nohide
	LV_Delete()
	for a,b in scripts
	if InStr(a,sort)
	LV_Add("",a)
	LV_Modify(1,"Select Focus Vis")
	return
	jts:
	LV_GetText(file,LV_GetNext())
	if file{
		f:=positions.ssn("//main[@file='" file "']/@last").text
		fff:=f?files.ssn("//main[@file='" file "']/file[@file='" f "']"):files.ssn("//main[@file='" file "']")
		tv({sc:v.sc,filename:fff})
	}
	Destroy(13)
	return
	jtsupdown:
	Gui,13:Default
	count:=A_ThisHotkey="up"?-1:+1,pos:=LV_GetNext()+count<1?1:LV_GetNext()+count,LV_Modify(pos,"Select Focus Vis")
	return
}
new_segment(new="",notv=""){
	cur:=ssn(current(1),"@file").Text
	SplitPath,cur,,dir
	if !new
	{
		FileSelectFile,new,s,%dir%\,Create a new Segment,*.ahk
		if ErrorLevel
		return
	}
	if node:=ssn(current(1),"file[@file='" new "']")
	return tv({sc:v.sc,filename:node})
	SplitPath,new,file,newdir
	incfile:=(newdir=dir)?file:new
	top:=TV_Add(file,ssn(current(1),"file/@tv").text)
	select:=files.under({node:"file",att:{file:new,code:Chr(35) "Include " incfile,tv:top},under:current(1)})
	up:=update({up:1})
	;future add a way to add stuff to the new file
	FileAppend,,%new%
	up[cur]:=1
	if !notv
	tv({sc:v.sc,filename:select})
}
hotkey(info){
	Hotkey,IfWinActive,% aid(info.win)
	for key,label in info.list
	Hotkey,%key%,%label%,On
}
getpos(){
	if !current(1)
	return
	sc:=v.sc,current:=current(1)
	fix:=positions.unique({path:"main",att:{file:ssn(current,"@file").text},check:"file"})
	fix:=positions.unique({under:fix,path:"file",att:{start:sc.2008,end:sc.2009,scroll:sc.2152,file:ssn(current(),"@file").text},check:"file"})
	fold:=0
	while,sc.2618(fold)>=0,fold:=sc.2618(fold)
	list.=fold ",",fold++
	if list
	fix.SetAttribute("fold",Trim(list))
	else
	fix.removeattribute("fold")
}
setpos(sc){
	file:=ssn(current(),"@file").text,parent:=ssn(current(1),"@file").text
	posinfo:=positions.ssn("//main[@file='" parent "']/file[@file='" file "']")
	ea:=xml.easyatt(posinfo),fold:=ea.fold
	if ea.start
	sc.2613(ea.scroll),sc.2160(ea.start,ea.end)
	Loop,Parse,fold,`,
	if A_LoopField is number
	sc.2231(A_LoopField)
}
find(){
	static
	file:=ssn(current(1),"@file").text
	infopos:=positions.ssn("//*[@file='" file "']")
	last:=ssn(infopos,"@search").text
	hwfind:=setup(4)
	search:=last?last:"Type in your query here"
	for a,b in ["Edit,gfindcheck w500 vfind," search ,"TreeView,w500 h300 AltSubmit gstate"
	,"Checkbox,vregex,Regex Search","Checkbox,vgr x+10,Greed","Checkbox,xm vcs,Case Sensitive"
	,"Checkbox,vsort gfsort,Sort by Segment"]{
		StringSplit,b,b,`,
		Gui,Add,%b1%,%b2%,%b3%
		b2:=b3:=""
	}
	Gui,Add,Button,gsearch Default,% " Search "
	snapshot(hwfind,4,{SysTreeView321:["w","h"],Button1:["y"],Button2:["y"],Button3:["y"],Button4:["y"],Button5:["y"],Edit1:["w"]})
	Gui,show,% show(4),Find
	for a,b in xml.easyatt(settings.ssn("//search/find"))
	GuiControl,4:,%a%,%b%
	ControlSend,Edit1,^a,% aid(hwfind)
	return
	findcheck:
	ControlGetText,Button,Button5,% aid(hwfind)
	if (Button!="search")
	ControlSetText,Button5,Search,% aid(hwfind)
	return
	search:
	ControlGetText,Button,Button5,% aid(hwfind)
	if (InStr(button,"search")){
		Gui,4:Submit,Nohide
		if !find
		return
		ff:="",ff.=gr?"":"U"
		ff.=cs?"O)":"Oi)",refreshing:=1,foundinfo:=[]
		main:=regex=0?"(.*)(\Q" find "\E)(.*)":"(" find ")"
		f:=gr&&regex?ff "(" find ")":ff main
		infopos.setattribute("search",find)
		Gui,4:Default
		GuiControl,4:-Redraw,SysTreeView321
		list:=sn(current(1),"*/@file"),contents:=update({get:1}),TV_Delete()
		while,l:=list.item(A_Index-1){
			out:=contents[l.text],found=1,r=0,fn:=l.text
			SplitPath,fn,file
			if !regex{
				while,found:=RegExMatch(out,ff main,fo,found){
					r:=sort&&A_Index=1?TV_Add(file):r
					parent:=TV_Add(fo.value(),r)
					foundinfo[parent]:={pos:fo.pos(2)-1,file:l.text,found:fo.len(2)}
					found:=fo.pos(3)
				}
			}
			else
			{
				while,found:=RegExMatch(out,"Oi)(.*" find ".*)",pof,found){
					fff:=1,r:=sort&&A_Index=1?TV_Add(file):r
					while,fff:=RegExMatch(pof.value(),ff main,fo,fff){
						parent:=TV_Add(fo.value(1)" : "pof.value(),r)
						foundinfo[parent]:={pos:found+fo.pos(1)-2,file:l.text,found:fo.len(1)}
						fff:=fo.pos(1)+fo.len(1)
					}
					found+=pof.len(0)
				}
			}
		}
		if TV_GetCount()
		ControlFocus,SysTreeView321
		GuiControl,4:+Redraw,SysTreeView321
		ControlSetText,Button5,Jump,% aid(hwfind)
		refreshing:=0
	}
	else if (Button="jump"){
		Gui,4:Submit,Nohide
		ea:=foundinfo[TV_GetSelection()]
		sc:=v.sc
		tv({sc:sc,filename:ssn(current(1),"file[@file='" ea.file "']")})
		sc.2160(ea.pos,ea.pos+ea.found)
		sc.2169
	}
	else
	sel:=TV_GetSelection(),TV_Modify(sel,ec:=TV_Get(sel,"E")?"-Expand":"Expand")
	state:
	sel:=TV_GetSelection()
	Gui,4:TreeView,SysTreeView321
	if refreshing
	return
	ControlGetFocus,focus,% aid(hwfind)
	if !InStr(Focus,"SysTreeView321"){
		ControlSetText,Button5,Search,% aid(hwfind)
		return
	}
	if TV_GetChild(sel)
	ControlSetText,Button5,% TV_Get(sel,"E")?"Contract":"Expand",% aid(hwfind)
	else if TV_GetCount()
	ControlSetText,Button5,Jump,% aid(hwfind)
	else
	ControlSetText,Button5,Search,% aid(hwfind)
	return
	sel:=TV_GetSelection()
	if TV_GetChild(sel)
	ControlSetText,Button5,% TV_Get(sel,"E")?"Contract":"Expand",% aid(hwfind)
	else
	ControlSetText,Button5,Jump,% aid(hwfind)
	return
	fsort:
	ControlSetText,Button5,Search,% aid(hwfind)
	goto search
	return
	4GuiEscape:
	4GuiClose:
	Gui,4:Submit,NoHide
	settings.add({path:"search/find",att:{regex:regex,cs:cs,sort:sort,gr:gr}}),foundinfo:=""
	Destroy(4)
	return
}
show_scintilla_code_in_line(get=""){
	static scintilla
	if !FileExist("lib\scintilla.xml"){
		SplashTextOn,300,100,Downloading definitions,Please wait
		URLDownloadToFile,http://files.maestrith.com/scintilla/scintilla.xmlfiles.maestrith.com/scintilla/scintilla.xml,lib\scintilla.xml
		SplashTextOff
	}
	if !IsObject(scintilla)
	scintilla:=new xml("scintilla","lib\scintilla.xml")
	if Get
	return scintilla
	sc:=v.sc
	text:=sc.textrange(sc.2128(sc.2166(sc.2008)),sc.2136(sc.2166(sc.2008)))
	pos=1
	while,pos:=RegExMatch(text,"(\d\d\d\d)",found,pos){
		codes:=scintilla.sn("//*[@code='" found1 "']")
		list.="Code : " found1 " = "
		while,c:=codes.item(A_Index-1)
		list.=ssn(c,"@name").text " "
		pos+=5
		list.="`n"
	}
	if list
	m(list)
}
scintilla_code_lookup(){
	static scintilla,slist,cs
	if !FileExist("lib\scintilla.xml"){
		SplashTextOn,300,100,Downloading definitions,Please wait
		URLDownloadToFile,http://files.maestrith.com/scintilla/scintilla.xml,lib\scintilla.xml
		SplashTextOff
	}
	if !IsObject(scintilla)
	scintilla:=new xml("scintilla","lib\scintilla.xml")
	scintilla:=show_scintilla_code_in_line(1),slist:=scintilla.sn("//item")
	scl:=setup(8)
	Gui,Add,Edit,Uppercase w500 gcodesort vcs
	Gui,Add,ListView,w720 h500 -Multi,Name|Code|Syntax
	Gui,Add,Button,ginsert Default,Insert code into script
	Gui,Add,Button,gdocsite,Goto Scintilla Document Site
	while,sl:=slist.item(A_Index-1)
	LV_Add("",ssn(sl,"@name").text,ssn(sl,"@code").text,ssn(sl,"@syntax").text)
	Gui,show,,Scintilla Code Lookup
	hotkey({win:scl,list:{up:"lookupud",down:"lookupud"}})
	Loop,3
	LV_ModifyCol(A_Index,"AutoHDR")
	return
	docsite:
	Run,http://files.maestrith.com/scintilla/scintilla.xmlwww.scintilla.org/ScintillaDoc.html
	return
	codesort:
	Gui,8:Submit,Nohide
	Gui,8:Default
	GuiControl,-Redraw,SysListView321
	LV_Delete()
	slist:=scintilla.sn("//*[contains(@name,'" cs "')]")
	while,sl:=slist.item(A_Index-1)
	LV_Add("",ssn(sl,"@name").text,ssn(sl,"@code").text,ssn(sl,"@syntax").text)
	LV_Modify(1,"Select Vis Focus")
	GuiControl,+Redraw,SysListView321
	return
	insert:
	LV_GetText(code,LV_GetNext(),2)
	sc:=v.sc
	DllCall(sc.fn,"Ptr",sc.ptr,"UInt",2003,int,sc.2008,astr,code,"Cdecl")
	npos:=sc.2008+StrLen(code)
	sc.2160(npos,npos)
	return
	lookupud:
	Gui,8:Default
	count:=A_ThisHotkey="up"?-1:+1,pos:=LV_GetNext()+count<1?1:LV_GetNext()+count,LV_Modify(pos,"Select Focus Vis")
	return
	8GuiClose:
	8GuiEscape:
	Destroy(8)
	return
}
full_backup(){
	save(),sc:=v.sc
	SplashTextOn,300,100,Backing up...,Please wait, This may take some time if it has been a while since your last full backup.
	cur:=ssn(current(1),"@file").Text
	SplitPath,cur,,dir
	backup:=dir "\backup\Full Backup" A_Now
	FileCreateDir,%backup%
	loop,%dir%\*.*
	{
		if InStr(a_loopfilename,".exe") || InStr(A_LoopFileName,".dll")
		continue
		filecopy,%A_LoopFileFullPath%,%backup%\%A_LoopFileName%
	}
	loop,%dir%\backup\*.*,2
	if !InStr(A_LoopFileFullPath,"Full Backup")
	fileremovedir,%a_loopfilefullpath%,1
	SplashTextOff
	;neat 
}
toggle_comment_line(){
	sc:=v.sc,sc.2078
	pi:=posinfo(),sl:=sc.2166(pi.start),el:=sc.2166(pi.end),end:=pi.end,single:=sl=el?1:0
	while,sl<=el{
		letter:=sc.textrange(min:=sc.2128(sl),min+1)
		if (min>end&&!single)
		break
		if (letter=";")
		sc.2190(min),sc.2192(min+1),sc.2194(0,""),end--
		else
		sc.2190(min),sc.2192(min),sc.2194(1,";"),end++
		sl++
	}
	sc.2079
}
posinfo(){
	sc:=v.sc
	current:=sc.2008
	line:=sc.2166(current),se:=[]
	ind:=sc.2128(line)
	lineend:=sc.2136(line)
	se[current]:=1,se[sc.2009]:=1
	out:={current:current,line:line,ind:ind,lineend:lineend,start:se.minindex(),end:se.maxindex()}
	return out
}

Create_Comment_Block(){
	pos:=posinfo(),sc:=v.sc
	start:=end:=laststart:=lastend:=sc.2128(sc.2166(sc.2008))
	cs:=sc.2010(start)
	sc.2078
	if (cs=10){
		start:=end:=sc.2128(sc.2166(sc.2008))
		docend:=sc.2006
		while sc.2010(start)=10&&start>0{
			laststart:=start
			start--
		}
		while sc.2010(end)=10&&end<docend{
			lastend:=end
			end++
		}
		start:=laststart
		end:=lastend
		if !start
		start:=0
		if !end
		end:=docend
		sc.2160(end,end-1)
		sc.2338
		sc.2160(start,start+1)
		sc.2338
	}
	else
	{
		start:=sc.2128(sc.2166(pos.start)),end:=sc.2136(sc.2166(pos.end))
		sc.2003(start,inline "/*`r`n")
		if (pos.start=pos.end)
		sc.2003(end+4,"`r`n*/")
		else
		sc.2003(end+4,"`r`n*/")
	}
	fix_indent(sc,1)
	sc.2079
}
quick_find(){
	static
	qf:=setup(5)
	for a,b in ["Text,,Find","Edit,w200 gqfsearch vqfind","Text,,Replace","Edit,w200 vreplace","Checkbox,vregex gqfsearch,Regex","Checkbox,x+10 vgr gqfsearch,Greed"
	,"Checkbox,xm vcs gqfsearch,Case Sensitive","Checkbox,xm vsis gqfsearch,Search in Selection"
	,"Button,gqfrep,Replace All","Button,greplacecurrent,Replace Current","Button,gnextfound Default,Next Found"]{
		StringSplit,info,b,`,
		Gui,Add,%info1%,%info2%,%info3%
		info1:=info2:=info3:=""
	}
	p:=posinfo(),sc:=v.sc,indic:=[],os:=p.start+1,oe:=p.end,getpos()
	Gui,Show,,Quick Find
	multi:=settings.ssn("//fonts/font[@code='" 2601 "']/@color").text
	multi:=multi?multi:0xff0000
	sc.2601(multi)
	if (os!=oe)
	indic:={os:os,oe:oe}
	else
	indic:={os:0,oe:sc.2006}
	for a,b in xml.easyatt(settings.ssn("//quick_find"))
	GuiControl,5:,%a%,%b%
	ControlSend,Edit1,^a,% aid(qf)
	return
	Nextfound:
	sc:=v.sc
	sc.2606
	sc.2169
	return
	qfsearch:
	Gui,5:Submit,Nohide
	sc:=v.sc,find:=""
	find.=gr?"":"U"
	find.=cs?"O)":"Oi)"
	find.=regex=0?"(\Q" qfind "\E)":qfind
	if !qfind
	return sc.2571
	indic["sel"]:=sis
	total:=q_f(find,indic)
	sc.2574(0)
	return
	5GuiEscape:
	5GuiClose:
	Gui,Submit
	settings.add({path:"quick_find",att:{qfind:qfind,replace:replace,cs:cs,regex:regex,sis:sis,gr:gr}})
	destroy(5)
	if !total
	sc.2160(indic.os-1,indic.oe)
	WinActivate,% aid()
	return
	replacecurrent:
	Gui,Submit,Nohide
	sc:=v.sc
	main:=sc.2575
	end:=sc.2577(main),start:=sc.2579(main)
	otext:=sc.textrange(start,end)
	rep:=RegExReplace(otext,find,replace,"",1,1)
	sc.2190(start),sc.2192(end),sc.2194(StrLen(rep),rep)
	sc.2606
	sc.2169
	return
	Qfrep:
	Gui,Submit,Nohide
	sc:=v.sc
	main:=sc.2575
	end:=sc.2577(main),start:=sc.2579(main)
	otext:=sc.textrange(start,end)
	rep:=RegExReplace(otext,find,replace,"",1,1)
	clip:=Clipboard
	Clipboard:=rep
	if rep in ``r,``n,``r``n,`\r,`\n,`\r`\n
	clipboard:=Chr(10)
	sc.2179
	clipboard:=clip
	count:=sc.2570
	add:=add*count
	goto 5GuiClose
	return
}
q_f(find="",sel=0){
	sc:=v.sc
	sc.2571
	text:=sc.gettext()
	if (sel.sel && Abs(sel.os-sel.oe)>1){
		found:=sel.os
		text:=SubStr(text,1,sel.oe)
	}
	found:=found?found:1
	while found:=RegExMatch(text,find,fo,found){
		if A_Index=1
		sc.2160(fo.pos()-1,fo.pos()+strlen(fo.0)-1)
		else
		sc.2573(fo.pos()+strlen(fo.0)-1,fo.pos()-1)
		found+=fo.len()
		total:=A_Index
	}
	if (total="")
	sc.2571
	return total
}
copy(){
	OnClipboardChange:
	copy:
	if v.startup
	return
	if WinActive(aid())
	v.sc.2178
	if !IsObject(v.clipboard)
	v.clipboard:=[]
	for a,b in v.clipboard
	if b=%clipboard%
	return
	v.clipboard.insert(Clipboard)
	if v.window.21
	clipboard_viewer(1)
	return
}
paste(){
	paste:
	v.sc.2179
	fix_indent(v.sc)
	return
}
cut(){
	v.sc.2177
}
clean_position_data(){
	nodes:=positions.sn("/*/*")
	while,node:=nodes.item[a_index-1]
	ifnotexist,% ssn(node,"@file").text
	xml.remove(node),list.=ssn(node,"@file").text "`n"
	save()
	if list
	m("Information for files:`n" list "has been deleted.")
	else
	m("All position data is current")
}
Duplicate_line(){
	v.sc.2469
}
destroy(win){
	Gui,1:-Disabled
	position:=winpos(WinActive("A"))
	if !position
	return
	if pos:=settings.ssn("//gui/position[@window='" win "']")
	pos.Text:=position
	else
	ss:=settings.add({path:"gui/position",att:{window:win},text:position,dup:1})
	ControlFocus,,% aid(v.sc.sc)
	Gui,%win%:Destroy
	v.window.remove(win)
}
keywords(){
	v.keywords:=[],v.kw:=[],v.custom:=[]
	for a,b in {cmd:commands.ssn("//Commands/Commands").text,itm:commands.ssn("//Commands/Items").text,user:settings.ssn("//Variables").text}{
		%a%:=b
		if a=cmd
		command:=%a%
		list.=%a% " "
		StringLower,%a%,%a%
		v.keywords[A_Index]:=%a%
	}
	ll:=settings.sn("//fonts/highlight/*")
	while,l:=ll.item(A_Index-1){
		v.custom[A_Index]:=l.text
		for a,b in v.keywords
		v.keywords[a]:=RegExReplace(b,"i)\b(" RegExReplace(l.text," ","|") ")\b")
	}
	v.cmds:=command
	v.user:=user
	v.keywords.list:=list
	sort,list,UD%A_Space%
	Loop,Parse,list,%a_space%,%a_space%
	v.keywords[substr(a_loopfield,1,1)].=a_loopfield " "
	Loop,Parse,command,%A_Space%,%A_Space%
	v.kw[A_LoopField]:=A_LoopField
}
Personal_Variable_List(){
	static
	qf:=setup(6)
	Gui,Add,ListView,w200 h400,Variables
	Gui,Add,Edit,w200 vvariable
	Gui,Add,Button,gaddvar Default,Add
	Gui,Add,Button,x+10 gvdelete,Delete Selected
	ControlFocus,Edit1,% aid(vars)
	Gui,Show,,Variables
	vars:=settings.sn("//Variables/*")
	while,vv:=vars.item(A_Index-1)
	LV_Add("",vv.text)
	ControlFocus,Edit1,% aid(qf)
	return
	vdelete:
	while,LV_GetNext(){
		LV_GetText(string,LV_GetNext())
		this:=settings.ssn("//Variable[text()='" string "']")
		this.parentnode.removechild(this)
		LV_Delete(LV_GetNext())
	}
	return
	addvar:
	Gui,6:Submit,Nohide
	if !variable
	return
	if !settings.ssn("//Variables/Variable[text()='" variable "']")
	settings.add({path:"Variables/Variable",text:variable,dup:1}),LV_Add("",variable)
	settings.Transform()
	ControlSetText,Edit1,,% aid(qf)
	return
	6GuiClose:
	6GuiEscape:
	keywords()
	Destroy(6)
	if v.theme
	if WinExist(aid(v.Theme))
	v.themesc.2181(0,themetext())
	return
}
setup(window,nodisable=""){
	ea:=settings.ea("//font[@style='5']")
	Background:=ea.Background,font:=ea.font,color:=RGB(ea.color)
	Background:=Background?Background:0
	size:=10
	Gui,%window%:Destroy
	Gui,%window%:Default
	Gui,+hwndhwnd
	if !nodisable{
		Gui,+Owner1 -0x20000
		Gui,1:+Disabled
	}
	Gui,color,% RGB(Background),% RGB(Background)
	Gui,Font,% "s" size " c" color,%font%
	Gui,%window%:Default
	v.window[window]:=1
	return hwnd
}
publish(return=""){
	sc:=v.sc,text:=update({get:1}),save()
	com:=files.sn("//*[@doc='" sc.2357 "']../*")
	while,file:=ssn(com.item(A_Index-1),"@file")
	publish.=text[file.text] "`r`n"
	publish:=Trim(publish,"`r`n")
	ea:=xml.easyatt(vversion.ssn("//*[@file='" ssn(current(1),"@file").text "']"))
	newver:=ea.version "." ea.increment
	aa:=vversion.ea("//info[@file='" ssn(current(1),"@file").text "']")
	repver:=aa.versstyle?newver:"Version=" newver
	if InStr(publish,Chr(59) "auto_version")
	publish:=RegExReplace(publish,Chr(59) "auto_version",repver)
	if return
	return publish
	Clipboard:=publish
	MsgBox,,AHK Studio,Project coppied to your clipboard,.6
}
close(){
	save()
	sc:=v.sc,udf:=update({get:1})
	close:=files.sn("//file[@doc='" sc.2357 "']../*")
	while,c:=close.item[A_Index-1]{
		att:=xml.easyatt(c)
		if att.doc
		sc.2377(0,att.doc)
		if att.tv
		TV_Delete(att.tv)
		udf[att.file]
	}
	file:=files.ssn("//file[@doc='" sc.2357 "']../@file").text
	remove:=settings.ssn("//open/file[text()='" file "']")
	remove.ParentNode.RemoveChild(remove)
	remove:=files.ssn("//file[@doc='" sc.2357 "']..")
	remove.ParentNode.RemoveChild(remove)
	if (v.control.maxindex()>1){
		DllCall("DestroyWindow",uptr,v.sc.sc)
		controllist(),arrange()
		ControlFocus,Scintilla1,% aid()
		cf("Scintilla1")
		return
	}
	else if files.sn("//main").length>0{
		tv({sc:sc,filename:files.ssn("//file[@file='" files.ssn("//@file").text "']")})
		ControlFocus,,% aid(sc.sc)
	}
	else
	untitled()
}
new_project(fn=""){
	if fn{
		text:=
		(
		"
		;You can start editing this file, open an existing one, or start a new file
		"
		)
		FileAppend,%text%,%fn%
	}
	else
	FileSelectFile,fn,,%A_ScriptDir%\Projects,Create a new file,*.ahk
	if ErrorLevel
	return
	fn:=InStr(fn,".ahk")?fn:fn ".ahk"
	FileAppend,% ";New file information will be editable in future releases",%fn%
	file:=settings.add({path:"open/file",text:fn})
	open({list:file})
	tv({filename:files.ssn("//file[@file='" fn "']")})
	;change open from an object based thingie to a file1,file2,file3 thing
}
character_count(){
	sc:=v.sc
	if sc.2161>1
	m(sc.2161-1)
	else
	m(sc.2183)
}
open_in_new_window(){
	open(1)
}
untitled(){
	count=1
		Loop,projects\*.ahk
		{
			if InStr(A_LoopFileName,"untitled")
			count++
		}
		new_project(A_ScriptDir "\projects\Untitled(" count ").ahk")
}
upload(winname="Upload"){
	static
	uphwnd:=setup(10)
	window({win:10,gui:["Text,Section,Version:","Edit,w200 vversion x+5 ys-2","text,x+5,.","Edit,x+5 w100 vincrement","UpDown,gincrement Range0-2000 0x80","Text,xs,Version Information:","Edit,w400 h400 vversioninfo"
	,"Text,Section,Upload directory:","Edit,vdir w200 x+10 ys-2","Checkbox,vcompile xm,Compile","Checkbox,vgistversion xm,Update Gist Version"
	,"Checkbox,vupver,Upload without progress bar (a bit more stable)","Checkbox,vversstyle,Remove (Version=) from the " chr(59) "auto_version"
	,"Button,w200 gupload xm Default,Upload"]})
	file:=ssn(current(1),"@file").text
	Gui,show,AutoSize,%winname%
	list:={compile:"Button1",version:"Edit1",increment:"Edit2",dir:"Edit4",gistversion:"Button2",upver:"Button3",versstyle:"Button4"}
	for a,b in vversion.ea("//info[@file='" file "']")
	GuiControl,10:,% list[a],%b%
	GuiControl,10:,Edit3,% vversion.ssn("//info[@file='" file "']").text
	ControlFocus,Edit3,% aid(uphwnd)
	Send,^{Home}{Down}
	return
	upload:
	gosub 10guiescape
	w:=window({get:10})
	if w.compile
	compile()
	f:=new ftp
	if f.Error
	return
	r:=f.put(file,w.dir,w.compile)
	if w.gistversion
	gist_post_version()
	if r
	m("Transfer complete")
	return
	10GuiEscape:
	10GuiClose:
	file:=ssn(current(1),"@file").text
	att:=[],win:=window({get:10})
	for a,b in win
	if a=versioninfo
	text:=b
	else
	att[a]:=b
	att.file:=file
	uq:=vversion.unique({path:"info",att:att,check:"file"}),uq.text:=text
	vversion.Transform(),vversion.save()
	destroy(10)
	ftp.cleanup()
	return
	increment:
	info:=window({get:10})
	ver:=info.version "." info.increment
	if !InStr(info.versioninfo,ver)
	ControlSetText,Edit3,% ver "`r`n`r`n" RegExReplace(info.versioninfo,"\n","`r`n"),% aid(uphwnd)
	ControlFocus,Edit3,% aid(uphwnd)
	Send,^{Home}{Down}
	return
}
startup(){
	if !FileExist("lib")
	FileCreateDir,lib
	if !FileExist("Projects")
	FileCreateDir,Projects
	DetectHiddenWindows,On
}
gui(){
	DllCall("LoadLibrary","str","scilexer.dll"),ea:=settings.ea("//font[@style='5']")
	Gui,+Resize +hwndmain
	Gui,Color,% RGB(ea.Background),ea.color
	Gui,Font,% "s10 c" RGB(ea.color),% ea.font
	Gui,Add,TreeView,% "w200 h500 Background" RGB(ea.Background) " gtv AltSubmit c" RGB(ea.color)
	v.main:=main,num:=settings.ssn("//@number").Text,num:=num?num:1
	Loop,% num
	new s
	Gui,Add,TreeView,% "ym Background" RGB(ea.Background) " c" RGB(ea.color) " w90 AltSubmit gcej sort"
	Gui,TreeView,SysTreeView321
	Gui,Add,StatusBar,hwndstatus
	pos:=settings.ssn("//gui/position").text,pos:=pos?pos:"w" A_ScreenWidth-100 " h" A_ScreenHeight-100
	controllist(),arrange(),cf(),options(1)
	Gui,show,%pos%,scintilla
	if settings.ssn("//position/@max").Text
	WinMaximize,% aid()
	count=1
	Gui,1:Default
	GuiControl,-Redraw,SysTreeView321
	if !settings.sn("//open/*").length
	untitled()
	else
	open({list:settings.ssn("//open")})
	for a,b in v.control{
		fname:=files.ssn("//file[@file='" settings.ssn("//last/file[" A_Index "]").text "']")
		if !fname
		fname:=files.ssn("//main")
		if !FileExist(ssn(fname,"@file").text)
		fname:=files.ssn("//file/@file/..")
		tv({sc:s.ctrl[b],filename:fname}),marginwidth(s.ctrl[b])
	}
	TV_Modify(files.ssn("//file[@file='" settings.ssn("//last/file[1]").text "']/@tv").text,"Select Focus Vis")
	GuiControl,+Redraw,SysTreeView321
}
code_vault(pop=0){
	static vault:=new xml("vault","lib\vault.xml"),cv,text
	if (pop){
		Menu,vault,Add,Edit Vault,editvault
		items:=vault.sn("//locker")
		while,m:=items.item(a_index-1)
		Menu,vault,Add,% ssn(m,"@locker").text,insertcode
		Menu,main,Add,Code Vault,:vault
		return
	}
	editvault:
	cv:=setup(9)
	Gui,Add,ListView,w200 h300 -Multi gvdisplay AltSubmit,Vault
	Gui,Add,Edit,w500 h300 x+10 gwritecode
	Gui,Add,Button,gaddvault xm,Add Code
	Gui,Add,Button,gmd x+10,Remove selected from vault
	items:=vault.sn("//locker")
	while,m:=items.item(a_index-1)
	LV_Add("",ssn(m,"@locker").text)
	Gui,show,,Code Vault
	return
	vdisplay:
	if LV_GetNext()=0||A_GuiEvent!="Normal"
	return
	LV_GetText(locker,LV_GetNext())
	ControlSetText,Edit1,% RegExReplace(vault.ssn("//*[@locker='" locker "']").text,"\n","`r`n")
	return
	md:
	if !LV_GetNext()
	return
	LV_GetText(rem,LV_GetNext())
	remove:=vault.ssn("//locker[@locker='" rem "']")
	remove.ParentNode.RemoveChild(remove)
	Menu,vault,Delete,%rem%
	code_vault(1),LV_Delete(LV_GetNext())
	return
	addvault:
	InputBox,new,New Code,Name please
	if !new
	return
	if !vault.ssn("//locker[@locker='" new "']"){
		vault.add({path:"locker",att:{locker:new},dup:1}),pos:=LV_Add("",new),LV_Modify(pos,"Select Vis Focus")
		code_vault(1)
		WinActivate,% aid(cv)
		ControlFocus,Edit1,% aid(cv)
		ControlSetText,Edit1,,% aid(cv)
	}
	return
	insertcode:
	MsgBox,4,Add as a new function,Create a new function?
	IfMsgBox,Yes
	{
		func:=A_ThisMenuItem
		cur:=ssn(current(1),"@file").Text
		SplitPath,cur,,dir
		if FileExist(dir "\" func)
		return m("Segment already exists.  Please choose another name")
		new_segment(dir "\" func)
		sleep,400
	}
	v.sc.2003(v.sc.2008,vault.ssn("//*[@locker='" A_ThisMenuItem "']").text)
	return
	writecode:
	if !LV_GetNext()
	return
	LV_GetText(cc,LV_GetNext())
	ControlGetText,text,Edit1,% aid(cv)
	vault.unique({path:"locker",att:{locker:cc},check:"locker"}).text:=text
	return
	9GuiClose:
	9GuiEscape:
	if A_Gui=9
	vault.Transform(),vault.save()
	destroy(A_Gui)
	return
}
run_x64(){
	save()
	SplitPath,A_AhkPath,,apdir
	file:=ssn(current(1),"@file").text
	SplitPath,file,filename,dir
	run,% apdir "\AutoHotkeyU64.exe " Chr(34) filename Chr(34),%dir%
}
compile(){
	main:=ssn(current(1),"@file").Text
	SplitPath,main,,dir,,name
	SplitPath,A_AhkPath,file,dirr
	Loop,%dirr%\Ahk2Exe.exe,1,1
	file:=A_LoopFileFullPath
	FileDelete,temp.upload
	FileAppend,% publish(1),temp.upload
	SplashTextOn,200,100,Compiling,Please wait.
	RunWait,%file% /in temp.upload /out "%dir%\%name%.exe"
	If FileExist("upx.exe"){
		SplashTextOn,,50,Compressing EXE,Please wait...
		RunWait,upx.exe -9 "%dir%\%name%.exe",,Hide
		SplashTextOff
	}
	FileDelete,temp.upload
	SplashTextOff
}
marginwidth(sc=""){
	sc:=sc?sc:sc:=v.sc
	sc.2242(0,sc.2276(32,"a" sc.2154))
}































titlechange(){
	WinSetTitle,% aid(),,% "AHK Studio: " ssn(current(),"@file").text
}
Dlg_Font(ByRef Style,Effects=1,window=""){
	VarSetCapacity(LOGFONT,60),strput(style.font,&logfont+28,32,"CP0")
	LogPixels:=DllCall("GetDeviceCaps","uint",DllCall("GetDC","uint",0),"uint",90),Effects:=0x041+(Effects?0x100:0)
	for a,b in font:={16:"bold",20:"italic",21:"underline",22:"strikeout"}
	if style[b]
	NumPut(b="bold"?700:1,logfont,a)
	style.size?NumPut(Floor(style.size*logpixels/72),logfont,0):NumPut(16,LOGFONT,0)
	VarSetCapacity(CHOOSEFONT,60,0),NumPut(60,CHOOSEFONT,0),NumPut(&LOGFONT,CHOOSEFONT,12),NumPut(Effects,CHOOSEFONT,20),NumPut(style.color,CHOOSEFONT,24),NumPut(window,CHOOSEFONT,4)
	if !r:=DllCall("comdlg32\ChooseFontA", "uint",&CHOOSEFONT)
	return
	Color:=NumGet(CHOOSEFONT,24)
	bold:=NumGet(LOGFONT,16)>=700?1:0
	style:={size:NumGet(CHOOSEFONT,16)//10,font:StrGet(&logfont+28,"CP0"),color:color}
	for a,b in font
	style[b]:=NumGet(LOGFONT,a,"UChar")?1:0
	style["bold"]:=bold
	return 1
}
cfont(){
	return settings.ea("//font[@style='5']")
}
edit_replacements(){
	static
	er:=setup(7),window({win:7,gui:["ListView,w400 h500,Value|Replacement","Text,,Value:","Edit,x+10 w200 vvalue","Text,xm,Replacement:","Edit,x+10 w200 vreplacement","Button,xm geradd Default,Add","Button,x+10 gerremove,Remove Selected"]}),sn:=settings.sn("//replacements/*")
	while,val:=sn.item(A_Index-1)
	LV_Add("",ssn(val,"@replace").text,val.text)
	LV_Modify(1,"Select Focus Vis"),hotkey({win:er,list:{"~Delete":"err","~BS":"err"}})
	Gui,Show,,Replacements
	return
	eradd:
	rep:=window({get:7})
	if !(rep.replacement&&rep.value)
	return m("both values are required")
	if !settings.ssn("//replacements/*[@replace='" rep.value "']")
	settings.add({path:"replacements/replacement",att:{replace:rep.value},text:rep.replacement,dup:1}),LV_Add("",rep.value,rep.replacement)
	Loop,2
	ControlSetText,Edit%A_Index%
	ControlFocus,Edit1
	return
	err:
	ControlGetFocus,focus,% aid(er)
	if Focus=SysListView321
	goto erremove
	return
	erremove:
	Gui,7:Default
	while,LV_GetNext(),LV_GetText(value,LV_GetNext())
	rem:=settings.ssn("//replacements/*[@replace='" value "']"),LV_Delete(LV_GetNext()),rem.ParentNode.RemoveChild(rem)
	return
}
window(info){
	static
	static variables:=[]
	if info.get{
		vars:=[],win:=info.get
		Gui,%win%:Submit,Nohide
		for a,b in variables[info.get]
		vars[a]:=%a%
		return vars
	}
	for a,b in info.gui{
		StringSplit,b,b,`,
		Gui,Add,%b1%,%b2% hwndpoo,%b3%
		RegExMatch(b2,"U)\bv(.*\b)",found)
		b2:=b3:=""
		if found1
		variables[info.win,found1]:=1
	}
}
snapshot(hwnd,win,list){
	offset:=[]
	Gui,Show,AutoSize hide
	SysGet,border,33
	SysGet,Caption,4
	VarSetCapacity(size,16,0),DllCall("user32\GetClientRect","uint",hwnd,"uint",&size),w:=NumGet(size,8),h:=NumGet(size,12)
	for a,b in list
	for c,d in b{
		ControlGetPos,x,y,cw,ch,%a%,% aid(hwnd)
		if (d="w")
		offset[a,d]:=w-cw
		if (d="h")
		offset[a,d]:=h-ch
		if (d="x")
		offset[a,d]:=w-(x-Border)
		if (d="y")
		offset[a,d]:=h-(y-Border-Caption)
	}
	v["window",win]:=offset
}
controllist(){
	control:=[],misc.remove("//scintilla")
	WinGet,list,ControlList,% aid()
	Loop,Parse,list,`n
	if InStr(A_LoopField,"scintilla"){
		count++
		ControlGet,hwnd,hwnd,,%A_LoopField%,% aid()
		control[count]:=hwnd
		misc.add({path:"scintilla/control",att:{number:count,sc:hwnd},dup:1})
	}
	v.control:=control,v.reverse:=reverse
}
winpos(hwnd){
	VarSetCapacity(size,16,0),DllCall("user32\GetClientRect","uint",hwnd,"uint",&size),w:=NumGet(size,8),h:=NumGet(size,12)
	WinGetPos,x,y,,,% aid(hwnd)
	if x&&y&&w&&h
	return "x" x " y" y " w" w " h" h
	else
	return
}
Remove_Spaces_From_Selected(){
	sc:=v.sc,pos:=posinfo()
	replace:=sc.textrange(pos.start,pos.end)
	replace:=RegExReplace(replace," ")
	sc.2170(0,replace)
}
class ftp{
	__New(){
		ea:=settings.ea("//ftp"),this.error:=0
		if !(ea.username!=""&&ea.password!=""&&ea.server!="")
		return m("Please setup your ftp information in settings"),settings()
		port:=ea.port?ea.port:21
		SplashTextOn,200,100,Logging In,Please Wait...
		this.library:=DllCall("LoadLibrary","str","wininet.dll","Ptr")
		this.Internet:=DllCall("wininet\InternetOpen","str",A_ScriptName,"UInt",AccessType,"str",Proxy,"str",ProxyBypass ,"UInt",0,"Ptr")
		if !this.internet
		this.cleanup(A_LastError)
		this.connect:=DllCall("wininet\InternetConnect","PTR",this.internet,"str",ea.Server,"uint",Port,"str",ea.Username,"str",ea.Password,"uint",1,"uint",flags,"uint",0,"Ptr")
		if !this.connect{
			this.cleanup(A_LastError)
			SplashTextOff
		}
		VarSetCapacity(ret,40)
	}
	createfile(name){
		list:=[]
		SplitPath,name,filename,dir,,namenoext
		IfNotExist,temp
		FileCreateDir,temp
		for a,b in [{text:publish(1),name:filename},{text:RegExReplace(vversion.ssn("//info[@file='" name "']").text,"\n","`r`n"),name:namenoext ".text"}]{
			FileDelete,% "temp\" b.name
			file:=FileOpen("temp\" b.name,2)
			file.write(b.text)
			file.seek(0)
			list[b.name]:=file
			if vversion.ssn("//*[@file='" ssn(current(1),"@file").text "']/@upver").text
			file.close()
		}
		return list
	}
	put(file,dir,compile){
		SplashTextOff
		updir:="/" Trim(RegExReplace(dir,"\\","/"),"/")
		this.cd("/" Trim(RegExReplace(dir,"\\","/"),"/"))
		if !(this.internet!=0&&this.connection!=0)
		return 0
		SplitPath,file,name,dir,,namenoext
		list:=this.createfile(file)
		BufferSize:=4096
		if compile
		list[namenoext ".exe"]:=FileOpen(dir "\" namenoext ".exe","r")
		upver:=vversion.ssn("//*[@file='" ssn(current(1),"@file").text "']/@upver").text
		for a,b in list{
			if upver{
				ff:=!InStr(a,".exe")?A_ScriptDir "\temp\" a:dir "\" namenoext ".exe"
				SplitPath,a,fname
				SplashTextOn,300,50,Uploading file %a%,Please Wait...
				ii:=DllCall("wininet\FtpPutFile",UPtr,this.connect,UPtr,&ff,UPtr,&fname,UInt,2,UInt,0,"cdecl")
				SplashTextOff
			}
			else
			{
				ff:=DllCall("wininet\FtpDeleteFile",UPtr,this.connect,UPtr,&a,"cdecl")
				this.file:=DllCall("wininet\FtpOpenFile",UPtr,this.connect,UPtr,&a,UInt,0x40000000,UInt,0x2,UPtr,0,"cdecl")
				Progress,0,uploading,%a%,Uploading,% cfont().font
				if !this.file
				this.cleanup(A_LastError)
				length:=b.length,totalsize:=0
				size:=1,b.seek(0)
				while,size{
					size:=b.rawread(buffer,BufferSize)
					totalsize+=size
					Progress,% (totalsize*100)/length
					DllCall("wininet\InternetWriteFile","PTR",this.File,"PTR",&Buffer,"UInt",size,"UIntP",out,"cdecl")
					sleep,10
					;t(this.file,a,close,totalsize,b.length)
				}
				close:=DllCall("wininet\InternetCloseHandle","UInt",this.file)
				sleep,100
				b.close()
			}
		}
		t()
		list:=""
		Progress,Off
	}
	__Delete(){
		this.cleanup
	}
	cleanup(error*){
		if error.1
		m(error.1)
		SplashTextOff
		if (error.1){
			this.error:=1
			MsgBox,48,AHK Studio,% this.GetLastError(error.1)
		}
		for a,b in [this.file,this.connect,this.internet]
		DllCall("wininet\InternetCloseHandle","UInt",this.internet)
		DllCall("FreeLibrary","UInt",this.library)
		return 0
	}
	CD(dir){
		available:=DllCall("wininet\FtpSetCurrentDirectory",UInt,this.connect,UPtr,&dir,"cdecl")
		if !available
		Loop,Parse,dir,/
		this.createdir(A_LoopField),this.setdir(A_LoopField)
	}
	setdir(dir){
		DllCall("wininet\FtpSetCurrentDirectory",UInt,this.connect,UPtr,&dir,"cdecl")
	}
	createdir(dir){
		DllCall("wininet\FtpCreateDirectory",UPtr,this.connect,UPtr,&dir,"cdecl")
	}
	GetDir(){
		cap:=VarSetCapacity(dir,128)
		DllCall("wininet\FtpGetCurrentDirectory",UInt,this.connect,UInt,&dir,UInt,&cap,"cdecl")
		return Trim(StrGet(&dir,128,"cp0"),"/")
	}
	;http://msdn.microsoft.com/en-us/library/ms679351
	GetLastError(error){
		size:=VarSetCapacity(buffer,1024)
		if (error = 12003){  ;ERROR_INTERNET_EXTENDED_ERROR
		VarSetCapacity(ErrorMsg,4)
		DllCall("wininet\InternetGetLastResponseInfo","UIntP",&ErrorMsg,"PTR",&buffer,"UIntP",&size)
		Return StrGet(&buffer,size)
	}
	DllCall("FormatMessage","UInt",0x00000800,"PTR",this.library,"UInt",error,"UInt",0,"Str",buffer,"UInt",size,"PTR",0)
	Return buffer
}
}
google_search_selected(){
	sc:=v.sc,text:=RegExReplace(sc.getseltext()," ","+")
	string:="http://www.google.com/search?q=" text
	Run,%string%
}
Check_For_New_Version(){
	static version
	Version=0.001.53
	static hh
	ver:=URLDownloadToVar("http://maestrith.com/files/AHKStudio/AHK Studio.text")
	hh:=setup(12)
	Gui,+Resize +hwndhwnd
	Gui,Margin,0,0
	Gui,Add,Button,%pos% gauto_update,Auto Update
	vv:=new s(12)
	ControlGetPos,,y,,h,Button1,ahk_id%hh%
	ControlMove,Scintilla1,,% h+y,,,ahk_id%hh%
	pos:=Settings.ssn("//gui/position[@window='12']").text
	pos:=pos?pos:"w800 h700"
	snapshot(hwnd,12,{Scintilla1:["w","h"]})
	Gui,Show,%pos%,Version : Current Version = %version%
	vv.2181(0,ver)
	return
	12GuiEscape:
	12GuiClose:
	destroy(12)
	return
	auto_update:
	ext:=A_IsCompiled?".exe":".ahk"
	FileMove,%A_ScriptName%,backup-%version%-%A_ScriptName%,1
	SplashTextOn,,50,Downloading Update,Please wait...
	URLDownloadToFile,http://www.maestrith.com/files/AHKStudio/AHK Studio%ext%,%A_ScriptName%
	Run,%A_ScriptName%
	ExitApp
	return
}
URLDownloadToVar(url){
	hObject:=ComObjCreate("WinHttp.WinHttpRequest.5.1")
	hObject.Open("GET",url)
	hObject.Send()
	return hObject.ResponseText
}
filecheck(){
	FileGetVersion,ver,scilexer.dll
	if (ver!="3.3.4.0")
	FileDelete,scilexer.dll
	FileInstall,scilexer.dll,scilexer.dll
	FileInstall,lib\commands.xml,lib\commands.xml
	if !(FileExist("lib\commands.xml")&&FileExist("scilexer.dll"))
	SplashTextOn,200,100,Checking for proper files,Please wait...
	if !FileExist("lib\commands.xml"),fix:=1
	URLDownloadToFile,http://www.autohotkey.net/~maestrith/tempstudio/commands.xml,lib\commands.xml
	if !FileExist("scilexer.dll")
	urldownloadtofile,http://www.maestrith.com/files/AHKStudio/SciLexer.dll,SciLexer.dll
	SplashTextOff
	commands:=new xml("commands","lib\commands.xml")
	if fix
	commands.Transform(),commands.save()
}
post_all_in_one_gist(info=""){
	url:="https://api.github.com/gists"
	info:=info?info:publish(1)
	get_access()
	file:=ssn(current(1),"@file").text
	id:=positions.ssn("//main[@file='" file "']/@id").text
	SplitPath,file,filename
	info:=RegExReplace(info,"([" Chr(34) "\\])","\$1")
	for a,b in {"`n":"\n","`t":"\t","`r":""}
	StringReplace,info,info,%a%,%b%,All
	desc=Posted using AHK Studio
	http:=ComObjCreate("WinHttp.WinHttpRequest.5.1")
	json={"description":"%desc%","public":true,"files":{"%filename%":{"content":"%info%"}}}
	check_id(id)
	if id
	http.Open("PATCH",url "/" id)
	else
	http.Open("POST",url)
	if access_token
	http.SetRequestHeader("Authorization","Bearer " access_token)
	http.send(json)
	codes:=http.ResponseText
	split:=http.option(1)
	SplitPath,split,fname
	m(fname,split)
	for a,b in ["html_url","id"]{
		split=":"
		RegExMatch(codes,"U)" b split "(.*)" chr(34),found)
		if b=html_url
		clipboard:=RegExReplace(found1,"\\")
		else
		id:=found1
	}
	if id{
		positions.unique({path:"main",att:{file:file,id:id},check:"file"})
		TrayTip,AHK Studio,Gist URL coppied to Clipboard,1
	}
	else
	m("Something went wrong.  Here is what the server sent back","","",codes)
}
Post_Multiple_Segment_Gist(){
	get_access()
	ea:=xml.easyatt(vversion.ssn("//*[@file='" ssn(current(1),"@file").text "']")),newver:=ea.version "." ea.increment
	fi:=sn(current(1),"file/@file"),file:=ssn(current(1),"@file").text
	id:=positions.ssn("//main[@file='" file "']/@multiple_id").text
	url:="https://api.github.com/gists"
	if id
	id:=check_id(id)
	SplitPath,file,filename
	desc=Posted using AHK Studio
	json={"description":"%desc%","public":true,"files":
	json.="{"
	udf:=update({get:1})
	while,f:=fi.item(A_Index-1).text{
		SplitPath,f,filename
		info:=udf[f]
		if a_index=1
		info.=compile_main_gist(f)
		json.=json(info,filename)
		if (fi.length!=A_Index)
		json.=","
	}
	StringTrimRight,json,json,1
	json.="}}"
	http:=ComObjCreate("WinHttp.WinHttpRequest.5.1")
	if id
	http.Open("PATCH",url "/" id)
	else
	http.Open("POST",url)
	http.SetRequestHeader("Authorization","Bearer " access_token)
	SplashTextOn,,50,Updating Gist,Please wait...
	http.send(json)
	codes:=http.ResponseText
	for a,b in ["html_url","id"]{
		split=":"
		RegExMatch(codes,"U)" b split "(.*)" chr(34),found)
		if b=html_url
		clipboard:=RegExReplace(found1,"\\")
		else
		id:=found1
	}
	SplashTextOff
	if id{
		positions.unique({path:"main",att:{file:file,multiple_id:id},check:"file"})
		m("URL Coppied to clipboard")
	}
	else
	m("Something went wrong.  Here is what the server sent back","","",codes,http.GetAllResponseHeaders())
}
json(info,filename){
	if !RegExReplace(info,"\s"){
		info="%filename%":{"content":";blank file"}
		return info
	}
	if InStr(info,Chr(59) "auto_version")
	info:=RegExReplace(info,Chr(59) "auto_version","Version=" newver)
	info:=RegExReplace(info,"([" Chr(34) "\\])","\$1")
	for a,b in {"`n":"\n","`t":"\t","`r":""}
	StringReplace,info,info,%a%,%b%,All
	next="%filename%":{"content":"%info%"}
	return next
}
compile_main_gist(filename){
	fn:=sn(current(1),"file/@file")
	while,f:=fn.item(A_Index-1).text{
		if A_Index=1
		continue
		SplitPath,f,filename
		text.="`r`n" Chr(35) "Include " filename
	}
	return text
}
get_access(){
	if !access_token{
		InputBox,access_token,This feature requires an access token from Github to use,Please enter your access token`nor press cancel to be taken to instructions on how to get an access token
		if (ErrorLevel||access_token=""){
			Run,http://www.autohotkey.com/board/topic/95515-ahk-11-create-a-gist-post/
			Exit
		}
		settings.add({path:"access_token",text:access_token})
	}
}
cf(con=""){
	static last:=""
	if IsObject(con){
		if !WinExist("ahk_id" con.sc){
			con=Scintilla1
			goto fixcon
		}
		v.sc:=con
		return last:=con
	}
	fixcon:
	con:=last=""&&!con?"Scintilla1":con
	if InStr(con,"scintilla"){
		ControlGet,hwnd,hwnd,,%con%,% aid()
		last:=s.ctrl[hwnd]
		v.sc:=last
	}
	return last
}
show(window){
	pos:=Settings.ssn("//gui/position[@window='" window "']").text
	pos:=pos?pos:"AutoSize"
	return pos
}
about(){
	about:=setup(14)
	licence=
	(
	License for Scintilla and SciTE
	
	Copyright 1998-2002 by Neil Hodgson <neilh@scintilla.org>
	
	All Rights Reserved 
	
	Permission to use, copy, modify, and distribute this software and its 
	documentation for any purpose and without fee is hereby granted, 
	provided that the above copyright notice appear in all copies and that 
	both that copyright notice and this permission notice appear in 
	supporting documentation. 
	
	NEIL HODGSON DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS 
	SOFTWARE, INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY 
	AND FITNESS, IN NO EVENT SHALL NEIL HODGSON BE LIABLE FOR ANY 
	SPECIAL, INDIRECT OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES 
	WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, 
	WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER 
	TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE 
	OR PERFORMANCE OF THIS SOFTWARE. 
	)
	sc:=new s(14)
	sc.2181(0,licence)
	ControlMove,Scintilla1,,,800,600,% aid(about)
	Gui,Show,w800 h600,About
	sc.2160(0,0)
	return
	14GuiClose:
	14GuiEscape:
	Destroy(14)
	return
}
custom_highlight_text(){
	static
	highlight:=setup(15)
	Gui,Add,Text,,Text should be space Delimited (this is a list)
	Gui,Add,ListView,w200 h500 AltSubmit gcht,List
	Gui,Add,Edit,x+10 w500 h500 gchtedit
	Loop,9
	LV_Add("","Custom List " A_Index)
	Gui,Show,,Custom Highlight Editor
	LV_Modify(1,"Select Vis Focus")
	return
	cht:
	if A_GuiEvent not in Normal,I
	return
	if list:=LV_GetNext()
	ControlSetText,Edit1,% settings.ssn("//fonts/highlight/list" list).text,% aid(highlight)
	return
	chtedit:
	if !list:=LV_GetNext()
	return
	ControlGetText,newtext,Edit1,% aid(highlight)
	StringLower,newtext,newtext
	hlt:=settings.add({path:"fonts/highlight/list" list,text:newtext,att:{list:list}})
	if !newtext
	return hlt.ParentNode.RemoveChild(hlt)
	return
	15GuiEscape:
	15GuiClose:
	Destroy(15),keywords(),list:=[]
	parent:=settings.ssn("//fonts/highlight")
	fix:=settings.sn("//fonts/highlight/*")
	while,ff:=fix.item(A_Index-1)
	list[ssn(ff,"@list").text]:=ff
	for a,b in list
	parent.AppendChild(b)
	if v.theme
	if WinExist(aid(v.Theme)){
		v.themesc.2181(0,themetext())
		color(v.themesc)
	}
	for a,b in v.control
	color(s.ctrl[b])
	return
}
restore_current_file(){
	file:=ssn(current(),"@file").text
	SplitPath,file,filename,dir
	restore:=setup(16)
	Gui,+Resize
	Gui,Add,ListView,x0 y0 w350 h480 altsubmit grestore,Backup
	Gui,Add,Edit,x+10 w550 h480
	Gui,Add,Button,x0 grestorefile Default,Restore selected file
	snapshot(restore,16,{SysListView321:["h"],Edit1:["w","h"],Button1:["y"]})
	SplashTextOn,,50,Collecting backup files,Please wait...
	loop,% dir "\backup\" filename,1,1
	{
		StringSplit,new,A_LoopFileDir,\
		last:=new0,d:=new%last%
		lv_add("",d)
	}
	LV_Modify(1,"select Focus")
	SplashTextOff
	Gui,Show,% show(16),Restore
	Restore:
	file:=ssn(current(),"@file").text
	SplitPath,file,filename,dir
	LV_GetText(bdir,LV_GetNext())
	FileRead,contents,% dir "\backup\" bdir "\" filename
	ControlSetText,Edit1,%contents%
	return
	restorefile:
	ControlGetText,contents,Edit1
	v.sc.2181(0,contents)
	16GuiClose:
	16GuiEscape:
	Destroy(16)
	return
}
gist_post_version(){
	name:=ssn(current(1),"@file").text
	url:="https://api.github.com/gists"
	info:=vversion.ssn("//info[@file='" name "']").text
	SplitPath,name,,,,nn
	json:=json(info,nn)
	get_access()
	http:=ComObjCreate("WinHttp.WinHttpRequest.5.1")
	file:=ssn(current(1),"@file").text
	id:=positions.ssn("//main[@file='" file "']/@version").text
	desc:="Posted with AHK Studio"
	json=
	(
	{"description":"%desc%","public":true,"files":{%json%}}
	)
	check_id(id)
	if id
	http.Open("PATCH",url "/" id)
	else
	http.Open("POST",url)
	if access_token
	http.SetRequestHeader("Authorization","Bearer " access_token)
	http.send(json)
	codes:=http.ResponseText
	for a,b in ["html_url","id"]{
		split=":"
		RegExMatch(codes,"U)" b split "(.*)" chr(34),found)
		if b=html_url
		hurl:=RegExReplace(found1,"\\")
		else
		id:=found1
	}
	if id{
		positions.unique({path:"main",att:{file:file,version:id},check:"file"})
		MsgBox,36,Gist Posted,Copy URL to Clipboard?
		IfMsgBox,No
		return
		Clipboard:=hurl
		TrayTip,AHK Studio,URL Coppied to clipboard,1
	}
	else
	m("Something went wrong.  Here is what the server sent back","","",codes)
}
edit_version_info(){
	upload("Edit Version Info")
}
;http://www.autohotkey.com/community/viewtopic.php?t=63916
DynaRun(TempScript, pipename=""){
	static _:="uint"
	@:=A_PtrSize?"Ptr":_
	If pipename=
	name := "AHK Studio Test"
	Else
	name := pipename
	__PIPE_GA_ := DllCall("CreateNamedPipe","str","\\.\pipe\" name,_,2,_,0,_,255,_,0,_,0,@,0,@,0)
	__PIPE_    := DllCall("CreateNamedPipe","str","\\.\pipe\" name,_,2,_,0,_,255,_,0,_,0,@,0,@,0)
	if (__PIPE_=-1 or __PIPE_GA_=-1)
	Return 0
	Run, %A_AhkPath% "\\.\pipe\%name%",,UseErrorLevel HIDE, PID
	If ErrorLevel
	MsgBox, 262144, ERROR,% "Could not open file:`n" __AHK_EXE_ """\\.\pipe\" name """"
	DllCall("ConnectNamedPipe",@,__PIPE_GA_,@,0)
	DllCall("CloseHandle",@,__PIPE_GA_)
	DllCall("ConnectNamedPipe",@,__PIPE_,@,0)
	script := (A_IsUnicode ? chr(0xfeff) : (chr(239) . chr(187) . chr(191))) . TempScript
	if !DllCall("WriteFile",@,__PIPE_,"str",script,_,(StrLen(script)+1)*(A_IsUnicode ? 2 : 1),_ "*",0,@,0)
	Return A_LastError
	DllCall("CloseHandle",@,__PIPE_)
	Return PID
}
Run_Selected_Text(){
	VarSetCapacity(text,v.sc.2161)
	v.sc.2161(0,&text)
	text:=StrGet(&text,"cp0")
	if text
	dynarun(text)
}
show_file(){
	file:=ssn(current(),"@file")
	f:=file.text
	file:="/select," chr(34) file.text chr(34)
	run explorer.exe %file%
}
Remove_Current_Segment(){
	current:=ssn(current(),"@file")
	main:=ssn(current(1),"@file").text
	ctv:=ssn(current(),"@tv").text
	if (current.text=main)
	return m("You can not remove the main Segment from a program")
	MsgBox,4,Remove Current Segment,Remove the current segment?
	IfMsgBox,No
	return
	cc:=ssn(current(1),"file")
	ctv:=ssn(current(),"@tv").text
	current().ParentNode.RemoveChild(current())
	TV_Delete(ctv)
	tv({sc:v.sc,filename:cc})
	update({up:1})[main]:=1
	MsgBox,260,Remove Current Segment,Delete Segment File?
	IfMsgBox,No
	return
	FileDelete,% current.text
}
export(){
	FileSelectFile,file,S16,,Export File,*.ahk
	if ErrorLevel
	return
	file:=InStr(file,".ahk")?file:file ".ahk"
	if FileExist(file)
	FileDelete,%file%
	FileAppend,% publish(1),%file%
}
Refresh_Code_Explorer(update=""){
	static
	global width
	explore:=[]
	Gui,1:TreeView,SysTreeView322
	GuiControl,-Redraw,SysTreeView322
	TV_Delete()
	loop:=sn(current(1),"*")
	functions:=TV_Add("Functions"),labels:=TV_Add("Labels"),hotkeys:=TV_Add("Hotkeys"),class:=TV_Add("Class")
	codes:=update({get:1})
	while,out:=ssn(loop.item[a_index-1],"@file"){
		code:=codes[out.text]
		for a,b in {hotkeys:"::",labels:":(\s+;.+)?`r",class:"(\s+;.+\s+)?(\s+)?{",functions:"\((.+)?\)(\s+;.+\s+)?(\s+)?{"}{
			pos:=1,find:=a!="class"?"^([\W\s+]?\w+)":"^[\s+]?class\s+(\w+)"
			while,pos:=RegExMatch(code,"OUim)" find b,fun,pos){
				tt:=TV_Add(fun.value(1),%a%,"Sort")
				explore[tt]:={file:out.text,pos:fun.pos(1)-1}
				pos:=fun.pos(1)+1
			}
		}
	}
	GuiControl,+Redraw,SysTreeView322
	Gui,1:TreeView,SysTreeView321
	return
	cej:
	if A_GuiEvent!=Normal
	return
	Gui,1:TreeView,SysTreeView322
	if found:=explore[TV_GetSelection()]{
		TV_GetText(ff,TV_GetSelection())
		tv({filename:ssn(current(1),"//*[@file='" found.file "']")})
		v.sc.2160(found.pos,found.pos+StrLen(ff)),v.sc.2169,v.sc.2400
	}
	return
}
/*
	@flan(){
	}
*/
ideas(){
	mainfile:=ssn(current(1),"@file").text
	v.ideas:=setup(19)
	Gui,+Resize
	Gui,Add,Edit,gideas Multi,% idea.ssn("//*[@file='" mainfile "']").text
	snapshot(v.ideas,19,{Edit1:["w","h"]})
	Gui,Show,% show(19),Ideas
	Gui,1:-Disabled
	settings.add({path:"ideas"}).text:=1
	return
	ideas:
	mainfile:=ssn(current(1),"@file").text
	ControlGetText,text,Edit1,% aid(v.ideas)
	idea.unique({path:"ideas",att:{file:mainfile},check:"file"}).text:=text
	return
	19GuiEscape:
	19GuiClose:
	settings.add({path:"ideas"}).text:=0
	Destroy(19)
	return
}
options(value=""){
	static options:={Virtual_Space:{0:3,3:0,code:2596}
	,Line_Highlight:{0:3,3:0,code:2096},Auto_Indent:{0:1,1:0}
	,Show_End_Of_Line:{0:1,1:0,code:2356},Show_Selected_Duplicates:{0:1,1:0}
	,Word_Wrap:{0:1,1:0,code:2268}}
	sc:=v.sc
	if !IsObject(v.options)
	v.options:=[]
	if (value=1){
		for a,b in options{
			setting:=settings.ssn("//options/" a).text
			if b.code&&setting
			sc[b.code](setting)
			v.options[a]:=setting
		}
	}
	if (value&&value!=1){
		if !set:=settings.ssn("//options/" value)
		set:=settings.add({path:"options/" value})
		set.text:=set.text?set.text:0
		Menu,options,ToggleCheck,% A_ThisMenuItem
		set.text:=options[value,set.text]
		if options[value].code
		sc[options[value].code](set.text)
		v.options[value]:=set.text
	}
	return options
}
widths(){
	static
	cew:
	ControlGetPos,,,w,,SysTreeView322,% aid()
	WinGetPos,,,ww,,% aid()
	setup(18)
	max:=ww-500
	Gui,Add,Text,,Adjust the File Explorer (Left TreeView)
	Gui,Add,Slider,range20-%max% gfewidth vfewidth AltSubmit,%w%
	Gui,Add,Text,,Adjust the Code Explorer (Right TreeView)
	Gui,Add,Slider,range20-%max% gwidth vwidth AltSubmit,%w%
	Gui,Show,,Width
	return
	fewidth:
	Gui,18:Submit,Nohide
	settings.add({path:"file_explorer",text:fewidth})
	arrange(1)
	width:
	Gui,18:Submit,Nohide
	settings.add({path:"code_explorer",text:width})
	arrange(1)
	return
	18GuiClose:
	18GuiEscape:
	Destroy(18)
	return
}
check_id(id){
	http:=ComObjCreate("WinHttp.WinHttpRequest.5.1")
	http.Open("GET","https://api.github.com/gists/" id "/star")
	http.SetRequestHeader("Authorization","Bearer " access_token)
	http.send(),code:=http.ResponseText
	http:=""
	if InStr(code,"not found")
	return
	return id
}
Linked_Scroll_Up(){
	for a,b in v.control
	s.ctrl[b].2168(0,-1)
}
Linked_Scroll_Down(){
	for a,b in v.control
	s.ctrl[b].2168(0,1)
}
GuiDropFiles:
cur:=current(1)
Loop,Parse,A_GuiEvent,`n,`r`n
{
	SplitPath,A_LoopField,filename,dir,ext
	if (ext="ahk"||ext="txt"||ext=""){
		if ssn(cur,"//*[contains(@file,'" filename "')]"){
			InputBox,filename,File Exists!,Segment with the filename "%filename%" already exists.`n`nRename the new segment in the field below or select cancel to not import this file.
			if ErrorLevel||filename=""
			continue
		}
		FileRead,out,%A_LoopField%
		newfile:=dir "\" filename
		if FileExist(newfile)
		FileDelete,%newfile%
		new_segment(newfile,1)
		FileAppend,%out%,%dir%\%filename%
		update({file:newfile,text:out})
		newfile:=1
	}
	else
	m("File formats supported are *.ahk,*.txt, or files without extensions")
	update({up:1})[ssn(cur,"@file").text]:=1
}
return
Auto_Insert(){
	static
	hwnd:=setup(20)
	Gui,Add,ListView,w200 h200 AltSubmit gchange,Entered Key|Added Key
	Gui,Add,Text,,Entered Key:
	Gui,Add,Edit,venter x+10 w50
	Gui,Add,Text,xm,Added Key:
	Gui,Add,Edit,vadd x+10 w50
	Gui,Add,Button,xm gaddkey Default,Add Keys
	Gui,Add,Button,x+10 gremkey,Remove Selected
	autoadd:=settings.sn("//autoadd/*")
	while,aa:=autoadd.item(a_index-1)
	ea:=xml.easyatt(aa),LV_Add("",Chr(ea.trigger),Chr(ea.add))
	Gui,Show,,Auto Insert
	return
	change:
	if A_GuiEvent not in Normal,i
	return
	if !LV_GetNext()
	return
	LV_GetText(in,LV_GetNext()),LV_GetText(out,LV_GetNext(),2)
	ControlSetText,Edit1,%in%,% aid(hwnd)
	ControlSetText,Edit2,%out%,% aid(hwnd)
	return
	20GuiEscape:
	20GuiClose:
	destroy(20)
	return
	addkey:
	Gui,Submit,Nohide
	if !(enter&&add)
	return m("Both values need to be filled in")
	if StrLen(enter)!=1||StrLen(add)!=1
	return m("Both values must be a single character")
	dup:=1
	if settings.ssn("//autoadd/key[@trigger='" Asc(enter) "']")
	LV_Delete(LV_GetNext()),dup:=0
	settings.add({path:"autoadd/key",att:{trigger:Asc(enter),add:Asc(add)},dup:dup})
	LV_Add("",enter,add)
	hotkeys()
	return
	remkey:
	while,LV_GetNext(){
		LV_GetText(trigger,LV_GetNext())
		Hotkey,IfWinActive,% aid()
		Hotkey,%trigger%,Off
		rem:=settings.ssn("//autoadd/key[@trigger='" Asc(trigger) "']")
		rem.ParentNode.RemoveChild(rem)
		LV_Delete(LV_GetNext())
	}
	return
}
clipboard_viewer(refresh=""){
	static cb
	if refresh{
		Gui,21:Default
		LV_Delete()
		loop,% v.clipboard.maxindex()
		LV_Add("",A_Index)
		sel:=refresh=2?1:v.clipboard.maxindex()
		LV_Modify(sel,"Select Focus Vis")
		return
	}
	cb:=setup(21)
	Gui,+Resize
	Gui,Add,ListView,w50 h400 AltSubmit gshowclip,Clip
	Gui,Add,Edit,w500 h400 x+10
	Gui,Add,Button,xm gcvcopy Default,Copy Current to Clipboard
	Gui,Add,Button,x+10 gcvremove,Remove Current
	for a in v.clipboard
	LV_Add("",A_Index)
	Gui,Show,% show(21),Clipboard Viewer
	select:=last?LV_GetCount():1
	LV_Modify(select,"Select Vis Focus")
	return
	21GuiEscape:
	21GuiClose:
	destroy(21)
	return
	showclip:
	if A_GuiEvent not in Normal,i
	return
	ControlSetText,Edit1,% v.clipboard[LV_GetNext()],% aid(cb)
	return
	cvcopy:
	Clipboard:=v.clipboard[LV_GetNext()]
	Destroy(21)
	return
	cvremove:
	v.Clipboard.remove(LV_GetNext())
	clipboard_viewer(2)
	return
}