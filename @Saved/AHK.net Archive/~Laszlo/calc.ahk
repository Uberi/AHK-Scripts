; Popup AHK calculator v.3.1
; Works with AHK 1.0.47.04 and 1.0.47.05
; Includes lexikos' lowlevel functions (http://www.autohotkey.com/forum/viewtopic.php?t=26300)

#SingleInstance Force
#NoEnv
SetBatchLines -1
Process Priority,,High

__help =
(Join`r`n
Calculator Shortcuts:
   Esc:    Clear expression
   Home/End/BS/Del... Edit expression
   Up/Dn:  Next entry in history, which starts with current exp
   PgUp/PgDn: Move in exp history
   Ctrl-Home/End: 1st/Last history entry
   Alt-V/Enter: eValuate expression
   Alt-H/F1: Help
   Alt-E:    Edit history Start/Stop
   Alt-S:    Save history
   Alt-L:    Load history
   Ctrl-F1:  Find function under cursor highlighted in Help

Array Lists:
   Delayed double click: edit value
   Context menu: More, Less, refresh
   Enter, Alt-M: Moore (add new entry, Enter accepts)
   Alt-L: Less (delete last etry)
   Alt-R: Refresh (take over array changes)

Graph:
   Mouse cursor: crosshair with ToolTip (x,y)
   Right-click: MsgBox with current (x,y), ClipBoard copy: Ctrl-C

Basic constructs:
   ; : separator between expressions
   '..', "..", `word : quoated strings
   :=, +=, -=, *=, /=, //=, .=, |=, &=, ^=, >>=, <<= : assignments
   +, -, /, //, *, ** : arithemtic operators
   ~, &, |, ^, <<, >> : bitwise operators (shift is 64-bit signed)
   !, &&, || : logical operators
   . : string concatenation
   "c ? a : b" : ternary operator
   <, >, =, ==, <=, >=, <> (or !=) : relational operators
   ++, -- : pre- and post-increments

AHK Built-in variables:
    A_WorkingDir, A_ScriptDir, A_ScriptName, A_ScriptFullPath
    A_AhkVersion, A_AhkPath,
    A_YYYY, A_MM, A_DD, A_MMMM, A_MMM, A_DDDD, A_DDD, A_WDay, A_YDay
    A_YWeek, A_Hour, A_Min, A_Sec, A_MSec, A_Now, A_NowUTC, A_TickCount

    ComSpec, A_Temp, A_OSType, A_OSVersion, A_Language, A_ComputerName
    A_UserName, A_WinDir, A_ProgramFiles, A_AppData, A_AppDataCommon
    A_Desktop, A_DesktopCommon, A_StartMenu, A_StartMenuCommon
    A_Programs, A_ProgramsCommon, A_Startup, A_StartupCommon
    A_MyDocuments, A_IsAdmin, A_ScreenWidth, A_ScreenHeight, A_IPAddress1..4

AHK functions:
   InStr(Haystack, Needle [, CaseSensitive = false, StartingPos = 1])
   SubStr(String, StartingPos [, Length])
   StrLen(String)
   RegExMatch(Haystack, NeedleRegEx [, OutputVar = "", StartingPos = 1])
   RegExReplace(Hstck,Ndle[,Rpmnt="",OutVarCnt="",Limit=-1,StartPos=1])

   FileExist(FilePattern)
   WinExist([WinTitle, WinText, ExcludeTitle, ExcludeText])
   DllCall()

   NumGet(VarOrAddress [, Offset = 0, Type = "UInt"])
   NumPut(Number, VarOrAddress [, Offset = 0, Type = "UInt"])
   VarSetCapacity(UnquotedVarName [, RequestedCapacity, FillByte])

   Asc(String), Chr(Number)
   Abs(), Ceil(), Exp(), Floor(), Log(), Ln(), Mod(x,m), Round(x[,N]), Sqrt()
   Sin(), Cos(), Tan(), ASin(), ACos(), ATan()

General Functions:
   b("bits") : string of bits to number, Sign = MS_bit
   list(vector) : Edit/Sort ListView of elements. Build: Enter-value-Enter
      RightClick menu: More (Enter, Alt-M: add new); Less (Alt-L: del last)
   msg(x) : MsgBox `% x

   sign(x) : the sign of x (-1,0,+1)
   rand(x,y) : random number in [x,y]; rand(x) new seed=x.

Float Functions:
   f2c(f) : Fahrenheit -> Centigrade
   c2f(c) : Centigrade -> Fahrenheit

   fcmp(x,y, tol) : floating point comparison with tolerance
   ldexp(x,e) : load exponent -> x * 2**e
   frexp(x, e) : -> scaled x to 0 or [0.5,1); e <- exp: x = frexp(x) * 2**e

   cot(x),  sec(x),  cosec(x)  : trigonometric functions
   acot(x), asec(x), acosec(x) : arcus (inverse) trigonometric functions
   atan2(x,y) : 4-quadrant atan

   sinh(x), cosh(x), tanh(x), coth(x)  : hyperbolic functions
   asinh(x),acosh(x),atanh(x),acoth(x) : inverse hyperbolics

   cbrt(x) : signed cubic root
   quadratic(x1, x2, a,b,c) : -> #real roots {x1,x2} of ax?+bx+c
   cubic(x1, x2, x3, a,b,c,d) :->#real roots {x1,x2,x3} of axl+bx?+cx+d

Integer functions:
   LCM(a,b) : Least Common Multiple
   GCD(a,b) : Euclidean Greatest Common Divisor
   xGCD(c,d, x,y) : eXtended GCD (returned), compute c,d: GCD = c*x + d*y

   Choose(n,k) : Binomial coefficient. "n.0" force floating point arithmetic
   Fib(n) : n-th Fibonacci number (n < 0 OK, iterative to avoid globals)
   fac(n) : n!
   IsPrime(p) : primality test 0/1

   ModMul(a,b, m) : unsigned a*b mod m, no overflow till a*b < 2**127
   ModPow(a,e, m) : unsigned a**e mod m, no overflow
   uMod(x,m) : unsigned x mod m
   uCmp(a,b) : unsigned 64-bit compare a <,=,> b: -1,0,1
   MsMul(a,b) : Most Significant UInt64 of a*b
   Reci64(m [, ByRef ms]) : Int64 2**ms/m: normalized (negative); unsigned m
   MSb(x) : Most  Significant bit: 1..64, (0 if x=0)
   LSb(x) : Least Significant bit: 1..64, (0 if x=0)

Iterators/Evaluators
   eval(expr) : evaluate ";" separated expressions, [.] index OK
   call(FName,p1=""...,p10="") : evaluate expression in FName,
      sets variables FName1:=p1, FName2:=p2...
   solve('x',x0,x1,'expr'[,tol]) : find 'x' where 'expr' = 0
   fmax('x',x0,x1,x2,'expr'[,tol])) : 'x' where 'expr' = max

   for(Var,i0,i1,d,expr) : evaluate all, return result of last
      {expr(Var:=i0),expr(Var:=i0+d)...}, until i1
   while(cond,expr) : evaluate expr while cond is true; -> last result
   until(expr,cond) : evaluate expr until cond gets true (>= once); -> last

Array creating functions (-> X="X", X_0=length, X_1,X_2... entries):
   copy("X",Y) : duplicates Y
   seq("X",i0,i1[,d=1]) : set up linear sequence X = {i0,i0+d..,i1}
   array("X","i",i0,i1,d, "expr") : X = {expr(i:=i0),expr(i:=i0+d)..,expr(i~=i1)}
   assign("X",entry1...) : assign (<=30) new entries to the of array X
   more("X",entry1...) : add (<=30) new entries to the of array X
   part("Y",X,i0,i1[,d=1]) : Y (!= X) <- {X[i0],X[i0+d]..,X[~i1]}
   join("Z",X,Y) : Z <- join arrays {X,Y}, (Z != X or Y)

   @("Z",X,"op|func",Y="") : elementwise ops, 0-pad; Y or X can be scalar
   plmul("z",y,x) : z <- polynomial y*x (convolution, FIR filter)
   pldiv("q","r",n,d) : polynomial division-mod: q <- n/d; r <- mod(n,d)

   sort("y",x[.opt]) : y <- sorted array x
      opt = 0: random, 1: no duplicates, 2: reverse, 3: reverse+unique
   primes("p",n) : p <- primes till n (Sieve of Eratosthenes)
   pDivs("d",n) : d <- prime divisors of n (increasing)

Vector -> scalar functions
   mean(X), std(X), moment(k,X) : statistics functions
   sum(X), prod(X), sumpow(k,X), dot(X,Y)
   pleval(p,x): evaluate polynomial, <- p(x), (Horner's method)

   min(x,x1=""...,x9="") : min of numbers or one vector
   max(x,x1=""...,x9="") : max of numbers or one vector
   pmean(p, x,x1=""...,x9="") : p-th power mean of numbers or one vector

Graphing functions
   graph(x0,x1,y0,y1,width=400,height=300,BGcolor=white) :
     create/change graph window to plot in, graph() destroys
   Xtick(Array=10,LineColor=gray,LineWidth=1) : add | lines at x positions
     can be called multiple times, BEFORE plot
     Array=integer : equidistant ticks, Array="" : 11 ticks
     Array=float : single line
   Ytick(Array=10,LineColor=gray,LineWidth=1) : add - lines at y positions
   plot(Y,color=blue,LineWidth=2) : add plot of Y with X = {1..len(Y)}
     if no graph paper: create default one
     plot() : erase function graphs
   plotXY(X,Y...): add XY plot to last graph
     if no graph, auto created with graph(min(X),max(X),min(Y),max(Y))

Special constructs:
   [expr] : "_" . eval(expr). x[i] = x_%i%; x[i+1]:=1 OK
   _ : last output
   _1, _2,..._9: earlier outputs (list() shows them)

Math Constants:
   pi = pi        `te   = e
   pi_2 = pi/2    `tln2 = log(2)
   pi23 = 2pi/3   `tlg2 = log10(2)
   pi43 = 4pi/3   `tlge = log10(e)
   pi2 = pi**2    `tln10= ln(10)
   rad = pi/180   `tdeg = 180/pi

Unit conversion constants (150*lb_kg -> 150 pounds = 68.0389 KG)
   inch_cm, foot_cm, mile_km
   oz_l,  pint_l,  gallon_l
   oz_g,  lb_kg
   acre_m2
)

pi  = 3.141592653589793238462643383279502884197169399375105820974944592 ; pi
pi_2= 1.570796326794896619231321691639751442098584699687552910487472296 ; pi/2
pi23= 2.094395102393195492308428922186335256131446266250070547316629728 ; 2pi/3
pi43= 4.188790204786390984616857844372670512262892532500141094633259455 ; 4pi/3
rad = 0.017453292519943295769236907684886127134428718885417254560971914 ; pi/180
deg = 57.29577951308232087679815481410517033240547246656432154916024386 ; 180/pi
pi2 = 9.869604401089358618834490999876151135313699407240790626413349374 ; pi**2
e   = 2.718281828459045235360287471352662497757247093699959574966967628 ; e
ln2 = 0.693147180559945309417232121458176568075500134360255254120680009 ; log(2)
lg2 = 0.301029995663981195213738894724493026768189881462108541310427461 ; log10(2)
lge = 0.434294481903251827651128918916605082294397005803666566114453783 ; log10(e)
ln10= 2.302585092994045684017991454684364207601101488628772976033327901 ; ln(10)

