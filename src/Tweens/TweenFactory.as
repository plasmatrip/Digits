/**
 * Created by Администратор on 15.10.15.
 */
package Tweens {

import flash.geom.Point;

import starling.animation.Transitions;

public class TweenFactory {
    public static const MOVE_OUT:String = 'Move_Out';

    public function TweenFactory() {
    }

    public static function getTween(tweenType:String):Function{
        var func:Function = null;
        switch (tweenType){
            case MOVE_OUT:
                func = MoveOut;
                break;
        }
        return func;
    }

    private static function MoveOut(target:Object, time:Number, position:Point, onComplete:Function,  onCompleteParam:Array, transition:Object = Transitions.LINEAR):void{
        onComplete();
    }
}
}
