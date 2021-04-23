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

class Reconstruct
{
    Tokens(Value)
    {
        static Operators := {_assign:                 ":="
                            ,_assign_add:             "+="
                            ,_assign_subtract:        "-="
                            ,_assign_multiply:        "*="
                            ,_assign_divide:          "/="
                            ,_assign_divide_floor:    "//="
                            ,_assign_remainder:       "%="
                            ,_assign_modulo:          "%%="
                            ,_assign_exponentiate:    "**="
                            ,_assign_concatenate:     ".="
                            ,_assign_bit_or:          "|="
                            ,_assign_bit_and:         "&="
                            ,_assign_bit_xor:         "^="
                            ,_assign_bit_shift_left:  "<<="
                            ,_assign_bit_shift_right: ">>="
                            ,_assign_or:              "||="
                            ,_assign_and:             "&&="
                            ,_if:                     "?"
                            ,_or:                     "||"
                            ,_and:                    "&&"
                            ,_equals:                 "="
                            ,_equals_strict:          "=="
                            ,_not_equals:             "!="
                            ,_not_equals_strict:      "!=="
                            ,_greater_than:           ">"
                            ,_less_than:              "<"
                            ,_greater_than_or_equal:  ">="
                            ,_less_than_or_equal:     "<="
                            ,_concatenate:            ".."
                            ,_bit_or:                 "|"
                            ,_bit_exclusive_or:       "^"
                            ,_bit_and:                "&"
                            ,_shift_left:             "<<"
                            ,_shift_right:            ">>"
                            ,_shift_right_unsigned:   ">>>"
                            ,_add:                    "+"
                            ,_subtract:               "-"
                            ,_multiply:               "*"
                            ,_divide:                 "/"
                            ,_divide_floor:           "//"
                            ,_remainder:              "%"
                            ,_modulo:                 "%%"
                            ,_not:                    "!"
                            ,_invert:                 "-"
                            ,_bit_not:                "~"
                            ,_address:                "&"
                            ,_exponentiate:           "**"
                            ,_evaluate:               "("
                            ,_call:                   "("
                            ,_end:                    ")"
                            ,_block:                  "{"
                            ,_block_end:              "}"
                            ,_array:                  "["
                            ,_subscript:              "["
                            ,_subscript_end:          "]"
                            ,_subscript_identifier:   "."}

        Result := ""
        For Index, Token In Value
        {
            If Token.Type = "OperatorNull"
                Result .= Operators[Token.Value.Identifier]
            Else If Token.Type = "OperatorLeft"
                Result .= Operators[Token.Value.Identifier]
            Else If Token.Type = "Line"
                Result .= "`n"
            Else If Token.Type = "Separator"
                Result .= ", "
            Else If Token.Type = "Map"
                Result .= ":"
            Else If Token.Type = "Symbol"
                Result .= "'" . Token.Value . "`n"
            Else If Token.Type = "String"
                Result .= """" . Token.Value . """"
            Else If Token.Type = "Identifier"
                Result .= Token.Value
            Else If Token.Type = "Number"
                Result .= Token.Value
            Else If Token.Type = "Comment"
                Result .= "/*" . Token.Value . "*/"
        }
        Return, Result
    }

