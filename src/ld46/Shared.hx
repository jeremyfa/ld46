package ld46;

import ceramic.Entity;
import tracker.Observable;
import ld46.model.LevelData;
import ld46.model.SaveData;
import ceramic.Assets;

class Shared extends Entity implements Observable {

    static var sharedInstance:Shared = new Shared();
    private function new() super();

    public static var project:Project;

    public static var assets:Assets;

    public static var save:SaveData;

    @observe var _level:LevelData;
    public static var level(get, set):LevelData;
    static function get_level():LevelData return sharedInstance._level;
    static function set_level(level:LevelData):LevelData return sharedInstance._level = level;

}