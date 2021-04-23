#NoEnv

global Infinity := 0xFFFFFFFF

;/*
#Warn All
#Warn LocalSameAsGlobal, Off

Field := "
( LTrim0 RTrim0
     #            
     #            
     #      #   # 
     #^     #   # 
     ######## # ##
            ##    
    #             
    #            #
  ### ############
 ##               
 ###############  
 ##               
 ##               
    #             
 ###              
 ##               
 ##     $         
                  
)"
Field := "
( LTrim0 RTrim0
             
    #        
    #        
  ^ #      $ 
    #        
             
)"
Grid := []
Start := {X: 1, Y: 1}, Goal := {X: 1, Y: 1}
Loop, Parse, Field, `n
{
    A_Index1 := A_Index
    Loop, Parse, A_LoopField
    {
        If (A_LoopField = "^")
            Start.X := A_Index1, Start.Y := A_Index
        Else If (A_LoopField = "$")
            Goal.X := A_Index1, Goal.Y := A_Index
        Grid[A_Index1,A_Index] := A_LoopField = "#"
    }
}

p := new PathfinderPresets.Grid8(Grid)
Path := p.Run(Start,Goal)

Symbols := "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
For Key, Node In Path
    Grid[Node.X,Node.Y] := SubStr(Symbols,Mod(A_Index - 1,StrLen(Symbols)) + 1,1)
Result := ""

For _, Row In Grid
{
    For _, Cell In Row
        Result .= Cell = 1 ? "#" : Cell ? Cell : " "
    Result .= "`n"
}
FileAppend, %Result%, *
ExitApp

Esc::ExitApp
*/

;wip: multiple goals: add Goals.Multiple and Heuristics.Multiple - heuristic should return Min(BaseHeuristic(Node,Goal1),BaseHeuristic(Node,Goal2),...)
;wip: getting as close as possible to unreachable goals: make a path to the node with the lowest heuristic value, or maybe set infinity to a lower value so it can get through at high cost?

class PathfinderPresets
{
    class Grid4 extends Pathfinder
    {
        __New(Grid)
        {
            this.Grid := Grid
        }

        static Goal := Goals.At
        static Adjacent := Adjacents.Grid4
        static Cost := Costs.Equal
        static Heuristic := Heuristics.Manhattan
    }

    class Grid8 extends Pathfinder
    {
        __New(Grid)
        {
            this.Grid := Grid
        }

        static Goal := Goals.At
        static Adjacent := Adjacents.Grid8
        static Cost := Costs.Diagonal
        static Heuristic := Heuristics.ChebyshevModified
    }
}

class Goals
{
    None(Node,Goal)
    {
        Return, True
    }

    At(Node,Goal)
    {
        Return, Node.X = Goal.X && Node.Y = Goal.Y
    }

    Beside(Node,Goal)
    {
        Return, (Abs(Goal.X - Node.X) + Abs(Goal.Y - Node.Y)) <= 1
    }
}

class Adjacents
{
    None(Node)
    {
        Return, []
    }

    ;useful for rectangular grid with 4 movement directions
    Grid4(Node)
    {
        Return, [{X: Node.X - 1, Y: Node.Y}
                ,{X: Node.X + 1, Y: Node.Y}
                ,{X: Node.X, Y: Node.Y - 1}
                ,{X: Node.X, Y: Node.Y + 1}]
    }

    ;useful for rectangular grid with 8 movement directions
    Grid8(Node)
    {
        Return, [{X: Node.X - 1, Y: Node.Y}
                ,{X: Node.X + 1, Y: Node.Y}
                ,{X: Node.X, Y: Node.Y - 1}
                ,{X: Node.X, Y: Node.Y + 1}
                ,{X: Node.X - 1, Y: Node.Y - 1}
                ,{X: Node.X + 1, Y: Node.Y - 1}
                ,{X: Node.X - 1, Y: Node.Y + 1}
                ,{X: Node.X + 1, Y: Node.Y + 1}]
    }
}

class Costs
{
    ;useful for blank maps
    None()
    {
        Return, 1
    }

    ;useful for rectangular grid with equal movement speeds in all directions
    Equal(Node,Neighbor)
    {
        If Neighbor.X < 1 || Neighbor.X > this.Grid.MaxIndex() || Neighbor.Y < 1 || Neighbor.Y > this.Grid[1].MaxIndex()
            Return, Infinity
        If this.Grid[Neighbor.X,Neighbor.Y]
            Return, Infinity
        Return, 1
    }

