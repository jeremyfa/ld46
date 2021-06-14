package ld46.ui;

import ceramic.View;

class OverlayView extends View {
    
    public function new() {

        super();

        color = BACKGROUND_COLOR;
        alpha = 0.5;

        autoChildrenDepth();

    }

    override function layout() {

    }

}