package ld46.model;

import ld46.enums.CharacterStatus;
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

    public var xForward(get, never):Float;
    inline function get_xForward():Float return switch direction {
        case NORTH: x;
        case EAST: x + 1;
        case SOUTH: x;
        case WEST: x - 1;
    }

    public var xBehind(get, never):Float;
    inline function get_xBehind():Float return switch direction {
        case NORTH: x;
        case EAST: x - 1;
        case SOUTH: x;
        case WEST: x + 1;
    }

    public var xOnTheLeft(get, never):Float;
    inline function get_xOnTheLeft():Float return switch direction {
        case NORTH: x - 1;
        case EAST: x;
        case SOUTH: x + 1;
        case WEST: x;
    }

    public var xOnTheRight(get, never):Float;
    inline function get_xOnTheRight():Float return switch direction {
        case NORTH: x + 1;
        case EAST: x;
        case SOUTH: x - 1;
        case WEST: x;
    }

    public var yForward(get, never):Float;
    inline function get_yForward():Float return switch direction {
        case NORTH: y - 1;
        case EAST: y;
        case SOUTH: y + 1;
        case WEST: y;
    }

    public var yBehind(get, never):Float;
    inline function get_yBehind():Float return switch direction {
        case NORTH: y + 1;
        case EAST: y;
        case SOUTH: y - 1;
        case WEST: y;
    }

    public var yOnTheLeft(get, never):Float;
    inline function get_yOnTheLeft():Float return switch direction {
        case NORTH: y;
        case EAST: y - 1;
        case SOUTH: y;
        case WEST: y + 1;
    }

    public var yOnTheRight(get, never):Float;
    inline function get_yOnTheRight():Float return switch direction {
        case NORTH: y;
        case EAST: y + 1;
        case SOUTH: y;
        case WEST: y - 1;
    }

    @observe public var direction:Direction;

    @observe public var status:CharacterStatus = ALIVE;

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
            this.direction = switch (d) {
                default: NORTH;
                case 1: EAST;
                case 2: SOUTH;
                case 3: WEST;
            }
            d = (d + 1) % 4;
        });
        */

    }

    public function turnLeft():Void {

        direction = switch direction {
            case NORTH: WEST;
            case WEST: SOUTH;
            case SOUTH: EAST;
            case EAST: NORTH;
        }

    }

    public function turnRight():Void {

        direction = switch direction {
            case NORTH: EAST;
            case EAST: SOUTH;
            case SOUTH: WEST;
            case WEST: NORTH;
        }

    }

    public function turnAround():Void {

        direction = switch direction {
            case NORTH: SOUTH;
            case EAST: WEST;
            case SOUTH: NORTH;
            case WEST: EAST;
        }

    }

    public function moveForward():Void {

        switch direction {
            case NORTH:
                y--;
            case EAST:
                x++;
            case SOUTH:
                y++;
            case WEST:
                x--;
        }

    }

}