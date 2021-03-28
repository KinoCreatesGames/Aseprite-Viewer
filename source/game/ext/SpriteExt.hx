package game.ext;

import flixel.util.FlxAxes;

class SpriteExt {
	public static inline function screenCenterHorz(sprite:FlxSprite) {
		sprite.screenCenter(FlxAxes.X);
	}

	public static inline function screenCenterVert(sprite:FlxSprite) {
		sprite.screenCenter(FlxAxes.Y);
	}
}