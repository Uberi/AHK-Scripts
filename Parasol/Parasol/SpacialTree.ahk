class Rectangle
{
    __New(X,Y,W,H)
    {
        this.X := X
        this.Y := Y
        this.W := W
        this.H := H
    }
}

class SpatialNode
{
    __New(Entity = False,Child1 = False,Child2 = False,Parent = False)
    {
        this.Leaf := IsObject(Entity)
        this.Entity := Entity
        this.Child1 := Child1
        this.Child2 := Child2
        this.Parent := Parent, ObjRelease(Parent) ;weak reference to parent
        If this.Leaf ;leaf node
        {
            ;wip: do real bounds calculations
            this.X := Entity.X
            this.Y := Entity.Y
            this.W := Entity.W
            this.H := Entity.H
        }
        Else ;parent node
            this.Recalculate()
    }

    Add(Entity)
    {
        If this.Leaf ;leaf node
        {
            ;convert this node into the parent node of its entity and the new entity
            this.Leaf := False
            this.Child1 := new this.base(this.Entity) ;wip: this needlessly recalculates bounds
            this.Child2 := new this.base(Entity)
            this.Entity := False
            ;wip: set child parent to this
        }
        Else ;parent node
        {
            ;insert entity into child that would grow least to incorporate it
            If this.Child1.Growth(Entity) < this.Child2.Growth(Entity)
                this.Child1.Add(Entity)
            Else
                this.Child2.Add(Entity)
        }
        this.Recalculate()
    }

    Remove(Entity)
    {
        ;wip
    }

    Growth(Entity)
    {
        Child := this.Leaf ? this : this.Child1
        X1 := (Child.X < Entity.X) ? Child.X : Entity.X
        X2 := ((Child.X + Child.W) > (Entity.X + Entity.W))
            ? (Child.X + Child.W) : (Entity.X + Entity.W)
        Y1 := (Child.Y < Entity.Y) ? Child.Y : Entity.Y
        Y2 := ((Child.Y + Child.H) > (Entity.Y + Entity.H))
            ? (Child.Y + Child.H) : (Entity.Y + Entity.H)
        Return, (this.W - (X2 - X1)) * (this.H - (Y2 - Y1))
    }

    Recalculate()
    {
        ;recalculate bounds
        X1 := (this.Child1.X < this.Child2.X) ? this.Child1.X : this.Child2.X
        X2 := ((this.Child1.X + this.Child1.W) > (this.Child2.X + this.Child2.W))
            ? (this.Child1.X + this.Child1.W) : (this.Child2.X + this.Child2.W)
        Y1 := (this.Child1.Y < this.Child2.Y) ? this.Child1.Y : this.Child2.Y
        Y2 := ((this.Child1.Y + this.Child1.H) > (this.Child2.Y + this.Child2.H))
            ? (this.Child1.Y + this.Child1.H) : (this.Child2.Y + this.Child2.H)
        this.X := (X1 + X2) / 2
        this.Y := (Y1 + Y2) / 2
        this.W := X2 - X1
        this.H := Y2 - Y1

        If this.Parent ;node has parent
        {
            ;wip: recalculate parent nodes (add this.Parent)
        }
    }
}