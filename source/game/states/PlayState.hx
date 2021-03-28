package game.states;

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
	public var pauseButton:FlxButton;

	override public function create() {
		super.create();
		add(new FlxText("Hello World", 32).screenCenter());
		createAse();
		createButtons();
	}

	public function createAse() {
		var exampleAseFile = AssetPaths.example__aseprite;
		trace('Added Asesprite File');
		var aSprite = new Asesprite(30, 30, 320, 299, exampleAseFile);
		add(aSprite);
		// var data = Assets.loadBytes(exampleAseFile);
		// data.onComplete((value) -> {
		// 	// trace(value);
		// 	var ase = Ase.fromBytes(value);
		// 	// trace(ase);
		// 	var sprite = new FlxSprite(0, 0);
		// 	sprite.makeGraphic(ase.header.width, ase.header.height,
		// 		KColor.TRANSPARENT);
		// 	trace(sprite.width, sprite.height);
		// 	var chunk = ase.frames[0].chunks[0];
		// 	switch (chunk.header.type) {
		// 		case ChunkType.LAYER:
		// 			var layerChunk:LayerChunk = cast chunk;
		// 		// sprite.pixels.draw(ase.frames[0].);
		// 		case _:
		// 			// Do nothing for now;
		// 	}

		// 	add(sprite);
		// });
	}

	public function createButtons() {
		var x = FlxG.width - 200;
		var y = 32;
		pauseButton = new FlxButton(x, y, 'Pause', clickPause);
	}

	public function clickPause() {
		// Pause Animation
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);
	}
}