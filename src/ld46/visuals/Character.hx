package ld46.visuals;

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

    var shape:CharacterShape;

    var didUpdatePositionOnce:Bool = false;

    public function new(shapeParent:Visual, characterData:CharacterData) {

        super();

        this.characterData = characterData;
        
        transparent = true;
        //color = Color.GREEN;
        
        size(BLOCK_SIZE, BLOCK_SIZE);

        shape = new CharacterShape(this);
        shapeParent.add(shape);

        app.oncePostFlushImmediate(() -> {
            autorun(updateColor);
            autorun(updatePosition);
        });

    }

    function updateColor() {

        shape.color = CHARACTER_COLORS[characterData.group];

    }

    function updatePosition() {

        var characterData = this.characterData;

        var x = characterData.x * BLOCK_SIZE;
        var y = characterData.y * BLOCK_SIZE;

        unobserve();
        shape.bounce();
        var tween = this.transition(LINEAR, didUpdatePositionOnce ? STEP_INTERVAL : 0, props -> {
            props.pos(x, y);
        });
        tween.onUpdate(this, (_, _) -> {
            updateShapePosition();
        });
        reobserve();

        didUpdatePositionOnce = true;

    }

    function updateShapePosition() {

        visualToScreen(width * 0.5, height * 0.5, _point);
        shape.parent.screenToVisual(_point.x, _point.y, _point);
        shape.pos(_point.x, _point.y);

    }
    
    override function destroy() {

        super.destroy();

        shape.destroy();

    }

}