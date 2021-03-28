package game.asesprite;

import ase.chunks.SliceChunk;

/**
 * Holds information regarding a slice from Asesprite.
 * Additionally could have a 9Slice information.
 */
class Slice {
	public var name(get, never):String;
	public var data(default, null):SliceChunk;

	public var has9Slices(get, never):Bool;

	public var firstKey(get, never):SliceKey;

	public function new(data:SliceChunk) {
		this.data = data;
	}

	inline function get_name() {
		return data.name;
	}

	// Inlining the get returns is a good optimization
	inline function get_has9Slices():Bool {
		return data.has9Slices;
	}

	/**
	 * First 9Slice Slice Key
	 * @return Bool
	 */
	inline function get_firstKey():SliceKey {
		return data.sliceKeys[0];
	}
}