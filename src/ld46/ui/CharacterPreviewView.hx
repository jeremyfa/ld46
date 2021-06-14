package ld46.ui;

import ceramic.Quad;
import ceramic.View;

class CharacterPreviewView extends View {

    var shape:Quad;

    var index:Int;

    public function new(index:Int) {

        super();

        transparent = true;

        this.index = index;

        shape = new Quad();
        shape.anchor(0.5, 0.5);
        shape.color = CHARACTER_COLORS[index];
        add(shape);

        viewSize(16, 24);

    }

    override function layout() {
        
        shape.size(width, height);
        shape.pos(width * 0.5, height * 0.5);

    }

}