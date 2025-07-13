extends Node

@export_group("Action Names", "act_")
@export var act_left: StringName  = &"move_left"
@export var act_right: StringName = &"move_right"
@export var act_jump: StringName  = &"jump"

@export_group("Walking", "walk_")
@export var walk_speed: float
@export var
