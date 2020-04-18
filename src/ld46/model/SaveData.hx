package ld46.model;

import tracker.Model;

using tracker.SaveModel;

class SaveData extends Model {

    @serialize public var unlockedLevel:Int = 1;

    public function new() {

        super();

        this.loadFromKey('save_data');
        this.autoSaveAsKey('save_data');

    }

}
