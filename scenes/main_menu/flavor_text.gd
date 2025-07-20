extends Label

@export_multiline var strings: Array[String]

func _ready() -> void:
	text = strings.pick_random()
	visible_characters = 0
	while visible_ratio < 1:
		visible_characters += 1
		await get_tree().create_timer(0.02).timeout
