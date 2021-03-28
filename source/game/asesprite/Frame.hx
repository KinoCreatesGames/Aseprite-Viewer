package game.asesprite;

import ase.chunks.LayerChunk;
import openfl.display.BitmapData;

// typedef FrameData = {
//   index:Int,
//   ?pixels:Pixels,
//   sprite:Asesprite,
//   frame:ase.Frame
// }

typedef FrameLayer = {
	layerChunk:LayerChunk,
	cel:Cel
}

/**
 * Holds Information about a single animation frame in Asesprite.
 */
class Frame {
	/**
	 * Animation frame bitmap data
	 */
	public var bitmapData:BitmapData;

	/**
	 * Duration of the animation frame
	 */
	public var duration(default, null):Int;

	/**
	 * Ase Codified frame information
	 		* Raw frame data.
	 */
	private var frame:ase.Frame;

	/**
	 * The frames that are a part of this animation frame.
	 */
	public var layers(default, null):Array<FrameLayer>;

	/**
	 * The tags that this frame of animation are associated with.
	 */
	public var tags(default, null):Array<String>;
}