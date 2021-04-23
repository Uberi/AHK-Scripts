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

class Parser
{
    __New(Lexer)
    {
        this.Lexer := Lexer
    }

    class Node
    {
        class Operation
        {
            __New(Value,Parameters,Position,Length)
            {
                this.Type := "Operation"
                this.Value := Value
                this.Parameters := Parameters
                this.Position := Position
                this.Length := Length
            }
        }

        class Block
        {
            __New(Contents,Position,Length)
            {
                this.Type := "Block"
                this.Contents := Contents
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

        class Self
        {
            __New(Position,Length)
            {
                this.Type := "Self"
                this.Position := Position
                this.Length := Length
            }
        }
    }

    Parse()
    {
        this.Ignore()

        Position1 := this.Lexer.Position
        Contents := this.Lines()

        ;check for end of input
        If !this.Lexer.End() ;input still remains
            throw Exception("Invalid program end.",A_ThisFunc,this.Lexer.Position)

        Operation := new this.Node.Identifier("_evaluate",Position1,0)
        Length := this.Lexer.Position - Position1
        Return, new this.Node.Operation(Operation,Contents,Position1,Length)
    }

    Statement(RightBindingPower = 0)
    {
        ;parse either the expression or the beginning of the statement
        Position1 := this.Lexer.Position
        Operation := this.Expression(RightBindingPower)

        ;check for line end
        Position2 := this.Lexer.Position
        this.Ignore()
        If this.Lexer.Line() || this.Lexer.Separator() || this.Lexer.Map() || this.Lexer.OperatorLeft() ;not a statement, just an expression
        {
            this.Lexer.Position := Position2 ;move back to before this token
            Return, Operation
        }

        ;check for end of input
        If this.Lexer.End() ;statement not found
            Return, Operation

        Parameters := this.ParameterList()

        Length := this.Lexer.Position - Position1
        Return, new this.Node.Operation(Operation,Parameters,Position1,Length)
    }

    Expression(RightBindingPower = 0)
    {
        this.Ignore()
        LeftSide := this.NullDenotation() ;parse element that does not require left side information
        Loop
        {
            this.Ignore()
            Position1 := this.Lexer.Position
            Operator := this.Lexer.OperatorLeft()

            If !Operator ;end of input
                Break
            If Operator.Value.LeftBindingPower <= RightBindingPower ;precedence is lower than current precedence
            {
                this.Lexer.Position := Position1 ;undo parsing operator
                Break
            }

            this.Ignore()
            LeftSide := this.OperatorLeft(Operator,LeftSide) ;parse element that requires left side information
        }
        Return, LeftSide
    }

    NullDenotation()
    {
        Token := this.Lexer.OperatorNull()
        If Token
            Return, this.OperatorNull(Token)
        If this.Lexer.Line()
            Return, this.NullDenotation()
        Token := this.Lexer.Symbol()
        If Token
            Return, new this.Node.Symbol(Token.Value,Token.Position,Token.Length)
        Token := this.Lexer.Self()
        If Token
            Return, new this.Node.Self(Token.Position,Token.Length)
        Token := this.Lexer.String()
        If Token
            Return, new this.Node.String(Token.Value,Token.Position,Token.Length)
        Token := this.Lexer.Identifier()
        If Token
            Return, new this.Node.Identifier(Token.Value,Token.Position,Token.Length)
        Token := this.Lexer.Number()
        If Token
            Return, new this.Node.Number(Token.Value,Token.Position,Token.Length)
        throw Exception("Missing token.",A_ThisFunc,this.Lexer.Position)
    }

    OperatorNull(Operator)
    {
        Result := this.Evaluate(Operator)
        If Result
            Return, Result
        Result := this.Block(Operator)
        If Result
            Return, Result
        Result := this.Array(Operator)
        If Result
            Return, Result
        Return, this.Unary(Operator)
    }

    OperatorLeft(Operator,LeftSide)
    {
        Result := this.Call(Operator,LeftSide)
        If Result
            Return, Result
        Result := this.Assignment(Operator,LeftSide)
        If Result
            Return, Result
        Result := this.Subscript(Operator,LeftSide)
        If Result
            Return, Result
        Result := this.SubscriptIdentifier(Operator,LeftSide)
        If Result
            Return, Result
        Result := this.Comparison(Operator,LeftSide)
        If Result
            Return, Result
        Result := this.Ternary(Operator,LeftSide)
        If Result
            Return, Result
        Result := this.BooleanShortCircuit(Operator,LeftSide)
        If Result
            Return, Result
        Return, this.Binary(Operator,LeftSide)
    }

