package ld46.ui;

import ld46.visuals.LevelGrid;
import ceramic.ui.TextView;
import ceramic.Color;
import ceramic.Fonts;
import ceramic.Quad;
import tracker.Autorun.*;
import ceramic.ui.View;

class GameView extends View {

    var overlay:OverlayView = null;

    var levelGrid:LevelGrid = null;

    var title:TextView;

    var endGameText:TextView;

    var clickToDoText:TextView;

    public function new() {

        super();

        transparent = true;

        overlay = new OverlayView();
        overlay.anchor(0.5, 0.5);
        overlay.depth = 20;
        add(overlay);

        overlay.onPointerDown(this, _ -> {

            if (game.levelData != null) {
                switch game.levelData.status {
                    case NONE:
                        game.levelData.status = RUNNING;
                        game.resetLoop();
                    case RUNNING:
                    case WON:
                        game.unlockNextLevel();
                        game.reloadLevel();
                    case LOST:
                        game.reloadLevel();
                        game.levelData.status = RUNNING;
                        game.resetLoop();
                }
            }

        });

        title = new TextView();
        title.color = Color.WHITE;
        title.pointSize = 40;
        title.font = assets.font(Fonts.SIMPLY_MONO_60);
        title.align = CENTER;
        title.verticalAlign = CENTER;
        title.anchor(0.5, 0.5);
        title.depth = 30;
        add(title);

        endGameText = new TextView();
        endGameText.color = Color.WHITE;
        endGameText.pointSize = 40;
        endGameText.font = assets.font(Fonts.SIMPLY_MONO_60);
        endGameText.align = CENTER;
        endGameText.verticalAlign = CENTER;
        endGameText.anchor(0.5, 0.5);
        endGameText.content = '';
        endGameText.depth = 30;
        add(endGameText);

        clickToDoText = new TextView();
        clickToDoText.color = Color.WHITE;
        clickToDoText.pointSize = 20;
        clickToDoText.font = assets.font(Fonts.SIMPLY_MONO_20);
        clickToDoText.align = CENTER;
        clickToDoText.verticalAlign = CENTER;
        clickToDoText.anchor(0.5, 0.5);
        clickToDoText.content = '';
        clickToDoText.depth = 30;
        add(clickToDoText);

        autorun(updateOverlay);
        autorun(updateLevelGrid);
        autorun(updateTexts);

    }

    function updateLevelGrid() {

        var levelData = game.levelData;

        unobserve();

        if (levelGrid != null) {
            levelGrid.destroy();
        }

        if (levelData != null) {
            levelGrid = new LevelGrid(levelData);
            levelGrid.depth = 10;
            levelGrid.anchor(0.5, 0.5);
            levelGrid.pos(screen.width * 0.5, screen.height * 0.5);
            add(levelGrid);
        }

        reobserve();

    }

    function updateOverlay() {

        var levelData = game.levelData;

        if (levelData == null || levelData.status != RUNNING) {
            overlay.active = true;
            overlay.transparent = (levelData != null && levelData.status != LOST && levelData.status != NONE);
        }
        else {
            overlay.active = false;
        }

    }

    function updateTexts() {

        var levelData = game.levelData;

        if (levelData != null && levelData.characters.length > 1) {
            title.content = 'KEEP THEM ALIVE';
        }
        else {
            title.content = 'KEEP IT ALIVE';
        }

        if (levelData == null || levelData.status == RUNNING) {
            endGameText.active = false;
            clickToDoText.active = false;
        }
        else {
            endGameText.active = true;
            clickToDoText.active = true;
            switch levelData.status {
                case NONE:
                    endGameText.content = '';
                    clickToDoText.content = 'CLICK ANYWHERE TO START';
                case WON:
                    if (levelData.characters.length > 1) {
                        endGameText.content = 'YOU SAVED THEM!';
                    }
                    else {
                        endGameText.content = 'YOU SAVED IT!';
                    }
                    clickToDoText.content = 'CLICK TO PLAY NEXT LEVEL';
                case LOST:
                    endGameText.content = 'YOU LOST ONE FELLOW...';
                    clickToDoText.content = 'CLICK TO TRY AGAIN';
                default:
            }
        }

    }

    override function layout() {

        levelGrid.pos(width * 0.5, height * 0.5);

        overlay.size(width, height);
        overlay.pos(width * 0.5, height * 0.5);

        title.pos(
            width * 0.5,
            70
        );

        endGameText.pos(
            width * 0.5,
            height - 100
        );

        clickToDoText.pos(
            width * 0.5,
            height - 70
        );

    }

}