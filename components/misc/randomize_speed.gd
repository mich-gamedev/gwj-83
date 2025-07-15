class_name RandomizeAnimationSpeed extends Node

@export var anim: Node
@export var min_scale: float = 0.8
@export var max_scale: float = 1.2

func _ready() -> void:
	if "speed_scale" in anim:
		anim.speed_scale = randf_range(min_scale,max_scale)
	else:
		push_error("No 'speed_scale' found on '%s'" % anim.get_path() if anim else "invalid object")
