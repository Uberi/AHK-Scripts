;v1.0 by majkinetor

;Options:
;    bg		- background 
;    fg		- foreground 
;	 tfg	- title color
;    size	- font size
;	 pre	- use preformated text

MsgBoxx( pMsg, pTitle="", pOptions="") {

	loop, parse, pOptions, %A_Space%
		j := InStr(A_LoopField, "="), o:=SubStr(A_LoopField, 1, j-1), o_%o% := SubStr(A_LoopField, j+1, StrLen(A_LoopField))

	IfEqual, o_align,,	SetEnv o_align, center
	IfEqual, o_size,,	SetEnv o_size, 4
	IfEqual, o_bg,,		SetEnv o_bg, silver
	ifEqual, pTitle, ,	SetEnv pTitle, %A_ScriptName%

	StringReplace, pMsg, pMsg, <, &lt;, A
	StringReplace, pMsg, pMsg, >, &gt;, A
	if (o_pre)
		 pMsg = <pre>%pMsg%</pre>
	else {
		StringReplace, pMsg, pMsg, `n, <BR>, A
		StringReplace, pMsg, pMsg, %A_Space%, &nbsp;, A
	}
	func = 
		(
			if (document.all) {
				w = document.all['Table'].offsetWidth ;
				h = document.all['Table'].offsetHeight;
				window.returnValue = 'dialogHeight:' +h + 'px;dialogWidth:' + w + 'px;';
				window.close();	
			}
		)


	loop, 2
	{
		FileDelete, ShowHTMLDialog_test.html
		goSub MsgBox_make

		FileAppend, %html%, ShowHTMLDialog_test.html 
		res := ShowHTMLDialog("file:///" A_ScriptDir "\ShowHTMLDialog_test.html", "default value", res ";scroll=0;unadorned:yes")
		func =
	}
	
	return	

 MsgBox_make:
	html = 
	(LTrim
		<script language="Javascript"> 
		function onLoad(){%func%} 
		</script>

		<BODY onLoad="onLoad();">
		<TABLE CELLPADDING="5" style="border-style:solid; border-width:3; background:%o_bg%" id="Table"   onkeypress="if (event.keyCode==27)window.close();">
		<TR>
			<TD style="color: %o_tfg%" align="left"><h2>%pTitle%</h><hr></TD>
		</TR>
		<TR>
			<TD style="color: %o_fg%" align="%o_align%"><h%o_size%>%pMsg%</h></TD>
		</TR>
				
		<TR>
			<TD align="center"><INPUT TYPE=button VALUE="Okay" onclick="window.close();"></TD>
		</TR>
	)
  return
}