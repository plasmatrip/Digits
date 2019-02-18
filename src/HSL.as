/**
 * Created by Administrator on 28.04.17.
 */
package {
public class HSL {
    private var luminance:Number;
    private var saturation:Number;
    private var hue:Number;

    public function HSL(h: Number = 0, s: Number = 1, l: Number = 0.5){
        hue = h;
        saturation = s;
        luminance = l;
    }

    public function get Hue():Number {
        return hue;
    }

    public function get Saturation():Number {
        return saturation;
    }

    public function get Luminance():Number {
        return luminance;
    }

    public function set Hue(Value: Number):void {
        hue = (Value > 360) ? Value - 360 : ((Value < 0) ? Value + 360 : Value);
    }

    public function set Saturation(Value: Number):void {
        saturation = (Value > 1) ? 1 : ((Value < 0) ? 0 : Value);
    }

    public function set Luminance(Value: Number):void {
        luminance = (Value > 1) ? 1 : ((Value < 0) ? 0 : Value);
    }

    public function toRGB():RGB{
        return getRGB(hue, saturation, luminance);
    }

    public function toHex():uint {
        return toRGB().Hex;
    }

    public static function getHex(h: Number, s: Number, l: Number):uint{
        return getRGB(h, s, l).Hex;
    }

    public static function getRGB(h: Number, s: Number, l: Number):RGB{
        h = h / 360;
        var r: Number;
        var g: Number;
        var b: Number;

        if(l == 0){
            r = g = b = 0;
        }else{
            if(s == 0){
                r = g = b = l;
            }else{
                var t2: Number = (l <= 0.5) ? l * (1 + s) : l + s - (l * s);
                var t1: Number = 2 * l - t2;
                var t3: Vector.<Number> = new Vector.<Number>();
                t3.push(h + 1 / 3);
                t3.push(h);
                t3.push(h - 1 / 3);
                var clr:Vector.<Number> = new Vector.<Number>();
                clr.push(0);
                clr.push(0);
                clr.push(0);
                for(var i: int = 0; i < 3; i++){
                    if(t3[i]<0) {
                        t3[i] += 1;
                    }
                    if(t3[i]>1) {
                        t3[i] -= 1;
                    }
                    if(6*t3[i] < 1) {
                        clr[i] = t1 + (t2 - t1) * t3[i] * 6;
                    }else if(2*t3[i]<1) {
                        clr[i] = t2;
                    }else if(3*t3[i]<2) {
                        clr[i] = (t1 + (t2 - t1) * ((2 / 3) - t3[i]) * 6);
                    }else {
                        clr[i] = t1;
                    }
                }
                r = clr[0];
                g = clr[1];
                b = clr[2];
            }
        }
        return new RGB(int(r * 255), int(g * 255), int(b * 255));
    }
}
}
