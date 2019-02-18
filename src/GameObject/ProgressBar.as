/**
 * Created by plasma_trip on 26.04.15.
 */
package GameObject {
import starling.display.Image;
import starling.display.Sprite;
import starling.textures.Texture;

public class ProgressBar extends Sprite {
    private var bar:Image;

    public function ProgressBar() {
        //bar = new Image(Texture.fromColor(Const.stageWidth, 8, 0x2CFFFFFF));
        bar = new Image(Const.assets.getTexture('progressBar'));
        bar.pivotX = bar.width - Const.stageWidth;
        bar.pivotY = bar.height * 0.5;
        addChild(bar);
    }

    public function update(scale:Number):void{
        bar.x = Const.stageWidth * scale - Const.stageWidth;
        //bar.scaleX = scale;
    }
}
}
