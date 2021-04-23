;AHK v1
#noEnv

;MsgBox % TriangleArea(0,0,1,0,0,2)

TriangleArea(X1,Y1,X2,Y2,X3,Y3)
{
    Return, Abs(((X1 * (Y2 - Y3))
               + (X2 * (Y3 - Y1))
               + (X3 * (Y1 - Y2)))
            / 2)
}