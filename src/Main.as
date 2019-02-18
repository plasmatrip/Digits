package
{
import flash.desktop.NativeApplication;
import flash.display.Bitmap;
import flash.display.Sprite;
import flash.display.StageAlign;
import flash.events.Event;
import flash.filesystem.File;
import flash.geom.Rectangle;
import flash.net.SharedObject;
import flash.system.Capabilities;

import starling.core.Starling;
import starling.events.Event;
import starling.textures.RenderTexture;
import starling.utils.AssetManager;
import starling.utils.StringUtil;
import starling.utils.SystemUtil;
//import starling.utils.formatString;



//[SWF(width="480", height="320",frameRate="30",backgroundColor="#E4F1FE")]
//[SWF(width="640", height="960",frameRate="30",backgroundColor="#302221")]
[SWF(frameRate="60",backgroundColor="#FFFFFF")]

/**
 * ...
 * @author plasma_trip
 */
public class Main extends Sprite
{
    //Android lunch screen
    [Embed(source="../init_screen/450x960-Portrait.png")]
    private static var Background450x960:Class;

    [Embed(source="../init_screen/480x800-Portrait.png")]
    private static var Background480x800:Class;

    [Embed(source="../init_screen/480x854-Portrait.png")]
    private static var Background480x854:Class;

    [Embed(source="../init_screen/600x1024-Portrait.png")]
    private static var Background600x1024:Class;

    [Embed(source="../init_screen/720x1280-Portrait.png")]
    private static var Background720x1280:Class;

    [Embed(source="../init_screen/800x1280-Portrait.png")]
    private static var Background800x1280:Class;

    [Embed(source="../init_screen/1080x1920-Portrait.png")]
    private static var Background1080x1920:Class;

    [Embed(source="../init_screen/1200x1920-Portrait.png")]
    private static var Background1200x1920:Class;

    //iPhone lunch screen
    //iPhone 3GS
    [Embed(source="../init_screen/Default.png")]
    private static var Background480x320:Class;
    //iPhone 4,4s
    [Embed(source="../init_screen/Default@2x~iphone.png")]
    private static var Background960x640:Class;
    //iPhone 5,5c,5s
    [Embed(source="../init_screen/Default-568h@2x~iphone.png")]
    private static var Background640x1136:Class;
    //iPhone 6, 7
    [Embed(source="../init_screen/Default-375w-667h@2x~iphone.png")]
    private static var Background750x1334:Class;
    //iPhone 6+, 7+
    [Embed(source="../init_screen/Default-414w-736h@3x~iphone.png")]
    private static var Background1242x2208:Class;
    //iPad 1,2,mini
    [Embed(source="../init_screen/Default-Portrait~ipad.png")]
    private static var Background768x1024:Class;
    //iPad 3,Air
    [Embed(source="../init_screen/Default-Portrait@2x~ipad.png")]
    private static var Background1536x2048:Class;
    //iPad Pro
    [Embed(source="../init_screen/Default-Portrait@2x.png")]
    private static var Background2048x2732:Class;

    //[Embed(source = "../levels.xml", mimeType = "application/octet-stream")]
    //private var XMLLevels:Class;

    private var viewPort:Rectangle;
    private var backgroundClass:Class;

    public function Main()
    {
        var iOS:Boolean = SystemUtil.platform == "IOS";
        Starling.multitouchEnabled = true;
        //for old version Starling.handleLostContext = iOS;//true;
        //for old version RenderTexture.optimizePersistentBuffers = iOS; // safe on iOS, dangerous on Android

        stage.align = StageAlign.TOP_LEFT;

        Const.mStarling = new Starling(Preloader, stage, viewPort);
        Const.mStarling.simulateMultitouch = false;
        Const.mStarling.enableErrorChecking = true;//Capabilities.isDebugger;
        Const.mStarling.showStats = true;
        /*Gestouch.inputAdapter = new NativeInputAdapter(stage);
         Gestouch.addDisplayListAdapter(starling.display.DisplayObject, new StarlingDisplayListAdapter());
         Gestouch.addTouchHitTester(new StarlingTouchHitTester(Const.mStarling), -1);*/

        updateViewport();
        if((stage.fullScreenWidth == 480 && stage.fullScreenHeight == 320) || (stage.fullScreenHeight == 480 && stage.fullScreenWidth == 320)) {
            //iPhone 3
            backgroundClass = Background480x320;
        }else if((stage.fullScreenWidth == 960 && stage.fullScreenHeight == 640) || (stage.fullScreenHeight == 960 && stage.fullScreenWidth == 640)){
            //iPhone 4, 4S
            backgroundClass = Background960x640;
        } else if((stage.fullScreenWidth == 1136 && stage.fullScreenHeight == 640) || (stage.fullScreenHeight == 1136 && stage.fullScreenWidth == 640)){
            //iPhone 5, 5c, 5s
            backgroundClass = Background640x1136;
        } else if((stage.fullScreenWidth == 1334 && stage.fullScreenHeight == 750) || (stage.fullScreenHeight == 1334 && stage.fullScreenWidth == 750)){
            //iPhone 6, 7
            backgroundClass = Background750x1334;
        } else if((stage.fullScreenWidth == 2208 && stage.fullScreenHeight == 1242) || (stage.fullScreenHeight == 2208 && stage.fullScreenWidth == 1242)){
            //iPhone 6+, 7+
            backgroundClass = Background1242x2208;
        } else if((stage.fullScreenWidth == 1024 && stage.fullScreenHeight == 736) || (stage.fullScreenHeight == 1024 && stage.fullScreenWidth == 768)){
            //iPad 1, 2, mini
            backgroundClass = Background768x1024;
        } else if((stage.fullScreenWidth == 2048 && stage.fullScreenHeight == 1536) || (stage.fullScreenHeight == 2048 && stage.fullScreenWidth == 1536)){
            //iPad 3, Air
            backgroundClass = Background1536x2048;
        } else if((stage.fullScreenWidth == 2732 && stage.fullScreenHeight == 2048) || (stage.fullScreenHeight == 2732 && stage.fullScreenWidth == 2048)){
            //iPad Pro
            backgroundClass = Background2048x2732;
        } else if((stage.fullScreenWidth == 960 && stage.fullScreenHeight == 450) || (stage.fullScreenHeight == 960 && stage.fullScreenWidth == 450)){
            backgroundClass = Background450x960;
        } else if((stage.fullScreenWidth == 800 && stage.fullScreenHeight == 480) || (stage.fullScreenHeight == 800 && stage.fullScreenWidth == 480)){
            backgroundClass = Background480x800;
        } else if((stage.fullScreenWidth == 854 && stage.fullScreenHeight == 480) || (stage.fullScreenHeight == 854 && stage.fullScreenWidth == 480)){
            backgroundClass = Background480x854;
        } else if((stage.fullScreenWidth == 1024 && stage.fullScreenHeight == 600) || (stage.fullScreenHeight == 1024 && stage.fullScreenWidth == 600)){
            backgroundClass = Background600x1024;
        } else if((stage.fullScreenWidth == 1280 && stage.fullScreenHeight == 720) || (stage.fullScreenHeight == 1280 && stage.fullScreenWidth == 720)){
            backgroundClass = Background720x1280;
        } else if((stage.fullScreenWidth == 1280 && stage.fullScreenHeight == 800) || (stage.fullScreenHeight == 1280 && stage.fullScreenWidth == 800)){
            backgroundClass = Background800x1280;
        } else if((stage.fullScreenWidth == 1920 && stage.fullScreenHeight == 1080) || (stage.fullScreenHeight == 1920 && stage.fullScreenWidth == 1080)){
            backgroundClass = Background1080x1920;
        } else if((stage.fullScreenWidth == 1920 && stage.fullScreenHeight == 1200) || (stage.fullScreenHeight == 1920 && stage.fullScreenWidth == 1200)){
            backgroundClass = Background1200x1920;
        } else {
            //Desktop
            backgroundClass = Background960x640;
        }

        var background:Bitmap = new backgroundClass();

        Background960x640 = null;
        Background640x1136 = null;
        Background750x1334 = null;
        Background1242x2208 = null;
        Background768x1024 = null;
        Background1536x2048 = null;
        Background2048x2732 = null;
        Background450x960 = null;
        Background480x800 = null;
        Background480x854 = null;
        Background600x1024 = null;
        Background720x1280 = null;
        Background800x1280 = null;
        Background1080x1920 = null;
        Background1200x1920 = null;
        Background480x320 = null;

        background.x = viewPort.x;
        background.y = viewPort.y;
        background.width  = viewPort.width;
        background.height = viewPort.height;
        background.smoothing = true;
        addChild(background);

        var appDir:File = File.applicationDirectory;
        var assets:AssetManager = new AssetManager(Const.scaleFactor);
        //assets.keepAtlasXmls = true;
        //assets.keepFontXmls = true;
        assets.useMipMaps = false;
        assets.verbose = Capabilities.isDebugger;
        assets.enqueue(
                appDir.resolvePath("assets/Particles"),
                appDir.resolvePath("assets/Animation"),
                appDir.resolvePath("assets/Music"),
                appDir.resolvePath(StringUtil.format("assets/{0}x", Const.scaleFactor == 3 ? 4 : Const.scaleFactor))
        );
        Const.assets = assets;
        //Const.soundAssets = new AssetManager(Const.scaleFactor);

        Const.mStarling.addEventListener(starling.events.Event.ROOT_CREATED,
                function(event:Object, app:Preloader):void
                {
                    Const.mStarling.removeEventListener(starling.events.Event.ROOT_CREATED, arguments.callee);
                    removeChild(background);
                    //background = null;


                    Const.gameLocalData = SharedObject.getLocal("Digits");
                    if (Const.gameLocalData.size != 0) {
                        //Const.readProgress();
                    } else {
                        //Const.saveProgress();
                    }

                    app.start(background);//bgTexture);
                    Const.mStarling.start();
                    background = null;
                });

        // When the game becomes inactive, we pause Starling; otherwise, the enter frame event
        // would report a very long 'passedTime' when the app is reactivated.
        NativeApplication.nativeApplication.addEventListener(flash.events.Event.ACTIVATE, onActivate);
        NativeApplication.nativeApplication.addEventListener(flash.events.Event.DEACTIVATE, onDeactivate);
        NativeApplication.nativeApplication.addEventListener(flash.events.Event.EXITING, onExit);
    }

    private function onExit(e:flash.events.Event):void{
        //Const.saveProgress();
    }

    private function onActivate(e:flash.events.Event):void{
        Const.mStarling.start();
    }

    private function onDeactivate(e:flash.events.Event):void{
        //Const.saveProgress();
        Const.mStarling.stop(true);
    }

    /*private function resizeHandler(e:starling.events.Event):void {
        updateViewport();
        Const.needRedraw = true;
    }*/

    private function updateViewport():void{
        //portrait
        if(stage.fullScreenHeight == 480 && stage.fullScreenWidth == 320) {//iPhone 3, Android 320x480
            viewPort = new Rectangle(0, 0, 320, 480);
            Const.scaleFactor = 1;
            Const.stageWidth = 320;
            Const.stageHeight = 480;
            Const.mStarling.stage.stageWidth = 320;
            Const.mStarling.stage.stageHeight = 480;
        } else if(stage.fullScreenHeight == 800 && stage.fullScreenWidth == 480) {//Android 480x800
            viewPort = new Rectangle(0,0,480,800);
            Const.scaleFactor = 2;
            Const.stageWidth = 240;
            Const.stageHeight = 400;
            Const.mStarling.stage.stageWidth = 240;
            Const.mStarling.stage.stageHeight = 400;
        } else if(stage.fullScreenHeight == 854 && stage.fullScreenWidth == 480) {//Android 480x854
            viewPort = new Rectangle(0,0,480,854);
            Const.scaleFactor = 2;
            Const.stageWidth = 240;
            Const.stageHeight = 427;
            Const.mStarling.stage.stageWidth = 240;
            Const.mStarling.stage.stageHeight = 427;
        } else if(stage.fullScreenHeight == 960 && stage.fullScreenWidth == 540) {//Android 540x960
            viewPort = new Rectangle(0,0,540,960);
            Const.scaleFactor = 2;
            Const.stageWidth = 270;
            Const.stageHeight = 480;
            Const.mStarling.stage.stageWidth = 270;
            Const.mStarling.stage.stageHeight = 480;
        } else if(stage.fullScreenHeight == 1024 && stage.fullScreenWidth == 600) {//Android 600x1024
            viewPort = new Rectangle(0,0,600,1024);
            Const.scaleFactor = 2;
            Const.stageWidth = 300;
            Const.stageHeight = 512;
            Const.mStarling.stage.stageWidth = 300;
            Const.mStarling.stage.stageHeight = 512;
        } else if(stage.fullScreenHeight == 1280 && stage.fullScreenWidth == 720) {//Android 720x1280
            viewPort = new Rectangle(0,0,720,1280);
            Const.scaleFactor = 2;
            Const.stageWidth = 360;
            Const.stageHeight = 640;
            Const.mStarling.stage.stageWidth = 360;
            Const.mStarling.stage.stageHeight = 640;
        } else if(stage.fullScreenHeight == 1280 && stage.fullScreenWidth == 800) {//Android 800x1280
            viewPort = new Rectangle(0,0,800,1280);
            Const.scaleFactor = 2;
            Const.stageWidth = 400;
            Const.stageHeight = 640;
            Const.mStarling.stage.stageWidth = 400;
            Const.mStarling.stage.stageHeight = 640;
        } else if(stage.fullScreenHeight == 1920 && stage.fullScreenWidth == 1080) {//Android 1080x1920
            viewPort = new Rectangle(0,0,1080,1920);
            Const.scaleFactor = 4;
            Const.stageWidth = 270;
            Const.stageHeight = 480;
            Const.mStarling.stage.stageWidth = 270;
            Const.mStarling.stage.stageHeight = 480;
        } else if(stage.fullScreenHeight == 1920 && stage.fullScreenWidth == 1200) {//Android 1920x1200
            viewPort = new Rectangle(0,0,1200,1920);
            Const.scaleFactor = 4;
            Const.stageWidth = 300;
            Const.stageHeight = 480;
            Const.mStarling.stage.stageWidth = 300;
            Const.mStarling.stage.stageHeight = 480;
        } else if(stage.fullScreenHeight == 960 && stage.fullScreenWidth == 640){//iPhone 4,4S
            viewPort = new Rectangle(0,0,640,960);
            Const.scaleFactor = 2;
            Const.stageWidth = 320;
            Const.stageHeight = 480;
            Const.mStarling.stage.stageWidth = 320;
            Const.mStarling.stage.stageHeight = 480;
        } else if(stage.fullScreenHeight == 1136 && stage.fullScreenWidth == 640){//iPhione 5,5S
            viewPort = new Rectangle(0,0,640,1136);
            Const.scaleFactor = 2;
            Const.stageWidth = 320;
            Const.stageHeight = 568;
            Const.mStarling.stage.stageWidth = 320;
            Const.mStarling.stage.stageHeight = 568;
        } else if(stage.fullScreenHeight == 1334 && stage.fullScreenWidth == 750) {//iPhone 6,7
            viewPort = new Rectangle(0, 0, 750, 1334);
            Const.scaleFactor = 2;
            Const.stageWidth = 375;
            Const.stageHeight = 667;
            Const.mStarling.stage.stageWidth = 375;
            Const.mStarling.stage.stageHeight = 667;
        } else if(stage.fullScreenHeight == 2208 && stage.fullScreenWidth == 1242){//iPhone 6+,7+
            viewPort = new Rectangle(0,0,1242,2208);
            Const.scaleFactor = 3;
            Const.stageWidth = 414;
            Const.stageHeight = 736;
            Const.mStarling.stage.stageWidth = 414;
            Const.mStarling.stage.stageHeight = 736;
        } else if(stage.fullScreenHeight == 1024 && stage.fullScreenWidth == 768){//iPad 1,2,mini
            viewPort = new Rectangle(0,0,768,1024);
            Const.scaleFactor = 2;
            Const.stageWidth = 384;
            Const.stageHeight = 512;
            Const.mStarling.stage.stageWidth = 384;
            Const.mStarling.stage.stageHeight = 512;
        } else if(stage.fullScreenHeight == 2732 && stage.fullScreenWidth == 2048){//iPad Pro
            viewPort = new Rectangle(0, 0, 2048, 2732);
            Const.scaleFactor = 4;
            Const.stageWidth = 512;
            Const.stageHeight = 683;
            Const.mStarling.stage.stageWidth = 512;
            Const.mStarling.stage.stageHeight = 683;
        } else if(stage.fullScreenHeight == 2048 && stage.fullScreenWidth == 1536){//iPad3, Air
            viewPort = new Rectangle(0,0,1536,2048);
            Const.scaleFactor = 4;
            Const.stageWidth = 384;
            Const.stageHeight = 512;
            Const.mStarling.stage.stageWidth = 384;
            Const.mStarling.stage.stageHeight = 512;
        }else{//Desktop
            viewPort = new Rectangle(0,0,640,960);
            Const.scaleFactor = 2;
            Const.stageWidth = 320;
            Const.stageHeight = 480;
            Const.mStarling.stage.stageWidth = 320;
            Const.mStarling.stage.stageHeight = 480;
        }
        Const.mStarling.viewPort = viewPort;
        Const.halfStageHeight = Const.stageHeight * 0.5;
        Const.halfStageWidth = Const.stageWidth * 0.5;
    }

}

}