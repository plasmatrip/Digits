package
{
import Screens.ScrGame;

import com.funkypandagame.stardustplayer.SimLoader;

import com.funkypandagame.stardustplayer.project.ProjectValueObject;

import flash.geom.Point;
import flash.geom.Rectangle;
import flash.net.SharedObject;
import flash.utils.ByteArray;

import starling.core.Starling;
import starling.display.MovieClip;
import starling.textures.Texture;
import starling.utils.AssetManager;

import treefortress.sound.SoundInstance;

/**
 * ...
 * @author plasma_trip
 */
public class Const
{
    //ссылка на шаред обжект
    public static var gameLocalData:SharedObject;

    //Переменные для настройки игры
    //public static var frameSize:Rectangle;
    public static var stageWidth:int;
    public static var stageHeight:int;
    public static var halfStageWidth:int;
    public static var halfStageHeight:int;
    public static var scaleFactor:int = 1;
    public static var assets:AssetManager;
    public static var mStarling:Starling;
    public static var contentScale:Number = 1;
    //public static var needRedraw:Boolean;

    public static var MAX_ROW:int = 7;//8;
    public static var MAX_COL:int = 7;
    public static var FULL_ROW:int = MAX_ROW + 1;
    public static var FIELD_WIDTH:Number;// = Const.assets.getTexture('tile_field').width;//Const.tileWidth;
    public static var HALF_CELL_SIZE:Number;// = CELL_SIZE * 0.5;
    public static var FIELD_HEIGHT:Number;// = CELL_SIZE * MAX_ROW;
    public static var BACK_Y:Number;
    public static var CELL_SIZE:Number;// = FIELD_WIDTH / MAX_COL;

    public static var MAX_VALUE:int;
    public static var CURRENT_TARGET:int;
    public static var CURRENT_MOVES:int;

    public static var soundAssets:AssetManager;
    public static var currentSoundInstance:SoundInstance;

    public static var sat:Number = -0.75;
    public static var tileColors:Vector.<uint>;
    public static var baseColorIndex:int = 0;

    public static var comboParticleProject:ProjectValueObject;
    public static var comboParticleLoader:SimLoader;

    public static function saveProgress():void
    {
        var ld:XML = gameDescription;
        var ba:ByteArray = new ByteArray();
        ba.writeMultiByte(ld.toXMLString(), 'unicode-1-1-utf-8');
        ba.compress();
        gameLocalData.data.gameDescription = ba;
        gameLocalData.flush();
    }

    public static function readProgress():void
    {
        var ba:ByteArray = gameLocalData.data.gameDescription;
        ba.uncompress();
        var ld:XML = new XML(ba);
        gameDescription = ld;
        ba.compress();
        gameLocalData.flush();
    }

    public static function changeTexture(mc:MovieClip, texture:String, fps:int = 12, onComplete:Function = null, setPivot:Boolean = true):void{
        while(mc.numFrames > 1){
            mc.removeFrameAt(0);
        }
        var textures:Vector.<Texture> = Const.assets.getTextures(texture);
        for each (var frame:Texture in textures){
            mc.addFrame(frame);
        }
        mc.removeFrameAt(0);
        mc.currentFrame = 0;
        mc.fps = fps;
        mc.readjustSize();
        if(setPivot){
            mc.pivotX = mc.width * 0.5;
            mc.pivotY = mc.height * 0.5;
        }
        if(onComplete){
            onComplete();
        }
    }

    public static var gameDescription:XML =
            <game>
                <selectSong>song1</selectSong>
                <song1>true</song1>
                <song2>false</song2>
                <song3>false</song3>
                <song4>false</song4>
                <maxValue>4</maxValue>
                <currentTarget>6</currentTarget>
                <targets>
                    <target number = '6'>
                        <moves>6</moves>
                        <song>2</song>
                    </target>
                    <target number = '7'>
                        <moves>6</moves>
                    </target>
                    <target number = '8'>
                        <moves>6</moves>
                        <song>3</song>
                    </target>
                    <target number = '9'>
                        <moves>6</moves>
                    </target>
                    <target number = '10'>
                        <moves>6</moves>
                        <song>4</song>
                    </target>
                    <target number = '11'>
                        <moves>6</moves>
                    </target>
                    <target number = '12'>
                        <moves>6</moves>
                        <song>5</song>
                    </target>
                    <target number = '13'>
                        <moves>6</moves>
                    </target>
                    <target number = '14'>
                        <moves>6</moves>
                        <song>6</song>
                    </target>
                    <target number = '15'>
                        <moves>6</moves>
                    </target>
                    <target number = '16'>
                        <moves>6</moves>
                    </target>
                    <target number = '17'>
                        <moves>6</moves>
                        <song>7</song>
                    </target>
                    <target number = '18'>
                        <moves>6</moves>
                    </target>
                    <target number = '19'>
                        <moves>6</moves>
                    </target>
                    <target number = '20'>
                        <moves>6</moves>
                        <song>8</song>
                    </target>
                </targets>
            </game>;
}

}