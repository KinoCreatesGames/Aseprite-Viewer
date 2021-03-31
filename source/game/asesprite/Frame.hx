package game.asesprite;

import openfl.display.Sprite;
import openfl.geom.Matrix;
import openfl.display.BlendMode;
import ase.chunks.LayerFlags;
import ase.chunks.CelType;
import ase.chunks.CelChunk;
import ase.chunks.ChunkType;
import game.asesprite.NineSlice.NineSliceSlices;
import openfl.display.Shape;
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
 * This frame can have tags and also be resized using 9Slices.
 */
class Frame {
	/**
	 * Animation frame bitmap data
	 */
	public var bitmapData:BitmapData;

	/**
	 * Duration of the animation frame
	 */
	public var duration(get, never):Int;

	/**
	 * Ase Codified frame information
	 		* Raw frame data.
	 */
	private var frame:ase.Frame;

	/**
	 * The frames that are a part of this animation frame.
	 */
	public var layers(default, null):Array<FrameLayer> = [];

	public var layersMap(default, null):Map<String, FrameLayer> = [];

	/**
	 * The tags that this frame of animation are associated with.
	 */
	public var tags(default, null):Array<String> = [];

	public var index(default, null):Int;

	public var nineSlices:NineSliceSlices;

	public var sprite(default, null):Asesprite;

	private var renderWidth:Int;
	private var renderHeight:Int;

	public function new(index:Int, ?frameBitmapData:BitmapData,
			?nineSlices:NineSliceSlices, ?renderWidth:Int, ?renderHeight:Int,
			?sprite:Asesprite, ?frame:ase.Frame) {
		// If Frame Bitmap data is supplied, use that for rendering
		if (sprite != null) {
			this.sprite = sprite;
		}
		if (frameBitmapData != null) {
			bitmapData = frameBitmapData;
		} else {
			if (nineSlices != null) {
				this.nineSlices = nineSlices;
			} else {
				bitmapData = new BitmapData(sprite.ase.header.width,
					sprite.ase.header.height, true, 0x00000000);
				this.frame = frame;

				// Place Asesprite layer info within within the frame.
				for (layer in sprite.aLayers) {
					var layerDef:FrameLayer = {
						layerChunk: layer,
						cel: null
					}
					layers.push(layerDef);
					layersMap.set(layer.name, layerDef);
				}

				// Take the binary data for individual frames chunk types
				// Input the cel information for each layer on the Asesprite file
				// Use this information in the program to determine sprite color
				// Linked Cels link to the frame position
				for (chunk in frame.chunks) {
					if (chunk.header.type == ChunkType.CEL) {
						var cel:CelChunk = cast chunk;
						if (cel.celType == CelType.LINKED) {
							layers[cel.layerIndex].cel = sprite.aFrames[cel.linkedFrame].layers[cel.layerIndex].cel;
						} else {
							layers[cel.layerIndex].cel = new Cel(sprite, cel);
						}
					}
				}
			}

			for (layer in layers) {
				if (layer.cel != null
					&& (layer.layerChunk.flags & LayerFlags.VISIBLE != 0)) {
					var blendModes:Array<BlendMode> = [
						NORMAL, // 0 - Normal
						MULTIPLY, // 1 - Multiply
						SCREEN, // 2 - Scren
						OVERLAY, // 3 - Overlay
						DARKEN, // 4 - Darken
						LIGHTEN, // 5 -Lighten
						NORMAL, // 6 - Color Dodge - NOT IMPLEMENTED
						NORMAL, // 7 - Color Burn - NOT IMPLEMENTED
						HARDLIGHT, // 8 - Hard Light
						NORMAL, // 9 - Soft Light - NOT IMPLEMENTED
						DIFFERENCE, // 10 - Difference
						ERASE, // 11 - Exclusion - Not sure about that
						NORMAL, // 12 - Hue - NOT IMPLEMENTED
						NORMAL, // 13 - Saturation - NOT IMPLEMENTED
						NORMAL, // 14 - Color - NOT IMPLEMENTED
						NORMAL, // 15 - Luminosity - NOT IMPLEMENTED
						ADD, // 16 - Addition
						SUBTRACT, // 17 - Subtract
						NORMAL // 18 - Divide - NOT IMPLEMENTED
					];
					var blendMode:BlendMode = blendModes[layer.layerChunk.blendMode];
					// Draws The Cel Pixel Data with the speicified blendMode into
					// the bitmap data
					var matrix:Matrix = new Matrix();
					matrix.translate(layer.cel.data.xPosition,
						layer.cel.data.yPosition);
					bitmapData.lock();
					bitmapData.draw(layer.cel, matrix, null, blendMode);
					bitmapData.unlock();
				}
			}
		}
	}

	// TODO: Remove 9Slice as we already have graphic resize in Flixel
	public function render9Slice(renderWidth:Int, renderHeight:Int) {
		if (null) if (bitmapData != null) {
			bitmapData.dispose();
			bitmapData = null;
		}

		var centerWidth = renderWidth
			- (nineSlices[0][0].width + nineSlices[0][2].width);
		var centerHeight = renderHeight
			- (nineSlices[0][0].height + nineSlices[2][0].height);

		var centerX = nineSlices[0][0].width;
		var centerY = nineSlices[0][0].height;

		var xs = [0, centerX, centerX + centerWidth];
		var ys = [0, centerY, centerY + centerHeight];

		var widths:Array<Int> = [nineSlices[0][0].width, centerWidth, nineSlices[0][2].width];
		var heights:Array<Int> = [nineSlices[0][0].height, centerHeight, nineSlices[2][0].height];

		var render = new Sprite();

		for (row in 0...3) {
			for (col in 0...3) {
				var sliceRender = new Shape();
				sliceRender.graphics.beginBitmapFill(nineSlices[row][col]);
				sliceRender.graphics.drawRect(0, 0, widths[col], heights[row]);
				sliceRender.graphics.endFill();

				sliceRender.x = xs[col];
				sliceRender.y = ys[row];
				// Takes the render of the slice and adds it to the new
				// Render so that we can draw the bitmap data from all the added children
				render.addChild(sliceRender);
			}
		}

		bitmapData = new BitmapData(renderWidth, renderHeight, true,
			0x00000000);
		bitmapData.draw(render);
	}

	/**
	 * Resizes the current frame.
	 * @param newWidth 
	 * @param newHeight 
	 */
	public function resize(newWidth:Int, newHeight:Int) {
		render9Slice(newWidth, newHeight);
	}

	inline function get_duration():Int {
		return frame.header.duration;
	}
}