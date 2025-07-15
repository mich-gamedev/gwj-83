extends CharacterBody2D

var START_SPEED := randf_range(320, 512)
const GROUPS = [&"player", &"player", &"player", &"player_fruit", &"player_node"]

@onready var line: Polygon2D = $Node2D/Line2D

func _ready() -> void:
	await get_tree().process_frame
	var target : Node2D = get_tree().get_nodes_in_group(GROUPS.pick_random()).pick_random()
	velocity = global_position.direction_to(target.global_position).rotated(deg_to_rad(randf_range(-10, 10))) * START_SPEED
	line.rotation = randf() * TAU
	await get_tree().create_timer(.33).timeout
	collision_mask = 1

func _physics_process(delta: float) -> void:
	if velocity != Vector2():
		velocity = velocity.move_toward(Vector2(), START_SPEED/2 * delta)

func _anim_finished(anim_name: StringName) -> void:
	queue_free()

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area is PlayerNode:
		Player.kill_node(area)
