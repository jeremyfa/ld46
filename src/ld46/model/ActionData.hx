package ld46.model;

import ld46.enums.ActionKind;
import tracker.Model;

class ActionData extends Model {

    @observe public var subActions:Array<ActionKind>;

    public function new(subActions:Array<ActionKind>) {

        super();

        this.subActions = subActions;
        
    }

}