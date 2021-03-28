package game.asesprite;

enum abstract ColorDepth(Int) from Int to Int {
	/**
	 * Color Depth is set to RGBA
	 */
	var RGBA:Int = 32;

	/**
	 * Color Depth is set to Grayscale
	 */
	var GRAYSCALE:Int = 16;

	/**
	 * Color Depth is set to Indexed
	 */
	var INDEXED:Int = 8;
}