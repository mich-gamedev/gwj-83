extends Node2D
@onready var line: Line2D = $Line2D
@onready var ray: RayCast2D = $RayCast2D
@onready var anim: AnimationPlayer = $AnimationPlayer

var stop_moving_laser: bool = false

var origin: Vector2
var elapsed: float

func _ready() -> void:
	await get_tree().process_frame
	origin = global_position

func _physics_process(delta: float) -> void:
	if !stop_moving_laser:
		ray.rotation = lerp_angle(ray.rotation, global_position.angle_to_point(Player.player.global_position), 1 - 0.005 ** delta)
		line.points[1] = to_local(ray.get_collision_point() - ray.target_position.normalized() * 2)
	elapsed += delta
	if origin != Vector2():
		global_position = origin + Vector2(sin(elapsed) * 2, cos(elapsed) * 4)

func kill() -> void:
	stop_moving_laser = true
	var coll = ray.get_collider()
	if coll is PlayerNode:
		Player.kill_node(coll)
	await anim.animation_finished
	queue_free()
