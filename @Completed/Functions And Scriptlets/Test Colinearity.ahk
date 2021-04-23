#NoEnv

;MsgBox % IsColinear(0,0,0,0.5,0,1)

IsColinear(Point1X,Point1Y,Point2X,Point2Y,Point3X,Point3Y)
{
 Return, ((Point1X - Point3X) * (Point2Y - Point3Y)) = ((Point2X - Point3X) * (Point1Y - Point3Y))
}