package ld46.ui;

import ceramic.Fonts;
import ceramic.Color;
import ceramic.ui.TextView;
import ceramic.ui.RowLayout;
import ceramic.ui.ColumnLayout;

class CharacterListView extends ColumnLayout {

    public function new() {

        super();

        transparent = true;

        itemSpacing = 10;

        var numCharacters = CHARACTER_COLORS.length;
        for (i in 0...numCharacters) {
            addRow(i);
        }
        
    }

    function addRow(index:Int) {

        var row = new RowLayout();

        row.itemSpacing = 14;

        var characterPreview = new CharacterPreviewView(index);
        row.add(characterPreview);

        var characterInfo = new TextView();
        characterInfo.textColor = TEXT_COLOR;
        characterInfo.pointSize = 20;
        characterInfo.font = assets.font(Fonts.SIMPLY_MONO_20);
        characterInfo.align = LEFT;
        characterInfo.verticalAlign = CENTER;
        characterInfo.anchor(0.5, 0.5);
        row.add(characterInfo);

        row.autorun(function() {
            var levelData = game.levelData;
            if (levelData == null) {
                row.visible = false;
            }
            else {
                var character = levelData.characters[index];
                if (character != null) {
                    row.visible = true;
                    characterInfo.content = switch character.conduct {
                        case PREFERS_LEFT: 'PREFERS LEFT';
                        case PREFERS_RIGHT: 'PREFERS RIGHT';
                        case MOVES_FORWARD: 'MOVES FORWARD';
                    }
                }
                else {
                    row.visible = false;
                }
            }
        });

        add(row);

    }

}