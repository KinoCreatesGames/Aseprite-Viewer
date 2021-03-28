package game.ext;

@:forward
@:forwardStatics
abstract KColor(FlxColor) from FlxColor to FlxColor {
	public static inline var WINTER_SKY = 0xFF206EFF;
	public static inline var RICH_BLACK = 0xFF0C0F0A;
	public static inline var EMERALD = 0xFF23CE6B;
	public static inline var BEAU_BLUE = 0xFFBAD7F2;
	public static inline var BURGUNDY = 0xFF7B0828;
	// public static inline var SNOW = 0xFBF5F3FF;
	public static inline var SNOW = 0xFFFBF5F3;
	public static inline var RICH_BLUE = 0x0F0E0EFF;
	public static inline var RICH_BLACK_FORGRA = 0xFF0F0E0E; // First 2 Letters are ARGB
	public static inline var RICH_BLACK_FORGRA_LOW = 0xF00F0E0E;
	public static inline var DARK_BYZANTIUM = 0xFF522B47;
	public static inline var MORNING_BLUE = 0xFF8DAA9D;
	public static inline var PRETTY_PINK = 0xFFFF6B97;
	public static inline var LIGHT_ORANGE = 0xFFFF9166;
}