    Unary(Operator)
    {
        RightSide := this.Statement(Operator.Value.RightBindingPower)

        Operation := new this.Node.Identifier(Operator.Value.Identifier,Operator.Position,Operator.Length)
        Parameters := [RightSide]
        Length := this.Lexer.Position - Operator.Position
        Return, new this.Node.Operation(Operation,Parameters,Operator.Position,Length)
    }

    Binary(Operator,LeftSide)
    {
        RightSide := this.Statement(Operator.Value.RightBindingPower)

        Operation := new this.Node.Identifier(Operator.Value.Identifier,Operator.Position,Operator.Length)
        Parameters := [LeftSide,RightSide]
        Length := this.Lexer.Position - LeftSide.Position
        Return, new this.Node.Operation(Operation,Parameters,LeftSide.Position,Length)
    }

    Evaluate(Operator)
    {
        If Operator.Value.Identifier != "_evaluate"
            Return, False

        Contents := this.Lines()

        ;check for end of statements
        Position1 := this.Lexer.Position
        Token := this.Lexer.OperatorLeft()
        If !(Token && Token.Value.Identifier = "_end")
            throw Exception("Invalid statement end.",A_ThisFunc,Position1)

        Operation := new this.Node.Identifier(Operator.Value.Identifier,Operator.Position,Operator.Length)
        Length := this.Lexer.Position - Operator.Position
        Return, new this.Node.Operation(Operation,Contents,Operator.Position,Length)
    }

    Block(Operator)
    {
        If Operator.Value.Identifier != "_block"
            Return, False

        ;check for empty block
        this.Ignore()
        Position1 := this.Lexer.Position
        Token := this.Lexer.OperatorLeft()
        If Token && Token.Value.Identifier = "_block_end"
        {
            Length := this.Lexer.Position - Position1
            Return, new this.Node.Block([],Position1,Length)
        }
        this.Lexer.Position := Position1

        Contents := this.Lines()

        ;check for end of block
        Position1 := this.Lexer.Position
        Token := this.Lexer.OperatorLeft()
        If !(Token && Token.Value.Identifier = "_block_end")
            throw Exception("Invalid block end.",A_ThisFunc,Position1)

        Length := this.Lexer.Position - Position1
        Return, new this.Node.Block(Contents,Position1,Length)
    }

    Array(Operator)
    {
        If Operator.Value.Identifier != "_array"
            Return, False

        ;check for empty array
        this.Ignore()
        Position1 := this.Lexer.Position
        Token := this.Lexer.OperatorLeft()
        If Token && Token.Value.Identifier = "_subscript_end"
        {
            Operation := new this.Node.Identifier(Operator.Value.Identifier,Operator.Position,Operator.Length)
            Length := this.Lexer.Position - Operator.Position
            Return, new this.Node.Operation(Operation,[],Operator.Position,Length)
        }
        this.Lexer.Position := Position1

        Parameters := this.ParameterList()

        ;check ending bracket is present
        Position1 := this.Lexer.Position
        Token := this.Lexer.OperatorLeft()
        If !(Token && Token.Value.Identifier = "_subscript_end")
            throw Exception("Invalid array end.",A_ThisFunc,Position1)

        Operation := new this.Node.Identifier(Operator.Value.Identifier,Operator.Position,Operator.Length)
        Length := this.Lexer.Position - Operator.Position
        Return, new this.Node.Operation(Operation,Parameters,Operator.Position,Length)
    }

    Call(Operator,LeftSide)
    {
        If Operator.Value.Identifier != "_call"
            Return, False

        ;check for empty parameter list
        this.Ignore()
        Position1 := this.Lexer.Position
        Token := this.Lexer.OperatorLeft()
        If Token && Token.Value.Identifier = "_end"
        {
            Length := this.Lexer.Position - LeftSide.Position
            Return, new this.Node.Operation(LeftSide,[],LeftSide.Position,Length)
        }
        this.Lexer.Position := Position1

        Parameters := this.ParameterList()

        ;check ending parenthesis is present
        Position1 := this.Lexer.Position
        Token := this.Lexer.OperatorLeft()
        If !(Token && Token.Value.Identifier = "_end")
            throw Exception("Invalid call end.",A_ThisFunc,Position1)

        Length := this.Lexer.Position - LeftSide.Position
        Return, new this.Node.Operation(LeftSide,Parameters,LeftSide.Position,Length)
    }

