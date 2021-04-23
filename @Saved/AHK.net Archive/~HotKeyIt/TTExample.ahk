#NoEnv                         
#Persistent                                                 
#SingleInstance force                                       
SendMode Input                                             
SetWorkingDir %A_ScriptDir%                                 
;Menu Tray, icon, rox.ico                                   

Gui +LastFound +AlwaysOntop   +ToolWindow +E0x08000000     
BackgroundColor = 990044                                   
Gui, Color, %BackgroundColor%                             

Gui, Margin, 0, 0                                           

Gui, Font, gold s8 bold                                     
               
;-----------------------Bar nr 1  ------------------------------------------------

ToolTip:=TT("AlwaysTip")
Gui, Add, button, x00 y0 w80 h40 gcl1,     attack
ToolTip.Add("Button1","Attack")
Gui, Add, button, x00 y45 w80 h40 gcl2,    pickup
ToolTip.Add("Button2","Pickup")
Gui,Show
Return
GuiClose:
ExitApp



cl1:
cl2:
Return







;: Title: sizeof function by HotKeyIt
;

; Function: sizeof
; Description:
;      sizeof() is based on AHK_L Objects and supports both, ANSI and UNICODE version, so to use it you will require <a href=http://www.autohotkey.com/forum/viewtopic.php?t=43049>Lexikos AutoHotkey_L.exe</a> or other versions based on it that supports objects.<br><br>nsizeof is used to calculate the size of structures or data types. <br>Visit <a href=http://www.autohotkey.com/forum/viewtopic.php?t=43049>sizeof at AutoHotkey</a> forum, any feedback is welcome.
; Syntax: size:= sizeof(Structure_Definition or Structure_Object)
; Parameters:
;	   Field types - All AutoHotkey and Windows Data Types are supported<br>AutoHotkey Data Types<br> Int, Uint, Int64, UInt64, Char, UChar, Short, UShort, Fload and Double.<br>Windows Data Types<br> - note, TCHAR UCHAR and CHAR return actual character rather than the value, use Asc() function to find out the value/code<br>Windows Data types: Asc(char)<br>ATOM,BOOL,BOOLEAN,BYTE,CHAR,COLORREF,DWORD,DWORDLONG,DWORD_PTR,<br>DWORD32,DWORD64,FLOAT,HACCEL,HALF_PTR,HANDLE,HBITMAP,HBRUSH,HCOLORSPACE,HCONV,HCONVLIST,HCURSOR,HDC,<br>HDDEDATA,HDESK,HDROP,HDWP,HENHMETAFILE,HFILE,HFONT,HGDIOBJ,HGLOBAL,HHOOK,HICON,HINSTANCE,HKEY,HKL,<br>HLOCAL,HMENU,HMETAFILE,HMODULE,HMONITOR,HPALETTE,HPEN,HRESULT,HRGN,HRSRC,HSZ,HWINSTA,HWND,INT,<br>INT_PTR,INT32,INT64,LANGID,LCID,LCTYPE,LGRPID,LONG,LONGLONG,LONG_PTR,LONG32,LONG64,LPARAM,LPBOOL,<br>LPBYTE,LPCOLORREF,LPCSTR,LPCTSTR,LPCVOID,LPCWSTR,LPDWORD,LPHANDLE,LPINT,LPLONG,LPSTR,LPTSTR,LPVOID,<br>LPWORD,LPWSTR,LRESULT,PBOOL,PBOOLEAN,PBYTE,PCHAR,PCSTR,PCTSTR,PCWSTR,PDWORD,PDWORDLONG,PDWORD_PTR,<br>PDWORD32,PDWORD64,PFLOAT,PHALF_PTR,PHANDLE,PHKEY,PINT,PINT_PTR,PINT32,PINT64,PLCID,PLONG,PLONGLONG,<br>PLONG_PTR,PLONG32,PLONG64,POINTER_32,POINTER_64,POINTER_SIGNED,POINTER_UNSIGNED,PSHORT,PSIZE_T,<br>PSSIZE_T,PSTR,PTBYTE,PTCHAR,PTSTR,PUCHAR,PUHALF_PTR,PUINT,PUINT_PTR,PUINT32,PUINT64,PULONG,PULONGLONG,<br>PULONG_PTR,PULONG32,PULONG64,PUSHORT,PVOID,PWCHAR,PWORD,PWSTR,SC_HANDLE,SC_LOCK,SERVICE_STATUS_HANDLE,<br>SHORT,SIZE_T,SSIZE_T,TBYTE,TCHAR,UCHAR,UHALF_PTR,UINT,UINT_PTR,UINT32,UINT64,ULONG,ULONGLONG,<br>ULONG_PTR,ULONG32,ULONG64,USHORT,USN,WCHAR,WORD,WPARAM
;	   <b>Parameters</b> - <b>Description</b>
;	   size - The size of structure or data type
;	   Structure_Definition - C/C++ syntax or usual definition (must not be multiline) e.g. "Int x,Int y", C/C++ definitions must be multiline.
; Return Value:
;     sizeof returns size of structures or data types
; Remarks:
;		None.
; Related:
; Example:
;		file:

sizeof(_TYPE_){
  ;Windows and AHK Data Types, used to find out the corresponding size
  static _types__:="
  (LTrim Join
    ,ATOM:2,LANGID:2,WCHAR:2,WORD:4,PTR:" A_PtrSize ",UPTR:" A_PtrSize ",SHORT:2,USHORT:2,INT:4,UINT:4,INT64:8,UINT64:8,DOUBLE:8,FLOAT:4,CHAR:1,UCHAR:1,__int64:8
    ,TBYTE:" (A_IsUnicode?2:1) ",TCHAR:" (A_IsUnicode?2:1) ",HALF_PTR:" (A_PtrSize=8?4:2) ",UHALF_PTR:" (A_PtrSize=8?4:2) ",INT32:4,LONG:4,LONG32:4,LONGLONG:8
    ,LONG64:8,USN:8,HFILE:" A_PtrSize ",HRESULT:" A_PtrSize ",INT_PTR:" A_PtrSize ",LONG_PTR:" A_PtrSize ",POINTER_64:" A_PtrSize ",POINTER_SIGNED:" A_PtrSize "
    ,BOOL:4,SSIZE_T:" A_PtrSize ",WPARAM:" A_PtrSize ",BOOLEAN:1,BYTE:1,COLORREF:4,DWORD:4,DWORD32:4,LCID:4,LCTYPE:4,LGRPID:4,LRESULT:4,PBOOL:" A_PtrSize "
    ,PBOOLEAN:" A_PtrSize ",PBYTE:" A_PtrSize ",PCHAR:" A_PtrSize ",PCSTR:" A_PtrSize ",PCTSTR:" A_PtrSize ",PCWSTR:" A_PtrSize ",PDWORD:" A_PtrSize "
    ,PDWORDLONG:" A_PtrSize ",PDWORD_PTR:" A_PtrSize ",PDWORD32:" A_PtrSize ",PDWORD64:" A_PtrSize ",PFLOAT:" A_PtrSize ",PHALF_PTR:" A_PtrSize "
    ,UINT32:4,ULONG:4,ULONG32:4,DWORDLONG:8,DWORD64:8,ULONGLONG:8,ULONG64:8,DWORD_PTR:" A_PtrSize ",HACCEL:" A_PtrSize ",HANDLE:" A_PtrSize "
     ,HBITMAP:" A_PtrSize ",HBRUSH:" A_PtrSize ",HCOLORSPACE:" A_PtrSize ",HCONV:" A_PtrSize ",HCONVLIST:" A_PtrSize ",HCURSOR:" A_PtrSize ",HDC:" A_PtrSize "
     ,HDDEDATA:" A_PtrSize ",HDESK:" A_PtrSize ",HDROP:" A_PtrSize ",HDWP:" A_PtrSize ",HENHMETAFILE:" A_PtrSize ",HFONT:" A_PtrSize "
   )"
  static _types_:=_types__ "
  (LTrim Join
     ,HGDIOBJ:" A_PtrSize ",HGLOBAL:" A_PtrSize ",HHOOK:" A_PtrSize ",HICON:" A_PtrSize ",HINSTANCE:" A_PtrSize ",HKEY:" A_PtrSize ",HKL:" A_PtrSize "
     ,HLOCAL:" A_PtrSize ",HMENU:" A_PtrSize ",HMETAFILE:" A_PtrSize ",HMODULE:" A_PtrSize ",HMONITOR:" A_PtrSize ",HPALETTE:" A_PtrSize ",HPEN:" A_PtrSize "
     ,HRGN:" A_PtrSize ",HRSRC:" A_PtrSize ",HSZ:" A_PtrSize ",HWINSTA:" A_PtrSize ",HWND:" A_PtrSize ",LPARAM:" A_PtrSize ",LPBOOL:" A_PtrSize ",LPBYTE:" A_PtrSize "
     ,LPCOLORREF:" A_PtrSize ",LPCSTR:" A_PtrSize ",LPCTSTR:" A_PtrSize ",LPCVOID:" A_PtrSize ",LPCWSTR:" A_PtrSize ",LPDWORD:" A_PtrSize ",LPHANDLE:" A_PtrSize "
     ,LPINT:" A_PtrSize ",LPLONG:" A_PtrSize ",LPSTR:" A_PtrSize ",LPTSTR:" A_PtrSize ",LPVOID:" A_PtrSize ",LPWORD:" A_PtrSize ",LPWSTR:" A_PtrSize "
     ,PHANDLE:" A_PtrSize ",PHKEY:" A_PtrSize ",PINT:" A_PtrSize ",PINT_PTR:" A_PtrSize ",PINT32:" A_PtrSize ",PINT64:" A_PtrSize ",PLCID:" A_PtrSize "
     ,PLONG:" A_PtrSize ",PLONGLONG:" A_PtrSize ",PLONG_PTR:" A_PtrSize ",PLONG32:" A_PtrSize ",PLONG64:" A_PtrSize ",POINTER_32:" A_PtrSize "
     ,POINTER_UNSIGNED:" A_PtrSize ",PSHORT:" A_PtrSize ",PSIZE_T:" A_PtrSize ",PSSIZE_T:" A_PtrSize ",PSTR:" A_PtrSize ",PTBYTE:" A_PtrSize "
     ,PTCHAR:" A_PtrSize ",PTSTR:" A_PtrSize ",PUCHAR:" A_PtrSize ",PUHALF_PTR:" A_PtrSize ",PUINT:" A_PtrSize ",PUINT_PTR:" A_PtrSize "
     ,PUINT32:" A_PtrSize ",PUINT64:" A_PtrSize ",PULONG:" A_PtrSize ",PULONGLONG:" A_PtrSize ",PULONG_PTR:" A_PtrSize ",PULONG32:" A_PtrSize "
     ,PULONG64:" A_PtrSize ",PUSHORT:" A_PtrSize ",PVOID:" A_PtrSize ",PWCHAR:" A_PtrSize ",PWORD:" A_PtrSize ",PWSTR:" A_PtrSize ",SC_HANDLE:" A_PtrSize "
     ,SC_LOCK:" A_PtrSize ",SERVICE_STATUS_HANDLE:" A_PtrSize ",SIZE_T:" A_PtrSize ",UINT_PTR:" A_PtrSize ",ULONG_PTR:" A_PtrSize ",VOID:" A_PtrSize "
     )"
  
  _offset_:=0           ; Init size/offset to 0
  
  If IsObject(_TYPE_){    ; If structure object - check for offset in structure and return pointer + last offset + its data size
    for _union_,_struct_ in _TYPE_
    {
      If (InStr(_union_,"`b")=1){
        If (_offset_<_total_union_size_:=_struct_ + (_TYPE_["`r" SubStr(_union_,2)]?A_PtrSize:sizeof(_TYPE_["`t" SubStr(_union_,2)])) )
          _offset_:=_total_union_size_
      } else if (IsObject(_struct_) && (_offset_<_total_union_size_:=sizeof(_struct_) )){
        _offset_:=_offset_+_total_union_size_
      }
    }
    If _TYPE_.HasKey("`t") ; type only, structure has no members and its a pointer
        _offset_:=_TYPE_["`r"]?A_PtrSize:sizeof(_TYPE_["`t"])
    Return _offset_  ;(_TYPE_["`t"]?4:0) ; if offset 0 and memory set,must be a pointer
  }
  
  If (RegExMatch(_TYPE_,"^[\w\d]+$") && !this.base.HasKey(_TYPE_)) ; structures name was supplied, resolve to global var and run again
      If InStr(_types_,"," _TYPE_ ":")
        Return SubStr(_types_,InStr(_types_,"," _TYPE_ ":") + 2 + StrLen(_TYPE_),1)
      else Return sizeof(%_TYPE_%)
      
  If InStr(_TYPE_,"`n") {   ; C/C++ style definition, convert
    _offset_:=""            ; This will hold new structure
    _struct_:=[]            ; This will keep track if union is structure
    _union_:=0              ; This will keep track of union depth
    Loop,Parse,_TYPE_,`n,`r`t%A_Space%%A_Tab%
    {
      _LF_:=""
      Loop,parse,A_LoopField,`,`;,`t%A_Space%%A_Tab%
      {
        If RegExMatch(A_LoopField,"^\s*//") ;break on comments and continue main loop
            break
        If (A_LoopField){
            If (!_LF_ && _ArrType_:=RegExMatch(A_LoopField,"\w\s+\w"))
              _LF_:=RegExReplace(A_LoopField,"\w\K\s+.*$")
            If Instr(A_LoopField,"{"){
              _union_++,_struct_.Insert(_union_,RegExMatch(A_LoopField,"i)^\s*struct\s*\{"))
            } else If InStr(A_LoopField,"}")
              _offset_.="}"
            else {
              If _union_
                  Loop % _union_
                    _ArrName_.=(_struct_[A_Index]?"struct":"") "{"
              _offset_.=(_offset_ ? "," : "") _ArrName_ ((_ArrType_ && A_Index!=1)?(_LF_ " "):"") RegExReplace(A_LoopField,"\s+"," ")
              _ArrName_:="",_union_:=0
            }
        }
      }
    }
    _TYPE_:=_offset_
    _offset_:=0           ; Init size/offset to 0
  }
  
  ; Following keep track of union size/offset
  _union_:=[]               ; keep track of union level, required to reset offset after union is parsed
  _struct_:=[]              ; for each union level keep track if it is a structure (because here offset needs to increase
  _union_size_:=[]        ; keep track of highest member within the union or structure, used to calculate new offset after union
  _total_union_size_:=0   ; used in combination with above, each loop the total offset is updated if current data size is higher
  
  ; Parse given structure definition and calculate size
  ; Structures will be resolved by recrusive calls (a structure must be global)
  Loop,Parse,_TYPE_,`,`;,%A_Space%%A_Tab%`n`r
  {
    _LF_ := A_LoopField
    ; Check for STARTING union and set union helpers
    While (RegExMatch(_LF_,"i)(struct|union)?\s*\{\K"))
        _union_.Insert(_offset_)
        ,_union_size_.Insert(0)
        ,_struct_.Insert(RegExMatch(_LF_,"i)struct\s*\{")?1:0)
        ,_LF_:=SubStr(_LF_,RegExMatch(_LF_,"i)(struct|union)?\s*\{\K"))
      
    _LF_BKP_:=_LF_ ;to check for ending brackets = union,struct
    StringReplace,_LF_,_LF_,},,A
    
    
    If InStr(_LF_,"*") ; It's a pointer, size will be always A_PtrSize
      _offset_ += A_PtrSize
    else {
      ; Split array type and optionally the size of array, e.g. "TCHAR chr[5]"
      RegExMatch(_LF_,"^\s*(?<ArrType_>\w+)?\s*(?<ArrName_>\w+)?\s*\[?(?<ArrSize_>\d+)?\]?\s*$",_)
      If (!_ArrName_ && !_ArrSize_ && !InStr( _types_  ,"," _ArrType_ ":"))
        _ArrName_:=_ArrType_,_ArrType_:="UInt"

      If (_idx_:=InStr( _types_  ,"," _ArrType_ ":")){ ; AHK or Windows data type
        ; find out the size in _types_ and add to total size
        _offset_ += SubStr( _types_  , _idx_+StrLen(_ArrType_)+2 , 1 ) * (_ArrSize_?_ArrSize_:1)
      } else ; resolve structure
        _offset_ += sizeof(%_ArrType_%) * (_ArrSize_?_ArrSize_:1) ; %Array1% will resolve to global variable
    }
    If _union_.MaxIndex()
          _union_size_[_union_.MaxIndex()]:=(_offset_ - _union_[_union_.MaxIndex()]>_union_size_[_union_.MaxIndex()])
                                            ?(_offset_ - _union_[_union_.MaxIndex()]):_union_size_[_union_.MaxIndex()]
    If (_union_.MaxIndex() && !_struct_[_struct_.MaxIndex()])
      _offset_:=_union_[_union_.MaxIndex()]
      
    ; Check for ENDING union and reset offset and union helpers
    While (SubStr(_LF_BKP_,0)="}"){
      If !_union_.MaxIndex(){
        MsgBox Incorrect structure, missing opening braket {`nProgram will exit now `n%_TYPE_%
        ExitApp
      }
      ; Increase total size of union/structure if necessary
      _total_union_size_ := _union_size_[_union_.MaxIndex()]>_total_union_size_?_union_size_[_union_.MaxIndex()]:_total_union_size_
      ,_union_.Remove() ; remove latest items
      ,_struct_.Remove()
      ,_union_size_.Remove()
      ,_LF_BKP_:=SubStr(_LF_BKP_,1,StrLen(_LF_BKP_)-1)
      If !_union_.MaxIndex(){ ; leaving top union, add offset
        _offset_+=_total_union_size_
        _total_union_size_:=0
      } else _offset_:=_union_[_union_.MaxIndex()] ; reset offset because we left a union or structure
    }
  }
  Return _offset_
}

