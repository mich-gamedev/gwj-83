extends CharacterBody2D

@onready var anim: AnimationPlayer = $AnimationPlayer

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area is PlayerNode:
		Player.kill_node(area)
		anim.play(&"kill")
		velocity = Vector2()
		await anim.animation_finished
		queue_free()
