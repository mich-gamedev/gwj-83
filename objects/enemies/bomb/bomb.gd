extends AnimatableBody2D

var velocity: Vector2
var START_SPEED := randf_range(320, 512)

@onready var line: Polygon2D = $Node2D/Line2D

func _ready() -> void:
	var target : Player = get_tree().get_first_node_in_group(&"player")
	velocity = global_position.direction_to(target.global_position).rotated(deg_to_rad(randf_range(-10, 10))) * START_SPEED
	line.rotation = randf() * TAU

func _physics_process(delta: float) -> void:
	velocity = velocity.move_toward(Vector2(), START_SPEED/2 * delta)
	position += velocity * delta

func _anim_finished(anim_name: StringName) -> void:
	queue_free()
