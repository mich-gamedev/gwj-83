extends CharacterBody2D

@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var sprite: RingDraw = $RingDraw

func _physics_process(delta: float) -> void:
	sprite.scale.y = remap(velocity.x, 0, 128, 1, .8)
	sprite.scale.x = remap(velocity.x, 0, 128, 1, 1.2)
	sprite.global_rotation = velocity.angle()

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area is PlayerNode and area != Player.nodes[-1]:
		Player.kill_node(area as PlayerNode)
		anim.play(&"kill")
		velocity = Vector2()
		await anim.animation_finished
		queue_free()

func _on_animation_player_2_animation_finished(anim_name: StringName) -> void:
	queue_free()
