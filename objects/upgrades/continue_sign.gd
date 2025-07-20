extends Area2D

@onready var anim_spawn: AnimationPlayer = $Spawn
@onready var anim_hover: AnimationPlayer = $ReferenceRect/Hover

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group(&"player_area"):
		anim_hover.play(&"open")

func _on_area_exited(area: Area2D) -> void:
	if area.is_in_group(&"player_area"):
		anim_hover.play_backwards(&"open")

func _on_purchase_pressed() -> void:
	Player.signals.upgrades_finished.emit()
	anim_hover.play(&"open", -1, -2, true)
	anim_spawn.play(&"spawn", -1, -2, true)
	await anim_spawn.animation_finished
	queue_free()
