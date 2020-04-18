package ld46.model;

import ceramic.Timer;
import ld46.enums.Direction;
import ld46.enums.ConductKind;
import tracker.Model;
import ceramic.Color;

class CharacterData extends Model {

    @observe public var group:Int;

    @observe public var conduct:ConductKind;

    @observe public var x:Float;

    @observe public var y:Float;

    @observe public var direction:Direction;

    public function new(x:Float, y:Float, direction:Direction, group:Int, conduct:ConductKind) {

        super();

        this.x = x;
        this.y = y;
        this.direction = direction;
        this.group = group;
        this.conduct = conduct;

        /*
        var d = 0;
        Timer.interval(this, 1.0, () -> {
            this.direction = switch (Std.random(4)) {
                default: NORTH;
                case 1: WEST;
                case 2: SOUTH;
                case 3: EAST;
            }
            d = (d + 1) % 4;
        });
        */

    }

}