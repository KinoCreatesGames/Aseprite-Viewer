package game.states;

import game.ui.TextButton;

class PauseSubState extends FlxSubState {
	public var pauseText:FlxText;

	private var pauseExitSound:FlxSound;
	private var initialPosition:Float;
	private var timeCount:Float;

	public function new() {
		super(KColor.RICH_BLACK_FORGRA_LOW); // Lower Opacity RICH_Black
	}

	override public function create() {
		pauseExitSound = FlxG.sound.load(AssetPaths.pause_out__wav);
		FlxG.mouse.visible = true;
		pauseText = new FlxText(0, 0, -1, 'Pause', Globals.FONT_L);
		pauseText.screenCenter();
		pauseText.y -= 30;
		pauseText.scrollFactor.set(0, 0);
		initialPosition = pauseText.y;
		add(pauseText);
		var resumeButton = new TextButton(0, 0, 'Resume', Globals.FONT_N,
			resumeGame);
		resumeButton.screenCenter();
		resumeButton.y += 40;
		resumeButton.hoverColor = KColor.BURGUNDY;
		resumeButton.clickColor = KColor.BURGUNDY;
		var returnToTitleButton = new TextButton(0, 0, 'To Title',
			Globals.FONT_N, toTitle);
		returnToTitleButton.screenCenter();
		returnToTitleButton.y += 80;
		returnToTitleButton.hoverColor = KColor.BURGUNDY;
		returnToTitleButton.clickColor = KColor.BURGUNDY;
		add(resumeButton);
		add(returnToTitleButton);
		super.create();
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);
		updatePausePosition(elapsed);
	}

	public function updatePausePosition(elapsed:Float) {
		timeCount += elapsed;
		pauseText.y = initialPosition + (30 * Math.sin(timeCount));
		if (timeCount > 30) {
			timeCount = 0;
		}
	}

	public function resumeGame() {
		pauseExitSound.play();
		close();
	}

	public function toTitle() {
		pauseExitSound.play();
		FlxG.camera.fade(KColor.BLACK, 1, false, () -> {
			close();

			FlxG.switchState(new TitleState());
		});
	}
}