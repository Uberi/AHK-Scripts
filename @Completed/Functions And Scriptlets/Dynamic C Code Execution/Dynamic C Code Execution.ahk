#NoEnv

/*
CProgram = main(){char*_result`;strcpy(_result,"Hello World")`;}
MsgBox % ExecuteCCode(CProgram)

Int = 101
CProgram = ;floating point support
(
#include <math.h>
double f(double x) { return sqrt(x); }
main()
{
  char* _result; // needed to export the result
  int i = %Int%;   // AHK varible reference %Int%
  sprintf(_result,"f(`%u) --> `%0.17g",i,f(i));
}
)
MsgBox % ExecuteCCode(CProgram)

Hex = 0x12345678
CProgram = ;assembler support
(
typedef unsigned long UInt32;

UInt32 BSWAP(UInt32 x)
{
  __asm__("bswap `%0" : "=r" (x) : "0" (x));
  return x;
}

main()
{
  char* _result;
  sprintf(_result,"ByteSwap of `%x = `%x",%Hex%,BSWAP(%Hex%));
}
)
MsgBox % ExecuteCCode(CProgram)
*/

ExecuteCCode(ByRef CProgram,LibraryPath = "",ResultLen = 999)
{
 LibraryPath := (LibraryPath = "") ? A_ScriptDir . "\TCC" : LibraryPath, hModule := DllCall("LoadLibrary","Str",LibraryPath . "\lib\libtcc.dll"), hModule <> 0 ? (Context := DllCall("libtcc\tcc_new","Cdecl UInt"), DllCall("libtcc\tcc_add_sysinclude_path","UInt",Context,"Str",LibraryPath . "\include", "Cdecl UInt"), DllCall("libtcc\tcc_add_library_path","UInt",Context,"Str",LibraryPath . "\lib", "Cdecl UInt"), VarSetCapacity(Result,ResultLen), (DllCall("libtcc\tcc_compile_string","UInt",Context,"Str",RegExReplace(CProgram,"S)(char\s*\*\s*_result)[^;]*","$1 = " . &Result),"Cdecl UInt") || ErrorLevel) ? Result := -1 : DllCall("libtcc\tcc_run","UInt",Context,"Cdecl UInt"), DllCall("libtcc\tcc_delete","UInt",Context,"Cdecl"), DllCall("FreeLibrary","UInt",hModule), VarSetCapacity(Result,-1)) : Result := -1
 Return, Result
}