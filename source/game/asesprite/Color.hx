package game.asesprite;

import haxe.io.Bytes;

/**
 * Color Manipulation Functions for Asesprite
 */
class Color {
	/**
	 * Converts 0xRRGGBBAA to 0xAARRGGBB
	 */
	public static function rgbaToargb(rgba:Bytes):UInt {
		var argb:Bytes = Bytes.alloc(4);
		// Not sure why Asesprite's color profile
		// has bytes in a strange order
		argb.set(0, rgba.get(2)); // AA
		argb.set(1, rgba.get(1)); // RR
		argb.set(2, rgba.get(0)); // GG
		argb.set(3, rgba.get(3)); // BB

		// Gets the unsigned integer bytes from the beginning
		return argb.getInt32(0);
	}

	/**
	 * Converts grayscale to rgba.
	 * 0xWWAA to AARRGGBB.
	 * @param bytePair 
	 * @return UInt
	 */
	public static function grayscaleTorgba(bytePair:Bytes):UInt {
		var rgba:Bytes = Bytes.alloc(4);
		var white = bytePair.get(0);
		var alpha = bytePair.get(1);
		rgba.set(0, white);
		rgba.set(1, white);
		rgba.set(2, white);
		rgba.set(3, alpha);
		return rgba.getInt32(0);
	}

	/**
	 * Converts grayscale to argb.
	 * 0xWWAA to AARRGGBB.
	 * @param bytePair 
	 * @return UInt
	 */
	public static function grayscaleToargba(bytePair:Bytes):UInt {
		var argb:Bytes = Bytes.alloc(4);
		var white = bytePair.get(0);
		var alpha = bytePair.get(1);
		argb.set(0, alpha);
		argb.set(1, white);
		argb.set(2, white);
		argb.set(3, white);
		return argb.getInt32(0);
	}

	/**
	 * Returns a 32 bit color value from the pallete
	 * or 0x00000000 if no such index in the palette.
	 * @param sprite 
	 * @param index 
	 * @return Null<UInt>
	 */
	public static function indexedToargb(sprite:Asesprite,
			index:Int):Null<UInt> {
		return
			index == sprite.ase.header.paletteEntry ? 0x00000000 : (sprite.aPalette.entries.exists(index) ? sprite.aPalette.entries[index] : 0x00000000);
	}
}