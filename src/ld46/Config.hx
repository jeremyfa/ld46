package ld46;

import ceramic.Color;

class Config {

    public static final BLOCK_SIZE = 32;

    public static final STEP_INTERVAL = 0.5;

    public static final BACKGROUND_COLOR:Color = 0x829DA5;

    public static final CROSS_COLOR = Color.RED;

    public static final ACTION_STAMP_COLOR = Color.BLACK;

    public static final CHARACTER_COLORS:Array<Color> = [
        Color.RED,
        Color.GREEN,
        Color.BLUE,
        Color.YELLOW,
        Color.PURPLE
    ];

    public static final BLOCK_WALL_COLOR:Color = Color.BLACK;//0x666666;//0x4D4A6F;//Color.BLACK;

    public static final BLOCK_GROUND_COLOR:Color = 0xF6F4D3;//4D4A6F;//Color.WHITE;

}