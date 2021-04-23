Pi := 3.141592653589793
MsgBox % (ATan2(0,1) = Pi / 2)
       . (ATan2(1,Sqrt(3)) = Pi / 3)
       . (ATan2(-1,0) = Pi)
       . (ATan2(1,0) = 0)

ATan2(x,y)
{
    static Pi := 3.141592653589793
    If x > 0
        Return, ATan(y / x)
    If x < 0
    {
        If y >= 0
            Return, ATan(y / x) + Pi
        ;y < 0
        Return, ATan(y / x) - Pi
    }
    ;x = 0
    If y > 0
        Return, Pi / 2
    If y < 0
        Return, -Pi / 2
    ;y = 0
    Return, "" ;undefined
}