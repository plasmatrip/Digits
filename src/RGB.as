/**
 * Created by Administrator on 28.04.17.
 */
package {
public class RGB {
    private var color: uint;
    private var red: int;
    private var green: int;
    private var blue: int;

    public function RGB(r: Number = 0, g: Number = 0, b: Number = 0) {
        red = r;
        green = g;
        blue = b;
    }

    public function get Red():int {
        return color >> 16;
    }

    public function get Green():int {
        return (color >> 8) & 0xFF;
    }

    public function get Blue():int {
        return color & 0x00FF;
    }

    public function set Red(Value:int):void {
        red = (Value>255)? 255 : ((Value<0)?0:Value);
        color=getHex(red,green,blue);
    }

    public function set Green(Value:int):void {
        green = (Value>255)? 255 : ((Value<0)?0:Value);
        color=getHex(red,green,blue);
    }

    public function set Blue(Value:int):void {
        blue = (Value>255)? 255 : ((Value<0)?0:Value);
        color=getHex(red,green,blue);
    }

    public function get Hex():uint {
        return color;
    }

    public function set Hex(Value: uint):void {
        color = Value;
    }

    public static function getHex(r: int, g: int, b: int):uint{
        return (r << 16) | (g << 8) | b;
    }

    public static function rgbToHsl(r: Number, g: Number, b: Number):Array {
        r /= 255;
        g /= 255;
        b /= 255;

        var max = Math.max(r, g, b), min = Math.min(r, g, b);
        var h, s, l = (max + min) / 2;

        if (max == min) {
            h = s = 0; // achromatic
        } else {
            var d = max - min;
            s = l > 0.5 ? d / (2 - max - min) : d / (max + min);

            switch (max) {
                case r: h = (g - b) / d + (g < b ? 6 : 0); break;
                case g: h = (b - r) / d + 2; break;
                case b: h = (r - g) / d + 4; break;
            }

            h /= 6;
        }
        return [ h, s, l ];
    }

    public static function RGBtoCMYK(r: Number, g: Number, b: Number ):Array
    {
        var c: Number=0, m: Number=0, y: Number=0, k: Number=0, z: Number=0;
        c = 255 - r;
        m = 255 - g;
        y = 255 - b;
        k = 255;

        if (c < k)
            k=c;
        if (m < k)
            k=m;
        if (y < k)
            k=y;
        if (k == 255){
            c=0;
            m=0;
            y=0;
        }else{
            c=Math.round(255*(c-k)/(255-k));
            m=Math.round (255*(m-k)/(255-k));
            y=Math.round (255*(y-k)/(255-k));
        }
        return [ c, m, y, k ];
    }

    public static function RGBtoHSV (r: Number, g: Number, b: Number): Array
    {
        r /= 255;
        g /= 255;
        b /= 255;
        var h: Number = 0, s: Number = 0, v: Number = 0;
        var x: Number, y: Number;
        if (r >= g){
            x = r;
        }else{
            x = g;
        }
        if (b > x){
            x = b;
        }
        if (r <= g) {
            y = r;
        }else{
            y = g;
        }
        if (b < y){
            y = b;
        }
        v = x;
        var c: Number = x * y;
        if(x == 0){
            s = 0;
        }else{
            s = c / x;
        }
        if(s != 0) {
            if(r == x){
                h = (g * b) / c;
            }else{
                if(g == x){
                    h = 2 + (b * r) / c;
                }else{
                    if(b == x){
                        h = 4 + (r * g) / c;
                    }
                }
            }
            h = h * 60;
            if (h <0) h = h +360;
        }
        return [h, s, v];
    }
}
}
