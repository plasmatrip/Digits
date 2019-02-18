package
{
import Screens.ScreenManager;
import Screens.ScreenType;

import com.catalystapps.gaf.core.GAFTimelinesManager;

import com.catalystapps.gaf.core.ZipToGAFAssetConverter;
import com.funkypandagame.stardustplayer.SimLoader;

import flash.display.Bitmap;
import flash.events.Event;
import flash.system.System;
import flash.utils.ByteArray;

import starling.display.Image;
import starling.display.Sprite;
import starling.text.BitmapFont;
import starling.text.TextField;
import starling.textures.Texture;

public class Preloader extends Sprite
{
    //private var loadingQueue:AssetManager;
    private var progressBar:Image;
    //private var loaderText:Image;
    private var lunchScreen:Image;
    private var comboParticleLoader:SimLoader;

    public function start(lunchScreen:Bitmap):void
    {
        this.lunchScreen = new Image(Texture.fromBitmap(lunchScreen, false, false, Const.scaleFactor));
        addChild(this.lunchScreen);

        progressBar = new Image(Texture.fromColor(Const.halfStageWidth, 8, 0x239a9e));
        progressBar.scaleX = 0;
        progressBar.x = Const.halfStageWidth * 0.5;
        progressBar.y = Const.stageHeight - 50;
        addChild(progressBar);

        /*var appDir:File = File.applicationDirectory;
         loadingQueue = new AssetManager(Const.scaleFactor);
         loadingQueue.useMipMaps = false;
         loadingQueue.verbose = Capabilities.isDebugger;
         loadingQueue.enqueue(
         appDir.resolvePath(formatString("loading/{0}x", Const.scaleFactor))
         );
         loadingQueue.loadQueue(loadProgress);*/
        Const.assets.loadQueue(onProgress);
    }

    /*private function loadProgress(progress:Number):void{
     if(progress == 1){
     progressBar = new MovieClip(loadingQueue.getTextures('loading'), 30);
     progressBar.stop();
     progressBar.x = Const.halfStageWidth;
     progressBar.y = Const.halfStageHeight;
     progressBar.pivotX = progressBar.width * 0.5;
     progressBar.pivotY = progressBar.height * 0.5;
     addChild(progressBar);
     loaderText = new Image(loadingQueue.getTexture('loaderText'));
     loaderText.x = Const.halfStageWidth;
     loaderText.y = progressBar.y - progressBar.height * 0.5 - loaderText.height;
     loaderText.pivotX = loaderText.width * 0.5;
     loaderText.pivotY = loaderText.height * 0.5;
     addChild(loaderText);
     Const.assets.loadQueue(onProgress);
     }
     }*/

    private function onProgress(progress:Number):void{
        if(progress == 1){
            // now would be a good time for a clean-up
            progressBar.removeFromParent();
            progressBar = null;

            System.pauseForGCIfCollectionImminent(0);
            System.gc();

            Const.FIELD_WIDTH = Const.assets.getTexture('tile_field3').width;
            Const.contentScale = Const.FIELD_WIDTH > Const.stageWidth ? Const.stageWidth / Const.FIELD_WIDTH : 1;
            //Const.FIELD_WIDTH *= Const.contentScale;
            Const.CELL_SIZE = Const.FIELD_WIDTH / Const.MAX_COL;
            Const.HALF_CELL_SIZE = Const.CELL_SIZE * 0.5;
            Const.FIELD_HEIGHT = Const.CELL_SIZE * Const.MAX_ROW;
            //Const.BACK_Y = Const.stageHeight - Const.assets.getTexture('tile_field3').height - 50;//40;
            Const.BACK_Y = Const.stageHeight - Const.FIELD_HEIGHT * Const.contentScale - 50;//40;
            //var t:Texture = Const.assets.getTexture('font');
            //var xml:XML = Const.assets.getXml('font');
            //var bmf:BitmapFont = new BitmapFont(t ,xml);
            //TextField.registerCompositor(bmf, 'font');
            TextField.registerBitmapFont(new BitmapFont(Const.assets.getTexture('font'),Const.assets.getXml('font')));
            //TextField.registerCompositor(new BitmapFont(Const.assets.getTexture('font'),Const.assets.getXml('font')), 'font');
            TextField.registerBitmapFont(new BitmapFont(Const.assets.getTexture('font2'),Const.assets.getXml('font2')));
            //TextField.registerCompositor(new BitmapFont(Const.assets.getTexture('font2'),Const.assets.getXml('font2')), 'font2');

            //ScreenManager.instance.container = this;
            //ScreenManager.instance.activateScreen(ScreenType.SCR_MAIN);

            //removeChild(lunchScreen);
            //lunchScreen = null;

            var gafConverter:ZipToGAFAssetConverter = new ZipToGAFAssetConverter();
            gafConverter.addEventListener(Event.COMPLETE, this.onConverted);
            gafConverter.convert(Const.assets.getByteArray('Animation'), 1, 1);
            //gafConverter.convert(Const.assets.getByteArray('new_pers'), 0.5, 2);
            //gafConverter.convert(Const.assets.getByteArray('cabbage'), 0.5, 2);

            //ScreenManager.instance.container = this;
            //ScreenManager.instance.activateScreen(ScreenType.SCR_MAIN);
            /*TextField.registerBitmapFont(new BitmapFont(Const.assets.getTexture('font'),Const.assets.getXml('font')));
             TextField.registerBitmapFont(new BitmapFont(Const.assets.getTexture('font2'),Const.assets.getXml('font2')));
             var tween:Tween = new Tween(this, 0.5);
             tween.animate('alpha', 0);
             tween.onCompleteArgs = [this];
             tween.onComplete = function(obj:Sprite):void{
             loaderText.removeFromParent(true);
             loaderText.texture.dispose();
             loaderText = null;
             progressBar.removeFromParent(true);
             progressBar.texture.dispose();
             progressBar = null;
             loadingQueue.dispose();
             loadingQueue = null;
             System.pauseForGCIfCollectionImminent(0);
             System.gc();
             var date:Date = new Date();
             if(Const.gameDescription.flowerLastTime == 0){
             Const.gameDescription.replace('flowerLastTime',<flowerLastTime>{date.getTime()}</flowerLastTime>);
             }
             if(Const.gameDescription.pictureLastTime == 0){
             Const.gameDescription.replace('pictureLastTime',<pictureLastTime>{date.getTime()}</pictureLastTime>);
             }
             if(Const.gameDescription.sportLastTime == 0){
             Const.gameDescription.replace('sportLastTime',<sportLastTime>{date.getTime()}</sportLastTime>);
             }
             Starling.juggler.remove(tween);
             alpha = 1;
             addChild(new ScrGame());
             };
             Starling.juggler.add(tween);*/
        }else{
            progressBar.scaleX= progress;
        }
    }

    private function onConverted(event: Event): void
    {
        var gafConverter: ZipToGAFAssetConverter = ZipToGAFAssetConverter(event.target);
        GAFTimelinesManager.addGAFBundle(gafConverter.gafBundle);
        gafConverter.removeEventListener(Event.COMPLETE, this.onConverted);

        comboParticleLoader = new SimLoader();
        comboParticleLoader.addEventListener(Event.COMPLETE, onComboParticleLoaded);
        var ba:ByteArray = Const.assets.getByteArray('combo_tile');
        comboParticleLoader.loadSim(ba);

        /*ScreenManager.instance.container = this;
        ScreenManager.instance.activateScreen(ScreenType.SCR_MAIN);

        removeChild(lunchScreen);
        lunchScreen = null;*/
    }

    private function onComboParticleLoaded(event:flash.events.Event):void{
        comboParticleLoader.removeEventListener(Event.COMPLETE, onComboParticleLoaded);
        Const.comboParticleLoader = comboParticleLoader;
        comboParticleLoader = null;

        ScreenManager.instance.container = this;
        ScreenManager.instance.activateScreen(ScreenType.SCR_MAIN);

        removeChild(lunchScreen);
        lunchScreen = null;
    }
}
}