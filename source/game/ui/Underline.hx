package game.ui;

class Underline extends FlxSprite {
	public function new(x:Float, y:Float, width:Float, height:Float,
			color:FlxColor) {
		super(x, y);
		makeGraphic(cast width, cast height, color);
	}

	/**
	 * Sets up a fade in/out with a duration in seconds
	 * @param duration
	 * @param loop
	 */
	public function setupFade(duration:Float, loop:Bool) {
		var fadeInFn = null;
		var fadeOutFn = null;
		fadeOutFn = (tween) -> {
			if (loop) {
				this.fadeOut(duration, fadeInFn);
			}
		}
		fadeInFn = (tween) -> {
			if (loop) {
				this.fadeIn(duration, fadeOutFn);
			}
		}
		return this.fadeOut(duration, fadeInFn);
	}
}