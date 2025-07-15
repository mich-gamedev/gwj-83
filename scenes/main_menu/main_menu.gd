extends Control

@onready var anim: AnimationPlayer = $SlideLeft/AnimationPlayer

func _on_play_pressed() -> void:
	%ConfigPanel.hide()
	%CreditsPanel.hide()
	anim.play(&"play")
	await anim.animation_finished
	get_tree().change_scene_to_file("res://scenes/world/world.tscn")

func _on_config_pressed() -> void:
	anim.play(&"config")
	%ConfigPanel.show()
	%CreditsPanel.hide()

func _on_credits_pressed() -> void:
	anim.play(&"config")
	%ConfigPanel.hide()
	%CreditsPanel.show()

func _on_quit_pressed() -> void:
	get_tree().quit()

func _on_back_pressed() -> void:
	anim.play(&"close")
