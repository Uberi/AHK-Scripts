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

class Lexer
{
    static Operators := Code.Lexer.GetOperatorTable()

    class Operator
    {
        __New(Identifier,LeftBindingPower,RightBindingPower)
        {
            this.Identifier := Identifier
            this.LeftBindingPower := LeftBindingPower
            this.RightBindingPower := RightBindingPower
        }
    }

    GetOperatorTable()
    {
        Operators := Object()
        Operators.NullDenotation := Object()
        Operators.LeftDenotation := Object()

        Operators.LeftDenotation[":="]  := new this.Operator("_assign"                 ,170 ,9)
        Operators.LeftDenotation["+="]  := new this.Operator("_assign_add"             ,170 ,9)
        Operators.LeftDenotation["-="]  := new this.Operator("_assign_subtract"        ,170 ,9)
        Operators.LeftDenotation["*="]  := new this.Operator("_assign_multiply"        ,170 ,9)
        Operators.LeftDenotation["/="]  := new this.Operator("_assign_divide"          ,170 ,9)
        Operators.LeftDenotation["//="] := new this.Operator("_assign_divide_floor"    ,170 ,9)
        Operators.LeftDenotation["%="]  := new this.Operator("_assign_remainder"       ,170 ,9)
        Operators.LeftDenotation["%%="] := new this.Operator("_assign_modulo"          ,170 ,9)
        Operators.LeftDenotation["**="] := new this.Operator("_assign_exponentiate"    ,170 ,9)
        Operators.LeftDenotation["..="]  := new this.Operator("_assign_concatenate"     ,170 ,9)
        Operators.LeftDenotation["|="]  := new this.Operator("_assign_bit_or"          ,170 ,9)
        Operators.LeftDenotation["&="]  := new this.Operator("_assign_bit_and"         ,170 ,9)
        Operators.LeftDenotation["^="]  := new this.Operator("_assign_bit_xor"         ,170 ,9)
        Operators.LeftDenotation["<<="] := new this.Operator("_assign_bit_shift_left"  ,170 ,9)
        Operators.LeftDenotation[">>="] := new this.Operator("_assign_bit_shift_right" ,170 ,9)
        Operators.LeftDenotation["||="] := new this.Operator("_assign_or"              ,170 ,9)
        Operators.LeftDenotation["&&="] := new this.Operator("_assign_and"             ,170 ,9)
        Operators.LeftDenotation["?"]   := new this.Operator("_if"                     ,20  ,19)
        Operators.LeftDenotation["||"]  := new this.Operator("_or"                     ,40  ,40)
        Operators.LeftDenotation["&&"]  := new this.Operator("_and"                    ,50  ,50)
        Operators.LeftDenotation["="]   := new this.Operator("_equals"                 ,70  ,70)
        Operators.LeftDenotation["=="]  := new this.Operator("_equals_strict"          ,70  ,70)
        Operators.LeftDenotation["!="]  := new this.Operator("_not_equals"             ,70  ,70)
        Operators.LeftDenotation["!=="] := new this.Operator("_not_equals_strict"      ,70  ,70)
        Operators.LeftDenotation[">"]   := new this.Operator("_greater_than"           ,80  ,80)
        Operators.LeftDenotation["<"]   := new this.Operator("_less_than"              ,80  ,80)
        Operators.LeftDenotation[">="]  := new this.Operator("_greater_than_or_equal"  ,80  ,80)
        Operators.LeftDenotation["<="]  := new this.Operator("_less_than_or_equal"     ,80  ,80)
        Operators.LeftDenotation[".."]  := new this.Operator("_concatenate"            ,90  ,90)
        Operators.LeftDenotation["|"]   := new this.Operator("_bit_or"                 ,100 ,100)
        Operators.LeftDenotation["^"]   := new this.Operator("_bit_exclusive_or"       ,110 ,110)
        Operators.LeftDenotation["&"]   := new this.Operator("_bit_and"                ,120 ,120)
        Operators.LeftDenotation["<<"]  := new this.Operator("_shift_left"             ,130 ,130)
        Operators.LeftDenotation[">>"]  := new this.Operator("_shift_right"            ,130 ,130)
        Operators.LeftDenotation[">>>"] := new this.Operator("_shift_right_unsigned"   ,130 ,130)
        Operators.LeftDenotation["+"]   := new this.Operator("_add"                    ,140 ,140)
        Operators.LeftDenotation["-"]   := new this.Operator("_subtract"               ,140 ,140)
        Operators.LeftDenotation["*"]   := new this.Operator("_multiply"               ,150 ,150)
        Operators.LeftDenotation["/"]   := new this.Operator("_divide"                 ,150 ,150)
        Operators.LeftDenotation["//"]  := new this.Operator("_divide_floor"           ,150 ,150)
        Operators.LeftDenotation["%"]   := new this.Operator("_remainder"              ,150 ,150)
        Operators.LeftDenotation["%%"]  := new this.Operator("_modulo"                 ,150 ,150)
        Operators.NullDenotation["!"]   := new this.Operator("_not"                    ,0   ,160)
        Operators.NullDenotation["-"]   := new this.Operator("_invert"                 ,0   ,160)
        Operators.NullDenotation["~"]   := new this.Operator("_bit_not"                ,0   ,160)
        Operators.NullDenotation["&"]   := new this.Operator("_address"                ,0   ,160)
        Operators.LeftDenotation["**"]  := new this.Operator("_exponentiate"           ,170 ,169)

        Operators.NullDenotation["("]   := new this.Operator("_evaluate"               ,0   ,0)
        Operators.LeftDenotation["("]   := new this.Operator("_call"                   ,190 ,0)
        Operators.LeftDenotation[")"]   := new this.Operator("_end"                    ,0   ,0)

        Operators.NullDenotation["{"]   := new this.Operator("_block"                  ,0   ,0)
        Operators.LeftDenotation["}"]   := new this.Operator("_block_end"              ,0   ,0)

        Operators.NullDenotation["["]   := new this.Operator("_array"                  ,0   ,0)
        Operators.LeftDenotation["["]   := new this.Operator("_subscript"              ,200 ,0)
        Operators.LeftDenotation["]"]   := new this.Operator("_subscript_end"          ,0   ,0)

        Operators.LeftDenotation["."]   := new this.Operator("_subscript_identifier"   ,200 ,200)

        ;obtain the length of the longest null denotation operator
        Operators.MaxNullLength := 0
        For Operator In Operators.NullDenotation
        {
            Length := StrLen(Operator)
            If (Length > Operators.MaxNullLength)
                Operators.MaxNullLength := Length
        }

        ;obtain the length of the longest left denotation operator
        Operators.MaxLeftLength := 0
        For Operator In Operators.LeftDenotation
        {
            Length := StrLen(Operator)
            If (Length > Operators.MaxLeftLength)
                Operators.MaxLeftLength := Length
        }

        Return, Operators
    }

