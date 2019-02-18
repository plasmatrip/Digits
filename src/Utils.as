/**
 * Created by Администратор on 02.09.15.
 */
package {
public class Utils {
    public static function roundToDecimal (base:Number, decimalPlace:int):Number
    {
        return Math.round(base * decimalPlace)/decimalPlace;
    }
}
}
