package game.asesprite;

import ase.chunks.LayerChunk;
import ase.Ase;
import openfl.utils.ByteArray;
import openfl.utils.Assets;

/**
 * A FlxSprite class with information about
 * the different properties of an Asesprite file.
 * This includes:
 * Frames - Frames of animation
 * Layers - Layers of the Asesprite file
 * Tags - Tags for individual animations
 * Slices
 * Palette
 * Duration - duration of an animation
 */
class Asesprite extends FlxSprite {
	public var ase:Ase;
	// Prefix with A to differentiate from other Flixel Classes
	public var aFrames(default, null):Array<Frame>;
	public var aLayers(default, null):Array<LayerChunk>;
	public var aPalette(default, null):Palette;

	public function new(x:Float, y:Float, aseFile:String) {
		super(x, y);
		// Load the Bytes from the Asesprite file
		Assets.loadBytes(aseFile).onComplete((byteData:ByteArray) -> {
			var data = byteData;
			ase = Ase.fromBytes(data);
		});
	}
}