    ;useful for rectangular grid with different diagonal movement speeds
    Diagonal(Node,Neighbor)
    {
        static DiagonalCost := Sqrt(2)
        If Neighbor.X < 1 || Neighbor.X > this.Grid.MaxIndex() || Neighbor.Y < 1 || Neighbor.Y > this.Grid[1].MaxIndex()
            Return, Infinity
        If this.Grid[Neighbor.X,Neighbor.Y]
            Return, Infinity
        If Node.X != Neighbor.X && Node.Y != Neighbor.Y ;diagonal movement
        {
            If this.Grid[Node.X,Neighbor.Y] && this.Grid[Neighbor.X,Node.Y] ;wall corner
                Return, Infinity
            Return, DiagonalCost
        }
        Return, 1
    }

    Physical(Node,Neighbor)
    {
        ;wip: consider turns, acceleration, decceration, speed, momentum
        Return, 1
    }
}

class Heuristics
{
    ;useful for when it is not possible to estimate the target search progress
    None(Node,Start,Goal)
    {
        ;without a heuristic, the A-star pathfinder simplifies to Dijkstra's algorithm
        Return, 0
    }

    ;useful for rectangular grid with 4 movement directions
    Manhattan(Node,Start,Goal)
    {
        ;Manhattan distance - distance if movements can only be orthogonal
        Return, Abs(Goal.X - Node.X) + Abs(Goal.Y - Node.Y)
    }

    ;useful for rectangular grid with 8 movement directions with equal cost
    Chebyshev(Node,Start,Goal)
    {
        ;Chebyshev distance - distance if movements can only be orthogonal or diagonal
        DeltaX := Abs(Goal.X - Node.X), DeltaY := Abs(Goal.Y - Node.Y)
        Return, DeltaX > DeltaY ? DeltaX : DeltaY
    }

    ;useful for rectangular grid with 8 movement directions with different diagonal cost
    ChebyshevModified(Node,Start,Goal)
    {
        static DiagonalCost := Sqrt(2)

        ;modified Chebyshev distance with diagonal movement more expensive than orthogonal
        DeltaX := Abs(Goal.X - Node.X), DeltaY := Abs(Goal.Y - Node.Y)
        If (DeltaX > DeltaY)
            Return, (DeltaY * DiagonalCost) + (DeltaX - DeltaY)
        Return, (DeltaX * DiagonalCost) + (DeltaY - DeltaX)
    }

    ;useful for rectangular grid with any movement direction
    Euclidean(Node,Start,Goal)
    {
        ;Euclidean distance - distance if travelling straight to the goal
        Return, Sqrt((Goal.X - Node.X) ** 2 + (Goal.Y - Node.Y) ** 2)
    }
}

class Pathfinder
{
    __New()
    {
        this.Goal := Goals.None
        this.Adjacent := Adjacents.None
        this.Costs := Costs.None
        this.Heuristic := Heuristics.None
    }

