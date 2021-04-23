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

/*
Bytecode format
---------------

Stack based virtual machine implementing a few simple instructions:

label value                     label definition for a location in the bytecode.

push value                      pushes a value onto the stack.

call parameter_count            pops and stores the jump target.
                                pushes the parameter count onto the stack.
                                pushes the current stack base onto the stack.
                                pushes the current instruction index onto the stack.
                                jumps to the stored jump target.

return                          pops the return value off of the stack and stores it.
                                pops the intruction index off of the stack and stores it.
                                pops the stack base off of the stack and stores it.
                                pops the parameter count off of the stack.
                                pops the parameters off of the stack.
                                jumps to the stored instruction index.
                                sets the stack base to the stored stack base.
                                pushes the return value back onto the stack.

jump                            pops the jump target off of the stack.
                                jumps to the stored jump target.

;wip: generated identifiers are not globally unique
;wip: distinct Array type using contiguous memory, faster than Object hash table implementation
;wip: dead/unreachable code elimination
*/

/*
class Bytecoder ;register based bytecode generator
{
    __New()
    {
        this.NameIndex := 1
        this.LabelIndex := 1
    }

    Convert(Tree)
    {
        Result := []
        If Tree.Type = "Operation"
        {
            Result := this.Convert(Tree.Value)
            Operation := "@invoke $" . this.NameIndex
            For Index, Parameter In Tree.Parameters
            {
                For Index, Value In this.Convert(Parameter)
                    Result.Insert(Value)
                Operation .= " $" . this.NameIndex
            }
            Operation := "$" . this.NameIndex . " = " . Operation, this.NameIndex ++
            Result.Insert(Operation)
            Return, Result
        }
        Else If Tree.Type = "Block"
        {
            BlockLabel := ":" . this.LabelIndex, this.LabelIndex ++
            TargetLabel := ":" . this.LabelIndex, this.LabelIndex ++

            Result := ["@jump " . TargetLabel,"@label " . BlockLabel]
            For Index, Node In Tree.Contents
            {
                For Index, Value In this.Convert(Node)
                    Result.Insert(Value)
            }
            Result.Insert("@label " . TargetLabel)
            Result.Insert("$" . this.NameIndex . " = " . BlockLabel), this.NameIndex ++
        }
        Else If Tree.Type = "Symbol"
            Result := ["$" . this.NameIndex . " = '" . Tree.Value], this.NameIndex ++
        Else If Tree.Type = "String"
            Result := ["$" . this.NameIndex . " = """ . Tree.Value . """"], this.NameIndex ++ ;wip: do escaping
        Else If Tree.Type = "Identifier"
            Result := ["$" . this.NameIndex . " = $" . Tree.Value], this.NameIndex ++
        Else If Tree.Type = "Number"
            Result := ["$" . this.NameIndex . " = #" . Tree.Value], this.NameIndex ++
        Return, Result
    }
}
*/

;/*
class Bytecoder ;stack based bytecode generator
{
    __New()
    {
        this.LabelCounter := 0
    }

    class Code
    {
        class Label
        {
            __New(Value,Position,Length)
            {
                this.Identifier := "Label"
                this.Value := Value
                this.Position := Position
                this.Length := Length
            }
        }

        class Jump
        {
            __New(Position,Length)
            {
                this.Identifier := "Jump"
                this.Position := Position
                this.Length := Length
            }
        }

        class Return
        {
            __New(Position,Length)
            {
                this.Identifier := "Return"
                this.Position := Position
                this.Length := Length
            }
        }

        class Call
        {
            __New(ParameterCount,Position,Length)
            {
                this.Identifier := "Call"
                this.Count := ParameterCount
                this.Position := Position
                this.Length := Length
            }
        }

        class Push
        {
            __New(Type,Value,Position,Length)
            {
                this.Identifier := "Push"
                this.Type := Type
                this.Value := Value
                this.Position := Position
                this.Length := Length
            }
        }

        class Load
        {
            __New(Value,Position,Length)
            {
                this.Identifier := "Load"
                this.Value := Value
                this.Position := Position
                this.Length := Length
            }
        }
    }

    Convert(Tree,Labels = "")
    {
        If !IsObject(Labels)
            Labels := []

        Result := this.Operation(Tree)
        If Result
            Return, Result
        Result := this.Block(Tree)
        If Result
            Return, Result
        Result := this.Symbol(Tree)
        If Result
            Return, Result
        Result := this.Self(Tree)
        If Result
            Return, Result
        Result := this.String(Tree)
        If Result
            Return, Result
        Result := this.Identifier(Tree)
        If Result
            Return, Result
        Result := this.Number(Tree)
        If Result
            Return, Result

        throw Exception("Unknown tree node type.",A_ThisFunc)
    }

    Operation(Tree)
    {
        If Tree.Type != "Operation"
            Return, False

        Result := []

        ReturnLabel := new this.Code.Label(this.LabelCounter,Tree.Position,Tree.Length)
        this.LabelCounter ++

        Result.Insert(new this.Code.Push("Label",ReturnLabel.Value,0,0)) ;wip: position and length

        ParameterCount := 0
        For Index, Parameter In Tree.Parameters
        {
            ParameterCount ++
            For Index, Node In this.Convert(Parameter)
                Result.Insert(Node)
        }

        For Index, Node In this.Convert(Tree.Value)
            Result.Insert(Node)

        Result.Insert(new this.Code.Call(ParameterCount,Tree.Position,Tree.Length))
        Result.Insert(ReturnLabel)

        Return, Result
    }

    Block(Tree)
    {
        If Tree.Type != "Block"
            Return, False

        Result := []

        BlockLabel := new this.Code.Label(this.LabelCounter,Tree.Position,Tree.Length)
        this.LabelCounter ++
        TargetLabel := new this.Code.Label(this.LabelCounter,0,0) ;wip: position and length
        this.LabelCounter ++

        ;skip over the block body in block literals
        Result.Insert(new this.Code.Push("Label",TargetLabel.Value,0,0)) ;wip: position and length
        Result.Insert(new this.Code.Jump(0,0)) ;wip: position and length

        ;start of block
        Result.Insert(BlockLabel)

        ;block body
        For Index, Content In Tree.Contents
        {
            For Index, Node In this.Convert(Content)
                Result.Insert(Node)
        }

        ;place block onto stack
        Result.Insert(new this.Code.Return(0,0)) ;wip: position and length
        Result.Insert(TargetLabel)
        Result.Insert(new this.Code.Push("Label",BlockLabel.Value,0,0)) ;wip: position and length

        Return, Result
    }

    Symbol(Tree)
    {
        If Tree.Type != "Symbol"
            Return, False

        Return, [new this.Code.Push("Symbol",Tree.Value,Tree.Position,Tree.Length)]
    }

    Self(Tree)
    {
        If Tree.Type != "Self"
            Return, False

        Return, [new this.Code.Push("Self","",Tree.Position,Tree.Length)]
    }

    String(Tree)
    {
        If Tree.Type != "String"
            Return, False

        Return, [new this.Code.Push("String",Tree.Value,Tree.Position,Tree.Length)]
    }

    Identifier(Tree)
    {
        If Tree.Type != "Identifier"
            Return, False

        Return, [new this.Code.Load(Tree.Value,Tree.Position,Tree.Length)]
    }

    Number(Tree)
    {
        If Tree.Type != "Number"
            Return, False

        Return, [new this.Code.Push("Number",Tree.Value,Tree.Position,Tree.Length)]
    }
}
*/