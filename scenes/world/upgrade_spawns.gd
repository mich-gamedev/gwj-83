extends Node2D

const UPGRADE_BUBBLE := preload("res://objects/upgrades/upgrade_bubble.tscn")
const CONTINUE_SIGN = preload("res://objects/upgrades/continue_sign.tscn")
const PATH := "res://resources/upgrades/res/"

var list := ResourceLoader.list_directory(PATH)

@onready var sign_spawner: Node2D = $"../SignSpawner"

func _ready() -> void:
	Player.signals.upgrades_ready.connect(_start_upgrades)
	Player.signals.upgrades_finished.connect(_upgrades_finished)

func _start_upgrades() -> void:
	if !Player.can_spawn_enemies: return
	for i in get_children():
		var inst = UPGRADE_BUBBLE.instantiate()
		inst.upgrade = load(PATH + list[randi_range(0, list.size() - 1)])
		get_tree().current_scene.add_child(inst)
		inst.global_position = i.global_position
		await get_tree().create_timer(0.05).timeout
	await get_tree().create_timer(0.05).timeout
	var sign = CONTINUE_SIGN.instantiate()
	get_tree().current_scene.add_child(sign)
	sign.global_position = sign_spawner.global_position

func _upgrades_finished() -> void:
	get_tree().call_group(&"upgrade", &"_exit")
	Player.upgrade_amount = int(float(Player.upgrade_amount) * (randf_range(1.75, 2.5) * Upgrade.data[&"upgrade_speed"]))
	Player.can_spawn_enemies = true
