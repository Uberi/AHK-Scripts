#singleinstance,force
detecthiddenwindows,on
filename:=gv(0,"file","lastopen")
fileinstall,commands.xml,commands.xml,1
fileinstall,scilexer.dll,scilexer.dll,1
detecthiddenwindows,on
coordmode,mouse,relative
ifexist scilexer.dll
{
 FileGetVersion, Out,scilexer.Dll
 if out!=3.0.2.0
 {
  MsgBox,Your current SciLexer.dll file is version %out% and is out of date.  The program will now download the newest version.  Thank you.
  FileDelete,scilexer.dll
 }
}
ifnotexist scilexer.dll
{
 splashtexton,300,50,Downloading support files,Please wait
 urldownloadtofile,http://www.maestrith.com/files/SciLexer.dll,scilexer.dll
}
ifnotexist commands.xml
urldownloadtofile,http://www.maestrith.com/files/commands.xml,commands.xml
splashtextoff
main:=[]
main[1]:={name:"Script Writer",position:"Hide w800 h600",number:1}
main[2]:={1:"Tab,-Tabstop vtab -Wrap gprograms x0 y0 h10,Tabs|1",2:"StatusBar,,testing"}
hgui:=window(main),var("main","ahk_id " hgui)
setcolors()
window:=[]
window[1]:={name:"File Explorer",position:" hide w300 h300",number:2}
window[2]:={1:"TreeView,x0 y0 gjtv 0x8000 AltSubmit w400 h400"}
window(window)
Gui,2:Default
autoopen()
lastopen:=gv(0,"segment","lastopen")
if !var("files").selectsinglenode("//*[@file='" lastopen "']").xml
lastopen:=gv(0,"file","lastopen")
gui,1:show
gui,2:show
lastopen:=lastopen?lastopen:"Untitled.ahk"
select(lastopen)
setpos()
hotkeys(1)
hotkey,ifwinactive,ahk_id %hgui%
hotkey,!j,jump,on
sc(2077,,"#abcdefghijklmnopqrstuvwxyz_ABCDEFGHIJKLMNOPQRSTUVWZYZ"),sc(2115,1)
code_explorer()
winactivate,% var("script writer")
return
exit(){
 GuiClose:
 savepos()
 save()
 ExitApp
 return
}
/*
ControlGet,out,list,,,% var("main") ;Use this to get a list in a listbox    % var("main") is the hgui or gui handle ;)
*/
run(){
 save()
 root:=var("files").selectsinglenode("//*[@window='" sc(2357) "']..")
 main:=root.selectsinglenode("@main").text
 run,%main%
}
guisize:
VarSetCapacity(Rect,16,0)
SendMessage,0x130a,0,&Rect,SysTabControl321,% var("main") ;thank you Rseding91
h:=NumGet(Rect,12,"Int")
ControlMove,SysTabControl321,,,%A_GuiWidth%,%h%
ControlGetPos,,sby,,sbh,msctls_statusbar321,% var("main")
ControlGetPos,,taby,,tabh,SysTabControl321,% var("main")
ControlGetPos,x,y,w,h,Scintilla1,% var("main")
ControlMove,Scintilla1,,% taby+tabh+1,% A_GuiWidth,% sby-(taby+tabh)
size()
return
open_folder(){
 root:=var("files").selectsinglenode("//*[@window='" sc(2357) "']..")
 main:=root.selectsinglenode("@main").text
 SplitPath,main,,dir
 run,%dir%
}
return
open(){
 save()
 fileselectfile,filename,M
 if errorlevel
 return
 if InStr(filename,"`n"){
  loop,Parse,filename,`n,`r`n
  if A_Index=1
  dir:=A_LoopField
  else
  files.=dir "\" A_LoopField "|"
 }
 else
 files:=filename
 list:=trim(option().selectsinglenode("//lastopen/file").text,"|")  "|" trim(files,"|")
 option(o:={1:"lastopen",2:"file"},f:={file:"file"},trim(list,"|"))
 soxml()
 autoopen(trim(files,"|"))
 return
}
size(){
 WinGetTitle,win,% "ahk_id " WinExist()
 option(o:={1:"position",2:"position"},i:={position:win},"w" a_guiwidth " h" a_guiheight)
}
jumptreeview(){
 jtv:
 if a_guievent!=Normal
 return
 gui,2:default
 select(var("files").selectsinglenode("//*[@*='" tv_getselection() "']").selectsinglenode("@file").text)
 return
}
fe(){
 2GuiSize:
 ControlMove,SysTreeView321,,,A_GuiWidth,A_GuiHeight
 size()
 return
}
f1::
msgbox % var("keywords")
return
xmldoc:=var("files")
xsl:=style()
xmldoc.transformNodeToObject(xsl,xmldoc)	;Apply the Style Sheet

msgbox % xmldoc.xml
return
Scintilla_Add(ParentWindowID, X, Y, W, H){
 Static ScintillaIndex := 0
 if !DllCall("GetModuleHandle","str","SciLexer.dll")
 DllCall("LoadLibrary","str","SciLexer.dll")
 return DllCall("CreateWindowEx" ,"int",0x200 ,"str","Scintilla"
 ,"str","Scintilla" . ++ScintillaIndex ,"int", 0x52310000
 ,"int",X ,"int",Y ,"int",W ,"int",H ,"uint",ParentWindowID
 ,"uint",0 ,"uint",0 ,"uint",0)
}
/*
string(x,y){
 loop,parse,y,| 
 {
  StringSplit,a,A_LoopField,`,
  sc(a1,a2,a3,a4)
 }
}
*/
GetText(x=""){
 s:=var("s")
 length:=DllCall(s.fn,"Ptr",s.ptr,"UInt",2182,"Int",0,"Int",0,"Cdecl")
 VarSetCapacity(te,length)
 DllCall(s.fn,"Ptr",s.ptr,"UInt",2182,"Int",length,"Int",&te,"Cdecl")
 return strget(&te,out,utf-16)
}
/*
gettext(){
 VarSetCapacity(text,sc(2182)),sc(2182,sc(2182),&text)
 return strget(&text,length,utf-16)
}
*/
sc(x,y=0,z=0){
 s:=var("s"),f:=var("f")
 wp:=(z+1)!=""?"Int":"AStr"
 lp:=(y+1)!=""?"Int":"AStr"
 for a,b in z
 wp:=a,z:=b
 main:=DllCall(s.fn,"Ptr",s.ptr,"UInt",x,lp,y,wp,z,"Cdecl")
 IfWinactive,Edit Colors
 {
  color:=DllCall(f.fn,"Ptr",f.ptr,"UInt",x,lp,y,wp,z,"Cdecl") 
  main:=main!=""?main:color
  return color
 }
 return main
}
var(x,y=""){
 static variables:=[]
 if (y="")
 return variables[x]
 variables[x]:=y
}
tabselection(tab=""){
 programs:
 if !tab
 ControlGet,Tab,Tab,,SysTabControl321,% var("script writer")
 main:=var("files").selectsinglenode("//Main[@tab='" tab "']").selectsinglenode("@main").text
 last:=option().selectsinglenode("//cursor_position[@main='" main "']").selectsinglenode("lastopen").text
 main:=last?last:main
 ;xml:=option(),root:=xml.selectsinglenode("//cursor_position[@main='" main "']").xml ; .selectsinglenode("lastopen").xml
 select(main)
 return
}
Scintilla_code_lookup(x=0){
 static
 if !IsObject(xmldoc){
  IfNotExist,scintilla.xml
  {
   SplashTextOn,300,100,Downloading definitions,Please wait
   URLDownloadToFile,http://www.autohotkey.net/~maestrith/scintilla.xml,scintilla.xml
   SplashTextOff
  }
  xmlDoc:=ComObjCreate("MSXML2.DOMDocument")
  xmldoc.setProperty("SelectionLanguage","XPath")
  xmldoc.load("scintilla.xml")
 }
 if x
 return xmldoc
 VarSetCapacity(text,sc(2161)),sc(2161,,&text),text:=trim(strget(&text,cp0))
 list=
 if text is number
 {
  node:=xmldoc.selectnodes("//scintilla/*[@code='" text "']")
  while,out:=node.item[A_Index-1].nodename
  list.=out "`n"
  msgbox % list
  return
 }
 window:=[]
 window[1]:={name:"Scintilla Code Search",position:"hide w900 h850",number:88}
 window[2]:={1:"edit,x0 w500 gcodesearch",2:"listview,w900 h800,Function|Code|Syntax",3:"button,gcodeins default,Insert"}
 window(window)
 gui,88:default
 node:=xmldoc.selectnodes("//scintilla/*[@code]")
 while,out:=node.item[A_Index-1].nodename,text:=node.item[A_Index-1].selectsinglenode("@code").text,syntax:=node.item[A_Index-1].selectsinglenode("@syntax").text
 lv_add("",out,text,syntax)
 lv_modifycol()
 gui,88:show
 return
 88guiescape:
 gui,88:hide
 savepos()
 return
 codesearch:
 controlgettext,search,Edit1
 GuiControl,-Redraw,SysListView321
 lv_delete()
 stringupper,search,search
 xmldoc:=Scintilla_code_lookup(1)
 codes:=xmldoc.selectnodes("//scintilla/*[contains(@name,'" search "')]")
 while,out:=codes.item[a_index-1].nodename
 lv_add("",out,codes.item[a_index-1].selectsinglenode("@code").text,codes.item[a_index-1].selectsinglenode("@syntax").text)
 GuiControl,+Redraw,SysListView321
 lv_modify(1,"Select Focus")
 return
 codeins:
 lv_gettext(code,lv_getnext(),2)
 sc(2003,sc(2008),{astr:code})
 send,{left,StrLen(code)}
 return
}
;f1::
xml:=Scintilla_code_lookup(1)
;fileread,syntax,doc\scintilla3.ahk
find:=xml.selectnodes("//scintilla/*")
while,node:=find.item[a_index-1].nodename,search:=find.item[a_index-1].selectsinglenode("@code").text
{
 ;regexmatch(syntax,"m)" search ",(.*)ahk_id",found)
 ;sx:=regexreplace(found1,",,")
 ;if (sx!=", "){
 add:=find.item[a_index-1]
 add.setattribute("name",node)
 ;}
}
msgbox % xml.xml
xml.save("syntax.xml")
;reload
return
option(struct="",attributes="",text="",new=""){
 static xmldoc
 main=Options
 if !IsObject(xmldoc){
  xmlDoc:=ComObjCreate("MSXML2.DOMDocument")
  xmlDoc.setProperty("SelectionLanguage","XPath")
  xmldoc.load("options.xml")
  if !root:=xmldoc.selectsinglenode(main){
   root:=xmldoc.createElement(main)
   xmldoc.appendchild(root)
  }
 }
 root:=xmldoc.selectsinglenode(main)
 if struct.remove
 {
  remove:=xmldoc.selectsinglenode(struct.remove)
  if remove.xml
  return xmldoc.documentelement.removechild(remove)
 }
 if !struct && !attributes && !text
 return xmldoc
 for a,b in attributes
 {
  if a_index=1
  if xmldoc.selectsinglenode("//" struct[struct.minindex()] "/*[@" a "='" b "']").xml
  {
   xml1:=xmldoc.selectsinglenode("//" struct[struct.minindex()] "/*[@" a "='" b "']")
   add=1
   exist=1
  }
  else
  new=1
  break
 }
 if (exist="" || new){
  for a,b in struct
  {
   path.="/" b
   if struct.maxindex()=A_Index && new
   xml%A_Index%:=xmldoc.createElement(b)
   else
   if !xml%A_Index%:=xmldoc.selectsinglenode("//" main path){
    xml%A_Index%:=xmldoc.createElement(b)
   }
   max:=A_Index-1,add:=A_Index
  }
  loop,%max%
  current:=A_Index+1,xml%A_Index%.appendchild(xml%current%)
  root.appendchild(xml1)
 }
 for a,b in attributes
 xml%add%.setattribute(a,b)
 if text!=""
 xml%add%.text:=text
 return 
}
soxml(){
 xmldoc:=option()
 xsl:=style()
 xmldoc.transformNodeToObject(xsl,xmldoc)	;Apply the Style Sheet
 xmldoc.save("options.xml")
}
style(){
 xsl := ComObjCreate("MSXML2.DOMDocument")
 style =
 (
 <xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
 <xsl:output method="xml" indent="yes" encoding="UTF-8"/>
 <xsl:template match="@*|node()">
 <xsl:copy>
 <xsl:apply-templates select="@*|node()"/>
 </xsl:copy>
 </xsl:template>
 </xsl:stylesheet>
 )
 xsl.loadXML(style), style:=null
 return xsl
}
gv(r="¿",search="¿",node="¿",attribute=""){
 static ls,lr,ln
 att:=attribute?attribute:"*"
 search:=search="¿"?ls:search,r:=r="¿"?lr:r,node:=node="¿"?ln:node
 x:=option()
 if !tv:=x.selectsinglenode("//" node "/*[@" att "='" search "']")
 ;if !tv:=x.selectsinglenode("//" node "/" search)
 tv:=x.selectsinglenode("//" node "/*[text()='" search "']")
 ls:=search,lr:=r,ln:=node
 if r=0
 return tv.text
 return tv.selectsinglenode("@" r).text
}
Full_Backup(){
 save()
 SplashTextOn,300,100,Backing up...,Please wait, This may take some time if it has been a while since your last full backup.
 root:=var("files").selectsinglenode("//*[@window='" sc(2357) "']..")
 main:=root.selectsinglenode("@main").text
 SplitPath,main,,dir
 backup:=dir "\backup\Full Backup" A_Now
 FileCreateDir,%backup%
 loop,%dir%\*.*
 {
  if InStr(a_loopfilename,".exe") || InStr(A_LoopFileName,".dll")
  continue
  filecopy,%A_LoopFileFullPath%,%backup%\%A_LoopFileName%
 }
 loop,%dir%\backup\*.*,2
 if a_loopfilename not contains full backup
 fileremovedir,%a_loopfilefullpath%,1
 SplashTextOff
}
OnWmNotify(wParam, lParam, msg, hwnd){
 critical
 static lastlist
 static lsub
 colors:=var("f")
 control:=numget(lparam+0)
 sc:=var(1)
 if !(control=sc||control=colors.colors)
 return
 code:=NumGet(lParam+8),cpos:=sc(2008)
 if code=2008
 update()
 if code=2001
 {
  start:=sc(2266,sc(2008),1),end:=sc(2267,sc(2008),1),out:=gettext(var(1)),word:=substr(out,start+1,length:=abs(end-start))
  keywords:=var("keywords")
  if (strlen(word)>1) ;&& sc(2102)=0)
  {
   loop,parse,keywords,%a_space%,%A_Space%
   if RegExMatch(A_LoopField,"Ai)" word)
   list.=a_loopfield " "
   if (list!=lastlist && list!="")
   sc(2100,strlen(word),trim(list))
   lastlist:=list
  }
  else
  lastlist:=list
  context()
 }
 if code=2001
 {
  char:=sc(2007,cpos-1)
  if char=10
  {
   fix_indent()
   if sc(2127,sc(2166,cpos)) && char=10
   send ^{right}
  }
  if char in 123,125
  fix_indent()
  ;if char in 32,44
  ;context() 
 }
 if code=2010
 ifwinactive,% var("edit colors")
 option({1:"font",2:"line_numbers"},,dlg_color(option().selectsinglenode("//font/line_numbers").text)),setcolors()
 if code=2027
 return changecolor()
 sc(2242,0,sc(2276,33,"_" sc(2154)))
}
autoopen(x=""){
 static
 static path:=[],value:=[]
 gui,2:default
 if !IsObject(xmldoc){
  xmlDoc:=ComObjCreate("MSXML2.DOMDocument")
  xmlDoc.setProperty("SelectionLanguage","XPath")
  filename:=x?x:gv(0,"file","lastopen")
  filename:=filename?filename:"Untitled.ahk"
  xml2:=xmldoc.createElement("Files")
  xmldoc.appendchild(xml2)
 }
 else
 {
  filename:=x
  xml2:=xmldoc.selectsinglenode("//Files")
 }
 loop,parse,filename,|
 {
  filename:=a_loopfield
  fileread,contents,%filename%
  update(filename,contents)
  splitpath,filename,name
  x1:=xmldoc.createelement("Main")
  x1.setattribute("main",filename)
  root:=tv_add(name)
  x2:=xmldoc.createelement("File")
  tab:=xmldoc.selectnodes("//Main").length
  tab:=!tab?1:tab+1
  x1.setattribute("tab",tab)
  x2.setattribute("file",filename)
  x2.setattribute("treeview",root)
  x2.setattribute("window",window)
  x2.setattribute("name",name)
  x1.appendchild(x2)
  fileread,contents,%filename%
  splitpath,filename,,maindir
  loop,parse,contents,`n,`r`n
  {
   if instr(a_loopfield,chr(35) include)
   {
    file:=trim(a_loopfield)
    stringreplace,file,file,`,,%a_space%,All
    inc:=substr(a_loopfield,10),inc:=InStr(inc,"*i ")?SubStr(inc,4):inc
    SplitPath,inc,file,dir
    inc:=!dir?maindir "\" inc:inc
    ifexist,%inc%
    {
     fileread,c,%inc%
     update(trim(inc),c)
     x2:=xmldoc.createelement("File")
     x2.setattribute("file",trim(inc))
     x2.setattribute("window",window)
     x2.setattribute("name",trim(file))
     x1.appendchild(x2)
     child:=tv_add(file,root)
     x2.setattribute("treeview",child)
     opened=1
    }
   }
  }
  xml2.appendchild(x1)
 }
 /*
 if !opened
 {
  update(filename,contents)
  window:=sc(2375)
  sc(2358,,window)
  option(o:={1:"Files",2:"file"},f:={file:"file",window:window},filename)
  sc(2181,,contents)
 }
 */
 list:=""
 tab:=xmldoc.selectnodes("//Main")
 while,main:=tab.item[a_index-1].selectsinglenode("@main").Text
 {
  splitpath,main,name
  list.=name "|"
 }
 GuiControl,1:,SysTabControl321,|%list%
 ;xml2.appendchild(x1)
 var("files",xmldoc)
 ;sc(2358,,lw)
 ;msgbox % xmldoc.xml
}
fix_indent(x=""){
 indent:=0 ;,fix:=av(0,"options","auto fix indentation")
 OnMessage(0x4E,"")
 s:=var("s")
 DllCall(s.fn,"Ptr",s.ptr,"UInt",2029,"Int","CRLF","Int",0,"Cdecl")
 ;ind:=av(0,"indent","level")?av(0,"indent","level"):1,sc:=gui(1),out:=scintilla_gettext(sc),indent:=0
 ind=1
 out:=gettext(var(1))
 fix=1
 sc(2078)
 if (x || fix)
 DllCall(s.fn,"Ptr",s.ptr,"UInt",2126,"Int",0,"Int",0,"Cdecl")
 loop,parse,out,`r,`r`n
 {
  if position:=instr(a_loopfield,";")
  text:=trim(substr(a_loopfield,1,position))
  else
  text:=trim(a_loopfield)
  if (SubStr(text,0)="{"){
   indent+=ind
   if (fix || x){
    DllCall(s.fn,"Ptr",s.ptr,"UInt",2126,"Int",A_Index-1,"Int",indent-1,"Cdecl")
    DllCall(s.fn,"Ptr",s.ptr,"UInt",2126,"Int",A_Index,"Int",indent,"Cdecl")
   }
   DllCall(s.fn,"Ptr",s.ptr,"UInt",2222,"Int",A_Index-1,"Int",0x2000|1024+indent-1,"Cdecl")
  }
  else if (text="}")
  {
   indent-=ind
   if indent < 0
   indent:=0
   if fix||x
   DllCall(s.fn,"Ptr",s.ptr,"UInt",2126,"Int",A_Index-1,"Int",indent,"Cdecl")
  }
  else if (fix || x)
  DllCall(s.fn,"Ptr",s.ptr,"UInt",2126,"Int",A_Index-1,"Int",indent,"Cdecl")
  DllCall(s.fn,"Ptr",s.ptr,"UInt",2222,"Int",A_Index,"Int",1024+indent,"Cdecl")
  list.=A_Index " " indent "`n"
  if indent < 0
  indent:=0  
 }
 update()
 sc(2079),index:=A_Index
 if indent>0
 tooltip,Segment is open,0,0,10
 else
 ToolTip,,,,10
 splashtextoff
 OnMessage(0x4E, "OnWmNotify")
}

