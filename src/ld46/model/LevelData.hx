package ld46.model;

import ld46.enums.Direction;
import ld46.enums.BlockKind;
import ld46.enums.LevelStatus;
import tracker.Model;

class LevelData extends Model {

    @observe public var status:LevelStatus = NONE;

    @observe public var grid:Array<Array<BlockKind>>;

    @observe public var characters:Array<CharacterData>;

    @observe public var actions:Array<ActionData>;

    @observe public var tip:String = null;

    public function new(grid:Array<Array<BlockKind>>, characters:Array<CharacterData>, actions:Array<ActionData>, ?tip:String) {

        super();

        this.grid = grid;
        this.characters = characters;
        this.actions = actions;
        this.tip = tip;

    }

    override function destroy() {

        super.destroy();

        if (characters != null) {
            for (character in characters) {
                character.destroy();
            }
            characters = null;
        }

        if (actions != null) {
            for (action in actions) {
                action.destroy();
            }
            actions = null;
        }
        
    }

    public function block(x:Float, y:Float):BlockKind {
        if (x < 0 || y < 0 || x >= grid[0].length || y >= grid.length)
            return KILL;
        var row = grid[Std.int(y)];
        if (row == null)
            return KILL;
        return row[Std.int(x)];
    }

    /**
     * Used to update level state
     * @param delta 
     */
    public function step():Void {

        if (status != RUNNING)
            return;

        for (i in 0...characters.length) {
            var character = characters[i];
            if (character.status == ALIVE) {
                applyCharacterCurrentBlock(character);
                if (character.status == ALIVE) {
                    moveCharacter(character);
                }
                character.forceDirection = false;
            }
        }

        checkEndOfGame();

    }

    function checkEndOfGame() {

        var anyNotRescued = false;
        for (i in 0...characters.length) {
            var character = characters[i];
            switch character.status {
                case ALIVE:
                    anyNotRescued = true;
                case KILLED:
                    status = LOST;
                    return;
                case RESCUED:
                    // Rescued
            }
        }

        if (!anyNotRescued) {
            status = WON;
        }

    }

    public function usedActionStamp(x:Float, y:Float):Null<ActionData> {

        var _x = Std.int(x);
        var _y = Std.int(y);

        for (i in 0...actions.length) {
            var action = actions[i];
            if (action.x == _x && action.y == _y) {
                return action;
            }
        }

        return null;

    }

    public function nextUsableAction():Null<ActionData> {

        for (i in 0...actions.length) {
            var action = actions[i];
            if (!action.used) {
                return action;
            }
        }

        return null;

    }

    public function characterOnBlock(x:Float, y:Float):Null<CharacterData> {

        for (i in 0...characters.length) {
            var character = characters[i];
            if (character.x == x && character.y == y) {
                return character;
            }
        }

        return null;

    }

    public function click(x:Int, y:Int):Void {

        if (status != RUNNING)
            return;

        var usedAction = usedActionStamp(x, y);

        if (usedAction != null) {
            usedAction.remove();
        }
        else {
            var nextAction = nextUsableAction();
            if (nextAction != null) {
                if (nextAction.acceptsBlock(block(x, y))) {
                    nextAction.x = x;
                    nextAction.y = y;
                }
            }
        }

    }

