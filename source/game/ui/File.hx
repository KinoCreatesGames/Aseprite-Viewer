package game.ui;

class File extends FlxTypedGroup<FlxSprite> {
	public var position:FlxPoint;
	public var background:FlxSprite;
	public var saveID:Int;
	public var gameTime:Float;
	public var realTime:Float;
	public var saveIDText:FlxText;
	public var gameTimeText:FlxText;
	public var realTimeText:FlxText;
	public var onClick:File -> Void;

	public static inline var WIDTH:Int = 400;
	public static inline var HEIGHT:Int = 75;
	public static inline var BGCOLOR:Int = KColor.RICH_BLACK_FORGRA;
	public static inline var BORDERSIZE:Int = 4;

	public static inline var MIN_TO_SEC:Int = 60;
	public static inline var MIN_TO_HRS:Int = 3600;

	public function new(id:Int, x:Float, y:Float, onClick:File -> Void) {
		super();
		saveID = id;
		position = new FlxPoint(x, y);
		this.onClick = onClick;
		create();
	}

	public function create() {
		createBackground(position);
		createText(position);
	}

	public function createBackground(position:FlxPoint) {
		background = new FlxSprite(position.x, position.y);
		background.makeGraphic(WIDTH, HEIGHT, BGCOLOR);

		background.drawRect(0, 0, WIDTH, HEIGHT, KColor.SNOW);
		background.drawRect(BORDERSIZE, BORDERSIZE, WIDTH - BORDERSIZE * 2,
			HEIGHT - BORDERSIZE * 2, BGCOLOR);
		add(background);
	}

	public function createText(position:FlxPoint) {
		// Create Text Options
		var x = position.x;
		var y = position.y;
		var padding = 12;
		// Save ID
		saveIDText = new FlxText(x + padding, y + padding, 50, '${saveID}',
			Globals.FONT_N);

		add(saveIDText);
		// Game Time
		gameTimeText = new FlxText(x + padding,
			(y + HEIGHT) - (padding + Globals.FONT_N + 24), WIDTH / 3,
			gameFormatTime(), Globals.FONT_N);

		add(gameTimeText);

		var realTimeWidth = (WIDTH / 3) + 75;
		// Real Time
		realTimeText = new FlxText((x + WIDTH) - realTimeWidth, y + padding,
			realTimeWidth, realFormatTime(), Globals.FONT_N);
		add(realTimeText);
	}

	public function gameFormatTime():String {
		var time = Math.floor(gameTime);
		var seconds = ((time % MIN_TO_HRS) % MIN_TO_SEC);
		var minutes = Math.floor((time % MIN_TO_HRS) / MIN_TO_SEC);
		var hours = Math.floor(time / MIN_TO_HRS);

		// Add Padding
		var hrs = '${hours}'.lpad("0", 2);
		var mins = '${minutes}'.lpad("0", 2);
		var secs = '${seconds}'.lpad("0", 2);
		return 'Play Time: ${hrs}:${mins}:${secs}';
	}

	public function realFormatTime():String {
		if (realTime > 0) {
			var date = Date.fromTime(realTime);
			return 'Time: ${DateTools.format(date, "%D %r")}';
		} else {
			return 'Time:';
		}
	}

	public function setId(id:Int) {
		saveID = id;
		updateSaveText();
	}

	public function updateSaveText() {
		gameTimeText.text = gameFormatTime();
		realTimeText.text = realFormatTime();
	}

	override public function update(elapsed) {
		super.update(elapsed);
		updateOnMouse(elapsed);
	}

	public function updateOnMouse(elapsed:Float) {
		// Use Background as hitbox to simplify work
		if (FlxG.mouse.overlaps(background) && FlxG.mouse.justPressed) {
			onClick(this);
		}
	}
}