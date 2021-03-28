package game.asesprite;

import ase.chunks.TagsChunk;

/**
 * Holds information regarding the tag
 * a frame is within.
 */
class Tag {
	/**
	 * Asesprite `Tag` chunk data
	 */
	public var data(default,
		null):ase.chunks.TagsChunk.Tag; // default means once it's set once we're good

	public var name(get, never):String;

	public function new(tagData:ase.chunks.TagsChunk.Tag) {
		data = tagData;
	}

	inline function get_name():String {
		return data.tagName;
	}
}