    __New(Text,Position = 1)
    {
        this.Text := Text
        this.Position := Position
    }

    class Token
    {
        class OperatorNull
        {
            __New(Value,Position,Length)
            {
                this.Type := "OperatorNull"
                this.Value := Value
                this.Position := Position
                this.Length := Length
            }
        }

        class OperatorLeft
        {
            __New(Value,Position,Length)
            {
                this.Type := "OperatorLeft"
                this.Value := Value
                this.Position := Position
                this.Length := Length
            }
        }

        class Line
        {
            __New(Position,Length)
            {
                this.Type := "Line"
                this.Position := Position
                this.Length := Length
            }
        }

        class Separator
        {
            __New(Position,Length)
            {
                this.Type := "Separator"
                this.Position := Position
                this.Length := Length
            }
        }

        class Map
        {
            __New(Position,Length)
            {
                this.Type := "Map"
                this.Position := Position
                this.Length := Length
            }
        }

        class Self
        {
            __New(Position,Length)
            {
                this.Type := "Map"
                this.Position := Position
                this.Length := Length
            }
        }

        class Symbol
        {
            __New(Value,Position,Length)
            {
                this.Type := "Symbol"
                this.Value := Value
                this.Position := Position
                this.Length := Length
            }
        }

        class String
        {
            __New(Value,Position,Length)
            {
                this.Type := "String"
                this.Value := Value
                this.Position := Position
                this.Length := Length
            }
        }

        class Identifier
        {
            __New(Value,Position,Length)
            {
                this.Type := "Identifier"
                this.Value := Value
                this.Position := Position
                this.Length := Length
            }
        }

        class Number
        {
            __New(Value,Position,Length)
            {
                this.Type := "Number"
                this.Value := Value
                this.Position := Position
                this.Length := Length
            }
        }

