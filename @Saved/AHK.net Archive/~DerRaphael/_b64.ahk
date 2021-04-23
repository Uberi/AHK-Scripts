MsgBox % b64("decode",encoded:=b64("encode",decoded:="Base64 encoding and decoding in One Line!",_TMP:=""),_TMP:="")

b64(mode, ByRef a, ByRef b, c=0, @="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/",u="UChar",v="varsetcapacity",[="RegExReplace",]="RegExMatch")
{
return % (SubStr(mode,1,1)="d")?((($:=(StrLen(a:=%[%(a,"[^a-zA-Z0-9+/]"))*6//8))&&($//3+1!=c)&&(z:=(!c)? %v%(b,$,32):1))? b64(mode,a,(b:=(NumPut((G:=((64*((64*((64*(%]%(@,SubStr(?:=SubStr(a,++c*4-3,4),1,1))-1))+(%]%(@,SubStr(?,2,1))-1)))+(StrLen(_:=SubStr(?,3,1))? %]%(@,_)-1:0)))+(StrLen(_:=SubStr(?,4,1))? %]%(@,_)-1:0)))>>16,b,(x:=c*3-3)+0,u)|NumPut(255&G>>8,b,x+1,u)|NumPut(255&G,b,x+2,u))? b:b),c):(z:=(x:=$)($:=b)(b:=x))? $:0):(($:=%v%(a))&&($!=c)&&(l:=StrLen(t:=SubStr(a,++c*3-2,3))))? b64(mode,a,b:=b SubStr(@,(((G:=NumGet(t,0,u)*65536+((l>1)? NumGet(t,1,u)*256:0)+((l>2)? NumGet(t,2,u):0))>>18)&63)+1,1) SubStr(@,((G>>12)&63)+1,1) ((l>1)? SubStr(@,((G>>6)&63)+1,1):"=")((l>2)? SubStr(@,(G&63)+1,1):"="),c):%[%(b,"(.{72})","$1`n")
}
