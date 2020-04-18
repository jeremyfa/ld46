package ld46.visuals;

import ld46.enums.BlockKind;
import ceramic.Quad;

class LevelGridItem extends Quad {

    public var value(default, set):BlockKind;
    function set_value(value:BlockKind):BlockKind {
        if (this.value == value) return value;
        this.value = value;
        contentDirty = true;
        return value;
    }

    public function new(value:BlockKind) {

        super();

        this.value = value;
        
    }

    override function computeContent() {

        size(BLOCK_SIZE, BLOCK_SIZE);

        switch value {
            case WALL:
                color = BLOCK_WALL_COLOR;
            case GROUND:
                color = BLOCK_GROUND_COLOR;
            case GOAL:
                color = BLOCK_GOAL_COLOR;
            case KILL:
                color = BLOCK_KILL_COLOR;
        }

        contentDirty = false;

    }

}
