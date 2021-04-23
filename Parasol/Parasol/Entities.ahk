class Particle extends Parasol.Entity
{
    __New(X,Y,VelocityX = 0,VelocityY = 0) ;meters, meters, meters/seconds, meters/seconds
    {
        this.X := X ;meters
        this.Y := Y ;meters
        this.Angle := 0 ;degrees
        this.VelocityX := VelocityX ;meters/seconds
        this.VelocityY := VelocityY ;meters/seconds
        this.AngularVelocity := 0 ;degrees/seconds
        this.ForceX := 0 ;Newtons
        this.ForceY := 0 ;Newtons
        this.Mass := 1 ;kilograms
    }

    Begin(Duration) ;seconds
    {
        this.ForceX := 0 ;Newtons
        this.ForceY := 0 ;Newtons
    }

    Impulse(X,Y,ImpulseX,ImpulseY) ;meters, meters, kilograms*meters/seconds, kilograms*meters/seconds
    {
        this.VelocityX += ImpulseX / this.Mass ;meters/seconds = kilograms*meters/seconds / kilograms
        this.VelocityY += ImpulseY / this.Mass ;meters/seconds = kilograms*meters/seconds / kilograms
    }

    Force(X,Y,ForceX,ForceY) ;meters, meters, Newtons, Newtons
    {
        this.ForceX += ForceX ;Newtons = Newtons
        this.ForceY += ForceY ;Newtons = Newtons
    }

    Torque(Value) ;Newtons*meters
    {
        
    }

    Transformed(X,Y,ByRef NewX,ByRef NewY) ;meters, meters, meters, meters
    {
        NewX := this.X + X
        NewY := this.Y + Y
    }

    End(Duration) ;seconds
    {
        ;calculate acceleration
        AccelerationX := this.ForceX / this.Mass ;meters/seconds^2 = kilograms*meters/seconds^2 / kilograms
        AccelerationY := this.ForceY / this.Mass ;meters/seconds^2 = kilograms*meters/seconds^2 / kilograms

        ;apply first half of acceleration (for more accurate integration at low frame rates)
        this.VelocityX += AccelerationX * Duration * 0.5 ;meters/seconds = meters/seconds^2 * seconds
        this.VelocityY += AccelerationY * Duration * 0.5 ;meters/seconds = meters/seconds^2 * seconds

        ;apply velocity
        this.X += this.VelocityX * Duration ;meters = meters/seconds * seconds
        this.Y += this.VelocityY * Duration ;meters = meters/seconds * seconds

        ;apply remaining acceleration
        this.VelocityX += AccelerationX * Duration * 0.5 ;meters/seconds = meters/seconds^2 * seconds
        this.VelocityY += AccelerationY * Duration * 0.5 ;meters/seconds = meters/seconds^2 * seconds
    }
}

class Polygon extends Parasol.Entity
{
    __New(X,Y,Points,Angle = 0,VelocityX = 0,VelocityY = 0,AngularVelocity = 0) ;meters, meters,, degrees, meters/second, meters/second, degrees/second
    {
        base.__New(X,Y,Angle,VelocityX,VelocityY,AngularVelocity)
        this.Points := Points
        ;wip: calculate mass and rotational inertia
    }
}