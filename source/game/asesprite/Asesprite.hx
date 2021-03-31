package game.asesprite;

import openfl.geom.Rectangle;
import ase.chunks.ChunkType;
import ase.chunks.TagsChunk;
import haxe.io.Bytes;
import openfl.display.Bitmap;
import ase.AnimationDirection;
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

	public var filePath:String;

	// Prefix with A to differentiate from other Flixel Classes
	public var aFrames(default, null):Array<Frame> = [];
	public var aFrameTags:TagsChunk;
	public var aFrameTime:Int = 0;
	public var aLayers(default, null):Array<LayerChunk> = [];
	public var aPalette(default, null):Palette;
	public var aBitmap(default, null):Bitmap;
	public var aPlaying(default, null):Bool;
	public var playBackSpeed:Int = 20;

	/**
	 * Map of all the tags associated with the asesprite file.
	 */
	public var aTags(default, null):Map<String, game.asesprite.Tag> = [];

	// Callback functions for entering data on the screen.
	public var onFinished:Void -> Void = null;
	public var onFrame:Array<Int -> Void> = [];
	public var onTag:Array<Array<String> -> Void> = [];

	public var currentFrame(default, set):Int = -1;
	public var currentRepeat:Int = 0;
	public var currentTag:String;
	public var alternatingDirection:Int = AnimationDirection.FORWARD;
	public var direction:Int = AnimationDirection.FORWARD;
	public var repeats:Int = -1;

	public var toFrame(get, never):Int;
	public var fromFrame(get, never):Int;

	/**
		Array of `Slice`s
	**/
	public var slices(default, null):Map<String, Slice> = [];

	public static function fromBytes(bytes:Bytes, useEnterFrame:Bool = true) {
		return null;
		// return new Asesprite(0, 0, );
	}

	public function new(x:Float, y:Float, width, height, ?aseFile:String,
			?bytes:Bytes) {
		super(x, y);

		this.makeGraphic(width, height, KColor.TRANSPARENT);
		// Load the Bytes from the Asesprite file
		if (aseFile != null) {
			this.filePath = aseFile;

			Assets.loadBytes(this.filePath).onComplete((byteData:ByteArray) -> {
				var data = byteData;
				ase = Ase.fromBytes(data);
				parseAsespriteFile(ase);
				currentFrame = 0; // Default current frame and redraw frame data
			});
		}
		if (bytes != null) {
			ase = Ase.fromBytes(bytes);
			trace(ase);
			parseAsespriteFile(ase);
			currentFrame = 0;
		}
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);
		if (aPlaying) {
			advance(playBackSpeed);
		}
	}

	public function setPlaybackSpeed(val:Int) {
		this.playBackSpeed = val;
		return this;
	}

	public function play(?tagName:String = null, ?repeats:Int = -1,
			?onFinished:Void -> Void = null):Asesprite {
		if (tagName != null) {
			currentTag = tagName;
		}
		aPlaying = true;
		this.repeats = currentRepeat = repeats;
		this.onFinished = onFinished;

		return this;
	}

	public function pause():Asesprite {
		aPlaying = false;
		return this;
	}

	/**
	 * Pause the animation and bring the playhead to the first frame
	 * of the animation or the current tag.
	 * @return Asesprite
	 */
	public function stop():Asesprite {
		pause();
		currentFrame = fromFrame;
		this.currentRepeat = this.repeats;
		return this;
	}

	public function spawn(?sliceName:String, ?spriteWidth:Int,
			?spriteHeight:Int, useEnterFrame:Null<Bool> = null):Asesprite {
		// return new Asesprite(this.x, this.y, this.filePath);
		// sliceName == null ? null : slices[sliceName],
		// useEnterFrame == null ? this.useEnterFrame : useEnterFrame,
		// spriteWidth, spriteHeight);
		return null;
	}

	/**
	 * Advance the animation by `time` in milliseconds
	 * @param time 
	 * @return Asesprite
	 */
	public function advance(time:Int):Asesprite {
		if (aPlaying) {
			if (time < 0) {
				throw 'TODO: time value can be negative';
			}
			aFrameTime += time;
			// Goes through each frame so long as frame is greater than duration
			while (aFrameTime > aFrames[currentFrame].duration) {
				aFrameTime -= aFrames[currentFrame].duration;
				nextFrame();
			}
		}
		return this;
	}

	public function nextFrame():Asesprite {
		var currentDirection:Int = direction;
		if (direction == AnimationDirection.PING_PONG) {
			currentDirection = this.alternatingDirection;
		}
		var futureFrame:Int = currentFrame;
		var alternationDirection:Int = currentDirection;

		if (currentDirection == AnimationDirection.FORWARD) {
			futureFrame = currentFrame + 1;
		} else if (currentDirection == AnimationDirection.REVERSE) {
			futureFrame = currentFrame - 1;
			alternationDirection = AnimationDirection.FORWARD;
		}

		if (futureFrame > toFrame || futureFrame < fromFrame) {
			if ((repeats == -1) || (repeats != -1 && --currentRepeat > 0)) {
				if (direction == AnimationDirection.PING_PONG) {
					currentFrame += alternationDirection == AnimationDirection.FORWARD ? 1 : -1;
					this.alternatingDirection == alternationDirection;
				} else {
					currentFrame = fromFrame;
				}
			} else {
				pause();
				if (onFinished != null) {
					onFinished();
					onFinished = null;
				}
			}
		} else {
			currentFrame = futureFrame;
		}

		return this;
	}

	/**
	 * 
	 * Resizes the sprite using Flixel setGraphicSize 
	 		* sprite.
	 * @param newWidth 
	 * @param newHeight 
	 */
	public function resize(newWidth:Int, newHeight:Int) {
		setGraphicSize(newWidth, newHeight);
		updateHitbox();
		return this;
	}

	public function parseAsespriteFile(value:Ase):Ase {
		ase = value;
		for (chunk in ase.frames[0].chunks) {
			switch (chunk.header.type) {
				case ChunkType.LAYER:
					aLayers.push(cast chunk);
				case ChunkType.PALETTE:
					aPalette = new Palette(cast chunk);

				case ChunkType.TAGS: // Add Tags to the asesprite file
					aFrameTags = cast chunk;
					for (frameTagData in aFrameTags.tags) {
						var animationTag:game.asesprite.Tag = new game.asesprite.Tag(frameTagData);

						if (aTags.exists(frameTagData.tagName)) {
							var num:Int = 1;
							var newName:String = '${frameTagData.tagName}_$num';
							while (aTags.exists(newName)) {
								num++;
								newName = '${frameTagData.tagName}_$num';
							}
							trace('WARNING: This file already contains tag named "${frameTagData.tagName}". It will be be automatically renamed to "$newName"');
							aTags.set(newName, animationTag);
						} else {
							// Add the animation tag directly
							aTags.set(frameTagData.tagName, animationTag);
						}
					}
				case ChunkType.SLICE:
					var newSlice = new Slice(cast chunk);
					slices[newSlice.name] = newSlice;
					trace(slices);
				case _:
					// Do nothing
			}
		}
		// Assign Asesprite Frames
		for (index in 0...ase.frames.length) {
			var frame = ase.frames[index];
			// Haxe is smart enough to organize the extra functions based on type
			// Meaning the frame information is being passed in to the last parameter
			// Despite being put in the third parameter here
			var newFrame:Frame = new Frame(index, this, frame);
			// totalDuration  += newFrame.duration;
			aFrames.push(newFrame);
			trace('Added new Frame');
		}

		// Assign Tags
		for (tag in aTags) {
			for (frameIndex in tag.data.fromFrame...tag.data.toFrame + 1) {
				aFrames[frameIndex].tags.push(tag.name);
			}
		}
		currentFrame = 0;

		return ase;
	}

	/**
	 * Starting frame of the animation of the current tag.
	 * @return Int
	 */
	inline function get_toFrame():Int {
		return
			currentTag != null ? aTags[currentTag].data.toFrame : aFrames.length
			- 1;
	}

	/**
	 * Ending frame of the animation of the current tag.
	 * @return Int
	 */
	inline function get_fromFrame():Int {
		return currentTag != null ? aTags[currentTag].data.fromFrame : 0;
	}

	/**
	 * Specialized function that will update the 
	 * frame and sprite data when you set the current frame.
	 * @return Int
	 */
	function set_currentFrame(value:Int):Int {
		if (value < 0) {
			value = 0;
		}

		if (value >= aFrames.length) {
			value = aFrames.length - 1;
		}

		// Update the bitmap data
		currentFrame = value;
		var frameData = aFrames[currentFrame].bitmapData;
		// this.graphic.bitmap.fl
		if (this.graphic != null) {
			// Clear Previous Frame
			this.graphic.bitmap.fillRect(new Rectangle(0, 0, frameWidth,
				frameHeight),
				KColor.TRANSPARENT);
			this.graphic.bitmap.draw(frameData);
		}
		return currentFrame;
	}
}