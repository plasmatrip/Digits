/**
 * Created by Администратор on 08.10.15.
 */
package GameObject {
import GameObject.Tile;

import starling.display.Image;
import starling.display.Quad;
import starling.textures.Texture;

public class ColumnSelector extends Quad{//Image{

    public function ColumnSelector():void {
        //super(Texture.fromColor(Const.CELL_SIZE, 10, 0x99FFFF, 0.3));
        super(Const.CELL_SIZE, 10, 0x99FFFF);
        alpha = 0.3;
        pivotX = Const.CELL_SIZE * 0.5;
    }

    public function update(tile:Tile = null, tiles:Vector.<Tile> = null):void{
        x = tile.col * width + width * 0.5;
        y = tile.y + tile.halfHeight;
        var i:int = tiles.length;
        var target:Tile;
        while(--i > -1){
            if(tiles[i].col == tile.col && tiles[i] != tile && tiles[i].row > tile.row){
                if(target){
                    if(tiles[i].row < target.row){
                        target = tiles[i];
                    }
                }else{
                    target = tiles[i];
                }
            }
        }
        var h:Number = target ? target.y - tile.y - tile.height : Const.FIELD_HEIGHT - y;
        if(h < 10){
            scaleY = 0;
        }else{
            scaleY = 1;
            height = h;
        }
    }
}
}
