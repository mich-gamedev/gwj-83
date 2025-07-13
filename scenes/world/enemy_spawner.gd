extends Node2D

var spawnrates: Array[EnemySpawnrate]

func _ready() -> void:
	for i in ResourceLoader.list_directory("res://resources/enemy_spawnrates/"):
		var resource = load(i)
		if resource is EnemySpawnrate:
			spawnrates.append(resource)

func spawn_rand() -> void:
	pass
