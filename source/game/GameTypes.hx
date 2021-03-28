package game;

typedef ActorData = {
	public var name:String;
	public var health:Int;
	public var atk:Int;
	public var def:Int;
	public var spd:Int;
	public var sprite:String;
}

typedef MonsterData = {
	> ActorData,
	public var points:Int;
	// public var patrol:Array<FlxPoint>;
}

typedef SceneText = {
	public var text:String;

	/**
	 * Delay in seconds
	 */
	public var delay:Int;
}

typedef GameState = {
	public var gameTime:Float;
}

typedef GameSaveState = {
	public var saveIndex:Int;
	public var days:Int;
	public var playerStats:ActorData;
	public var gameTime:Float;
	public var realTime:Float;
	public var playerAffectionLvl:Int;
	public var playerHappinessLvl:Int;
}

typedef GameSettingsSaveState = {
	public var skipMiniGames:Bool;

	/**
	 * Volume from 0 to 1 for 0 - 100%
	 */
	public var volume:Float;
}

enum abstract AnimTypes(String) from String to String {
	public var IDLE:String = 'idle';
	public var MOVE:String = 'move';
	public var DEATH:String = 'death';
}

enum Splash {
	Delay(imageName:String, seconds:Int);
	Click(imageName:String);
	ClickDelay(imageName:String, seconds:Int);
}

enum Stat {
	Atk(?value:Int);
	Def(?value:Int);
	Intl(?value:Int);
	Agi(?value:Int);
	Dex(?value:Int);
}

/**
 * Rating in Minigames
 * Good - Average Reward
 * Great - Better Reward
 * Amazing - Highest Score Reward
 */
enum Rating {
	Good;
	Great;
	Amazing;
}