/**
 * Created by Администратор on 15.10.15.
 */
package Screens {
public interface IGameScreen{

    function get activateTweenType():String;

    function set activateTweenType(value:String):void;

    function get deactivateTweenType():String;

    function set deactivateTweenType(value:String):void;

    function get type():String;

    function set type(value:String):void;

    function activate(param:Object = null):void;

    function deactivate():void;

    function callAfterActivate():void

    function callAfterDeactivate():void

    function getTweenParam(actionType:String):Array;

    //function release():void;

}
}
