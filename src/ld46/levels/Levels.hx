package ld46.levels;

import ld46.model.ActionData;
import ld46.model.CharacterData;
import ld46.model.LevelData;

class Levels {

    static final A:Int = 10;
    static final B:Int = 11;
    static final C:Int = 12;
    static final D:Int = 13;
    static final E:Int = 14;

    public static function level01() {

        return new LevelData([
            [1,1,1,1,1,1,1,1,0,1,1,1,1],
            [1,1,1,1,1,1,1,1,0,1,1,1,1],
            [0,0,0,0,0,0,0,0,0,1,1,1,1],
            [1,1,1,1,1,0,1,1,1,1,1,1,1],
            [1,1,1,1,1,0,0,0,0,0,0,0,A],
            [1,1,1,1,1,1,1,1,1,1,1,1,1]
        ], [
            new CharacterData(
                0, 2, EAST,
                0, PREFERS_RIGHT
            )
        ], [
            new ActionData([
                TURN_RIGHT
            ])
        ]);

    }

}