For Key In new Iterator(1,5)
    MsgBox %Key%

class Iterator
{
    __New(Start,End)
    {
        this.Start := Start
        this.End := End
    }

    _NewEnum()
    {
        Return, new Iterator.Enumerator(this.Start,this.End)
    }

    class Enumerator
    {
        __New(Start,End)
        {
            this.Start := Start
            this.End := End
            this.Index := Start
        }

        Next(ByRef Key)
        {
            Key := this.Index
            this.Index ++
            Return, Key <= this.End
        }
    }
}