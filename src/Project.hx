package;

import ld46.levels.Levels;
import ld46.model.SaveData;
import ld46.visuals.LevelGrid;
import ceramic.Assets;
import ceramic.Entity;
import ceramic.Color;
import ceramic.InitSettings;
import ceramic.Shortcuts.*;

class Project extends Entity {

    function new(settings:InitSettings) {

        super();

        project = this;

        settings.antialiasing = 4;
        settings.background = Color.GRAY;
        settings.targetWidth = 1024;
        settings.targetHeight = 768;
        settings.scaling = FIT;

        app.onceReady(this, ready);

    }

    function ready() {

        assets = new Assets();
        assets.addAll();
        assets.onceComplete(this, assetsReady);
        assets.load();

    }

    function assetsReady(_) {

        start();

    }

    function start() {

        save = new SaveData();

        level = switch (save.unlockedLevel) {
            case 1: Levels.level01();
            default: null;
        }

        var levelGrid = new LevelGrid(level);
        levelGrid.anchor(0.5, 0.5);
        levelGrid.pos(screen.width * 0.5, screen.height * 0.5);

    }

}