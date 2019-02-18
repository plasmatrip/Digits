/**
 * Created by Administrator on 04.08.16.
 */
package Screens {
import starling.animation.Transitions;
import starling.animation.Tween;
import starling.core.Starling;
import starling.display.Image;
import starling.display.Sprite;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;
import starling.textures.Texture;

public class ScrBuySong extends GameScreen{
    private var buy1:Sprite;
    private var buy2:Sprite;

    public function ScrBuySong(param:Object = null) {
        var img:Image = new Image(Texture.fromColor(Const.stageWidth, Const.stageHeight, 0x000000, 0.7));
        addChild(img);

        img = new Image(Const.assets.getTexture('close'));
        img.x = Const.stageWidth - img.width * 1.5;
        img.y = img.height * 0.5;
        img.name = 'CLOSE';
        addChild(img);
    }


    override public function activate(param:Object = null):void {
    }

    override public function callAfterActivate():void {
        var img:Image;
        var tween:Tween;

        buy1 = new Sprite();
        buy1.touchGroup = true;
        buy1.name = 'BUY1';
        img = new Image(Const.assets.getTexture('buy1'));
        img.pivotX = img.width * 0.5;
        img.pivotY = img.height * 0.5;
        buy1.addChild(img);
        buy1.x = -buy1.width * 0.5;//buy1.width * 0.5 + (Const.stageWidth - buy1.width * 2) / 3;
        buy1.y = Const.halfStageHeight;
        addChild(buy1);

        tween = new Tween(buy1, 0.5, Transitions.EASE_OUT);
        tween.moveTo(buy1.width * 0.5 + (Const.stageWidth - buy1.width * 2) / 3, buy1.y);
        Starling.juggler.add(tween);

        buy2 = new Sprite();
        buy2.touchGroup = true;
        buy2.name = 'BUY2';
        img = new Image(Const.assets.getTexture('buy2'));
        img.pivotX = img.width * 0.5;
        img.pivotY = img.height * 0.5;
        buy2.addChild(img);
        img = new Image(Const.assets.getTexture('video'));
        img.pivotX = img.width * 0.5;
        img.pivotY = img.height * 0.5;
        img.x = img.width * 0.25;
        img.y = buy2.height * 0.5 - img.height * 0.25;
        buy2.addChild(img);
        buy2.x = Const.stageWidth + buy2.width * 0.5;//Const.stageWidth - buy2.width * 0.5 - (Const.stageWidth - buy2.width * 2) / 3;
        buy2.y = Const.halfStageHeight;
        addChild(buy2);

        tween = new Tween(buy2, 0.5, Transitions.EASE_OUT);
        tween.moveTo(Const.stageWidth - buy2.width * 0.5 - (Const.stageWidth - buy2.width * 2) / 3, buy2.y);
        Starling.juggler.add(tween);

        addEventListener(TouchEvent.TOUCH, onTouch);
    }

    override public function deactivate():void {
        buy1.removeChildren();
        buy1.removeFromParent();
        buy1 = null;
        buy2.removeChildren();
        buy2.removeFromParent();
        buy2 = null;
        dispatchEvent(new ScreenEvent(ScreenEvent.SCREEN_DEACTIVATED, true, {'type':type}));
    }

    override public function callAfterDeactivate():void {
        dispatchEvent(new ScreenEvent(ScreenEvent.SCREEN_CAN_REMOVE, true, {'type':type}));
    }

    override public function getTweenParam(actionType:String):Array {
        return super.getTweenParam(actionType);
    }

    private function onTouch(e:TouchEvent):void {
        var touch:Touch = e.getTouch(this);
        if(touch) {
            if (touch.phase == TouchPhase.BEGAN) {
                switch (touch.target.name) {
                    case 'CLOSE':
                        ScreenManager.instance.deactivateScreen(this.type);
                        break;
                }
            }
        }
    }
}
}
