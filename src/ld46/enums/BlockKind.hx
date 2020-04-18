package ld46.enums;

enum abstract BlockKind(Int) from Int to Int {

    /**
     * Normal ground, where characters can move
     */
    var GROUND = 0;

    /**
     * Wall. Blocking characters
     */
    var WALL = 1;

    /**
     * When a character touches this block, it's saved!
     */
    var GOAL = 2;

    /**
     * When a character touches this block, it's killed...
     */
    var KILL = 3;

}