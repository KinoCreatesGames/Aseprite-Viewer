package game;

import flixel.FlxBasic;

class SaveLoad extends FlxBasic {
	/**
	 * Current Game State Information for passing to save files
	 */
	public var gameData:GameState;

	public static inline var SAVE_SETTINGS = 'SoulSettings';
	public static inline var SAVE_DATA_PREFIX = 'SoulData';
	public static var Save(get, null):SaveLoad;

	public var TextSpeed(get, null):Float;
	public var TextMode(get, null):String;
	public var SkipMiniGames(get, null):Bool;

	public static function initializeSave() {
		var save = new SaveLoad();
		save.gameData = {
			gameTime: 0,
		};
		FlxG.plugins.list.push(save);
	};

	public static function get_Save():SaveLoad {
		return cast(FlxG.plugins.get(SaveLoad), SaveLoad);
	}

	public function get_TextSpeed():Float {
		var save = createSaveSettings();
		var modeText = save.data.modeText;
		return switch (modeText) {
			case 'Normal':
				0.05;
			case 'Fast':
				0.01;
			case 'Slow':
				0.20;
			case _:
				0.05;
		}
		save.close();
	}

	public function get_TextMode():String {
		var save = createSaveSettings();
		var modeText = save.data.modeText;
		save.close();
		return modeText;
	}

	public function get_SkipMiniGames() {
		var save = createSaveSettings();
		var skipMiniGames = save.data.skipMiniGames;
		save.close();
		return skipMiniGames;
	}

	public function createSaveSettings():FlxSave {
		var save = new FlxSave();
		save.bind(SAVE_SETTINGS);
		return save;
	}

	public function loadSettings() {
		// Saves The Options For The Game
		var save = createSaveSettings();
		// Set Volume
		if (save.data.volume != null) {
			FlxG.sound.volume = save.data.volume;
		}
		// Set Skip Mini Games
		if (save.data.skipMiniGames != null) {}
		// Set Text Speed Mode
		if (save.data.modeText == null) {
			save.data.modeText = 'Normal';
		}
		save.close();
	}

	public function createSaveData(saveId:Int):FlxSave {
		var save = new FlxSave();
		save.bind(SAVE_DATA_PREFIX + saveId);
		return save;
	}

	public function createLoadSaveData(saveId:Int):FlxSave {
		return createSaveData(saveId);
	}

	/**
	 * Returns the loaded save file.
	 * Accessing it via your fn
	 * and close the file after loading complete.
	 * @param saveId
	 * @return FlxSave
	 */
	public function loadSaveData(saveId:Int, loadFn:GameSaveState -> Void) {
		var save = createSaveData(saveId);
		var data:GameSaveState = save.data.saveData;
		loadFn(data);
		save.close();
	}
}