package;

import assets.Shaders;
import ceramic.Quad;
import assets.Images;
import assets.Sounds;
import ld46.ui.GameView;
import ld46.model.GameData;
import assets.Fonts;
import ceramic.Timer;
import ld46.levels.Levels;
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
        settings.background = BACKGROUND_COLOR;
        settings.targetWidth = 1024;
        settings.targetHeight = 768;
        settings.scaling = FIT;
        settings.resizable = true;
        //settings.defaultFont = Fonts.BLACKJACK;// Fonts.ROBOTO_BOLD_20;
        settings.title = 'Keep it Alive - LDJAM46';

        app.onceReady(this, ready);

    }

    function ready() {

        assets = new Assets();
        assets.add(Fonts.SIMPLY_MONO);
        assets.add(Fonts.ROBOTO_BOLD_20);
        assets.add(Sounds.MAKEITALIVE);
        assets.onceComplete(this, assetsReady);
        assets.load();

    }

    function assetsReady(_) {

        start();

    }

    function start() {

        game = new GameData();
        view = new GameView();

        view.anchor(0.5, 0.5);
        view.size(screen.width, screen.height);
        view.pos(screen.width * 0.5, screen.height * 0.5);
        screen.onResize(view, () -> {
            view.size(screen.width, screen.height);
            view.pos(screen.width * 0.5, screen.height * 0.5);
        });

        /*
        var q = new Quad();
        q.depth = 999999;
        q.texture = assets.texture(Images.LANDSCAPE);
        */

    }

}
