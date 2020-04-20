package ld46.visuals;

import ceramic.Timer;
import ld46.model.LevelData;
import ceramic.Point;
import ceramic.Color;
import ceramic.Shape;
import tracker.Observable;
import tracker.Autorun.*;
import ld46.model.CharacterData;
import ceramic.Visual;
import ceramic.Quad;

class Character extends Quad implements Observable {

    static var _point = new Point(0, 0);

    @observe public var characterData:CharacterData;

    @observe public var levelData:LevelData;

    var shape:CharacterShape;

    var didUpdatePositionOnce:Bool = false;

    public function new(shapeParent:Visual, levelData:LevelData, characterData:CharacterData) {

        super();

        this.levelData = levelData;
        this.characterData = characterData;
        
        transparent = true;
        
        size(BLOCK_SIZE, BLOCK_SIZE);

        shape = new CharacterShape(this);
        shapeParent.add(shape);

        app.oncePostFlushImmediate(() -> {
            autorun(updateColor);
            autorun(updatePosition);
        });

    }

    function updateColor() {

        if (characterData.status == KILLED) {
            switch levelData.block(characterData.x, characterData.y) {
                case GOAL_A | GOAL_B | GOAL_C | GOAL_D | GOAL_E:
                    if (characterData.didJump) {
                        Timer.delay(this, JUMP_KILL_DELAY, () -> {
                            shape.color = CHARACTER_KILLED_COLOR;
                        });
                    }
                    else {
                        shape.color = CHARACTER_KILLED_COLOR;
                    }
                    //Color.interpolate(CHARACTER_COLORS[characterData.group], Color.BLACK, 0.85);
                default:
                    shape.color = Color.interpolate(CHARACTER_COLORS[characterData.group], Color.BLACK, 0.5);
            }
        }
        else {
            shape.color = CHARACTER_COLORS[characterData.group];
        }

    }

    function updatePosition() {

        var characterData = this.characterData;

        var x = characterData.x * BLOCK_SIZE;
        var y = characterData.y * BLOCK_SIZE;

        unobserve();
        shape.bounce();
        var isJump = Math.abs(x - this.x) > BLOCK_SIZE * 1.5 || Math.abs(y - this.y) > BLOCK_SIZE * 1.5;
        var tween = this.transition(isJump ? ELASTIC_EASE_IN_OUT : LINEAR, didUpdatePositionOnce ? STEP_INTERVAL : 0, props -> {
            props.pos(x, y);
        });
        if (tween != null) {
            tween.onUpdate(this, (_, _) -> {
                updateShapePosition();
            });
        }
        else {
            app.oncePostFlushImmediate(() -> {
                if (!destroyed) {
                    updateShapePosition();
                }
            });
        }
        reobserve();

        didUpdatePositionOnce = true;

    }

    function updateShapePosition() {

        visualToScreen(width * 0.5, height * 0.5, _point);
        shape.parent.screenToVisual(_point.x, _point.y, _point);
        shape.pos(_point.x, _point.y);
        shape.depth = 1000 - _point.x * 0.001 + _point.y + 20 * (levelData.characters.indexOf(characterData) / levelData.characters.length);

    }
    
    override function destroy() {

        super.destroy();

        shape.destroy();

    }

}