extends Area2D

var upgrade: Upgrade

@onready var title_desc: RichTextLabel = %TitleDesc
@onready var label_white: Label = $ReferenceRect/ColorRect/MarginContainer/VBoxContainer/Purchase/Label
@onready var label_black: Label = $ReferenceRect/ColorRect/MarginContainer/VBoxContainer/Purchase/Label/ColorRect/Label
@onready var anim_hover: AnimationPlayer = $ReferenceRect/Hover
@onready var anim_spawn: AnimationPlayer = $Spawn
@onready var icons: Node2D = %Icons

func _ready() -> void:
	for i in icons.get_children():
		i.hide()
	icons.get_node(upgrade.icon).show()
	title_desc.text %= [upgrade.title, upgrade.desc if !upgrade in Upgrade.purchased_upgrades else upgrade.desc_post_purchase]
	label_white.text %= upgrade.get_price()
	label_black.text = label_white.text

func _on_area_entered(area: Area2D) -> void:
	#print("AREA ENTERED UPGRADE")
	if area.is_in_group(&"player_area"):
		print("PLAYER ENTERED UPGRADE")
		anim_hover.play(&"open")

func _on_area_exited(area: Area2D) -> void:
	if area.is_in_group(&"player_area"):
		anim_hover.play_backwards(&"open")

func _on_purchase_pressed() -> void:
	if upgrade:
		upgrade.run_upgrade()
		Stats.upgrades_collected += 1
		anim_hover.play(&"open", -1, -2, true)
		anim_spawn.play(&"spawn", -1, -2, true)
		upgrade = null
		await anim_spawn.animation_finished
		queue_free()

func _exit() -> void:
		anim_hover.play(&"open", -1, -2, true)
		anim_spawn.play(&"spawn", -1, -2, true)
		upgrade = null
		await anim_spawn.animation_finished
		queue_free()
