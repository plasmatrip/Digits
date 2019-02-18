/**
 * Created by Администратор on 14.10.15.
 */
package Screens {
public class ScreenType {
    public static const SCR_MAIN:String = 'MAIN_SCREEN';
    public static const SCR_GAME:String = 'GAME_SCREEN';
    public static const SCR_PAUSE:String = 'PAUSE_SCREEN';
    public static const SCR_SONG_SHOP:String = 'SONG_SHOP_SCREEN';

    public static function getScreen(screenType:String, param:Object = null):GameScreen
    {
        var screen:GameScreen = null;
        switch (screenType){
            case SCR_MAIN:
                screen =  new ScrMain(param);
                break;
            case SCR_GAME:
                screen =  new ScrGame(param);
                break;
            case SCR_SONG_SHOP:
                screen =  new ScrBuySong(param);
                break;
            case SCR_PAUSE:
                //screen =  new ScrPause();
                break;
        }
        return screen;
    }
}
}
