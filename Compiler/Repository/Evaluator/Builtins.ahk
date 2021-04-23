class Builtins
{
    class Object
    {
        _boolean(Arguments,Environment)
        {
            Return, Builtins.True
        }

        _string(Arguments,Environment)
        {
            Return, new Builtins.String("<" . this.__Class . " " . &this . ">")
        }

        _hash(Arguments,Environment)
        {
            Return new Builtins.Number(&this)
        }
    }

    class None extends Builtins.Object
    {
        _string(Arguments,Environment)
        {
            Return, new Builtins.String("None")
        }
    }

    class True extends Builtins.Object
    {
        _string(Arguments,Environment)
        {
            Return, new Builtins.String("True")
        }
    }

    class False extends Builtins.Object
    {
        _string(Arguments,Environment)
        {
            Return, new Builtins.String("False")
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

        _boolean(Arguments,Environment)
        {
            Return, ObjNewEnum(this.Value).Next(Key) ? Builtins.True : Builtins.False
        }

        _subscript(Arguments,Environment)
        {
            Key := Arguments[1]._hash([],Environment).Value
            Return, this.Value[Key] ? this.Value[Key] : Builtins.None
        }

        _assign(Arguments,Environment)
        {
            Key := Arguments[1]._hash([],Environment).Value
            this.Value[Key] := Arguments[2]
        }
    }

    class Block extends Builtins.Object
    {
        __New(Contents,Environment)
        {
            this.Contents := Contents
            this.Environment := Environment
        }

        __Call(Key,Instance,Arguments,Environment)
        {
            ;set up an inner environment with self and arguments ;wip: make this a bit more minimal
            InnerEnvironment := new Builtins.Array({self: this, args: new Builtins.Array(Arguments,Environment)},Environment)
            InnerEnvironment.Value.base := Environment.Value

            ;evaluate the contents of the block
            Result := Builtins.None
            For Index, Content In this.Contents
                Result := Eval(Content,InnerEnvironment)
            Return, Result
        }
    }

    class Symbol extends Builtins.Object
    {
        __New(Value)
        {
            this.Value := Value
        }

        _equals(Arguments,Environment)
        {
            Return, this.Value = Arguments[1].Value
        }

        _equals_strict(Arguments,Environment)
        {
            Return, this.Value == Arguments[1].Value
        }

        _hash(Arguments,Environment)
        {
            Value := DllCall("ntdll\RtlComputeCrc32","UInt",0,"UPtr",ObjGetAddress(this,"Value"),"UPtr",StrLen(this.Value) << !!A_IsUnicode)
            Return, new Builtins.Number(Value)
        }
    }

    class String extends Builtins.Object
    {
        __New(Value)
        {
            this.Value := Value
        }

        _boolean(Arguments,Environment)
        {
            Return, this.Value = "" ? Builtins.True : Builtins.False
        }

        _equals(Arguments,Environment)
        {
            Return, this.Value = Arguments[1].Value
        }

        _equals_strict(Arguments,Environment)
        {
            Return, this.Value == Arguments[1].Value
        }

        _multiply(Arguments,Environment)
        {
            Result := ""
            Loop, % Arguments[1].Value
                Result .= this.Value
            Return, new this.base(Result)
        }

        _subscript(Arguments,Environment)
        {
            Return, new this.base(SubStr(this.Value,Arguments[1].Value,1)) ;wip: cast to string
        }

        _concatenate(Arguments,Environment)
        {
            Return, new this.base(this.Value . Arguments[1].Value) ;wip: cast to string
        }

        _string(Arguments,Environment)
        {
            Return, this
        }
    }

    class Number extends Builtins.Object
    {
        __New(Value)
        {
            this.Value := Value
        }

        _boolean(Arguments,Environment)
        {
            Return, this.Value = 0 ? Builtins.False : Builtins.True
        }

        _equals(Arguments,Environment)
        {
            Return, this.Value = Arguments[1].Value ? Builtins.True : Builtins.False ;wip: try to convert to number
        }

        _equals_strict(Arguments,Environment)
        {
            Return, this.Value == Arguments[1].Value
        }

        _add(Arguments,Environment)
        {
            Return, new this.base(this.Value + Arguments[1].Value)
        }

        _multiply(Arguments,Environment)
        {
            Return, new this.base(this.Value * Arguments[1].Value)
        }

        _string(Arguments,Environment)
        {
            Return, new Builtins.String(this.Value)
        }

        _hash(Arguments,Environment)
        {
            Return, this
        }
    }

    ;wip: should be implemented in core.ato
    _array(Arguments,Environment)
    {
        Return, new Builtins.Array(Arguments,Environment)
    }

    _assign(Arguments,Environment)
    {
        Return, Arguments[1]._assign([Arguments[2],Arguments[3]],Environment)
    }

    _if(Arguments,Environment)
    {
        If Arguments[1]._boolean([],Environment)
            Return, Arguments[2]([],Environment)
        Return, Arguments[3]([],Environment)
    }

    _or(Arguments,Environment)
    {
        If Arguments[1]._boolean([],Environment)
            Return, Arguments[1]
        Return, Arguments[2]([],Environment)
    }

    _and(Arguments,Environment)
    {
        MsgBox
        If !Arguments[1]._boolean([],Environment)
            Return, Arguments[1]
        Return, Arguments[2]([],Environment)
    }

    _equals(Arguments,Environment)
    {
        Return, Arguments[1]._equals([Arguments[2]],Environment)
    }

    _equals_strict(Arguments,Environment)
    {
        Return, Arguments[1]._equals_strict([Arguments[2]],Environment)
    }

    _add(Arguments,Environment)
    {
        Return, Arguments[1]._add([Arguments[2]],Environment)
    }

    _multiply(Arguments,Environment)
    {
        Return, Arguments[1]._multiply([Arguments[2]],Environment)
    }

    _evaluate(Arguments,Environment)
    {
        ;return the last parameter
        If ObjMaxIndex(Arguments)
            Return, Arguments[Arguments.MaxIndex()]
        Return, Environment.None
    }

    _subscript(Arguments,Environment)
    {
        Return, Arguments[1]._subscript([Arguments[2]],Environment)
    }

    _concatenate(Arguments,Environment)
    {
        Return, Arguments[1]._concatenate([Arguments[2]],Environment)
    }

    print(Arguments,Environment)
    {
        FileAppend, % Arguments[1]._string([],Environment).Value . "`n", *
        Return, Arguments[1]
    }
}