package ld46.visuals;

import ceramic.Tween;
import ld46.enums.Direction;
import ceramic.Quad;
import ceramic.Color;
import ceramic.Shape;
import ceramic.Visual;
import ceramic.Timer;

using ceramic.VisualTransition;

class CharacterShape extends Visual {

    public var color(default, set):Color = Color.WHITE;
    function set_color(color:Color):Color {
        this.color = color;
        subShapes[0].color = Color.interpolate(color, Color.BLACK, 0.5);
        subShapes[1].color = color;
        return color;
    }

    var subShapes:Array<Shape> = [];

    // Used in calculus in case we change BLOCK_SIZE later
    var factor = BLOCK_SIZE / 32;

    var owner:Character;

    var orientation:Float = 180;

    var turning:Bool = false;

    public function new(owner:Character) {

        super();

        this.owner = owner;

        size(BLOCK_SIZE, BLOCK_SIZE);
        anchor(0.5, 1);

        var shape = new Shape();
        shape.vertices = [
            0.2 * BLOCK_SIZE, 0,
            0.8 * BLOCK_SIZE, 0,
            0.8 * BLOCK_SIZE, BLOCK_SIZE,
            0.2 * BLOCK_SIZE, BLOCK_SIZE
        ];
        shape.size(BLOCK_SIZE, BLOCK_SIZE);
        shape.anchor(0.5, 1);
        shape.pos(width * 0.5, height);
        shape.skewY = -20;
        add(shape);

        subShapes.push(shape);

        var shape = new Shape();
        shape.vertices = [
            0.2 * BLOCK_SIZE, 0,
            0.8 * BLOCK_SIZE, 0,
            0.8 * BLOCK_SIZE, BLOCK_SIZE,
            0.2 * BLOCK_SIZE, BLOCK_SIZE
        ];
        shape.size(BLOCK_SIZE, BLOCK_SIZE);
        shape.anchor(0.5, 1);
        shape.pos(width * 0.5 + 1, height + 1);
        shape.skewY = -20;
        add(shape);

        subShapes.push(shape);

        applyOrientation(switch owner.characterData.direction {
            case NORTH: 270;
            case EAST: 180;
            case SOUTH: 270;
            case WEST: 180;
        });
        owner.characterData.onDirectionChange(this, (newDirection, prevDirection) -> {
            turn(prevDirection, newDirection);
        });

        /*
        function dir() {
            turn(SOUTH, WEST);
        }
        Timer.interval(this, 1.0, dir);
        dir();
        */

    }

    public function turn(fromDirection:Direction, toDirection:Direction):Void {

        //trace('TURN from $fromDirection to $toDirection');

        if (turning) {
            app.onceUpdate(this, _ -> {
                turn(fromDirection, toDirection);
            });
            return;
        }
        turning = true;

        var duration = 0.5;

        switch [fromDirection, toDirection] {

            case [NORTH, EAST]:
                applyOrientation(90);
                app.oncePostFlushImmediate(() -> {
                    applyOrientation(180, duration);
                    app.onceUpdate(this, _ -> turning = false);
                });
            case [NORTH, SOUTH]:
                applyOrientation(90);
                app.oncePostFlushImmediate(() -> {
                    applyOrientation(270, duration);
                    app.onceUpdate(this, _ -> turning = false);
                });
            case [NORTH, WEST]:
                applyOrientation(90);
                app.oncePostFlushImmediate(() -> {
                    applyOrientation(0, duration).onceComplete(this, () -> {
                        applyOrientation(180);
                        app.onceUpdate(this, _ -> turning = false);
                    });
                });
            case [NORTH, NORTH]:
                applyOrientation(90);
                app.onceUpdate(this, _ -> turning = false);

            case [EAST, SOUTH]:
                applyOrientation(180);
                app.oncePostFlushImmediate(() -> {
                    applyOrientation(270, duration);
                    app.onceUpdate(this, _ -> turning = false);
                });
            case [EAST, WEST]:
                applyOrientation(180);
                app.oncePostFlushImmediate(() -> {
                    applyOrientation(0, duration).onceComplete(this, () -> {
                        applyOrientation(180);
                        app.onceUpdate(this, _ -> turning = false);
                    });
                });
            case [EAST, NORTH]:
                applyOrientation(180);
                app.oncePostFlushImmediate(() -> {
                    applyOrientation(90, duration).onceComplete(this, () -> {
                        applyOrientation(270);
                        app.onceUpdate(this, _ -> turning = false);
                    });
                });
            case [EAST, EAST]:
                applyOrientation(180);
                app.onceUpdate(this, _ -> turning = false);

            case [SOUTH, WEST]:
                applyOrientation(90);
                app.oncePostFlushImmediate(() -> {
                    applyOrientation(180, duration);
                    app.onceUpdate(this, _ -> turning = false);
                });
            case [SOUTH, NORTH]:
                applyOrientation(90);
                app.oncePostFlushImmediate(() -> {
                    applyOrientation(270, duration);
                    app.onceUpdate(this, _ -> turning = false);
                });
            case [SOUTH, EAST]:
                applyOrientation(90);
                app.oncePostFlushImmediate(() -> {
                    applyOrientation(0, duration).onceComplete(this, () -> {
                        applyOrientation(180);
                        app.onceUpdate(this, _ -> turning = false);
                    });
                });
            case [SOUTH, SOUTH]:
                applyOrientation(270);

            case [WEST, NORTH]:
                applyOrientation(0);
                app.oncePostFlushImmediate(() -> {
                    applyOrientation(90, duration).onceComplete(this, () -> {
                        applyOrientation(270);
                        app.onceUpdate(this, _ -> turning = false);
                    });
                });
            case [WEST, EAST]:
                applyOrientation(0);
                app.oncePostFlushImmediate(() -> {
                    applyOrientation(180, duration);
                    app.onceUpdate(this, _ -> turning = false);
                });
            case [WEST, SOUTH]:
                applyOrientation(180);
                app.oncePostFlushImmediate(() -> {
                    applyOrientation(90, duration).onceComplete(this, () -> {
                        applyOrientation(270);
                        app.onceUpdate(this, _ -> turning = false);
                    });
                });
            case [WEST, WEST]:
                applyOrientation(180);
                app.onceUpdate(this, _ -> turning = false);
        }

    }

