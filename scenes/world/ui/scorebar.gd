extends ProgressBar

var twn: Tween

func _ready() -> void:
	Player.signals.score_updated.connect(_score_updated)

func _score_updated() -> void:
	if twn: twn.kill()
	twn = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	twn.tween_property(self, ^"value", Player.score, 0.5)
