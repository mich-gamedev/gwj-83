class_name Player extends Node2D

const MIN_DIST: float = 16.
const NODE = preload("res://objects/player/node.tscn")
const SLICE = preload("res://fx/vfx/slice.tscn")

static var hp: int = 3:
	set(v):
		hp = v
		Stats.longest_length = max(hp, Stats.longest_length)
static var nodes: Array[PlayerNode]
static var signals := Signals.new()
static var score: int = 0:
	set(v):
		score = v
		if v >= upgrade_amount:
			signals.upgrades_ready.emit()
			can_spawn_enemies = false
static var player: Player
static var is_dead: bool

static var upgrade_amount: int = 20
static var can_spawn_enemies = true

const FRUIT = preload("res://objects/fruit/fruit.tscn")

@onready var coll_cast: RayCast2D = $CollCast
@onready var fruit_cast: ShapeCast2D = $FruitCast
@onready var line: Line2D = $Line2D
@onready var guide: Line2D = $Guide
@onready var guide_ring: RingDraw = $GuideRing
@onready var tongue: Line2D = $Tongue
@onready var mouse_warper: Control = $MouseWarper
@onready var parry_vuln_timer: Timer = $ParryVulnTimer
@onready var dmg_cast: RayCast2D = $DmgCast
@onready var player_area: Area2D = $PlayerArea
@onready var sfx_place: AudioStreamPlayer = $SfxPlace
@onready var sfx_slice: AudioStreamPlayer = $SfxSlice
@onready var sfx_eat: AudioStreamPlayer = $SfxEat

class Signals:
	signal fruit_collected(fruit: Area2D)
	signal score_updated
	signal node_spawned(node: PlayerNode)
	signal harmed
	signal died(to: Node2D)
	signal upgrades_ready
	signal upgrades_finished

static func reset() -> void:
	nodes.clear()
	hp = 3
	score = 0
	is_dead = false
	upgrade_amount = 20
	can_spawn_enemies = true
	Stats.reset()
	Upgrade.reset()

func _ready() -> void:
	fruit_cast.add_exception(player_area)
	reset()
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
	target = target.normalized() * clamp(target.length(), MIN_DIST, Upgrade.data["node_dist"])
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
		mouse_warper.warp_mouse(joy_dir.normalized() * remap(joy_dir.length(), DEADZONE, 1, MIN_DIST, Upgrade.data["node_dist"]))

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(&"fire") and !is_dead:
		var target := get_local_mouse_position()
		target = target.normalized() * clampf(target.length(), MIN_DIST, Upgrade.data["node_dist"])
		coll_cast.target_position = target
		coll_cast.force_raycast_update()
		fruit_cast.target_position = -(target + (target.normalized() * 20))
		fruit_cast.position = (target.normalized() * 10)
		tongue.rotation = target.angle()
		if coll_cast.is_colliding(): return

		global_position += coll_cast.target_position
		fruit_cast.force_shapecast_update()
		if nodes.size() > 1: nodes[-1].decay()
		parry_vuln_timer.start()

		for i in fruit_cast.get_collision_count():
			var node : Node2D = fruit_cast.get_collider(i) as Node2D
			if node.is_in_group(&"player_fruit"):
				hp += 1
				if can_spawn_enemies: score += 1
				signals.fruit_collected.emit(node)
				signals.score_updated.emit()
				node.queue_free()
				sfx_eat.play()
			if node.is_in_group(&"no_spawn_fruit"):
				hp += 1
				if can_spawn_enemies: score += 1
				signals.score_updated.emit()
				node.queue_free()
				sfx_eat.play()
			if node.is_in_group(&"sliceable_area"):
				hp += node.get_meta(&"slice_bonus", 0)
				score += node.get_meta(&"slice_bonus", 0)
				signals.score_updated.emit()
				node.owner.queue_free()
				sfx_slice.play()
				var inst : Line2D = SLICE.instantiate() as Line2D
				get_tree().current_scene.add_child(inst)
				inst.global_position = node.global_position
				inst.global_rotation = target.angle()
				ShakeCam.shake(3)
				Stats.enemies_parried += 1
		dmg_cast.target_position = -target
		dmg_cast.force_raycast_update()
		if dmg_cast.is_colliding():
			var coll = dmg_cast.get_collider()
			if coll is PlayerNode and coll != nodes[-1]: kill_node(coll, self)
		spawn_node()
		sfx_place.play()

func spawn_node() -> PlayerNode:
	var inst : PlayerNode = NODE.instantiate()
	get_tree().current_scene.add_child(inst)
	inst.global_position = global_position
	nodes.append(inst)
	fruit_cast.add_exception(inst)
	signals.node_spawned.emit(inst)

	for i in max(nodes.size() - hp, 0):
		nodes[i].kill()
		nodes.pop_front()

	return inst

static func kill_node(node: PlayerNode, by: Node2D) -> void:
	signals.harmed.emit()
	var idx = nodes.find(node)
	if (idx == -1 or idx == -2) and !player.parry_vuln_timer.is_stopped(): return
	for i in idx:
		nodes[0].ring_draw.draw_color = Color("#df4fcd")
		nodes[0].kill()
		nodes.pop_front()
		hp -= 1
		if randf() < Upgrade.data[&"repair_chance"]:
			var inst = FRUIT.instantiate()
			inst.add_to_group(&"no_spawn_fruit")
			inst.remove_from_group(&"player_fruit")
			player.get_tree().current_scene.add_child.call_deferred(inst)
			inst.global_position = nodes[0].global_position
		if hp == 1:
			nodes[-1].ring_draw.draw_color = Color("#df4fcd")
			nodes[-1].kill()
			nodes.clear()
	if hp <= 1:
		signals.died.emit(by)
		is_dead = true
	else:
		Stats.highest_loss = max(idx, Stats.highest_loss)