;: Title: Class _Struct + sizeof() by HotKeyIt
;

; Function: _Struct
; Description:
;      _Struct is based on AHK_L Objects and supports both, ANSI and UNICODE version, so to use it you will require <a href=http://www.autohotkey.com/forum/viewtopic.php?t=43049>Lexikos AutoHotkey_L.exe</a> or other versions based on it that supports objects.<br><br>new _Struct is used to create new structure. You can create predefined structures that are saved as global variables or pass you own structure definition.<br>_Struct supportes structure in structure as well as Arrays of structures and Vectors.<br>Visit <a href=http://www.autohotkey.com/forum/viewtopic.php?t=43049>_Struct at AutoHotkey</a> forum, any feedback is welcome.
; Syntax: MyStruct:= new _Struct(Structure_Definition,Address,initialization)
; Parameters:
;	   General Design - Class _Struct will create Object(s) that will manage fields of structure(s), for example RC := new _Struct("RECT") creates a RECT structure with fields left,top,right,bottom. To pass structure its pointer to a function or DllCall or SendMessage you will need to use RC[""] or RC[].<br><br>To access fields you can use usual Object syntax: RC.left, RC.right ...<br>To set a field of the structure use RC.top := 100.
;	   Field types - All AutoHotkey and Windows Data Types are supported<br>AutoHotkey Data Types<br> Int, Uint, Int64, UInt64, Char, UChar, Short, UShort, Fload and Double.<br>Windows Data Types<br> - note, TCHAR UCHAR and CHAR return actual character rather than the value, use Asc() function to find out the value/code<br>Windows Data types: Asc(char)<br>ATOM,BOOL,BOOLEAN,BYTE,CHAR,COLORREF,DWORD,DWORDLONG,DWORD_PTR,<br>DWORD32,DWORD64,FLOAT,HACCEL,HALF_PTR,HANDLE,HBITMAP,HBRUSH,HCOLORSPACE,HCONV,HCONVLIST,HCURSOR,HDC,<br>HDDEDATA,HDESK,HDROP,HDWP,HENHMETAFILE,HFILE,HFONT,HGDIOBJ,HGLOBAL,HHOOK,HICON,HINSTANCE,HKEY,HKL,<br>HLOCAL,HMENU,HMETAFILE,HMODULE,HMONITOR,HPALETTE,HPEN,HRESULT,HRGN,HRSRC,HSZ,HWINSTA,HWND,INT,<br>INT_PTR,INT32,INT64,LANGID,LCID,LCTYPE,LGRPID,LONG,LONGLONG,LONG_PTR,LONG32,LONG64,LPARAM,LPBOOL,<br>LPBYTE,LPCOLORREF,LPCSTR,LPCTSTR,LPCVOID,LPCWSTR,LPDWORD,LPHANDLE,LPINT,LPLONG,LPSTR,LPTSTR,LPVOID,<br>LPWORD,LPWSTR,LRESULT,PBOOL,PBOOLEAN,PBYTE,PCHAR,PCSTR,PCTSTR,PCWSTR,PDWORD,PDWORDLONG,PDWORD_PTR,<br>PDWORD32,PDWORD64,PFLOAT,PHALF_PTR,PHANDLE,PHKEY,PINT,PINT_PTR,PINT32,PINT64,PLCID,PLONG,PLONGLONG,<br>PLONG_PTR,PLONG32,PLONG64,POINTER_32,POINTER_64,POINTER_SIGNED,POINTER_UNSIGNED,PSHORT,PSIZE_T,<br>PSSIZE_T,PSTR,PTBYTE,PTCHAR,PTSTR,PUCHAR,PUHALF_PTR,PUINT,PUINT_PTR,PUINT32,PUINT64,PULONG,PULONGLONG,<br>PULONG_PTR,PULONG32,PULONG64,PUSHORT,PVOID,PWCHAR,PWORD,PWSTR,SC_HANDLE,SC_LOCK,SERVICE_STATUS_HANDLE,<br>SHORT,SIZE_T,SSIZE_T,TBYTE,TCHAR,UCHAR,UHALF_PTR,UINT,UINT_PTR,UINT32,UINT64,ULONG,ULONGLONG,<br>ULONG_PTR,ULONG32,ULONG64,USHORT,USN,WCHAR,WORD,WPARAM
;	   <b>Structure Definition</b> - <b>Description</b>
;	   User defined - To create a user defined structure you will need to pass a string of predefined types and field names.<br>Default type is UInt, so for example for a RECT structure type can be omited: <b>"left,top,right,left"</b>, which is the same as <b>"Uint left,Uint top,Uint right,Uint bottom"</b><br><br>You can also use structures very similar to C#/C++ syntax, see example.
;	   Global - Global variables can be used to save structures, easily pass name of that variable as first parameter, e.g. new _Struct("MyStruct") where MyStruct must be a global variable with structure definition. Also new _Struct(MyStruct) can be used if variable is accessible.
;	   Array - To create an array of structures include a digit in the end of your string enclosed in squared brackets.<br>For example "RECT[2]" would create an array of 2 structures.<br>This feature can also be used for user defined arrays, for example "Int age,TCHAR name[10]".
;	   Union - Using {} you can create union, for example: <br>AHKVar:="{Int64 ContentsInt64,Double ContentsDouble,object},...
;	   Struct - Using struct{} you can create structures in union.
;	   Pointer - To create a pointer you can use *, for example: CHR:="char *str" will hold a pointer to a character. Same way you can have a structure in structure so you can call for example Label.NextLabel.NextLabel.JumpToLine
;	   <b>Parameters</b> - <b>Description</b>
;	   MyStruct - This will become a class object representing the strucuture
;	   Structure_Definition - C/C++ syntax or usual definition (must not be multiline) e.g. "Int x,Int y", C/C++ definitions must be multiline.
;	   pointer - Pass a pointer as second parameter to occupy existing strucure.
;	   Initialization - Pass an object to initialize structure, e.g. {left:100,top:20}. If pointer is not used initialization can be specified in second parameter.
; Return Value:
;     Return value is a class object representing your structure
; Remarks:
;		<b>NOTE!!! accessing a field that does not exist will crash your application, these errors are not catched for performance reasons.</b>
; Related:
; Example:
;		file:Struct_Example.ahk
;
Class _Struct {
	; Data Sizes
  static PTR:=A_PtrSize,UPTR:=A_PtrSize,SHORT:=2,USHORT:=2,INT:=4,UINT:=4,__int64:=8,INT64:=8,UINT64:=8,DOUBLE:=8,FLOAT:=4,CHAR:=1,UCHAR:=1,VOID:=A_PtrSize
    ,TBYTE:=A_IsUnicode?2:1,TCHAR:=A_IsUnicode?2:1,HALF_PTR:=A_PtrSize=8?4:2,UHALF_PTR:=A_PtrSize=8?4:2,INT32:=4,LONG:=4,LONG32:=4,LONGLONG:=8
    ,LONG64:=8,USN:=8,HFILE:=A_PtrSize,HRESULT:=A_PtrSize,INT_PTR:=A_PtrSize,LONG_PTR:=A_PtrSize,POINTER_64:=A_PtrSize,POINTER_SIGNED:=A_PtrSize
    ,BOOL:=4,SSIZE_T:=A_PtrSize,WPARAM:=A_PtrSize,BOOLEAN:=1,BYTE:=1,COLORREF:=4,DWORD:=4,DWORD32:=4,LCID:=4,LCTYPE:=4,LGRPID:=4,LRESULT:=4,PBOOL:=4
    ,PBOOLEAN:=A_PtrSize,PBYTE:=A_PtrSize,PCHAR:=A_PtrSize,PCSTR:=A_PtrSize,PCTSTR:=A_PtrSize,PCWSTR:=A_PtrSize,PDWORD:=A_PtrSize,PDWORDLONG:=A_PtrSize
    ,PDWORD_PTR:=A_PtrSize,PDWORD32:=A_PtrSize,PDWORD64:=A_PtrSize,PFLOAT:=A_PtrSize,PHALF_PTR:=A_PtrSize
    ,UINT32:=4,ULONG:=4,ULONG32:=4,DWORDLONG:=8,DWORD64:=8,ULONGLONG:=8,ULONG64:=8,DWORD_PTR:=A_PtrSize,HACCEL:=A_PtrSize,HANDLE:=A_PtrSize
    ,HBITMAP:=A_PtrSize,HBRUSH:=A_PtrSize,HCOLORSPACE:=A_PtrSize,HCONV:=A_PtrSize,HCONVLIST:=A_PtrSize,HCURSOR:=A_PtrSize,HDC:=A_PtrSize
    ,HDDEDATA:=A_PtrSize,HDESK:=A_PtrSize,HDROP:=A_PtrSize,HDWP:=A_PtrSize,HENHMETAFILE:=A_PtrSize,HFONT:=A_PtrSize
  static HGDIOBJ:=A_PtrSize,HGLOBAL:=A_PtrSize,HHOOK:=A_PtrSize,HICON:=A_PtrSize,HINSTANCE:=A_PtrSize,HKEY:=A_PtrSize,HKL:=A_PtrSize
    ,HLOCAL:=A_PtrSize,HMENU:=A_PtrSize,HMETAFILE:=A_PtrSize,HMODULE:=A_PtrSize,HMONITOR:=A_PtrSize,HPALETTE:=A_PtrSize,HPEN:=A_PtrSize
    ,HRGN:=A_PtrSize,HRSRC:=A_PtrSize,HSZ:=A_PtrSize,HWINSTA:=A_PtrSize,HWND:=A_PtrSize,LPARAM:=A_PtrSize,LPBOOL:=A_PtrSize,LPBYTE:=A_PtrSize
    ,LPCOLORREF:=A_PtrSize,LPCSTR:=A_PtrSize,LPCTSTR:=A_PtrSize,LPCVOID:=A_PtrSize,LPCWSTR:=A_PtrSize,LPDWORD:=A_PtrSize,LPHANDLE:=A_PtrSize
    ,LPINT:=A_PtrSize,LPLONG:=A_PtrSize,LPSTR:=A_PtrSize,LPTSTR:=A_PtrSize,LPVOID:=A_PtrSize,LPWORD:=A_PtrSize,LPWSTR:=A_PtrSize,PHANDLE:=A_PtrSize
    ,PHKEY:=A_PtrSize,PINT:=A_PtrSize,PINT_PTR:=A_PtrSize,PINT32:=A_PtrSize,PINT64:=A_PtrSize,PLCID:=A_PtrSize,PLONG:=A_PtrSize,PLONGLONG:=A_PtrSize
    ,PLONG_PTR:=A_PtrSize,PLONG32:=A_PtrSize,PLONG64:=A_PtrSize,POINTER_32:=A_PtrSize,POINTER_UNSIGNED:=A_PtrSize,PSHORT:=A_PtrSize,PSIZE_T:=A_PtrSize
    ,PSSIZE_T:=A_PtrSize,PSTR:=A_PtrSize,PTBYTE:=A_PtrSize,PTCHAR:=A_PtrSize,PTSTR:=A_PtrSize,PUCHAR:=A_PtrSize,PUHALF_PTR:=A_PtrSize,PUINT:=A_PtrSize
    ,PUINT_PTR:=A_PtrSize,PUINT32:=A_PtrSize,PUINT64:=A_PtrSize,PULONG:=A_PtrSize,PULONGLONG:=A_PtrSize,PULONG_PTR:=A_PtrSize,PULONG32:=A_PtrSize
    ,PULONG64:=A_PtrSize,PUSHORT:=A_PtrSize,PVOID:=A_PtrSize,PWCHAR:=A_PtrSize,PWORD:=A_PtrSize,PWSTR:=A_PtrSize,SC_HANDLE:=A_PtrSize
    ,SC_LOCK:=A_PtrSize,SERVICE_STATUS_HANDLE:=A_PtrSize,SIZE_T:=A_PtrSize,UINT_PTR:=A_PtrSize,ULONG_PTR:=A_PtrSize,ATOM:=2,LANGID:=2,WCHAR:=2,WORD:=4
	; Data Types
  static _VOID:="PTR",_TBYTE:=A_IsUnicode?"USHORT":"UCHAR",_TCHAR:=A_IsUnicode?"USHORT":"UCHAR",_HALF_PTR:=A_PtrSize=8?"INT":"SHORT"
    ,_UHALF_PTR:=A_PtrSize=8?"UINT":"USHORT",_BOOL:="Int",_INT32:="Int",_LONG:="Int",_LONG32:="Int",_LONGLONG:="Int64",_LONG64:="Int64"
    ,_USN:="Int64",_HFILE:="PTR",_HRESULT:="PTR",_INT_PTR:="PTR",_LONG_PTR:="PTR",_POINTER_64:="PTR",_POINTER_SIGNED:="PTR",_SSIZE_T:="PTR"
    ,_WPARAM:="PTR",_BOOLEAN:="UCHAR",_BYTE:="UCHAR",_COLORREF:="UInt",_DWORD:="UInt",_DWORD32:="UInt",_LCID:="UInt",_LCTYPE:="UInt"
    ,_LGRPID:="UInt",_LRESULT:="UInt",_PBOOL:="UPTR",_PBOOLEAN:="UPTR",_PBYTE:="UPTR",_PCHAR:="UPTR",_PCSTR:="UPTR",_PCTSTR:="UPTR"
    ,_PCWSTR:="UPTR",_PDWORD:="UPTR",_PDWORDLONG:="UPTR",_PDWORD_PTR:="UPTR",_PDWORD32:="UPTR",_PDWORD64:="UPTR",_PFLOAT:="UPTR",___int64:="Int64"
    ,_PHALF_PTR:="UPTR",_UINT32:="UInt",_ULONG:="UInt",_ULONG32:="UInt",_DWORDLONG:="UInt64",_DWORD64:="UInt64",_ULONGLONG:="UInt64"
    ,_ULONG64:="UInt64",_DWORD_PTR:="UPTR",_HACCEL:="UPTR",_HANDLE:="UPTR",_HBITMAP:="UPTR",_HBRUSH:="UPTR",_HCOLORSPACE:="UPTR"
    ,_HCONV:="UPTR",_HCONVLIST:="UPTR",_HCURSOR:="UPTR",_HDC:="UPTR",_HDDEDATA:="UPTR",_HDESK:="UPTR",_HDROP:="UPTR",_HDWP:="UPTR"
  static _HENHMETAFILE:="UPTR",_HFONT:="UPTR",_HGDIOBJ:="UPTR",_HGLOBAL:="UPTR",_HHOOK:="UPTR",_HICON:="UPTR",_HINSTANCE:="UPTR",_HKEY:="UPTR"
    ,_HKL:="UPTR",_HLOCAL:="UPTR",_HMENU:="UPTR",_HMETAFILE:="UPTR",_HMODULE:="UPTR",_HMONITOR:="UPTR",_HPALETTE:="UPTR",_HPEN:="UPTR"
    ,_HRGN:="UPTR",_HRSRC:="UPTR",_HSZ:="UPTR",_HWINSTA:="UPTR",_HWND:="UPTR",_LPARAM:="UPTR",_LPBOOL:="UPTR",_LPBYTE:="UPTR",_LPCOLORREF:="UPTR"
    ,_LPCSTR:="UPTR",_LPCTSTR:="UPTR",_LPCVOID:="UPTR",_LPCWSTR:="UPTR",_LPDWORD:="UPTR",_LPHANDLE:="UPTR",_LPINT:="UPTR",_LPLONG:="UPTR"
    ,_LPSTR:="UPTR",_LPTSTR:="UPTR",_LPVOID:="UPTR",_LPWORD:="UPTR",_LPWSTR:="UPTR",_PHANDLE:="UPTR",_PHKEY:="UPTR",_PINT:="UPTR"
    ,_PINT_PTR:="UPTR",_PINT32:="UPTR",_PINT64:="UPTR",_PLCID:="UPTR",_PLONG:="UPTR",_PLONGLONG:="UPTR",_PLONG_PTR:="UPTR",_PLONG32:="UPTR"
    ,_PLONG64:="UPTR",_POINTER_32:="UPTR",_POINTER_UNSIGNED:="UPTR",_PSHORT:="UPTR",_PSIZE_T:="UPTR",_PSSIZE_T:="UPTR",_PSTR:="UPTR"
    ,_PTBYTE:="UPTR",_PTCHAR:="UPTR",_PTSTR:="UPTR",_PUCHAR:="UPTR",_PUHALF_PTR:="UPTR",_PUINT:="UPTR",_PUINT_PTR:="UPTR",_PUINT32:="UPTR"
    ,_PUINT64:="UPTR",_PULONG:="UPTR",_PULONGLONG:="UPTR",_PULONG_PTR:="UPTR",_PULONG32:="UPTR",_PULONG64:="UPTR",_PUSHORT:="UPTR"
    ,_PVOID:="UPTR",_PWCHAR:="UPTR",_PWORD:="UPTR",_PWSTR:="UPTR",_SC_HANDLE:="UPTR",_SC_LOCK:="UPTR",_SERVICE_STATUS_HANDLE:="UPTR"
    ,_SIZE_T:="UPTR",_UINT_PTR:="UPTR",_ULONG_PTR:="UPTR",_ATOM:="Ushort",_LANGID:="Ushort",_WCHAR:="Ushort",_WORD:="Ushort"
    
  ; Struct Contstructor
  ; Memory, offset and definitions are saved in following character + given key/name
  ;   `a = Allocated Memory
  ;   `b = Byte Offset (related to struct address)
  ;   `f = Format (encoding for string data types)
  ;   `n = New data type (AHK data type)
  ;   `r = Is Pointer (requred for __GET and __SET)
  ;   `t = Type (data type, also when it is name of a Structure it is used to resolve structure pointers dynamically
  ;   `v = Memory used to save string
  
  __NEW(_TYPE_,_pointer_=0,_init_=0){
    global _Struct,_DEBUG_

    If !_base_
      _base_:={__GET:this.base.___GET,__SET:this.base.___SET,__SETPTR:this.base.__SETPTR,__Clone:this.base.___Clone}

    If (RegExMatch(_TYPE_,"^[\w\d]+$") && !this.base.HasKey(_TYPE_)) ; structures name was supplied, resolve to global var and run again
      _TYPE_:=%_TYPE_%
    
    ; If a pointer is supplied, save it in key [""] else reserve and zero-fill memory + set pointer in key [""]
    If (_pointer_ && !IsObject(_pointer_))
      this[""] := _pointer_
    else
      this._SetCapacity("`a",_StructSize_:=sizeof(_TYPE_)) ; Set Capacity in key ["`a"]
      ,this[""]:=this._GetAddress("`a") ; Save pointer in key [""]
      ,DllCall("RtlFillMemory","UPTR",this[""],"UInt",_StructSize_,"UChar",0) ; zero-fill memory
    
    ; C/C++ style structure definition, convert it
    If InStr(_TYPE_,"`n") {
      _struct_:=[] ; keep track of structures (union is just removed because {} = union, struct{} = struct
      _union_:=0   ; init to 0, used to keep track of union depth
      Loop,Parse,_TYPE_,`n,`r`t%A_Space%%A_Tab% ; Parse each line
      {
        _LF_:=""
        Loop,parse,A_LoopField,`,`;,`t%A_Space%%A_Tab% ; Parse each item
        {
          If RegExMatch(A_LoopField,"^\s*//") ;break on comments and continue main loop
              break
          If (A_LoopField){ ; skip empty lines
              If (!_LF_ && _ArrType_:=RegExMatch(A_LoopField,"\w\s+\w")) ; new line, find out data type and save key in _LF_ Data type will be added later
                _LF_:=RegExReplace(A_LoopField,"\w\K\s+.*$")
              If Instr(A_LoopField,"{"){ ; Union, also check if it is a structure
                _union_++,_struct_.Insert(_union_,RegExMatch(A_LoopField,"i)^\s*struct\s*\{"))
              } else If InStr(A_LoopField,"}") ; end of union/struct
                _offset_.="}"
              else { ; not starting or ending struct or union so add definitions and apply Data Type.
                If _union_ ; add { or struct{
                    Loop % _union_
                      _ArrName_.=(_struct_[A_Index]?"struct":"") "{"
                _offset_.=(_offset_ ? "," : "") _ArrName_ ((_ArrType_ && A_Index!=1)?(_LF_ " "):"") RegExReplace(A_LoopField,"\s+"," ")
                _ArrName_:="",_union_:=0
              }
          }
        }
      }
      _TYPE_:=_offset_
    }

    _offset_:=0                 
    _union_:=[]                 ; keep track of union level, required to reset offset after union is parsed
    _struct_:=[]                ; for each union level keep track if it is a structure (because here offset needs to increase
    _union_size_:=[]          ; keep track of highest member within the union or structure, used to calculate new offset after union
    _total_union_size_:=0     ; used in combination with above, each loop the total offset is updated if current data size is higher
    
    ; Parse given structure definition and create struct members
    ; User structures will be resolved by recrusive calls (!!! a structure must be a global variable)
    Loop,Parse,_TYPE_,`,`;,%A_Space%%A_Tab%`n`r
    {
      _LF_ := A_LoopField,_IsPtr_:=0
      ; Check for STARTING union and set union helpers
      While (RegExMatch(_LF_,"i)(struct|union)?\s*\{\K"))
        _union_.Insert(_offset_)
        ,_union_size_.Insert(0)
        ,_struct_.Insert(RegExMatch(_LF_,"i)struct\s*\{")?1:0)
        ,_LF_:=SubStr(_LF_,RegExMatch(_LF_,"i)(struct|union)?\s*\{\K"))
       
      _LF_BKP_:=_LF_ ;to check for ending brackets = union,struct
      StringReplace,_LF_,_LF_,},,A ;remove all closing brackets (these will be checked later)
      
      ; Check if item is a pointer and remove * for further processing, separate key will store that information
      While % (InStr(_LF_,"*")){
        StringReplace,_LF_,_LF_,*
        _IsPtr_:=A_Index
      }

      ; Split off data type, name and size (only data type is mandatory)
      RegExMatch(_LF_,"^\s*(?<ArrType_>\w+)?\s*(?<ArrName_>\w+)?\s*\[?(?<ArrSize_>\d+)?\]?\s*\}*\s*$",_)

      If (!_ArrName_ && !_ArrSize_){
        If (_ArrType_=_TYPE_ || (_ArrType_ "*") =_TYPE_ || ("*" _ArrType_=_TYPE_)) {
          this["`t"]:=_TYPE_
          ,this["`n"]:=_IsPtr_?"PTR":this.base.HasKey("_" _ArrType_)?this.base["_" _ArrType_]:"PTR"
          ,this["`r"]:=_IsPtr_
          ,this["`b"]:=0
          If _ArrType_ in LPTSTR,LPCTSTR,TCHAR
            this["`f"] := A_IsUnicode ? "UTF-16" : "CP0"
          else if _ArrType_ in LPWSTR,LPCWSTR,WCHAR
            this["`f"] := "UTF-16"
          else
            this["`f"] := "CP0"
          this.base:=_base_
          Return this ;:= new _Struct(%_ArrType_%,_pointer_)   ;only Data type was supplied, object/structure has got no members/keys
        } else 
          _ArrName_:=_ArrType_,_ArrType_:="UInt"
      }
      
      ; Set structure keys.
      ; If type is not a pointer and not a Windows or AHK data type, it must be a global variable containing structure definition
      If (!_IsPtr_ && _ArrSize_) {  ; Array size supplied, e.g. TCHAR chr[5]
        _new_struct_:=""            ; concatenate new structure definition and save it as object in _ArrName_
        Loop % _ArrSize_            ; the new structure/object will contain digit keys and usual members
          _new_struct_ .= (_new_struct_?",":"") _ArrType_ " " A_Index
        If RegExMatch(_TYPE_,"^\s*" _ArrType_ "\s*\[\s*" _ArrSize_ "\s*\]\s*$"){ ;structure name was not given we have to create items 1,2,3... in this structure
          this["`t"]:=_TYPE_
          ,this["`n"]:=this.base.HasKey("_" _ArrType_)?this.base["_" _ArrType_]:"PTR"
          ,this["`r"]:=_IsPtr_
          ,this["`b"]:=0
          If _ArrType_ in LPTSTR,LPCTSTR,TCHAR
            this["`f"] := A_IsUnicode ? "UTF-16" : "CP0"
          else if _ArrType_ in LPWSTR,LPCWSTR,WCHAR
            this["`f"] := "UTF-16"
          else
            this["`f"] := "CP0"
          Loop % _ArrSize_
            this.Insert(A_Index,new _Struct(_ArrType_,this[""] + _offset_ + ((A_Index-1)*sizeof(_ArrType_))))     ; Create new structure and assign to _ArrName_
          _offset_+=sizeof(_ArrType_)*_ArrSize_       ; update offset
        } else {
          this.Insert(_ArrName_,new _Struct(_new_struct_,this[""] + _offset_))     ; Create new structure and assign to _ArrName_
          _offset_+=sizeof(_new_struct_)       ; update offset
        }
        Continue
      } else If (!_IsPtr_ && !_Struct.HasKey(_ArrType_) && !%_ArrType_%) {     ; Data type not found, also not structure was found
          MsgBox Structure %_ArrType_% not found, program will exit now         ; Display error message and exit app
          ExitApp
      } else if (!_IsPtr_ && !_Struct.HasKey(_ArrType_)){  ; _ArrType_ not found resolve to global variable (must contain struct definition)
          this.Insert(_ArrName_, new _Struct(%_ArrType_%,this[""] + _offset_,1))
          _offset_+=sizeof(%_ArrType_%) ; move offset
          Continue
      } else {
        this["`t" _ArrName_] := _ArrType_
        ,this["`n" _ArrName_]:=_IsPtr_?"PTR":this.base.HasKey("_" _ArrType_)?this.base["_" _ArrType_]:_ArrType_
        ,this["`b" _ArrName_] := _offset_ ; offset and pointer identifier for __GET, __SET
        ,this["`r" _ArrName_] := _IsPtr_ ; reqired for __GET, __SET
        
        ; Set Encoding format
        If _ArrType_ in LPTSTR,LPCTSTR,TCHAR
          this["`f" _ArrName_] := A_IsUnicode ? "UTF-16" : "CP0"
        else if _ArrType_ in LPWSTR,LPCWSTR,WCHAR
          this["`f" _ArrName_] := "UTF-16"
        else
          this["`f" _ArrName_] := "CP0"
        
        ; update current union size
        If _union_.MaxIndex()
          _union_size_[_union_.MaxIndex()]:=(_offset_ + this.base[this["`n" _ArrName_]] - _union_[_union_.MaxIndex()]>_union_size_[_union_.MaxIndex()])
                                            ?(_offset_ + this.base[this["`n" _ArrName_]] - _union_[_union_.MaxIndex()]):_union_size_[_union_.MaxIndex()]
        ; if not a union or a union + structure then offset must be moved (when structure offset will be reset below
        If (!_union_.MaxIndex()||_struct_[_struct_.MaxIndex()])
          _offset_+=_IsPtr_?A_PtrSize:_Struct[_ArrType_]
      }
      
      
      ; Check for ENDING union and reset offset and union helpers
      While (SubStr(_LF_BKP_,0)="}"){
        If !_union_.MaxIndex(){
          MsgBox Incorrect structure, missing opening braket {`nProgram will exit now `n%_TYPE_%
          ExitApp
        }
        ; Increase total size of union/structure if necessary
        _total_union_size_ := _union_size_[_union_.MaxIndex()]>_total_union_size_?_union_size_[_union_.MaxIndex()]:_total_union_size_
        ,_union_.Remove() ; remove latest items
        ,_struct_.Remove()
        ,_union_size_.Remove()
        ,_LF_BKP_:=SubStr(_LF_BKP_,1,StrLen(_LF_BKP_)-1)
        If !_union_.MaxIndex(){ ; leaving top union, add offset
          _offset_+=_total_union_size_
          _total_union_size_:=0
        } else _offset_:=_union_[_union_.MaxIndex()] ; reset offset because we left a union or structure
      }
    }
    this.base:=_base_ ; apply new base which uses below functions and uses ___GET for __GET and ___SET for __SET
    If (IsObject(_init_)){ ; Initialization of structures members, e.g. _Struct(_RECT,{left:10,right:20})
      for _key_,_value_ in _init_
        this[_key_] := _value_
    } else if IsObject(_pointer_) ; Same as above but instead of pointer a initialization
      for _key_,_value_ in _pointer_
        this[_key_] := _value_
    Return this
  }
  
  __SETPTR(_newPTR_="",_object_=0){ ;only called internally to reset pointers in structure
    If !_object_ ; called not recrusive so use this (main structure)
      _obj_:=this
    else _obj_:=_object_
    for _key_,_value_ in _obj_ ; Loop trough structure to check for structures
      If IsObject(_value_)
        this.__SETPTR(_newPTR_  + (_value_[""] - this[""]),_value_) ; _value_ contains an object/structure, call recrusive so it gets changed below
      else if (_key_="" && _obj_!=this){ ; do not apply main pointer yet because it is used to calculate offset
        _obj_[""]:=_newPTR_ ; assign new pointer.
      }
    If !_object_ ; In the end, apply main pointer
      this[""]:=_newPTR_
  }
  ___Clone(offset){
    new:={}
    for k,v in this
      if IsObject(v)
        v.___Clone(offset)
      else new[k]:=v
    new.base:=Object(NumGet(&this+0,8,"PTR"))
    new[]:=new[""]+sizeof(this)*(offset-1)
    return new
  }
  ___GET(_key_="",opt="~"){
    global _Struct          ; Used for dynamic structure creation
  	static _types__:="
    (LTrim Join
      ,ATOM:2,LANGID:2,WCHAR:2,WORD:4,PTR:" A_PtrSize ",UPTR:" A_PtrSize ",SHORT:2,USHORT:2,INT:4,UINT:4,INT64:8,UINT64:8,DOUBLE:8,FLOAT:4,CHAR:1,UCHAR:1,__int64:8
      ,TBYTE:" (A_IsUnicode?2:1) ",TCHAR:" (A_IsUnicode?2:1) ",HALF_PTR:" (A_PtrSize=8?4:2) ",UHALF_PTR:" (A_PtrSize=8?4:2) ",INT32:4,LONG:4,LONG32:4,LONGLONG:8
      ,LONG64:8,USN:8,HFILE:" A_PtrSize ",HRESULT:" A_PtrSize ",INT_PTR:" A_PtrSize ",LONG_PTR:" A_PtrSize ",POINTER_64:" A_PtrSize ",POINTER_SIGNED:" A_PtrSize "
      ,BOOL:4,SSIZE_T:" A_PtrSize ",WPARAM:" A_PtrSize ",BOOLEAN:1,BYTE:1,COLORREF:4,DWORD:4,DWORD32:4,LCID:4,LCTYPE:4,LGRPID:4,LRESULT:4,PBOOL:" A_PtrSize "
      ,PBOOLEAN:" A_PtrSize ",PBYTE:" A_PtrSize ",PCHAR:" A_PtrSize ",PCSTR:" A_PtrSize ",PCTSTR:" A_PtrSize ",PCWSTR:" A_PtrSize ",PDWORD:" A_PtrSize "
      ,PDWORDLONG:" A_PtrSize ",PDWORD_PTR:" A_PtrSize ",PDWORD32:" A_PtrSize ",PDWORD64:" A_PtrSize ",PFLOAT:" A_PtrSize ",PHALF_PTR:" A_PtrSize "
      ,UINT32:4,ULONG:4,ULONG32:4,DWORDLONG:8,DWORD64:8,ULONGLONG:8,ULONG64:8,DWORD_PTR:" A_PtrSize ",HACCEL:" A_PtrSize ",HANDLE:" A_PtrSize "
       ,HBITMAP:" A_PtrSize ",HBRUSH:" A_PtrSize ",HCOLORSPACE:" A_PtrSize ",HCONV:" A_PtrSize ",HCONVLIST:" A_PtrSize ",HCURSOR:" A_PtrSize ",HDC:" A_PtrSize "
       ,HDDEDATA:" A_PtrSize ",HDESK:" A_PtrSize ",HDROP:" A_PtrSize ",HDWP:" A_PtrSize ",HENHMETAFILE:" A_PtrSize ",HFONT:" A_PtrSize "
     )"
    static _types_:=_types__ "
    (LTrim Join
       ,HGDIOBJ:" A_PtrSize ",HGLOBAL:" A_PtrSize ",HHOOK:" A_PtrSize ",HICON:" A_PtrSize ",HINSTANCE:" A_PtrSize ",HKEY:" A_PtrSize ",HKL:" A_PtrSize "
       ,HLOCAL:" A_PtrSize ",HMENU:" A_PtrSize ",HMETAFILE:" A_PtrSize ",HMODULE:" A_PtrSize ",HMONITOR:" A_PtrSize ",HPALETTE:" A_PtrSize ",HPEN:" A_PtrSize "
       ,HRGN:" A_PtrSize ",HRSRC:" A_PtrSize ",HSZ:" A_PtrSize ",HWINSTA:" A_PtrSize ",HWND:" A_PtrSize ",LPARAM:" A_PtrSize ",LPBOOL:" A_PtrSize ",LPBYTE:" A_PtrSize "
       ,LPCOLORREF:" A_PtrSize ",LPCSTR:" A_PtrSize ",LPCTSTR:" A_PtrSize ",LPCVOID:" A_PtrSize ",LPCWSTR:" A_PtrSize ",LPDWORD:" A_PtrSize ",LPHANDLE:" A_PtrSize "
       ,LPINT:" A_PtrSize ",LPLONG:" A_PtrSize ",LPSTR:" A_PtrSize ",LPTSTR:" A_PtrSize ",LPVOID:" A_PtrSize ",LPWORD:" A_PtrSize ",LPWSTR:" A_PtrSize "
       ,PHANDLE:" A_PtrSize ",PHKEY:" A_PtrSize ",PINT:" A_PtrSize ",PINT_PTR:" A_PtrSize ",PINT32:" A_PtrSize ",PINT64:" A_PtrSize ",PLCID:" A_PtrSize "
       ,PLONG:" A_PtrSize ",PLONGLONG:" A_PtrSize ",PLONG_PTR:" A_PtrSize ",PLONG32:" A_PtrSize ",PLONG64:" A_PtrSize ",POINTER_32:" A_PtrSize "
       ,POINTER_UNSIGNED:" A_PtrSize ",PSHORT:" A_PtrSize ",PSIZE_T:" A_PtrSize ",PSSIZE_T:" A_PtrSize ",PSTR:" A_PtrSize ",PTBYTE:" A_PtrSize "
       ,PTCHAR:" A_PtrSize ",PTSTR:" A_PtrSize ",PUCHAR:" A_PtrSize ",PUHALF_PTR:" A_PtrSize ",PUINT:" A_PtrSize ",PUINT_PTR:" A_PtrSize "
       ,PUINT32:" A_PtrSize ",PUINT64:" A_PtrSize ",PULONG:" A_PtrSize ",PULONGLONG:" A_PtrSize ",PULONG_PTR:" A_PtrSize ",PULONG32:" A_PtrSize "
       ,PULONG64:" A_PtrSize ",PUSHORT:" A_PtrSize ",PVOID:" A_PtrSize ",PWCHAR:" A_PtrSize ",PWORD:" A_PtrSize ",PWSTR:" A_PtrSize ",SC_HANDLE:" A_PtrSize "
       ,SC_LOCK:" A_PtrSize ",SERVICE_STATUS_HANDLE:" A_PtrSize ",SIZE_T:" A_PtrSize ",UINT_PTR:" A_PtrSize ",ULONG_PTR:" A_PtrSize ",VOID:" A_PtrSize "
       )"
    ; ListVars
    ; MsgBox % this.HasKey("`t" _key_)
    If !this.HasKey("`t" _key_)
      If _key_<>
        If _key_ is digit
          return this.__Clone(_key_)
    If (_key_=""){           ; Key was not given so structure[] has been called, return pointer to structure
      Return this[""]
    } else If (this["`r" _key_]){ ; Pointer, create structure using structure its type and address saved in structure
      If (opt="~"){
        ; If InStr(_types_,"," this["`t" _key_] ":") ;default data type
          ; return NumGet(this[""]+this["`b" _key_],0,this["`n" _key_]) ;new _Struct(this["`t" _key_],NumGet(this[""]+this["`b" _key_],0,"PTR"))
        Loop % (this["`r" _key_]-1) 
          pointer.="*"
        MsgBox % pointer this["`t" _key_]
        Return new _Struct(pointer this["`t" _key_],NumGet(this[""]+this["`b" _key_],0,"PTR"))
      } else Return NumGet(this[""]+this["`b" _key_],0,"PTR") ;this[_key_][opt]
    } else if (opt=""){        ; Additional parameter was given and it is empty so return pointer to _key_ (struct.key[""])ListVars
      Return this[""]+this["`b" _key_]
    } else If (InStr( ",CHAR,UCHAR,TCHAR,WCHAR," , "," this["`t" _key_] "," )){  ; StrGet 1 character only
      Return StrGet(this[""]+this["`b" _key_],1,this["`f" _key_])
    } else if InStr( ",LPSTR,LPTSTR,LPCTSTR,LPWSTR,LPCWSTR," , "," this["`t" _key_] "," ){ ; StrGet string
      Return StrGet(NumGet(this[""]+this["`b" _key_],0,"PTR"),this["`f" _key_])
    } else    ; It is not a pointer and not a string so use NumGet
      Return NumGet(this[""]+this["`b" _key_],0,this["`n" _key_])
  }
  ___SET(_key_="",_value_=9223372036854775809,opt="~"){
      If (_value_=9223372036854775809){ ; Set new Pointer, here a value was assigned e.g. struct[]:=&var
          this._SetCapacity("`a",0) ; free internal memory as this is not used anymore
          this.__SETPTR(_key_) ; Reset all pointers in structure
          Return
      } else if this["`r" _key_]{ ; Pointer
        If opt
          If opt is digit  
          {
            If !NumGet(this[""]+this["`b" _key_],0,"PTR")
              this._SetCapacity("`v" _key_,A_PtrSize),NumPut(this._GetAddress("`v" _key_),this[""]+this["`b" _key_],0,"PTR")
            return NumPut(opt,this[""]+this["`b" _key_],0,"PTR")
          }
        ; It is a string, use internal memory for string and pointer, then save pointer in key so it is a Pointer to Pointer of a string
        If InStr( ",LPSTR,LPTSTR,LPCTSTR,LPWSTR,LPCWSTR," , "," this["`t" _key_] "," )
          this._SetCapacity("`v" _key_,(this["`f" _key_]="CP0" ? 1 : 2)*(StrLen(_value_)+2) + A_PtrSize) ; A_PtrSize to save additionally a pionter to string
          ,NumPut(this._GetAddress("`v" _key_)+A_PtrSize,this._GetAddress("`v" _key_),0,"PTR") ; NumPut addr of string
          ,StrPut(_value_,this._GetAddress("`v" _key_)+A_PtrSize,this["`f" _key_]) ; StrPut char to addr+A_PtrSize
          ,NumPut(this._GetAddress("`v" _key_),this[""]+this["`b" _key_],0,"PTR") ; NumPut pointer addr to key
        else if InStr( ",TCHAR,CHAR,UCHAR,WCHAR," , "," this["`t" _key_] "," ) ; same as above but for 1 Character only
          this._SetCapacity("`v" _key_,(this["`f" _key_]="CP0" ? 1 : 2)) ; Internal memory for character
          ,StrPut(SubStr(_value_,1,1),this._GetAddress("`v" _key_),1,this["`f" _key_]) ; StrPut char to addr
          ,NumPut(this._GetAddress("`v" _key_),this[""]+this["`b" _key_],0,"PTR") ; NumPut pointer addr to key
        else
          this._SetCapacity("`v" _key_,A_PtrSize) ; Internal memory for character
          ,NumPut(_value_,this._GetAddress("`v" _key_),0,this["`n" _key_])
          ,NumPut(this._GetAddress("`v" _key_),this[""]+this["`b" _key_],A_PtrSize=8?"UInt64":"UInt") ; NumPut new addr to key
      } else if InStr( ",LPSTR,LPTSTR,LPCTSTR,LPWSTR,LPCWSTR," , "," this["`t" _key_] "," ){ 
        this._SetCapacity("`v" _key_,(this["`f" _key_]="CP0" ? 1 : 2)*(StrLen(_value_)+2)) ; for simplicity add 2 bytes instead of checking for UNICODE or ANSI
        ,StrPut(_value_,this._GetAddress("`v" _key_),this["`f" _key_]) ; StrPut string to addr
        ,NumPut(this._GetAddress("`v" _key_),this[""]+this["`b" _key_],0,"PTR") ; NumPut string addr to key
      } else if InStr( ",TCHAR,CHAR,UCHAR,WCHAR," , "," this["`t" _key_] "," ){
        StrPut(SubStr(_value_,1,1),this[""] + this["`b" _key_],1,this["`f" _key_]) ; StrPut character key
      } else{
        NumPut(_value_,this[""]+this["`b" _key_],0,this["`n" _key_]) ; NumPut new value to key
      }
      Return _value_
  }
}

;: Title: TT.ahk Object based ToolTip Library by HotKeyIt
;

; Function: TT() - Object based ToolTip Library by HotKeyIt
; Description:
;      TT is based on AHK_L Objects and supports both, ANSI and UNICODE version, so to use it you will require <a href=http://www.autohotkey.com/forum/viewtopic.php?t=43049>Lexikos AutoHotkey_L.exe</a> or other versions based on it that supports objects.<br><br>TT is used to work with ToolTip controls. You can create standalone ToolTips but also ToolTips for Controls of your GUI.
; Syntax: TTObj:=TT(Options,Text,Title)
; Parameters:
;	   TTObj - ToolTip Object to control ToolTip using its functions and ToolTip messages.
;	   <b>Options</b> - <b>Description</b> (If Options is a digit or hexadecimal number TT will assume this is the parent window)
;	   <b>Options requiring a value</b> - All these options need to be followed by = and a value. For example Parent=99
;	   GUI/PARENT - Parent HWND or Gui Id (Parent can be 1-99 as well). When no Parent or GUI ID is given, GUI +LastFound will be used, when you do not want to have a parent use PARENT=0 (OnShow,OnClick,OnClose is only possible if PARENT is an AutoHotkey window)
;	   AUTOPOP / INITIAL / RESHOW - Option for Control ToolTips.<br>AUTOPOP - How long to remain visible.<br>INITIAL - Delay showing.<br>RESHOW - Delay showing between tools.<br>For reference see <a href=http://msdn.microsoft.com/en-us/library/bb760404.aspx>TTM_SETDELAYTIME Message</a>.
;	   MAXWIDTH - Maximum tooltip window width, or -1 to allow any width.<br>For reference see <a href=http://msdn.microsoft.com/en-us/library/bb760408.aspx>TTM_SETMAXTIPWIDTH Message</a>.
;	    ICON - 0=none 1=info 2=warning 3=error (> 3 = hIcon). (!!! Use "" to show the image as icon from a jpg, bmp and other image files.<br>For reference see <a href=http://msdn.microsoft.com/en-us/library/bb760414.aspx>TTM_SETTITLE Message</a>.<br>Since the Icon is in the title, it will appear only if there is a title.
;	   Color - RGB color for ToolTip text color.<br>For reference see <a href=http://msdn.microsoft.com/en-us/library/bb760413.aspx>TTM_SETTIPTEXTCOLOR Message</a>.
;	   BackGround - RGB ToolTip background color.<br>For reference see <a href=http://msdn.microsoft.com/en-us/library/bb760411.aspx>TTM_SETTIPBKCOLOR  Message</a>.
;	   OnClose/OnClick - A function to be launched when a ToolTip was closed or a link was clicked. ParseLinks option will be set automatically.<br><br>Links are created using <a [action]>Text</a>.<br>Your OnClick function can accept up to two parameters ToolTip_Message(action[,Tool]).<br>When action is not specified Text will be used.<br>Tool is your ToolTip object that you can access inside your function.<br>OnClose uses same parameters but first passed parameter will be empty.
;	   <b>Options not requiring a value<b> - <b>HWND CENTER RTL SUB TRACK ABSOLUTE TRANSPARENT PARSELINKS</b> - For reference see <a href=http://msdn.microsoft.com/en-us/library/bb760256.aspx>TOOLINFO Structure</a><br> - <b>CloseButton</b> for your ToolTip<br> - <b>ClickTrough</b> will enable clicking trough ToolTip<br> - <b>Balloon</b> ToolTip<br> - <b>Style</b> uses themed hyperlinks.<br> - <b>NoFade</b> disables fading in.<br> - <b>NoAnimate</b> disables sliding on Win2000.<br> - <b>NoPrefix</b> Prevents the system from stripping ampersand characters from a string or terminating a string at a tab character.<br> - <b>AlwaysTip</b> - Indicates that the tooltip control appears even if the tooltip control's owner window is inactive.
;	   <b>ToolTip functions</b> - <b>All function beside Add, Del, Show, Color, Remove and Text are ToolTip messages, for reference see <a href=http://msdn.microsoft.com/en-us/library/ff486069.aspx>ToolTip Messages</a>.<br>To call them use for example TTObj.TRACKACTIVATE(x,y)</b>
;	   ToolTip.<b>Add()</b> - ToolTip.Add(Control[,text,uFlags/options,parent])<br> - <b>Control</b> can be text like Button1 or hwnd of control.<br> - <b>Text</b> to be displayed.<br> - <b>uFlags/options</b> can be a value or list of strings <b>HWND CENTER RTL SUB TRACK ABSOLUTE TRANSPARENT PARSELINKS</b>.<br> - <b>Parent</b> can be a parent window, default is set in TT function, see above.<br>To enable ToolTip for Static controls like Text and Picture add 0x100 to Controls options.
;	   ToolTip.<b>Remove()</b> - Removes a ToolTip object and all control associations. Call TT_Remove() to remove all ToolTips (will be called automatically when scripts exits).
;	   ToolTip.<b>Del()</b> - ToolTip.Del(Control)<br>Delete a ToolTip associated with a control only, other ToolTips will remain.
;	   ToolTip.<b>Show()</b> - ToolTip.Show([Text,x,y,title,icon,iconIdx])<br>Show a ToolTip. x and y can be TrayIcon to show ToolTip at TrayIcon coordinates of your app.
;	   ToolTip.<b>Hide()</b> - Hides a ToolTip. Same as ToolTip.TrackPosition(0).<br>Note NoFade only disables fade in, to have no fade out use ToolTip.Text("")!
;	   ToolTip.<b>Color()</b> - ToolTip.Color(textcolor,backgroundcolor)<br>Used to set both colors and string colors like White,Black,Yellow,Red,Blue.... You can also use wrapped message straight away: TTObj.SETTIPBKCOLOR(RGBValue) and ToolTip.SETTIPTEXTCOLOR(RGBValue)
;	   ToolTip.<b>Font()</b> - ToolTip.Font(Font)<br>Change Font of ToolTip. Example ToolTip.Font("S20 bold italic striceout underline, Arial")
;	   ToolTip.<b>Text()</b> - ToolTip.Text(text)<br>Update text for main ToolTip (created when TT() is called).
;	   ToolTip.<b>Title()</b> - ToolTip.Title([title,icon,iconIdx])<br>Update title and icon for ToolTip. Icon can be 0 - 3 or a hIcon or a file path and iconIdx if it is an exe,dll or cur file.<br>IconIdx must be an empty string ("") if you want to load an icon from jpg, png, bmp, gif or other supported files by gdi as well as from HEX string.<br>Otherwise associated icon for given file type will be loaded.
;	   ToolTip.<b>Icon()</b> - ToolTip.Icon([icon,iconIdx])<br>Update only icon for ToolTip. Icon can be a file path, see title function. TT_GetIcon can be used to get a hIcon. "" for iconIdx will load the image as icon from jpg, bmp ... file.<br>Since the Icon is in the title, it will appear only if there is a title.
; Return Value:
;     TT returns a ToolTip object that can be used to perform all action on a ToolTip.
; Remarks:
;		When no Parent is given when calling TT(), Gui +LastFound will be used, when first parameter of TT(0x283475) is digit or xdigit, it will be used as parent.<br>Options TRACK and NOPREFIX are forced by default, to disable use TRACK=0 NOPREFIX=0.
; Related:
; Example:
;		file:TT_Example.ahk
;

TT_Init(){ ;initialize structures finction
	global _TOOLINFO:="cbSize,uFlags,UPTR hwnd,UPTR uId,_RECT rect,UPTR hinst,LPTSTR lpszText,UPTR lParam,void *lpReserved"
	global _RECT:="left,top,right,bottom"
	global _CURSORINFO:="cbSize,flags,HCURSOR hCursor,x,y"
	global _ICONINFO:="fIcon,xHotspot,yHotSpot,HBITMAP hbmMask,HBITMAP hbmColor"
	global _BITMAP:="LONG bmType,LONG bmWidth,LONG bmHeight,LONG bmWidthBytes,WORD bmPlanes,WORD bmBitsPixel,LPVOID bmBits"
	global _SHFILEINFO:="HICON hIcon,iIcon,DWORD dwAttributes,TCHAR szDisplayName[260],TCHAR szTypeName[80]"
}
TT(options="",text="",title=""){
	global _Struct
	static temp:=TT_Init()
	; Options
	;WS_POPUP=0x80000000,TTS_ALWAYSTIP=0x1,TTS_NOPREFIX=0x2,TTS_USEVISUALSTYLE=0x100,TTS_NOFADE=0x20,TTS_NOANIMATE=0x10
	static HWND_TOPMOST:=-1,SWP_NOMOVE=0x2, SWP_NOSIZE=0x1, SWP_NOACTIVATE=0x10
	; Objects
	,base:=Object("Color","TT_Color","Show","TT_Show","Hide","TTM_Trackactivate","Add","TT_Add","AddTool","TTM_AddTool"
			,"Del","TT_Del","Title","TTM_SetTitle","Text","TT_Text","ACTIVATE","TTM_ACTIVATE","Set","TT_Set"
			,"ADDTOOL","TTM_ADDTOOL","Remove","TT_Remove","Icon","TT_Icon","Font","TT_Font"
			,"ADJUSTRECT","TTM_ADJUSTRECT","DELTOOL","TTM_DELTOOL","ENUMTOOLS","TTM_ENUMTOOLS","GETBUBBLESIZE","TTM_GETBUBBLESIZE"
			,"GETCURRENTTOOL","TTM_GETCURRENTTOOL","GETDELAYTIME","TTM_GETDELAYTIME","GETMARGIN","TTM_GETMARGIN"
			,"GETMAXTIPWIDTH","TTM_GETMAXTIPWIDTH","GETTEXT","TTM_GETTEXT","GETTIPBKCOLOR","TTM_GETTIPBKCOLOR"
			,"GETTIPTEXTCOLOR","TTM_GETTIPTEXTCOLOR","GETTITLE","TTM_GETTITLE","GETTOOLCOUNT","TTM_GETTOOLCOUNT"
			,"GETTOOLINFO","TTM_GETTOOLINFO","HITTEST","TTM_HITTEST","NEWTOOLRECT","TTM_NEWTOOLRECT","POP","TTM_POP"
			,"POPUP","TTM_POPUP","RELAYEVENT","TTM_RELAYEVENT","SETDELAYTIME","TTM_SETDELAYTIME","SETMARGIN","TTM_SETMARGIN"
			,"SETMAXTIPWIDTH","TTM_SETMAXTIPWIDTH","SETTIPBKCOLOR","TTM_SETTIPBKCOLOR","SETTIPTEXTCOLOR","TTM_SETTIPTEXTCOLOR"
			,"SETTITLE","TTM_SETTITLE","SETTOOLINFO","TTM_SETTOOLINFO","SETWINDOWTHEME","TTM_SETWINDOWTHEME"
			,"TRACKACTIVATE","TTM_TRACKACTIVATE","TRACKPOSITION","TTM_TRACKPOSITION","UPDATE","TTM_UPDATE"
			,"UPDATETIPTEXT","TTM_UPDATETIPTEXT","WINDOWFROMPOINT","TTM_WINDOWFROMPOINT"
			,"GetAddress","GetAddress","_NewEnum","_NewEnum","__Delete","__Delete","base",Object("__Call","TT_Set","__Delete","TT_Delete"))
	,@:=Object()
	If options=9223372036854775808 
		Return @
	else if options is xdigit
		Parent:=options
	else If (options){
		Loop,Parse,options,%A_Space%,%A_Space%
			If istext {
				If (SubStr(A_LoopField,0)="'")
					%istext%:=string A_Space SubStr(A_LoopField,1,StrLen(A_LoopField)-1),istext:="",string:=""
				else
					string.= A_Space A_LoopField
			} else If A_LoopField contains AUTOPOP,INITIAL,PARENT,RESHOW,MAXWIDTH,ICON,Color,BackGround,OnClose,OnClick,OnShow,GUI,NOPREFIX,TRACK
			{
				RegExMatch(A_LoopField,"^(\w+)=?(.*)?$",option)
				If ((Asc(option2)=39 && SubStr(A_LoopField,0)!="'") && (istext:=option1) && (string:=SubStr(option2,2)))
					Continue
				%option1%:=option2
			} else if A_LoopField
				%A_LoopField% := 1
	}
	If (Parent && Parent<100 && !DllCall("IsWindow","UPTR",Parent)){
		Gui,%Parent%:+LastFound
		Parent:=WinExist()
	} else if (GUI){
		Gui, %GUI%:+LastFound
		Parent:=WinExist()
	} else if (Parent=""){
		Gui +LastFound
		Parent:=WinExist()
	}
	T:=Object("base",base)
	T.HWND := DllCall("CreateWindowEx", "UInt", (ClickTrough?0x20:0)|0x8, "str", "tooltips_class32", "UPTR", 0
         , "UInt",0x80000000|(Style?0x100:0)|(NOFADE?0x20:0)|(NoAnimate?0x10:0)|((NOPREFIX+1)?(NOPREFIX?0x2:0x2):0x2)|(AlwaysTip?0x1:0)|(ParseLinks?0x1000:0)|(CloseButton?0x80:0)|(Balloon?0x40:0)
         , "int",0x80000000,"int",0x80000000,"int",0x80000000,"int",0x80000000, "UPTR",Parent?Parent:0,"UPTR",0,"UPTR",0,"UPTR",0,"UPTR")
	DllCall("SetWindowPos","UPTR",T.HWND,"UPTR",HWND_TOPMOST,"Int",0,"Int",0,"Int",0,"Int",0
                           ,"UInt",SWP_NOMOVE|SWP_NOSIZE|SWP_NOACTIVATE)
	@.Insert(T)
	T.SETMAXTIPWIDTH(MAXWIDTH?MAXWIDTH:A_ScreenWidth)
	If !(AUTOPOP INITIAL RESHOW)
		T.SETDELAYTIME()
	else T.SETDELAYTIME(AUTOPOP?AUTOPOP*1000:-1),T.SETDELAYTIME(INITIAL?INITIAL*1000:-1),T.SETDELAYTIME(RESHOW?RESHOW*1000:-1)
	T.fulltext:=text,T.maintext:=RegExReplace(text,"<a\K[^<]*?>",">")
	If ((T.OnClick:=OnClick)||(T.OnClose:=OnClose)||(T.OnShow:=OnShow)),T.OnClose:=OnClose,T.OnShow:=OnShow,T.ClickHide:=ClickHide
		OnMessage(0x4e,"TT_OnMessage")
	If OnClick
		ParseLinks:=1
	T.rc:=new _Struct("_RECT") ;for TTM_SetMargin
	;Tool for Main ToolTip
	T.P:=new _Struct("_TOOLINFO"),P:=T.P,P.cbSize:=sizeof("_TOOLINFO")
	P.uFlags:=(HWND?0x1:0)|(Center?0x2:0)|(RTL?0x4:0)|(SUB?0x10:0)|(Track+1?(Track?0x20:0):0x20)|(Absolute?0x80:0)|(TRANSPARENT?0x100:0)|(ParseLinks?0x1000:0)
	P.hwnd:=Parent,P.uId:=Parent,P.lpszText:=T.maintext,T.AddTool(P[])
	If Color
		T.SETTIPTEXTCOLOR(Color)
	If Background
		T.SETTIPBKCOLOR(BackGround)
	T.SetTitle(T.maintitle:=title,icon)
	Sleep,100
	Return T
}

TT_Delete(t=""){ ;delete all ToolTips (will be executed OnExit)
	TT_Remove(),TT_GetIcon() ;delete ToolTips and Destroy all icon handles
}

TT_Remove(T=""){
	static @:=TT(9223372036854775808) ;Get main object that holds all ToolTips
	If !T
		Loop % @.MaxIndex()
		{
			T:=@[A_Index]
			@.Remove(A_Index)
			for id,tool in T.T
				T.DelTool(tool[])
			T.DelTool(T.P[])
			DllCall("DestroyWindow","UPTR",T.HWND)
		}
	else
		for id,Tool in @
		{
			If (T=Tool){
				@[id]:=@[@.MaxIndex()],@.Remove(id)
				for id,tools in Tool.T
					Tool.DelTool(tools[])
				Tool.DelTool(Tool.P[])
				DllCall("DestroyWindow","UPTR",Tool.HWND)
				break
			}
		}
}

TT_OnMessage(wParam,lParam,msg,hwnd){
	static TTN_FIRST:=0xfffffdf8, @:=TT(9223372036854775808) ;Get main object that holds all ToolTips
  Loop 4
		m += *(lParam + 8 + (A_PtrSize=4?0:8) + A_Index-1) << 8*(A_Index-1)
	m:=TTN_FIRST-m
	If m not between 1 and 3
		Return
	Loop 4
		p += *(lParam + 0 + A_Index-1) << 8*(A_Index-1)
	If (m=3)
		Loop 4
			option += *(lParam + 16 + (A_PtrSize=4?0:12) + A_Index-1) << 8*(A_Index-1)
	for id,T in @
		If (p=T.hwnd)
			break
	text:=T.fulltext
	If (m=1){ 							;Show
		If IsFunc(T.OnShow)
			T.OnShow("",T)
	} else If (m=2){ 					;Close
		If IsFunc(T.OnClose)
			T.OnClose("",T)
		T.TRACKACTIVATE(0,T.P[])
	} else If InStr(text,"<a"){	;Click
		Loop % option+1
			StringTrimLeft,text,text,% InStr(text,"<a")+1
		If T.ClickHide
			T.TRACKACTIVATE(0,T.P[])
		action:=SubStr(text,1,InStr(text,">")-1)
		If !(action){
			StringTrimLeft,text,text,% InStr(text,">")
			text:=SubStr(text,1,InStr(text,"</a>")-1)
			action:=text
		} else
			action=%action%
		If IsFunc(T.OnClick)
			T.OnClick(action,T)
	}
	Return true
}

TT_ADD(T,Control,Text="",uFlags="",Parent=""){
	;	uFlags http://msdn.microsoft.com/en-us/library/bb760256.aspx
	; TTF_ABSOLUTE=0x80, TTF_CENTERTIP=0x0002, TTF_IDISHWND=0x1, TTF_PARSELINKS=0x1000 ,TTF_RTLREADING = 0x4
	; TTF_SUBCLASS=0x10, TTF_TRAMsgCK=0x20, TTF_TRANSPARENT=0x100
	global _Struct
	DetectHiddenWindows:=A_DetectHiddenWindows
	DetectHiddenWindows,On
	if (Parent){
		If (Parent && Parent<100 and !DllCall("IsWindow","UPTR",Parent)){
			Gui %Parent%:+LastFound
			Parent:=WinExist()
		}
		T["T",Abs(Parent)]:=new _Struct("_TOOLINFO"),Tool:=T["T",Abs(Parent)]
		Tool.uId:=Parent,Tool.hwnd:=Parent,Tool.uFlags:=(0|16)
		DllCall("GetClientRect","UPTR",T.HWND,"UPTR", T[Abs(Parent)].rect[])
		T.ADDTOOL(T["T",Abs(Parent)][])
	}
	If text=
		ControlGetText,text,%Control%,% "ahk_id " (Parent?Parent:T.P.hwnd)
	If Control is not Xdigit
		If Control is not digit
			ControlGet,Control,Hwnd,,%Control%,% "ahk_id " (Parent?Parent:T.P.hwnd)
	If uFlags
		If uFlags is not digit
		{
			Loop,Parse,uflags,%A_Space%,%A_Space%
				If A_LoopField
					%A_LoopField% := 1
			uFlags:=(HWND?0x1:HWND=""?0x1:0)|(Center?0x2:0)|(RTL?0x4:0)|(SUB?0x10:0)|(Track?0x20:0)|(Absolute?0x80:0)|(TRANSPARENT?0x100:0)|(ParseLinks?0x1000:0)
		}
	T["T",Abs(Control)]:=new _Struct("_TOOLINFO")
	Tool:=T.T[Abs(Control)]
	Tool.cbSize:=sizeof("_TOOLINFO")
	T[Abs(Control),"text"]:=RegExReplace(text,"<a\K[^<]*?>",">")
	Tool.uId:=Control,Tool.hwnd:=Parent?Parent:T.P.hwnd,Tool.uFlags:=uFlags?(uFlags|16):(1|16)
	Tool.lpszText:=T[Abs(Control)].text
	DllCall("GetClientRect","UPTR",T.HWND,"UPTR",Tool.rect[])
	T.ADDTOOL(Tool[])
	DetectHiddenWindows,%DetectHiddenWindows%
}

TT_DEL(T,Control){
	If !Control
		Return 0
	If Control is not Xdigit
		If Control is not digit
			ControlGet,Control,Hwnd,,%Control%,% "ahk_id " t.P.hwnd
   T.DELTOOL(T.T[Abs(Control)][]),T.T.Remove(Abs(Control))
}

TT_Color(T,Color="",Background=""){
	static TTM_SETTIPBKCOLOR=0x413,TTM_SETTIPTEXTCOLOR=0x414
		,Black=0x000000,Green=0x008000,Silver=0xC0C0C0,Lime=0x00FF00,Gray=0x808080,Olive=0x808000
		,White=0xFFFFFF,Yellow=0xFFFF00,Maroon=0x800000,Navy=0x000080,Red=0xFF0000,Blue=0x0000FF
		,Purple=0x800080,Teal=0x008080,Fuchsia=0xFF00FF,Aqua=0x00FFFF
	If (Color!="")
		T.SETTIPTEXTCOLOR(Color)
	If (BackGround!="")
		T.SETTIPBKCOLOR(BackGround)
}

TT_Text(T,text){
	static TTM_UPDATETIPTEXT=0x400+(A_IsUnicode?57:12),TTM_UPDATE=0x400+29
	T.fulltext:=text,T.maintext:=RegExReplace(text,"<a\K[^<]*?>",">"),T.P.lpszText:=T.maintext
	T.UPDATETIPTEXT(T.P[])
}
TT_Icon(T,icon=0,icon#=1){
   static TTM_SETTITLE = 0x400 + (A_IsUnicode ? 33 : 32)
	If icon
		If icon is not digit
			icon:=TT_GetIcon(icon,icon#)
   Return DllCall("SendMessage","UPTR",T.HWND,"UInt",TTM_SETTITLE,"UPTR",icon,"UPTR",T.GetAddress("maintitle"),"UPTR"),T.UPDATE()
}

TT_GetIcon(File="",Icon#=1){
   global _Struct
   static hIcon:=Object(),AW:=A_IsUnicode?"W":"A"
		,si:=DllCall( "LoadLibrary", "Str","gdiplus","UPTR"),temp:=VarSetCapacity(si, 16, 0), si := Chr(1)
	If !sfi {
      sfi:=new _Struct("_SHFILEINFO"),sfi_size:=sizeof("_SHFILEINFO")
		SysGet, SmallIconSize, 49
		DllCall("gdiplus\GdiplusStartup", "UPTR*",pToken, "UPTR",&si, "UPTR",0)
	}
	If !File {
		for file,obj in hIcon
			If IsObject(obj){
				for icon,handle in obj
					DllCall("DestroyIcon","UPTR",handle)
			} else 
				DllCall("DestroyIcon","UPTR",handle)
		DllCall("gdiplus\GdiplusShutdown", "UPTR",pToken),sfi:=""
		Return
	}
	If hIcon[File,Icon#]
		Return hIcon[file,Icon#] 
	SplitPath, File,,, Ext
   If ext in cur
	{
		Return hIcon[file,Icon#]:=DllCall("LoadImage", "UPTR", 0, "str", File, "uint", ext="cur"?2:1, "int", 0, "int", 0, "uint", 0x10,"UPTR")
	} else if Ext in EXE,ICO,DLL
   {
      If ext=LNK
      {
         FileGetShortcut,%File%,Fileto,,,,FileIcon,FileIcon#
         File:=!FileIcon ? FileTo : FileIcon
      }
      SplitPath, File,,, Ext
	   DllCall("PrivateExtractIcons", "Str", File, "Int", Icon#-1, "Int", SmallIconSize, "Int", SmallIconSize, "UPTR*", Icon, "UPTR*", 0, "UInt", 1, "UInt", 0, "Int")
		Return hIcon[File,Icon#]:=Icon
	} else if (Icon#=""){
		If !FileExist(File){ 
			if File is xdigit ;assume Hex string
			{
				nSize := StrLen(File)//2
				VarSetCapacity( Buffer,nSize ) 
				Loop % nSize 
				  NumPut( "0x" . SubStr(File,2*A_Index-1,2), Buffer, A_Index-1, "Char" )
			} else Return
		} else {
			FileGetSize,nSize,%file%
			FileRead,Buffer,*c %file%
		}
		hData := DllCall("GlobalAlloc", "UInt",2, "UInt", nSize,"UPTR")
		pData := DllCall("GlobalLock", "UPTR",hData,"UPTR")
		DllCall( "RtlMoveMemory", "UPTR",pData, "UPTR",&Buffer, "UInt",nSize )
		DllCall( "GlobalUnlock", "UPTR",hData )
		DllCall( "ole32\CreateStreamOnHGlobal", "UPTR",hData, "Int",True, "UPTR*",pStream )
		DllCall( "gdiplus\GdipCreateBitmapFromStream", "UInt",pStream, "UPTR*",pBitmap )
		DllCall( "gdiplus\GdipCreateHBITMAPFromBitmap", "UPTR",pBitmap, "UPTR*",hBitmap, "UInt",0 )
		DllCall( "gdiplus\GdipDisposeImage", "UPTR",pBitmap )
		ii:=new _Struct("_ICONINFO")
		ii.ficon:=1,ii.hbmMask:=hBitmap,ii.hbmColor:=hBitmap
		return hIcon[File]:=DllCall("CreateIconIndirect","UPTR",ii[],"UPTR")
	} else {
		If hIcon[File]
			Return hIcon[file]
		else If DllCall("Shell32\SHGetFileInfo" AW, "str", File, "uint", 0, "UPTR", sfi[], "uint", sfi_size, "uint", 0x101,"UPTR"){
			Return hIcon[Ext] := sfi.hIcon
      }
	}
}

TT_Show(T,text="",x="",y="",title="",icon="",icon#=1){
	global _Struct
	static pcursor:= new _Struct("_CURSORINFO"),sizeof_Cursor:=sizeof("_CURSORINFO")
	static picon:=new _Struct("_ICONINFO")
	static pbitmap:=new _Struct("_BITMAP"),sizeof_B:=sizeof("_BITMAP")
	If Text!=
		T.Text(text)
	If (title!="")
		T.SETTITLE(title,icon,icon#)
	If (x="TrayIcon" || y="TrayIcon"){
		DetectHiddenWindows,% (DetectHiddenWindows:=A_DetectHiddenWindows ? "On" : "On")
		Process, Exist
		PID:=ErrorLevel
		hWndTray:=WinExist("ahk_class Shell_TrayWnd")
		ControlGet,hWndToolBar,Hwnd,,ToolbarWindow321,ahk_id %hWndTray%
		WinGet, procpid, PID,ahk_id %hWndToolBar%
		VarSetCapacity(lpdata,20),VarSetCapacity(dwExtraData,8)
		DataH   := DllCall( "OpenProcess", "uint", 0x38, "int", 0, "uint", procpid,"UPTR") ;0x38 = PROCESS_VM_OPERATION+READ+WRITE
		bufAdr  := DllCall( "VirtualAllocEx", "UPTR", DataH, "UPTR", 0, "uint", 20, "uint", MEM_COMMIT:=0x1000, "uint", PAGE_READWRITE:=0x4,"UPTR")
		max:=DllCall("SendMessage","UPTR",hWndToolBar,"UInt",0x418,"UPTR",0,"UPTR",0,"UPTR")
    Loop % max
		{
			i:=max-A_Index
      DllCall("SendMessage","UPTR",hWndToolBar,"UInt",0x417,"UPTR",i,"UPTR",bufAdr,"UPTR")
			DllCall("ReadProcessMemory", "UPTR", DataH, "UPTR", bufAdr, "UPTR", &lpdata, "uint", 20, "uint", 0)
			DllCall("ReadProcessMemory", "UPTR", DataH, "UPTR", NumGet(lpData,12), "UPTR", &dwExtraData, "UInt", 8, "UInt", 0)
			WinGet,BWPID,PID,% "ahk_id " NumGet(dwExtraData,0)
			If (BWPID!=PID)
				continue
			DllCall("SendMessage","UPTR",hWndToolBar,"UInt",0x41d,"UPTR",i,"UPTR",bufAdr,"UPTR")
			If (NumGet(lpData,8)>7){
				ControlGetPos,xc,yc,xw,yw,Button2,ahk_id %hWndTray%
				xc+=xw/2, yc+=yw/4
			} else {
				DllCall( "ReadProcessMemory", "UPTR", DataH, "UPTR", bufAdr, "UPTR", &lpdata, "uint", 20, "uint", 0 )
				ControlGetPos,xc,yc,,,ToolbarWindow321,ahk_id %hWndTray%
				halfsize:=NumGet(lpdata,12)/2
				xc+=NumGet(lpdata,0)+ halfsize
				yc+=NumGet(lpdata,4)+ (halfsize/1.5)
			}
			WinGetPos,xw,yw,,,ahk_id %hWndTray%
			xc+=xw,yc+=yw
			break
		}
		If (!xc && !yc){
			If A_OsVersion in Win_7,WIN_VISTA
					ControlGetPos,xc,yc,xw,yw,Button1,ahk_id %hWndTray%
				else
					ControlGetPos,xc,yc,xw,yw,Button2,ahk_id %hWndTray%
			xc+=xw/2, yc+=yw/4
			WinGetPos,xw,yw,,,ahk_id %hWndTray%
			xc+=xw,yc+=yw
		}
		DllCall( "VirtualFreeEx", "UPTR", DataH, "UPTR", bufAdr, "uint", 0, "uint", MEM_RELEASE:=0x8000)
		DllCall( "CloseHandle", "UPTR", DataH )
		DetectHiddenWindows % DetectHiddenWindows
		If x=TrayIcon
			x:=xc
		If y=TrayIcon
			y:=yc
	}
	If (x="" || y=""){
		pCursor.cbSize:=sizeof_Cursor
		DllCall("GetCursorInfo", "ptr", pCursor[""])
		DllCall("GetIconInfo", "ptr", pCursor.hCursor, "ptr", pIcon[""])
		If picon.hbmColor
			DllCall("DeleteObject", "ptr", pIcon.hbmColor)
		DllCall("GetObject", "ptr", pIcon.hbmMask, "uint", sizeof_B, "ptr", pBitmap[""])
		hbmo := DllCall("SelectObject", "ptr", cdc:=DllCall("CreateCompatibleDC", "ptr", sdc:=DllCall("GetDC","ptr"),"ptr"), "ptr", pIcon.hbmMask)
		w:=pBitmap.bmWidth,h:=pBitmap.bmHeight, h:= h=w*2 ? (h//2,c:=0xffffff,s:=32) : (h,c:=s:=0)
		Loop % w {
			xi := A_Index - 1
			Loop % h {
				yi := A_Index - 1 + s
				if (DllCall("GetPixel", "ptr", cdc, "uint", xi, "uint", yi) = c) {
					if (xo < xi)
						 xo := xi
					if (xs = "" || xs > xi)
						 xs := xi
					if (yo < yi)
						 yo := yi
					if (ys = "" || ys > yi)
						 ys := yi
				}
			}
		}
		DllCall("ReleaseDC", "ptr", 0, "ptr", sdc)
		DllCall("DeleteDC", "ptr", cdc)
		DllCall("DeleteObject", "ptr", hbmo)
		DllCall("DeleteObject", "ptr", picon.hbmMask)
		If (y=""){
			SysGet,yl,77
			SysGet,yr,79
			y:=pCursor.y-pIcon.yHotspot+ys+(yo-ys)-s+1
			If y not between %yl% and %yr%
				y:=y<yl ? yl : yr
			If (y > yr - 20)
				y := yr - 20
		}
		If (x=""){
			SysGet,xr,78
			SysGet,xl,76
			x:=pCursor.x-pIcon.xHotspot+xs+(xo-xs)+1
			If x not between %xl% and %xr%
				x:=x<xl ? xl : xr
		}
	}
	T.TRACKPOSITION(x,y)
	T.TRACKACTIVATE(1)
}

TT_Set(T,option="",OnOff=1){
	static Style=0x100,NOFADE=0x20,NoAnimate=0x10,NOPREFIX=0x2,AlwaysTip=0x1,ParseLinks=0x1000,CloseButton=0x80,Balloon=0x40
			,ClickTrough=0x20
	If option in Style,NOFADE,NoAnimate,NOPREFIX,AlwaysTip,ParseLinks,CloseButton,Balloon
		DllCall("SetWindowLong","UPTR",T.HWND,"UInt",-16,"UInt",DllCall("GetWindowLong","UPTR",T.HWND,"UInt",-16)+(OnOff?(%option%):(-%option%)))
	else If option in ClickTrough
		DllCall("SetWindowLong","UPTR",T.HWND,"UInt",-20,"UInt",DllCall("GetWindowLong","UPTR",T.HWND,"UInt",-20)+(OnOff?(%option%):(-%option%)))
	else
		MsgBox Invalid option: %option%
	T.Update()
}

TT_Font(T, pFont="") { ;Taken from HE_SetFont, thanks majkinetor. http://www.autohotkey.com/forum/viewtopic.php?p=124450#124450
   static WM_SETFONT := 0x30

 ;parse font 
   italic      := InStr(pFont, "italic")    ?  1    :  0 
   underline   := InStr(pFont, "underline") ?  1    :  0 
   strikeout   := InStr(pFont, "strikeout") ?  1    :  0 
   weight      := InStr(pFont, "bold")      ? 700   : 400 

 ;height 
   RegExMatch(pFont, "(?<=[S|s])(\d{1,2})(?=[ ,])", height) 
   if (height = "") 
      height := 10 
   RegRead, LogPixels, HKEY_LOCAL_MACHINE, SOFTWARE\Microsoft\Windows NT\CurrentVersion\FontDPI, LogPixels 
   height := -DllCall("MulDiv", "int", Height, "int", LogPixels, "int", 72) 

 ;face 
   RegExMatch(pFont, "(?<=,).+", fontFace)    
   if (fontFace != "") 
       fontFace := RegExReplace( fontFace, "(^\s*)|(\s*$)")      ;trim 
   else fontFace := "MS Sans Serif" 
	If (pFont && !InStr(pFont,",") && (italic+underline+strikeout+weight)=400)
		fontFace:=pFont
	
 ;create font 
   hFont   := DllCall("CreateFont", "int",  height, "int",  0, "int",  0, "int", 0 
                      ,"int",  weight,   "Uint", italic,   "Uint", underline 
                      ,"uint", strikeOut, "Uint", nCharSet, "Uint", 0, "Uint", 0, "Uint", 0, "Uint", 0, "str", fontFace) 

   ret:= DllCall("SendMessage","UPTR",T.hwnd,"UInt",WM_SETFONT,"UPTR",hFont,"UPTR",TRUE,"UPTR")
	DllCall("CloseHandle","UPTR",hfont)
	Return ret
}

TTM_ACTIVATE(T,Activate=0){
   static TTM_ACTIVATE = 0x400 + 1
   Return DllCall("SendMessage","UPTR",T.HWND,"UInt",TTM_ACTIVATE,"UPTR",activate,"UPTR",0,"UPTR")
}

TTM_ADDTOOL(T,pTOOLINFO){
   static TTM_ADDTOOL = A_IsUnicode ? 0x432 : 0x404
   Return DllCall("SendMessage","UPTR",T.HWND,"UInt",TTM_ADDTOOL,"UPTR",0,"UPTR",pTOOLINFO,"UPTR")
}

TTM_ADJUSTRECT(T,action,prect){
   static TTM_ADJUSTRECT = 0x41f
   Return DllCall("SendMessage","UPTR",T.HWND,"UInt",TTM_ADJUSTRECT,"UPTR",action,"UPTR",prect,"UPTR")
}
TTM_DELTOOL(T,pTOOLINFO){
   static TTM_DELTOOL = A_IsUnicode ? 0x433 : 0x405
   Return DllCall("SendMessage","UPTR",T.HWND,"UInt",TTM_DELTOOL,"UPTR",0,"UPTR",pTOOLINFO,"UPTR")
}
TTM_ENUMTOOLS(T,idx,pTOOLINFO){
   static TTM_ENUMTOOLS = A_IsUnicode?0x43a:0x40e
   Return DllCall("SendMessage","UPTR",T.HWND,"UInt",TTM_ENUMTOOLS,"UPTR",idx,"UPTR",pTOOLINFO,"UPTR")
}
TTM_GETBUBBLESIZE(T,pTOOLINFO){
   static TTM_GETBUBBLESIZE = 0x41e
   Return DllCall("SendMessage","UPTR",T.HWND,"UInt",TTM_GETBUBBLESIZE,"UPTR",0,"UPTR",pTOOLINFO,"UPTR")
}
TTM_GETCURRENTTOOL(T,pTOOLINFO){
   static TTM_GETCURRENTTOOL = 0x400 + (A_IsUnicode ? 59 : 15)
   return DllCall("SendMessage","UPTR",T.HWND,"UInt",TTM_GETCURRENTTOOL,"UPTR",0,"UPTR",pTOOLINFO,"UPTR")
}
TTM_GETDELAYTIME(T,whichtime){
	;TTDT_RESHOW = 1; TTDT_AUTOPOP = 2; TTDT_INITIAL = 3
   static TTM_GETDELAYTIME = 0x400 + 21
   return DllCall("SendMessage","UPTR",T.HWND,"UInt",TTM_GETDELAYTIME,"UPTR",whichtime,"UPTR",0,"UPTR")
}
TTM_GETMARGIN(T,pRECT){
   static TTM_GETMARGIN = 0x41b
   Return DllCall("SendMessage","UPTR",T.HWND,"UInt",TTM_GETMARGIN,"UPTR",0,"UPTR",pRECT,"UPTR")
}
TTM_GETMAXTIPWIDTH(T,wParam=0,lParam=0){
   static TTM_GETMAXTIPWIDTH = 0x419
   return DllCall("SendMessage","UPTR",T.HWND,"UInt",TTM_GETMAXTIPWIDTH,"UPTR",0,"UPTR",0,"UPTR")
}
TTM_GETTEXT(T,buffer,pTOOLINFO){
   static TTM_GETTEXT = A_IsUnicode?0x438:0x40b
   Return DllCall("SendMessage","UPTR",T.HWND,"UInt",TTM_GETTEXT,"UPTR",buffer,"UPTR",pTOOLINFO,"UPTR")
}
TTM_GETTIPBKCOLOR(T,wParam=0,lParam=0){
   static TTM_GETTIPBKCOLOR = 0x416
   return DllCall("SendMessage","UPTR",T.HWND,"UInt",TTM_GETTIPBKCOLOR,"UPTR",0,"UPTR",0,"UPTR")
}
TTM_GETTIPTEXTCOLOR(T,wParam=0,lParam=0){
   static TTM_GETTIPTEXTCOLOR = 0x417
   return DllCall("SendMessage","UPTR",T.HWND,"UInt",TTM_GETTIPTEXTCOLOR,"UPTR",0,"UPTR",0,"UPTR")
}
TTM_GETTITLE(T,pTTGETTITLE){
	;struct("TTGETTITLE:DWORD dwSize,UPTR uTitleBitmap,UPTR cch,WCHAR *pszTitle")
   static TTM_GETTITLE = 0x423
   Return DllCall("SendMessage","UPTR",T.HWND,"UInt",TTM_GETTITLE,"UPTR",0,"UPTR",pTTGETTITLE,"UPTR")
}
TTM_GETTOOLCOUNT(T,wParam=0,lParam=0){
   static TTM_GETTOOLCOUNT = 0x40d
   return DllCall("SendMessage","UPTR",T.HWND,"UInt",TTM_GETTOOLCOUNT,"UPTR",0,"UPTR",0,"UPTR")
}
TTM_GETTOOLINFO(T,pTOOLINFO){
   static TTM_GETTOOLINFO = 0x400 + (A_IsUnicode ? 53 : 8)
   return DllCall("SendMessage","UPTR",T.HWND,"UInt",TTM_GETTOOLINFO,"UPTR",0,"UPTR",pTOOLINFO,"UPTR")
}
TTM_HITTEST(T,pTTHITTESTINFO){
	;struct("TTHITTESTINFO:HWND hwnd,POINT pt,TOOLINFO ti")
   static TTM_HITTEST = A_IsUnicode?0x437:0x40a
   return DllCall("SendMessage","UPTR",T.HWND,"UInt",TTM_HITTEST,"UPTR",0,"UPTR",pTTHITTESTINFO,"UPTR")
}
TTM_NEWTOOLRECT(T,pTOOLINFO=0){
   static TTM_NEWTOOLRECT = 0x400 + (A_IsUnicode ? 52 : 6)
   Return DllCall("SendMessage","UPTR",T.HWND,"UInt",TTM_NEWTOOLRECT,"UPTR",0,"UPTR",pTOOLINFO?pTOOLINFO:T.P[""],"UPTR")
}
TTM_POP(T,wParam=0,lParam=0){
   static TTM_POP = 0x400 + 28 
   Return DllCall("SendMessage","UPTR",T.HWND,"UInt",TTM_POP,"UPTR",0,"UPTR",0,"UPTR")
}
TTM_POPUP(T,wParam=0,lParam=0){
   static TTM_POPUP = 0x422
   Return DllCall("SendMessage","UPTR",T.HWND,"UInt",TTM_POPUP,"UPTR",0,"UPTR",0,"UPTR")
}
TTM_RELAYEVENT(T,wParam=0,lParam=0){
	;struct("MSG:HWND hwnd,UPTR message,WPARAM wParam,LPARAM lParam,DWORD time,POINT pt")
   static TTM_RELAYEVENT = 0x407
   Return DllCall("SendMessage","UPTR",T.HWND,"UInt",TTM_RELAYEVENT,"UPTR",0,"UPTR",0,"UPTR")
}
TTM_SETDELAYTIME(T,whichTime=0,mSec=-1){
	;TTDT_AUTOMATIC = 0; TTDT_RESHOW = 1; TTDT_AUTOPOP = 2; TTDT_INITIAL = 3
   static TTM_SETDELAYTIME = 0x400 + 3
   Return DllCall("SendMessage","UPTR",T.HWND,"UInt",TTM_SETDELAYTIME,"UPTR",whichTime,"UPTR",mSec,"UPTR")
}
TTM_SETMARGIN(T,top=0,left=0,bottom=0,right=0){
   static TTM_SETMARGIN = 0x41a
	rc:=T.rc,rc.top:=top,rc.left:=left,rc.bottom:=bottom,rc.right:=right
	Return DllCall("SendMessage","UPTR",T.HWND,"UInt",TTM_SETMARGIN,"UPTR",0,"UPTR",rc[""],"UPTR")
}
TTM_SETMAXTIPWIDTH(T,maxwidth=-1){
   static TTM_SETMAXTIPWIDTH = 0x418
   return DllCall("SendMessage","UPTR",T.HWND,"UInt",TTM_SETMAXTIPWIDTH,"UPTR",0,"UPTR",maxwidth,"UPTR")
}
TTM_SETTIPBKCOLOR(T,color=0){
   static TTM_SETTIPBKCOLOR = 0x413
			,Black:=0x000000,    Green:=0x008000,		Silver:=0xC0C0C0,		Lime:=0x00FF00
			,Gray:=0x808080,    	Olive:=0x808000,		White:=0xFFFFFF,   	Yellow:=0xFFFF00
			,Maroon:=0x800000,	Navy:=0x000080,		Red:=0xFF0000,    	Blue:=0x0000FF
			,Purple:=0x800080,   Teal:=0x008080,		Fuchsia:=0xFF00FF,	Aqua:=0x00FFFF
	If color is alpha
		If (%color%)
			Color:=%color%
	Color := (StrLen(Color) < 8 ? "0x" : "") . Color
	Color := ((Color&255)<<16)+(((Color>>8)&255)<<8)+(Color>>16) ; rgb -> bgr
   Return DllCall("SendMessage","UPTR",T.HWND,"UInt",TTM_SETTIPBKCOLOR,"UPTR",color,"UPTR",0,"UPTR")
}
TTM_SETTIPTEXTCOLOR(T,color=0){
   static TTM_SETTIPTEXTCOLOR = 0x414
			,Black:=0x000000,    Green:=0x008000,		Silver:=0xC0C0C0,		Lime:=0x00FF00
			,Gray:=0x808080,    	Olive:=0x808000,		White:=0xFFFFFF,   	Yellow:=0xFFFF00
			,Maroon:=0x800000,	Navy:=0x000080,		Red:=0xFF0000,    	Blue:=0x0000FF
			,Purple:=0x800080,   Teal:=0x008080,		Fuchsia:=0xFF00FF,	Aqua:=0x00FFFF
	If color is alpha
		If (%color%)
			Color:=%color%
	Color := (StrLen(Color) < 8 ? "0x" : "") . Color
	Color := ((Color&255)<<16)+(((Color>>8)&255)<<8)+(Color>>16) ; rgb -> bgr
   Return DllCall("SendMessage","UPTR",T.HWND,"UInt",TTM_SETTIPTEXTCOLOR,"UPTR",color,"UPTR",0,"UPTR")
}
TTM_SETTITLE(T,title="",icon="",Icon#=1){
   static TTM_SETTITLE = 0x400 + (A_IsUnicode ? 33 : 32)
	If icon
		If icon is not digit
			icon:=TT_GetIcon(icon,Icon#)
	T.maintitle := (StrLen(title) < 96) ? title : (Chr(133) SubStr(title, -97))
	If Icon!=
		lastIcon:=Icon
   Return DllCall("SendMessage","UPTR",T.HWND,"UInt",TTM_SETTITLE,"UPTR",icon,"UPTR",T.GetAddress("maintitle"),"UPTR"),T.UPDATE(),lastIcon:=Icon
}
TTM_SETTOOLINFO(T,pTOOLINFO=0){
   static TTM_SETTOOLINFO = A_IsUnicode?0x436:0x409
   Return DllCall("SendMessage","UPTR",T.HWND,"UInt",TTM_SETTOOLINFO,"UPTR",0,"UPTR",pTOOLINFO?pTOOLINFO:T.P[""],"UPTR")
}
TTM_SETWINDOWTHEME(T,theme=""){
   Return DllCall("SendMessage","UPTR",T.HWND,"UInt",0x200b,"UPTR",0,"UPTR",&theme,"UPTR")
}
TTM_TRACKACTIVATE(T,activate=0,pTOOLINFO=0){
   Return DllCall("SendMessage","UPTR",T.HWND,"UInt",0x411,"UPTR",activate,"UPTR",(pTOOLINFO)?(pTOOLINFO):(T.P[""]),"UPTR")
}
TTM_TRACKPOSITION(T,x=0,y=0){
	Return DllCall("SendMessage","UPTR",T.HWND,"UInt",0x412,"UPTR",0,"UPTR",(x & 0xFFFF)|(y & 0xFFFF)<<16,"UPTR")
}
TTM_UPDATE(T){
   Return DllCall("SendMessage","UPTR",T.HWND,"UInt",0x41D,"UPTR",0,"UPTR",0,"UPTR")
}
TTM_UPDATETIPTEXT(T,pTOOLINFO=0){
   static TTM_UPDATETIPTEXT = A_IsUnicode?0x439:0x40c
   Return DllCall("SendMessage","UPTR",T.HWND,"UInt",TTM_UPDATETIPTEXT,"UPTR",0,"UPTR",pTOOLINFO?pTOOLINFO:T.P[""],"UPTR")
}
TTM_WINDOWFROMPOINT(T,pPOINT){
   Return DllCall("SendMessage","UPTR",T.HWND,"UInt",0x410,"UPTR",0,"UPTR",pPOINT,"UPTR")
}