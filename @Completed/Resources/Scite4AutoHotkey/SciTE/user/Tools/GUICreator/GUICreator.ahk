#SingleInstance, Force
DetectHiddenWindows,On
SetWorkingDir, %A_ScriptDir%
compile_constants(),quick_help()
if !FileExist("tile.bmp"){
	SplashTextOn,200,150,Downloading tile image,Please wait
	URLDownloadToFile,http://www.autohotkey.net/~maestrith/guicreator/tile.bmp,tile.bmp
	SplashTextOff
}
if xg({settings:"//Auto_load_last_project"}).text
{
	if last:=xg({settings:"//lastopen/@file"}).text
	load(last)
	else
	gui(),Redraw()
}
else
gui()
gui(x=""){
	Version=0.220.0
	if x=1
	return version
	Gui,Destroy
	SysGet,border,32
	SysGet,caption,4
	var({pos:{border:border,caption:caption,status:h,ymin:caption+Border}})
	Gui,+hwndhwnd +Resize
	for a,b in {control:1,groupbox:1,tab:1,show:1}
	xadd("gui",a,"")
	OnMessage(0x136,"WM_CTLCOLORDLG")
	OnMessage(5,"setguipos")
	OnMessage(0x232,"snap")
	Gui,Show,w500 h500,GUI Creator (Right click for menu)
	hwnd(1,hwnd)
	gui_hotkeys()
	return
	GuiClose:
	if !xg({settings:"//Auto_Save_On_Exit"}).Text
	exitapp
	if last:=xg({settings:"//lastopen/@file"}).text
	save(last)
	else if sn(xget("undo"),"//*[@hwnd]").length
	save()
	ExitApp
	return
}
gui_hotkeys(){
	Hotkey,IfWinActive,% hwnd([1])
	Hotkey,~RButton,showmenu,On
	Hotkey,*~LButton,LButton,On
	for a,b in {Up:"adjust",Down:"adjust",Left:"adjust",Right:"adjust","^q":"quickadd",Delete:"Delete",BS:"Delete","^a":"selectall","^c":"copy_selected","^v":"paste_selected","^z":"undo","+^z":"redo","^y":"redo","^q":"quickadd"}
	hotkey,%a%,%b%,On
	for a,b in {Create:1,Hotkeys:1}{
		key:=sn(xget("settings"),"//" a "/*")
		while,k:=key.item[A_Index-1]
		Hotkey,% k.text,%a%,On
	}
	return
	copy_selected:
	paste_selected:
	%A_ThisLabel%()
	undo()
	return
	hotkeys:
	MouseGetPos,x,y,win,con,2
	married(con),var({right:{control:con+0,x:x,y:y}}),hk:=xg({settings:"//Hotkeys/*[text()='" A_ThisHotkey "']"}).nodename
	if InStr("undo|redo",hk)
	goto,%hk%
	else
	%hk%(),undo()
	return
	undo:
	u()
	return
	redo:
	u(1)
	return	
}
hwnd(number,wnd=""){
	static hwnd:=[]
	if IsObject(number)
	return hwnd[number.1].h
	if !wnd
	return hwnd[number].n
	hwnd[number]:={n:wnd,h:"ahk_id " wnd+0}
}
m(x*){
	for a,b in x
	list.=b "`n"
	MsgBox,% list
}
t(f*){
	for a,b in f
	list.=b "`n"
	tooltip,% list
}
quick_add(){
	quickadd:
	MouseGetPos,x,y,win,con,2
	married(con)
	var({right:{control:con+0,x:x,y:y}})
	if (win!=hwnd(1))
	return
	for a,b in constants("controls")
	Menu,add,add,%a%,c
	Menu,add,Show
	Menu,Delete,add
	return
	create:
	type:=xg({settings:"//Create/*[text()='" A_ThisHotkey "']"}).nodename
	MouseGetPos,x,y,win,con,2
	grid(x,y,1),add_control({x:x,y:y,type:type}),undo()
	return
}
mm(){
	showmenu:
	MouseGetPos,x,y,win,con,2
	married(con)
	var({right:{control:con+0,x:x,y:y}})
	if (win!=hwnd(1))
	return
	if con
	Menu,rmenu,Add,Edit Control,ec
	menu:=xg({Constants:"//Menu"}),xget("Constants"),m:=menu.selectnodes("//Menu/*")
	while,v:=m.item[A_Index-1]{
		menu:=v.SelectNodes("info/*"),mn:=RegExReplace(v.nodename,"_"," ")
		while,item:=menu.item[A_Index-1].SelectSingleNode("@value").text{
			Menu,%mn%,Add,% item,menu
			if xg({settings:"//" v.nodename "/" clean(item)}).text
			Menu,%mn%,Check,% item
			else
			menu,%mn%,UnCheck,% item
			if (IsFunc(clean(item))=0&&(mn!="Add"))
			if mn!=quick options
			list.=item "`n"
		}
		Menu,rmenu,Add,%mn%,:%mn%
	}
	for a,b in {Version:1,"Program Settings":1,"Window Options":1,"Quick Help":1}
	Menu,rmenu,Add,%a%,menu
	Menu,rmenu,Show
	Menu,rmenu,DeleteAll
	menu,rmenu,Show
	return
	menu:
	if (A_ThisMenu="quick options"&&A_ThisMenuItem="Grid")
	var({wbrush:0}),Redraw()
	if InStr("undo|redo",A_ThisMenuItem){
		unre:=InStr(A_ThisMenuItem,"undo")?0:1,u(unre)
		undo()
		return
	}
	if (A_ThisMenu="quick options")
	tmi:=xg({settings:"//Quick_Options/" clean(A_ThisMenuItem)}),xadd("settings","Quick_Options/" clean(A_ThisMenuItem),"",bool:=tmi.text?0:1),xsave("settings")
	if A_ThisMenu=Add
	return ac()
	mi:=clean(A_ThisMenuItem)
	if IsFunc(mi)
	%mi%(),undo()
	return
}
ac(){
	c:
	right:=var("right"),x:=right.x,y:=right.y
	grid(x,y,1)
	add_control({x:x,y:y,type:A_ThisMenuItem})
	if A_ThisLabel in Menu,c
	undo()
	return
}
add_control(pos,noundo=0){
	if pos.reload
	value1:=pos.value
 	pos.w?"":default_size(pos.type,pos),list:=[]
	static conlist:={DateTime:"longdate",MonthCal:"",Tab:"Tab|Tab",Progress:100,TreeView:"",Tab2:"Tab|Tab"}
	tab:=intab(pos)?intab(pos):intab(pos,"Tab2")
	if (Tab&&InStr(pos.type,"Tab"))
	return m("You can not place tabs inside of other tabs")
	if pos.tabnum
	tabnum:=pos.tabnum
	else
	{
		ControlGet,tabnum,Tab,,,% "ahk_id" tab
		if tabnum
		pos["tabnum"]:=tabnum
	}
	if InStr(pos.type,"Tab")
	count:=sn(xget("gui"),"//*[@type='" pos.type "']").length+1,pos["tn"]:=count
	value:=conlist[pos.type]?conlist[pos.type]:pos.type,value:=pos.value?pos.value:value
	if value=Picture
	pos.value:=value:=trim(picture())
	pos.value:=pos.type!="treeview"?value:""
	pos.type:=constants("Controls")[pos.type]
	if pos.Reload
	pos.value:=value:=value1
	WinGet,bcl,ControlListHWND,% hwnd([1])
	if tabnum
	Gui,1:Tab,% trim(tabnum),% ssn(xget("gui"),"//*[@hwnd='" tab "']/@tn").Text
	if font:=compilefont(pos)
	Gui,1:font,%font%,% pos.font
	Gui,1:Add,% pos.type,% compilepos(pos) "hwndhwnd",% value
	Gui,1:Tab
	Gui,1:Font
	if xg({settings:"//Snap_to_Grid"}).text && default_size(pos.type,pos).w="" && default_size(pos.type,pos).h=""
	Resize_Width_to_Grid(hwnd,1),resize_height_to_grid(hwnd,1)
	tv:=pos.type="treeview"?TreeView():0
	WinGet,cl,ControlListHWND,% hwnd([1])
	married(ee(bcl,cl))
	pos["hwnd"]:=hwnd+0
	guixmladd(pos,tab)
	if A_ThisLabel in create,c
	u({clear:1})
}
ee(x,y){
	loop,parse,y,`n
	if !InStr(x,A_LoopField)
	left.=A_LoopField "`n"
	left:=left?left:y
	return Trim(left,"`n")
}
compilepos(pos){
	options:=sn("settings","//Quick_Options/*"),op:=[]
	while,o:=options.item[A_Index-1]
	op[o.nodename]:=o.Text
	for a,b in constants("pos")
	if pos[a]!=""
	position.=a pos[a] " "
	if (pos.type="ListView")
	position.="-Multi "
	if pos.options
	position.=" " pos.options " "
	if op.Control_Borders
	position.=" Border "
	if pos.Style
	position.=" " pos.style " "
	if (op["disable_lists"]&&RegExMatch(pos.type,"i)(DropDownList|DDL|ComboBox)"))
	position.="Disabled "
	return position
}
constants(x=""){
	static allcon:=[]
	static constant:={info:{value:"Name of control",g:"Target label to trigger",v:"Variable to associate with this control",x:"Control Position X",y:"Control Position Y",w:"Control Width",h:"Control Height"}}
	static Button:={info:{"-Wrap":"Prevent text wrapping",Default:"Make this button the default selection","0x100":"Left-aligns the text.","0x200":"Right-aligns the text.","0x800":"Places the text at the bottom of the control's available height.","0x1":"Creates a push button with a heavy black border.","0x2000":"Wraps the text to multiple lines if the text is too long to fit on a single line in the control's available width.","0x400":"Places text at the top of the control's available height.","0xC00":"Vertically centers text in the control's available height.","0x8000":"Specifies that the button is two-dimensional."}}
	static Checkbox:={info:{"Check3":"Greyed out Check","0x1000":"Makes a checkbox or radio button look and act like a push button.","0x200":"Right-aligns the text.","0x800":"Places the text at the bottom of the control's available height.","0x2000":"Wraps the text to multiple lines if the text is too long to fit on a single line in the control's available width.","0x400":"Places text at the top of the control's available height.","0xC00":"Vertically centers text in the control's available height.","0x8000":"Specifies that the button is two-dimensional."}}
	static DateTime:={info:{Right:"Causes the drop-down calendar to drop down on the right side of the control instead of the left","0x1":"Provides an up-down control to the right of the control to modify date-time values.","0x2":"Displays a checkbox inside the control that users can uncheck to make the control have no date/time selected","0x0":"Displays the date in short format.","0x4":"Format option 'LongDate'.","0xC":"Format option blank/omitted.","0x9":"Format option 'Time'.","0x20":"The calendar will drop down on the right side of the control instead of the left."}
	,constants:{Range:"Set the range of dates eg(20050101-20120101)"}}
	static Edit:={info:{Limit:"Restricts the user's input to the visible width of the edit field",Lowercase:"The characters typed by the user are automatically converted to lowercase",Multi:"Makes it possible to have more than one line of text (Can not be combined with password)",Number:"Prevents the user from typing anything other than digits into the field",Password:"Hides the user's input (such as for password entry)",ReadOnly:"Prevents the user from changing the control's contents",Uppercase:"The characters typed by the user are automatically converted to uppercase","-WantCtrlA":"Prevents the user's press of Control-A from selecting all text in the edit control",WantTab:"Causes a tab keystroke to produce a tab character rather than navigating to the next control","-Wrap":"Turns off word-wrapping in a multi-line edit control (re-load required to see effect)","-WantReturn":"Prevents a multi-line edit control from capturing the Enter keystroke",0x40:"Scrolls text up one page when the user presses the ENTER key on the last line.",0x1:"Centers text in a multiline edit control.",0x100:"Negates the default behavior for an edit control.",0x400:"This style is most useful for edit controls that contain file names.",0x2:"Right-aligns text in a multiline edit control.","-E0x200":"Remove border"}
	,constants:{T:"Set tab stops inside a multi-line edit control (numbers only)",R:"Number of Rows (Most likely need a reload)"}}
	static GroupBox:={info:{Wrap:"Allows for a multi-line heading","0x200":"Right-aligns the text.","0x800":"Places the text at the bottom of the control's available height.","0x2000":"Wraps the text to multiple lines if the text is too long to fit on a single line in the control's available width.","0x400":"Places text at the top of the control's available height."}
	,constants:{R:"Set the number of rows available to the GroupBox"}}
	static ListBox:={info:{AltSubmit:"Alternate Submit",Multi:"Allows more than one item to be selected simultaneously via shift-click and control-click",ReadOnly:"Prevents items from being visibly highlighted when they are selected (but Gui Submit will still store the selected item)",Sort:"Automatically sorts the contents of the list alphabetically","0x1000":"Shows a disabled vertical scroll bar for the list box when the box does not contain enough items to scroll.","0x100":"Specifies that the list box will be exactly the size specified by the application when it created the list box.","0x8":"A simplified version of multi-select in which control-click and shift-click are not necessary because normal left clicks serve to extend the selection or de-select a selected item.","0x80":"Enables a ListBox to recognize and expand tab characters when drawing its strings. The default tab positions are 32 dialog box units. A dialog box unit is equal to one-fourth of the current dialog box base-width unit."}
	,constants:{T:"Set tab stops, which can be used to format the text into columns"}}
	static ListView:={info:{AltSubmit:"Notifies the script for more types of ListView events than normal",Checked:"Provides a checkbox at the left side of each row",Grid:"Provides horizontal and vertical lines to visually indicate the boundaries between rows and columns","-Hdr":"To omit the special top row that contains column titles","-Multi":"Prevents the user from selecting more than one row at a time",NoSortHdr:"Prevents the header from being clickable",NoSort:"Turns off the automatic sorting that occurs when the user clicks a column header","-ReadOnly":"Allow editing of the text in the first column of each row",Sort:"The control is kept alphabetically sorted according to the contents of the first column",SortDesc:"Same as above except in descending order","-WantF2":"Prevents an F2 keystroke from editing the currently focused row"},style:{"0x800":"Items are left-aligned in icon and small icon view.","0x100":"Icons are automatically kept arranged in icon and small icon view.","0x3":"+List. Specifies list view.","0x80":"Item text is displayed on a single line in icon view. By default, item text may wrap in icon view.","0x2000":"Scrolling is disabled. All items must be within the client area. This style is not compatible with the LVS_LIST or LVS_REPORT styles.","0x1000":"This style specifies a virtual list-view control (not directly supported by AutoHotkey).","0x400":"The owner window can paint items in report view in response to WM_DRAWITEM messages (not directly supported by AutoHotkey).","0x1":"+Report. Specifies report view.","0x40":"The image list will not be deleted when the control is destroyed. This style enables the use of the same image lists with multiple list-view controls.","0x8":"The selection, if any, is always shown, even if the control does not have keyboard focus.","0x2":"+IconSmall. Specifies small-icon view."}
	,constants:{R:"Number of rows (Most likely need a reload)"}}
	static MonthCal:={info:{Multi:"Multi-select. Allows the user to shift-click or click-drag to select a range of adjacent dates",4:"Display week numbers (1-52) to the left of each row of days",8:"Prevent the circling of today's date within the control",16:"Prevent the display of today's date at the bottom of the control"}
	,constants:{Range:"Set the range of dates eg(20050101-20120101)"}}
	static Picture:={info:{"0x4000000":"Force picture to the background","0x40":"[Windows XP or later] Adjusts the bitmap to fit the size of the control.","0x200":"Centers the bitmap in the control. If the bitmap is too large, it will be clipped. For text controls If the control contains a single line of text, the text is centered vertically within the available height of the control"}}
	static Progress:={info:{"-Smooth":"Displays a length of segments rather than a smooth continuous bar",Vertical:"Makes the bar rise or fall vertically rather than move along horizontally (Requires a variable to work properly)","0x8":"[Requires Windows XP or later] This style is typically used to indicate an ongoing operation whose completion time is unknown."}
	,constants:{Background:"Background Color",Range:"Set the range to be something other than 0 to 100 (eg, -4-45)"}}
	static Radio:={info:{Group:"Start a new group",Checked:"Have this radio checked by default","0x1000":"Makes a checkbox or radio button look and act like a push button.","0x200":"Right-aligns the text.","0x800":"Places the text at the bottom of the control's available height.","0x2000":"Wraps the text to multiple lines if the text is too long to fit on a single line in the control's available width.","0x400":"Places text at the top of the control's available height.","0xC00":"Vertically centers text in the control's available height.","0x8000":"Specifies that the button is two-dimensional."}}
	static Slider:={info:{Center:"The thumb (the bar moved by the user) will be blunt on both ends rather than pointed at one end",Invert:"Reverses the control so that the lower value is considered to be on the right/bottom rather than the left/top",Left:"The thumb (the bar moved by the user) will point to the top rather than the bottom",NoTicks:"Omit tickmarks alongside the track",ToolTip:"Creates a tooltip that reports the numeric position of the slider as the user is dragging it",Vertical:"Makes the control slide up and down rather than left and right","0x1":"The control has a tick mark for each increment in its range of values. Use +/-TickInterval to have more flexibility.","0x40":"+/-Thick. Allows the thumb's size to be changed.","0x80":"The control does not display the moveable bar."}
	,constants:{Range:"Set the range to be something other than 0 to 100"}}
	static Tab:={info:{"-Background":"Override the window's custom background color and uses the system's default Tab control color",Buttons:"Creates a series of buttons at the top of the control rather than a series of tabs","-Wrap":"Prevent the tabs from taking up more than a single row",Left:"Align tabs left",Right:"Align tabs right",Bottom:"Align tabs to the bottom"
	,"0x1":"Unneeded tabs scroll to the opposite side of the control when a tab is selected."
	,"0x4":"Multiple tabs can be selected by holding down CTRL when clicking. This style must be used with the TCS_BUTTONS style."
	,"0x10":"Icons are aligned with the left edge of each fixed-width tab. This style can only be used with the TCS_FIXEDWIDTH style."
	,"0x40":"Items under the pointer are automatically highlighted"
	,"0x400":"All tabs are the same width. This style cannot be combined with the TCS_RIGHTJUSTIFY style."
	,"0x800":"Rows of tabs will not be stretched to fill the entire width of the control. This style is the default."
	,"0x1000":"The tab control receives the input focus when clicked."
	,"0x2000":"The parent window is responsible for drawing tabs."
	,"0x4000":"The tab control has a tooltip control associated with it."
	,"0x8000":"The tab control does not receive the input focus when clicked."}}
	static Text:={info:{"-Wrap":"Prevent text wrapping",Center:"Centers the text in the control",Right:"Justifies text to the right of the control"
	,"0x7":"Specifies a box with a frame drawn in the same color as the window frames." 
	,"0x4":"Specifies a rectangle filled with the current window frame color."
	,"0x12":"Draws the frame of the static control using the EDGE_ETCHED edge style."
	,"0x10":"Draws the top and bottom edges of the static control using the EDGE_ETCHED edge style."
	,"0x11":"Draws the left and right edges of the static control using the EDGE_ETCHED edge style."
	,"0x8":"Specifies a box with a frame drawn with the same color as the screen background (desktop)."
	,"0x5":"Specifies a rectangle filled with the current screen background color."
	,"0x80":"Prevents interpretation of any ampersand (&) characters in the control's text as accelerator prefix characters."
	,"0x100":"Sends the parent window the STN_CLICKED notification when the user clicks the control."
	,"0x1000":"Draws a half-sunken border around a static control."
	,"0x9":"Specifies a box with a frame drawn with the same color as the window background. This color is white in the default color scheme."
	,"0x6":"Specifies a rectangle filled with the current window background color. This color is white in the default color scheme."}}
	static TreeView:={info:{AltSubmit:"AltSubmit","-Lines":"Removes the lines to link items",HScroll:"Disables the horizontal scroll bar",ReadOnly:"Prevents the user from editing treeview items",Checked:"Adds a checkbox to every item(reload required)"
	,"-0x1":"Removes the + and - buttons","0x10":"Prevents the tree-view control from sending TVN_BEGINDRAG notification messages.","0x1000":"Enables full-row selection in the tree view.This style cannot be used in conjunction with the TVS_HASLINES style."
	,"0x800":"Obtains ToolTip information by sending the TVN_GETINFOTIP notification.","0x2000":"Disables both horizontal and vertical scrolling in the control. The control will not display any scroll bars."
	,"0x80":"Disables ToolTips.","0x40":"Causes text to be displayed from right-to-left (RTL). Usually, windows display text left-to-right (LTR).","0x20":"Causes a selected item to remain selected when the tree-view control loses focus."
	,"0x400":"Causes the item being selected to expand and the item being unselected to collapse upon selection in the tree-view. If the user holds down the CTRL key while selecting an item, the item being unselected will not be collapsed."
	,"0x200":"Enables hot tracking of the mouse in a tree-view control."}}
	static UpDown:={info:{Horz:"Make's the control's buttons point left/right rather than up/down",Left:"Puts the UpDown on the left side of its buddy rather than the right",Wrap:"Causes the control to wrap around to the other end of its range when the user attempts to go beyond the minimum or maximum","-16":"Cause a vertical UpDown to be isolated","0x80":"Include 0x80 in Options to omit the thousands separator that is normally present between every three decimal digits in the buddy control"
	,"0x20":"Allows the user to press the Up or Down arrow keys on the keyboard to increase or decrease the UpDown control's position."}
	,constants:{Range:"Set the range to be something other than 0 to 100 (eg, -4-45)"}}
	static Controls:={Button:"Button",Checkbox:"Checkbox",ComboBox:"ComboBox",DateTime:"DateTime",DropDownList:"DropDownList",Edit:"Edit",Groupbox:"Groupbox",Hotkey:"Hotkey",Listbox:"Listbox",ListView:"ListView",MonthCal:"MonthCal",Picture:"Picture",Progress:"Progress",Radio:"Radio",Slider:"Slider",Tab:"Tab",Tab2:"Tab2",Text:"Text",Treeview:"Treeview",UpDown:"UpDown"}
	static Quick:={info:{"Snap to Grid":1,"Grid":1,"Add Spaces to Output":1,"Control Borders":1,"Warn Overwrite":1,"Auto Load Last Project":1,"Disable Lists":1,"Auto Save on Exit":1}}
	static Positioning:={info:{"Center In Window":1,"Space Evenly Horizontal":1,"Space Evenly Vertical":1,"Align Selected To Grid":1,"Center Vertically":1,"Center Horizontally":1,"Align Vertically":1,"Align Horizontally":1,"Snap Window to Grid":1}}
	static Resize:={info:{"Resize Width to Grid":1,"Resize Height to Grid":1,"Resize Width and Height to Grid":1}}
	static duplicate:={info:{"Copy Width":1,"Copy Height":1,"Duplicate Selected":1,"Copy Height and Width":1}}
	static menu_edit:={info:{Undo:1,Redraw:1,Font:1,"Set Offsets":1,"Select All":1,Delete:1,Redo:1,"Paste Selected":1,"Copy Selected":1,"Reorder Code":1}}
	static file:={info:{Load:1,Save:1,Export:1,Import:1,New:1,"Copy Code to Clipboard":1,"Import From Clipboard":1,"Test GUI":1,"Preview Code":1}}
	static menu:={Add:{info:controls},"Quick_Options":quick,Positioning:positioning,Duplicate:duplicate,Edit:menu_edit,File:file,Resize:resize}
	static Show:={info:{xCenter:"Centers the window horizontally on the screen",yCenter:"Centers the window vertically on the screen",AutoSize:"Resizes the window to accommodate only its currently visible controls",Minimize:"Minimizes the window and activates the one beneath it",Maximize:"Maximizes and activates the window",Restore:"Unminimizes or unmaximizes the window if necessary",NoActivate:"Unminimizes or unmaximizes the window if necessary",NA:"Shows the window without activating it",Hide:"Hides the window and activates the one beneath it"}
	,constants:{SysMenu:"Omits the system menu and icon in the window's upper left corner",MaximizeBox:"Disables the maximize button in the title bar",MinimizeBox:"Disables the minimize button in the title bar",Disabled:"Disables the window, which prevents the user from interacting with its controls",Resize:"Makes the window resizable and enables its maximize button in the title bar",AlwaysOnTop:"Makes the window stay on top of all other windows",Border:"Provides a thin-line border around the window",Caption:"Remove the caption bar"}}
	static windowoptions:={"Makes the window stay on top of all other windows":"+AlwaysOnTop","Provides a thin-line border around the window":"+Border","Remove the caption bar":"-Caption","Disables the window, which prevents the user from interacting with its controls":"+Disabled","Disables the maximize button in the title bar":"-MaximizeBox","Disables the minimize button in the title bar":"-MinimizeBox","Makes the window resizable and enables its maximize button in the title bar":"Resize","-SysMenu (minus SysMenu) to omit the system menu and icon in the window's upper left corner":"-SysMenu"}
	if !x
	{
		tab2:=tab
		for a,b in controls
		%a%.insert("constants",{style:"Set the style for this control"})
		allcon:={Controls:{},Constants:{},Menu:{},Show:{}}
		for con in controls
		allcon.controls.insert(con,%con%)
		allcon.constants.insert("Constants",constant)
		for con,obj in menu
		allcon.menu.insert(con,obj)
		for con,obj in {show:show}
		allcon.show.insert(con,obj)
		return allcon
	}
	static font:={bold:1,italic:1,strikeout:1,underline:1,c:1,size:1,q:1,fontw:1,font:1}
	static pos:={x:"x",y:"y",w:"w",h:"h"}
	static nh:={x:"x",y:"y",w:"w"}
	static constantlist:=["x","y","w","h","g","v","value"]
	return out:=%x%
}
adjust(ByRef x,ByRef y){
	pos:=var("pos")
	x:=x-pos.Border,y:=y-pos.Border-pos.Caption
	return {x:x,y:y}
}
fine(){
	adjust:
	out:=xg({settings:"//Snap_to_Grid"}).text,all:=getallpos(hwnd(1),1)
	ad:=out?10:1
	if A_ThisHotkey=up
	yad:=-ad,xad:=0
	if A_ThisHotkey=Down
	yad:=ad,xad:=0
	if A_ThisHotkey=Left
	yad:=0,xad:=-ad
	if A_ThisHotkey=right
	yad:=0,xad:=ad
	for a,b in selected_controls()
	checkmove(a,all[a].x+xad,all[a].y+yad)
	showhighlight(),undo()
	return
}
var(x=""){
	static list:=[]
	if !x
	return list
	if !IsObject(x)
	return list[x]
	for a,b in x
	list[a]:=b
}
grid(ByRef x,ByRef y,adjust=""){
	offset:=easyatt(xg({settings:"//Offset"}))
	out:=xg({settings:"//Snap_to_Grid"}).Text
	out:=adjust=2?1:out
	offsetx:=offset.x?offset.x:2
	offsety:=offset.y?offset.y:0
	x:=out?round(x,-1)-offsetx:x
	y:=out?round(y,-1)-offsety:y
	if adjust=1
	adjust(x,y)
	sleep,1
	return {x:x,y:y}
}
WM_CTLCOLORDLG(w,l,m,h){
	Static wBrush
	if A_Gui!=1
	return
	if xg({settings:"//Grid"}).text
	tile:="tile.bmp"
	else
	return
	If !wBrush
	hBM:=DllCall("LoadImage",Int,0,Str,tile,Int,0,Int,0,Int,0,UInt,0x400010),wBrush:=DllCall("CreatePatternBrush",UInt,hBM),var({hbm:hbm}),var({wbrush:wbrush})
	Return wBrush
}
married(ByRef x=""){
	static married:=[]
	if !x
	return married
	if !InStr(x,"`n")
	return x:=married[x]?married[x]:x+0
	StringSplit,c,x,`n
	married[c2+0]:=c1+0
}
xget(doc,xpath="",attribute=""){
	xml:=xml(doc).xml
	if !xpath
	return xml
	data:=xml.selectsinglenode("//" xpath)
	if attribute
	return data.selectsinglenode("@" attribute).text
	return data.text
}
xml(ref="",root="",file=""){
	static documents:=[]
	if ref.remove
	return documents.remove(ref.remove)
	if !ref
	return documents
	file:=file?file:ref ".xml",root:=!root?ref:root
	if !documents[ref]{
		doc:=ComObjCreate("MSXML2.DOMDocument"),doc.setProperty("SelectionLanguage","XPath")
		ifexist %file%
		doc.load(file)
		else
		xml:=doc.createelement(root),doc.appendchild(xml)
		documents[ref]:={xml:doc,file:file,root:root}
	}
	return documents[ref]
}
xg(xml){
	ret:=[]
	for a,b in xml
	x:=xml(a).xml.selectsinglenode(b),ret[A_Index]:=x
	return o:=isobject(ret.2)?ret:x
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
	<xsl:for-each select="@*">
	<xsl:text></xsl:text>
	</xsl:for-each>
	</xsl:copy>
	</xsl:template>
	</xsl:stylesheet>
	)
	xsl.loadXML(style), style:=null
	return xsl
}
xadd(ref,path,value,text="",duplicate=""){
	doc:=xml(ref).xml,currentpath:=xml(ref).root,batch:=[]
	StringSplit,path,path,/
	edit:=doc.selectsinglenode("//" path)
	if (edit=""||duplicate){
		check:=doc.SelectSingleNode("//" path)?1:0
		Loop,Parse,path,/
		last:=currentpath,bool:=doc.SelectSingleNode(currentpath.="/" A_LoopField)?1:0,batch[A_Index]:={name:A_LoopField,exist:bool,last:last}
		for a,b in batch
		if !b.Exist
		edit:=doc.selectsinglenode(b.last),xml:=doc.createelement(b.name),edit.appendchild(xml)
		edit:=doc.SelectSingleNode(b.last "/" b.name)
	}
	if duplicate&&check=1
	dup:=doc.SelectSingleNode(batch[path0]last),xml:=doc.CreateElement(path%path0%),dup.AppendChild(xml),edit:=xml
	if IsObject(value)
	for a,b in value
	edit.setattribute(a,b)		
	else
	edit.text:=value
	if Text!=""
	edit.text:=Text
	return edit
}
sn(xml,node){
	if !IsObject(xml)
	xml:=xget(xml)
	return xml.selectnodes(node)
}
ssn(xml,node){
	return xml.selectsinglenode(node)
}
xx(doc,path,value,text="",find=""){
	main:=xml(doc)
	for a,b in Main
	%a%:=b
	pat:="//" root,root:=xml.selectsinglenode("/*")
	for a,b in find
	if found:=ssn(xml,"//" path "[@" a "='" b "']"){
		for a,b in value
		found.setattribute(a,b)
		return found
	}
	Loop,Parse,path,/
	{
		pat.="/" A_LoopField
		bool:=ssn(xml,pat)?1:0
		if bool
		{
			last:=ssn(xml,pat)
			lastpath:=A_LoopField
			continue
		}
		if (bool=0 && A_Index=1)
		last:=xml.createelement(A_LoopField),root.appendchild(last)
		if (bool=0 && A_Index>1)
		new:=xml.createelement(A_LoopField),last.appendchild(new)
		last:=ssn(xml,pat)
		lastpath:=A_LoopField
	}
	stringsplit,path,pat,/
	prev:=path0>1?path0-1:1
	if bool && find
	dup:=xml.createelement(lastpath),new:=ssn(xml,"//" path%prev%),new.appendchild(dup),last:=dup
	for a,b in value
	last.setattribute(a,b)
	if text
	last.text:=text
	return last
}
guixmladd(info,tab){
	n:=[]
	xml:=xget("gui")
	for a,b in info
	if a not in tab,tabnum
	n[a]:=b
	if tab
	{
		t:=xg({gui:"//*[@hwnd='" tab "']"})
		if !newtab:=ssn(t,"tabnum[@tab='" info.tabnum "']")
		newtab:=xml.createelement("tabnum"),t.appendchild(newtab),newtab.setattribute("tab",info.tabnum)
		new:=xml.createelement("control"),newtab.appendchild(new)
		for a,b in info
		if a!=tab
		new.setattribute(a,b)
		return
	}
	if InStr(info.type,"Tab")
	{
		xx("gui","tab/tab",n,,{hwnd:info.hwnd})
		return
	}
	if info.type="Groupbox"
	return xx("gui","groupbox/control",n,,{hwnd:info.hwnd})
	if !Tab
	xx("gui","control/control",n,,{hwnd:info.hwnd})
}
xsave(file=""){
	if file{
		b:=xget(file)
		file:=xml()[file].file?xml()[file].file:file
		b.transformNodeToObject(style(),b),b.save(file)
	}
	else
	for a,b in xml()
	b.xml.transformNodeToObject(style(),b.xml),b.xml.save(b.file)
}
class xml{
	__New(param*){
		ref:=param.1,root:=param.2,file:=param.3
		file:=file?file:ref ".xml",root:=!root?ref:root
		temp:=ComObjCreate("MSXML2.DOMDocument"),doc.setProperty("SelectionLanguage","XPath")
		ifexist %file%
		temp.load(file),this.xml:=temp
		else
		this.xml:=xml.CreateElement(temp,root)
		this.file:=file
		xml.list({ref:ref,xml:this.xml,obj:this})
	}
	__Get(){
		return this.xml.xml
	}
	CreateElement(doc,root){
		x:=doc.CreateElement(root),doc.AppendChild(x)
		return doc
	}
	add(path="",att="",text="",dup="",find=""){
		main:=this.xml.SelectSingleNode("*")
		for a,b in find
		if found:=main.SelectSingleNode("//" path "[@" a "='" b "']"){
			for a,b in att
			found.setattribute(a,b)
			return found
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
			if Text
			p.text:=text
		}
	}
	remove(){
		this.xml:=""
	}
	save(){
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
		xsl := ComObjCreate("MSXML2.DOMDocument")
		style =
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
		return xsl
	}
}
intab(position,type="Tab"){
	tab:=sn(xget("gui"),"//*[@type='" type "']"),all:=getallpos(hwnd(1))
	xx:=position.x,yy:=position.y
	while,t:=ssn(tab.item[A_Index-1],"@hwnd").text
	{
		x:=all[t].x,y:=all[t].y,w:=all[t].w+x,h:=all[t].h+y
		if (x<xx && xx<w)&&(y<yy&&yy<h)
		return t
	}
}
getallpos(win="",adjust=0){
	list:=[],win:=win?win:hwnd(1)
	WinGet,cl,ControlListhwnd,ahk_id %win%
	Loop,Parse,cl,`n
	{
		con:=A_LoopField,married(con)
		if (con!=A_LoopField)
		continue
		ControlGetPos,x,y,w,h,,% "ahk_id " A_LoopField
		if !adjust
		adjust(x,y)
		for a,b in {x:x,y:y,w:w,h:h,xx:x+w,yy:y+h}
		list[con,a]:=b
	}
	return list
}
delete(){
	right:=var("right")
	if selected_controls().minindex()
	MsgBox,4,Delete Controls,Delete all selected controls?`nTo avoid this message press Delete or Backspace to delete all selected controls
	IfMsgBox Yes
	for a,b in selected_controls()
	remove:=xg({gui:"//*[@hwnd='" a "']"}),remove.parentnode.removechild(remove)
	else
	remove:=xg({gui:"//*[@hwnd='" right.control "']"}),remove.parentnode.removechild(remove)
	load(xget("gui"))
	undo()
	return
	delete:
	for a,b in selected_controls()
	remove:=xg({gui:"//*[@hwnd='" a "']"}),remove.parentnode.removechild(remove)
	load(xget("gui"))
	undo()
	return
}
undo(){
	con:=xget("gui"),tf:=[],grp:=sn(con,"//*[@type='Groupbox']"),pos:=var("pos"),xywh:=["x","y","w","h"]
	for a,b in getallpos()
	{
		control:=xg({gui:"//*[@hwnd='" a "']"}),pos:=easyatt(control),nh:=InStr("DropDownList|DDL|ComboBox",pos.type)
		for c,d in p:=nh?constants("nh"):constants("pos")
		Control.SetAttribute(c,b[c])
	}
	if grp.length
	while,cons:=grp.item[A_Index-1]
	{
		f:=sn(cons,"*")
		pos:=easyatt(cons)
		inside:=inside(pos)
		while,incon:=f.item[A_Index-1]
		{
			if (ssn(incon,"@tabnum"))&&inside[ssn(incon,"@hwnd").text]=""
			back:=ssn(incon,"../.."),back.appendchild(incon)
			else if (ssn(incon,"@type").text="Groupbox"&&inside[ssn(incon,"@hwnd").text]="")
			back:=ssn(con,"//gui/groupbox"),back.appendchild(incon)
			else if inside[ssn(incon,"@hwnd").text]=""
			back:=ssn(con,"/gui/" incon.nodename),back.appendchild(incon)
		}
	}
	group:=sn(con,"//*[@type='Groupbox']")
	while,val:=group.item[A_Index-1]
	for a in inside(ssn(val,"@hwnd").text){
		if (ssn(val,"@tabnum").text=ssn(con,"//*[@hwnd='" a "']").selectsinglenode("@tabnum").text && ssn(con,"//*[@hwnd='" a "']/../@hwnd").text!=ssn(val,"@hwnd").text)
		val.appendchild(ssn(con,"//*[@hwnd='" a "']"))
	}
	winpos:=getwinpos(x,y,w,h,hwnd(1)),show:=ssn(con,"//gui/show")
	for a,b in {x:x,y:y,w:w,h:h}
	show.SetAttribute(a,b)
	xxx:=ssn(xget("gui"),"//gui").clonenode(1),x:=xadd("undo","undo",{time:a_now},,1),x.AppendChild(xxx)
	if (WinExist(hwnd([66]))&&hwnd(66))
	Preview_Code()
}
easyatt(node){
	list:=[],nodes:=sn(node,"@*")
	while,n:=nodes.item[A_Index-1]
	list[n.nodename]:=n.text
	return list
}
inside(control){
	if IsObject(control)
	ea:=control
	else
	ea:=easyatt(xg({gui:"//*[@hwnd='" control "']"}))
	if ea.h=""
	gcp:=getconpos(Control),ea.h:=gcp.h
	xml:=xget("gui"),f:=sn(xml,"//*[@x>" ea.x "][@x<" ea.x+ea.w "][@y>" ea.y "][@y<" ea.y+ea.h "]"),list:=[]
	while,v:=f.item[A_Index-1].SelectSingleNode("@hwnd")
	list[v.Text]:=v.Text,l.=v.text "`n"
	return list
}
lbutton(){
	LButton:
	MouseGetPos,x,y,win,Con,2
	married(con),control:=[]
	sleep,1
	win+=0
	if (win!=hwnd(1))
	return
	if !con
	return select()
	while,GetKeyState("LButton","P"){
		MouseGetPos,xx,yy
		if (Abs(x-xx)>2||Abs(y-yy)>2)
		if GetKeyState("Shift","P")
		return resize(con,x,y)
		else
		return move(con,x,y)
	}
	if GetKeyState("Shift","P")
	selected_controls(con),showhighlight()
	else if GetKeyState("Control","P"){
		sel:=selected_controls()
		if sel[con]{
			for a,b in sel
			if (a!=con)
			Control[a]:=a
			selected_controls(Control)
		}
		else
		selected_controls(Con)
		showhighlight()
	}
	else
	Control[con]:=con,selected_controls(Control),showhighlight()
	return
}
checkmove(Control,x="",y="",w="",h=""){
	adjust(x,y)
	for a,b in constants("pos")
	if (%a%!="")
	position.=a %a% " "
	GuiControl,movedraw,%control%,%position%
}
u(x=0){
	static last
	if x.clear
	return last:=""
	undo:=xget("undo")
	if (x=0){
		if !last
		last:=ssn(undo,"//undo").lastchild.previoussibling
		else if last.previoussibling
		last:=last.previoussibling
	}
	if (x=1){
		if !last
		return
		else if last.nextsibling
		last:=last.nextsibling
		else
		return
	}
	u:=last.clonenode(1)
	if ssn(u,"*")
	load(ssn(u,"*"))
	else
	xml({remove:"gui"}),gui(2)
}
load(load=""){
	if !load
	FileSelectFile,load,,,,*.xml
	if ErrorLevel
	return
	if IsObject(load)
	con:=load,xml({remove:"gui"}),gui(2)
	else
	reset(),gui(2),xadd("settings","lastopen",{file:load}),xsave("settings"),xml("temp","gui",load),con:=xget("temp")
	font:=sn(con,"//*[@hwnd]")
	show:=ssn(con,"//show"),x:=xg({gui:"//show"})
	e:=easyatt(show)
	for a,b in e
	%a%:=b
	if !(x&&y&&w&&h)
	return
	Gui,Show,x%x% y%y% w%w% h%h% hide
	if !font.length
	return new()
	while,control:=font.item[A_Index-1]{
		pos:=easyatt(control)
		pos.reload:=1
		add_control(pos)
	}
	x:=xg({gui:"//show"})
	for a,b in allattributes("temp","//show")
	x.SetAttribute(a,b)
	Gui,Show
	if !IsObject(load)
	undo()
	WinSetTitle,% hwnd([1]),,% "GUI Creator (Right click for menu) : " xg({settings:"//lastopen/@file"}).text
}
reset(noreset=""){
	xml({remove:"temp"})
	xml({remove:"gui"})
	if !noreset
	xml({remove:"undo"})
}
allattributes(doc,path){
	values:=[]
	doc:=xml(doc).xml
	main:=ssn(doc,path)
	list:=sn(main,"@*")
	while,value:=list.item[A_Index-1]
	values[value.nodename]:=value.text
	return values
}
compile_constants(){
	doc:=xget("Constants")
	first:=doc.SelectSingleNode("//Constants")
	con:=doc.createelement("Constants"),first.appendchild(con)
	for a,b in constants(){
		main:=doc.CreateElement(a),con.AppendChild(main)
		for c,d in b{
			i:=doc.createelement(c),main.AppendChild(i)
			for e,f in d{
 				j:=doc.createelement(clean(e)),i.AppendChild(j)
				for g,h in f
				k:=doc.createelement("value"),j.AppendChild(k),k.SetAttribute("value",g),k.SetAttribute("desc",h)
			}
		}
	}
	doc.transformNodeToObject(style(),doc)
	root:=ssn(doc,"//Constants/info")
	for a,b in ["x","y","w","h","v","g"]
	child:=ssn(root,"*[@value='" b "']"),root.AppendChild(child)
}
clean(x,y=0){
	if y=1
	return regexreplace(x,"i)(?:[^a-z0-9 ]|\&)","")
	return regexreplace(regexreplace(x,"i)(?:[^a-z0-9 ]|\&)","")," ","_")
}
move(con,x,y){
	offset:=[],grid(x,y)
	Gui,99:Destroy
	if selected_controls()[con]
	for a,b in selected_controls(){
		cp:=getconpos(a),offset[a,"x"]:=x-cp.x,offset[a,"y"]:=y-cp.y
		for a,b in inside(a)
		cp:=getconpos(a),offset[a,"x"]:=x-cp.x,offset[a,"y"]:=y-cp.y
	}
	else
	{
		cp:=getconpos(con),g:=grid(cp.x,cp.y),offset[con,"x"]:=x-g.x,offset[con,"y"]:=y-g.y
		for a,b in inside(con)
		cp:=getconpos(a),offset[a,"x"]:=x-cp.x,offset[a,"y"]:=y-cp.y
	}
	while,GetKeyState("LButton","P"){
		MouseGetPos,xx,yy
		grid(xx,yy)
		if (lastx=xx&&lasty=yy)
		continue
		for a,b in offset
		checkmove(a,xx-b.x,yy-b.y)
		lastx:=xx,lasty:=yy
	}
	showhighlight(),undo(),Redraw()
}
resize(con,x,y){
	offset:=[],grid(x,y)
	Gui,99:Destroy
	cp:=getconpos(con),offset["w"]:=cp.w,offset["h"]:=cp.h
	while,GetKeyState("LButton","P"){
		MouseGetPos,xx,yy
		g:=grid(xx,yy)
		if (lastx=xx&&lasty=yy)
		continue
		nx:=xx-x+offset.w,ny:=yy-y+offset.h
		if GetKeyState("Control","P")
		ny:=offset.h*((xx-x)+offset.w)/offset.w
		if selected_controls()[con]
		for a,b in selected_controls()
		checkmove(a,"","",nx,ny)
		else
		checkmove(con,"","",nx,ny)
		lastx:=xx,lasty:=yy
	}
	showhighlight(),undo(),Redraw()
}
Resize_Width_to_Grid(x="",nosh=0){
	right:=var("right"),sel:=selected_controls()
	for a,b in sel
	g:=getconpos(a),checkmove(a,,,round(g.w,-1))
	g:=getconpos(right.control),checkmove(right.control,,,round(g.w,-1)),g:=getconpos(x),checkmove(x,,,round(g.w,-1))
	if !nosh
	showhighlight(),m()
}
Resize_Height_to_Grid(x="",nosh=0){
	right:=var("right"),sel:=selected_controls()
	for a,b in sel
	g:=getconpos(a),checkmove(a,,,,round(g.h,-1))
	g:=getconpos(right.control),checkmove(right.control,,,,round(g.h,-1)),g:=getconpos(x),checkmove(x,,,,round(g.h,-1))
	if !nosh
	showhighlight()
}
Resize_Width_and_Height_to_Grid(){
	right:=var("right"),sel:=selected_controls()
	for a,b in sel
	g:=getconpos(a),checkmove(a,,,round(g.w,-1),round(g.h,-1))
	g:=getconpos(right.control),checkmove(right.control,,,round(g.w,-1),round(g.h,-1)),showhighlight()
}
selected_controls(list=""){
	static save:=[]
	if IsObject(list)
	return save:=list
	if !list
	return save
	if !IsObject(list)
	save[list]:=list
}
getconpos(con){
	married(con),list:=[]
	ControlGetPos,x,y,w,h,,ahk_id %con%
	for a,b in {x:x,y:y,w:w,h:h,xx:x+w,yy:y+h}
	list[a]:=b
	return list
}
showhighlight(color=0,position=0){
	list:=[]:=pos:=""
	gui,99:destroy
	Gui,99:+LastFound +owner1 +E0x20 -Caption +hwndsh +ToolWindow 
	;var({sh:"ahk_id " sh})
	WinSet,TransColor,0xF0F0F0 100
	Gui,99:Color,0xF0F0F0,0xFF
	color:=0xaaaa00,pos:=getallpos(hwnd(1),1)
	WinGetPos, x1, y1, w1, h1,% hwnd([1])
	for a,b in selected_controls(){
		if !a
		continue
		Random,color,0x111111,0xffffff
		if (pos[a].x=""||pos[a].y=""||pos[a].w=""||pos[a].h="")
		continue
		Gui, 99:Add, Progress, % "c" color " x" pos[a].x " y" pos[a].y " w" pos[a].w " h" pos[a].h " hwndhwnd", 100
		list[a]:=hwnd
	}
	getwinpos(x,y,w,h,hwnd(1)),p:=var("pos")
	h:=h+p.Border+p.Caption, w+=p.Border
	Gui,99:Show,x%x% y%y% w%w% h%h% NoActivate
	var({high:list})
}
redraw(){
	WinSet,Redraw,,% hwnd([1])
}
getwinpos(ByRef x,ByRef y,ByRef w,ByRef h,win){
	WinGetPos,x,y,,,ahk_id %win%
	VarSetCapacity(size,16,0),DllCall("user32\GetClientRect","uint",win,"uint",&size),w:=NumGet(size,8),h:=NumGet(size,12)
	return "x" x " y" y " w" w " h" h
}
select(){
	p:=var("pos"),ins:=[],sel:=[],xy:=[]
	MouseGetPos,xx,yy
	if (xx<p.Border || yy<p.Border+p.Caption){
		Gui,99:Destroy
		return
	}
	Random,color,0xaaaaaa,0xeeeeee
	gui,59:-caption +alwaysontop +E0x20 +hwndselect +Owner1
	WinGetPos,wx,wy,ww,wh,% hwnd([1])
	gui,59:show,% "x" wx " y" wy " w" ww " h" wh  " noactivate hide"
	gui,59:color,%color%
	gui,59:show,NoActivate
	WinSet,Transparent,20,ahk_id %select%
	while,GetKeyState("LButton","P"){
		mousegetpos,x,y
		winset,region,%xx%-%yy% %x%-%yy% %x%-%y% %xx%-%y% %xx%-%yy%,ahk_id %select%
	}
	Gui,59:Destroy
	adjust(x,y),adjust(xx,yy)
	xy["x",x]:=1,xy["x",xx]:=1,xy["y",y]:=1,xy["y",yy]:=1
	if (x=""||y=""||xx=""||yy="")
	return selected_controls({}),showhighlight()
	ins:=inside({x:xy.x.minindex(),w:abs(x-xx),y:xy.y.minindex(),h:abs(y-yy)})
	if GetKeyState("Control","P"){
		new:=[]
		sel:=selected_controls()
		for a,b in ins
		if !sel[a]
		new[a]:=a
		ins:=new
	}
	if GetKeyState("Shift","P")&&GetKeyState("Control","P")=0{
		for a,b in selected_controls()
		ins[a]:=a
	}
	selected_controls(ins),showhighlight()
}
compilefont(control){
	for a,b in control{
		if (a="size"&&b)
		sizeval.=" s" b
		if (a="color"&&b)
		sizeval.=" c" b
		if (RegExMatch(a,"i)(bold|italic|strikeout|underline)")&&b=1)
		sizeval.=" " a
	}
	return Trim("norm" sizeval)
}
save(filename=""){
	undo()
	if !filename
	over:=xg({settings:"//Warn_Overwrite"}).Text?"S16":"S"
	if !filename
	FileSelectFile,filename,%over%,,Save Gui Structure as...,*.xml
	if ErrorLevel
	return
	filename:=InStr(filename,".xml")?filename:filename ".xml"
	xadd("settings","lastopen",{file:filename}),xsave("settings")
	FileDelete,%filename%
	b:=xget("gui")
	b.transformNodeToObject(style(),b),b.save(filename)
}
new(noreset=""){
	win:=WinExist(hwnd([88]))
	pos:=getwinpos(x,y,w,h,hwnd(88))
	reset(noreset),xadd("settings","lastopen",{file:""}),xsave("settings")
	gui()
}
Preview_Code(){
	program:=export(1)
	if WinExist(hwnd([66])){
		ControlSetText,Edit1,%program%,% hwnd([66])
		return
	}
	Gui,66:Destroy
	Gui,66:+hwndhwnd +Resize +Owner1
	setguifont(66)
	hwnd(66,hwnd)
	Gui,66:Add,Edit,w500 r20 -Wrap,% program
	shapeset(66,{Edit1:"wh"},hwnd,"Code Preview")
	Gui,66:Show,x0 y0
	WinActivate,% hwnd([1])
	return
	66GuiClose:
	Gui,66:Destroy
	return
}
align_vertically(){
	right:=var("right")
	if !right.Control
	minx:=posinfo().y.minindex()
	else
	minx:=getconpos(right.Control).y
	for a,b in selected_controls()
	Checkmove(a,,minx)
	showhighlight(),Redraw()
}
align_horizontally(){
	right:=var("right")
	if !right.Control
	minx:=posinfo().x.minindex()
	else
	minx:=getconpos(right.Control).x
	for a,b in selected_controls()
	Checkmove(a,minx)
	showhighlight(),Redraw()
}
align_selected_to_grid(){
	for a,b in selected_controls()
	p:=getconpos(a),g:=grid(p.x,p.y,2),checkmove(a,g.x,g.y)
	showhighlight()
}
posinfo(){
	x:=[],y:=[],totalheight:=0,totalwidth:=0,w:=[],h:=[],order:=[]
	for a,b in selected_controls(){
		p:=getconpos(a)
		x[p.x,a]:=p
		y[p.y,a]:=p
		totalheight+=p.h
		totalwidth+=p.w
	}
	for a in x
	for b,c in x[a]
	w[c.x+c.w,b]:=c
	for a in y
	for b,c in y[a]
	h[c.y+c.h,b]:=c
	return {x:x,y:y,w:w,h:h,tw:totalwidth,th:totalheight}
}
select_all(){
	selectall:
	all:=[]
	for a,b in getallpos(hwnd(1))
	all[a]:=a
	selected_controls(all),showhighlight()
	return
}
setguipos(shape="",a="",b="",hwnd=""){
	offsets:=var("offsets")
	getwinpos(xx,yy,ww,hh,hwnd)
	for a,b in offsets[A_Gui]
	for c,d in b
	{
		if c in w,x
		GuiControl,%A_Gui%:MoveDraw,%a%,% c ww-d
		if c in h,y
		GuiControl,%A_Gui%:MoveDraw,%a%,% c hh-d
	}
}
shapeset(num,shape,hwnd,title=""){
	static controls:=[]
	Gui,%num%:Show, AutoSize,%title%
	Gui,%num%:Show
	getwinpos(xx,yy,ww,hh,hwnd)
	pos:=var("pos")
	list:=getallpos(hwnd,1)
	for a,b in shape
	loop,parse,b
	{
		if A_LoopField in x,w
		coord:=A_LoopField="x"?ww+pos.border+pos.border:ww
		if A_LoopField in y,h
		coord:=A_LoopField="y"?hh+pos.caption+pos.border:hh
		ControlGet,con,hwnd,,%a%,ahk_id %hwnd%
		gcp:=getconpos(con)
		controls[num,a,A_LoopField]:=abs(coord-list[con,A_LoopField])
	}
	var({offsets:controls})
}
snap_window_to_grid(){
	p:=var("pos")
	getwinpos(x,y,w,h,hwnd(1))
	w:=round(w,-1)
	h:=round(h,-1)
	w+=(p.Border*2)+1,h+=(p.Border*2)+p.Caption+1
	WinMove,% hwnd([1]),,,,% w,% h
}
snap(a,b,c,d){
	if (d+0!=hwnd(1))
	return
	if xg({settings:"//Snap_to_Grid"}).text
	snap_window_to_grid()
}
treeview(x=""){
	if !x
	return v:=TV_Add("TreeView"),TV_Add("TreeView",v)
	m("Working on a nifty way to work this out.  Stay tuned.")
}
program_settings(){
	static
	programsettings:
	settings:=xget("settings"),fun:=constants("positioning")
	functions:=[]
	for a,b in {positioning:1,duplicate:1,file:1,resize:1,menu_edit:1}
	for a,b in constants(a).info
	functions[a]:=b
	for a,b in {"Edit Control":1,"Quick Add":1,Undo:1,Redo:1,"Paste Selected":1,"Copy Selected":1}
	functions[a]:=a
	Gui,60:Destroy
	setguifont(60)
	Gui,60:+hwndhwnd +Resize +Owner1
	hwnd(60,hwnd)
	Gui,60:Default
	Gui,Add,Text,,Click or press F2 to change the values.`nAvoid any hotkey using the left button`nonly use modified right button (+RButton)
	Gui,Add,Tab,w850 Buttons h550,Hotkeys|Default Sizes
	Gui,Add,ListView,w400 h480 vsyslistview321 AltSubmit -ReadOnly gproset,Key|Hotkey
	Gui,Add,ListView,x+10 w400 h480 vsyslistview322 AltSubmit -ReadOnly gproset,Key|Hotkey
	Gui,Tab,2
	Gui,Add,ListView,w500 h500 -ReadOnly AltSubmit gproset,Size (Width Height)|Control
	Gui,ListView,SysListView321
	Gui,Tab
	Gui,Add,Button,gpsfont xm,GUI Font
	functions.insert("Font",1)
	for a,b in functions
	LV_Add("",ssn(settings,"//Hotkeys/" clean(a)).text,a)
	Gui,60:ListView,SysListView322
	for a,b in constants("controls")
	LV_Add("",ssn(settings,"//Create/" clean(a)).text,a)
	Gui,60:Show,,Program Settings
	LV_Modify(1,"Select Focus")
	Gui,ListView,SysListView323
	for a,b in constants("controls")
	LV_Add("",ssn(settings,"//Default/" clean(a)).text,a)
	return
	proset:
	if A_GuiEvent not in normal
	return
	Send,{f2}
	60GuiContextMenu:
	return
	60GuiEscape:
	60GuiClose:
	for a,b in {SysListView321:"Hotkeys",SysListView322:"Create",SysListView323:"Default"}
	{
		Gui,60:ListView,%a%
		Loop,% LV_GetCount()
		{
			LV_GetText(val,A_Index),LV_GetText(set,A_Index,2)
			if val
			xadd("settings",b "/" clean(set),"",val)
			if !val
			if remove:=xg({settings:"//" b "/" clean(set)})
			remove.parentnode.removechild(remove)
		}
	}
	gui_hotkeys(),xsave("settings")
	Gui,60:Destroy
	return
	psfont:
	style:=easyatt(xg({settings:"//font"}))
	style:=style.name?style:{name:"Arial"}
	style.color:=RGB(style.color)
	if !dlg_font(name,style,rgb(style.color))
	return
	font:=xadd("settings","font",style)
	program_settings()
	return
}
font(){
	sel:=selected_controls(),con:=xget("gui"),right:=var("right").control+0
	sel[right]:=right,style:=[]
	if n:=ssn(con,"//*[@hwnd='" right "']/@font")
	values:=sn(n,"../@*")
	style:=easyatt(ssn(n,".."))
	name:=style.font?style.font:"Arial"
	if !dlg_font(name,style,rgb(style.color))
	return
	for a,b in sel
	{
		font:=ssn(con,"//*[@hwnd='" a "']")
		for b,c in Style
		{
			if b=name
			b:="font"
			if b=Color
			c:=rgb(c)
			font.SetAttribute(b,c)
		}
		size:=compilefont(easyatt(font))
		Gui,font,%size%,% style.name
		GuiControl,font,% a
	}
	Gui,Font
}
Dlg_Font(ByRef Name,ByRef Style,ByRef Color,Effects=true,hGui=0){
	name:=style.name?style.name:name
	strput(strget(&name),&name,"CP0")
	LogPixels:=DllCall("GetDeviceCaps","uint",DllCall("GetDC","uint",hGui),"uint",90)
	VarSetCapacity(LOGFONT,128,0)
	Effects:=0x041+(Effects ? 0x100 : 0)
	DllCall("RtlMoveMemory","uint",&LOGFONT+28,"Uint",&Name,"Uint",32)
	s:=style.bold?NumPut(700,LOGFONT,16)
	s:=style.italic?NumPut(255,LOGFONT,20,1)
	s:=style.underline?NumPut(1,LOGFONT,21,1)
	s:=style.strikeout?NumPut(1,LOGFONT,22,1)
	if style.size
	s:=-DllCall("MulDiv","int",style.size,"int",LogPixels,"int",72),NumPut(s,LOGFONT,0,"Int")
	else  NumPut(16,LOGFONT,0)
	VarSetCapacity(CHOOSEFONT,60,0),NumPut(60,CHOOSEFONT,0),NumPut(hGui,CHOOSEFONT,4),NumPut(&LOGFONT,CHOOSEFONT,12),NumPut(Effects,CHOOSEFONT,20),NumPut(color,CHOOSEFONT,24)
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
	strikeout:=NumGet(LOGFONT,22,"UChar")?1:0
	s:=NumGet(LOGFONT,0,"Int")
	style:={size:Abs(DllCall("MulDiv","int",abs(s),"int",72,"int",LogPixels)),underline:underline,italic:italic,bold:bold,name:strget(&name,cp0),color:color,strikeout:strikeout}
	name:=strget(&name,cp0) 
	return 1
}
rgb(c){
	setformat,IntegerFast,H
	c:=(c&255)<<16 | (c&65280) | (c>>16),c:=SubStr(c,1)
	SetFormat, integerfast,D
	return c
}
edit_control(){
	ec:
	con:=var("right").control,c:=xg({gui:"//*[@hwnd='" con "']"})
	if !con
	return m("Please place the mouse over a control to edit")
	att:=easyatt(c)
	type:=xg({gui:"//*[@hwnd='" con "']/@type"}).text
	menu:=xget("Constants"),m:=menu.selectnodes("//Controls/" type "/info/*[@value]")
	rows:=m.length+1
	Gui,45:Destroy
	Gui,45:+Owner1
	setguifont(45)
	if rows
	Gui,45:Add,ListView,w600 Checked r%rows%,Set|Value|Description
	else
	Gui,45:Add,ListView,w600 h0,set|value|description
	Gui,45:Default,
	while,v:=m.item[A_Index-1]{
		value:=ssn(v,"@value").text
		a:=att.options,look:=RegExReplace(a," ","\b|")
		if look
		Check:=RegExMatch(value,look "\b")?"Check":""
		LV_Add(check,"",value,ssn(v,"@desc").text)
	}
	loop,3
	LV_ModifyCol(A_Index,"autohdr")
	mm:=menu.selectnodes("//Controls/" type "/constants/*[@value]|//Constants/info/*")
	rows:=mm.length
	Gui,45:Add,ListView,r%rows% w600 AltSubmit gecedit NoSort -ReadOnly,Value|Info
	while,v:=mm.item[A_Index-1]{
		in:=ssn(v,"@value").text
		vv:=att[in]
		LV_Add("",vv,ssn(v,"@desc").text)
	}
	LV_ModifyCol(1,200),LV_ModifyCol(2,"autohdr")
	Gui,Add,Button,gecu Default,Update Control
	Gui,Add,Button,x+10 gecup,Update Selected Size
	ecp:=xg({settings:"//EditControl"}),ecp:=easyatt(ecp),position:=""
	for a,b in ecp
	position.=" " a b " "
	Gui,45:Show,% position
	var({current:{options:m,menu:mm,atts:att,control:c,type:type}})
	return
	ecup:
	gosub ecu
	position:=var("ecpos")
	for a,b in selected_controls()
	GuiControl,1:MoveDraw,% a,%position%
	showhighlight(),undo()
	return
	ecu:
	m:=var("current"),values:=m.values,menu:=m.menu,type:=m.type,c:=xg({gui:"//*[@hwnd='" var("right").control "']"})
	toggleoptions(xg({gui:"//*[@hwnd='" var("right").control "']/@options"}).text,onoff)
	Gui,45:Default
	Gui,ListView,SysListView321
	rownumber:=0,optionlist:=""
	while,RowNumber:=LV_GetNext(RowNumber,"C")
	lv_gettext(value,rownumber,2),optionlist.=value " "
	options:=trim(optionlist)
	c.SetAttribute("options",options)
	toggleoptions(options,1),Redraw(),position:=""
	con:=var("right").control
	pos:=easyatt(c)
	toggleoptions(pos.style,0)
	redraw()
	Gui,ListView,SysListView322
	while,v:=menu.item[A_Index-1]{
		LV_GetText(value,A_Index),val:=ssn(v,"@value").text
		if (val="value")
		name:=value
		c.SetAttribute(val,value)
		if val in x,y,w,h
		if value
		position.=val value " "
		if val in w,h
		if value
		size.=val value " "
		if InStr(val,"style")
		style:=value
	}
	var({ecpos:size})
	GuiControl,1:MoveDraw,% var("right").control,%position%
	if type=listview
	return update_changed_columns(var("right").control,name),undo()
	if type in tab,ListBox,ComboBox,DDL,DropDownList,Tab2
	{
		GuiControl,1:,% var("right").control,|%name%
		return undo()
	}
	con:=var("right").control
	ss:=style
	GuiControl,1:,%con%,%name%
	if ss
	GuiControl,1:%ss%,%con%
	undo(),showhighlight(),Redraw()
	return
	ecedit:
	Gui,45:Default
	if A_GuiEvent!=Normal
	return
	m:=var("current"),values:=m.values,menu:=m.menu,type:=m.type
	LV_GetText(setting,LV_GetNext(),2),LV_GetText(list,LV_GetNext(),1)
	if InStr(setting,"name of"){
		if (type="TreeView")
		return treeview(1)
		if (RegExMatch(type,"i)(ListView|ListBox|Tab|ComboBox|DropDownList|DDL)"))
		return list_editor(list)
		if (type="TreeView")
		return treeview(1)
		if (type="Picture")
		return picture(list,setting)
	}
	ControlSend,SysListView322,{f2},% hwnd([45])
	return
	45GuiClose:
	45GuiEscape:
	win:=getwinpos(x,y,w,h,WinActive()),xadd("settings","EditControl",{x:x,y:y})
	Gui,45:Destroy
	return
}
setguifont(x){
	style:=easyatt(xg({settings:"//font"})),style.color:=RGB(style.color)
	Gui,%x%:Font,% compilefont(style),% style.name
}
toggleoptions(options,onoff){
	static
	con:=var("right").control
	if !onoff
	loop,Parse,options,%A_Space%
	{
		if InStr(A_LoopField,"-"),value:=SubStr(A_LoopField,2)
		GuiControl,1:+%value%,%con%
		else
		GuiControl,1:-%A_LoopField%,%con%
	}
	else
	loop,Parse,options,%a_space%
	{
		if InStr(A_LoopField,"-")
		value:=SubStr(A_LoopField,2),oper:="-"
		if InStr(A_LoopField,"+")
		value:=SubStr(A_LoopField,2),oper:="+"
		if A_LoopField not contains +,-
		oper:="+",value:=A_LoopField
		GuiControl,1:%oper%%value%,%con%
	}
	return
}
update_changed_columns(x,list){
	Gui,1:Default
	Gui,1:ListView,%x%
	while,LV_GetText(out,0,1)
	lv_deletecol(1)
	loop,parse,list,|
	if A_LoopField
	LV_InsertCol(A_Index,"autohdr",A_LoopField)
	lv_modifycol(1,"autohdr")
}
list_editor(list){
	Gui,46:Destroy
	Gui,46:+hwndhwnd
	hwnd(46,hwnd)
	Gui,46:Add,ListView,w400 h600 Multi -ReadOnly AltSubmit gle,Value
	for a,b in {delsel:"Delete Selected",addedit:"Add"}
	{
		default:=a="addedit"?"Default":""
		Gui,46:add,Button,g%a% %Default%,%b%
	}
	Gui,46:Add,Button,gleup,Update
	Gui,46:Default
	Loop,Parse,list,|
	LV_Add("",A_LoopField)
	Gui,46:Show
	return
	delsel:
	if A_GuiEvent!=Normal
	return
	list:=[]
	while,rownumber:=LV_GetNext()
	LV_Delete(rownumber)
	return
	addedit:
	num:=LV_Add("")
	ControlFocus,SysListView321,% hwnd([46])
	LV_Modify(num,"focus")
	ControlSend,SysListView321,{f2},% hwnd([46])
	return
	le:
	return
	leup:
	list:=""
	Loop,% LV_GetCount()
	LV_GetText(value,A_Index),list.=value "|"
	Gui,45:Default
	Gui,ListView,SysListView322
	LV_Modify(LV_GetNext(),"Col1",Trim(list,"|"))
	Gui,46:Destroy
	return
	46GuiEscape:
	Gui,46:Destroy
	return
}
window_options(){
	static
	Gui,88:Destroy
	setguifont(88)
	Gui,88:+hwndhwnd
	hwnd(88,hwnd)
	list:=""
	static replace:={SysMenu:"-SysMenu",MaximizeBox:"-MaximizeBox",MinimizeBox:"-MinimizeBox",Disabled:"+Disabled",AlwaysOnTop:"+AlwaysOnTop",Border:"+Border",Caption:"-Caption",Resize:"+Resize"}
	maininfo:=xg({gui:"//show"}),list.=ssn(maininfo,"@options").text,list.=" " ssn(maininfo,"@show").text
	show:=xg({constants:"//Show/show"})
	for b,a in {constants:"options",info:"info"}
	{
		%a%:=sn(show,b "/*"),rows:=%a%.length
		Gui,88:Add,ListView,r%rows% w600 Checked,Set|Value|Description
		Gui,88:Default
		while,v:=%a%.item[A_Index-1]
		value:=ssn(v,"@value").text,newval:=replace[value]?replace[value]:value,check:=InStr(list,value)?"Check":"",LV_Add(check,"",newval,ssn(v,"@desc").text)
		loop,3
		LV_ModifyCol(A_Index,"autohdr")
	}
	edits:={1:"Window Title",2:"Window Number"}
	for b,a in edits
	{
		Gui,Add,Text,xm,%a%:
		text:=A_Index=1?xg({gui:"//show/@title"}).text:xg({gui:"//show/@number"}).text,number:=b=2?"number Limit2 w100":"w300"
		Gui,Add,Edit,gwov x+0 %number%,%text%
	}
	Gui,Add,Button,gwou Default xm,Update
	Gui,88:Show,,Window Options
	;t("needs some other options if you get to it like delimeter and owner...")
	return
	wou:
	options:=show:="",s:=xg({gui:"//show"})
	Gui,88:Default
	for a,b in {SysListView321:"options",SysListView322:"show"}{
		Gui,88:ListView,%a%
		rownumber:=0,list:=""
		while,RowNumber:=LV_GetNext(RowNumber,"C")
		lv_gettext(value,rownumber,2),list.=value " "
		s.SetAttribute(b,list)
	}
	Gui,88:Destroy
	return
	wov:
	s:=xg({gui:"//show"}),f:={Edit1:"title",Edit2:"number"}
	ControlGetFocus,focus,% hwnd([88])
	s.setattribute(f[focus],A_GuiControl)
	return
	88GuiEscape:
	Gui,88:Destroy
	return
}
picture(x="",y=""){
	FileSelectFile,Picture,,,Select a picture to use
	if ErrorLevel
	return
	if !x
	return picture
	Gui,97:Destroy
	Gui,97:+hwndpic
	Gui,97:Add,Picture,hwndphwnd,%picture%
	Gui,97:show,Hide
	g:=getconpos(phwnd)
	Gui,97:Destroy
	Gui,45:Default
	Gui,45:ListView,SysListView322
	Loop,% LV_GetCount()
	{
		LV_GetText(info,A_Index,2)
		if InStr(info,"Control width")
		LV_Modify(A_Index,"",g.w,info)
		if InStr(info,"Control height")
		LV_Modify(A_Index,"",g.h,info)
	}
	LV_Modify(LV_GetNext(),"",picture,y)
}
control_borders(){
	load(xget("gui"))
}
quick_help(){
	nag:=xg({settings:"//Nag"}).text
	if (nag&&A_ThisLabel="")
	return
	quickhelp:
	qh=Hold down shift to resize a control
	,`nUndo hotkey Control+z and Redo hotkey Shift+Control+z or Control+y
	,`nHold down control while resizing to resize proportionally`nCreating Tabs and controls on those tabs works:
	,`n1.Either right click to add the control on the current tab
	,`n2.Your mouse must be over the tab you want the control on prior to hitting the hotkey`nSelect controls you would like to delete and press either backspace or delete.
	,`nQuick Menu (press Ctrl-Q)
	,`n`nShow again next run?
	MsgBox,4,Quick Help,%qh%
	IfMsgBox no
	xadd("settings","Nag",0,1)
	IfMsgBox Yes
	xadd("settings","Nag",0,0)
	return
}
copy_width(){
	right:=var("right")
	if !right.Control
	exit m("You must right click on the control you wish to copy the values from")
	con:=getconpos(right.control)
	for a,b in selected_controls()
	checkmove(a,,,con.w)
	showhighlight(),Redraw()
}
copy_height(){
	right:=var("right")
	con:=getconpos(right.control)
	if !right.Control
	exit m("You must right click on the control you wish to copy the values from")
	for a,b in selected_controls()
	checkmove(a,,,,con.h)
	showhighlight(),Redraw()
}
copy_height_and_width(){
	copy_width(),copy_height()
}
duplicate_selected(){
	sel:=selected_controls(),all:=getallpos(hwnd(1)),gui:=xget("gui"),pi:=posinfo(),type:=sn(gui,"//*[@type]")
	offset:=pi.w.maxindex()-pi.x.minindex()+10
	while,node:=type.item[A_Index-1]
	{
		t:=ssn(node,"@type").text
		hwnd:=ssn(node,"@hwnd").text
		if !sel[hwnd]
		continue
		ea:=easyatt(node)
		g:=grid(ea.x+offset,0,1),ea.x:=g.x
		hwnd:=add_control(ea)
	}
}
copy_selected(){
	gui:=xget("gui"),type:=sn(gui,"//*[@type]"),list:=[],sel:=selected_controls(),pi:=posinfo()
	var({minx:pi.x.minindex(),miny:pi.y.minindex()})
	while,node:=type.item[A_Index-1]
	{
		t:=ssn(node,"@type").text
		hwnd:=ssn(node,"@hwnd").text
		if !sel[hwnd]
		continue
		list[A_Index]:=easyatt(node)
	}
	var({coppied:list})
}
paste_selected(){
	right:=var("right")
	minx:=var("minx"),miny:=var("miny")
	if (A_ThisLabel="paste_selected")
	MouseGetPos,x,y
	else
	x:=right.x,y:=right.y
	grid(x,y)
	for a,b in var("coppied"){
		bx:=b.x,by:=b.y
		offx:=b.x-minx+x,offy:=b.y-miny+y
		b.x:=offx,b.y:=offy
		add_control(b)
		b.x:=bx,b.y:=by
	}
}
space_evenly_vertical(){
	p:=posinfo(),min:=p.y.minindex(),max:=p.h.maxindex(),th:=p.th
	for a,b in selected_controls()
	count:=A_Index-1
	spaces:=(max-min-th)/count
	spaces:=spaces<0?0:spaces
	for a in p.h{
		for b,c in p.h[a]{
			cc++
			if cc=1
			{
				start:=c.y+c.h
				continue
			}
			checkmove(b,,start+spaces)
			start+=spaces+c.h
		}
	}
	showhighlight()
}
space_evenly_horizontal(){
	p:=posinfo(),min:=p.x.minindex(),max:=p.w.maxindex(),tw:=p.tw
	for a,b in selected_controls()
	count:=A_Index-1
	spaces:=(max-min-tw)/count
	spaces:=spaces<0?0:spaces
	for a in p.w{
		for b,c in p.w[a]{
			cc++
			if cc=1
			{
				start:=c.x+c.w
				continue
			}
			checkmove(b,start+spaces)
			start+=spaces+c.w
		}
	}
	showhighlight()
}
center_horizontally(){
	p:=posinfo(),min:=p.x.minindex(),max:=p.w.maxindex(),pos:=var("pos")
	getwinpos(x,y,w,h,hwnd(1))
	ow:=w-(max-min)
	space:=ow/2
	offset:=space-min
	for a,b in selected_controls()
	p:=getconpos(a),checkmove(a,p.x+offset+pos.border)
	showhighlight(),Redraw()
}
center_vertically(){
	p:=posinfo(),min:=p.y.minindex(),max:=p.h.maxindex(),pos:=var("pos")
	getwinpos(x,y,w,h,hwnd(1))
	oh:=h-(max-min)
	space:=oh/2
	offset:=space-min
	for a,b in selected_controls()
	p:=getconpos(a),checkmove(a,,p.y+offset+pos.border+pos.Caption)
	showhighlight(),Redraw()
}
center_in_window(){
	center_vertically(),center_horizontally()
}
disable_lists(){
	load(xget("gui"))
}
export(export=""){
	doc:=xget("Constants"),const:=doc.SelectSingleNode("//Constants/info"),getwinpos(x,y,w,h,hwnd(1))
	gui:=xget("gui"),count=0
	cc:=sn(doc,"//Constants/info/*")
	lastfont:="Gui,Font," compilefont(easyatt(c)) "," font "`n"
	allcon:=sn(gui,"//@type"),count:=0,glist:=[],vlist:=[],conflict:=[],total:="#SingleInstance,force`n"
	if options:=ssn(gui,"//show/@options").text
	total.="Gui," options "`n"
	while,c:=ssn(allcon.item[a_index-1],".."){
		list=
		ee:=easyatt(c)
		if RegExMatch(ee.type,"i)(ComboBox|DDL|DropDownList)")
		c.SetAttribute("h","")
		tn:=ssn(c,"@tabnum").Text
		if (tn!=lasttn&&count)
		total.="Gui,Tab," tn "," count "`n"
		fontname:=ssn(c,"@font").Text,font:="Gui,Font," compilefont(easyatt(c)) "," fontname "`n"
		if (font!=lastfont&&fontname)
		total.="Gui,Font," compilefont(easyatt(c)) "," fontname "`n"
		if (font!=lastfont&&fontname="")
		total.="Gui,Font`n"
		if ee.g
		glist[ee.g]:=ee.g
		if ee.v
		vlist[ee.v]:=ee.v
		type:=ssn(c,"@type").text,ccc:=sn(doc,"//Controls/" type "/constants/*[@value]")
		for a,b in {ccc:ccc,cc:cc}
		while,v:=b.item[A_Index-1],val:=ssn(v,"@value").text
		if (val!="value"&&ssn(c,"@" val).text!="")
		if (val="Style"&&ssn(c,"@" val).text)
		list.=ssn(c,"@" val).text " "
		else
		list.=val ssn(c,"@" val).text " "
		if InStr(type,"tab")
		count++
		list:=Trim(list)
		options:=ee.options?" " ee.options:""
		total.="Gui,Add," type "," list options "," ssn(c,"@value").text "`n"
		if type=TreeView
		{
			if xg({gui:"//show/@number"}).text
			total.="Gui,Default`n"
			total.="TV_Add(" chr(34) type chr(34) ")`n"
		}
		lastfont:="Gui,Font," compilefont(easyatt(c)) "," fontname "`n"
		lasttn:=tn
	}
	for a,b in vlist
	{
		con:=sn(gui,"//*[@v='" a "']")
		if con.length>1
		while,hwnd:=con.item[A_Index-1].SelectSingleNode("@hwnd").text
		conflict[hwnd]:=hwnd
	}
	if conflict.minindex()
	selected_controls(conflict),showhighlight(),m("The selected controls share the same variable.  Please change them.")
	title:=xg({gui:"//show/@title"}).text
	options:=xg({gui:"//show/@show"}).text
	total.="Gui,Show,x" x " y" y " w" w " h" h " " options "," title "`n"
	number:=xg({gui:"//show/@number"}).text
	if number
	total:=RegExReplace(total,"i)Gui,","Gui," number ":")
	for a,b in glist
	total.=a ":`nreturn`n"
	StringReplace,total,total,`n,`r`n,All
	if xg({settings:"//Add_Spaces_to_Output"}).Text
	total:=RegExReplace(total,","," , ")
	if export
	return total
	over:=xg({settings:"//Warn_Overwrite"}).Text?"S16":"S"
	if !filename
	FileSelectFile,filename,%over%,,Export Gui Structure as...,*.ahk
	if ErrorLevel
	return
	if xg({settings:"//Add_Spaces_"}).Text?"S16":"S"
	filename:=InStr(filename,".ahk")?filename:filename ".ahk"
	filedelete,%filename%
	FileAppend,%total%,%filename%
}
test_gui(){
	program:=export(1)
	FileDelete,temp.ahk
	FileAppend,%program%,temp.ahk
	run,temp.ahk
}
set_offsets(){
	static
	offset:=xg({settings:"//Offset"})
	x:=ssn(offset,"@x").text!=""?ssn(offset,"@x").text:2
	y:=ssn(offset,"@y").text!=""?ssn(offset,"@y").text:0
	sysget,caption,4
	sysget,border,32
	caption+=Border
	Gui,56:Destroy
	Gui,56:+Owner1
	Gui,56:Add,Text,,Make sure that you have at least one control in the main window near the top corner.`nAdjust the values and press Update Alignment.
	Gui,56:Add,Text,,Offset value for X
	Gui,56:Add,Edit,w50 vx x+10,%x%
	Gui,56:Add,UpDown,range-5-5
	Gui,56:Add,Text,x10,Offset value for Y
	Gui,56:Add,Edit,w50 vy x+10,%y%
	Gui,56:Add,UpDown,range-5-5
	Gui,56:Add,Button,galignall,Update Alignment
	Gui,56:Show,,Set Offset
	ControlSetText,Edit1,%x%,Set Offset
	ControlSetText,Edit2,%y%,Set Offset
	return
	alignall:
	Gui,56:Submit,NoHide
	Gui,1:Default
	xadd("settings","Offset",{x:x,y:y})
	select_all(),align_selected_to_grid(),xsave("settings")
	return
}
copy_code_to_clipboard(){
	Clipboard:=export(1)
	MsgBox,,Code Coppied,Code coppied to clipboard,1
}
import(program=""){
	doc:=xget("Constants"),const:=doc.SelectSingleNode("//Constants/info"),attributes:=attlist(const.SelectNodes("*/@value")),controls:=constants("controls")
	if !program
	{
		FileSelectFile,filename,,,,*.ahk
		FileRead,program,%filename%
		if ErrorLevel
		return
	}
	reset(),gui(2)
	Loop,Parse,program,`n,`r`n
	{
		RegExReplace(A_LoopField,",","",count),search:=""
		Loop,% Count
		search.=",(.*)"
		RegExMatch(A_LoopField,"O)" search,v)
		Loop,%Count%
		if RegExMatch(trim(v.1),"(.*):(.*)",win)
		number:=win1?Trim(win1):number,action:=win2
		else if v.1
		action:=trim(v.1)
		info:=v.3?trim(v.3):""
		if InStr(action,"tab")
		tabnum:=v.2,tab:=v.3
		if InStr(action,"font")
		if !v.3
		style:="",font:=""
		else
		font:=v.3,style:=v.2
		if (action="add"){
			vv:=constants("Controls")[Trim(v.2)]
			con:=doc.SelectSingleNode("//" controls[vv]),option:=attlist(con.SelectNodes("info/*/@value")),c:=attlist(con.SelectNodes("constants/*/@value")),cc:=attlist(const.SelectNodes("*/@value")),pos:=[]
			Loop,Parse,info,%A_Space%
			{
				if option[A_LoopField]{
					options.=option[A_LoopField] " "
					continue
				}
				for c,d in {c:c,cc:cc}
				for a,b in d
				if RegExMatch(A_LoopField,"iA)" a "(.*)\b",found)
				pos[a]:=found1
			}
			if Style
			splitfont(style,pos),pos["font"]:=font
			for a,b in {options:Trim(options),control:trim(vv),value:trim(v.4),type:trim(vv)}
			pos[a]:=b
			if tabnum
			pos["tab"]:=tab,pos["tabnum"]:=tabnum
			add_control(pos)
			options=
		}
		if (action="show"){
			where:=v.2,list:=[],pos:=[],option:="",ll:="",title:=info
			nodes:=compilenodes(sn(xg({constants:"//Show/show/constants"}),"*/@value"))
			show1:=xg({constants:"//Show/show/info"})
			v:=sn(show1,"*/@value")
			while,q:=v.item[A_Index-1].text
			list[q]:=q
			Loop,Parse,where,%A_Space%
			if list[A_LoopField]
			options.=list[A_LoopField] " "
			for a,b in nodes
			ll.=a "|"
			if RegExMatch(program,"i)(.*)(" trim(ll,"|") ")",found)
			for a,b in nodes
			if InStr(found,a)
			show.=a " "
			for a,b in {show:show,options:options,number:number,title:title}
			pos[a]:=b
			for a,b in constants("show")
			if InStr(A_LoopField,b)
			so.=b " "
			for a,b in constants("pos")
			if RegExMatch(where,"Ui)\b" a "(.*)\b",p)
			position.=a p1 " ",pos[a]:=p1
			Gui,Show,%position%
			xadd("gui","show",pos)
		}
		action:=""
	}
	undo()
	return
}
attlist(node){
	val:=[]
	while,v:=node.item[A_Index-1]
	val[v.text]:=v.text
	return val
}
splitfont(font,pos){
	RegExMatch(font,"iU)s(.*)\b",size)
	pos["size"]:=size1
	RegExMatch(font,"iU)c(.*)\b",size)
	pos["color"]:=size1
	for a,b in {bold:1,italic:1,strikeout:1,underline:1}
	if InStr(font,a)
	pos[a]:=1
	return pos
}
compilenodes(node){
	n:=[]
	while,v:=node.item[A_Index-1]
	n[v.text]:=v.text
	return n
}
default_size(type,pos){
	if Default:=xg({settings:"//Default/" type}).text
	{
		RegExReplace(Default,"[^0-9]"," ",count)
		find:=count?"(.*)[^0-9](.*)":"(.*)"
		RegExMatch(Default,"O)" find,out)
		p:=count?{w:out.1,h:out.2}:{w:out.1}
		for a,b in p
		pos.Insert(a,b)
	}
	return pos
}
version(){
	SplashTextOn,200,50,Please wait,Downloading latest information
	URLDownloadToFile,http://www.autohotkey.net/~maestrith/creatorbeta/GUI Creator.text,version.txt
	SplashTextOff
	FileRead,ver,version.txt
	Gui,55:Destroy
	Gui,55:+hwndhwnd +Resize +Owner1
	setguifont(55)
	hwnd(55,hwnd)
	Gui,55:Add,Edit,w500 h500,%ver%
	Gui,55:Add,Button,gverupdate w500,Update
	shapeset(55,{Edit1:"wh",Button1:"yw"},hwnd)
	Gui,55:Show,% getwinpos(0,0,0,0,hwnd(1)),% "Version: " gui(1)
	return
	verupdate:
	ext:=A_IsCompiled?".exe":".ahk"
	m("You will be prompted to save your current gui....if you do not do so you will lose all edited data")
	save()
	FileMove,%A_ScriptFullPath%,% "Backup_" gui(1) ext
	URLDownloadToFile,http://www.autohotkey.net/~maestrith/creatorbeta/GUI Creator%ext%,GUI Creator%ext%
	run,GUI Creator%ext%
	ExitApp
	return
	version:
	version()
	return
}
Import_From_Clipboard(){
	import(Clipboard)
}
;Gui,3:Add,Button,,Hi
;Gui,3:Show,xcenter ycenter,Hi
reorder_code(){
	gui:=xget("gui")
	allcon:=sn(gui,"//gui/control/control/@type/..")
	Gui,47:Destroy
	Gui,47:+hwndhwnd
	hwnd(47,hwnd),setguifont(47)
	Hotkey,IfWinActive,% hwnd([47])
	for a,b in {up:1,down:1}
	Hotkey,%a%,rcmv,On
	Gui,47:Default
	size:=xg({settings:"//font/@size"}).text
	size:=size?size:8
	w:=(size*1.5)*2+500
	Gui,Add,Tab,w%w% r26,Controls outside of Groupboxes and Tabs|Groupboxes|Tabs
	Gui,Tab,1
	Gui,47:Add,Text,,Controls outside of Groupboxes and Tabs
	Gui,47:Add,ListView,w500 r25 NoSort gselect AltSubmit,Control|Type|HWND
	while,ac:=allcon.item[A_Index-1]
	v:=easyatt(ac),LV_Add("",v.value,v.type,v.hwnd)
	Loop,3
	LV_ModifyCol(A_Index,"AutoHDR")
	Gui,Tab,2
	Gui,47:Add,Text,,Groupboxes
	allcon:=sn(gui,"//gui/groupbox/*[@type/..]")
	rows:=allcon.length
	Gui,47:Add,ListView,w500 r%rows% NoSort gselect AltSubmit,Control|Type|HWND
	while,v:=allcon.item[A_Index-1]{
		v:=easyatt(v),LV_Add("",v.value,v.type,v.hwnd)
		Loop,3
		LV_ModifyCol(A_Index,"AutoHDR")
	}
	Gui,47:Add,Text,,% "Controls in Groupbox.`nSelect a GroupBox above to see the controls"
	Gui,47:Add,ListView,w500 r10 NoSort gselect AltSubmit,Control|Type|HWND
	Gui,Tab,3
	Gui,47:Add,Text,,Tabs
	Gui,47:Add,ListView,w500 r5 NoSort gselect  AltSubmit,Value|Type|HWND
	Gui,Add,Text,,Tab Number
	allcon:=sn(gui,"//gui/tab/*[@type]")
	while,v:=allcon.item[A_Index-1]{
		v:=easyatt(v),LV_Add("",v.value,v.type,v.hwnd)
		Loop,3
		LV_ModifyCol(A_Index,"AutoHDR")
	}
	Gui,47:Add,ListView,w500 r5 NoSortHdr Sort gselecttab AltSubmit,Tab Number
	Gui,Add,Text,,Controls on selected Tab
	Gui,Add,ListView,w500 r10 NoSort gselect AltSubmit,Value|Type|HWND
	Gui,47:Show,AutoSize
	return
	selecttab:
	if A_GuiEvent!=Normal
	return
	Gui,47:Default
	Gui,ListView,SysListView324
	LV_GetText(hwnd,LV_GetNext(),3)
	Gui,ListView,SysListView325
	LV_GetText(tab,LV_GetNext(),1)
	GuiControl,1:Choose,%hwnd%,%tab%
	selected_controls({}),showhighlight()
	allcon:=sn(xget("gui"),"//*[@hwnd='" hwnd "']/*[@tab='" tab "']/*|//*[@hwnd='" hwnd "']/*[@tab='" tab "']/*/*")
	Gui,ListView,SysListView326
	LV_Delete()
	while,v:=allcon.item[A_Index-1]{
		ee:=easyatt(v)
		LV_Add("",ee.value,ee.type,ee.hwnd)
		Loop,3
		LV_ModifyCol(A_Index,"AutoHDR")
	}
	return
	select:
	if A_GuiEvent not in Normal
	return
	ControlGetFocus,con,% hwnd([47])
	Gui,47:Default
	Gui,47:ListView,%con%
	LV_GetText(hwnd,LV_GetNext(),3)
	sel:=[]
	x=0
	while x:=LV_GetNext(x)
	LV_GetText(hwnd,x,3),sel[hwnd]:=hwnd
	selected_controls(sel),showhighlight()
	if con=SysListView322
	{
		allcon:=sn(xget("gui"),"//*[@hwnd='" hwnd "']/*")
		Gui,47:ListView,SysListView323
		LV_Delete()
		while,v:=allcon.item[A_Index-1]{
			ee:=easyatt(v)
			LV_Add("",ee.value,ee.type,ee.hwnd)
			Loop,3
			LV_ModifyCol(A_Index,"AutoHDR")
		}
	}
	if con=SysListView324
	{
		allcon:=sn(xget("gui"),"//*[@hwnd='" hwnd "']/*")
		Gui,47:ListView,SysListView325
		LV_Delete()
		while,v:=allcon.item[A_Index-1]{
			ee:=easyatt(v)
			LV_Add("",ee.tab)
			Loop,3
			LV_ModifyCol(A_Index,"AutoHDR")
		}
		Gui,47:ListView,SysListView326
		LV_Delete()
	}
	return
	47GuiEscape:
	Gui,47:Destroy
	return
	rcmv:
	ControlGetFocus,con,% hwnd([47])
	Gui,47:Default
	Gui,47:ListView,%con%
	move_item(A_ThisHotkey)
	return
}
move_item(direction){
	gui:=xget("gui")
	line:=LV_GetNext(),inc:=direction="down"?1:-1,sel:=[]
	if (direction="up"&&line=1)||line=0
	return
	while x := LV_GetNext(x)
	sel.insert(x)
	for a,b in Sel{
		cur:=direction="down"?sel[sel.maxindex()-a_index+1]:b,next:=cur+inc
		if (sel[sel.maxindex()]=LV_GetCount()&&direction="down")
		return
		Loop,% LV_GetCount("col")
		LV_GetText(v,cur,A_Index),LV_GetText(v1,next,A_Index),LV_Modify(cur,"Col" a_index,v1),LV_Modify(next,"Col" a_index,v)
		LV_Modify(cur,"-select"),LV_Modify(next,"select")
	}
	loop,% LV_GetCount()
	LV_GetText(hwnd,A_Index,3),ssn(gui,"//*[@hwnd='" hwnd "']..").AppendChild(ssn(gui,"//*[@hwnd='" hwnd "']"))
	undo()
}