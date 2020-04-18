package ld46.visuals;

import ceramic.Color;
import ceramic.Quad;
import ceramic.Visual;

class Cross extends Visual {

    var bar1:Quad;

    var bar2:Quad;
    
    public var color(get, set):Color;
    function get_color():Color return bar1.color;
    function set_color(color:Color):Color {
        bar1.color = color;
        bar2.color = color;
        return color;
    }

    override function set_width(width:Float):Float {
        if (_width == width) return width;
        super.set_width(width);
        contentDirty = true;
        return width;
    }

    override function set_height(height:Float):Float {
        if (_height == height) return height;
        super.set_height(height);
        contentDirty = true;
        return height;
    }

    public function new() {

        super();

        bar1 = new Quad();
        bar1.anchor(0.5, 0.5);
        add(bar1);
        bar2 = new Quad();
        bar2.anchor(0.5, 0.5);
        add(bar2);

        size(BLOCK_SIZE, BLOCK_SIZE);

        color = CROSS_COLOR;

    }

    override function computeContent() {
        
        bar1.size(width, height * 0.25);
        bar2.size(width, height * 0.25);

        bar1.pos(width * 0.5, height * 0.5);
        bar2.pos(width * 0.5, height * 0.5);

        bar1.rotation = 45;
        bar2.rotation = -45;

        contentDirty = false;

    }

}