inch_cm = 2.54                                 ; inches to centimeters
foot_cm = 30.48                                ; feet to centimeters
mile_km = 1.609344                             ; miles to Kilometers
oz_l    = 0.02957352956                        ; liquid ounces to liters
pint_l  = 0.4731764730                         ; pints to liters
gallon_l= 3.785411784                          ; gallons to liters
oz_g    = 28.34952312                          ; dry ounces to grams
lb_kg   = 0.45359237                           ; pounds to Kilograms
acre_m2 = 4046.856422                          ; acres to square meters

_0 := 9                                        ; length of output history
SetFormat Float, 0.16e                         ; max precise AHK internal format
__init()                                       ; init low-level functions
SplitPath A_ScriptName,,,,__file               ; default history file
__ini  := __file . ".ini"                      ; window position, hotkeys
__file .= ".hst"                               ; default expressions history file
VarSetCapacity(__Z,30)                         ; used in graphs
GoSub LoadHistory
OnExit CleanUp
__cursor := DllCall("LoadCursor", "uint", 0, "uint", 32515)

Menu Tray, NoStandard                          ; custom tray menu
Menu Tray, Click, 1                            ; single click activates
Menu Tray, Add, Show, Calc
Menu Tray, Add, Help,  ButtonHelp
Menu Tray, Add, Edit/Hide History, ButtonEdit
Menu Tray, Add, Load History, ButtonLoad
Menu Tray, Add, Save History, ButtonSave
Menu Tray, Add, Exit, CleanUp
Menu Tray, Default, Show
Menu Tray, Icon, %A_WinDir%\system32\calc.exe  ; borrow the icon of calc.exe

Menu ListMenu, Add, More, 4ButtonMore
Menu ListMenu, Add, Less, 4ButtonLess
Menu ListMenu, Add, Refresh, 4ButtonRefresh
Menu ListMenu, Default, More

IniRead __GrWidth,  %__ini%, Graph Defaults, width,   600
IniRead __GrHeight, %__ini%, Graph Defaults, height,  400
IniRead __GRxTicks, %__ini%, Graph Defaults, xTicks,  10
IniRead __GRyTicks, %__ini%, Graph Defaults, yTicks,  10
IniRead __GrBgColor,%__ini%, Graph Defaults, BgColor, 0xFFFFFF
IniRead __GrLnColor,%__ini%, Graph Defaults, LnColor, 0xFF0000
IniRead __GrLnWidth,%__ini%, Graph Defaults, LnWidth, 2

IniRead __FontSz,%__ini%, Font, size, 11
IniRead __Font,%__ini%, Font, font, Tahoma

IniRead __CalcHK,%__ini%, Hotkeys, Calc, #c
HotKey %__CalcHK%, Calc
IniRead __VarsHK,%__ini%, Hotkeys, Vars, #d
HotKey %__VarsHK%, Vars ; DEBUG

Gui font, s%__FontSz%, %__Font%                ; Main calculator GUI
   Gui Add, Text, x9 y9,0                      ; write 0 to estimate needed size
   GuiControlGet __POS, Pos, Static1           ; metrics of "0"
   __winW := 67*__POSW                         ; room for 65 chars + margin
   __t    := 10*__POSW
   __winWW:= __winW + __t
Gui +Delimiter`n
Gui Margin, 5, 5
Gui Add, ComboBox,% "x5 y5 v__code w" . __winWW, %__history%`n`n
Gui Add, Text, cGreen y+7 w%__t%, AHK string:`n0.6gS0.17g`nIntSUint 64`nHexSZHex`nBinary
Gui Add, Edit, yp-2 x+0 -0x200000 v__res w%__winW% r5 t99 ReadOnly ; no scroll bar, tabs= dialog template units
Gui Add, Edit, w%__winW% r10 v__hist           ; history edit
Gui Add, Button, Hidden Default, e&valuate     ; hidden buttons
Gui Add, Button, Hidden, &Edit                 ; ..activated by Alt-Letter
Gui Add, Button, Hidden, &Save
Gui Add, Button, Hidden, &Load
Gui Add, Button, Hidden, &Help
GuiControl Hide, __hist                        ; hidden history

GuiControlGet __P, Pos, __res                  ; dimensions of the control __PX...

IniRead __CalcX, %__ini%, Window Positions, CalcX, % (A_ScreenWidth -__PW)//2
IniRead __CalcY, %__ini%, Window Positions, CalcY, % (A_ScreenHeight-__PH)//2
IniRead __HelpX, %__ini%, Window Positions, HelpX, 180
IniRead __HelpY, %__ini%, Window Positions, HelpY, 0
IniRead __ListX, %__ini%, Window Positions, ListX, 180
IniRead __ListY, %__ini%, Window Positions, ListY, % (A_ScreenHeight-4*__PH)//2
IniRead __GraphX,%__ini%, Window Positions, GraphX,% (A_ScreenWidth -400)//2
IniRead __GraphY,%__ini%, Window Positions, GraphY,0

Gui Show, AutoSize Hide x%__CalcX% y%__CalcY%, Evaluate AHK expression {Enter}
Gui +LastFound
WinGet __CalcID, ID
Gui -LastFound
GroupAdd __CalcGroup, ahk_id %__CalcID%
Return

Vars:
   ListVars ; for debug!
Return

Calc:
   Gui Show
Return

ButtonEdit:                                    ; toggle history edit control
   GuiControlGet __histshow, Visible, __hist
   If (__histshow) {                           ; hide
      GuiControlGet __history,,__hist
      GuiControl Hide, __hist
      GuiControl,,__code, `n%__history%`n`n    ; replace all, select last
   }
   Else {                                      ; show
      GuiControl Show, __hist
      GuiControl,,__hist, %__history%
   }
   Gui Show, AutoSize                          ; adjust GUI window
Return

