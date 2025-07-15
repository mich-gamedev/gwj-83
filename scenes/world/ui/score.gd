extends RichTextLabel

func _ready() -> void:
	Player.signals.score_updated.connect(_score_updated)

func _score_updated() -> void:
	show()
	text = "[shake][center]%03d/%03d" % [Player.score, 20]
	await get_tree().create_timer(.15).timeout
	text = "[center]%03d/%03d" % [Player.score, 20]
