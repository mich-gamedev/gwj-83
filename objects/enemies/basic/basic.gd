extends CharacterBody2D

@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var sprite: RingDraw = $RingDraw

func _physics_process(_delta: float) -> void:
	sprite.scale.y = remap(velocity.x, 0, 128, 1, .8)
	sprite.scale.x = remap(velocity.x, 0, 128, 1, 1.2)
	sprite.global_rotation = velocity.angle()

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area is PlayerNode:
		Player.kill_node(area as PlayerNode, self)
		_kill()

func _on_animation_player_2_animation_finished(_anim_name: StringName) -> void:
	queue_free()

func _kill() -> void:
		anim.play(&"kill")
		velocity = Vector2()
		await anim.animation_finished
		queue_free()
