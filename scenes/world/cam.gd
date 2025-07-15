class_name ShakeCam extends Camera2D

var twn: Tween
static var node: ShakeCam

func _ready() -> void:
	node = self

static func shake(amt: float) -> void:
	node._shake(amt)

func _shake(amt: float) -> void:
	if twn: twn.kill()
	twn = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	twn.tween_property(self, ^"offset", Vector2.from_angle(randf() * TAU) * amt, 0.1)
	twn.tween_property(self, ^"offset", Vector2(), 0.2)
