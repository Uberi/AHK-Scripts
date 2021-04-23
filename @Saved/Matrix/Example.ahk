A := [[1,0,2]
     ,[2,3,1]]

B := [[1,2]
     ,[3,4]
     ,[5,6]
     ,[7,8]]

C := [[1]
     ,[4]]

D := [1,2,3,4]

E := [[2,3]
     ,[1,0]]
         
F := [[1,0,2]
     ,[2,3,1]
    ,[8,7,6]]
     
H := [[1,3,5,-1]
     ,[2,2,3, 0]
     ,[0,1,2, 3]
     ,[4,5,3, 2]]
       




zeros := Matrix.Zeros(6)
MsgBox % zeros.ToString()

identity := Matrix.Eye(6)
MsgBox % identity.ToString()

MsgBox % identity.Equals(zeros) ? "the matrices are equal" : "the matrices are NOT equal"


At := Matrix.Transpose(A)
MsgBox % Matrix.ToString(A) "`n`nTransposed`n" At.ToString() 


P := Matrix.Multiply(E, A)
MsgBox % Matrix.ToString(E) "`nmultiplicated by `n" Matrix.ToString(A) "`nyields:" Matrix.ToString(P)


AplusA := Matrix.Add(A,A)
MsgBox % "A added to A" Matrix.ToString(AplusA)

Amul3 := Matrix.MultiplyScalar(A,3)
MsgBox % "A multiplicated by 3" Matrix.ToString(Amul3)

det := Matrix.Det(H) ; calculate the determinant of matrix H
MsgBox % Matrix.ToString(H) "`nthe determinant is:`n" det

Hm := new Matrix(H) ; you can also use instances of the matrix class 
MsgBox % "using the matrix object:`n" Hm.ToString() "`nthe determinant is:`n" Hm.Det()


;
; 1. define a mirror matrix
; 2. define a rotation matrix
; 3. combine them to a single transformation matrix by multiplicating them
; 4. use it to transform a single 2D vertex
;

;1.
;y = 2*x
m := 2
M := Matrix.Mirror2D(m)

;2.
angleDegree := 90
radAngle :=  angleDegree * (45 / atan(1)) ; 90° degree to radians
R := Matrix.Rotate2D(radAngle)

;3. T = R * M
T := R.MultiplyRight(M)

;4. v --> vertex

v := [-2,5]

; v' = T * v
vTransformed := T.MultiplyRight(v)


; gaussian calculations (code provided by Babba/horst)
a:=[[2,0,1]
   ,[0,3,0]
   ,[10,0,-4]]

; calc the inverse of an matrix
msgbox % Matrix.Inverse(a).ToString()


/*
Solve a linear equation system like:

3x + 2y - z   =  1
2x - 2y + 4z  = -2
-x + 1/2y - z =  0

expected result:
x = 1
y = -2
z = -2

*/
s := [[ 3, 2, -1]
     ,[ 2,-2,  4]
     ,[-1,1/2,-1]]

b := [1
    ,-2
     ,0]

x := Matrix.Gauss(s,b)

MsgBox %  x.ToString()

ExitApp