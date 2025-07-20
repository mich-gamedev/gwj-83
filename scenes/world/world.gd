extends Node2D

@onready var fruit_rect := Rect2($FruitRect.global_position, $FruitRect.size)
@onready var border: ReferenceRect = $Border
const FRUIT = preload("res://objects/fruit/fruit.tscn")

func _ready() -> void:
	Player.signals.fruit_collected.connect(_fruit_collected)
	Player.signals.harmed.connect(_harmed)
	Player.signals.upgrades_ready.connect(_upgrade_ready)
	Player.signals.upgrades_finished.connect(_fruit_collected.bind(null), CONNECT_DEFERRED)
	_fruit_collected.call_deferred(null)

func _fruit_collected(fruit: Area2D) -> void:
	if !Player.can_spawn_enemies: return
	if fruit: await fruit.tree_exited
	var pears_to_spawn = max(Upgrade.data["pears"] - get_tree().get_nodes_in_group(&"player_fruit").size(), 0)
	for i in pears_to_spawn:
		var inst = FRUIT.instantiate()
		add_child(inst)
		inst.global_position = Vector2(randf_range(fruit_rect.position.x, fruit_rect.end.x), randf_range(fruit_rect.position.y, fruit_rect.end.y))

func _harmed() -> void:
	border.border_color = Color("#df4fcd")
	await get_tree().create_timer(0.25).timeout
	border.border_color = Color("#f6fbd9")

func _upgrade_ready() -> void:
	await get_tree().process_frame
	get_tree().call_group.call_deferred(&"enemy", &"_kill")
	get_tree().call_group(&"player_fruit", &"queue_free")
