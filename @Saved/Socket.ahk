#SingleInstance,Force
v:=[]
global v
gui()
strsplit(data,delim,omit=""){
	stringsplit,data,data,%delim%,%omit%
	list:=[]
	loop,% data0
	list.insert(data%a_index%)
	return list
}
log(a,b=""){
	return
}
return
GuiClose:
ExitApp
return
RecvFrom(socket, byref out_ip, byref out_port, byref message){
	static MSG_PEEK := 2, MSG_OOB := 1, MSG_WAITALL := 8
	Ptr := (A_PtrSize) ? "uptr" : "uint"
	fl := 0
	while !size:=MessageSize(socket)
	sleep, 100
	if !len
	len:=size
	VarSetCapacity(buffer, len)
	if (GetSocketInfo(socket,af,maxsockaddr,minsockaddr,type,protocol)!=0)
	return 0
	VarSetCapacity(sockaddr,maxsockaddr,0)
	result:=DllCall("ws2_32\recv", Ptr, socket, Ptr, &buffer, "int",len, "int", fl, Ptr, &sockaddr, "int", maxsockaddr)
	message:=StrGet(&buffer,result,"UTF-8")
	return result
}
GetAddrInfo(socket, hostname_or_ip, port, byref sockaddr, byref sockaddrlen){
	static AF_INET := 2, AF_INET6 := 23
	static ADDR_ANY := 0xFFFFFFFF, ADDR_NONE := 0
	static addr
	sPtr:=(A_PtrSize)?A_PtrSize:4
	Ptr:=(A_PtrSize)?"uptr":"uint"
	AStr:=(A_IsUnicode)?"astr":"str"
	if GetSocketInfo(socket,af,maxsockaddr,minsockaddr,type,protocol)
	return
	VarSetCapacity(hints,20+(3*sPtr),0)
	NumPut(af,hints,4,"int")
	NumPut(type,hints,8,"int")
	NumPut(protocol,hints,12,"int")
	if DllCall("ws2_32\getaddrinfo",AStr,hostname_or_ip,AStr,port,Ptr,&hints,Ptr "*",result)
	return
	sockaddrlen := NumGet(result+0, 16, "int")
	sockaddr := NumGet(result+0, 16+(2*sPtr), Ptr)
	if (af=AF_INET)
	ip := NumGet(sockaddr+0, 4, "uchar") "." NumGet(sockaddr+0, 5, "uchar") "." NumGet(sockaddr+0, 6, "uchar") "." NumGet(sockaddr+0, 7, "uchar")
	return 1
}
GetSocketInfo(socket, byref af, byref maxsockaddr, byref minsockaddr, byref type, byref protocol){
	static SOL_SOCKET := 0xFFFF
	static SO_PROTOCOL_INFOA := 0x2004
	sPtr := (A_PtrSize) ? A_PtrSize : 4
	Ptr := (A_PtrSize) ? "uptr" : "uint"
	size := 1024
	VarSetCapacity(protocol_info, size, 0)
	VarSetCapacity(psize, 4, 0)
	NumPut(size, psize)
	result := DllCall("ws2_32\getsockopt", Ptr, socket, "int", SOL_SOCKET, "int", SO_PROTOCOL_INFOA, Ptr, &protocol_info, Ptr, &psize)
	offset := 76
	af := NumGet(protocol_info, offset, "int")
	maxsockaddr := NumGet(protocol_info, offset+4, "int")
	minsockaddr := NumGet(protocol_info, offset+8, "int")
	type := NumGet(protocol_info, offset+12, "int")
	protocol := NumGet(protocol_info, offset+16, "int")
	return result
}
class socket{
	__New(version=2.0){
		DllCall("LoadLibrary","str","ws2_32","uPtr")
		VarSetCapacity(WSAData,7*A_PtrSize)
		if (instr(version, "."))
		{
			wVersionRequested:=(Substr(version,1,Instr(version,".")-1)&0xFF)
			wVersionRequested|=(Substr(version,Instr(version,".")+1)&0xFF)<<8
		}
		else
		wVersionRequested:=version&0xFF
		DllCall("ws2_32\WSAStartup","ushort",wVersionRequested,"uPtr",&WSAData,"int")
		v.this:=this
		this.socket()
	}
	Socket(protocol="TCP", ipversion="IPv4"){
		ss:=DllCall("ws2_32\socket","int",2,"int",1,"int",6,"uPtr")
		this.socket:=ss
		this.HandleEvents()
	}
	HandleEvents(){
		;static FD_READ:=1,FD_ACCEPT:=8,FD_CONNECT:=16,FD_CLOSE:=32
		static msg:=0x9987
		Ptr:=(A_PtrSize)?"uptr":"uint"
		fdevents:=1
		OnMessage(msg,"Proc")
		if DllCall("ws2_32\WSAAsyncSelect",Ptr,this.socket,"uPtr",hwnd(1),"uint",msg,"uint",fdevents)
		return m("[ERROR] Can't handle events")
	}
	Connect(ip,port){
		static AF_INET := 2, AF_INET6 := 23
		sPtr := (A_PtrSize) ? A_PtrSize : 4
		Ptr := (A_PtrSize) ? "uptr" : "uint"
		AStr := (A_IsUnicode) ? "astr" : "str"
		if !GetAddrInfo(this.socket,ip,port,sockaddr,sockaddrlen)
		return m("Can not get the socket information.")
		DllCall("ws2_32\WSAConnect",Ptr,this.socket,Ptr,sockaddr,int,sockaddrlen,Ptr,0,Ptr,0,Ptr,0,Ptr,0,"int")
	}
	Send(message){
		message.="`r`n"
		result:=DllCall("ws2_32\send","uPtr",this.socket,"AStr",message,"int",StrLen(message),"int",0,"int")
		if (result=-1)
		return m("[ERROR] Sending failed!")
		v.total.=message
		next(message)
	}
}
MessageSize(socket){
	ll.=a_thisfunc "`n"
	static FIONREAD := 0x4004667F
	Ptr := (A_PtrSize) ? "uptr" : "uint"
	VarSetCapacity(argp, 4, 0)
	if (DllCall("ws2_32\ioctlsocket", Ptr, socket, "uint", FIONREAD, Ptr, &argp)!=0)
	return 0
	return NumGet(argp, 0, "int")
}
onread(socket){
	recvfrom(socket,ip,port,message)
	v.total.=message
	v.message:=message
	return message
}
Proc(wParam,lParam,msg,hwnd){
	event:=lParam&0xFFFF
	error:=lParam>>16
	if (event=1){
		message:=onread(wParam)
		next(message)
	}
	return 1
}
next(message){
	ControlSetText,Edit1,% v.total,% hwnd([1])
	ControlSend,Edit1,^{End},% hwnd([1])
	Loop,Parse,message,`r`n,`r`n
	{
		in:=strsplit(A_LoopField," ")
		if (in.2=353){
			for a,b in in{
				b:=RegExReplace(b,"A):")
				RegExMatch(SubStr(b,1,1),"\W",prefix)
				if channel
				v.nicklist[channel,prefix,b]:=1
				if InStr(b,"#")
				channel:=b
			}
		}
		if (in.2=366){
			v.chan[in.4]:=1
			updatechan(in.4)
		}
		if (in.1="ping"){
			v.this.send("PONG " in.2)
			TrayTip,AHK_IRC,Just Pong'd,3
		}
		;if (SubStr(in.4,1,1)="#"){
		;d({l:1})
		;v.chan[in.4]:=1
		;updatechan()
		;}
		if (in.2="JOIN"){
			regexmatch(in.1,"A):(.+)!",new)
			v.nicklist[in.3,new1]:=1
			changechan()
		}
		
		;WORK ON THESE
		;ALSO ADD THE COLOR LISTVIEWS IF POSSIBLE.
		;:maestrith!~maestrith@cpe-76-188-92-52.neo.res.rr.com JOIN #maestrith1  ;when a user joins
		;:maestrith!~maestrith@cpe-76-188-92-52.neo.res.rr.com PRIVMSG #maestrith :testing ;when a user sends a msg to the chan
		;:maestrith!~maestrith@cpe-76-188-92-52.neo.res.rr.com PRIVMSG maestrith1 :hey ;private message note the lack of # and the username is yours
		;:maestrith1!~maestrith@cpe-76-188-92-52.neo.res.rr.com PART #maestrith ;user leaves
		;:ChanServ!ChanServ@services. MODE #maestrith +o maestrith1 ;give op
		;:ChanServ!ChanServ@services. MODE #maestrith -o maestrith1 ;lose op
		;:ChanServ!ChanServ@services. MODE #maestrith -v maestrith1 ;devoice
		;:ChanServ!ChanServ@services. NOTICE maestrith1 :You have been devoiced on #maestrith by maestrith ;notices should be a different color!
	}
	if !WinActive(hwnd([1]))
	if !RegExMatch(message,"Ai)ping")
	TrayTip,AHK IRC,%message%,3
	return
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
hwnd(win,hwnd=0){
	static windows:=[]
	if win&&hwnd
	return windows[win]:=hwnd
	if win.rem
	return windows[win.rem]:=0
	if win.1
	return "ahk_id" windows[win.1]
	return windows[win]
}
gui(){
	static
	DllCall("LoadLibrary","str","scilexer.dll")
	Gui,+hwndhwnd
	hwnd(1,hwnd)
	OnMessage(0x06,"Focus")
	Gui,Add,ListView,w150 r20 gg vchangechan AltSubmit,Channels
	Gui,Add,Edit,w700 r26 x+10
	Gui,Add,Edit,w500 vedit -WantReturn
	Gui,Add,Button,Default gsend x+10,Send
	sc:=new s(1,"w200 h360 ym x880")
	sc.2052(32,0)
	sc.2051(32,0xffffff)
	sc.2242(1,0)
	sc.2188(0)
	sc.2096(1)
	sc.2470(50)
	sc.2098(0xff00ff)
	sc.2050
	sc.2181(0,"stuff`nthings`shit")
	sc.2171(1),sc.2478(0)
	v.users:=sc
	Gui,Add,Button,xm gconnect,Connect
	Gui,Add,Button,x+10 gg vupdatechan,Update Channel List
	Gui,Add,Button,x+10 gjoinmaestrith,Join Maestrith
	Gui,Show
	ControlFocus,Edit2,% hwnd([1])
	return
	joinmaestrith:
	sock.send("JOIN #maestrith")
	return
	connect:
	username=maestrith1
	sock:=new socket()
	sock.connect("irc.freenode.net",6667)
	sleep,2000
	sock.Send("NICK " username)
	sleep,200
	sock.Send("USER " username " 0 * :" username)
	return
	send:
	ControlGetText,edit,Edit2,% hwnd([1])
	d({l:1}),LV_GetText(channel,LV_GetNext())
	StringSplit,edit,edit,%A_Space%
	info:=strsplit(edit," ")
	;#sjc_bot
	;add /msg whois....hell look at the site with the irc commands and add em
	if (info.1="/quit"||info.1="/q")
	mm:="QUIT :" compile(info)
	else if (info.1="/n"||info.1="/nickserv")
	mm:="PRIVMSG NICKSERV :" compile(info,1)
	else if (info.1="/raw"||info.1="/r")
	mm:=compile(info,1)
	else if (info.1="/msg"||info.1="/m")
	mm:="PRIVMSG " info.2 " :" compile(info)
	else if (info.1="/part")
	mm:="PART " out:=InStr(info.2,"#")?info.2:"#" info.2
	else if (info.1="/ns"||info.1="/nickserv")
	mm:="PRIVMSG nickserv :" compile(info,1)
	else if (info.1="/j"||info.1="/join")
	mm:="JOIN " out:=InStr(info.2,"#")?info.2:"#" info.2
	else
	mm:="PRIVMSG " channel " :" edit
	if mm
	sock.Send(mm)
	ControlSetText,Edit2,,% hwnd([1])
	return
	g:
	%A_GuiControl%()
	return
	
}
focus(){
	ControlFocus,Edit2,% hwnd([1])
}
compile(info,index=2){
	for a,b in info{
		if a_index>%index%
		nm.=b " "
	}
	return nm
}
d(info){
	win:=info.w?info.w:1
	type:=info.t?"TreeView":"ListView"
	control:=info.t?"SysTreeView32":"SysListView32"
	con:=info.t?info.t:info.l
	Gui,%win%:Default
	Gui,%win%:%type%,% control con
}
changechan(){
	d({l:1})
	LV_GetText(chan,LV_GetNext())
	;d({l:2}),LV_Delete(),
	count:=0,sc:=v.users
	sc.2171(0),sc.2004
	colors:=[0xff0000,0x00ff00,0x0000ff]
	for a,prefix in {1:"@",2:"+",3:""}{
		count++
		sc.2051(count,colors[A_Index])
		for user,b in v.nicklist[chan,prefix]{
			start:=sc.2006
			sc.2003(start,user "`n")
			sc.2032(start,0x1f)
			sc.2033(start+StrLen(user)+1,count)
		}
	}
	sc.2171(1)
	
	;LV_Add("",a)
}
updatechan(sel=""){
	d({l:1}),LV_Delete()
	for a,chan in v.chan{
		Select:=chan=sel?"Select Vis Focus":""
		LV_Add(Select,a)
	}
}
class s{
	static ctrl:=[],lc:=""
	__New(win=1,pos=""){
		static count=1
		Gui,%win%:Add,custom,classScintilla hwndsc %pos% +1387331584
		this.sc:=sc,s.ctrl[sc]:=this,t:=[]
		for a,b in {fn:2184,ptr:2185}
		this[a]:=DllCall("SendMessageA","UInt",sc,"int",b,int,0,int,0)
		;controllist(),arrange(),color(this)
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