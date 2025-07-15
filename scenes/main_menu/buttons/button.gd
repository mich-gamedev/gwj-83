extends Button

@onready var label_white: Label = $Label
@onready var label_black: Label = $Label/ColorRect/Label
@onready var panel: Panel = $Label/ColorRect

var twn: Tween

func _ready() -> void:
	mouse_entered.connect(_mouse_entered)
	mouse_exited.connect(_mouse_exited)

func _process(delta: float) -> void:
	label_black.visible = panel.size.x > 0.25

func _mouse_entered() -> void:
	if twn: twn.kill()
	twn = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO).set_parallel()
	twn.tween_property(panel, ^"size:x", size.x, .5)
	twn.tween_property(label_black, ^"position:x", 4, .5)
	twn.tween_property(label_white, ^"position:x", 4, .5)

func _mouse_exited() -> void:
	if twn: twn.kill()
	twn = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO).set_parallel()
	twn.tween_property(panel, ^"size:x", 0, .5)
	twn.tween_property(label_black, ^"position:x", 0, .5)
	twn.tween_property(label_white, ^"position:x", 0, .5)
