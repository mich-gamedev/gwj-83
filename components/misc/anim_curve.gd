class_name AnimationCurve extends Node

@export var curve: Curve
@export var animation_player: AnimationPlayer

func _ready() -> void:
	Player.signals.fruit_collected.connect(_fruit_collected)

func _fruit_collected(fruit: Area2D) -> void:
	animation_player.speed_scale = curve.sample_baked(Player.score)
