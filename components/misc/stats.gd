class_name Stats extends Node

static var died_to: String
static var enemies: int
static var longest_length: int
static var highest_loss: int
static var enemies_parried: int
static var upgrades_collected: int

static func reset() -> void:
	enemies = 0
	longest_length = 0
	highest_loss = 0
	enemies_parried = 0
	upgrades_collected = 0
