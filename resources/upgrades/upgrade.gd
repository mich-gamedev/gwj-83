class_name Upgrade extends Resource

static var data: Dictionary[StringName, Variant]
static var purchased_upgrades: Array[Upgrade]

static func reset() -> void:
	(load("res://resources/upgrades/default_stats.tres") as Upgrade).run_upgrade()
	purchased_upgrades.clear()

@export_group("Display")
@export var icon: String
@export var title: String
@export_multiline var desc: String
@export_multiline var desc_post_purchase: String
@export_group("Logic")
@export var stats: Dictionary[StringName, String]
@export var price: Curve

func run_upgrade() -> void:
	if Engine.is_editor_hint(): return
	purchased_upgrades.append(self)
	if get_price(): Player.kill_node(Player.nodes[get_price()], null)

	for i in stats:
		var value
		if String(stats[i]).substr(1).is_valid_int():
			value = String(stats[i]).substr(1).to_int()
		elif String(stats[i]).substr(1).is_valid_float():
			value = String(stats[i]).substr(1).to_float()
		match String(stats[i])[0]:
			"+":
				Upgrade.data[i] += value
			"-":
				Upgrade.data[i] -= value
			"=":
				Upgrade.data[i] = value
			"*":
				Upgrade.data[i] *= value
			"/":
				Upgrade.data[i] /= value
			"^":
				Upgrade.data[i] **= value
			_:
				push_error("%s's stats value \"%s\" does not begin with a valid operator. Continuing" % [resource_path, i])

func get_price() -> int:
	return int(price.sample_baked(Player.score)) if price else 0