    Assignment(Operator,LeftSide)
    {
        static AssignmentOperators := {_assign: True, _assign_add: True, _assign_subtract: True, _assign_multiply: True, _assign_divide_floor: True, _assign_remainder: True, _assign_modulo: True, _assign_exponentiate: True, _assign_concatenate: True, _assign_bit_or: True, _assign_bit_and: True, _assign_bit_xor: True, _assign_bit_shift_left: True, _assign_bit_shift_right: True, _assign_or: True, _assign_and: True}
        If !AssignmentOperators.HasKey(Operator.Value.Identifier)
            Return, False

        ;check for field assignment (x[y] := z)
        If LeftSide.Type = "Operation" && LeftSide.Value.Type = "Identifier" && LeftSide.Value.Value = "_subscript"
        {
            Key := LeftSide.Parameters[2]
            LeftSide := LeftSide.Parameters[1]
        }
        Else If LeftSide.Type = "Identifier"
        {
            Key := new this.Node.Symbol(LeftSide.Value,LeftSide.Position,LeftSide.Length)
            LeftSide := new this.Node.Self(0,0)
        }
        Else
            throw Exception("Invalid assignment.",A_ThisFunc,LeftSide.Position)

        RightSide := this.Statement(Operator.Value.RightBindingPower)

        Operation := new this.Node.Identifier(Operator.Value.Identifier,Operator.Position,Operator.Length)
        Parameters := [LeftSide,Key,RightSide]
        Length := this.Lexer.Position - LeftSide.Position
        Return, new this.Node.Operation(Operation,Parameters,LeftSide.Position,Length)
    }

