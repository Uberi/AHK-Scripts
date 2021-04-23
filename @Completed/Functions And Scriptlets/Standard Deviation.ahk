#NoEnv

;MsgBox % StandardDeviation([1,2,3,4,5,6,7,8,9])

StandardDeviation(DataList,IsSample = 0) ;Welford's algorithm
{
    If !ObjMaxIndex(DataList) ;no entries
        throw Exception("Data contains no entries.")

    Counter := 0
    Mean := 0
    Accumulated := 0

    For Index, Value In DataList
    {
        Counter ++
        Delta := Value - Mean
        Mean += Delta / Counter
        Accumulated += Delta * (Value - Mean)
    }
    Return, Sqrt(Accumulated / (Counter - !!IsSample))
}

StandardDeviation1(DataList,IsSample = 0) ;two-pass algorithm, more numerically stable
{
    If !ObjMaxIndex(DataList) ;no entries
        throw Exception("Data contains no entries.")

    Counter := 0
    Sum := 0
    For Index, Value In DataList
    {
        Counter ++
        Sum += Value
    }
    Mean := Sum / Counter

    Sum := 0
    For Index, Value In DataList
        Sum += (Value - Mean) ** 2

    Variance := Sum / (Counter - !!IsSample)
}