/**
 * Created by Администратор on 23.09.15.
 */
package GameObject {
import com.catalystapps.gaf.core.GAFTimelinesManager;
import com.catalystapps.gaf.data.GAFTimeline;
import com.catalystapps.gaf.display.GAFMovieClip;

public class Hero extends GAFMovieClip {
    public static const ANIM_TYPE1:String = 'Hero1';

    public static const SQNS_STAY:String = 'Stay';
    public static const SQNS_PUNCH:String = 'Punch';
    public static const SQNS_:String = 'Shoot';
    public static const SQNS_SHOOT:String = 'Shoot';

    public function Hero(animType:String){
        //this = GAFTimelinesManager.getGAFMovieClip('Animation', animType);
        super(GAFTimelinesManager.getGAFTimeline('Animation', animType));
    }

}
}
