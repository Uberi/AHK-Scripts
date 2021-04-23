
class BigInt
{
    mult( nb ) {
        global BigInt
        if nb.__Class == "BigInt"
        {
            b := nb
            ins := []
            layers := []
            loop b._MaxIndex()
            {
                lay := this.Mult(b[A_Index])
                if ins._maxindex()
                    lay.insert(1, ins*)
                ins.insert(0)
                layers.insert(lay)
            }
            ret := layers.remove()
            ret._sum(layers)
            ret.neg := b.neg * this.neg
            return ret
        }
        n := nb
        if n == 0 OR this.eq(0)
            return new BigInt(0)
        if Abs(n) == 1
        {
            ret := this.clone()
            ret.neg := ret.neg * n
            return ret
        }
        if this.abs().eq(1)
            return new BigInt(n * this.neg)
        
        ret := new BigInt(0)
        ret.neg := this.neg * sign(n)
        carry := 0
        n := Abs(Floor(n))
        loop this._MaxIndex()
        {
            t := this[A_Index] * n + carry
            carry := t < 0 ? ~(-(t >> 32))+1 : t >> 32
            ret[A_Index] := Abs(t & 0xffffffff)
        }
        if carry
            ret.insert(carry)
        return ret
    }
    
    sum( nbs ) {
        ret := this.clone()
        ret._sum(nbs)
        return ret
    }
    
    _sum( nbs ) {
        global BigInt
        while nb := nbs.remove()
        {
            b := nb.__class = "BigInt" ? nb : new BigInt(nb)
            if b.neg == this.neg ;signs are equal
                ThisNegative := 1, BNegative := 1
            else if this.abs().gt(b.abs()) ;this has a greater magnitude than b
                ThisNegative := 1, BNegative := -1
            else ;this has a lesser magnitude than b
                this.neg := b.neg, ThisNegative := -1, BNegative := 1
            carry := 0
            loop max(b._MaxIndex(), this._MaxIndex())
            {
                t := (this[A_Index] OR 0)*ThisNegative + (b[A_Index] OR 0)*BNegative + carry
                if t < 0
                    this[A_Index] := t + 0x100000000, carry := -1
                else
                    this[A_Index] := t & 0xFFFFFFFF, carry := t >> 32
            }
            if carry
                this.insert(carry)
        }
        this._trim()
    }
    
    add( nb ) {
        return this.sum([nb])
    }
    
    _add( nb ) {
        this._sum([nb])
    }
    
    sub( nb ) {
        ret := this.clone()
        ret._sub(nb)
        return ret
    }
    
    _sub( nb ) {
        Global BigInt
        b := nb.__class = "BigInt" ? nb.clone() : new BigInt(nb)
        b.neg := -b.neg
        this._sum([b])
    }
    
    div( D, ByRef R := 0 ) {
        ret := this.clone()
        ErrorLevel := IsByRef(R) ? ret._div(D,R) : ret._div(D)
        return ret
    }
    
    _div( D, ByRef R := 0 ) {
    ; adapted from BigInt lib from http://sourceforge.net/projects/cpp-bigint/
        global BigInt
        if D.__class != "BigInt"
            D := new BigInt(D)
        else
            D := D.clone()
        N := this.clone()
        neg := N.neg * D.neg
        N.neg := 1
        D.neg := 1
        
        iD := D.clone()
        iN := N.clone()
        
        ; TODO: check N > D
        ; TODO: check D > 0
        ; TODO: check N > 0
        if D.eq(0) 
            return "Error: Can't divide by zero" 
        
        this.remove("", Chr(A_IsUnicode ? 65535 : 255)) ; remove string keys
        this.remove(this._minindex(),this._maxindex())  ; remove integer keys
        this.__new() ; re-initialize this
        
        shiftcnt := 0
        while D.lt(N)
            D._shl(), shiftcnt++
        if D.gt(N)
            D._shr(), shiftcnt--
        
        if shiftcnt >= 0
            loop shiftcnt+1
            {
                this._shl()
                if D.lteq(N)
                    N._sub(D)
                    , this._add(1)
                D._shr()
            }
        if IsByRef(R)
            R := iN.sub(iD.mult(this))
        this.neg := neg
    }
    
