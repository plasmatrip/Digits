/**
 * Created by plasma_trip on 25.02.15.
 */
package Screens{

import GameObject.ColumnSelector;
import GameObject.Gui;
import GameObject.Scene;
import GameObject.Tile;
import Geom.Vec2D;
import Tweens.TweenFactory;

import com.funkypandagame.stardustplayer.SimPlayer;
import com.funkypandagame.stardustplayer.project.ProjectValueObject;

import idv.cjcat.stardustextended.Stardust;
import idv.cjcat.stardustextended.actions.Action;
import idv.cjcat.stardustextended.clocks.SteadyClock;
import idv.cjcat.stardustextended.clocks.SteadyClock;
import idv.cjcat.stardustextended.emitters.Emitter;

import idv.cjcat.stardustextended.handlers.starling.StardustStarlingRenderer;

//import ch.badmojo.color.Color;
//import ch.badmojo.color.ColorWheel;

import com.catalystapps.gaf.core.GAFTimelinesManager;
import com.catalystapps.gaf.display.GAFMovieClip;
import flash.filesystem.File;
import flash.geom.Point;
import starling.animation.Transitions;
import starling.animation.Tween;
import starling.core.Starling;
import starling.display.Image;
import starling.display.MovieClip;
import starling.display.Sprite;
import starling.events.EnterFrameEvent;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;
import starling.text.BitmapFont;
import starling.text.TextField;
import starling.utils.Align;
import starling.utils.Color;
import treefortress.sound.SoundAS;
import treefortress.sound.SoundInstance;

public class ScrGame extends GameScreen {
    private var tapText:TextField;
    private var gameState:uint;
    private var gui:Gui;
    private var tiles:Vector.<Tile>;
    private var tileField:Sprite;
    private var columnSelector:ColumnSelector;
    private var explosions:Vector.<MovieClip>;
    private var progress:Number;
    private var progressInc:Number;
    private var level:int;
    private var lastCol:int;
    private var lastRow:int;
    private var tileDownMode:Boolean = false;
    public var rising:int;
    private var scrLoadSounds:Sprite;
    private var loadSoundsBar:Image;
    private var scenes:Vector.<Scene>;
    private var colors:Vector.<uint> = new <uint>[0xF05B5C, 0xF0C41B, 0x4FBA70, 0x2F96C0, 0x965CA5];
    private var musicians:Vector.<String> = new <String>['Char_1', 'Char_2', 'Char_3'];
    private var currentColor:int;
    private var currentMusician:int;
    private var canAddLine:Boolean = true;
    private var addLineCount:int = 0;

    private var lastTouchTile:Tile;
    private var lastTouch:Touch;

    private var comboParticles:Vector.<SimPlayer>;

    private var gameMode:uint = 0;

    public function ScrGame(param:Object = null) {
        type = ScreenType.SCR_GAME;
        activateTweenType = TweenFactory.MOVE_OUT;
        var background:Image = new Image(Const.assets.getTexture('back_top_2'));
        background.pivotX = background.width * 0.5;
        background.pivotY = background.height;
        background.x = Const.halfStageWidth;
        background.y = Const.BACK_Y + 4;

        var scaleY:Number = background.y / background.height;
        var scaleX:Number = Const.stageWidth / background.width;
        background.scale = scaleY > scaleX ? scaleY : scaleX;

        addChild(background);
        background = new Image(Const.assets.getTexture('back_down'));
        background.x = background.pivotX = background.width * 0.5;
        background.y = Const.BACK_Y;
        addChild(background);

        var back:Image = new Image(Const.assets.getTexture('tile_field3'));
        back.scale = Const.contentScale;
        back.x = (Const.stageWidth - back.width) * 0.5;
        back.y = Const.stageHeight - back.height - 12;//4;
        addChild(back);

        tileField = new Sprite();
        tileField.scale = Const.contentScale;
        tileField.x = back.x;
        tileField.y = back.y;
        addChild(tileField);

        SoundAS.addSound('1', Const.assets.getSound('01'));// Ударные'));
        SoundAS.addSound('2', Const.assets.getSound('02'));// Бас'));
        SoundAS.addSound('3', Const.assets.getSound('03'));// Колокольчик'));
        SoundAS.addSound('4', Const.assets.getSound('04'));// Гармошка'));
        SoundAS.addSound('5', Const.assets.getSound('05'));// Флейта'));
        SoundAS.addSound('6', Const.assets.getSound('06'));// Синтезатор'));
        SoundAS.addSound('7', Const.assets.getSound('07'));// Гитара'));
        SoundAS.addSound('8', Const.assets.getSound('08'));// Голос'));

        if(param) {
            if(param.hasOwnProperty('mode')){
                gameMode = param.mode;
            }
        }
    }

    override public function activate(param:Object = null):void{
        gui = new Gui();
        gui.y = -gui.height;

        addChild(gui);

        Const.CURRENT_TARGET = int(Const.gameDescription.currentTarget);
        Const.CURRENT_MOVES = Const.gameDescription.targets.target.(@number == Const.CURRENT_TARGET).moves;
        updateGUI();

        if(param) {
            if(param.hasOwnProperty('mode')){
                gameMode = param.mode;
            }
        }
    }

    override public function callAfterActivate():void{
        var tween:Tween = new Tween(gui, 0.5, Transitions.EASE_OUT_BOUNCE);
        tween.moveTo(gui.x, 0);
        tween.onComplete = function():void{
            addEventListener(TouchEvent.TOUCH, onTouch);
            addEventListener(EnterFrameEvent.ENTER_FRAME, update);
            start();
        };
        Starling.juggler.add(tween);
    }

    override public function deactivate():void {
        dispatchEvent(new ScreenEvent(ScreenEvent.SCREEN_DEACTIVATED, true, {'type':type}));
    }

    override public function callAfterDeactivate():void {
        dispatchEvent(new ScreenEvent(ScreenEvent.SCREEN_CAN_REMOVE, true, {'type':type}));
    }


    override public function getTweenParam(actionType:String):Array{
        var ret:Array = null;
        switch (actionType){
            case ScreenManager.ACTION_ACTIVATE:
                ret = [this,  1, new Point(), callAfterActivate, null];
                break;
            case ScreenManager.ACTION_DEACTIVATE:
                break;
        }
        return ret;
    }

    private function start():void{
        Const.currentSoundInstance = SoundAS.getSound(String(1));
        Const.currentSoundInstance.play(0, 0, -1).fadeTo(1, 5000);

        removeChild(tapText);
        tapText = null;

        Const.MAX_VALUE = int(Const.gameDescription.maxValue);
        lastCol = -1;
        lastRow = -1;

        gui.tweenGuiElement();

        progress = 100;
        progressInc = 0.1;
        level = 100;

        tiles = new Vector.<Tile>;
        explosions = new Vector.<MovieClip>();

        columnSelector = new ColumnSelector();
        columnSelector.visible = false;
        tileField.addChild(columnSelector);

        if(gameMode != GameState.GS_CHANGE_TILES) {
            canAddLine = true;
            addLineCount++;
        }else{
            Const.MAX_VALUE = 24;
            generateRandomTiles();
        }

        gameState = GameState.GS_PLAY;

        scenes = new <Scene>[];

        currentColor = 0;
        currentMusician = 0;

        comboParticles = new <SimPlayer>[];
        //comboParticlePlayer = new SimPlayer();
        //comboParticlePlayer.setProject(Const.comboParticleProject);
    }

    private function generateRandomTiles():void{
        var tile:Tile;
        var value:int;
        var row:int = Const.MAX_ROW;
        var col:int = Const.MAX_COL;
        var numbers:Vector.<Boolean> = new Vector.<Boolean>(row*col, true);
        var i:int = numbers.length;
        var count:int = 0;
        while(--i > -1){
            numbers[i] = false;
        }
        if(tiles.length == 0){
            for(row = Const.MAX_ROW; row > 0; row--){
                for(col = Const.MAX_COL; col > 0; col--){
                    /*value = Math.floor(Math.random()*(Const.MAX_VALUE))+1;
                    while(numbers[value] && count < 24){
                        value = Math.floor(Math.random()*(Const.MAX_VALUE))+1;
                    }
                    count++;
                    numbers[value] = true;*/
                    if(count == Const.MAX_VALUE){
                        count = 0;
                    }
                    count++;
                    value = count;
                    tile = new Tile(value);
                    tile.x = (col) * Const.CELL_SIZE - Const.HALF_CELL_SIZE;
                    tile.y = (row) * Const.CELL_SIZE - Const.HALF_CELL_SIZE;
                    tile.isRising = false;
                    tileField.addChild(tile);
                    tiles[tiles.length] = tile;
                }
            }
        }else{
            i = tiles.length;
            while(--i > -1){
                value = Math.floor(Math.random()*(Const.MAX_VALUE))+1;
                while(numbers[value] && count < Const.MAX_VALUE){
                    value = Math.floor(Math.random()*(Const.MAX_VALUE))+1;
                }
                count++;
                numbers[value] = true;
                tiles[i].value = value;
            }
        }
    }

    private function addMusician():void{
        if(scenes.length == 8){
            return;
        }
        var scene:Scene;
        var _w:Number;
        var _h:Number;
        currentColor++;
        if(currentColor > colors.length - 1){
            currentColor = 0;
        }
        switch(scenes.length){
            case 0:
                _w = Const.stageWidth;
                _h = Const.BACK_Y + 4;
                scene = new Scene(_w, _h, colors[currentColor], musicians[currentMusician]);
                scene.eraser();
                addChild(scene);
                break;
            case 1:
                scenes[0].moveToLeft(Const.halfStageWidth);
                _w = Const.halfStageWidth;
                _h = Const.BACK_Y + 4;
                scene = new Scene(_w, _h, colors[currentColor], musicians[currentMusician]);
                scene.x = Const.stageWidth;
                scene.show(Const.halfStageWidth, 0);
                addChild(scene);
                break;
            case 2:
                scenes[0].moveToDown((Const.BACK_Y + 4) * 0.5, (Const.BACK_Y + 4) * 0.5, 0.75);
                scenes[1].moveToDown((Const.BACK_Y + 4) * 0.5, (Const.BACK_Y + 4) * 0.5, 0.75);
                _w = Const.stageWidth;
                _h = (Const.BACK_Y + 4) * 0.5;
                scene = new Scene(_w, _h, colors[currentColor], musicians[currentMusician]);
                scene.y = -scene.height;
                scene.show(0, 0);
                addChild(scene);
                break;
            case 3:
                scenes[2].moveToLeft(Const.halfStageWidth);
                _w = Const.halfStageWidth;
                _h = (Const.BACK_Y + 4) * 0.5;
                scene = new Scene(_w, _h, colors[currentColor], musicians[currentMusician]);
                scene.x = Const.stageWidth;
                scene.show(Const.halfStageWidth, 0);
                addChild(scene);
                break;
            default:
                _w = Const.stageWidth / (Math.floor(scenes.length / 2) + 1);
                if(scenes.length / 2 == Math.floor(scenes.length / 2)){
                    for(var i:int = 0; i < scenes.length; i++){
                        if(i < 4){
                            scenes[i].moveToLeft(_w, scenes[i].x > 0 ? scenes[i].x - (scenes[i].quad.width - _w) : 0);
                        }else{
                            scenes[i].moveToLeft(_w, scenes[i].x > 0 ? scenes[i].x - (scenes[i].quad.width - _w) * 2 : 0);
                        }
                    }
                    _h = Const.BACK_Y + 4;
                    scene = new Scene(_w, _h, colors[currentColor], musicians[currentMusician]);
                    scene.x = Const.stageWidth;
                    scene.show(Const.stageWidth - _w, 0);
                    addChild(scene);
                }else{
                    scenes[scenes.length - 1].moveToDown((Const.BACK_Y + 4) * 0.5, (Const.BACK_Y + 4) * 0.5, 0.75);
                    _h = (Const.BACK_Y + 4) * 0.5;
                    scene = new Scene(_w, _h, colors[currentColor], musicians[currentMusician]);
                    scene.x = Const.stageWidth - _w;
                    scene.y = -scene.height;
                    //scene.show(-1, 0);
                    scene.show(scene.x, 0);
                    addChild(scene);
                }
                break;
        }
        scenes[scenes.length] = scene;
        currentMusician++;
        if(currentMusician > musicians.length - 1){
            currentMusician = 0;
        }
    }

    private function restart():void{
        Const.CURRENT_TARGET = int(Const.gameDescription.currentTarget);
        Const.CURRENT_MOVES = Const.gameDescription.targets.target.(@number == Const.CURRENT_TARGET).moves;
        Const.MAX_VALUE = int(Const.gameDescription.maxValue);

        var i:int = tiles.length;
        while(--i > -1){
            Starling.juggler.removeTweens(tiles[i]);
            tiles[i].removeEventListeners();
            tiles[i].removeFromParent();
            tiles.splice(i,1);
        }

        i = explosions.length;
        while( -- i > -1){
            explosions[i].removeFromParent();
            explosions.splice(i, 1);
        }

        i = scenes.length;
        while( -- i > -1){
            scenes[i].removeFromParent();
            scenes.splice(i, 1);
        }

        lastCol = -1;
        lastRow = -1;

        progress = 100;
        progressInc = 0.1;
        level = 100;

        columnSelector.visible = false;

        canAddLine = true;
        addLineCount++;

        addMusician();

        gameState = GameState.GS_PLAY;
    }

    private function gameOver():void{
        SoundAS.stopAll();
        removeEventListener(EnterFrameEvent.ENTER_FRAME, update);

        gameState = GameState.GS_GAMEOVER;

        removeChild(gui);
        gui = null;

        var i:int;
        var sm:SimPlayer;
        i = comboParticles.length;
        while(--i > -1){
            sm = comboParticles[i];
            for each (var emitter: Emitter in Const.comboParticleProject.emittersArr)
            {
                SteadyClock(emitter.clock).ticksPerCall = 0;
            }
        }

        i = tiles.length;
        while(--i > -1){
            Starling.juggler.removeTweens(tiles[i]);
            tiles[i].removeEventListeners();
            tiles[i].removeFromParent();
            tiles[i] = null;
        }
        tiles = null;

        i = explosions.length;
        while( -- i > -1){
            explosions[i].removeFromParent();
        }
        explosions = null;

        i = scenes.length;
        while( -- i > -1){
            scenes[i].removeFromParent();
            scenes.splice(i, 1);
        }
        scenes = null;

        tileField.removeChild(columnSelector);
        columnSelector = null;

        tapText = new TextField(250, 40, 'GAME OVER');
        tapText.format.verticalAlign = Align.TOP;
        tapText.format.setTo('font');
        tapText.x = Const.halfStageWidth;
        tapText.y = Const.halfStageHeight;
        tapText.pivotX = tapText.width * 0.5;
        tapText.pivotY = tapText.height * 0.5;
        tapText.format.color = starling.utils.Color.WHITE;
        tapText.format.size = BitmapFont.NATIVE_SIZE;
        tapText.touchable = false;
        addChild(tapText);
    }

    private function addNewLine():void{
        canAddLine = false;
        rising = 7;
        var tile:Tile;
        var value:int;
        var i: int = Const.MAX_COL;
        while(--i > -1){
            value = Math.floor(Math.random()*(Const.MAX_VALUE))+1;
            tile = new Tile(value);
            tile.x = (i + 1) * Const.CELL_SIZE - Const.HALF_CELL_SIZE;
            tile.y = Const.FULL_ROW * Const.CELL_SIZE - Const.HALF_CELL_SIZE;
            tileField.addChild(tile);
            tiles[tiles.length] = tile;
            tile.addEventListener(EnterFrameEvent.ENTER_FRAME, moveTileToUp);
        }
    }

    //двигаем тайл вверх после добавления новой линии
    private function moveTileToUp(e:EnterFrameEvent):void{
        var target:Tile = Tile(e.target);
        var upSpeed:Number = 3;
        var tile1:Tile;
        var tile2:Tile;
        var i:int = tiles.length;
        var penetrationVector:Vec2D;
        var j:int;
        var callAfterRemove:Function = null;
        if(target.y - upSpeed <= Const.MAX_ROW * Const.CELL_SIZE - Const.HALF_CELL_SIZE){
            upSpeed = target.y - (Const.MAX_ROW * Const.CELL_SIZE - Const.HALF_CELL_SIZE);
            target.removeEventListener(EnterFrameEvent.ENTER_FRAME, moveTileToUp);
            target.isRising = false;
            callAfterRemove = checkColForEqualTile;
            rising--;
        }
        while(--i > -1){
            tile1 = tiles[i];
            if(tile1.col == target.col || tile1.left == target.col || tile1.rigth == target.col){
                if(!tile1.isTouch){
                    tile1.y -= upSpeed;
                }else{
                    j = tiles.length;
                    while(--j > -1){
                        tile2 = tiles[j];
                        if(tile2.col == target.col && tile2 != tile1){
                            penetrationVector = tile1.aabb.checkIntersection(tile2.aabb);
                            if(penetrationVector.length != 0){
                                tile1.y += penetrationVector.y;
                                break;
                            }
                        }
                    }
                }
            }
        }
        if(callAfterRemove != null){
            callAfterRemove(target.col);
        }
        if(rising == 0){
            canAddLine = true;
            addLineCount--;
        }
    }

    //проверяем свободна ли верхняя строка
    private function isEmptyLine():Boolean{
        var tile:Tile;
        var i:int = tiles.length;
        while(--i > -1){
            tile = tiles[i];
            if(!tile.isTouch && Math.floor(tile.y / Const.CELL_SIZE) == 0){
                return false;
            }
        }
        return true;
    }

    //проверяем колонку на одинаковые тайлы, если равны опускаем вниз с тайла, находящегося с верху
    private function checkColForEqualTile(col:int):void{
        if(gameState == GameState.GS_GAMEOVER){
            return;
        }
        var tile:Tile;
        var anotherTile:Tile;
        var j:int;
        var i:int = tiles.length;
        //в цикле берем тайл, расположеный в проверяемой колонке
        while(--i > -1){
            tile = tiles[i];
            if(tile.col == col && tile.bottom < Const.MAX_ROW && !tile.isTouch){//tile != touchTile){
                j = tiles.length;
                //в цикле берем тайлы из той же колонки находящиеся над тайлом tile
                while(--j > -1){
                    anotherTile = tiles[j];
                    if(anotherTile != tile && anotherTile.col == col && anotherTile.row == tile.row - 1 && anotherTile.row < Const.MAX_ROW && tile.value == anotherTile.value){
                        incrementTile(1, anotherTile, tile, true);
                        colToDown(anotherTile.col, anotherTile.row);
                        return;
                    }
                }
            }
        }

    }

    //опускаем колонку вниз после того как убрали тайл из нее
    //передаем в функцию строку и колонку из которых переместили тайл
    private function colToDown(col:int, row:int):void{
        var tile:Tile;
        //ищем самый первый тайл над пустым местом
        for(var j:int = row; j > -1; j--){
            var i:int = tiles.length;
            while(--i > -1){
                tile = tiles[i];
                if(tile.col == col && tile.row == j){
                    tileDownMode = true;
                    tile.addEventListener(EnterFrameEvent.ENTER_FRAME, moveColToDown);
                    return;
                }
            }
        }
        //если нет пустого места в колонке между тайлами, то проверим на наличие одинаковых тайлов
        Starling.juggler.delayCall(checkColForEqualTile, 0.07, [col]);
    }

    //слушатель для опускаемого вниз тайла и всех тайлов выше него
    private function moveColToDown(e:EnterFrameEvent):void{
        var moveTile:Tile = Tile(e.target);//опускаемы тайл
        var col:int = moveTile.col;//колонка опускаемого тайла
        var row:int = moveTile.row;//строка опускаемого тайла
        var target:Tile;
        var tile:Tile;
        var penetrationVector:Vec2D;
        //в цикле проходимся по строкам поля начиная со строки в которой находится опускаемый тайл
        for(var i:int = row; i > -1; i--){
            var j:int = tiles.length;
            //в цикле выбираем тайлы которые находятся в i строке и в колонке опускаемого тайла
            while(--j > -1){
                target = tiles[j];//текущий тайл из массива
                if(target.row == i && target.col == col && !target.isTouch){//target != touchTile){
                    //опускаем тайл вниз и проверяем на пересечение с нижним тайлом
                    target.y += 10;//TILE_DOWN_SPEED;
                    var k:int = tiles.length;
                    //в цикле проходимсчя по тайлам, выбирая находящийся в той же колонке и той же строке или строке на 1 ниже
                    while(--k > -1){
                        tile = tiles[k];
                        if(tile.col == target.col && (tile.row == target.row || tile.row - 1 == target.row) && tile != target && !tile.isTouch){//tile != touchTile ){
                            penetrationVector = target.aabb.checkIntersection(tile.aabb);
                            if(penetrationVector.length != 0 || tile.y - target.y < Const.CELL_SIZE){
                                target.y = tile.y - Const.CELL_SIZE;
                                if(target == moveTile){
                                    tileDownMode = false;
                                    moveTile.removeEventListener(EnterFrameEvent.ENTER_FRAME, moveColToDown);
                                    col = moveTile.col;
                                    Starling.juggler.delayCall(checkColForEqualTile, 0.07, [col]);//checkColForEqualTile(moveTile.col);
                                }
                            }
                        }
                    }
                    //проверяем ушел за границы поля или нет
                    if(target.y > Const.FIELD_HEIGHT - Const.HALF_CELL_SIZE){
                        target.y = Const.FIELD_HEIGHT - Const.HALF_CELL_SIZE;
                        if(target == moveTile){
                            tileDownMode = false;
                            moveTile.removeEventListener(EnterFrameEvent.ENTER_FRAME, moveColToDown);
                            col = moveTile.col;
                            Starling.juggler.delayCall(checkColForEqualTile, 0.07, [col]);//checkColForEqualTile(moveTile.col);
                        }
                    }
                }
            }
        }
    }

    //двигали тайл и попали на такой же. target - тайл который убираем, tile - тайл который увеличиваем на 1
    private function incrementTile(value:int, target:Tile,  tile:Tile, tweenOut:Boolean = false):void{
        columnSelector.visible = false;

        //tile.value++;
        tile.value += value;
        tile.incTween();

        var mc:MovieClip = new MovieClip(Const.assets.getTextures('explosion'), 60);
        mc.x = tile.x;
        mc.y = tile.y;
        mc.pivotX = mc.width  * 0.5;
        mc.pivotY = mc.height * 0.5;
        mc.loop = false;
        mc.play();
        tileField.addChild(mc);
        explosions[explosions.length] = mc;
        Starling.juggler.add(mc);

        target.removeEventListeners();
        tiles.splice(tiles.indexOf(target), 1);
        if(tweenOut){
            var tween:Tween = new Tween(target,  0.05);
            tween.fadeTo(0.001);
            tween.moveTo(target.x, target.y + target.halfHeight);
            tween.onComplete = function(target:Tile):void{
                if(target.parent){
                    target.removeFromParent();
                }
            };
            tween.onCompleteArgs = [target];
            Starling.juggler.add(tween);
        }else{
            tileField.removeChild(target);
        }
        //если новое значение равно цели то добавляем новую линию и выбираем новую цель
        if(tile.value == Const.CURRENT_TARGET){
            addMusician();
            if(Const.gameDescription.targets.target.(@number == Const.CURRENT_TARGET).hasOwnProperty('song')){
                var si:SoundInstance = SoundAS.getSound(String(Const.gameDescription.targets.target.(@number == Const.CURRENT_TARGET).song));
                if(si){
                    if(Const.currentSoundInstance == null){
                        Const.currentSoundInstance = si;
                        si.play(0, 0, -1).fadeTo(1, 5000);
                    }else{
                        si.play(0, Const.currentSoundInstance.position, -1).fadeTo(1, 5000);
                    }
                }
            }
            Const.MAX_VALUE++;
            Const.CURRENT_TARGET++;
            Const.CURRENT_MOVES = Const.gameDescription.targets.target.(@number == Const.CURRENT_TARGET).moves;
            updateGUI();
            if(isEmptyLine()) {
                //addNewLine();
                addLineCount++;
            }
        }else{
            //if(rising == 0){
                if(!checkPossibleMoves()) {
                    if (isEmptyLine()) {
                        addLineCount++;
                        //addNewLine();
                    }
                }
            //}
        }
    }

    //проверяем есть ли возможность с текущими фишками достич цели
    private function checkPossibleMoves():Boolean{
        //создаем массив размерностью максимального достигнутого числа
        //и заносим в него количество фишек одного типа
        var values:Vector.<int> = new Vector.<int>(Const.CURRENT_TARGET, true);
        var i:int;
        for(i = 0; i < tiles.length; i++){
            values[tiles[i].value - 1]++;
        }
        for(i = 0; i < values.length; i++){
            if(values[i] > 1){
                return true;
            }
        }
        return false;
    }

    //отпустили тайл над пустым местом, двигаем его вниз
    private function moveTileToDown(e:EnterFrameEvent):void{
        var target:Tile = Tile(e.target);
        target.y += 25;//TILE_DOWN_SPEED;
        //проверяем тайл на нахождение в границах поля
        if(target.y > Const.FIELD_HEIGHT - Const.HALF_CELL_SIZE){
            target.y = Const.FIELD_HEIGHT - Const.HALF_CELL_SIZE;
            target.removeEventListener(EnterFrameEvent.ENTER_FRAME, moveTileToDown);
            target.isTouch = false;
            //проверяем тайл упал на тоже место или на новое
            if(lastCol != target.col || lastRow != target.row){
                Const.CURRENT_MOVES--;
                updateGUI();
            }
            lastCol = -1;
            lastRow = -1;
        }
        //проверяем тайл на пересечение с другими тайлами, находящимися в том же столбце и в тоже строке или строке на 1 ниже
        var penetrationVector:Vec2D;
        var tile:Tile;
        var i:int = tiles.length;
        while(--i > -1){
            tile = tiles[i];
            if(target != tile && target.col == tile.col && target.row <= tile.top && target != tile && !tile.isTouch){//tile != touchTile){
                penetrationVector = target.aabb.checkIntersection(tile.aabb);
                //проверяем наличие пересечения или что бы расстояние между тайлами было не меньше размера клетки
                if(penetrationVector.length != 0 || tile.y - target.y < Const.CELL_SIZE){
                    target.y = tile.y - Const.CELL_SIZE;
                    target.removeEventListener(EnterFrameEvent.ENTER_FRAME, moveTileToDown);
                    target.isTouch = false;
                    //проверяем тайл упал на тоже место или на новое
                    if(lastCol != target.col || lastRow != target.row){
                        Const.CURRENT_MOVES--;
                        updateGUI();
                    }
                    lastCol = -1;
                    lastRow = -1;

                    if(target.value == tile.value && target.canBeConnected(tile) && target.parent){
                        //incrementTile(target, tile);
                        //check combo start
                        if(lastTouchTile == target){
                            incrementTile(1, target, tile);
                            deleteRow(tile);
                            //trace('Combo!');
                            lastTouchTile = null;
                        }/*else if(lastTouchTile == tile){
                            incrementTile(2, target, tile);
                            //trace('Combo!');
                            lastTouchTile = null;
                        }*/else{
                            incrementTile(1, target, tile);
                            //trace('No combo!');
                            lastTouchTile = tile;

                            addParticlesToBonusTile(tile);
                        }
                        //check combo end
                        checkColForEqualTile(tile.col);
                        //colToDown(target.col,target.row);
                    }
                    checkColForEqualTile(target.col);
                    break;
                }
            }
        }
    }

    private function deleteRow(target:Tile):void{
        var tile:Tile;
        var mc:MovieClip;
        var i:int = tiles.length;
        while(--i > -1){
            tile = tiles[i];
            if(tile.row == target.row){
                tile.removeEventListeners();
                tiles.splice(i, 1);

                mc = new MovieClip(Const.assets.getTextures('explosion'), 60);
                mc.x = tile.x;
                mc.y = tile.y;
                mc.pivotX = mc.width  * 0.5;
                mc.pivotY = mc.height * 0.5;
                mc.loop = false;
                mc.play();
                tileField.addChild(mc);
                explosions[explosions.length] = mc;
                Starling.juggler.add(mc);

                var tween:Tween = new Tween(tile,  0.05);
                tween.fadeTo(0.001);
                tween.moveTo(tile.x, tile.y + tile.halfHeight);
                tween.onComplete = function(tile:Tile):void{
                    if(tile.parent){
                        tile.removeFromParent();
                    }
                    colToDown(tile.col,  tile.row);
                };
                tween.onCompleteArgs = [tile];
                Starling.juggler.add(tween);
            }
        }
        if(!checkPossibleMoves()) {
            if (isEmptyLine()) {
                addLineCount++;
                //addNewLine();
            }
        }
    }

    private function onTouch(touchEvent:TouchEvent):void {
        var touch:Touch = touchEvent.getTouch(this);
        var tile:Tile;
        var target:Tile;
        if(touch){
            switch (gameState){
                case GameState.GS_MENU:
                    if(touch.phase == TouchPhase.BEGAN){
                        start();
                    }
                    break;
                case GameState.GS_PLAY:
                    if(touch.target is Tile){
                        target = Tile(touch.target);
                        if(target.isRising){
                            return;
                        }
                        switch(touch.phase) {
                            case TouchPhase.BEGAN:
                                if(gameMode == GameState.GS_CHANGE_TILES){
                                    generateRandomTiles();
                                    return;
                                }
                                if(target){
                                    lastCol = target.col;
                                    lastRow = target.row;
                                    target.isTouch = true;
                                    columnSelector.visible = true;
                                    columnSelector.update(target, tiles);//1);
                                }
                                break;
                            case TouchPhase.MOVED:
                                if(target){//} && touchTile != null) {
                                    //смещение по осям
                                    var offsetX:Number = touch.globalX - touch.previousGlobalX;
                                    var offsetY:Number = touch.globalY - touch.previousGlobalY;
                                    var col:int = target.col;
                                    var row:int = target.row;

                                    //делим смещение на половину половины размера тайла для исключения туннелинга при определения пересечения с другим тайлом
                                    var xs:Number = Math.ceil(Math.abs(offsetX) / (target.halfWidth * 0.5));
                                    var ys:Number = Math.ceil(Math.abs(offsetY) / (target.halfHeight * 0.5));
                                    var segment:Number = xs > ys ? xs : ys;
                                    var stepX:Number = offsetX / segment;
                                    var stepY:Number = offsetY / segment;
                                    var penetrationVector:Vec2D = Vec2D.zero();
                                    var i:int;
                                    var isIntersect:Boolean = false;
                                    while(--segment > -1){
                                        target.x += stepX;
                                        target.y += stepY;
                                        i = tiles.length;
                                        while(--i > -1){
                                            tile = tiles[i];
                                            if(tile != target){
                                                penetrationVector = target.aabb.checkIntersection(tile.aabb);
                                                if(penetrationVector.length != 0){
                                                    /*if(lastTouch == touch){
                                                        return;
                                                    }else {
                                                        lastTouch = touch;
                                                    }*/
                                                    //trace(touchEvent.toString(), ' ', touch.toString(), ' ', touchEvent.timestamp);
                                                    //trace('MD: intersect');
                                                    isIntersect = true;
                                                    target.x += penetrationVector.x;
                                                    target.y += penetrationVector.y;
                                                    if(target.value == tile.value && target.canBeConnected(tile) && target.parent){
                                                        columnSelector.visible = false;
                                                        //incrementTile(target, tile);
                                                        //check combo start
                                                        if(lastTouchTile == target){
                                                            incrementTile(1, target, tile);
                                                            deleteRow(tile);
                                                            //trace('Combo!');
                                                            lastTouchTile = null;
                                                        }/*else if(lastTouchTile == tile){
                                                            incrementTile(2, target, tile);
                                                            //trace('Combo!');
                                                            lastTouchTile = null;
                                                        }*/else{
                                                            incrementTile(1, target, tile);
                                                            //trace('No combo!');
                                                            lastTouchTile = tile;

                                                            addParticlesToBonusTile(tile);
                                                        }
                                                        //check combo end
                                                        Const.CURRENT_MOVES--;
                                                        updateGUI();
                                                        checkColForEqualTile(tile.col);
                                                        colToDown(col,row);
                                                        return;
                                                    }
                                                }
                                            }
                                        }
                                    }

                                    //рейкаст для проверки пересечения, когда тачпойнт ушел с тайла
                                    if(!isIntersect){
                                        var touchPoint:Point = tileField.globalToLocal(new Point(touch.globalX, touch.globalY));
                                        if(!target.aabb.checkPointIntersection(touchPoint)){
                                            var end:Vec2D = new Vec2D(touchPoint.x, touchPoint.y);
                                            var beginTopLeft:Vec2D = new Vec2D(target.aabb.min.x, target.aabb.min.y);
                                            var beginTopRight:Vec2D = new Vec2D(target.aabb.max.x, target.aabb.min.y);
                                            var beginDownRight:Vec2D = new Vec2D(target.aabb.max.x, target.aabb.max.y);
                                            var beginDownLeft:Vec2D = new Vec2D(target.aabb.min.x, target.aabb.max.y);
                                            var cp:Number;
                                            var minCP:Number = Number.POSITIVE_INFINITY;
                                            i = tiles.length;
                                            while(--i > -1) {
                                                tile = tiles[i];
                                                if (tile != target) {
                                                    cp = tile.aabb.getRayIntersection(beginTopLeft, end);
                                                    if(cp < minCP){
                                                        minCP = cp;
                                                        penetrationVector = beginTopLeft;
                                                    }
                                                    cp = tile.aabb.getRayIntersection(beginTopRight, end);
                                                    if(cp < minCP){
                                                        minCP = cp;
                                                        penetrationVector = beginTopRight;
                                                    }
                                                    cp = tile.aabb.getRayIntersection(beginDownRight, end);
                                                    if(cp < minCP){
                                                        minCP = cp;
                                                        penetrationVector = beginDownRight;
                                                    }
                                                    cp = tile.aabb.getRayIntersection(beginDownLeft, end);
                                                    if(cp < minCP){
                                                        minCP = cp;
                                                        penetrationVector = beginDownLeft;
                                                    }
                                                }
                                            }
                                            if(minCP == Number.POSITIVE_INFINITY){
                                                target.x = touchPoint.x;
                                                target.y = touchPoint.y;
                                            }else{
                                                target.x += (end.x - penetrationVector.x) * minCP;
                                                target.y += (end.y - penetrationVector.y) * minCP;
                                            }
                                            i = tiles.length;
                                            while(--i > -1) {
                                                tile = tiles[i];
                                                if (tile != target) {
                                                    penetrationVector = target.aabb.checkIntersection(tile.aabb);
                                                    if (penetrationVector.length != 0) {
                                                        target.x += penetrationVector.x;
                                                        target.y += penetrationVector.y;
                                                    }
                                                }
                                            }
                                        }
                                    }

                                    if(target.x < target.halfWidth){
                                        target.x = target.halfWidth;
                                    }else if(target.x > Const.FIELD_WIDTH - target.halfWidth){
                                        target.x = Const.FIELD_WIDTH - target.halfWidth;
                                    }
                                    if(target.y < target.halfHeight){
                                        target.y = target.halfHeight;
                                    }else if(target.y > Const.FIELD_HEIGHT - target.halfHeight){
                                        target.y = Const.FIELD_HEIGHT - target.halfHeight;
                                    }

                                    //проверяем изменилась ли позиция тайла
                                    if(col != target.col){
                                        colToDown(col,row);
                                    }
                                    //if(columnSelector.visible){
                                        columnSelector.update(target, tiles);
                                    //}
                                }
                                break;
                            case TouchPhase.ENDED:
                                if(gameMode == GameState.GS_CHANGE_TILES){
                                    return;
                                }
                                if(target){
                                    columnSelector.visible = false;
                                    //target = Tile(touch.target);
                                    target.x = target.col * Const.CELL_SIZE + Const.HALF_CELL_SIZE;
                                    target.y = target.row * Const.CELL_SIZE + Const.HALF_CELL_SIZE;
                                    target.addEventListener(EnterFrameEvent.ENTER_FRAME, moveTileToDown);
                                }
                                break;
                        }
                    }else{
                        if(touch.phase == TouchPhase.BEGAN) {
                            switch (touch.target.name) {
                                case 'BTN_RESTART':
                                    //restart();
                                    addMusician();
                                    //gameOver();
                                    break;
                                case 'SETTINGS':
                                    scrLoadSound();
                                    break;
                                case 'BTN_HOME':
                                    gameOver();
                                    break;
                                case 'BTN_MUTE':
                                    SoundAS.fadeAllTo(0);
                                    gui.btnMute.visible = false;
                                    gui.btnUnmute.visible = true;
                                    break;
                                case 'BTN_UNMUTE':
                                    playAllOpenSound();
                                    gui.btnMute.visible = true;
                                    gui.btnUnmute.visible = false;
                                    break;
                            }
                        }
                    }
                    break;
                case GameState.GS_GAMEOVER:
                    if(touch.phase == TouchPhase.BEGAN){
                        ScreenManager.instance.activateScreen(ScreenType.SCR_MAIN);
                        ScreenManager.instance.deactivateScreen(this.type);
                    }
                    break;
            }
        }
    }

    private function addParticlesToBonusTile(tile:Tile):void{
        var p:int = comboParticles.length;

        while(--p > -1){
            for each (var emitter: Emitter in comboParticles[p].getProject().emittersArr)
            {
                for each (var action:Action in emitter.actions){
                    if(!action.active){
                        action.active = true;
                    }
                }
                emitter.active = false;
            }
        }

        var sm:SimPlayer = new SimPlayer();
        sm.setProject(Const.comboParticleLoader.createProjectInstance());
        sm.setRenderTarget(tile);
        comboParticles[comboParticles.length] = sm;
        sm = null;
    }

    private function scrLoadSound():void{
        Const.soundAssets.purge();
        scrLoadSounds = new Sprite();
        scrLoadSounds.addChild(new Image(Const.assets.getTexture('loadingsounds')));
        loadSoundsBar = new Image(Const.assets.getTexture('loadingbar'));
        scrLoadSounds.addChild(loadSoundsBar);
        loadSoundsBar.x = 16.40;
        loadSoundsBar.y = 29.5;
        loadSoundsBar.scaleX = 0;
        scrLoadSounds.pivotX = scrLoadSounds.width * 0.5;
        scrLoadSounds.pivotY = scrLoadSounds.height * 0.5;
        scrLoadSounds.x = Const.halfStageWidth;
        scrLoadSounds.y = -scrLoadSounds.height;
        addChild(scrLoadSounds);

        var tween:Tween = new Tween(scrLoadSounds, 0.5, Transitions.EASE_OUT_BACK);
        tween.moveTo(scrLoadSounds.x, Const.halfStageHeight);
        tween.onComplete = callAfterShowLoadScreen;
        Starling.juggler.add(tween);
    }

    private function loadSounds(progress:Number):void{
        loadSoundsBar.scaleX = progress;
        if(progress == 1){
            var tween:Tween = new Tween(scrLoadSounds, 0.5, Transitions.EASE_IN_BACK);
            tween.moveTo(scrLoadSounds.x, - scrLoadSounds.y);
            tween.onComplete = callAfterUnshowLoadScreen;
            tween.delay = 0.25;
            Starling.juggler.add(tween);

            Const.currentSoundInstance = null;
            SoundAS.removeAll();
            var sounds:Vector.<String> = Const.soundAssets.getSoundNames();
            var i:int = sounds.length;
            while(--i > -1){
                SoundAS.addSound(sounds[i], Const.soundAssets.getSound(sounds[i]));
            }
            sounds = null;

            playAllOpenSound();
        }
    }

    private function playAllOpenSound():void{
        var si:SoundInstance;
        var i:int = 0;
        while(++i <= Const.MAX_VALUE){
            si = SoundAS.getSound(String(i));
            if(si){
                if(Const.currentSoundInstance == null){
                    Const.currentSoundInstance = si;
                }
                si.play(1, 0, -1);
            }
        }
    }

    private function callAfterShowLoadScreen():void{
        var file:File = new File(File.applicationDirectory.nativePath + '/music');
        var dir:Array = file.getDirectoryListing();
        var i:int = dir.length;
        while(--i > -1){
            if(dir[i].nativePath.indexOf('.mp3') == -1){
                dir.splice(i,1);
            }
        }
        if(dir.length){
            i = dir.length;
            while(--i > -1) {
                Const.soundAssets.enqueue(
                        file.resolvePath(dir[i].nativePath)
                );
            }
            Const.soundAssets.loadQueue(loadSounds);
        }
    }

    private function callAfterUnshowLoadScreen():void{
        scrLoadSounds.removeFromParent();
        loadSoundsBar.dispose();
        loadSoundsBar = null;
        scrLoadSounds.dispose();
        scrLoadSounds = null;
    }

    private function updateGUI():void{
        gui.txtTarget.text = 'TARGET ' + String(Const.CURRENT_TARGET);
        gui.txtMoves.text = 'MOVES ' + String(Const.CURRENT_MOVES);
        gui.recordText = Const.CURRENT_TARGET;
    }

    private function update(e:EnterFrameEvent):void {
        switch (gameState){
            case GameState.GS_PLAY:
                var i:int;
                i = comboParticles.length;
                while(--i > -1){
                    comboParticles[i].stepSimulation(e.passedTime);
                }
                if(addLineCount > 0){
                    if(canAddLine){
                        addNewLine();
                        //aa
                    }
                }
                if(explosions){
                    i = explosions.length;
                    while(--i > -1){
                        if(explosions[i].isComplete){
                            tileField.removeChild(explosions[i]);
                            explosions.splice(i, 1);
                        }
                    }
                }
                if(Const.CURRENT_MOVES <= 0 && !tileDownMode){
                    if(isEmptyLine()) {
                        //addNewLine();
                        addLineCount++;
                        Const.CURRENT_MOVES = Const.gameDescription.targets.target.(@number == Const.CURRENT_TARGET).moves;
                        gui.txtMoves.text = 'MOVES ' + String(Const.CURRENT_MOVES);
                    }else{
                        gameOver();
                    }
                }
                break;
        }
    }

}
}
