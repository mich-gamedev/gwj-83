extends Control

@onready var death_anim: AnimationPlayer = %DeathAnim
@onready var death_message: RichTextLabel = %DeathMessage
@onready var stats: RichTextLabel = %Stats

var death_texts: Dictionary[String, String] = {
	"res://objects/enemies/basic/basic.tscn": "[b]look_at[/b] loves the smell of your head node, and will follow it anywhere. use this to your advantage by running into them to parry them.",
	"res://objects/enemies/bomb/bomb.tscn": "[b]get_normal[/b] is a ticking time bomb that bounces everywhere. try to stay out of it's path, if possible.",
	"res://objects/enemies/laser/bomb.tscn": "[b]queue_free[/b] fires her lasers quickly! you have to either parry her, or hide behind your tail.",
	"res://objects/player/player.tscn": "[b]_ready[/b]?? your tail isn't food! make sure to avoid nodes you've already planted."
}

func _ready() -> void:
	Player.signals.died.connect(_died)

func _died(to: Node2D) -> void:
	var file = to.scene_file_path if to.scene_file_path else to.owner.scene_file_path
	death_message.text = death_texts[file]
	death_anim.play(&"open")
	stats.text %= [Stats.enemies, Stats.longest_length, Stats.highest_loss, Stats.enemies_parried, Stats.upgrades_collected]
	await death_anim.animation_finished
	get_tree().paused = true

func _on_retry_pressed() -> void:
	death_anim.play(&"retry")
	await death_anim.animation_finished
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/main_menu/main_menu.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()
