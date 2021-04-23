; Popup AHK calculator v.3.51
; Works with AHK 1.0.47.04 ... 1.0.47.06
; Includes Lexikos' lowlevel functions (http://www.autohotkey.com/forum/viewtopic.php?t=26300)

; Updated LowLevel functions included to handle quoted commas
; Bugfix in parsing ";" separated commands (ignore quoted ;)
; ";;" in literal strings not treated as line-end comment
; Improved `var -> "var" replacement (not in quotes, to keep `n,`t...)
; `n, `t... are now supported in strings

; Measure width of all text/header for consitent display in any font, fontsize and dpi settings
; dllcall("GetDialogBaseUnits","UInt") --> pixels for tabstop (dpi dependent)
; New user interface: Expression imput (~Paper) on top, results below.
;-- Enter evaluates current line.
;---- In last line: insert blank line below.
;-- Ctrl-Enter: insert newline char
;-- Shift-Enter: execute (multiline, partial line) selection
; Ctrl-= duplicate current line
; ESC clear current line
; Ctrl-Z undo/redo last edit

; Context menu in calculator window (right click, Appskey):
;--- Help,Load,Save,Hide,Exit
;--- duplicate_line,clear_line,select_line,select_all,undo
;--- cut,copy,paste,delete
; Removed Alt-A/U/E history editing (history is now directly editable)
; New context menu and tray menu items, shortcuts:
;-- Alt-E: appEnd-to-history
;-- Alt-S: Save selection
;-- Alt-W: Write history to file.

; Tab: insert line-end from first/next match (restarts after edit of expr)
;--- completed part is selected (blue)
;--- Ctrl-Z: previous/this match
; Shift-Tab: insert line-end from last/previous match

; Incremental search in expressions:
;-- Alt-F toggles search field, ESC closes
;-- Tab/Shift-Tab: next/previous match
;-- Enter: 1st match
;-- UP arrow: goto found text

; Incremental search in Help (Enter/Tab/Shift-Tab: 1st/next/prev match)
;-- Up/Down: scroll help text

; New keys in calc.ini:
;-- MaxHist=99 number of input lines read from history (more saved)
;-- KeptOutput=9 number of last results kept in output history _1, _2...

; New construct: ";;" line-end comment
; Multi-line results shown in one line, `n --> S
;   long output lines are truncated (use msg() instead)
; Changed msg(x[,x1...,x9]): up to 10 arguments in separate lines
; Added run(file): execute list of expressions stroed in file
; Added time(Format="",Time=""): formatted time (now) ~ AHK's FormatTime
; Added Mode(["DEGree/RADians"]): set/toggle trigonometric domain
; Changed all trigonometric functions to work in selected domain
; Added FFormat(["format"]): set floating point format, default 0.16e
; Window title now shows trig mode [RAD] and floating pt format [0.16e]
; Added constants
;--- Dmax = 1.7976931348623157e+308 (largest double)
;--- Dmin = 2.2250738585072014e-308 (least positive normalized double)
;--- Deps = 1.1102230246251565e-016 (=smallest douple: 1 + Deps > 1)

; Added fnext(x[,d=1]): next float (add ad to LS bits of x) for left/right limit
; Added f2int(d): integer representation of bits of floating point (double) d
; Added int2f(i): floating point representation (double) of bits of integer i

; Added Solve3(x,a,d,c,b): solve the tridiagonal system [a,d,c]*x = b for x
; UpSample(z,y,p): insert p points in (y[i],y[i+1]) via natural cubic spline

; Added CBget('x') : Get vector from the ClipBoard (CSV format: 1, "ab", cd)
; Added CBput(x[,form]): Put formatted vector to the ClipBoard [comma separated]

; Added Bin2Hex(Addr,Len): Convert Len bytes @ Addr to hex stream
; Added Hex2Bin(ByRef Bin, Hex): Convert Hex stream to binary, store in var Bin
; Added BC(NumStr,InputBase,OutputBase): Base Conversion
; Added from0(x): round away FROM 0
; Added to0(x):   round toward TO 0 (truncate)

; Added diff(y,x): (~differential) y[i] <- x[i+1]-x[i], i=1..x[0]-1
; Added cumsum(y,x): (~integral) y[i] <- x[i]+x[i-1]+..+x[1], i=1..x[0]

; Added Error function erf(x), related to the normal distribution
; Added GAMMA(a[,x]): upper incomplete gamma: Integral(t**(a-1)*e**-t, t=x..inf)
; Added LnGamma(a): direct method (less overflow) [balanced: speed vs. code complexity]

; Start and End limts of the Axes are now shown in graphs

; CALC-TEST.HST sample history file uploaded with examples for most functions

#SingleInstance Force
#NoEnv
SetBatchLines -1
Process Priority,,High

__help =
(Join`r`n
Calculator Shortcuts:
   Enter:      `tEvaluate current line in Expressions control
   Shift-Enter:`tEvaluate selected text (multi-, partial line)
   Ctrl-Enter :`tLine break
   Esc:        `tIn expression: Clear current line, else HIDE
   Ctrl-Z:     `tUndo/Redo last edit
   BS/Del/Ctrl-Del:`tDelete part of expression

   Home/End/Left/Right/Up/Down/PgUp/PgDn,
   ... Ctrl-Left/Right, Ctrl-Home/End: move caret
   Shift-Home/End/Left/Right, Ctrl-A: Select

   Alt-V/Enter:`teValuate expression
   Alt-S:    `tSave selection
   Alt-W:    `tWrite history to file
   Alt-E:    `tappEnd history to file
   Alt-L:    `tLoad history
   Alt-F:    `tShow/Hide incremental Find field
           `t`tEnter: 1st, Tab/Shift-Tab: next/prev,  : GoTo found text

   Alt-H/F1:`tHelp window with incremental search; Enter/Tab/Shift-Tab,Scroll
   Ctrl-F1: `tFind function under cursor highlighted in Help
   Ctrl-=:  `tDuplicate current line
   TAB:     `tCommand completion from first/next match in expressions
   Shift-TAB`tCommand completion from last/previous match in expressions

Array List Shortcuts:
   Delayed double click: edit value
   Context menu: More, Less, Refresh
   Enter: More (Add new entry. Enter accepts, Esc aborts)
   Alt-M: More
   Alt-L: Less (delete last etry)
   Alt-R: Refresh (take over array changes)

Graph:
   Mouse cursor: crosshair with ToolTip (x,y)
   Right-click: MsgBox current (x,y), Copy to ClipBoard: Ctrl-C

Basic constructs:
   `n, `r, `b, `t, `v, `a : Escape Sequences (special chars)
   `var : "var"
   ; : separator between expressions
   ;; : line end comment
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

General Functions:
   Mode(["DEGree"/"RADians"]) : set/toggle trigonometric domain
   FFormat(["format"]) : set floating point format, default 0.16e
   b(BitString) : string of bits to number, Sign = MS_bit
   BC(NumStr,InputBase,OutputBase) : Base Convertion
   Bin2Hex(Addr,Len) : Convert Len bytes @ Addr to hex stream
   Hex2Bin(Bin, Hex) : Convert Hex stream to binary, store in var Bin

   run(file) : execute expressions stroed in file | file.clc
   list(vector) : Edit/Sort ListView of elements. Build: Enter-value-Enter
      RightClick menu: More (Enter, Alt-M: add new); Less (Alt-L: del last)
   msg(x[,x1..,x9]) : (~MsgBox) Print arguments in separate lines
   time([Format,Time]) : formatted time [now] ~ AHK's FormatTime

   sign(x) : the sign of x (-1,0,+1)
   to0(x):   round toward TO 0 (truncate)
   from0(x): round away FROM 0
   rand(x,y) : random number in [x,y]; rand(x) new seed=x.

Float Functions:
   f2c(f) : Fahrenheit -> Centigrade
   c2f(c) : Centigrade -> Fahrenheit

   fcmp(x,y[,tol=9]) : floating point comparison with tolerance
   fnext(x[,d=1]) : next float (ad to LS bits of x) for left/right limit
   f2int(d): integer representation of bits of floating point (double) d
   int2f(i): floating point representation (double) of bits of integer i

   ldexp(x,e) : load exponent -> x * 2**e
   frexp(x,e) : scaled x: 0 or in [0.5,1); e <- exp: x = frexp(x) * 2**e

 -trigonometric functions in degrees or radians:
   sin(x), cos(x), tan(x), cot(x), sec(x), cosec(x)
 -arcus (inverse) trigonometric functions in degrees or radians:
   asin(x), acos(x), atan(x), acot(x), asec(x), acosec(x)
   atan2(x,y) : 4-quadrant atan

   sinh(x), cosh(x), tanh(x), coth(x)  : hyperbolic functions
   asinh(x),acosh(x),atanh(x),acoth(x) : inverse hyperbolics

   erf(x) : Error function
   GAMMA(a[,x]) : upper incomplete gamma: Integral(t**(a-1)*e**-t, t=x..inf)
   LnGamma(a) : Log of gamma(a), direct method (less overflow)

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
   Reci64(m [,ms]) : Int64 2**ms/m (set ms): normalized (negative); unsigned m
   MSb(x) : Most  Significant bit: 1..64, (0 if x=0)
   LSb(x) : Least Significant bit: 1..64, (0 if x=0)

Iterators/Evaluators
   eval(expr) : evaluate ";" separated expressions, [.] index OK
   call(FName[,p1..,p10]) : evaluate expression in FName,
      sets variables FName1:=p1, FName2:=p2...
   solve('x',x0,x1,'expr'[,tol]) : find x in [x0,x1] where expr = 0
   fmax('x',x0,x1,x2,'expr'[,tol])) : x in [x0,x2] where expr=max, start at x1

   for(Var,i0,i1,d,expr) : evaluate all, return result of last
      {expr(Var:=i0),expr(Var:=i0+d)...}, until i1
   while(cond,expr) : evaluate expr while cond is true; -> last result
   until(expr,cond) : evaluate expr until cond gets true (>= once); -> last

