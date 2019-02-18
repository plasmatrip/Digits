/**
 * Created by Никита on 21.05.2015.
 */
package Geom {
import flash.geom.Point;

public class AABB {
    public var center:Vec2D = new Vec2D();
    public var extents:Vec2D = new Vec2D();
    public var velocity:Vec2D = new Vec2D(0, 0);
    public var acceleration:Vec2D = new Vec2D(0, 0);

    private var _min:Vec2D;
    private var _max:Vec2D;
    private var _size:Vec2D;

    public function AABB(center:Vec2D, extents:Vec2D, velocity:Vec2D = null, acceleration:Vec2D = null) {
        this.center = center;
        this.extents = extents;
        if(velocity != null){
            this.velocity = velocity;
        }
        if(acceleration != null){
            this.acceleration = acceleration;
        }
    }

    /*public function move(velocity:Vec2D):void{
        center.x += velocity.x;
        center.y += velocity.y;
    }*/

    public function get min():Vec2D
    {
        return new Vec2D(center.x - extents.x, center.y - extents.y);
    }

    public function get max():Vec2D
    {
        return new Vec2D(center.x + extents.x, center.y + extents.y);
    }

    public function get size():Vec2D
    {
        return new Vec2D(extents.x * 2, extents.y * 2);
    }

    //вычисляем "разность" Минковского
    public function minkowskiDifference(other:AABB):AABB
    {
        var topLeft:Vec2D = Vec2D.subtractVectors(min, other.max);//A-B
        var fullSize:Vec2D = Vec2D.addVectors(size, other.size);//A+B
        return new AABB(Vec2D.addVectors(topLeft, Vec2D.divideByScalar(fullSize, 2)), Vec2D.divideByScalar(fullSize, 2));
    }

    //вычисляем ближайшую точку на гранях AABB "разности" Минковского к заданной точке (для вычиления вектора проникновения это начало координат)
    public function closestPointOnBoundsToPoint(point:Vec2D):Vec2D
    {
        var minDist:Number = Math.abs(point.x - min.x);
        var boundsPoint:Vec2D = new Vec2D(min.x, point.y);
        if (Math.abs(max.x - point.x) < minDist){
            minDist = Math.abs(max.x - point.x);
            boundsPoint = new Vec2D(max.x, point.y);
        }
        if (Math.abs(max.y - point.y) < minDist){
            minDist = Math.abs(max.y - point.y);
            boundsPoint = new Vec2D(point.x, max.y);
        }
        if (Math.abs(min.y - point.y) < minDist){
            //minDist = Math.abs(min.y - point.y);
            boundsPoint = new Vec2D(point.x, min.y);
        }
        return boundsPoint;
    }

    // taken from https://github.com/pgkelley4/line-segments-intersect/blob/master/js/line-segments-intersect.js
    // returns the point where they intersect (if they intersect)
    // returns null if they don't intersect
    private function getRayIntersectionFractionOfFirstRay(startA:Vec2D, endA:Vec2D, startB:Vec2D, endB:Vec2D):Number
    {
        var r:Vec2D = Vec2D.subtractVectors(endA, startA);
        var s:Vec2D = Vec2D.subtractVectors(endB, startB);
        var numerator:Number = Vec2D.crossProduct(Vec2D.subtractVectors(startB, startA), r);
        var denominator:Number = Vec2D.crossProduct(r, s);
        if (numerator == 0 && denominator == 0){
            // the lines are co-linear
            // check if they overlap
            /*return	((originB.x - startA.x < 0) != (originB.x - endA.x < 0) != (endB.x - startA.x < 0) != (endB.x - endA.x < 0)) ||
             ((originB.y - startA.y < 0) != (originB.y - endA.y < 0) != (endB.y - startA.y < 0) != (endB.y - endA.y < 0));*/
            return Number.POSITIVE_INFINITY;
        }
        if (denominator == 0){
            // lines are parallel
            return Number.POSITIVE_INFINITY;
        }
        var u:Number = numerator / denominator;
        var t:Number = Vec2D.crossProduct(Vec2D.subtractVectors(startB, startA), s) / denominator;
        if ((t >= 0) && (t <= 1) && (u >= 0) && (u <= 1)){
            //return startA + (r * t);
            return t;
        }
        return Number.POSITIVE_INFINITY;
    }

    public function getRayIntersectionFraction(origin:Vec2D, direction:Vec2D):Number
    {
        var end:Vec2D = Vec2D.addVectors(origin, direction);
        var minT:Number = getRayIntersectionFractionOfFirstRay(origin, end, new Vec2D(min.x, min.y), new Vec2D(min.x, max.y));
        var x:Number;
        x = getRayIntersectionFractionOfFirstRay(origin, end, new Vec2D(min.x, max.y), new Vec2D(max.x, max.y));
        if (x < minT){
            minT = x;
        }
        x = getRayIntersectionFractionOfFirstRay(origin, end, new Vec2D(max.x, max.y), new Vec2D(max.x, min.y));
        if (x < minT){
            minT = x;
        }
        x = getRayIntersectionFractionOfFirstRay(origin, end, new Vec2D(max.x, min.y), new Vec2D(min.x, min.y));
        if (x < minT){
            minT = x;
        }
        // ok, now we should have found the fractional component along the ray where we collided
        return minT;
    }

    public function getRayIntersection(start:Vec2D, end:Vec2D):Number
    {
        //var end:Vec2D = Vec2D.addVectors(origin, direction);
        var minT:Number = getRayIntersectionFractionOfFirstRay(start, end, new Vec2D(min.x, min.y), new Vec2D(min.x, max.y));
        var x:Number;
        x = getRayIntersectionFractionOfFirstRay(start, end, new Vec2D(min.x, max.y), new Vec2D(max.x, max.y));
        if (x < minT){
            minT = x;
        }
        x = getRayIntersectionFractionOfFirstRay(start, end, new Vec2D(max.x, max.y), new Vec2D(max.x, min.y));
        if (x < minT){
            minT = x;
        }
        x = getRayIntersectionFractionOfFirstRay(start, end, new Vec2D(max.x, min.y), new Vec2D(min.x, min.y));
        if (x < minT){
            minT = x;
        }
        // ok, now we should have found the fractional component along the ray where we collided
        return minT;
    }

    //определяем наличие пересечения двух AABB и вычисляем вектор проникновения
    public function checkIntersection(boxB:AABB):Vec2D{
        var penetrationVector:Vec2D = Vec2D.zero();
        var md:AABB = boxB.minkowskiDifference(this);
        if(md.min.x <= 0 && md.max.x >= 0 && md.min.y <= 0 && md.max.y >= 0)
        {
            penetrationVector = md.closestPointOnBoundsToPoint(Vec2D.zero());
        }
        return penetrationVector;
    }

    public function checkPointIntersection(point:Point):Boolean{
        if(point.x >= min.x && point.x <= max.x && point.y >= min.y && point.y <= max.y){
            return true;
        }
        return false;
    }
}
}
