package game.asesprite;

import game.asesprite.AseTypes.ColorDepth;
import openfl.utils.ByteArray;
import haxe.io.BytesInput;
import ase.chunks.CelChunk;
import openfl.display.BitmapData;

using game.asesprite.Color;

/**
 * A single cell in Asesprite, containing the pixel information.
 * This pixel data exists on a frame on a layer.
 */
class Cel extends BitmapData {
	private var celChunk:CelChunk;

	public var chunk(default, null):CelChunk;

	function get_chunk():CelChunk {
		return celChunk;
	}

	public function new(sprite:Asesprite, celChunk:CelChunk) {
		super(celChunk.width, celChunk.height, true, 0x00000000);
		this.celChunk = celChunk;

		// Pixel Input uses BytesInput as a container to stream the bytes
		// as we see fit
		var pixelInput:BytesInput = new BytesInput(this.celChunk.rawData);
		var pixels:ByteArray = new ByteArray(celChunk.width * celChunk.height * 4);

		// We loop from top to bottom left to right as in Asesprite
		// Pixels are filled from top left to bottom right.
		for (_ in 0...this.celChunk.height) {
			for (_ in 0...this.celChunk.width) {
				// Note Unsigned Int is only for Flash and C#, simulated for other platforms
				var pixel:UInt = 0x00000000; // AARRGGBB

				// Reading binary data directly into the pixel Unsigned Int
				// We check the sprite header for the colorDepth profile for
				// The Asesprite file
				switch (sprite.ase.header.colorDepth) {
					case ColorDepth.RGBA: // 32 bits per pixel
						// Reading 4 bytes (32 bits) for RGBA
						pixel = pixelInput.read(4).rgbaToargb();
					case ColorDepth.GRAYSCALE: // 16 bits per pixel
						pixel = pixelInput.read(2).grayscaleToargba();
					case ColorDepth.INDEXED: // 8 bits per pixel
						pixel = sprite.indexedToargb(pixelInput.readByte());
				}
				pixels.writeUnsignedInt(pixel);
			}
		}

		// Return the position of the byte array back to 0 for reading
		pixels.position = 0;

		// Set the pixel information in the cel to the bitmap.
		lock();
		setPixels(rect, pixels);
		unlock();

		// Clear the byte array as we're done with the pixels after
		// Adding it to the bitmap
		pixels.clear();
	}
}