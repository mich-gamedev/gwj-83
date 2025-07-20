extends Control

@onready var anim: AnimationPlayer = $AnimationPlayer

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(&"pause"):
		if get_tree().paused:
			_on_resume_pressed()
		else:
			anim.play(&"open")
			get_tree().paused = true


func _on_resume_pressed() -> void:
	anim.play(&"close")
	await anim.animation_finished
	get_tree().paused = false

func _on_quit_pressed() -> void:
	get_tree().quit()

func _on_main_menu_pressed() -> void:
	anim.play(&"retry")
	await anim.animation_finished
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/main_menu/main_menu.tscn")
