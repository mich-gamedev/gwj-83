extends Button

@onready var label_white: Label = $Label
@onready var label_black: Label = $Label/ColorRect/Label
@onready var panel: Panel = $Label/ColorRect
@onready var hover: AudioStreamPlayer = $Hover
@onready var press: AudioStreamPlayer = $Press

@export var do_start_anim: bool = false

var twn: Tween
var start_twn: Tween

func _ready() -> void:
	mouse_entered.connect(_mouse_entered)
	mouse_exited.connect(_mouse_exited)
	pressed.connect(press.play)
	panel.resized.connect(_resized)
	if do_start_anim:
		label_white.scale = Vector2(5, 0.0)
		await get_tree().create_timer(0.2 + 0.1 * get_parent().get_children().find(self)).timeout
		start_twn = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
		start_twn.tween_property(label_white, ^"scale", Vector2.ONE, 0.5)

func _resized() -> void:
	label_black.visible = panel.size.x > 0.25

func _mouse_entered() -> void:
	if twn: twn.kill()
	twn = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO).set_parallel()
	twn.tween_property(panel, ^"size:x", size.x, .5)
	twn.tween_property(label_black, ^"position:x", 4, .5)
	twn.tween_property(label_white, ^"position:x", 4, .5)
	hover.play()

func _mouse_exited() -> void:
	if twn: twn.kill()
	twn = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO).set_parallel()
	twn.tween_property(panel, ^"size:x", 0, .5)
	twn.tween_property(label_black, ^"position:x", 0, .5)
	twn.tween_property(label_white, ^"position:x", 0, .5)
