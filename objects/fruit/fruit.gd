extends Area2D

@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var sprites: Node2D = $Node2D

func _ready() -> void:
	sprites.scale.x = [-1, 1].pick_random()

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == &"spawn":
		anim.play(&"sway")
