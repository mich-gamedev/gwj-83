class_name Player extends Node2D

const MIN_DIST: float = 16.
const MAX_DIST: float = 64.
const NODE = preload("res://objects/player/node.tscn")
const SLICE = preload("res://fx/vfx/slice.tscn")

static var hp: int = 3
static var nodes: Array[PlayerNode]
static var signals := Signals.new()
static var score: int = 0
static var player: Player

@onready var coll_cast: RayCast2D = $CollCast
@onready var fruit_cast: RayCast2D = $FruitCast
@onready var line: Line2D = $Line2D
@onready var guide: Line2D = $Guide
@onready var guide_ring: RingDraw = $GuideRing
@onready var tongue: Line2D = $Tongue
@onready var mouse_warper: Control = $MouseWarper

class Signals:
	signal fruit_collected(fruit: Area2D)
	signal score_updated
	signal node_spawned(node: PlayerNode)
	signal harmed

func _ready() -> void:
	player = self
	guide_ring.global_position = global_position
	await get_tree().process_frame
	spawn_node()

func _physics_process(delta: float) -> void:
	line.clear_points()
	for i in nodes:
		line.add_point(i.ring_draw.global_position)
	guide.clear_points()
	var target = get_local_mouse_position()
	target = target.normalized() * clamp(target.length(), MIN_DIST, MAX_DIST)
	for i in [0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1]:
		var point = (to_local(nodes[-1].ring_draw.global_position) if !nodes.is_empty() else Vector2()).lerp(to_local(guide_ring.global_position), i)
		point.y += 64 * (i - .5) ** 2 - 16
		guide.add_point(point)
	guide_ring.global_position = guide_ring.global_position.lerp(to_global(target), 1 - 0.0000000001 ** delta)
	if nodes.size() > 1:
		tongue.global_position = nodes[-1].ring_draw.global_position
	var joy_dir := Input.get_vector(&"left", &"right", &"up", &"down")
	const DEADZONE := .2
	if joy_dir:
		mouse_warper.warp_mouse(joy_dir.normalized() * remap(joy_dir.length(), DEADZONE, 1, MIN_DIST, MAX_DIST))

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(&"fire"):
		var target := get_local_mouse_position()
		target = target.normalized() * clampf(target.length(), MIN_DIST, MAX_DIST)
		coll_cast.target_position = target
		coll_cast.force_raycast_update()
		fruit_cast.target_position = -(target + (target.normalized() * 16))
		fruit_cast.position = (target.normalized() * 8)
		tongue.rotation = target.angle()
		if coll_cast.is_colliding(): return

		global_position += coll_cast.target_position
		fruit_cast.force_raycast_update()
		if nodes.size() > 1: nodes[-1].decay()

		while fruit_cast.is_colliding():
			var node : Node2D = fruit_cast.get_collider() as Node2D
			if node.is_in_group(&"player_fruit"):
				hp += 1
				score += 1
				signals.fruit_collected.emit(node)
				signals.score_updated.emit()
				node.queue_free()
			if node is PlayerNode and nodes[-1] != node: kill_node(node)
			fruit_cast.add_exception(node)
			fruit_cast.force_raycast_update()
			if node.is_in_group(&"sliceable_area"):
				hp += node.get_meta(&"slice_bonus", 0)
				score += node.get_meta(&"slice_bonus", 0)
				signals.score_updated.emit()
				node.owner.queue_free()
				var inst : Line2D = SLICE.instantiate() as Line2D
				get_tree().current_scene.add_child(inst)
				inst.global_position = node.global_position
				inst.global_rotation = target.angle()
				ShakeCam.shake(3)
		spawn_node()
		fruit_cast.clear_exceptions()

func spawn_node() -> PlayerNode:
	var inst : PlayerNode = NODE.instantiate()
	get_tree().current_scene.add_child(inst)
	inst.global_position = global_position
	nodes.append(inst)
	signals.node_spawned.emit(inst)

	for i in max(nodes.size() - hp, 0):
		nodes[i].kill()
		nodes.pop_front()

	return inst

static func kill_node(node: PlayerNode) -> void:
	signals.harmed.emit()
	for i in nodes.find(node):
		nodes[0].ring_draw.draw_color = Color("#df4fcd")
		nodes[0].kill()
		nodes.pop_front()
		hp -= 1
	Engine.get_main_loop().paused = true
	Engine.get_main_loop().create_timer(0.25).timeout
	Engine.get_main_loop().paused = false
