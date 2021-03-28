package game.ui;

enum ButtonState {
	IDLE;
	HOVER;
	CLICKED;
}

class TextButton extends FlxText {
	public var onClick:Void -> Void;
	public var clickColor:Int;
	public var hoverColor:Int;
	public var idleColor:Int;
	public var state:ButtonState;
	public var canClick:Bool;

	public function new(x:Int, y:Int, text:String, size:Int,
			onClick:Void -> Void) {
		super(x, y, -1, text, size);
		state = IDLE;
		clickColor = KColor.WHITE;
		hoverColor = KColor.WHITE;
		idleColor = KColor.WHITE;
		this.onClick = onClick;
		canClick = true;
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);
		if (canClick && visible) {
			updateButtonMouseOver();
		}
	}

	public function updateButtonMouseOver() {
		if (FlxG.mouse.overlaps(this) && state != HOVER) {
			state = HOVER;
			updateTextColor(hoverColor);
		} else if (FlxG.mouse.overlaps(this) && FlxG.mouse.justPressed
			&& state != CLICKED) {
			state = CLICKED;
			updateTextColor(clickColor);
			onClick();
		} else if (!FlxG.mouse.overlaps(this)) {
			state = IDLE;
			updateTextColor(idleColor);
		}
	}

	public function updateTextColor(color:Int) {
		if (color != this.color) {
			this.color = color;
		}
	}
}