    public function applyOrientation(orientation:Int, duration:Float = 0):Null<Tween> {

        // 0/2: west/east
        // 1/3: north/south
        
        this.orientation = orientation;

        switch orientation {
            case 0:
                subShapes[0].transition(duration, _westEast0Props0);
                return subShapes[1].transition(duration, _westEast0Props1);
            case 90:
                subShapes[0].transition(duration, _northSouth1Props0);
                return subShapes[1].transition(duration, _northSouth1Props1);
            case 180:
                subShapes[0].transition(duration, _westEast2Props0);
                return subShapes[1].transition(duration, _westEast2Props1);
            case 270:
                subShapes[0].transition(duration, _northSouth3Props0);
                return subShapes[1].transition(duration, _northSouth3Props1);
            default:
                return null;
        }

    }

    function _northSouth1Props0(props:VisualTransitionProperties):Void {
        props.pos(width * 0.5 + 1.5 * factor + 4.25 * factor, height + 3.7 * factor);
        props.scaleX = 0.85;
        props.skewY = -143;
    }

    function _northSouth1Props1(props:VisualTransitionProperties):Void {
        props.pos(width * 0.5 + 4.25 * factor, height + 3.7 * factor);
        props.scaleX = 0.85;
        props.skewY = -143;
    }

    function _westEast2Props0(props:VisualTransitionProperties):Void {
        props.pos(width * 0.5, height + 1.2 * factor);
        props.scaleX = 1;
        props.skewY = -20;
    }

    function _westEast2Props1(props:VisualTransitionProperties):Void {
        props.pos(width * 0.5 + 1 * factor, height + 1 * factor + 1.2 * factor);
        props.scaleX = 1;
        props.skewY = -20;
    }

    function _northSouth3Props0(props:VisualTransitionProperties):Void {
        props.pos(width * 0.5 + 1.5 * factor, height);
        props.scaleX = 0.85;
        props.skewY = 37;
    }

    function _northSouth3Props1(props:VisualTransitionProperties):Void {
        props.pos(width * 0.5, height);
        props.scaleX = 0.85;
        props.skewY = 37;
    }

    function _westEast0Props0(props:VisualTransitionProperties):Void {
        props.pos(width * 0.5 - 1 * factor + 7 * factor, height - 1 * factor);
        props.skewY = -200;
        props.scaleX = 1;
    }

    function _westEast0Props1(props:VisualTransitionProperties):Void {
        props.pos(width * 0.5 + 7 * factor, height);
        props.skewY = -200;
        props.scaleX = 1;
    }

}