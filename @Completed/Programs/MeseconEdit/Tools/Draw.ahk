#NoEnv

class Draw
{
    static Nodes := Object("Blinky Plant",Nodes.BlinkyPlant
                          ,"Inverter",    Nodes.Inverter
                          ,"Mesecon",     Nodes.Mesecon
                          ,"Meselamp",    Nodes.Meselamp
                          ,"Plug",        Nodes.Plug
                          ,"Power Plant", Nodes.PowerPlant
                          ,"Sign",        Nodes.Sign
                          ,"Socket",      Nodes.Socket
                          ,"Solid",       Nodes.Solid
                          ,"Switch",       Nodes.Switch)

    Select()
    {
        SubTools := []
        For ToolName In this.Nodes
            SubTools.Insert(ToolName)
        Return, SubTools
    }

    Activate(Grid)
    {
        global Width, Height
        MouseX1 := ~0, MouseY1 := ~0
        While, GetKeyState("LButton","P")
        {
            GetMouseCoordinates(Width,Height,MouseX,MouseY)
            If (MouseX != MouseX1 || MouseY != MouseY1)
            {
                GuiControlGet, NodeName, Main:, Subtools

                Grid[MouseX,MouseY] := ""
                NodeClass := this.Nodes[NodeName]
                Grid[MouseX,MouseY] := new NodeClass(MouseX,MouseY)

                MouseX1 := MouseX, MouseY1 := MouseY
            }
            Sleep, 0
        }
    }
}