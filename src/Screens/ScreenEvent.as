/**
 * Created by Administrator on 18.07.16.
 */
package Screens {
import starling.events.Event;

public class ScreenEvent extends Event {
    public static const type:String = 'GAME_SCREEN_EVENT';

    public static const SCREEN_ACTIVATED:String = 'screen_activated';
    public static const SCREEN_DEACTIVATED:String = 'screen_deactivated';
    public static const SCREEN_CAN_REMOVE:String = 'screen_can_remove';

    public function ScreenEvent(type:String, bubbles:Boolean = false, data:Object = null) {
        super(type, bubbles, data);
    }
}
}
