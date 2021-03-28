package game.char;

// Note we'll be using tiles so don't go over the tile limit
class Actor extends FlxSprite {
	public var name:String;
	public var data:ActorData;
	public var atk:Int;
	public var def:Int;
	public var spd:Int;

	public function new(x:Float, y:Float, actorData:ActorData) {
		super(x, y);
		data = actorData;
		assignStats();
	}

	/**
	 * Assigns all the stats that come directly from Depot for each actor.
	 */
	public function assignStats() {
		name = data.name;
		health = data.health;
		atk = data.atk;
		def = data.def;
		spd = data.spd;
	}
}