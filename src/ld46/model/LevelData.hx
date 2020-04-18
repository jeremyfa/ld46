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

}