package game.asesprite;

import ase.chunks.PaletteChunk;
import haxe.io.Bytes;

/**
 * Holds information regarding Sprite's palette
 * information.
 */
class Palette {
	public var data(default, null):PaletteChunk;

	/**
	 * A `Map` of palette's entries.
	 */
	public var entries(default, null):Map<Int, UInt> = [];

	/**
	 * Number of entries in the palette.
	 */
	public var size(get, null):Int;

	inline function get_size():Int {
		return data.paletteSize;
	}

	/**
	 * Creates a new palette with information on the 
	 		* palette of the sprite in Asesprite.
	 * @param paletteChunk 
	 */
	public function new(paletteChunk:PaletteChunk) {
		data = paletteChunk;

		for (index in data.entries.keys()) {
			var entry = data.entries[index];
			var color:Bytes = Bytes.alloc(4);
			color.set(0, entry.blue);
			color.set(1, entry.green);
			color.set(2, entry.red);
			color.set(3, entry.alpha);
			entries.set(index, color.getInt32(0));
		}
	}
}