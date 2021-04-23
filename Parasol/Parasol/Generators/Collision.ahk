class Collision
{
    Step(Duration,Instance)
    {
        ;broadphase collision
        Candidates := this.CollideCandidates(Instance.Entities)

        ;narrowphase collision
        For Index, Candidate In Candidates
        {
            Entity1 := Candidate[1]
            Entity2 := Candidate[2]

            Polygon1 := this.TransformedPolygon(Entity1.Points,Entity1.X,Entity1.Y,Entity1.Angle)
            Polygon2 := this.TransformedPolygon(Entity2.Points,Entity2.X,Entity2.Y,Entity2.Angle)

            Value := this.CollidePolygonPolygon(Polygon1,Polygon2)
            If Value ;objects are colliding
            {
                Contact := new Instance.Contact(Entity1,Entity2,Value.X,Value.Y,Value.NormalX,Value.NormalY,Value.Overlap,0.5) ;wip: give restitution value
                Instance.Contacts.Insert(Contact)
            }
        }
    }

    TransformedPolygon(Points,X,Y,Angle)
    {
        Opposite := Sin(Angle / Degrees)
        Adjacent := Cos(Angle / Degrees)
        RotatedPolygon := []
        For Index, Point In Points
            RotatedPolygon[Index] := {X: X + (Point.X * Adjacent) - (Point.Y * Opposite)
                                    , Y: Y + (Point.X * Opposite) + (Point.Y * Adjacent)}
        Return, RotatedPolygon
    }

    CollideCandidates(Entities)
    {
        ;broadphase collision ;wip: optimise this by using a spatial tree
        Candidates := []
        For Entity1 In Entities
        {
            For Entity2 In Entities
            {
                If (&Entity1 < &Entity2)
                    Candidates.Insert([Entity1, Entity2])
            }
        }
        Return, Candidates
    }

    ;determines whether two polygons are colliding
    CollidePolygonPolygon(Polygon1,Polygon2)
    {
        ;create a list of all vertices in both polygons
        Vertices := Polygon1.Clone()
        Vertices.Insert(Vertices.MaxIndex() + 1,Polygon2*)

        ;test each separating axis candidate in each polygon
        Normals := []
        Overlap := Infinity
        Overlap := this.TestPolygon(Polygon1,Polygon2,Overlap,NormalX,NormalY,Vertices,Normals,1)
        If Overlap = 0
            Return, False
        Overlap := this.TestPolygon(Polygon2,Polygon1,Overlap,NormalX,NormalY,Vertices,Normals,-1)
        If Overlap = 0
            Return, False

        ;determine the average point of collision
        MaxIndex := Vertices.MaxIndex()
        X := 0, Y := 0
        If MaxIndex ;points of collision are available
        {
            For Index, Vertex In Vertices
                X += Vertex.X, Y += Vertex.Y
        }
        Else ;points of collision are not available
        {
            ;estimate point of collision as the average of all vertices
            MaxIndex := Polygon1.MaxIndex() + Polygon2.MaxIndex()
            For Index, Vertex In Polygon1
                X += Vertex.X, Y += Vertex.Y
            For Index, Vertex In Polygon2
                X += Vertex.X, Y += Vertex.Y
        }
        X /= MaxIndex, Y /= MaxIndex

        ;no separating axis found, objects are colliding
        Return, {X: X, Y: Y, NormalX: NormalX, NormalY: NormalY, Overlap: Overlap}
    }

    ;checks each normal of each edge of the first polygon for a separating axis
    TestPolygon(Polygon1,Polygon2,MinimumOverlap,ByRef CollisionNormalX,ByRef CollisionNormalY,ByRef Vertices,ByRef Normals,Direction)
    {
        MaxIndex1 := Polygon1.MaxIndex()
        Loop, %MaxIndex1% ;loop through all edges of the first polygon
        {
            Vertex1 := Polygon1[A_Index] ;first point of edge
            Vertex2 := Polygon1[(A_Index = MaxIndex1) ? 1 : (A_Index + 1)] ;second point of edge

            ;calculate one of the line's normals as the axis to test
            NormalX := Vertex1.Y - Vertex2.Y, NormalY := Vertex2.X - Vertex1.X
            Length := Sqrt((NormalX ** 2) + (NormalY ** 2))
            If Length = 0 ;ignore doubled points
                Continue
            NormalX /= Length, NormalY /= Length

            ;check if axis has already been processed
            If Normals[NormalX, NormalY] || Normals[-NormalX, -NormalY]
                Continue
            Normals[NormalX, NormalY] := True ;ensure axis only once

            ;find the extents of the polygons in the axis to test
            this.ProjectExtents(Polygon1,NormalX,NormalY,Minimum1,Maximum1)
            this.ProjectExtents(Polygon2,NormalX,NormalY,Minimum2,Maximum2)

            ;determine the amount by which the extents overlap
            Minimum := (Minimum1 < Minimum2) ? Minimum2 : Minimum1
            Maximum := (Maximum1 > Maximum2) ? Maximum2 : Maximum1
            Overlap := Maximum - Minimum
            If Overlap <= 0 ;not overlapping
                Return, 0

            ;eliminate vertices that fall outside of the overlapping extents
            Index := 1
            While, Index <= Vertices.MaxIndex()
            {
                Vertex := Vertices[Index]
                Extent := (Vertex.X * NormalX) + (Vertex.Y * NormalY)
                If (Extent < Minimum || Extent > Maximum)
                    Vertices.Remove(Index)
                Else
                    Index ++
            }

            ;current axis has lowest overlap
            If (Overlap < MinimumOverlap)
            {
                ;store collision normal and overlap amount
                MinimumOverlap := Overlap
                If (Minimum1 > Minimum2)
                    CollisionNormalX := NormalX * Direction, CollisionNormalY := NormalY * Direction
                Else
                    CollisionNormalX := -NormalX * Direction, CollisionNormalY := -NormalY * Direction
            }
        }
        Return, MinimumOverlap
    }

    ;determines the extents of a polygon along a given axis
    ProjectExtents(Polygon,NormalX,NormalY,ByRef Minimum,ByRef Maximum)
    {
        Minimum := Infinity
        Maximum := -Infinity
        For Index, Vertex In Polygon
        {
            ;project current vertex onto axis using dot product and check the extent
            Extent := (Vertex.X * NormalX) + (Vertex.Y * NormalY)
            If (Extent < Minimum)
                Minimum := Extent
            If (Extent > Maximum)
                Maximum := Extent
        }
    }
}