#NoEnv

;/*
MsgBox % RandomChoose([4, 1, 0, 3])
MsgBox % RandomChooseOnce([4, 1, 0, 3])
MsgBox % (new RandomChooser([4, 1, 0, 3])).Choose()
*/

;chooses and returns an index within `Weights` randomly such that indices with higher weights have a better chance of being chosen
RandomChoose(Weights) ;array of weight values to assign to each index
{
    ;find sum of all weights
    Total := 0
    For Index, Weight In Weights
        Total += Weight

    ;choose a random index by weight
    Random, Value, 0.0, Total
    For Index, Weight In Weights
    {
        Value -= Weight
        If Value <= 0
            Return, Index
    }
}

;chooses and returns an index within `Weights` randomly such that indices with higher weights have a better chance of being chosen, while only iterating through the array once (slower roulette/king-of-the-hill method)
RandomChooseOnce(Weights)
{
    Total := 0
    Choice := 1
    For Index, Weight In Weights
    {
        Total += Weight
        Random, Value, 0.0, Total
        If (Value <= Weight)
            Choice := Index
    }
    Return, Choice
}

class RandomChooser
{
    __New(Weights)
    {
        ;create strictly increasing list of sums of weights up to a given index
        Total := 0
        this.Totals := []
        For Index, Weight In Weights
        {
            Total += Weight
            this.Totals[Index] := Total
        }
    }

    Choose()
    {
        Lower := 1, Higher := this.Totals.MaxIndex()
        Random, Value, 0.0, this.Totals[Higher]

        ;see where the value fits in the list of weights in sorted order using binary search
        While, Lower < Higher
        {
            Pivot := (Lower + Higher) // 2
            If (Value < this.Totals[Pivot])
                Higher := Pivot
            Else
                Lower := Pivot + 1
        }
        Return, Lower
    }
}