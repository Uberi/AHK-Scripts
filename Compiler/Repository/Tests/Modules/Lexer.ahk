#NoEnv

/*
Copyright 2011-2013 Anthony Zhang <azhang9@gmail.com>

This file is part of Autonomy. Source code is available at <https://github.com/Uberi/Autonomy>.

Autonomy is free software: you can redistribute it and/or modify
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

class Category_Lexer
{
    class Category_OperatorNull
    {
        Test_Blank()
        {
            l := new Code.Lexer("")
            Tests.LexerTest(l,l.OperatorNull(),False,1)
        }

        Test_Invalid()
        {
            l := new Code.Lexer("@")
            Tests.LexerTest(l,l.OperatorNull(),False,1)
        }

        Test_InputEnd()
        {
            l := new Code.Lexer("!")
            Tests.LexerTest(l,l.OperatorNull(),new Code.Lexer.Token.OperatorNull(Code.Lexer.Operators.NullDenotation["!"],1,1),2)
        }

        Test_Simple()
        {
            l := new Code.Lexer("!`n")
            Tests.LexerTest(l,l.OperatorNull(),new Code.Lexer.Token.OperatorNull(Code.Lexer.Operators.NullDenotation["!"],1,1),2)
        }
    }

    class Category_OperatorLeft
    {
        Test_Blank()
        {
            l := new Code.Lexer("")
            Tests.LexerTest(l,l.OperatorLeft(),False,1)
        }

        Test_Invalid()
        {
            l := new Code.Lexer("@")
            Tests.LexerTest(l,l.OperatorLeft(),False,1)
        }

        Test_InputEnd()
        {
            l := new Code.Lexer("+")
            Tests.LexerTest(l,l.OperatorLeft(),new Code.Lexer.Token.OperatorLeft(Code.Lexer.Operators.LeftDenotation["+"],1,1),2)
        }

        Test_Simple()
        {
            l := new Code.Lexer("+`n")
            Tests.LexerTest(l,l.OperatorLeft(),new Code.Lexer.Token.OperatorLeft(Code.Lexer.Operators.LeftDenotation["+"],1,1),2)
        }
    }

    class Category_Symbol
    {
        Test_Blank()
        {
            l := new Code.Lexer("")
            Tests.LexerTest(l,l.Symbol(),False,1)
        }

        Test_Invalid()
        {
            l := new Code.Lexer("@")
            Tests.LexerTest(l,l.Symbol(),False,1)
        }

        Test_InvalidChar()
        {
            l := new Code.Lexer("'@")
            try l.Symbol()
            catch e
            {
                Tests.LexerTestException(e,"Invalid symbol.","Code.Lexer.Symbol",1,1)
                Return
            }
            throw "Invalid error."
        }

        Test_InputEnd()
        {
            l := new Code.Lexer("'abc")
            Tests.LexerTest(l,l.Symbol(),new Code.Lexer.Token.Symbol("abc",1,4),5)
        }

        Test_Simple()
        {
            l := new Code.Lexer("'abc`n")
            Tests.LexerTest(l,l.Symbol(),new Code.Lexer.Token.Symbol("abc",1,4),5)
        }

        Test_Numeric()
        {
            l := new Code.Lexer("'123abc`n")
            Tests.LexerTest(l,l.Symbol(),new Code.Lexer.Token.Symbol("123abc",1,7),8)
        }
    }

    class Category_String
    {
        Test_Blank()
        {
            l := new Code.Lexer("")
            Tests.LexerTest(l,l.String(),False,1)
        }

        Test_Invalid()
        {
            l := new Code.Lexer("$")
            Tests.LexerTest(l,l.String(),False,1)
        }

        Test_InputEnd()
        {
            l := new Code.Lexer("""Hello, world!")
            try l.String()
            catch e
            {
                Tests.LexerTestException(e,"Invalid string.","Code.Lexer.String",1,14)
                Return
            }
            throw "Invalid error."
        }

        Test_Unclosed()
        {
            l := new Code.Lexer("""Hello, world!`nmore text")
            try l.String()
            catch e
            {
                Tests.LexerTestException(e,"Invalid string.","Code.Lexer.String",1)
                Return
            }
            throw "Invalid error."
        }

        Test_Empty()
        {
            l := new Code.Lexer("""""")
            Tests.LexerTest(l,l.String(),new Code.Lexer.Token.String("",1,2),3)
        }

        Test_Simple()
        {
            l := new Code.Lexer("""Hello, world!""")
            Tests.LexerTest(l,l.String(),new Code.Lexer.Token.String("Hello, world!",1,15),16)
        }

        class Category_Escape
        {
            Test_InvalidCharacter()
            {
                l := new Code.Lexer("""``w""")
                try l.String()
                catch e
                {
                    Tests.LexerTestException(e,"Invalid escape sequence.","Code.Lexer.Escape",2,2)
                    Return
                }
                throw "Invalid error."
            }

            Test_InvalidCode()
            {
                l := new Code.Lexer("""``c[""")
                try l.String()
                catch e
                {
                    Tests.LexerTestException(e,"Invalid character escape sequence.","Code.Lexer.Escape",2,3)
                    Return
                }
                throw "Invalid error."
            }

            Test_Character()
            {
                l := new Code.Lexer("""escaped```` ``""quote``"" and``ttab``n""")
                Tests.LexerTest(l,l.String(),new Code.Lexer.Token.String("escaped`` ""quote"" and`ttab`n",1,32),33)
            }

            Test_Code()
            {
                l := new Code.Lexer("""``c[32]``c[97]123``c[102]""")
                Tests.LexerTest(l,l.String(),new Code.Lexer.Token.String(" a123f",1,24),25)
            }

            Test_Newline()
            {
                l := new Code.Lexer("""line 1```r`nline 2```rline 3```nline 4""")
                Tests.LexerTest(l,l.String(),new Code.Lexer.Token.String("line 1line 2line 3line 4",1,33),34)
            }
        }
    }

    class Category_Identifier
    {
        Test_Blank()
        {
            l := new Code.Lexer("")
            Tests.LexerTest(l,l.Identifier(),False,1)
        }

        Test_Invalid()
        {
            l := new Code.Lexer("@")
            Tests.LexerTest(l,l.Identifier(),False,1)
        }

        Test_InputEnd()
        {
            l := new Code.Lexer("abc")
            Tests.LexerTest(l,l.Identifier(),new Code.Lexer.Token.Identifier("abc",1,3),4)
        }

        Test_Simple()
        {
            l := new Code.Lexer("abc`n")
            Tests.LexerTest(l,l.Identifier(),new Code.Lexer.Token.Identifier("abc",1,3),4)
        }
    }

    class Category_Number
    {
        Test_Blank()
        {
            l := new Code.Lexer("")
            Tests.LexerTest(l,l.Number(),False,1)
        }

        Test_Invalid()
        {
            l := new Code.Lexer("@")
            If !Equal(l.Number(),False)
                throw "Invalid output."
            If l.Position != 1
                throw "Invalid position."
            Tests.LexerTest(l,l.Number(),False,1)
        }

        Test_Simple()
        {
            l := new Code.Lexer("123")
            Tests.LexerTest(l,l.Number(),new Code.Lexer.Token.Number(123,1,3),4)
        }

        Test_ObjectAccess()
        {
            l := new Code.Lexer("123.property")
            Tests.LexerTest(l,l.Number(),new Code.Lexer.Token.Number(123,1,3),4)
        }

        Test_Base()
        {
            l := new Code.Lexer("0xBE4")
            Tests.LexerTest(l,l.Number(),new Code.Lexer.Token.Number(0xBE4,1,5),6)
        }

        Test_Decimal()
        {
            l := new Code.Lexer("123.456")
            Tests.LexerTest(l,l.Number(),new Code.Lexer.Token.Number(123.456,1,7),8)
        }

        Test_Exponent()
        {
            l := new Code.Lexer("123e4")
            Tests.LexerTest(l,l.Number(),new Code.Lexer.Token.Number(1230000,1,5),6)
        }

        Test_BaseDecimal()
        {
            l := new Code.Lexer("0b101.011")
            Tests.LexerTest(l,l.Number(),new Code.Lexer.Token.Number(5.375,1,9),10)
        }

        Test_ExponentDecimal()
        {
            l := new Code.Lexer("123.456e4")
            Tests.LexerTest(l,l.Number(),new Code.Lexer.Token.Number(1234560,1,9),10)
        }

        Test_BaseExponent()
        {
            l := new Code.Lexer("0b1e4")
            Tests.LexerTest(l,l.Number(),new Code.Lexer.Token.Number(16,1,5),6)
        }

        Test_BaseExponentDecimal()
        {
            l := new Code.Lexer("0b101.011e4")
            Tests.LexerTest(l,l.Number(),new Code.Lexer.Token.Number(86,1,11),12)
        }
    }

    class Category_Line
    {
        Test_Blank()
        {
            l := new Code.Lexer("")
            Tests.LexerTest(l,l.Line(),False,1)
        }

        Test_Invalid()
        {
            l := new Code.Lexer("@")
            Tests.LexerTest(l,l.Line(),False,1)
        }

        Test_InputEnd()
        {
            l := new Code.Lexer("`r`n")
            Tests.LexerTest(l,l.Line(),new Code.Lexer.Token.Line(1,2),3)
        }

        Test_Simple()
        {
            l := new Code.Lexer("`r`nabc")
            Tests.LexerTest(l,l.Line(),new Code.Lexer.Token.Line(1,2),3)
        }
    }

    class Category_Separator
    {
        Test_Blank()
        {
            l := new Code.Lexer("")
            Tests.LexerTest(l,l.Separator(),False,1)
        }

        Test_Invalid()
        {
            l := new Code.Lexer("@")
            Tests.LexerTest(l,l.Separator(),False,1)
        }

        Test_InputEnd()
        {
            l := new Code.Lexer(",")
            Tests.LexerTest(l,l.Separator(),new Code.Lexer.Token.Separator(1,1),2)
        }

        Test_Simple()
        {
            l := new Code.Lexer(",`n")
            Tests.LexerTest(l,l.Separator(),new Code.Lexer.Token.Separator(1,1),2)
        }
    }

    class Category_Map
    {
        Test_Blank()
        {
            l := new Code.Lexer("")
            Tests.LexerTest(l,l.Map(),False,1)
        }

        Test_Invalid()
        {
            l := new Code.Lexer("@")
            Tests.LexerTest(l,l.Map(),False,1)
        }

        Test_InputEnd()
        {
            l := new Code.Lexer(":")
            Tests.LexerTest(l,l.Map(),new Code.Lexer.Token.Map(1,1),2)
        }

        Test_Simple()
        {
            l := new Code.Lexer(":`n")
            Tests.LexerTest(l,l.Map(),new Code.Lexer.Token.Map(1,1),2)
        }
    }

    class Category_Comment
    {
        Test_Blank()
        {
            l := new Code.Lexer("")
            Tests.LexerTest(l,l.Comment(),False,1)
        }

        Test_Invalid()
        {
            l := new Code.Lexer("@")
            Tests.LexerTest(l,l.Comment(),False,1)
        }

        class Category_SingleLine
        {
            Test_InputEnd()
            {
                l := new Code.Lexer(";test")
                Tests.LexerTest(l,l.Comment(),new Code.Lexer.Token.Comment("test",1,5),6)
            }

            Test_Simple()
            {
                l := new Code.Lexer(";test`n")
                Tests.LexerTest(l,l.Comment(),new Code.Lexer.Token.Comment("test",1,5),6)
            }
        }

        class Category_Multiline
        {
            Test_InputEnd()
            {
                l := new Code.Lexer("/*test")
                Tests.LexerTest(l,l.Comment(),new Code.Lexer.Token.Comment("test",1,6),7)
            }

            Test_Simple()
            {
                l := new Code.Lexer("/*test*/")
                Tests.LexerTest(l,l.Comment(),new Code.Lexer.Token.Comment("test",1,8),9)
            }

            Test_Nested()
            {
                l := new Code.Lexer("/*/**/*/")
                Tests.LexerTest(l,l.Comment(),new Code.Lexer.Token.Comment("/**/",1,8),9)
            }
        }
    }

    class Category_End
    {
        Test_Simple()
        {
            l := new Code.Lexer("")
            If !l.End()
                throw "Invalid output."
            If l.Position != 1
                throw "Invalid position."
        }

        Test_Negative()
        {
            l := new Code.Lexer("abc")
            If l.End()
                throw "Invalid output."
            If l.Position != 1
                throw "Invalid position."
        }
    }
}

LexerTest(Lexer,Result,Value,Position)
{
    If !Equal(Result,Value)
        throw "Invalid output."
    If Lexer.Position != Position
        throw "Invalid position."
}

LexerTestException(Result,Message,Location,Position,Length)
{
    If Result.Message != Message
        throw "Invalid error message."
    If Result.Location != Location
        throw "Invalid error location."
    If Result.Position != Position
        throw "Invalid error position."
    If Result.Length != Length
        throw "Invalid error length."
}