package ld46.levels;

import ld46.model.ActionData;
import ld46.model.CharacterData;
import ld46.model.LevelData;

class Levels {

    public static function level01() {

        return new LevelData([
            [1,1,1,1,1,1,1,1,3,1,1,1,1],
            [1,1,1,1,1,1,1,1,0,1,1,1,1],
            [0,0,0,0,0,0,0,0,0,1,1,1,1],
            [1,1,1,1,1,0,1,1,1,1,1,1,1],
            [1,1,1,1,1,0,0,0,0,0,0,0,2],
            [1,1,1,1,1,1,1,1,1,1,1,1,1]
        ], [
            new CharacterData(
                0, 2, EAST,
                0, MOVE_FORWARD
            )
        ], [
            new ActionData([
                TURN_RIGHT
            ])
        ]);

    }

}