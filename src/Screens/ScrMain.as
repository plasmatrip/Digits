/**
 * Created by ������������� on 16.10.15.
 */
package Screens {
import Tweens.TweenFactory;
import flash.geom.Point;
import starling.animation.Transitions;
import starling.animation.Tween;
import starling.core.Starling;
import starling.display.Image;
import starling.display.Sprite;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;
import starling.filters.ColorMatrixFilter;

public class ScrMain extends GameScreen {
    private var song1:Sprite;
    private var song2:Sprite;
    private var song3:Sprite;
    private var song4:Sprite;

    public function ScrMain(param:Object = null) {
        type = ScreenType.SCR_MAIN;
        activateTweenType = TweenFactory.MOVE_OUT;
        //deactivateTweenType = TweenFactory.MOVE_OUT;
    }

    override public function activate(param:Object = null):void{
        var background:Image = new Image(Const.assets.getTexture('back_top_2'));
        background.pivotX = background.width * 0.5;
        background.pivotY = background.height;
        background.x = Const.halfStageWidth;
        background.y = Const.BACK_Y + 4;
        //background.scaleX = background.scaleY = background.y / background.height;

        var scaleY:Number = background.y / background.height;
        var scaleX:Number = Const.stageWidth / background.width;
        background.scale = scaleY > scaleX ? scaleY : scaleX;

        addChild(background);
        background = new Image(Const.assets.getTexture('back_down'));
        background.x = background.pivotX = background.width * 0.5;
        background.y = Const.BACK_Y;
        addChild(background);
    }

    override public function callAfterActivate():void{
        /*if(tapText){
            removeChild(tapText);
            tapText = null;
        }
        tapText = new TextField(250, 40, 'TAP TO PLAY');
        //tapText.vAlign = VAlign.TOP;
        //tapText.fontName = 'font';
        tapText.format.setTo('font');
        tapText.format.verticalAlign = Align.TOP;
        tapText.x = Const.halfStageWidth;
        tapText.y = Const.halfStageHeight - tapText.height;
        tapText.pivotX = tapText.width * 0.5;
        tapText.pivotY = tapText.height * 0.5;
        tapText.format.color = Color.WHITE;
        tapText.format.size = BitmapFont.NATIVE_SIZE;
        tapText.touchable = false;
        tapText.alpha = 0.001;
        addChild(tapText);*/

        /*var tween:Tween = new Tween(tapText, 0.5, Transitions.EASE_OUT);
        tween.fadeTo(1);
        tween.moveTo(tapText.x, Const.halfStageHeight);
        Starling.juggler.add(tween);*/

        var img:Image = new Image(Const.assets.getTexture('play'));
        img = new Image(Const.assets.getTexture('play'));
        img.name = 'PLAY';
        img.pivotX = img.width * 0.5;
        img.pivotY = img.height * 0.5;
        img.x = Const.halfStageWidth;
        img.y = Const.halfStageHeight - img.pivotY * 0.75;
        img.alpha = 0.1;
        img.scale = 0.1;
        addChild(img);

        var tween:Tween = new Tween(img, 0.3);
        tween.fadeTo(1);
        Starling.juggler.add(tween);

        tween = new Tween(img, 0.5, Transitions.EASE_OUT_ELASTIC);
        tween.scaleTo(1);
        Starling.juggler.add(tween);

        song1 = new Sprite();
        song1.name = 'SONG1';
        song1.touchGroup = true;
        img = new Image(Const.assets.getTexture('song_on'));
        img.pivotX = img.width * 0.5;
        img.pivotY = img.height * 0.5;
        song1.addChild(img);
        img = new Image(Const.assets.getTexture('musician1'));
        img.pivotX = img.width * 0.5;
        img.pivotY = img.height * 0.5;
        img.touchable = false;
        song1.addChild(img);
        song1.x = -song1.width;//song1.width * 0.5 + (Const.stageWidth - song1.width * 2) / 3;
        song1.y = Const.stageHeight - song1.height * 2;
        addChild(song1);

        tween = new Tween(song1, 0.3, Transitions.EASE_OUT);
        tween.moveTo(song1.width * 0.5 + (Const.stageWidth - song1.width * 2) / 3, song1.y);
        Starling.juggler.add(tween);

        var greyFilter:ColorMatrixFilter;

        song2 = new Sprite();
        song2.touchGroup = true;
        song2.name = 'SONG2';
        if(Const.gameDescription.song2 == false) {
            greyFilter = new ColorMatrixFilter();
            greyFilter.tint(0xFFFFFF, 1);
            greyFilter.adjustBrightness(-0.5);
            song2.filter = greyFilter;
        }
        img = new Image(Const.assets.getTexture('song_on'));
        img.pivotX = img.width * 0.5;
        img.pivotY = img.height * 0.5;
        song2.addChild(img);
        img = new Image(Const.assets.getTexture('musician2'));
        img.pivotX = img.width * 0.5;
        img.pivotY = img.height * 0.5;
        img.touchable = false;
        song2.addChild(img);
        song2.x = Const.stageWidth + song2.width;//Const.stageWidth - song2.width * 0.5 - (Const.stageWidth - song2.width * 2) / 3;
        song2.y = Const.stageHeight - song2.height * 2;
        addChild(song2);

        tween = new Tween(song2, 0.3, Transitions.EASE_OUT);
        tween.moveTo(Const.stageWidth - song2.width * 0.5 - (Const.stageWidth - song2.width * 2) / 3, song2.y);
        Starling.juggler.add(tween);

        song3= new Sprite();
        song3.touchGroup = true;
        song3.name = 'SONG3';
        if(Const.gameDescription.song3 == false) {
            greyFilter = new ColorMatrixFilter();
            greyFilter.tint(0xFFFFFF, 1);
            greyFilter.adjustBrightness(-0.5);
            song3.filter = greyFilter;
        }
        img = new Image(Const.assets.getTexture('song_on'));
        img.pivotX = img.width * 0.5;
        img.pivotY = img.height * 0.5;
        song3.addChild(img);
        img = new Image(Const.assets.getTexture('musician3'));
        img.pivotX = img.width * 0.5;
        img.pivotY = img.height * 0.5;
        img.touchable = false;
        song3.addChild(img);
        song3.x = -song3.width * 0.5;//song3.width * 0.5 + (Const.stageWidth - song3.width * 2) / 3;
        song3.y = Const.stageHeight - song3.height * 0.75;
        addChild(song3);

        tween = new Tween(song3, 0.3, Transitions.EASE_OUT);
        tween.moveTo(song3.width * 0.5 + (Const.stageWidth - song3.width * 2) / 3, song3.y);
        Starling.juggler.add(tween);

        song4 = new Sprite();
        song4.touchGroup = true;
        song4.name = 'SONG4';
        if(Const.gameDescription.song4 == false) {
            greyFilter = new ColorMatrixFilter();
            greyFilter.tint(0xFFFFFF, 1);
            greyFilter.adjustBrightness(-0.5);
            song4.filter = greyFilter;
        }
        img = new Image(Const.assets.getTexture('song_on'));
        img.pivotX = img.width * 0.5;
        img.pivotY = img.height * 0.5;
        song4.addChild(img);
        img = new Image(Const.assets.getTexture('musician4'));
        img.pivotX = img.width * 0.5;
        img.pivotY = img.height * 0.5;
        img.touchable = false;
        song4.addChild(img);
        song4.x = Const.stageWidth + song4.width;//Const.stageWidth - song4.width * 0.5 - (Const.stageWidth - song4.width * 2) / 3;
        song4.y = Const.stageHeight - song4.height * 0.75;
        addChild(song4);

        var tween:Tween = new Tween(song4, 0.3, Transitions.EASE_OUT);
        tween.moveTo(Const.stageWidth - song4.width * 0.5 - (Const.stageWidth - song4.width * 2) / 3, song4.y);
        Starling.juggler.add(tween);

        addEventListener(TouchEvent.TOUCH, onTouch);
    }

    override public function deactivate():void {
        dispatchEvent(new ScreenEvent(ScreenEvent.SCREEN_DEACTIVATED, true, {'type':type}));
    }

    override public function callAfterDeactivate():void {
        dispatchEvent(new ScreenEvent(ScreenEvent.SCREEN_CAN_REMOVE, true, {'type':type}));
    }


    override public function getTweenParam(actionType:String):Array{
        var ret:Array = null;
        switch (actionType){
            case ScreenManager.ACTION_ACTIVATE:
                ret = [this,  1, new Point(), callAfterActivate, null];
                break;
            case ScreenManager.ACTION_DEACTIVATE:
                break;
        }
        return ret;
    }

    private function onTouch(e:TouchEvent):void {
        var touch:Touch = e.getTouch(this);
        if(touch) {
            if (touch.phase == TouchPhase.BEGAN) {
                switch (touch.target.name) {
                    case 'PLAY':
                        ScreenManager.instance.activateScreen(ScreenType.SCR_GAME);
                        ScreenManager.instance.deactivateScreen(this.type);
                        break;
                    case 'SONG1':
                        ScreenManager.instance.activateScreen(ScreenType.SCR_GAME, {'mode':GameState.GS_CHANGE_TILES});
                        ScreenManager.instance.deactivateScreen(this.type);
                        break;
                    case 'SONG2':
                        if(Const.gameDescription.song2 == false) {
                            ScreenManager.instance.activateScreen(ScreenType.SCR_SONG_SHOP);
                        }else{

                        }
                        break;
                }
            }
        }
    }
}
}