    maxbit() {
        bits := (this._maxindex() - 1) * 32
        x := this[this._maxindex()]
        while x
            bits++, x := x >> 1
        return bits
    }
    
    pow( nb ) {
        global BigInt
        b := nb.__class = "BigInt" ? nb : new BigInt(nb)
        if b.neg == -1
            return "Error: Exponent must be positive."
        return BigInt._power(this, b)
    }
    
    _power( x, n ) {
        global BigInt
        if x.eq(0)
            return new BigInt(0)
        if x.eq(1) OR n.eq(0)
            return new BigInt(1)
        if n.eq(1)
            return x.clone()
        if n[1] & 1  ; odd
            return x.mult(BigInt._power(x.mult(x), n.shr()))
        return BigInt._power(x.mult(x), n.shr())  ; even
    }
    
    shl( n := 1 ) {
        ret := this.clone()
        ret._shl(n)
        return ret
    }
    
    _shl( n := 1 ) {
        loop n//32
            this.insert(1, 0)
        n := mod(n,32)
        m := (0xffffffff << (32-n)) & 0xffffffff
        c := 0
        loop this._maxindex()
            ct := (this[A_Index] & m) >> (32-n)
            , this[A_Index] := ((this[A_Index] << n) & 0xffffffff) | c
            , c := ct
        if c
            this.insert(c)
        this._trim()
    }
    
    shr( n := 1 ) {
        ret := this.clone()
        ret._shr(n)
        return ret
    }
    
