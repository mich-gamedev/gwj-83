extends Node2D

@onready var fruit_rect := Rect2($FruitRect.global_position, $FruitRect.size)
@onready var border: ReferenceRect = $Border
const FRUIT = preload("res://objects/fruit/fruit.tscn")

func _ready() -> void:
	Player.signals.fruit_collected.connect(_fruit_collected)
	Player.signals.harmed.connect(_harmed)
	_fruit_collected.call_deferred(null)

func _fruit_collected(_fruit: Area2D) -> void:
	var inst = FRUIT.instantiate()
	add_child(inst)
	inst.global_position = Vector2(randf_range(fruit_rect.position.x, fruit_rect.end.x), randf_range(fruit_rect.position.y, fruit_rect.end.y))

func _harmed() -> void:
	border.border_color = Color("#df4fcd")
	await get_tree().create_timer(0.25).timeout
	border.border_color = Color("#f6fbd9")
