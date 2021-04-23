global Infinity := 0xFFFFFFFFFFFFFFF
global Degrees := 180 / 3.141592653589793

class Parasol
{
    __New()
    {
        this.Entities := Object()
        this.Generators := []
    }

    AddEntity(Entity)
    {
        this.Entities[Entity] := True
        Return, this
    }

    RemoveEntity(Entity)
    {
        If !this.Entities.HasKey(Entity)
            throw Exception("INVALID_INPUT",-1,"Entity not found.")
        this.Entities.Remove(Entity)
        Return, this
    }

    Register(Generator)
    {
        this.Generators.Insert(Generator)
        Return, this
    }

    Unregister(Generator)
    {
        For Index, Value In this.Generators
        {
            If (Generator = Value)
            {
                this.Generators.Remove(Index)
                Return, this
            }
        }
        throw Exception("INVALID_INPUT",-1,"Generator not found.")
    }

    Step(Duration)
    {
        For Entity In this.Entities
            Entity.Begin(Duration)

        this.Contacts := []

        ;step generators
        Index := 1
        For Index, Generator In this.Generators.Clone()
            Generator.Step(Duration,this)

        this.ResolveContacts(Duration,this.Contacts,this.Contacts.MaxIndex() * 2)

        For Entity In this.Entities
            Entity.End(Duration)

        Return, this
    }

    class Entity
    {
        __New(X,Y,Angle = 0,VelocityX = 0,VelocityY = 0,AngularVelocity = 0) ;meters, meters, degrees, meters/second, meters/second, degrees/second
        {
            this.X := X ;meters = meters
            this.Y := Y ;meters = meters
            this.Angle := Angle ;degrees = degrees
            this.VelocityX := VelocityX ;meters/second = meters/second
            this.VelocityY := VelocityY ;meters/second = meters/second
            this.AngularVelocity := AngularVelocity ;degrees/second = degrees/second
            this.ForceX := 0 ;Newtons
            this.ForceY := 0 ;Newtons
            this.ForceTorque := 0 ;Newton*meters
            this.Mass := 1 ;kilograms
            this.RotationalInertia := this.Mass * 0.1 ;kilograms*meters^2 = ;wip: calculate this properly
        }

        Begin(Duration) ;seconds
        {
            this.ForceX := 0 ;Newtons
            this.ForceY := 0 ;Newtons
            this.ForceTorque := 0 ;Newton*meters
        }

        Impulse(X,Y,ImpulseX,ImpulseY) ;meters, meters, kilograms*meters/second, kilograms*meters/second
        {
            ;apply impulse
            this.VelocityX += ImpulseX / this.Mass ;meters/second = kilograms*meters/second / kilogram
            this.VelocityY += ImpulseY / this.Mass ;meters/second = kilograms*meters/second / kilogram

            ;transform point into local, non-rotated coordinates
            X -= this.X ;meters = meters
            Y -= this.Y ;meters = meters

            ;determine the amount of impulsive torque (cross product of contact position and impulse) and change in rotational velocity
            ImpulsiveTorque := (X * ImpulseY) - (Y * ImpulseX) ;Newtons*meters*seconds = (meters * kilograms*meters/seconds) - (meters * kilograms*meters/seconds)
            AngularVelocity := (ImpulsiveTorque / this.RotationalInertia) * Degrees ;degrees/seconds = (Newtons*meters*seconds / kilograms*meters^2) * degrees

            ;determine linear component (cross product of rotational velocity and contact position)
            ;this.VelocityX += -(AngularVelocity / Degrees) * Y ;meters/seconds = (degrees/seconds / degrees) * meters
            ;this.VelocityY += (AngularVelocity / Degrees) * X ;meters/seconds = (degrees/seconds / degrees) * meters

            ;this.AngularVelocity += AngularVelocity ;degrees/seconds = degrees/seconds
        }

        Force(X,Y,ForceX,ForceY) ;meters, meters, Newtons, Newtons
        {
            ;apply force
            this.ForceX += ForceX ;Newtons = Newtons
            this.ForceY += ForceY ;Newtons = Newtons

            ;transform point into local, non-rotated coordinates
            X -= this.X ;meters = meters
            Y -= this.Y ;meters = meters

            ;add torque caused by force (cross product of displacement and force)
            this.ForceTorque += (X * ForceY) - (Y * ForceX) ;Newtons*meters = meters*Newtons
        }

        Torque(Value) ;Newtons*meters ;wip: support adding torque at position and add support for that in motor
        {
            this.ForceTorque += Value ;Newtons*meters = Newtons*meters
        }

        Transformed(X,Y,ByRef NewX,ByRef NewY) ;meters, meters, meters, meters
        {
            ;calculate rotation values
            Opposite := Sin(this.Angle / Degrees)
            Adjacent := Cos(this.Angle / Degrees)

            ;transform local coordinates to world coordinates
            NewX := this.X + (X * Adjacent) - (Y * Opposite) ;meters = meters + (meters * 1) + (meters * 1)
            NewY := this.Y + (X * Opposite) + (Y * Adjacent) ;meters = meters + (meters * 1) + (meters * 1)
        }

        End(Duration) ;seconds
        {
            ;calculate acceleration
            AccelerationX := this.ForceX / this.Mass ;meters/seconds^2 = kilograms*meters/seconds^2 / kilograms
            AccelerationY := this.ForceY / this.Mass ;meters/seconds^2 = kilograms*meters/seconds^2 / kilograms
            AngularAcceleration := this.ForceTorque / this.RotationalInertia ;degrees/seconds^2 = degrees * kilograms*meters^2/seconds^2 / kilograms*meters^2

            ;apply first half of acceleration (for more accurate integration at low frame rates)
            this.VelocityX += AccelerationX * Duration * 0.5 ;meters/seconds = meters/seconds^2 * seconds
            this.VelocityY += AccelerationY * Duration * 0.5 ;meters/seconds = meters/seconds^2 * seconds
            this.AngularVelocity += AngularAcceleration * Duration * 0.5 ;degrees/seconds = degrees/seconds^2 * seconds

            ;apply velocity
            this.X += this.VelocityX * Duration ;meters = meters/seconds * seconds
            this.Y += this.VelocityY * Duration ;meters = meters/seconds * seconds
            this.Angle += this.AngularVelocity * Duration ;degrees = degrees/seconds * seconds

            ;apply remaining acceleration
            this.VelocityX += AccelerationX * Duration * 0.5 ;meters/seconds = meters/seconds^2 * seconds
            this.VelocityY += AccelerationY * Duration * 0.5 ;meters/seconds = meters/seconds^2 * seconds
            this.AngularVelocity += AngularAcceleration * Duration * 0.5 ;degrees/seconds = degrees/seconds^2 * seconds
        }
    }

    #Include Contact.ahk
    #Include Entities.ahk
    #Include Generators/Simple.ahk
    #Include Generators/Linkages.ahk
    #Include Generators/Collision.ahk
}