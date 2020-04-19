package ld46.model;

import ld46.levels.Levels;
import ceramic.Timer;
import tracker.Model;

using tracker.SaveModel;

class GameData extends Model {

    @serialize public var unlockedLevels:Int = 1;

    @serialize public var currentLevel:Int = 1;

    @observe public var levelData:LevelData = null;

    var clearInterval:Void->Void = null;

    var resetingLoop:Bool = false;

    public function new() {

        super();

        this.loadFromKey('game_data');
        this.autoSaveAsKey('game_data');

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

    }

    public function reloadLevel() {

        var prevLevelData = levelData;

        levelData = switch (currentLevel) {
            case 1: Levels.level01();
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
