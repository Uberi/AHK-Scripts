#NoEnv

SetFormat, IntegerFast, Hex
c := new Color(Color.Unpack(0xAAFF00))
MsgBox % Color.Pack(c.RGB)
MsgBox % Color.Pack(c.HSV)

class Color
{
    __New(Value = "",Type = "RGB")
    {
        this.Red := 0, this.Green := 0, this.Blue := 0
        If (Value != "")
        {
            If (Type = "RGB")
                this.RGB := Value
            If (Type = "BGR")
                this.BGR := Value
            Else If (Type = "HSV")
                this.HSV := Value
        }
    }

    Pack(Triple)
    {
        ;retrieve components as byte values
        Component1 := Round(Triple[1] * 0xFF)
        Component2 := Round(Triple[2] * 0xFF)
        Component3 := Round(Triple[3] * 0xFF)

        ;clamp HDR values
        Component1 := (Component1 < 0) ? 0 : ((Component1 > 0xFF) ? 0xFF : Component1)
        Component2 := (Component2 < 0) ? 0 : ((Component2 > 0xFF) ? 0xFF : Component2)
        Component3 := (Component3 < 0) ? 0 : ((Component3 > 0xFF) ? 0xFF : Component3)

        Return, (Component1 << 16) | (Component2 << 8) | Component3
    }

    Unpack(Value)
    {
        ;retrieve components packed in lower 3 bytes
        Component1 := (Value >> 16) / 0xFF
        Component2 := (((Value & 0xFF00) >> 8) & 0xFF) / 0xFF
        Component3 := (Value & 0xFF) / 0xFF

        Return, [Component1, Component2, Component3]
    }

    _RGB(Color = "")
    {
        If (Color = "")
            Return, [this.Red, this.Green, this.Blue]
        Else
        {
            this.Red := Color[1]
            this.Green := Color[2]
            this.Blue := Color[3]
        }
    }

    _BGR(Color = "")
    {
        If (Color = "")
        {
            Return, [this.Blue, this.Green, this.Red]
        }
        Else
        {
            this.Red := Color[3]
            this.Green := Color[2]
            this.Blue := Color[1]
        }
    }

    _Hue(Color = "")
    {
        If (Color = "")
        {
            Minimum := (this.Red < this.Green) ? ((this.Red < this.Blue) ? this.Red : this.Blue) : ((this.Green < this.Blue) ? this.Green : this.Blue)
            Value := (this.Red > this.Green) ? ((this.Red > this.Blue) ? this.Red : this.Blue) : ((this.Green > this.Blue) ? this.Green : this.Blue)
            Delta := Value - Minimum
            If Delta = 0 ;achromatic
                Return, 0 ;arbitrary hue
            If this.Red = Value ;between yellow and magenta
                Hue := (this.Green - this.Blue) / Delta
            Else If this.Green = Value ;between cyan and yellow
                Hue := 2 + ((this.Blue - this.Red) / Delta)
            Else ;between magenta and cyan
                Hue := 4 + ((this.Red - this.Green) / Delta)
            If Hue < 0
                Hue += 6
            Return, Hue / 6
        }
        Else
        {
            ;check input validity
            If Color Is Not Number
                throw Exception("Invalid hue component: " . Color . ".",-1)

            ;wip
        }
    }

    _Saturation(Color = "")
    {
        If (Color = "")
        {
            Minimum := (this.Red < this.Green) ? ((this.Red < this.Blue) ? this.Red : this.Blue) : ((this.Green < this.Blue) ? this.Green : this.Blue)
            Value := (this.Red > this.Green) ? ((this.Red > this.Blue) ? this.Red : this.Blue) : ((this.Green > this.Blue) ? this.Green : this.Blue)
            Delta := Value - Minimum
            If Delta = 0 ;achromatic
                Return, 0 ;no saturation
            Return, Delta / Value
        }
        Else
        {
            ;check input validity
            If Color Is Not Number
                throw Exception("Invalid saturation component: " . Color . ".",-1)

            ;wip
        }
    }

    _Value(Color = "")
    {
        If (Color = "")
        {
            ;value is the magnitude of the greatest component
            Return, (this.Red > this.Green) ? ((this.Red > this.Blue) ? this.Red : this.Blue) : ((this.Green > this.Blue) ? this.Green : this.Blue)
        }
        Else
        {
            ;check input validity
            If Color Is Not Number
                throw Exception("Invalid value component: " . Color . ".",-1)

            ;wip
        }
    }

    _HSV(Color = "")
    {
        If (Color = "")
        {
            ;wip: handle HDR
            Minimum := (this.Red < this.Green) ? ((this.Red < this.Blue) ? this.Red : this.Blue) : ((this.Green < this.Blue) ? this.Green : this.Blue)
            Value := (this.Red > this.Green) ? ((this.Red > this.Blue) ? this.Red : this.Blue) : ((this.Green > this.Blue) ? this.Green : this.Blue)
            Delta := Value - Minimum
            If Delta = 0 ;achromatic
                Return, Round(Value * 0xFF) ;arbitrary hue and no saturation
            If this.Red = Value ;between yellow and magenta
                Hue := (this.Green - this.Blue) / Delta
            Else If this.Green = Value ;between cyan and yellow
                Hue := 2 + ((this.Blue - this.Red) / Delta)
            Else ;between magenta and cyan
                Hue := 4 + ((this.Red - this.Green) / Delta)
            If Hue < 0
                Hue += 6
            Hue /= 6
            Saturation := Delta / Value
            Return, [Hue, Saturation, Value]
        }
        Else
        {
            ;retrieve components
            Hue := Color[1]
            Saturation := Color[2]
            Value := Color[3]

            Hue *= 6
            Sector := Floor(Hue)
            FractionalHue := Hue - Sector
            Component1 := Value * (1 - Saturation)
            Component2 := Value * (1 - (Saturation * FractionalHue))
            Component3 := Value * (1 - (Saturation * (1 - FractionalHue)))

            If Sector = 0 ;zeroth sector
                this.Red := Value, this.Green := Component3, this.Blue := Component1
            Else If Sector = 1 ;first sector
                this.Red := Component2, this.Green := Value, this.Blue := Component1
            Else If Sector = 2 ;second sector
                this.Red := Component1, this.Green := Value, this.Blue := Component3
            Else If Sector = 3 ;third sector
                this.Red := Component1, this.Green := Component2, this.Blue := Value
            Else If Sector = 4 ;fourth sector
                this.Red := Component3, this.Green := Component1, this.Blue := Value
            Else ;fifth sector
                this.Red := Value, this.Green := Component1, this.Blue := Component2
        }
    }

