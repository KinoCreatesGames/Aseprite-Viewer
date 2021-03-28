package game.asesprite;

import ase.chunks.PaletteChunk;
import haxe.io.Bytes;

/**
 * Holds information regarding Sprite's palette
 * information.
 */
class Palette {
	private var data:PaletteChunk;
	private var paletteEntries:Map<Int, UInt> = [];

	/**
	 * A `Map` of palette's entries.
	 */
	public var entries(default, null):Map<Int, UInt>;

	function get_entries():Map<Int, UInt> {
		return paletteEntries;
	}

	/**
	 * Number of entries in the palette.
	 */
	public var size(default, null):Int;

	function get_size():Int {
		return data.paletteSize;
	}

	public function new(paletteChunk:PaletteChunk) {
		data = paletteChunk;

		for (index in data.entries.keys()) {
			var entry = data.entries[index];
			var color:Bytes = Bytes.alloc(4);
			color.set(0, entry.blue);
			color.set(1, entry.green);
			color.set(2, entry.red);
			color.set(3, entry.alpha);
			paletteEntries.set(index, color.getInt32(0));
		}
	}
}