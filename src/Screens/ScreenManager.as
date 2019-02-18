/**
 * Created by Администратор on 14.10.15.
 */
package Screens {
import Tweens.TweenFactory;
import starling.display.DisplayObjectContainer;
import starling.events.EventDispatcher;

public class ScreenManager extends EventDispatcher{
    public static const ACTION_ACTIVATE:String = 'ACTIVATE';
    public static const ACTION_DEACTIVATE:String = 'DACTIVATE';

    private static var _instance:ScreenManager;
    private static var _allowInstance:Boolean = false;

    private var _container:DisplayObjectContainer;
    private var screens:Vector.<GameScreen>;

    private var currentScreen:GameScreen;
    //private var activatingScreen:IGameScreen;

    public function ScreenManager() {
        if(!_allowInstance){
            throw new Error('Singlton! Use <ClassName>.instanse!');
        }
        screens = new <GameScreen>[];
    }

    public static function get instance():ScreenManager{
        if(!_instance){
            _allowInstance = true;
            _instance = new ScreenManager();
            _allowInstance = false;
        }
        return _instance;
    }

    public function set container(value:DisplayObjectContainer):void {
        _container = value;
    }

    public function get container():DisplayObjectContainer {
        return _container;
    }

    public function activateScreen(screenType:String, param:Object = null):void{
        var activatingScreen:GameScreen = null;
        var i:int = screens.length;
        while(--i > -1){
            if(screens[i].type == screenType){
                activatingScreen = screens[i];
                break;
            }
        }
        if(!activatingScreen){
            activatingScreen = ScreenType.getScreen(screenType, param);
            screens[screens.length] = activatingScreen;
        }
        activatingScreen.activate(param);
        container.addChild(activatingScreen);
        if(activatingScreen.activateTweenType){
            TweenFactory.getTween(activatingScreen.activateTweenType).apply(this, activatingScreen.getTweenParam(ACTION_ACTIVATE));
        }else{
            activatingScreen.callAfterActivate();
        }
    }

    public function deactivateScreen(screenType:String):void{
        var deactivatingScreen:GameScreen = null;
        var i:int = screens.length;
        while(--i > -1){
            if(screens[i].type == screenType){
                deactivatingScreen = screens[i];
                break;
            }
        }
        if(deactivatingScreen){
            //слушаем событие деактивации экрана. вызываем функцию деактивации экрана. в функции прописываем анимации проигрываемые при деактивации экрана
            container.addEventListener(ScreenEvent.SCREEN_DEACTIVATED, onScreenDeactivated);
            deactivatingScreen.deactivate();
            /*deactivatingScreen.deactivate();
             if(deactivatingScreen.deactivateTweenType){
             TweenFactory.getTween(deactivatingScreen.deactivateTweenType).apply(this, deactivatingScreen.getTweenParam(ACTION_DEACTIVATE));
             }else{
             deactivatingScreen.callAfterDeactivate();
             }*/
        }
    }

    private function onScreenDeactivated(e:ScreenEvent):void {
        container.removeEventListener(ScreenEvent.SCREEN_DEACTIVATED, onScreenDeactivated);
        var deactivatingScreen:GameScreen = null;
        var i:int = screens.length;
        while(--i > -1){
            if(screens[i].type == e.data.type){
                deactivatingScreen = screens[i];
                break;
            }
        }
        if(deactivatingScreen){
            container.addEventListener(ScreenEvent.SCREEN_CAN_REMOVE, onScreenCanRemove);
            if(deactivatingScreen.deactivateTweenType){
                TweenFactory.getTween(deactivatingScreen.deactivateTweenType).apply(this, deactivatingScreen.getTweenParam(ACTION_DEACTIVATE));
            }else{
                deactivatingScreen.callAfterDeactivate();
            }
        }
    }

    private function onScreenCanRemove(e:ScreenEvent):void {
        container.removeEventListener(ScreenEvent.SCREEN_CAN_REMOVE, onScreenCanRemove);
        var deactivatingScreen:GameScreen = null;
        var i:int = screens.length;
        while(--i > -1){
            if(screens[i].type == e.data.type){
                deactivatingScreen = screens[i];
                break;
            }
        }
        if(deactivatingScreen){
            container.removeChild(deactivatingScreen);
        }
    }
}
}