    Subscript(Operator,LeftSide)
    {
        If Operator.Value.Identifier != "_subscript"
            Return, False

        Position1 := this.Lexer.Position
        Parameters := [LeftSide]

        Loop, 1
        {
            ;parse start index or normal subscript if present (x[ -> a], ::], ::c], :b:], :b:c], a::], a::c], a:b:], a:b:c], :], :b], a:], a:b])
            this.Ignore()
            If !this.Lexer.Map() ;start index not skipped (x[ -> a], a::], a::c], a:b:], a:b:c], a:], a:b])
            {
                Parameters[2] := this.Statement() ;obtain start index
                If !this.Lexer.Map() ;end index not specified (x[a -> ])
                {
                    Operation := new this.Node.Identifier(Operator.Value.Identifier,Operator.Position,Operator.Length)
                    Break
                }
            }

            Operation := new this.Node.Identifier("_slice",Operator.Position,Operator.Length)

            ;parse end index if present (x[*: -> :], :c], b:], b:c], ], b])
            this.Ignore()
            If !this.Lexer.Map() ;end index not skipped (x[*: -> b:], b:c], ], b])
            {
                ;check for end index
                Position2 := this.Lexer.Position
                Token := this.Lexer.OperatorLeft()
                If Token && Token.Value.Identifier = "_subscript_end" ;end of slice (x[*: -> ])
                {
                    Length := this.Lexer.Position - Operator.Position
                    Return, new this.Node.Operation(Operation,Parameters,Operator.Position,Length)
                }
                this.Lexer.Position := Position2

                ;end index specified (x[*: -> b:], b:c], b])
                Parameters[3] := this.Statement() ;obtain end index
                If !this.Lexer.Map() ;step not specified (x[*:b -> ])
                    Break
            }

            ;step not skipped (x[*:*: -> ], c])
            this.Ignore()
            Position2 := this.Lexer.Position
            Token := this.Lexer.OperatorLeft()
            this.Lexer.Position := Position2
            If !(Token && Token.Value.Identifier = "_subscript_end") ;step specified (x[*:*: -> c])
                Parameters[4] := this.Statement() ;obtain step
        }

        ;check for subscript end
        Position2 := this.Lexer.Position
        Token := this.Lexer.OperatorLeft()
        If Token && Token.Value.Identifier = "_subscript_end"
        {
            Length := this.Lexer.Position - Operator.Position
            Return, new this.Node.Operation(Operation,Parameters,Operator.Position,Length)
        }
        throw Exception("Invalid subscript end.",A_ThisFunc,Position2)
    }

    SubscriptIdentifier(Operator,LeftSide)
    {
        If Operator.Value.Identifier != "_subscript_identifier"
            Return, False

        Position1 := this.Lexer.Position
        Token := this.Lexer.Identifier()
        If !Token
            throw Exception("Invalid symbol.",A_ThisFunc,Position1)
        RightSide := new this.Node.Symbol(Token.Value,Token.Position,Token.Length)

        Operation := new this.Node.Identifier("_subscript",Operator.Position,Operator.Length)
        Parameters := [LeftSide,RightSide]
        Length := this.Lexer.Position - LeftSide.Position
        Return, new this.Node.Operation(Operation,Parameters,LeftSide.Position,Length)
    }

    Comparison(Operator,LeftSide)
    {
        static ComparisonOperators := {_equals: True, equals_strict: True, _not_equals: True, _not_equals_strict: True, _greater_than: True, _less_than: True, _greater_than_or_equal: True, _less_than_or_equal: True}
        If !ComparisonOperators.HasKey(Operator.Value.Identifier)
            Return, False

        RightSide := this.Statement(Operator.Value.RightBindingPower)

        ;parse normally if it is not a chained comparison
        Position1 := this.Lexer.Position
        Token := this.Lexer.OperatorLeft()
        this.Lexer.Position := Position1
        If !(Token && ComparisonOperators.HasKey(Token.Value.Identifier))
        {
            Operation := new this.Node.Identifier(Operator.Value.Identifier,Operator.Position,Operator.Length)
            Parameters := [LeftSide,RightSide]
            Length := this.Lexer.Position - LeftSide.Position
            Return, new this.Node.Operation(Operation,Parameters,LeftSide.Position,Length)
        }

        Comparison := new this.Node.Symbol(Operator.Value.Identifier,Operator.Position,Operator.Length)
        Parameters := [LeftSide,Comparison,RightSide]

        ;parse chained comparison if present
        Loop
        {
            Position1 := this.Lexer.Position
            Token := this.Lexer.OperatorLeft()
            If !(Token && ComparisonOperators.HasKey(Token.Value.Identifier))
                Break
            Parameters.Insert(new this.Node.Symbol(Token.Value.Identifier,Token.Position,Token.Length))
            Parameters.Insert(this.Statement(Token.Value.RightBindingPower)) ;parse the right side of the comparison
        }
        this.Lexer.Position := Position1

        Operation := new this.Node.Identifier("_compare",Operator.Position,Operator.Length)
        Length := this.Lexer.Position - LeftSide.Position
        Return, new this.Node.Operation(Operation,Parameters,LeftSide.Position,Length)
    }

    Ternary(Operator,LeftSide)
    {
        If Operator.Value.Identifier != "_if"
            Return, False

        Branch := this.Statement(Operator.RightBindingPower)
        Length := this.Lexer.Position - Branch.Position
        Branch := new this.Node.Block([Branch],Branch.Position,Length)

        Parameters := [LeftSide,Branch]
        If this.Lexer.Map() ;ternary expression
        {
            Alternative := this.Statement(Operator.RightBindingPower)
            Length := this.Lexer.Position - Alternative.Position
            Alternative := new this.Node.Block([Alternative],Alternative.Position,Length)
            Parameters.Insert(Alternative)
        }

        Operation := new this.Node.Identifier(Operator.Value.Identifier,Operator.Position,Operator.Length)
        Length := this.Lexer.Position - LeftSide.Position
        Return, new this.Node.Operation(Operation,Parameters,LeftSide.Position,Length)
    }

    BooleanShortCircuit(Operator,LeftSide)
    {
        If Operator.Value.Identifier != "_or" && Operator.Value.Identifier != "_and"
            Return, False

        RightSide := this.Statement(Operator.Value.RightBindingPower)
        Length := this.Lexer.Position - RightSide.Position
        RightSide := new this.Node.Block([RightSide],RightSide.Position,Length)

        Operation := new this.Node.Identifier(Operator.Value.Identifier,Operator.Position,Operator.Length)
        Parameters := [LeftSide,RightSide]
        Length := this.Lexer.Position - LeftSide.Position
        Return, new this.Node.Operation(Operation,Parameters,LeftSide.Position,Length)
    }

    Ignore()
    {
        Loop
        {
            If !(this.Lexer.Whitespace() || this.Lexer.Comment())
                Break
        }
    }

    Lines()
    {
        Contents := []
        Loop
        {
            Contents.Insert(this.Statement())
            If !this.Lexer.Line() || this.Lexer.End()
                Break
        }
        Return, Contents
    }

    ParameterList()
    {
        Parameters := []
        Index := 1
        Loop
        {
            ;parse a parameter
            Value := this.Statement()

            If this.Lexer.Map() ;named parameter
                Parameters[Value] := this.Statement()
            Else ;ordered parameter
            {
                Parameters[Index] := Value
                Index ++
            }

            If this.Lexer.Separator() ;parameters remain
            {
                ;check for skipped parameters (e.g., x,,y)
                Loop
                {
                    this.Ignore()
                    If !this.Lexer.Separator() ;end of skipped parameters
                        Break
                    Index ++ ;move past parameter index
                }
            }
            Else ;end of parameters
                Break
        }
        Return, Parameters
    }
}