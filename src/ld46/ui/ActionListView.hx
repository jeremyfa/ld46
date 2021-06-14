package ld46.ui;

import assets.Fonts;
import ceramic.Color;
import ceramic.TextView;
import ceramic.RowLayout;
import ceramic.ColumnLayout;

class ActionListView extends ColumnLayout {

    public function new() {

        super();

        transparent = true;

        itemSpacing = 10;

        var numActions = 5;
        for (i in 0...numActions) {
            addRow(i);
        }
        
    }

    function addRow(index:Int) {

        var row = new RowLayout();
        row.align = RIGHT;

        row.itemSpacing = 14;

        var actionInfo = new TextView();
        actionInfo.textColor = TEXT_COLOR;
        actionInfo.pointSize = 20;
        actionInfo.font = assets.font(Fonts.SIMPLY_MONO);
        actionInfo.align = RIGHT;
        actionInfo.verticalAlign = CENTER;
        actionInfo.anchor(0.5, 0.5);
        row.add(actionInfo);

        var actionPreview = new ActionPreviewView(index);
        row.add(actionPreview);

        row.autorun(function() {
            var levelData = game.levelData;
            if (levelData == null) {
                row.visible = false;
            }
            else {
                var action = levelData.actions[index];
                if (action != null) {
                    row.visible = true;
                    actionInfo.content = switch action.subActions[0] {
                        case TURN_LEFT: 'TURN LEFT';
                        case TURN_RIGHT: 'TURN RIGHT';
                        case TURN_AROUND: 'TURN AROUND';
                        case MOVE_FORWARD: 'MOVE FORWARD';
                        case JUMP_FORWARD: 'JUMP FORWARD';
                        case JUMP_LEFT: 'JUMP LEFT';
                        case JUMP_RIGHT: 'JUMP RIGHT';
                    };
                }
                else {
                    row.visible = false;
                }
            }
        });

        add(row);

    }

}