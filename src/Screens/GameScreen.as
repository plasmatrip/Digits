/**
 * Created by Администратор on 15.10.15.
 */
package Screens {
import starling.display.DisplayObjectContainer;

public class GameScreen extends DisplayObjectContainer implements IGameScreen {
    private var _type:String;
    private var _activateTweenType:String = null;
    private var _deactivateTweenType:String = null;

    public function GameScreen(param:Object = null) {

    }

    public function get type():String {
        return _type;
    }

    public function set type(value:String):void {
        _type = value;
    }

    public function activate(param:Object = null):void {
    }

    public function deactivate():void {
    }

    protected function release():void {
        if(parent){
            this.removeFromParent();
        }
    }

    public function callAfterActivate():void {
    }

    public function callAfterDeactivate():void {
    }

    public function getTweenParam(actionType:String):Array {
        return null;
    }

    public function get activateTweenType():String {
        return _activateTweenType;
    }

    public function set activateTweenType(value:String):void {
        _activateTweenType = value;
    }

    public function get deactivateTweenType():String {
        return _deactivateTweenType;
    }

    public function set deactivateTweenType(value:String):void {
        _deactivateTweenType = value;
    }
}
}
