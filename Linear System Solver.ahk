#NoEnv

/*
MsgBox % ShowObject(LinearSystemSolve([[2,  4, 6,  8, 10,  0]
                                      ,[1,  3, 5,  8,  3, -1]
                                      ,[3,  8, 9, 20,  3,  5]
                                      ,[4,  8, 9, -2,  3,  8]
                                      ,[5, -3, 3, -2,  1,  0]]))
*/

;/*
MsgBox % ShowObject(LinearSystemSolve([[ 2,  1, -1,   8]    ; 2x + y -  z =   8
                                      ,[-3, -1,  2, -11]    ;-3x - y + 2z = -11
                                      ,[-2,  1,  2,  -3]])) ;-2x + y + 2z =  -3
*/

Gui, Font, s24, Arial
Gui, Add, Text, x10 y10 w500 h40, Enter a system of linear equations:

Gui, Show
Return

GuiClose:
ExitApp

;wip: inline fractions code for smaller size
#Include @Completed/Functions and Scriptlets/Fraction/Fraction.ahk

#Warn All
#Warn LocalSameAsGlobal, Off

;/*
LinearSystemSolve(Matrix)
{
    Unknowns := Matrix.MaxIndex()

    ;convert each number into a fraction
    Loop, %Unknowns%
    {
        Row := Matrix[A_Index]
        Loop, % Row.MaxIndex()
            Row[A_Index] := new Fraction(Row[A_Index])
    }

    Column := 0
    Loop, % Unknowns - 1
    {
        Column ++

        ;find the row with the largest value in the current column
        RowMaximum := Column
        RowIndex := Column
        While, RowIndex < Unknowns ;iterate through each row after the current one
        {
            RowIndex ++ ;obtain the row index
            If Matrix[RowIndex][Column].Clone().Abs().Greater(Matrix[RowMaximum][Column].Clone().Abs()) ;value greater than previous maximum
                RowMaximum := RowIndex
        }

        ;swap the maximum row and the current row
        Row := Matrix[Column]
        Matrix[Column] := Matrix[RowMaximum]
        Matrix[RowMaximum] := Row

        ;check if the matrix has a singular unique solution
        If Matrix[Column][Column].Numerator = 0
            throw Exception("Could not find singular unique solution.")

        ;eliminate the unknown in the current column
        RowIndex := Column
        While, RowIndex < Unknowns ;iterate through each row after the current one
        {
            RowIndex ++ ;obtain the row index
            Index := Unknowns + 1
            While, Index >= Column
            {
                Matrix[RowIndex][Index].Subtract(Matrix[Column][Index].Clone().Multiply(Matrix[RowIndex][Column]).Divide(Matrix[Column][Column]))
                Index --
            }
        }
    }

    ;substitute known coefficients for unknowns
    Result := []
    RowIndex := Unknowns
    While, RowIndex > 0 ;loop through each unknown backwards
    {
        Row := Matrix[RowIndex]
        Value := new Fraction(0)
        Index := Unknowns
        While, Index > RowIndex
            Value.Add(Result[Index].Clone().Multiply(Row[Index])), Index --
        Result[RowIndex] := Row[Unknowns + 1].Clone().Subtract(Value).Divide(Row[RowIndex])
        RowIndex --
    }

    Return, Result
}
*/

/*
LinearSystemSolve(Matrix)
{
    Unknowns := Matrix.MaxIndex()
    Column := 0
    Loop, % Unknowns - 1
    {
        Column ++

        ;find the row with the largest value in the current column
        RowMaximum := Column
        RowIndex := Column
        While, RowIndex < Unknowns ;iterate through each row after the current one
        {
            RowIndex ++ ;obtain the row index
            If Abs(Matrix[RowIndex][Column]) > Abs(Matrix[RowMaximum][Column]) ;value greater than previous maximum
                RowMaximum := RowIndex
        }

        ;swap the maximum row and the current row
        Row := Matrix[Column]
        Matrix[Column] := Matrix[RowMaximum]
        Matrix[RowMaximum] := Row

        ;check if the matrix has a singular unique solution
        If Abs(Matrix[Column][Column]) < 0.000001 ;wip: this might need to be 0 (0x=5)
            throw Exception("Could not find singular unique solution.")

        ;eliminate the unknown in the current column
        RowIndex := Column
        While, RowIndex < Unknowns ;iterate through each row after the current one
        {
            RowIndex ++ ;obtain the row index
            Index := Unknowns + 1
            While, Index >= Column
            {
                Matrix[RowIndex][Index] -= (Matrix[Column][Index] * Matrix[RowIndex][Column]) / Matrix[Column][Column]
                Index --
            }
        }
    }

    ;substitute known coefficients for unknowns
    Result := []
    RowIndex := Unknowns
    While, RowIndex > 0 ;loop through each unknown backwards
    {
        Row := Matrix[RowIndex]
        Value := 0
        Index := Unknowns
        While, Index > RowIndex
            Value += Result[Index] * Row[Index], Index --
        Result[RowIndex] := (Row[Unknowns + 1] - Value) / Row[RowIndex]
        RowIndex --
    }

    Return, Result
}