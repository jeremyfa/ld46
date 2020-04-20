package ld46.visuals;

import tracker.Observable;
import tracker.Autorun;
import tracker.Autorun.*;
import ld46.model.LevelData;
import ceramic.Visual;
import ceramic.Quad;
import ceramic.Color;

class LevelGrid extends Quad implements Observable {

    var layers:Array<Visual>;

    var characterShapesLayer:Visual;

    @observe public var levelData:LevelData = null;

    var gridVisuals:Array<LevelGridItem> = [];

    var characterVisuals:Array<Character> = [];

    var actionVisuals:Array<ActionStamp> = [];

    var layerTime = 0.0;

    var numRows:Int = 0;

    var numCols:Int = 0;

    public function new(levelData:LevelData) {

        super();

        transparent = true;
        this.levelData = levelData;

        initLayers();
        updateLayersPosition();

        autorun(updateGridItems);
        autorun(updateActionItems);
        autorun(updateCharacters);
        
    }

    function initLayers() {

        layers = [];
        for (i in 0...3) {
            var layer = new Visual();
            layer.anchor(0.5, 0.5);
            layer.depth = i + 1;
            layer.rotation = -20;
            add(layer);
            layers.push(layer);
        }

        app.onUpdate(this, delta -> {
            layerTime = (layerTime + delta * 0.5) % 1.0;
            updateLayersPosition();
        });

        characterShapesLayer = new Visual();
        characterShapesLayer.depth = 10;
        characterShapesLayer.anchor(0.5, 0.5);
        add(characterShapesLayer);

    }

    function updateLayersPosition() {

        var gapY = 1 + (Math.sin(layerTime * Math.PI * 2) + 1.0) * 0.25;

        for (i in 0...layers.length) {
            var layer = layers[i];
            layer.size(width, height);
            layer.skewX = -30;
            layer.x = width * 0.5;//2 * i + layer.skewX;
            layer.y = height * 0.5 - 2 * gapY * i;
        }

        characterShapesLayer.size(width, height);
        characterShapesLayer.pos(width * 0.5, height * 0.5);

    }

    function updateGridItems() {

        var levelData = this.levelData;

        if (levelData == null) {
            unobserve();
            for (item in gridVisuals) {
                item.destroy();
            }
            gridVisuals = [];
            return;
        }

        var grid = levelData.grid;
        unobserve();

        numCols = grid[0].length;
        numRows = grid.length;

        width = BLOCK_SIZE * numCols;
        height = BLOCK_SIZE * numRows;

        var y = 0;
        for (row in grid) {
            var x = 0;
            for (value in row) {
                var item = gridVisuals[y * numCols + x];
                if (item == null) {
                    item = new LevelGridItem(levelData, x, y, value);
                    gridVisuals[y * numCols + x] = item;
                    ((item:LevelGridItem) -> {
                        item.onPointerDown(this, info -> {
                            levelData.click(
                                item.blockX,
                                item.blockY
                            );
                        });
                    })(item);
                }
                else {
                    item.levelData = levelData;
                    item.value = value;
                    item.blockX = x;
                    item.blockY = y;
                }
                item.pos(
                    x * BLOCK_SIZE,
                    y * BLOCK_SIZE
                );
                switch value {
                    case GROUND:
                        layers[0].add(item);
                    case GOAL_A | GOAL_B | GOAL_C | GOAL_D | GOAL_E | KILL:
                        layers[1].add(item);
                    case WALL:
                        layers[2].add(item);
                }
                x++;
            }
            y++;
        }

        while (gridVisuals.length > numRows * numCols) {
            gridVisuals.pop().destroy();
        }
        
        updateLayersPosition();

        reobserve();

    }

    function updateActionItems() {

        var levelData = this.levelData;

        if (levelData == null) {
            unobserve();
            for (item in actionVisuals) {
                item.destroy();
            }
            actionVisuals = [];
            return;
        }

        var actions = levelData.actions;
        unobserve();

        for (i in 0...actions.length) {
            var actionData = actions[i];
            var item = actionVisuals[i];
            if (item == null) {
                item = new ActionStamp(i + 1);
                item.depth = 2;
                actionVisuals[i] = item;
                layers[0].add(item);
            }
            reobserve();
            if (actionData.x != -1 && actionData.y != -1) {
                unobserve();
                item.active = true;
                item.pos(
                    BLOCK_SIZE * actionData.x,
                    BLOCK_SIZE * actionData.y
                );
            }
            else {
                unobserve();
                item.active = false;
            }
        }

        while (actionVisuals.length > actions.length) {
            actionVisuals.pop().destroy();
        }

        reobserve();

    }

    function updateCharacters() {

        var levelData = this.levelData;

        if (levelData == null) {
            unobserve();
            for (item in characterVisuals) {
                item.destroy();
            }
            characterVisuals = [];
            return;
        }

        var charactersData = levelData.characters;

        unobserve();

        for (i in 0...charactersData.length) {
            var characterVisual = characterVisuals[i];
            var character = charactersData[i];
            if (characterVisual == null) {
                characterVisual = new Character(characterShapesLayer, levelData, character);
                characterVisuals[i] = characterVisual;
            }
            else {
                characterVisual.characterData = character;
            }

            reobserve();
            switch levelData.block(character.x, character.y) {
                case GOAL_A | GOAL_B | GOAL_C | GOAL_D | GOAL_E:
                    unobserve();
                    layers[1].add(characterVisual);
                default:
                    unobserve();
                    layers[0].add(characterVisual);
            }
        }

        while (characterVisuals.length > charactersData.length) {
            characterVisuals.pop().destroy();
        }

        reobserve();

    }

}