ButtonEvaluate:                                ; Alt-V or Enter: evaluate expression
   ControlGetText __code,Edit1,ahk_id %__CalcID% ; Gui Submit, NoHide: first match from history
   GuiControl,,__res, % __eval(__code)         ; EVAL

   StringReplace __hs, __history, %A_Space%, , ALL
   StringReplace __cd,  __code,   %A_Space%, , ALL
   If !InStr("`n" . __hs . "`n","`n" . __cd . "`n") { ; code is not in history, disregarding space
      StringGetPos __pos, __history, `n, R99   ; append it to history
      If ErrorLevel
         __pos = 0
      __history := SubStr(__history,__pos+1) . "`n" . __code
      GuiControl,,__code, `n%__history%`n`n    ; replace all, select last
   }
return

GuiEscape:                                     ; clear expression window
   ControlSend Edit1, {END}+^{HOME}{DEL}, ahk_id %__CalcID%
Return

GuiClose:                                      ; hide calculator
   WinGetPos __CalcX, __CalcY,,, ahk_id %__CalcID%
   Gui Hide                                    ; keep it alive for fast activation
Return

#IfWinActive ahk_group __CalcGroup             ; \/ -------------------------- \/

^Home::Send {PgUp 9}                           ; Ctrl-Home: highlight oldest history entry
^End::Send {PgDn 9}                            ; Ctrl-End:  highlight newest history entry
F1::                                           ; F1: Help
   GoSub ButtonHelp                            ; redraw help window
   GuiControl 3:Focus, __HelpSearch            ; focus on search
Return
^F1::                                          ; Ctrl-F1: Help on selected function
   ControlGetText __code, Edit1, ahk_id %__CalcID%
   ControlGet __col, CurrentCol,, Edit1, ahk_id %__CalcID% ; pos 1..
   __t := " " . RegExReplace(SubStr(__code,1,__col-1),"^.*?(\w*)$","$1")
              . RegExReplace(SubStr(__code,__col),"^(\w*).*$","$1") . "("
   GoSub ButtonHelp                            ; redraw help window
HelpFind:
   GuiControl 3:Focus, __Help                  ; focus on main help window to show selection
   SendMessage 0xB6, 0, -999, Edit1, ahk_id %__HelpID% ; Scroll to top
   StringGetPos __pos, __Help, %__t%           ; find pos of "func"
   StringLeft __s, __Help, %__pos%             ; cut off end to count lines
   StringReplace __s,__s,`n,`n,UseErrorLevel   ; Errorlevel <- line number
   SendMessage 0xB6, 0, ErrorLevel, Edit1, ahk_id %__HelpID% ; Scroll to visible
   SendMessage 0xB1, __pos, __pos+StrLen(__t), Edit1, ahk_id %__HelpID% ; Select search text
Return

#IfWinActive                                   ; /\ -------------------------- /\

SaveHistory:                                   ; overwrite file with history data
   FileDelete %__file%
   StringReplace __history, __history, `r, `n, ALL
   StringReplace __history, __history, `n`n, `n, ALL
   StringReplace __history, __history, `n`n, `n, ALL
   FileAppend %__history%, %__file%
Return

LoadHistory:                                   ; gets earlier saved history data
   FileRead __history, %__file%
   StringReplace __history, __history, `r, `n, ALL
   StringReplace __history, __history, `n`n, `n, ALL
   StringReplace __history, __history, `n`n, `n, ALL
Return

ButtonSave:                                    ; Alt-S
   FileSelectFile __file, S, %A_WorkingDir%\%__file%, Save the history to..., *.hst
   IfEqual ErrorLevel,0, GoSub SaveHistory
Return

ButtonLoad:                                    ; Alt-L
   FileSelectFile __file,, %A_WorkingDir%\%__file%, Load the history from..., *.hst
   IfEqual ErrorLevel,0, GoSub LoadHistory
   GuiControl,,__code, `n%__history%`n`n       ; replace all, select last
Return

ButtonHelp:                                    ; Alt-H: list of shortcuts, functions
   Gui 3:Destroy
   Gui 3:font, s%__FontSz%, %__Font%
   Gui 3:Margin, 5, 5
   Gui 3:Add, Edit, w%__winWW% r20 v__help Readonly, %__help% ; help
   Gui 3:Add, Text, y+10 w70, Search
   Gui 3:Add, Edit,% "x+0 r1 v__HelpSearch w" . __winWW-70
   Gui 3:Add, Button, x0 y0 Hidden Default, Search
   Gui 3:Show, x%__HelpX% y%__HelpY%, AHK Calculator HELP
   WinGet __HelpID, ID, A
   Send ^{Home}                                ; de-select any text
Return

3ButtonSearch:
   GuiControlGet  __t,,__HelpSearch, 3:        ; get search text
GoTo HelpFind

3GuiEscape:
3GuiClose:
   WinGetPos __HelpX, __HelpY,,,  ahk_id %__HelpID%
   Gui 3:Destroy
Return

4GuiEscape:
4GuiClose:
   WinGetPos __ListX, __ListY,,,  ahk_id %__ListID%
   Gui 4:Destroy
Return

CleanUp:
   GoSub SaveHistory

   IfWinExist ahk_id %__CalcID%
      GoSub  GuiClose
   IfWinExist ahk_id %__GraphID%
      GoSub 2GuiClose
   IfWinExist ahk_id %__HelpID%
      GoSub 3GuiClose
   IfWinExist ahk_id %__ListID%
      GoSub 4GuiClose
                    ; save positions in ini
   If __CalcX <>
      IniWrite %__CalcX%, %__ini%, Window Positions, CalcX
   If __CalcY <>
      IniWrite %__CalcY%, %__ini%, Window Positions, CalcY
   If __HelpX <>
      IniWrite %__HelpX%, %__ini%, Window Positions, HelpX
   If __HelpY <>
      IniWrite %__HelpY%, %__ini%, Window Positions, HelpY
   If __ListX <>
      IniWrite %__ListX%, %__ini%, Window Positions, ListX
   If __ListY <>
      IniWrite %__ListY%, %__ini%, Window Positions, ListY
   If __GraphX <>
      IniWrite %__GraphX%,%__ini%, Window Positions, GraphX
   If __GraphY <>
      IniWrite %__GraphY%,%__ini%, Window Positions, GraphY
ExitApp

2GuiContextMenu:    ; mouse coordinates in axes
   If (A_GuiEvent != "RightClick")
      Return
   DllCall("msvcrt\sprintf", "Str",__Z, "Str","( %.3g, %.3g )"
      ,"double",__x0+(A_GuiX-__GX-__margin)/__xs,"double",__y1-(A_GuiY-__GY-__margin)/__ys)
   Msgbox %__Z%     ; Ctrl-C copies
Return

2GuiEscape:
   Plot()           ; clear function graphs
Return

2GuiClose:
   WinGetPos __GraphX, __GraphY,,, ahk_id %__GraphID%
   Graph()          ; destroy graph paper and drawings
Return


__eval(x) {              ; evaluate AHK expression, format results in decimal, hex and binary
   Global _, _1,_2,_3,_4,_5,_6,_7,_8,_9
   Static H = 0x1234567890123456, N = 0x1234567890123456                           ; allocate
   , U = 123456789012345678901234567890123456789012345678901234567890                ; ...
   , D = 123456789012345678901234567890123456789012345678901234567890                ; memory
   y := eval(RegExReplace(x,"``([^\)\],\s]*)([\)\],\s]|$)","""$1""$2"))         ; `var->"var"
   DllCall("msvcrt\sprintf", "Str",D, "Str","%.6g`tS  %.17g","double",y,"double",y)
   DllCall("msvcrt\sprintf", "Str",H, "Str","0x%I64X","Int64",y+0) ;+0 to handle large floats
   DllCall("msvcrt\sprintf", "Str",U, "Str","%I64i`tS  %I64u","Int64",y+0,"Int64",y+0)
   DllCall("msvcrt\sprintf", "Str",N, "Str","0x%I64X","Int64",-y)              ; negative hex
   k := StrLen(H)<18 ? H : SubStr(H,1,17)*16+abs("0x" SubStr(H,0))        ; force wrap around
   m := -(k<0)
   Loop { ; Binary form of k. 1st bit = SIGN to be extended left: -8:1000; -1:1; 0:0; 8:01000
      IfEqual m,%k%, break
      b := k&1 . b, k >>= 1
   }
   Loop 8
      i := 10 - A_Index, j := i-1, _%i% := _%j%
   _ := _1 := y                          ; previous outputs
   Return y "`n" D "`n" U "`n" H "`tS  -" N "`n" (-m . b)
}

eval(x) {       ; evaluate ";" separated list of AHK expressions, also called from calculator
   Loop Parse, x, `;                  ; evaluate each term separated by ";", keep last result
   {                                                       ; ignore ";" inside quoted strings
      e .= A_LoopField . "`;"
      StringReplace e, e, ", ", UseErrorLevel
      If (ErrorLevel & 1)                ; odd #quotes to the left: ";" inside quoted strings
         Continue
      StringReplace e, e, ', ', UseErrorLevel
      If (ErrorLevel & 1)                ; odd #quotes to the left: ";" inside quoted strings
         Continue
      StringTrimRight e, e, 1
      y := __eval__(e)
      e =       ; restart collecting parts between ";"
   }
   Return y     ; last result
}

__eval__(x) { ; replace all [expr] with their value, evaluate x
   Loop                                  ; find last innermost [..] not in quotes!
      If RegexMatch(x,"^(([^""']*|(""[^""]*"")|('[^']*'))+)\[(([^\['\]""]*|(""[^""]*"")|('[^']*'))*)\](.*)",y)
         x := y1 . "_" . __expr(y5) . y9 ; v = value of x; replace [x] with _v
      Else Break
   Return __expr(x)
}

b(bits) {       ; Number converted from the binary "bits" string, 1st bit = SIGN
   n = 0
   Loop Parse, bits
      n += n + A_LoopField
   Return n - (SubStr(bits,1,1)<<StrLen(bits))
}

Hex2Bin(ByRef bin, hex) { ; convert hex stream to binary
   Static f
   If (f = "") {
      VarSetCapacity(f,73,1)
      Loop 73
         NumPut("0x"
. SubStr("568b74240c8a164684d2743b578b7c240c538ac2c0e806b109f6e98ac802cac0e10488"
. "0f8a164684d2741a8ac2c0e806b309f6eb80e20f02c20ac188078a16474684d275cd5b5f5ec3"
, 2*A_Index-1,2), f, A_Index-1, "Char")
   }
   VarSetCapacity(bin, (StrLen(hex)+1)//2, 99)
   DllCall(&f, "UInt",&bin, "UInt",&hex, "CDECL")
}

msg(x) {        ; MsgBox % x
   MsgBox % x
   Return x
}

rand(min,max="") { ; random number in the range; max="": reseed
   If max =
      Random,,min  ; reseed
   Else {
      Random t, Min, Max
      Return t
   }
}

solve(__Name,__x0,__x1,__exp,__tol=63) { ; <- find x: exp(x) = 0 within tol-erance
   Local __s, __s0 ; assumed global
   %__Name% := __x0
   If (0 = (__s0:=fcmp(eval(__exp),0,__tol)))
      Return __x0
   %__Name% := __x1
   If (0 = (__s :=fcmp(eval(__exp),0,__tol)))
      Return __x1
   If (__s0 = __s)
      Return "Error: same sign at endpoints"

   Loop {
      %__Name% := (__x0 + __x1)/2
      If (fcmp(__x0,__x1,__tol) = 0 || 0 = (__s:=fcmp(eval(__exp),0,__tol)))
         Return %__Name% . ""
      If (__s0 = __s)
         __x0 := %__Name%
      Else
         __x1 := %__Name%
   }
}

fmax(__Name,__x0,__x1,__x2,__exp,__tol=63) { ; <- find x: exp(x) = max within tol-erance
   Local __y, __y0, __y1, __y2               ; assumed global
                                  ; SORT x0 <= x1 <= x2
   If (fcmp(__x0,__x1,__tol) > 0)            ; make x0 <= x1
      __y := __x0, __x0 := __x1, __x1 := __y
   If (fcmp(__x1,__x2,__tol) > 0)            ; make x1 <= x2
      __y := __x1, __x1 := __x2, __x2 := __y
   If (fcmp(__x0,__x1,__tol) > 0)            ; make x0 <= x1, sorted {x0,x1,x2}
      __y := __x0, __x0 := __x1, __x1 := __y

   Loop 3                         ; set yi
      %__Name% := __x%A_Index%, __y%A_Index% := eval(__exp)
   If (fcmp(__y0,__y1,__tol) > 0 || fcmp(__y2,__y1,__tol) > 0)
      Return "Error: middle point not max"

   Loop {
      If (fcmp(__x0,__x2,__tol) = 0)         ; endpoints are close
         Return __x1

      %__Name% := (__x0 + __x1)/2
      __y := eval(__exp)
      If (fcmp(__y,__y1,__tol) > 0) {        ; max is in left half interval ('>' keeps max at x1)
         __x2 := __x1, __y2 := __y1, __x1 := %__Name%, __y1 := __y
         Continue
      }
      __x0 := %__Name%, __y0 := __y

      %__Name% := (__x1 + __x2)/2
      __y := eval(__exp)
      If (fcmp(__y,__y1,__tol) > 0) {        ; max is in right half interval ('>' keeps max at x1)
         __x0 := __x1, __y0 := __y1, __x1 := %__Name%, __y1 := __y
         Continue
      }
      __x2 := %__Name%, __y2 := __y
   }
}

call(__Name,__p1="",__p2="",__p3="",__p4="",__p5="",__p6="",__p7="",__p8="",__p9="",__p10="") {
    Global  ; needed for %__Name%
    Loop
       IfEqual __p%A_Index%,, break
       Else
          %__Name%%A_Index% := __p%A_Index%
    Return eval(%__Name%)
}

for(__Var,__i0,__i1,__d,__expr) { ; <- evaluate {expr(i0),expr(i0+d)..,expr(i1)}
   Local __y, __sd := (__d>0)-(__d<0) ; assumed global
   If (__d = 0)
      Return
   Loop {
      If (fcmp(__i0,__i1,63) = __sd)
         Return __y
      %__Var% := __i0
      __y := eval(__expr)
      __i0 += __d
   }
}

while(cond,expr) { ; <- evaluate expr while cond is true
   Loop
      If !eval(cond)
         Return y
      Else
         y := eval(expr)
}

until(expr,cond) { ; <- evaluate expr until cond gets true
   Loop {
      y := eval(expr)
      If eval(cond)
         Return y
   }
}

list(__Name="") {                              ; Array in editable ListView, list() last outputs
   Local __w
   Static __header := "                       Value                      |Idx"

   __n := __Name                               ; Save Name to global

   LV_Delete()                                 ; clear old
   Gui 4:Destroy                               ; window

   Gui 4:font, s%__FontSz%, %__Font%
   Gui 4:Margin, 5, 5
   Gui 4:Add, ListView, r20 Grid -ReadOnly gListVw, %__header%
   Gui 4:Add, Button, x0 y0 Hidden Default, &More    ; Enter = Alt-M: More
   Gui 4:Add, Button, x0 y0 Hidden, &Less            ; Alt-L: Less
   Gui 4:Add, Button, x0 y0 Hidden, &Refresh         ; Alt-R: Refresh
   Gui 4:Default                               ; LV_ functions to work here

   If (%__Name%_0+0 = "" || %__Name%_0 < 0)    ; If __Name is not array
      %__Name% := __Name, %__Name%_0 := 0      ; create empty array
   Loop % %__Name%_0
      LV_Add("", %__Name%_%A_Index%, A_Index)
   LV_ModifyCol(2,"AutoHdr Integer Center")    ; sort as Int, Center
   LV_ModifyCol(1,"AutoHdr Float Center")      ; Auto-size to fit content
   LV_ModifyCol(2,"Sort")                      ; to redraw LV correctly (?!)
   Gui 4:Show, x%__ListX% y%__ListY%, Edit Array: "%__Name%"
   WinGet __ListID, ID, A
   Return __Name
}

ListVw:                                        ; Events in ListView
   If (A_GuiEvent = "e")                       ; when entry-change finished
      LV_GetText(%__n%_%A_EventInfo%, A_EventInfo)
Return

4GuiContextMenu:
   Menu ListMenu, Show
Return

4ButtonMore:                                   ; create/edit new array entry
   __i := ++%__n%_0
   %__n%_%__i% = ...
   list(__n)
   SendInput {End}{F2}                         ; show last, start editing
Return

4ButtonLess:                                   ; remove last array entry
   if (%__n%_0 = 1)
       %__n%_0 = 0
   if (%__n%_0 < 1)
      Return
   %__n%_0--
   list(__n)
Return

4ButtonRefresh:                                ; refresh LV
   Gui 4:Default                               ; LV_ functions to work here (needed after menu)
   LV_Delete()                                 ; remove all rows
   Loop % %__n%_0
      LV_Add("", %__n%_%A_Index%, A_Index)     ; add rows
   LV_ModifyCol(2,"AutoHdr Integer Center")    ; sort as Int, Center
   LV_ModifyCol(1,"AutoHdr Float Center")      ; Auto-size to fit content
   LV_ModifyCol(2,"Sort")                      ; to redraw LV correctly
Return

seq(__Name,__i0,__i1,__d=1) { ; <- {i0,i0+d..,i1}
   Local __sd := (__d>0)-(__d<0) ; assumed GLOBAL for %__Name%
   %__Name% := __Name            ; store name
   If ((__i0 > __i1 && __d > 0) || (__i0 < __i1 && __d < 0) || (__d = 0)) {
      %__Name%_0 = 0             ; length of array
      Return __Name
   }
   Loop {
      %__Name%_%A_Index% := __i0
      %__Name%_0 := A_Index
      __i0 += __d
      If (fcmp(__i0,__i1,63) = __sd)
         Return __Name
   }
}

array(__Name,__Var,__i0,__i1,__d,__expr) { ; <- {expr(i0),expr(i0+d)..,expr(i1)}
   Local __sd := (__d>0)-(__d<0) ; assumed GLOBAL
   %__Name% := __Name            ; store name
   If ((__i0 > __i1 && __d > 0) || (__i0 < __i1 && __d < 0) || (__d = 0)) {
      %__Name%_0 = 0             ; length of array
      Return __Name
   }
   Loop {
      %__Var% := __i0
      %__Name%_%A_Index% := eval(__expr)
      %__Name%_0 := A_Index
      __i0 += __d
      If (fcmp(__i0,__i1,63) = __sd)
         Return __Name
   }
}

assign(__Name, __1, __2="", __3="", __4="", __5="", __6="", __7="", __8="", __9="",__10="" ; assign
          ,__11="",__12="",__13="",__14="",__15="",__16="",__17="",__18="",__19="",__20="" ; vector
          ,__21="",__22="",__23="",__24="",__25="",__26="",__27="",__28="",__29="",__30="") {
   Global
   %__Name% := __Name          ; store name
   Loop 30 {
      IfEqual __%A_Index%,, Break ; runs at least once
      %__Name%_0 := A_Index
      %__Name%_%A_Index% := __%A_Index%
   }
   Return __Name
}

more(__Name, __1, __2="", __3="", __4="", __5="", __6="", __7="", __8="", __9="",__10=""  ; more entries
        ,__11="",__12="",__13="",__14="",__15="",__16="",__17="",__18="",__19="",__20=""  ; to end of array
        ,__21="",__22="",__23="",__24="",__25="",__26="",__27="",__28="",__29="",__30="") {
   Local __i  ; assume GLOBAL for __Name
   %__Name% := __Name          ; store name
   __i := %__Name%_0+0 = "" ? 0 : %__Name%_0
   Loop 30 {
      IfEqual __%A_Index%,, Break ; runs at least once
      %__Name%_0 := ++__i
      %__Name%_%__i% := __%A_Index%
   }
   Return __Name
}

join(__Name,__A,__B) { ; <- joined arrays {A,B}
   Local __i := %__A%_0          ; assumed GLOBAL
   %__Name% := __Name            ; store name
   Loop % %__A%_0
      %__Name%_%A_Index% := %__A%_%A_Index%
   Loop % %__B%_0 {
      __i++
      %__Name%_%__i% := %__B%_%A_Index%
   }
   %__Name%_0 := __i
   Return __Name
}

part(__Name,__A,__i0,__i1,__d=1) { ; <- {A[i0],A[i0+d]..,A[i1]}. Can reverse sequence
   Local __sd := (__d>0)-(__d<0) ; assumed GLOBAL
   __d := round(__d)             ; only integer indices allowed
   __i0 := round(__i0), __i1 := round(__i1)
   %__Name% := __Name          ; store name
   If ((__i0 > __i1 && __d > 0) || (__i0 < __i1 && __d < 0) || __d = 0 || %__A%_0 < 1
     || __i0 < 0 || __i1 < 0  || %__A%_0 < __i0 || %__A%_0 < __i1) {
      %__Name%_0 = 0         ; length of array
      Return __Name
   }
   Loop {
      %__Name%_%A_Index% := %__A%_%__i0%
      %__Name%_0 := A_Index
      __i0 += __d
      If ( (__i0>__i1)-(__i0<__i1) = __sd || __i0 > %__A%_0 || __i0 < 1 )
         Return __Name
   }
}

copy(__Name,__A) { ; duplicate array
   Global
   Loop % %__A%_0
      %__Name%_%A_Index% := %__A%_%A_Index%
   %__Name% := __Name          ; store Name
   %__Name%_0 := %__A%_0       ; length
   Return __Name
}

sort(__Name,__A,__opt="") { ; sort array; opt = 0: random, 1: no duplicates, 2: reverse, 3: rev.unique
   Local __temp
   Static __0 = "Random", __1 = "U", __2 = "R", __3 = "RU"
   Loop % %__A%_0
      __temp .= %__A%_%A_Index% . "`n"
   StringTrimRight __temp, __temp, 1 ; remove trailing `n
   Sort __temp, % "N" . __%__opt%
   %__Name% := __Name                ; store Name
   StringSplit %__Name%_, __temp, `n ; make array
   Return __Name
}

primes(__Name,__n) { ; primes <= n in array
   Local __i := 3, __j, __k := 1, __P0
   %__Name%_1 := 2         ; First is the even prime 2
   Loop % (__n-1)//2  {
      If (__P%__i% <> 0) { ; Not marked as composite: Prime is found
         __k++
         %__Name%_%__k% := __i
         __j := __i*__i    ; Small multiples are already marked
         Loop  {
            IfGreater __j,%__n%, Break
            __P%__j% = 0   ; Mark multiples as composite
            __j += __i
         }
      }
      __i += 2             ; next odd number
   }
   %__Name%_0 := __k
   %__Name% := __Name      ; store Name
   Return __Name
}

pDivsA(__Name,__n) {  ; vector of prime divisors, AHK version (SLOW)
   Local __d, __k
   %__Name% := __Name             ; store Name
   If __n is not Integer          ; for Floats only:
      __n := Round(__n)           ; Round(n) destroys large integers!
   If ((__n:=abs(__n)) < 4) {
      %__Name%_0 := 1             ; special cases
      %__Name%_1 := __n
      Return __Name
   }
   __d := 2                       ; first trial divisor
   __k := 0                       ; number of divisors so far
   ToolTip Computing..., 10, 40   ; indicate work in progress
   Loop {
      If (__n = 1) {
         ToolTip
         %__Name%_0 := __k        ; size
         Return __Name
      }
      If (__d*__d > __n) {
         ToolTip
         %__Name%_0 := ++__k      ; size
         %__Name%_%__k% := __n    ; last divisor
         Return __Name
      }
      Loop
         If (Mod(__n,__d) <> 0)   ; n is not divisible by d
            Break
         Else {
            __n //= __d
            __k++
            %__Name%_%__k% := __d ; next divisor
         }
      __d := next_d(__d)
   }
}

pDivs(__Name,__n) {  ; vector of prime divisors. Compiled version (Fast)
   Local  __d, __k                ; assumed global
   Static __f, __p

   %__Name% := __Name             ; store Name
   If __n is not Integer          ; for Floats only:
      __n := Round(__n)           ; Round(n) destroys large integers!
   If ((__n:=abs(__n)) < 4) {
      %__Name%_0 := 1             ; special cases
      %__Name%_1 := __n
      Return __Name
   }

   If (__f = "") {
      Hex2Bin(__f,"558bec5151568b75106a1e33d2598bc6f7f13b75148bca773a8b45088945"
. "f88b450c33d2f7f68955fc8b45f88b55fcf775108bc285c0741f8b45180fb6040103f003c883"
. "f91d897510760383e91e3b751476cc33c0eb028bc65ec9c3") ; 92 Bytes
      Hex2Bin(__p,"010601020302010403020102010403020102010403020106050403020102")
   }

   __d := 2                       ; first trial divisor
   __k := 0                       ; number of divisors so far
   ToolTip Computing..., 10, 40   ; indicate work in progress

   Loop {
      __d := DllCall(&__f, "Int64",__n, "UInt",__d, "UInt",round(sqrt(__n)), "UInt",&__p, "CDECL UInt")
      if (__d = 0) {              ; no divisor found
         ToolTip
         %__Name%_0 := ++__k      ; one more: n
         %__Name%_%__k% := __n    ; store last divisor
         Return __Name
      }
      __n //= __d                 ; reduce n
      If (__n = 1) {              ; last divisor was found
         ToolTip
         %__Name%_0 := __k        ; size
         Return __Name
      }
      __k++                       ; one more
      %__Name%_%__k% := __d       ; save new found divisor
   }
}

@(__Name,__A,__op,__B="") { ; elementwise operation of arrays, or vactor <op> scalar, 0 pad
   Local __n, __i
   %__Name% := __Name          ; store name
   If __op is alnum            ; FUNCTION name
   {
      If __A is number
      {
         Loop % %__B%_0
            %__Name%_%A_Index% := __expr(__op . "(" . __A . "," . %__B%_%A_Index% . ")")
         %__Name%_0 := %__B%_0 ; length
      }
      Else If __B is number
      {
         Loop % %__A%_0
            %__Name%_%A_Index% := __expr(__op . "(" . %__A%_%A_Index% . "," . __B . ")")
         %__Name%_0 := %__A%_0 ; length
      }
      Else If (__B = "") {
         Loop % %__A%_0
            %__Name%_%A_Index% := __expr(__op . "(" . %__A%_%A_Index% . ")")
         %__Name%_0 := %__A%_0 ; length
      }
      Else {
         If (%__A%_0 < %__B%_0) {
            Loop % %__A%_0
               %__Name%_%A_Index% := __expr(__op . "(" . %__A%_%A_Index% . "," . %__B%_%A_Index% . ")")
            Loop % %__B%_0 - %__A%_0
               __i := %__A%_0 + A_Index, %__Name%_%__i% := __expr(__op . "(0," . %__B%_%__i% . ")")
            %__Name%_0 := %__B%_0 ; length
         }
         Else {                ; A longer
            Loop % %__B%_0
               %__Name%_%A_Index% := __expr(__op . "(" . %__A%_%A_Index% . "," . %__B%_%A_Index% . ")")
            Loop % %__A%_0 - %__B%_0
               __i := %__B%_0 + A_Index, %__Name%_%__i% := __expr(__op . "(" . %__A%_%__i% . ",0)")
            %__Name%_0 := %__A%_0 ; length
         }
      }
   }
   Else                        ; AHK OPERATOR +-*/<==>^&|.~!
   {
      If __A is number
      {
         Loop % %__B%_0
            %__Name%_%A_Index% := __expr(__A . __op . %__B%_%A_Index%)
         %__Name%_0 := %__B%_0 ; length
      }
      Else If __B is number
      {
         Loop % %__A%_0
            %__Name%_%A_Index% := __expr(%__A%_%A_Index% . __op . __B)
         %__Name%_0 := %__A%_0 ; length
      }
      Else If (__B = "") {     ; pefix unary operator ~-!&*++-- (written as postfix)
         Loop % %__A%_0
            %__Name%_%A_Index% := __expr(__op . %__A%_%A_Index%)
         %__Name%_0 := %__A%_0 ; length
      }
      Else {                   ; binary operator
         If (%__A%_0 < %__B%_0) {
            Loop % %__A%_0
               %__Name%_%A_Index% := __expr(%__A%_%A_Index% . __op . %__B%_%A_Index%)
            Loop % %__B%_0 - %__A%_0
               __i := %__A%_0 + A_Index, %__Name%_%__i% := __expr(0 . __op . %__B%_%__i%)
            %__Name%_0 := %__B%_0 ; length
         }
         Else {                ; A longer
            Loop % %__B%_0
               %__Name%_%A_Index% := __expr(%__A%_%A_Index% . __op . %__B%_%A_Index%)
            Loop % %__A%_0 - %__B%_0
               __i := %__B%_0 + A_Index, %__Name%_%__i% := __expr(%__A%_%__i% . __op . 0)
            %__Name%_0 := %__A%_0 ; length
         }
      }
   }
   Return __Name
}

plmul(__z,__y,__x) { ; z <- y*x polynomial multiplication (convolution, FIR filter)
   Local __i, __j
   %__z% := __z                     ; store name
   %__z%_0 := %__y%_0 + %__x%_0 - 1 ; length
   Loop % %__z%_0
      %__z%_%A_Index% := 0
   Loop % %__x%_0 {
      __i := A_Index
      Loop % %__y%_0
         __j := __i+A_Index-1, %__z%_%__j% += %__y%_%A_Index% * %__x%_%__i%
   }
   Return __z
}

pldiv(__q,__r,__n,__d) { ; polynomial division,mod: q <- n/d; r <- mod(n,d)
   Local __i, __j, __ni, __di, __nl, __dl
   %__q% := __q                 ; store name
   %__r% := __r                 ; store name
   __nl := %__n%_0,  __dl := %__d%_0

   Loop %__nl%
      %__r%_%A_Index% := %__n%_%A_Index%

   If (__dl > __nl) {           ; too short divisor
      %__q%_0 := 0
      Return __q
   }

   %__q%_0 := __nl - __dl + 1   ; quotient length
   __ni:= __nl
   __qi:= %__q%_0
   Loop % __nl - __dl + 1  {
      %__q%_%__qi% := %__r%_%__ni% / %__d%_%__dl%
      Loop % __dl-1
         __i := __dl-A_Index, __j := __ni-A_Index, %__r%_%__j% -= %__q%_%__qi% * %__d%_%__i%
      --__ni,  --__qi
   }

   Loop % __ni+1 {
      If (%__r%_%__ni% != 0)
         Break
      --__ni
   }

   %__r%_0 := __ni ? __ni : 1   ; remainder length
   Return __q
}


pleval(__p, __x) { ; evaluate polynomial p(x), Horner's method
   Local __i, __v := 0
   __i := %__p%_0
   Loop % %__p%_0
      __v := __v*__x + %__p%_%__i%, --__i
   Return __v
}

sum(__X) {
   Local __s := 0
   Loop % %__X%_0
      __s += %__X%_%A_Index%
   Return __s
}
sumpow(__k,__X) {
   Local __s := 0
   Loop % %__X%_0
      __s += (%__X%_%A_Index%)**__k
   Return __s
}
prod(__X) {
   Local __s := 1
   Loop % %__X%_0
      __s *= %__X%_%A_Index%
   Return __s
}
mean(__X) {
   Local __s := 0
   Loop % %__X%_0
      __s += %__X%_%A_Index%
   Return __s / %__X%_0
}
std(__X) {
   Local __s := 0, __m := mean(__X)
   Loop % %__X%_0
      __s += (%__X%_%A_Index% - __m)**2
   Return sqrt(__s / %__X%_0)
}
moment(__k,__X) {
   Local __s := 0, __m := mean(__X)
   Loop % %__X%_0
      __s += (%__X%_%A_Index% - __m)**__k
   Return __s / %__X%_0
}
dot(__A,__B) {
   Local __s := 0, __n := %__A%_0 < %__B%_0 ? %__A%_0 : %__B%_0
   Loop %__n%
      __s += %__A%_%A_Index% * %__B%_%A_Index%
   Return __s
}

f2c(f) {        ; Fahrenheit -> Centigrade
  Return (f-32)/1.8
}

c2f(c) {        ; Centigrade -> Fahrenheit
  Return c*1.8+32
}

LCM(a,b) {      ; Least Common Multiple
   Return a * (b // GCD(a,b))
}

GCD(a,b) {      ; Euclidean GCD
   Return b=0 ? Abs(a) : GCD(b, mod(a,b))
}

xGCD(ByRef c, ByRef d, x,y) { ; Extended GCD, return GCD(x,y), compute c,d: GCD = c*x + d*y
   a := 0, b := 1, c := 1, d := 0
   Loop {
      If (y = 0)
         Return x
      q := x//y
      t := x - q*y,  x := y,  y := t
      t := c - q*a,  c := a,  a := t
      t := d - q*b,  d := b,  b := t
   }
}

ModMul(a,b, m) { ; unsigned a*b mod m, a*b < 2**127
   a:= umod(a,m), b:= umod(b,m)  ; reduce the chance of overflow
   ab := MsMul(a,b)              ; MS word of a*b
   k  := reci64(m,ms)            ; 2**ms/m
   mn := m << (127-ms)           ; normalized m, 127-ms = 64-MSb
   q  := MsMul(ab,k)*2           ; estimate for multiple q of mn making a*b-q*mn = {0,y}
   Loop {                        ; runs normally 1..5 times
      c := ucmp(ab,MsMul(q,mn))
      If (c > 0)                 ; not ab > MS(q*mn)
         q++                     ; increment q, MS of MS(q*mn) increases by less than 1
      Else
      If (c < 0)
         q--                     ; decrement q, MS of MS(q*mn) decreases by less than 1
      Else  {                    ; MS(a*b-q*mn) = 0
         If (ucmp(a*b,q*mn) > 0) ; a*b > q*mn
            Return umod(a*b-q*mn,m) ; MS = 0: rem found in LS of a*b - q*mn
         Else                    ; a*b <= q*mn: subtract 2**64
            If (a*b-q*mn < 0)
               Return mod(a*b-q*mn,m) + m ; "-": implicit -2**64
            Else
               Return mod(a*b-q*mn+2*(m+mod(-0x8000000000000000,m)),m)
      }
   }
}

reci64(m, ByRef ms="") { ; 2**ms/m: Int64 normalized (negative), m: UNSIGNED written with sign
   Static t64 := 18446744073709551616.0    ; 2.0**64
   ms := MSb(m)+63                         ; (2**ms / m) will be computed
   md := m < 0 ? m+t64 : m+.0              ; double from (wrapped around) m
   k  := round(2.**(ms-2)/md)*4            ; 51-bit accurate integer reciprocal
   k  := k = 0 ? -1 : k                    ; max unsigned = 2**64-1
   kd := MsMul(k,m) - (1<<ms-64)           ; MS of distance from 2's power (wrapped, SIGNED)
   km := k*m                               ; LS 64 bits of k*m
   km += km < 0 ? t64 : 0.0                ; positive, double
   Return k - round((kd*t64 + km) / md)    ; low precision correction: (k*m-2**ms)/m
}

ModPow(a,e, m) { ; unsigned a**e mod m
   p := 1
   Loop {
      If (e = 0)
         Return p
      If (e & 1)
         p := ModMul(p,a, m)    ; p *= a
      e := (e>>1) & 0x7fffffffffffffff ; unsigned halve
      a := ModMul(a,a, m)       ; a *= a
   }
}

MsMul(a,b) { ; Most Significant 64 bits of a*b
   Static x = 0xFFFFFFFF
   a0 := a & x, a1 := a >> 32 & x ; unsigned shift!
   b0 := b & x, b1 := b >> 32 & x
   Return a1*b1 + (a1*b0 >> 32 & x) + (a0*b1 >> 32 & x)
       + (((a1*b0 & x) + (a0*b1& x) + (a0*b0 >> 32 & x)) >> 32)
}

MSb(x) { ; Most Significant bit: 1..64, (0 if x=0)
   Static f
   If (f = "")
      Hex2Bin(f,"8B4424040FBDC0C3")
   If (x < 0)
      Return 64
   If (0 = x >> 32)
      Return DllCall(&f, "UInt32", x,   "CDECL Int") + (x<>0)
   Return 33+DllCall(&f, "UInt32",x>>32,"CDECL Int")
}

LSb(x) { ; Least Significant bit: 1..64, (0 if x=0)
   Static f
   If (f = "")
      Hex2Bin(f,"8B4424040FBCC0C3")
   If (x = 0)
      Return 0
   If (0 = x & 0xFFFFFFFF)
      Return DllCall(&f, "UInt32",x>>32,"CDECL Int") + 33
   Return 1+ DllCall(&f, "UInt32", x,   "CDECL Int")
}


umod(x,m) {     ; unsigned mod (if < 0: add 2*mod(2**63,m))
   x := mod(x,m)
   Return x < 0 ? mod(x+m-2*mod(-0x8000000000000000,m),m) : x
}

ucmp(a,b) {     ; unsigned 64-bit compare a <,=,> b : -1,0,1
   Static f
   If (f = "")
      Hex2Bin(f,"8B4424048B4C24088B108B4004568B318B49043BC157720B77043B"
. "D6760533FF47EB0233FF3BC1770B72043BD6730533C941EB0233C98BC75F2BC15EC3")
   Return DllCall(&f, "Int64*",a, "Int64*",b, "CDECL Int")
}

IsPrimeA(N) {   ; 1 if N = Prime or 1; 0 otherwise; pure AHK version: SLOW
   Static p1_15 = 614889782588491410, p16_25 = 3749562977351496827
   If N in 2,3,5,7,11,13,17,19,23,29,31,37,41,43,47,53,59,61,67,71,73,79,83,89,97 ; small primes directly
      Return 1
   If N < 101
      Return 0
   If (gcd(N,p1_15) <> 1 || gcd(N,p16_25) <> 1) ; GCD with products of primes <= 97
      Return 0
   c := Round(Sqrt(N))     ; safe rounding
   d := 101                ; 1st unhandled prime
   ToolTip Computing..., 10, 40
   Loop {
      If (d > c || Mod(N,d) = 0)
         Break             ; d is too large or N is divisible by d
      d := next_d(d)       ; next candidate divisor
   }
   ToolTip
   Return d > c
}
next_d(d) { ; helper func: 2->3,3->5 then next num not divisible by 2, 3 or 5
   Static d2=1, d3=2, d5=2,  d1=6, d7=4, d11=2, d13=4, d17=2, d19=4, d23=6, d29=2
   m := Mod(d,30) ; could use static array to update m, too
   Return d + d%m%
}

isprime(n) {    ; 1 if N = Prime; 0 otherwise; compiled version: FAST
   Static f, p
   If n < 4
      Return n > 1
   If (f = "") {
      Hex2Bin(f,"558bec5151568b75106a02593bf1894dfc72398b45088945f88b450c33d2f7"
. "75fc8955108b45f88b5510f775fc8bc285c0741e83f91d760383e91e8b45140fb604010145fc"
. "03c83975fc76cd33c040eb0233c05ec9c3") ; 86 Bytes
      Hex2Bin(p,"010601020302010403020102010403020102010403020106050403020102")
   }
   ToolTip Computing..., 10, 40
   c := DllCall(&f, "Int64",n, "UInt",round(sqrt(n)), "UInt",&p, "CDECL Int")
   ToolTip
   Return c
}

Choose(n,k) {   ; Binomial coefficient. "n.0" force floating point arithmetic
   p := 1, i := 0, k := k < n-k ? k : n-k
   Loop %k%
      p *= n-i, p //= ++i
   Return p
}

Fib(n) {        ; n-th Fibonacci number (n < 0 OK, iterative to avoid globals)
   a := 0, b := 1
   Loop % abs(n)-1
      c := b, b += a, a := c
   Return n=0 ? 0 : n>0 || n&1 ? b : -b
}

fac(n) {        ; n!
   Return n<2 ? 1 : n*fac(n-1)
}

sign(x) {       ; the sign of x (-1,0,+1)
   Return (x>0) - (x<0)
}

fcmp(x,y,tol) { ; floating point comparison with tolerance
   Static f
   If (f = "")
      Hex2Bin(f,"558bec83e4f883ec148b5510538b5d0c85db568b7508578b7d148974241889542410b90"
. "00000807f137c0485f6730d33c02bc68bd91b5d0c89442418837d14007f137c0485d2730d33c02bc28bf9"
. "1b7d14894424108b7424182b7424108b45188bcb1bcff7d8993bd17f187c043bc677128b4518993bca7f0"
. "a7c043bf0770433c0eb183bdf7f117c0a8b44241039442418730583c8ffeb0333c0405f5e5b8be55dc3")

   Return DllCall(&f, "double",x, "double",y, "Int",tol, "CDECL Int")
}

cbrt(x) {       ; signed cubic root
   Static e = 0.333333333333333333
   Return x < 0 ? -(-x)**e : x**e
}

quadratic(ByRef x1, ByRef x2, a,b,c) { ; -> #real roots {x1,x2} of ax**2+bx+c
   i := fcmp(b*b,4*a*c,63) ; 6 LS bit tolerance
   If (i = -1) {
      x1 := x2 := ""
      Return 0
   }
   If (i = 0) {
      x1 := x2 := -b/2/a
      Return 1
   }
   d := sqrt(b*b - 4*a*c)
   x1 := (-b-d)/2/a
   x2 := x1 + d/a
   Return 2
}
cubic(ByRef x1, ByRef x2, ByRef x3, a,b,c,d) { ; -> #real roots {x1,x2,x3} of ax**3+bx**2+cx+d
   Static pi23 = 2.094395102393195492, pi43 = 4.188790204786390985
   x := -b/3/a                                 ; Nickalls method
   y := ((a*x+b)*x+c)*x+d
   E2:= (b*b-3*a*c)/9/a/a
   H2:= 4*a*a*E2*E2*E2

   i := fcmp(y*y,H2, 63)

   If (i = 1) { ; 1 real root
      q := sqrt(y*y-H2)
      x1 := x + cbrt((-y+q)/2/a) + cbrt((-y-q)/2/a)
      x2 := x3 := ""
      Return 1
   }
   If (i = 0) { ; 3 real roots (1 or 2 different)
      If (fcmp(H2,0, 63) = 0) { ; root1 is triple...
         x1 := x2 := x3 := x
         Return 1
      } ; h <> 0                : root2 is double...
      E := cbrt(y/2/a) ; with correct sign
      x1 := x - E - E
      x2 := x3 := x + E
      Return 2
   } ; i = -1   : 3 real roots (different)...
   t := acos(-y/sqrt(H2)) / 3
   E := 2*sqrt(E2)
   x1 := x + E*cos(t)
   x2 := x + E*cos(t+pi23)
   x3 := x + E*cos(t+pi43)
   Return 3
}

min(__x,__x1="",__x2="",__x3="",__x4="",__x5="",__x6="",__x7="",__x8="",__x9="") { ; min of numbers or array
   Local __m
   If (__x1 = "" && 0+%__x%_0 > 0) { ; min of array
      __m := %__x%_1
      Loop % %__x%_0
         If (__m > %__x%_%A_Index%)
             __m:= %__x%_%A_Index%
      Return __m
   }
   Loop 9
      If (__x%A_Index% <> "" && __x > __x%A_Index%) ; ignore blanks
          __x:= __x%A_Index%
   Return __x
}
max(__x,__x1="",__x2="",__x3="",__x4="",__x5="",__x6="",__x7="",__x8="",__x9="") { ; max of numbers or array
   Local __m
   If (__x1 = "" && 0+%__x%_0 > 0) { ; max of array
      __m := %__x%_1
      Loop % %__x%_0
         If (__m < %__x%_%A_Index%)
             __m:= %__x%_%A_Index%
      Return __m
   }
   Loop 9
      If (__x < __x%A_Index%)
          __x:= __x%A_Index%
   Return __x
}

pmean(__k, __x,__x1="",__x2="",__x3="",__x4="",__x5="",__x6="",__x7="",__x8="",__x9="") { ; __k-th power mean
   Local __m := 0
   If (__x1 = "" && 0+%__x%_0 > 0) { ; work on array
      Loop % %__x%_0
         __m+= %__x%_%A_Index% ** __k
      Return (__m/%__x%_0) ** (1/__k)
   }
   __x := __x**__k
   Loop 9 {
      IfEqual __x%A_Index%,, break ; stop at omitted/blank parameter
      __x += __x%A_Index% ** __k
      n := A_Index
   }
   Return (__x/(n+1))**(1/__k)
}

cot(x) {        ; cotangent
   Return 1/tan(x)
}
sec(x) {        ; secant
   Return 1/cos(x)
}
cosec(x) {      ; cosecant
   Return 1/sin(x)
}
acot(x) {       ; inverse cotangent
   Return 1.57079632679489662 - atan(x)
}
asec(x) {        ; inverse secant
   Return acos(1/x)
}
acosec(x) {      ; inverse cosecant
   Return asin(1/x)
}
atan2(x,y) {    ; 4-quadrant atan
   Return dllcall("msvcrt\atan2","Double",y, "Double",x, "CDECL Double")
}

sinh(x) {       ; hyperbolic sine
   Return dllcall("msvcrt\sinh", "Double",x, "CDECL Double")
}
cosh(x) {       ; hyperbolic cosine
   Return dllcall("msvcrt\cosh", "Double",x, "CDECL Double")
}
tanh(x) {       ; hyperbolic tangent
   Return dllcall("msvcrt\tanh", "Double",x, "CDECL Double")
}
coth(x) {       ; hyperbolic cotangent
   Return 1/dllcall("msvcrt\tanh", "Double",x, "CDECL Double")
}

asinh(x) {      ; inverse hyperbolic sine
   Return ln(x + sqrt(x*x+1))
}
acosh(x) {      ; inverse hyperbolic cosine
   Return ln(x + sqrt(x*x-1))
}
atanh(x) {      ; inverse hyperbolic tangent
   Return 0.5*ln((1+x)/(1-x))
}
acoth(x) {      ; inverse hyperbolic cotangent
   Return 0.5*ln((x+1)/(x-1))
}

ldexp(x,e) {    ; load exponent -> x * 2**e
   Return dllcall("msvcrt\ldexp","Double",x, "Int",e, "CDECL Double")
}

frexp(x, ByRef e) { ; -> scaled x to [0.5,1) or 0; e <- exp: x = frexp(x) * 2**e
   Return dllcall("msvcrt\frexp","Double",x, "Int*",e, "CDECL Double")
}

;------------------------------------------------------------------------------------
; GRAPHIC functions
;------------------------------------------------------------------------------------
graph(x0="",x1="",y0="",y1="",width="",height="",BGcolor="") {
   Local Pen, Brush ; implicit Global

   width  := width  = "" ? __GrWidth  : width
   height := height = "" ? __GrHeight : height
   BGcolor:= BGcolor= "" ? __GrBGcolor: BGcolor

   __width:=width, __height:=height, __margin:=10
   __x0:=x0, __x1:=x1, __y0:=y0, __y1:=y1,
   __xs:=(width-1)/(x1-x0), __ys:=(height-1)/(y1-y0)

   If (__graphID != "") {
      DllCall("DeleteObject", UInt,__PaperDC)
      DllCall("DeleteObject", UInt,__PaperBM)
      DllCall("DeleteObject", UInt,__MemoryDC)
      DllCall("DeleteObject", UInt,__MemoryBM)
      DllCall("ReleaseDC", UInt,0, UInt,__WindowDC)
      GUI 2:Destroy
      OnMessage(0x20, "") ; WM_SETCURSOR
      OnMessage(0x200,"") ; WM_MOUSEMOVE
      SetTimer GraphTimer, OFF
      __GraphID =
   }
   If (x0 = "")
      Return        ; no params = destroy

   Gui 2:font, s%__FontSz%, %__Font%
   Gui 2:Add, Text, x0 y0 w0 h0 ; mark the upper left corner as Static1 control
   Gui 2:Show, % "x" . __GraphX . " y" . __GraphY . " w" . width+2*__margin . "h" . height+2*__margin, Calculator Graph
   WinGet __GraphID, ID, A
   ControlGetPos __GX, __GY,,, Static1, ahk_id %__graphID% ; top left corner of Graph work area
   OnMessage(0x20, "HandleMessage") ; WM_SETCURSOR
   OnMessage(0x200,"HandleMessage") ; WM_MOUSEMOVE
   SetTimer GraphTimer, 100

   __WindowDC := DllCall("GetDC", UInt,__graphID) ; Device Context for the window to be drawn to
   __PaperDC := DllCall("CreateCompatibleDC", UInt,__WindowDC) ; memory DC, "graph paper,"
   __PaperBM := DllCall("CreateCompatibleBitmap",UInt,__WindowDC,UInt,width,UInt,height) ; create a bitmap on the DC
   DllCall("SelectObject", UInt,__PaperDC, UInt,__PaperBM)

   __MemoryDC := DllCall("CreateCompatibleDC", UInt,__WindowDC) ; Memory DC, finished product
   __MemoryBM := DllCall("CreateCompatibleBitmap",UInt,__WindowDC,UInt,width,UInt,height) ; create a bitmap on the DC
   DllCall("SelectObject", UInt,__MemoryDC, UInt,__MemoryBM)

   Pen := DllCall("CreatePen", UInt,0, UInt,0, UInt,BGcolor)
   DllCall("SelectObject", UInt,__PaperDC, UInt,Pen)

   Brush := DllCall("CreateSolidBrush", UInt,BGcolor)
   DllCall("SelectObject", UInt,__PaperDC, UInt,Brush)
   DllCall("Rectangle", UInt,__PaperDC, UInt,0, UInt,0, UInt,width, UInt,height)
   DllCall("DeleteObject", UInt,Pen)
   DllCall("DeleteObject", UInt,Brush)

   DllCall("BitBlt", UInt,__MemoryDC, UInt,0, UInt,0
      , UInt,width, UInt,height, UInt,__PaperDC,  UInt,0, UInt,0, UInt,0x00CC0020)
   DllCall("BitBlt", UInt,__WindowDC, UInt,__margin, UInt,__margin
      , UInt,__width, UInt,__height, UInt,__MemoryDC, UInt,0, UInt,0, UInt,0x00CC0020)
}

HandleMessage(__p_w, __p_l, __p_m, __p_hw) {
   Global
   If (__p_hw = __GraphID) {
      If (__hover && __p_m = 0x20) ; WM_SETCURSOR
         Return 1
      __hover = 1
      DllCall("SetCursor", "uint", __cursor)
      DllCall("msvcrt\sprintf", "Str",__Z, "Str","( %.3g, %.3g )"
      ,"double",__x0+((__p_l & 0xFFFF)-__margin)/__xs,"double",__y1-((__p_l>>16)-__margin)/__ys)
      ToolTip %__Z%
   } Else
      __hover = 0
   Return
}

GraphTimer: ; Erase tooltip outside. Other actions not needed for Vista/modern graphic cards
   MouseGetPos __X,__Y,__WinID
   If (__Xold = __X && __Yold = __Y && __GraphID = __WinID)
      Return                                    ; if nothing changed, do nothing (no flicker)
   __Xold := __X, __Yold := __Y
   If (__WinID <> __GraphID || __Y < __GY)      ; in Graph, but not in title bar!
      ToolTip                                   ; erase tooltip outside
   DllCall("BitBlt", UInt,__MemoryDC, UInt,0, UInt,0           ; REDRAW
      , UInt,width, UInt,height, UInt,__PaperDC,  UInt,0, UInt,0, UInt,0x00CC0020)
   DllCall("BitBlt", UInt,__WindowDC, UInt,__margin, UInt,__margin
      , UInt,__width, UInt,__height, UInt,__MemoryDC, UInt,0, UInt,0, UInt,0x00CC0020)
Return

Xtick(X="",color=0x777777,width=1,Label=true) { ; | tick lines
   Local Pen, xi ; Implicit Global

   X  := X  = "" ? __GRxTicks  : X

   Pen := DllCall("CreatePen", UInt,0, UInt,width, UInt,color)
   DllCall("SelectObject", UInt,__PaperDC, UInt,Pen)

   If X is integer                              ; #X stripes
      Loop % X+1 {
         xi := Round((__x1 - (__x0 + (A_Index-1)*(__x1-__x0)/x) ) * __xs)
         DllCall("MoveToEx", UInt,__PaperDC, UInt,xi, UInt,0, UInt,0)
         DllCall("LineTo", UInt,__PaperDC, UInt,xi, UInt,__width)
      }
   Else If X is float                           ; single line
   {
      xi := Round((X - __x0) * __xs)
      DllCall("MoveToEx", UInt,__PaperDC, UInt,xi, UInt,0, UInt,0)
      DllCall("LineTo", UInt,__PaperDC, UInt,xi, UInt,__height)
   }
   Else                                         ; lines from array
      Loop % %X%_0 {
         xi := Round((%X%_%A_Index% - __x0) * __xs)
         DllCall("MoveToEx", UInt,__PaperDC, UInt,xi, UInt,0, UInt,0)
         DllCall("LineTo", UInt,__PaperDC, UInt,xi, UInt,__height)
      }

   DllCall("DeleteObject", UInt,Pen)

   DllCall("BitBlt", UInt,__MemoryDC, UInt,0, UInt,0
      , UInt,__width, UInt,__height, UInt,__PaperDC,  UInt,0, UInt,0, UInt,0x00CC0020)
}

Ytick(Y="",color=0x777777,width=1,Label=true) { ; - tick lines
   Local Pen, yi ; Implicit Global

   Y  := Y  = "" ? __GRyTicks  : Y

   Pen := DllCall("CreatePen", UInt,0, UInt,width, UInt,color)
   DllCall("SelectObject", UInt,__PaperDC, UInt,Pen)

   If Y is integer                              ; #Y stripes
      Loop % Y+1 {
         yi := Round((__y1 - (__y0 + (A_Index-1)*(__y1-__y0)/Y) ) * __ys)
         DllCall("MoveToEx", UInt,__PaperDC, UInt,0, UInt,yi, UInt,0)
         DllCall("LineTo", UInt,__PaperDC, UInt,__width, UInt,yi)
      }
   Else If Y is float                           ; single line
   {
      yi := Round((__y1 - Y) * __ys)
      DllCall("MoveToEx", UInt,__PaperDC, UInt,0, UInt,yi, UInt,0)
      DllCall("LineTo", UInt,__PaperDC, UInt,__width, UInt,yi)
   }
   Else                                         ; lines from array
      Loop % %Y%_0 {
         yi := Round((__y1 - %Y%_%A_Index%) * __ys)
         DllCall("MoveToEx", UInt,__PaperDC, UInt,0, UInt,yi, UInt,0)
         DllCall("LineTo", UInt,__PaperDC, UInt,__width, UInt,yi)
      }

   DllCall("DeleteObject", UInt,Pen)

   DllCall("BitBlt", UInt,__MemoryDC, UInt,0, UInt,0
      , UInt,__width, UInt,__height, UInt,__PaperDC,  UInt,0, UInt,0, UInt,0x00CC0020)
}

plotXY(X,Y,color="",width="") {            ; plot [x1,y1]-[x2,y2]-...
   Local Pen ; Implicit Global

   color := color = "" ? __GrLnColor : color
   width := width = "" ? __GrLnWidth : width

   If (__graphID = "") {                        ; create graph paper if none
      graph(min(X),max(X),min(Y),max(Y))
      Xtick(__GRxTicks)
      YTick(__GRyTicks)
   }

   Pen := DllCall("CreatePen", UInt,0, UInt,width, UInt,color)
   DllCall("SelectObject", UInt,__MemoryDC, UInt,Pen)

   DllCall("MoveToEx", UInt,__MemoryDC
      , UInt,Round((%X%_1-__x0)*__xs), UInt,Round((__y1-%Y%_1)*__ys), UInt,0)
   Loop % %X%_0
      DllCall("LineTo", UInt,__MemoryDC
         , UInt,Round((%X%_%A_Index%-__x0)*__xs),UInt,Round((__y1-%Y%_%A_Index%)*__ys))

   DllCall("DeleteObject", UInt,Pen)

   DllCall("BitBlt", UInt,__WindowDC, UInt,__margin, UInt,__margin
      , UInt,__width, UInt,__height, UInt,__MemoryDC, UInt,0, UInt,0, UInt,0x00CC0020)
}

plot(Y="",color="",width="") {             ; plot with implicit X = 1,2,..
   Local Pen

   color := color = "" ? __GrLnColor : color
   width := width = "" ? __GrLnWidth : width

   If (Y = "") {                                ; clear graph paper
      DllCall("BitBlt", UInt,__MemoryDC, UInt,0, UInt,0
         , UInt,__width, UInt,__height, UInt,__PaperDC, UInt,0, UInt,0, UInt,0x00CC0020)
      DllCall("BitBlt", UInt,__WindowDC, UInt,__margin, UInt,__margin
         , UInt,__width, UInt,__height, UInt,__MemoryDC, UInt,0, UInt,0, UInt,0x00CC0020)
      Return
   }

   If (__graphID = "") {                        ; create graph paper if none
      graph(1,%Y%_0,min(Y),max(Y))
      Xtick(__GRxTicks)
      YTick(__GRyTicks)
   }

   Pen := DllCall("CreatePen", UInt,0, UInt,width, UInt,color)
   DllCall("SelectObject", UInt,__MemoryDC, UInt,Pen)

   DllCall("MoveToEx", UInt,__MemoryDC, UInt,0, UInt,Round((__y1-%Y%_1)*__ys), UInt,0)
   Loop % %Y%_0
      DllCall("LineTo", UInt,__MemoryDC
         , UInt,Round((A_Index-1)*__xs), UInt,Round((__y1-%Y%_%A_Index%)*__ys))

   DllCall("DeleteObject", UInt,Pen)

   DllCall("BitBlt", UInt,__WindowDC, UInt,__margin, UInt,__margin
      , UInt,__width, UInt,__height, UInt,__MemoryDC, UInt,0, UInt,0, UInt,0x00CC0020)
}

;------------------------------------------------------------------------------------
; lexikos' lowlevel functions (http://www.autohotkey.com/forum/viewtopic.php?t=26300)
;------------------------------------------------------------------------------------
__init() {
    __getFirstFunc()
    __mcode("__getVar","8B4C24088B0933C08379080375028B018B4C2404998901895104C3")
    __mcode("__static","8B4424088B008378080375068B0080480D04C3")
}
__mcode(FuncName, Hex) {
    if !(pFunc := __getFuncUDF(FuncName)) or !(pbin := DllCall("GlobalAlloc","uint",0,"uint",StrLen(Hex)//2))
        return 0
    Loop % StrLen(Hex)//2
        NumPut("0x" . SubStr(Hex,2*A_Index-1,2), pbin-1, A_Index, "char")
    NumPut(pbin,pFunc+4), NumPut(1,pFunc+49,0,"char")
    return pbin
}
__static(var) {
}
__getVar(var) {
}
__getGlobalVar(__gGV_sVarName) {
    global
    return __getVar(%__gGV_sVarName%)
}
__getBuiltInVar(sVarName) {
    static pDerefs, DerefCount
    if !pDerefs ;= label->mJumpToLine->mArg[0]->deref
    {
        pDerefs := NumGet(NumGet(NumGet(__findLabel("__gBIV_marker"),4),4),8)
        Loop
            if ! NumGet(pDerefs+(A_Index-1)*12) {
                DerefCount := A_Index-1
                break
            }
    }
    low := 0
    high := DerefCount - 1
    Loop {
        if (low > high)
            break
        mid := (low+high)//2
        i := DllCall("shlwapi\StrCmpNIA","uint",NumGet(pDerefs+mid*12),"str",sVarName,"int",NumGet(pDerefs+mid*12,10,"ushort"))
        if i > 0
            high := mid - 1
        else if i < 0
            low := mid + 1
        else
            return NumGet(pDerefs+mid*12,4)
    }
    return 0
__gBIV_marker:
    return % 0,
    ( Join`s
A_AhkPath A_AhkVersion A_AppData A_AppDataCommon A_AutoTrim A_BatchLines
A_CaretX A_CaretY A_ComputerName A_ControlDelay A_Cursor A_DD A_DDD A_DDDD
A_DefaultMouseSpeed A_Desktop A_DesktopCommon A_DetectHiddenText
A_DetectHiddenWindows A_EndChar A_EventInfo A_ExitReason A_FormatFloat
A_FormatInteger A_Gui A_GuiControl A_GuiControlEvent A_GuiEvent A_GuiHeight
A_GuiWidth A_GuiX A_GuiY A_Hour A_IconFile A_IconHidden A_IconNumber A_IconTip
A_Index A_IPAddress1 A_IPAddress2 A_IPAddress3 A_IPAddress4 A_IsAdmin
A_IsSuspended A_KeyDelay A_Language A_LastError A_LineFile A_LineNumber
A_LoopField A_LoopFileAttrib A_LoopFileDir A_LoopFileExt A_LoopFileFullPath
A_LoopFileLongPath A_LoopFileName A_LoopFileShortName A_LoopFileShortPath
A_LoopFileSize A_LoopFileSizeKb A_LoopFileSizeMb A_LoopFileTimeAccessed
A_LoopFileTimeCreated A_LoopFileTimeModified A_LoopReadLine A_MDay A_Min A_MM
A_MMM A_MMMM A_Mon A_MouseDelay A_MSec A_MyDocuments A_Now A_NowUtc
A_NumBatchLines A_OSType A_OSVersion A_PriorHotkey A_ProgramFiles A_Programs
A_ProgramsCommon A_ScreenHeight A_ScreenWidth A_ScriptDir A_ScriptFullPath
A_ScriptName A_Sec A_Space A_StartMenu A_StartMenuCommon A_Startup
A_StartupCommon A_StringCaseSense A_Tab A_Temp A_ThisFunc A_ThisHotkey
A_ThisLabel A_ThisMenu A_ThisMenuItem A_ThisMenuItemPos A_TickCount A_TimeIdle
A_TimeIdlePhysical A_TimeSincePriorHotkey A_TimeSinceThisHotkey
A_TitleMatchMode A_TitleMatchModeSpeed A_UserName A_WDay A_WinDelay A_WinDir
A_WorkingDir A_YDay A_Year A_YWeek A_YYYY Clipboard ClipboardAll ComSpec false
ProgramFiles true
    )
}
__getVarInContext(sVarName, pScopeFunc=0) {
    static pThisFunc
    if pVar:=__getBuiltInVar(sVarName)
        return pVar
    if !pScopeFunc
        return __getGlobalVar(sVarName)
    if !pThisFunc && !(pThisFunc := __getFuncUDF(A_ThisFunc))
        return
    NumPut(NumGet(pScopeFunc+48,0,"char"),pThisFunc+48,0,"char")
    VarSetCapacity(ThisFuncProps, 20)
    , DllCall("RtlMoveMemory","uint",&ThisFuncProps,"uint",pThisFunc+20,"uint",20)
    , DllCall("RtlMoveMemory","uint",pThisFunc+20,"uint",pScopeFunc+20,"uint",20)
    return pVar
}
__listFuncs(UserFunctionsOnly=False) {
    this_file_index := NumGet(NumGet(__getFuncUDF(A_ThisFunc)+4),2,"ushort")
    if !(pFunc := __getFirstFunc())
        return
    Loop {
        if !UserFunctionsOnly || !NumGet(pFunc+49,0,"char") && NumGet(NumGet(pFunc+4),2,"ushort") != this_file_index
            list .= __str(NumGet(pFunc+0)) "`n"
        if !(pFunc := NumGet(pFunc+44)) ; pFunc->mNextFunc
            break
    }
    return SubStr(list,1,-1)
}
__findFunc(FuncName, BuiltIn="") {
    if ((pFunc:=__getFuncUDF(FuncName)) && !BuiltIn)
        return pFunc
    if !(pFunc:=__getFirstFunc())
        return 0
    Loop {  ; Note: ! is used here to ensure both values are true boolean 1 or 0.
        if (BuiltIn = "" or (!NumGet(pFunc+49,0,"uchar") = !BuiltIn))
            if (__str(NumGet(pFunc+0)) = FuncName) ; pFunc->mName
                return pFunc
        if !(pFunc := NumGet(pFunc+44)) ; pFunc->mNextFunc
            break
    }
    return 0
}
__getFirstFunc() {
    static pFirstFunc
    if !pFirstFunc {
        if !(pLine := __getFirstLine())
            return 0
        Loop {
            Loop % NumGet(pLine+1,0,"uchar") { ; pLine->mArgc
                pArg := NumGet(pLine+4) + (A_Index-1)*12  ; pLine->mArg[A_Index-1]
                if (NumGet(pArg+0,0,"uchar") != 0) ; pArg->type != ARG_TYPE_NORMAL
                    continue ; arg has no derefs (only a Var*)
                Loop {
                    pDeref := NumGet(pArg+8) + (A_Index-1)*12  ; pArg->deref[A_Index-1]
                    if (!NumGet(pDeref+0)) ; pDeref->marker (NULL terminates list)
                        break
                    if (NumGet(pDeref+8,0,"uchar")) ; pDeref->is_function
                    {
                        pFunc := NumGet(pDeref+4)
                        if (NumGet(pFunc+49,0,"uchar")) { ; pFunc->mIsBuiltIn
                            if !pFirstBIF
                                pFirstBIF := pFunc
                        } else { ; UDF
                            pFuncLine := NumGet(pFunc+4)
                            FuncLine := NumGet(pFuncLine+8)
                            FuncFile := NumGet(pFuncLine+2,0,"ushort")
                            if !pFirstFunc or (FuncFile < FirstFuncFile || (FuncFile = FirstFuncFile && FuncLine < FirstFuncLine))
                                pFirstFunc:=pFunc, FirstFuncLine:=FuncLine, FirstFuncFile:=FuncFile
                        }
                    }
                }
            }
            if !(pLine:=NumGet(pLine+20)) ; pLine->mNextLine
                break
        }
        if pFirstBIF
        {
            if pFirstFunc
            {   ; Look for the BIF using the UDF as a starting point.
                pFunc := pFirstFunc
                Loop {
                    if !(pFunc := NumGet(pFunc+44)) ; pFunc->mNextFunc
                        break
                    ; If the BIF is found, the UDF must precede it in the list.
                    if (pFunc = pFirstBIF)
                        return pFirstFunc
                }
            }
            pFirstFunc := pFirstBIF
            return pFirstFunc
        }
    }
    return pFirstFunc
}
__listLabels(UserLabelsOnly=False) {
    this_file_index := NumGet(NumGet(__getFuncUDF(A_ThisFunc)+4),2,"ushort")
    if pLabel := __getFirstLabel()
        Loop {
            if !UserLabelsOnly || NumGet(NumGet(pLabel+4),2,"ushort") != this_file_index
                list .= __str(NumGet(pLabel+0)) "`n"
            if ! pLabel := NumGet(pLabel+12)
                break
        }
    return SubStr(list,1,-1)
}
__findLabel(sLabel) {
    if pLabel := __getFirstLabel()
        Loop {
            if __str(NumGet(pLabel+0)) = sLabel
                return pLabel
            if ! pLabel := NumGet(pLabel+12)
                return 0
        }
}
__getFirstLabel() {
    static pFirstLabel
    if !pFirstLabel {
        if !(pLine := NumGet(__getFuncUDF(A_ThisFunc)+4))
            return 0
        Loop {
            act := NumGet(pLine+0,0,"char")
            if (act = 96 || act = 95) ; ACT_GOSUB || ACT_GOTO
                break
            if !(pLine:=NumGet(pLine+20)) ; pLine->mNextLine
                return 0
        }
        pFirstLabel := NumGet(pLine+24)
        Loop {
            if ! pPrevLabel:=NumGet(pFirstLabel+8)
                break
            pFirstLabel := pPrevLabel
        }
    }
    return pFirstLabel
    __getFirstLabel_HookLabel:
    goto __getFirstLabel_HookLabel
}
__getFirstLine() {
    static pFirstLine
    if (pFirstLine = "") {
        if pThisFunc := __getFuncUDF(A_ThisFunc) {
            if pFirstLine := NumGet(pThisFunc+4) ; mJumpToLine
            Loop {
                if !(pLine:=NumGet(pFirstLine+16)) ; mPrevLine
                    break
                pFirstLine := pLine
            }
        }
    }
    return pFirstLine
}
__getFuncUDF(FuncName) {
    if pCb := RegisterCallback(FuncName) {
        func := NumGet(pCb+28)
        DllCall("GlobalFree","uint",pCb)
    }
    return func
}
__str(addr,len=-1) {
    if len<0
        return DllCall("MulDiv","uint",addr,"int",1,"int",1,"str")
    VarSetCapacity(str,len), DllCall("lstrcpyn","str",str,"uint",addr,"int",len+1)
    return str
}
__expr(expr, pScopeFunc=0) {
    static pFunc, pThisFunc
    if !pFunc
        pFunc:=__getFuncUDF("__expr_sub"), pThisFunc:=__getFuncUDF(A_ThisFunc)

    if ! pArg:=__MakeExpressionArg(expr, pScopeFunc)
        return

    nInst := NumGet(pThisFunc+40)
    VarSetCapacity(Line%nInst%,32,0), __static(Line%nInst%), pLine:=&Line%nInst%

    NumPut(pArg,NumPut(1,NumPut(102,pLine+0,0,"char"),0,"char"),2), NumPut(pLine,NumPut(pLine,pLine+16))
    NumPut(pLine,pFunc+4)
    , ret := __expr_sub()
    , NumPut(0,pLine+1,0,"char"), DllCall("GlobalFree","uint",pArg)
    return ret
}
__expr_sub() {
    global
}
__MakeExpressionArg(expr, pScopeFunc=0) {
    static OPERAND_TERMINATORS = "<>=/|^,:"" `t*&~!()+-"
    i = 0
    open_parens = 0
    Loop {
        if (c:=SubStr(expr,++i,1)) = ""
            break
        if c = "
        {
            if ! i:=InStr(expr,"""",1,i+1)
                return 0, ErrorLevel:="Missing close-quote ("")"
        }
        else if c = '
        {
            if ! j:=InStr(expr,"'",1,i+1)
                return 0, ErrorLevel:="Missing close-quote (')"
            literal := SubStr(expr,i+1,j-i-1)
            StringReplace, literal, literal, ", "", UseErrorLevel
            expr := SubStr(expr,1,i-1) . """" . literal . """" . SubStr(expr,j+1)
            i := j + ErrorLevel
        }
        else if c = (
            open_parens += 1
        else if c = )
            open_parens -= 1
    }
    if open_parens > 0
        return 0, ErrorLevel:="Missing "")"""
    if open_parens < 0
        return 0, ErrorLevel:="Missing ""("""
    num_derefs = 0
    pos = 1
    Loop {
        if ! pos:=RegExMatch(expr, """.*?""|[\w#@$?\[\]\.%]+", word, pos)
            break
        marker := pos-1
        pos += StrLen(word)
        if SubStr(word,1,1)="""" ; skip quoted literal strings
            continue
        if InStr(word,".") or word+0!="" ; number or error
            continue
        if word = ?
            continue
        param_count = 0
        if is_func:=SubStr(expr,pos,1)="("
        {
            if InStr(word, "%")
                return 0, Errorlevel:="Dynamic function calls are not supported."
            if ! var_or_func:=__findFunc(word)
                return 0, ErrorLevel:="Call to nonexistent function """ word """."
            i := pos
            open_parens = 1
            Loop {
                if (c:=SubStr(expr,++i,1))=""
                    break
                if (param_count=0 && !(c=" "||c="`t"||c=")"))
                    param_count = 1
                if c = ,
                    param_count += open_parens=1 ? 1 : 0
                else if c = (
                    open_parens += 1
                else if c = )
                    if --open_parens = 0
                        break
            }
            if (param_count < NumGet(var_or_func+16))
                return 0, ErrorLevel:="Too few parameters passed to function """ word """."
            if (param_count > NumGet(var_or_func+12))
                return 0, ErrorLevel:="Too many parameters passed to function """ word """."
        }
        else
        {
            if i:=InStr(full_word:=word, "%") {
                original_marker := marker
                Loop {
                    if !(j:=InStr(full_word, "%", 1, i+1)) or j-i<2
                        return 0, ErrorLevel:="Invalid deref """ full_word """."
                    word_len := StrLen( word := SubStr(full_word, i, j-i+1) )
                    marker := original_marker + i-1
                    if var_or_func:=__getVarInContext(SubStr(word,2,-1), pScopeFunc)
                        gosub __MakeExpressionArg_AddDeref
                    if ! i:=InStr(full_word, "%", 1, j+1)
                        break
                }
                continue
            }
            var_or_func := __getVarInContext(word, pScopeFunc)
        }

        if var_or_func
        {
            word_len := StrLen(word)
            gosub __MakeExpressionArg_AddDeref
        }
    }
    pArg := DllCall("GlobalAlloc","uint",0x40,"uint",25+StrLen(expr)+num_derefs*12)
    DllCall("lstrcpy","uint",pArg+12,"str",expr)
    NumPut(pDerefs:=pArg+13+StrLen(expr),NumPut(pArg+12,NumPut(StrLen(expr),NumPut(1,NumPut(0,pArg+0,0,"char"),0,"char"),0,"short")))
    Loop, %num_derefs% {
        DllCall("RtlMoveMemory","uint",pDeref:=pDerefs+A_Index*12-12,"uint",&deref%A_Index%,"uint",12)
        NumPut(pArg+12+NumGet(pDeref+0),pDeref+0) ; deref.marker += base_address_of_text
    }
    return pArg, ErrorLevel=0
    __MakeExpressionArg_AddDeref:
        num_derefs += 1
        VarSetCapacity(deref%num_derefs%,12)
        NumPut(word_len,NumPut(param_count,NumPut(is_func,NumPut(var_or_func,NumPut(marker,deref%num_derefs%)),0,"char"),0,"char"),0,"short")
    return
}
