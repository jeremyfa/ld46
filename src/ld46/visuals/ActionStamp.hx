package ld46.visuals;

import ceramic.Color;
import ld46.model.ActionData;
import ceramic.Border;
import ceramic.Text;
import ceramic.Quad;

class ActionStamp extends Quad {

    var text:Text;

    public var number(default, set):Int;
    function set_number(number:Int):Int {
        this.number = number;
        text.content = '' + number;
        return number;
    }

    public function new(number:Int) {

        super();

        color = BLOCK_GROUND_COLOR;
        transparent = false;

        size(BLOCK_SIZE, BLOCK_SIZE);

        text = new Text();
        text.pointSize = 25;
        text.color = ACTION_STAMP_COLOR;
        text.align = CENTER;
        text.anchor(0.5, 0.525);
        text.pos(width * 0.5, height * 0.5);
        text.inheritAlpha = true;
        add(text);

        var border = new Border();
        border.borderPosition = INSIDE;
        border.borderSize = 2;
        border.borderColor = ACTION_STAMP_COLOR;
        border.size(width, height);
        border.inheritAlpha = true;
        add(border);

        this.number = number;

    }

}