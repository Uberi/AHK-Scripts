#NoEnv

;wip: exceptions on failure

Number := new BigInteger("FADD",16)
MsgBox % DumpInteger(Number)

DumpInteger(Integer)
{
    Result := ""
    For Index, Value In Integer.Data
        Result .= Index . ": " . Value . "`n"
    Return, SubStr(Result,1,-1)
}

class BigInteger
{
    __New(Number = "0",Base = 10)
    {
        this.Data := [0]
        this.Sign := 1 ;wip: process signs in methods

        CharSet := "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        Loop, Parse, Number
            this.Multiply(Base).Add(InStr(CharSet,A_LoopField) - 1)
    }

    ToString(Base = 10)
    {
        CharSet := "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        Loop, Parse, Number
        {
            ;wip: base conversion code here
        }
    }

    ToInteger()
    {
        
    }

    Add(Number)
    {
        If IsObject(Number) ;big integer object
        {
            Loop
            {
                
            }
        }
        Else If Number Is Integer
        {
            Overflow := Number
            Loop
            {
                If Overflow = 0 ;no more overflow propogation needed
                    Break
                Sum := ObjHasKey(this.Data,A_Index) ? (this.Data[A_Index] + Overflow) : Overflow ;calculate the sum of the numbers
                this.Data[A_Index] := Sum & 0xFFFFFFFF ;store the sum modulo the base in the big integer
                Overflow := Sum // 0x100000000 ;store the the sum divided by the base as the overflow
            }
        }
        Else
            Throw Exception("Invalid number: """ . Number . """.",-1)
        Return, this
    }

    Subtract(Number)
    {
        Return, this
    }

    Multiply(Number)
    {
        If IsObject(Number) ;big integer object
        {
            
        }
        Else If Number Is Integer
        {
            Overflow := 0
            While, A_Index <= ObjMaxIndex(this.Data) || Overflow ;number of sections
            {
                Sum := (ObjHasKey(this.Data,A_Index) ? ((this.Data[A_Index] * Number) + Overflow) : Overflow) ;calculate the product of the numbers
                this.Data[A_Index] := Sum & 0xFFFFFFFF ;store the sum modulo the base in the big integer
                Overflow := Sum // 0x100000000 ;store the the sum divided by the base as the overflow
            }
        }
        Else
            Throw Exception("Invalid number: """ . Number . """.",-1)
        Return, this
    }

    Divide(Number)
    {
        Return, this
    }

    Exponentiate(Number)
    {
        If IsObject(Number) ;big integer object
        {
            
        }
        Else If Number Is Integer
        {
            Result := new BigInteger("1")
            While, Number != 0
            {
                If Number & 1 ;odd number
                    Result.Multiply(this)
                Number >>= 1
                this.Multiply(this)
            }
            this := Result ;wip: not working
        }
        Return, this
    }

    Equal(Number)
    {
        
    }

    Greater(Number)
    {
        
    }

    Lesser(Number)
    {
        
    }

    GreaterOrEqual(Number)
    {
        
    }

    LesserOrEqual(Number)
    {
        
    }
}