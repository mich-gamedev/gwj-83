extends Path2D

@export var scene: PackedScene
@export var group: StringName
@export var max_curve: Curve
@export var delay_min_max: Vector2 = Vector2(0, .25)
@export var min_player_dist: float = 96.
@export var active: bool = true

const MAX_DIST_ATT = 48

func spawn() -> void:
	if !Player.can_spawn_enemies: return
	if !active: return
	await get_tree().create_timer(randf_range(delay_min_max.x, delay_min_max.y)).timeout
	if !max_curve or get_tree().get_nodes_in_group(group).size() < max_curve.sample_baked(Player.score):
		var too_close := !is_zero_approx(min_player_dist)
		var point: Vector2 = curve.sample_baked(randf_range(0, curve.get_baked_length()))
		var att := 0
		while too_close:
			att += 1
			if att > MAX_DIST_ATT:
				too_close = false
				break
			point = curve.sample_baked(randf_range(0, curve.get_baked_length()))
			too_close = false
			for i in Player.nodes:
				print("DISTANCE: ", i.global_position.distance_to(to_global(point)))
				if i.global_position.distance_to(to_global(point)) < min_player_dist:
					too_close = true
		var inst = scene.instantiate()
		get_tree().current_scene.add_child(inst)
		inst.add_to_group(&"enemy")
		inst.global_position = to_global(point)
		Stats.enemies += 1
