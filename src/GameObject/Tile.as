package GameObject {

import Geom.AABB;
import Geom.Vec2D;

import starling.animation.Transitions;
import starling.animation.Tween;
import starling.core.Starling;
import starling.display.Image;
import starling.display.Sprite;
import starling.filters.ColorMatrixFilter;
import starling.text.BitmapFont;
import starling.text.TextField;
import starling.utils.Align;
import starling.utils.Color;

//import starling.events.EnterFrameEvent;
//import starling.text.TextField;

public class Tile extends Sprite{
    private var _value:int;
    private var texture:Image;

    public var halfWidth:Number;
    public var halfHeight:Number;

    public var isTouch:Boolean;
    public var isRising:Boolean;

    private var _center:Vec2D;
    private var _aabb:AABB;

    private var txt:TextField;

    private var baseColors:Vector.<uint> = new <uint>[0x992e1c, 0x9c6b02, 0x091d66, 0x007172, 0x9b5106, 0xa59a02, 0x3b065e, 0x023f76,
        0x9e6901, 0x427d2b, 0x091d66, 0x6b015d, 0x6b015d, 0x9c5207, 0x006e3d, 0x023f76, 0x9d2e1d, 0x076f72, 0x417c2a, 0x6c025e, 0x940507,
        0x390760, 0xa19600, 0x02703f];
    private var sat:Vector.<Number> = new <Number>[-0.25, 0, 0.25, 0.5, 0.75, 1];

    public function Tile(value:int) {
        touchGroup = true;
        _value = value;

        /*var colorFilter:ColorMatrixFilter = new ColorMatrixFilter();
        colorFilter.tint(Const.tileColors[_value - 1], 1);//RND.getInt(1,baseColors.length) - 1] , 1);
        colorFilter.adjustSaturation(0.5);//sat[RND.getInt(1, sat.length) - 1]);*/
        //colorFilter.adjustBrightness(Const.sat);


        texture = new Image(Const.assets.getTexture(value.toString()));//+'_'+value.toString()));
        /*texture = new Image(Const.assets.getTexture('grey'));
        texture.filter = colorFilter;*/
        texture.name = 'tile';
        pivotX = texture.width * 0.5;
        pivotY = texture.height * 0.5;
        addChild(texture);

        halfHeight = height * 0.5;
        halfWidth = width * 0.5;
        _center = new Vec2D(x, y);
        _aabb = new AABB(new Vec2D(x, y), new Vec2D(halfWidth, halfHeight));

        isTouch = false;
        isRising = true;

        /*txt = new TextField(100, 40, value.toString());
        //txtMoves.vAlign = VAlign.CENTER;
        //txtMoves.hAlign = HAlign.LEFT;
        //txtMoves.fontName = 'font';
        //Starling 2.0 start
        txt.format.setTo("font");
        txt.format.verticalAlign = Align.CENTER;
        txt.format.horizontalAlign = Align.LEFT;
        //Starling 2.0 end
        txt.x = pivotX;
        txt.y = pivotY;
        //txtMoves.pivotX = _recText.width * 0.5;
        txt.pivotY = txt.height * 0.5 + 2;
        txt.format.color = Color.WHITE;
        txt.format.size = BitmapFont.NATIVE_SIZE;
        txt.touchable = false;
        addChild(txt);*/
    }

    public function incTween():void{
        scaleX = scaleY = 1.3;
            Starling.juggler.removeTweens(this);
            var tween:Tween = new Tween(this,  0.5, Transitions.EASE_OUT_ELASTIC);
            tween.scaleTo(1);
            Starling.juggler.add(tween);
    }

    //проверяем находится ли этот тайл рядом с тайлом из параметра
    public function isNearTile(tile:Tile):Boolean{
        if(tile.col == left || tile.col == rigth || tile.row == top || tile.row == bottom){
            return true;
        }
        return false;
    }

    //проверяем можно ли соеденить этот тайл с тайлом из параметра
    public function canBeConnected(tile:Tile):Boolean{
        if((tile.col == col && Math.abs(tile.x - x) <= halfWidth * 0.5) || (tile.row == row && Math.abs(tile.y - y) <= halfHeight * 0.5)){
            return true;
        }
        return false;
    }

    public function get value():int {
        return _value;
    }

    public function set value(value:int):void {
        /*var colorFilter:ColorMatrixFilter = new ColorMatrixFilter();
        colorFilter.tint(Const.tileColors[value - 1], 1);//RND.getInt(1,baseColors.length) - 1] , 1);
        colorFilter.adjustSaturation(0.75);//sat[RND.getInt(1, sat.length) - 1]);*/

        _value = value;
        texture.texture = Const.assets.getTexture(value.toString());//+'_'+value.toString());

        //texture.filter = colorFilter;

        //txt.text = value.toString();
    }

    //выисляем текущую строку тайла
    public function get row():int{
        return Math.floor(y / Const.CELL_SIZE) ;
    }

    //вычисляем текущую колонку тайла
    public function get col():int{
        return Math.floor(x / Const.CELL_SIZE) ;
    }

    //вычисляем колонку левой границы тайла
    public function get left():int{
        return Math.floor((x - halfWidth) / Const.CELL_SIZE)
    }

    //вычисляем колонку правой границы тайла
    public function get rigth():int{
        return Math.floor((x + halfWidth) / Const.CELL_SIZE)
    }

    //вычисляем строку верней границы тайла
    public function get top():int{
        return Math.floor((y - halfHeight) / Const.CELL_SIZE)
    }

    //вычисляем строку нижней границы тайла
    public function get bottom():int{
        return Math.floor((y + halfHeight) / Const.CELL_SIZE)
    }

    //центр тайла
    public function get center():Vec2D {
        return _aabb.center;
    }

    override public function set x(value:Number):void{
        _aabb.center.x = value;
        super.x =value ;
    }

    override public function set y(value:Number):void{
        _aabb.center.y = value;
        super.y =value ;
    }

    public function get aabb():AABB {
        _aabb.center.x = x;
        _aabb.center.y = y;
        return _aabb;
    }

    public function toString():String{
        return '[' + value + ' - ' + col + ' : ' + row + ']';
    }
}
}
