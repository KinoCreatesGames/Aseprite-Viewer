package game.ui;

import flixel.addons.text.FlxTypeText;

class MsgWindow extends FlxTypedGroup<FlxSprite> {
	public var position:FlxPoint;
	public var background:FlxSprite;
	public var nextArrow:FlxSprite;
	public var text:FlxTypeText;
	public var borderSize:Float;

	public static inline var WIDTH:Int = 400;
	public static inline var HEIGHT:Int = 200;
	public static inline var BGCOLOR:Int = KColor.RICH_BLACK;
	public static inline var FONTSIZE:Int = 12;

	public function new(x:Float, y:Float) {
		super();
		position = new FlxPoint(x, y);
		borderSize = 4;
		create();
	}

	public function create() {
		createBackground(position);
		createDownArrow(position);
		createText(position);
	}

	public function createBackground(positioin:FlxPoint) {
		background = new FlxSprite(position.x, position.y);
		// Have to use make graphic first in order to actually draw Rects
		background.makeGraphic(WIDTH, HEIGHT, BGCOLOR);

		background.drawRect(0, 0, WIDTH, HEIGHT, KColor.WHITE);
		background.drawRect(borderSize, borderSize, WIDTH - borderSize * 2,
			HEIGHT - borderSize * 2, BGCOLOR);
		add(background);
	}

	public function createDownArrow(position:FlxPoint) {
		var margin = 32 + borderSize;
		var y = (position.y + HEIGHT) - margin;
		var x = (position.x + WIDTH) - margin;

		nextArrow = new FlxSprite(x, y);
		nextArrow.loadGraphic(AssetPaths.dialog_arrow__png, true, 32, 32);
		nextArrow.animation.add('spin', [0, 1, 2, 3, 4, 5, 6], 6, true);
		nextArrow.visible = false;
		add(nextArrow);
	}

	public function createText(position:FlxPoint) {
		var x = position.x + 12 + borderSize;
		var y = position.y + 12 + borderSize;
		text = new FlxTypeText(x, y, cast WIDTH - (12 + borderSize),
			'Test Text', FONTSIZE);
		text.wordWrap = true;

		add(text);
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);
	}

	public function sendMessage(text:String, ?speakerName:String) {
		if (speakerName != null) {
			this.text.resetText('${speakerName}: ${text}');
		} else {
			this.text.resetText('${text}');
		}
		// Next arrow becomes invisible.
		nextArrow.visible = false;
		nextArrow.animation.stop();
		this.text.start(0.05, false, false, null, () -> {
			trace('Play Arrow');
			nextArrow.visible = true;
			nextArrow.animation.play('spin');
		});
	}

	public function show() {
		visible = true;
	}

	public function hide() {
		visible = false;
	}
}