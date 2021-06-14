package ld46.ui;

import assets.Shaders;
import ceramic.Timer;
import assets.Sounds;
import ld46.visuals.LevelGrid;
import ceramic.TextView;
import ceramic.Color;
import assets.Fonts;
import ceramic.Quad;
import tracker.Autorun.*;
import ceramic.View;

using StringTools;

class GameView extends View {

    var overlay:OverlayView = null;

    var levelGrid:LevelGrid = null;

    var title:TextView;

    var endGameText:TextView;

    var tipText:TextView;

    var clickToDoText:TextView;

    var characterList:CharacterListView;

    var actionList:ActionListView;

    var thanksForPlaying:TextView;

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
        title.textColor = TEXT_COLOR;
        title.pointSize = 40;
        title.font = assets.font(Fonts.SIMPLY_MONO);
        title.align = CENTER;
        title.verticalAlign = CENTER;
        title.anchor(0.5, 0.5);
        title.depth = 30;
        add(title);

        tipText = new TextView();
        tipText.textColor = TEXT_COLOR;
        tipText.pointSize = 14;
        tipText.font = assets.font(Fonts.SIMPLY_MONO);
        tipText.align = CENTER;
        tipText.verticalAlign = CENTER;
        tipText.anchor(0.5, 0.5);
        tipText.content = '';
        tipText.viewWidth = 100;
        tipText.depth = 30;
        add(tipText);

        endGameText = new TextView();
        endGameText.textColor = TEXT_COLOR;
        endGameText.pointSize = 40;
        endGameText.font = assets.font(Fonts.SIMPLY_MONO);
        endGameText.align = CENTER;
        endGameText.verticalAlign = CENTER;
        endGameText.anchor(0.5, 0.5);
        endGameText.content = '';
        endGameText.depth = 30;
        add(endGameText);

        clickToDoText = new TextView();
        clickToDoText.textColor = TEXT_COLOR;
        clickToDoText.pointSize = 20;
        clickToDoText.font = assets.font(Fonts.SIMPLY_MONO);
        clickToDoText.align = CENTER;
        clickToDoText.verticalAlign = CENTER;
        clickToDoText.anchor(0.5, 0.5);
        clickToDoText.content = '';
        clickToDoText.depth = 40;
        clickToDoText.onPointerDown(this, _ -> {
            trace('CLICK RETRY');
            if (game.levelData != null && game.levelData.status == RUNNING) {
                game.reloadLevel();
            }
        });
        add(clickToDoText);

        thanksForPlaying = new TextView();
        thanksForPlaying.transparent = false;
        thanksForPlaying.color = BACKGROUND_COLOR;
        thanksForPlaying.textColor = TEXT_COLOR;
        thanksForPlaying.pointSize = 20;
        thanksForPlaying.font = assets.font(Fonts.SIMPLY_MONO);
        thanksForPlaying.align = CENTER;
        thanksForPlaying.verticalAlign = CENTER;
        thanksForPlaying.anchor(0.5, 0.5);
        thanksForPlaying.content = '
THANKS FOR PLAYING

THIS SMALL GAME WAS CREATED IN 48H BY JEREMY FAIVRE FOR LDJAM46

I WISH I HAD TIME TO ADD MORE LEVELS...

TELL ME IF YOU LIKED IT!
I HAVE PLENTY OF IDEAS TO EXPAND THE CONCEPT!
        '.trim();
        thanksForPlaying.depth = 50;
        autorun(() -> {
            thanksForPlaying.active = game.thanksForPlaying;
        });
        add(thanksForPlaying);

        characterList = new CharacterListView();
        characterList.depth = 30;
        add(characterList);

        actionList = new ActionListView();
        actionList.depth = 30;
        add(actionList);

        autorun(updateOverlay);
        autorun(updateLevelGrid);
        autorun(updateTexts);

        screen.oncePointerDown(this, _ -> {
            screen.oncePointerUp(this, _ -> {
                app.backend.audio.resumeAudioContext(success -> {
                    bgm = assets.sound(Sounds.MAKEITALIVE);
                    if (bgm != null) {
                        bgm.play(0, true);
                    }
                });
            });
        });

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
            overlay.transparent = true;//(levelData != null && levelData.status != NONE);
        }
        else {
            overlay.active = false;
        }

    }

    function updateTexts() {

        var levelData = game.levelData;

        if (levelData != null) {

            var tip = levelData.tip;
            tipText.content = tip != null && levelData.status == LOST ? tip : 'LEVEL ${game.currentLevel}';

            switch levelData.status {
                case NONE:
                    tipText.active = true;
                case RUNNING:
                    tipText.active = false;
                case WON:
                    tipText.active = false;
                case LOST:
                    tipText.active = true;
            }

            switch levelData.status {
                case NONE | RUNNING:
                    if (levelData.characters.length > 1) {
                        title.content = 'KEEP THEM ALIVE';
                    }
                    else {
                        title.content = 'KEEP IT ALIVE';
                    }
                case WON:
                    title.content = 'GOOD JOB';
                case LOST:
                    title.content = 'OH, NO...';
            }
        }
        else {
            tipText.active = false;
            title.content = 'KEEP IT ALIVE';
        }

        if (levelData != null) {
            characterList.active = true;
        }
        else {
            characterList.active = false;
        }

        if (levelData == null || levelData.status == RUNNING) {
            endGameText.active = false;
            title.active = false;

            if (levelData != null) {
                clickToDoText.active = true;
                clickToDoText.content = 'RETRY';
            }
            else {
                clickToDoText.active = false;
            }
        }
        else {
            endGameText.active = true;
            clickToDoText.active = true;
            title.active = true;
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
                    endGameText.content = 'YOU LOST ONE FELLOW!';
                    clickToDoText.content = 'CLICK TO TRY AGAIN';
                default:
            }
        }

    }

    override function layout() {

        /*
        // Should not be needed but it is needed and I didn't have time to know why
        if (title.text.contentDirty)
            title.text.computeContent();
        if (tipText.text.contentDirty)
            tipText.text.computeContent();
        if (clickToDoText.text.contentDirty)
            clickToDoText.text.computeContent();
        if (endGameText.text.contentDirty)
            endGameText.text.computeContent();
        */

        levelGrid.pos(width * 0.5, height * 0.5);

        overlay.size(width, height);
        overlay.pos(width * 0.5, height * 0.5);

        title.autoComputeSize(true);
        title.pos(
            width * 0.5,
            70
        );

        tipText.pos(
            width * 0.5,
            120
        );

        endGameText.pos(
            width * 0.5,
            height - 100
        );

        clickToDoText.autoComputeSize(true);
        clickToDoText.pos(
            width * 0.5,
            height - 70
        );

        characterList.anchor(0, 0);
        characterList.pos(50, 55);
        characterList.autoComputeSize(true);

        actionList.anchor(1, 0);
        actionList.pos(width - 50, 55);
        actionList.autoComputeSize(true);

        thanksForPlaying.size(width, height);
        thanksForPlaying.pos(width * 0.5, height * 0.5);

    }

}