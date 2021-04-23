ResolveContacts(Duration,Contacts,Iterations) ;seconds
{
    Loop, %Iterations%
    {
        MaxVelocity := Infinity ;meters/seconds
        LargestContact := False
        For Index, Contact In Contacts
        {
            ;determine the relative velocity along the contact normal
            VelocityX := Contact.Entity1.VelocityX - Contact.Entity2.VelocityX ;meters/seconds = meters/seconds - meters/seconds
            VelocityY := Contact.Entity1.VelocityY - Contact.Entity2.VelocityY ;meters/seconds = meters/seconds - meters/seconds
            SeparatingVelocity := (VelocityX * Contact.NormalX) + (VelocityY * Contact.NormalY) ;meters/seconds = meters/seconds

            If (SeparatingVelocity < MaxVelocity)
            {
                If (SeparatingVelocity < 0 || Contact.Penetration > 0)
                {
                    MaxVelocity := SeparatingVelocity ;meters/seconds = meters/seconds
                    LargestContact := Contact
                }
            }
        }

        If !LargestContact ;no contacts to resolve
            Break

        Entity1X := LargestContact.Entity1.X, Entity1Y := LargestContact.Entity1.Y ;meters = meters, meters = meters
        Entity2X := LargestContact.Entity2.X, Entity2Y := LargestContact.Entity2.Y ;meters = meters, meters = meters
        LargestContact.Resolve(Duration) ;seconds
        Entity1X -= LargestContact.Entity1.X, Entity1Y -= LargestContact.Entity1.Y ;meters = meters, meters = meters
        Entity2X -= LargestContact.Entity2.X, Entity2Y -= LargestContact.Entity2.Y ;meters = meters, meters = meters

        ;update interpenetrations
        For Index, Contact In Contacts
        {
            If Contact.Entity1 = LargestContact.Entity1
                Contact.Penetration += (Entity1X * Contact.NormalX) + (Entity1Y * Contact.NormalY) ;meters = meters
            Else If Contact.Entity1 = LargestContact.Entity2
                Contact.Penetration += (Entity2X * Contact.NormalX) + (Entity2Y * Contact.NormalY) ;meters = meters
            If Contact.Entity2 = LargestContact.Entity1
                Contact.Penetration -= (Entity1X * Contact.NormalX) + (Entity1Y * Contact.NormalY) ;meters = meters
            Else If Contact.Entity2 = LargestContact.Entity2
                Contact.Penetration -= (Entity2X * Contact.NormalX) + (Entity2Y * Contact.NormalY) ;meters = meters
        }
    }
}

class Contact
{
    __New(Entity1,Entity2,X,Y,NormalX,NormalY,Penetration,Restitution) ;meters, meters,,, meters
    {
        this.Entity1 := Entity1
        this.Entity2 := Entity2
        this.X := X ;meters
        this.Y := Y ;meters
        this.NormalX := NormalX
        this.NormalY := NormalY
        this.Penetration := Penetration ;meters
        this.Restitution := Restitution
    }

    Resolve(Duration) ;seconds
    {
        this.ResolveVelocity(Duration) ;seconds
        this.ResolveInterpenetration(Duration) ;seconds
    }

    ResolveVelocity(Duration)
    {
        ;check if both entities have infinite mass
        If this.Entity1.Mass = Infinity && this.Entity2.Mass = Infinity
            Return

        ;determine the instantaneous velocity of entities at point of collision including linear motion caused by rotation
        Velocity1X := ((this.Entity1.AngularVelocity / Degrees) * (this.Y - this.Entity1.Y)) + this.Entity1.VelocityX ;meters/second = (degrees/second / degrees) * meters + meters/second
        Velocity1Y := ((this.Entity1.AngularVelocity / Degrees) * (this.X - this.Entity1.X)) + this.Entity1.VelocityY ;meters/second = (degrees/second / degrees) * meters + meters/second
        Velocity2X := ((this.Entity2.AngularVelocity / Degrees) * (this.Y - this.Entity2.Y)) + this.Entity2.VelocityX ;meters/second = (degrees/second / degrees) * meters + meters/second
        Velocity2Y := ((this.Entity2.AngularVelocity / Degrees) * (this.X - this.Entity2.X)) + this.Entity2.VelocityY ;meters/second = (degrees/second / degrees) * meters + meters/second
        VelocityX := Velocity1X - Velocity2X ;meters/seconds = meters/seconds - meters/seconds
        VelocityY := Velocity1Y - Velocity2Y ;meters/seconds = meters/seconds - meters/seconds

        ;determine the relative velocity along the contact normal
        SeparatingVelocity := (VelocityX * this.NormalX) + (VelocityY * this.NormalY) ;meters/seconds = meters/seconds
        If SeparatingVelocity >= 0 ;entities are separating or stationary relative to each other
            Return

        ;calculate the amount of impulse
        Ratio := (this.Entity1.Mass * this.Entity2.Mass) / (this.Entity1.Mass + this.Entity2.Mass)
        Impulse := SeparatingVelocity * (1 + this.Restitution) * Ratio ;kilograms*meters/seconds = meters/seconds / kilograms

        ;apply impulse
        this.Entity1.Impulse(this.X,this.Y,Impulse * -this.NormalX,Impulse * -this.NormalY) ;wip: offsets in world coords
        this.Entity2.Impulse(this.X,this.Y,Impulse * this.NormalX,Impulse * this.NormalY) ;wip: offsets in world coords
    }

    ResolveInterpenetration(Duration)
    {
        ;check if objects are interpenetrating
        If this.Penetration <= 0
            Return

        ;check if both entities have infinite mass
        If this.Entity1.Mass = Infinity && this.Entity2.Mass = Infinity
            Return

        ;calculate the amount of displacement for each entity
        TotalMass := this.Entity1.Mass + this.Entity2.Mass ;kilograms = kilograms + kilograms
        Displacement1 := this.Penetration * this.Entity2.Mass / TotalMass ;meters = meters * kilograms / kilograms
        Displacement2 := this.Penetration * this.Entity1.Mass / TotalMass ;meters = meters * kilograms / kilograms

        ;apply displacement
        this.Entity1.X += Displacement1 * this.NormalX ;meters = meters
        this.Entity1.Y += Displacement1 * this.NormalY ;meters = meters
        this.Entity2.X -= Displacement2 * this.NormalX ;meters = meters
        this.Entity2.Y -= Displacement2 * this.NormalY ;meters = meters
    }
}