Array creating functions (-> X="X", X_0=length, X_1,X_2... entries):
   copy("X",Y) : duplicates Y
   part("Y",X,i0,i1[,d=1]) : Y (!= X) <- {X[i0],X[i0+d]..,X[~i1]}
   join("Z",X,Y) : Z <- join arrays {X,Y}, (Z != X or Y)

   assign("X",entry1...) : assign (<=30) entries to array X
   more("X",entry1...) : add (<=30) new entries to end of array X

   seq("X",i0,i1[,d=1]) : set up linear sequence X = {i0,i0+d..,i1}
   array("X","i",i0,i1,d, "expr") : X = {expr(i:=i0),expr(i:=i0+d)..,expr(i~=i1)}

   sort("y",x[.opt]) : y <- sorted array x
      opt = 0: random, 1: no duplicates, 2: reverse, 3: reverse+unique

   @("Z",X,"op|func"[,Y=]) : elementwise ops, 0-pad; Y or X can be scalar
   diff(y,x) : (~differential) y[i] <- x[i+1]-x[i], i=1..x[0]-1
   cumsum(y,x) : (~integral) y[i] <- x[i]+x[i-1]+..+x[1], i=1..x[0]

   Solve3(x,a,d,c,b) : solve the tridiagonal system [a,d,c]*x = b for x
   UpSample(z,y,p) : insert p points in (y[i],y[i+1]) via natural cubic spline

   plmul("z",y,x) : z <- polynomial y*x (convolution, FIR filter)
   pldiv("q","r",n,d) : polynomial division-mod: q <- n/d; r <- mod(n,d)

   primes("p",n) : p <- primes till n (Sieve of Eratosthenes)
   pDivs("d",n) : d <- prime divisors of n (increasing)

Vector -> scalar functions
   mean(X), std(X), moment(k,X) : statistics functions
   sum(X), prod(X), sumpow(k,X), dot(X,Y)
   pleval(p,x): evaluate polynomial, <- p(x), (Horner's method)

   min(x[,x1..,x9]) : min of numbers or one vector
   max(x[,x1..,x9]) : max of numbers or one vector
   pmean(p, x,[,x1..,x9]) : p-th power mean of numbers or one vector

Graphing functions
   graph(x0,x1,y0,y1[,width=400,height=300,BGcolor=white]) :
     create/change graph window to plot in
     graph() : DESTROY
   Xtick([Array=10,LineColor=gray,LineWidth=1]) : add | lines at x positions
     can be called multiple times, BEFORE plot
     Array=integer : equidistant ticks, Array="" : 11 ticks
     Array=float : single line
   Ytick([Array=10,LineColor=gray,LineWidth=1]) : add - lines at y positions
   plot(Y[,color=blue,LineWidth=2]) : add plot of Y with X = {1..len(Y)}
     if no graph paper: create default one
     plot() : ERASE function plot
   plotXY(X,Y[,color=blue,LineWidth=2]): add XY plot to last graph
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
   spi = sqrt(pi)

   Dmax = max double
   Dmin = least positive normalized double
   Deps = smallest douple: 1 + Deps > 1

Unit conversion constants (150*lb_kg -> 150 pounds = 68.0389 Kg)
   inch_cm, foot_cm, mile_km
   oz_l,  pint_l,  gallon_l
   oz_g,  lb_kg
   acre_m2
)

__deg = RAD                                    ; default trignometric mode: Radians
__fformat = 0.16e                              ; max precise default AHK internal format
SetFormat Float, %__fformat%                   ; constants in default precision

pi  = 3.141592653589793238462643383279502884197169399375105820974944592 ; pi
pi_2= 1.570796326794896619231321691639751442098584699687552910487472296 ; pi/2
pi23= 2.094395102393195492308428922186335256131446266250070547316629728 ; 2pi/3
pi43= 4.188790204786390984616857844372670512262892532500141094633259455 ; 4pi/3
rad = 0.017453292519943295769236907684886127134428718885417254560971914 ; pi/180
deg = 57.29577951308232087679815481410517033240547246656432154916024386 ; 180/pi
pi2 = 9.869604401089358618834490999876151135313699407240790626413349374 ; pi**2
spi = 1.772453850905516027298167483341145182797549456122387128213807790 ; sqrt(pi)
e   = 2.718281828459045235360287471352662497757247093699959574966967628 ; e
ln2 = 0.693147180559945309417232121458176568075500134360255254120680009 ; log(2)
lg2 = 0.301029995663981195213738894724493026768189881462108541310427461 ; log10(2)
lge = 0.434294481903251827651128918916605082294397005803666566114453783 ; log10(e)
ln10= 2.302585092994045684017991454684364207601101488628772976033327901 ; ln(10)

DllCall("RtlMoveMemory", "DoubleP",Dmax, "Int64P",0x7fefffffffffffff, "Uint",8) ; largest double
DllCall("RtlMoveMemory", "DoubleP",Dmin, "Int64P",0x0010000000000000, "Uint",8) ; smallest normalized double > 0
DllCall("RtlMoveMemory", "DoubleP",Deps, "Int64P",0x3CA0000000000001, "Uint",8) ; smallest double + 1 > 1
inch_cm = 2.54                                 ; inches to centimeters
foot_cm = 30.48                                ; feet to centimeters
mile_km = 1.609344                             ; miles to Kilometers
oz_l    = 0.02957352956                        ; liquid ounces to liters
pint_l  = 0.4731764730                         ; pints to liters
gallon_l= 3.785411784                          ; gallons to liters
oz_g    = 28.34952312                          ; dry ounces to grams
lb_kg   = 0.45359237                           ; pounds to Kilograms
acre_m2 = 4046.856422                          ; acres to square meters

__init()                                       ; init low-level functions
SplitPath A_ScriptName,,,,__file               ; default history file
__ini  := __file . ".ini"                      ; window position, hotkeys
__hst  := __file . ".hst"                      ; default expressions history file
VarSetCapacity(__Z,63)                         ; formatted numbers used in graphs
OnExit CleanUp
__cursor := DllCall("LoadCursor", "uint", 0, "uint", 32515)
__lastMatch = 0                                ; new search
__a := __b := 1234                             ; reserve memory for Int
__WinTitle = AHK Expression Evaluator          ; [status] info follows

Menu Tray, NoStandard                          ; custom tray menu
Menu Tray, Click, 1                            ; single click activates
Menu Tray, Add, sh&Ow, Calc
Menu Tray, Add, &Help,  ButtonHelp
Menu Tray, Add, &Save selection,ButtonSave
Menu Tray, Add, &Load history,  ButtonLoad
Menu Tray, Add, &Write history, ButtonWrite
Menu Tray, Add, app&End history,ButtonAppend
Menu Tray, Add, e&Xit, CleanUp
Menu Tray, Default, sh&Ow
Menu Tray, Icon, %A_WinDir%\system32\calc.exe  ; borrow the icon of calc.exe

Menu RightClick, Add, &Help,  ButtonHelp
Menu RightClick, Add                           ; separator
Menu RightClick, Add, &Repeat line,RepeatLine
Menu RightClick, Add, &Blank line, BlankLine
Menu RightClick, Add, select li&Ne,SelectLine
Menu RightClick, Add, select &All, SelectAll
Menu RightClick, Add, &Undo, Undo
Menu RightClick, Add                           ; separator
Menu RightClick, Add, cu&T,   Cut
Menu RightClick, Add, &Copy,  Copy
Menu RightClick, Add, &Paste, Paste
Menu RightClick, Add, &Delete,Delete
Menu RightClick, Add                           ; separator
Menu RightClick, Add, &Save Selection,ButtonSave
Menu RightClick, Add, &Load history,  ButtonLoad
Menu RightClick, Add, &Write history, ButtonWrite
Menu RightClick, Add, app&End History,ButtonAppend
Menu RightClick, Add                           ; separator
Menu RightClick, Add, h&Ide, GuiClose
Menu RightClick, Add, e&Xit, CleanUp

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

IniRead __FontSz,%__ini%, Font, size, 11       ; Font
IniRead __Font,%__ini%, Font, font, Tahoma