    function applyCharacterCurrentBlock(character:CharacterData) {

        var usedAction = usedActionStamp(character.x, character.y);
        
        character.didJump = false;
        var jumpDirection:Direction = NORTH;

        if (usedAction != null) {
            for (subAction in usedAction.subActions) {
                switch subAction {
                    case TURN_LEFT:
                        character.turnLeft();
                        character.forceDirection = true;
                    case TURN_RIGHT:
                        character.turnRight();
                        character.forceDirection = true;
                    case TURN_AROUND:
                        character.turnAround();
                        character.forceDirection = true;
                    case MOVE_FORWARD:
                        character.forceDirection = true;
                    case JUMP_FORWARD:
                        if (blockForwardForwardCharacter(character) != WALL) {
                            character.jumpForward();
                            character.forceDirection = true;
                            character.didJump = true;
                            jumpDirection = character.direction;
                        }
                    case JUMP_LEFT:
                        character.turnLeft();
                        if (blockForwardForwardCharacter(character) != WALL) {
                            character.jumpForward();
                            character.forceDirection = true;
                            character.didJump = true;
                            jumpDirection = character.direction;
                        }
                    case JUMP_RIGHT:
                        character.turnRight();
                        if (blockForwardForwardCharacter(character) != WALL) {
                            character.jumpForward();
                            character.forceDirection = true;
                            character.didJump = true;
                            jumpDirection = character.direction;
                        }
                }
            }
        }

        switch [character.group, block(character.x, character.y)] {

            case [_, GROUND | WALL]:
                // Nothing to do here

            case [0, GOAL_A] | [1, GOAL_B] | [2, GOAL_C] | [3, GOAL_D] | [4, GOAL_E]:
                log.debug('RESCUED');
                character.status = RESCUED;

            case [_, GOAL_A] | [_, GOAL_B] | [_, GOAL_C] | [_, GOAL_D] | [_, GOAL_E]:
                log.debug('KILLED (wrong goal)');
                character.status = KILLED;

            case [_, KILL]:
                log.debug('KILLED');
                character.status = KILLED;

        }

        if (character.didJump && character.status == ALIVE) {
            var actualDirection = character.direction;
            character.direction = jumpDirection;
            character.moveBackward();
            character.direction = actualDirection;
        }

    }

    function moveCharacter(character:CharacterData, attemptsLeft:Int = 4):Void {

        if (attemptsLeft-- == 0) {
            log.debug('STUCK');
            return;
        }

        var didTurn = false;
        if (!character.forceDirection) {
            if (character.conduct == PREFERS_LEFT) {
                switch blockOnTheLeftOfCharacter(character) {
                    case GROUND | KILL | GOAL_A | GOAL_B | GOAL_C | GOAL_D | GOAL_E:
                        character.turnLeft();
                        character.moveForward();
                        didTurn = true;
                    default:
                }
            }
            else if (character.conduct == PREFERS_RIGHT) {
                switch blockOnTheRightOfCharacter(character) {
                    case GROUND | KILL | GOAL_A | GOAL_B | GOAL_C | GOAL_D | GOAL_E:
                        character.turnRight();
                        character.moveForward();
                        didTurn = true;
                    default:
                }
            }
        }

        if (!didTurn) {
            switch blockForwardCharacter(character) {
                case GROUND | KILL | GOAL_A | GOAL_B | GOAL_C | GOAL_D | GOAL_E:
                    log.debug('MOVE FORWARD');
                    character.moveForward();
                case WALL:
                    log.debug('(facing wall)');
                    switch [
                        blockBehindCharacter(character) != WALL,
                        blockOnTheLeftOfCharacter(character) != WALL,
                        blockOnTheRightOfCharacter(character) != WALL
                    ] {
                        case [_, true, true]:
                            switch character.conduct {
                                case PREFERS_LEFT:
                                    character.turnLeft();
                                    moveCharacter(character, attemptsLeft);
                                case PREFERS_RIGHT | MOVES_FORWARD:
                                    character.turnRight();
                                    moveCharacter(character, attemptsLeft);
                            }
                        case [_, true, false]:
                            character.turnLeft();
                            moveCharacter(character, attemptsLeft);
                        case [_, false, true]:
                            character.turnRight();
                            moveCharacter(character, attemptsLeft);
                        case [true, false, false]:
                            character.turnAround();
                            moveCharacter(character, attemptsLeft);
                        default:
                            log.debug('STOP');
                    }
            }
        }

    }

    public function blockForwardCharacter(character:CharacterData):BlockKind {

        return block(character.xForward, character.yForward);

    }

    public function blockForwardForwardCharacter(character:CharacterData):BlockKind {

        return block(character.xForwardForward, character.yForwardForward);

    }

    public function blockBehindCharacter(character:CharacterData):BlockKind {

        return block(character.xBehind, character.yBehind);

    }

    public function blockOnTheLeftOfCharacter(character:CharacterData):BlockKind {

        return block(character.xOnTheLeft, character.yOnTheLeft);

    }

    public function blockOnTheRightOfCharacter(character:CharacterData):BlockKind {

        return block(character.xOnTheRight, character.yOnTheRight);

    }

}