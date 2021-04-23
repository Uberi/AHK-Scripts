class Force
{
    __New(Entity,X,Y,ForceX,ForceY,Local = False) ;meters, meters, Newtons, Newtons
    {
        this.Entity := Entity
        this.X := X ;meters = meters
        this.Y := Y ;meters = meters
        this.ForceX := ForceX ;Newtons = Newtons
        this.ForceY := ForceY ;Newtons = Newtons
        this.Local := Local
    }

    Step(Duration,Instance)
    {
        this.Entity.Transformed(this.X,this.Y,X,Y) ;meters, meters, meters, meters
        If this.Local ;direction of the force is in local coordinates
        {
            this.Entity.Transformed(this.ForceX,this.ForceY,ForceX,ForceY) ;meters, meters, meters, meters
            ForceX -= this.Entity.X, ForceY -= this.Entity.Y
            this.Entity.Force(X,Y,ForceX,ForceY) ;meters, meters, Newtons, Newtons
        }
        Else ;direction of the force is is world coordinates
            this.Entity.Force(X,Y,this.ForceX,this.ForceY) ;meters, meters, Newtons, Newtons
    }
}

class Motor
{
    __New(Entity,Torque) ;wip: apply torque at one specific point on the object
    {
        this.Entity := Entity
        this.Torque := Torque ;Newtons*meters
    }

    Step(Duration,Instance)
    {
        this.Entity.Torque(this.Torque) ;Newtons*meters
    }
}

class Drag
{
    __New(Entity,Coefficient)
    {
        this.Entity := Entity
        this.Coefficient := Coefficient ;drag coefficient ;wip: should have one along each axis
    }

    Step(Duration,Instance)
    {
        ;apply linear drag
        this.Entity.Force(this.Entity.X,this.Entity.Y,this.Coefficient * -this.Entity.VelocityX,this.Coefficient * -this.Entity.VelocityY) ;meters, meters, meters/seconds, meters/seconds

        ;apply rotational drag
        this.Entity.Torque(this.Coefficient * -this.Entity.AngularVelocity) ;degrees/seconds
    }
}

class Gravity
{
    __New(Entity,Acceleration = 9.81) ;meters/seconds^2
    {
        this.Entity := Entity
        this.Amount := Acceleration ;meters/seconds^2 = meters/seconds^2
    }

    Step(Duration,Instance)
    {
        If this.Entity.Mass < Infinity
            this.Entity.Force(this.Entity.X,this.Entity.Y,0,this.Entity.Mass * this.Amount) ;meters, meters, Newtons, kilograms * meters/seconds^2
    }
}