    Run(Start,Goal)
    {
        CurrentScores := [], CurrentScores[Start.X,Start.Y] := 0 ;map of current scores
        TotalScores := [], TotalScores[Start.X,Start.Y] := 0 ;map of total scores

        OpenHeap := new this.NodeHeap(TotalScores), OpenHeap.Add(Start) ;heap of open nodes
        OpenMap := [], OpenMap[Start.X,Start.Y] := True ;map of open nodes
        ClosedMap := [] ;map of visited nodes
        HeuristicMap := [] ;heuristic cache map
        Parents := [] ;mapping of nodes to their parents

        While, OpenHeap.Count() > 0 ;loop while there are entries in the open list
        {
            ;select node having the lowest total score
            Node := OpenHeap.Pop()

            If this.Goal(Node,Goal) ;goal reached
            {
                ;reconstruct the best path
                Path := [Node]
                While, Node.X != Start.X || Node.Y != Start.Y ;loop backwards through path until reaching the beginning
                {
                    Node := Parents[Node.X,Node.Y]
                    Path.Insert(1,Node)
                }
                Return, Path
            }

            OpenMap[Node.X,Node.Y] := 0 ;remove the entry from the open map
            ClosedMap[Node.X,Node.Y] := 1 ;mark node as visited

            For Index, Neighbor In this.Adjacent(Node)
            {
                If ClosedMap[Neighbor.X,Neighbor.Y] ;node already visited
                    Continue

                MovementCost := this.Cost(Node,Neighbor) ;cost of moving from the current node to the neighbor node
                If (MovementCost = Infinity) ;movement not possible
                    Continue

                NewScore := CurrentScores[Node.X,Node.Y] + MovementCost ;add the cost to the current score
                If OpenMap[Neighbor.X,Neighbor.Y] ;node in open heap
                {
                    If (NewScore < CurrentScores[Neighbor.X,Neighbor.Y]) ;better path found
                    {
                        ;update scores and path
                        CurrentScores[Neighbor.X,Neighbor.Y] := NewScore
                        TotalScores[Neighbor.X,Neighbor.Y] := NewScore + HeuristicMap[Neighbor.X,Neighbor.Y]
                        Parents[Neighbor.X,Neighbor.Y] := Node
                    }
                }
                Else ;node not in open heap
                {
                    HeuristicMap[Neighbor.X,Neighbor.Y] := this.Heuristic(Neighbor,Start,Goal)

                    ;update scores and path
                    CurrentScores[Neighbor.X,Neighbor.Y] := NewScore
                    TotalScores[Neighbor.X,Neighbor.Y] := NewScore + HeuristicMap[Neighbor.X,Neighbor.Y]
                    Parents[Neighbor.X,Neighbor.Y] := Node

                    OpenMap[Neighbor.X,Neighbor.Y] := True ;add the entry to the open map
                    OpenHeap.Add(Neighbor) ;add node to open heap
                }
            }
        }
        Return, [] ;could not find a path
    }

    class NodeHeap extends BinaryHeap
    {
        __New(TotalScores)
        {
            base.__New()
            this.TotalScores := TotalScores
        }

        Compare(Value1,Value2)
        {
            Return, this.TotalScores[Value1.X,Value1.Y] < this.TotalScores[Value2.X,Value2.Y]
        }
    }
}

class BinaryHeap
{
    __New()
    {
        this.Data := []
    }

    Add(Value)
    {
        Index := this.Data.MaxIndex(), Index := Index ? (Index + 1) : 1

        ;append value to heap array
        this.Data[Index] := Value

        ;rearrange the array to satisfy the minimum heap property
        ParentIndex := Index >> 1
        While, Index > 1 && this.Compare(this.Data[Index],this.Data[ParentIndex]) ;child entry is less than its parent
        {
            ;swap the two elements so that the child entry is greater than its parent
            Temp1 := this.Data[ParentIndex]
            this.Data[ParentIndex] := this.Data[Index]
            this.Data[Index] := Temp1

            ;move to the parent entry
            Index := ParentIndex, ParentIndex >>= 1
        }
    }

    Peek()
    {
        If !this.Data.MaxIndex()
            throw Exception("Cannot obtain minimum entry from empty heap.",-1)
        Return, this.Data[1]
    }

    Pop()
    {
        MaxIndex := this.Data.MaxIndex()
        If !MaxIndex ;no entries in the heap
            throw Exception("Cannot pop minimum entry off of empty heap.",-1)

        Minimum := this.Data[1] ;obtain the minimum value in the heap

        ;move the last entry in the heap to the beginning
        this.Data[1] := this.Data[MaxIndex]
        this.Data.Remove(MaxIndex), MaxIndex --

        ;rearrange array to satisfy the heap property
        Index := 1, ChildIndex := 2
        While, ChildIndex <= MaxIndex
        {
            ;obtain the index of the lower of the two child nodes if there are two of them
            If (ChildIndex < MaxIndex && this.Compare(this.Data[ChildIndex + 1],this.Data[ChildIndex]))
                ChildIndex ++

            ;stop updating if the parent is less than or equal to the child
            If this.Compare(this.Data[Index],this.Data[ChildIndex])
                Break

            ;swap the two elements so that the child entry is greater than the parent
            Temp1 := this.Data[Index]
            this.Data[Index] := this.Data[ChildIndex]
            this.Data[ChildIndex] := Temp1

            ;move to the child entry
            Index := ChildIndex, ChildIndex <<= 1
        }

        Return, Minimum
    }

    Count()
    {
        Value := this.Data.MaxIndex()
        Return, Value ? Value : 0
    }

    Compare(Value1,Value2)
    {
        Return, Value1 < Value2
    }
}