    _shr( n := 1 ) {
        if n//32
        {
            this.remove(1, n//32)
            n := mod(n,32)
            if !this._maxindex()
                this.insert(0)
        }
        m := 0xffffffff >> (32 - n)
        loop this._maxindex()
            this[A_Index] := (this[A_Index] >> n) | (((this[A_Index+1] OR 0) & m) << (32-n))
        this._trim()
    }
    
    or( nb ) {
        ret := this.clone()
        ret._or(nb)
        return ret
    }
    
    _or( nb ) {
        global BigInt
        b := nb.__class = "BigInt" ? nb : new BigInt(nb)
        loop b._maxindex()
            this[A_Index] := (this[A_Index] OR 0) | b[A_Index]
        return this
    }
    
    and( nb ) {
        ret := this.clone()
        ret._and(nb)
        return ret
    }
    
    _and( nb ) {
        global BigInt
        b := nb.__class = "BigInt" ? nb : new BigInt(nb)
        loop max(b._maxindex(), this._maxindex())
            this[A_Index] := (this[A_Index] OR 0) & (b[A_Index] OR 0)
        this._trim()
        return this
    }
    
    xor( nb ) {
        ret := this.clone()
        ret._xor(nb)
        return ret
    }
    
    _xor( nb ) {
        global BigInt
        b := nb.__class = "BigInt" ? nb : new BigInt(nb)
        loop b._maxindex()
            this[A_Index] := (this[A_Index] OR 0) ^ b[A_Index]
        return ret
    }
    
    not( m := "" ) {
        ret := this.clone()
        ret._not(m)
        return ret
    }
    
    _not( m := "" ) {
        m := max(this.maxbit(), m)
        loop m // 32
            this[A_Index] := ~this[A_Index] & 0xffffffff
        if mod(m, 32)
            this[this._maxindex()] := ~this[this._maxindex()] & (0xffffffff >> (32-mod(m,32)))
    }
    
    sqrt() {
    
    }
    
    rotr() {
    
    }
    
    rotl() {
    
    }
    
    gt( nb ) {
        global BigInt
        b := nb.__class = "BigInt" ? nb : new BigInt(nb)
        if this.neg != b.neg
            return this.neg > b.neg
        if this._maxindex()*this.neg < b._maxindex()*b.neg
            return false
        i := max(this._maxindex(), b._maxindex())
        while i
        {
            x := (this[i] OR 0)*this.neg
            y := (b[i] OR 0)*b.neg
            if x == y
                i--
            else
                return x > y
        }
        return false
    }
    
    gteq( nb ) {
        return this.gt(nb) OR this.eq(nb)
    }
    
    lt( nb ) {
        global BigInt
        b := nb.__class = "BigInt" ? nb : new BigInt(nb)
        if this.neg != b.neg
            return this.neg < b.neg
        if this._maxindex()*this.neg > b._maxindex()*b.neg
            return false
        i := max(this._maxindex(), b._maxindex())
        while i
        {
            x := (this[i] OR 0)*this.neg
            y := (b[i] OR 0)*b.neg
            if x == y
                i--
            else
                return x < y
        }
        return false
    }
    
    lteq( nb ) {
        return this.lt(nb) OR this.eq(nb)
    }
    
    eq( nb ) {
        global BigInt
        b := nb.__class = "BigInt" ? nb : new BigInt(nb)
        if this._maxindex() != b._maxindex() OR this.neg != b.neg
            return false
        loop this._maxindex()
            if this[A_Index] != b[A_Index]
                return false
        return true
    }
    
    noteq( nb ) {
        return !this.eq(nb)
    }
    
    abs() {
        ret := this.clone()
        ret._abs()
        return ret
    }
    
    _abs() {
        this.neg := 1
    }
    
    _trim() {
        ; delete leading zeros
        while this[this._maxindex()] == 0 AND this._maxindex() != 1
            this.remove()
        ; zero cannot be negative
        if this._maxindex() == 1 AND this[1] == 0
            this.neg := 1
    }
    
    __new( ByRef x := 0, options := '', chars := '' ) {
        ; support options:
        ;   x is bytearray (must be byref)(big or little edian)
        ;   
        if options == ''
        {
            this.neg := sign(x)
            carry := Abs(Floor(x)) >> 32
            this[1] := Abs(Floor(x)) & 0xffffffff
            if carry
                this[2] := carry
        }
        if options = 'hex'
        {
            this.neg := substr(x,1,1) == '-' ? -1 : 1
            this[1] := 0
            if this.neg == -1
                x := substr(x,2)
            if substr(x,1,2) == '0x'
                x := substr(x,3)
            while x
            {
                y := substr(x,-8)
                this[A_Index] := ("0x" y) + 0
                x := substr(x, 1, -8)
            }
        }
        this._trim()
        return this
    }
    
    __string( format := "hex" ) {
        ; add little-edian format
        ; add octal format
        ; add decimal format
        if format = "hex"
            loop this._maxindex()
                ret := format("{1:08x}", this[A_Index]) ret
        else if format = "bin"
            loop this._maxindex()
                ret := substr("0000000000000000000000000000000000000000" bin(this[A_Index]), -32) ret
        return (this.neg < 0 ? "-" : "") ret
    }

}

sign(x) {
    return x < 0 ? -1 : 1
}

bin(x){
	while x OR A_Index == 1
		r:=1&x r,x>>=1
	return r
}

#singleinstance, force

/*
BigInt::Rossi BigInt::Rossi::sqrt()		// Returns the square root of this
{
    BigInt::Rossi ret;
    BigInt::Rossi tmp;
    BigInt::Rossi delta;

    BigInt::Rossi mask (RossiTwo);

    tmp = *this;
    mask = -mask;

    std::size_t i = 0;
    ret = tmp; 
    for (i = 0; ret != RossiZero; ret >>= 1, i++)
    {
        // Do nothing
    }

    ret = tmp; 
    for (std::size_t j = 0; j < std::size_t(i >> 1); ret >>= 1, j++)
    {
        // Do nothing
    }

    do
    {
        // -----------------------------------------------
        // We are really performing the fuction:
        //	 delta = (tmp/ret - ret) / 2;
        //   below, but since these are unsigned numbers,
        //   we MUST do the subtraction last in order for
        //   the ret = ret + delta;  equation to work properly.
        // -----------------------------------------------

        delta = ( tmp >> BigInt::Ulong(1)) / ret - (ret >> BigInt::Ulong(1));
        ret = ret + delta;
    } while ((delta &= mask) != RossiZero);

    return ret;
}
*/