        class Comment
        {
            __New(Value,Position,Length)
            {
                this.Type := "Comment"
                this.Value := Value
                this.Position := Position
                this.Length := Length
            }
        }
    }

    Next()
    {
        Position1 := this.Position

        this.Whitespace()

        If this.End() ;past end of text
        {
            this.Position := Position1
            Return, False
        }

        Token := this.OperatorNull()
        If Token
            Return, Token

        Token := this.OperatorLeft()
        If Token
            Return, Token

        Token := this.Line()
        If Token
            Return, Token

        Token := this.Separator()
        If Token
            Return, Token

        Token := this.Map()
        If Token
            Return, Token

        Token := this.Symbol()
        If Token
            Return, Token

        Token := this.String()
        If Token
            Return, Token

        Token := this.Identifier()
        If Token
            Return, Token

        Token := this.Number()
        If Token
            Return, Token

        Token := this.Comment()
        If Token
            Return, Token

        throw {Message: "Invalid token.", Position: this.Position, Length: 1, Location: A_ThisFunc}
    }

    OperatorNull()
    {
        Length := this.Operators.MaxNullLength
        Position1 := this.Position
        While, Length > 0
        {
            Output := this.Char(Length)
            If this.Operators.NullDenotation.HasKey(Output) ;operator found
            {
                ;if the operator ends in an identifier character, check next char: x is y -> is(x, y), x isAAA y -> x(isAAA(y))
                If !InStr("abcdefghijklmnopqrstuvwxyz_0123456789",SubStr(Output,0)) ;operator does not end in an identifier character
                    || !this.Match("abcdefghijklmnopqrstuvwxyz_0123456789") ;operator ends in an identifier character, but next character is not an identifier character
                {
                    Operator := this.Operators.NullDenotation[Output]
                    Return, new this.Token.OperatorNull(Operator,Position1,Length)
                }
            }
            this.Position := Position1
            Length --
        }
        Return, False
    }

    OperatorLeft()
    {
        Length := this.Operators.MaxLeftLength
        Position1 := this.Position
        While, Length > 0
        {
            Output := this.Char(Length)
            If this.Operators.LeftDenotation.HasKey(Output) ;operator found
            {
                ;if the operator ends in an identifier character, check next char: x is y -> is(x, y), x isAAA y -> x(isAAA(y))
                If !InStr("abcdefghijklmnopqrstuvwxyz_0123456789",SubStr(Output,0)) ;operator does not end in an identifier character
                    || !this.Match("abcdefghijklmnopqrstuvwxyz_0123456789") ;operator ends in an identifier character, but next character is not an identifier character
                {
                    Operator := this.Operators.LeftDenotation[Output]
                    Return, new this.Token.OperatorLeft(Operator,Position1,Length)
                }
            }
            this.Position := Position1
            Length --
        }
        Return, False
    }

    Symbol()
    {
        Position1 := this.Position

        If !this.Match("'") ;check for symbol character
            Return, False

        If !this.Match("abcdefghijklmnopqrstuvwxyz_0123456789",Output)
            throw {Message: "Invalid symbol.", Position: Position1, Length: 1, Location: A_ThisFunc}

        ;obtain the rest of the symbol
        While, this.Match("abcdefghijklmnopqrstuvwxyz_0123456789",CurrentChar)
            Output .= CurrentChar

        Length := this.Position - Position1
        Return, new this.Token.Symbol(Output,Position1,Length)
    }

    String()
    {
        Position1 := this.Position
        If !this.Match("""") ;check for opening quote
            Return, False

        Output := ""
        Loop
        {
            If SubStr(this.Text,this.Position,2) = "``""" ;escaped close quote
            {
                this.Position += 2
                CurrentChar := """"
            }
            Else If !this.Escape(CurrentChar) ;check for escape sequences
            {
                If this.End() ;check for end of input
                    Break
                CurrentChar := SubStr(this.Text,this.Position,1)
                this.Position ++ ;move past character
                If (CurrentChar = "`r" || CurrentChar = "`n") ;invalid string end
                    Break
                If (CurrentChar = """") ;closing quote found
                {
                    Length := this.Position - Position1
                    Return, new this.Token.String(Output,Position1,Length)
                }
            }
            Output .= CurrentChar
        }
        Length := this.Position - Position1
        throw {Message: "Invalid string.", Position: Position1, Length: Length, Location: A_ThisFunc}
    }

