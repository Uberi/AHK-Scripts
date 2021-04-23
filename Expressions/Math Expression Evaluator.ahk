term1 := "10 * (10 + 12) / (5 * (8 + 2 * (1 + 3)) * (50 + 2))"
term2 := "1 * 2-1 * sin( cos(pi) )"
term3 := "sqrt(2^2/2)*(2**(1/2))"
term4 := "6 % 4"
term5 := "( 1 + 1 + 1 ) !"
term6 := "fib(6)"

MsgBox % calc("2 * 5 + sqrt(4)") ;1.383416 ms

msgbox % term1 " = " calc( term1 ) 
  . "`n" term2 " = " calc( term2 )
  . "`n" term3 " = " calc( term3 )
  . "`n" term4 " = " calc( term4 )
  . "`n" term5 " = " calc( term5 )
  . "`n" term6 " = " calc( term6 )
exitapp

calc( t, t0="", t1="", t2="" )
{   ; c-labeled functions by Laszlo: http://www.autohotkey.com/forum/topic17058.html
   static f := "sqrt|log|ln|exp|sin|cos|tan|asin|acos|atan|rad|deg|abs", c := "fib|gcb|min|max|sgn"
          o := "\*\*|\^|\*|/|//|\+|\-|%", pi:="pi", e:="e"
   if ( t0 = "fib"  && t1 != "" && t2 != "" ) {
      a := 0, b := 1 
      Loop % abs(t1)-1
         c := b, b += a, a := c
      return t1=0 ? 0 : t1>0 || t1&1 ? b : -b
   } else if ( t0 != "" && RegExMatch( t0, "(" f "|" c "|" o "|!)" ) && t1 != "" && t2 != "" )
      return t0 == "**" ? t1 ** t2 : t0 == "^" ? t1 ** t2 
           : t0 == "*" ? t1 * t2   : t0 == "/" ? t1 / t2 : t0 == "+" ? t1 + t2 : t0 == "-" ? t1 - t2
          : t0 == "//" ? t1 // t2 : t0 == "%" ? Mod( t1, t2 ) : t0 = "abs" ? abs( calc( t1 ) )
          : t0 == "!" ? ( t1 < 2 ? 1 : t1 * calc( t, t0, t1-1, 0 ) )
          : t0 = "log" ? log( calc( t1 ) ) : t0 = "ln" ? ln( calc ( t1 ) )
          : t0 = "sqrt" ? sqrt( calc( t1 ) ) : t0 = "exp" ? Exp( calc ( t1 ) )
          : t0 = "rad" ? calc( calc( t1 ) "* pi / 180" ) : t0 = "deg" ? calc( calc( t1 ) "* 180 / pi" )
          : t0 = "sin" ? sin( calc( "rad(" t1 ")" ) ) : t0 = "asin" ? asin( calc( "rad(" t1 ")" ) )
          : t0 = "cos" ? cos( calc( "rad(" t1 ")" ) ) : t0 = "acos" ? acos( calc( "rad(" t1 ")" ) )
          : t0 = "tan" ? tan( calc( "rad(" t1 ")" ) ) : t0 = "atan" ? atan( calc( "rad(" t1 ")" ) )
          : t0 = "min" ? ( t1 < t2 ? t1 : t2 ) : t0 = "max" ? ( t1 < t2 ? t2 : t1 )
          : t0 = "gcd" ? ( t2 = 0 ? abs(t1) : calc( t, t0, calc( t1 "%" t2 ) ) )
          : t0 = "sgn" ? (t1>0)-(t1<0) : 0
   
   t := RegExReplace( t, "\s*", "" )
   while ( RegExMatch( t, "i)" f "|" c "|" o "|" pi "|" e "|!" ) )
      if ( RegExMatch( t, "i)\b" pi "\b" ) )
         t := RegExReplace( t, "i)\b" pi "\b", 4 * atan(1) )
      else if ( RegExMatch( t, "i)\b" e "\b" ) )
         t := RegExReplace( t, "i)\b" e "\b", 2.718281828459045 )
      else if ( RegExMatch( t, "i)(" f "|" c ").*", s ) 
             && RegExMatch( s, "(?>[^\(\)]*)\((?>[^\(\)]*)(?R)*(?>[^\(\)]*)\)", m )
            && RegExMatch( m, "(?P<0>[^(]+)\((?P<1>[^,]*)(,(?P<2>.*))?\)", p ) )
         t := RegExReplace( t, "\Q" p "\E", calc( "", p0, p1, p2 != "" ? p2 : 0 ) )
      else if ( RegExMatch( t, "(?P<1>-*\d+(\.\d+)?)!", p) )
         t := RegExReplace( t, "\Q" p "\E", calc( "", "!", p1, 0 ) )
      else if ( RegExMatch( t, "\((?P<0>[^(]+)\)", p ) )
         t := RegExReplace( t, "\Q(" p0 ")\E", calc( p0 ) )
      else
         loop, parse, o, |
            while ( RegExMatch( t, "(?P<1>-*\d+(\.\d+)?)(?P<0>" A_LoopField ")(?P<2>-*\d+(\.\d+)?)", p ) )
               t := RegExReplace( t, "\Q" p "\E", calc( "", p0, p1, p2 ) )
   return t
}

esc::exitapp