update(x="",y=""){
 static script:=[]
 if y=get
 return script
 if (x=0 && y="get")
 return script
 if x&&y
 return script[x]:=y
 if x&&y=""
 return script[x]
 files:=var("files")
 script[files.selectsinglenode("//*[@*='" sc(2357) "']").selectsinglenode("@file").text]:=out:=gettext(var(1))
 modified(files.selectsinglenode("//*[@*='" sc(2357) "']").selectsinglenode("@file").text)
}
modified(x,y=0){
 static modified:=[]
 if x && y=0
 return modified[x]:=x
 if y=1
 return modified
 if (x="all"&&y=2)
 return modified:=object()
 if y=2
 return modified.remove(x)
}
save(){
 now:=a_now
 for a,b in modified(0,1)
 {
  if a=Untitled.ahk
  {
   fileselectfile,filename,S16,,Save Untitled.ahk as?
   if errorlevel
   continue
   filename:=instr(filename,".ahk")?filename:filename ".ahk"
   a:=filename
   update(filename,update("untitled.ahk"))
   update("untitled.ahk"," ")
   xml:=var("files"),root:=xml.selectsinglenode("//Files")
   xml1:=root.selectsinglenode("//Main[@main='Untitled.ahk']")
   xml1.setattribute("main",filename)
   xml2:=xml1.selectsinglenode("File")
   xml2.setattribute("file",filename)
   splitpath,filename,name
   xml2.setattribute("name",name)
   treeview:=xml2.selectsinglenode("@treeview").text
   gui,2:default
   tv_modify(treeview,"",name)
   tabs:=root.selectnodes("//Main")
   while,main:=tabs.item[a_index-1].selectsinglenode("@main").Text
   {
    splitpath,main,name
    list.=name "|"
   }
   GuiControl,1:,SysTabControl321,|%list%
  }
  fileread,old,%a%
  if old=% update(a)
  continue
  splitpath,a,name,dir
  backup:=dir "\backup\" now
  filecreatedir,%backup%
  filemove,%a%,%backup%\%name%,1
  fileappend,% update(a),%a%
 }
 modified("all",2)
 getpos(),savepos()
 segment:=var("files").selectsinglenode("//File[@window='" sc(2357) "']").selectsinglenode("@file").text
 option({1:"lastopen",2:"segment"},{segment:"segment"},segment)
 soxml()
}
savepos(){
 for a,b in var("windows"){
  wingetpos,x,y,,,% var(a)
  option(o:={1:"position",2:"position"},i:={position:a},"x" x " y" y " " gv(0,a,"position"))
 }
}
g_close(){
 3guiclose:
 88guiclose:
 5guiclose:
 10guiclose:
 8guiclose:
 gui,%a_gui%:hide
 savepos()
 return
}
jump_to_segment(){
 jump:
 window:=[]
 window[1]:={name:"Jump to Segment",position:"w300 h300",number:5}
 window[2]:={1:"Edit,w300 -Multi r1 x0 y0 gjs,Enter Segment Name",2:"Listview,w300 x0 r10,Open Files",3:"Button,gjts x0 Default,Jump to file"}
 window(window)
 gui,5:default
 root:=var("files").selectsinglenode("//*[@window='" sc(2357) "']..")
 f:=root.selectnodes("*/@name")
 while,out:=f.item[a_index-1].text
 lv_add("",out)
 lv_modifycol()
 lv_modify(1,"select focus")
 return
 5guiescape:
 gui,5:hide
 savepos()
 return
 jts:
 if lv_getnext()=0
 return
 lv_gettext(seg,lv_getnext())
 file:=var("files").selectsinglenode("//*[@window='" sc(2357) "']..")
 if !file.xml
 file:=var("files").selectsinglenode("//Main")
 filename:=file.selectsinglenode("//*[@name='" seg "']").selectsinglenode("@file").text
 select(filename)
 gui,5:hide
 return
 js:
 lv_delete()
 controlgettext,find,Edit1
 root:=var("files").selectsinglenode("//*[@window='" sc(2357) "']..")
 f:=root.selectnodes("*/@name")
 while,out:=f.item[a_index-1].text
 if instr(out,find)
 lv_add("",out)
 lv_modify(1,"Select Focus")
 return
 5GuiSize:
 ControlGetPos,,,,h,Button1,%win%
 ControlMove,Edit1,,,%A_GuiWidth%
 ControlMove,SysListView321,,,%A_GuiWidth%,% A_GuiHeight-h
 ControlMove,Button1,,% A_ScreenHeight
 size()
 return
}
files(info,all=""){
 f:=var("files")
 node:=info.main?info.main:"*"
 if all && node!="*"
 return f.selectsinglenode("//Main[@*='" node "']")
 if info.return
 return f.selectsinglenode("//*[@*='" search "']").selectsinglenode("@" info.return).text
 out:=f.selectsinglenode("//*[@*='" info.search "']").xml
 return out
}
setpos(){
 filename:=var("files").selectsinglenode("//*[@window='" sc(2357) "']").selectsinglenode("@file").text
 xml:=option()
 root:=xml.selectsinglenode("//cursor_position/file[text()='" filename "']")
 sc(2160,root.selectsinglenode("@min").text,root.selectsinglenode("@max").text),sc(2613,root.selectsinglenode("@scroll").text)
}
getpos(){
 xml:=option(),root:=xml.selectsinglenode("//Options")
 main:=var("files").selectsinglenode("//*[@window='" sc(2357) "']..").selectsinglenode("@main").text
 filename:=var("files").selectsinglenode("//*[@window='" sc(2357) "']").selectsinglenode("@file").text
 if !Main
 return
 if !pos:=xml.selectsinglenode("//cursor_position[@main='" main "']")
 pos:=xml.createelement("cursor_position"),pos.setattribute("main",main),root.appendchild(pos)
 if !position:=pos.selectsinglenode("//cursor_position/file[text()='" filename "']")
 position:=xml.createelement("file"),position.text:=filename,pos.appendchild(position)
 position.setattribute("min",sc(2009)),position.setattribute("max",sc(2008)),position.setattribute("scroll",sc(2152))
}
window(win,window="",var=""){
 static
 if Var
 {
  Gui,%window%:Submit,NoHide
  return out:=%var%
 }
 static windows:=[]
 num:=win[1].number
 tooltip ;needed for some reason
 Gui,%num%:Show,% "hide " win[1].position
 Gui,%num%:Destroy
 Gui,%num%:+LastFound
 windows[win[1].name]:=win[1].number
 wincolors(windows)
 if num=1
 Gui,%num%:+Resize +lastfound
 else
 Gui,%num%:+Resize +owner1 +lastfound
 for a,b in win[2]{
  b1:=b2:=b3:=""
  StringSplit,b,b,`,
  Gui,%num%:Add,%b1%,%b2%,%b3%
 }
 size:=gv(0,win[1].name,"position")
 loop,Parse,size,%A_Space%
 if SubStr(A_LoopField,2)=""
 {
  position:=1
  break
 }
 position:=position=1?"":size
 if !size
 position.=" " win[1].position
 if InStr(win[1].position,"hide")
 position.=" Hide"
 if win[1].name="Script Writer"
 {
  sc:=Scintilla_Add(WinExist(),0,20,400,400)
  var(1,sc)
  fn1:=DllCall("SendMessageA","UInt",sc,"int",2184,int,0,int,0)
  ptr1:=DllCall("SendMessageA","UInt",sc,"int",2185,int,0,int,0)
  s:={fn:fn1,ptr:ptr1}
  var("s",s)
  menu()
 }
 if win[1].name="Edit Colors"
 88menu()
 Gui,%num%:Show,% position,% win[1].name
 var("windows",windows)
 sleep,1
 var(win[1].name,"ahk_id " WinExist())
 hotkeys(1)
 return WinExist()
}
wincolors(windows=""){
 if !windows
 windows:=var("windows")
 background:=option().selectsinglenode("//font/Background_Color").text
 Background:=Background?Background:0 
 Background:=rgb(Background)
 for a,b in windows
 {
  if a=main
  continue
  ID:=b
  Gui,%id%:Default
  color:=gv("color",5,"font","style")
  name:=gv("name",5,"font","style")
  style:="s" gv("size",5,"font","style")
  color:=color?color:0xffffff
  gui,font,% style " c" RGB(Color),%name%
  gui,color,%background%,%background%
  winget,controllist,controllisthwnd,%a%
  loop,Parse,ControlList,`n
  {
   guicontrol,+background%background%,%A_LoopField%
   guicontrol,font,%A_LoopField%
  }
 }
}
rgb(c){
 setformat,IntegerFast,H
 c:=(c&255)<<16 | (c&65280) | (c>>16),c:=SubStr(c,1)
 SetFormat, integerfast,D
 return c
}
select(x=0){
 getpos()
 files:=var("files")
 if window:=files.selectsinglenode("//*[@file='" x "']").selectsinglenode("@window").text{
  sc(2358,,window)
  gui,2:default
  setpos()
 }
 else
 {
  contents:=update(x)
  if !contents
  fileread,contents,%x%
  window:=sc(2375)
  sc(2358,,window),set()
  sc(2181,,contents)
  modified(x,2)
  root:=var("files").selectsinglenode("//*[@file='" x "']")
  root.setattribute("window",window)
  setpos()
  ;return
 }
 root:=var("files").selectsinglenode("//*[@window='" sc(2357) "']..").selectsinglenode("@main").text
 xml:=option(),root:=xml.selectsinglenode("//cursor_position[@main='" root "']")
 if !lastopen:=root.selectsinglenode("lastopen")
 lastopen:=xml.createelement("lastopen"),root.appendchild(lastopen)
 lastopen.text:=x
 gui,2:default
 tv_modify(files.selectsinglenode("//*[@file='" x "']").selectsinglenode("@treeview").text,"select vis")
}
set(sc=""){
 language=asm
 sc(4006,,"asm")
 loop,7
 sc(4005,a_index-1,keywords(a_index))
}
keywords(x){
 static
 if (!isobject(keywords) || x=98)
 {
  keywords:=object(),com:=Object()
  1=autotrim blockinput break clipwait continue controlclick controlfocus controlget controlgetfocus controlgetpos controlgettext controlmove controlsend controlsendraw controlsettext coordmode critical detecthiddentext detecthiddenwindows drive driveget drivespacefree edit else endrepeat envadd envdiv envget envmult envset envsub envupdate exit exitapp fileappend filecopy filecopydir filecreatedir filecreateshortcut filedelete filegetattrib filegetshortcut filegetsize filegettime filegetversion fileinstall filemove filemovedir fileread filereadline filerecycle filerecycleempty fileremovedir fileselectfile fileselectfolder filesetattrib filesettime formattime getkeystate gosub goto groupactivate groupadd groupclose groupdeactivate gui guicontrol guicontrolget hideautoitwin hotkey if ifequal ifexist ifgreater ifgreaterorequal instr ifinstring ifless iflessorequal ifmsgbox ifnotequal ifnotexist ifnotinstring ifwinactive ifwinexist ifwinnotactive ifwinnotexist imagesearch inidelete iniread iniwrite input inputbox keyhistory keywait listhotkeys listlines listvars loop menu mouseclick mouseclickdrag mousegetpos mousemove msgbox onexit outputdebug pause pixelgetcolor pixelsearch postmessage process progress random regdelete regexmatch regexreplace regread regwrite reload repeat return run runas runwait send sendmessage sendraw sendinput setbatchlines setcapslockstate setcontroldelay setdefaultmousespeed setenv setformat setkeydelay setmousedelay setnumlockstate setscrolllockstate setstorecapslockmode settimer settitlematchmode setwindelay setworkingdir shutdown sleep sort soundbeep soundget soundgetwavevolume soundplay soundset soundsetwavevolume splashimage splashtextoff splashtexton splitpath statusbargettext statusbarwait stringcasesense stringgetpos stringleft stringlen stringlower stringmid stringreplace stringright stringsplit stringtrimleft stringtrimright stringupper suspend sysget thread tooltip transform traytip tv_add tv_modify tv_delete tv_getselection tv_getcount tv_getparent tv_getchild tv_getprev tv_getnext tv_gettext tv_get urldownloadtofile winactivate winactivatebottom winclose winget wingetactivestats wingetactivetitle wingetclass wingetpos wingettext wingettitle winhide winkill winmaximize winmenuselectitem winminimize winminimizeall winminimizeallundo winmove winrestore winset winsettitle winshow winwait winwaitactive winwaitclose winwaitnotactive purple
  2=a_ahkversion a_autotrim a_batchlines a_caretx a_carety a_computername a_controldelay a_cursor a_dd a_ddd a_dddd a_defaultmousespeed a_desktop a_desktopcommon a_detecthiddentext a_detecthiddenwindows a_endchar a_eventinfo a_exitreason a_formatfloat a_formatinteger a_gui a_guicontrol a_guicontrolevent a_guievent a_guiheight a_guiwidth a_guix a_guiy a_hour a_iconfile a_iconhidden a_iconnumber a_icontip a_index a_ipaddress1 a_ipaddress2 a_ipaddress3 a_ipaddress4 a_isadmin a_iscompiled a_issuspended a_keydelay a_language a_linefile a_linenumber a_loopfield a_loopfileattrib a_loopfiledir a_loopfileext a_loopfilefullpath a_loopfilelongpath a_loopfilename a_loopfileshortname a_loopfileshortpath a_loopfilesize a_loopfilesizekb a_loopfilesizemb a_loopfiletimeaccessed a_loopfiletimecreated a_loopfiletimemodified a_loopreadline a_loopregkey a_loopregname a_loopregsubkey a_loopregtimemodified a_loopregtype a_mday a_min a_mm a_mmm a_mmmm a_mon a_mousedelay a_msec a_mydocuments a_now a_nowutc a_numbatchlines a_ostype a_osversion a_priorhotkey a_programfiles a_programs a_programscommon a_screenheight a_screenwidth a_scriptdir a_scriptfullpath a_scriptname a_sec a_space a_startmenu a_startmenucommon a_startup a_startupcommon a_stringcasesense a_tab a_thishotkey a_thismenu a_thismenuitem a_thismenuitempos a_tickcount a_timeidle a_timeidlephysical a_timesincepriorhotkey a_timesincethishotkey a_titlematchmode a_titlematchmodespeed a_username a_wday a_windelay a_windir a_workingdir a_yday a_year a_yweek a_yyyy abort abs acos add ahk_class ahk_group ahk_id ahk_pid alnum alpha alt altdown altsubmit alttab alttabandmenu alttabmenu alttabmenudismiss altup alwaysontop appskey asc asin atan background backspace between bitand bitnot bitor bitshiftleft bitshiftright bitxor blind border bottom browser_back browser_favorites browser_forward browser_home browser_refresh browser_search browser_stop bs button buttons byref cancel capacity capslock caption ceil center check check3 checkbox checked checkedgray choose choosestring chr click clipboard clipboardall close color combobox contains control controllist cos count ctrl ctrlbreak ctrldown ctrlup date datetime days ddl default del delete deleteall delimiter deref destroy digit disable disabled down dropdownlist eject enable enabled end enter error errorlevel esc escape exp exstyle f1 f2 f3 f4 f5 f6 f7 f8 f9 f10 f11 f12
  3=allowsamelinecomments clipboardtimeout commentflag errorstdout escapechar hotkeyinterval hotkeymodifiertimeout hotstring include installkeybdhook installmousehook maxhotkeysperinterval maxmem maxthreads maxthreadsbuffer maxthreadsperhotkey noenv notrayicon persistent singleinstance usehook winactivateforce
  Loop,3
  keywords[a_index]:=%a_index%
  ;for a,b in av(0,"keywords")
  ;keywords[a+3]=b
  fileread,commands,commands.ini
  Loop,parse,commands,`n,`r
  {
   if !a_loopfield
   continue
   regexmatch(a_loopfield,"AU)(.*)[[:space:]\,]",out)
   if SubStr(A_LoopField,1,1)="_" || SubStr(out1,1,1)="_"
   continue
   if out && A_LoopField
   com[trim(out)]:=A_LoopField
   if (!out1 && InStr(list,"," a_loopfield ",")=0)
   list.=a_loopfield ","
   if out1 && InStr(list,"," out1 ",")=0
   list.=out1 ","
  }
  Sort,list,D`,
  keywords[99]:=list
  var("com",com)
  xmlDoc:=ComObjCreate("MSXML2.DOMDocument")
  xmlDoc.setProperty("SelectionLanguage","XPath")
  xmldoc.load("commands.xml")
  commands:=xmldoc.selectsinglenode("//Commands").text
  items:=xmldoc.selectsinglenode("//Items").text
  list:=commands " " items
  sort,list,UD%a_space%
  var("keywords",list)
  var("c",commands)
  var("commands",xmldoc)
 }
 out:=keywords[x]
 sort,out,D%a_space%
 return out
}
jump_to_project(){
 f:=var("files")
 files:=f.selectnodes("//Main")
 window:=[]
 window[1]:={name:"Jump to Project",position:"w400 h500",number:4}
 window[2]:={1:"Listview,x0 y0 w300 r10,Open Files",2:"Button,gjtp Default,Jump to file"}
 window(window)
 Gui,4:Default
 while,filename:=files.item[a_index-1].selectsinglenode("@main").text
 lv_add("",filename)
 return
 4guisize:
 ControlGetPos,,y,,h,Button1
 ControlMove,Button1,,% a_guiheight-8,%a_guiwidth%
 controlmove,SysListView321,,,%a_guiwidth%,% a_guiheight-h
 size()
 return
 4GuiEscape:
 4GuiClose:
 Gui,4:Hide
 return
 jtp:
 Gui,4:Default
 if LV_GetNext()!=0
 tabselection(LV_GetNext())
 ;LV_GetText(file,LV_GetNext())
 ;select(file)
 return
}
find(){
 window:=[]
 window[1]:={name:"Search",position:"w500 h500",number:10}
 window[2]:={1:"Edit,-multi r1 x0 y0",2:"treeview,ggh altsubmit vtv",3:"checkbox,ggh vsort,Sort by segment",4:"Button,default ggh vsearch hidden,Search"}
 var("search","ahk_id" window(window))
 controlfocus,Edit1,Search
 ControlSetText,Edit1,% option().selectsinglenode("//search/search").text
 send,^A
 WinSet,Redraw,,% var("search")
 return
 10guiescape:
 gui,10:hide
 savepos()
 return
 10GuiSize:
 ControlGetPos,,,,bh,Button1,% var("search")
 ControlMove,Button1,,% A_GuiHeight-3
 ControlMove,Edit1,,,%A_GuiWidth%
 ControlGetPos,,y,,eh,Edit1
 ControlGetPos,,by,,,Button1
 ControlMove,SysTreeView321,,% y+eh,% A_GuiWidth,% by-y-eh
 size()
 return
}
search(){
 controlgetfocus,control
 ControlGetText,find,Edit1,% var("search")
 if control=systreeview321
 {
  child:=tv_getchild(tv_getselection())
  tv_gettext(position,child)
  tv_gettext(file,tv_getnext(child))
  select(file),sc(2160,position,position+strlen(find))
 }
 if control=edit1
 {
  option(o:={1:"search",2:"search"},,find)
  check()
 }
 return
}
gh(){
 gh:
 function:=regexreplace(a_guicontrol," ","_")
 %function%()
 return
}
tv(){
 if !(a_guievent = "normal" or a_guievent = "I")
 return
 msgbox,here
}
check(){
 Gui,10:Default
 root:=var("files").selectsinglenode("//*[@window='" sc(2357) "']..")
 root:=root.selectnodes("*/@file")
 TV_Delete()
 controlget,sort,checked,,Button1,% var("search")
 ControlGetText,find,Edit1,% var("search")
 GuiControl,-Redraw,SysTreeView321
 contents:=update("get")
 while,file:=root.item[a_index-1].nodevalue,out:=update(file)
 if InStr(out,find){
  found:=file
  if sort
  cat:=TV_Add(found)
  loop {
   stringgetpos,pos,out,%find%,L%a_index%
   if pos=-1
   break
   text:=substr(out,1,instr(out,"`r",0,(pos+1))-1)
   text:=substr(text,instr(text,"`r",0,0)+1)
   if !sort
   f%a_index%:=TV_Add(text)
   else
   f%a_index%:=TV_Add(text,cat)
   TV_Add((pos), f%a_index%)
   TV_Add(file, f%a_index%)
  }
 }
 if TV_GetCount()
 controlfocus,SysTreeView321,Search 
 GuiControl,+Redraw,SysTreeView321
}
find_in_segment(){
 window:=[]
 value:=option().selectsinglenode("//search/segment").text
 window[1]:={name:"Find in Segment",position:"w400 h300",number:8}
 window[2]:={1:"Edit,x0 y0 w400 vsearch," value,2:"radio,vnext checked,Next",3:"radio,vprevious,Previous",4:"button,default gfis,Find"}
 window(window)
 Gui,8:Show,AutoSize
 return
 8GuiEscape:
 out:=window(0,8,"search")
 option(o:={1:"search",2:"segment"},,out)
 Gui,8:hide
 savepos()
 return
 fis:
 controlget,next,checked,,Next
 controlgettext,out,Edit1,Find in Segment
 out:=window(0,8,"search")
 if !next
 {
  sc(2190,sc(2008)-1)
  sc(2192,sc(0))
  start:=sc(2197,strlen(out),{astr:out})
  if start=-1
  {
   msgbox Reached the begining of the selection.
   return
  }
  Sc(2160,start,start+strlen(out))
 }
 else
 {
  sc(2190,sc(2008))
  sc(2192,sc(2006))
  start:=sc(2197,strlen(out),{astr:out})
  if start=-1
  {
   msgbox Reached the end of the selection.
   return
  }
  Sc(2160,start,start+strlen(out))
 }
 return
}
hotkeys(x=0){
 hotkeys:=option().selectnodes("//Hotkeys/*")
 while,node:=hotkeys.item[a_index-1],label:=node.nodename,key:=node.text,window:=node.selectsinglenode("@window").text
 {
  if (key && x=1){
   hotkey,ifwinactive,% var(window)
   hotkey,%key%,hotkey,On
  }
  if (key && x=0){
   hotkey,ifwinactive,% var(window)
   hotkey,%key%,hotkey,Off
  }
 }
 return
 hotkey:
 key:=option().selectsinglenode("//Hotkeys/*[text()='" a_thishotkey "']")
 hotkey:=key.nodename
 if isfunc(hotkey)
 %hotkey%()
 return
}
menu(){
 menu:=constants("menu")
 options:=option()
 if !xml:=options.selectsinglenode("//quick_settings")
 {
  for a in menu
  {
   mitem:=clean(menu[a].item)
   if (menu[a].menu="o")
   if mitem not in simple_brace,end_of_line,debug,settings
   option(o:={1:"quick_settings",2:mitem},,1)
  }
  xml:=options.selectsinglenode("//quick_settings")
 }
 for a in menu
 {
  menu,% menu[a].menu,add,% menu[a].item,menu
  fun:=clean1(menu[a].item)
  if xml.selectsinglenode(clean(menu[a].item)).text
  {
   Menu,o,Check,% menu[a].item
   if isfunc(v:=clean(menu[a].item))
   %v%()
  }
 }
 menu,bar,add,&File,:f
 menu,bar,add,&Edit,:e
 menu,bar,add,&About,:a
 menu,bar,add,&Options,:o
 menu,bar,add,&Window,:w
 gui,1:menu,bar
 return
 menu:
 fun:=clean1(A_ThisMenuItem)
 if (a_thismenu="o"&&a_thismenuitem!="&settings")
 options()
 if !isfunc(fun)
 msgbox not available yet
 else
 %fun%()
 return
}
constants(x){
 ;static
 static hotkeys:={"Next variable":"Script Writer","Previous variable":"Script Writer","Add variable":"Script Writer","Insert variable":"Script Writer","Function Finder":"Script Writer","Find Again":"Script Writer",Run:"Script Writer","Insert Function":"Script Writer",Find:"Script Writer",Testing:"Script Writer",Reload:"Script Writer","Character Count":"Script Writer","Scintilla Code Lookup":"Script Writer",headderval:{1:"Value",2:"Hotkey",3:"Window"}}
 static menu:="f,&New|f,&Open|f,I&mport|f,&Close|f,New S&egment|f,Create Se&gment From Selection|f,&Save|f,Open Fol&der|f,&Run|f,&Version|f,&Full Backup|f,&Publish|f,&Auto Update|f,&Upload|f,Post to A&hk.net|f,Expor&t|f,Export P&lugin|e,Global Fo&nt|e,Fi&x Indent|e,R&eplace Text|e,&Find|e,Fin&d in Segment|e,Ed&it Replacements|e,Cu&t|e,Edit &Highlight Text|e,Edit Co&lors|e,&Copy|e,&Jump to Segment|e,Ju&mp to Project|e,Paste	Ctrl &V|e,&Restore|e,Remove Current &Segment|e,&Plugins|e,Insert F&unction|e,Ch&aracter Count|a,&Help|a,&About|w,&Variables|w,&Ideas|f,E&xit|o,&Settings|o,&Auto Fix Indentation|o,&Highlight Matching Brace|o,&Word Wrap|o,&Context Sensitive Help|o,S&imple Brace|o,Create &Matching Brace|o,&End of line|o,&Debug"
 ftp:={Server:"",User:"",Pass:"",headderval:{1:"Value",2:"FTP Settings",3:""}}
 if isobject(%x%)
 return out:=%x%
 val:=[]
 loop,parse,%x%,|
 {
  StringSplit,_,A_LoopField,`,
  val[A_Index]:={menu:_1,item:_2}
 }
 return val
}
clean(x,y=0){
 if y=1
 return regexreplace(x,"i)(?:[^a-z0-9 ]|\&)","")
 return regexreplace(regexreplace(x,"i)(?:[^a-z0-9 ]|\&)","")," ","_")
}
clean1(x){
 return regexreplace(regexreplace(x,"i)(?:[^a-z0-9 ]|\&)","")," ","_")
}

cut(){
 sc(2177)
}
copy(){
 sc(2178)
}
pastectrl_v(){
 paste:
 sc(2179)
 ;if av(0,"options","auto fix indentation")
 fix_indent()
 if sc(2127,sc(2166,sc(2008))) && sc(2128,sc(2166,sc(2008)))>sc(2008)
 send ^{right}
 exit
}
setcolors(){
 for a,b in {Background_Color:"background",Line_Numbers_Background:"lnb",Word_Wrap_Markers:"wrap",line_numbers:"lnf"}
 %b%:=option().selectsinglenode("//font/" a).text
 background:=background?background:0
 color:=0xFFFFFF,name:="Tahoma",size:=12,style:=32,bold:=0,italic:=0,underline:=0
 sc(2056,style,name),sc(2051,style,color),sc(2055,style,size),sc(2054,style,italic),sc(2053,style,bold),sc(2059,style,underline),sc(2052,style,background) 
 font:=option().selectsinglenode("//font/*[@style='5']").selectnodes("@*")
 while,font.item[a_index-1].nodename,style:=32
 type:=font.item[a_index-1].nodename,value:=font.item[a_index-1].nodevalue,%type%:=value
 sc(2056,style,name),sc(2051,style,color),sc(2055,style,size),sc(2054,style,italic),sc(2053,style,bold),sc(2059,style,underline),sc(2052,style,background)
 defaultname:=name?name:"Tahoma",Defaultsize:=size?size:14
 OnMessage(0x4E, "OnWmNotify")
 sc(2055,32,size),sc(2050,32,0)
 lnb:=lnb?lnb:0xff00c0
 lnf:=lnf?lnf:0xffffff
 sc(2052,33,lnb),sc(2051,33,0xffffff),sc(2051,33,lnf)
 for a,b in {34:0xff0000,6:255,7:16744576,8:999999}
 sc(2051,a,b)
 fonts:=option().selectnodes("//font/*")
 while,font:=fonts.item[a_index-1].selectnodes("@*")
 {
  style:=color:=size:=italic:=bold:=underline:=0
  color:=0xFFFFFF,size:="",name:=""
  while,font.item[a_index-1].nodename
  type:=font.item[a_index-1].nodename,value:=font.item[a_index-1].nodevalue,%type%:=value
  name:=name?name:Defaultname,size:=size?size:Defaultsize
  sc(2056,style,name),sc(2051,style,color),sc(2055,style,size),sc(2054,style,italic),sc(2053,style,bold),sc(2059,style,underline),sc(2052,style,background)
  if style=38
  sc(2212,1)
 }
 if color:=option().selectsinglenode("//font/Word_Wrap_Markers").text
 sc(2051,32,color)
 sc(2069,0xffffff), sc(2052,38,0x808080)
}
global_font(x=5){
 if !font:=option().selectsinglenode("//font/*[@style='" x "']").selectnodes("@*")
 font:=option().selectsinglenode("//font/*[@style='5']").selectnodes("@*"),replace:=1 
 while,font.item[a_index-1].nodename
 type:=font.item[a_index-1].nodename,value:=font.item[a_index-1].nodevalue,%type%:=value
 defaults:={34:0xff0000,6:255,7:16744576,8:999999}
 color:=replace?defaults[x]:color
 if !font
 color:=0xFFFFFF,name:="Tahoma",size:=14
 if !dlg_font(name,style:={size:size,bold:bold,underline:underline,italic:italic},color)
 return
 option(o:={1:"font",2:"style"},{style:x})
 fix:=option().selectsinglenode("//font/*[@style='" x "']")
 for a,b in style
 fix.setattribute(a,b)
 fix.text:="_"
 setcolors(),wincolors()
}
Dlg_Font(ByRef Name,ByRef Style,ByRef Color,Effects=true,hGui=0){
 strput(strget(&name),&name,"CP0")
 LogPixels:=DllCall("GetDeviceCaps","uint",DllCall("GetDC","uint",hGui),"uint",90)
 VarSetCapacity(LOGFONT,128,0)
 Effects:=0x041+(Effects ? 0x100 : 0)
 DllCall("RtlMoveMemory","uint",&LOGFONT+28,"Uint",&Name,"Uint",32),clr:=color
 if style.bold
 NumPut(700,LOGFONT,16)
 if style.italic
 NumPut(255,LOGFONT,20,1)
 if style.underline
 NumPut(1,LOGFONT,21,1)
 if InStr(Style,"strikeout")
 NumPut(1,LOGFONT,22,1)
 if style.size
 {
  s:=-DllCall("MulDiv","int",style.size,"int",LogPixels,"int",72)
  NumPut(s,LOGFONT,0,"Int")
 }
 else  NumPut(16,LOGFONT,0)
 VarSetCapacity(CHOOSEFONT,60,0)
 ,NumPut(60,CHOOSEFONT,0)
 ,NumPut(hGui,CHOOSEFONT,4)
 ,NumPut(&LOGFONT,CHOOSEFONT,12)
 ,NumPut(Effects,CHOOSEFONT,20)
 ,NumPut(clr,CHOOSEFONT,24)
 r:=DllCall("comdlg32\ChooseFontA", "uint",&CHOOSEFONT)
 if !r
 return false
 VarSetCapacity(Name,32)
 DllCall("RtlMoveMemory","str",Name,"Uint",&LOGFONT + 28,"Uint",32)
 Style:="s" NumGet(CHOOSEFONT,16) // 10
 old:=A_FormatInteger
 SetFormat,integer,hex
 Color:=NumGet(CHOOSEFONT,24)
 SetFormat,integer,%old%
 Style=
 VarSetCapacity(s,3)
 DllCall("RtlMoveMemory","str",s,"Uint",&LOGFONT + 20,"Uint",3)
 bold:=NumGet(LOGFONT,16)>=700?1:0
 italic:=NumGet(LOGFONT,20,"UChar")?1:0
 underline:=NumGet(LOGFONT,21,"UChar")?1:0
 s:=NumGet(LOGFONT,0,"Int")
 style:={size:Abs(DllCall("MulDiv","int",abs(s),"int",72,"int",LogPixels)),underline:underline,italic:italic,bold:bold,name:strget(&name,cp0),color:color}
 name:=strget(&name,cp0) 
 return 1
}
publish(x=""){
 save()
 files:=var("files").selectsinglenode("//File[@window='" sc(2357) "']..").selectnodes("*/@file")
 while,name:=files.item[a_index-1].nodevalue
 {
  contents:=update(name)
  if !contents
  fileread,contents,%name%
  publish.=RegExReplace(contents "`r`n",chr(35) "include(.*)`r`n")
 }
 Clipboard:=publish
 MsgBox,Code coppied to Clipboard 
 /*
 text:=update("get")
 xmldoc:=var("xml")
 files:=xmldoc.selectnodes("//Main[@main='" gv(5) "']/File/@include")
 while,file:=files.item[A_Index-1].text
 {
  contents:=text[file]
  if !contents
  fileread,contents,% gv(file,2,2,1)
  if a_index=1
  publish.=RegExReplace(contents "`r`n",chr(35) "include(.*)`r`n")
  else
  publish.=contents "`r`n"
  Clipboard:=publish
  MsgBox,Code coppied to Clipboard 
 }
 */
}
restore(){
 window:=[]
 window[1]:={name:"Restore",position:"w800 h500",number:7}
 window[2]:={1:"listview,x0 y0 w550 h480 altsubmit grestore,Backup",2:"edit,x+0 w480 h480",3:"button,x0 grestorefile,Restore selected file"}
 window(window)
 Gui,7:Default
 file:=var("files").selectsinglenode("//*[@window='" sc(2357) "']").selectsinglenode("@file").text
 SplitPath,file,filename,dir
 loop,% dir "\backup\" filename,1,1
 {
  StringSplit,new,A_LoopFileDir,\
  last:=new0,d:=new%last%
  lv_add("",d)
 }
 LV_Modify(1,"select Focus")
 Restore:
 file:=var("files").selectsinglenode("//*[@window='" sc(2357) "']").selectsinglenode("@file").text
 SplitPath,file,filename,dir
 LV_GetText(bdir,LV_GetNext())
 FileRead,contents,% dir "\backup\" bdir "\" filename
 ControlSetText,Edit1,%contents%
 */
 return
 restorefile:
 ControlGetText,contents,Edit1
 Gui,7:Hide
 sc(2181,0,contents)
 setpos()
 return
 7guiescape:
 gui,7:hide
 return
 7GuiSize:
 ControlGetPos,,,,h,Button1,Restore
 ControlMove,SysListView321,,,,% A_GuiHeight-h
 ControlGetPos,,y,w,h,SysListView321
 ControlMove,Button1,,% y+h,%w%
 ControlMove,Edit1,,,% A_GuiWidth-w,%A_GuiHeight%
 return
}
code_explorer(){
 if !var("Code Explorer"){
  window:=[]
  window[1]:={name:"Code Explorer",position:"w550 h550",number:3}
  window[2]:={1:"TreeView,x0 y0",2:"Button,ggh vcoderefresh,Refresh list"}
  window(window)
 }
}
coderefresh(){
 SplashTextOn,200,100,Updating the Code Explorer,Please wait
 Gui,3:Default
 TV_Delete()
 function:=[]
 GuiControl,-Redraw,SysTreeView321
 for a,script in update(0,"get") ;Search all files
 Loop,Parse,script,`n,`r`n
 {
  main:=var("files").selectsinglenode("//*[@file='" a "']/..").selectsinglenode("@main").text
  search:=trim(InStr(A_LoopField,";")?trim(SubStr(A_LoopField,1,InStr(A_LoopField,";"))):search:=A_LoopField)
  if (RegExMatch(search,"U)(.*)\(.*\).*{",fun)){
   if !InStr(fun1," ") && !InStr(fun1,"=") && !InStr(fun1,",")
   function["Functions",main,search]:={data:search,pos:InStr(script,A_LoopField),file:a}
  }
  if !InStr(search,":")
  continue
  RegExMatch(search,"(.*):(.*)",block)
  if block1 && InStr(block1," ")=0 && !block2 && InStr(search,"::")
  function["Hotkey",main,search]:={data:search,pos:InStr(script,A_LoopField),file:a}
  if block1 && InStr(block1," ")=0 && !block2 && !InStr(block1,":")
  function["Blocks",main,search]:={data:search,pos:InStr(script,A_LoopField),file:a}
 }
 gui,3:Default
 for a in function
 {
  root:=TV_Add(a)
  for b in function[a]{
   parent:=TV_Add(b,root)
   for c in function[a,b]{
    child:=TV_Add(function[a,b,c].data,parent)
    TV_Add(function[a,b,c].file,child)
    TV_Add(function[a,b,c].pos,child)
   }
  }
 }
 GuiControl,+Redraw,SysTreeView321
 SplashTextOff
 return
 3GuiSize:
 SysGet,Caption,4
 SysGet,Border,8
 caption+=Border
 ControlGetPos,,,,h,Button1,Code Explorer
 ControlMove,Button1,,% A_GuiHeight-(h-caption-Border-Border+1),%A_GuiWidth%
 ControlGetPos,,y,,,Button1,Code Explorer
 ControlMove,SysTreeView321,,,% A_GuiWidth,% y-border-caption
 size()
 return
}
options(){
 x:=a_thismenuitem
 op:=clean(a_thismenuitem)
 if !op
 return
 options:=option()
 xml:=options.selectsinglenode("//quick_settings")
 node:=xml.selectsinglenode(op)
 value:=node.text
 value:=value?0:1
 node.text:=value
 if value
 Menu,o,Check,%x%
 else
 Menu,o,UnCheck,%x%
 ;option:=clean(x)
 if IsFunc(op)
 %op%(value)
 exit
}
debug(){
 
}
word_wrap(){
 sc(2460,2)
 value:=option().selectsinglenode("//Word_Wrap").text
 value:=value?value:0
 sc(2268,value)
}
Edit_colors(){
 window:=[]
 window[1]:={name:"Edit Colors",position:"w500 h500",number:88}
 window[2]:={1:"Button,Hidden"}
 hgui:=window(window)
 Hotkey,IfWinActive,% var("edit colors")
 Hotkey,RButton,rcm,on
 sc:=Scintilla_Add(hgui,0,0,var("tempw"),var("temph"))
 fn1:=DllCall("SendMessageA","UInt",sc,"int",2184,int,0,int,0)
 ptr1:=DllCall("SendMessageA","UInt",sc,"int",2185,int,0,int,0)
 var("f",{fn:fn1,ptr:ptr1,colors:sc})
 out=/*`nMulti-Line`ncomments`n*/`nSelect the text to change the colors`nThis is a sample of normal text`n`"incomplete quote`n"complete quote"`n`;comment`n0123456789`n()[]^&*()+~`{`}``b``a``c``k``t``i``c``k`n
 loop,6
 out.="Keyword set" a_index "=" keywords(a_index)  "`n"
 out.="Keyword sets 4-6 are yours to add whatever you like. `nGoto Edit/Edit highlight text to add/edit your lists.`n`nRight click to change the style of each font.`n`nLeft click for better control of colors." 
 DllCall(fn1,"Ptr",ptr1,"UInt",2181,"Int","","aStr",out,"Cdecl")
 DllCall(fn1,"Ptr",ptr1,"UInt",2246,"Int",0,"int",1,"Cdecl")
 DllCall(fn1,"Ptr",ptr1,"UInt",2069,"Int",0xFFFFFF,"int",0,"Cdecl")
 language=asm
 DllCall(fn1,"Ptr",ptr1,"UInt",4006,"Int",0,"astr",language,"Cdecl")
 gui,88:show
 WinGetPos,x,y,w,h,Edit Colors
 if (w<100 || h<100)
 WinMove,Edit Colors,,% x,% y,200,200 
 loop,7
 sc(4005,A_Index-1,keywords(A_Index))
 sc(2246,0,1)
 setcolors()
 loop,34
 DllCall(fn1,"Ptr",ptr1,"UInt",2409,"Int",a_index-1,"int",1,"Cdecl")
 ; sc(2409,a_index-1,1)
 return
 88GuiSize:
 ControlMove,Scintilla1,,,%A_GuiWidth%,%A_GuiHeight%,% var("edit colors")
 var("tempw",A_GuiWidth),var("temph",A_GuiHeight)
 size()
 return
 colormenu:
 name:=clean(a_thismenuitem)
 if name=syntax_font
 {
  global_font(38)
  return
 }
 color:=option().selectsinglenode("//font/" name).text
 option({1:"font",2:name},,dlg_color(color))
 setcolors(),wincolors() 
 return
}
Dlg_Color(Color, setcolor=""){
 VarSetCapacity(CHOOSECOLOR, 0x24, 0), VarSetCapacity(CUSTOM, 64, 0)
 ,NumPut(0x24,CHOOSECOLOR, 0), NumPut(hGui,CHOOSECOLOR, 4)
 ,NumPut(color,CHOOSECOLOR, 12), NumPut(&CUSTOM,CHOOSECOLOR, 16)
 ,NumPut(0x00000103,CHOOSECOLOR, 20)
 nRC := DllCall("comdlg32\ChooseColorA", str, CHOOSECOLOR)
 if (errorlevel <> 0) || (nRC = 0)
 Exit
 setformat,integer,H
 clr := NumGet(CHOOSECOLOR, 12)
 setformat,integer,D
 return %clr%
}
changecolor(){
 Defaultcolor:=option().selectsinglenode("//font/*[@style='5']").selectsinglenode("@color").text
 Defaultcolor:=Defaultcolor?Defaultcolor:0xFFFFFF
 defaults:={34:0xff0000,6:255,7:16744576,8:999999}
 style:=sc(2010,sc(2008))
 if !color:=option().selectsinglenode("//font/*[@style='" style "']")
 option(o:={1:"font",2:"style"},{style:style}),color:=option().selectsinglenode("//font/*[@style='" style "']")
 if !c:=color.selectsinglenode("@color").text
 c:=defaults[style]?defaults[style]:Defaultcolor
 color.setattribute("color",c)
 newcolor:=dlg_color(c)
 color.setattribute("color",newcolor)
 color.text:="_"
 setcolors(),wincolors()
 return
 rcm:
 mousegetpos,,,out
 WinGetTitle,win,ahk_id %out%
 ControlGetPos,xx,yy,,,Scintilla1,Edit Colors
 MouseGetPos,x,y
 x:=x-xx,y:=y-yy
 style:=Sc(2010,Sc(2022,x,y))
 return global_font(style)
}
88menu(){
 menu,list,add,Background Color,colormenu
 menu,list,add,Line Numbers Background,colormenu
 menu,list,add,Syntax Font,colormenu
 menu,list,add,Word Wrap Markers,colormenu
 menu,list,add,Line Numbers Background,colormenu 
 menu,other,add,Other Colors,:list
 gui,88:menu,other
}
settings(){
 window:=[]
 window[1]:={name:"Settings",position:"w400 h500",number:6}
 window[2]:={1:"ListView,x0 y20 Grid -ReadOnly gsettings AltSubmit,Value|Setting|Window",2:"Tab,x0 y0 vtab gchangetab -Wrap,Hotkeys|Ftp"}
 window(window)
 fillsettings(),hotkeys()
 return
 6GuiSize:
 VarSetCapacity(Rect,16,0)
 SendMessage,0x130a,0,&Rect,SysTabControl321,% var("main") ;thank you Rseding91
 h:=NumGet(Rect,12,"Int")
 ControlGetPos,,y,,,SysTabControl321
 ControlMove,SysTabControl321,,,%A_GuiWidth%,%h%
 ControlMove,SysListView321,,% y+h,%A_GuiWidth%,% A_GuiHeight-h
 Size()
 return
 settings:
 if a_guievent=Normal
 send,{f2}
 return
 changetab:
 savesettings()
 values:=window(0,6,"tab")
 fillsettings()
 return
 6guiclose:
 6guiescape:
 savesettings()
 hotkeys(1)
 gui,6:hide
 return
}
fillsettings(x=0){
 Gui,6:Default
 LV_Delete()
 values:=window(0,6,"tab")
 settings:=constants(values)
 for a,b in settings
 if isobject(b)
 {
  for index,value in b
  lv_modifycol(index,"",value)
 }
 else
 LV_Add("",option().selectsinglenode("//" clean(values) "/" clean(a)).text,a,b)
 LV_ModifyCol(1,"autohdr")
 LV_ModifyCol(2,"autohdr")
}
savesettings(){
 Gui,6:Default
 options:=option()
 add:=options.selectsinglenode("//Options")
 values:=window(0,6,"tab")
 loop,% lv_getcount(){
  LV_GetText(value,a_index),LV_GetText(setting,a_index,2),lv_gettext(window,a_index,3)
  if !main:=options.selectsinglenode("//Options/" clean(values))
  main:=options.createelement(clean(values)),add.appendchild(main)
  if s:=options.selectsinglenode("//Options/" clean(values) "/" clean(setting))
  if !value
  {
   s.text:=""
   continue
  }
  if !value
  continue
  if !s:=options.selectsinglenode("//Options/" clean(values) "/" clean(setting))
  s:=options.createelement(clean(setting))
  s.text:=value
  if window
  s.setattribute("window",clean(window))
  main.appendchild(s)
 }
}
new_segment(){
 nodes:=var("files")
 node:=nodes.selectsinglenode("//*[@window='" sc(2357) "']../File"),main:=node.selectsinglenode("..")
 mainfile:=main.selectsinglenode("@main").text
 splitpath,mainfile,,dir
 inputbox,segment,Input a new name
 if (segment="" || errorlevel)
 exit
 ifexist,%dir%\%segment%
 {
  msgbox file exists, please choose another
  new_segment()
 }
 gui,2:default
 root:=tv_getparent(tv_getselection())
 window:=node.selectsinglenode("@window").text
 if (window=sc(2357)){
  text:=update(node.selectsinglenode("@file").text) "`r`n" chr(35) "include " segment
  sc(2181,,text)
  setpos()
  root:=tv_getselection()
 }
 if window && window != sc(2357)
 sc(2377,window),node.setattribute("window","")
 text:=update(mainfile)
 update(node.selectsinglenode("@file").text,text "`r`n" chr(35) "include " segment),modified(node.selectsinglenode("@file").text)
 fileappend,%a_space%,%dir%\%segment%
 current:=tv_add(segment,root)
 file:=nodes.createelement("File"),file.setattribute("file",dir "\" segment),file.setattribute("window",""),file.setattribute("treeview",current),file.setattribute("name",segment)
 node:=nodes.selectsinglenode("//*[@window='" sc(2357) "']..")
 node.appendchild(file),select(dir "\" segment)
}
testing(){
 msgbox % var("files").xml
}
/* Make the commands.xml
fileread,commands,commands.ini
xmlDoc:=ComObjCreate("MSXML2.DOMDocument")
xmlDoc.setProperty("SelectionLanguage","XPath")
xml2:=xmldoc.createElement("Commands")
root:=xmldoc.createelement("Commands")
xml3:=xmldoc.createelement("Items")
xmldoc.appendchild(root)
loop,parse,commands,`n,`r`n
{
 stringsplit,command,a_loopfield,%a_space%
 com:=command1,syntax:=substr(a_loopfield,strlen(command1)+2)
 if !com
 continue
 node:=!syntax?"item":"commands"
 if node=commands
 {
  xml1:=xmldoc.createelement(node)
  xml1.text:=com
  xml1.setattribute("syntax",syntax)
  xml2.appendchild(xml1)
 }
 else
 {
  xml1:=xmldoc.createelement(node)
  xml1.text:=com
  xml3.appendchild(xml1)   
 }
}
root.appendchild(xml2)
root.appendchild(xml3)
xsl:=style()
xmldoc.transformNodeToObject(xsl,xmldoc)	;Apply the Style Sheet
xmldoc.save("commands.xml")
run commands.xml
}
*/

 
 
;sweet

msgbox ok 
context(){
 static lasttip
 if !option().selectsinglenode("//Context_Sensitive_Help").text
 return
 code:=substr(getline(),1,sc(2129,sc(2008)))
 line:=sc(2166,sc(2008)),home:=sc(2128,line),current:=sc(2008),out:=gettext(var(1))
 while current > home , current--
 {
  start:=sc(2266,current,1),end:=sc(2267,current,1),word:=substr(out,start+1,length:=abs(end-start))
  if sc(2007,current)=41
  {
   current:=sc(2353,current),current:=sc(2266,current)
   continue
  }
  if word
  if InStr(var("c")," " word " "){
   RegExMatch(var("c"),"i)" word,found)
   context:=var("commands").selectsinglenode("//*[text()='" found "']").selectsinglenode("@syntax").text
   if !context
   continue
   if (sc(2102)=0)
   sc(2200,sc(2008),word context)
   line:=RegExReplace(RegExReplace(getline(),"U)" chr(34) ".*" chr(34)),"\(.*\)")
   lasttip:=word
   return
  }
  current:=start
 }
 sc(2201)
}  
getline(){
 s:=var("s")
 length:=DllCall(s.fn,"Ptr",s.ptr,"UInt",2153,"Int",sc(2166,sc(2008)),"Int",0,"Cdecl")
 VarSetCapacity(te,length)
 DllCall(s.fn,"Ptr",s.ptr,"UInt",2153,"Int",sc(2166,sc(2008)),"Int",&te,"Cdecl")
 return strget(&te,out,utf-16)
}
/*
Ideas window
work on folding
Multiple Files
*/
close(){
 msgbox coming soon
}
insert_function(){
 InputBox,name,Function name,Input the name of the function
 InputBox,options,Function Options,Input the options for this function (eg. function(*this information) )
 sc(2003,sc(2008),name "(" options "){`n`n}"),fix_indent()
 send,{down}^{right}
 coderefresh()
}
new(){
 FileSelectFile,filename,S16,,Create a new file,AHK Files (*.ahk)
 if ErrorLevel
 return
 file:=InStr(filename,".ahk")?filename:filename ".ahk"
 IfExist,%file%
 {
  MsgBox,Please choose another name.
  new()
 }
 FileAppend,"#SingleInstance, Force",%file%
 files:=file
 list:=trim(option().selectsinglenode("//lastopen/file").text,"|")  "|" trim(files,"|")
 option(o:={1:"lastopen",2:"file"},f:={file:"file"},trim(list,"|"))
 soxml()
 autoopen(trim(files,"|"))
}
