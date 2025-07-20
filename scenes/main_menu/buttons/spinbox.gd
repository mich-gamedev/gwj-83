extends Control

@export var responsible_property: String

@onready var minus: Button = $Control/Minus
@onready var label: Label = $Label
@onready var plus: Button = $Control2/Plus
@onready var hover: AudioStreamPlayer = $Hover
@onready var press: AudioStreamPlayer = $Press

var twn: Tween

@export_range(0, 10) var value: int = 5:
	set(v):
		value = v
		label.text = "%02d" % v
		if is_node_ready():
			label.scale = Vector2(0.25, 1.5)
			if twn: twn.kill()
			twn = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
			twn.tween_property(label, ^"scale", Vector2.ONE, 0.5)
		plus.disabled = value >= 10
		minus.disabled = value <= 0
		SaveData.data[responsible_property] = v

func _ready() -> void:
	minus.mouse_entered.connect(_hovered)
	minus.pressed.connect(_pressed)
	plus.mouse_entered.connect(_hovered)
	plus.pressed.connect(_pressed)
	minus.pressed.connect(func(): value -= 1)
	plus.pressed.connect(func(): value += 1)
	value = SaveData.data[responsible_property]

func _pressed() -> void:
	press.play()

func _hovered() -> void:
	hover.play()
