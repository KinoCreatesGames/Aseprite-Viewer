package game.states;

import haxe.io.Bytes;
import openfl.events.Event;
import openfl.events.EventType;
import openfl.net.FileReference;
import flixel.math.FlxMath;
import game.asesprite.Asesprite;
import ase.Frame;
import ase.chunks.LayerChunk;
import ase.chunks.ChunkType;
import lime.app.Future;
import flixel.text.FlxText;
import flixel.FlxState;
import openfl.utils.Assets;
import ase.Ase;

class PlayState extends FlxState {
	public var asesprite:Asesprite;
	public var pauseButton:FlxButton;
	public var playButton:FlxButton;
	public var stopButton:FlxButton;
	public var browseButton:FlxButton;
	public var currentTag:String;

	public var tagButtons:Array<FlxButton> = [];

	override public function create() {
		super.create();
		add(new FlxText("Asesprite File Viewer", 24).screenCenter());
		createAse();
		createButtons();
	}

	public function createAse() {
		var exampleAseFile = AssetPaths.example__aseprite;
		trace('Added Asesprite File');
		var aSprite = new Asesprite(60, 60, 320, 299, exampleAseFile);
		asesprite = aSprite;
		asesprite.resize(150, 150).setPosition(150, 150);
		add(asesprite);
	}

	public function createButtons() {
		var x = 50;
		var y = 32;
		var spacing = 16;
		playButton = new FlxButton(x, y, 'Play', clickPlay);
		pauseButton = new FlxButton(createSpacer(playButton, spacing), y,
			'Pause', clickPause);
		stopButton = new FlxButton(createSpacer(pauseButton, spacing), y,
			'Stop', clickStop);

		browseButton = new FlxButton(createSpacer(stopButton, spacing), y,
			'Browse', clickBrowse);

		add(playButton);
		add(pauseButton);
		add(stopButton);
		add(browseButton);
		createTagButtons();
	}

	public inline function createSpacer(button:FlxButton, spacing:Int):Int {
		return Math.floor(button.x + button.width + spacing);
	}

	public function createTagButtons() {
		var verticalSpacing = 4;
		var yPosition = playButton.y + playButton.height + verticalSpacing;
		var xPosition = playButton.x;
		tagButtons.iter((button) -> button.kill());
		tagButtons.resize(0);
		for (tagName => tag in asesprite.aTags) {
			var button = new FlxButton(xPosition, yPosition, tagName, () -> {
				currentTag = tagName;
			});
			yPosition += verticalSpacing + playButton.height;
			tagButtons.push(button);
			add(button);
		}
	}

	public function clickPlay() {
		asesprite.play(currentTag);
	}

	public function clickPause() {
		// Pause Animation
		asesprite.pause();
	}

	public function clickStop() {
		asesprite.stop();
	}

	public function clickBrowse() {
		var fileRef = new FileReference();
		fileRef.addEventListener(Event.COMPLETE, (event) -> {
			trace('Completed browsing files', fileRef.data);
			// daa is usually in bytes
			var bytes:Bytes = cast fileRef.data;
			var ase = Ase.fromBytes(bytes);
			var asesprite = new Asesprite(60, 60, ase.header.width,
				ase.header.height, bytes);
			this.asesprite.kill();
			this.asesprite = asesprite;
			add(this.asesprite);
			createTagButtons();
			trace(fileRef.data);
			trace(fileRef.name);
			trace(fileRef.type);
			trace(fileRef.size);
		});

		fileRef.addEventListener(Event.SELECT, (event) -> {
			trace('Selected file');
			trace('Completed browsing files', fileRef.data);
			fileRef.load();
		});
		fileRef.browse();
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);
	}
}