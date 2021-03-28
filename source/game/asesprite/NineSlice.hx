package game.asesprite;

import ase.chunks.SliceChunk.SliceKey;
import openfl.display.BitmapData;

typedef NineSliceSlices = Array<Array<BitmapData>>;

/**
 * NineSlice is a class used to implement the 9Slice technique
 * for rescaling the sprite. It's a 2D resizing technique.
 */
class NineSlice extends FlxSprite {
	public static function generate(bitmapData:BitmapData,
			sliceKey:SliceKey):NineSliceSlices {
		var result:NineSliceSlices = [for (_ in 0...3) [for (_ in 0...3) null]];

		var xs = [];

		var ys = [];
		return result;
	}
}