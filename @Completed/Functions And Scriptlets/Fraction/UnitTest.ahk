#NoEnv

/*
Copyright 2013 Anthony Zhang <azhang9@gmail.com>

This file is part of Fraction.ahk. Source code is available at <https://github.com/Uberi/Fraction.ahk>.

Fraction.ahk is free software: you can redistribute it and/or modify
it under the terms of the GNU Affero General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Affero General Public License for more details.

You should have received a copy of the GNU Affero General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

If TestFraction.Run(Pass,Fail)
    MsgBox, All tests passed.
Else
{
    Result := ""
    For Index, Name In Fail
        Result .= "`n" . Name
    MsgBox, Some tests failed:`n%Result%
}

#Include %A_ScriptDir%\Fraction.ahk

class TestFraction
{
    _Create()
    {
        f := new Fraction(-3,-2)
        Return, this.Check(f,3,2)
    }

    _Fast()
    {
        f := new Fraction
        f.Fast().Set(5,10)
        Return, this.Check(f,5,10)
    }

    _Reduce()
    {
        f := new Fraction(45,-9)
        t := f.Reduce()
        Return, this.Check(t,-5,1)
    }

    _Set()
    {
        f := new Fraction
        Return, this.Check(f.Set(4,-7),-4,7)
    }

    _FromNumber()
    {
        f := new Fraction
        Return, this.Check(f.Set(-0.457),-69,151)
    }

    _FromString()
    {
        f := new Fraction
        Return, this.Check(f.Set("  -45  /  -7   "),45,7)
    }

    _ToNumber()
    {
        f := new Fraction(5,4)
        Return, f.ToNumber() = 1.25
    }

    _ToString()
    {
        f := new Fraction(3,-2)
        Return, f.ToString() = "-3/2"
    }

    _Equal()
    {
        f := new Fraction(5,-6)
        Return, f.Equal(new Fraction(-20,24))
    }

    _Less()
    {
        f := new Fraction(-1,7)
        Return, f.Less(new Fraction(4,3))
    }

    _LessOrEqual()
    {
        f := new Fraction(5,-7)
        Return, f.Less(new Fraction(-2,3))
    }

    _Greater()
    {
        f := new Fraction(1,-6)
        Return, f.Greater(new Fraction(-2,3))
    }

    _GreaterOrEqual()
    {
        f := new Fraction(7,9)
        Return, f.GreaterOrEqual(new Fraction(4,10))
    }

    _Sign()
    {
        f := new Fraction(-1,-2)
        Return, f.Sign() = 1
    }

    _Abs()
    {
        f := new Fraction(9,-6)
        Return, this.Check(f.Abs(),3,2)
    }

    _Add()
    {
        f := new Fraction(7,6)
        Return, this.Check(f.Add(new Fraction(4,9)),29,18)
    }

    _Subtract()
    {
        f := new Fraction(7,4)
        Return, this.Check(f.Subtract(new Fraction(2,5)),27,20)
    }

    _Multiply()
    {
        f := new Fraction(5,2)
        Return, this.Check(f.Divide(new Fraction(4,3)),15,8)
    }

    _Divide()
    {
        f := new Fraction(2,6)
        Return, this.Check(f.Divide(new Fraction(7,5)),5,21)
    }

    _Remainder()
    {
        f := new Fraction(5,-3)
        t := f.Remainder(new Fraction(-3,2))
        Return, this.Check(t,-1,6)
    }

    _Exponentiate()
    {
        f := new Fraction(-4,-2)
        t := f.Exponentiate(3)
        Return, this.Check(t,8,1)
    }

    _GCD()
    {
        f := new Fraction(-3,4)
        t := f.GCD(new Fraction(21,23))
        Return, this.Check(t,3,92)
    }

    _LCM()
    {
        f := new Fraction(4,-3)
        t := f.LCM(new Fraction(-2,7))
        Return, this.Check(t,4,1)
    }

    Check(Value,Numerator,Denominator)
    {
        Return, Value.Numerator = Numerator && Value.Denominator = Denominator
    }

    Run(ByRef Pass,ByRef Fail)
    {
        Pass := []
        Fail := []
        For Name, Test In this
        {
            If IsFunc(Test) && SubStr(Name,1,1) = "_"
            {
                Result := Test.(this)
                If Result
                    Pass.Insert(Name)
                Else
                    Fail.Insert(Name)
            }
        }
        Return, !Fail.MaxIndex()
    }
}