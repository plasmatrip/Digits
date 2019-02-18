/**
 * Created by Администратор on 21.10.15.
 */
package GameObject {
import starling.animation.Transitions;
import starling.animation.Tween;
import starling.core.Starling;
import starling.display.Image;
import starling.display.Sprite;
import starling.text.BitmapFont;
import starling.text.TextField;
import starling.utils.Align;
import starling.utils.Color;
//import starling.utils.HAlign;
//import starling.utils.VAlign;

public class Gui extends Sprite {
    private var _recText:TextField;
    private var tweens:Vector.<Tween>;

    public var txtMoves:TextField;
    public var txtTarget:TextField;

    public var btnMute:Image;
    public var btnUnmute:Image;

    public function Gui() {
        var tween:Tween;
        var guiElement:Image;

        tweens = new <Tween>[];

        guiElement = new Image(Const.assets.getTexture('panel'));
        guiElement.pivotX = guiElement.width * 0.5;
        guiElement.x = Const.halfStageWidth;
        addChild(guiElement);

        guiElement = new Image(Const.assets.getTexture('settings2'));
        guiElement.pivotY = guiElement.height * 0.5;
        guiElement.y = guiElement.height * 0.5;
        guiElement.x = -guiElement.width;
        guiElement.name = 'SETTINGS';
        addChild(guiElement);
        tween = new Tween(guiElement, 1, Transitions.EASE_OUT);
        tween.moveTo(0, guiElement.y);
        tweens[tweens.length] = tween;

        /*guiElement = new Image(Const.assets.getTexture('btnRestart'));
        guiElement.pivotY = guiElement.height * 0.5;
        guiElement.y = guiElement.height * 0.5 + 3;
        guiElement.x = Const.stageWidth + guiElement.width;
        guiElement.name = 'BTN_RESTART';
        addChild(guiElement);
        tween = new Tween(guiElement, 1, Transitions.EASE_OUT);
        tween.moveTo(Const.stageWidth - guiElement.width - 10, guiElement.y);
        tweens[tweens.length] = tween;*/
        guiElement = new Image(Const.assets.getTexture('btnRestart'));
        guiElement.pivotY = guiElement.height * 0.5;
        guiElement.pivotX = guiElement.width * 0.5;
        guiElement.y = Const.BACK_Y + 22;
        guiElement.x = Const.halfStageWidth;
        guiElement.name = 'BTN_RESTART';
        addChild(guiElement);
        /*tween = new Tween(guiElement, 1, Transitions.EASE_OUT);
        tween.moveTo(Const.stageWidth - guiElement.width - 10, guiElement.y);
        tweens[tweens.length] = tween;*/

        guiElement = new Image(Const.assets.getTexture('tablo'));
        guiElement.pivotX = guiElement.width * 0.5;
        guiElement.x = Const.halfStageWidth;
        addChild(guiElement);

        _recText = new TextField(100, 40, '5');
        //_recText.vAlign = VAlign.CENTER;
        //_recText.fontName = 'font2';
        //Starling 2.0 start
        _recText.format.setTo("font2");
        _recText.format.verticalAlign = Align.CENTER;
        //Starling 2.0 end
        _recText.x = Const.halfStageWidth;
        _recText.y = guiElement.height * 0.5 - 5;
        _recText.pivotX = _recText.width * 0.5;
        _recText.pivotY = _recText.height * 0.5 + 2;
        _recText.format.color = Color.WHITE;
        _recText.format.size = BitmapFont.NATIVE_SIZE;
        _recText.touchable = false;
        addChild(_recText);

        txtMoves = new TextField(100, 40, 'MOVES:');
        //txtMoves.vAlign = VAlign.CENTER;
        //txtMoves.hAlign = HAlign.LEFT;
        //txtMoves.fontName = 'font';
        //Starling 2.0 start
        txtMoves.format.setTo('font', BitmapFont.NATIVE_SIZE, Color.WHITE);
        txtMoves.format.verticalAlign = Align.CENTER;
        txtMoves.format.horizontalAlign = Align.LEFT;
        //Starling 2.0 end
        txtMoves.x = Const.stageWidth - 85;
        txtMoves.y = Const.BACK_Y + 25;
        //txtMoves.pivotX = _recText.width * 0.5;
        txtMoves.pivotY = txtMoves.height * 0.5 + 2;
        //txtMoves.format.color = Color.WHITE;
        //txtMoves.format.size = BitmapFont.NATIVE_SIZE;
        txtMoves.touchable = false;
        addChild(txtMoves);

        txtTarget = new TextField(100, 40, 'TARGET:');
        //txtTarget.vAlign = VAlign.CENTER;
        //txtTarget.hAlign = HAlign.LEFT;
        //txtTarget.fontName = 'font';
        txtTarget.format.setTo("font");
        txtTarget.format.verticalAlign = Align.CENTER;
        txtTarget.format.horizontalAlign = Align.LEFT;
        txtTarget.x = 15;
        txtTarget.y = Const.BACK_Y + 25;
        //txtMoves.pivotX = _recText.width * 0.5;
        txtTarget.pivotY = txtMoves.height * 0.5 + 2;
        txtTarget.format.color = Color.WHITE;
        txtTarget.format.size = BitmapFont.NATIVE_SIZE;
        txtTarget.touchable = false;
        addChild(txtTarget);

        /*guiElement = new Image(Const.assets.getTexture('btnHome'));
        guiElement.pivotY = guiElement.height * 0.5;
        guiElement.y = 178;
        guiElement.x = 85;
        guiElement.scaleX = guiElement.scaleY = 0.75;
        guiElement.name = 'BTN_HOME';
        addChild(guiElement);*/

        /*btnMute = new Image(Const.assets.getTexture('btnMute'));
        btnMute.pivotY = btnMute.height * 0.5;
        btnMute.y = 178;
        btnMute.x = 155;
        btnMute.scaleX = btnMute.scaleY = 0.75;
        btnMute.name = 'BTN_MUTE';
        addChild(btnMute);*/

        /*btnUnmute = new Image(Const.assets.getTexture('btnUnmute'));
        btnUnmute.visible = false;
        btnUnmute.pivotY = btnUnmute.height * 0.5;
        btnUnmute.y = 178;
        btnUnmute.x = 155;
        btnUnmute.scaleX = btnUnmute.scaleY = 0.75;
        btnUnmute.name = 'BTN_UNMUTE';
        addChild(btnUnmute);*/

        guiElement = new Image(Const.assets.getTexture('lenta'));
        guiElement.pivotX = guiElement.width * 0.5;
        guiElement.x = Const.halfStageWidth - 53 - 15;
        guiElement.rotation = Math.PI/2 + 0.3;
        addChild(guiElement);
        //tween = new Tween(guiElement, 1.2, Transitions.EASE_OUT_ELASTIC);
        tween = new Tween(guiElement, 1.7, Transitions.EASE_OUT_ELASTIC);
        tween.rotateTo(0);
        tweens[tweens.length] = tween;

        guiElement = new Image(Const.assets.getTexture('lenta'));
        guiElement.pivotX = guiElement.width * 0.5;
        guiElement.x = Const.halfStageWidth - 53 - 40;
        guiElement.rotation = Math.PI/2;
        addChild(guiElement);
        //tween = new Tween(guiElement, 1, Transitions.EASE_OUT_ELASTIC);
        tween = new Tween(guiElement, 1.5, Transitions.EASE_OUT_ELASTIC);
        tween.rotateTo(0);
        tweens[tweens.length] = tween;

        guiElement = new Image(Const.assets.getTexture('lenta'));
        guiElement.pivotX = guiElement.width * 0.5;
        guiElement.x = Const.halfStageWidth + 53 + 15;
        guiElement.rotation = -(Math.PI/2 + 0.4);
        addChild(guiElement);
        //tween = new Tween(guiElement, 1.1, Transitions.EASE_OUT_ELASTIC);
        tween = new Tween(guiElement, 1.6, Transitions.EASE_OUT_ELASTIC);
        tween.rotateTo(0);
        tweens[tweens.length] = tween;

        guiElement = new Image(Const.assets.getTexture('lenta'));
        guiElement.pivotX = guiElement.width * 0.5;
        guiElement.x = Const.halfStageWidth + 53 + 40;
        guiElement.rotation = -(Math.PI/2 + 0.1);
        addChild(guiElement);
        //tween = new Tween(guiElement, 1.3, Transitions.EASE_OUT_ELASTIC);
        tween = new Tween(guiElement, 1.8, Transitions.EASE_OUT_ELASTIC);
        tween.rotateTo(0);
        tweens[tweens.length] = tween;
    }

    public function tweenGuiElement():void{
        var i:int = tweens.length;
        while(--i > -1){
            Starling.juggler.add(tweens[i]);
        }
        tweens = null;
    }

    public function set recordText(value:int):void {
        _recText.text = String(value);
    }
}
}
