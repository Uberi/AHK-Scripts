class Builtins
{
    class Object
    {
        _boolean(Interpreter,Arguments,Environment)
        {
            Interpreter.Stack.Insert(Builtins.True)
            Interpreter.Return()
        }

        _string(Interpreter,Arguments,Environment)
        {
            Interpreter.Stack.Insert(new Builtins.String("<" . this.__Class . " " . &this . ">"))
            Interpreter.Return()
        }

        _hash(Interpreter,Arguments,Environment)
        {
            Interpreter.Stack.Insert(new Builtins.Number(&this))
            Interpreter.Return()
        }
    }

    class None extends Builtins.Object
    {
        _string(Interpreter,Arguments,Environment)
        {
            Interpreter.Stack.Insert(new Builtins.String("None"))
            Interpreter.Return()
        }
    }

    class True extends Builtins.Object
    {
        _string(Interpreter,Arguments,Environment)
        {
            Interpreter.Stack.Insert(new Builtins.String("True"))
            Interpreter.Return()
        }
    }

    class False extends Builtins.Object
    {
        _string(Interpreter,Arguments,Environment)
        {
            Interpreter.Stack.Insert(new Builtins.String("False"))
            Interpreter.Return()
        }
    }

    class Array extends Builtins.Object
    {
        __New(Value,Environment)
        {
            this.Value := {}
            For Key, Entry In Value
            {
                If Key Is Number
                    Key := new Builtins.Number(Key)
                Else
                    Key := new Builtins.Symbol(Key)
                this._assign([Key,Entry],Environment)
            }
        }

        _boolean(Interpreter,Arguments,Environment)
        {
            Interpreter.Stack.Insert(ObjNewEnum(this.Value).Next(Key) ? Builtins.True : Builtins.False)
            Interpreter.Return()
        }

        _subscript(Interpreter,Arguments,Environment)
        {
            Key := Arguments[1]._hash([],Environment).Value
            Interpreter.Stack.Insert(this.Value[Key] ? this.Value[Key] : Builtins.None)
            Interpreter.Return()
        }

        _assign(Interpreter,Arguments,Environment)
        {
            Interpreter.Stack.Insert(this.Index)
            Arguments[1]._hash([],Environment)
            Key := Interpreter.Stack.Remove().Value
            MsgBox % Key
            this.Value[Key] := Arguments[2]
            Interpreter.Stack.Insert(Arguments[2])
            Interpreter.Return()
        }
    }

    class Block extends Builtins.Object
    {
        ;wip
        __New(Target)
        {
            this.Target := Target
        }

        __Call(Self,Key,Interpreter,Arguments,Environment)
        {
            ;wip: need to have default return value
            this.Index := Interpreter.Target
        }
    }

    class Symbol extends Builtins.Object
    {
        __New(Value)
        {
            this.Value := Value
        }

        _equals(Interpreter,Arguments,Environment)
        {
            Interpreter.Stack.Insert(this.Value = Arguments[1].Value ? Builtins.True : Builtins.False)
            Interpreter.Return()
        }

        _equals_strict(Interpreter,Arguments,Environment)
        {
            Interpreter.Stack.Insert(this.Value == Arguments[1].Value ? Builtins.True : Builtins.False)
        }

        _hash(Interpreter,Arguments,Environment)
        {
            Value := DllCall("ntdll\RtlComputeCrc32","UInt",0,"UPtr",ObjGetAddress(this,"Value"),"UPtr",StrLen(this.Value) << !!A_IsUnicode)
            Interpreter.Stack.Insert(new Builtins.Number(Value))
            Interpreter.Return()
        }
    }

    class String extends Builtins.Object
    {
        __New(Value)
        {
            this.Value := Value
        }

        _boolean(Interpreter,Arguments,Environment)
        {
            Interpreter.Stack.Insert(this.Value = "" ? Builtins.True : Builtins.False)
            Interpreter.Return()
        }

        _equals(Interpreter,Arguments,Environment)
        {
            Interpreter.Stack.Insert(this.Value = Arguments[1].Value ? Builtins.True : Builtins.False)
            Interpreter.Return()
        }

        _equals_strict(Interpreter,Arguments,Environment)
        {
            Interpreter.Stack.Insert(this.Value == Arguments[1].Value ? Builtins.True : Builtins.False)
            Interpreter.Return()
        }

        _multiply(Interpreter,Arguments,Environment)
        {
            Result := ""
            Loop, % Arguments[1].Value
                Result .= this.Value
            Interpreter.Stack.Insert(new this.base(Result))
            Interpreter.Return()
        }

        _subscript(Interpreter,Arguments,Environment)
        {
            Interpreter.Stack.Insert(new this.base(SubStr(this.Value,Arguments[1].Value,1))) ;wip: cast index to number
            Interpreter.Return()
        }

        _concatenate(Interpreter,Arguments,Environment)
        {
            Interpreter.Stack.Insert(new this.base(this.Value . Arguments[1]._string([],Environment).Value))
            Interpreter.Return()
        }

        _string(Interpreter,Arguments,Environment)
        {
            Interpreter.Stack.Insert(this) ;wip: this is a byref copy, needs to be byval
            Interpreter.Return()
        }
    }

    class Number extends Builtins.Object
    {
        __New(Value)
        {
            this.Value := Value
        }

        _boolean(Interpreter,Arguments,Environment)
        {
            Interpreter.Stack.Insert(this.Value = 0 ? Builtins.False : Builtins.True)
            Interpreter.Return()
        }

        _equals(Interpreter,Arguments,Environment)
        {
            Interpreter.Stack.Insert(this.Value = Arguments[1].Value ? Builtins.True : Builtins.False) ;wip: try to convert to number
            Interpreter.Return()
        }

        _equals_strict(Interpreter,Arguments,Environment)
        {
            Interpreter.Stack.Insert(this.Value == Arguments[1].Value ? Builtins.True : Builtins.False) ;wip: try to convert to number
            Interpreter.Return()
        }

        _add(Interpreter,Arguments,Environment)
        {
            Interpreter.Stack.Insert(new this.base(this.Value + Arguments[1].Value))
            Interpreter.Return()
        }

        _multiply(Interpreter,Arguments,Environment)
        {
            Interpreter.Stack.Insert(new this.base(this.Value * Arguments[1].Value))
            Interpreter.Return()
        }

        _string(Interpreter,Arguments,Environment)
        {
            Interpreter.Stack.Insert(new Builtins.String(this.Value))
            Interpreter.Return()
        }

        _hash(Interpreter,Arguments,Environment)
        {
            Interpreter.Stack.Insert(this) ;wip: make this a byval copy
            Interpreter.Return()
        }
    }

    ;wip: should be implemented in core.ato
    _array(Interpreter,Arguments,Environment)
    {
        Interpreter.Stack.Insert(new Builtins.Array(Arguments,Environment))
        Interpreter.Return()
    }

    _assign(Interpreter,Arguments,Environment)
    {
        Interpreter.Stack.Insert(Arguments[1]._assign([Arguments[2],Arguments[3]],Environment))
        Interpreter.Return()
    }

    _if(Interpreter,Arguments,Environment)
    {
        If Arguments[1]._boolean([],Environment)
            Interpreter.Stack.Insert(Arguments[2]([],Environment))
        Else
            Interpreter.Stack.Insert(Arguments[3]([],Environment))
        Interpreter.Return()
    }

    _or(Interpreter,Arguments,Environment)
    {
        If Arguments[1]._boolean([],Environment)
            Interpreter.Stack.Insert(Arguments[1])
        Else
            Interpreter.Stack.Insert(Arguments[2]([],Environment))
        Interpreter.Return()
    }

    _and(Interpreter,Arguments,Environment)
    {
        If !Arguments[1]._boolean([],Environment)
            Interpreter.Stack.Insert(Arguments[1])
        Else
            Interpreter.Stack.Insert(Arguments[2]([],Environment))
        Interpreter.Return()
    }

    _equals(Interpreter,Arguments,Environment)
    {
        Interpreter.Stack.Insert(Arguments[1]._equals([Arguments[2]],Environment))
        Interpreter.Return()
    }

    _equals_strict(Interpreter,Arguments,Environment)
    {
        Interpreter.Stack.Insert(Arguments[1]._equals_strict([Arguments[2]],Environment))
        Interpreter.Return()
    }

    _add(Interpreter,Arguments,Environment)
    {
        Interpreter.Stack.Insert(Arguments[1]._add([Arguments[2]],Environment))
        Interpreter.Return()
    }

    _multiply(Interpreter,Arguments,Environment)
    {
        Interpreter.Stack.Insert(Arguments[1]._multiply([Arguments[2]],Environment))
        Interpreter.Return()
    }

    _evaluate(Interpreter,Arguments,Environment)
    {
        ;return the last parameter
        If ObjMaxIndex(Arguments)
            Interpreter.Stack.Insert(Arguments[Arguments.MaxIndex()])
        Else
            Interpreter.Stack.Insert(Environment.None)
        Interpreter.Return()
    }

    _subscript(Interpreter,Arguments,Environment)
    {
        Interpreter.Stack.Insert(Arguments[1]._subscript([Arguments[2]],Environment))
        Interpreter.Return()
    }

    _concatenate(Interpreter,Arguments,Environment)
    {
        Interpreter.Stack.Insert(Arguments[1]._concatenate([Arguments[2]],Environment))
        Interpreter.Return()
    }

    print(Interpreter,Arguments,Environment)
    {
        FileAppend, % Arguments[1]._string([],Environment).Value . "`n", *
        Interpreter.Stack.Insert(Arguments[1])
        Interpreter.Return()
    }
}