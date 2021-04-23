class Spring
{
    __New(Entity1,Entity2,X1,Y1,X2,Y2,Length,Stiffness) ;meters, meters, meters, meters, meters, Newtons/meters
    {
        this.Entity1 := Entity1
        this.Entity2 := Entity2
        this.X1 := X1, this.Y1 := Y1 ;meters, meters
        this.X2 := X2, this.Y2 := Y2 ;meters, meters
        this.Length := Length ;meters
        this.Stiffness := Stiffness ;Newtons/meters
    }

    Step(Duration,Instance)
    {
        ;obtain world coordinates of attachment points
        this.Entity1.Transformed(this.X1,this.Y1,X1,Y1) ;meters, meters, meters, meters
        this.Entity2.Transformed(this.X2,this.Y2,X2,Y2) ;meters, meters, meters, meters

        DisplacementX := X2 - X1, DisplacementY := Y2 - Y1 ;meters = meters - meters, meters = meters - meters
        Distance := Sqrt((DisplacementX ** 2) + (DisplacementY ** 2)) ;meters = Sqrt(meters^2 + meters^2)
        If (Distance = this.Length) ;not stretched or compressed
            Return
        StretchForce := (Distance - this.Length) * this.Stiffness ;Newtons = meters * Newtons/meters
        StretchX := StretchForce * (DisplacementX / Distance) ;Newtons = Newtons * meters/meters
        StretchY := StretchForce * (DisplacementY / Distance) ;Newtons = Newtons * meters/meters
        this.Entity1.Force(X1,Y1,StretchX,StretchY) ;meters, meters, Newtons, Newtons
        this.Entity2.Force(X2,Y2,-StretchX,-StretchY) ;meters, meters, Newtons, Newtons
    }
}

class Bungee
{
    __New(Entity1,Entity2,X1,Y1,X2,Y2,Length,Stiffness) ;meters, meters, meters, meters, meters, Newtons/meters
    {
        this.Entity1 := Entity1
        this.Entity2 := Entity2
        this.X1 := X1, this.Y1 := Y1 ;meters, meters
        this.X2 := X2, this.Y2 := Y2 ;meters, meters
        this.Length := Length ;meters
        this.Stiffness := Stiffness ;Newtons/meter
    }

    Step(Duration,Instance)
    {
        ;obtain world coordinates of attachment points
        this.Entity1.Transformed(this.X1,this.Y1,X1,Y1) ;meters, meters, meters, meters
        this.Entity2.Transformed(this.X2,this.Y2,X2,Y2) ;meters, meters, meters, meters

        DisplacementX := X2 - X1, DisplacementY := Y2 - Y1 ;meters, meters
        Distance := Sqrt((DisplacementX ** 2) + (DisplacementY ** 2)) ;meters = Sqrt(meters^2 + meters^2)
        If (Distance <= this.Length) ;not stretched
            Return
        StretchForce := (Distance - this.Length) * this.Stiffness ;Newtons = meters * Newtons/meters
        StretchX := StretchForce * (DisplacementX / Distance) ;Newtons = Newtons * meters/meters
        StretchY := StretchForce * (DisplacementY / Distance) ;Newtons = Newtons * meters/meters
        this.Entity1.Force(X1,Y1,StretchX,StretchY) ;meters, meters, Newtons, Newtons
        this.Entity2.Force(X2,Y2,-StretchX,-StretchY) ;meters, meters, Newtons, Newtons
    }
}

class Cable
{
    __New(Entity1,Entity2,X1,Y1,X2,Y2,Length,Restitution) ;meters, meters, meters, meters, meters ;wip: X and Y attach points for this as well as rod
    {
        this.Entity1 := Entity1
        this.Entity2 := Entity2
        this.X1 := X1, this.Y1 := Y1 ;meters, meters
        this.X2 := X2, this.Y2 := Y2 ;meters, meters
        this.Length := Length ;meters
        this.Restitution := Restitution
    }

    Step(Duration,Instance)
    {
        ;obtain world coordinates of attachment points
        this.Entity1.Transformed(this.X1,this.Y1,X1,Y1) ;meters, meters, meters, meters
        this.Entity2.Transformed(this.X2,this.Y2,X2,Y2) ;meters, meters, meters, meters

        DisplacementX := X2 - X1, DisplacementY := Y2 - Y1 ;meters = meters - meters, meters = meters - meters
        Distance := Sqrt((DisplacementX ** 2) + (DisplacementY ** 2)) ;meters = Sqrt(meters^2 + meters^2)
        Penetration := Distance - this.Length ;meters = meters - meters
        If Penetration < 0 ;within cable limit
            Return
        NormalX := DisplacementX / Distance, NormalY := DisplacementY / Distance ;1 = meters / meters, 1 = meters / meters
        Contact := new Instance.Contact(this.Entity1,this.Entity2,0,0,NormalX,NormalY,Penetration,this.Restitution) ;meters, meters,,, meters
        Instance.Contacts.Insert(Contact)
        ;wip: offsets in world coords, and maybe needs two contacts, one per entity?
    }
}

class Rod
{
    __New(Entity1,Entity2,X1,Y1,X2,Y2,Length) ;meters, meters, meters, meters, meters
    {
        this.Entity1 := Entity1
        this.Entity2 := Entity2
        this.X1 := X1, this.Y1 := Y1 ;meters, meters
        this.X2 := X2, this.Y2 := Y2 ;meters, meters
        this.Length := Length ;meters
    }

    Step(Duration,Instance)
    {
        ;obtain world coordinates of attachment points
        this.Entity1.Transformed(this.X1,this.Y1,X1,Y1) ;meters, meters, meters, meters
        this.Entity2.Transformed(this.X2,this.Y2,X2,Y2) ;meters, meters, meters, meters

        DisplacementX := X2 - X1, DisplacementY := Y2 - Y1 ;meters = meters - meters, meters = meters - meters
        Distance := Sqrt((DisplacementX ** 2) + (DisplacementY ** 2)) ;meters = Sqrt(meters^2 + meters^2)
        Penetration := Distance - this.Length ;meters = meters - meters
        NormalX := DisplacementX / Distance, NormalY := DisplacementY / Distance ;1 = meters / meters, 1 = meters / meters
        If Penetration > 0 ;rod is overextended ;wip: both need offsets in world coords, maybe needs two contacts, one per entity?
            Contact := new Instance.Contact(this.Entity1,this.Entity2,0,0,NormalX,NormalY,Penetration,0) ;meters, meters,,, meters
        Else If Penetration < 0 ;rod is underextended
            Contact := new Instance.Contact(this.Entity1,this.Entity2,0,0,-NormalX,-NormalY,-Penetration,0) ;meters, meters,,, meters
        Else
            Return
        Instance.Contacts.Insert(Contact)
    }
}