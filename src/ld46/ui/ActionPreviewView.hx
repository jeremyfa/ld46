package ld46.ui;

import ceramic.Text;
import ceramic.Quad;
import ceramic.View;

class ActionPreviewView extends View {

    var text:Text;

    var index:Int;

    public function new(index:Int) {

        super();

        this.index = index;

        transparent = true;
        //color = BLOCK_GROUND_COLOR;
        //alpha = 0.5;

        borderSize = 1.75;
        borderColor = ACTION_STAMP_COLOR;
        borderPosition = MIDDLE;

        text = new Text();
        text.pointSize = 25 * 23 / 32;
        text.color = ACTION_STAMP_COLOR;
        text.align = CENTER;
        text.anchor(0.5, 0.525);
        text.pos(width * 0.5, height * 0.5);
        text.content = '' + (index + 1);
        add(text);

        viewSize(28, 28);

    }

    override function layout() {
        
        text.pos(width * 0.5, height * 0.5);

    }

}