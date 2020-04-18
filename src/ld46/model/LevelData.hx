package ld46.model;

import ld46.enums.BlockKind;
import tracker.Model;

class LevelData extends Model {

    @observe public var grid:Array<Array<BlockKind>>;

    @observe public var characters:Array<CharacterData>;

    @observe public var actions:Array<ActionData>;

    public function new(grid:Array<Array<BlockKind>>, characters:Array<CharacterData>, actions:Array<ActionData>) {

        super();

        this.grid = grid;
        this.characters = characters;
        this.actions = actions;

    }

    public function block(x:Int, y:Int):BlockKind {
        if (x < 0 || y < 0 || x >= grid[0].length || y >= grid.length)
            return GROUND;
        var row = grid[y];
        if (row == null)
            return GROUND;
        return row[x];
    }

    /**
     * Used to update level state
     * @param delta 
     */
    public function step():Void {

        return;

        for (i in 0...characters.length) {
            var character = characters[i];

            if (blockForwardCharacter(character) == GROUND) {
                switch character.direction {
    
                    case NORTH:
                        character.y--;
    
                    case EAST:
                        character.x++;
    
                    case SOUTH:
                        character.y++;
    
                    case WEST:
                        character.x--;
                }
            }

        }

    }

    public function blockForwardCharacter(character:CharacterData):BlockKind {

        switch character.direction {
            case NORTH:
                return block(
                    Math.floor(character.x),
                    Math.floor(character.y) - 1
                );
            case EAST:
                return block(
                    Math.floor(character.x) + 1,
                    Math.floor(character.y)
                );
            case SOUTH:
                return block(
                    Math.floor(character.x),
                    Math.floor(character.y) + 1
                );
            case WEST:
                return block(
                    Math.floor(character.x) - 1,
                    Math.floor(character.y)
                );
        }

        return GROUND;

    }

}