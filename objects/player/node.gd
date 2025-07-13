class_name PlayerNode extends Area2D

@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var coll_shape: CollisionShape2D = $CollisionShape2D
@onready var ring_draw: RingDraw = $RingDraw
var elapsed := randf_range(0, 10)
var origin := Vector2(-1, -1)

func _ready() -> void:
	Player.signals.node_spawned.connect(_node_spawned, CONNECT_DEFERRED)
	await get_tree().process_frame
	origin = global_position
	(coll_shape.shape as SegmentShape2D).b = to_local(Player.nodes[-2].global_position) if Player.nodes.size() > 2 else Vector2()

func decay() -> void:
	anim.play(&"decay")

func kill() -> void:
	anim.play(&"pop")
	await anim.animation_finished
	queue_free()

func _physics_process(delta: float) -> void:
	elapsed += delta
	if origin != Vector2(-1, -1):
		ring_draw.global_position = origin + Vector2(sin(elapsed) * 2, cos(elapsed) * 4)

func _node_spawned(node: PlayerNode) -> void:
	if Player.nodes.find(self) == 0:
		coll_shape.disabled = true
