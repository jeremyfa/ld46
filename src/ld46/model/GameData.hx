package ld46.model;

import ld46.levels.Levels;
import ceramic.Timer;
import tracker.Model;

using tracker.SaveModel;

class GameData extends Model {

    @serialize public var unlockedLevels:Int = 1;

    @serialize public var currentLevel:Int = 1;

    @observe public var levelData:LevelData = null;

    @observe public var thanksForPlaying:Bool = false;

    var clearInterval:Void->Void = null;

    var resetingLoop:Bool = false;

    public function new() {

        super();

        // Uncomment to enable saving state
        //this.loadFromKey('game_data');
        //this.autoSaveAsKey('game_data');

        reloadLevel();

        resetLoop();

    }

    public function resetLoop() {

        if (resetingLoop)
            return;
        
        resetingLoop = true;

        if (clearInterval != null) {
            clearInterval();
            clearInterval = null;
        }

        app.onceUpdate(this, _ -> {
            tick();
            clearInterval = Timer.interval(this, STEP_INTERVAL, tick);

            resetingLoop = false;
        });

    }

    function tick() {

        if (levelData != null && levelData.status == RUNNING) {
            levelData.step();
        }

    }

    public function unlockNextLevel() {

        if (currentLevel < Levels.NUM_LEVELS) {
            currentLevel++;
            if (unlockedLevels < currentLevel) {
                unlockedLevels = currentLevel;
            }
        }
        else {
            thanksForPlaying = true;
        }

    }

    public function reloadLevel() {

        var prevLevelData = levelData;

        levelData = switch (currentLevel) {
            case 1: Levels.level01();
            case 2: Levels.level02();
            case 3: Levels.level03();
            case 4: Levels.level04();
            case 5: Levels.level05();
            case 6: Levels.level06();
            case 7: Levels.level07();
            case 8: Levels.level08();
            default: null;
        }

        if (prevLevelData != null) {
            // We wait a bit because it may still be needed for transition display
            Timer.delay(this, 5.0, () -> {
                prevLevelData.destroy();
                prevLevelData = null;
            });
        }

    }

    override function destroy() {

        super.destroy();

        if (levelData != null) {
            levelData.destroy();
            levelData = null;
        }

    }

}
