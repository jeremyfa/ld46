package ld46.model;

import ld46.enums.BlockKind;
import ld46.enums.ActionKind;
import tracker.Model;

class ActionData extends Model {

    @observe public var subActions:Array<ActionKind>;

    @observe public var x:Int = -1;

    @observe public var y:Int = -1;

    public var used(get, never):Bool;
    inline function get_used():Bool return x >= 0 && y >= 0;

    public function new(subActions:Array<ActionKind>, x:Int = -1, y:Int = -1) {

        super();

        this.subActions = subActions;
        this.x = x;
        this.y = y;
        
    }

    public function acceptsBlock(block:BlockKind):Bool {

        return block == GROUND;

        // This will be improved later with more options

    }

    public function remove():Void {

        x = -1;
        y = -1;

    }

}