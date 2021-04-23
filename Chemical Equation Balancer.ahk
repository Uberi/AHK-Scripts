#NoEnv

;wip: 2Al + 3H2SO4 -> 3H2 + Al2S3O12

Gui, Font, s18 Bold, Arial
Gui, Add, Text, x2 y0 w470 h40, Enter a chemical equation to balance:
Gui, Font, Norm
Gui, Add, Edit, x2 y40 w470 h40 vEquation gStartBalance, Al + H2SO4 -> H2 + Al2S3O12
Gui, Font, s12
Gui, Add, Edit, x2 y90 w470 h25 vResult ReadOnly
Gui, +ToolWindow +AlwaysOnTop
Gui, Show, w475 h120, Equation Balancer
Gosub, Balance
Return

GuiClose:
ExitApp

StartBalance:
SetTimer, Balance, -500
Return

Balance:
GuiControlGet, Equation,, Equation
If !RegExMatch(Equation,"S)^\s*(\d*[A-Z][\da-zA-Z]*\s*(?:\+\s*\d*[A-Z][\da-zA-Z]*\s*)*)->\s*(\d*[A-Z][\da-zA-Z]*\s*(?:\+\s*\d*[A-Z][\da-zA-Z]*\s*)*)$",Match)
{
    GuiControl,, Result, Invalid equation.
    Return
}

LeftSide := []
RightSide := []

LeftTerms := []
RightTerms := []

For Index, Entry In [[LeftSide,Match1,LeftTerms],[RightSide,Match2,RightTerms]]
{
    Side := Entry[1], Match := Entry[2], Terms := Entry[3]

    TermPos := 1
    While, TermPos := RegExMatch(Match,"OS)\d*\K[A-Z][\da-zA-Z]*",TermMatch,TermPos)
    {
        Value := TermMatch.Value(0)
        Terms.Insert(Value)
        
        Side[A_Index] := Term := {}
        FactorPos := 1
        While, FactorPos := RegExMatch(Value,"OS)([A-Z][a-z]*)(\d*)",FactorMatch,FactorPos)
        {
            Amount := FactorMatch.Value(2)
            If !Amount
                Amount := 1
            Term[FactorMatch.Value(1)] := Amount
            FactorPos += FactorMatch.Len(0)
        }
        TermPos += TermMatch.Len(0)
    }
}

Result := BalanceChemicalEquation(LeftSide,RightSide)
MsgBox % ShowObject(Result)
;wip
GuiControl,, Result, %Value%
Return

BalanceChemicalEquation(LeftSide,RightSide)
{
    ;count elements and assign a row number to each one
    Elements := {}
    Rows := 0
    For Index, Term In LeftSide
    {
        For Element, Amount In Term
        {
            If !Elements.HasKey(Element)
            {
                Rows ++
                Elements[Element] := Rows
            }
        }
    }

    ;initialize the matrix
    Columns := LeftSide.MaxIndex() + RightSide.MaxIndex() + 1
    Matrix := []
    Loop, %Rows%
    {
        Row := Matrix[A_Index] := []
        Loop, %Columns%
            Row[A_Index] := 0
    }

    ;fill the matrix with the amount of each element in each term (LeftSide[Element]-RightSide[Element]=0)
    For Index, Term In LeftSide
    {
        For Element, Amount In Term
            Matrix[Elements[Element],Index] := Amount
    }
    Columns := LeftSide.MaxIndex()
    For Index, Term In RightSide
    {
        For Element, Amount In Term
            Matrix[Elements[Element],Index + Columns] := -Amount
    }

    Result := LinearSystemSolve(Matrix)

    ;convert result entries into integers
    GCD := new Fraction(0)
    For Index, Entry In Result
        GCD.GCD(Entry)
    For Index, Entry In Result
        Result[Index] := -Result[Index].Divide(GCD).Numerator
    Result.Insert(GCD.Denominator)

    Return, Result
}

#Include @Completed/Functions and Scriptlets/Fraction/Fraction.ahk

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