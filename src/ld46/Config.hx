package ld46;

import ceramic.Color;

class Config {

    public static final BLOCK_SIZE = 32;

    public static final STEP_INTERVAL = 0.5;

    public static final CROSS_COLOR = Color.RED;

    public static final ACTION_STAMP_COLOR = Color.BLACK;

    public static final CHARACTER_COLORS:Array<Color> = [
        Color.RED,
        Color.GREEN,
        Color.BLUE,
        Color.YELLOW,
        Color.PURPLE
    ];

    public static final BLOCK_WALL_COLOR = Color.BLACK;

    public static final BLOCK_GROUND_COLOR = Color.WHITE;

    public static final BLOCK_GOAL_COLOR = Color.GREEN;

    public static final BLOCK_KILL_COLOR = Color.RED;

}