package ld46;

import ceramic.Sound;
import ceramic.Entity;
import tracker.Observable;
import ld46.model.LevelData;
import ld46.model.GameData;
import ld46.ui.GameView;
import ceramic.Assets;

class Shared extends Entity implements Observable {

    static var sharedInstance:Shared = new Shared();
    private function new() super();

    public static var project:Project;

    public static var assets:Assets;

    public static var game:GameData;

    public static var view:GameView;

    public static var bgm:Sound;

}