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
     * When a character touches this block, it's killed...
     */
    var KILL = 3;

    /**
     * Goal A (for 1st character)
     */
    var GOAL_A = 10;

    /**
     * Goal B (for 2nd character)
     */
    var GOAL_B = 11;

    /**
     * Goal C (for 3rd character)
     */
    var GOAL_C = 12;

    /**
     * Goal D (for 4th character)
     */
    var GOAL_D = 13;

    /**
     * Goal E (for 5th character)
     */
    var GOAL_E = 14;

}