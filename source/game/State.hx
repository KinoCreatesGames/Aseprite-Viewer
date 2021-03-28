package game;

class State {
	public var currentState:Float -> Void;

	public function new(initialState:Float -> Void) {
		currentState = initialState;
	}

	public function update(elapsed:Float) {
		currentState(elapsed);
	}
}