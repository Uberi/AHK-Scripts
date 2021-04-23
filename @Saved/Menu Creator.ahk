#SingleInstance,Force
DetectHiddenWindows,On
set:=[[["Display Menu","^m"],["Copy menu to Clipboard","^c"],["New Menu","^n"],["Load Menu","^l"],["Save Menu","^s"],["Save As","^a"]]
,[["Add Separator","^e"],["New Top Level","^t"],["New Under Selected","^u"]]
,[["Edit Menu Color","F2"],["Remove Menu Color","F4"]]
,[["Add Custom Label","!a"],["Remove Menu Item","Delete"],["Move Selected Item Up","^Up"],["Move Selected Item Down","^Down"],["Move Selected Item To Parent","^Left"],["Move Selected Item Under Sibling","^Right"]]
,[["Help","^h"],["Settings","F1"],["Version","^v"],["Debug Window","F3"]]]
x:=new xml("top"),settings:=new xml("settings"),v:=[]
global x,settings,v,set
Gui,+hwndmain +Resize -0x30000
v.main:=main
Gui,Add,TreeView,w500 h300 gdrag
Gui,Add,Tab,w500 h200 Buttons,File|Add|Color|Edit|Settings
for a,b in Set{
	Gui,Tab,%A_Index%
	for c,d in b
	Gui,Add,Button,% "gg v" clean(d.1) " " pos,% d.1
}
SysGet,caption,4
SysGet,Border,33
WinGet,list,ControlList,% aid(v.main)
Gui,1:Show,AutoSize,Menu Editor
VarSetCapacity(size,16,0),DllCall("user32\GetClientRect","uint",v.main,"uint",&size),w:=NumGet(size,8),h:=NumGet(size,12)
v.border:=border,v.caption:=caption
Loop,Parse,list,`n
{
	ControlGetPos,x,y,ww,wh,%A_LoopField%,% aid(v.main)
	v.controls[A_LoopField]:={x:x,y:h-y,w:w-ww,h:h-wh}
}
v.debug:=debug,help(),hotkeys()
file:=settings.ssn("//last/@file").text?settings.ssn("//last/@file").text:"saved.xml"
IfExist,%file%
load_menu(file)
a:=settings.ssn("//position").text?settings.ssn("//position").text:""
Gui,Show,%a%,Menu Creator
Gui,2:+hwnddebug
Gui,2:Add,Edit,w500 h500 -Wrap
Gui,2:Show,x0 y0 NA Hide,Debug
return
clean(x){
	return RegExReplace(RegExReplace(x,"&")," ","_")
}
clear_here(){
	TV_Modify(x.ssn("//@here/../@tv").text,"Select Focus Vis")
	rem:=x.sn("//@here")
	while,del:=ssn(rem.item(A_Index-1),"..")
	del.removeattribute("here")
}
copy_menu_to_clipboard(){
	Clipboard:=RegExReplace(display_menu(1),"\n","`r`n") "total:`r`nreturn"
	MsgBox,1,Menu Creator,Menu saved to Clipboard,.5
}
display_menu(return=""){
	count=1,current:=current().SetAttribute("here",1)
	check:=x.sn("//*[@name='--Separator--']")
	while,chk:=check.item(A_Index-1)
	if chk.firstchild
	return m("Separators can not be the top of a menu structure.  Please fix this and try again")
	load_menu(x),x.Transform(),clear_here()
	GuiControl,2:,Edit1,% x[]
	mm:=[]
	c:=x.sn("//*[@menu!='Main']")
	while,item:=c.item(A_Index-1),custom:=ssn(item,"@custom").text?ssn(item,"@custom").text:"total"
	list.="Menu," ssn(item.parentnode,"@under").text ",Add," ssn(item,"@name").text "," custom "`n"
	c:=x.sn("//*[@menu='Main']")
	while,item:=c.item(A_Index-1){
		if item.firstchild
		list.="Menu,Main,Add," ssn(item,"@name").text ",:" ssn(item,"@under").text "`n"
		else
		list.="Menu,Main,Add," ssn(item,"@name").text ",total`n",mm.Insert(tm)
	}
	c:=x.sn("//*[@under]")
	while,item:=c.item(A_Index-1)
	list.="Menu," ssn(item,"@menu").text ",Add," ssn(item,"@name").text ",:" ssn(item,"@under").text "`n"
	c:=x.sn("//*[@color]")
	while,item:=c.item(A_Index-1)
	list.="Menu," ssn(item.firstchild,"@menu").text ",Color," ssn(item,"@color").text ",Single`n"
	list:=RegExReplace(list,"iU),--Separator--.*\n","`n")
	c:=x.sn("//*[@custom]"),l:=[]
	while,item:=c.item(A_Index-1)
	l[ssn(item,"@custom").text]:=1
	for a,b in l
	if a
	menus.=a ":`nreturn`n"
	for a,b in {" ,":settings.ssn("//spaces/before").Text,", ":settings.ssn("//spaces/after").Text}
	if b
	list:=RegExReplace(list,",",a)
	if return
	return list "Menu,Main,Show`nreturn`n" menus
	sep:=[],list:=Trim(list,"`n")
	Loop,Parse,list,`n
	{
		info:=RegExReplace(A_LoopField," ")
		StringSplit,f,info,`,
		Menu,%f2%,%f3%,%f4%,% InStr(f5,":")?f5:"total"
		sep[f2]:=1
		f4:=f5:=""
	}
	Menu,main,Show
	for a,b in sep
	Menu,% Trim(a),Delete
	return
	total:
	m(A_ThisMenuItem)
	return
}
GuiContextMenu:
MouseGetPos,,,,con
MouseClick,Left
if con!=SysTreeView321
return
Menu,rcm,Add,New Top Level,rcm
Menu,rcm,Add,New Under Selected,rcm
Menu,rcm,Add,Edit Menu Color,rcm
Menu,rcm,Add,Remove Menu Color,rcm
Menu,rcm,Show
return
rcm:
f:=clean(A_ThisMenuItem)
%f%()
return
return
edit_menu_color(){
	current:=current()
	v.current:=current
	color:=ssn(current.parentnode,"@color").text
	color:=color?color:0
	Gui,6:Destroy
	Gui,6:+ToolWindow +Owner1
	Gui,6:Add,Text,,Selected menus color
	Gui,6:Add,Progress,w50 h20 c%color% x+10,100
	Gui,6:Add,Button,gmc x+10,Change Color
	color=0
	if current.firstchild{
		color:=ssn(current,"@color").text
		color:=color?color:0
		Gui,6:Add,Text,xm,Submenus color
		Gui,6:Add,Progress,w50 h20 c%color% x+10,100
		Gui,6:Add,Button,gmc x+10,Change Submenu Color
	}
	Gui,6:Show,,Edit Colors
}
mc:
if (A_GuiControl="Change Color"){
	color:=dlg_color(RGB(ssn(v.current.parentnode,"@color").text))
	v.current.parentnode.SetAttribute("color",RGB(color))
	GuiControl,% "6:+c" RGB(color),msctls_progress321
}
if (A_GuiControl="Change Submenu Color"){
	color:=dlg_color(RGB(ssn(v.current,"@color").text))
	v.current.SetAttribute("color",RGB(color))
	GuiControl,% "6:+c" RGB(color),msctls_progress322
}
return
6GuiEscape:
Gui,6:Destroy
return
debug_window(){
	WinGet,style,style,Debug
	if style=0x84CA0000
	Gui,2:show,NA
	else
	WinHide,% aid(v.debug)
}
drag:
if A_GuiEvent!=D
return
move:=x.ssn("//*[@tv='" A_EventInfo "']")
while,GetKeyState("LButton","P"){
}
MouseClick,Left
TV_GetSelection()=0?under:=x.ssn("//top"):under:=current()
if ssn(under,"@name").text="--separator--"
{
	m("Separators can not be top menus")
	return
}
if move.xml=under.xml
return
under.appendchild(move),move.SetAttribute("here",1)
GuiControl,-Redraw,SysTreeView321
x.Transform(),load_menu(x),clear_here()
GuiControl,+Redraw,SysTreeView321
return
3GuiEscape:
3GuiClose:
hotkeys(),t()
4GuiEscape:
4GuiClose:
Gui,%A_Gui%:Destroy
return
GuiEscape:
VarSetCapacity(size,16,0),DllCall("user32\GetClientRect","uint",v.main,"uint",&size),w:=NumGet(size,8),h:=NumGet(size,12)
WinGetPos,x,y,,,% aid(v.main)
settings.add("position","","x" x " y" y " w" w " h" h)
save_menu()
settings.save()
ExitApp
return
g:
%A_GuiControl%()
return
hotkeys(){
	Hotkey,IfWinActive,% aid(v.main)
	for a,b in Set
	for c,d in b{
		k:=settings.ssn("//hotkeys/" clean(d.1)).text
		key:=k?k:settings.add("hotkeys/" clean(d.1),"",d.2)
		Hotkey,%key%,hotkey,On
	}
	return
	hotkey:
	key:=settings.ssn("//*[text()='" A_ThisHotkey "']").nodename
	%key%()
	return
}
load_menu(filename=""){
	GuiControl,-Redraw,SysTreeView321
	if !IsObject(filename){
		if !filename
		FileSelectFile,filename,,,Save Menu As,*.xml
		if ErrorLevel
		return
		if new xml("temp","",filename).ssn("//*").nodename!="top"
		return m("Incorrect file type.")
		filename!="temp.xml"?settings.add("last",{file:filename}):""
		x:=new xml("top","",filename),x.sn("//*").length<2?x:=new xml("top"):""
	}
	c:=x.sn("//*"),TV_Delete(),count:=1
	while,i:=c.item(A_Index-1)
	i.removeattribute("tv"),i.removeattribute("parent"),i.removeattribute("menu"),i.removeattribute("top"),i.removeattribute("under")
	while,i:=c.item(A_Index-1){
		if A_Index=1
		continue
		if i.firstchild()
		i.SetAttribute("under","menu" count),count++
		if tv:=ssn(i.parentnode,"@tv").text
		i.SetAttribute("parent",tv)
		tv:=tv?tv:""
		new:=TV_Add(ssn(i,"@name").text,tv)
		i.SetAttribute("tv",new)
		if num:=ssn(i.parentnode,"@under").text
		i.SetAttribute("menu",num)
		if i.parentnode.nodename="top"
		i.SetAttribute("menu","Main")
	}
	Loop,% TV_GetCount()
	TV_Modify(next:=TV_GetNext(next,"F"),"Expand")
	x.Transform(),TV_Modify(TV_GetChild(0),"Focus Vis Select")
	GuiControl,2:,Edit1,% x[]
	GuiControl,+Redraw,SysTreeView321
}
Move_Selected_Item_To_Parent(){
	GuiControl,-Redraw,SysTreeView321
	current:=current()
	if current.parentnode.nodename!="top"{
		current.SetAttribute("here",1)
		under:=current.parentnode
		under.parentnode.insertbefore(current,current.parentnode)
		load_menu(x),clear_here()
	}
	GuiControl,+Redraw,SysTreeView321
}
Move_Selected_Item_Under_Sibling(){
	GuiControl,-Redraw,SysTreeView321
	current:=current()
	if sibling:=current.nextsibling{
		sibling.firstchild?sibling.insertbefore(current,sibling.firstchild):sibling.appendchild(current)
		current.SetAttribute("here",1),load_menu(x),clear_here()
	}
	GuiControl,+Redraw,SysTreeView321
}
Move_Selected_Item_Up(){
	GuiControl,-Redraw,SysTreeView321
	current:=current()
	if b4:=current.previousSibling{
		current.SetAttribute("here",1)
		new:=b4.parentnode.insertBefore(current,b4)
		load_menu(x)
		clear_here()
	}
	GuiControl,+Redraw,SysTreeView321
}
Move_Selected_Item_Down(){
	GuiControl,-Redraw,SysTreeView321
	current:=current()
	if b4:=current.nextSibling{
		current.SetAttribute("here",1)
		new:=b4.parentnode.insertBefore(b4,current)
		load_menu(x)
		clear_here()
	}
	GuiControl,+Redraw,SysTreeView321
}
help(){
	if remove:=settings.ssn("//Compile_Menu")
	remove.parentnode.removechild(remove)
	list=Hotkeys:`n`n
	for a,b in Set
	for c,d in b{
		if !key:=settings.ssn("//hotkeys/" clean(d.1)).text
		key:=d.2,settings.add("hotkeys/" clean(d.1),"",d.2)
		list.=d.1 " = " change(key) "`n"
		if a=new top level
		ntl:=key
		if a=new under selected
		un:=key
	}
	message:=list "`nAdd new menu items with the New Top Level button or " change(ntl) "`nAdd submenus with the New Under Selected button or " change(un) "`nDrag and drop items from one place to another`n`nShow again at startup?"
	if !settings.ssn("//help").text||A_ThisLabel{
		if !settings.ssn("//help")
		MsgBox,4,Menu Creator Help,%message%
		else
		MsgBox,260,Menu Creator Help,%message%
		IfMsgBox,No
		settings.add("help","",1)
		IfMsgBox,Yes
		settings.add("help","",0)
	}
}
change(key){
	for a,b in {Control:"\^",Alt:"\!"}
	key:=RegExReplace(key,b,a "+")
	return key
}
new_menu(){
	x:=new xml("top"),TV_Delete()
	x.Transform(),settings.ssn("//last").removeattribute("file")
	GuiControl,2:,Edit1,% x[]
}
remove_menu_item(){
	GuiControl,-Redraw,SysTreeView321
	remove:=current()
	next:=remove.previousSibling?remove.previousSibling:remove.nextSibling
	remove.parentnode.removechild(remove),next.SetAttribute("here",1)
	load_menu(x),clear_here()
	GuiControl,+Redraw,SysTreeView321
}
save_menu(filename=""){
	filename:=filename?filename:settings.ssn("//last/@file").text
	if !filename
	FileSelectFile,filename,S16,,Save Menu As,*.xml
	if ErrorLevel
	return
	filename:=InStr(filename,".xml")?filename:filename ".xml"
	settings.add("last",{file:filename})
	x.transform(),x.xml.save(filename)
	MsgBox,0,File Saved,File Saved,1
}
save_as(){
	FileSelectFile,filename,S16,,Save Menu As,*.xml
	if ErrorLevel
	return
	save_menu(filename)
}

