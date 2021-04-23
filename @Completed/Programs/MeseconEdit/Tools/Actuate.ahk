#NoEnv

class Actuate
{
    Select()
    {
        Return, ["Punch","Walk Over","Inspect"]
    }

    Activate(Grid)
    {
        global Width, Height
        GetMouseCoordinates(Width,Height,MouseX,MouseY)
        Cell := Grid[MouseX,MouseY]

        GuiControlGet, Action, Main:, Subtools
        If (Action = "Punch")
            Cell.Punch()
        Else If (Action = "Walk Over")
            Cell.WalkOver()
        Else If (Action = "Inspect")
        {
            If Cell
            {
                Count := 0
                For IndexX, Column In Grid
                {
                    For IndexY, Node In Column
                    {
                        If Node.__Class = Cell.__Class
                            Count ++
                    }
                }
            }
            Else ;node is blank
                Count := "infinity"
            Info := "Node:`t`t" . (Cell ? Cell.__Class : "(None)")
                . "`nPosition:`t`t(" . MouseX . "," . MouseY . ",0)"
                . "`nAmount:`t`t1 of " . Count
                . "`nState:`t`t" . (Cell.HasKey("State") ? Cell.State : "(None)")
            ToolTip, %Info%,,, 20
            KeyWait, LButton
            ToolTip,,,, 20
        }
    }
}