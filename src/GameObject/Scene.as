/**
 * Created by plasma_trip on 12.04.16.
 */
package GameObject {
import com.catalystapps.gaf.core.GAFTimelinesManager;
import com.catalystapps.gaf.display.GAFMovieClip;

import starling.animation.Transitions;
import starling.animation.Tween;
import starling.core.Starling;
import starling.display.BlendMode;
import starling.display.Image;
import starling.display.Quad;
import starling.display.Sprite;
import starling.textures.RenderTexture;
import starling.textures.TextureSmoothing;

public class Scene extends Sprite {
    //private var colors:Vector.<uint> = new <uint>[0xF05B5C, 0xF0C41B, 0x4FBA70, 0x2F96C0, 0x965CA5];

    public var quad:Quad;
    private var musician:GAFMovieClip;

    public var cl:int;
    private var _mask:Image;
    private var renderTexture:RenderTexture;
    private var canvas:Image;
    private var _background:Quad;

    private var fullHeight:Number;
    private var fullWidth:Number;

    public function Scene(_width:Number, _height:Number, _color:uint, _musician:String) {
        quad = new Quad(_width, _height, _color);
        addChild(quad);

        musician = GAFTimelinesManager.getGAFMovieClip('Animation', _musician);
        musician.smoothing = TextureSmoothing.BILINEAR;
        musician.showBounds(true);
        fullHeight = musician.height;
        fullWidth = musician.width;
        musician.showBounds(false);
        musician.scale = getScale(quad.width, quad.height);
        musician.x = quad.width * 0.5;
        musician.y = quad.height;
        musician.fps = 60;
        musician.play();
        addChild(musician);

        renderTexture = new RenderTexture(_width, _height);
        canvas = new Image(renderTexture);
        addChild(canvas);
        _background = new Quad(_width, _height, 0xFFFFFF);
        _background.blendMode = BlendMode.NORMAL;
        _mask = new Image(Const.assets.getTexture('eraser0001'));
        _mask.width = _width;
        _mask.height = _height;
        _mask.blendMode = BlendMode.ERASE;
        renderTexture.draw(_background);
        renderTexture.draw(_mask);
        cl = 1;
    }

    private function getScale(_width:Number, _height:Number):Number{
        var _qs:Number = _width < _height ? _width : _height;
        var _s1:Number = _qs / fullWidth;
        var _s2:Number = _qs / fullHeight;
        if(fullWidth * _s1 < _width && fullHeight * _s1 < _height){
            if(fullWidth * _s2 < _width && fullHeight * _s2 < _height){
                return _s1 < _s2 ? _s2 : _s1;
            }else {
                return _s1;
            }
        }else{
            return _s2;
        }
    }

    public function moveToLeft(_width:Number, _x:Number = 0):void{
        var tween:Tween = new Tween(quad, 1, Transitions.EASE_OUT);
        tween.animate('width', _width);
        Starling.juggler.add(tween);
        tween = new Tween(musician, 1, Transitions.EASE_OUT);
        tween.animate('x', _width * 0.5);
        tween.scaleTo(getScale(_width, quad.height));
        Starling.juggler.add(tween);
        if(_x > 0){
            tween = new Tween(this,  1, Transitions.EASE_OUT);
            tween.animate('x', _x);
            Starling.juggler.add(tween);
        }
    }

    public function moveToDown(_height:Number, _y:Number, _scale:Number):void{
        var tween:Tween = new Tween(quad, 1, Transitions.EASE_OUT);
        tween.animate('height', _height);
        Starling.juggler.add(tween);
        tween = new Tween(this, 1, Transitions.EASE_OUT);
        tween.animate('y', _y);
        Starling.juggler.add(tween);1
        tween = new Tween(musician, 1, Transitions.EASE_OUT);
        tween.scaleTo(getScale(quad.width, _height));
        tween.animate('y', _height);
        Starling.juggler.add(tween);
    }

    public function show(_x:Number, _y:Number):void{
        var tween:Tween;
        tween = new Tween(this, 1, Transitions.EASE_OUT);
        tween.moveTo(_x, _y);
        tween.onComplete = function():void{
            eraser();
        };
        Starling.juggler.add(tween);
    }

    public function eraser():void{
        var tween:Tween = new Tween(this, .75);
        tween.animate('cl', 11);
        tween.onUpdate = function():void{
            var texture:String = cl >= 10 ? cl.toString() : '0' + cl.toString();
            _mask.texture = Const.assets.getTexture('eraser00' + texture);
            renderTexture.clear();
            renderTexture.draw(_background);
            renderTexture.draw(_mask);
        };
        tween.onComplete = function():void{
            canvas.removeFromParent();
            _mask = null;
            renderTexture = null;
            canvas = null;
            _background = null;
        };
        Starling.juggler.add(tween);
    }
}
}
