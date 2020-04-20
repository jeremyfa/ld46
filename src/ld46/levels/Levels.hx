package ld46.levels;

import ld46.model.ActionData;
import ld46.model.CharacterData;
import ld46.model.LevelData;

class Levels {

    public static final NUM_LEVELS = 8;

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
                0, MOVES_FORWARD
            )
        ], [
            new ActionData([
                TURN_RIGHT
            ])
        ],
        'TIP: CLICK ON THE GROUND TO MAKE IT TURN RIGHT');

    }

    public static function level02() {

        return new LevelData([
            [1,1,1,1,1,1,1,1,1,1,1,1,1],
            [1,1,1,1,1,0,0,0,0,0,A,1,1],
            [0,0,0,0,0,0,1,1,1,1,1,1,1],
            [1,1,1,1,1,0,1,1,1,1,1,1,1],
            [1,1,1,1,1,0,1,1,1,1,1,1,1],
            [1,1,1,1,1,0,1,1,1,1,1,1,1]
        ], [
            new CharacterData(
                0, 2, EAST,
                0, MOVES_FORWARD
            )
        ], [
            new ActionData([
                TURN_AROUND
            ])
        ]);

    }

    public static function level03() {

        return new LevelData([
            [1,1,1,1,1,1,1,1,1,1,1,1,1],
            [1,1,1,1,1,1,1,1,1,1,A,1,1],
            [0,0,0,0,0,0,1,1,1,1,0,1,1],
            [1,1,1,1,1,0,1,1,1,1,0,1,1],
            [1,1,1,1,1,0,0,0,0,0,0,0,0],
            [1,1,1,1,1,0,1,1,1,1,1,1,1]
        ], [
            new CharacterData(
                0, 2, EAST,
                0, MOVES_FORWARD
            )
        ], [
            new ActionData([
                TURN_LEFT
            ]),
            new ActionData([
                TURN_LEFT
            ])
        ]);

    }

    public static function level04() {

        return new LevelData([
            [1,1,1,1,1,1,0,1,1,1,1,1,1],
            [1,1,1,1,1,0,0,1,1,1,A,1,1],
            [1,1,1,1,1,0,1,1,1,0,0,1,1],
            [1,1,1,1,1,0,1,1,1,0,1,1,1],
            [1,1,1,1,1,0,0,0,3,0,1,1,1],
            [1,1,1,1,1,1,1,1,1,1,1,1,1]
        ], [
            new CharacterData(
                6, 0, SOUTH,
                0, MOVES_FORWARD
            )
        ], [
            new ActionData([
                JUMP_FORWARD
            ])
        ]);

    }

    public static function level05() {

        return new LevelData([
            [1,1,0,1,1,1,1],
            [1,1,0,1,1,1,1],
            [0,0,0,1,1,1,1],
            [1,1,0,1,1,1,1],
            [1,1,0,1,1,1,1],
            [1,1,0,1,1,1,1],
            [1,1,0,0,0,A,1],
            [1,1,1,1,1,1,1]
        ], [
            new CharacterData(
                2, 0, SOUTH,
                0, PREFERS_RIGHT
            )
        ], [
            new ActionData([
                MOVE_FORWARD
            ])
        ]);

    }

    public static function level06() {

        return new LevelData([
            [1,1,1,1,1,1,1,1,1,1,1,1,1],
            [1,1,1,1,1,1,1,1,1,1,A,1,1],
            [0,0,0,0,0,0,1,1,1,1,0,1,1],
            [1,1,1,1,1,0,1,1,1,1,0,1,1],
            [1,1,1,1,1,0,0,0,0,0,0,0,0],
            [1,1,1,1,1,0,1,1,1,1,1,1,1]
        ], [
            new CharacterData(
                0, 2, EAST,
                0, MOVES_FORWARD
            )
        ], [
            new ActionData([
                TURN_LEFT
            ])
        ],
        'TIP: STAMPS ARE REUSABLE');

    }

    public static function level07() {

        return new LevelData([
            [1,1,1,1,1,0,1,1],
            [1,1,1,1,1,0,1,1],
            [1,1,1,1,1,0,1,1],
            [1,1,1,0,1,0,1,1],
            [1,1,1,0,1,0,1,1],
            [1,1,1,0,1,0,1,1],
            [1,A,0,0,0,0,0,0],
            [1,1,1,1,1,0,1,1],
            [1,1,1,1,1,0,1,1],
            [1,1,1,1,1,B,1,1]
        ], [
            new CharacterData(
                3, 3, SOUTH,
                0, PREFERS_LEFT
            ),
            new CharacterData(
                5, 0, SOUTH,
                1, PREFERS_LEFT
            )
        ], [
            new ActionData([
                TURN_AROUND
            ]),
            new ActionData([
                JUMP_FORWARD
            ])
        ]);

    }

    public static function level08() {

        return new LevelData([
            [1,1,1,1,1,1,1,1,0,1,1,1,1],
            [1,1,1,1,1,1,1,1,0,0,0,0,1],
            [0,0,0,0,0,0,0,0,0,1,1,B,1],
            [1,1,1,1,1,0,1,1,1,1,1,1,1],
            [1,1,1,1,1,0,0,0,0,0,0,0,A],
            [1,1,1,1,1,0,1,1,1,1,1,1,1],
            [1,1,1,1,1,0,1,1,1,1,1,1,1]
        ], [
            new CharacterData(
                0, 2, EAST,
                0, MOVES_FORWARD
            ),
            new CharacterData(
                8, 0, SOUTH,
                1, MOVES_FORWARD
            )
        ], [
            new ActionData([
                TURN_RIGHT
            ]),
            new ActionData([
                TURN_AROUND
            ]),
            new ActionData([
                TURN_RIGHT
            ]),
            new ActionData([
                TURN_LEFT
            ])
        ]);

    }

}