IniRead __CalcHK,%__ini%, Hotkeys, Calc, #c    ; popup calculator
HotKey %__CalcHK%, Calc
IniRead __VarsHK,%__ini%, Hotkeys, Vars,+#d
HotKey %__VarsHK%, Vars                        ; show variables (DEBUG)

IniRead _0, %__ini%, Settings, KeptOutput, 9   ; length of output history
IniRead __MaxHist, %__ini%,Settings,MaxHist,99 ; #lines kept in history (99)

                                         ; Get text dimensions for font, fontsz, dpi settings
__tabU := dllcall("GetDialogBaseUnits","UInt")//2 & 0xFF ; pixels for each tabstop
Gui font, s%__FontSz%, %__Font%                ; Same as Main calculator GUI

Gui Add, Text,,%A_Space%                    ; metrics for the Space char
GuiControlGet __POS, Pos, Static1
__SW := __POSW                                 ; width of Space
__TH := __POSH                                 ; height of 1-line text control

Gui Add, Text,,0                               ; write 0 to estimate digit size
GuiControlGet __0, Pos, Static2             ; get metrics of "0", __0W = width, __0H = height

__winW := 66*__0W + 4                          ; room for 65 digits + margin
__midl := round(.9*__winW/__tabU)              ; middle measured in display units (4 pixels)

Gui Add, Text,,hex                          ; metrics for info before tab
GuiControlGet __POS, Pos, Static3
__tab  := round((__POSW+__SW)/__tabU)          ; tab in info box

Gui Add, Text,,AHK string`n.6g S .17g`nInt S  Uint`nhex S -hex
GuiControlGet __POS, Pos, Static4           ; metrics for info box
__infW := __POSW + 2*__SW                      ; width with two gaps
__winWW:= __infW + __winW                      ; total width for input, history edit and Help

Gui Add, Text,,Value                        ; LIST
GuiControlGet __POS, Pos, Static5              ; width of "Value"
__t := SubStr("                          ",1,ceil((26*__0W - __POSW)/__SW/2))
__listHDR := __t . "Value" . __t . "| Idx "    ; pad both sides w. spaces for wide enough cells

Gui Add, Text,,%__listHDR%                     ; width of raw header text
GuiControlGet __POS, Pos, Static6
__listW := __POSW + 4*__SW + 4*__tabU + 2      ; width of LV = header text + 4*gap + line

Gui Destroy                              ; Measuring GUI is not needed any more

__file := __hst                          ; Standard history file
GoSub LoadHistory                        ; Gui below shows it

Gui font, s%__FontSz%, %__Font%          ; Main calculator GUI
Gui +Delimiter`n
Gui Margin, 5, 5
Gui Add, Edit, 0x100 r5 -WantReturn -Wrap w%__winWW% HWND__hwndE v__history gEdit, %__history%`n
Gui Add, Edit, -E0x200 -0x200000 cGreen x5 y+9 r5 w%__infW% t%__tab% ReadOnly -Wrap HWND__hwndI
  , AHK string`n.6g`tS .17g`nInt`tS  Uint`nhex`tS -hex`n   Binary ; no frame|scroll bar
Gui Add, Edit, yp-2 x+0 -0x200000 -Wrap v__res w%__winW% r5 t%__midl% ReadOnly HWND__hwndO
Gui Add, Text, cGreen x5 y+10, Search%A_Space%
GuiControlGet __POS, Pos, Static1
Gui Add, Edit,% "-WantReturn x+0 yp-3 r1 v__find gFIND HWND__hwndF w" . __winWW-__POSW
Gui Add, Button, Hidden Default, e&valuate     ; hidden buttons
Gui Add, Button, Hidden, &Write                ; ..activated by Alt-Letter
Gui Add, Button, Hidden, app&End
Gui Add, Button, Hidden, &Load
Gui Add, Button, Hidden, &Save                 ; selection
Gui Add, Button, Hidden, &Help
Gui Add, Button, Hidden, &Find
GuiControl Hide, Static1                       ; hidden search control
GuiControl Hide, __find

