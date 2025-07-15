extends Button

var twn_hover: Tween
var twn_press: Tween

@export var hover_pos: Vector2 = Vector2(-2, -1)
@export var press_scale: Vector2 = Vector2(0.25, 1.5)

func _ready() -> void:
	mouse_entered.connect(_mouse_entered)
	mouse_exited.connect(_mouse_exited)

func _mouse_entered() -> void:
	if disabled: return
	if twn_hover: twn_hover.kill()
	twn_hover = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	twn_hover.tween_property(self, ^"position", hover_pos, 0.25)

func _mouse_exited() -> void:
	if twn_hover: twn_hover.kill()
	twn_hover = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	twn_hover.tween_property(self, ^"position", Vector2(), 0.25)

func _pressed() -> void:
	scale = press_scale
	if twn_press: twn_press.kill()
	twn_press = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	twn_press.tween_property(self, ^"scale", Vector2.ONE, 0.5)