    Identifier()
    {
        Position1 := this.Position
        If !this.Match("abcdefghijklmnopqrstuvwxyz_",Output) ;check for identifier character
            Return, False

        ;obtain the rest of the identifier
        While, this.Match("abcdefghijklmnopqrstuvwxyz_0123456789",CurrentChar)
            Output .= CurrentChar

        Length := this.Position - Position1
        Return, new this.Token.Identifier(Output,Position1,Length)
    }

    Number()
    {
        Position1 := this.Position
        If !this.Match("0123456789",Output) ;check for numerical digits
            Return, False

        Exponent := 0
        NumberBase := 10, CharSet := "0123456789"
        If Output = 0 ;starting digit is 0
        {
            Position2 := this.Position
            CurrentChar := this.Char()
            If (CurrentChar = "x") ;hexadecimal base
                NumberBase := 16, CharSet := "0123456789ABCDEF"
            Else If (CurrentChar = "b") ;binary base
                NumberBase := 2, CharSet := "01"
            Else ;decimal base
                this.Position := Position2 ;move back to second character in number
        }

        ;check for integer digits
        Position2 := this.Position
        If (NumberBase != 10 && !this.Match(CharSet)) ;ensure there are digits after the base specifier
        {
            Length := this.Position - Position1
            throw {Message: "Invalid number.", Position: Position1, Length: Length, Location: A_ThisFunc}
        }
        this.Position := Position2 ;move back to third character in number

        ;handle integer digits of number
        While, Value := this.Match(CharSet) ;character is numeric
            Output := (Output * NumberBase) + (Value - 1)

        ;handle decimal point if present, disambiguating the decimal point from the object access operator
        Position2 := this.Position
        If this.Match(".") ;period found
        {
            If (NumberBase != 16 ;decimals should not be available in hexadecimal numbers
                && Value := this.Match(CharSet)) ;character after period is numeric
            {
                ;handle decimal digits of number
                Output := (Output * NumberBase) + (Value - 1), Exponent --
                While, Value := this.Match(CharSet) ;character is numeric
                    Output := (Output * NumberBase) + (Value - 1), Exponent --
            }
            Else ;object access operator
            {
                this.Position := Position2
                Length := this.Position - Position1
                Return, new this.Token.Number(Output,Position1,Length)
            }
        }

        Position2 := this.Position
        If (NumberBase != 16 ;exponents should not be available in hexadecimal numbers
            && this.Match("e")) ;exponent found
        {
            If this.Match("-") ;exponent is negative
                Sign := -1
            Else
                Sign := 1

            If !this.Match("0123456789",Value)
            {
                Length := this.Position - Position2
                throw {Message: "Invalid number exponent.", Position: Position2, Length: Length, Location: A_ThisFunc}
            }

            ;handle digits of the exponent
            While, CurrentChar := this.Match("0123456789")
                Value := (Value * 10) + (CurrentChar - 1)

            Exponent += Value * Sign
        }

        ;check for invalid identifier
        Position2 := this.Position
        If this.Match("abcdefghijklmnopqrstuvwxyz_")
        {
            While, this.Match("abcdefghijklmnopqrstuvwxyz_") ;parse the rest of the identifier
            {
            }
            Length := this.Position - Position2
            throw {Message: "Invalid identifier.", Position: Position2, Length: Length, Location: A_ThisFunc}
        }

        ;apply exponent
        Output *= NumberBase ** Exponent

        Length := this.Position - Position1
        Return, new this.Token.Number(Output,Position1,Length)
    }

    Line()
    {
        Position1 := this.Position

        ;check for line end
        If !this.Match("`r`n")
            Return, False

        ;move past any remaining line end characters
        this.Whitespace()
        While, this.Match("`r`n")
            this.Whitespace()

        Length := this.Position - Position1
        Return, new this.Token.Line(Position1,Length)
    }

    Separator()
    {
        Position1 := this.Position

        ;check for separator
        If !this.Match(",")
            Return, False

        Return, new this.Token.Separator(Position1,1)
    }

    Map()
    {
        Position1 := this.Position

        ;check for map
        If !this.Match(":")
            Return, False

        Return, new this.Token.Map(Position1,1)
    }

    Self()
    {
        Position1 := this.Position

        ;check for self
        If !this.Match("$")
            Return, False

        Return, new this.Token.Self(Position1,1)
    }

