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
                    item = new LevelGridItem(value);
                    gridVisuals[y * numCols + x] = item;
                }
                else {
                    item.value = value;
                }
                item.pos(
                    x * BLOCK_SIZE,
                    y * BLOCK_SIZE
                );
                switch value {
                    case GROUND:
                        layers[0].add(item);
                    case GOAL | KILL:
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
            if (characterVisual == null) {
                characterVisual = new Character(characterShapesLayer, charactersData[i]);
                layers[1].add(characterVisual);
            }
            else {
                characterVisual.characterData = charactersData[i];
            }
        }

        while (characterVisuals.length > charactersData.length) {
            characterVisuals.pop().destroy();
        }

    }

}