extends ProgressBar

var twn: Tween

@onready var sparkle: AnimationPlayer = $Sparkle

func _ready() -> void:
	Player.signals.score_updated.connect(_score_updated)
	Player.signals.upgrades_finished.connect(_upgrades_finished, CONNECT_DEFERRED)

func _process(delta: float) -> void:
	get_child(0).visible = !is_equal_approx(value, min_value)
	sparkle.play(&"sparkle" if value >= max_value - 2 else &"RESET")

func _score_updated() -> void:
	if twn: twn.kill()
	twn = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	twn.tween_property(self, ^"value", Player.score, 0.5)

func _upgrades_finished() -> void:
	var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO).set_parallel()
	tween.tween_property(self, ^"min_value", Player.score, 0.5)
	tween.tween_property(self, ^"max_value", Player.upgrade_amount, 0.5)
