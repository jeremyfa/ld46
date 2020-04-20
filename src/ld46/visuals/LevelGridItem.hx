package ld46.visuals;

import ceramic.Color;
import tracker.Observable;
import tracker.Autorun.*;
import ld46.model.LevelData;
import ld46.enums.BlockKind;
import ceramic.Quad;

class LevelGridItem extends Quad implements Observable {

    @observe public var value:BlockKind;

    @observe public var levelData:LevelData;

    @observe public var blockX:Int;

    @observe public var blockY:Int;

    @observe public var hover:Bool = false;

    var stampPreview:ActionStamp = null;

    public function new(levelData:LevelData, blockX:Int, blockY:Int, value:BlockKind) {

        super();

        this.levelData = levelData;
        this.value = value;
        this.blockX = blockX;
        this.blockY = blockY;

        size(BLOCK_SIZE, BLOCK_SIZE);

        autorun(updateDisplay);

        onPointerOver(this, info -> {
            hover = true;
        });
        onPointerOut(this, info -> {
            hover = false;
        });
        
    }

    function updateDisplay() {

        var value = this.value;
        var levelData = this.levelData;
        var color = this.color;

        unobserve();

        switch value {
            case GROUND:
                reobserve();
                if (hover && levelData != null && levelData.status == RUNNING) {
                    var action = levelData.nextUsableAction();
                    unobserve();
                    if (action != null) {
                        var actionNumber = levelData.actions.indexOf(action) + 1;
                        if (stampPreview == null) {
                            stampPreview = new ActionStamp(actionNumber);
                            add(stampPreview);
                        }
                        stampPreview.number = actionNumber;
                        stampPreview.alpha = 0.4;
                        stampPreview.active = true;
                    }
                    else {
                        if (stampPreview != null)
                            stampPreview.active = false;
                    }
                }
                else {
                    unobserve();
                    if (stampPreview != null)
                        stampPreview.active = false;
                }
            default:
                if (stampPreview != null)
                    stampPreview.active = false;
        }

        switch value {
            case WALL:
                transparent = false;
                color = BLOCK_WALL_COLOR;
            case GROUND:
                transparent = false;
                color = BLOCK_GROUND_COLOR;
            case GOAL_A:
                transparent = false;
                color = CHARACTER_COLORS[0];
            case GOAL_B:
                transparent = false;
                color = CHARACTER_COLORS[1];
            case GOAL_C:
                transparent = false;
                color = CHARACTER_COLORS[2];
            case GOAL_D:
                transparent = false;
                color = CHARACTER_COLORS[3];
            case GOAL_E:
                transparent = false;
                color = CHARACTER_COLORS[4];
            case KILL:
                transparent = true;
        }

        switch value {
            case GOAL_A | GOAL_B | GOAL_C | GOAL_D | GOAL_E:
                reobserve();
                var character = levelData.characterOnBlock(blockX, blockY);
                unobserve();
                if (character != null) {
                    if (character.matchesGoal(value))
                        color = Color.interpolate(color, Color.WHITE, 0.5);
                    else
                        //color = GOAL_KILLED_COLOR;//Color.interpolate(color, Color.BLACK, 0.75);
                        color = Color.interpolate(color, Color.BLACK, 0.5);
                }
                else {
                    color = Color.interpolate(color, Color.BLACK, 0.5);
                }
            default:
        }

        this.color = color;

        reobserve();

    }

    override function computeContent() {

        size(BLOCK_SIZE, BLOCK_SIZE);

        contentDirty = false;

    }

}