    Tree(Value)
    {
        static AssignmentOperators := {_assign:                 ":="
                                      ,_assign_add:             "+="
                                      ,_assign_subtract:        "-="
                                      ,_assign_multiply:        "*="
                                      ,_assign_divide:          "/="
                                      ,_assign_divide_floor:    "//="
                                      ,_assign_remainder:       "%="
                                      ,_assign_modulo:          "%%="
                                      ,_assign_exponentiate:    "**="
                                      ,_assign_concatenate:     "..="
                                      ,_assign_bit_or:          "|="
                                      ,_assign_bit_and:         "&="
                                      ,_assign_bit_xor:         "^="
                                      ,_assign_bit_shift_left:  "<<="
                                      ,_assign_bit_shift_right: ">>="
                                      ,_assign_or:              "||="
                                      ,_assign_and:             "&&="}
        static UnaryOperators := {_address:               "&"
                                 ,_bit_not:               "~"
                                 ,_invert:                "-"
                                 ,_not:                   "!"}
        static BinaryOperators := {_exponentiate:          "**"
                                  ,_modulo:                "%%"
                                  ,_remainder:             "%"
                                  ,_divide_floor:          "//"
                                  ,_divide:                "/"
                                  ,_multiply:              "*"
                                  ,_subtract:              "-"
                                  ,_add:                   "+"
                                  ,_shift_right_unsigned:  ">>>"
                                  ,_shift_right:           ">>"
                                  ,_shift_left:            "<<"
                                  ,_bit_and:               "&"
                                  ,_bit_exclusive_or:      "^"
                                  ,_bit_or:                "|"
                                  ,_concatenate:           ".."
                                  ,_less_than_or_equal:    "<="
                                  ,_greater_than_or_equal: ">="
                                  ,_less_than:             "<"
                                  ,_greater_than:          ">"
                                  ,_not_equals_strict:     "!=="
                                  ,_not_equals:            "!="
                                  ,_equals_strict:         "=="
                                  ,_equals:                "="}
        
        If Value.Type = "Operation"
        {
            Callable := Value.Value
            Parameters := Value.Parameters
            If Callable.Type = "Identifier"
            {
                If AssignmentOperators.HasKey(Callable.Value)
                {
                    If Parameters[2].Type = "Symbol"
                    {
                        Result := ""
                        If Parameters[1].Type != "Self"
                            Result .= this.Tree(Parameters[1]) . "."
                        Result .= Parameters[2].Value
                    }
                    Else
                        Result := this.Tree(Parameters[1]) . "[" . this.Tree(Parameters[2]) . "]"
                    Return, Result . " " . AssignmentOperators[Callable.Value] . " " . this.Tree(Parameters[3])
                }
                If Callable.Value = "_subscript"
                {
                    If Parameters[2].Type = "Symbol"
                        Return, "(" . this.Tree(Parameters[1]) . "." . Parameters[2].Value . ")"
                    Return, this.Tree(Parameters[1]) . "[" . this.Tree(Parameters[2]) . "]"
                }
                If Callable.Value = "_slice"
                {
                    Start := Parameters.HasKey(2) ? this.Tree(Parameters[2]) : ""
                    End := Parameters.HasKey(3) ? this.Tree(Parameters[3]) : ""
                    Step := Parameters.HasKey(4) ? this.Tree(Parameters[4]) : ""
                    Value := RTrim(Start . ":" . End . ":" . Step,":")
                    If (Start != "" && End = "" && Step = "")
                        Value .= ":"
                    If (Value = "")
                        Value := ":"
                    Return, this.Tree(Parameters[1]) . "[" . Value . "]"
                }
                If Callable.Value = "_compare"
                {
                    Result := "(" . this.Tree(Parameters[1])
                    Index := 2
                    Loop, % Parameters.MaxIndex() // 2
                    {
                        Result .= " " . BinaryOperators[Parameters[Index].Value]
                        Index ++
                        Result .= " " . this.Tree(Parameters[Index])
                        Index ++
                    }
                    Return, Result . ")"
                }
                If Callable.Value = "_array"
                {
                    Result := "["
                    ParameterValue := []
                    Loop, % Parameters.MaxIndex()
                        ParameterValue.Insert(Parameters.HasKey(A_Index) ? this.Tree(Parameters[A_Index]) : "")
                    For Key, Parameter In Parameters
                    {
                        If IsObject(Key)
                            ParameterValue.Insert(this.Tree(Key) . ": " . this.Tree(Parameter))
                    }
                    For Index, Value In ParameterValue
                    {
                        If Index != 1
                            Result .= "," . (Value = "" ? "" : " ")
                        Result .= Value
                    }
                    Return, Result . "]"
                }
                If Callable.Value = "_evaluate"
                {
                    Result := "("
                    For Index, Parameter In Parameters
                        Result .= this.Tree(Parameter) . "`n"
                    Return, SubStr(Result,1,-1) . ")"
                }
                If Callable.Value = "_and"
                    Return, "(" . this.Tree(Parameters[1]) . " && " . this.Tree(Parameters[2].Contents[1]) . ")"
                If Callable.Value = "_or"
                    Return, "(" . this.Tree(Parameters[1]) . " || " . this.Tree(Parameters[2].Contents[1]) . ")"
                If Callable.Value = "_if"
                    Return, "(" . this.Tree(Parameters[1]) . " ? " . this.Tree(Parameters[2].Contents[1]) . " : " . this.Tree(Parameters[3].Contents[1]) . ")"
                If UnaryOperators.HasKey(Callable.Value)
                    Return, "(" . UnaryOperators[Callable.Value] . this.Tree(Parameters[1]) . ")"
                If BinaryOperators.HasKey(Callable.Value)
                    Return, "(" . this.Tree(Parameters[1]) . " " . BinaryOperators[Callable.Value] . " " . this.Tree(Parameters[2]) . ")"
            }
            Result := this.Tree(Value.Value) . "("
            ParameterValue := []
            Loop, % Parameters.MaxIndex()
                ParameterValue.Insert(Parameters.HasKey(A_Index) ? this.Tree(Parameters[A_Index]) : "")
            For Key, Parameter In Parameters
            {
                
                If IsObject(Key)
                    ParameterValue.Insert(this.Tree(Key) . ": " . this.Tree(Parameter))
            }
            For Index, Value In ParameterValue
            {
                If Index != 1
                    Result .= "," . (Value = "" ? "" : " ")
                Result .= Value
            }
            Return, Result . ")"
        }
        If Value.Type = "Block"
        {
            Result := ""
            For Index, Content In Value.Contents
                Result .= this.Tree(Content) . "`n"
            Return, "{" . SubStr(Result,1,-1) . "}"
        }
        If Value.Type = "Self"
            Return, "$"
        If Value.Type = "Symbol"
            Return, "'" . Value.Value
        If Value.Type = "String"
        {
            Result := Value.Value
            StringReplace, Result, Result, ``, ````, All
            StringReplace, Result, Result, ", ``", All
            StringReplace, Result, Result, `r, ``r, All
            StringReplace, Result, Result, `n, ``n, All
            StringReplace, Result, Result, `t, ``t, All
            Return, """" . Result . """"
        }
        If Value.Type = "Identifier"
            Return, Value.Value
        If Value.Type = "Number"
            Return, Value.Value
        Return, "(UNKNOWN_VALUE)"
    }
}

class Dump
{
    Tokens(Value)
    {
        Result := ""
        For Index, Token In Value
        {
            If Token.Type = "OperatorNull"
                Result .= Token.Position . ":" . Token.Length . "`t" . Token.Type . "`t" . Token.Value.Identifier . "`n"
            Else If Token.Type = "OperatorLeft"
                Result .= Token.Position . ":" . Token.Length . "`t" . Token.Type . "`t" . Token.Value.Identifier . "`n"
            Else If Token.Type = "Line"
                Result .= Token.Position . ":" . Token.Length . "`t" . Token.Type . "`n"
            Else If Token.Type = "Separator"
                Result .= Token.Position . ":" . Token.Length . "`t" . Token.Type . "`n"
            Else If Token.Type = "Map"
                Result .= Token.Position . ":" . Token.Length . "`t" . Token.Type . "`n"
            Else If Token.Type = "Self"
                Result .= Token.Position . ":" . Token.Length . "`t" . Token.Type . "`n"
            Else If Token.Type = "Symbol"
                Result .= Token.Position . ":" . Token.Length . "`t" . Token.Type . "`t" . Token.Value . "`n"
            Else If Token.Type = "String"
                Result .= Token.Position . ":" . Token.Length . "`t" . Token.Type . "`t""" . Token.Value . """`n"
            Else If Token.Type = "Identifier"
                Result .= Token.Position . ":" . Token.Length . "`t" . Token.Type . "`t" . Token.Value . "`n"
            Else If Token.Type = "Number"
                Result .= Token.Position . ":" . Token.Length . "`t" . Token.Type . "`t" . Token.Value . "`n"
            Else If Token.Type = "Comment"
                Result .= Token.Position . ":" . Token.Length . "`t" . Token.Type . "`t""" . Token.Value . """`n"
        }
        Return, SubStr(Result,1,-1)
    }

    Tree(Value,Padding = "")
    {
        Result := Padding . Value.Position . ":" . Value.Length . " " . Value.Type
        If Value.Type = "Operation"
        {
            Result .= "`n" . this.Tree(Value.Value,Padding . "`t")
            For Key, Value In Value.Parameters
            {
                Result .= "`n" . Padding . "`t@Key`n" . (IsObject(Key) ? this.Tree(Key,Padding . "`t") : Padding . "`t" . Key)
                Result .= "`n" . Padding . "`t@Value`n" . this.Tree(Value,Padding . "`t")
            }
            Return, Result
        }
        If Value.Type = "Block"
        {
            For Key, Value In Value.Contents
                Result .= this.Tree(Value,Padding . "`t") . "`n"
            Return, SubStr(Result,1,-1)
        }
        If Value.Type = "Symbol"
            Return, Result . " " . Value.Value
        If Value.Type = "String"
            Return, Result . " " . Value.Value
        If Value.Type = "Identifier"
            Return, Result . " " . Value.Value
        If Value.Type = "Number"
            Return, Result . " " . Value.Value
        Return, Result
    }

    Bytecode(Value)
    {
        Result := ""
        For Index, Entry In Value
        {
            If Entry.Identifier = "Label"
                Result .= ":" . Entry.Value
            Else If Entry.Identifier = "Jump"
                Result .= "jump"
            Else If Entry.Identifier = "Return"
                Result .= "return"
            Else If Entry.Identifier = "Call"
                Result .= "call " . Entry.Count
            Else If Entry.Identifier = "Push"
            {
                Result .= "push "
                If Entry.Type = "Label"
                    Result .= ":" . Entry.Value
                Else If Entry.Type = "Symbol"
                    Result .= "symbol " . Entry.Value
                Else If Entry.Type = "Self"
                    Result .= "$"
                Else If Entry.Type = "String"
                    Result .= "string " . Entry.Value
                Else If Entry.Type = "Number"
                    Result .= "number " . Entry.Value
                Else
                    throw Exception("Invalid push.")
            }
            Else If Entry.Identifier = "Load"
                Result .= "load " . Entry.Value
            Else
                throw Exception("Invalid bytecode.")
            Result .= "`n"
        }
        Return, Result
    }
}