    __Get(Key)
    {
        If (Key = "RGB")
            Return, this._RGB()
        If (Key = "BGR")
            Return, this._BGR()
        If (Key = "Hue")
            Return, this._Hue()
        If (Key = "Saturation")
            Return, this._Saturation()
        If (Key = "Value")
            Return, this._Value()
        If (Key = "HSV")
            Return, this._HSV()
        throw Exception("Unknown key: " . Key,-1)
    }

    __Set(Key,Color)
    {
        If (Key = "Red" || Key = "Green" || Key = "Blue") ;wip: this never seems to run
        {
            If Color Is Not Number
                throw Exception("Invalid RGB color component: " . Color . ".",-1)
            ObjInsert(this,Key,Color)
        }
        Else If (Key = "RGB")
            this._RGB(Color)
        Else If (Key = "BGR")
            this._BGR(Color)
        Else If (Key = "Hue")
            this._Hue(Color)
        Else If (Key = "Saturation")
            this._Saturation(Color)
        Else If (Key = "Value")
            this._Value(Color)
        Else If (Key = "Hue" || Key = "Saturation" || Key = "Value")
        {
            HSV := this._HSV()
            Hue := HSV[1], Saturation := HSV[2], Value := HSV[3]

            If (Key = "Hue")
                Hue := Color
            Else If (Key = "Saturation")
                Saturation := Color
            Else If (Key = "Value")
                Value := Color

            ;wip: HDR values
            Sector := Floor(Hue)
            FractionalHue := Hue - Sector
            Component1 := Value * (1 - Saturation)
            Component2 := Value * (1 - (Saturation * FractionalHue))
            Component3 := Value * (1 - (Saturation * (1 - FractionalHue)))

            If Sector = 0 ;zeroth sector
                this.Red := Value, this.Green := Component3, this.Blue := Component1
            Else If Sector = 1 ;first sector
                this.Red := Component2, this.Green := Value, this.Blue := Component1
            Else If Sector = 2 ;second sector
                this.Red := Component1, this.Green := Value, this.Blue := Component3
            Else If Sector = 3 ;third sector
                this.Red := Component1, this.Green := Component2, this.Blue := Value
            Else If Sector = 4 ;fourth sector
                this.Red := Component3, this.Green := Component1, this.Blue := Value
            Else ;fifth sector
                this.Red := Value, this.Green := Component1, this.Blue := Component2
        }
        Else If (Key = "HSV")
            this._HSV(Color)
        Else
            throw Exception("Unknown key: " . Key,-1)
        Return, Color
    }
}

RGBToHSV(RGB)
{
    Minimum := (RGB.Red < RGB.Green) ? ((RGB.Red < RGB.Blue) ? RGB.Red : RGB.Blue) : ((RGB.Green < RGB.Blue) ? RGB.Green : RGB.Blue)
    Value := (RGB.Red > RGB.Green) ? ((RGB.Red > RGB.Blue) ? RGB.Red : RGB.Blue) : ((RGB.Green > RGB.Blue) ? RGB.Green : RGB.Blue)
    Delta := Value - Minimum
    If Delta = 0 ;pure blackness
        Return, Object("Hue",0,"Saturation",0,"Value",Value)

    If RGB.Red = Value ;between yellow and magenta
        Hue := (RGB.Green - RGB.Blue) / Delta
    Else If RGB.Green = Value ;between cyan and yellow
        Hue := 2 + ((RGB.Blue - RGB.Red) / Delta)
    Else ;between magenta and cyan
        Hue := 4 + ((RGB.Red - RGB.Green) / Delta)
    If Hue < 0
        Hue += 6
    Hue /= 6
    Return, Object("Hue",Hue,"Saturation",Delta / Value,"Value",Value)
}

HSVToRGB(HSV)
{
    Hue := HSV.Hue * 6
    Sector := Floor(Hue)
    FractionalHue := Hue - Sector
    Component1 := HSV.Value * (1 - HSV.Saturation)
    Component2 := HSV.Value * (1 - (HSV.Saturation * FractionalHue))
    Component3 := HSV.Value * (1 - (HSV.Saturation * (1 - FractionalHue)))

    If Sector = 0 ;zeroth sector
        Return, Object("Red",HSV.Value,"Green",Component3,"Blue",Component1)
    If Sector = 1 ;first sector
        Return, Object("Red",Component2,"Green",HSV.Value,"Blue",Component1)
    If Sector = 2 ;second sector
        Return, Object("Red",Component1,"Green",HSV.Value,"Blue",Component3)
    If Sector = 3 ;third sector
        Return, Object("Red",Component1,"Green",Component2,"Blue",HSV.Value)
    If Sector = 4 ;fourth sector
        Return, Object("Red",Component3,"Green",Component1,"Blue",HSV.Value)
    Return, Object("Red",HSV.Value,"Green",Component1,"Blue",Component2) ;fifth sector
}