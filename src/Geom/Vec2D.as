/**
 * Created by Никита on 21.05.2015.
 */
package Geom {
public class Vec2D {
    public var x:Number;
    public var y:Number;

    private var _length:Number;
    private var _normalized:Vec2D;
    private var _tangent:Vec2D;

    public function Vec2D(x:Number = 0, y:Number = 0):void {
        this.x = x;
        this.y = y;
    }

    public function set(x:Number = 0, y:Number = 0):void{
        this.x = x;
        this.y = y;
    }

    public static function direction(angle:Number):Vec2D{
        var _x:Number = Math.sin(angle * Math.PI / 180);
        var _y:Number = Math.cos(angle * Math.PI / 180);
        return new Vec2D(_x,_y);
    }

    public static function zero():Vec2D{
        return new Vec2D(0,0);
    }

    public function get length():Number
    {
        return Math.sqrt((this.x * this.x) + (this.y * (this.y)));
    }

    public function get normalized():Vec2D
    {
        var l:Number = length;
        if (l != 0){
            return new Vec2D(x / l, y / l);
        }
        return new Vec2D(0, 0);
    }

    public function get tangent():Vec2D
    {
        return new Vec2D(-this.y, this.x);
    }

    public static function squareDistance(a:Vec2D, b:Vec2D):Number
    {
        return (a.x - b.x) * (a.x - b.x) + (a.y - b.y) * (a.y - b.y);
    }

    public function isZero():Boolean
    {
        return this.x == 0 && this.y == 0;
    }

    //A * s
    public static function multiplyScalar(a:Vec2D, s:Number):Vec2D
    {
        return new Vec2D(a.x * s, a.y * s);
    }

    //A / B
    public static function divideByScalar(a:Vec2D, s:Number):Vec2D
    {
        return new Vec2D(a.x / s, a.y / s);
    }

    //A + B
    public static function addVectors(a:Vec2D, b:Vec2D):Vec2D
    {
        return new Vec2D(a.x + b.x, a.y + b.y);
    }

    //A - B
    public static function subtractVectors(a:Vec2D, b:Vec2D):Vec2D
    {
        return new Vec2D(a.x - b.x, a.y - b.y);
    }

    //A * B
    public static function crossProduct(a:Vec2D, b:Vec2D):Number
    {
        return (a.x * b.y - a.y * b.x);
    }

    public static function dotProduct(a:Vec2D, b:Vec2D):Number
    {
        return a.x * b.x + a.y * b.y;
    }

    public function toString():String
    {
        return "[" + this.x + ", " + this.y + "]";
    }

}
}
