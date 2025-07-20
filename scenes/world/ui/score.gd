extends RichTextLabel

func _ready() -> void:
	Player.signals.score_updated.connect(_score_updated)
	Player.signals.upgrades_finished.connect(_score_updated)

func _score_updated() -> void:

	text = "[shake][center]%03d/%03d" % [Player.score, Player.upgrade_amount]
	position.y -= 1
	await get_tree().create_timer(.15).timeout
	text = "[center]%03d/%03d" % [Player.score, Player.upgrade_amount]
	position.y += 1
