#singleinstance,force
detecthiddenwindows,on
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
gui(),variables(1)
return
/*
ControlGet,out,list,,,% var("main") ;Use this to get a list in a listbox    % var("main") is the hgui or gui handle ;)
*/
return
size(){
 option({1:"position",2:"position"},i:={position:var("windownames")[A_Gui]},"w" a_guiwidth " h" a_guiheight)
}
jumptreeview(){
 jtv:
 if a_guievent!=Normal
 return
 gui,2:default
 select(var("files").selectsinglenode("//*[@*='" tv_getselection() "']").selectsinglenode("@file").text)
 return
}
Scintilla_Add(ParentWindowID, X, Y, W, H){
 Static ScintillaIndex := 0
 if !DllCall("GetModuleHandle","str","SciLexer.dll")
 DllCall("LoadLibrary","str","SciLexer.dll")
 return DllCall("CreateWindowEx" ,"int",0x200 ,"str","Scintilla"
 ,"str","Scintilla" . ++ScintillaIndex ,"int", 0x52310000
 ,"int",X ,"int",Y ,"int",W ,"int",H ,"uint",ParentWindowID
 ,"uint",0 ,"uint",0 ,"uint",0)
}
string(y){
 loop,parse,y,| 
 {
  StringSplit,a,A_LoopField,`,
  sc(a1,a2,a3),a1:=a2:=a3:=""
 }
}
*/
GetText(x=""){
 s:=var("s")
 length:=DllCall(s.fn,"Ptr",s.ptr,"UInt",2182,"Int",0,"Int",0,"Cdecl")
 VarSetCapacity(te,length)
 DllCall(s.fn,"Ptr",s.ptr,"UInt",2182,"Int",length,"Int",&te,"Cdecl")
 return strget(&te,"",utf-16)
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
gui(x=0){
 static
 Version=0.400.13
 if x
 return out:=%x%
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
 hotkeys(1)
 hotkey,ifwinactive,ahk_id %hgui%
 hotkey,!j,jump,on
 sc(2077,,"#abcdefghijklmnopqrstuvwxyz_ABCDEFGHIJKLMNOPQRSTUVWZYZ"),sc(2115,1)
 code_explorer()
 winactivate,% var("script writer")
 string(" 2246,2,1|2242,0,0|2242,1,15|2155,0|2069,0xFFFFFF|2242,0,0|2155,,0|2132,1|2460,3|2462,1|2134,1|2260,1|2264,1000|2122,indent|2037,65001|2040,1,7|2115,1")
 string("2242,2,13|2244,2,0xFE000000|2040,25,13|2040,26,15|2040,27,11|2040,28,10|2040,29,9|2040,30,12|2040,31,14|2233,16")
 return
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
 2GuiSize:
 ControlMove,SysTreeView321,,,A_GuiWidth,A_GuiHeight
 size()
 return
}
tabselection(tab=""){
 programs:
 if !tab
 ControlGet,Tab,Tab,,SysTabControl321,% var("script writer")
 main:=var("files").selectsinglenode("//Main[@tab='" tab "']").selectsinglenode("@main").text
 last:=option().selectsinglenode("//file_information[@main='" main "']").selectsinglenode("lastopen").text
 main:=last?last:main
 tab=
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
skimcode(){
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
}
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
 path:="//" main
 for a,b in struct
 path.="/" b
 return root.SelectSingleNode(path)
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
  start:=sc(2266,cpos,1),end:=sc(2267,cpos,1),out:=gettext(var(1)),word:=substr(out,start+1,length:=abs(end-start))
  keywords:=var("keywords"),keywords.=" " RegExReplace(var("customvarlist"),"\|"," ")
  if (strlen(word)>1)
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
  char:=sc(2007,cpos-1)
  if char in 40,44,32
  rep(word,cpos)
  if (char=40&&option().SelectSingleNode("//Smart_Parentheses").text){
   line:=sc(2166,sc(2008)),home:=sc(2008)-1,end:=sc(2136,line)
   while,% home+A_Index < End,current:=home+A_Index
   if (sc(2007,current)=40){
    sc(2003,sc(2353,current),")"),added=1
    break
   }
   if !added
   sc(2003,sc(2008),")")
  }
  if (char=123&&option().SelectSingleNode("//Create_Matching_Brace").text)
  {
   if sc(2008)!=sc(2009)
   return sc(2003,sc(2008),"{"),sc(2003,sc(2009,"`n}"))
   fold:=sc(2223,sc(2166,cpos))
   line:=sc(2224,sc(2166,cpos),fold-1)
   position:=sc(2136,line)
   sc(2003,position,"`n}")
   fix_indent()
   return
  }
  if (char=123&&option().SelectSingleNode("//Simple_Brace").text)
  sc(2003,sc(2008),chr(125))
  if char in 10,123,125
  {
   fix_indent()
   if sc(2127,sc(2166,cpos)) && char=10
   send ^{right}
  }
 }
 if code=2010
 {
  win:=WinActive()
  WinGetTitle,win,% "ahk_id" win
  if InStr(win,"Script Writer")
  fold()
  if InStr(win,"Edit Colors")
  option({1:"font",2:"line_numbers"},,dlg_color(option().selectsinglenode("//font/line_numbers").text)),setcolors()
 }
 if code=2027
 return changecolor()
 if code=2007
 {
  line:=sc(2166,cpos)+1
  text:="Row:" line " Column:" sc(2129,cpos),StatusBar({1:text,2:1})
  if option().SelectSingleNode("//Highlight_Matching_Brace").text
  {
   max:=sc(2006),out:=sc(2353,cpos),out1:=sc(2353,cpos-1),sub:=out>0?out:sub:=out1>0?out1:-1,cp:=out>0?cpos:cpos-1
   if sub>0
   sc(2351,cp,sub)
   else
   sc(2352,-1)
  }
 }
 sc(2242,0,sc(2276,33,"_" sc(2154)))
}
autoopen(x="",clear=""){
 static
 static path:=[],value:=[]
 gui,2:default
 if (IsObject(xmldoc)=0 || clear=1){
  TV_Delete()
  xmlDoc:=ComObjCreate("MSXML2.DOMDocument")
  xmlDoc.setProperty("SelectionLanguage","XPath")
  filename:=x?x:gv(0,"file","lastopen")
  filename:=Trim(filename,"|")
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
  ;x1.setattribute("treeview",root)
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
 list:=""
 tab:=xmldoc.selectnodes("//Main")
 while,main:=tab.item[a_index-1].selectsinglenode("@main").Text
 {
  splitpath,main,name
  list.=name "|"
 }
 GuiControl,1:,SysTabControl321,|%list%
 var("files",xmldoc)
}
fix_indent(x=""){
 ;,fix:=av(0,"options","auto fix indentation")
 OnMessage(0x4E,"")
 s:=var("s")
 DllCall(s.fn,"Ptr",s.ptr,"UInt",2029,"Int","CRLF","Int",0,"Cdecl")
 ;ind:=av(0,"indent","level")?av(0,"indent","level"):1,sc:=gui(1),out:=scintilla_gettext(sc),indent:=0
 ind:=1,indent:=0
 out:=gettext(var(1))
 fix:=option().SelectSingleNode("//Auto_Fix_Indentation").text
 fix:=fix!=""?fix:0
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
 now:=a_now,lastvar()
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
  pos:=gv(0,a,"position")
  pos:=SubStr(pos,InStr(pos,"w"))
  option(o:={1:"position",2:"position"},i:={position:a},"x" x " y" y " " pos)
 }
}
g_close(){
 12GuiClose:
 12GuiEscape:
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
 window[2]:={1:"Edit,w300 -Multi r1 x0 y0 gjs,Enter Segment Name",2:"Listview,w300 x0 r10,Open Files",3:"Button,gjts x0 Default,Jump to Segment"}
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
 filename:=file.selectsinglenode("*[@name='" seg "']").selectsinglenode("@file").text
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
 root:=xml.selectsinglenode("//file_information/position[text()='" filename "']")
 min:=root.selectsinglenode("@min").text,max:=root.selectsinglenode("@max").text,scroll:=root.selectsinglenode("@scroll").text
 fold:=root.selectsinglenode("@fold").text
 min:=min?min:0,max:=max?max:0,scroll:=scroll?scroll:0
 sc(2160,min,max),sc(2613,scroll)
 Loop,Parse,fold,`,
 sc(2231,A_LoopField)
}
getpos(){
 xml:=option(),root:=xml.selectsinglenode("//Options")
 main:=var("files").selectsinglenode("//*[@window='" sc(2357) "']..").selectsinglenode("@main").text
 filename:=var("files").selectsinglenode("//*[@window='" sc(2357) "']").selectsinglenode("@file").text
 if !Main
 return
 if !pos:=xml.selectsinglenode("//file_information[@main='" main "']")
 pos:=xml.createelement("file_information"),pos.setattribute("main",main),root.appendchild(pos)
 if !position:=pos.selectsinglenode("//file_information/position[text()='" filename "']")
 position:=xml.createelement("position"),position.text:=filename,pos.appendchild(position)
 position.setattribute("min",sc(2009)),position.setattribute("max",sc(2008)),position.setattribute("scroll",sc(2152))
 fold:=0
 while,sc(2618,fold)>=0,fold:=sc(2618,fold)
 list.=fold ",",fold++
 fold:=trim(list,",")
 position.setattribute("fold",fold)
}
window(win,window="",var=""){
 static
 static windownames:=[]
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
 87menu()
 Gui,%num%:Show,% position,% win[1].name
 var("windows",windows)
 sleep,1
 var(win[1].name,"ahk_id " WinExist())
 windownames[win[1].number]:=win[1].name
 var("windownames",windownames)
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
 getpos(),lastvar(),files:=var("files")
 if window:=files.selectsinglenode("//*[@file='" x "']").selectsinglenode("@window").text{
  sc(2358,,window)
  gui,2:default
  fix_indent()
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
  fix_indent()
  setpos()
 }
 GuiControl,1:Choose,SysTabControl321,% root:=var("files").selectsinglenode("//*[@window='" sc(2357) "']..").selectsinglenode("@tab").Text
 root:=var("files").selectsinglenode("//*[@window='" sc(2357) "']..").selectsinglenode("@main").text
 xml:=option(),root:=xml.selectsinglenode("//file_information[@main='" root "']")
 if !lastopen:=root.selectsinglenode("lastopen")
 lastopen:=xml.createelement("lastopen"),root.appendchild(lastopen)
 lastopen.text:=x
 SplitPath,x,name
 name:="Segment: " name
 StatusBar({1:name,2:2})
 gui,2:default
 tv_modify(files.selectsinglenode("//*[@file='" x "']").selectsinglenode("@treeview").text,"select vis")
 populatevariables()
 sc(2242,0,sc(2276,33,"_" sc(2154)))
 root:=var("files").selectsinglenode("//*[@window='" sc(2357) "']../@main").text
 last:=option().selectsinglenode("//file_information[@main='" root "']").SelectSingleNode("ideas")
 ControlSetText,Edit1,% last.text,% var("ideas")
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
  loop,3
  keywords[a_index+3]:=option().SelectSingleNode("//keywords/Keyword_List_" A_Index+3).Text
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
  list:=" " commands " " items " "
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
 LV_Modify(1,"Select Focus")
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
 Gui,8:Show
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
reload(){
 reload
}

menu(){
 Menu,o,UseErrorLevel,On
 menu:=constants("menu")
 options:=option()
 if !xml:=options.selectsinglenode("//quick_settings")
 {
  for a in menu
  {
   mitem:=clean(menu[a].item)
   if (menu[a].menu="o")
   if mitem not in simple_brace,end_of_line,debug,settings
   option({1:"quick_settings",2:mitem},,1)
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
 static hotkeys:={"Next variable":"Script Writer","Previous variable":"Script Writer","Add variable":"Script Writer","Function Finder":"Script Writer","Find Again":"Script Writer",Run:"Script Writer","Insert Function":"Script Writer",Find:"Script Writer",Testing:"Script Writer",Reload:"Script Writer","Character Count":"Script Writer","Scintilla Code Lookup":"Script Writer",headderval:{1:"Value",2:"Hotkey",3:"Window"}}
 static menu:="f,&New|f,&Open|f,I&mport|f,&Close|f,New S&egment|f,Create Se&gment From Selection|f,&Save|f,Open Fol&der|f,&Run|f,&Version|f,&Full Backup|f,&Publish|f,&Auto Update|f,&Upload|f,Post to A&hk.net|f,Expor&t|f,Export P&lugin|e,Global Fo&nt|e,Fi&x Indent|e,R&eplace Text|e,&Find|e,Fin&d in Segment|e,Ed&it Replacements|e,Cu&t|e,Edit &Highlight Text|e,Edit Co&lors|e,&Copy|e,&Jump to Segment|e,Ju&mp to Project|e,Paste	Ctrl &V|e,&Restore|e,Remove Current &Segment|e,&Plugins|e,Insert F&unction|e,Ch&aracter Count|a,&Help|a,&About|w,&Variables|w,&Ideas|f,E&xit|o,&Settings|o,&Auto Fix Indentation|o,&Highlight Matching Brace|o,&Word Wrap|o,&Context Sensitive Help|o,S&imple Brace|o,Create &Matching Brace|o,Smart &Parentheses|o,&End of line|o,&Debug"
 static ftp:={Server:"",Username:"",Password:"",headderval:{1:"Value",2:"FTP Settings",3:""}}
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
 sc(2052,33,lnb),sc(2051,33,0xffffff),sc(2290,1,lnb),Sc(2291,1,lnb)
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
 root:=var("files").selectsinglenode("//*[@window='" sc(2357) "']../@main").text
 info:=option().selectsinglenode("//file_information[@main='" root "']")
 version:=info.SelectSingleNode("version/@version").text
 files:=var("files").selectsinglenode("//File[@window='" sc(2357) "']..").selectnodes("*/@file")
 while,name:=files.item[a_index-1].nodevalue
 {
  contents:=update(name)
  if !contents
  fileread,contents,%name%
  publish.=RegExReplace(contents "`r`n",chr(35) "include(.*)`r`n")
 }
 StringReplace,publish,publish,% chr(59) "auto_version",Version=%version%
 if x
 return publish
 Clipboard:=publish
 MsgBox,Code coppied to Clipboard 
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
  window[2]:={1:"TreeView,x0 y0 gexplorer",2:"Button,ggh vcoderefresh,Refresh list"}
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
   if !b
   continue
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
 explorer:
 
 return
}
options(x=""){
 x:=x?x:A_ThisMenuItem
 op:=clean(x)
 if !op
 return
 options:=option()
 xml:=options.selectsinglenode("//quick_settings")
 if !node:=xml.selectsinglenode(op)
 node:=options.createelement(op),xml.appendchild(node)
 value:=node.text
 value:=value?0:1
 node.text:=value
 if value
 Menu,o,Check,%x%
 else
 Menu,o,UnCheck,%x%
 if IsFunc(op)
 %op%(value)
 exit
}
word_wrap(){
 sc(2460,2)
 value:=option().selectsinglenode("//Word_Wrap").text
 value:=value?value:0
 sc(2268,value)
}
simple_brace(){
 Menu,o,Enable,Create &Matching Brace
 if ErrorLevel
 return
 if (option().selectsinglenode("//Create_Matching_Brace").text&&option().selectsinglenode("//Simple_Brace").text)
 options("Create &Matching Brace")
}
create_matching_brace(){
 Menu,o,Enable,S&imple Brace
 if ErrorLevel
 return
 if (option().selectsinglenode("//Create_Matching_Brace").text&&option().selectsinglenode("//Simple_Brace").text)
 options("S&imple Brace")
}
Edit_colors(){
 window:=[]
 window[1]:={name:"Edit Colors",position:"w500 h500",number:87}
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
 gui,87:show
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
 87GuiSize:
 ControlMove,Scintilla1,,,%A_GuiWidth%,%A_GuiHeight%,% var("edit colors")
 var("tempw",A_GuiWidth),var("temph",A_GuiHeight)
 size()
 return
 87guiescape:
 gui,87:hide
 savepos()
 return
 colormenu:
 name:=clean(a_thismenuitem)
 if name=syntax_font
 return global_font(38)
 if name=matching_brace
 return changecolor(34)
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
changecolor(c=""){
 Defaultcolor:=option().selectsinglenode("//font/*[@style='5']").selectsinglenode("@color").text
 Defaultcolor:=Defaultcolor?Defaultcolor:0xFFFFFF
 defaults:={34:0xff0000,6:255,7:16744576,8:999999}
 style:=c?c:sc(2010,sc(2008))
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
87menu(){
 menu,list,add,Background Color,colormenu
 menu,list,add,Line Numbers Background,colormenu
 menu,list,add,Syntax Font,colormenu
 menu,list,add,Word Wrap Markers,colormenu
 menu,list,add,Line Numbers Background,colormenu
 menu,list,add,Matching Brace,colormenu
 menu,other,add,Other Colors,:list
 gui,87:menu,other
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
 if A_GuiEvent=k
 savesettings()
 return
 changetab:
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
new_segment(segment=""){
 nodes:=var("files")
 node:=nodes.selectsinglenode("//*[@window='" sc(2357) "']../File"),main:=node.selectsinglenode("..")
 mainfile:=main.selectsinglenode("@main").text
 splitpath,mainfile,,dir
 if !segment
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
context(){
 static lasttip
 if !option().selectsinglenode("//Context_Sensitive_Help").text
 return
 code:=substr(getline(),1,sc(2129,sc(2008))+1)
 line:=sc(2166,sc(2008)),home:=sc(2128,line),current:=sc(2008),out:=gettext(var(1))
 while current>home,current--
 {
  start:=sc(2266,current,1),end:=sc(2267,current,1),word:=substr(out,start+1,length:=abs(end-start))
  if sc(2007,current)=41
  {
   current:=sc(2353,current)=-1?current-1:sc(2266,sc(2353,current))
   continue
  }
  tooltip,,0,0,3
  if word
  if InStr(var("c")," " word " "){
   RegExMatch(var("c"),"i)" word,found)
   context:=var("commands").selectsinglenode("//*[text()='" found "']").selectsinglenode("@syntax").text
   if !context
   continue
   if (sc(2102)=0)
   sc(2200,sc(2008),word context)
   if sc(2007,subs:=sc(2267,current,1))=40
   function:=substr(gettext(var(1)),subs+2,nu:=abs(sc(2008)-subs-1)>=0?abs(sc(2008)-subs-1):0),fun:=1
   else
   function:=code
   line:=RegExReplace(RegExReplace(function,"U)" chr(34) ".*" chr(34)),"\(.*\)")
   RegExReplace(line,",",",",Count)
   tts:=(fun=1 && count=0)?instr(word context,"(",1):InStr(word context,",",0,1,count)+1
   tte:=InStr(word context,",",0,1,count+1)
   tte:=tte?tte:StrLen(word context)
   sc(2204,tts,tte)
   lasttip:=word
   return
  }
  current:=start
 }
 sc(2201)
}
getline(){
 line:=sc(2166,sc(2008)),home:=sc(2128,line),end:=sc(2136,line),home:=!home?1:home
 return, SubStr(gettext(var(1)),home,abs(end-home+1))
}
ideas(){
 window:=[]
 window[1]:={name:"Ideas",position:"w300 h300",number:15}
 window[2]:={1:"Edit,x0 y0 gideas videas Multi"}
 window(window)
 root:=var("files").selectsinglenode("//*[@window='" sc(2357) "']../@main").text
 last:=option().selectsinglenode("//file_information[@main='" root "']").SelectSingleNode("ideas")
 ControlSetText,Edit1,% last.text
 return
 15guisize:
 ControlMove,Edit1,,,% A_GuiWidth,% A_GuiHeight
 size()
 return
 15GuiEscape:
 15GuiClose:
 savepos()
 Gui,15:Hide
 return
 ideas:
 main:=var("files").selectsinglenode("//*[@window='" sc(2357) "']../@main").Text
 last:=option().selectsinglenode("//file_information[@main='" main "']")
 if !info:=last.SelectSingleNode("ideas")
 info:=option().CreateElement("ideas"),last.AppendChild(info)
 info.Text:=window(0,15,"ideas")
 return
}
close(){
 save()
 root:=var("files")
 close:=root.SelectNodes("//*[@window!='']")
 while,window:=close.item[A_Index-1].SelectSingleNode("@window").Text
 sc(2377,,window)
 lastopen:=option().SelectSingleNode("//lastopen/file")
 replace:=root.selectsinglenode("//*[@window='" sc(2357) "']..").SelectSingleNode("@main").Text
 l:=lastopen.text
 StringReplace,l,l,%replace%,,All
 StringReplace,l,l,||,|,All
 l:=trim(l,"|")
 lastopen.Text:=l
 autoopen(l,1)
 StringSplit,file,l,|
 tab:=root.SelectSingleNode("//*[@main='" file1 "']").SelectSingleNode("@tab").text
 tabselection(tab)
}
insert_function(){
 InputBox,name,Function name,Input the name of the function
 if (ErrorLevel || name="")
 return
 InputBox,options,Function Options,Input the options for this function (eg. function(*this information) )
 if ErrorLevel
 return
 sc(2003,sc(2008),clean(name) "(" options "){`n`n}"),fix_indent()
 send,{down}{right}
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
upload(){
 root:=var("files").selectsinglenode("//*[@window='" sc(2357) "']../@main").text
 SplitPath,root,,,,dir
 info:=option().selectsinglenode("//file_information[@main='" root "']"),main:=option(),var("rootname",info)
 if !version:=info.SelectSingleNode("version")
 version:=main.createelement("version"),info.appendchild(version)
 if !ver:=version.SelectSingleNode("@version")
 ver:=version.SetAttribute("version",0.0)
 ver:=ver.Text?ver.Text:0.0,ver.Text:=ver
 if !updir:=version.SelectSingleNode("@uploaddir")
 updir:=version.SetAttribute("uploaddir",dir)
 uploaddir:=updir.text,info:=version.Text
 newline=`r`n
 if !InStr(info,ver(ver))
 info:=ver(ver) newline info
 window:=[]
 window[1]:={name:"Version Information",position:"w500 h800",number:13}
 window[2]:={1:"edit,x0 y0 w400 vversion," ver(ver),2:"edit,r2 vversion_information," info,3:"text,,Upload directory",4:"edit,vuploaddir," uploaddir,5:"button,guploadscript vup,Upload your script"}
 window(window)
 ControlFocus,Edit2
 Send,!{Home}{Down}{Enter}{up}
 return
 13GuiSize:
 ControlMove,Edit1,,,A_GuiWidth,,%win%
 ControlGetPos,,y,,h,Edit1,%win%
 ControlGetPos,,ye,,he,Edit3,%win%
 ControlGetPos,,yb,,hb,Button1,%win%
 ControlGetPos,,,w1,h1,Static1,%win%
 subtract:=he+hb+h
 ControlMove,Edit2,,% y+h,% A_GuiWidth,% A_GuiHeight-subtract
 controlgetpos,,y2,,h2,Edit2,%win%
 half:=floor((he-h1)/2)
 ControlMove,Static1,,% y+h+h2+half
 ControlMove,Edit3,% w1+10,% y+h+h2,% A_GuiWidth-w1-2
 ControlMove,Button1,,% y+h+h2+he,% A_GuiWidth
 width:=A_GuiWidth,height:=A_GuiHeight
 size()
 return
 uploadscript:
 root:=var("rootname")
 ver:=root.SelectSingleNode("version/@version"),ver.text:=window(0,13,"version")
 FileDelete,version.txt
 FileAppend,% window(0,13,"version_information"),version.txt
 info:=root.SelectSingleNode("version"),info.text:=window(0,13,"version_information")
 info.SetAttribute("uploaddir",window(0,13,"uploaddir"))
 FileDelete,ftpfile.ftp
 FileAppend,% publish(1),ftpfile.ftp
 root:=var("files").selectsinglenode("//*[@window='" sc(2357) "']..").selectsinglenode("@main").text
 SplitPath,root,filename,dir,,name
 name:=window(0,13,"uploaddir")?window(0,13,"uploaddir"):name
 username:=option().selectsinglenode("//Ftp/Username").text
 Password:=option().selectsinglenode("//Ftp/Password").text
 server:=option().selectsinglenode("//Ftp/Server").text
 if !ftpopen(server,21,username,Password)
 goto ftperror
 FtpCreateDirectory(name)
 FtpPutFile("ftpfile.ftp",name "/" filename)
 FtpPutFile("version.txt",name "/version.txt")
 if size:=ftpgetfilesize(name "/" filename)
 goto ftpclose
 ftperror:
 msgbox Something went wrong.  Please check your settings and try again.
 return
 ftpclose:
 ftpclose()
 msgbox %size% transferred.
 compile()
 Gui,13:Hide
 return
 13GuiClose:
 13GuiEscape:
 root:=var("rootname")
 info:=root.SelectSingleNode("version"),info.text:=window(0,13,"version_information")
 info.SetAttribute("uploaddir",window(0,13,"uploaddir"))
 Gui,13:Hide
 return
}
run(){
 save()
 root:=var("files").selectsinglenode("//*[@window='" sc(2357) "']..")
 main:=root.selectsinglenode("@main").text
 debug:=option().SelectSingleNode("//Debug").text
 if debug
 {
  if debug(main)
  run,%main%
 }
 else
 run,%main%
} 
exit(){
 GuiClose:
 savepos()
 save()
 ExitApp
 return
} 
open_folder(){
 root:=var("files").selectsinglenode("//*[@window='" sc(2357) "']..")
 main:=root.selectsinglenode("@main").text
 SplitPath,main,,dir
 run,%dir%
}
open(filename=""){
 save()
 if !file
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
 StringSplit,file,files,|
 tab:=var("files").SelectSingleNode("//*[@main='" file1 "']").SelectSingleNode("@tab").text
 tabselection(tab)
 
 return
} 
/*
format and display the files.xml
xmldoc:=var("files")
xsl:=style()
xmldoc.transformNodeToObject(xsl,xmldoc)	;Apply the Style Sheet
msgbox % xmldoc.xml
*/
debug(lastopen=0){
 ;if (lastopen=0 || lastopen=A_ScriptFullPath || lastopen="" || lastopen=1)
 if lastopen in 0,1,"",%A_ScriptFullPath%
 return 1
 debug:
 ToolTip
 settimer,debug,Off
 save()
 for process in ComObjGet("winmgmts:").ExecQuery("Select * from Win32_Process")
 if InStr(process.CommandLine,lastopen){
  IfWinExist,% "ahk_pid " process.ProcessId
  WinKill,% "ahk_pid " process.ProcessId
  Process,Close,% process.processid
 }
 SplitPath,lastopen,,dir
 path:=A_AhkPath
 file=%dir%\debug.bat
 dfile=%dir%\debug.dbg
 filedelete,%dfile%
 filedelete,%file%
 fileappend,`"%a_ahkpath%`" /ErrorStdOut `"%lastopen%`" > debug.dbg 2>&1,%file%
 runwait,"%file%",%dir%,hide
 FileRead,debug,%dfile%
 if debug
 {
  file1:=SubStr(debug,1,out:=InStr(debug,"(")-2)
  line:=SubStr(debug,out+3,instr(debug,")")-out-3)
  RegExMatch(debug,"i)Specifically:(.*)",out)
  out:=substr(out,15)
  select(file1)
  tooltip,%debug%
  sc:=var(1)
  sc(2024,line-1)
  sc(2190, sc(2008))
  sc(2192,sc(2006))
  start:=sc(2197,strlen(out),out)
  Sc(2160,start,start+strlen(out))
 }
 return 0
}
fold(){
 ControlGetPos,xx,yy,,,Scintilla1,% var("script writer")
 MouseGetPos,x,y
 x:=x-xx,y:=y-yy
 v:=var("f",f)
 line:=sc(2166,Sc(2022,x,y))
 if sc(2223,line) < 9000
 return
 sc(2231,line)
}
statusbar(x){
 static settext:=[]
 sizes:=[]
 settext[x.2]:=x.1
 Gui,1:Default
 size:=option().SelectSingleNode("//font/style[@style='5']").SelectSingleNode("@size").Text
 for a,b in settext
 sizes[a]:=StrLen(x.1)*size
 SB_SetParts(sizes[1],sizes[2],sizes[3])
 SB_SetText(x.1,x.2)
}
variables(x=0){
 visible:=option().SelectSingleNode("//position/position[@position='Variables']"),vis:=Visible.SelectSingleNode("@visible").text
 if (!var("variables")&&(vis=1 || x=0)){
  window:=[]
  window[1]:={name:"Variables",position:"w400 h500",number:9}
  window[2]:={1:"Listview,x0 y0 w300 -Multi -ReadOnly AltSubmit gvariablesedit r10,Variables",2:"Edit",3:"Button,gaddvar Default,Add Variable"}
  window(window) 
  Visible.SetAttribute("visible",1)
  WinActivate,% var("script writer")
  populatevariables()
  return
 }
 if x=1
 return
 WinGet,style,Style,% var("Variables")
 if Style=0x94CF0000
 {
  Visible.SetAttribute("visible",0)
  Gui,9:Hide
 }
 else
 {
  Visible.SetAttribute("visible",1)
  Gui,9:Show
 }
 WinActivate,% var("script writer")
 return
 9GuiSize:
 SysGet,Caption,4
 SysGet,Border,8
 ControlGetPos,,,,eh,Edit1
 ControlGetPos,,sy,,,SysListView321
 ControlMove,Button1,,% A_GuiHeight-Caption+Border,% A_GuiWidth
 ControlGetPos,,y,,,Button1
 ControlMove,Edit1,,% y-eh,% A_GuiWidth
 ControlGetPos,,y,,,Edit1
 ControlMove,SysListView321,,,% A_GuiWidth,% y-sy
 size()
 return
 9guiclose:
 9guiescape:
 Gui,9:Hide
 Visible:=option().SelectSingleNode("//position/position[@position='Variables']")
 Visible.SetAttribute("visible",0)
 return
 addvar:
 Gui,9:Default
 ControlGetText,Edit,Edit1,% var("variables")
 LV_Add("",regexreplace(Edit,"i)(?:[^a-z0-9_]|\& )",""))
 updatevars()
 GuiControl,,Edit1
 return
 variablesedit:
 Gui,9:Default
 if (A_EventInfo=8||A_EventInfo=46){
  LV_Delete(LV_GetNext())
  updatevars()
 }
 return
}
add_variable(){
 if !var("variables")
 variables()
 Gui,9:Show
 ControlFocus,Edit1,% var("variables")
}
populatevariables(){
 static lastmain
 Gui,9:Default
 LV_Delete()
 main:=var("files").SelectSingleNode("//*[@window='" sc(2357) "']../@main").Text
 if main=lastmain
 return
 variables:=option().selectsinglenode("//file_information[@main='" main "']").selectsinglenode("variables")
 v:=variables.text,var("customvarlist",v)
 Loop,Parse,v,|
 LV_Add("",A_LoopField)
 LV_Modify(variables.SelectSingleNode("@lastvar").Text,"Select Focus")
 LV_GetText(var,LV_GetNext())
 statusbar({1:"Current Variable: " var,2:3})
 lastmain:=main
}
updatevars(){
 root:=var("files").selectsinglenode("//*[@window='" sc(2357) "']..").selectsinglenode("@main").text
 xml:=option(),root:=xml.selectsinglenode("//file_information[@main='" root "']")
 if !variables:=root.SelectSingleNode("variables")
 variables:=xml.createelement("variables"),root.appendchild(variables)
 while,A_Index<=LV_GetCount(),LV_GetText(var,A_Index)
 vars.=var "|"
 variables.text:=trim(vars,"|")
 populatevariables()
}
lastvar(){
 main:=var("files").SelectSingleNode("//*[@window='" sc(2357) "']../@main").Text
 variables:=option().selectsinglenode("//file_information[@main='" main "']").selectsinglenode("variables")
 Gui,9:Default
 variables.SetAttribute("lastvar",LV_GetNext())
}
previous_variable(){
 Gui,9:Default
 if LV_GetNext()>1
 LV_Modify(LV_GetNext()-1,"Select Focus")
 LV_GetText(var,LV_GetNext())
 statusbar({1:"Current Variable: " var,2:3})
}
next_variable(){
 Gui,9:Default
 if LV_GetNext()<LV_GetCount()
 LV_Modify(LV_GetNext()+1,"Select Focus") 
 LV_GetText(var,LV_GetNext())
 statusbar({1:"Current Variable: " var,2:3})
}
remove_current_segment(){
 nodes:=var("files")
 main:=nodes.selectsinglenode("//*[@window='" sc(2357) "']..")
 node:=nodes.selectsinglenode("//*[@window='" sc(2357) "']../File")
 window:=node.selectsinglenode("@window").text
 if (window=sc(2357)){
  MsgBox,Can not remove the main project.
  return
 }
 if window && window != sc(2357)
 sc(2377,window),node.setattribute("window","")
 remove:=update(node.selectsinglenode("@file").text) "`r`n"
 current:=nodes.selectsinglenode("//*[@window='" sc(2357) "']").SelectSingleNode("@file").Text
 SplitPath,current,filename
 MsgBox,4,Are you sure?,Remove %current% from the current project?
 IfMsgBox,no
 return
 MsgBox,4,Delete the file from your computer?,Also delete the file?
 IfMsgBox,Yes
 FileDelete,%current%
 RegExMatch(remove,"(.*" filename ")",out)
 remove:=RegExReplace(remove,out "`r`n")
 update(node.selectsinglenode("@file").text,remove)
 Gui,2:Default
 TV_Delete(TV_GetSelection())
 current:=nodes.selectsinglenode("//*[@window='" sc(2357) "']")
 main.removechild(current)
 sc(2377,,sc(2357))
 select(node.selectsinglenode("@file").text)
}
drop(){
 GuiDropFiles:
 open:=""
 list:=trim(option().selectsinglenode("//lastopen/file").text,"|")
 Loop,Parse,A_GuiEvent,`n
 {
  if !InStr(list,A_LoopField)
  if !var("files").SelectSingleNode("//*[@file='" A_LoopField "']").xml
  list.="|" A_LoopField,open.=A_LoopField "|"
 }
 option(o:={1:"lastopen",2:"file"},f:={file:"file"},trim(list,"|"))
 if InStr(A_GuiEvent,"`n")
 return autoopen(RegExReplace(open,"`n","|"))
 if open
 autoopen(open)
 return
}
edit_replacements(){
 window:=[]
 window[1]:={name:"Replacements",position:"w400 h700",number:11}
 window[2]:={1:"ListView,x0 y0 h500 AltSubmit gpoprep Grid,Replacement Input|Replacement Text",2:"Text,,Replacement Input",3:"Edit,w200 x+10 vin",4:"Text,x0,Replacement Text",5:"Edit,w200 x+10 vout",6:"Button,x0 greplacement Default,Add Replacement"}
 er:=window(window)
 Gui,11:Default
 for b,c in rep()
 LV_Add("",b,c)
 ControlGetPos,x,y,w,h,SysListView321,ahk_id %er%
 Gui,11:Show,% "w" w
 WinActivate,% var("replacements")
 return
 11GuiEscape:
 11:GuiClose:
 Gui,11:Hide
 return
 replacement:
 Gui,11:Default
 in:=window(0,11,"in"),out:=window(0,11,"out")
 StringLower,in,in
 if !in || !out
 return
 if rep:=option().SelectSingleNode("//replacements/*[@replace='" in "']"){
  rep.text:=out
  while,A_Index<=LV_GetCount(),LV_GetText(line,A_Index)
  if line=%in%
  LV_Modify(A_Index,"",in,out)
 }
 else
 {
  root:=option(),main:=root.SelectSingleNode("//Options")
  if !rep:=option().SelectSingleNode("//replacements")
  rep:=root.CreateElement("replacements"),main.AppendChild(rep)
  replace:=root.CreateElement("replacement")
  replace.setattribute("replace",in),replace.text:=out,rep.appendchild(replace)
  LV_Add("",in,out)
 }
 rep()
 GuiControl,,Edit1
 GuiControl,,Edit2
 ControlFocus,Edit1
 return
 poprep:
 if (A_GuiEvent="k" && (A_EventInfo=8||A_EventInfo=46)){
  LV_GetText(in,LV_GetNext())
  root:=option().SelectSingleNode("//replacements")
  rep:=option().SelectSingleNode("//replacements/*[@replace='" in "']")
  root.removechild(rep)
  LV_Delete(LV_GetNext())
  return
 }
 if A_GuiEvent!=Normal
 return
 LV_GetText(in,LV_GetNext()),LV_GetText(out,LV_GetNext(),2)
 GuiControl,,Edit1,%in%
 GuiControl,,Edit2,%out%
 return
}
rep(cword="",cpos=""){
 static
 if !IsObject(replacement) || (cword=""&&cpos=""){
  rep:=option().SelectNodes("//replacements/*"),replacement:=Object()
  while,r:=rep.item[A_Index-1]
  replacement[r.SelectSingleNode("@replace").Text]:=r.text
  if (cword=""&&cpos="")
  return replacement
 }
 cpos-=1
 start:=sc(2266,cpos,1),end:=sc(2267,cpos,1),out:=gettext(var(1)),word:=substr(out,start+1,length:=abs(end-start))
 if replacement[word]
 {
  sc(2160,start,cpos),sc(2170,0,replacement[word])
  send,{Right}
 }
}
character_count(){
 if sc(2161)>1
 msgbox % sc(2161)-1
 else
 MsgBox % sc(2183)
}
replace_text(){
 window:=[]
 window[1]:={name:"Replace Text",position:"w400 h500",number:77}
 window[2]:={1:"text,x0,Find text:",2:"edit,vfind x+5 w150",3:"text,x0,Replace with:",4:"edit,vreplace x+5 w150",5:"button,ggh vfindandreplace default x0,Find and Replace"}
 window(window)
 return
 77GuiEscape:
 77GuiClose:
 Gui,77:Hide
 return
 77GuiSize:
 ControlGetPos,1x,,,,Edit1
 ControlGetPos,2x,,,,Edit2
 ControlMove,Edit1,,,% A_GuiWidth-1x+5
 ControlMove,Edit2,,,% A_GuiWidth-2x+5
 size()
 return
}
findandreplace(){
 find:=window(0,77,"find"),replace:=window(0,77,"replace")
 if !find
 return
 root:=var("files").selectsinglenode("//*[@window='" sc(2357) "']..")
 files:=root.SelectNodes("*/@file"),found=0
 while,file:=files.item[A_Index-1].Text
 if InStr(update(file),find){
  loop,
  {
   select(file)
   sc(2190,found)
   sc(2192,sc(2006))
   start:=sc(2197,strlen(find),find)
   sc(2160,start,start+strlen(find))
   if start=-1
   {
    found=0
    break
   }
   msgbox,35,Text Found.,Replace this occurence,0
   controlfocus,Scintilla1,% var("script writer")
   ifmsgbox,yes
   {
    sc(2170,,replace)
    update()
   }
   ifmsgbox,cancel
   {
    Gui,77:Hide
    exit
   }
   found:=sc(2008)+1
  }
 }
}
version(){
 SplashTextOn,200,100,Please Wait,Downloading Version Information.
 urldownloadtofile,http://www.autohotkey.net/~maestrith/Script Writer/version.txt,update.html
 SplashTextOff
 window:=[]
 window[1]:={name:"Current Version",position:"w400 h500",number:12}
 window[2]:={1:"Edit,x0 y0 w500 h600"}
 window(window)
 FileRead,version,update.html
 ControlSetText,Edit1,%version%
 send,^{home}
 Gui,12:Show,,% "Version=" gui("version")
 return
 12GuiSize:
 ControlMove,Edit1,,,%A_GuiWidth%,%A_GuiHeight%
 size()
 return
}
ver(ver){
 return substr(ver,1,instr(ver,".",0,0))(substr(ver,(instr(ver,".",0,0)+1))+1)
}
;original code from olfen http://www.autohotkey.com/forum/viewtopic.php?t=10393&highlight=ftp+com
FtpOpen(Server,Port=21,Username=0,Password=0){
 static serverinfo:=[]
 if server between 1 and 3
 return serverinfo[server]
 username:=username ? username : "anonymous",password:=password ? password : "anonymous"
 hModule:=DllCall("LoadLibrary","str","wininet.dll")
 io_hInternet:=DllCall("wininet\InternetOpen","str",A_ScriptName,"UInt",AccessType,"int","","int","",UInt,0)
 If(ErrorLevel!=0 or io_hInternet=0){
  return FtpClose()
 }
 ic_hInternet:=DllCall("wininet\InternetConnect","uint",io_hInternet,"str",Server,"uint",Port,"str",Username,"str",Password,"uint",1,"uint",0,"uint",0),serverinfo:={1:ic_hinternet,2:io_hinternet,3:hmodule}
 return out:=(ErrorLevel!=0 or ic_hInternet=0) ? 0 : 1
}
FtpClose(x=0){
 DllCall("wininet\InternetCloseHandle","UInt",ftpopen(1)),DllCall("wininet\InternetCloseHandle","UInt",ftpopen(2)),DllCall("FreeLibrary","UInt",ftpopen(3))
}
FtpGetFileSize(FileName){
 fof_hInternet:=DllCall("wininet\FtpOpenFile","uint",ftpopen(1),"str",FileName,"uint",0x80000000,"uint",Flags,"uint",0)
 If (ErrorLevel!= 0 or fof_hInternet = 0)
 return 0
 FileSize := DllCall("wininet\FtpGetFileSize","uint",fof_hInternet,"uint",0)
 DllCall("wininet\InternetCloseHandle","UInt",fof_hInternet)
 return,FileSize
}
FtpPutFile(LocalFile,NewRemoteFile="",Flags=0){
 newremotefile:=newremotefile ? newremotefile : localfile
 r:=DllCall("wininet\FtpPutFile","uint",ftpopen(1),"str",LocalFile,"str",NewRemoteFile,"uint",Flags,"uint",0)
 return out:=(ErrorLevel != 0 or r = 0) ? 0 : 1
}
FtpCreateDirectory(DirName){
 r := DllCall("wininet\FtpCreateDirectory","uint",ftpopen(1),"str",DirName)
 return out:=(ErrorLevel != 0 or r = 0) ? 0 : 1
}
;------------------------------------------Thanks olfen :)------------------------------
create_segment_from_selection(){
 node:=var("files").selectsinglenode("//*[@window='" sc(2357) "']../@main").text
 SplitPath,node,dir
 InputBox,segment,Please input a name,Please name the new segment.
 if ErrorLevel||segment=""
 return
 IfExist,%dir%\%segment%
 {
  MsgBox, file exists.  Please choose another
  create_segment_from_selection()
 }
 oldclip:=Clipboard
 sc(2177)
 new_segment(segment)
 sc(2181,,Clipboard)
 Clipboard:=oldclip
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
 8guisize:
 size()
 return
}
import(x=0,name=0){
 file:=x
 if !(File){
  MsgBox,This process does not always work on every script.  Please open it normally and use Create Segment from Selection if it does not.
  FileSelectFile,file,,,Select a file to import,*.ahk
  if ErrorLevel
  return
  SplitPath,file,,,,noext
  name:=noext
  IfExist,projects\%noext%
  msgbox,3,Project Already Exists,Delete?`nYes: Delete and create a new project`nNo: Rename project`nCancel: Abort
  IfMsgBox,Yes
  FileRemoveDir,projects\%noext%,1
  IfMsgBox,No
  FileMoveDir,projects\%noext%,projects\%noext%-%a_now%,1
  IfMsgBox,Cancel
  return
 }
 fileread,script,%file%
 loop,parse,script,`n,`r
 {
  if (RegExMatch(A_LoopField,"(.*\(.*\).*{)",fun) && substr(a_loopfield,0)="{")
  start=1
  if !start
  everything.=a_loopfield "`n"
  if start
  {
   stringsplit,out,a_loopfield,;
   out:=trim(out1)
   if SubStr(out,0) = "{"
   indent++
   if out = `}
   indent--
   program.=a_loopfield "`n"
   if indent=0
   {
    prognum++
    final%prognum%:=program
    program=
    start=
   }
  }
 }
 dir=%A_ScriptDir%\projects\%name%
 fileremovedir,%dir%,1
 filecreatedir,%dir%
 loop,%prognum%
 fileappend,% trim(final%a_index%,"`r`n"),% dir "\" substr(final%a_index%,1,instr(final%a_index%,"(")-1)
 loop,%dir%\*.
 list.=a_loopfilename ","
 fileappend,%everything%,%dir%\%name%
 include:=chr(35) "include"
 fileappend,%include% %name%`n,%dir%\%name%.ahk
 loop,parse,list,`,
 if a_loopfield
 fileappend,%include% %a_loopfield%`n,%dir%\%name%.ahk
 autoopen(dir "\" name ".ahk")
}
export(){
 FileSelectFile,export,S 16,,Export file as?,AHK (*.ahk)
 export:=!InStr(export,".ahk")?export ".ahk":export
 filedelete,% export
 FileAppend,% publish(1),% export
}
edit_highlight_text(){
 window:=[]
 window[1]:={name:"Edit Highlight Text",position:"w800 h500",number:14}
 window[2]:={1:"Text,x0 y0,Highlight lists are separated by a single space. (each word one space)",2:"ListView,x0 w300 h500 AltSubmit ghighlight,List",3:"Edit,x+5 gupdatelist w495 h500"}
 window(window)
 Gui,14:Default
 loop,3
 LV_Add("","Keyword List " A_Index+3)
 LV_Modify(1,"select Focus")
 return
 14guiclose:
 14guiescape:
 Gui,14:Hide
 keywords(98),savepos()
 return
 14guisize:
 ControlGetPos,x,y,w,,SysListView321
 ControlMove,SysListView321,,,,% A_GuiHeight-y
 ControlMove,Edit1,,,% A_GuiWidth-w-5,% A_GuiHeight-y
 size()
 return
 highlight:
 if A_GuiEvent not in normal,i
 return
 LV_GetText(list,LV_GetNext())
 if !key:=option().SelectSingleNode("//keywords/" clean(list))
 key:=option({1:"keywords",2:clean(list)})
 ControlSetText,Edit1,% key.text
 return
 updatelist:
 LV_GetText(list,LV_GetNext())
 ControlGetText,text,Edit1
 key:=option({1:"keywords",2:clean(list)},,text)
 return
}
about(){
 window:=[]
 window[1]:={name:"About",position:"w500 h500",number:16}
 window[2]:={1:"Edit,x0 y0 w500 h500"}
 window(window)
 about=
 (
 I will have more here in the future`r`nI would like to thank everyone in the community that is doing something to promote Autohotkey, developing for it, and sharing their code freely so that we can all learn from them.
 License for Scintilla and SciTE 
 Copyright 1998-2002 by Neil Hodgson <neilh@scintilla.org>
 All Rights Reserved:
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
 ControlSetText,Edit1,%about%
 return
 16GuiSize:
 ControlMove,Edit1,,,% A_GuiWidth,% A_GuiHeight
 size()
 return
 16GuiEscape:
 16GuiClose:
 Gui,16:Hide
 savepos()
 return
}
help(){
 Run,http://code.google.com/p/script-writer/
}
compile(){
 save()
 msgbox,36,Compile Script,Would you like to compile and upload your script?,0
 IfMsgBox,no
 return
 SplitPath,A_AhkPath,,dir
 compiler=%dir%\compiler\ahk2exe.exe
 IfnotExist,%compiler%
 {
  MsgBox,Can not find compiler.  Please install Autohotkey again.
  return
 }
 root:=var("files").selectsinglenode("//*[@window='" sc(2357) "']..")
 main:=root.selectsinglenode("@main").text
 SplitPath,main,file,updir,,noext
 splashtexton,300,50,Compiling Script,Please wait
 RunWait,ahk2exe.exe /in "%a_scriptdir%\ftpfile.ftp" /out "%updir%\%noext%.exe" /mpress 1,%dir%\compiler\
 SplashTextOff
 username:=option().selectsinglenode("//Ftp/Username").text
 Password:=option().selectsinglenode("//Ftp/Password").text
 server:=option().selectsinglenode("//Ftp/Server").text
 directory:=option().selectsinglenode("//file_information[@main='" main "']").selectsinglenode("version/@uploaddir").text
 if !ftpopen(server,21,username,password)
 goto oops
 FtpCreateDirectory("/" directory)
 SplashTextOn,200,30,Uploading %noext%.exe,Please Wait
 if !ftpputfile(updir "\" noext ".exe",directory "/" noext ".exe")
 goto oops
 if !size:=ftpgetfilesize(directory "/" noext ".exe")
 goto oops
 SplashTextOff
 msgbox % "Uploaded " SIZE " bytes"
 ftpclose()
 return
 oops:
 SplashTextOff
 msgbox Check your settings and try again.`nAutohotkey.net has changed usernames from username to username@autohotkey.net
 ftpclose()
}
auto_update(){
 save()
 splitpath,a_scriptname,,,,filename
 version:=gui("version"),ext:=if A_IsCompiled?".exe":".ahk"
 filemove,%a_scriptname%,backup_%version%_%a_scriptname%,1
 SplashTextOn,500,200,Please Wait,Downloading the new version.  This could take a minute
 urldownloadtofile,http://www.autohotkey.net/~maestrith/Script Writer/Script Writer%ext%,%a_scriptname%
 reload
}
