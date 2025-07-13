extends Path2D

const BOMB = preload("res://objects/enemies/bomb/bomb.tscn")

func spawn() -> void:
	var point = curve.sample_baked(randf_range(0, curve.get_baked_length()))
	print(point)
	var inst = BOMB.instantiate()
	get_tree().current_scene.add_child(inst)
	inst.global_position = to_global(point)
