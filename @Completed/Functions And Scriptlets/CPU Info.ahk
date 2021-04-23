;AHK v1
#NoEnv

;MsgBox % CPUInfo()

CPUInfo()
{
 /*
 0 = Vendor ID
 1 = Processor Info and Feature Bits
 2 = Cache and TLB Descriptor Info
 3 = Processor Serial Number
 0x80000000 = Get Highest Extended Function Supported
 0x80000001 = Extended Processor Info and Feature Bits
 0x80000002, 0x80000003, 0x80000004 = Processor Brand String
 */
 Hex := "538B4424080FA2508B44241489188B44241889088B44241C89105B8B44240C89185BC3"
 VarSetCapacity(CPUID,35), Position := 1
 Loop, 35
  NumPut("0x" . SubStr(Hex,Position,2),CPUID,Position >> 1,"Char"), Position += 2
 VarSetCapacity(Var1,4,0), VarSetCapacity(Var2,4,0), VarSetCapacity(Var3,4,0), VarSetCapacity(Var4,4,0)
 DllCall(&CPUID,"UInt",0,"Str",Var1,"Str",Var2,"Str",Var3,"Str",Var4,"CDecl")
 If A_IsUnicode
  StrGetFunc := "StrGet", Var2 := %StrGetFunc%(&Var2,4,"CP0"), Var3 := %StrGetFunc%(&Var3,4,"CP0"), Var4 := %StrGetFunc%(&Var4,4,"CP0")
 Result := Var2 . Var4 . Var3 . "`n"
 FormatInteger := A_FormatInteger
 SetFormat, IntegerFast, Hex
 DllCall(&CPUID,"UInt",1,"UInt*",Var1,"UInt*",Var2,"UInt*",Var3,"UInt*",Var4,"CDecl"), Result .= Var1 . "," . Var2 . "," . Var3 . "," . Var4 . "`n"
 DllCall(&CPUID,"UInt",2,"UInt*",Var1,"UInt*",Var2,"UInt*",Var3,"UInt*",Var4,"CDecl"), Result .= Var1 . "," . Var2 . "," . Var3 . "," . Var4 . "`n"
 DllCall(&CPUID,"UInt",3,"UInt*",Var1,"UInt*",Var2,"UInt*",Var3,"UInt*",Var4,"CDecl"), Result .= Var1 . "," . Var2 . "," . Var3 . "," . Var4 . "`n"
 DllCall(&CPUID,"UInt",0x80000000,"UInt*",Var1,"UInt*",Var2,"UInt*",Var3,"UInt*",Var4,"CDecl"), Result .= Var1 . "," . Var2 . "," . Var3 . "," . Var4 . "`n"
 DllCall(&CPUID,"UInt",0x80000001,"UInt*",Var1,"UInt*",Var2,"UInt*",Var3,"UInt*",Var4,"CDecl"), Result .= Var1 . "," . Var2 . "," . Var3 . "," . Var4 . "`n"
 SetFormat, IntegerFast, %FormatInteger%
 VarSetCapacity(Var1,4,0), VarSetCapacity(Var2,4,0), VarSetCapacity(Var3,4,0), VarSetCapacity(Var4,4,0)
 DllCall(&CPUID,"UInt",0x80000002,"Str",Var1,"Str",Var2,"Str",Var3,"Str",Var4,"CDecl")
 If A_IsUnicode
  Var1 := %StrGetFunc%(&Var1,4,"CP0"), Var2 := %StrGetFunc%(&Var2,4,"CP0"), Var3 := %StrGetFunc%(&Var3,4,"CP0"), Var4 := %StrGetFunc%(&Var4,4,"CP0")
 Result .= Var1 . Var2 . Var3 . Var4
 DllCall(&CPUID,"UInt",0x80000003,"Str",Var1,"Str",Var2,"Str",Var3,"Str",Var4,"CDecl")
 If A_IsUnicode
  Var1 := %StrGetFunc%(&Var1,4,"CP0"), Var2 := %StrGetFunc%(&Var2,4,"CP0"), Var3 := %StrGetFunc%(&Var3,4,"CP0"), Var4 := %StrGetFunc%(&Var4,4,"CP0")
 Result .= Var1 . Var2 . Var3 . Var4
 DllCall(&CPUID,"UInt",0x80000004,"Str",Var1,"Str",Var2,"Str",Var3,"Str",Var4,"CDecl")
 If A_IsUnicode
  Var1 := %StrGetFunc%(&Var1,4,"CP0"), Var2 := %StrGetFunc%(&Var2,4,"CP0"), Var3 := %StrGetFunc%(&Var3,4,"CP0"), Var4 := %StrGetFunc%(&Var4,4,"CP0")
 Result .= Var1 . Var2 . Var3 . Var4
 Return, Result
}