    Comment()
    {
        Position1 := this.Position
        If this.Match(";")
        {
            Output := ""
            Loop
            {
                Position2 := this.Position
                If this.End() ;check for end of input
                    Break
                CurrentChar := this.Char()
                If (CurrentChar = "`r" || CurrentChar = "`n")
                    Break
                Output .= CurrentChar
            }
            this.Position := Position2
            Length := this.Position - Position1
            Return, new this.Token.Comment(Output,Position1,Length)
        }
        If this.Match("/") && this.Match("*")
        {
            Output := ""
            CommentLevel := 1
            Loop
            {
                If this.End() ;check for end of input
                    Break
                CurrentChar := this.Char()
                If (CurrentChar = "/" && this.Match("*")) ;comment start
                {
                    CommentLevel ++
                    Output .= "/*"
                }
                Else If (CurrentChar = "*" && this.Match("/")) ;comment end
                {
                    CommentLevel --
                    If CommentLevel = 0 ;original comment end
                        Break
                    Output .= "*/"
                }
                Else
                    Output .= CurrentChar
            }
            Length := this.Position - Position1
            Return, new this.Token.Comment(Output,Position1,Length)
        }
        this.Position := Position1
        Return, False
    }

    Whitespace()
    {
        If !this.Match(" `t")
            Return, False

        ;move past any remaining whitespace
        While, this.Match(" `t")
        {
        }
        Return, True
    }

    End()
    {
        Return, SubStr(this.Text,this.Position,1) = ""
    }

    Char(Length = 1)
    {
        Result := ""
        Loop, %Length%
        {
            If !this.Escape(CurrentChar)
            {
                If this.End()
                    Return, ""
                CurrentChar := SubStr(this.Text,this.Position,1)
                this.Position ++
            }
            Result .= CurrentChar
        }
        Return, Result
    }

    Match(Characters,ByRef Matched = "")
    {
        Position1 := this.Position
        Matched := this.Char()
        If (Matched != "")
        {
            Index := InStr(Characters,Matched)
            If Index
                Return, Index
        }
        this.Position := Position1
        Return, False
    }

    Escape(ByRef Output)
    {
        If SubStr(this.Text,this.Position,1) != "``" ;check for escape character
            Return, False
        Position1 := this.Position
        this.Position ++ ;move past escape character

        If this.End() ;check for end of input
            throw {Message: "Invalid escape sequence.", Position: Position1, Length: 1, Location: A_ThisFunc}

        CurrentChar := SubStr(this.Text,this.Position,1) ;obtain the escaped character
        this.Position ++ ;move past escaped character

        If (CurrentChar = "`n") ;skip `n if present
            Output := ""
        Else If (CurrentChar = "`r") ;skip either `r or `r`n if present
        {
            Output := ""
            If SubStr(this.Text,this.Position,1) = "`n" ;check for newline and ignore if present
                this.Position ++
        }
        Else If (CurrentChar = "``") ;literal backtick
            Output := "``"
        Else If (CurrentChar = "r") ;literal carriage return
            Output := "`r"
        Else If (CurrentChar = "n") ;literal newline
            Output := "`n"
        Else If (CurrentChar = "t") ;literal tab
            Output := "`t"
        Else If (CurrentChar = "c") ;character code
        {
            If SubStr(this.Text,this.Position,1) = "[" ;character code start
                this.Position ++ ;move past opening square bracket
            Else
                throw {Message: "Invalid character escape sequence.", Position: Position1, Length: 2, Location: A_ThisFunc}

            CharacterCode := SubStr(this.Text,this.Position,1)
            If (CharacterCode != "" && InStr("0123456789",CharacterCode)) ;character is numeric
            {
                this.Position ++ ;move past first digit of character code
                While, (CurrentChar := SubStr(this.Text,this.Position,1)) != "" && InStr("0123456789",CurrentChar) ;character is numeric
                    CharacterCode .= CurrentChar, this.Position ++
                If (CurrentChar = "]") ;character code end
                    this.Position ++ ;move past closing square bracket
                Else ;unclosed character code
                {
                    Length := this.Position - Position1
                    throw {Message: "Invalid character escape sequence.", Position: Position1, Length: Length, Location: A_ThisFunc}
                }
                Output := Chr(CharacterCode)
            }
            Else ;invalid character code
                throw {Message: "Invalid character escape sequence.", Position: Position1, Length: 3, Location: A_ThisFunc}
        }
        Else
            throw {Message: "Invalid escape sequence.", Position: Position1, Length: 2, Location: A_ThisFunc}
        Return, True
    }
}