Add_Separator(){
	menu=--Separator--
	new:=TV_Add(menu),TV_Modify(new,"Select Vis Focus")
	x.Add("menu",{name:menu,tv:new,top:1},"",1),x.Transform()
	GuiControl,2:,Edit1,% x[]
}
settings(){
	static
	Gui,3:Destroy
	Gui,3:+ToolWindow +hwndsetting
	Gui,3:Add,ListView,w350 h400 AltSubmit gselhk,Key Action|Key
	Gui,3:Add,Hotkey,gchangekey vchk limit3
	Gui,3:Add,Button,x+10 gdelete Disabled,Delete
	Gui,3:Add,Button,x+10 gdelete Disabled,BackSpace
	for a,b in {before:settings.ssn("//spaces/before").Text,after:settings.ssn("//spaces/after").Text}
	Gui,3:Add,Checkbox,% "gcomma xm " check:=b?"Checked":"",Add spaces %a% commas
	Gui,3:Default
	v.setting:=setting
	for a,b in Set
	for c,d in b{
		if !key:=settings.ssn("//hotkeys/" clean(d.1)).text
		key:=d.1,settings.add("hotkeys/" clean(d.1),"",d.2)
		LV_Add("",d.1,change(key))
	}
	Loop,2
	LV_ModifyCol(A_Index,"AutoHDR")
	Gui,3:Show,,Settings
	return
	changekey:
	if !LV_GetNext()
	return
	Gui,3:Submit,Nohide
	LV_Modify(LV_GetNext(),"Col2",change(chk)),t(),LV_GetText(setting,LV_GetNext()),settings.add("hotkeys/" clean(setting),"",chk)
	return
	selhk:
	if (LV_GetNext()=0||A_GuiEvent!="Normal")
	return
	t("Press a key to change it")
	Loop,2
	GuiControl,3:Enable,Button%A_Index%
	ControlFocus,msctls_hotkey321,Settings
	return
	delete:
	if next:=LV_GetNext()
	LV_GetText(setting,Next),LV_Modify(next,"Col2",A_GuiControl),settings.add("hotkeys/" clean(setting),"",A_GuiControl)
	return
	comma:
	ControlGet,check,Checked,,%A_GuiControl%,% aid(v.setting)
	option:=InStr(A_GuiControl,"after")?"after":"before"
	settings.add("spaces/" option,"",check)
	return
}
new_top_level(){
	InputBox,menu,Add Top Level Menu Item,Name?
	if !Menu
	return
	list:=x.sn("//top/*")
	while,a:=list.item(A_Index-1)
	if ssn(a,"@name").text=menu
	return m("Duplicate Menus not allowed")
	new:=TV_Add(menu),TV_Modify(new,"Select Vis Focus")
	x.Add("menu",{name:menu,tv:new,top:1},"",1),x.Transform()
	GuiControl,2:,Edit1,% x[]
}
new_under_selected(){
	if !TV_GetSelection()
	return m("Create a top level item first")
	InputBox,menu,Add Under Current,Name?
	if !Menu
	return
	top:=x.sn("//*[@tv='" TV_GetSelection() "']/*")
	while,a:=top.item(A_Index-1)
	if ssn(a,"@name").text=menu
	return m("Duplicate Menu items not alowed in the same menu")
	new:=TV_Add(menu,TV_GetSelection()),TV_Modify(TV_GetSelection(),"Expand")
	x.Add("menu",{name:menu,tv:new,parent:TV_GetSelection()},"","","",current())
	x.Transform()
	GuiControl,2:,Edit1,% x[]
}
version(){
	Version=0.001.19
	URLDownloadToFile,http://www.autohotkey.net/~maestrith/menucreator/Menu Creator.text,version.txt
	FileRead,ver,version.txt
	Gui,4:+ToolWindow
	Gui,4:Add,Edit,w400 h300,%ver%
	Gui,4:Add,Button,gau,Auto Update
	Gui,4:Show,,Current Version: %version%
	Send,^{Home}
	return
	au:
	save_menu()
	ext:=A_IsCompiled?".exe":".ahk"
	FileMove,%A_ScriptFullPath%,% "Backup_" A_Now ext
	URLDownloadToFile,http://www.autohotkey.net/~maestrith/menucreator/Menu Creator%ext%,Menu Creator%ext%
	run,Menu Creator%ext%
	ExitApp
	return
}
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
	__Get(){
		return this.xml.xml
	}
	CreateElement(doc,root){
		xm:=doc.CreateElement(root),doc.AppendChild(xm)
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
		list:=[]
		while,n:=node.attributes.item(A_Index-1)
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
Dlg_Color(Color){
	VarSetCapacity(CUSTOM,64,0),VarSetCapacity(CHOOSECOLOR,0x24,0)
	,NumPut(0x24,CHOOSECOLOR,0),NumPut(WinActive(),CHOOSECOLOR,4)
	,NumPut(color,CHOOSECOLOR,12),NumPut(&CUSTOM,CHOOSECOLOR,16)
	,NumPut(0x00000103,CHOOSECOLOR,20)
	nRC:=DllCall("comdlg32\ChooseColorA", str,CHOOSECOLOR)
	setformat,integer,H
	clr := NumGet(CHOOSECOLOR,12)
	setformat,integer,D
	return %clr%
}
rgb(c){
	setformat,IntegerFast,H
	c:=(c&255)<<16|(c&65280)|(c>>16),c:=SubStr(c,1)
	SetFormat, integerfast,D
	return c
}

remove_menu_color(){
	current:=current().parentnode.removeattribute("color")
}
add_custom_label(){
	current:=current()
	InputBox,custom,This will launch a custom label when this menu item is selected.,Leave this value blank or hit cancel to remove the custom label,,650,,,,,,% ssn(current,"@custom").text
	if (custom=""||ErrorLevel!=0)
	return current.removeattribute("custom")
	current.SetAttribute("custom",clean(custom))
}

aid(hwnd){
	return "ahk_id" hwnd
}
current(){
	return x.ssn("//*[@tv='" TV_GetSelection() "']")
}
GuiSize:
For a,b in v.controls
if !InStr(a,"TreeView")
GuiControl,1:movedraw,%a%,% "y" a_guiheight-(b.y+v.border+v.caption)
else
GuiControl,1:movedraw,%a%,% "w" A_GuiWidth-(b.w) " h" A_GuiHeight-(b.h)
return