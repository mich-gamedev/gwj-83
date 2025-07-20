extends Button

@export var responsible_property: String

@onready var off_panel: Panel = $Control/OffPanel
@onready var on_panel: Panel = $Control/OnPanel
@onready var hover: Control = $Control
@onready var sfx_hover: AudioStreamPlayer = $"../../Music/Spinbox/Hover"
@onready var sfx_press: AudioStreamPlayer = $"../../Music/Spinbox/Press"

var twn: Tween
var hover_twn: Tween

func _ready() -> void:
	mouse_entered.connect(_mouse_entered)
	mouse_exited.connect(_mouse_exited)
	set_deferred(&"button_pressed", SaveData.data[responsible_property])

func _mouse_entered() -> void:
	if hover_twn: hover_twn.kill()
	hover_twn = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	hover_twn.tween_property(hover, ^"position", Vector2(-2, -1), 0.25)
	sfx_hover.play()

func _mouse_exited() -> void:
	if hover_twn: hover_twn.kill()
	hover_twn = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	hover_twn.tween_property(hover, ^"position", Vector2(), 0.25)

func _toggled(toggled_on: bool) -> void:
	if twn: twn.kill()
	sfx_press.play()
	off_panel.size = Vector2(24, 1)
	on_panel.size = Vector2(24, 1)
	off_panel.position = Vector2(-5, 6)
	on_panel.position = Vector2(-5, 6)
	on_panel.visible = toggled_on
	off_panel.visible = !toggled_on
	twn = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC).set_parallel()
	twn.tween_property(off_panel, ^"size", Vector2(14, 14), 0.5)
	twn.tween_property(off_panel, ^"position", Vector2(), 0.5)
	twn.tween_property(on_panel, ^"size", Vector2(14, 14), 0.5)
	twn.tween_property(on_panel, ^"position", Vector2(), 0.5)
	SaveData.data[responsible_property] = toggled_on