Position(name,default,max) {                   ; position <- ini, with error check
   Global __ini
   IniRead x, %__ini%, Window Positions, %name%, %default%
   Return x < -10 ? 0 : x > max ? max : x
}
__CalcX := Position("CalcX", A_ScreenWidth//2, A_ScreenWidth-100)
__CalcY := Position("CalcY", A_ScreenHeight//2,A_ScreenHeight-80)
__HelpX := Position("HelpX", 180,              A_ScreenWidth-100)
__HelpY := Position("HelpY", 0,                A_ScreenHeight-80)
__ListX := Position("ListX", 180,              A_ScreenWidth-100)
__ListY := Position("ListY", A_ScreenHeight//2,A_ScreenHeight-80)
__GraphX:= Position("GraphX",A_ScreenWidth//2, A_ScreenWidth-100)
__GraphY:= Position("GraphY",0,                A_ScreenHeight-80)

Gui Show, AutoSize Hide x%__CalcX% y%__CalcY%, %__WinTitle% [%__deg%] [%__fformat%]
Gui +LastFound
WinGet __CalcID, ID
Gui -LastFound

Gui 3:font, s%__FontSz%, %__Font%              ; Help window
Gui 3:Margin, 5, 5
Gui 3:Add, Edit, 0x100 w%__winWW% r20 v__help HWND__hwndH Readonly, %__help% ; keep selection visible
Gui 3:Add, Text, y+10, Search%A_Space%
GuiControlGet __POS, 3:Pos, Static1            ; width of text
Gui 3:Add, Edit,% "x+0 yp-3 r1 v__HelpSearch ghFIND w" . __winWW-__POSW
Gui 3:Add, Button, x0 y0 Hidden Default, Search
Gui 3:Show, Hide, AHK Calculator HELP
Gui 3:+LastFound
WinGet __HelpID, ID
Gui 3:-LastFound

GroupAdd CalcGroup, ahk_id %__CalcID%
GroupAdd HelpGroup, ahk_id %__HelpID%

SendMessage 0xB6,-0x80000000,0x7fffffff,,ahk_id %__hwndE% ; scroll all the way down
SendMessage 0xB1, 0x7fffffff,0x7fffffff,,ahk_id %__hwndE% ; caret after last char

ControlFocus,, ahk_id %__hwndE%                ; Select Input field

GUI SHOW                                       ; Remove to start script dormant

OnMessage(0x205,"RCmessage")                   ; Monitor WM_RBUTTONUP = 0x205

Return

;============ END of Autoexecute Section ============;

Vars:
   ListVars ; for debug!
Return

Calc:
   Gui Show
Return

ButtonEvaluate:                                ; Alt-V or Enter: evaluate expression
   If (GetKeyState("Shift","P")) {             ; Shift-Enter
      SendMessage 0xB0,&__a,&__b,,ahk_id %__hwndE% ; EM_GETSEL
      __a := NumGet(__a)                           ; selection start
      __b := NumGet(__b)                           ; selection end: `r`n newlines assumed!
      ControlGetText __History,,ahk_id %__hwndE%   ; current history data: `r`n newlines
      __t := SubStr(__History,__a+1,__b-__a)       ; text in the selection
      StringReplace __t, __t, `r,,ALL
      Loop Parse, __t, `n
          __s := __eval(A_LoopField)               ; EVAL each line
      GuiControl,,__res, %__s%                     ; res <-- last result
   }
   Else {                                      ; {Enter}
      ControlGet __c, CurrentLine,,,ahk_id %__hwndE%
      ControlGet __code,Line,%__c%,,ahk_id %__hwndE%

      GuiControl,,__res, % __eval(__code)          ;  EVAL --> res
   }

   GuiControl Focus,__history                  ; back to Input window
   ControlGet __L,LineCount,,,ahk_id %__hwndE% ; current length of history
   If (__c = __L && __code > "")
      ControlSend,,{End}^{Enter},ahk_id %__hwndE% ; add blank line below last, if not blank
Return

GuiClose:                                      ; hide calculator
GuiEscape:
   WinGetPos __CalcX, __CalcY,,, ahk_id %__CalcID%
   Gui Hide                                    ; keep it alive for fast activation
Return

#IfWinActive ahk_group CalcGroup               ; \/ -------------------------- \/

F1::                                           ; F1: Help
   GoSub ButtonHelp                            ; redraw help window
   GuiControl 3:Focus, __HelpSearch            ; focus on search
Return

^F1::                                          ; Ctrl-F1: Help on selected function
   ControlGet __t, CurrentLine,,,ahk_id %__hwndE%
   ControlGet __code,Line,%__t%,,ahk_id %__hwndE%
   ControlGet __col,CurrentCol,,,ahk_id %__hwndE% ; pos 1..
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

^=::                                           ; Ctrl-=: duplicate current line
DuplicateLine:
   ControlSend,,{Home}+{End},ahk_id %__hwndE%  ; select line
   SendMessage 0xB0,&__a,&__b,,ahk_id %__hwndE% ; EM_GETSEL
   __a := NumGet(__a)                          ; selection start
   __b := NumGet(__b)                          ; selection end: `r`n newlines assumed!
   ControlGetText __History,,ahk_id %__hwndE%  ; current history data: `r`n newlines
   __t := SubStr(__History,__a+1,__b-__a)      ; text in the selection
   ControlSend,,{End}^{Enter},ahk_id %__hwndE% ; deselect, insert new line
   SendMessage 0xC2, 1, &__t,,ahk_id %__hwndE% ; EM_REPLACESEL
Return

AppsKey::                                      ; context menu as right click on Expression
   MouseGetPos,,, __winID
   If (__winID != __calcID)
      MouseMove 10, 30, 0
   RCmessage(0, 0, 0, __hwndE)
Return

tab::                                          ; command completion | find 1st / next
   ControlGetFocus __f, ahk_id %__CalcID%
   If (__f = "Edit1")                          ; Command completion (forward circular)
      GoTo NextMatch
   Else If (__f = "Edit4")                     ; Find 1st / NEXT
      GoTo NextFind
   Else
      Send {Tab}
Return

+Tab::                                         ; Backward find
   ControlGetFocus __f, ahk_id %__CalcID%
   If (__f = "Edit1")                          ; Command completion backward
      GoTo PrevMatch
   Else If (__f = "Edit4")                     ; Find 1st / PREV
      GoTo PrevFind
   Else
      Send {Tab}
Return

Esc::                                          ; Clear line / Cancel Find
   ControlGetFocus __f, ahk_id %__CalcID%
   If (__f = "Edit1")                          ; Clear expression
      ControlSend,, {END}+{HOME}{DEL}, ahk_id %__CalcID%
   Else If (__f = "Edit4")                     ; Cancel Find
      GoTo ButtonFind
   Else
      Send {Esc}
Return

Up::                                           ; GoTo Found text
   ControlGetFocus __f, ahk_id %__CalcID%
   If (__f = "Edit4") {
      ControlFocus,,ahk_id %__hwndE%
      SendMessage 0xB0,&__a,&__b,,ahk_id %__hwndE% ; EM_GETSEL
      __b := NumGet(__b)                           ; selection end
      SendMessage 0xB1,__b,__b,,ahk_id %__hwndE%   ; EM_SetSel=0xB1
   }
   Else
      Send {Up}
Return

Enter::
   ControlGetFocus __f, ahk_id %__CalcID%
   If (__f = "Edit4")                          ; Find 1st match
      GoTo Find
   Else
      Send {Enter}
Return

#IfWinActive                                   ; /\ -------------------------- /\

Edit:
   __lastMatch = 0                             ; after edit start new search
Return

RCmessage(__wP, __lP, __msgP, __hwndP) {       ; Simulated context menu
   Global
   If (InStr(__hwndE . __hwndI . __hwndO . __CalcID, __hwndP)) {
      MouseGetPos __mx, __my, __mWin, __mCtrl
      Menu RightClick, Show
      Return 0
   }
   Return
}

MouseBack:                                     ; save place to return for action
   ControlFocus %__mCtrl%, ahk_id %__mWin%
   MouseMove __mx, __my, 0
Return

BlankLine:                                     ; clear current line
   GoSub MouseBack
   Click __mx, __my
   Send {ESC}
Return

RepeatLine:                                    ; duplicate current line
   GoSub MouseBack
   Click __mx, __my
GoTo DuplicateLine

SelectLine:
   GoSub MouseBack
   Click __mx, __my
   Send {Home}+{End}^c
Return

SelectAll:
   GoSub MouseBack
   Click __mx, __my
   Send ^a
Return

Undo:
   GoSub MouseBack
   Send ^z
Return

Cut:
   GoSub MouseBack
   Send ^x
Return

Copy:
   GoSub MouseBack
   Sleep 50
   Send ^c
Return

Paste:
   GoSub MouseBack
   Click __mx, __my
   Send ^v
Return

Delete:
   GoSub MouseBack
   Send {Del}
Return

SaveSelection:                                 ; save selected expressions to file
   FileDelete %__file%                         ; delete file if exists
   SendMessage 0xB0,&__a,&__b,,ahk_id %__hwndE% ; EM_GETSEL
   __a := NumGet(__a)                           ; selection start
   __b := NumGet(__b)                           ; selection end: `r`n newlines assumed!
   ControlGetText __History,,ahk_id %__hwndE%   ; current history data: `r`n newlines
   __t := SubStr(__History,__a+1,__b-__a)       ; text in the selection
   StringReplace __t, __t, `r,,ALL
   FileAppend %__t%, %__file%                  ; expressions saved
Return

WriteHistory:                                  ; overwrite file with history data
   FileDelete %__file%
AppendHistory:                                 ; append history to file
   GuiControlGet __history                     ; current content of history: `n newlines!
   __history := RegExReplace(__history,"^`n+|`n+$|`n(?=`n)")
   FileAppend %__history%, %__file%            ; expressions w/o blank lines
Return

LoadHistory:                                   ; load maxHist lines of history data
   FileRead __history, %__file%                ; ... w/o redundant newlines
   StringReplace __history,__history,`r,`n,ALL ; work with `n and `r`n newlines!
   __history := RegExReplace(__history,"^`n+|`n+$|`n(?=`n)")
   StringGetPos __pos, __history, `n, R%__maxHist%
   StringRight __history, __history, % StrLen(__history)-__pos-1
   GuiControl,,__history, %__history%
Return

NextMatch:                                     ; Command completion FORWARD
   ControlGetText __hist,,ahk_id %__hwndE%     ; current history data: `r`n newlines for insertion

   SendMessage 0xB0,&__a,0,,ahk_id %__hwndE%   ; EM_GetSel=0xB0
   __a := NumGet(__a)                          ; selection start (or caret pos)
   SendMessage 0xBB,-1,,,ahk_id %__hwndE%      ; EM_LineIndex=0xBB
   __c := ErrorLevel                           ; pos1 of current line
   __code := SubStr(__hist,__c+1,__a-__c)

   __hist = `r`n%__hist%`r`n                   ; add leading and trailing newlines
   __code = `r`n%__code%                       ; for search from pos1 in line
   __match := __lastMatch                      ; search after this

   StringGetPos __pos, __hist, %__code%,, __match
   If (__pos = __c)                         ; jump over own line
      StringGetPos __pos,__hist,%__code%,, __c+1

   If (__pos < 0) {                            ; no more match
      __lastMatch = 0                          ; start over even if no selection to delete
      SendMessage 0xC2,1,"",,ahk_id %__hwndE%  ; delete selection | nothing: EM_ReplaceSel=0xC2
      Return                                   ; nothing to insert
   }
   StringGetPos __match,__hist,`r`n,,__pos+1   ; next newline (always found)
   __t := SubStr(__hist,__pos+StrLen(__code)+1,__match-__pos-StrLen(__code))

   SendMessage 0xC2,1,&__t,,ahk_id %__hwndE%              ; EM_ReplaceSel=0xC2
   SendMessage 0xB1,__a,__a+StrLen(__t),,ahk_id %__hwndE% ; EM_SetSel=0xB1
   SetTimer SetMatch, -1                       ; set lastMatch AFTER Edit resets it
Return

PrevMatch:                                     ; Command completion BACKWARD
   ControlGetText __hist,,ahk_id %__hwndE%     ; current history data: `r`n newlines for insertion

   SendMessage 0xB0,&__a,0,,ahk_id %__hwndE%   ; EM_GetSel=0xB0
   __a := NumGet(__a)                          ; selection start (or caret pos)
   SendMessage 0xBB,-1,,,ahk_id %__hwndE%      ; EM_LineIndex=0xBB
   __c := ErrorLevel                           ; pos1 of current line
   __code := SubStr(__hist,__c+1,__a-__c)

   __hist = `r`n%__hist%`r`n                   ; add leading and trailing newlines
   __code = `r`n%__code%                       ; for search from pos1 in line
   __match := __lastMatch < 1 ? 0 : StrLen(__hist)-__lastMatch

   StringGetPos __pos, __hist, %__code%, R, __match
   If (__pos = __c)                            ; jump over own line
      StringGetPos __pos,__hist,%__code%,R,StrLen(__hist)-__c+1

   If (__pos < 0) {                            ; no more match
      __lastMatch = 0                          ; start over even if no selection to delete
      SendMessage 0xC2,1,"",,ahk_id %__hwndE%  ; delete selection | nothing: EM_ReplaceSel=0xC2
      Return                                   ; nothing to insert
   }
   StringGetPos __match,__hist,`r`n,,__pos+1   ; next newline (always found)
   __t := SubStr(__hist,__pos+StrLen(__code)+1,__match-__pos-StrLen(__code))
   __match := __pos-1

   SendMessage 0xC2,1,&__t,,ahk_id %__hwndE%              ; EM_ReplaceSel=0xC2
   SendMessage 0xB1,__a,__a+StrLen(__t),,ahk_id %__hwndE% ; EM_SetSel=0xB1
   SetTimer SetMatch, -1                       ; set lastMatch AFTER Edit resets it
Return

SetMatch:
   __lastMatch := __match                      ; ignore last change of expr
Return


Find:                                          ; Incremental search
   GuiControlGet __find
   __lastFind = 0
NextFind:                                      ; Called at TAB
   ControlGetText __hist,,ahk_id %__hwndE%     ; current history data: `r`n newlines for insertion

   StringGetPos __lastFind, __hist, %__find%,, __lastFind+1

   If(__lastFind < 0)                          ; no more match
      SendMessage 0xB1,-1,-1,,ahk_id %__hwndE% ; EM_SetSel=0xB1
   Else
      SendMessage 0xB1,__lastFind,__lastFind+StrLen(__find),,ahk_id %__hwndE% ; EM_SetSel=0xB1
   SendMessage 0xB7,0,0,,ahk_id %__hwndE%      ; EM_ScrollCaret=0xB7
Return

PrevFind:                                      ; Called at Shif-TAB
   ControlGetText __hist,,ahk_id %__hwndE%     ; current history data: `r`n newlines for insertion

   __lastFind := __lastFind < 1 ? 0 : StrLen(__hist)-__lastFind
   StringGetPos __lastFind, __hist, %__find%, R1, __lastFind+1

   If(__lastFind < 0)                          ; no more match
      SendMessage 0xB1,-1,-1,,ahk_id %__hwndE% ; EM_SetSel=0xB1
   Else
      SendMessage 0xB1,__lastFind,__lastFind+StrLen(__find),,ahk_id %__hwndE% ; EM_SetSel=0xB1
   SendMessage 0xB7,0,0,,ahk_id %__hwndE%      ; EM_ScrollCaret=0xB7
Return

ButtonFind:                                    ; Alt-F
   GuiControlGet __show, Visible, __find
   If (__show) {                               ; hide
      GuiControl Hide, Static1
      GuiControl Hide, __find
      ControlFocus,,ahk_id %__hwndE%
      SendMessage 0xB1, __aE, __bE,,ahk_id %__hwndE% ; EM_SetSel=0xB1
      SendMessage 0xB7,0,0,,ahk_id %__hwndE%   ; EM_ScrollCaret=0xB7
   }
   Else {                                      ; show
      GuiControl Show, Static1
      GuiControl Show, __find
      SendMessage 0xB0,&__a,&__b,,ahk_id %__hwndE% ; EM_GetSel=0xB0
      __aE := NumGet(__a)                          ; selection start
      __bE := NumGet(__b)                          ; selection end: `r`n newlines assumed!
      ControlFocus,,ahk_id %__hwndF%
      Send {End}
   }
   Gui Show, AutoSize                          ; adjust GUI window
Return

ButtonSave:                                    ; Alt-S
   FileSelectFile __file,, %A_WorkingDir%\%__file%, Save the SELECTION to..., *.clc
   IfEqual ErrorLevel,0, GoTo SaveSelection
Return

ButtonLoad:                                    ; Alt-L
   FileSelectFile __file,, %A_WorkingDir%\%__file%, Load the history from..., *.hst
   IfEqual ErrorLevel,0, GoTo LoadHistory
Return

ButtonWrite:                                   ; Alt-W
   FileSelectFile __file, S, %A_WorkingDir%\%__file%, Write the history to..., *.hst
   IfEqual ErrorLevel,0, GoTo WriteHistory
Return

ButtonAppend:                                  ; Alt-E
   FileSelectFile __file,, %A_WorkingDir%\%__file%, Append the history to..., *.hst
   IfEqual ErrorLevel,0, GoTo AppendHistory
Return

ButtonHelp:                                    ; Alt-H: list of shortcuts, functions
   Gui 3:Show, x%__HelpX% y%__HelpY%, AHK Calculator HELP
   Send ^{Home}                                ; de-select any text
Return

#IfWinActive ahk_group HelpGroup               ; \/ -------------------------- \/

 Tab::GoTo NextHelp
+Tab::GoTo PrevHelp

Up::                                           ; Scroll UP
   ControlGetFocus __f, ahk_id %__HelpID%
   If (__f = "Edit2")
      SendMessage 0xB6,0,1,,ahk_id %__hwndH%   ; EM_LineScroll = 0xB6
   Else
      Send {Up}
Return

Down::                                         ; Scroll Down
   ControlGetFocus __f, ahk_id %__HelpID%
   If (__f = "Edit2")
      SendMessage 0xB6,0,-1,,ahk_id %__hwndH%  ; EM_LineScroll = 0xB6
   Else
      Send {Down}
Return

#IfWinActive                                   ; /\ -------------------------- /\

3GuiEscape:
3GuiClose:
   WinGetPos __HelpX, __HelpY,,,ahk_id %__HelpID%
   Gui 3:Hide
Return

3ButtonSearch:                                 ; Incremental HELP search
hFind:
   GuiControlGet  __t,,__HelpSearch, 3:        ; get search text
   __lastHelp = 0
NextHelp:                                      ; Called at TAB
   StringGetPos __lastHelp, __Help, %__t%,, __lastHelp+1

   If(__lastHelp < 0)                          ; no more match
      SendMessage 0xB1,-1,-1,Edit1,ahk_id %__HelpID% ; EM_SetSel=0xB1
   Else
      SendMessage 0xB1,__lastHelp,__lastHelp+StrLen(__t),Edit1,ahk_id %__HelpID% ; EM_SetSel=0xB1
   SendMessage 0xB7,0,0,Edit1,ahk_id %__HelpID% ;EM_ScrollCaret=0xB7
Return

PrevHelp:                                      ; Called at Shif-TAB
   __lastHelp := __lastHelp < 1 ? 0 : StrLen(__Help)-__lastHelp
   StringGetPos __lastHelp, __Help, %__t%, R, __lastHelp+1

   If(__lastHelp < 0)                          ; no more match
      SendMessage 0xB1,-1,-1,Edit1,ahk_id %__HelpID% ; EM_SetSel=0xB1
   Else
      SendMessage 0xB1,__lastHelp,__lastHelp+StrLen(__t),Edit1,ahk_id %__HelpID% ; EM_SetSel=0xB1
   SendMessage 0xB7,0,0,Edit1,ahk_id %__HelpID% ;EM_ScrollCaret=0xB7
Return


4GuiEscape:
4GuiClose:
   WinGetPos __ListX, __ListY,,,  ahk_id %__ListID%
   Gui 4:Destroy
Return

2GuiEscape:
   Plot()           ; clear function graphs
Return

2GuiClose:
   WinGetPos __GraphX, __GraphY,,, ahk_id %__GraphID%
   Graph()          ; destroy graph paper and drawings
Return

CleanUp:
   __file := __hst                             ; standard history file
   GoSub WriteHistory

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


__eval(y) {              ; evaluate AHK expression, format results in decimal, hex and binary
   Global _, _1,_2,_3,_4,_5,_6,_7,_8,_9, __fformat
   SetFormat Float, %__fformat%                                              ; set each time!
   Static H = 0x1234567890123456, N = 0x1234567890123456                           ; allocate
   , U = 123456789012345678901234567890123456789012345678901234567890                ; ...
   , D = 123456789012345678901234567890123456789012345678901234567890                ; memory
   y:=RegExReplace(y,"^(([^'""]*?('[^']*'|""[^""]*?""))*?[^'""]*?);;.*","$1") ;remove comment
   Loop {                                                ; `var->"var" outside quoted strings
      y:=RegExReplace(y,"^(([^``'""]*('[^']*'|""[^""]*""))*[^``'""]*)``(\w+)","$1""$4""",cnt)
      IfLess cnt,1, Break
   }
   y := eval(y)                                                               ; EVALUATE expr
   StringReplace y, y, `n, S, All                                   ; show result in one line
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
   StringReplace x, x, ``n,% chr(10),All
   StringReplace x, x, ``r,% chr(13),All
   StringReplace x, x, ``b,% chr(8), All
   StringReplace x, x, ``t,% chr(9), All
   StringReplace x, x, ``v,% chr(11),All
   StringReplace x, x, ``a,% chr(7), All
   StringReplace x, x, ``f,% chr(12),All
   RegExMatch(x,"^(([^`;'""]*('[^']*'|""[^""]*""))*[^`;'""]*)`;?(.*)",y)
   y := __eval__(y1)           ; cut at ";", no ";" in y1
   Return y4="" ? y : eval(y4) ; return last result, recurse into y4 with further ;'s
}

__eval__(x) { ; replace every [expr] with their _value, evaluate x (no ";" inside)
   Loop                                  ; find last innermost [..] not in quotes!
      If RegexMatch(x,"^(([^""']*|(""[^""]*"")|('[^']*'))+)\[(([^\['\]""]*|(""[^""]*"")|('[^']*'))*)\](.*)",y)
         x := y1 . "_" . __expr(y5) . y9 ; v = value of x; replace [x] with _v
      Else Break
   Return __expr(x)
}

Mode(d="") {  ; Set/Toggle DEG-RAD mode
   Global __fformat, __deg, __WinTitle
   If d =
      __deg := __deg = "RAD" ? "DEG" : "RAD"
   Else
      __deg := SubStr(d,1,1) = "D" ? "DEG" : "RAD"
   WinSetTitle %__WinTitle% [%__deg%] [%__fformat%]
   Return __deg
}

FFormat(f="0.16e") { ; Set floating point format
   Global __fformat, __deg, __WinTitle
   SetFormat Float, %f%
   __fformat := A_FormatFloat
   WinSetTitle %__WinTitle% [%__deg%] [%__fformat%]
   Return __fformat
}

run(__file) {  ; execute list of expressions in file (.clc default extension)
   Global
   If !FileExist(__file) {
      __file .= ".clc"                   ; try file.clc
      If !FileExist(__file)
         Return "<File not found>"       ; error
   }
   FileRead __t, %__file%                ; get the expressions
   StringReplace __t, __t, `r,,ALL
   Loop Parse, __t, `n                   ; evaluate each line
      __s := __eval(A_LoopField)
   Return __s                            ; return last result
}

b(bits) {      ; number converted from the binary "bits" string, 1st bit = SIGN
   n = 0
   Loop Parse, bits
      n += n + A_LoopField
   Return n - (SubStr(bits,1,1)<<StrLen(bits))
}
                ; Base[2,36] Convertion. NumStr signed. Result unsigned, except OutputBase 10
BC(NumStr,InputBase=8,OutputBase=10) {
  Static S = 12345678901234567890123456789012345678901234567890123456789012345
  DllCall("msvcrt\_i64toa", "Int64"
    ,DllCall("msvcrt\_strtoui64", "Str",NumStr, "Uint",0, "UInt",InputBase, "CDECL Int64")
  ,"Str",S, "UInt",OutputBase, "CDECL")
  Return S
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

Bin2Hex(addr,len) { ; Bin2Hex(&x,4)
   Static fun
   If (fun = "")
      Hex2Bin(fun,"8B4C2404578B7C241085FF7E2F568B7424108A06C0E8042C0A8AD0C0EA05"
      . "2AC2044188018A06240F2C0A8AD0C0EA052AC2410441468801414F75D75EC601005FC3")
   VarSetCapacity(hex,2*len+1)
   dllcall(&fun, "uint",&hex, "uint",addr, "uint",len, "cdecl")
   VarSetCapacity(hex,-1) ; update StrLen
   Return hex
}

msg(x,x1="",x2="",x3="",x4="",x5="",x6="",x7="",x8="",x9="") { ; MsgBox %x%`n%x1%...
   x .= "`n" . x1 . "`n" . x2 . "`n" . x3 . "`n" . x4 . "`n" . x5 . "`n" . x6 . "`n" . x7 . "`n" . x8 . "`n" . x9
   x := RegExReplace(x,"\R+$")
   MsgBox %x%
   Return x
}

time(Format="",Time="") {
   FormatTime f, %Time%, %Format%
   Return f
}

rand(min,max="") { ; random number in the range; max="": reseed
   If max =
      Random,,min  ; reseed
   Else {
      Random t, Min, Max
      Return t
   }
}

solve(__Name,__x0,__x1,__ex,__tol=63) { ; <- find x: expr(x) = 0 within tol-erance
   Local __s, __s0 ; assumed global
   %__Name% := __x0
   If (0 = (__s0:=fcmp(eval(__ex),0,__tol)))
      Return __x0
   %__Name% := __x1
   If (0 = (__s :=fcmp(eval(__ex),0,__tol)))
      Return __x1
   If (__s0 = __s)
      Return "Error: same sign at endpoints"

   Loop {
      %__Name% := (__x0 + __x1)/2
      If (fcmp(__x0,__x1,__tol) = 0 || 0 = (__s:=fcmp(eval(__ex),0,__tol)))
         Return %__Name% . ""
      If (__s0 = __s)
         __x0 := %__Name%
      Else
         __x1 := %__Name%
   }
}

/* Solve Tridiagonal linear system: a[1..n-1], d[1..n], c[1..n-1], b[1..n] --> x[1..n]
d[1]x[1] + c[1]x[2]                                                              = b[1]
a[1]x[1] + d[2]x[2] + c[2]x[3]                                                   = b[2]
           a[2]x[2] + d[3]x[3] + c[3]x[4]                                        = b[3]
                                    . . . .                                      = . . .
                                        a[n-2]x[n-2] + d[n-1]x[n-1] + c[n-1]x[n] = b[n-1]
                                                       a[n-1]x[n-1] +  d[n] x[n] = b[n]
*/
Solve3(__x,__a,__d,__c,__b) { ; solve the tridiagonal system [a,d,c]*x = b for x
   Local __j, __k, __n ; GLOBAL __bb_*, __dd_* (cannot declare local arrays)
   __n := %__b%_0
   %__x% := __x
   %__x%_0  := __n
   __dd_1 := %__d%_1
   __bb_1 := %__b%_1
   Loop % __n-1 {
      __j := A_Index, __k := __j+1
      __dd_%__k% := %__d%_%__k% - %__a%_%__j% / __dd_%__j% * %__c%_%__j%
      __bb_%__k% := %__b%_%__k% - %__a%_%__j% / __dd_%__j% * __bb_%__j%
   }

   %__x%_%__n% := __bb_%__n% / __dd_%__n%
   Loop % __n-1 {
      __k := __n-A_Index, __j := __k+1
      %__x%_%__k% := (__bb_%__k% - %__c%_%__k% * %__x%_%__j%) / __dd_%__k%
   }
   Return __x
}

UpSample(__z,__y,__p) { ; insert p points in (y[i],y[i+1]) via NATURAL CUBIC SPLINE
   Local __n, __n1, __n2, __i, __j, __k, __d, __e, __f, __s, __t, __u, __v
 ; GLOBAL __a_*, __b_*, __c_*, __d_*, __z_*
   __n := %__y%_0, __n1 := __n-1, __n2 := __n-2
   __b_0 := __n                          ; size taken from here
   __a_%__n1% := 0
   __d_1 := __d_%__n% := 1
   __c_1 := 0
   __b_1 := __b_%__n% := 0
   Loop %__n2% {                         ; setup tridiagonal matrix
      __i := A_Index+1, __j := __i+1
      __a_%A_Index% := 1
      __d_%__i% := 4
      __c_%__i% := 1
      __b_%__i% := %__y%_%__j% - 2*%__y%_%__i% + %__y%_%A_Index%
   }
   Solve3("__z","__a","__d","__c","__b") ; result in __z_*

   __d := 1 / (__p+1)
   __k := 1                              ; index of upsampled point
   Loop % __n-1 {
      %__z%_%__k% := %__y%_%A_Index%     ; copy leftmost point in current interval
      ++__k
      __i := A_Index, __j := __i+1
      __s := __z_%__j%                   ; coeffs of cubic terms
      __t := __z_%__i%
      __u := %__y%_%__j% - __z_%__j%     ; coeffs of linear terms
      __v := %__y%_%__i% - __z_%__i%
      __e := __d, __f := 1-__d           ; interpolation points in current interval
      Loop %__p% {
         %__z%_%__k% := __e*(__u+__s*__e*__e) + __f*(__v+__t*__f*__f)
         __k += 1, __e += __d, __f -= __d
      }
   }
   %__z% := __z                          ; store name
   %__z%_0 := __k                        ; length
   %__z%_%__k% := %__y%_%__n%            ; last point
   Return __z
}

fmax(__Name,__x0,__x1,__x2,__ex,__tol=63) { ; <- find x: exp(x) = max within tol-erance
   Local __y, __y0, __y1, __y2               ; assumed global
                                  ; SORT x0 <= x1 <= x2
   If (fcmp(__x0,__x1,__tol) > 0)            ; make x0 <= x1
      __y := __x0, __x0 := __x1, __x1 := __y
   If (fcmp(__x1,__x2,__tol) > 0)            ; make x1 <= x2
      __y := __x1, __x1 := __x2, __x2 := __y
   If (fcmp(__x0,__x1,__tol) > 0)            ; make x0 <= x1, sorted {x0,x1,x2}
      __y := __x0, __x0 := __x1, __x1 := __y

   Loop 3                         ; set yi
      %__Name% := __x%A_Index%, __y%A_Index% := eval(__ex)
   If (fcmp(__y0,__y1,__tol) > 0 || fcmp(__y2,__y1,__tol) > 0)
      Return "Error: middle point not max"

   Loop {
      If (fcmp(__x0,__x2,__tol) = 0)         ; endpoints are close
         Return __x1

      %__Name% := (__x0 + __x1)/2
      __y := eval(__ex)
      If (fcmp(__y,__y1,__tol) > 0) {        ; max is in left half interval ('>' keeps max at x1)
         __x2 := __x1, __y2 := __y1, __x1 := %__Name%, __y1 := __y
         Continue
      }
      __x0 := %__Name%, __y0 := __y

      %__Name% := (__x1 + __x2)/2
      __y := eval(__ex)
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

for(__Var,__i0,__i1,__d,__ex) { ; <- evaluate {expr(i0),expr(i0+d)..,expr(i1)}
   Local __y, __sd := (__d>0)-(__d<0) ; assumed global
   If (__d = 0)
      Return
   Loop {
      If (fcmp(__i0,__i1,63) = __sd)
         Return __y
      %__Var% := __i0
      __y := eval(__ex)
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
   Global
   __n := __Name                               ; Save Name to global __n

   LV_Delete()                                 ; clear old
   IfWinExist ahk_id %__ListID%
      GoSub 4GuiClose

   Gui 4:font, s%__FontSz%, %__Font%
   Gui 4:Margin, 5, 5

   Gui 4:Add, ListView, w%__listW% r20 Grid -ReadOnly gListVw, %__listHDR%
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

array(__Name,__Var,__i0,__i1,__d,__ex) { ; <- {expr(i0),expr(i0+d)..,expr(i1)}
   Local __sd := (__d>0)-(__d<0) ; assumed GLOBAL
   %__Name% := __Name            ; store name
   If ((__i0 > __i1 && __d > 0) || (__i0 < __i1 && __d < 0) || (__d = 0)) {
      %__Name%_0 = 0             ; length of array
      Return __Name
   }
   Loop {
      %__Var% := __i0
      %__Name%_%A_Index% := eval(__ex)
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

CBget(__Name) {      ; Get vector from the ClipBoard (CSV format: 1, "ab", cd)
   Local __i := 0
   Loop Parse, ClipBoard, CSV
      ++__i, %__Name%_%__i% := A_LoopField
   %__Name% := __Name                ; store Name
   %__Name%_0 := __i                 ; length
   Return __Name
}

CBput(__Name,__form="") { ; Put formatted vector to the ClipBoard [comma separated list]
   Local __CB
   Static __d := "1234567890123456789012345678901234567890"
   If (__form = "") {
      Loop % %__Name%_0
         __CB .= %__Name%_%A_Index% . ", "
      ClipBoard := SubStr(__CB,1,StrLen(__CB)-2)
   }
   Else {
      Loop % %__Name%_0 {
         DllCall("msvcrt\sprintf", "Str",__d, "Str",__form,"Double",%__Name%_%A_Index%)
         __CB .= __d
      }
      ClipBoard := __CB
   }
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

diff(__y,__x) {      ; y[i] <- x[i+1]-x[i], i=1..x[0]-1
   Local __i
   %__y% := __y                ; store name
   %__y%_0 := %__x%_0 - 1      ; length
   Loop % %__y%_0
      __i := A_Index+1, %__y%_%A_Index% :=  %__x%_%__i% - %__x%_%A_Index%
   Return __y
}

cumsum(__y,__x) {    ; y[i] <- x[i]+x[i-1]+..+x[1], i=1..x[0]
   Local __s := 0
   %__y% := __y                ; store name
   %__y%_0 := %__x%_0          ; length
   Loop % %__y%_0
      __s := %__y%_%A_Index% :=  __s + %__x%_%A_Index%
   Return __y
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

to0(x) {        ; round toward TO 0 (truncate)
   Return x < 0 ? ceil(x) : floor(x)
}

from0(x) {      ; round away FROM 0
   Return x < 0 ? floor(x) : ceil(x)
}

fcmp(x,y,tol=9) { ; floating point comparison with tolerance
   Static f
   If (f = "")
      Hex2Bin(f,"558bec83e4f883ec148b5510538b5d0c85db568b7508578b7d148974241889542410b90"
. "00000807f137c0485f6730d33c02bc68bd91b5d0c89442418837d14007f137c0485d2730d33c02bc28bf9"
. "1b7d14894424108b7424182b7424108b45188bcb1bcff7d8993bd17f187c043bc677128b4518993bca7f0"
. "a7c043bf0770433c0eb183bdf7f117c0a8b44241039442418730583c8ffeb0333c0405f5e5b8be55dc3")

   Return DllCall(&f, "double",x, "double",y, "Int",tol, "CDECL Int")
}

fnext(x,d=1) {  ; add d to LS bits of double x
   Global Dmin
   If x = 0           ; increment LS bits of 0 would give de-normalized numbers
      If d > 0
         x := Dmin, d -= 1
      Else If d < 0
         x :=-Dmin, d += 1
      Else
         Return 0.0+0 ; formatted 0

   i := DllCall("ntdll\RtlLargeIntegerAdd", "Double",x, "Int64",x<0 ? -d : d, "Int64")
   DllCall("ntdll\RtlMoveMemory", "Double*",t, "Int64*",i, "Uint",8) ; double result not in registers
   Return t
}

f2int(d) {      ; integer representation of bits of floating point (double) d
   Return DllCall("ntdll\RtlLargeIntegerAdd", "Double",d, "Int64",0, "Int64")
}

int2f(i) {      ; floating point representation (double) of bits of integer i
   DllCall("ntdll\RtlMoveMemory", "Double*",t, "Int64*",i, "Uint",8)
   Return t
}

cbrt(x) {       ; signed cubic root
   Static e = 0.333333333333333333
   Return x < 0 ? -(-x)**e : x**e
}

erf(x) {        ; Error function (symmetric)
   Return ((x>0)-(x<0))*(1 - .56418958354775628*GAMMA(0.5,x*x))
}

; Gamma functions: ~"Computation of Special Functions" Zhang and Jin, John Wiley and Sons, 1996

GAMMA(a,x=0) {  ; upper incomplete gamma: Integral(t**(a-1)*e**-t, t = x..inf)
   If (a > 171 || x < 0)
      Return 2.e308   ; overflow

   xam := x > 0 ? -x+a*ln(x) : 0
   If (xam > 700)
      Return 2.e308   ; overflow

   If (x > 1+a) {     ; no need for gamma(a)
      t0 := 0, k := 60
      Loop 60
          t0 := (k-a)/(1+k/(x+t0)), --k
      Return exp(xam) / (x+t0)
   }

   r := 1, ga := 1    ; compute ga = gamma(a) ...
   If (a = round(a))  ; if integer: factorial
      If (a > 0)
         Loop % a-1
            ga *= A_Index+1
      Else            ; negative integer
         ga := 1.7976931348623157e+308 ; Dmax
   Else {             ; not integer
      If (abs(a) > 1) {
         z := abs(a)
         m := floor(z)
         Loop %m%
             r *= (z-A_Index)
         z -= m
      }
      Else
         z := a

      gr := (((((((((((((((((((((((       0.14e-14
          *z - 0.54e-14)             *z - 0.206e-13)          *z + 0.51e-12)
          *z - 0.36968e-11)          *z + 0.77823e-11)        *z + 0.1043427e-9)
          *z - 0.11812746e-8)        *z + 0.50020075e-8)      *z + 0.6116095e-8)
          *z - 0.2056338417e-6)      *z + 0.1133027232e-5)    *z - 0.12504934821e-5)
          *z - 0.201348547807e-4)    *z + 0.1280502823882e-3) *z - 0.2152416741149e-3)
          *z - 0.11651675918591e-2)  *z + 0.7218943246663e-2) *z - 0.9621971527877e-2)
          *z - 0.421977345555443e-1) *z + 0.1665386113822915) *z - 0.420026350340952e-1)
          *z - 0.6558780715202538)   *z + 0.5772156649015329) *z + 1

      ga := 1.0/(gr*z) * r
      If (a < -1)
         ga := -3.1415926535897931/(a*ga*sin(3.1415926535897931*a))
   }

   If (x = 0)         ; complete gamma requested
      Return ga

   s := 1/a           ; here x <= 1+a
   r := s
   Loop 60 {
      r *= x/(a+A_Index)
      s += r
      If (abs(r/s) < 1.e-15)
         break
   }
   Return ga - exp(xam)*s
}

LnGamma(x) {    ; Log of gamma(x)
    If (x <= 0)
       Return  ; error
    If (x = 1 || x = 2)
       Return 0.0
    n := x <= 7 ? floor(7-x) : 0
    x0:= x+n

    x2:= 1/(x0*x0)
    g := ((((((((-1.39243221690590  *x2 + 0.1796443723688307)
       *x2 - 2.955065359477124e-02) *x2 + 6.410256410256410e-03)
       *x2 - 1.917526917526918e-03) *x2 + 8.417508417508418e-04)
       *x2 - 5.952380952380952e-04) *x2 + 7.936507936507937e-04)
       *x2 - 2.777777777777778e-03) *x2 + 8.333333333333333e-02

    g := g/x0 + (x0-0.5)*ln(x0) - x0 + 0.9189385332046727418

    Loop %n%
       g -= ln(x0-=1)

    Return g
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

rad(a) {
   Global __deg
   Return __deg = "DEG" ? a*57.295779513082323 : a
}

deg(a) {
   Global __deg
   Return __deg = "DEG" ? a*0.017453292519943295 : a
}

sin(x) {        ; sine - needs redefinition for RAD/DEG
   Return dllcall("msvcrt\sin", "Double",deg(x), "CDECL Double")
}
cos(x) {        ; cosine
   Return dllcall("msvcrt\cos", "Double",deg(x), "CDECL Double")
}
tan(x) {        ; tangent
   Return dllcall("msvcrt\tan", "Double",deg(x), "CDECL Double")
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

asin(x) {       ; inverse sine
   Return rad(dllcall("msvcrt\asin", "Double",x, "CDECL Double"))
}
acos(x) {       ; inverse cosine
   Return rad(dllcall("msvcrt\acos", "Double",x, "CDECL Double"))
}
atan(x) {       ; inverse tangent
   Return rad(dllcall("msvcrt\atan", "Double",x, "CDECL Double"))
}

acot(x) {       ; inverse cotangent
   Return atan(1/x)
}
asec(x) {       ; inverse secant
   Return acos(1/x)
}
acosec(x) {     ; inverse cosecant
   Return asin(1/x)
}
atan2(x,y) {    ; 4-quadrant atan
   Return rad(dllcall("msvcrt\atan2","Double",y, "Double",x, "CDECL Double"))
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

   __width:=width, __height:=height
   __offX:=30, __offY := __TH+5, dX:=10, dY:=2*__TH+4
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

   DllCall("msvcrt\sprintf", "Str",__Z, "Str","%.3gS%.3gS%.3gS%.3g"
      ,"double",x0,"double",x1,"double",y0,"double",y1)
   __Z := RegExReplace(__Z,"e(\+?|(\-?))0+","e$2")
   StringSplit __Z, __Z, S

   Gui 2:font, s%__FontSz%, %__Font%
   Gui 2:Add, Text, x%__offX% y%__offY% w%width% h%height% hwnd__hwndC ; the canvas, Static1
   Gui 2:Add, Text, x5 y5, %__Z4%                                      ; y1, Static2...
   Gui 2:Add, Text,% "x5 y" . __offY+height, %__Z3%
   Gui 2:Add, Text,% "x" . __offX . " y" . __offY+height+__TH, %__Z1%
   Gui 2:Add, Text,% "Right x" . __offX+width//2 . " y" . __offY+height+__TH . " w" . width//2, %__Z2%
   Gui 2:Show

   Gui 2:+LastFound
   WinGet __GraphID, ID
   Gui 2:-LastFound

   ControlGetPos __GX, __GY,,, Static1, ahk_id %__graphID% ; Canvas position used with A_GuiX/Y
   Gui 2:Show, % "x" . __GraphX . " y" . __GraphY . " w" . width+__offX+dX . "h" . height+__offY+dY, Calculator Graph
   OnMessage(0x20, "HandleMessage")     ; WM_SETCURSOR
   OnMessage(0x200,"HandleMessage")     ; WM_MOUSEMOVE
   SetTimer GraphTimer, 50

   __WindowDC := DllCall("GetDC", UInt,__hwndC) ; Device Context for the window to be drawn to
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
   DllCall("BitBlt", UInt,__WindowDC, UInt,0, UInt,0
      , UInt,width, UInt,height, UInt,__MemoryDC, UInt,0, UInt,0, UInt,0x00CC0020)
}

2GuiContextMenu:    ; mouse coordinates in axes
   If (A_GuiEvent != "RightClick")
      Return
   DllCall("msvcrt\sprintf", "Str",__Z, "Str","( %.3g, %.3g )"
      ,"double",__x0+(A_GuiX-__GX)/__xs,"double",__y1-(A_GuiY-__GY)/__ys)
   Msgbox %__Z%     ; Ctrl-C copies
Return

HandleMessage(__p_w, __p_l, __p_m, __p_hw) {
   Global
   MouseGetPos,,,,,__Ctrl          ; X,Y would be relative to active window
   If (__Ctrl = "Static1") {
      If (__hover && __p_m = 0x20) ; WM_SETCURSOR
         Return 1
      __hover = 1
      DllCall("SetCursor", "uint", __cursor)
      DllCall("msvcrt\sprintf", "Str",__Z, "Str","( %.3g, %.3g )"
      ,"double",__x0+((__p_l & 0xFFFF)-__offX)/__xs,"double",__y1-((__p_l>>16)-__offY)/__ys)
      ToolTip %__Z%
   } Else
      __hover = 0
   Return
}

GraphTimer: ; Erase tooltip outside. Other actions not needed for Vista/modern graphic cards
   Critical
   MouseGetPos __X,__Y,__WinID, __Ctrl
   If (__Xold = __X && __Yold = __Y && __GraphID = __WinID)
      Return                                    ; if nothing changed, do nothing (no flicker)
   __Xold := __X, __Yold := __Y
   If (__WinID <> __GraphID || __Ctrl <> "Static1") ; not in canvas:
      ToolTip                                       ; ..erase tooltip
   DllCall("BitBlt", UInt,__MemoryDC, UInt,0, UInt,0           ; REDRAW - for slow graphic cards
      , UInt,width, UInt,height, UInt,__PaperDC,  UInt,0, UInt,0, UInt,0x00CC0020)
   DllCall("BitBlt", UInt,__WindowDC, UInt,0, UInt,0
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

   DllCall("BitBlt", UInt,__WindowDC, UInt,0, UInt,0
      , UInt,__width, UInt,__height, UInt,__MemoryDC, UInt,0, UInt,0, UInt,0x00CC0020)
}

plot(Y="",color="",width="") {             ; plot with implicit X = 1,2,..
   Local Pen

   color := color = "" ? __GrLnColor : color
   width := width = "" ? __GrLnWidth : width

   If (Y = "") {                                ; clear graph paper
      DllCall("BitBlt", UInt,__MemoryDC, UInt,0, UInt,0
         , UInt,__width, UInt,__height, UInt,__PaperDC, UInt,0, UInt,0, UInt,0x00CC0020)
      DllCall("BitBlt", UInt,__WindowDC, UInt,0, UInt,0
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

   DllCall("BitBlt", UInt,__WindowDC, UInt,0, UInt,0
      , UInt,__width, UInt,__height, UInt,__MemoryDC, UInt,0, UInt,0, UInt,0x00CC0020)
}

;------------------------------------------------------------------------------------
; Lexikos' lowlevel functions 1.0 (http://www.autohotkey.com/forum/viewtopic.php?t=26300)
;------------------------------------------------------------------------------------

__init() {
    static initd
    if initd
        return
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
            {
                pFunc := pFirstFunc
                Loop {
                    if !(pFunc := NumGet(pFunc+44)) ; pFunc->mNextFunc
                        break
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
        pFunc:=__getFuncUDF("__expr_sub"), pThisFunc:=__getFuncUDF(A_ThisFunc), __init()

    nInst := NumGet(pThisFunc+40)
    VarSetCapacity(Line%nInst%,44,0), __static(Line%nInst%), pLine:=&Line%nInst%

    if ! __ParseExpressionArg(expr, pArg:=&Line%nInst%+32, pScopeFunc)
        return

    NumPut(pArg,NumPut(1,NumPut(102,pLine+0,0,"char"),0,"char"),2)
    , NumPut(pLine,NumPut(pLine,pLine+16))
    , NumPut(pLine,pFunc+4)
    , ret := __expr_sub()
    , NumPut(0,pLine+1,0,"char")
    , DllCall("GlobalFree","uint",NumGet(pArg+4)) ; text
    , DllCall("GlobalFree","uint",NumGet(pArg+8)) ; deref
    return ret
}

__expr_sub() {
    global
}

__ParseExpressionArg(expr, pArg, pScopeFunc=0) {
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
        if ! pos:=RegExMatch(expr, """.*?""|[\w#@$?\[\]\.%\x80-\xFF]+", word, pos)
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
            in_quote := false
            Loop {
                if (c:=SubStr(expr,++i,1))=""
                    break
                if (param_count=0 && !(c=" "||c="`t"||c=")"))
                    param_count = 1
                if c = "
                    in_quote := !in_quote
                if in_quote
                    continue
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

    pText := DllCall("GlobalAlloc","uint",0,"uint",StrLen(expr)+1)
    DllCall("lstrcpy","uint",pText,"str",expr)
    pDerefs := DllCall("GlobalAlloc", "uint", 0x40, "uint", (num_derefs+1)*12)
    NumPut(pDerefs, NumPut(pText, NumPut(StrLen(expr), NumPut(1, NumPut(0, pArg+0,0,"char"), 0,"char"), 0,"short")))
    Loop, %num_derefs% {
        pDeref := pDerefs + (A_Index-1)*12
        DllCall("RtlMoveMemory","uint",pDeref,"uint",&deref%A_Index%,"uint",12)
        NumPut(pText + NumGet(pDeref+0), pDeref+0) ; deref.marker += base_address_of_text
    }
    return pArg, ErrorLevel=0

    __MakeExpressionArg_AddDeref:
        num_derefs += 1
        VarSetCapacity(deref%num_derefs%,12)
        NumPut(word_len,NumPut(param_count,NumPut(is_func,NumPut(var_or_func,NumPut(marker,deref%num_derefs%)),0,"char"),0,"char"),0,"short")
    return
}

__lineAlloc() {
    return __LinePool()
}

__lineFree(pline) {
    __LinePool(pline)
}

__linePool(pline=0) {
    static pool
    if pline
        DllCall("RtlZeroMemory","uint",pline,"uint",32), pool .= pline . ","
    else if i:=InStr(pool,",")
        return pline:=SubStr(pool,1,i-1), pool:=SubStr(pool,i+1)
    else
    {
        pline := DllCall("GlobalAlloc","uint",0x40,"uint",32*32)
        pool =
        Loop, 31    ; exclude the first Line.
            pool .= pline+A_Index*32 . ","
        return pline
    }
}
